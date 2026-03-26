import { ExtractedEntities, IntentClassifier, UserIntent } from '../intelligence/IntentClassifier.js';
import { ResponseBuilder, analyzeQueryAmbiguity, detectMissingPlatform } from '../utils/ResponseBuilder.js';
import { SmartAssistContext } from './SmartAssistContext.js';
import { SmartAssistResponse } from './SmartAssistResponse.js';
import { DocSearch } from '../search/DocSearch.js';
import { KnowledgeRegistry } from '../intelligence/KnowledgeRegistry.js';
import { PlatformOrchestrator } from '../intelligence/PlatformOrchestrator.js';
import { TemplateRegistry } from '../intelligence/TemplateRegistry.js';
import { ConfigSearch } from '../search/ConfigSearch.js';
import { KnowledgeGraph } from '../intelligence/KnowledgeGraph.js';
import { ShardedSourceSearch } from '../search/ShardedSourceSearch.js';
import { SimilarityMatcher, Vectorizable } from '../intelligence/SimilarityMatcher.js';
import { SmartAssistLogger } from '../utils/SmartAssistLogger.js';
import { PlatformCapabilityRegistry, PlatformRoute } from '../intelligence/PlatformCapabilityRegistry.js';
import { inspectMcpResult } from '../utils/LogResponseInspector.js';
import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';
import { execFile } from 'child_process';
import { promisify } from 'util';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const execFileAsync = promisify(execFile);

export class SmartAssistService {
  private readonly platformCapabilityRegistry = new PlatformCapabilityRegistry();
  private platformCoverageCache: {
    docsProductsByPlatform: Record<string, Set<string>>;
    sourceComponentsByPlatform: Record<string, Set<string>>;
  } | null = null;

  constructor(
    private readonly intentClassifier: IntentClassifier,
    private readonly context: SmartAssistContext,
    private readonly responses: SmartAssistResponse,
    private readonly docSearch: DocSearch,
    private readonly knowledgeRegistry: KnowledgeRegistry,
    private readonly templateRegistry: TemplateRegistry,
    private readonly platformOrchestrator: PlatformOrchestrator,
    private readonly configSearch: ConfigSearch,
    private readonly knowledgeGraph: KnowledgeGraph,
    private readonly sourceSearch: ShardedSourceSearch
  ) {}

