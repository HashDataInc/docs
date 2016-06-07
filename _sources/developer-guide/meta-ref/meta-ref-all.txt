:orphan:

.. include:: ../../defines.hrst

System Catalog Reference
========================

This reference describes the Greenplum Database system catalog tables
and views. System tables prefixed with gp\_ relate to the parallel
features of Greenplum Database. Tables prefixed with pg\_ are either
standard PostgreSQL system catalog tables supported in Greenplum
Database, or are related to features Greenplum that provides to enhance
PostgreSQL for data warehousing workloads. Note that the global system
catalog for Greenplum Database resides on the master instance.

System Tables
-------------

-  gp\_configuration (Deprecated. See gp\_segment\_configuration.)
-  gp\_configuration\_history
-  gp\_db\_interfaces
-  gp\_distribution\_policy
-  gp\_fastsequence
-  gp\_fault\_strategy
-  gp\_global\_sequence
-  gp\_id
-  gp\_interfaces
-  gp\_master\_mirroring (Deprecated. See pg\_stat\_replication.)
-  gp\_persistent\_database\_node
-  gp\_persistent\_filespace\_node
-  gp\_persistent\_relation\_node
-  gp\_persistent\_tablespace\_node
-  gp\_relation\_node
-  gp\_san\_configuration
-  gp\_segment\_configuration
-  gp\_version\_at\_initdb
-  gpexpand.status
-  gpexpand.status\_detail
-  pg\_aggregate
-  pg\_am
-  pg\_amop
-  pg\_amproc
-  pg\_appendonly
-  pg\_appendonly\_alter\_column (not supported in 4.3)
-  pg\_attrdef
-  pg\_attribute
-  pg\_auth\_members
-  pg\_authid
-  pg\_autovacuum (not supported in 4.2.5 and later)
-  pg\_cast
-  pg\_class
-  pg\_constraint
-  pg\_conversion
-  pg\_database
-  pg\_depend
-  pg\_description
-  pg\_exttable
-  pg\_filespace
-  pg\_filespace\_entry
-  pg\_foreign\_data\_wrapper (not supported in 4.3)
-  pg\_foreign\_server (not supported in 4.3)
-  pg\_foreign\_table (not supported in 4.3)
-  pg\_index
-  pg\_inherits
-  pg\_language
-  pg\_largeobject
-  pg\_listener
-  pg\_namespace
-  pg\_opclass
-  pg\_operator
-  pg\_partition
-  pg\_partition\_rule
-  pg\_pltemplate
-  pg\_proc
-  pg\_resourcetype
-  pg\_resqueue
-  pg\_resqueuecapability
-  pg\_rewrite
-  pg\_shdepend
-  pg\_shdescription
-  pg\_stat\_last\_operation
-  pg\_stat\_last\_shoperation
-  pg\_statistic
-  pg\_tablespace
-  pg\_trigger
-  pg\_type
-  pg\_user\_mapping (not supported in 4.3)
-  pg\_window

System Views
------------

Greenplum Database provides the following system views not available in
PostgreSQL.

-  gp\_distributed\_log
-  gp\_distributed\_xacts
-  gp\_pgdatabase
-  gp\_resqueue\_status
-  gp\_transaction\_log
-  gpexpand.expansion\_progress
-  pg\_max\_external\_files (shows number of external table files
   allowed per segment host when using the file protocol)
-  pg\_partition\_columns
-  pg\_partition\_templates
-  pg\_partitions
-  pg\_stat\_activity
-  pg\_stat\_replication
-  pg\_resqueue\_attributes
-  pg\_resqueue\_status (Deprecated. Use
   gp\_toolkit.gp\_resqueue\_status.)
-  pg\_stat\_resqueues
-  pg\_user\_mappings (not supported)
-  session\_level\_memory\_consumption 4.3.4.0

For more information about the standard system views supported in
PostgreSQL and Greenplum Database, see the following sections of the
PostgreSQL documentation:

-  `System
   Views <http://www.postgresql.org/docs/8.2/static/views-overview.html>`__
-  `Statistics Collector
   Views <http://www.postgresql.org/docs/8.2/static/monitoring-stats.html#MONITORING-STATS-VIEWS-TABLE>`__
-  `The Information
   Schema <http://www.postgresql.org/docs/8.2/static/information-schema.html>`__

System Catalogs Definitions
---------------------------

System catalog table and view definitions in alphabetical order.

gp\_configuration\_history
~~~~~~~~~~~~~~~~~~~~~~~~~~

The *gp*\ configuration\_history\_ table contains information about
system changes related to fault detection and recovery operations. The
fts\_probe process logs data to this table, as do certain related
management utilities such as gpcheck, gprecoverseg, and gpinitsystem.
For example, when you add a new segment and mirror segment to the
system, records for these events are logged to
gp\_configuration\_history.
The event descriptions stored in this table may be helpful for
troubleshooting serious system issues in collaboration with Greenplum
support technicians.

This table is populated only on the master. This table is defined in the
pg\_global tablespace, meaning it is globally shared across all
databases in the system.

+----------+----------------------------+-------------------------------------+--------------------------------------------------------------------------------+
| column   | type                       | references                          | description                                                                    |
+==========+============================+=====================================+================================================================================+
| time     | timestamp with time zone   |                                     | Timestamp for the event recorded.                                              |
+----------+----------------------------+-------------------------------------+--------------------------------------------------------------------------------+
| dbid     | smallint                   | gp\_segment \_ configuration.dbid   | System-assigned ID. The unique identifier of a segment (or master) instance.   |
+----------+----------------------------+-------------------------------------+--------------------------------------------------------------------------------+
| desc     | text                       |                                     | Text description of the event.                                                 |
+----------+----------------------------+-------------------------------------+--------------------------------------------------------------------------------+

pg\_partition\_columns
~~~~~~~~~~~~~~~~~~~~~~

The pg\_partition\_columns system view is used to show the partition key
columns of a partitioned table.

+--------------------------------+------------+--------------+----------------------------------------------------------------------------------------------------------------------------------------+
| column                         | type       | references   | description                                                                                                                            |
+================================+============+==============+========================================================================================================================================+
| schemaname                     | name       |              | The name of the schema the partitioned table is in.                                                                                    |
+--------------------------------+------------+--------------+----------------------------------------------------------------------------------------------------------------------------------------+
| tablename                      | name       |              | The table name of the top-level parent table.                                                                                          |
+--------------------------------+------------+--------------+----------------------------------------------------------------------------------------------------------------------------------------+
| columnname                     | name       |              | The name of the partition key column.                                                                                                  |
+--------------------------------+------------+--------------+----------------------------------------------------------------------------------------------------------------------------------------+
| partitionleve                  | smallint   |              | The level of this subpartition in the hierarchy.                                                                                       |
+--------------------------------+------------+--------------+----------------------------------------------------------------------------------------------------------------------------------------+
| position\_in\_partition\_key   | integer    |              | For list partitions you can have a composite (multi-column) partition key. This shows the position of the column in a composite key.   |
+--------------------------------+------------+--------------+----------------------------------------------------------------------------------------------------------------------------------------+

