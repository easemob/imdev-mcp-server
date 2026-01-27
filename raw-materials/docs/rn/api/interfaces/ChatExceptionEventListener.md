[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatExceptionEventListener

# Interface: ChatExceptionEventListener

Defined in: ChatEvents.ts:1283

## Methods

### onExcept()

> **onExcept**(`params`): `void`

Defined in: ChatEvents.ts:1292

When an internal except occurs, this callback notification is triggered.

#### Parameters

##### params

###### except

[`ChatException`](../classes/ChatException.md)

###### extra?

`Record`\<`string`, `string`\>

###### from?

`string`

#### Returns

`void`

#### Params

-
- Param [except] The except object.
- Param [from] Where the except occurred.
- Param [extra] The extra information.
