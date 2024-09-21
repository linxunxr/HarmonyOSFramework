/**
 * Copyright (C), 2024-09-21
 * @author LinXun
 * @date 2024/9/21 11:01
 * @version 1.0
 * @description: 屏幕封装
 */
import { display, window } from '@kit.ArkUI'
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointConstants } from '../constants/BreakpointConstants';

export class WindowUtil {
  private windowStage?: window.WindowStage;
  private mainWindowClass?: window.Window;

  static getInstance(): WindowUtil | undefined {
    if (!AppStorage.get<WindowUtil>(CommonConstants.WINDOW_UTIL_LIST[0])) {
      AppStorage.setOrCreate(CommonConstants.WINDOW_UTIL_LIST[0], new WindowUtil());
    }
    return AppStorage.get<WindowUtil>(CommonConstants.WINDOW_UTIL_LIST[0]);
  }

  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
  }

  async setMainWindow(): Promise<void> {
    if (this.windowStage === undefined) {
      Logger.error(`WindowStage 未定义`);
      return;
    }
    await this.windowStage?.getMainWindow().then((windowClass: window.Window) => {
      this.mainWindowClass = windowClass;
    }).catch((error: BusinessError) => {
      Logger.error(`获取 MainWindow 失败. code:${error.code}, message:${error.message}`);
      return;
    });
  }
  
  getMainWindow(): window.Window | undefined {
    return this.mainWindowClass;
  }
  
  /**
   * 全屏沉浸式
   */
  setFullScreen(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`WindowStage 未定义`);
      return;
    }
    this.mainWindowClass?.setWindowLayoutFullScreen(true)
      .then(() => {
        Logger.info(`设置全屏沉浸式成功.`)
      })
      .catch((error: BusinessError) => {
        Logger.error(`设置全屏沉浸式失败. code:${error.code}, message:${error.message}`);
        return;
      });
  }
  
  /**
   * 获取安全避让区高度 并设置为全局变量
   */
  setAvoidRectHeight(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`WindowStage 未定义`);
      return;
    }
    let topHeight: number = this.mainWindowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height;
    let bottomHeight: number = this.mainWindowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).bottomRect.height;
    AppStorage.setOrCreate(CommonConstants.AVOID_RECT_HEIGHT_TOP, px2vp(topHeight));
    AppStorage.setOrCreate(CommonConstants.AVOID_RECT_HEIGHT_BOTTOM, px2vp(bottomHeight));
  }
  
  updateBreakpoint(windowWith: number): void {
    let windowWidthVp = windowWith / display.getDefaultDisplaySync().densityPixels;
    let curBp: string = "";
    if (windowWidthVp < BreakpointConstants.BREAKPOINT_RANGES[1]) {
      curBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidthVp < BreakpointConstants.BREAKPOINT_RANGES[2]) {
      curBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      curBp = BreakpointConstants.BREAKPOINT_LG;
    }
    Logger.info(`更新断点成功${curBp}`);
    AppStorage.setOrCreate(BreakpointConstants.CURRENT_BREAKPOINT, curBp);
  }

  updateWindowStatusType(windowStatusType: window.WindowStatusType): void {
    let isSplitMode: boolean = false;
    if (windowStatusType === window.WindowStatusType.SPLIT_SCREEN) {
      isSplitMode = true;
    }
    AppStorage.setOrCreate(BreakpointConstants.IS_SPLIT_MODE, isSplitMode);
  }
}