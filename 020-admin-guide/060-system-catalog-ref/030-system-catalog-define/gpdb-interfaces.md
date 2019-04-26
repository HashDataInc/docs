# gp\_db\_interfaces

gp\_db\_interfaces 表包含有关Segment与网络接口的关系的信息。该信息和 [gp_interfaces](./gpinterfaces.md) 的数据连接在一起被系统用于为多种目的网络接口的使用，包括故障检测。

##### 表 1\. pg\_catalog.gp\_db_interfaces

|列|类型|引用|描述|
|:---|:---|:---|:---|
|dbid|smallint|gp\_segment\_ configuration.dbid|系统分配的ID。Segment（或Master）实例的唯一标识符。|
|interfaceid|smallint|gp_interfaces.interfaceid|系统分配的网络接口ID。|
|priority|smallint||该Segment的网络接口的优先级。|

**上级主题：** [系统目录定义](./README.md)