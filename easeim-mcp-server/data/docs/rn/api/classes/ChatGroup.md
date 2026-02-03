[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroup

# Class: ChatGroup

Defined in: common/ChatGroup.ts:165

The group information class, which contains the information of the chat group.

You can call the [ChatGroupManager.fetchGroupInfoWithoutMembersFromServer](ChatGroupManager.md#fetchgroupinfowithoutmembersfromserver) method to obtain group information.

## Constructors

### Constructor

> **new ChatGroup**(`params`): `ChatGroup`

Defined in: common/ChatGroup.ts:237

#### Parameters

##### params

###### adminList?

`string`[]

###### announcement?

`string`

###### blockList?

`string`[]

###### description?

`string`

###### groupAvatar?

`string`

###### groupId

`string`

###### groupName?

`string`

###### isAllMemberMuted?

`boolean`

###### memberCount?

`number`

###### memberList?

`string`[]

###### messageBlocked?

`boolean`

###### muteList?

`string`[]

###### options?

`any`

###### owner

`string`

###### permissionType

`number`

#### Returns

`ChatGroup`

## Properties

### adminList

> **adminList**: `string`[]

Defined in: common/ChatGroup.ts:201

The admin list of the group.

***

### announcement

> **announcement**: `string`

Defined in: common/ChatGroup.ts:189

The content of the group announcement.

***

### blockList

> **blockList**: `string`[]

Defined in: common/ChatGroup.ts:205

The block list of the group.

***

### description

> **description**: `string`

Defined in: common/ChatGroup.ts:181

The group description.

***

### groupAvatar

> **groupAvatar**: `string`

Defined in: common/ChatGroup.ts:177

The group avatar.

***

### groupId

> **groupId**: `string`

Defined in: common/ChatGroup.ts:169

The group ID.

***

### groupName

> **groupName**: `string`

Defined in: common/ChatGroup.ts:173

The group name.

***

### isAllMemberMuted

> **isAllMemberMuted**: `boolean`

Defined in: common/ChatGroup.ts:221

Whether all group members are muted.
- `true`: Yes.
- `false`: No.

***

### memberCount

> **memberCount**: `number`

Defined in: common/ChatGroup.ts:193

The member count of the group.

***

### memberList

> **memberList**: `string`[]

Defined in: common/ChatGroup.ts:197

The member list of the group.

***

### messageBlocked

> **messageBlocked**: `boolean`

Defined in: common/ChatGroup.ts:215

Whether group messages are blocked.
- `true`: Yes.
- `false`: No.

***

### muteList

> **muteList**: `string`[]

Defined in: common/ChatGroup.ts:209

The mute list of the group.

***

### options?

> `optional` **options**: [`ChatGroupOptions`](ChatGroupOptions.md)

Defined in: common/ChatGroup.ts:229

The group options.

***

### owner

> **owner**: `string`

Defined in: common/ChatGroup.ts:185

The user ID of the group owner.

***

### permissionType

> **permissionType**: [`ChatGroupPermissionType`](../enumerations/ChatGroupPermissionType.md)

Defined in: common/ChatGroup.ts:225

The role of the current user in the group.

## Accessors

### maxCount

#### Get Signature

> **get** **maxCount**(): `number`

Defined in: common/ChatGroup.ts:233

Gets the maximum number of members allowed in a group. The parameter is set when the group is created.

##### Returns

`number`
