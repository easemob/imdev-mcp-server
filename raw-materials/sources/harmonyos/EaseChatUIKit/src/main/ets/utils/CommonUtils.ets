import uikit from '../internal/ChatUIKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ChatLog } from '../../../../Index';
import { JSON } from '@kit.ArkTS';

export function getString(resource: Resource, arg?: string | number): string {
  try {
    if (arg != undefined) {
      return getContext().resourceManager.getStringSync(resource, arg);
    }
    return getContext().resourceManager.getStringSync(resource);
  } catch (e) {
    let code = (e as BusinessError).code;
    let message = (e as BusinessError).message;
    ChatLog.d('getString failed: error code: '+code+', message: '+message);
  }
  return '';
}

export function getNumber(resource: Resource): number {
  try {
    return getContext().resourceManager.getNumber(resource);
  } catch (error) {
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    ChatLog.d(`getNumber failed, error code: ${code}, message: ${message}.`);
  }
  return 0;
}

/**
 * 对key拼接前缀。
 * @param key
 * @param userId
 * @returns
 */
export function appendFlag(key: string, userId?: string): string {
  let prefix: string = '';
  if (!userId) {
    prefix = uikit.sdk.getCurrentUser();
  } else {
    prefix = userId;
  }
  return prefix + '_' + key;
}

/**
 * 解析 JSON 字符串，并排除 '{}' 和 '[]' 这两种情况。
 * @param json
 * @returns {Object | null}
 */
export function parseJson(json?: string) {
  if (!json) {
    return null;
  }
  if (typeof json === 'object') {
    return json;
  }
  let result = JSON.parse(json);
  if (JSON.stringify(result) === '{}' || JSON.stringify(result) === '[]') {
    return null;
  }
  return result;
}