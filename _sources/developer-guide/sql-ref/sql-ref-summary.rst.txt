.. include:: ../../defines.hrst

.. _sql_syntax_summary:

SQL 语法摘要
------------

ABORT
~~~~~

.. Aborts the current transaction.

终止当前事务。

::

    ABORT [WORK | TRANSACTION]

查看 :ref:`sql_ref_abort` 了解更多。

ALTER AGGREGATE
~~~~~~~~~~~~~~~

.. Changes the definition of an aggregate function

修改聚合函数定义。

::

    ALTER AGGREGATE name ( type [ , ... ] ) RENAME TO new_name

    ALTER AGGREGATE name ( type [ , ... ] ) OWNER TO new_owner

    ALTER AGGREGATE name ( type [ , ... ] ) SET SCHEMA new_schema

See ALTER AGGREGATE for more information.

ALTER CONVERSION
~~~~~~~~~~~~~~~~

.. Changes the definition of a conversion.

修改编码转换定义。

::

    ALTER CONVERSION name RENAME TO newname

    ALTER CONVERSION name OWNER TO newowner

See ALTER CONVERSION for more information.

ALTER DATABASE
~~~~~~~~~~~~~~

.. Changes the attributes of a database.

修改数据库属性。

::

    ALTER DATABASE name [ WITH CONNECTION LIMIT connlimit ]

    ALTER DATABASE name SET parameter { TO | = } { value | DEFAULT }

    ALTER DATABASE name RESET parameter

    ALTER DATABASE name RENAME TO newname

    ALTER DATABASE name OWNER TO new_owner

See ALTER DATABASE for more information.

ALTER DOMAIN
~~~~~~~~~~~~

.. Changes the definition of a domain.

修改域的定义。

::

    ALTER DOMAIN name { SET DEFAULT expression | DROP DEFAULT }

    ALTER DOMAIN name { SET | DROP } NOT NULL

    ALTER DOMAIN name ADD domain_constraint

    ALTER DOMAIN name DROP CONSTRAINT constraint_name [RESTRICT | CASCADE]

    ALTER DOMAIN name OWNER TO new_owner

    ALTER DOMAIN name SET SCHEMA new_schema

See ALTER DOMAIN for more information.

ALTER EXTERNAL TABLE
~~~~~~~~~~~~~~~~~~~~

.. Changes the definition of an external table.

修改外部表的定义。

::

    ALTER EXTERNAL TABLE name RENAME [COLUMN] column TO new_column

    ALTER EXTERNAL TABLE name RENAME TO new_name

    ALTER EXTERNAL TABLE name SET SCHEMA new_schema

    ALTER EXTERNAL TABLE name action [, ... ]

See ALTER EXTERNAL TABLE for more information.

.. ALTER FILESPACE
.. ~~~~~~~~~~~~~~~

.. Changes the definition of a filespace.

.. ::

..    ALTER FILESPACE name RENAME TO newname

..    ALTER FILESPACE name OWNER TO newowner

.. See ALTER FILESPACE for more information.

ALTER FUNCTION
~~~~~~~~~~~~~~

.. Changes the definition of a function.

修改函数的定义。

::

    ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] ) 
       action [, ... ] [RESTRICT]

    ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] )
       RENAME TO new_name

    ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] ) 
       OWNER TO new_owner

    ALTER FUNCTION name ( [ [argmode] [argname] argtype [, ...] ] ) 
       SET SCHEMA new_schema

See ALTER FUNCTION for more information.

ALTER GROUP
~~~~~~~~~~~

.. Changes a role name or membership.

修改数据库角色的名称或者成员关系。

::

    ALTER GROUP groupname ADD USER username [, ... ]

    ALTER GROUP groupname DROP USER username [, ... ]

    ALTER GROUP groupname RENAME TO newname

See ALTER GROUP for more information.

ALTER INDEX
~~~~~~~~~~~

.. Changes the definition of an index.

修改索引的定义。

