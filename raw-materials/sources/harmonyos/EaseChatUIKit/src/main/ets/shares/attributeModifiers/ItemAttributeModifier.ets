
export class ItemBackgroundAttributeModifier implements AttributeModifier<CommonAttribute> {

  applyNormalAttribute(instance: CommonAttribute): void {
    instance.backgroundColor($r('app.color.chat_color_background'))
  }

}

export class ItemClickAttributeModifier extends ItemBackgroundAttributeModifier {

  applyNormalAttribute(instance: CommonAttribute): void {
    instance.backgroundColor($r('app.color.chat_color_background'))
  }

  applyPressedAttribute(instance: CommonAttribute): void {
    instance.backgroundColor($r('app.color.chat_color_background_pressed'))
  }

}

