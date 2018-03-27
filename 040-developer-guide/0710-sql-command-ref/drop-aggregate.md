# DROP AGGREGATE

# 删除聚集函数

删除一个聚集函数

## 概要

```
DROP AGGREGATE [IF EXISTS] name ( type [, ...] ) [CASCADE | RESTRICT]
```

## 描述

DROP AGGREGATE 会删除一个存在的聚集函数。要执行该命令，当前用户必须是该聚集函数的拥有者。

## 参数

IF EXISTS

如果该聚集函数不存在不会抛出异常。在异常情况下会发出通知。

name

存在的聚集函数的名称（可选方案限定）。

type

聚集函数操作的输入数据类型。要引用一个 0 个参数的聚集函数，写 \* 替代输入数据类型列表。

CASCADE

自动删除依赖该聚集函数的对象。

RESTRICT

如果有任何对象依赖于它，则拒绝删除聚集函数。这是默认的。

## 示例

删除参数为 integer 的聚集函数 myavg：

```
DROP AGGREGATE myavg(integer);
```

## 兼容性

SQL 标准中没有 DROP AGGREGATE 语句。

## 另见

[ALTER AGGREGATE](./alter-aggregate.md), [CREATE AGGREGATE](./create-aggregate.md)

**上级话题：** [SQL命令参考](./README.md)

