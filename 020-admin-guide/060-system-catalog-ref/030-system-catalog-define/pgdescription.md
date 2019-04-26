# pg\_description

pg\_description 系统目录表存储每个数据库对象的可选描述（注释）。可以使用 COMMENT 命令来操作描述，并使用 psql 的 \d 元命令来查看。 pg\_description 的初始内容中提供了许多内建系统对象的描述。另请参见 [pg\_shdescription](./pgshdescription.md) ，它对涉及 HashData 数据库系统共享对象的描述执行类似的功能。

##### 表 1. pg\_catalog.pg\_description

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| objoid | oid | any OID column | 该描述所涉及对象的OID。 |
| classoid | oid | pg\_class.oid | 该对象所出现的系统目录的OID。 |
| objsubid | int4 |  | 对于表列的注释，这是列编号。对于其他对象类型，此列为0。 |
| description | text |  | 作为此对象描述的任意文本。 |

**上级主题：** [系统目录定义](./README.md)
