[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatRoomManager

# Class: ChatRoomManager

Defined in: ChatRoomManager.ts:50

The chat room manager class, which manages user operations, like joining and leaving the chat room and retrieving the chat room list, and manages member privileges.

## Extends

- `Native`

## Constructors

### Constructor

> **new ChatRoomManager**(): `ChatRoomManager`

Defined in: ChatRoomManager.ts:52

#### Returns

`ChatRoomManager`

#### Overrides

`Native.constructor`

## Methods

### addAttributes()

> **addAttributes**(`params`): `Promise`\<`Map`\<`string`, `string`\>\>

Defined in: ChatRoomManager.ts:1108

Sets custom chat room attributes.

#### Parameters

##### params

###### attributes

`object`[]

###### deleteWhenLeft?

`boolean`

###### overwrite?

`boolean`

###### roomId

`string`

#### Returns

`Promise`\<`Map`\<`string`, `string`\>\>

If certain attributes fail to be set, the SDK returns a map of the attributes in key-value format, where the key is the attribute key and the value is the reason for the failure.

#### Params

params
- roomId The chat room ID.
- attributes The chat room attributes to add. The attributes are in key-value format.
In a key-value pair, the key is the attribute name that can contain 128 characters at most; the value is the attribute value that cannot exceed 4096 characters.
A chat room can have a maximum of 100 custom attributes and the total length of custom chat room attributes cannot exceed 10 GB for each app. Attribute keys support the following character sets:
  - 26 lowercase English letters (a-z)
  - 26 uppercase English letters (A-Z)
  - 10 numbers (0-9)
  - "_", "-", "."
- deleteWhenLeft: Whether to delete the chat room attributes set by the member when he or she exits the chat room.
  - (Default)`true`: Yes.
  - `false`: No.
- overwrite: Whether to overwrite the attributes with same key set by others.
  - `true`: Yes.
  - (Default)`false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addChatRoomAdmin()

> **addChatRoomAdmin**(`roomId`, `admin`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:637

Adds a chat room admin.

Only the chat room owner can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### admin

`string`

The user ID of the chat room admin to be added.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addMembersToChatRoomAllowList()

> **addMembersToChatRoomAllowList**(`roomId`, `members`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:965

Adds members to the allow list of the chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### members

`string`[]

The user IDs of members to be added to the allow list of the chat room.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addRoomListener()

> **addRoomListener**(`listener`): `void`

Defined in: ChatRoomManager.ts:212

Adds a chat room listener.

#### Parameters

##### listener

[`ChatRoomEventListener`](../interfaces/ChatRoomEventListener.md)

The listener to add.

#### Returns

`void`

***

### blockChatRoomMembers()

> **blockChatRoomMembers**(`roomId`, `members`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:745

Adds the specified members to the block list of the chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### members

`string`[]

The user IDs of members to be added to block list of the chat room.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeChatRoomDescription()

> **changeChatRoomDescription**(`roomId`, `description`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:486

Modifies the chat room description.

Only the chat room owner can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### description

`string`

The new description of the chat room.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeChatRoomSubject()

> **changeChatRoomSubject**(`roomId`, `subject`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:460

Changes the chat room name.

Only the chat room owner can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### subject

`string`

The new name of the chat room.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### changeOwner()

> **changeOwner**(`roomId`, `newOwner`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:616

Transfers the chat room ownership.

Only the chat room owner can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### newOwner

`string`

The user ID of the new chat room owner.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### createChatRoom()

> **createChatRoom**(`subject`, `description?`, `welcome?`, `members?`, `maxCount?`): `Promise`\<[`ChatRoom`](ChatRoom.md)\>

Defined in: ChatRoomManager.ts:402

Creates a chat room.

#### Parameters

##### subject

`string`

The chat room name.

##### description?

`string`

The chat room description.

##### welcome?

`string`

A welcome message for new chat room members.

##### members?

`string`[]

The list of members invited to join the chat room.

##### maxCount?

`number` = `300`

The maximum number of members allowed to join the chat room.

#### Returns

`Promise`\<[`ChatRoom`](ChatRoom.md)\>

The chat room instance.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### destroyChatRoom()

> **destroyChatRoom**(`roomId`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:440

Destroys a chat room.

Only the chat room owner can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomAllowListFromServer()

> **fetchChatRoomAllowListFromServer**(`roomId`): `Promise`\<`string`[]\>

Defined in: ChatRoomManager.ts:885

Gets the allow list from the server.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`string`[]\>

The allow list of the chat room.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomAnnouncement()

> **fetchChatRoomAnnouncement**(`roomId`): `Promise`\<`string` \| `undefined`\>

Defined in: ChatRoomManager.ts:862

Gets the chat room announcement from the server.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`string` \| `undefined`\>

The chat room announcement.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomAttributes()

> **fetchChatRoomAttributes**(`roomId`, `keys?`): `Promise`\<`Map`\<`string`, `string`\>\>

Defined in: ChatRoomManager.ts:1064

Gets custom chat room attributes from the server.

#### Parameters

##### roomId

`string`

The chat room ID.

##### keys?

`string`[]

The key list of custom attributes to get. If you set it as `null` or leave it empty, this method retrieves all custom attributes.

#### Returns

`Promise`\<`Map`\<`string`, `string`\>\>

Custom chat room attributes in key-value format.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomBlockList()

> **fetchChatRoomBlockList**(`roomId`, `pageNum`, `pageSize`): `Promise`\<`string`[]\>

Defined in: ChatRoomManager.ts:803

Gets the chat room block list with pagination.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### pageNum

`number` = `1`

The page number, starting from 1.

##### pageSize

`number` = `200`

The number of users on the block list that you expect to get on each page.

#### Returns

`Promise`\<`string`[]\>

The user IDs of the chat room members on the block list.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomInfoFromServer()

> **fetchChatRoomInfoFromServer**(`roomId`): `Promise`\<[`ChatRoom`](ChatRoom.md) \| `undefined`\>

Defined in: ChatRoomManager.ts:346

Gets the details of the chat room from the server.

By default, the details do not include the chat room member list.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<[`ChatRoom`](ChatRoom.md) \| `undefined`\>

The chat room instance. The SDK returns `undefined` if the chat room does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomMembers()

> **fetchChatRoomMembers**(`roomId`, `cursor`, `pageSize`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<`string`\>\>

Defined in: ChatRoomManager.ts:515

Gets the chat room member list.

#### Parameters

##### roomId

`string`

The chat room ID.

##### cursor

`string` = `''`

The cursor position from which to start to get data.
              At the first method call, if you set `cursor` as `null` or an empty string, the SDK gets the data in the reverse chronological order of when users join the chat room.

##### pageSize

`number` = `200`

The number of members that you expect to get on each page.

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<`string`\>\>

The list of chat room members and the cursor for the next query. See [ChatCursorResult](ChatCursorResult.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchChatRoomMuteList()

> **fetchChatRoomMuteList**(`roomId`, `pageNum`, `pageSize`): `Promise`\<`string`[]\>

Defined in: ChatRoomManager.ts:684

Uses the pagination to get the list of members who are muted in the chat room.

This method gets data from the server.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### pageNum

`number` = `1`

The page number, starting from 1.

##### pageSize

`number` = `200`

The number of muted members that you expect to get on each page.

#### Returns

`Promise`\<`string`[]\>

The user IDs of muted members.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchPublicChatRoomsFromServer()

> **fetchPublicChatRoomsFromServer**(`pageNum`, `pageSize`): `Promise`\<[`ChatPageResult`](ChatPageResult.md)\<[`ChatRoom`](ChatRoom.md)\>\>

Defined in: ChatRoomManager.ts:308

Gets chat room data from the server with pagination.

#### Parameters

##### pageNum

`number` = `1`

The page number, starting from 1.

##### pageSize

`number` = `200`

The number of chat rooms that you expect to get on each page.

#### Returns

`Promise`\<[`ChatPageResult`](ChatPageResult.md)\<[`ChatRoom`](ChatRoom.md)\>\>

The list of obtained chat rooms. See [ChatPageResult](ChatPageResult.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getChatRoomWithId()

> **getChatRoomWithId**(`roomId`): `Promise`\<[`ChatRoom`](ChatRoom.md) \| `undefined`\>

Defined in: ChatRoomManager.ts:373

Gets the chat room by ID from the local database.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<[`ChatRoom`](ChatRoom.md) \| `undefined`\>

The chat room instance. The SDK returns `undefined` if the chat room does not exist.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### isMemberInChatRoomAllowList()

> **isMemberInChatRoomAllowList**(`roomId`): `Promise`\<`boolean`\>

Defined in: ChatRoomManager.ts:912

Checks whether the member is on the allow list of the chat room.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`boolean`\>

Whether the member is on the allow list of the chat room.
         - `true`: Yes.
         - `false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### isMemberInChatRoomMuteList()

> **isMemberInChatRoomMuteList**(`roomId`): `Promise`\<`boolean`\>

Defined in: ChatRoomManager.ts:940

Checks whether the member is in the mute list of the chat room.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`boolean`\>

Whether the member is in the mute list of the chat room.
         - `true`: Yes.
         - `false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### ~~joinChatRoom()~~

> **joinChatRoom**(`roomId`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:246

Joins the chat room.

To leave the chat room, you can call [leaveChatRoom](#leavechatroom).

#### Parameters

##### roomId

`string`

The ID of the chat room to join.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

#### Deprecated

2024-08-15 replaced by [joinChatRoomEx](#joinchatroomex)

***

### joinChatRoomEx()

> **joinChatRoomEx**(`params`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:268

Joins the chat room.

To leave the chat room, you can call [leaveChatRoom](#leavechatroom).

#### Parameters

##### params

###### exitOtherRoom?

`boolean`

###### ext?

`string`

###### roomId

`string`

#### Returns

`Promise`\<`void`\>

#### Params

-

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### leaveChatRoom()

> **leaveChatRoom**(`roomId`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:289

Leaves the chat room.

#### Parameters

##### roomId

`string`

The ID of the chat room to leave.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### muteAllChatRoomMembers()

> **muteAllChatRoomMembers**(`roomId`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:1025

Mutes all members.

Only the chat room owner or admin can call this method.

The chat room owner, admins, and members added to the allow list cannot be muted.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### muteChatRoomMembers()

> **muteChatRoomMembers**(`roomId`, `muteMembers`, `duration`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:557

Mutes the specified members in a chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### muteMembers

`string`[]

The user IDs of members to be muted.

##### duration

`number` = `-1`

The mute duration in milliseconds.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAllRoomListener()

> **removeAllRoomListener**(): `void`

Defined in: ChatRoomManager.ts:230

Removes all the chat room listeners.

#### Returns

`void`

***

### removeAttributes()

> **removeAttributes**(`params`): `Promise`\<`Map`\<`string`, `string`\>\>

Defined in: ChatRoomManager.ts:1149

Removes custom chat room attributes.

#### Parameters

##### params

###### forced?

`boolean`

###### keys

`string`[]

###### roomId

`string`

#### Returns

`Promise`\<`Map`\<`string`, `string`\>\>

If certain attributes fail to be removed, the SDK returns a map of the attributes in key-value format, where the key is the attribute key and the value is the reason for the failure.

#### Params

params
- roomId: The chat room ID.
- keys: The keys of the chat room attributes to remove.
- forced: Whether to remove the attributes with same key set by others.
  - `true`: Yes.
  - (Default)`false`: No.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeChatRoomAdmin()

> **removeChatRoomAdmin**(`roomId`, `admin`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:656

Removes administrative privileges of a chat room admin.

#### Parameters

##### roomId

`string`

The chat room ID.

##### admin

`string`

The user ID of the chat room admin whose administrative privileges are to be removed.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeChatRoomMembers()

> **removeChatRoomMembers**(`roomId`, `members`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:717

Removes the specified members from a chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### members

`string`[]

The user IDs of the members to be removed.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeMembersFromChatRoomAllowList()

> **removeMembersFromChatRoomAllowList**(`roomId`, `members`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:993

Removes members from the allow list of the chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### members

`string`[]

The user IDs of members to be removed from the allow list of the chat room.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeRoomListener()

> **removeRoomListener**(`listener`): `void`

Defined in: ChatRoomManager.ts:222

Removes the chat room listener.

#### Parameters

##### listener

[`ChatRoomEventListener`](../interfaces/ChatRoomEventListener.md)

The listener to remove.

#### Returns

`void`

***

### setNativeListener()

> **setNativeListener**(`event`): `void`

Defined in: ChatRoomManager.ts:61

#### Parameters

##### event

`NativeEventEmitter`

#### Returns

`void`

***

### unBlockChatRoomMembers()

> **unBlockChatRoomMembers**(`roomId`, `members`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:773

Removes the specified members from the block list of the chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### members

`string`[]

The user IDs of members to be removed from the block list of the chat room.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unMuteAllChatRoomMembers()

> **unMuteAllChatRoomMembers**(`roomId`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:1044

Unmutes all members of the chat room.

Only the chat room owner or admins can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unMuteChatRoomMembers()

> **unMuteChatRoomMembers**(`roomId`, `unMuteMembers`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:588

Unmutes the specified members in a chat room.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### unMuteMembers

`string`[]

The user IDs of members to be unmuted.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateChatRoomAnnouncement()

> **updateChatRoomAnnouncement**(`roomId`, `announcement`): `Promise`\<`void`\>

Defined in: ChatRoomManager.ts:836

Updates the chat room announcement.

Only the chat room owner or admin can call this method.

#### Parameters

##### roomId

`string`

The chat room ID.

##### announcement

`string`

The new chat room announcement.

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

`Native._callMethod`

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

`Native.checkErrorFromResult`
