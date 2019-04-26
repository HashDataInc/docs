# pg\_attribute

该 pg\_attribute 存储关于表列的信息。数据库中每个表的每一列都正好对应 pg\_attribute 表的一行（还有有索引的属性项，以及所有有 pg\_class 项的对象的属性）。术语属性等效于列。

##### 表 1. pg\_catalog.pg\_attribute

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| attrelid | oid | pg\_class.oid | 该列所属的表 |
| attname | name |  | 列名 |
| atttypid | oid | pg\_type.oid | 该列的数据类型 |
| attstattarget | int4 |  | 控制由ANALYZE为此列积累的统计信息的详细程度。0值表示不应收集统计信息。负值表示使用系统默认的统计信息目标。正值的确切含义依赖于数据类型。对于标量数据类型，它既是要收集的“最常用值”的目标，也是要创建的柱状图的目标。 |
| attlen | int2 |  | 该列类型的pg\_type.typlen的副本。 |
| attnum | int2 |  | 列编号，普通列从1开始编号。系统列（如OID），具有（任意）负编号。 |
| attndims | int4 |  | 如果列是一个数组类型则是维度数；否则为 0（目前，数组的维数不是强制的，所以任何非0值都能有效地表示它为一个数组\)。 |
| attcacheoff | int4 |  | 在存储中始终为-1 ，但是当加载到内存中的行描述符时，这可能会被更新以缓存该属性在行中的偏移量。 |
| atttypmod | int4 |  | 记录在创建时提供的特定类型的数据（例如，varchar列的最大长度）。它被传递到特定类型的输入函数和长度强制函数。对于不需要它的类型，该值通常为-1。 |
| attbyval | boolean |  | 该列类型的pg\_type.typbval副本。 |
| attstorage | char |  | 通常是该列类型的pg\_type.typstorage副本。对于可TOAST的数据类型来说，可以在列创建之后更改这些数据类型，以控制存储策略。 |
| attalign | char |  | 该列类型的pg\_type.typalign副本 |
| attnotnull | boolean |  | 这表示一个非空约束。可以更改此列以启用或禁用该约束。 |
| atthasdef | boolean |  | 此列具有默认值，这种情况下， 将在pg\_attrdef目录中存在相应的条目实际定义默认值。 |
| attisdropped | boolean |  | 该列已被删除，不再有效。已删除的列仍然物理存在于表中，但是会被解析器忽略，所以无法通过SQL访问。 |
| attislocal | boolean |  | 该列在关系中本地定义。 请注意，列可以同时在本地定义和继承。 |
| attinhcount | int4 |  | 这列的直接祖先的数量。具有非0数量祖先的列不能被删除或重命名。 |

**上级主题：** [系统目录定义](./README.md)
