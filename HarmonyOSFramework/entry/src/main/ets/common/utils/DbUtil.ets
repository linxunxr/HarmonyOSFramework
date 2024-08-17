/**
 * Copyright (C), 2024-08-17
 * @author LinXun
 * @date 2024/8/17 9:37
 * @version 1.0
 * @description: 数据库操作类封装
 */
import { relationalStore, ValuesBucket, ValueType } from '@kit.ArkData'
import { common } from '@kit.AbilityKit';
import CommonConstants from '../constants/CommonConstants';
import Logger from './Logger';
import { ColumnInfo, ColumnType } from '../database/rdb/ColumnInfo';
import map from '@hms.core.map.map';

class DbUtil {
  // 数据库实例
  rdbStore: relationalStore.RdbStore | undefined = undefined;
  /**
   * 初始化数据库
   * @param context
   * @returns
   */
  initDB(context: common.UIAbilityContext): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG)
        .then(rdbStore => {
          this.rdbStore = rdbStore;
          Logger.debug(`${CommonConstants.RDB_PREFIX}`, 'rdbStore初始化成功');
          resolve();
        })
        .catch((reason: string) => {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, 'rdbStore初始化失败:', JSON.stringify(reason));
          reject(reason);
        })
    })
  }
  /**
   * 删除数据库
   * @param context
   * @returns
   */
  deleteDB(context: common.UIAbilityContext): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      if (this.rdbStore === undefined) {
        resolve();
      }
      relationalStore.deleteRdbStore(context, CommonConstants.STORE_CONFIG, (error) => {
        if (error) {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, 'rdbStore删除失败:', JSON.stringify(error));
          reject(error);
        }
        this.rdbStore = undefined;
        resolve();
      })
    })
  }
  /**
   * 创建表
   * @param createSQL
   * @returns
   */
  createTable(createSQL: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.rdbStore?.executeSql(createSQL)
        .then(() => {
          Logger.debug(`${CommonConstants.RDB_PREFIX}`, `创建表成功`);
          reject();
        })
        .catch((reason: string) => {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '创建表失败:', JSON.stringify(reason));
          reject(reason);
        })
    })
  }
  /**
   * 插入数据
   * @param tableName
   * @param obj
   * @param columns
   * @returns
   */
  insert(tableName: string, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1. 构建新增数据值集
      let value = this.buildValueBucket(obj, columns);
      // 2. 新增
      this.rdbStore?.insert(tableName, value, (error, id) => {
        if (error) {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '新增失败:', JSON.stringify(error));
          reject(error);
        } else {
          Logger.debug(`${CommonConstants.RDB_PREFIX}`, '新增成功！新增id:', id.toString());
          resolve(id);
        }
      })
    })
  }
  /**
   * 删除数据
   * @param predicates
   * @returns
   */
  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.delete(predicates, (error, rows) => {
        if (error) {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '删除失败:', JSON.stringify(error));
          reject(error);
        } else {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '删除成功,删除行数:', rows.toString());
          resolve(rows);
        }
      })
    })
  }
  /**
   * 更新数据
   * @param predicates
   * @param obj
   * @param columns
   * @returns
   */
  update(predicates: relationalStore.RdbPredicates, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      let value = this.buildValueBucket(obj, columns);
      this.rdbStore?.update(value, predicates, (error, rows) => {
        if (error) {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '更新失败:', JSON.stringify(error));
          reject(error);
        } else {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '更新成功,更新行数:', rows.toString());
          resolve(rows);
        }
      })
    })
  }
  /**
   * 查询数据
   * @param predicates
   * @param columns
   * @returns
   */
  queryForList<T>(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (error, result) => {
        if (error) {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '查询失败:', JSON.stringify(error));
          reject(error);
        } else  {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '查询成功,查询行数:', result.rowCount.toString());
          resolve(this.paresResultSet(result, columns));
          result.close();
        }
      })
    })
  }
  /**
   * 查询表中数据条数
   * @param predicates
   * @param columns
   * @returns
   */
  queryForCount(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (error, result) => {
        if (error) {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '查询失败:', JSON.stringify(error));
          reject(error);
        } else  {
          Logger.error(`${CommonConstants.RDB_PREFIX}`, '查询成功,查询行数:', result.rowCount.toString());
          resolve(result.rowCount);
        }
      })
    })
  }
  /**
   * 解析结果集
   * @param result
   * @param columns
   * @returns
   */
  paresResultSet<T>(result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    // 1. 声明最终返回的结果
    let arr: T[] = [];
    // 2. 判断是否存在结果
    if (result.rowCount <= 0) {
      Logger.debug(`${CommonConstants.RDB_PREFIX}`,'解析结果集无结果');
      return arr;
    }
    // 3. 处理结果
    while (!result.isAtLastRow) {
      result.goToNextRow();
      let obj: ValuesBucket = {};
      columns.forEach(info => {
        let val: ValueType | Uint8Array | null = null;
        switch (info.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName));
            break;
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(info.columnName));
            break;
        }
        obj[info.name] = val;
      })
      arr.push(obj as T);
    }
    return arr;
}
  /**
   * 构建值集
   * @param obj
   * @param columns
   * @returns
   */
  buildValueBucket(obj: object, columns: ColumnInfo[]): ValuesBucket {
    let value: ValuesBucket = {};
    columns.forEach(info => {
      value[info.columnName] = obj[info.name];
    });
    return value;
  }
}
let dbUtil: DbUtil = new DbUtil();
export default dbUtil as DbUtil;