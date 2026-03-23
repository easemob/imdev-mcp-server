import uikit from '../../internal/ChatUIKit';
import { EmojiIcon, EmojiIconDefaultData, TextParseResult, TextParseType } from '../../internal/model/EmojiIcon';
import {
  ChatEmojiExtendModel,
  ChatImageButtonModel,
  ChatMoreExtendModel,
  ChatPrimaryMenuModel,
  ChatTextInputModel
} from '../../model/builder/ChatComponentModel';
import { AppStyle, CornerStyle } from '../../model/CornerStyle';
import { imageBuilder } from '../../shares/builders/CommonBulders';
import { EmojiView, MenuItemView } from '../../shares/components/CommonComponents';
import { ChatPrimaryTextInputAttributeModifier } from './attributeModifiers/ChatPrimaryTextInputAttributeModifier';
import { inputMethod } from '@kit.IMEKit';
import { MenuItem } from '../../model/Menu';
import { bottomSheetDialogBuilder, BottomSheetDialogHelper } from '../../shares/dialogs/BottomSheetDialog';
import { recordBottomSheetDialogBuilder } from '../../shares/dialogs/RecordBottomSheetDialog';
import { BottomSheetDialogOptions, RecordBottomSheetDialogOptions } from '../../model/DialogOptions';
import { ChatDialog } from '../../shares/dialogs/ChatDialog';
import { ArrayList } from '@kit.ArkTS';
import { defaultChatMoreExtendMenus } from '../../internal/configs/KitDefaultData';
import {
  contentParsed,
  getContent,
  getDuration,
  getFilename,
  getImageAttachmentResource,
  getNicknameFromMessage,
  getUserCardNickname,
  getVideoThumbnailResource,
  isBuilderSpan,
  isRecalledMessage,
  isUserCardMessage
} from '../../utils/MessageUtil';
import {
  TextBodyMediumAttributeModifier,
  TextBodySmallAttributeModifier,
  TextLabelMediumAttributeModifier,
  TextLabelSmallAttributeModifier
} from '../../shares/attributeModifiers/TextAttributeModifiers';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { LengthMetrics } from '@kit.ArkUI';
import { getString as getStringRes } from '../../utils/CommonUtils';
import { KitConstants } from '../../../../../Index';
import { ChatMessage, ContentType } from '@easemob/chatsdk';
import { EventBus, getEventStr } from '../../utils/EventBus';
import { registerKeyboardHeightChange, unRegisterKeyboardHeightChange } from '../../utils/SoftKeyboardUtils';
import { ContactModel } from '../../model/ContactModel';
import { ChatUserInfoManager } from '../../internal/manager/ChatUserInfoManager';
import { RichEditorSpanModel } from '../../model/builder/MessageComponentModel';
import { MessageContent } from '../../model/Message';
import { booleanDefault } from '../../internal/utils/UIKitUtils';
import { KeyboardHelper } from '../../internal/KeyboardHelper';
import { ChatReplyMediaAttributeModifier } from './attributeModifiers/ChatReplyMediaAttributeModifier';
import { MessageReplyAttributeModifier } from '../../internal/attributeModifiers/MessageAttributeModifier';

@ComponentV2
export struct ChatInputMenuView {
  @Require @Param conversationId: string = '';
  @Local isAutoCancel: boolean = true;
  @Local chatPrimaryTextInputController: RichEditorController = new RichEditorController();
  @Param primaryMenuModel: ChatPrimaryMenuModel = new ChatPrimaryMenuModel();
  @Event onExtendMenuClick: (id: string | number) => void;
  @Param extendMenus: MenuItem[] = defaultChatMoreExtendMenus((id: string | number) => {
    this.onExtendMenuClick?.(id);
  })
  @Param moreExtendDialogOptions: BottomSheetDialogOptions = {
    alignment: DialogAlignment.Bottom,
    menus: this.extendMenus,
    autoCancel: true
  }
  @Event onClickSend: (content: MessageContent) => void;
  @Event onClickRecord: (callback: (isPermissionRecordGranted: boolean) => void) => void;
  @Event onClickRecordSend: (voicePath: string | undefined, duration: number) => void = ()=>{};
  @Event onClickText: () => void;
  @Param moreExtendDialogWrapper: WrappedBuilder<[BottomSheetDialogOptions]> = wrapBuilder(bottomSheetDialogBuilder)
  @Local moreExtendDialogId: string = ''
  @Param recordDialogOptions: RecordBottomSheetDialogOptions = {
    conversationId: this.conversationId,
    alignment: DialogAlignment.Bottom,
    autoCancel: true,
    onClickSend: this.onClickRecordSend
  }
  @Param recordDialogWrapper: WrappedBuilder<[RecordBottomSheetDialogOptions]> = wrapBuilder(recordBottomSheetDialogBuilder)
  @Local recordDialogId: string = ''
  @Local privateMenuBottomHeight: number = 0
  @Consumer('is_reply_style') isReplyStyle: boolean = false;
  @Monitor('isReplyStyle')
  onReplyChange() {
    if (!this.isReplyStyle) {
      KeyboardHelper.getInstance().reset();
    }
  }

  openMoreExtendDialog() {
    if (uikit.configs.appStyle !== AppStyle.STYLE_2) {
      return
    }
    if (!ChatDialog.isExist(this.moreExtendDialogId)) {
      let onDidDisappear = this.moreExtendDialogOptions.onDidDisappear
      let onItemClick = this.moreExtendDialogOptions.onItemClick
      if (this.moreExtendDialogOptions) {
        this.moreExtendDialogOptions.onDidDisappear = () => {
          this.primaryMenuModel.isShowMoreExtendStatus = false;
          onDidDisappear?.()
        }
        this.moreExtendDialogOptions.onItemClick = (index: number, value: object | ResourceStr) => {
          onItemClick?.(index, value);
        }
      }
      this.moreExtendDialogId = BottomSheetDialogHelper.createDialog(this.getUIContext(), this.moreExtendDialogOptions, this.moreExtendDialogWrapper)
    }
    BottomSheetDialogHelper.openDialog(this.moreExtendDialogId);
  }

