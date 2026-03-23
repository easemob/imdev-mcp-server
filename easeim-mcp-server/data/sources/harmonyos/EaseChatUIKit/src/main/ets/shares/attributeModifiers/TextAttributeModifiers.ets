
export type CommonTextFontAttribute = TextAttribute | ButtonAttribute | TextInputAttribute | SpanAttribute;

/**
 * 通用字体样式：基类
 */
export class TextBaseAttributeModifier implements AttributeModifier<CommonTextFontAttribute> {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontFamily('HarmonyOS Sans');
  }

  applySelectedAttribute(instance: CommonTextFontAttribute): void {
  }

  applyDisabledAttribute(instance: CommonTextFontAttribute): void {
  }

  applyFocusedAttribute(instance: CommonTextFontAttribute): void {
  }

  applyPressedAttribute(instance: CommonTextFontAttribute): void {
  }

}

/**
 * 通用字体样式：简体中文/标题/大 - Bold 20/28
 */
export class TextHeadlineLargeAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_headline_large'));
    instance.fontWeight(FontWeight.Medium);
  }

}

/**
 * 通用字体样式：简体中文/标题/中 - Bold 18/26
 */
export class TextHeadlineMediumAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_headline_medium'));
    instance.fontWeight(FontWeight.Medium);
  }

}

/**
 * 通用字体样式：简体中文/标题/小 - Bold 16/22
 */
export class TextHeadlineSmallAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_headline_small'));
    instance.fontWeight(FontWeight.Medium);
  }

}

/**
 * 通用字体样式：简体中文/次级标题/大 - Medium 18/26
 */
export class TextTitleLargeAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_title_large'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/中次级标题/中 - Medium 16/22
 */
export class TextTitleMediumAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_title_medium'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/小次级标题/小 - Medium 14/20
 */
export class TextTitleSmallAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_title_small'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/标签/大 - Medium 16/22
 */
export class TextLabelLargeAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_label_large'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/标签/中 - Medium 14/20
 */
export class TextLabelMediumAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_label_medium'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/标签/小 - Medium 12/16
 */
export class TextLabelSmallAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_label_small'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/标签/超小 - Medium 11/14
 */
export class TextLabelExtraSmallAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_label_small_extra'));
    instance.fontWeight(FontWeight.Regular);
  }

}

/**
 * 通用字体样式：简体中文/文本/大 - Regular 16/22
 */
export class TextBodyLargeAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_body_large'));
    instance.fontWeight(FontWeight.Normal);
  }

}

/**
 * 通用字体样式：简体中文/文本/中 - Regular 14/20
 */
export class TextBodyMediumAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_body_medium'));
    instance.fontWeight(FontWeight.Normal);
  }

}

/**
 * 通用字体样式：简体中文/文本/小  - Regular 12/16
 */
export class TextBodySmallAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_body_small'));
    instance.fontWeight(FontWeight.Normal);
  }

}

/**
 * 通用字体样式：简体中文/文本/超小  - Regular 11/14
 */
export class TextBodyExtraSmallAttributeModifier extends TextBaseAttributeModifier {

  applyNormalAttribute(instance: CommonTextFontAttribute): void {
    instance.fontSize($r('app.float.text_body_small_extra'));
    instance.fontWeight(FontWeight.Normal);
  }

}

export class TextSingleLineAttributeModifier implements AttributeModifier<TextAttribute> {
  private declare ellipsisMode: EllipsisMode;
  private declare maxLines: number;

  constructor(ellipsisMode: EllipsisMode = EllipsisMode.END, maxLines: number = 1) {
    this.ellipsisMode = ellipsisMode;
    this.maxLines = maxLines;
  }

  applyNormalAttribute(instance: TextAttribute): void {
    instance.maxLines(this.maxLines);
    instance.textOverflow({overflow: TextOverflow.Ellipsis});
    instance.ellipsisMode(this.ellipsisMode);
  }

}