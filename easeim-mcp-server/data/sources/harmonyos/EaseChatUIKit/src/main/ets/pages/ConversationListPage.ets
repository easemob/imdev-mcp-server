import { ConvListViewModel } from '../viewmodels/ConvListViewModel';
import { ConversationListView } from '../components/conversation/ConversationListView';
import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { ChatKitConversation } from '../model/ChatKitConversation';
import { ChatUser } from '../internal/model/ChatUser';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { ChatPageParams } from '../model/PageParams';
import { MenuItem } from '../model/Menu';
import { defaultConvOperationMenus } from '../internal/configs/KitDefaultData';
import { KitCallback } from '../interfaces/CommonCallback';
import { KitConstants } from '../constants/KitConstants';
import { ChatLog } from '@easemob/chatsdk';

@ComponentV2
export struct ConversationListPage {
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Param viewModel: ConvListViewModel = new ConvListViewModel();
  @Param hideTitleBar: boolean = false;
  @Param hideBackIcon: boolean = true;
  @Event onItemClick: KitCallback<ChatKitConversation> = (item: ChatKitConversation) => {
    this.navPathStack?.pushPath({name: "ChatPage", param: {
        conversationId: item.conversationId,
        conversationType: item.type
      } as ChatPageParams
    })
  };
  @Param titleOperationMenus: MenuItem[] = defaultConvOperationMenus((id: string | number) => {
    if (typeof id === 'string') {
      if (id === KitConstants.CONV_PAGE_ACTION_NEW_CHAT) {
        this.navPathStack?.pushPath({name: "NewConversationPage"});
      } else if (id === KitConstants.CONV_PAGE_ACTION_ADD_CONTACT) {
        this.navPathStack?.pushPath({name: "AddContactDialogPage"});
      } else if (id === KitConstants.CONV_PAGE_ACTION_CREATE_GROUP) {
        this.navPathStack?.pushPath({name: "CreateGroupPage"});
      }
    }

  });
  @Event onAvatarClick?: () => void = () => {
    ChatLog.d("click avatar");
  };
  @Event onBackPress?: () => void = () => {
    this.navPathStack?.pop();
  };
  @Event onSearchClick: KitCallback = () => {
    this.navPathStack?.pushPath({name: "SearchConversationPage"});
  }

  @Local declare currentUser: ChatUser;

  aboutToAppear(): void {
    this.currentUser = ChatUserInfoManager.getInstance().getCurrentUser();
  }

  build() {
    NavDestination() {
      Column() {
        if (!this.hideTitleBar) {
          ComposeTitleBar({
            icon: this.hideBackIcon ? undefined : $r('app.media.icon_back_arrow'),
            avatar: this.currentUser.avatar ?? $r('app.media.avatar_default'),
            avatarAlt: $r('app.media.avatar_default'),
            titleIcon: $r('app.media.chat_icon_title_chat'),
            titlePosition: HorizontalAlign.Center,
            operationItem: this.titleOperationMenus,
            moreIcon: $r('app.media.chat_icon_add'),
            overflowMenuWith: 160,
            onAvatarClick: this.onAvatarClick,
            onBackPress: this.onBackPress
          })
        }
        ConversationListView({
          viewModel: this.viewModel,
          onItemClick: this.onItemClick,
          onSearchClick: this.onSearchClick
        })
          .layoutWeight(1)
      }
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.chat_color_background'))
    .onReady((context) => {
      if (!this.navPathStack) {
        this.navPathStack = context.pathStack
      }
    })
  }

}

@Builder
export function ConversationListPageBuilder() {
  ConversationListPage()
}


