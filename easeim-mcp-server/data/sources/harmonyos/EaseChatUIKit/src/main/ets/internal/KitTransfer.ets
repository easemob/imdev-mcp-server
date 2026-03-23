import { ChatUserProfile } from '../model/ChatUserProfile';
import { ChatUser } from './model/ChatUser';

/**
 * Transfer UserProfile to EaseUser.
 * @param { EaseProfile } profile - 参数。
 * @returns { ChatUser } - 返回 ChatUser 对象。
 */
export function transferUserProfile(profile: ChatUserProfile) {
  let user = new ChatUser(profile.id);
  user.nickname = profile.name;
  user.avatar = profile.avatar;
  user.remark = profile.remark;
  return user;
}

/**
 * Create a user by userId.
 * @param { string } userId - 用户 ID。
 * @returns { ChatUser } - 返回 ChatUser 对象。
 */
export function createProfile(userId: string) {
  return new ChatUser(userId);
}