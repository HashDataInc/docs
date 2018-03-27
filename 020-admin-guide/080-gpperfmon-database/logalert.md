# log\_alert\_\*

log\_alert\_\* 表存储 pg\_log 的错误和警告。

这里有三种 log\_alert 表，所有的表都有相同的列：

* log\_alert\_now 是一个外部表，其数据文件存在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到 log\_alert\_history 表之间的时段，当前的 pg\_log 错误和警告存储在 log\_alert\_now 中。
* log\_alert\_tail 是一个外部表，其数据文件存在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 log\_alert\_now 中清除但是还没有提交到 log\_alert\_history 的 pg\_log 错误和警告。它通常只包含了几分钟的数据。
* log\_alert\_history 是一个常规表，它存储数据库范围的历史错误和警告数据。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

| Column | Type | Description |
| :--- | :--- | :--- |
| logtime | timestamp with time zone | 此日志文件的时间戳 |
| loguser | text | 查询的用户 |
| logdatabase | text | 访问的数据库 |
| logpid | text | 进程 ID |
| logthread | text | 线程数 |
| loghost | text | 主机名或 IP 地址 |
| logport | text | 端口号 |
| logsessiontime | timestamp with time zone | 会话时间戳 |
| logtransaction | integer | 事务IDTransaction id |
| logsession | text | 会话IDSession id |
| logcmdcount | text | 指令统计 |
| logsegment | text | Segment 数量 |
| logslice | text | 片数量 |
| logdistxact | text | 分布事务 |
| loglocalxact | text | 本地事务 |
| logsubxact | text | 子事务 |
| logseverity | text | 日志严重性 |
| logstate | text | 状态 |
| logmessage | text | 日志信息 |
| logdetail | text | 详细信息 |
| loghint | text | 提示信息 |
| logquery | text | 执行查询 |
| logquerypos | text | 查询位置 |
| logcontext | text | 内容信息 |
| logdebug | text | 调试 |
| logcursorpos | text | 游标位置 |
| logfunction | text | 函数信息 |
| logfile | text | 源代码文件 |
| logline | text | 源代码行 |
| logstack | text | 栈追踪 |

## 日志处理和切换

HashData 数据系统日志记录器把警告日志写到 $MASTER\_DATA\_DIRECTORY/gpperfmon/logs 目录中。

代理进程（gpmmon）执行下面的步骤来合并日志文件然后将它们加载到 gpperfmon 数据库：

1. 收集日志目录（除了最新的日志，它已被 syslogger 打开并且正被写入）下的所有 gpdb-alert-\* 文件到单个文件 alert\_log\_stage 中。

2. 装载 alert\_log\_stage 文件到 gpperfmon 数据库中的 log\_alert\_history 表。

3. 清空 alert\_log\_stage 文件。

4. 移除所有的 gp-alert-\* 文件，除了最新的那个。

syslogger 每24小时或者当当前的日志文件大小超过 1M 时切换一次警告日志。如果有单个错误消息包含一个大型 SQL 语句或者大型的栈追踪，被轮转的日志文件可能会超过 1MB。此外，syslogger 以块的方式处理错误消息，每个日志进程都会有一个单独的块。块的大小取决于操作系统；比如，在 Red Hat Enterprise Linux 上，块的大小为 4096 字节。如果许多 HashData 数据库会话同时产生错误消息，那么在它大小被检查前以及日志选择被触发前，日志文件会显著地增大。