::

    ALTER INDEX name RENAME TO new_name

    ALTER INDEX name SET TABLESPACE tablespace_name

    ALTER INDEX name SET ( FILLFACTOR = value )

    ALTER INDEX name RESET ( FILLFACTOR )

See ALTER INDEX for more information.

ALTER LANGUAGE
~~~~~~~~~~~~~~

.. Changes the name of a procedural language.

修改过程语言的名称。

::

    ALTER LANGUAGE name RENAME TO newname

See ALTER LANGUAGE for more information.

ALTER OPERATOR
~~~~~~~~~~~~~~

.. Changes the definition of an operator.

修改运算符的定义。

::

    ALTER OPERATOR name ( {lefttype | NONE} , {righttype | NONE} ) 
       OWNER TO newowner

See ALTER OPERATOR for more information.

ALTER OPERATOR CLASS
~~~~~~~~~~~~~~~~~~~~

.. Changes the definition of an operator class.

修改运算符类的定义。

::

    ALTER OPERATOR CLASS name USING index_method RENAME TO newname

    ALTER OPERATOR CLASS name USING index_method OWNER TO newowner

See ALTER OPERATOR CLASS for more information.

ALTER PROTOCOL
~~~~~~~~~~~~~~

.. Changes the definition of a protocol.

修改外部表协议的定义。

::

    ALTER PROTOCOL name RENAME TO newname

    ALTER PROTOCOL name OWNER TO newowner

See ALTER PROTOCOL for more information.

ALTER RESOURCE QUEUE
~~~~~~~~~~~~~~~~~~~~

.. Changes the limits of a resource queue.

修改资源队列的限制。

::

    ALTER RESOURCE QUEUE name WITH ( queue_attribute=value [, ... ] ) 

See ALTER RESOURCE QUEUE for more information.

ALTER ROLE
~~~~~~~~~~

.. Changes a database role (user or group).

修改数据库角色（用户或组）。

::

    ALTER ROLE name RENAME TO newname

    ALTER ROLE name SET config_parameter {TO | =} {value | DEFAULT}

    ALTER ROLE name RESET config_parameter

    ALTER ROLE name RESOURCE QUEUE {queue_name | NONE}

    ALTER ROLE name [ [WITH] option [ ... ] ]

See ALTER ROLE for more information.

ALTER SCHEMA
~~~~~~~~~~~~

.. Changes the definition of a schema.

修改模式的定义。

::

    ALTER SCHEMA name RENAME TO newname

    ALTER SCHEMA name OWNER TO newowner

See ALTER SCHEMA for more information.

ALTER SEQUENCE
~~~~~~~~~~~~~~

.. Changes the definition of a sequence generator.

修改序列生成器的定义。

::

    ALTER SEQUENCE name [INCREMENT [ BY ] increment] 
         [MINVALUE minvalue | NO MINVALUE] 
         [MAXVALUE maxvalue | NO MAXVALUE] 
         [RESTART [ WITH ] start] 
         [CACHE cache] [[ NO ] CYCLE] 
         [OWNED BY {table.column | NONE}]

    ALTER SEQUENCE name SET SCHEMA new_schema

See ALTER SEQUENCE for more information.

ALTER TABLE
~~~~~~~~~~~

.. Changes the definition of a table.

修改表的定义。

::

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

ALTER TABLESPACE
~~~~~~~~~~~~~~~~

.. Changes the definition of a tablespace.

修改表空间的定义。

::

    ALTER TABLESPACE name RENAME TO newname

    ALTER TABLESPACE name OWNER TO newowner

See ALTER TABLESPACE for more information.

ALTER TYPE
~~~~~~~~~~

.. Changes the definition of a data type.

修改数据类型的定义。

::

    ALTER TYPE name
       OWNER TO new_owner | SET SCHEMA new_schema

See ALTER TYPE for more information.

ALTER USER
~~~~~~~~~~

.. Changes the definition of a database role (user).

