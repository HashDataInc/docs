# pg_shdescription

pg\_shdescription 系统目录表存储共享数据库对象的可选描述（注释）。描述可以通过 COMMENT 命令操作，并且可以使用 psql 的 \\d 元命令来查看。另见  [pg_description](./pgdescription.md) ，它对单个数据库中对象的描述提供了相似的功能。与大部分其他系统目录不同， pg\_shdescription 在 HashData 系统的所有数据库之间共享：在每一个系统中只有一份 pg\_shdescription 拷贝，而不是每个数据库一份。

##### 表 1\. pg\_catalog.pg\_shdescription

|列|类型|参考|描述|
|:---|:---|:---|:---|
|objoid|oid||任意OID列,该描述所属的对象的OID。
|classoid|oid|pg_class.oid|该对象所在系统目录的OID。
|description|text||作为该对象描述的任意文本。

**上级主题：** [系统目录定义](./README.md)