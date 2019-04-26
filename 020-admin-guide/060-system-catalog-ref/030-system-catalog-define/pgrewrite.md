# pg\_rewrite

pg\_rewrite 系统目录表存储表和视图的重写规则。如果一个表在这个目录中有任何规则，其 pg\_class.relhasrules 必须为真。

##### 表 1. pg\_catalog.pg\_rewrite

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| rulename | name |  | 规则名称。 |
| ev\_class | oid | pg\_class.oid | 使用该规则的表。 |
| ev\_attr | int2 |  | 使用该规则的列（当前总是0，表示在整个表上使用）。 |
| ev\_type | char |  | 使用该规则的事件类型：1 = SELECT，2 = UPDATE，3 = INSERT，4 = DELETE |
| is\_instead | boolean |  | 如果规则是一个INSTEAD规则，则为真。 |
| ev\_qual | text |  | 规则条件的表达式树（按照nodeToString\(\)的表现形式）。 |
| ev\_action | text |  | 规则动作的查询树（按照nodeToString\(\)的表现形式）。 |

**上级主题：** [系统目录定义](./README.md)
