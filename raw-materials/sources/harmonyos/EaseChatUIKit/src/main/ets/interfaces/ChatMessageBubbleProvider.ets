import { ChatKitMessage } from '../model/ChatKitMessage';

export interface ChatMessageBubbleProvider {

  /**
   * 消息条目Bubble的builder提供者。
   * @param message
   */
  messageBubbleWrapBuilder: (message: ChatKitMessage) => WrappedBuilder<[ChatKitMessage]> | undefined;

}