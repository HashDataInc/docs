# 数据类型

HashData 数据库有丰富的本地数据类型集供用户使用。 用户还可以使用 CREATE TYPE 命令定义新的数据类型。该引用显示所有的内置数据类型。除了这里列出的类型之外， 还有一些内部使用的数据类型，例如 _oid_ （对象标识符），但是在本指南中没有记录。

以下数据类型由SQL指定： _bit_, _bit varying_, _boolean_, _character varying, varchar_, _character, char_, _date_, _double precision_, _integer_, _interval_, _numeric_, _decimal_, _real_, _smallint_, _time_ （有或没有时区）和 _timestamp_ \(有或没有时区\)。

每种数据类型都具有由其输入和输出功能决定的外部表现。 许多内置类型具有明显的外部格式。 但是有些数据类型只为PostgreSQL \(和 HashData 数据库\)所用，例如几何路径，或者一些格式可能的情况， 例如日期和时间类型。一些输入和输出功能不可逆。也就是说，与原始输入相比，输出功能的结果可能会失去准确性。

表 1.  HashData 数据库内建数据类型

| Name | Alias | Size | Range | Description |
| :--- | :--- | :--- | :--- | :--- |
| bigint | int8 | 8 bytes | -922337203​6854775808 to 922337203​6854775807 | large range integer |
| bigserial | serial8 | 8 bytes | 1 to 922337203​6854775807 | large autoincrementing integer |
| bit \[ \(n\) \] |  | n bits | [bit string constant](https://www.postgresql.org/docs/8.2/static/sql-syntax.html#SQL-SYNTAX-BIT-STRINGS) | fixed-length bit string |
| bit varying \[ \(n\) \][1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) | varbit | actual number of bits | [bit string constant](https://www.postgresql.org/docs/8.2/static/sql-syntax.html#SQL-SYNTAX-BIT-STRINGS) | variable-length bit string |
| boolean | bool | 1 byte | true/false, t/f, yes/no, y/n, 1/0 | logical boolean \(true/false\) |
| box |  | 32 bytes | \(\(x1,y1\),\(x2,y2\)\) | rectangular box in the plane - not allowed in distribution key columns. |
| bytea[1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) |  | 1 byte +_binary string_ | sequence of[octets](https://www.postgresql.org/docs/8.2/static/datatype-binary.html#DATATYPE-BINARY-SQLESC) | variable-length binary string |
| character \[ \(n\) \][1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) | char \[ \(n\) \] | 1 byte +_n_ | strings up to\_n\_characters in length | fixed-length, blank padded |
| character varying \[ \(n\) \][1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) | varchar \[ \(n\) \] | 1 byte +_string size_ | strings up to\_n\_characters in length | variable-length with limit |
| cidr |  | 12 or 24 bytes |  | IPv4 and IPv6 networks |
| circle |  | 24 bytes | &lt;\(x,y\),r&gt; \(center and radius\) | circle in the plane - not allowed in distribution key columns. |
| date |  | 4 bytes | 4713 BC - 294,277 AD | calendar date \(year, month, day\) |
| decimal \[ \(p, s\) \][1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) | numeric \[ \(p, s\) \] | variable | no limit | user-specified precision, exact |
| double precision | float8float | 8 bytes | 15 decimal digits precision | variable-precision, inexact |
| inet |  | 12 or 24 bytes |  | IPv4 and IPv6 hosts and networks |
| integer | int, int4 | 4 bytes | -2147483648 to +2147483647 | usual choice for integer |
| interval \[ \(p\) \] |  | 12 bytes | -178000000 years - 178000000 years | time span |
| lseg |  | 32 bytes | \(\(x1,y1\),\(x2,y2\)\) | line segment in the plane - not allowed in distribution key columns. |
| macaddr |  | 6 bytes |  | MAC addresses |
| money |  | 4 bytes | -21474836.48 to +21474836.47 | currency amount |
| path[1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) |  | 16+16n bytes | \[\(x1,y1\),...\] | geometric path in the plane - not allowed in distribution key columns. |
| point |  | 16 bytes | \(x,y\) | geometric point in the plane - not allowed in distribution key columns. |
| polygon |  | 40+16n bytes | \(\(x1,y1\),...\) | closed geometric path in the plane - not allowed in distribution key columns. |
| real | float4 | 4 bytes | 6 decimal digits precision | variable-precision, inexact |
| serial | serial4 | 4 bytes | 1 to 2147483647 | autoincrementing integer |
| smallint | int2 | 2 bytes | -32768 to +32767 | small range integer |
| text[1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) |  | 1 byte +_string size_ | strings of any length | variable unlimited length |
| time \[ \(p\) \] \[ without time zone \] |  | 8 bytes | 00:00:00\[.000000\] - 24:00:00\[.000000\] | time of day only |
| time \[ \(p\) \] with time zone | timetz | 12 bytes | 00:00:00+1359 - 24:00:00-1359 | time of day only, with time zone |
| timestamp \[ \(p\) \] \[ without time zone \] |  | 8 bytes | 4713 BC - 294,277 AD | both date and time |
| timestamp \[ \(p\) \] with time zone | timestamptz | 8 bytes | 4713 BC - 294,277 AD | both date and time, with time zone |
| xml[1](http://gpdb.docs.pivotal.io/43170/ref_guide/data_types.html#topic1__if139219) |  | 1 byte +_xml size_ | xml of any length | variable unlimited length |

## 伪类型

HashData 数据库支持统称为 _伪类型_的专用数据类型项。 伪类型不能用作列数据类型，但可以用于声明函数的参数或结果类型。每个可用的伪类型在函数的行为与简单地取得或返回特定SQL数据类型的值不对应的情况下很有用。

以程序语言编码的函数只能使用其实现语言所允许的伪类型。 程序语言都禁止使用伪类型作为参数类型，并且只允许使用 _void_ 和 _record_作为结果类型。

伪类型_记录_ 作为返回数据类型的函数返回未指定的行类型。 该 _记录_ 表示可能是匿名复合类型的数组。由于 复合数据带有自己的类型识别，因此在数组级别不需要额外的知识。

伪类型_void_ 表示函数无返回值。

> 注解：  HashData 数据库不支持触发器和伪类型 _触发器_。

types _anyelement_, _anyarray_, _anynonarray_, 和 _anyenum_ 多态类型的伪类型。 一些程序语言还支持使用类型 _anyarray_, _anyelement_, _anyenum_, 和 _anynonarray_的多态函数。

有关伪类型的更多信息， 请参阅有关 [伪类型](https://www.postgresql.org/docs/8.3/static/datatype-pseudo.html)的Postgres文档。

## 多态类型

特别有趣的四种伪类型是 _anyelement_, _anyarray_, _anynonarray_, 和 _anyenum_, 它们统称为_多态_ 类型。使用这些类型声明的任何函数都被称为多态函数。一个多态函数可以对许多不同的数据类型进行操作，特定数据类型由在运行时实际传递给它的数据类型确定。

当一个调用多态函数的查询被解析时，多态参数和结果会被绑在一起并且解析为一种特定的数据类型。声明为 _anyelement_ 的每个位置（参数或返回值）声明为anyelement的每个位置（参数或返回值）都被允许具有任何特定的实际数据类型，但在任何给定的调用中，它们必须都是相同的实际类型 声明为_anyarray_ c的每个位置都可以有任何数组数据类型，但类似地，它们必须都是相同的类型。 如果有声明为_anyarray_也有声明为 _anyelement_， 则再_anyarray_ 位置中的实际数组类型 必须是一个数组的，其元素在_anyelement_ 位置上显示相同的类型。 _anynonarray_ 被视为与 _anyelement_完全相同，但添加了实际类型不能是数组类型的附加约束。_anyenum_ 被视为与_anyelement_完全相同，但添加的实际类型必须是 enum类型的约束。

当多个参数位置被声明为多态类型时，net效果是仅允许实际参数类型的某些组合。 例如，一个声明为equal\(_anyelement_, _anyelement_\)的函数只要具有相同的数据类型，就可以使用任何两个输入值。

当函数的返回值被声明为多态类型时，还必须至少有一个参数位置也是多态的，并且作为参数提供的实际数据类型确定该调用的实际结果类型。 例如，如果没有数组下标机制，可以定义一个实现下标的函数 subscript\(_anyarray_, integer\) 返回 _anyelement_。此声明将实际的第一个参数限制为数组类型，并允许解析器从实际的第一个参数的类型推断出正确的结果类型。另一个例子是一个声明的函数 myfunc\(_anyarray_\) returns _anyenum_ 将只接受数组enum 类型。

请注意，_anynonarray_ 和_anyenum_ 不代表单独的类型变量; 它们与_anyelement_类型相同，只是附加约束。 例如，声明函数为 myfunc\(_anyelement_, _anyenum_\) 相当于将其声明为 myfunc\(_anyenum_, _anyenum_\): 两个实际参数必须相同 enum 类型。

当其最后一个参数被声明为一个可变函数（一个取可变数量的参数）是多态的VARIADIC _anyarray_。为了参数匹配和确定实际的结果类型， 这样的函数的行为与用户已经声明了适当数量的 _anynonarray_ 参数的行为相同。

有关多态类型的更多信息，请参阅有关 [多态参数和返回类型](https://www.postgresql.org/docs/8.3/static/xfunc-c.html#AEN41553)的Postgres文档。

**上级标题：**  [HashData 数据库参考指南](./README.md)

1 对于可变长度数据类型，如果数据大于等于127字节，存储开销是每个字节需要4个字节存储。

