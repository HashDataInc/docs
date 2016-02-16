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

#### Choosing the Table Distribution Policy
All Greenplum Database tables are distributed. When you create or alter a table, you optionally specify DISTRIBUTED BY (hash distribution) or DISTRIBUTED RANDOMLY (round-robin distribution) to determine the table row distribution.

Note: The Greenplum Database server configuration parameter gp_create_table_random_default_distribution controls the table distribution policy if the DISTRIBUTED BY clause is not specified when you create a table.
For information about the parameter, see "Server Configuration Parameters" of the Greenplum Database Reference Guide.

Consider the following points when deciding on a table distribution policy.

* Even Data Distribution — For the best possible performance, all segments should contain equal portions of data. If the data is unbalanced or skewed, the segments with more data must work harder to perform their portion of the query processing. Choose a distribution key that is unique for each record, such as the primary key.
* Local and Distributed Operations — Local operations are faster than distributed operations. Query processing is fastest if the work associated with join, sort, or aggregation operations is done locally, at the segment level. Work done at the system level requires distributing tuples across the segments, which is less efficient. When tables share a common distribution key, the work of joining or sorting on their shared distribution key columns is done locally. With a random distribution policy, local join operations are not an option.
* Even Query Processing — For best performance, all segments should handle an equal share of the query workload. Query workload can be skewed if a table's data distribution policy and the query predicates are not well matched. For example, suppose that a sales transactions table is distributed on the customer ID column (the distribution key). If a predicate in a query references a single customer ID, the query processing work is concentrated on just one segment.

##### Declaring Distribution Keys

CREATE TABLE's optional clauses DISTRIBUTED BY and DISTRIBUTED RANDOMLY specify the distribution policy for a table. The default is a hash distribution policy that uses either the PRIMARY KEY (if the table has one) or the first column of the table as the distribution key. Columns with geometric or user-defined data types are not eligible as Greenplum distribution key columns. If a table does not have an eligible column, Greenplum distributes the rows randomly or in round-robin fashion.

To ensure even distribution of data, choose a distribution key that is unique for each record. If that is not possible, choose DISTRIBUTED RANDOMLY. For example:

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

### Creating and Using Sequences
You can use sequences to auto-increment unique ID columns of a table whenever a record is added. Sequences are often used to assign unique identification numbers to rows added to a table. You can declare an identifier column of type SERIAL to implicitly create a sequence for use with a column.

Parent topic: Defining Database Objects

#### Creating a Sequence
The CREATE SEQUENCE command creates and initializes a special single-row sequence generator table with the given sequence name. The sequence name must be distinct from the name of any other sequence, table, index, or view in the same schema. For example:

	CREATE SEQUENCE myserial START 101;

#### Using a Sequence
After you create a sequence generator table using CREATE SEQUENCE, you can use the nextval function to operate on the sequence. For example, to insert a row into a table that gets the next value of a sequence:

	INSERT INTO vendors VALUES (nextval('myserial'), 'acme');

You can also use the setval function to reset a sequence's counter value. For example:

	SELECT setval('myserial', 201);

A nextval operation is never rolled back. Afetched value is considered used, even if the transaction that performed the nextval fails. This means that failed transactions can leave unused holes in the sequence of assigned values. setval operations are never rolled back.

Note that the nextval function is not allowed in UPDATE or DELETE statements if mirroring is enabled, and the currval and lastval functions are not supported in Greenplum Database.

To examine the current settings of a sequence, query the sequence table:

	SELECT * FROM myserial;

#### Altering a Sequence
The ALTER SEQUENCE command changes the parameters of an existing sequence generator. For example:

	ALTER SEQUENCE myserial RESTART WITH 105;

Any parameters not set in the ALTER SEQUENCE command retain their prior settings.

#### Dropping a Sequence
The DROP SEQUENCE command removes a sequence generator table. For example:

	DROP SEQUENCE myserial;

### Using Indexes in Greenplum Database
In most traditional databases, indexes can greatly improve data access times. However, in a distributed database such as Greenplum, indexes should be used more sparingly. Greenplum Database performs very fast sequential scans; indexes use a random seek pattern to locate records on disk. Greenplum data is distributed across the segments, so each segment scans a smaller portion of the overall data to get the result. With table partitioning, the total data to scan may be even smaller. Because business intelligence (BI) query workloads generally return very large data sets, using indexes is not efficient.

Greenplum recommends trying your query workload without adding indexes. Indexes are more likely to improve performance for OLTP workloads, where the query is returning a single record or a small subset of data. Indexes can also improve performance on compressed append-optimized tables for queries that return a targeted set of rows, as the optimizer can use an index access method rather than a full table scan when appropriate. For compressed data, an index access method means only the necessary rows are uncompressed.

