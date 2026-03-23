import { ChatUserInfoManager } from '../../internal/manager/ChatUserInfoManager';
import { ContactModel } from '../../model/ContactModel';
import {
  TextLabelMediumAttributeModifier,
  TextSingleLineAttributeModifier,
  TextTitleMediumAttributeModifier
} from '../../shares/attributeModifiers/TextAttributeModifiers';
import { LengthMetrics } from '@kit.ArkUI';
import { ChatKitContact } from '../../model/ChatKitContact';
import { ItemClickAttributeModifier } from '../../shares/attributeModifiers/ItemAttributeModifier';
import { StringUtil } from '../../utils/StringUtil';
import { KitConstants } from '../../constants/KitConstants';
import { ChatKitGroup } from '../../model/ChatKitGroup';
import { AvatarAttributeModifier } from '../../shares/attributeModifiers/AvatarAttributeModifier';
import uikit from '../../internal/ChatUIKit';

@ComponentV2
export struct ContactItemView {
  @Require @Param contact: ContactModel | ChatKitContact | ChatKitGroup;
  // search style
  @Param isSearchStyle: boolean = false;
  @Param keyword: string = '';
  @Param dividerVisible: boolean = false;
  // check model
  @Param isCheckModel: boolean = false;

  private getName(): string {
    if (this.contact instanceof ContactModel) {
      return ChatUserInfoManager.getInstance().getNickname(this.contact);
    } else if (this.contact instanceof ChatKitContact) {
      return this.contact.nickname ?? this.contact.id;
    } else if (this.contact instanceof ChatKitGroup) {
      if (this.contact.name) {
        return this.contact.name;
      }
      return this.contact.id;
    }
    return '';
  }

  private isItemChecked() {
    if (this.contact instanceof ChatKitContact) {
      return this.contact.isChecked ?? false;
    }
    return false;
  }

  build() {
    Column() {
      Row() {
        if (this.isCheckModel) {
          Image(this.isItemChecked() ? $r('app.media.icon_checked_rectangle') : $r('app.media.icon_unchecked_rectangle'))
            .width(28)
            .height(28)
            .objectFit(ImageFit.Fill)
            .margin({
              right: 12
            })
        }
        Image(this.contact.avatar)
          .width(40)
          .height(40)
          .alt((this.contact instanceof ChatKitGroup) ? $r('app.media.avatar_group_default') : $r('app.media.avatar_default'))
          .objectFit(ImageFit.Fill)
          .attributeModifier(uikit.configs.avatarAttribute ?? new AvatarAttributeModifier(uikit.configs.cornerStyle, 40))
        if (this.isSearchStyle) {
          Text() {
            ForEach(StringUtil.splitByKeyword(this.getName(), this.keyword), (item: string) => {
              if (item === this.keyword) {
                Span(item)
                  .fontColor($r('app.color.chat_color_search_select_keyword'))
              } else {
                Span(item)
                  .fontColor($r('app.color.chat_color_conv_item_name'))
              }
            })
          }
          .margin({
            start: LengthMetrics.vp(12),
            end: LengthMetrics.vp(12)
          })
          .attributeModifier(new TextSingleLineAttributeModifier())
          .attributeModifier(new TextTitleMediumAttributeModifier())
        } else {
          Text(this.getName())
            .fontColor($r('app.color.chat_color_text_primary'))
            .margin({
              start: LengthMetrics.vp(12),
              end: LengthMetrics.vp(12)
            })
            .attributeModifier(new TextSingleLineAttributeModifier())
            .attributeModifier(new TextLabelMediumAttributeModifier())
            .layoutWeight(1)
        }
      }
      .width(KitConstants.FULL_WIDTH)
      .layoutWeight(1)

      if (this.dividerVisible) {
        Divider().strokeWidth(1).color($r('app.color.chat_color_list_separator')).margin({start: LengthMetrics.vp(52)})
      }
    }
    .padding({
      start: LengthMetrics.vp(16)
    })
    .height(60)
    .width('100%')
    .attributeModifier(new ItemClickAttributeModifier())
  }
}