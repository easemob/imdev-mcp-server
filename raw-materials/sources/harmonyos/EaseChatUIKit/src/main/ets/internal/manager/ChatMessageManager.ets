import { ChatMessage } from '@easemob/chatsdk';
import { ChatMessageBubbleProvider } from '../../interfaces/ChatMessageBubbleProvider';
import { ChatMessageItemProvider } from '../../interfaces/ChatMessageItemProvider';
import { ConversationLatestMessageContentProvider } from '../../interfaces/ConversationLatestMessageContentProvider';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { getMessageItemNodeController, MessageItemNodeController } from '../provider/MessageItemNodeController';

/**
 * 消息布局提供者管理类。
 */
export class ChatMessageProviderManager {
  private messageBubbleProvider?: ChatMessageBubbleProvider;
  private messageItemProvider?: ChatMessageItemProvider;
  private contentProvider?: ConversationLatestMessageContentProvider;

  /**
   * 提供消息条目完整布局的组件。
   * @param itemProvider
   */
  addMessageItemProvider(itemProvider: ChatMessageItemProvider | ChatMessageBubbleProvider) {
    if (typeof (itemProvider as ChatMessageItemProvider).messageItemWrapBuilder !== 'undefined') {
      this.messageItemProvider = itemProvider as ChatMessageItemProvider;
    } else if (typeof (itemProvider as ChatMessageBubbleProvider).messageBubbleWrapBuilder !== 'undefined') {
      this.messageBubbleProvider = itemProvider as ChatMessageBubbleProvider;
    }
  }

  /**
   * 会话最后一条消息内容提供者
   * @param contentProvider
   */
  setConversationLatestMessageContentProvider(contentProvider: ConversationLatestMessageContentProvider) {
    this.contentProvider = contentProvider;
  }

  hasCustomBubbleNode(item?: ChatKitMessage | ChatMessage): boolean {
    if (!item || !this.messageBubbleProvider) {
      return false;
    }
    let message: ChatKitMessage;
    if (item instanceof ChatKitMessage) {
      message = item;
    } else {
      message = new ChatKitMessage(item);
    }
    let builder = this.messageBubbleProvider.messageBubbleWrapBuilder?.(message);
    if (!builder) {
      return false;
    }
    return true;
  }

  provideMessageBubbleNodeController(uiContext: UIContext, item: ChatKitMessage): MessageItemNodeController | undefined {
    if (this.messageBubbleProvider) {
      return getMessageItemNodeController(uiContext, item, this.messageBubbleProvider.messageBubbleWrapBuilder?.(item));
    }
    return undefined;
  }

  hasCustomItemNode(item?: ChatKitMessage | ChatMessage): boolean {
    if (!item || !this.messageItemProvider) {
      return false;
    }
    let message: ChatKitMessage;
    if (item instanceof ChatKitMessage) {
      message = item;
    } else {
      message = new ChatKitMessage(item);
    }
    let builder = this.messageItemProvider.messageItemWrapBuilder?.(message);
    if (!builder) {
      return false;
    }
    return true;
  }

  provideMessageItemNodeController(uiContext: UIContext, item: ChatKitMessage): MessageItemNodeController | undefined {
    if (this.messageItemProvider) {
      return getMessageItemNodeController(uiContext, item, this.messageItemProvider.messageItemWrapBuilder?.(item));
    }
    return undefined;
  }

  hasCustomContent(message?: ChatMessage): boolean {
    if (!message) {
      return false;
    }
    if (this.contentProvider && this.contentProvider.latestMessageContent(message)) {
      return true;
    }
    return false;
  }

  getCustomContentInConversationItem(item?: ChatKitMessage | ChatMessage): string | undefined {
    if (!item) {
      return undefined;
    }
    let message: ChatMessage;
    if (item instanceof ChatKitMessage) {
      message = item.origin;
    } else {
      message = item;
    }
    if (this.contentProvider) {
      return this.contentProvider?.latestMessageContent?.(message);
    }
    return undefined;
  }

}

export const messageProviderManager = new ChatMessageProviderManager();