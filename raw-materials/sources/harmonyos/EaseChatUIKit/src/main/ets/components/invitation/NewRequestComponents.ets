import {
  AvatarAttributeModifier,
  KitConstants,
  messageItemAvatarBuilder,
  TextLabelMediumAttributeModifier,
  TextSingleLineAttributeModifier,
  TextTitleMediumAttributeModifier,
  TextTitleSmallAttributeModifier
} from '../../../../../Index';
import uikit from '../../internal/ChatUIKit';
import { getNumber } from '../../utils/CommonUtils';
import { LengthMetrics } from '@kit.ArkUI';
import { ChatKitNotification, NotificationStatus } from '../../model/Notification';

@ComponentV2
export struct NewRequestItemView {
  @Require @Param notification: ChatKitNotification;
  @Param dividerVisible: boolean = true;
  @Event onAddClick: (notification: ChatKitNotification) => void;

  build() {
    Column() {
      Row({space: getNumber($r('app.float.chat_margin_common_large'))}) {
        messageItemAvatarBuilder({
          src: this.notification.user?.avatar,
          alignSelf: ItemAlign.Auto,
          margin: {bottom: 0},
          imageFit: ImageFit.Fill,
          attributeModifier: new AvatarAttributeModifier(uikit.configs.cornerStyle, $r('app.float.new_request_icon_size'))
        })

        Column({space: 2}) {
          Text(this.notification.user?.getNickname())
            .fontColor($r('app.color.chat_color_conv_item_name'))
            .attributeModifier(new TextSingleLineAttributeModifier())
            .attributeModifier(new TextTitleMediumAttributeModifier())

          Text(this.notification.content)
            .fontColor($r('app.color.chat_color_text_secondary'))
            .attributeModifier(new TextTitleSmallAttributeModifier())
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        Button(this.getButtonContent(), {type: ButtonType.Normal, buttonStyle: ButtonStyleMode.NORMAL})
          .width(76)
          .height(28)
          .backgroundColor($r('app.color.chat_color_emphasize'))
          .stateStyles({
            disabled: {
              .backgroundColor($r('app.color.chat_color_switch_bg_off'))
            }
          })
          .enabled(this.notification.status === NotificationStatus.CONTACT_INVITED)
          .visibility(this.getButtonContent() === '' ? Visibility.Hidden : Visibility.Visible)
          .border({
            radius: $r('app.float.corner_radius_small_extra')
          })
          .fontColor($r('app.color.chat_color_text_primary_contrary'))
          .attributeModifier(new TextLabelMediumAttributeModifier())
          .onClick(() => {
            this.onAddClick?.(this.notification);
          })

      }
      .width(KitConstants.FULL_WIDTH)
      .layoutWeight(1)
      .alignItems(VerticalAlign.Center)
      .alignSelf(ItemAlign.Center)
      .padding({
        start: LengthMetrics.resource($r('app.float.chat_margin_common_large')),
        end: LengthMetrics.resource($r('app.float.chat_margin_common_large'))
      })

      if (this.dividerVisible) {
        Divider().strokeWidth(1).color($r('app.color.chat_color_list_separator')).margin({start: LengthMetrics.vp(68)})
      }
    }
    .height(60)
    .width('100%')

  }

  private getButtonContent() {
    if (this.notification.status === NotificationStatus.CONTACT_INVITED) {
      return $r('app.string.add');
    } else if (this.notification.status === NotificationStatus.CONTACT_AGREED) {
      return $r('app.string.new_request_agreed');
    } else if (this.notification.status === NotificationStatus.CONTACT_REFUSED) {
      return $r('app.string.new_request_refused');
    }
    return ''
  }
}