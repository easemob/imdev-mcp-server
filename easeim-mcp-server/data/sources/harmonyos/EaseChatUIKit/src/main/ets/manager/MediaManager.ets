import { ChatError, ChatLog } from '@easemob/chatsdk';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { JSON } from '@kit.ArkTS';
import { Context } from '@kit.AbilityKit';
import { dataSharePredicates } from '@kit.ArkData';
import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import { MediaResult, VideoResult } from '../model/MediaResult';
import { fsUtilStore } from '../utils/FsUtil';
import { image } from '@kit.ImageKit';
import { media } from '@kit.MediaKit';
import { fileIo, fileUri, picker } from '@kit.CoreFileKit';
import { camera, cameraPicker } from '@kit.CameraKit';
import { FileUtil } from '../utils/FileUtil';
import uikit from '../internal/ChatUIKit';
import fs from '@ohos.file.fs';

class MediaManager {
  /**
   * 从系统相册选择图片或者视频
   * @permission ohos.permission.READ_IMAGEVIDEO
   * @param context
   * @param mimeType
   * @returns
   */
  async callImageOrVideoPicker(context: Context, mimeType: photoAccessHelper.PhotoViewMIMETypes = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE) {
    try { // 设置photoPicker的参数
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      // 过滤选择媒体文件类型
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
      // 选择媒体文件的最大数目
      PhotoSelectOptions.maxSelectNumber = 1;
      // 使用图库选择器对象前，需要先创建PhotoViewPicker实例
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      let photoSelectResult = await photoPicker.select(PhotoSelectOptions);
      if (!photoSelectResult) {
        return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "no selected image!"));
      }
      // 日志记录成功信息
      ChatLog.d('PhotoSelectResult uri: ' + JSON.stringify(photoSelectResult));
      // 获取到目标uri
      const targetUri = photoSelectResult.photoUris[0];
      // 如果已经指定为图片或者视频，则直接返回uri。
      if (mimeType === photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE ||
        mimeType === photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE) {
        return targetUri;
      }
      // 如果指定为 IMAGE_VIDEO_TYPE 类型，则需要判断 uri 的类型
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI, targetUri);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [photoAccessHelper.PhotoKeys.WIDTH, photoAccessHelper.PhotoKeys.HEIGHT, photoAccessHelper.PhotoKeys.DURATION],
        predicates: predicates
      }
      let fetchResult = await photoAccessHelper.getPhotoAccessHelper(context).getAssets(fetchOptions);
      const asset = await fetchResult.getFirstObject();
      if (asset.photoType === photoAccessHelper.PhotoType.IMAGE) {
        return {
          photo: {
            uri: targetUri,
            width: asset.get(photoAccessHelper.PhotoKeys.WIDTH) as number,
            height: asset.get(photoAccessHelper.PhotoKeys.HEIGHT) as number
          }
        } as MediaResult
      } else if (asset.photoType === photoAccessHelper.PhotoType.VIDEO) {
        return {
          video: {
            uri: targetUri,
            width: asset.get(photoAccessHelper.PhotoKeys.WIDTH) as number,
            height: asset.get(photoAccessHelper.PhotoKeys.HEIGHT) as number,
            duration: asset.get(photoAccessHelper.PhotoKeys.DURATION) as number
          }
        } as MediaResult
      }
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "unknown mime type!"));
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, "callImageOrVideoPicker"))
    }
  }

  /**
   * 获取视频首帧。
   * @param uri
   * @param thumbnailPath
   * @param thumbnailSize
   * @param thumbnailOptions
   * @returns
   */
  async getVideoFirstFrame(uri: string, thumbnailPath: string, thumbnailSize?: media.PixelMapParams, thumbnailOptions?: image.PackingOption) {
    return fsUtilStore.getThumbnail(uri, thumbnailPath, thumbnailSize, thumbnailOptions);
  }

  /**
   * 调起文件选择器
   * @returns
   */
  async callFilePicker(conversationId: string): Promise<string> {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = 1;

      const documentViewPicker = new picker.DocumentViewPicker(); // 创建文件选择器实例
      let result = await documentViewPicker.select(documentSelectOptions)
      if (!result) {
        return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "no selected file!"));
      }
      let documentUri = result[0];
      try {
        await FileUtil.revokePermission(documentUri);
      } catch (e) {
        // 如果没有设置权限或者授权进行持久化时失败，需要将文件拷贝到指定文件夹下
        let destDir = FileUtil.getConversationAttachmentDir(conversationId);
        if (!FileUtil.accessSync(destDir)) {
          fs.mkdirSync(destDir, true);
        }
        let filename = new fileUri.FileUri(documentUri).name
        let destPath = destDir + '/' + filename;
        let destUri = fileUri.getUriFromPath(destPath);
        try {
          await fs.copy(documentUri, destUri);
          return destPath;
        } catch (e) {
          ChatLog.e("copy file failed: "+JSON.stringify(e));
        }
      }
      return documentUri;
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, "callFilePicker"))
    }
  }

  // 显示相机选择器
  async callCameraPicker(context: Context, mediaType: cameraPicker.PickerMediaType = cameraPicker.PickerMediaType.PHOTO, savedUri?: string) {
    let saveUri = savedUri;
    if (savedUri) {
      if (!FileUtil.isUri(savedUri)) {
        if (!FileUtil.accessSync(savedUri)) {
          try {
            fileIo.createRandomAccessFileSync(savedUri, fileIo.OpenMode.CREATE);
          } catch (e) {
            ChatLog.e(JSON.stringify(e));
            return Promise.reject(ChatError.createError(ChatError.FILE_INVALID, "create file failed!"));
          }
        }
        saveUri = fileUri.getUriFromPath(savedUri);
      }
    }

    // 相机选择器的配置信息
    let pickerProfile: cameraPicker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
      saveUri: saveUri
    };

    // 相机选择器的媒体类型
    let mediaTypes: cameraPicker.PickerMediaType[] = [mediaType]

    let pickerResult = await cameraPicker.pick(context, mediaTypes, pickerProfile);
    // 返回成功
    if (pickerResult.resultCode === 0) {
      if (pickerResult.mediaType === cameraPicker.PickerMediaType.PHOTO) {
        return {
          photo: {
            uri: savedUri
          }
        } as MediaResult
      } else {
        return await this.fetchMetadataFromFdSrc(savedUri!);
      }
    } else {
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "not pick result from camera!"));
    }
  }

  async fetchMetadataFromFdSrc(uriOrPath: string) {
    if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
      // 创建AVMetadataExtractor对象
      let avMetadataExtractor: media.AVMetadataExtractor = await media.createAVMetadataExtractor();
      // 设置fdSrc
      avMetadataExtractor.fdSrc = fileIo.openSync(uriOrPath);
      // 获取元数据（promise模式）
      let result: MediaResult | undefined;
      try {
        let metadata = await avMetadataExtractor.fetchMetadata();
        if (metadata) {
          result = new MediaResult();
          result.video = new VideoResult();
          result.video.uri = uriOrPath;
          if (metadata.videoWidth) {
            result.video.width = Number.parseInt(metadata.videoWidth);
          }
          if (metadata.videoHeight) {
            result.video.height = Number.parseInt(metadata.videoHeight);
          }
          if (metadata.duration) {
            result.video.duration = Number.parseInt(metadata.duration);
          }
        }
        // 释放资源（promise模式）
        avMetadataExtractor.release();
      } catch (e) {
        return Promise.reject(ChatTransfer.transferError(e as CommonError, "fetchMetadataFromFdSrc"))
      }
      return result;
    }
    return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "Not support SystemCapability.Multimedia.Media.AVMetadataExtractor in the device."))
  }

  /**
   * 打开视频消息全屏弹框。
   * @param messageId
   */
  openVideoDialog(dialogController: CustomDialogController) {
    dialogController.open();
  }

  /**
   * 打开大图弹框。
   * @param messageId
   */
  openImageDialog(dialogController: CustomDialogController) {
    dialogController.open();
  }
}

export const kitMedia = new MediaManager()