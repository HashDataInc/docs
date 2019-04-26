# gp\_persistent\_relation\_node

gp\_persistent\_relation\_node 表跟踪与关系对象（表、视图、索引等）的事务状态有关的文件系统对象状态。此信息用于确保系统目录以及持久化到磁盘的文件系统文件的状态保持同步。该信息由从主机到镜像机的文件复制过程使用。

##### 表 1. pg\_catalog.gp\_persistent\_relation\_node

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| tablespace\_oid | oid | pg\_tablespace.oid | 表空间的对象ID |
| database\_oid | oid | pg\_database.oid | 数据库对象ID |
| relfilenode\_oid | oid | pg\_class.relfilenode | 关系文件节点的对象ID。 |
| segment\_file\_num | integer |  | 对于追加优化的表，追加优化的Segment文件编号。 |
| relation\_storage\_manager | smallint |  | 关系是堆存储还是追加优化存储。 |
| persistent\_state | smallint |  | 0 - 空闲 ；1 - 待定创建 ；2 - 已创建 ；3 - 待定删除 ；4 - 中止创建 ；5 - “即时”待定创建 ；6 - 待定批量加载创建 |
| mirror\_existence\_state | smallint |  | 0 - 无镜像 ；1 - 未被镜像 ；2 - 镜像创建待定 ；3 - 镜像已创建 ；4 - 创建前镜像宕机 ；5 - 创建期间镜像宕机 ；6 - 镜像删除待定 ；7 - 仅剩镜像删除 |
| parent\_xid | integer |  | 全局事务ID。 |
| persistent\_serial\_num | bigint |  | 文件块在事务日志中的日志序列号位置。 |
| previous\_free\_tid | tid |  | 被 HashData 数据库用于在内部管理文件系统对象的持久表示。 |

**上级主题：** [系统目录定义](./README.md)