修改数据库角色（用户）的定义。

::

    ALTER USER name RENAME TO newname

    ALTER USER name SET config_parameter {TO | =} {value | DEFAULT}

    ALTER USER name RESET config_parameter

    ALTER USER name [ [WITH] option [ ... ] ]

See ALTER USER for more information.

ANALYZE
~~~~~~~

.. Collects statistics about a database.

收集数据库的统计信息。

::

    ANALYZE [VERBOSE] [ROOTPARTITION [ALL] ] 
       [table [ (column [, ...] ) ]]

See ANALYZE for more information.

BEGIN
~~~~~

.. Starts a transaction block.

启动一个事务块。

::

    BEGIN [WORK | TRANSACTION] [transaction_mode]
          [READ ONLY | READ WRITE]

查看 :ref:`sql_ref_begin` 了解更多。

CHECKPOINT
~~~~~~~~~~

.. Forces a transaction log checkpoint.

强制系统进行一次事务日志的检查点。

::

    CHECKPOINT

See CHECKPOINT for more information.

CLOSE
~~~~~

.. Closes a cursor.

关闭一个游标。

::

    CLOSE cursor_name

See CLOSE for more information.

CLUSTER
~~~~~~~

.. Physically reorders a heap storage table on disk according to an index.
.. Not a recommended operation in Greenplum Database.

根据索引的顺序，对 heap 表的记录进行物理上重新排序。
|product-name| 不推荐使用此操作。

::

    CLUSTER indexname ON tablename

    CLUSTER tablename

    CLUSTER

See CLUSTER for more information.

COMMENT
~~~~~~~

.. Defines or change the comment of an object.

定义或修改对象的注释。

::

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

COMMIT
~~~~~~

.. Commits the current transaction.

提交当前事务。

::

    COMMIT [WORK | TRANSACTION]

See COMMIT for more information.

COPY
~~~~

.. Copies data between a file and a table.

在表或文件之间拷贝数据。

::

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

CREATE AGGREGATE
~~~~~~~~~~~~~~~~

.. Defines a new aggregate function.

定义聚合函数。

::

    CREATE [ORDERED] AGGREGATE name (input_data_type [ , ... ]) 
          ( SFUNC = sfunc,
            STYPE = state_data_type
            [, PREFUNC = prefunc]
            [, FINALFUNC = ffunc]
            [, INITCOND = initial_condition]
            [, SORTOP = sort_operator] )

See CREATE AGGREGATE for more information.

CREATE CAST
~~~~~~~~~~~

.. Defines a new cast.

定义类型转换。

::

    CREATE CAST (sourcetype AS targettype) 
           WITH FUNCTION funcname (argtypes) 
           [AS ASSIGNMENT | AS IMPLICIT]

    CREATE CAST (sourcetype AS targettype) WITHOUT FUNCTION 
           [AS ASSIGNMENT | AS IMPLICIT]

See CREATE CAST for more information.

CREATE CONVERSION
~~~~~~~~~~~~~~~~~

.. Defines a new encoding conversion.

定义编码转换。

::

    CREATE [DEFAULT] CONVERSION name FOR source_encoding TO 
         dest_encoding FROM funcname

See CREATE CONVERSION for more information.

CREATE DATABASE
~~~~~~~~~~~~~~~

.. Creates a new database.

创建数据库。

::

    CREATE DATABASE name [ [WITH] [OWNER [=] dbowner]
                         [TEMPLATE [=] template]
                         [ENCODING [=] encoding]
                         [TABLESPACE [=] tablespace]
                         [CONNECTION LIMIT [=] connlimit ] ]

See CREATE DATABASE for more information.

CREATE DOMAIN
~~~~~~~~~~~~~

.. Defines a new domain.

定义域。

::

    CREATE DOMAIN name [AS] data_type [DEFAULT expression] 
           [CONSTRAINT constraint_name
           | NOT NULL | NULL 
           | CHECK (expression) [...]]

