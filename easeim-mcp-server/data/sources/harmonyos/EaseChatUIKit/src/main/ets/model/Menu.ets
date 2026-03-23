import { ContentType } from '@easemob/chatsdk';
import { MessageStatus } from '@easemob/chatsdk/src/main/ets/message/ChatMessage';
import { ChatKitConversation } from '../../../../Index';
import { ChatKitMessage } from './ChatKitMessage';

export class MenuItem {
  id: number | string = '';
  icon?: Resource; // 条目图标
  value: ResourceStr = ''; //条目内容。
  fontColor?: ResourceColor; //条目字体颜色。
  height?: Length; // 条目高度，默认为56vp
  order?: number; // 排序
  padding?: Length; // 图标和文字之间的距离
  enable?: boolean; // 是否可用, 默认为可用
  showAsAction?: ShowAsAction; // 菜单项的展示状态，默认为 ShowAsAction.ifRoom
  /**
   * 点击事件，不是所有的地方的菜单项都添加了action。
   */
  action?: (id: number | string) => void;
}

/**
 * 消息条目中的菜单项
 */
export class MessageMenuItem extends MenuItem {
  messageEnable?: MessageEnableOptions;
  onMenuClick?: (id: string | number, message: ChatKitMessage) => void;
}

/**
 * 会话列表条目的菜单项
 */
export class ConvMenuItem extends MenuItem {
  backgroundColor?: ResourceColor;
  onMenuClick?: (id: string | number, conv: ChatKitConversation) => void;
}

export class MessageEnableOptions {
  /**
   * 是否是发送方
   */
  isSender?: boolean = true

  /**
   * 可用菜单项的消息类型
   */
  messageTypes?: Array<ContentType | string>

  /**
   * 消息发送状态
   */
  messageStatus?: MessageStatus[]

  /**
   * 其他条件
   */
  other?: boolean;
}

export enum ShowAsAction {
  /**
   * 不会出现在TitleBar上，会在悬浮菜单中展示。
   */
  never,
  /**
   * 如果TitleBar的空间足够，则在TitleBar上展示，否则在悬浮菜单中展示。
   */
  ifRoom,
  /**
   * 即使有图标，也只展示文字。
   */
  withText
}
