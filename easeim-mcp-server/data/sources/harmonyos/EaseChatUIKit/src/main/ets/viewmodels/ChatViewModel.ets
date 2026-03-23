import {
  ChatCallback,
  ChatClient,
  ChatError,
  ChatLog,
  ChatMessage,
  ChatMessageListener,
  ChatType,
  ConnectionListener,
  ContentType,
  Conversation,
  ConversationListener,
  CursorResult,
  DownloadStatus,
  FetchMessageOption,
  RecallMessageInfo,
  VoiceMessageBody
} from '@easemob/chatsdk';
import { KitConstants } from '../../../../Index';
import { ChatTransfer } from '../internal/ChatTransfer';
import uikit from '../internal/ChatUIKit';
import { deleteFromArray, update } from '../internal/utils/ArrayUtils';
import { mentionManager } from '../manager/GroupChatMentionManager';
import { ChatKitMessage } from '../model/ChatKitMessage';
import { ErrorInfo } from '../model/ErrorInfo';
import { ChatRepo } from '../repositories/MessageRepo';
import { EventBus, getEventStr } from '../utils/EventBus';
import {
  createRecalledMessage,
  defaultFetchMessagesOptions,
  getMsgDownloadThumbnailEvent,
  isMediaMessage,
  isSender
} from '../utils/MessageUtil';

export type OnOperateSuccess = (message?: ChatMessage) => void;
export type OnOperateFail = (messageId: string | undefined, errorCode: number, errorMsg: string) => void;

export abstract class BaseViewModel {
  /**
   * 页面可见时调用，用于一些初始化操作。
   */
  abstract aboutToAppear();

  /**
   * 页面销毁时调用，用于资源释放。
   */
  abstract aboutToDisAppear();
}

@ObservedV2
export abstract class BaseListViewModel<T> extends BaseViewModel {
  @Trace dataList: T[] = [];
  @Trace errorInfo?: ErrorInfo;
  @Trace noMoreInfo?: ErrorInfo;
  @Trace isRefreshing: boolean = false;
}

@ObservedV2
export abstract class BaseChatViewModel extends BaseListViewModel<ChatKitMessage> {
  protected conversationId: string = '';
  protected chatType: ChatType = ChatType.Chat;
  protected conversation?: Conversation;
  protected isFetchMessagesFromServer: boolean = false;
  listScroller: Scroller = new Scroller();
  onDeleteMessageResult?: (messageId: string) => void;
  onRecallMessageResult?: (code: number, messageId: string) => void;
  onReceivedMessage?: (message: ChatMessage) => void;

  /**
   * 删除一条本地消息
   * @param message
   */
  abstract deleteMessage(message: ChatKitMessage);

  /**
   * 插入一条本地消息。
   * @param message
   */
  abstract insertMessage(message: ChatKitMessage);

  /**
   * 撤回一条已发送成功的消息。
   * @param message
   */
  abstract recallMessage(message: ChatKitMessage);

  /**
   * 对消息列表进行排序。
   */
  abstract sortMessages(dataList?: ChatKitMessage[]): ChatKitMessage[] | void;

  /**
   * 设置是否从服务器拉取消息，默认为false。
   * @param isFromServer
   */
  setFetchFromServer(isFromServer: boolean) {
    this.isFetchMessagesFromServer = isFromServer;
  }

  /**
   * 获取消息。
   * @param { number } pageSize - 一次获取消息的数量。
   * @param { string } cursorOrStartMsgId - 当从服务获取时，指获取消息的cursor；当从本地获取时，指查询的起始消息 ID。
   * @param { FetchMessageOption | undefined } fetchOptions - 当从服务获取时，获取消息的参数。
   */
  getMessages(pageSize: number = 20, cursorOrStartMsgId: string = '', fetchOptions?: FetchMessageOption) {}

  /**
   * 获取更多的消息。
   */
  abstract getMoreMessages();

  /**
   * 将会话消息置为已读。
   */
  abstract markAllMessagesAsRead();

  /**
   * 发送会话已读回执。
   * @param { boolean } isCheckUnreadCount - 是否检查会话的未读数，默认检查。
   */
  abstract ackConversationRead(isCheckUnreadCount?: boolean);

