import { ChatError, Group, GroupStyle } from '@easemob/chatsdk';
import uikit from '../internal/ChatUIKit';
import { ErrorInfo } from '../model/ErrorInfo';
import { BaseListViewModel } from './ChatViewModel';
import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import { GroupRepo } from '../repositories/GroupRepo';
import { ChatKitGroup } from '../model/ChatKitGroup';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { groupInfoManager } from '../internal/manager/ChatGroupInfoManager';

@ObservedV2
export abstract class BaseGroupListViewModel extends BaseListViewModel<ChatKitGroup> {
  @Trace searchResult: ChatKitGroup[] = [];
  @Trace joinedGroupCount: number = 0;
  @Trace isLoading: boolean = false;

  /**
   * 获取群组列表。
   */
  abstract getGroups();

  /**
   * 获取更多的群组列表。
   */
  abstract fetchMoreGroups();

  abstract fetchJoinedGroupCount();

  abstract createGroup(members: string[], groupName?: string, maxUsers?: number): Promise<Group>;

  /**
   * 向用户提供一组联系人id，并要求返回一组联系人信息。
   * @param start
   * @param end
   */
  abstract fetchGroups(start: number, end: number);
}

export class GroupListViewModel extends BaseGroupListViewModel {
  protected pageNum: number = 0;
  protected pageSize: number = 20;

  aboutToAppear(): void {
    this.getGroups().catch((e: CommonError) => {
      this.errorInfo = ErrorInfo.create('getGroups', ChatTransfer.transferError(e));
    });
    this.fetchJoinedGroupCount();
  }

  aboutToDisAppear(): void {

  }

  async getGroups() {
    if (!uikit.sdk.isSdkInited()) {
      this.errorInfo = ErrorInfo.create("getGroups", ChatError.createError(ChatError.GENERAL_ERROR, "SDK is not initialized."));
      return;
    }
    let groups = await GroupRepo.getAllGroups();
    if (groups) {
      this.dataList = groups;
    }
    let allGroups: ChatKitGroup[] = [];
    groups = await GroupRepo.fetchJoinedGroupsFromServer(this.pageNum, this.pageSize);
    this.pageNum++;
    if (groups.length > 0) {
      groups.forEach(item => {
        allGroups.push(item);
      })
    }
    if (groups && groups.length < this.pageSize) {
      this.noMoreInfo = ErrorInfo.create("fetchJoinedGroupsFromServer");
    }
    this.dataList = allGroups;
  }

  fetchMoreGroups() {
    if (this.noMoreInfo) {
      this.isLoading = false;
      return;
    }
    GroupRepo.fetchJoinedGroupsFromServer(this.pageNum, this.pageSize).then((groups) => {
      this.isLoading = false;
      let allGroups: ChatKitGroup[] = [];
      this.pageNum++;
      if (groups.length > 0) {
        groups.forEach(item => {
          allGroups.push(item);
        })
      }
      if (groups && groups.length < this.pageSize) {
        this.noMoreInfo = ErrorInfo.create("fetchJoinedGroupsFromServer");
      }
      this.dataList.push(...groups);this.pageNum++;
      if (groups.length > 0) {
        groups.forEach(item => {
          allGroups.push(item);
        })
      }
      if (groups && groups.length < this.pageSize) {
        this.noMoreInfo = ErrorInfo.create("fetchJoinedGroupsFromServer");
      }
      this.dataList.push(...groups);
    }).catch((e: ChatError) => {
      this.isLoading = false;
      this.errorInfo = ErrorInfo.create("fetchMoreGroups", e);
    })

  }

  fetchJoinedGroupCount(): void {
    GroupRepo.fetchJoinedGroupsCount().then((count) => {
      this.joinedGroupCount = count ?? 0;
    }).catch((e: ChatError) => {
      this.errorInfo = ErrorInfo.create("fetchJoinedGroupsCount", ChatError.createError(e.errorCode, e.description));
    })
  }

  async createGroup(members: string[], groupName?: string, maxUsers?: number) {
    return await GroupRepo.createGroup({
      groupName: this.getGroupName(members, groupName),
      members: members,
      maxUsers: maxUsers ?? 200,
      style: GroupStyle.GroupStylePrivateMemberCanInvite
    })
  }

  private getGroupName(members: string[], groupName?: string): string {
    if (groupName) {
      return groupName;
    }
    if (members && members.length > 0) {
      return members.slice(0, 3).map(item => {
        return ChatUserInfoManager.getInstance().getUserInfo(item);
      }).map(user => {
        return user.nickname ?? user.userId
      }).join(',')
    }
    let user = ChatUserInfoManager.getInstance().getCurrentUser();
    return user.nickname ?? user.userId;
  }

  async fetchGroups(start: number, end: number): Promise<void> {
    if (end <= start) {
      return;
    }
    if (end + 5 < this.dataList.length) {
      end = end + 5;
    }
    let result: string[] = [];
    this.dataList.forEach((group, index) => {
      if (index >= start && index <= end) {
        let info = groupInfoManager.getGroupInfoFromCache(group.id);
        if (!info) {
          result.push(group.id);
        }
      }
    })
    if (result && result.length > 0) {
      for (let i = 0; i < result.length; i++) {
        await groupInfoManager.getGroupInfo(result[i]);
      }
      let subArr: ChatKitGroup[] = [];
      for (let i = start; i <= end; i++) {
        let item = this.dataList[i];
        item.update();
        subArr.push(item);
      }
      this.dataList.splice(start, subArr.length, ...subArr);
    }
  }

}