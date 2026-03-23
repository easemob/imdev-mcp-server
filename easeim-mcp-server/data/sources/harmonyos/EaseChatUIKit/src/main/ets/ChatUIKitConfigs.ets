import { ChatConfigs } from './model/ChatConfigs';
import { AppStyle, CornerStyle } from './model/CornerStyle';
import { AvatarAttributeModifier } from './shares/attributeModifiers/AvatarAttributeModifier';
import { CornerRadiusNormalAttributeModifier } from './shares/attributeModifiers/CornerRadiusAttrbuteModifiers';


export class ChatUIKitConfigs {
  /**
   * 圆角样式。默认为 {@link CornerStyle.ROUND}。
   */
  cornerStyle?: CornerStyle;

  /**
   * 应用样式。
   */
  appStyle?: AppStyle;

  /**
   * 头像样式。
   * 默认样式为 {@link AvatarAttributeModifier}。
   */
  avatarAttribute?: CornerRadiusNormalAttributeModifier;

  /**
   * 聊天页面相关配置
   */
  chatConfigs?: ChatConfigs;

}