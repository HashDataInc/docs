# gp\_version\_at\_initdb

gp\_version\_at\_initdb表在 HashData 数据库系统的Master和每一个Segment上被填充。它标识着系统初始化时使用的 HashData 数据库版本。 这个表被定义在pg\_global 表空间中，意味着它在系统中的所有数据库中全局共享。

##### 表 1. pg\_catalog.gp\_version

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| schemaversion | integer |  | 模式版本号。 |
| productversion | text |  | 产品版本号。 |

**上级主题：** [系统目录定义](./README.md)
