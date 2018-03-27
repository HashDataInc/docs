

# 分布

选择能够均匀分布数据的分布键对 HashData 数据仓库非常重要。在大规模并行处理无共享环境中，查询的总体响应时间取决于所有段数据库的完成时间。集群的最快速度与最慢的那个段数据库一样。如果存在严重数据倾斜现象，那么数据较多的段数据库响应时间将更久。每个段数据库最好有数量接近的数据，处理时间也相似。如果一个段数据库处理的数据显著比其他段多，那么性能会很差，并可能出现内存溢出错误。

确定分布策略时考虑以下最佳实践：

* 为所有表要么明确地指明其分布字段，要么使用随机分布。不要使用默认方式。
* 理想情况下，使用能够将数据均匀分布到所有段数据库上的一个字段做分布键。
* 不要使用常出现在查询的 WHERE 子句中的字段做分布键。
* 不要使用日期或者时间字段做分布键。
* 分布字段的数据要么是唯一值要么基数很大。
* 如果单个字段不能实现数据均匀分布，则考虑使用两个字段做分布键。作为分布键的字段最好不要超过两个。HashData 数据仓库使用哈希进行数据分布，使用更多的字段通常不能得到更均匀的分布，反而耗费更多的时间计算哈希值。
* 如果两个字段也不能实现数据的均匀分布，则考虑使用随机分布。大多数情况下，如果分布键字段超过两个，那么执行表关联时通常需要节点间的数据移动操作（Motion），如此一来和随机分布相比，没有明显优势。

HashData 数据仓库的随机分布不是轮询算法，不能保证每个节点的记录数相同，但是通常差别会小于 10%。

关联大表时最优分布至关重要。关联操作需要匹配的记录必须位于同一段数据库上。如果分布键和关联字段不同，则数据需要动态重分发。某些情况下，广播移动操作（Motion）比重分布移动操作效果好。

## 本地（Co-located）关联

如果所用的哈希分布能均匀分布数据，并导致本地关联，那么性能会大幅提升。本地关联在段数据库内部执行，和其他段数据库没有关系，避免了网络通讯开销，避免或者降低了广播移动操作和重分布移动操作。

为经常关联的大表使用相同的字段做分布键可实现本地关联。本地关联需要关联的双方使用相同的字段（且顺序相同）做分布键，并且关联时所有的字段都被使用。分布键数据类型必须相同。如果数据类型不同，磁盘上的存储方式可能不同，那么即使值看起来相同，哈希值也可能不一样。

## 数据倾斜

数据倾斜是很多性能问题和内存溢出问题的根本原因。数据倾斜不仅影响扫描/读性能，也会影响很多其他查询执行操作符，例如关联操作、分组操作等。

数据初始加载后，验证并保证数据分布的均匀性非常重要；每次增量加载后，都要验证并保证数据分布的均匀性。

下面的查询语句统计每个段数据库上的记录的条数，并根据最大和最小行数计算方差：

```
SELECT 'Example Table' AS "Table Name",
     max(c) AS "Max Seg Rows", min(c) AS "Min Seg Rows",
     (max(c)-min(c))*100.0/max(c) AS "Percentage Difference Between Max & Min"
FROM (SELECT count(*) c, gp_Segment_id FROM facts GROUP BY 2) AS a;
```

_gp\_tooklit_ 模式中有两个视图可以帮助检查倾斜情况：

* 视图 _gp\_toolkit.gp\_skew\_coefficients_ 通过计算每个段数据库所存储数据的变异系数（coefficient of variation, CV）来显示数据倾斜情况。 _skccoeff_ 字段表示变异系数，通过标准偏差除以均值计算而来。它同时考虑了数据的均值和可变性。这个值越小越好，值越高表示数据倾斜越严重。
* 视图 _gp\_toolkit.gp\_skew\_idle\_fractions_ 通过计算表扫描时系统空闲的百分比显示数据分布倾斜情况，这是表示计算倾斜情况的一个指标。 _siffraction_ 字段显示了表扫描时处于空闲状态的系统的百分比。这是数据不均匀分布或者查询处理倾斜的一个指标。例如，0.1 表示 10% 倾斜，0.5 表示 50% 倾斜，以此类推。如果倾斜超过 10%，则需对其分布策略进行评估。

## 计算倾斜（Procedding Skew）

