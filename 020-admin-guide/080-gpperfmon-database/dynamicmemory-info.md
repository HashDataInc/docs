# dynamic\_memory\_info

dynamic\_memory\_info 视图显示在一个 Segment 主机上所有 Segment 实例已经使用以及可用动态内存的总额。动态内存是指 HashData 数据库实例开始取消进程之前允许单个 Segment 实例的查询进程消耗的最大内存量。该限制通过 gp\_vmem\_protect\_limit 服务器配置参数来进行设置，并且会为每个 Segment 分别计算。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp without time zone | 在segment\_history表中创建该行的时间。 |
| hostname | varchar\(64\) | 与这些系统内存度量相关的Segment或者Master主机名。 |
| dynamic\_memory\_used\_mb | numeric | 分配给在该Segment上运行的查询进程的动态内存总量（以MB为单位）。 |
| dynamic\_memory\_available\_mb | numeric | 在这台Segment主机上运行的查询进程可用的额外动态内存量（以MB为单位）。注意这个值是一台主机上对所有Segment可用的内存总量。即便这个值报告了可用内存，仍有可能该主机上的一个或者更多Segment已经超过了它们的内存限制（通过gp\_vmem\_protect\_limit参数设置）。 |


