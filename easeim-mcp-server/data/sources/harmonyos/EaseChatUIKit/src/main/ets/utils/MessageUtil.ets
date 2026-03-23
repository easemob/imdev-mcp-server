import {
  ChatClient,
  ChatError,
  ChatMessage,
  ChatMessageBody,
  ChatType,
  ContentType,
  ConversationType,
  CustomMessageBody,
  DownloadStatus,
  FetchMessageOption,
  MessageStatus,
  TextMessageBody,
  VoiceMessageBody
} from '@easemob/chatsdk';
import { ChatKitMessage } from '../model/ChatKitMessage';
import { AttachmentMessageBody } from '../model/AttachmentMessageBody';
import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import uikit from '../internal/ChatUIKit';
import { FileUtil } from './FileUtil';
import { getEventStr } from './EventBus';
import { KitConstants } from '../constants/KitConstants';
import { fileUri } from '@kit.CoreFileKit';
import { display } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { StringUtil } from './StringUtil';
import { UserCard } from '../model/UserCard';
import { MessageMenuItem } from '../model/Menu';
import { EmojiManager } from '../internal/manager/EmojiManager';
import { TextParseResult } from '../internal/model/EmojiIcon';
import { ChatReplyContentType } from '../model/ChatReplyContentType';
import { JSON } from '@kit.ArkTS';
import { MessageContent } from '../model/Message';
import { RichEditorSpanModel } from '../model/builder/MessageComponentModel';
import { getString, parseJson } from './CommonUtils';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { isCurrentUser } from './GroupUtil';
import { ChatUser, MessageUserInfo } from '../internal/model/ChatUser';

/**
 * 用于消息相关的方法
 */
export function isAttachmentMessage(message: ChatMessage | ChatKitMessage) {
  let type = ContentType.TXT;
  if (message instanceof ChatMessage) {
    type = message.getType();
  } else {
    type = message.origin.getType();
  }
  return type === ContentType.IMAGE || type === ContentType.VIDEO ||
    type === ContentType.VOICE || type === ContentType.COMBINE ||
    type === ContentType.FILE
}

/**
 * 判断是否是多媒体消息
 */
export function isMediaMessage(message: ChatMessage | ChatKitMessage) {
  let type = ContentType.TXT;
  if (message instanceof ChatMessage) {
    type = message.getType();
  } else {
    type = message.origin.getType();
  }
  return type === ContentType.IMAGE || type === ContentType.VIDEO ||
    type === ContentType.VOICE
}

export function getAttachmentInfo(message: ChatMessage | ChatKitMessage): AttachmentMessageBody | null {
  if (isAttachmentMessage(message)) {
    let body: ChatMessageBody | undefined;
    if (message instanceof ChatMessage) {
      body = message.getBody()
    } else {
      body = message.origin.getBody();
    }
    return body ? ((ChatTransfer.revertAttachmentMessageBody(body) as AttachmentMessageBody) ?? null) : null;
  } else {
    return null;
  }
}

export function defaultFetchMessagesOptions(): FetchMessageOption {
  const option = new FetchMessageOption();
  option.setIsSave(true);
  return option;
}

/**
 * 获取消息时间戳。
 *
 * 根据{@link ChatOptions.isSortMessageByServerTime}，选择服务器时间戳还是本地时间戳。
 *
 * @param { ChatMessage } message - 消息对象。
 * @returns { number } - 返回消息时间戳。
 */
export function getMessageTimestamp(message: ChatMessage): number {
  if (!uikit.isInited()) {
    return 0;
  }
  let isSortMessageByServerTime = uikit.sdk.getOptions()?.isSortMessageByServerTime();
  if (isSortMessageByServerTime === undefined) {
    return 0;
  }
  return isSortMessageByServerTime ? message.getServerTimestamp() : message.getLocalTimestamp();
}

/**
 * 消息是否发送失败
 * @param message
 * @returns
 */
export function isSentFailed(message: ChatMessage): boolean {
  if (!uikit.isInited()) {
    return false;
  }
  return message.getStatus() === MessageStatus.FAIL;
}

/**
 * 判断是否是消息发送方。
 * @param message
 * @returns
 */
export function isSender(message: ChatMessage): boolean {
  if (!uikit.isInited()) {
    return false;
  }
  return message.getFrom().toLowerCase() === uikit.sdk.getCurrentUser().toLowerCase()
}

