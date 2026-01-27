[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatMultiDeviceEvent

# Enumeration: ChatMultiDeviceEvent

Defined in: ChatEvents.ts:20

The event types in multi-device login scenarios.

This class takes user A that uses both Device A1 and Device A2 as an example to describe when the various types of multi-device events are triggered.

## Enumeration Members

### CONTACT\_ACCEPT

> **CONTACT\_ACCEPT**: `3`

Defined in: ChatEvents.ts:28

If user A accepts a friend request on Device A1, this event is triggered on Device A2.

***

### CONTACT\_ALLOW

> **CONTACT\_ALLOW**: `6`

Defined in: ChatEvents.ts:40

If user A removes another user from the block list on Device A1, this event is triggered on Device A2.

***

### CONTACT\_BAN

> **CONTACT\_BAN**: `5`

Defined in: ChatEvents.ts:36

If user A adds another user to the block list on Device A1, this event is triggered on Device A2.

***

### CONTACT\_DECLINE

> **CONTACT\_DECLINE**: `4`

Defined in: ChatEvents.ts:32

If user A declines a friend request on Device A1, this event is triggered on Device A2.

***

### CONTACT\_REMOVE

> **CONTACT\_REMOVE**: `2`

Defined in: ChatEvents.ts:24

If user A deletes a contact on Device A1, this event is triggered on Device A2.

***

### CONVERSATION\_DELETED

> **CONVERSATION\_DELETED**: `62`

Defined in: ChatEvents.ts:180

If user A deletes a conversation on device A1, this event is triggered on device A2.

***

### CONVERSATION\_MUTE\_CHANGED

> **CONVERSATION\_MUTE\_CHANGED**: `64`

Defined in: ChatEvents.ts:190

If user A mutes a conversation on device A1, this event is triggered on device A2.

Upon receiving this event, the system will automatically update the push mode information of the conversation. You need to call the corresponding method to update the conversation.

***

### CONVERSATION\_PINNED

> **CONVERSATION\_PINNED**: `60`

Defined in: ChatEvents.ts:172

If user A pins a conversation on device A1, this event is triggered on device A2.

***

### CONVERSATION\_UNPINNED

> **CONVERSATION\_UNPINNED**: `61`

Defined in: ChatEvents.ts:176

If user A unpins a conversation on device A1, this event is triggered on device A2.

***

### CONVERSATION\_UPDATE\_MARK

> **CONVERSATION\_UPDATE\_MARK**: `63`

Defined in: ChatEvents.ts:184

If user A updates a conversation mark on device A1, this event is triggered on device A2.

***

### GROUP\_ADD\_ADMIN

> **GROUP\_ADD\_ADMIN**: `26`

Defined in: ChatEvents.ts:109

If user A adds a group admin on Device A1, this event is triggered on Device A2.

***

### GROUP\_ADD\_MUTE

> **GROUP\_ADD\_MUTE**: `28`

Defined in: ChatEvents.ts:117

If user A mutes a group member on Device A1, this event is triggered on Device A2.

***

### GROUP\_ADD\_USER\_ALLOW\_LIST

> **GROUP\_ADD\_USER\_ALLOW\_LIST**: `30`

Defined in: ChatEvents.ts:125

If user A adds other members to the allow list of the chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_ALL\_BAN

> **GROUP\_ALL\_BAN**: `32`

Defined in: ChatEvents.ts:134

If user A mutes all chat group members on Device A1, this event is triggered on Device A2.

***

### GROUP\_ALLOW

> **GROUP\_ALLOW**: `22`

Defined in: ChatEvents.ts:93

If user A removes a member from a group block list on Device A1, this event is triggered on Device A2.

***

### GROUP\_APPLY

> **GROUP\_APPLY**: `14`

Defined in: ChatEvents.ts:61

If user A requests to join a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_APPLY\_ACCEPT

> **GROUP\_APPLY\_ACCEPT**: `15`

Defined in: ChatEvents.ts:65

If user A accepts a request to join the chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_APPLY\_DECLINE

> **GROUP\_APPLY\_DECLINE**: `16`

Defined in: ChatEvents.ts:69

If user A declines a request to join the chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_ASSIGN\_OWNER

> **GROUP\_ASSIGN\_OWNER**: `25`

Defined in: ChatEvents.ts:105

If user A transfers the group ownership on Device A1, this event is triggered on Device A2.

***

### GROUP\_BAN

> **GROUP\_BAN**: `21`

Defined in: ChatEvents.ts:89

If user A adds a member to a group block list on Device A1, this event is triggered on Device A2.

***

### GROUP\_BLOCK

> **GROUP\_BLOCK**: `23`

Defined in: ChatEvents.ts:97

If user A blocks messages from a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_CREATE

> **GROUP\_CREATE**: `10`

Defined in: ChatEvents.ts:45

If user A creates a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_DESTROY

> **GROUP\_DESTROY**: `11`

Defined in: ChatEvents.ts:49

If user A destroys a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_INVITE

> **GROUP\_INVITE**: `17`

Defined in: ChatEvents.ts:73

If user A invites a user to join the chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_INVITE\_ACCEPT

> **GROUP\_INVITE\_ACCEPT**: `18`

Defined in: ChatEvents.ts:77

If user A accepts a group invitation on Device A1, this event is triggered on Device A2.

***

### GROUP\_INVITE\_DECLINE

> **GROUP\_INVITE\_DECLINE**: `19`

Defined in: ChatEvents.ts:81

If user A declines a group invitation on Device A1, this event is triggered on Device A2.

***

### GROUP\_JOIN

> **GROUP\_JOIN**: `12`

Defined in: ChatEvents.ts:53

If user A joins a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_KICK

> **GROUP\_KICK**: `20`

Defined in: ChatEvents.ts:85

If user A removes a user from a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_LEAVE

> **GROUP\_LEAVE**: `13`

Defined in: ChatEvents.ts:57

If user A leaves a chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_METADATA\_CHANGED

> **GROUP\_METADATA\_CHANGED**: `52`

Defined in: ChatEvents.ts:168

The current user modified custom attributes of a group member on another device.

***

### GROUP\_REMOVE\_ADMIN

> **GROUP\_REMOVE\_ADMIN**: `27`

Defined in: ChatEvents.ts:113

If user A removes a group admin on Device A1, this event is triggered on Device A2.

***

### GROUP\_REMOVE\_ALL\_BAN

> **GROUP\_REMOVE\_ALL\_BAN**: `33`

Defined in: ChatEvents.ts:140

If user A unmutes all chat group members on Device A1, this event is triggered on Device A2.

Even if all chat group members are unmuted, members on the mute list still cannot send messages in the group.

***

### GROUP\_REMOVE\_MUTE

> **GROUP\_REMOVE\_MUTE**: `29`

Defined in: ChatEvents.ts:121

If user A unmutes a group member on Device A1, this event is triggered on Device A2.

***

### GROUP\_REMOVE\_USER\_ALLOW\_LIST

> **GROUP\_REMOVE\_USER\_ALLOW\_LIST**: `31`

Defined in: ChatEvents.ts:129

If user A removes other members from the allow list of the chat group on Device A1, this event is triggered on Device A2.

***

### GROUP\_UNBLOCK

> **GROUP\_UNBLOCK**: `24`

Defined in: ChatEvents.ts:101

If user A unblocks messages from a chat group on Device A1, this event is triggered on Device A2.

***

### THREAD\_CREATE

> **THREAD\_CREATE**: `40`

Defined in: ChatEvents.ts:144

If user A creates a message thread on Device A1, this event is triggered on Device A2.

***

### THREAD\_DESTROY

> **THREAD\_DESTROY**: `41`

Defined in: ChatEvents.ts:148

If user A destroys a message thread on Device A1, this event is triggered on Device A2.

***

### THREAD\_JOIN

> **THREAD\_JOIN**: `42`

Defined in: ChatEvents.ts:152

If user A joins a message thread on Device A1, this event is triggered on Device A2.

***

### THREAD\_KICK

> **THREAD\_KICK**: `45`

Defined in: ChatEvents.ts:164

If user A kicks a user from a message thread on Device A1, this event is triggered on Device A2.

***

### THREAD\_LEAVE

> **THREAD\_LEAVE**: `43`

Defined in: ChatEvents.ts:156

If user A leaves a message thread on Device A1, this event is triggered on Device A2.

***

### THREAD\_UPDATE

> **THREAD\_UPDATE**: `44`

Defined in: ChatEvents.ts:160

If user A updates the message thread name, or sends or recalls a message in thread on Device A1, this event is triggered on Device A2.
