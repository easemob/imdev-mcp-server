import { ChatError, GroupOptions } from '@easemob/chatsdk';
import uikit from '../internal/ChatUIKit';
import { ChatKitGroup } from '../model/ChatKitGroup';

export class GroupRepo {

  static async fetchJoinedGroupsCount() {
    return await uikit.sdk.groupManager()?.fetchJoinedGroupsCount();
  }

  static async getAllGroups() {
    let groups = await uikit.sdk.groupManager()?.getAllGroups();
    if (groups) {
      const arr: ChatKitGroup[] = [];
      groups.forEach(group => {
        arr.push(new ChatKitGroup(group));
      })
      return arr;
    }
    return null;
  }

  static async fetchJoinedGroupsFromServer(pageNum: number, pageSize: number) {
    let groups = await uikit.sdk.groupManager()?.fetchJoinedGroupsFromServer(pageNum, pageSize);
    const arr: ChatKitGroup[] = [];
    if (groups) {
      groups.forEach(group => {
        arr.push(new ChatKitGroup(group));
      })
      return arr;
    }
    return arr;
  }

  static async createGroup(option?: GroupOptions) {
    return await uikit.sdk.groupManager()?.createGroup(option) ?? Promise.reject(ChatError.createError(ChatError.GENERAL_ERROR, "SDK is not initialized"));
  }
}