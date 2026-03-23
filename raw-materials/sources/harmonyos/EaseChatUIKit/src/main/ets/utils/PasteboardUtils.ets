import pasteboard from '@ohos.pasteboard';

/**
 * 复制到剪切板。
 * @param content
 * @returns
 */
export function copyToPasteboard(content?: string): boolean {
  if (!content) {
    return false;
  }
  // 创建一条纯文本类型的剪贴板内容对象
  let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, content);
  // 将数据写入系统剪贴板
  let systemPasteboard = pasteboard.getSystemPasteboard();
  systemPasteboard.setData(pasteData);
  return true;
}