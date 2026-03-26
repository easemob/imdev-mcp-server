/**
 * 配置搜索引擎
 * 提供配置项和扩展点的查询功能
 */

import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';
import type { ConfigIndex, ComponentConfig, ConfigProperty, ExtensionPoint, UIKitComponent } from '../types/index.js';
import { normalizePlatform } from '../utils/platform.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

interface Usage {
  file: string;
  line: number;
  context: string;
  component: string;
}

interface ConfigImpact {
  property: ConfigProperty;
  usageCount: number;
  usages: Usage[];
  affectedComponents: string[];
  category: string;
  summary: string;
}

interface ImpactAnalysis {
  version: string;
  generatedAt: string;
  totalConfigs: number;
  byComponent: Record<string, ConfigImpact[]>;
  byCategory: Record<string, ConfigImpact[]>;
}

export class ConfigSearch {
  private index: ConfigIndex | null = null;
  private indexPath: string;
  private impactAnalysis: ImpactAnalysis | null = null;
  private impactAnalysisPath: string;

  constructor() {
    this.indexPath = path.join(__dirname, '../../data/configs/index.json');
    this.impactAnalysisPath = path.join(__dirname, '../../data/configs/impact-analysis.json');
  }

  /**
   * 加载索引文件
   */
  private loadIndex(): ConfigIndex {
    if (this.index) {
      return this.index;
    }

    try {
      const content = fs.readFileSync(this.indexPath, 'utf-8');
      this.index = JSON.parse(content);
      return this.index!;
    } catch (error) {
      throw new Error(`Failed to load config index: ${error}`);
    }
  }

  /**
   * 加载影响分析数据
   */
  private loadImpactAnalysis(): ImpactAnalysis {
    if (this.impactAnalysis) {
      return this.impactAnalysis;
    }

    try {
      const content = fs.readFileSync(this.impactAnalysisPath, 'utf-8');
      this.impactAnalysis = JSON.parse(content);
      return this.impactAnalysis!;
    } catch (error) {
      throw new Error(`Failed to load impact analysis: ${error}`);
    }
  }

  /**
   * 列出配置项
   * @param component 组件名称或 'all'
   * @param platform 平台名称（如 ios, android, web, flutter, rn, harmony）
   */
  listConfigOptions(component: UIKitComponent | 'all', platform?: string): Record<string, ConfigProperty[]> {
    const index = this.loadIndex();
    const result: Record<string, ConfigProperty[]> = {};
    const normalizedPlatform = platform ? normalizePlatform(platform) : undefined;

    if (component === 'all') {
      // 返回所有组件的配置，按平台过滤
      for (const [compKey, compConfig] of Object.entries(index.components)) {
        // compKey 格式: "platform/Component"
        const keyPlatform = compKey.split('/')[0];
        const normalizedKeyPlatform = normalizePlatform(keyPlatform);

        // 如果指定了平台，只返回匹配的组件
        if (normalizedPlatform && normalizedKeyPlatform !== normalizedPlatform) {
          continue;
        }

        if (compConfig.configProperties.length > 0) {
          result[compKey] = compConfig.configProperties;
        }
      }
    } else {
      // 返回指定组件的配置
      // 构建查找键：如果指定了平台，使用 "platform/component" 格式
      const lookupKey = normalizedPlatform ? `${normalizedPlatform}/${component}` : component;
      const compConfig = index.components[lookupKey];

      if (compConfig && compConfig.configProperties.length > 0) {
        result[lookupKey] = compConfig.configProperties;
      } else if (!normalizedPlatform) {
        // 未指定平台时，搜索所有平台的该组件
        for (const [compKey, config] of Object.entries(index.components)) {
          if (compKey.endsWith(`/${component}`) && config.configProperties.length > 0) {
            result[compKey] = config.configProperties;
          }
        }
      }
    }

    return result;
  }

  /**
   * 获取扩展点
   * @param component 组件名称或 'all'
   * @param type 扩展点类型
   * @param platform 平台名称（如 ios, android, web, flutter, rn, harmony）
   */
  getExtensionPoints(
    component: UIKitComponent | 'all',
    type: 'protocol' | 'class' | 'all' = 'all',
    platform?: string
  ): Record<string, ExtensionPoint[]> {
    const index = this.loadIndex();
    const result: Record<string, ExtensionPoint[]> = {};
    const normalizedPlatform = platform ? normalizePlatform(platform) : undefined;

    let components: [string, ComponentConfig][];

    if (component === 'all') {
      // 按平台过滤所有组件
      components = Object.entries(index.components).filter(([compKey]) => {
        if (!normalizedPlatform) return true;
        const keyPlatform = compKey.split('/')[0];
        return normalizePlatform(keyPlatform) === normalizedPlatform;
      });
    } else {
      // 指定组件：使用 "platform/component" 格式查找
      const lookupKey = normalizedPlatform ? `${normalizedPlatform}/${component}` : component;
      const compConfig = index.components[lookupKey];

      if (compConfig) {
        components = [[lookupKey, compConfig]];
      } else if (!normalizedPlatform) {
        // 未指定平台时，搜索所有平台的该组件
        components = Object.entries(index.components).filter(([compKey]) =>
          compKey.endsWith(`/${component}`)
        );
      } else {
        components = [];
      }
    }

    for (const [compKey, compConfig] of components) {
      if (!compConfig) continue;

      let extensionPoints = compConfig.extensionPoints;

      // 按类型过滤
      if (type !== 'all') {
        extensionPoints = extensionPoints.filter((e: ExtensionPoint) => e.type === type);
      }

      if (extensionPoints.length > 0) {
        result[compKey] = extensionPoints;
      }
    }

    return result;
  }

