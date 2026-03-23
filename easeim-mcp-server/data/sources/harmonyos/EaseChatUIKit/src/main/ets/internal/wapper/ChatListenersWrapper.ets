import {
  ChatClient,
  ChatLog,
  ChatMessage,
  ChatMessageListener,
  ChatMessagePinInfo,
  ChatMessageReactionChange,
  ConnectionListener,
  ContactListener,
  ConversationListener,
  ConversationType,
  Group,
  GroupListener,
  GroupReadAck,
  LoginExtInfo,
  MultiDevicesEvent,
  MultiDevicesListener,
  PinOperation,
  Presence,
  PresenceListener,
  RecallMessageInfo,
  SharedFile
} from '@easemob/chatsdk';
import ArrayList from '@ohos.util.ArrayList';
import { ChatUserInfoManager } from '../manager/ChatUserInfoManager';
import { mentionManager } from '../../manager/GroupChatMentionManager';
import { createRecalledMessage } from '../../utils/MessageUtil';
import { ChatTransfer, CommonError } from '../ChatTransfer';
import { NotificationRepository } from '../../repositories/NotificationRepository';

export class ChatListenersWrapper {
  private connectListeners = new ArrayList<ConnectionListener>();
  private messageListeners = new ArrayList<ChatMessageListener>();
  private groupListeners = new ArrayList<GroupListener>();
  private contactListeners = new ArrayList<ContactListener>();
  private convListeners = new ArrayList<ConversationListener>();
  private presenceListeners = new ArrayList<PresenceListener>();
  private multiDeviceListeners = new ArrayList<MultiDevicesListener>();

