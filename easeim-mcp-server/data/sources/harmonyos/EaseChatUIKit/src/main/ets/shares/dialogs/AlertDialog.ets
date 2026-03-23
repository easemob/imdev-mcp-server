import { DialogOptions } from '../../model/DialogOptions';
import {
  TextHeadlineSmallAttributeModifier,
  TextLabelMediumAttributeModifier,
  TextTitleLargeAttributeModifier
} from '../attributeModifiers/TextAttributeModifiers';
import { MenuItem } from '../../model/Menu';
import { MenuItemView } from '../components/CommonComponents';
import { ChatDialog } from './ChatDialog';
import { ComponentContent, LengthMetrics } from '@ohos.arkui.node';
import { searchInputBuilder } from '../builders/CommonBulders';

export class AlertDialog {

  static show(context: UIContext, options: DialogOptions) {
    if (ChatDialog.isExist(options?.id ?? '')) {
      console.log('Dialog has opened, id: '+options?.id)
      return;
    }
    const dialog = new ChatDialog(context);
    const builder = wrapBuilder(alertDialogBuilder);
    let contentNode = new ComponentContent(context, builder, options);
    let dialogId = dialog.setOptions(options).setContentNode(contentNode).createDialog()
    dialog.openDialog(dialogId);
  }

}

@Builder
export function alertDialogBuilder(options: DialogOptions) {
  ChatAlertDialog({
    options: options
  })
}

@ComponentV2
export struct ChatAlertDialog {
  @Param options: DialogOptions = new DialogOptions();
  @Local dialogHeight: number = 0
  @Local translateY: number = 0

  private closeDialog() {
    let dialog = ChatDialog.getDialog(this.options.id ?? '');
    if (dialog) {
      dialog.closeDialog();
    }
  }

  aboutToAppear(): void {
    let onWillDismiss = this.options.onWillDismiss
    this.options.onWillDismiss = (action: DismissDialogAction)  => {
      if (onWillDismiss) {
        onWillDismiss(action)
      } else {
        if (action.reason === DismissReason.PRESS_BACK || action.reason === DismissReason.TOUCH_OUTSIDE) {
          this.closeDialog();
        }
      }
    }
  }

  private isDividerVisible() {
    let cancelButtonVisible = true;
    if (this.options.cancelButton) {
      cancelButtonVisible = this.options.cancelButton.visible === Visibility.Visible;
    }
    let confirmButtonVisible = true;
    if (this.options.confirmButton) {
      confirmButtonVisible = this.options.confirmButton.visible === Visibility.Visible;
    }
    return cancelButtonVisible && confirmButtonVisible;
  }

  build() {
    Column() {
      if (this.options.title) {
        Text(this.options.title.content)
          .fontColor(this.options.title.fontColor ?? $r('app.color.chat_color_text_primary'))
          .margin({
            top: 24,
            bottom: this.options.content !== undefined ? 12 : 24
          })
          .attributeModifier(this.options.title.attributeModifier ?? new TextTitleLargeAttributeModifier())
      }
      if (this.options.content) {
        Text(this.options.content.content)
          .fontColor(this.options.content.fontColor ?? $r('app.color.chat_color_text_secondary'))
          .margin({
            top: 12,
            bottom: 24
          })
          .attributeModifier(this.options.content.attributeModifier ?? new TextLabelMediumAttributeModifier())
      }

      if (this.options.input) {
        searchInputBuilder((value) => {
          this.options.onChange?.(value);
        }, () => {}, () => {}, {
          margin: {},
          height: 48,
          placeholder: this.options.input.placeholder,
          searchIcon: {size: 0},
          cancelText: {visible: Visibility.None}
        })
      }

      if (this.options.menus) {

        List() {
          ForEach(this.options.menus, (item: MenuItem | ResourceStr, index: number) => {
            ListItem() {
              MenuItemView({
                menu: item
              })
                .onClick(() => {
                  this.options.onItemClick?.(index, item);
                  if (typeof (item as MenuItem).id != undefined) {
                    (item as MenuItem).action?.((item as MenuItem).id);
                  }
                })
            }
          }, (item: MenuItem | ResourceStr, index: number) => {
            if (typeof(item as MenuItem).id !== 'undefined') {
              return (item as MenuItem).id + '';
            } else {
              if (typeof item === 'string') {
                return index + "";
              } else {
                return item.id.toString();
              }
            }
          })
        }
        .width('100%')
        .margin({
          bottom: 24
        })
        .divider({
          strokeWidth: 0.5,
          startMargin: 16,
          color: $r('app.color.chat_color_list_separator')
        })
      }
      Row() {
        Button(this.options.cancelButton?.content ?? $r('app.string.cancel'), {type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL})
          .fontColor(this.options.cancelButton?.fontColor ?? $r('app.color.chat_color_text_primary'))
          .onClick(() => {
            this.closeDialog();
            this.options.onAction?.(0, "cancel");
          })
          .layoutWeight(1)
          .height($r("app.float.chat_dialog_button_height"))
          .border({
            radius: $r('app.float.corner_radius_small_extra'),
            width: 1,
            color: $r('app.color.chat_color_dialog_cancel_border')
          })
          .backgroundColor(this.options.cancelButton?.backgroundColor ?? $r('app.color.chat_color_background'))
          .visibility(this.options.cancelButton?.visible ?? Visibility.Visible)
          .attributeModifier(this.options.cancelButton?.attributeModifier ?? new TextHeadlineSmallAttributeModifier())

        Blank(12).visibility(this.isDividerVisible() ? Visibility.None : Visibility.Visible)

        Button(this.options.confirmButton?.content ?? $r('app.string.confirm'), {type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL})
          .fontColor(this.options.confirmButton?.fontColor ?? $r('app.color.chat_color_text_alert_dialog_confirm'))
          .onClick(() => {
            this.closeDialog();
            this.options.onAction?.(1, "confirm");
          })
          .layoutWeight(1)
          .height($r("app.float.chat_dialog_button_height"))
          .borderRadius($r('app.float.corner_radius_small_extra'))
          .backgroundColor(this.options.confirmButton?.backgroundColor ?? $r('app.color.chat_color_emphasize'))
          .visibility(this.options.confirmButton?.visible ?? Visibility.Visible)
          .attributeModifier(this.options.confirmButton?.attributeModifier ?? new TextHeadlineSmallAttributeModifier())
      }
      .width('100%')
      .margin({
        bottom: 16
      })
    }
    .width(this.options.width ?? '80%')
    .height(this.options.height ?? 'auto')
    .padding({
      start: LengthMetrics.vp(16),
      end: LengthMetrics.vp(16)
    })
    .borderRadius($r('app.float.corner_radius_small_extra'))
    .backgroundColor(this.options.backgroundColor ?? $r('app.color.chat_color_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}