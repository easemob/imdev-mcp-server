import { ChatError, ChatLog, ChatMessage, ChatType, ContentType, TextMessageBody } from '@easemob/chatsdk';
import { ChatInputMenuView, ChatInputReplyView } from '../../components/chat/ChatComponents';
import { MessageItemView } from '../../components/chat/MessageComponents';
import { PermissionManager } from '../../manager/PermissionManager';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import {
  createRecalledMessage,
  getMessageContent,
  getReplyExt,
  isRecalledMessage,
  isReplyMessage,
  isText,
  isUserCardMessage
} from '../../utils/MessageUtil';
import { showToast } from '../../utils/ToastUtil';
import { BaseChatViewModel, ChatViewModel } from '../../viewmodels/ChatViewModel';
import { MenuItem, MessageMenuItem } from '../../model/Menu';
import { KitConstants } from '../../../../../Index';
import { BottomSheetDialogOptions, EditMessageBottomSheetDialogOptions } from '../../model/DialogOptions';
import { bottomSheetDialogBuilder, BottomSheetDialogHelper } from '../../shares/dialogs/BottomSheetDialog';
import { ChatDialog } from '../../shares/dialogs/ChatDialog';
import { kitMedia } from '../../manager/MediaManager';
import { cameraPicker } from '@kit.CameraKit';
import { getFilePath, getRandomFilename, resizeSoftware } from '../../internal/utils/UIKitUtils';
import { BaseMessageViewModel, MessageViewModel } from '../../viewmodels/MessageViewModel';
import {
  defaultChatMessageMenus,
  defaultChatMoreExtendMenus,
  defaultMediaSelectOptions
} from '../../internal/configs/KitDefaultData';
import { editMessageBottomSheetDialogBuilder } from '../../shares/dialogs/EditMessageBottomSheetDialog';
import { ChatPrimaryMenuModel } from '../../model/builder/ChatComponentModel';
import { EventBus, getEventStr } from '../../utils/EventBus';
import { AlertDialog } from '../../shares/dialogs/AlertDialog';
import { GroupMentionBottomSheetDialog } from '../../shares/dialogs/GroupMentionBottomSheetDialog';
import { ContactModel } from '../../model/ContactModel';
import { MessageContent } from '../../model/Message';
import uikit from '../../internal/ChatUIKit';
import { ShowVideoDialog } from '../../shares/dialogs/ShowVideoDialog';
import { ShowBigImageDialog } from '../../shares/dialogs/ShowBigImageDialog';
import { ChatKitContact } from '../../model/ChatKitContact';
import { copyToPasteboard } from '../../utils/PasteboardUtils';
import { MessageUnsentView } from './bubbles/MessageUnsentView';
import { messageProviderManager } from '../../internal/manager/ChatMessageManager';

