# 字段顺序和字节对齐
为了获得最佳性能，建议对表的字段顺序进行调整以实现数据类型的字节对齐。对堆表使用下面的顺序：

1. 分布键和分区键
1. 固定长度的数值类型
1. 可变长度的数据类型

从大到小布局数据类型，BIGINT 和 TIMESTAMP 在 INT 和 DATE 类型之前，TEXT，VARCHAR 和 NUMERIC(x,y) 位于后面。例如首先定义 8 字节的类型（BIGINT，TIMESTAMP）字段，然后是 4 字节类型（INT，DATE），随后是 2 字节类型（SMALLINT），最后是可变长度数据类型（VARCHAR）。 如果你的字段定义如下：

```
Int, Bigint, Timestamp, Bigint, Timestamp, Int (分布键), Date (分区键), Bigint,Smallint
```
则建议调整为：

```
Int (分布键), Date (分区键), Bigint, Bigint, Bigint, Timestamp, Timestamp, Int, Smallint
```