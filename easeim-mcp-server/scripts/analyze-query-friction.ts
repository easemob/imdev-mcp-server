#!/usr/bin/env npx tsx
/**
 * 查询纠缠分析器
 *
 * 输入：
 * - ToolLogger JSONL
 * - SmartAssistLogger JSONL
 *
 * 输出：
 * - 识别“同一问题多次纠缠”的会话链路
 * - 归因：表述不清 / 内容缺失 / 未直接告知无结果 / 证据链偏弱
 * - 生成 Markdown 报告
 */

import * as fs from 'fs';
import * as path from 'path';

type ToolLogEntry = {
  timestamp: string;
  session_id?: string;
  tool?: { name?: string; args?: unknown };
  response?: {
    type?: 'success' | 'error';
    category?: 'answer' | 'clarification' | 'no_result';
    has_no_result_cue?: boolean;
    direct_no_result?: boolean;
    evidence_count?: number;
    preview?: string;
  };
};

type SmartAssistLogEntry = {
  timestamp: string;
  session_id?: string;
  raw_query?: string;
  route?: { name?: string; reason?: string };
  ambiguity?: { is_ambiguous?: boolean; type?: string };
  response?: {
    type?: 'answer' | 'clarification' | 'error';
    category?: 'answer' | 'clarification' | 'no_result';
    has_no_result_cue?: boolean;
    direct_no_result?: boolean;
    evidence_count?: number;
    preview?: string;
  };
};

type Turn = {
  source: 'tool' | 'smart_assist';
  sessionId: string;
  timestamp: string;
  ts: number;
  query: string;
  normalizedQuery: string;
  responseType: string;
  category: 'answer' | 'clarification' | 'no_result';
  hasNoResultCue: boolean;
  directNoResult: boolean;
  evidenceCount: number;
  preview: string;
  toolName?: string;
  routeName?: string;
  routeReason?: string;
  ambiguityType?: string;
};

type FrictionCase = {
  sessionId: string;
  normalizedQuery: string;
  sampleQuery: string;
  attempts: number;
  clarificationTurns: number;
  noResultTurns: number;
  directNoResultTurns: number;
  answerTurns: number;
  evidenceCount: number;
  cause: string;
  confidence: 'high' | 'medium' | 'low';
  score: number;
  turns: Turn[];
};

function getArg(name: string): string | undefined {
  const index = process.argv.indexOf(name);
  if (index === -1) return undefined;
  return process.argv[index + 1];
}

function parseJsonl<T>(filePath: string): T[] {
  if (!fs.existsSync(filePath)) return [];
  const lines = fs.readFileSync(filePath, 'utf-8')
    .split('\n')
    .map(line => line.trim())
    .filter(Boolean);

  const results: T[] = [];
  for (const line of lines) {
    try {
      results.push(JSON.parse(line) as T);
    } catch {
      // 忽略坏行
    }
  }
  return results;
}

