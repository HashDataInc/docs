# pg\_listener

pg\_listener系统目录表支持LISTEN和NOTIFY命令。监听器在pg\_listener中为每个正在监听的通知名称创建一项。通知者扫描和更新每个匹配的项以显示通知已经发生。通知者也会发送一个信号（使用表中记录的PID）将监听器从睡眠中唤醒。

此表目前不在 HashData 数据库中使用。

##### 表 1. pg\_catalog.pg\_listener

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| relname | name |  | 通知条件名称（该名称不需要匹配数据库中任何实际关系）。 |
| listenerpid | int4 |  | 创建这个项的服务器进程的PID。 |
| notification | int4 |  | 如果这个监听器没有事件待处理，则为0。如果有待处理事件，则为发送通知的服务器进程的PID。 |

**上级主题：** [系统目录定义](./README.md)
