/**
 * Copyright (C), 2024-09-21
 * @author LinXun
 * @date 2024/9/21 10:49
 * @version 1.0
 * @description: 断点类型
 */
import { BreakpointConstants } from '../constants/BreakpointConstants';

export class BreakpointType<T> {
  sm: T;
  md: T;
  lg: T;

  constructor(sm: T, md: T, lg: T) {
    this.sm = sm;
    this.md = md;
    this.lg = lg;
  }

  /**
   * 获取当前屏幕类型下的对应取值
   * @param currentBreakpoint
   * @returns
   */
  getValue(currentBreakpoint: string): T {
    if (currentBreakpoint === BreakpointConstants.BREAKPOINT_MD) {
      return this.md;
    } else if (currentBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
      return this.lg;
    } else {
      return this.sm;
    }
  }
}