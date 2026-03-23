import { window } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';

/**
 * 获取当前应用内最上层的子窗口，若无应用子窗口，则返回应用主窗口。
 */
class WindowInfo {
  // 单位：vp
  size: window.Size = { width: 0, height: 0 };
  // 单位：vp
  topRectHeight: number = 0;
  // 单位：vp
  bottomRectHeight: number = 0;

  constructor(context?: Context) {
    window.getLastWindow(context ?? getContext(this)).then((value: window.Window) => {
      const avoidAreaType = window.AvoidAreaType.TYPE_SYSTEM; // 系统默认区域，包括状态栏，导航栏
      const avoidArea = value.getWindowAvoidArea(avoidAreaType);
      this.topRectHeight = px2vp(avoidArea.topRect.height);
      this.bottomRectHeight = px2vp(avoidArea.bottomRect.height);

      const rect: window.Rect = value.getWindowProperties().windowRect;
      this.size.width = px2vp(rect.width);
      this.size.height = px2vp(rect.height);
      console.log(`[windowWidth]${this.size.width} [windowHeight]${this.size.height}`);
    })
  }
}

export const windowInfo = new WindowInfo();

export class WindowManager {
  private declare context: Context;
  private static instance: WindowManager | undefined;

  private constructor(context: Context) {
    this.context = context;
  }

  static getInstance(context?: Context): WindowManager {
    if (!WindowManager.instance) {
      WindowManager.instance = new WindowManager(context ?? getContext());
    }
    return WindowManager.instance
  }

  /**
   * 获取当前屏幕尺寸。
   * @returns
   */
  async getWindowSize(): Promise<window.Size> {
    let currentWindow = await window.getLastWindow(this.context);
    const rect: window.Rect = currentWindow.getWindowProperties().windowRect;
    return {
      width: px2vp(rect.width),
      height: px2vp(rect.height)
    }
  }

  /**
   * 获取底部状态栏高度
   * @returns
   */
  async getBottomIndicatorHeight(): Promise<number> {
    let currentWindow = await window.getLastWindow(this.context);
    const avoidAreaType = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
    const avoidArea = currentWindow.getWindowAvoidArea(avoidAreaType);
    return px2vp(avoidArea.bottomRect.height);
  }

  /**
   * 获取顶部状态栏高度
   * @returns
   */
  async getTopAvoidHeight(): Promise<number> {
    let currentWindow = await window.getLastWindow(this.context);
    const avoidAreaType = window.AvoidAreaType.TYPE_SYSTEM; // 系统默认区域，包括状态栏，导航栏
    const avoidArea = currentWindow.getWindowAvoidArea(avoidAreaType);
    return px2vp(avoidArea.topRect.height);
  }


}

/**
 * 设置屏幕常量
 * @param context
 * @param isKeepScreenOn
 */
export async function keepScreenOn(context: Context, isKeepScreenOn: boolean) {
  let value: window.Window = await window.getLastWindow(context)
  value.setWindowKeepScreenOn(isKeepScreenOn);
}