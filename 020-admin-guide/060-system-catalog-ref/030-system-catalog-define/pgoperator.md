# pg\_operator

系统目录表pg\_operator存储关于操作符的信息，包括内建的和通过CREATE OPERATOR语句定义的操作符。未用的列包含零值。例如，一个前缀操作符的oprleft为0。

##### 表 1. pg\_catalog.pg\_operator

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| oprname | name |  | 操作符的名称。 |
| oprnamespace | oid | pg\_namespace.oid | 操作符所属的名字空间的OID。 |
| oprowner | oid | pg\_authid.oid | 操作符的拥有者。 |
| oprkind | char |  | b = 中缀 \(前缀和后缀\)，l = 前缀 \("左"\)，r = 后缀 \("右"\) |
| oprcanhash | boolean |  | 该操作符是否支持哈希连接。 |
| oprleft | oid | pg\_type.oid | 左操作数类型。 |
| oprright | oid | pg\_type.oid | 右操作数类型。 |
| oprresult | oid | pg\_type.oid | 结果类型。 |
| oprcom | oid | pg\_operator.oid | 该操作符的交换子（如果存在）。 |
| oprnegate |  | pg\_operator.oid | 该操作符的求反器（如果存在）。 |
| oprlsortop | oid | pg\_operator.oid | 如果该操作符支持归并连接，这个属性记录排序左操作数类型的操作符（L<L）。 |
| oprrsortop | oid | pg\_operator.oid | 如果该操作符支持归并连接，这个属性记录排序右操作数类型的操作符（R<R）。 |
| oprltcmpop | oid | pg\_operator.oid | 如果该操作符支持归并连接，这个属性记录比较左右操作数的小于操作符（L<R）。 |
| oprgtcmpop | oid | pg\_operator.oid | 如果该操作符支持归并连接，这个属性记录比较左右操作数的小于操作符（L>R）。 |
| oprcode | regproc | pg\_proc.oid | 实现该操作符的函数。 |
| oprrest | regproc | pg\_proc.oid | 该操作符的限制选择度估算函数。 |
| oprjoin | regproc | pg\_proc.oid | 该操作符的连接选择度估算函数。 |

**上级主题：** [系统目录定义](./README.md)
