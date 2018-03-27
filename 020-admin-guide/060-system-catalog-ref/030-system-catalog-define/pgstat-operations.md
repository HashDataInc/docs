# pg\_stat\_operations

视图 pg\_stat\_operations 显示了关于最后一个执行在数据库对象（例如，表、索引、视图或者数据库）上或者全局对象（例如角色）的操作的细节信息。

##### 表 1. pg\_catalog.pg\_stat\_operations

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| classname | text |  | 在 pg\_catalog 模式中的系统表的名称。\(pg\_class=relations, pg\_database=databases,pg\_namespace=schemas,pg\_authid=roles\) |
| objname | name |  | 对象名。 |
| objid | oid |  | 对象OID。 |
| schemaname | name |  | 对象所属的模式的模式名。 |
| usestatus | text |  | 上一个在对象上执行操作的角色的状态（CURRENT=当前系统中活跃的角色，DROPPED=已经不再系统中的角色， CHANGED=仍然有同名的角色在系统中，但是从上次操作执行后已经发生了改变）。 |
| usename | name |  | 在对象上执行操作的角色的角色名。 |
| actionname | name |  | 执行在对象上的操作。 |
| subtype | text |  | 被执行操作的对象的类型或者 The type of object operated on or the subclass of operation performed. |
| statime | timestamptz |  | 操作的时间戳。这和写到 HashData 数据库系统日志文件的时间戳是相同的，以防需要在日志中查询更多关于操作细节的信息。 |

**上级主题：** [系统目录定义](./README.md)
