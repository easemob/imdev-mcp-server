import { MessageItemCommonAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import audioPlayer from '../../../internal/manager/AudioPlayerManager';
import { MessageBubbleModel, MessageTextModel } from '../../../model/builder/MessageComponentModel';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import { TextBodyLargeAttributeModifier } from '../../../shares/attributeModifiers/TextAttributeModifiers';
import { getVoiceBubbleWidth, getVoiceLengthStr, isSender, setVoiceMessageListened } from '../../../utils/MessageUtil';
import { MessageItemSentStatusView } from './../MessageComponents';
import { LengthMetrics } from '@kit.ArkUI';

@ComponentV2
export struct MessageVoiceBubbleView {
  @Require @Param message: ChatKitMessage;
  @Monitor('message')
  onMessageChange(iMonitor: IMonitor) {
    this.voiceResource = $r('app.media.message_voice_receive');
    this.isSender = isSender(this.message.origin) || this.param.isSender === true;
    if (this.isSender) {
      this.voiceResource = $r('app.media.message_voice_send');
    }
  }
  @Param param: MessageBubbleModel = new MessageTextModel();
  private declare isSender: boolean;
  @Local voiceResource: Resource = $r('app.media.message_voice_receive');
  @Local state: AnimationStatus = AnimationStatus.Initial
  private animatorDuration: number = 600;
  @Consumer('on_error_icon_click') onErrorIconClick: (message: ChatKitMessage) =>void = message => {}
  @Consumer("click_media_message") onMediaClick: (message: ChatKitMessage) => void = message => {};
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  aboutToAppear(): void {
    this.isSender = isSender(this.message.origin) || this.param.isSender === true;
    if (this.isSender) {
      this.voiceResource = $r('app.media.message_voice_send');
    }
  }

  aboutToDisappear(): void {
    this.stopVoice();
  }

  private async stopVoice() {
    if (audioPlayer.isPlaying()) {
      const msgId = this.message.messageId;
      const playingId: string | undefined = audioPlayer.getPlayingVoiceId();
      if (msgId === playingId) {
        this.state = AnimationStatus.Initial;
        await audioPlayer.stopPlay();
      }
    }
  }

  private async playVoice() {
    const msgId = this.message.messageId;
    if (audioPlayer.isPlaying()) {
      this.state = AnimationStatus.Initial;
      const playingId: string | undefined = audioPlayer.getPlayingVoiceId();
      await audioPlayer.stopPlay();
      if (msgId === playingId) {
        return;
      }
    } else {
      this.state = AnimationStatus.Running;
      setVoiceMessageListened(this.message.origin);
      this.message.update();
      audioPlayer.playVoice(this.message.origin, () => {
        this.state = AnimationStatus.Initial;
      });
    }
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
          this.voiceLengthTextBuilder()

          this.voiceAnimatorBuilder()

        } else {
          this.voiceAnimatorBuilder()

          this.voiceLengthTextBuilder()
        }
      }
      .padding({
        left: this.isSender ? $r('app.float.message_item_voice_bubble_padding_max') : $r('app.float.message_item_voice_bubble_padding'),
        right: this.isSender ? $r('app.float.message_item_voice_bubble_padding') : $r('app.float.message_item_voice_bubble_padding_max'),
        top: $r('app.float.message_item_voice_bubble_padding'),
        bottom: $r('app.float.message_item_voice_bubble_padding')
      })
      .constraintSize({
        maxWidth: $r('app.float.message_item_voice_width_60s')
      })
      .width(getVoiceBubbleWidth(this.message.origin))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .attributeModifier(new MessageItemCommonAttributeModifier(this.isSender))
      .onClick(()=> {
        this.onMediaClick(this.message);
        if (this.onItemInnerClick && this.onItemInnerClick(this.message)) {
          return;
        }
        this.playVoice();
      })
      if (!this.isSender && !this.message.isListened) {
        Circle({
          width: 8,
          height: 8
        })
          .fill($r('app.color.chat_color_warning'))
          .margin({
            start: LengthMetrics.vp(8)
          })
          .alignSelf(ItemAlign.Center)
      }
    }
    .alignItems(VerticalAlign.Bottom)
  }

  @Builder
  voiceLengthTextBuilder() {
    Text(getVoiceLengthStr(this.message.origin) ?? "")
      .fontColor((this.param as MessageTextModel).fontColor ?? (this.isSender ? $r('app.color.chat_color_text_primary_contrary') : $r('app.color.chat_color_text_primary')))
      .attributeModifier((this.param as MessageTextModel).attributeModifier ?? new TextBodyLargeAttributeModifier())
      .lineBreakStrategy(LineBreakStrategy.BALANCED)
  }

  @Builder
  voiceAnimatorBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      Image(this.voiceResource)
        .width($r('app.float.message_item_voice_receive_icon_size'))
        .height($r('app.float.message_item_voice_receive_icon_size'))
        .objectFit(ImageFit.Contain)
        .visibility(this.state === AnimationStatus.Running ? Visibility.Hidden : Visibility.Visible)
      ImageAnimator()
        .images([
          {
            src: this.isSender ? $r('app.media.message_voice_send_playing_f1') :
            $r('app.media.message_voice_receive_playing_f1')
          },
          {
            src: this.isSender ? $r('app.media.message_voice_send_playing_f2') :
            $r('app.media.message_voice_receive_playing_f2')
          },
          {
            src: this.isSender ? $r('app.media.message_voice_send_playing_f3') :
            $r('app.media.message_voice_receive_playing_f3')
          }
        ])
        .duration(this.animatorDuration)
        .state(this.state)
        .reverse(false)
        .fillMode(FillMode.None)
        .iterations(-1)
        .width($r('app.float.message_item_voice_receive_icon_size'))
        .height($r('app.float.message_item_voice_receive_icon_size'))
        .visibility(this.state === AnimationStatus.Running ? Visibility.Visible : Visibility.None);
    }
  }
}
