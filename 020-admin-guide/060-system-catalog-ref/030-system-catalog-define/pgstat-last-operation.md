# pg\_stat\_last\_operation

pg\_stat\_last\_operation表包含关于数据库对象（表、视图等）的元数据跟踪信息。

##### 表 1. pg\_catalog.pg\_stat\_last\_operation

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| classid | oid | pg\_class.oid | 包含对象的系统目录的OID。 |
| objid | oid | any OID column | 对象在其系统目录内的对象OID。 |
| staactionname | name |  | 在一个对象上采取的动作。 |
| stasysid | oid | pg\_authid.oid | pg\_authid.oid的外键。 |
| stausename | name |  | 在该对象上执行操作的角色的名称。 |
| stasubtype | text |  | 被执行操作的对象的类型或者被执行操作的子类。 |
| statime | timestamp with timezone |  | 操作的时间戳。这和写到 HashData 数据库服务器日志文件的时间戳是相同的，以便在日志中查询更多关于操作细节的信息。 |

**上级主题：** [系统目录定义](./README.md)
