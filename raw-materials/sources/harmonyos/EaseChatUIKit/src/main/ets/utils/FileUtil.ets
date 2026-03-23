import { ChatError, ChatLog } from '@easemob/chatsdk';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { filePreview } from '@kit.PreviewKit';
import { fileShare } from '@kit.CoreFileKit';
import uikit from '../internal/ChatUIKit';

export class FileUtil {

  private static mimeTypeMap: Map<string, string> = new Map([
    ['txt', 'text/plain'],
    ['cpp', 'text/x-c++src'],
    ['c', 'text/x-csrc'],
    ['h', 'text/x-chdr'],
    ['java', 'text/x-java'],
    ['xhtml', 'application/xhtml+xml'],
    ['xml', 'text/xml'],
    ['html', 'text/html'],
    ['htm', 'text/html'],
    ['jpg', 'image/jpeg'],
    ['png', 'image/png'],
    ['gif', 'image/gif'],
    ['webp', 'image/webp'],
    ['bmp', 'image/bmp'],
    ['svg', 'image/svg+xml'],
    ['m4a', 'audio/mp4a-latm'],
    ['aac', 'audio/aac'],
    ['mp3', 'audio/mpeg'],
    ['ogg', 'audio/ogg'],
    ['wav', 'audio/x-wav'],
    ['mp4', 'video/mp4'],
    ['mkv', 'video/x-matroska'],
    ['ts', 'video/mp2ts'],
    ['pdf', 'application/pdf']
  ])

  static accessSync(filePath: string): boolean {
    return FileUtil.isUri(filePath) ? true : fs.accessSync(filePath);
  }

  /**
   * 判断是否是Uri。
   * @param uriOrPath { string } - 沙箱路径或者Uri。
   * @returns { boolean } - 返回是否是Uri。
   */
  static isUri(uriOrPath: string): boolean {
    return uriOrPath.startsWith("file://");
  }

  private static parseImage(imagePath: string): Promise<image.PixelMap> {
    if (FileUtil.accessSync(imagePath)) {
      const imageSource = image.createImageSource(imagePath);
      let decodingOptions : image.DecodingOptions = {
        editable: true,
        desiredPixelFormat: 3,
      }
      return imageSource.createPixelMap(decodingOptions);
    }
    return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "image no exist."));
  }

  /**
   * 获取图片信息。
   * @param imagePath
   * @returns
   */
  static async getImageSize(context: Context | undefined, imagePath: string): Promise<image.Size> {
    if (!context) {
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'Context is undefined.'))
    }
    if (FileUtil.isUri(imagePath)) {
      return FileUtil.getImageUriSize(context, imagePath);
    }
    let pixelMap: image.PixelMap | null = null;
    try {
      pixelMap = await FileUtil.parseImage(imagePath);
      let imageInfo = await pixelMap.getImageInfo();
      pixelMap.release();
      return {width: imageInfo.size.width, height: imageInfo.size.height};
    } catch (e) {
      if (pixelMap != null) {
        pixelMap.release();
      }
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'image no exist or parse pixel map failed.'))
    }
  }

  /**
   * 获取图片信息。
   *
   * @permission ohos.permission.READ_IMAGEVIDEO
   * @param context
   * @param imageUri
   * @returns
   */
  static async getImageUriSize(context: Context, imageUri: string): Promise<image.Size> {
    try {
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', imageUri);
      let fetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: [photoAccessHelper.PhotoKeys.WIDTH, photoAccessHelper.PhotoKeys.HEIGHT],
        predicates: predicates
      }
      let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
        await phAccessHelper.getAssets(fetchOption);
      // 得到uri对应的PhotoAsset对象，读取文件的部分信息
      const asset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      return {
        width: asset.get(photoAccessHelper.PhotoKeys.WIDTH) as number,
        height: asset.get(photoAccessHelper.PhotoKeys.HEIGHT) as number
      }
    } catch (e) {
      ChatLog.e('uriGetAssets failed with err: '+JSON.stringify(e));
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'uriGetAssets failed.'))
    }
  }

  /**
   * 获取文件的mimeType。
   * @param filename
   * @returns
   */
  static getFileMimeType(filename: string) {
    let mimeType: string = '';
    FileUtil.mimeTypeMap.forEach((value, key) => {
      if (filename.endsWith(key)) {
        mimeType = value;
      }
    })
    return mimeType;
  }

  static isFileCanPreview(context: Context, uri: string) {
    return filePreview.canPreview(context, uri)
  }

  /**
   * 预览文件。
   * @param context
   * @param fileUri
   * @param filename
   * @returns
   */
  static async openFilePreview(context: Context, fileUri: string, filename: string) {
    let isCanPreview = await filePreview.canPreview(context, fileUri);
    if (!isCanPreview) {
      try {
        await FileUtil.activatePermission(fileUri);
      } catch (e) {
        return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'File can not be previewed, fileUri: '+fileUri));
      }
    }
    let displayInfo: filePreview.DisplayInfo = {
      x: 100,
      y: 100,
    };
    let fileInfo: filePreview.PreviewInfo = {
      title: filename,
      uri: fileUri,
      mimeType: FileUtil.getFileMimeType(filename)
    };
    return filePreview.openPreview(context, fileInfo, displayInfo);
  }

  static async revokePermission(uri: string): Promise<void> {
    if (!canIUse('SystemCapability.FileManagement.AppFileService.FolderAuthorization')) {
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'this api is not supported on this device'));
    }
    let policyInfo: fileShare.PolicyInfo = {
      uri: uri,
      operationMode: fileShare.OperationMode.READ_MODE,
    };
    let policies: Array<fileShare.PolicyInfo> = [policyInfo];
    await fileShare.persistPermission(policies);
  }

  static async activatePermission(uri: string): Promise<void> {
    if (!canIUse('SystemCapability.FileManagement.AppFileService.FolderAuthorization')) {
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'this api is not supported on this device'));
    }
    let policyInfo: fileShare.PolicyInfo = {
      uri: uri,
      operationMode: fileShare.OperationMode.READ_MODE,
    };
    let policies: Array<fileShare.PolicyInfo> = [policyInfo];
    await fileShare.activatePermission(policies);
  }

  /**
   * 获取会话附件所在的文件夹路径。
   * @param conversationId
   * @returns
   */
  static getConversationAttachmentDir(conversationId: string): string {
    return uikit.sdk.getOptions()?.getDownloadPath() + '/' + uikit.sdk.getCurrentUser() + '/' + conversationId;
  }
}