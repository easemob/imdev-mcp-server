import { ChatMessage, ChatMessageListener, ChatType } from '@easemob/chatsdk';
import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { MenuItem } from '../model/Menu';
import { ChatView } from '../components/chat/ChatView';
import { ChatPageParams } from '../model/PageParams';
import { ChatConvInfoManager } from '../manager/ChatConvInfoManager';
import listenerWrapper from '../internal/wapper/ChatListenersWrapper';

@ComponentV2
export struct ChatPage {
  pathStack: NavPathStack = new NavPathStack();
  @Local conversationId: string = '';
  @Local chatType: ChatType = ChatType.Chat;
  // 标题栏中相关事件回调
  @Event onBackPress?: () => void = () => { this.pathStack.pop() }
  @Event onAvatarClick?: () => void = () => {
    console.log("click avatar")
  };
  @Event onTitleClick?: () => void = undefined;
  @Param pageMenus: MenuItem[] = []
  @Local avatar?: ResourceStr;
  private messageListener: ChatMessageListener = {
    onMessageReceived: (messages: ChatMessage[]): void => {
      messages.forEach(message => {
        if (message.getConversationId() === this.conversationId && this.chatType === ChatType.Chat) {
          this.updateAvatar();
        }
      })
    }
  }

  aboutToAppear(): void {
    listenerWrapper.addMessageChangeListener(this.messageListener);
  }

  aboutToDisappear(): void {
    listenerWrapper.removeMessageChangeListener(this.messageListener);
  }

  private updateAvatar() {
    this.avatar = ChatConvInfoManager.getInstance().getConversationAvatar(this.conversationId, this.chatType as number);
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          primaryTitle: ChatConvInfoManager.getInstance().getConversationName(this.conversationId, this.chatType),
          avatar: this.avatar,
          avatarAlt: this.chatType === ChatType.Chat ? $r('app.media.avatar_default') : $r('app.media.avatar_group_default'),
          onBackPress: () => {
            this.onBackPress?.();
          },
          onTitleClick: () => {
            this.onTitleClick?.();
          },
          onAvatarClick: this.onAvatarClick,
          operationItem: this.pageMenus
        })

        ChatView({
          conversationId: this.conversationId,
          chatType: this.chatType,
          pathStack: this.pathStack
        })
          .layoutWeight(1)

      }
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.chat_color_background'))
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      let params = this.pathStack.getParamByName("ChatPage") as ChatPageParams[]
      if (params) {
        let param = params[0] as ChatPageParams;
        this.conversationId = param.conversationId;
        this.chatType = param.conversationType as number;
        this.updateAvatar();
      } else {
        // 如果没有传参数则关闭当前页面
        this.pathStack.removeByName("ChatPage");
      }
    })
  }
}

@Builder
export function ChatPageBuilder() {
  ChatPage()
}
