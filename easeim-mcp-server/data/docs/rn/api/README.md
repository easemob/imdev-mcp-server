**react-native-chat-sdk**

***

ChatSDK is a highly reliable global communication platform where your users can chat one-to-one, in groups or in chat rooms. Users communicate with text messages, share images, audios, videos, files, emojis, and locations. ChatSDK supplies typing indicators out-of-the-box.

- The ChatClient class is the entry of the chat SDK. It provides methods to allow you to log in to and log out of the chat app and manage the connection between the SDK and the chat server.
- The ChatManager class provides methods to allow you to send and receive messages, manage conversations , and download attachments.
- The ChatMessage class defines message attributes .
- The ChatConversation class provides methods for conversation management.
- The ChatContactManager class provides methods for chat contact management such as adding, retrieving, modifying, and deleting contacts.
- The ChatGroupManager class provides methods for group management, like group creation and destruction and member management.
- The ChatRoomManager class provides methods for chat room management, like joining and leaving the chat room and retrieving the chat room list, and manages member privileges.
- The ChatPresenceManager class provides methods for you to set message push configuration options.
- The ChatPushManager class provides methods to allow you to manage offline push services.
- The ChatUserInfoManager class provides methods for user attribute management, including getting and updating user attributes.

## ChatClient
| Method | Description |
| :----- | :---------- |
| [getInstance](classes/ChatClient.md#getinstance) | The chat client class, which is the entry of the chat SDK. It defines how to log in to and log out of the chat app and how to manage the connection between the SDK and the chat server. |
| [getEventEmitter](classes/ChatClient.md#geteventemitter) | The chat client class, which is the entry of the chat SDK. It defines how to log in to and log out of the chat app and how to manage the connection between the SDK and the chat server. |
| [setNativeListener](classes/ChatClient.md#setnativelistener) | The chat client class, which is the entry of the chat SDK. It defines how to log in to and log out of the chat app and how to manage the connection between the SDK and the chat server. |
| [version](classes/ChatClient.md#version) | The chat client class, which is the entry of the chat SDK. It defines how to log in to and log out of the chat app and how to manage the connection between the SDK and the chat server. |
| [options](classes/ChatClient.md#options) | Gets the SDK configurations. |
| [currentUserName](classes/ChatClient.md#currentusername) | Gets the current logged-in user ID. |
| [init](classes/ChatClient.md#init) | Initializes the SDK. |
| [isConnected](classes/ChatClient.md#isconnected) | Checks whether the SDK is connected to the chat server. |
| [getCurrentUsername](classes/ChatClient.md#getcurrentusername) | Gets the current logged-in user ID from the server. |
| [isLoginBefore](classes/ChatClient.md#isloginbefore) | Checks whether the current user is logged in to the app. |
| [getAccessToken](classes/ChatClient.md#getaccesstoken) | Gets the token for login. |
| [createAccount](classes/ChatClient.md#createaccount) | Creates a new user (open registration). |
| [login](classes/ChatClient.md#login) | Logs in to the chat server with a password or an Easemob token. An exception message is thrown if the login fails. |
| [loginWithToken](classes/ChatClient.md#loginwithtoken) | Logs in to the chat server with a token. An exception message is thrown if the login fails. |
| [loginWithAgoraToken](classes/ChatClient.md#loginwithagoratoken) | @deprecated 2023-11-17 Use  login instead. |
| [renewAgoraToken](classes/ChatClient.md#renewagoratoken) | Renews the Agora token. |
| [logout](classes/ChatClient.md#logout) | Logs out of the chat app. An exception message is thrown if the logout fails. |
| [changeAppKey](classes/ChatClient.md#changeappkey) | Updates the App Key, which is the unique identifier used to access the chat service. |
| [changeAppId](classes/ChatClient.md#changeappid) | Updates the App id, which is the unique identifier used to access the chat service. |
| [compressLogs](classes/ChatClient.md#compresslogs) | Compresses the debug log file into a gzip archive. |
| [getLoggedInDevicesFromServer](classes/ChatClient.md#getloggedindevicesfromserver) | Gets the list of online devices to which you have logged in with a specified account. |
| [kickDevice](classes/ChatClient.md#kickdevice) | Logs out from a specified account on a device. |
| [kickAllDevices](classes/ChatClient.md#kickalldevices) | Logs out from a specified account on all devices. |
| [updatePushConfig](classes/ChatClient.md#updatepushconfig) | Update push configurations. |
| [getRTCTokenInfoWithChannelName](classes/ChatClient.md#getrtctokeninfowithchannelname) | Gets the Agora RTC token, token expiration time, and RTC UID matching the Agora Chat user ID according to the channel name (channelName). |
| [getUserIdsWithRTCUids](classes/ChatClient.md#getuseridswithrtcuids) | Gets the Agora Chat user IDs matching the Agora RTC UIDs. |
| [addConnectionListener](classes/ChatClient.md#addconnectionlistener) | Adds the connection status listener. |
| [removeConnectionListener](classes/ChatClient.md#removeconnectionlistener) | Removes the connection status listener. |
| [removeAllConnectionListener](classes/ChatClient.md#removeallconnectionlistener) | Removes all the connection status listeners for the chat server. |
| [addMultiDeviceListener](classes/ChatClient.md#addmultidevicelistener) | Adds the multi-device listener. |
| [removeMultiDeviceListener](classes/ChatClient.md#removemultidevicelistener) | Removes the specified multi-device listener. |
| [removeAllMultiDeviceListener](classes/ChatClient.md#removeallmultidevicelistener) | Removes all the multi-device listeners. |
| [addCustomListener](classes/ChatClient.md#addcustomlistener) | Adds a custom listener to receive data that the iOS or Android devices send to the React Native layer. |
| [removeCustomListener](classes/ChatClient.md#removecustomlistener) | Removes a custom listener to stop receiving data that the iOS or Android devices send to the React Native layer. |
| [removeAllCustomListener](classes/ChatClient.md#removeallcustomlistener) | Removes all the custom listeners. |
| [addExceptListener](classes/ChatClient.md#addexceptlistener) | Add error listener. |
| [removeExceptListener](classes/ChatClient.md#removeexceptlistener) | Remove error listener. |
| [removeAllExceptListener](classes/ChatClient.md#removeallexceptlistener) | Remove all error listener. |
| [chatManager](classes/ChatClient.md#chatmanager) | Gets the chat manager class. |
| [groupManager](classes/ChatClient.md#groupmanager) | Gets the chat group manager class. |
| [contactManager](classes/ChatClient.md#contactmanager) | Gets the contact manager class. |
| [pushManager](classes/ChatClient.md#pushmanager) | Gets the push manager class. |
| [userManager](classes/ChatClient.md#usermanager) | Gets the user information manager class. |
| [roomManager](classes/ChatClient.md#roommanager) | Gets the chat room manager class. |
| [presenceManager](classes/ChatClient.md#presencemanager) | Gets the presence manager class. |

| Event | Description |
| :----- | :---------- |
| [onConnected](interfaces/ChatConnectEventListener.md#onconnected) | Occurs when the SDK connects to the chat server successfully. |
| [onDisconnected](interfaces/ChatConnectEventListener.md#ondisconnected) | Occurs when the SDK disconnects from the chat server. |
| [onTokenWillExpire](interfaces/ChatConnectEventListener.md#ontokenwillexpire) | Occurs when the token is about to expire. |
| [onTokenDidExpire](interfaces/ChatConnectEventListener.md#ontokendidexpire) | Occurs when the token has expired. |
| [onAppActiveNumberReachLimit](interfaces/ChatConnectEventListener.md#onappactivenumberreachlimit) | The number of daily active users (DAU) or monthly active users (MAU) for the app has reached the upper limit. |
| [onOfflineMessageSyncStart](interfaces/ChatConnectEventListener.md#onofflinemessagesyncstart) | Callback invoked when the synchronization of offline messages starts. |
| [onOfflineMessageSyncFinish](interfaces/ChatConnectEventListener.md#onofflinemessagesyncfinish) | Callback invoked when the synchronization of offline messages finishes. |
| [onUserDidLoginFromOtherDevice](interfaces/ChatConnectEventListener.md#onuserdidloginfromotherdevice) | Occurs when the current user account is logged in to another device. |
| [onUserDidLoginFromOtherDeviceWithInfo](interfaces/ChatConnectEventListener.md#onuserdidloginfromotherdevicewithinfo) | Occurs when the current user account is logged in to another device. |
| [onUserDidRemoveFromServer](interfaces/ChatConnectEventListener.md#onuserdidremovefromserver) | Occurs when the current chat user is removed from the server. |
| [onUserDidForbidByServer](interfaces/ChatConnectEventListener.md#onuserdidforbidbyserver) | Occurs when the current chat user is banned from accessing the server. |
| [onUserDidChangePassword](interfaces/ChatConnectEventListener.md#onuserdidchangepassword) | Occurs when the current chat user changed the password. |
| [onUserDidLoginTooManyDevice](interfaces/ChatConnectEventListener.md#onuserdidlogintoomanydevice) | Occurs when the current chat user logged in to many devices. |
| [onUserKickedByOtherDevice](interfaces/ChatConnectEventListener.md#onuserkickedbyotherdevice) | Occurs when the current chat user is kicked out of the app by another device. |
| [onUserAuthenticationFailed](interfaces/ChatConnectEventListener.md#onuserauthenticationfailed) | Occurs when the current chat user authentication failed. |

| Event | Description |
| :----- | :---------- |
| [onContactEvent](interfaces/ChatMultiDeviceEventListener.md#oncontactevent) | Occurs when a contact event occurs. |
| [onGroupEvent](interfaces/ChatMultiDeviceEventListener.md#ongroupevent) | Occurs when a group event occurs. |
| [onThreadEvent](interfaces/ChatMultiDeviceEventListener.md#onthreadevent) | Occurs when a thread event occurs. |
| [onMessageRemoved](interfaces/ChatMultiDeviceEventListener.md#onmessageremoved) | Callback to other devices after conversation deleted message from server after enabling multiple devices. |
| [onConversationEvent](interfaces/ChatMultiDeviceEventListener.md#onconversationevent) | Occurs when a conversation event occurs. |

| Event | Description |
| :----- | :---------- |
| [onDataReceived](interfaces/ChatCustomEventListener.md#ondatareceived) | The custom event listener. |
## ChatManager
| Method | Description |
| :----- | :---------- |
| [setNativeListener](classes/ChatManager.md#setnativelistener) | The chat manager class, responsible for sending and receiving messages, managing conversations (including loading and deleting conversations), and downloading attachments. |
| [addMessageListener](classes/ChatManager.md#addmessagelistener) | Adds a message listener. |
| [removeMessageListener](classes/ChatManager.md#removemessagelistener) | Removes the message listener. |
| [removeAllMessageListener](classes/ChatManager.md#removeallmessagelistener) | Removes all message listeners. |
| [sendMessage](classes/ChatManager.md#sendmessage) | Sends a message. |
| [resendMessage](classes/ChatManager.md#resendmessage) | Resends a message. |
| [sendMessageReadAck](classes/ChatManager.md#sendmessagereadack) | Sends the read receipt to the server. |
| [sendGroupMessageReadAck](classes/ChatManager.md#sendgroupmessagereadack) | Sends the group message receipt to the server. |
| [sendConversationReadAck](classes/ChatManager.md#sendconversationreadack) | Sends the conversation read receipt to the server. |
| [recallMessage](classes/ChatManager.md#recallmessage) | For a one-to-one chat conversation, only the message sender can recall the message that is sent successfully. If the message expires, the recall fails. |
| [getMessage](classes/ChatManager.md#getmessage) | Gets a message from the local database by message ID. |
| [getMessagesWithIds](classes/ChatManager.md#getmessageswithids) | Gets messages with the specified IDs from the local database. |
| [markAllConversationsAsRead](classes/ChatManager.md#markallconversationsasread) | Marks all conversations as read. |
| [getUnreadCount](classes/ChatManager.md#getunreadcount) | Gets the count of the unread messages. |
| [insertMessage](classes/ChatManager.md#insertmessage) | Inserts a message to the conversation in the local database. |
| [updateMessage](classes/ChatManager.md#updatemessage) | Updates the local message. |
| [importMessages](classes/ChatManager.md#importmessages) | Imports messages to the local database. |
| [downloadAttachmentInCombine](classes/ChatManager.md#downloadattachmentincombine) | Downloads the message attachment. |
| [downloadThumbnailInCombine](classes/ChatManager.md#downloadthumbnailincombine) | Downloads the message thumbnail. |
| [downloadAttachment](classes/ChatManager.md#downloadattachment) | Downloads the message attachment. |
| [downloadThumbnail](classes/ChatManager.md#downloadthumbnail) | Downloads the message thumbnail. |
| [fetchHistoryMessages](classes/ChatManager.md#fetchhistorymessages) | Uses the pagination to get messages in the specified conversation from the server. |
| [fetchHistoryMessagesByOptions](classes/ChatManager.md#fetchhistorymessagesbyoptions) | retrieve the history message for the specified session from the server. |
| [searchMsgFromDB](classes/ChatManager.md#searchmsgfromdb) | Retrieves messages with keywords in a conversation from the local database. |
| [getMsgsWithKeyword](classes/ChatManager.md#getmsgswithkeyword) | Retrieves messages with keywords from the local database. |
| [getConvsMsgsWithKeyword](classes/ChatManager.md#getconvsmsgswithkeyword) | Loads messages with the specified keyword from the local database, returning a dictionary containing conversation IDs and message ID arrays. |
| [fetchGroupAcks](classes/ChatManager.md#fetchgroupacks) | Uses the pagination to get read receipts for group messages from the server. |
| [removeConversationFromServer](classes/ChatManager.md#removeconversationfromserver) | Deletes the specified conversation and its historical messages from the server. |
| [getConversation](classes/ChatManager.md#getconversation) | Gets the conversation by conversation ID and conversation type. |
| [getAllConversations](classes/ChatManager.md#getallconversations) | Gets all conversations from the local database. |
| [fetchAllConversations](classes/ChatManager.md#fetchallconversations) | @deprecated 2023-07-24 Use  fetchConversationsFromServerWithCursor instead. |
| [deleteConversation](classes/ChatManager.md#deleteconversation) | Deletes a conversation and its local messages from the local database. |
| [getLatestMessage](classes/ChatManager.md#getlatestmessage) | Gets the latest message from the conversation. |
| [getLatestReceivedMessage](classes/ChatManager.md#getlatestreceivedmessage) | Gets the latest received message from the conversation. |
| [getConversationUnreadCount](classes/ChatManager.md#getconversationunreadcount) | Gets the unread message count of the conversation. |
| [getConversationMessageCount](classes/ChatManager.md#getconversationmessagecount) | Gets the message count of the conversation. |
| [markMessageAsRead](classes/ChatManager.md#markmessageasread) | Marks a message as read. |
| [markAllMessagesAsRead](classes/ChatManager.md#markallmessagesasread) | Marks all messages as read. |
| [updateConversationMessage](classes/ChatManager.md#updateconversationmessage) | Updates a message in the local database. |
| [deleteMessage](classes/ChatManager.md#deletemessage) | Deletes a message from the local database. |
| [deleteMessagesWithTimestamp](classes/ChatManager.md#deletemessageswithtimestamp) | Deletes messages sent or received in a certain period from the local database. |
| [deleteConversationAllMessages](classes/ChatManager.md#deleteconversationallmessages) | Deletes all messages in the conversation from both the memory and local database. |
| [deleteMessagesBeforeTimestamp](classes/ChatManager.md#deletemessagesbeforetimestamp) | Deletes local messages with timestamp that is before the specified one. |
| [getMessagesWithMsgType](classes/ChatManager.md#getmessageswithmsgtype) | Retrieves messages of a certain type in a conversation from the local database. |
| [getMsgsWithMsgType](classes/ChatManager.md#getmsgswithmsgtype) | Retrieves messages of a certain type in the conversation from the local database. |
| [getMessages](classes/ChatManager.md#getmessages) | Retrieves messages of a specified quantity in a conversation from the local database. |
| [getMsgs](classes/ChatManager.md#getmsgs) | Retrieves messages of a specified quantity in a conversation from the local database. |
| [getMessagesWithKeyword](classes/ChatManager.md#getmessageswithkeyword) | Gets messages that the specified user sends in a conversation in a certain period. |
| [getConvMsgsWithKeyword](classes/ChatManager.md#getconvmsgswithkeyword) | Gets messages that the specified user sends in a conversation in a certain period. |
| [getMessageWithTimestamp](classes/ChatManager.md#getmessagewithtimestamp) | Retrieves messages that are sent and received in a certain period in a conversation in the local database. |
| [getMsgWithTimestamp](classes/ChatManager.md#getmsgwithtimestamp) | Retrieves messages that are sent and received in a certain period in a conversation in the local database. |
| [translateMessage](classes/ChatManager.md#translatemessage) | Translates a text message. |
| [fetchSupportedLanguages](classes/ChatManager.md#fetchsupportedlanguages) | Gets all languages supported by the translation service. |
| [setConversationExtension](classes/ChatManager.md#setconversationextension) | Sets the extension information of the conversation. |
| [addReaction](classes/ChatManager.md#addreaction) | Adds a Reaction. |
| [removeReaction](classes/ChatManager.md#removereaction) | Deletes a Reaction. |
| [fetchReactionList](classes/ChatManager.md#fetchreactionlist) | Gets the list of Reactions. |
| [fetchReactionDetail](classes/ChatManager.md#fetchreactiondetail) | Gets the Reaction details. |
| [reportMessage](classes/ChatManager.md#reportmessage) | Reports an inappropriate message. |
| [getReactionList](classes/ChatManager.md#getreactionlist) | Gets the list of Reactions from a message. |
| [groupAckCount](classes/ChatManager.md#groupackcount) | Gets the number of members that have read the group message. |
| [createChatThread](classes/ChatManager.md#createchatthread) | Creates a message thread. |
| [joinChatThread](classes/ChatManager.md#joinchatthread) | Joins a message thread. |
| [leaveChatThread](classes/ChatManager.md#leavechatthread) | Leaves a message thread. |
| [destroyChatThread](classes/ChatManager.md#destroychatthread) | Destroys the message thread. |
| [updateChatThreadName](classes/ChatManager.md#updatechatthreadname) | Changes the name of the message thread. |
| [removeMemberWithChatThread](classes/ChatManager.md#removememberwithchatthread) | Removes a member from the message thread. |
| [fetchMembersWithChatThreadFromServer](classes/ChatManager.md#fetchmemberswithchatthreadfromserver) | Uses the pagination to get a list of members in the message thread. |
| [fetchJoinedChatThreadFromServer](classes/ChatManager.md#fetchjoinedchatthreadfromserver) | Uses the pagination to get the list of message threads that the current user has joined. |
| [fetchJoinedChatThreadWithParentFromServer](classes/ChatManager.md#fetchjoinedchatthreadwithparentfromserver) | Uses the pagination to get the list of message threads that the current user has joined in the specified group. |
| [fetchChatThreadWithParentFromServer](classes/ChatManager.md#fetchchatthreadwithparentfromserver) | Uses the pagination to get the list of message threads in the specified group. |
| [fetchLastMessageWithChatThread](classes/ChatManager.md#fetchlastmessagewithchatthread) | Gets the last reply in the specified message threads from the server. |
| [fetchChatThreadFromServer](classes/ChatManager.md#fetchchatthreadfromserver) | Gets the details of the message thread from the server. |
| [getMessageThread](classes/ChatManager.md#getmessagethread) | Gets the details of the message thread from the memory. |
| [getThreadConversation](classes/ChatManager.md#getthreadconversation) | Gets the thread conversation by conversation ID. |
| [fetchConversationsFromServerWithPage](classes/ChatManager.md#fetchconversationsfromserverwithpage) | Gets conversations from the server with pagination. |
| [removeMessagesFromServerWithMsgIds](classes/ChatManager.md#removemessagesfromserverwithmsgids) | Deletes messages from the conversation (from both local storage and server). |
| [removeMessagesFromServerWithTimestamp](classes/ChatManager.md#removemessagesfromserverwithtimestamp) | Deletes messages from the conversation (from both local storage and server). |
| [fetchConversationsFromServerWithCursor](classes/ChatManager.md#fetchconversationsfromserverwithcursor) | Gets the list of conversations from the server with pagination. |
| [fetchPinnedConversationsFromServerWithCursor](classes/ChatManager.md#fetchpinnedconversationsfromserverwithcursor) | Get the list of pinned conversations from the server with pagination. |
| [pinConversation](classes/ChatManager.md#pinconversation) | Sets whether to pin a conversation. |
| [modifyMessageBody](classes/ChatManager.md#modifymessagebody) | Modifies a message. |
| [modifyMsgBody](classes/ChatManager.md#modifymsgbody) | Modifies a message both in the local storage and server. |
| [fetchCombineMessageDetail](classes/ChatManager.md#fetchcombinemessagedetail) | Gets the list of original messages included in a combined message. |
| [addRemoteAndLocalConversationsMark](classes/ChatManager.md#addremoteandlocalconversationsmark) | Marks conversations. |
| [deleteRemoteAndLocalConversationsMark](classes/ChatManager.md#deleteremoteandlocalconversationsmark) | Unmarks conversations. |
| [fetchConversationsByOptions](classes/ChatManager.md#fetchconversationsbyoptions) | Gets the conversations from the server by conversation filter options. |
| [deleteAllMessageAndConversation](classes/ChatManager.md#deleteallmessageandconversation) | Clears all conversations and all messages in them. |
| [pinMessage](classes/ChatManager.md#pinmessage) | Pins a message. |
| [unpinMessage](classes/ChatManager.md#unpinmessage) | Unpins a message. |
| [fetchPinnedMessages](classes/ChatManager.md#fetchpinnedmessages) | Gets the list of pinned messages in the conversation from the server. |
| [getPinnedMessages](classes/ChatManager.md#getpinnedmessages) | Gets the pinned messages in a local conversation. |
| [getMessagePinInfo](classes/ChatManager.md#getmessagepininfo) | Gets the pinning information of a message. |
| [searchMessages](classes/ChatManager.md#searchmessages) | Searches for messages. |
| [searchMessagesInConversation](classes/ChatManager.md#searchmessagesinconversation) | Searches for messages in a conversation. |
| [removeMessagesWithTimestamp](classes/ChatManager.md#removemessageswithtimestamp) | Delete the local and server messages of the current user. The server messages of other users in the single chat or group chat with the user will not be affected and can be obtained through roaming. |
| [getMessageCountWithTimestamp](classes/ChatManager.md#getmessagecountwithtimestamp) | Gets the count of messages in the conversation. |
| [getMessageCount](classes/ChatManager.md#getmessagecount) | Gets the count of messages in the local database. |

| Event | Description |
| :----- | :---------- |
| [onMessagesReceived](interfaces/ChatMessageEventListener.md#onmessagesreceived) | Occurs when a message is received. |
| [onCmdMessagesReceived](interfaces/ChatMessageEventListener.md#oncmdmessagesreceived) | Occurs when a command message is received. |
| [onMessagesRead](interfaces/ChatMessageEventListener.md#onmessagesread) | Occurs when a read receipt is received for a message. |
| [onGroupMessageRead](interfaces/ChatMessageEventListener.md#ongroupmessageread) | Occurs when a read receipt is received for a group message. |
| [onMessagesDelivered](interfaces/ChatMessageEventListener.md#onmessagesdelivered) | Occurs when a delivery receipt is received. |
| [onMessagesRecalledInfo](interfaces/ChatMessageEventListener.md#onmessagesrecalledinfo) | Occurs when a received message is recalled. |
| [onConversationsUpdate](interfaces/ChatMessageEventListener.md#onconversationsupdate) | Occurs when the conversation is updated. |
| [onConversationRead](interfaces/ChatMessageEventListener.md#onconversationread) | Occurs when a conversation read receipt is received. |
| [onMessageReactionDidChange](interfaces/ChatMessageEventListener.md#onmessagereactiondidchange) | Occurs when a message reaction changes. |
| [onChatMessageThreadCreated](interfaces/ChatMessageEventListener.md#onchatmessagethreadcreated) | Occurs when a message thread is created. |
| [onChatMessageThreadUpdated](interfaces/ChatMessageEventListener.md#onchatmessagethreadupdated) | Occurs when a message thread is updated. |
| [onChatMessageThreadDestroyed](interfaces/ChatMessageEventListener.md#onchatmessagethreaddestroyed) | Occurs when a message thread is destroyed. |
| [onChatMessageThreadUserRemoved](interfaces/ChatMessageEventListener.md#onchatmessagethreaduserremoved) | Occurs when the current user is removed from the message thread by the admin. |
| [onMessageContentChanged](interfaces/ChatMessageEventListener.md#onmessagecontentchanged) | Occurs when the content of a text message is modified. |
| [onMessagePinChanged](interfaces/ChatMessageEventListener.md#onmessagepinchanged) | Occurs when the message pinning status changed. |
## ChatContactManager
| Method | Description |
| :----- | :---------- |
| [setNativeListener](classes/ChatContactManager.md#setnativelistener) | The contact manager class, which manages chat contacts such as adding, retrieving, modifying, and deleting contacts. |
| [addContactListener](classes/ChatContactManager.md#addcontactlistener) | Adds a contact listener. |
| [removeContactListener](classes/ChatContactManager.md#removecontactlistener) | Removes the contact listener. |
| [removeAllContactListener](classes/ChatContactManager.md#removeallcontactlistener) | Removes all contact listeners. |
| [addContact](classes/ChatContactManager.md#addcontact) | Adds a new contact. |
| [deleteContact](classes/ChatContactManager.md#deletecontact) | Deletes a contact and all the related conversations. |
| [getAllContactsFromServer](classes/ChatContactManager.md#getallcontactsfromserver) | Gets the contact list from the server. |
| [getAllContactsFromDB](classes/ChatContactManager.md#getallcontactsfromdb) | Gets the contact list from the local database. |
| [addUserToBlockList](classes/ChatContactManager.md#addusertoblocklist) | Adds a contact to the block list. |
| [removeUserFromBlockList](classes/ChatContactManager.md#removeuserfromblocklist) | Removes the contact from the block list. |
| [getBlockListFromServer](classes/ChatContactManager.md#getblocklistfromserver) | Gets the block list from the server. |
| [getBlockListFromDB](classes/ChatContactManager.md#getblocklistfromdb) | Gets the block list from the local database. |
| [acceptInvitation](classes/ChatContactManager.md#acceptinvitation) | Accepts a friend invitation。 |
| [declineInvitation](classes/ChatContactManager.md#declineinvitation) | Declines a friend invitation. |
| [getSelfIdsOnOtherPlatform](classes/ChatContactManager.md#getselfidsonotherplatform) | Gets the unique IDs of the current user on the other devices. The ID is in the format of `{user_ID} + "/" + {resource_ID}`. |
| [getAllContacts](classes/ChatContactManager.md#getallcontacts) | Gets all contacts from the local database. |
| [getContact](classes/ChatContactManager.md#getcontact) | Gets the contact by user ID from local database. |
| [fetchAllContacts](classes/ChatContactManager.md#fetchallcontacts) | Gets all contacts from the server. |
| [fetchContacts](classes/ChatContactManager.md#fetchcontacts) | Gets the contacts from the server. |
| [setContactRemark](classes/ChatContactManager.md#setcontactremark) | Set the contact's remark. |

| Event | Description |
| :----- | :---------- |
| [onContactAdded](interfaces/ChatContactEventListener.md#oncontactadded) | Occurs when a friend request from the current user is accepted by the peer user. |
| [onContactDeleted](interfaces/ChatContactEventListener.md#oncontactdeleted) | Occurs when a friend request from the current user is declined by the peer user. |
| [onContactInvited](interfaces/ChatContactEventListener.md#oncontactinvited) | Occurs when a friend request is received by the current user. |
| [onFriendRequestAccepted](interfaces/ChatContactEventListener.md#onfriendrequestaccepted) | Occurs when a friend request is accepted by the current user. |
| [onFriendRequestDeclined](interfaces/ChatContactEventListener.md#onfriendrequestdeclined) | Occurs when a friend request is declined by the current user. |
## ChatGroupManager
| Method | Description |
| :----- | :---------- |
| [setNativeListener](classes/ChatGroupManager.md#setnativelistener) | The group manager class, which defines how to manage groups, like group creation and destruction and member management. |
| [getGroupWithId](classes/ChatGroupManager.md#getgroupwithid) | Gets the group instance from the memory by group ID. |
| [getJoinedGroups](classes/ChatGroupManager.md#getjoinedgroups) | Gets the list of groups that the current user has joined. |
| [fetchJoinedGroupsFromServer](classes/ChatGroupManager.md#fetchjoinedgroupsfromserver) | Gets the list of groups that the current user has joined. |
| [fetchPublicGroupsFromServer](classes/ChatGroupManager.md#fetchpublicgroupsfromserver) | Gets public groups from the server with pagination. |
| [createGroup](classes/ChatGroupManager.md#creategroup) | Creates a group instance. |
| [createGroupEx](classes/ChatGroupManager.md#creategroupex) | Creates a group instance. |
| [fetchGroupInfoFromServer](classes/ChatGroupManager.md#fetchgroupinfofromserver) | Gets the group information from the server. |
| [fetchGroupInfoWithoutMembersFromServer](classes/ChatGroupManager.md#fetchgroupinfowithoutmembersfromserver) | Gets the group information from the server. |
| [fetchMemberListFromServer](classes/ChatGroupManager.md#fetchmemberlistfromserver) | Uses the pagination to get the member list of the group from the server. |
| [fetchMemberInfoListFromServer](classes/ChatGroupManager.md#fetchmemberinfolistfromserver) | Uses the pagination to get the member information list of the group from the server. |
| [fetchBlockListFromServer](classes/ChatGroupManager.md#fetchblocklistfromserver) | Uses the pagination to get the group block list from the server. |
| [fetchMuteListFromServer](classes/ChatGroupManager.md#fetchmutelistfromserver) | Uses the pagination to get the mute list of the group from the server. |
| [fetchAllowListFromServer](classes/ChatGroupManager.md#fetchallowlistfromserver) | Uses the pagination to get the allow list of the group from the server. |
| [isMemberInAllowListFromServer](classes/ChatGroupManager.md#ismemberinallowlistfromserver) | Gets whether the member is on the allow list of the group. |
| [fetchGroupFileListFromServer](classes/ChatGroupManager.md#fetchgroupfilelistfromserver) | Uses the pagination to get the shared files of the group from the server. |
| [fetchAnnouncementFromServer](classes/ChatGroupManager.md#fetchannouncementfromserver) | Gets the group announcement from the server. |
| [addMembers](classes/ChatGroupManager.md#addmembers) | Adds users to the group. |
| [inviteUser](classes/ChatGroupManager.md#inviteuser) | Invites users to join the group. |
| [removeMembers](classes/ChatGroupManager.md#removemembers) | Removes a member from the group. |
| [blockMembers](classes/ChatGroupManager.md#blockmembers) | Adds the user to the block list of the group. |
| [unblockMembers](classes/ChatGroupManager.md#unblockmembers) | Removes users from the group block list. |
| [changeGroupName](classes/ChatGroupManager.md#changegroupname) | Changes the group name. |
| [changeGroupDescription](classes/ChatGroupManager.md#changegroupdescription) | Modifies the group description. |
| [leaveGroup](classes/ChatGroupManager.md#leavegroup) | Leaves a group. |
| [destroyGroup](classes/ChatGroupManager.md#destroygroup) | Destroys the group instance. |
| [blockGroup](classes/ChatGroupManager.md#blockgroup) | Blocks group messages. |
| [unblockGroup](classes/ChatGroupManager.md#unblockgroup) | Unblocks group messages. |
| [changeOwner](classes/ChatGroupManager.md#changeowner) | Transfers the group ownership. |
| [addAdmin](classes/ChatGroupManager.md#addadmin) | Adds a group admin. |
| [removeAdmin](classes/ChatGroupManager.md#removeadmin) | Removes a group admin. |
| [muteMembers](classes/ChatGroupManager.md#mutemembers) | Mutes group members. |
| [unMuteMembers](classes/ChatGroupManager.md#unmutemembers) | Unmutes group members. |
| [muteAllMembers](classes/ChatGroupManager.md#muteallmembers) | Mutes all members. |
| [unMuteAllMembers](classes/ChatGroupManager.md#unmuteallmembers) | Unmutes all group members. |
| [addAllowList](classes/ChatGroupManager.md#addallowlist) | Adds members to the allow list of the group. |
| [removeAllowList](classes/ChatGroupManager.md#removeallowlist) | Removes members from the allow list of the group. |
| [uploadGroupSharedFile](classes/ChatGroupManager.md#uploadgroupsharedfile) | Uploads the shared file to the group. |
| [downloadGroupSharedFile](classes/ChatGroupManager.md#downloadgroupsharedfile) | Downloads the shared file of the group. |
| [removeGroupSharedFile](classes/ChatGroupManager.md#removegroupsharedfile) | Removes a shared file of the group. |
| [updateGroupAnnouncement](classes/ChatGroupManager.md#updategroupannouncement) | Updates the group announcement. |
| [updateGroupAvatar](classes/ChatGroupManager.md#updategroupavatar) | Updates the group avatar. |
| [updateGroupExtension](classes/ChatGroupManager.md#updategroupextension) | Updates the group extension field. |
| [joinPublicGroup](classes/ChatGroupManager.md#joinpublicgroup) | Joins a public group. |
| [requestToJoinPublicGroup](classes/ChatGroupManager.md#requesttojoinpublicgroup) | Requests to join a group. |
| [acceptJoinApplication](classes/ChatGroupManager.md#acceptjoinapplication) | Accepts a join request. |
| [declineJoinApplication](classes/ChatGroupManager.md#declinejoinapplication) | Declines a join request. |
| [acceptInvitation](classes/ChatGroupManager.md#acceptinvitation) | Accepts a group invitation. |
| [declineInvitation](classes/ChatGroupManager.md#declineinvitation) | Declines a group invitation. |
| [setMemberAttribute](classes/ChatGroupManager.md#setmemberattribute) | Sets custom attributes of a group member. |
| [fetchMemberAttributes](classes/ChatGroupManager.md#fetchmemberattributes) | Gets all custom attributes of a group member. |
| [fetchMembersAttributes](classes/ChatGroupManager.md#fetchmembersattributes) | Gets custom attributes of multiple group members by attribute key. |
| [fetchJoinedGroupCount](classes/ChatGroupManager.md#fetchjoinedgroupcount) | Gets the number of groups joined by the current user. |
| [addGroupListener](classes/ChatGroupManager.md#addgrouplistener) | Adds a group listener. |
| [removeGroupListener](classes/ChatGroupManager.md#removegrouplistener) | Removes the group listener. |
| [removeAllGroupListener](classes/ChatGroupManager.md#removeallgrouplistener) | Clears all group listeners. |

| Event | Description |
| :----- | :---------- |
| [onInvitationReceived](interfaces/ChatGroupEventListener.md#oninvitationreceived) | Occurs when the current user receives a group invitation. |
| [onRequestToJoinReceived](interfaces/ChatGroupEventListener.md#onrequesttojoinreceived) | Occurs when a join request from the current user is received by the peer user. |
| [onRequestToJoinAccepted](interfaces/ChatGroupEventListener.md#onrequesttojoinaccepted) | Occurs when a join request from the current user is accepted by the peer user. |
| [onRequestToJoinDeclined](interfaces/ChatGroupEventListener.md#onrequesttojoindeclined) | Occurs when a join request from the current user is declined by the peer user. |
| [onInvitationAccepted](interfaces/ChatGroupEventListener.md#oninvitationaccepted) | Occurs when a group invitation from the current user is accepted by the peer user. |
| [onInvitationDeclined](interfaces/ChatGroupEventListener.md#oninvitationdeclined) | Occurs when a group invitation from the current user is declined by the peer user. |
| [onMemberRemoved](interfaces/ChatGroupEventListener.md#onmemberremoved) | Occurs when the current user is removed from the group. |
| [onDestroyed](interfaces/ChatGroupEventListener.md#ondestroyed) | Occurs when a group is destroyed. |
| [onAutoAcceptInvitation](interfaces/ChatGroupEventListener.md#onautoacceptinvitation) | Occurs when the group invitation is accepted automatically by the current user. |
| [onMuteListAdded](interfaces/ChatGroupEventListener.md#onmutelistadded) | Occurs when one or more members are added to the mute list of the group. |
| [onMuteListRemoved](interfaces/ChatGroupEventListener.md#onmutelistremoved) | Occurs when one or more members are removed from the mute list of the group. |
| [onAdminAdded](interfaces/ChatGroupEventListener.md#onadminadded) | Occurs when a member is set as an admin. |
| [onAdminRemoved](interfaces/ChatGroupEventListener.md#onadminremoved) | Occurs when the administrative privileges of an admin are removed. |
| [onOwnerChanged](interfaces/ChatGroupEventListener.md#onownerchanged) | Occurs when the group ownership is transferred. |
| [onMemberJoined](interfaces/ChatGroupEventListener.md#onmemberjoined) | Occurs when a user joins a group. |
| [onMembersJoined](interfaces/ChatGroupEventListener.md#onmembersjoined) | Occurs when multiple users join a group. |
| [onMemberExited](interfaces/ChatGroupEventListener.md#onmemberexited) | Occurs when a member voluntarily leaves the group. |
| [onMembersExited](interfaces/ChatGroupEventListener.md#onmembersexited) | Occurs when multiple users leave a group. |
| [onAnnouncementChanged](interfaces/ChatGroupEventListener.md#onannouncementchanged) | Occurs when the group announcement is updated. |
| [onSharedFileAdded](interfaces/ChatGroupEventListener.md#onsharedfileadded) | Occurs when a shared file is added to the group. |
| [onSharedFileDeleted](interfaces/ChatGroupEventListener.md#onsharedfiledeleted) | Occurs when a shared file is removed from a group. |
| [onAllowListAdded](interfaces/ChatGroupEventListener.md#onallowlistadded) | Occurs when one or more group members are added to the allow list. |
| [onAllowListRemoved](interfaces/ChatGroupEventListener.md#onallowlistremoved) | Occurs when one or more group members are removed from the allow list. |
| [onAllGroupMemberMuteStateChanged](interfaces/ChatGroupEventListener.md#onallgroupmembermutestatechanged) | Occurs when all group members are muted or unmuted. |
| [onDetailChanged](interfaces/ChatGroupEventListener.md#ondetailchanged) | Occurs when the chat group detail change. All chat group members receive this event. |
| [onStateChanged](interfaces/ChatGroupEventListener.md#onstatechanged) | Occurs when the disabled state of group changes. |
| [onMemberAttributesChanged](interfaces/ChatGroupEventListener.md#onmemberattributeschanged) | Occurs when a custom attribute(s) of a group member is/are changed. |
## ChatRoomManager
| Method | Description |
| :----- | :---------- |
| [setNativeListener](classes/ChatRoomManager.md#setnativelistener) | The chat room manager class, which manages user operations, like joining and leaving the chat room and retrieving the chat room list, and manages member privileges. |
| [addRoomListener](classes/ChatRoomManager.md#addroomlistener) | Adds a chat room listener. |
| [removeRoomListener](classes/ChatRoomManager.md#removeroomlistener) | Removes the chat room listener. |
| [removeAllRoomListener](classes/ChatRoomManager.md#removeallroomlistener) | Removes all the chat room listeners. |
| [joinChatRoom](classes/ChatRoomManager.md#joinchatroom) | Joins the chat room. |
| [joinChatRoomEx](classes/ChatRoomManager.md#joinchatroomex) | Joins the chat room. |
| [leaveChatRoom](classes/ChatRoomManager.md#leavechatroom) | Leaves the chat room. |
| [fetchPublicChatRoomsFromServer](classes/ChatRoomManager.md#fetchpublicchatroomsfromserver) | Gets chat room data from the server with pagination. |
| [fetchChatRoomInfoFromServer](classes/ChatRoomManager.md#fetchchatroominfofromserver) | Gets the details of the chat room from the server. |
| [getChatRoomWithId](classes/ChatRoomManager.md#getchatroomwithid) | Gets the chat room by ID from the local database. |
| [createChatRoom](classes/ChatRoomManager.md#createchatroom) | Creates a chat room. |
| [destroyChatRoom](classes/ChatRoomManager.md#destroychatroom) | Destroys a chat room. |
| [changeChatRoomSubject](classes/ChatRoomManager.md#changechatroomsubject) | Changes the chat room name. |
| [changeChatRoomDescription](classes/ChatRoomManager.md#changechatroomdescription) | Modifies the chat room description. |
| [fetchChatRoomMembers](classes/ChatRoomManager.md#fetchchatroommembers) | Gets the chat room member list. |
| [muteChatRoomMembers](classes/ChatRoomManager.md#mutechatroommembers) | Mutes the specified members in a chat room. |
| [unMuteChatRoomMembers](classes/ChatRoomManager.md#unmutechatroommembers) | Unmutes the specified members in a chat room. |
| [changeOwner](classes/ChatRoomManager.md#changeowner) | Transfers the chat room ownership. |
| [addChatRoomAdmin](classes/ChatRoomManager.md#addchatroomadmin) | Adds a chat room admin. |
| [removeChatRoomAdmin](classes/ChatRoomManager.md#removechatroomadmin) | Removes administrative privileges of a chat room admin. |
| [fetchChatRoomMuteList](classes/ChatRoomManager.md#fetchchatroommutelist) | Uses the pagination to get the list of members who are muted in the chat room. |
| [removeChatRoomMembers](classes/ChatRoomManager.md#removechatroommembers) | Removes the specified members from a chat room. |
| [blockChatRoomMembers](classes/ChatRoomManager.md#blockchatroommembers) | Adds the specified members to the block list of the chat room. |
| [unBlockChatRoomMembers](classes/ChatRoomManager.md#unblockchatroommembers) | Removes the specified members from the block list of the chat room. |
| [fetchChatRoomBlockList](classes/ChatRoomManager.md#fetchchatroomblocklist) | Gets the chat room block list with pagination. |
| [updateChatRoomAnnouncement](classes/ChatRoomManager.md#updatechatroomannouncement) | Updates the chat room announcement. |
| [fetchChatRoomAnnouncement](classes/ChatRoomManager.md#fetchchatroomannouncement) | Gets the chat room announcement from the server. |
| [fetchChatRoomAllowListFromServer](classes/ChatRoomManager.md#fetchchatroomallowlistfromserver) | Gets the allow list from the server. |
| [isMemberInChatRoomAllowList](classes/ChatRoomManager.md#ismemberinchatroomallowlist) | Checks whether the member is on the allow list of the chat room. |
| [isMemberInChatRoomMuteList](classes/ChatRoomManager.md#ismemberinchatroommutelist) | Checks whether the member is in the mute list of the chat room. |
| [addMembersToChatRoomAllowList](classes/ChatRoomManager.md#addmemberstochatroomallowlist) | Adds members to the allow list of the chat room. |
| [removeMembersFromChatRoomAllowList](classes/ChatRoomManager.md#removemembersfromchatroomallowlist) | Removes members from the allow list of the chat room. |
| [muteAllChatRoomMembers](classes/ChatRoomManager.md#muteallchatroommembers) | Mutes all members. |
| [unMuteAllChatRoomMembers](classes/ChatRoomManager.md#unmuteallchatroommembers) | Unmutes all members of the chat room. |
| [fetchChatRoomAttributes](classes/ChatRoomManager.md#fetchchatroomattributes) | Gets custom chat room attributes from the server. |
| [addAttributes](classes/ChatRoomManager.md#addattributes) | Sets custom chat room attributes. |
| [removeAttributes](classes/ChatRoomManager.md#removeattributes) | Removes custom chat room attributes. |

| Event | Description |
| :----- | :---------- |
| [onDestroyed](interfaces/ChatRoomEventListener.md#ondestroyed) | Occurs when the chat room is destroyed. All chat room members receive this event. |
| [onMemberJoined](interfaces/ChatRoomEventListener.md#onmemberjoined) | Occurs when a member joins the chat room. All chat room members, except the new member, receive this event. |
| [onMemberExited](interfaces/ChatRoomEventListener.md#onmemberexited) | Occurs when a member exits the chat room. All chat room members, except the member exiting the chat room, receive this event. |
| [onMemberRemoved](interfaces/ChatRoomEventListener.md#onmemberremoved) | Occurs when a member is removed from a chat room. The member that is kicked out of the chat room receive this event. |
| [onMuteListAdded](interfaces/ChatRoomEventListener.md#onmutelistadded) | Occurs when the chat room member(s) is/are added to the mute list. The muted members receive this event. |
| [onMuteListAddedV2](interfaces/ChatRoomEventListener.md#onmutelistaddedv2) | Occurs when the chat room member(s) is/are added to the mute list. The muted members receive this event. |
| [onMuteListRemoved](interfaces/ChatRoomEventListener.md#onmutelistremoved) | Occurs when the chat room member(s) is/are removed from the mute list. The members that are removed from the mute list receive this event. |
| [onAdminAdded](interfaces/ChatRoomEventListener.md#onadminadded) | Occurs when a chat room member is set as an admin. The member set as the chat room admin receives this event. |
| [onAdminRemoved](interfaces/ChatRoomEventListener.md#onadminremoved) | Occurs when the chat room member(s) is/are removed from the admin list. The admin removed from the admin list receives this event. |
| [onOwnerChanged](interfaces/ChatRoomEventListener.md#onownerchanged) | Occurs when the chat room owner is changed. The chat room owner receives this event. |
| [onAnnouncementChanged](interfaces/ChatRoomEventListener.md#onannouncementchanged) | Occurs when the chat room announcement changes. All chat room members receive this event. |
| [onAllowListAdded](interfaces/ChatRoomEventListener.md#onallowlistadded) | Occurs when the chat room member(s) is/are added to the allow list. The members added to the allow list receive this event. |
| [onAllowListRemoved](interfaces/ChatRoomEventListener.md#onallowlistremoved) | Occurs when the chat room member(s) is/are removed from the allow list. The members that are removed from the allow list receive this event. |
| [onAllChatRoomMemberMuteStateChanged](interfaces/ChatRoomEventListener.md#onallchatroommembermutestatechanged) | Occurs when all members in the chat room are muted or unmuted. All chat room members receive this event. |
| [onSpecificationChanged](interfaces/ChatRoomEventListener.md#onspecificationchanged) | Occurs when the chat room specifications changes. All chat room members receive this event. |
| [onAttributesUpdated](interfaces/ChatRoomEventListener.md#onattributesupdated) | The custom chat room attribute(s) is/are updated. All chat room members receive this event. |
| [onAttributesRemoved](interfaces/ChatRoomEventListener.md#onattributesremoved) | The custom chat room attribute(s) is/are removed. All chat room members receive this event. |
## ChatPresenceManager
| Method | Description |
| :----- | :---------- |
| [setNativeListener](classes/ChatPresenceManager.md#setnativelistener) | The presence manager class. |
| [addPresenceListener](classes/ChatPresenceManager.md#addpresencelistener) | Adds a presence listener. |
| [removePresenceListener](classes/ChatPresenceManager.md#removepresencelistener) | Removes a presence listener. |
| [removeAllPresenceListener](classes/ChatPresenceManager.md#removeallpresencelistener) | Clears all presence listeners. |
| [publishPresence](classes/ChatPresenceManager.md#publishpresence) | Publishes a custom presence state. |
| [subscribe](classes/ChatPresenceManager.md#subscribe) | Subscribes to the presence state of a user. |
| [unsubscribe](classes/ChatPresenceManager.md#unsubscribe) | Unsubscribes from the presence state of the unspecified users. |
| [fetchSubscribedMembers](classes/ChatPresenceManager.md#fetchsubscribedmembers) | Uses the pagination to get a list of users whose presence states you have subscribed to. |
| [fetchPresenceStatus](classes/ChatPresenceManager.md#fetchpresencestatus) | Gets the current presence state of specified users. |

| Event | Description |
| :----- | :---------- |
| [onPresenceStatusChanged](interfaces/ChatPresenceEventListener.md#onpresencestatuschanged) | The custom chat room attribute(s) is/are removed. All chat room members receive this event. |
## ChatPushManager
| Method | Description |
| :----- | :---------- |
| [setNativeListener](classes/ChatPushManager.md#setnativelistener) | The class for message push configuration options. |
| [setSilentModeForConversation](classes/ChatPushManager.md#setsilentmodeforconversation) | Sets the offline push for the conversation. |
| [removeSilentModeForConversation](classes/ChatPushManager.md#removesilentmodeforconversation) | Clears the offline push settings of the conversation. |
| [fetchSilentModeForConversation](classes/ChatPushManager.md#fetchsilentmodeforconversation) | Gets the offline push settings of the conversation. |
| [setSilentModeForAll](classes/ChatPushManager.md#setsilentmodeforall) | Sets the offline push of the app. |
| [fetchSilentModeForAll](classes/ChatPushManager.md#fetchsilentmodeforall) | Gets the do-not-disturb settings of the app. |
| [fetchSilentModeForConversations](classes/ChatPushManager.md#fetchsilentmodeforconversations) | Gets the do-not-disturb settings of the specified conversations. |
| [setPreferredNotificationLanguage](classes/ChatPushManager.md#setpreferrednotificationlanguage) | Sets the target translation language of offline push notifications. |
| [fetchPreferredNotificationLanguage](classes/ChatPushManager.md#fetchpreferrednotificationlanguage) | Gets the configured push translation language. |
| [updatePushNickname](classes/ChatPushManager.md#updatepushnickname) | Updates nickname of the sender displayed in push notifications. |
| [updatePushDisplayStyle](classes/ChatPushManager.md#updatepushdisplaystyle) | Updates the display style of push notifications. |
| [fetchPushOptionFromServer](classes/ChatPushManager.md#fetchpushoptionfromserver) | Gets the push configurations from the server. |
| [selectPushTemplate](classes/ChatPushManager.md#selectpushtemplate) | Selects the push template for offline push. |
| [fetchSelectedPushTemplate](classes/ChatPushManager.md#fetchselectedpushtemplate) | Gets the selected push template for offline push. |
## ChatUserInfoManager
| Method | Description |
| :----- | :---------- |
| [updateOwnUserInfo](classes/ChatUserInfoManager.md#updateownuserinfo) | Modifies the user attributes of the current user. |
| [fetchUserInfoById](classes/ChatUserInfoManager.md#fetchuserinfobyid) | Gets the user attributes of the specified users. |
| [fetchOwnInfo](classes/ChatUserInfoManager.md#fetchowninfo) | Gets attributes of the current user from the server. |
## ChatMessage
| Method | Description |
| :----- | :---------- |
| [constructor](classes/ChatMessage.md#constructor) | Constructs a message. |
| [createSendMessage](classes/ChatMessage.md#createsendmessage) | Constructs a message. |
| [createTextMessage](classes/ChatMessage.md#createtextmessage) | Creates a text message for sending. |
| [createFileMessage](classes/ChatMessage.md#createfilemessage) | Creates a message with a file attachment for sending. |
| [createImageMessage](classes/ChatMessage.md#createimagemessage) | Creates an image message for sending. |
| [createVideoMessage](classes/ChatMessage.md#createvideomessage) | Creates a video message for sending. |
| [createVoiceMessage](classes/ChatMessage.md#createvoicemessage) | Creates a voice message for sending. |
| [createCombineMessage](classes/ChatMessage.md#createcombinemessage) | Creates a combined message for sending. |
| [createLocationMessage](classes/ChatMessage.md#createlocationmessage) | Creates a location message for sending. |
| [createCmdMessage](classes/ChatMessage.md#createcmdmessage) | Creates a command message for sending. |
| [createCustomMessage](classes/ChatMessage.md#createcustommessage) | Creates a custom message for sending. |
| [createReceiveMessage](classes/ChatMessage.md#createreceivemessage) | Creates a received message instance. |
| [reactionList](classes/ChatMessage.md#reactionlist) | Gets the list of Reactions. |
| [groupReadCount](classes/ChatMessage.md#groupreadcount) | Gets the count of read receipts of a group message. |
| [threadInfo](classes/ChatMessage.md#threadinfo) | Gets details of a message thread. |
| [getPinInfo](classes/ChatMessage.md#getpininfo) | Get the list of pinned messages in the conversation. |
| [messagePriority](classes/ChatMessage.md#messagepriority) | Set the chat room message priority. |
## ChatConversation
| Method | Description |
| :----- | :---------- |
| [name](classes/ChatConversation.md#name) | Gets the conversation ID. |
| [getUnreadCount](classes/ChatConversation.md#getunreadcount) | Gets the count of unread messages in the conversation. |
| [getMessageCount](classes/ChatConversation.md#getmessagecount) | Gets the count of messages in the conversation. |
| [getMessageCountWithTimestamp](classes/ChatConversation.md#getmessagecountwithtimestamp) | Gets the count of messages in the conversation. |
| [getLatestMessage](classes/ChatConversation.md#getlatestmessage) | Gets the latest message from the conversation. |
| [getLatestReceivedMessage](classes/ChatConversation.md#getlatestreceivedmessage) | Gets the latest message received in the conversation. |
| [setConversationExtension](classes/ChatConversation.md#setconversationextension) | Sets the extension information of the conversation. |
| [markMessageAsRead](classes/ChatConversation.md#markmessageasread) | Marks a message as read. |
| [markAllMessagesAsRead](classes/ChatConversation.md#markallmessagesasread) | Marks all messages as read. |
| [updateMessage](classes/ChatConversation.md#updatemessage) | Updates a message in the local database. |
| [deleteMessage](classes/ChatConversation.md#deletemessage) | Deletes a message from the local database. |
| [deleteMessagesWithTimestamp](classes/ChatConversation.md#deletemessageswithtimestamp) | Deletes messages sent or received in a certain period from the local database. |
| [deleteAllMessages](classes/ChatConversation.md#deleteallmessages) | Deletes all the messages of the conversation. |
| [getMessagesWithMsgType](classes/ChatConversation.md#getmessageswithmsgtype) | Gets messages of a certain type that a specified user sends in a conversation. |
| [getMsgsWithMsgType](classes/ChatConversation.md#getmsgswithmsgtype) | Gets messages of a certain type in the conversation from the local database. |
| [getMessages](classes/ChatConversation.md#getmessages) | Gets messages of a certain quantity in a conversation from the local database. |
| [getMsgs](classes/ChatConversation.md#getmsgs) | Gets messages of a specified quantity in a conversation from the local database. |
| [getMessagesWithIds](classes/ChatConversation.md#getmessageswithids) | Gets messages with the specified IDs from the local database. |
| [getMessagesWithKeyword](classes/ChatConversation.md#getmessageswithkeyword) | Gets messages with keywords in a conversation in the local database. |
| [getMsgsWithKeyword](classes/ChatConversation.md#getmsgswithkeyword) | Gets messages that the specified user sends in a conversation in a certain period. |
| [getMessageWithTimestamp](classes/ChatConversation.md#getmessagewithtimestamp) | Gets messages that are sent and received in a certain period in a conversation in the local database. |
| [getMsgWithTimestamp](classes/ChatConversation.md#getmsgwithtimestamp) | Gets messages that are sent and received in a certain period in a conversation in the local database. |
| [removeMessagesFromServerWithMsgIds](classes/ChatConversation.md#removemessagesfromserverwithmsgids) | Deletes messages from the conversation (from both local storage and server). |
| [removeMessagesFromServerWithTimestamp](classes/ChatConversation.md#removemessagesfromserverwithtimestamp) | Deletes messages from the conversation (from both local storage and server). |
| [getPinnedMessages](classes/ChatConversation.md#getpinnedmessages) | Gets the pinned messages in the conversation from the local database. |
| [fetchPinnedMessages](classes/ChatConversation.md#fetchpinnedmessages) | Gets the pinned messages in the conversation from the server. |
| [searchMessages](classes/ChatConversation.md#searchmessages) | Searches for messages. |
| [removeMessagesWithTimestamp](classes/ChatConversation.md#removemessageswithtimestamp) | Delete the local and server messages of the current user. The server messages of other users in the single chat or group chat with the user will not be affected and can be obtained through roaming. |
