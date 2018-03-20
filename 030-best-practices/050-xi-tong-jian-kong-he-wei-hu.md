本章介绍日常维护最佳实践以确保 HashData 数据仓库的高可用性和最佳性能。

## 监控

HashData 数据仓库带有一套系统监控工具。

_gp\_toolkit_ 模式包含可以查询系统表、日志和操作环境状态的视图，使用 SQL 命令可以访问这些视图。

_gp\_stats\_missing_ 视图可以显示没有统计信息、需要运行 ANALYZE 的表。

关于 _gpstate_ 和 _gpcheckperf_ 的更多信息，请参考 《HashData 数据仓库工具指南》。关于 _gp\_toolkit_ 模式的更多信息，请参考《HashData 数据仓库参考指南》。

### gpstate

gpstate 工具显示了 HashData 数据仓库的系统状态，包括哪些段数据库 \(Segments\) 宕机，主服务器 \(Master\) 和 Segment 的配置信息（主机、数据目录等），系统使用的端口和 Segments 的镜像信息。

运行 gpstate -Q 列出 Master 系统表中标记为“宕机”的 Segments。

使用 gpstate -s 显示 HashData 数据仓库集群的详细状态信息。

### gpcheckperf

_gpcheckperf_ 工具测试给定主机的基本硬件性能。其结果可以帮助识别硬件问题。它执行下面的检查：

* 磁盘 I/O 测试 - 使用操作系统的 dd 命令读写一个大文件，测试磁盘的 IO 性能。它以每秒多少兆包括读写速度。
* 内存带宽测试 - 使用 STREAM 基准程序测试可持续的内存带宽。
* 网络性能测试 - 使用 _gpnetbench_ 网络基准程序（也可以用 _netperf_ ）测试网络性能。测试有三种模式：并行成对测试（-r N）,串行成对测试（-r n），全矩阵测试（-r M）。测试结果包括传输速率的最小值、最大值、平均数和中位数。

运行 _gpcheckperf_ 时数据库必须停止。如果系统不停止，即使没有查询， _gpcheckperf_ 的结果也可能不精确。

_gpcheckperf_ 需要在待测试性能的主机间建立可信无密码SSH连接。它会调用 _gpssh_ 和 _gpscp_ ，所以这两个命令必须在系统路径 PATH 中。可以逐个指定待测试的主机（-h host1 -h host2 …）或者使用 -f hosts\_file，其中 hosts\_file 是包含待测试主机信息的文件。如果主机有多个子网，则为每个子网创建一个主机文件，以便可以测试每个子网。

默认情况下， _gpcheckperf_ 运行磁盘 I/O 测试、内存测试和串行成对网络性能测试。对于磁盘测试，必须使用 -d 选项指定要测试的文件系统路径。下面的命令测试文件 subnet\_1\_hosts 中主机的磁盘和内存性能：

```
$ gpcheckperf -f subnet_1_hosts -d /data1 -d /data2 -r ds
```

-r 选项指定要运行的测试：磁盘 IO（d），内存带宽（s），网络并行成对测试（N），网络串行成对测试（n），网络全矩阵测试（M）。只能选择一种网络测试模式。更多信息，请参考《HashData 数据仓库参考指南》。

### 使用操作系统工具监控

下面的 Linux/Unix 工具可用于评估主机性能：

* iostat 监控段数据库 \(Segments\) 的磁盘活动
* top 显示操作系统进程的动态信息
* vmstate 显示内存使用情况的统计信息

可以使用 gpssh 在多个主机上运行这些命令。

### 最佳实践

* 实现《HashData 数据仓库管理员指南》中推荐的监控和维护任务。
* 安装前运行 _gpcheckperf_ ，此后周期性运行 _gpcheckperf_ ，并保存每次的结果，以用于比较系统随着时间推移的性能变化。
* 使用一切可用的工具来更好地理解系统在不同负载下的行为。
* 检查任何异常事件并确定原因。
* 通过定期运行解释计划监控系统查询活动，以确保查询处于最佳运行状态。
* 检查查询计划，以确定是否按预期使用了索引和进行了分区裁剪。

