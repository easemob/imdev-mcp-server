[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatGroupStyle

# Enumeration: ChatGroupStyle

Defined in: common/ChatGroup.ts:6

The group types.

## Enumeration Members

### PrivateMemberCanInvite

> **PrivateMemberCanInvite**: `1`

Defined in: common/ChatGroup.ts:14

Private groups where each group member can invite users to join.

***

### PrivateOnlyOwnerInvite

> **PrivateOnlyOwnerInvite**: `0`

Defined in: common/ChatGroup.ts:10

Private groups where only the group owner or admins can invite users to join.

***

### PublicJoinNeedApproval

> **PublicJoinNeedApproval**: `2`

Defined in: common/ChatGroup.ts:18

Public groups where users can join only after an invitation is received from the group owner(admin) or the join request is accepted by the  group owner(admin).

***

### PublicOpenJoin

> **PublicOpenJoin**: `3`

Defined in: common/ChatGroup.ts:22

Public groups where users can join freely, without the approval of the group owner or admins.
