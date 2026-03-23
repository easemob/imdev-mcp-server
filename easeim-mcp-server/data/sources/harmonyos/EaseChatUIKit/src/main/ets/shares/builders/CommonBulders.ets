import uikit from '../../internal/ChatUIKit';
import {
  BadgeModel,
  CheckboxModel,
  EmojiModel,
  ImageModel,
  RowModel,
  SearchModel,
  TextModel,
  ToggleSwitchModel
} from '../../model/builder/ComponentModel';
import { ComponentStatus } from '../../model/ComponentStatus';
import {
  CircleAttributeModifier,
  CornerRadiusSmallAttributeModifier
} from '../attributeModifiers/CornerRadiusAttrbuteModifiers';
import {
  TextBodyLargeAttributeModifier,
  TextBodyMediumAttributeModifier,
  TextTitleMediumAttributeModifier
} from '../attributeModifiers/TextAttributeModifiers';
import { LengthMetrics } from '@kit.ArkUI';
import { KitCallback } from '../../interfaces/CommonCallback';
import { getDefaultBorderRadius, isRoundStyle } from '../../internal/utils/UIKitUtils';
import { AvatarAttributeModifier } from '../attributeModifiers/AvatarAttributeModifier';

/**
 * 通用图片加载自定义构建函数。
 * @param { ImageModel } param - 图片控制model
 */
@Builder
export function imageBuilder(param: ImageModel) {

  Column() {
    if (param.width || param.height) {
      if (param.width && param.height) {
        Image(param.src)
          .objectFit(param.imageFit ?? ImageFit.Contain)
          .alt(param.alt)
          .fitOriginalSize(param.fitOriginalSize ?? false)
          .visibility(param.visible ?? Visibility.Visible)
          .draggable(false)
          .margin(param.margin)
          .border(param.border ?? {})
          .attributeModifier(param.attributeModifier)
          .width(param.width)
          .height(param.height)
      } else if (param.width) {
        Image(param.src)
          .objectFit(param.imageFit ?? ImageFit.Contain)
          .alt(param.alt)
          .fitOriginalSize(param.fitOriginalSize ?? false)
          .visibility(param.visible ?? Visibility.Visible)
          .draggable(false)
          .margin(param.margin)
          .border(param.border ?? {})
          .attributeModifier(param.attributeModifier)
          .width(param.width)
      } else {
        Image(param.src)
          .objectFit(param.imageFit ?? ImageFit.Contain)
          .alt(param.alt)
          .fitOriginalSize(param.fitOriginalSize ?? false)
          .visibility(param.visible ?? Visibility.Visible)
          .draggable(false)
          .margin(param.margin)
          .border(param.border ?? {})
          .attributeModifier(param.attributeModifier)
          .width(param.height)
      }
    } else {
      Image(param.src)
        .objectFit(param.imageFit ?? ImageFit.Contain)
        .alt(param.alt)
        .fitOriginalSize(param.fitOriginalSize ?? false)
        .visibility(param.visible ?? Visibility.Visible)
        .draggable(false)
        .margin(param.margin)
        .border(param.border ?? {})
        .attributeModifier(param.attributeModifier)
    }
  }

}

/**
 * 通用头像自定义构建函数。
 *
 * 有默认参数。
 *
 * @param { ImageModel } param - 图片控制model
 */
@Builder
export function avatarBuilder(param?: ImageModel) {
  imageBuilder({
    src: param?.src ?? $r('app.media.avatar_default'),
    width: param?.width,
    height: param?.height,
    border: param?.border,
    fillColor: param?.fillColor,
    imageFit: param?.imageFit,
    alt: param?.alt,
    visible: param?.visible,
    margin: param?.margin,
    alignSelf: param?.alignSelf,
    backgroundColor: param?.backgroundColor,
    attributeModifier: param?.attributeModifier
      ?? uikit.configs.avatarAttribute
      ?? new AvatarAttributeModifier(uikit.configs.cornerStyle, param?.height)
  })
}

@Builder
export function emojiBuilder(param?: EmojiModel) {

  Column() {
    imageBuilder({
      src: param?.src,
      width: param?.width ?? $r('app.float.chat_emoji_size'),
      height: param?.height ?? $r('app.float.chat_emoji_size'),
      attributeModifier: new CircleAttributeModifier()
    })
  }
  .width(param?.outlineSize ?? $r('app.float.chat_emoji_outline_size'))
  .height(param?.outlineSize ?? $r('app.float.chat_emoji_outline_size'))
  .backgroundColor(param?.status ?
    ((param.status === ComponentStatus.CHECKED) ?
    $r('app.color.chat_color_component_normal') :
      ((param.status === ComponentStatus.CHECKED_OFF) ?
      $r('app.color.chat_color_component_normal_off') :
      Color.Transparent)) :
  Color.Transparent)
  .justifyContent(FlexAlign.Center)
  .enabled(param?.status !== ComponentStatus.CHECKED_OFF)
  .clip(true)
  .onClick(()=> {
    param?.onClick?.(param.status ?? ComponentStatus.UNCHECKED);
  })
  .attributeModifier(param?.attributeModifier ?? new CornerRadiusSmallAttributeModifier())

}

/**
 * 通用Checkbox自定义构建函数
 * @param param
 */
