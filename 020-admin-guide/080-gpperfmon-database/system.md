# system\_\*

system\_\* 表存储了系统利用度量。有三张 system 表，它们有相同的列：

* system\_now 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到 system\_history 表之间的时段，当前系统利用度量存储在 system\_now 中。

* system\_tail 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 system\_now 中清除但是还没有提交到 system\_history 的系统利用数据。它通常只包含了几分钟的数据。

* system\_history 是一个常规表，它存储数据库范围的历史系统利用度量。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp | 此行创建的时间 |
| hostname | varchar\(64\) | 与这些系统度量关联的Segment或Master的主机名。 |
| mem\_total | bigint | 该主机上总的系统内存量（以字节为单位）。 |
| mem\_used | bigint | 该主机上已经使用了的系统内存量（以字节为单位）。 |
| mem\_actual\_used | bigint | 该主机上实际使用的内存量（以字节为单位，不考虑留给cache以及缓冲区的内存）。 |
| mem\_actual\_free | bigint | 该主机上实际空闲的内存量（以字节为单位，不考虑留给cache以及缓冲区的内存）。 |
| swap\_total | bigint | 该主机上总的交换空间（以字节为单位）。 |
| swap\_used | bigint | 该主机上已经使用的交换空间（以字节为单位）。 |
| swap\_page\_in | bigint | 换进的页数。 |
| swap\_page\_out | bigint | 换出的页数。 |
| cpu\_user | float | HashData 系统用户的CPU使用。 |
| cpu\_sys | float | 该主机上CPU使用。 |
| cpu\_idle | float | 在度量收集期间的空闲CPU容量。 |
| load0 | float | 前一分钟内的CPU负载平均值。 |
| load1 | float | 前五分钟内的CPU负载平均值。 |
| load2 | float | 前十五分钟内的CPU负载平均值。 |
| quantum | int | 这个度量项的度量收集间隔。 |
| disk\_ro\_rate | bigint | 每秒磁盘的读操作。 |
| disk\_wo\_rate | bigint | 每秒磁盘的写操作。 |
| disk\_rb\_rate | bigint | 磁盘写操作每秒的字节数。 |
| net\_rp\_rate | bigint | 读取操作每秒在系统网络上的包。 |
| net\_wp\_rate | bigint | 写入操作每秒在系统网络上的包。 |
| net\_rb\_rate | bigint | 读取操作每秒在系统网络上的字节数。 |
| net\_wb\_rate | bigint | 写入操作每秒在系统网络上的字节数。 |


