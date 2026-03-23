import { ChatClient } from '@easemob/chatsdk';
import { ChatTransfer, CommonError } from './ChatTransfer';
import { createProfile, transferUserProfile } from './KitTransfer';
import { ChatUser } from './model/ChatUser';
import { ChatUIKitConfigs } from '../ChatUIKitConfigs';
import listenerWrapper from './wapper/ChatListenersWrapper';
import { ChatUIKitDefaultConfigs } from '../model/ChatConfigs';
import { ChatMessageItemProvider } from '../interfaces/ChatMessageItemProvider';
import { ChatMessageBubbleProvider } from '../interfaces/ChatMessageBubbleProvider';
import { messageProviderManager } from './manager/ChatMessageManager';
import { ConversationItemProvider } from '../interfaces/ConversationItemProvider';
import { conversationProviderManager } from './manager/ConversationItemManager';
import { mentionManager } from '../manager/GroupChatMentionManager';
import { ProfileProvider as ProfileProvider } from '../interfaces/UserProfileProvider';
import { ChatUserProfile } from '../model/ChatUserProfile';
import { ChatUserInfoManager } from './manager/ChatUserInfoManager';
import { DataPreferenceManager } from './manager/DataPreferenceManager';
import { JSON } from '@kit.ArkTS';
import { ChatGroupProfile } from '../model/ChatGroupProfile';
import { groupInfoManager } from './manager/ChatGroupInfoManager';
import { ConversationLatestMessageContentProvider } from '../interfaces/ConversationLatestMessageContentProvider';

class ChatUIKit {
  configs: ChatUIKitConfigs = new ChatUIKitDefaultConfigs();
  user: ChatUser = new ChatUser('');
  private isInit = false;
  declare sdk: ChatClient;
  profileProvider?: ProfileProvider;

  init(chatClient: ChatClient, configs?: ChatUIKitConfigs): void {
    this.sdk = chatClient;
    if (configs) {
      this.configs = configs;
    }
    listenerWrapper.register();
    this.isInit = true;
    this.sdk.isAutoLogin().then((isAutoLogin) => {
      if (isAutoLogin) {
        mentionManager.getAtMapFromDP();
        let userJson = DataPreferenceManager.getInstance().getSync(ChatUserInfoManager.getInstance().getCurrentUserKeyInDP(), '') as string;
        if (userJson) {
          let user = JSON.parse(userJson) as ChatUser;
          if (user) {
            this.setCurrentUser(user);
          }
        } else {
          let user = ChatUserInfoManager.getInstance().getUserProfileFromCache(uikit.sdk.getCurrentUser()) ?? new ChatUser(uikit.sdk.getCurrentUser());
          this.setCurrentUser(user);
        }
      }
    })
  }

  async loginWithPassword(userId: string, password: string): Promise<void> {
    try {
      userId = userId.toLowerCase();
      await ChatClient.getInstance().login(userId, password);
      this.setCurrentUser(createProfile(userId));
      mentionManager.getAtMapFromDP();
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, "loginWithPassword"));
    }
  }

  async login(userId: string, token: string): Promise<void> {
    try {
      userId = userId.toLowerCase();
      await ChatClient.getInstance().loginWithToken(userId, token);
      this.setCurrentUser(createProfile(userId));
      mentionManager.getAtMapFromDP();
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, "login"));
    }
  }

  async logout(unbindDeviceToken: boolean = true): Promise<void> {
    try {
      await ChatClient.getInstance().logout(unbindDeviceToken);
      this.clear();
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, "logout"));
    }
  }

  isInited(): boolean {
    return this.isInit;
  }

  setMessageItemProvider(messageItemProvider: ChatMessageItemProvider | ChatMessageBubbleProvider) {
    messageProviderManager.addMessageItemProvider(messageItemProvider);
  }

  setConversationItemProvider(itemProvider: ConversationItemProvider) {
    conversationProviderManager.addConversationItemProvider(itemProvider);
  }

  setConversationLatestMessageContentProvider(contentProvider: ConversationLatestMessageContentProvider) {
    messageProviderManager.setConversationLatestMessageContentProvider(contentProvider);
  }

  setProfileProvider(provider: ProfileProvider) {
    this.profileProvider = provider;
  }

  setCurrentUser(user: ChatUserProfile | ChatUser) {
    let current: ChatUser;
    if (user instanceof ChatUser) {
      current = user;
    } else {
      current = transferUserProfile(user);
    }
    this.user = current;
    // 将当前用户信息保存到DataPreference中
    DataPreferenceManager.getInstance().putSync(ChatUserInfoManager.getInstance().getCurrentUserKeyInDP(), JSON.stringify(this.user));
    ChatUserInfoManager.getInstance().updateUser(this.user);
  }

  updateUserProfiles(users: ChatUserProfile[] | ChatGroupProfile[]) {
    if (users.length > 0) {
      let user = users[0];
      if (user instanceof ChatUserProfile) {
        ChatUserInfoManager.getInstance().updateUserInfos(users);
      } else {
        groupInfoManager.refreshGroupInfoCache(users)
      }
    }

  }

  private clear() {
    listenerWrapper.clear();
    mentionManager.removeAll();
  }

}

const uikit = new ChatUIKit();
export default uikit;