See CREATE DOMAIN for more information.

CREATE EXTERNAL TABLE
~~~~~~~~~~~~~~~~~~~~~

.. Defines a new external table.

定义外部表。

::

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

CREATE FUNCTION
~~~~~~~~~~~~~~~

.. Defines a new function.

定义函数。

::

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

CREATE GROUP
~~~~~~~~~~~~

.. Defines a new database role.

定义数据库角色。

::

    CREATE GROUP name [ [WITH] option [ ... ] ]

See CREATE GROUP for more information.

CREATE INDEX
~~~~~~~~~~~~

.. Defines a new index.

定义索引。

::

    CREATE [UNIQUE] INDEX name ON table
           [USING btree|bitmap|gist]
           ( {column | (expression)} [opclass] [, ...] )
           [ WITH ( FILLFACTOR = value ) ]
           [TABLESPACE tablespace]
           [WHERE predicate]

See CREATE INDEX for more information.

CREATE LANGUAGE
~~~~~~~~~~~~~~~

.. Defines a new procedural language.

定义过程语言。

::

    CREATE [PROCEDURAL] LANGUAGE name

    CREATE [TRUSTED] [PROCEDURAL] LANGUAGE name
           HANDLER call_handler [VALIDATOR valfunction]

See CREATE LANGUAGE for more information.

CREATE OPERATOR
~~~~~~~~~~~~~~~

.. Defines a new operator.

定义运算符。

::

    CREATE OPERATOR name ( 
           PROCEDURE = funcname
           [, LEFTARG = lefttype] [, RIGHTARG = righttype]
           [, COMMUTATOR = com_op] [, NEGATOR = neg_op]
           [, RESTRICT = res_proc] [, JOIN = join_proc]
           [, HASHES] [, MERGES]
           [, SORT1 = left_sort_op] [, SORT2 = right_sort_op]
           [, LTCMP = less_than_op] [, GTCMP = greater_than_op] )

See CREATE OPERATOR for more information.

CREATE OPERATOR CLASS
~~~~~~~~~~~~~~~~~~~~~

.. Defines a new operator class.

定义运算符类。

::

    CREATE OPERATOR CLASS name [DEFAULT] FOR TYPE data_type  
      USING index_method AS 
      { 
      OPERATOR strategy_number op_name [(op_type, op_type)] [RECHECK]
      | FUNCTION support_number funcname (argument_type [, ...] )
      | STORAGE storage_type
      } [, ... ]

See CREATE OPERATOR CLASS for more information.

CREATE RESOURCE QUEUE
~~~~~~~~~~~~~~~~~~~~~

.. Defines a new resource queue.

定义资源队列。

::

    CREATE RESOURCE QUEUE name WITH (queue_attribute=value [, ... ])

See CREATE RESOURCE QUEUE for more information.

CREATE ROLE
~~~~~~~~~~~

.. Defines a new database role (user or group).

定义数据库角色（用户或组）

::

    CREATE ROLE name [[WITH] option [ ... ]]

See CREATE ROLE for more information.

CREATE RULE
~~~~~~~~~~~

.. Defines a new rewrite rule.

定义重写规则。

::

    CREATE [OR REPLACE] RULE name AS ON event
      TO table [WHERE condition] 
      DO [ALSO | INSTEAD] { NOTHING | command | (command; command 
      ...) }

See CREATE RULE for more information.

CREATE SCHEMA
~~~~~~~~~~~~~

.. Defines a new schema.

定义模式。

::

    CREATE SCHEMA schema_name [AUTHORIZATION username] 
       [schema_element [ ... ]]

    CREATE SCHEMA AUTHORIZATION rolename [schema_element [ ... ]]

See CREATE SCHEMA for more information.

CREATE SEQUENCE
~~~~~~~~~~~~~~~

.. Defines a new sequence generator.

定义序列生成器。

