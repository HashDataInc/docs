# pg\_constraint

pg\_constraint 系统目录表储存表上的检查、主键、唯一和外键约束。列约束不被特别对待。每个列约束都等效于某种表约束。非空约束在[pg\_attribute](./pgattribute.md)目录表中表示。域上的检查约束也储存在这里。

##### 表 1. pg\_catalog.pg\_constraint

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| conname | name |  | 约束名称（不一定唯一！） |
| connamespace | oid | pg\_namespace.oid | 包含约束的命名空间（方案）的OID |
| contype | char |  | c = 检查约束，f = 外键约束，p = 主键约束， u = 唯一约束。 |
| condeferrable | boolean |  | 约束是否可以延迟？ |
| condeferred | boolean |  | 约束是否默认延迟？ |
| conrelid | oid | pg\_class.oid | 约束所在的表；如果不是一个表约束则为0。 |
| contypid | oid | pg\_type.oid | 该约束所在的域；如果不是一个域约束则为0。 |
| confrelid | oid | pg\_class.oid | 如果是一个外键，则表示所引用的表；否则为0。 |
| confupdtype | char |  | 外键更新动作代码。 |
| confdeltype | char |  | 外键删除动作代码。 |
| confmatchtype | char |  | 外键匹配类型。 |
| conkey | int2\[\] | pg\_attribute.attnum | 如果是一个表约束，则表示所约束的列的列表。 |
| confkey | int2\[\] | pg\_attribute.attnum | 如果是一个外键，则表示所引用列的列表。 |
| conbin | text |  | 如果是一个检查约束，则表示表达式的内部表示。 |
| consrc | text |  | 如果是一个检查约束，则表示表达式的人类可读的表示。当被引用对象改变时候，这个属性不会被更新；例如，它不会跟踪列的重命名。最好使用pg\_get\_constraintdef\(\)来提取检查约束的定义，而不是依赖此字段。 |

**上级主题：** [系统目录定义](./README.md)
