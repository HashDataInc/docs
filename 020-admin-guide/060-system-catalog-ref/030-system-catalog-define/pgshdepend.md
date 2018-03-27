# pg\_shdepend

pg\_shdepend 系统目录表记录数据库对象和共享对象（例如角色）之间的依赖关系。这些信息使得 HashData 数据库可以确保对象在被删除时没有被其他对象引用。另见 [pg\_depend](./pgdepend.md) ，它对单个数据库中对象之间的依赖提供了相似的功能。 与大部分其他系统目录不同，pg\_shdepend 在 HashData 系统的所有数据库之间共享：在每一个系统中只有一份 pg\_shdepend 拷贝，而不是每个数据库一份。

在所有情况下，一个 pg\_shdepend 项表明被引用对象不能在没有删除其依赖对象的情况下被删除。但是，其中也有多种依赖类型，由 deptype 标识：

* **SHARED\_DEPENDENCY\_OWNER \(o\)** — 被引用对象（必须是一个角色）是依赖对象的拥有者。
* **SHARED\_DEPENDENCY\_ACL \(a\)** — 被引用对象（必须是一个角色）在依赖对象的ACL（访问控制列表）中被提到。
* **SHARED\_DEPENDENCY\_PIN \(p\)** — 没有依赖对象；这种类型的项是系统本身依赖被引用对象的信号，因此对象绝不能被删除。此类型的项仅通过系统初始化创建，依赖对象列包含0。

##### 表 1. pg\_catalog.pg\_shdepend

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| dbid | oid | pg\_database.oid | 依赖对象所在的数据库OID，如果是一个共享对象则值为0。 |
| classid | oid | pg\_class.oid | 依赖对象所在的系统目录的OID。 |
| objid | oid |  | 任意OID列。依赖对象的OID。 |
| objsubid | int4 |  | 对于一个表列，这将是列编号。对于所有其他对象类型，该列值为0。 |
| refclassid | oid | pg\_class.oid | 被引用对象所在的系统目录的OID（必须是一个共享的目录）。 |
| refobjid | oid |  | 任意OID列。被引用对象的OID。 |
| refobjsubid | int4 |  | 对于一个表列，这将是被引用列的列编号。对于所有其他对象类型，该列值为0。 |
| deptype | char |  | 一个定义该依赖关系的特定语义的代码。 |

**上级主题：** [系统目录定义](./README.md)