@ComponentV2
export struct ChatView {
  @Require @Param conversationId: string = '';
  @Require @Param chatType: ChatType = ChatType.Chat;
  /**
   * 如果要进行页面跳转，需要传入 NavPathStack 参数。
   */
  @Param pathStack?: NavPathStack = undefined;
  // 消息列表相关viewModel
  @Param viewModel: BaseChatViewModel = new ChatViewModel(this.conversationId, this.chatType);
  // 消息发送相关viewModel
  @Param messageViewModel: BaseMessageViewModel = new MessageViewModel(this.conversationId, this.chatType);
  @Monitor('viewModel.errorInfo')
  onError(monitor: IMonitor) {
    showToast({message: this.viewModel.errorInfo?.errorMessage ?? "Error happened"})
  }
  @Local refreshState: RefreshStatus = RefreshStatus.Inactive;
  @Local refreshOffset: number = 0;
  @Local listScrollSnapAlign: ScrollSnapAlign = ScrollSnapAlign.END;
  @Local replyMessage?: ChatKitMessage;
  @Monitor('replyMessage')
  onReplyStyleChange(monitor: IMonitor) {
    this.isReplyStyle = this.replyMessage !== undefined
  }
  @Param privateMenuModel: ChatPrimaryMenuModel = new ChatPrimaryMenuModel();
  private mediaTypeSelectDialogId: string = '';
  @Param mediaTypeSelectDialogWrapper: WrappedBuilder<[BottomSheetDialogOptions]> = wrapBuilder(bottomSheetDialogBuilder)
  @Param mediaTypeSelectDialogOptions: BottomSheetDialogOptions = defaultMediaSelectOptions((id: string | number) => {
    this.dealWithDefaultMediaSelectOptions(id);
  })
  private editMessageDialogId: string = '';
  @Param editMessageDialogWrapper: WrappedBuilder<[EditMessageBottomSheetDialogOptions]> = wrapBuilder(editMessageBottomSheetDialogBuilder)
  @Param editMessageDialogOptions: EditMessageBottomSheetDialogOptions = {
    alignment: DialogAlignment.Bottom,
    autoCancel: true,
    onEditChange: (messageId: string | undefined, value: string) => {
      if (messageId) {
        let newBody = new TextMessageBody(value);
        this.messageViewModel.editMessage(messageId, newBody);
      }
    },
  }
  private visibleStartIndex: number = -1;
  private visibleEndIndex: number = -1;
  private declare eventBus: EventBus;
  private isChatInputMenuViewAppear: boolean = false;
  private preTouchY: number = -1;
  /**
   * 自定义扩展项。
   */
  @Param extendMenus: MenuItem[] = defaultChatMoreExtendMenus((id: string | number) => {
    this.onExtendMenuClick?.(id);
  });
  /**
   * 点击录音按钮的事件。
   */
  @Event onRecordClick: (callback: (isPermissionRecordGranted: boolean) => void) => void = (callback) => {
    PermissionManager.requestPermissions(getContext(), ['ohos.permission.MICROPHONE']).then((result) => {
      callback(result.authResults[0] === 0);
    })
  };
  /**
   * 默认自定义扩展项点击事件。
   */
  @Event onExtendMenuClick: (id: string | number) => void = (id) => {
    this.performExtendMenu(id);
  };
  @Provider('group_member_at_user') selectedMember?: ContactModel;
  /**
   * 群聊中在输入框中输入@后的事件提供者
   */
  @Provider('is_at_input') onAtInput: () => void = () => {
    if (this.chatType === ChatType.GroupChat) {
      this.openGroupMentionDialog();
    }
  };
  /**
   * 点击多媒体消息条目的事件提供者，这些多媒体需要点击后才发送已读ack。
   */
  @Provider("click_media_message") onMediaClick: (message: ChatKitMessage) => void = message => {
    this.viewModel.ackMessageRead(message.origin, false);
  };
  @Provider("is_reply_style") isReplyStyle: boolean = false;
  @Event messageItemMenusProvider: (message: ChatKitMessage) => MessageMenuItem[] = (message: ChatKitMessage) => {
    return defaultChatMessageMenus(message, (id, message) => {this.dealWithDefaultMessageItemMenusAction(id, message)})
  };
  /**
   * 从 messageItemMenusProvider 中拿到外界或者默认的消息条目长按的菜单项
   */
  @Provider("message_item_menus_provider") messageItemMenusInnerProvider: (message: ChatKitMessage) => MessageMenuItem[] = (message: ChatKitMessage) => {
    return this.messageItemMenusProvider(message);
  }
  /**
   * 点击回复消息中的回复部分组件的响应事件
   */
  @Provider('on_click_message_reply') onMessageReplyClick: (messageId: string) => void = messageId => {
    let message = uikit.sdk.chatManager()?.getMessage(messageId);
    if (message) {
      if (message.getType() === ContentType.IMAGE) {
        kitMedia.openImageDialog(new CustomDialogController({
          builder: ShowBigImageDialog({
            messageId: messageId
          }),
          cornerRadius: 0,
          alignment: DialogAlignment.Center,
          backgroundColor: Color.Black,
          backgroundBlurStyle: BlurStyle.NONE,
          height: '100%',
          width: '100%',
          customStyle: true
        }));
        return;
      } else if (message.getType() === ContentType.VIDEO) {
        kitMedia.openVideoDialog(new CustomDialogController({
          builder: ShowVideoDialog({
            messageId: messageId
          }),
          cornerRadius: 0,
          alignment: DialogAlignment.Center,
          backgroundColor: Color.Black,
          backgroundBlurStyle: BlurStyle.NONE,
          height: '100%',
          width: '100%',
          customStyle: true
        }));
        return;
      }
      (this.viewModel as ChatViewModel)?.scrollToTargetMessage(messageId, this.visibleStartIndex, this.visibleEndIndex);
    }
  }
  @Event onErrorIconClick: (message: ChatKitMessage) => void = message => {
    this.showResendDialog(message);
  };
  /**
   * 点击发送失败图标的事件提供者
   */
  @Provider('on_error_icon_click') onErrorInnerIconClick: (message: ChatKitMessage) => void = this.onErrorIconClick;
  @Event onItemClick?: (message: ChatKitMessage) => boolean = message => {
    if (isUserCardMessage(message.origin)) {
      return true;
    }
    return false;
  };
  @Provider('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean = this.onItemClick;

  aboutToAppear(): void {
    resizeSoftware(getContext(this));
    this.eventBus = EventBus.create();
    this.viewModel.aboutToAppear();
    this.viewModel.onDeleteMessageResult = () => {
      this.delayResetScrollSnapAlign();
    }
    this.viewModel.onRecallMessageResult = () => {
      this.delayResetScrollSnapAlign();
    }
    this.viewModel.onReceivedMessage = () => {
      this.changeScrollSnapAlign(ScrollSnapAlign.END);
    }
    this.messageViewModel.onMessageSent = (message: ChatMessage) => {
      this.changeScrollSnapAlign(ScrollSnapAlign.END);
      this.viewModel.dataList.push(new ChatKitMessage(message));
      if (isReplyMessage(message)) {
        this.replyMessage = undefined;
      }
      this.viewModel.scrollToLatest();
    }
    this.messageViewModel.onMessageSendSuccess = (oldMsgId, message: ChatMessage) => {
      ChatLog.d('update messages');
      this.viewModel.updateMessage(oldMsgId, message);
    }
    this.messageViewModel.onMessageSendFailed = (messageId: string, error: ChatError) => {
      this.viewModel.updateMessage(messageId);
    }
    this.messageViewModel.onMessageProgress = (message, progress) => {
      if (progress != 100) {
        this.viewModel.updateMessage(message.getMsgId());
      }
    }
    this.messageViewModel.onEditSuccess = (message: ChatMessage) => {
      ChatLog.d('edit after msgId: '+message.getMsgId());
      this.viewModel.updateMessage(message.getMsgId());
    }
    this.messageViewModel.onEditError = (messageId: string, error: ChatError) => {

    }
    this.messageViewModel.onWillSendMessage = (message: ChatMessage) => {
      if (isText(message) && this.replyMessage) {
        message.setJsonAttribute(KitConstants.REPLY_MSG_QUOTE, getReplyExt(this.replyMessage));
      }
    }
    let globalEvent = EventBus.global();
    globalEvent.on(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "recall"), (params: ChatMessage[]) => {
      params.forEach(item => {
        if (item.getConversationId() === this.conversationId) {
          this.viewModel.updateMessage(item.getMsgId(), createRecalledMessage(item));
        }
      })
    })
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisAppear()
    this.closeMediaTypeSelectDialog()
  }