/**
 * 判断是否是单聊。
 * @param message
 * @returns
 */
export function isSingleChat(message: ChatMessage | ChatKitMessage): boolean {
  let chatType: ChatType = ChatType.Chat;
  if (message instanceof ChatMessage) {
    chatType = message.getChatType();
  } else {
    chatType = message.origin.getChatType();
  }
  return chatType === ChatType.Chat;
}

/**
 * 判断是否是群聊。
 * @param message
 * @returns
 */
export function isGroupChat(message: ChatMessage | ChatKitMessage): boolean {
  let chatType: ChatType = ChatType.Chat;
  if (message instanceof ChatMessage) {
    chatType = message.getChatType();
  } else {
    chatType = message.origin.getChatType();
  }
  return chatType === ChatType.GroupChat;
}

/**
 * 判断是否是文本消息。
 * @param message
 * @returns
 */
export function isText(message: ChatMessage): boolean {
  return message.getType() === ContentType.TXT;
}

/**
 * 判断是否是文件消息。
 * @param message
 * @returns
 */
export function isFileMessage(message: ChatMessage): boolean {
  return message.getType() === ContentType.FILE;
}

/**
 * 判断是否是语音消息。
 * @param message
 * @returns
 */
export function isVoiceMessage(message: ChatMessage): boolean {
  return message.getType() === ContentType.VOICE;
}

/**
 * 判断是否是图片消息
 * @param message
 * @returns
 */
export function isImageMessage(message: ChatMessage): boolean {
  return message.getType() === ContentType.IMAGE;
}

/**
 * 判断是否是视频消息
 * @param message
 * @returns
 */
export function isVideoMessage(message: ChatMessage): boolean {
  return message.getType() === ContentType.VIDEO;
}

/**
 * 获取附件名称
 * @param message
 * @returns
 */
export function getFilename(message?: ChatMessage | ChatKitMessage): string | undefined {
  if (!message) {
    return undefined;
  }
  if (isAttachmentMessage(message)) {
    return getAttachmentInfo(message)?.filename
  } else {
    return undefined;
  }
}

/**
 * 获取语音或者视频消息的时长。
 * @param message
 * @returns
 */
export function getDuration(message?: ChatMessage | ChatKitMessage): number | undefined {
  if (!message) {
    return undefined;
  }
  if (isAttachmentMessage(message)) {
    return getAttachmentInfo(message)?.duration;
  } else {
    return undefined;
  }
}

/**
 * 获取文本消息内容。
 * @param message
 * @returns
 */
export function getMessageContent(message: ChatMessage): string | undefined {
  if (isText(message)) {
    return (message.getBody() as TextMessageBody).getContent();
  }
  return undefined;
}

/**
 * 获取文本消息解析后的内容。
 * @param message
 * @returns
 */
export function contentParsed(message: ChatMessage | string): TextParseResult[] | undefined {
  let result: string | undefined = '';
  if (typeof message === 'string') {
    result = message;
  } else {
    result = getMessageContent(message);
  }
  if (result) {
    return EmojiManager.getInstance().parseMessageContent(result);
  }
  return undefined;
}

/**
 * 判断是否是RichEditor中的builderSpan。
 * @param span
 * @returns
 */
export function isBuilderSpan(span: RichEditorImageSpanResult | RichEditorTextSpanResult): boolean {
  return !(span as RichEditorTextSpanResult).value &&
    !(span as RichEditorImageSpanResult).valueResourceStr?.toString().replaceAll(' ', '');
}

/**
 * 将RichEditor的结果转为字符串类型，包括处理emoji。
 * @param controller
 * @param { RichEditorSpanModel[] } builderSpans - 自定义span内容
 * @returns
 */
