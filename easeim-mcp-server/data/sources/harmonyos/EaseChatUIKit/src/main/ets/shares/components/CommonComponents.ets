import { ChatEmojiAttributeModifier } from '../../components/chat/attributeModifiers/ChatEmojiAttributeModifier';
import { ImageModel, TextModel } from '../../model/builder/ComponentModel';
import { ComponentStatus } from '../../model/ComponentStatus';
import { MenuItem, ShowAsAction } from '../../model/Menu';
import {
  TextBaseAttributeModifier,
  TextBodyLargeAttributeModifier,
  TextBodySmallAttributeModifier,
  TextTitleMediumAttributeModifier
} from '../attributeModifiers/TextAttributeModifiers';
import { avatarBuilder, badgeBuilder, emojiBuilder, imageBuilder } from '../builders/CommonBulders';
import { LengthMetrics, OperateIcon, TextModifier, UIUtils } from '@kit.ArkUI';
import { KitCallback } from '../../interfaces/CommonCallback';
import { getDefaultBorderRadius } from '../../internal/utils/UIKitUtils';

@ComponentV2
export struct EmojiView {
  @Require @Param src: ResourceStr;
  @Param isCheckStyle: boolean = false;
  @Param emojiWidth: Length = $r('app.float.chat_emoji_size');
  @Param emojiHeight: Length = $r('app.float.chat_emoji_size');
  @Param outlineSize: Length = $r('app.float.chat_emoji_outline_size');
  @Local status: ComponentStatus = ComponentStatus.UNCHECKED;
  @Event onEmojiClick: (isChecked: boolean) => void;

  build() {
    emojiBuilder({
      src: this.src,
      width: this.emojiWidth,
      height: this.emojiHeight,
      outlineSize: this.outlineSize,
      status: this.status,
      onClick: (status) => {
        if (this.isCheckStyle) {
          if (status === ComponentStatus.UNCHECKED) {
            this.status = ComponentStatus.CHECKED
          } else if (status === ComponentStatus.CHECKED) {
            this.status = ComponentStatus.UNCHECKED
          }
          this.onEmojiClick?.(this.status === ComponentStatus.CHECKED);
        } else {
          this.onEmojiClick?.(true);
        }
      },
      attributeModifier: this.isCheckStyle ? undefined : new ChatEmojiAttributeModifier()
    })
  }
}

@Component
export struct MenuItemView {
  @State menu: MenuItem | ResourceStr = '';
  @State isVertical: boolean = false;
  iconParam?: ImageModel = new ImageModel();
  textParam?: TextModel = new TextModel();
  @State menuHeight?: Length = undefined;
  @State menuWidth?: Length = undefined;
  @State iconOutBtnHeight?: Length = undefined;
  @State iconOutBtnWidth?: Length = undefined;
  @State iconOutBtnBackgroundColor?: ResourceColor = undefined;
  @State iconOutBtnBorderRadius?: Length = $r('app.float.corner_radius_medium');

