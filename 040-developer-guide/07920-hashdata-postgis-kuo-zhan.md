# PostGIS 扩展

本章包含以下信息：

* [关于 PostGIS](#topic1)
* [HashData PostGIS 扩展](#topic2)
* [启用 PostGIS 支持](#topic3)
* [用法](#topic4)
* [PostGIS 扩展支持和限制](#topic5)

**父主题：**[HashData 数据库参考指南](./README.md)

## <h2 id='topic1'> 关于 PostGIS

PostGIS 是 PostgreSQL 的空间数据库扩展，允许 GIS（地理信息系统）对象存储在数据库中。HashData 数据库 PostGIS 扩展包括对基于 GiST 的 R-Tree 空间索引和用于分析和处理 GIS 对象的功能的支持。

有关 PostGIS 的更多信息，请转到 [http://postgis.refractions.net/](http://postgis.refractions.net/)。

有关 HashData 数据库 PostGIS 扩展支持的信息，请参阅 [PostGIS 扩展支持和限制](#topic5)。

## <h2 id='topic2'> HashData PostGIS 扩展

HashData 数据库 PostGIS 扩展可从 [Pivotal Network 获得](https://network.pivotal.io/)。您可以使用 HashData Package Manager 进行安装（gppkg）。

* HashData 数据库支持 PostGIS 扩展包 2.0 版（PostGIS 2.0.3）。要在 HashData 数据库中使用扩展包，必须安装和使用 HashData 数据库扩展包（ gppkg 文件和 contrib 模块）。

查看 PostGIS 文档以获取更改列表：[http://postgis.net/docs/manual-2.0/release_notes.html](http://postgis.net/docs/manual-2.0/release_notes.html)

> 警告：PostGIS 2.0 删除了许多弃用的功能，但在 PostGIS 1.4 中可用。使用 PostGIS 1.4 中弃用的函数编写的函数和应用程序可能需要重写。请参阅 PostGIS 文档以获取新功能，增强功能或更改功能的列表：[http://postgis.net/docs/manual-2.0/PostGIS_Special_Functions_Index.html#NewFunctions](http://postgis.net/docs/manual-2.0/PostGIS_Special_Functions_Index.html#NewFunctions)

### HashData 数据库 PostGIS 限制

HashData 数据库 PostGIS 扩展不支持以下功能：

* 拓扑
* 光栅
* 少量用户定义的函数和聚合
* PostGIS 长事务支持
* 几何和地理类型修饰符

有关 HashData 数据库 PostGIS 支持的信息，请参阅 [PostGIS 扩展支持和限制](#topic5)。

## <h2 id='topic3'> 启用 PostGIS 支持

安装 PostGIS 扩展包后，为需要使用的每个数据库启用 PostGIS 支持。要启用支持，请在目标数据库中运行随 PostGIS 软件包一起提供的启用 SQL 脚本。

对于 PostGIS ，您运行两个 SQL 脚本 postgis.sql 和 spatial\_ref\_sys.sql 在您的目标数据库中。

例如：

```
psql -d mydatabase -f 
  $GPHOME/share/postgresql/contrib/postgis-2.0/postgis.sql
psql -d mydatabase -f 
  $GPHOME/share/postgresql/contrib/postgis-2.0/spatial_ref_sys.sql
```

> 注意：spatial\_ref\_sys.sql 填充 spatial\_ref\_sys 带有 EPSG 坐标系定义标识符的表。如果您已覆盖标准条目并想要使用这些覆盖，请不要在创建新数据库时加载 spatial\_ref\_sys.sql 文件。

您的数据库现在在空间上启用了。


## <h2 id='topic4'> 用法

以下示例 SQL 语句创建非 OpenGIS 表和几何。

```
CREATE TABLE geom_test ( gid int4, geom geometry, 
  name varchar(25) );
INSERT INTO geom_test ( gid, geom, name )
  VALUES ( 1, 'POLYGON((0 0 0,0 5 0,5 5 0,5 0 0,0 0 0))', '3D Square');
INSERT INTO geom_test ( gid, geom, name ) 
  VALUES ( 2, 'LINESTRING(1 1 1,5 5 5,7 7 5)', '3D Line' );
INSERT INTO geom_test ( gid, geom, name )
  VALUES ( 3, 'MULTIPOINT(3 4,8 9)', '2D Aggregate Point' );
SELECT * from geom_test WHERE geom &&
  Box3D(ST_GeomFromEWKT('LINESTRING(2 2 0, 3 3 0)'));
```

以下示例 SQL 语句将创建一个表，并使用引用 SPATIAL\_REF\_SYS 表中的条目的 SRID 整数值向表中添加几何列。该 INSERT 语句添加到表中的地址。

```
CREATE TABLE geotest (id INT4, name VARCHAR(32) );
SELECT AddGeometryColumn('geotest','geopoint', 4326,'POINT',2);
INSERT INTO geotest (id, name, geopoint)
  VALUES (1, 'Olympia', ST_GeometryFromText('POINT(-122.90 46.97)', 4326));
INSERT INTO geotest (id, name, geopoint)|
  VALUES (2, 'Renton', ST_GeometryFromText('POINT(-122.22 47.50)', 4326));
SELECT name,ST_AsText(geopoint) FROM geotest;
```

### 空间索引

PostgreSQL 提供对 GiST 空间索引的支持。即使在大型物体上，GiST 方案也提供索引。它使用有损索引系统，其中较小的对象充当索引中较大对象的代理。在 PostGIS 索引系统中，所有对象都使用边界框作为索引中的代理。

#### 建立空间索引

您可以按如下所示构建 GiST 索引：

```
CREATE INDEX indexname
ON tablename
USING GIST ( geometryfield );
```

## <h2 id='topic5'> PostGIS 扩展支持和限制

本节介绍 HashData PostGIS 扩展功能支持和限制。

* [支持的 PostGIS 数据类型](#topic3_1)
* [支持的 PostGIS 索引](#topic3_2)
* [PostGIS 扩展限制](#topic3_3)

HashData 数据库 PostGIS 扩展不支持以下功能：

* 拓扑
* 光栅

### <h3 id='topic3_1'> 支持的 PostGIS 数据类型

HashData 数据库 PostGIS 扩展支持以下 PostGIS 数据类型：

* Box2D的
* box3d
* 几何
* 地理
* 球体

### <h3 id='topic3_2'> 支持的 PostGIS 索引

HashData 数据库 PostGIS 扩展支持 GiST（广义搜索树）索引。

### <h3 id='topic3_3'> PostGIS 扩展限制

本节列出了用户定义函数（ UDF ），数据类型和聚合的 HashData 数据库 PostGIS 扩展限制。

* HashData 数据库不支持与 PostGIS 拓扑或栅格功能相关的数据类型和功能，例如: TopoGeometry 和 ST\_AsRaster 。
* ST\_Estimated\_Extent 函数不受支持。该功能需要用于 HashData 数据库不可用的用户定义数据类型的表列统计信息。
* 不支持 ST\_GeomFromGeoJSON 函数。该功能需要 JSON 支持。HashData 数据库支持 JSON。
* HashData 数据库不支持这些 PostGIS 聚合：
  
  * ST\_MemCollect
  * ST\_MakeLine

  在具有多个分段的 HashData 数据库中，如果聚合重复多次调用，聚合可能会返回不同的答案。

* HashData 数据库不支持 PostGIS 长事务。

  PostGIS 依赖触发器和 PostGIS 表 _public.authorization\_table_ 来支持长事务。当 PostGIS 尝试获取长事务的锁定时，HashData 数据库会报告错误，指出该函数无法访问关系 _authorization\_table_ 。

* HashData 数据库不支持用户定义类型的类型修饰符。解决方法是使用 AddGeometryColumn 函数用于 PostGIS 几何。例如，无法使用以下 SQL 命令创建具有 PostGIS 几何的表：
  
  ```
  CREATE TABLE geometry（id INTEGER，geom geometry（LINESTRING））;
  ```

  使用 AddGeometryColumn 函数将 PostGIS 几何添加到表中。例如，以下 SQL 语句将创建一个表并将 PostGIS 几何添加到表中：
  
  ```
  CREATE TABLE geometry（id INTEGER）;
  SELECT AddGeometryColumn（'public'，'geometries'，'geom'，0，'LINESTRING'，2）;
  ```



