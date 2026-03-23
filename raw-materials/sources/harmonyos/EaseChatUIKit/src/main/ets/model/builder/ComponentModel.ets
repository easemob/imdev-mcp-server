import { ComponentStatus } from '../ComponentStatus';
import { CornerRadiusNormalAttributeModifier } from '../../shares/attributeModifiers/CornerRadiusAttrbuteModifiers';
import { TextBaseAttributeModifier } from '../../shares/attributeModifiers/TextAttributeModifiers';
import { CountStyle } from '../Badge';
import { KitCallback } from '../../interfaces/CommonCallback';

/**
 * 通用自定义构建函数的model
 */
export class CommonComponentModel<T> {
  width?: Length;
  height?: Length;
  visible?: Visibility;
  margin?: Margin;
  alignSelf?: ItemAlign;
  backgroundColor?: ResourceColor;
  attributeModifier?: T;
}

export class CheckboxModel extends CommonComponentModel<AttributeModifier<CheckboxAttribute>>{
  options?: CheckboxOptions;
  isSelect?: boolean;
  unselectedColor?: ResourceColor;
  selectedColor?: ResourceColor;
  shape?: CheckBoxShape;
  onChange?: (value: boolean) => void;
  onClick?: KitCallback<ClickEvent>;
  contentModifier?: ContentModifier<CheckBoxConfiguration>
}

export class ToggleSwitchModel extends CommonComponentModel<AttributeModifier<ToggleAttribute>>{
  isSelect?: boolean;
  selectedColor?: ResourceColor;
  onChange?: (value: boolean) => void;
}

export class ImageModel extends CommonComponentModel<CornerRadiusNormalAttributeModifier>{
  src?: ResourceStr;
  imageFit?: ImageFit;
  alt?: string | Resource | PixelMap;
  fitOriginalSize?: boolean;
  border?: BorderOptions;
  fillColor?: ResourceColor;
}

export class EmojiModel extends ImageModel {
  status?: ComponentStatus;
  outlineSize?: Length;
  onClick?: (status: ComponentStatus) => void;
}

export class TextModel extends CommonComponentModel<TextBaseAttributeModifier>{
  content?: ResourceStr;
  fontColor?: ResourceColor;
  placeholder?: ResourceStr;
}

export class TextDateModel extends TextModel {
  date: string = ''
  options?: DateTimeOptions;
  locale?: string | Array<string>;
  separate?: string;
}

export class ButtonModel extends TextModel {
  backgroundColor?: ResourceColor
}

export class BadgeModel extends TextModel {
  count: number = 0;
  position?: BadgePosition|Position;
  style: BadgeStyle = {};
}

export class CountModel extends TextModel {
  count: number = 0;
  maxCount?: number;
  style?: CountStyle;
}

export class RowModel extends CommonComponentModel<AttributeModifier<RowAttribute>> {
  alignItems?: VerticalAlign
  justifyContent?: FlexAlign
  space?: string | number
}

/**
 * 用在 searchInputBuilder 中。
 */
export class SearchModel extends TextModel {
  placeholder?: ResourceStr;
  placeholderColor?: ResourceColor;
  placeholderSize?: Length;
  searchIcon?: IconOptions;
  /**
   * 输入框内的清除按钮设置选项
   */
  cancelIcon?: CancelButtonOptions;
  /**
   * 取消按钮设置选项
   */
  cancelText?: TextModel;
}