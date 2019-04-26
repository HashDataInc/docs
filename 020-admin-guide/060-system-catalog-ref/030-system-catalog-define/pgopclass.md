# pg\_opclass

系统目录表 pg\_opclass 定义索引访问方法的操作符类。每一个操作符类定义了一种特定数据类型和一种特定索引访问方法的索引列的语义。注意对于一个给定的类型/访问方法的组合可以有多个操作符类，因此可以支持多种行为。定义一个操作符类的主要信息其实现在并不在其 pg\_opclass 行中，而是在 [pg\_amop](./pgamop.md) 和 [pg\_amproc](./pgamproc.md) 中的相关行中。这些行被看认为是操作符类定义的一部分 - 这不同于通过单个 [pg\_class](./pgclass.md) 行外加 [pg\_attribute](./pgattribute.md) 和其他表中的相关行定义一个关系的情况。

##### 表 1. pg\_catalog.pg\_opclass

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| opcamid | oid | pg\_am.oid | 操作符类所属的索引访问方法。 |
| opcname | name |  | 操作符类的名称 |
| opcnamespace | oid | pg\_namespace.oid | 操作符类所属的名字空间 |
| opcowner | oid | pg\_authid.oid | 操作符类的拥有者 |
| opcintype | oid | pg\_type.oid | 操作符类索引的数据类型。 |
| opcdefault | boolean |  | 如果此操作符类为数据类型的opcintype默认值则为真。 |
| opckeytype | oid | pg\_type.oid | 存储在索引中的数据类型，如果值为0则与opcintype相同。 |

**上级主题：** [系统目录定义](./README.md)
