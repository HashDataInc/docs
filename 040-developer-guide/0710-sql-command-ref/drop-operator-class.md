# DROP OPERATOR CLASS

# 删除操作符类

删除操作符类

## 概要

```
DROP OPERATOR CLASS [IF EXISTS] name USING index_method [CASCADE | RESTRICT]
```

## 描述

DROP OPERATOR 删除一个操作符类。要执行这个命令用户必须是操作符类的拥有者。

## 参数

IF EXISTS

如果操作符类不存在，不会抛出异常。这种情况下会发出通知。

name

存在的操作符类的名字（可选方案限定）。

index\_method

操作符类索引访问方法的名称。

CASCADE

自动删除依赖于该操作类的对象。

RESTRICT

如果有任何对象依赖于操作符类，则拒绝删除该操作符类。

## 示例

删除 B-tree 操作符类 widget\_ops：

```
DROP OPERATOR CLASS widget_ops USING btree;
```

如果有任何存在的索引使用操作符类，则命令会失败。添加 CASCADE 来删除这些索引和操作符类。

## 兼容性

SQL 标准中没有 DROP OPERATOR CLASS 语句。

## 另见

[ALTER OPERATOR CLASS](./alter-operator-class.md), [CREATE OPERATOR CLASS](./create-operator-class.md)

**上级话题：** [SQL命令参考](./README.md)

