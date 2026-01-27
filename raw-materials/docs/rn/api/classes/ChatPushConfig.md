[**react-native-chat-sdk**](../README.md)

***

[react-native-chat-sdk](../globals.md) / ChatPushConfig

# Class: ChatPushConfig

Defined in: common/ChatPushConfig.ts:32

The push configuration class.

For Google Firebase Cloud Messaging (FCM), see https://firebase.google.com/docs/cloud-messaging/concept-options.
For the Apple Push Notification service (APNs), see https://developer.apple.com/documentation/usernotifications.
For platform information of React Native, see https://reactnative.dev/docs/platform.
For example:
   ```console.log('android: ext: ', Platform.OS, (Platform as any).constants);```
Print result:
   ```
   [
      {"Brand": "google", "Fingerprint": "google/walleye/walleye:11/RP1A.200720.009/6720564:user/release-keys", "Manufacturer": "Google", "Model": "Pixel 2", "Release": "11", "Serial": "unknown", "Version": 30, "isTesting": false, "reactNativeVersion": {"major": 0, "minor": 66, "patch": 4, "prerelease": null}, "uiMode": "normal"}
  ]
   ```

## Constructors

### Constructor

> **new ChatPushConfig**(`params?`): `ChatPushConfig`

Defined in: common/ChatPushConfig.ts:52

Constructs a push configuration object.

#### Parameters

##### params?

###### deviceId?

`string`

###### deviceToken?

`string`

#### Returns

`ChatPushConfig`

## Properties

### deviceId?

> `optional` **deviceId**: `string`

Defined in: common/ChatPushConfig.ts:38

The device ID.
For FCM, the field is the user ID of the push notification sender.
For APNs, this field is the certificate name of the push service.

***

### deviceToken?

> `optional` **deviceToken**: `string`

Defined in: common/ChatPushConfig.ts:44

The device token.
The device token is indicated in the callback or method provided by the push vendor.
For details, see the push SDK instructions of the respective push vendors.

***

### manufacturer?

> `optional` **manufacturer**: `string`

Defined in: common/ChatPushConfig.ts:48

The device vendor. See Platform.constants.Manufacturer
