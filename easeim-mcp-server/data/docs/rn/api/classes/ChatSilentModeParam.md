[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatSilentModeParam

# Class: ChatSilentModeParam

Defined in: common/ChatSilentMode.ts:65

The parameter entity class for the offline message push.

## Constructors

### Constructor

> **new ChatSilentModeParam**(`params`): `ChatSilentModeParam`

Defined in: common/ChatSilentMode.ts:95

Constructs an object.

#### Parameters

##### params

###### duration?

`number`

###### endTime?

[`ChatSilentModeTime`](ChatSilentModeTime.md)

###### paramType

[`ChatSilentModeParamType`](../enumerations/ChatSilentModeParamType.md)

###### remindType?

[`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

###### startTime?

[`ChatSilentModeTime`](ChatSilentModeTime.md)

#### Returns

`ChatSilentModeParam`

## Properties

### duration?

> `optional` **duration**: `number`

Defined in: common/ChatSilentMode.ts:90

The duration of the do-not-disturb mode, in minutes.

***

### endTime?

> `optional` **endTime**: [`ChatSilentModeTime`](ChatSilentModeTime.md)

Defined in: common/ChatSilentMode.ts:86

The end time of do-not-disturb mode.
- Both the start time and end time need to be set.
- If both `hours` and `minutes` are set to `0` in the start time and end time, the Do Not Disturb mode is disabled.

***

### paramType

> **paramType**: [`ChatSilentModeParamType`](../enumerations/ChatSilentModeParamType.md)

Defined in: common/ChatSilentMode.ts:69

The parameter type of the do-not-disturb mode.

***

### remindType?

> `optional` **remindType**: [`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

Defined in: common/ChatSilentMode.ts:73

The push notification mode.

***

### startTime?

> `optional` **startTime**: [`ChatSilentModeTime`](ChatSilentModeTime.md)

Defined in: common/ChatSilentMode.ts:79

The start time of do-not-disturb mode.
- Both the start time and end time need to be set.
- If both `hours` and `minutes` are set to `0` in the start time and end time, the Do Not Disturb mode is disabled.

## Methods

### constructorWithDuration()

> `static` **constructorWithDuration**(`silentDuration`): `ChatSilentModeParam`

Defined in: common/ChatSilentMode.ts:130

Set the duration of the do-not-disturb mode for the offline message push.

#### Parameters

##### silentDuration

`number`

The duration of the do-not-disturb mode, in minutes.

#### Returns

`ChatSilentModeParam`

The ChatSilentModeParam object.

***

### constructorWithNotification()

> `static` **constructorWithNotification**(`remindType`): `ChatSilentModeParam`

Defined in: common/ChatSilentMode.ts:115

Sets the push notification mode.

#### Parameters

##### remindType

[`ChatPushRemindType`](../enumerations/ChatPushRemindType.md)

The push notification mode.

#### Returns

`ChatSilentModeParam`

The ChatSilentModeParam Object.

***

### constructorWithPeriod()

> `static` **constructorWithPeriod**(`params`): `ChatSilentModeParam`

Defined in: common/ChatSilentMode.ts:149

Sets the time frame of the do-not-disturb mode.

The time frame of the do-not-disturb mode is valid only at the app level, but not for conversations.

#### Parameters

##### params

###### endTime

[`ChatSilentModeTime`](ChatSilentModeTime.md)

###### startTime

[`ChatSilentModeTime`](ChatSilentModeTime.md)

#### Returns

`ChatSilentModeParam`

The ChatSilentModeParam object.

#### Params

params
- startTime: The start point in the do-not-disturb time frame.
- endTime: The end point in the do-not-disturb time frame.
