# pg_aggregate

pg\_aggregate 存储关于聚集函数的信息。聚集函数是对一个值集合（通常是来自于匹配某个查询条件的每个行的一个列值）进行操作并且返回从这些值计算出的一个值的函数。 典型的聚集函数是 sum、count 和 max。 pg\_aggregate 里的每个项都是一个 pg\_proc 项的扩展。pg\_proc的项记载该聚集的名字、输入输出的数据类型以及其他和普通函数类似的信息。

##### 表 1\. pg\_catalog.pg\_aggregate

|列|类型|引用|描述|
|:---|:---|:---|:---|
|aggfnoid|regproc|pg_proc.oid|聚集函数的OID
|aggtransfn|regproc|pg_proc.oid|转移函数的OID
|aggprelimfn|regproc||预备函数的OID（如果没有就为0）
|aggfinalfn|regproc|pg_proc.oid|最终函数的OID（如果没有就为0）
|agginitval|text||转移状态的初始值。这是一个文本域，它包含初始值的外部字符串表现形式。 如果这个域为NULL，则转移状态从NULL开始
|agginvtransfn|regproc|pg_proc.oid| _aggtransfn_ 的反函数在 pg_proc 中的OID
|agginvprelimfn|regproc|pg_proc.oid| _aggprelimfn_ 的反函数在pg_proc中的OID
|aggordered|Boolean||如果为true，则聚集定义为 ORDERED。
|aggsortop|oid|pg_operator.oid|相关的排序操作符的OID（如果没有则为零）
|aggtranstype|oid|pg_type.oid|聚集函数的内部转移（状态）数据的数据类型

**上级主题：** [系统目录定义](./README.md)