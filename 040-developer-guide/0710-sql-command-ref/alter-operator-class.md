# ALTER OPERATOR CLASS

更改一个操作符类的定义。

## 概要

```
ALTER OPERATOR CLASS name USING index_method RENAME TO newname

ALTER OPERATOR CLASS name USING index_method OWNER TO newowner
```

## 描述

ALTER OPERATOR CLASS 更改操作符类的定义。

用户必须拥有操作符类才能够使用 ALTER OPERATOR CLASS。要改变所有者，用户必须是新拥有角色的直接或间接成员，并且新角色在操作符类模式上必须有 CREATE 特权。（这些限制强制要求修改所有者不能做那些通过删除或重建操作符类都不能做到的事情。然而，超级用户可以随意修改操作符类的所有者）。

## 参数

_name_

一个存在的操作符的类的名称。

_index\_method_

操作符类索引方法的名称。

_newname_

操作符类的新名称。

_newowner_

操作符类的新的拥有者。

## 兼容性

在 SQL 标准中没有 ALTER OPERATOR CLASS 语句。

## 另见

[CREATE OPERATOR CLASS](./create-operator-class.md) ，[DROP OPERATOR CLASS](./drop-operator-class.md)

**上级主题：** [SQL命令参考](./README.md)

