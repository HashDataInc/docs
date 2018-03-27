# gp_pgdatabase

gp_pgdatabase 视图显示 HashData 中 Segment 实例的状态信息，以及它们是作为镜像 Segment 还是主 Segment。 HashData 的故障检测和恢复工具在内部使用此视图来确定失效的 Segment。

##### 表 1\. pg\_catalog.gp\_pgdatabase

|列|类型|引用|描述|
|:---|:---|:---|:---|
|dbid|smallint|gp\_segment\_configuration.dbid|系统分配的ID。Segment（或者Master）实例的唯一标识符。
|isprimary|boolean|gp\_segment\_configuration.role|该实例是否处于活动状态。它目前是否作为主Segment（还是镜像Segment）。
|content|smallint|gp\_segment\_ configuration.content|实例上部分数据的ID。主Segment实例及其镜像将具有相同的内容ID。对于Segment，值为 0- _N_, 其中 _N_ 是 HashData 数据库中的Segment数量。对于Master，值为-1。
|definedprimary|boolean|gp\_segment\_ configuration.preferred_role|在初始化系统时，该实例是否被定义为主Segment（而不是镜像Segment）。

**上级主题：** [系统目录定义](./README.md)