# pg\_stat\_partition\_operations

pg\_stat\_partition\_operations 视图显示了执行在一个分区表上的上一个操作的细节信息。

##### 表 1. pg\_catalog.pg\_stat\_partition\_operations

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| classname | text |  | The name of the system table in the pg\_catalog schema where the record about this object is stored \(always pg\_class for tables and partitions\). |
| objname | name |  | 对象名。 |
| objid | oid |  | 对象OID。 |
| schemaname | name |  | 对象所属的模式的模式名。 |
| usestatus | text |  | 上一个在对象上执行操作的角色的状态（CURRENT=当前系统中活跃的角色，DROPPED=已经不再系统中的角色， CHANGED=仍然有同名的角色在系统中，但是从上次操作执行后已经发生了改变）。 |
| usename | name |  | 在对象上执行操作的角色的角色名。 |
| actionname | name |  | 执行在对象上的操作。 |
| subtype | text |  | 被执行操作的对象的类型或者The type of object operated on or the subclass of operation performed. |
| statime | timestamptz |  | 操作的时间戳。这和写到 HashData 数据库系统日志文件的时间戳是相同的，以防需要在日志中查询更多关于操作细节的信息。 |
| partitionlevel | smallint |  | 该分区在分区层次中的级别。 |
| parenttablename | name |  | 该分区上一个层次的父表的关系名。 |
| parentschemaname | name |  | 父表所属模式的名称。 |
| parent\_relid | oid |  | 该分区上一个层次的父表的OID。 |

**上级主题：** [系统目录定义](./README.md)
