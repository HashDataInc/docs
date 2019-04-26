# ALTER TABLESPACE

更改一个表空间的定义。

## 概要

```
ALTER TABLESPACE name RENAME TO newname

ALTER TABLESPACE name OWNER TO newowner
```

## 描述

ALTER TABLESPACE 可用于更改一个表空间的定义。

要使用 ALTER TABLESPACE，用户必须拥有该表空间。要修改拥有者，用户还必须是新拥有角色的直接或者间接成员（注意超级用户自动拥有这些特权）。

## 参数

_name_

一个现有表空间的名称。

_newname_

新的表空间的名称。新的表空间名称不能以 pg\_ 或 gp\_ 开头。\(这类名称保留用于系统表空间\).

_newowner_

该表空间的新拥有者。

## 示例

重命名表空间 index\_space 为 fast\_raid:

```
ALTER TABLESPACE index_space RENAME TO fast_raid;
```

更改表空间 index\_space的所有者:

```
ALTER TABLESPACE index_space OWNER TO mary;
```

## 兼容性

在 SQL 标准中没有 ALTER TABLESPACE 语句。

## 另见

[CREATE TABLESPACE](./create-tablespace.md)，[DROP TABLESPACE](./drop-tablespace.md)

**上级主题：** [SQL命令参考](./README.md)