::

    CREATE [TEMPORARY | TEMP] SEQUENCE name
           [INCREMENT [BY] value] 
           [MINVALUE minvalue | NO MINVALUE] 
           [MAXVALUE maxvalue | NO MAXVALUE] 
           [START [ WITH ] start] 
           [CACHE cache] 
           [[NO] CYCLE] 
           [OWNED BY { table.column | NONE }]

See CREATE SEQUENCE for more information.

CREATE TABLE
~~~~~~~~~~~~

.. Defines a new table.

定义表。

::

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

CREATE TABLE AS
~~~~~~~~~~~~~~~

.. Defines a new table from the results of a query.

根据查询结果定义一张表。

::

    CREATE [ [GLOBAL | LOCAL] {TEMPORARY | TEMP} ] TABLE table_name
       [(column_name [, ...] )]
       [ WITH ( storage_parameter=value [, ... ] ) ]
       [ON COMMIT {PRESERVE ROWS | DELETE ROWS | DROP}]
       [TABLESPACE tablespace]
       AS query
       [DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY]

See CREATE TABLE AS for more information.

CREATE TABLESPACE
~~~~~~~~~~~~~~~~~

.. Defines a new tablespace.

定义表空间。

::

    CREATE TABLESPACE tablespace_name [OWNER username] 
           FILESPACE filespace_name

See CREATE TABLESPACE for more information.

CREATE TYPE
~~~~~~~~~~~

.. Defines a new data type.

定义数据类型。

::

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

CREATE USER
~~~~~~~~~~~

.. Defines a new database role with the LOGIN privilege by default.

定义一个数据库角色，并且默认具有登陆权限。

::

    CREATE USER name [ [WITH] option [ ... ] ]

See CREATE USER for more information.

CREATE VIEW
~~~~~~~~~~~

.. Defines a new view.

定义视图。

::

    CREATE [OR REPLACE] [TEMP | TEMPORARY] VIEW name
           [ ( column_name [, ...] ) ]
           AS query

See CREATE VIEW for more information.

DEALLOCATE
~~~~~~~~~~

.. Deallocates a prepared statement.

回收并删除预优化的语句。

::

    DEALLOCATE [PREPARE] name

See DEALLOCATE for more information.

DECLARE
~~~~~~~

.. Defines a cursor.

定义一个游标。

::

    DECLARE name [BINARY] [INSENSITIVE] [NO SCROLL] CURSOR 
         [{WITH | WITHOUT} HOLD] 
         FOR query [FOR READ ONLY]

See DECLARE for more information.

DELETE
~~~~~~

.. Deletes rows from a table.

从一张表中删除记录。

::

    DELETE FROM [ONLY] table [[AS] alias]
          [USING usinglist]
          [WHERE condition | WHERE CURRENT OF cursor_name ]

See DELETE for more information.

DROP AGGREGATE
~~~~~~~~~~~~~~

.. Removes an aggregate function.

删除聚合函数。

::

    DROP AGGREGATE [IF EXISTS] name ( type [, ...] ) [CASCADE | RESTRICT]

See DROP AGGREGATE for more information.

DROP CAST
~~~~~~~~~

.. Removes a cast.

删除类型转换。

::

    DROP CAST [IF EXISTS] (sourcetype AS targettype) [CASCADE | RESTRICT]

See DROP CAST for more information.

DROP CONVERSION
~~~~~~~~~~~~~~~

.. Removes a conversion.

删除编码转换。

::

    DROP CONVERSION [IF EXISTS] name [CASCADE | RESTRICT]

See DROP CONVERSION for more information.

DROP DATABASE
~~~~~~~~~~~~~

.. Removes a database.

删除数据库。

::

    DROP DATABASE [IF EXISTS] name

See DROP DATABASE for more information.

DROP DOMAIN
~~~~~~~~~~~

.. Removes a domain.

删除域。

::

    DROP DOMAIN [IF EXISTS] name [, ...]  [CASCADE | RESTRICT]

See DROP DOMAIN for more information.

