[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatVideoMessageBody

# Class: ChatVideoMessageBody

Defined in: common/ChatMessage.ts:1428

The video message body class.

## Extends

- `_ChatFileMessageBody`

## Constructors

### Constructor

> **new ChatVideoMessageBody**(`params`): `ChatVideoMessageBody`

Defined in: common/ChatMessage.ts:1457

#### Parameters

##### params

###### displayName

`string`

###### duration?

`number`

###### fileSize?

`number`

###### fileStatus?

`number`

###### height?

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

###### thumbnailLocalPath?

`string`

###### thumbnailRemotePath?

`string`

###### thumbnailSecret?

`string`

###### thumbnailStatus?

[`ChatDownloadStatus`](../enumerations/ChatDownloadStatus.md)

###### width?

`number`

#### Returns

`ChatVideoMessageBody`

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

### duration

> **duration**: `number`

Defined in: common/ChatMessage.ts:1432

The video duration in seconds.

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

### height

> **height**: `number`

Defined in: common/ChatMessage.ts:1456

The video height in pixels.

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

### thumbnailLocalPath

> **thumbnailLocalPath**: `string`

Defined in: common/ChatMessage.ts:1436

The local path of the video thumbnail.

***

### thumbnailRemotePath

> **thumbnailRemotePath**: `string`

Defined in: common/ChatMessage.ts:1440

The URL of the thumbnail on the server.

***

### thumbnailSecret

> **thumbnailSecret**: `string`

Defined in: common/ChatMessage.ts:1444

The secret to download the video thumbnail.

***

### thumbnailStatus

> **thumbnailStatus**: [`ChatDownloadStatus`](../enumerations/ChatDownloadStatus.md)

Defined in: common/ChatMessage.ts:1448

The download status of the video thumbnail. See [ChatDownloadStatus](../enumerations/ChatDownloadStatus.md)

***

### type

> `readonly` **type**: [`ChatMessageType`](../enumerations/ChatMessageType.md)

Defined in: common/ChatMessage.ts:1159

The message type. See [ChatMessageType](../enumerations/ChatMessageType.md).

#### Inherited from

`_ChatFileMessageBody.type`

***

### width

> **width**: `number`

Defined in: common/ChatMessage.ts:1452

The video width in pixels.
