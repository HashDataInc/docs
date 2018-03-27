# pg\_largeobject

pg\_largeobject 系统目录表保存构成“大对象”的数据。大对象由创建时分配的 OID 来识别。每个大对象被分解成便于在 pg\_largeobject 表中储存为行的足够小的段或者“页”。每页的数据量被定义为LOBLKSIZE（当前是 BLCKSZ/4，或者通常是 8K）。

pg\_largeobject 的每一行都保存一个大对象的一个页，从对象内的字节偏移量（ _pageno_ \* LOBLKSIZE）开始。该实现允许稀疏存储：页面可以丢失，并且即使它们不是对象的最后一页也可能比 LOBLKSIZE 字节更短。大对象中缺少的区域被读作0。

##### 表 1. pg\_catalog.pg\_largeobject

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| loid | oid |  | 包含这一页的大对象的标识符。 |
| pageno | int4 |  | 大对象中该页的页号（从0开始计数）。 |
| data | bytea |  | 存储在大对象中的实际数据。该数据不会超过LOBLKSIZE字节数而且可能会更小。 |

**上级主题：** [系统目录定义](./README.md)
