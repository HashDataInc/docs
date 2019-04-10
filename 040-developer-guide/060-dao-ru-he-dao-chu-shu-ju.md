# 导入导出数据

本节的主题是描述如何高效地往 HashData 数据仓库导入数据和从 HashData 数据仓库往外导出数据，以及如何格式化导入的文件格式。

HashData 数据仓库支持高效地并发导入和导出数据功能，利用各云平台的对象存储，可以与不同系统更加简单地进行数据交换操作。

通过使用外部表，HashData 数据仓库让您能够通过 SQL 命令在数据库内直接利用并行机制访问外部数据资源，例如：SELECT，JOIN，ORDER BY 或者在外部表上创建视图。 外部表一般用来将外部数据导入到数据库内部普通表，例如：

```sql
CREATE TABLE table AS SELECT * FROM ext_table;
```
## 通过外部表访问对象存储

CREATE EXTERNAL TABLE 可以创建可读外部表。外部表允许 HashData 数据仓库将外部数据源当作数据库普通表来进行处理。

### 使用对象存储

HashData 数据仓库目前支持多种不同的对象存储服务平台，包括青云、腾讯云、阿里云、亚马逊S3、金山云等，同时也支持兼容S3协议的私有部署。

通过在外部表的 LOCATION 子句，您可以指定对象存储的位置和访问键值。这样，在每次使用 SQL 命令读取外部表时，HashData 数据仓库会将对象存储中该目录下的所有数据文件读取到数据库中进行处理。 如果您需要多次处理该数据，建议您通过 `CREATE TABE table AS SELECT * FROM ext_table` 的方式，将对象存储的数据导入到 HashData 数据仓库的内置表。这样可以更好的利用优化过的存储结构来优化您的数据分析流程。

您可以通过如下的语法来定义访问对象存储上面数据的外部表：

```sql
CREATE READABLE EXTERNAL TABLE table_name ( [
  { column_name data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
    | table_constraint
    | LIKE source_table [ like_option ... ] }
] ) LOCATION (oss_parameters) FORMAT '[ CSV | TEXT | ORC ]';
```
其中 oss_parameters 由以下部分组成：

- resource_URI ：对象存储中数据文件位置，必填，以"**oss://**"开始，推荐用户使用各对象存储云平台的路径URI模式，创建读外部表时，URI可以指向文件目录或者单个文件。

- oss_type ：对象存储平台，必填，不区分大小写。
  - 青云: QS
  - 腾讯云: COS
  - 阿里云: ALI
  - 亚马逊S3: S3B
  - 金山云: KS3

- access_key_id ：对象存储平台密钥ID，如果访问具有公开读取权限的数据可不填。

- secret_access_key ： 对象存储平台密钥，如果访问具有公开读取权限的数据可不填。

- cos_appid ： 仅在使用腾讯云时需要填入的appid。

- isvirtual ： 默认值为false，仅当使用兼容S3协议的私有部署，且使用virtual-host-style的URI路径时需要将其指定为true。

#### 青云导入CSV格式数据

在下面的示例中，我们将向您展示如何从青云对象存储中直接读取 1GB 规模 TPCH 测试数据的例子，数据文件为CSV格式。我们提供的此份数据为公开读取权限， 故不用填写key信息。

