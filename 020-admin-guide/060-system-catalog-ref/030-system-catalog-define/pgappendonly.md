# pg\_appendonly

pg\_appendonly 表包含有关追加优化表的储存选项和其他特性的信息。

##### 表 1. pg\_catalog.pg\_appendonly

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| relid | oid |  | 压缩表的表对象标识符（OID）。 |
| blocksize | integer |  | 用于追加优化表压缩的块尺寸。有效值为8K - 2M。默认值为32K。 |
| safefswritesize | integer |  | 在非成熟文件系统中追加优化表的安全写操作的最小尺寸。通常设置为文件系统扩展块尺寸的倍数，例如Linux ext3是4096字节，所以通常使用32768的值。 |
| compresslevel | smallint |  | 压缩级别，压缩比从1增加到9。 |
| majorversion | smallint |  | pg\_appendonly表的主要版本号。 |
| minorversion | smallint |  | pg\_appendonly表的次要版本号。 |
| checksum | boolean |  | 存储的校验和值，在压缩和扫描时用来比较数据块的状态，以确保数据完整性。 |
| compresstype | text |  | 用于压缩追加优化表的压缩类型。 有效值为： zlib（gzip压缩） |
| columnstore | boolean |  | 1为列存，0为行存。 |
| segrelid | oid |  | 表在磁盘上的Segment文件ID。 |
| segidxid | oid |  | 索引在磁盘上的Segment文件ID。 |
| blkdirrelid | oid |  | 用于磁盘上列存表文件的块。 |
| blkdiridxid | oid |  | 用于磁盘上列存索引文件的块。 |
| visimaprelid | oid |  | 表的可见性映射。 |
| visimapidxid | oid |  | 可见性映射上的B-树索引。 |

**上级主题：** [系统目录定义](./README.md)
