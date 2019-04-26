# EXECUTE

执行一个预备的 SQL 语句。

## 概要

```
EXECUTE name [ (parameter [, ...] ) ]
```

## 描述

EXECUTE 被用来执行一个之前准备好的语句。由于预备语句只在会话期间存在，该预备语句必须在当前会话中由一个更早执行的 PREPARE 语句所创建。

如果创建预备语句的 PREPARE 语句指定了一些参数，必须向 EXECUTE 语句传递一组兼容的参数，否则会发生错误。注意（与函数不同）预备语句无法基于其参数的类型或者数量重载。在一个数据库会话中，预备语句的名称必须唯一。

更多创建和使用预备语句的信息请见 PREPARE。

## 参数

name

要执行的预备语句的名称。

parameter

给预备语句的参数的实际值。这必须是一个能得到与该参数数据类型（ 在预备语句创建时决定）兼容的值的表达式。

## 示例

为一个 INSERT 语句创建一个预备语句，然后执行它：

```
PREPARE fooplan (int, text, bool, numeric) AS INSERT INTO 
foo VALUES($1, $2, $3, $4);
EXECUTE fooplan(1, 'Hunter Valley', 't', 200.00);
```

## 兼容性

SQL 标准包括了一个 EXECUTE 语句，但是只被用于嵌入式 SQL。这个版本的 EXECUTE 语句也用了一种有点不同的语法。

## 另见

[DEALLOCATE](./deallocate.md), [PREPARE](./prepare.md)

**上级主题：** [SQL命令参考](./README.md)

