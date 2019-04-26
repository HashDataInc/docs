# ALTER AGGREGATE

更改聚集函数的定义

## 概要

```
ALTER AGGREGATE name ( type [ , ... ] ) RENAME TO new_name
ALTER AGGREGATE name ( type [ , ... ] ) OWNER TO new_owner
ALTER AGGREGATE name ( type [ , ... ] ) SET SCHEMA new_schema
```

## 描述

ALTER AGGREGATE 更改聚集函数的定义。

用户必须拥有聚集函数才能去使用 ALTER AGGREGATE。 要更改聚合函数的模式，还必须对新模式具有CREATE 特权。要更改所有者，用户还必须是新任命的直接或间接成员，并且该角色必须对聚合函数的模式具有 CREATE 特权。(这些限制强制要求拥有者不能通过丢弃并重建该聚集函数来做任何不能做的事情。然而，超级用户可以改变任何聚合函数的所有权。)

## 参数

name

一个现有聚集函数的名称（可以是限定模式）

type

聚集函数能运行的输入数据类型。要引用零参数聚合函数，写入*代替输入数据类型的列表。

new_name

聚集函数的新名称。

new_owner

聚集函数新的所有者。

new_schema

聚集函数的新模式。

## 示例

要把 integer 类型的聚合函数 myavg 重命名为 my_average:

```
ALTER AGGREGATE myavg(integer) RENAME TO my_average;
```

更改 integer 类型的聚合函数 myavg 的所有者为 joe:

```
ALTER AGGREGATE myavg(integer) OWNER TO joe;
```

将 integer 类型的聚合函数 myavg 移动到模式 myschema 中:

```
ALTER AGGREGATE myavg(integer) SET SCHEMA myschema;
```

## 兼容性

在 SQL 标准中没有 ALTER AGGREGATE 语句。

## 另见

[CREATE AGGREGATE](./create-aggregate.md)，[DROP AGGREGATE](./drop-aggregate.md)

**上级主题：** [SQL命令参考](./README.md)

