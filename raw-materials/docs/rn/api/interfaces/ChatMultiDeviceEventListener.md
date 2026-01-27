[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMultiDeviceEventListener

# Interface: ChatMultiDeviceEventListener

Defined in: ChatEvents.ts:455

The multi-device event listener.

The listener listens for the actions of the current user on other devices, including contact events, group events, thread events, and conversation events.

## Methods

### onContactEvent()?

> `optional` **onContactEvent**(`event?`, `target?`, `ext?`): `void`

Defined in: ChatEvents.ts:463

Occurs when a contact event occurs.

#### Parameters

##### event?

[`ChatMultiDeviceEvent`](../enumerations/ChatMultiDeviceEvent.md)

The event type.

##### target?

`string`

The user ID.

##### ext?

`string`

The extension of user information.

#### Returns

`void`

***

### onConversationEvent()?

> `optional` **onConversationEvent**(`event?`, `convId?`, `convType?`): `void`

Defined in: ChatEvents.ts:510

Occurs when a conversation event occurs.

#### Parameters

##### event?

[`ChatMultiDeviceEvent`](../enumerations/ChatMultiDeviceEvent.md)

The event type.

##### convId?

`string`

The conversation ID.

##### convType?

[`ChatConversationType`](../enumerations/ChatConversationType.md)

The conversation type.

#### Returns

`void`

***

### onGroupEvent()?

> `optional` **onGroupEvent**(`event?`, `target?`, `usernames?`): `void`

Defined in: ChatEvents.ts:476

Occurs when a group event occurs.

#### Parameters

##### event?

[`ChatMultiDeviceEvent`](../enumerations/ChatMultiDeviceEvent.md)

The event type.

##### target?

`string`

The group ID.

##### usernames?

`string`[]

The array of user IDs.

#### Returns

`void`

***

### onMessageRemoved()?

> `optional` **onMessageRemoved**(`convId?`, `deviceId?`): `void`

Defined in: ChatEvents.ts:501

Callback to other devices after conversation deleted message from server after enabling multiple devices.

#### Parameters

##### convId?

`string`

The conversation ID.

##### deviceId?

`string`

The device ID.

#### Returns

`void`

***

### onThreadEvent()?

> `optional` **onThreadEvent**(`event?`, `target?`, `usernames?`): `void`

Defined in: ChatEvents.ts:489

Occurs when a thread event occurs.

#### Parameters

##### event?

[`ChatMultiDeviceEvent`](../enumerations/ChatMultiDeviceEvent.md)

The event type.

##### target?

`string`

The group ID.

##### usernames?

`string`[]

The array of user IDs.

#### Returns

`void`
