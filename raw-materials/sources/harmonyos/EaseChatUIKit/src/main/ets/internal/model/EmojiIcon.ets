export class EmojiIcon {
  icon: ResourceStr;
  emojiText: string;
  type: EmojiIconType;
  identityCode?: string;
  bigIcon: number = -1;
  name?: string;
  iconPath?: string;
  bigIconPath?: string;
  enableClick: boolean = true;

  constructor(icon: ResourceStr, emojiText: string, type: EmojiIconType) {
    this.icon = icon;
    this.emojiText = emojiText;
    this.type = type;
  }

}

export enum EmojiIconType {
  /**
   * normal icon, can be input one or more in edit view
   */
  NORMAL,

  /**
   * big icon, send out directly when your press it
   */
  BIG_EXPRESSION
}

/**
 * 文本消息解析结果类
 */
export class TextParseResult {
  parseType: TextParseType = TextParseType.Text;
  text?: string;
  emoji?: object | ResourceStr;
}

export enum TextParseType {
  Text,
  Emoji
}

export class EmojiIconDefaultData {
  // emoji常量
  static readonly ee_1 = "😀";
  static readonly ee_2 = "😄";
  static readonly ee_3 = "😉";
  static readonly ee_4 = "😮";
  static readonly ee_5 = "🤪";
  static readonly ee_6 = "😎";
  static readonly ee_7 = "🥱";
  static readonly ee_8 = "🥴";
  static readonly ee_9 = "☺️";
  static readonly ee_10 = "🙁";
  static readonly ee_11 = "😭";
  static readonly ee_12 = "😐";
  static readonly ee_13 = "😇";
  static readonly ee_14 = "😬";
  static readonly ee_15 = "🤓";
  static readonly ee_16 = "😳";
  static readonly ee_17 = "🥳";
  static readonly ee_18 = "😠";
  static readonly ee_19 = "🙄";
  static readonly ee_20 = "🤐";
  static readonly ee_21 = "🥺";
  static readonly ee_22 = "🤨";
  static readonly ee_23 = "😫";
  static readonly ee_24 = "😷";
  static readonly ee_25 = "🤒";
  static readonly ee_26 = "😱";
  static readonly ee_27 = "😘";
  static readonly ee_28 = "😍";
  static readonly ee_29 = "🤢";
  static readonly ee_30 = "👿";
  static readonly ee_31 = "🤬";
  static readonly ee_32 = "😡";
  static readonly ee_33 = "👍";
  static readonly ee_34 = "👎";
  static readonly ee_35 = "👏";
  static readonly ee_36 = "🙌";
  static readonly ee_37 = "🤝";
  static readonly ee_38 = "🙏";
  static readonly ee_39 = "❤️";
  static readonly ee_40 = "💔";
  static readonly ee_41 = "💕";
  static readonly ee_42 = "💩";
  static readonly ee_43 = "💋";
  static readonly ee_44 = "☀️";
  static readonly ee_45 = "🌜";
  static readonly ee_46 = "🌈";
  static readonly ee_47 = "⭐";
  static readonly ee_48 = "🌟";
  static readonly ee_49 = "🎉";
  static readonly ee_50 = "💐";
  static readonly ee_51 = "🎂";
  static readonly ee_52 = "🎁";
  // 为兼容旧版uikit
  private static readonly ee_53 = "\uD83C\uDF85"
  private static readonly ee_54 = "\uD83D\uDE34"
  private static readonly ee_55 = "😕"
  private static readonly ee_56 = "😯"
  private static readonly ee_57 = "\uD83D\uDE0F"
  private static readonly ee_58 = "\uD83D\uDE11"
  private static readonly ee_59 = "🌹"
  private static readonly ee_60 = "\uD83C\uDF42"
  private static readonly ee_61 = "😂"
  private static readonly ee_62 = "🤗"
  private static readonly ee_63 = "👌"
  private static readonly ee_64 = "💣"

