import { KitCallback } from '../../interfaces/CommonCallback';
import { ChatKitGroup } from '../../model/ChatKitGroup';
import { BaseGroupListViewModel, GroupListViewModel } from '../../viewmodels/GroupViewModel';
import { ContactItemView } from '../contact/ContactComponents';

@ComponentV2
export struct GroupListView {
  @Param viewModel: BaseGroupListViewModel = new GroupListViewModel();
  @Event onItemClick: KitCallback<ChatKitGroup>;
  private isCanLoad: boolean = false;
  private startIndex: number = 0;
  private endIndex: number = 0;
  private isScrolling: boolean = false;

  aboutToAppear(): void {
    this.viewModel.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisAppear();
  }

  @Builder
  customRefreshComponent() {
    // show nothing
    Text('')
  }

  @Builder
  footer() {
    Row() {
      LoadingProgress().height(32).width(48)
      Text("加载中")
    }.width("100%")
    .height(64)
    .justifyContent(FlexAlign.Center)
    // 当不处于加载中状态时隐藏组件
    .visibility(this.viewModel.isLoading ? Visibility.Visible : Visibility.None)
  }

  build() {
    Refresh({refreshing: false, builder: this.customRefreshComponent()}) {
      List() {
        Repeat<ChatKitGroup>(this.viewModel.dataList)
          .each((obj: RepeatItem<ChatKitGroup>) => {
            ListItem() {
              ContactItemView({
                contact: obj.item,
                dividerVisible: true
              })
            }
            .onClick(() => {
              this.onItemClick(obj.item);
            })
          })
          .key((item) => {
            return item.id;
          })

      }
      .scrollBar(BarState.Off)
      .onScrollIndex((start: number, end: number) => {
        this.startIndex = start;
        this.endIndex = end;
        console.log('scroll start: '+start+' end: '+end);
        // 当达到列表末尾时，触发新数据加载
        if (this.isCanLoad && end >= this.viewModel.dataList.length - 1) {
          this.isCanLoad = false;
          this.viewModel.isLoading = true;
          this.viewModel.fetchMoreGroups();
        }
        if (!this.isScrolling) {
          this.viewModel.fetchGroups(this.startIndex, this.endIndex);
        }
      })
      .onScrollStart(() => {
        this.isScrolling = true;
      })
      .onScrollStop(() => {
        this.viewModel.fetchGroups(this.startIndex, this.endIndex);
      })
      .onScrollFrameBegin((offset: number, state: ScrollState) => {
        // 只有当向上滑动时触发新数据加载
        if (offset > 5 && !this.viewModel.isLoading) {
          this.isCanLoad = true;
        }
        return { offsetRemain: offset };
      })
      .height('100%')
    }
    .pullToRefresh(false)
    .layoutWeight(1)

  }
}