  private connectListener: ConnectionListener = {
    onConnected: (): void => {
      this.notifyConnectionListener(listener => listener.onConnected());
    },
    onDisconnected: (errorCode: number): void => {
      this.notifyConnectionListener(listener => listener.onDisconnected(errorCode));
    },
    onLogout: (errorCode: number, info: LoginExtInfo): void => {
      this.notifyConnectionListener(listener => listener.onLogout?.(errorCode, info));
    },
    onTokenExpired: (): void => {
      this.notifyConnectionListener(listener => listener.onTokenExpired?.());
    },
    onTokenWillExpire: (): void => {
      this.notifyConnectionListener(listener => listener.onTokenWillExpire?.());
    },
    onOfflineMessageSyncStart: (): void =>
    {
      this.notifyConnectionListener(listener => listener.onOfflineMessageSyncStart?.());
    },
    onOfflineMessageSyncFinish: (): void => {
      this.notifyConnectionListener(listener => listener.onOfflineMessageSyncFinish?.());
    }
  }
  private messageListener: ChatMessageListener = {
    onMessageReceived: (messages: ChatMessage[]): void => {
      mentionManager.checkReceiveMessages(messages);
      ChatUserInfoManager.getInstance().receiveMessages(messages);
      this.notifyMessageListener(listener => listener.onMessageReceived(messages));
    },
    onCmdMessageReceived: (messages: Array<ChatMessage>): void => {
      this.notifyMessageListener(listener => listener.onCmdMessageReceived?.(messages));
    },
    onMessageRead: (messages: Array<ChatMessage>): void => {
      this.notifyMessageListener(listener => listener.onMessageRead?.(messages));
    },
    onMessageDelivered: (messages: Array<ChatMessage>): void => {
      this.notifyMessageListener(listener => listener.onMessageDelivered?.(messages));
    },
    onMessageRecalled: (recallInfo: Array<RecallMessageInfo>): void => {
      // 增加全局的操作，防止出现没有注册监听，导致没有及时构建撤回消息的问题
      if (recallInfo && recallInfo.length > 0) {
        recallInfo.forEach(item => {
          mentionManager.removeTargetMessage(item.getConversationId(), item.getRecallMessageId());
          let message = item.getRecallMessage();
          if (message) {
            createRecalledMessage(message)
          }
        })
      }
      this.notifyMessageListener(listener => listener.onMessageRecalled?.(recallInfo));
    },
    onMessageChanged: (message: ChatMessage, change: object): void => {
      this.notifyMessageListener(listener => listener.onMessageChanged?.(message, change));
    },
    onGroupMessageRead: (groupReadAcks: Array<GroupReadAck>): void => {
      this.notifyMessageListener(listener => listener.onGroupMessageRead?.(groupReadAcks));
    },
    onReadAckForGroupMessageUpdated: (): void => {
      this.notifyMessageListener(listener => listener.onReadAckForGroupMessageUpdated?.());
    },
    onMessageContentChanged: (modifiedMessage: ChatMessage, operatorId: string, operationTime: number): void => {
      this.notifyMessageListener(listener => listener.onMessageContentChanged?.(modifiedMessage, operatorId, operationTime));
    },
    onReactionChanged: (messageReactionChange: Array<ChatMessageReactionChange>): void => {
      this.notifyMessageListener(listener => listener.onReactionChanged?.(messageReactionChange));
    },
    onMessagePinChanged: (messageId: string, conversationId: string, pinOperation: PinOperation, pinInfo: ChatMessagePinInfo): void => {
      this.notifyMessageListener(listener => listener.onMessagePinChanged?.(messageId, conversationId, pinOperation, pinInfo));
    },
  }
  private groupListener: GroupListener = {
    onInvitationReceived: (groupId: string, groupName: string, inviter: string, reason: string): void => {
      this.notifyGroupListener(listener => listener.onInvitationReceived?.(groupId, groupName, inviter, reason));
    },
    
    onRequestToJoinReceived: (groupId: string, groupName: string, applicant: string, reason: string): void => {
      this.notifyGroupListener(listener => listener.onRequestToJoinReceived?.(groupId, groupName, applicant, reason));
    },
    
    onRequestToJoinAccepted: (groupId: string, groupName: string, accepter: string): void => {
      this.notifyGroupListener(listener => listener.onRequestToJoinAccepted?.(groupId, groupName, accepter));
    },
    
    onRequestToJoinDeclined: (groupId: string, groupName: string, decliner: string, applicant: string, reason: string): void => {
      this.notifyGroupListener(listener => listener.onRequestToJoinDeclined?.(groupId, groupName, decliner, applicant, reason));
    },
    
    onInvitationAccepted: (groupId: string, invitee: string, reason: string): void => {
      this.notifyGroupListener(listener => listener.onInvitationAccepted?.(groupId, invitee, reason));
    },
    
    onInvitationDeclined: (groupId: string, invitee: string, reason: string): void => {
      this.notifyGroupListener(listener => listener.onInvitationDeclined?.(groupId, invitee, reason));
    },
    
    onUserRemoved: (groupId: string, groupName: string): void => {
      this.notifyGroupListener(listener => listener.onUserRemoved?.(groupId, groupName));
    },
    
    onGroupDestroyed: (groupId: string, groupName: string): void => {
      this.notifyGroupListener(listener => listener.onGroupDestroyed?.(groupId, groupName));
    },
    
    onAutoAcceptInvitationFromGroup: (groupId: string, inviter: string, inviteMessage: string): void => {
      this.notifyGroupListener(listener => listener.onAutoAcceptInvitationFromGroup?.(groupId, inviter, inviteMessage));
    },
    
    onMutelistAdded: (groupId: string, mutes: Array<string>, muteExpire: number): void => {
      this.notifyGroupListener(listener => listener.onMutelistAdded?.(groupId, mutes, muteExpire));
    },
    
    onMutelistRemoved: (groupId: string, mutes: Array<string>): void => {
      this.notifyGroupListener(listener => listener.onMutelistRemoved?.(groupId, mutes));
    },
    
    onWhitelistAdded: (groupId: string, whitelist: Array<string>): void => {
      this.notifyGroupListener(listener => listener.onWhitelistAdded?.(groupId, whitelist));
    },
    
    onWhitelistRemoved: (groupId: string, whitelist: Array<string>): void => {
      this.notifyGroupListener(listener => listener.onWhitelistRemoved?.(groupId, whitelist));
    },
    
    onAllMemberMuteStateChanged: (groupId: string, isMuted: boolean): void => {
      this.notifyGroupListener(listener => listener.onAllMemberMuteStateChanged?.(groupId, isMuted));
    },
    
    onAdminAdded: (groupId: string, administrator: string): void => {
      this.notifyGroupListener(listener => listener.onAdminAdded?.(groupId, administrator));
    },
    
    onAdminRemoved: (groupId: string, administrator: string): void => {
      this.notifyGroupListener(listener => listener.onAdminRemoved?.(groupId, administrator));
    },
    
    onOwnerChanged: (groupId: string, newOwner: string, oldOwner: string): void => {
      this.notifyGroupListener(listener => listener.onOwnerChanged?.(groupId, newOwner, oldOwner));
    },
    
    onMemberJoined: (groupId: string, member: string): void => {
      this.notifyGroupListener(listener => listener.onMemberJoined?.(groupId, member));
    },
    
    onMemberExited: (groupId: string, member: string): void => {
      this.notifyGroupListener(listener => listener.onMemberExited?.(groupId, member));
    },
    
    onAnnouncementChanged: (groupId: string, announcement: string): void => {
      this.notifyGroupListener(listener => listener.onAnnouncementChanged?.(groupId, announcement));
    },
    
    onSharedFileAdded: (groupId: string, sharedFile: SharedFile): void => {
      this.notifyGroupListener(listener => listener.onSharedFileAdded?.(groupId, sharedFile));
    },
    
    onSharedFileDeleted: (groupId: string, fileId: string): void => {
      this.notifyGroupListener(listener => listener.onSharedFileDeleted?.(groupId, fileId));
    },
    
    onSpecificationChanged: (group: Group): void => {
      this.notifyGroupListener(listener => listener.onSpecificationChanged?.(group));
    },
    
    onStateChanged: (group: Group, isDisabled: boolean): void => {
      this.notifyGroupListener(listener => listener.onStateChanged?.(group, isDisabled));
    },
    
    onGroupMemberAttributeChanged: (groupId: string, member: string, attributes: Map<string, string>, from: string): void => {
      this.notifyGroupListener(listener => listener.onGroupMemberAttributeChanged?.(groupId, member, attributes, from));
    },
  }
  private contactListener: ContactListener = {
    onContactAdded: (userId: string): void => {
      this.notifyContactListener(listener => listener.onContactAdded?.(userId));
    },
    
    onContactDeleted: (userId: string): void => {
      this.notifyContactListener(listener => listener.onContactDeleted?.(userId));
    },
    
    onContactInvited: (userId: string, reason: string): void => {
      // 创建本地通知消息，并保存到本地。
      NotificationRepository.createNotification(userId, reason);
      this.notifyContactListener(listener => listener.onContactInvited?.(userId, reason));
    },
    
    onFriendRequestAccepted: (userId: string): void => {
      this.notifyContactListener(listener => listener.onFriendRequestAccepted?.(userId));
    },
    
    onFriendRequestDeclined: (userId: string): void => {
      this.notifyContactListener(listener => listener.onFriendRequestDeclined?.(userId));
    },
  }
  private convListener: ConversationListener = {
    onConversationUpdate: (): void => {
      this.notifyConversationListener(listener => listener.onConversationUpdate?.());
    },
    onConversationRead: (from: string, to: string): void => {
      this.notifyConversationListener(listener => listener.onConversationRead?.(from, to));
    }
  }
  private presenceListener: PresenceListener = {
    onPresenceUpdated: (presences: Presence[]): void => {
      this.notifyPresenceListener(listener => listener.onPresenceUpdated(presences));
    }
  }
  private multiDeviceListener: MultiDevicesListener = {
    onContactEvent: (event: MultiDevicesEvent, target: string, ext: string): void => {
      this.notifyMultiDeviceListener(listener => listener.onContactEvent(event, target, ext));
    },
    onGroupEvent: (event: MultiDevicesEvent, target: string, userIds: string[]): void => {
      this.notifyMultiDeviceListener(listener => listener.onGroupEvent(event, target, userIds));
    },
    onMessageRemoved: (conversationId: string, deviceId: string): void => {
      this.notifyMultiDeviceListener(listener => listener.onMessageRemoved(conversationId, deviceId));
    },
    onConversationEvent: (event: MultiDevicesEvent, conversationId: string, type: ConversationType): void => {
      this.notifyMultiDeviceListener(listener => listener.onConversationEvent?.(event, conversationId, type));
    },
  }

