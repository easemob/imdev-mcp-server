
/**
 * 名片消息对象。
 */
export class UserCard {
  uid: string = '';
  nickname?: string;
  avatar?: string;

  constructor(uid: string, nickname?: string, avatar?: string) {
    this.uid = uid;
    this.nickname = nickname;
    this.avatar = avatar;
  }
}