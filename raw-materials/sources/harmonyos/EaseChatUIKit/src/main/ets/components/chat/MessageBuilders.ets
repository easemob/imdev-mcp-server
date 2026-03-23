import { KitConstants } from '../../constants/KitConstants'
import { TextParseResult, TextParseType } from '../../internal/model/EmojiIcon'
import { getIconByMessageSentStatus } from '../../internal/utils/UIKitUtils'
import { ChatUserInfoManager } from '../../internal/manager/ChatUserInfoManager'
import { TextDateModel, TextModel } from '../../model/builder/ComponentModel'
import { MessageAvatarModel, MessageSentStatusModel, MessageTextModel } from '../../model/builder/MessageComponentModel'
import { MessageSentStatus } from '../../model/ComponentStatus'
import {
  TextBodyLargeAttributeModifier,
  TextBodySmallAttributeModifier,
  TextLabelSmallAttributeModifier
} from '../../shares/attributeModifiers/TextAttributeModifiers'
import { avatarBuilder, imageBuilder } from '../../shares/builders/CommonBulders'
import { getMessageContentFontColor, getMessageMentionInfo } from '../../utils/MessageUtil'

/**
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-builder-V5#builder函数里面使用的组件没有根节点包裹
 * 建议在@Builder组件需要用根结点包裹。
 */

/**
 * 日期文本自定义构建函数。
 *
 * 在uikit中用于消息条目的日期显示。
 *
 * @param { TextDateModel } param - 日期控制model
 */
@Builder
export function messageItemDateBuilder(param: TextDateModel) {

  Column() {
    Text(param.date)
      .fontColor(param.fontColor ?? $r('app.color.chat_color_message_item_date'))
      .attributeModifier(param.attributeModifier ?? new TextBodySmallAttributeModifier())
  }
  .alignRules({
    start: {anchor: 'barrier_message_avatar_end', align: HorizontalAlign.End},
    top: {anchor: 'message_item_bubble', align: VerticalAlign.Bottom}
  })
  .height($r('app.float.message_item_date_height'))
  .padding({
    top: $r('app.float.message_item_bubble_margin')
  })
  .id('message_item_date')

}

/**
 * 消息昵称自定义构建函数。
 * @param { TextModel } param - 文本控制model
 */
@Builder
export function messageItemNicknameBuilder(param: TextModel) {

  Column() {
    Text(param.content)
      .fontColor(param.fontColor ?? $r('app.color.chat_color_message_item_nickname'))
      .attributeModifier(param.attributeModifier ?? new TextLabelSmallAttributeModifier())
  }
  .alignRules({
    start: {anchor: 'barrier_message_avatar_end', align: HorizontalAlign.End},
  })
  .padding({
    bottom: $r('app.float.message_item_bubble_margin')
  })
  .id('message_item_nickname')

}

/**
 * 消息发送状态。
 * 包括：发送成功，发送中，发送失败，消息已送达，消息已被对方阅读
 * @param param
 */
@Builder
export function messageItemSentStatusBuilder(param: MessageSentStatusModel) {

  if (param.status === undefined || param.status === MessageSentStatus.PROGRESSING) {
    Column() {
      imageBuilder({
        src: $r('app.media.spinner'),
        width: param.width ?? 20,
        height: param.height ?? 20
      })
    }
    .justifyContent(FlexAlign.Center)
    .rotate({
      angle: param?.angle
    })
    .animation({
      duration: 1000,
      curve: Curve.Linear,
      iterations: -1,
      playMode: PlayMode.Normal,
    })
  } else {
    Column() {
      imageBuilder({
        src: getIconByMessageSentStatus(param.status),
        width: param.width ?? 20,
        height: param.height ?? 20
      })
    }
  }

}

/**
 * 消息条目头像自定义构建函数。
 * @param param
 */
@Builder
export function messageItemAvatarBuilder(param: MessageAvatarModel) {

  Column() {
    avatarBuilder({
      src: param.src,
      alt: param.alt ?? $r('app.media.avatar_default'),
      width: param.width,
      height: param.height,
      imageFit: param.imageFit,
      attributeModifier: param.attributeModifier
    })
  }
  .alignSelf(param.alignSelf ?? ItemAlign.End)
  .margin(param.margin ?? {
    bottom: $r('app.float.message_item_avatar_margin_bottom'),
    left: param.isSender ? $r('app.float.message_item_avatar_margin_end') : 0,
    right: param.isSender ? 0 : $r('app.float.message_item_avatar_margin_end')})

}

/**
 * 消息条目bubble箭头自定义构建函数
 * @param param
 */
@Builder
export function messageItemArrowBuilder(param: TextModel) {
  Path()
    .width(5)
    .height(8)
    .commands(`${param.content}`)
    .fillOpacity(1)
    .strokeLineJoin(LineJoinStyle.Round)
    .strokeLineCap(LineCapStyle.Round)
    .fill(param.fontColor ?? $r('app.color.chat_color_message_bubble_background'))
    .stroke(param.fontColor ?? $r('app.color.chat_color_message_bubble_background'))
    .strokeWidth(1)
}

/**
 * 消息条目文本内容自定义构建函数
 * @param param
 */
@Builder
export function messageItemTextBuilder(param: MessageTextModel) {
  Column() {
    if (param.textParseResult) {
      Text() {
        ForEach(param.textParseResult, (item: TextParseResult) => {
          if (item.parseType === TextParseType.Text) {
            if (param.hasMention) {
              ForEach(getMessageMentionInfo(item.text), (subItem: string) => {
                if (!param.isSender && (subItem === KitConstants.AT_PREFIX + KitConstants.AT_ALL_LABEL || subItem === KitConstants.AT_PREFIX + ChatUserInfoManager.getInstance().getCurrentUser().getNickname())) {
                  Span(subItem)
                    .fontColor($r('app.color.chat_color_text_primary_activated'))
                } else {
                  Span(subItem)
                }
              })
            } else {
              Span(item.text)
            }
          } else {
            if (typeof (item.emoji as ResourceStr) !== 'undefined') {
              ImageSpan(item.emoji as ResourceStr)
                .width(param.emojiSize ?? $r('app.float.text_body_large'))
                .height(param.emojiSize ?? $r('app.float.text_body_large'))
                .objectFit(ImageFit.Fill)
                .verticalAlign(ImageSpanAlignment.CENTER)
            }
          }
        })
      }
      .fontColor(param.fontColor ?? getMessageContentFontColor(param.isSender))
      .lineHeight(22)
      .attributeModifier(param.attributeModifier ?? new TextBodyLargeAttributeModifier())
    } else {
      Text(param.content)
        .fontColor(param.fontColor ?? getMessageContentFontColor(param.isSender))
        .lineHeight(22)
        .attributeModifier(param.attributeModifier ?? new TextBodyLargeAttributeModifier())
        .lineBreakStrategy(LineBreakStrategy.BALANCED)
    }
  }

}

@Builder
export function editMessageCheckboxBuilder(config: CheckBoxConfiguration) {
  Stack() {
    if (!config.selected) {
      Image($r('app.media.chat_checkbox_unselect'))
        .width(30)
        .height(30)
        .objectFit(ImageFit.Fill)
    } else {
      Button({type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL}) {
        Image($r('app.media.chat_checkbox_select'))
          .width(30)
          .height(30)
          .objectFit(ImageFit.Fill)
      }
    }
  }
}