DROP EXTERNAL TABLE
~~~~~~~~~~~~~~~~~~~

.. Removes an external table definition.

删除外部表定义。

::

    DROP EXTERNAL [WEB] TABLE [IF EXISTS] name [CASCADE | RESTRICT]

See DROP EXTERNAL TABLE for more information.

.. DROP FILESPACE
.. ~~~~~~~~~~~~~~

.. Removes a filespace.

.. ::

..     DROP FILESPACE [IF EXISTS] filespacename

.. See DROP FILESPACE for more information.

DROP FUNCTION
~~~~~~~~~~~~~

.. Removes a function.

删除函数。

::

    DROP FUNCTION [IF EXISTS] name ( [ [argmode] [argname] argtype 
        [, ...] ] ) [CASCADE | RESTRICT]

See DROP FUNCTION for more information.

DROP GROUP
~~~~~~~~~~

.. Removes a database role.

删除数据库角色。

::

    DROP GROUP [IF EXISTS] name [, ...]

See DROP GROUP for more information.

DROP INDEX
~~~~~~~~~~

.. Removes an index.

删除索引。

::

    DROP INDEX [IF EXISTS] name [, ...] [CASCADE | RESTRICT]

See DROP INDEX for more information.

DROP LANGUAGE
~~~~~~~~~~~~~

.. Removes a procedural language.

删除过程语言。

::

    DROP [PROCEDURAL] LANGUAGE [IF EXISTS] name [CASCADE | RESTRICT]

See DROP LANGUAGE for more information.

DROP OPERATOR
~~~~~~~~~~~~~

.. Removes an operator.

删除运算符。

::

    DROP OPERATOR [IF EXISTS] name ( {lefttype | NONE} , 
        {righttype | NONE} ) [CASCADE | RESTRICT]

See DROP OPERATOR for more information.

DROP OPERATOR CLASS
~~~~~~~~~~~~~~~~~~~

.. Removes an operator class.

删除运算符类。

::

    DROP OPERATOR CLASS [IF EXISTS] name USING index_method [CASCADE | RESTRICT]

See DROP OPERATOR CLASS for more information.

DROP OWNED
~~~~~~~~~~

.. Removes database objects owned by a database role.

删除一个数据库角色拥有的所有数据库对象。

::

    DROP OWNED BY name [, ...] [CASCADE | RESTRICT]

See DROP OWNED for more information.

DROP RESOURCE QUEUE
~~~~~~~~~~~~~~~~~~~

.. Removes a resource queue.

删除资源队列。

::

    DROP RESOURCE QUEUE queue_name

See DROP RESOURCE QUEUE for more information.

DROP ROLE
~~~~~~~~~

.. Removes a database role.

删除数据库角色。

::

    DROP ROLE [IF EXISTS] name [, ...]

See DROP ROLE for more information.

DROP RULE
~~~~~~~~~

.. Removes a rewrite rule.

删除重写规则。

::

    DROP RULE [IF EXISTS] name ON relation [CASCADE | RESTRICT]

See DROP RULE for more information.

DROP SCHEMA
~~~~~~~~~~~

.. Removes a schema.

删除模式。

::

    DROP SCHEMA [IF EXISTS] name [, ...] [CASCADE | RESTRICT]

See DROP SCHEMA for more information.

DROP SEQUENCE
~~~~~~~~~~~~~

.. Removes a sequence.

删除序列。

::

    DROP SEQUENCE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]

See DROP SEQUENCE for more information.

DROP TABLE
~~~~~~~~~~

.. Removes a table.

删除表。

::

    DROP TABLE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]

See DROP TABLE for more information.

DROP TABLESPACE
~~~~~~~~~~~~~~~

.. Removes a tablespace.

删除表空间。

::

    DROP TABLESPACE [IF EXISTS] tablespacename

See DROP TABLESPACE for more information.

DROP TYPE
~~~~~~~~~

.. Removes a data type.

删除数据类型。

