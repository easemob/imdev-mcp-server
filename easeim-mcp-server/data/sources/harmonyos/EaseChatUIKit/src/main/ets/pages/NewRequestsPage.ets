import { ChatUser } from '../internal/model/ChatUser';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';
import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { MenuItem } from '../model/Menu';
import { defaultContactListOperationMenus } from '../internal/configs/KitDefaultData';
import { KitConstants } from '../../../../Index';
import { KitCallback } from '../interfaces/CommonCallback';
import { ChatKitContact } from '../model/ChatKitContact';
import { ConversationType } from '@easemob/chatsdk';
import { ChatPageParams } from '../model/PageParams';
import { NewRequestListView } from '../components/invitation/NewRequestListView';

@ComponentV2
export struct NewRequestsPage {
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
  @Event onBackPress?: () => void = () => {
    this.navPathStack?.pop();
  };
  @Event onItemClick: KitCallback<ChatKitContact> = (contact) => {
    this.navPathStack?.pushPath({name: "ChatPage", param: {
      conversationId: contact.id,
      conversationType: ConversationType.Chat
    } as ChatPageParams
    })
  };

  showAddContactDialog() {
    this.navPathStack?.pushPath({name: "AddContactDialogPage"});
  }

  aboutToAppear(): void {
    this.currentUser = ChatUserInfoManager.getInstance().getCurrentUser();
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          primaryTitle: $r('app.string.new_request_page_title'),
          operationItem: this.titleOperationMenus,
          moreIcon: $r('app.media.chat_icon_add'),
          overflowMenuWith: 160,
          onBackPress: () => {
            this.onBackPress?.();
          }
        })
        NewRequestListView()
          .layoutWeight(1)
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.chat_color_background'))
    .onReady((context) => {
      if (!this.navPathStack) {
        this.navPathStack = context.pathStack;
      }
    })
  }
}

@Builder
export function NewRequestsPageBuilder() {
  NewRequestsPage()
}
