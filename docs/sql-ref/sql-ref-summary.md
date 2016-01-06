## SQL Syntax Summary ##
### ABORT ###
Aborts the current transaction.

	ABORT [WORK | TRANSACTION]
See ABORT for more information.

### ALTER AGGREGATE ###
Changes the definition of an aggregate function

	ALTER AGGREGATE name ( type [ , ... ] ) RENAME TO new_name

	ALTER AGGREGATE name ( type [ , ... ] ) OWNER TO new_owner

	ALTER AGGREGATE name ( type [ , ... ] ) SET SCHEMA new_schema
See ALTER AGGREGATE for more information.

### ALTER CONVERSION
Changes the definition of a conversion.

	ALTER CONVERSION name RENAME TO newname

	ALTER CONVERSION name OWNER TO newowner
See ALTER CONVERSION for more information.

### ALTER DATABASE
Changes the attributes of a database.

	ALTER DATABASE name [ WITH CONNECTION LIMIT connlimit ]

	ALTER DATABASE name SET parameter { TO | = } { value | DEFAULT }

	ALTER DATABASE name RESET parameter

	ALTER DATABASE name RENAME TO newname

	ALTER DATABASE name OWNER TO new_owner
See ALTER DATABASE for more information.

### ALTER DOMAIN
Changes the definition of a domain.

	ALTER DOMAIN name { SET DEFAULT expression | DROP DEFAULT }

	ALTER DOMAIN name { SET | DROP } NOT NULL

	ALTER DOMAIN name ADD domain_constraint

	ALTER DOMAIN name DROP CONSTRAINT constraint_name [RESTRICT | CASCADE]

	ALTER DOMAIN name OWNER TO new_owner

	ALTER DOMAIN name SET SCHEMA new_schema
See ALTER DOMAIN for more information.

### ALTER EXTERNAL TABLE
Changes the definition of an external table.

	ALTER EXTERNAL TABLE name RENAME [COLUMN] column TO new_column

	ALTER EXTERNAL TABLE name RENAME TO new_name

	ALTER EXTERNAL TABLE name SET SCHEMA new_schema

	ALTER EXTERNAL TABLE name action [, ... ]
See ALTER EXTERNAL TABLE for more information.

### ALTER FILESPACE
Changes the definition of a filespace.

	ALTER FILESPACE name RENAME TO newname

	ALTER FILESPACE name OWNER TO newowner
See ALTER FILESPACE for more information.

### ALTER FUNCTION
Changes the definition of a function.

	ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] ) 
	   action [, ... ] [RESTRICT]

	ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] )
	   RENAME TO new_name

	ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] ) 
	   OWNER TO new_owner

	ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] ) 
	   SET SCHEMA new_schema
See ALTER FUNCTION for more information.

### ALTER GROUP
Changes a role name or membership.

	ALTER GROUP groupname ADD USER username [, ... ]

	ALTER GROUP groupname DROP USER username [, ... ]

	ALTER GROUP groupname RENAME TO newname
See ALTER GROUP for more information.

### ALTER INDEX
Changes the definition of an index.

	ALTER INDEX name RENAME TO new_name

	ALTER INDEX name SET TABLESPACE tablespace_name

	ALTER INDEX name SET ( FILLFACTOR = value )

	ALTER INDEX name RESET ( FILLFACTOR )
See ALTER INDEX for more information.

### ALTER LANGUAGE
Changes the name of a procedural language.

	ALTER LANGUAGE name RENAME TO newname
See ALTER LANGUAGE for more information.

### ALTER OPERATOR
Changes the definition of an operator.

	ALTER OPERATOR name ( {lefttype | NONE} , {righttype | NONE} ) 
	   OWNER TO newowner
See ALTER OPERATOR for more information.

### ALTER OPERATOR CLASS
Changes the definition of an operator class.

	ALTER OPERATOR CLASS name USING index_method RENAME TO newname

	ALTER OPERATOR CLASS name USING index_method OWNER TO newowner
See ALTER OPERATOR CLASS for more information.

### ALTER PROTOCOL
Changes the definition of a protocol.

	ALTER PROTOCOL name RENAME TO newname

	ALTER PROTOCOL name OWNER TO newowner
See ALTER PROTOCOL for more information.

### ALTER RESOURCE QUEUE
Changes the limits of a resource queue.

	ALTER RESOURCE QUEUE name WITH ( queue_attribute=value [, ... ] ) 
See ALTER RESOURCE QUEUE for more information.

### ALTER ROLE
Changes a database role (user or group).

	ALTER ROLE name RENAME TO newname

	ALTER ROLE name SET config_parameter {TO | =} {value | DEFAULT}

	ALTER ROLE name RESET config_parameter

	ALTER ROLE name RESOURCE QUEUE {queue_name | NONE}

	ALTER ROLE name [ [WITH] option [ ... ] ]
See ALTER ROLE for more information.

