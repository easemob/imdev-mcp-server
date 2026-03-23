import { window } from '@kit.ArkUI';

/**
 * 注册软键盘高度变化的监听。
 * @param context
 * @param callback 返回当前的键盘高度，返回值为整数，单位为vp。
 */
export function registerKeyboardHeightChange(context: Context, callback?: (height: number) => void) {
  window.getLastWindow(context).then(currentWindow => {
    currentWindow.on('keyboardHeightChange', (height: number) => {
      callback?.(px2vp(height));
    });
  });
}

/**
 * 解注册软键盘高度变化的监听。
 * @param context
 */
export function unRegisterKeyboardHeightChange(context: Context) {
  window.getLastWindow(context).then(currentWindow => {
    currentWindow.off('keyboardHeightChange');
  });
}