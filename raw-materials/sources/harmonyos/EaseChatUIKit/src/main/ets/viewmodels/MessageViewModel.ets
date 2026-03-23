import {
  ChatCallback,
  ChatClient,
  ChatError,
  ChatLog,
  ChatMessage,
  ChatType,
  CmdMessageBody,
  ContentType,
  CustomMessageBody,
  FileMessageBody,
  GroupReadAck,
  TextMessageBody
} from '@easemob/chatsdk';
import { kitMedia } from '../manager/MediaManager';
import { getFilePath, getRandomFilename } from '../internal/utils/UIKitUtils';
import uikit from '../internal/ChatUIKit';
import { MessageContent } from '../model/Message';
import { KitConstants } from '../../../../Index';
import { isCurrentUser } from '../utils/GroupUtil';
import { JSON } from '@kit.ArkTS';
import { ChatKitContact } from '../model/ChatKitContact';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { EventBus, getEventStr } from '../utils/EventBus';
import { addUserInfo } from '../utils/MessageUtil';

export type OnMessageError = (messageId: string, error: ChatError) => void;
export type OnMessageSuccess = (olsMsgId: string, message: ChatMessage) => void;
export type OnMessageProgress = (message: ChatMessage, progress: number) => void;
export type OnMessageCallback = (message: ChatMessage) => void;
export type OnEditSuccess = OnMessageCallback;
export type OnEditError = OnMessageError;

export abstract class BaseMessageViewModel {
  protected conversationId: string;
  protected chatType: ChatType;
  // 发送成功的回调
  onMessageSendSuccess?: OnMessageSuccess;
  // 发送失败的回调
  onMessageSendFailed?: OnMessageError;
  // 发送过程中的回调
  onMessageProgress?: OnMessageProgress;
  // 已发送的回调
  onMessageSent?: OnMessageCallback;
  // 发送前回调
  onWillSendMessage?: OnMessageCallback;
  onEditSuccess?: OnEditSuccess;
  onEditError?: OnEditError;

  constructor(conversationId: string, chatType: ChatType = ChatType.Chat) {
    this.conversationId = conversationId;
    this.chatType = chatType;
  }

  /**
   * 发送消息的逻辑
   * @param message
   * @param onError
   * @param onSuccess
   * @param onProgress
   */
  abstract sendMessage(message: ChatMessage | undefined, onError: OnMessageError, onSuccess: OnMessageSuccess, onProgress: OnMessageProgress);

  /**
   * 发送前执行该方法，在{@Link sendMessage}中调用。
   * @param message
   */
  abstract willSendMessage(message: ChatMessage);

  /**
   * 发送命令消息
   * @param action
   * @param onError
   * @param onSuccess
   */
  abstract sendCmdMessage(action: string, onError: OnMessageError, onSuccess: OnMessageSuccess);

