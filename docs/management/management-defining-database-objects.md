### 定义数据库对象
This section covers data definition language (DDL) in Greenplum Database and how to create and manage database objects.
Creating objects in a Greenplum Database includes making up-front choices about data distribution, storage options, data loading, and other Greenplum features that will affect the ongoing performance of your database system. Understanding the options that are available and how the database will be used will help you make the right decisions.
Most of the advanced Greenplum features are enabled with extensions to the SQL CREATE DDL statements.

#### Creating and Managing Databases
A Greenplum Database system is a single instance of Greenplum Database. There can be several separate Greenplum Database systems installed, but usually just one is selected by environment variable settings. See your Greenplum administrator for details.

There can be multiple databases in a Greenplum Database system. This is different from some database management systems (such as Oracle) where the database instance is the database. Although you can create many databases in a Greenplum system, client programs can connect to and access only one database at a time — you cannot cross-query between databases.

##### About Template Databases
Each new database you create is based on a template. Greenplum provides a default database, template1. Use template1 to connect to Greenplum Database for the first time. Greenplum Database uses template1 to create databases unless you specify another template. Do not create any objects in template1 unless you want those objects to be in every database you create.

Greenplum Database uses two other database templates, template0 and postgres, internally. Do not drop or modify template0 or postgres. You can use template0 to create a completely clean database containing only the standard objects predefined by Greenplum Database at initialization, especially if you modified template1.

##### Creating a Database
The CREATE DATABASE command creates a new database. For example:

	=> CREATE DATABASE new_dbname;

To create a database, you must have privileges to create a database or be a Greenplum Database superuser. If you do not have the correct privileges, you cannot create a database. Contact your Greenplum Database administrator to either give you the necessary privilege or to create a database for you.

You can also use the client program createdb to create a database. For example, running the following command in a command line terminal connects to Greenplum Database using the provided host name and port and creates a database named mydatabase:

	$ createdb -h masterhost -p 5432 mydatabase

The host name and port must match the host name and port of the installed Greenplum Database system.
Some objects, such as roles, are shared by all the databases in a Greenplum Database system. Other objects, such as tables that you create, are known only in the database in which you create them.

##### Cloning a Database
By default, a new database is created by cloning the standard system database template, template1. Any database can be used as a template when creating a new database, thereby providing the capability to 'clone' or copy an existing database and all objects and data within that database. For example:

	=> CREATE DATABASE new_dbname TEMPLATE old_dbname;

##### Viewing the List of Databases
If you are working in the psql client program, you can use the \l meta-command to show the list of databases and templates in your Greenplum Database system. If using another client program and you are a superuser, you can query the list of databases from the pg_database system catalog table. For example:

	=> SELECT datname from pg_database;

##### Altering a Database
The ALTER DATABASE command changes database attributes such as owner, name, or default configuration attributes. For example, the following command alters a database by setting its default schema search path (the search_path configuration parameter):

	=> ALTER DATABASE mydatabase SET search_path TO myschema, public, pg_catalog;

To alter a database, you must be the owner of the database or a superuser.

##### Dropping a Database
The DROP DATABASE command drops (or deletes) a database. It removes the system catalog entries for the database and deletes the database directory on disk that contains the data. You must be the database owner or a superuser to drop a database, and you cannot drop a database while you or anyone else is connected to it. Connect to template1 (or another database) before dropping a database. For example:

	=> \c template1
	=> DROP DATABASE mydatabase;

You can also use the client program dropdb to drop a database. For example, the following command connects to Greenplum Database using the provided host name and port and drops the database mydatabase:

	$ dropdb -h masterhost -p 5432 mydatabase


Warning: Dropping a database cannot be undone.

#### Creating and Managing Schemas
Schemas logically organize objects and data in a database. Schemas allow you to have more than one object (such as tables) with the same name in the database without conflict if the objects are in different schemas.

##### The Default "Public" Schema
Every database has a default schema named public. If you do not create any schemas, objects are created in the public schema. All database roles (users) have CREATE and USAGE privileges in the public schema. When you create a schema, you grant privileges to your users to allow access to the schema.

##### Creating a Schema
Use the **CREATE SCHEMA** command to create a new schema. For example: 

	=> CREATE SCHEMA myschema;

To create or access objects in a schema, write a qualified name consisting of the schema name and table name separated by a period. For example:

	myschema.table

See `Schema Search Paths` for information about accessing a schema.
You can create a schema owned by someone else, for example, to restrict the activities of your users to
well-defined namespaces. The syntax is:

	=> CREATE SCHEMA schemaname AUTHORIZATION username;

##### Schema Search Paths
To specify an object's location in a database, use the schema-qualified name. For example:

	=> SELECT * FROM myschema.mytable;

You can set the search_path configuration parameter to specify the order in which to search the available schemas for objects. The schema listed first in the search path becomes the default schema. If a schema is not specified, objects are created in the default schema.

###### Setting the Schema Search Path
The search_path configuration parameter sets the schema search order. The ALTER DATABASE command sets the search path. For example:

	 => ALTER DATABASE mydatabase SET search_path TO myschema, public, pg_catalog;

You can also set search_path for a particular role (user) using the ALTER ROLE command. For example:

	 => ALTER ROLE sally SET search_path TO myschema, public, pg_catalog;

###### Viewing the Current Schema
Use the current_schema() function to view the current schema. For example:

	=> SELECT current_schema();

Use the SHOW command to view the current search path. For example:

	=> SHOW search_path;

