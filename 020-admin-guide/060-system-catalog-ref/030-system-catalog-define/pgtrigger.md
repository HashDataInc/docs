# pg\_trigger

pg\_trigger 系统目录表存储表上的触发器。

> 注意： HashData 数据库不支持触发器。

##### 表 1. pg\_catalog.pg\_trigger

| 名称 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| tgrelid | oid | pg\_class.oid | 注意 HashData 数据库不强制参照完整性。触发器所在的表。 |
| tgname | name |  | 触发器名（同一个表的触发器名必须唯一）。 |
| tgfoid | oid | pg\_proc.oid | 注意 HashData 数据库不强制参照完整性。要被触发器调用的函数 |
| tgtype | int2 |  | 触发器触发条件的位掩码。 |
| tgenabled | boolean |  | 为真是，启用触发器。 |
| tgisconstraint | boolean |  | 如果触发器实现一个参照完整性约束，则为真。 |
| tgconstrname | name |  | 参照完整性的名称。 |
| tgconstrrelid | oid | pg\_class.oid | 注意 HashData 数据库不强制参照完整性。被一个参照完整性约束引用的表。 |
| tgdeferrable | boolean |  | 如果可延迟则为真。 |
| tginitdeferred | boolean |  | 如果初始可延迟则为真。 |
| tgnargs | int2 |  | 传递给触发器函数的参数字符串个数。 |
| tgattr | int2vector |  | 当前没有使用。 |
| tgargs | bytea |  | 传递给触发器的参数字符串，每一个都以NULL结尾。 |

**上级主题：** [系统目录定义](./README.md)

