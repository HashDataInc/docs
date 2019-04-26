# segment\_\*

segment\_\* 表包含 HashData 数据库 Segment 实例的内存分配统计。这会跟踪一个特定 Segment 实例上所有 postgres 进程消耗的内存量，以及根据 postgresql.conf 配置参数 gp\_vmem\_protect\_limit 留给 Segment 的可用内存量。一个导致 Segment 超过该限制的查询将被取消从而防止系统级别的内存不足错误。

有三个 Segment 表，它们都有相同的列：

* segment\_now 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到 segment\_history 表之间的时段，当前内存分配数据存储在 segment\_now  中。

* segment\_tail 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 segment\_now 中清除但是还没有提交到 segment\_history 的内存分配数据。它通常只包含了几分钟的数据。

* segment\_history 是一个常规表，它存储数据库范围的历史内存分配数据。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

一个特定的 Segment 实例通过它的 hostname 和 dbid（根据 gp\_segment\_configuration 的唯一 Segment 标识符）来标识。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp\(0\)\(without time zone\) | 此行创建的时间 |
| dbid | int | Segment 的 ID（dbid 来自于 gp\_segment\_configuration）。 |
| hostname | varchar\(64\) | Segment 的主机名。 |
| dynamic\_memory\_used | bigint | 在该 Segment 上执行的查询处理分配的动态内存量（以字节为单位）。 |
| dynamic\_memory\_available | bigint | 在达到通过参数 gp\_vmem\_protect\_limit 设置的值前该 Segment 还能请求的额外的动态内存量（以字节为单位）。 |

主机的聚合内存分配与利用另见视图 memory\_info 和 dynamic\_memory\_info。


