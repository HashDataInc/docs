# pg\_conversion

pg\_conversion 系统目录表描述了由 CREATE CONVERSION 定义的可用编码转换过程。

##### 表 1. pg\_catalog.pg\_conversion

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| conname | name |  | 转换的名称（在命名空间中唯一）。 |
| connamespace | oid | pg\_namespace.oid | 包含此转换的命名空间（方案）的OID。 |
| conowner | oid | pg\_authid.oid | 转换的拥有者。 |
| conforencoding | int4 |  | 源编码ID。 |
| contoencoding | int4 |  | 目标编码ID。 |
| conproc | regproc | pg\_proc.oid | 转换过程。 |
| condefault | boolean |  | 如果是默认转换，则为真。 |

**上级主题：** [系统目录定义](./README.md)