```sql
CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL,
                       N_NAME       CHAR(25) NOT NULL,
                       N_REGIONKEY  INTEGER NOT NULL,
                       N_COMMENT    VARCHAR(152));
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/nation/ oss_type=qs')
FORMAT 'csv';

CREATE TABLE REGION  ( R_REGIONKEY  INTEGER NOT NULL,
                       R_NAME       CHAR(25) NOT NULL,
                       R_COMMENT    VARCHAR(152));
CREATE READABLE EXTERNAL TABLE e_REGION (LIKE REGION) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/region/ oss_type=qs') 
FORMAT 'csv';

CREATE TABLE PART  ( P_PARTKEY     INTEGER NOT NULL,
                     P_NAME        VARCHAR(55) NOT NULL,
                     P_MFGR        CHAR(25) NOT NULL,
                     P_BRAND       CHAR(10) NOT NULL,
                     P_TYPE        VARCHAR(25) NOT NULL,
                     P_SIZE        INTEGER NOT NULL,
                     P_CONTAINER   CHAR(10) NOT NULL,
                     P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                     P_COMMENT     VARCHAR(23) NOT NULL );
CREATE READABLE EXTERNAL TABLE e_PART (LIKE PART) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/part/ oss_type=qs') 
FORMAT 'csv';

CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER NOT NULL,
                        S_NAME        CHAR(25) NOT NULL,
                        S_ADDRESS     VARCHAR(40) NOT NULL,
                        S_NATIONKEY   INTEGER NOT NULL,
                        S_PHONE       CHAR(15) NOT NULL,
                        S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                        S_COMMENT     VARCHAR(101) NOT NULL);
CREATE READABLE EXTERNAL TABLE e_SUPPLIER (LIKE SUPPLIER) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/supplier/ oss_type=qs') 
FORMAT 'csv';

CREATE TABLE PARTSUPP ( PS_PARTKEY     INTEGER NOT NULL,
                        PS_SUPPKEY     INTEGER NOT NULL,
                        PS_AVAILQTY    INTEGER NOT NULL,
                        PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                        PS_COMMENT     VARCHAR(199) NOT NULL );
CREATE READABLE EXTERNAL TABLE e_PARTSUPP (LIKE PARTSUPP) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/partsupp/ oss_type=qs') 
FORMAT 'csv';

CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER NOT NULL,
                        C_NAME        VARCHAR(25) NOT NULL,
                        C_ADDRESS     VARCHAR(40) NOT NULL,
                        C_NATIONKEY   INTEGER NOT NULL,
                        C_PHONE       CHAR(15) NOT NULL,
                        C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                        C_MKTSEGMENT  CHAR(10) NOT NULL,
                        C_COMMENT     VARCHAR(117) NOT NULL);
CREATE READABLE EXTERNAL TABLE e_CUSTOMER (LIKE CUSTOMER) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/customer/ oss_type=qs') 
FORMAT 'csv';

CREATE TABLE ORDERS ( O_ORDERKEY       INT8 NOT NULL,
                      O_CUSTKEY        INTEGER NOT NULL,
                      O_ORDERSTATUS    CHAR(1) NOT NULL,
                      O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                      O_ORDERDATE      DATE NOT NULL,
                      O_ORDERPRIORITY  CHAR(15) NOT NULL,
                      O_CLERK          CHAR(15) NOT NULL,
                      O_SHIPPRIORITY   INTEGER NOT NULL,
                      O_COMMENT        VARCHAR(79) NOT NULL);
CREATE READABLE EXTERNAL TABLE e_ORDERS (LIKE ORDERS) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/orders/ oss_type=qs') 
FORMAT 'csv';

CREATE TABLE LINEITEM ( L_ORDERKEY    INT8 NOT NULL,
                        L_PARTKEY     INTEGER NOT NULL,
                        L_SUPPKEY     INTEGER NOT NULL,
                        L_LINENUMBER  INTEGER NOT NULL,
                        L_QUANTITY    DECIMAL(15,2) NOT NULL,
                        L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                        L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                        L_TAX         DECIMAL(15,2) NOT NULL,
                        L_RETURNFLAG  CHAR(1) NOT NULL,
                        L_LINESTATUS  CHAR(1) NOT NULL,
                        L_SHIPDATE    DATE NOT NULL,
                        L_COMMITDATE  DATE NOT NULL,
                        L_RECEIPTDATE DATE NOT NULL,
                        L_SHIPINSTRUCT CHAR(25) NOT NULL,
                        L_SHIPMODE     CHAR(10) NOT NULL,
                        L_COMMENT      VARCHAR(44) NOT NULL);
CREATE READABLE EXTERNAL TABLE e_LINEITEM (LIKE LINEITEM) 
LOCATION ('oss://hashdata-public.pek3a.qingstor.com/tpch/1g/lineitem/ oss_type=qs') 
FORMAT 'csv';
```
#### 青云导入ORC格式数据

