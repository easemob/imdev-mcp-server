import { MessageImageModel } from '../../../model/builder/MessageComponentModel';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import { imageBuilder } from '../../../shares/builders/CommonBulders';
import {
  getImageAttachmentResource,
  getImageShowSize,
  getMsgDownloadThumbnailEvent,
  isSender
} from '../../../utils/MessageUtil';
import { MessageItemSentStatusView } from './../MessageComponents';
import { ChatError, ChatLog } from '@easemob/chatsdk';
import { EventBus } from '../../../utils/EventBus';
import { MessageItemImageAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import { kitMedia } from '../../../manager/MediaManager';
import { ShowBigImageDialog } from '../../../shares/dialogs/ShowBigImageDialog';

@ComponentV2
export struct MessageImageBubbleView {
  @Require @Param message: ChatKitMessage;
  @Param param: MessageImageModel = new MessageImageModel();
  @Local imageWidth: Length = $r('app.float.message_item_image_default_size');
  @Local imageHeight: Length = $r('app.float.message_item_image_default_size');
  @Local imageLocalResource: ResourceStr | undefined = undefined;
  @Param onItemClick: (message: ChatKitMessage) => void = () => {
    kitMedia.openImageDialog(new CustomDialogController({
      builder: ShowBigImageDialog({
        messageId: this.message.messageId
      }),
      cornerRadius: 0,
      alignment: DialogAlignment.Center,
      backgroundColor: Color.Black,
      backgroundBlurStyle: BlurStyle.NONE,
      height: '100%',
      width: '100%',
      customStyle: true
    }));
  }
  @Monitor('message', 'message.attachmentDownloadStatus', 'message.thumbnailDownloadStatus')
  onAttachmentChange(monitor: IMonitor) {
    this.getImageSize();
    this.getImageLocalResource();
  }
  @Consumer('on_error_icon_click') onErrorIconClick: (message: ChatKitMessage) =>void = message => {}
  @Consumer("click_media_message") onMediaClick: (message: ChatKitMessage) => void = message => {};
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  private getImageSize() {
    getImageShowSize(this.message.origin).then((size) => {
      this.imageWidth = size.width;
      this.imageHeight = size.height;
    }).catch((e: ChatError) => {
      ChatLog.e('getImageSize: '+e.description);
      this.imageWidth = $r('app.float.message_item_image_default_size');
      this.imageHeight = $r('app.float.message_item_image_default_size');
    })
  }

  private getImageLocalResource() {
    this.imageLocalResource = getImageAttachmentResource(this.message, (messageId: string) => {
      new EventBus().emit(getMsgDownloadThumbnailEvent(), messageId);
    });
  }

  aboutToAppear(): void {
    this.getImageSize();
    this.getImageLocalResource();
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
      if (this.imageLocalResource) {
        imageBuilder({
          src: this.imageLocalResource,
          width: this.imageWidth,
          height: this.imageHeight,
          attributeModifier: this.param.attributeModifier ?? new MessageItemImageAttributeModifier()
        })
      } else {
        imageBuilder({
          src: $r("app.media.quote_default_image_icon"),
          width: this.imageWidth,
          height: this.imageHeight,
        })
      }
    }
    .alignItems(VerticalAlign.Bottom)
    .onClick(() => {
      this.onMediaClick(this.message);
      if (this.onItemInnerClick && this.onItemInnerClick(this.message)) {
        return;
      }
      this.onItemClick(this.message);
    })
  }
}