export function getContent(controller: RichEditorController, builderSpans?: RichEditorSpanModel[]): MessageContent {
  let content = '';
  let builderSpanIndex = 0;
  let atList: string[] = [];
  controller.getSpans().forEach(item => {
    const textSpan = item as RichEditorTextSpanResult;
    const imageSpan = item as RichEditorImageSpanResult;
    if (textSpan.value) {
      content += textSpan.value;
    } else if (isBuilderSpan(item)) {
      if (builderSpans) {
        let richEditorSpan = builderSpans[builderSpanIndex];
        builderSpanIndex += 1;
        content += richEditorSpan.value
        if (typeof richEditorSpan.data === 'string') {
          atList.push(richEditorSpan.data);
        }
      }
    } else {
      let resourcePath = imageSpan.valueResourceStr;
      let emojiText = EmojiManager.getInstance().getEmojiByRawResource(resourcePath);
      content += emojiText;
    }
  })
  return {
    value: content,
    atList: atList.length > 0 ? atList : undefined
  };
}

/**
 * 获取语音消息气泡的宽度。
 * @param message
 * @returns
 */
export function getVoiceBubbleWidth(message: ChatMessage): Resource {
  if (!(message.getBody() instanceof VoiceMessageBody)) {
    return $r('app.float.message_item_voice_width_1_9s');
  }
  const voiceDuration = (message.getBody() as VoiceMessageBody).getDuration();
  let length = $r('app.float.message_item_voice_width_60s');
  if (voiceDuration < 10) {
    length = $r('app.float.message_item_voice_width_1_9s');
  } else if (voiceDuration >= 10 && voiceDuration < 20) {
    length = $r('app.float.message_item_voice_width_10_19s');
  } else if (voiceDuration >= 20 && voiceDuration < 30) {
    length = $r('app.float.message_item_voice_width_20_29s');
  } else if (voiceDuration >= 30 && voiceDuration < 40) {
    length = $r('app.float.message_item_voice_width_30_39s');
  } else if (voiceDuration >= 40 && voiceDuration < 50) {
    length = $r('app.float.message_item_voice_width_40_49s');
  } else if (voiceDuration >= 50 && voiceDuration < 60) {
    length = $r('app.float.message_item_voice_width_50_59s');
  }
  return length;
}

/**
 * 获取语音长度。
 * @param message
 * @returns
 */
export function getVoiceLengthStr(message: ChatMessage): string | undefined {
  if (!(message.getBody() instanceof VoiceMessageBody)) {
    return undefined;
  }
  const voiceDuration = (message.getBody() as VoiceMessageBody).getDuration();
  if (voiceDuration <= 60) {
    return voiceDuration + "''";
  } else {
    return `60''+`;
  }
}

export function isLocalImageAccess(message: ChatMessage, isCheckThumbnail: boolean = false): boolean {
  let attachment = getAttachmentInfo(message);
  if (!attachment) {
    return false;
  }
  let localPath = '';

  if (isCheckThumbnail) {
    localPath = attachment.thumbnail?.thumbnailLocalPath ?? '';
  } else {
    localPath = attachment.localPath;
  }
  return FileUtil.accessSync(localPath);
}

/**
 * 获取消息下载缩略图的事件。
 * @returns
 */
export function getMsgDownloadThumbnailEvent(): string {
  return getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "download_thumbnail");
}

/**
 * 获取消息发送结果的事件。
 * @returns
 */
export function getMsgSendResultEvent(): string {
  return getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "send");
}

/**
 * 获取图片消息或者视频消息的缩略图或者首帧。
 * @param message
 * @param onNeedDownload
 * @returns
 */
function getImageThumbnailResource(message: ChatKitMessage, onNeedDownload?: (messageId: string) => void): ResourceStr | undefined {
  let attachment = getAttachmentInfo(message);
  if (message.thumbnailDownloadStatus === DownloadStatus.SUCCESS) {
    if (isLocalImageAccess(message.origin, true)) {
      let path = attachment?.thumbnail?.thumbnailLocalPath;
      return path ? fileUri.getUriFromPath(path) : undefined;
    } else {
      onNeedDownload?.(message.messageId);
      return undefined;
    }
  } else if (message.thumbnailDownloadStatus === DownloadStatus.FAILED) {
    if (!StringUtil.isEmpty(attachment?.thumbnail?.thumbnailRemoteUrl)) {
      onNeedDownload?.(message.messageId);
    }
    return undefined;
  } else if (message.thumbnailDownloadStatus === DownloadStatus.PENDING) {
    if (isLocalImageAccess(message.origin, true)) {
      let path = attachment?.thumbnail?.thumbnailLocalPath;
      return path ? fileUri.getUriFromPath(path) : undefined;
    } else {
      if (!StringUtil.isEmpty(attachment?.thumbnail?.thumbnailRemoteUrl)) {
        onNeedDownload?.(message.messageId);
      }
      return undefined;
    }
  } else {
    return undefined;
  }
}

