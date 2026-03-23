import uikit from '../../../internal/ChatUIKit';
import { CornerStyle } from '../../../model/CornerStyle';

export class ChatPrimaryTextInputAttributeModifier implements AttributeModifier<RichEditorAttribute> {
  private cornerStyle: CornerStyle;
  private leftPadding: Resource;
  private rightPadding: Resource;
  private topPadding: Resource;
  private bottomPadding: Resource;

  constructor(cornerStyle?: CornerStyle) {
    this.cornerStyle = cornerStyle ?? (uikit.configs.cornerStyle ?? CornerStyle.ROUND);
    this.leftPadding = $r('app.float.chat_margin_common_small');
    this.rightPadding = $r('app.float.chat_margin_common_small');
    this.topPadding = $r('app.float.chat_margin_common_small');
    this.bottomPadding = $r('app.float.chat_margin_common_small');
  }
  
  applyNormalAttribute(instance: RichEditorAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius($r('app.float.corner_radius_small_extra'))
    } else {
      instance.borderRadius('50%')
    }
    instance.padding({
      left: this.leftPadding,
      right: this.rightPadding,
      top: this.topPadding,
      bottom: this.bottomPadding
    })
    instance.backgroundColor($r('app.color.chat_color_sub_background'))
  }

  applyPressedAttribute(instance: RichEditorAttribute): void {
  }

  applyFocusedAttribute(instance: RichEditorAttribute): void {
  }

  applyDisabledAttribute(instance: RichEditorAttribute): void {
  }

  applySelectedAttribute(instance: RichEditorAttribute): void {
  }

  getTopPadding() {
    return getContext(this).resourceManager.getNumber(this.topPadding);
  }

  getBottomPadding() {
    return getContext(this).resourceManager.getNumber(this.bottomPadding);
  }
  
}