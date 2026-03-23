import audioRecorder, { RecordStatus, VoiceRecorderListener } from '../../internal/manager/AudioRecorderManager';
import { RecordBottomSheetDialogOptions } from '../../model/DialogOptions';
import { CornerRadiusExtraLargeAttributeModifier } from '../attributeModifiers/CornerRadiusAttrbuteModifiers';
import {
  TextBodySmallAttributeModifier,
  TextHeadlineSmallAttributeModifier,
  TextLabelMediumAttributeModifier
} from '../attributeModifiers/TextAttributeModifiers';
import { BottomSheetDialogHelper } from './BottomSheetDialog';
import { keepScreenOn } from '../../utils/Window';
import audioPlayer from '../../internal/manager/AudioPlayerManager';
import { getString } from '../../utils/CommonUtils';
import { Animator, AnimatorResult } from '@kit.ArkUI';
import { ChatDialog } from './ChatDialog';


@Builder
export function recordBottomSheetDialogBuilder(options: RecordBottomSheetDialogOptions) {
  Column() {
    RecordBottomSheetDialog({
      options: options
    })
  }
}

@ComponentV2
export struct RecordBottomSheetDialog {
  @Param options: RecordBottomSheetDialogOptions = new RecordBottomSheetDialogOptions();
  // 最大录音时长
  @Local maxRecordSeconds: number = this.options.maxRecordSeconds ?? 60;
  @Local dialogHeight: number = 0
  @Local translateY: number = 0
  @Local recordStatus: RecordStatus = RecordStatus.RECORD_IDLE;
  @Local voiceRemainTip: ResourceStr = '';
  @Local voiceLength: string = '';
  @Local voiceStatus: ResourceStr = '';
  @Local recordSeconds: number = 0;
  @Local recordRemainSeconds: number = 0;
  @Local remainPlaySeconds: number = 0;
  @Local isCancelable: boolean = true;
  @Monitor('isCancelable')
  cancelableStatusChange(monitor: IMonitor) {
    this.options.cancelableChange?.(this.isCancelable)
  }
  @Monitor('recordStatus')
  onRecordStatusChange(monitor: IMonitor) {
    if (this.recordStatus === RecordStatus.RECORDING || this.recordStatus === RecordStatus.RECORD_PLAYING) {
      this.playAnimator();
    } else {
      this.finishAnimator();
    }
  }
  @Monitor('recordSeconds')
  onRecordSecondsChange(monitor: IMonitor) {
    this.voiceLength = getString($r('app.string.chat_record_time'), this.recordSeconds);
  }
  @Monitor('recordRemainSeconds')
  onRecordRemainSecondsChange(monitor: IMonitor) {
    if (this.recordRemainSeconds) {
      this.voiceRemainTip = getString($r('app.string.chat_record_remain_time'), this.recordRemainSeconds);
    }
  }
  @Monitor('remainPlaySeconds')
  onRemainSecondsChange(monitor: IMonitor) {
    this.voiceLength = getString($r('app.string.chat_record_time'), this.remainPlaySeconds);
  }
  private voicePath?: string;
  private intervalId: number | undefined;
  @Local bgBtnWidth: number = 100;
  @Local bgBtnHeight: number = 68;
  private bgAnimator?: AnimatorResult;
  private isSend: boolean = false;
  private listener:VoiceRecorderListener = {
    onStart: (voicePath?: string | undefined): void => {
      this.voicePath = voicePath
    },
    onStop: (seconds: number): void => {
      this.recordSeconds = seconds;
    },
    onError: (errorCode: number, errorMessage: string) => {

    }
  }

  aboutToAppear(): void {
    let onWillDismiss = this.options.onWillDismiss
    this.options.onWillDismiss = (action: DismissDialogAction) => {
      if (onWillDismiss) {
        onWillDismiss(action)
      } else {
        if (action.reason === DismissReason.PRESS_BACK) {
          action.dismiss();
        }
        if (action.reason === DismissReason.TOUCH_OUTSIDE && (this.options.autoCancel || this.options.autoCancel === undefined)) {
          action.dismiss();
        }
      }
    }
    audioRecorder.setOnVoiceRecorderListener(this.listener);
    this.toIdle();
  }

  aboutToDisappear(): void {
    if (audioRecorder.isRecording()) {
      this.toStopRecord();
    }
    if (audioPlayer.isPlaying()) {
      this.toStopPlayVoice()
    }
    if (!this.isSend) {
      this.toIdle();
    }
    // 释放对象
    this.bgAnimator = undefined;
  }

  private toIdle() {
    this.setIdleStatus()
    if (this.voicePath) {
      audioRecorder.reset()
      this.voicePath = undefined;
    }
  }

  private toRecord() {
    this.setRecordingStatus();
    this.startToRecord(() => {
      this.toStopRecord();
    })
  }

  private toStopRecord() {
    this.setRecordStopStatus();
    this.stopRecord();
  }

  private toPlayVoice() {
    this.setRecordPlayingStatus();
    this.startPlay(()=> {
      this.toStopPlayVoice()
    })
  }

