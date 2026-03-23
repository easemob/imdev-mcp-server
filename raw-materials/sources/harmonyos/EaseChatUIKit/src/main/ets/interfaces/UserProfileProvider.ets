import { ChatGroupProfile } from '../model/ChatGroupProfile';
import { ChatUserProfile } from '../model/ChatUserProfile';

/**
 * 用户信息提供者
 */
export interface ProfileProvider {

  /**
   * 获取用户信息。
   * @param { string | string[] | undefined } userId - 用户ID
   * @param { string | undefined } groupId - 群组ID
   * @returns { Promise<ChatUserProfile | ChatUserProfile[] | ChatGroupProfile> } - 返回用户信息或者群组。
   */
  fetchProfile: (userId?: string | string[], groupId?: string) => Promise<ChatUserProfile | ChatUserProfile[] | ChatGroupProfile>;
}