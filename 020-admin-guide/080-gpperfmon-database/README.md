# gpperfmon 数据库

gpperfmon 数据库是一个专门用于数据收集代理在 HashData 的 Segment 主机上保存统计信息的指定数据库。可选的 HashData 命令中心管理工具需要该数据库。gpperfmon 数据库通过使用命令行实用程序 gpperfmon\_install 创建。该程序创建 gpperfmon 数据库以及 gpmon 数据库上的角色，同时，开启在 Segment 主机上的监视代理。更多关于使用该工具和配置数据收集代理的信息请见 HashData 数据库工具指南中的 gpperfmon\_install 参考。

gpperfmon 数据库包含下面三种表集合。

* now 这类表存储当前系统度量数据，例如活跃的查询。
* history 这类表存储历史度量数据。
* tail 这类表存储临时数据。Tail 这类表只在内部使用不应该被用户查询。now 和 tail 这两类表在 Master 主机文件系统中被存储为文本文件，能够被 gpperfmon 数据库以外部表的形式访问。history 这类表是存储在 gpperfmon 数据库中的普通数据库表。

gpperfmon 数据库中包含下面类别的表：

* [database\_\*](./database.md)  表存储一个 HashData 数据库实例的查询负载信息。
* [diskspace\_\*](./diskspace.md) 表存储磁盘空间度量。
* [filerep\_\*](./filerep.md) 表存储文件复制过程的健康和状态度量。该过程是 HashData 数据库实例实现高可用/镜像 的方式。为每一对主-镜像都会维护统计信息。
* [interface\_stats\_\*](./interfacestats.md) 表存储每个 HashData 数据库实例的每个活跃接口的统计度量。注意：这些表已经就位以备将来所用，现在还没有进行填充。
* [log\_alert\_\*](./logalert.md)  表存储关于 pg\_log 错误和警告的信息。
* [queries\_\*](./queries.md) 表存储高层次的查询状态信息。
* [segment\_\*](./segment.md)  表存储 HashData 数据库 Segment 实例的内存分配统计。
* socket\_stats\_\*表存储一个 HashData 数据库实例的套接字使用的统计信息。注意：这些表已经就位以备将来使用，现在还没有进行填充。
* [system\_\*](./system.md) 表存储系统利用的度量。

gpperfmon 数据库还包含以下的视图：

* [dynamic\_memory \_info](./dynamicmemory-info.md) 视图显示 每台主机上所有Segment的聚合以及每台主机上已经使用的动态内存量。
* [memory\_info](./memoryinfo.md) 视图显示从 system\_history 和 segment\_history 表获取的关于每个主机的内存信息。

