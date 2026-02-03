[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatPushManager

# Class: ChatPushManager

Defined in: ChatPushManager.ts:33

The class for message push configuration options.

## Extends

- `Native`

## Constructors

### Constructor

> **new ChatPushManager**(): `ChatPushManager`

Defined in: ChatPushManager.ts:35

#### Returns

`ChatPushManager`

#### Overrides

`Native.constructor`

## Methods

### fetchPreferredNotificationLanguage()

> **fetchPreferredNotificationLanguage**(): `Promise`\<`string` \| `undefined`\>

Defined in: ChatPushManager.ts:227

Gets the configured push translation language.

#### Returns

`Promise`\<`string` \| `undefined`\>

The language code.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchPushOptionFromServer()

> **fetchPushOptionFromServer**(): `Promise`\<[`ChatPushOption`](ChatPushOption.md)\>

Defined in: ChatPushManager.ts:286

Gets the push configurations from the server.

#### Returns

`Promise`\<[`ChatPushOption`](ChatPushOption.md)\>

The push options.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchSelectedPushTemplate()

> **fetchSelectedPushTemplate**(): `Promise`\<`string` \| `undefined`\>

Defined in: ChatPushManager.ts:319

Gets the selected push template for offline push.

#### Returns

`Promise`\<`string` \| `undefined`\>

The name of the selected push template.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchSilentModeForAll()

> **fetchSilentModeForAll**(): `Promise`\<[`ChatSilentModeResult`](ChatSilentModeResult.md)\>

Defined in: ChatPushManager.ts:161

Gets the do-not-disturb settings of the app.

#### Returns

`Promise`\<[`ChatSilentModeResult`](ChatSilentModeResult.md)\>

The do-not-disturb settings of the app.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchSilentModeForConversation()

> **fetchSilentModeForConversation**(`params`): `Promise`\<[`ChatSilentModeResult`](ChatSilentModeResult.md)\>

Defined in: ChatPushManager.ts:114

Gets the offline push settings of the conversation.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

#### Returns

`Promise`\<[`ChatSilentModeResult`](ChatSilentModeResult.md)\>

The offline push settings of the conversation.

#### Params

params
- convId: The conversation ID.
- convType: The conversation type.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### fetchSilentModeForConversations()

> **fetchSilentModeForConversations**(`conversations`): `Promise`\<`Map`\<`string`, [`ChatSilentModeResult`](ChatSilentModeResult.md)\>\>

Defined in: ChatPushManager.ts:177

Gets the do-not-disturb settings of the specified conversations.

#### Parameters

##### conversations

[`ChatConversation`](ChatConversation.md)[]

The conversation list.

#### Returns

`Promise`\<`Map`\<`string`, [`ChatSilentModeResult`](ChatSilentModeResult.md)\>\>

The do-not-disturb settings of the specified conversations, which are key-value pairs where the key is the conversation ID and the value is the do-not-disturb settings.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### removeSilentModeForConversation()

> **removeSilentModeForConversation**(`params`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:85

Clears the offline push settings of the conversation.

After clearing, the conversation uses the offline push settings of the app. See EMPushManager.setSilentModeForAll.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

#### Returns

`Promise`\<`void`\>

#### Params

params
- convId: The conversation ID.
- convType: The conversation type.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### selectPushTemplate()

> **selectPushTemplate**(`templateName`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:304

Selects the push template for offline push.

The push template can be set with a RESTful API or on the console.

#### Parameters

##### templateName

`string`

The push template name. If the template name does not exist, this template does not take effect, although no error is returned.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setNativeListener()

> **setNativeListener**(`_event`): `void`

Defined in: ChatPushManager.ts:39

#### Parameters

##### \_event

`NativeEventEmitter`

#### Returns

`void`

***

### setPreferredNotificationLanguage()

> **setPreferredNotificationLanguage**(`languageCode`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:205

Sets the target translation language of offline push notifications.

#### Parameters

##### languageCode

`string`

The language code. See [ChatTextMessageBody](ChatTextMessageBody.md).

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setSilentModeForAll()

> **setSilentModeForAll**(`option`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:141

Sets the offline push of the app.

#### Parameters

##### option

[`ChatSilentModeParam`](ChatSilentModeParam.md)

The offline push parameters.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### setSilentModeForConversation()

> **setSilentModeForConversation**(`params`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:53

Sets the offline push for the conversation.

#### Parameters

##### params

###### convId

`string`

###### convType

[`ChatConversationType`](../enumerations/ChatConversationType.md)

###### option

[`ChatSilentModeParam`](ChatSilentModeParam.md)

#### Returns

`Promise`\<`void`\>

#### Params

params
- convId: The conversation ID.
- convType: The conversation type.
- option: The configuration options for the offline push.

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updatePushDisplayStyle()

> **updatePushDisplayStyle**(`displayStyle`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:267

Updates the display style of push notifications.

The default value is [ChatPushDisplayStyle.Simple](../enumerations/ChatPushDisplayStyle.md#simple).

#### Parameters

##### displayStyle

[`ChatPushDisplayStyle`](../enumerations/ChatPushDisplayStyle.md) = `ChatPushDisplayStyle.Simple`

The display style of push notifications.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### updatePushNickname()

> **updatePushNickname**(`nickname`): `Promise`\<`void`\>

Defined in: ChatPushManager.ts:248

Updates nickname of the sender displayed in push notifications.

This nickname can be different from the nickname in the user profile; however, we recommend that you use the same nickname for both. Therefore, if either nickname is updated, the other should be changed at the same time.

To update the nickname in the user profile, you can call [ChatUserInfoManager.updateOwnUserInfo](ChatUserInfoManager.md#updateownuserinfo).

#### Parameters

##### nickname

`string`

The nickname of the sender displayed in push notifications.

#### Returns

`Promise`\<`void`\>

#### Throws

A description of the exception. See [ChatError](ChatError.md).

***

### \_callMethod()

> `protected` `static` **\_callMethod**\<`T`\>(`method`, `args?`): `Promise`\<`T`\>

Defined in: \_\_internal\_\_/Native.ts:14

#### Type Parameters

##### T

`T`

#### Parameters

##### method

`string`

##### args?

`Object`

#### Returns

`Promise`\<`T`\>

#### Inherited from

`Native._callMethod`

***

### checkErrorFromResult()

> `protected` `static` **checkErrorFromResult**(`result`): `void`

Defined in: \_\_internal\_\_/Native.ts:9

#### Parameters

##### result

`any`

#### Returns

`void`

#### Inherited from

`Native.checkErrorFromResult`
