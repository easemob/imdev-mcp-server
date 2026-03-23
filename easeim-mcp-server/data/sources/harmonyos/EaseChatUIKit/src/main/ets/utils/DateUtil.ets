import { intl } from '@kit.LocalizationKit';

/**
 * 格式化消息日期
 * @param timestamp
 * @returns
 */
export function formatMessageDate(timestamp: number): string {
  let date = new Date(timestamp);
  let options: DateTimeOptions = {};
  if (isSameDay(date)) {
    // 显示效果：16:28
    options = {timeStyle: 'short', hourCycle: 'h24'};
  } else if (isSameYear(date)) {
    // 显示效果：2月10日 16:28
    options = {month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hourCycle: 'h24'};
  } else {
    // 显示效果：2025年2月10日 16:28
    options = {year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hourCycle: 'h24'};
  }
  return formatDate(date, options);
}

/**
 * 格式化会话条目的日志
 * @param timestamp
 * @returns
 */
export function formatConversationDate(timestamp: number): string {
  let date = new Date(timestamp);
  let options: DateTimeOptions = {};
  if (isSameDay(date)) {
    options = {timeStyle: 'short', hourCycle: 'h24'};
  } else if (isSameYear(date)) {
    options = {month: 'long', day: 'numeric'};
  } else {
    options = {dateStyle: 'long'};
  }
  return formatDate(date, options);
}

/**
 * 格式化日期。
 *
 * 默认样式为：9月17日 13:04
 * @param { string | Date } date - 时间戳的字符串形式或者日期
 * @param { DateTimeOptions } options - 日期格式
 * @param { string | Array<string> } locale - 区域参数
 * @returns
 */
export function formatDate(date: string | number | Date,
  options: DateTimeOptions = {month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hourCycle: 'h24'},
  locale: string | Array<string> = 'zh-CN') {
  let d: Date;
  if (typeof date === 'string') {
    const timestamp = parseInt(date);
    d = new Date(timestamp);
  } else if (typeof date === 'number'){
    d = new Date(date);
  } else {
    d = date;
  }
  let dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat(locale, options);
  return dateFormat.format(d);
}

function fillNum(num: number) {
  if (num < 10) {
    return `0${num}`;
  }
  return num.toString();
}

/**
 * 格式化时间。
 * @param time
 * @returns
 */
export function formatTime(time: number | undefined) {
  if (time == -1 || time == undefined) {
    time = 0;
  }
  const TIMESTAMP: number = 1000;
  const TIME_UNIT: number = 60;
  const MAX_HOURS: number = 24;
  let hour = Math.floor(time % (TIMESTAMP * TIME_UNIT * TIME_UNIT * MAX_HOURS) / (TIMESTAMP * TIME_UNIT * TIME_UNIT));
  let minute = Math.floor(time % (TIMESTAMP * TIME_UNIT * TIME_UNIT) / (TIMESTAMP * TIME_UNIT));
  let second = Math.floor(time % (TIMESTAMP * TIME_UNIT) / TIMESTAMP);
  if (hour > 0) {
    return `${fillNum(hour)}:${fillNum(minute)}:${fillNum(second)}`;
  }
  return `${fillNum(minute)}:${fillNum(second)}`;
}

/**
 * 是否是同一年。
 *
 * 如果date2没有传入，则和当前年份进行对比。
 * @param date
 * @returns
 */
export function isSameYear(date: Date, date2?: Date): boolean {
  let current = date2 ?? new Date();
  return current.getFullYear() === date.getFullYear();
}

/**
 * 是否是同一月份。
 *
 * 如果date2没有传入，则和当前时间进行对比。
 * @param date
 * @returns
 */
export function isSameMonth(date: Date, date2?: Date): boolean {
  let current = date2 ?? new Date();
  return current.getFullYear() === date.getFullYear() &&
    current.getMonth() === date.getMonth();
}

/**
 * 是否是同一天。
 *
 * 如果date2没有传入，则和当前时间进行对比。
 * @param date
 * @returns
 */
export function isSameDay(date: Date, date2?: Date): boolean {
  let current = date2 ?? new Date();
  return isSameMonth(date, current) &&
    current.getDate() === date.getDate();
}