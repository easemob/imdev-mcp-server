import { ContactListView } from '../components/contact/ContactListView';
import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { MenuItem } from '../model/Menu';
import { KitCallback } from '../interfaces/CommonCallback';
import { ChatKitContact } from '../model/ChatKitContact';
import { BaseContactListViewModel, ContactListViewModel } from '../viewmodels/ContactViewModel';
import { ChatPageParams, SearchContactPageParams, SearchContactResponseType } from '../model/PageParams';
import { ConversationType } from '@easemob/chatsdk';
import { EventBus, getEventStr, KitConstants } from '../../../../Index';

@ComponentV2
export struct NewConversationPage {
  @Local viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Local titleOperationMenus: MenuItem[] = [];
  @Event onItemClick: KitCallback<ChatKitContact> = (contact) => {
    this.navPathStack?.replacePath({name: "ChatPage", param: {
      conversationId: contact.id,
      conversationType: ConversationType.Chat
    } as ChatPageParams});
  };
  @Event onSearchClick: KitCallback = () => {
    this.navPathStack?.pushPath({name: 'SearchContactPage', param: {
      responseType: SearchContactResponseType.chat,
      isNeedNotify: true,
      isReplacePath: true } as SearchContactPageParams})
  };

  aboutToAppear(): void {
    EventBus.global().on(getEventStr(KitConstants.EVENTBUS_PAGE_FLAG, KitConstants.EVENTBUS_POP_ACTION), (params: string[]) => {
      if (params && params[0] === 'SearchContactPage') {
        this.navPathStack?.removeByName('NewConversationPage');
      }
    })
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          primaryTitle: $r('app.string.new_conversation_page_title'),
          onBackPress: () => {
            this.navPathStack?.pop();
          }
        })
        ContactListView({
          viewModel: this.viewModel,
          onSearchClick: this.onSearchClick,
          onItemClick: this.onItemClick,
          searchViewHint: $r('app.string.search')
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
export function NewConversationPageBuilder() {
  NewConversationPage()
}
