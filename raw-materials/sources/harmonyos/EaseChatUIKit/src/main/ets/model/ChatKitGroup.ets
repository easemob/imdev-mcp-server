import { Group } from '@easemob/chatsdk';
import { groupInfoManager } from '../internal/manager/ChatGroupInfoManager';
import { getGroupName } from '../utils/GroupUtil';
import { ChatKitBaseModel } from './ChatKitBaseModel';

@ObservedV2
export class ChatKitGroup extends ChatKitBaseModel<Group> {
  declare id: string;
  @Trace name?: string;
  @Trace avatar?: ResourceStr;
  @Monitor('avatar')
  onAvatar(monitor: IMonitor) {
    console.log('profile id: '+this.id + " avatar: "+this.avatar);
  }

  constructor(group: Group) {
    super();
    this.origin = group;
    this.update();
  }

  update(): void {
    if (this.origin) {
      this.id = this.origin.groupId();
      this.name = groupInfoManager.getGroupInfoFromCache(this.id)?.name ?? getGroupName(this.id);
      this.avatar = groupInfoManager.getGroupInfoFromCache(this.id)?.avatar ?? $r('app.media.avatar_group_default');
    }
  }

}
