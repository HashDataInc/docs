# pg\_locks

该 pg\_locks 视图提供了有关在 HashData 数据库中由开放事务持有的锁的信息的访问。

pg\_locks 包含一行关于每个积极可锁对象，请求的锁模式和相关事务。 因此，如果多个事务正在持有或等待其上的锁，同样的可锁对象可能会出现多次。 但是，目前没有锁的对象根本就不会出现。

有几种不同类型的可锁对象：整个关系（如表），关系的个别页，关系的个别元组，事务Id和通用数据库对象。另外，扩展关系的权利表示为单独的可锁对象。

##### 表 1. pg\_catalog.pg\_locks

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| locktype | text |  | 可锁对象的类型：relation, extend, page, tuple, transactionid, object, userlock, resource queue, 或 advisory |
| database | oid | pg\_database.oid | 该对象存在的数据库的Oid， 如果该对象是共享对象，则为0。如果对象是事务ID，则为空。 |
| relation | oid | pg\_class.oid | 关系的Oid，如果对象不是关系或者关系的一部分，则为NULL。 |
| page | integer |  | 关系中的页码，如果对象不是元组或者关系页则为NULL |
| tuple | smallint |  | 页中的元组号，如果该对象不是个元组则为NULL。 |
| transactionid | xid |  | 事务的Id，如果该对象不是一个事务Id，则为NULL。 |
| classid | oid | pg\_class.oid | 包含对象的系统目录的Oid，如果对象不是一般数据库对象，则为NULL。 |
| objid | oid | any OID column | 其系统目录中对象的Oid，如果对象不是一般数据库对象，则为NULL。 |
| objsubid | smallint |  | 对一个表列来说， 这是列号（ classid和objid引用表本身）。 对于所有其他的对象类型，此列为0。如果对象不是数据库对象，则为NULL。 |
| transaction | xid |  | 等待或持有该锁的事务的Id。 |
| pid | integer |  | 持有或等待该锁的事务进程的进程Id，如果锁由准备（prepared）的事务持有，则为NULL。 |
| mode | text |  | 该进程所持有或期望的锁模式的名称。 |
| granted | boolean |  | 锁被持有为真，锁为等待为假。 |
| mppsessionid | integer |  | 与锁相关的客户端会话的id。 |
| mppiswriter | boolean |  | 指明该锁是否由一个写进程所持有。 |
| gp\_segment\_id | integer |  | 该  HashData  持有该锁的段的id（dbid） |

**上级主题：** [系统目录定义](./README.md)
