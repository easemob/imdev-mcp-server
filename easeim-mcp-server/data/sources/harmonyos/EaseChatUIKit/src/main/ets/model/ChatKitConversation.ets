import { ChatMessage, Conversation, ConversationType, PushRemindType } from '@easemob/chatsdk';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { mentionManager } from '../manager/GroupChatMentionManager';
import { ChatKitBaseModel } from './ChatKitBaseModel';
import { ChatUserProfile } from './ChatUserProfile';
import { ChatGroupProfile } from './ChatGroupProfile';
import { ChatConvInfoManager } from '../../../../Index';
import { getGroupName } from '../utils/GroupUtil';

@ObservedV2
export class ChatKitConversation extends ChatKitBaseModel<Conversation>{
  declare conversationId: string;
  declare type: ConversationType;
  @Trace latestMessage?: ChatMessage;
  @Trace unreadCount?: number;
  @Trace isPinned: boolean = false;
  @Trace isMuted: boolean = false;
  /**
   * 会话信息，报错名称和头像
   */
  @Trace profile?: ChatUserProfile | ChatGroupProfile;
  /**
   * 是否有@All或者@当前用户的未读消息
   */
  @Trace hasMention: boolean = false;
  /**
   * 最近一条消息的发送人
   */
  @Trace latestUser?: ChatUserProfile;

  constructor(conversation: Conversation) {
    super();
    this.origin = conversation;
    this.update();
  }

  update() {
    if (this.origin) {
      this.conversationId = this.origin.conversationId();
      this.type = this.origin.getType();
      this.latestMessage = this.origin.getLatestMessage();
      this.unreadCount = this.origin.getUnreadMsgCount();
      this.isPinned = this.origin.isPinned();
      this.isMuted = this.origin.pushRemindType() != PushRemindType.ALL;
      this.hasMention = mentionManager.isContainsTarget(this.conversationId);
      if (this.latestMessage) {
        this.latestUser = ChatUserInfoManager.getInstance().getUserInfo(this.latestMessage, false).getUserProfile();
      }
      this.getConversationInfo();
    }
  }

  getConversationInfo(): ChatUserProfile | ChatGroupProfile {
    let info = ChatConvInfoManager.getInstance().getConversationInfo(this.origin)
    if (!info) {
      ChatConvInfoManager.getInstance().getConversationInfoAsync(this.conversationId, this.type).then((profile) => {
        // 返回结果后，赋值给profile属性。
        this.profile = profile;
      })
      // 先返回结果。
      let profile: ChatUserProfile | ChatGroupProfile;
      if (this.type === ConversationType.Chat) {
        profile = new ChatUserProfile();
        profile.id = this.conversationId;
      } else {
        profile = new ChatGroupProfile();
        profile.id = this.conversationId;
        if (this.type === ConversationType.GroupChat) {
          profile.name = getGroupName(this.conversationId);
        }
      }
      this.profile = profile;
      return profile;
    }
    this.profile = info;
    return info;
  }

  getName(): string {
    let name = this.profile?.name;
    if (!name && this.type === ConversationType.GroupChat) {
      name = getGroupName(this.conversationId);
    }
    return name ?? this.conversationId;
  }

  getAvatar(): ResourceStr {
    return this.profile?.avatar ??
      ((this.type === ConversationType.Chat) ?
      $r('app.media.avatar_default') :
      $r('app.media.avatar_group_default'));
  }

}