  private performExtendMenu(id: string | number) {
    if (id === KitConstants.EXTEND_ACTION_CAMERA) {
      this.openMediaTypeSelectDialog();
    } else if (id === KitConstants.EXTEND_ACTION_IMAGE) {
      kitMedia.callImageOrVideoPicker(getContext()).then((result) => {
        if (typeof result === 'string') {
          this.messageViewModel.sendImageMessage(result);
        } else {
          if (result.photo) {
            this.messageViewModel.sendImageMessage(result.photo.uri);
          } else if (result.video) {
            this.messageViewModel.sendVideoMessage(result.video.uri, result.video.duration ?? 0);
          }
        }
      })
    } else if (id === KitConstants.EXTEND_ACTION_FILE) {
      kitMedia.callFilePicker(this.conversationId).then((result) => {
        this.messageViewModel.sendFileMessage(result)
      })
    } else if (id === KitConstants.EXTEND_ACTION_USER) {
      this.pathStack?.pushPath({name: "ShareContactPage", param: this.conversationId, onPop: (result) => {
        let contact = result.result as ChatKitContact;
        if (contact) {
          this.messageViewModel.sendUserCard(contact);
        }
      }})
    }
  }

  private openMediaTypeSelectDialog() {
    if (!ChatDialog.isExist(this.mediaTypeSelectDialogId)) {
      this.mediaTypeSelectDialogId = BottomSheetDialogHelper.createDialog(this.getUIContext(), this.mediaTypeSelectDialogOptions, this.mediaTypeSelectDialogWrapper)
    }
    BottomSheetDialogHelper.openDialog(this.mediaTypeSelectDialogId);
  }

  private closeMediaTypeSelectDialog() {
    BottomSheetDialogHelper.closeDialog(this.mediaTypeSelectDialogId);
  }

  private openEditMessageDialog() {
    if (!ChatDialog.isExist(this.editMessageDialogId)) {
      this.editMessageDialogId = BottomSheetDialogHelper.createDialog(this.getUIContext(), this.editMessageDialogOptions, this.editMessageDialogWrapper)
    }
    BottomSheetDialogHelper.openDialog(this.editMessageDialogId);
  }

