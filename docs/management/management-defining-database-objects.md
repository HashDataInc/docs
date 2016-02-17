### 定义数据库对象
本节介绍 <&product-name> 支持的数据定义语言 (DDL) 以及如何创建和管理数据库对象。

在 Greenplum Database 中创建对象包括前期选择数据分布、 存储选项、 数据加载和其他会影响您的数据库系统运行性能的功能。了解可用的选项和数据库内部如何支持这些选项将帮助您做出正确的决定。
大部分 Greenplum 高级特性是通过使用扩展的 SQL CREATE DDL 语句完成的。

#### 创建和管理数据库
<&product-name> 支持创建多个独立的数据库对数据进行隔离。这个特性与某些数据库并不相同，例如：Oracle数据库。虽然 <&product-name> 支持多个数据库，但是客户端程序一次只能连接并使用一个数据库。

##### 关于数据库模版
您创建的每一个数据库都是基于一个模版得到的。系统中的默认模版数据库叫做：template1。我们建议您不要在template1中创建任何数据对象，否则您后续创建的数据库都会包含这些数据。

<&product-name> 内部还使用另外两个内置模版：template0 和 postgres。因此请勿删除或修改 template0 和 postgres 数据库。您也可以使用 template0 作为模版，创建一个只含有标准预定义对象的空白数据库。

##### 创建数据库
使用 CREATE DATABASE 命令来创建一个新的数据库. 例如:

	=> CREATE DATABASE new_dbname;

若要创建新的数据库, 您需要拥有创建数据库的权限或者超级用户权限。如果您没有相应的权限，创建数据库的操作将会失败。可以联系数据管理员来取得创建数据库的权限。

##### 克隆数据库
创建新的数据库时，系统实际上通过克隆一个默认的标准数据库模版 template1 来完成。实际上，您可以指定任意一个数据作为创建新数据库的模版，这样新的数据库就会自动包含模版数据库中的所有对象和数据。例如：

	=> CREATE DATABASE new_dbname TEMPLATE old_dbname;

##### 列出所有数据库
如果您使用 psql 客户端程序，您可以使用 \l 命令列出系统中的模版数据库和数据库。如果您使用其他客户端程序并且拥有超级用户权限，您可以通过查询 pg_database 系统表列出所有数据库。例如：

	=> SELECT datname from pg_database;

##### 修改数据库
ALTER DATABASE 命令可以用来修改数据库的属主，名称或者默认参数配置。例如, 下面的命令修改了数据库默认模式搜索路径：

	=> ALTER DATABASE mydatabase SET search_path TO myschema, public, pg_catalog;

你需要是数据库的属主或拥有超级用户权限，才可以对数据库信息进行修改。

##### 删除数据库
DROP DATABASE 命令可以删除数据库。该命令将会从系统表中删除数据库相关信息，并在磁盘上删除该数据库相关的所有数据。只有数据库的属主或者超级用户才能够删除数据库。正在被使用的数据库是无法被删除的。例如：

	=> \c template1
	=> DROP DATABASE mydatabase;

警告：删除数据库是不可逆的过程，请小心使用。

#### 创建和管理模式
通过模式（Schema）对数据库对象进行逻辑上的分类组织。通过使用模式允许您在同一个数据库中，创建同名对象（例如：表）。

##### 默认模式 "Public"
数据库默认包含一个默认模式：public。如果您没有创建任何模式，新创见的对象会默认使用 public 模式。数据库所有的用户都拥有 public 模式上的 CREATE （创建）和 USAGE（使用）权限。当您创建额外的模式时，您可以对用户授予权限，来控制访问。

##### 创建模式
使用 **CREATE SCHEMA** 命令来创建一个新的模式. 例如: 

	=> CREATE SCHEMA myschema;

要在指定的模式下创建对象或访问对象，您需要使用限定名格式来进行。限定名格式是模式名”.“表名的方式，例如：

	myschema.table

参考 `模式搜索路径` 了解更多关于访问模式的说明.
可以通过为用户创建私有的模式，来更好的限制用户对名称空间的使用。语法如下：

	=> CREATE SCHEMA schemaname AUTHORIZATION username;

##### 模式的搜索路径
通过使用模式限定名，可以指向数据库中特定位置的对象。例如：

	=> SELECT * FROM myschema.mytable;

可以通过设置参数 search_path 来指定模式的搜索顺序。搜索路径中第一个模式就是系统使用的默认模式，当没有引用模式时，对象将会自动创建在默认模式下。

###### 设置模式搜索路径
search_path 配置参数涌来设置模式搜索顺序。ALTER DATABASE 命令可以设置数据库内默认搜索路径。例如：

	 => ALTER DATABASE mydatabase SET search_path TO myschema, public, pg_catalog;

还可以通过 ALTER ROLE 命令来为指定的用户修改 search_path 参数。例如：

	 => ALTER ROLE sally SET search_path TO myschema, public, pg_catalog;

###### 查看当前模式
通过 current_schema() 函数，系统可以显示当前模式。例如：

	=> SELECT current_schema();

类似的，使用 SHOW 命令也可以显示当前搜索路径。例如：

	=> SHOW search_path;

##### 删除模式
使用 DROP SCHEMA 命令可以删除一个模式。例如：

	=> DROP SCHEMA myschema;

默认的删除命令只能删除一个空的模式。要删除模式及其内部包含的所有对象（表，数据，函数，等），使用下面的命令：

	=> DROP SCHEMA myschema CASCADE;

##### 系统预定义模式

每个数据库中内置了下列系统模式：

* pg_catalog 包含了系统表，内建数据类型，函数和运算符对象。模式搜索路径时，系统总是会考虑此模式下的所有对象。
* information_schema 模式包含了大量标准化视图来描述数据库内部对象信息。这些视图以标准化方式来展现系统表中的信息。
* pg_toast 存储大对象，例如：记录大笑超过页面大小的对象。此模式下的信息是数据库内部使用的。
* pg_bitmapindex 存储bitmap所有对象，例如：值列表。此模式下的信息是数据库内部使用的。
* pg_aoseg 存储 append-optimized 表对象. 此模式下的信息是数据库内部使用的。
* gp_toolkit 是一个管理视图，内置一些外部表，视图和函数。可以通过SQL语句进行访问。所有数据库用户都能够访问 gp_toolkit 来查看日志文件和其它系统参数。

### 创建和管理表
<&product-name> 中的表和其它关系型数据库十分相似，但是为了适应分布式需求，数据将会分散到多个节点进行存储。每次创建表时，你可以指定数据的分布策略。

#### 创建表
CREATE TABLE命令用来创建和定义表结构，创建表时，您需要定义下面信息：

* 表中包含的列及其对应数据类型。请参考 选择列数据类型。
* 用于限制表或列存储数据的表约束或列约束。请参考 设置表约束和列约束。
* 数据分布策略，系统将会根据策略将数据存储到不同节点。请参考 选择数据分布策略。
* 磁盘存储格式。请参考 表存储模型。
* 大表的数据分区策略。请参考 创建和管理数据库（TODO: 错误？）。

