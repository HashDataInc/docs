# gp\_resqueue\_status

gp\_toolkit.gp\_resqueue\_status视图允许管理员查看负载管理资源队列的状态和活动。它显示系统中有多少来自特定资源队列的查询操作正在等待运行，以及有多少个活动查询来自于特定的资源队列。

##### 表 1. gp\_toolkit.gp\_resqueue\_status

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| queueid | oid | gp\_toolkit.gp\_resqueue\_ queueid | 资源队列的ID。 |
| rsqname | name | gp\_toolkit.gp\_resqueue\_ rsqname | 资源队列的名称。 |
| rsqcountlimit | real | gp\_toolkit.gp\_resqueue\_ rsqcountlimit | 资源队列的活动查询阈值。值-1表示无限制。 |
| rsqcountvalue | real | gp\_toolkit.gp\_resqueue\_ rsqcountvalue | 资源队列中当前正被使用的活动查询槽的数量。 |
| rsqcostlimit | real | gp\_toolkit.gp\_resqueue\_ rsqcostlimit | 资源队列的查询代价阈值。值-1表示无限制。 |
| rsqcostvalue | real | gp\_toolkit.gp\_resqueue\_ rsqcostvalue | 资源队列中当前所有语句的总代价。 |
| rsqmemorylimit | real | gp\_toolkit.gp\_resqueue\_ rsqmemorylimit | 资源队列的内存限制。 |
| rsqmemoryvalue | real | gp\_toolkit.gp\_resqueue\_ rsqmemoryvalue | 资源队列中当前所有语句使用的总内存。 |
| rsqwaiters | integer | gp\_toolkit.gp\_resqueue\_ rsqwaiter | 资源队列中正在等待的语句数。 |
| rsqholders | integer | gp\_toolkit.gp\_resqueue\_ rsqholders | 目前在系统中运行的来自该资源队列的语句数目。 |

**上级主题：** [系统目录定义](./README.md)
