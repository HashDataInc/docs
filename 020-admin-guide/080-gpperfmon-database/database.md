# database\_\*

database\_\* 表存储一个 HashData 数据库实例的查询负载信息。有三个数据库表，它们都有相同的列：

* database\_now 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到 database\_history 表之间的时段，当前查询负载数据存储在 database\_now 中。
* database\_tail 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 database\_now 中清除但是还没有提交到 database\_history 的查询负载数据。它通常只包含了几分钟的数据。
* database\_history 是一个常规表，它存储数据库范围的历史查询负载数据。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp\(0\) | 此行创建的时间 |
| queries\_total | int | 数据收集时刻，数据库中总的查询数量。 |
| queries\_running | int | 数据收集时刻，数据库中活跃的查询数量。 |
| queries\_queued | int | 数据收集时刻，在资源队列中等待的查询数量。 |


