[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatFileMessageBody

# Class: ChatFileMessageBody

Defined in: common/ChatMessage.ts:1327

The file message body class.

## Extends

- `_ChatFileMessageBody`

## Constructors

### Constructor

> **new ChatFileMessageBody**(`params`): `ChatFileMessageBody`

Defined in: common/ChatMessage.ts:1328

#### Parameters

##### params

###### displayName?

`string`

###### fileSize?

`number`

###### fileStatus?

`number`

###### lastModifyOperatorId?

`string`

###### lastModifyTime?

`number`

###### localPath

`string`

###### modifyCount?

`number`

###### remotePath?

`string`

###### secret?

`string`

#### Returns

`ChatFileMessageBody`

#### Overrides

`_ChatFileMessageBody.constructor`

## Properties

### displayName

> **displayName**: `string`

Defined in: common/ChatMessage.ts:1296

The file name.

#### Inherited from

`_ChatFileMessageBody.displayName`

***

### fileSize

> **fileSize**: `number`

Defined in: common/ChatMessage.ts:1292

The size of the file in bytes.

#### Inherited from

`_ChatFileMessageBody.fileSize`

***

### fileStatus

> **fileStatus**: [`ChatDownloadStatus`](../enumerations/ChatDownloadStatus.md)

Defined in: common/ChatMessage.ts:1288

The download status of the attachment file. See [ChatDownloadStatus](../enumerations/ChatDownloadStatus.md).

#### Inherited from

`_ChatFileMessageBody.fileStatus`

***

### lastModifyOperatorId?

> `optional` **lastModifyOperatorId**: `string`

Defined in: common/ChatMessage.ts:1164

The user ID of the operator that modified the message last time.

#### Inherited from

`_ChatFileMessageBody.lastModifyOperatorId`

***

### lastModifyTime?

> `optional` **lastModifyTime**: `number`

Defined in: common/ChatMessage.ts:1169

The UNIX timestamp of the last message modification, in milliseconds.

#### Inherited from

`_ChatFileMessageBody.lastModifyTime`

***

### localPath

> **localPath**: `string` = `''`

Defined in: common/ChatMessage.ts:1276

The local path of the file.

#### Inherited from

`_ChatFileMessageBody.localPath`

***

### modifyCount?

> `optional` **modifyCount**: `number`

Defined in: common/ChatMessage.ts:1174

The number of times a message is modified.

#### Inherited from

`_ChatFileMessageBody.modifyCount`

***

### remotePath

> **remotePath**: `string`

Defined in: common/ChatMessage.ts:1284

The path of the attachment file in the server.

#### Inherited from

`_ChatFileMessageBody.remotePath`

***

### secret

> **secret**: `string`

Defined in: common/ChatMessage.ts:1280

The token to download the file attachment.

#### Inherited from

`_ChatFileMessageBody.secret`

***

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

#### Inherited from

`_ChatFileMessageBody.type`
