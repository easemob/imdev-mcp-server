import { Contact } from '@easemob/chatsdk';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { StringUtil } from '../utils/StringUtil';
import { ChatKitBaseModel } from './ChatKitBaseModel';

@ObservedV2
export class ChatKitContact extends ChatKitBaseModel<Contact> {
  declare id: string;
  @Trace remark?: string;
  @Trace avatar?: ResourceStr;
  @Trace nickname?: string;
  @Trace isChecked?: boolean;
  firstLetter: string = '';
  en_name: string = '';

  constructor(contact: Contact) {
    super();
    this.origin = contact;
    this.update();
  }

  update(): void {
    if (this.origin) {
      this.id = this.origin.userId();
      this.remark = this.origin.remark();
      this.avatar = ChatUserInfoManager.getInstance().getAvatar(this.id);
      this.nickname = ChatUserInfoManager.getInstance().getNickname(this.id);
      this.en_name = StringUtil.getPinyin(this.nickname);
      this.firstLetter = StringUtil.getFirstLetter(this.en_name);
    }
  }

}

@ObservedV2
export class ContactsGroup {
  @Trace key: string = '';
  @Trace contacts?: ChatKitContact[];
}