  private static readonly unicode_ee_1 = "u{1F600}"; // 😀
  private static readonly unicode_ee_2 = "u{1F604}"; // 😄
  private static readonly unicode_ee_3 = "u{1F609}"; // 😉
  private static readonly unicode_ee_4 = "u{1F62E}"; // 😮
  private static readonly unicode_ee_5 = "u{1F92A}"; // 🤪
  private static readonly unicode_ee_6 = "u{1F60E}"; // 😎
  private static readonly unicode_ee_7 = "u{1F971}"; // 🥱
  private static readonly unicode_ee_8 = "u{1F974}"; // 🥴
  private static readonly unicode_ee_9 = "u{263A}"; // ☺️
  private static readonly unicode_ee_10 = "u{1F641}"; // 🙁
  private static readonly unicode_ee_11 = "u{1F62D}"; // 😭
  private static readonly unicode_ee_12 = "u{1F610}"; // 😐
  private static readonly unicode_ee_13 = "u{1F607}"; // 😇
  private static readonly unicode_ee_14 = "u{1F62C}"; // 😬
  private static readonly unicode_ee_15 = "u{1F913}"; // 🤓
  private static readonly unicode_ee_16 = "u{1F633}"; // 😳
  private static readonly unicode_ee_17 = "u{1F973}"; // 🥳
  private static readonly unicode_ee_18 = "u{1F620}"; // 😠
  private static readonly unicode_ee_19 = "u{1F644}"; // 🙄
  private static readonly unicode_ee_20 = "u{1F910}"; // 🤐
  private static readonly unicode_ee_21 = "u{1F97A}"; // 🥺
  private static readonly unicode_ee_22 = "u{1F928}"; // 🤨
  private static readonly unicode_ee_23 = "u{1F62B}"; // 😫
  private static readonly unicode_ee_24 = "u{1F637}"; // 😷
  private static readonly unicode_ee_25 = "u{1F912}"; // 🤒
  private static readonly unicode_ee_26 = "u{1F631}"; // 😱
  private static readonly unicode_ee_27 = "u{1F618}"; // 😘
  private static readonly unicode_ee_28 = "u{1F60D}"; // 😍
  private static readonly unicode_ee_29 = "u{1F922}"; // 🤢
  private static readonly unicode_ee_30 = "u{1F47F}"; // 👿
  private static readonly unicode_ee_31 = "u{1F92C}"; // 🤬
  private static readonly unicode_ee_32 = "u{1F621}"; // 😡
  private static readonly unicode_ee_33 = "u{1F44D}"; // 👍
  private static readonly unicode_ee_34 = "u{1F44E}"; // 👎
  private static readonly unicode_ee_35 = "u{1F44F}"; // 👏
  private static readonly unicode_ee_36 = "u{1F64C}"; // 🙌
  private static readonly unicode_ee_37 = "u{1F91D}"; // 🤝
  private static readonly unicode_ee_38 = "u{1F64F}"; // 🙏
  private static readonly unicode_ee_39 = "u{2764}"; // ❤️
  private static readonly unicode_ee_40 = "u{1F494}"; // 💔
  private static readonly unicode_ee_41 = "u{1F495}"; // 💕
  private static readonly unicode_ee_42 = "u{1F4A9}"; // 💩
  private static readonly unicode_ee_43 = "u{1F48B}"; // 💋
  private static readonly unicode_ee_44 = "u{2600}"; // ☀️
  private static readonly unicode_ee_45 = "u{1F31C}"; // 🌜
  private static readonly unicode_ee_46 = "u{1F308}"; // 🌈
  private static readonly unicode_ee_47 = "u{2B50}"; // ⭐
  private static readonly unicode_ee_48 = "u{1F31F}"; // 🌟
  private static readonly unicode_ee_49 = "u{1F389}"; // 🎉
  private static readonly unicode_ee_50 = "u{1F490}"; // 💐
  private static readonly unicode_ee_51 = "u{1F382}"; // 🎂
  private static readonly unicode_ee_52 = "u{1F381}"; // 🎁
  // 为兼容旧版uikit的表情
  private static readonly unicode_ee_53 = "u{1F385}"; // "\uD83C\uDF85"
  private static readonly unicode_ee_54 = "u{1F634}"; // "\uD83D\uDE34"
  private static readonly unicode_ee_55 = "u{1F615}"; // 😕
  private static readonly unicode_ee_56 = "u{1F62F}"; // 😯
  private static readonly unicode_ee_57 = "u{1F60F}"; // \uD83D\uDE0F
  private static readonly unicode_ee_58 = "u{1F611}"; // \uD83D\uDE11
  private static readonly unicode_ee_59 = "u{1F339}"; // 🌹
  private static readonly unicode_ee_60 = "u{1F342}"; // \uD83C\uDF42
  private static readonly unicode_ee_61 = "u{1F602}"; // 😂
  private static readonly unicode_ee_62 = "u{1F917}"; // 🤗
  private static readonly unicode_ee_63 = "u{1F44C}"; // 👌
  private static readonly unicode_ee_64 = "u{1F4A3}"; // 💣
  // 旧版本emoji常量
  private static readonly o_ee_1 = "[):]";
  private static readonly o_ee_2 = "[:D]";
  private static readonly o_ee_3 = "[;)]";
  private static readonly o_ee_4 = "[:-o]";
  private static readonly o_ee_5 = "[:p]";
  private static readonly o_ee_6 = "[(H)]";
  private static readonly o_ee_7 = "[:@]";
  private static readonly o_ee_8 = "[:s]";
  private static readonly o_ee_9 = "[:$]";
  private static readonly o_ee_10 = "[:(]";
  private static readonly o_ee_11 = "[:'(]";
  private static readonly o_ee_12 = "[:|]";
  private static readonly o_ee_13 = "[(a)]";
  private static readonly o_ee_14 = "[8o|]";
  private static readonly o_ee_15 = "[8-|]";
  private static readonly o_ee_16 = "[+o(]";
  private static readonly o_ee_17 = "[<o)]";
  private static readonly o_ee_18 = "[|-)]";
  private static readonly o_ee_19 = "[*-)]";
  private static readonly o_ee_20 = "[:-#]";
  private static readonly o_ee_21 = "[:-*]";
  private static readonly o_ee_22 = "[^o)]";
  private static readonly o_ee_23 = "[8-)]";
  private static readonly o_ee_24 = "[(|)]";
  private static readonly o_ee_25 = "[(u)]";
  private static readonly o_ee_26 = "[(S)]";
  private static readonly o_ee_27 = "[(*)]";
  private static readonly o_ee_28 = "[(#)]";
  private static readonly o_ee_29 = "[(R)]";
  private static readonly o_ee_30 = "[({)]";
  private static readonly o_ee_31 = "[(})]";
  private static readonly o_ee_32 = "[(k)]";
  private static readonly o_ee_33 = "[(F)]";
  private static readonly o_ee_34 = "[(W)]";
  private static readonly o_ee_35 = "[(D)]";
  private static readonly o_ee_36 = "[(E)]";
  private static readonly o_ee_37 = "[(T)]";
  private static readonly o_ee_38 = "[(G)]";
  private static readonly o_ee_39 = "[(Y)]";
  private static readonly o_ee_40 = "[(I)]";
  private static readonly o_ee_41 = "[(J)]";
  private static readonly o_ee_42 = "[(K)]";
  private static readonly o_ee_43 = "[(L)]";
  private static readonly o_ee_44 = "[(M)]";
  private static readonly o_ee_45 = "[(N)]";
  private static readonly o_ee_46 = "[(O)]";
  private static readonly o_ee_47 = "[(P)]";
  private static readonly o_ee_48 = "[(U)]";
  private static readonly o_ee_49 = "[(Z)]";
  private static readonly o_ee_50 = "[-)]";
  private static readonly o_ee_51 = "[:-]";
  private static readonly o_ee_52 = "☺";

