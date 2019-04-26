# pg\_filespace\_entry

表空间需要一个文件系统位置来储存其数据库文件。在 HashData 数据库中，Master 和每个 Segment（主 Segment 和镜像 Segment）需要自己独特的存储位置。 HashData 系统中所有组件的文件系统位置的集合被称为 _文件空间_ 。pg\_filespace\_entry 表包含构成一个 HashData 数据库文件空间的 HashData 数据库系统中文件系统位置集合的信息。

##### 表 1. pg\_catalog.pg\_filespace\_entry

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| fsefsoid | OID | pg\_filespace.oid | 文件空间的对象 ID |
| fsedbid | integer | gp\_segment\_ configuration.dbid | Segment 的 ID。 |
| fselocation | text |  | 这个 Segment ID 的文件系统位置。 |

**上级主题：** [系统目录定义](./README.md)
