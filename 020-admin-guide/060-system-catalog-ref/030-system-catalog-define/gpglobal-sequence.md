# gp\_global\_sequence

gp\_global\_sequence 表包含事务日志中的日志序列号位置，文件复制进程用它来确定要从主 Segment 复制到镜像 Segment 的文件块。

##### 表 1. pg\_catalog.gp\_global\_sequence

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| sequence\_num | bigint |  | 日志序列号在事务日志中的位置。 |

**上级主题：** [系统目录定义](./README.md)