#### 选择列数据类型
列数据类型的选择是根据存储该列的数据值决定的。选择数据类型应该尽可能选择占用空间更小，同时能够保证存储所有数据并能最合理的表达数据。例如：使用字符型数据类型保存字符串，日期或者日期时间戳类型保存日期类型，数值类型来保存数值。

我们建议您使用 VARCHAR 或者 TEXT 来保存文本类数据。我们不推荐使用 CHAR 类型保存文本类型。VARCHAR 或 TEXT 类型对于数据末尾的空白字符将原样保存和处理，但是 CHAR 类型不能满足这个需求。请参考 CREATE TABLE 命令了解更多相关信息。 

您应该使用最小的数值类型同时满足数值存储和未来的扩展需求。例如：使用 BIGINT 类型存储 INT 或者 SMALLINT 会浪费存储空间。如果数据随时间推移需要扩展，并且数据重新加载比较浪费时间，就应该考虑开始就使用更大的数据类型。例如：如果当前数值能够用SMALLINT存储，但是数值会越来越大，那么使用INT类型可能是一个长期来看更好的选择。

如果您考虑连接两张表，那么连接参与的数据类型应该保持一致。通常表连接是用一张表的主键和另一张表的外键进行的。当数据类型不一致时，数据库就需要进行额外的类型转换，然而这完全是无意义的开销。

系统支持大量原生的数据类型，文档后面会进行详细介绍。

#### 设置表约束和列约束

您可以通过在表或者列上创建约束来限制存储到表中的数据。<&product-name> 支持 PostgreSQL 的所有种类的约束，但是您需要注意一些额外的限制条件：

* CHECK 约束只能引用 CHECK 的目标表。
* UNIQUE 和 PRIMARY KEY 约束必须和数据分布键和分区键兼容。
* FOREIGN KEY 约束能够创建，但是系统不会检查此约束是否满足条件。
* 创建在分区表上的约束将会把整个分区表当成一个整体处理。系统不允许针对表中特定分区定义约束条件。

##### Check 约束
Check 约束允许你限制某个列值必须满足一个布尔（真值）表达式。例如，要求产品价格必须是一个正数：

	=> CREATE TABLE products 
	           ( product_no integer, 
	             name text, 
	             price numeric CHECK (price > 0) );

##### 非空约束
非空约束允许你限制某个列值不能为空，此约束总是以列约束形式使用。例如：

	=> CREATE TABLE products 
	           ( product_no integer NOT NULL,
	             name text NOT NULL,
	             price numeric );

##### 约束约束

唯一约束确保存储在一张表中的一列或多列数据数据已定唯一。要使用唯一约束，表必须使用Hash分布策略，并且约束列必须和表的分布键对应的列一致（或者是超集）。例如：

	=> CREATE TABLE products 
	           ( product_no integer UNIQUE, 
	             name text, 
	             price numeric)
	          DISTRIBUTED BY (product_no);

##### 主键约束
主键约束是唯一约束和非空约束的组合。要使用主键约束，表必须使用Hash分布策略，并且约束列必须和表的分布键对应的列一致（或者是超集）。如果一张表指定主键约束，分布键值默认会使用主键约束指定的列。例如：

	=> CREATE TABLE products 
	           ( product_no integer PRIMARY KEY, 
	             name text, 
	             price numeric)
	          DISTRIBUTED BY (product_no);

##### 外键约束
<&product-name> 不支持外键约束，但是允许您声明外键约束。系统不会进行参照完整性检查。

外键约束指定一列或多列必须与另一张表中值相匹配，满足两张表之间的参照完整性。<&product-name>不支持数据分布到多个节点的参照完整性检查。

#### 选择表的数据分布列
所有 <&product-name> 数据表都是分布在多个节点的。当您创建或修改表时，您可以通过使用 DISTRIBUTED BY（基于哈希分布）或者 DISTRIBUTED RANDOMLY(随机分布)来为表指定数据分布规则。

注意：The Greenplum Database server configuration parameter gp_create_table_random_default_distribution controls the table distribution policy if the DISTRIBUTED BY clause is not specified when you create a table.
For information about the parameter, see "Server Configuration Parameters" of the Greenplum Database Reference Guide.

当您在考虑表的数据分布策略时，您可以考虑下面的问题来帮助决策：

* 均匀的分布数据 — 为了尽可能获得最佳性能，每个节点应该尽可能获得均匀的数据。如果数据呈现出极度不均匀，那么数据量较大的节点就需要更多资源甚至是时间才能完成相应的工作。选择数据分布键值时尽量保证键值唯一，例如使用主键约束。
* 局部和分布式运算 — 局部运算远远快于分布是运算。如果连接，排序或聚合运算能够在局部进行（计算和数据在一个节点完成），那么查询的整体速度就会更快。如果某些计算需要在整个系统来完成，那么数据需要进行交换，这样的操作就会降低效率。如果参与连接活着排序的操表都包含相同的数据分布键，那么这样的操作就可以在局部进行。如果数据采用随机分布策略，系统就无法在局部完成像连接这样的操作。
* 均匀的处理请求 — 为了最优的性能，每个节点应该处理均匀的查询工作。如果表的数据分布策略和查询使用数据不匹配，查询的负载就会产生倾斜。例如：销售交易记录表是按照客户ID进行分布的，那么一个查询特定客户ID的查询就只会在一个特定的节点进行计算。

##### 声明数据分布
CREATE TABLE 的可选子句 DISTRIBUTED BY 和 DISTRIBUTED RANDOMLY 可以为表指定数据分布策略。表的默认分布策略是使用主键约束（如果有的话）或者使用表的第一列。地理信息类型或者用户自定义数据类型是不能被用来作为表的数据分布列的。如果一张表没有任何合法的数据分布列，系统默认使用随机数据分布策略。

为了尽可能保证数据的均匀分布，尽量选择能够使数据唯一的分布值。如果没有任何值能够满足，可以使用随机分布策略：

	=> CREATE TABLE products
	                        (name varchar(40),
	                         prod_id integer,
	                         supplier_id integer)
	             DISTRIBUTED BY (prod_id);

	=> CREATE TABLE random_stuff
                            (things text,
                             doodads text,
                             etc text)
                 DISTRIBUTED RANDOMLY;

### Partitioning Large Tables
Table partitioning enables supporting very large tables, such as fact tables, by logically dividing them into smaller, more manageable pieces. Partitioned tables can improve query performance by allowing the Greenplum Database query optimizer to scan only the data needed to satisfy a given query instead of scanning all the contents of a large table.

* About Table Partitioning
* Deciding on a Table Partitioning Strategy
* Creating Partitioned Tables
* Loading Partitioned Tables
* Verifying Your Partition Strategy
* Viewing Your Partition Design
* Maintaining Partitioned Tables
* Parent topic: Defining Database Objects

#### About Table Partitioning
Partitioning does not change the physical distribution of table data across the segments. Table distribution is physical: Greenplum Database physically divides partitioned tables and non-partitioned tables across segments to enable parallel query processing. Table partitioning is logical: Greenplum Database logically divides big tables to improve query performance and facilitate data warehouse maintenance tasks, such as rolling old data out of the data warehouse.

