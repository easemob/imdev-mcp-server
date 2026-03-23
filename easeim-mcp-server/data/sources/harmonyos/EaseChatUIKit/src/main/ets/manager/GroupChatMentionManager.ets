import { ChatMessage } from '@easemob/chatsdk';
import { JSON } from '@kit.ArkTS';
import { appendFlag } from '../utils/CommonUtils';
import { isGroupMentionMessage } from '../utils/MessageUtil';
import { DataPreferenceManager } from '../internal/manager/DataPreferenceManager';

export class GroupChatMentionManager {
  private atMap: Map<string, string[]> = new Map();
  private static readonly atKey = "em_at_list";

  private getAtKeyInDP() {
    return appendFlag(GroupChatMentionManager.atKey);
  }

  /**
   * 从DataPreference中读取@相关信息。
   */
  getAtMapFromDP() {
    let jsonData = DataPreferenceManager.getInstance().getSync(this.getAtKeyInDP(), '') as string;
    if (jsonData) {
      this.atMap.clear();
      let dataArray = JSON.parse(jsonData) as Array<(string | string[])[]>;
      dataArray.forEach((arr, index) => {
        let key = arr[0] as string;
        let value = arr[1] as string[];
        this.atMap.set(key, value);
      })
    }
  }

  /**
   * 将更新后的atMap信息存储到DataPreference中。
   */
  updateAtMapToDP() {
    let atMapJson = JSON.stringify(Array.from(this.atMap.entries()));
    DataPreferenceManager.getInstance().putSync(this.getAtKeyInDP(), atMapJson);
  }

  /**
   * 检查并添加有@当前用户的消息id。
   * @param messages
   */
  checkReceiveMessages(messages: ChatMessage[]) {
    let needUpdate = false;
    messages.forEach(message => {
      if (isGroupMentionMessage(message)) {
        if (this.atMap.has(message.getConversationId())) {
          let atList = this.atMap.get(message.getConversationId());
          if (!atList) {
            atList = new Array<string>();
          }
          atList.push(message.getMsgId());
          this.atMap.set(message.getConversationId(), atList);
          needUpdate = true;
        } else {
          let atList: string[] = [];
          atList.push(message.getMsgId());
          this.atMap.set(message.getConversationId(), atList);
          needUpdate = true;
        }
      }
    })
    if (needUpdate) {
      this.updateAtMapToDP();
    }
  }

  /**
   * 收到撤回消息的时候，需要调用这个方法。
   * @param conversationId
   * @param messageId
   */
  removeTargetMessage(conversationId: string, messageId: string) {
    let needUpdate = false;
    if (this.atMap.has(conversationId)) {
      let atList = this.atMap.get(conversationId);
      if (atList && atList.includes(messageId)) {
        let index = atList.indexOf(messageId);
        atList.splice(index, 1);
        needUpdate = true;
      }
      if (atList?.length === 0) {
        this.atMap.delete(conversationId);
      }
    }
    if (needUpdate) {
      this.updateAtMapToDP();
    }
  }

  /**
   * 调用会话置为已读时，调用这个方法。
   * @param conversationId
   */
  removeTarget(conversationId: string) {
    let needUpdate = false;
    if (this.atMap.has(conversationId)) {
      this.atMap.delete(conversationId);
      needUpdate = true;
    }
    if (needUpdate) {
      this.updateAtMapToDP();
    }
  }

  /**
   * 退出登录的时候，需要调用这个方法。
   */
  removeAll() {
    this.atMap.clear();
  }

  isContainsTarget(conversationId: string) {
    return this.atMap.has(conversationId);
  }
}

export const mentionManager = new GroupChatMentionManager();