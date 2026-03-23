import { ChatError, ContactListener } from '@easemob/chatsdk';
import uikit from '../internal/ChatUIKit';
import { DataPreferenceManager } from '../internal/manager/DataPreferenceManager';
import { ChatKitContact, ContactsGroup } from '../model/ChatKitContact';
import { ErrorInfo } from '../model/ErrorInfo';
import { BaseListViewModel } from './ChatViewModel';
import { intl } from '@kit.LocalizationKit';
import { ContactRepo } from '../repositories/ContactRepo';
import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import { StringUtil } from '../utils/StringUtil';
import { GroupRepo } from '../repositories/GroupRepo';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { appendFlag, getString } from '../utils/CommonUtils';
import { EventBus, getEventStr, KitConstants } from '../../../../Index';
import listenerWrapper from '../internal/wapper/ChatListenersWrapper';
import { NotificationRepository } from '../repositories/NotificationRepository';

@ObservedV2
export abstract class BaseContactListViewModel extends BaseListViewModel<ContactsGroup> {
  @Trace alphabets: string[] = [];
  @Trace joinedGroupCount: number = 0;
  @Trace newRequestCount: number = 0;
  @Trace allLocalContacts: ChatKitContact[] = [];
  @Trace searchResult: ChatKitContact[] = [];

  abstract getContacts();

  abstract sortContacts(contacts: ChatKitContact[]): ChatKitContact[];

  abstract sortContactsGroup();

  abstract getAlphabets();

  abstract fetchJoinedGroupCount();

  /**
   * 获取本地新请求的未读数量。
   */
  abstract getNewRequestsCount();

  /**
   * 在本地搜索会话。
   * @param { string } key
   * @returns { ChatKitConversation[] }
   */
  abstract searchContacts(key: string);

  /**
   * 向用户提供一组联系人id，并要求返回一组联系人信息。
   * @param start
   * @param end
   */
  abstract fetchContacts(start: number, end: number);
}

export class ContactListViewModel extends BaseContactListViewModel {
  static IS_LOAD_CONTACT_FROM_SERVER: string = 'is_load_contact_from_server';
  protected declare collator: intl.Collator;
  private hasLoaded: boolean = false;
  private requestRepository: NotificationRepository = new NotificationRepository();
  private listener: ContactListener = {
    onContactAdded: (userId: string) => {
      this.getContactList();
    },
    onContactDeleted: (userId: string) => {
      this.getContactList();
    },
    onFriendRequestAccepted: (userId: string) => {
      this.getContactList();
    }
  }

  aboutToAppear(): void {
    this.collator = new intl.Collator('zh-CN', {
      localeMatcher: 'lookup',
      usage: 'sort',
      sensitivity: 'case'
    })
    this.getContactList();
    this.fetchJoinedGroupCount();
    this.getNewRequestsCount();
    // 监听通知
    EventBus.global().on(getEventStr(KitConstants.EVENTBUS_CONTACT_FLAG, KitConstants.EVENTBUS_ADD_ACTION), () => {
      this.getContactList();
    })
    EventBus.global().on(getEventStr(KitConstants.EVENTBUS_NOTIFICATION_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION), () => {
      this.getNewRequestsCount();
    })

    listenerWrapper.addContactChangeListener(this.listener);
  }

  aboutToDisAppear(): void {
    listenerWrapper.removeContactChangeListener(this.listener);
  }

  private getContactList() {
    this.getContacts().catch((e: CommonError) => {
      this.errorInfo = ErrorInfo.create('getContacts', ChatTransfer.transferError(e));
    });
  }

  async getContacts() {
    if (!uikit.sdk.isSdkInited()) {
      this.errorInfo = ErrorInfo.create("getContactsFromLocal", ChatError.createError(ChatError.GENERAL_ERROR, "SDK is not initialized."));
      return;
    }
    let key = appendFlag(ContactListViewModel.IS_LOAD_CONTACT_FROM_SERVER);
    let isLoaded = DataPreferenceManager.getInstance().getSync(key, false) as boolean;
    let map: Map<string, ChatKitContact[]> = new Map();
    if (isLoaded) {
      let result = await ContactRepo.getContactsFromLocal();
      this.allLocalContacts = result;
      result.forEach(item => {
        let key = item.firstLetter;
        if (!map.get(key)) {
          map.set(key, []);
        }
        let value = map.get(key)!!;
        value.push(item);
        map.set(key, value);
      })
      let groupList: ContactsGroup[] = [];
      map.forEach((items, key) => {
        const group = new ContactsGroup();
        group.key = key;
        group.contacts = this.sortContacts(items);
        groupList.push(group);
      })
      this.dataList = groupList;
      this.sortContactsGroup();
      this.getAlphabets();
    } else {
      this.allLocalContacts = [];
      let pageSize = 50;
      let cursor = '';
      let groupList: ContactsGroup[] = [];
      do {
        let cursorResult = await ContactRepo.fetchContactsFromServer(pageSize, cursor);
        cursor = cursorResult.getNextCursor();
        cursorResult.getResult().forEach(item => {
          let key = item.firstLetter;
          if (!map.get(key)) {
            map.set(key, []);
          }
          let value = map.get(key)!!;
          value.push(item);
          map.set(key, value);
        })
      } while (cursor)
      DataPreferenceManager.getInstance().putSync(key, true);
      map.forEach((items, key) => {
        const group = new ContactsGroup();
        group.key = key;
        group.contacts = this.sortContacts(items);
        groupList.push(group);
        this.allLocalContacts.push(...items);
      })
      this.dataList = groupList;
      this.sortContactsGroup();
      this.getAlphabets();
    }
    this.hasLoaded = true;
  }

