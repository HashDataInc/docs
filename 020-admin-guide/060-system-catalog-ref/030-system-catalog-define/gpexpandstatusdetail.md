# gpexpand.status\_detail

gpexpand.status\_detail 表包含了系统扩展操作设计到的表的状态信息。你可以通过查询这个表来检查正在扩展的表的状态，或者查看已经完成扩展的表的开始和结束时间。

这个表也包含 oid，磁盘大小，和常规的分布策略及分布键这些相关信息。扩展的总体状态信息存储在 [gpexpand.status](./gpexpandstatus.md) 中。

在一个常规的扩展操作中，不需要修改这个表中的数据。

| 列 | 类型 | 应用 | 描述 |
| :--- | :--- | :--- | :--- |
| dbname | text |  | Name of the database to which the table belongs. |
| fq\_name | text |  | Fully qualified name of the table. |
| schema\_oid | oid |  | OID for the schema of the database to which the table belongs. |
| table\_oid | oid |  | OID of the table. |
| distribution\_policy | smallint\(\) |  | Array of column IDs for the distribution key of the table. |
| distribution\_policy \_names | text |  | Column names for the hash distribution key. |
| distribution\_policy \_coloids | text |  | Column IDs for the distribution keys of the table. |
| storage\_options | text |  | Not enabled in this release. Do not update this field. |
| rank | int |  | Rank determines the order in which tables are expanded. The expansion utility will sort on rank and expand the lowest-ranking tables first. |
| status | text |  | Status of expansion for this table. Valid values are:NOT STARTEDIN PROGRESSFINISHEDNO LONGER EXISTS |
| last updated | timestamp with time zone |  | Timestamp of the last change in status for this table. |
| expansion started | timestamp with time zone |  | Timestamp for the start of the expansion of this table. This field is only populated after a table is successfully expanded. |
| expansion finished | timestamp with time zone |  | Timestamp for the completion of expansion of this table. |
| source bytes |  |  | The size of disk space associated with the source table. Due to table bloat in heap tables and differing numbers of segments after expansion, it is not expected that the final number of bytes will equal the source number. This information is tracked to help provide progress measurement to aid in duration estimation for the end-to-end expansion operation. |

**上级主题：** [系统目录定义](./README.md)