示例数据为公开读取权限，您不需要提供key信息。

```sql
CREATE READABLE EXTERNAL TABLE e_STOCK (DATE CHAR(15),
                                        OPEN_PRICE FLOAT,
                                        HIGH_PRICE FLOAT,
                                        LOW_PRICE FLOAT,
                                        CLOSE_PRICE FLOAT,
                                        VOLUME INT,
                                        ADJ_PRICE FLOAT)
LOCATION ('oss://ossext-orc-example.pek3b.qingstor.com/orc oss_type=qs') FORMAT 'orc';
SELECT COUNT(*) FROM e_STOCK;
```

#### 其他云平台示例
##### 腾讯云

```sql
--Import data from ORC files:
CREATE READABLE EXTERNAL table xxx (xxx) LOCATION('oss://ossext-example-1255522018.cos.ap-beijing.myqcloud.com/orc oss_type=COS cos_appid=1255522018 access_key_id=xxx secret_access_key=xxx') FORMAT 'orc';

--Import csv format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://ossext-example-1255522018.cos.ap-beijing.myqcloud.com/readable/nation oss_type=COS cos_appid=1255522018 access_key_id=xxx secret_access_key=xxx') FORMAT 'csv';

--Import text format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://ossext-example-1255522018.cos.ap-beijing.myqcloud.com/readable/nation oss_type=COS cos_appid=1255522018 access_key_id=xxx secret_access_key=xxx') FORMAT 'text';
```
##### 阿里云

```sql
--Import data from ORC files:
CREATE READABLE EXTERNAL table xxx (xxx) LOCATION('oss://ossext-example.oss-cn-beijing.aliyuncs.com/orc oss_type=ali access_key_id=xxx secret_access_key=xxx') FORMAT 'orc';

--Import csv format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://ossext-example.oss-cn-beijing.aliyuncs.com/readable/nation oss_type=ali access_key_id=xxx secret_access_key=xxx') FORMAT 'csv';

--Import text format data from uncompressed files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://ossext-example.oss-cn-beijing.aliyuncs.com/readable/nation oss_type=ali access_key_id=xxx secret_access_key=xxx') FORMAT 'text';
```
##### 亚马逊S3

```sql
--Import data from ORC files:
CREATE READABLE EXTERNAL table xxx (xxx) LOCATION('oss://s3.cn-north-1.amazonaws.com.cn/ossext-example/orc oss_type=S3B access_key_id=xxx secret_access_key=xxx') FORMAT 'orc';

--Import csv format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://s3.cn-north-1.amazonaws.com.cn/ossext-example/readable/nation oss_type=S3B access_key_id=xxx secret_access_key=xxx') FORMAT 'csv';

--Import text format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://s3.cn-north-1.amazonaws.com.cn/ossext-example/readable/nation oss_type=S3B access_key_id=xxx secret_access_key=xxx') FORMAT 'text';
```

##### 金山云

```sql
--Import data from ORC files:
CREATE READABLE EXTERNAL table xxx (xxx) location('oss://ossext-example.ks3-cn-beijing.ksyun.com/orc oss_type=KS3 access_key_id=xxx secret_access_key=xxx') FORMAT 'orc';

--Import csv format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://ossext-example.ks3-cn-beijing.ksyun.com/readable/nation oss_type=KS3 access_key_id=xxx secret_access_key=xxx') FORMAT 'csv';

--Import text format data from files/file:
CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION) LOCATION ('oss://ossext-example.ks3-cn-beijing.ksyun.com/readable/nation oss_type=KS3 access_key_id=xxx secret_access_key=xxx') FORMAT 'text';
```

## 处理错误

可读外部表最常用于将数据导入到数据库内置表中。您可以通过使用 CREATE TABLE AS SELECT 或 INSERT INTO 命令从外部表读取数据。默认情况下，如果数据中包含格式错误的行，整个命令都会失败，数据不会被成功地加载到目标的数据表中。