  closeMoreExtendDialog() {
    if (uikit.configs.appStyle !== AppStyle.STYLE_2) {
      return
    }
    BottomSheetDialogHelper.closeDialog(this.moreExtendDialogId);
  }

  openRecordDialog() {
    if (!ChatDialog.isExist(this.recordDialogId)) {
      let onDidDisappear = this.recordDialogOptions.onDidDisappear
      let cancelableChange = this.recordDialogOptions.cancelableChange
      if (this.recordDialogOptions) {
        this.recordDialogOptions.onDidDisappear = () => {
          this.primaryMenuModel.isShowRecordExtendStatus = false;
          this.primaryMenuModel.isInputtingStatus = true;
          onDidDisappear?.()
        }
        this.recordDialogOptions.cancelableChange = (canCancel: boolean) => {
          this.updateRecordDialog(canCancel);
          cancelableChange?.(canCancel)
        }
        this.recordDialogOptions.onClickRecord = this.onClickRecord
      }
      this.recordDialogId = BottomSheetDialogHelper.createDialog(this.getUIContext(), this.recordDialogOptions, this.recordDialogWrapper)
    }
    BottomSheetDialogHelper.openDialog(this.recordDialogId);
  }

  closeRecordDialog() {
    BottomSheetDialogHelper.closeDialog(this.recordDialogId);
  }

  updateRecordDialog(canCancel: boolean = true) {
    BottomSheetDialogHelper.updateDialog<RecordBottomSheetDialogOptions>(this.recordDialogOptions.id ?? '', {
      id: this.recordDialogOptions.id,
      conversationId: this.conversationId,
      alignment: DialogAlignment.Bottom,
      autoCancel: canCancel,
      onClickRecord: this.onClickRecord,
      cancelableChange: this.recordDialogOptions.cancelableChange,
      onClickSend: this.recordDialogOptions.onClickSend
    })
  }

  aboutToAppear(): void {
    registerKeyboardHeightChange(getContext(this), (height) => {
      if (this.isReplyStyle) {
        KeyboardHelper.getInstance().setKeyboardChange(height);
        this.privateMenuBottomHeight = KeyboardHelper.getInstance().getDifference();
      }
    })
  }

  aboutToDisappear(): void {
    unRegisterKeyboardHeightChange(getContext(this));
  }

  build() {
    Column() {
      ChatPrimaryMenuView({
        textInputController: this.chatPrimaryTextInputController,
        param: this.primaryMenuModel,
        onClickRecord: (visible) => {
          if (visible) {
            this.openRecordDialog();
            this.closeMoreExtendDialog();
          } else {
            this.closeRecordDialog();
          }
        },
        onClickEmoji: (visible) => {
          if (visible) {
            this.closeMoreExtendDialog();
          }
        },
        onClickMore: (visible) => {
          if (visible) {
            this.openMoreExtendDialog();
          } else {
            this.closeMoreExtendDialog();
          }
        },
        onClickSend: (content: MessageContent) => {
          this.onClickSend?.(content)
        },
        onClickText: () => {
          this.onClickText?.();
        }
      })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          if (this.isReplyStyle) {
            KeyboardHelper.getInstance().setViewHeightChange(newValue);
            this.privateMenuBottomHeight = KeyboardHelper.getInstance().getDifference();
          }
        })
      if (this.primaryMenuModel.isShowEmojiExtendStatus) {
        ChatEmojiExtendView({
          onItemEmojiClick: (emoji: EmojiIcon) => {
            this.chatPrimaryTextInputController.addImageSpan(emoji.icon, {
              offset: this.chatPrimaryTextInputController.getCaretOffset(),
              imageStyle: {
                size: [$r('app.float.text_body_large'), $r('app.float.text_body_large')]
              }
            })
          },
          onDeleteClick: () => {
            // 获取光标位置
            const offset = this.chatPrimaryTextInputController.getCaretOffset()
            this.chatPrimaryTextInputController.deleteSpans({
              start: offset - 1,
              end: offset
            })
          },
          onSendClick: () => {

          }
        })
      }
      if (this.primaryMenuModel.isShowMoreExtendStatus && uikit.configs.appStyle === AppStyle.STYLE_1) {
        ChatMoreExtendView({
          moreMenuData: this.extendMenus
        })
      }
      // 为解决消息回复时，输入框弹不起来的问题
      Column()
        .height(this.privateMenuBottomHeight)
    }
  }
}

@ComponentV2
export struct ChatPrimaryImageButton {
  @Require @Param src: ResourceStr;
  @Param param: ChatImageButtonModel = new ChatImageButtonModel();
  @Event onClickEvent: () => void;

  build() {
    Column() {
      Button(this.param.btnOptions ?? {type: ButtonType.Circle, stateEffect: true, buttonStyle: ButtonStyleMode.TEXTUAL}) {
        Image(this.src)
          .width(this.param.width ?? $r('app.float.chat_primary_icon_size'))
          .height(this.param.height ?? $r('app.float.chat_primary_icon_size'))
          .objectFit(this.param.imageFit ?? ImageFit.Contain)
          .fillColor(this.param.fillColor ?? $r('app.color.chat_color_icon_fill'))
          .attributeModifier(this.param.attributeModifier)
      }
      .margin(this.param.btnMargin ?? $r('app.float.chat_margin_common_medium'))
      .width(this.param.btnWidth ?? 'auto')
      .height(this.param.btnHeight ?? 'auto')
      .onClick(() => {
        this.onClickEvent();
      })
    }
    .shadow(this.param.btnShadow)
    .border(this.param.border)
    .backgroundColor(this.param.btnBackgroundColor ?? Color.Transparent)

  }
}