  async handle(args: any) {
    const { query, session_id, platform } = args;

    const startTime = Date.now();
    const requestId = SmartAssistLogger.newRequestId();
    const sessionId = session_id || 'default';
    const rawQuery = typeof query === 'string' ? query : String(query ?? '');
    const toEntityLog = (value: ExtractedEntities): Record<string, string | number | null> => ({
      ...value
    });

    const logAndReturn = (entry: Omit<Parameters<typeof SmartAssistLogger.log>[0], 'log_version' | 'timestamp' | 'request_id' | 'session_id' | 'raw_query' | 'timing_ms'>, result: any) => {
      const inspection = inspectMcpResult(result);
      SmartAssistLogger.log({
        log_version: 'v1',
        timestamp: new Date().toISOString(),
        request_id: requestId,
        session_id: sessionId,
        raw_query: rawQuery,
        timing_ms: {
          total: Date.now() - startTime
        },
        ...entry,
        response: {
          ...entry.response,
          category: inspection.category,
          has_no_result_cue: inspection.hasNoResultCue,
          has_clarification_cue: inspection.hasClarificationCue,
          direct_no_result: inspection.directNoResult,
          evidence_count: inspection.evidenceCount,
          preview: inspection.preview
        }
      });
      return result;
    };

    if (typeof query !== 'string' || !query.trim()) {
      SmartAssistLogger.log({
        log_version: 'v1',
        timestamp: new Date().toISOString(),
        request_id: requestId,
        session_id: sessionId,
        raw_query: rawQuery,
        route: { name: 'invalid_query', reason: 'empty_query' },
        response: { type: 'error' },
        timing_ms: {
          total: Date.now() - startTime
        },
        error: { message: 'query 参数必须是非空字符串' }
      });
      throw new Error('query 参数必须是非空字符串');
    }

    const ambiguityAnalysis = analyzeQueryAmbiguity(query);
    if (ambiguityAnalysis.isAmbiguous) {
      return logAndReturn(
        {
          platform: { provided: platform ?? null },
          ambiguity: {
            is_ambiguous: true,
            type: ambiguityAnalysis.ambiguityType
          },
          route: { name: 'ambiguous', reason: ambiguityAnalysis.ambiguityType },
          response: { type: 'clarification' }
        },
        this.responses.buildAmbiguousQueryResponse(query, ambiguityAnalysis)
      );
    }

    const continuity = this.context.detectContinuity(query, sessionId);
    const contextSummary = this.context.getContextSummary(sessionId);
    const { enhancedQuery } = this.context.enhanceQuery(query, sessionId);

    const platformCheck = detectMissingPlatform(query, platform);
    if (platformCheck.needsPlatform && platformCheck.isImplementationQuery) {
      const missingPlatformResult = this.intentClassifier.classify(enhancedQuery);
      return logAndReturn(
        {
          enhanced_query: enhancedQuery,
          platform: { provided: platform ?? null, detected: platformCheck.detectedPlatform ?? null },
          continuity: { is_continuation: continuity.isContinuation, type: continuity.type },
          intent: {
            name: missingPlatformResult.intent,
            confidence: missingPlatformResult.confidence,
            sub_intent: missingPlatformResult.subIntent
          },
          entities: toEntityLog(missingPlatformResult.entities),
          route: { name: 'missing_platform', reason: platformCheck.featureName },
          response: { type: 'clarification' }
        },
        this.responses.buildPlatformSelectionResponse(query, platformCheck.featureName, missingPlatformResult)
      );
    }

    const effectivePlatform = platformCheck.detectedPlatform || platform;
    const intentResult = this.intentClassifier.classify(enhancedQuery, effectivePlatform);
    const { intent, confidence, entities } = intentResult;
    const platformForAnswer = effectivePlatform || platformCheck.detectedPlatform || platform || 'ios';
    const normalizedPlatform = platformForAnswer === 'react-native' ? 'rn' : platformForAnswer;

    const platformConstraint = this.buildKnownPlatformConstraintResponse(
      query,
      normalizedPlatform,
      entities.componentName
    );
    if (platformConstraint) {
      return logAndReturn(
        {
          enhanced_query: enhancedQuery,
          platform: {
            provided: platform ?? null,
            detected: platformCheck.detectedPlatform ?? null,
            effective: effectivePlatform ?? platformForAnswer
          },
          continuity: { is_continuation: continuity.isContinuation, type: continuity.type },
          intent: {
            name: intent,
            confidence,
            sub_intent: intentResult.subIntent
          },
          entities: toEntityLog(entities),
          route: { name: 'platform_constraint', reason: platformConstraint.reason },
          response: { type: 'answer' }
        },
        {
          content: [
            {
              type: 'text',
              text: platformConstraint.text
            }
          ]
        }
      );
    }

    const templateMatch = this.matchTemplateIntent(enhancedQuery, normalizedPlatform);
    if (templateMatch) {
      return logAndReturn(
        {
          enhanced_query: enhancedQuery,
          platform: {
            provided: platform ?? null,
            detected: platformCheck.detectedPlatform ?? null,
            effective: effectivePlatform ?? platformForAnswer
          },
          continuity: { is_continuation: continuity.isContinuation, type: continuity.type },
          intent: {
            name: intent,
            confidence,
            sub_intent: intentResult.subIntent
          },
          entities: toEntityLog(entities),
          template_match: {
            template_name: templateMatch.templateName,
            score: templateMatch.score
          },
          route: { name: 'template_match', reason: templateMatch.templateName },
          response: { type: 'answer' }
        },
        this.buildTemplateMatchResponse(templateMatch, normalizedPlatform)
      );
    }

    this.context.recordSearch(query, intentResult, sessionId);

    if (confidence < 50 && intent === UserIntent.UNKNOWN) {
      const possibleIntents = this.getPossibleIntents(query);
      return logAndReturn(
        {
          enhanced_query: enhancedQuery,
          platform: {
            provided: platform ?? null,
            detected: platformCheck.detectedPlatform ?? null,
            effective: effectivePlatform ?? platformForAnswer
          },
          continuity: { is_continuation: continuity.isContinuation, type: continuity.type },
          intent: {
            name: intent,
            confidence,
            sub_intent: intentResult.subIntent
          },
          entities: toEntityLog(entities),
          route: { name: 'low_confidence' },
          response: { type: 'clarification' }
        },
        this.responses.buildLowConfidenceResponse(query, intentResult, possibleIntents)
      );
    }

    const builder = ResponseBuilder.create();

    builder.addTitle('🧠 智能助手分析');
    builder.addParagraph(`**您的问题**: ${query}`);

    if (continuity.isContinuation && continuity.suggestedContext) {
      builder.addParagraph(`> 📎 **上下文**: ${continuity.suggestedContext}`);
    }

    builder.addParagraph(`**识别意图**: ${this.intentClassifier.getIntentDescription(intent)} (置信度: ${confidence.toFixed(0)}%)`);

    const extractedEntities: string[] = [];
    if (entities.errorCode) extractedEntities.push(`错误码: ${entities.errorCode}`);
    if (entities.componentName) extractedEntities.push(`组件: ${entities.componentName}`);
    if (entities.featureName) extractedEntities.push(`功能: ${entities.featureName}`);
    if (entities.className) extractedEntities.push(`类: ${entities.className}`);
    if (entities.messageName) extractedEntities.push(`消息类型: ${entities.messageName}`);
    if (entities.configProperty) extractedEntities.push(`配置项: ${entities.configProperty}`);

    if (extractedEntities.length > 0) {
      builder.addParagraph(`**提取的关键信息**: ${extractedEntities.join(' | ')}`);
    }

    builder.addDivider();

    let resultText = builder.build().content[0].text;

    switch (intent) {
      case UserIntent.FIX_ERROR:
        if (entities.errorCode) {
          resultText += await this.getErrorSolution(entities.errorCode, normalizedPlatform);
        } else {
          resultText += `## 💡 建议\n\n`;
          resultText += `检测到您在询问错误相关问题，但未提取到具体错误码。\n\n`;
          resultText += `请提供具体的错误码数字，例如：\n`;
          resultText += `- "错误码 508 怎么解决"\n`;
          resultText += `- "error code 200 是什么意思"\n\n`;
          resultText += `或者使用 \`diagnose\` 工具描述症状：\n`;
          resultText += `- "消息发送失败"\n`;
          resultText += `- "登录超时"\n`;
        }
        break;

      case UserIntent.CUSTOMIZE_MESSAGE:
        resultText += await this.getCustomMessageSolution(entities.messageName || 'Custom', normalizedPlatform);
        break;

      case UserIntent.ADD_MENU_ITEM:
        resultText += await this.getAddMenuSolution(normalizedPlatform);
        break;

      case UserIntent.CUSTOMIZE_UI:
      case UserIntent.CONFIGURE_APPEARANCE:
        resultText += await this.getUiCustomizationSolution(
          entities.configProperty,
          intentResult.subIntent,
          normalizedPlatform,
          entities.componentName,
          query
        );
        break;

      case UserIntent.UNDERSTAND_CLASS:
        if (entities.className) {
          resultText += await this.explainClass(entities.className, normalizedPlatform);
        } else {
          resultText += `## 💡 建议\n\n`;
          resultText += `请提供具体的类名，例如：\n`;
          resultText += `- "MessageCell 是什么"\n`;
          resultText += `- "CustomMessageCell 怎么用"\n`;
          resultText += `- "ComponentsRegister 的作用"\n`;
        }
        break;

      case UserIntent.INTEGRATE_SDK:
        resultText += `## 📚 SDK 集成指南\n\n`;
        resultText += `建议使用 \`get_guide\` 工具获取详细的集成指南：\n\n`;
        resultText += `\`\`\`\nget_guide topic="quickstart"\n\`\`\`\n\n`;
        resultText += `### 快速集成步骤\n\n`;
        resultText += `1. **CocoaPods 安装**\n`;
        resultText += `   \`\`\`ruby\n   pod 'EaseChatUIKit'\n   \`\`\`\n\n`;
        resultText += `2. **初始化 SDK**\n`;
        resultText += `   \`\`\`swift\n   import EaseChatUIKit\n   \n   // 在 AppDelegate 中初始化\n   let options = ChatOptions(appkey: "您的AppKey")\n   ChatUIKitClient.shared.setup(option: options)\n   \`\`\`\n\n`;
        resultText += `3. **登录**\n`;
        resultText += `   \`\`\`swift\n   ChatUIKitClient.shared.login(user: userId, token: token) { error in\n       if let error = error {\n           print("登录失败: \\(error.errorDescription)")\n       } else {\n           print("登录成功")\n       }\n   }\n   \`\`\`\n`;
        break;

      case UserIntent.IMPLEMENT_FEATURE:
        resultText += `## 📋 功能实现建议\n\n`;
        if (entities.featureName) {
          resultText += `您想实现的功能: **${entities.featureName}**\n\n`;
          resultText += `使用 \`search_api\` 工具搜索相关 API：\n`;
          resultText += `\`\`\`\nsearch_api query="${entities.featureName}"\n\`\`\`\n\n`;
        }
        resultText += `或者使用 \`list_scenarios\` 查看所有支持的场景。\n`;
        break;

      default:
        resultText += `## 💡 建议\n\n`;
        resultText += `我未能准确理解您的意图。您可以尝试：\n\n`;
        resultText += `1. **查看可用场景**: \`list_scenarios\`\n`;
        resultText += `2. **搜索 API**: \`search_api query="关键词"\`\n`;
        resultText += `3. **搜索源码**: \`search_source query="关键词"\`\n`;
        resultText += `4. **查询错误码**: \`lookup_error code=508\`\n`;
        resultText += `5. **获取指南**: \`get_guide topic="quickstart"\`\n\n`;
        resultText += `或者用更具体的语言描述您的需求：\n`;
        resultText += `- "我想自定义一个订单消息"\n`;
        resultText += `- "如何添加发送位置的菜单"\n`;
        resultText += `- "错误码 508 怎么解决"\n`;
    }

    const recommendations = this.context.getRecommendations(sessionId, 3);
    if (recommendations.length > 0) {
      resultText += `\n---\n\n## 📌 您可能还想了解\n\n`;
      for (const rec of recommendations) {
        const icon = rec.type === 'class' ? '🔷' : rec.type === 'api' ? '📗' : rec.type === 'guide' ? '📖' : '💡';
        resultText += `- ${icon} **${rec.title}**: ${rec.description}\n`;
      }
    }

    if (contextSummary.recentQueries.length > 1) {
      resultText += `\n---\n\n<details>\n<summary>📋 会话上下文</summary>\n\n`;
      resultText += `- 当前话题: ${contextSummary.currentTopic || '未确定'}\n`;
      resultText += `- 会话时长: ${contextSummary.sessionDuration} 分钟\n`;
      resultText += `- 最近查询: ${contextSummary.recentQueries.slice(-3).join(' → ')}\n`;
      resultText += `</details>\n`;
    }

    return logAndReturn(
      {
        enhanced_query: enhancedQuery,
        platform: {
          provided: platform ?? null,
          detected: platformCheck.detectedPlatform ?? null,
          effective: effectivePlatform ?? platformForAnswer
        },
        continuity: { is_continuation: continuity.isContinuation, type: continuity.type },
        intent: {
          name: intent,
          confidence,
          sub_intent: intentResult.subIntent
        },
        entities: toEntityLog(entities),
        route: { name: `intent:${intent}` },
        response: { type: 'answer' }
      },
      {
        content: [
          {
            type: 'text',
            text: resultText
          }
        ]
      }
    );
  }