function getImageThumbnailLocalPath(message: ChatMessage, isIncludeRemoteUrl?: boolean): string | undefined {
  const attachment = getAttachmentInfo(message);
  if (attachment?.thumbnail?.thumbnailDownloadStatus === DownloadStatus.SUCCESS || attachment?.thumbnail?.thumbnailDownloadStatus === DownloadStatus.PENDING) {
    if (isLocalImageAccess(message, true)) {
      return attachment?.thumbnail?.thumbnailLocalPath;
    }
  }
  return isIncludeRemoteUrl ? attachment?.thumbnail?.thumbnailRemoteUrl : undefined;
}

/**
 * 获取图片消息本地地址。
 * @param { ChatMessage } message - 视频消息。
 * @param { boolean } isIncludeRemoteUrl - 是否包括远程地址。
 * @returns
 */
function getImageAttachmentLocalPath(message: ChatMessage, isIncludeRemoteUrl?: boolean): string | undefined {
  const attachment = getAttachmentInfo(message);
  if (!attachment) {
    return undefined;
  }
  const type = message.getType();
  if (type === ContentType.IMAGE) {
    if (attachment.downloadStatus === DownloadStatus.SUCCESS || attachment.downloadStatus === DownloadStatus.PENDING) {
      if (isLocalImageAccess(message)) {
        return attachment.localPath;
      } else {
        return getImageThumbnailLocalPath(message, isIncludeRemoteUrl);
      }
    } else {
      return getImageThumbnailLocalPath(message, isIncludeRemoteUrl);
    }
  } else if (type === ContentType.VIDEO) {
    if (attachment.downloadStatus === DownloadStatus.SUCCESS || attachment.downloadStatus === DownloadStatus.PENDING) {
      if (isLocalImageAccess(message, true)) {
        return attachment?.thumbnail?.thumbnailLocalPath;
      }
    } else {
      return isIncludeRemoteUrl ? getImageThumbnailLocalPath(message, isIncludeRemoteUrl) : undefined;
    }
  }
  return undefined;
}

/**
 * 获取视频消息首帧本地地址。
 * @param { ChatKitMessage } message - 视频消息。
 * @param onNeedDownload - 需要下载的回调
 * @returns
 */
export function getVideoThumbnailResource(message: ChatKitMessage, onNeedDownload?: (messageId: string) => void): ResourceStr | undefined {
  return getImageThumbnailResource(message, onNeedDownload);
}

/**
 * 获取图片消息附件本地地址。
 * @param message
 * @returns
 */
export function getImageAttachmentResource(message: ChatKitMessage, onNeedDownload?: (messageId: string) => void): ResourceStr | undefined {

  if (message.attachmentDownloadStatus === DownloadStatus.SUCCESS) {
    if (isLocalImageAccess(message.origin)) {
      let localPath  = getAttachmentInfo(message)?.localPath
      return localPath ? (FileUtil.isUri(localPath) ? localPath : fileUri.getUriFromPath(localPath)) : undefined;
    } else {
      return getImageThumbnailResource(message, onNeedDownload);
    }
  } else {
    return getImageThumbnailResource(message, onNeedDownload);
  }
}

/**
 * 获取图片尺寸。
 * @param message
 * @returns
 */
export async function getImageAttachmentSize(message: ChatMessage): Promise<image.Size> {
  const localPath = getImageAttachmentLocalPath(message);
  if (!localPath) {
    return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'Local path is undefined.'));
  }
  return await FileUtil.getImageSize(getContext(), localPath);
}

/**
 * 获取图片的尺寸。
 * @param message
 * @returns
 */
