# filerep\_\*

filerep\* 表为 HashData 数据库实例存储高可用文件复制进程信息。有三个 filerep 表，它们都有相同的列：

* filerep\_now 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到 filerep\_history 表之间的时段，当前的文件复制数据存储在 filerep\_now 中。

* filerep\_tail 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 filerep\_now 中清除但是还没有提交到 filerep\_history 的文件复制数据。它通常只包含了几分钟的数据。

* filerep\_history 是一个常规表，它存储数据库范围的历史文件复制数据。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp | 此行创建的时间 |
| primary\_measurement\_microsec | bigint | 说明主度量（包含在 UDP 消息中）是在多长的时间段上被收集的。 |
| mirror\_measurement\_microsec | bigint | 说明镜像度量（包含在UDP消息中）是在多长的时间段上被收集的。 |
| primary\_hostname | varchar\(64\) | primary 主机的名称 |
| primary\_port | int | Primary 主机的端口号 |
| mirror\_hostname | varchar\(64\) | Mirror 主机的名称 |
| mirror\_port | int | Mirror 主机的端口号 |
| primary\_write\_syscall\_bytes\_avg | bigint | 每个间隔中，主服务器上通过写系统调用写到磁盘上的平均数据量 |
| primary\_write\_syscall\_byte\_max | bigint | 每个间隔中，主服务器上通过写系统调用写到磁盘上的最大数据量 |
| primary\_write\_syscall\_microsecs\_avg | bigint | 每个间隔中，主服务器上一次写系统调用写数据到磁盘上所要求的平均时间 |
| primary\_write\_syscall\_microsecs\_max | bigint | 每个间隔中，主服务器上一次写系统调用写数据到磁盘上所要求的最大时间 |
| primary\_write\_syscall\_per\_sec | double precision | 主服务器上每秒写系统调用的数量。它只反映将写入磁盘放入内存队列中的时间 |
| primary\_fsync\_syscall\_microsec\_avg | bigint | 每个间隔中，主服务器上一次文件同步系统调用写数据到磁盘上所要求的平均时间 |
| primary\_fsync\_syscall\_microsec\_max | bigint | 每个间隔中，主服务器上一次文件同步系统调用写数据到磁盘上所要求的最大时间 |
| primary\_fsync\_syscall\_per\_sec | double precision | 主服务器上每秒的文件同步系统调用数量。和在数据被递送或者加入队列后就立刻返回的写系统调用不同，文件同步系统调用会等待所有未解决的写入被写到磁盘上。这一列中的文件同步系统调用值反映了大量数据的实际磁盘访问时间 |
| primary\_write\_shmem\_bytes\_avg | bigint | 每个间隔中，主服务器上被写到共享内存中的平均数据量 |
| primary\_write\_shmem\_bytes\_max | bigint | 每个间隔中，主服务器上被写到共享内存中的最大数据量 |
| primary\_write\_shmem\_microsec\_avg | bigint | 每个间隔中，主服务器上写入数据到共享内存中所需要的平均时间 |
| primary\_write\_shmem\_microsec\_max | bigint | 每个间隔中，主服务器上写入数据到共享内存中所需要的最大时间 |
| primary\_write\_shmem\_per\_sec | double precision | 主服务器上每秒写到共享内存中的次数 |
| primary\_fsync\_shmem\_microsec\_avg | bigint | 每个间隔中，主服务器上文件同步系统调用写入数据到共享内存中所需要的平均时间 |
| primary\_fsync\_shmem\_microsec\_max | bigint | 每个间隔中，主服务器上文件同步系统调用写入数据到共享内存中所需要的最大时间 |
| primary\_fsync\_shmem\_per\_sec | double precision | 主服务器每秒写到共享内存的文件同步调用次数。这一列中的文件同步系统调用值反映了大数据量时的实际磁盘访问次数 |
| primary\_roundtrip\_fsync\_msg\_microsec\_avg | bigint | 每个间隔中，主服务器和镜像服务器之间一次往返文件同步所需要的平均时间。包括：从主服务器到镜像服务器的一个文件同步消息的排队。消息在网络中的传播。在镜像服务器上文件同步的执行。文件同步确认信息通过网络传回主服务器。 |
| primary\_roundtrip\_fsync\_msg\_microsec\_max | bigint | 每个间隔中，主服务器和镜像服务器之间一次往返文件同步所需要的最大时间。包括：从主服务器到镜像服务器的一个文件同步消息的排队。消息在网络中的传播。在镜像服务器上文件同步的执行。文件同步确认信息通过网络传回主服务器。 |
| primary\_roundtrip\_fsync\_msg\_per\_sec | double precision | 每秒往返文件同步的数量。 |
| primary\_roundtrip\_test\_msg\_microsec\_avg | bigint | 每个间隔，主服务器和镜像服务器之间一次往返测试消息完成所需的平均时间。这与primary\\_roundtrip\\_fsync\\_msg\\_microsec\_avg类似，不过它不包括磁盘访问部分。因此，这是一个显示文件复制过程中平均网络延迟的有用的度量。 |
| primary\_roundtrip\_test\_msg\_microsec\_max | bigint | 每个间隔，主服务器和镜像服务器之间一次往返测试消息完成所需的最大时间。这与primary\\_roundtrip\\_fsync\\_msg\\_microsec\_max类似，不过它不包括磁盘访问部分。因此，这是一个显示文件复制过程中最大网络延迟的有用的度量。 |
| primary\_roundtrip\_test\_msg\_per\_sec | double precision | 每秒的往返文件同步数量。类似于primary\\_roundtrip\\_fsync\\_msg\\_per\_sec，但它不包括磁盘访问部分。因此，这是一个显示文件复制过程中网络延迟的有用的度量。注意：测试消息通常每分钟发生一次，所以通常在不包含测试消息的时间段会看到值为“0”。 |
| mirror\_write\_syscall\_size\_avg | bigint | 每个间隔中，镜像服务器上写系统调用写入到磁盘的平均数据量。 |
| mirror\_write\_syscall\_size\_max | bigint | 每个间隔中，镜像服务器上写系统调用写入到磁盘的最大数据量。 |
| mirror\_write\_syscall\_microsec\_avg | bigint | 每个间隔中，镜像服务器上一次写系统表用写数据到磁盘所需的平均时间。 |
| mirror\_write\_syscall\_microsec\_max | bigint | 每个间隔中，镜像服务器上一次写系统表用写数据到磁盘所需的最大时间。 |