当不均衡的数据流向并被某个或者少数几个段数据库处理时将出现计算倾斜。这常常是 HashData 数据仓库性能和稳定性问题的罪魁祸首。关联、排序、聚合和各种 OLAP 操作中易发生计算倾斜。计算倾斜发生在查询执行时，不如数据倾斜那么容易检测，通常是由于选择了不当的分布键造成数据分布不均匀而引起的。数据倾斜体现在表级别，所以容易检测，并通过选择更好的分布键避免。

如果单个段数据库失败（不是某个节点上的所有段实例），那么可能是计算倾斜造成的。识别计算倾斜目前主要靠手动。首先查看临时溢出文件，如果有计算倾斜，但是没有造成临时溢出文件，则不会影响性能。下面是检查的步骤和所用的命令：

1. 找到怀疑发生计算倾斜的数据库的 OID：

	```
	SELECT oid, datname FROM pg_database;
	```

	例子输出:

	```
	 oid | datname
	-------+-----------
 	17088 | gpadmin
 	10899 | postgres
  	   1 | template1
 	10898 | template0
 	38817 | pws
 	39682 | gpperfmon
	(6 rows)
	```

2. 使用 gpssh 检查所有 Segments 上的溢出文件大小。使用上面结果中的 OID 替换 :

	```
	[gpadmin@mdw?kend]$ gpssh -f ~/hosts -e \
    "du -b /data[1-2]/primary/gpseg*/base/<OID>/pgsql_tmp/*" | \
    grep -v "du -b" | sort | \ awk -F" " '{ arr[$1] = arr[$1] + $2 ; tot = tot +
$2 }; \ END
    { for ( i in arr ) print "Segment node" i, arr, \ "bytes (" arr/(1024**3)"
GB)"; \
 print "Total", tot, "bytes (" tot/(1024**3)" GB)" }' -
	```

	\#\#\# 例子输出:

	```
	Segment node[sdw1] 2443370457 bytes (2.27557 GB)
	Segment node[sdw2] 1766575328 bytes (1.64525 GB)
	Segment node[sdw3] 1761686551 bytes (1.6407 GB)
	Segment node[sdw4] 1780301617 bytes (1.65804 GB)
	Segment node[sdw5] 1742543599 bytes (1.62287 GB)
	Segment node[sdw6] 1830073754 bytes (1.70439 GB)
	Segment node[sdw7] 1767310099 bytes (1.64594 GB)
	Segment node[sdw8] 1765105802 bytes (1.64388 GB)
	Total 14856967207 bytes (13.8366 GB)
	```

	如果不同段数据库的磁盘使用量持续差别巨大，那么需要一进步查看当前执行的查询是否发生了计算倾斜（上面的例子可能不太恰当，因为没有显示出明显的倾斜）。 在很多监控系统中，总是会发生某种程度的倾斜，如果仅是临时性的，则不必深究。