### 额外信息

* 《HashData 数据仓库工具指南》中 _gpcheckperf_
* 《HashData 数据仓库管理员指南》中“监控和维护任务建议”
* Sustainable Memory Bandwidth in Current High Performance Computers. John D. McCalpin. Oct 12, 1995.
* 关于 netperf，可参考 [www.netperf.org](https://hewlettpackard.github.io/netperf/)，需要在每个待测试的主机上安装 netperf。 参考 gpcheckperf 指南获的更多信息。

## 更新统计信息

良好查询性能的最重要前提是精确的表数据统计信息。使用 ANALYZE 语句更新统计信息后，优化器可以选取最优的查询计划。分析完表数据后，相关统计信息保存在系统表中。如果系统表存储的信息过时了，优化器可能生成低效的计划。

### 选择性统计

不带参数运行 ANALYZE 会更新数据库中所有表的统计信息。这可能非常耗时，不推荐这样做。当数据发生变化时，建议对变化的表进行 ANALYZE。

对大表执行 ANALYZE 可能较为耗时。如果对大表的所有列运行 ANALYZE 不可行，则使用 ANALYZE table\(column, …\) 仅为某些字段生成统计信息。确保包括关联、WHERE 子句、SORT 子句、GROUP BY 子句、HAVING 子句中使用的字段。

对于分区表，可以只 ANALYZE 发生变化的分区，譬如只分析新加入的分区。注意可以 ANALYZE 分区表的父表或者最深子表。统计数据和用户数据一样，存储在最深子表中。中间层子表既不保存数据，也不保存统计信息，因而 ANALYZE 它们没有效果。可以从系统表 pg\_partitions 中找到分区表的名字。

```
SELECT partitiontablename from pg_partitions WHERE tablename='parent_table;
```

### 提高统计数据质量

需要权衡生成统计信息所需时间和统计信息的质量（或者精度）。

为了在合理的时间内完成大表的分析，ANALYZE 对表内容随机取样，而不是分析每一行。调整配置参数 _default\_statistics\_target_ 可以改变采样率。其取值范围为 1 到 1000；默认是 25。 默认 _default\_statistics\_target_ 影响所有字段。较大的值会增加 ANALYZE 的时间，然而会提高优化器的估算质量。对于那些数据模式不规则的字段更是如此。可以在主服务器 \(Master\) 的会话中设置该值，但是需要重新加载。

配置参数 _gp\_analyze\_relative\_error_ 会影响为确定字段基数而收集的统计信息的采样率。例如 0.5 表示可以接受 50% 的误差。默认值是 0.25。使用 _gp\_analyze\_relative\_error_ 设置表基数估计的可接受的相对误差。如果统计数据不能产生较好的基数估计，则降低相对误差率（接受更少的错误）以采样更多的行。然而不建议该值低于 0.1，否则会大大延长 ANALYZE 的时间。

### 运行 ANALYZE

运行 ANALYZE 的时机包括：

* 加载数据后
* CREATE INDEX 操作后
* 影响大量数据的 INSERT、UPDATE 和 DELETE 操作后

ANALYZE 只需对表加读锁，所以可以与其他数据库操作并行执行，但是在数据加载和执行 INSERT/UPDATE/DELETE/CREATE INDEX 操作时不要运行 ANALYZE。

### 自动统计

配置参数 _gp\_autostats\_mode_ 和 _gp\_autostats\_on\_change\_threshold_ 确定何时触发自动分析操作。当自动统计数据收集被触发后，planner 会自动加入一个 ANALYZE 步骤。

_gp\_autostats\_mode_ 默认设置是 on\_no\_stats ，如果表没有统计数据，则 CREATE TABLE AS SELECT, INSERT, COPY 操作会触发自动统计数据收集。

如果 _gp\_autostats\_mode_ 是 on\_change，则仅当更新的行数超过 _gp\_autostats\_on\_change\_threshold_ 定义的阈值时才触发统计信息收集，其默认值是 2147483647。这种模式下，可以触发自动统计数据收集的操作有：CREATE TABLE AS SELECT, UPDATE, DELETE, INSERT 和 COPY。

设置 _gp\_autostats\_mode_ 为 none 将禁用自动统计信息收集功能。

对分区表，如果从最顶层的父表插入数据不会触发统计信息收集。如果数据直接插入到叶子表（实际存储数据的表），则会触发统计信息收集。

## 管理数据库膨胀

HashData 数据仓库的堆表使用 PostgreSQL 的多版本并发控制（MVCC）的存储实现方式。删除和更新的行仅仅是逻辑删除，其实际数据仍然存储在表中，只是不可见。这些删除的行，也称为过期行，由空闲空间映射表（FSM, Free Space Map）记录。VACUUM 标记这些过期的行为空闲空间，并可以被后续插入操作重用。

如果某个表的 FSM 不足以容纳所有过期的行，VACUUM 命令无法回收溢出 FSM 的过期行空间。这些空间只能由 VACUUM FULL 回收，VACUUM FULL 会锁住整个表，逐行拷贝到文件头部，并截断 （TRUNCATE） 文件。对于大表，这一操作非常耗时。仅仅建议对小表执行这种操作。如果试图杀死 VACUUM FULL 进程，系统可能会被破坏。

> 注意：大型 UPDATE 和 DELETE 操作之后务必运行 VACUUM，避免运行 VACUUM FULL。

如果出现 FSM 溢出，需要回收空间，则建议使用 CREATE TABLE…AS SELECT 命令拷贝数据到新表，删除原来的表，然后重命名新表为原来的名字。

频繁更新的表会有少量过期行和空闲空间，空闲空间可被新加入的数据重用。但是当表变得非常大，而可见数据只占整体空间的一小部分，其余空间被过期行占用时，称之为膨胀（bloated）。膨胀表占用更多空间，需要更多 I/O，因而会降低查询效率。

膨胀会影响堆表、系统表和索引。

周期性运行 VACUUM 可以避免表增长的过大。如果表变得非常膨胀，必须使用 VACUUM FULL语句（或者其方法）精简该表。如果大表变得非常膨胀，则建议使用消除数据膨胀（后续章节）中介绍的方法消除膨胀的表。

> 警告：切勿运行 VACUUM FULL <database\_name>; 或者对大表运行 VACUUM FULL。 运行 VACUUM 时，堆表的过期行被加入到共享的空闲空间映射表中。FSM 必须足够容纳过期行。如果不够大，则溢出 FSM 的空间不能被 VACUUM 回收。必须使用 VACUUM FULL 或者其他方法回收溢出空间。

定期性运行 VACUUM 可以避免 FSM 溢出。表越膨胀，FSM 就需要记录越多的行。对于非常大的具有很多对象的数据库，需要增大 FSM 以避免溢出。

配置参数 _max\_fsm\_pages_ 设置在共享空闲空间映射表中被 FSM 跟踪的磁盘页最大数目。一页占用 6 个字节共享空间。默认值是 200,000。

配置参数 _max\_fsm\_relations_ 设置在共享空间映射表中被 FSM 跟踪的表的最大数目。该值需要大于数据库中堆表、索引和系统表的总数。每个段数据库的每个表占用 60 个字节的共享内存。默认值是 1000。

更详细的信息，请参考《HashData 数据仓库参考指南》。

### 检测数据膨胀

ANALYZE 收集的统计信息可用于计算存储一个表所期望的磁盘页数。期望的页数和实际页数之间的差别是膨胀程度的一个度量。gp\_toolkit 模式的 gp\_bloat\_diag 视图通过比较期望页数和实际页数的比例识别膨胀的表。使用这个视图前，确保数据库的统计信息是最新的，然后运行下面的 SQL：

```
gpadmin=# SELECT * FROM gp_toolkit.gp_bloat_diag;
 bdirelid | bdinspname | bdirelname | bdirelpages | bdiexppages |
 bdidiag
---------+------------+------------+-------------+-------------
+------------
    21488 |     public |         t1 |          97 |           1 | significant amount
of bloat suspected
(1 row)
```

结果中包括中度或者严重膨胀的表。实际页数与期望页数之比位于 4 和 10 之间是中度膨胀，大于 10 为严重膨胀。

视图 gp\_toolkit.gp\_bloat\_expected\_pages 列出每个数据库对象实际使用的页数和期望使用的磁盘页数。

```
gpadmin=# SELECT * FROM gp_toolkit.gp_bloat_expected_pages LIMIT 5;
 btdrelid | btdrelpages | btdexppages
---------+-------------+-------------
    10789 |           1 |           1
    10794 |           1 |           1
    10799 |           1 |           1
     5004 |           1 |           1
     7175 |           1 |           1
(5 rows)
```

btdrelid 是表的对象 ID。btdrelpages 字段表示表适用的实际页数；bdtexppages 字段表示期望的页数。注意，这些数据基于统计信息，确保表发生变化后运行 ANALYZE。

### 消除数据膨胀表

VACUUM 命令将过期行加入到空闲空间映射表中以便以后重用。如果对频繁更新的表定期运行 VACUUM，过期行占用的空间可以被及时的回收并重用，避免表变得非常大。同样重要的是在 FSM 溢出前运行 VACUUM。对更新异常频繁的表，建议至少每天运行一次 VACUUM 以防止表变得膨胀。

> 警告：如果表严重膨胀，建议运行 VACUUM 前运行 ANALYZE。因为 ANALYZE 使用块级别抽样，如果一个表中无效/有效行的块的比例很高，则 ANALYZE 会设置系统表 pg\_class 的 reltuples 字段为不精确的值或者 0，这会导致查询优化器不能生成最优查询。VACUUM 命令设置的数值更精确，如果在 ANALYZE 之后运行可以修正不精确的行数估计。

如果一个表膨胀严重，运行 VACUUM 命令是不够的。对于小表，可以通过 VACUUM FULL 回收溢出 FSM  的空间，降低表的大小。然而 VACUUM FULL 操作需要 ACCESS EXCLUSIVE 锁，可能需要非常久或者不可预测的时间才能完成。注意，消除大表膨胀的每种方法都是资源密集型操作，只有在极端情况下才使用。

第一种方法是创建大表拷贝，删掉原表，然后重命名拷贝。这种方法使用 CREATE TABLE AS SELECT 创建新表，例如：

```
gpadmin=# CREATE TABLE mytable_tmp AS SELECT * FROM mytable;
gpadmin=# DROP TABLE mytable;
gpadmin=# ALTER TABLE mytabe_tmp RENAME TO mytable;
```

第二种消除膨胀的方法是重分布。步骤为：

1. 记录表的分布键

2. 修改表的分布策略为随机分布

	```
	ALTER TABLE mytable SET WITH (REORGANIZE=false)
	DISTRIBUTED randomly;
	```

	此命令修改表的分布策略，但是不会移动数据。这个命令会瞬间完成。

3. 改回原来的分布策略

	```
	ALTER TABLE mytable SET WITH (REORGANIZE=true)
	DISTRIBUTED BY (<original distribution columns>);
	```

	此命令会重新分布数据。因为和原来的分布策略相同，所以仅会在同一个段数据库上重写数据，并去掉过期行。

### 消除系统表膨胀

HashData 数据仓库系统表也是堆表，因而也会随着时间推移而变得膨胀。随着数据库对象的创建、修改和删除，系统表中会留下过期行。

使用 gpload 加载数据会造成膨胀，因为它会创建并删除外部表。（建议使用 gpfdist 加载数据）。

### 系统表膨胀

会拉长表扫描所需的时间，例如生成解释计划时。系统表需要频繁扫描，如果它们变得膨胀，那么系统整体性能会下降。

建议每晚 \(至少每周\) 对系统表运行 VACUUM。

下面的脚本对系统表运行 VACUUM ANALYZE。

```
#!/bin/bash
DBNAME="<database_name>"
VCOMMAND="VACUUM ANALYZE"psql -tc "select '$VCOMMAND' || ' pg_catalog.' || relname || ';'FROM pg_class a, pg_namespace b \
where a.relnamespace=b.oid andb.nspname='pg_catalog' and a.relkind='r'"
$DBNAME | psql -a $DBNAME
```

如果系统表变得异常膨胀，则必须执行一次集中地系统表维护操作。对系统表不能使用 CREATE TABLE AS SELECT 和上面介绍的重分布方法消除膨胀，而只能在计划的停机期间，运行 VACUUM FULL。在这个期间，停止系统上的所有系统表操作，VACUUM FULL 会对系统表使用排它锁。定期运行 VACUUM 可以防止这一代价高昂的操作。

### 消除索引表膨胀

VACUUM 命令仅恢复数据表的空间，要恢复索引表的空间，使用 REINDEX 重建索引。 使用 REINDEX table\_name 重建一个表的所有索引；使用 REINDEX index\_name 重建某个索引。

### 消除 AO 表膨胀

AO 表的处理方式和堆表完全不同。尽管 AO 表可以更新和删除，然而 AO 表不是为此而优化的，建议对 AO 表避免使用更新和删除。如果 AO 表用于一次加载/多次读取的业务，那么 AO 表的 VACUUM 操作几乎会立即返回。

如果确实需要对 AO 表执行 UPDATE 或者 DELETE，则过期行会记录在辅助的位图表中，而不是像堆表那样使用空闲空间映射表。使用 VACUUM 回收空间。对含有过期行的 AO 表运行 VACUUM 会通过重写来精简整张表。如果过期行的百分比低于配置参数 gp\_appendonly\_compaction\_threshold , 则不会执行任何操作，默认值是 10（10%）。每个段数据库 \(Segment\) 上都会检查该值，所以有可能某些 Segment 上执行空间回收操作，而另一些 Segment 不执行任何操作。可以通过设置 gp\_appendonly\_compaction 参数为 no 禁止 AO 表空间回收。

## 监控日志文件

了解系统日志文件的位置和内容，并定期的监控这些文件。

下标列出了 HashData 各种日志文件的位置。文件路径中，date 是格式为 YYYYMMDD 的日期， instance 是当前实例的名字，n 是 Segment 号。

| 路径 | 描述 |
| :--- | :--- |
| /var/gpadmin/gpadminlogs/\* | 很多不同类型的日志文件 |
| /var/gpadmin/gpadminlogs/gpstart\_date.log | 启动日志 |
| /var/gpadmin/gpadminlogs/gpstop\_date.log | 停止服务器日志 |
| /var/gpadmin/gpadminlogs/gpsegstart.py\_idb\*gpadmin\_date.log | Segment 启动日志 |
| /var/gpadmin/gpadminlogs/gpsegstop.py\_idb\*gpadmin\_date.log | Segment 停止日志 |
| /var/gpdb/instance/dataMaster/gpseg-1/pg\_log/startup.log | 实例启动日志 |
| /var/gpdb/instance/dataMaster/gpseg-1/gpperfmon/logs/gpmon.\*.log | Gpperfmon 日志 |
| /var/gpdb/instance/datamirror/gpseg{n}/pg\_log/.\*csv | 镜像 Segment 日志 |
| /var/gpdb/instance/dataprimary/gpseg{n}/pg\_log/.\*csv | 主 Segment 日志 |
| /var/log/messages | Linux 系统日志 |

首先使用 gplogfilter -t\(–trouble\) 从 Master 日志中搜索 ERROR:, FATAL:, PANIC: 开头的消息。WARNING 开头的消息也可能提供有用的信息。

若需搜索段数据库（Segment）日志，从主服务器（Master）上使用 gpssh 连接到 Segment 上，然后使用 gplogfilter 工具搜索消息。可以通过 Segment\_id 识别是哪个 Segment 的日志。

配置参数 _log\_rotation\_age_ 控制什么时候会创建新的日志文件。默认情况下，每天创建一个新的日志文件。

