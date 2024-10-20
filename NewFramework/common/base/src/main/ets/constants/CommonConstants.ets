/**
 * Copyright (C), 2024-09-21
 * @author LinXun
 * @date 2024/9/21 10:36
 * @version 1.0
 * @description: 通用常量
 */
import { relationalStore } from '@kit.ArkData';

export class CommonConstants {
  /**
   * 日志TAG
   */
  // APP 日志TAG
  static readonly LOGGER_PREFIX: string = "[NewFramework]";
  // 用户首选项TAG
  static readonly PREF_PREFIX: string = "[PrefTag]";
  // 数据库操作日志TAG
  static readonly RDB_PREFIX: string = "[RdbTag]";
  // 键值数据库操作日志TAG
  static readonly KV_PREFIX: string = "[KvTag]";
  /**
   * 包名
   */
  static readonly BUNDLE_NAME: string = "com.sparks_fire.framework.framework.new";
  /**
   * 用户首选项 名
   */
  static readonly PREF_STORE: string = "PrefStore";
  /**
   * 安全区避让高度
   */
  static readonly AVOID_RECT_HEIGHT_TOP: string = "topRectHeight";
  static readonly AVOID_RECT_HEIGHT_BOTTOM: string = "bottomRectHeight";
  /**
   * 界面 abilityUtil 列表
   */
  static readonly WINDOW_UTIL_LIST: string[] = ["windowUtil"];
  /**
   * 用户首选项 Util
   */
  static readonly PREFERENCE_UTIL: string = "prefUtil";
  /**
   * 键值数据库 Util
   */
  static readonly KV_UTIL: string = "kvUtil";
  /**
   * 数据库 Util
   */
  static readonly DB_UTIL: string = "dbUtil";
  /**
   * 页面
   */
  static readonly PAGE_INFOS: string = "pagesInfos";
  /**
   * 屏幕DPI
   */
  static readonly SCREEN_DPI_CONSTANT: number = 160;
  /**
   * 设备类型
   */
  static readonly DEVICE_TYPES: string[] = ["2in1", "tablet"];
  /**
   * 百分百
   */
  static readonly FULL_WIN: string = "100%";
  /**
   * bar 宽度
   */
  static readonly BAR_WIDTH_LG: string = "96vp";
  /**
   * bar 高度
   */
  static readonly BAR_HEIGHT_LIST: number[] = [56, 80];
  /**
   * 数据库配置
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: "framework.db",
    securityLevel: relationalStore.SecurityLevel.S1
  }
}