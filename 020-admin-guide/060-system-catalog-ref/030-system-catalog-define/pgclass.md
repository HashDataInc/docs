# pg\_class

系统目录表 pg\_class 记录表以及其他大部分具有列或者与表（也称为关系）相似的东西。这包括索引（另见 [pg\_index](./pgindex.md)）、序列、视图、组合类型和 TOAST 表。并不是所有的列对所有的关系类型都有意义。

##### 表 1. pg\_catalog.pg\_class

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| relname | name |  | 表、索引、视图等的名字。 |
| relnamespace | oid | pg\_namespace.oid | 包含这个关系的命名空间（方案）的OID |
| reltype | oid | pg\_type.oid | 如果有的话（索引为0，没有pg\_type项\)，对应与此表的行类型的数据类型的OID |
| relowner | oid | pg\_authid.oid | 关系的所有者 |
| relam | oid | pg\_am.oid | 如果这是一个索引，则表示访问方法（B树、位图、哈希等。） |
| relfilenode | oid |  | 此关系的磁盘文件的名称，如果没有则为0。 |
| reltablespace | oid | pg\_tablespace.oid | 存储此关系的表空间。如果为0，则表示数据库的默认表空间（如果关系没有磁盘文件，则无意义）。 |
| relpages | int4 |  | 该表的磁盘尺寸，以页面为单位（每页32k）。这只是规划器使用估计值。它由VACUUM、ANALYZE和一些DDL命令更新。 |
| reltuples | float4 |  | 表中的行数。这只是规划器使用的估计值。它由 VACUUM、ANALYZE和一些DDL命令更新。 |
| reltoastrelid | oid | pg\_class.oid | 与这张表关联的TOAST表的OID，没有的就为0。TOAST在一张二级表中存储普通行不能存储的大属性。 |
| reltoastidxid | oid | pg\_class.oid | 对于TOAST表，其上的索引的OID。如果不是TOAST表则为0。 |
| relaosegidxid | oid |  | 已弃用。 |
| relaosegrelid | oid |  | 已弃用。 |
| relhasindex | boolean |  | 如果这是一个表，它有（或最近有）任何索引，则为true。这由CREATE INDEX设置，但不会被DROP INDEX立刻清除。VACUUM 如果没有找到表的索引，则会清除这个属性。 |
| relisshared | boolean |  | 如果此表在系统中的所有数据库中共享，则为true。只有某些系统目录表被共享。 |
| relkind | char |  | 对象的类型,r = 堆或追加优化表， i = 索引，S = 序列，v = 视图，c = 组合类型，t = TOAST值， o = 内部的追加优化Segment文件和EOF，u = 未登记的临时堆表。 |
| relstorage | char |  | 表的存储模式,a= 追加优化，c= 列存，h = 堆， v = 虚拟，x= 外部表。 |
| relnatts | int2 |  | 关系中用户列的数量（系统列不计入）。pg\_attribute中必须有这么多个相应的项。 |
| relchecks | int2 |  | 表中检查约束的个数。 |
| reltriggers | int2 |  | 表中触发器的个数。 |
| relukeys | int2 |  | 未使用 |
| relfkeys | int2 |  | 未使用 |
| relrefs | int2 |  | 未使用 |
| relhasoids | boolean |  | 如果为关系的每一行生成OID即为真。 |
| relhaspkey | boolean |  | 如果该表有（或曾经有）主键则为真。 |
| relhasrules | boolean |  | 如果表有规则则为真 |
| relhassubclass | boolean |  | 如果表有（或曾经有）任何继承的子代，则为真。 |
| relfrozenxid | xid |  | 表中在此之前的所有事务的ID已替换为的永久（冻结）事务ID。这用于跟踪该表是否需要清理以防止事务ID回卷或允许pg\_clog收缩。如果关系不是表，则为0（InvalidTransactionId）。 |
| relacl | aclitem\[\] |  | 由GRANT和REVOKE分配的访问权限。 |
| reloptions | text\[\] |  | 访问方法相关的选项，为形如“键=值"的字符串。 |

**上级主题：** [系统目录定义](./README.md)