  sortContacts(contacts: ChatKitContact[]): ChatKitContact[] {
    contacts.sort((a, b) => {
      return this.collator.compare(a.en_name, b.en_name);
    })
    return contacts;
  }

  sortContactsGroup(): void {
    this.dataList.sort((a, b) => {
      if (StringUtil.isLetter(a.key) && StringUtil.isLetter(b.key)) {
        return this.collator.compare(a.key, b.key);
      } else if (StringUtil.isLetter(a.key)) {
        // 如果只有一个是字母，字母排在前面
        return -1;
      } else if (StringUtil.isLetter(b.key)) {
        return 1;
      }
      // 非字母的字符彼此之间按字典顺序排序
      return this.collator.compare(a.key, b.key);
    })
  }

  getAlphabets(): void {
    let letterArr: string[] = [];
    this.dataList.forEach(item => {
      letterArr.push(item.key);
    })
    this.alphabets = letterArr;
  }

  fetchJoinedGroupCount(): void {
    GroupRepo.fetchJoinedGroupsCount().then((count) => {
      this.joinedGroupCount = count ?? 0;
    }).catch((e: ChatError) => {
      this.errorInfo = ErrorInfo.create("fetchJoinedGroupsCount", ChatError.createError(e.errorCode, e.description));
    })
  }

  getNewRequestsCount(): void {
    this.newRequestCount = this.requestRepository.getUnreadNotifications();
  }

  async searchContacts(key: string) {
    if (!key) {
      this.searchResult = [];
      return;
    }
    if (this.allLocalContacts.length === 0) {
      this.allLocalContacts = await ContactRepo.getContactsFromLocal();
    }
    let arr: ChatKitContact[] = [];
    if (this.allLocalContacts) {
      this.allLocalContacts.forEach(item => {
        let id = item.id;
        let name = item.nickname ?? id;
        if (name.includes(key) || id.includes(key)) {
          arr.push(item);
        }
      })
    }
    this.searchResult = arr;
  }

  async fetchContacts(start: number, end: number): Promise<void> {
    if (end <= start || !this.hasLoaded) {
      return;
    }
    let result: string[] = [];
    this.dataList.forEach((group, index) => {
      if (index < end) {
        group.contacts?.forEach(item => {
          let user = ChatUserInfoManager.getInstance().getUserProfileFromCache(item.id);
          if (!user) {
            result.push(item.id);
          }
        })
      }
      if (index === end) {
        group.contacts?.forEach(item => {
          if (result.length < 100) {
            let user = ChatUserInfoManager.getInstance().getUserProfileFromCache(item.id);
            if (!user) {
              result.push(item.id);
            }
          }
        })
      }
    })
    let users = await ChatUserInfoManager.getInstance().getUserProfiles(result);
    if (users && users.length > 0) {
      setTimeout(()=> {
        this.updateAllData();
      }, 100);
    }
  }

  private updateAllData() {
    this.dataList = [];
    let map: Map<string, ChatKitContact[]> = new Map();
    console.log('contact all contact size: '+this.allLocalContacts.length)
    this.allLocalContacts.forEach(item => {
      item.update();
      let key = item.firstLetter;
      if (!map.get(key)) {
        map.set(key, []);
      }
      let value = map.get(key)!!;
      value.push(item);
      map.set(key, value);
    })
    this.allLocalContacts = [];
    let groupList: ContactsGroup[] = [];
    map.forEach((items, key) => {
      const group = new ContactsGroup();
      group.key = key;
      group.contacts = this.sortContacts(items);
      groupList.push(group);
      this.allLocalContacts.push(...items);
    })
    this.dataList = groupList;
    console.log('contact after all contact size: '+this.allLocalContacts.length)
    console.log('contact after group size: '+this.dataList.length)
    this.dataList.forEach(item => {
      console.log("contact group item size: "+item.contacts?.length);
    })
    this.sortContactsGroup();
    this.getAlphabets();
  }

}

@ObservedV2
export abstract class BaseContactViewModel {
  /**
   * 添加联系人
   * @param userId
   */
  abstract addContact(userId: string): Promise<void> ;
}

export class ContactViewModel extends BaseContactViewModel {

  async addContact(userId: string): Promise<void> {
    try {
      await ContactRepo.addContact(userId)
    } catch (e) {
      let code = ChatError.GENERAL_ERROR;
      let description = getString($r('app.string.add_contact_common_error'));
      if (e instanceof ChatError) {
        code = e.errorCode;
        if (e.errorCode === ChatError.CONTACT_REACH_LIMIT) {
          description = getString($r('app.string.add_contact_reach_limit'));
        } else if (e.errorCode === ChatError.CONTACT_REACH_LIMIT_PEER) {
          description = getString($r('app.string.add_contact_reach_limit_peer'));
        }
      }
      return Promise.reject(ChatError.createError(code, description));
    }
  }

}