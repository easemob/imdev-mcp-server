import { TextParseResult } from '../../internal/model/EmojiIcon';
import { CornerRadiusNormalAttributeModifier } from '../../shares/attributeModifiers/CornerRadiusAttrbuteModifiers';
import { TextBaseAttributeModifier } from '../../shares/attributeModifiers/TextAttributeModifiers';
import { MessageSentStatus } from '../ComponentStatus';
import { ImageModel, TextModel } from './ComponentModel';


export interface MessageBubbleModel {
  background?: ResourceColor;
  isSender?: boolean;
}

/**
 * 消息发送状态
 */
export class MessageSentStatusModel extends ImageModel {
  status?: MessageSentStatus;
  angle?: number | string;
}

/**
 * 文本消息
 */
export class MessageTextModel extends TextModel implements MessageBubbleModel {
  background?: ResourceColor;
  isSender?: boolean;
  // 包含表情符的文本解析结果，仅在文本消息中使用这个属性
  textParseResult?: TextParseResult[];
  // 设置文本中表情符的尺寸大小
  emojiSize?: Length;
  hasMention?: boolean;
}

/**
 * 消息头像对象
 */
export class MessageAvatarModel extends ImageModel implements MessageBubbleModel{
  isSender?: boolean;
}

/**
 * 消息图片对象
 */
export class MessageImageModel extends ImageModel implements MessageBubbleModel {
  isSender?: boolean;
}

/**
 * 消息文件对象
 */
export class MessageFileModel extends TextModel implements MessageBubbleModel {
  isSender?: boolean;
  // 用于文件长度控件颜色
  secondFontColor?: ResourceColor;
  // 用于文件长度控件属性设置
  secondAttributeModifier?: TextBaseAttributeModifier;
}

/**
 * 名片消息对象。
 */
export class MessageUserCardModel extends TextModel implements MessageBubbleModel {
  isSender?: boolean;
  secondFontColor?: ResourceColor;
  secondAttributeModifier?: TextBaseAttributeModifier;
  avatarAttributeModifier?: CornerRadiusNormalAttributeModifier;
}

/**
 * 用于 RichEditor 中 RichEditorController.addBuilderSpan 时的对象。
 * 具体使用详见组件：ChatPrimaryTextInput
 */
export interface RichEditorSpanModel {
  value?: string
  resourceValue?: ResourceStr
  type: 'text' | 'image' | 'builder'
  data?: string | object
}