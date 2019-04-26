# pg\_language

pg\_language 系统目录表注册用户可以用来编写函数和存储程序的语言。它由CREATE LANGUAGE填充。

##### 表 1. pg\_catalog.pg\_language

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| lanname | name |  | 语言的名称 |
| lanowner | oid | pg\_authid.oid | 语言的拥有者 |
| lanispl | boolean |  | 对内部语言（如SQL）而言，值为假。而对于用户自定义的语言为真。目前，pg\_dump 仍然使用它来确定哪些语言需要被转存，但是，在将来它可能会被不同的机制所代替。 |
| lanpltrusted | boolean |  | 如果这是一种可信的语言，则为真，表示它不会为正常SQL执行环境之外的任何东西授予访问。只有超级用户才能用不可信语言创建函数。 |
| lanplcallfoid | oid | pg\_proc.oid | 对于非内部的语言，该属性引用了一个语言处理程序，该程序是一个特殊的函数，负责执行所有以特定语言编写的函数。 |
| laninline | oid | pg\_proc.oid | 这个属性引用一个函数负责执行内联匿名代码块的函数。如果不支持匿名块，则为0。 |
| lanvalidator | oid | pg\_proc.oid | 这个属性引用一个语言验证器函数，负责在创建新函数时检查新函数的语法和合法性。如果没有提供验证器，则为0。 |
| lanacl | aclitem\[\] |  | 语言的访问特权。 |

**上级主题：** [系统目录定义](./README.md)
