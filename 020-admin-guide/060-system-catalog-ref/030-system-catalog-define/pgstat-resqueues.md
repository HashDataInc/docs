# pg\_stat\_resqueues

pg\_stat\_resqueues 视图允许管理员查看资源队列一段时间的负载度量。用户必须在 HashData 数据库的 Master 示例上启用 stats\_queue\_level 服务器配置参数。启用对这些度量的收集确实会招致小小的性能惩罚，因为每个通过资源队列提交的语句必须被记录在系统目录表中。

##### 表 1\. pg\_catalog.pg\_stat_resqueues

|列|类型|参考|描述|
|:---|:---|:---|:---|
|queueoid|oid||资源队列的OID。
|queuename|name||资源队列的名称。
|n\_queries\_exec|bigint||已提交的要从该资源队列中执行的查询数目。
|n\_queries\_wait|bigint||已提交到该资源队列中，在执行之前必须进行等待的查询数目。
|elapsed_exec|bigint||通过该资源队列提交的语句的总执行时间。
|elapsed_wait|bigint||通过该资源队列提交的语句，在执行之前必须进行等待的总时间。

**上级主题：** [系统目录定义](./README.md)