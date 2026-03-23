import { ChatMessage } from '@easemob/chatsdk';
import { KitConstants } from '../constants/KitConstants';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { ChatUser } from '../internal/model/ChatUser';
import { NotificationRepository } from '../repositories/NotificationRepository';
import { ChatKitBaseModel } from './ChatKitBaseModel';

@ObservedV2
export class ChatKitNotification extends ChatKitBaseModel<ChatMessage> {
  declare id: string;
  @Trace user?: ChatUser;
  @Trace status: NotificationStatus = NotificationStatus.CONTACT_INVITED;
  @Trace content: string = '';

  constructor(message: ChatMessage) {
    super();
    this.origin = message;
    this.id = this.origin.getMsgId();
    this.update();
  }

  update(): void {
    if (NotificationRepository.isNotification(this.origin)) {
      let ext = this.origin.ext();
      this.status = ext.get(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_STATUS) as number;
      let from = ext.get(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_FROM) as string;
      this.content = NotificationRepository.getNotificationContent(from, this.status);
      ChatUserInfoManager.getInstance().getUserProfile(from).then(user => {
        this.user = user;
      });
    }
  }

}

export enum NotificationStatus {
  /**
   * 收到好友邀请。
   */
  CONTACT_INVITED,
  /**
   * 收到好友拒绝事件。
   */
  CONTACT_REFUSED,
  /**
   * 收到好友同意事件。
   */
  CONTACT_AGREED
}