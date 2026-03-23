import { KitConstants } from '../../../../Index';
import uikit from '../internal/ChatUIKit';
import { ContactModel } from '../model/ContactModel';

/**
 * 判断目标用户是否是当前用户。
 * @param userId
 * @returns
 */
export function isCurrentUser(userId?: string): boolean {
  return uikit.sdk.getCurrentUser() === userId;
}

/**
 * 获取发送@消息中全部选项的对象。
 * @returns
 */
export function getGroupAllLabel(): ContactModel {
  let contact = new ContactModel(KitConstants.AT_ALL_LABEL);
  contact.nickname = getContext().resourceManager.getStringSync($r('app.string.chat_group_mention_all'));
  contact.avatar = $r('app.media.chat_icon_group_all');
  return contact;
}

/**
 * 获取群组名称。
 * @param groupId
 * @returns
 */
export function getGroupName(groupId: string): string {
  let group = uikit.sdk.groupManager()?.getGroup(groupId);
  let groupName = group?.groupName();
  if (groupName) {
    return groupName;
  }
  return groupId;
}