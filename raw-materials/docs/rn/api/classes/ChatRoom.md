[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatRoom

# Class: ChatRoom

Defined in: common/ChatRoom.ts:63

The chat room instance class.

To get the correct value, ensure that you call [ChatRoomManager.fetchChatRoomInfoFromServer](ChatRoomManager.md#fetchchatroominfofromserver) to get chat room details before calling this method.

## Constructors

### Constructor

> **new ChatRoom**(`params`): `ChatRoom`

Defined in: common/ChatRoom.ts:154

#### Parameters

##### params

###### adminList?

`string`[]

###### announcement?

`string`

###### blockList?

`string`[]

###### createTimestamp?

`number`

###### description?

`string`

###### isAllMemberMuted?

`boolean`

###### isInWhitelist?

`boolean`

###### maxUsers?

`string`

###### memberCount?

`string`

###### memberList?

`string`[]

###### muteExpireTimestamp?

`number`

###### muteKVList?

`Record`\<`string`, `number`\>

###### muteList?

`string`[]

###### owner

`string`

###### permissionType

`number`

###### roomId

`string`

###### roomName?

`string`

#### Returns

`ChatRoom`

## Properties

### adminList?

> `optional` **adminList**: `string`[]

Defined in: common/ChatRoom.ts:95

The admin list of the chat room.

***

### announcement?

> `optional` **announcement**: `string`

Defined in: common/ChatRoom.ts:83

The chat room announcement.

***

### blockList?

> `optional` **blockList**: `string`[]

Defined in: common/ChatRoom.ts:103

The block list of the chat room.

***

### createTimestamp?

> `optional` **createTimestamp**: `number`

Defined in: common/ChatRoom.ts:137

Gets the timestamp(ms) when the chat room was created.
This property is available once join the chat room.

***

### description?

> `optional` **description**: `string`

Defined in: common/ChatRoom.ts:75

The chat room description.

***

### isAllMemberMuted?

> `optional` **isAllMemberMuted**: `boolean`

Defined in: common/ChatRoom.ts:122

Whether all members are muted in the chat room.
- `true`: Yes.
- `false`: No.

***

### isInWhitelist?

> `optional` **isInWhitelist**: `boolean`

Defined in: common/ChatRoom.ts:131

Current user is in allow list or not.
This property is available once join the chat room.
This property will be updated when current user is added or removed from the white list.
- `true`: In white list.
- `false`: Not in white list.

***

### maxUsers?

> `optional` **maxUsers**: `string`

Defined in: common/ChatRoom.ts:91

The maximum number of users allowed to join a chat room. This field is specified during the creation of a chat room.

***

### memberCount?

> `optional` **memberCount**: `string`

Defined in: common/ChatRoom.ts:87

The number of members in the chat room.

***

### memberList?

> `optional` **memberList**: `string`[]

Defined in: common/ChatRoom.ts:99

The member list of the chat room.

***

### muteExpireTimestamp?

> `optional` **muteExpireTimestamp**: `number`

Defined in: common/ChatRoom.ts:148

Gets the timestamp(ms) when Current user will be unmuted.

This property is available once join the chat room.
This property will be updated when current use is muted or unmuted.

- Current use is not muted if it is zero.
- Means cannot get MuteUntilTimeStamp correctly if it is be set with -1;

***

### muteKVList?

> `optional` **muteKVList**: `Record`\<`string`, `number`\>

Defined in: common/ChatRoom.ts:116

The mute list of the chat room.

key: userId
value: mute expire time

***

### ~~muteList?~~

> `optional` **muteList**: `string`[]

Defined in: common/ChatRoom.ts:109

The mute list of the chat room.

#### Deprecated

2024-12-03 Please use `muteKVList` instead.

***

### owner

> **owner**: `string`

Defined in: common/ChatRoom.ts:79

The user ID of the chat room owner.

***

### permissionType

> **permissionType**: [`ChatRoomPermissionType`](../enumerations/ChatRoomPermissionType.md)

Defined in: common/ChatRoom.ts:153

The role of the current user in the chat room. For role types, see [ChatRoomPermissionType](../enumerations/ChatRoomPermissionType.md).

***

### roomId

> **roomId**: `string`

Defined in: common/ChatRoom.ts:67

The chat room ID.

***

### roomName?

> `optional` **roomName**: `string`

Defined in: common/ChatRoom.ts:71

The chat room name.
