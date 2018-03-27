# gp\_distribution\_policy

gp\_distribution\_policy 表包含有关 HashData 数据库表及其分布表数据的策略的信息。 该表仅在 Master 上填充。该表不是全局共享的，这意味着每个数据库都有自己的副本。

##### 表 1. pg\_catalog.gp\_distribution\_policy

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| localoid | oid | pg\_class.oid | 表对象标识符（OID）。 |
| attrnums | smallint\[\] | pg\_attribute.attnum | 分布列的编号。 |

**上级主题：** [系统目录定义](./README.md)