SEGMENT REJECT LIMIT 子句允许您将外部表中格式错误的数据进行隔离，继续导入格式正确的数据。使用 SEGMENT REJECT LIMIT 命令设定一个阈值，用 ROWS 指定拒绝的错误记录行数（默认），或者 PERCENT 指定拒绝的错误记录百分比（1-100）。

如果错误的行数到达 SEGMENT REJECT LIMIT 指定的值，整个外部表操作将会终止。错误行数的限制是根据每个加载节点单独计算的。加载操作将会正常处理格式正确的记录，如果错误的记录数没有超过 SEGMENT REJECT LIMIT，跳过格式错误的记录，并将其保存在错误记录中。

LOG ERRORS 子句允许您保留错误记录信息，在命令执行后进一步排查问题。要了解 LOG ERRORS 子句的使用方法，请参考 CREATE EXTERNAL TABLE 命令。

当你使用了 SEGMENT REJECT LIMIT 子句，HashData 数据仓库将会在单行错误隔离模式下扫描外部数据。单行错误隔离模式将会为外部数据记录附加额外的格式错误信息，例如：不一致的列值，错误的列数据类型，非法的客户端编码序列。HashData 数据仓库不会进行约束错误检查，但是您可以通过在使用 SELECT 命令处理外部表时，增加必要的过滤限制条件。例如，下面的例子可以消除重复键值的错误：

```
=# INSERT INTO table_with_pkeys
   SELECT DISTINCT * FROM external_table;
```

> 注意：当使用外部表加载数据时，服务器配置参数 `gp_initial_bad_row_limit` 用来限制在最开始处理时，最多多少行不能遇到错误记录。默认设置为如果在前 1000 行中遇到错误记录，就会停止后续处理。

### 定义使用单行错误隔离的外部表

下面的例子将会将错误记录保存在 HashData 数据仓库内部，并且设置错误阈值为 10 条记录：

```
=# CREATE EXTERNAL TABLE ext_expenses ( name text,
   date date,  amount float4, category text, desc1 text )
   LOCATION ('oss://hashdata-public.pek3a.qingstor.com/ext_expenses/ access_key_id=<access-key-id> secret_access_key=<secret-access-key> oss_type=qs')
   FORMAT 'TEXT' (DELIMITER '|')
   LOG ERRORS SEGMENT REJECT LIMIT 10 ROWS;
```

通过使用内置 SQL 函数 `gp_read_error_log(‘external_table’)` 可以读取错误记录数据。下面的示例命令可以显示 `ext_expenses` 的错误记录：

```
SELECT gp_read_error_log('ext_expenses');
```
要了解更多关于错误记录信息，请参考在错误日志中查看错误记录。

内置 SQL 函数 `gp_truncate_error_log(‘external_table’)` 可以删除错误记录。下面的例子用来删除之前访问外部表时记录的错误数据：

```
SELECT gp_truncate_error_log('ext_expenses');
```
### 捕获记录格式错误和声明拒绝错误记录限制

下面的 SQL 语句片段用来在 HashData 数据仓库中捕获格式错误，并声明最多拒绝 10 条错误记录的限制。

```
LOG ERRORS SEGMENT REJECT LIMIT 10 ROWS
```
### 在错误日志中查看错误记录

如果您使用单行错误隔离模式（参考 定义使用单行错误隔离的外部表），格式错误的记录信息将会被记录在数据库内部。

通过使用内置 SQL 函数 `gp_read_error_log(‘external_table’)` 可以读取错误记录数据。下面的示例命令可以显示 `ext_expenses` 的错误记录：

```
SELECT gp_read_error_log('ext_expenses');
```
## 优化数据加载和查询性能

下面的小建议可以帮助您优化数据加载和加载后的查询性能。

如果您向已经存在的数据表加载数据，可以考虑先删除索引（如果该表已经建了索引的话）。在数据上重新创建索引的速度远远快于在已有索引上逐行插入的性能。您还可以临时地增加 maintenance\_work\_mem 服务器参数来优化 CREATE INDEX 命令的创建参数（该参数可能影响数据库加载性能）。建议您在系统没有活跃操作时删除和重新创建索引。

