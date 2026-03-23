import { ChatKitConversation, KitConstants } from '../../../../../Index';
import { KitCallback } from '../../interfaces/CommonCallback';
import { defaultConvItemMenus } from '../../internal/configs/KitDefaultData';
import { conversationProviderManager } from '../../internal/manager/ConversationItemManager';
import { ConvMenuItem } from '../../model/Menu';
import { TextTitleMediumAttributeModifier } from '../../shares/attributeModifiers/TextAttributeModifiers';
import { emptyDataBuilder, searchBuilder } from '../../shares/builders/CommonBulders';
import { BaseConvListViewModel, ConvListViewModel } from '../../viewmodels/ConvListViewModel';
import { ConversationItemView } from './ConversationComponents';

@ComponentV2
export struct ConversationListView {
  @Param viewModel: BaseConvListViewModel = new ConvListViewModel();
  @Event onItemClick: KitCallback<ChatKitConversation>;
  @Param itemMenus: ConvMenuItem[] = defaultConvItemMenus((id: string | number, conv: ChatKitConversation) => {
    if (typeof id === 'string') {
      if (id === KitConstants.CONV_MENU_ACTION_MUTE) {
        this.viewModel.muteConversation(conv, true);
      } else if (id === KitConstants.CONV_MENU_ACTION_UNMUTE) {
        this.viewModel.muteConversation(conv, false);
      } else if (id === KitConstants.CONV_MENU_ACTION_PIN) {
        this.viewModel.pinConversation(conv, true);
      } else if (id === KitConstants.CONV_MENU_ACTION_UNPIN) {
        this.viewModel.pinConversation(conv, false);
      } else if (id === KitConstants.CONV_MENU_ACTION_DELETE) {
        this.viewModel.deleteConversation(conv);
      }
    }
  });
  /**
   * 是否展示搜索组件
   */
  @Param showSearchView: boolean = true;
  @Event onSearchClick: KitCallback = () => {

  };
  @BuilderParam searchBuilder: (onClick: KitCallback) => void = searchBuilder;
  @BuilderParam emptyDataBuilder: (onClick?: KitCallback<ClickEvent>) => void = emptyDataBuilder;
  private scroller: ListScroller = new ListScroller()

  aboutToAppear(): void {
    this.viewModel.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisAppear();
  }

  @Builder
  swipeActionBuilder(conv: ChatKitConversation) {
    Row() {
      ForEach(this.viewModel.getTargetMenus(this.itemMenus, conv), (item: ConvMenuItem, index) => {
        Button({type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL}) {
          if (item.icon) {
            Image(item.icon)
              .height(28)
              .width(28)
              .objectFit(ImageFit.Fill)
              .fillColor(item.fontColor ?? $r('app.color.chat_color_conv_item_menu_icon_fillColor'))
          } else {
            Text(item.value)
              .fontColor(item.fontColor)
              .attributeModifier(new TextTitleMediumAttributeModifier())
          }
        }
        .height('100%')
        .padding(24)
        .backgroundColor(item.backgroundColor ?? Color.Transparent)
        .onClick(() => {
          this.scroller.closeAllSwipeActions();
          item.onMenuClick?.(item.id, conv);
        })
      })
    }
    .height('100%')
  }

  build() {
    Column() {
      if (this.showSearchView) {
        this.searchBuilder(this.onSearchClick)
      }
      if (this.viewModel.dataList.length > 0) {
        List({scroller: this.scroller}) {
          Repeat<ChatKitConversation>(this.viewModel.dataList)
            .each((obj: RepeatItem<ChatKitConversation>) => {
              ListItem() {
                if (conversationProviderManager.hasCustomNode(obj.item)) {
                  NodeContainer(conversationProviderManager.provideNodeController(this.getUIContext(), obj.item))
                } else {
                  ConversationItemView({
                    conversation: obj.item
                  })
                }
              }
              .onClick(() => {
                this.onItemClick?.(obj.item);
              })
              .swipeAction({
                end: () => {this.swipeActionBuilder(obj.item)}
              })
            })
            .virtualScroll()
            .key((item: ChatKitConversation, index: number) => {
              return item.conversationId;
            })
        }
        .cachedCount(4)
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: $r('app.color.chat_color_list_separator'),
          startMargin: 78
        })
      } else {
        this.emptyDataBuilder()
      }
    }
  }
}