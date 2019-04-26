# pg\_stat\_replication

pg\_stat\_replication 视图包含用来镜像 HashData 数据库的 Master 的 walsender 进程的元数据。

##### 表 1. pg\_catalog.pg\_stat\_replication

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| procpid | integer |  | WAL发送器后台进程的进程ID。 |
| usesysid | integer |  | 运行WAL发送器后台进程的用户系统ID。 |
| usename | name |  | 运行WAL发送器后台进程的用户名。 |
| application\_name | oid |  | 客户端应用名。 |
| client\_addr | name |  | 客户端IP地址。 |
| client\_port | integer |  | 客户端端口号。 |
| backend\_start | timestamp |  | 操作开始的时间戳。 |
| state | text |  | WAL发送状态。可取值有：startup,backup,catchup,streaming |
| sent\_location | text |  | WAL发送器已发送的xlog记录位置。 |
| write\_location | text |  | WAL接收器的xlog记录写位置。 |
| flush\_location | text |  | WAL接收器的xlog记录刷入位置。 |
| replay\_location | text |  | 后备机xlog记录的重放位置。 |
| sync\_priority | text |  | 优先级，值为1。 |
| sync\_state | text |  | WAL发送器的同步状态。该值为sync。 |

**上级主题：** [系统目录定义](./README.md)
