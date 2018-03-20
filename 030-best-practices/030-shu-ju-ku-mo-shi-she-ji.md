HashData 数据仓库是一个基于大规模并行处理（MPP）和无共享架构的数据仓库。这种分析型数据库的数据模式与高度规范化的事务性 OLTP 数据库显著不同。使用非规范化数据仓库模式，例如具有大事实表和小维度表的星型或者雪花模式，处理 MPP 分析型业务时，HashData 数据仓库表现优异。

## 数据类型

### 类型一致性

关联列使用相同的数据类型。如果不同表中的关联列数据类型不同，HashData 数据仓库必须动态的进行类型转换以进行比较。考虑到这一点，你可能需要增大数据类型的大小，以便关联操作更高效。

### 类型最小化

建议选择最高效的类型存储数据，这可以提高数据库的有效容量及查询执行性能。建议使用 TEXT 或者 VARCHAR 而不是 CHAR。不同的字符类型间没有明显的性能差别，但是 TEXT 或者 VARCHAR 可以降低空间使用量。建议使用满足需求的最小数值类型。如果 INT 或 SAMLLINT 够用，那么选择 BIGINT 会浪费空间。

## 存储模型

在 HashData 数据仓库中，创建表时可以选择不同的存储类型。需要清楚什么时候该使用堆存储、什么时候使用追加优化 (AO) 存储、什么时候使用行存储、什么时候使用列存储。对于大型事实表这尤为重要。相比而言，对小的维度表就不那么重要了。选择合适存储模型的常规最佳实践为：

1. 对于大型事实分区表，评估并优化不同分区的存储选项。一种存储模型可能满足不了整个分区表的不同分区的应用场景，例如某些分区使用行存储而其他分区使用列存储。

2. 使用列存储时，段数据库内每一列对应一个文件。对于有大量列的表，经常访问的数据使用列存储，不常访问的数据使用行存储。

3. 在分区级别或者在数据存储级别上设置存储类型。

4. 如果集群需要更多空间，或者期望提高 I/O 性能，考虑使用压缩。

### 堆存储和 AO 存储

堆存储是默认存储模型，也是 PostgreSQL 存储所有数据库表的模型。如果表和分区经常执行 UPDATE、DELETE 操作或者单个 INSERT 操作，则使用堆存储模型。如果需要对表和分区执行并发 UPDATE、DELETE、INSERT 操作，也使用堆存储模型。

如果数据加载后很少更新，之后的插入也是以批处理方式执行，则使用追加优化 \(AO\) 存储模型。千万不要对 AO 表执行单个 INSERT/UPDATE/DELETE 操作。并发批量 INSERT 操作是可以的，但是不要执行并发批量 UPDATE 或者 DELETE 操作。

AO 表中执行删除和更新操作后行所占空间的重用效率不如堆表，所以这种存储类型不适合频繁更新的表。AO 表主要用于分析型业务中加载后很少更新的大表。

### 行存储和列存储

行存储是存储数据库元组的传统方式。一行的所有列在磁盘上连续存储，所以一次 I/O 可以从磁盘上读取整个行。

列存储在磁盘上将同一列的值保存在一块。每一列对应一个单独的文件。如果表是分区表，那么每个分区的每个列对应一个单独的文件。如果列存储表有很多列，而 SQL 查询只访问其中的少量列，那么 I/O 开销与行存储表相比大大降低，因为不需要从磁盘上读取不需要访问的列。

交易型业务中更新和插入频繁，建议使用行存储。如果需要同时访问宽表的很多字段时，建议使用行存储。如果大多数字段会出现在 SELECT 列表中或者 WHERE 子句中，建议使用行存储。对于通用的混合型负载，建议使用行存储。行存储提供了灵活性和性能的最佳组合。

列存储是为读操作而非写操作优化的一种存储方式，不同字段存储在磁盘上的不同位置。对于有很多字段的大型表，如果单个查询只需访问较少字段，那么列存储性能优异。