@Builder
export function checkboxBuilder(param?: CheckboxModel) {

  Column() {
    Checkbox(param?.options)
      .width(param?.width ?? $r('app.float.chat_checkbox_size'))
      .height(param?.height ?? $r('app.float.chat_checkbox_size'))
      .select(param?.isSelect)
      .unselectedColor(param?.unselectedColor ?? $r('app.color.chat_color_switch_bg_off'))
      .selectedColor(param?.selectedColor ?? $r('app.color.chat_color_component_normal'))
      .shape(param?.shape ?? CheckBoxShape.ROUNDED_SQUARE)
      .margin(param?.margin ?? 0)
      .onChange(param?.onChange)
      .contentModifier(param?.contentModifier)
      .attributeModifier(param?.attributeModifier)
  }

}

/**
 * 通用Toggle-Switch自定义构建函数
 * @param param
 */
@Builder
export function switchBuilder(param?: ToggleSwitchModel) {

  Column() {
    Toggle({type: ToggleType.Switch, isOn: param?.isSelect})
      .width(param?.width ?? $r('app.float.chat_switch_width'))
      .height(param?.height ?? $r('app.float.chat_switch_height'))
      .selectedColor(param?.selectedColor ?? $r('app.color.chat_color_component_normal'))
      .switchStyle({
        unselectedColor: $r('app.color.chat_color_switch_unselect'),
        pointColor: $r('app.color.chat_color_switch_point')
      })
      .onChange(param?.onChange)
      .attributeModifier(param?.attributeModifier)
  }

}

/**
 * 信息标识符
 * @param param
 */
@Builder
export function badgeBuilder(param?: BadgeModel) {
  Badge({
    count: param?.count ?? 0,
    position: param?.position ?? BadgePosition.Right,
    style: param?.style ?? {badgeSize: 18, badgeColor: $r('app.color.chat_color_primary')}
  }) {
    Text(param?.content ?? ' ')
      .fontColor(param?.fontColor ?? $r('app.color.chat_color_text_primary'))
      .attributeModifier(param?.attributeModifier ?? new TextBodyMediumAttributeModifier())
  }

}

@Builder
export function searchBuilder(onClick: KitCallback, textParam?: TextModel, imageParam?: ImageModel, param?: RowModel) {
  Row({space: param?.space ?? 4}) {
    Image(imageParam?.src ?? $r('app.media.chat_icon_search'))
      .width(imageParam?.width ?? 22)
      .height(imageParam?.height ?? 22)
      .fillColor(imageParam?.fillColor ?? $r('app.color.chat_color_search_icon_fill'))
      .objectFit(imageParam?.imageFit?? ImageFit.Contain)
      .border(imageParam?.border)
      .attributeModifier(imageParam?.attributeModifier)
    Text(textParam?.content ?? $r('app.string.search'))
      .fontColor(textParam?.fontColor ?? $r('app.color.chat_color_text_secondary_contrary'))
      .attributeModifier(textParam?.attributeModifier ?? new TextBodyLargeAttributeModifier())
  }
  .alignItems(param?.alignItems ?? VerticalAlign.Center)
  .justifyContent(param?.justifyContent ?? FlexAlign.Center)
  .width(param?.width ?? '95%')
  .height(param?.height ?? 36)
  .margin(param?.margin ?? {
    start: LengthMetrics.vp(8),
    end: LengthMetrics.vp(8),
    top: LengthMetrics.vp(4),
    bottom: LengthMetrics.vp(4),
  })
  .onClick(() => {
    onClick();
  })
  .backgroundColor($r('app.color.chat_color_sub_background'))
  .borderRadius(getDefaultBorderRadius())
  .attributeModifier(param?.attributeModifier)
}

@Builder
export function searchInputBuilder(onChange: KitCallback<string>, onBackPress: KitCallback, onSubmit?: KitCallback<string>, param?: SearchModel) {
  Row() {
    Search({placeholder: param?.placeholder ?? $r('app.string.search')})
      .placeholderColor(param?.placeholderColor ?? $r('app.color.chat_color_text_secondary_contrary'))
      .placeholderFont({
        size: param?.placeholderSize ?? 16
      })
      .searchIcon(param?.searchIcon ??
        {
          size: 22,
          src: $r('app.media.chat_icon_search')
        }
      )
      .cancelButton(param?.cancelIcon ??
        {
          icon: {
            size: 22,
            src: $r('app.media.chat_icon_cancel')
          }
        }
      )
      .onChange((value) => {
        onChange?.(value);
      })
      .onSubmit((value) => {
        onSubmit?.(value);
      })
      .borderRadius(isRoundStyle() ? 4 : '50%')
      .height(param?.height ?? 36)
      .margin(param?.margin ??
        {
          start: LengthMetrics.vp(8),
          end: LengthMetrics.vp(3),
          top: 4,
          bottom: 4
        }
      )
      .layoutWeight(1)

    Button({type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL}) {
      Text(param?.cancelText?.content ?? $r('app.string.cancel'))
        .fontColor(param?.cancelText?.fontColor ?? $r('app.color.chat_color_text_primary_activated'))
        .attributeModifier(param?.cancelText?.attributeModifier ?? new TextTitleMediumAttributeModifier())
    }
    .visibility(param?.cancelText?.visible ?? Visibility.Visible)
    .padding({
      left: 20,
      right: 20,
      top: 5,
      bottom: 5
    })
    .onClick(() => {
      onBackPress?.();
    })
  }
}

@Builder
export function emptyDataBuilder(onClick?: KitCallback<ClickEvent>) {
  Column() {
    Stack() {
      imageBuilder({
        src: $r('app.media.chat_icon_empty_data'),
        width: 105,
        height: 105,
        imageFit: ImageFit.Fill
      })
    }
    .onClick((event: ClickEvent) => {
      onClick?.(event);
    })
  }
  .justifyContent(FlexAlign.Center)
  .width('100%')
  .layoutWeight(1)
}