  private matchTemplateIntent(query: string, platform: string) {
    const templateItems = this.templateRegistry.load(platform);

    if (templateItems.length === 0) {
      return null;
    }

    const candidates: Vectorizable[] = templateItems.map((template) => ({
      id: template.id,
      text: `${template.name} ${template.description || ''} ${template.domain}`.trim()
    }));

    const matcher = new SimilarityMatcher();
    matcher.trainIDF(candidates.map(c => c.text));

    const match = matcher.findBestMatchWithTFIDF(query, candidates, 0.45);
    if (!match) return null;

    const templateName = match.target.id.split(':').slice(2).join(':');
    if (!templateName) {
      return null;
    }

    return {
      templateName,
      scenarioName: match.target.text,
      score: match.score
    };
  }

  private buildTemplateMatchResponse(
    match: { templateName: string; scenarioName: string; score: number },
    platform: string
  ) {
    const builder = ResponseBuilder.create();
    builder.addTitle('模板匹配');
    builder.addParagraph(`已根据您的描述匹配到模板：${match.scenarioName}`);
    builder.addParagraph(`匹配度: ${(match.score * 100).toFixed(0)}%`);

    const generated = this.platformOrchestrator.generateCode(match.templateName, platform, {
      platform,
      name: 'Custom'
    });

    if (!generated) {
      builder.addParagraph('未能生成模板代码，请检查平台或模板配置。');
      return builder.build();
    }

    builder.addParagraph('代码生成结果：');
    builder.addText(`\`\`\`swift\n${generated.code}\n\`\`\``);
    if (generated.usage) {
      builder.addParagraph(`集成步骤:\n${generated.usage}`);
    }

    return builder.build();
  }

  private normalizeCoveragePlatform(platform: string): string {
    const normalized = platform.toLowerCase();
    if (normalized === 'react-native' || normalized === 'reactnative') return 'rn';
    if (normalized === 'harmonyos' || normalized === 'ohos') return 'harmony';
    return normalized;
  }

  private detectComponentHint(query: string, componentName?: string | null): 'callkit' | 'chatroomuikit' | 'chatuikit' | null {
    const normalizedComponent = (componentName || '').toLowerCase();
    if (normalizedComponent.includes('call')) return 'callkit';
    if (normalizedComponent.includes('chatroom')) return 'chatroomuikit';
    if (normalizedComponent.includes('chat')) return 'chatuikit';

    const lowerQuery = query.toLowerCase();
    if (/callkit|calluikit|easecalluikit|通话|音视频/.test(lowerQuery)) return 'callkit';
    if (/chatroomuikit|chatroom|聊天室/.test(lowerQuery)) return 'chatroomuikit';
    if (/chatuikit|easechatuikit|消息界面|会话界面/.test(lowerQuery)) return 'chatuikit';
    return null;
  }

  private loadPlatformCoverage() {
    if (this.platformCoverageCache) return this.platformCoverageCache;

    const docsProductsByPlatform: Record<string, Set<string>> = {};
    const sourceComponentsByPlatform: Record<string, Set<string>> = {};

    const projectRoot = path.join(__dirname, '../..');
    const docsIndexPath = path.join(projectRoot, 'data/docs/index.json');
    if (fs.existsSync(docsIndexPath)) {
      const docsIndex = JSON.parse(fs.readFileSync(docsIndexPath, 'utf-8')) as {
        apiModules?: Array<{ platform?: string; product?: string }>;
        guides?: Array<{ platform?: string; product?: string }>;
      };
      for (const item of [...(docsIndex.apiModules || []), ...(docsIndex.guides || [])]) {
        const platform = this.normalizeCoveragePlatform(String(item.platform || 'unknown'));
        const product = String(item.product || 'general');
        if (!docsProductsByPlatform[platform]) docsProductsByPlatform[platform] = new Set<string>();
        docsProductsByPlatform[platform].add(product);
      }
    }

    const sourcesIndexPath = path.join(projectRoot, 'data/sources/index.json');
    if (fs.existsSync(sourcesIndexPath)) {
      const sourcesIndex = JSON.parse(fs.readFileSync(sourcesIndexPath, 'utf-8')) as {
        files?: Array<{ platform?: string; component?: string }>;
      };
      for (const file of sourcesIndex.files || []) {
        const platform = this.normalizeCoveragePlatform(String(file.platform || 'unknown'));
        const component = String(file.component || '');
        if (!sourceComponentsByPlatform[platform]) sourceComponentsByPlatform[platform] = new Set<string>();
        if (component) sourceComponentsByPlatform[platform].add(component);
      }
    }

    this.platformCoverageCache = { docsProductsByPlatform, sourceComponentsByPlatform };
    return this.platformCoverageCache;
  }

