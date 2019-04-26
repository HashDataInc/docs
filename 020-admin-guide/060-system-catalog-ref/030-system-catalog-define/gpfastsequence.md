# gp\_fastsequence

gp\_fastsequence 表包含有关追加优化表和列存表的信息。last\_sequence 值表示该表当前使用的最大行号。

##### 表 1. pg\_catalog.gp\_fastsequence

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| objid | oid | pg\_class.oid | 用于跟踪追加优化文件段的pg\_aoseg.pg\_aocsseg\_\*表的对象ID。 |
| objmod | bigint |  | 对象修饰符。 |
| last\_sequence | bigint |  | 对象使用的最后一个序列号。 |

**上级主题：** [系统目录定义](./README.md)
