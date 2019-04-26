# pg_tablespace

pg\_tablespace 系统目录表存储关于可用表空间的信息。 表可以被放置在特定表空间中以实现磁盘布局的管理。与大部分其他系统目录不同，pg\_tablespace 在 HashData 系统的所有数据库之间共享：在每一个系统中只有一份 pg\_tablespace 的拷贝，而不是每个数据库一份。

##### 表 1\. pg\_catalog.pg\_tablespace

|列|类型|参考|描述|
|:---|:---|:---|:---|
|spcname|name||表空间名。
|spcowner|oid|pg_authid.oid|表空间的拥有者，通常是创建它的用户。
|spclocation|text\[\]||已弃用。
|spcacl|aclitem\[\]||访问权限。
|spcprilocations|text\[\]||不赞成。
|spcmrilocations|text\[\]||不赞成。
|spcfsoid|oid|pg_filespace.oid|被该表空间使用的文件空间的对象ID。一个文件空间定义在Master、主Segment和镜像Segment上的目录位置。

**上级主题：** [系统目录定义](./README.md)