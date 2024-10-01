/**
 * Copyright (C), 2024-10-01
 * @author LinXun
 * @date 2024/10/1 14:32
 * @version 1.0
 * @description: 用户首选项
 */
import { preferences } from '@kit.ArkData'
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';

export class PreferenceUtil {
  private pref?: preferences.Preferences;
  static getInstance(): PreferenceUtil | undefined {
    if (!AppStorage.get<PreferenceUtil>(CommonConstants.PREFERENCE_UTIL)) {
      AppStorage.setOrCreate(CommonConstants.PREFERENCE_UTIL, new PreferenceUtil());
    }
    return AppStorage.get<PreferenceUtil>(CommonConstants.PREFERENCE_UTIL);
  }
  /**
   * 加载首选项 并初始化
   * @param context
   */
  async loadPreference(context: Context) {
    try {
      this.pref = await preferences.getPreferences(context, CommonConstants.PREF_STORE);
      Logger.debug(CommonConstants.PREF_PREFIX, `加载Preference${CommonConstants.PREF_STORE}成功`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(CommonConstants.PREF_PREFIX, `加载Preference失败！code:${error.code},message:${error.message}`);
    }
  }
  /**
   * 新增首选项/修改
   * @param key
   * @param value
   */
  async putPreference(key: string, value: preferences.ValueType) {
    if (!this.pref) {
      Logger.error(CommonConstants.PREF_PREFIX, `Preference尚未初始化！`);
      return;
    }
    try {
      await this.pref.put(key, value);
      await this.pref.flush();
      Logger.debug(CommonConstants.PREF_PREFIX, `写入首选项成功！[${key} = ${value}]`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(CommonConstants.PREF_PREFIX, `写入首选项失败！code:${error.code},message:${error.message}`);
    }
  }
  /**
   * 获取首选项
   * @param key
   * @returns
   */
  async getPreferenceValue(key: string): Promise<preferences.ValueType | null> {
    if (!this.pref) {
      Logger.error(CommonConstants.PREF_PREFIX, `Preference尚未初始化！`);
      return null;
    }
    try {
      let value = await this.pref.get(key, "");
      if (value == "") {
        Logger.error(CommonConstants.PREF_PREFIX, `未查询到key`);
        return null;
      }
      return value;
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(CommonConstants.PREF_PREFIX, `查询首选项失败！key:${key},code:${error.code},message:${error.message}`);
      return null;
    }
  }
}