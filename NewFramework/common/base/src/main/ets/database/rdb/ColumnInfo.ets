/**
 * Copyright (C), 2024-10-03
 * @author LinXun
 * @date 2024/10/3 11:21
 * @version 1.0
 * @description: 数据库列接口
 */

export interface ColumnInfo {
  name: string;
  columnName: string;
  type: ColumnType;
}

// 数据类型
export enum ColumnType {
  LONG,
  DOUBLE,
  STRING,
  BLOB
}