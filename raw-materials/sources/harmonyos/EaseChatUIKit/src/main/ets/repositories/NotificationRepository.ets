import uikit from '../internal/ChatUIKit';
import { NotificationStatus } from '../model/Notification';
import { getString } from '../utils/CommonUtils';
import { util } from '@kit.ArkTS';
import { KitConstants } from '../constants/KitConstants';
import {
  ChatMessage,
  ChatType,
  Conversation,
  ConversationType,
  MessageExtType,
  MessageStatus,
  TextMessageBody
} from '@easemob/chatsdk';
import { EventBus, getEventStr } from '../utils/EventBus';

/**
 * 请求通知仓库
 */
export class NotificationRepository {
  /**
   * 系统默认会话的id。
   */
  private DEFAULT_SYSTEM_CONV_ID: string = KitConstants.DEFAULT_SYSTEM_CONV_ID;

  private declare systemConv?: Conversation;

  constructor() {
    this.systemConv = uikit.sdk.chatManager()?.getConversation(this.DEFAULT_SYSTEM_CONV_ID, ConversationType.Chat, true);
  }

  /**
   * 判断是否是通知消息。
   * @param message
   * @returns
   */
  static isNotification(message: ChatMessage): boolean {
    return message.getChatType() === ChatType.Chat && message.getConversationId() === KitConstants.DEFAULT_SYSTEM_CONV_ID;
  }

  /**
   * 加载本地所有的通知消息。最多加载400个。
   * @returns
   */
  async getAllNotifications(pageSize: number = 400): Promise<ChatMessage[]> {
    return await this.systemConv?.loadMoreMessagesFromDB('', pageSize) ?? [];
  }

  /**
   * 获取本地未读通知消息数。
   * @returns
   */
  getUnreadNotifications(): number {
    return this.systemConv?.getUnreadMsgCount() ?? 0;
  }

  /**
   * 更新本地通知消息。
   * @param message
   * @returns
   */
  updateNotification(message: ChatMessage): boolean {
    if (!NotificationRepository.isNotification(message)) {
      return false;
    }
    return this.systemConv?.updateMessage(message) ?? false;
  }

  /**
   * 移除本地通知消息。
   * @param message
   * @returns
   */
  removeNotification(message: ChatMessage): boolean {
    if (!NotificationRepository.isNotification(message)) {
      return false;
    }
    return this.systemConv?.removeMessage(message) ?? false;
  }

  /**
   * 将所有的本地消息置为已读。
   * @returns
   */
  markAllNotificationRead(): boolean {
    return this.systemConv?.markAllMessagesAsRead() ?? false;
  }

  /**
   * 同意好友邀请。
   * @param userId
   * @returns
   */
  agreeInvite(userId: string) {
    return uikit.sdk.contactManager()?.acceptInvitation(userId)
  }

  /**
   * 拒绝好友请求。
   * @param userIn
   * @returns
   */
  refuseInvite(userIn: string) {
    return uikit.sdk.contactManager()?.declineInvitation(userIn);
  }

  /**
   * 获取通知消息内容。
   * @param userId
   * @param status
   * @returns
   */
  static getNotificationContent(userId: string, status: NotificationStatus): string {
    if (status === NotificationStatus.CONTACT_INVITED) {
      return getString($r('app.string.notification_invitation_reason'));
    }
    return '';
  }

  /**
   * 创建一条通知消息。
   * @param userId
   * @param reason
   * @param status
   * @param isBroadcast
   * @returns
   */
  static async createNotification(userId?: string, reason?: string, status: NotificationStatus = NotificationStatus.CONTACT_INVITED, isBroadcast: boolean = true) {
    if (!userId) {
      return false;
    }
    // 检查本地是否有对应的消息，没有则插入，有则更新
    let conversation = uikit.sdk.chatManager()?.getConversation(KitConstants.DEFAULT_SYSTEM_CONV_ID);
    let exist = false;
    if (conversation) {
      let messages = await conversation.loadMoreMessagesFromDB('', 400);
      messages.forEach(msg => {
        let ext = msg.ext();
        let s = ext.get(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_STATUS) as number;
        let from = ext.get(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_FROM) as string;
        if (from === userId && status === s) {
          // 本地存在相同的消息，更新本地消息的时间
          exist = true;
          let timestamp = Date.now();
          msg.setServerTimestamp(timestamp);
          msg.setLocalTimestamp(timestamp);
        }
      })
    }
    if (!exist) {
      let ext: Map<string, MessageExtType> = new Map();
      ext.set(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_FROM, userId);
      if (reason) {
        ext.set(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_REASON, reason);
      }
      ext.set(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_STATUS, status);
      let content = NotificationRepository.getNotificationContent(userId, status);
      let body = new TextMessageBody(content);
      let message = ChatMessage.createReceiveMessage(KitConstants.DEFAULT_SYSTEM_CONV_ID, body, ChatType.Chat, util.generateRandomUUID(true));
      message.setStatus(MessageStatus.SUCCESS);
      message.setExt(ext);
      message.setUnread(true);
      uikit.sdk.chatManager()?.saveMessage(message);
      if (isBroadcast) {
        // 通知有新的通知消息
        EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_NOTIFICATION_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION));
      }
      return true;
    }
    return false;
  }

}