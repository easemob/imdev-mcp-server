import { BottomSheetDialogOptions, DialogOptions } from '../../model/DialogOptions';
import {
  TextLabelMediumAttributeModifier,
  TextTitleLargeAttributeModifier
} from '../attributeModifiers/TextAttributeModifiers';
import { MenuItem } from '../../model/Menu';
import { MenuItemView } from '../components/CommonComponents';
import { ChatDialog } from './ChatDialog';
import { ComponentContent } from '@ohos.arkui.node';

export class BottomSheetDialogHelper {

  static createDialog<T extends DialogOptions>(context: UIContext, options: T, builder?: WrappedBuilder<[T]>): string {
    if (ChatDialog.isExist(options?.id ?? '')) {
      console.log('Dialog has opened, id: '+options?.id)
      return '';
    }
    const dialog = new ChatDialog(context)
    if (!builder) {
      builder = wrapBuilder(bottomSheetDialogBuilder);
    }
    let contentNode = new ComponentContent(context, builder, options);
    return dialog
      .setOptions(options)
      .setContentNode(contentNode)
      .createDialog()
  }

  static openDialog(dialogId: string) {
    let dialog = ChatDialog.getDialog(dialogId);
    if (dialog) {
      dialog.openDialog(dialogId);
    }
  }

  static closeDialog(dialogId: string) {
    let dialog = ChatDialog.getDialog(dialogId);
    if (dialog) {
      dialog.closeDialog();
    }
  }

  static updateDialog<T extends DialogOptions>(dialogId: string, options: T) {
    let dialog = ChatDialog.getDialog(dialogId);
    if (dialog) {
      dialog.updateDialog(options);
    }
  }

}

@Builder
export function bottomSheetDialogBuilder(options: BottomSheetDialogOptions) {
  BottomSheetDialog({
    options: options
  })
}

@ComponentV2
export struct BottomSheetDialog {
  @Param options: BottomSheetDialogOptions = new BottomSheetDialogOptions();
  @Local dialogHeight: number = 0
  @Local translateY: number = 0

  aboutToAppear(): void {
    let onWillDismiss = this.options.onWillDismiss
    this.options.onWillDismiss = (action: DismissDialogAction)  => {
      if (onWillDismiss) {
        onWillDismiss(action)
      } else {
        if (action.reason === DismissReason.PRESS_BACK || action.reason === DismissReason.TOUCH_OUTSIDE) {
          BottomSheetDialogHelper.closeDialog(this.options.id ?? '')
        }
      }
    }
  }

  private appearAnimation(duration: number = 300) {
    animateTo({
      duration: duration,
      curve: Curve.Linear,
      playMode: PlayMode.Normal
    }, () => {
      this.translateY = 0
    })
  }

  private disappearAnimation(duration: number = 300) {
    animateTo({
      duration: duration,
      curve: Curve.Linear,
      playMode: PlayMode.Normal,
      onFinish: () => {
        BottomSheetDialogHelper.closeDialog(this.options.id ?? '')
      }
    }, () => {
      this.translateY = this.dialogHeight
    })
  }

  build() {
    Column() {
      if (this.options.title) {
        Text(this.options.title.content)
          .fontColor(this.options.title.fontColor ?? $r('app.color.chat_color_text_primary'))
          .margin({
            top: 24
          })
          .attributeModifier(this.options.title.attributeModifier ?? new TextTitleLargeAttributeModifier())
      }
      if (this.options.content) {
        Text(this.options.content.content)
          .fontColor(this.options.content.fontColor ?? $r('app.color.chat_color_text_secondary'))
          .margin({
            top: 12
          })
          .attributeModifier(this.options.content.attributeModifier ?? new TextLabelMediumAttributeModifier())
      }
      if (this.options.menus) {
        if (this.options.isTopDragVisible === undefined || this.options.isTopDragVisible) {
          Divider()
            .strokeWidth(5)
            .width(36)
            .color($r('app.color.chat_color_bottom_sheet_drag'))
            .lineCap(LineCapStyle.Round)
            .alignSelf(ItemAlign.Center)
            .margin({top: 6, bottom: 5})
        }

        List() {
          ForEach(this.options.menus, (item: MenuItem | ResourceStr, index: number) => {
            ListItem() {
              MenuItemView({
                menu: item
              })
                .onClick(() => {
                  this.disappearAnimation(100)
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
        .divider({
          strokeWidth: 0.5,
          startMargin: 16,
          color: $r('app.color.chat_color_list_separator')
        })
      }
      if (this.options.isCancelVisible === undefined || this.options.isCancelVisible) {
        Divider().strokeWidth(8).color($r('app.color.chat_color_bottom_sheet_divider'))
        Row() {
          Button(this.options.cancelButton?.content ?? $r('app.string.cancel'), {type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL})
            .fontColor(this.options.cancelButton?.fontColor ?? $r('app.color.chat_color_primary'))
            .onClick(() => {
              this.disappearAnimation(100)
              this.options.onAction?.(0, "cancel");
            })
            .layoutWeight(1)
            .height($r("app.float.chat_menu_item_medium_height"))
            .attributeModifier(this.options.cancelButton?.attributeModifier ?? new TextLabelMediumAttributeModifier())
        }
        .margin({
          bottom: 28
        })
      }
    }
    .width(this.options.width ?? '100%')
    .height(this.options.height ?? 'auto')
    .border({
      radius: {
        topLeft: $r('app.float.corner_radius_large'),
        topRight: $r('app.float.corner_radius_large')
      }
    })
    .gesture(
      PanGesture()
        .onActionUpdate((event: GestureEvent|undefined) => {
          if(event){
            if (event.offsetY < 0) {
              return
            }
            this.translateY = event.offsetY;
          }
        })
        .onActionEnd(() => {
          if (this.translateY > this.dialogHeight / 2) {
            this.disappearAnimation(100);
          } else {
            this.appearAnimation();
          }
        })
    )
    .backgroundColor(this.options.backgroundColor ?? $r('app.color.chat_color_background'))
    .visibility(Visibility.Hidden)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (this.dialogHeight === 0) {
        this.dialogHeight = (newValue.height as number) ?? 0;
        this.translateY = this.dialogHeight;
        this.appearAnimation()
      }
    })
    .visibility(this.dialogHeight > 0 ? Visibility.Visible : Visibility.Hidden)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .translate({
      y: this.translateY
    })
  }
}