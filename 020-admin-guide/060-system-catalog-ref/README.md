# 系统目录参考

该参考文献描述了 HashData 数据库系统目录表和视图。以 `gp_` 为前缀的系统表与 HashData 数据库的并行特性有关。 以 `pg_` 为前缀的表是 HashData 数据库中支持的标准 PostgreSQL 系统目录表， 或与 HashData 数据库性能有关，以提升 PostgreSQL 的数据仓库工作负载。请注意，HashData 数据库的全局系统目录位于主实例上。

> 警告:不支持对 HashData 数据库系统目录表或视图的更改。如果更改目录表或视图，则必须重新初始化并还原集群

* [**系统表**](./010-xi-tong-biao.md)

* [**系统视图**](./020-xi-tong-shi-tu.md)

* [**系统目录定义**](./030-system-catalog-define/README.md)


