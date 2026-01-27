[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupMessageAck

# Class: ChatGroupMessageAck

Defined in: common/ChatGroup.ts:116

The class for read receipts of group messages.

## Constructors

### Constructor

> **new ChatGroupMessageAck**(`params`): `ChatGroupMessageAck`

Defined in: common/ChatGroup.ts:141

#### Parameters

##### params

###### ack_id

`string`

###### count

`number`

###### ext?

\{ `content`: `string`; \}

###### ext.content

`string`

###### from

`string`

###### msg_id

`string`

###### timestamp

`number`

#### Returns

`ChatGroupMessageAck`

## Properties

### ack\_id

> **ack\_id**: `string`

Defined in: common/ChatGroup.ts:124

The ID of the read receipt of a group message.

***

### content?

> `optional` **content**: `string`

Defined in: common/ChatGroup.ts:140

The extension information of a read receipt.

***

### count

> **count**: `number`

Defined in: common/ChatGroup.ts:132

The number of read receipts of group messages.

***

### from

> **from**: `string`

Defined in: common/ChatGroup.ts:128

The ID of the user who sends the read receipt.

***

### msg\_id

> **msg\_id**: `string`

Defined in: common/ChatGroup.ts:120

The group message ID.

***

### timestamp

> **timestamp**: `number`

Defined in: common/ChatGroup.ts:136

The Unix timestamp of sending the read receipt of a group message. The unit is millisecond.
