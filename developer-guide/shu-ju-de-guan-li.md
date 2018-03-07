# 数据的管理

本章节想您提供关于在 HashData 数据仓库中操作数据和并发访问的相关信息。本章节包含下面一些子话题：

* HashData 数据仓库中的并发控制
* 插入数据
* 更新存在的数据
* 删除数据
* 使用事务
* 数据库的清理

## 6.1. HashData 数据仓库中的并发控制
在 HashData 数据仓库和 PostgreSQL 中，并发控制并不是通过锁实现的。而是通过使用 多个数据版本的多版本并发控制（MVCC）来维护数据一致性的。 MVCC 能够对数据库的每个会话提供 事务隔离，并且保证每一个查询事务都能看到一份数据的快照。这种方式保证了事务看到一致的数据， 而不会被其他并发运行的事务影响到。

由于 MVCC 不通过显示封锁来控制并发访问，这就使得锁冲突最小化，因此 HashData 数据仓库能够在 多用户环境下依然提供稳定可靠的处理能力。查询数据（读取）使用的锁，不会与写入数据使用的锁产生 （冲突）。

HashData 数据仓库提供了多个锁模式来对表中的数据提供并发访问控制。

大多数 HashData 数据仓库的 SQL 命令能够自动地根据执行的命令，在操作的表上获取适当的锁，来 防止删除表或修改表的操作。对于不能简单地修改来兼容 MVCC 行为的应用程序，可以通过使用 LOCK 命令来显示获取指定类型的锁。但是，合理使用 MVCC 能够有效提升性能。

|锁模式	|相关 SQL 命令	|冲突|
|:---|:---|:---|
|ACCESS SHARE	|SELECT	|ACCESS EXCLUSIVE
|ROW SHARE	|SELECT FOR SHARE	|EXCLUSIVE, ACCESS EXCLUSIVE
|ROW EXCLUSIVE	|INSERT, COPY	|SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE
|SHARE UPDATE EXCLUSIVE	|VACUUM (without FULL), ANALYZE	|SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE
|SHARE	|CREATE INDEX	|ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE
|SHARE ROW EXCLUSIVE||	 	ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE
|EXCLUSIVE	|DELETE, UPDATE, SELECT FOR UPDATE, See Note	|ROW SHARE, ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE
|ACCESS EXCLUSIVE	|ALTER TABLE, DROP TABLE, TRUNCATE, REINDEX, CLUSTER, VACUUM FULL	|ACCESS SHARE, ROW SHARE, ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE

> 注意: 在 HashData 数据仓库中, UPDATE, DELETE, 和 SELECT FOR UPDATE 命令将会使用更加严格的 EXCLUSIVE 锁，而不是 ROW EXCLUSIVE。

## 6.2. 插入数据
使用 INSERT 命令可以在表中创建数据。使用此命令需要提供表名和该表中每列的值，你可以通过显示地指定列名来改变提供列值的顺序。 如果您没有指定列名，列值需要按照表中的列顺序指定，并使用逗号进行分隔。

下面是指定按照列名顺序提供列值的示例：

```
INSERT INTO products (name, price, product_no) VALUES ('Cheese', 9.99, 1);
```
下面是指提供列值的示例：

```
INSERT INTO products VALUES (1, 'Cheese', 9.99);
```
通常情况下，提供的列值是字面值（常量），但是您也可以使用标量表达式。例如：

```
INSERT INTO films SELECT * FROM tmp_films WHERE date_prod < '2004-05-07';
```
您还可以在一条命令中插入多行值：

```
INSERT INTO products (product_no, name, price) VALUES
    (1, 'Cheese', 9.99),
    (2, 'Bread', 1.99),
    (3, 'Milk', 2.99);
```
您可以通过指定分区表的根表，来向分区表中插入数据。您也可以通过在 INSERT 命令中指定 分区表的子表（叶子节点）。如果您提供的数据与该子表存储的数据不匹配，系统将提示错误信 息。INSERT 命令不支持指定非叶子节点的子表。

要插入大量数据，请使用外部表命令。外部表数据加载机制在处理大量数据插入方面比 INSERT 命令更加高效。请参考 TODO 了解更多关于海量数据加载问题。

Append 表（追加表）是一种专门为海量数据加载设计的存储模型。HashData 数据仓库不推荐 使用单行的 INSERT 命令来操作追加表。目前 HashData 数据仓库允许最多 127 并发事务 同时向一张追加表进行插入。

## 6.3. 更新存在的数据
UPDATE 命令可以更新一张表中的记录。该命令支持一次更新所有记录，部分记录或者单条记录。 该命令还允许针对特定列进行更新，而不影响其他列值。

要执行更新操作，需要如下信息：

* 要更新的表名和相关列名
* 新的列值
* 用来指定需要更新记录的一个或多个选择条件

下面示例展示将所有价格为 5 的产品价格改为 10 的命令：

```
UPDATE products SET price = 10 WHERE price = 5;
```
在 HashData 数据仓库中使用 Update 命令有如下限制：

* HashData 数据仓库数据分布键值不能被更新。
* HashData 数据仓库不支持 RETURNING 子句。
* HashData 数据仓库分区列不能被更新（分区键值）。

## 6.4. 删除数据

DELETE 命令可以从表中删除记录。使用 WHERE 子句可以删除符合特定条件的记录。如果没有 指定 WHERE 条件，表中所有记录都会被删除。执行的结果就是一张没有记录的空表。

下面示例展示删除所有价格为 10 的产品：

