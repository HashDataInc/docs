# pg_am

pg_am 表存储有关索引访问方法的信息。系统所支持的每一种索引访问方法都有一行。

##### 表 1\. pg\_catalog.pg\_am

|列|类型|引用|描述|
|:---|:---|:---|:---|
|amname|name||访问方法的名称
|amstrategies|int2||此访问方法的操作符策略数量
|amsupport|int2||此访问方法的支持例程数量
|amorderstrategy|int2||如果索引不提供排序顺序，则为零。否则是描述排序顺序的策略操作符的策略编号
|amcanunique|boolean||访问方法是否支持唯一索引？
|amcanmulticol|boolean||访问方法是否支持多列索引？
|amoptionalkey|boolean||访问方法是否支持对第一个索引列没有任何约束的扫描？
|amindexnulls|boolean||访问方法是否支持空索引条目？
|amstorage|boolean||索引存储数据类型能否与列数据类型不同？
|amclusterable|boolean||能否以这种类型的索引作聚簇？
|aminsert|regproc|pg_proc.oid|“插入此元组”函数
|ambeginscan|regproc|pg_proc.oid|“开始新扫描”函数
|amgettuple|regproc|pg_proc.oid|“下一个有效的元组”函数
|amgetmulti|regproc|pg_proc.oid|“获取多个元组”函数
|amrescan|regproc|pg_proc.oid|“重新启动扫描”函数
|amendscan|regproc|pg_proc.oid|“结束扫描”函数
|ammarkpos|regproc|pg_proc.oid|“标记当前扫描位置”函数
|amrestrpos|regproc|pg_proc.oid|“恢复已标记扫描位置”函数
|ambuild|regproc|pg_proc.oid|“建立新的索引”函数
|ambulkdelete|regproc|pg_proc.oid|批量删除函数
|amvacuumcleanup|regproc|pg_proc.oid|后-VACUUM清理函数
|amcostestimate|regproc|pg_proc.oid|估计索引扫描代价的函数
|amoptions|regproc|pg_proc.oid|为索引解析和验证reloptions的函数

**上级主题：** [系统目录定义](./README.md)