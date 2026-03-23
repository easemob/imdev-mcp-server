import { TextParseResult, TextParseType } from '../../internal/model/EmojiIcon'
import { CountStyle } from '../../model/Badge'
import { CountModel, TextDateModel } from '../../model/builder/ComponentModel'
import { MessageTextModel } from '../../model/builder/MessageComponentModel'
import {
  TextBodyMediumAttributeModifier,
  TextLabelSmallAttributeModifier,
  TextSingleLineAttributeModifier
} from '../../shares/attributeModifiers/TextAttributeModifiers'
import { unreadCount } from '../../utils/ConvUtil'
import { messageItemDateBuilder } from '../chat/MessageBuilders'

/**
 * 日期文本自定义构建函数。
 *
 * 在uikit中用于会话条目的日期显示。
 *
 * @param { TextDateModel } param - 日期控制model
 */
@Builder
export function conversationItemDateBuilder(param: TextDateModel) {
  messageItemDateBuilder(param)
}

@Builder
export function unreadCountPot(param: CountModel) {
  if (param.style === undefined || param.style === CountStyle.COUNT) {
    Button({type: ButtonType.Capsule, buttonStyle: ButtonStyleMode.TEXTUAL}) {
      Text(unreadCount(param.count, param.maxCount))
        .fontColor(param.fontColor ?? $r('app.color.chat_color_text_primary_contrary'))
        .padding({left: 6, right: 6})
        .attributeModifier(param.attributeModifier ?? new TextLabelSmallAttributeModifier())
    }
    .height(param.height ?? 18)
    .constraintSize({
      minWidth: param.height ?? 18
    })
    .visibility(param.count === 0 ? Visibility.Hidden : Visibility.Visible)
    .backgroundColor(param.backgroundColor ?? $r('app.color.chat_color_primary'))
  } else {
    Button({type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL})
    .height(param.height ?? 8)
    .visibility(param.count === 0 ? Visibility.Hidden : Visibility.Visible)
    .backgroundColor(param.backgroundColor ?? $r('app.color.chat_color_primary'))
  }
}

/**
 * 会话条目内容自定义构建函数
 * @param param
 */
@Builder
export function convItemTextBuilder(param: MessageTextModel) {
  Column() {
    if (param.textParseResult) {
      Text() {
        ForEach(param.textParseResult, (item: TextParseResult) => {
          if (item.parseType === TextParseType.Text) {
            Span(item.text)
          } else {
            if (typeof (item.emoji as ResourceStr) !== 'undefined') {
              ImageSpan(item.emoji as ResourceStr)
                .width(param.emojiSize ?? $r('app.float.text_body_medium'))
                .height(param.emojiSize ?? $r('app.float.text_body_medium'))
                .objectFit(ImageFit.Fill)
                .verticalAlign(ImageSpanAlignment.CENTER)
            }
          }
        })
      }
      .fontColor(param.fontColor ?? $r('app.color.chat_color_conv_item_message'))
      .attributeModifier(new TextSingleLineAttributeModifier())
      .attributeModifier(param.attributeModifier ?? new TextBodyMediumAttributeModifier())
    } else {
      Text(param.content)
        .fontColor(param.fontColor ?? $r('app.color.chat_color_conv_item_message'))
        .attributeModifier(new TextSingleLineAttributeModifier())
        .attributeModifier(param.attributeModifier ?? new TextBodyMediumAttributeModifier())
        .lineBreakStrategy(LineBreakStrategy.BALANCED)
    }
  }

}