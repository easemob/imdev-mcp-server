import { DownloadStatus } from '@easemob/chatsdk';
import { ImageSize } from './ImageSize';

/**
 * 缩略图信息。
 */
export class ImageThumbnail {

  /**
   * 附件缩略图本地路径。图片和视频有此属性。
   */
  thumbnailLocalPath?: string;

  /**
   * 附件缩略图的服务器路径。图片和视频有此属性。
   */
  thumbnailRemoteUrl?: string;

  /**
   * 附件缩略图的下载状态。图片和视频有此属性。
   */
  thumbnailDownloadStatus?: DownloadStatus;

  /**
   * 视频缩略图尺寸。
   */
  thumbnailSize?: ImageSize;
}