  private buildKnownPlatformConstraintResponse(
    query: string,
    platform: string,
    componentName?: string | null
  ): { reason: string; text: string } | null {
    const normalizedPlatform = this.normalizeCoveragePlatform(platform);
    const componentHint = this.detectComponentHint(query, componentName);
    if (!componentHint) return null;

    const lowerQuery = query.toLowerCase();
    const asksDemoOrSource = /demo|sample|源码|示例|例子|source/.test(lowerQuery);
    const coverage = this.loadPlatformCoverage();
    const docsProducts = Array.from(coverage.docsProductsByPlatform[normalizedPlatform] || []);
    const sourceComponents = Array.from(coverage.sourceComponentsByPlatform[normalizedPlatform] || []);

    const productHasCallkit = docsProducts.includes('callkit');
    const sourceHasCallkit = sourceComponents.includes('EaseCallUIKit');
    const sourceHasChatroomUIKit = sourceComponents.includes('EaseChatroomUIKit');
    const sourceHasChatUIKit = sourceComponents.includes('EaseChatUIKit');

    if (componentHint === 'callkit' && (normalizedPlatform === 'flutter' || normalizedPlatform === 'harmony')) {
      const text = `## ⚠️ 当前平台暂无 CallKit 可用内容\n\n`
        + `您询问的是 CallKit/通话能力，但当前索引中该平台无对应 CallKit 文档与源码。\n\n`
        + `### 证据\n\n`
        + `- docs 产品覆盖（${normalizedPlatform}）: ${docsProducts.join(', ') || '无'}\n`
        + `- sources 组件覆盖（${normalizedPlatform}）: ${sourceComponents.join(', ') || '无'}\n`
        + `- CallKit docs 命中: ${productHasCallkit ? '有' : '无'}\n`
        + `- CallKit source 命中: ${sourceHasCallkit ? '有' : '无'}\n\n`
        + `### 建议\n\n`
        + `1. 若需要通话能力，请切换到 iOS/Android/Web/RN 路线查询。\n`
        + `2. 若当前仅做 ${normalizedPlatform}，建议先聚焦 ChatUIKit/SDK 可用能力。\n`;
      return { reason: 'callkit_unavailable_on_platform', text };
    }

    if (normalizedPlatform === 'flutter' && componentHint === 'chatroomuikit') {
      const text = `## ℹ️ Flutter 平台 ChatroomUIKit 能力并入 ChatUIKit\n\n`
        + `您询问了 ChatroomUIKit。在 Flutter 索引中，聊天室相关能力已并入 \`EaseChatUIKit\` 组件，而非单独的 \`EaseChatroomUIKit\` 组件。\n\n`
        + `### 证据\n\n`
        + `- docs 产品覆盖（flutter）: ${docsProducts.join(', ') || '无'}\n`
        + `- sources 组件覆盖（flutter）: ${sourceComponents.join(', ') || '无'}\n`
        + `- EaseChatroomUIKit source 命中: ${sourceHasChatroomUIKit ? '有' : '无'}\n`
        + `- EaseChatUIKit source 命中: ${sourceHasChatUIKit ? '有' : '无'}\n\n`
        + `### 建议\n\n`
        + `1. 使用 \`search_source query="chatroom" component="EaseChatUIKit" platform="flutter"\`。\n`
        + `2. 优先查看 Flutter ChatUIKit 文档中的聊天室章节。\n`;
      return { reason: asksDemoOrSource ? 'flutter_chatroom_merged_no_separate_demo' : 'flutter_chatroom_merged', text };
    }

    if (normalizedPlatform === 'harmony' && componentHint === 'chatroomuikit' && asksDemoOrSource) {
      const text = `## ⚠️ HarmonyOS ChatroomUIKit 暂无独立 Demo 源码\n\n`
        + `当前鸿蒙索引仅包含 SDK 文档与 ChatUIKit 源码，未发现 ChatroomUIKit 独立 Demo 源码。\n\n`
        + `### 证据\n\n`
        + `- docs 产品覆盖（harmony）: ${docsProducts.join(', ') || '无'}\n`
        + `- sources 组件覆盖（harmony）: ${sourceComponents.join(', ') || '无'}\n`
        + `- EaseChatroomUIKit source 命中: ${sourceHasChatroomUIKit ? '有' : '无'}\n\n`
        + `### 建议\n\n`
        + `1. 先参考鸿蒙 SDK 文档 + ChatUIKit 源码实现等价功能。\n`
        + `2. 使用 \`search_source query="chatroom|room" component="EaseChatUIKit" platform="harmony"\` 定位可复用实现。\n`;
      return { reason: 'harmony_chatroom_demo_missing', text };
    }

    return null;
  }

  private getPossibleIntents(query: string): Array<{ intent: string; label: string; description: string }> {
    const intents = [
      { intent: 'customize_ui', label: '定制 UI 样式', description: '修改颜色、字体、布局等界面元素' },
      { intent: 'custom_message', label: '自定义消息类型', description: '创建订单、卡片等自定义消息' },
      { intent: 'fix_error', label: '解决错误/问题', description: '查询错误码、诊断问题' },
      { intent: 'integrate_sdk', label: 'SDK 集成配置', description: '安装、初始化、配置 SDK' },
      { intent: 'understand_api', label: '了解 API 用法', description: '查看接口文档和使用方法' }
    ];

    const lowerQuery = query.toLowerCase();
    if (lowerQuery.includes('颜色') || lowerQuery.includes('样式') || lowerQuery.includes('ui')) {
      const uiIntent = intents.find(i => i.intent === 'customize_ui');
      if (uiIntent) {
        intents.splice(intents.indexOf(uiIntent), 1);
        intents.unshift(uiIntent);
      }
    }
    if (lowerQuery.includes('错误') || lowerQuery.includes('失败') || lowerQuery.includes('error')) {
      const errorIntent = intents.find(i => i.intent === 'fix_error');
      if (errorIntent) {
        intents.splice(intents.indexOf(errorIntent), 1);
        intents.unshift(errorIntent);
      }
    }
    if (lowerQuery.includes('消息') || lowerQuery.includes('message')) {
      const msgIntent = intents.find(i => i.intent === 'custom_message');
      if (msgIntent) {
        intents.splice(intents.indexOf(msgIntent), 1);
        intents.unshift(msgIntent);
      }
    }

    return intents.slice(0, 4);
  }

