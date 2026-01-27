[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatTextMessageBody

# Class: ChatTextMessageBody

Defined in: common/ChatMessage.ts:1194

The text message body class.

## Extends

- [`ChatMessageBody`](ChatMessageBody.md)

## Constructors

### Constructor

> **new ChatTextMessageBody**(`params`): `ChatTextMessageBody`

Defined in: common/ChatMessage.ts:1209

#### Parameters

##### params

###### content

`string`

###### lastModifyOperatorId?

`string`

###### lastModifyTime?

`number`

###### modifyCount?

`number`

###### targetLanguageCodes?

`string`[]

###### translations?

`any`

#### Returns

`ChatTextMessageBody`

#### Overrides

[`ChatMessageBody`](ChatMessageBody.md).[`constructor`](ChatMessageBody.md#constructor)

## Properties

### content

> **content**: `string`

Defined in: common/ChatMessage.ts:1198

The text message content.

***

### lastModifyOperatorId?

> `optional` **lastModifyOperatorId**: `string`

Defined in: common/ChatMessage.ts:1164

The user ID of the operator that modified the message last time.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`lastModifyOperatorId`](ChatMessageBody.md#lastmodifyoperatorid)

***

### lastModifyTime?

> `optional` **lastModifyTime**: `number`

Defined in: common/ChatMessage.ts:1169

The UNIX timestamp of the last message modification, in milliseconds.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`lastModifyTime`](ChatMessageBody.md#lastmodifytime)

***

### modifyCount?

> `optional` **modifyCount**: `number`

Defined in: common/ChatMessage.ts:1174

The number of times a message is modified.

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`modifyCount`](ChatMessageBody.md#modifycount)

***

### targetLanguageCodes?

> `optional` **targetLanguageCodes**: `string`[]

Defined in: common/ChatMessage.ts:1202

The target language for translation. See [https://docs.microsoft.com/en-us/azure/cognitive-services/translator/language-support](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/language-support).

***

### translations?

> `optional` **translations**: `any`

Defined in: common/ChatMessage.ts:1208

The translation.

It is a KV object, where the key is the target language and the value is the translation.

***

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

#### Inherited from

[`ChatMessageBody`](ChatMessageBody.md).[`type`](ChatMessageBody.md#type)