3. 如果发生了严重的持久性倾斜，接下来的任务是找到有问题的查询。上一步命令计算的是整个节点的磁盘使用量。现在我们要找到对应的段数据库(Segment)目录。可以从主节点（Master）上， 也可以登录到上一步识别出的 Segment 上做本操作。下面例子演示从 Master 执行操作。

	本例找的是排序生成的临时文件。然而并不是所有情况都是由排序引起的，需要具体问题具体分析：

	```
[gpadmin@mdw?kend]$ gpssh -f ~/hosts -e \
   "ls -l /data[1-2]/primary/gpseg*/base/19979/pgsql_tmp/*"
   | grep -i sort | sort
	```
	下面是例子输出：

	```
[sdw1] -rw------- 1 gpadmin gpadmin 1002209280 Jul 29 12:48
       /data1/primary/gpseg2/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_19791_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 1003356160 Jul 29 12:48
       /data1/primary/gpseg1/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_19789_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 288718848 Jul 23 14:58
       /data1/primary/gpseg2/base/19979/pgsql_tmp/
pgsql_tmp_slice0_sort_17758_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 291176448 Jul 23 14:58
       /data2/primary/gpseg5/base/19979/pgsql_tmp/
pgsql_tmp_slice0_sort_17764_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 988446720 Jul 29 12:48
       /data1/primary/gpseg0/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_19787_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 995033088 Jul 29 12:48
       /data2/primary/gpseg3/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_19793_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 997097472 Jul 29 12:48
       /data2/primary/gpseg5/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_19797_0001.0
[sdw1] -rw------- 1 gpadmin gpadmin 997392384 Jul 29 12:48
       /data2/primary/gpseg4/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_19795_0001.0
[sdw2] -rw------- 1 gpadmin gpadmin 1002340352 Jul 29 12:48
       /data2/primary/gpseg11/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_3973_0001.0
[sdw2] -rw------- 1 gpadmin gpadmin 1004339200 Jul 29 12:48
       /data1/primary/gpseg8/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_3967_0001.0
[sdw2] -rw------- 1 gpadmin gpadmin 989036544 Jul 29 12:48
       /data2/primary/gpseg10/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_3971_0001.0
[sdw2] -rw------- 1 gpadmin gpadmin 993722368 Jul 29 12:48
       /data1/primary/gpseg6/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_3963_0001.0
[sdw2] -rw------- 1 gpadmin gpadmin 998277120 Jul 29 12:48
       /data1/primary/gpseg7/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_3965_0001.0
[sdw2] -rw------- 1 gpadmin gpadmin 999751680 Jul 29 12:48
       /data2/primary/gpseg9/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_3969_0001.0
[sdw3] -rw------- 1 gpadmin gpadmin 1000112128 Jul 29 12:48
       /data1/primary/gpseg13/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_24723_0001.0
[sdw3] -rw------- 1 gpadmin gpadmin 1004797952 Jul 29 12:48
       /data2/primary/gpseg17/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_24731_0001.0
[sdw3] -rw------- 1 gpadmin gpadmin 1004994560 Jul 29 12:48
       /data2/primary/gpseg15/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_24727_0001.0
[sdw3] -rw------- 1 gpadmin gpadmin 1006108672 Jul 29 12:48
       /data1/primary/gpseg14/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_24725_0001.0
[sdw3] -rw------- 1 gpadmin gpadmin 998244352 Jul 29 12:48
       /data1/primary/gpseg12/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_24721_0001.0
[sdw3] -rw------- 1 gpadmin gpadmin 998440960 Jul 29 12:48
       /data2/primary/gpseg16/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_24729_0001.0
[sdw4] -rw------- 1 gpadmin gpadmin 1001029632 Jul 29 12:48
       /data2/primary/gpseg23/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29435_0001.0
[sdw4] -rw------- 1 gpadmin gpadmin 1002504192 Jul 29 12:48
       /data1/primary/gpseg20/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29429_0001.0
[sdw4] -rw------- 1 gpadmin gpadmin 1002504192 Jul 29 12:48
       /data2/primary/gpseg21/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29431_0001.0
[sdw4] -rw------- 1 gpadmin gpadmin 1009451008 Jul 29 12:48
       /data1/primary/gpseg19/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29427_0001.0
[sdw4] -rw------- 1 gpadmin gpadmin 980582400 Jul 29 12:48
       /data1/primary/gpseg18/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29425_0001.0
[sdw4] -rw------- 1 gpadmin gpadmin 993230848 Jul 29 12:48
       /data2/primary/gpseg22/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29433_0001.0
[sdw5] -rw------- 1 gpadmin gpadmin 1000898560 Jul 29 12:48
       /data2/primary/gpseg28/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_28641_0001.0
[sdw5] -rw------- 1 gpadmin gpadmin 1003388928 Jul 29 12:48
       /data2/primary/gpseg29/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_28643_0001.0
[sdw5] -rw------- 1 gpadmin gpadmin 1008566272 Jul 29 12:48
       /data1/primary/gpseg24/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_28633_0001.0
[sdw5] -rw------- 1 gpadmin gpadmin 987332608 Jul 29 12:48
       /data1/primary/gpseg25/base/19979/
pgsql_tmp/pgsql_tmp_slice10_sort_28635_0001.0
[sdw5] -rw------- 1 gpadmin gpadmin 990543872 Jul 29 12:48
       /data2/primary/gpseg27/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_28639_0001.0
[sdw5] -rw------- 1 gpadmin gpadmin 999620608 Jul 29 12:48
       /data1/primary/gpseg26/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_28637_0001.0
[sdw6] -rw------- 1 gpadmin gpadmin 1002242048 Jul 29 12:48
       /data2/primary/gpseg33/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29598_0001.0
[sdw6] -rw------- 1 gpadmin gpadmin 1003683840 Jul 29 12:48
       /data1/primary/gpseg31/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29594_0001.0
[sdw6] -rw------- 1 gpadmin gpadmin 1004732416 Jul 29 12:48
       /data2/primary/gpseg34/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29600_0001.0
[sdw6] -rw------- 1 gpadmin gpadmin 986447872 Jul 29 12:48
       /data2/primary/gpseg35/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29602_0001.0
[sdw6] -rw------- 1 gpadmin gpadmin 990543872 Jul 29 12:48
       /data1/primary/gpseg30/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29592_0001.0
[sdw6] -rw------- 1 gpadmin gpadmin 992870400 Jul 29 12:48
       /data1/primary/gpseg32/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_29596_0001.0
[sdw7] -rw------- 1 gpadmin gpadmin 1007321088 Jul 29 12:48
       /data2/primary/gpseg39/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_18530_0001.0
[sdw7] -rw------- 1 gpadmin gpadmin 1011187712 Jul 29 12:48
       /data1/primary/gpseg37/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_18526_0001.0
[sdw7] -rw------- 1 gpadmin gpadmin 987332608 Jul 29 12:48
       /data2/primary/gpseg41/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_18534_0001.0
[sdw7] -rw------- 1 gpadmin gpadmin 994344960 Jul 29 12:48
       /data1/primary/gpseg38/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_18528_0001.0
[sdw7] -rw------- 1 gpadmin gpadmin 996114432 Jul 29 12:48
       /data2/primary/gpseg40/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_18532_0001.0
[sdw7] -rw------- 1 gpadmin gpadmin 999194624 Jul 29 12:48
       /data1/primary/gpseg36/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_18524_0001.0
[sdw8] -rw------- 1 gpadmin gpadmin 1002242048 Jul 29 12:48
       /data2/primary/gpseg46/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15675_0001.0
[sdw8] -rw------- 1 gpadmin gpadmin 1003520000 Jul 29 12:48
       /data1/primary/gpseg43/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15669_0001.0
[sdw8] -rw------- 1 gpadmin gpadmin 1008009216 Jul 29 12:48
       /data1/primary/gpseg44/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15671_0001.0
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:16
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0001.0
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:21
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0002.1
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:24
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0003.2
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:26
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0004.3
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:31
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0006.5
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:32
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0005.4
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:34
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0007.6
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:36
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0008.7
[sdw8] -rw------- 1 gpadmin gpadmin 1073741824 Jul 29 12:43
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0009.8
[sdw8] -rw------- 1 gpadmin gpadmin 924581888 Jul 29 12:48
       /data2/primary/gpseg45/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15673_0010.9
[sdw8] -rw------- 1 gpadmin gpadmin 990085120 Jul 29 12:48
       /data1/primary/gpseg42/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15667_0001.0
[sdw8] -rw------- 1 gpadmin gpadmin 996933632 Jul 29 12:48
       /data2/primary/gpseg47/base/19979/pgsql_tmp/
pgsql_tmp_slice10_sort_15677_0001.0
	```
	从结果可以发现主机 sdw8 上的 Segment gpseg45 是罪魁祸首。

