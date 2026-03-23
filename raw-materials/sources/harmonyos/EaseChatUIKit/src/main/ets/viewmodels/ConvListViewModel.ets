import { ChatTransfer, CommonError } from '../internal/ChatTransfer';
import { ChatKitConversation } from '../model/ChatKitConversation';
import { ErrorInfo } from '../model/ErrorInfo';
import { ConversationRepo } from '../repositories/ConversationRepo';
import { BaseListViewModel } from './ChatViewModel';
import {
  ChatError,
  ChatLog,
  ChatMessage,
  ChatMessageListener,
  ConnectionListener,
  Conversation,
  ConversationListener,
  CursorResult,
  RecallMessageInfo
} from '@easemob/chatsdk';
import uikit from '../internal/ChatUIKit';
import { EventBus, getEventStr } from '../utils/EventBus';
import { KitConstants } from '../../../../Index';
import { ConvMenuItem } from '../model/Menu';
import { ChatConvInfoManager } from '../manager/ChatConvInfoManager';

@ObservedV2
export abstract class BaseConvListViewModel extends BaseListViewModel<ChatKitConversation> {
  protected isFetchConvsFromServer: boolean = false;
  protected isRemoveMessagesWhenRemoveConversation: boolean = true;

  constructor(isRemoveMessages: boolean = true) {
    super();
    this.isRemoveMessagesWhenRemoveConversation = isRemoveMessages;
  }

  /**
   * 是否从服务器拉取会话。
   * @param isFetchFromServer
   */
  fetchFromServer(isFetchFromServer: boolean)
  {
    this.isFetchConvsFromServer = isFetchFromServer;
  }

  /**
   * 获取会话列表。
   * @param pageSize
   * @param cursor
   */
  getConversations(pageSize: number = 50, cursor: string = '') {}

  /**
   * 对会话进行排序。
   */
  sortConversations() {}

  /**
   * 设置会话免打扰/取消免打扰
   * @param conv
   * @param isMute
   */
  abstract muteConversation(conv: ChatKitConversation, isMute: boolean);

  /**
   * 设置会话置顶/取消置顶
   * @param conv
   * @param isPin
   */
  abstract pinConversation(conv: ChatKitConversation, isPin: boolean);

  /**
   * 删除会话。
   * 是否从服务器删除会话，需要根据{@link fetchFromServer}方法。
   * @param conv
   */
  abstract deleteConversation(conv: ChatKitConversation);

  /**
   * 在本地搜索会话。
   * @param { string } key
   * @returns { ChatKitConversation[] }
   */
  abstract searchConversations(key: string);

  /**
   * 获取指定的会话条目菜单项。
   * @param menus
   * @param conv
   * @returns
   */
  abstract getTargetMenus(menus: ConvMenuItem[], conv: ChatKitConversation): ConvMenuItem[];

  /**
   * 更新会话条目。
   * @param conv
   */
  abstract updateItem(conv: ChatKitConversation | Conversation | string);
}

export class ConvListViewModel extends BaseConvListViewModel{
  protected pageSize: number = 50;
  protected nextCursor: string = '';
  protected isLoadedData: boolean = false;
  private conversationListener: ConversationListener = {
    onConversationUpdate: () => {

    },
    onConversationRead: (from: string, to: string): void => {
      this.dataList.forEach(item => {
        if (item.conversationId === to) {
          this.updateItem(item);
        }
      })
    }
  }

  private connectionListener: ConnectionListener = {
    onConnected: (): void => {
      if (!this.isLoadedData) {
        this.getConversations();
      }
    },
    onDisconnected: (errorCode: number): void => {

    }
  }

  private messageListener: ChatMessageListener = {
    onMessageReceived: (messages: Array<ChatMessage>) => {
      this.getConversations();
    },
    onMessageChanged: (message: ChatMessage) => {

    },
    onMessageRecalled: (recallInfo: RecallMessageInfo[]) => {
      this.getConversations();
    },
    onMessageContentChanged: (modifiedMessage: ChatMessage, operatorId: string, operationTime: number) => {
      this.dataList.forEach(item => {
        if (item && item.latestMessage && item.latestMessage.getMsgId() === modifiedMessage.getMsgId()) {
          this.updateItem(item);
        }
      })
    }
  }

  aboutToAppear(): void {
    uikit.sdk.addConnectionListener(this.connectionListener);
    uikit.sdk.chatManager()?.addConversationListener(this.conversationListener);
    uikit.sdk.chatManager()?.addMessageListener(this.messageListener);
    EventBus.global().on(getEventStr(KitConstants.EVENTBUS_CONV_FLAG, KitConstants.EVENTBUS_UPDATE_ACTION), (params: string[]) => {
      ChatLog.d('conversation: outside update from eventbus: '+params);
      if (params) {
        if (params.length > 0) {
          this.updateItem(params[0]);
        } else {
          this.getConversations();
        }
      }
    })
    this.getConversations();
  }

  aboutToDisAppear(): void {
    uikit.sdk.removeConnectionListener(this.connectionListener);
    uikit.sdk.chatManager()?.removeConversationListener(this.conversationListener);
    uikit.sdk.chatManager()?.removeMessageListener(this.messageListener);
  }