Greenplum Database supports:
* range partitioning: division of data based on a numerical range, such as date or price.
* list partitioning: division of data based on a list of values, such as sales territory or product line.
* A combination of both types.

TODO: Figure 1. Example Multi-level Partition Design 

##### Table Partitioning in Greenplum Database
Greenplum Database divides tables into parts (also known as partitions) to enable massively parallel processing. Tables are partitioned during CREATE TABLE using the PARTITION BY (and optionally the SUBPARTITION BY) clause. Partitioning creates a top-level (or parent) table with one or more levels of sub-tables (or child tables). Internally, Greenplum Database creates an inheritance relationship between the top-level table and its underlying partitions, similar to the functionality of the INHERITS clause of PostgreSQL.

Greenplum uses the partition criteria defined during table creation to create each partition with a distinct CHECK constraint, which limits the data that table can contain. The query optimizer uses CHECK constraints to determine which table partitions to scan to satisfy a given query predicate.

The Greenplum system catalog stores partition hierarchy information so that rows inserted into the top-level parent table propagate correctly to the child table partitions. To change the partition design or table structure, alter the parent table using ALTER TABLE with the PARTITION clause.

To insert data into a partitioned table, you specify the root partitioned table, the table created with the CREATE TABLE command. You also can specify a leaf child table of the partitioned table in an INSERT command. An error is returned if the data is not valid for the specified leaf child table. Specifying a child table that is not a leaf child table in the INSERT command is not supported. Execution of other DML commands such as UPDATE and DELETE on any child table of a partitioned table is not supported. These commands must be executed on the root partitioned table, the table created with the CREATE TABLE command.

#### Deciding on a Table Partitioning Strategy
Not all tables are good candidates for partitioning. If the answer is yes to all or most of the following questions, table partitioning is a viable database design strategy for improving query performance. If the answer is no to most of the following questions, table partitioning is not the right solution for that table. Test your design strategy to ensure that query performance improves as expected.

* Is the table large enough? Large fact tables are good candidates for table partitioning. If you have millions or billions of records in a table, you may see performance benefits from logically breaking that data up into smaller chunks. For smaller tables with only a few thousand rows or less, the administrative overhead of maintaining the partitions will outweigh any performance benefits you might see.
* Are you experiencing unsatisfactory performance? As with any performance tuning initiative, a table should be partitioned only if queries against that table are producing slower response times than desired.
* Do your query predicates have identifiable access patterns? Examine the WHERE clauses of your query workload and look for table columns that are consistently used to access data. For example, if most of your queries tend to look up records by date, then a monthly or weekly date-partitioning design might be beneficial. Or if you tend to access records by region, consider a list-partitioning design to divide the table by region.
* Does your data warehouse maintain a window of historical data? Another consideration for partition design is your organization's business requirements for maintaining historical data. For example, your data warehouse may require that you keep data for the past twelve months. If the data is partitioned by month, you can easily drop the oldest monthly partition from the warehouse and load current data into the most recent monthly partition.
* Can the data be divided into somewhat equal parts based on some defining criteria? Choose partitioning criteria that will divide your data as evenly as possible. If the partitions contain a relatively equal number of records, query performance improves based on the number of partitions created. For example, by dividing a large table into 10 partitions, a query will execute 10 times faster than it would against the unpartitioned table, provided that the partitions are designed to support the query's criteria.

Do not create more partitions than are needed. Creating too many partitions can slow down management and maintenance jobs, such as vacuuming, recovering segments, expanding the cluster, checking disk usage, and others.

Partitioning does not improve query performance unless the query optimizer can eliminate partitions based on the query predicates. Queries that scan every partition run slower than if the table were not partitioned, so avoid partitioning if few of your queries achieve partition elimination. Check the explain plan for queries to make sure that partitions are eliminated. See Query Profiling for more about partition elimination.

Be very careful with multi-level partitioning because the number of partition files can grow very quickly. For example, if a table is partitioned by both day and city, and there are 1,000 days of data and 1,000 cities, the total number of partitions is one million. Column-oriented tables store each column in a physical table, so if this table has 100 columns, the system would be required to manage 100 million files for the table.

Before settling on a multi-level partitioning strategy, consider a single level partition with bitmap indexes. Indexes slow down data loads, so performance testing with your data and schema is recommended to decide on the best strategy.

#### Creating Partitioned Tables
You partition tables when you create them with CREATE TABLE. This topic provides examples of SQL syntax for creating a table with various partition designs.

To partition a table:

1. Decide on the partition design: date range, numeric range, or list of values.
1. Choose the column(s) on which to partition the table.
1. Decide how many levels of partitions you want. For example, you can create a date range partition table by month and then subpartition the monthly partitions by sales region.

* Defining Date Range Table Partitions
* Defining Numeric Range Table Partitions
* Defining List Table Partitions
* Defining Multi-level Partitions
* Partitioning an Existing Table

##### Defining Date Range Table Partitions
A date range partitioned table uses a single date or timestamp column as the partition key column. You can use the same partition key column to create subpartitions if necessary, for example, to partition by month and then subpartition by day. Consider partitioning by the most granular level. For example, for a table partitioned by date, you can partition by day and have 365 daily partitions, rather than partition by year then subpartition by month then subpartition by day. A multi-level design can reduce query planning time, but a flat partition design runs faster.

You can have Greenplum Database automatically generate partitions by giving a START value, an END value, and an EVERY clause that defines the partition increment value. By default, START values are always inclusive and END values are always exclusive. For example:

	CREATE TABLE sales (id int, date date, amt decimal(10,2))
	DISTRIBUTED BY (id)
	PARTITION BY RANGE (date)
	( START (date '2008-01-01') INCLUSIVE
	   END (date '2009-01-01') EXCLUSIVE
	   EVERY (INTERVAL '1 day') );

You can also declare and name each partition individually. For example:

	CREATE TABLE sales (id int, date date, amt decimal(10,2))
	DISTRIBUTED BY (id)
	PARTITION BY RANGE (date)
	( PARTITION Jan08 START (date '2008-01-01') INCLUSIVE , 
	  PARTITION Feb08 START (date '2008-02-01') INCLUSIVE ,
	  PARTITION Mar08 START (date '2008-03-01') INCLUSIVE ,
	  PARTITION Apr08 START (date '2008-04-01') INCLUSIVE ,
	  PARTITION May08 START (date '2008-05-01') INCLUSIVE ,
	  PARTITION Jun08 START (date '2008-06-01') INCLUSIVE ,
	  PARTITION Jul08 START (date '2008-07-01') INCLUSIVE ,
	  PARTITION Aug08 START (date '2008-08-01') INCLUSIVE ,
	  PARTITION Sep08 START (date '2008-09-01') INCLUSIVE ,
	  PARTITION Oct08 START (date '2008-10-01') INCLUSIVE ,
	  PARTITION Nov08 START (date '2008-11-01') INCLUSIVE ,
	  PARTITION Dec08 START (date '2008-12-01') INCLUSIVE 
	                  END (date '2009-01-01') EXCLUSIVE );

You do not have to declare an END value for each partition, only the last one. In this example, Jan08 ends where Feb08 starts.

