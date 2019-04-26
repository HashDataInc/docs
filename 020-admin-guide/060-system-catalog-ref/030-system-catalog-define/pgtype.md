# pg\_type

pg\_type 系统目录表存储有关数据类型的信息。基类（标量类型）由CREATE TYPE创建。而域由CREATE DOMAIN创建。数据库中的每一个表都会有一个自动创建的组合类型，用于表示表的行结构。也可以使用CREATE TYPE AS 创建组合类型。

##### 表 1. pg\_catalog.pg\_type

| 名称 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| typname | name |  | 数据类型的名字。 |
| typnamespace | oid | pg\_namespace.oid | 包含此类型的名字空间的OID。 |
| typowner | oid | pg\_authid.oid | 类型的拥有者。 |
| typlen | int2 |  | 对于一个固定尺寸的类型，typlen是该类型内部表示的字节数。对于一个变长类型，typlen为负值。-1表示一个“varlena”类型（具有长度字），-2表示一个以空值结尾的C字符串。 |
| typbyval | boolean |  | typbyval 决定内部例程传递这个类型的数值时是通过传值还是传引用方式。如果typlen不是1、2或4（或者在Datum为8字节的机器上为8），typbyval最好是假。变长类型总是传引用。注意即使长度允许传值，typbyval也可以为假；例如，当前对于类型float4这个属性为真。 |
| typtype | char |  | b表示基类，c表示组合类型（例如一个表的行类型），d表示域，e表示枚举类型，p表示伪类型。 |
| typisdefined | boolean |  | 如果此类型已被定义则为真，如果此类型只是一个表示还未定义类型的占位符则为假。当typisdefined为假，除了类型名字、名字空间和OID之外什么都不能被依赖。 |
| typdelim | char |  | 在分析数组输入时，分隔两个此类型值的字符。注意该分隔符是与数组元素数据类型相关联的， 而不是和数组的数据类型关联。 |
| typrelid | oid | pg\_class.oid | 如果这是一个组合类型， 那么这个列指向pg\_class中定义对应表的项（对于自由存在的组合类型，pg\_class项并不表示一个表，但不管怎样该类型的pg\_attribute项需要链接到它）。对非组合类型此列为零。 |
| typelem | oid | pg\_type.oid | 如果typelem不为0，则它标识pg\_type里面的另外一行。 当前类型可以被加上下标得到一个值为类型typelem的数组来描述。 一个"真的"数组类型是变长的（typlen = -1），但是一些定长的（tylpen &gt; 0）类型也拥有非零的typelem，比如name和point。 如果一个定长类型拥有一个typelem， 则它的内部形式必须是某个typelem数据类型的值，不能有其它数据。变长数组类型有一个由该数组子例程定义的头。 |
| typinput | regproc | pg\_proc.oid | 输入转换函数（文本格式）。 |
| typoutput | regproc | pg\_proc.oid | 输出转换函数（文本格式）。 |
| typreceive | regproc | pg\_proc.oid | 输入转换函数（二进制格式），如果没有则为0。 |
| typsend | regproc | pg\_proc.oid | 输出转换函数（二进制格式），如果没有则为0。 |
| typmodin | regproc | pg\_proc.oid | 类型修改器输入函数，如果类型没有提供修改器则为0 |
| typmodout | regproc | pg\_proc.oid | 类型修改器输出函数，如果类型没有提供修改器则为0。 |
| typanalyze | regproc | pg\_proc.oid | 自定义 ANALYZE 函数，0表示使用标准函数。 |
| typalign | char |  | typalign 是当存储此类型值时要求的对齐性质。它应用于磁盘存储以及该值在 Greenplum内部的大多数表现形式。 如果多个值是连续存放的，比如在磁盘上的一个完整行，在这种类型的数据前会插入填充，这样它就可以按照指定边界存储。 对齐引用是该序列中第一个数据的开头。对齐引用是序列中第一个数据的开始。可能的值有：c = char对齐，即不需要对齐。s = short对齐（在大部分机器上为2字节）。i = int对齐（在大部分机器上为4字节）。d = double对齐（在很多机器上为8字节，但绝不是全部）。 |
| typstorage | char |  | 如果一个变长类型（typlen = -1）可被TOAST，typstorage说明这种类型的列应采取的默认策略。可能的值是：p: 值必须平面存储。e: 值可以被存储在一个"二级"关系 如果有，见pg\_class.reltoastrelid\)。m:值可以被压缩线内存储。x: 值可以被压缩线内存储或存储在"二级"存储。注意： m 列也可以被移动到二级存储，但只能是作为最后一种方案 \(e 和 x列会先被移动）。 |
| typnotnull | boolean |  | 表示类型上的一个非空约束。只用于域。 |
| typbasetype | oid | pg\_type.oid | 标识这个域基于的类型。如果此类不是一个域则为0。 |
| typtypmod | int4 |  | 域使用typtypmod来记录被应用于它们基类型的typmod（如果基类型不使用typmod，则为-1）。如果此类型不是一个域则为-1。 |
| typndims | int4 |  | 对于一个数组上的域，typndims是数组维度数（如果，typbasetype是一个数组类型；域的typelem会匹配基类型的typelem）。除数组类型上的域之外的类型的此列为0。 |
| typdefaultbin | text |  | 如果typdefaultbin为非空，那么它是 该类型默认表达式的nodeToString\(\)表现形式。这个列只用于域。 |
| typdefault | text |  | 如果某类型没有相关默认值，那么typdefault为空。如果typdefaultbin不为空， 那么typdefault必须包含一个typdefaultbin所指的默认表达式的人类可读的版本。 如果typdefaultbin为空但typdefault不为空，则typdefault是该类型默认值的外部表现形式， 它可以被交给该类型的输入转换器来产生一个常量。 |

**上级主题：** [系统目录定义](./README.md)

