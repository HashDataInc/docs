# pg\_enum

该 pg\_enum 表包含与其相关联的值和标签匹配的枚举类型条目。给定枚举值的内部表示其实是 pg\_enum表中相关行的Oid。特定枚举类型的Oid保证按照应有类型排序方式进行排序， 但是不保证不相关枚举类型Oid的排序。

##### 表 1. pg\_catalog.pg\_enum

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| enumtypid | oid | pgtype.oid | 拥有此枚举类型 pg\_type 条目的Oid。 |
| enumlabel | name |  | 此枚举值的文本标签。 |

**上级主题：** [系统目录定义](./README.md)