### ALTER SCHEMA
Changes the definition of a schema.

	ALTER SCHEMA name RENAME TO newname

	ALTER SCHEMA name OWNER TO newowner
See ALTER SCHEMA for more information.

### ALTER SEQUENCE
Changes the definition of a sequence generator.

	ALTER SEQUENCE name [INCREMENT [ BY ] increment] 
		 [MINVALUE minvalue | NO MINVALUE] 
		 [MAXVALUE maxvalue | NO MAXVALUE] 
		 [RESTART [ WITH ] start] 
		 [CACHE cache] [[ NO ] CYCLE] 
		 [OWNED BY {table.column | NONE}]

	ALTER SEQUENCE name SET SCHEMA new_schema
See ALTER SEQUENCE for more information.

### ALTER TABLE
Changes the definition of a table.

	ALTER TABLE [ONLY] name RENAME [COLUMN] column TO new_column

	ALTER TABLE name RENAME TO new_name

	ALTER TABLE name SET SCHEMA new_schema

	ALTER TABLE [ONLY] name SET 
		 DISTRIBUTED BY (column, [ ... ] ) 
	   | DISTRIBUTED RANDOMLY 
	   | WITH (REORGANIZE=true|false)
	 
	ALTER TABLE [ONLY] name action [, ... ]

	ALTER TABLE name
	   [ ALTER PARTITION { partition_name | FOR (RANK(number)) 
	   | FOR (value) } partition_action [...] ] 
	   partition_action
See ALTER TABLE for more information.

### ALTER TABLESPACE
Changes the definition of a tablespace.

	ALTER TABLESPACE name RENAME TO newname

	ALTER TABLESPACE name OWNER TO newowner
See ALTER TABLESPACE for more information.

### ALTER TYPE
Changes the definition of a data type.

	ALTER TYPE name
	   OWNER TO new_owner | SET SCHEMA new_schema
See ALTER TYPE for more information.

### ALTER USER
Changes the definition of a database role (user).

	ALTER USER name RENAME TO newname

	ALTER USER name SET config_parameter {TO | =} {value | DEFAULT}

	ALTER USER name RESET config_parameter

	ALTER USER name [ [WITH] option [ ... ] ]
See ALTER USER for more information.

### ANALYZE
Collects statistics about a database.

	ANALYZE [VERBOSE] [ROOTPARTITION [ALL] ] 
	   [table [ (column [, ...] ) ]]
See ANALYZE for more information.

### BEGIN
Starts a transaction block.

	BEGIN [WORK | TRANSACTION] [transaction_mode]
		  [READ ONLY | READ WRITE]
See BEGIN for more information.

### CHECKPOINT
Forces a transaction log checkpoint.

	CHECKPOINT
See CHECKPOINT for more information.

### CLOSE
Closes a cursor.

	CLOSE cursor_name
See CLOSE for more information.

### CLUSTER
Physically reorders a heap storage table on disk according to an index. Not a recommended operation in Greenplum Database.

	CLUSTER indexname ON tablename

	CLUSTER tablename

	CLUSTER
See CLUSTER for more information.

### COMMENT
Defines or change the comment of an object.

	COMMENT ON
	{ TABLE object_name |
	  COLUMN table_name.column_name |
	  AGGREGATE agg_name (agg_type [, ...]) |
	  CAST (sourcetype AS targettype) |
	  CONSTRAINT constraint_name ON table_name |
	  CONVERSION object_name |
	  DATABASE object_name |
	  DOMAIN object_name |
	  FILESPACE object_name |
	  FUNCTION func_name ([[argmode] [argname] argtype [, ...]]) |
	  INDEX object_name |
	  LARGE OBJECT large_object_oid |
	  OPERATOR op (leftoperand_type, rightoperand_type) |
	  OPERATOR CLASS object_name USING index_method |
	  [PROCEDURAL] LANGUAGE object_name |
	  RESOURCE QUEUE object_name |
	  ROLE object_name |
	  RULE rule_name ON table_name |
	  SCHEMA object_name |
	  SEQUENCE object_name |
	  TABLESPACE object_name |
	  TRIGGER trigger_name ON table_name |
	  TYPE object_name |
	  VIEW object_name } 
	IS 'text'
See COMMENT for more information.

### COMMIT
Commits the current transaction.

	COMMIT [WORK | TRANSACTION]
See COMMIT for more information.