  // 新旧emoji映射表
  static mapping: Map<string, string> = new Map([
    [EmojiIconDefaultData.o_ee_1, EmojiIconDefaultData.ee_9],// ☺️
    [EmojiIconDefaultData.o_ee_2, EmojiIconDefaultData.ee_2],// "😄"
    [EmojiIconDefaultData.o_ee_3, EmojiIconDefaultData.ee_3],// "😉"
    [EmojiIconDefaultData.o_ee_4, EmojiIconDefaultData.ee_4],// "😮"
    [EmojiIconDefaultData.o_ee_5, EmojiIconDefaultData.ee_5],// \uD83E\uDD2A
    [EmojiIconDefaultData.o_ee_6, EmojiIconDefaultData.ee_6],// 😎
    [EmojiIconDefaultData.o_ee_7, EmojiIconDefaultData.ee_32],// 😡
    [EmojiIconDefaultData.o_ee_8, EmojiIconDefaultData.ee_8],// \uD83E\uDD74
    [EmojiIconDefaultData.o_ee_9, EmojiIconDefaultData.ee_16],// 😳
    [EmojiIconDefaultData.o_ee_10, EmojiIconDefaultData.ee_10],// 🙁
    [EmojiIconDefaultData.o_ee_11, EmojiIconDefaultData.ee_11],// 😭
    [EmojiIconDefaultData.o_ee_12, EmojiIconDefaultData.ee_12],// 😐
    [EmojiIconDefaultData.o_ee_13, EmojiIconDefaultData.ee_13],// 😇
    [EmojiIconDefaultData.o_ee_14, EmojiIconDefaultData.ee_14],// 😬
    [EmojiIconDefaultData.o_ee_15, EmojiIconDefaultData.ee_15],// \uD83E\uDD13
    [EmojiIconDefaultData.o_ee_16, EmojiIconDefaultData.ee_26],// 😱
    [EmojiIconDefaultData.o_ee_17, EmojiIconDefaultData.ee_53],// \uD83C\uDF85 "u{1F385}"
    [EmojiIconDefaultData.o_ee_18, EmojiIconDefaultData.ee_54],// \uD83D\uDE34 "u{1F634}"
    [EmojiIconDefaultData.o_ee_19, EmojiIconDefaultData.ee_55],// 😕 "u{1F615}"
    [EmojiIconDefaultData.o_ee_20, EmojiIconDefaultData.ee_24],// 😷
    [EmojiIconDefaultData.o_ee_21, EmojiIconDefaultData.ee_56],// 😯 "u{1F62F}"
    [EmojiIconDefaultData.o_ee_22, EmojiIconDefaultData.ee_57],// \uD83D\uDE0F "u{1F60F}"
    [EmojiIconDefaultData.o_ee_23, EmojiIconDefaultData.ee_58],// \uD83D\uDE11 "u{1F611}"
    [EmojiIconDefaultData.o_ee_24, EmojiIconDefaultData.ee_39],// ❤️
    [EmojiIconDefaultData.o_ee_25, EmojiIconDefaultData.ee_40],// 💔
    [EmojiIconDefaultData.o_ee_26, EmojiIconDefaultData.ee_45],// 🌜
    [EmojiIconDefaultData.o_ee_27, EmojiIconDefaultData.ee_48],// 🌟
    [EmojiIconDefaultData.o_ee_28, EmojiIconDefaultData.ee_44],// ☀️
    [EmojiIconDefaultData.o_ee_29, EmojiIconDefaultData.ee_46],// 🌈
    [EmojiIconDefaultData.o_ee_30, EmojiIconDefaultData.ee_28],// 😍
    [EmojiIconDefaultData.o_ee_31, EmojiIconDefaultData.ee_27],// 😘
    [EmojiIconDefaultData.o_ee_32, EmojiIconDefaultData.ee_43],// 💋
    [EmojiIconDefaultData.o_ee_33, EmojiIconDefaultData.ee_59],// 🌹 "u{1F339}"
    [EmojiIconDefaultData.o_ee_34, EmojiIconDefaultData.ee_60],// \uD83C\uDF42 "u{1F342}"
    [EmojiIconDefaultData.o_ee_35, EmojiIconDefaultData.ee_33],// 👍
    [EmojiIconDefaultData.o_ee_36, EmojiIconDefaultData.ee_61],// 😂 "u{1F602}"
    [EmojiIconDefaultData.o_ee_37, EmojiIconDefaultData.ee_62],// 🤗 "u{1F917}"
    [EmojiIconDefaultData.o_ee_38, EmojiIconDefaultData.ee_35],// 👏
    [EmojiIconDefaultData.o_ee_39, EmojiIconDefaultData.ee_37],// 🤝
    [EmojiIconDefaultData.o_ee_40, EmojiIconDefaultData.ee_33],// 👍
    [EmojiIconDefaultData.o_ee_41, EmojiIconDefaultData.ee_34],// 👎
    [EmojiIconDefaultData.o_ee_42, EmojiIconDefaultData.ee_63],// 👌 "u{1F44C}"
    [EmojiIconDefaultData.o_ee_43, EmojiIconDefaultData.ee_39],// ❤️
    [EmojiIconDefaultData.o_ee_44, EmojiIconDefaultData.ee_40],// 💔
    [EmojiIconDefaultData.o_ee_45, EmojiIconDefaultData.ee_64],// 💣  "u{1F4A3}"
    [EmojiIconDefaultData.o_ee_46, EmojiIconDefaultData.ee_42],// 💩
    [EmojiIconDefaultData.o_ee_47, EmojiIconDefaultData.ee_59],// 🌹  x
    [EmojiIconDefaultData.o_ee_48, EmojiIconDefaultData.ee_38],// 🙏
    [EmojiIconDefaultData.o_ee_49, EmojiIconDefaultData.ee_49],// 🎉
    [EmojiIconDefaultData.o_ee_50, EmojiIconDefaultData.ee_29],// 🤢
    [EmojiIconDefaultData.o_ee_51, EmojiIconDefaultData.ee_19],// 🙄
    [EmojiIconDefaultData.o_ee_52, EmojiIconDefaultData.ee_9],// ☺️
  ]);

