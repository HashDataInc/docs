# pg\_amproc

该 pg\_amproc 表存储与索引访问操作符相关的支持过程的信息。对于属于一个操作符类的每个支持过程都有一行。

##### 表 1. pg\_catalog.pg\_amproc

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| amopclaid | oid | pg\_opclass.oid | 该条目对应的索引操作符类 |
| amprocsubtype | oid | pg\_type.oid | 如果是跨类型例程，则为子类型，否则为0 |
| amprocnum | int2 |  | 支持过程编号 |
| amproc | regproc | pg\_proc.oid | 过程的OID |

**上级主题：** [系统目录定义](./README.md)
