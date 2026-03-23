import { ConversationType } from '@easemob/chatsdk';

/**
 * 跳转到ChatPage页面需要携带的参数
 */
export class ChatPageParams {
  conversationId: string = '';
  conversationType: ConversationType = ConversationType.Chat;
}

/**
 * 搜索页面参数
 * 主要是点击后的响应。
 */
export class SearchContactPageParams {
  responseType: SearchContactResponseType = SearchContactResponseType.chat
  /**
   * 点击后是替换搜索页面还是跳转到新的页面
   */
  isReplacePath?: boolean;

  /**
   * 是否进行通知，以进行页面关闭等操作
   */
  isNeedNotify?: boolean;
}

export enum SearchContactResponseType {
  /**
   * 带参数返回
   */
  onPop,
  /**
   * 跳转到聊天页面
   */
  chat
}