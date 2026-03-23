import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { ChatKitMessage } from '../../model/ChatKitMessage';

export class ItemNodeController<T extends object> extends NodeController {
  private rootNode: FrameNode | null = null;
  private uiContext?: UIContext;
  private itemNode: BuilderNode<[T]> | null = null;

  constructor(uiContext: UIContext, item: T, wrapBuilder: WrappedBuilder<[T]>) {
    super();
    this.uiContext = uiContext;
    // uiContext is required for creating a node.
    this.rootNode = new FrameNode(this.uiContext);
    // uiContext is required for create a node;
    this.itemNode = new BuilderNode(this.uiContext);
    this.itemNode.build(wrapBuilder, item);
    this.rootNode.getRenderNode()?.appendChild(this.itemNode.getFrameNode()?.getRenderNode());
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode) {
      return this.rootNode;
    }
    return null;
  }

}

/**
 * 消息条目的NodeController.
 */
export class MessageItemNodeController extends ItemNodeController<ChatKitMessage> {

  constructor(uiContext: UIContext, item: ChatKitMessage, wrapBuilder: WrappedBuilder<[ChatKitMessage]>) {
    super(uiContext, item, wrapBuilder);
  }

}

export const getMessageItemNodeController = (uiContext: UIContext, message: ChatKitMessage, wrapBuilder: WrappedBuilder<[ChatKitMessage]> | undefined): MessageItemNodeController | undefined => {
  if (wrapBuilder) {
    let baseNode = new MessageItemNodeController(uiContext, message, wrapBuilder);
    return baseNode
  }
  return undefined;
}
