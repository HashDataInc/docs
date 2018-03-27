# CREATE PROTOCOL

# 创建协议

注册一个自定义数据访问协议，当定义 HashData 数据库外部表时能指定该协议。

## 概要

```
CREATE [TRUSTED] PROTOCOL name (
   [readfunc='read_call_handler'] [, writefunc='write_call_handler']
   [, validatorfunc='validate_handler' ])
```

## 描述

CREATE PROTOCOL 将数据访问协议名字和负责从外部数据源读取和写入数据的处理程序相关联。

该 CREATE PROTOCOL 必须指定一个读调用程序或者一个写调用程序，在 CREATE PROTOCOL 命令中指定的调用程序必须在数据库中定义。

该协议名称可以在 CREATE EXTERNAL TABLE 命令中指定。

更多关于创建和启用数据访问协议的信息，请参阅  HashData 数据库管理员指南中的“自定义数据库访问协议的例子”。

## 参数

TRUSTED

噪声词。

name

数据访问协议的名称，协议名称大小写敏感，数据库中协议的名称必须唯一。

readfunc= 'read\_call\_handler'

之前注册函数的名称， HashData 数据库会调用该函数从外部数据源中读数据，该命令必须指定一个读调用程序或写调程序。

writefunc= 'write\_call\_handler'

之前注册函数的名称， HashData 数据库会调用该函数将数据写入到外部数据源，该命令必须指定一个读调用程序或写调用程序。

validatorfunc='validate\_handler'

可选的验证函数，该函数验证在 CREATE EXTERNAL TABLE 命令中指定的 URL。

## 注意

HashData 数据库安装自定义协议。 file, gpfdist, gpfdists, 和默认值 gphdfs 。可选择的是，s3 协议也能被安装。

任何实现了数据访问协议的共享库必须位于所有 HashData 数据库段主机的相同位置。例如，该共享库可以在由操作系统环境变量 LD\_LIBRARY\_PATH 指定的在所有主机上的位置。用户也可以指定一个位置，当用户定义处理函数的时候。例如，当用户在 CREATE PROTOCOL 命令中定义 s3 协议时候， 用户指定了 `$libdir/gps3ext.so` 作为共享对象的位置。 其中 `$libdir` 位于 `$GPHOME/lib`。

## 兼容性

CREATE PROTOCOL 是 HashData 数据库扩展。

## 另见

[ALTER PROTOCOL](./alter-protocol.md)， [CREATE EXTERNAL TABLE](./create-external-table.md)， [DROP PROTOCOL](./drop-protocol.md)

**上级话题：** [SQL命令参考](./README.md)

