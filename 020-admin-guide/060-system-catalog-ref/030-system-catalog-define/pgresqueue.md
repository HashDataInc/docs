# pg\_resqueue

pg\_resqueue系统目录包含了用于负载管理特性的 HashData 数据库资源队列的信息。该表只在Master上被填充。该表定义在pg\_global表空间中，意味着它被系统中所有数据库共享。

##### 表 1. pg\_catalog.pg\_resqueue

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| rsqname | name |  | 资源队列名。 |
| rsqcountlimit | real |  | 资源队列的活动查询阈值。 |
| rsqcostlimit | real |  | 资源队列的查询代价阈值。 |
| rsqovercommit | boolean |  | 当系统是空闲时，允许超过代价阈值的查询运行。 |
| rsqignorecostlimit | real |  | 查询被认为是一个“小查询”的查询代价限制。代价低于该限制的查询将不会被入队列而是立即被执行。 |

**上级主题：** [系统目录定义](./README.md)