如果您向新的数据表加载数据，请在数据加载完毕后再创建索引。推荐的步骤是：创建表，加载数据，创建必要的索引。

数据加载完毕后，运行 ANALYZE 命令。如果您操作影响的数据非常多，建议运行 ANALYZE 或者 VACUUM ANALYZE 命令来更新系统的统计信息，这样优化器可以利用最新的信息，更好的优化查询。最新的统计信息能够对查询进行更加精确的优化，从而避免由于统计信息不准确或者不可用时，导致查询性能非常差。

在数据加载出错后，运行 VACUUM 命令。如果数据加载操作没有使用错误记录隔离模式，加载操作将在遇到的第一个错误处停止。这时已经加载的数据虽然不会被访问到，但是他们已经占用了磁盘上的存储空间。请运行 VACUUM 命令来回收这些浪费的空间。

合理使用表分区技术可以简化数据的维护工作。

## 从 HashData 数据仓库导出数据

通过使用可写外部表，您可以将 HashData 数据仓库中的数据表导出成外部通用文件格式。通过可写外部数据表，您可以简单的实现多系统互联。未来，HashData 数据仓库还会支持更多导出功能，让您能够轻松的利用不同数据处理平台，来优化您的数据处理体验。

本章节向您介绍如何利用可写外部表将数据库内部数据导出到外部存储。

### 使用对象存储

HashData 数据仓库充分考虑云平台优势，因此提供利用高效的对象存储来作为数据导出目的地。HashData 数据仓库将会利用其自身并行的架构将数据并行写入到对象存储。

创建可写外部表的语法与可读外部表的类似，唯一的区别在于可读外部表为CREATE READABLE EXTERNAL，可写外部表为CREATE WRITABLE EXTERNAL TABLE。另外resource_URI为目录路径，如果不存在将被创建。

## 格式化数据文件

在使用对象存储来进行数据的导入导出时，需要您指定数据的格式信息。CREATE EXTERNAL TABLE 允许您描述数据的存储格式。数据可以是使用特定分隔符的文本文件或者逗号分隔值的 CSV 格式。只有格式正确的数据才能被 HashData 数据仓库正确读取。本小结向您介绍 HashData 数据仓库期望的数据文件格式。

### 数据行的格式

HashData 数据仓库期望数据行使用 LF 字符（Line feed，0x0A），CR（Carriage return，0x0D），或者 CR 和 LF（CR+LF，0x0D 0x0A）。LF 是 UNIX 或类 UNIX 操作系统上标准的换行符。像 Windows 或者 Mac OS X 使用 CR 或 CR+LF。HashData 数据仓库能够支持前面提到的三种换行的表示形式。

### 数据列的格式

对于文本文件和 CSV 文件来说，默认的列分隔符分别是 TAB 字符（0x09）和逗号（0x2C）。您也可以通过 CREATE EXTERNAL TABLE 语句的 DELIMITER 子句为数据文件指定一个字符作为分隔符。分隔符字符需要在两个数据字段之间使用。每行的开头和结尾不需要指定分隔符。下面的示例是一个使用（|）字符的示例输入：

```
data value 1|data value 2|data value 3
```
下面的示例语句介绍如何在语句中指定（|）作为分隔符：

```
=# CREATE EXTERNAL TABLE ext_table (name text, date date)
LOCATION ('oss://<your-bucket-name>.pek3a.qingstor.com/filename.txt access_key_id=<access-key-id> secret_access_key=<secret-access-key> oss_type=qs')
FORMAT 'TEXT' (DELIMITER '|');
```
### 在数据中表示空值
数据库中的空值（NULL）表示列值未知。在您提供的数据文件中，可以指定一个字符串来表示空值。对于文本文件来说，默认的字符串是 N，对于 CSV 文件来说，使用没有双引号保护的空值。您还可以在 CREATE EXTERNAL TABLE 的 NULL 子句中指定其他的字符串来表示空值。例如，如果您不需要区分空值和空字符串的话，可以使用空字符串来表示空值。在数据加载时，任何数据值和指定的空值字符串相同时，就会被解释为空值。