  build() {
    if (this.isVertical) {
      Column() {
        if (typeof (this.menu as MenuItem).id !== 'undefined') {
          if ((this.menu as MenuItem).icon) {
            Button({type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL}) {
              Image((this.menu as MenuItem).icon)
                .width(this.iconParam?.width ?? $r("app.float.chat_menu_item_icon_large_size"))
                .height(this.iconParam?.height ?? $r("app.float.chat_menu_item_icon_large_size"))
                .fillColor(this.iconParam?.fillColor ?? $r('app.color.chat_color_menu_icon_fill'))
            }
            .backgroundColor(this.iconOutBtnBackgroundColor ?? $r('app.color.chat_color_sub_background'))
            .width(this.iconOutBtnWidth ?? $r("app.float.chat_menu_item_large_size"))
            .height(this.iconOutBtnHeight ?? $r("app.float.chat_menu_item_large_size"))
            .borderRadius(this.iconOutBtnBorderRadius ?? $r('app.float.corner_radius_medium'))
            .margin({
              bottom: (this.menu as MenuItem).padding ?? 8
            })
          }
          Text((this.menu as MenuItem).value)
            .fontColor((this.menu as MenuItem).fontColor ?? (this.textParam?.fontColor ?? $r('app.color.chat_color_text_primary')))
            .attributeModifier(this.textParam?.attributeModifier ?? new TextBodySmallAttributeModifier())
        } else {
          Text(this.menu as ResourceStr)
            .fontColor((this.textParam?.fontColor ?? $r('app.color.chat_color_text_primary')))
            .attributeModifier(this.textParam?.attributeModifier ?? new TextBodySmallAttributeModifier())
        }
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(this.menuHeight ?? 'auto')
      .width(this.menuWidth ?? $r("app.float.chat_menu_item_large_size"))
    } else {
      Button({type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL}) {
        Row() {
          if (typeof (this.menu as MenuItem).id !== 'undefined') {
            if ((this.menu as MenuItem).icon) {
              Image((this.menu as MenuItem).icon)
                .width(this.iconParam?.width ?? $r("app.float.chat_menu_item_icon_medium_size"))
                .height(this.iconParam?.height ?? $r("app.float.chat_menu_item_icon_medium_size"))
                .margin({right: (this.menu as MenuItem).padding ?? 4})
            }
            Text((this.menu as MenuItem).value)
              .fontColor((this.menu as MenuItem).fontColor ?? (this.textParam?.fontColor ?? $r('app.color.chat_color_text_primary')))
              .attributeModifier(this.textParam?.attributeModifier ?? new TextBodyLargeAttributeModifier())
          } else {
            Text(this.menu as ResourceStr)
              .fontColor((this.textParam?.fontColor ?? $r('app.color.chat_color_text_primary')))
              .attributeModifier(this.textParam?.attributeModifier ?? new TextBodyLargeAttributeModifier())
          }
        }
        .backgroundColor(this.iconOutBtnBackgroundColor ?? Color.Transparent)
        .borderRadius(this.iconOutBtnBorderRadius ?? 0)
        .height(this.menuHeight ?? this.iconOutBtnHeight ?? (this.menu as MenuItem).height ?? $r("app.float.chat_menu_item_medium_height"))
        .width(this.menuWidth ?? this.iconOutBtnWidth ?? '100%')
        .padding(16)
      }
    }
  }
}

/**
 * 通用标题栏，只能在ComposeV2中使用
 */
@ComponentV2
export struct ComposeTitleBar {
  @Param icon?: ResourceStr = $r('app.media.icon_back_arrow');
  @Param avatar?: ResourceStr = undefined;
  /**
   * 头像占位图
   */
  @Param avatarAlt?: ResourceStr = undefined;
  @Param primaryTitle?: ResourceStr = undefined;
  @Param secondaryTitle?: ResourceStr = undefined;
  @Param titlePosition?: HorizontalAlign = HorizontalAlign.Start;
  @Param primaryTitleModifier?: TextModifier = this.defaultPrimaryTitleModifier();
  @Param secondaryTitleModifier?: TextModifier = this.defaultSecondaryTitleModifier();
  @Param titleIcon?: ResourceStr = undefined;
  @Param titleIconModifier?: ImageModifier = undefined;
  @Param operationItem?: Array<MenuItem> = undefined;
  @Monitor('operationItem')
  operationItemChange(monitor: IMonitor) {
    this.updateMenus();
  }
  @Param moreIcon?: Resource = undefined;
  @Param overflowMenuWith?: Length = 100;
  @Local menus: MenuItem[] = [];
  @Local subMenus: MenuItem[] = [];
  @Param defaultHeight: Length = 44;
  @Event onBackPress?: () => void;
  @Event onAvatarClick?: () => void;
  @Event onTitleClick?: () => void;
  @Param textMenuPadding: Padding | Length | LocalizedPadding = {end: LengthMetrics.vp(16)};

