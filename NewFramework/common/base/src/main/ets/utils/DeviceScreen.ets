/**
 * Copyright (C), 2024-09-21
 * @author LinXun
 * @date 2024/9/21 10:57
 * @version 1.0
 * @description: 获取屏幕宽高
 */
import { display } from '@kit.ArkUI'
import { CommonConstants } from '../constants/CommonConstants';

export class DeviceScreen {
  /**
   * 获取屏幕宽度
   * @returns
   */
  public static getDeviceWidth(): number {
    let displayObject = display.getDefaultDisplaySync();
    let screenPixelWidth = displayObject.width;
    let screenDensityDPI = displayObject.densityDPI;
    return screenPixelWidth * (CommonConstants.SCREEN_DPI_CONSTANT / screenDensityDPI);
  }
  /**
   * 获取屏幕高度
   * @returns
   */
  public static getDeviceHeight(): number {
    let displayObject = display.getDefaultDisplaySync();
    let screenPixelHeight = displayObject.height;
    let screenDensityDPI = displayObject.densityDPI;
    return screenPixelHeight * (CommonConstants.SCREEN_DPI_CONSTANT / screenDensityDPI);
  }
}