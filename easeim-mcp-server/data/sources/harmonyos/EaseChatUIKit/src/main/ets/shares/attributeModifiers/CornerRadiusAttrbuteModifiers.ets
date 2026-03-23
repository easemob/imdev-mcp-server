
export type CommonCornerRadiusAttribute = TextAttribute | ButtonAttribute | TextInputAttribute | ImageAttribute | CommonAttribute | RowAttribute;

/**
 * 通用圆角：基类，不做圆角处理。
 */
export class CornerRadiusNormalAttributeModifier implements AttributeModifier<CommonCornerRadiusAttribute> {

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
  }

  applyPressedAttribute(instance: CommonCornerRadiusAttribute): void {
  }

  applyFocusedAttribute(instance: CommonCornerRadiusAttribute): void {
  }

  applyDisabledAttribute(instance: CommonCornerRadiusAttribute): void {
  }

  applySelectedAttribute(instance: CommonCornerRadiusAttribute): void {
  }

}

/**
 * 通用圆角：圆角半径为最小宽或者高的一半。
 */
export class CornerRadiusExtraLargeAttributeModifier extends CornerRadiusNormalAttributeModifier {

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    instance.borderRadius('50%');
  }

}

/**
 * 通用圆角：圆角半径: 16vp。
 */
export class CornerRadiusLargeAttributeModifier extends CornerRadiusNormalAttributeModifier {

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    instance.borderRadius($r('app.float.corner_radius_large'));
  }

}

/**
 * 通用圆角：圆角半径: 12vp。
 */
export class CornerRadiusMediumAttributeModifier extends CornerRadiusNormalAttributeModifier {

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    instance.borderRadius($r('app.float.corner_radius_medium'));
  }

}

/**
 * 通用圆角：圆角半径: 8vp。
 */
export class CornerRadiusSmallAttributeModifier extends CornerRadiusNormalAttributeModifier {

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    instance.borderRadius($r('app.float.corner_radius_small'));
  }

}

/**
 * 通用圆角：圆角半径: 4vp。
 */
export class CornerRadiusExtraSmallAttributeModifier extends CornerRadiusNormalAttributeModifier {

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    instance.borderRadius($r('app.float.corner_radius_small_extra'));
  }

}

/**
 * 通用圆形
 */
export class CircleAttributeModifier extends CornerRadiusExtraLargeAttributeModifier {

}
