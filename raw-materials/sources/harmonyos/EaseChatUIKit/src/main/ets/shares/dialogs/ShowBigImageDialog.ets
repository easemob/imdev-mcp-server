import { ChatMessage } from '@easemob/chatsdk';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { ShowBigImagePage } from '../../components/ShowBigImageView';
import { getImageAttachmentResource, isLocalImageAccess } from '../../utils/MessageUtil';
import { showToast } from '../../utils/ToastUtil';
import { TextHeadlineMediumAttributeModifier } from '../attributeModifiers/TextAttributeModifiers';
import uikit from '../../internal/ChatUIKit';

/*
  图片查看器
 */
@CustomDialog
export struct ShowBigImageDialog {
  controller?: CustomDialogController
  @Require @BuilderParam messageId: string;
  @State localPath: ResourceStr | undefined = undefined;
  @State showLoading: boolean = false;
  @State progress: number = 0

  aboutToAppear(): void {
    const message = uikit.sdk.chatManager()?.getMessage(this.messageId);
    if (!message) {
      this.controller?.close();
    } else {
      if (isLocalImageAccess(message)) {
        this.localPath = getImageAttachmentResource(new ChatKitMessage(message));
        this.showLoading = false;
      } else {
        this.showLoading = true;
        this.downloadAttachment(message);
      }
    }
  }

  private downloadAttachment(message: ChatMessage) {
    message.setMessageStatusCallback({
      onSuccess: () => {
        this.showLoading = false;
        this.localPath = getImageAttachmentResource(new ChatKitMessage(message));
      },
      onError: (code: number, error: string) => {
        showToast({
          message: $r('app.string.download_image_error_tips')+": " + error
        })
      },
      onProgress: (progress: number) => {
        this.progress = progress;
      }
    })
    uikit.sdk.chatManager()?.downloadAttachment(message);
  }

  build() {
    Column() {
      if (this.showLoading) {
        Column() {
          Text($r('app.string.downloading_image_tips'))
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
        ShowBigImagePage({
          imageUri: this.localPath
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