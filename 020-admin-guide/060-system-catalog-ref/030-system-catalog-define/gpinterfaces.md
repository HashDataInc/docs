# gp\_interfaces

gp\_interfaces 表包含有关Segment主机上的网络接口的信息。 该信息与[gp\_db\_interfaces](./gpdb-interfaces.md)的数据连接在一起被系统用来为多种目的优化可用网络接口的使用，包括故障检测。

##### 表 1. gp\_interfaces

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| interfaceid | smallint |  | 系统分配的ID。 网络接口的唯一标识符。 |
| address | name |  | 包含网络接口的Segment主机的主机名地址。可以是数字IP地址或主机名。 |
| status | smallint |  | 网络接口的状态。值为0表示接口不可用。 |

**上级主题：** [系统目录定义](./README.md)
