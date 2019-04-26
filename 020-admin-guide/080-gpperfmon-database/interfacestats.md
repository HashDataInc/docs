# interface\_stats\_*

interface\_stats\_* 表存储 HashData 数据库实例上每个活动接口上通信的统计度量。

这些表已经就位以备将来的使用，当前还没有进行填充。

这里有三个 interface_stats 表，它们都有相同的列：

*   interface\_stats\_now 是一个外部表，其数据文件存储在$MASTER\_DATA\_DIRECTORY/gpperfmon/data中。
*   interface\_stats\_tail是一个外部表，其数据文件存储在$MASTER\_DATA\_DIRECTORY/gpperfmon/data中。这是一个过渡表，其中存放着已经从interface\_stats\_now中清除但是还没有提交到interface\_stats\_history的统计性接口度量。它通常只包含了几分钟的数据。
*   interface\_stats\_history是一个常规表，它存储数据库范围的历史统计性接口度量。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

|列名|类型|描述|
|:---|:---|:---|
|interface_name|string|接口名。例如，eth0、eth1、lo等。|
|bytes_received|bigint|收到的数据量（以字节为单位）。|
|packets_received|bigint|收到的数据包数量。|
|receive_errors|bigint|在数据接收过程中遇到的错误数量。|
|receive_drops|bigint|在数据接收过程中发生丢包的次数。|
|receive\_fifo\_errors|bigint|在数据接收过程中遇到FIFO（先进先出）错误的次数。|
|receive\_frame\_errors|bigint|在数据接收过程中帧错误的次数。|
|receive\_compressed\_packets|int|收到的压缩格式的包的数目。|
|receive\_multicast\_packets|int|接收的多播数据包的数量。|
|bytes_transmitted|bigint|数据的传输量（以字节为单位）。|
|packets_transmitted|bigint|被传输的包的数量。|
|transmit_errors|bigint|在数据传输过程中遇到的错误数量。|
|transmit_drops|bigint|在数据传输过程中丢包的次数。|
|transmit\_fifo\_errors|bigint|在数据传输过程中遇到的FIFO错误次数。|
|transmit\_collision\_errors|bigint|在数据传输过程中遇到冲突错误的次数。|
|transmit\_carrier\_errors|bigint|在数据传输过程中，遇到载体错误的次数。|
|transmit\_compressed\_packets|int|以压缩格式进行传输的包的数目。|

