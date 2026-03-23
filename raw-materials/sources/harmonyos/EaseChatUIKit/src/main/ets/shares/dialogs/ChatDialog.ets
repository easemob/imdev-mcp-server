import { ChatError } from '@easemob/chatsdk';
import { PromptActionOptions } from '../../model/DialogOptions';
import HashMap from '@ohos.util.HashMap';

export class ChatDialog {
  private context: UIContext;
  private contentNode: ComponentContent<Object> | undefined;
  private options: PromptActionOptions | undefined;

  constructor(context: UIContext) {
    this.context = context
  }

  /**
   * 设置ComponentContent
   * @param contentNode
   * @returns
   */
  setContentNode(contentNode: ComponentContent<Object>) {
    this.contentNode = contentNode;
    return this;
  }

  /**
   * 设置 Dialog 的选项。
   * @param options
   * @returns
   */
  setOptions(options?: PromptActionOptions) {
    this.options = options
    return this;
  }

  /**
   * 获取已打开弹框的id。
   * @returns
   */
  getDialogId(): string | undefined {
    return this.options?.id;
  }

  createDialog(): string {
    if (!this.options) {
      this.options = new PromptActionOptions();
      this.options.id = ChatDialogAction.getInstance().generateDialogId();
    } else {
      if (!this.options.id) {
        this.options.id = ChatDialogAction.getInstance().generateDialogId();
      }
    }
    let onDidDisappear = this.options.onDidDisappear
    this.options.onDidDisappear = () => {
      ChatDialogAction.getInstance().remove(this.options?.id ?? '');
      this.contentNode?.dispose();
      onDidDisappear?.();
    }
    let onWillDismiss = this.options.onWillDismiss
    const dialog = this;
    this.options.onWillDismiss = (action: DismissDialogAction) => {
      if (onWillDismiss) {
        onWillDismiss(action);
      } else {
        if (action.reason == DismissReason.PRESS_BACK ) {
          action.dismiss()
        } else if (action.reason == DismissReason.TOUCH_OUTSIDE && (dialog.options?.autoCancel === undefined || dialog.options.autoCancel)) {
          action.dismiss()
        }
      }
    }
    ChatDialogAction.getInstance().add(this.options.id, this);
    return this.options.id;
  }

  /**
   * 打开弹窗。
   * @returns
   */
  async openDialog(dialogId: string): Promise<void> {
    if (!dialogId) {
      return Promise.reject(ChatError.createError(ChatError.OPERATION_UNSUPPORTED, 'dialogId cannot be empty.'));
    }
    if (!this.context) {
      return Promise.reject(ChatError.createError(ChatError.INVALID_PARAM, 'context is undefined.'));
    }
    if (!this.contentNode) {
      return Promise.reject(ChatError.createError(ChatError.INVALID_PARAM, 'componentContent is undefined.'));
    }
    return await this.context.getPromptAction().openCustomDialog(this.contentNode, this.options)
  }

  /**
   * 关闭弹窗。
   * @returns
   */
  async closeDialog(): Promise<void> {
    if (!this.context) {
      return Promise.reject(ChatError.createError(ChatError.INVALID_PARAM, 'context is undefined.'));
    }
    if (!this.contentNode) {
      return Promise.reject(ChatError.createError(ChatError.INVALID_PARAM, 'componentContent is undefined.'));
    }
    await this.context.getPromptAction().closeCustomDialog(this.contentNode);
    this.contentNode.dispose()
  }

  /**
   * 更新弹窗。
   * @param options
   * @returns
   */
  async updateDialog<T extends PromptActionOptions>(options: T): Promise<void> {
    if (!this.context) {
      return Promise.reject(ChatError.createError(ChatError.INVALID_PARAM, 'context is undefined.'));
    }
    if (!this.contentNode) {
      return Promise.reject(ChatError.createError(ChatError.INVALID_PARAM, 'componentContent is undefined.'));
    }
    return this.contentNode.update(options);
  }

  static getDialog(dialogId: string): ChatDialog | undefined {
    return ChatDialogAction.getInstance().get(dialogId);
  }

  static isExist(dialogId: string): boolean {
    return ChatDialogAction.getInstance().contains(dialogId);
  }
}

class ChatDialogAction {
  private static instance: ChatDialogAction;
  private caches: HashMap<string, ChatDialog> = new HashMap();
  private constructor() {
  }

  static getInstance(): ChatDialogAction {
    if (!ChatDialogAction.instance) {
      ChatDialogAction.instance = new ChatDialogAction();
    }
    return ChatDialogAction.instance
  }

  add(dialogId: string, dialog: ChatDialog) {
    if (this.caches.hasKey(dialogId)) {
      console.log(`already has the dialog: ${dialogId}`);
      return false;
    }
    this.caches.set(dialogId, dialog);
    return true;
  }

  remove(dialogId: string): boolean {
    if (this.caches.hasKey(dialogId)) {
      return this.caches.remove(dialogId) != undefined
    }
    return false;
  }

  contains(dialogId: string): boolean {
    return this.caches.hasKey(dialogId);
  }

  get(dialogId: string): ChatDialog | undefined {
    if (this.caches.hasKey(dialogId)) {
      return this.caches.get(dialogId)
    }
    return undefined
  }

  generateDialogId(): string {
    return new Date().getTime() + ''
  }
}