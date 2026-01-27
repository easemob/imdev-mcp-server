[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatPresence

# Class: ChatPresence

Defined in: common/ChatPresence.ts:4

The presence property class that contains presence properties, including the publisher's user ID and current presence state, and the platform used by the online device, as well as the presence's extension information, update time, and subscription expiration time.

## Constructors

### Constructor

> **new ChatPresence**(`params`): `ChatPresence`

Defined in: common/ChatPresence.ts:26

#### Parameters

##### params

###### expiryTime

`string`

###### lastTime

`string`

###### publisher

`string`

###### statusDescription

`string`

###### statusDetails

`any`

#### Returns

`ChatPresence`

## Properties

### expiryTime

> **expiryTime**: `string`

Defined in: common/ChatPresence.ts:20

The Unix timestamp when the presence subscription expires. The unit is second.

***

### lastTime

> **lastTime**: `string`

Defined in: common/ChatPresence.ts:16

The Unix timestamp when the presence state is last updated. The unit is second.

***

### publisher

> **publisher**: `string`

Defined in: common/ChatPresence.ts:8

The user ID of the presence publisher.

***

### statusDescription

> **statusDescription**: `string`

Defined in: common/ChatPresence.ts:12

The custom online state such as busy, away, or hidden.

***

### statusDetails

> **statusDetails**: `Map`\<`string`, `number`\>

Defined in: common/ChatPresence.ts:24

The details of the current presence state.
