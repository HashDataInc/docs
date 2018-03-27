# ALTER TYPE

更改一个数据类型的定义。

## 概要

```
ALTER TYPE name
   OWNER TO new_owner | SET SCHEMA new_schema
```

## 描述

ALTER TYPE 更改一种现有类型的定义。用户可以更改类型的模式和所有者。

用户必须拥有此类型才能使用 ALTER TYPE. 要更改类型的模式，用户还必须对新模式具有 CREATE 特权。 要更改类型拥有者用户必须是新角色的直接或间接成员，并且该角色在类型的模式上有 CREATE 特权\(这些限制强制修改拥有者不能做一些通过删除和重建类型做不到的事情。不过，一个超级用户怎么都能更改任何类型的所有权\)。

## 参数

_name_

要修改的一个现有类型的名称（可选限定模式）。

_new\_owner_

该类型新的拥有者的类型名。

_new\_schema_

该类型的新模式。

## 示例

更改用户自定义的 email 拥有者为 joe:

```
ALTER TYPE email OWNER TO joe;
```

更改用户自定义的 email 类型模式为 customers:

```
ALTER TYPE email SET SCHEMA customers;
```

## 兼容性

在 SQL 标准中没有 ALTER TYPE 语句。

## 另见

[CREATE TYPE](./create-type.md)， [DROP TYPE](./drop-type.md)

**上级主题：** [SQL命令参考](./README.md)