##### Defining Numeric Range Table Partitions
A numeric range partitioned table uses a single numeric data type column as the partition key column. For example:

	CREATE TABLE rank (id int, rank int, year int, gender 
	char(1), count int)
	DISTRIBUTED BY (id)
	PARTITION BY RANGE (year)
	( START (2001) END (2008) EVERY (1), 
	  DEFAULT PARTITION extra ); 

For more information about default partitions, see Adding a Default Partition.

##### Defining List Table Partitions
A list partitioned table can use any data type column that allows equality comparisons as its partition key column. A list partition can also have a multi-column (composite) partition key, whereas a range partition only allows a single column as the partition key. For list partitions, you must declare a partition specification for every partition (list value) you want to create. For example:

	CREATE TABLE rank (id int, rank int, year int, gender 
	char(1), count int ) 
	DISTRIBUTED BY (id)
	PARTITION BY LIST (gender)
	( PARTITION girls VALUES ('F'), 
	  PARTITION boys VALUES ('M'), 
	  DEFAULT PARTITION other );

Note: The current Greenplum Database legacy optimizer allows list partitions with multi-column (composite) partition keys. A range partition only allows a single column as the partition key. The Pivotal Query Optimizer, that will available in a future release, does not support composite keys, so Pivotal does not recommend using composite partition keys.
For more information about default partitions, see Adding a Default Partition.

##### Defining Multi-level Partitions
You can create a multi-level partition design with subpartitions of partitions. Using a subpartition template ensures that every partition has the same subpartition design, including partitions that you add later. For example, the following SQL creates the two-level partition design shown in Figure 1:

	CREATE TABLE sales (trans_id int, date date, amount 
	decimal(9,2), region text) 
	DISTRIBUTED BY (trans_id)
	PARTITION BY RANGE (date)
	SUBPARTITION BY LIST (region)
	SUBPARTITION TEMPLATE
	( SUBPARTITION usa VALUES ('usa'), 
	  SUBPARTITION asia VALUES ('asia'), 
	  SUBPARTITION europe VALUES ('europe'), 
	  DEFAULT SUBPARTITION other_regions)
	  (START (date '2011-01-01') INCLUSIVE
	   END (date '2012-01-01') EXCLUSIVE
	   EVERY (INTERVAL '1 month'), 
	   DEFAULT PARTITION outlying_dates );

The following example shows a three-level partition design where the sales table is partitioned by year, then month, then region. The SUBPARTITION TEMPLATE clauses ensure that each yearly partition has the same subpartition structure. The example declares a DEFAULT partition at each level of the hierarchy.

	CREATE TABLE p3_sales (id int, year int, month int, day int, 
	region text)
	DISTRIBUTED BY (id)
	PARTITION BY RANGE (year)
	    SUBPARTITION BY RANGE (month)
	       SUBPARTITION TEMPLATE (
	        START (1) END (13) EVERY (1), 
	        DEFAULT SUBPARTITION other_months )
	           SUBPARTITION BY LIST (region)
	             SUBPARTITION TEMPLATE (
	               SUBPARTITION usa VALUES ('usa'),
	               SUBPARTITION europe VALUES ('europe'),
	               SUBPARTITION asia VALUES ('asia'),
	               DEFAULT SUBPARTITION other_regions )
	( START (2002) END (2012) EVERY (1), 
	  DEFAULT PARTITION outlying_years );

CAUTION:
When you create multi-level partitions on ranges, it is easy to create a large number of subpartitions, some containing little or no data. This can add many entries to the system tables, which increases the time and memory required to optimize and execute queries. Increase the range interval or choose a different partitioning strategy to reduce the number of subpartitions created.

##### Partitioning an Existing Table
Tables can be partitioned only at creation. If you have a table that you want to partition, you must create a partitioned table, load the data from the original table into the new table, drop the original table, and rename the partitioned table with the original table's name. You must also re-grant any table permissions. For example:

	CREATE TABLE sales2 (LIKE sales) 
	PARTITION BY RANGE (date)
	( START (date '2008-01-01') INCLUSIVE
	   END (date '2009-01-01') EXCLUSIVE
	   EVERY (INTERVAL '1 month') );
	INSERT INTO sales2 SELECT * FROM sales;
	DROP TABLE sales;
	ALTER TABLE sales2 RENAME TO sales;
	GRANT ALL PRIVILEGES ON sales TO admin;
	GRANT SELECT ON sales TO guest;

##### Limitations of Partitioned Tables
For each partition level, a partitioned table can have a maximum of 32,767 partitions.

A primary key or unique constraint on a partitioned table must contain all the partitioning columns. A unique index can omit the partitioning columns; however, it is enforced only on the parts of the partitioned table, not on the partitioned table as a whole.

The Pivotal Query Optimizer supports uniform multi-level partitioned tables. If Pivotal Query Optimizer is enabled and the multi-level partitioned table is not uniform, Greenplum Database executes queries against the table with the legacy query optimizer. For information about uniform multi-level partitioned tables, see About Uniform Multi-level Partitioned Tables.

Exchanging a leaf child partition with an external table is not supported if the partitioned table is created with the SUBPARITION clause or if a partition has a subpartition. For information about exchanging a leaf child partition with an external table, see Exchanging a Leaf Child Partition with an External Table.

These are limitations for partitioned tables when a leaf child partition of the table is an external table:

* Queries that run against partitioned tables that contain external table partitions are executed with the legacy query optimizer.
* The external table partition is a read only external table. Commands that attempt to access or modify data in the external table partition return an error. For example:
	* INSERT, DELETE, and UPDATE commands that attempt to change data in the external table partition return an error.
	* TRUNCATE commands return an error.
	* COPY commands cannot copy data to a partitioned table that updates an external table partition.
	* COPY commands that attempt to copy from an external table partition return an error unless you specify the IGNORE EXTERNAL PARTITIONS clause with COPY command. If you specify the clause, data is not copied from external table partitions.
To use the COPY command against a partitioned table with a leaf child table that is an external table, use an SQL query to copy the data. For example, if the table my_sales contains a with a leaf child table that is an external table, this command sends the data to stdout:

			COPY (SELECT * from my_sales ) TO stdout

	* VACUUM commands skip external table partitions.

* The following operations are supported if no data is changed on the external table partition. Otherwise, an error is returned.
	* Adding or dropping a column.
	* Changing the data type of column.

* These ALTER PARTITION operations are not supported if the partitioned table contains an external table partition:
	* Setting a subpartition template.
	* Altering the partition properties.
	* Creating a default partition.
	* Setting a distribution policy.
	* Setting or dropping a NOT NULL constraint of column.
	* Adding or dropping constraints.
	* Splitting an external partition.

* The Greenplum Database utility gpcrondump does not back up data from a leaf child partition of a partitioned table if the leaf child partition is a readable external table.

##### Loading Partitioned Tables
After you create the partitioned table structure, top-level parent tables are empty. Data is routed to the bottom-level child table partitions. In a multi-level partition design, only the subpartitions at the bottom of the hierarchy can contain data.

