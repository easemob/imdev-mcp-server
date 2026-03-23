import { TextDateModel, TextModel } from '../../model/builder/ComponentModel';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import {
  messageItemArrowBuilder,
  messageItemAvatarBuilder,
  messageItemDateBuilder,
  messageItemNicknameBuilder
} from './MessageBuilders';
import {
  filterMessageMenu,
  getMessageTimestamp,
  isGroupChat,
  isSender,
  isUserCardMessage
} from '../../utils/MessageUtil';
import { ContentType, MessageStatus } from '@easemob/chatsdk';
import { MessageAvatarModel } from '../../model/builder/MessageComponentModel';
import { MessageVoiceBubbleView } from './bubbles/MessageVoiceBubbleView';
import { booleanDefault, getIconByMessageSentStatus, getMessageSentStatus } from '../../internal/utils/UIKitUtils';
import { MessageImageBubbleView } from './bubbles/MessageImageBubbleView';
import { MessageVideoBubbleView } from './bubbles/MessageVideoBubbleView';
import uikit from '../../internal/ChatUIKit';
import { CornerStyle } from '../../model/CornerStyle';
import { MessageFileBubbleView } from './bubbles/MessageFileBubbleView';
import { MessageContactBubbleView } from './bubbles/MessageContactBubbleView';
import { MessageMenuItem } from '../../model/Menu';
import { MenuItemView } from '../../shares/components/CommonComponents';
import { TextLabelSmallAttributeModifier } from '../../shares/attributeModifiers/TextAttributeModifiers';
import { MessageTextBubbleView } from './bubbles/MessageTextBubbleView';
import { formatMessageDate } from '../../utils/DateUtil';
import { ChatUserInfoManager } from '../../internal/manager/ChatUserInfoManager';
import { MessageUnknownBubbleView } from './bubbles/MessageUnknownBubbleView';
import { messageProviderManager } from '../../internal/manager/ChatMessageManager';
import { imageBuilder } from '../../shares/builders/CommonBulders';
import { MessageSentStatus } from '../../model/ComponentStatus';

@ComponentV2
export struct MessageItemView {
  @Require @Param message: ChatKitMessage;
  @Monitor('message.isReplyResponse')
  onResponseReply(monitor: IMonitor) {
    if (this.message.isReplyResponse) {
      this.bgColor = $r('app.color.chat_color_sub_background')
    }
  }
  @BuilderParam customAvatarBuilder: ($$: MessageAvatarModel) => void = messageItemAvatarBuilder;
  @BuilderParam customNicknameBuilder: ($$: TextModel) => void = messageItemNicknameBuilder;
  @BuilderParam customDateBuilder: ($$: TextDateModel) => void = messageItemDateBuilder;
  @BuilderParam customMessageContent: () => void = this.messageItemContentBuilder;
  @Local messageMenus: MessageMenuItem[] = [];
  @Local bgColor: ResourceColor = Color.Transparent;
  @Local longMenusWidth?: Length;
  @Consumer("message_item_menus_provider") messageItemMenusInnerProvider: (message: ChatKitMessage) => MessageMenuItem[] = message => [];

  @Builder
  messageItemMenuBuilder() {
    Flex({wrap: FlexWrap.Wrap, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start}) {
      ForEach(this.messageMenus, (item: MessageMenuItem, index) => {
        GridCol() {
          MenuItemView({
            menu: item,
            isVertical: true,
            menuWidth: 68,
            menuHeight: 58,
            iconOutBtnWidth: $r('app.float.chat_menu_item_icon_large_size'),
            iconOutBtnHeight: $r('app.float.chat_menu_item_icon_large_size'),
            iconOutBtnBackgroundColor: Color.Transparent,
            iconOutBtnBorderRadius: 0,
            iconParam: {
              width: $r('app.float.chat_menu_item_icon_large_size'),
              height: $r('app.float.chat_menu_item_icon_large_size')
            },
            textParam: {
              attributeModifier: new TextLabelSmallAttributeModifier(),
            }
          })
            .onClick(() => {
              item.onMenuClick?.(item.id, this.message);
            })
        }
      },  (item: MessageMenuItem) => {
        return item.id + '';
      })
    }
    .onSizeChange((oldV, newV) => {
      // 为了解决设置Flex宽度随条目数变化动态调节的问题
      let totalW = this.messageMenus.length * 68;
      let width = newV.width as number;
      let height = newV.height as number;
      if (width > totalW) {
        this.longMenusWidth = totalW;
      }
      if (height > 58 * 2) {
        let number = Math.floor(width / 68);
        this.longMenusWidth = number * 68;
      }
    })
    .width(this.longMenusWidth ?? 'auto')
    .layoutWeight(this.longMenusWidth === undefined ? 1 : 0)
    .padding({
      top: 12,
      bottom: 12
    })
  }

