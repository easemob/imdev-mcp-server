type InspectCategory = 'answer' | 'clarification' | 'no_result';

export interface ResponseInspection {
  preview: string;
  category: InspectCategory;
  hasNoResultCue: boolean;
  hasClarificationCue: boolean;
  directNoResult: boolean;
  evidenceCount: number;
}

function toSingleLine(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}

function extractText(result: unknown): string {
  if (!result || typeof result !== 'object') return '';
  const record = result as Record<string, unknown>;
  const content = record.content;
  if (!Array.isArray(content)) return '';
  for (const item of content) {
    if (item && typeof item === 'object' && typeof (item as Record<string, unknown>).text === 'string') {
      return (item as Record<string, string>).text || '';
    }
  }
  return '';
}

function countEvidence(text: string): number {
  const pattern = /\b[\w.-]+(?:\/[\w./-]+)?\.(?:md|swift|kt|java|dart|ets|ts|tsx|js|jsx)(?::\d+(?:-\d+)?)?\b/g;
  const matches = text.match(pattern);
  return matches ? matches.length : 0;
}

function hasClarificationInMetadata(text: string): boolean {
  const marker = 'MCP_METADATA';
  if (!text.includes(marker)) return false;
  return /"needsClarification"\s*:\s*true/.test(text);
}

export function inspectMcpResult(result: unknown): ResponseInspection {
  const text = extractText(result);
  const preview = toSingleLine(text).slice(0, 240);
  const lower = text.toLowerCase();

  const hasNoResultCue = /未找到|无结果|没有找到|not found|no result|暂无|无法读取|未能找到/.test(text);
  const hasClarificationCue =
    hasClarificationInMetadata(text) ||
    /需要更多信息|请提供|请选择|请补充|需要澄清|missing info|clarification/.test(text);
  const directNoResult =
    /^(#\s*)?(api|源码|搜索|诊断)?\s*(结果)?.{0,20}(未找到|无结果|没有找到|暂无|不支持)/m.test(text) ||
    /^错误:\s*无法读取/m.test(text);
  const evidenceCount = countEvidence(text);

  let category: InspectCategory = 'answer';
  if (hasClarificationCue) {
    category = 'clarification';
  } else if (hasNoResultCue) {
    category = 'no_result';
  }

  if (!text.trim()) {
    category = 'no_result';
  }

  return {
    preview,
    category,
    hasNoResultCue,
    hasClarificationCue,
    directNoResult,
    evidenceCount
  };
}