@ComponentV2
export struct ChatPrimaryTextInput {
  @Require @Param controller: RichEditorController = new RichEditorController();
  @Param param: ChatTextInputModel = new ChatTextInputModel();
  @Param builderSpans: RichEditorSpanModel[] = [];
  @Event onInputChange: (value: Array<RichEditorImageSpanResult | RichEditorTextSpanResult>) => void;
  @Event onDidSend: (controller: RichEditorController) => void;
  @Event onEditingChange: (isEditingChange: boolean) => void;
  @Event onTextClick:() => void;
  @Event onInputFocus: () => void;
  @Event onInputBlur: () => void;
  @Local maxHeight: Length = $r('app.float.chat_primary_input_min_height');
  @Consumer('group_member_at_user') selectedMember?: ContactModel;
  @Monitor('selectedMember')
  onGroupMemberSelectListener(monitor: IMonitor) {
    if (this.selectedMember) {
      this.onAtGroupMemberClick(this.selectedMember);
    }
  }
  // 是否正在进行@输入
  private isAtInput: boolean = false;
  @Consumer('is_at_input') onAtInput: () => void = () => {};
  private builderSpanSuffix: string = ' ';

  private measureTextHeight() {
    let sizeOptions = this.getUIContext().getMeasureUtils().measureTextSize({
      textContent: 'Hello HarmonyOS',
      fontSize: this.param.fontSize ?? $r('app.float.text_body_large')
    })
    let height = px2vp(sizeOptions.height as number);
    let maxLines = this.param.maxLines ?? 4;
    if (height * maxLines > this.maxHeight) {
      const topPadding = this.param.attributeModifier?.getTopPadding() ?? new ChatPrimaryTextInputAttributeModifier().getTopPadding()
      const bottomPadding = this.param.attributeModifier?.getBottomPadding() ?? new ChatPrimaryTextInputAttributeModifier().getBottomPadding()
      this.maxHeight  = Math.ceil(height)  * maxLines + topPadding + bottomPadding;
    }
  }

  @Builder
  AtSpan(nickname: string) {
    Text(`@${nickname}${this.builderSpanSuffix}`)
      .fontColor($r('app.color.chat_color_text_primary_activated'))
  }

  onAtGroupMemberClick: (contact: ContactModel) => void = contact => {
    const controller = this.controller;
    const offset = controller.getCaretOffset();
    const range: RichEditorRange = { start: offset - 1, end: offset };
    const span = controller.getSpans(range);
    if (offset !== 0 && (span[0] as RichEditorTextSpanResult).value === '@') {
      controller.deleteSpans(range);
    }
    controller.addBuilderSpan(() => this.AtSpan(ChatUserInfoManager.getInstance().getNickname(contact)), {
      offset: controller.getCaretOffset()
    });
    this.setBuilderSpans(controller, contact);
  }

  setBuilderSpans(controller: RichEditorController, contact: ContactModel) {
    const builderSpan: RichEditorSpanModel = {
      value: `@${ChatUserInfoManager.getInstance().getNickname(contact)}${this.builderSpanSuffix}`,
      data: contact.id,
      type: 'builder'
    };
    const range: RichEditorRange = { end: controller.getCaretOffset() };
    const index = this.getBuilderSpanCount(controller, range) - 1;
    this.builderSpans.splice(index, 0, builderSpan);
  }

  getBuilderSpanCount(controller: RichEditorController, range: RichEditorRange) {
    return controller.getSpans(range).reduce((count: number, span) => {
      return isBuilderSpan(span) ? count + 1 : count;
    }, 0);
  }

  aboutToDelete: (value: RichEditorDeleteValue) => boolean = value => {
    const controller = this.controller;
    const span = value.richEditorDeleteSpans[0];
    if (span && isBuilderSpan(span)) {
      if (this.hasSelection(controller)) {
        this.deleteBuilderSpan();
        return true;
      }
      controller.setSelection(value.offset, value.offset + 1);
      return false;
    }
    return true;
  }

  deleteBuilderSpan() {
    const controller = this.controller;
    const range: RichEditorRange = { end: controller.getCaretOffset() };
    const index = this.getBuilderSpanCount(controller, range) - 1;
    this.builderSpans.splice(index, 1);
  }

  hasSelection(controller: RichEditorController) {
    const selection = controller.getSelection().selection;
    return selection[0] !== selection[1];
  }

  onAtSymbolInput: () => void = () => {
    const controller = this.controller;
    this.isAtInput = true;
    this.onAtInput();
    controller.addTextSpan('@', { offset: controller.getCaretOffset() });
  }

  onIMEInputComplete: (result: RichEditorTextSpanResult) => void = result => {
    if (result.value) {
      this.isAtInput = false;
    }
  }

  aboutToIMEInput: (value: RichEditorInsertValue) => boolean = value => {
    if (value.insertValue === '@') {
      this.onAtSymbolInput();
      return false;
    }
    return true;
  }

  onDeleteComplete: () => void = () => {
    const controller = this.controller;
    const offset = controller.getCaretOffset();
    const span = controller.getSpans({ start: offset - 1, end: offset });
    if (span[0] && (span[0] as RichEditorTextSpanResult).value === '@') {
      this.isAtInput = true;
    } else {
      this.isAtInput = false;
    }
  }

  aboutToAppear(): void {
    this.maxHeight = getContext(this).resourceManager.getNumber($r('app.float.chat_primary_input_min_height'));
    this.measureTextHeight()
  }

