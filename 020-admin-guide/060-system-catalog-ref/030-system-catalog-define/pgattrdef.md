# pg\_attrdef

该 pg\_attrdef 表储存列的默认值，关于列的主要信息储存在[pg\_attribute](./pgattribute.md)中。只有那些明确指定了默认值的列（在创建表或者添加列时）才会在该表中有一项。

##### 表 1. pg\_catalog.pg\_attrdef

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| adrelid | oid | pg\_class.oid | 该列所属的表 |
| adnum | int2 | pg\_attribute.attnum | 列编号 |
| adbin | text |  | 列默认值的内部表示 |
| adsrc | text |  | 默认值的人类可读的表示，这个字段是历史遗留下来的，最好别用。 |

**上级主题：** [系统目录定义](./README.md)