  private notifyConnectionListener(action: (listener: ConnectionListener) => void) {
    if (this.connectListeners.isEmpty()) return;
    this.connectListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  private notifyMessageListener(action: (listener: ChatMessageListener) => void) {
    if (this.messageListeners.isEmpty()) return;
    this.messageListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  private notifyGroupListener(action: (listener: GroupListener) => void) {
    if (this.groupListeners.isEmpty()) return;
    this.groupListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  private notifyContactListener(action: (listener: ContactListener) => void) {
    if (this.contactListeners.isEmpty()) return;
    this.contactListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  private notifyConversationListener(action: (listener: ConversationListener) => void) {
    if (this.convListeners.isEmpty()) return;
    this.convListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  private notifyPresenceListener(action: (listener: PresenceListener) => void) {
    if (this.presenceListeners.isEmpty()) return;
    this.presenceListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  private notifyMultiDeviceListener(action: (listener: MultiDevicesListener) => void) {
    if (this.multiDeviceListeners.isEmpty()) return;
    this.multiDeviceListeners.forEach(listener => {
      try {
        action(listener);
      } catch (e) {
        ChatLog.e(ChatTransfer.transferError(e as CommonError, action.name).description)
      }
    })
  }

  register() {
    ChatClient.getInstance().addConnectionListener(this.connectListener);
    ChatClient.getInstance().chatManager()?.addMessageListener(this.messageListener);
    ChatClient.getInstance().chatManager()?.addConversationListener(this.convListener);
    ChatClient.getInstance().groupManager()?.addListener(this.groupListener);
    ChatClient.getInstance().contactManager()?.addContactListener(this.contactListener);
    ChatClient.getInstance().presenceManager()?.addListener(this.presenceListener);
    ChatClient.getInstance().addMultiDevicesListener(this.multiDeviceListener);
  }

  unregister() {
    this.clear();
    ChatClient.getInstance().removeConnectionListener(this.connectListener);
    ChatClient.getInstance().chatManager()?.removeMessageListener(this.messageListener);
    ChatClient.getInstance().chatManager()?.removeConversationListener(this.convListener);
    ChatClient.getInstance().groupManager()?.removeListener(this.groupListener);
    ChatClient.getInstance().contactManager()?.removeContactListener(this.contactListener);
    ChatClient.getInstance().presenceManager()?.removeListener(this.presenceListener);
    ChatClient.getInstance().removeMultiDevicesListener(this.multiDeviceListener);
  }

  clear() {
    this.connectListeners.clear();
    this.messageListeners.clear();
    this.convListeners.clear();
    this.groupListeners.clear();
    this.contactListeners.clear();
    this.presenceListeners.clear();
    this.multiDeviceListeners.clear();
  }

  addConnectionListener(listener: ConnectionListener) {
    if (this.connectListeners.has(listener)) return;
    this.connectListeners.add(listener);
  }

  removeConnectionListener(listener: ConnectionListener) {
    this.connectListeners.remove(listener);
  }

  addMessageChangeListener(listener: ChatMessageListener) {
    if (this.messageListeners.has(listener)) return;
    this.messageListeners.add(listener);
  }

  removeMessageChangeListener(listener: ChatMessageListener) {
    this.messageListeners.remove(listener);
  }

  addGroupChangeListener(listener: GroupListener) {
    if (this.groupListeners.has(listener)) return;
    this.groupListeners.add(listener);
  }

  removeGroupChangeListener(listener: GroupListener) {
    this.groupListeners.remove(listener);
  }

  addContactChangeListener(listener: ContactListener) {
    if (this.contactListeners.has(listener)) return;
    this.contactListeners.add(listener);
  }

  removeContactChangeListener(listener: ContactListener) {
    this.contactListeners.remove(listener);
  }

  addConversationChangeListener(listener: ConversationListener) {
    if (this.convListeners.has(listener)) return;
    this.convListeners.add(listener);
  }

  removeConversationChangeListener(listener: ConversationListener) {
    this.convListeners.add(listener);
  }

  addPresenceChangeListener(listener: PresenceListener) {
    if (this.presenceListeners.has(listener)) return;
    this.presenceListeners.add(listener);
  }

  removePresenceChangeListener(listener: PresenceListener) {
    this.presenceListeners.remove(listener);
  }

  addMultiDeviceListener(listener: MultiDevicesListener) {
    if (this.multiDeviceListeners.has(listener)) return;
    this.multiDeviceListeners.add(listener);
  }

  removeMultiDeviceListener(listener: MultiDevicesListener) {
    this.multiDeviceListeners.remove(listener);
  }

}

const listenerWrapper = new ChatListenersWrapper();
export default listenerWrapper;