  private openGroupMentionDialog() {
    GroupMentionBottomSheetDialog.show(this.getUIContext(), {
      groupId: this.conversationId,
      alignment: DialogAlignment.Bottom,
      autoCancel: true,
      onItemClick: (index, value) => {
        this.selectedMember = value as ContactModel;
      }
    })
  }

  private showDeleteMessageDialog(message : ChatKitMessage) {
    AlertDialog.show(this.getUIContext(), {
      title: {
        content: $r('app.string.chat_message_delete_dialog_title')
      },
      content: {
        content: $r('app.string.chat_message_delete_dialog_content')
      },
      cornerRadius: $r('app.float.corner_radius_small'),
      alignment: DialogAlignment.Center,
      cancelButton: {
        content: $r('app.string.cancel')
      },
      confirmButton: {
        content: $r('app.string.confirm')
      },
      onAction: (action: number, content: string) => {
        if (action === 1) {
          this.changeScrollSnapAlign(ScrollSnapAlign.NONE);
          this.viewModel.deleteMessage(message);
        }
      }
    })
  }

  private showRecallMessageDialog(message : ChatKitMessage) {
    AlertDialog.show(this.getUIContext(), {
      title: {
        content: $r('app.string.chat_message_recall_dialog_title')
      },
      cornerRadius: $r('app.float.corner_radius_small'),
      alignment: DialogAlignment.Center,
      cancelButton: {
        content: $r('app.string.cancel')
      },
      confirmButton: {
        content: $r('app.string.confirm')
      },
      onAction: (action: number, content: string) => {
        if (action === 1) {
          this.changeScrollSnapAlign(ScrollSnapAlign.NONE);
          this.viewModel.recallMessage(message);
        }
      }
    })
  }

  private dealWithDefaultMessageItemMenusAction(id: string | number, message : ChatKitMessage) {
    if (typeof id === 'string') {
      if (id === KitConstants.MESSAGE_MENU_ACTION_COPY) {
        if (isText(message.origin)) {
          let msg = getMessageContent(message.origin);
          copyToPasteboard(msg);
        }
      } else if (id === KitConstants.MESSAGE_MENU_ACTION_REPLY) {
        this.replyMessage = message;
        // 切换为文本输入模式
        this.changeInputType('text_style');
      } else if (id === KitConstants.MESSAGE_MENU_ACTION_FORWARD) {

      } else if (id === KitConstants.MESSAGE_MENU_ACTION_EDIT) {
        console.log('edit before msgId: '+message.messageId)
        if (isText(message.origin)) {
          this.editMessageDialogOptions.content = {
            content: getMessageContent(message.origin)
          }
          this.editMessageDialogOptions.messageId = message.messageId
        }
        this.openEditMessageDialog();
      } else if (id === KitConstants.MESSAGE_MENU_ACTION_REPORT) {

      } else if (id === KitConstants.MESSAGE_MENU_ACTION_DELETE) {
        this.showDeleteMessageDialog(message);
      } else if (id === KitConstants.MESSAGE_MENU_ACTION_RECALL) {
        this.showRecallMessageDialog(message);
      }
    }
  }

  private dealWithDefaultMediaSelectOptions(id: string | number) {
    if (typeof id === 'string') {
      if (id === KitConstants.MEDIA_TYPE_SELECT_ACTION_PHONE) {
        kitMedia.callCameraPicker(getContext(), cameraPicker.PickerMediaType.PHOTO, getFilePath(this.conversationId, getRandomFilename('jpg'))).then((result) => {
          if (result?.photo?.uri) {
            this.messageViewModel.sendImageMessage(result?.photo?.uri);
          }
        }).catch((e: ChatError) => {
          ChatLog.e(e.description);
        })
      } else if (id === KitConstants.MEDIA_TYPE_SELECT_ACTION_VIDEO) {
        kitMedia.callCameraPicker(getContext(), cameraPicker.PickerMediaType.VIDEO, getFilePath(this.conversationId, getRandomFilename('mp4')))
          .then((result) => {
            if (result?.video?.uri) {
              this.messageViewModel.sendVideoMessage(result?.video?.uri, result.video.duration ?? 0);
            }
          }).catch((e: ChatError) => {
          ChatLog.e(e.description);
        })
      }
    }
  }

  private delayResetScrollSnapAlign() {
    setTimeout(() => {
      this.changeScrollSnapAlign(ScrollSnapAlign.END);
    }, 1000)
  }

  private changeInputType(style: string = 'default_style') {
    this.eventBus?.emit(getEventStr(KitConstants.EVENTBUS_INPUT_FLAG, style));
  }