Rows that cannot be mapped to a child table partition are rejected and the load fails. To avoid unmapped rows being rejected at load time, define your partition hierarchy with a DEFAULT partition. Any rows that do not match a partition's CHECK constraints load into the DEFAULT partition. See Adding a Default Partition.

At runtime, the query optimizer scans the entire table inheritance hierarchy and uses the CHECK table constraints to determine which of the child table partitions to scan to satisfy the query's conditions. The DEFAULT partition (if your hierarchy has one) is always scanned. DEFAULT partitions that contain data slow down the overall scan time.

When you use COPY or INSERT to load data into a parent table, the data is automatically rerouted to the correct partition, just like a regular table.

Best practice for loading data into partitioned tables is to create an intermediate staging table, load it, and then exchange it into your partition design. See Exchanging a Partition.

##### Verifying Your Partition Strategy
When a table is partitioned based on the query predicate, you can use EXPLAIN to verify that the query optimizer scans only the relevant data to examine the query plan.

For example, suppose a sales table is date-range partitioned by month and subpartitioned by region as shown in Figure 1. For the following query:

	EXPLAIN SELECT * FROM sales WHERE date='01-07-12' AND region='usa';

The query plan for this query should show a table scan of only the following tables:

* the default partition returning 0-1 rows (if your partition design has one)
* the January 2012 partition (sales_1_prt_1) returning 0-1 rows
* the USA region subpartition (sales_1_2_prt_usa) returning some number of rows.

The following example shows the relevant portion of the query plan.

	->  Seq Scan onsales_1_prt_1 sales (cost=0.00..0.00 rows=0 width=0)
			Filter: "date"=01-07-08::date AND region='USA'::text
	->  Seq Scan onsales_1_2_prt_usa sales (cost=0.00..9.87 rows=20 width=40)

Ensure that the query optimizer does not scan unnecessary partitions or subpartitions (for example, scans of months or regions not specified in the query predicate), and that scans of the top-level tables return 0-1 rows.

##### Troubleshooting Selective Partition Scanning
The following limitations can result in a query plan that shows a non-selective scan of your partition hierarchy.

* The query optimizer can selectively scan partitioned tables only when the query contains a direct and simple restriction of the table using immutable operators such as:
=, < , <= , >,  >= , and <>
* Selective scanning recognizes STABLE and IMMUTABLE functions, but does not recognize VOLATILE functions within a query. For example, WHERE clauses such as date > CURRENT_DATE cause the query optimizer to selectively scan partitioned tables, but time > TIMEOFDAY does not.

#### Viewing Your Partition Design
You can look up information about your partition design using the pg_partitions view. For example, to see the partition design of the sales table:

	SELECT partitionboundary, partitiontablename, partitionname, 
	partitionlevel, partitionrank 
	FROM pg_partitions 
	WHERE tablename='sales';
The following table and views show information about partitioned tables.
	
* pg_partition - Tracks partitioned tables and their inheritance level relationships.
* pg_partition_templates - Shows the subpartitions created using a subpartition template.
* pg_partition_columns - Shows the partition key columns used in a partition design.
For information about Greenplum Database system catalog tables and views, see the Greenplum Database Reference Guide.

#### Maintaining Partitioned Tables
To maintain a partitioned table, use the ALTER TABLE command against the top-level parent table. The most common scenario is to drop old partitions and add new ones to maintain a rolling window of data in a range partition design. You can convert (exchange) older partitions to the append-optimized compressed storage format to save space. If you have a default partition in your partition design, you add a partition by splitting the default partition.

* Adding a Partition
* Renaming a Partition
* Adding a Default Partition
* Dropping a Partition
* Truncating a Partition
* Exchanging a Partition
* Splitting a Partition
* Modifying a Subpartition Template
* Exchanging a Leaf Child Partition with an External Table

Important: When defining and altering partition designs, use the given partition name, not the table object name. Although you can query and load any table (including partitioned tables) directly using SQL commands, you can only modify the structure of a partitioned table using the ALTER TABLE...PARTITION clauses.
Partitions are not required to have names. If a partition does not have a name, use one of the following expressions to specify a part: PARTITION FOR (value) or )PARTITION FOR(RANK(number).

##### Adding a Partition
You can add a partition to a partition design with the ALTER TABLE command. If the original partition design included subpartitions defined by a subpartition template, the newly added partition is subpartitioned according to that template. For example:

	ALTER TABLE sales ADD PARTITION 
	            START (date '2009-02-01') INCLUSIVE 
	            END (date '2009-03-01') EXCLUSIVE;
If you did not use a subpartition template when you created the table, you define subpartitions when adding a partition:

	ALTER TABLE sales ADD PARTITION 
	            START (date '2009-02-01') INCLUSIVE 
	            END (date '2009-03-01') EXCLUSIVE
	      ( SUBPARTITION usa VALUES ('usa'), 
	        SUBPARTITION asia VALUES ('asia'), 
	        SUBPARTITION europe VALUES ('europe') );
When you add a subpartition to an existing partition, you can specify the partition to alter. For example:

	ALTER TABLE sales ALTER PARTITION FOR (RANK(12))
	      ADD PARTITION africa VALUES ('africa');
Note: You cannot add a partition to a partition design that has a default partition. You must split the default partition to add a partition. See Splitting a Partition.

##### Renaming a Partition
Partitioned tables use the following naming convention. Partitioned subtable names are subject to uniqueness requirements and length limitations.

	<parentname>_<level>_prt_<partition_name>
For example:

	sales_1_prt_jan08
For auto-generated range partitions, where a number is assigned when no name is given):

	sales_1_prt_1
To rename a partitioned child table, rename the top-level parent table. The <parentname> changes in the table names of all associated child table partitions. For example, the following command:

	ALTER TABLE sales RENAME TO globalsales;
Changes the associated table names:

	globalsales_1_prt_1
You can change the name of a partition to make it easier to identify. For example:

	ALTER TABLE sales RENAME PARTITION FOR ('2008-01-01') TO jan08;
Changes the associated table name as follows:

	sales_1_prt_jan08
When altering partitioned tables with the ALTER TABLE command, always refer to the tables by their partition name (jan08) and not their full table name (sales_1_prt_jan08).

Note: The table name cannot be a partition name in an ALTER TABLE statement. For example, ALTER TABLE sales... is correct, ALTER TABLE sales_1_part_jan08... is not allowed.

##### Adding a Default Partition
You can add a default partition to a partition design with the ALTER TABLE command.

	ALTER TABLE sales ADD DEFAULT PARTITION other;
If your partition design is multi-level, each level in the hierarchy must have a default partition. For example:

	ALTER TABLE sales ALTER PARTITION FOR (RANK(1)) ADD DEFAULT PARTITION other;

	ALTER TABLE sales ALTER PARTITION FOR (RANK(2)) ADD DEFAULT PARTITION other;

	ALTER TABLE sales ALTER PARTITION FOR (RANK(3)) ADD DEFAULT PARTITION other;
If incoming data does not match a partition's CHECK constraint and there is no default partition, the data is rejected. Default partitions ensure that incoming data that does not match a partition is inserted into the default partition.