4. 使用 SSH 登录到有问题的节点，并切换为 root 用户，使用 lsof 找到拥有排序临时文件的进程 PID。

	```
	[root@sdw8?~]# lsof /data2/primary/gpseg45/base/19979/pgsql_tmp/
	pgsql_tmp_slice10_sort_15673_0002.1
	COMMAND    PID    USER    FD    TYPE    DEVICE    SIZE    NODE    NAME
	postgres  15673  gpadmin  11u  REG  8,48  1073741824  64424546751/data2/	primary/
	gpseg45/base/19979/pgsql_tmp/pgsql_tmp_slice10_sort_15673_0002.1
	```
	
	这个例子中 PID 15673 也是文件名的一部分，然而并不是所有的临时溢出文件名都包含进程 PID。

5. 使用 ps 命令识别 PID 对应的数据库和连接信息。

	```
	[root@sdw8?~]# ps -eaf | grep 15673
	gpadmin 15673 27471 28 12:05          00:12:59 postgres: port 40003, sbaskin bdw
       	172.28.12.250(21813) con699238 seg45 cmd32 slice10 MPPEXEC SELECT
	root 29622 29566 0 12:50 pts/16 00:00:00 grep 15673
	```

6. 最后，我们可以找到造成倾斜的查询语句。到主节点（Master）上，根据用户名 (sbaskin)、连接信息(con699238) 和命令信息(cmd32)查找pg_log下面的日志文件。找到对应的日志行，该行应该包含出问题的查询语句。 有时候cmd数字可能不一致。例如 ps 输出中 postgres 进程显示的是 cmd32，而日志中可能会是 cmd34。 如果分析的是正在运行的查询语句，则用户在对应连接上运行的最后一条语句就是出问题的查询语句。

	大多数情况下解决这种问题是重写查询语句。创建临时表可以避免倾斜。设置临时表使用随机分布，这样会强制执行两阶段聚合(two-stage aggregation)。