export async function getImageShowSize(message: ChatMessage): Promise<image.Size> {
  try {
    const originalSize = await getImageAttachmentSize(message);
    if (!originalSize) {
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "original size is undefined."));
    }
    const originalWidth = px2vp(originalSize.width as number);
    const originalHeight = px2vp(originalSize.height as number);
    const maxWidth = px2vp((display.getDefaultDisplaySync().width as number) * (3/5.0));
    const maxHeight = px2vp((display.getDefaultDisplaySync().height as number) * (3/8.0));
    let radio = originalWidth * 1.0 / (originalHeight === 0 ? 1 : originalHeight);
    if (radio === 0) {
      radio = 1.0
    }
    if (0 <= radio && radio <= 1.0 / 10) {
      return {
        width: maxHeight / 10.0,
        height: maxHeight
      }
    } else if (radio >= 1.0 /10 && radio <= 3.0 / 4) {
      return {
        width: maxHeight * radio,
        height: maxHeight
      }
    } else if (radio >= 3.0 / 4 && radio <= 10.0) {
      return {
        width: maxWidth,
        height: maxWidth / radio
      }
    } else {
      return {
        width: maxWidth,
        height: maxWidth / 10
      }
    }
  } catch (e) {
    return Promise.reject(ChatTransfer.transferError(e as CommonError, "getImageShowSize"));
  }
}

/**
 * 获取消息内容的文本颜色
 * @param isSender
 * @returns
 */
export function getMessageContentFontColor(isSender: boolean) {
  return isSender ? $r('app.color.chat_color_text_primary_contrary') : $r('app.color.chat_color_text_primary');
}

/**
 * 获取文件长度的字符样式。
 * @param fileLength
 */
export function getMessageFileLengthStr(fileLength: number | undefined) {
  if (!fileLength) {
    return '';
  }
  if (fileLength < 1024) {
    return fileLength + 'B';
  } else if (fileLength < 1024 * 1024) {
    return (fileLength / 1024).toFixed() + 'KB';
  } else {
    return (fileLength / (1024 * 1024)).toFixed() + 'MB';
  }
}

/**
 * 是否是名片消息。
 * @param { ChatMessage } message - 消息对象。
 * @returns
 */
export function isUserCardMessage(message: ChatMessage): boolean {
  if (message.getType() === ContentType.CUSTOM) {
    const action = (message.getBody() as CustomMessageBody)?.event();
    return action === KitConstants.USER_CARD_EVENT;
  }
  return false;
}

/**
 * 获取名片信息。
 * @param message
 * @returns
 */
export function getUserCardInfo(message: ChatMessage): UserCard | undefined {
  if (isUserCardMessage(message)) {
    const ext = (message.getBody() as CustomMessageBody)?.getParams();
    if (!ext) {
      return undefined;
    }
    const uid = ext.get(KitConstants.USER_CARD_ID) as string;
    const nickname = ext.get(KitConstants.USER_CARD_NICK);
    const avatar = ext.get(KitConstants.USER_CARD_AVATAR);
    return new UserCard(uid, nickname, avatar);
  }
  return undefined;
}

/**
 * 获取名片信息中的头像。
 * @param message
 * @returns
 */
export function getUserCardAvatar(message: ChatMessage): string | undefined {
  let user = getUserCardInfo(message);
  if (user && user.avatar) {
    return user.avatar;
  }
  return undefined;
}

/**
 * 获取名片信息中的昵称。
 * @param message
 * @returns
 */
export function getUserCardNickname(message: ChatMessage): string | undefined {
  let user = getUserCardInfo(message);
  if (user) {
    if (user.nickname) {
      return user.nickname;
    }
    return user.uid;
  }
  return undefined;
}

export function convTypeToChat(convType: ConversationType): ChatType {
  return convType as number;
}

export function filterMessageMenu(menus: MessageMenuItem[], message: ChatMessage) {
  console.log('filterMessageMenu: '+menus.length);
  const result: MessageMenuItem[] = [];
  menus.forEach(item => {
    if (item.messageEnable === undefined) {
      result.push(item);
    } else if (item.messageEnable) {
      let isAdd = false;
      isAdd = item.messageEnable.isSender === undefined || item.messageEnable.isSender === isSender(message);
      if (!isAdd) {
        return;
      }
      if (item.messageEnable.messageTypes) {
        isAdd = item.messageEnable.messageTypes.includes(message.getType());
        if (!isAdd) {
          return;
        }
      }
      if (item.messageEnable.messageStatus) {
        isAdd = item.messageEnable.messageStatus.includes(message.getStatus());
        if (!isAdd) {
          return;
        }
      }
      isAdd = item.messageEnable.other === undefined || item.messageEnable.other;
      if (isAdd) {
        result.push(item);
      }
    }
  })
  return result;
}