  /**
   * 发送消息已读回执。
   * @param message
   * @param isCheckMedia 是否检查多媒体消息，默认多媒体消息点击后再发送已读回执。
   */
  abstract ackMessageRead(message: ChatMessage, isCheckMedia?: boolean);

  /**
   * 下载图片缩略图，视频首帧或者语音消息。
   * @param message
   */
  abstract downloadThumbnail(message: ChatMessage);

  /**
   * 更新消息状态。
   * @param messageId
   * @param newMsg
   */
  abstract updateMessage(messageId: string, newMsg?: ChatMessage);

  /**
   * 滑动到最新消息处。
   */
  abstract scrollToLatest();

  /**
   * 滑动到指定位置。
   * @param target
   */
  abstract scrollToTarget(target: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions);

}

export class ChatViewModel extends BaseChatViewModel{
  protected cursorOrStartMsgId: string = '';
  protected pageSize: number = 20;
  protected fetchOptions: FetchMessageOption = defaultFetchMessagesOptions();
  protected isLoadedData: boolean = false;

  private messageListener: ChatMessageListener = {
    onMessageReceived: (messages: Array<ChatMessage>) => {
      messages.forEach((msg) => {
        if (this.isCurrentConv(msg)) {
          this.onReceivedMessage?.(msg);
          this.ackMessageRead(msg);
          this.dataList.push(new ChatKitMessage(msg));
          this.scrollToLatest();
        }
      })
    },
    onMessageRead: (messages: ChatMessage[]) => {
      messages.forEach(item => {
        if (this.isCurrentConv(item)) {
          this.updateMessage(item.getMsgId());
        }
      })
    },
    onMessageChanged: (message: ChatMessage) => {
      if (this.isCurrentConv(message)) {
        this.updateMessage(message.getMsgId());
      }
    },
    onMessageRecalled: (recallInfo: RecallMessageInfo[]) => {
      let msgs: ChatMessage[] = [];
      recallInfo.forEach(item => {
        if (this.isCurrentConv(item.getConversationId())) {
          // 增加撤回消息的逻辑
          if (item.getRecallMessage()) {
            msgs.push(item.getRecallMessage()!);
          }
        }
      })
      EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "recall"), ...msgs);
      // 通知page内的组件消息被撤回
      EventBus.create().emit(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "recall"), ...msgs);
    }
  }

  private connectionListener: ConnectionListener = {
    onConnected: (): void => {
      if (!this.isLoadedData) {
        this.getMessages(this.pageSize, '', this.fetchOptions);
      }
    },
    onDisconnected: (errorCode: number): void => {

    }
  }

  private conversationListener: ConversationListener = {
    onConversationRead: (from: string, to: string): void => {
      if (this.isCurrentConv(to)) {
        this.dataList.forEach(item => {
          item.update();
        })
      }
    }
  }

  constructor(conversationId: string, chatType: ChatType = ChatType.Chat) {
    super();
    this.conversationId = conversationId;
    this.chatType = chatType;
    this.conversation = ChatClient.getInstance().chatManager()?.getConversation(conversationId, chatType as number, true);
  }

  private isCurrentConv(message: ChatMessage | string): boolean {
    if (typeof message === 'string') {
      return message === this.conversationId;
    }
    return message.getConversationId() === this.conversationId;
  }

  getMessages(pageSize: number = 20, cursorOrStartMsgId: string = '', fetchOptions: FetchMessageOption = defaultFetchMessagesOptions()) {
    if (!this.checkConversation('getMessages')) {
      return;
    }
    this.pageSize = pageSize;
    this.fetchOptions = fetchOptions;
    if (!uikit.sdk.isLoggedIn()) {
      return;
    }
    this.isLoadedData = true;
    if (this.isFetchMessagesFromServer) {
      ChatRepo.fetchHistoryMessagesFromServer(this.conversation!.conversationId(), this.conversation!.getType(), pageSize, cursorOrStartMsgId, fetchOptions).then((result: CursorResult<ChatKitMessage>) => {
        this.cursorOrStartMsgId = result.getNextCursor();
        this.dataList = this.sortMessages(result.getResult());
        this.scrollToLatest();
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('fetchHistoryMessagesFromServer', e);
      })
    } else {
      ChatRepo.loadMoreMessages(this.conversation!, cursorOrStartMsgId, pageSize).then(result => {
        if (result.length > 0) {
          this.cursorOrStartMsgId = result[0].origin.getMsgId();
          this.dataList = this.sortMessages(result);
          this.scrollToLatest();
        }
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('loadMoreMessagesFromDB', e);
      })
    }
  }

  getMoreMessages() {
    if (!this.checkConversation('getMoreMessages')) {
      return;
    }
    if (this.isFetchMessagesFromServer) {
      if (!this.cursorOrStartMsgId) {
        this.isRefreshing = false;
        this.noMoreInfo = ErrorInfo.create('getMoreMessages');
        return;
      }
      ChatRepo.fetchHistoryMessagesFromServer(this.conversation!.conversationId(),
          this.conversation!.getType(),
          this.pageSize,
          this.cursorOrStartMsgId,
          this.fetchOptions)
        .then((result: CursorResult<ChatKitMessage>) => {
          this.isRefreshing = false;
          this.cursorOrStartMsgId = result.getNextCursor();
          if (result.getResult().length > 0) {
            let dataArray = this.dataList;
            dataArray.push(...result.getResult());
            this.dataList = this.sortMessages(dataArray);
            this.scrollToTarget(result.getResult().length - 1);
          }
      }).catch((e: ChatError) => {
        this.isRefreshing = false;
        this.errorInfo = ErrorInfo.create('fetchHistoryMessagesFromServer', e);
      })
    } else {
      ChatRepo.loadMoreMessages(this.conversation!, this.getStartMsgId(), this.pageSize).then(result => {
        this.isRefreshing = false;
        if (result.length === 0) {
          this.noMoreInfo = ErrorInfo.create('getMoreMessages');
          return;
        }
        if (result.length > 0) {
          let dataArray = this.dataList;
          dataArray.unshift(...result);
          this.dataList = this.sortMessages(dataArray);
          this.scrollToTarget(result.length - 1);
        }
      }).catch((e: ChatError) => {
        this.isRefreshing = false;
        this.errorInfo = ErrorInfo.create('loadMoreMessagesFromDB', e);
      })
    }
  }

  private getStartMsgId(): string {
    if (this.dataList && this.dataList.length > 0) {
      return this.dataList[0].messageId;
    }
    return '';
  }

  aboutToAppear(): void {
    uikit.sdk.chatManager()?.addMessageListener(this.messageListener);
    uikit.sdk.addConnectionListener(this.connectionListener);
    uikit.sdk.chatManager()?.addConversationListener(this.conversationListener);
    this.markAllMessagesAsRead();
    this.getMessages();
    this.ackConversationRead();
    EventBus.create().on(getMsgDownloadThumbnailEvent(), (params: string[]) => {
      if (params && params.length > 0) {
        let messageId = params[0];
        let message = this.dataList.find(item => item.messageId === messageId);
        if (message) {
          this.downloadThumbnail(message.origin);
        }
      }
    })
  }

  aboutToDisAppear(): void {
    uikit.sdk.removeConnectionListener(this.connectionListener);
    uikit.sdk.chatManager()?.removeMessageListener(this.messageListener);
    uikit.sdk.chatManager()?.removeConversationListener(this.conversationListener);
    this.markAllMessagesAsRead();
  }

  recallMessage(message: ChatKitMessage): void {
    ChatClient.getInstance().chatManager()?.recallMessage(message.origin).then(() => {
      //deleteFromArray(message, this.messages);
      this.updateMessage(message.messageId, createRecalledMessage(message.origin));
      // 通知对应的会话进行刷新。
      EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_CONV_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION), this.conversationId);
      // 通知消息被撤回
      EventBus.create().emit(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "recall"), message.origin);
      this.onRecallMessageResult?.(ChatError.EM_NO_ERROR, message.messageId);
    }).catch((e: ChatError) => {
      this.onRecallMessageResult?.(e.errorCode, message.messageId);
    })
  }

  deleteMessage(message: ChatKitMessage): void {
    const isDeleted = this.conversation?.removeMessage(message.origin);
    if (isDeleted) {
      deleteFromArray(message, this.dataList);
      // 通知消息被删除
      EventBus.create().emit(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "delete"), message.messageId);
      this.onDeleteMessageResult?.(message.messageId);
    }
  }

  insertMessage(message: ChatKitMessage): void {
    const isInserted = this.conversation?.insertMessage(message.origin);
    if (isInserted) {
      this.dataList.push(message)
    }
  }

  sortMessages(dataList?: ChatKitMessage[]): ChatKitMessage[] {
    let sortArray = this.dataList;
    if (dataList) {
      sortArray = dataList;
    }
    sortArray.sort((a, b) => {
      let sortByServerTime = uikit.sdk.getOptions()?.isSortMessageByServerTime() ?? true
      return sortByServerTime ? a.serverTimestamp - b.serverTimestamp : a.localTimestamp - b.localTimestamp
    });
    // 如果是传入的数据，则返回其排序的数组
    if (dataList) {
      return sortArray;
    }
    // 如果没有传入数据，则对 this.dataList 进行排序，并返回。
    this.dataList = sortArray;
    return sortArray;
  }

  markAllMessagesAsRead(): void {
    this.conversation?.markAllMessagesAsRead();
    mentionManager.removeTarget(this.conversationId);
    // 通知对应的会话进行刷新。
    EventBus.global().emit(getEventStr(KitConstants.EVENTBUS_CONV_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION), this.conversationId);
  }

  ackConversationRead(isCheckUnreadCount?: boolean | undefined): void {
    // 检查是否需要接收方已读确认
    if (!uikit.sdk.getOptions()?.isRequireReadAck()) {
      return;
    }
    if (isCheckUnreadCount === undefined) {
      isCheckUnreadCount = true
    }
    let hasUnread = true;
    if (isCheckUnreadCount) {
      let unreadCount = uikit.sdk.chatManager()?.getConversation(this.conversationId)?.getUnreadMsgCount();
      if (unreadCount) {
        hasUnread = unreadCount > 0;
      }
    }
    if (hasUnread) {
      uikit.sdk.chatManager()?.ackConversationRead(this.conversationId);
    }
  }

  ackMessageRead(message: ChatMessage, isCheckMedia?: boolean): void {
    if (isSender(message)) {
      return;
    }
    // 检查是否需要接收方已读确认
    if (!uikit.sdk.getOptions()?.isRequireReadAck()) {
      return;
    }
    // 检查消息是否已经发送过已读回执
    if (message.isReceiverRead()) {
      return;
    }
    if (isCheckMedia === undefined) {
      isCheckMedia = true;
    }
    if (isCheckMedia && isMediaMessage(message)) {
      return;
    }
    uikit.sdk.chatManager()?.ackMessageRead(message.getConversationId(), message.getMsgId());
  }

  downloadThumbnail(message: ChatMessage) {
    let type = message.getType();
    if (type != ContentType.IMAGE && type != ContentType.VIDEO && type != ContentType.VOICE) {
      ChatLog.e('不是附件消息！messageId: '+message.getMsgId());
      return;
    }
    let callback: ChatCallback = {
      onSuccess: () => {
        this.updateMessage(message.getMsgId());
      }
    }
    message.setMessageStatusCallback(callback);
    if (type === ContentType.IMAGE || type === ContentType.VIDEO) {
      let body = ChatTransfer.revertAttachmentMessageBody(message.getBody());
      if (body?.thumbnail?.thumbnailDownloadStatus !== DownloadStatus.DOWNLOADING) {
        ChatClient.getInstance().chatManager()?.downloadThumbnail(message);
      }
    } else if (type === ContentType.VOICE) {
      if (message.getBody() instanceof VoiceMessageBody) {
        if ((message.getBody() as VoiceMessageBody).getDownloadStatus() !== DownloadStatus.DOWNLOADING) {
          ChatClient.getInstance().chatManager()?.downloadAttachment(message);
        }
      }
    }
  }

  updateMessage(messageId: string, newMsg?: ChatMessage | undefined): void {
    if (newMsg) {
      update(messageId, new ChatKitMessage(newMsg), this.dataList);
    } else {
      update(messageId, this.dataList);
    }
  }

  scrollToLatest(): void {
    setTimeout(() => {
      this.listScroller.scrollEdge(Edge.Bottom);
    })
  }

  scrollToTarget(target: number, smooth?: boolean, align?: ScrollAlign, options?: ScrollToIndexOptions) {
    setTimeout(() => {
      this.listScroller.scrollToIndex(target, smooth, align, options);
    })
  }

  scrollToTargetMessage(msgId: string, start: number, end: number, loadMore: boolean = true) {
    let position = this.dataList.findIndex(item => item.messageId === msgId);
    if (position == -1) {
      // 从本地数据库中查找，需要加载前200条即可，如果找到则滑动，如果没有找到，则不动
      if (!this.isFetchMessagesFromServer && loadMore) {
        ChatRepo.loadMoreMessages(this.conversation!, this.cursorOrStartMsgId, 200).then(result => {
          this.isRefreshing = false;
          if (result.length > 0) {
            this.cursorOrStartMsgId = result[0].messageId;
            this.dataList.unshift(...result);
            // 保持原位置，防止加载的数据中没有目标数据
            this.scrollToTarget(start + result.length);
            // 递归一次
            this.scrollToTargetMessage(msgId, start + result.length, end + result.length, false);
          }
        })
      }
    } else {
      console.log('position: '+position)
      if (!loadMore || (position < start || position > end)) {
        this.scrollToTarget(position)
      }
      // 背景变化
      this.dataList[position].isReplyResponse = true;
    }
  }

  private checkConversation(method: string): boolean {
    if (this.conversation) {
      return true;
    }
    this.errorInfo = ErrorInfo.create(method, "conversation is undefined.", ChatError.INVALID_PARAM);
    return false;
  }

}


