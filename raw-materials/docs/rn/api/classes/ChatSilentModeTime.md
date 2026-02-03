[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatSilentModeTime

# Class: ChatSilentModeTime

Defined in: common/ChatSilentMode.ts:42

The time class that is used to set the start point and end point in the do-not-disturb time frame for the offline message push.

## Constructors

### Constructor

> **new ChatSilentModeTime**(`params?`): `ChatSilentModeTime`

Defined in: common/ChatSilentMode.ts:56

#### Parameters

##### params?

###### hour?

`number`

###### minute?

`number`

#### Returns

`ChatSilentModeTime`

## Properties

### hour

> **hour**: `number`

Defined in: common/ChatSilentMode.ts:48

The start or end hour of the do-not-disturb time frame.

The time is based on a 24-hour clock. The value range is [0,23].

***

### minute

> **minute**: `number`

Defined in: common/ChatSilentMode.ts:54

The start or end minute of the do-not-disturb time frame.

The value range is [0,59].
