import {
  ChatError,
  ChatMessage,
  Conversation,
  ConversationType,
  CursorResult,
  FetchMessageOption,
  SearchDirection
} from '@easemob/chatsdk';
import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import kitClient from '../internal/ChatUIKit';
import { ChatKitMessage } from '../model/ChatKitMessage';

export class ChatRepo {

  /**
   * 从服务器获取消息。
   * @param conversationId
   * @param conversationType
   * @param pageSize
   * @param cursor
   * @param fetchOption
   * @returns
   */
  static async fetchHistoryMessagesFromServer(
    conversationId: string,
    conversationType: ConversationType,
    pageSize: number,
    cursor: string,
    fetchOption: FetchMessageOption): Promise<CursorResult<ChatKitMessage>> {
    try {
      let cursorResult =
        await kitClient.sdk.chatManager()?.fetchHistoryMessages(conversationId, conversationType, pageSize, cursor,
          fetchOption);
      if (cursorResult) {
        return ChatTransfer.transferCursorResult(cursorResult, (msg: ChatMessage) => {
          return new ChatKitMessage(msg);
        })
      }
      return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "fetchHistoryMessagesFromServer result is undefined."))
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, "fetchHistoryMessagesFromServer"));
    }
  }

  /**
   * 从指定消息 ID 开始分页加载数据库中的消息。
   * @param conversation
   * @param startMsgId
   * @param pageSize
   * @param direction
   * @returns
   */
  static async loadMoreMessages(conversation: Conversation, startMsgId: string, pageSize: number, direction: SearchDirection = SearchDirection.UP) {
    let msgs = await conversation.loadMoreMessagesFromDB(startMsgId, pageSize, direction);
    const result: ChatKitMessage[] = [];
    msgs.forEach(item => {
      result.push(new ChatKitMessage(item));
    })
    return result;
  }
}