##### Dropping a Partition
You can drop a partition from your partition design using the ALTER TABLE command. When you drop a partition that has subpartitions, the subpartitions (and all data in them) are automatically dropped as well. For range partitions, it is common to drop the older partitions from the range as old data is rolled out of the data warehouse. For example:

	ALTER TABLE sales DROP PARTITION FOR (RANK(1));

##### Truncating a Partition
You can truncate a partition using the ALTER TABLE command. When you truncate a partition that has subpartitions, the subpartitions are automatically truncated as well.

	ALTER TABLE sales TRUNCATE PARTITION FOR (RANK(1));

##### Exchanging a Partition
You can exchange a partition using the ALTER TABLE command. Exchanging a partition swaps one table in place of an existing partition. You can exchange partitions only at the lowest level of your partition hierarchy (only partitions that contain data can be exchanged).

Partition exchange can be useful for data loading. For example, load a staging table and swap the loaded table into your partition design. You can use partition exchange to change the storage type of older partitions to append-optimized tables. For example:

	CREATE TABLE jan12 (LIKE sales) WITH (appendonly=true);
	INSERT INTO jan12 SELECT * FROM sales_1_prt_1 ;
	ALTER TABLE sales EXCHANGE PARTITION FOR (DATE '2012-01-01') 
	WITH TABLE jan12;
Note: This example refers to the single-level definition of the table sales, before partitions were added and altered in the previous examples.
Warning: If you specify the WITHOUT VALIDATION clause, you must ensure that the data in table that you are exchanging for an existing partition is valid against the constraints on the partition. Otherwise, queries against the partitioned table might return incorrect results.
The Greenplum Database server configuration parameter gp_enable_exchange_default_partition controls availability of the EXCHANGE DEFAULT PARTITION clause. The default value for the parameter is off, the clause is not available and Greenplum Database returns an error if the clause is specified in an ALTER TABLE command.

For information about the parameter, see "Server Configuration Parameters" in the Greenplum Database Reference Guide.
Warning: Before you exchange the default partition, you must ensure the data in the table to be exchanged, the new default partition, is valid for the default partition. For example, the data in the new default partition must not contain data that would be valid in other leaf child partitions of the partitioned table. Otherwise, queries against the partitioned table with the exchanged default partition that are executed by the Pivotal Query Optimizer might return incorrect results.

##### Splitting a Partition
Splitting a partition divides a partition into two partitions. You can split a partition using the ALTER TABLE command. You can split partitions only at the lowest level of your partition hierarchy: only partitions that contain data can be split. The split value you specify goes into the latter partition.

For example, to split a monthly partition into two with the first partition containing dates January 1-15 and the second partition containing dates January 16-31:

	ALTER TABLE sales SPLIT PARTITION FOR ('2008-01-01')
	AT ('2008-01-16')
	INTO (PARTITION jan081to15, PARTITION jan0816to31);
If your partition design has a default partition, you must split the default partition to add a partition.

When using the INTO clause, specify the current default partition as the second partition name. For example, to split a default range partition to add a new monthly partition for January 2009:

	ALTER TABLE sales SPLIT DEFAULT PARTITION 
	START ('2009-01-01') INCLUSIVE 
	END ('2009-02-01') EXCLUSIVE 
	INTO (PARTITION jan09, default partition);

##### Modifying a Subpartition Template
Use ALTER TABLE SET SUBPARTITION TEMPLATE to modify the subpartition template of a partitioned table. Partitions added after you set a new subpartition template have the new partition design. Existing partitions are not modified.

The following example alters the subpartition template of this partitioned table:
	CREATE TABLE sales (trans_id int, date date, amount decimal(9,2), region text)
	  DISTRIBUTED BY (trans_id)
	  PARTITION BY RANGE (date)
	  SUBPARTITION BY LIST (region)
	  SUBPARTITION TEMPLATE
	    ( SUBPARTITION usa VALUES ('usa'),
	      SUBPARTITION asia VALUES ('asia'),
	      SUBPARTITION europe VALUES ('europe'),
	      DEFAULT SUBPARTITION other_regions )
	  ( START (date '2014-01-01') INCLUSIVE
	    END (date '2014-04-01') EXCLUSIVE
	    EVERY (INTERVAL '1 month') );
This ALTER TABLE command, modifies the subpartition template.

	ALTER TABLE sales SET SUBPARTITION TEMPLATE
	( SUBPARTITION usa VALUES ('usa'), 
	  SUBPARTITION asia VALUES ('asia'), 
	  SUBPARTITION europe VALUES ('europe'),
	  SUBPARTITION africa VALUES ('africa'), 
	  DEFAULT SUBPARTITION regions );
When you add a date-range partition of the table sales, it includes the new regional list subpartition for Africa. For example, the following command creates the subpartitions usa, asia, europe, africa, and a default partition named other:

	ALTER TABLE sales ADD PARTITION "4"
	  START ('2014-04-01') INCLUSIVE 
	  END ('2014-05-01') EXCLUSIVE ;
To view the tables created for the partitioned table sales, you can use the command \dt sales* from the psql command line.

To remove a subpartition template, use SET SUBPARTITION TEMPLATE with empty parentheses. For example, to clear the sales table subpartition template:

	ALTER TABLE sales SET SUBPARTITION TEMPLATE ();

##### Exchanging a Leaf Child Partition with an External Table
You can exchange a leaf child partition of a partitioned table with a readable external table.The external table data can reside on a host file system, an NFS mount, or a Hadoop file system (HDFS).

For example, if you have a partitioned table that is created with monthly partitions and most of the queries against the table only access the newer data, you can copy the older, less accessed data to external tables and exchange older partitions with the external tables. For queries that only access the newer data, you could create queries that use partition elimination to prevent scanning the older, unneeded partitions.

Exchanging a leaf child partition with an external table is not supported in these cases:
* The partitioned table is created with the SUBPARITION clause or if a partition has a subpartition.
* The partitioned table contains a column with a check constraint or a NOT NULL constraint.
For information about exchanging and altering a leaf child partition, see the ALTER TABLE command in the Greenplum Database Command Reference.

For information about limitations of partitioned tables that contain a external table partition, see Limitations of Partitioned Tables.

###### Example Exchanging a Partition with an External Table

This is a simple example that exchanges a leaf child partition of this partitioned table for an external table. The partitioned table contains data for the years 2000 through 2003.

	CREATE TABLE sales (id int, year int, qtr int, day int, region text)
	  DISTRIBUTED BY (id) 
	  PARTITION BY RANGE (year) 
	  ( PARTITION yr START (2000) END (2004) EVERY (1) ) ;
There are four leaf child partitions for the partitioned table. Each leaf child partition contains the data for a single year. The leaf child partition table sales_1_prt_yr_1 contains the data for the year 2000. These steps exchange the table sales_1_prt_yr_1 with an external table the uses the gpfdist protocol:

1. Ensure that the external table protocol is enabled for the Greenplum Database system.
This example uses the gpfdist protocol. This command starts the gpfdist protocol.

		$ gpfdist

