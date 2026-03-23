import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { ChatClient, ChatLog } from '@easemob/chatsdk';
import { getFilePath } from '../utils/UIKitUtils';

export enum RecordStatus {
  /**
   * Recorder is idle.
   */
  RECORD_IDLE,

  /**
   * Recording.
   */
  RECORDING,

  /**
   * Stop recording.
   */
  RECORD_STOP,

  /**
   * Playing the voice.
   */
  RECORD_PLAYING,

  /**
   * Record occurs error.
   */
  RECORD_ERROR,

  /**
   * Record is done.
   */
  RECORD_DONE
}

/**
 * 一个完整的【开始录制-暂停录制-恢复录制-停止录制】示例
 * async audioRecorderDemo() {
 *   await this.startRecordingProcess(); // 开始录制
 *   // 用户此处可以自行设置录制时长，例如通过设置休眠阻止代码执行
 *   await this.pauseRecordingProcess(); //暂停录制
 *   await this.resumeRecordingProcess(); // 恢复录制
 *   await this.stopRecordingProcess(); // 停止录制
 * }
 */
export class AudioRecorderManager {
  private EXTENSION: string = ".m4a";
  private avRecorder: media.AVRecorder | undefined = undefined;
  private fd: number = 0;
  private intervalId: number = 0;
  private avProfile: media.AVRecorderProfile = {
    audioBitrate: 100000, // 音频比特率
    audioChannels: 2, // 音频声道数
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前支持ACC，MP3，G711MU
    audioSampleRate: 48000, // 音频采样率
    fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前支持MP4，M4A，MP3，WAV
  };
  private _isRecording: boolean = false;
  private listener: VoiceRecorderListener | undefined;
  private startTimestamp: number = 0;

  // 注册audioRecorder回调函数
  private setAudioRecorderCallback() {
    if (this.avRecorder != undefined) {
      // 状态机变化回调函数
      this.avRecorder.on('stateChange', (state: media.AVRecorderState, reason: media.StateChangeReason) => {
        ChatLog.d(`AudioRecorder current state is ${state}`);
      })
      // 错误上报回调函数
      this.avRecorder.on('error', (err: BusinessError) => {
        ChatLog.e(`AudioRecorder failed, code is ${err.code}, message is ${err.message}`);
        if (this.listener) {
          this.listener.onError?.(err.code, err.message);
        }
      })
    }
  }

  // 开始录制对应的流程
  /**
   * @permission ohos.permission.MICROPHONE
   */
  async startRecording(conversationId: string) {
    if (this.avRecorder != undefined) {
      await this.avRecorder.release();
      this.avRecorder = undefined;
    }
    // 1.创建录制实例
    this.avRecorder = await media.createAVRecorder();
    this.setAudioRecorderCallback();
    // 2.获取录制文件fd赋予avConfig里的url；参考FilePicker文档
    const voiceFilePath = getFilePath(conversationId, this.getVoiceFilename(ChatClient.getInstance().getCurrentUser()));
    let file = fs.openSync(voiceFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    this.fd = file.fd;
    let audioFileUri = 'fd://'+file.fd;
    const avConfig: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC, // 音频输入源，这里设置为麦克风
      profile: this.avProfile,
      url: audioFileUri, // 参考应用文件访问与管理开发示例新建并读写一个文件
    };
    // 3.配置录制参数完成准备工作
    await this.avRecorder.prepare(avConfig);
    // 4.开始录制
    await this.avRecorder.start();
    this._isRecording = true;
    this.startTimestamp = new Date().getTime();
    this.setInterval();
    if (this.listener) {
      this.listener.onStart(voiceFilePath);
    }
  }

  // 暂停录制对应的流程
  async pauseRecording() {
    if (this.avRecorder != undefined && this.avRecorder.state === 'started') { // 仅在started状态下调用pause为合理状态切换
      this._isRecording = false;
      this.clearInterval();
      await this.avRecorder.pause();
    }
  }

  // 恢复录制对应的流程
  async resumeRecording() {
    if (this.avRecorder != undefined && this.avRecorder.state === 'paused') { // 仅在paused状态下调用resume为合理状态切换
      await this.avRecorder.resume();
      this._isRecording = true;
      this.setInterval();
    }
  }

  // 停止录制对应的流程
  async stopRecording() {
    if (this.avRecorder != undefined) {
      this._isRecording = false;
      this.clearInterval();
      // 1. 停止录制
      if (this.avRecorder.state === 'started'
        || this.avRecorder.state === 'paused') { // 仅在started或者paused状态下调用stop为合理状态切换
        await this.avRecorder.stop();
      }
      // 2.重置
      await this.avRecorder.reset();
      // 3.释放录制实例
      await this.avRecorder.release();
      this.avRecorder = undefined;
      // 4.关闭录制文件fd
      fs.closeSync(this.fd);
      const costSeconds = (new Date().getTime() - this.startTimestamp) / 1000;
      if (this.listener) {
        this.listener.onStop(costSeconds);
      }
    }
  }

  async reset() {
    // 删除录制文件
    fs.unlinkSync(fs.dup(this.fd).path);
    if (this._isRecording) {
      await this.stopRecording();
    }
    if (this.avRecorder) {
      // 2.重置
      await this.avRecorder.reset();
      // 3.释放录制实例
      await this.avRecorder.release();
      this.avRecorder = undefined;
    }
  }

  /**
   * 设置语音录制监听。
   * @param listener
   */
  setOnVoiceRecorderListener(listener: VoiceRecorderListener) {
    this.listener = listener;
  }

  /**
   * 判断是否正在录音
   * @returns
   */
  isRecording(): boolean {
    return this._isRecording
  }

  private getVoiceFilename(uid: string): string {
    const now = new Date();
    let timestamp = now.getTime().toString();
    return uid + timestamp.substring(0, 15) + this.EXTENSION;
  }

  /**
   * 设置定时器。
   */
  private setInterval() {
    this.intervalId = setInterval(async () => {
      let maxAmplitude = await this.getAudioCapturerMaxAmplitude();
      if (this.listener) {
        this.listener.onAudioMaxAmplitude?.(maxAmplitude);
      }
    }, 200);
  }

  /**
   * 取消定时器。
   */
  private clearInterval() {
    clearInterval(this.intervalId);
    this.intervalId = 0;
  }

  /**
   * 获取当前音频最大振幅。
   * @returns
   */
  private async getAudioCapturerMaxAmplitude(): Promise<number> {
    if (!this.avRecorder) {
      return Promise.reject(new Error("AVRecorder is not inited."));
    }
    return await this.avRecorder.getAudioCapturerMaxAmplitude();
  }

}

/**
 * 语音录制接口。
 */
export interface VoiceRecorderListener {
  /**
   * 语音录制开始。
   * @param { string | undefined } voicePath - 语音文件路径。
   */
  onStart: (voicePath?: string) => void;

  /**
   * 音频最大振幅。
   */
  onAudioMaxAmplitude?: (maxAmplitude: number) => void;

  /**
   * 语音录制停止。
   * @param { number } seconds - 录制时长，单位秒。
   */
  onStop: (seconds: number) => void;

  /**
   * 语音录制报错。
   * @param { number } errorCode - 语音录制错误码。
   * @param { string } errorMessage - 语音录制错误信息。
   */
  onError?: (errorCode: number, errorMessage: string) => void;
}

const audioRecorder = new AudioRecorderManager();
export default audioRecorder;