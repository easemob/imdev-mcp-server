import { KitCallback } from '../../interfaces/CommonCallback';
import { TextModel } from '../../model/builder/ComponentModel';
import { ChatKitContact, ContactsGroup } from '../../model/ChatKitContact';
import { ItemBackgroundAttributeModifier } from '../../shares/attributeModifiers/ItemAttributeModifier';
import { TextLabelLargeAttributeModifier } from '../../shares/attributeModifiers/TextAttributeModifiers';
import { searchBuilder } from '../../shares/builders/CommonBulders';
import { getString } from '../../utils/CommonUtils';
import { BaseContactListViewModel, ContactListViewModel } from '../../viewmodels/ContactViewModel';
import { contactItemHeader } from './ContactBuilders';
import { ContactItemView } from './ContactComponents';

@ComponentV2
export struct ContactListView {
  @Param viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Event onItemClick: KitCallback<ChatKitContact>;
  /**
   * 是否展示搜索组件
   */
  @Param showSearchView: boolean = true;
  @Param searchViewHint: ResourceStr = $r('app.string.placeholder_search_contact');
  @BuilderParam searchBuilder: (onClick: KitCallback, textParam: TextModel) => void = searchBuilder;
  @BuilderParam moreActionBuilder?: (onClick: KitCallback<number>) => void;
  @Event onSearchClick: KitCallback;
  @Event onMoreActionClick: KitCallback<number>;
  private scroller: ListScroller = new ListScroller();
  @Local selectedIndex: number = 0;
  @Local alphabets: string[] = [];
  /**
   * 是否是选择模式。
   */
  @Param isCheckModel: boolean = false;

  aboutToAppear(): void {
    this.viewModel.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisAppear();
  }

  build() {
    Column() {
      if (this.showSearchView) {
        this.searchBuilder(this.onSearchClick, {content: this.searchViewHint})
      }
      Stack({ alignContent: Alignment.End }) {
        List({scroller: this.scroller}) {
          if (this.moreActionBuilder) {
            this.moreActionBuilder(this.onMoreActionClick)
          }
          Repeat<ContactsGroup>(this.viewModel.dataList)
            .each((obj: RepeatItem<ContactsGroup>) => {
              ListItemGroup({header: contactItemHeader({content: obj.item.key})}) {
                if (obj.item.contacts) {
                  Repeat<ChatKitContact>(obj.item.contacts)
                    .each((item: RepeatItem<ChatKitContact>) => {
                      ListItem() {
                        ContactItemView({
                          contact: item.item,
                          isCheckModel: this.isCheckModel,
                          dividerVisible: true
                        })
                      }
                      .onClick(() => {
                        this.onItemClick(item.item);
                      })
                    })
                    .key((item) => {
                      return item.id;
                    })
                }
              }
            })
            .key((item, index) => {
              return item.key;
            })
            .virtualScroll()

          if (this.viewModel.allLocalContacts.length > 0) {
            ListItem() {
              Row() {
                Text(getString($r('app.string.contact_list_count'), this.viewModel.allLocalContacts.length))
                  .fontColor($r('app.color.chat_color_text_tertiary'))
                  .margin(19)
                  .attributeModifier(new TextLabelLargeAttributeModifier())
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .attributeModifier(new ItemBackgroundAttributeModifier())
            }
          }
        }
        .scrollBar(BarState.Off)
        .sticky(StickyStyle.Header)
        .onScrollIndex((firstIndex: number, endIndex: number) => {
          if (this.moreActionBuilder) {
            if (firstIndex > 0) {
              this.selectedIndex = firstIndex - 1;
            }
          } else {
            this.selectedIndex = firstIndex;
          }
          this.viewModel.fetchContacts(this.selectedIndex, this.selectedIndex + (endIndex - firstIndex));
        })
        .height('100%')

        // 字母表索引组件
        AlphabetIndexer({ arrayValue: this.viewModel.alphabets, selected: 0 })
          .selectedColor($r('app.color.chat_color_contact_item_side_selected'))
          .selectedBackgroundColor($r('app.color.chat_color_contact_item_side_selected_bg'))
          .selected(this.selectedIndex)
          .font({
            size: 11
          })
          .selectedFont({
            size: 11
          })
          .onSelect((index) => {
            if (this.moreActionBuilder) {
              this.scroller.scrollToIndex(index + 1);
            } else {
              this.scroller.scrollToIndex(index);
            }
          })
      }
      .layoutWeight(1)
    }
  }
}

@ComponentV2
export struct ContactCheckListView {
  @Param viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Event onItemClick: KitCallback<ChatKitContact>;
  @Event onSearchClick: KitCallback;

  build() {
    ContactListView({
      viewModel: this.viewModel,
      isCheckModel: true,
      onItemClick: (item) => {
        item.isChecked = !item.isChecked
        this.onItemClick?.(item);
      },
      onSearchClick: this.onSearchClick
    })
  }
}