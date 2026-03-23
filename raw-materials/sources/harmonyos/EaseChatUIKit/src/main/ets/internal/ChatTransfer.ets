import {
  ChatError,
  ChatMessageBody,
  CombineMessageBody,
  Conversation,
  CursorResult,
  FileMessageBody,
  ImageMessageBody,
  VideoMessageBody,
  VoiceMessageBody
} from '@easemob/chatsdk';
import { BusinessError } from '@kit.BasicServicesKit';
import { AttachmentMessageBody } from '../model/AttachmentMessageBody';
import { ImageThumbnail } from '../model/ImageThumbnail';
import { ImageSize } from '../model/ImageSize';
import { MessageCombine } from '../model/Message';
import { ChatKitConversation } from '../model/ChatKitConversation';

export type CommonError = ChatError | BusinessError;

export class ChatTransfer {

  /**
   * Transfer {@link ChatError} or {@link BusinessError} to {@link ChatError}.
   * @param { CommonError } error - ChatError or BusinessError.
   * @param { string } prefix - 当错误是 BusinessError 时，错误信息的前缀。
   * @returns { EaseError } - 返回 { EaseError } 对象。
   */
  static transferError(error: CommonError, prefix: string = ""): ChatError {
    let err = ChatError.createError(ChatError.EM_NO_ERROR, "");
    if (error instanceof ChatError) {
      err = error;
    }else {
      err.errorCode = ChatError.GENERAL_ERROR;
      if (prefix) {
        prefix += ": ";
      }
      err.description = prefix + error.message;
    }
    return err;
  }

  /**
   * 将{@link ChatMessageBody}转成{@link EaseMessageBody}。
   * @param { ChatMessageBody } body - 消息体。
   * @returns { EaseMessageBody } - 返回kit层的消息体。
   */
  static revertAttachmentMessageBody(body: ChatMessageBody | undefined): AttachmentMessageBody | null {
    if (!body) {
      return null;
    }
    if (body instanceof ImageMessageBody || body instanceof VideoMessageBody
      || body instanceof VoiceMessageBody || body instanceof CombineMessageBody || body instanceof FileMessageBody) {
      const b = new AttachmentMessageBody();
      (b as AttachmentMessageBody).filename = body.getFileName();
      (b as AttachmentMessageBody).localPath = body.getLocalPath();
      (b as AttachmentMessageBody).remoteUrl = body.getRemoteUrl();
      (b as AttachmentMessageBody).secretKey = body.getSecretKey();
      (b as AttachmentMessageBody).fileLength = body.getFileLength();
      (b as AttachmentMessageBody).downloadStatus = body.getDownloadStatus();
      if (body instanceof ImageMessageBody || body instanceof VideoMessageBody) {
        let thumbnail = new ImageThumbnail();
        thumbnail.thumbnailLocalPath = body.getThumbnailLocalPath();
        thumbnail.thumbnailRemoteUrl = body.getThumbnailRemoteUrl();
        thumbnail.thumbnailDownloadStatus = body.getThumbnailDownloadStatus();
        (b as AttachmentMessageBody).thumbnail = thumbnail;
        if (body instanceof ImageMessageBody) {
          (b as AttachmentMessageBody).size = new ImageSize(body.getWidth(), body.getHeight());
        }else {
          (b as AttachmentMessageBody).size = new ImageSize(body.getThumbnailWidth(), body.getThumbnailHeight());
          (b as AttachmentMessageBody).duration = body.getDuration();
        }
      } else if (body instanceof VoiceMessageBody) {
        (b as AttachmentMessageBody).duration = body.getDuration();
      } else if (body instanceof CombineMessageBody) {
        (b as AttachmentMessageBody).combine = new MessageCombine(body.getTitle(), body.getSummary(), body.getCompatibleText());
      }
      return b;
    } else {
      return null;
    }
  }

  static revertConversation(conversation: Conversation): ChatKitConversation {
    const conv = new ChatKitConversation(conversation);
    return conv;
  }

  /**
   * 将结果从 S 类型转为 D 类型。
   * @param source
   * @param callback
   * @returns
   */
  static transferCursorResult<S, D> (source: CursorResult<S>, callback: (value: S, index: number, array: S[]) => D): CursorResult<D> {
    let cursor: string = source.getNextCursor();
    let resultArray: D[] = source.getResult().map(callback)
    let result = new CursorResult<D>();
    result.setNextCursor(cursor);
    result.setResult(resultArray);
    return result;
  }

}