  private defaultPrimaryTitleModifier() {
    let modifier = new TextModifier();
    modifier.fontSize($r('app.float.text_title_medium'));
    modifier.fontWeight(FontWeight.Regular);
    modifier.fontColor($r('app.color.chat_color_text_primary'))
    return modifier;
  }

  private defaultSecondaryTitleModifier() {
    let modifier = new TextModifier();
    modifier.fontColor($r('app.color.chat_color_text_secondary'))
    modifier.fontSize($r('app.float.text_body_small_extra'));
    modifier.fontWeight(FontWeight.Normal);
    return modifier;
  }

  sort(menus: MenuItem[]): MenuItem[] {
    menus.sort((a: MenuItem, b: MenuItem) => {
      if (a.order && b.order) {
        return b.order - a.order;
      } else {
        return 0;
      }
    })
    return menus;
  }

  updateMenus() {
    if (this.operationItem && this.operationItem.length > 0) {
      let enableMenus: MenuItem[] = [];
      this.operationItem.forEach(item => {
        if (item.enable || item.enable === undefined) {
          enableMenus.push(item);
        }
      })
      let mainMenus: MenuItem[] = [];
      let subMenus: MenuItem[] = [];
      enableMenus.forEach(item => {
        if (item.showAsAction !== undefined) {
          if (item.showAsAction === ShowAsAction.ifRoom) {
            mainMenus.push(item);
          } else {
            subMenus.push(item);
          }
        } else {
          mainMenus.push(item);
        }
      })
      if (mainMenus.length === 0) {
        if (subMenus.length > 0) {
          mainMenus.push({
            id: 'more',
            value: '更多',
            icon: this.moreIcon ?? $r('app.media.icon_menu_more')
          })
          this.menus = mainMenus;
          this.subMenus = this.sort(subMenus);
        }
      } else if (mainMenus.length > 3) {
        mainMenus = this.sort(mainMenus);
        let menus = mainMenus.slice(0, 2);
        menus.push({
          id: 'more',
          value: '更多',
          icon: this.moreIcon ?? $r('app.media.icon_menu_more')
        })
        subMenus.push(...mainMenus.slice(2, mainMenus.length));
        this.menus = menus;
        this.subMenus = this.sort(subMenus);
      } else {
        this.menus = this.sort(mainMenus);
        if (subMenus.length > 0) {
          this.menus.push({
            id: 'more',
            value: '更多',
            icon: this.moreIcon ?? $r('app.media.icon_menu_more')
          })
          this.subMenus = this.sort(subMenus);
        }
      }
    } else {
      this.menus = [];
      this.subMenus = [];
    }
  }

  aboutToAppear(): void {
    this.updateMenus();
  }

