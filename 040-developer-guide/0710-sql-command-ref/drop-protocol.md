# DROP PROTOCOL

从数据库中移除一个外部表数据访问协议。

## 概要

```
DROP PROTOCOL [IF EXISTS] name
```

## 描述

DROP PROTOCOL 从数据库中移除一个指定的协议。协议的名字可以通过命令 CREATE EXTERNAL TABLE  来指定，用来从外部数据源来读取数据或者将数据写到一个外部数据源中。

> 警告: 如果用户删除了一个数据访问协议，那么通过该访问协议定义的外部表将再也不能访问外部数据源。

## 参数

IF EXISTS

如果协议不存在，不会抛出一个错误。这种情况下会发出一个提示。

name

一个存在的数据访问协议的名字。

## 注解

如果用户删除一个数据访问协议，在数据库中定义的与该协议相关联的调用处理程序不会被删除。用户一定要手动地删除那些函数。

被协议用到的共享库也需要从 HashData 数据库的主机移除。

## 兼容性

DROP PROTOCOL 是一个 HashData 的扩展。

## 另见

[CREATE EXTERNAL TABLE](./create-external-table.md)、[CREATE PROTOCOL](./create-protocol.md)

**上层主题 上级主题：** [SQL命令参考](./README.md)

