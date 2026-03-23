import { CursorResult } from '@easemob/chatsdk';
import uikit from '../internal/ChatUIKit';
import { ChatKitContact } from '../model/ChatKitContact';

export class ContactRepo {

  static async getContactsFromLocal() {
   let contacts = await uikit.sdk.contactManager()?.getContactsFromLocal();
   const arr: ChatKitContact[] = [];
    if (contacts) {
      contacts.forEach(item => {
        arr.push(new ChatKitContact(item));
      })
    }
    return arr;
  }

  static async fetchContactsFromServer(pageSize: number, cursor?: string) {
    let result = await uikit.sdk.contactManager()?.fetchAllContactsFromServerByPage(pageSize, cursor ?? '');
    let returnCursor = new CursorResult<ChatKitContact>();
    if (result) {
      returnCursor.setNextCursor(result.getNextCursor());
      let arr: ChatKitContact[] = [];
      result.getResult().forEach(item => {
        arr.push(new ChatKitContact(item));
      })
      returnCursor.setResult(arr);
    }
    return returnCursor;
  }

  static async addContact(userId: string) {
    await uikit.sdk.contactManager()?.addContact(userId)
  }
}