import {
  TextLabelMediumAttributeModifier,
  TextTitleLargeAttributeModifier,
  TextTitleSmallAttributeModifier
} from '../shares/attributeModifiers/TextAttributeModifiers';
import { searchInputBuilder } from '../shares/builders/CommonBulders';
import { LengthMetrics } from '@kit.ArkUI';
import { KitConstants } from '../constants/KitConstants';
import { getDefaultBorderRadius, isRoundStyle, resizeSoftware } from '../internal/utils/UIKitUtils';
import { BaseContactViewModel, ContactViewModel } from '../viewmodels/ContactViewModel';
import { ChatError } from '@easemob/chatsdk';
import { showToast } from '../utils/ToastUtil';

@ComponentV2
export struct AddContactDialogPage {
  pathStack: NavPathStack = new NavPathStack();
  @Param viewModel: BaseContactViewModel = new ContactViewModel();
  @Local inputValue: string = '';

  aboutToAppear(): void {
    resizeSoftware(getContext(this))
  }

  build() {
    NavDestination() {
      Stack({alignContent: Alignment.Center}) {
        Column() {
          Text($r('app.string.add_contact_dialog_title'))
            .fontColor($r('app.color.chat_color_text_primary'))
            .margin({
              top: 24
            })
            .attributeModifier(new TextTitleLargeAttributeModifier())

          Text($r('app.string.add_contact_dialog_content'))
            .fontColor($r('app.color.chat_color_text_secondary'))
            .margin({
              top: 12,
              bottom: 24
            })
            .attributeModifier(new TextLabelMediumAttributeModifier())

          searchInputBuilder((value) => {
            this.inputValue = value;
          }, () => {}, () => {}, {
            margin: {},
            height: 48,
            placeholder: $r('app.string.add_contact_dialog_placeholder'),
            searchIcon: {size: 0},
            cancelText: {visible: Visibility.None}
          })

          Row() {
            Button($r('app.string.cancel'), {type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL})
              .fontColor($r('app.color.chat_color_text_primary'))
              .onClick(() => {
                this.pathStack.pop();
              })
              .layoutWeight(1)
              .height($r("app.float.chat_dialog_button_height"))
              .border({
                radius: getDefaultBorderRadius(),
                width: 1,
                color: $r('app.color.chat_color_dialog_cancel_border')
              })
              .backgroundColor($r('app.color.chat_color_background'))
              .visibility(Visibility.Visible)
              .attributeModifier(new TextTitleSmallAttributeModifier())

            Blank(12)

            Button($r('app.string.add'), {type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL})
              .fontColor(this.inputValue.length > 0 ? $r('app.color.chat_color_text_primary_contrary') : $r('app.color.chat_color_text_tertiary'))
              .onClick(() => {
                this.viewModel.addContact(this.inputValue).then(() => {
                  this.pathStack.pop();
                }).catch((e: ChatError) => {
                  showToast({message: e.description});
                })
              })
              .layoutWeight(1)
              .height($r("app.float.chat_dialog_button_height"))
              .borderRadius(getDefaultBorderRadius())
              .backgroundColor($r('app.color.chat_color_emphasize'))
              .stateStyles({
                disabled: {
                  .backgroundColor($r('app.color.chat_color_button_disable'))
                }
              })
              .visibility(Visibility.Visible)
              .enabled(this.inputValue.length > 0)
              .attributeModifier(new TextTitleSmallAttributeModifier())
          }
          .width('100%')
          .margin({
            bottom: 16,
            top: 24
          })
        }
        .justifyContent(FlexAlign.Center)
        .width('80%')
        .height('auto')
        .padding({
          start: LengthMetrics.vp(16),
          end: LengthMetrics.vp(16)
        })
        .borderRadius(isRoundStyle() ? 8 : 16)
        .backgroundColor($r('app.color.chat_color_background'))
        .onClick(() => {

        })
      }
      .onClick(() => {
        this.pathStack.pop()
      })
      .width(KitConstants.FULL_WIDTH)
      .height(KitConstants.FULL_HEIGHT)
    }
    .backgroundColor('rgba(0,0,0,0.3)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
  }
}

@Builder
export function AddContactDialogPageBuilder() {
  AddContactDialogPage()
}