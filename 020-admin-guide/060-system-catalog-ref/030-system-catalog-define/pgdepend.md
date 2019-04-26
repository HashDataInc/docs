# pg\_depend

pg\_depend 系统目录表记录数据库对象之间依赖关系。此信息允许 DROP 命令查找哪些其他对象必须由 DROP CASCADE 删除或者必须防止在 DROP RESTRICT 情况中被删除。另请参见 [pg\_shdepend](./pgshdepend.md)，它对涉及 HashData 系统共享对象的依赖执行类似的功能。

在所有的情况下，pg\_depend 项表示在不删除依赖对象的前提下也不能删除被引用对象。不过，有几种由 deptype 区分的子类型：

* **DEPENDENCY\_NORMAL \(n\)** — 单独创建的对象之间的正常关系。可以删除依赖对象而不影响被引用的对象。被引用对象只能通过指定CASCADE来删除，在这种情况下依赖对象也会被删除。例如：表列对其数据类型具有正常的依赖性。
* **DEPENDENCY\_AUTO \(a\)** — 依赖对象可以独立于被引用对象而删除，并且如果被引用对象被删除，则依赖对象应该自动被删除（不管是RESTRICT还是CASCADE模式）。例如：表上的命名约束自动依赖表，因此如果表被删除，该约束也将消失。
* **DEPENDENCY\_INTERNAL \(i\)** — 依赖对象作为被引用对象的一部分创建，实际只是其内部实现的一部分。依赖对象的DROP 操作将被完全禁止（我们会告诉用户针对被引用对象发出DROP命令来代替）。被引用对象的DROP命令会被传播以删除依赖对象，不管是否指定CASCADE（级联删除）。
* **DEPENDENCY\_PIN \(p\)** — 没有依赖对象；这种类型的项是系统本身依赖被引用对象的信号，此类型的项仅通过系统初始化创建，依赖对象包含0。

##### 表 1. pg\_catalog.pg\_depend

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| classid | oid | pg\_class.oid | 依赖对象所在的系统目录的OID。 |
| objid | oid | any OID column | 特定依赖对象的OID。 |
| objsubid | int4 |  | 对于表列，这是列编号。对于其他对象类型，此列为0。 |
| refclassid | oid | pg\_class.oid | 被引用对象所在的系统目录的OID。 |
| refobjid | oid | any OID column | 特定被引用对象的OID。 |
| refobjsubid | int4 |  | 对于表列，这是被引用的列编号。对于其他对象类型，该列为0。 |
| deptype | char |  | 定义此依赖关系的特定语义的代码。 |

**上级主题：** [系统目录定义](./README.md)
