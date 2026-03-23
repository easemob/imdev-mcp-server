/**
 * 合并消息信息。
 */
export class MessageCombine {

  /**
   * 合并消息的标题。
   */
  title?: string;

  /**
   * 合并消息的概要。
   */
  summary?: string;

  /**
   * 合并消息的兼容文本。
   */
  compatibleText?: string;

  constructor(title?: string, summary?: string, compatibleText?: string) {
    this.title = title;
    this.summary = summary;
    this.compatibleText = compatibleText;
  }

}

/**
 * 输入框内容对象，用于接收 ChatPrimaryTextInput 中输出的内容，包含文本内容以及@成员内容。
 */
export class MessageContent {
  /**
   * 文本消息内容
   */
  value: string = '';
  /**
   * @成员列表，如果列表不为空为@消息，否则是普通消息
   */
  atList?: string[];
}

/**
 * @类型
 */
export enum MentionType {
  ME,
  ALL
}