  @Builder
  subMenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      ForEach(this.subMenus, (item: MenuItem, index) => {
        Column() {
          Button({type: ButtonType.Capsule, buttonStyle: ButtonStyleMode.TEXTUAL}) {
            Row() {
              Image(item.icon)
                .width(20)
                .height(20)
                .fillColor($r('app.color.chat_color_menu_icon_fill'))
                .margin({ right: 5 })

              Text(item.value).fontColor($r('app.color.chat_color_text_primary'))
                .attributeModifier(new TextTitleMediumAttributeModifier())
            }
            .width('100%')
            .height(30)
            .justifyContent(FlexAlign.Start)
            .align(Alignment.Center)
            .onClick(() => {
              item.action?.(item.id);
            })
          }

          if (index != this.subMenus.length - 1) {
            Divider().height(10).width('80%').color($r('app.color.chat_color_list_separator'))
          }
        }.padding({
          left: 12,
          right: 12,
          top: 5,
          bottom: 5
        }).height(40)
      })
    }.width(this.overflowMenuWith ?? 100)
  }

  build() {
    Row() {
      if (this.icon) {
        Button({type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL}) {
          Image(this.icon)
            .width(24)
            .height(24)
            .fillColor($r('app.color.chat_color_icon_fill'))
        }
        .height('100%')
        .padding({
          left: 8
        })
        .onClick(() => {
          this.onBackPress?.();
        })
      }

      if (this.avatar) {
        Button({type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL}) {
          avatarBuilder({
            src: this.avatar,
            alt: this.avatarAlt,
            width: 32,
            height: 32,
            imageFit: ImageFit.Fill
          })
        }
        .margin({
          left: this.icon === undefined ? 12 : 0
        })
        .onClick(() => {
          this.onAvatarClick?.();
        })
      }

      Column() {
        if (this.titleIcon) {
          Image(this.titleIcon)
            .height(22)
            .objectFit(ImageFit.Fill)
            .attributeModifier(this.titleIconModifier)
        } else {
          Text(this.primaryTitle)
            .textStyles()
            .attributeModifier(this.primaryTitleModifier)

          Text(this.secondaryTitle)
            .textStyles()
            .attributeModifier(this.secondaryTitleModifier)
        }
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(this.titlePosition ?? HorizontalAlign.Start)
      .onClick(() => {
        this.onTitleClick?.();
      })

      if (this.menus.length > 0) {
        List() {
          ForEach(this.menus, (item: MenuItem, index) => {
            ListItem() {
              if (item.id === 'more') {
                Button({type: ButtonType.Capsule, buttonStyle: ButtonStyleMode.TEXTUAL}) {
                  if (item.icon) {
                    Image(item.icon)
                      .width(24)
                      .height(24)
                      .fillColor($r('app.color.chat_color_menu_icon_fill'))
                  } else {
                    Text(item.value)
                      .fontColor((item.fontColor ?? $r('app.color.chat_color_text_primary')))
                      .attributeModifier(new TextBodyLargeAttributeModifier())
                  }
                }
                .width(36)
                .height(36)
                .bindMenu(this.subMenuBuilder())
              } else {
                Button({type: ButtonType.Capsule, buttonStyle: ButtonStyleMode.TEXTUAL}) {
                  if (item.icon) {
                    Image(item.icon)
                      .width(24)
                      .height(24)
                      .fillColor($r('app.color.chat_color_menu_icon_fill'))
                  } else {
                    Text(item.value)
                      .fontColor((item.fontColor ?? $r('app.color.chat_color_text_primary')))
                      .padding(this.textMenuPadding)
                      .attributeModifier(new TextBodyLargeAttributeModifier())
                  }
                }
                .width(item.icon != undefined ? 36 : 'auto')
                .height(36)
                .onClick(() => {
                  item.action?.(item.id);
                })
              }
            }
            .height('100%')
          }, (item: MenuItem, index) => {
            return typeof item.id === 'string' ? item.id : item.id + ''
          })
        }
        .listDirection(Axis.Horizontal)
      }
    }
    .alignItems(VerticalAlign.Center)
    .height(this.defaultHeight)
    .width('100%')
  }
}

@Extend(Text)
function textStyles() {
  .maxLines(1)
  .ellipsisMode(EllipsisMode.CENTER)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .margin({
    start: LengthMetrics.vp(8)
  })
}

@ComponentV2
export struct ComposeBadgeListItem {
  @Require @Param title: ResourceStr;
  @Param titleColor: ResourceColor = $r('app.color.chat_color_text_primary');
  @Param titleAttribute: TextBaseAttributeModifier = new TextTitleMediumAttributeModifier();
  @Param srcParam?: ImageModel = undefined;
  @Param operateIconVisible: boolean = true;
  @Param operateIcon: OperateIcon = {value: $r('app.media.chat_icon_arrow_right')};
  @Param badgeCount: number = 0;
  @Param badgeStyle: BadgeStyle = {
    badgeColor: $r('app.color.chat_color_badge'),
    borderColor: $r('app.color.chat_color_badge'),
    badgeSize: 16,
    fontSize: 12,
    color: $r('app.color.chat_color_text_primary_contrary'),
  };
  @Param dividerVisible: boolean = true;

