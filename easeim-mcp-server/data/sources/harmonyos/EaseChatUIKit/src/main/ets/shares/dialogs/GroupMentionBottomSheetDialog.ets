import { ContactItemView } from '../../components/contact/ContactComponents';
import { ContactModel } from '../../model/ContactModel';
import { DialogOptions } from '../../model/DialogOptions';
import { ComposeTitleBar } from '../../shares/components/CommonComponents';
import { GroupMemberViewModel } from '../../viewmodels/GroupMemberViewModel';
import { ChatDialog } from './ChatDialog';
import { ComponentContent } from '@kit.ArkUI';

@Builder
export function groupMentionBottomSheetDialogBuilder(options: GroupMentionOptions) {
  Column() {
    GroupMentionBottomSheetDialog({
      options: options
    })
  }
}

export class GroupMentionOptions extends DialogOptions {
  groupId: string = ''
}

@ComponentV2
export struct GroupMentionBottomSheetDialog {
  @Param options: GroupMentionOptions = new GroupMentionOptions();
  @Local viewModel: GroupMemberViewModel = new GroupMemberViewModel(this.options.groupId);
  @Local dialogHeight: number = 0
  @Local translateY: number = 16
  @Local maxHeight: Length = $r('app.float.chat_primary_input_min_height')
  private isCanLoad: boolean = false;

  static show(context: UIContext, options: GroupMentionOptions) {
    if (ChatDialog.isExist(options?.id ?? '')) {
      console.log('Dialog has opened, id: '+options?.id)
      return;
    }
    const dialog = new ChatDialog(context);
    const builder = wrapBuilder(groupMentionBottomSheetDialogBuilder);
    let contentNode = new ComponentContent(context, builder, options);
    let dialogId = dialog.setOptions(options).setContentNode(contentNode).createDialog()
    dialog.openDialog(dialogId);
  }

  private closeDialog() {
    let dialog = ChatDialog.getDialog(this.options.id ?? '');
    if (dialog) {
      dialog.closeDialog();
    }
  }

  aboutToAppear(): void {
    this.viewModel.fetchGroupMembers();
    let onWillDismiss = this.options.onWillDismiss
    this.options.onWillDismiss = (action: DismissDialogAction) => {
      if (onWillDismiss) {
        onWillDismiss(action)
      } else {
        if (action.reason === DismissReason.PRESS_BACK) {
          action.dismiss();
        }
        if (action.reason === DismissReason.TOUCH_OUTSIDE && (this.options.autoCancel || this.options.autoCancel === undefined)) {
          action.dismiss();
        }
      }
    }
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
    Column() {
      ComposeTitleBar({
        primaryTitle: $r('app.string.chat_group_mention_title'),
        onBackPress: () => {
          this.closeDialog();
        }
      })

      Refresh({refreshing: false, builder: this.customRefreshComponent()}) {
        List() {
          Repeat<ContactModel>(this.viewModel.contacts)
            .each((obj: RepeatItem<ContactModel>) => {
              ListItem() {
                ContactItemView({
                  contact: obj.item
                })
              }
              .onClick(()=> {
                this.closeDialog();
                this.options.onItemClick?.(obj.index, obj.item);
              })
            })
            .virtualScroll()
            .key((item: ContactModel, index: number) => {
              return item.id;
            })

          ListItem() {
            this.footer();
          }
        }
        .scrollBar(BarState.Off)
        .onScrollIndex((start: number, end: number) => {
          // 当达到列表末尾时，触发新数据加载
          if (this.isCanLoad && end >= this.viewModel.contacts.length - 1) {
            this.isCanLoad = false;
            this.viewModel.isLoading = true;
            this.viewModel.fetchMoreGroupMembers();
          }
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
    .borderRadius({
      topLeft: 10,
      topRight: 10
    })
    .padding({
      top: 10
    })
    .width(this.options.width ?? '100%')
    .height(this.options.height ?? '90%')
    .backgroundColor(this.options.backgroundColor ?? $r('app.color.chat_color_background'))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (oldValue.globalPosition && newValue.globalPosition) {
        let oldY = (oldValue.globalPosition.y as number) ?? 0
        let newY = (newValue.globalPosition.y as number) ?? 0
        if (newY > oldY) {
          this.translateY = 0;
        } else {
          this.translateY = 16;
        }
      }
    })
    .translate({
      y: this.translateY
    })
  }
}