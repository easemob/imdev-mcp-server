import { KitConstants } from '../../../../../../Index';
import { MessageItemCommonAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import uikit from '../../../internal/ChatUIKit';
import { TextParseResult } from '../../../internal/model/EmojiIcon';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import { TextBodyExtraSmallAttributeModifier } from '../../../shares/attributeModifiers/TextAttributeModifiers';
import {
  contentParsed,
  isGroupMentionMessage,
  isRecalledMessage,
  isReplyMessage,
  isSender,
  parseMessageReplyInfo
} from '../../../utils/MessageUtil';
import { ChatMessageReplyView } from './../ChatComponents';
import { messageItemTextBuilder } from './../MessageBuilders';
import { MessageItemSentStatusView } from './../MessageComponents';

@ComponentV2
export struct MessageTextBubbleView {
  @Require @Param message: ChatKitMessage;
  @Monitor('message')
  onMessageChange(monitor: IMonitor) {
    this.getMessageContent();
    if (isReplyMessage(this.message)) {
      let result = parseMessageReplyInfo(this.message);
      this.replyInfo = result;
      if (result) {
        let msgId = result[KitConstants.REPLY_MSG_ID];
        let replyMsg = uikit.sdk.chatManager()?.getMessage(msgId);
        if (replyMsg) {
          this.replyMessage = new ChatKitMessage(replyMsg);
        }
      }
    }
  }
  @Monitor('message.operationCount')
  onOperationCountChange(monitor: IMonitor) {
    this.getMessageContent();
  }
  @Local replyMessage?: ChatKitMessage;
  @Local replyInfo?: Record<string, string>;
  @Local messageContent: TextParseResult[] | undefined;
  @Consumer('on_error_icon_click') onErrorIconClick: (message: ChatKitMessage) =>void = message => {}
  @Consumer('on_click_message_reply') onMessageReplyClick: (messageId: string) => void = messageId => {}
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  aboutToAppear(): void {
    if (isReplyMessage(this.message)) {
      let result = parseMessageReplyInfo(this.message);
      this.replyInfo = result;
      if (result) {
        let msgId = result[KitConstants.REPLY_MSG_ID];
        let replyMsg = uikit.sdk.chatManager()?.getMessage(msgId);
        if (replyMsg) {
          this.replyMessage = new ChatKitMessage(replyMsg);
        }
      }
    } else {
      this.replyInfo = undefined;
      this.replyMessage = undefined;
    }
    this.getMessageContent();
  }

  private getMessageContent() {
    this.messageContent = contentParsed(this.message.origin);
  }

  build() {
    Column() {
      if (isReplyMessage(this.message)) {
        ChatMessageReplyView({
          message: this.replyMessage,
          replyInfo: this.replyInfo,
          isSender: isSender(this.message.origin),
          onLostReplyContent: () => {
            this.replyInfo = undefined;
            this.replyMessage = undefined;
          }
        })
          .margin({
            bottom: 2
          })
          .constraintSize({
            maxWidth: $r('app.float.message_item_bubble_max_width')
          })
          .onClick(() => {
            if (this.replyMessage && !isRecalledMessage(this.replyMessage.origin)) {
              this.onMessageReplyClick?.(this.replyInfo?.[KitConstants.REPLY_MSG_ID] ?? '');
            }
          })
      }
      Row() {
        if (isSender(this.message.origin)) {
          MessageItemSentStatusView({
            message: this.message,
            onErrorClick: this.onErrorIconClick
          })
          Blank(4)
        }

        Column() {
          messageItemTextBuilder({
            textParseResult: this.messageContent,
            isSender: isSender(this.message.origin),
            hasMention: isGroupMentionMessage(this.message)
          })
          if (this.message.operationCount && this.message.operationCount > 0) {
            Text($r('app.string.chat_edit_message_flag'))
              .fontColor(isSender(this.message.origin) ? $r('app.color.chat_color_edit_message_send_flag') : $r('app.color.chat_color_edit_message_receive_flag'))
              .alignSelf(ItemAlign.End)
              .lineHeight(14)
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
        .attributeModifier(new MessageItemCommonAttributeModifier(isSender(this.message.origin), isReplyMessage(this.message)))
      }
      .alignItems(VerticalAlign.Bottom)
    }
    .onClick(()=> {
      this.onItemInnerClick?.(this.message);
    })
    .alignItems(isSender(this.message.origin) ? HorizontalAlign.End : HorizontalAlign.Start)
  }
}