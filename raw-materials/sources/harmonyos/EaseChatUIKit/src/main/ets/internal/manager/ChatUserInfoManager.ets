import { ChatMessage } from '@easemob/chatsdk';
import { KitConstants } from '../../constants/KitConstants';
import uikit from '../ChatUIKit';
import { transferUserProfile } from '../KitTransfer';
import { ChatUser } from '../model/ChatUser';
import { ChatKitContact } from '../../model/ChatKitContact';
import { ChatUserProfile } from '../../model/ChatUserProfile';
import { ContactModel } from '../../model/ContactModel';
import { appendFlag } from '../../utils/CommonUtils';
import { EventBus, getEventStr } from '../../utils/EventBus';
import { getUserCardInfo, getUserInfoFromMessage } from '../../utils/MessageUtil';

/**
 * 用户信息管理
 */
export class ChatUserInfoManager {
  private static instance: ChatUserInfoManager | undefined;
  private static readonly currentUserKey = "current_user_key";
  private userInfos: Map<string, ChatUser> = new Map();
  private groupUserInfos: Map<string, Map<string, ChatUser>> = new Map();

  private constructor() {}

  static getInstance() {
    if (!ChatUserInfoManager.instance) {
      ChatUserInfoManager.instance = new ChatUserInfoManager();
    }
    return ChatUserInfoManager.instance;
  }

  getCurrentUserKeyInDP(): string {
    return appendFlag(ChatUserInfoManager.currentUserKey);
  }

  getCurrentUser(): ChatUser {
    let user = uikit.user;
    if (user.userId) {
      return user;
    }
    user = this.getUserProfileFromCache(uikit.sdk.getCurrentUser()) ?? new ChatUser(uikit.sdk.getCurrentUser());
    return user;
  }

  getNickname(contact: string | ChatUserProfile | ChatUser | ContactModel | ChatKitContact | ChatMessage) {
    if (typeof contact === 'string') {
      return this.getUserInfo(contact).getNickname();
    } else if (contact instanceof ChatUserProfile) {
      return contact.id;
    } else if (contact instanceof ChatUser) {
      if (!contact.nickname) {
        return contact.userId;
      }
      return contact.nickname;
    } else if (contact instanceof ContactModel) {
      if (!contact.nickname) {
        return contact.id;
      }
      return contact.nickname;
    } else if (contact instanceof ChatKitContact) {
      if (!contact.nickname) {
        return contact.id;
      }
      return contact.nickname;
    } else {
      return this.getUserInfo(contact).getNickname();
    }
  }

  getAvatar(message: ChatMessage | string): ResourceStr {
    let user = this.getUserInfo(message);
    return user.avatar ?? $r('app.media.avatar_default');
  }

  getUserCardNickname(message: ChatMessage) {
    let user = getUserCardInfo(message);
    return user?.nickname ?? (user?.uid ?? '');
  }

  getUserInfo(message: ChatMessage | string, isNeedFetch: boolean = true): ChatUser {
    let userId: string = '';
    if (message instanceof ChatMessage) {
      userId = message.getFrom();
    } else {
      userId = message;
    }
    let user = this.getUserProfileFromCache(userId);
    if (user) {
      return user;
    }
    if (message instanceof ChatMessage) {
      let user = getUserInfoFromMessage(message);
      if (user) {
        return user;
      }
      if (isNeedFetch) {
        // 异步请求，先返回包含id的用户对象。
        this.getUserProfile(userId).then(user => {
          // 请成功后，通知刷新
          EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_CONV_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION), message.getConversationId());
        });
      }
    }
    return new ChatUser(userId);
  }

  updateUser(user: ChatUser) {
    if (!this.userInfos.has(user.userId)) {
      this.userInfos.set(user.userId, user);
    }
  }

  updateUserInfos(users: ChatUserProfile[]) {
    users.forEach(item => {
      this.userInfos.set(item.id, transferUserProfile(item));
    })
  }

  getUserProfileFromCache(userId: string, groupId?: string): ChatUser | undefined {
    if (!groupId) {
      if (this.userInfos.has(userId)) {
        let user = this.userInfos.get(userId);
        if (user) {
          return user;
        }
      }
    } else {
      if (this.groupUserInfos.has(groupId)) {
        let group = this.groupUserInfos.get(groupId);
        if (group && group.has(userId)) {
          let user = group.get(userId);
          if (user) {
            return user;
          }
        }
      }
    }
    return undefined;
  }

  async getUserProfile(userId: string, groupId?: string): Promise<ChatUser> {
    let user = this.getUserProfileFromCache(userId, groupId);
    if (user) {
      return user;
    }
    let provider = uikit.profileProvider;
    if (provider) {
      let user = await provider.fetchProfile(userId, groupId);
      if (user && user instanceof ChatUserProfile && user.id === userId) {
        let chatUser = transferUserProfile(user);
        if (!groupId) {
          this.userInfos.set(userId, chatUser);
        } else {
          if (!this.groupUserInfos.has(groupId)) {
            let userInfos: Map<string, ChatUser> = new Map();
            userInfos.set(userId, chatUser);
            this.groupUserInfos.set(groupId, userInfos);
          } else {
            let userInfos = this.groupUserInfos.get(groupId);
            if (!userInfos) {
              userInfos = new Map<string, ChatUser>();
            }
            userInfos.set(userId, chatUser);
            this.groupUserInfos.set(groupId, userInfos);
          }
        }
        return transferUserProfile(user);
      }
    }
    return new ChatUser(userId);
  }

  async getUserProfiles(userIds: string[]): Promise<ChatUser[]> {
    let lastUserIds: string[] = [];
    let result: ChatUser[] = [];
    userIds.forEach(item => {
      let user = this.getUserProfileFromCache(item);
      if (!user) {
        lastUserIds.push(item);
      } else {
        result.push(user);
      }
    })
    if (lastUserIds.length === 0) {
      return [];
    }
    let provider = uikit.profileProvider;
    if (provider) {
      let users = await provider.fetchProfile(lastUserIds) as ChatUserProfile[];
      if (users && !(users instanceof ChatUserProfile)) {
        users.forEach(item => {
          if (lastUserIds.includes(item.id)) {
            let user = transferUserProfile(item);
            this.userInfos.set(item.id, user);
            result.push(user);
          }
        })
      }
    }
    return result;
  }

  /**
   * 从接收到的消息中，更新用户信息。
   * @param messages
   */
  receiveMessages(messages: ChatMessage[]) {
    messages.forEach(message => {
      let user = getUserInfoFromMessage(message);
      if (user) {
        this.userInfos.set(user.userId, user);
      }
    })
  }

}