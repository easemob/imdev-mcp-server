[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatFetchMessageOptions

# Class: ChatFetchMessageOptions

Defined in: common/ChatMessage.ts:1665

The parameter configuration class for pulling historical messages from the server.

## Constructors

### Constructor

> **new ChatFetchMessageOptions**(`params`): `ChatFetchMessageOptions`

Defined in: common/ChatMessage.ts:1698

#### Parameters

##### params

###### direction

[`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

###### endTs

`number`

###### from?

`string`

###### msgTypes?

[`ChatMessageType`](../enumerations/ChatMessageType.md)[]

###### needSave

`boolean`

###### senders?

`string`[]

###### startTs

`number`

#### Returns

`ChatFetchMessageOptions`

## Properties

### direction

> **direction**: [`ChatSearchDirection`](../enumerations/ChatSearchDirection.md)

Defined in: common/ChatMessage.ts:1691

The message search direction, Default is [ChatSearchDirection.UP](../enumerations/ChatSearchDirection.md#up).

***

### endTs

> **endTs**: `number`

Defined in: common/ChatMessage.ts:1687

The end time for message query. The time is a UNIX time stamp in milliseconds.

***

### ~~from?~~

> `optional` **from**: `string`

Defined in: common/ChatMessage.ts:1671

The user ID of the message sender in the group conversation.

#### Deprecated

2025-07-21. Use `senders` instead.

***

### msgTypes?

> `optional` **msgTypes**: [`ChatMessageType`](../enumerations/ChatMessageType.md)[]

Defined in: common/ChatMessage.ts:1679

The array of message types for query. The default value is `undefined`, indicating that all types of messages are retrieved.

***

### needSave

> **needSave**: `boolean`

Defined in: common/ChatMessage.ts:1697

Whether to save the retrieved messages to the database:
- `true`: save to database;
- `false`(Default)：no save to database.

***

### senders?

> `optional` **senders**: `string`[]

Defined in: common/ChatMessage.ts:1675

The array of user IDs of the message senders in the group conversation.

***

### startTs

> **startTs**: `number`

Defined in: common/ChatMessage.ts:1683

The start time for message query. The time is a UNIX time stamp in milliseconds. The default value is -1,indicating that this parameter is ignored during message query.If the [startTs] is set to a specific time spot and the [endTs] uses the default value -1,the SDK returns messages that are sent and received in the period that is from the start time to the current time.If the [startTs] uses the default value -1 and the [endTs] is set to a specific time spot,the SDK returns messages that are sent and received in the period that is from the timestamp of the first message to the current time.
