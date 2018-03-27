# ALTER OPERATOR

更改操作符的定义。

## 概要

```
ALTER OPERATOR name ( {lefttype | NONE} , {righttype | NONE} ) OWNER TO newowner
```

## 描述

ALTER OPERATOR 更改一个操作符的定义。 目前唯一可用的功能是更改操作符的所有者。

用户必须拥有操作符才能使用 ALTER OPERATOR。 要更改所有者，用户还必须是新拥有角色的一个直接或间接的成员，并且该角色必须具有该操作符所在模式上的 CREATE 特权。\(（这种限制强制要求即使更改所有者也不能做那些通过删除或重建操作符所不能做到的事情。然而，超级用户可以任意修改操作符的所有权）

## 参数

_name_

现有操作符的名称（可选方案限定）

_lefttype_

操作符左操作数的数据类型；如果没有左操作数记为 NONE

_righttype_

操作符右操作数的数据类型；如果操作符没有右操作数记为 NONE

_newowner_

操作符新的所有者。

## 示例

更改 text 类型的一个自定义操作符 a @@ b 的所有者:

```
ALTER OPERATOR @@ (text, text) OWNER TO joe;
```

## 兼容性

在 SQL 标准中没有 ALTER OPERATOR 语句。

## 另见

[CREATE OPERATOR](./create-operator.md) ，[DROP OPERATOR](./drop-operator.md)

**上级主题：** [SQL命令参考](./README.md)