  build() {
    Row() {
      RichEditor({controller: this.controller})
        .onReady(() => {
          this.controller.setTypingStyle({
            fontColor: this.param.fontColor ?? $r('app.color.chat_color_text_primary'),
            fontSize: this.param.fontSize ?? $r('app.float.text_body_large')
          })
        })
        .placeholder(this.param.placeholder ?? $r('app.string.chat_primary_input_placeholder'),
        this.param.placeholderStyle ?? {
          fontColor: $r('app.color.chat_color_text_secondary_contrary'),
          font: {
            size: $r('app.float.text_body_large')
          }
        })
        .onEditingChange(isEditingChange => {
          this.onEditingChange?.(isEditingChange);
        })
        .enterKeyType(EnterKeyType.Send)
        .aboutToDelete(this.aboutToDelete)
        .onDeleteComplete(this.onDeleteComplete)
        .onIMEInputComplete(this.onIMEInputComplete)
        .aboutToIMEInput(this.aboutToIMEInput)
        .onSubmit((enterKey, event) => {
          if (enterKey === EnterKeyType.Send) {
            this.onDidSend?.(this.controller);
          }
        })
        .onDidChange((rangeBefore: TextRange, rangeAfter: TextRange) => {
          this.onInputChange?.(this.controller.getSpans());
        })
        .constraintSize({
          minHeight: $r('app.float.chat_primary_input_min_height'),
          maxHeight: this.maxHeight
        })
        .onClick(() => {
          this.onTextClick?.();
        })
        .onFocus(()=> {
          this.onInputFocus?.();
        })
        .onBlur(()=> {
          this.onInputBlur?.();
        })
        .id('ChatPrimaryTextInput')
        .layoutWeight(1)
        .attributeModifier(this.param.attributeModifier ?? new ChatPrimaryTextInputAttributeModifier())
    }
    .layoutWeight(1)
    .margin({
      left: $r('app.float.chat_margin_common_small'),
      top: $r('app.float.chat_margin_common_small'),
      bottom: $r('app.float.chat_margin_common_small')
    })
  }
}

@ComponentV2
export struct ChatPrimaryMenuView {
  @Require @Param textInputController: RichEditorController = new RichEditorController();
  @Param param: ChatPrimaryMenuModel = new ChatPrimaryMenuModel();
  @Event onClickRecord: (visible: boolean) => void;
  @Event onClickEmoji: (visible: boolean) => void;
  @Event onClickMore: (visible: boolean) => void;
  @Event onClickSend: (content: MessageContent) => void;
  @Event onClickText: () => void;
  @Local builderSpans: RichEditorSpanModel[] = [];
  @Monitor('param.isShowEmojiExtendStatus')
  onEmojiStyleChange(monitor: IMonitor) {
    if (this.param.isShowEmojiExtendStatus) {
      this.showEmojiStatus();
    }
  }
  @Monitor('param.isShowRecordExtendStatus')
  onRecordStyleChange(monitor: IMonitor) {
    if (this.param.isShowRecordExtendStatus) {
      this.showRecordStatus();
    }
  }
  @Monitor('param.isShowMoreExtendStatus')
  onMoreStyleChange(monitor: IMonitor) {
    if (this.param.isShowMoreExtendStatus) {
      this.showMoreStatus(true);
    }
  }
  @Monitor('param.isInputtingStatus')
  onTextStyleChange(monitor: IMonitor) {
    if (this.param.isInputtingStatus) {
      this.showTextInputStatus();
    }
  }

  /**
   * 展示更多扩展
   * @param isClick
   */
  private showMoreStatus(isClick: boolean = false) {
    this.param.isExtendIconVisible = true;
    this.param.isSendIconVisible = false;
    if (isClick) {
      // 退出编辑态
      this.textInputController.stopEditing();
      this.param.isShowEmojiExtendStatus = false;
      this.param.isShowRecordExtendStatus = false;
      this.param.isInputtingStatus = false;
    }
  }

  /**
   * 展示发送状态
   * 当输入框内有文字或者表情符时，这时可以是文字输入状态，也可以是表情输入状态
   */
  private showSendStatus() {
    this.param.isExtendIconVisible = false;
    this.param.isSendIconVisible = true;
  }

  /**
   * 表情输入状态
   * 输入框要获取到焦点，但是不能弹软键盘
   * 是否展示发送按钮，要根据输入框内是否有文字或者表情符
   */
  private showEmojiStatus() {
    // 指定控件获取焦点
    this.getUIContext().getFocusController().requestFocus('ChatPrimaryTextInput');
    // 关闭软键盘
    inputMethod.getController().stopInputSession();
    // 不展示录音状态
    this.param.isShowRecordExtendStatus = false;
    // 判断输入框内是否有内容
    if (this.isHadInputContent()) {
      this.param.isSendIconVisible = true;
      this.param.isExtendIconVisible = false;
    } else {
      this.param.isExtendIconVisible = true;
      this.param.isSendIconVisible = false;
    }
    // 不展示扩展功能项
    this.param.isShowMoreExtendStatus = false;
  }

  private showRecordStatus() {
    // 退出编辑态
    this.textInputController.stopEditing();
    // 显示more的icon
    this.param.isExtendIconVisible = true;
    // 不实现发送icon
    this.param.isSendIconVisible = false;
    // 关闭表情扩展
    this.param.isShowEmojiExtendStatus = false;
    // 关闭更多扩展
    this.param.isShowMoreExtendStatus = false;
    // 关闭输入框模式
    this.param.isInputtingStatus = false;
  }

  /**
   * 展示文本输入状态
   */
  private showTextInputStatus() {
    if (this.isHadInputContent()) {
      this.param.isExtendIconVisible = false;
      this.param.isSendIconVisible = true;
    } else {
      this.param.isExtendIconVisible = true;
      this.param.isSendIconVisible = false;
    }
    this.getUIContext().getFocusController().requestFocus('ChatPrimaryTextInput');
    // 关闭表情扩展
    this.param.isShowEmojiExtendStatus = false;
    // 关闭录音功能
    this.param.isShowRecordExtendStatus = false;
    // 关闭更多扩展
    this.param.isShowMoreExtendStatus = false;
  }

