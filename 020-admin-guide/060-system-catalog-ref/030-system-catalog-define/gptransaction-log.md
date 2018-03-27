# gp\_transaction\_log

gp\_transaction\_log 视图包含特定段的本地事务的状态信息。此视图允许用户查看本地事务的状态。

##### 表 1. pg\_catalog.gp\_transaction\_log

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| segment\_id | smallint | gp\_segment\_ configuration.content | 如果是Segment，则是内容ID。Master总为-1 \(没有内容\)。 |
| dbid | smallint | gp\_segment\_ configuration.dbid | Segment实例的唯一ID。 |
| transaction | xid |  | 本地事务的ID。 |
| status | text |  | 本地事务的状态（提交或者中止）。 |

**上级主题：** [系统目录定义](./README.md)
