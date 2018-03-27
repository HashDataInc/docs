# pg\_resqueue\_attributes

pg\_resqueue\_attributes 视图允许管理员查看资源队列的属性，例如活动语句限制、查询代价限制以及优先级。

##### 表 1. pg\_catalog.pg\_resqueue\_attributes

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| rsqname | name | pg\_resqueue.rsqname | 资源队列的名称。 |
| resname | text |  | 资源队列属性的名称。 |
| ressetting | text |  | 资源队列属性的当前值。 |
| restypid | integer |  | 系统分配的资源类型ID。 |

**上级主题：** [系统目录定义](./README.md)
