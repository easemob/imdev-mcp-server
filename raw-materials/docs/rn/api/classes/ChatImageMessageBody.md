[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatImageMessageBody

# Class: ChatImageMessageBody

Defined in: common/ChatMessage.ts:1346

The image message body class.

## Extends

- `_ChatFileMessageBody`

## Constructors

### Constructor

> **new ChatImageMessageBody**(`params`): `ChatImageMessageBody`

Defined in: common/ChatMessage.ts:1381

#### Parameters

##### params

###### displayName

`string`

###### fileSize?

`number`

###### fileStatus?

`number`

###### height?

`number`

###### isGif?

`boolean`

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

###### sendOriginalImage?

`boolean`

###### thumbnailLocalPath?

`string`

###### thumbnailRemotePath?

`string`

###### thumbnailSecret?

`string`

###### thumbnailStatus?

`number`

###### width?

`number`

#### Returns

`ChatImageMessageBody`

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

### height

> **height**: `number`

Defined in: common/ChatMessage.ts:1376

The image height in pixels.

***

### isGif?

> `optional` **isGif**: `boolean`

Defined in: common/ChatMessage.ts:1380

Whether the image is a GIF.

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

### sendOriginalImage

> **sendOriginalImage**: `boolean`

Defined in: common/ChatMessage.ts:1352

Whether to send the original image.
* - `true`: Yes.
* - (Default) `false`: No. If the image is smaller than 100 KB, the SDK sends the original image. If the image is equal to or greater than 100 KB, the SDK will compress it before sending the compressed image.

***

### thumbnailLocalPath

> **thumbnailLocalPath**: `string`

Defined in: common/ChatMessage.ts:1356

The local path or the URI of the thumbnail as a string.

***

### thumbnailRemotePath

> **thumbnailRemotePath**: `string`

Defined in: common/ChatMessage.ts:1360

The URL of the thumbnail on the server.

***

### thumbnailSecret

> **thumbnailSecret**: `string`

Defined in: common/ChatMessage.ts:1364

The secret to access the thumbnail. A secret is required for verification for thumbnail download.

***

### thumbnailStatus

> **thumbnailStatus**: [`ChatDownloadStatus`](../enumerations/ChatDownloadStatus.md)

Defined in: common/ChatMessage.ts:1368

The download status of the thumbnail. See [ChatDownloadStatus](../enumerations/ChatDownloadStatus.md)

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

Defined in: common/ChatMessage.ts:1372

The image width in pixels.
