import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { KitCallback } from '../interfaces/CommonCallback';
import { ConversationType } from '@easemob/chatsdk';
import { ChatPageParams } from '../model/PageParams';
import { BaseGroupListViewModel, GroupListViewModel } from '../viewmodels/GroupViewModel';
import { ChatKitGroup } from '../model/ChatKitGroup';
import { GroupListView } from '../components/group/GroupListView';
import { getString } from '../utils/CommonUtils';

@ComponentV2
export struct GroupListPage {
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Param viewModel: BaseGroupListViewModel = new GroupListViewModel();
  @Local groupsCount: number = 0;
  @Event onItemClick: KitCallback<ChatKitGroup> = (contact) => {
    this.navPathStack?.pushPath({name: "ChatPage", param: {
      conversationId: contact.id,
      conversationType: ConversationType.GroupChat
    } as ChatPageParams
    })
  };
  @Event onBackPress: KitCallback = () => {
    this.navPathStack?.pop();
  };

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          primaryTitle: getString($r('app.string.group_list_count_title'), this.viewModel.joinedGroupCount),
          onBackPress: this.onBackPress
        })
        GroupListView({
          viewModel: this.viewModel,
          onItemClick: this.onItemClick
        })
          .layoutWeight(1)
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context) => {
      if (!this.navPathStack) {
        this.navPathStack = context.pathStack
      }
    })
  }
}

@Builder
export function GroupListPageBuilder() {
  GroupListPage()
}