1. Create a writable external table.
This CREATE WRITABLE EXTENAL TABLE command creates a writeable external table with the same columns as the partitioned table.

		CREATE WRITABLE EXTERNAL TABLE my_sales_ext ( LIKE sales_1_prt_yr_1 )
		  LOCATION ( 'gpfdist://gpdb_test/sales_2000' )
		  FORMAT 'csv' 
		  DISTRIBUTED BY (id) ;

1. Create a readable external table that reads the data from that destination of the writable external table created in the previous step.
This CREATE EXTENAL TABLE create a readable external that uses the same external data as the writeable external data.

		CREATE EXTERNAL TABLE sales_2000_ext ( LIKE sales_1_prt_yr_1) 
		  LOCATION ( 'gpfdist://gpdb_test/sales_2000' )
		  FORMAT 'csv' ;

1. Copy the data from the leaf child partition into the writable external table.
This INSERT command copies the data from the child leaf partition table of the partitioned table into the external table.

		INSERT INTO my_sales_ext SELECT * FROM sales_1_prt_yr_1 ;

1. Exchange the existing leaf child partition with the external table.
This ALTER TABLE command specifies the EXCHANGE PARTITION clause to switch the readable external table and the leaf child partition.

		ALTER TABLE sales ALTER PARTITION yr_1 
		   EXCHANGE PARTITION yr_1 
		   WITH TABLE sales_2000_ext WITHOUT VALIDATION;
	The external table becomes the leaf child partition with the table name sales_1_prt_yr_1 and the old leaf child partition becomes the table sales_2000_ext.
Warning: In order to ensure queries against the partitioned table return the correct results, the external table data must be valid against the CHECK constraints on the leaf child partition. In this case, the data was taken from the child leaf partition table on which the CHECK constraints were defined.

1. Drop the table that was rolled out of the partitioned table.

		DROP TABLE sales_2000_ext ;
	You can rename the name of the leaf child partition to indicate that sales_1_prt_yr_1 is an external table.

This example command changes the partitionname to yr_1_ext and the name of the child leaf partition table to sales_1_prt_yr_1_ext.

	ALTER TABLE sales RENAME PARTITION yr_1 TO  yr_1_ext ;

### 创建和使用序列
通过使用序列，系统可以在新的纪录插入表中时，自动地按照自增方式分配一个唯一ID。使用序列一半就是为插入表中的纪录自动分配一个唯一标识符。您可以通过声明一个 SERIAL 类型的标识符列，该类型将会自动创建一个序列来分配ID。

#### 创建序列
CREATE SEQUENCE 命令用来创建和初始化一张特殊的单行序列生成器表，该表名称就是指定序列的名称。序列的名称在同一个模式下，不能与其它序列，表，索引或者视图重名。示例：

	CREATE SEQUENCE myserial START 101;

#### 使用序列
在使用 CREATE SEQUENCE 创建系列生成器表后，可以通过 nextval 函数来使用序列。例如下面例子，向表中插入新数据时，自动获得下一个序列值：

	INSERT INTO vendors VALUES (nextval('myserial'), 'acme');

还可以通过使用函数 setval 来重置序列的值。示例：

	SELECT setval('myserial', 201);

请注意 nextval 操作是不会回滚的，数值一旦被获取，即使最终事务回滚，该数据也被认为已经被分配和使用了。这意味着失败的事务会给序列分配的数值中留下空洞。类似地，setval操作也不支持回滚。

通过下面的查询，可以检查序列的当前值：

	SELECT * FROM myserial;

#### 修改序列
ALTER SEQUENCE 命令可以修改已经存在的序列生成器参数。例如：

	ALTER SEQUENCE myserial RESTART WITH 105;


#### 删除序列
DROP SEQUENCE 命令删除序列生成表。例如：

	DROP SEQUENCE myserial;

### 使用索引
在绝大部分传统数据中，索引都能够极大地提高数据访问速速。然而，在像 <&product-name> 这样的分布式数据库系统中，索引的使用需要更加谨慎。

<&product-name> 执行顺序扫描的速度非常快，索引只用来随机访问时，在磁盘上定位特定数据。由于数据是分散在多个节点上的，因此每个节点数据相对更少。再加上使用分区表功能，实际的顺序扫描可能更小。因为商业智能(BI)类应用通常返回较大的结果数据，因此索引并不高效。

请尝试在没有索引的情况下，运行查询。一般情况下，对于OLTP类型业务，索引对性能的影响更大。因为这类查询一般只返回一条或较少的数据。对于压缩的 append 表来说，对于返回一部分数据的查询来说性能也能得到提高。这是因为优化器可以使用索引访问来避免使用全表的顺序扫描。对于压缩的数据，使用索引访问方法时，只有需要的数据才会被解压缩。

<&product-name> 对于包含主键的表自动创建主键约束。要对分区表创建索引，只需要在分区表上创建所以即可。<&product-name> 能够自动在分区表下的分区上创建对应索引。<&product-name> 不支持对分区表下的分区创建单独的索引。

请注意，唯一约束会隐式地创建唯一索引，唯一索引会包含所有数据分布键和分区键。唯一约束是对整个表范围保证唯一性的（包括所有的分区）。

索引会增加数据库系统的运行开销，它们占用存储空间并且在数据更新时，需要额外的维护工作。请确保查询集合在使用您创建的索引后，性能得到了改善（和全表顺序扫描相比）。您可以使用 EXPLAIN 命令来确认索引是否被使用。

创建索引时，您需要注意下面的问题点：

* 您的查询特点。索引对于查询只返回单条记录或者较少的数据集时，性能提升明显。
* 压缩表。对于压缩的 append 表来说，对于返回一部分数据的查询来说性能也能得到提高。对于压缩的数据，使用索引访问方法时，只有需要的数据才会被解压缩。
* 避免在经常改变的列上创建索引。在经常更新的列上创建索引会导致每次更新数据时写操作大量增加。
* 创建选择率高的 B-树索引。索引选择率是列的唯一值除以记录数的比值。例如，一张表有 1000 条记录，其中有 800 个唯一值，这个列索引的选择率就是 0.8，这个数值就比较好。唯一索引的选择率总是 1.0，也是选择率最好的。<&product-name> 只允许创建包含表数据分布键的唯一索引。
* 对于选择率较低的列，使用 Bitmap 索引。
* 对参与连接操作的列创建索引。对经常用于连接的列（例如：外键列）创建索引，可以让查询优化器使用更多的连接算法，进而提高连接效率。
* 对经常出现在 WHERE 条件中的列创建索引。
* 避免创建冗余的索引。如果索引开头几列重复出现在多个索引中，这些索引就是冗余的。
* 在大量数据加载时，删除索引。如果要向表中加载大量数据，考虑加载数据前删除索引，加载后重新建立索引的方法。这样的操作通常比带着索引加载要快。
* 考虑聚簇索引。聚簇索引是指数据在物理上，按照索引顺序存储。如果您访问的数据在磁盘是随机存储，那么数据库就需要磁盘上不断变更位置读取您需要的数据。如果数据更佳紧密的存储起来，读取数据的操作效率就会更高。例如：在日期列上创建聚簇索引，数据也是按照日期列顺序存储。一个查询如果读取一个日期范围的数据，那么就可以利用磁盘顺序扫描的快速特性。

