# ALTER EXTERNAL TABLE

更改外部表的定义。

## 概要

```
ALTER EXTERNAL TABLE name RENAME [COLUMN] column TO new_column

ALTER EXTERNAL TABLE name RENAME TO new_name

ALTER EXTERNAL TABLE name SET SCHEMA new_schema

ALTER EXTERNAL TABLE name action [, ... ]
```

其中 action 是下列之一：

```
  ADD [COLUMN] new_column type
  DROP [COLUMN] column [RESTRICT|CASCADE]
  ALTER [COLUMN] column TYPE type [USING expression]
  OWNER TO new_owner
```

## 描述

ALTER EXTERNAL TABLE 更改一个现有外部表的定义。有几种子形式：

* **ADD COLUMN** —向外部表定义添加一个新列。
* **DROP COLUMN** — 从外部表定义中删除一列。请注意，如果用户删除可读的外部表列，它只会更改 HashData 数据库中的表定义。外部数据文件不会更改。如果需要删除任何表外部的依赖于此列的数据，比如一个指向此列的视图，则需要指定 CASCADE 关键字。
* **ALTER COLUMN TYPE** — 更改表的列的数据类型。 
* **OWNER** — 将外部表的所有者更改为指定的用户。
* **RENAME** — 更改外部表的名称或表中单个列的名称。对外部数据没有影响。
* **SET SCHEMA** —将外部表移动到另一个模式。

用户必须拥有外部表才能使用 ALTER EXTERNAL TABLE。 要更改外部表的模式，用户还必须对新模式具有 CREATE 权限。要更改所有者，用户还必须是新拥有角色的直接或间接成员，该角色必须对外部表的模式具有 CREATE 特权。超级用户自动拥有这些权限。

在此版本中， ALTER EXTERNAL TABLE 不能修改外部表类型（read, write, web），数据格式或外部数据的位置。 要修改此信息，用户必须删除并重新创建外部表定义。

## 参数

_name_

要修改的现有外部表定义的名称（可以是方案限定）。

_column_

新列或现有列的名称。

_new\_column_

现有列的新名称。

_new\_name_

外部表的新名称。

_type_

新列的数据类型或现有列的新数据类型。

_new\_owner_

外部表的新所有者的角色名称。

_new\_schema_

该表要被移动到其中的模式的名称。

## 示例

向外部表定义添加新列：

```
ALTER EXTERNAL TABLE ext_expenses ADD COLUMN manager text;
```

更改外部表的名称：

```
ALTER EXTERNAL TABLE ext_data RENAME TO ext_sales_data;
```

更改外部表的所有者：

```
ALTER EXTERNAL TABLE ext_data OWNER TO jojo;
```

更改外部表的模式：

```
ALTER EXTERNAL TABLE ext_leads SET SCHEMA marketing;
```

## 兼容性

ALTER EXTERNAL TABLE 是  HashData 数据库的一个扩展。在标准 SQL 或常规 PostgreSQL 中没有 ALTER EXTERNAL TABLE 语句。

## 另见

[CREATE EXTERNAL TABLE](./create-external-table.md)，[DROP EXTERNAL TABLE](./drop-external-table.md)

**上级主题：** [SQL命令参考](./README.md)

