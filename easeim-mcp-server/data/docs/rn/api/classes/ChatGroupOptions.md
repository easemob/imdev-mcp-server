[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupOptions

# Class: ChatGroupOptions

Defined in: common/ChatGroup.ts:279

The group options to be configured when the chat group is created.

## Constructors

### Constructor

> **new ChatGroupOptions**(`params`): `ChatGroupOptions`

Defined in: common/ChatGroup.ts:317

Construct a group option.

#### Parameters

##### params

###### ext?

`string`

###### inviteNeedConfirm?

`boolean`

###### isDisabled?

`boolean`

###### maxCount?

`number`

###### style?

`number`

#### Returns

`ChatGroupOptions`

## Properties

### ext?

> `optional` **ext**: `string`

Defined in: common/ChatGroup.ts:307

The group extension information.

***

### inviteNeedConfirm

> **inviteNeedConfirm**: `boolean`

Defined in: common/ChatGroup.ts:303

Whether to ask for consent when inviting a user to join a group.

Whether to automatically accept the invitation to join a group depends on two settings:

- GroupOptions.inviteNeedConfirm, an option for group creation.
- [ChatOptions.autoAcceptGroupInvitation](ChatOptions.md#autoacceptgroupinvitation): Determines whether to automatically accept an invitation to join the group.

There are two cases:
- If `inviteNeedConfirm` is set to `false`, the SDK adds the invitee directly to the group on the server side, regardless of the setting of [ChatOptions.autoAcceptGroupInvitation](ChatOptions.md#autoacceptgroupinvitation) on the invitee side.
- If `inviteNeedConfirm` is set to `true`, whether the invitee automatically joins the chat group or not depends on the settings of [ChatOptions.autoAcceptGroupInvitation](ChatOptions.md#autoacceptgroupinvitation).

[ChatOptions.autoAcceptGroupInvitation](ChatOptions.md#autoacceptgroupinvitation) is an SDK-level operation. If it is set to `true`, the invitee automatically joins the chat group; if it is set to `false`, the invitee can manually accept or decline the group invitation instead of joining the group automatically.

***

### isDisabled

> **isDisabled**: `boolean`

Defined in: common/ChatGroup.ts:313

Whether the group is disabled:
- `true`: Yes.
- `false`: No.

***

### maxCount

> **maxCount**: `number`

Defined in: common/ChatGroup.ts:287

The maximum number of members allowed in a group.

***

### style

> **style**: [`ChatGroupStyle`](../enumerations/ChatGroupStyle.md)

Defined in: common/ChatGroup.ts:283

The group style.
