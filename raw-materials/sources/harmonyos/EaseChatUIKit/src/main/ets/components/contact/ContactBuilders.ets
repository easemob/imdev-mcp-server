import { TextModel } from '../../model/builder/ComponentModel';
import { TextTitleSmallAttributeModifier } from '../../shares/attributeModifiers/TextAttributeModifiers';
import { LengthMetrics } from '@kit.ArkUI';

/**
 * 联系人条目条目自定义构建函数。
 * @param param
 */
@Builder
export function contactItemHeader(param: TextModel) {
  Text(param.content)
    .fontColor(param.fontColor ?? $r('app.color.chat_color_contact_item_header'))
    .padding({
      start: LengthMetrics.vp(16),
      top: 6,
      bottom: 6
    })
    .width(param.width ?? '100%')
    .height(param.height ?? 32)
    .backgroundColor(param.backgroundColor ?? $r('app.color.chat_color_background'))
    .attributeModifier(param.attributeModifier ?? new TextTitleSmallAttributeModifier())
}