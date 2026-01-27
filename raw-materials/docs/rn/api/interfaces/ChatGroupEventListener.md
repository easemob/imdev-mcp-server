[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupEventListener

# Interface: ChatGroupEventListener

Defined in: ChatEvents.ts:717

The group event listener.

For descriptions of callback methods in the listener, user A acts as the current user and user B serves as the peer user.

## Methods

### onAdminAdded()?

> `optional` **onAdminAdded**(`params`): `void`

Defined in: ChatEvents.ts:879

Occurs when a member is set as an admin.

#### Parameters

##### params

###### admin

`string`

###### groupId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [admin] The user ID of the member that is set as an admin.

***

### onAdminRemoved()?

> `optional` **onAdminRemoved**(`params`): `void`

Defined in: ChatEvents.ts:887

Occurs when the administrative privileges of an admin are removed.

#### Parameters

##### params

###### admin

`string`

###### groupId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [admin] The user ID of the admin whose administrative privileges are removed.

***

### onAllGroupMemberMuteStateChanged()?

> `optional` **onAllGroupMemberMuteStateChanged**(`params`): `void`

Defined in: ChatEvents.ts:992

Occurs when all group members are muted or unmuted.

#### Parameters

##### params

###### groupId

`string`

###### isAllMuted

`boolean`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [isAllMuted] Whether all group members are muted.
  - `true`: Yes.
  - `false`: No.

***

### onAllowListAdded()?

> `optional` **onAllowListAdded**(`params`): `void`

Defined in: ChatEvents.ts:971

Occurs when one or more group members are added to the allow list.

#### Parameters

##### params

###### groupId

`string`

###### members

`string`[]

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [members] The user IDs of members that are added to the allow list of the group.

***

### onAllowListRemoved()?

> `optional` **onAllowListRemoved**(`params`): `void`

Defined in: ChatEvents.ts:979

Occurs when one or more group members are removed from the allow list.

#### Parameters

##### params

###### groupId

`string`

###### members

`string`[]

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [members] The user IDs of members that are removed from the allow list of the group.

***

### onAnnouncementChanged()?

> `optional` **onAnnouncementChanged**(`params`): `void`

Defined in: ChatEvents.ts:944

Occurs when the group announcement is updated.

#### Parameters

##### params

###### announcement

`string`

###### groupId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [announcement] The new announcement.

***

### onAutoAcceptInvitation()?

> `optional` **onAutoAcceptInvitation**(`params`): `void`

Defined in: ChatEvents.ts:844

Occurs when the group invitation is accepted automatically by the current user.

For example, after user B invites user A to join the group, as user A sets [ChatOptions.autoAcceptGroupInvitation](../classes/ChatOptions.md#autoacceptgroupinvitation) to `true`, the invitee joins the group automatically and receives this callback.

#### Parameters

##### params

###### groupId

`string`

###### inviteMessage?

`string`

###### inviter

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId]			The group ID.
- Param [inviter]			The user ID of the inviter.
- Param [inviteMessage]    The invitation message.

***

### onDestroyed()?

> `optional` **onDestroyed**(`params`): `void`

Defined in: ChatEvents.ts:833

Occurs when a group is destroyed.

#### Parameters

##### params

###### groupId

`string`

###### groupName?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.

***

### onDetailChanged()?

> `optional` **onDetailChanged**(`group`): `void`

Defined in: ChatEvents.ts:1002

Occurs when the chat group detail change. All chat group members receive this event.

#### Parameters

##### group

[`ChatGroup`](../classes/ChatGroup.md)

The chat group.

#### Returns

`void`

***

### onInvitationAccepted()?

> `optional` **onInvitationAccepted**(`params`): `void`

Defined in: ChatEvents.ts:798

Occurs when a group invitation from the current user is accepted by the peer user.

For example, after user B accepts a group invitation from user A, user A receives this callback.

#### Parameters

##### params

###### groupId

`string`

###### invitee

`string`

###### reason?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.
- Param [invitee] The user ID of the invitee.
- Param [reason] The reason for accepting the group invitation.

***

### onInvitationDeclined()?

> `optional` **onInvitationDeclined**(`params`): `void`

Defined in: ChatEvents.ts:813

Occurs when a group invitation from the current user is declined by the peer user.

For example, after user B declines a group invitation from user A, user A receives this callback.

#### Parameters

##### params

###### groupId

`string`

###### invitee

`string`

###### reason?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [invitee] The user ID of the invitee.
- Param [reason] The reason for accepting the group invitation.

***

### onInvitationReceived()?

> `optional` **onInvitationReceived**(`params`): `void`

Defined in: ChatEvents.ts:729

Occurs when the current user receives a group invitation.

For example, after user B sends user A a group invitation, user A receives this callback.

#### Parameters

##### params

###### groupId

`string`

###### groupName

`string`

###### inviter

`string`

###### reason?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.
- Param [inviter] The user ID of the inviter.
- Param [reason] The reason for invitation.

***

### onMemberAttributesChanged()?

> `optional` **onMemberAttributesChanged**(`params`): `void`

Defined in: ChatEvents.ts:1020

Occurs when a custom attribute(s) of a group member is/are changed.

#### Parameters

##### params

###### attributes

`any`

###### groupId

`string`

###### member

`string`

###### operator

`string`

#### Returns

`void`

#### Params

params
- groupId: The group ID.
- member: The group member.
- attributes: The modified custom attributes, in key-value format.
- operator: The user ID of the operator.

***

### ~~onMemberExited()?~~

> `optional` **onMemberExited**(`params`): `void`

Defined in: ChatEvents.ts:928

Occurs when a member voluntarily leaves the group.

#### Parameters

##### params

###### groupId

`string`

###### member

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [member] The user ID of the member leaving the group.

#### Deprecated

Use [onMembersExited](#onmembersexited) instead.

***

### ~~onMemberJoined()?~~

> `optional` **onMemberJoined**(`params`): `void`

Defined in: ChatEvents.ts:910

Occurs when a user joins a group.

#### Parameters

##### params

###### groupId

`string`

###### member

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [member] The user ID of the new member.

#### Deprecated

Use [onMembersJoined](#onmembersjoined) instead.

***

### onMemberRemoved()?

> `optional` **onMemberRemoved**(`params`): `void`

Defined in: ChatEvents.ts:825

Occurs when the current user is removed from the group.

#### Parameters

##### params

###### groupId

`string`

###### groupName?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.

***

### onMembersExited()?

> `optional` **onMembersExited**(`params`): `void`

Defined in: ChatEvents.ts:936

Occurs when multiple users leave a group.

#### Parameters

##### params

###### groupId

`string`

###### members

`string`[]

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [members] The user IDs of the members leaving the group.

***

### onMembersJoined()?

> `optional` **onMembersJoined**(`params`): `void`

Defined in: ChatEvents.ts:918

Occurs when multiple users join a group.

#### Parameters

##### params

###### groupId

`string`

###### members

`string`[]

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [members] The user IDs of the new members.

***

### onMuteListAdded()?

> `optional` **onMuteListAdded**(`params`): `void`

Defined in: ChatEvents.ts:859

Occurs when one or more members are added to the mute list of the group.

A user, when muted, can still see group messages, but cannot send messages in the group. However, a user on the block list can neither see nor send group messages.

#### Parameters

##### params

###### groupId

`string`

###### muteExpire?

`number`

###### mutes

`string`[]

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [mutes] The user ID(s) of member(s) that are muted.
- Param [muteExpire] Reserved parameter. The Unix timestamp when the mute expires. The unit is millisecond.

***

### onMuteListRemoved()?

> `optional` **onMuteListRemoved**(`params`): `void`

Defined in: ChatEvents.ts:871

Occurs when one or more members are removed from the mute list of the group.

#### Parameters

##### params

###### groupId

`string`

###### mutes

`string`[]

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [mutes] The user ID(s) of member(s) that is removed from the mute list.

***

### onOwnerChanged()?

> `optional` **onOwnerChanged**(`params`): `void`

Defined in: ChatEvents.ts:896

Occurs when the group ownership is transferred.

#### Parameters

##### params

###### groupId

`string`

###### newOwner

`string`

###### oldOwner

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [newOwner] The user ID of the new group owner.
- Param [oldOwner] The user ID of the previous group owner.

***

### onRequestToJoinAccepted()?

> `optional` **onRequestToJoinAccepted**(`params`): `void`

Defined in: ChatEvents.ts:763

Occurs when a join request from the current user is accepted by the peer user.

For a group of the `PublicJoinNeedApproval` style, after user B accepts a join request from user A, user A receives this callback.

#### Parameters

##### params

###### accepter

`string`

###### groupId

`string`

###### groupName?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.
- Param [accepter] The ID of the user that accepts the join request.

***

### onRequestToJoinDeclined()?

> `optional` **onRequestToJoinDeclined**(`params`): `void`

Defined in: ChatEvents.ts:780

Occurs when a join request from the current user is declined by the peer user.

For example, for a group of the `PublicJoinNeedApproval` style, after user B declines a join request from user A, user A receives this callback.

#### Parameters

##### params

###### applicant?

`string`

###### decliner

`string`

###### groupId

`string`

###### groupName?

`string`

###### reason?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.
- Param [decliner] The ID of the user that declines the join request.
- Param [applicant] The user ID of the applicant.
- Param [reason] The reason for declining the join request.

***

### onRequestToJoinReceived()?

> `optional` **onRequestToJoinReceived**(`params`): `void`

Defined in: ChatEvents.ts:747

Occurs when a join request from the current user is received by the peer user.

For example, after user A sends a join request to user B, user B receives this callback.

#### Parameters

##### params

###### applicant

`string`

###### groupId

`string`

###### groupName?

`string`

###### reason?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [groupName] The group name.
- Param [applicant] The user ID of the applicant.
- Param [reason] The reason for requesting to join the group.

***

### onSharedFileAdded()?

> `optional` **onSharedFileAdded**(`params`): `void`

Defined in: ChatEvents.ts:955

Occurs when a shared file is added to the group.

#### Parameters

##### params

###### groupId

`string`

###### sharedFile

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [sharedFile] The ID of the new shared file.

***

### onSharedFileDeleted()?

> `optional` **onSharedFileDeleted**(`params`): `void`

Defined in: ChatEvents.ts:963

Occurs when a shared file is removed from a group.

#### Parameters

##### params

###### fileId

`string`

###### groupId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [groupId] The group ID.
- Param [fileId] The ID of the shared file that is deleted.

***

### onStateChanged()?

> `optional` **onStateChanged**(`group`): `void`

Defined in: ChatEvents.ts:1009

Occurs when the disabled state of group changes.

#### Parameters

##### group

[`ChatGroup`](../classes/ChatGroup.md)

The chat group.

#### Returns

`void`
