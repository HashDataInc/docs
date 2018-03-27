# pg\_max\_external\_files

pg\_max\_external\_files 视图显示使用外部表文件协议时每台Segment主机允许的外部表文件最大数量。

##### 表 1. pg\_catalog.pg\_max\_external\_files

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| hostname | name |  | 在Segment主机上访问特定Segment实例所使用的主机名。 |
| maxfiles | bigint |  | 该主机上的主Segment实例数。 |

**上级主题：** [系统目录定义](./README.md)
