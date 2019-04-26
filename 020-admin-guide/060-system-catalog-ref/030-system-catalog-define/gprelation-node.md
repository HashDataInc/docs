# gp\_relation\_node

gp\_relation\_node 表包含有关关系（表、视图、索引等）的文件系统对象的信息。

##### 表 1. pg\_catalog.gp\_relation\_node

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| relfilenode\_oid | oid | pg\_class.relfilenode | 关系文件节点的对象ID。 |
| segment\_file\_num | integer |  | 对于追加优化的表，追加优化的Segment文件编号。 |
| persistent\_tid | tid |  | 被 HashData 数据库用于在内部管理文件系统对象的持久表示。 |
| persistent\_serial\_num | bigint |  | 文件块在事务日志中的日志序列号位置。 |

**上级主题：** [系统目录定义](./README.md)
