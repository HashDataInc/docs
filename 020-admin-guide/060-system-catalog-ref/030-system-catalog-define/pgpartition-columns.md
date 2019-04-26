# pg\_partition\_columns

pg\_partition\_columns系统视图被用来显示一个分区表的分区键列。

##### 表 1\. pg\_catalog.pg\_partition_columns

|列|类型|参考|描述|
|:---|:---|:---|:---|
|schemaname|name||该分区表所在方案的名称。
|tablename|name||顶层父表的表名。
|columnname|name||分区键列的名称。
|partitionlevel|smallint||该子分区在层次中的级别。
|position\_in\_partition_key|integer||对于列表分区可以有组合（多列）分区键。此处显示了列在组合键中的位置。

**上级主题：** [系统目录定义](./README.md)