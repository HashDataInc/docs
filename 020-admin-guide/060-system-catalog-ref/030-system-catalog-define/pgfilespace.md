# pg\_filespace

pg\_filespace 表包含在 HashData 数据库系统中创建的文件空间的信息。每个系统都包含一个默认的文件空间 pg\_system，它是在系统初始化的时候创建的数据目录位置的集合。

表空间需要一个文件系统位置来储存其数据库文件。在 HashData 数据库中，Master 和每个 Segment（主 Segment 和镜像 Segment）都需要自己的储存位置。 HashData 系统中所有组件的文件系统位置的集合就被称为文件空间。

##### 表 1. pg\_catalog.pg\_filespace

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| fsname | name |  | 文件空间的名字。 |
| fsowner | oid | pg\_roles.oid | 创建文件空间角色的对象ID。 |

**上级主题：** [系统目录定义](./README.md)
