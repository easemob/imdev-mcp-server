import { ClassRegistry } from './ClassRegistry.js';

export interface ScenarioSolution {
  id: string;
  scenario: string;
  description: string;
  keywords: string[];
  steps: string[];
  relatedClasses: string[];
  relatedApis: string[];
  relatedConfigs: string[];
  codeTemplate: string;
  tips: string[];
  difficulty: 'easy' | 'medium' | 'hard';
}

export interface ClassInfo {
  name: string;
  description: string;
  superclass: string | null;
  protocols: string[];
  isOpen: boolean;
  file: string;
  keyMethods: string[];
  keyProperties: string[];
  usageScenarios: string[];
}

export interface RelatedItems {
  classes: string[];
  apis: string[];
  configs: string[];
  guides: string[];
  scenarios: string[];
}

export class KnowledgeGraph {
  private classRegistry: ClassRegistry;

  constructor() {
    this.classRegistry = new ClassRegistry();
  }

  /**
   * 检查指定平台是否有知识图谱数据
   * @param platform 平台名称
   * @returns 是否有数据
   */
  hasPlatformData(platform: string): boolean {
    return this.classRegistry.hasPlatformData(platform);
  }

  /**
   * 获取支持的平台列表（有知识图谱数据的平台）
   */
  getSupportedPlatforms(): string[] {
    return this.classRegistry.getSupportedPlatforms();
  }

  /**
   * 获取类信息
   * @param className 类名
   * @param platform 平台名称（可选）
   * @returns 类信息，如果平台无数据则返回 null
   */
  getClassInfo(className: string, platform?: string): ClassInfo | null {
    // 如果指定了平台但该平台没有知识图谱数据，返回 null
    if (platform && !this.hasPlatformData(platform)) {
      return null;
    }
    return this.classRegistry.getClassInfo(className, platform);
  }

  /**
   * 获取子类列表
   * @param className 类名
   * @param platform 平台名称（可选）
   * @returns 子类列表，如果平台无数据则返回空数组
   */
  getSubclasses(className: string, platform?: string): string[] {
    if (platform && !this.hasPlatformData(platform)) {
      return [];
    }
    return this.classRegistry.getSubclasses(className, platform);
  }

  /**
   * 获取继承链
   * @param className 类名
   * @param platform 平台名称（可选）
   * @returns 继承链，如果平台无数据则返回空数组
   */
  getInheritanceChain(className: string, platform?: string): string[] {
    if (platform && !this.hasPlatformData(platform)) {
      return [];
    }
    return this.classRegistry.getInheritanceChain(className, platform);
  }
}
