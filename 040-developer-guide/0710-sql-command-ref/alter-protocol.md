# ALTER PROTOCOL

更改一个协议的定义

## 概要

```
ALTER PROTOCOL name RENAME TO newname

ALTER PROTOCOL name OWNER TO newowner
```

## 描述

ALTER PROTOCOL 更改一个协议的定义。只有协议的名称或拥有者可被更改。

用户必须拥有一个协议才能去使用 ALTER PROTOCOL。要更改所有者，用户必须是新拥有角色的直接或间接的成员，并且该角色必须在转换的模式是上具有 CREATE 特权。

这些限制适当的确保修改所有者只能通过删除或重建协议。注意一个超级用户可以修改任何协议的所属关系。

## 参数

_name_

现有协议的名称（可选方案限定）。

_newname_

协议的新名称。

_newowner_

协议的新的所有者。

## 示例

重命名转换 GPDBauth 为 GPDB\_authentication:

```
ALTER PROTOCOL GPDBauth RENAME TO GPDB_authentication;
```

更改转换 GPDB\_authentication 的所有者为 joe:

```
ALTER PROTOCOL GPDB_authentication OWNER TO joe;
```

## 兼容性

在 SQL 标准中没有 ALTER PROTOCOL 语句

## 另见

[CREATE EXTERNAL TABLE](./create-external-table.md) ，[CREATE PROTOCOL](./create-protocol.md)

**上级主题：** [SQL命令参考](./README.md)

