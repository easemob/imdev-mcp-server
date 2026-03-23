import { ConversationItemProvider } from '../../interfaces/ConversationItemProvider';
import { ChatKitConversation } from '../../model/ChatKitConversation';
import {
  ConversationItemNodeController,
  getConversationItemNodeController
} from '../provider/ConversationItemNodeController';

/**
 * 会话条目布局提供者管理类。
 */
export class ConversationItemManager {
  private itemProvider?: ConversationItemProvider;

  /**
   * 提供会话条目完整布局的组件。
   * @param itemProvider
   */
  addConversationItemProvider(itemProvider: ConversationItemProvider) {
    this.itemProvider = itemProvider;
  }

  hasCustomNode(item?: ChatKitConversation): boolean {
    if (!item || !this.itemProvider) {
      return false;
    }
    let builder = this.itemProvider.itemWrapBuilder?.(item);
    if (!builder) {
      return false;
    }
    return true;
  }

  provideNodeController(uiContext: UIContext, item: ChatKitConversation): ConversationItemNodeController | undefined {
    if (this.hasCustomNode(item) && this.itemProvider) {
      return getConversationItemNodeController(uiContext, item, this.itemProvider.itemWrapBuilder?.(item));
    }
    return undefined;
  }

}

export const conversationProviderManager = new ConversationItemManager();