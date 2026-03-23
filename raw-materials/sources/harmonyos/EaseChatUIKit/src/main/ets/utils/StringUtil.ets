import { ChineseHelper, PinyinFormat, PinyinHelper } from '@ohos/pinyin4js';

export class StringUtil {

  /**
   * 判断字符串是否未空。
   * @param { string } str - 字符串。
   * @returns
   */
  static isEmpty(str: string | undefined | null) : boolean {
    return str === null || str === undefined || str === '';
  }

  /**
   * 以关键字拆分字符串。
   * @param str
   * @param keyword
   * @returns
   */
  static splitByKeyword(str: string, keyword: string): string[] {
    let result: string[] = [];
    let index = str.indexOf(keyword);
    while (index != -1) {
      result.push(str.substring(0, index));
      result.push(keyword);
      str = str.slice(index + keyword.length);
      index = str.indexOf(keyword);
    }
    if (str) {
      result.push(str)
    }
    return result;
  }

  /**
   * 获取字符串的第一个字符，如果是汉字，会先转成拼音，再取第一个字符。
   * @param str
   * @returns
   */
  static getPinyin(str?: string): string {
    if (!str) {
      return '';
    }
    if (ChineseHelper.isChinese(str)) {
      return PinyinHelper.convertToPinyinString(str, '', PinyinFormat.WITH_TONE_MARK);
    } else {
      return str;
    }
  }

  /**
   * 获取字符串的第一个字符，如果是汉字，会先转成拼音，再取第一个字符。
   * @param str
   * @returns
   */
  static getFirstLetter(str?: string): string {
    if (!str) {
      return '#';
    }
    let pinyin = StringUtil.getPinyin(str);
    if (!pinyin) {
      return '#';
    }
    let firstLetter = pinyin[0];
    if (!StringUtil.isLetter(firstLetter)) {
      return '#';
    }
    return firstLetter;
  }

  /**
   * 判断是否是字母。
   * @param char
   * @returns
   */
  static isLetter(char: string): boolean {
    const letterRegex = /^[A-Za-z]$$/;
    return letterRegex.test(char);
  }
}