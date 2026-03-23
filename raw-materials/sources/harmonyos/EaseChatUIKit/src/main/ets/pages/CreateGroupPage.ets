import { ContactCheckListView } from '../components/contact/ContactListView';
import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { MenuItem } from '../model/Menu';
import { KitCallback } from '../interfaces/CommonCallback';
import { ChatKitContact } from '../model/ChatKitContact';
import ArrayList from '@ohos.util.ArrayList';
import { KitConstants } from '../constants/KitConstants';
import { getString } from '../utils/CommonUtils';
import { BaseContactListViewModel, ContactListViewModel } from '../viewmodels/ContactViewModel';
import { BaseGroupListViewModel, GroupListViewModel } from '../viewmodels/GroupViewModel';
import { ChatError, ConversationType } from '@easemob/chatsdk';
import { ChatPageParams } from '../model/PageParams';
import { showToast } from '../utils/ToastUtil';

@ComponentV2
export struct CreateGroupPage {
  @Local viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Local groupViewModel: BaseGroupListViewModel = new GroupListViewModel();
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Local titleOperationMenus: MenuItem[] = [];
  @Local selectedContact: ArrayList<string> = new ArrayList();
  @Event onItemClick: KitCallback<ChatKitContact> = (contact) => {
    if (contact.isChecked && !this.selectedContact.has(contact.id)) {
      this.selectedContact.add(contact.id);
    } else if (!contact.isChecked && this.selectedContact.has(contact.id)) {
      this.selectedContact.remove(contact.id);
    }
    this.updateMenu();
  };
  @Event onSearchClick: KitCallback = () => {
    this.navPathStack?.pushPath({name: "ContactSearchSelectorPage", param: this.selectedContact, onPop: (result) => {
      let resultParams = result.result as ArrayList<string>;
      if (resultParams && resultParams.length > 0) {
        this.selectedContact = resultParams;
        this.updateContactList();
      }
    }});
  };

  private updateMenu() {
    if (this.selectedContact.length > 0) {
      let menu = {
        id: KitConstants.CREATE_GROUP_PAGE_ACTION + this.selectedContact.length,
        value: getString($r('app.string.create_group_menu_action'), this.selectedContact.length),
        fontColor: $r('app.color.chat_color_create_group_menu_text'),
        action: (id: number | string) => {
          this.createGroup();
        }
      } as MenuItem
      this.titleOperationMenus = [menu];
    } else {
      this.titleOperationMenus = [];
    }
  }

  private updateContactList() {
    if (this.viewModel.dataList) {
      this.viewModel.dataList.forEach(group => {
        if (group.contacts) {
          group.contacts.forEach(contact => {
            contact.isChecked = false;
            if (this.selectedContact.has(contact.id)) {
              contact.isChecked = true;
            }
          })
        }
      })
      this.updateMenu();
    }
  }

  private createGroup() {
    this.groupViewModel.createGroup(this.selectedContact.convertToArray()).then(group => {
      this.navPathStack?.replacePath({name: "ChatPage", param: {
        conversationId: group.groupId(),
        conversationType: ConversationType.GroupChat
      } as ChatPageParams
      })
    }).catch((e: ChatError) => {
      showToast({message: e.description});
    })
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          primaryTitle: $r('app.string.create_group_page_title'),
          operationItem: this.titleOperationMenus,
          onBackPress: () => {
            this.navPathStack?.pop();
          }
        })
        ContactCheckListView({
          viewModel: this.viewModel,
          onSearchClick: this.onSearchClick,
          onItemClick: this.onItemClick
        })
          .layoutWeight(1)
      }
      .height('100%')
    }
    .backgroundColor($r('app.color.chat_color_background'))
    .hideTitleBar(true)
    .onReady((context) => {
      if (!this.navPathStack) {
        this.navPathStack = context.pathStack
      }
    })
  }
}

@Builder
export function CreateGroupPageBuilder() {
  CreateGroupPage()
}
