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

### 创建外部表导入栅格、 矢量、netcdf 等格式数据

HashData 可以通过外部表导入栅格、矢量和netcdf等数据格式。您可以按如下所示构建外部表。

```sql
CREATE [ READABLE | WRITABLE ] EXTERNAL TABLE table_name ( [
  { column_name data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
    | table_constraint
    | LIKE source_table [ like_option ... ] }
] ) LOCATION (oss_parameters) FORMAT '[ CSV | TEXT | ORC | RASTER | SHAPEFILE | NETCDF]';

where oss_parameters are:
resource_URI
oss_type
access_key_id
secret_access_key
cos_appid
isvirtual
layer
subdataset
```

##### resource_URI

资源url路径，必须以 "**oss://**"作为开始。

oss各个云平台url常见的有两种格式**virtual-host-style** 和 **path-host-style**。以下以青云举例子。

virtual-host-style：oss://<bucketName>.<zone>.qingstor.com/<objectPath>

path-host-style：oss://<zone>.qingstor.com/<bucketName>/<objectPath>

在使用中推荐使用path-host-style格式。以下是各云平台path-host-style格式：

**QingStor**: oss://<zone>.qingstor.com/<bucketName>/<objectPath>

**Tencent COS**: oss://cos.<zone>.myqcloud.com/<bucketNameWithAppid>/<objectPath>

**Ali OSS**: oss://<zone>.aliyuncs.com/<bucketName>/<objectPath>

**S3**: oss://s3.<zone>.amazonaws.com.cn/<bucketName>/<objectPath>

**KS3**: oss://<zone>.ksyun.com/<bucketName>/<objectPath>

##### oss_type

各个oss云的平台。目前支持云平台有：

**Qingstor** (青云): QS 

**Tencent COS ** (腾讯云): COS

**Ali OSS **(阿里云): ALi 

**S3** (亚马逊云): S3B 

**KS3** (金山云):KS3 

##### access_key_id

可选参数：oss云的公共密钥，如果是公有云可以不提供，否则必须提供。

##### secret_access_key

可选参数：oss云的私有密钥，如果是公有云可以不提供，否则必须提供。

##### cos_appid

可选参数：腾讯云使用的appid。

##### isvirtual

可选参数：该字段只会应用于私有部署的情况。如果当前你的resource_URI 是一个私有部署(私有部署指你的url是类似ip格式“oss://192.168.0.0” 或者 “oss://www.test.com”格式，不具备oss各个云平台通用url格式情况。oss各个通用url参考resource_URI 字段) 你必须设置isvirtual这个字段。如果你使用的是**virtual-host-style** 的url格式，该字段必须设置成为true。如果你使用的是  **path-host-style**的url格式，该字段需要设置成false。当然这个字段默认是false。

##### layer

可选字段：该字段只会应用在格式是**SHAPEFILE**情况下。layer表示当前外部表要导入矢量图层的名称。

##### subdataset

可选字段：该字段只会应用在格式是**NETCDF**情况下。subdataset 表示外部表导入那个子数据集。

#### 导入栅格数据格式

外部表导入栅格数据格式。这里提供一个简单示例。

```sql
--Import Gis raster data to table:
CREATE READABLE EXTERNAL TABLE osstbl_example(filename text, rast raster, metadata text) LOCATION('oss://ossext-example.sh1a.qingstor.com/raster oss_type=QS access_key_id=xxx secret_access_key=xxx') FORMAT 'raster';
```

#### 导入矢量数据格式

由于矢量数据带有多个图层信息，首先需要用户创建function展示当前bucket下面全部的图层信息。这里使用ogr_fdw_info方法创建。执行select用户可以查看当前bucket下面全部图层信息。在用户获取需要图层名称后，创建外部表格式选择Shapefile格式。用户填写layer字段选择要导入图层名称，创建成功后执行select语句就可以通过外部表导入矢量数据了。

以下示例展示外部表导入矢量数据的方法：

```sql
--Create layer Function:
CREATE OR REPLACE FUNCTION ogr_fdw_info(text) returns setof record as '$libdir/gpossext.so', 'Ogr_Fdw_Info'  LANGUAGE C STRICT;

--Display layer name from oss cloud:
select * from ogr_fdw_info('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS') AS tbl(name text, sqlq text);

--Create shapefile table:
create readable external table launder (fid bigint, geom Geometry(Point,4326), name varchar, age integer, height real, birthdate date) location('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=2launder') format 'Shapefile';
```

#### 导入netcdf数据格式

由于netcdf数据具有多个子数据集。首先要通过创建function显示用户当前文件中有哪些子数据集。这里使用nc_subdataset_info方法创建function，执行select显示子数据集。当用户获取到子数据集后，创建netcdf格式的外部表，用户填写subdataset选择子数据集。创建成功后执行select语句就可以通过外部表导入netcdf的数据了。

以下示例展示外部表导入netcdf的方法：

```sql
--Display subdataset.
CREATE OR REPLACE FUNCTION nc_subdataset_info(text) returns setof record as  '$libdir/gpossext.so', 'nc_subdataset_info' LANGUAGE C STRICT;

select * from nc_subdataset_info ('oss://ossext-example.sh1a.qingstor.com/netcdf/input.nc access_key_id=xxx secret_access_key=xxx oss_type=QS ') AS tbl(name text, sqlq text);

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

