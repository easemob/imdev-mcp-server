import { ChatClient, ChatMessage, MessageStatus } from '@easemob/chatsdk';
import { MessageSentStatus } from '../../model/ComponentStatus';
import { fileIo as fs } from '@kit.CoreFileKit';
import { isSender } from '../../utils/MessageUtil';
import { Context } from '@kit.AbilityKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import uikit from '../ChatUIKit';
import { CornerStyle } from '../../model/CornerStyle';

/**
 * 获取消息发送状态。
 * @param { ChatMessage } message - 消息对象。
 * @returns
 */
export function getMessageSentStatus(message: ChatMessage) {
  if (isSender(message)) {
    let sentStatus = MessageSentStatus.SUCCESS;
    const status = message.getStatus();
    if (status === MessageStatus.PROGRESSING) {
      sentStatus = MessageSentStatus.PROGRESSING;
    } else if (status === MessageStatus.CREATE || status === MessageStatus.FAIL) {
      sentStatus = MessageSentStatus.FAILED;
    } else {
      if (message.isDelivered()) {
        sentStatus = MessageSentStatus.DELIVERED;
      } else if (message.isReceiverRead()) {
        sentStatus = MessageSentStatus.READ;
      }
    }
    return sentStatus;
  } else {
    return MessageSentStatus.SUCCESS;
  }
}

/**
 * 获取消息发送状态资源。
 * @param status
 * @returns
 */
export function getIconByMessageSentStatus(status: MessageSentStatus) {
  let res = $r('app.media.spinner');
  if (status === MessageSentStatus.SUCCESS) {
    res = $r('app.media.message_sent');
  } else if (status === MessageSentStatus.FAILED) {
    res = $r('app.media.message_fail');
  } else if (status === MessageSentStatus.DELIVERED) {
    res = $r('app.media.message_delivered');
  } else if (status === MessageSentStatus.READ) {
    res = $r('app.media.message_read');
  }
  return res;
}

/**
 * 获取会话下的文件路径。
 * @param conversationId
 * @returns
 */
export function getFilePath(conversationId: string | undefined, filename: string): string | undefined {
  let filePath: string | undefined;
  if (!ChatClient.getInstance().isSdkInited()) {
    filePath = undefined;
  }
  if (!conversationId) {
    filePath = ChatClient.getInstance().getOptions()?.getDownloadPath();
  }
  filePath = ChatClient.getInstance().getOptions()?.getDownloadPath() + "/" + ChatClient.getInstance().getCurrentUser() + "/" + conversationId;
  if (!fs.accessSync(filePath)) {
    console.log("filePath: "+filePath);
    fs.mkdirSync(filePath, true);
  }
  if (filePath) {
    return filePath + "/" + filename;
  }
  return filePath;
}

export function getRandomFilename(suffix?: string) {
  let temp = new Date().getTime() + "";
  return temp + (suffix ? "." + suffix : "");
}

/**
 * 设置弹起软键盘时窗口进行重新布局。
 * @param context
 */
export function resizeSoftware(context: Context) {
  try {
    window.getLastWindow(context, (err, data) => {
      if (err.code) {
        return;
      }
      data.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
    });
  } catch (exception) {
  }
}

/**
 * 给布尔类型设置默认值，当有undefined的时候。
 * @param enable
 * @param defaultValue
 * @returns
 */
export function booleanDefault(enable?: boolean, defaultValue: boolean = true): boolean {
  return enable ?? defaultValue
}

/**
 * 是否是圆角模式
 * @returns
 */
export function isRoundStyle(): boolean {
  return !(uikit.configs.cornerStyle === CornerStyle.CIRCLE)
}

/**
 * 获取默认的圆角
 * @returns
 */
export function getDefaultBorderRadius() {
  return isRoundStyle() ? 4 : '50%';
}