import { KitConstants } from '../../../constants/KitConstants';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import { TextLabelSmallAttributeModifier } from '../../../shares/attributeModifiers/TextAttributeModifiers';
import { formatMessageDate } from '../../../utils/DateUtil';
import { getMessageContent, getMessageTimestamp, isSender } from '../../../utils/MessageUtil';
import { messageItemDateBuilder, messageItemTextBuilder } from './../MessageBuilders';

@Preview
@ComponentV2
export struct MessageUnsentView {
  @Require @Param message: ChatKitMessage;

  build() {
    Column({space: 5}) {
      messageItemDateBuilder({ date: formatMessageDate(getMessageTimestamp(this.message.origin)) })
      messageItemTextBuilder({
        content: getMessageContent(this.message.origin),
        isSender: isSender(this.message.origin),
        fontColor: $r('app.color.chat_color_message_unsent_text'),
        attributeModifier: new TextLabelSmallAttributeModifier()
      })
    }
    .alignItems(HorizontalAlign.Center)
    .padding({
      bottom: $r('app.float.message_item_text_bubble_padding_vertical')
    })
    .width(KitConstants.FULL_WIDTH)
  }
}