  static unicodeMapping: Map<string, string> = new Map([
    [EmojiIconDefaultData.ee_1, EmojiIconDefaultData.unicode_ee_1],
    [EmojiIconDefaultData.ee_2, EmojiIconDefaultData.unicode_ee_2],
    [EmojiIconDefaultData.ee_3, EmojiIconDefaultData.unicode_ee_3],
    [EmojiIconDefaultData.ee_4, EmojiIconDefaultData.unicode_ee_4],
    [EmojiIconDefaultData.ee_5, EmojiIconDefaultData.unicode_ee_5],
    [EmojiIconDefaultData.ee_6, EmojiIconDefaultData.unicode_ee_6],
    [EmojiIconDefaultData.ee_7, EmojiIconDefaultData.unicode_ee_7],
    [EmojiIconDefaultData.ee_8, EmojiIconDefaultData.unicode_ee_8],
    [EmojiIconDefaultData.ee_9, EmojiIconDefaultData.unicode_ee_9],
    [EmojiIconDefaultData.ee_10, EmojiIconDefaultData.unicode_ee_10],
    [EmojiIconDefaultData.ee_11, EmojiIconDefaultData.unicode_ee_11],
    [EmojiIconDefaultData.ee_12, EmojiIconDefaultData.unicode_ee_12],
    [EmojiIconDefaultData.ee_13, EmojiIconDefaultData.unicode_ee_13],
    [EmojiIconDefaultData.ee_14, EmojiIconDefaultData.unicode_ee_14],
    [EmojiIconDefaultData.ee_15, EmojiIconDefaultData.unicode_ee_15],
    [EmojiIconDefaultData.ee_16, EmojiIconDefaultData.unicode_ee_16],
    [EmojiIconDefaultData.ee_17, EmojiIconDefaultData.unicode_ee_17],
    [EmojiIconDefaultData.ee_18, EmojiIconDefaultData.unicode_ee_18],
    [EmojiIconDefaultData.ee_19, EmojiIconDefaultData.unicode_ee_19],
    [EmojiIconDefaultData.ee_20, EmojiIconDefaultData.unicode_ee_20],
    [EmojiIconDefaultData.ee_21, EmojiIconDefaultData.unicode_ee_21],
    [EmojiIconDefaultData.ee_22, EmojiIconDefaultData.unicode_ee_22],
    [EmojiIconDefaultData.ee_23, EmojiIconDefaultData.unicode_ee_23],
    [EmojiIconDefaultData.ee_24, EmojiIconDefaultData.unicode_ee_24],
    [EmojiIconDefaultData.ee_25, EmojiIconDefaultData.unicode_ee_25],
    [EmojiIconDefaultData.ee_26, EmojiIconDefaultData.unicode_ee_26],
    [EmojiIconDefaultData.ee_27, EmojiIconDefaultData.unicode_ee_27],
    [EmojiIconDefaultData.ee_28, EmojiIconDefaultData.unicode_ee_28],
    [EmojiIconDefaultData.ee_29, EmojiIconDefaultData.unicode_ee_29],
    [EmojiIconDefaultData.ee_30, EmojiIconDefaultData.unicode_ee_30],
    [EmojiIconDefaultData.ee_31, EmojiIconDefaultData.unicode_ee_31],
    [EmojiIconDefaultData.ee_32, EmojiIconDefaultData.unicode_ee_32],
    [EmojiIconDefaultData.ee_33, EmojiIconDefaultData.unicode_ee_33],
    [EmojiIconDefaultData.ee_34, EmojiIconDefaultData.unicode_ee_34],
    [EmojiIconDefaultData.ee_35, EmojiIconDefaultData.unicode_ee_35],
    [EmojiIconDefaultData.ee_36, EmojiIconDefaultData.unicode_ee_36],
    [EmojiIconDefaultData.ee_37, EmojiIconDefaultData.unicode_ee_37],
    [EmojiIconDefaultData.ee_38, EmojiIconDefaultData.unicode_ee_38],
    [EmojiIconDefaultData.ee_39, EmojiIconDefaultData.unicode_ee_39],
    [EmojiIconDefaultData.ee_40, EmojiIconDefaultData.unicode_ee_40],
    [EmojiIconDefaultData.ee_41, EmojiIconDefaultData.unicode_ee_41],
    [EmojiIconDefaultData.ee_42, EmojiIconDefaultData.unicode_ee_42],
    [EmojiIconDefaultData.ee_43, EmojiIconDefaultData.unicode_ee_43],
    [EmojiIconDefaultData.ee_44, EmojiIconDefaultData.unicode_ee_44],
    [EmojiIconDefaultData.ee_45, EmojiIconDefaultData.unicode_ee_45],
    [EmojiIconDefaultData.ee_46, EmojiIconDefaultData.unicode_ee_46],
    [EmojiIconDefaultData.ee_47, EmojiIconDefaultData.unicode_ee_47],
    [EmojiIconDefaultData.ee_48, EmojiIconDefaultData.unicode_ee_48],
    [EmojiIconDefaultData.ee_49, EmojiIconDefaultData.unicode_ee_49],
    [EmojiIconDefaultData.ee_50, EmojiIconDefaultData.unicode_ee_50],
    [EmojiIconDefaultData.ee_51, EmojiIconDefaultData.unicode_ee_51],
    [EmojiIconDefaultData.ee_52, EmojiIconDefaultData.unicode_ee_52],
    [EmojiIconDefaultData.ee_53, EmojiIconDefaultData.unicode_ee_53],
    [EmojiIconDefaultData.ee_54, EmojiIconDefaultData.unicode_ee_54],
    [EmojiIconDefaultData.ee_55, EmojiIconDefaultData.unicode_ee_55],
    [EmojiIconDefaultData.ee_56, EmojiIconDefaultData.unicode_ee_56],
    [EmojiIconDefaultData.ee_57, EmojiIconDefaultData.unicode_ee_57],
    [EmojiIconDefaultData.ee_58, EmojiIconDefaultData.unicode_ee_58],
    [EmojiIconDefaultData.ee_59, EmojiIconDefaultData.unicode_ee_59],
    [EmojiIconDefaultData.ee_60, EmojiIconDefaultData.unicode_ee_60],
    [EmojiIconDefaultData.ee_61, EmojiIconDefaultData.unicode_ee_61],
    [EmojiIconDefaultData.ee_62, EmojiIconDefaultData.unicode_ee_62],
    [EmojiIconDefaultData.ee_63, EmojiIconDefaultData.unicode_ee_63],
    [EmojiIconDefaultData.ee_64, EmojiIconDefaultData.unicode_ee_64],
  ])

