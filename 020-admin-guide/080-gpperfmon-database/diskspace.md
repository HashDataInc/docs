# diskspace\_\*

diskspace\_\* 表存储磁盘空间度量。

* diskspace\_now 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到 diskspace\_history 表之间的时段，当前磁盘空间度量存储在 diskspace\_now 中。

* diskspace\_tail 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 diskspace\_now 中清除但是还没有提交到 diskspace\_history 的磁盘空间度量。它通常只包含了几分钟的数据。

* diskspace\_history 是一个常规表，它存储数据库范围的历史磁盘空间度量。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp\(0\) without time zone | 磁盘空间测试时间。 |
| hostname | varchar\(64\) | 磁盘空间测试的主机名称。 |
| Filesystem | text | 磁盘空间测试的文件系统名称。 |
| total\_bytes | bigint | 文件系统中的总的字节数。 |
| bytes\_used | bigint | 在文件系统中使用的总的字节数。 |
| bytes\_available | bigint | 在文件系统中空的字节数 |


