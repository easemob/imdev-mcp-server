import { ChatKitNotification } from '../../model/Notification';
import { BaseNewRequestViewModel, NewRequestViewModel } from '../../viewmodels/NewRequestViewModel';
import { NewRequestItemView } from './NewRequestComponents';

@ComponentV2
export struct NewRequestListView {
  // 消息列表相关viewModel
  @Param viewModel: BaseNewRequestViewModel = new NewRequestViewModel();
  @Event onAddClick: (notification: ChatKitNotification) => void = (notification) => {
    this.viewModel.agreeInvitation(notification);
  };

  aboutToAppear(): void {
    this.viewModel.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisAppear();
  }

  build() {
    Refresh({refreshing: $$this.viewModel.isRefreshing}) {
      List() {
        Repeat<ChatKitNotification>(this.viewModel.dataList)
          .each((obj: RepeatItem<ChatKitNotification>) => {
            ListItem() {
              NewRequestItemView({
                notification: obj.item,
                onAddClick: (msg) => {
                  this.onAddClick?.(msg);
                }
              })
            }
          })
          .virtualScroll()
          .key((item: ChatKitNotification, index: number) => {
            return item.id;
          })
      }
      .onClick(()=> {

      })
      .cachedCount(4)
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .layoutWeight(1)
    .refreshOffset(60)
    .pullToRefresh(true)
    .onRefreshing(() => {
      this.viewModel.loadAllNotificationMessages();
    })
  }
}