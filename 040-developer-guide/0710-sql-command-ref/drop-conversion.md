# DROP CONVERSION

# 删除转换

删除一个转换

## 概要

```
DROP CONVERSION [IF EXISTS] name [CASCADE | RESTRICT]
```

## 描述

DROP CONVERSION 删除之前定义的一个转换。 为了能够删除一个转换，用户必须先拥有该转换。

## 参数

IF EXISTS

如果该转换不存在不会抛出异常，这种情况下会发出一个通知。

name

转换的名字，该转换名字可以是方案限定的

CASCADE

RESTRICT

这些关键词没有作用，因为他们是不依赖该转换。

## 例子

删除叫 myname 的转换：

```
DROP CONVERSION myname;
```

## 兼容性

SQL 标准中没有 DROP CONVERSION 的语句。

## 另见

[ALTER CONVERSION](./alter-conversion.md), [CREATE CONVERSION](./create-conversion.md)

**上级话题：** [SQL命令参考](./README.md)

