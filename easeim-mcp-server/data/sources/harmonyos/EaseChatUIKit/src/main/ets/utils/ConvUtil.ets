
/**
 * 未读数处理逻辑/
 * @param count
 * @param maxCount
 * @returns
 */
export function unreadCount(count: number, maxCount?: number) {
  if (!maxCount) {
    maxCount = 99;
  }
  if (count <= 0) {
    return '';
  }
  if (count > maxCount) {
    return `${maxCount}+`;
  }
  return `${count}`;
}