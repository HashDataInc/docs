# pg\_partition\_rule

pg\_partition\_rule系统目录表被用来跟踪分区表、它们的检查约束以及数据包含规则。pg\_partition\_rule表中的每一行要么代表了一个叶子分区（最底层包含数据的分区），要么是一个分支分区（用于定义分区层次的顶层或者中间层分区，但不包含数据）。

##### 表 1. pg\_catalog.pg\_partition\_rule

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| paroid | oid | pg\_partition.oid | 这个分区所属的分区级别的行标识符（来自 [pg\_partition](./pgpartition.md) ）。对于分支分区，相应的表（由pg\_partition\_rule标识）是一个空的容器表。对于叶子分区，这个表含有分区包含规则的行。 |
| parchildrelid | oid | pg\_class.oid | 分区（子表）的表标识符。 |
| parparentrule | oid | pg\_partition\_rule.paroid | 与该分区的父表相关的规则的行标识符。 |
| parname | name |  | 该分区的给定名称。 |
| parisdefault | boolean |  | 该分区是否为默认分区。 |
| parruleord | smallint |  | 对于范围分区表，该分区在分区层次的这个级别上的排名。 |
| parrangestartincl | boolean |  | 对于范围分区表，开始值是否被包括。 |
| parrangeendincl | boolean |  | 对于范围分区表，结束值是否被包括。 |
| parrangestart | text |  | 对于范围分区表，范围的开始值。 |
| parrangeend | text |  | 对于范围分区表，范围的结束值。 |
| parrangeevery | text |  | 对于范围分区表，EVERY子句的间隔值。 |
| parlistvalues | text |  | 对于列表分区表，指派给该分区的值列表。 |
| parreloptions | text |  | 一个描述特定分区存储特性的数组。 |

**上级主题：** [系统目录定义](./README.md)
