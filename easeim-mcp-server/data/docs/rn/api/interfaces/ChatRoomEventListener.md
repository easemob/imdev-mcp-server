[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatRoomEventListener

# Interface: ChatRoomEventListener

Defined in: ChatEvents.ts:1082

The chat room event listener.

## Methods

### onAdminAdded()?

> `optional` **onAdminAdded**(`params`): `void`

Defined in: ChatEvents.ts:1172

Occurs when a chat room member is set as an admin. The member set as the chat room admin receives this event.

#### Parameters

##### params

###### admin

`string`

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [admin]  The user ID of the member who is set as an admin.

***

### onAdminRemoved()?

> `optional` **onAdminRemoved**(`params`): `void`

Defined in: ChatEvents.ts:1180

Occurs when the chat room member(s) is/are removed from the admin list. The admin removed from the admin list receives this event.

#### Parameters

##### params

###### admin

`string`

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [admin] The user ID of the admin whose administrative privileges are removed.

***

### onAllChatRoomMemberMuteStateChanged()?

> `optional` **onAllChatRoomMemberMuteStateChanged**(`params`): `void`

Defined in: ChatEvents.ts:1230

Occurs when all members in the chat room are muted or unmuted. All chat room members receive this event.

#### Parameters

##### params

###### isAllMuted

`boolean`

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [isAllMuted] Whether all chat room members are muted.
  - `true`: Yes.
  - `false`: No.

***

### onAllowListAdded()?

> `optional` **onAllowListAdded**(`params`): `void`

Defined in: ChatEvents.ts:1212

Occurs when the chat room member(s) is/are added to the allow list. The members added to the allow list receive this event.

#### Parameters

##### params

###### members

`string`[]

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [members] The member(s) added to the allow list of the chat room.

***

### onAllowListRemoved()?

> `optional` **onAllowListRemoved**(`params`): `void`

Defined in: ChatEvents.ts:1220

Occurs when the chat room member(s) is/are removed from the allow list. The members that are removed from the allow list receive this event.

#### Parameters

##### params

###### members

`string`[]

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [members] The member(s) removed from the allow list of the chat room.

***

### onAnnouncementChanged()?

> `optional` **onAnnouncementChanged**(`params`): `void`

Defined in: ChatEvents.ts:1201

Occurs when the chat room announcement changes. All chat room members receive this event.

#### Parameters

##### params

###### announcement

`string`

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [announcement] The new announcement.

***

### onAttributesRemoved()?

> `optional` **onAttributesRemoved**(`params`): `void`

Defined in: ChatEvents.ts:1264

The custom chat room attribute(s) is/are removed. All chat room members receive this event.

#### Parameters

##### params

###### from

`string`

###### removedKeys

`string`[]

###### roomId

`string`

#### Returns

`void`

#### Params

params
- roomId: The chat room ID.
- removedKeys: The key list of custom chat room attributes that are removed.
- from: The user ID of the operator.

***

### onAttributesUpdated()?

> `optional` **onAttributesUpdated**(`params`): `void`

Defined in: ChatEvents.ts:1250

The custom chat room attribute(s) is/are updated. All chat room members receive this event.

#### Parameters

##### params

###### attributes

`Map`\<`string`, `string`\>

###### from

`string`

###### roomId

`string`

#### Returns

`void`

#### Params

params
- roomId: The chat room ID.
- attributes: The list of custom chat room attributes (key-value) that are updated.
- from: The user ID of the operator.

***

### onDestroyed()?

> `optional` **onDestroyed**(`params`): `void`

Defined in: ChatEvents.ts:1090

Occurs when the chat room is destroyed. All chat room members receive this event.

#### Parameters

##### params

###### roomId

`string`

###### roomName?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [roomName] The name of the chat room.

***

### onMemberExited()?

> `optional` **onMemberExited**(`params`): `void`

Defined in: ChatEvents.ts:1110

Occurs when a member exits the chat room. All chat room members, except the member exiting the chat room, receive this event.

#### Parameters

##### params

###### participant

`string`

###### roomId

`string`

###### roomName?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [participant] The user ID of the member who leaves the chat room.

***

### onMemberJoined()?

> `optional` **onMemberJoined**(`params`): `void`

Defined in: ChatEvents.ts:1098

Occurs when a member joins the chat room. All chat room members, except the new member, receive this event.

#### Parameters

##### params

###### ext?

`string`

###### participant

`string`

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [participant] The user ID of the new member.

***

### onMemberRemoved()?

> `optional` **onMemberRemoved**(`params`): `void`

Defined in: ChatEvents.ts:1124

Occurs when a member is removed from a chat room. The member that is kicked out of the chat room receive this event.

#### Parameters

##### params

###### participant?

`string`

###### reason?

`string`

###### roomId

`string`

###### roomName?

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [roomName] The name of the chat room.
- Param [participant] The user ID of the member that is removed from a chat room.
- Param [reason] Reason for removal.

***

### ~~onMuteListAdded()?~~

> `optional` **onMuteListAdded**(`params`): `void`

Defined in: ChatEvents.ts:1140

Occurs when the chat room member(s) is/are added to the mute list. The muted members receive this event.

#### Parameters

##### params

###### expireTime?

`string`

###### mutes

`string`[]

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [mutes] The user ID(s) of muted member(s).
- Param [expireTime] Reserved parameter. The Unix timestamp when the mute duration expires.

#### Deprecated

2024-12-03, Please use [onMuteListAddedV2](#onmutelistaddedv2) instead.

***

### onMuteListAddedV2()?

> `optional` **onMuteListAddedV2**(`params`): `void`

Defined in: ChatEvents.ts:1153

Occurs when the chat room member(s) is/are added to the mute list. The muted members receive this event.

#### Parameters

##### params

###### mutes

`Record`\<`string`, `number`\>

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [mutes] The user list. key is User ID, value is the mute expire time.

***

### onMuteListRemoved()?

> `optional` **onMuteListRemoved**(`params`): `void`

Defined in: ChatEvents.ts:1164

Occurs when the chat room member(s) is/are removed from the mute list. The members that are removed from the mute list receive this event.

#### Parameters

##### params

###### mutes

`string`[]

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [mutes] The user ID(s) of unmuted member(s).

***

### onOwnerChanged()?

> `optional` **onOwnerChanged**(`params`): `void`

Defined in: ChatEvents.ts:1189

Occurs when the chat room owner is changed. The chat room owner receives this event.

#### Parameters

##### params

###### newOwner

`string`

###### oldOwner

`string`

###### roomId

`string`

#### Returns

`void`

#### Params

The parameter set.
- Param [roomId] The chat room ID.
- Param [newOwner] The user ID of the new chat room owner.
- Param [oldOwner] The user ID of the previous chat room owner.

***

### onSpecificationChanged()?

> `optional` **onSpecificationChanged**(`room`): `void`

Defined in: ChatEvents.ts:1240

Occurs when the chat room specifications changes. All chat room members receive this event.

#### Parameters

##### room

[`ChatRoom`](../classes/ChatRoom.md)

The chat room.

#### Returns

`void`
