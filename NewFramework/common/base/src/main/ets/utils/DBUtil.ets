/**
 * Copyright (C), 2024-10-03
 * @author LinXun
 * @date 2024/10/3 11:22
 * @version 1.0
 * @description: 数据库操作类封装
 */
import { relationalStore, ValuesBucket, ValueType } from '@kit.ArkData'
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';
import { ColumnInfo, ColumnType } from '../database/rdb/ColumnInfo';

export class DBUtil {
  rdbStore?: relationalStore.RdbStore;
  static getInstance(): DBUtil | undefined {
    if (!AppStorage.get<DBUtil>(CommonConstants.DB_UTIL)) {
      AppStorage.setOrCreate(CommonConstants.DB_UTIL, new DBUtil());
    }
    return AppStorage.get<DBUtil>(CommonConstants.DB_UTIL);
  }
  initDB(context: Context): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG)
        .then(rdbStore => {
          this.rdbStore = rdbStore;
          Logger.debug(CommonConstants.RDB_PREFIX, `rdbStore初始化成功`);
          resolve();
        })
        .catch((error: BusinessError) => {
          Logger.error(CommonConstants.RDB_PREFIX, `rdbStore初始化失败！code:${error.code},message:${error.message}`);
          reject(error);
        })
    });
  }
  deleteDB(context: Context): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      if (this.rdbStore === undefined) {
        resolve();
      }
      relationalStore.deleteRdbStore(context, CommonConstants.STORE_CONFIG)
        .then(() => {
          this.rdbStore = undefined;
          resolve();
        })
        .catch((error: BusinessError) => {
          Logger.error(CommonConstants.RDB_PREFIX, `rdbStore 删除失败!code:${error.code},message:${error.message}`);
          reject(error);
        })
    })
  }
  createTable(createSQL: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.rdbStore?.executeSql(createSQL)
        .then(() => {
          Logger.debug(CommonConstants.RDB_PREFIX, `创建表成功！`);
          resolve();
        })
        .catch((error: BusinessError) => {
          Logger.error(CommonConstants.RDB_PREFIX, `创建表失败！code:${error.code}, message:${error.message}`);
          reject(error);
        })
    })
  }
  insert(tableName: string, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建新增数据
      let value = this.buildValueBucket(obj, columns);
      // 2.新增
      this.rdbStore?.insert(tableName, value, (err, id) => {
        if (err) {
          Logger.error(CommonConstants.RDB_PREFIX,'新增失败！', JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(CommonConstants.RDB_PREFIX,'新增成功！新增id：', id.toString());
          resolve(id);
        }
      })
    });
  }
  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.delete(predicates, (err, rows) => {
        if (err) {
          Logger.error(CommonConstants.RDB_PREFIX,'删除失败!,', JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(CommonConstants.RDB_PREFIX,'删除成功！删除行数：', rows.toString());
          resolve(rows);
        }
      })
    });
  }
  queryForList<T> (predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          Logger.error(CommonConstants.RDB_PREFIX,'查询失败!',JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(CommonConstants.RDB_PREFIX,'查询成功！查询行数：', result.rowCount.toString());
          resolve(this.parseResultSet(result, columns));
          result.close();
        }
      })
    });
  }
  queryForCount (predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore?.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          Logger.error(CommonConstants.RDB_PREFIX,'查询失败!',JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(CommonConstants.RDB_PREFIX,'查询成功！查询行数：', result.rowCount.toString());
          resolve(result.rowCount);
        }
      })
    });
  }
  update(predicates: relationalStore.RdbPredicates, obj: object, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建更新数据
      let value = this.buildValueBucket(obj, columns);
      // 2.更新
      this.rdbStore?.update(value, predicates, (err, result) => {
        if (err) {
          Logger.error(CommonConstants.RDB_PREFIX, '更新失败！', JSON.stringify(err));
          reject(err);
        } else {
          Logger.debug(CommonConstants.RDB_PREFIX, '更新成功！更新行数：', result.toString());
          resolve(result);
        }
      })
    });
  }
  parseResultSet<T> (result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    // 1.声明最终返回的结果
    let arr: T[] = [];
    // 2.判断是否有结果
    if (result.rowCount <= 0) {
      Logger.debug('无结果');
      return arr;
    }
    // 3.处理结果
    while (!result.isAtLastRow) {
      // 3.1 去下一行
      result.goToNextRow();
      // 3.2 解析这行数据，转为对象
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
      // 3.3 将对象填入结果数组
      arr.push(obj as T);
    }
    return arr;
  }
  buildValueBucket(obj: object, columns: ColumnInfo[]): ValuesBucket {
    let value: ValuesBucket = {};
    columns.forEach(info => {
      if (typeof obj[info.name] !== 'undefined') {
        value[info.columnName] = obj[info.name];
      }
    });
    return value;
  }
}