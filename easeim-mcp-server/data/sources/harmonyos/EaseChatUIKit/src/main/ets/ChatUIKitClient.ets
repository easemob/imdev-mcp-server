import { ChatClient } from '@easemob/chatsdk';
import { ChatUIKitConfigs } from './ChatUIKitConfigs';
import { ChatMessageBubbleProvider } from './interfaces/ChatMessageBubbleProvider';
import { ChatMessageItemProvider } from './interfaces/ChatMessageItemProvider';
import { ConversationItemProvider } from './interfaces/ConversationItemProvider';
import { ConversationLatestMessageContentProvider } from './interfaces/ConversationLatestMessageContentProvider';
import { ProfileProvider } from './interfaces/UserProfileProvider';
import uikit from './internal/ChatUIKit';
import { ChatGroupProfile } from './model/ChatGroupProfile';
import { ChatUserProfile } from './model/ChatUserProfile';

export class ChatUIKitClient {

  /**
   * 初始化 ChatUIKit .
   * @param { ChatClient } chatClient - SDK 对象。
   * @param { ChatUIKitConfigs } configs - uikit 配置项。
   */
  static init(chatClient: ChatClient, configs?: ChatUIKitConfigs) {
    uikit.init(chatClient, configs);
  }

  /**
   * 登录账号，用于测试。正式环境需要调用{@link login}.
   * @param { string } userId - 登录用户 ID。
   * @param { string } password - 用户密码。
   * @returns { Promise<void> } - 返回登录的 promise 结果。
   */
  static loginWithPassword(userId: string, password: string): Promise<void> {
    return uikit.loginWithPassword(userId, password);
  }

  /**
   * 登录账号。
   * @param { string } userId - 登录用户 ID。
   * @param { string } token - 用户 token。
   * @returns { Promise<void> } - 返回登录的 promise 结果。
   */
  static login(userId: string, token: string): Promise<void> {
    return uikit.login(userId, token);
  }

  /**
   * 退出登录。
   * @param { boolean } unbindDeviceToken - 是否解绑推送。
   * @returns { Promise<void> } - 返回退出登录的 promise 结果。
   */
  static logout(unbindDeviceToken?: boolean): Promise<void> {
    return uikit.logout(unbindDeviceToken);
  }

  /**
   * 判断是否处于登录状态。
   * @returns { boolean } - 返回当前是否处于登录状态。
   */
  static isInited(): boolean {
    return uikit.isInited();
  }

  /**
   * 设置消息条目布局提供者。
   * @param messageItemProvider
   */
  static setMessageItemProvider(messageItemProvider: ChatMessageItemProvider | ChatMessageBubbleProvider) {
    uikit.setMessageItemProvider(messageItemProvider);
  }

  /**
   * 设置会话条目布局提供者
   * @param itemProvider
   */
  static setConversationItemProvider(itemProvider: ConversationItemProvider) {
    uikit.setConversationItemProvider(itemProvider);
  }

  /**
   * 设置会话条目最后一条消息内容提供者
   * @param contentProvider
   */
  static setConversationLatestMessageContentProvider(contentProvider: ConversationLatestMessageContentProvider) {
    uikit.setConversationLatestMessageContentProvider(contentProvider);
  }

  /**
   * 设置用户信息提供者。
   * @param provider
   */
  static setProfileProvider(provider: ProfileProvider) {
    uikit.setProfileProvider(provider);
  }

  /**
   * 设置当前用户信息。
   * @param user
   */
  static setCurrentUser(user: ChatUserProfile) {
    uikit.setCurrentUser(user);
  }

  /**
   * 刷新用户信息。
   * @param users
   */
  static updateUserProfiles(users: ChatUserProfile[] | ChatGroupProfile[]) {
    uikit.updateUserProfiles(users);
  }

}