.. include:: ../../defines.hrst

.. _sql_ref_begin:

BEGIN
-----

启动一个事务块。

语法
~~~~

::

	BEGIN [WORK | TRANSACTION] [transaction_mode]
	      [READ ONLY | READ WRITE]


transaction_mode 可以是下面的一个值：

::

	ISOLATION LEVEL | {SERIALIZABLE | READ COMMITTED | READ UNCOMMITTED}

描述
~~~~

.. BEGIN initiates a transaction block, that is, all statements after a BEGIN command will be executed in a single transaction until an explicit COMMIT or ROLLBACK is given. By default (without BEGIN), Greenplum Database executes transactions in autocommit mode, that is, each statement is executed in its own transaction and a commit is implicitly performed at the end of the statement (if execution was successful, otherwise a rollback is done).

BEGIN 启动一个事务块，所有在 BEGIN 语句之道 COMMIT 或 ROLLBACK 的语句之间的 SQL 命令将会被当做一个单独的事务运行。默认情况下（不使用 BEGIN），|product-name| 工作在自动提交模式，每条语句将会自动启动一个事务快，并执行该语句，在语句执行后，自动执行事务提交命令（如果执行失败，将会自动执行回滚）。

.. Statements are executed more quickly in a transaction block, because transaction start/commit requires significant CPU and disk activity. Execution of multiple statements inside a transaction is also useful to ensure consistency when making several related changes: other sessions will be unable to see the intermediate states wherein not all the related updates have been done.

由于启动和提交事务需要额外的 CPU 和 磁盘资源，因此在同一个事务块中运行多个语句的速度更快。在同一个事务中运行多个语句也能更好的保证多个修改后的数据一致性：其他会话的操作不会观察到还没有完成的更新操作导致道数据中间状态。

.. If the isolation level or read/write mode is specified, the new transaction has those characteristics, as if SET TRANSACTION was executed.

如果指定了隔离级别或读写模式，新事务将会具有设置的特性，此效果与执行 SET TRANSACTION 一致。

参数
~~~~

WORK
TRANSACTION

	可选的关键字，无任何效果。

SERIALIZABLE
READ COMMITTED
READ UNCOMMITTED

..	The SQL standard defines four transaction isolation levels: READ COMMITTED, READ UNCOMMITTED, SERIALIZABLE, and REPEATABLE READ. The default behavior is that a statement can only see rows committed before it began (READ COMMITTED). In Greenplum Database READ UNCOMMITTED is treated the same as READ COMMITTED. REPEATABLE READ is not supported; use SERIALIZABLE if this behavior is required. SERIALIZABLE is the strictest transaction isolation. This level emulates serial transaction execution, as if transactions had been executed one after another, serially, rather than concurrently. Applications using this level must be prepared to retry transactions due to serialization failures.

SQL 标准定了四个事务隔离级别：READ COMMITTED，READ UNCOMMITTED，SERIALIZABLE 和 REPEATABLE READ。默认行为是一条命令只能看到在它开始运行时已经提交的结果（READ COMMITTED）。在 |product-name| 中，READ UNCOMMITTED 和 READ COMMITTED 行为相同。虽然不支持 REPEATABLE READ，但是可以使用更严格的 SERIALIZABLE 模式。SERIALIZABLE 是事务隔离级别中最严格的。在此模式下，事务的执行将会模拟串行化事务执行的效果，类似于事务是一个接着一个运行，而并不是并发执行。应用在使用 SERIALIZABLE 隔离级别时，需要处理由于串行化失败后重新执行事务的工作。	

READ WRITE
READ ONLY

..	Determines whether the transaction is read/write or read-only. Read/write is the default. When a transaction is read-only, the following SQL commands are disallowed: INSERT, UPDATE, DELETE, and COPY FROM if the table they would write to is not a temporary table; all CREATE, ALTER, and DROP commands; GRANT, REVOKE, TRUNCATE; and EXPLAIN ANALYZE and EXECUTE if the command they would execute is among those listed.

决定事务是读写模式还是只读模式。默认模式为读写模式。当一个事务是只读模式，下面的 SQL 命令将会被禁用：访问非临时表的 INSERT，UPDATE，DELETE 和 COPY FROM命令； 所有的 CREATE，ALTER，和 DROP 命令；GRANT，REVOKE，TRUNCATE 命令；在 EXPLAIN ANALYZE 和 EXECUTE 中使用了前面提到的过的命令。

注意
~~~~

.. START TRANSACTION has the same functionality as BEGIN.

START TRANSACTION 和 BEGIN 命令功能相同。

.. Use COMMIT or ROLLBACK to terminate a transaction block.

使用 COMMIT 或 ROLLBACK 来结束一个事务块。

.. Issuing BEGIN when already inside a transaction block will provoke a warning message. The state of the transaction is not affected. To nest transactions within a transaction block, use savepoints (see SAVEPOINT).

在启动的事务块内部执行 :ref:`sql_ref_begin` 没有任何副作用，但是系统会发出一条警告信息。事务的状态不会受到任何影响。要在事务块中使用嵌套事务，使用保存点功能（ 参考 SAVEPOINT）。


示例
~~~~

要启动一个事务：

.. code-block:: sql

	BEGIN;

启动一个可串行化隔离级别的事务：

.. code-block:: sql

	BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

兼容性
~~~~~~

.. BEGIN is a Greenplum Database language extension. It is equivalent to the SQL-standard command START TRANSACTION.

BEGIN 是 |postgres| 和 |greenplum| 的扩展命令。它等效于 SQL 标准命令 START TRANSACTION。

.. Incidentally, the BEGIN key word is used for a different purpose in embedded SQL. You are advised to be careful about the transaction semantics when porting database applications.

然而，BEGIN 关键词在嵌入式 SQL 中具有其它含义。在您迁移数据库应用时，请小心留意事务语义。


相关命令
~~~~~~~~

COMMIT, ROLLBACK, START TRANSACTION, SAVEPOINT
