import { CornerStyle } from '../../model/CornerStyle';
import {
  CommonCornerRadiusAttribute,
  CornerRadiusNormalAttributeModifier
} from '../../shares/attributeModifiers/CornerRadiusAttrbuteModifiers';
import uikit from '../ChatUIKit';

/**
 * 用于回复消息布局圆角属性。
 */
export class MessageReplyAttributeModifier extends CornerRadiusNormalAttributeModifier {

  private declare cornerStyle: CornerStyle;
  private declare isSender: boolean;
  private declare isInputStyle: boolean;

  constructor(isSender: boolean = true, isInputStyle: boolean, cornerStyle?: CornerStyle) {
    super();
    this.cornerStyle = (cornerStyle ?? uikit.configs.cornerStyle) ?? CornerStyle.ROUND;
    this.isSender = isSender;
    this.isInputStyle = isInputStyle;
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.isInputStyle) {
      instance.borderRadius(0);
    } else {
      if (this.cornerStyle === CornerStyle.ROUND) {
        instance.borderRadius($r('app.float.corner_radius_small_extra'))
      } else if (this.cornerStyle === CornerStyle.CIRCLE) {
        if (this.isSender) {
          instance.borderRadius({
            topLeft: $r('app.float.corner_radius_large'),
            topRight: $r('app.float.corner_radius_medium'),
            bottomLeft: $r('app.float.corner_radius_large'),
            bottomRight: $r('app.float.corner_radius_small_extra')
          })
        } else {
          instance.borderRadius({
            topLeft: $r('app.float.corner_radius_medium'),
            topRight: $r('app.float.corner_radius_large'),
            bottomLeft: $r('app.float.corner_radius_small_extra'),
            bottomRight: $r('app.float.corner_radius_large')
          })
        }

      }
    }
    instance.backgroundColor($r('app.color.chat_color_message_reply_bg'))
  }
}

/**
 * 用于消息条目bubble圆角属性。
 */
export class MessageItemCommonAttributeModifier extends CornerRadiusNormalAttributeModifier {

  private declare cornerStyle: CornerStyle;
  private declare isSender: boolean;
  private declare isReplyMessage: boolean;

  constructor(isSender: boolean = true, isReplyMessage: boolean = false, cornerStyle?: CornerStyle) {
    super();
    this.cornerStyle = (cornerStyle ?? uikit.configs.cornerStyle) ?? CornerStyle.ROUND;
    this.isSender = isSender;
    this.isReplyMessage = isReplyMessage;
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius($r('app.float.corner_radius_small_extra'))
    } else if (this.cornerStyle === CornerStyle.CIRCLE) {
      if (this.isSender) {
        if (this.isReplyMessage) {
          instance.borderRadius({
            topLeft: $r('app.float.corner_radius_large'),
            topRight: $r('app.float.corner_radius_small_extra'),
            bottomLeft: $r('app.float.corner_radius_large'),
            bottomRight: $r('app.float.corner_radius_small_extra')
          })
        } else {
          instance.borderRadius({
            topLeft: $r('app.float.corner_radius_large'),
            topRight: $r('app.float.corner_radius_medium'),
            bottomLeft: $r('app.float.corner_radius_large'),
            bottomRight: $r('app.float.corner_radius_small_extra')
          })
        }
      } else {
        if (this.isReplyMessage) {
          instance.borderRadius({
            topLeft: $r('app.float.corner_radius_small_extra'),
            topRight: $r('app.float.corner_radius_large'),
            bottomLeft: $r('app.float.corner_radius_small_extra'),
            bottomRight: $r('app.float.corner_radius_large')
          })
        } else {
          instance.borderRadius({
            topLeft: $r('app.float.corner_radius_medium'),
            topRight: $r('app.float.corner_radius_large'),
            bottomLeft: $r('app.float.corner_radius_small_extra'),
            bottomRight: $r('app.float.corner_radius_large')
          })
        }
      }

    }
    if (this.isSender) {
      instance.backgroundColor($r('app.color.chat_color_message_bubble_send_background'))
    } else {
      instance.backgroundColor($r('app.color.chat_color_message_bubble_background'))
    }
  }
}

/**
 * 用于图片以及视频条目bubble圆角属性
 */
export class MessageItemImageAttributeModifier extends CornerRadiusNormalAttributeModifier {

  private declare cornerStyle: CornerStyle;

  constructor(cornerStyle?: CornerStyle) {
    super();
    this.cornerStyle = (cornerStyle ?? uikit.configs.cornerStyle) ?? CornerStyle.ROUND;
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius($r('app.float.corner_radius_small_extra'));
    } else if (this.cornerStyle === CornerStyle.CIRCLE) {
      instance.borderRadius($r('app.float.corner_radius_medium'))
    }
    instance.borderWidth($r('app.float.message_item_image_border_width'));
    instance.borderColor($r('app.color.chat_color_message_image_border'));
    instance.borderStyle(BorderStyle.Solid);
  }
}

/**
 * 用于引用消息条目bubble圆角属性
 */
export class MessageItemOverlayAttributeModifier extends CornerRadiusNormalAttributeModifier {

  private declare cornerStyle: CornerStyle;
  private declare isSender: boolean;

  constructor(isSender: boolean = true, cornerStyle?: CornerStyle) {
    super();
    this.cornerStyle = (cornerStyle ?? uikit.configs.cornerStyle) ?? CornerStyle.ROUND;
    this.isSender = isSender;
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius($r('app.float.corner_radius_small_extra'))
    } else if (this.cornerStyle === CornerStyle.CIRCLE) {
      if (this.isSender) {
        instance.borderRadius({
          topLeft: $r('app.float.corner_radius_large'),
          topRight: $r('app.float.corner_radius_small_extra'),
          bottomLeft: $r('app.float.corner_radius_large'),
          bottomRight: $r('app.float.corner_radius_small_extra')
        })
      } else {
        instance.borderRadius({
          topLeft: $r('app.float.corner_radius_small_extra'),
          topRight: $r('app.float.corner_radius_large'),
          bottomLeft: $r('app.float.corner_radius_small_extra'),
          bottomRight: $r('app.float.corner_radius_large')
        })
      }
    }
    if (this.isSender) {
      instance.backgroundColor($r('app.color.chat_color_message_bubble_send_background'))
    } else {
      instance.backgroundColor($r('app.color.chat_color_message_bubble_background'))
    }
  }
}