### COPY
Copies data between a file and a table.

	COPY table [(column [, ...])] FROM {'file' | STDIN}
		 [ [WITH] 
		   [OIDS]
		   [HEADER]
		   [DELIMITER [ AS ] 'delimiter']
		   [NULL [ AS ] 'null string']
		   [ESCAPE [ AS ] 'escape' | 'OFF']
		   [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
		   [CSV [QUOTE [ AS ] 'quote'] 
				[FORCE NOT NULL column [, ...]]
		   [FILL MISSING FIELDS]
		   [[LOG ERRORS [INTO error_table] [KEEP] 
		   SEGMENT REJECT LIMIT count [ROWS | PERCENT] ]

	COPY {table [(column [, ...])] | (query)} TO {'file' | STDOUT}
		  [ [WITH] 
			[OIDS]
			[HEADER]
			[DELIMITER [ AS ] 'delimiter']
			[NULL [ AS ] 'null string']
			[ESCAPE [ AS ] 'escape' | 'OFF']
			[CSV [QUOTE [ AS ] 'quote'] 
				 [FORCE QUOTE column [, ...]] ]
		  [IGNORE EXTERNAL PARTITIONS ]
See COPY for more information.

### CREATE AGGREGATE
Defines a new aggregate function.

	CREATE [ORDERED] AGGREGATE name (input_data_type [ , ... ]) 
		  ( SFUNC = sfunc,
			STYPE = state_data_type
			[, PREFUNC = prefunc]
			[, FINALFUNC = ffunc]
			[, INITCOND = initial_condition]
			[, SORTOP = sort_operator] )
See CREATE AGGREGATE for more information.

### CREATE CAST
Defines a new cast.

	CREATE CAST (sourcetype AS targettype) 
		   WITH FUNCTION funcname (argtypes) 
		   [AS ASSIGNMENT | AS IMPLICIT]

	CREATE CAST (sourcetype AS targettype) WITHOUT FUNCTION 
		   [AS ASSIGNMENT | AS IMPLICIT]
See CREATE CAST for more information.

### CREATE CONVERSION
Defines a new encoding conversion.

	CREATE [DEFAULT] CONVERSION name FOR source_encoding TO 
		 dest_encoding FROM funcname
See CREATE CONVERSION for more information.

### CREATE DATABASE
Creates a new database.

	CREATE DATABASE name [ [WITH] [OWNER [=] dbowner]
						 [TEMPLATE [=] template]
						 [ENCODING [=] encoding]
						 [TABLESPACE [=] tablespace]
						 [CONNECTION LIMIT [=] connlimit ] ]
See CREATE DATABASE for more information.

### CREATE DOMAIN
Defines a new domain.

	CREATE DOMAIN name [AS] data_type [DEFAULT expression] 
		   [CONSTRAINT constraint_name
		   | NOT NULL | NULL 
		   | CHECK (expression) [...]]
See CREATE DOMAIN for more information.

### CREATE EXTERNAL TABLE
Defines a new external table.

	CREATE [READABLE] EXTERNAL TABLE table_name     
		( column_name data_type [, ...] | LIKE other_table )
		  LOCATION ('file://seghost[:port]/path/file' [, ...])
			| ('gpfdist://filehost[:port]/file_pattern[#transform]'
			| ('gpfdists://filehost[:port]/file_pattern[#transform]'
				[, ...])
			| ('gphdfs://hdfs_host[:port]/path/file')
		  FORMAT 'TEXT' 
				[( [HEADER]
				   [DELIMITER [AS] 'delimiter' | 'OFF']
				   [NULL [AS] 'null string']
				   [ESCAPE [AS] 'escape' | 'OFF']
				   [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
				   [FILL MISSING FIELDS] )]
			   | 'CSV'
				[( [HEADER]
				   [QUOTE [AS] 'quote'] 
				   [DELIMITER [AS] 'delimiter']
				   [NULL [AS] 'null string']
				   [FORCE NOT NULL column [, ...]]
				   [ESCAPE [AS] 'escape']
				   [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
				   [FILL MISSING FIELDS] )]
			   | 'AVRO' 
			   | 'PARQUET'

			   | 'CUSTOM' (Formatter=<formatter specifications>)
		 [ ENCODING 'encoding' ]
		 [ [LOG ERRORS [INTO error_table]] SEGMENT REJECT LIMIT count
		   [ROWS | PERCENT] ]

	CREATE [READABLE] EXTERNAL WEB TABLE table_name     
	   ( column_name data_type [, ...] | LIKE other_table )
		  LOCATION ('http://webhost[:port]/path/file' [, ...])
		| EXECUTE 'command' [ON ALL 
							  | MASTER
							  | number_of_segments
							  | HOST ['segment_hostname'] 
							  | SEGMENT segment_id ]
		  FORMAT 'TEXT' 
				[( [HEADER]
				   [DELIMITER [AS] 'delimiter' | 'OFF']
				   [NULL [AS] 'null string']
				   [ESCAPE [AS] 'escape' | 'OFF']
				   [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
				   [FILL MISSING FIELDS] )]
			   | 'CSV'
				[( [HEADER]
				   [QUOTE [AS] 'quote'] 
				   [DELIMITER [AS] 'delimiter']
				   [NULL [AS] 'null string']
				   [FORCE NOT NULL column [, ...]]
				   [ESCAPE [AS] 'escape']
				   [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
				   [FILL MISSING FIELDS] )]
			   | 'CUSTOM' (Formatter=<formatter specifications>)
		 [ ENCODING 'encoding' ]
		 [ [LOG ERRORS [INTO error_table]] SEGMENT REJECT LIMIT count
		   [ROWS | PERCENT] ]

	CREATE WRITABLE EXTERNAL TABLE table_name
		( column_name data_type [, ...] | LIKE other_table )
		 LOCATION('gpfdist://outputhost[:port]/filename[#transform]'
		  | ('gpfdists://outputhost[:port]/file_pattern[#transform]'
			  [, ...])
		  | ('gphdfs://hdfs_host[:port]/path')
		  FORMAT 'TEXT' 
				   [( [DELIMITER [AS] 'delimiter']
				   [NULL [AS] 'null string']
				   [ESCAPE [AS] 'escape' | 'OFF'] )]
			  | 'CSV'
				   [([QUOTE [AS] 'quote'] 
				   [DELIMITER [AS] 'delimiter']
				   [NULL [AS] 'null string']
				   [FORCE QUOTE column [, ...]] ]
				   [ESCAPE [AS] 'escape'] )]
			   | 'AVRO' 
			   | 'PARQUET'

			   | 'CUSTOM' (Formatter=<formatter specifications>)
		[ ENCODING 'write_encoding' ]
		[ DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY ]

	CREATE WRITABLE EXTERNAL WEB TABLE table_name
		( column_name data_type [, ...] | LIKE other_table )
		EXECUTE 'command' [ON ALL]
		FORMAT 'TEXT' 
				   [( [DELIMITER [AS] 'delimiter']
				   [NULL [AS] 'null string']
				   [ESCAPE [AS] 'escape' | 'OFF'] )]
			  | 'CSV'
				   [([QUOTE [AS] 'quote'] 
				   [DELIMITER [AS] 'delimiter']
				   [NULL [AS] 'null string']
				   [FORCE QUOTE column [, ...]] ]
				   [ESCAPE [AS] 'escape'] )]
			   | 'CUSTOM' (Formatter=<formatter specifications>)
		[ ENCODING 'write_encoding' ]
		[ DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY ]
See CREATE EXTERNAL TABLE for more information.

### CREATE FUNCTION
Defines a new function.

	CREATE [OR REPLACE] FUNCTION name    
		( [ [argmode] [argname] argtype [, ...] ] )
		  [ RETURNS { [ SETOF ] rettype 
			| TABLE ([{ argname argtype | LIKE other table }
			  [, ...]])
			} ]
		{ LANGUAGE langname
		| IMMUTABLE | STABLE | VOLATILE
		| CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
		| [EXTERNAL] SECURITY INVOKER | [EXTERNAL] SECURITY DEFINER
		| AS 'definition'
		| AS 'obj_file', 'link_symbol' } ...
		[ WITH ({ DESCRIBE = describe_function
			   } [, ...] ) ]
See CREATE FUNCTION for more information.

### CREATE GROUP
Defines a new database role.

	CREATE GROUP name [ [WITH] option [ ... ] ]
See CREATE GROUP for more information.

### CREATE INDEX
Defines a new index.

	CREATE [UNIQUE] INDEX name ON table
		   [USING btree|bitmap|gist]
		   ( {column | (expression)} [opclass] [, ...] )
		   [ WITH ( FILLFACTOR = value ) ]
		   [TABLESPACE tablespace]
		   [WHERE predicate]
See CREATE INDEX for more information.

### CREATE LANGUAGE
Defines a new procedural language.

	CREATE [PROCEDURAL] LANGUAGE name

	CREATE [TRUSTED] [PROCEDURAL] LANGUAGE name
		   HANDLER call_handler [VALIDATOR valfunction]
See CREATE LANGUAGE for more information.

### CREATE OPERATOR
Defines a new operator.

	CREATE OPERATOR name ( 
		   PROCEDURE = funcname
		   [, LEFTARG = lefttype] [, RIGHTARG = righttype]
		   [, COMMUTATOR = com_op] [, NEGATOR = neg_op]
		   [, RESTRICT = res_proc] [, JOIN = join_proc]
		   [, HASHES] [, MERGES]
		   [, SORT1 = left_sort_op] [, SORT2 = right_sort_op]
		   [, LTCMP = less_than_op] [, GTCMP = greater_than_op] )
See CREATE OPERATOR for more information.

### CREATE OPERATOR CLASS
Defines a new operator class.

	CREATE OPERATOR CLASS name [DEFAULT] FOR TYPE data_type  
	  USING index_method AS 
	  { 
	  OPERATOR strategy_number op_name [(op_type, op_type)] [RECHECK]
	  | FUNCTION support_number funcname (argument_type [, ...] )
	  | STORAGE storage_type
	  } [, ... ]
See CREATE OPERATOR CLASS for more information.

### CREATE RESOURCE QUEUE
Defines a new resource queue.

	CREATE RESOURCE QUEUE name WITH (queue_attribute=value [, ... ])
See CREATE RESOURCE QUEUE for more information.

### CREATE ROLE
Defines a new database role (user or group).

	CREATE ROLE name [[WITH] option [ ... ]]
See CREATE ROLE for more information.

### CREATE RULE
Defines a new rewrite rule.

	CREATE [OR REPLACE] RULE name AS ON event
	  TO table [WHERE condition] 
	  DO [ALSO | INSTEAD] { NOTHING | command | (command; command 
	  ...) }
See CREATE RULE for more information.

### CREATE SCHEMA
Defines a new schema.

	CREATE SCHEMA schema_name [AUTHORIZATION username] 
	   [schema_element [ ... ]]

	CREATE SCHEMA AUTHORIZATION rolename [schema_element [ ... ]]
See CREATE SCHEMA for more information.

### CREATE SEQUENCE
Defines a new sequence generator.

	CREATE [TEMPORARY | TEMP] SEQUENCE name
		   [INCREMENT [BY] value] 
		   [MINVALUE minvalue | NO MINVALUE] 
		   [MAXVALUE maxvalue | NO MAXVALUE] 
		   [START [ WITH ] start] 
		   [CACHE cache] 
		   [[NO] CYCLE] 
		   [OWNED BY { table.column | NONE }]
See CREATE SEQUENCE for more information.

### CREATE TABLE
Defines a new table.

	CREATE [[GLOBAL | LOCAL] {TEMPORARY | TEMP}] TABLE table_name ( 
	[ { column_name data_type [ DEFAULT default_expr ] 
	   [column_constraint [ ... ]
	[ ENCODING ( storage_directive [,...] ) ]
	] 
	   | table_constraint
	   | LIKE other_table [{INCLUDING | EXCLUDING} 
						  {DEFAULTS | CONSTRAINTS}] ...}
	   [, ... ] ]
	   )
	   [ INHERITS ( parent_table [, ... ] ) ]
	   [ WITH ( storage_parameter=value [, ... ] )
	   [ ON COMMIT {PRESERVE ROWS | DELETE ROWS | DROP} ]
	   [ TABLESPACE tablespace ]
	   [ DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY ]
	   [ PARTITION BY partition_type (column)
		   [ SUBPARTITION BY partition_type (column) ] 
			  [ SUBPARTITION TEMPLATE ( template_spec ) ]
		   [...]
		( partition_spec ) 
			| [ SUBPARTITION BY partition_type (column) ]
			  [...]
		( partition_spec
		  [ ( subpartition_spec
			   [(...)] 
			 ) ] 
		)
See CREATE TABLE for more information.

### CREATE TABLE AS
Defines a new table from the results of a query.

	CREATE [ [GLOBAL | LOCAL] {TEMPORARY | TEMP} ] TABLE table_name
	   [(column_name [, ...] )]
	   [ WITH ( storage_parameter=value [, ... ] ) ]
	   [ON COMMIT {PRESERVE ROWS | DELETE ROWS | DROP}]
	   [TABLESPACE tablespace]
	   AS query
	   [DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY]
See CREATE TABLE AS for more information.

### CREATE TABLESPACE
Defines a new tablespace.

	CREATE TABLESPACE tablespace_name [OWNER username] 
		   FILESPACE filespace_name
See CREATE TABLESPACE for more information.

### CREATE TYPE
Defines a new data type.

	CREATE TYPE name AS ( attribute_name data_type [, ... ] )

	CREATE TYPE name (
		INPUT = input_function,
		OUTPUT = output_function
		[, RECEIVE = receive_function]
		[, SEND = send_function]
		[, INTERNALLENGTH = {internallength | VARIABLE}]
		[, PASSEDBYVALUE]
		[, ALIGNMENT = alignment]
		[, STORAGE = storage]
		[, DEFAULT = default]
		[, ELEMENT = element]
		[, DELIMITER = delimiter] )

	CREATE TYPE name
See CREATE TYPE for more information.

### CREATE USER
Defines a new database role with the LOGIN privilege by default.

	CREATE USER name [ [WITH] option [ ... ] ]
See CREATE USER for more information.

### CREATE VIEW
Defines a new view.

	CREATE [OR REPLACE] [TEMP | TEMPORARY] VIEW name
		   [ ( column_name [, ...] ) ]
		   AS query
See CREATE VIEW for more information.

### DEALLOCATE
Deallocates a prepared statement.

	DEALLOCATE [PREPARE] name
See DEALLOCATE for more information.

### DECLARE
Defines a cursor.

	DECLARE name [BINARY] [INSENSITIVE] [NO SCROLL] CURSOR 
		 [{WITH | WITHOUT} HOLD] 
		 FOR query [FOR READ ONLY]
See DECLARE for more information.

### DELETE
Deletes rows from a table.

	DELETE FROM [ONLY] table [[AS] alias]
		  [USING usinglist]
		  [WHERE condition | WHERE CURRENT OF cursor_name ]
See DELETE for more information.

### DROP AGGREGATE
Removes an aggregate function.

	DROP AGGREGATE [IF EXISTS] name ( type [, ...] ) [CASCADE | RESTRICT]
See DROP AGGREGATE for more information.

### DROP CAST
Removes a cast.

	DROP CAST [IF EXISTS] (sourcetype AS targettype) [CASCADE | RESTRICT]
See DROP CAST for more information.

### DROP CONVERSION
Removes a conversion.

	DROP CONVERSION [IF EXISTS] name [CASCADE | RESTRICT]
See DROP CONVERSION for more information.

### DROP DATABASE
Removes a database.

	DROP DATABASE [IF EXISTS] name
See DROP DATABASE for more information.

### DROP DOMAIN
Removes a domain.

	DROP DOMAIN [IF EXISTS] name [, ...]  [CASCADE | RESTRICT]
See DROP DOMAIN for more information.

### DROP EXTERNAL TABLE
Removes an external table definition.

	DROP EXTERNAL [WEB] TABLE [IF EXISTS] name [CASCADE | RESTRICT]
See DROP EXTERNAL TABLE for more information.

### DROP FILESPACE
Removes a filespace.

	DROP FILESPACE [IF EXISTS] filespacename
See DROP FILESPACE for more information.

### DROP FUNCTION
Removes a function.

	DROP FUNCTION [IF EXISTS] name ( [ [argmode] [argname] argtype 
		[, ...] ] ) [CASCADE | RESTRICT]
See DROP FUNCTION for more information.

### DROP GROUP
Removes a database role.

	DROP GROUP [IF EXISTS] name [, ...]
See DROP GROUP for more information.

### DROP INDEX
Removes an index.

	DROP INDEX [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
See DROP INDEX for more information.

### DROP LANGUAGE
Removes a procedural language.

	DROP [PROCEDURAL] LANGUAGE [IF EXISTS] name [CASCADE | RESTRICT]
See DROP LANGUAGE for more information.

### DROP OPERATOR
Removes an operator.

	DROP OPERATOR [IF EXISTS] name ( {lefttype | NONE} , 
		{righttype | NONE} ) [CASCADE | RESTRICT]
See DROP OPERATOR for more information.

### DROP OPERATOR CLASS
Removes an operator class.

	DROP OPERATOR CLASS [IF EXISTS] name USING index_method [CASCADE | RESTRICT]
See DROP OPERATOR CLASS for more information.

### DROP OWNED
Removes database objects owned by a database role.

	DROP OWNED BY name [, ...] [CASCADE | RESTRICT]
See DROP OWNED for more information.

### DROP RESOURCE QUEUE
Removes a resource queue.

	DROP RESOURCE QUEUE queue_name
See DROP RESOURCE QUEUE for more information.

### DROP ROLE
Removes a database role.

	DROP ROLE [IF EXISTS] name [, ...]
See DROP ROLE for more information.

### DROP RULE
Removes a rewrite rule.

	DROP RULE [IF EXISTS] name ON relation [CASCADE | RESTRICT]
See DROP RULE for more information.

### DROP SCHEMA
Removes a schema.

	DROP SCHEMA [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
See DROP SCHEMA for more information.

### DROP SEQUENCE
Removes a sequence.

	DROP SEQUENCE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
See DROP SEQUENCE for more information.

### DROP TABLE
Removes a table.

	DROP TABLE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
See DROP TABLE for more information.

### DROP TABLESPACE
Removes a tablespace.

	DROP TABLESPACE [IF EXISTS] tablespacename
See DROP TABLESPACE for more information.

### DROP TYPE
Removes a data type.

	DROP TYPE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
See DROP TYPE for more information.

### DROP USER
Removes a database role.

	DROP USER [IF EXISTS] name [, ...]
See DROP USER for more information.

### DROP VIEW
Removes a view.

	DROP VIEW [IF EXISTS] name [, ...] [CASCADE | RESTRICT]
See DROP VIEW for more information.

### END
Commits the current transaction.

	END [WORK | TRANSACTION]
See END for more information.

### EXECUTE
Executes a prepared SQL statement.

	EXECUTE name [ (parameter [, ...] ) ]
See EXECUTE for more information.

### EXPLAIN
Shows the query plan of a statement.

	EXPLAIN [ANALYZE] [VERBOSE] statement
See EXPLAIN for more information.

### FETCH
Retrieves rows from a query using a cursor.

	FETCH [ forward_direction { FROM | IN } ] cursorname
See FETCH for more information.

### GRANT
Defines access privileges.

	GRANT { {SELECT | INSERT | UPDATE | DELETE | REFERENCES | 
	TRIGGER | TRUNCATE } [,...] | ALL [PRIVILEGES] }
		ON [TABLE] tablename [, ...]
		TO {rolename | PUBLIC} [, ...] [WITH GRANT OPTION]

	GRANT { {USAGE | SELECT | UPDATE} [,...] | ALL [PRIVILEGES] }
		ON SEQUENCE sequencename [, ...]
		TO { rolename | PUBLIC } [, ...] [WITH GRANT OPTION]

	GRANT { {CREATE | CONNECT | TEMPORARY | TEMP} [,...] | ALL 
	[PRIVILEGES] }
		ON DATABASE dbname [, ...]
		TO {rolename | PUBLIC} [, ...] [WITH GRANT OPTION]

	GRANT { EXECUTE | ALL [PRIVILEGES] }
		ON FUNCTION funcname ( [ [argmode] [argname] argtype [, ...] 
	] ) [, ...]
		TO {rolename | PUBLIC} [, ...] [WITH GRANT OPTION]

	GRANT { USAGE | ALL [PRIVILEGES] }
		ON LANGUAGE langname [, ...]
		TO {rolename | PUBLIC} [, ...] [WITH GRANT OPTION]

	GRANT { {CREATE | USAGE} [,...] | ALL [PRIVILEGES] }
		ON SCHEMA schemaname [, ...]
		TO {rolename | PUBLIC} [, ...] [WITH GRANT OPTION]

	GRANT { CREATE | ALL [PRIVILEGES] }
		ON TABLESPACE tablespacename [, ...]
		TO {rolename | PUBLIC} [, ...] [WITH GRANT OPTION]

	GRANT parent_role [, ...] 
		TO member_role [, ...] [WITH ADMIN OPTION]

	GRANT { SELECT | INSERT | ALL [PRIVILEGES] } 
		ON PROTOCOL protocolname
		TO username
See GRANT for more information.

### INSERT
Creates new rows in a table.

	INSERT INTO table [( column [, ...] )]
	   {DEFAULT VALUES | VALUES ( {expression | DEFAULT} [, ...] ) 
	   [, ...] | query}
See INSERT for more information.

### LOAD
Loads or reloads a shared library file.

	LOAD 'filename'
See LOAD for more information.

### LOCK
Locks a table.

	LOCK [TABLE] name [, ...] [IN lockmode MODE] [NOWAIT]
See LOCK for more information.

### MOVE
Positions a cursor.

	MOVE [ forward_direction {FROM | IN} ] cursorname
See MOVE for more information.

### PREPARE
Prepare a statement for execution.

	PREPARE name [ (datatype [, ...] ) ] AS statement
See PREPARE for more information.

### REASSIGN OWNED
Changes the ownership of database objects owned by a database role.

	REASSIGN OWNED BY old_role [, ...] TO new_role
See REASSIGN OWNED for more information.

### REINDEX
Rebuilds indexes.

	REINDEX {INDEX | TABLE | DATABASE | SYSTEM} name
See REINDEX for more information.

### RELEASE SAVEPOINT
Destroys a previously defined savepoint.

	RELEASE [SAVEPOINT] savepoint_name
See RELEASE SAVEPOINT for more information.

### RESET
Restores the value of a system configuration parameter to the default value.

	RESET configuration_parameter

	RESET ALL
See RESET for more information.

### REVOKE
Removes access privileges.

	REVOKE [GRANT OPTION FOR] { {SELECT | INSERT | UPDATE | DELETE 
		   | REFERENCES | TRIGGER | TRUNCATE } [,...] | ALL [PRIVILEGES] }
		   ON [TABLE] tablename [, ...]
		   FROM {rolename | PUBLIC} [, ...]
		   [CASCADE | RESTRICT]

	REVOKE [GRANT OPTION FOR] { {USAGE | SELECT | UPDATE} [,...] 
		   | ALL [PRIVILEGES] }
		   ON SEQUENCE sequencename [, ...]
		   FROM { rolename | PUBLIC } [, ...]
		   [CASCADE | RESTRICT]

	REVOKE [GRANT OPTION FOR] { {CREATE | CONNECT 
		   | TEMPORARY | TEMP} [,...] | ALL [PRIVILEGES] }
		   ON DATABASE dbname [, ...]
		   FROM {rolename | PUBLIC} [, ...]
		   [CASCADE | RESTRICT]

	REVOKE [GRANT OPTION FOR] {EXECUTE | ALL [PRIVILEGES]}
		   ON FUNCTION funcname ( [[argmode] [argname] argtype
								  [, ...]] ) [, ...]
		   FROM {rolename | PUBLIC} [, ...]
		   [CASCADE | RESTRICT]

	REVOKE [GRANT OPTION FOR] {USAGE | ALL [PRIVILEGES]}
		   ON LANGUAGE langname [, ...]
		   FROM {rolename | PUBLIC} [, ...]
		   [ CASCADE | RESTRICT ]

	REVOKE [GRANT OPTION FOR] { {CREATE | USAGE} [,...] 
		   | ALL [PRIVILEGES] }
		   ON SCHEMA schemaname [, ...]
		   FROM {rolename | PUBLIC} [, ...]
		   [CASCADE | RESTRICT]

	REVOKE [GRANT OPTION FOR] { CREATE | ALL [PRIVILEGES] }
		   ON TABLESPACE tablespacename [, ...]
		   FROM { rolename | PUBLIC } [, ...]
		   [CASCADE | RESTRICT]

	REVOKE [ADMIN OPTION FOR] parent_role [, ...] 
		   FROM member_role [, ...]
		   [CASCADE | RESTRICT]
See REVOKE for more information.

### ROLLBACK
Aborts the current transaction.

	ROLLBACK [WORK | TRANSACTION]
See ROLLBACK for more information.

### ROLLBACK TO SAVEPOINT
Rolls back the current transaction to a savepoint.

	ROLLBACK [WORK | TRANSACTION] TO [SAVEPOINT] savepoint_name
See ROLLBACK TO SAVEPOINT for more information.

### SAVEPOINT
Defines a new savepoint within the current transaction.

	SAVEPOINT savepoint_name
See SAVEPOINT for more information.

### SELECT
Retrieves rows from a table or view.

	SELECT [ALL | DISTINCT [ON (expression [, ...])]]
	  * | expression [[AS] output_name] [, ...]
	  [FROM from_item [, ...]]
	  [WHERE condition]
	  [GROUP BY grouping_element [, ...]]
	  [HAVING condition [, ...]]
	  [WINDOW window_name AS (window_specification)]
	  [{UNION | INTERSECT | EXCEPT} [ALL] select]
	  [ORDER BY expression [ASC | DESC | USING operator] [, ...]]
	  [LIMIT {count | ALL}]
	  [OFFSET start]
	  [FOR {UPDATE | SHARE} [OF table_name [, ...]] [NOWAIT] [...]]
See SELECT for more information.

### SELECT INTO
Defines a new table from the results of a query.

	SELECT [ALL | DISTINCT [ON ( expression [, ...] )]]
		* | expression [AS output_name] [, ...]
		INTO [TEMPORARY | TEMP] [TABLE] new_table
		[FROM from_item [, ...]]
		[WHERE condition]
		[GROUP BY expression [, ...]]
		[HAVING condition [, ...]]
		[{UNION | INTERSECT | EXCEPT} [ALL] select]
		[ORDER BY expression [ASC | DESC | USING operator] [, ...]]
		[LIMIT {count | ALL}]
		[OFFSET start]
		[FOR {UPDATE | SHARE} [OF table_name [, ...]] [NOWAIT] 
		[...]]
See SELECT INTO for more information.

### SET
Changes the value of a Greenplum Database configuration parameter.

	SET [SESSION | LOCAL] configuration_parameter {TO | =} value | 
		'value' | DEFAULT}

	SET [SESSION | LOCAL] TIME ZONE {timezone | LOCAL | DEFAULT}
See SET for more information.

### SET ROLE
Sets the current role identifier of the current session.

	SET [SESSION | LOCAL] ROLE rolename

	SET [SESSION | LOCAL] ROLE NONE

	RESET ROLE
See SET ROLE for more information.

### SET SESSION AUTHORIZATION
Sets the session role identifier and the current role identifier of the current session.

	SET [SESSION | LOCAL] SESSION AUTHORIZATION rolename

	SET [SESSION | LOCAL] SESSION AUTHORIZATION DEFAULT

	RESET SESSION AUTHORIZATION
See SET SESSION AUTHORIZATION for more information.

### SET TRANSACTION
Sets the characteristics of the current transaction.

	SET TRANSACTION [transaction_mode] [READ ONLY | READ WRITE]

	SET SESSION CHARACTERISTICS AS TRANSACTION transaction_mode 
		 [READ ONLY | READ WRITE]
See SET TRANSACTION for more information.

### SHOW
Shows the value of a system configuration parameter.

	SHOW configuration_parameter

	SHOW ALL
See SHOW for more information.

### START TRANSACTION
Starts a transaction block.

	START TRANSACTION [SERIALIZABLE | READ COMMITTED | READ UNCOMMITTED]
					  [READ WRITE | READ ONLY]
See START TRANSACTION for more information.

### TRUNCATE
Empties a table of all rows.

	TRUNCATE [TABLE] name [, ...] [CASCADE | RESTRICT]
See TRUNCATE for more information.

### UPDATE
Updates rows of a table.

	UPDATE [ONLY] table [[AS] alias]
	   SET {column = {expression | DEFAULT} |
	   (column [, ...]) = ({expression | DEFAULT} [, ...])} [, ...]
	   [FROM fromlist]
	   [WHERE condition | WHERE CURRENT OF cursor_name ]
See UPDATE for more information.

### VACUUM
Garbage-collects and optionally analyzes a database.

	VACUUM [FULL] [FREEZE] [VERBOSE] [table]

	VACUUM [FULL] [FREEZE] [VERBOSE] ANALYZE
	              [table [(column [, ...] )]]
See VACUUM for more information.

### VALUES
Computes a set of rows.

	VALUES ( expression [, ...] ) [, ...]
	   [ORDER BY sort_expression [ASC | DESC | USING operator] [, ...]]
	   [LIMIT {count | ALL}] [OFFSET start]
See VALUES for more information.
