# gpexpand.expansion\_progress

gpexpand.expansion\_progress 视图包含系统扩展操作的状态信息。这个视图提供了表的重分布的估算速率和完成重分布操作的估计时间。

扩展中需要的表的详细状态信息在 [gpexpand.status\_detail](./gpexpandstatusdetail.md) 视图中.

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| name | text |  | Name for the data field provided. Includes:Bytes LeftBytes DoneEstimated Expansion RateEstimated Time to CompletionTables ExpandedTables Left |
| value | text |  | The value for the progress data. For example:Estimated Expansion Rate - 9.75667095996092 MB/s |

**上级主题：** [系统目录定义](./README.md)