  @Builder
  messageItemContentBuilder() {

    Column() {
      MessageContentView({message: this.message})
        .bindContextMenu(this.messageItemMenuBuilder(), ResponseType.LongPress, {
          enableArrow: true,
          placement: isSender(this.message.origin) ? Placement.TopRight : Placement.TopLeft,
          aboutToAppear: () => {
            let messageMenus = this.messageItemMenusInnerProvider(this.message);
            this.messageMenus = filterMessageMenu(messageMenus, this.message.origin);
          },
          backgroundColor: $r('sys.color.background_primary'),
          borderRadius: $r('app.float.corner_radius_small_extra')
        })
    }
    .alignRules({
      start: { anchor: '__container__', align: HorizontalAlign.Start },
      top: { anchor: 'message_item_nickname', align: VerticalAlign.Bottom },
      bias: {horizontal: 0}
    })
    .id('message_item_bubble')

  }

  build() {
    Row() {
      if (!isSender(this.message.origin)) {
        this.customAvatarBuilder({ src: ChatUserInfoManager.getInstance().getAvatar(this.message.origin), isSender: false })
      }
      RelativeContainer() {
        if (isGroupChat(this.message) &&
          ((!isSender(this.message.origin) && uikit.configs.chatConfigs?.showReceiverNickname) ||
          (isSender(this.message.origin) && uikit.configs.chatConfigs?.showSenderNickname))
        ) {
          this.customNicknameBuilder({ content: ChatUserInfoManager.getInstance().getNickname(this.message.origin) })
        }

        this.customMessageContent()

        this.customDateBuilder({ date: formatMessageDate(getMessageTimestamp(this.message.origin)) })
      }
      .direction(isSender(this.message.origin) ? Direction.Rtl : Direction.Ltr)
      .layoutWeight(1)
      .height('auto')

      if (isSender(this.message.origin) && booleanDefault(uikit.configs.chatConfigs?.showSelfAvatar)) {
        this.customAvatarBuilder({ src: ChatUserInfoManager.getInstance().getAvatar(this.message.origin), isSender: true })
      }
    }
    .padding({
      left: isSender(this.message.origin) ? 0 : $r('app.float.message_item_padding_start'),
      right: isSender(this.message.origin)? $r('app.float.message_item_padding_start') : 0
    })
    .backgroundColor(this.message.isReplyResponse ? this.bgColor : Color.Transparent)
    .animation({
      duration: this.message.isReplyResponse ? 500 : 0,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: ()=> {
        this.message.isReplyResponse = false;
      }
    })
  }

}

@ComponentV2
export struct MessageContentView {
  @Require @Param message: ChatKitMessage;
  @Local command: string = '';
  @Local contentType: ContentType | undefined;
  @Monitor('message')
  onMessageChange(monitor: IMonitor) {
    this.contentType = this.message.origin.getType();
  }

  private getPathY(bubbleHeight: Length | undefined, value: number) {
    return bubbleHeight ? vp2px(bubbleHeight as number - value) : vp2px(value);
  }

  private getPathX(bubbleWidth: Length | undefined, value: number) {
    return bubbleWidth ? vp2px(bubbleWidth as number + value) : vp2px(value);
  }

