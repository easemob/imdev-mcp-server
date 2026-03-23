import { ChatError } from '@easemob/chatsdk';
import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import uikit from '../internal/ChatUIKit';
import { ContactModel } from '../model/ContactModel';
import { getGroupAllLabel, isCurrentUser } from '../utils/GroupUtil';

@ObservedV2
export abstract class BaseGroupMemberViewModel {
  protected declare groupId: string
  @Trace contacts: ContactModel[] = [];
  @Trace isLoading: boolean = false;
  @Trace hasMore: boolean = true;

  /**
   * 获取群组成员列表。
   * @param { number } pageSize - 每页返回的群组成员数。
   */
  abstract fetchGroupMembers(pageSize?: number);

  /**
   * 获取更多的群组成员列表。
   * @param { number } pageSize - 每页返回的群组成员数。
   * @param { string } cursor - 可选参数，从这个游标位置开始取数据，首次获取数据时可不传或传 ""。
   */
  abstract fetchMoreGroupMembers(pageSize?: number, cursor?: string);
}

export class GroupMemberViewModel extends BaseGroupMemberViewModel {
  private cursor: string = '';
  private pageSize: number = 20;

  constructor(groupId: string) {
    super();
    this.groupId = groupId;
  }

  async fetchGroupMembers(pageSize?: number | undefined): Promise<void> {
    if (pageSize) {
      this.pageSize = pageSize;
    }
    this.cursor = '';
    this.contacts.splice(0, this.contacts.length);
    let contactList: ContactModel[] = [];
    let group = uikit.sdk.groupManager()?.getGroup(this.groupId);
    try { // 如果本地没有群信息，需要从服务器拉取群详情
      if (!group || !group.owner()) {
        group = await uikit.sdk.groupManager()?.fetchGroupFromServer(this.groupId);
      }
      if (group && group.owner()) {
        if (isCurrentUser(group.owner())) {
          contactList.push(getGroupAllLabel());
        }
        if (!isCurrentUser(group.owner())) {
          contactList.push(new ContactModel(group.owner()));
        }
        group.adminList().forEach(item => {
          if (!isCurrentUser(item)) {
            contactList.push(new ContactModel(item));
          }
        })
      }
      const result = await uikit.sdk.groupManager()?.fetchGroupMembers(this.groupId, this.pageSize, this.cursor);
      if (result) {
        this.cursor = result.getNextCursor();
        this.hasMore = this.cursor !== '';

        result.getResult().forEach(item => {
          if (!isCurrentUser(item)) {
            let contact = new ContactModel(item);
            contactList.push(contact);
          }
        })
        this.contacts.push(...contactList);
      }
    } catch (e) {
      return Promise.reject(ChatTransfer.transferError(e as CommonError, 'fetchGroupMembers'));
    }
    return;
  }

  fetchMoreGroupMembers(pageSize?: number | undefined, cursor?: string | undefined): void {
    if (pageSize) {
      this.pageSize = pageSize;
    }
    if (cursor) {
      this.cursor = cursor;
    }
    if (!this.hasMore) {
      this.isLoading = false;
      return;
    }
    uikit.sdk.groupManager()?.fetchGroupMembers(this.groupId, this.pageSize, this.cursor).then((result)=> {
      this.isLoading = false;
      this.cursor = result.getNextCursor();
      this.hasMore = this.cursor !== '';
      let contactList: ContactModel[] = [];
      result.getResult().forEach(item => {
        let contact = new ContactModel(item);
        contactList.push(contact);
      })
      if (this.contacts.length > 0) {
        this.contacts.push(...contactList);
      }
    }).catch((e: ChatError) => {
      this.isLoading = false;
    })
  }

}