# gp\_segment\_configuration

gp\_segment\_configuration 表包含有关镜像 Segment 和 Segment 配置的信息。

##### 表 1. pg\_catalog.gp\_segment\_configuration

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| dbid | smallint |  | Segment（或Master）实例的唯一标识符。 |
| content | smallint |  | Segment实例的内容标识符。主Segment实例及其镜像将始终具有相同的内容标识符。对于Segment，值为0- _N_ ，其中 _N_ 是系统中主Segment的数量。对于Master，该值始终为-1。 |
| role | char |  | Segment当前的角色。值是p（主）或者m （镜像）。 |
| preferred\_role | char |  | 在初始化时为Segment初始分配的角色。值为p（主）或者m （镜像）。 |
| mode | char |  | Segment与其镜像副本的同步状态。值是s（已同步）、c（记录更改）或者r（重新同步中）。 |
| status | char |  | Segment的故障状态。值是u（在线）或者d（离线）。 |
| port | integer |  | 数据库服务器监听器进程正在使用的TCP端口。 |
| hostname | text |  | Segment主机的主机名。 |
| address | text |  | 用于访问Segment主机上的特定Segment的主机名。在从3.x升级而来的系统上或者没有为每个接口配置主机名的系统上，该值可能与hostname相同。 |
| replication\_port | integer |  | 块复制进程用来保持主Segment和镜像Segment同步的TCP端口。 |

**上级主题：** [系统目录定义](./README.md)

