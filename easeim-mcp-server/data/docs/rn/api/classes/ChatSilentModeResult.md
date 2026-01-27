[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatSilentModeResult

# Class: ChatSilentModeResult

Defined in: common/ChatSilentMode.ts:164

The configuration result class for the do-not-disturb mode of the offline message push.

## Constructors

### Constructor

> **new ChatSilentModeResult**(`params`): `ChatSilentModeResult`

Defined in: common/ChatSilentMode.ts:193

Constructs an object.

#### Parameters

##### params

###### conversationId

`string`

###### conversationType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### endTime?

[`ChatSilentModeTime`](ChatSilentModeTime.md)

###### expireTimestamp?

`number`

###### remindType?

[`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

###### startTime?

[`ChatSilentModeTime`](ChatSilentModeTime.md)

#### Returns

`ChatSilentModeResult`

## Properties

### conversationId

> **conversationId**: `string`

Defined in: common/ChatSilentMode.ts:176

The conversation ID.

***

### conversationType

> **conversationType**: [`ChatConversationType`](../enumerations/ChatConversationType.md)

Defined in: common/ChatSilentMode.ts:172

The conversation Type.

***

### endTime?

> `optional` **endTime**: [`ChatSilentModeTime`](ChatSilentModeTime.md)

Defined in: common/ChatSilentMode.ts:188

The end point in the do-not-disturb time frame for the offline message push.

***

### expireTimestamp?

> `optional` **expireTimestamp**: `number`

Defined in: common/ChatSilentMode.ts:168

The Unix timestamp when the do-not-disturb mode of the offline message push expires, in milliseconds.

***

### remindType?

> `optional` **remindType**: [`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

Defined in: common/ChatSilentMode.ts:180

The push notification mode.

***

### startTime?

> `optional` **startTime**: [`ChatSilentModeTime`](ChatSilentModeTime.md)

Defined in: common/ChatSilentMode.ts:184

The start point in the do-not-disturb time frame for the offline message push.
