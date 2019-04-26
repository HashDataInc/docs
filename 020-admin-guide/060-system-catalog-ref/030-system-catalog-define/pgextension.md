# pg\_extension

该系统目录表 pg\_extension 存储了关于安装的扩展的信息。

##### 表 1. pg\_catalog.pg\_extension

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| extname | name |  | 扩展名 |
| extowner | oid | pg\_authid.oid | 扩展所有者 |
| extnamespace | oid | pg\_namespace.oid | 包含扩展导出对象的模式 |
| extrelocatable | boolean |  | 如果该扩展能够重定位到其他模式，则为真。 |
| extversion | text |  | 扩展的版本名字 |
| extconfig | oid\[\] | pg\_class.oid | 扩展配置表的 regclass OIDs 数组， 如果为空则为 NULL。 |
| extcondition | text\[\] |  | 扩展配置表的 WHERE-clause过滤条件数组，如果没有则为 NULL 。 |

与大多数命名空间列的目录不同，extnamespace 并不意味着该扩展属于这个模式。扩展名不符合模式限制。 extnamespace 模式指示其包含大部分或全部扩展对象的模式。如果 extrelocatable 为 真，则该模式必须包含所有属于扩展名的符合方案限定的对象。

**上级主题：** [系统目录定义](./README.md)