  /**
   * 默认状态：文本状态，
   */
  private showDefaultStatus() {
    if (this.isHadInputContent()) {
      this.param.isExtendIconVisible = false;
      this.param.isSendIconVisible = true;
    } else {
      this.param.isExtendIconVisible = true;
      this.param.isSendIconVisible = false;
    }
    // 退出编辑态
    this.textInputController.stopEditing();
    // 关闭输入模式
    this.param.isInputtingStatus = false;
    // 关闭表情扩展
    this.param.isShowEmojiExtendStatus = false;
    // 关闭录音功能
    this.param.isShowRecordExtendStatus = false;
    // 关闭更多扩展
    this.param.isShowMoreExtendStatus = false;
  }

  /**
   * 输入框内是否有文字或者表情符
   * @returns
   */
  private isHadInputContent() {
    return this.textInputController?.getSpans()?.length > 0;
  }

  private getRichEditorContent(): MessageContent {
    return getContent(this.textInputController, this.builderSpans);
  }

  aboutToAppear(): void {
    let eventBus = new EventBus(getContext());
    eventBus.on(getEventStr(KitConstants.EVENTBUS_INPUT_FLAG, "default_style"), () => {
      this.showDefaultStatus();
    })
    eventBus.on(getEventStr(KitConstants.EVENTBUS_INPUT_FLAG, "text_style"), () => {
      this.showTextInputStatus();
    })
  }

  build() {
    Row() {
      if (this.param.isRecorderEnable && booleanDefault(this.param.isRecorderIconVisible)) {
        ChatPrimaryImageButton({
          src: $r('app.media.chat_primary_record_icon'),
          param: {
            btnMargin: {
              left: $r('app.float.chat_margin_common_medium'),
              right: 0,
              top: $r('app.float.chat_margin_common_medium'),
              bottom: $r('app.float.chat_margin_common_medium')
            }
          },
          onClickEvent: ()=> {
            this.param.isShowRecordExtendStatus = !this.param.isShowRecordExtendStatus;
            if (!this.param.isShowRecordExtendStatus) {
              this.param.isInputtingStatus = true;
            }
            this.onClickRecord?.(this.param.isShowRecordExtendStatus);
          }
        })
      }
      if (this.param.isInputTextEnable && booleanDefault(this.param.isInputTextVisible)) {
        ChatPrimaryTextInput({
          controller: this.textInputController,
          builderSpans: this.builderSpans,
          onInputChange: (value) => {
            let isChange = value.length > 0;
            if (isChange) {
              this.showSendStatus();
            } else {
              this.showMoreStatus();
            }
          },
          onDidSend: (controller) => {
            if (controller.getSpans().length > 0) {
              this.showMoreStatus();
              this.onClickSend?.(this.getRichEditorContent());
              controller.deleteSpans();
            }
          },
          onTextClick: () => {
            this.showTextInputStatus();
            this.onClickText?.();
          },
          onInputFocus: () => {
            if (this.param.isShowEmojiExtendStatus) {
              // 关闭软键盘
              inputMethod.getController().stopInputSession();
            }
          }
        })
          .margin({
            right: (booleanDefault(this.param.isSendIconVisible, false)
              || this.param.isExtendEnable && booleanDefault(this.param.isExtendIconVisible)
              || this.param.isEmojiEnable && booleanDefault(this.param.isEmojiIconVisible)) ? 0 : $r('app.float.chat_margin_common_small')
          })
          .layoutWeight(1)
      }
      if (this.param.isEmojiEnable && booleanDefault(this.param.isEmojiIconVisible)) {
        ChatPrimaryImageButton({
          src: this.param.isShowEmojiExtendStatus ? $r("app.media.chat_primary_softkeyboard_icon") : $r('app.media.chat_primary_emoji_icon'),
          param: {
            btnMargin: {
              left: $r('app.float.chat_margin_common_medium'),
              right: 0,
              top: $r('app.float.chat_margin_common_medium'),
              bottom: $r('app.float.chat_margin_common_medium')
            }
          },
          onClickEvent: ()=> {
            this.param.isShowEmojiExtendStatus = !this.param.isShowEmojiExtendStatus;
            if (!this.param.isShowEmojiExtendStatus) {
              this.param.isInputtingStatus = true;
            }
            this.onClickEmoji?.(this.param.isShowEmojiExtendStatus);
          }
        })
      }
      if (this.param.isExtendEnable && booleanDefault(this.param.isExtendIconVisible)) {
        ChatPrimaryImageButton({
          src: this.param.isShowMoreExtendStatus ? $r('app.media.chat_primary_more_close_icon') : $r('app.media.chat_primary_more_icon'),
          param: {
            btnMargin: {
              left: this.param.isEmojiIconVisible ? $r('app.float.chat_margin_common_small') : $r('app.float.chat_margin_common_medium'),
              right: $r('app.float.chat_margin_common_medium'),
              top: $r('app.float.chat_margin_common_medium'),
              bottom: $r('app.float.chat_margin_common_medium')
            }
          },
          onClickEvent: ()=> {
            this.param.isShowMoreExtendStatus = !this.param.isShowMoreExtendStatus;
            if (!this.param.isShowMoreExtendStatus) {
              this.param.isInputtingStatus = true;
            }
            this.onClickMore?.(this.param.isShowMoreExtendStatus);
          }
        })
      }
      if (booleanDefault(this.param.isSendIconVisible, false)) {
        ChatPrimaryImageButton({
          src: $r('app.media.chat_primary_send_icon'),
          param: {
            btnMargin: {
              left: this.param.isEmojiIconVisible ? $r('app.float.chat_margin_common_small') : $r('app.float.chat_margin_common_medium'),
              right: $r('app.float.chat_margin_common_medium'),
              top: $r('app.float.chat_margin_common_medium'),
              bottom: $r('app.float.chat_margin_common_medium')
            },
            fillColor: $r('app.color.chat_color_primary')
          },
          onClickEvent: ()=> {
            this.onClickSend?.(this.getRichEditorContent());
            this.textInputController.deleteSpans();
          }
        })
      }
    }
    .alignItems(VerticalAlign.Bottom)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      width: {
        top: 1
      },
      color: {
        top: $r('app.color.chat_color_list_separator')
      }
    })
    .backgroundColor($r('app.color.chat_color_background'))
  }
}

