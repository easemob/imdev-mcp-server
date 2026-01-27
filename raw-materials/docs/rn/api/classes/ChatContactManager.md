[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatContactManager

# Class: ChatContactManager

Defined in: ChatContactManager.ts:34

The contact manager class, which manages chat contacts such as adding, retrieving, modifying, and deleting contacts.

## Extends

- `BaseManager`

## Constructors

### Constructor

> **new ChatContactManager**(): `ChatContactManager`

Defined in: ChatContactManager.ts:36

#### Returns

`ChatContactManager`

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

> `protected` `static` **TAG**: `string` = `'ChatContactManager'`

Defined in: ChatContactManager.ts:35

#### Overrides

`BaseManager.TAG`

## Methods

### acceptInvitation()

> **acceptInvitation**(`userId`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:265

Accepts a friend invitation。

#### Parameters

##### userId

`string`

The user who sends the friend invitation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addContact()

> **addContact**(`userId`, `reason`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:127

Adds a new contact.

#### Parameters

##### userId

`string`

The user ID of the contact to add.

##### reason

`string` = `''`

The reason for adding the contact. This parameter is optional and can be `null` or "".

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### addContactListener()

> **addContactListener**(`listener`): `void`

Defined in: ChatContactManager.ts:96

Adds a contact listener.

#### Parameters

##### listener

[`ChatContactEventListener`](../interfaces/ChatContactEventListener.md)

The listener to add.

#### Returns

`void`

***

### addUserToBlockList()

> **addUserToBlockList**(`userId`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:201

Adds a contact to the block list.

You can send messages to the users on the block list, but cannot receive messages from them.

#### Parameters

##### userId

`string`

The user ID of the contact to be added to the block list.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### declineInvitation()

> **declineInvitation**(`userId`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:280

Declines a friend invitation.

#### Parameters

##### userId

`string`

The user who sends the friend invitation.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### deleteContact()

> **deleteContact**(`userId`, `keepConversation`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:148

Deletes a contact and all the related conversations.

#### Parameters

##### userId

`string`

The user ID of the contact to delete.

##### keepConversation

`boolean` = `false`

Whether to retain conversations of the contact to delete.
- `true`: Yes.
- (Default) `false`: No.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchAllContacts()

> **fetchAllContacts**(): `Promise`\<[`ChatContact`](ChatContact.md)[]\>

Defined in: ChatContactManager.ts:352

Gets all contacts from the server.

#### Returns

`Promise`\<[`ChatContact`](ChatContact.md)[]\>

The list of contacts.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchContacts()

> **fetchContacts**(`params`): `Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatContact`](ChatContact.md)\>\>

Defined in: ChatContactManager.ts:373

Gets the contacts from the server.

#### Parameters

##### params

###### cursor?

`string`

###### pageSize?

`number`

#### Returns

`Promise`\<[`ChatCursorResult`](ChatCursorResult.md)\<[`ChatContact`](ChatContact.md)\>\>

The list of contacts.

#### Params

params -
- cursor: The cursor of the page to get. The first page is an empty string.
- pageSize: The number of contacts to get. The default value is 20. [1-50]

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getAllContacts()

> **getAllContacts**(): `Promise`\<[`ChatContact`](ChatContact.md)[]\>

Defined in: ChatContactManager.ts:310

Gets all contacts from the local database.

#### Returns

`Promise`\<[`ChatContact`](ChatContact.md)[]\>

The list of contacts.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getAllContactsFromDB()

> **getAllContactsFromDB**(): `Promise`\<`string`[]\>

Defined in: ChatContactManager.ts:184

Gets the contact list from the local database.

#### Returns

`Promise`\<`string`[]\>

The contact list.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getAllContactsFromServer()

> **getAllContactsFromServer**(): `Promise`\<`string`[]\>

Defined in: ChatContactManager.ts:169

Gets the contact list from the server.

#### Returns

`Promise`\<`string`[]\>

The list of contacts.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getBlockListFromDB()

> **getBlockListFromDB**(): `Promise`\<`string`[]\>

Defined in: ChatContactManager.ts:250

Gets the block list from the local database.

#### Returns

`Promise`\<`string`[]\>

The block list obtained from the local database.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getBlockListFromServer()

> **getBlockListFromServer**(): `Promise`\<`string`[]\>

Defined in: ChatContactManager.ts:235

Gets the block list from the server.

#### Returns

`Promise`\<`string`[]\>

The block list obtained from the server.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getContact()

> **getContact**(`userId`): `Promise`\<[`ChatContact`](ChatContact.md) \| `undefined`\>

Defined in: ChatContactManager.ts:330

Gets the contact by user ID from local database.

#### Parameters

##### userId

`string`

The user ID of the contact to get.

#### Returns

`Promise`\<[`ChatContact`](ChatContact.md) \| `undefined`\>

The contact.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### getSelfIdsOnOtherPlatform()

> **getSelfIdsOnOtherPlatform**(): `Promise`\<`string`[]\>

Defined in: ChatContactManager.ts:295

Gets the unique IDs of the current user on the other devices. The ID is in the format of `{user_ID} + "/" + {resource_ID}`.

#### Returns

`Promise`\<`string`[]\>

The list of unique IDs of users on the other devices if the method succeeds.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAllContactListener()

> **removeAllContactListener**(): `void`

Defined in: ChatContactManager.ts:114

Removes all contact listeners.

#### Returns

`void`

***

### removeContactListener()

> **removeContactListener**(`listener`): `void`

Defined in: ChatContactManager.ts:106

Removes the contact listener.

#### Parameters

##### listener

[`ChatContactEventListener`](../interfaces/ChatContactEventListener.md)

The listener to remove.

#### Returns

`void`

***

### removeUserFromBlockList()

> **removeUserFromBlockList**(`userId`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:218

Removes the contact from the block list.

#### Parameters

##### userId

`string`

The user ID of the contact to be removed from the block list.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setContactRemark()

> **setContactRemark**(`contact`): `Promise`\<`void`\>

Defined in: ChatContactManager.ts:406

Set the contact's remark.

#### Parameters

##### contact

[`ChatContact`](ChatContact.md)

The contact to set.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setNativeListener()

> **setNativeListener**(`event`): `void`

Defined in: ChatContactManager.ts:45

#### Parameters

##### event

`NativeEventEmitter`

#### Returns

`void`

#### Overrides

`BaseManager.setNativeListener`

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
