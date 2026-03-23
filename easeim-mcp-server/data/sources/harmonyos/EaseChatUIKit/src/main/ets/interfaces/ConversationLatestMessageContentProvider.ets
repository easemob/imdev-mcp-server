import { ChatMessage } from '@easemob/chatsdk';

export interface ConversationLatestMessageContentProvider {
  /**
   * 提供会话条目中最新一条消息的内容。
   * @param message
   * @returns
   */
  latestMessageContent: (message: ChatMessage) => string | undefined;
}