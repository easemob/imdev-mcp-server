import { UIContext } from '@kit.ArkUI';
import { ChatKitConversation } from '../../model/ChatKitConversation';
import { ItemNodeController } from './MessageItemNodeController';

/**
 * 会话条目的NodeController.
 */
export class ConversationItemNodeController extends ItemNodeController<ChatKitConversation> {

  constructor(uiContext: UIContext, item: ChatKitConversation, wrapBuilder: WrappedBuilder<[ChatKitConversation]>) {
    super(uiContext, item, wrapBuilder);
  }

}

export const getConversationItemNodeController = (uiContext: UIContext, item: ChatKitConversation, wrapBuilder: WrappedBuilder<[ChatKitConversation]> | undefined): ConversationItemNodeController | undefined => {
  if (wrapBuilder) {
    let baseNode = new ConversationItemNodeController(uiContext, item, wrapBuilder);
    return baseNode
  }
  return undefined;
}
