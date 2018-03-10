# 系统配置

本节描述了 HashData 数据仓库 集群关于主机配置的需求和最佳实践。

## 首选操作系统

CentOS是首选操作系统。应使用最新支持的主版本，目前是 CentOS 7。

## 文件系统

HashData 数据仓库 的数据目录推荐使用 XFS 文件系统。使用以下选项挂载 XFS：

```
rw,noatime,inode64,allocsize=16m
```

## 端口配置

操作系统配置参数_ip\_local\_port\_range_的设置不要和 HashData 数据仓库 的端口范围有冲突，例如：

```
net.ipv4.ip_local_port_range=3000 65535
PORT_BASE=2000
MIRROR_PORT_BASE=2100
REPLICATION_PORT_BASE=2200
MIRROR_REPLICATION_PORT_BASE=2300
```

## I/O 配置

包含数据目录的设备的预读大小应设为16384。

```
/sbin/blockdev --getra /dev/sdb
16384
```

包含数据目录的设备的 I/O 调度算法设置为deadline。

```
# cat /sys/block/sdb/queue/scheduler
noop anticipatory [deadline] cfq
```

通过 /etc/security/limits.conf 增大操作系统文件数和进程数。

```
* soft nofile 65536
* hard nofile 65536
* soft nproc 131072
* hard nproc 131072
```

启用core文件转储，并保存到已知位置。确保limits.conf中允许的core转储文件。

```
kernel.core_pattern = /var/core/core.%h.%t
# grep core /etc/security/limits.conf
* soft core unlimited
```

## 操作系统内存配置

Linux sysctl 的_vm.overcommit\_memory_和_vm.overcommit\_ratio_变量会影响操作系统对内存分配的管理。这些变量应该设置如下：

**vm.overcommit\_memory**

控制操作系统使用什么方法确定分配给进程的内存总数。对于 HashData 数据仓库，唯一建议值是2。

**vm.overcommit\_ratio**

控制分配给应用程序进程的内存百分比。建议使用缺省值50。

不要启用操作系统的大内存页。

详见：_内存和负载管理_。（后续章节\)

## 共享内存设置

HashData 数据仓库 中同一数据库实例的不同postgres进程间通讯使用共享内存。使用sysctl配置如下共享内存参数，且不建议修改：

```
kernel.shmmax = 500000000
kernel.shmmni = 4096
kernel.shmall = 4000000000
```

## 验证操作系统

使用gpcheck验证操作系统配置。参考 《HashData 数据仓库 工具指南》中的gpcheck。

## 设置段数据库个数

确定每个段主机上段数据库的个数对整体性能有着巨大影响。这些段数据库之间共享主机的 CPU 核、内存、网卡等，且和主机上的所有进程共享这些资源。过高地估计每个服务器上运行的段数据库个数，通常是达不到最优性能的常见原因之一。

以下因素确定了一个主机上可以运行多少个段数据库：

* CPU 核的个数
* 物理内存容量
* 网卡个数及速度
* 存储空间
* 主段数据库和镜像共存
* 主机是否运行 ETL 进程
* 主机上运行的非 HashData 数据仓库 进程

## 段服务器内存配置

服务器配置参数_gp\_vmem\_protect\_limit_控制了每个段数据库为所有运行的查询分配的内存总量。如果查询需要的内存超过此值，则会失败。使用下面公式确定合适的值：

```
(swap + (RAM * vm.overcommit_ratio)) * .9 / number_of_segments_per_server
```

例如，具有下面配置的段服务器：

* 8GB 交换空间
* 128GB 内存
* vm.overcommit\_ratio = 50
* 8 个段数据库

则设置_gp\_vmem\_protect\_limit_为 8GB：

```
(8 + (128 * .5)) * .9 / 8 = 8 GB
```

参见：_内存和负载管理_。（后续章节\)

## SQL语句内存配置

服务器配置参数_gp\_statement\_mem_控制段数据库上单个查询可以使用的内存总量。如果语句需要更多内存，则会溢出数据到磁盘。用下面公式确定合适的值：

```
(gp_vmem_protect_limit*.9)/max_expected_concurrent_queries
```

例如，如果并发度为40，_gp\_vmeme\_protect\_limit_为8GB，则_gp\_statement\_mem_为：

```
(8192MB * .9) / 40 = 184MB
```

每个查询最多可以使用 184MB 内存，之后将溢出到磁盘。

若想安全的增大_gp\_statement\_mem_，要么增大_gp\_vmem\_protect\_limit_，要么降低并发。要增大\*gp\_vmem\_protect\_limit\*，必须增加物理内存和/或交换空间，或者降低单个主机上运行的段数据库个数。

请注意，为集群添加更多的段数据库实例并不能解决内存不足的问题，除非引入更多新主机来降低了单个主机上运行的段数据库的个数。

了解什么是溢出文件。了解 _gp\_workfile\_limit\_files\_per\_query _参数，其控制了单个查询最多可以创建多少个溢出文件。了解_gp\_workfile\_limit\_per\_Segment_。

有关使用资源队列管理内存的更多信息，请参考：_内存和负载管理_。（后续章节\)

## 溢出文件配置

如果为SQL查询分配的内存不足，HashData 数据仓库 会创建溢出文件（也叫工作文件）。在默认情况下，一个SQL查询最多可以创建 100000 个溢出文件，这足以满足大多数查询。

参数_gp\_workfile\_limit\_files\_per\_query_决定了一个查询最多可以创建多少个溢出文件。0 意味着没有限制。限制溢出文件数据可以防止失控查询破坏整个系统。

如果分配内存不足或者出现数据倾斜，则一个SQL查询可能产生大量溢出文件。如果超过溢出文件上限，HashData 数据仓库 报告如下错误：

```
ERROR: number of workfiles per query limit exceeded
```

在尝试增大_gp\_workfile\_limit\_files\_per\_query_前，先尝试通过修改 SQL、数据分布策略或者内存配置以降低溢出文件个数。

gp\_toolkit模式包括一些视图，通过这些视图可以看到所有使用溢出文件的查询的信息。这些信息有助于故障排除和调优查询：

* _gp\_workfile\_entries_
  视图的每一行表示一个正在使用溢出文件的操作符的信息。关于操作符，参考:
  _如何理解查询计划解释_
  。（后续章节\)
* _gp\_workfile\_usage\_per\_query_
  视图的每一行表示一个正在使用溢出文件的 SQL 查询的信息。
* _gp\_workfile\_usage\_per\_Segment_
  视图的每一行对应一个段数据库，包含了该段上使用的溢出文件占用的磁盘空间总量。

关于这些视图的字段涵义，请参考《HashData 数据仓库 参考指南》。

参数_gp\_workfile\_compress\_algorithm_指定溢出文件的压缩算法：none 或者 zlib。