function normalizeQuery(raw: string): string {
  return raw
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function pickToolQuery(args: unknown): string {
  if (!args || typeof args !== 'object') return '';
  const record = args as Record<string, unknown>;
  const keys = ['query', 'symptom', 'propertyName', 'className', 'topic', 'path', 'symbol', 'code'];
  for (const key of keys) {
    if (record[key] === undefined || record[key] === null) continue;
    const value = String(record[key]).trim();
    if (value) return value;
  }
  return '';
}

function toTurnFromTool(entry: ToolLogEntry): Turn | null {
  const query = pickToolQuery(entry.tool?.args);
  if (!query) return null;
  const sessionId = entry.session_id || 'default';
  const ts = Date.parse(entry.timestamp || '');
  const category = entry.response?.category
    || (entry.response?.type === 'error' ? 'no_result' : 'answer');
  return {
    source: 'tool',
    sessionId,
    timestamp: entry.timestamp,
    ts: Number.isFinite(ts) ? ts : 0,
    query,
    normalizedQuery: normalizeQuery(query),
    responseType: entry.response?.type || 'unknown',
    category,
    hasNoResultCue: !!entry.response?.has_no_result_cue,
    directNoResult: !!entry.response?.direct_no_result,
    evidenceCount: entry.response?.evidence_count || 0,
    preview: entry.response?.preview || '',
    toolName: entry.tool?.name
  };
}

function toTurnFromSmartAssist(entry: SmartAssistLogEntry): Turn | null {
  const query = (entry.raw_query || '').trim();
  if (!query) return null;
  const sessionId = entry.session_id || 'default';
  const ts = Date.parse(entry.timestamp || '');
  const category = entry.response?.category
    || (entry.response?.type === 'clarification' ? 'clarification' : entry.response?.type === 'error' ? 'no_result' : 'answer');
  return {
    source: 'smart_assist',
    sessionId,
    timestamp: entry.timestamp,
    ts: Number.isFinite(ts) ? ts : 0,
    query,
    normalizedQuery: normalizeQuery(query),
    responseType: entry.response?.type || 'unknown',
    category,
    hasNoResultCue: !!entry.response?.has_no_result_cue,
    directNoResult: !!entry.response?.direct_no_result,
    evidenceCount: entry.response?.evidence_count || 0,
    preview: entry.response?.preview || '',
    routeName: entry.route?.name,
    routeReason: entry.route?.reason,
    ambiguityType: entry.ambiguity?.type
  };
}

function classifyCause(stats: {
  attempts: number;
  clarificationTurns: number;
  noResultTurns: number;
  directNoResultTurns: number;
  answerTurns: number;
  evidenceCount: number;
  hasAmbiguityRoute: boolean;
}): { cause: string; confidence: 'high' | 'medium' | 'low'; score: number } {
  const {
    attempts,
    clarificationTurns,
    noResultTurns,
    directNoResultTurns,
    answerTurns,
    evidenceCount,
    hasAmbiguityRoute
  } = stats;

  if (clarificationTurns >= 2 && noResultTurns === 0 && evidenceCount === 0 && answerTurns >= 1) {
    return {
      cause: '回答泛化且缺少证据，疑似内容缺失但未直接告知无结果',
      confidence: 'high',
      score: attempts * 2 + clarificationTurns * 2 + 3
    };
  }

  if (clarificationTurns >= 2 || hasAmbiguityRoute) {
    return {
      cause: '表述不清或缺少关键槽位（平台/组件/问题上下文）',
      confidence: clarificationTurns >= 2 ? 'high' : 'medium',
      score: attempts * 2 + clarificationTurns * 3
    };
  }

  if (noResultTurns > 0 && answerTurns === 0) {
    return {
      cause: '内容缺失或索引覆盖不足（问题无法命中）',
      confidence: 'high',
      score: attempts * 2 + noResultTurns * 3
    };
  }

  if (noResultTurns > 0 && directNoResultTurns === 0) {
    return {
      cause: '未直接告知“无结果”，导致用户反复追问',
      confidence: 'medium',
      score: attempts * 2 + noResultTurns * 2 + 2
    };
  }

  if (attempts >= 3 && evidenceCount === 0) {
    return {
      cause: '回答缺少证据链（路径/行号），用户信任不足而重复询问',
      confidence: 'medium',
      score: attempts * 2 + 2
    };
  }

  return {
    cause: '可能是多轮确认过程，建议人工复核',
    confidence: 'low',
    score: attempts
  };
}

function analyzeFriction(turns: Turn[], minAttempts: number): FrictionCase[] {
  const bySession = new Map<string, Turn[]>();
  for (const turn of turns) {
    if (!bySession.has(turn.sessionId)) bySession.set(turn.sessionId, []);
    bySession.get(turn.sessionId)!.push(turn);
  }

  const cases: FrictionCase[] = [];

  for (const [sessionId, sessionTurns] of bySession) {
    const sorted = sessionTurns.sort((a, b) => a.ts - b.ts);
    const byQuery = new Map<string, Turn[]>();
    for (const turn of sorted) {
      if (!turn.normalizedQuery) continue;
      if (!byQuery.has(turn.normalizedQuery)) byQuery.set(turn.normalizedQuery, []);
      byQuery.get(turn.normalizedQuery)!.push(turn);
    }

    for (const [normalizedQuery, queryTurns] of byQuery) {
      if (queryTurns.length < minAttempts) continue;
      const clarificationTurns = queryTurns.filter(t => t.category === 'clarification').length;
      const noResultTurns = queryTurns.filter(t => t.category === 'no_result' || t.hasNoResultCue).length;
      const directNoResultTurns = queryTurns.filter(t => t.directNoResult).length;
      const answerTurns = queryTurns.filter(t => t.category === 'answer').length;
      const evidenceCount = queryTurns.reduce((sum, turn) => sum + turn.evidenceCount, 0);
      const hasAmbiguityRoute = queryTurns.some(t =>
        (t.routeName || '').includes('ambiguous')
        || (t.routeName || '').includes('missing_platform')
        || (t.routeName || '').includes('low_confidence')
        || !!t.ambiguityType
      );

      const judgement = classifyCause({
        attempts: queryTurns.length,
        clarificationTurns,
        noResultTurns,
        directNoResultTurns,
        answerTurns,
        evidenceCount,
        hasAmbiguityRoute
      });

      cases.push({
        sessionId,
        normalizedQuery,
        sampleQuery: queryTurns[0]?.query || normalizedQuery,
        attempts: queryTurns.length,
        clarificationTurns,
        noResultTurns,
        directNoResultTurns,
        answerTurns,
        evidenceCount,
        cause: judgement.cause,
        confidence: judgement.confidence,
        score: judgement.score,
        turns: queryTurns
      });
    }

    const sessionClarifications = sorted.filter(t => t.category === 'clarification').length;
    const sessionNoResults = sorted.filter(t => t.category === 'no_result' || t.hasNoResultCue).length;
    const sessionDirectNoResults = sorted.filter(t => t.directNoResult).length;
    const sessionAnswers = sorted.filter(t => t.category === 'answer').length;
    const sessionEvidence = sorted.reduce((sum, turn) => sum + turn.evidenceCount, 0);
    const sessionAmbiguous = sorted.some(t =>
      (t.routeName || '').includes('ambiguous')
      || (t.routeName || '').includes('missing_platform')
      || (t.routeName || '').includes('low_confidence')
      || !!t.ambiguityType
    );

    const hasSessionFriction = sorted.length >= minAttempts && (
      sessionClarifications >= 2
      || (sessionNoResults > 0 && sessionAnswers === 0)
      || (sessionClarifications >= 1 && sorted.length >= 3)
    );

    if (hasSessionFriction) {
      const judgement = classifyCause({
        attempts: sorted.length,
        clarificationTurns: sessionClarifications,
        noResultTurns: sessionNoResults,
        directNoResultTurns: sessionDirectNoResults,
        answerTurns: sessionAnswers,
        evidenceCount: sessionEvidence,
        hasAmbiguityRoute: sessionAmbiguous
      });

      cases.push({
        sessionId,
        normalizedQuery: `session:${sessionId}`,
        sampleQuery: sorted.map(turn => turn.query).slice(0, 2).join(' → '),
        attempts: sorted.length,
        clarificationTurns: sessionClarifications,
        noResultTurns: sessionNoResults,
        directNoResultTurns: sessionDirectNoResults,
        answerTurns: sessionAnswers,
        evidenceCount: sessionEvidence,
        cause: `${judgement.cause}（会话级）`,
        confidence: judgement.confidence,
        score: judgement.score + 1,
        turns: sorted
      });
    }
  }

  const dedup = new Map<string, FrictionCase>();
  for (const item of cases.sort((a, b) => b.score - a.score)) {
    const key = `${item.sessionId}|${item.normalizedQuery}`;
    if (!dedup.has(key)) {
      dedup.set(key, item);
    }
  }

  return Array.from(dedup.values()).sort((a, b) => b.score - a.score);
}

function renderReport(params: {
  toolLogPath?: string;
  assistLogPath?: string;
  turnCount: number;
  sessionCount: number;
  cases: FrictionCase[];
}): string {
  const { toolLogPath, assistLogPath, turnCount, sessionCount, cases } = params;
  const topCases = cases.slice(0, 20);
  const causeCounter = new Map<string, number>();
  for (const item of topCases) {
    causeCounter.set(item.cause, (causeCounter.get(item.cause) || 0) + 1);
  }

  let md = '# 查询纠缠证据链报告\n\n';
  md += `- 生成时间: ${new Date().toISOString()}\n`;
  md += `- Tool 日志: ${toolLogPath || '未提供'}\n`;
  md += `- SmartAssist 日志: ${assistLogPath || '未提供'}\n`;
  md += `- 分析总 Turn: ${turnCount}\n`;
  md += `- 会话数: ${sessionCount}\n`;
  md += `- 识别纠缠问题数: ${cases.length}\n\n`;

  md += '## 归因分布\n\n';
  if (causeCounter.size === 0) {
    md += '- 暂无可归因样本\n\n';
  } else {
    for (const [cause, count] of causeCounter.entries()) {
      md += `- ${cause}: ${count}\n`;
    }
    md += '\n';
  }

  md += '## Top 纠缠问题\n\n';
  if (topCases.length === 0) {
    md += '暂无满足阈值的重复纠缠样本。\n\n';
  } else {
    md += '| 会话 | 查询 | 尝试次数 | 澄清次数 | 无结果次数 | 直接告知无结果 | 证据命中 | 主要原因 | 置信度 |\n';
    md += '|---|---|---:|---:|---:|---:|---:|---|---|\n';
    for (const item of topCases) {
      md += `| ${item.sessionId} | ${item.sampleQuery.replace(/\|/g, '\\|')} | ${item.attempts} | ${item.clarificationTurns} | ${item.noResultTurns} | ${item.directNoResultTurns} | ${item.evidenceCount} | ${item.cause} | ${item.confidence} |\n`;
    }
    md += '\n';
  }

  md += '## 证据链样本\n\n';
  for (const item of topCases.slice(0, 8)) {
    md += `### 会话 ${item.sessionId} / 查询: ${item.sampleQuery}\n\n`;
    md += `- 归因: ${item.cause}\n`;
    md += `- 指标: attempts=${item.attempts}, clarifications=${item.clarificationTurns}, no_results=${item.noResultTurns}, direct_no_result=${item.directNoResultTurns}, evidence=${item.evidenceCount}\n\n`;
    for (const turn of item.turns) {
      const route = turn.routeName ? ` route=${turn.routeName}${turn.routeReason ? `(${turn.routeReason})` : ''}` : '';
      const tool = turn.toolName ? ` tool=${turn.toolName}` : '';
      md += `- [${turn.timestamp}] source=${turn.source}${tool}${route} category=${turn.category} no_result=${turn.hasNoResultCue ? 'Y' : 'N'} direct_no_result=${turn.directNoResult ? 'Y' : 'N'} evidence=${turn.evidenceCount}\n`;
      if (turn.preview) {
        md += `  preview: ${turn.preview}\n`;
      }
    }
    md += '\n';
  }

  md += '## 优化建议\n\n';
  md += '1. 对“高澄清频次”问题，强化槽位提取与必填反问（平台/组件/层级），避免多轮猜测。\n';
  md += '2. 对“无结果且未直说”问题，统一输出模板：明确无命中 + 缺失范围 + 推荐下一步。\n';
  md += '3. 对“证据链弱”问题，强制返回至少一条证据路径（文档 path 或源码 path:line）。\n';
  md += '4. 对“内容缺失”高发问题，回补 raw-materials 与模板/知识库，并在报告中标注缺口平台与模块。\n';

  return md;
}

function main() {
  const toolLogPath = getArg('--tool-log');
  const assistLogPath = getArg('--assist-log');
  const outputPath = getArg('--output');
  const minAttempts = Number(getArg('--min-attempts') || '2');

  if (!toolLogPath && !assistLogPath) {
    console.error('❌ 请至少提供一个日志路径：--tool-log 或 --assist-log');
    process.exit(1);
  }

  const toolEntries = toolLogPath ? parseJsonl<ToolLogEntry>(toolLogPath) : [];
  const smartEntries = assistLogPath ? parseJsonl<SmartAssistLogEntry>(assistLogPath) : [];

  const turns: Turn[] = [];
  for (const entry of toolEntries) {
    const turn = toTurnFromTool(entry);
    if (turn) turns.push(turn);
  }
  for (const entry of smartEntries) {
    const turn = toTurnFromSmartAssist(entry);
    if (turn) turns.push(turn);
  }

  const sessionCount = new Set(turns.map(turn => turn.sessionId)).size;
  const cases = analyzeFriction(turns, Math.max(2, minAttempts));
  const report = renderReport({
    toolLogPath,
    assistLogPath,
    turnCount: turns.length,
    sessionCount,
    cases
  });

  if (outputPath) {
    const absPath = path.resolve(outputPath);
    fs.mkdirSync(path.dirname(absPath), { recursive: true });
    fs.writeFileSync(absPath, report);
    console.log(`✅ 报告已写入: ${absPath}`);
  } else {
    console.log(report);
  }
}

main();
