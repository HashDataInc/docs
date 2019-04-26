# DROP OPERATOR

删除一个操作符。

## 概要

```
DROP OPERATOR [IF EXISTS] name ( {lefttype | NONE} , 
    {righttype | NONE} ) [CASCADE | RESTRICT]
```
## 描述

DROP OPERATOR 从数据库系统中删除一个操作符。要执行这个命令用户必须是该操作符的拥有者。

## 参数

IF EXISTS

如果操作符不存在，不会抛出错误。这种情况下会发出通知。

name

存在操作符的名字（可选方案限定）。

lefttype

操作符左操作数的数据类型；如果没有左操作数写 NONE。

righttype

操作符右操作数的数据类型；如果没有右操作数写 NONE。

CASCADE

自动删除依赖于该操作符的对象。

RESTRICT

如果有任何对象依赖于该操作符，则拒绝删除该操作符。这是默认的。

## 示例

删除 integer 类型的 power 操作符 `a^b`：

```
DROP OPERATOR ^ (integer, integer);
```
删除左一元位补码 `~b`：

```
DROP OPERATOR ~ (none, bit);
```
删除右一元 bigint 的阶乘操作符 x!：

```
DROP OPERATOR ! (bigint, none);
```
## 兼容性

SQL 标准中没有 DROP OPERATOR 语句。

## 另见

[ALTER OPERATOR](./alter-operator.md), [CREATE OPERATOR](./create-operator.md)

**上级话题：** [SQL命令参考](./README.md)