  private static emojis: string[] = [
    EmojiIconDefaultData.ee_1,
    EmojiIconDefaultData.ee_2,
    EmojiIconDefaultData.ee_3,
    EmojiIconDefaultData.ee_4,
    EmojiIconDefaultData.ee_5,
    EmojiIconDefaultData.ee_6,
    EmojiIconDefaultData.ee_7,
    EmojiIconDefaultData.ee_8,
    EmojiIconDefaultData.ee_9,
    EmojiIconDefaultData.ee_10,
    EmojiIconDefaultData.ee_11,
    EmojiIconDefaultData.ee_12,
    EmojiIconDefaultData.ee_13,
    EmojiIconDefaultData.ee_14,
    EmojiIconDefaultData.ee_15,
    EmojiIconDefaultData.ee_16,
    EmojiIconDefaultData.ee_17,
    EmojiIconDefaultData.ee_18,
    EmojiIconDefaultData.ee_19,
    EmojiIconDefaultData.ee_20,
    EmojiIconDefaultData.ee_21,
    EmojiIconDefaultData.ee_22,
    EmojiIconDefaultData.ee_23,
    EmojiIconDefaultData.ee_24,
    EmojiIconDefaultData.ee_25,
    EmojiIconDefaultData.ee_26,
    EmojiIconDefaultData.ee_27,
    EmojiIconDefaultData.ee_28,
    EmojiIconDefaultData.ee_29,
    EmojiIconDefaultData.ee_30,
    EmojiIconDefaultData.ee_31,
    EmojiIconDefaultData.ee_32,
    EmojiIconDefaultData.ee_33,
    EmojiIconDefaultData.ee_34,
    EmojiIconDefaultData.ee_35,
    EmojiIconDefaultData.ee_36,
    EmojiIconDefaultData.ee_37,
    EmojiIconDefaultData.ee_38,
    EmojiIconDefaultData.ee_39,
    EmojiIconDefaultData.ee_40,
    EmojiIconDefaultData.ee_41,
    EmojiIconDefaultData.ee_42,
    EmojiIconDefaultData.ee_43,
    EmojiIconDefaultData.ee_44,
    EmojiIconDefaultData.ee_45,
    EmojiIconDefaultData.ee_46,
    EmojiIconDefaultData.ee_47,
    EmojiIconDefaultData.ee_48,
    EmojiIconDefaultData.ee_49,
    EmojiIconDefaultData.ee_50,
    EmojiIconDefaultData.ee_51,
    EmojiIconDefaultData.ee_52,
  ];

  private static emojiArray: EmojiIcon[] = [];

  private static getEmojiIconResource(num: number): Resource | undefined {
    if (num <= EmojiIconDefaultData.emojis.length) {
      return $rawfile(`emoji/emoji_${num}.png`)
    }
    return undefined;
  }

  /**
   * 默认Emoji数据。
   * @returns
   */
  static createEmojiData(): EmojiIcon[] {
    if (EmojiIconDefaultData.emojiArray.length > 0) {
      return EmojiIconDefaultData.emojiArray;
    }
    EmojiIconDefaultData.emojis.forEach((item, index) => {
      const res = EmojiIconDefaultData.getEmojiIconResource(index + 1);
      if (res) {
        EmojiIconDefaultData.emojiArray.push(new EmojiIcon(res, item, EmojiIconType.NORMAL));
      }
    })
    return EmojiIconDefaultData.emojiArray;
  }

}

