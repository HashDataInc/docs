# pg\_exttable

pg\_exttable 系统目录表用来追踪由 CREATE EXTERNAL TABLE 命令创建的外部表和 Web 表。

##### 表 1. pg\_catalog.pg\_exttable

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| reloid | oid | pg\_class.oid | 该外部表的 OID。 |
| urilocation | text\[\] |  | 外部表文件的 URI 地址。 |
| execlocation | text\[\] |  | 为外部表定义的 ON Segment 位置。 |
| fmttype | char |  | 外部表文件的格式：t是文本，c是csv。 |
| fmtopts | text |  | 外部表文件的格式化选项，如字段定界符、空字符串、转义字符等。 |
| options | text\[\] |  | 为外部表定义的选项。 |
| command | text |  | 访问外部表所执行的OS命令。 |
| rejectlimit | integer |  | 每个Segment拒绝错误行的限制，之后装载将失败。 |
| rejectlimittype | char |  | 拒绝限制的阀值类型：r 表示行数。 |
| fmterrtbl | oid | pg\_class.oid | 记录格式错误的错误表的对象ID。**注意：**此列不再使用，将在以后的版本中被删除。 |
| encoding | text |  | 客户端编码。 |
| writable | boolean |  | 0表示可读外部表， 1表示可写外部表。 |

**上级主题：** [系统目录定义](./README.md)
