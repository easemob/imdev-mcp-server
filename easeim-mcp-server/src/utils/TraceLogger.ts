/**
 * 调用链追踪日志系统
 * 记录完整的请求处理链路，包括：
 * - 原始查询和增强后的查询
 * - 每个处理步骤的入参、出参、耗时
 * - 内部函数调用链
 */

import * as fs from 'fs';
import * as path from 'path';
import { randomUUID } from 'crypto';

/** 单个调用步骤 */
export interface TraceSpan {
  span_id: string;
  parent_span_id?: string;
  name: string;           // 步骤名称，如 'query_expand', 'doc_search', 'intent_classify'
  start_time: string;
  end_time?: string;
  duration_ms?: number;
  input?: unknown;        // 入参
  output?: unknown;       // 出参（可选截断）
  output_summary?: {      // 出参摘要
    type?: string;
    count?: number;
    preview?: string;
  };
  error?: string;
  metadata?: Record<string, unknown>;
}

/** 完整的请求追踪记录 */
export interface TraceRecord {
  log_version: 'v2';
  trace_id: string;
  session_id?: string;
  timestamp: string;

  // 原始请求
  request: {
    tool_name: string;
    args: unknown;
  };

  // 查询处理
  query_processing?: {
    raw_query: string;
    normalized_platform?: string;
    spell_correction?: {
      original: string;
      corrected: string;
      has_correction: boolean;
    };
    query_expansion?: {
      original: string;
      expanded_terms: string[];
      synonyms_used: Array<{ term: string; synonyms: string[] }>;
    };
    enhanced_query?: string;
  };

  // 意图识别
  intent?: {
    name: string;
    confidence: number;
    sub_intent?: string;
    entities?: Record<string, unknown>;
  };

  // 路由决策
  route?: {
    name: string;
    reason?: string;
  };

  // 调用链（所有内部函数调用）
  spans: TraceSpan[];

  // 最终响应
  response: {
    type: 'success' | 'error' | 'clarification';
    content_length?: number;
    result_count?: number;
    preview?: string;
  };

  // 总耗时
  total_duration_ms: number;

  // 错误信息
  error?: {
    message: string;
    stack?: string;
  };
}

/** 追踪上下文，用于在函数调用间传递 */
export class TraceContext {
  readonly traceId: string;
  readonly sessionId?: string;
  private spans: TraceSpan[] = [];
  private currentSpanId?: string;
  private startTime: number;
  private record: Partial<TraceRecord>;

  constructor(toolName: string, args: unknown, sessionId?: string) {
    this.traceId = randomUUID();
    this.sessionId = sessionId;
    this.startTime = Date.now();
    this.record = {
      log_version: 'v2',
      trace_id: this.traceId,
      session_id: sessionId,
      timestamp: new Date().toISOString(),
      request: {
        tool_name: toolName,
        args: this.sanitizeArgs(args)
      },
      spans: []
    };
  }

  /** 开始一个新的 span */
  startSpan(name: string, input?: unknown): string {
    const spanId = randomUUID().slice(0, 8);
    const span: TraceSpan = {
      span_id: spanId,
      parent_span_id: this.currentSpanId,
      name,
      start_time: new Date().toISOString(),
      input: this.truncateData(input)
    };
    this.spans.push(span);
    this.currentSpanId = spanId;
    return spanId;
  }

  /** 结束一个 span */
  endSpan(spanId: string, output?: unknown, metadata?: Record<string, unknown>) {
    const span = this.spans.find(s => s.span_id === spanId);
    if (span) {
      span.end_time = new Date().toISOString();
      span.duration_ms = Date.now() - new Date(span.start_time).getTime();
      span.output_summary = this.summarizeOutput(output);
      span.metadata = metadata;

      // 如果输出不太大，也记录完整输出
      const outputStr = JSON.stringify(output);
      if (outputStr && outputStr.length < 2000) {
        span.output = output;
      }
    }
    // 恢复到父 span
    if (span?.parent_span_id) {
      this.currentSpanId = span.parent_span_id;
    }
  }

  /** 记录 span 错误 */
  spanError(spanId: string, error: Error | string) {
    const span = this.spans.find(s => s.span_id === spanId);
    if (span) {
      span.error = typeof error === 'string' ? error : error.message;
      span.end_time = new Date().toISOString();
      span.duration_ms = Date.now() - new Date(span.start_time).getTime();
    }
  }

  /** 记录查询处理信息 */
  setQueryProcessing(info: TraceRecord['query_processing']) {
    this.record.query_processing = info;
  }

  /** 记录意图识别结果 */
  setIntent(intent: TraceRecord['intent']) {
    this.record.intent = intent;
  }