  /**
   * 发送文本消息
   * @param content
   * @param isNeedGroupAck
   * @param onError
   * @param onSuccess
   */
  sendTextMessage(content?: MessageContent, isNeedGroupAck: boolean = false, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {}

  /**
   * 发送语音消息
   * @param voicePath
   * @param duration
   * @param onError
   * @param onSuccess
   */
  sendVoiceMessage(voicePath: string, duration: number, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {}

  /**
   * 发送图片消息
   * @param imagePath
   * @param onError
   * @param onSuccess
   * @param onProgress
   */
  sendImageMessage(imagePath: string, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {}

  /**
   * 发送视频消息
   * @param videoPath
   * @param duration
   * @param onError
   * @param onSuccess
   * @param onProgress
   */
  sendVideoMessage(videoPath: string, duration: number, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {}

  /**
   * 发送文件消息
   * @param filePath
   * @param onError
   * @param onSuccess
   * @param onProgress
   */
  sendFileMessage(filePath: string, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {}

  /**
   * 发送名片消息
   * @param { string | ChatKitContact } user - 要发送的用户ID或者对象。
   * @param onError
   * @param onSuccess
   */
  sendUserCard(user: string | ChatKitContact, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {}

  /**
   * 编辑消息
   * @param messageId
   * @param modifiedBody
   * @param onError
   * @param onSuccess
   */
  editMessage(messageId: string, modifiedBody: TextMessageBody | CustomMessageBody, onError: OnEditError = () => {}, onSuccess: OnEditSuccess = () => {}) {}

  /**
   * 重新发送消息的逻辑
   * @param message
   * @param onError
   * @param onSuccess
   * @param onProgress
   */
  resendMessage(message: ChatMessage | undefined, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {}
}

export class MessageViewModel extends BaseMessageViewModel {

  willSendMessage(message: ChatMessage): void {
    // 统一添加相同的ext时调用
  }

  private callError(messageId: string, code: number, error: string, onError?: OnMessageError) {
    onError?.(messageId, ChatError.createError(code, error));
    this.onMessageSendFailed?.(messageId, ChatError.createError(code, error));
  }

  private callSuccess(oldMsgId: string, message: ChatMessage, onSuccess?: OnMessageSuccess) {
    onSuccess?.(oldMsgId, message);
    this.onMessageSendSuccess?.(oldMsgId, message);
  }

  private callProgress(message: ChatMessage, progress: number, onProgress?: OnMessageProgress) {
    onProgress?.(message, progress);
    this.onMessageProgress?.(message, progress);
  }

  sendMessage(message: ChatMessage | undefined, onError: OnMessageError, onSuccess: OnMessageSuccess, onProgress: OnMessageProgress = () => {}) {
    if (!message) {
      this.callError('', ChatError.INVALID_PARAM, "Message is undefined!", onError)
      return
    }
    let oldMsgId = message.getMsgId();
    let callback: ChatCallback = {
      onSuccess: (): void => {
        this.callSuccess(oldMsgId, message, onSuccess);
      },
      onError: (code: number, error: string): void => {
        this.callError(message.getMsgId(), code, error, onError);
        // 消息发送失败，通知对应的会话进行刷新。
        EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_CONV_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION), this.conversationId);
      },
      onProgress: (progress: number): void => {
        this.callProgress(message, progress, onProgress);
      }
    };
    message.setMessageStatusCallback(callback);
    if (this.chatType === ChatType.GroupChat) {
      message.setChatType(ChatType.GroupChat);
    } else if (this.chatType === ChatType.ChatRoom) {
      message.setChatType(ChatType.ChatRoom);
    }
    addUserInfo(message);
    this.onWillSendMessage?.(message);
    this.willSendMessage(message);
    ChatClient.getInstance().chatManager()?.sendMessage(message);
    this.onMessageSent?.(message);
    // 通知会话列表进行刷新。
    EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_CONV_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION));
  }

  sendCmdMessage(action: string, onError: OnMessageError, onSuccess: OnMessageSuccess) {
    let cmdBody = new CmdMessageBody(action);
    let message = ChatMessage.createSendMessage(this.conversationId, cmdBody, this.chatType);
    let oldMsgId = message.getMsgId();
    message.setMessageStatusCallback({
      onSuccess: () => {
        onSuccess(oldMsgId, message);
      },
      onError: (code: number, error: string) => {
        onError(message.getMsgId(), ChatError.createError(code, error));
      }
    })
    ChatClient.getInstance().chatManager()?.sendMessage(message);
  }

  sendCustomMessage(to: string, event: string, exts: Map<string, string> = new Map(), onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {
    let customMessageBody = new CustomMessageBody(event);
    customMessageBody.setParams(exts);
    let message = ChatMessage.createSendMessage(to, customMessageBody, ChatType.Chat);
    //this.sendMessage(message, "custom", onError, onSuccess);
  }

  sendTextMessage(content?: MessageContent, isNeedGroupAck: boolean = false, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {
    if (!content || !content.value) {
      this.callError('', ChatError.INVALID_PARAM, "消息内容不能为空！");
      return;
    }
    let message = ChatMessage.createTextSendMessage(this.conversationId, content.value);
    if (!message) {
      this.callError('', ChatError.MESSAGE_INVALID, "消息对象不合法！");
      return;
    }
    if (this.chatType === ChatType.GroupChat) {
      message.setIsNeedGroupAck(isNeedGroupAck);
      // 添加@逻辑
      if (content.atList) {
        if (content.atList.includes(KitConstants.AT_ALL_LABEL)) {
          let owner = uikit.sdk.groupManager()?.getGroup(this.conversationId)?.owner();
          if (isCurrentUser(owner)) {
            let ext: Map<string, string> = new Map();
            ext.set(KitConstants.MESSAGE_ATTR_AT_MSG, KitConstants.AT_ALL_LABEL);
            message.setExt(ext);
          }
        } else {
          message.setJsonAttribute(KitConstants.MESSAGE_ATTR_AT_MSG, content.atList);
        }
      }
    }
    this.sendMessage(message, onError, onSuccess)
  }

  sendVoiceMessage(voicePath: string, duration: number, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {
    if (!voicePath) {
      this.callError('', ChatError.INVALID_PARAM, "语音文件不能为空！");
      return;
    }
    let message = ChatMessage.createVoiceSendMessage(this.conversationId, voicePath, duration);
    if (!message) {
      this.callError('', ChatError.MESSAGE_INVALID, "消息对象不合法！");
      return;
    }
    this.sendMessage(message, onError, onSuccess);
  }

  sendImageMessage(imagePath: string, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {
    this.sendMessage(ChatMessage.createImageSendMessage(this.conversationId, imagePath), onError, onSuccess, onProgress);
  }

  sendVideoMessage(videoPath: string, duration: number, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {
    let thumbnailPath = getFilePath(this.conversationId, getRandomFilename('.jpg'));
    if (thumbnailPath) {
      kitMedia.getVideoFirstFrame(videoPath, thumbnailPath).then((result) => {
        let message = ChatMessage.createVideoSendMessage(this.conversationId, videoPath, duration, result);
        this.sendMessage(message, onError, onSuccess, onProgress)
      }).catch(() => {
        let message = ChatMessage.createVideoSendMessage(this.conversationId, videoPath, duration);
        this.sendMessage(message, onError, onSuccess, onProgress)
      })
    } else {
      let message = ChatMessage.createVideoSendMessage(this.conversationId, videoPath, duration);
      this.sendMessage(message, onError, onSuccess, onProgress)
    }
  }

  sendFileMessage(filePath: string, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {
    let message = ChatMessage.createFileSendMessage(this.conversationId, filePath);
    this.sendMessage(message, onError, onSuccess, onProgress);
  }

  sendUserCard(user: string | ChatKitContact, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}) {
    let id = '';
    let nickname = '';
    let avatar = '';
    if (typeof user === 'string') {
      let userInfo = ChatUserInfoManager.getInstance().getUserInfo(user);
      id = userInfo.userId;
      nickname = userInfo.nickname ?? '';
      if (userInfo.avatar && typeof userInfo.avatar === 'string') {
        avatar = userInfo.avatar
      } else {
        avatar = '';
      }
    } else {
      id = user.id;
      nickname = user.nickname ?? '';
      if (user.avatar && typeof user.avatar === 'string') {
        avatar = user.avatar
      } else {
        avatar = '';
      }
    }
    let body = new CustomMessageBody(KitConstants.USER_CARD_EVENT);
    let params: Map<string, string> = new Map();
    params.set(KitConstants.USER_CARD_ID, id);
    params.set(KitConstants.USER_CARD_NICK, nickname);
    params.set(KitConstants.USER_CARD_AVATAR, avatar);
    body.setParams(params);
    let message = ChatMessage.createSendMessage(this.conversationId, body, this.chatType);
    this.sendMessage(message, onError, onSuccess);
  }

  editMessage(messageId: string, modifiedBody: TextMessageBody | CustomMessageBody, onError: OnEditError = () => {}, onSuccess: OnEditSuccess = () => {}) {
    uikit.sdk.chatManager()?.modifyMessage(messageId, modifiedBody).then(result => {
      onSuccess(result);
      this.onEditSuccess?.(result);
    }).catch((e: ChatError) => {
      onError(messageId, e);
      this.onEditError?.(messageId, e);
    })
  }

  resendMessage(message: ChatMessage | undefined, onError: OnMessageError = () => {}, onSuccess: OnMessageSuccess = () => {}, onProgress: OnMessageProgress = () => {}) {
    if (!message) {
      this.callError('', ChatError.INVALID_PARAM, "Message is undefined!", onError)
      return
    }
    let oldMsgId = message.getMsgId();
    let callback: ChatCallback = {
      onSuccess: (): void => {
        this.callSuccess(oldMsgId, message, onSuccess);
      },
      onError: (code: number, error: string): void => {
        this.callError(message.getMsgId(), code, error, onError);
      },
      onProgress: (progress: number): void => {
        this.callProgress(message, progress, onProgress);
      }
    };
    message.setMessageStatusCallback(callback);
    ChatClient.getInstance().chatManager()?.sendMessage(message);
  }

  getLatestMessage(conversationId: string): ChatMessage | undefined {
    let conv = ChatClient.getInstance().chatManager()?.getConversation(conversationId);
    if (conv) {
      return conv.getLatestMessage();
    }
    return undefined;
  }

}