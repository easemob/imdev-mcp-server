import { ChatKitMessage } from '../model/ChatKitMessage';

export interface ChatMessageItemProvider {

  /**
   * 消息条目的builder提供者。
   *
   * 需要开发者提供消息条目的完整组件。
   * @param item
   */
  messageItemWrapBuilder: (item: ChatKitMessage) => WrappedBuilder<[ChatKitMessage]> | undefined;

}