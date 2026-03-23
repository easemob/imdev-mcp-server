import {
  ChatPrimaryTextInputAttributeModifier
} from '../../components/chat/attributeModifiers/ChatPrimaryTextInputAttributeModifier';
import { CommonComponentModel, ImageModel } from './ComponentModel';

/**
 * 聊天主菜单的控制model。
 */
@ObservedV2
export class ChatPrimaryMenuModel {
  // enable属性是控制对应的icon是否可用
  @Trace isRecorderEnable?: boolean = true;
  @Trace isInputTextEnable?: boolean = true;
  @Trace isEmojiEnable?: boolean = true;
  @Trace isExtendEnable?: boolean = true;
  // visible属性是控制对应的icon是否可见的
  @Trace isRecorderIconVisible?: boolean = true;
  @Trace isInputTextVisible?: boolean = true;
  @Trace isEmojiIconVisible?: boolean = true;
  @Trace isExtendIconVisible?: boolean = true;
  @Trace isSendIconVisible?: boolean = false;
  // status属性是，标明当前处于哪种状态，比如isShowRecordExtendStatus = true，则是在语音预录制或者录制状态，其他状态都是false
  @Trace isShowRecordExtendStatus?: boolean = false;
  @Trace isShowEmojiExtendStatus?: boolean = false;
  @Trace isShowMoreExtendStatus?: boolean = false;
  @Trace isInputtingStatus?: boolean = false;
}

/**
 * 聊天主菜单输入框控制model
 */
export class ChatTextInputModel extends CommonComponentModel<ChatPrimaryTextInputAttributeModifier> {
  // 输入框字体大小
  fontSize?: Length;
  // 输入框字体颜色
  fontColor?: ResourceColor;
  // 提示文本
  placeholder?: ResourceStr;
  // 提示文本样式
  placeholderStyle?: PlaceholderStyle;
  // 最大输入行数
  maxLines?: number;
}

/**
 * 表情扩展区域控制model
 */
export class ChatEmojiExtendModel {
  // 最大列数
  maxColumnCount?: number = 7;
  // 扩展区域高度
  height?: Length;
  topPadding?: Length;
  bottomPadding?: Length;
  startPadding?: Length;
  endPadding?: Length;
  // 行间距
  rowGap?: Length;
  // 列间距
  columnGap?: Length;
}

/**
 * 扩展区域控制model
 */
export class ChatMoreExtendModel {
  // 最大列数
  maxColumnCount?: number = 4;
  // 扩展区域高度
  height?: Length;
  topPadding?: Length;
  bottomPadding?: Length;
  startPadding?: Length;
  endPadding?: Length;
  // 行间距
  rowGap?: Length;
  // 列间距
  columnGap?: Length;
}

/**
 * 带图片的button的控制model
 */
export class ChatImageButtonModel extends ImageModel{
  btnOptions?: ButtonOptions
  btnWidth?: Length;
  btnHeight?: Length;
  btnBorder?: BorderOptions;
  btnMargin?: Length | Margin;
  btnShadow?: ShadowOptions | ShadowStyle;
  btnBackgroundColor?: ResourceColor;
}