Greenplum Database automatically creates PRIMARY KEY constraints for tables with primary keys. To create an index on a partitioned table, create an index on the partitioned table that you created. The index is propagated to all the child tables created by Greenplum Database. Creating an index on a table that is created by Greenplum Database for use by a partitioned table is not supported.

Note that a UNIQUE CONSTRAINT (such as a PRIMARY KEY CONSTRAINT) implicitly creates a UNIQUE INDEX that must include all the columns of the distribution key and any partitioning key. The UNIQUE CONSTRAINT is enforced across the entire table, including all table partitions (if any).

Indexes add some database overhead — they use storage space and must be maintained when the table is updated. Ensure that the query workload uses the indexes that you create, and check that the indexes you add improve query performance (as compared to a sequential scan of the table). To determine whether indexes are being used, examine the query EXPLAIN plans. See Query Profiling.

Consider the following points when you create indexes.

* Your Query Workload. Indexes improve performance for workloads where queries return a single record or a very small data set, such as OLTP workloads.
* Compressed Tables. Indexes can improve performance on compressed append-optimized tables for queries that return a targeted set of rows. For compressed data, an index access method means only the necessary rows are uncompressed.
* Avoid indexes on frequently updated columns. Creating an index on a column that is frequently updated increases the number of writes required when the column is updated.
* Create selective B-tree indexes. Index selectivity is a ratio of the number of distinct values a column has divided by the number of rows in a table. For example, if a table has 1000 rows and a column has 800 distinct values, the selectivity of the index is 0.8, which is considered good. Unique indexes always have a selectivity ratio of 1.0, which is the best possible. Greenplum Database allows unique indexes only on distribution key columns.
* Use Bitmap indexes for low selectivity columns. The Greenplum Database Bitmap index type is not available in regular PostgreSQL. See About Bitmap Indexes.
* Index columns used in joins. An index on a column used for frequent joins (such as a foreign key column) can improve join performance by enabling more join methods for the query optimizer to use.
* Index columns frequently used in predicates. Columns that are frequently referenced in WHERE clauses are good candidates for indexes.
* Avoid overlapping indexes. Indexes that have the same leading column are redundant.
* Drop indexes for bulk loads. For mass loads of data into a table, consider dropping the indexes and re-creating them after the load completes. This is often faster than updating the indexes.
* Consider a clustered index. Clustering an index means that the records are physically ordered on disk according to the index. If the records you need are distributed randomly on disk, the database has to seek across the disk to fetch the records requested. If the records are stored close together, the fetching operation is more efficient. For example, a clustered index on a date column where the data is ordered sequentially by date. A query against a specific date range results in an ordered fetch from the disk, which leverages fast sequential access.

#### To cluster an index in Greenplum Database
Using the CLUSTER command to physically reorder a table based on an index can take a long time with very large tables. To achieve the same results much faster, you can manually reorder the data on disk by creating an intermediate table and loading the data in the desired order. For example:

	CREATE TABLE new_table (LIKE old_table) 
	       AS SELECT * FROM old_table ORDER BY myixcolumn;
	DROP old_table;
	ALTER TABLE new_table RENAME TO old_table;
	CREATE INDEX myixcolumn_ix ON old_table;
	VACUUM ANALYZE old_table;

Parent topic: Defining Database Objects

#### Index Types
Greenplum Database supports the Postgres index types B-tree and GiST. Hash and GIN indexes are not supported. Each index type uses a different algorithm that is best suited to different types of queries. B-tree indexes fit the most common situations and are the default index type. See Index Types in the PostgreSQL documentation for a description of these types.

Note: Greenplum Database allows unique indexes only if the columns of the index key are the same as (or a superset of) the Greenplum distribution key. Unique indexes are not supported on append-optimized tables. On partitioned tables, a unique index cannot be enforced across all child table partitions of a partitioned table. A unique index is supported only within a partition.

##### About Bitmap Indexes
Greenplum Database provides the Bitmap index type. Bitmap indexes are best suited to data warehousing applications and decision support systems with large amounts of data, many ad hoc queries, and few data modification (DML) transactions.

An index provides pointers to the rows in a table that contain a given key value. A regular index stores a list of tuple IDs for each key corresponding to the rows with that key value. Bitmap indexes store a bitmap for each key value. Regular indexes can be several times larger than the data in the table, but bitmap indexes provide the same functionality as a regular index and use a fraction of the size of the indexed data.

Each bit in the bitmap corresponds to a possible tuple ID. If the bit is set, the row with the corresponding tuple ID contains the key value. A mapping function converts the bit position to a tuple ID. Bitmaps are compressed for storage. If the number of distinct key values is small, bitmap indexes are much smaller, compress better, and save considerable space compared with a regular index. The size of a bitmap index is proportional to the number of rows in the table times the number of distinct values in the indexed column.