  private changeScrollSnapAlign(scrollSnapAlign: ScrollSnapAlign) {
    if (this.listScrollSnapAlign != scrollSnapAlign) {
      this.listScrollSnapAlign = scrollSnapAlign;
    }
  }

  private showResendDialog(message: ChatKitMessage) {
    AlertDialog.show(this.getUIContext(), {
      title: {
        content: $r('app.string.chat_message_resend_title')
      },
      cornerRadius: $r('app.float.corner_radius_small_extra'),
      alignment: DialogAlignment.Center,
      cancelButton: {
        content: $r('app.string.cancel')
      },
      confirmButton: {
        content: $r('app.string.confirm')
      },
      onAction: (action: number, content: string) => {
        if (action === 1) {
          this.messageViewModel.resendMessage(message.origin, ()=>{}, ()=> {
            setTimeout(() => {
              this.viewModel.sortMessages();
            }, 100)
          });
        }
      }
    })
  }

  build() {
    Column() {
      Refresh({refreshing: $$this.viewModel.isRefreshing}) {
        List({scroller: this.viewModel.listScroller}) {
          Repeat<ChatKitMessage>(this.viewModel.dataList)
            .each((obj: RepeatItem<ChatKitMessage>) => {})
            .virtualScroll()
            .template('default', (obj: RepeatItem<ChatKitMessage>) => {
              ListItem() {
                MessageItemView({
                  message: obj.item,
                })
              }
            }, { cachedCount: 7 })
            .template('extend', (obj: RepeatItem<ChatKitMessage>) => {
              ListItem() {
                if (messageProviderManager.hasCustomItemNode(obj.item)) {
                  NodeContainer(messageProviderManager.provideMessageItemNodeController(this.getUIContext(), obj.item))
                } else {
                  MessageUnsentView({
                    message: obj.item,
                  })
                }
              }
            }, { cachedCount: 3 })
            .templateId((item: ChatKitMessage, index: number) => {
              if (messageProviderManager.hasCustomItemNode(item) || isRecalledMessage(item.origin)) {
                return 'extend';
              }
              return 'default';
            })
            .key((item: ChatKitMessage, index: number) => {
              return item.uuid;
            })
        }
        .onClick(()=> {
          this.changeInputType();
        })
        .onScrollIndex((start: number, end: number) => {
          this.visibleStartIndex = start;
          this.visibleEndIndex = end;
        })
        .onWillScroll((scrollOffset: number, scrollState: ScrollState, scrollSource: ScrollSource)=> {
          if (scrollSource === ScrollSource.DRAG) {
            this.changeScrollSnapAlign(ScrollSnapAlign.NONE);
          }
        })
        .onTouch((event) => {
          if (event.type === TouchType.Move) {
            let touchY = event.touches[0].y;
            if (this.preTouchY === -1) {
              this.preTouchY = touchY;
            }
            if (Math.abs(touchY - this.preTouchY) > 10) {
              this.changeInputType();
              this.preTouchY = -1;
            }
          }
        })
        .cachedCount(4)
        .scrollSnapAlign(this.listScrollSnapAlign)
        .maintainVisibleContentPosition(true)
        .divider({
          strokeWidth: 16,
          color: Color.Transparent
        })
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .layoutWeight(1)
      .refreshOffset(60)
      .pullToRefresh(true)
      .onRefreshing(() => {
        this.viewModel.getMoreMessages();
      })

      if (this.replyMessage) {
        ChatInputReplyView({
          message: this.replyMessage,
          onReplyClear: () => {
            this.replyMessage = undefined
          }
        })
      }

      ChatInputMenuView({
        conversationId: this.conversationId,
        primaryMenuModel: this.privateMenuModel,
        extendMenus: this.extendMenus,
        onClickSend: (content: MessageContent) => {
          this.messageViewModel.sendTextMessage(content);
        },
        onClickRecord: this.onRecordClick,
        onClickRecordSend: (voicePath: string | undefined, duration: number) => {
          if (voicePath) {
            this.messageViewModel.sendVoiceMessage(voicePath, duration)
          }
        },
        onClickText: () => {
          this.viewModel.scrollToLatest();
        },
        onExtendMenuClick: this.onExtendMenuClick
      })
        .onAppear(()=> {
          this.isChatInputMenuViewAppear = true;
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          if (this.isChatInputMenuViewAppear) {
            this.viewModel.scrollToTarget(this.viewModel.dataList.length - 1, true, ScrollAlign.END);
          }
        })
    }
  }
}