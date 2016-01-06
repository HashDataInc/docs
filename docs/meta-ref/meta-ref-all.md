# System Catalog Reference #
This reference describes the Greenplum Database system catalog tables and views. System tables prefixed with gp_ relate to the parallel features of Greenplum Database. Tables prefixed with pg_ are either standard PostgreSQL system catalog tables supported in Greenplum Database, or are related to features Greenplum that provides to enhance PostgreSQL for data warehousing workloads. Note that the global system catalog for Greenplum Database resides on the master instance.

## System Tables ##
* gp_configuration (Deprecated. See gp_segment_configuration.)
* gp_configuration_history
* gp_db_interfaces
* gp_distribution_policy
* gp_fastsequence
* gp_fault_strategy
* gp_global_sequence
* gp_id
* gp_interfaces
* gp_master_mirroring (Deprecated. See pg_stat_replication.)
* gp_persistent_database_node
* gp_persistent_filespace_node
* gp_persistent_relation_node
* gp_persistent_tablespace_node
* gp_relation_node
* gp_san_configuration
* gp_segment_configuration
* gp_version_at_initdb
* gpexpand.status
* gpexpand.status_detail
* pg_aggregate
* pg_am
* pg_amop
* pg_amproc
* pg_appendonly
* pg_appendonly_alter_column (not supported in 4.3)
* pg_attrdef
* pg_attribute
* pg_auth_members
* pg_authid
* pg_autovacuum (not supported in 4.2.5 and later)
* pg_cast
* pg_class
* pg_constraint
* pg_conversion
* pg_database
* pg_depend
* pg_description
* pg_exttable
* pg_filespace
* pg_filespace_entry
* pg_foreign_data_wrapper (not supported in 4.3)
* pg_foreign_server (not supported in 4.3)
* pg_foreign_table (not supported in 4.3)
* pg_index
* pg_inherits
* pg_language
* pg_largeobject
* pg_listener
* pg_namespace
* pg_opclass
* pg_operator
* pg_partition
* pg_partition_rule
* pg_pltemplate
* pg_proc
* pg_resourcetype
* pg_resqueue
* pg_resqueuecapability
* pg_rewrite
* pg_shdepend
* pg_shdescription
* pg_stat_last_operation
* pg_stat_last_shoperation
* pg_statistic
* pg_tablespace
* pg_trigger
* pg_type
* pg_user_mapping (not supported in 4.3)
* pg_window

## System Views ##
Greenplum Database provides the following system views not available in PostgreSQL.
* gp_distributed_log
* gp_distributed_xacts
* gp_pgdatabase
* gp_resqueue_status
* gp_transaction_log
* gpexpand.expansion_progress
* pg_max_external_files (shows number of external table files allowed per segment host when using the file protocol)
* pg_partition_columns
* pg_partition_templates
* pg_partitions
* pg_stat_activity
* pg_stat_replication
* pg_resqueue_attributes
* pg_resqueue_status (Deprecated. Use gp_toolkit.gp_resqueue_status.)
* pg_stat_resqueues
* pg_user_mappings (not supported)
* session_level_memory_consumption 4.3.4.0

For more information about the standard system views supported in PostgreSQL and Greenplum Database, see the following sections of the PostgreSQL documentation:

* [System Views](http://www.postgresql.org/docs/8.2/static/views-overview.html)
* [Statistics Collector Views](http://www.postgresql.org/docs/8.2/static/monitoring-stats.html#MONITORING-STATS-VIEWS-TABLE)
* [The Information Schema](http://www.postgresql.org/docs/8.2/static/information-schema.html)

## System Catalogs Definitions ##
System catalog table and view definitions in alphabetical order.

### gp_configuration_history ###
The _gp_configuration_history_ table contains information about system changes related to fault detection and recovery operations. The fts_probe process logs data to this table, as do certain related management utilities such as gpcheck, gprecoverseg, and gpinitsystem. For example, when you add a new segment and mirror segment to the system, records for these events are logged to gp_configuration_history.
The event descriptions stored in this table may be helpful for troubleshooting serious system issues in collaboration with Greenplum support technicians.

This table is populated only on the master. This table is defined in the pg_global tablespace, meaning it is globally shared across all databases in the system.

|column|type|references|description|
|---|---|---|---|
|time|timestamp with time zone||Timestamp for the event recorded.|
|dbid|smallint|gp_segment _ configuration.dbid|System-assigned ID. The unique identifier of a segment (or master) instance.|
|desc|text||Text description of the event.|

### pg_partition_columns ###
The pg_partition_columns system view is used to show the partition key columns of a partitioned table.

|column|type|references|description|
|---|---|---|---|
|schemaname|name||The name of the schema the partitioned table is in.|
|tablename|name||The table name of the top-level parent table.|
|columnname| name| |The name of the partition key column.|
|partitionleve|smallint | |The level of this subpartition in the hierarchy.|
|position_in_partition_key|integer||For list partitions you can have a composite (multi-column) partition key. This shows the position of the column in a composite key.|