  /** 记录路由决策 */
  setRoute(route: TraceRecord['route']) {
    this.record.route = route;
  }

  /** 完成追踪并返回完整记录 */
  finish(response: TraceRecord['response'], error?: Error): TraceRecord {
    const record: TraceRecord = {
      ...this.record as TraceRecord,
      spans: this.spans,
      response,
      total_duration_ms: Date.now() - this.startTime
    };

    if (error) {
      record.error = {
        message: error.message,
        stack: error.stack
      };
    }

    return record;
  }

  /** 截断过大的数据 */
  private truncateData(data: unknown, maxLength: number = 500): unknown {
    if (data === null || data === undefined) return data;

    const str = JSON.stringify(data);
    if (str.length <= maxLength) return data;

    if (typeof data === 'string') {
      return data.slice(0, maxLength) + '...[truncated]';
    }

    if (Array.isArray(data)) {
      return {
        _truncated: true,
        length: data.length,
        sample: data.slice(0, 3)
      };
    }

    return {
      _truncated: true,
      preview: str.slice(0, maxLength) + '...'
    };
  }

  /** 生成输出摘要 */
  private summarizeOutput(output: unknown): TraceSpan['output_summary'] {
    if (output === null || output === undefined) {
      return { type: 'null' };
    }

    if (Array.isArray(output)) {
      return {
        type: 'array',
        count: output.length,
        preview: output.length > 0 ? JSON.stringify(output[0]).slice(0, 100) : undefined
      };
    }

    if (typeof output === 'object') {
      const obj = output as Record<string, unknown>;

      // 检查常见的结果结构
      if ('results' in obj && Array.isArray(obj.results)) {
        return {
          type: 'search_result',
          count: (obj.results as unknown[]).length,
          preview: (obj.results as unknown[]).length > 0
            ? JSON.stringify((obj.results as unknown[])[0]).slice(0, 100)
            : undefined
        };
      }

      return {
        type: 'object',
        preview: JSON.stringify(output).slice(0, 100)
      };
    }

    return {
      type: typeof output,
      preview: String(output).slice(0, 100)
    };
  }

  /** 清理敏感参数 */
  private sanitizeArgs(args: unknown): unknown {
    if (typeof args !== 'object' || args === null) return args;

    const sanitized = { ...args as Record<string, unknown> };
    // 可以在这里过滤敏感字段
    return sanitized;
  }
}

/** 追踪日志记录器 */
export class TraceLogger {
  private static enabled = TraceLogger.resolveEnabled();
  private static logPath = TraceLogger.resolveLogPath();
  private static dirReady = false;

  /** 创建新的追踪上下文 */
  static createContext(toolName: string, args: unknown, sessionId?: string): TraceContext {
    return new TraceContext(toolName, args, sessionId);
  }

  /** 记录完整的追踪记录 */
  static log(record: TraceRecord) {
    if (!TraceLogger.enabled) return;

    const line = JSON.stringify(record);

    if (TraceLogger.logPath) {
      TraceLogger.ensureDir();
      fs.appendFileSync(TraceLogger.logPath, `${line}\n`);
      return;
    }

    console.error(line);
  }

  /** 便捷方法：追踪函数调用 */
  static async traceAsync<T>(
    ctx: TraceContext,
    name: string,
    input: unknown,
    fn: () => Promise<T>
  ): Promise<T> {
    const spanId = ctx.startSpan(name, input);
    try {
      const result = await fn();
      ctx.endSpan(spanId, result);
      return result;
    } catch (error) {
      ctx.spanError(spanId, error as Error);
      throw error;
    }
  }

  /** 便捷方法：追踪同步函数调用 */
  static trace<T>(
    ctx: TraceContext,
    name: string,
    input: unknown,
    fn: () => T
  ): T {
    const spanId = ctx.startSpan(name, input);
    try {
      const result = fn();
      ctx.endSpan(spanId, result);
      return result;
    } catch (error) {
      ctx.spanError(spanId, error as Error);
      throw error;
    }
  }

  private static resolveEnabled(): boolean {
    const value = process.env.EASEIM_TRACE_LOG;
    // 默认开启
    if (!value) return true;
    return !['0', 'false', 'no', 'off'].includes(value.toLowerCase());
  }

  private static resolveLogPath(): string {
    return process.env.EASEIM_TRACE_LOG_PATH || '/tmp/easeim_trace.log';
  }

  private static ensureDir() {
    if (TraceLogger.dirReady || !TraceLogger.logPath) return;
    const dir = path.dirname(TraceLogger.logPath);
    fs.mkdirSync(dir, { recursive: true });
    TraceLogger.dirReady = true;
  }
}