  private async getErrorSolution(errorCode: number, platform?: string): Promise<string> {
    const error = this.docSearch.lookupError(errorCode);

    if (!error) {
      return `## ❌ 未找到错误码 ${errorCode}\n\n该错误码可能不在已记录的范围内。建议查看环信官方文档。\n`;
    }

    return `## 🔧 错误码 ${errorCode} 解决方案

**错误名称**: ${error.name}
**所属模块**: ${error.module}
**描述**: ${error.brief}

### 可能原因

${error.causes.map((c: any, i: number) => `${i + 1}. ${c}`).join('\n')}

### 解决方案

${error.solutions.map((s: any, i: number) => `${i + 1}. ${s}`).join('\n')}

### 代码示例

\`\`\`swift
// 错误处理示例
EMClient.shared().chatManager?.send(message) { msg, error in
    if let error = error {
        switch error.code {
        case ${errorCode}:
            // ${error.brief}
            print("错误: ${error.name}")
            // 处理方式: ${error.solutions[0] || '参见解决方案'}
        default:
            print("其他错误: \\(error.errorDescription)")
        }
    }
}
\`\`\`
`;
  }

  private async getCustomMessageSolution(messageName: string, platform?: string): Promise<string> {
    const normalizedPlatform = platform === 'react-native' ? 'rn' : platform;
    const scenario = this.knowledgeRegistry.getScenario('custom_message', normalizedPlatform)
      || this.knowledgeRegistry.getScenario('common:custom_message')
      || this.knowledgeRegistry.getScenario('ios:custom_message')
      || this.knowledgeRegistry.getScenario('custom_message');

    let resultText = `## 📝 自定义 ${messageName} 消息实现方案\n\n`;

    if (scenario) {
      resultText += `### 实现步骤\n\n`;
      scenario.steps.forEach((step, i) => {
        resultText += `${i + 1}. ${step}\n`;
      });
      resultText += '\n';
    }

    const generated = this.platformOrchestrator.generateCode('custom_message_full', normalizedPlatform || 'ios', {
      platform: normalizedPlatform || 'ios',
      name: messageName,
      variables: {
        messageName,
        cellHeight: 120
      }
    });

    if (generated) {
      resultText += `### 完整代码\n\n`;
      resultText += `\`\`\`swift\n${generated.code}\n\`\`\`\n\n`;
      if (generated.usage) {
        resultText += `**集成步骤**:\n${generated.usage}\n\n`;
      }
    }

    resultText += `### 关键类说明\n\n`;
    resultText += `| 类名 | 作用 | 源文件 |\n`;
    resultText += `|------|------|--------|\n`;
    resultText += `| CustomMessageCell | 自定义消息 Cell 基类 | CustomMessageCell.swift |\n`;
    resultText += `| MessageEntity | 消息实体，包含高度计算 | MessageEntity.swift |\n`;
    resultText += `| ComponentsRegister | 注册自定义组件 | ComponentsRegister.swift |\n`;
    resultText += `| ChatCustomMessageBody | 自定义消息体 | SDK |\n\n`;

    resultText += `### 💡 提示\n\n`;
    resultText += `使用 \`generate_code scenario="custom_message" name="${messageName}"\` 可单独生成代码模板。\n`;

    return resultText;
  }

  private async getAddMenuSolution(platform?: string): Promise<string> {
    const normalizedPlatform = platform === 'react-native' ? 'rn' : platform;
    const scenario = this.knowledgeRegistry.getScenario('add_attachment_menu', normalizedPlatform)
      || this.knowledgeRegistry.getScenario('common:add_attachment_menu')
      || this.knowledgeRegistry.getScenario('ios:add_attachment_menu')
      || this.knowledgeRegistry.getScenario('add_attachment_menu');

    let resultText = `## ➕ 添加附件菜单项方案\n\n`;

    if (scenario) {
      resultText += `### 实现步骤\n\n`;
      scenario.steps.forEach((step, i) => {
        resultText += `${i + 1}. ${step}\n`;
      });
      resultText += '\n';
    }

    const generated = this.platformOrchestrator.generateCode('attachment_menu', normalizedPlatform || 'ios', {
      platform: normalizedPlatform || 'ios',
      name: 'SendOrder',
      variables: {
        menuName: '发送订单',
        menuTag: 'SendOrder',
        iconName: 'order_icon'
      }
    });

    resultText += `### 代码示例\n\n`;
    if (generated) {
      resultText += `\`\`\`swift\n${generated.code}\n\`\`\`\n\n`;
      if (generated.usage) {
        resultText += `**集成步骤**:\n${generated.usage}\n\n`;
      }
    }

    resultText += `### 💡 提示\n\n`;
    resultText += `- 使用 \`generate_code scenario="attachment_menu"\` 生成更多代码模板\n`;
    resultText += `- 菜单图标建议使用 24x24 或 32x32 的 PNG 图片\n`;

    return resultText;
  }

