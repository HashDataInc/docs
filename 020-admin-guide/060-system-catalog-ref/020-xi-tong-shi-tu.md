# 系统视图

HashData 数据库提供以下系统视图，它们在PostgreSQL中不可用。

* [gp\_distributed\_log](./030-system-catalog-define/gpdistributed-log.md)
* [gp\_distributed\_xacts](./030-system-catalog-define/gpdistributed-xacts.md)
* [gp\_pgdatabase](./030-system-catalog-define/gppgdatabase.md)
* [gp\_resqueue\_status](./030-system-catalog-define/gpresqueue-status.md)
* [gp\_transaction\_log](./030-system-catalog-define/gptransaction-log.md)
* [gpexpand.expansion\_progress](./030-system-catalog-define/gpexpandexpansionprogress.md)
* [pg\_max\_external\_files](./030-system-catalog-define/pgmax-external-files.md)
* [pg\_partition\_columns](./030-system-catalog-define/pgpartition-columns.md)
* [pg\_partition\_templates](./030-system-catalog-define/pgpartition-templates.md)
* [pg\_partitions](./030-system-catalog-define/pgpartitions.md)
* [pg\_resqueue\_attributes](./030-system-catalog-define/pgresqueue-attributes.md)
* pg\_resqueue\_status（已弃用，请使用[gp\_toolkit.gp\_resqueue\_status](./030-system-catalog-define/gpresqueue-status.md)）
* [pg\_stat\_activity](./030-system-catalog-define/pgstat-activity.md)
* [pg\_stat\_replication](./030-system-catalog-define/pgstat-replication.md)
* [pg\_stat\_resqueues](./030-system-catalog-define/pgstat-resqueues.md)
* session\_level\_memory\_consumption（见 HashData 数据库管理员指南中的“查看会话内存使用信息”）

有关PostgreSQL和 HashData 数据库支持的标准系统视图的更多信息，请参阅 PostgreSQL 文档的以下部分：

* [系统视图](https://www.postgresql.org/docs/8.3/static/views-overview.html)
* [统计收集器视图](https://www.postgresql.org/docs/8.3/static/monitoring-stats.html#MONITORING-STATS-VIEWS-TABLE)
* [信息方案](https://www.postgresql.org/docs/8.3/static/information-schema.html)

**上级主题：** [系统目录参考](./README.md)

