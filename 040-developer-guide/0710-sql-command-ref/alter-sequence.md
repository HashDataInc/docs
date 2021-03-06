# ALTER SEQUENCE

更改一个序列的定义。

## 概要

```
ALTER SEQUENCE name [INCREMENT [ BY ] increment] 
     [MINVALUE minvalue | NO MINVALUE] 
     [MAXVALUE maxvalue | NO MAXVALUE] 
     [RESTART [ WITH ] start] 
     [CACHE cache] [[ NO ] CYCLE] 
     [OWNED BY {table.column | NONE}]

ALTER SEQUENCE name SET SCHEMA new_schema
```

## 描述

ALTER SEQUENCE 更改一个现有序列发生器的参数。任何没有被明确在 ALTER SEQUENCE 命令中设置的参数，都要维持他们之前的设置。

用户必须拥有该序列才能使用 ALTER SEQUENCE。要更改一个序列的模式，用户还必须拥有新模式上的 CREATE 特权。 注意超级用户自动拥有所有的特权。

## 参数

_name_

要修改的序列的名称（可选方案限定）。

_increment_

子句 INCREMENT BY increment 是可选的。一个正值将产生一个上升序列，一个负值会产生一个下降序列。如果未被指定，则旧的增量值将被保持。

_minvalue_

NO MINVALUE

可选的子句 MINVALUE minvalue 决定一个序列能产生的最小值。 如果 NO MINVALUE 被指定，上升序列和下降序列的默认值分别是 1 和 -263-1。如果这些选项都没有被指定，将保持当前的最小值。

_maxvalue_

NO MAXVALUE

可选子句 MAXVALUE maxvalue 决定一个序列能产生的最大值。 如果 NO MAXVALUE 被指定, 上升序列和下降序列的默认值分别是 263-1 和 -1。如果这些选项都没有被指定，将保持当前的最大值。

_start_

可选子句 RESTART WITH 更改该序列被记录的开始值。

_cache_

子句 CACHE cache 使得序列数字被预先分配并且保存在内存中以便更快的访问。最小值是 1（每次只产生一个值，即无缓存）。如果没有指定，旧的缓冲值将被保持。

CYCLE

当一个上升或者下降序列已经达到 maxvalue 或者 minvalue 时，可选的 CYCLE 关键词可以被用来允许该序列绕回。如果达到限制，下一个被生成的数字将分别是 minvalue 或者 maxvalue。

NO CYCLE

如果可选的 NO CYCLE 关键字被指定，在该序列达到其最大值后对 nextval 的任何调用将会返回错误。如果 CYCLE 或 NO CYCLE 都没有被指定, 将维持旧的循环行为。

OWNED BY _table.column_

OWNED BY NONE

The OWNED BY 选项导致该序列与一个特定的表列相关联，这样如果该列（或者整个表）被删除，该序列也会被自动删除。 如果指定了关联， 这种关联会替代之前为该序列指定的任何关联。被指定的表必须具有相同的 拥有者并且与该序列在同一个模式中。 OWNED BY NONE 可以移除任何现有的关联。

_new\_schema_

该序列的新模式。

## 注解

为了避免从同一个序列获得数字的并发事务阻塞， ALTER SEQUENCE 在该序列生成参数上的结果永远不会被回滚，那些更改立刻生效并且无法逆转。不过， OWNED BY、RENAME TO 以及 SET SCHEMA 子句会导致普通目录被更新并且无法被回滚。

ALTER SEQUENCE 不会立即影响会话中的 nextval\(\) 值，也不会影响当前会话中预先分配的序列值。在注意到序列生成参数被更改之前它们将用尽所有缓存的值。当前会话将被立刻影响。

一些 [ALTER TABLE](./alter-table.md) 的变体可以很好的用于序列。 例如, 重命名一个序列利用 ALTER TABLE RENAME。

## 示例

重启一个被称为 serial 的序列在 105:

```
ALTER SEQUENCE serial RESTART WITH 105;
```

## 兼容性

ALTER SEQUENCE 符合 SQL 标准，OWNED BY、RENAME TO 和 SET SCHEMA 子句除外，它们是 HashData 数据库的扩展。

## 另见

[CREATE SEQUENCE](./create-sequence.md)，[DROP SEQUENCE](./drop-sequence.md)，[ALTER TABLE](./alter-table.md)

**上级主题：** [SQL命令参考](./README.md)