Bitmap indexes are most effective for queries that contain multiple conditions in the WHERE clause. Rows that satisfy some, but not all, conditions are filtered out before the table is accessed. This improves response time, often dramatically.

##### When to Use Bitmap Indexes

Bitmap indexes are best suited to data warehousing applications where users query the data rather than update it. Bitmap indexes perform best for columns that have between 100 and 100,000 distinct values and when the indexed column is often queried in conjunction with other indexed columns. Columns with fewer than 100 distinct values, such as a gender column with two distinct values (male and female), usually do not benefit much from any type of index. On a column with more than 100,000 distinct values, the performance and space efficiency of a bitmap index decline.

Bitmap indexes can improve query performance for ad hoc queries. AND and OR conditions in the WHERE clause of a query can be resolved quickly by performing the corresponding Boolean operations directly on the bitmaps before converting the resulting bitmap to tuple ids. If the resulting number of rows is small, the query can be answered quickly without resorting to a full table scan.

##### When Not to Use Bitmap Indexes

Do not use bitmap indexes for unique columns or columns with high cardinality data, such as customer names or phone numbers. The performance gains and disk space advantages of bitmap indexes start to diminish on columns with 100,000 or more unique values, regardless of the number of rows in the table.

Bitmap indexes are not suitable for OLTP applications with large numbers of concurrent transactions modifying the data.

Use bitmap indexes sparingly. Test and compare query performance with and without an index. Add an index only if query performance improves with indexed columns.

#### Creating an Index
The CREATE INDEX command defines an index on a table. A B-tree index is the default index type. For example, to create a B-tree index on the column gender in the table employee:

	CREATE INDEX gender_idx ON employee (gender);

To create a bitmap index on the column title in the table films:

	CREATE INDEX title_bmp_idx ON films USING bitmap (title);

#### Examining Index Usage
Greenplum Database indexes do not require maintenance and tuning. You can check which indexes are used by the real-life query workload. Use the EXPLAIN command to examine index usage for a query.

The query plan shows the steps or plan nodes that the database will take to answer a query and time estimates for each plan node. To examine the use of indexes, look for the following query plan node types in your EXPLAIN output:

* Index Scan - A scan of an index.
* Bitmap Heap Scan - Retrieves all
* from the bitmap generated by BitmapAnd, BitmapOr, or BitmapIndexScan and accesses the heap to retrieve the relevant rows.
* Bitmap Index Scan - Compute a bitmap by OR-ing all bitmaps that satisfy the query predicates from the underlying index.
* BitmapAnd or BitmapOr - Takes the bitmaps generated from multiple BitmapIndexScan nodes, ANDs or ORs them together, and generates a new bitmap as its output.

You have to experiment to determine the indexes to create. Consider the following points.

* Run ANALYZE after you create or update an index. ANALYZE collects table statistics. The query optimizer uses table statistics to estimate the number of rows returned by a query and to assign realistic costs to each possible query plan.
* Use real data for experimentation. Using test data for setting up indexes tells you what indexes you need for the test data, but that is all.
* Do not use very small test data sets as the results can be unrealistic or skewed.
* Be careful when developing test data. Values that are similar, completely random, or inserted in sorted order will skew the statistics away from the distribution that real data would have.
* You can force the use of indexes for testing purposes by using run-time parameters to turn off specific plan types. For example, turn off sequential scans (enable_seqscan) and nested-loop joins (enable_nestloop), the most basic plans, to force the system to use a different plan. Time your query with and without indexes and use the EXPLAIN ANALYZE command to compare the results.

#### Managing Indexes
Use the REINDEX command to rebuild a poorly-performing index. REINDEX rebuilds an index using the data stored in the index's table, replacing the old copy of the index.

To rebuild all indexes on a table

	REINDEX my_table;

	REINDEX my_index;

#### Dropping an Index
The DROP INDEX command removes an index. For example:

	DROP INDEX title_idx;

When loading data, it can be faster to drop all indexes, load, then recreate the indexes.

### Creating and Managing Views
Views enable you to save frequently used or complex queries, then access them in a SELECT statement as if they were a table. A view is not physically materialized on disk: the query runs as a subquery when you access the view.

If a subquery is associated with a single query, consider using the WITH clause of the SELECT command instead of creating a seldom-used view.

Parent topic: Defining Database Objects

#### Creating Views
The CREATE VIEW command defines a view of a query. For example:

	CREATE VIEW comedies AS SELECT * FROM films WHERE kind = 'comedy';

Views ignore ORDER BY and SORT operations stored in the view.

#### Dropping Views
The DROP VIEW command removes a view. For example:

	DROP VIEW topten;