/**
 * 获取消息编辑次数。
 * @param message
 * @returns
 */
export function getOperationCount(message: ChatMessage) {
  if (isText(message)) {
    return (message.getBody() as TextMessageBody).operationCount()
  } else {
    return 0;
  }
}

/**
 * 获取昵称
 * @param userId
 * @returns
 */
export function getNicknameFromMessage(userId: string) {
  return userId;
}

/**
 * 判断是否是回复消息。
 * @param message
 * @returns
 */
export function isReplyMessage(message: ChatMessage | ChatKitMessage): boolean {
  let msg: ChatMessage;
  if (message instanceof ChatMessage) {
    msg = message;
  } else {
    msg = message.origin;
  }
  return msg.ext().has(KitConstants.REPLY_MSG_QUOTE);
}

/**
 * 回复消息中，被回复消息构建ext。
 * @param message
 */
export function getReplyExt(message: ChatMessage | ChatKitMessage) {
  let msg: ChatMessage;
  if (message instanceof ChatMessage) {
    msg = message;
  } else {
    msg = message.origin;
  }
  let type = msg.getType();
  let info: Record<string, string> = {}
  info[KitConstants.REPLY_MSG_ID] = msg.getMsgId();
  info[KitConstants.REPLY_MSG_SENDER] = msg.getFrom();
  if (type === ContentType.TXT) {
    info[KitConstants.REPLY_MSG_PREVIEW] = (msg.getBody() as TextMessageBody).getContent();
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.txt]
  } else if (type === ContentType.IMAGE) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_image'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.img]
  } else if (type === ContentType.VIDEO) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_video'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.video]
  } else if (type === ContentType.LOCATION) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_location'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.location]
  } else if (type === ContentType.VOICE) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_voice'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.audio]
  } else if (type === ContentType.FILE) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_file'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.file]
  } else if (type === ContentType.CUSTOM) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_custom'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.custom]
  } else if (type === ContentType.COMBINE) {
    info[KitConstants.REPLY_MSG_PREVIEW] = getContext().resourceManager.getStringSync($r('app.string.chat_reply_preview_combine'));
    info[KitConstants.REPLY_MSG_TYPE] = ChatReplyContentType[ChatReplyContentType.combine]
  } else {
    info[KitConstants.REPLY_MSG_PREVIEW] = `[${ContentType[type].toLowerCase()}]`;
    info[KitConstants.REPLY_MSG_TYPE] = ContentType[type].toLowerCase();
  }
  return info;
}

/**
 * 解析回复消息携带的消息内容。
 * @param message
 * @returns
 */
export function parseMessageReplyInfo(message: ChatMessage | ChatKitMessage) {
  let msg: ChatMessage;
  if (message instanceof ChatMessage) {
    msg = message;
  } else {
    msg = message.origin;
  }
  if (!isReplyMessage(message)) {
    return undefined;
  }
  let ext = msg.ext().get(KitConstants.REPLY_MSG_QUOTE);
  if (typeof ext === 'string') {
    return JSON.parse(ext) as Record<string, string>;
  }
  return ext as Record<string, string>;
}

/**
 * 获取消息类型
 * @param replyType
 * @returns
 */
export function getMessageTypeByReply(replyType?: string): ContentType | undefined {
  if (replyType === ChatReplyContentType[ChatReplyContentType.txt]) {
    return ContentType.TXT;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.img]) {
    return ContentType.IMAGE;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.video]) {
    return ContentType.VIDEO;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.location]) {
    return ContentType.LOCATION;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.audio]) {
    return ContentType.VOICE;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.file]) {
    return ContentType.FILE;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.cmd]) {
    return ContentType.CMD;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.custom]) {
    return ContentType.CUSTOM;
  } else if (replyType === ChatReplyContentType[ChatReplyContentType.combine]) {
    return ContentType.COMBINE;
  } else {
    return undefined;
  }
}

/**
 * 设置语音消息已读。
 * @param message
 */
export function setVoiceMessageListened(message: ChatMessage) {
  message.setIsListened(true);
  uikit.sdk.chatManager()?.updateMessage(message);
}

/**
 * 是否是撤回占位消息。
 * @param origin
 * @returns
 */