  /**
   * 获取组件信息
   */
  getComponentInfo(component: UIKitComponent): ComponentConfig | null {
    const index = this.loadIndex();
    return index.components[component] || null;
  }

  /**
   * 获取所有组件列表
   */
  getAllComponents(): ComponentConfig[] {
    const index = this.loadIndex();
    return Object.values(index.components);
  }

  /**
   * 搜索配置项
   */
  searchConfigProperty(query: string): Record<string, ConfigProperty[]> {
    const index = this.loadIndex();
    const result: Record<string, ConfigProperty[]> = {};
    const lowerQuery = query.toLowerCase();

    for (const [compName, compConfig] of Object.entries(index.components)) {
      const matched = compConfig.configProperties.filter(prop => {
        return (
          prop.name.toLowerCase().includes(lowerQuery) ||
          prop.type.toLowerCase().includes(lowerQuery) ||
          prop.description?.toLowerCase().includes(lowerQuery)
        );
      });

      if (matched.length > 0) {
        result[compName] = matched;
      }
    }

    return result;
  }

  /**
   * 搜索扩展点
   */
  searchExtensionPoint(query: string): Record<string, ExtensionPoint[]> {
    const index = this.loadIndex();
    const result: Record<string, ExtensionPoint[]> = {};
    const lowerQuery = query.toLowerCase();

    for (const [compName, compConfig] of Object.entries(index.components)) {
      const matched = compConfig.extensionPoints.filter(point => {
        return (
          point.name.toLowerCase().includes(lowerQuery) ||
          point.description?.toLowerCase().includes(lowerQuery) ||
          point.methods?.some(m => m.toLowerCase().includes(lowerQuery))
        );
      });

      if (matched.length > 0) {
        result[compName] = matched;
      }
    }

    return result;
  }

  /**
   * 获取配置项的使用情况
   * @param propertyName 配置项名称
   * @param component 组件名称或 'all'
   * @param platform 平台名称（如 ios, android, web, flutter, rn, harmony）
   */
  getConfigUsage(propertyName: string, component: UIKitComponent | 'all' = 'all', platform?: string): ConfigImpact | null {
    const analysis = this.loadImpactAnalysis();
    const normalizedPlatform = platform ? normalizePlatform(platform) : undefined;

    // 如果指定了组件
    if (component !== 'all') {
      // 构建查找键：使用 "platform/component" 格式
      const lookupKey = normalizedPlatform ? `${normalizedPlatform}/${component}` : component;
      let componentImpacts = analysis.byComponent[lookupKey];

      if (componentImpacts) {
        const impact = componentImpacts.find(i => i.property.name === propertyName);
        return impact || null;
      }

      // 未指定平台时，搜索所有平台的该组件
      if (!normalizedPlatform) {
        for (const [compKey, impacts] of Object.entries(analysis.byComponent)) {
          if (compKey.endsWith(`/${component}`)) {
            const impact = impacts.find(i => i.property.name === propertyName);
            if (impact) {
              return impact;
            }
          }
        }
      }

      return null;
    }

    // 搜索所有组件，按平台过滤
    for (const [compKey, impacts] of Object.entries(analysis.byComponent)) {
      // 按平台过滤
      if (normalizedPlatform) {
        const keyPlatform = compKey.split('/')[0];
        if (normalizePlatform(keyPlatform) !== normalizedPlatform) {
          continue;
        }
      }

      const impact = impacts.find(i => i.property.name === propertyName);
      if (impact) {
        return impact;
      }
    }

    return null;
  }

  /**
   * 获取配置项类别
   */
  getConfigCategory(propertyName: string): string | null {
    const analysis = this.loadImpactAnalysis();

    for (const [compName, impacts] of Object.entries(analysis.byComponent)) {
      const impact = impacts.find(i => i.property.name === propertyName);
      if (impact) {
        return impact.category;
      }
    }

    return null;
  }
}
