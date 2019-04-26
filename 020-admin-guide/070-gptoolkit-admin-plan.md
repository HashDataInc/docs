# gp\_toolkit 管理方案

 HashData 提供了一个称为 gp\_toolkit 的管理方案，它能用来查询系统表目录、日志文件以及操作系统环境来获取系统状态信息。gp\_toolkit 方案包含了一些能够通过 SQL 命令来访问的视图。gp\_toolkit 能够被所有的数据库用户访问，但是一些对象需要超级用户权限。为了方便，用户或许想要添加 gp\_toolkit 方案到其方案搜索路径中，例如：

```
=> ALTER ROLE myrole SET search_path TO myschema,gp_toolkit;
```
这份文档描述了 gp\_toolkit 中大部分的有用视图。用户可能注意到了 gp\_toolkit 方案中的其他对象（视图、函数以及外部表）并没有在本文档中进行描述（这些是本节中描述的视图的支持对象）。

> 警告：不要修改在 gp\_toolkit 方案中的数据库对象。不要在其中创建数据库对象。改变里面的对象可能会影响到从方案对象返回的管理信息的准确性。在数据库进行备份然后通过 gpcrondump 和 gpdbrestore 工具进行恢复时，任何在 gp\_toolkit 方案中的修改将会丢失。

*   **[检查需要日常维护的表](#topic2-1)**  
    
*   **[检查锁](#topic2-2)**  
    
*   **[检查追加优化表](#topic2-3)**  
    
*   **[浏览 HashData 服务器日志文件](#topic2-4)**  
    
*   **[检查服务器配置文件](#topic2-5)**  
    
*   **[检查失效的 Segment](#topic2-6)**  
    
*   **[检查资源队列活动和状态](#topic2-7)**  
    
*   **[检查查询磁盘溢出空间使用](#topic2-8)**  
    
*   **[查看用户和组（角色）](#topic2-9)**  
    
*   **[检查数据库对象的大小和磁盘空间](#topic2-10)**  
    
*   **[检查不均匀的数据分布](#topic2-11)**  
    

## <h2 id='topic2-1'> 检查需要日常维护的表

下面的视图能够帮助识别需要日常维护（VACUUM 和 / 或者 ANALYZE）的表。

*   [gp\_bloat\_diag](#topic3-1)
*   [gp\_stats\_missing](#topic3-2)

VACUUM 或者 VACUUM FULL 命令回收已经删除的或者废弃的行占据的空间。由于在 HashData 中使用了多版本并发控制（MVCC）事务并发模型 ，被删除或者更新的数据行仍然在磁盘中占据物理空间即使它们在新的事务中是不可见的。过期的行增加了在磁盘上表的大小，同时降低了表扫描的速度。

ANALYZE 命令收集了查询优化器所需的列级别的统计信息。 HashData 使用了基于代价依赖于数据库统计信息的查询优化器。准确的统计允许查询优化器能够更好的评估一个查询操作的选择率以及检索的行数，这样能选择一个更加有效的查询计划。

### <h3 id='topic3-1'> gp\_bloat\_diag

该视图显示了那些膨胀的（在磁盘上实际的页数超过了根据表统计信息得到预期的页数）正规的堆存储的表。膨胀的表需要执行 VACUUM 或者 VACUUM FULL 来回收被已经删除或者废弃的行占据的磁盘空间。该视图能够被所有用户访问，但是非超级用户看到他们有权限访问到的表。

> 注意：对于返回追加优化表信息的诊断函数，见[检查追加优化表](#topic2-3)部分。

##### 表 1. gp\_bloat\_diag 视图

|列名|描述|
|:---|:---|
|bdirelid|表对象id。|
|bdinspname|方案名。|
|bdirelname|表名。|
|bdirelpages|在磁盘上的实际页数。|
|bdiexppages|根据表数据得到的期望的页数。|
|bdidiag|膨胀诊断信息。|

### <h3 id='topic3-2'> gp\_stats\_missing

该视图显示那些没有统计信息的表，因此可能需要在表上执行 ANALYZE 命令。

##### 表 2. gp\_stats\_missing 视图

|列名|描述|
|:---|:---|
|smischema|方案名。|
|smitable|表名。|
|smisize|这些表有统计信息吗？如果这些表没有行数量统计以及行大小统计记录在系统表中，取值为false，这也表明该表需要被分析。如果表没有包含任何的函数时，值也为false。例如，分区表的父表总是空的，同时也总是返回一个false。|
|smicols|表中的列数。|
|smirecs|表中的行数。|

## <h2 id='topic2-2'> 检查锁

当一个事务访问一个关系（如，一张表），它需要获取一个锁。取决于获取锁类型，后续事务可能在它们能访问相同表之前进行等待。更多更与锁类型的信息，见 HashData 管理员指南中“管理数据“部分。 HashData 资源队列（用来负载管理）也需要使用锁来控制查询进入系统的许可。

gp\_locks\_* 这一类的视图能够帮助诊断那些由于一个锁而正在发生等待的查询和会话。

*   [gp\_locks\_on\_relation](#topic3-3)
*   [gp\_locks\_on\_resqueue](#topic3-4)

### <h3 id='topic3-3'> gp\_locks\_on\_relation

该视图显示了当前所有表上持有锁，以及查询关联的锁的相关联的会话信息。更多关于锁类型的信息，见 HashData 管理员指南中“管理数据“部分。该视图能够被所有用户访问，但是非超级用户只能够看到他们有权限访问的关系上持有的锁。

##### 表 3. gp\_locks\_on_relation 视图

|列名|描述|
|:---|:---|
|lorlocktype|能够加锁对象的类型：relation、 extend、page、tuple、transactionid、object、userlock、resource queue以及advisory|
|lordatabase|对象存在的数据库对象ID，如果对象为一个共享对象则该值为0。|
|lorrelname|关系名。|
|lorrelation|关系对象ID。|
|lortransaction|锁所影响的事务ID 。|
|lorpid|持有或者等待该锁的服务器端进程的进程ID 。如果该锁被一个预备事务持有则为NULL。|
|lormode|由该进程持有或者要求的锁模式名。|
|lorgranted|显示是否该锁被授予（true）或者未被授予（false）。|
|lorcurrentquery|会话中的当前查询。|

### <h3 id='topic3-4'> gp\_locks\_on_resqueue

该视图显示当前被一个资源队列持有的所有的锁，以及查询关联的锁的相关联的会话信息。该视图能够被所有用户访问，但是非超级用户只能够看到关联他们自己会话的锁。

##### 表 4. gp\_locks\_on_resqueue 视图

|列名|描述|
|:---|:---|
|lorusename|执行该会话用户的用户名。|
|lorrsqname|资源队列名。|
|lorlocktype|能够加锁的对象类型： resource queue|
|lorobjid|加锁事务的ID 。|
|lortransaction|受到锁影响的事务ID。|
|lorpid|受到锁影响的事务的进程ID 。|
|lormode|该进程持有的或者要求的锁模式的名称。|
|lorgranted|显示是否该锁被授予（true）或者未被授予（false）。|
|lorwaiting|显示是否会话正在等待。|

## <h2 id='topic2-3'> 检查追加优化表

gp\_toolkit 方案包括了一系列能够用来研究追加优化表状态的诊断函数。

当一张追加优化表（或者面向列的追加优化表）被创建，另外一张表被隐式地创建，包含该表当前状态的元数据。元数据包含了诸如每个表的段的记录数的信息。

追加优化表可能有一些不可见的行，这些行已经被更新或者删除，但是仍旧保留在存储空间中直到通过使用 VACUUM 进行压缩处理。隐藏的行通过使用辅助的可见性映射表或者 visimap 来记录。

下面的函数能够让用户访问追加优化表和基于列存的表的元数据以及查看那些不可见的行。一些函数有两个版本：一个版本使用表 oid，另外一个版本使用表名。后一种版本有 "\_name" 添加到函数名之后。

### \_\_gp_aovisimap\_compaction\_info(oid)

该函数显示一张追加优化表的压缩信息。这些信息属于 HashData 数据库 Segment 上存储该表数据的磁盘数据文件。用户可以用这些信息决定那些将要通过追加优化表上的 VACUUM 操作进行压缩的数据文件。

> 注意：直到一个 VACUUM 命令从数据文件中删除了行，已经被删除或者被更新的元组仍旧在磁盘上占有物理空间，即使它们对新的事务是不可见的。配置参数 gp\_appendonly\_compaction 控制 VACUUM 的功能。

该表描述了 \_\_gp_aovisimap\_compaction\_info 函数输出表。

##### 表 5. \_\_gp\_aovisimap\_compaction\_info 输出表

|列名|描述|
|:---|:---|
|conten|HashData 段ID。|
|datafile|在段中的数据文件的ID。|
| compaction_possible |该值的取值要么为t要么为f。当取值为t是表明数据文件中的数据在一个 VACUUM命令执行时被压缩。 服务器端配置参数 gp\_appendonly\_compaction_threshold 影响该值。|
|hidden_tupcount |在数据文件中，被隐藏（已经删除的或者被更新的）的行数。|
|total_tupcount |在数据文件中，总的行数。|
|percent_hidden |在数据文件中，隐藏行（已经被删除或被更新的）占总的行数的比率（百分比）。|

### \_\_gp\_aoseg\_name('table_name')

该函数返回包含在追加优化表的磁盘上的段文件中的元数据信息。

##### 表 6. \_\_gp\_aoseg_name 输出表

|列名|描述|
|:---|:---|
|segno|文件段号。|
|eof|该文件段有效的结尾。|
|tupcount|该段中总的元组数（包括不可见的元组）。|
|varblockcount|段文件中总的 varlbock 数。|
|eof_uncompressed|没有压缩的文件的文件结尾。|
|modcount|数据修改操作的数量。|
|state|文件段的状态。指示段是否是活跃的或者在压缩后可以被删除。|

### \_\_gp\_aoseg_history(oid)

该函数返回包含在追加优化表的磁盘上的段文件中的元数据信息。它显示 aoseg 元信息的所有不同版本（堆元组）。该数据较为复杂，但是对于那些对系统有深入了解的用户能够用这些信息来调试。

输入参数为追加优化表的 OID。

调用以表名作为参数的函数 \_\_gp\_aoseg\_history\_name('table_name') 可以获取相同的结果。

##### 表 7. \_\_gp\_aoseg_history 输出表

|列名|描述|
|:---|:---|
|gp_tid|元组的id。|
|gp_xmin|最早事务的id。|
|gp\_xmin_status|gp_xmin 事务的状态。|
|gp\_xmin\_commit_ |gp_xmin 事务的提交分布式 ID。|
|gp_xmax|最晚的事务ID。|
|gp\_xmax_status|最晚事务的状态。|
|gp\_xmax\_commit_ |gp_xmax 事务的提交分布式ID。|
|gp\_command_id|查询命令的ID。|
|gp_infomask|包含状态信息的位图。|
|gp\_update_tid|如果行被更新，该字段指明新元组的ID 。|
|gp_visibility|元组的可见状态。|
|segno|在段文件中段的数量。|
|tupcount|总的元组数目（包括隐藏元组）。|
|eof|段的有效文件结尾。|
|eof_uncompressed|数据没有被压缩的文件的文件结尾。|
|modcount|数据修改的计数。|
|state|段的状态。|

### \_\_gp_aocsseg(oid)

该函数返回包含在列存式的追加优化表的磁盘段文件中的元数据信息，但不包括不可见行。每行描述表中一个列的一个段。

输入参数是列存追加优化表的 OID。调用以表名作为参数的函数 \_\_gp\_aocsseg\_name('table_name')能够获取相同的结果。

##### 表 8. \_\_gp_aocsseg(oid) 输出表

|列名|描述|
|:---|:---|
|gp_tid|表的id。|
|segno|段号。|
|column_num|列号。|
|physical_segno|在段文件中的段编号。|
|tupcount|段中行的数量，不考虑隐藏的元组。|
|eof|段的有效文件结尾。|
|eof_uncompressed|数据没有被压缩的段的有效文件结尾。|
|modcount|段中数据修改操作的计数。|
|state|段的状态。|

### \_\_gp\_aocsseg_history(oid)

该函数返回包含在列存式的追加优化表的磁盘段文件中的元数据信息。每行描述了一列的一个段。该数据较为复杂，但是对于那些对系统有深入了解用户能够可用这些信息来调试。

输入参数是列存式的追加优化表的OID。调用以表名作为参数的函数\_\_gp\_aocsseg\_history\_name('table_name') 能够得到相同的结果。

##### 表 9. \_\_gp\_aocsseg_history 输出表

|列名|描述|
|:---|:---|
|gp_tid|元组的OID。|
|gp_xmin|最早的事务。|
|gp\_xmin_status|gp_xmin事务的状态。|
|gp\_xmin_ | gp_xmin的文本表示。|
|gp_xmax|最晚的事务。|
|gp\_xmax_status|gp_xmax事务的状态。|
|gp\_xmax_ |gp_xmax的文本表示。|
|gp\_command_id|在元组上的操作的命令ID。|
|gp_infomask|包含状态信息的位图。|
|gp\_update_tid|如果行被更新，这里是更新的元组的ID。|
|gp_visibility|元组的可见性状态。|
|segno|段文件中的段号。|
|column_num|列号。|
|physical_segno|包含列上数据的段。|
|tupcount|段中总的元组数目。|
|eof|段的有效文件结尾。|
|eof_uncompressed|数据没有被压缩的段的文件结尾。|
|modcount|数据修改操作的计数。|
|state|段的状态。|

### \_\_gp_aovisimap(oid)

该函数返回元组id、段文件、根据可见性映射得到的每个不可见元素的行号。

输入参数为一个追加优化表的id。

通过使用以表名作为参数的函数 \_\_gp\_aovisimap\_name('table_name') 能够获取相同的结果。

|列名|描述|
|:---|:---|
|tid|元组id。|
|segno|段文件的编号。|
|row_num|一个已经被删除或者更新的行的行号。|

### \_\_gp\_aovisimap\_hidden_info(oid)

该函数返回一个追加优化表在段文件中隐藏行和可见元组的数目。

输入参数为追加优化表的 oid。

调用以表名为输入参数的函数 \_\_gp\_aovisimap\_hidden\_info\_name('table_name')能够获取相同的结果。

|列名|描述|
|:---|:---|
|segno|段文件的段号。|
|hidden_tupcount|段中隐藏元组的数目。|
|total_tupcount|段文件中总的元组数目。|

### \_\_gp\_aovisimap_entry(oid)

该函数返回表的每个可见映射的入口信息。

输入参数为一个追加优化表的 oid。

调用以表名为参数的函数 \_\_gp\_aovisimap\_entry\_name('table_name') 能够获取相同的结果。

##### 表 10. \_\_gp\_aovisimap_entry 输出表

|列名|描述|
|:---|:---|
|segno|可见性映射项的段号。|
|first\_row_num|项的第一行行号。|
|hidden_tupcount|在项中的隐藏元组的总数。|
|bitmap|可见性位图的文本表示。|

## <h2 id='topic2-4'> 查看 HashData 服务器日志文件

每个 HashData 的组件（Master、后备Master、主Segment、镜像Segment）都会保存它们主机的服务器日志文件。gp\_log_* 视图家族允许用户发出针对服务器日志文件的SQL查询来查找感兴趣的特定项。使用这些视图需要有超级用户权限。

*   [gp\_log\_command_timings](#topic3-5)
*   [gp\_log_database](#topic3-6)
*   [gp\_log\_master_concise](#topic3-7)
*   [gp\_log_system](#topic3-8)

### <h3 id='topic3-5'> gp\_log\_command_timings

该视图用一个外部表来读取在主机上的日志文件同时报告在数据库会话中 SQL 命令的执行时间。使用该视图需要拥有超级用户权限。

##### 表 11. gp\_log\_command_timings 视图

|列名|描述|
|:---|:---|
|logsession|会话标识符（带有“con”前缀）。|
|logcmdcount|一个会话中的命令数（带有“cmd”前缀）。|
|logdatabase|数据库名。|
|loguser|数据库用户名。|
|logpid|进程id（带有前缀“p”）|
|logtimemin|该命令的第一条日志信息的时间。|
|logtimemax|该命令最后一条信息日志信息的时间。|
|logduration|语句从开始到结束的持续时间。|

### <h3 id='topic3-6'> gp\_log_database

该视图使用一个外部表来读取整个 HashData 系统（主机，段，镜像）的服务器日志文件和列出与当前数据库关联的日志的入口。相关联的日志的入口能够使用会话 id（logssesion）和命令 id（logcmdcount）来标识。使用这个视图需要超级用户的权限。

##### 表 12. gp\_log_database 视图

|列名|描述|
|:---|:---|
|logtime|日志信息的时间戳。|
|loguser|数据库用户名。|
|logdatabase|数据库名。|
|logpid|相关联的进程id（以“p”为前缀）。|
|logthread|相关联的线程计数（以“th”为前缀）。|
|loghost|Segment或者Master主机名。|
|logport|Segment或者Master端口。|
|logsessiontime|会话连接打开的时间。|
|logtransaction|全局事务ID。|
|logsession|会话标识符（以“con”为前缀）。|
|logcmdcount|一个会话中的命令编号（以“cmd”为前缀）。|
|logsegment|Segment内容的标识符（基础以“seg”为前缀，镜像以“mir”为前缀）。Master总是有一个-1的内容ID。|
|logslice|切片id（正在被执行的查询计划一部分）。|
|logdistxact|分布式式事务ID。|
|loglocalxact|本地事务ID。|
|logsubxact|子事务ID。|
|logseverity|LOG、ERROR、FATAL、 PANIC、DEBUG1 或者 DEBUG2。|
|logstate|与日志消息相关的 SQL 状态编码。|
|logmessage|日志或者错误消息文本。|
|logdetail|与错误消息相关的详细消息文本。|
|loghint|与错误消息相关的提示消息文本。|
|logquery|内部产生的查询文本。|
|logquerypos|内部产生的查询文本中的光标索引。|
|logcontext|该消息产生的上下文。|
|logdebug|带有全部细节的查询字符串，方便调试。|
|logcursorpos|查询字符串中的光标索引。|
|logfunction|该消息产生的函数。|
|logfile|该消息产生的日志文件。|
|logline|指明在日志文件产生该消息的行。|
|logstack|与该消息相关的栈追踪的完整文本信息。|

### <h3 id='topic3-7'> gp\_log\_master_concise

该视图使用一个外部表读取来自 Master 日志文件中日志域的一个子集。使用该视图需要超级用户权限。

##### 表 13. gp\_log\_master_concise视图

|列名|描述|
|:---|:---|
|logtime|日志消息的时间戳。|
|logdatabase|数据库的名称。|
|logsession|会话标识符（以“con”为前缀）。|
|logcmdcount|会话中的命令编号（以“cmd”为前缀）。|
|logmessage|日志或者出错消息文本。|

### <h3 id='topic3-8'> gp\_log_system

该视图使用一个外部表来读取来自整个 HashData （Master、Segment、镜像）的服务器日志文件并且列出所有的日志项。相关的日志项可以通过会话 ID（logsession）和命令 ID（logcmdcount）来标识。该视图的使用需要有超级用户权限。

##### 表 14. gp\_log_system视图

|列名|描述|
|:---|:---|
|logtime|日志消息的时间戳。|
|loguser|数据库用户名。|
|logdatabase|数据库名。|
|logpid|相关联的进程id（以“p”为前缀）。|
|logthread|相关联的线程计数（以“th”为前缀）。|
|loghost|Segment或者Master的主机名。|
|logport|Segment或者Master的端口。|
|logsessiontime|会话连接打开的时间。|
|logtransaction|全局事务ID。|
|logsession|会话标识符（以“con”为前缀）。|
|logcmdcount|会话中的命令编号（以“cmd“为前缀）。|
|logsegment|Segment内容标识符（基础以”seg“为标识符，镜像以“mir”为标识符，Master的内容ID总是-1）。|
|logslice|切片ID（正在被执行的查询计划的部分）。|
|logdistxact|分布式事务ID。|
|loglocalxact|本地事务ID。|
|logsubxact|子事务ID。|
|logseverity|LOG、ERROR、FATAL、 PANIC、DEBUG1或者DEBUG2。|
|logstate|和日志消息关联的SQL状态代码。|
|logmessage|日志或者错误消息文本。|
|logdetail|与错误消息关联的详细消息文本。|
|loghint|与错误消息关联的提示消息文本。|
|logquery|内部产生的查询文本。|
|logquerypos|内部产生的查询文本中的光标索引。|
|logcontext|该消息产生的上下文。|
|logdebug|查询字符串，带有完整的细节用于调试。|
|logcursorpos|查询字符串中的光标索引。|
|logfunction|该消息产生的函数。|
|logfile|该消息产生的日志文件。|
|logline|指明在日志文件产生该消息的行。|
|logstack|与该消息关联的跟踪栈的完整文本。|

## <h2 id='topic2-5'> 检查服务器端配置文件

每个 HashData 数据库组件（Master、后备 Master、主 Segment 及镜像 Segment）都有它们自己的服务器配置文件（postgresql.conf）。下面的 gp_toolkit 对象能够用来检查系统中所有的主postgresql.conf 文件中的参数设置：

*   [gp\_param\_setting('parameter_name')](#topic3-9)
*   [gp\_param\_settings\_seg\_value_diffs](#topic3-10)

### <h3 id='topic3-9'> gp\_param\_setting('parameter_name')

该函数接受服务器配置参数的名称作为参数，并且返回 Master 和每个活动 Segment 的 postgresql.conf 值。该函数能够被所有用户访问。

##### 表 15. gp\_param\_setting('parameter_name') 函数

|列名|描述|
|:---|:---|
|paramsegment|Segment内容ID（只显示活动Segment）。Master的内容ID总是为-1。|
|paramname|参数的名字。|
|paramvalue|参数的值。|

#### 示例：

```
SELECT * FROM gp_param_setting('max_connections');
```
### <h3 id='topic3-10'> gp\_param\_settings\_seg\_value_diffs

那些被分类为本地（local）（表示每个 Segment 从其自己的 postgresql.conf 文件中获取参数值）的服务器配置参数，应该在所有 Segment 上做相同的设置。该视图显示了那些不一致的本地参数的设置。那些被认为应该有不同值的参数（例如 port）不包括在内。该视图能够被所有的用户访问。

##### 表 16. gp\_param\_settings\_seg\_value_diffs 视图

|列名|描述|
|:---|:---|
|psdname|参数名。|
|psdvalue|参数值。|
|psdcount|拥有该值的 Segment 的数目。|

## <h2 id='topic2-6'> 检查失效的 Segment

[gp\_pgdatabase_invalid](#topic3-11) 视图能够被用来检查状态为 “down” 的 Segment。


### <h3 id='topic3-11'> gp\_pgdatabase_invalid

该视图显示系统目录中被标记为 down 的 Segment 的信息。该视图能够被所有的用户访问。

##### 表 17. gp\_pgdatabase_invalid 视图

|列名|描述|
|:---|:---|
|pgdbidbid|Segment的dbid。每个Segment有唯一的dbid。|
|pgdbiisprimary|Segment当前是否为主（活动）Segment？（t或者f）|
|pgdbicontent|该Segment的内容ID。一个主Segment和镜像Segment将有相同的内容ID。|
|pgdbivalid|该Segment是否为up和有效？（t或者f）|
|pgdbidefinedprimary|在系统初始化时，该Segment是否已经被指定为主Segment角色？（t或者f）|

## <h2 id='topic2-7'> 检查资源队列的活动和状态

使用资源队列的目的是限制任何给定时刻系统中的活跃查询的数量，从而避免使得一些系统资源（例如，内存、CPU、磁盘I/O）耗尽。所有的数据库用户都被指定了一个资源队列，每个由用户提交的语句在它们能够运行前，首先在资源队列限制上进行评估。gp\_resq_* 视图族可以被用来通过当前已被提交给系统的语句的相应资源队列检查其状态。注意那些由超级用户发出的语句会从资源队列中豁免。

*   [gp\_resq_activity](#topic3-12)
*   [gp\_resq\_activity\_by_queue](#topic3-13)
*   [gp\_resq\_priority_statement](#topic3-14)
*   [gp\_resq_role](#topic3-15)
*   [gp\_resqueue_status](#topic3-16)

### <h3 id='topic3-12'> gp\_resq_activity

对于那些有活动负载的资源队列，该视图为每一个通过资源队列提交的活动语句显示一行。该视图能够被所有用户访问。

##### 表 18. gp\_resq_activity 视图

|列名|描述|
|:---|:---|
|resqprocpid|指定给该语句的进程ID（在Master上）。|
|resqrole|用户名。|
|resqoid|资源队列对象ID。|
|resqname|资源队列名。|
|resqstart|语句被发送到系统的时间。|
|resqstatus|语句的状态：正在执行、等待或者取消。|

### <h3 id='topic3-13'> gp\_resq\_activity\_by_queue

对于有活动负载的资源队列，该视图显示了队列活动的总览。该视图能够被所有用户访问。

##### 表 19. gp\_resq\_activity\_by_queue 列

|列名|描述|
|:---|:---|
|resqoid|资源队列对象ID。|
|resqname|资源队列名。|
|resqlast|最后一个语句发送到队列的时间。|
|resqstatus|最后一个语句的状态：正在执行、等待或者取消。|
|resqtotal|该队列总的语句数。|

### <h3 id='topic3-14'> gp\_resq\_priority_statement

该视图为当前运行在 HashData 数据库系统上的所有语句显示资源队列优先级、会话 ID 以及其他信息。该视图能够被所有用户访问。

##### 表 20. gp\_resq\_priority_statement 视图

|列名|描述|
|:---|:---|
|rqpdatname|该会话连接到的数据库的名称。|
|rqpusename|发出该语句的用户。|
|rqpsession|会话ID。|
|rqpcommand|该会话中的语句编号（命令ID和会话ID唯一标识一条语句）。|
|rqppriority|语句的资源队列优先级（MAX、HIGH、MEDIUM、LOW）。|
|rqpweight|一个与该语句的优先级相关的整数值。|
|rqpquery|语句的查询文本。|

### <h3 id='topic3-15'> gp\_resq_role

该视图显示与角色相关的资源队列。该视图能够被所有用户访问。

##### 表 21. gp\_resq_role 视图

|列名|描述|
|:---|:---|
|rrrolname|角色（用户）名。|
|rrrsqname|指定给角色的资源队列名。如果一个角色没有被明确地指定一个资源队列，那么它将会在默认资源队列 pg_default 中。|

### <h3 id='topic3-16'> gp\_resqueue_status

该视图允许管理员查看到一个负载管理资源队列的状态和活动。它显示在系统中一个特定的资源队列有多少查询正在等待执行以及有多少查询当前是活动的。

##### 表 22. gp\_resqueue_status 视图

|列名|描述|
|:---|:---|
|queueid|资源队列的ID。|
|rsqname|资源队列名。|
|rsqcountlimit|一个资源队列的活动查询数的阈值。如果值为-1则意味着没有限制。|
|rsqcountvalue|资源队列中当前正在被使用的活动查询槽的数量。|
|rsqcostlimit|资源队列的查询代价阈值。如果值为-1则意味着没有限制。|
|rsqcostvalue|当前在资源队列中所有语句的总代价。|
|rsqmemorylimit|资源队列的内存限制。|
|rsqmemoryvalue|当前资源队列中所有语句使用的总内存。|
|rsqwaiters|当前在资源队列中处于等待状态的语句数目。|
|rsqholders|资源队列中当前正在系统上运行的语句数目。|

## <h2 id='topic2-8'> 检查查询磁盘溢出空间使用

gp\_workfile\_* 视图显示当前所有使用磁盘溢出空间的查询的信息。如果没有充足的内存来执行查询， HashData 会在磁盘上创建工作文件。该信息能够别用来排查问题以及调优查询。在这些视图中的信息也能够被用来指定 HashData 数据库配置参数 gp\_workfile\_limit\_per_query 和 gp_workfile_limit_per_segment 的值。

*   [gp\_workfile_entries](#topic3-17)
*   [gp\_workfile\_usage\_per_query](#topic3-18)
*   [gp\_workfile\_usage\_per_segment](#topic3-19)

### <h3 id='topic3-17'> gp\_workfile_entries

该视图为当前在Segment上使用磁盘空间作为工作文件的操作符包含一行。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的数据库的信息。

##### 表 23. gp\_workfile_entries

|列名|类型|参考|描述|
|:---|:---|:---|:---|
|command_cnt|integer||查询的命令ID。|
|content|smallint||一个Segment实例的内容标识符。|
|current_query|text||当前进程正在执行的查询。|
|datname|name||HashData 数据库名。|
|directory|text||工作文件的路径。|
|optype|text||创建工作文件的查询操作符类型。|
|procpid|integer||服务器进程的进程ID 。|
|sess_id|integer||会话ID 。|
|size|bigint||以字节为单位的工作文件的大小。|
|numfiles|bigint||被创建文件的数目。|
|slice|smallint||查询计划切片。查询计划正在被执行的部分。|
|state|text||创建工作文件的查询的状态。|
|usename|name||角色名。|
|workmem|integer||分配给操作符的内存量（以KB为单位）。|

### <h3 id='topic3-18'> gp\_workfile\_usage\_per_query

该视图对当前时间每个段上的每个使用磁盘空间作为工作文件的查询包含一行。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的数据库的信息。

##### 表 24. gp\_workfile\_usage\_per_query

|列名|类型|参考|描述|
|:---|:---|:---|:---|
|command_cnt|integer||查询的命令ID。|
|content|smallint||一个Segment实例的内容标识符。|
|current_query|text||当前进程正在执行的查询。|
|datname|name|| HashData 数据库名。|
|procpid|integer||服务器进程的进程ID 。|
|sess_id|integer||会话ID 。|
|size|bigint||以字节为单位的工作文件的大小。|
|numfiles|bigint||被创建文件的数目。|
|state|text||创建工作文件的查询的状态。|
|usename|name||角色名。|

### <h3 id='topic3-19'> gp\_workfile\_usage\_per_segment

这个视图为每个Segment包含一行。每一行显示当前在该Segment被用于工作文件的磁盘空间总量。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的数据库的信息。

##### 表 25. gp\_workfile\_usage\_per_segment

|列名|类型|参考|描述|
|:---|:---|:---|:---|
|content|smallint||一个Segment实例的内容标识符。|
|size|bigint||一个Segment上工作文件的总大小。|
|numfiles|bigint||已经创建的文件数目。|

## <h2 id='topic2-9'> 浏览用户和组（角色）

将用户（角色）分组在一起来简化对象特权的管理常常会很方便：这样，特权能够对一个组进行整体的分配和回收。在 HashData 数据库中，这可以通过创建一个代表组的角色来实现，然后授予组角色的成员关系给每个单独的用户角色。

[gp\_roles\_assigned](#topic3-20) 视图能够用来查看系统中所有的角色以及指派给它们的成员（如果该角色同时也是一个组角色）。


### <h3 id='topic3-20'> gp\_roles\_assigned

该视图显示系统中所有的角色以及指派给它们的成员（如果该角色同时也是一个组角色）。该视图能够被所有用户访问。

##### 表 26. gp\_roles\_assigned 视图

|列名|描述|
|:---|:---|
|raroleid|角色对象ID。如果该角色有成员（用户），它将被认为是一个组角色。|
|rarolename|角色（用户或者组）名。|
|ramemberid|该角色的一个成员角色的角色对象ID 。|
|ramembername|该角色的一个成员角色的名称。|

## <h2 id='topic2-10'> 检查数据库对象的大小和磁盘空间

gp\_size\_* 视图族能被用来确定分布式 HashData 数据库、方案、表或者索引的磁盘空间使用。下面的视图计算一个对象在所有主 Segment（镜像没有包括在尺寸计算中）上的总尺寸。

*   [gp\_size\_of\_all\_table\_indexes](#topic3-21)
*   [gp\_size\_of\_database](#topic3-22)
*   [gp\_size\_of\_index](#topic3-23)
*   [gp\_size\_of\_partition\_and\_indexes\_disk](#topic3-24)
*   [gp\_size\_of\_schema\_disk](#topic3-25)
*   [gp\_size\_of\_table\_and\_indexes\_disk](#topic3-26)
*   [gp\_size\_of\_table\_and\_indexes\_licensing](#topic3-27)
*   [gp\_size\_of\_table\_disk](#topic3-28)
*   [gp\_size\_of\_table\_uncompressed](#topic3-29)
*   [gp\_disk\_free](#topic3-30)

表和索引的尺寸视图通过对象 ID（不是名字）列出关系。为了通过名字来检查一个表或者索引的尺寸，用户必须在 pg_class 中查看查看关系名（relname）。例如：

```
SELECT relname as name, sotdsize as size, sotdtoastsize as 
toast, sotdadditionalsize as other 
FROM gp_size_of_table_disk as sotd, pg_class 
WHERE sotd.sotdoid=pg_class.oid ORDER BY relname;
```

### <h3 id='topic3-21'> gp\_size\_of\_all\_table\_indexes

该视图显示了一个表上所有索引的总尺寸。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的关系。

##### 表 27. gp\_size\_of\_all\_table\_indexes 视图

|列名|描述|
|:---|:---|
|soatioid|表的对象ID 。|
|soatisize|所有表索引的总尺寸（以字节为单位）。|
|soatischemaname|模式名。|
|soatitablename|表名。|

### <h3 id='topic3-22'> gp\_size\_of\_database

该视图显示数据库的总尺寸。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的数据库。

##### 表 28. gp\_size\_of\_database 视图

|列名|描述|
|:---|:---|
|sodddatname|数据库名。|
|sodddatsize|数据库的尺寸（以字节为单位）。|

### <h3 id='topic3-23'> gp\_size\_of\_index

该视图显示一个索引的总尺寸。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的关系。

##### 表 29. gp\_size\_of\_index 视图

|列名|描述|
|:---|:---|
|soioid|索引的对象ID 。|
|soitableoid|索引所属表的对象ID 。|
|soisize|索引的尺寸（以字节为单位）。|
|soiindexschemaname|索引的方案名。|
|soiindexname|索引名。|
|soitableschemaname|表的方案名。|
|soitablename|表名。|

### <h3 id='topic3-24'> gp\_size\_of\_partition\_and\_indexes\_disk

该视图显示分区子表及其索引在磁盘上的尺寸。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的关系。

##### 表 30. gp\_size\_of\_partition\_and\_indexes\_disk 视图

|列名|描述|
|:---|:---|
|sopaidparentoid|父表的对象ID 。|
|sopaidpartitionoid|分区表的对象ID 。|
|sopaidpartitiontablesize|分区表的尺寸（以字节为单位）。|
|sopaidpartitionindexessize|在该分区上，所有索引的总尺寸。|
|Sopaidparentschemaname|父表所在的方案名。|
|Sopaidparenttablename|父表名。|
|Sopaidpartitionschemaname|分区所在的方案名。|
|sopaidpartitiontablename|分区表名。|

### <h3 id='topic3-25'> gp\_size\_of\_schema\_disk

该视图显示当前数据库中 public 方案和用户创建方案的方案尺寸。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的方案。

##### 表 31. gp\_size\_of\_schema\_disk 视图

|列名|描述|
|:---|:---|
|sosdnsp|方案名。|
|sosdschematablesize|方案中所有表的总尺寸（以字节为单位）。/td> |
|sosdschemaidxsize|方案中所有索引的总尺寸（以字节为单位）。|

### <h3 id='topic3-26'> gp\_size\_of\_table\_and\_indexes\_disk

该视图显示表及其索引在磁盘上的大小。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的关系。

##### 表 32. gp\_size\_of\_table\_and\_indexes\_disk 视图

|列名|描述|
|:---|:---|
|sotaidoid|父表的对象ID 。|
|sotaidtablesize|表在磁盘上的尺寸。|
|sotaididxsize|表上所有索引的总尺寸。|
|sotaidschemaname|方案名。|
|sotaidtablename|表名。|

### <h3 id='topic3-27'> gp\_size\_of\_table\_and\_indexes\_licensing

该视图显示表及其索引的总尺寸，用于特许目的。使用该视图需要超级用户权限。

##### 表 33. gp\_size\_of\_table\_and\_indexes\_licensing 视图

|列名|描述|
|:---|:---|
|sotailoid|表的对象ID。|
|sotailtablesizedisk|表的总磁盘尺寸。|
|sotailtablesizeuncompressed|如果表是一个压缩的追加优化表，显示未压缩时的尺寸（以字节为单位）。|
|sotailindexessize|表中所有索引的总尺寸。|
|sotailschemaname|方案名。|
|sotailtablename|表名。|

### <h3 id='topic3-28'> gp\_size\_of\_table\_disk

该视图显示一个表在磁盘上的尺寸。该视图能够被所有的用户访问，但是非超级用户只能看到他们有权访问的表。

##### 表 34. gp\_size\_of\_table\_disk 视图

|列名|描述|
|:---|:---|
|sotdoid|表的对象ID 。|
|sotdsize|表的尺寸（以字节为单位）。只考虑主表尺寸。其中并未包括辅助对象，例如超尺寸（toast）属性或者AO表的额外存储对象。|
|sotdtoastsize|TOAST表（超尺寸属性存储）的尺寸，如果存在TOAST。|
|sotdadditionalsize|反映追加优化（AO）表的段和块目录表尺寸。|
|sotdschemaname|方案名。|
|sotdtablename|表名。|

### <h3 id='topic3-29'> gp\_size\_of\_table\_uncompressed

该视图显示追加优化（AO）表没有压缩时的尺寸。否则，显示表在磁盘上的尺寸。使用该视图需要超级用户权限。

##### 表 35. gp\_size\_of\_table\_uncompressed 视图

|列名|描述|
|:---|:---|
|sotuoid|表对象ID。|
|sotusize|如果是一个压缩的AO表则显示它没有被压缩时的尺寸（以字节为单位）。否则显示该表在磁盘上的尺寸。|
|sotuschemaname|方案名。|
|sotutablename|表名。|

### <h3 id='topic3-30'> gp\_disk_free

该外部表在活动Segment主机上运行df（磁盘空闲）并且报告返回的结果。计算中不包括不活动的镜像Segment。这个外部表的使用要求超级用户权限。

##### 表 36. gp\_disk\_free external 表

|列名|描述|
|:---|:---|
|dfsegment|Segment的内容ID（只显示活动的Segment）。|
|dfhostname|Segment主机的主机名。|
|dfdevice|设备名。|
|dfspace|Segment文件系统中的空闲磁盘空间（以KB为单位）。|

## <h2 id='topic2-11'> 检查不均匀的数据分布

在 HashData 数据库中，所有的表都是分布式的，意味着它们的数据被分布在了系统中所有的Segment中。如果数据没有被均匀地分布，那么查询处理性能可能会受到影响。如果一个表有不均匀的数据分布，下面的视图能够帮助诊断：

*   [gp\_skew\_coefficients](#topic3-31)
*   [gp\_skew\_idle\_fractions](#topic3-32)


### <h3 id='topic3-31'> gp\_skew_coefficients

该视图通过计算存储在每个Segment上的数据的变异系数（CV）来显示数据分布倾斜。该视图能够被所有用户访问，但是非超级用户只能看到他们有权访问的表。

##### 表 37. gp\_skew\_coefficients 视图

|列名|描述|
|:---|:---|
|skcoid|表的对象id。|
|skcnamespace|表定义在其中的命名空间。|
|skcrelname|表名。|
|skccoeff|变异系数（CV）计算为标准差除以平均值。它同时考虑了一个数据序列的平均值以及平均值的变化性。值越低，情况越好。值越大表明数据倾斜越严重。|

### <h3 id='topic3-32'> gp\_skew\_idle_fractions

该视图通过计算在表扫描过程中系统空闲的百分比来显示数据分布倾斜，这是一种数据处理倾斜的指示器。该视图能够被所有用户访问，但是非超级用户只能看到他们有权访问的表。

##### 表 38. gp\_skew\_idle_fractions 视图

|列名|描述|
|:---|:---|
|sifoid|表的对象ID。|
|sifnamespace|表被定义在其中的命名空间。|
|sifrelname|表名。|
|siffraction|在一次表扫描过程中系统空闲的百分比，该值是不均匀数据分布或者查询处理倾斜的指示器。例如，一个0.1的值表示有10%的倾斜，0.5的值表示有50%的倾斜等等。如果一个表的倾斜超过10%，就应该评估它的分布策略。|