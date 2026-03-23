import { ChatError } from '@easemob/chatsdk';
import { ChatGroupProfile } from '../../model/ChatGroupProfile';
import uikit from '../ChatUIKit';

export class ChatGroupInfoManager {
  /**
   * key为groupId，value为群组属性
   */
  private infoMap: Map<string, ChatGroupProfile> = new Map();

  /**
   * 从缓存中获取群组信息。
   * @param groupId
   * @returns
   */
  getGroupInfoFromCache(groupId: string): ChatGroupProfile | undefined {
    if (this.infoMap.has(groupId)) {
      return this.infoMap.get(groupId);
    }
    return undefined;
  }

  /**
   * 更新本地群组缓存
   * @param groupInfo
   */
  refreshGroupInfoCache(groupInfo: ChatGroupProfile | ChatGroupProfile[]) {
    if (groupInfo instanceof ChatGroupProfile) {
      this.infoMap.set(groupInfo.id, groupInfo);
    } else {
      groupInfo.forEach(item => {
        this.infoMap.set(item.id, item);
      })
    }
  }

  /**
   * 从provider中获取群组信息。
   * @param groupId
   * @returns
   */
  async getGroupInfo(groupId: string): Promise<ChatGroupProfile> {
    let provider = uikit.profileProvider;
    if (provider) {
      let profile = await provider.fetchProfile(undefined, groupId) as ChatGroupProfile
      if (profile && profile instanceof ChatGroupProfile && profile.id === groupId) {
        this.refreshGroupInfoCache(profile);
        return profile
      }
    }
    return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'Not found group info from provider.'));
  }
}

export const groupInfoManager = new ChatGroupInfoManager();