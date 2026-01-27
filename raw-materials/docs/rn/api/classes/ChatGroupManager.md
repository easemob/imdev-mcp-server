[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupManager

# Class: ChatGroupManager

Defined in: ChatGroupManager.ts:75

The group manager class, which defines how to manage groups, like group creation and destruction and member management.

## Extends

- `BaseManager`

## Constructors

### Constructor

> **new ChatGroupManager**(): `ChatGroupManager`

Defined in: ChatGroupManager.ts:81

#### Returns

`ChatGroupManager`

#### Overrides

`BaseManager.constructor`

## Properties

### \_eventEmitter?

> `protected` `optional` **\_eventEmitter**: `NativeEventEmitter`

Defined in: \_\_internal\_\_/Base.ts:19

#### Inherited from

`BaseManager._eventEmitter`

***

### TAG

> `protected` `static` **TAG**: `string` = `'ChatGroupManager'`

Defined in: ChatGroupManager.ts:76

#### Overrides

`BaseManager.TAG`

## Methods

### acceptInvitation()

> **acceptInvitation**(`groupId`, `inviter`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1644

Accepts a group invitation.

#### Parameters

##### groupId

`string`

The group ID.

##### inviter

`string`

The user ID of the inviter.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### acceptJoinApplication()

> **acceptJoinApplication**(`groupId`, `userId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1586

Accepts a join request.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### userId

`string`

The ID of the user who sends a request to join the group.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addAdmin()

> **addAdmin**(`groupId`, `admin`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1169

Adds a group admin.

Only the group owner can call this method and group admins cannot.

#### Parameters

##### groupId

`string`

The group ID.

##### admin

`string`

The user ID of the admin to add.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addAllowList()

> **addAllowList**(`groupId`, `members`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1305

Adds members to the allow list of the group.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The user IDs of members to be added to the allow list of the group.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addGroupListener()

> **addGroupListener**(`listener`): `void`

Defined in: ChatGroupManager.ts:1809

Adds a group listener.

#### Parameters

##### listener

[`ChatGroupEventListener`](../interfaces/ChatGroupEventListener.md)

The group listener to add.

#### Returns

`void`

***

### addMembers()

> **addMembers**(`groupId`, `members`, `welcome?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:880

Adds users to the group.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The array of new members to add.

##### welcome?

`string`

(optional) The welcome message.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### blockGroup()

> **blockGroup**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1111

Blocks group messages.

The user that blocks group messages is still a group member, but cannot receive group messages.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### blockMembers()

> **blockMembers**(`groupId`, `members`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:972

Adds the user to the block list of the group.

Users will be first removed from the group they have joined before being added to the block list of the group. The users on the group block list cannot join the group again.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The array of user IDs of members to be added to the block list.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeGroupDescription()

> **changeGroupDescription**(`groupId`, `description`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1048

Modifies the group description.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### description

`string`

The new group description.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeGroupName()

> **changeGroupName**(`groupId`, `groupName`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1020

Changes the group name.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### groupName

`string`

The new group name.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeOwner()

> **changeOwner**(`groupId`, `newOwner`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1148

Transfers the group ownership.

Only the group owner can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### newOwner

`string`

The user ID of the new group owner.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~createGroup()~~

> **createGroup**(`options`, `groupName`, `desc?`, `inviteMembers?`, `inviteReason?`): `Promise`\<[`ChatGroup`](ChatGroup.md)\>

Defined in: ChatGroupManager.ts:463

Creates a group instance.

After the group is created, the data in the memory and database will be updated and multiple devices will receive the notification event and update the group to the memory and database.

You can set [ChatGroupEventListener](../interfaces/ChatGroupEventListener.md) to listen for the event.

#### Parameters

##### options

[`ChatGroupOptions`](ChatGroupOptions.md)

The options for creating a group. See [ChatGroupOptions](ChatGroupOptions.md).
The options are as follows:
- The maximum number of members allowed in the group. The default value is 200.
- The group style. See [ChatGroupStyle](../enumerations/ChatGroupStyle.md). The default value is [ChatGroupStyle.PrivateOnlyOwnerInvite](../enumerations/ChatGroupStyle.md#privateonlyownerinvite).
- Whether to ask for permission when inviting a user to join the group. The default value is `false`, indicating that invitees are automatically added to the group without their permission.
- The extension of group details.

##### groupName

`string`

The group name.

##### desc?

`string`

The group description.

##### inviteMembers?

`string`[]

The group member array.

##### inviteReason?

`string`

The group joining invitation.

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md)\>

The created group instance.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2025-07-23 Use [createGroupEx](#creategroupex) instead.

***

### createGroupEx()

> **createGroupEx**(`params`): `Promise`\<[`ChatGroup`](ChatGroup.md)\>

Defined in: ChatGroupManager.ts:501

Creates a group instance.

After the group is created, the data in the memory and database will be updated and multiple devices will receive the notification event and update the group to the memory and database.

You can set [ChatGroupEventListener](../interfaces/ChatGroupEventListener.md) to listen for the event.

#### Parameters

##### params

###### desc?

`string`

###### groupAvatar?

`string`

###### groupName

`string`

###### inviteMembers?

`string`[]

###### inviteReason?

`string`

###### options

[`ChatGroupOptions`](ChatGroupOptions.md)

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md)\>

The created group instance.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### declineInvitation()

> **declineInvitation**(`groupId`, `inviter`, `reason?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1671

Declines a group invitation.

#### Parameters

##### groupId

`string`

The group ID.

##### inviter

`string`

The user ID of the inviter.

##### reason?

`string`

The reason for declining the invitation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### declineJoinApplication()

> **declineJoinApplication**(`groupId`, `username`, `reason?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1615

Declines a join request.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### username

`string`

The ID of the user who sends a request to join the group.

##### reason?

`string`

The reason of declining the join request.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### destroyGroup()

> **destroyGroup**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1092

Destroys the group instance.

Only the group owner can call this method.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### downloadGroupSharedFile()

> **downloadGroupSharedFile**(`groupId`, `fileId`, `savePath`, `callback?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1389

Downloads the shared file of the group.

#### Parameters

##### groupId

`string`

The group ID.

##### fileId

`string`

The ID of the shared file.

##### savePath

`string`

The local path of the shared file.

##### callback?

[`ChatGroupFileStatusCallback`](../interfaces/ChatGroupFileStatusCallback.md)

(Optional) The file upload result callback.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchAllowListFromServer()

> **fetchAllowListFromServer**(`groupId`): `Promise`\<`string`[]\>

Defined in: ChatGroupManager.ts:765

Uses the pagination to get the allow list of the group from the server.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`string`[]\>

The allow list of the group.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchAnnouncementFromServer()

> **fetchAnnouncementFromServer**(`groupId`): `Promise`\<`string`\>

Defined in: ChatGroupManager.ts:854

Gets the group announcement from the server.

All group members can call this method.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`string`\>

The group announcement.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchBlockListFromServer()

> **fetchBlockListFromServer**(`groupId`, `pageSize`, `pageNum`): `Promise`\<`string`[]\>

Defined in: ChatGroupManager.ts:697

Uses the pagination to get the group block list from the server.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### pageSize

`number` = `200`

The number of group members on the block list that you expect to get on each page.

##### pageNum

`number` = `1`

The page number, starting from 1.

#### Returns

`Promise`\<`string`[]\>

The group block list.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchGroupFileListFromServer()

> **fetchGroupFileListFromServer**(`groupId`, `pageSize`, `pageNum`): `Promise`\<[`ChatGroupSharedFile`](ChatGroupSharedFile.md)[]\>

Defined in: ChatGroupManager.ts:816

Uses the pagination to get the shared files of the group from the server.

#### Parameters

##### groupId

`string`

The group ID.

##### pageSize

`number` = `200`

The number of shared files that you get on each page.

##### pageNum

`number` = `1`

The page number, starting from 1.

#### Returns

`Promise`\<[`ChatGroupSharedFile`](ChatGroupSharedFile.md)[]\>

The shared file list.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~fetchGroupInfoFromServer()~~

> **fetchGroupInfoFromServer**(`groupId`, `isFetchMembers`): `Promise`\<[`ChatGroup`](ChatGroup.md) \| `undefined`\>

Defined in: ChatGroupManager.ts:553

Gets the group information from the server.

#### Parameters

##### groupId

`string`

The group ID.

##### isFetchMembers

`boolean` = `false`

Whether to get group member information:
                      - `true`: Yes. This method can return information of at most 200 group members. To get information of all group members, you can call [fetchMemberListFromServer](#fetchmemberlistfromserver).
                      - `false`: No.

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md) \| `undefined`\>

The group instance. The SDK returns `undefined` if the group does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

Use [fetchGroupInfoWithoutMembersFromServer](#fetchgroupinfowithoutmembersfromserver) instead.

***

### fetchGroupInfoWithoutMembersFromServer()

> **fetchGroupInfoWithoutMembersFromServer**(`groupId`): `Promise`\<[`ChatGroup`](ChatGroup.md) \| `undefined`\>

Defined in: ChatGroupManager.ts:584

Gets the group information from the server.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md) \| `undefined`\>

The group instance. The SDK returns `undefined` if the group does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchJoinedGroupCount()

> **fetchJoinedGroupCount**(): `Promise`\<`number`\>

Defined in: ChatGroupManager.ts:1797

Gets the number of groups joined by the current user.

#### Returns

`Promise`\<`number`\>

The list of joined groups of the current user.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchJoinedGroupsFromServer()

> **fetchJoinedGroupsFromServer**(`pageSize`, `pageNum`): `Promise`\<[`ChatGroup`](ChatGroup.md)[]\>

Defined in: ChatGroupManager.ts:375

Gets the list of groups that the current user has joined.

This method gets data from the server.

This method returns a group list which does not contain member information. If you want to update information of a group to include its member information, call [fetchMemberListFromServer](#fetchmemberlistfromserver).

#### Parameters

##### pageSize

`number`

The number of groups that you expect to return on each page [1, 20].

##### pageNum

`number`

The page number, starting from 0.

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md)[]\>

The list of groups that the current user joins.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchMemberAttributes()

> **fetchMemberAttributes**(`groupId`, `member`): `Promise`\<`Record`\<`string`, `string`\> \| `undefined`\>

Defined in: ChatGroupManager.ts:1732

Gets all custom attributes of a group member.

#### Parameters

##### groupId

`string`

The group ID.

##### member

`string`

The user ID of the group member whose all custom attributes are retrieved.

#### Returns

`Promise`\<`Record`\<`string`, `string`\> \| `undefined`\>

The user attributes.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchMemberInfoListFromServer()

> **fetchMemberInfoListFromServer**(`groupId`, `cursor`, `limit?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatGroupMember`](ChatGroupMember.md)\>\>

Defined in: ChatGroupManager.ts:655

Uses the pagination to get the member information list of the group from the server.

#### Parameters

##### groupId

`string`

The group ID.

##### cursor

`string`

The cursor position from which to start to get data. At the first method call, if you set `cursor` as `null`, the SDK gets the data in the reverse chronological order of when users join the group.

##### limit?

`number`

The number of group members that you expect to get on each page. The default value is 200.

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatGroupMember`](ChatGroupMember.md)\>\>

The group member information list and the cursor for the next query. See [ChatCursorResult](ChatCursorResult.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchMemberListFromServer()

> **fetchMemberListFromServer**(`groupId`, `pageSize`, `cursor?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<`string`\>\>

Defined in: ChatGroupManager.ts:614

Uses the pagination to get the member list of the group from the server.

#### Parameters

##### groupId

`string`

The group ID.

##### pageSize

`number` = `200`

The number of group members that you expect to get on each page.

##### cursor?

`string`

The cursor position from which to start to get data. At the first method call, if you set `cursor` as `null`, the SDK gets the data in the reverse chronological order of when users join the group.

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<`string`\>\>

The group member list and the cursor for the next query. See [ChatCursorResult](ChatCursorResult.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchMembersAttributes()

> **fetchMembersAttributes**(`groupId`, `members`, `attributeKeys?`): `Promise`\<`Map`\<`string`, `Record`\<`string`, `string`\>\>\>

Defined in: ChatGroupManager.ts:1762

Gets custom attributes of multiple group members by attribute key.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The array of user IDs of group members whose custom attributes are retrieved.(limitation is ten. More than callback error. )

##### attributeKeys?

`string`[]

The array of keys of custom attributes to be retrieved.

#### Returns

`Promise`\<`Map`\<`string`, `Record`\<`string`, `string`\>\>\>

The users attributes.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchMuteListFromServer()

> **fetchMuteListFromServer**(`groupId`, `pageSize`, `pageNum`): `Promise`\<`string`[]\>

Defined in: ChatGroupManager.ts:732

Uses the pagination to get the mute list of the group from the server.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### pageSize

`number` = `200`

The number of muted members that you expect to get on each page.

##### pageNum

`number` = `1`

The page number, starting from 1.

#### Returns

`Promise`\<`string`[]\>

The group mute list.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchPublicGroupsFromServer()

> **fetchPublicGroupsFromServer**(`pageSize`, `cursor?`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatGroupInfo`](ChatGroupInfo.md)\>\>

Defined in: ChatGroupManager.ts:411

Gets public groups from the server with pagination.

#### Parameters

##### pageSize

`number`

The number of public groups that you expect on each page.

##### cursor?

`string`

The cursor position from which to start to get data. At the first method call, if you set `cursor` as `null`, the SDK gets the data in the reverse chronological order of when groups are created.

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatGroupInfo`](ChatGroupInfo.md)\>\>

The group list and the cursor for the next query. See [ChatCursorResult](ChatCursorResult.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getGroupWithId()

> **getGroupWithId**(`groupId`): `Promise`\<[`ChatGroup`](ChatGroup.md) \| `undefined`\>

Defined in: ChatGroupManager.ts:327

Gets the group instance from the memory by group ID.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md) \| `undefined`\>

The group instance. The SDK returns `undefined` if the group does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getJoinedGroups()

> **getJoinedGroups**(): `Promise`\<[`ChatGroup`](ChatGroup.md)[]\>

Defined in: ChatGroupManager.ts:351

Gets the list of groups that the current user has joined.

This method gets data from the local database.

#### Returns

`Promise`\<[`ChatGroup`](ChatGroup.md)[]\>

The group list.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### inviteUser()

> **inviteUser**(`groupId`, `members`, `reason?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:915

Invites users to join the group.

This method works only for groups with the following styles:
- `PrivateOnlyOwnerInvite` style: Only the group owner can invite users to join the group.
- `PrivateMemberCanInvite` style: Each group member can invite users to join the group.
- `PublicJoinNeedApproval` style: Each group member can invite users to join the group and users can join a group only after getting approval from the group owner or admins.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The array of user IDs of new members to invite.

##### reason?

`string`

The invitation reason.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### isMemberInAllowListFromServer()

> **isMemberInAllowListFromServer**(`groupId`): `Promise`\<`boolean`\>

Defined in: ChatGroupManager.ts:789

Gets whether the member is on the allow list of the group.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`boolean`\>

Whether the current user is on the allow list of the group.
- `true`: Yes.
- `false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### joinPublicGroup()

> **joinPublicGroup**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1538

Joins a public group.

For a group that requires no authentication，users can join it freely without obtaining permissions from the group owner or admin.

For a group that requires authentication, users need to wait for the group owner or admin to agree before joining the group. For details, see [ChatGroupStyle](../enumerations/ChatGroupStyle.md).

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### leaveGroup()

> **leaveGroup**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1073

Leaves a group.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### muteAllMembers()

> **muteAllMembers**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1266

Mutes all members.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### muteMembers()

> **muteMembers**(`groupId`, `members`, `duration`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1212

Mutes group members.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The list of user IDs of members to mute.

##### duration

`number` = `-1`

The mute duration in milliseconds. It is a reserved parameter.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAdmin()

> **removeAdmin**(`groupId`, `admin`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1190

Removes a group admin.

Only the group owner can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### admin

`string`

The user ID of the group admin to remove.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAllGroupListener()

> **removeAllGroupListener**(): `void`

Defined in: ChatGroupManager.ts:1827

Clears all group listeners.

#### Returns

`void`

***

### removeAllowList()

> **removeAllowList**(`groupId`, `members`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1329

Removes members from the allow list of the group.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The user IDs of members to be removed from the allow list of the group.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeGroupListener()

> **removeGroupListener**(`listener`): `void`

Defined in: ChatGroupManager.ts:1819

Removes the group listener.

#### Parameters

##### listener

[`ChatGroupEventListener`](../interfaces/ChatGroupEventListener.md)

The group listener to remove.

#### Returns

`void`

***

### removeGroupSharedFile()

> **removeGroupSharedFile**(`groupId`, `fileId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1427

Removes a shared file of the group.

Group members can delete their own uploaded files. The group owner or admin can delete all shared files.

#### Parameters

##### groupId

`string`

The group ID.

##### fileId

`string`

The ID of the shared file.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMembers()

> **removeMembers**(`groupId`, `members`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:946

Removes a member from the group.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The user ID of the member to be removed.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### requestToJoinPublicGroup()

> **requestToJoinPublicGroup**(`groupId`, `reason?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1558

Requests to join a group.

You can call this method to only join public groups requiring authentication, i.e., groups with the style of [ChatGroupStyle.PublicJoinNeedApproval](../enumerations/ChatGroupStyle.md#publicjoinneedapproval).

#### Parameters

##### groupId

`string`

The group ID.

##### reason?

`string`

The reason for requesting to join the group.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setMemberAttribute()

> **setMemberAttribute**(`groupId`, `member`, `attributes`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1701

Sets custom attributes of a group member.

#### Parameters

##### groupId

`string`

The group ID.

##### member

`string`

The array of user IDs of group members whose custom attributes are retrieved.(limitation is ten. More than callback error. )

##### attributes

`Record`\<`string`, `string`\>

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setNativeListener()

> **setNativeListener**(`event`): `void`

Defined in: ChatGroupManager.ts:87

#### Parameters

##### event

`NativeEventEmitter`

#### Returns

`void`

#### Overrides

`BaseManager.setNativeListener`

***

### unblockGroup()

> **unblockGroup**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1128

Unblocks group messages.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unblockMembers()

> **unblockMembers**(`groupId`, `members`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:996

Removes users from the group block list.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The user IDs of members to be removed from the group block list.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unMuteAllMembers()

> **unMuteAllMembers**(`groupId`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1285

Unmutes all group members.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unMuteMembers()

> **unMuteMembers**(`groupId`, `members`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1243

Unmutes group members.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### members

`string`[]

The array of user IDs of members to be unmuted.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateGroupAnnouncement()

> **updateGroupAnnouncement**(`groupId`, `announcement`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1455

Updates the group announcement.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### announcement

`string`

The group announcement.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateGroupAvatar()

> **updateGroupAvatar**(`groupId`, `avatar`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1481

Updates the group avatar.

#### Parameters

##### groupId

`string`

The group ID.

##### avatar

`string`

The new group avatar.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateGroupExtension()

> **updateGroupExtension**(`groupId`, `extension`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1509

Updates the group extension field.

Only the group owner or admin can call this method.

#### Parameters

##### groupId

`string`

The group ID.

##### extension

`string`

The updated group extension field.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### uploadGroupSharedFile()

> **uploadGroupSharedFile**(`groupId`, `filePath`, `callback?`): `Promise`\<`void`\>

Defined in: ChatGroupManager.ts:1354

Uploads the shared file to the group.

When a shared file is uploaded, the upload progress callback will be triggered.

#### Parameters

##### groupId

`string`

The group ID.

##### filePath

`string`

The local path of the shared file.

##### callback?

[`ChatGroupFileStatusCallback`](../interfaces/ChatGroupFileStatusCallback.md)

(Optional) The file upload result callback.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### \_callMethod()

> `protected` `static` **\_callMethod**\<`T`\>(`method`, `args?`): `Promise`\<`T`\>

Defined in: \_\_internal\_\_/Native.ts:14

#### Type Parameters

##### T

`T`

#### Parameters

##### method

`string`

##### args?

`Object`

#### Returns

`Promise`\<`T`\>

#### Inherited from

`BaseManager._callMethod`

***

### checkErrorFromResult()

> `protected` `static` **checkErrorFromResult**(`result`): `void`

Defined in: \_\_internal\_\_/Native.ts:9

#### Parameters

##### result

`any`

#### Returns

`void`

#### Inherited from

`BaseManager.checkErrorFromResult`

***

### handleGroupFileCallback()

> `protected` `static` **handleGroupFileCallback**(`methodName`, `self`, `groupId`, `filePath`, `callback?`): `void`

Defined in: \_\_internal\_\_/Base.ts:63

#### Parameters

##### methodName

`string`

##### self

`BaseManager`

##### groupId

`string`

##### filePath

`string`

##### callback?

[`ChatGroupFileStatusCallback`](../interfaces/ChatGroupFileStatusCallback.md)

#### Returns

`void`

#### Inherited from

`BaseManager.handleGroupFileCallback`

***

### handleMessageCallback()

> `protected` `static` **handleMessageCallback**(`methodName`, `self`, `message`, `callback?`): `void`

Defined in: \_\_internal\_\_/Base.ts:29

#### Parameters

##### methodName

`string`

##### self

`BaseManager`

##### message

[`ChatMessage`](ChatMessage.md)

##### callback?

[`ChatMessageStatusCallback`](../interfaces/ChatMessageStatusCallback.md)

#### Returns

`void`

#### Inherited from

`BaseManager.handleMessageCallback`
