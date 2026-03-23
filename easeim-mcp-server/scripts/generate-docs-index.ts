#!/usr/bin/env node
/**
 * 生成文档索引脚本 (v3 - 平台优先架构)
 * 扫描 raw-materials/docs/<platform>/ 下的各类文档
 */

import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PROJECT_ROOT = path.resolve(__dirname, '../..');
const RAW_DOCS_DIR = path.join(PROJECT_ROOT, 'raw-materials/docs');
const OUTPUT_DIR = path.join(__dirname, '../data/docs');
const OUTPUT_FILE = path.join(OUTPUT_DIR, 'index.json');

type Platform = 'ios' | 'android' | 'web' | 'flutter' | 'unity' | 'rn' | 'harmony' | 'windows' | 'all' | 'unknown';
type Product = 'sdk' | 'chatuikit' | 'callkit' | 'chatroomuikit' | 'imkit' | 'general';

interface GuideDoc {
  id: string;
  title: string;
  path: string; 
  platform: Platform;
  product: Product;
  keywords: string[];
  description: string;
}

interface ApiModule {
  id: string;
  name: string;
  description: string;
  docPath: string;
  platform: Platform;
  product: Product;
  keywords: string[];
}

interface DocsIndex {
  version: string;
  lastUpdated: string;
  platforms: Platform[];
  guides: GuideDoc[];
  apiModules: ApiModule[];
  errorCodeIndex: Record<string, any>;
}

function walkDir(dir: string, baseDir: string): string[] {
  let results: string[] = [];
  if (!fs.existsSync(dir)) return [];
  const list = fs.readdirSync(dir);
  for (const file of list) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat && stat.isDirectory()) {
      results = results.concat(walkDir(filePath, baseDir));
    } else if (file.endsWith('.md')) {
      results.push(path.relative(baseDir, filePath));
    }
  }
  return results;
}

function analyzeProduct(relativePath: string): Product {
  const lowerPath = relativePath.toLowerCase();
  if (lowerPath.includes('callkit')) return 'callkit';
  if (lowerPath.includes('chatroomuikit')) return 'chatroomuikit';
  if (lowerPath.includes('chatuikit') || lowerPath.includes('uikit')) return 'chatuikit';
  if (lowerPath.includes('imkit')) return 'imkit';
  if (lowerPath.includes('sdk')) return 'sdk';
  return 'general';
}

function normalizePlatformName(rawPlatform: string): Platform {
  const normalized = rawPlatform.trim().toLowerCase();
  if (normalized === 'react-native' || normalized === 'reactnative') return 'rn';
  if (normalized === 'harmonyos' || normalized === 'ohos') return 'harmony';
  if (normalized === 'ios' || normalized === 'android' || normalized === 'web' || normalized === 'flutter' || normalized === 'unity' || normalized === 'rn' || normalized === 'windows') {
    return normalized;
  }
  return 'unknown';
}

function splitTokens(text: string): string[] {
  return text
    .replace(/([a-z])([A-Z])/g, '$1 $2')
    .split(/[^a-zA-Z0-9\u4e00-\u9fa5]+/)
    .map(token => token.trim().toLowerCase())
    .filter(token => token.length > 1);
}

function buildDocKeywords(platform: Platform, product: Product, title: string, relativePath: string): string[] {
  const fromPath = relativePath.split('/').flatMap(segment => splitTokens(segment));
  const fromTitle = splitTokens(title);
  return Array.from(new Set([
    platform,
    product,
    ...fromPath,
    ...fromTitle
  ]));
}