::

    DROP TYPE [IF EXISTS] name [, ...] [CASCADE | RESTRICT]

See DROP TYPE for more information.

DROP USER
~~~~~~~~~

.. Removes a database role.

删除数据库角色。

::

    DROP USER [IF EXISTS] name [, ...]

See DROP USER for more information.

DROP VIEW
~~~~~~~~~

.. Removes a view.

删除视图。

::

    DROP VIEW [IF EXISTS] name [, ...] [CASCADE | RESTRICT]

See DROP VIEW for more information.

END
~~~

.. Commits the current transaction.

提交当前事务。

::

    END [WORK | TRANSACTION]

See END for more information.

EXECUTE
~~~~~~~

.. Executes a prepared SQL statement.

执行一个预优化的 SQL 语句。

::

    EXECUTE name [ (parameter [, ...] ) ]

See EXECUTE for more information.

EXPLAIN
~~~~~~~

.. Shows the query plan of a statement.

显示一个语句的查询计划。

::

    EXPLAIN [ANALYZE] [VERBOSE] statement

See EXPLAIN for more information.

FETCH
~~~~~

.. Retrieves rows from a query using a cursor.

从游标对应的查询中，取得记录。

::

    FETCH [ forward_direction { FROM | IN } ] cursorname

See FETCH for more information.

GRANT
~~~~~

.. Defines access privileges.

授予访问权限。

::

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

INSERT
~~~~~~

.. Creates new rows in a table.

在一张表中创建新的记录。

::

    INSERT INTO table [( column [, ...] )]
       {DEFAULT VALUES | VALUES ( {expression | DEFAULT} [, ...] ) 
       [, ...] | query}

See INSERT for more information.

.. LOAD
.. ~~~~

.. Loads or reloads a shared library file.

.. ::

..    LOAD 'filename'

.. See LOAD for more information.

LOCK
~~~~

.. Locks a table.

为一张表显示地设置一把锁。

::

    LOCK [TABLE] name [, ...] [IN lockmode MODE] [NOWAIT]

See LOCK for more information.

MOVE
~~~~

.. Positions a cursor.

游标定位。

::

    MOVE [ forward_direction {FROM | IN} ] cursorname

See MOVE for more information.

PREPARE
~~~~~~~

.. Prepare a statement for execution.

预优化一个查询语句。

::

    PREPARE name [ (datatype [, ...] ) ] AS statement

See PREPARE for more information.

REASSIGN OWNED
~~~~~~~~~~~~~~

.. Changes the ownership of database objects owned by a database role.

将一个角色拥有的所有数据库对象变更给另一个角色。

::

    REASSIGN OWNED BY old_role [, ...] TO new_role

See REASSIGN OWNED for more information.

REINDEX
~~~~~~~

.. Rebuilds indexes.

重建索引。

::

    REINDEX {INDEX | TABLE | DATABASE | SYSTEM} name

See REINDEX for more information.

RELEASE SAVEPOINT
~~~~~~~~~~~~~~~~~

.. Destroys a previously defined savepoint.

清理一个之前定义的保存点。

::

    RELEASE [SAVEPOINT] savepoint_name

See RELEASE SAVEPOINT for more information.

RESET
~~~~~

.. Restores the value of a system configuration parameter to the default value.

将系统配置参数的值恢复成默认值。

::

    RESET configuration_parameter

    RESET ALL

See RESET for more information.

REVOKE
~~~~~~

.. Removes access privileges.

删除访问权限。

::

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

ROLLBACK
~~~~~~~~

.. Aborts the current transaction.

终止当前事务。

::

    ROLLBACK [WORK | TRANSACTION]

See ROLLBACK for more information.

ROLLBACK TO SAVEPOINT
~~~~~~~~~~~~~~~~~~~~~

.. Rolls back the current transaction to a savepoint.

将当前事务回滚到一个指定的保存点。

::

    ROLLBACK [WORK | TRANSACTION] TO [SAVEPOINT] savepoint_name

