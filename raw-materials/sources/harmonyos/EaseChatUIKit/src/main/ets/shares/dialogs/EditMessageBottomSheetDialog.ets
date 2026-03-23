import { EditMessageBottomSheetDialogOptions } from '../../model/DialogOptions';
import { TextLabelSmallAttributeModifier } from '../attributeModifiers/TextAttributeModifiers';
import { checkboxBuilder } from '../builders/CommonBulders';
import { EditMessageCheckBoxStyle } from '../../internal/attributeModifiers/ComponentModifier';
import { TextParseResult, TextParseType } from '../../internal/model/EmojiIcon';
import { EmojiManager } from '../../internal/manager/EmojiManager';
import { getContent } from '../../utils/MessageUtil';
import { BottomSheetDialogHelper } from './BottomSheetDialog';

@Builder
export function editMessageBottomSheetDialogBuilder(options: EditMessageBottomSheetDialogOptions) {
  Column() {
    EditMessageBottomSheetDialog({
      options: options
    })
  }
}

@ComponentV2
export struct EditMessageBottomSheetDialog {
  @Param controller: RichEditorController = new RichEditorController();
  @Param options: EditMessageBottomSheetDialogOptions = new EditMessageBottomSheetDialogOptions();
  @Local dialogHeight: number = 0
  @Local translateY: number = 16
  @Local maxHeight: Length = $r('app.float.chat_primary_input_min_height')
  @Local isSelect: boolean = false;
  private previousContent?: string = '';
  @Local parseContent: TextParseResult[] | undefined = []

  aboutToAppear(): void {
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
    this.measureTextHeight();
    this.previousContent = this.options.content?.content as string
    this.parseContent = EmojiManager.getInstance().parseMessageContent(this.previousContent);
  }

  private measureTextHeight() {
    let sizeOptions = this.getUIContext().getMeasureUtils().measureTextSize({
      textContent: 'Hello HarmonyOS',
      fontSize: $r('app.float.text_body_large')
    })
    let height = px2vp(sizeOptions.height as number);
    let maxLines = 4;
    this.maxHeight = getContext().resourceManager.getNumber($r('app.float.chat_primary_input_min_height'));
    if (height * maxLines > this.maxHeight) {
      const topPadding = 7
      const bottomPadding = 7
      this.maxHeight  = Math.ceil(height)  * maxLines + topPadding + bottomPadding;
      console.log('maxHeight: '+this.maxHeight)
    }
  }

  build() {
    Column() {
      Text() {
        ImageSpan($r('app.media.chat_icon_edit_message'))
          .width(16)
          .height(16)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)

        Span('编辑中')
          .fontColor($r('app.color.chat_color_text_special'))
      }
      .padding({left: 12})
      .width('100%')
      .height(30)
      .backgroundColor($r('app.color.chat_color_sub_background'))

      Row() {
        RichEditor({controller: this.controller})
          .onReady(() => {
            this.controller.setTypingStyle({
              fontColor: this.options.textModel?.fontColor ?? $r('app.color.chat_color_text_primary'),
              fontSize: this.options.textModel?.fontSize ?? $r('app.float.text_body_large')
            })
            this.parseContent?.forEach(item => {
              if (item.parseType === TextParseType.Text) {
                this.controller.addTextSpan(item.text)
              } else if (item.parseType === TextParseType.Emoji) {
                if (typeof (item.emoji as ResourceStr) !== 'undefined') {
                  this.controller.addImageSpan(item.emoji as ResourceStr, {
                    imageStyle: {
                      size: [$r('app.float.text_body_large'), $r('app.float.text_body_large')]
                    }
                  })
                }
              }
            })
          })
          .placeholder(this.options.textModel?.placeholder ?? $r('app.string.chat_primary_input_placeholder'),
            this.options.textModel?.placeholderStyle ?? {
              fontColor: $r('app.color.chat_color_text_secondary_contrary'),
              font: {
                size: $r('app.float.text_body_large')
              }
            })
          .onDidChange((rangeBefore: TextRange, rangeAfter: TextRange) => {
            let content = getContent(this.controller).value;
            this.isSelect = content !== this.previousContent
          })
          .constraintSize({
            minHeight: $r('app.float.chat_primary_input_min_height'),
            maxHeight: this.maxHeight
          })
          .defaultFocus(true)
          .layoutWeight(1)
          .margin({
            right: 12
          })
          .backgroundColor($r('app.color.chat_color_sub_background'))
          .attributeModifier(this.options.textModel?.attributeModifier)

        Stack() {
          checkboxBuilder({
            width: 30,
            height: 30,
            shape: CheckBoxShape.CIRCLE,
            isSelect: this.isSelect,
            contentModifier: new EditMessageCheckBoxStyle()
          })
        }
        .onClick(()=> {
          if (this.isSelect) {
            this.options.onEditChange?.(this.options.messageId, getContent(this.controller).value);
            BottomSheetDialogHelper.closeDialog(this.options.id ?? '');
          }
        })
      }
      .padding({
        left: 12,
        right: 12,
        top: 8,
        bottom: 8
      })
    }
    .width(this.options.width ?? '100%')
    .height(this.options.height ?? 'auto')
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
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .translate({
      y: this.translateY
    })
  }
}