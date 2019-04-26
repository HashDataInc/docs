# pg\_compression

该 pg\_compression 系统目录表描述了可用的压缩方法。

##### 表 1. pg\_catalog.pg\_compression

| 列 | 类型 | 修饰符 | 存储 | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| compname | name | not null | plain | 压缩的名字 |
| compconstructor | regproc | not null | plain | 压缩构造函数的名称 |
| compdestructor | regproc | not null | plain | 压缩销毁函数的名称 |
| compcompressor | regproc | not null | plain | 压缩机的名称 |
| compdecompressor | regproc | not null | plain | 解压缩器的名称 |
| compvalidator | regproc | not null | plain | 压缩验证器的名称 |
| compowner | oid | not null | plain | 来自pg\_authid的Oid |

**上级主题：** [系统目录定义](./README.md)