export function isRecalledMessage(origin: ChatMessage): boolean {
  if (isText(origin)) {
    let ext = origin.ext();
    let isRecalledMessage = (ext.get(KitConstants.MESSAGE_TYPE_RECALL) as boolean) ?? false;
    return isRecalledMessage;
  }
  return false;
}

/**
 * 创建撤回占位消息
 * @param origin
 * @returns
 */
export function createRecalledMessage(origin: ChatMessage): ChatMessage {
  let isSend = isSender(origin);
  let content = isSend ? getString($r('app.string.chat_msg_recall_content_self')) :
    getString($r('app.string.chat_msg_recall_content_other'), ChatUserInfoManager.getInstance().getNickname(origin));
  let body: TextMessageBody = new TextMessageBody(content);
  let message: ChatMessage = isSend ?
    ChatMessage.createSendMessage(origin.getTo(), body, origin.getChatType()) :
    ChatMessage.createReceiveMessage(origin.getFrom(), body, origin.getChatType(), origin.getMsgId());
  message.setMsgId(origin.getMsgId());
  message.setServerTimestamp(origin.getServerTimestamp());
  message.setLocalTimestamp(origin.getLocalTimestamp());
  message.setExt(new Map<string, boolean>([[KitConstants.MESSAGE_TYPE_RECALL, true]]));
  message.setStatus(MessageStatus.SUCCESS);
  ChatClient.getInstance().chatManager()?.saveMessage(message);
  return message;
}

/**
 * 判断当前消息是否可以被编辑
 * @param message
 * @returns
 */
export function isMessageCanEdit(message: ChatMessage): boolean {
  const chatType = message.getChatType();
  const type = message.getType();
  const isSend = isSender(message);
  // 只支持文本消息编辑
  if (type != ContentType.TXT) {
    return false;
  }
  if (chatType === ChatType.Chat) {
    if (isSend) {
      const count = message.getBody()?.operationCount() ?? 10;
      if (count < 10) {
        return true;
      }
    }
  } else if (chatType === ChatType.GroupChat) {
    const group = uikit.sdk.groupManager()?.getGroup(message.getConversationId());
    const canEdit = isCurrentUser(group?.owner()) || group?.adminList().includes(uikit.sdk.getCurrentUser());
    if (isSend || canEdit) {
      let count = 10;
      try {
        count = message.getBody()?.operationCount() ?? 10;
      } catch (e) {
        count = 10;
      }
      if (count < 10) {
        return true;
      }
    }
  }
  return false;
}

/**
 * 判断消息是否可以被撤回
 * @param message
 * @returns
 */
export function isMessageCanRecall(message: ChatMessage): boolean {
  let current = new Date().getTime();
  return current - message.getServerTimestamp() <= (uikit.configs.chatConfigs?.timePeriodCanRecallMessage ?? 120000);
}

export function isBigExpressionMessage(message: ChatMessage): boolean {
  return message.getType() === ContentType.TXT && message.ext().has(KitConstants.MESSAGE_ATTR_IS_BIG_EXPRESSION);
}

/**
 * 获取消息内容。
 * @param message
 * @returns
 */
export function getMessageDigest(message?: ChatMessage): ResourceStr {
  if (!message) {
    return '';
  }
  const type = message.getType();
  const context = getContext();
  if (type === ContentType.LOCATION) {
    if (isSender(message)) {
      return $r('app.string.chat_msg_label_location_send');
    } else {
      return context.resourceManager.getStringSync($r('app.string.chat_msg_label_location_receive'), ChatUserInfoManager.getInstance().getNickname(message));
    }
  } else if (type === ContentType.IMAGE) {
    return $r('app.string.chat_msg_label_image');
  } else if (type === ContentType.VIDEO) {
    return $r('app.string.chat_msg_label_video');
  } else if (type === ContentType.VOICE) {
    return $r('app.string.chat_msg_label_voice');
  } else if (type === ContentType.FILE) {
    let filename = getFilename(message);
    return filename !== undefined ? `${context.resourceManager.getStringSync($r('app.string.chat_msg_label_file'))} ${filename}` : $r('app.string.chat_msg_label_file');
  } else if (type === ContentType.CUSTOM) {
    if (isUserCardMessage(message)) {
      return context.resourceManager.getStringSync($r('app.string.chat_msg_label_user_card'), ChatUserInfoManager.getInstance().getUserCardNickname(message));
    } else {
      return $r('app.string.chat_msg_label_custom');
    }
  } else if (type === ContentType.COMBINE) {
    return $r('app.string.chat_msg_label_combine');
  } else if (type === ContentType.TXT) {
    let content = (message.getBody() as TextMessageBody).getContent();
    if (isBigExpressionMessage(message)) {
      if (!content) {
        return $r('app.string.chat_msg_label_dynamic_expression');
      }
    }
    return content;
  } else {
    return '';
  }
}

