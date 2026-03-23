import {
  CommonCornerRadiusAttribute,
  CornerRadiusSmallAttributeModifier
} from '../../../shares/attributeModifiers/CornerRadiusAttrbuteModifiers';

/**
 * Emoji扩展条目的属性。
 */
export class ChatEmojiAttributeModifier extends CornerRadiusSmallAttributeModifier {
  applyPressedAttribute(instance: CommonCornerRadiusAttribute): void {
    instance.backgroundColor($r('app.color.chat_color_component_normal'))
  }
}