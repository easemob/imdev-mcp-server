import { ChatError } from '@easemob/chatsdk';
import { KitConstants } from '../constants/KitConstants';
import { ErrorInfo } from '../model/ErrorInfo';
import { ChatKitNotification, NotificationStatus } from '../model/Notification';
import { NotificationRepository } from '../repositories/NotificationRepository';
import { EventBus, getEventStr } from '../utils/EventBus';
import { BaseListViewModel } from './ChatViewModel';

export abstract class BaseNewRequestViewModel extends BaseListViewModel<ChatKitNotification> {

  /**
   * 加载本地所有的通知消息。
   */
  abstract loadAllNotificationMessages();

  /**
   * 同意好友邀请。
   * @param notification
   */
  abstract agreeInvitation(notification: ChatKitNotification);

  /**
   * 拒绝好友邀请。
   * @param notification
   */
  abstract refuseInvitation(notification: ChatKitNotification);

  /**
   * 删除本地邀请通知消息。
   * @param notification
   */
  abstract deleteInvitation(notification: ChatKitNotification);

  abstract getUnreadCount(): number;
}

export class NewRequestViewModel extends BaseNewRequestViewModel{
  private declare repository: NotificationRepository;

  constructor() {
    super();
    this.repository = new NotificationRepository();
  }

  aboutToAppear(): void {
    this.loadAllNotificationMessages();
    if (this.getUnreadCount() > 0) {
      this.repository.markAllNotificationRead();
      EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_NOTIFICATION_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION));
    }
  }

  aboutToDisAppear(): void {

  }

  loadAllNotificationMessages(): void {
    this.repository.getAllNotifications().then((notifications) => {
      this.isRefreshing = false;
      this.dataList = notifications.map((msg) => new ChatKitNotification(msg));
    }).catch((e: ChatError) => {
      this.isRefreshing = false;
      this.errorInfo = ErrorInfo.create('loadAllNotificationMessages', e);
    });
  }

  agreeInvitation(notification: ChatKitNotification): void {
    let userId = this.getFrom(notification);
    if (userId) {
      this.repository.agreeInvite(userId)?.then(() => {
        // 同意好友请求后，删除当条记录
        let index = this.dataList.indexOf(notification);
        notification.status = NotificationStatus.CONTACT_AGREED;
        this.dataList.splice(index, 1, notification);
        this.repository.removeNotification(notification.origin);
        // 通知联系人列表刷新
        EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_CONTACT_FLAG, KitConstants.EVENTBUS_ADD_ACTION));
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('agreeInvitation', e);
      })
    }
  }

  refuseInvitation(notification: ChatKitNotification): void {
    let userId = this.getFrom(notification);
    if (userId) {
      this.repository.refuseInvite(userId)?.then(() => {
        // 删除当条记录
        let index = this.dataList.indexOf(notification);
        notification.status = NotificationStatus.CONTACT_REFUSED;
        this.dataList.splice(index, 1, notification);
        this.repository.removeNotification(notification.origin);
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('refuseInvitation', e);
      })
    }
  }

  deleteInvitation(notification: ChatKitNotification): void {
    let result = this.repository.removeNotification(notification.origin);
    if (result) {
      let index = this.dataList.indexOf(notification);
      this.dataList.splice(index, 1);
    }
  }

  getUnreadCount(): number {
    return this.repository.getUnreadNotifications();
  }

  private getFrom(notification: ChatKitNotification): string | undefined {
    if (!NotificationRepository.isNotification(notification.origin)) {
      return undefined;
    }
    return notification.origin.ext().get(KitConstants.DEFAULT_SYSTEM_NOTIFICATION_FROM) as string;
  }
}