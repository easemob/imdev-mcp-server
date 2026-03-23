import { Conversation, CursorResult, PushRemindType } from '@easemob/chatsdk';
import kitClient from '../internal/ChatUIKit';
import uikit from '../internal/ChatUIKit';
import { ChatKitConversation } from '../model/ChatKitConversation';
import { ChatTransfer } from '../internal/ChatTransfer';

export class ConversationRepo {

  static async fetchConversations(limit: number, cursor: string): Promise<CursorResult<ChatKitConversation> | null> {
    let result = await kitClient.sdk.chatManager()?.fetchConversationsFromServer(limit, cursor);
    if (!result) {
      return null;
    }
    return ChatTransfer.transferCursorResult<Conversation, ChatKitConversation>(result, (conv: Conversation) => {
      return ChatTransfer.revertConversation(conv);
    });
  }

  static getConversations(): Array<ChatKitConversation> | null {
    let result = kitClient.sdk.chatManager()?.getAllConversationsBySort();
    if (!result) {
      return null;
    }
    return result.map((conv: Conversation) => {
      return ChatTransfer.revertConversation(conv);
    });
  }

  static async muteConversation(conv: Conversation) {
    return await uikit.sdk.pushManager()?.setSilentModeForConversation(conv.conversationId(), conv.getType(), PushRemindType.NONE);
  }

  static async unmuteConversation(conv: Conversation) {
    return await uikit.sdk.pushManager()?.clearRemindTypeForConversation(conv.conversationId(), conv.getType());
  }

  static async pinConversation(conv: Conversation, isPin: boolean) {
    return await uikit.sdk.chatManager()?.pinConversation(conv.conversationId(), isPin);
  }

  static deleteConversationFromLocal(conv: Conversation, isRemoveMessages: boolean) {
    return uikit.sdk.chatManager()?.deleteConversation(conv.conversationId(), isRemoveMessages);
  }

  static async removeConversationFromServer(conv: Conversation, isRemoveMessages: boolean) {
    return await uikit.sdk.chatManager()?.deleteConversationFromServer(conv.conversationId(), conv.getType(), isRemoveMessages);
  }
}