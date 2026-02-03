[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatUserInfoManager

# Class: ChatUserInfoManager

Defined in: ChatUserInfoManager.ts:13

The user information manager for updating and getting user attributes.

## Extends

- `Native`

## Constructors

### Constructor

> **new ChatUserInfoManager**(): `ChatUserInfoManager`

Defined in: ChatUserInfoManager.ts:16

#### Returns

`ChatUserInfoManager`

#### Overrides

`Native.constructor`

## Methods

### fetchOwnInfo()

> **fetchOwnInfo**(): `Promise`\<[`ChatUserInfo`](ChatUserInfo.md) \| `undefined`\>

Defined in: ChatUserInfoManager.ts:96

Gets attributes of the current user from the server.

#### Returns

`Promise`\<[`ChatUserInfo`](ChatUserInfo.md) \| `undefined`\>

The obtained user attributes. See [ChatUserInfo](ChatUserInfo.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchUserInfoById()

> **fetchUserInfoById**(`userIds`): `Promise`\<`Map`\<`string`, [`ChatUserInfo`](ChatUserInfo.md)\>\>

Defined in: ChatUserInfoManager.ts:71

Gets the user attributes of the specified users.

#### Parameters

##### userIds

`string`[]

The user ID array.

#### Returns

`Promise`\<`Map`\<`string`, [`ChatUserInfo`](ChatUserInfo.md)\>\>

A map that contains key-value pairs where the key is the user ID and the value is user attributes，see [ChatUserInfo](ChatUserInfo.md).

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updateOwnUserInfo()

> **updateOwnUserInfo**(`params`): `Promise`\<`void`\>

Defined in: ChatUserInfoManager.ts:38

Modifies the user attributes of the current user.

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

#### Returns

`Promise`\<`void`\>

#### Params

The parameter set.
- [nickName] The nickname of the user.
- [avatarUrl] The avatar URL of the user.
- [mail] The email address of the user.
- [phone] The phone number of the user.
- [gender] The gender of the user. The value can only be `0`, `1`, or `2`. Other values are invalid.
   - `0`: (Default) Unknown;
   - `1`: Male;
   - `2`: Female.
- [sign] The signature of the user.
- [birth] The birthday of the user.
- [ext] The custom extension information of the user. You can set it to an empty string or type custom information and encapsulate them as a JSON string.

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
