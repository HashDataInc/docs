# pg\_database

pg\_database 系统目录表储存了可用数据库的信息。数据库由 SQL 命令 CREATE DATABASE 创建。和大多数系统目录不同，pg\_database 在系统中所有数据库之间共享。每个系统只有一个 pg\_database 副本，而不是每个数据库一个。

##### 表 1. pg\_catalog.pg\_database

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| datname | name |  | 数据库名称。 |
| datdba | oid | pg\_authid.oid | 数据库的拥有者，通常是创建它的人。 |
| encoding | int4 |  | 数据库的字符编码。 pg\_encoding\_to\_char\(\)可以将此编号转换为编码名称。 |
| datistemplate | boolean |  | 如果为真则这个数据库可以被用在 CREATE DATABASE 的 TEMPLATE 子句中来创建一个新的数据库作为这个数据库的克隆体。 |
| datallowconn | boolean |  | 如果为假，则该数据库不可连接。这用于保护数据库 template0 不被修改。 |
| datconnlimit | int4 |  | 设置该数据库最大并发连接数。-1表示没有限制。 |
| datlastsysoid | oid |  | 数据库中的最后一个系统OID。 |
| datfrozenxid | xid |  | 这个数据库中在此之前的所有事务ID已被替换为的永久（冻结）事务ID。这用于追踪该数据库是否需要清理，以防止事务ID回卷或允许pg\_clog收缩，它是每个表的 _pg\_class.relfrozenxid_ 的最小值。 |
| dattablespace | oid | pg\_tablespace.oid | 数据库的默认表空间。在此数据库中，所有 _pg\_class.reltablespace_ 为 0 的表都将存储在此表空间中。所有非共享的系统目录也将放在那里。 |
| datconfig | text\[\] |  | 用户可设置的服务器配置参数的会话默认值。 |
| datacl | aclitem\[\] |  | 由 GRANT 和 REVOKE 所给予的数据库访问特权。 |

**上级主题：** [系统目录定义](./README.md)
