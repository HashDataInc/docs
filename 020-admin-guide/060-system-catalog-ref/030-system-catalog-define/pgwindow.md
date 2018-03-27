# pg\_window

pg\_window 表存储关于窗口函数的信息。窗口函数通常用于创建复杂的 OLAP（在线分析处理）查询。窗口函数被应用到单个查询表达式的范围分区结果集。一个窗口分区是一个查询返回行的子集，由一个特定的OVER\(\)子句定义。典型的窗口函数有 rank、dense\_rank 和 row\_number。在pg\_window中每个条目是 [pg\_proc](./pgproc.md) 中一个条目的扩展。 [pg\_proc](./pgproc.md) 中的一个条目包含了窗含函数的名称、输入以及输出数据的类型以及其它同普通函数类似的信息。

##### 表 1. pg\_catalog.pg\_window

| 名称 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| winfnoid | regproc | pg\_proc.oid | 窗口函数在 pg\_proc 中的OID。 |
| winrequireorder | boolean |  | 窗口函数要求它的窗口说明有一个 ORDER BY 子句。 |
| winallowframe | boolean |  | 窗口函数允许它的窗口说明有一个 ROWS 或 RANGE 帧子句。 |
| winpeercount | boolean |  | 计算这个窗口函数要求平级分组行计数，因此 Window 节点实现必须在需要时“向前看”来保证在其中间状态中该计数可用。 |
| wincount | boolean |  | 计算该窗口函数要求分区行计数。 |
| winfunc | regproc | pg\_proc.oid | 一个计算中间类型窗口函数值的函数在 pg\_proc 中的 OID。 |
| winprefunc | regproc | pg\_proc.oid | 一个计算延迟型窗口函数的部分值的预备窗口函数在 pg\_proc 中的 OID。 |
| winpretype | oid | pg\_type.oid | 预备窗函数的结果类型在 pg\_type 中OID。 |
| winfinfunc | regproc | pg\_proc.oid | 一个从分区行计数以及 winprefunc 结果计算延迟型窗口函数最终值的函数在 pg\_proc 中的OID。 |
| winkind | char |  | 一个显示该窗口函数在一类相关函数中成员关系的字符：w - 普通的窗函数,n - NTILE函数,f - FIRST\_VALUE函数,l - LAST\_VALUE函数,g - LAG函数,d - LEAD函数 |

**上级主题：** [系统目录定义](./README.md)