See ROLLBACK TO SAVEPOINT for more information.

SAVEPOINT
~~~~~~~~~

.. Defines a new savepoint within the current transaction.

在当前事务中，定义一个新的保存点。

::

    SAVEPOINT savepoint_name

See SAVEPOINT for more information.

SELECT
~~~~~~

.. Retrieves rows from a table or view.

从表或视图中获取数据。

::

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

SELECT INTO
~~~~~~~~~~~

.. Defines a new table from the results of a query.

使用查询的结果定义一张数据表。

::

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

SET
~~~

.. Changes the value of a Greenplum Database configuration parameter.

修改 |product-name| 配置参数的值。

::

    SET [SESSION | LOCAL] configuration_parameter {TO | =} value | 
        'value' | DEFAULT}

    SET [SESSION | LOCAL] TIME ZONE {timezone | LOCAL | DEFAULT}

See SET for more information.

SET ROLE
~~~~~~~~

.. Sets the current role identifier of the current session.

设置当前会话使用的角色。

::

    SET [SESSION | LOCAL] ROLE rolename

    SET [SESSION | LOCAL] ROLE NONE

    RESET ROLE

See SET ROLE for more information.

SET SESSION AUTHORIZATION
~~~~~~~~~~~~~~~~~~~~~~~~~

.. Sets the session role identifier and the current role identifier of the current session.

设置会话授权使用角色。

::

    SET [SESSION | LOCAL] SESSION AUTHORIZATION rolename

    SET [SESSION | LOCAL] SESSION AUTHORIZATION DEFAULT

    RESET SESSION AUTHORIZATION

See SET SESSION AUTHORIZATION for more information.

SET TRANSACTION
~~~~~~~~~~~~~~~

.. Sets the characteristics of the current transaction.

设置当前事务的事务特性。

::

    SET TRANSACTION [transaction_mode] [READ ONLY | READ WRITE]

    SET SESSION CHARACTERISTICS AS TRANSACTION transaction_mode 
         [READ ONLY | READ WRITE]

See SET TRANSACTION for more information.

SHOW
~~~~

.. Shows the value of a system configuration parameter.

显示系统配置参数的值。

::

    SHOW configuration_parameter

    SHOW ALL

See SHOW for more information.

START TRANSACTION
~~~~~~~~~~~~~~~~~

.. Starts a transaction block.

启动一个事务块。

::

    START TRANSACTION [SERIALIZABLE | READ COMMITTED | READ UNCOMMITTED]
                      [READ WRITE | READ ONLY]

See START TRANSACTION for more information.

TRUNCATE
~~~~~~~~

.. Empties a table of all rows.

清空一张表中的所有记录。

::

    TRUNCATE [TABLE] name [, ...] [CASCADE | RESTRICT]

See TRUNCATE for more information.

UPDATE
~~~~~~

.. Updates rows of a table.

更新表中的记录。

::

    UPDATE [ONLY] table [[AS] alias]
       SET {column = {expression | DEFAULT} |
       (column [, ...]) = ({expression | DEFAULT} [, ...])} [, ...]
       [FROM fromlist]
       [WHERE condition | WHERE CURRENT OF cursor_name ]

See UPDATE for more information.

VACUUM
~~~~~~

.. Garbage-collects and optionally analyzes a database.

数据库磁盘垃圾回收并收集统计信息。

::

    VACUUM [FULL] [FREEZE] [VERBOSE] [table]

    VACUUM [FULL] [FREEZE] [VERBOSE] ANALYZE
                  [table [(column [, ...] )]]

See VACUUM for more information.

VALUES
~~~~~~

.. Computes a set of rows.

根据表达式计算出一个集合的记录。

::

    VALUES ( expression [, ...] ) [, ...]
       [ORDER BY sort_expression [ASC | DESC | USING operator] [, ...]]
       [LIMIT {count | ALL}] [OFFSET start]

See VALUES for more information.
