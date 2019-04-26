# memory_info

memory\_info 视图显示在 system_history 和 segment_history 中每台主机的内存信息。这允许管理员去比较在一台 Segment 主机上总的可用内存、一台 Segment 主机上总的已经用内存以及查询处理使用的动态内存。

|列名|类型|描述|
|:---|:---|:---|
|ctime|timestamp(0) without time zone|这一行在segment_history表中被创建的时间。|
|hostname|varchar(64)|与这些系统内存度量相关的Segment或者Master主机名。|
|mem\_total\_mb|numeric|这台Segment主机的总系统内存（以MB为单位）。|
|mem\_used\_mb|numeric|这台Segment主机已用的总系统内存（以MB为单位）。|
|mem\_actual\_used_mb|numeric|这台Segment主机实际使用的系统内存（以MB为单位）。|
|mem\_actual\_free_mb|numeric|这台Segment主机实际的空闲系统内存（以MB为单位）。|
|swap\_total\_mb|numeric|这台Segment主机的总交换空间（以MB为单位）。|
|swap\_used\_mb|numeric|这台Segment主机已用的总交换空间（以MB为单位）。|
|dynamic\_memory\_used_mb|numeric|执行在这个Segment上的查询处理分配的动态内存大小（以MB为单位）。|
|dynamic\_memory\_available_mb|numeric|执行在这个Segment上的查询处理可用的额外动态内存的大小（以MB为单位）。注意：该值是在一台主机上所有Segment的可用内存的总和。尽管该值报告了可用内存，但是也有可能在一个或者更多Segment已经超过了通过参数gp\_vmem\_protect_limit为它们设置的内存限制。|

