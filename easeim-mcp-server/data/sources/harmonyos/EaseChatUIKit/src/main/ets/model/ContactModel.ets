import { ChatUserProfile } from './ChatUserProfile';

export class ContactModel extends ChatUserProfile{
  nickname?: string

  constructor(id: string) {
    super()
    this.id = id;
  }
}