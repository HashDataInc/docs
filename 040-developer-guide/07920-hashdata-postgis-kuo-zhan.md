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

### 利用插件本地导入GIS数据

GIS数据分为栅格和矢量两种格式。可以利用Postgis插件工具（raster2pgsql、shp2pgsql）将本地GIS数据转为sql文件，再将sql文件导入到数据库中。

#### 导入矢量数据格式

矢量数据导入按照以下格式构建。

```
shp2pgsql [<options>] <shapefile> [[<schema>.]<table>]
```

示例

把**/data/shapefile/enc.shp**文件转换成sql文件，public.table_shapefile是要创建的表名称。load.sql是转换的sql文件。

```
shp2pgsql /data/shapefile/enc.shp public.table_shapefile > load.sql
```

执行SQL文件导入数据库。

#### 导入栅格数据格式

栅格数据导入按照以下格式构建。

```
raster2pgsql [<options>] <raster>[ <raster>[...]] [[<schema>.]<table>]
```

示例

把**/data/raster/input.tif** 文件按照20x20瓦片大小切分，public.table_raster是要创建的表名称。load.sql是转换的sql文件。

**-F**：增加一列为raster文件的文件名。

**-t**：按照 num x num的瓦片进行大小切分。

```
raster2pgsql -F -t 20x20 /data/raster/input.tif public.table_raster > load.sql
```

执行SQL文件导入数据库。

### 创建外部表导入GIS和NETCDF等数据格式

HashData 可以通过外部表导入GIS和NETCDF等数据格式。GIS数据分为栅格和矢量两种格式，您可以按如下所示构建外部表。

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
tile_size
```

**resource_URI** 资源url路径，必须以 "**oss://**"作为开始。

**isvirtual** 资源url是**virtual-host-style**格式**isvirtual**字段为**true**，否则默认为**false**。

**layer** 创建外部表格式为**SHAPEFILE**时使用，layer 表示外部表导入的矢量图层。

**subdataset** 创建外部表格式为**NETCDF**时使用，subdataset 表示外部表导入的子数据集。

**tile_size** 创建外部表格式为**RASTER**时使用，tile_size 表示对栅格数据分片的大小。

#### 导入栅格数据格式

由于有些TIFF文件像素很大无法直接导入到数据库中，这里会对栅格数据分片处理。tile_size 是设置切分数据的大小，如果在oss_parameters中没有设置其大小默认按照512x512处理。切分数据分片最大值不能大于10000x10000，如果大于按照最大值10000来进行分片处理。

这里提供一个简单示例。

```sql
--Import Gis raster data to table:
CREATE READABLE EXTERNAL TABLE osstbl_example(filename text, rast raster, metadata text) LOCATION('oss://ossext-example.sh1a.qingstor.com/raster tile_size=100x100 oss_type=QS access_key_id=xxx secret_access_key=xxx') FORMAT 'raster';

SELECT filename, st_value(rast, 3, 4) from osstbl_example order by filename;

--Results of the raster
-- filename列说明
-- icg/gis/raster/test_input.tiff 是对象存储的文件路径。
-- tilenum 是当前切分的第几个瓦片。
-- xtile 表示坐标系x第几个瓦片。
-- ytile 表示坐标系y第几个瓦片。
-- tile_size 是当前切片大小。
                                  filename                                   |     st_value
-----------------------------------------------------------------------------+------------------
 icg/gis/raster/test_input.tiff tilenum:0 xtile:0 ytile:0 tile_size:100x100  | 260.100006103516
 icg/gis/raster/test_input.tiff tilenum:1 xtile:1 ytile:0 tile_size:100x100  | 252.389999389648
 icg/gis/raster/test_input.tiff tilenum:2 xtile:2 ytile:0 tile_size:100x100  | 255.429992675781
 icg/gis/raster/test_input.tiff tilenum:3 xtile:3 ytile:0 tile_size:100x100  | 288.690002441406
 icg/gis/raster/test_input.tiff tilenum:4 xtile:1 ytile:1 tile_size:100x100  | 280.169982910156
 icg/gis/raster/test_input.tiff tilenum:5 xtile:2 ytile:1 tile_size:100x100  |  284.72998046875
 icg/gis/raster/test_input.tiff tilenum:6 xtile:3 ytile:1 tile_size:100x100  | 301.100006103516
 icg/gis/raster/test_input.tiff tilenum:7 xtile:1 ytile:2 tile_size:100x100  | 297.639984130859
 icg/gis/raster/test_input.tiff tilenum:8 xtile:2 ytile:2 tile_size:100x100  | 301.940002441406
 icg/gis/raster/test_output.tiff tilenum:0 xtile:0 ytile:0 tile_size:100x100 | 260.100006103516
 icg/gis/raster/test_output.tiff tilenum:1 xtile:1 ytile:0 tile_size:100x100 | 252.389999389648
 icg/gis/raster/test_output.tiff tilenum:2 xtile:2 ytile:0 tile_size:100x100 | 255.429992675781
 icg/gis/raster/test_output.tiff tilenum:3 xtile:3 ytile:0 tile_size:100x100 | 288.690002441406
 icg/gis/raster/test_output.tiff tilenum:4 xtile:1 ytile:1 tile_size:100x100 | 280.169982910156
 icg/gis/raster/test_output.tiff tilenum:5 xtile:2 ytile:1 tile_size:100x100 |  284.72998046875
 icg/gis/raster/test_output.tiff tilenum:6 xtile:3 ytile:1 tile_size:100x100 | 301.100006103516
 icg/gis/raster/test_output.tiff tilenum:7 xtile:1 ytile:2 tile_size:100x100 | 297.639984130859
 icg/gis/raster/test_output.tiff tilenum:8 xtile:2 ytile:2 tile_size:100x100 | 301.940002441406
