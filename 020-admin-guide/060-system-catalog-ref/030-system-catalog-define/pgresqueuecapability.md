# pg\_resqueuecapability

pg\_resqueuecapability 系统目录表包含现有 HashData 数据库资源队列的扩展属性或者能力的信息。只有已经被指定了扩展能力（例如，优先级设置）的资源队列会被记录在该表中。该表通过资源队列对象 ID 与 [pg\_resqueue](./pgresqueue.md) 表连接，通过资源类型 ID（restypid）与 [pg\_resourcetype](./pgresourcetype.md) 表连接。

该表只在 Master 上被填充。该表定义在 pg\_global 表空间中，意味着它在系统中所有的数据库间共享。

##### 表 1. pg\_catalog.pg\_resqueuecapability

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| rsqueueid | oid | pg\_resqueue.oid | 相关资源队列的对象ID。 |
| restypid | smallint | pg\_resourcetype.restypid | 资源类型，该值从 [_pg\_resqueuecapability_](./pgresqueuecapability.md) 系统表中得来。 |
| ressetting | opaque type |  | 为这个记录所引用的能力设置的特定值。根据实际的资源类型，该值可能有不同的数据类型。 |

**上级主题：** [系统目录定义](./README.md)
