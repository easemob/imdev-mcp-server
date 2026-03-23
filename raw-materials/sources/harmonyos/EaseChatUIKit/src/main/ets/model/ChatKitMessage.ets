import { ChatMessage, ContentType, DownloadStatus, MessageExtType, MessageStatus } from '@easemob/chatsdk';
import { ChatTransfer } from '../internal/ChatTransfer';
import { isAttachmentMessage } from '../utils/MessageUtil';
import { ChatKitBaseModel as ChatKitBaseModel } from './ChatKitBaseModel';
import { util } from '@kit.ArkTS';

/**
 * 消息对象。
 */
@ObservedV2
export class ChatKitMessage extends ChatKitBaseModel<ChatMessage>{

  /**
   * 消息的唯一标识。
   */
  declare uuid: string;

  /**
   * 消息 ID。
   */
  @Trace declare messageId: string;

  /**
   * 头像
   */
  @Trace icon?: Resource;

  /**
   * 消息的发送/接收状态。
   */
  @Trace status: MessageStatus = MessageStatus.CREATE;

  /**
   * 消息已读状态。
   */
  @Trace isRead: boolean = false;

  /**
   * 语音消息是否已听。
   */
  @Trace isListened?: boolean = false;

  /**
   * 对方是否已读。
   */
  @Trace isReceiverRead: boolean = false;

  /**
   * 消息是否成功送达。
   */
  @Trace isDelivered: boolean = false;

  /**
   * 消息是否需要群组已读回执。
   */
  @Trace isNeedGroupAck: boolean = false;

  /**
   * 群消息已读人数。
   */
  @Trace groupAckCount?: number;

  /**
   * 消息的服务器时间戳。
   */
  @Trace serverTimestamp: number = 0;

  /**
   * 消息的本地时间戳。
   */
  @Trace localTimestamp: number = 0;

  /**
   * 消息的可扩展属性。
   */
  @Trace ext?: Map<string, MessageExtType>;

  /**
   * 是否只投递在线用户。
   */
  @Trace isDeliverOnlineOnly: boolean = false;

  /**
   * 消息撤回者的用户 ID。
   */
  @Trace recaller?: string;

  /**
   * 附件下载状态。
   *
   * 附件消息（图片消息，视频消息，语音消息，合并消息）有此属性。
   */
  @Trace attachmentDownloadStatus?: DownloadStatus

  /**
   * 缩略图下载状态。
   *
   * 图片消息，视频消息有该属性。
   */
  @Trace thumbnailDownloadStatus?: DownloadStatus

  /**
   * 响应点击回复消息时的标记。
   */
  @Trace isReplyResponse: boolean = false;

  /**
   * 消息被编辑的次数
   */
  @Trace operationCount?: number;

  constructor(message: ChatMessage) {
    super();
    this.uuid = util.generateRandomUUID(true);
    this.origin = message;
    this.updateProperty(message);
  }

  /**
   * 更新消息的状态信息。
   */
  update() {
    this.updateProperty(this.origin);
  }

  private updateProperty(message: ChatMessage) {
    this.messageId = message.getMsgId();
    this.status = message.getStatus();
    this.isRead = !message.isUnread();
    this.isListened = message.isListened();
    this.isReceiverRead = message.isReceiverRead();
    this.isDelivered = message.isDelivered();
    this.isNeedGroupAck = message.isNeedGroupAck();
    this.groupAckCount = message.groupAckCount();
    this.serverTimestamp = message.getServerTimestamp();
    this.localTimestamp = message.getLocalTimestamp();
    this.ext = message.ext();
    this.isDeliverOnlineOnly = message.isDeliverOnlineOnly();
    this.recaller = message.getRecaller();
    if (isAttachmentMessage(message)) {
      const attachmentInfo = ChatTransfer.revertAttachmentMessageBody(message.getBody());
      this.attachmentDownloadStatus = attachmentInfo?.downloadStatus;
      this.thumbnailDownloadStatus = attachmentInfo?.thumbnail?.thumbnailDownloadStatus;
    }
    if (this.origin.getType() === ContentType.TXT) {
      this.operationCount = this.origin.getBody()?.operationCount();
    }
  }

}
