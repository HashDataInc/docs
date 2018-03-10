## 数据加载

HashData 数据仓库 支持多种数据加载方式，每种都有其适用的场景。

### INSERT 语句直接插入字段数据

带有字段值的INSERT语句插入单行数据。数据通过主服务器（Master）分发到某个段数据库（Segment）。这是最慢的方法，不适合加载大量数据。

### COPY语句

PostgreSQL 的 COPY 语句从外部文件拷贝数据到数据库表中。它可以插入多行数据，比INSERT语句效率高，但是所有行数据仍然会通过Master。所有数据由一个命令完成拷贝，不能并行化。

COPY命令的数据输入可以是文件或者标准输入。例如：

```
COPY table FROM '/data/mydata.csv' WITH CSV HEADER;
```

COPY适合加载少量数据，例如数千行的维度表数据或者一次性数据加载。

使用脚本加载少于10k行数据时可以使用COPY。

COPY是单个命令，所以不需要禁用自动提交（autocommit）。

可以并发运行多个 COPY 命令以提高效率。

### 外部表

HashData 数据仓库 外部表可以访问数据库之外的数据。可以使用 SELECT 访问外部数据，常用于抽取、加载、转换（ELT）模式中。ELT 是 ETL 模式的一个变种，可以充分利用 HashData 数据仓库 的快速并行数据加载能力。

使用ETL时，数据从数据源抽取，在数据库之外使用诸如 Informatica 或者 Datastage 的外部工具进行转换，然后加载到数据库中。

使用ELT时，HashData 数据仓库 外部表提供对外部数据的直接访问，包括文件（例如文本文件、CSV或者XML文件）、Web服务器、Hadoop文件系统、可执行操作系统程序或者下节介绍的gpfdist文件服务器。外部表支持选择、排序和关联等SQL操作，所以数据可以同时进行加载和转换；或者加载到某个表后在执行转换操作，并最终插入到目标表中。

外部表定义使用CREATE EXTERNAL TABLE语句，该语句的LOCATION子句定义了数据源，FORMAT子句定义了数据的格式以便系统可以解析该数据。外部文件数据使用file://协议，且必须位于Segment主机上可以被 HashData 数据仓库 超级用户访问的位置。可以有多个数据文件，LOCATION子句中文件的个数就是并发读取外部数据的Segments的个数。

#### 外部表和gpfdist

加载大量事实表的最快方法是使用外部表与gpfdist。gpfdist是一个基于HTTP协议的、可以为HashData数据仓库的段数据库（Segments）并行提供数据的文件服务器。单个 gpfdist 实例速率可达 200MB/秒，多个 gpfdist 进程可以并行运行，每个提供部分加载数据。当使用

```
INSERT INTO <table> SELECT *FROM <external_table>
```

语句加载数据时，这个INSERT语句由Master解析，并分发到各个主Segments上。每个Segment连接到gpfdist服务器，并行获取数据、解析数据、验证数据、计算分布键的哈希值，并基于哈希值分布到存储该数据的目标Segment上。默认情况下，每个 gpfdist 实例可以接受至多来自64个Segment的连接。通过使用多个 gpfdist 服务器和大量Segments，可以实现非常高的加载速度。

使用 gpfdist 时，最多可以有_gp\_external\_max\_segs_个Segment并行访问外部数据。优化gpfdist性能时，随着Segment个数的增加，最大化并行度。均匀分布数据到尽可能的ETL节点。切分大文件为多个相同的部分，并分布到尽可能多的文件系统下。

每个文件系统运行两个 gpfdist 实例。加载数据时，在Segment上 gpfdist 往往是CPU密集型任务。但是譬如有八个机架的Segment节点，那么Segments上会有大量CPU资源，可以驱动更多的 gpfdist 进程。在尽可能多的网卡上运行 gpfdist。清楚了解绑定的NICs个数，并启动足够多的 gpfdist 进程充分使用网络资源。

均匀地为加载任务分配资源很重要。加载速度取决于最慢的节点，加载文件布局的倾斜会造成该资源成为瓶颈。

