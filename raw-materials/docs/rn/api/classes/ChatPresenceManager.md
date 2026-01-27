[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatPresenceManager

# Class: ChatPresenceManager

Defined in: ChatPresenceManager.ts:19

The presence manager class.

## Extends

- `Native`

## Constructors

### Constructor

> **new ChatPresenceManager**(): `ChatPresenceManager`

Defined in: ChatPresenceManager.ts:25

#### Returns

`ChatPresenceManager`

#### Overrides

`Native.constructor`

## Methods

### addPresenceListener()

> **addPresenceListener**(`listener`): `void`

Defined in: ChatPresenceManager.ts:60

Adds a presence listener.

#### Parameters

##### listener

[`ChatPresenceEventListener`](../interfaces/ChatPresenceEventListener.md)

The presence listener to add.

#### Returns

`void`

***

### fetchPresenceStatus()

> **fetchPresenceStatus**(`members`): `Promise`\<[`ChatPresence`](ChatPresence.md)[]\>

Defined in: ChatPresenceManager.ts:180

Gets the current presence state of specified users.

#### Parameters

##### members

`string`[]

The array of user IDs whose current presence state you want to check.

#### Returns

`Promise`\<[`ChatPresence`](ChatPresence.md)[]\>

The current presence states of the specified users.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchSubscribedMembers()

> **fetchSubscribedMembers**(`pageNum`, `pageSize`): `Promise`\<`string`[]\>

Defined in: ChatPresenceManager.ts:153

Uses the pagination to get a list of users whose presence states you have subscribed to.

#### Parameters

##### pageNum

`number` = `1`

The current page number, starting from 1.

##### pageSize

`number` = `20`

The number of subscribed users that you expect to get on each page.

#### Returns

`Promise`\<`string`[]\>

The user IDs of your subscriptions. The SDK returns `null` if you does not subscribe to the presence state of any users.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### publishPresence()

> **publishPresence**(`description?`): `Promise`\<`void`\>

Defined in: ChatPresenceManager.ts:87

Publishes a custom presence state.

#### Parameters

##### description?

`string`

The extension information of the presence state. It can be set as nil.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeAllPresenceListener()

> **removeAllPresenceListener**(): `void`

Defined in: ChatPresenceManager.ts:76

Clears all presence listeners.

#### Returns

`void`

***

### removePresenceListener()

> **removePresenceListener**(`listener`): `void`

Defined in: ChatPresenceManager.ts:69

Removes a presence listener.

#### Parameters

##### listener

[`ChatPresenceEventListener`](../interfaces/ChatPresenceEventListener.md)

The presence listener to remove.

#### Returns

`void`

***

### setNativeListener()

> **setNativeListener**(`event`): `void`

Defined in: ChatPresenceManager.ts:31

#### Parameters

##### event

`NativeEventEmitter`

#### Returns

`void`

***

### subscribe()

> **subscribe**(`members`, `expiry`): `Promise`\<[`ChatPresence`](ChatPresence.md)[]\>

Defined in: ChatPresenceManager.ts:108

Subscribes to the presence state of a user.

If the subscription succeeds, the subscriber will receive the callback when the presence state of the user changes.

#### Parameters

##### members

`string`[]

The array of user IDs users whose presence state you want to subscribe to.

##### expiry

`number`

The subscription duration in seconds. The duration cannot exceed 2,592,000 (30×24×3600) seconds, i.e., 30 days.

#### Returns

`Promise`\<[`ChatPresence`](ChatPresence.md)[]\>

The current presence state of users to whom you have subscribed.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### unsubscribe()

> **unsubscribe**(`members`): `Promise`\<`void`\>

Defined in: ChatPresenceManager.ts:134

Unsubscribes from the presence state of the unspecified users.

#### Parameters

##### members

`string`[]

The array of user IDs whose presence state you want to unsubscribe from.

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
