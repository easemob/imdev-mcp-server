import { ChatUserProfile } from '../../model/ChatUserProfile';

export class ChatUser {
  userId: string = "";
  nickname?: string;
  avatar?: ResourceStr;
  contact?: CONTACT;
  email?: string;
  phone?: string;
  gender?: GENDER;
  sign?: string;
  birth?: string;
  ext?: string;
  remark?: string;

  constructor(userId: string) {
    this.userId = userId;
  }

  getNickname(): string {
    if (!this.nickname) {
      return this.userId;
    }
    return this.nickname;
  }

  getUserProfile(): ChatUserProfile {
    let profile = new ChatUserProfile();
    profile.id = this.userId;
    profile.name = this.getNickname();
    profile.avatar = this.avatar;
    profile.remark = this.remark;
    return profile;
  }
}

export class MessageUserInfo {
  nickname?: string;
  avatarURL?: string;
  remark?: string;

  constructor(nickname?: string, avatarURL?: string, remark?: string) {
    this.nickname = nickname;
    this.avatarURL = avatarURL;
    this.remark = remark;
  }

  getUser(id: string): ChatUser {
    let user = new ChatUser(id);
    user.nickname = this.nickname;
    user.avatar = this.avatarURL;
    user.remark = this.remark;
    return user;
  }
}

export enum CONTACT {
  NORMAL,
  BLOCK,
  NO_CONTACT
}

export enum GENDER {
  UNKNOWN,
  MALE,
  FEMALE
}