配置参数_gp\_external\_max\_segs_控制连接单个 gpfdist 的Segments的个数。默认值是64。确保\*gp\_external\_max\_segs\* 和 gpfdist 进程个数是偶数因子，也就是说_gp\_external\_max\_segs_值是 gpfdist 进程个数的倍数。例如如果有12个Segments、4 个进程，优化器轮询Segment连接如下：

```
Segment 1  - gpfdist 1
Segment 2  - gpfdist 2
Segment 3  - gpfdist 3
Segment 4  - gpfdist 4
Segment 5  - gpfdist 1
Segment 6  - gpfdist 2
Segment 7  - gpfdist 3
Segment 8  - gpfdist 4
Segment 9  - gpfdist 1
Segment 10 - gpfdist 2
Segment 11 - gpfdist 3
Segment 12 - gpfdist 4
```

加载数据到现有表之前删除索引，加载完成后重建索引。在已有数据上创建索引比边加载边更新索引快。

数据加载后对表运行 ANALYZE。加载过程中通过设置_gp\_autostats\_mode_为NONE禁用统计信息自动收集。

对有大量分区的列表频繁执行少量数据加载会严重影响系统性能，因为每次访问的物理文件很多。

#### gpload

gpload 是一个数据加载工具，是 HashData 数据仓库 外部表并行数据加载特性的一个接口。

小心使用 gpload，因为它会创建和删除外部表而造成系统表膨胀。建议使用性能最好的 gpfdist。

gpload 使用YAML格式的控制文件来定义数据加载规范，执行下面操作：

* 启动 gpfdist 进程；
* 基于定义的外部数据创建临时外部表；
* 执行INSERT、UPDATE或者MERGE操作，加载数据到数据库中的目标表；
* 删除临时外部表；
* 清理 gpfdist 进程。

加载操作处于单个事务之中。

### 最佳实践

* 加载数据到现有表前删除索引，加载完成后重建索引。创建新索引比边加载边更新索引快。
* 加载过程中，设置
  _gp\_autostats\_mode_
  为 NONE，禁用统计信息自动收集。
* 外部表不适合频繁访问或者 ad-hoc 访问。
* 外部表没有统计数据。可以使用下面的语句为外部表设置大概估计的行数和磁盘页数：

```
UPDATE pg_class SET reltuples=400000, relpages=400   WHERE relname='myexttable';
```

* 使用 gpfdist 时，为ETL服务器上的每个NIC运行一个 gpfdist 实例以最大化利用网络带宽。均匀分布数据到多个 gpfdist 实例上。
* 使用 gpload 时，运行尽可能多的 gpload。充分利用CPU、内存和网络资源以提高从ETL服务器加载数据到\|product-name\| 的速度。
* 使用 LOG ERRORS INTO 子句保存错误行。错误行 – 例如，缺少字段值或者多了额外值，或者不正确的数据类型 – 保存到错误表中，加载继续执行。Segment REJECT LIMIT 子句设置命令中止前允许的错误行的数目或者百分比。
* 如果加载报错，对目标表运行 VACUUM 释放空间。
* 数据加载完成后，对堆表包括系统表运行 VACUUM，对所有表运行 ANALYZE。对AO表不必运行 VACUUM。如果表是分区表，则可以仅对数据加载影响的分区执行 VACUUM 和 ANALYZE。这样可以清除失败的加载占用的空间、删除或者更新的行占用的空间，并更新统计数据。
* 加载大量数据后重新检查数据倾斜。使用下面查询检查倾斜状况：

```
SELECT gp_segment_id, count(*)
FROM schema.table GROUP BY gp_Segment_id ORDER BY 2;
```

* 默认情况，gpfdist 可以处理的最大行为 32K。如果行大于32K，则需要使用 gpfdist 的-m 选项增大最大行长度。如果使用 gpload，配置控制文件中的 MAX\_LINE\_LENGTH 参数。

#### 额外信息

关于 gpfdist 和 gpload 的更多信息，请参考《HashData 数据仓库 参考指南》。