列存储的另一个好处是相同类型的数据存储在一起比混合类型数据占用的空间少，因而列存储表比行存储表使用的磁盘空间小。列存储的压缩比也高于行存储。

数据仓库的分析型业务中，如果 SELECT 访问少量字段或者在少量字段上执行聚合计算，则建议使用列存储。如果只有单个字段需要频繁更新而不修改其他字段，则建议列存储。从一个宽列存储表中读完整的行比从行存储表中读同一行需要更多时间。特别要注意的是，HashData 数据仓库每个段数据库上每一列都是一个独立的物理文件。

## 压缩

HashData 数据仓库为 AO 表和分区提供多种压缩选项。使用压缩后，每次磁盘读操作可以读入更多的数据，因而可以提高 I/O 性能。建议在实际保存物理数据的那一层设置字段压缩方式。

请注意，新添加的分区不会自动继承父表的压缩方式，必须在创建新分区时明确指定压缩选项。

Delta 和 RLE 的压缩比较高。高压缩比使用的磁盘空间较少，但是在写入数据或者读取数据时需要额外的时间和 CPU 周期进行压缩和解压缩。压缩和排序联合使用，可以达到最好的压缩比。

在压缩文件系统上不要再使用数据库压缩。

测试不同的压缩类型和排序方法以确定最适合自己数据的压缩方式。

## 分布

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

### 本地（Co-located）关联

如果所用的哈希分布能均匀分布数据，并导致本地关联，那么性能会大幅提升。本地关联在段数据库内部执行，和其他段数据库没有关系，避免了网络通讯开销，避免或者降低了广播移动操作和重分布移动操作。

为经常关联的大表使用相同的字段做分布键可实现本地关联。本地关联需要关联的双方使用相同的字段（且顺序相同）做分布键，并且关联时所有的字段都被使用。分布键数据类型必须相同。如果数据类型不同，磁盘上的存储方式可能不同，那么即使值看起来相同，哈希值也可能不一样。

### 数据倾斜

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

### 计算倾斜（Procedding Skew）

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

## 分区
好的分区策略可以让查询只扫描需要访问的分区，以降低扫描的数据量。

在每个段数据库上的每个分区都是一个物理文件。读取分区表的所有分区比读取相同数据量的非分区表需要更多时间。

以下是分区最佳实践：

* 只为大表设置分区，不要为小表设置分区。
* 仅在根据查询条件可以实现分区裁剪时对大表使用分区。
* 建议优先使用范围 (Range) 分区，否则使用列表 (List) 分区。
* 仅当 SQL 查询包含使用不变操作符（例如 =，<, <=, >=, <>）的简单直接的约束时，查询优化器才会执行分区裁剪。
* 选择性扫描可以识别查询中的 STABLE 和 IMMUTABLE 函数，但是不能识别 VOLATILE 函数。例如查询优化器对下面的 WHERE 子句

	```
	date > CURRENT_DATE
	```
	可以启用分区裁剪，但是如果 WHERE 子句如下则不会启用分区裁剪。

	```
	time > TIMEOFDAY
	```
	通过检查查询的 EXPLAIN 计划验证是否执行分区裁剪非常重要。

* 不要使用默认分区。默认分区总是会被扫描，更重要的是很多情况下会导致溢出而造成性能不佳。
* 切勿使用相同的字段既做分区键又做分布键。
* 避免使用多级分区。虽然支持子分区但不推荐，因为通常子分区包含数据不多甚至没有。随着分区或者子分区增多性能可能会提高，然而维护这些分区和子分区的代价将超过性能的提升。基于性能、扩展性和可管理性，在扫描性能和分区总数间取得平衡。
* 对于列存储的表，慎用过多的分区。
* 考虑好并发量和所有并发查询打开和扫描的分区均值。

### 分区数目和列存储文件