  private toStopPlayVoice() {
    this.setPlayerStopStatus();
    this.stopPlay();
    // 停止计时器
    this.stopTimeout();
  }

  private setIdleStatus() {
    this.recordStatus = RecordStatus.RECORD_IDLE;
    this.voiceStatus = $r('app.string.chat_record_start_hint');
    this.voiceRemainTip = '';
    this.recordSeconds = 0;
    this.recordRemainSeconds = 0;
    this.isCancelable = true;
  }

  private setRecordingStatus() {
    this.recordStatus = RecordStatus.RECORDING
    this.voiceLength = getString($r('app.string.chat_record_time'),0);
    this.voiceStatus = $r('app.string.chat_record_recording');
    this.voiceRemainTip = '';
    this.isCancelable = false;
  }

  private setRecordStopStatus() {
    this.recordStatus = RecordStatus.RECORD_STOP
    this.voiceLength = getString($r('app.string.chat_record_time'), 0);
    this.voiceStatus = $r('app.string.chat_record_start_play');
    this.voiceRemainTip = '';
    this.isCancelable = true;
  }

  private setRecordPlayingStatus() {
    this.recordStatus = RecordStatus.RECORD_PLAYING
    this.voiceStatus = $r('app.string.chat_record_playing');
    this.voiceRemainTip = '';
    this.isCancelable = false;
  }

  private setPlayerStopStatus() {
    this.setRecordStopStatus();
  }

  private setRecordErrorStatus() {
    this.recordStatus = RecordStatus.RECORD_ERROR
  }

  private setRecordDoneStatue() {
    this.recordStatus = RecordStatus.RECORD_DONE
    this.setRecordStopStatus();
  }

  private async startToRecord(action: () => void) {
    if (audioRecorder.isRecording()) {
      await audioRecorder.stopRecording();
    }
    keepScreenOn(getContext(), true);
    await audioRecorder.startRecording(this.options.conversationId);
    this.startTimeout(() => {
      this.recordSeconds++;
      if (this.maxRecordSeconds - this.recordSeconds >= 0) {
        let remainSeconds = this.maxRecordSeconds - this.recordSeconds;
        if (remainSeconds <= 10) {
          this.recordRemainSeconds = remainSeconds;
        }
      }
      if (this.recordSeconds === this.maxRecordSeconds) {
        this.stopTimeout();
        action();
      }
    })
  }

  private async stopRecord() {
    // 下一个状态是播放，需要将播放时间设置为录音时间
    this.remainPlaySeconds = this.recordSeconds;
    keepScreenOn(getContext(), false);
    await audioRecorder.stopRecording();
    this.stopTimeout()
  }

  private async startPlay(action: () => void) {
    if (this.voicePath) {
      if (audioPlayer.isPlaying()) {
        await audioPlayer.stopPlay();
      }
      await audioPlayer.startPlay(this.voicePath)
      this.startTimeout(() => {
        this.remainPlaySeconds--;
        if (this.remainPlaySeconds <= 0) {
          this.stopTimeout();
          action()
        }
      })
    }
  }

  private async stopPlay() {
    this.remainPlaySeconds = this.recordSeconds;
    await audioPlayer.stopPlay();
  }

  private startTimeout(func: () => void) {
    if (this.intervalId) {
      return;
    }
    this.intervalId = setInterval(func, 1000);
  }

  private stopTimeout() {
    clearInterval(this.intervalId);
    this.intervalId = undefined;
  }

  private appearAnimation(duration: number = 300) {
    animateTo({
      duration: duration,
      curve: Curve.Linear,
      playMode: PlayMode.Normal
    }, () => {
      this.translateY = 0
    })
  }

  private disappearAnimation(duration: number = 100) {
    animateTo({
      duration: duration,
      curve: Curve.Linear,
      playMode: PlayMode.Normal,
      onFinish: () => {
        BottomSheetDialogHelper.closeDialog(this.options.id ?? '')
      }
    }, () => {
      this.translateY = this.dialogHeight
    })
  }

  private create() {
    let _this = this
    this.bgAnimator = Animator.create({
      duration: 1000,
      easing: "ease",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: -1,
      begin: 100,
      end: 90
    })
    this.bgAnimator.onFinish = () => {
      this.bgBtnWidth = 100
      this.bgBtnHeight = 68
    }
    this.bgAnimator.onRepeat = () => {
    }
    this.bgAnimator.onCancel = () => {
    }
    this.bgAnimator.onFrame = (value: number) => {
      _this.bgBtnWidth = value
      _this.bgBtnHeight = value - 32;
    }
  }

  private playAnimator() {
    if (!this.bgAnimator) {
      this.create();
    }
    this.bgAnimator?.play();
  }

  private finishAnimator() {
    if (this.bgAnimator) {
      this.bgAnimator.finish();
    }
  }

