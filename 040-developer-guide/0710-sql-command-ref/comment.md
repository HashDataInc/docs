# COMMENT

定义或更改对象的注释。

## 概要

```
COMMENT ON
{ TABLE object_name |
  COLUMN table_name.column_name |
  AGGREGATE agg_name (agg_type [, ...]) |
  CAST (sourcetype AS targettype) |
  CONSTRAINT constraint_name ON table_name |
  CONVERSION object_name |
  DATABASE object_name |
  DOMAIN object_name |
  FILESPACE object_name |
  FUNCTION func_name ([[argmode] [argname] argtype [, ...]]) |
  INDEX object_name |
  LARGE OBJECT large_object_oid |
  OPERATOR op (leftoperand_type, rightoperand_type) |
  OPERATOR CLASS object_name USING index_method |
  [PROCEDURAL] LANGUAGE object_name |
  RESOURCE QUEUE object_name |
  ROLE object_name |
  RULE rule_name ON table_name |
  SCHEMA object_name |
  SEQUENCE object_name |
  TABLESPACE object_name |
  TRIGGER trigger_name ON table_name |
  TYPE object_name |
  VIEW object_name } 
IS 'text'
```

## 描述

COMMENT 存储关于数据库对象的注释。因此为了修改一段注释，对同一个对象发出一个新的 COMMENT 命令。 要移除一段注释，可在文本字符串的位置上写上 NULL。当对象被删除时，其注释也会被自动删除。

可以使用 psql 元命令轻松检索注释 dd, d+, l+。其他检索注释的用户接口可以构建在 psql 使用的内建函数之上即 obj\_description, col\_description, shobj\_description.

## 参数

_object\_name_

_table\_name.column\_name_

_agg\_name_

_constraint\_name_

_func\_name_

_op_

_rule\_name_

_trigger\_name_

要注释的对象的名称。表，聚合，域，函数，索引，操作符，操作符类，序列，类型和视图的名称可能是方案限定的。

> 注意：HashData 数据库不支持触发器。

_agg\_type_

聚合功能运行的输入数据类型。要引用零参数聚合函数，写 \* 代替输入数据类型的列表。

_sourcetype_

造型的源数据类型的名称。

_targettype_

造型的目标数据类型的名称。

_argmode_

一个函数或者聚集的参数的模式：IN, OUT, INOUT,或者 VARIADIC。如果被省略，默认值是 IN。 注意 COMMENT ON FUNCTION 并不真正关心 OUT 参数， 因为决定函数的身份只需要输入参数。 因此，列出 IN, INOUT, 和 VARIADIC 参数就足够了。

_argname_

一个函数或者聚集参数的名称。 注意 COMMENT ON FUNCTION 并不真正关心参数名称， 因为决定函数的身份只需要参数数据类型。

_argtype_

一个函数或者聚集参数的数据类型。

_large\_object\_oid_

大对象的 OID。

PROCEDURAL

这是一个噪声词。

_text_

写成一个字符串的新注释。如果要删除注释，写成 NULL。

## 注解

当前对查看注释没有安全机制：任何连接到一个数据库的用户能够看到该数据库中所有对象的注释。对于数据库、角色、表空间这类共享对象，注释被全局存储，因此连接到集簇中任何数据库的任何用户可以看到共享对象的所有注释。因此，不要在注释中放置有安全性风险的信息。

## 示例

为表 mytable 附加一段注释：

```
COMMENT ON TABLE mytable IS 'This is my table.';
```

移除它：

```
COMMENT ON TABLE mytable IS NULL;
```

## 兼容性

SQL 标准中没有 COMMENT 语句。

**上级主题：** [SQL命令参考](./README.md)

