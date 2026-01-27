[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatUserInfo

# Class: ChatUserInfo

Defined in: common/ChatUserInfo.ts:4

The user information class, which contains the user attributes, such as the user ID and the nickname and avatar of a user.

## Constructors

### Constructor

> **new ChatUserInfo**(`params`): `ChatUserInfo`

Defined in: common/ChatUserInfo.ts:47

#### Parameters

##### params

###### avatarUrl?

`string`

###### birth?

`string`

###### ext?

`string`

###### gender?

`number`

###### mail?

`string`

###### nickName?

`string`

###### phone?

`string`

###### sign?

`string`

###### userId

`string`

#### Returns

`ChatUserInfo`

## Properties

### avatarUrl?

> `optional` **avatarUrl**: `string`

Defined in: common/ChatUserInfo.ts:16

The avatar URL of the user.

***

### birth?

> `optional` **birth**: `string`

Defined in: common/ChatUserInfo.ts:39

The birthday of the user.

***

### ext?

> `optional` **ext**: `string`

Defined in: common/ChatUserInfo.ts:45

The extension information of the user.

You can specify either an empty string or the custom information encapsulated as the JSON string.

***

### gender?

> `optional` **gender**: `number`

Defined in: common/ChatUserInfo.ts:31

The gender of the user.
- (Default) `0`: Unknown.
- `1`: Male.
- `2`: Female.

***

### mail?

> `optional` **mail**: `string`

Defined in: common/ChatUserInfo.ts:20

The email address of the user.

***

### nickName?

> `optional` **nickName**: `string`

Defined in: common/ChatUserInfo.ts:12

The nickname of the user.

***

### phone?

> `optional` **phone**: `string`

Defined in: common/ChatUserInfo.ts:24

The mobile phone number of the user.

***

### sign?

> `optional` **sign**: `string`

Defined in: common/ChatUserInfo.ts:35

The signature of the user.

***

### userId

> **userId**: `string`

Defined in: common/ChatUserInfo.ts:8

The user ID.