#### 聚簇索引
对一张非常的表，使用 CLUSTER 命令来根据索引对表的物理存储进行重新排序可能花费非常长的时间。您可以通过手工将排序的表数据导入一张中间表，来加上面的操作，例如：

	CREATE TABLE new_table (LIKE old_table) 
	       AS SELECT * FROM old_table ORDER BY myixcolumn;
	DROP old_table;
	ALTER TABLE new_table RENAME TO old_table;
	CREATE INDEX myixcolumn_ix ON old_table;
	VACUUM ANALYZE old_table;

#### 索引类型
<&product-name> 支持 Postgres 中索引类型 B树 和 GiST. Hash 和 GIN 索引不支持。每一种索引都使用不同算法，因此适用的查询也不同。B树索引适用于大部分常见情况，因此也是默认类型。您可以参考 PostgreSQL 文档中关于索引的相关介绍。

注意：唯一索引使用的列必须和表的分布键值一样（或超集）。append-optimized 存储类型的表不支持唯一索引。对于分区表来说，唯一索引不能对整张表（对所有子表）来保证唯一性。唯一索引可以对于一个子分区保证唯一性。

##### 关于 Bitmap 索引
<&product-name> 提供了 Bitmap 索引类型。Bitmap 索引特别适合大数据量的数据仓库应用和决策支持系统这种查询，临时性查询特别多，数据改动少的业务。

索引提供根据指定键值指向表中记录的指针。一般的索引存储了每个键值对应的所有记录ID映射关系。而 Bitmap 索引是将键值存储为位图形式。一般的索引可能会占用实际数据几倍的存储空间，但是 Bitmap 索引在提供相同功能下，需要的存储远远小于实际的数据大小。

位图中的每一位对应一个记录ID。如果位被设置了，该记录ID指向的记录满足键值。一个映射函数负责将比特位置转换为记录ID。位图使用压缩进行存储。如果键值去重后的数量比较少，bitmap 索引相比普通的索引来说，体积非常小，压缩效果更好，能够更好的节省存储空间。因此 bitmap 索引的大小可以近似通过记录总数乘以索引列去重后的数量得出。

对于在 WHERE 子句中包含多个条件的查询来说，bitmap 索引一般都非常有效。如果在访问数据表之前，就能过滤掉只满足部分条件的记录，那么查询响应时间就会得到巨大的提升。

##### When to Use Bitmap Indexes
Bitmap索引特别适用数据仓库类型的应用程序，因为数据的更新相对非常少。Bitmap索引对于去重后列值在 100 到 10,0000 个，并且查询时经常是类似这样的多列参一起使用的查询性能提升非常明显。但是像性别这种只有两个值的类型，实际上索引并不能提供比较好的性能提升。如果去重后的值多余 10,0000 个，bitmap 索引的性能收益和存储效率都会开始下降。

Bitmap 索引对于临时性的查询性能改进比较明显。在 WHERE 子句中的 AND 和 OR 条件来说，可以利用 bitmap 索引信息快速得到满足条件的结果，而不用首先读取记录信息。如果结果集数据很少，查询就不需要使用全表扫描，并且能非常快的返回结果。
##### 不适合使用Bitmap索引的情况
如果列的数据唯一或者重复非常少，就应该避免使用bitmap索引。bitmap索引的性能优势和存储优势在列的唯一值超过10,0000后就会开始下降。与表中的总纪录数没有任何关系。
Bitmap索引也不适合并发修改数据事务特别多的OLTP类型应用。
使用bitmap索引应该谨慎，仔细对比建立索引前后的查询性能。只添加那些对查询性能有帮助的索引。

#### 创建索引
CREATE INDEX 命令可以给指定的表定义索引。索引的默认类型是：B树索引。下面例子给表 employee 的 gender 列，添加了一个B树索引：

	CREATE INDEX gender_idx ON employee (gender);

为 films 表的 title 列创建 bitmap 索引：

	CREATE INDEX title_bmp_idx ON films USING bitmap (title);

#### 检查索引的
<&product-name> 索引不需要维护和调优。你可以通过真实的查询来检查索引的使用情况。EXPLAIN 命令可以用来检查一个查询使用索引的情况。
查询计划会显示数据库为了回答您的查询所需要的步骤和计划节点，并给出每个节点的时间开销评估。要检查索引的使用情况，可以通过检查 EXPLAIN 输出中下面查询计划节点：

* Index Scan - 扫描索引
* Bitmap Heap Scan - 根据 BitmapAnd， BitmapOr，或 BitmapIndexScan 生成位图，从 heap 文件中读取相应的记录。
* Bitmap Index Scan - 通过底层的索引，生成满足多个查询的条件的位图信息。
* BitmapAnd 或 BitmapOr - 根据多个 BitmapIndexScan 生成的位图进行位与和位或运算，生成新的位图。

创建索引前，您需要做一些实验来决定如何创建索引，下面是一些您需要考虑的地方：

* 当你创建或更新索引后，最好运行 ANALYZE 命令。ANALYZE 针对表收集统计信息。查询优化器会利用表的统计信息来评估查询返回的结果数量，并且对每种查询计划估算更真实的时间开销。
* 使用真实数据来进行实验。如果利用测试数据来决定添加索引，那么你的索引只是针对测试数据进行了优化。
* 不要使用可能导致结果不真实或者数据倾斜的小数据集进行测试。
* 设计测试数据时需要非常小心。测试数据如果过于相似，完全随机，按特定顺序导入，都可能导致统计数据与真实数据分布的巨大差异。
* 你可以通过调整运行时参数来禁用某些特定查询类型，这样可以更加针对性对索引使用进行测试。例如：关闭顺序扫描（enable_seqscan）和嵌套连接（enable_nestloop），及其它基础查询计划，可以强制系统选择其它类型的查询计划。通过对查询计时和利用 EXPLAIN ANALYZE 命令来对比使用和不使用索引的查询结果。

#### 索引管理
使用 REINDEX 命令可以对戏能不好的索引进行重新创建。REINDEX 重建是对表中数据重建并替换就索引实现的。

在指定表上重新生成所有索引：

	REINDEX my_table;

对指定索引重新生成：

	REINDEX my_index;

#### 删除索引
DROP INDEX 命令删除一个索引，例如：

	DROP INDEX title_idx;

加载数据时，可以通过首先删除索引，加载数据，再重新建立索引的方式加快数据加载速度。

### 创建和管理视图
视图能够将您常用或复杂的查询保存起来，并允许您在 SELECT 语句中像访问表一样访问保存的查询。视图并不会导致在磁盘上存储数据，而是在访问视图时，视图定义的查询以自查询的方式被饮用。

如果某个自查询只被某个特定查询使用，考虑使用 SELECT 语句的 WITH 子句来避免创建一张不能被公用的视图。

#### 创建视图
CREATE VIEW 命令根据一个查询定义一个视图，例如：

	CREATE VIEW comedies AS SELECT * FROM films WHERE kind = 'comedy';

视图会忽略视图定义查询中的 ORDER BY 和 SORT 的功能。

#### 删除视图
DROP VIEW 删除一张视图，例如:

	DROP VIEW topten;