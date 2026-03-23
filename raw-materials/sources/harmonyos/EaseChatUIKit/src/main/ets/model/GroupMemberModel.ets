import { ContactModel } from './ContactModel';

export class GroupMemberModel extends ContactModel {
  role?: GroupMemberRole
}

export enum GroupMemberRole {
  OWNER,
  ADMIN,
  MEMBER
}