@ComponentV2
export struct ChatEmojiExtendView {
  @Param emojiData:EmojiIcon[] = EmojiIconDefaultData.createEmojiData();
  @Param param: ChatEmojiExtendModel = new ChatEmojiExtendModel()
  @Param maxCount: number = 7;
  @Event onItemEmojiClick: (emoji: EmojiIcon) => void;
  @Event onDeleteClick: () => void;
  @Event onSendClick: () => void;

  private getTemplateStr(): string {
    let templateStr = '';
    const maxCount = this.param.maxColumnCount ?? this.maxCount
    for (let index = 0; index < maxCount; index++) {
      if (index === this.maxCount - 1) {
        templateStr += '1fr'
      } else {
        templateStr += '1fr '
      }
    }
    return templateStr;
  }

  build() {
    Stack({alignContent: Alignment.BottomEnd}) {
      Grid() {
        ForEach(this.emojiData, (item: EmojiIcon, index: number) => {
          GridItem() {
            EmojiView({
              src: item.icon,
              onEmojiClick: (isChecked) => {
                this.onItemEmojiClick?.(this.emojiData[index]);
              }
            })
          }
        }, (item: EmojiIcon, index) => {
          return item.emojiText;
        })
      }
      .columnsTemplate(this.getTemplateStr())
      .rowsGap(this.param.rowGap ?? $r('app.float.chat_emoji_extend_rows_gap'))
      .height(this.param.height ?? $r('app.float.chat_emoji_extend_height'))
      .padding({
        left: this.param.startPadding ?? $r('app.float.chat_emoji_extend_start_padding'),
        right: this.param.endPadding ?? $r('app.float.chat_emoji_extend_end_padding'),
        top: this.param.topPadding ?? $r('app.float.chat_emoji_extend_top_padding'),
        bottom: this.param.bottomPadding ?? $r('app.float.chat_emoji_extend_bottom_padding')
      })

      Row({space: getContext(this).resourceManager.getNumber($r('app.float.chat_margin_common_medium'))}) {
        ChatPrimaryImageButton({
          src: $r('app.media.chat_emoji_extend_arrow_left'),
          param: {
            width: 24,
            height: 24,
            btnOptions: {type: ButtonType.Normal, stateEffect: true, buttonStyle: ButtonStyleMode.TEXTUAL},
            btnWidth: $r('app.float.chat_emoji_extend_btn_size'),
            btnHeight: $r('app.float.chat_emoji_extend_btn_size'),
            btnMargin: 0,
            btnBackgroundColor: $r('app.color.chat_color_background'),
            btnShadow: ShadowStyle.OUTER_DEFAULT_XS,
            border: {
              radius: uikit.configs.cornerStyle === CornerStyle.ROUND ? $r('app.float.corner_radius_small_extra') : '50%'
            }
          },
          onClickEvent: () => {
            this.onDeleteClick?.()
          }
        })
        ChatPrimaryImageButton({
          src: $r('app.media.chat_emoji_extend_airplane'),
          param: {
            width: 24,
            height: 24,
            btnOptions: {type: ButtonType.Normal, stateEffect: true, buttonStyle: ButtonStyleMode.TEXTUAL},
            btnWidth: $r('app.float.chat_emoji_extend_btn_size'),
            btnHeight: $r('app.float.chat_emoji_extend_btn_size'),
            btnMargin: 0,
            btnShadow: ShadowStyle.OUTER_DEFAULT_XS,
            btnBackgroundColor: $r('app.color.chat_color_emphasize'),
            border: {
              radius: uikit.configs.cornerStyle === CornerStyle.ROUND ? $r('app.float.corner_radius_small_extra') : '50%'
            }
          },
          onClickEvent: () => {
            this.onSendClick?.()
          }
        })
          .visibility(Visibility.None)
      }
      .margin({
        right: $r('app.float.chat_emoji_extend_btn_margin'),
        bottom: $r('app.float.chat_emoji_extend_btn_margin')
      })
    }
  }
}

@ComponentV2
export struct ChatMoreExtendView {
  @Param moreMenuData: MenuItem[] = [];
  @Param param: ChatMoreExtendModel = new ChatMoreExtendModel()
  @Param maxCount: number = this.param.maxColumnCount ?? 4;
  @Event onItemClick: (menu: MenuItem) => void;
  @Local menuGroup: Array<MenuItem>[] = [];
  @Local sHeight?: Length = 0;
  @Local isShowIndicator: boolean = false;

  aboutToAppear(): void {
    this.splitData();
  }

  splitData() {
    if (this.moreMenuData.length > this.maxCount * 2) {
      this.isShowIndicator = true;
      let subArray: ArrayList<MenuItem> = new ArrayList();
      this.moreMenuData.forEach((item, index) => {
        subArray.add(item);
        if ((index + 1) % (this.maxCount * 2) === 0 || index === this.moreMenuData.length -1) {
          this.menuGroup.push(subArray.convertToArray());
          subArray.clear();
        }
      })
    } else {
      this.isShowIndicator = false;
      if (this.moreMenuData.length > 0) {
        this.menuGroup.push(this.moreMenuData);
      }
    }
  }

