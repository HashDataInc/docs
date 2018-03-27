# pg\_index

pg\_index 系统目录表包含部分关于索引的信息。剩下的信息主要在 [pg\_class](./pgclass.md) 表中。

##### 表 1. pg\_catalog.pg\_index

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| indexrelid | oid | pg\_class.oid | 该索引的 pg\_class 项的 OID。 |
| indrelid | oid | pg\_class.oid | 该索引所对应的表的pg\_class项的OID。 |
| indnatts | int2 |  | 索引中的列数（与其 pg\_class.relnatts重复）。 |
| indisunique | boolean |  | 如果为真，则这是一个唯一索引。 |
| indisprimary | boolean |  | 如果为真，则这个索引表示表的主键（此属性为真时indisunique总是为真）。 |
| indisclustered | boolean |  | 如果为真，表最后一次是通过CLUSTER命令在此索引上聚簇。 |
| indisvalid | boolean |  | 如果为真，则该索引目前对查询有效。如果为假，意味着该索引目前可能不完整：它仍然必须被INSERT/UPDATE操作所修改，但是它不能被安全地用于查询。 |
| indkey | int2vector | pg\_attribute.attnum | 这是一个长度为indnatts值的数组，它指出了这个索引索引哪些表列。例如，值为1 3意味着1号、3号列组成索引键。该数组中的0表示相应的索引属性是表列上的表达式，而不是简单的列引用。 |
| indclass | oidvector | pg\_opclass.oid | 对于索引键中的每个列，它包含要使用的操作符类OID。 |
| indexprs | text |  | 非简单列引用的索引属性的表达式树（表示为 nodeToString\(\)的形式）。这是一个列表，indkey中每一个为0的元素在其中都有一项。如果所有索引属性都是简单引用，则为NULL。 |
| indpred | text |  | 用于部分索引谓词的表达式树（表示为 nodeToString\(\)的形式），如不是部分索引则为NULL。 |

**上级主题：** [系统目录定义](./README.md)
