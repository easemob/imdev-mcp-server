[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupMember

# Class: ChatGroupMember

Defined in: common/ChatGroup.ts:425

The class that defines the member information of a chat group.

## Constructors

### Constructor

> **new ChatGroupMember**(`params`): `ChatGroupMember`

Defined in: common/ChatGroup.ts:438

#### Parameters

##### params

###### joinedTimestamp

`number`

###### memberId

`string`

###### role

[`ChatGroupPermissionType`](../enumerations/ChatGroupPermissionType.md)

#### Returns

`ChatGroupMember`

## Properties

### joinedTimestamp

> **joinedTimestamp**: `number`

Defined in: common/ChatGroup.ts:433

The Unix timestamp for the member joining the group, in milliseconds.

***

### memberId

> **memberId**: `string`

Defined in: common/ChatGroup.ts:429

The user ID of the group member.

***

### role

> **role**: [`ChatGroupPermissionType`](../enumerations/ChatGroupPermissionType.md)

Defined in: common/ChatGroup.ts:437

The role of the group member.
