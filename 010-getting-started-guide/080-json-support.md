# JSON 函数和操作符

用于创建和操作 JSON 数据的内置函数和操作符。

* [JSON 操作符](#title1)
* [JSON 创建函数](#title2)
* [JSON 处理功能](#title3)

> 注解： 对于 json 的值， 对象包含重复的键/值对，也保留所有键/值对。处理功能将最后一个值视为可操作的。

## <h2 id='title1'> JSON 操作符

该表描述了可用于的操作符 json 的数据类型。

##### <h5 id='tab1'> 表 1. json 操作符

| 操作符 | 右操作数类型 | 描述 | 示例 | 示例结果 |
| :--- | :--- | :--- | :--- | :--- |
| -> | int | 获取 JSON 数组元素（从零索引）。 | '\[{"a":"foo"},{"b":"bar"},{"c":"baz"}\]'::json->2 | {"c":"baz"} |
| -> | text | 通过键获取JSON对象字段。 | '{"a": {"b":"foo"}}'::json->'a' | {"b":"foo"} |
| ->> | int | 获取JSON数组元素作为文本。 | '\[1,2,3\]'::json->>2 | 3 |
| ->> | text | 获取JSON对象字段作为文本。 | '{"a":1,"b":2}'::json->>'b' | 2 |
| \#> | text\[\] | 在指定的路径获取JSON对象。 | '{"a": {"b":{"c": "foo"}}}'::json\#>'{a,b}' | {"c": "foo"} |
| \#>> | text\[\] | 以指定路径获取JSON对象作为文本。 | '{"a":\[1,2,3\],"b":\[4,5,6\]}'::json\#>>'{a,2}' | 3 |

## <h2 id='title2'> JSON 创建函数

此表描述了创建的函数的 json 值。

##### <h5 id='tab2'> 表 2. JSON 创建函数

| 函数 | 描述 | 示例 | 示例结果 |
| :--- | :--- | :--- | :--- |
| to\_json\(anyelement\) | 将值作为有效的 JSON 对象返回。数组和复合类型被递归处理并转换为数组和对象。 如果输入包含类型为 json 的造型, 则使用造型函数执行转换; 否则，将生成 JSON 标量值。对于除数字，布尔值或空值之外的任何标量类型，将使用文本表示，正确引用和转义，以使其为有效的 JSON 字符串。 | `to_json('Fred said "Hi."'::text)` | `"Fred said "Hi.""` |
| array\_to\_json(anyarray [, pretty_bool]) | 将数组作为JSON数组返回。 HashData 数据库的多维数组成为数组的JSON数组。如果 pretty\_bool 是 true，则在第一个元素之间添加换行符。 | array\_to\_json('\{\{1,5\},\{99,100\}\}'::int[]) | `[[1,5],[99,100]]` |
| `row_to_json(record [,pretty_bool])` | 将该行作为 JSON 对象返回。如果 elements if pretty\_bool 是 true 则在第 1 级元素之间添加换行符。 | `row_to_json(row(1,'foo'))` | `{"f1":1,"f2":"foo"}` |

> 注解：除了提供精细打印选项外，array\_to\_json 和 row\_to\_json 具有与 to\_json 相同的行为。 对于 to\_json 描述的行为也适用于由其他 JSON 创建函数转换的单个值。

## <h2 id='title3'> JSON 处理函数

此表描述处理 json 值的函数。

##### <h5 id='tab3'> 表 3. JSON 处理函数

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