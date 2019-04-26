# ALTER DOMAIN

更改现有域的定义。

## 概要

```
ALTER DOMAIN name { SET DEFAULT expression | DROP DEFAULT }

ALTER DOMAIN name { SET | DROP } NOT NULL

ALTER DOMAIN name ADD domain_constraint

ALTER DOMAIN name DROP CONSTRAINT constraint_name \[RESTRICT | CASCADE\]

ALTER DOMAIN name OWNER TO new_owner

ALTER DOMAIN name SET SCHEMA new_schema
```

## 描述

ALTER DOMAIN 更改一个现有域的定义。 有几种形式：

* **SET/DROP DEFAULT** — 这些形式设置或删除域的默认值。请注意，默认值仅适用于后续的INSERT 命令。 它们不影响使用域的表中已经存在的行。
* **SET/DROP NOT NULL** — 这些形式会改变域是否被标记为允许 NULL 值或者拒绝 NULL 值。 用户只能 SET NOT NULL 当使用域的列不包含空值时。
* **ADD domain\_constraint** — 这种形式使用和 CREATE DOMAIN 相同的语法为域增加一个新的约束。如果所有使用域的列满足新的约束，则添加成功。
* **DROP CONSTRAINT** — 此形式删除域的约束。
* **OWNER** — 此形式将域的所有者更改为指定的用户。
* **SET SCHEMA** — 此形式更改域的模式。与域相关联的任何约束也被移动到新的模式中。

用户必须拥有域才能 ALTER DOMAIN. 要更改域的模式，用户还必须对新模式具有 CREATE 特权 要更改所有者，用户还必须是新拥有角色的直接或间接成员，并且该角色必须对该域的模式具有 CREATE 特权。 这些限制强制修改拥有者不能做一些通过删除和重建域做不到的事情。不过，一个超级用户怎么都能更改任何域的所有权。

## 参数

_name_

要更改的现有域的名称（可选方案限定）。

_domain\_constraint_

域的新域约束。

_constraint\_name_

要删除的现有约束的名称。

_CASCADE_

自动删除依赖约束的对象。

_RESTRICT_

如果有任何依赖对象，拒绝删除约束。这是默认行为。

_new\_owner_

域的新所有者的用户名

_new\_schema_

域的新模式。

## 示例

添加 NOT NULL 约束到一个域:

```
ALTER DOMAIN zipcode SET NOT NULL;
```

删除NOT NULL 约束从一个域中:

```
ALTER DOMAIN zipcode DROP NOT NULL;
```

向域添加检查约束：

```
ALTER DOMAIN zipcode ADD CONSTRAINT zipchk CHECK (char_length(VALUE) = 5);
```

从域中删除检查约束：

```
ALTER DOMAIN zipcode DROP CONSTRAINT zipchk;
```

将域移动到不同的模式：

```
ALTER DOMAIN zipcode SET SCHEMA customers;
```

## 兼容性

ALTER DOMAIN 符合 SQL 标准，除了OWNER 和 SET SCHEMA 变型, 它们是 HashData 数据库扩展。

## 另见

[CREATE DOMAIN](./create-domain.md)，[DROP DOMAIN](./drop-domain.md)

**上级主题：** [SQL命令参考](./README.md)

