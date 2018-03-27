# pg_namespace

pg_namespace 系统目录表存储命名空间。命名空间是 SQL 模式的底层结构：每个命名空间都可以具有单独的没有命名冲突的关系、类型等集合。

##### 表 1\. pg\_catalog.pg\_namespace

|列|类型|参考|描述|
|:---|:---|:---|:---|
|nspname|name||命名空间的名字
|nspowner|oid|pg_authid.oid|命名空间的所有者
|nspacl|aclitem\[\]||由GRANT和REVOKE给予的访问特权。

**上级主题：** [系统目录定义](./README.md)