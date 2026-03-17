/**
 * 平台规范化工具
 * - 统一平台别名（如 react-native/reactnative -> rn）
 * - 为工具 schema 提供统一的平台可选值
 */

const PLATFORM_ALIAS_CONFIG = {
  ios: ['ios'],
  android: ['android'],
  web: ['web'],
  flutter: ['flutter'],
  unity: ['unity'],
  rn: ['rn', 'react-native', 'reactnative'],
  harmony: ['harmony'],
  windows: ['windows'],
} as const;

export type CanonicalPlatform = keyof typeof PLATFORM_ALIAS_CONFIG;

const PLATFORM_ALIAS_LOOKUP = new Map<string, CanonicalPlatform>();

for (const [canonical, aliases] of Object.entries(PLATFORM_ALIAS_CONFIG) as Array<[CanonicalPlatform, readonly string[]]>) {
  for (const alias of aliases) {
    PLATFORM_ALIAS_LOOKUP.set(alias.toLowerCase(), canonical);
  }
}

export const PLATFORM_INPUT_VALUES = Object.values(PLATFORM_ALIAS_CONFIG).flat();

/**
 * 将平台值规范化为系统内部使用的 canonical 值
 */
export function normalizePlatform(platform: string): CanonicalPlatform | string {
  const normalized = platform.trim().toLowerCase();
  return PLATFORM_ALIAS_LOOKUP.get(normalized) || normalized;
}

/**
 * 规范化参数对象中的 platform 字段（如存在）
 */
export function normalizePlatformInArgs<T>(args: T): T {
  if (!args || typeof args !== 'object' || Array.isArray(args)) {
    return args;
  }

  const record = args as Record<string, unknown>;
  if (typeof record.platform !== 'string') {
    return args;
  }

  const normalizedPlatform = normalizePlatform(record.platform);
  if (normalizedPlatform === record.platform) {
    return args;
  }

  return { ...record, platform: normalizedPlatform } as T;
}
