# DROP TYPE

移除一个数据类型。

## 概要

```
DROP TYPE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
```

## 描述

DROP TYPE 移除一种用户定义的数据类型。只有一个类型的拥有者才能移除它。

## 参数

IF EXISTS

如果该类型不存在则不要抛出一个错误，而是发出一个提示。

name

要移除的数据类型的名称（可以是方案限定的）。

CASCADE

自动删除依赖于该类型的对象（例如表列、函数、操作符），然后删除所有 依赖于那些对象的对象。

RESTRICT

如果有任何对象依赖于该类型，则拒绝删除它。这是默认值。

## 示例

移除一个名为 box 的数据库类型：

```
DROP TYPE box;
```

## 兼容性

这个命令类似于 SQL 标准中的对应命令，但 IF EXISTS 选项是 HashData 数据库的一个扩展。 但是要注意 HashData 数据库中的 CREATE TYPE 命令和数据类型扩展机制都与 SQL 标准不同。

## 另见

[ALTER TYPE](./alter-type.md), [CREATE TYPE](./create-type.md)

**上级主题：** [SQL命令参考](./README.md)

