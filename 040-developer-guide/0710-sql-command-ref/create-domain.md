# CREATE DOMAIN

定义一个新的域。

## 概要

```
CREATE DOMAIN name [AS] data_type [DEFAULT expression] 
       [CONSTRAINT constraint_name
       | NOT NULL | NULL 
       | CHECK (expression) [...]]
```

## 描述

CREATE DOMAIN 创建一个新的域。域本质上是一种带有可选约束（在允许的值集合上的限制）的数据类型。 定义域的用户将成为它的拥有者。域的名称在其模式中的类型和域之间必须保持唯一。

域主要被用于把字段上的常用约束抽象到一个单一的位置以便维护。例如，几个表可能都包含电子邮件地址列，而且都要求相同的 CHECK 约束来验证地址的语法。可以为此定义一个域，而不是在每个表上都单独设置一个约束。

## 参数

_name_

要被创建的域的名称（可以被方案限定）。

_data\_type_

域的底层数据类型。可以包括数组指示符。

DEFAULT _expression_

为该域数据类型的列指定一个默认值。该值是任何没有变量的表达式（但不允许子查询）。默认值表达式的数据类型必须匹配域的数据类型。如果没有指定默认值，那么默认值就是空值。默认值表达式将被用在任何没有指定列值的插入操作中。如果为一个特定列定义了默认值，它会覆盖与域相关的默认值。继而，域默认值会覆盖任何与底层数据类型相关的默认值。

CONSTRAINT _constraint\_name_

一个约束的名称（可选）。如果没有指定，系统会生成一个名称。

NOT NULL

这个域的值通常不能为空值。

NULL

这个域的值允许为空值，这是默认值。这个子句只是为了与非标准 SQL 数据库相兼容而设计。在新的应用中不鼓励使用它。

CHECK \(_expression_\)

CHECK 子句指定该域的值必须满足的完整性约束或者测试。每一个约束必须是一个产生布尔结果的表达式。 它应该使用关键词 VALUE 来引用要被测试的值。目前, CHECK 表达式不能包含子查询，也不能引用 VALUE 之外的变量。

## 示例

创建 `us_zip_code` 数据类型。使用正则表达式测试来验证该值是否为有效的美国邮政编码。

```
CREATE DOMAIN us_zip_code AS TEXT CHECK 
       ( VALUE ~ '^d{5}$' OR VALUE ~ '^d{5}-d{4}$' );
```

## 兼容性

CREATE DOMAIN 符合 SQL 标准。

## 另见

[ALTER DOMAIN](./alter-domain.md)，[DROP DOMAIN](./drop-domain.md)

**上级主题：** [SQL命令参考](./README.md)

