# 系统配置参数

 HashData 数据库服务器配置参数的字典序描述。

*   [add\_missing\_from](#add_missing_from)
*   [application_name](#application_name)
*   [array_nulls](#array_nulls)
*   [authentication_timeout](#authentication_timeout)
*   [backslash_quote](#backslash_quote)
*   [block_size](#block_size)
*   [bonjour_name](#bonjour_name)
*   [check\_function\_bodies](#check_function_bodies)
*   [client_encoding](#client_encoding)
*   [client\_min\_messages](#client_min_messages)
*   [cpu\_index\_tuple_cost](#cpu_index_tuple_cost)
*   [cpu\_operator\_cost](#cpu_operator_cost)
*   [cpu\_tuple\_cost](#cpu_tuple_cost)
*   [cursor\_tuple\_fraction](#cursor_tuple_fraction)
*   [custom\_variable\_classes](#custom_variable_classes)
*   [DateStyle](#DateStyle)
*   [db\_user\_namespace](#db_user_namespace)
*   [deadlock_timeout](#deadlock_timeout)
*   [debug_assertions](#debug_assertions)
*   [debug\_pretty\_print](#debug_pretty_print)
*   [debug\_print\_parse](#debug_print_parse)
*   [debug\_print\_plan](#debug_print_plan)
*   [debug\_print\_prelim_plan](#debug_print_prelim_plan)
*   [debug\_print\_rewritten](#debug_print_rewritten)
*   [debug\_print\_slice_table](#debug_print_slice_table)
*   [default\_statistics\_target](#default_statistics_target)
*   [default_tablespace](#default_tablespace)
*   [default\_transaction\_isolation](#default_transaction_isolation)
*   [default\_transaction\_read_only](#default_transaction_read_only)
*   [dynamic\_library\_path](#dynamic_library_path)
*   [effective\_cache\_size](#effective_cache_size)
*   [enable_bitmapscan](#enable_bitmapscan)
*   [enable_groupagg](#enable_groupagg)
*   [enable_hashagg](#enable_hashagg)
*   [enable_hashjoin](#enable_hashjoin)
*   [enable_indexscan](#enable_indexscan)
*   [enable_mergejoin](#enable_mergejoin)
*   [enable_nestloop](#enable_nestloop)
*   [enable_seqscan](#enable_seqscan)
*   [enable_sort](#enable_sort)
*   [enable_tidscan](#enable_tidscan)
*   [escape\_string\_warning](#escape_string_warning)
*   [explain\_pretty\_print](#explain_pretty_print)
*   [extra\_float\_digits](#extra_float_digits)
*   [filerep\_mirrorvalidation\_during_resync](#filerep_mirrorvalidation_during_resync)
*   [from\_collapse\_limit](#from_collapse_limit)
*   [gp\_adjust\_selectivity\_for\_outerjoins](#gp_adjust_selectivity_for_outerjoins)
*   [gp\_analyze\_relative_error](#gp_analyze_relative_error)
*   [gp\_appendonly\_compaction](#gp_appendonly_compaction)
*   [gp\_appendonly\_compaction_threshold](#gp_appendonly_compaction_threshold)
*   [gp\_autostats\_mode](#gp_autostats_mode)
*   [gp\_autostats\_mode\_in\_functions](#gp_autostats_mode_in_functions)
*   [gp\_autostats\_on\_change\_threshold](#gp_autostats_on_change_threshold)
*   [gp\_backup\_directIO](#gp_backup_directIO)
*   [gp\_backup\_directIO\_read\_chunk_mb](#gp_backup_directIO_read_chunk_mb)
*   [gp\_cached\_segworkers_threshold](#gp_cached_segworkers_threshold)
*   [gp\_command\_count](#gp_command_count)
*   [gp\_connection\_send_timeout](#gp_connection_send_timeout)
*   [gp\_connections\_per_thread](#gp_connections_per_thread)
*   [gp_content](#gp_content)
*   [gp\_create\_table\_random\_default_distribution](#gp_create_table_random_default_distribution)
*   [gp_dbid](#gp_dbid)
*   [gp\_debug\_linger](#gp_debug_linger)
*   [gp\_default\_storage_options](#gp_default_storage_options)
*   [gp\_dynamic\_partition_pruning](#gp_dynamic_partition_pruning)
*   [gp\_email\_from](#gp_email_from)
*   [gp\_email\_smtp_password](#gp_email_smtp_password)
*   [gp\_email\_smtp_server](#gp_email_smtp_server)
*   [gp\_email\_smtp_userid](#gp_email_smtp_userid)
*   [gp\_email\_to](#gp_email_to)
*   [gp\_enable\_adaptive_nestloop](#gp_enable_adaptive_nestloop)
*   [gp\_enable\_agg_distinct](#gp_enable_agg_distinct)
*   [gp\_enable\_agg\_distinct\_pruning](#gp_enable_agg_distinct_pruning)
*   [gp\_enable\_direct_dispatch](#gp_enable_direct_dispatch)
*   [gp\_enable\_exchange\_default\_partition](#gp_enable_exchange_default_partition)
*   [gp\_enable\_fallback_plan](#gp_enable_fallback_plan)
*   [gp\_enable\_fast_sri](#gp_enable_fast_sri)
*   [gp\_enable\_gpperfmon](#gp_enable_gpperfmon)
*   [gp\_enable\_groupext\_distinct\_gather](#gp_enable_groupext_distinct_gather)
*   [gp\_enable\_groupext\_distinct\_pruning](#gp_enable_groupext_distinct_pruning)
*   [gp\_enable\_multiphase_agg](#gp_enable_multiphase_agg)
*   [gp\_enable\_predicate_propagation](#gp_enable_predicate_propagation)
*   [gp\_enable\_preunique](#gp_enable_preunique)
*   [gp\_enable\_relsize_collection](#gp_enable_relsize_collection)
*   [gp\_enable\_sequential\_window\_plans](#gp_enable_sequential_window_plans)
*   [gp\_enable\_sort_distinct](#gp_enable_sort_distinct)
*   [gp\_enable\_sort_limit](#gp_enable_sort_limit)
*   [gp\_external\_enable_exec](#gp_external_enable_exec)
*   [gp\_external\_max_segs](#gp_external_max_segs)
*   [gp\_filerep\_tcp\_keepalives\_count](#gp_filerep_tcp_keepalives_count)
*   [gp\_filerep\_tcp\_keepalives\_idle](#gp_filerep_tcp_keepalives_idle)
*   [gp\_filerep\_tcp\_keepalives\_interval](#gp_filerep_tcp_keepalives_interval)
*   [gp\_fts\_probe_interval](#gp_fts_probe_interval)
*   [gp\_fts\_probe_retries](#gp_fts_probe_retries)
*   [gp\_fts\_probe_threadcount](#gp_fts_probe_threadcount)
*   [gp\_fts\_probe_timeout](#gp_fts_probe_timeout)
*   [gp\_gpperfmon\_send_interval](#gp_gpperfmon_send_interval)
*   [gpperfmon\_log\_alert_level](#gpperfmon_log_alert_level)
*   [gp\_hadoop\_home](#gp_hadoop_home)
*   [gp\_hadoop\_target_version](#gp_hadoop_target_version)
*   [gp\_hashjoin\_tuples\_per\_bucket](#gp_hashjoin_tuples_per_bucket)
*   [gp\_idf\_deduplicate](#gp_idf_deduplicate)
*   [gp\_initial\_bad\_row\_limit](#topic_lvm_ttc_3p)
*   [gp\_interconnect\_fc_method](#gp_interconnect_fc_method)
*   [gp\_interconnect\_hash_multiplier](#gp_interconnect_hash_multiplier)
*   [gp\_interconnect\_queue_depth](#gp_interconnect_queue_depth)
*   [gp\_interconnect\_setup_timeout](#gp_interconnect_setup_timeout)
*   [gp\_interconnect\_snd\_queue\_depth](#gp_interconnect_snd_queue_depth)
*   [gp\_interconnect\_type](#gp_interconnect_type)
*   [gp\_log\_format](#gp_log_format)
*   [gp\_log\_fts](#gp_log_fts)
*   [gp\_log\_gang](#gp_log_gang)
*   [gp\_max\_csv\_line\_length](#gp_max_csv_line_length)
*   [gp\_max\_databases](#gp_max_databases)
*   [gp\_max\_filespaces](#gp_max_filespaces)
*   [gp\_max\_local\_distributed\_cache](#gp_max_local_distributed_cache)
*   [gp\_max\_packet_size](#gp_max_packet_size)
*   [gp\_max\_plan_size](#gp_max_plan_size)
*   [gp\_max\_tablespaces](#gp_max_tablespaces)
*   [gp\_motion\_cost\_per\_row](#gp_motion_cost_per_row)
*   [gp\_num\_contents\_in\_cluster](#gp_num_contents_in_cluster)
*   [gp\_reject\_percent_threshold](#gp_reject_percent_threshold)
*   [gp\_reraise\_signal](#gp_reraise_signal)
*   [gp\_resqueue\_memory_policy](#gp_resqueue_memory_policy)
*   [gp\_resqueue\_priority](#gp_resqueue_priority)
*   [gp\_resqueue\_priority\_cpucores\_per_segment](#gp_resqueue_priority_cpucores_per_segment)
*   [gp\_resqueue\_priority\_sweeper\_interval](#gp_resqueue_priority_sweeper_interval)
*   [gp_role](#gp_role)
*   [gp_safefswritesize](#gp_safefswritesize)
*   [gp\_segment\_connect_timeout](#gp_segment_connect_timeout)
*   [gp\_segments\_for_planner](#gp_segments_for_planner)
*   [gp\_server\_version](#gp_server_version)
*   [gp\_server\_version_num](#gp_server_version_num)
*   [gp\_session\_id](#gp_session_id)
*   [gp\_set\_proc_affinity](#gp_set_proc_affinity)
*   [gp\_set\_read_only](#gp_set_read_only)
*   [gp\_snmp\_community](#gp_snmp_community)
*   [gp\_snmp\_monitor_address](#gp_snmp_monitor_address)
*   [gp\_snmp\_use\_inform\_or_trap](#gp_snmp_use_inform_or_trap)
*   [gp\_statistics\_pullup\_from\_child_partition](#gp_statistics_pullup_from_child_partition)
*   [gp\_statistics\_use_fkeys](#gp_statistics_use_fkeys)
*   [gp\_vmem\_idle\_resource\_timeout](#gp_vmem_idle_resource_timeout)
*   [gp\_vmem\_protect_limit](#gp_vmem_protect_limit)
*   [gp\_vmem\_protect\_segworker\_cache_limit](#gp_vmem_protect_segworker_cache_limit)
*   [gp\_workfile\_checksumming](#gp_workfile_checksumming)
*   [gp\_workfile\_compress_algorithm](#gp_workfile_compress_algorithm)
*   [gp\_workfile\_limit\_files\_per_query](#gp_workfile_limit_files_per_query)
*   [gp\_workfile\_limit\_per\_query](#gp_workfile_limit_per_query)
*   [gp\_workfile\_limit\_per\_segment](#gp_workfile_limit_per_segment)
*   [gpperfmon_port](#gpperfmon_port)
*   [整数_datetimes](#integer_datetimes)
*   [IntervalStyle](#IntervalStyle)
*   [join\_collapse\_limit](#join_collapse_limit)
*   [keep\_wal\_segments](#keep_wal_segments)
*   [krb\_caseins\_users](#krb_caseins_users)
*   [krb\_server\_keyfile](#krb_server_keyfile)
*   [krb_srvname](#krb_srvname)
*   [lc_collate](#lc_collate)
*   [lc_ctype](#lc_ctype)
*   [lc_messages](#lc_messages)
*   [lc_monetary](#lc_monetary)
*   [lc_numeric](#lc_numeric)
*   [lc_time](#lc_time)
*   [listen_addresses](#listen_addresses)
*   [local\_preload\_libraries](#local_preload_libraries)
*   [log_autostats](#log_autostats)
*   [log_connections](#log_connections)
*   [log_disconnections](#log_disconnections)
*   [log\_dispatch\_stats](#log_dispatch_stats)
*   [log_duration](#log_duration)
*   [log\_error\_verbosity](#log_error_verbosity)
*   [log\_executor\_stats](#log_executor_stats)
*   [log_hostname](#log_hostname)
*   [log\_min\_duration_statement](#log_min_duration_statement)
*   [log\_min\_error_statement](#log_min_error_statement)
*   [log\_min\_messages](#log_min_messages)
*   [log\_parser\_stats](#log_parser_stats)
*   [log\_planner\_stats](#log_planner_stats)
*   [log\_rotation\_age](#log_rotation_age)
*   [log\_rotation\_size](#log_rotation_size)
*   [log_statement](#log_statement)
*   [log\_statement\_stats](#log_statement_stats)
*   [log_timezone](#log_timezone)
*   [log\_truncate\_on_rotation](#log_truncate_on_rotation)
*   [max\_appendonly\_tables](#max_appendonly_tables)
*   [max_connections](#max_connections)
*   [max\_files\_per_process](#max_files_per_process)
*   [max\_fsm\_pages](#max_fsm_pages)
*   [max\_fsm\_relations](#max_fsm_relations)
*   [max\_function\_args](#max_function_args)
*   [max\_identifier\_length](#max_identifier_length)
*   [max\_index\_keys](#max_index_keys)
*   [max\_locks\_per_transaction](#max_locks_per_transaction)
*   [max\_prepared\_transactions](#max_prepared_transactions)
*   [max\_resource\_portals\_per\_transaction](#max_resource_portals_per_transaction)
*   [max\_resource\_queues](#max_resource_queues)
*   [max\_stack\_depth](#max_stack_depth)
*   [max\_statement\_mem](#max_statement_mem)
*   [optimizer](#optimizer)
*   [optimizer\_array\_expansion_threshold](#optimizer_array_expansion_threshold)
*   [optimizer\_analyze\_root_partition](#optimizer_analyze_root_partition)
*   [optimizer_control](#optimizer_control)
*   [optimizer\_cte\_inlining_bound](#optimizer_cte_inlining_bound)
*   [optimizer\_enable\_master\_only\_queries](#optimizer_enable_master_only_queries)
*   [optimizer\_force\_multistage_agg](#optimizer_force_multistage_agg)
*   [optimizer\_force\_three\_stage\_scalar_dqa](#optimizer_force_three_stage_scalar_dqa)
*   [optimizer\_join\_order_threshold](#optimizer_join_order_threshold)
*   [optimizer\_mdcache\_size](#optimizer_mdcache_size)
*   [optimizer\_metadata\_caching](#optimizer_metadata_caching)
*   [optimizer_minidump](#optimizer_minidump)
*   [optimizer\_nestloop\_factor](#optimizer_nestloop_factor)
*   [optimizer\_parallel\_union](#optimizer_parallel_union)
*   [optimizer\_print\_missing_stats](#optimizer_print_missing_stats)
*   [optimizer\_print\_optimization_stats](#optimizer_print_optimization_stats)
*   [optimizer\_sort\_factor](#optimizer_sort_factor)
*   [password_encryption](#password_encryption)
*   [password\_hash\_algorithm](#password_hash_algorithm)
*   [pgstat\_track\_activity\_query\_size](#pgstat_track_activity_query_size)
*   [pljava_classpath](#pljava_classpath)
*   [pljava\_classpath\_insecure](#pljava_classpath_insecure)
*   [pljava\_statement\_cache_size](#pljava_statement_cache_size)
*   [pljava\_release\_lingering_savepoints](#pljava_release_lingering_savepoints)
*   [pljava_vmoptions](#pljava_vmoptions)
*   [port](#port)
*   [random\_page\_cost](#random_page_cost)
*   [readable\_external\_table_timeout](#readable_external_table_timeout)
*   [repl\_catchup\_within_range](#repl_catchup_within_range)
*   [replication_timeout](#replication_timeout)
*   [regex_flavor](#regex_flavor)
*   [resource\_cleanup\_gangs\_on\_wait](#resource_cleanup_gangs_on_wait)
*   [resource\_select\_only](#resource_select_only)
*   [runaway\_detector\_activation_percent](#runaway_detector_activation_percent)
*   [search_path](#search_path)
*   [seq\_page\_cost](#seq_page_cost)
*   [server_encoding](#server_encoding)
*   [server_version](#server_version)
*   [server\_version\_num](#server_version_num)
*   [shared_buffers](#shared_buffers)
*   [shared\_preload\_libraries](#shared_preload_libraries)
*   [ssl](#ssl)
*   [ssl_ciphers](#ssl_ciphers)
*   [standard\_conforming\_strings](#standard_conforming_strings)
*   [statement_mem](#statement_mem)
*   [statement_timeout](#statement_timeout)
*   [stats\_queue\_level](#stats_queue_level)
*   [superuser\_reserved\_connections](#superuser_reserved_connections)
*   [tcp\_keepalives\_count](#tcp_keepalives_count)
*   [tcp\_keepalives\_idle](#tcp_keepalives_idle)
*   [tcp\_keepalives\_interval](#tcp_keepalives_interval)
*   [temp_buffers](#temp_buffers)
*   [TimeZone](#TimeZone)
*   [timezone_abbreviations](#timezone_abbreviations)
*   [track_activities](#track_activities)
*   [track_counts](#track_counts)
*   [transaction_isolation](#transaction_isolation)
*   [transaction\_read\_only](#transaction_read_only)
*   [transform\_null\_equals](#transform_null_equals)
*   [unix\_socket\_directory](#unix_socket_directory)
*   [unix\_socket\_group](#unix_socket_group)
*   [unix\_socket\_permissions](#unix_socket_permissions)
*   [update\_process\_title](#update_process_title)
*   [vacuum\_cost\_delay](#vacuum_cost_delay)
*   [vacuum\_cost\_limit](#vacuum_cost_limit)
*   [vacuum\_cost\_page_dirty](#vacuum_cost_page_dirty)
*   [vacuum\_cost\_page_hit](#vacuum_cost_page_hit)
*   [vacuum\_cost\_page_miss](#vacuum_cost_page_miss)
*   [vacuum\_freeze\_min_age](#vacuum_freeze_min_age)
*   [validate\_previous\_free_tid](#validate_previous_free_tid)
*   [vmem\_process\_interrupt](#vmem_process_interrupt)
*   [wal\_receiver\_status_interval](#wal_receiver_status_interval)
*   [writable\_external\_table_bufsize](#writable_external_table_bufsize)
*   [xid\_stop\_limit](#xid_stop_limit)
*   [xid\_warn\_limit](#xid_warn_limit)
*   [xmlbinary](#xmlbinary)
*   [xmloption](#xmloption)

add\_missing\_from
------------------

自动向 FROM 字句添加缺少的表引用。当前与 8.1 之前的版本的 PostgreSQL 的版本兼容，默认情况下允许此行为。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

application_name
----------------

设置客户端会话的应用程序名称。例如，如果通过 psql 连接，这将会被设置为 psql。设置应用程序名称可以在日志消息和统计视图中进行报告。

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> session <br> reload|

array_nulls
-----------

该参数控制输入解析器是否将非引用的 NULL 识别为指定空数组元素。默认情况下，这是打开的，允许输入数组值包含空值。因此可以将 NULL 视为指定字符串值为 “NULL” 的普通数组元素。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

authentication_timeout
----------------------

完成客户端认证的最大时间，这样可以防止挂起的客户端无限期占用连接。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|1分钟|local <br> system <br> restart|

backslash_quote
---------------

这可以控制是否在字符串中可以用 \\'表示引号。代表引号的首选 SQL 标准是用 （''） 表示，但是 PostgreSQL 历来也使用 \\'。但是，使用 \\' 会导致安全风险，因为在一些客户端字符集编码中，有很多多字节字符，其中最后一个字节等同于 ASCII 字符 \\。

|值范围|默认|设置分类|
|:---|:---|:---|
|on（总是允许 \\'） <br> off（总是拒绝） <br> safe_encoding （只有客户端编码不允许多字节中的ASCII字符\\才允许）|safe_encoding|master <br> session <br> reload|

block_size
----------

报告磁盘块大小。

|值范围|默认|设置分类|
|:---|:---|:---|
|字节数|32768|只读|

bonjour_name
------------

指定 Bonjour 广播名称。默认情况下，使用计算机名称，指定为空字符串。如果服务器未支持 Bonjour 服务，则忽略此选项。

|值范围|默认|设置分类|
|:---|:---|:---|
|string|未设置|master <br> system <br> restart|

check\_function\_bodies
-----------------------

当设置为关闭时，禁用在 CREATE FUNCTION 期间函数体字符串的验证。当从 dump 恢复函数定义时禁用验证对避免诸如转发引用之类的问题是有时有用的。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

client_encoding
---------------

设置客户端编码（字符集）。默认是使用与数据库相同的编码。请参阅 PostgreSQL 文档中的 [支持的字符集](https://www.postgresql.org/docs/8.3/static/multibyte.html#MULTIBYTE-CHARSET-SUPPORTED)。

|值范围|默认|设置分类|
|:---|:---|:---|
|字符集|UTF8|master <br> session <br> reload|

client\_min\_messages
---------------------

控制哪些消息级别发送到客户端。每个级别包括跟它随后的所有级别，越往后的级别，发送的消息就越少。

|值范围|默认|设置分类|
|:---|:---|:---|
|DEBUG5 <br> DEBUGz4 <br> DEBUG3 <br> DEBUG2 <br> DEBUG1 <br> LOG <br> NOTICE <br> WARNING <br> ERROR <br> FATAL <br> PANIC|NOTICE|master <br> session <br> reload|

cpu\_index\_tuple_cost
----------------------

对于传统的查询优化器（planner），在索引扫描期间设置对处理每个索引行代价的估计。这是作为顺序页面提取代价的一部分来衡量的。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|0.005|master <br> session <br> reload|

cpu\_operator\_cost
-------------------

对于传统的查询优化器（planner），设置对处理 WHERE 语句中每个操作符代价的估计。这是作为顺序页面提取代价的一部分来衡量的。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|0.0025|master <br> session <br> reload|

cpu\_tuple\_cost
----------------

对于传统的查询优化器（planner），设置对处理一个查询中每行（元组）代价的估计。这是作为顺序页面提取代价的一部分来衡量的。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|0.01|master <br> session <br> reload|

cursor\_tuple\_fraction
-----------------------

告知传统查询优化器（planner）预期在游标查询中提取多少行，从而允许传统优化器使用此信息来优化查询计划 。默认值为 1 表示获取所有行。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|1|master <br> session <br> reload|

custom\_variable\_classes
-------------------------

指定要用于自定义变量的一个或多个类名。自定义变量通常是服务器不知道的变量，但是由一些附加模块使用。这些变量的名字必须由类名，点和变量名组成。

|值范围|默认|设置分类|
|:---|:---|:---|
|逗号分隔的类名列表|未设置|local <br> system <br> restart|

DateStyle
---------

设置日期和时间值的显示格式，以及解释模糊日期输入值的规则。该变量值包含两个独立的而部分：输出格式规范和输入输出规范中年月日的顺序。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<format\>, \<date style\> <br> 其中： <br> \<format\> 是 ISO、Postgres、SQL 或者 German <br> \<date style\> 是 DMY、MDY 或者 YMD|ISO, MDY|master <br> session <br> reload|

db\_user\_namespace
-------------------

这启用了每个数据库的用户名。如果打开，用户应该以 _username@dbname_ 创建用户。要创建普通的全局用户，只需要在客户端指定用户名时附加 @。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

deadlock_timeout
----------------

在检查以查看是否存在死锁情况之前等待锁的时间。在一个比较重的服务器上，用户可能希望提高此值。理想的情况下，设置的值应该超过用户的典型处理时间，以此提高在等待线程在决定检查死锁之前自动解锁的几率。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效时间的表达式（数字或者单位）。|1 s|local <br> system <br> restart|

debug_assertions
----------------

打开各种断言检查。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

debug\_pretty\_print
--------------------

缩进调试输出产生更可读但是更长的输出格式。 _client\_min\_messages_ 或者 _log\_min\_messages_ 必须是 DEBUG1 或者更低。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

debug\_print\_parse
-------------------

对于每一个执行的查询，打印出结果分析树。 _client\_min\_messages_ 或 _log\_min\_messages_ 必须是 DEBUG1 或者更低。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

debug\_print\_plan
------------------

对于每个执行的查询，打印出 HashData 并行查询执行计划。 _client\_min\_messages_ 或 _log\_min\_messages_ 必须是 DEBUG1 或者更低。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

debug\_print\_prelim_plan
-------------------------

对每个执行的查询，打印出初步查询计划。 _client\_min\_messages_ 或 _log\_min\_messages_ 必须是 DEBUG1 或者更低。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

debug\_print\_rewritten
-----------------------

对于每个执行的查询，打印出查询重写输出。 _client\_min\_messages_ 或 _log\_min\_messages_ 必须是 DEBUG1 or lower.

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

debug\_print\_slice_table
-------------------------

对于每个执行的查询，打印  HashData  查询分片计划。 _client\_min\_messages_ 或 _log\_min\_messages_ 必须是 DEBUG1 或者更低。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

default\_statistics\_target
---------------------------

通过 ALTER TABLE SET STATISTICS 为没有指定列目标集的表的列设置默认统计目标。较大的值会增加 ANALYZE 所需的时间，但是可能会提高传统查询优化器（planner） 估计的质量。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|25|master <br> session <br> reload|

default_tablespace
------------------

当 CREATE 命令没有明确指定一个表空间，会在默认的表空间创建对象（表和索引）。

|值范围|默认|设置分类|
|:---|:---|:---|
|表空间的名字|未设置|master <br> session <br> reload|

default\_transaction\_isolation
-------------------------------

控制每个新事务的默认隔离级别

|值范围|默认|设置分类|
|:---|:---|:---|
|读已提交（read committed） <br> 读未提交（read uncommitted） <br> 序列化（serializable）|读已提交（read committed）|master <br> session <br> reload|

default\_transaction\_read_only
-------------------------------

控制每个新事务的默认只读状态。只读的SQL事务 不能修改非临时表。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

dynamic\_library\_path
----------------------

如果需要打开动态加载的模块，并且在 CREATE FUNCTION 或 LOAD 命令中指定的文件名没有目录部分（即：目录不包括斜杠），系统会搜索该路径以获取所需的文件。此时， PostgreSQL 内置编译的包库目录会替换 \$libdir。这是由标准 PostgreSQL 发行版提供的模块安装位置。

|值范围|默认|设置分类|
|:---|:---|:---|
|由冒号分隔的绝对目录路径列表|\$libdir|local <br> system <br> restart|

effective\_cache\_size
----------------------

设置对于遗传查询优化器（计划器）的单个查询可用的磁盘缓存的有效大小的假设。这是对使用索引成本估计的因素；较高的值使之更可能使用索引扫描，较低的值使之更可能使用顺序扫描。该参数对 HashData 服务器实例分配的共享内存大小没有影响。也不会保留内核磁盘缓存；它仅用于估计目的。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|512MB|master <br> session <br> reload|

enable_bitmapscan
-----------------

启用或禁用遗传查询优化器（计划程序）使用位图扫描计划类型。请注意，这不同于位图索引扫描。位图扫描意味着索引将在适当时候动态转换为内存中的位图，从而使得针对大型表的复杂查询的索引性能更快。当不同索引上有多个谓词时使用它。可以比较每列的每个位图，以创建所选元组的最终列表。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_groupagg
---------------

启用或禁用遗传查询优化器（计划器）使用组聚集计划类型

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_hashagg
--------------

启用或禁用遗传查询优化器（计划器）使用哈希聚集计划类型。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_hashjoin
---------------

启用或者禁用遗传查询优化器（计划器）使用散列聚集计划类型。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_indexscan
----------------

启用或禁用遗传查询优化器（计划器）使用索引扫描计划类型。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_mergejoin
----------------

启用或禁用遗传查询优化器（计划器）使用合并连接计划类型。合并连接是基于左右表的顺序排序，然后并行扫描它们的想法。因此，两种数据类型必须能够被完全排序，并且连接操作符必须是只能在排序顺序中位于“相同位置”的值对的连接操作符号。在实践中，这意味着连接操作符具有相等的性质。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

enable_nestloop
---------------

启用或禁用遗传查询优化器（计划器）使用嵌套循环连接计划。完全禁止嵌套循环连接是不可能的，但是如果有其他方法可用，则关闭此变量可能会使得遗传优化器放弃使用该方法。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

enable_seqscan
--------------

启用或者禁用遗传查询优化器（计划器）使用顺序扫描类型。完全禁止顺序扫描是不可能 的，但是如果有其他方法可用，则关闭此变量将阻止遗传查询优化器使用该方法。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_sort
-----------

启用或禁用遗传查询优化器（计划器）使用显式的排序步骤。完全禁止显式排序是不可能的，但是，如果有其他可用的方法，关闭此变量将阻止遗传查询优化器使用该方法。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

enable_tidscan
--------------

启用或者禁止遗传查询优化器（计划器）使用元组标识符。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

escape\_string\_warning
-----------------------

打开的时候，如果在普通字符串文字（‘...’语法）中出现反斜杠（\\）,则会发出警告。转义字符语法（E'...'）应用于转义，因为在将来的版本中，普通字符串将具有字面上处理反斜杠的符合SQL标准的行为。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

explain\_pretty\_print
----------------------

确定 EXPLAIN VERBOSE 是否使用缩进或非缩进格式显示详细的查询树存储。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

extra\_float\_digits
--------------------

调整浮点值显示的位数，包括float4，float8， 和几何数据类型。将参数将加到数位上。该值可以设置为高达2，包括部分有效位。这对于转储需要精确恢复的浮点数据尤其有用。或者用以用来设置为负摒弃不需要的位。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|0|master <br> session <br> reload|

filerep\_mirrorvalidation\_during_resync
----------------------------------------

该默认设置值 false 在段镜像增量重新同步期间可以提供数据库性能。设置为 true 可以在增量重新同步期间检查段镜像上所有关系的文件是否存在。检查文件会降低增量重新同步过程的性能，但是提供了对数据库对象的最小检查。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|false|master <br> session <br> reload|

from\_collapse\_limit
---------------------

如果生成的 FROM 列表不超过这么多项，则遗传查询优化器（计划器）将把子查询合并到上层查询中。较小的值会较少计划时间，但是可能会产生较差的查询计划。

|值范围|默认|设置分类|
|:---|:---|:---|
|1- _n_|20|master <br> session <br> reload|

gp\_adjust\_selectivity\_for\_outerjoins
----------------------------------------

启用对外连接的NULL测试的选择性。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_analyze\_relative_error
---------------------------

设置表的基数的估计可接受的误差，0.5应该等于可50%的接受的误差（这是PostgreSQL中使用的默认值）。如果在 ANALYZE 期间收集的统计数据没有对特定表属性产生良好的基数估计，减少相对误差值（接受较少的错误）告诉系统对更多行进行采样。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点 < 1.0|0.25|master <br> session <br> reload|

gp\_appendonly\_compaction
--------------------------

在 VACUUM 命令期间启用压缩段文件。当禁用时， VACUUM 只会将段文件清为EOF值，与当前的行为一样。管理员可能希望在高I/O负载情况或低空闲空间的情况下禁用压缩。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_appendonly\_compaction_threshold
------------------------------------

当在没有指定FULL选项情况下运行VACUUM时，指明隐藏行和总行的阀值比率（以百分比表示），该比率会触发段文件的压缩。如果段中的段文件中的隐藏行的比例小于该阀值，则段文件不能压缩，并且发出日志消息。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 (%)|10|master <br> session <br> reload|

gp\_autostats\_mode
-------------------

指定使用 ANALYZE触发自动统计信息收集的模式。on\_no\_stats 选项可以触发对任何没有统计信息的表上的 CREATE TABLE AS SELECT，INSERT，或 COPY 操作的统计信息收集。

当受影响的行数超过由 gp\_autostats\_on\_change\_threshold 定义的阀值时，on_change 选项才会触发统计信息收集。可以使用 on_change 触发自动统计信息收集的操作有：

```
CREATE TABLE AS SELECT

UPDATE

DELETE

INSERT

COPY
```

默认值是 on\_no\_stats。

> 注意： 对于分区表来说，如果从分区表的顶级父表插入数据，则不会触发自动统计信息收集。

如果数据直接插入到分区表的叶表（数据的存储位置）中，则触发自动统计信息收集。统计数据仅在叶表上收集。

|值范围|默认|设置分类|
|:---|:---|:---|
|none <br> on_change <br> on\_no\_stats|on\_no\_ stats|master <br> session <br> reload|

gp\_autostats\_mode\_in\_functions
----------------------------------

指定使用过程语言函数中的 ANALYZE 语句触发自动统计信息收集的模式。 none 选项禁用统计信息收集。 on\_no\_stats 选项在任何没有现有统计信息表上的函数中执行的 CREATE TABLE AS SELECT，INSERT，或 COPY 操作触发统计信息收集。

只有当受影响的行数超过由gp\_autostats\_on\_change\_threshold定义的阀值时，on_change 选项才会触发统计信息收集。可以使用 on_change 触发自动信息统计收集功能的操作有：

```
CREATE TABLE AS SELECT

UPDATE

DELETE

INSERT

COPY
```

|值范围|默认|设置分类|
|:---|:---|:---|
|none <br> on_change <br> on\_no\_stats|none|master <br> session <br> reload|

gp\_autostats\_on\_change\_threshold
------------------------------------

当 gp\_autostats\_mode 设定为 on_change时，指明自动统计信息收集的阀值。当触发表操作影响超过此阀值的行数时，将添加ANALYZE 并收集表的统计信息。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|2147483647|master <br> session <br> reload|

gp\_backup\_directIO
--------------------

直接 I/O 允许 HashData 数据库绕过文件系统缓存中的内存缓冲区进行备份。当直接 I/O 用于文件时，数据将直接从磁盘传输到应用程序缓冲区，而不使用文件缓冲区缓存。

仅在 Red Hat Enterprise Linux，CentOS，和SUSE上支持直接I/O。

|值范围|默认|设置分类|
|:---|:---|:---|
|on, off|off|local <br> session <br> reload|

gp\_backup\_directIO\_read\_chunk_mb
------------------------------------

当使用 [gp\_backup\_directIO](#gp_backup_directIO)启用直接I/O时，以MB为单位设置块的大小。默认的块大小是20MB。

默认值是最佳设置。减少该值会增加备份时间，增加该值会导致备份时间几乎不变。

|值范围|默认|设置分类|
|:---|:---|:---|
|1-200|20 MB|local <br> session <br> reload|

gp\_cached\_segworkers_threshold
--------------------------------

当用户启动与 HashData 数据库的会话并发出查询时，系统将在每个段上创建工作进程的组或”帮派“，以进行工作。完成工作以后，除了由此参数设置的缓存数字外，段工作进程将被销毁。较低的设置节省了段主机上的系统资源，但更高的设置可能会提高高级用户（希望在一行中发出许多复杂查询）的性能。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|5|master <br> session <br> reload|

gp\_command\_count
------------------

显示主机从客户端收到的命令数量。请注意，单个SQLcommand可能在内部实际涉及多个命令，因此对于单个查询，计数器可能会增加多个命令。该计数器也由在命令上执行的所有段进程共享。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|1|read only|

gp\_connection\_send_timeout
----------------------------

在查询处理期间发送数据到无响应的 HashData 数据库用户客户端的超时时间。值为0将禁用超时， HashData 数据库将无限期地等待客户端。到达超时时，将使用此消息取消查询：

无法向客户端发送数据：连接超时。

|值范围|默认|设置分类|
|:---|:---|:---|
|秒数|3600（1小时）|master <br> system <br> reload|

gp\_connections\_per_thread
---------------------------

当处理SQL查询时，调度工作以查询段实例上的执行段实例上的执行程序进程时，控制 HashData 数据库查询调度程序（QD）生成的异步线程（工作线程）的数量。当处理查询时，该值设置工作线程连接到的主段实例的数量。例如，当值是2的时并且有64个段实例时，QD将生成32个工作线程来调度查询计划工作。每个线程分派给2个段。

对于默认值0，查询分派器生成两种类型的线程：管理查询计划工作分派的主线程和互连线程。主线程也作为工作线程。

对于大于0的值，QD 生成3中类型的线程：主线程，一个或者多个工作线程和互连线程。当该值等于或者大于段实例的数量时，QD将生成3个线程：主线程，单个工作线程和互连线程。

不需要改动该默认值，除非有已知的吞吐性能问题。

该参数仅适用于主机，并更改它需要需要重新启动服务器。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 >= 0|0|master <br> restart|

gp_content
----------

如果是段的话则为本地内容。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数||read only|

gp\_create\_table\_random\_default_distribution
-----------------------------------------------

使用不包含DISTRIBUTED BY子句的CREATE TABLE 或 CREATE TABLE AS 创建 HashData 数据库表时，控制表的创建。

对于 CREATE TABLE，如果参数的值为 off（默认值），并且表创建命令不包含 DISTRIBUTED BY 子句，则 HashData 数据库将根据该命令选择分布键。如果表创建命令中指定了 LIKE 或者 INHERITS 子句，则创建的表使用与源表或父表相同的分布键。

如果该参数值设置为真 on，当未指定DISTRIBUTED BY子句时， HashData 数据库遵循以下规则创建表：

*   如果 PRIMARY KEY 或者 UNIQUE 列未指定，则该表的分布式随机的（DISTRIBUTED RANDOMLY）。即使创建表的命令中包含 LIKE 或 INHERITS 子句，表分布也是随机的。
*   如果指定了 PRIMARY KEY 或者 UNIQUE 列，还必须指定 DISTRIBUTED BY 子句。如果没有指定 DISTRIBUTED BY 子句作为表创建命令的一部分，则该命令失败。

对于不包含分布子句的 CREATE TABLE AS 命令：

*   如果遗传查询优化器创建表，并且参数的值为 off，则表分布策略将根据该命令确定。
*   如果遗传查询优化器创建表，并且参数的值为 on，则表分布策略是随机的。
*   如果 GPORCA 创建表，则表分布策略是随机的，该参数无效。

更多关于遗传查询优化器和GPORCA的信息，请参阅  HashData 数据库管理员指南的“查询数据”。

|值范围|默认|设置分类|
|:---|:---|:---|
|boolean|off|master <br> system <br> reload|

gp_dbid
-------

如果是段，为本地内容的dbid。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数||read only|

gp\_debug\_linger
-----------------

在致命内部错误之后， HashData 进程停留的秒数。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|0|master <br> session <br> reload|

gp\_default\_storage_options
----------------------------

当使用 CREATE TABLE 命令创建表之后，为以下的表存储选项设置默认值。

*   APPENDONLY
*   BLOCKSIZE
*   CHECKSUM
*   COMPRESSTYPE
*   COMPRESSLEVEL
*   ORIENTATION

以逗号分隔列表指定多个存储选项值。

用户可以使用此参数设置存储选项，而不是在CREATE TABLE命令的WITH中指定表存储选项。使用 CREATE TABLE 命令指定的表存储选项将覆盖此参数指定的值。

并非存储选项值的所有组合都有效。如果指定的存储选项无效，则返回错误。有关表存储选项的信息，请参阅 CREATE TABLE 命令。

可以为数据库和用户设置默认值。如果服务器配置参数设置在不同的级别，则当用户登录到数据库并创建表时候，表存储值的优先顺序从最高到最低：

1.  在 CREATE TABLE 命令中用 WITH 子句或者 ENCODING 子句指定的值。
2.  使用 ALTER ROLE...SET 命令为用户设置的 gp\_default\_storage_options 的值。
3.  ALTER DATABASE...SET 命令为用户创建的 gp\_default\_storage_options 的值。
4.  使用 gpconfig 实用功能为 HashData 数据库系统创建的 gp\_default\_storage_options 的值。

参数值不是累积的。例如，如果，参数指定数据库和用户登录的 APPENDONLY 和 COMPRESSTYPE 选项，并且设置参数以指定 ORIENTATION 选项的值，则将忽略在数据库级别设置的 APPENDONLY，和 COMPRESSTYPE 值。

此示例 ALTER DATABASE 命令为数据库mystest设置了默认的 ORIENTATION 和 COMPRESSTYPE 表存储选项。

```
ALTER DATABASE mytest SET gp\_default\_storage\_options = 'orientation=column, compresstype=rle\_type'
```

要在 mytest 数据库中使用面向列的表和RLE压缩方式创建一个追加优化表。用户需要仅在WITH子句中指定 APPENDONLY=TRUE。

该例子 gpconfig 实用程序命令为 HashData 数据库系统设置默认存储选项。如果用户为多表存储选项设置了默认值，则该值必须要用单引号括起来，然后再用双引号括起来。

```
gpconfig -c 'gp\_default\_storage_options' -v "'appendonly=true, orientation=column'"
```

此示例 gpconfig 实用程序命令显示参数的值。该参数的值必须在 HashData 数据库主机和所有段之间一致。

```
gpconfig -s 'gp\_default\_storage_options'
```
|值范围|默认|Set Classifications 1|
|:---|:---|:---|
|APPENDONLY= TRUE \| FALSE <br> BLOCKSIZE= integer between 8192 and 2097152 <br>  CHECKSUM= TRUE \| FALSE <br> COMPRESSTYPE= ZLIB \| QUICKLZ2 \| RLE_TYPE \| NONE <br> COMPRESSLEVEL= integer between 0 and 9 <br> ORIENTATION= ROW \| COLUMN|APPENDONLY=FALSE <br> BLOCKSIZE=32768 <br> CHECKSUM=TRUE <br> COMPRESSTYPE=none <br> COMPRESSLEVEL=0 <br> ORIENTATION=ROW|master <br> session <br> reload|

> 注意： 1当参数使用 gpconfig 实用程序实用程序设置在系统级时，为set classification（集合分类）

gp\_dynamic\_partition_pruning
------------------------------

启用可以动态消除分区扫描的计划。

|值范围|默认|设置分类|
|:---|:---|:---|
|on/off|on|master <br> session <br> reload|

gp\_email\_from
---------------

邮件地址用发送邮件警告，以该形式：

'username@example.com'

或

'Name \<username@example\.com\>'

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> system <br> reload <br> superuser|

gp\_email\_smtp_password
------------------------

用于与SMTP服务器进行身份验证的密码/密令。

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> system <br> reload <br> superuser|

gp\_email\_smtp_server
----------------------

用于发送电子邮件警报的SMTP服务器的完全限定域名或IP地址和端口。必须的格式为：

smtp_servername.domain.com:port

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> system <br> reload <br> superuser|

gp\_email\_smtp_userid
----------------------

用于和SMTP服务器进行认证的用户id。

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> system <br> reload <br> superuser|

gp\_email\_to
-------------

分号（;）分隔的电子邮件地址列表接受电子邮件警报消息，格式为：‘username\@example.com’

或

'Name \<username@example\.com\>'

如果没有设置此参数，则禁用邮件警告。

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> system <br> reload <br> superuser|

gp\_enable\_adaptive_nestloop
-----------------------------

在遗传查询优化器的执行时间内，启用使用名为“自适应嵌套式”的新类型的连接节点。这将导致遗传优化器相比嵌套连接更倾向于哈希连接，如果连接外侧的行数超过预先计算的阀值。这参数提高索引操作的性能，该遗传查询优化器以前喜欢慢的嵌套循环连接。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_agg_distinct
------------------------

启用或者禁用两阶段聚合以计算单个不同合格的聚合。这仅适用于包含单个不同合格的聚合函数的子查询。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_agg\_distinct\_pruning
----------------------------------

启用或者禁用三阶段聚合和连接来计算单个不同合格的聚合。这仅应用在包括一个或多个单个不同合格的聚合函数的子查询上。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_direct_dispatch
---------------------------

启用或者禁用针对访问单个段上的数据查询的目标查询计划的分派。打开时，目标行在单个段上的查询仅将他们的查询计划分配到该段（而不是所有段）。这显著地减少了限定查询的响应时间，因为没有涉及互连设置。直接分派的话确实需要主机上更多的CPU利用率。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> system <br> restart|

gp\_enable\_exchange\_default\_partition
----------------------------------------

控制 ALTER TABLE 的EXCHANGE DEFAULT PARTITION 子句的可用性。 该参数默认值为 off。如果该子句在 ALTER TABLE 命令中指定了，则该子句不可用并且 HashData 数据库返回一个错误。

如果该值为 on， HashData 数据库返回一个警告声明由于默认分区中无效的数据，交换默认分区可能会导致错误的结果。

警告： 在更换默认分区之前，必须确保要交换表中的数据，新的默认分区对默认分区有效。例如，新的默认分区中的数据不能包含在分区表的其他叶子分区中有效的数据。否则，使用有GPORCA执行交换的默认分区的分区表的查询可能返回不正确的结果。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

gp\_enable\_fallback_plan
-------------------------

允许使用禁用计划类型，当查询没有该类型不可行的时候。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_fast_sri
--------------------

当设置为 on，该遗传查询优化器（计划器）计划单行插入，因此他们被直接送到了正确的段实例上（无需引导操作）。这很大的提高了当行插入语句的性能。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_gpperfmon
---------------------

启用或者禁用数据收集代理，该代理为 HashData  命令中心填充 gpperfmon 数据库。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

gp\_enable\_groupext\_distinct\_gather
--------------------------------------

启用或禁用向单个节点收集数据，以便在组扩展查询上计算分别不同合格的聚集。当这个参数和 gp\_enable\_groupext\_distinct\_pruning 都启用了，该遗传查询优化器（计划器）使用代价较小的计划。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_groupext\_distinct\_pruning
---------------------------------------

启用或者禁用三阶段聚集和连接以在组扩展查询上计算不同合格的聚合。通常，启用此参数将生成较便宜（代价小）的查询计划，该计划相较于存在的计划将会被遗传查询优化器所使用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_multiphase_agg
--------------------------

启用或者禁用两或三阶段并行聚合方案的遗传查询优化器（计划程序）。此方法适用于具有聚合的任何子查询。如果 gp\_enable\_multiphase_agg 是off，则 gp\_enable\_agg_distinct 和 gp\_enable\_agg\_distinct\_pruning 将被禁用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_predicate_propagation
---------------------------------

当被启用时，该遗传查询优化器（计划器）会在表上分布键连接的地方将谓词应用于两个表的表达式。在进行连接前过滤这两个表（如果可以的话）会更有效率。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_preunique
---------------------

启用 SELECT DISTINCT 查询的两阶段重复删除（不是 SELECT COUNT(DISTINCT)）。启用后，它会在移动之前增加一个额外的 SORT DISTINCT 计划点集。在distinct操作大大较少行数的情况下，这种额外的 SORT DISTINCT 比跨Interconnect发送行代价小的多。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_sequential\_window\_plans
-------------------------------------

如果启用，启用包含窗口函数调用的查询的非并行查询计划。如果关闭，将并行评估兼容窗口函数并重新加入结果。这是一个实验参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_relsize_collection
------------------------------

如果没有表的统计信息，则可以使遗传查询优化器（计划程序）使用表的估计大小 （pg\_relation\_size 函数）。默认情况下，如果统计信息不可用，计划器将使用默认值来估计行数。默认行为可以提高查询计划时间，减少繁重工作负载中的资源的使用情况，但是可能导致次优计划。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

gp\_enable\_sort_distinct
-------------------------

排序的时候启用删除的重复项。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_enable\_sort_limit
----------------------

在排序时启用 LIMIT 操作。当计划最多需要前 _limit_number_ 行时候排序会更有效。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_external\_enable_exec
-------------------------

启用或禁用在段主机上执行os命令或脚本的外部表的使用（CREATE EXTERNAL TABLE EXECUTE 语法）。如果使用Command Center或 MapReduce功能，必须启用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> system <br> restart|

gp\_external\_max_segs
----------------------

设置在外部表操作期间将扫描外部表数据段的数量，目的是不使系统因扫描数据过载，并从其他并发操作中夺取资源。这仅适用于使用 the gpfdist:// 协议来访问外部表数据的外部表。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|64|master <br> session <br> reload|

gp\_filerep\_tcp\_keepalives\_count
-----------------------------------

在连接被认为死亡之前，可能会丢失多少个keepalives。值为0是默认使用系统默认值。如果不支持TCP_KEEPCNT，该参数必须是0。

对于主段和镜像段之间的所有连接，使用此参数。对于不在主段和镜像段之间的设置，请使用 tcp\_keepalives\_count。

|值范围|默认|设置分类|
|:---|:---|:---|
|丢失的keepalives数量|2|local <br> system <br> restart|

gp\_filerep\_tcp\_keepalives\_idle
----------------------------------

在空间连接上发送keepalive之间的秒数。值为0使用系统默认值。如果不支持TCP_KEEPIDLE ，该参数必须是0。

对于主段和镜像段之间的所有连接，使用此参数。对于不再主段和镜像段之间的设置，请使用 tcp\_keepalives\_idle。

|值范围|默认|设置分类|
|:---|:---|:---|
|秒数|1 分钟|local <br> system <br> restart|

gp\_filerep\_tcp\_keepalives\_interval
--------------------------------------

在重新传输之前等待响应 keepalive 的秒数。值为 0 使用默认值。如果不支持 TCP_KEEPINTVL ，则此参数必须为0。

对于主段和镜像段之间的所有连接，使用此参数，对于不在主镜像和镜像段之间的设置，请使用 tcp\_keepalives\_interval。

|值范围|默认|设置分类|
|:---|:---|:---|
|秒数|30 秒|local <br> system <br> restart|

gp\_fts\_probe_interval
-----------------------

指定故障检测过程的轮询间隔（ftsprobe）。 该 ftsprobe 进程大概需要此量的时间来检测分段故障。

|值范围|默认|设置分类|
|:---|:---|:---|
|10 - 3600 秒|1min|master <br> system <br> restart

gp\_fts\_probe_retries
----------------------

在报告段失败之前，指定故障检测进程（ftsprobe）尝试连接到段的次数。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|5|master <br> system <br> restart|

gp\_fts\_probe_threadcount
--------------------------

指定要创建的 ftsprobe 线程数。该参数应设置为等于或大于每个主机的段数。

|值范围|默认|设置分类|
|:---|:---|:---|
|1 - 128|16|master <br> system <br> restart|

gp\_fts\_probe_timeout
----------------------

指定故障检测过程（ftsprobe）允许的超时，以在声明它之前建立与段的连接。

|值范围|默认|设置分类|
|:---|:---|:---|
|10 - 3600 秒|20 秒|master <br> system <br> restart|

gp\_log\_fts
------------

控制故障检测进程（ftsprobe） 写入日志文件的细节数量。

|值范围|默认|设置分类|
|:---|:---|:---|
|OFF <br> TERSE <br> VERBOSE <br> DEBUG|TERSE|master <br> system <br> restart|

gp\_log\_gang
-------------

控制写入到日志文件中的关于查询工作进程创建和查询管理的信息量。默认值为 OFF，不记录信息。

|值范围|默认|设置分类|
|:---|:---|:---|
|OFF <br> TERSE <br> VERBOSE <br> DEBUG|OFF|master <br> session <br> restart|

gp\_gpperfmon\_send_interval
----------------------------

设置 HashData 数据库服务进程将查询执行更新发送到用数据收集代理进程的频率，该代理进程为Cmmand Center填充 gpperfmon 数据库。 此期间隔期间执行的查询操作通过UDP发送到段监视代理。如果发现在长时间运行的复杂查询中丢了过多的UDP的数据包用户可以考虑增加此值。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|1sec|master <br> system <br> restart|

gpperfmon\_log\_alert_level
---------------------------

控制哪些消息级别写入 gpperfmon 日志。每个级别包括跟随它的所有级别。级别越后，发送到日志的消息越少。

> 注意： 如果 gpperfmon 数据库已经安装并正在监视数据库，则默认值为警告。

|值范围|默认|设置分类|
|:---|:---|:---|
|none <br> warning <br> error <br> fatal <br> panic|none|local <br> system <br> restart|

gp\_hadoop\_home
----------------

使用 Pivotal HD 时，指定 Hadoop 的安装目录。例如，该默认安装目录是 /usr/lib/gphd。

使用 HashData  HD 1.2 或更早的版本时，请指定与 HADOOP_HOME 环境变量相同的值。

|值范围|默认|设置分类|
|:---|:---|:---|
|有效的目录名|HADOOP_HOME 的值|local <br> session <br> reload|

gp\_hadoop\_target_version
--------------------------

 HashData  Hadoop 目标的安装版本。

|值范围|默认|设置分类|
|:---|:---|:---|
|gphd-1.0 <br> gphd-1.1 <br> gphd-1.2 <br> gphd-2.0 <br> gphd-3.0 <br> gpmr-1.0 <br> gpmr-1.2 <br> hadoop2 <br> hdp2 <br> cdh5 <br> cdh3u2 <br> cdh4.1|gphd-1.1|local <br> session <br> reload|

gp\_hashjoin\_tuples\_per\_bucket
---------------------------------

设置 HashJoin 操作使用的哈希表的目标密度。较小的值将倾向于产生较大的哈希表，这可能增加连接性能。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|5|master <br> session <br> reload|

gp\_idf\_deduplicate
--------------------

改变计算和处理 MEDIAN 和 PERCENTILE_DISC 的策略。

|值范围|默认|设置分类|
|:---|:---|:---|
|auto <br> none <br> force|auto|master <br> session <br> reload|

gp\_initial\_bad\_row\_limit
----------------------------

对于参数值 _n_ ，当用户使用 COPY 命令或从外部表导入数据时，如果处理的前 _n_ 行包括格式错误，则 HashData 数据库停止处理输入行。如果前 _n_ 行中有处理的有效的行， HashData 数据库将继续处理输入行。

设置该值为 0 来禁止该限制。

也可以为 COPY 命令或者外部表定义指定 SEGMENT REJECT LIMIT 子句来限定被拒绝的行。

INT_MAX 是最大能够存储在用户系统上的 integer 值。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 0 - INT_MAX| 1000|master <br> session <br> reload|

gp\_interconnect\_fc_method
---------------------------

指定用于默认的 HashData 数据库 UDPIFC 互连的流控制方法。

对于基于容量的流量控制，当接收机不具有容量时，发送方不发送数据包。

基于丢失的流量控制是基于基于容量的流量控制的，并根据包的丢失情况调整发送速度。

|值范围|默认|设置分类|
|:---|:---|:---|
|CAPACITY <br> LOSS|LOSS|master <br> session <br> reload|

gp\_interconnect\_hash_multiplier
---------------------------------

设置由 HashData 数据库用于具有默认 UDPIFC 互连的互连连接的哈希表的大小。该数字乘以段数，以确定哈希表中的桶数。增加该值会增加复杂多片层查询的互连性能（同时在片段主机上占用更多内存）。

|值范围|默认|设置分类|
|:---|:---|:---|
|2-25|2|master <br> session <br> reload|

gp\_interconnect\_queue_depth
-----------------------------

设置由接收器上的 HashData 数据库互连排队的每个对等体的数据量（当数据被接收但没有空间可用于接收数据时，数据将被丢弃，并且发送器将需要重新发送），用于默认的 UDPIFC 互连。增加深度的默认值将导致系统使用多的内存，但可能提高性能。将此值设置在 1 到 10 之间是合理的。具有数据偏移的查询可能会随着队列深度的增加而更好地执行。增加这个值可能会大大增加系统使用的内存量。

|值范围|默认|设置分类|
|:---|:---|:---|
|1-2048|4|master <br> session <br> reload|

gp\_interconnect\_setup_timeout
-------------------------------

指定等待 HashData 数据库互连在超时之前完成设置的时间量。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|2 hours|master <br> session <br> reload|

gp\_interconnect\_snd\_queue\_depth
-----------------------------------

设置发送方默认的 UDPIFC 互连排队的每个对等端口上的数据量。增加深度默认值将导致系统使用更多内存，但是可能会提高性能。该参数的合理值在1到4之间。增加值可能会大大增加系统使用的内存量。

|值范围|默认|设置分类|
|:---|:---|:---|
|1 - 4096|2|master <br> session <br> reload|

gp\_interconnect\_type
----------------------

设置用于 HashData 数据库互连流量的网络协议。UDPIFC 指定使用UDP与互连流量的流量控制，并且这是唯一支持的值。

UDPIFC（默认值）指定使用UDP和互连流量的流量控制。使用 [gp\_interconnect\_fc_method](#gp_interconnect_fc_method) 指定互连流量控制方法。

使用TCP作为互连协议， HashData 数据库具有 1000 非分段实例的上限-如果查询包含复杂的多分片查询，上限就会小于该值。

|值范围|默认|设置分类|
|:---|:---|:---|
|UDPIFC <br> TCP|UDPIFC|local <br> system <br> restart|

gp\_log\_format
---------------

指定服务器日志文件的格式。如果使用 _gp_toolkit_ 管理模式，日志文件必须是 CSV 格式。

|值范围|默认|设置分类|
|:---|:---|:---|
|csv <br> text|csv|local <br> system <br> restart|

gp\_max\_csv\_line\_length
--------------------------

将导入到系统的 CSV 格式文件中的行的最大长度。默认值为 1MB（1048576 字节）。最大允许为 4MB（4194184 字节）。如果使用 _gp_toolkit_ 管理模式读取 HashData 数据库日志文件，则可能需要增加默认值。

|值范围|默认|设置分类|
|:---|:---|:---|
|字节数|1048576|local <br> system <br> restart|

gp\_max\_databases
------------------

在 HashData 数据库系统中允许的最大数据库数。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|16|master <br> system <br> restart|

gp\_max\_filespaces
-------------------

 HashData 数据库系统中允许的最大文件空间数。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|8|master <br> system <br> restart|

gp\_max\_local\_distributed\_cache
----------------------------------

将分布式实务日志条目的最大数量设置到段实例的后台进程内存的 cache 中。

日志条目包含正在被 SQL 语句访问的行状态的信息。在 MVCC 环境中执行多个同时进行的 SQL 语句时，该信息用于决定那些行对于 SQL 实务是可见的。通过提高行可见性确定进程的性能，本地缓存分布式实务日志条目可以提高事务处理速度。

默认值对于不同的 SQL 处理环境是最佳的。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|1024|local <br> system <br> restart|

gp\_max\_packet_size
--------------------

设置 HashData 数据库互连的元组序列块大小。

|值范围|默认|设置分类|
|:---|:---|:---|
|512-65536|8192|master <br> system <br> restart|

gp\_max\_plan_size
------------------

指定查询执行计划的总的最大未压缩的大小乘以计划中移动操作符（切片）的数量。如果查询计划的大小超过该值，则查询将被取消，并返回错误。值为0表示不监视计划的大小。

用户可以指定一个以 kB，MB，或者 GB。默认单位是 kB。例如，值 200 是 200kB。值 1GB 等同于 1024MB 或者 1048576kB。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|0|master <br> superuser <br> session|

gp\_max\_tablespaces
--------------------

 HashData 数据库系统允许的最大表空间数量。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|16|master <br> system <br> restart|

gp\_motion\_cost\_per\_row
--------------------------

设置移动操作符的遗传查询优化器（计划器）的成本估计，该移动操作符将一个行从一个段传输到另一个段，以顺序页面提取的成本为单位。如果为 0，则使用的值是 _cpu\_tuple\_cost_ 的两倍。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|0|master <br> session <br> reload|

gp\_num\_contents\_in\_cluster
------------------------------

 HashData 数据库系统主段数目。

|值范围|默认|设置分类|
|:---|:---|:---|
|-|-|read only|

gp\_reject\_percent_threshold
-----------------------------

对于 COPY 和外部表 SELECT 上的单行错误处理，设置在 SEGMENT REJECT LIMIT _n_ PERCENT 开始计算之前处理的行数。

|值范围|默认|设置分类|
|:---|:---|:---|
|1- _n_|300|master <br> session <br> reload|

gp\_reraise\_signal
-------------------

如果启用，如果发生致命的服务器错误，将尝试转存内核。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_resqueue\_memory_policy
---------------------------

启用  HashData  内存管理的功能。分布算法 eager_free 利用了一个事实，该事实是不是所有的操作符都在统一个时间执行。查询计划被分成几个阶段， HashData 数据库将在该阶段结束时急速释放分配给前一个阶段的内存，然后将新的内存分配给新阶段。

当设置为 none，内存管理和 HashData 数据库 4.1 之前的版本一样。

当设置为 auto，查询内存使用情况由 [statement_mem](#statement_mem) 和资源队列内存限制来控制。

|值范围|默认|设置分类|
|:---|:---|:---|
|none, auto, eager_free|eager_free|local <br> system <br> restart/reload|

gp\_resqueue\_priority
----------------------

启用或者禁用查询优先级。禁用此参数时，不会再查询运行时评估现有的优先级设置。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|local <br> system <br> restart|

gp\_resqueue\_priority\_cpucores\_per_segment
---------------------------------------------

指定每个段实例分配的 CPU 单元数。例如，如果 HashData 数据库集群具有 4 个段的 10 个核心段主机，则将段实例的值设置为 2.5。对于主实例，该值将为 10。主机上通常只有主实例运行在用户其上，因此主机的值应反应所有可用 CPU 内核的使用情况。

不正确的设置可能导致 CPU 利用率不足或查询优先级不能按照设计工作。

 HashData  Data Computing Appliance V2 上的段默认值是4，而主机上是25。

|值范围|默认|设置分类|
|:---|:---|:---|
|0.1 - 512.0|4|local <br> system <br> restart|

gp\_resqueue\_priority\_sweeper\_interval
-----------------------------------------

指定清理进程评估当前 CPU 使用情况的间隔。当新语句变成活动状态时，将在下一个时间间隔到来之前完成优先级评估和 CPU 共享的决定。

|值范围|默认|设置分类|
|:---|:---|:---|
|500 - 15000 ms|1000|local <br> system <br> restart

gp_role
-------

该服务进程的角色 " 对主机设置为 _dispatch_ ，对段设置为 _execute_ 。

|值范围|默认|设置分类|
|:---|:---|:---|
|dispatch <br> execute <br> utility||read only|

gp_safefswritesize
------------------

指定用于非成熟文件系统中追加优化表的安全写入操作的最小大小。当指定大于 0 的字节数时候，追加优化写入程序将附加数据添加到该数上，以防止由于文件系统错误导致的数据损坏。当使用具有该类型的文件系统的 HashData 数据库时，每个非成熟文件系统都具有已知的安全写入大小，该大小必须在这里指定。这通常是设置为文件系统的大小的倍数；例如，Linux ext3 是 4096 字节，所以值 32768 时经常使用的。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|0|local <br> system <br> restart|

gp\_segment\_connect_timeout
----------------------------

在超时之前， HashData 互连将尝试通过网络连接到段实例的时间。控制主段（master）和主要段（primary）之间的网络连接超时，以及主要段（primary）到镜像段之间的复制进程。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|10min|local <br> system <br> reload|

gp\_segments\_for_planner
-------------------------

假设在其成本和大小估计中，设置遗传查询优化器（计划器）主要段实例数。如果为0，则使用的值是实际的主要段数。该变量影响传统优化器对移动操作符中每个发送和接受进程处理的行数的估计。

|值范围|默认|设置分类|
|:---|:---|:---|
|0- _n_|0|master <br> session <br> reload|

gp\_server\_version
-------------------

以字符串报告服务器的版本号。版本修饰符参数可能会追加到版本字符串的数字部分，例如： _5.0.0beta_ 。

|值范围|默认|设置分类|
|:---|:---|:---|
|String. Examples: _5.0.0_|n/a|read only|

gp\_server\_version_num
-----------------------

以数字的形式报告服务器的版本号。该数保证永远对每个版本都是增加的，可以用来数字比较。主要版本是表示为两位数，次要和补丁版本是填充0。

|值范围|默认|设置分类|
|:---|:---|:---|
| _Mmmpp_ where _M_ is the major version, _mm_ is the minor version zero-padded and _pp_ is the patch version zero-padded. Example: 50000|n/a|read only|

gp\_session\_id
---------------

系统为客户端会话分配ID号。当主实例首次启动时，从1开始计数。

|值范围|默认|设置分类|
|:---|:---|:---|
|1- _n_|14|read only|

gp\_set\_proc_affinity
----------------------

如果启动，当 HashData 服务器（postmaster）开始时，它会绑定到CPU。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> system <br> restart|

gp\_set\_read_only
------------------

设置为 on 以禁用对数据库的写入。任何正在进行的事务必须必须在只读模式生效之前完成。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> system <br> restart|

gp\_snmp\_community
-------------------

设置为用户的环境指定的社区名称。

|值范围|默认|设置分类|
|:---|:---|:---|
|SNMP community name|public|master <br> system <br> reload|

gp\_snmp\_monitor_address
-------------------------

用户网络监视程序的主机名：端口。通常，端口是 162。如果有多个监视器地址，以逗号来分隔。

|值范围|默认|设置分类|
|:---|:---|:---|
|hostname:port||master <br> system <br> reload|

gp\_snmp\_use\_inform\_or_trap
------------------------------

陷阱通知是一个应用程序发送到另一个应用程序之间的 SMTP 消息（例如，在 HashData 数据库和网络监视应用程序之间）。这些消息不被监视应用程序所确认，但会产生更少的网络开销。

提醒通知和陷阱消息一样，除了应用程序会生成警告的应用程序发送确认。

|值范围|默认|设置分类|
|:---|:---|:---|
|inform <br> trap|trap|master <br> system <br> reload|

gp\_statistics\_pullup\_from\_child_partition
---------------------------------------------

当使用遗传查询优化器（计划器）对父表进行计划查询的时，启用子表统计信息的使用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_statistics\_use_fkeys
-------------------------

当启用时，允许遗传查询优化器（计划器）使用存储在系统目录中的外键信息来优化在外键和主键之间的连接。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

gp\_vmem\_idle\_resource\_timeout
---------------------------------

如果一个数据库会话空间时间超过指定时间，会话将释放系统资源（如共享内存），但仍然保持连接到数据库。这允许一次并发连接更多的连接到数据库。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|18s|master <br> system <br> reload|

gp\_vmem\_protect_limit
-----------------------

设置活跃段实例的所有 postgres 进程可以使用的内存量（以 MB 为单位）。如果查询超出该限制，则不会分配内存，并且查询将失败。请注意，这是本地参数，必须为系统中的每个段（主要段和镜像段）设置。设置参数值时，仅指定数值。例如，要指定 4096MB，请使用 4096。不要将单位 MB 添加到该值。

为了防止内存的过度分配，这些计算可以估计一个安全的 gp\_vmem\_protect_limit 值。

首先计算 gp_vmem的值。这是主机上可用的 HashData 数据库内存

```
gp_vmem = ((SWAP \+ RAM) – (7.5GB + 0.05 * RAM)) / 1.7
```
其中 SWAP 是主机交换空间，RAM 是主机上的 RAM，以 GB 为单位。

接下来，计算 max\_acting\_primary_segments。这是当镜像段由于故障而被激活时，可以在主机上运行的主要段（primary）的最大数量。对于每个主机，配置有4个主机块，8个段实例。例如，单个段主机故障将，在故障的主机模块每个剩余主机上，激活2或3个镜像段。此配置的 max\_acting\_primary_segments 值为11（8个主要段加上3个故障后激活的镜像段）。

这是 gp\_vmem\_protect_limit的计算。该值应转化为MB。

```
gp\_vmem\_protect_limit = gp_vmem / acting\_primary\_segments
```
对于生成大量工作文件的情况，这是负责工作文件 gp_vmem 的计算。

```
gp_vmem = ((SWAP \+ RAM) – (7.5GB + 0.05 * RAM \- (300KB * total_#_workfiles))) / 1.7
```
有关监视和管理工作文件使用情况的信息，请参阅  HashData  数据库管理员指南。

基于 gp_vmem 值用户可以计算 vm.overcommit_ratio 操作系统的内核参数。当配置每个 HashData 数据库主机时，此参数被设置。

```
vm.overcommit_ratio = (RAM \- (0.026 * gp_vmem)) / RAM
```
> 注意： 该内核参数 vm.overcommit_ratio 在 Red Hat Enterprise Linux 中默认值是50。

有关内核参数的信息，请参阅  HashData 数据库安装指南。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|8192|local <br> system <br> restart|

gp\_vmem\_protect\_segworker\_cache_limit
-----------------------------------------

如果查询执行器进程的消耗此配置的数量，则该进程将不会被缓存以备在进程完成后的后续查询中使用。具有大量连接或空闲进程的系统可能希望减少此数量以释放段上的更多内存。请注意，这是一个本地参数，必须为每个段设置。

|值范围|默认|设置分类|
|:---|:---|:---|
|兆字节数|500|local <br> system <br> restart|

gp\_workfile\_checksumming
--------------------------

向 HashAgg 和 HashJoin 查询操作符使用的工作文件（或益出文件）的每个块添加校验和值。这增加了从错误的OS磁盘驱动程序将错误的块写入磁盘的额外保护措施。当校验和操作失败时，查询将取消并回滚，而不是潜在地将数据写入磁盘。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

gp\_workfile\_compress_algorithm
--------------------------------

当查询处理期间散列聚合或散列连接操作溢出到磁盘时，指定要在溢出文件上要使用的压缩算法。如果使用zlib，它必须在所有段的 `$PATH` 中。

如果用户的  HashData 数据库安装使用串行 ATA (SATA) 磁盘驱动器，则将此参数的值设置为 zlib 可能有助于避免IO操作超载磁盘子系统。

|值范围|默认|设置分类|
|:---|:---|:---|
|none <br> zlib|none|master <br> session <br> reload|

gp\_workfile\_limit\_files\_per_query
-------------------------------------

设置每个段每个查询允许的临时溢出文件（也称工作文件）的最大数量。当执行需要比分配内存更多的内存的查询时，会创建溢出文件。当超过限制时，当前查询终止。

将值设置为 0（零）以允许无限数量的溢出文件。主会话重新加载。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|100000|master <br> session <br> reload|

gp\_workfile\_limit\_per\_query
-------------------------------

设置单个查询允许用于在每个段创建临时溢出文件的最大磁盘大小。默认值为0，这意味着不强制执行限制。

|值范围|默认|设置分类|
|:---|:---|:---|
|千字节|0|master <br> session <br> reload|

gp\_workfile\_limit\_per\_segment
---------------------------------

设置允许所有运行查询用于在每个段创建临时溢出文件的最大磁盘大小。默认值为0，这意味着不强制执行限制。

|值范围|默认|设置分类|
|:---|:---|:---|
|千字节|0|local <br> system <br> restart|

gpperfmon_port
--------------

设置所有数据收集代理（对于CommandCenter）与主机通信的端口。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|8888|master <br> system <br> restart|

整数_datetimes
------------

报告 PostgreSQL 是否支持64位整数日期和时间。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|read only|

IntervalStyle
-------------

设置间隔值的显示形式。 _sql_standard_ 值产生输出匹配 SQL 标准间隔字面值。当 [DateStyle](#DateStyle) 参数设置为ISO时， _postgres_ 值产生输出匹配PostgreSQL8.4之前的发行版本。

当 [DateStyle](#DateStyle) 参数设置为 non-ISO 输出时， _postgres_verbose_ 值产生输出匹配  HashData  3.3之前的发行版本。

_iso_8601_ 值产生与ISO 8601第4.4.3.2节中定义的 _format with designators_ 时间间隔相匹配的输出。有关详细信息，请参阅 [PostgreSQL 文档](https://www.postgresql.org/docs/8.4/static/datatype-datetime.html) 。

|值范围|默认|设置分类|
|:---|:---|:---|
|postgres <br> postgres_verbose <br> sql_standard <br> iso_8601|postgres|master <br> session <br> reload|

join\_collapse\_limit
---------------------

每当列表总数不超过这么多项目时，该遗传查询优化器（计划器）将会重写明确的内部 JOIN 结构到 FROM 项目的列表中。 默认的是，这个变量与 _from\_collapse\_limit_ 相同，这适用于大多数用途，将此变量设置为1可防止内部链接重新排序。将此变量设置为1和 _from\_collapse\_limit_ 之间的值可能有助于根据所选计划的质量来衡量计划时间。

|值范围|默认|设置分类|
|:---|:---|:---|
|1- _n_|20|master <br> session <br> reload|

keep\_wal\_segments
-------------------

对于 HashData 数据库主镜像，如果检查点操作发生，则设置由活跃的 HashData 数据库主机保存的最大的WAL段文件数。

段文件用来在备用主机上同步活跃的主机。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|5|master <br> system <br> reload <br> superuser|

krb\_caseins\_users
-------------------

设置Kerberos用户名是否应该被区分大小写。默认值是区分大小写（off状态）。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> system <br> restart|

krb\_server\_keyfile
--------------------

设置 Kerberos 服务器秘钥（key）文件的位置。

|值范围|默认|设置分类|
|:---|:---|:---|
|路径和文件名|unset|master <br> system <br> restart|

krb_srvname
-----------

设置 Kerberos 服务名称。

|值范围|默认|设置分类|
|:---|:---|:---|
|服务名|postgres|master <br> system <br> restart|

lc_collate
----------

报告文本数据排序完成的场所。该值是在 HashData 数据库数组初始化时确定的。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>||read only|

lc_ctype
--------

报告确定字符分类的范围。该值是在 HashData 数据库数组初始化时确定的。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>||read only|

lc_messages
-----------

设置显示消息的语言。可用的范围取决于用户的操作系统安装的内容-使用 _locale -a_ 来列出所有可用的范围。默认值是从服务器执行环境中继承的。在某些系统上，此设置类型不存在。设置此变量仍然有效，但是不会有任何影响。此外，有一个机会没有翻译信息所需语言的存在，这种情况下，用户讲继续看到英文讯息。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>||local <br> system <br> restart|

lc_monetary
-----------

设置用于格式化金额的区域设置（部分，locale），例如使用 _to_char_ 函数系列。可用的区域设置取决于用户安装操作系统的内容 -使用 _locale -a_ 可以列出可用的区域设置。默认值从服务器的执行环境继承。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>||local <br> system <br> restart|

lc_numeric
----------

设置用于格式化数字的区域设置，例如使用 _to_char_ 函数系列。可用的区域设置取决用户的操作系统安装的内容-使用 _locale -a_ 来列出所有可用的区域设置。默认值是从服务器的执行环境继承。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>||local <br> system <br> restart|

lc_time
-------

该参数目前没有什么用，但是将来可能会有用。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>||local <br> system <br> restart|

listen_addresses
----------------

指定服务器要监听客户端程序的TCP/IP地址- 逗号分隔的主机名和，或数字IP地址。特殊的项 * 对应于所有可用的IP接口。如果列表为空，则只能连接UNIX域的套接字。

|值范围|默认|设置分类|
|:---|:---|:---|
|localhost, <br> host names, <br> IP addresses, <br> \* (all available IP interfaces)|\*|master <br> system <br> restart|

local\_preload\_libraries
-------------------------

逗号分隔的共享库文件的列表，该列表将在客户端会话开始时预加载。

|值范围|默认|设置分类|
|:---|:---|:---|
|||local <br> system <br> restart|

log_autostats
-------------

记录有关 [gp\_autostats\_mode](#gp_autostats_mode) 和 [gp\_autostats\_on\_change\_threshold](#gp_autostats_on_change_threshold)的自动 ANALYZE 操作的信息的日志。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload <br> superuser|

log_connections
---------------

这将向服务器日志输出一条详细说明每个成功连接的详细信息。某些客户端程序（向psql）在确定是否需要密码时尝试连接两次，因此重复的”连接接收“消息并不总是指示着问题。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

log_disconnections
------------------

这将在客户端会话终止时在服务器日志中输出一行，并包括会话的持续时间。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

log\_dispatch\_stats
--------------------

当设置为“on”时候，该参数添加一条有关语句发送的详细信息的日志消息。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

log_duration
------------

会导致每个满足 _log_statement_ 的已完成语句的持续时间都会被记录。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload <br> superuser|

log\_error\_verbosity
---------------------

控制记录在每个消息的服务器日志中写入的详细信息量。

|值范围|默认|设置分类|
|:---|:---|:---|
|TERSE <br> DEFAULT <br> VERBOSE|DEFAULT|master <br> session <br> reload <br> superuser|

log\_executor\_stats
--------------------

对于每个查询，将查询执行程序的性能统计信息写入服务器日志。这是一个粗糙的剖析仪器，无法和 _log\_statement\_stats_ 一起使用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

log_hostname
------------

默认情况下，连接日志消息仅显示连接主机和IP地址。打开此选项可以记录 HashData 数据库主机的IP地址和主机名。请注意，根据用户主机名决定设置，这可能会施加一个不可忽视的性能惩罚，无法和 _log\_statement\_stats_ 一起使用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> system <br> restart|

log\_min\_duration_statement
----------------------------

如果其持续时间大于或等于指定的毫秒数，则将该语句及其持续时间记录子单个日志行上。将其设置为0会打印所有语句和它们的持续时间。例如，如果用户设置其为250，然后所有执行时间大于250ms的SQL语句将会记录到日志上。启用该选项可用于在用户的应用中追踪未优化查询。

|值范围|默认|设置分类|
|:---|:---|:---|
|毫秒数, 0, -1|-1|master <br> session <br> reload <br> superuser|

log\_min\_error_statement
-------------------------

控制是否会在服务器日志中记录引发错误情况的SQL的语句。所有导致指定级别或者更高级别错误的SQL语句都被记录。默认值为PANIC（有效的关闭此功能以正常使用）。启用此选项有助于追踪出现在服务器日志中的任何错误的来源。

|值范围|默认|设置分类|
|:---|:---|:---|
|DEBUG5 <br> DEBUG4 <br> DEBUG3 <br> DEBUG2 <br> DEBUG1 <br> INFO <br> NOTICE <br> WARNING <br> ERROR <br> FATAL <br> PANIC|ERROR|master <br> session <br> reload <br> superuser|

log\_min\_messages
------------------

控制那些消息级别写入服务器日志。每个级别包括跟随它（它之后）的所有级别，级别越靠后，发送到日志的消息越少。

|值范围|默认|设置分类|
|:---|:---|:---|
|DEBUG5 <br> DEBUG4 <br> DEBUG3 <br> DEBUG2 <br> DEBUG1 <br> INFO <br> NOTICE <br> WARNING <br> LOG <br> ERROR <br> FATAL <br> PANIC|WARNING|master <br> session <br> reload <br> superuser|

log\_parser\_stats
------------------

对于每个查询，将查询解析器的性能统计信息写入服务器日志。这是一个粗糙的剖析仪器。无法与 _log\_statement\_stats_ 一起使用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload <br> superuser|

log\_planner\_stats
-------------------

对于每个查询，将遗传查询优化器（计划程序）的性能统计信息写入服务器日志。这是一个粗糙的剖析仪器。无法与 _log\_statement\_stats_ 一起使用。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload <br> superuser|

log\_rotation\_age
------------------

确定单个日志文件的最长生命周期，在这段时间之后，将创建一个新的日志文件。设置为0以禁用基于时间的日志文件的创建。

|值范围|默认|设置分类|
|:---|:---|:---|
|任何有效的时间表达式 （数字和单位）|1d|local <br> system <br> restart|

log\_rotation\_size
-------------------

确定单个日志文件的最大大小。这么多千字节被发射到日志文件之后，将创建一个新的日志文件。设置为0以禁用基于大小的新的日志文件的创建。

最大值为 INT\_MAX/1024。如果指定了无效值，则使用默认值。INT\_MAX 是可以作为整数存储在系统上的最大值。

|值范围|默认|设置分类|
|:---|:---|:---|
|千字节数|0|local <br> system <br> restart|

log_statement
-------------

控制记录那些SQL语句。DDL记录所有数据定义命令，如 CREATE，ALTER，和 DROP 命令。MOD记录所有DDL语句，加上 INSERT，UPDATE，DELETE，TRUNCATE和COPY FROM。如果它们包含的命令是适当的类型，则还会记录PREPARE 和 EXPLAIN ANALYZE 语句。

|值范围|默认|设置分类|
|:---|:---|:---|
|NONE <br> DDL <br> MOD <br> ALL|ALL|master <br> session <br> reload <br> superuser|

log\_statement\_stats
---------------------

对于每个查询，将查询解析器，计划程序和执行程序的总体性能统计信息写入服务器日志。这是一个粗糙的剖析仪器。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload <br> superuser|

log_timezone
------------

设置用于记录在日志中的时间戳使用的时区。与 [TimeZone](#TimeZone)不同，该值是系统范围内的，因此所有会话将一致的报告时间戳。默认值是 unknown，这意味着使用系统环境指定的时区作为时区。

|值范围|默认|设置分类|
|:---|:---|:---|
|string|unknown|local <br> system <br> restart|

log\_truncate\_on_rotation
--------------------------

清空（覆盖），而不是附加到任何现有的同名的日志文件。清空将仅在由于基于时间的轮换打开新文件时，才会发生。例如，将此设置与log_filename（例如 gpseg#-%H.log）组合将导致生成二十四小时日志文件，然后循环覆盖他们。关闭时，在所有情况下，将附加在预先存在的文件。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

max\_appendonly\_tables
-----------------------

设置可以写入或更新追加优化表的并发事务的最大数量。超过最大数量的事务将返回错误。

计数的操作是 INSERT，UPDATE， COPY 和 VACUUM 操作。该限制仅限于正在进行的事务。一旦事务结束（终止或者提交），它不再计入此限制。

对于针对分区表的操作，作为追加优化表并被更改的每个子分区（字表）被计为最大值的单个表。例如，分区表 p_tbl 被定义为具有追加优化表 p\_tbl\_ao1，p\_tbl\_ao2，和 p\_tbl\_ao3的三个自分区。针对改变追加优化表 p\_tbl\_ao1 和 p\_tbl\_ao2的分区表p_tbl 的 INSERT 或 UPDATE 命令被计为两个事务。

增加该限制值，将在服务器开始时，在主机上分配更多的共享内存。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|10000|master <br> system <br> restart|

max_connections
---------------

与数据库服务器并发连接的最大数量。在 HashData 数据库系统中，用户客户端仅连通 HashData 主实例。段实例应允许的数量应该是主实例数量的5-10倍。增加此参数时，[max\_prepared\_transactions](#max_prepared_transactions) 也必须要增加。更多关于限制并发连接的信息，参阅_ HashData 数据库管理员指南_的“配置客户端身份验证”。

增加此参数可能会导致 HashData 数据库要求更多的共享内存。有关 HashData 服务器实例共享内存缓存区的信息，请参阅 [shared_buffers](#shared_buffers)。

|值范围|默认|设置分类|
|:---|:---|:---|
|10- _n_|Master上是250  <br> Segment上是750|local <br> system <br> restart|

max\_files\_per_process
-----------------------

设置允许每个服务器子进程同时打开文件的最大数量。如果内核正在执行每个进程的安全限制，则不需要担心此设置。一些平台，例如BSD，内核将允许单个进程打开比系统真正支持的更多文件数目。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|1000|local <br> system <br> restart|

max\_fsm\_pages
---------------

设置在共享空闲内存映射中追踪的可用空间的最大磁盘页数。每个页面槽都占用了6个字节的共享内存。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 16 * _max\_fsm\_relations_|200000|local <br> system <br> restart|

max\_fsm\_relations
-------------------

设置在共享内存空间映射中可追踪空闲空间的最大关系数。应设置为大于总数的值：

表 \+ 索引 \+ 系统表。

对于每个段实例的每个关系，它花费了大约60个字节的内存。最好放大一点空间，设置高一点而不是太低。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|1000|local <br> system <br> restart|

max\_function\_args
-------------------

报告函数参数的最大数目。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|100|read only|

max\_identifier\_length
-----------------------

报告最大标识符长度。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|63|read only|

max\_index\_keys
----------------

报告索引键的最大数目。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|32|read only|

max\_locks\_per_transaction
---------------------------

共享锁表的创建带有描述在 _max\_locks\_per_transaction_ \* (_max_connections_ \+ _max\_prepared\_transactions_) 对象上的锁，所以在一次不能将多于这么多的不同的对象锁住。这不是任何一个事务所占锁数量的硬限制，而是最大平均值。如果客户端在单个事务中涉及多张不同的表，用户可能需要提升该值。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|128|local <br> system <br> restart|

max\_prepared\_transactions
---------------------------

设置能同时处于准备状态的最大事务数。  HashData  在内部使用准备好的事务来确保数据跨段的完整性。该值至少和主机上的 [max_connections](#max_connections) 值一样大。段实例应设置与主机相同的值。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|250 on master <br> 250 on segments|local <br> system <br> restart|

max\_resource\_portals\_per\_transaction
----------------------------------------

设置每个事务允许同时打开用户声明游标的最大数量。请注意，打开的游标将在资源维持一个查询节点。用于工作负载管理。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|64|master <br> system <br> restart|

max\_resource\_queues
---------------------

设置可在 HashData 数据库系统中创建的资源队列的最大数量。请注意，资源队列是系统范围内的（和角色一样），因此他们适用于系统中的所有数据库。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|9|master <br> system <br> restart|

max\_stack\_depth
-----------------

指定服务器栈的最大安全执行深度。此参数的理想设置是内核执行的实际的栈大小限制（由 _ulimit -s_ 或本地等效设置），少于一个兆字节的安全边距。将参数设置为高于实际内核限制将意味着失控的递归函数可能导致单个后端进程崩溃。

|值范围|默认|设置分类|
|:---|:---|:---|
|千字节数|2MB|local <br> system <br> restart|

max\_statement\_mem
-------------------

设置查询的最大内存限制。将 [statement_mem](#statement_mem) 设置得太高，有助于在查询处理期间避免段主机上的内存不足的错误。当 [gp\_resqueue\_memory_policy](#gp_resqueue_memory_policy)=auto时， statement_mem 和 资源队列内存限制了控制查询内存的使用。考虑到单个段主机的配置，计算该设置如下：

(seghost\_physical\_memory) / (average\_number\_concurrent_queries)

|值范围|默认|设置分类|
|:---|:---|:---|
|千字节数|2000MB|master <br> session <br> reload <br> superuser|

optimizer
---------

运行SQL查询时启用或禁用GPORCA。 默认值为 on。如果禁用GPORCA， HashData 数据库仅使用遗传查询优化器。

GPORCA 和遗传查询优化器共存。启用GPORCA后， HashData 数据库使用GPORCA在可能时为查询生成执行计划。如果GPORCA不可用，则使用遗传查询优化器。

可以为数据库系统，单个数据库，会话或查询 optimizer（优化器）参数。

有关遗传查询优化器和GPORCA的信息，请参阅  HashData 数据库管理员指南中的“查询数据”。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

optimizer\_analyze\_root_partition
----------------------------------

对于分区表，当在表上运行 ANALYZE 命令时收集根分区的统计信息。 GPORCA 使用根分区统计信息来生成一个查询计划。而遗传查询优化器并不使用这些数据。如果用户设置服务器配置参数 [optimizer](#optimizer) 的值为on，请将此参数设置为on，并在分区表上运行ANALYZE 或 ANALYZE ROOTPARTITION命令来确保收集到正确的统计信息。

有关遗产查询优化器和GPORCA的信息，请参阅  HashData 数据库管理员指南的“查询数据”。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

optimizer\_array\_expansion_threshold
-------------------------------------

当启用（默认值）GPORCA时候并且正在处理包含具有常量数组的谓词的查询时，该 optimizer\_array\_expansion_threshold 参数将根据数组中的常量数限制优化过程。如果当前查询谓词中的数组包含多于参数指定的数字元素，则GPORCA在查询优化期间禁用将谓词转换为其分离的正常格式。

默认值为25。

例如，当GPORCA正在执行超过25个元素的 IN 子句查询时，GPORCA 在查询优化期间不会将谓词转化为其分离的正常格式，以减少优化时间，消耗更小的内存。查询处理的差异可以在查询EXPLAIN 计划的IN子句的过滤条件中看到。

更改此参数的值会换来更小的优化时间和更少的内存消耗，以及在查询优化期间的约束导出的潜在优势，例如冲突监测和分区消除。

可以为数据库系统，单个数据库，会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Integer > 0|25|master <br> session <br> reload|

optimizer_control
-----------------

控制是否可以使用SET，RESET 命令或  HashData  数据库实用程序 gpconfig更改服务器配置参数优化程序。如果 optimizer_control 参数值为 on，则用户可以设置 optimizer 参数。如果 optimizer_control 参数值为 off，则 optimizer 参数不能被改变。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> system <br> restart <br> superuser|

optimizer\_cte\_inlining_bound
------------------------------

启用GPORCA（默认值）时, 此参数控制对公共表达式（CTE）查询（包含 WHERE 子句的查询）执行的内联量。默认值为“0”禁用内联。

可以为数据库系统，单个数据库或会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Decimal >= 0|0|master <br> session <br> reload|

optimizer\_enable\_master\_only\_queries
----------------------------------------

启用GPORCA（默认值）时，此参数允许GPORCA执行仅在 HashData 数据库主机上运行的目录查询。对于默认值 off，只有遗传查询优化器才能执行仅在 HashData 数据库主机上运行的目录查询。

可以为数据库系统，单个数据库会会话或查询设置该参数。

注意： 启用此参数会降低运行中的短目录查询的性能。为了避免此问题，请仅为会话或查询设置此参数。

有关GPORCA的信息，请参阅  HashData 数据库管理员指南。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

optimizer\_force\_multistage_agg
--------------------------------

对于默认设置，启用GPORCA并且此参数为 true，当生成此类计划备选项时，GPORCA 会选择标量不同的合格聚合的3个阶段聚合计划。当值为 false时，GPORCA 会基于代价作出选择，而不是启发式选择。

可以为数据库系统，单个数据库，会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|true|master <br> session <br> reload|

optimizer\_force\_three\_stage\_scalar_dqa
------------------------------------------

对于默认设置，启用GPORCA并且此参数为 true，当生成此类计划备选方案时，GPORCA 会选择具有多级聚合的计划。当值为false时，GPORCA会基于成本作出选择，而不是启发式选择。

可以为数据库系统，单个数据库，会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|true|master <br> session <br> reload|

optimizer\_join\_order_threshold
--------------------------------

当启用GPORCA（默认值）时，该参数设置连接子节点的最大数量，GPORCA 将使用基于动态编程连接排序算法为该子节点排序。用户可以为单个查询或整个会话设置此值。

|值范围|默认|设置分类|
|:---|:---|:---|
|0 - INT_MAX|10|master <br> session <br> reload|

optimizer\_mdcache\_size
------------------------

设置GPORCA在查询优化期间用于缓存查询元数据（优化数据）的 HashData 数据库主机上的最大内存量。基于内存限制会话。GPORCA 使用默认设置在查询优化期间缓存元数据：启用GPORCA并且 [optimizer\_metadata\_caching](#optimizer_metadata_caching) 为 on。

默认值为 16384 (16MB)。这是通过性能分析确定的最佳值。

用户可以以KB，MB，或GB为单位指定值。默认单位是KB。例如，值16384 为 16384KB。值1GB 等同为 1024MB 或 1048576KB。如果值为0，则缓存大小不收限制。

可以为数据库系统，单个数据库，会话或查询设置此参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Integer >= 0|16384|master <br> session <br> reload|

optimizer\_metadata\_caching
----------------------------

当启用GPORCA（默认值）时，该参数指定在查询优化期间，GPORCA是否在 HashData 数据库主机的内存中缓存查询元数据（优化数据）。 该参数的默认值为 on，启用缓存。该缓存是基于会话的。当会话结束时，如果查询元数据量超过缓存大小，则旧的未使用的元数据将从缓存中释放。

如果该值为 off，GPORCA 在查询优化期间不缓存元数据。

可以为数据库系统，单个数据库，会话或查询设置此参数。

服务器配置参数 [optimizer\_mdcache\_size](#optimizer_mdcache_size) 控制查询元数据缓存的大小。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

optimizer_minidump
------------------

GPORCA 生成 minidump 文件来描述给定查询的优化上下文。文件中的信息不是可以用来方便地调试和排除故障的格式。minidump 文件位于主数据目录下，并使用以下命名格式：

Minidump_date_time.mdp

minidump 文件包含查询相关的信息：

*   目录对象包括GPORCA要求的数据类型，表格，操作符和统计信息。
*   查询的内部表示（DXL）。
*   GPORCA制定的计划的内部表示（DXL）。
*   传递给GPORCA的系统配置信息，如服务器配置参数，成本和统计信息配置，以及段的数量。
*   在优化查询时，生成的错误堆栈跟踪。

将此参数设置为 ALWAYS 会为所有查询生成一个minidump。将此参数设置为ONERROR 以最小化总优化时间。

关于GPORCA的信息，参阅  HashData 数据库管理员指南的“查询数据”。

|值范围|默认|设置分类|
|:---|:---|:---|
|ONERROR <br> ALWAYS|ONERROR|master <br> session <br> reload|

optimizer\_nestloop\_factor
---------------------------

启用GPORCA（默认值）时，该参数控制在查询优化期间应用的嵌套循环连接代价因子，该默认值为 1，指定了默认排序代价因子。该值表示的是从默认因子中减去或者增加的一个比率。例如，2.0 将代价因子设置为默认值的2倍。此外，值 0.5 将代价因子设置为默认值的一半。

可以为数据库系统，单个数据库，会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Decimal > 0|1|master <br> session <br> reload|

optimizer\_parallel\_union
--------------------------

启用GPORCA（默认值）时，optimizer\_parallel\_union 控制对包含 UNION 或 UNION ALL 子句的查询的并行化的数量。

当该值为 off时，默认值GPORCA会生成一个查询计划，其中APPEND(UNION) 操作符的每个子节点与在同一个片段，该片段和APPEND操作符一样。 在查询执行期间，子节点以顺序的方式执行。

当该值是 on，GPORCA 生成一个查询计划，其中再分配移动节点在 APPEND（UNION）操作符之下。在查询优化期间，子节点和父APPEND操作符在不同的片段上，允许APPEND（UNION）操作符的子进程在段实例上并行执行。

可以为数据库系统，单个数据库，会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

optimizer\_print\_missing_stats
-------------------------------

当启用 GPORCA（默认值），该参数控制关于查询缺少统计信息的列的表列信息的显示。默认值为 true，将列信息显示给客户端。当为 false，该信息不回发送到客户端。

信息在查询执行期间显示，或使用 EXPLAIN 或 EXPLAIN ANALYZE 命令显示。

可以为数据库系统，单个数据库会会话设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|true|master <br> session <br> reload|

optimizer\_print\_optimization_stats
------------------------------------

当启用GPORCA（默认值）时，该参数可以启用对查询各种优化阶段的GPORCA查询优化统计信息的日志记录。默认值为 off，不记录优化统计信息。要记录优化统计信息，必须将此参数设置为 on ，并将参数 client\_min\_messages 必须设置为 log。

*   set optimizer\_print\_optimization_stats = on;
*   set client\_min\_messages = 'log';

在查询执行期间或使用 EXPLAIN 或 EXPLAIN ANALYZE 命令记录信息。

可以为数据库系统，单个数据库，会话或查询设置此参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

optimizer\_sort\_factor
-----------------------

当启用GPORCA（默认值）时，optimizer\_sort\_factor 控制在查询优化期间应用于排序操作的代价因子。该默认值为 1 指定了默认排序的代价因子。该值是在默认因子增加或者减少的比率。例如，值 2.0 将成本因子设置为默认值的2倍，值 0.5 将成本因子设置为默认值的一半。

可以为数据库系统，单个数据库，会话或查询设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|Decimal > 0|1|master <br> session <br> reload|

password_encryption
-------------------

当在 CREATE USER 或 ALTER USER 中指定密码而没有写入 ENCRYPTED 或 UNENCRYPTED字段时，该参数决定是否对密码进行加密。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

password\_hash\_algorithm
-------------------------

指定在存储加密的Greeenplum数据库用户密码时使用的加密散列算法。默认的算法是MD5。

有关设置密码散列算法以保护用户密码的信息，请参阅  HashData 数据库管理员指南中的“在 HashData 数据库中保护密码”。

|值范围|默认|设置分类|
|:---|:---|:---|
|MD5 <br> SHA-256|MD5|master <br> session <br> reload <br> superuser|

pgstat\_track\_activity\_query\_size
------------------------------------

设置存储在系统目录视图pg\_stat\_activity中的 current_query列中的查询文本的最大长度限制。最小长度为1024字节。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|1024|local <br> system <br> restart|

pljava_classpath
----------------

冒号（：）分隔的jar文件或包含PL/Java函数所需的jar文件的目录的列表。必须指定jar文件或目录的完整路径，除非 `$GPHOME/lib/postgresql/java` 目录中的jar文件可以省略路径。jar文件必须安装在所有 HashData 主机上的相同位置，并可由 gpadmin 用户读取。

pljava_classpath 参数用于在每个用户会话开始时组合 PL/Java 类路径。会话启动后添加的jar文件不可用于该会话。

如果在 pljava_classpath 完整的jar文件的路径，则将其添加到PL/Java 类路径。当指定了一个目录，该目录包含任何jar文件都会被添加到PL/Java 类路径。搜索不会下降到指定目录的子目录中。如果 pljava_classpath 中包含的jar文件没有路径，则该jar文件必须在 `$GPHOME/lib/postgresql/java` 目录中。

> 注意： 如果有很多目录要搜索，或者有很多的 jar 文件，这将会影响性能。

如果 [pljava\_classpath\_insecure](#pljava_classpath_insecure) 为 false，设置 pljava_classpath 参数需要超级用户权限。当代码由没有超级用户权限的用户执行时，在SQL代码中设置类路径将会失败。该 pljava_classpath 参数必须先前由超级用户或在 postgresql.conf 文件中设置。在 postgresql.conf 文件中改变类路径需要重载 （gpstop -u）。

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> session <br> reload <br> superuser|

pljava\_classpath\_insecure
---------------------------

控制服务器配置参数 [pljava_classpath](#pljava_classpath) 是否可以由用户设置，而无需Geenplum数据库的超级用户权限。当为真 true时，pljava_classpath 可以由常规用户设置。否则，[pljava_classpath](#pljava_classpath) 只能由数据库超级用户设置。 默认值为 false。

警告： 启用此参数给非管理员数据库用户运行未经授权的Java方法可能的风险。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|false|master <br> session <br> restart <br> superuser|

pljava\_statement\_cache_size
-----------------------------

为准备语句设置 JRE MRU（最近常使用的）缓存的大小（KB）。

|值范围|默认|设置分类|
|:---|:---|:---|
|千字节数|10|master <br> system <br> restart <br> superuser|

pljava\_release\_lingering_savepoints
-------------------------------------

如果为真，PL/Java 函数中使用的保留点将在函数退出时释放。如果为 false，则保留点将会被回滚。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|true|master <br> system <br> restart <br> superuser|

pljava_vmoptions
----------------

定义Java VM的启动选项。默认值是空的字符串（“”）。

|值范围|默认|设置分类|
|:---|:---|:---|
|string||master <br> system <br> restart <br> superuser|

port
----

一个 HashData 数据库实例的监听端口。主站和每个段都有自己的端口。必须在 gp\_segment\_configuration 目录中更改 HashData 系统的端口号。用户必须在更改端口号之前关闭用户的 HashData 数据库系统。

|值范围|默认|设置分类|
|:---|:---|:---|
|any valid port number|5432|local <br> system <br> restart|

random\_page\_cost
------------------

设置遗传查询优化器（计划程序）的非连续读取的磁盘页面的成本估计。这是以顺序页面提取的成本的倍数来衡量的。更高的值使得更可能使用顺序扫描，较低的值使得更可能使用索引扫描。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|100|master <br> session <br> reload|

readable\_external\_table_timeout
---------------------------------

当SQL从外部表读取时候，参数值指定当数据停止从外部表返回时， HashData 数据库在取消查询之前等待查询的时间（以秒为单位）。

默认值为 0，指明没有时间限制， HashData 数据库不会取消查询。

如果使用gpfdist的查询运行了很长时间，然后返回错误“间歇性网络连接问题”，则用户可以为readable\_external\_table_timeout指定一个值。如果gpfdist在指定的时间内没有返回任何数据，则 HashData 将取消查询。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 >= 0|0|master <br> system <br> reload|

repl\_catchup\_within_range
---------------------------

对 HashData 数据库主镜像，控制对活跃主机的更新。如果没有由 walsender 处理的WAL段文件的数量超过此值，则 HashData 数据库会更新活跃的主机。

如果段文件的数量没有超过此值，则 HashData 数据库将阻止更新以允许 walsender 处理文件。如果所有的WAL段都被处理了，则更新活跃的主机。

|值范围|默认|设置分类|
|:---|:---|:---|
|0 - 64|1|master <br> system <br> reload <br> superuser|

replication_timeout
-------------------

对 HashData 数据库主机镜像，设置活跃主机上的 walsender 进程等待备用主机上的walreceiver 进程的状态消息的最大时间。如果没有收到信息，walsender 会记录一条错误信息。

[wal\_receiver\_status_interval](#wal_receiver_status_interval) 控制 walreceiver 状态信息之间的间隔。

|值范围|默认|设置分类|
|:---|:---|:---|
|0 - INT_MAX|60000 ms (60 seconds)|master <br> system <br> reload <br> superuser|

regex_flavor
------------

‘扩展’设置可能有助于与 PostgreSQL7.4 之前的版本精确的向后兼容。

|值范围|默认|设置分类|
|:---|:---|:---|
|advanced <br> extended <br> basic|advanced|master <br> session <br> reload|

resource\_cleanup\_gangs\_on\_wait
----------------------------------

如果通过资源队列提交语句，则在资源队列进行锁定之前，请清理任何空闲的查询执行工作进程。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> system <br> restart|

resource\_select\_only
----------------------

设置资源队列管理的查询类型。如果设置为on，则会对 SELECT，SELECT INTO，CREATE TABLE AS SELECT 和 DECLARE CURSOR 进行评估。如果设置为off，则也会对 INSERT，UPDATE 和 DELETE 命令也将被评估。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> system <br> restart

runaway\_detector\_activation_percent
-------------------------------------

设置触发终止查询的 HashData 数据库vmem内存的百分比。如果用 HashData 数据库段的vmem内存的百分比超过了指定的值，那么 HashData 会根据内存的使用情况终止查询，从消耗内存最大量的查询开始。直到被使用的vmem的百分比低于指定的百分比为止，查询才被终止。

使用服务器配置参数 [gp\_vmem\_protect_limit](#gp_vmem_protect_limit)指定活跃的 HashData 数据库段实例的最大vmem值。

例如，如果vmem 内存设置到10GB，并且 runaway\_detector\_activation_percent 为 90（90%），当使用的vmem内存量超过9GB时， HashData 数据库将禁用查询的自动终止。

值为0禁用基于使用vmem百分比的查询。

|值范围|默认|设置分类|
|:---|:---|:---|
|percentage (integer)|90|local <br> system <br> restart|

search_path
-----------

当在没有模式组件的简单名称引用对象时，指定模式被搜索的顺序。当在不同的模式中存在同名的对象，将使用在搜索路径中首先找到的对象。系统目录模式， _pg_catalog_ ，始终被搜索，无论是否在路径中提及。当创建对象没有指定目标模式时，它们会被放在搜索路径的第一个模式中。可以通过SQL函数 _current_schemas()_ 检查搜索路径当前的有效值。 _current_schemas()_ 显示如何解决出现在 _search_path_ 的请求。

|值范围|默认|设置分类|
|:---|:---|:---|
|a comma- separated list of schema names|`$user,public`|master <br> session <br> reload|

seq\_page\_cost
---------------

对于遗传查询优化器（计划器），设置作为一系列顺序提取的一部分的磁盘页面提取的成本估计。

|值范围|默认|设置分类|
|:---|:---|:---|
|浮点|1|master <br> session <br> reload|

server_encoding
---------------

报告数据库编码（字符集）。确定 HashData 数据库数组何时被初始化。通常，客户端只需关心 _client_encoding_ 的值。

|值范围|默认|设置分类|
|:---|:---|:---|
|\<依赖于系统\>|UTF8|read only|

server_version
--------------

报告该 HashData 数据库发行版基于的 PostgreSQL 的版本。

|值范围|默认|设置分类|
|:---|:---|:---|
|string|8.3.23|read only|

server\_version\_num
--------------------

报告该 HashData 数据库发行版基于的PostgreSQL的整数版本。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|80323|read only|

shared_buffers
--------------

设置 HashData 数据库段实例用户共享内存的内存量。此设置必须至少为128KB并且至少16KB倍的 [max_connections](#max_connections)数。

每个 HashData 数据库段实例根据段配置计算并尝试分配一定量的共享内存。 shared_buffers 是共享内存计算的重要部分，但不是全部。当设置 shared_buffers时，操作系统参数 SHMMAX 或 SHMALL 的值可能也需要调整。

操作系统参数 SHMMAX 指定了单个共享内存分配的最大大小。 SHMMAX 的值必须大于此值：

```
 shared_buffers \+ other\_seg\_shmem
```
other\_seg\_shmem 的值是 HashData 数据库共享内存计算的部分，这不是由 shared_buffers 值所负责的。 other\_seg\_shmem 的值将根据段配置而有所不同。

使用默认的 HashData 数据库参数的值， other\_seg\_shmem 的值，对于 HashData 数据库段大约是111MB，而对于主机大约是79MB。

该操作系统参数 SHMALL 指定主机上共享内存的最大数量。SHMALL 必须大于此值：

```
 (num\_instances\_per_host \* ( shared_buffers \+ other\_seg\_shmem )) \+ other\_app\_shared_mem 
```
other\_app\_shared_mem 值是主机上其他应用程序和进程使用的共享内存量。

当共享内存分配出现错误，解决共享内存分配问题的可能方法是增加 SHMMAX 或 SHMALL或 减少 shared_buffers 或 max_connections。

有关参数 SHMMAX 和 SHMALL的 HashData 数据库值的信息，请参考“ HashData 数据库安装指南”。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 16K * _max_connections_|125MB|local <br> system <br> restart|

shared\_preload\_libraries
--------------------------

在服务器启动时预先加载的共享库的逗号分隔列表。 PostgreSQL过程语言可以这样预先加载，通常通过使用语法 `$libdir/plXXX` ，其中 XXX 是 pgsql, perl, tcl, 或 python。通过预先加载库，库首次使用时候，可以避免库启动时间。如果未找到指定的库，则服务器将无法启动。如果未找到指定的库，则服务器将无法启动。

|值范围|默认|设置分类|
|:---|:---|:---|
|||local <br> system <br> restart|

ssl
---

启用 SSL 连接。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> system <br> restart|

ssl_ciphers
-----------

指定允许在安全连接上使用的SSL密码列表。有关支持的密码列表，请参阅openssl手册页。

|值范围|默认|设置分类|
|:---|:---|:---|
|string|ALL|master <br> system <br> restart|

standard\_conforming\_strings
-----------------------------

确定普通字符串文字（‘...’）是否按照SQL标准中的规定字面处理反斜杠。默认值为on。关闭此参数以将字符串文字中的反斜杠视为转义字符而不是字面反斜杠。应用程序可以检查此参数以确定如何处理字符串文字。此参数的存在也可以作为支持转义字符串语法（E‘...’）的指示。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

statement_mem
-------------

为每个查询分配主机内存。使用此参数分配的内存量不能超过 [max\_statement\_mem](#max_statement_mem) 或查询提交的资源队列上的内存限制。当 [gp\_resqueue\_memory_policy](#gp_resqueue_memory_policy) =auto时，statement_mem 和资源队列内存限制了控制查询内存的使用。

如果查询需要额外的内存，则会使用磁盘上的临时溢出文件。

该计算可用于估计各种情况下的合理值。

```
( gp\_vmem\_protect_limitGB * .9 ) / max\_expected\_concurrent_queries

```
将 gp\_vmem\_protect_limit 设置为 8192MB (8GB) 并假设最大40个并发查询和10%的缓冲区。

```
(8GB * .9) / 40 = .18GB = 184MB
```
|值范围|默认|设置分类|
|:---|:---|:---|
|千字节数|128MB|master <br> session <br> reload|

statement_timeout
-----------------

终止任何占据了指定毫秒数量的语句。0为关闭该限制。

|值范围|默认|设置分类|
|:---|:---|:---|
|毫秒数|0|master <br> session <br> reload|

stats\_queue\_level
-------------------

收集数据库活动的资源队列的统计信息。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

superuser\_reserved\_connections
--------------------------------

决定为 HashData 数据库超级用户保留的连接节点的数量。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 < _max_connections_|3|local <br> system <br> restart|

tcp\_keepalives\_count
----------------------

在连接被认为是死亡之前，可能会丢失的Keepalive的数量。0值使用系统默认值。如果不支持 TCP_KEEPCNT，则该参数必须为0。

对于不再主段和镜像段之间的所有连接，请使用此参数。对于主段和镜像段之间的设置，请使用gp\_filerep\_tcp\_keepalives\_count。

|值范围|默认|设置分类|
|:---|:---|:---|
|number of lost keepalives|0|local <br> system <br> restart|

tcp\_keepalives\_idle
---------------------

在空闲连接上发送keepalive之间的秒数。值为0使用系统默认值。如果不支持TCP_KEEPIDLE ，则此参数必须为0。

对于不再主段和镜像段之间的所有连接，请使用此参数。对于主段和镜像段之间的设置，请使用gp\_filerep\_tcp\_keepalives\_idle。

|值范围|默认|设置分类|
|:---|:---|:---|
|秒数|0|local <br> system <br> restart|

tcp\_keepalives\_interval
-------------------------

在重新传输之前等待keepalive响应的秒数。值为0使用系统默认值。如果不支持TCP_KEEPINTVL，该参数必须是0。

对于不在主段和镜像段之间的所有连接，请使用此参数。对于主段和镜像段之间的设置，请使用gp\_filerep\_tcp\_keepalives\_interval。

|值范围|默认|设置分类|
|:---|:---|:---|
|秒数|0|local <br> system <br> restart|

temp_buffers
------------

设置每个数据库会话使用的临时缓冲区的最大数量。这些是仅用于访问临时表的会话本地缓冲区。该设置可以在单个会话中进行更改，但只能在会话首次使用临时表前进行更改。在实际上不需要大量临时缓冲区的会话中设置大值的代价只是每个增量的缓冲区描述符，或大约64字节。但是，如果实际使用了缓冲区，则会消耗额外的8192字节。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数|1024|master <br> session <br> reload|

TimeZone
--------

设置显示和解释时间戳的时区。默认值是使用系统环境指定的时区作为时区。请参阅PostgreSQL 文档的 [Date/Time Keywords](https://www.postgresql.org/docs/8.3/static/datetime-keywords.html)。

|值范围|默认|设置分类|
|:---|:---|:---|
|time zone abbreviation|local|restart|

timezone_abbreviations
----------------------

设置服务器接受日期时间输入的时区缩写集合。默认值为 Default，它是世界上绝大多数地区都应用的集合。Australia 和 India 和为特定安装定义的其他集合。可能的值是存储在 `$GPHOME/share/postgresql/timezonesets/` 中的配置文件的名称。

要将 HashData 数据库配置为使用自定义的时区集合，请将包含时区定义的文件复制到 HashData  Database主节点和分段主机上的 `$GPHOME/share/postgresql/timezonesets/` 目录中。然后将服务器配置参数 timezone_abbreviations 设置到文件中。例如，使用包含默认时区和WIB（Waktu Indonesia Barat）时区的 custom 文件。

1.  拷贝文件 Default 从目录 $GPHOME/share/postgresql/timezonesets/ 到文件 custom中。将 WIB 时区信息从文件 Asia.txt 添加到 custom文件中。
2.  复制 custom 文件到 HashData 数据库主和段主机上的目录 $GPHOME/share/postgresql/timezonesets/ 中。
3.  将服务器配置参数 timezone_abbreviations 设置为 custom。
4.  重新加载服务器配置参数（gpstop -u）。

|值范围|默认|设置分类|
|:---|:---|:---|
|string|Default|master <br> session <br> reload|

track_activities
----------------

启用对每个会话当前执行命令的统计信息的收集以及该命令开始执行的时间。启用后，所有用户都不会看到此信息，该信息只对超级用户和用户该会话的用户可见。该数据可以通过 _pg\_stat\_activity_ 系统视图访问。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|master <br> session <br> reload|

track_counts
------------

启用数据库活动上的行和块级统计数据的收集。如果启用，则可以通过 _pg_stat_ 和 _pg_statio_ 系列视图来访问生成的数据。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|local <br> system <br> restart|

transaction_isolation
---------------------

设置当前的事务的隔离级别。

|值范围|默认|设置分类|
|:---|:---|:---|
|read committed <br> serializable|read committed|master <br> session <br> reload|

transaction\_read\_only
-----------------------

设置当前事务的只读状态。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

transform\_null\_equals
-----------------------

当为on时，表单表达式 expr = NULL（或 NULL = expr）被视为expr IS NULL，也就是说如果expr 计算为控制，则返回为true，否则返回为false。expr = NULL 的正确的SQL规范兼容行为是始终返回null（未知）。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

unix\_socket\_directory
-----------------------

指定服务器上侦听来自客户端应用程序的连接的UNIX-域的套接字的目录。

|值范围|默认|设置分类|
|:---|:---|:---|
|目录路径|unset|local <br> system <br> restart|

unix\_socket\_group
-------------------

设置UNIX-域套接字的所属组。默认情况下是一个空字符串，该默认值使用当前用户的默认组。

|值范围|默认|设置分类|
|:---|:---|:---|
|UNIX组名|unset|local <br> system <br> restart|

unix\_socket\_permissions
-------------------------

设置UNIX-域套接字的访问权限。UNIX-域套接字使用通常的UNIX文件系统的权限集合。请注意，对于UNIX-域套接字，只有写入权限才是最重要的。

|值范围|默认|设置分类|
|:---|:---|:---|
|数字形式的UNIX文件权限模式（ _chmod_ 或者 _umask_ 命令接受的形式）|511|local <br> system <br> restart|

update\_process\_title
----------------------

每当服务器接收到新的SQL命令时，都可以更新进程的标题。进程标题通常由 ps 命令查看。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|on|local <br> system <br> restart|

vacuum\_cost\_delay
-------------------

当超过代价限制时候，进程休眠的时间长度。0禁用基于时间的清理延迟功能。

|值范围|默认|设置分类|
|:---|:---|:---|
|milliseconds < 0 (in multiples of 10)|0|local <br> system <br> restart|

vacuum\_cost\_limit
-------------------

积累的代价值，该代价会导致清理进程的休眠。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|200|local <br> system <br> restart|

vacuum\_cost\_page_dirty
------------------------

当修改一个之前是干净的块时所估计的代价。它表示将脏块再次刷新到磁盘所需的额外I/O。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|20|local <br> system <br> restart|

vacuum\_cost\_page_hit
----------------------

基于共享缓存的缓冲区清理的估计代价。它代表锁定缓冲池，查找共享哈希表并扫描页面的内存的代价。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|1|local <br> system <br> restart|

vacuum\_cost\_page_miss
-----------------------

清理必须从磁盘读取的缓冲区的估计代价。该代表了锁定缓冲池，查找共享哈希表，从磁盘读取所需块并扫描其内容的代价。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 \> 0|10|local <br> system <br> restart|

vacuum\_freeze\_min_age
-----------------------

指定事务中的截止年龄，当扫描表的时候，VACUUM 应该使用该年龄来决定是否使用 _FrozenXID_ 替代事务ID。

有关 VACUUM 和事务ID管理的信息，请参阅  HashData 数据库管理员指南 的“管理数据”和 [PostgreSQL 文档](https://www.postgresql.org/docs/8.3/static/routine-vacuuming.html#VACUUM-FOR-WRAPAROUND)。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 0-100000000000|100000000|local <br> system <br> restart|

validate\_previous\_free_tid
----------------------------

启用验证空闲元组ID（TID）列表的测试。该列表由 HashData 数据库维护和使用。 HashData 数据库通过确保当前空闲元组的先前空闲TID是有效的空闲元组来确定TID列表的有效性。默认值为 true，启用该测试。

如果 HashData 数据库监测到空闲TID列表中的损害，则重建免费TID列表，记录警告，并且检查失败的查询返回警告。 HashData 数据库尝试执行查询。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|true|master <br> session <br> reload|

vmem\_process\_interrupt
------------------------

在数据库查询执行期间，可以在为查询预留vmem内存之前检查中断。在为查询预留更多的vmem之前，请检查查询的当前会话是否有待处理的查询取消或其他挂起的中断。这确保了更多的响应中断处理，包括查询取消请求。默认值是off。

|值范围|默认|设置分类|
|:---|:---|:---|
|Boolean|off|master <br> session <br> reload|

wal\_receiver\_status_interval
------------------------------

对于 HashData 数据库主镜像，请设置发送到活跃主机的 walreceiver 进程状态信息之间的间隔。在重型负载下，该值可能会更长。

该 [replication_timeout](#replication_timeout) 值控制了 walsender 进程 walreceiver 等待接收信息的时间。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 0- INT_MAX/1000|10 sec|master <br> system <br> reload <br> superuser|

writable\_external\_table_bufsize
---------------------------------

 HashData 数据库用于网络通信的缓冲区大小（以KB为单位），例如 gpfdist 实用程序和外部web表（实用http）。 HashData 数据库在数据库数据写出之前将数据存储在缓冲区中。有关 gpfdist的信息，请参阅  HashData 数据库使用指南。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 32 - 131072 (32KB - 128MB)|64|local <br> system <br> reload|

xid\_stop\_limit
----------------

发生事务ID环绕的ID之前的事务ID数。达到此限制时， HashData 数九将停止创建新事务，以避免由于事务ID环绕而导致的数据丢失。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 10000000 - 2000000000|1000000000|local <br> system <br> restart|

xid\_warn\_limit
----------------

在[xid\_stop\_limit](#xid_stop_limit)指定的限制之前的事务ID数量。当 HashData 数据库达到此限制时，他会发出警告以执行VACUUM操作，来避免由于事务ID环绕而导致的数据丢失。

|值范围|默认|设置分类|
|:---|:---|:---|
|整数 10000000 - 2000000000|500000000|local <br> system <br> restart|

xmlbinary
---------

指定二进制值如何在XML数据中编码。例如，当 bytea 值转化为XML值时。该二进制数据可以转换为base64编码或者十六进制编码。默认值是base64。

可以为数据库系统，单个数据库或会话设置该参数。

|值范围|默认|设置分类|
|:---|:---|:---|
|base64 <br> hex|base64|master <br> session <br> reload|

xmloption
---------

指定是否将XML数据视为执行隐式解析和序列化的操作的XML文档（document）或者 XML 内容片段（content）。默认值为 content。

此参数影响 xml\_is\_well_formed()执行的验证。如果值为 document，则该函数检查格式良好的XML文档。如果值为 content，则该函数将检查格式良好的XML内容片段。

注意： 包含文档类型声明（DTD）的XML文档不被视为有效的XML内容片段。如果将 xmloption 设置为 content， 则包含DTD的XML不被视为有效的XML。

。要将包含DTD的字符换转化为 xml 数据类型，请将 xmlparse 函数和 document 关键字一起使用，或将 xmloption 值改为 document。

可以为数据库系统，单个数据库或会话设置参数。设置此选项的SQL命令也可以在 HashData 数据库中使用。

```
SET XML OPTION { DOCUMENT | CONTENT }
```
|值范围|默认|设置分类|
|:---|:---|:---|
|document <br> content|content|master <br> session <br> reload|