
/**
 * 控件状态。
 */
export enum ComponentStatus {
  UNCHECKED,
  CHECKED,
  /**
   * 选中未激活状态
   */
  CHECKED_OFF
}

/**
 * 消息状态。
 */
export enum MessageSentStatus {
  /**
   * 发送中
   */
  PROGRESSING,
  /**
   * 发送失败
   */
  FAILED,
  /**
   * 发送成功
   */
  SUCCESS,
  /**
   * 消息送达（需要开启{@link ChatOptions.setRequireDeliveryAck}设置）
   */
  DELIVERED,
  /**
   * 消息已被对方阅读（需要开启{@link ChatOptions.setRequireReadAck}设置）
   */
  READ
}