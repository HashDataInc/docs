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

HashData 数据库内置了 PostGIS 扩展。

* HashData 数据库内置支持的 PostGIS 版本是 2.1.5。

查看 PostGIS 文档以获取更改列表：[http://postgis.net/docs/manual-2.0/release_notes.html](http://postgis.net/docs/manual-2.0/release_notes.html)

> 警告：PostGIS 2.0 删除了许多弃用的功能，但在 PostGIS 1.4 中可用。使用 PostGIS 1.4 中弃用的函数编写的函数和应用程序可能需要重写。请参阅 PostGIS 文档以获取新功能，增强功能或更改功能的列表：[http://postgis.net/docs/manual-2.0/PostGIS_Special_Functions_Index.html#NewFunctions](http://postgis.net/docs/manual-2.0/PostGIS_Special_Functions_Index.html#NewFunctions)

### HashData 数据库 PostGIS 限制

HashData 数据库 PostGIS 扩展不支持以下功能：

* 拓扑
* 少量用户定义的函数和聚合
* PostGIS 长事务支持

有关 HashData 数据库 PostGIS 支持的信息，请参阅 [PostGIS 扩展支持和限制](#topic5)。

## <h2 id='topic3'> 启用 PostGIS 支持

默认情况下，HashData 数据库启动的时候已经安装 PostGIS 扩展包了。如果没有默认安装的话，则可以通过如下方式为需要使用的每个数据库启用 PostGIS 支持。要启用支持，请在目标数据库中运行随 PostGIS 软件包一起提供的以下SQL 脚本：postgis.sql、  postgis_comments.sql、rtpostgis.sql 和 raster_comments.sql。

例如：

```
psql -d mydatabase -f ${GPHOME}/share/postgresql/contrib/postgis-2.1/postgis.sql
psql -d mydatabase -f ${GPHOME}/share/postgresql/contrib/postgis-2.1/postgis_comments.sql
psql -d mydatabase -f ${GPHOME}/share/postgresql/contrib/postgis-2.1/rtpostgis.sql
psql -d mydatabase -f ${GPHOME}/share/postgresql/contrib/postgis-2.1/raster_comments.sql
```

您的数据库现在可以使用 PostGIS 扩展了。


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

以下示例 SQL 语句将创建一个表，并使用引用 SPATIAL\_REF\_SYS 表中的记录的 SRID 整数值向表中添加几何类型的列。该 INSERT 语句添加到表中的地址。

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

HashData 提供对 GiST 空间索引的支持。即使在大型物体上，GiST 方案也提供索引。它使用有损索引系统，其中较小的对象充当索引中较大对象的代表。在 PostGIS 索引系统中，所有对象都使用边界框作为索引中的代表。

#### 建立空间索引

您可以按如下所示构建 GiST 索引：

```
CREATE INDEX indexname
ON tablename
USING GIST ( geometryfield );
```

### 创建外部表导入栅格、 矢量、netcdf 等数据格式

HashData 可以通过外部表导入栅格、矢量和netcdf等数据格式。您可以按如下所示构建外部表。

```sql
CREATE [ READABLE | WRITABLE ] EXTERNAL TABLE table_name ( [
  { column_name data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
    | table_constraint
    | LIKE source_table [ like_option ... ] }
] ) LOCATION (oss_parameters) FORMAT '[ CSV | TEXT | ORC | RASTER | SHAPEFILE | NETCDF]';
```

oss_parameters 参数描述：

```sql
resource_URI
oss_type={QS|KS3|S3|S3B|ALI|COS}
access_key_id
secret_access_key
isvirtual={true|false}
layer
subdataset
```

**resource_URI** 资源url路径，必须以 "**oss://**"作为开始。

**isvirtual** 资源url是**virtual-host-style**格式**isvirtual**字段为**true**，否则为**false**。

**layer** 创建外部表格式为**SHAPEFILE**时使用，layer 表示外部表导入的矢量图层。

**subdataset** 创建外部表格式为**NETCDF**时使用，subdataset 表示外部表导入的子数据集。

#### 导入栅格数据格式

外部表导入栅格数据格式，这里提供一个简单示例。

```sql
--Import Gis raster data to table:
CREATE READABLE EXTERNAL TABLE osstbl_example(filename text, rast raster, metadata text) LOCATION('oss://ossext-example.sh1a.qingstor.com/raster oss_type=QS access_key_id=xxx secret_access_key=xxx') FORMAT 'raster';
```

#### 导入矢量数据格式

**查看矢量数据**

矢量数据带有多个图层信息，用户需要创建SQL函数查看矢量数据的图层信息。创建SQL函数Ogr_Fdw_Info并执行该方法，创建成功后用户可执行查询语句查看矢量数据的图层信息。

```sql
--Create SQL Function:
CREATE OR REPLACE FUNCTION ogr_fdw_info(text) returns setof record as '$libdir/gpossext.so', 'Ogr_Fdw_Info'  LANGUAGE C STRICT;

select * from ogr_fdw_info('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS') AS tbl(name text, sqlq text);
```

**创建外部表导入矢量数据**

创建外部表格式选择Shapefile格式。填写layer字段选择要导入的图层，创建成功后用户可执行查询语句查看。

```sql
--Create shapefile table:
create readable external table launder (fid bigint, geom Geometry(Point,4326), name varchar, age integer, height real, birthdate date) location('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=2launder') format 'Shapefile';
```

#### 导入netcdf数据格式

**查看netcdf子数据集**

netcdf数据具有多个子数据集。用户需要创建SQL函数查看子数据集。创建SQL函数nc_subdataset_info并执行该方法，创建成功后用户可执行查询语句查看子数据集。

```sql
--Create SQL Function:
CREATE OR REPLACE FUNCTION nc_subdataset_info(text) returns setof record as  '$libdir/gpossext.so', 'nc_subdataset_info' LANGUAGE C STRICT;

select * from nc_subdataset_info ('oss://ossext-example.sh1a.qingstor.com/netcdf/input.nc access_key_id=xxx secret_access_key=xxx oss_type=QS ') AS tbl(name text, sqlq text);
```

**创建外部表导入netcdf数据**

创建外部表为netcdf格式，用户填写subdataset选择子数据集。创建成功后用户可执行查询语句查看。

```sql
--Create netcdf table:
CREATE READABLE EXTERNAL TABLE osstbl_netcdf(filename text, rast raster, metadata text) LOCATION('oss://ossext-example.sh1a.qingstor.com/netcdf/input.nc subdataset=1 access_key_id=xxx secret_access_key=xxx oss_type=QS') FORMAT 'netcdf';
```

## <h2 id='topic5'> PostGIS 扩展支持和限制

本节介绍 HashData PostGIS 扩展功能支持和限制。

* [支持的 PostGIS 数据类型](#topic3_1)
* [支持的 PostGIS 索引](#topic3_2)
* [PostGIS 扩展限制](#topic3_3)

HashData 数据库 PostGIS 扩展不支持以下功能：

* 拓扑

### <h3 id='topic3_1'> 支持的 PostGIS 数据类型

HashData 数据库 PostGIS 扩展支持以下 PostGIS 数据类型：

* Box2D
* Box3D
* 几何
* 地理
* 球体
* 栅格

### <h3 id='topic3_2'> 支持的 PostGIS 索引

HashData 数据库 PostGIS 扩展支持 GiST（广义搜索树）索引。

### <h3 id='topic3_3'> PostGIS 扩展限制

本节列出了用户定义函数（ UDF ），数据类型和聚合的 HashData 数据库 PostGIS 扩展限制。

* HashData 数据库不支持与 PostGIS 拓扑功能相关的数据类型和功能，例如: TopoGeometry 。
* ST\_Estimated\_Extent 函数不支持。该功能需要用于 HashData 数据库不可用的用户定义数据类型的表列统计信息。
* HashData 数据库不支持这些 PostGIS 聚合：
  
  * ST\_MemCollect
  * ST\_MakeLine

  在具有多个分段的 HashData 数据库中，如果聚合重复多次调用，聚合可能会返回不同的答案。

* HashData 数据库不支持 PostGIS 长事务。

  PostGIS 依赖触发器和 PostGIS 表 _public.authorization\_table_ 来支持长事务。当 PostGIS 尝试获取长事务的锁定时，HashData 数据库会报告错误，指出该函数无法访问关系 _authorization\_table_ 。

