# CREATE OPERATOR FAMILY

# 创建操作符族

定义一个新的操作符族

## 概要

```
CREATE OPERATOR FAMILY name  USING index_method
```

## 描述

CREATE OPERATOR FAMILY 创建一个新的操作符族。操作符族定义了相关操作符类的集合，以及一些额外的操作符和支持函数，这些函数和这些操作符类兼容，但是对于任何单个索引的运行来说不是必需的。（对索引必不可少的操作符和函数应归入相应的操作符类而不是在操作符族中“松动”，通常，单数据类型操作符绑定到操作符类，然而跨数据类型操作符可能在包含该两种数据类型的系列中“松动”。）

新的操作符族最初是空的，应该通过发出后续的 CREATE OPERATOR CLASS 命令来增加包含的操作符类，以及可选的 ALTER OPERATOR FAMILY命令来添加 "松动" 的操作符和相应的支持函数。

如果给定了模式名称，则在指定的模式中创建操作符族。否则会在当前模式中创建操作符族。 同一个模式中的两个操作符族，只有在当他们所指定的索引方法不同时，才能重名。

定义操作符族的人成为其所有者。目前，创建用户必须是超级用户（该限制的制定是因为错误的操作符族会混淆服务器甚至致使其崩溃。）

## 参数

name

要定义的操作符族的（可选操作符限定）名字，该名字是方案限定的。

index\_method

该操作符族的索引方法的名称。

## 兼容性

CREATE OPERATOR FAMILY 是 HashData 数据库的扩展，SQL标准中没有 CREATE OPERATOR FAMILY 语句。

## 另见

 [DROP OPERATOR FAMILY](./drop-operator-family.md), [CREATE FUNCTION](./create-function.md), [ALTER OPERATOR CLASS](./alter-operator-class.md), [CREATE OPERATOR CLASS](./create-operator-class.md), [DROP OPERATOR CLASS](./drop-operator-class.md)

**上级话题：** [SQL命令参考](./README.md)