HashData 数据仓库对于文件数目的唯一硬性限制是操作系统的打开文件限制。然而也需要考虑到集群的文件总数、每个段数据库(Segment)上的文件数和每个主机上的文件总数。在 MPP 无共享环境中，节点独立运行。每个节点受其磁盘、CPU 和内存的约束。HashData 数据仓库中 CPU 和 I/O 较少成为瓶颈，而内存却比较常见，因为查询执行器需要使用内存优化查询的性能。

Segment 的最佳文件数与每个主机节点上 Segment 个数、集群大小、SQL 访问模式、并发度、负载和倾斜等都有关系。通常一个主机上配置六到八个 Segments，对于大集群建议为每个主机配置更少的 Segment。使用分区和列存储时平衡集群中的文件总数很重要，但是更重要的是考虑好每个 Segment 的文件数和每个主机上的文件数。

例如数据仓库集群中每个节点 64GB 内存：

* 节点数：16
* 每个节点 Segment 数：8
* 每个 Segment 的文件均数：10000

一个节点的文件总数是：8*10000 = 80000，集群的文件总数是：8 * 16 * 10000 = 1280000. 随着分区增加和列字段的增加，文件数目增长很快。

作为一个最佳实践，单个节点的文件总数上限为 100000。如前面例子所示，Segment 的最佳文件数和节点的文件总数和节点的硬件配置（主要是内存）、集群大小、SQL 访问、并发度、负载和数据倾斜等相关。

### 索引

HashData 数据仓库通常不用索引，因为大多数的分析型查询都需要处理大量数据，而顺序扫描时数据读取效率较高，因为每个段数据库(Segment)含有数量相当的数据，且所有 Segment 并行读取数据。

对于具有高选择性的查询，索引可以提高查询性能。

即使明确需要索引，也不要索引经常更新的字段。对频繁更新的字段建立索引会增加数据更新时写操作的代价。

仅当表达式常在查询中使用时才建立基于表达式的索引。

谓词索引会创建局部索引，可用于从大表中选择少量行的情况。

避免重复索引。具有相同前缀字段的索引是冗余的。

对于压缩 AO 表，索引可以提高那些指返回少量匹配行的查询的性能。对于压缩数据，索引可以降低需要解压缩的页面数。

创建选择性高的 B 树索引。索引选择性是指：表的索引字段的不同值总数除以总行数。例如，如果一个表有 1000 行，索引列具有 800 个不同的值，那么该索引的选择性为 0.8，这是一个良好的选择性值。

如果创建索引后查询性能没有显著地提升，则删除该索引。确保创建的每个索引都被优化器采用。

加载数据前务必删除索引。加载速度比带索引快一个数量级。加载完成后，重建索引。

位图索引适合查询而不适合更新业务。当列的基数较低（譬如 100 到 100000 个不同值）时位图索引性能最好。不要对唯一列、基数很高的列或者基数很低的列建立位图索引。不要为业务性负载使用位图索引。

一般来说，不要索引分区表。如果需要，索引字段不要和分区字段相同。分区表索引的一个优势在于：随着 B 树的增大， B 树的性能呈指数下降，因而分区表上创建的索引对应的 B 树比较小，性能比非分区表好。

### 字段顺序和字节对齐
为了获得最佳性能，建议对表的字段顺序进行调整以实现数据类型的字节对齐。对堆表使用下面的顺序：

1. 分布键和分区键
1. 固定长度的数值类型
1. 可变长度的数据类型

从大到小布局数据类型，BIGINT 和 TIMESTAMP 在 INT 和 DATE 类型之前，TEXT，VARCHAR 和 NUMERIC(x,y) 位于后面。例如首先定义 8 字节的类型（BIGINT，TIMESTAMP）字段，然后是 4 字节类型（INT，DATE），随后是 2 字节类型（SMALLINT），最后是可变长度数据类型（VARCHAR）。 如果你的字段定义如下：

```
Int, Bigint, Timestamp, Bigint, Timestamp, Int (分布键), Date (分区键), Bigint,Smallint
```
则建议调整为：

```
Int (分布键), Date (分区键), Bigint, Bigint, Bigint, Timestamp, Timestamp, Int, Smallint
```

