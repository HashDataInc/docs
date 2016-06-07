.. include:: ../../defines.hrst

.. _sql_ref_abort:

ABORT
-----

.. Aborts the current transaction.

终止当前事务。

语法
~~~~

::

	ABORT [WORK | TRANSACTION]

描述
~~~~

ABORT 回滚当前事务，所有由当前事务进行的修改都将被丢弃。此命令与标准 SQL 语句 ROLLBACK 命令行为完全一致。因为历史原因，因此保留此命令。

参数
~~~~

WORK
TRANSACTION

	可选的关键字，无任何效果。

注意
~~~~

请使用 COMMIT 来完成一个成功的事务。

如果没有启动任何事务的情况下执行 :ref:`sql_ref_abort` 没有任何副作用，但是系统会发出一条警告信息。

兼容性
~~~~~~

此命令是因为历史原因造成的 |postgres| 和 |greenplum| 的扩展。ROLLBACK 是标准 SQL 的等价命令。

相关命令
~~~~~~~~

:ref:`sql_ref_begin`, COMMIT, ROLLBACK