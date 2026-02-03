[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatSearchDirection

# Enumeration: ChatSearchDirection

Defined in: common/ChatConversation.ts:20

The message search directions.

The message search is based on the Unix timestamp included in messages. Each message contains two Unix timestamps:
   - The Unix timestamp when the message is created;
   - The Unix timestamp when the message is received by the server.

Which Unix timestamp is used for message search depends on the setting of [ChatOptions.sortMessageByServerTime](../classes/ChatOptions.md#sortmessagebyservertime).

## Enumeration Members

### DOWN

> **DOWN**: `1`

Defined in: common/ChatConversation.ts:30

Messages are retrieved in the ascending order of the timestamp included in them.

***

### UP

> **UP**: `0`

Defined in: common/ChatConversation.ts:25

Messages are retrieved in the descending order of the timestamp included in them.
