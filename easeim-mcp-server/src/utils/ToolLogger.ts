import * as fs from 'fs';
import * as path from 'path';
import { randomUUID } from 'crypto';

export type ToolLogEntry = {
  log_version: 'v1';
  timestamp: string;
  request_id: string;
  session_id?: string;
  tool: {
    name: string;
    args: unknown;
  };
  response: {
    type: 'success' | 'error';
    content_length?: number;
    category?: 'answer' | 'clarification' | 'no_result';
    has_no_result_cue?: boolean;
    has_clarification_cue?: boolean;
    direct_no_result?: boolean;
    evidence_count?: number;
    preview?: string;
  };
  timing_ms: {
    total: number;
  };
  error?: {
    message: string;
  };
};

export class ToolLogger {
  private static enabled = ToolLogger.resolveEnabled();
  private static logPath = ToolLogger.resolveLogPath();
  private static dirReady = false;

  static newRequestId(): string {
    return randomUUID();
  }

  static log(entry: ToolLogEntry) {
    if (!ToolLogger.enabled) return;
    const line = JSON.stringify(entry);

    if (ToolLogger.logPath) {
      ToolLogger.ensureDir();
      fs.appendFileSync(ToolLogger.logPath, `${line}\n`);
      return;
    }

    console.error(line);
  }

  private static resolveEnabled(): boolean {
    const value = process.env.EASEIM_TOOL_LOG;
    // 默认开启，除非显式设置为 0/false/no/off
    if (!value) return true;
    return !['0', 'false', 'no', 'off'].includes(value.toLowerCase());
  }

  private static resolveLogPath(): string {
    return process.env.EASEIM_TOOL_LOG_PATH || '/tmp/tool.log';
  }

  private static ensureDir() {
    if (ToolLogger.dirReady || !ToolLogger.logPath) return;
    const dir = path.dirname(ToolLogger.logPath);
    fs.mkdirSync(dir, { recursive: true });
    ToolLogger.dirReady = true;
  }
}
