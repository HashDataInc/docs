# gpexpand.status


gpexpand.status 表包含有关系统扩展操作状态的信息。扩展中涉及的特定表的状态存储在 [gpexpand.status\_detail](./gpexpandstatusdetail.md) 中。

在正常的扩展操作中，不需要修改存储在该表中的数据。

##### 表 1\. gpexpand.status

|列|类型|引用|描述|
|:---|:---|:---|:---|
|status|text||跟踪扩展操作的状态。有效值为： <br> SETUP <br> SETUP DONE <br> EXPANSION STARTED <br> EXPANSION STOPPED <br> COMPLETED
|updated|timestamp with time zone||最后状态变化的时间戳。|

**上级主题：** [系统目录定义](./README.md)