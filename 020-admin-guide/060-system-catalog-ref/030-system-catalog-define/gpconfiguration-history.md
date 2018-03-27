# gp\_configuration\_history

gp\_configuration\_history 表包含有关故障检测和恢复操作相关的系统更改信息。 fts\_probe进程将数据记录到此表，和相关的 gpcheck、gprecoverseg和gpinitsystem之类的管理工具一样。 例如，当用户向系统添加新的Segment和镜像Segment时，这些事件会被记录到 gp\_configuration\_history。

该表仅在Master上填充。该表在 pg\_global表空间中定义, 这意味着它在系统中的所有数据库之间全局共享。

##### 表 1. pg\_catalog.gp\_configuration\_history

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| time | timestamp with time zone |  | 记录事件的时间戳。 |
| dbid | smallint | gp\_segment \_configuration.dbid | 系统分配的ID。Segment（或者Master）实例的唯一标识符。 |
| desc | text |  | 时间的文本描述 |

有关gpcheck、 gprecoverseg 和 gpinitsystem 的信息，请参阅 HashData 数据库工具指南。

**上级主题：** [系统目录定义](./README.md)

