/**
 * Copyright (C), 2024-08-10
 * @author LinXun
 * @date 2024/8/10 11:14
 * @version 1.0
 * @description: 项目中的常量
 */
import { relationalStore } from '@kit.ArkData';

export default class CommonConstants {
  /**
   * 安全区常量名
   */
  static readonly AVOID_HEIGHT_TOP: string = "topAvoidHeight";
  static readonly AVOID_HEIGHT_BOTTOM: string = "bottomAvoidHeight";
  /**
   * 日志TAG
   */
  // APP日志TAG
  static readonly LOGGER_PREFIX: string = "Framework";
  // 用户首选项TAG
  static readonly PREF_PREFIX: string = "[PrefTag]";
  // 数据库操作日志TAG
  static readonly RDB_PREFIX: string = "[RdbTag]";
  /**
   * 用户首选项名字
   */
  static readonly PREF_STORE: string = "PrefStore";
  /**
   * 数据库配置
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: "Framework.db",
    securityLevel: relationalStore.SecurityLevel.S1
  };
}