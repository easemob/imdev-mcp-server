import { ChatUser } from '../internal/model/ChatUser';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { ComposeBadgeListItem, ComposeTitleBar } from '../shares/components/CommonComponents';
import { MenuItem } from '../model/Menu';
import { defaultContactListOperationMenus } from '../internal/configs/KitDefaultData';
import { ContactListView, KitConstants } from '../../../../Index';
import { BaseContactListViewModel, ContactListViewModel } from '../viewmodels/ContactViewModel';
import { KitCallback } from '../interfaces/CommonCallback';
import { ChatKitContact } from '../model/ChatKitContact';
import { ConversationType } from '@easemob/chatsdk';
import { ChatPageParams } from '../model/PageParams';

@ComponentV2
export struct ContactListPage {
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Local declare currentUser: ChatUser;
  @Local titleOperationMenus: MenuItem[] = defaultContactListOperationMenus((id: string | number) => {
    if (typeof id === 'string') {
      if (id === KitConstants.CONTACT_LIST_PAGE_ACTION_ADD_CONTACT) {
        this.showAddContactDialog();
      }
    }
  });
  @Event onAvatarClick?: () => void = () => {
    console.log("click avatar")
  };
  @Param viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Event onItemClick: KitCallback<ChatKitContact> = (contact) => {
    this.navPathStack?.pushPath({name: "ChatPage", param: {
      conversationId: contact.id,
      conversationType: ConversationType.Chat
    } as ChatPageParams
    })
  };
  @Event onSearchClick: KitCallback = () => {
    this.navPathStack?.pushPath({name: "SearchContactPage"});
  };
  @Event onMoreActionClick: KitCallback<number> = (index) => {
    if (index === 0) {
      this.navPathStack?.pushPath({name: "GroupListPage"});
    } else if (index === 1) {
      this.navPathStack?.pushPath({name: "NewRequestsPage"});
    }
  }

  showAddContactDialog() {
    this.navPathStack?.pushPath({name: "AddContactDialogPage"});
  }

  @Builder
  moreActionBuilder(onClick: KitCallback<number>) {
    ListItem() {
      Column() {
        ComposeBadgeListItem({
          title: $r('app.string.new_request'),
          badgeCount: this.viewModel.newRequestCount,
          badgeStyle: {
            color: $r('app.color.chat_color_text_primary_contrary'),
            fontSize: 14,
            badgeColor: $r('app.color.chat_color_primary'),
            borderColor: $r('app.color.chat_color_primary')
          }
        })
          .onClick(() => {
            onClick(1);
          })
        ComposeBadgeListItem({
          title: $r('app.string.group_chat'),
          badgeCount: this.viewModel.joinedGroupCount,
          badgeStyle: {
            color: $r('app.color.chat_color_text_secondary'),
            fontSize: 14,
            badgeColor: Color.Transparent,
            borderColor: Color.Transparent
          }
        })
          .onClick(() => {
            onClick(0);
          })
      }
    }
  }

  aboutToAppear(): void {
    this.currentUser = ChatUserInfoManager.getInstance().getCurrentUser();
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          icon: undefined,
          avatar: this.currentUser.avatar ?? $r('app.media.avatar_default'),
          titleIcon: $r('app.media.chat_icon_title_contact'),
          titlePosition: HorizontalAlign.Center,
          operationItem: this.titleOperationMenus,
          moreIcon: $r('app.media.chat_icon_add'),
          overflowMenuWith: 160,
          onAvatarClick: this.onAvatarClick
        })
        ContactListView({
          viewModel: this.viewModel,
          onSearchClick: this.onSearchClick,
          onItemClick: this.onItemClick,
          moreActionBuilder: this.moreActionBuilder,
          onMoreActionClick: this.onMoreActionClick
        })
          .layoutWeight(1)
      }
      .height('100%')
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
export function ContactListPageBuilder() {
  ContactListPage()
}
