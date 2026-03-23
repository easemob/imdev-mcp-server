import { MessageItemCommonAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import { TextBodyExtraSmallAttributeModifier } from '../../../shares/attributeModifiers/TextAttributeModifiers';
import { getString } from '../../../utils/CommonUtils';
import { getOperationCount, isSender } from '../../../utils/MessageUtil';
import { messageItemTextBuilder } from './../MessageBuilders';
import { ContentType } from '@easemob/chatsdk';

@Preview
@ComponentV2
export struct MessageUnknownBubbleView {
  @Require @Param message: ChatKitMessage;
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  build() {
    Column() {
      messageItemTextBuilder({
        content: getString($r('app.string.chat_msg_unknown_type'), ContentType[this.message.origin.getType()]),
        isSender: isSender(this.message.origin),
        fontColor: $r('app.color.chat_color_message_unknown_type')
      })
      if (getOperationCount(this.message.origin) > 0) {
        Text($r('app.string.chat_edit_message_flag'))
          .fontColor(isSender(this.message.origin) ? $r('app.color.chat_color_edit_message_send_flag') : $r('app.color.chat_color_edit_message_receive_flag'))
          .alignSelf(ItemAlign.End)
          .attributeModifier(new TextBodyExtraSmallAttributeModifier())
      }
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: $r('app.float.message_item_text_bubble_padding_horizontal'),
      right: $r('app.float.message_item_text_bubble_padding_horizontal'),
      top: $r('app.float.message_item_text_bubble_padding_vertical'),
      bottom: $r('app.float.message_item_text_bubble_padding_vertical')
    })
    .constraintSize({
      maxWidth: $r('app.float.message_item_bubble_max_width')
    })
    .onClick(()=> {
      this.onItemInnerClick?.(this.message);
    })
    .alignItems(isSender(this.message.origin) ? HorizontalAlign.End : HorizontalAlign.Start)
    .attributeModifier(new MessageItemCommonAttributeModifier(isSender(this.message.origin)))
  }
}