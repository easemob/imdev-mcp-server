import { ContentType, MessageStatus } from '@easemob/chatsdk';
import { ChatKitConversation, KitConstants } from '../../../../../Index';
import { ChatKitMessage } from '../../model/ChatKitMessage';
import { BottomSheetDialogOptions } from '../../model/DialogOptions';
import { ConvMenuItem, MenuItem, MessageMenuItem, ShowAsAction } from '../../model/Menu';
import { isMessageCanEdit, isMessageCanRecall } from '../../utils/MessageUtil';

/**
 * 聊天消息长按默认菜单项。
 * @param onMenuClick
 * @returns
 */
export function defaultChatMessageMenus(message: ChatKitMessage, onMenuClick: (id: string | number, message : ChatKitMessage) => void): MessageMenuItem[] {

  return [
    {
      id: KitConstants.MESSAGE_MENU_ACTION_COPY,
      value: $r('app.string.chat_message_menu_copy'),
      icon: $r('app.media.chat_icon_message_menu_copy'),
      messageEnable: {
        messageTypes: [ContentType.TXT]
      },
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    },
    {
      id: KitConstants.MESSAGE_MENU_ACTION_REPLY,
      value: $r('app.string.chat_message_menu_reply'),
      icon: $r('app.media.chat_icon_message_menu_reply'),
      messageEnable: {
        messageStatus: [MessageStatus.SUCCESS]
      },
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    },
    {
      id: KitConstants.MESSAGE_MENU_ACTION_FORWARD,
      value: $r('app.string.chat_message_menu_forward'),
      icon: $r('app.media.chat_icon_message_menu_forward'),
      messageEnable: {
        messageStatus: [MessageStatus.SUCCESS],
        other: false
      },
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    },
    {
      id: KitConstants.MESSAGE_MENU_ACTION_EDIT,
      value: $r('app.string.chat_message_menu_edit'),
      icon: $r('app.media.chat_icon_message_menu_edit'),
      messageEnable: {
        isSender: true,
        messageStatus: [MessageStatus.SUCCESS],
        messageTypes: [ContentType.TXT],
        other: isMessageCanEdit(message.origin)
      },
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    },
    {
      id: KitConstants.MESSAGE_MENU_ACTION_REPORT,
      value: $r('app.string.chat_message_menu_report'),
      icon: $r('app.media.chat_icon_message_menu_report'),
      messageEnable: {
        isSender: false,
        messageStatus: [MessageStatus.SUCCESS],
        other: false
      },
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    },
    {
      id: KitConstants.MESSAGE_MENU_ACTION_DELETE,
      value: $r('app.string.chat_message_menu_delete'),
      icon: $r('app.media.chat_icon_message_menu_delete'),
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    },
    {
      id: KitConstants.MESSAGE_MENU_ACTION_RECALL,
      value: $r('app.string.chat_message_menu_recall'),
      icon: $r('app.media.chat_icon_message_menu_recall'),
      messageEnable: {
        isSender: true,
        messageStatus: [MessageStatus.SUCCESS],
        other: isMessageCanRecall(message.origin)
      },
      onMenuClick: (id: string | number, message : ChatKitMessage) => {
        onMenuClick(id, message);
      }
    }
  ]
}

/**
 * 默认的多媒体选项：相机或者摄像
 * @param action
 * @returns
 */
export function defaultMediaSelectOptions(action: (id: string | number) => void): BottomSheetDialogOptions {
  return {
    alignment: DialogAlignment.Bottom,
    menus: [
      {
        id: KitConstants.MEDIA_TYPE_SELECT_ACTION_PHONE,
        value: $r('app.string.chat_media_type_phone'),
        action: (id: string | number) => {
          action(id);
        }
      },
      {
        id: KitConstants.MEDIA_TYPE_SELECT_ACTION_VIDEO,
        value: $r('app.string.chat_media_type_video'),
        action: (id: string | number) => {
          action(id);
        }
      }
    ],
    autoCancel: true
  }
}

/**
 * 默认的聊天扩展项
 * @param action
 * @returns
 */
