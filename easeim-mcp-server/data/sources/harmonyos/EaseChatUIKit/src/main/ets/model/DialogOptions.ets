import { KitCallback } from '../interfaces/CommonCallback';
import { ChatTextInputModel } from './builder/ChatComponentModel';
import { ButtonModel, ImageModel, TextModel } from './builder/ComponentModel';
import { MenuItem } from './Menu';

export declare type ActionCallBack = (action: number, content: string) => void;
export declare type OnItemClick = (index: number, value: object | ResourceStr) => void;

/**
 * 在相对较复杂的应用场景中推荐使用UIContext中获取到的PromptAction对象提供的openCustomDialog接口来实现自定义弹窗。
 */
export class PromptActionOptions {
  /**
   * 弹窗的id，需要具有唯一性。
   */
  id?: string;
  /**
   * Mask Region of dialog. The size can't exceed the main window.
   *
   * 弹窗遮蔽层区域，在遮蔽层区域内的事件不透传，在遮蔽层区域外的事件透传。
   */
  maskRect?: Rectangle;
  /**
   * Defines the dialog alignment of the screen.
   */
  alignment?: DialogAlignment;
  /**
   * Defines the dialog offset.
   */
  offset?: Offset;
  /**
   * Whether to display in the sub window.
   */
  showInSubWindow?: boolean;
  /**
   * Whether it is a modal dialog
   */
  isModal?: boolean;
  /**
   * Allows users to click the mask layer to exit.
   */
  autoCancel?: boolean;
  /**
   * Transition parameters of opening/closing custom dialog.
   */
  transition?: TransitionEffect;
  /**
   * Defines custom dialog maskColor
   */
  maskColor?: ResourceColor;
  /**
   * Callback function when the CustomDialog interactive dismiss.
   * 1.当用户执行点击遮障层关闭、左滑/右滑、三键back、键盘ESC关闭交互操作时，如果注册该回调函数，则不会立刻关闭弹窗。
   * 在回调函数中可以通过reason得到阻拦关闭弹窗的操作类型，从而根据原因选择是否能关闭弹窗。当前组件返回的reason中，暂不支持CLOSE_BUTTON的枚举值。
   * 2.在onWillDismiss回调中，不能再做onWillDismiss拦截。
   */
  onWillDismiss?: Callback<DismissDialogAction>;
  /**
   * Callback function when the dialog appears.
   */
  onDidAppear?: () => void;
  /**
   * Callback function when the dialog disappears.
   */
  onDidDisappear?: () => void;
  /**
   * Callback function before the dialog openAnimation starts.
   */
  onWillAppear?: () => void;
  /**
   * Callback function before the dialog closeAnimation starts.
   */
  onWillDisappear?: () => void;
  /**
   * Defines the customDialog's keyboard avoid mode
   */
  keyboardAvoidMode?: KeyboardAvoidMode;
}

export class DialogOptions extends PromptActionOptions{
  /**
   * 标题的样式
   */
  title?: TextModel
  /**
   * 内容的样式
   */
  content?: TextModel
  /**
   * 输入框的样式
   */
  input?: TextModel
  /**
   * 确定按钮的样式
   */
  confirmButton?: ButtonModel
  /**
   * 取消按钮的样式
   */
  cancelButton?: ButtonModel
  /**
   * 选项条目列表
   */
  menus?: MenuItem[] | ResourceStr[]
  /**
   * 条目点击事件
   */
  onItemClick?: OnItemClick;
  /**
   * 输入框内容变化
   */
  onChange?: KitCallback<string>;
  cornerRadius?: Length; //设置背板的圆角半径。可分别设置4个圆角的半径，默认15。
  /**
   * 设置弹窗的高度。
   */
  height?: Dimension | Length;
  /**
   * 设置弹窗的宽度
   */
  width?: Dimension | Length;
  /**
   * 按钮回调事件。
   */
  onAction?: ActionCallBack;
  /**
   * 弹窗背板颜色。默认值：Color.White
   */
  backgroundColor?: ResourceColor;
  /**
   * 用于设置弹窗是否在拉起软键盘时进行自动避让。
   * 默认值：KeyboardAvoidMode.DEFAULT
   */
  keyboardAvoidMode?: KeyboardAvoidMode
}

export class BottomSheetDialogOptions extends DialogOptions {
  /**
   * 是否支持滑动扩展区域，默认为false，不支持扩展。
   */
  isExpand?: boolean
  /**
   * 是否显示顶部拖拽把手
   * 当选项条目列表不为空的时候，这个值默认为true
   */
  isTopDragVisible?: boolean
  /**
   * 取消按钮是否可见，默认可见
   */
  isCancelVisible?: boolean
  /**
   * 选项条目列表
   */
  menus?: MenuItem[] | ResourceStr[] = []
  /**
   * 在BottomSheetDialog内部关闭dialog时触发
   */
  onDismiss?: () => void;
}

export class RecordBottomSheetDialogOptions extends DialogOptions {
  /**
   * 会话ID。
   */
  conversationId: string = ''
  /**
   * 最大语音时长
   */
  maxRecordSeconds?: number;
  /**
   * 语音按钮的图标
   */
  recordIcon?: ImageModel
  /**
   * 删除录音的图标
   */
  deleteIcon?: ImageModel
  /**
   * 发送录音的图标
   */
  sendIcon?: ImageModel
  /**
   * 倒计时文字设置
   */
  timeCountText?: TextModel
  /**
   * 录音状态文字设置
   */
  statusText?: TextModel
  /**
   * 播放剩余时间文字设置
   */
  remainText?: TextModel
  /**
   * 点击区域外是否关闭弹框设置发生改变
   */
  cancelableChange?: (canCancel: boolean) => void
  /**
   * 点击录制语音的回调事件，如果返回true，则表示用户拦截处理；返回false，表示采用默认逻辑。
   */
  onClickRecord?: (callback: (isPermissionRecordGranted: boolean) => void ) => void
  /**
   * 点击发送按钮
   */
  onClickSend: (voicePath: string | undefined, duration: number) => void = () => {};
}

export class EditMessageBottomSheetDialogOptions extends DialogOptions {
  textModel?: ChatTextInputModel;
  messageId?: string;
  onEditChange?: (messageId: string | undefined, value: string) => void;
}

