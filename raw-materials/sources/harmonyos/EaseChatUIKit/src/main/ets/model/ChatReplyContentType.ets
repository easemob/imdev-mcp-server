import { ChatMessage } from '@easemob/chatsdk';

export enum ChatReplyContentType {
  /**
   * Map to {@link ChatMessage.ContentType.TXT}
   */
  txt,

  /**
   * Map to {@link ChatMessage.ContentType.IMAGE}
   */
  img,

  /**
   * Map to {@link ChatMessage.ContentType.VIDEO}
   */
  video,

  /**
   * Map to {@link ChatMessage.ContentType.LOCATION}
   */
  location,

  /**
   * Map to {@link ChatMessage.ContentType.VOICE}
   */
  audio,

  /**
   * Map to {@link ChatMessage.ContentType.FILE}
   */
  file,

  /**
   * Map to {@link ChatMessage.ContentType.CMD}
   */
  cmd,

  /**
   * Map to {@link ChatMessage.ContentType.CUSTOM}
   */
  custom,

  /**
   * Map to {@link ChatMessage.ContentType.COMBINE}
   */
  combine,
  unknown
}