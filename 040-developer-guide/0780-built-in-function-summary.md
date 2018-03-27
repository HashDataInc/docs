# 内置函数摘要

HashData 数据库支持内置函数和操作符，包括可用于窗口表达式的分析函数和窗口函数。有关使用内置 HashData 数据库函数的信息，参阅 HashData 数据库管理员指南中的 “使用函数和操作符”。

* [HashData 数据库函数类型](#tip1)
* [内建函数和操作符](#tip2)
* [JSON 函数和操作符](#tip3)
* [窗口函数](#tip4)
* [高级聚集函数](#tip5)

**上级主题：**  [HashData 数据库参考指南](./README.md)

## <h2 id ='tip1'> HashData 数据库函数类型

HashData 数据库评估 SQL 表达式中使用的函数和操作符。一些函数和操作符只允许在主机上执行，因为它们可能会导致 HashData 数据库段实例不一致。本表介绍了 HashData 数据库函数类型。

##### <h5 id='tab5'>表 1. HashData 数据库中的函数

| 函数类型 | HashData 是否支持 | 描述 | 注释 |
| :--- | :--- | :--- | :--- |
| IMMUTABLE | 是 | 仅依赖于其参数列表中的信息。给定相同的参数值，始终返回相同的结果。 |  |
| STABLE | 在大多数情况下是的 | 在单个表扫描中，对相同的参数值返回相同的结果，但结果将通过 SQL 语句进行更改。 | 结果取决于数据库查找或参数值。 current\_timestamp 系列函数是 STABLE; 值在执行中不会改变。 |
| VOLATILE | 受限制的 | 函数值可以在单个表扫描中更改。 例如: random\(\), currval\(\), timeofday\(\). | 任何具有副作用的函数的都不稳定的，即使其结果是可预测的。例如: setval\(\). |

在 HashData 数据库中，数据通过字段被区分——没一个字段是一个独立的 Postgres 数据库。为了防止不一致或意外的结果，如果它们包含 SQL 命令或以任何方式修改数据库， 则不要在该子段级别执行分类为 VOLATILE 的函数。例如， 不允许在 HashData 数据库中的分布式数据上执行 setval\(\) 等函数，因为它们可能导致段实例之间的数据不一致。

为了确保数据的一致性，用户可以在主服务器上计算和运行的语句中安全地使用 VOLATILE 和 STABLE 函数。 例如，以下语句在 master 上运行\(没有 FROM 子句的语句\):

```
SELECT setval('myseq', 201);
SELECT foo();
```

如果语句具有包含分布式表的 FROM 子句，并且 FROM 子句中的函数返回一组行，则语句可以在字段上运行：

```
SELECT * from foo();
```

HashData 数据库不支持返回表引用函数 \(rangeFuncs\) 或使用 refCursor 数据类型的函数。

## <h2 id ='tip2'> 内建函数和操作符

下表列出了 PostgreSQL 支持的内置函数和操作符的类别。除了 STABLE 和 VOLATILE 函数外, postgreSQL 中的所有函数和操作符在 HashData 数据库中都被支持，但是他们 受到  [HashData 数据库函数类型](#hashdata-数据库函数类型) 中所述的限制。 有关这些内置函数和操作符的更多信息，请参阅 PostgreSQL 文档的 Functions and Operators 部分。

##### <h5 id='tab2'> 表 2. 内建函数和操作符

| 操作符/函数类别 | VOLATILE 函数 | STABLE 函数 | 限制 |
| :--- | :--- | :--- | :--- |
| [逻辑操作符](https://www.postgresql.org/docs/8.3/static/functions.html#FUNCTIONS-LOGICAL) |  |  |  |
| [比较操作符](https://www.postgresql.org/docs/8.3/static/functions-comparison.html) |  |  |  |
| [数学函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-math.html) | random setseed |  |  |
| [字符串函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-string.html) | 所有内建转换函数 | convert pg\_client\_encoding |  |
| [二进制字符串函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-binarystring.html) |  |  |  |
| [位串函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-bitstring.html) |  |  |  |
| [模式匹配](http://www.postgresql.org/docs/8.3/static/functions-matching.html) |  |  |  |
| [数据类型格式化功能](https://www.postgresql.org/docs/8.3/static/functions-formatting.html) |  | to\_char to\_timestamp |  |
| [日期/时间函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-datetime.html) | timeofday | age current\_date current\_time current\_timestamp localtime localtimestamp now |  |
| [枚举支持功能](https://www.postgresql.org/docs/8.3/static/functions-enum.html) |  |  |  |
| [几何函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-geometry.html) |  |  |  |
| [网络地址功能和操作符](https://www.postgresql.org/docs/8.3/static/functions-net.html) |  |  |  |
| [序列操作功能](https://www.postgresql.org/docs/8.3/static/functions-sequence.html) | currval lastval nextval setval |  |  |
| [条件表达式](https://www.postgresql.org/docs/8.3/static/functions-conditional.html) |  |  |  |
| [数组函数和操作符](https://www.postgresql.org/docs/8.3/static/functions-array.html) |  | 所有数组函数 |  |
| [聚合函数](https://www.postgresql.org/docs/8.3/static/functions-aggregate.html) |  |  |  |
| [子查询表达式](https://www.postgresql.org/docs/8.3/static/functions-subquery.html) |  |  |  |
| [行和数组比较](https://www.postgresql.org/docs/8.3/static/functions-comparisons.html) |  |  |  |
| [设置返回功能](https://www.postgresql.org/docs/8.3/static/functions-srf.html) | generate\_series |  |  |
| [系统信息功能](https://www.postgresql.org/docs/8.3/static/functions-info.html) |  | 所有会话信息函数 所有访问特权查询函数 所有方案可见性查询函数 所有系统目录信息函数 所有注释信息函数 所有事务ID和快照 |  |
| [系统管理功能](https://www.postgresql.org/docs/8.3/static/functions-admin.html) | set\_config pg\_cancel\_backend pg\_reload\_conf pg\_rotate\_logfile pg\_start\_backup pg\_stop\_backup pg\_size\_pretty pg\_ls\_dir pg\_read\_file pg\_stat\_file | current\_setting 所有数据库对象尺寸函数 | 注意：函数pg\_column\_size 显示存储值所需的字节，可能使用 TOAST 压缩。 |
| [XML 函数](http://www.postgresql.org/docs/9.1/interactive/functions-xml.html)和类似函数的表达式 |  | xmlagg\(xml\) xmlexists\(text, xml\) xml\_is\_well\_formed\(text\) xml\_is\_well\_formed\_document\(text\) xml\_is\_well\_formed\_content\(text\) xpath\(text, xml\) xpath\(text, xml, text\[\]\) xpath\_exists\(text, xml\) xpath\_exists\(text, xml, text\[\]\) xml\(text\) text\(xml\) xmlcomment\(xml\) xmlconcat2\(xml, xml\) |  |

## <h2 id ='tip3'> JSON函数和操作符

用于创建和操作 JSON 数据的内置函数和操作符。

* [JSON 操作符](#json-操作符)
* [JSON 创建函数](#json-创建函数)
* [JSON 处理功能](#json-处理函数)

> 注解： 对于 json 的值， 对象包含重复的键/值对，也保留所有键/值对。处理功能将最后一个值视为可操作的。

### JSON 操作符

该表描述了可用于的操作符 json 的数据类型。

##### <h5 id='tab3'> 表 3. json 操作符

| 操作符 | 右操作数类型 | 描述 | 示例 | 示例结果 |
| :--- | :--- | :--- | :--- | :--- |
| -> | int | 获取 JSON 数组元素（从零索引）。 | '\[{"a":"foo"},{"b":"bar"},{"c":"baz"}\]'::json->2 | {"c":"baz"} |
| -> | text | 通过键获取JSON对象字段。 | '{"a": {"b":"foo"}}'::json->'a' | {"b":"foo"} |
| ->> | int | 获取JSON数组元素作为文本。 | '\[1,2,3\]'::json->>2 | 3 |
| ->> | text | 获取JSON对象字段作为文本。 | '{"a":1,"b":2}'::json->>'b' | 2 |
| \#> | text\[\] | 在指定的路径获取JSON对象。 | '{"a": {"b":{"c": "foo"}}}'::json\#>'{a,b}' | {"c": "foo"} |
| \#>> | text\[\] | 以指定路径获取JSON对象作为文本。 | '{"a":\[1,2,3\],"b":\[4,5,6\]}'::json\#>>'{a,2}' | 3 |

### JSON 创建函数

此表描述了创建的函数的 json 值。

##### <h5 id='tab4'> 表 4. JSON 创建函数

| 函数 | 描述 | 示例 | 示例结果 |
| :--- | :--- | :--- | :--- |
| to\_json\(anyelement\) | 将值作为有效的 JSON 对象返回。数组和复合类型被递归处理并转换为数组和对象。 如果输入包含类型为 json 的造型, 则使用造型函数执行转换; 否则，将生成 JSON 标量值。对于除数字，布尔值或空值之外的任何标量类型，将使用文本表示，正确引用和转义，以使其为有效的 JSON 字符串。 | `to_json('Fred said "Hi."'::text)` | `"Fred said "Hi.""` |
| array\_to\_json(anyarray [, pretty_bool]) | 将数组作为JSON数组返回。 HashData 数据库的多维数组成为数组的JSON数组。如果 pretty\_bool 是 true，则在第一个元素之间添加换行符。 | array\_to\_json('\{\{1,5\},\{99,100\}\}'::int[]) | `[[1,5],[99,100]]` |
| `row_to_json(record [,pretty_bool])` | 将该行作为 JSON 对象返回。如果 elements if pretty\_bool 是 true 则在第 1 级元素之间添加换行符。 | `row_to_json(row(1,'foo'))` | `{"f1":1,"f2":"foo"}` |

> 注解：除了提供精细打印选项外，array\_to\_json 和 row\_to\_json 具有与 to\_json 相同的行为。 对于 to\_json 描述的行为也适用于由其他 JSON 创建函数转换的单个值。

### JSON 处理函数

此表描述处理 json 值的函数。

##### <h5 id='tab5'> 表 5. JSON 处理函数

| 函数 | 返回类型 | 描述 | 示例 | 示例结果 |
| :--- | :--- | :--- | :--- | :--- |
| json\_each\(json\) | set of key text, value json set of key text, value jsonb | 将最外层的JSON对象扩展为一组键/值对。 | `select * from json_each('{"a":"foo", "b":"bar"}')` | `a:"foo" b:"bar"` |
| json\_each\_text\(json\) | setof key text, value text | 将最外层的JSON对象扩展为一组键/值对。返回的值是类型 text。 | `select * from json_each_text('{"a":"foo", "b":"bar"}')` | `a:foo b:bar` |
| json\_extract\_path\(from\_json json, VARIADIC path\_elems text\[\]\) | json | 返回指定为的JSON值 path\_elems。 相当于 \#> 操作符。 | `json_extract_path('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}','f4')` | `{"f5":99,"f6":"foo"}` |
| json\_extract\_path\_text\(from\_json json, VARIADIC path\_elems text\[\]\) | text | 返回指定为的JSON值path\_elems 作为文本。 相当于 \#>> 操作符。 | `json_extract_path_text('{"f2":{"f3":1},"f4":{"f5":99,"f6":"foo"}}','f4', 'f6')` | foo |
| json\_object\_keys\(json\) | setof text | 返回最外层JSON对象中的键集。 | `json_object_keys('{"f1":"abc","f2":{"f3":"a", "f4":"b"}}')` | `json_object_keys:f1 f2` |
| json\_populate\_record\(base anyelement, from\_json json\) | anyelement | 扩展对象 from\_json 其列与由 base 定义的记录类型匹配。 | `select * from json_populate_record(null::myrowtype, '{"a":1,"b":2}')` | `a:1 b:2` |
| json\_populate\_recordset\(base anyelement, from\_json json\) | setof anyelement | 扩展最外层的对象数组 from\_json 到一组行，其列与定义的记录类型 base 相匹配 。 | `select * from json_populate_recordset(null::myrowtype, '[{"a":1,"b":2},{"a":3,"b":4}]')` | `a:1,3 b:2,4` |
| json\_array\_elements\(json\) | setof json | 将JSON数组扩展为一组JSON值。 | `select * from json_array_elements('[1,true, [2,false]]')` | `value:1 , true ,[2,false]` |

> 注意： 许多这些函数和操作符将 Unicode字符串中的 Unicode 转义转换为常规字符。这些函数为不能在数据库编码中表示的字符引发错误。

对于 json\_populate\_record 和 json\_populate\_recordset，从 JSON 类型强制是尽力而为，可能不会导致某些类型的期望值。JSON 键与目标行类型中的相同列名匹配。输出中不会出现未显示在目标行类型中的 JSON 字段， 并且不匹配任何 JSON 字段的目标列返回 NULL。

## <h2 id ='tip4'> 窗口函数

以下内置窗口函数是 PostgreSQL 数据库的 HashData 扩展。所有窗口函数都是不可变的。有关窗口函数的更多信息，请参阅 HashData 数据库管理员指南。

##### <h5 id='tab6'> 表 6. 窗口函数

| 函数 | 返回类型 | 完整语法 | 描述 |
| :--- | :--- | :--- | :--- |
| cume\_dist\(\) | double precision | CUME\_DIST\(\) OVER \( \[PARTITION BY expr \] ORDER BY expr \) | 计算一组值中的值的累积分布。具有相等值的行总是计算相同的累积分布值。 |
| dense\_rank\(\) | bigint | DENSE\_RANK \(\) OVER \( \[PARTITION BY expr \] ORDER BY expr \) | 计算有序的一组行中的行的排名，而不跳过排名。具有相等值的行具有相同的等级值。 |
| first\_value\(expr\) | same as input expr type | FIRST\_VALUE\( expr \) OVER \( \[PARTITION BY expr \] ORDER BY expr \[ROWS RANGE frame\_expr \] \) | 返回有序值集中的第一个值。 |
| lag\(expr \[,offset\] \[,default\]\) | same as input expr type | LAG\( expr \[, offset \] \[, default \]\) OVER \( \[PARTITION BY expr \] ORDER BY expr \) | 提供访问同一个表的多行，而不进行自我连接。 给定从查询返回的一系列行和光标的位置， LAG在该位置之前提供对给定物理偏移量的行的访问。默认 offset 是1. 默认设置如果偏移量超出窗口范围则返回的值。 如果默认没被指定，默认值为null。 |
| last\_value\(expr\) | same as input expr type | LAST\_VALUE\(expr\) OVER \( \[PARTITION BY expr\] ORDER BY expr \[ROWS  RANGE frameexpr\] \) | 返回有序值集中的最后一个值。 |
| lead\(expr \[,offset\] \[,default\]\) | same as input expr type | LEAD\(expr \[,offset\] \[,expr default\]\) OVER \( \[PARTITION BY expr\] ORDER BY expr \) | 提供访问同一个表的多行，而不进行自我连接。给定从查询返回的一系列行和光标的位置， lead 在该位置之后提供对给定物理偏移量的行的访问。 如果未指定_偏移量_ ， 则默认偏移量为 1。默认设置如果偏移超出窗口范围则返回的值。 If 默认如果没被指定，默认值为 null. |
| ntile\(expr\) | bigint | NTILE\(expr\) OVER \( \[PARTITION BY expr\] ORDER BY expr \) | 将有序数据集划分为多个桶 \(由 expr定义\) 并为每一行分配一个桶号。 |
| percent\_rank\(\) | double precision | PERCENT\_RANK \(\) OVER \( \[PARTITION BY expr\] ORDER BY expr \) | 计算假设行的排名 R 减1， 除了被评估的行数（在窗口分区内）除以1。 |
| rank\(\) | bigint | RANK \(\) OVER \( \[PARTITION BY expr\] ORDER BY expr \) | 计算有序的一组值中的一行的排名。排名标准相等值的行获得相同的排名。绑定行的数量被添加到等级号以计算下一个等级值。在这种情况下，排名可能不是连续的数字。 |
| row\_number\(\) | bigint | ROW\_NUMBER \(\) OVER \( \[PARTITION BY expr\] ORDER BY expr \) | 为其应用的每一行分配唯一的编号（窗口分区中的每一行或查询的每一行）。 |

## <h2 id ='tip5'> 高级聚集函数

以下内置的高级分析功能是 PostgreSQL 数据库的 HashData 扩展。分析功能是不可变的。

> 注意：用于分析的 HashData  MADlib 扩展提供了其他高级功能，可以使用 HashData 数据库数据执行统计分析和机器学习。请参阅 [用于分析的 HashData MADlib 扩展](./07910-yong-yu-fen-xi-de-hashdata-madlib-kuo-zhan.md)。

##### <h5 id='tab7'> 表 7. 高级聚集函数

| 函数 | 返回类型 | 完整语法 | 描述 |
| :--- | :--- | :--- | :--- |
| MEDIAN \(expr\) | timestamp, timestamptz, interval, float | MEDIAN \(expression\)\|Example:SELECT department\_id, MEDIAN\(salary\) FROM employees GROUP BY department\_id; | 可以采用二维数组作为输入。将这样的数组视为矩阵。 |
| PERCENTILE\_CONT \(expr\) WITHIN GROUP \(ORDER BY expr \[DESC/ASC\]\) | timestamp, timestamptz, interval, float | PERCENTILE\_CONT\(percentage\) WITHIN GROUP \(ORDER BY expression\) Example:SELECT department\_id,PERCENTILE\_CONT \(0.5\) WITHIN GROUP \(ORDER BY salary DESC\) "Median\_cont"; FROM employees GROUP BY department\_id; | 执行假定连续分布模型的逆分布函数。它需要百分位数值和排序规范，并返回与参数的数字数据类型相同的数据类型。该返回值是执行线性插值后的计算结果。在此计算中将忽略空值。 |
| PERCENTILE\_DISC \(expr\) WITHIN GROUP \(ORDER BY expr \[DESC/ASC\]\) | timestamp, timestamptz, interval, float | ERCENTILE\_DISC\(percentage\) WITHIN GROUP \(ORDER BY expression\) Example:SELECT department\_id, PERCENTILE\_DISC \(0.5\) WITHIN GROUP \(ORDER BY salary DESC\) "Median\_desc"; FROM employees GROUP BY department\_id; | 执行一个假设离散分布模型的逆分布函数。它需要一个百分位数值和一个排序规格。这个返回值是集合中的一个元素。在此计算中将忽略空值。 |
| sum\(array\[\]\) | smallint\[\],int\[\], bigint\[\], float\[\] | sum(array[[1,2],[3,4]]) Example:CREATE TABLE mymatrix (myvalue int[]);INSERT INTO mymatrix VALUES (array[[1,2],[3,4]]); INSERT INTO mymatrix VALUES (array[[0,1],[1,0]]); SELECT sum(myvalue) FROM mymatrix;sum :\{\{1,3\},\{4,4\}\} | 执行矩阵求和。可以将二维数组作为输入，作为矩阵处理。 |
| pivot\_sum \(label\[\], label, expr\) | int\[\], bigint\[\], float\[\] | pivot\_sum\( array\['A1','A2'\], attr, value\) | 使用 sum 来解析重复条目的枢轴聚合。 |
| unnest \(array\[\]\) | set of anyelement | unnest\( array\['one', 'row', 'per', 'item'\]\)\` | 将一维数组转换成行。返回一组 anyelement（一种多态的 [PostgreSQL中的伪类型](https://www.postgresql.org/docs/8.3/static/datatype-pseudo.html)。 |



