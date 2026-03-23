import { ChatUIKitConfigs } from '../ChatUIKitConfigs';
import { AppStyle, CornerStyle } from './CornerStyle';

export class ChatConfigs {
  // 消息可以被撤回的时间，默认为2分钟
  timePeriodCanRecallMessage?: number;
  // 聊天页面是否展示自己的昵称；默认，群聊中，不展示自己的昵称。
  showSenderNickname?: boolean;
  /**
   * 是否展示聊天页面中对方的昵称：默认，群聊中，展示其他人的昵称
   */
  showReceiverNickname?: boolean;
  // 聊天页面是否展示自己的头像；默认，在单聊和群聊中，展示自己的头像。
  showSelfAvatar?: boolean;
}

export class ChatUIKitDefaultConfigs extends ChatUIKitConfigs {
  cornerStyle: CornerStyle = CornerStyle.ROUND;
  appStyle: AppStyle = AppStyle.STYLE_1;
  chatConfigs: ChatConfigs = new ChatDefaultConfigs();
}

export class ChatDefaultConfigs extends ChatConfigs {
  timePeriodCanRecallMessage: number = 120000;
  showSenderNickname: boolean = false;
  showReceiverNickname: boolean = true;
  showSelfAvatar: boolean = true;
}