#!/usr/bin/env npx tsx
/**
 * 回放 Smart Assist 会话，生成可分析日志
 *
 * 使用方式：
 * EASEIM_SMART_ASSIST_LOG=1 \
 * EASEIM_SMART_ASSIST_LOG_PATH=./tmp/smart-assist.log \
 * npx tsx scripts/replay-smart-assist-sessions.ts
 */

import * as fs from 'fs';
import * as path from 'path';
import { IntentClassifier } from '../src/intelligence/IntentClassifier.js';
import { SmartAssistContext } from '../src/assist/SmartAssistContext.js';
import { SmartAssistResponse } from '../src/assist/SmartAssistResponse.js';
import { ContextManager } from '../src/intelligence/ContextManager.js';
import { DocSearch } from '../src/search/DocSearch.js';
import { KnowledgeRegistry } from '../src/intelligence/KnowledgeRegistry.js';
import { TemplateRegistry } from '../src/intelligence/TemplateRegistry.js';
import { PlatformOrchestrator } from '../src/intelligence/PlatformOrchestrator.js';
import { CodeGenerator } from '../src/intelligence/CodeGenerator.js';
import { ConfigSearch } from '../src/search/ConfigSearch.js';
import { KnowledgeGraph } from '../src/intelligence/KnowledgeGraph.js';
import { ShardedSourceSearch } from '../src/search/ShardedSourceSearch.js';
import { SmartAssistService } from '../src/assist/SmartAssistService.js';

type SessionCase = {
  session_id: string;
  platform: string;
  queries: string[];
};

function getArg(name: string): string | undefined {
  const index = process.argv.indexOf(name);
  if (index === -1) return undefined;
  return process.argv[index + 1];
}

function loadCases(filePath?: string): SessionCase[] {
  if (!filePath) {
    return [
      {
        session_id: 's-ui-ambiguous',
        platform: 'ios',
        queries: [
          '怎么改气泡',
          '消息气泡颜色怎么改',
          'iOS 里消息气泡颜色怎么改'
        ]
      },
      {
        session_id: 's-harmony-callkit-gap',
        platform: 'harmony',
        queries: [
          '鸿蒙 callkit 怎么接入',
          'harmonyos 有通话 uikit 吗',
          '有没有 callkit demo'
        ]
      },
      {
        session_id: 's-flutter-roomuikit',
        platform: 'flutter',
        queries: [
          'flutter chatroomuikit 怎么集成',
          'flutter chatroomuikit demo 在哪里',
          '只有 chatuikit 吗'
        ]
      }
    ];
  }

  const absPath = path.resolve(filePath);
  if (!fs.existsSync(absPath)) {
    throw new Error(`用例文件不存在: ${absPath}`);
  }
  const parsed = JSON.parse(fs.readFileSync(absPath, 'utf-8')) as SessionCase[];
  return parsed;
}

async function main() {
  const caseFile = getArg('--cases');
  const sessions = loadCases(caseFile);

  const intentClassifier = new IntentClassifier();
  const context = new SmartAssistContext(new ContextManager());
  const responses = new SmartAssistResponse();
  const docSearch = new DocSearch();
  const knowledgeRegistry = new KnowledgeRegistry();
  const templateRegistry = new TemplateRegistry();
  const codeGenerator = new CodeGenerator();
  const platformOrchestrator = new PlatformOrchestrator(knowledgeRegistry, templateRegistry, codeGenerator);
  const configSearch = new ConfigSearch();
  const knowledgeGraph = new KnowledgeGraph();
  const sourceSearch = new ShardedSourceSearch();

  const service = new SmartAssistService(
    intentClassifier,
    context,
    responses,
    docSearch,
    knowledgeRegistry,
    templateRegistry,
    platformOrchestrator,
    configSearch,
    knowledgeGraph,
    sourceSearch
  );

  console.log(`🚀 开始回放会话，共 ${sessions.length} 个 session`);
  for (const session of sessions) {
    console.log(`\n📌 session=${session.session_id}, platform=${session.platform}, turns=${session.queries.length}`);
    for (const query of session.queries) {
      try {
        const result = await service.handle({
          query,
          platform: session.platform,
          session_id: session.session_id
        });
        const text = Array.isArray(result?.content) && result.content[0]?.text
          ? String(result.content[0].text)
          : '';
        console.log(`- Q: ${query}`);
        console.log(`  A: ${text.replace(/\s+/g, ' ').slice(0, 120)}...`);
      } catch (error) {
        console.log(`- Q: ${query}`);
        console.log(`  E: ${error instanceof Error ? error.message : String(error)}`);
      }
    }
  }
  console.log('\n✅ 回放完成');
}

main().catch((error) => {
  console.error('❌ 回放失败:', error);
  process.exit(1);
});
