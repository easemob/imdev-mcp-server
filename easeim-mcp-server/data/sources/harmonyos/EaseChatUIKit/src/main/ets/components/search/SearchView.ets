import { emptyDataBuilder } from '../../shares/builders/CommonBulders';
import { KitCallback } from '../../interfaces/CommonCallback';
import { BaseConvListViewModel, ConvListViewModel } from '../../viewmodels/ConvListViewModel';
import { ChatKitConversation } from '../../../../../Index';
import { ConversationSearchItemView } from '../conversation/ConversationComponents';
import { resizeSoftware } from '../../internal/utils/UIKitUtils';
import { BaseContactListViewModel, ContactListViewModel } from '../../viewmodels/ContactViewModel';
import { ChatKitContact } from '../../model/ChatKitContact';
import { ContactItemView } from '../contact/ContactComponents';
import { SearchInput } from '../../shares/components/CommonComponents';

@ComponentV2
export struct SearchConversationView {
  @Param viewModel: BaseConvListViewModel = new ConvListViewModel();
  @Event onSubmit: KitCallback<string> = (value) => {
    this.viewModel.searchConversations(value);
  }
  @Event onBackPress: KitCallback;
  @Event onItemClick: KitCallback<ChatKitConversation>;
  private keyword: string = '';

  aboutToAppear(): void {
    resizeSoftware(getContext(this))
  }

  build() {
    Column() {

      SearchInput({
        onChange: (value) => {
          this.keyword = value;
          this.onSubmit(value);
        },
        onSubmit: (value) => {
          this.keyword = value;
          this.onSubmit(value);
        },
        onBackPress: () => {
          this.onBackPress();
        }
      })

      if (this.viewModel.dataList.length > 0) {
        List() {
          Repeat<ChatKitConversation>(this.viewModel.dataList)
            .each((obj: RepeatItem<ChatKitConversation>) => {
              ListItem() {
                ConversationSearchItemView({
                  conversation: obj.item,
                  keyword: this.keyword
                })
              }
              .onClick(() => {
                this.onItemClick(obj.item);
              })
            })
            .virtualScroll()
            .key((item: ChatKitConversation) => {
              return item.conversationId;
            })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        emptyDataBuilder();
      }

    }
    .width('100%')
    .height('100%')
  }
}

@ComponentV2
export struct SearchContactView {
  @Param viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Event onSubmit: KitCallback<string> = (value) => {
    this.viewModel.searchContacts(value);
  }
  @Event onBackPress: KitCallback;
  @Event onItemClick: KitCallback<ChatKitContact>;
  @Local keyword: string = '';
  /**
   * 是否是选择模式。
   */
  @Param isCheckModel: boolean = false;
  @Param cancelText: ResourceStr = $r('app.string.cancel');

  @Param dividerVisible: boolean = false;

  aboutToAppear(): void {
    resizeSoftware(getContext(this))
  }

  build() {
    Column() {
      SearchInput({
        onChange: (value) => {
          this.keyword = value;
          this.onSubmit(value);
        },
        onSubmit: (value) => {
          this.keyword = value;
          this.onSubmit(value);
        },
        onBackPress: () => {
          this.onBackPress();
        },
        cancelText: {
          content: this.cancelText
        }
      })

      if (this.viewModel.searchResult.length > 0) {
        List() {
          Repeat<ChatKitContact>(this.viewModel.searchResult)
            .each((obj: RepeatItem<ChatKitContact>) => {
              ListItem() {
                ContactItemView({
                  contact: obj.item,
                  isSearchStyle: true,
                  keyword: this.keyword,
                  isCheckModel: this.isCheckModel,
                  dividerVisible: this.dividerVisible
                })
              }
              .onClick(() => {
                this.onItemClick(obj.item);
              })
            })
            .virtualScroll()
            .key((item: ChatKitContact) => {
              return item.id;
            })
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        emptyDataBuilder();
      }

    }
    .width('100%')
    .height('100%')
  }
}