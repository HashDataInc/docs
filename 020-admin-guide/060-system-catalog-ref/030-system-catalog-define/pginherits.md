# pg\_inherits

pg\_inherits 系统目录表记录有关继承层次结构的信息。数据库中的每个直接子表在其中都有一项（间接继承可以通过 pg\_inherits 项构成的链来确定）。在 HashData 数据库中，继承关系由 INHERITS 子句（独立继承）和 CREATE TABLE 的 PARTITION BY 子句（分区子表继承）创建。

##### 表 1. pg\_catalog.pg\_inherits

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| inhrelid | oid | pg\_class.oid | 子表的OID。 |
| inhparent | oid | pg\_class.oid | 父表的OID。 |
| inhseqno | int4 |  | 如果对于一个子表有多个直接父表（多继承），则这个数字将指出被继承列的安排顺序。计数从1开始。 |

**上级主题：** [系统目录定义](./README.md)