  aboutToAppear(): void {
    this.contentType = this.message.origin.getType();
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {

      if (uikit.configs.cornerStyle === CornerStyle.ROUND && (this.message.origin.getType() === ContentType.TXT ||
        this.message.origin.getType() === ContentType.VOICE ||
        this.message.origin.getType() === ContentType.FILE || isUserCardMessage(this.message.origin))) {
        messageItemArrowBuilder({
          content: this.command,
          fontColor: isSender(this.message.origin) ? $r('app.color.chat_color_message_bubble_send_background') : $r('app.color.chat_color_message_bubble_background')
        })
      }

      if (messageProviderManager.hasCustomBubbleNode(this.message)) {
        NodeContainer(messageProviderManager.provideMessageBubbleNodeController(this.getUIContext(), this.message))
      } else {
        if (this.contentType === ContentType.TXT) {
          MessageTextBubbleView({
            message: this.message
          })
        } else if (this.contentType === ContentType.IMAGE) {
          MessageImageBubbleView({
            message: this.message
          })
        } else if (this.contentType === ContentType.VIDEO) {
          MessageVideoBubbleView({
            message: this.message
          })
        } else if (this.contentType === ContentType.VOICE) {
          MessageVoiceBubbleView({
            message: this.message
          })
        } else if (this.contentType === ContentType.FILE) {
          MessageFileBubbleView({
            message: this.message
          })
        } else if (isUserCardMessage(this.message.origin)) {
          MessageContactBubbleView({
            message: this.message
          })
        } else {
          // 默认：以文本形式展示消息类型，例如：不支持的消息类型：CUSTOM
          MessageUnknownBubbleView({
            message: this.message
          })
        }
      }

    }
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions)=> {
      const bubbleHeight = newValue.height;
      const bubbleWidth = newValue.width;
      if (isSender(this.message.origin)) {
        this.command = `M${this.getPathX(bubbleWidth, 0)} ${this.getPathY(bubbleHeight, 18)} L${this.getPathX(bubbleWidth, 5)} ${this.getPathY(bubbleHeight, 10) - vp2px(4)} L${this.getPathX(bubbleWidth, 0)} ${this.getPathY(bubbleHeight, 10)} Z`
      } else {
        this.command = `M-${vp2px(5)} ${this.getPathY(bubbleHeight, 10) - vp2px(4)} L0 ${this.getPathY(bubbleHeight, 18)} L0 ${this.getPathY(bubbleHeight, 10)} Z`
      }
    })
  }

}

@ComponentV2
export struct MessageItemSentStatusView {
  @Require @Param message: ChatKitMessage;
  @Param iconSize: number = 20;
  @Local angel: number = 0;
  @Local messageSentStatus: MessageSentStatus = MessageSentStatus.SUCCESS;
  @Monitor('message', 'message.status', 'message.isDelivered', 'message.isReceiverRead')
  onMessageSentStatus(monitor: IMonitor) {
    this.messageSentStatus = getMessageSentStatus(this.message.origin);
  }
  @Event onErrorClick: (message: ChatKitMessage) => void;

  aboutToAppear(): void {
    this.messageSentStatus = getMessageSentStatus(this.message.origin);
    if (this.messageSentStatus === MessageSentStatus.PROGRESSING) {
      this.message.origin.setMessageStatusCallback({
        onSuccess: () => {
          this.message.update();
        },
        onError: () => {
          this.message.update();
        }
      })
    }
  }

  showRotateAnimator() {
    animateTo({
      duration: 1000,
      curve: Curve.Linear,
      playMode: PlayMode.Normal,
      iterations: -1
    }, () => {
      this.angel = this.angel + 360;
    })
  }

  build() {
    Column() {
      if (this.messageSentStatus === MessageSentStatus.PROGRESSING) {
        Column() {
          imageBuilder({
            src: $r('app.media.spinner'),
            width: this.iconSize,
            height: this.iconSize
          })
        }
        .justifyContent(FlexAlign.Center)
        .rotate({
          angle: this.angel
        })
        .onAppear(() => {
          this.showRotateAnimator();
        })
      } else {
        imageBuilder({
          src: getIconByMessageSentStatus(this.messageSentStatus),
          width: this.iconSize,
          height: this.iconSize
        })
      }
    }
    .onClick(()=> {
      if (this.message.status === MessageStatus.FAIL || this.message.status === MessageStatus.CREATE) {
        this.onErrorClick?.(this.message);
      }
    })
  }

}
