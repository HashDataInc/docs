# DROP OPERATOR FAMILY

# 删除操作符族（family）

删除一个操作符族。

## 概要

```
DROP OPERATOR FAMILY [IF EXISTS] name USING index_method [CASCADE | RESTRICT]
```

## 描述

DROP OPERATOR FAMILY 删除了一个操作符族。要执行该命令，用户必须是该该操作符族的拥有者。

DROP OPERATOR FAMILY 包含删除在该操作符族中的任何操作符，但是它不会删除该系列引用的任何操作符或函数。如果有索引依赖于系列中 的操作符类，用户将需要指定 CASCADE 来完整的删除。

## 参数

IF EXISTS

如果一个操作符不存在，不会抛出错误。这种情况下会发出通知。

name

存在的操作符族的名字（可选方案限定）。

index\_method

操作符族的索引访问方法的名字

CASCADE

自动删除依赖该操作符族的对象。

RESTRICT

如果有任何对象依赖于操作符族，则拒绝删除该操作符族。这是默认的。

## 例子

删除 B-tree 的操作符族 float\_ops:

```
DROP OPERATOR FAMILY float_ops USING btree;
```

如果有任何存在索引使用该操作符族，则该命令失败。添加 CASCADE 来删除操作符族和索引。

## 兼容性

SQL 标准中没有 DROP OPERATOR FAMILY 。

## 另见

[CREATE OPERATOR FAMILY](./create-operator-family.md), [ALTER OPERATOR CLASS](./alter-operator-class.md), [CREATE OPERATOR CLASS](./create-operator-class.md), [DROP OPERATOR CLASS](./drop-operator-class.md)

**上级话题：** [SQL命令参考](./README.md)

