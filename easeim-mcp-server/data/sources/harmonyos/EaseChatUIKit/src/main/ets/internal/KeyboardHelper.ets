import { WindowManager } from '../utils/Window';

export class KeyboardHelper {
  private static instance: KeyboardHelper|undefined;
  private windowHeight: number = 0;
  private softwareHeight: number = 0;
  private viewBottomToBottom: number = 0;
  private constructor() {
    WindowManager.getInstance(getContext()).getWindowSize().then(result => {
      this.windowHeight = result.height;
    })
  }

  static getInstance(): KeyboardHelper {
    if (!KeyboardHelper.instance) {
      KeyboardHelper.instance = new KeyboardHelper();
    }
    return KeyboardHelper.instance
  }

  setKeyboardChange(softwareHeight: number) {
    this.softwareHeight = softwareHeight;
  }

  setViewHeightChange(viewArea: Area) {
    if (viewArea.globalPosition.y) {
      this.viewBottomToBottom = this.windowHeight - (viewArea.globalPosition.y as number) - (viewArea.height as number)
    } else {
      this.viewBottomToBottom = 0;
    }
  }

  reset() {
    this.viewBottomToBottom = 0;
    this.softwareHeight = 0;
  }

  /**
   * 获取差值
   * @returns
   */
  getDifference(): number {
    if (this.viewBottomToBottom >= this.softwareHeight) {
      return 0;
    }
    return this.softwareHeight - this.viewBottomToBottom;
  }

}