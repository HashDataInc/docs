# gp\_persistent\_filespace\_node

gp\_persistent\_filespace\_node 表跟踪与文件空间对象的事务状态有关的文件系统对象状态。此信息用于确保系统目录以及持久化到磁盘的文件系统文件的状态保持同步。该信息由从主机到镜像机的文件复制过程使用。

###### 表 1. pg\_catalog.gp\_persistent\_filespace\_node

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| filespace\_oid | oid | pg\_filespace.oid | 文件空间的对象ID |
| db\_id\_1 | smallint |  | 主Segment的ID |
| location\_1 | text |  | 主文件系统位置 |
| db\_id\_2 | smallint |  | 镜像Segment的ID |
| location\_2 | text |  | 镜像文件系统位置 |
| persistent\_state | smallint |  | 0 - 空闲 ；1 - 待定创建 ；2 - 已创建 ；3 - 待定删除 ；4 - 中止创建 ；5 - “即时”待定创建 ；6 - 待定批量加载创建 |
| mirror\_existence \_state | smallint |  | 0 - 无镜像 ；1 - 未被镜像 ；2 - 镜像创建待定 ；3 - 镜像已创建 ；4 - 创建前镜像宕机 ；5 - 创建期间镜像宕机 ；6 - 镜像删除待定 ；7 - 仅剩镜像删除 |
| parent\_xid | integer |  | 全局事务ID。 |
| persistent\_serial\_num | bigint |  | 文件块在事务日志中的日志序列号位置。 |
| previous\_free\_tid | tid |  | 被 HashData 数据库用于在内部管理文件系统对象的持久表示。 |

**上级主题：** [系统目录定义](./README.md)