  build() {
    Column() {
      Row() {
        if (this.srcParam) {
          imageBuilder(this.srcParam)
        }

        Text(this.title)
          .fontColor(this.titleColor)
          .attributeModifier(this.titleAttribute)

        Blank()

        badgeBuilder({
          count: this.badgeCount,
          style: this.badgeStyle,
          position: BadgePosition.Right
        })

        if (this.operateIconVisible) {
          imageBuilder({
            src: this.operateIcon.value ?? $r('app.media.chat_icon_arrow_right'),
            width: 20,
            height: 20,
            imageFit: ImageFit.Fill,
            margin: {right: 16, left: 5}
          })
        }
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .padding({
        start: this.srcParam === undefined ? LengthMetrics.vp(16) : LengthMetrics.vp(12),
        end: this.operateIconVisible ? LengthMetrics.vp(12) : LengthMetrics.vp(16)
      })
      .layoutWeight(1)

      if (this.dividerVisible) {
        Divider().strokeWidth(1).color($r('app.color.chat_color_list_separator')).margin({start: LengthMetrics.vp(16)})
      }
    }
    .width('100%')
    .height($r('app.float.chat_menu_item_medium_height'))
    .backgroundColor($r('app.color.chat_color_background'))
    .stateStyles({
      clicked: {
        .backgroundColor($r('app.color.chat_color_background_pressed'))
      }
    })
  }
}

@ComponentV2
export struct SearchInput {
  @Param placeholder?: ResourceStr = undefined;
  @Param placeholderColor?: ResourceColor = undefined;
  @Param placeholderSize?: Length = undefined;
  @Param searchIcon?: IconOptions = undefined;
  @Param searchHeight?: Length = 36;
  @Param searchMargin?: Margin | Length | LocalizedMargin = undefined;
  /**
   * 输入框内的清除按钮设置选项
   */
  @Param cancelIcon?: CancelButtonOptions = undefined;
  @Param cancelText: TextModel = UIUtils.makeObserved(new TextModel());
  @Event onChange: KitCallback<string>;
  @Event onBackPress: KitCallback;
  @Event onSubmit?: KitCallback<string>;

  build() {
    Row() {
      Search({placeholder: this.placeholder ?? $r('app.string.search')})
        .placeholderColor(this.placeholderColor ?? $r('app.color.chat_color_text_secondary_contrary'))
        .placeholderFont({
          size: this.placeholderSize ?? 16
        })
        .searchIcon(this.searchIcon ??
          {
            size: 22,
            src: $r('app.media.chat_icon_search'),
            color: $r('app.color.chat_color_search_icon_fill')
          }
        )
        .cancelButton(this.cancelIcon ??
          {
            icon: {
              size: 22,
              src: $r('app.media.chat_icon_cancel')
            }
          }
        )
        .onChange((value) => {
          this.onChange?.(value);
        })
        .onSubmit((value) => {
          this.onSubmit?.(value);
        })
        .borderRadius(getDefaultBorderRadius())
        .height(this.searchHeight ?? 36)
        .margin(this.searchMargin ??
          {
            start: LengthMetrics.vp(8),
            end: LengthMetrics.vp(3),
            top: 4,
            bottom: 4
          }
        )
        .layoutWeight(1)

      Button({type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL}) {
        Text(this.cancelText?.content ?? $r('app.string.cancel'))
          .fontColor(this.cancelText?.fontColor ?? $r('app.color.chat_color_text_primary_activated'))
          .attributeModifier(this.cancelText?.attributeModifier ?? new TextTitleMediumAttributeModifier())
      }
      .visibility(this.cancelText?.visible ?? Visibility.Visible)
      .padding({
        left: 20,
        right: 20,
        top: 5,
        bottom: 5
      })
      .onClick(() => {
        this.onBackPress?.();
      })
    }
  }
}
