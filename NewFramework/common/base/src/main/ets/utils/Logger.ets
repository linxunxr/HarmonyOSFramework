/**
 * Copyright (C), 2024-09-21
 * @author LinXun
 * @date 2024/9/21 10:52
 * @version 1.0
 * @description: 日志封装
 */
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CommonConstants } from '../constants/CommonConstants';

class Logger {
  private domain: number;
  private prefix: string;
  private format: string = "%{public}s, %{public}s";

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
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

export default new Logger(CommonConstants.LOGGER_PREFIX);