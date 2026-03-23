import { ChatKitConversation } from '../model/ChatKitConversation';

export interface ConversationItemProvider {

  /**
   * 会话条目的builder提供者。
   *
   * @param item
   */
  itemWrapBuilder: (item: ChatKitConversation) => WrappedBuilder<[ChatKitConversation]> | undefined;

}