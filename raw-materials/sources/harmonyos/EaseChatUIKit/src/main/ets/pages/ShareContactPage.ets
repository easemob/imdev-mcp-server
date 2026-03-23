import { ContactListView } from '../components/contact/ContactListView';
import { ComposeTitleBar } from '../shares/components/CommonComponents';
import { KitCallback } from '../interfaces/CommonCallback';
import { ChatKitContact } from '../model/ChatKitContact';
import { SearchContactPageParams, SearchContactResponseType } from '../model/PageParams';
import { AlertDialog } from '../shares/dialogs/AlertDialog';
import { ChatUserInfoManager } from '../internal/manager/ChatUserInfoManager';

@ComponentV2
export struct ShareContactPage {
  @Param pathStack?: NavPathStack = undefined;
  @Local navPathStack?: NavPathStack = this.pathStack;
  @Event onItemClick: KitCallback<ChatKitContact> = (contact) => {
    this.showShareDialog(contact);
  };
  @Event onSearchClick: KitCallback = () => {
    this.navPathStack?.pushPath({name: "SearchContactPage", param: { responseType: SearchContactResponseType.onPop } as SearchContactPageParams , onPop: (result) => {
      let resultParam = result.result as ChatKitContact;
      if (resultParam) {
        this.showShareDialog(resultParam);
      }
    }});
  };
  private targetUserId: string = '';

  private showShareDialog(contact: ChatKitContact) {
    AlertDialog.show(this.getUIContext(), {
      title: {
        content: $r('app.string.share_contact_page_title')
      },
      content: {
        content: getContext().resourceManager.getStringSync($r('app.string.share_contact_content')
          , ChatUserInfoManager.getInstance().getNickname(contact)
          , ChatUserInfoManager.getInstance().getNickname(this.targetUserId))
      },
      cornerRadius: $r('app.float.corner_radius_small'),
      alignment: DialogAlignment.Center,
      cancelButton: {
        content: $r('app.string.cancel')
      },
      confirmButton: {
        content: $r('app.string.confirm')
      },
      onAction: (action: number, content: string) => {
        if (action === 1) {
          this.navPathStack?.pop(contact);
        }
      }
    })
  }

  build() {
    NavDestination() {
      Column() {
        ComposeTitleBar({
          primaryTitle: $r('app.string.share_contact_page_title'),
          onBackPress: () => {
            this.navPathStack?.pop();
          }
        })
        ContactListView({
          onItemClick: this.onItemClick,
          onSearchClick: this.onSearchClick
        })
          .layoutWeight(1)
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context) => {
      if (!this.navPathStack) {
        this.navPathStack = context.pathStack;
      }
      if (this.navPathStack) {
        let params = this.navPathStack.getParamByName('ShareContactPage') as string[];
        if (params) {
          let param = params[0];
          if (param) {
            this.targetUserId = param;
          }
        }
      }
    })
  }
}

@Builder
export function ShareContactPageBuilder() {
  ShareContactPage()
}
