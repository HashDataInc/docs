## 内存管理

内存管理对 HashData 数据仓库集群性能有显著影响。默认设置可以满足大多数环境需求。不要修改默认设置，除非你理解系统的内存特性和使用情况。如果精心设计内存管理，大多数内存溢出问题可以避免。

下面是 HashData 数据仓库内存溢出的常见原因：

* 集群的系统内存不足
* 内存参数设置不当
* 段数据库 \(Segment\) 级别的数据倾斜
* 查询级别的计算倾斜

有时不仅可以通过增加系统内存解决问题，还可以通过正确的配置内存和设置恰当的资源队列管理负载，以避免很多内存溢出问题。

建议使用如下参数来配置操作系统和数据库的内存：

* vm.overcommit\_memory

  > 这是 /etc/sysctl.conf 中设置的一个 Linux 内核参数。总是设置其值为 2。它控制操作系统使用什么方法确定分配给进程的内存总数。对于 HashData 数据仓库，唯一建议值是 2。

* vm.overcommit\_ratio

  > 这是 /etc/sysctl.conf 中设置的一个 Linux 内核参数。它控制分配给应用程序进程的内存百分比。建议使用缺省值 50.

* 不要启用操作系统的大内存页

* gp\_vmem\_protect\_limit

  > 使用 _gp\_vmem\_protect\_limit_ 设置段数据库\(Segment\)能为所有任务分配的最大内存。切勿设置此值超过系统物理内存。如果 _gp\_vmem\_protect\_limit_ 太大，可能造成系统内存不足，引起正常操作失败，进而造成段数据库故障。如果 gp\_vmem\_protect\_limit 设置为较低的安全值，可以防止系统内存真正耗尽；打到内存上限的查询可能失败，但是避免了系统中断和 Segment 故障，这是所期望的行为。 _gp\_vmem\_protect\_limit_ 的计算公式为:

	```
	( SWAP + ( RAM * vm.overcommit_ratio )) * .9 /number_segments_per_server
	```

* runaway\_detector\_activation\_percent

  > HashData 数据仓库提供了失控查询终止（Runaway Query Termination）机制避免内存溢出。系统参数_runaway\_detector\_activation\_percent_控制内存使用达到_gp\_vmem\_protect\_limit_的多少百分比时会终止查询，默认值是 90%。如果某个Segment使用的内存超过了_gp\_vmem\_protect\_limit_的90%（或者其他设置的值），HashData 数据仓库会根据内存使用情况终止那些消耗内存最多的 SQL 查询，直到低于期望的阈值。

* statement\_mem

  > 使用_statement\_mem_控制 Segment 数据库分配给单个查询的内存。如果需要更多内存完成操作，则会溢出到磁盘（溢出文件，spill files）。_statement\_mem_的计算公式为:

	```
    (vmprotect * .9) / max_expected_concurrent_queries
	```

	> *statement_mem* 的默认值是128MB。例如使用这个默认值， 对于每个服务器安装 8 个 Segment 的集群来说，一条查询在每个服务器上需要 1GB 内存（8 Segments * 128MB）。对于需要更多内存才能执行的查询，可以设置回话级别的 *statement_mem*。对于并发度比较低的集群，这个设置可以较好的管理查询内存使用量。并发度高的集群也可以使用资源队列对系统运行什么任务和怎么运行提供额外的控制。
	

* gp\_workfile\_limit\_files\_per\_query

  > _gp\_workfile\_limit\_files\_per\_query_ 限制一个查询可用的临时溢出文件数。当查询需要比分配给它的内存更多的内存时将创建溢出文件。当溢出文件超出限额时查询被终止。默认值是 0，表示溢出文件数目没有限制，可能会用光文件系统空间。

* gp\_workfile\_compress\_algorithm

  > 如果有大量溢出文件，则设置_gp\_workfile\_compress\_algorithm_对溢出文件压缩。压缩溢出文件也有助于避免磁盘子系统 I/O 操作超载。

## 配置资源队列

HashData 数据仓库的资源队列提供了强大的机制来管理集群的负载。队列可以限制同时运行的查询的数量和内存使用量。当 HashData 数据仓库收到查询时，将其加入到对应的资源队列，队列确定是否接受该查询以及何时执行它。

* 不要使用默认的资源队列，为所有用户都分配资源队列。每个登录用户（角色）都关联到一个资源队列；用户提交的所有查询都由相关的资源队列处理。如果没有明确关联到某个队列，则使用默认的队列  _pg\_default_ 。
* 避免使用 gpadmin 角色或其他超级用户角色运行查询 超级用户不受资源队列的限制，因为超级用户提交的查询始终运行，完全无视相关联的资源队列的限制。
* 使用资源队列参数 _ACTIVE\_STATEMENTS_ 限制某个队列的成员可以同时运行的查询的数量。
* 使用 _MEMORY\_LIMIT_ 参数控制队列中当前运行查询的可用内存总量。联合使用 _ACTIVE\_STATEMENTS_ 和 **MEMORY\_LIMIT**  属性可以完全控制资源队列的活动。

队列工作机制如下：假设队列名字为 _sample\_queue_ ， _ACTIVE\_STATEMENTS_ 为 10， _MEMORY\_LIMIT_ 为 2000MB。这限制每个段数据库 \(Segment\) 的内存使用量约为 2GB。如果一个服务器配置 8 个 Segments，那么一个服务器上， _sample\_queue_ 需要 16GB 内存。如果 Segment 服务器有 64GB 内存，则该系统不能超过 4 个这种类型的队列，否则会出现内存溢出。（4队列 \* 16GB/队列）。

> 注意 _STATEMENT\_MEM_ 参数可使得某个查询比队列里其他查询分配更多的内存，然而这也会降低队列中其他查询的可用内存。

* 资源队列优先级可用于控制工作负载以获得期望的效果。具有 _MAX_ 优先级的队列会阻止其他较低优先级队列的运行，直到 _MAX_ 队列处理完所有查询。
* 根据负载和一天中的时间段动态调整资源队列的优先级以满足业务需求。根据时间段和系统的使用情况，典型的环境会有动态调整队列优先级的操作流。可以通过脚本实现工作流并加入到 crontab 中。
* 使用 _gp\_toolkit_ 提供的视图查看资源队列使用情况，并了解队列如何工作。



