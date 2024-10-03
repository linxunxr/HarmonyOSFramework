/**
 * Copyright (C), 2024-10-02
 * @author LinXun
 * @date 2024/10/2 13:58
 * @version 1.0
 * @description: 键值数据库操作类封装
 */
import { distributedKVStore } from '@kit.ArkData';
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';

export class KvUtil {
  private kvManager?: distributedKVStore.KVManager;
  private kvDeviceStore?: distributedKVStore.DeviceKVStore;
  private kvSingleStore?: distributedKVStore.SingleKVStore;
  static getInstance(): KvUtil | undefined {
    if (!AppStorage.get<KvUtil>(CommonConstants.KV_UTIL)) {
      AppStorage.setOrCreate(CommonConstants.KV_UTIL, new KvUtil());
    }
    return AppStorage.get<KvUtil>(CommonConstants.KV_UTIL);
  }
  /**
   * 初始化
   * @param context
   * @returns
   */
  initKv(context: Context): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      const kvStoreConfig: distributedKVStore.KVManagerConfig = {
        context: context,
        bundleName: CommonConstants.BUNDLE_NAME
      };
      try {
        this.kvManager = distributedKVStore.createKVManager(kvStoreConfig);
        Logger.debug(CommonConstants.KV_PREFIX, `创建kvManager成功`);
        resolve();
      } catch (e) {
        let error = e as BusinessError;
        Logger.error(CommonConstants.KV_PREFIX, `创建kvManager失败！code:${error.code}, message:${error.message}`);
        reject(error);
      }
    })
  }
  /**
   * 创建数据库
   * @param name 数据库名
   * @param op 数据库配置
   * @returns
   */
  createKvDB(name: string, op: distributedKVStore.Options): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      if (!this.kvManager) {
        Logger.error(CommonConstants.KV_PREFIX, `kvManager不存在！`);
        reject();
      }
      if (op.kvStoreType === distributedKVStore.KVStoreType.SINGLE_VERSION) {
        this.kvManager?.getKVStore(name, op, (error: BusinessError, store: distributedKVStore.SingleKVStore) => {
          if (error) {
            Logger.error(CommonConstants.KV_PREFIX, `创建数据库失败！code:${error.code}, message:${error.message}`);
            reject(error);
          }
          this.kvSingleStore = store;
          Logger.debug(CommonConstants.KV_PREFIX, `创建数据库失败`);
          resolve();
        })
      } else  {
        this.kvManager?.getKVStore(name, op, (error: BusinessError, store: distributedKVStore.DeviceKVStore) => {
          if (error) {
            Logger.error(CommonConstants.KV_PREFIX, `创建数据库失败！code:${error.code}, message:${error.message}`);
            reject(error);
          }
          this.kvDeviceStore = store;
          Logger.debug(CommonConstants.KV_PREFIX, `创建数据库失败`);
          resolve();
        })
      }
    })
  }
  /**
   * 插入数据 & 更新数据
   * @param key
   * @param value
   * @param isSingle 是否是 非分布式
   * @returns
   */
  putData(key: string, value: distributedKVStore.ValueType, isSingle: boolean): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      if (!this.kvManager) {
        Logger.error(CommonConstants.KV_PREFIX, `kvManager不存在！`);
        reject();
      }
      if (isSingle) {
        this.kvSingleStore?.put(key, value)
          .then(() => {
            Logger.debug(CommonConstants.KV_PREFIX, `插入[${key}=${value}]成功`);
            resolve();
          })
          .catch((error: BusinessError) => {
            Logger.error(CommonConstants.KV_PREFIX, `插入[${key}=${value}]失败！code:${error.code}, message:${error.message}`);
            reject(error);
          })
      } else {
        this.kvDeviceStore?.put(key, value)
          .then(() => {
            Logger.debug(CommonConstants.KV_PREFIX, `插入[${key}=${value}]成功`);
            resolve();
          })
          .catch((error: BusinessError) => {
            Logger.error(CommonConstants.KV_PREFIX, `插入[${key}=${value}]失败！code:${error.code}, message:${error.message}`);
            reject(error);
          })
      }
    })
  }
  /**
   * 删除数据
   * @param key
   * @param isSingle
   * @returns
   */
  deleteData(key: string, isSingle: boolean): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      if (!this.kvManager) {
        Logger.error(CommonConstants.KV_PREFIX, `kvManager不存在！`);
        reject();
      }
      if (isSingle) {
        this.kvSingleStore?.delete(key)
          .then(() => {
            Logger.debug(CommonConstants.KV_PREFIX, `删除[${key}]成功`);
            resolve();
          })
          .catch((error: BusinessError) => {
            Logger.error(CommonConstants.KV_PREFIX, `删除[${key}]失败！code:${error.code}, message:${error.message}`);
            reject(error);
          })
      } else {
        this.kvDeviceStore?.delete(key)
          .then(() => {
            Logger.debug(CommonConstants.KV_PREFIX, `删除[${key}]成功`);
            resolve();
          })
          .catch((error: BusinessError) => {
            Logger.error(CommonConstants.KV_PREFIX, `删除[${key}]失败！code:${error.code}, message:${error.message}`);
            reject(error);
          })
      }
    })
  }
  getData<T>(key: string, isSingle: boolean): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      if (!this.kvManager) {
        Logger.error(CommonConstants.KV_PREFIX, `kvManager不存在！`);
        reject();
      }
      if (isSingle) {
        this.kvSingleStore?.get(key)
          .then((result) => {
            Logger.debug(CommonConstants.KV_PREFIX, `删除[${key}]成功`);
            resolve(result as T);
          })
          .catch((error: BusinessError) => {
            Logger.error(CommonConstants.KV_PREFIX, `删除[${key}]失败！code:${error.code}, message:${error.message}`);
            reject(error);
          })
      } else {
        this.kvDeviceStore?.get(key)
          .then((result) => {
            Logger.debug(CommonConstants.KV_PREFIX, `删除[${key}]成功`);
            resolve(result as T);
          })
          .catch((error: BusinessError) => {
            Logger.error(CommonConstants.KV_PREFIX, `删除[${key}]失败！code:${error.code}, message:${error.message}`);
            reject(error);
          })
      }
    })
  }
}