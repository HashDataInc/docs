# pg\_amop

pg\_amop 表存储关于与访问方法操作符类相关的操作符的信息。对于每一个操作符类中的成员即操作符都有一行。

##### 表 1. pg\_catalog.pg\_amop

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| amopclaid | oid | pg\_opclass.oid | 此项所对应的索引操作符类 |
| amopsubtype | oid | pg\_type.oid | 用于区分一个策略的多个项的子类型，默认为零 |
| amopstrategy | int2 |  | 操作符策略号 |
| amopreqcheck | boolean |  | 索引命中必须被复查 |
| amopopr | oid | pg\_operator.oid | 操作符的OID |

**上级主题：** [系统目录定义](./README.md)
