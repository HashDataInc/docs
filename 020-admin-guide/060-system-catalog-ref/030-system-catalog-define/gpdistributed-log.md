# gp\_distributed\_log

gp\_distributed\_log视图包含有关分布式事务及其关联的本地事务的状态信息。分布式事务是涉及修改Segment实例上数据的事务。 HashData 的分布式事务管理器确保了这些Segment保持同步。 此视图允许用户查看分布式事务的状态。

##### 表 1. pg\_catalog.gp\_distributed\_log

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| segment\_id | smallint | gp\_segment\_ configuration.content | 如果是Segment，则是其内容ID。Master总是为-1（无内容）。 |
| dbid | small\_int | gp\_segment\_ configuration.dbid | Segment实例的唯一ID。 |
| distributed\_xid | xid |  | 全局事务ID。 |
| distributed\_id | text |  | 分布式事务的系统分配ID。 |
| status | text |  | 分布式事务的状态（提交或者中止）。 |
| local\_transaction | xid |  | 本地事务ID。 |

**上级主题：** [系统目录定义](./README.md)
