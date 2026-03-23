import { ChatKitMessage } from '../../model/ChatKitMessage';

/**
 * 从列表中删除指定消息id的消息
 * @param msgId
 * @param msgs
 * @returns
 */
export function deleteFromArray<T extends ChatKitMessage>(msg: string | T, msgs: T[]) {
  let index = findIndex(msg, msgs);
  if (index === -1) {
    return false;
  }
  msgs.splice(index, 1);
  return true;
}

/**
 * 更新列表中的指定消息。
 * @param msg
 * @param msgs
 * @returns
 */
export function update<T extends ChatKitMessage>(msg: string | T, msgs: T[]);
/**
 * 将旧的消息替换为新的消息。
 * @param oldMsgId
 * @param newMsg
 * @param msgs
 */
export function update<T extends ChatKitMessage>(oldMsgId: string, newMsg: T, msgs: T[]);
export function update<T extends ChatKitMessage>(oldMsg: string | T, newMsg: T | T[], msgs?: T[]) {
  if (typeof(newMsg as T).messageId === 'string') {
    let index = findIndex(oldMsg, msgs!);
    if (index === -1) {
      return false;
    }
    let target = (msgs as Array<T>)[index];
    if (target.uuid === (newMsg as T).uuid) {
      target.update();
    } else {
      msgs?.splice(index, 1, (newMsg as T));
    }
    return true;
  } else {
    let index = findIndex(oldMsg, newMsg as Array<T>);
    if (index === -1) {
      return false;
    }
    let target = (newMsg as Array<T>)[index];
    target.update();
    return true;
  }
}

/**
 * 找到指定消息的index，如果没有找到则返回-1.
 * @param msg
 * @param msgs
 * @returns
 */
export function findIndex<T extends ChatKitMessage>(msg: string | T, msgs: T[]) {
  let msgId: string = '';
  if (typeof msg === 'string') {
    msgId = msg;
  } else {
    msgId = msg.messageId;
  }
  return msgs.findIndex((item) => item.messageId === msgId);
}

/**
 * 是否找到指定的消息。
 * @param msg
 * @param msgs
 * @param find
 * @param notFind
 */
export function findFunc<T extends ChatKitMessage>(msg: string | T, msgs: T[], find: (index: number) => void, notFind: () => void = () => {}) {
  let msgId: string = '';
  if (typeof msg === 'string') {
    msgId = msg;
  } else {
    msgId = msg.messageId;
  }
  let index = msgs.findIndex((item) => item.messageId === msgId);
  if (index !== -1) {
    find(index);
  } else {
    notFind();
  }
}