# pg\_proc

pg\_proc 系统目录表存储关于函数（或过程）的信息，包括所有的内建函数以及由 CREATE FUNCTION 定义的函数。该表也包含了聚集和窗口函数以及普通函数的数据。如果 proisagg 为真，在 pg\_aggregate 中应该有一个相匹配的行。如果 proiswin 为真，在 pg\_window 应该有一个相匹配的行。

对于编译好的函数（包括内建的和动态载入的），prosrc 包含了函数的 C 语言名字（链接符号）。对于所有其他已知的语言类型，prosrc 包含函数的源码文本。除了对于动态载入的 C 函数之外，probin 是不被使用的。对于动态载入的 C 函数，它给定了包含该函数的共享库文件的名称。

##### 表 1. pg\_catalog.pg\_proc

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| proname | name |  | 函数的名字。 |
| pronamespace | oid | pg\_namespace.oid | 函数所属的名字空间的OID。 |
| proowner | oid | pg\_authid.oid | 函数的拥有者。 |
| prolang | oid | pg\_language.oid | 该函数的实现语言或调用接口。 |
| procost | float4 |  | 估计的执行代价（以cpu\_operator\_cost为单位），如果proretset为true，这是返回每行的代价。 |
| provariadic | oid | pg\_type.oid | 可变数组参数的元素的数据类型，如果函数没有可变参数则为0。 |
| proisagg | boolean |  | 函数是否为一个聚集函数。 |
| prosecdef | boolean |  | 函数是一个安全性定义器（例如，一个"setuid"函数） |
| proisstrict | boolean |  | 当任意调用参数为空时，函数是否会返回空值。在那种情况下函数实际上根本不会被调用。非“strict”函数必须准备好处理空值输入。 |
| proretset | boolean |  | 函数是否返回一个集合（即，指定数据类型的多个值）。 |
| provolatile | char |  | 说明函数的结果是仅依赖于它的输入参数，还是会被外部因素影响。值i表示“不变的”函数，它对于相同的输入总是输出相同的结果。值s表示“稳定的”函数，它的结果（对于固定输入）在一次扫描内不会变化。值v表示“不稳定的”函数，它的结果在任何时候都可能变化（使用具有副作用，结果可能在任何时刻发生改变）。 |
| pronargs | int2 |  | 输入参数的个数。 |
| pronargdefaults | int2 |  | 具有默认值的参数个数。 |
| prorettype | oid | pg\_type.oid | 返回值的数据类型。 |
| proiswin | boolean |  | 既不是聚集函数也不是标量函数，而是一个窗口函数。 |
| proargtypes | oidvector | pg\_type.oid | 函数参数的数据类型的数组。这只包括输入参数（包括INOUT和VARIADIC参数），因此也表现了函数的调用特征。 |
| proallargtypes | oid\[\] | pg\_type.oid | 函数参数的数据类型的数组。这包括所有参数（含OUT和INOUT参数）。不过，如果所有参数都是IN参数，这个属性将为空。注意下标是从1开始，然而由于历史原因proargtypes的下标是从0开始。 |
| proargmodes | char\[\] |  | 函数参数的模式的数组：i表示IN参数，o表示OUT参数，b表示INOUT参数，v表示VARIADIC参数。如果所有的参数都是IN参数，这个属性为空。注意这里的下标对应着proallargtypes而不是proargtypes中的位置。 |
| proargnames | text\[\] |  | 函数参数的名字的数组。没有名字的参数在数组中设置为空字符串。如果没有一个参数有名字，这个属性为空。注意这里的下标对应着proallargtypes而不是proargtypes中的位置。 |
| proargdefaults | text |  | 默认值的表达式树。这是一个pronargdefaults元素的列表，对应于最后N个输入参数（即最后N个N位置）。如果没有一个参数具有默认值，这个属性为空。 |
| prosrc | text |  | 这个域告诉函数处理者如何调用该函数。它可能是针对解释型语言的实际源码、一个符号链接、一个文件名或任何其他东西，这取决于实现语言/调用规范。 |
| probin | bytea |  | 关于如何调用函数的附加信息。其解释是与语言相关的。 |
| proacl | aclitem\[\] |  | 由GRANT/REVOKE给予的函数访问特权。 |

**上级主题：** [系统目录定义](./README.md)