export function defaultChatMoreExtendMenus(action: (id: string | number) => void): MenuItem[] {
  return [
    {
      id: KitConstants.EXTEND_ACTION_CAMERA,
      value: $r('app.string.chat_extend_more_camera'),
      icon: $r('app.media.chat_icon_extend_more_camera'),
      order: 2,
      action: (id: string | number) => {
        action(id);
      }
    },
    {
      id: KitConstants.EXTEND_ACTION_IMAGE,
      value: $r('app.string.chat_extend_more_image'),
      icon: $r('app.media.chat_icon_extend_more_image'),
      order: 1,
      action: (id: string | number) => {
        action(id);
      }
    },
    {
      id: KitConstants.EXTEND_ACTION_FILE,
      value: $r('app.string.chat_extend_more_file'),
      icon: $r('app.media.chat_icon_extend_more_file'),
      order: 3,
      action: (id: string | number) => {
        action(id);
      }
    },
    {
      id: KitConstants.EXTEND_ACTION_USER,
      value: $r('app.string.chat_extend_more_user'),
      icon: $r('app.media.chat_icon_extend_more_user'),
      order: 4,
      action: (id: string | number) => {
        action(id);
      }
    }
  ]
}

/**
 * 默认会话条目菜单。
 * @param action
 * @returns
 */
export function defaultConvItemMenus(action: (id: string | number, conv: ChatKitConversation) => void): ConvMenuItem[] {
  return [
    {
      id: KitConstants.CONV_MENU_ACTION_MUTE,
      value: $r('app.string.conv_item_action_mute'),
      icon: $r('app.media.chat_icon_conv_menu_mute'),
      backgroundColor: $r('app.color.chat_color_conv_item_menu_bg_mute'),
      onMenuClick: (id: string | number, conv: ChatKitConversation) => {
        action(id, conv);
      }
    },
    {
      id: KitConstants.CONV_MENU_ACTION_UNMUTE,
      value: $r('app.string.conv_item_action_unmute'),
      icon: $r('app.media.chat_icon_conv_menu_unmute'),
      backgroundColor: $r('app.color.chat_color_conv_item_menu_bg_mute'),
      onMenuClick: (id: string | number, conv: ChatKitConversation) => {
        action(id, conv);
      }
    },
    {
      id: KitConstants.CONV_MENU_ACTION_PIN,
      value: $r('app.string.conv_item_action_pin'),
      icon: $r('app.media.chat_icon_conv_menu_pin'),
      backgroundColor: $r('app.color.chat_color_conv_item_menu_bg_pin'),
      onMenuClick: (id: string | number, conv: ChatKitConversation) => {
        action(id, conv);
      }
    },
    {
      id: KitConstants.CONV_MENU_ACTION_UNPIN,
      value: $r('app.string.conv_item_action_unpin'),
      icon: $r('app.media.chat_icon_conv_menu_unpin'),
      backgroundColor: $r('app.color.chat_color_conv_item_menu_bg_pin'),
      onMenuClick: (id: string | number, conv: ChatKitConversation) => {
        action(id, conv);
      }
    },
    {
      id: KitConstants.CONV_MENU_ACTION_DELETE,
      value: $r('app.string.conv_item_action_delete'),
      icon: $r('app.media.chat_icon_conv_menu_delete'),
      backgroundColor: $r('app.color.chat_color_conv_item_menu_bg_delete'),
      onMenuClick: (id: string | number, conv: ChatKitConversation) => {
        action(id, conv);
      }
    },
  ]
}

/**
 * 会话列表页面，标题栏菜单项
 * @param action
 * @returns
 */
export function defaultConvOperationMenus(action: (id: string | number) => void): MenuItem[] {
  return [
    {
      id: KitConstants.CONV_PAGE_ACTION_NEW_CHAT,
      value: $r('app.string.conv_page_action_new_chat'),
      icon: $r('app.media.chat_icon_new_chat'),
      showAsAction: ShowAsAction.never,
      action: (id) => {
        action(id);
      }
    },
    {
      id: KitConstants.CONV_PAGE_ACTION_ADD_CONTACT,
      value: $r('app.string.conv_page_action_add_contact'),
      icon: $r('app.media.chat_icon_add_contact'),
      showAsAction: ShowAsAction.never,
      action: (id) => {
        action(id);
      }
    },
    {
      id: KitConstants.CONV_PAGE_ACTION_CREATE_GROUP,
      value: $r('app.string.conv_page_action_create_group'),
      icon: $r('app.media.chat_icon_create_group'),
      showAsAction: ShowAsAction.never,
      action: (id) => {
        action(id);
      }
    },
  ]
}

/**
 * 联系人列表页面，标题栏菜单项
 * @param action
 * @returns
 */
export function defaultContactListOperationMenus(action: (id: string | number) => void): MenuItem[] {
  return [
    {
      id: KitConstants.CONTACT_LIST_PAGE_ACTION_ADD_CONTACT,
      value: $r('app.string.contact_list_page_action_add_contact'),
      icon: $r('app.media.chat_icon_contact_add'),
      showAsAction: ShowAsAction.ifRoom,
      action: (id) => {
        action(id);
      }
    }
  ]
}