### 转义

在 HashData 数据仓库中有两个保留字符具有特殊含义：

* 被用来在数据文件中作为列的分隔符的字符。
* 被用来在数据文件中作为换行的字符。

如果您提供的数据中包含上面的字符，需要将该字符进行转义，这样 HashData 数据仓库就会将其解释为数据，而不会解释为列分隔符或换行。默认情况下，文本文件的转义字符是 （反斜线），CSV 文件是 “（双引号）。

#### 文本文件中的转义操作
默认情况下，文本格式文件的转义字符是 （反斜线）。您可以在 CREATE EXTERNAL TABLE 的 ESCAPE 语句中指定其他的转义字符。如果您的数据中包含了转义字符本身，可以使用转义字符来转义它自己。

让我们来看一下例子，假设您有一张包含三个列的表，您希望将下面三列作为列值加载到表中：

```
backslash =
vertical bar = |
exclamation point = !
```
您指定 | 作为列分隔符，\作为转义字符。您数据文件中，格式化后的数据行应该类似下面的样子：

```
backslash = \\ | vertical bar = \| | exclamation point = !
```
这里请您注意反斜线是一部分数据，因此需要使用另一个反斜线进行转义。另外 | 字符也是数据的一部分，因此需要使用反斜线将其转义。

您还可以使用转义字符来转义八进制和十六进制序列。在 HashData 数据仓库加载数据时，转义的值将会被转换为对应的字符。例如，要加载 & 字符，可以用转义字符来转义该字符的十六进制（0x26）或者八进制（046）表示。

您也可以在文件格式文件中，利用 ESCAPE 语句来禁用转义功能，例如：

```
ESCAPE 'OFF'
```
如果您要加载包含大量反斜线的数据时（例如，互联网类日志），禁用转义功能将会非常方便。

#### CSV 文件中的转义操作

默认情况下，CSV 格式文件的转义字符是 “（双引号）。您可以在 CREATE EXTERNAL TABLE 的 ESCAPE 语句中指定其他的转义字符。如果您的数据中包含了转义字符本身，可以使用转义字符来转义它自己。

让我们来看一下例子，假设您有一张包含三个列的表，您希望将下面三列作为列值加载到表中：

```
Free trip to A,B
5.89
Special rate “1.79”
```
您指定 , （逗号）作为列分隔符，”（双引号） 作为转义字符。您数据文件中，格式化后的数据行应该类似下面的样子：
```
"Free trip to A,B","5.89","Special rate ""1.79"""
```
如果逗号是数据的一部分，需要使用双引号来保护。如果双引号是数据的一部分，即使整个数据是用双引号来保护的，还是需要用双引号来转义双引号的。

使用双引号保护整个数据字段可以保证数据开头和结尾的空白字符被正确解释。

```
"Free trip to A,B ","5.89 ","Special rate ""1.79"" "
```

>注意：在 CSV 格式中，字符解释的处理非常严格。例如：被引号保护的空白字符或者其他非分隔字符。由于上面的原因，如果向系统导入的数据在末尾补充了保持每行相同长度的空白字符，将会引起错误。因此，在使用 HashData 数据仓库读取数据时，需要先将 CSV 文件进行预处理，移除不必要的末尾空白字符。

### 字符编码的处理

字符编码系统是通过一种编码方法，将字符集中的字符和特定数值组成一个固定映射关系，来允许对数据传输和存储。HashData 数据仓库支持多种不同的字符集，例如：单字节的字符集 ISO 8859 及其衍生字符集，多字节字符集 EUC（扩展 UNIX 编码），UTF-8 等。虽然有一小部分字符集不支持作为服务器端存储编码，但是客户端可以使用所有的字符集。

数据文件使用的编码必须是 HashData 数据仓库能够识别的。 在数据加载时，如果数据文件包含无效或不支持的编码序列时，将会导致错误。

> 注意：如果数据文件是在微软的 Windows 操作系统上生成的，请在进行数据加载前，运行 dos2unix 命令来删除原始文件中 Windows 平台的特殊字符。
