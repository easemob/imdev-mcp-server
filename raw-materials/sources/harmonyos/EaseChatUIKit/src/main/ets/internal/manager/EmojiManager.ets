import { EmojiIconDefaultData, TextParseResult, TextParseType } from '../model/EmojiIcon';

export class EmojiManager {
  static readonly DELETE_KEY = "em_delete_delete_expression";

  private emojiMap: Map<string, object | ResourceStr> = new Map();

  private static instance: EmojiManager | undefined;

  private constructor() {
    EmojiIconDefaultData.createEmojiData().forEach(item => {
      if (item.emojiText && item.icon) {
        this.emojiMap.set(item.emojiText, item.icon);
      }
    })
  }

  static getInstance(): EmojiManager {
    if (!EmojiManager.instance) {
      EmojiManager.instance = new EmojiManager();
    }
    return EmojiManager.instance!!
  }

  private getEmojiIconByEmoji(emojiText: string): object | ResourceStr | undefined {
    return this.emojiMap.get(emojiText)
  }

  private getEmojiRegSourceCode() {
    let sourceCode = `[`;
    EmojiIconDefaultData.unicodeMapping.forEach((unicode, emoji) => {
      sourceCode += `\\${unicode}|`;
    })
    sourceCode = sourceCode.substring(0, sourceCode.length - 1);
    sourceCode += ']';
    return sourceCode;
  }

  parseMessageContent(content?: string): TextParseResult[] | undefined {
    if (!content) {
      return undefined;
    }

    let sourceCode = this.getEmojiRegSourceCode();
    let flags = `gu`;
    let emojiRegex = new RegExp(sourceCode, flags);
    let lastMatchIndex = 0;
    let isFinish = false;
    const parseResult: TextParseResult[] = [];
    while (!isFinish) {
      // 使用match方法来查找字符串中的表情符号
      let match = emojiRegex.exec(content);
      if (match) {
        let emoji = match[0];
        const emojiIcon = this.getEmojiIconByEmoji(emoji);
        if (emojiIcon) {
          const nonMatchStr = content.substring(lastMatchIndex, match.index);
          lastMatchIndex = match.index + match[0].length;
          if (nonMatchStr.length > 0) {
            const textResult = new TextParseResult();
            textResult.parseType = TextParseType.Text;
            textResult.text = nonMatchStr;
            parseResult.push(textResult);
          }
          const emojiResult = new TextParseResult();
          emojiResult.parseType = TextParseType.Emoji;
          emojiResult.emoji = emojiIcon;
          parseResult.push(emojiResult);
        } else {
          const matchStr = content.substring(lastMatchIndex, match.index + match[0].length);
          lastMatchIndex = match.index + match[0].length;
          const textResult = new TextParseResult();
          textResult.parseType = TextParseType.Text;
          textResult.text = matchStr;
          parseResult.push(textResult);
        }
      } else {
        // 没有找到匹配项
        if (lastMatchIndex < content.length) {
          const textResult = new TextParseResult();
          textResult.parseType = TextParseType.Text;
          textResult.text = content.substring(lastMatchIndex, content.length);
          parseResult.push(textResult);
        }
        isFinish = true;
      }
    }
    return parseResult;
  }

  getEmojiByRawResource(raw: ResourceStr | undefined) {
    if (raw && raw.toString().length > 0) {
      let path = raw.toString();
      let splits = path.split("/")
      // 获取到rawfile资源下的资源名称
      let rawName = splits[splits.length - 1];
      // 文件名为'emoji_3.png'
      let number = Number.parseInt(rawName.substring(6, rawName.length - 4));
      let emoji = EmojiIconDefaultData.createEmojiData()[number - 1]
      return emoji.emojiText;
    }
    return '';
  }

}