  private async getUiCustomizationSolution(
    configProperty: string | null,
    subIntent?: string,
    platform?: string,
    componentName?: string | null,
    rawQuery?: string
  ): Promise<string> {
    const normalizedPlatform = platform === 'react-native' ? 'rn' : platform;
    const moduleId = this.resolveModuleId(componentName);
    const platformRoute = normalizedPlatform
      ? this.platformCapabilityRegistry.getPlatformRoute(moduleId, normalizedPlatform)
      : null;
    const routingNotice = this.buildPlatformRoutingNotice(platformRoute, moduleId, normalizedPlatform);
    const normalizedConfigProperty = configProperty?.trim() || null;
    const subIntentFromConfig = normalizedConfigProperty === 'messageLongPressedActions'
      ? 'message_long_press_menu'
      : normalizedConfigProperty === 'contentStyle'
        ? 'message_content_style'
        : undefined;
    const resolvedSubIntent = subIntent || subIntentFromConfig;
    let resultText = `## 🎨 UI 定制方案\n\n`;
    if (routingNotice) {
      resultText += routingNotice;
      return resultText;
    }

    const appearanceQuickIndex = normalizedPlatform === 'ios'
      ? this.buildAppearanceQuickIndex(platformRoute)
      : '';
    const uiOptionsFallback = normalizedPlatform === 'ios'
      ? this.buildUiOptionsFallback(platformRoute)
      : '';
    const entryRouteSummary = appearanceQuickIndex ? '' : this.buildEntryRouteSummary(platformRoute);

    if (configProperty) {
      const usage = this.configSearch.getConfigUsage(configProperty, 'all', normalizedPlatform);
      if (usage) {
        resultText += `### 配置项: ${configProperty}\n\n`;
        resultText += `**类型**: \`${usage.property.type}\`\n`;
        resultText += `**默认值**: \`${usage.property.defaultValue || '无'}\`\n`;
        resultText += `**影响组件**: ${usage.affectedComponents.slice(0, 5).join(', ')}\n\n`;
      }
    }

    switch (resolvedSubIntent) {
      case 'bubble_style':
        resultText += `### 气泡样式定制\n\n`;
        resultText += `\`\`\`swift
// 设置气泡圆角
Appearance.chat.bubbleStyle = .withArrow  // 带箭头样式

// 设置气泡颜色（通过主题色调）
Appearance.primaryHue = 203/360.0  // 蓝色系

// 如需完全自定义，继承 MessageCell 重写
class MyBubbleCell: MessageCell {
    override func createContent() -> UIView {
        let bubble = super.createContent()
        bubble.backgroundColor = .systemBlue
        bubble.layer.cornerRadius = 16
        return bubble
    }
}
\`\`\`\n\n`;
        break;

      case 'avatar_style':
        resultText += `### 头像样式定制\n\n`;
        resultText += `\`\`\`swift
// 设置头像圆角
Appearance.avatarRadius = .large  // 圆形头像

// 设置占位图
Appearance.avatarPlaceHolder = UIImage(named: "default_avatar")

// 可选值: .extraSmall, .small, .medium, .large
\`\`\`\n\n`;
        break;

      case 'color_theme':
      case 'theme':
        resultText += `### 主题颜色定制\n\n`;
        resultText += `\`\`\`swift
// 设置主色调 (HSL 色相值 0-1)
Appearance.primaryHue = 203/360.0     // 蓝色
Appearance.secondaryHue = 155/360.0   // 绿色
Appearance.errorHue = 350/360.0       // 红色

// 常用色相参考:
// 红色: 0/360.0
// 橙色: 30/360.0
// 黄色: 60/360.0
// 绿色: 120/360.0
// 蓝色: 210/360.0
// 紫色: 270/360.0
\`\`\`\n\n`;
        break;

      case 'custom_text_style':
      case 'text_style_customization':
        resultText += `### 文本消息样式深度定制\n\n`;
        resultText += `由于文本消息的渲染涉及复杂的富文本计算，修改颜色和字体需要通过重载 \`MessageEntity\` 实现：\n\n`;

        const generated = this.platformOrchestrator.generateCode('text_style_customization', normalizedPlatform || 'ios', {
          platform: normalizedPlatform || 'ios',
          name: 'Custom',
          variables: {
            messageName: 'Custom'
          }
        });
        if (generated) {
          resultText += `\`\`\`swift\n${generated.code}\n\`\`\`\n\n`;
          if (generated.usage) {
            resultText += `**集成步骤**:\n${generated.usage}\n`;
          }
        }
        break;

      case 'message_long_press_menu':
        resultText += `### 消息长按菜单样式\n\n`;
        resultText += `**Appearance 快速索引**：\n`;
        resultText += `- \`Appearance.chat.messageLongPressedActions\`：长按菜单项配置\n`;
        resultText += `- \`Appearance.actionSheetRowHeight\`：ActionSheet 行高\n\n`;
        resultText += `\`\`\`swift
// 1) 配置长按菜单项（ActionSheetItemProtocol）
let copy = ActionSheetItem(title: "复制", type: .normal, tag: "Copy")
copy.action = { /* 处理复制 */ }

let delete = ActionSheetItem(title: "删除", type: .destructive, tag: "Delete")
delete.action = { /* 处理删除 */ }

Appearance.chat.messageLongPressedActions = [copy, delete]

// 2) 调整菜单行高（可选）
Appearance.actionSheetRowHeight = 56
\`\`\`\n\n`;
        resultText += `说明：以上配置来自 \`Appearance.md\`（iOS ChatUIKit）。请在初始化 UIKit 前设置。\n`;
        break;

      case 'message_content_style':
        resultText += `### 消息内容展示样式\n\n`;
        resultText += `**Appearance 快速索引**：\n`;
        resultText += `- \`Appearance.chat.contentStyle\`：消息内容显示元素组合\n\n`;
        resultText += `\`\`\`swift
// 可选项：.withReply, .withAvatar, .withNickName, .withDateAndTime
Appearance.chat.contentStyle = [.withReply, .withAvatar, .withNickName, .withDateAndTime]
\`\`\`\n\n`;
        resultText += `说明：以上配置来自 \`Appearance.md\`（iOS ChatUIKit）。请在初始化 UIKit 前设置。\n`;
        break;

      case 'hide_message_avatar_nickname':
        resultText += `### 隐藏消息头像/昵称\n\n`;
        resultText += `**Appearance 快速索引**：\n`;
        resultText += `- \`Appearance.chat.contentStyle\`：去掉 \`.withAvatar\` / \`.withNickName\`\n\n`;
        resultText += `\`\`\`swift
// 仅保留需要显示的元素
Appearance.chat.contentStyle = [.withReply, .withDateAndTime]
\`\`\`\n\n`;
        resultText += `说明：以上配置来自 \`Appearance.md\`（iOS ChatUIKit）。请在初始化 UIKit 前设置。\n`;
        break;

      case 'appearance_quick_index':
        if (entryRouteSummary) {
          resultText += entryRouteSummary;
        }
        resultText += appearanceQuickIndex;
        resultText += uiOptionsFallback;
        break;

      default:
        if (entryRouteSummary) {
          resultText += entryRouteSummary;
        }
        if (appearanceQuickIndex) {
          resultText += appearanceQuickIndex;
          resultText += uiOptionsFallback;
        }
        if (moduleId !== 'chat_uikit') {
          break;
        }
        resultText += `### 常用配置项\n\n`;
        resultText += `| 配置项 | 作用 | 示例 |\n`;
        resultText += `|--------|------|------|\n`;
        resultText += `| primaryHue | 主色调 | 203/360.0 |\n`;
        resultText += `| avatarRadius | 头像圆角 | .large |\n`;
        resultText += `| bubbleStyle | 气泡样式 | .withArrow |\n`;
        resultText += `| inputPlaceHolder | 输入框占位符 | "请输入..." |\n\n`;

        resultText += `使用 \`list_config_options\` 查看所有可配置项。\n`;
    }

    const rgFallback = await this.buildRgFallbackSummary({
      query: rawQuery,
      moduleId,
      platform: normalizedPlatform,
      subIntent: resolvedSubIntent,
      configProperty: normalizedConfigProperty
    });
    if (rgFallback) {
      resultText += rgFallback;
    }

    return resultText;
  }