```
DELETE FROM products WHERE price = 10;
```
删除表中所有数据：

```
DELETE FROM products;
```
在 HashData 数据仓库中使用 DELETE 命令有如下限制：

HashData 数据仓库不支持 RETURNING 子句。
### 6.4.1. 清空表

TRUNCATE 命令可以快速地删除表中所有记录。

例如：

```
TRUNCATE mytable;
```
此命令可以将表中所有记录一次清空。由于 TRUNCATE 不对表进行扫描，因此该操作不操作继承表或者 ON DELETE 重写规则。命令只会将指定表中的纪录清空。

## 6.5. 使用事务

事务允许您将多个 SQL 语句当做一个原子的操作（要么都做，要么都不做）。下面列出 SQL 的事务命令：

* BEGIN 或 START TRANSACTION 开始一个事务代码块。
* END 或 COMMIT 将会提交事务运行结果。
* ROLLBACK 放弃当前事务对数据库的所有修改。
* SAVEPOINT 保存点可以在当前事务中间保存特定信息来允许事务回滚到指定保存点。通过使用保存点，您可以回滚该保存点之后的所有命令，并且保留该保存点之前执行命令的结果。
* ROLLBACK TO SAVEPOINT 将事务状态恢复到指定保存点。
* RELEASE SAVEPOINT 将事务内的保存点占用资源释放。

### 6.5.1. 事务的隔离级别

HashData 数据仓库支持标准 SQL 事务级别如下：

* 读未提交（read uncommitted）和读提交（read committed）行为与 SQL 标准定义的读已提交一致
* 可重复读（repeatable read） 不被支持。如果需要使用可重复读行为，可以通过使用串行化级别来兼容。
* 可串行化（serializable）行为与 SQL 标准定义的可串行化一致

下面向您介绍 HashData 数据仓库各个事务级别的行为介绍：

读提交/读未提交 — 提供快速，简单和部分事务隔离。在读提交和读未提交事务隔离级别下，SELECT, UPDATE, 和 DELETE 操作的数据库快照，是在查询启动时构建的。

SELECT 查询：

* 可以看到查询启动前所有已经提交的数据变动。
* 可以看到事务内部已经执行的操作变动。
* 不可以看到事务外部未提交的数据变动。
* 可能在本事务读取数据后，看到其他并发事务提交的变动。
* 在同一个事务中的后续 SELECT 查询可能会看到其他并发事务在该 SELECT 查询启动前提交的变动。 UPDATE 和 DELETE 命令只操作在命令启动前已经提交的变动。

读提交或读未提交事务隔离级别在进行 UPDATE 或 DELETE 操作时，允许并发事务对记录进行修改或封锁。 读提交或读未提交事务隔离级别可能对于执行复杂查询更新，对数据库系统要求一致性视图的应用程序来说不能胜任。

可串行化 — 提供严格地事务隔离，事务的执行结果类似于事务一个一个地顺序执行，而不是并发执行。 使用可串行化隔离级别的应用程序在设计时，需要考虑串行化失败的情况，进行必要的重试操作。在 HashData 数据仓库中，SERIALIZABLE 隔离级别能够在不使用代价较高的封锁机制下，防止读脏数据， 不可重复读，和读幻象。但是还存在一些其他 SERIALIZABLE 事务之间的交互，使得 HashData 数据仓库不能 提供真正的可串行化结果。并发执行的事务需要进行检查，来识别事务交互时因为紧致并发更新相同的数据导致 相互影响。识别的问题可以通过显示地表锁或者事务冲突来避免，例如：通过并发更新一个标志行来引入事务冲突。

SELECT 查询：

* 可以看到事务启动时数据的快照（不是事务中当前查询启动时的快照）
* 只能看到查询启动前已经提交的数据变动。
* 可以看到事务内部已经执行的操作变动。
* 不可以看到事务外部未提交的数据变动。
* 不可以看到并发执行的事务产生的数据变动。
* 在一个事务中的后续 SELECT 命令看到的数据总是一样的。UPDATE，DELETE，SELECT FOR UPDATE， 和 SELECT FOR SHARE 命令只操作在命令启动前本事务已经提交的变动。如果其他并发执行的事务已经 更新，删除，或锁住一个要被操作的目标记录，那么可串行化或可重复读的事务将会等待该并发事务完成， 再更新该记录，删除该记录，或者回滚事务。

如果并发事务更新或删除记录，那么可串行化或可重复读的事务将会回滚。如果并发事务回滚，那么可串行 化或可重复读的事务将会更新或删除该记录。

HashData 数据仓库中的默认隔离级别是读提交。要改变事务的隔离级别，可以在使用 BEGIN 启动 事务时声明，或者在事务启动后，使用 SET TRANSACTION 命令设置。

## 6.6. 数据库的清理

虽然被删除或者被更新的记录对于新事务是不可见的，但是它们仍然会占用磁盘的物理空间。 需要定期运行 VACUUM 命令来清理这些过期的记录。例如：

```
VACUUM mytable;
```
VACUUM 命令将会收集表相关的统计数据，例如：记录数和页面数。在数据加载后，请使用 Vacuum 对所有的 数据表进行处理（包括追加表）。要了解日常使用 VACUUM 操作的信息，请参考：TODO: Routine Vacuum and Analyze.

> 重要: 如果数据更新或删除比较频繁，请使用 VACUUM, VACUUM FULL, 和 VACUUM ANALYZE 命令来 维护数据信息。TODO: 请查看 VACUUM 命令相关文档。