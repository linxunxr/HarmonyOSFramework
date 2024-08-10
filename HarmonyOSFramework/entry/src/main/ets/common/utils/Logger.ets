/**
 * Copyright (C), 2024-08-10
 * @author LinXun
 * @date 2024/8/10 11:17
 * @version 1.0
 * @description: 日志封装类
 */
import CommonConstants from '../constants/CommonConstants';
import { hilog } from '@kit.PerformanceAnalysisKit';

class Logger {
  private domain: number;
  private prefix: string;
  private format: string = "%{public} %{public}";

  /**
   * 日志封装构造函数
   * @param prefix
   * @param domain
   */
  constructor(prefix: string = "", domain: number = 0xFF00) {
    this.prefix = prefix;
    this.domain = domain;
  }
  debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }
  info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }
  warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }
  error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }
  fatal(...args: string[]): void {
    hilog.fatal(this.domain, this.prefix, this.format, args);
  }
}

// 构造并导出
export default new Logger(CommonConstants.LOGGER_PREFIX, 0xFF02);