  private async buildRgFallbackSummary(options: {
    query?: string;
    moduleId: string;
    platform?: string;
    subIntent?: string;
    configProperty?: string | null;
  }): Promise<string> {
    const { query, moduleId, platform, subIntent, configProperty } = options;
    if (!query || !platform) return '';
    if (platform !== 'ios') return '';
    if (configProperty) return '';
    if (!this.shouldUseRgFallback(query)) return '';
    if (subIntent && subIntent !== 'appearance_quick_index') return '';

    const { docRoots, sourceRoots, projectRoot, docBase, sourceBase } = this.getRgSearchRoots(moduleId, platform);
    if (docRoots.length === 0 && sourceRoots.length === 0) return '';

    const docResult = await this.runRgSearch({
      query,
      roots: docRoots,
      globs: ['*.md'],
      projectRoot,
      maxFiles: 4,
      maxLines: 40
    });

    const sourceResult = await this.runRgSearch({
      query,
      roots: sourceRoots,
      globs: ['*.swift'],
      projectRoot,
      maxFiles: 4,
      maxLines: 40
    });

    if (docResult.status === 'none' && sourceResult.status === 'none') {
      return '';
    }

    let result = `### 兜底检索（rg）\n\n`;

    if (docResult.status === 'ambiguous' || sourceResult.status === 'ambiguous') {
      result += `命中结果较多，请提供更具体的关键词（类名/配置项/文件名），以便精确定位。\n\n`;
    }

    if (docResult.status === 'ok') {
      result += `**文档候选**\n`;
      for (const item of docResult.files) {
        const docPath = this.toDocPath(item.path, docBase);
        if (!docPath) continue;
        result += `- \`${docPath}\`（建议：\`read_doc path="${docPath}"\`）\n`;
      }
      result += '\n';
    }

    if (sourceResult.status === 'ok') {
      result += `**源码候选**\n`;
      for (const item of sourceResult.files) {
        const sourcePath = this.toSourcePath(item.path, sourceBase);
        if (!sourcePath) continue;
        const lineInfo = item.line ? `:${item.line}` : '';
        result += `- \`${sourcePath}${lineInfo}\`\n`;
      }
      result += '\n';
    }

    return result;
  }

  private shouldUseRgFallback(query: string): boolean {
    const trimmed = query.trim();
    if (trimmed.length < 2) return false;
    const hasChinese = /[\u4e00-\u9fa5]{2,}/.test(trimmed);
    const hasAscii = /[a-zA-Z0-9]{3,}/.test(trimmed);
    return hasChinese || hasAscii;
  }

  private getRgSearchRoots(moduleId: string, platform: string) {
    const projectRoot = path.join(__dirname, '../..');
    const docBase = path.join(projectRoot, 'data/docs');
    const sourceBase = path.join(projectRoot, 'data/sources');

    if (platform !== 'ios') {
      return { docRoots: [], sourceRoots: [], projectRoot, docBase, sourceBase };
    }

    if (moduleId === 'call_kit') {
      return {
        docRoots: [path.join(docBase, 'ios/guides/callkit')],
        sourceRoots: [path.join(sourceBase, 'ios/EaseCallUIKit')],
        projectRoot,
        docBase,
        sourceBase
      };
    }

    return {
      docRoots: [path.join(docBase, 'ios/guides/chatuikit')],
      sourceRoots: [path.join(sourceBase, 'ios/EaseChatUIKit')],
      projectRoot,
      docBase,
      sourceBase
    };
  }

  private async runRgSearch(options: {
    query: string;
    roots: string[];
    globs: string[];
    projectRoot: string;
    maxFiles: number;
    maxLines: number;
  }): Promise<{ status: 'ok' | 'ambiguous' | 'none'; files: Array<{ path: string; line?: number }> }> {
    const { query, roots, globs, projectRoot, maxFiles, maxLines } = options;
    if (roots.length === 0) return { status: 'none', files: [] };

    const args: string[] = ['-n', '-S', '--no-heading', '--color', 'never', '--max-count', String(maxLines)];
    for (const glob of globs) {
      args.push('-g', glob);
    }
    args.push('--', query, ...roots.map(root => path.relative(projectRoot, root)));

    try {
      const { stdout } = await execFileAsync('rg', args, {
        cwd: projectRoot,
        maxBuffer: 1024 * 1024
      });
      const lines = stdout.trim().split('\n').filter(Boolean);
      if (lines.length === 0) return { status: 'none', files: [] };

      const fileMap = new Map<string, { path: string; line?: number }>();
      for (const line of lines) {
        const first = line.indexOf(':');
        const second = first === -1 ? -1 : line.indexOf(':', first + 1);
        if (first === -1 || second === -1) continue;
        const rawPath = line.slice(0, first);
        const filePath = path.isAbsolute(rawPath) ? rawPath : path.join(projectRoot, rawPath);
        const lineNumber = parseInt(line.slice(first + 1, second), 10);
        if (!fileMap.has(filePath)) {
          fileMap.set(filePath, {
            path: filePath,
            line: Number.isNaN(lineNumber) ? undefined : lineNumber
          });
        }
        if (fileMap.size >= maxFiles && lines.length >= maxLines) {
          break;
        }
      }

      if (fileMap.size > maxFiles || lines.length >= maxLines) {
        return { status: 'ambiguous', files: [] };
      }

      return {
        status: 'ok',
        files: Array.from(fileMap.values())
      };
    } catch (error: any) {
      if (error?.code === 1) {
        return { status: 'none', files: [] };
      }
      return { status: 'none', files: [] };
    }
  }

  private toDocPath(filePath: string, docBase: string): string | null {
    const normalized = filePath.replace(/\\/g, '/');
    const marker = docBase.replace(/\\/g, '/') + '/';
    const index = normalized.indexOf(marker);
    if (index === -1) return null;
    return normalized.slice(index + marker.length);
  }

  private toSourcePath(filePath: string, sourceBase: string): string | null {
    const normalized = filePath.replace(/\\/g, '/');
    const marker = sourceBase.replace(/\\/g, '/') + '/';
    const index = normalized.indexOf(marker);
    if (index === -1) return null;
    return normalized.slice(index + marker.length);
  }

  private resolveModuleId(componentName?: string | null): string {
    if (!componentName) return 'chat_uikit';
    const moduleMatch = this.platformCapabilityRegistry.getModuleByAlias(componentName);
    return moduleMatch?.id || 'chat_uikit';
  }

  private buildPlatformRoutingNotice(
    route: PlatformRoute | null,
    moduleId: string,
    platform?: string
  ): string {
    if (!platform) return '';
    if (!route) {
      return `### 平台入口未接入\n\n` +
        `模块 \`${moduleId}\` 的 \`${platform}\` 入口尚未配置。\n` +
        `请参考 \`docs/PLATFORM_ENTRY_ROUTING.md\` 接入平台入口路由。\n\n`;
    }
    if (route.status !== 'available') {
      return `### 平台入口未接入\n\n` +
        `${route.moduleName} 在 \`${platform}\` 平台尚未接入入口路由。\n` +
        `${route.note ? `备注: ${route.note}\n` : ''}` +
        `请参考 \`docs/PLATFORM_ENTRY_ROUTING.md\` 接入平台入口路由。\n\n`;
    }
    return '';
  }