  async getConversations(pageSize: number = 50, cursor: string = '') {
    if (!uikit.sdk.isLoggedIn()) {
      return;
    }
    this.isLoadedData = true;
    if (this.isFetchConvsFromServer) {
      this.pageSize = pageSize;
      this.nextCursor = cursor;
      let cursorResult: CursorResult<ChatKitConversation> | null;
      let result: ChatKitConversation[] = [];
      do {
        try {
          cursorResult = await ConversationRepo.fetchConversations(this.pageSize, this.nextCursor);
          if (!cursorResult) {
            this.dataList = [];
            this.errorInfo = ErrorInfo.create('fetchConversationsFromServer', ChatError.createError(ChatError.GENERAL_ERROR, "cursorResult is undefined!"));
            break;
          }
        } catch (e) {
          this.errorInfo = ErrorInfo.create('fetchConversationsFromServer', ChatTransfer.transferError(e as CommonError));
          break;
        }
        this.nextCursor = cursorResult.getNextCursor();
        if (result.length === 0) {
          result = cursorResult.getResult();
        } else {
          result.push(...cursorResult.getResult());
        }
      } while (this.nextCursor)
      this.dataList = result;
      if (this.dataList.length > 0) {
        this.sortConversations();
      }
    } else {
      let result = ConversationRepo.getConversations();
      if (!result) {
        this.dataList = [];
        this.errorInfo = ErrorInfo.create('getAllConversationsBySort', ChatError.createError(ChatError.GENERAL_ERROR, "sdk is undefined!"));
        return;
      }
      // 过滤掉默认系统通知内容
      this.dataList = result.filter(conv => {
        return conv.conversationId !== KitConstants.DEFAULT_SYSTEM_CONV_ID;
      });
    }
  }

  sortConversations(): void {
    this.dataList.sort((a, b) => {
      if (!a.latestMessage || !b.latestMessage) {
        return 0; // 如果有最新的消息为空，则不改变相对顺序。
      }
      let sortByServerTime = uikit.sdk.getOptions()?.isSortMessageByServerTime() ?? true
      return sortByServerTime ? b.latestMessage.getServerTimestamp() - a.latestMessage.getServerTimestamp()
        : b.latestMessage.getLocalTimestamp() - a.latestMessage.getLocalTimestamp();
    })
  }

  muteConversation(conv: ChatKitConversation, isMute: boolean): void {
    if (isMute) {
      ConversationRepo.muteConversation(conv.origin).then((result) => {
        this.updateItem(conv.conversationId);
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('muteConversation', ChatTransfer.transferError(e));
      })
    } else {
      ConversationRepo.unmuteConversation(conv.origin).then(() => {
        this.updateItem(conv.conversationId);
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('unmuteConversation', ChatTransfer.transferError(e));
      })
    }
  }

  pinConversation(conv: ChatKitConversation, isPin: boolean): void {
    ConversationRepo.pinConversation(conv.origin, isPin).then(() => {
      this.getConversations();
    })
  }

  deleteConversation(conv: ChatKitConversation): void {
    if (this.isFetchConvsFromServer) {
      ConversationRepo.removeConversationFromServer(conv.origin, this.isRemoveMessagesWhenRemoveConversation).then(() => {
        let index = this.dataList.indexOf(conv);
        if (index > -1) {
          this.dataList.splice(index, 1);
        }
      }).catch((e: ChatError) => {
        this.errorInfo = ErrorInfo.create('removeConversationFromServer', ChatTransfer.transferError(e));
      })
    } else {
      let result = ConversationRepo.deleteConversationFromLocal(conv.origin, this.isRemoveMessagesWhenRemoveConversation);
      if (result) {
        let index = this.dataList.indexOf(conv);
        if (index > -1) {
          this.dataList.splice(index, 1);
        }
      }
    }
  }

  searchConversations(key: string) {
    if (!key) {
      this.dataList = [];
      return;
    }
    let result = ConversationRepo.getConversations();
    let arr: ChatKitConversation[] = [];
    if (result) {
      result.forEach(item => {
        let id = item.conversationId;
        let name = ChatConvInfoManager.getInstance().getConversationName(item.origin);
        if (name.includes(key) || id.includes(key)) {
          arr.push(item);
        }
      })
    }
    this.dataList = arr;
  }

  getTargetMenus(menus: ConvMenuItem[], conv: ChatKitConversation): ConvMenuItem[] {
    const isPinned = conv.isPinned;
    const isMuted = conv.isMuted;
    menus.forEach(item => {
      if (item.id === KitConstants.CONV_MENU_ACTION_PIN) {
        item.enable = !isPinned;
      } else if (item.id === KitConstants.CONV_MENU_ACTION_UNPIN) {
        item.enable = isPinned;
      } else if (item.id === KitConstants.CONV_MENU_ACTION_MUTE) {
        item.enable = !isMuted;
      } else if (item.id === KitConstants.CONV_MENU_ACTION_UNMUTE) {
        item.enable = isMuted;
      } else if (item.id === KitConstants.CONV_MENU_ACTION_DELETE) {
        item.enable = true;
      }
    })
    let target = menus.filter((item) => item.enable);
    return target;
  }

  updateItem(conv: ChatKitConversation | Conversation | string): void {
    let id = '';
    if (typeof conv === 'string') {
      id = conv;
    } else if (conv instanceof ChatKitConversation) {
      id = conv.conversationId
    } else if (conv instanceof Conversation) {
      id = conv.conversationId();
    }
    let index = this.dataList.findIndex((item) => item.conversationId === id);
    if (index != -1) {
      let target = this.dataList[index];
      target.update();
    }
  }
}