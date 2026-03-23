import { common } from '@kit.AbilityKit';

/**
 * 获取 EventBus 的 event.
 * @param flag
 * @param ext
 * @returns
 */
export function getEventStr(flag: string, ext?: string) {
  return 'event_bus_' + flag + (ext ? '_'+ext : '');
}

/**
 * 需要在Chat SDK初始化完成调用
 */
export class EventBus {

  private bus: common.EventHub = getContext(this).eventHub;

  constructor(context?: Context) {
    this.bus = context?.eventHub ?? getContext(this).getApplicationContext().eventHub;
  }

  /**
   * 创建基于page上下文的EventBus对象。
   * @returns
   */
  static create() {
    return new EventBus(getContext());
  }

  /**
   * 创建基于应用上下文的EventBus对象。
   * @returns
   */
  static global() {
    return new EventBus(getContext().getApplicationContext());
  }

  /**
   * 订阅事件
   * @param event
   * @param callback
   */
  public on(event: string, callback: Function) {
    this.bus.on(event, callback)
  }

  /**
   * 取消订阅事件
   * @param event
   * @param callback
   */
  public off(event: string, callback?: Function) {
    this.bus.off(event, callback)
  }

  /**
   * 触发事件
   * @param event
   * @param params
   */
  public emit(event: string, ...params: Object[]) {
    this.bus.emit(event, params)
  }

}