  private buildAppearanceQuickIndex(route: PlatformRoute | null): string {
    if (!route || route.status !== 'available') return '';
    const appearanceRoute = route.entryRoutes.find(item => item.surface === 'appearance');
    if (!appearanceRoute) return '';

    let result = `### Appearance 优先入口\n\n`;
    if (appearanceRoute.docPath) {
      result += `- 直接查看: \`read_doc path="${appearanceRoute.docPath}"\`\n`;
    } else if (appearanceRoute.sourcePath) {
      result += `- 直接查看: \`read_source path="${appearanceRoute.sourcePath}"\`\n`;
    }
    if (appearanceRoute.examples && appearanceRoute.examples.length > 0) {
      for (const example of appearanceRoute.examples) {
        result += `- ${example}\n`;
      }
    }
    return result + '\n';
  }

  private buildEntryRouteSummary(route: PlatformRoute | null): string {
    if (!route || route.status !== 'available') return '';
    if (!route.entryRoutes || route.entryRoutes.length === 0) return '';

    let result = `### 平台入口路由（${route.moduleName} / ${route.platform}）\n\n`;
    for (const item of route.entryRoutes) {
      const label = this.formatEntryRouteLabel(item.surface);
      const parts: string[] = [];
      if (item.summary) {
        parts.push(item.summary);
      }
      if (item.docPath) {
        parts.push(`read_doc: \`${item.docPath}\``);
      }
      if (item.sourcePath) {
        parts.push(`read_source: \`${item.sourcePath}\``);
      }
      const detail = parts.length > 0 ? ` - ${parts.join(' | ')}` : '';
      result += `- ${label}${detail}\n`;
    }
    return result + '\n';
  }

  private formatEntryRouteLabel(surface: string): string {
    switch (surface) {
      case 'appearance':
        return 'Appearance';
      case 'options':
        return 'UIOptions / 初始化选项';
      case 'component_props':
        return '组件构造参数';
      case 'theme_tokens':
        return '主题变量';
      case 'override':
        return '源码扩展/继承';
      case 'source':
        return '源码入口';
      default:
        return surface;
    }
  }

  private buildUiOptionsFallback(route: PlatformRoute | null): string {
    if (!route || route.status !== 'available') return '';
    const optionsRoute = route.entryRoutes.find(item => item.surface === 'options');
    if (!optionsRoute) return '';

    let result = `### 未命中 Appearance？\n\n`;
    if (optionsRoute.docPath) {
      result += `- 直接查看: \`read_doc path="${optionsRoute.docPath}"\`\n`;
    }
    if (optionsRoute.examples && optionsRoute.examples.length > 0) {
      result += `初始化开关优先看：\n`;
      for (const example of optionsRoute.examples) {
        result += `- \`${example}\`\n`;
      }
      result += '\n';
    }
    return result;
  }

  async explainClass(className: string, platform?: string): Promise<string> {
    // 先检查该平台是否有知识图谱数据
    const hasPlatformData = platform ? this.knowledgeGraph.hasPlatformData(platform) : true;
    const classInfo = this.knowledgeGraph.getClassInfo(className, platform);

    if (!classInfo) {
      // 知识图谱中没有找到，尝试源码搜索
      const searchResult = this.sourceSearch.search(className, 'all', 3, platform);
      if (searchResult.results.length > 0) {
        let resultText = `## 📖 ${className}\n\n`;
        // 如果指定平台没有知识图谱数据，提示用户
        if (platform && !hasPlatformData) {
          resultText += `> ℹ️ ${platform} 平台暂无知识图谱数据，以下为源码搜索结果。\n\n`;
        }
        resultText += `在以下文件中找到相关定义：\n\n`;
        for (const r of searchResult.results) {
          resultText += `- \`${r.path}\`\n`;
        }
        resultText += `\n使用 \`read_source path="${searchResult.results[0].path}"\` 查看具体实现。\n`;
        return resultText;
      }
      // 如果平台没有知识图谱数据，给出提示
      if (platform && !hasPlatformData) {
        const supportedPlatforms = this.knowledgeGraph.getSupportedPlatforms();
        return `${platform} 平台暂无知识图谱数据。\n\n` +
          `当前支持的平台: ${supportedPlatforms.join(', ') || '无'}\n\n` +
          `建议使用以下工具查找信息：\n` +
          `- \`search_source query="${className}" platform="${platform}"\` 搜索源码\n` +
          `- \`search_api query="${className}" platform="${platform}"\` 搜索 API 文档\n`;
      }
      return `未找到类 ${className} 的定义。请检查类名是否正确。\n`;
    }

    let resultText = `## 📚 ${className}\n\n`;

    if (classInfo.description) {
      resultText += `${classInfo.description}\n\n`;
    }

    if (classInfo.superclass) {
      const inheritanceChain = this.knowledgeGraph.getInheritanceChain(className, platform);
      resultText += `### 继承关系\n\n`;
      resultText += `\`${inheritanceChain.join(' → ')}\`\n\n`;
    }

    if (classInfo.keyMethods && classInfo.keyMethods.length > 0) {
      resultText += `### 关键方法\n\n`;
      for (const method of classInfo.keyMethods) {
        resultText += `- \`${method}\`\n`;
      }
      resultText += '\n';
    }

    if (classInfo.keyProperties && classInfo.keyProperties.length > 0) {
      resultText += `### 关键属性\n\n`;
      for (const prop of classInfo.keyProperties) {
        resultText += `- \`${prop}\`\n`;
      }
      resultText += '\n';
    }

    if (classInfo.usageScenarios && classInfo.usageScenarios.length > 0) {
      resultText += `### 使用场景\n\n`;
      for (const scenario of classInfo.usageScenarios) {
        // 按平台优先级查找场景信息
        const scenarioInfo = this.knowledgeRegistry.getScenario(`${platform}:${scenario}`, platform)
          || this.knowledgeRegistry.getScenario(`common:${scenario}`)
          || this.knowledgeRegistry.getScenario(scenario, platform);
        if (scenarioInfo) {
          resultText += `- **${scenarioInfo.scenario}**: ${scenarioInfo.description}\n`;
        } else {
          resultText += `- ${scenario}\n`;
        }
      }
      resultText += '\n';
    }

    resultText += `使用 \`read_source path="${classInfo.file}"\` 查看完整源码。\n`;

    return resultText;
  }
}