##### Dropping a Schema
Use the DROP SCHEMA command to drop (delete) a schema. For example:

	=> DROP SCHEMA myschema;

By default, the schema must be empty before you can drop it. To drop a schema and all of its objects (tables, data, functions, and so on) use:

	=> DROP SCHEMA myschema CASCADE;

##### System Schemas

The following system-level schemas exist in every database:
* pg_catalog contains the system catalog tables, built-in data types, functions, and operators. It is always part of the schema search path, even if it is not explicitly named in the search path.
* information_schema consists of a standardized set of views that contain information about the objects in the database. These views get system information from the system catalog tables in a standardized way.
* pg_toast stores large objects such as records that exceed the page size. This schema is used internally by the Greenplum Database system.
* pg_bitmapindex stores bitmap index objects such as lists of values. This schema is used internally by the Greenplum Database system.
* pg_aoseg stores append-optimized table objects. This schema is used internally by the Greenplum Database system.
* gp_toolkit is an administrative schema that contains external tables, views, and functions that you can access with SQL commands. All database users can access gp_toolkit to view and query the system log files and other system metrics.

### Creating and Managing Tables
Greenplum Database tables are similar to tables in any relational database, except that table rows are distributed across the different segments in the system. When you create a table, you specify the table's distribution policy.

#### Creating a Table
The CREATE TABLE command creates a table and defines its structure. When you create a table, you define:

* The columns of the table and their associated data types. See Choosing Column Data Types.
* Any table or column constraints to limit the data that a column or table can contain. See Setting Table and Column Constraints.
* The distribution policy of the table, which determines how Greenplum Database divides data is across the segments. See Choosing the Table Distribution Policy.
* The way the table is stored on disk. See Choosing the Table Storage Model.
* The table partitioning strategy for large tables. See Creating and Managing Databases.

#### Choosing Column Data Types
The data type of a column determines the types of data values the column can contain. Choose the data type that uses the least possible space but can still accommodate your data and that best constrains the data. For example, use character data types for strings, date or timestamp data types for dates, and numeric data types for numbers.

For table columns that contain textual data, Pivotal recommends specifying the data type VARCHAR or TEXT. Specifying the data type CHAR is not recommended. In Greenplum Database, the data types VARCHAR or TEXT handles padding added to the data (space characters added after the last non-space character) as significant characters, the data type CHAR does not. For information on the character data types, see the CREATE TABLE command in the Greenplum Database Reference Guide.

Use the smallest numeric data type that will accommodate your numeric data and allow for future expansion. For example, using BIGINT for data that fits in INT or SMALLINT wastes storage space. If you expect that your data values will expand over time, consider that changing from a smaller datatype to a larger datatype after loading large amounts of data is costly. For example, if your current data values fit in a SMALLINT but it is likely that the values will expand, INT is the better long-term choice.

Use the same data types for columns that you plan to use in cross-table joins. Cross-table joins usually use the primary key in one table and a foreign key in the other table. When the data types are different, the database must convert one of them so that the data values can be compared correctly, which adds unnecessary overhead.

Greenplum Database has a rich set of native data types available to users. See the Greenplum Database Reference Guide for information about the built-in data types.

#### Setting Table and Column Constraints

You can define constraints on columns and tables to restrict the data in your tables. Greenplum Database support for constraints is the same as PostgreSQL with some limitations, including:

* CHECK constraints can refer only to the table on which they are
* UNIQUE and PRIMARY KEY constraints must be compatible with their tableʼs distribution key and partitioning key, if any.
* FOREIGN KEY constraints are allowed, but not enforced.
* Constraints that you define on partitioned tables apply to the partitioned table as a whole. You cannot define constraints on the individual parts of the table.

##### Check Constraints
Check constraints allow you to specify that the value in a certain column must satisfy a Boolean (truth-value) expression. For example, to require positive product prices:

	=> CREATE TABLE products 
	           ( product_no integer, 
	             name text, 
	             price numeric CHECK (price > 0) );

##### Not-Null Constraints

Not-null constraints specify that a column must not assume the null value. A not-null constraint is always written as a column constraint. For example:

	=> CREATE TABLE products 
	           ( product_no integer NOT NULL,
	             name text NOT NULL,
	             price numeric );

##### Unique Constraints

Unique constraints ensure that the data contained in a column or a group of columns is unique with respect to all the rows in the table. The table must be hash-distributed (not DISTRIBUTED RANDOMLY), and the constraint columns must be the same as (or a superset of) the table's distribution key columns. For example:

	=> CREATE TABLE products 
	           ( product_no integer UNIQUE, 
	             name text, 
	             price numeric)
	          DISTRIBUTED BY (product_no);

##### Primary Keys

A primary key constraint is a combination of a UNIQUE constraint and a NOT NULL constraint. The table must be hash-distributed (not DISTRIBUTED RANDOMLY), and the primary key columns must be the same as (or a superset of) the table's distribution key columns. If a table has a primary key, this column (or group of columns) is chosen as the distribution key for the table by default. For example:

	=> CREATE TABLE products 
	           ( product_no integer PRIMARY KEY, 
	             name text, 
	             price numeric)
	          DISTRIBUTED BY (product_no);

##### Foreign Keys

Foreign keys are not supported. You can declare them, but referential integrity is not enforced.

Foreign key constraints specify that the values in a column or a group of columns must match the values appearing in some row of another table to maintain referential integrity between two related tables. Referential integrity checks cannot be enforced between the distributed table segments of a Greenplum database.

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

### TODO

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