  build() {
    Column() {
      Row() {

        Button({type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL}) {
          Image(this.options.deleteIcon?.src ?? $r('app.media.chat_icon_record_delete'))
            .width(this.options.deleteIcon?.width ?? $r("app.float.chat_menu_item_icon_medium_size"))
            .height(this.options.deleteIcon?.height ?? $r("app.float.chat_menu_item_icon_medium_size"))
        }
        .padding(12)
        .margin({
          right: 42
        })
        .visibility(this.recordStatus >= RecordStatus.RECORD_STOP ? Visibility.Visible : Visibility.None)
        .backgroundColor($r('app.color.chat_color_record_delete_button'))
        .onClick(() => {
          this.toIdle();
        })

        Stack({alignContent: Alignment.Center}) {

          Button({type: ButtonType.Capsule, buttonStyle: ButtonStyleMode.TEXTUAL, stateEffect: false})
            .backgroundColor($r('app.color.chat_color_record_bg_button'))
            .width(this.bgBtnWidth)
            .height(this.bgBtnHeight)

          Button({type: ButtonType.Capsule, buttonStyle: ButtonStyleMode.TEXTUAL, stateEffect: true}) {
            Stack() {
              Image(this.options.recordIcon?.src ?? $r('app.media.chat_icon_record'))
                .width(this.options.recordIcon?.width ?? $r("app.float.chat_menu_item_icon_medium_size"))
                .height(this.options.recordIcon?.height ?? $r("app.float.chat_menu_item_icon_medium_size"))
                .visibility(this.recordStatus === RecordStatus.RECORD_IDLE ? Visibility.Visible : Visibility.None)
              Text(this.voiceLength)
                .fontColor($r('app.color.chat_color_record_length_text'))
                .attributeModifier(this.options.timeCountText?.attributeModifier ?? new TextHeadlineSmallAttributeModifier())
                .visibility(this.recordStatus !== RecordStatus.RECORD_IDLE ? Visibility.Visible : Visibility.None)
            }
            .backgroundColor($r('app.color.chat_color_primary'))
            .width(80)
            .height(48)
            .attributeModifier(new CornerRadiusExtraLargeAttributeModifier())
          }
          .onClick(()=> {
            if (this.recordStatus === RecordStatus.RECORD_IDLE) {
              this.options.onClickRecord?.((isPermissionRecordGranted: boolean) => {
                if (isPermissionRecordGranted) {
                  this.toRecord();
                }
              });
            } else if (this.recordStatus === RecordStatus.RECORDING) {
              this.toStopRecord()
            } else if (this.recordStatus === RecordStatus.RECORD_STOP ||
              this.recordStatus === RecordStatus.RECORD_DONE) {
              this.toPlayVoice()
            } else if (this.recordStatus === RecordStatus.RECORD_PLAYING) {
              this.toStopPlayVoice()
            }
          })
        }
        .width(100)
        .height(68)

        Button({type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL}) {
          Image(this.options.sendIcon?.src ?? $r('app.media.chat_icon_record_send'))
            .width(this.options.sendIcon?.width ?? $r("app.float.chat_menu_item_icon_medium_size"))
            .height(this.options.sendIcon?.height ?? $r("app.float.chat_menu_item_icon_medium_size"))
            .visibility(this.recordStatus >= RecordStatus.RECORD_STOP ? Visibility.Visible : Visibility.None)
        }
        .padding(12)
        .margin({
          left: 42
        })
        .visibility(this.recordStatus >= RecordStatus.RECORD_STOP ? Visibility.Visible : Visibility.None)
        .backgroundColor($r('app.color.chat_color_record_send_button'))
        .onClick(() => {
          this.isSend = true;
          ChatDialog.getDialog(this.options.id ?? '')?.closeDialog();
          this.options.onClickSend(this.voicePath, this.recordSeconds);
        })

      }
      .margin({
        top: 62
      })


      Text(this.voiceStatus)
        .fontColor($r('app.color.chat_color_text_secondary'))
        .attributeModifier(this.options.timeCountText?.attributeModifier ?? new TextLabelMediumAttributeModifier())
        .margin({
          top: 8
        })

      Text(this.voiceRemainTip)
        .fontColor($r('app.color.chat_color_text_secondary'))
        .attributeModifier(this.options.timeCountText?.attributeModifier ?? new TextBodySmallAttributeModifier())
        .margin({
          top: 8
        })
    }
    .width(this.options.width ?? '100%')
    .height(this.options.height ?? $r('app.float.chat_record_dialog_height'))
    .gesture(
      PanGesture()
        .onActionUpdate((event: GestureEvent|undefined) => {
          if(event){
            if (event.offsetY < 0) {
              return
            }
            if (this.recordStatus === RecordStatus.RECORDING || this.recordStatus === RecordStatus.RECORD_PLAYING) {
              return
            }
            this.translateY = event.offsetY;
          }
        })
        .onActionEnd(() => {
          if (this.translateY > this.dialogHeight / 2) {
            this.disappearAnimation();
          } else {
            this.appearAnimation();
          }
        })
    )
    .backgroundColor(this.options.backgroundColor ?? $r('app.color.chat_color_background'))
    .visibility(Visibility.Hidden)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (this.dialogHeight === 0) {
        this.dialogHeight = (newValue.height as number) ?? 0;
        this.translateY = this.dialogHeight;
        this.appearAnimation()
      }
    })
    .visibility(this.dialogHeight > 0 ? Visibility.Visible : Visibility.Hidden)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .translate({
      y: this.translateY
    })
  }
}