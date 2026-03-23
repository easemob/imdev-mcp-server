import { ChatMessage, DownloadStatus } from '@easemob/chatsdk';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { FileUtil } from '../../utils/FileUtil';
import { getAttachmentInfo, isLocalImageAccess } from '../../utils/MessageUtil';
import { showToast } from '../../utils/ToastUtil';
import { TextLabelMediumAttributeModifier } from '../attributeModifiers/TextAttributeModifiers';
import fileUri from '@ohos.file.fileuri';
import { ChatTransfer, CommonError } from '../../internal/ChatTransfer';
import uikit from '../../internal/ChatUIKit';

/*
  图片查看器
 */
@CustomDialog
export struct MessageFileDownloadDialog {
  controller?: CustomDialogController
  @Require @BuilderParam messageId: string;
  @State localPath: string | undefined = undefined;
  @State progress: number = 0
  @State angle: number = 0;
  @State showLoading: boolean = false;

  aboutToAppear(): void {
    const message = uikit.sdk.chatManager()?.getMessage(this.messageId);
    if (!message) {
      this.controller?.close();
    } else {
      if (isLocalImageAccess(message)) {
        this.showLoading = false;
        this.openFilePreview(message);
      } else {
        this.showLoading = true;
        this.downloadAttachment(message);
      }
    }
  }

  private openFilePreview(message: ChatMessage) {
    let attachment = getAttachmentInfo(message);
    if (!attachment) {
      showToast({
        message: "Not get the attachment infomation!"
      })
      return;
    }
    this.localPath = attachment?.localPath;
    let localUri:string;
    if (FileUtil.isUri(this.localPath)) {
      localUri = this.localPath;
    } else {
      localUri = fileUri.getUriFromPath(this.localPath);
    }
    FileUtil.openFilePreview(getContext(), localUri, attachment.filename).then(() => {
      this.controller?.close();
    }).catch((e: CommonError) => {
      const error = ChatTransfer.transferError(e);
      showToast({
        message: 'open file preview failed: ' + error.description
      })
      this.controller?.close();
    })
  }

  private downloadAttachment(message: ChatMessage) {
    let msg = new ChatKitMessage(message);
    message.setMessageStatusCallback({
      onSuccess: () => {
        this.showLoading = false;
        this.openFilePreview(message);
      },
      onError: (code: number, error: string) => {
        showToast({
          message: $r('app.string.download_file_error_tips')+": " + error
        })
        this.controller?.close();
      },
      onProgress: (progress: number) => {
        this.progress = progress;
      }
    })
    if (msg.attachmentDownloadStatus !== DownloadStatus.DOWNLOADING) {
      uikit.sdk.chatManager()?.downloadAttachment(message);
    }
  }

  build() {
    if (this.showLoading) {
      Column() {

        Image($r('app.media.spinner'))
          .width(36)
          .height(36)
          .fillColor($r('app.color.chat_color_background'))
          .rotate({
            angle: this.angle
          })
          .animation({
            duration: 1000,
            curve: Curve.Linear,
            iterations: -1,
            playMode: PlayMode.Normal,
          })
          .margin({
            bottom: 4
          })


        Text($r('app.string.downloading_tips'))
          .fontColor($r('app.color.chat_color_text_primary_contrary'))
          .attributeModifier(new TextLabelMediumAttributeModifier())
      }
      .width(94)
      .height(78)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius($r('app.float.corner_radius_medium'))
      .backgroundColor('#59000000')
      .onAppear(() => {
        this.angle = 360;
      })
      .onClick(()=> {
        this.controller?.close();
      })
    }
  }
}