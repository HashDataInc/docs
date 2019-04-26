# CREATE RULE

# 创建规则

定义一个新的重写规则。

## 概要

```
CREATE [OR REPLACE] RULE name AS ON event
  TO table [WHERE condition] 
  DO [ALSO | INSTEAD] { NOTHING | command | (command; command 
  ...) }
```

## 描述

CREATE RULE 定义一个新的规则应用于指定的表或视图 CREATE OR REPLACE RULE 将创建一个新的规则，或者在同一张表中替代一个已经存在的同名的规则。

HashData 数据库规则系统允许定义对数据库表的插入，更新或删除的可选操作。当指定表上的命令执行时，规则会导致附加命令或可选命令将被执行。规则也能应用于视图。意识到规则实际上是命令转换机制，或是命令宏是很重要的。转换在执行命令开始之前发生，它不像触发器那样为每个物理行独立运行。

ON SELECT 规则必须是无条件的 INSTEAD 规则，并且必须具有由单个 SELECT 命令组成的操作。因此，ON SELECT 能有效的将表转换成视图，其视图内容是规则的 SELECT 命令返回的行，而不是存储在表中的任何内容（如果有的话）。编写 CREATE VIEW 命令的风格比创建真实的表并且在其上定义 ON SELECT 规则要好很多。

用户可以通过定义 ON INSERT， ON UPDATE，和 ON DELETE 规则来创建可更新的视图的错觉，以便在其他表带有更新操作的视图上替换更新操作。

如果用户尝试使用条件规则进行视图更新，则会有一个 catch：对于希望在视图中允许的每一个操作，必须要有一个无条件的 INSTEAD 规则。如果规则是有条件的或不是 INSTEAD，则系统仍将拒绝执行更新操作的尝试，因为它认为在某些情况下可能会尝试对视图的虚拟表执行操作。如果要处理条件规则中的所有可用的情况，请添加无条件的 DO INSTEAD NOTHING 规则来确保系统理解它将永远不会被调用来更新虚拟表。然后使条件规则非 INSTEAD；在应用他们的场景中，他们添加到默认的 INSTEAD NOTHING 操作。（但是，该方法目前无法支持 RETURNING 查询）

## 参数

name

创建规则的名称。改名字在同一张表中必须和其他的规则的名字不相同。同一表和相同事件类型上的多个规则按字母顺序排序。

event

该事件是以下 SELECT，INSERT， UPDATE，或 DELETE 之一。

table

该规则所应用的表或视图的名称（选择性方案限定）。

condition

任何 SQL 的条件表达式（返回布尔值）。该条件表达式可能不会引用任何表除了 NEW 和 OLD，并且可能不会包含聚集函数。 NEW 和 OLD 引用参考表中的值。NEW 表在 ON INSERT 和 ON UPDATE 规则中有效，以引用要插入或更新的新行。OLD 表在 ON UPDATE 和 ON DELETE 规则中有效，以引用将要被更新或者删除的行。

INSTEAD

INSTEAD 提示该命令应当替代原命令运行。

ALSO

ALSO 提示该命令应当附加到原命令上运行。如果不指定是 ALSO 也不指定 INSTEAD，则默认是 ALSO。

command

构成规则操作的命令或命令组。有效的命令是 SELECT，INSERT，UPDATE，或 DELETE。特殊表名 NEW 和 OLD 可能会被用来引用在参考表中的值。 NEW 在 ON INSERT 和 ONUPDATE 规则中有效，以引用被更新或插入的新行。OLD 在 ON UPDATE 和 ON DELETE 规则中有效，以引用将被更新和删除的行。

## 注意

用户必须是表的拥有者才能为其创建和改变规则。

注意避免递归规则是很重要的，递归规则在规则创建时不会被验证，但会在执行时报告错误。

## 例子

创建一个规则向字表 b2001 中插入行，当用户试图向其分区的父表 rank 中插入的时候:

```
CREATE RULE b2001 AS ON INSERT TO rank WHERE gender='M' and 
year='2001' DO INSTEAD INSERT INTO b2001 VALUES (NEW.id, 
NEW.rank, NEW.year, NEW.gender, NEW.count);
```

## 兼容性

就如同整个查询重写系统一样，CREATE RULE 是 HashData 数据库语言的扩展。

## 另见

[DROP RULE](./drop-rule.md)， [CREATE TABLE](./create-table.md)， [CREATE VIEW](./create-view.md)

**上级话题：** [SQL命令参考](./README.md)

