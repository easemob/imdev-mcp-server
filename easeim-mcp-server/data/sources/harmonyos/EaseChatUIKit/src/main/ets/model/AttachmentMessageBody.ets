import { DownloadStatus } from '@easemob/chatsdk';
import { MessageCombine } from './Message';
import { ImageSize } from './ImageSize';
import { ImageThumbnail } from './ImageThumbnail';

/**
 * 附件消息。包括文件消息，图片消息，视频消息，音频消息和合并消息。
 */
export class AttachmentMessageBody {

  /**
   * 附件名称。
   */
  filename: string = "";

  /**
   * 附件的本地路径。
   */
  localPath: string = "";

  /**
   * 附件的服务器路径。
   */
  remoteUrl: string = "";

  /**
   * 附件的密钥。
   */
  secretKey: string = "";

  /**
   * 附件的大小。
   */
  fileLength: number = 0;

  /**
   * 附件的下载状态。
   */
  downloadStatus: DownloadStatus = DownloadStatus.SUCCESS;

  /**
   * 缩略图信息。
   */
  thumbnail?: ImageThumbnail;

  /**
   * 图片的尺寸。
   */
  size?: ImageSize;

  /**
   * 视频或者音频的时长。
   */
  duration?: number;

  /**
   * 合并消息信息。
   */
  combine?: MessageCombine;
}