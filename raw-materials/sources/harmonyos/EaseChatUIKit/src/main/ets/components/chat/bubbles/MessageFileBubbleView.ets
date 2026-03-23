import { MessageItemCommonAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import { isRoundStyle } from '../../../internal/utils/UIKitUtils';
import { MessageFileModel } from '../../../model/builder/MessageComponentModel';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import {
  TextBodyMediumAttributeModifier,
  TextTitleMediumAttributeModifier
} from '../../../shares/attributeModifiers/TextAttributeModifiers';
import { MessageFileDownloadDialog } from '../../../shares/dialogs/MessageFileDownloadDialog';
import {
  getAttachmentInfo,
  getMessageContentFontColor,
  getMessageFileLengthStr,
  isSender
} from '../../../utils/MessageUtil';
import { MessageItemSentStatusView } from './../MessageComponents';

@ComponentV2
export struct MessageFileBubbleView {
  @Require @Param message: ChatKitMessage;
  @Param param: MessageFileModel = new MessageFileModel();
  private declare isSender: boolean;
  @Local messageId: string = '';
  @Param onItemClick: (message: ChatKitMessage) => void = () => {
    this.messageId = this.message.messageId;
    this.fileViewerDialog.open()
  }
  @Consumer('on_error_icon_click') onErrorIconClick: (message: ChatKitMessage) =>void = message => {}
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  private fileViewerDialog: CustomDialogController = new CustomDialogController({
    builder: MessageFileDownloadDialog({
      messageId: this.messageId
    }),
    cornerRadius: 0,
    alignment: DialogAlignment.Center,
    backgroundColor: Color.Black,
    height: 78,
    width: 94,
    customStyle: true
  })

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
      Row() {
        if (this.isSender) {
          Stack({alignContent: Alignment.Center}) {
            Image($r('app.media.message_file_icon'))
              .width(32)
              .height(32)
              .objectFit(ImageFit.Fill)
          }
          .width(44)
          .height(44)
          .borderRadius(isRoundStyle() ? 4 : 8)
          .backgroundColor($r('app.color.chat_color_message_file_icon_bg'))
          Blank(12)
        }

        Column() {
          Text(getAttachmentInfo(this.message)?.filename)
            .fontColor(this.param.fontColor ?? getMessageContentFontColor(this.isSender))
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.CENTER)
            .attributeModifier(this.param.attributeModifier ?? new TextTitleMediumAttributeModifier())
            .lineBreakStrategy(LineBreakStrategy.BALANCED)

          Text(getMessageFileLengthStr(getAttachmentInfo(this.message)?.fileLength))
            .fontColor(this.param.secondFontColor ?? this.isSender ? $r('app.color.chat_color_message_file_length_send') : $r('app.color.chat_color_message_file_length_receive'))
            .attributeModifier(this.param.secondAttributeModifier ?? new TextBodyMediumAttributeModifier())
            .lineBreakStrategy(LineBreakStrategy.BALANCED)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
        .layoutWeight(1)

        if (!this.isSender) {
          Blank(12)
          Stack({alignContent: Alignment.Center}) {
            Image($r('app.media.message_file_icon'))
              .width(32)
              .height(32)
              .objectFit(ImageFit.Fill)
          }
          .width(44)
          .height(44)
          .borderRadius(isRoundStyle() ? 4 : 8)
          .backgroundColor($r('app.color.chat_color_message_file_icon_bg'))
        }
      }
      .padding({
        left: $r('app.float.message_item_text_bubble_padding_horizontal'),
        right: $r('app.float.message_item_text_bubble_padding_horizontal'),
        top: $r('app.float.message_item_text_bubble_padding_vertical'),
        bottom: $r('app.float.message_item_text_bubble_padding_vertical')
      })
      .width($r('app.float.message_item_file_width'))
      .height($r('app.float.message_item_file_height'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .attributeModifier(new MessageItemCommonAttributeModifier(this.isSender))
      .constraintSize({
        maxWidth: $r('app.float.message_item_bubble_max_width')
      })
      .onClick(() => {
        if (this.onItemInnerClick && this.onItemInnerClick(this.message)) {
          return;
        }
        this.onItemClick(this.message)
      })
    }
    .alignItems(VerticalAlign.Bottom)
  }
}