// Basic implementation of IDataSource to handle data listener
export class MessageDataSource implements IDataSource {
  messageData: ChatKitMessage[] = [];
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return this.messageData.length;
  }

  public getData(index: number): ChatKitMessage {
    return this.messageData[index];
  }

  /**
   * 添加数据到指定位置
   * @param index
   * @param data
   */
  public push(index: number, data: ChatKitMessage);
  /**
   * 添加数据
   * @param data
   */
  public push(data: ChatKitMessage);
  public push(indexOrData: ChatKitMessage | number, data?: ChatKitMessage): void {
    if (typeof indexOrData === 'number') {
      this.messageData.splice(indexOrData, 0, data!);
      this.notifyDataAdd(indexOrData);
    } else {
      this.messageData.push(indexOrData);
      this.notifyDataAdd(this.messageData.length - 1);
    }
  }

  /**
   * 添加数据到数据开始的位置。
   * @param data
   */
  public unshift(data: ChatKitMessage): void {
    this.messageData.unshift(data);
    this.notifyDataAdd(0);
  }

  /**
   * 添加数据数组到数据开始的位置
   * @param data
   */
  public unshiftList(data: ChatKitMessage[]): void {
    this.messageData.unshift(...data);
    this.notifyDatasetAdd(0, data.length);
  }

  /**
   * 设置数据
   * @param data
   */
  public setData(data: ChatKitMessage[]): void {
    this.messageData = data;
  }

  /**
   * 添加数据数组
   * @param data
   */
  public pushList(data: ChatKitMessage[]): void {
    data.forEach(element => {
      this.messageData.push(element);
    });
    this.notifyDataAdd(this.messageData.length - 1);
  }

  /**
   * 删除数据
   * @param msgId
   */
  public delete(msgId: string) {
    this.messageData.forEach((msg, index, msgList) => {
      if (msgId === msg.origin.getMsgId()) {
        this.messageData.splice(index, 1)
        this.notifyDataDelete(index)
        return
      }
    })
  }

  public getMessageList(): ChatKitMessage[] {
    return this.messageData;
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.CHANGE, index: index}]);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(
        [{type: DataOperationType.EXCHANGE, index: {start: from, end: to}}]);
    })
  }

  // 通知LazyForEach组件指定数据发生改变
  notifyDatasetAdd(index: number, count: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{
        type: DataOperationType.ADD,
        index: index,
        count: count
      }]);
    })
  }
}