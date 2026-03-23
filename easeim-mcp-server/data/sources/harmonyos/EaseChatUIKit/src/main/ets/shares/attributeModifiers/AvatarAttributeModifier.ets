import { CornerStyle } from '../../model/CornerStyle';
import { CommonCornerRadiusAttribute,
  CornerRadiusNormalAttributeModifier } from './CornerRadiusAttrbuteModifiers';

/**
 * 头像通用样式。
 */
export class AvatarAttributeModifier extends CornerRadiusNormalAttributeModifier {

  private declare cornerStyle: CornerStyle;
  private declare imageSize: Length;
  private declare radius: Length;

  constructor(cornerStyle?: CornerStyle, size?: Length, radius?: Length) {
    super();
    this.cornerStyle = cornerStyle ?? CornerStyle.ROUND;
    this.imageSize = size ?? $r('app.float.avatar_image_size');
    if (this.cornerStyle === CornerStyle.ROUND) {
      if (!radius) {
        if (!size) {
          this.radius = $r('app.float.corner_radius_small_tiny');
        } else {
          this.radius = $r('app.float.corner_radius_small_extra');
        }
      } else {
        this.radius = radius;
      }
    }
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius(this.radius);
      instance.width(this.imageSize);
      instance.height(this.imageSize);
    } else if (this.cornerStyle === CornerStyle.CIRCLE) {
      instance.width(this.imageSize);
      instance.height(this.imageSize);
      let radius = 0;
      if (typeof this.imageSize === 'number') {
        radius = this.imageSize / 2;
        instance.borderRadius(radius);
      } else if (typeof this.imageSize === 'string'){
        instance.borderRadius(this.imageSize);
      } else {
        radius = getContext().resourceManager.getNumber(this.imageSize) / 2;
        instance.borderRadius(radius);
      }
    }
  }

}