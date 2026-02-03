[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMessageThreadEvent

# Class: ChatMessageThreadEvent

Defined in: common/ChatMessageThread.ts:132

The message thread event class.

## Constructors

### Constructor

> **new ChatMessageThreadEvent**(`params`): `ChatMessageThreadEvent`

Defined in: common/ChatMessageThread.ts:148

Constructs a message thread event.

#### Parameters

##### params

###### from

`string`

###### thread

`any`

###### type

`number`

#### Returns

`ChatMessageThreadEvent`

## Properties

### from

> **from**: `string`

Defined in: common/ChatMessageThread.ts:136

The user ID of the message thread operator.

***

### thread

> **thread**: [`ChatMessageThread`](ChatMessageThread.md)

Defined in: common/ChatMessageThread.ts:144

The message thread object.

***

### type

> **type**: [`ChatMessageThreadOperation`](../enumerations/ChatMessageThreadOperation.md)

Defined in: common/ChatMessageThread.ts:140

The message thread event type.
