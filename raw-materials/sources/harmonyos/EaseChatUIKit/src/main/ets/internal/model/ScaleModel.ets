/*
  图片缩放模型
 */
@Observed
export class ScaleModel {
  /**
   * 本次缩放因子，用于控制图片的大小显示
   */
  scaleValue: number;
  /**
   * 记录上次缩放完后的缩放因子
   */
  lastValue: number;
  maxScaleValue: number;
  extraScaleValue: number;
  /**
   * 默认缩放值，1
   */
  readonly defaultScaleValue: number = 1;

  constructor(scaleValue: number = 1.0, lastValue: number = 1.0,
    maxScaleValue: number = 1.5, extraScaleValue: number = 0.2) {
    this.scaleValue = scaleValue;
    this.lastValue = lastValue;
    this.maxScaleValue = maxScaleValue;
    this.extraScaleValue = extraScaleValue;
  }

  reset(): void {
    this.scaleValue = this.defaultScaleValue;
    this.lastValue = this.scaleValue;
  }

  stash(): void {
    this.lastValue = this.scaleValue;
  }

  toString(): string {
    return `[scaleValue: ${this.scaleValue} lastValue: ${this.lastValue}]`;
  }
}