  private createDotIndicator(): DotIndicator {
    const dot = new DotIndicator();
    dot.itemWidth(6)
      .itemHeight(6)
      .selectedItemWidth(6)
      .selectedItemHeight(6)
      .color($r('app.color.chat_indicator_unselect'))
      .selectedColor($r('app.color.chat_indicator_select'))
    return dot;
  }

  build() {
    Swiper() {
      ForEach(this.menuGroup, (subMenuGroup: MenuItem[], index) => {
        GridRow({
          columns: this.maxCount,
          breakpoints: {
            reference: BreakpointsReference.WindowSize
          },
          gutter: {
            x: this.param.columnGap ?? 0,
            y: this.param.rowGap ?? 12
          }
        }) {
          ForEach(subMenuGroup, (item: MenuItem, index: number) => {
            GridCol({order: item.order ?? 0}) {
              MenuItemView({
                menu: item,
                isVertical: true
              })
            }
            .onClick(() => {
              item.action?.(item.id);
            })
          }, (item: MenuItem, index) => {
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
        .padding({
          left: this.param.startPadding ?? $r('app.float.chat_more_extend_start_padding'),
          right: this.param.endPadding ?? $r('app.float.chat_more_extend_end_padding'),
          top: this.param.topPadding ?? $r('app.float.chat_more_extend_top_padding'),
          bottom: this.param.bottomPadding ?? $r('app.float.chat_more_extend_bottom_padding')
        })
        .width('100%')
      }, (item: MenuItem[], index) => {
        return (item[0].id as string) ?? index + '';
      })
    }
    .indicator(this.isShowIndicator ? this.createDotIndicator() : false )
    .loop(false)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (this.sHeight === 0) {
        this.sHeight = newValue.height
      }
    })
    .width('100%')
    .height(this.sHeight === 0 ? 'auto' : this.sHeight)
    .margin({
      bottom: $r('app.float.chat_default_bottom_margin')
    })

  }
}

@ComponentV2
export struct ChatMessageReplyView {
  @Require @Param message?: ChatKitMessage;
  @Monitor('message')
  onMessageChange(monitor: IMonitor) {
    if (this.message) {
      this.getMessageType();
    }
  }
  @Param isSender: boolean = false;
  @Param replyInfo?: Record<string, string> = {};
  @Param isInputView: boolean = false;
  @Event onReplyClear: () => void;
  @Local type?: ContentType = undefined;
  @Local isLostMessage: boolean = false;
  @Event onLostReplyContent: () => void;

  private getTargetTextAttribute() {
    return this.isInputView ? new TextBodySmallAttributeModifier() : new TextBodyMediumAttributeModifier();
  }
  private getTargetTipAttribute() {
    return this.isInputView ? new TextLabelSmallAttributeModifier() : new TextLabelMediumAttributeModifier();
  }

  private getTargetIconSize() {
    return this.isInputView ? 16 : 18;
  }

  private getMessageType() {
    if (this.message && !isRecalledMessage(this.message.origin)) {
      this.type = this.message.origin.getType();
      this.isLostMessage = false;
    } else {
      this.isLostMessage = true;
    }
  }

  aboutToAppear(): void {
    this.getMessageType();
    EventBus.create().on(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "recall"), (params: ChatMessage[]) => {
      params.forEach(item => {
        if (item.getMsgId() === this.message?.messageId) {
          this.isLostMessage = true;
          this.onLostReplyContent?.();
        }
      })
    });
    EventBus.create().on(getEventStr(KitConstants.EVENTBUS_MESSAGE_FLAG, "delete"), (params: string[]) => {
      params.forEach(item => {
        if (item === this.message?.messageId) {
          this.isLostMessage = true;
          this.onLostReplyContent?.();
        }
      })
    });
  }

