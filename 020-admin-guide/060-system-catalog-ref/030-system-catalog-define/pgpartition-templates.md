# pg\_partition\_templates

pg\_partition\_templates 系统视图用来显示通过子分区模板创建的子分区。

##### 表 1\. pg\_catalog.pg\_partition_templates

|列|类型|参考|描述|
|:---|:---|:---|:---|
|schemaname|name||该分区表所在的方案的名称。
|tablename|name||顶层父表的表名。
|partitionname|name||子分区的名称（如果在ALTER TABLE命令中引用分区，用的就是这个名称）。如果该分区在创建时或者通过EVERY子句产生时没有给定一个名称则为NULL。
|partitiontype|text||子分区的类型（范围或者列表）。
|partitionlevel|smallint||该分区在层次中的级别。
|partitionrank|bigint||对于范围分区，该分区相对于同级中其他分区的排名。
|partitionposition|smallint||该子分区的规则顺序位置。
|partitionlistvalues|text||对于列表分区，该子分区相关的列表值。
|partitionrangestart|text||对于范围分区，该子分区的开始值。
|partitionstartinclusive|boolean||如果该子分区包含了开始值则为T，否则为F。
|partitionrangeend|text||对于范围分区，该子分区的结束值。
|partitionendinclusive|boolean|| 如果该子分区包含了结束值则为T，否则为F。
|partitioneveryclause|text||该子分区的 EVERY 子句（间隔）。
|partitionisdefault|boolean||如果这是一个默认子分区则为T，否则为F。
|partitionboundary|text||该子分区的整个分区说明。

**上级主题：** [系统目录定义](./README.md)