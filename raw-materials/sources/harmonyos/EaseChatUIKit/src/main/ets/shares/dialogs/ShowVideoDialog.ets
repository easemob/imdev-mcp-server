import { ChatMessage, DownloadStatus } from '@easemob/chatsdk';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { getAttachmentInfo, isLocalImageAccess } from '../../utils/MessageUtil';
import { showToast } from '../../utils/ToastUtil';
import { TextHeadlineMediumAttributeModifier } from '../attributeModifiers/TextAttributeModifiers';
import { ShowVideoView } from '../../components/ShowVideoView';
import uikit from '../../internal/ChatUIKit';

/*
  图片查看器
 */
@CustomDialog
export struct ShowVideoDialog {
  controller?: CustomDialogController
  @Require @BuilderParam messageId: string;
  @State localPath: string | undefined = undefined;
  @State showLoading: boolean = false;
  @State progress: number = 0

  aboutToAppear(): void {
    const message = uikit.sdk.chatManager()?.getMessage(this.messageId);
    if (!message) {
      this.controller?.close();
    } else {
      if (isLocalImageAccess(message)) {
        this.localPath = getAttachmentInfo(message)?.localPath;
        this.showLoading = false;
      } else {
        this.showLoading = true;
        this.downloadAttachment(message);
      }
    }
  }

  private downloadAttachment(message: ChatMessage) {
    let msg = new ChatKitMessage(message);
    message.setMessageStatusCallback({
      onSuccess: () => {
        this.showLoading = false;
        this.localPath = getAttachmentInfo(message)?.localPath;
      },
      onError: (code: number, error: string) => {
        showToast({
          message: $r('app.string.download_video_error_tips')+": " + error
        })
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
    Column() {
      if (this.showLoading) {
        Column() {
          Text($r('app.string.downloading_video_tips'))
            .fontColor($r('app.color.chat_color_text_primary_contrary'))
            .attributeModifier(new TextHeadlineMediumAttributeModifier())

          Progress({value: this.progress, total: 100, type:ProgressType.Linear})
            .style({strokeWidth: 10, enableSmoothEffect: true})
            .color($r('app.color.chat_color_component_normal'))
            .width('80%')
            .margin({
              top: 20
            })
        }
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Black)
      } else {
        ShowVideoView({
          videoUrl: this.localPath,
          onCompleteCallback: () => {
            this.controller?.close();
          }
        });
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onClick(()=> {
      this.controller?.close();
    })
  }
}