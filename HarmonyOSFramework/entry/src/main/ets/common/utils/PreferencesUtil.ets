/**
 * Copyright (C), 2024-08-10
 * @author LinXun
 * @date 2024/8/10 19:23
 * @version 1.0
 * @description: 首选项操作类的封装
 */

import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';
import CommonConstants from '../constants/CommonConstants';
import Logger from './Logger';
import { JSON } from '@kit.ArkTS';

class PreferencesUtil {
  private pref: preferences.Preferences | null = null;
  /**
   * 加载首选项并初始化
   * @param context
   */
  async loadPreference(context: Context) {
    // 加载
    try {
      this.pref = await preferences.getPreferences(context, CommonConstants.PREF_STORE);
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `加载Preferences[${CommonConstants.PREF_STORE}]成功`);
    } catch (error) {
      Logger.error(`[${CommonConstants.PREF_PREFIX}]`, `加载Preferences[${CommonConstants.PREF_STORE}]失败：`, JSON.stringify(error));
    }
  }
  /**
   * 新增首选项
   * @param key
   * @param value
   */
  async putPreference(key: string, value: preferences.ValueType) {
    // 判断是否初始化
    if (!this.pref) {
      Logger.error(`[${CommonConstants.PREF_PREFIX}]`, `Preferences尚未初始化`);
      return;
    }
    try {
      await this.pref.put(key, value);
      // 刷盘
      await this.pref.flush();
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `写入Preferences[${key} = ${value}]成功`);
    } catch (error) {
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `写入Preferences[${key} = ${value}]失败：`, JSON.stringify(error));
    }
  }
  /**
   * 获取首选项
   * @param key
   * @param defaultValue
   * @returns
   */
  async getPreferenceValue(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType | null> {
    // 判断是否初始化
    if (!this.pref) {
      Logger.error(`[${CommonConstants.PREF_PREFIX}]`, `Preferences尚未初始化`);
      return null;
    }
    try {
      let value = await this.pref.get(key, defaultValue);
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `读取Preferences[${key} = ${value}]成功`);
      return value;
    } catch (error) {
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `读取Preferences[${key}]失败：`, JSON.stringify(error));
      return null;
    }
  }
  /**
   * 删除首选项
   * @param key
   */
  async deletePreference(key: string) {
    // 判断是否初始化
    if (!this.pref) {
      Logger.error(`[${CommonConstants.PREF_PREFIX}]`, `Preferences尚未初始化`);
      return;
    }
    try {
      await this.pref.delete(key);
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `删除Preferences[${key}}]成功`);
    } catch (error) {
      Logger.debug(`[${CommonConstants.PREF_PREFIX}]`, `删除Preferences[${key}}]失败：`, JSON.stringify(error));
    }
  }
}
// 导出
const preferencesUtil = new PreferencesUtil();
export default preferencesUtil as PreferencesUtil;