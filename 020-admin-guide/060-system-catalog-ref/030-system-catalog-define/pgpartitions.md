# pg\_partitions

pg\_partitions 系统视图被用于显示分区表的结构。

##### 表 1. pg\_catalog.pg\_partitions

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| schemaname | name |  | 分区表所属方案的名称。 |
| tablename | name |  | 顶层父表的名称。 |
| partitiontablename | name |  | 分区表的关系名（直接访问分区时使用的表名）。 |
| partitionname | name |  | 分区的名称（在ALTER TABLE命令引用分区时，使用该名称）。如果在分区创建时或者由EVERY子句产生时没有给定名称则为NULL。 |
| parentpartitiontablename | name |  | 该分区上一层父表的关系名。 |
| parentpartitionname | name |  | 该分区上一层父表给定的名称。 |
| partitiontype | text |  | 分区的类型（范围或者列表）。 |
| partitionlevel | smallint |  | 该分区在层次中的级别。 |
| partitionrank | bigint |  | 对于范围分区，该分区相对于同级其他分区的排名。 |
| partitionposition | smallint |  | 该分区的规则顺序位置。 |
| partitionlistvalues | text |  | 对于列表分区，与该分区相关的列表值。 |
| partitionrangestart | text |  | 对于范围分区，该分区的开始值。 |
| partitionstartinclusive | boolean |  | 如果该分区包含了开始值则为 T ，否则为F。 |
| partitionrangeend | text |  | 对于范围分区，该分区的结束值。 |
| partitionendinclusive | boolean |  | 如果该分区包含了结束值则为 T ，否则为F。 |
| partitioneveryclause | text |  | 该分区的EVERY子句（间隔）。 |
| partitionisdefault | boolean |  | 如果该分区为默认分区则为 T否则为 F. |
| partitionboundary | text |  | 该分区的整个分区描述。 |

**上级主题：** [系统目录定义](./README.md)
