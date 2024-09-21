/**
 * Copyright (C), 2024-09-21
 * @author LinXun
 * @date 2024/9/21 10:46
 * @version 1.0
 * @description: 断点常量
 */

export class BreakpointConstants {
  /**
   * sm 常量
   */
  static readonly BREAKPOINT_SM: string = "sm";
  /**
   * md 常量
   */
  static readonly BREAKPOINT_MD: string = "md";
  /**
   * lg 常量
   */
  static readonly BREAKPOINT_LG: string = "lg";
  /**
   * 当前屏幕类型常量
   */
  static readonly CURRENT_BREAKPOINT: string = "currentBreakpoint";
  /**
   * 判断是否折叠
   */
  static readonly IS_SPLIT_MODE: string = "isSplitMode";
  /**
   * 屏幕宽度常量
   */
  static readonly WINDOW_WIDTH: string = "windowWidth";
  /**
   * 屏幕大小范围
   */
  static readonly BREAKPOINT_RANGES: number[] = [320, 600, 840];
}