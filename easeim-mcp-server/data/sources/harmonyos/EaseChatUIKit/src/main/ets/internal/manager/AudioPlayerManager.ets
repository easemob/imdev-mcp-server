import { BusinessError } from '@kit.BasicServicesKit';
import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { ChatError, ChatLog, ChatMessage, ContentType, VoiceMessageBody } from '@easemob/chatsdk';

/**
 * 语音播放管理器。
 */
export class AudioPlayerManager {
  private avPlayer: media.AVPlayer | undefined;
  private currentPlayingId: string | undefined;
  private onCompletion?: () => void;

  // 注册avplayer回调函数
  private setAVPlayerCallback(avPlayer: media.AVPlayer) {
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    avPlayer.on('error', (err: BusinessError) => {
      ChatLog.e(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      avPlayer.reset(); // 调用reset重置资源，触发idle状态
    })
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          ChatLog.d('AVPlayer state idle called.');
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          ChatLog.d('AVPlayer state initialized called.');
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_VOICE_MESSAGE,
            rendererFlags: 0
          }
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          ChatLog.d('AVPlayer state prepared called.');
          avPlayer.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          ChatLog.d('AVPlayer state playing called.');
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          ChatLog.d('AVPlayer state paused called.');
          break;
        case 'completed': // 播放结束后触发该状态机上报
          ChatLog.d('AVPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口
          await this.stopPlay();
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          ChatLog.d('AVPlayer state stopped called.');
          avPlayer.reset(); // 调用reset接口初始化avplayer状态
          if (this.onCompletion) {
            this.onCompletion();
          }
          break;
        case 'released':
          ChatLog.d('AVPlayer state released called.');
          this.avPlayer = undefined;
          this.currentPlayingId = undefined;
          break;
        default:
          ChatLog.e('AVPlayer state unknown called.');
          break;
      }
    })
  }

  /**
   * 是否正在播放语音。
   * @returns { boolean } - 返回语音的播放状态。
   */
  isPlaying(): boolean {
    if (this.avPlayer) {
      return this.avPlayer.state === 'playing';
    }
    return false;
  }

  /**
   * 获取正在播放的语音消息ID。
   * @returns
   */
  getPlayingVoiceId(): string | undefined {
    return this.currentPlayingId;
  }

  /**
   * 停止播放语音。
   */
  async stopPlay() {
    if (this.avPlayer) {
      await this.avPlayer.stop();
      await this.avPlayer.reset();
      await this.avPlayer.release();
      this.avPlayer = undefined;
      this.currentPlayingId = undefined;
    }
  }

  /**
   * 播放语音。
   * @param { ChatMessage } message - 语音消息。
   * @returns
   */
  async playVoice(message: ChatMessage, onCompletion?: () => void) {
    if (message.getType() !== ContentType.VOICE) {
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "Message type is wrong."))
    }
    let body = message.getBody() as VoiceMessageBody
    let localPath = body.getLocalPath();
    if (fs.accessSync(localPath)) {
      this.currentPlayingId = message.getMsgId();
      await this.startPlay(localPath, false, onCompletion);
      return
    } else {
      const remoteUrl = body.getRemoteUrl();
      if (remoteUrl) {
        this.currentPlayingId = message.getMsgId();
        await this.startPlay(remoteUrl, true, onCompletion);
        return
      }
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "Voice message: localPath not has access and remote url is empty."))
    }
  }

  /**
   * 播放语音文件。
   * @param { string } filePath - 本地语音文件或者远程语音路径。
   * @param { boolean } isRemoteUrl - 是否是远程路径。
   */
  async startPlay(filePath: string, isRemoteUrl: boolean = false, onCompletion?: () => void) {
    if (!this.avPlayer) {
      // 创建avPlayer实例对象
      this.avPlayer = await media.createAVPlayer();
      // 创建状态机变化回调函数
      this.setAVPlayerCallback(this.avPlayer);
    } else {
      await this.avPlayer.reset();
      if (this.onCompletion) {
        this.onCompletion();
      }
    }

    this.onCompletion = onCompletion;

    if (isRemoteUrl) {
      this.avPlayer.url = filePath;
    } else {
      let fdPath = 'fd://';
      // 打开相应的资源文件地址获取fd，并为url赋值触发initialized状态机上报
      let file = await fs.open(filePath);
      fdPath = fdPath + '' + file.fd;
      this.avPlayer.url = fdPath;
    }
  }
}

const audioPlayer = new AudioPlayerManager();
export default audioPlayer;