[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatContactEventListener

# Interface: ChatContactEventListener

Defined in: ChatEvents.ts:1035

The contact update listener.

It listens for contact changes, including adding or removing a friend and accepting and declining a friend request.

For descriptions of callback methods in the listener, user A acts as the current user and user B serves as the peer user.

## Methods

### onContactAdded()?

> `optional` **onContactAdded**(`userName`): `void`

Defined in: ChatEvents.ts:1043

Occurs when a friend request from the current user is accepted by the peer user.

For example, after user B accepts a friend request from user A, user A receives this callback.

#### Parameters

##### userName

`string`

The user ID of the user that accepts the friend request of the current user.

#### Returns

`void`

***

### onContactDeleted()?

> `optional` **onContactDeleted**(`userName`): `void`

Defined in: ChatEvents.ts:1051

Occurs when a friend request from the current user is declined by the peer user.

For example, after user B declines a friend request from user A, user A receives this callback.

#### Parameters

##### userName

`string`

The user that declines the friend request from the current user.

#### Returns

`void`

***

### onContactInvited()?

> `optional` **onContactInvited**(`userName`, `reason?`): `void`

Defined in: ChatEvents.ts:1060

Occurs when a friend request is received by the current user.

For example, after user A receives a friend request from user B, user A receives this callback.

#### Parameters

##### userName

`string`

The user who initiates the friend request.

##### reason?

`string`

The invitation message.

#### Returns

`void`

***

### onFriendRequestAccepted()?

> `optional` **onFriendRequestAccepted**(`userName`): `void`

Defined in: ChatEvents.ts:1068

Occurs when a friend request is accepted by the current user.

For example, after user A accepts a friend request from user B, user A receives this callback.

#### Parameters

##### userName

`string`

The user who initiates the friend request.

#### Returns

`void`

***

### onFriendRequestDeclined()?

> `optional` **onFriendRequestDeclined**(`userName`): `void`

Defined in: ChatEvents.ts:1076

Occurs when a friend request is declined by the current user.

For example, after user A declines a friend request from user B, user A receives this callback.

#### Parameters

##### userName

`string`

The user who initiates the friend request.

#### Returns

`void`