/**
 * 判断是否时群@消息且是@当前用户的。
 * @param message
 * @returns
 */
export function isGroupMentionMessage(message: ChatMessage | ChatKitMessage) {
  let msg: ChatMessage;
  if (message instanceof ChatKitMessage) {
    msg = message.origin;
  } else {
    msg = message;
  }
  if (msg.getChatType() != ChatType.GroupChat) {
    return false;
  }
  let ext = msg.ext();
  if (ext.has(KitConstants.MESSAGE_ATTR_AT_MSG)) {
    let mentionListJson = ext.get(KitConstants.MESSAGE_ATTR_AT_MSG) as string[];
    if (mentionListJson.includes(KitConstants.AT_ALL_LABEL)) {
      return true;
    }
    if (mentionListJson.includes(uikit.sdk.getCurrentUser())) {
      return true;
    }
  }
  return false;
}

/**
 * 获取消息内容中@All和@当前用户的内容。
 * @param content
 * @returns
 */
export function getMessageMentionInfo(content?: string): string[] {
  if (!content) {
    return [''];
  }
  let subStr = StringUtil.splitByKeyword(content, KitConstants.AT_PREFIX + KitConstants.AT_ALL_LABEL);
  let nickname = ChatUserInfoManager.getInstance().getCurrentUser().getNickname();
  let result: string[] = [];
  subStr.forEach(item => {
    result.push(...StringUtil.splitByKeyword(item, KitConstants.AT_PREFIX + nickname));
  })
  return result;
}

/**
 * 向消息的扩展信息中添加当前用户信息。
 * @param message
 * @param user
 */
export function addUserInfo(message: ChatMessage) {
  let user = uikit.user;
  if (!user.nickname && user.avatar && user.remark) {
    return;
  }
  let info: MessageUserInfo = new MessageUserInfo();
  if (user.nickname) {
    info.nickname = user.nickname;
  }
  if (user.avatar && typeof user.avatar === 'string') {
    info.avatarURL = user.avatar;
  }
  if (user.remark) {
    info.remark = user.remark;
  }
  message.setJsonAttribute(KitConstants.MESSAGE_EXT_USER_INFO_KEY, info);
}

/**
 * 消息中是否包含用户信息。
 * @param message
 * @returns
 */
export function isIncludeUserInfo(message: ChatMessage) {
  let ext = message.ext();
  return ext.has(KitConstants.MESSAGE_EXT_USER_INFO_KEY);
}

/**
 * 从消息中获取携带的用户信息。
 * @param message
 * @returns
 */
export function getUserInfoFromMessage(message: ChatMessage): ChatUser | undefined {
  if (isIncludeUserInfo(message)) {
    let ext = message.ext();
    let userJsonStr = ext.get(KitConstants.MESSAGE_EXT_USER_INFO_KEY);
    let userInfo: object | null = null;
    if (typeof userJsonStr === 'string') {
      userInfo = parseJson(userJsonStr);
    } else if (typeof userJsonStr === 'object') {
      userInfo = userJsonStr as object;
    }
    if (userInfo) {
      let keys = Object.keys(userInfo);
      let user = new ChatUser(message.getFrom());
      keys.forEach(key => {
        if (userInfo) {
          if (key === KitConstants.MESSAGE_EXT_USER_INFO_NICKNAME_KEY) {
            user.nickname = userInfo[key];
          } else if (key === KitConstants.MESSAGE_EXT_USER_INFO_AVATAR_KEY) {
            user.avatar = userInfo[key];
          } else if (key === KitConstants.MESSAGE_EXT_USER_INFO_REMARK_KEY) {
            user.remark = userInfo[key];
          }
        }
      })
      ChatUserInfoManager.getInstance().updateUser(user);
      return user;
    }
  }
  return undefined;
}

