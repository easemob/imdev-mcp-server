import { MessageItemCommonAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import { MessageUserCardModel } from '../../../model/builder/MessageComponentModel';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import {
  CornerRadiusExtraSmallAttributeModifier
} from '../../../shares/attributeModifiers/CornerRadiusAttrbuteModifiers';
import {
  TextBodyExtraSmallAttributeModifier,
  TextTitleMediumAttributeModifier
} from '../../../shares/attributeModifiers/TextAttributeModifiers';
import { avatarBuilder } from '../../../shares/builders/CommonBulders';
import { getUserCardAvatar, getUserCardNickname, isSender } from '../../../utils/MessageUtil';
import { MessageItemSentStatusView } from './../MessageComponents';

@ComponentV2
export struct MessageContactBubbleView {
  @Require @Param message: ChatKitMessage;
  @Param param: MessageUserCardModel = new MessageUserCardModel();
  private declare isSender: boolean;
  @Param onItemClick: (message: ChatKitMessage) => void = () => {
    //todo 添加跳转逻辑
  }
  @Consumer('on_error_icon_click') onErrorIconClick: (message: ChatKitMessage) =>void = message => {}
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  aboutToAppear(): void {
    this.isSender = isSender(this.message.origin) || this.param.isSender === true;
  }

  build() {
    Row() {
      if (isSender(this.message.origin)) {
        MessageItemSentStatusView({
          message: this.message,
          onErrorClick: this.onErrorIconClick
        })
        Blank(4)
      }
      Column() {
        Row() {
          avatarBuilder({
            src: getUserCardAvatar(this.message.origin) ?? $r('app.media.avatar_default'),
            width: 44,
            height: 44,
            attributeModifier: new CornerRadiusExtraSmallAttributeModifier()
          })

          Text(getUserCardNickname(this.message.origin))
            .fontColor(this.param.fontColor ?? (this.isSender ? $r('app.color.chat_color_text_primary_contrary') : $r('app.color.chat_color_text_primary')))
            .margin({
              left: 12
            })
            .attributeModifier(this.param.attributeModifier ?? new TextTitleMediumAttributeModifier())
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)

        Divider()
          .strokeWidth(0.5)
          .color(this.isSender ? $r('app.color.chat_color_message_user_card_send_divider') : $r('app.color.chat_color_message_user_card_receive_divider'))
          .margin({
            top: 12,
            bottom: 4
          })

        Text($r('app.string.contact'))
          .fontColor(this.param.secondFontColor ?? (this.isSender ? $r('app.color.chat_color_text_primary_contrary') : $r('app.color.chat_color_text_special')))
          .attributeModifier(this.param.secondAttributeModifier ?? new TextBodyExtraSmallAttributeModifier())
      }
      .padding({
        left: $r('app.float.message_item_voice_bubble_padding_max'),
        right: $r('app.float.message_item_voice_bubble_padding_max'),
        top: $r('app.float.message_item_voice_bubble_padding_max'),
        bottom: $r('app.float.message_item_voice_bubble_padding')
      })
      .alignItems(HorizontalAlign.Start)
      .width($r('app.float.message_item_user_card_width'))
      .height($r('app.float.message_item_user_card_height'))
      .attributeModifier(new MessageItemCommonAttributeModifier(this.isSender))
      .onClick(() => {
        if (this.onItemInnerClick && this.onItemInnerClick(this.message)) {
          return;
        }
        this.onItemClick(this.message);
      })
    }
    .alignItems(VerticalAlign.Bottom)
  }
}