function extractMeta(content: string) {
  const lines = content.split('\n');
  let title = '';
  let description = '';

  for (const line of lines) {
    const trimmed = line.trim();
    if (!title && trimmed.startsWith('# ')) {
      title = trimmed.replace(/^#\s+/, '');
    } else if (title && trimmed && !trimmed.startsWith('#') && !trimmed.startsWith('<')) {
      description = trimmed;
      break;
    }
  }
  return { title, description };
}

/**
 * 解析错误码 Markdown 表格
 */
function parseErrorCodes(content: string): Record<string, any> {
  const errorCodeIndex: Record<string, any> = {};
  const lines = content.split('\n');
  let inTable = false;

  for (const line of lines) {
    const trimmed = line.trim();

    // 跳过表头和分隔行
    if (trimmed.startsWith('| 错误码') || trimmed.startsWith('| :-')) {
      inTable = true;
      continue;
    }

    if (!inTable || !trimmed.startsWith('|')) continue;

    // 解析表格行: | 错误码 | 错误信息 | 描述和可能原因 | 解决方法 |
    const cells = trimmed.split('|').map(c => c.trim()).filter(Boolean);
    if (cells.length < 4) continue;

    const codeStr = cells[0].replace(/<[^>]+>/g, '').trim();
    const code = parseInt(codeStr);
    if (isNaN(code)) continue;

    const name = cells[1].trim();
    const description = cells[2].replace(/<br\/?>/g, '\n').trim();
    const solution = cells[3].replace(/<br\/?>/g, '\n').trim();

    // 从描述中提取可能的原因
    const causes: string[] = [];
    const descParts = description.split(/[：:]/);
    if (descParts.length > 1) {
      causes.push(descParts[0].trim());
    }

    errorCodeIndex[code.toString()] = {
      code,
      name,
      brief: descParts[0].trim(),
      description,
      causes,
      solutions: solution ? [solution] : []
    };
  }

  return errorCodeIndex;
}

function main() {
  console.log('🚀 开始生成文档索引 (平台优先版)...\n');

  if (!fs.existsSync(RAW_DOCS_DIR)) {
    console.error('❌ 目录不存在');
    return;
  }

  const platforms = fs.readdirSync(RAW_DOCS_DIR).filter(d => fs.statSync(path.join(RAW_DOCS_DIR, d)).isDirectory());
  const normalizedPlatforms = new Set<Platform>();

  const guides: GuideDoc[] = [];
  const apiModules: ApiModule[] = [];
  let errorCodeIndex: Record<string, any> = {};

  for (const platform of platforms) {
    const platformPath = path.join(RAW_DOCS_DIR, platform);
    const normalizedPlatform = normalizePlatformName(platform);
    normalizedPlatforms.add(normalizedPlatform);
    console.log(`🌐 处理平台: ${platform}`);

    // 1. 处理指南 (guides)
    const guidesDir = path.join(platformPath, 'guides');
    const guideFiles = walkDir(guidesDir, platformPath);
    for (const file of guideFiles) {
      const content = fs.readFileSync(path.join(platformPath, file), 'utf-8');
      const { title, description } = extractMeta(content);
      const product = analyzeProduct(file);
      guides.push({
        id: `${normalizedPlatform}_${file.replace(/\.md$/, '').replace(/\//g, '_')}`,
        title: title || path.basename(file),
        path: `${platform}/${file}`,
        platform: normalizedPlatform,
        product,
        keywords: buildDocKeywords(normalizedPlatform, product, title || path.basename(file), file),
        description: description || ''
      });
    }

    // 2. 处理 API (api)
    const apiDir = path.join(platformPath, 'api');
    const apiFiles = walkDir(apiDir, platformPath);
    for (const file of apiFiles) {
      const content = fs.readFileSync(path.join(platformPath, file), 'utf-8');
      const { title, description } = extractMeta(content);
      const product = analyzeProduct(file);
      apiModules.push({
        id: `${normalizedPlatform}_${file.replace(/\.md$/, '').replace(/\//g, '_')}`,
        name: title || path.basename(file),
        description: description || '',
        docPath: `${platform}/${file}`,
        platform: normalizedPlatform,
        product,
        keywords: buildDocKeywords(normalizedPlatform, product, title || path.basename(file), file)
      });
    }

    // 3. 处理错误码 (errors)
    const errorsDir = path.join(platformPath, 'errors');
    const errorFiles = walkDir(errorsDir, platformPath);
    for (const file of errorFiles) {
      if (file.includes('error')) {
        const content = fs.readFileSync(path.join(platformPath, file), 'utf-8');
        const parsedErrors = parseErrorCodes(content);
        // 合并错误码（后面的会覆盖前面的）
        errorCodeIndex = { ...errorCodeIndex, ...parsedErrors };
        console.log(`   📋 解析错误码: ${Object.keys(parsedErrors).length} 个`);
      }
    }
  }

  // 3. 同步文件到 data/docs
  console.log('\n📄 同步文档文件...');
  if (!fs.existsSync(OUTPUT_DIR)) fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  
  function recursiveCopy(src: string, dest: string) {
    if (!fs.existsSync(src)) return;
    const stat = fs.statSync(src);
    if (stat.isDirectory()) {
      if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
      fs.readdirSync(src).forEach(child => recursiveCopy(path.join(src, child), path.join(dest, child)));
    } else {
      fs.copyFileSync(src, dest);
    }
  }
  
  platforms.forEach(p => recursiveCopy(path.join(RAW_DOCS_DIR, p), path.join(OUTPUT_DIR, p)));

  const index: DocsIndex = {
    version: '3.0.0',
    lastUpdated: new Date().toISOString(),
    platforms: Array.from(normalizedPlatforms),
    guides,
    apiModules,
    errorCodeIndex
  };

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(index, null, 2));
  console.log(`\n📝 索引已生成: ${OUTPUT_FILE}`);
  console.log(`   错误码总数: ${Object.keys(errorCodeIndex).length}`);
  console.log('✅ 文档架构升级完成！');
}

main();
