# gp\_distributed\_xacts

gp\_distributed\_xacts 视图包含有关 HashData 数据库分布式事务的信息。分布式事务是涉及修改 Segment 实例上数据的事务。HashData 的分布式事务管理器确保了这些 Segment 保持同步。此视图允许用户查看当前活动的会话及其关联的分布式事务。

##### 表 1. pg\_catalog.gp\_distributed\_xacts

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| distributed\_xid | xid |  | 分布式事务在HashData数据库阵列中使用的事务ID。 |
| distributed\_id | text |  | 分布式事务标识符。它有2个部分 - 一个唯一的时间戳和分布式事务编号。 |
| state | text |  | 本次会话对于分布式事务的当前状态。 |
| gp\_session\_id | int |  | 与此事务关联的HashData数据库会话的ID编号。 |
| xmin\_distributed \_snapshot | xid |  | 在此事务开始时，所有打开事务中发现的最小分布式事务号。它用于MVCC分布式快照目的。 |

**上级主题：** [系统目录定义](./README.md)