  build() {
    Row() {
      Column() {
        Row() {
          if (this.isInputView) {
            Text($r('app.string.chat_reply_tips'))
              .fontColor($r('app.color.chat_color_text_special'))
              .margin({
                right: 2
              })
              .attributeModifier(new TextBodySmallAttributeModifier())
          }
          if (!this.isLostMessage) {
            Text(getNicknameFromMessage(this.message?.origin?.getFrom() ?? this.replyInfo?.[KitConstants.REPLY_MSG_SENDER] ?? ''))
              .fontColor($r('app.color.chat_color_text_special'))
              .maxLines(1)
              .textOverflow({overflow: TextOverflow.Ellipsis})
              .ellipsisMode(EllipsisMode.CENTER)
              .attributeModifier(new TextLabelSmallAttributeModifier())
          }
        }
        .margin({
          bottom: 4
        })
        if (this.isLostMessage) {
          Text($r('app.string.chat_reply_lost_message_tips'))
          .fontColor($r('app.color.chat_color_text_tertiary'))
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .ellipsisMode(EllipsisMode.END)
          .attributeModifier(new TextBodyMediumAttributeModifier())
        } else {
          if (this.type === ContentType.TXT) {
            Text() {
              ForEach(contentParsed(this.message?.origin ? this.message.origin : (this.replyInfo?.[KitConstants.REPLY_MSG_PREVIEW] ?? '')), (item: TextParseResult) => {
                if (item.parseType === TextParseType.Text) {
                  Span(item.text)
                    .fontColor($r('app.color.chat_color_text_secondary'))
                } else {
                  if (typeof (item.emoji as ResourceStr) !== 'undefined') {
                    ImageSpan(item.emoji as ResourceStr)
                      .width(this.getTargetIconSize())
                      .height(this.getTargetIconSize())
                      .objectFit(ImageFit.Fill)
                      .verticalAlign(ImageSpanAlignment.CENTER)
                  }
                }
              })
            }
            .fontColor($r('app.color.chat_color_text_secondary'))
            .maxLines(this.isInputView ? 1 : 2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .attributeModifier(this.getTargetTextAttribute())
          } else if (this.type === ContentType.FILE) {
            Text() {
              ImageSpan($r('app.media.chat_icon_reply_file'))
                .width(this.getTargetIconSize())
                .height(this.getTargetIconSize())
                .objectFit(ImageFit.Fill)
              Span(' ')
              Span(!this.isInputView && getFilename(this.message?.origin) ? $r('app.string.chat_reply_file_message_tips') : $r('app.string.chat_reply_file_tips'))
                .fontColor($r('app.color.chat_color_text_secondary'))
              Span('  ')
              Span(getFilename(this.message?.origin) ?? '')
                .fontColor($r('app.color.chat_color_text_secondary'))
            }
            .maxLines(this.isInputView ? 1 : 2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.CENTER)
          } else if (this.type === ContentType.VOICE) {
            Text() {
              ContainerSpan() {
                ImageSpan($r('app.media.chat_icon_reply_voice'))
                  .width(this.getTargetIconSize())
                  .height(this.getTargetIconSize())
                  .objectFit(ImageFit.Fill)
                Span(' ')
                Span(!this.isInputView && getDuration(this.message?.origin) ? $r('app.string.chat_reply_voice_message_tips') : $r('app.string.chat_reply_voice_tips'))
                  .fontColor($r('app.color.chat_color_text_secondary'))
                Span('  ')
                Span(getDuration(this.message?.origin) ? getStringRes($r('app.string.chat_reply_voice_duration'), getDuration(this.message?.origin)) : '')
                  .fontColor($r('app.color.chat_color_text_secondary'))
              }
            }
          } else if (this.type === ContentType.IMAGE) {
            Text() {
              ImageSpan($r('app.media.chat_icon_reply_image'))
                .width(this.getTargetIconSize())
                .height(this.getTargetIconSize())
                .objectFit(ImageFit.Fill)
              Span(' ')
              Span($r('app.string.chat_reply_image_tips'))
                .fontColor($r('app.color.chat_color_text_secondary'))
            }
            .margin({
              end: LengthMetrics.vp(16)
            })
            .attributeModifier(this.getTargetTipAttribute())
          } else if (this.type === ContentType.VIDEO) {
            Text() {
              ImageSpan($r('app.media.chat_icon_reply_video'))
                .width(this.getTargetIconSize())
                .height(this.getTargetIconSize())
                .objectFit(ImageFit.Fill)
              Span(' ')
              Span($r('app.string.chat_reply_video_tips'))
                .fontColor($r('app.color.chat_color_text_secondary'))
            }
            .margin({
              end: LengthMetrics.vp(16)
            })
            .attributeModifier(this.getTargetTipAttribute())
          } else if (this.type === ContentType.CUSTOM && this.message && isUserCardMessage(this.message?.origin)) {
            Text() {
              ImageSpan($r('app.media.chat_icon_reply_user_card'))
                .width(this.getTargetIconSize())
                .height(this.getTargetIconSize())
                .objectFit(ImageFit.Fill)
              Span(' ')
              Span(getUserCardNickname(this.message.origin))
                .fontColor($r('app.color.chat_color_text_secondary'))
            }
            .textAlign(TextAlign.Center)
            .margin({
              end: LengthMetrics.vp(16)
            })
            .attributeModifier(this.getTargetTipAttribute())
          } else {
            Text($r('app.string.chat_reply_unkown_type'))
              .fontColor($r('app.color.chat_color_text_tertiary'))
          }
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(this.isInputView ? 1 : 0)
      if (!this.isLostMessage) {
        if (this.type === ContentType.IMAGE) {
          imageBuilder({
            alt: $r('app.media.quote_default_image_icon'),
            src: this.message ? getImageAttachmentResource(this.message) : $r('app.media.quote_default_image_icon'),
            width: 36,
            height: 36,
            imageFit: ImageFit.Fill,
            attributeModifier: new ChatReplyMediaAttributeModifier()
          })
        }
        if (this.type === ContentType.VIDEO) {
          Stack() {
            imageBuilder({
              alt: $r('app.media.quote_default_video_icon'),
              src: this.message ? getVideoThumbnailResource(this.message) : $r('app.media.quote_default_video_icon'),
              width: 36,
              height: 36,
              imageFit: ImageFit.Fill,
              attributeModifier: new ChatReplyMediaAttributeModifier()
            })
            imageBuilder({
              src: $r('app.media.message_video_flag'),
              width: 24,
              height: 24,
            })
          }
        }
        if (this.isInputView) {
          Button({type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL}) {
            Image($r('app.media.chat_icon_reply_off'))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Fill)
              .fillColor($r('app.color.chat_color_reply_off_icon_fill'))
          }
          .height('100%')
          .margin({
            start: LengthMetrics.vp(12)
          })
          .onClick(this.onReplyClear)
        }
      }
    }
    .justifyContent(FlexAlign.Start)
    .padding({
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(12),
      top: LengthMetrics.vp(8),
      bottom: LengthMetrics.vp(8)
    })
    .height(this.isInputView ? 52 : 'auto')
    .attributeModifier(new MessageReplyAttributeModifier(this.isSender, this.isInputView))
  }
}

@ComponentV2
export struct ChatInputReplyView {
  @Require @Param message: ChatKitMessage;
  @Event onReplyClear: () => void;

  build() {
    Column() {
      Divider().height(1).backgroundColor($r('app.color.chat_color_list_separator'))
      ChatMessageReplyView({
        message: this.message,
        isInputView: true,
        onReplyClear: this.onReplyClear
      })
    }
    .width('100%')
  }
}