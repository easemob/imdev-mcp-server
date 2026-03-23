import { ChatError, ChatType, Conversation, ConversationType } from '@easemob/chatsdk';
import uikit from '../internal/ChatUIKit';
import { TextParseResult } from '../internal/model/EmojiIcon';
import { ChatKitConversation } from '../model/ChatKitConversation';
import { contentParsed, getMessageDigest } from '../utils/MessageUtil';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { groupInfoManager } from '../internal/manager/ChatGroupInfoManager';
import { ChatGroupProfile, ChatUserProfile } from '../../../../Index';
import { getGroupName } from '../utils/GroupUtil';

/**
 * 会话信息管理类
 */
export class ChatConvInfoManager {
  private static instance: ChatConvInfoManager | undefined;
  private constructor() {}

  static getInstance() {
    if (!ChatConvInfoManager.instance) {
      ChatConvInfoManager.instance = new ChatConvInfoManager();
    }
    return ChatConvInfoManager.instance;
  }

  getConversationInfo(conversation: Conversation): ChatUserProfile | ChatGroupProfile | undefined;
  getConversationInfo(conversationId: string, conversationType: ConversationType): ChatUserProfile | ChatGroupProfile | undefined;
  /**
   * 从缓存中获取会话信息。
   * @param conversation
   * @param conversationType
   * @returns
   */
  getConversationInfo(conversation: Conversation | string, conversationType?: ConversationType): ChatUserProfile | ChatGroupProfile | undefined {
    let type = ConversationType.Chat;
    let conversationId = '';
    if (typeof conversation === 'string') {
      conversationId = conversation;
      type = conversationType!;
    } else {
      conversationId = conversation.conversationId();
      type = conversation.getType();
    }
    // 从缓存中获取
    if (type === ConversationType.Chat) {
      let user = ChatUserInfoManager.getInstance().getUserProfileFromCache(conversationId);
      if (user) {
        return user.getUserProfile();
      }
    } else if (type === ConversationType.GroupChat) {
      let group = groupInfoManager.getGroupInfoFromCache(conversationId);
      if (group) {
        if (!group.name) {
          group.name = getGroupName(conversationId);
        }
        return group;
      }
    }
    return undefined;
  }

  /**
   * 异步获取会话信息。
   * @param conversationId
   * @param conversationType
   * @returns
   */
  async getConversationInfoAsync(conversationId: string, conversationType: ConversationType): Promise<ChatUserProfile | ChatGroupProfile> {
    if (conversationType === ConversationType.Chat) {
      return (await ChatUserInfoManager.getInstance().getUserProfile(conversationId)).getUserProfile()
    } else if (conversationType === ConversationType.GroupChat) {
      return await groupInfoManager.getGroupInfo(conversationId)
    }
    return Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, 'Not chat or group chat.'));
  }

  /**
   * 获取会话的展示名称。
   * @param conv
   * @returns
   */
  getConversationName(conversation: Conversation | string, chatType?: ChatType): string {
    let conv: Conversation | undefined = undefined;
    let type = ConversationType.Chat;
    let conversationId = '';
    if (typeof conversation === 'string') {
      conversationId = conversation;
      conv = uikit.sdk.chatManager()?.getConversation(conversation);
      if (!conv && chatType) {
        type = chatType as number;
      }
    } else {
      conv = conversation;
    }
    if (conv) {
      conversationId = conv.conversationId();
      type = conv.getType();
    }
    // 如果缓存中有的话，返回缓存中的数据
    let info = this.getConversationInfo(conversationId, type);
    if (info) {
      return info.name ?? conversationId;
    }
    // 如果缓存中没有，去向用户要，如果用户提供了，则更新对象对应的属性
    if (type === ConversationType.Chat) {
      ChatUserInfoManager.getInstance().getUserProfile(conversationId);
    } else if (type === ConversationType.GroupChat) {
      groupInfoManager.getGroupInfo(conversationId);
      let groupName = getGroupName(conversationId);
      if (groupName) {
        return groupName;
      }
    }
    return conversationId;
  }

  getConversationAvatar(conv: Conversation): ResourceStr;
  getConversationAvatar(conv: string, convType: ConversationType): ResourceStr;
  /**
   * 获取会话的头像
   * @param conv
   * @returns
   */
  getConversationAvatar(conv: Conversation | string, convType?: ConversationType): ResourceStr {
    let type = ConversationType.Chat;
    let conversation: Conversation | undefined;
    let conversationId: string;
    if (typeof conv === 'string') {
      conversationId = conv;
      conversation = uikit.sdk.chatManager()?.getConversation(conv);
      if (conversation) {
        type = conversation.getType();
      } else {
        type = convType!;
      }
    } else {
      conversation = conv;
      type = conv.getType();
      conversationId = conv.conversationId();
    }
    // 如果缓存中有的话，返回缓存中的数据
    let info = this.getConversationInfo(conversationId, type);
    if (info && info.avatar) {
      return info.avatar;
    }
    // 缓存中没有则使用默认头像
    if (type === ConversationType.Chat) {
      return $r('app.media.avatar_default');
    } else if (type === ConversationType.GroupChat) {
      return $r('app.media.avatar_group_default');
    } else {
      return $r('app.media.avatar_group_default');
    }
  }

  /**
   * 获取最新一条消息内容。
   * @param conv
   * @returns
   */
  getLatestMessageContent(conv: Conversation): ResourceStr {
    if (!conv.getLatestMessage()) {
      return '';
    }
    return getMessageDigest(conv.getLatestMessage());
  }

  /**
   * 获取最新一条消息内容。
   * @param conv
   * @returns
   */
  getLatestMessageParsedContent(conv: ChatKitConversation): TextParseResult[] | undefined {
    let result = this.getLatestMessageContent(conv.origin);
    let contentStr = '';
    if (typeof result === 'string') {
      contentStr = result;
    } else {
      contentStr = getContext().resourceManager.getStringSync(result);
    }
    if (conv.origin.getType() !== ConversationType.Chat) {
      if (conv.latestUser) {
        let nickname = conv.latestUser.name;
        contentStr = nickname + ": " + contentStr;
      }
    }
    return contentParsed(contentStr);
  }
}