import uikit from '../../internal/ChatUIKit';
import { TextDateModel } from '../../model/builder/ComponentModel';
import { MessageAvatarModel } from '../../model/builder/MessageComponentModel';
import { ChatKitConversation } from '../../model/ChatKitConversation';
import { AvatarAttributeModifier } from '../../shares/attributeModifiers/AvatarAttributeModifier';
import { messageItemAvatarBuilder } from '../chat/MessageBuilders';
import { conversationItemDateBuilder, convItemTextBuilder, unreadCountPot } from './ConversationBuilders';
import { LengthMetrics } from '@kit.ArkUI';
import { getMessageTimestamp, isSender, isSentFailed } from '../../utils/MessageUtil';
import { CountStyle } from '../../model/Badge';
import { formatConversationDate } from '../../utils/DateUtil';
import {
  TextBodyMediumAttributeModifier,
  TextBodySmallAttributeModifier,
  TextSingleLineAttributeModifier,
  TextTitleMediumAttributeModifier
} from '../../shares/attributeModifiers/TextAttributeModifiers';
import { KitConstants } from '../../../../../Index';
import { ChatConvInfoManager } from '../../manager/ChatConvInfoManager';
import { StringUtil } from '../../utils/StringUtil';
import { MessageItemSentStatusView } from '../chat/MessageComponents';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { messageProviderManager } from '../../internal/manager/ChatMessageManager';
import { TextParseResult } from '../../internal/model/EmojiIcon';
import { getNumber } from '../../utils/CommonUtils';

@ComponentV2
export struct ConversationItemView {
  @Require @Param conversation: ChatKitConversation;
  @Monitor('conversation.latestMessage')
  onLatestMessageChange(monitor: IMonitor) {
    this.textParseResult = ChatConvInfoManager.getInstance().getLatestMessageParsedContent(this.conversation);
    this.messageContent = ChatConvInfoManager.getInstance().getLatestMessageContent(this.conversation.origin);
  }
  @Local textParseResult?: TextParseResult[];
  @Local messageContent: ResourceStr = '';
  @BuilderParam customAvatarBuilder: ($$: MessageAvatarModel) => void = messageItemAvatarBuilder;
  @BuilderParam customDateBuilder: ($$: TextDateModel) => void = conversationItemDateBuilder;

  aboutToAppear(): void {
    this.textParseResult = ChatConvInfoManager.getInstance().getLatestMessageParsedContent(this.conversation);
    this.messageContent = ChatConvInfoManager.getInstance().getLatestMessageContent(this.conversation.origin);
  }

  build() {
    Row({space: getNumber($r('app.float.chat_margin_common_large'))}) {
      this.customAvatarBuilder({
        src: this.conversation.getAvatar(),
        alignSelf: ItemAlign.Auto,
        margin: {bottom: 0},
        imageFit: ImageFit.Fill,
        attributeModifier: new AvatarAttributeModifier(uikit.configs.cornerStyle, $r('app.float.chat_icon_size_large'))
      })

      Column({space: 2}) {
        Row({space: 5}) {
          Row({space: 2}) {
            Text(this.conversation.getName())
              .fontColor($r('app.color.chat_color_conv_item_name'))
              .attributeModifier(new TextSingleLineAttributeModifier())
              .attributeModifier(new TextTitleMediumAttributeModifier())

            if (this.conversation.isMuted) {
              Image($r('app.media.chat_icon_conv_muted'))
                .width(20)
                .height(20)
                .objectFit(ImageFit.Fill)
            }
          }
          .layoutWeight(1)

          this.customDateBuilder({
            date: this.conversation.latestMessage !== undefined ? formatConversationDate(getMessageTimestamp(this.conversation.latestMessage)) : '',
            fontColor: $r('app.color.chat_color_conv_item_date'),
            attributeModifier: new TextBodySmallAttributeModifier()
          })
        }
        .width(KitConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Row(){
            if (this.conversation.hasMention) {
              Text($r("app.string.chat_conv_mention_self_flag"))
                .fontColor($r('app.color.chat_color_conv_item_mention'))
                .attributeModifier(new TextBodyMediumAttributeModifier())
            }
            if (this.conversation.latestMessage && isSender(this.conversation.latestMessage) && isSentFailed(this.conversation.latestMessage)) {
              MessageItemSentStatusView({
                message: new ChatKitMessage(this.conversation.latestMessage),
                iconSize: 14
              })
              Blank(4).constraintSize({
                maxWidth: 4
              })
            }
            if (messageProviderManager.hasCustomContent(this.conversation.latestMessage)) {
              convItemTextBuilder({
                content: messageProviderManager.getCustomContentInConversationItem(this.conversation.latestMessage)
              })
            } else {
              convItemTextBuilder({
                textParseResult: this.textParseResult,
                content: this.messageContent
              })
            }
          }
          .layoutWeight(1)
          .margin({
            end: LengthMetrics.vp(10)
          })

          unreadCountPot({
            count: this.conversation.unreadCount ?? 0,
            style: this.conversation.isMuted ? CountStyle.DOT : CountStyle.COUNT
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(KitConstants.FULL_WIDTH)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
    .height($r('app.float.conv_item_height'))
    .alignItems(VerticalAlign.Center)
    .backgroundColor(this.conversation.isPinned ? $r('app.color.chat_color_conv_item_bg_pinned') : $r('app.color.chat_color_conv_item_bg'))
    .stateStyles({
      clicked: {
        .backgroundColor($r('app.color.chat_color_conv_item_bg_pressed'))
      }
    })
    .padding({
      start: LengthMetrics.resource($r('app.float.chat_margin_common_large')),
      end: LengthMetrics.resource($r('app.float.chat_margin_common_large'))
    })
  }
}

@ComponentV2
export struct ConversationSearchItemView {
  @Require @Param conversation: ChatKitConversation;
  @Require @Param keyword: string;
  @BuilderParam customAvatarBuilder: ($$: MessageAvatarModel) => void = messageItemAvatarBuilder;

  build() {
    Row({space: getContext().resourceManager.getNumber($r('app.float.chat_margin_common_large'))}) {
      this.customAvatarBuilder({
        src: this.conversation.getAvatar(),
        alignSelf: ItemAlign.Auto,
        margin: {bottom: 0},
        imageFit: ImageFit.Fill,
        attributeModifier: new AvatarAttributeModifier(uikit.configs.cornerStyle, $r('app.float.chat_icon_size_large'))
      })

      Text() {
          ForEach(StringUtil.splitByKeyword(this.conversation.getName(), this.keyword), (item: string) => {
            if (item === this.keyword) {
              Span(item)
                .fontColor($r('app.color.chat_color_search_select_keyword'))
            } else {
              Span(item)
                .fontColor($r('app.color.chat_color_conv_item_name'))
            }
          })
        }
        .attributeModifier(new TextSingleLineAttributeModifier())
        .attributeModifier(new TextTitleMediumAttributeModifier())
    }
    .width('100%')
    .height($r('app.float.conv_item_height'))
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.chat_color_conv_item_bg_pinned'))
    .stateStyles({
      clicked: {
        .backgroundColor($r('app.color.chat_color_conv_item_bg_pressed'))
      }
    })
    .padding({
      start: LengthMetrics.resource($r('app.float.chat_margin_common_large')),
      end: LengthMetrics.resource($r('app.float.chat_margin_common_large'))
    })
  }
}