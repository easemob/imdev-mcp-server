export class KitConstants {
  /**
   * Component size
   */
  static readonly FULL_HEIGHT: string = '100%';
  static readonly FULL_WIDTH: string = '100%';
  static readonly AUTO_HEIGHT: string = 'auto';
  static readonly AUTO_WIDTH: string = 'auto';
  /**
   * EventBus flag
   */
  static readonly EVENTBUS_MESSAGE_FLAG = 'message';
  static readonly EVENTBUS_INPUT_FLAG = 'input_type';
  static readonly EVENTBUS_MESSAGE_DOWNLOAD_THUMBNAIL_EXT = 'download_thumbnail';
  static readonly EVENTBUS_CONV_FLAG = 'conversation';
  static readonly EVENTBUS_PAGE_FLAG = 'page';
  static readonly EVENTBUS_NOTIFICATION_FLAG = 'notification';
  static readonly EVENTBUS_CONTACT_FLAG = 'contact';

  static readonly EVENTBUS_UPDATE_ACTION = 'update';
  static readonly EVENTBUS_DELETE_ACTION = 'delete';
  static readonly EVENTBUS_ADD_ACTION = 'add';
  static readonly EVENTBUS_POP_ACTION = 'pop';
  /**
   * User card
   */
  static readonly USER_CARD_EVENT = "userCard";
  static readonly USER_CARD_ID = "uid";
  static readonly USER_CARD_NICK = "nickname";
  static readonly USER_CARD_AVATAR = "avatar";
  /**
   * Extend action id
   */
  static readonly EXTEND_ACTION_CAMERA = 'camera';
  static readonly EXTEND_ACTION_IMAGE = 'image';
  static readonly EXTEND_ACTION_FILE = 'file';
  static readonly EXTEND_ACTION_USER = 'user';
  /**
   * media type select action id
   */
  static readonly MEDIA_TYPE_SELECT_ACTION_PHONE = 'phone';
  static readonly MEDIA_TYPE_SELECT_ACTION_VIDEO = 'video';
  /**
   * Message long press menu action id
   */
  static readonly MESSAGE_MENU_ACTION_COPY = 'copy';
  static readonly MESSAGE_MENU_ACTION_REPLY = 'reply';
  static readonly MESSAGE_MENU_ACTION_FORWARD = 'forward';
  static readonly MESSAGE_MENU_ACTION_EDIT = 'edit';
  static readonly MESSAGE_MENU_ACTION_REPORT = 'report';
  static readonly MESSAGE_MENU_ACTION_DELETE = 'delete';
  static readonly MESSAGE_MENU_ACTION_RECALL = 'recall';
  /**
   * reply
   */
  static readonly REPLY_MSG_ID = "msgID"
  static readonly REPLY_MSG_PREVIEW = "msgPreview"
  static readonly REPLY_MSG_SENDER = "msgSender"
  static readonly REPLY_MSG_TYPE = "msgType"
  static readonly REPLY_MSG_QUOTE = "msgQuote"

  static readonly MESSAGE_ATTR_IS_BIG_EXPRESSION = "em_is_big_expression"
  static readonly MESSAGE_ATTR_AT_MSG = "em_at_list";
  static readonly AT_PREFIX = '@';
  static readonly AT_ALL_LABEL = 'All';

  static readonly MESSAGE_TYPE_RECALL = "message_recall"

  /**
   * Conversation item menu action id
   */
  static readonly CONV_MENU_ACTION_PIN = 'pin';
  static readonly CONV_MENU_ACTION_UNPIN = 'unpin';
  static readonly CONV_MENU_ACTION_MUTE = 'mute';
  static readonly CONV_MENU_ACTION_UNMUTE = 'unmute';
  static readonly CONV_MENU_ACTION_DELETE = 'delete';

  /**
   * Conversation page operation menu action id
   */
  static readonly CONV_PAGE_ACTION_NEW_CHAT = 'new_chat';
  static readonly CONV_PAGE_ACTION_ADD_CONTACT = 'add_contact';
  static readonly CONV_PAGE_ACTION_CREATE_GROUP = 'create_group';

  /**
   * Contact list page operation menu action id
   */
  static readonly CONTACT_LIST_PAGE_ACTION_ADD_CONTACT = 'add_contact';

  /**
   * Create group page operation menu action id
   */
  static readonly CREATE_GROUP_PAGE_ACTION = 'create_group';

  /**
   * Message ext for user infomation.
   */
  static readonly MESSAGE_EXT_USER_INFO_KEY = "ease_chat_uikit_user_info";
  static readonly MESSAGE_EXT_USER_INFO_NICKNAME_KEY = "nickname";
  static readonly MESSAGE_EXT_USER_INFO_AVATAR_KEY = "avatarURL";
  static readonly MESSAGE_EXT_USER_INFO_REMARK_KEY = "remark";

  /**
   * Local request notifications.
   */
  static readonly DEFAULT_SYSTEM_CONV_ID = 'default_system_conv';
  static readonly DEFAULT_SYSTEM_NOTIFICATION_STATUS = 'status';
  static readonly DEFAULT_SYSTEM_NOTIFICATION_FROM = 'from';
  static readonly DEFAULT_SYSTEM_NOTIFICATION_REASON = 'reason';

}