```



#### 导入矢量数据格式

查看矢量数据详细信息: 创建SQL函数Ogr_Fdw_Info并执行该方法，创建成功后用户可获取shapefile建表SQL语句。

```sql
--Create SQL Function:
CREATE OR REPLACE FUNCTION ogr_fdw_info(text) returns setof record as '$libdir/gpossext.so', 'Ogr_Fdw_Info'  LANGUAGE C STRICT;

select * from ogr_fdw_info('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS') AS tbl(name text, sqlq text);

--Results of the ogr_fdw_info SQL function
   name   |                                                                                               sqlq
----------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 2launder | CREATE READABLE EXTERNAL TABLE shp_2launder (
          :   fid bigint,
          :   geom Geometry(Point,4326),
          :   n2ame varchar OPTIONS (column_name 2ame),
          :   age integer,
          :   height real,
          :   b_rthdate date OPTIONS (column_name b-rthdate)
          : )
          : LOCATION ('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=2launder')
          :  FORMAT 'Shapefile';
          :
 enc      | CREATE READABLE EXTERNAL TABLE shp_enc (
          :   fid bigint,
          :   geom Geometry(Point,4326),
          :   name varchar,
          :   age integer,
          :   height real,
          :   birthdate date
          : )
          : LOCATION ('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=enc')
          :  FORMAT 'Shapefile';
          :
 pt_two   | CREATE READABLE EXTERNAL TABLE shp_pt_two (
          :   fid bigint,
          :   geom Geometry(Point,4326),
          :   name varchar,
          :   age integer,
          :   height real,
          :   birthdate date
          : )
          : LOCATION ('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=pt_two')
          :  FORMAT 'Shapefile';
          :
 natural  | CREATE READABLE EXTERNAL TABLE shp_natural (
          :   fid bigint,
          :   id real,
          :   natural varchar
          : )
          : LOCATION ('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=natural')
          :  FORMAT 'Shapefile';
          :
(4 rows)
```

导入数据: 创建外部表格式选择Shapefile格式。用户填写layer字段选择图层，创建成功后用户可执行查询语句查看。

```sql
--Create shapefile table:
create readable external table shp_2launder (fid bigint, geom Geometry(Point,4326), name varchar, age integer, height real, birthdate date) location('oss://ossext-example.sh1a.qingstor.com/shape access_key_id=xxx secret_access_key=xxx oss_type=QS layer=2launder') format 'Shapefile';

SELECT * FROM shp_2launder;

--Results of the shapefile
 fid |                        geom                        | name  | age | height | birthdate
-----+----------------------------------------------------+-------+-----+--------+------------
   0 | 0101000020E6100000C00497D1162CB93F8CBAEF08A080E63F | Peter |  45 |    5.6 | 04-12-1965
   1 | 0101000020E610000054E943ACD697E2BFC0895EE54A46CF3F | Paul  |  33 |   5.84 | 03-25-1971
(2 rows)

```

#### 导入NETCDF数据格式

查看子数据集: NETCDF数据具有多个子数据集。用户需要创建SQL函数查看子数据集。创建SQL函数nc_subdataset_info并执行该方法，创建成功后用户可执行查询语句查看子数据集。

```sql
--Create SQL Function:
CREATE OR REPLACE FUNCTION nc_subdataset_info(text) returns setof record as  '$libdir/gpossext.so', 'nc_subdataset_info' LANGUAGE C STRICT;

select * from nc_subdataset_info ('oss://ossext-example.sh1a.qingstor.com/netcdf/input.nc access_key_id=xxx secret_access_key=xxx oss_type=QS ') AS tbl(name text, sqlq text);

--Results of the netcdf SQL Function
          name           |                                      sqlq
-------------------------+--------------------------------------------------------------------------------
 icg/gis/netcdf/input.nc | SUBDATASET_1_NAME=NETCDF:"/vsiossext/netcdf/input.nc":TMP_P0_L103_GLL0
                         : SUBDATASET_1_DESC=[1x205x253] TMP_P0_L103_GLL0 (32-bit floating-point)
                         : SUBDATASET_2_NAME=NETCDF:"/vsiossext/netcdf/input.nc":initial_time0
                         : SUBDATASET_2_DESC=[1x18] initial_time0 (8-bit character)
                         :
```

导入数据: 创建外部表为NETCDF格式，用户填写subdataset字段选择子数据集。创建成功后用户可执行查询语句查看。

```sql
--Create netcdf table:
CREATE READABLE EXTERNAL TABLE osstbl_netcdf(filename text, rast raster, metadata text) LOCATION('oss://ossext-example.sh1a.qingstor.com/netcdf/input.nc subdataset=1 access_key_id=xxx secret_access_key=xxx oss_type=QS') FORMAT 'netcdf';

SELECT filename, st_value(rast, 3, 4) from osstbl_netcdf order by filename;

--Results of the netcdf
    filename     |     st_value
-----------------+------------------
 netcdf/input.nc | 260.100006103516
(1 row)
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

