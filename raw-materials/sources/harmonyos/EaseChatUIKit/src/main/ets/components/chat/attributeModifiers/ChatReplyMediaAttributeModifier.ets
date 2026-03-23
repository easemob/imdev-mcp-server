import uikit from '../../../internal/ChatUIKit';
import { CornerStyle } from '../../../model/CornerStyle';
import {
  CommonCornerRadiusAttribute,
  CornerRadiusNormalAttributeModifier
} from '../../../shares/attributeModifiers/CornerRadiusAttrbuteModifiers';

export class ChatReplyMediaAttributeModifier extends CornerRadiusNormalAttributeModifier {
  private declare cornerStyle: CornerStyle;

  constructor(cornerStyle?: CornerStyle) {
    super();
    this.cornerStyle = cornerStyle ?? (uikit.configs.cornerStyle ?? CornerStyle.ROUND);
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius(2);
      instance.width($r('app.float.chat_icon_size_medium'));
      instance.height($r('app.float.chat_icon_size_medium'));
    } else {
      instance.borderRadius($r('app.float.corner_radius_small'));
      instance.width($r('app.float.chat_icon_size_medium'));
      instance.height($r('app.float.chat_icon_size_medium'));
    }
  }

}