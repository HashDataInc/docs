# 定义数据库对象

在这个章节中，我们将介绍 HashData 数据仓库支持的数据定义语言 \(DDL\) 以及如何创建和管理数据库对象。

创建 HashData 数据仓库对象的时候，我们需要考虑很多因素，包括数据分布、存储选项、数据加载以及其它影响数据库系统运行性能的功能。了解可用的选项和数据库内部如何支持这些选项将帮助您做出正确的选择。

通过扩展标准 SQL 的 CREATE DDL 语句，HashData 数据仓库实现了很多高级的功能。

## 4.1. 创建和管理数据库

与一些商业数据库（如 Oracle 数据库）不同，HashData 数据仓库支持创建多个数据隔离的独立数据库，但是客户端程序每次只能连接并使用其中一个。

### 4.1.1 关于数据库模版

您创建的每一个数据库都是基于一个模版得到的。系统中的默认模版数据库叫做：template1。我们建议您不要在 template1 中创建任何数据对象， 否则您后续创建的数据库都会包含这些数据。

HashData 数据仓库内部还使用另外两个内置模版：template0 和 postgres。因此请勿删除或修改 template0 和 postgres 数据库。您也可以使用 template0 作为模版，创建一个只含有标准预定义对象的空白数据库，特别是在您已经修改了默认模版数据库 template1 的情况下。

### 4.1.2 创建数据库

使用 CREATE DATABASE 命令来创建一个新的数据库. 例如:

```
=> CREATE DATABASE new_dbname;
```

若要创建新的数据库,您需要拥有创建数据库的权限或拥有者超级用户权限。如果您没有相应的权限，创建数据库的操作将会失败。可以联系数据管理员来取得创建数据库的权限。

### 4.1.3 克隆数据库

创建新的数据库时，系统实际上通过克隆一个默认的标准数据库模版 template1 来完成。实际上，您可以指定任意一个数据库作为创建新数据库的模版，这样新的数据库就会自动包含模版数据库中的所有对象和数据。例如：

```
=> CREATE DATABASE new_dbname TEMPLATE old_dbname;
```

### 4.1.4 列出所有数据库

如果您使用 psql 客户端程序，您可以使用 \l 命令列出系统中的模版数据库和数据库。如果您使用其他客户端程序并且拥有超级用户权限，您可以通过查询 pg\_database 系统表列出所有数据库。例如：

```
=> SELECT datname from pg_database;
```

### 4.1.5 修改数据库

ALTER DATABASE 命令可以用来修改数据库的属主，名称或者默认参数配置。例如,下面的命令修改了数据库默认模式搜索路径：

```
=> ALTER DATABASE mydatabase SET search_path TO myschema, public, pg_catalog;
```

你需要是数据库的属主或拥有超级用户权限，才可以对数据库信息进行修改。

### 4.1.6 删除数据库

DROP DATABASE 命令可以删除数据库。该命令将会从系统表中删除数据库相关信息，并在磁盘上删除该数据库相关的所有数据。只有数据库的属主或者超级用户才能够删除数据库。正在被使用的数据库是无法被删除的。例如：

```
=> \c template1
=> DROP DATABASE mydatabase;
```

> 警告：删除数据库是不可逆的操作，请谨慎使用。

## 4.2. 创建和管理模式

模式（Schema）的作用类似于名字空间，实现了数据库对象逻辑上的分类组织。通过使用模式对象，您可以在同一个数据库中，创建同名的对象（例如：表，函数）。

### 4.2.1 默认模式 "public"

数据库包含一个默认模式：public。如果您没有创建任何模式，新创建的对象会默认使用 public 模式。数据库所有的用户都拥有 public 模式上的 CREATE（创建）和 USAGE（使用）权限。当您创建额外的模式时，您可以对用户授予权限，从而实现访问控制。

### 4.2.2 创建模式

使用 **CREATE SCHEMA** 命令来创建一个新的模式. 例如:

```
=> CREATE SCHEMA myschema;
```

要在指定的模式下创建对象或访问对象，您需要使用限定名格式来进行。限定名格式是模式名”.“表名的方式，例如：

```
myschema.table
```

参考 [模式的搜索路径]()了解更多关于访问模式的说明.通过为用户创建私有的模式，可以更好地限制用户对名称空间的使用。语法如下：

```
=> CREATE SCHEMA schemaname AUTHORIZATION username;
```

### 4.2.3 模式的搜索路径

通过使用模式限定名，可以指向数据库中特定位置的对象。例如：

```
=> SELECT * FROM myschema.mytable;
```

可以通过设置参数 search\_path 来指定模式的搜索顺序。搜索路径中第一个模式就是系统使用的默认模式，当没有引用模式时，对象将会自动创建在默认模式下。

设置模式搜索路径 search\_path 配置参数用来设置模式搜索顺序。ALTER DATABASE 命令可以设置数据库内默认搜索路径。例如：

```
=> ALTER DATABASE mydatabase SET search_path TO myschema, public, pg_catalog;
```

还可以通过 ALTER ROLE 命令来为指定的用户修改 search\_path 参数。例如：

```
=> ALTER ROLE sally SET search_path TO myschema, public, pg_catalog;
```

查看当前模式通过 current\_schema\(\) 函数，系统可以显示当前模式。例如：

```
=> SELECT current_schema();
```

类似的，使用 SHOW 命令也可以显示当前搜索路径。例如：

```
=> SHOW search_path;
```

### 4.2.4 删除模式

使用 DROP SCHEMA 命令可以删除一个模式。例如：

```
=> DROP SCHEMA myschema;
```

默认的删除命令只能删除一个空的模式。要删除模式及其内部包含的所有对象（表，数据，函数，等），使用下面的命令：

```
=> DROP SCHEMA myschema CASCADE;
```

### 4.2.5 系统预定义模式

每个数据库中内置了下列系统模式：

* pg\_catalog 包含了系统表，内建数据类型，函数和运算符对象。模式搜索路径时，系统总是会考虑此模式下的所有对象。
* information\_schema 模式包含了大量标准化视图来描述数据库内部对象信息。这些视图以标准化方式来展现系统表中的信息。
* pg\_toast 存储大对象，例如：记录大小超过页面大小的对象。此模式下的信息是数据库内部使用的。
* pg\_bitmapindex 存储bitmap所有对象，例如：值列表。此模式下的信息是数据库内部使用的。
* pg\_aoseg 存储 append-optimized 表对象. 此模式下的信息是数据库内部使用的。
* gp\_toolkit 是一个管理视图，内置一些外部表，视图和函数。可以通过SQL语句进行访问。所有数据库用户都能够访问 gp\_toolkit 来查看日志文件和其它系统参数。

## 4.3. 创建和管理表

HashData 数据仓库中的表和其它关系型数据库十分相似，但由于是 MPP 架构，数据会被打散分发到多个节点存储。每次创建表时，你可以指定数据的分布策略。

### 4.3.1 创建表

CREATE TABLE 命令用来创建和定义表结构，创建表时，您需要定义下面信息：

* 表中包含的列及其对应数据类型。请参考 [选择列数据类型]()。
* 用于限制表或列存储数据的表约束或列约束。请参考 [设置表约束和列约束]()。
* 数据分布策略，系统根据策略将数据存储到不同节点。请参考 [选择数据分布策略]()。
* 磁盘存储格式。请参考 [表存储模型]()。
* 大表的数据分区策略。请参考 [对大表进行分区处理]()。

### 4.3.2 选择列数据类型

列数据类型的选择是根据该列存储的数值决定的。选择的数据类型应该尽可能占用空间小，同时能够保证存储所有可能的数值并且最合理地表达数据。例如：使用字符型数据类型保存字符串，日期或者日期时间戳类型保存日期类型，数值类型来保存数值。

我们建议您使用 VARCHAR 或者 TEXT 来保存文本类数据。我们不推荐使用 CHAR 类型保存文本类型。VARCHAR 或 TEXT 类型对于数据末尾的空白字符将原样保存和处理，但是 CHAR 类型不能满足这个需求。请参考 CREATE TABLE 命令了解更多相关信息。

您应该使用同时满足数值存储和未来扩展需求的最小数据类型。例如：使用 BIGINT 类型存储 INT 或者 SMALLINT 数值会浪费存储空间。如果数据随时间推移需要扩展，并且数据重新加载比较浪费时间，那么在开始的时候就应该考虑使用更大的数据类型。例如：如果当前数值能够用SMALLINT存储，但是数值会越来越大，那么长远来看使用INT类型可能是更好的选择。

如果您考虑两表连接，那么参与连接的列的数据类型应该保持一致。通常表连接是用一张表的主键和另一张表的外键进行的。当数据类型不一致时，数据库需要进行额外的类型转换，而这开销是完全无意义的。

HashData 数据仓库支持大量原生的数据类型，文档后面会进行详细介绍。

## 4.4. 设置表约束和列约束

您可以通过在表或者列上创建约束来限制存储到表中的数据。HashData 数据仓库支持 postgres 所有种类的约束，但是您需要注意一些额外的限制条件：

* CHECK 约束只能引用 CHECK 的目标表。
* UNIQUE 和 PRIMARY KEY 约束必须和数据分布键和分区键兼容。
* FOREIGN KEY 约束能够创建，但是系统不会检查此约束是否满足条件。
* 创建在分区表上的约束将会把整个分区表当成一个整体处理。系统不允许针对表中特定分区定义约束条件。

### 4.4.1 Check 约束

Check 约束允许你限制某个列值必须满足一个布尔（真值）表达式。例如，要求产品价格必须是一个正数：

```
=> CREATE TABLE products 
           ( product_no integer, 
             name text, 
             price numeric CHECK (price > 0) );
```

### 4.4.2 非空约束

非空约束允许你限制某个列值不能为空，此约束总是以列约束形式使用。例如：

```
=> CREATE TABLE products 
           ( product_no integer NOT NULL,
             name text NOT NULL,
             price numeric );
```

### 4.4.3 唯一约束

唯一约束确保存储在一张表中的一列或多列数据数据一定唯一。要使用唯一约束，表必须使用Hash分布策略，并且约束列必须和表的分布键对应的列一致（或者是超集）。例如：

```
=> CREATE TABLE products 
           ( product_no integer UNIQUE, 
             name text, 
             price numeric)
          DISTRIBUTED BY (product_no);
```

### 4.4.4 主键约束

主键约束是唯一约束和非空约束的组合。要使用主键约束，表必须使用Hash分布策略，并且约束列必须和表的分布键对应的列一致（或者是超集）。如果一张表指定了主键约束，分布键值默认会使用主键约束指定的列。例如：

```
=> CREATE TABLE products 
           ( product_no integer PRIMARY KEY, 
             name text, 
             price numeric)
          DISTRIBUTED BY (product_no);
```

### 4.4.5 外键约束

HashData 数据仓库不支持外键约束，但是允许您声明外键约束。系统不会进行参照完整性检查。

外键约束指定一列或多列必须与另一张表中的值相匹配，满足两张表之间的参照完整性。HashData 数据仓库不支持数据分布到多个节点的参照完整性检查。

## 4.5. 选择数据分布策略

所有 HashData 数据仓库数据表都是分布在多个节点的。当您创建或修改表时，您可以通过使用  
DISTRIBUTED BY（基于哈希分布）或者 DISTRIBUTED RANDOMLY\(随机分布\)来为表指定数据分布规则。

> 注意：gp\_create\_table\_random\_default\_distribution 参数控制着在  
> DISTRIBUTED BY 子句缺省情况下的行为。

当您在考虑表的数据分布策略时，您可以从以下三方面来分析并帮助决策：

* 均匀地分布数据 — 为了尽可能获得最佳性能，每个节点应该尽可能获得均匀的数据。如果数据呈现出极度不均匀，那么数据量较大的节点就需要更多资源甚至是时间才能完成相应的工作。选择数据分布键值时尽量保证键值唯一，例如使用主键约束。
* 局部和分布式运算 — 局部运算远远快于分布式运算。如果连接，排序或聚合运算能够在局部进行（计算和数据在一个节点完成），那么查询的整体速度就会更快。如果某些计算需要在整个系统来完成，那么数据需要进行交换，这样的操作就会降低效率。如果参与连接或者排序的表都包含相同的数据分布键，那么这样的操作就可以在局部进行。如果数据采用随机分布策略，系统就无法在局部完成像连接这样的操作。
* 均匀地处理请求 — 为了最优的性能，每个节点应该处理均匀的查询工作。如果表的数据分布策略和查询使用数据不匹配，查询的负载就会产生倾斜。例如：销售交易记录表是按照客户ID进行分布的，那么一个查询特定客户ID的查询就只会在一个特定的节点进行计算。

### 4.5.1 声明数据分布

CREATE TABLE 的可选子句 DISTRIBUTED BY 和 DISTRIBUTED RANDOMLY 可以为表指定数据分布策略。表的默认分布策略是使用主键约束（如果有的话）或者使用表的第一列。地理信息类型或者用户自定义数据类型是不能被用来作为表的数据分布列的。如果一张表没有任何合法的数据分布列，系统默认使用随机数据分布策略。

为了尽可能保证数据的均匀分布，尽量选择能够使数据唯一的分布值。如果没有任何值能够满足，可以使用随机分布策略：

```
=> CREATE TABLE products
                        (name varchar(40),
                         prod_id integer,
                         supplier_id integer)
             DISTRIBUTED BY (prod_id);

=> CREATE TABLE random_stuff
                        (things text,
                         doodads text,
                         etc text)
             DISTRIBUTED RANDOMLY;
```

## 4.6. 表存储模型

HashData 数据仓库支持多种表存储模型，以及这些模型的混合。当您创建一张表的时候，您可以选择如何存储数据。这个小节中，我们将解释各种表存储模型，以及如何根据您的工作负载选择性能最优的存储模型。

* 堆存储（Heap Storage）
* 追加优化存储（Append-Optimized Storage）
* 如何选择行存储和列存储
* 数据压缩（只适用于追加优化存储）
* 查看追加优化表的数据压缩和数据分布
* 更改一张表
* 删除一张表

> 提醒：为了简化创建表操作，您可以通过设置配置参数 gp\_default\_storage\_options 来指定默认的表存储模型。

### 4.6.1 堆存储（Heap Storage）

默认的情况下，HashData 数据仓库会选用和 PostgreSQL 一样的堆存储模型。堆存储的表非常适合这种场景下的OLTP（在线事务处理）工作负载：数据初次加载后频繁更新。为了确保可靠的数据库事务处理，更新和删除操作需要保存行级别的版本信息。堆存储表最适合小的维度表，尤其是在数据初次加载后频繁  
更新的场景下。

由于堆存储是默认的存储模型，所以您可以通过如下语句创建堆存储表：

```
=> CREATE TABLE foo (a int, b int) DISTRIBUTED BY (a);
```

### 4.6.2 追加优化存储（Append-Optimized Storage）

追加优化存储模型适合数据仓库中非规范化的事实表，后者通常是系统中最大的表。事实表通常是批量加载进入数据仓库，并且用于只读的查询中。相对于堆存储模型，追加优化存储省去了行级别版本信息存储开销（每行大约20个字节），并使得存储页结构更加地精简和易于优化。追加优化存储是为数据批量加载而优化的，所以我们并不推荐单行的插入操作。

您可以通过使用 CREATE TABLE 命令的 WITH 子句来指定表存储模型。下面的例子是创建一个没有数据压缩的追加优化存储表：

```
=> CREATE TABLE bar (a int, b text)
          WITH (appendonly=true)
          DISTRIBUTED RANDOMLY;
```

在一个可串行化的事务里面，对追加优化表进行更新和删除操作是不允许的，并且会导致事务中断。另外，追加优化表不支持 CLUSTER， DECLARE...FOR UPDATE，和触发器。

### 4.6.3 行存储还是列存储

HashData 数据仓库提供了行存储、列存储以及两者组合的存储选项。在这个小节里，我们将讨论如何根据您的数据和工作负载决定存选项，从而取得最优的查询性能。基本原则如下：

* 行存储：适合包含很多迭代事务查询以及需要访问记录中大部分列查询的在线事务处理（OLTP）工作负载。对于这种场景，由于行存储将一条记录所有列的数据放在一起了，读取访问会非常高效。
* 列存储：适合只需要对表中少数列进行聚合操作的数据仓库工作负载，或者定期对表中某一列进行更新（保持其它列不变）的工作负载。

对于大部分通用的或者混合的工作负载，行存储在灵活性和性能方面做了最好的平衡。然而，在某些应用场景中，列存储模型提供了更加高效的I/O和存储使用。在选择行存储还是列存储的时候，可以考虑以下几个需求：

* 表数据的更新。如果需要频繁地加载和更新表数据的话，那么您应该选择行导向的堆存储。只有追加优化表支持列存储。
* 频繁的插入操作。如果插入操作很多的话，行导向的存储模型会比较合适。由于每列数据需要写到磁盘上的不同文件，列存储表对写操作不友好。
* 查询中需要访问的列数。如果查询中的 SELECT 列表或者 WHERE 子句包含了表的大多数列，那么您应该考虑使用行存储。列存储表非常适合对表中某一列进行聚合计算并且 WHERE or HAVING 谓词也是针对聚合列。例如：

```
    => SELECT SUM(salary) ...

    => SELECT AVG(salary) ... WHERE salary > 10000
```

另外一种适合列存储的查询是，WHERE 谓词只正针对某一列并且查询结果返回少数几列表数据。例如：

```
    => SELECT salary, dept, ... WHERE state = 'CA'
```

* 表中列的数量。如果表中的每行数据量比较少，或者表中的大部分列在查询中都会被访问到，这种场景中，相对于列存储，行存储会更高效。对于那些包含很多列的表，如果查询只访问到其中少数一部分列，那么列存储能够提供高好的性能。
* 压缩。由于同一列的数据类型是相同的，所以相对于行式存储，列示存储存在更多数据压缩空间。例如，很多种压缩算法都利用了相邻数据的相似度进行压缩。另一方面，越高的压缩比意味着数据的随机访问越困难，因为数据首先得解压了才能被读取。

**创建一个列存储表**

您可以通过 CREATE TABLE 语句中的 WITH 子句来指定表的存储选项。默认的情况下，创建的新表都是行式的堆存储表。只有追加优化的表才支持列示存储。下面的例子中，我们创建一个列示存储表：

```
=> CREATE TABLE bar (a int, b text)
          WITH (appendonly=true, orientation=column)
          DISTRIBUTED BY (a);
```

### 4.6.4 数据压缩（只适用于追加优化存储）

在 HashData 数据仓库中，对于追加优化表，存在两种不同级别的数据压缩：

* 表级别的压缩作用于整张表。
* 列级别的压缩作用于表中的某一列。您可以针对表中的不同列使用不同的压缩算法。

下面的表格总结了现在支持的压缩算法

| 表导向 | 支持的压缩类型 | 支持的压缩算法 |
| :--- | :--- | :--- |
| 行式存储 | 表压缩 | ZLIB |
| 列式存储 | 列压缩和表压缩 | ZLIB 和 RLE\_TYPE |

在选择压缩算法和压缩级别的时候，您需要考虑下列因素：

* CPU的使用。您必须确保您的计算节点有足够的CPU计算能力去压缩和解压数据。
* 压缩比和磁盘大小。尽可能减少磁盘占用空间是一方面，另一方面我们也需要考虑压缩和扫描数据时所消耗的时间和CPU计算能力。在这者之间找到一个合适的平衡点非常关键。
* 压缩速度。zlib提供了1-9的压缩级别。一般来说，级别越高，压缩比越高，但是压缩速度越慢。
* 解压和扫描的速度。压缩数据的查询性能由很多因素决定，包括硬件、查询参数配置和其它因素。为了做出最合适的选择，我们建议您在实际环境中进行性能测试比较。

**创建一张压缩表**

您可以通过 CREATE TABLE 语句中的 WITH 子句来指定表的存储选项。只有追加优化的表支持压缩。下面的例子演示了如何创建一张使用 zlib 算法、压缩级别为 5 的追加优化表：

```
=> CREATE TABLE bar (a int, b text)
          WITH (appendonly=true, compresstype=zlib, compresslevel=5);
```

**每一列单独的压缩算法**

下面的例子演示了，对于一张列式存储的表，如何为每一列指定单独的压缩算法：

```
=> CREATE TABLE bar (
          a int ENCODING (compresstype=zlib, compresslevel=5, blocksize=524288),
      b text ENCODING (compresstype=rle_type, compresslevel=3, blocksize=2097152))
      WITH (appendonly=true, orientation=column);
```

### 4.6.5 查看追加优化表的数据压缩和分布

HashData 数据仓库提供了查看追加优化表数据压缩和分布的内置函数。这些函数接受表的对象ID或者名字作为查询参数。您可以给表名加上限定的模式名字。

| 函数 | 返回类型 | 描述 |
| :--- | :--- | :--- | :--- |
| get\_ao\_distribution\(name | oid\) | \(dbid, tuplecount\)集合 | 返回每个 Segment 数据库的元组个数 |
| get\_ao\_compression\_ratio\(name | oid\) | float8 | 返回压缩追加优化表的压缩比；或者-1 |

数据压缩比是作为整张表的值返回的。例如，如果返回值是 3.19，或者 3.19:1，那么意味这压缩前的数据大小是压缩后数据大小的 3 倍多一点。

表分布函数返回的是元组的集合，表明每个 Segment 数据库中表元组的数量。例如，在一个包含 4 个 Segment 数据库、数据库 ID 从 0 到 3 的系统中，函数返回如下类似的结果：

```
    => SELECT get_ao_distribution('lineitem_comp');
     get_ao_distribution
    ---------------------
    (0,7500721)
    (1,7501365)
    (2,7499978)
    (3,7497731)
    (4 rows)
```

### 4.6.6 RLE\_TYPE 压缩算法

对于列级别的压缩类型，HashData 数据仓库支持 Run-length Encoding（RLE）压缩算法。RLE算法的原理是将重复出现的值存成一个值和出现的次数。举个例子，一张表包含两列，一列是日期 date，另一列是描述 description。假设这张表中有 200000 行数据中 date 的值是 date1，400000 行数据中 date 的值是 date2，那么使用RLE压缩后的数据内容类似 date1 200000，date2  
400000。RLE 算法不合适数据中只有很少重复值的表。这种情况下，RLE 反而让需要存储的数据量变大。

RLE 压缩算法分成四中级别。级别越高，压缩比越高，但是压缩速度越慢。

### 4.6.7 更改一张表

您可以通过使用 ALTER TABLE语句来更改一张表的定义，包括列的定义、数据分布策略、存储模型和分区结构。例如，给表中的某一列增加非空约束：

```
=> ALTER TABLE address ALTER COLUMN street SET NOT NULL;
```

**改变表的数据分布策略**

对于一张分区表，表数据分布策略的改变会影响到其所有的子分区表。这个操作将保留包括表的属主在内的其它表属性。例如，下面的命令将表 sales 分布在所有 Segment 数据库中的数据以 customer\_id  
列为分布键重新分布：

```
=> ALTER TABLE sales SET DISTRIBUTED BY (customer_id);
```

当您修改了一个张表的 hash 分布策略后，这张表的数据会自动地重分布。但是，将表的分布策略改成随机分布不会导致数据的重分布。例如，下面这个例子不会有立即的效果：

```
=> ALTER TABLE sales SET DISTRIBUTED RANDOMLY;
```

**重分布表数据**

我们可以在 ALTER TABLE 的 WITH 子句中指定 REORGANIZE=TRUE 来对表数据进行重分布。当出现数据倾斜问题或者有新的计算资源加入到系统中，重组织数据是一个可性的解决方案。例如，下面这个例子中，表数据将基于现有的数据分布策略（包括随机分布）对数据进行重分布：

```
=> ALTER TABLE sales SET WITH (REORGANIZE=TRUE);
```

**修改表的存储模型**

表的存储模型、压缩和存储导向（行式存储还是列式存储）只能在创建的时候指定。如果需要修改表的存储模型，您需要使用正确的存储选项创建一张新的表，将数据从旧表中加载到新表中，然后删除旧表，将新表重命名为旧表的名字。您当然也需要重新设置所有的表权限。例如：

```
CREATE TABLE sales2 (LIKE sales)
WITH (appendonly=true, orientation=column,
      compresstype=zlib, compresslevel=5);
INSERT INTO sales2 SELECT * FROM sales;
DROP TABLE sales;
ALTER TABLE sales2 RENAME TO sales;
GRANT ALL PRIVILEGES ON sales TO admin;
GRANT SELECT ON sales TO guest;
```

### 4.6.8 删除一张表

您可以通过 DROP TABLE 语句将一张表从数据库中删除。例如：

```
=> DROP TABLE mytable;
```

如果只是清空表数据而不删除表定义的话，您可以使用 DELETE 或者 TRUNCATE 语句。例如：

```
DELETE FROM mytable;
TRUNCATE mytable;
```

DROP TABLE 语句同时会删除目标表上的所有索引、规则、触发器和约束。通过指定 CASCADE，您还可以一并删除依赖于这张表的视图。

## 4.7. 对大表进行分区处理

表分区通过将数据逻辑上划分到多个较小，更容易管理的小表，来支持超大表，例如：事实表（fact table）。HashData 数据仓库查询优化器通过利用分表信息，只检索满足查询要求的数据，从而避免检索大表的所有内容，最终提高查询性能。

* 表分区概述
* 选择分区表策略
* 创建分区表
* 向分区表加载数据
* 验证分区表策略
* 查看分区表设计
* 分区表的维护

### 4.7.1 表分区概述

表分区不改变计算节点之间数据的分布规则。表分布存储是 HashData 数据仓库是在物理上将分区表和普通表数据存储在多个 segment 节点上，从而允许并行查询处理。表分区是 HashData 数据仓库在逻辑上将大表数据分开存放，来提升查询性能并且简化数据仓库的维护任务，例如：将旧数据从数据仓库删除。

HashData 数据仓库支持：

* 范围分区：按照数值范围进行分区，例如：日期或价格。
* 列表分区：按照列表包含的数值进行分区，例如：销售地区或产品线。
* 范围分区和列表分区的组合使用。

![](/assets/management-partition-pic-1.jpg)

图1. 多层分区表结构

### 4.7.2 HashData 数据仓库的表分区介绍

HashData 数据仓库通过将数据打散成多份来支持并行处理。表分区是在建表语句 CREATE TABLE 中指定 PARTITION BY（以及可选的 SUBPARTITION BY）。分区将会创建一张顶层（父）表以及一层或多层子表。在内部，HashData 数据仓库将会对顶层表和子表创建继承关系，这与 postgres 的 INHERITS  
子句十分类似。

HashData 数据仓库将会根据创建表的分区定义为每个分区创建一个 CHECK 约束条件，该约束将会限制该分区能够包含的数据。查询优化器将会利用 CHECK 约束来决定扫描哪些表分区可以 满足查询指定的过滤条件。

HashData 数据仓库系统信息表保存分区的结构信息，这样每当有记录插入到顶层的父表时，系统能够正确地将其插入到子分区中。要改变分区结构或表结构，在父表上使用 ALTER TABLE 以及 PARTITION 子句即可。

要插入数据到分区表，你需要指定根分区表（也就是 CREATE TABLE 命令时指定的表）。您还可以在 INSERT 语句中指定分区表的叶子表。如果数据不满足该分区的要求，将会得到错误提示。INSERT 语句不支持指定的非叶子表的分区。执行其他 DML 语句（例如：UPDATE 和 DELETE）时，不支持指定任何子分区。要执行前面的命令，必须指定根分区表（也就是 CREATE TABLE 命令时指定的表）。

### 4.7.3 选择分区表方案

并不是所有表都是适合使用表分区。如果下面问题的答案大部分或者全部是肯定的，那么表分区将会是一种重要的提升查询性能的数据库设计方案。如果大部分问题回答是否定的，那么采用分区表策略就不大合适了。最后，还需要对设计方案进行测试，以确保查询性能与期望相符。

* 这张表的数据足够多吗？一般来说，数据量很多的事实表（facttable）比较适合采用表分区。
  如果表中有上百万甚至上亿条记录时，通过逻辑上将数据分散到多个小数据表中，性能将会
  得到较大提升。对于只有几千条记录甚至更少的表，管理上的维护开销将会完全抵消带
  来的性能收益。
* 目前的性能无法满足业务需求？与大部分性能调优的初衷类似，对表进行分区处理应该是在
  对该表的查询响应时间无法满足需求时进行的。
* 查询过滤条件是否有较固定的访问模型？通过分析查询中 WHERE
  子句中涉及的数据列信息，
  判断是否存在一些列经常作为数据检索的条件。例如：如果大部分的查询趋向使用日志来检索
  数据，那么一个按月或星期分割的、基于日期的分区设计可能对提升查询性能有较好效果。又或者，
  查询倾向于按照地区进行数据检索，那么考虑利用列表值进行分区的时候，根据地区信息分区效果可能比较好。
* 数据库仓库是否需要保存一段时间的历史数据？另一个重要的考虑因素就是在机构的商业需求中，
  对历史数据的维护操作需求。例如，如果数据仓库需要维护过去12个月的数据，那么按照
  月份对数据进行分区，您就可以轻易的将最旧的月份分区直接删除，并将当前数据加载到
  最近的月份分区中。
* 数据能够根据某些条件分成基本相等的部分吗？选择分区条件时，应该保证数据被分割
  后，每个分区表的数据量尽可能地均匀。如果每个分区包含的数据量近似相等，查询性能提升与分区表的数量直接相关。例如，将一张大表分成10个分区后，如果分区条件能够满足查询检索条件，查询
  对于分区表的处理能够比对没有分区之前的表快10倍。

创建的分区数量不应该超过实际需求数量。创建过多的分区可能会拖慢管理和维护作业，例如：  
清理工作，节点恢复，集群扩展，查看磁盘使用情况等。

只有当查询优化器能够利用查询过滤条件，来消除一些分区扫描时，表分区才能提高查询性能。  
查询扫描所有分区的运行时间实际上比扫描没有分区时候的运行时间更长，所以如果没有什么查  
询能消除一些分区扫描时，请不要使用表分区。可以通过检查查询计划来确认分区是否被消除。

在使用多层表分区时，请注意分区文件数的增长速度可能超出您的预期。例如，一张按照天和城  
市进行分区的表，当存储 1000 天和 1000 个城市时，需要创建一百万个分区。列存表，将每  
列独立存储成一个物理表，对于一张有 100 列的表来说，系统管理该表需要管理 1 亿个文件。

在使用多层表分区时，您可以考虑使用单层表分区和位图索引（Bitmap索引）。由于索引将会  
降低数据加载速度，因此推荐您使用性能测试来针对您的数据和模式进行评测，选取最优策略。

### 4.7.4 创建分区表

在使用 CREATE TABLE 命令创建表时，您可以对表进行分区操作。本主题向您展示用于创建不  
同类型分区表的 SQL 语法。

要将一只表进行分区：

1. 确定分区表的设计：日期范围，数值范围，列表值。
2. 选择用于分区的数据列。
3. 确定分区的层数。例如，你可以首先按照日期范围根据月份进行分区，在按月分区的子分区  
   中，按照销售地区分区。

4. 定义按日期划分的分区表

5. 定义数值划分的分区表
6. 定义列表值分区
7. 定义多层分区
8. 对已经存在的进行分区

### 4.7.5 定义按日期划分的分区表

日期划分的分区表使用一个日期或时间戳列做为分区键值列。如果需要，子分区可以使用与父分  
区相同的分区键值列。例如：父分区按照月份进行划分，子分区使用日期进行划分。在分区时，  
应该考虑按照最细的粒度来进行。例如：对于按照日期划分的分区表来说，您应该直接按照天数  
创建分区，这样创建365个按天存储的分区表即可。应该避免先按照年，再按照月，最后按照天  
来创建分区表的模式。虽然多层的分区设计可以降低查询计划的时间，但是设计上扁平的分区表  
在运行时，速度更快。

您可以通过指定起始值（START），终止值（END）和增量子句（EVERY）指出分区的增量值，让 HashData 数据仓库来自动地生成分区。默认情况下，起始值总是包含的（闭区间），而终止值是排除的（开区间）。例如：

```
CREATE TABLE sales (id int, date date, amt decimal(10,2))
DISTRIBUTED BY (id)
PARTITION BY RANGE (date)
( START (date '2008-01-01') INCLUSIVE
   END (date '2009-01-01') EXCLUSIVE
   EVERY (INTERVAL '1 day') );
```

您还可以为每个分区指定独立的名称，例如：

```
CREATE TABLE sales (id int, date date, amt decimal(10,2))
DISTRIBUTED BY (id)
PARTITION BY RANGE (date)
( PARTITION Jan08 START (date '2008-01-01') INCLUSIVE , 
  PARTITION Feb08 START (date '2008-02-01') INCLUSIVE ,
  PARTITION Mar08 START (date '2008-03-01') INCLUSIVE ,
  PARTITION Apr08 START (date '2008-04-01') INCLUSIVE ,
  PARTITION May08 START (date '2008-05-01') INCLUSIVE ,
  PARTITION Jun08 START (date '2008-06-01') INCLUSIVE ,
  PARTITION Jul08 START (date '2008-07-01') INCLUSIVE ,
  PARTITION Aug08 START (date '2008-08-01') INCLUSIVE ,
  PARTITION Sep08 START (date '2008-09-01') INCLUSIVE ,
  PARTITION Oct08 START (date '2008-10-01') INCLUSIVE ,
  PARTITION Nov08 START (date '2008-11-01') INCLUSIVE ,
  PARTITION Dec08 START (date '2008-12-01') INCLUSIVE 
                  END (date '2009-01-01') EXCLUSIVE );
```

除了最后一个分区外，其他分区的终止值可以省略。在上例中，Jan08 的终止值就是 Feb08 的起始值。

### 4.7.6 定义数值划分的分区表

使用数值范围的分区表，利用单独的数值类型列做为分区键值列。例如：

```
CREATE TABLE rank (id int, rank int, year int, gender 
char(1), count int)
DISTRIBUTED BY (id)
PARTITION BY RANGE (year)
( START (2001) END (2008) EVERY (1), 
  DEFAULT PARTITION extra );
```

要了解更多关于默认分区的信息，请参考 [增加默认分区]()。

### 4.7.7 定义列表值分区

使用列表值进行分区的表可以选用任何支持等值比较的数据类型列做为分区键值列。并且使用  
列表值进行分区还可以支持多列（复合）分区键值列，与之对应的范围分区只支持单列做为分  
区键值列。对于列表值分区来说，您必须为每一个要创建的分区指定对应的列表值。例如：

```
CREATE TABLE rank (id int, rank int, year int, gender 
char(1), count int ) 
DISTRIBUTED BY (id)
PARTITION BY LIST (gender)
( PARTITION girls VALUES ('F'), 
  PARTITION boys VALUES ('M'), 
  DEFAULT PARTITION other );
```

要了解更多关于默认分区的信息，请参考 [增加默认分区]()。

### 4.7.8 定义多层分区

您可以通过在分区下创建子分区来实现多层分区的设计。使用子分区定义模版能够保证每个分  
区拥有一致的子分区结构，即使在未来添加新分区时，该模版仍然能够保证新的子分区结构。  
例如，下面的 SQL 语句可以创建与图 1 一致的两层分区表：

```
CREATE TABLE sales (trans_id int, date date, amount 
decimal(9,2), region text) 
DISTRIBUTED BY (trans_id)
PARTITION BY RANGE (date)
SUBPARTITION BY LIST (region)
SUBPARTITION TEMPLATE
( SUBPARTITION usa VALUES ('usa'), 
  SUBPARTITION asia VALUES ('asia'), 
  SUBPARTITION europe VALUES ('europe'), 
  DEFAULT SUBPARTITION other_regions)
  (START (date '2011-01-01') INCLUSIVE
   END (date '2012-01-01') EXCLUSIVE
   EVERY (INTERVAL '1 month'), 
   DEFAULT PARTITION outlying_dates );
```

下面是一个三层的分区表定义，sales 表分别按照年度，月份，地区进行分区。这里的 SUBPARTITION TEMPLATE 子句保证了每一个按年度的分区表拥有完全一致的子分区表结构。这个例子中，还在每层结构中声明了一个 DEFAULT 分区。

```
CREATE TABLE p3_sales (id int, year int, month int, day int, 
region text)
DISTRIBUTED BY (id)
PARTITION BY RANGE (year)
    SUBPARTITION BY RANGE (month)
       SUBPARTITION TEMPLATE (
        START (1) END (13) EVERY (1), 
        DEFAULT SUBPARTITION other_months )
           SUBPARTITION BY LIST (region)
             SUBPARTITION TEMPLATE (
               SUBPARTITION usa VALUES ('usa'),
               SUBPARTITION europe VALUES ('europe'),
               SUBPARTITION asia VALUES ('asia'),
               DEFAULT SUBPARTITION other_regions )
( START (2002) END (2012) EVERY (1), 
  DEFAULT PARTITION outlying_years );
```

> 小心：当您基于范围信息创建多层分区表时，很容易导致系统创建大量包含很少甚至没有数据的子分区表。  
> 这种情况下，将导致系统信息表中包含大量子分区信息，最终增加优化和执行查询需要的时间和内存。  
> 可以通过增加范围间隔或不同的分区策略来减少创建的子分区数量。

### 4.7.9 对已经存在的进行分区

您只能在创建表时对表进行分区操作。如果您想要对一张进行分区操作，您需要先创建一张分区表，  
从旧表加载数据到新表，删除旧表，并将新的分区表名称改为旧表。您还需要对表的权限进行重新  
授予的操作，例如：

```
CREATE TABLE sales2 (LIKE sales) 
PARTITION BY RANGE (date)
( START (date '2008-01-01') INCLUSIVE
   END (date '2009-01-01') EXCLUSIVE
   EVERY (INTERVAL '1 month') );
INSERT INTO sales2 SELECT * FROM sales;
DROP TABLE sales;
ALTER TABLE sales2 RENAME TO sales;
GRANT ALL PRIVILEGES ON sales TO admin;
GRANT SELECT ON sales TO guest;
```

### 4.7.10 分区表的限制

在每层的分区上，分区表都能创建最多 32,767 个子分区。

分区表的主键或者唯一约束并序包含所有分区的键值列。唯一索引可以不包含分区键值列，  
但是该唯一索引只对分区表部分数据有效，不能对整个分区表生效。

将叶子分区交换为外部表不支持下面情况：被交换的分区是通过 SUBPARTITION  
子句创建或者 被交换的分区包含子分区。  
要了解将叶子分区交换为外部表，请参考 [将叶子分区交换为外部表]()。

下面是分区表的子叶分区是外部表时的一些限制：

* 外部表分区必须是一个可读外部表。任何试图反问和修改外部表数据的命令都会返回  
  失败。例如：

  * INSERT，DELETE 和 UPDATE
    命令都会试图修改外部表分区的数据，将会返回错误。
  * TRUNCATE 命令返回错误。
  * COPY 命令不能将数据拷贝到分区表，因为该操作可能修改外部表分区。
  * COPY  
    命令在试图拷贝包含外部表分区的分区表时，将会返回错误。但是可以通过指定  
    IGNORE EXTERNAL PARTITIONS  
    子句来避免该错误。如果您使用了上面的子句，外  
    部表分区中的数据将不会被拷贝。要想对包含外部表分区的分区表使用  
    COPY 命令， 利用 SQL 查询语句来拷贝数据。例如：如果表 my\_sales  
    包含了一个外部表分区， 下面的命令将会把所有数据输出到标准输出：

    ```
    COPY (SELECT * from my_sales ) TO stdout
    ```

  * VACUUM 将会跳过外部表分区。

* 下列命令在数据不发生改变的情况下能够支持外部表分区。否则，将返回一个错误：

  * 添加或删除列。
  * 变更列的类型。

* 下面的 ALTER PARTITION 操作不支持外部表分区：
  * 设置子分区定义模版。
  * 修改分区属性。
  * 创建默认分区。
  * 设置数据分布键值（DISTRIBUTED BY）。
  * 对数据列添加或删除非空约束。
  * 添加或删除约束。
  * 分裂外部表分区。

### 4.7.11 向分区表加载数据

在创建了分区表结构后，顶层的父表是没有数据的。数据自动地存储到最底层的子分区中。在多  
层分区结构中，只有在结构最底层的子分区表才会包含数据。

如果记录不满足任何子分区表的要求，插入将会被拒绝，数据加载都会失败。要避免不合要求的  
记录在加载时被拒绝导致的失败，可以在定义分区结构时，创建一个默认分区（DEFAULT）。  
任何不满足分区 CHECK 约束记录都会被加载到默认分区。请查看 [增加默认分区]()。

在查询运行时，查询优化器将会扫描整个表的继承结构，使用 CHECK 约束来判断需要扫描哪些  
子分区来满足查询条件。默认分区每次都会被扫描。包含数据的默认分区将会拖慢整体的扫描时  
间。

当使用 COPY 或 INSERT 命令向父表加载数据时，数据将会自动的存储到正确的分区中。

向分区表加载数据的最佳实践就是创建一个中间的临时表，向该表加载数据，然后通过交换分区  
的方式加入到分区表中。请查看 [交换分区]()。

### 4.7.12 验证分区表策略

当您根据查询条件对表进行分区后，可以通过使用 EXPLAIN 命令检查查询计划的方式，来验证  
查询优化器只决定扫描和请求相关的分区数据。

例如，假设图1中的 sales 表是按照日期范围每个月创建一个分区，并且根据地区创建子分区。  
对于下面的查询：

```
EXPLAIN SELECT * FROM sales WHERE date='01-07-12' AND region='usa';
```

上面查询的查询计划应该显示出表扫描只考虑如下分区：

* 默认分区，返回 0-1 条结果（如果创建了默认分区）
* 2012 年 1月分区（sales\_1\_prt\_1）返回 0-1 条
* USA 地区子分区（sales\_1\_2\_prt\_usa）返回多条结果

下面是查询计划的部分内容：

```
->  Seq Scan on sales_1_prt_1 sales (cost=0.00..0.00 rows=0 width=0)
        Filter: "date"=01-07-08::date AND region='USA'::text
->  Seq Scan on sales_1_2_prt_usa sales (cost=0.00..9.87 rows=20 width=40)
```

您需要确保优化器没有扫描不必要的分区或子分区（例如：扫描了查询中没有指定的时间或地区），  
并且顶层表返回 0-1 行结果。

### 4.7.13 排查选择性分区扫描

下面的限制可能导致查询计划显示出没有选择部分分区表结构的情况。

* 查询优化器只能在查询使用直接和简单的限制条件和不变运算符（immutable
  operator）， 进行选择性分区扫描。例如： =， \&lt;， \&lt;= ， &gt;， &gt;= 和
  \&lt;&gt;。
* 选择性的扫描只能支持稳定函数（STABLE）和不变函数（IMMUTABLE），不支持易变
  （VOLATILE）函数。例如，当 WHERE 子句中包含 date &gt; CURRENT\_DATE
  时，查询优化 器可以选择性的扫描分区表，但是 time &gt; TIMEOFDAY
  就不会使用选择性分区扫描。

### 4.7.14 查看分区表设计

通过 pg\_partitions 视图，您可以查看分区表设计信息。下面示例可以查看  
sales 表 的分区设计信息：

```
SELECT partitionboundary, partitiontablename, partitionname, 
partitionlevel, partitionrank 
FROM pg_partitions 
WHERE tablename='sales';
```

如下表和视图向您提供分区表相关信息：

* pg\_partition - 跟踪分区表及其继承关系信息。
* pg\_partition\_templates - 创建子分区使用的子分区模版信息。
* pg\_partition\_columns - 分区表分区键值信息。

### 4.7.15 分区表的维护

要维护分区表，可以对顶层的分区表（根表）使用 ALTER TABLE  
命令。最常见的维护场景就  
是对于范围分区的设计，通过删除旧分区，创建新分区，来维护一个特定数据窗口。您还可以将  
旧分区转换（exchange）成追加表格式，并使用压缩方式来节省磁盘的存储空间。如果您的分区  
表包含了一个默认分区，可以通过分裂默认分区来添加新的分区。

* 增加分区
* 重命名分区
* 增加默认分区
* 删除分区
* 清空分区
* 交换分区
* 分裂分区
* 修改子分区模版
* 将叶子分区交换为外部表

重要：在定义或修改分区表时，请指定分区名称（不是表名称）。尽管您可以直接通过  
SQL 命令 直接对表（或分区表）进行查询或数据加载操作。但是您只能通过  
ALTER TABLE ... PARTITION 子句来修改分区表的结构。

分区的名称可以省略。如果一个分区没有名字，使用下面的表达式可以指定分区：

```
PARTITION FOR (value)

PARTITION FOR(RANK(number))
```

### 4.7.16 增加分区

您可以通过 ALTER TABLE  
命令向已有的分区表中添加新的分区。如果原始的分区表包含了用来  
定义子分区的子分区模版，新增加的分区会根据模版信息创建子分区。例如：

```
ALTER TABLE sales ADD PARTITION 
            START (date '2009-02-01') INCLUSIVE 
            END (date '2009-03-01') EXCLUSIVE;
```

如果在创建表时没有指定子分区模版，增加新分区时，您需要指定子分区信息：

```
ALTER TABLE sales ADD PARTITION 
            START (date '2009-02-01') INCLUSIVE 
            END (date '2009-03-01') EXCLUSIVE
      ( SUBPARTITION usa VALUES ('usa'), 
        SUBPARTITION asia VALUES ('asia'), 
        SUBPARTITION europe VALUES ('europe') );
```

当您向已经存在的分区增加子分区时，需要指定分区来进行操作：

```
ALTER TABLE sales ALTER PARTITION FOR (RANK(12))
      ADD PARTITION africa VALUES ('africa');
```

注意：您不能向包含默认分区的分区表中增加新分区。您需要通过将默认分区分裂来增加分区。  
参考 [分裂分区]()

### 4.7.17 重命名分区

下面列出分区表命名规则。分区表的字表名称需要保证唯一性且遵守名称长度限制。

```
<parentname>_<level>_prt_<partition_name>
```

一个字表的名称示例：

```
sales_1_prt_jan08
```

对于自动生成的范围分区表，如果您没有指定分区名称，将会自动分配一个数值来生成分区名：

```
sales_1_prt_1
```

要修改分区表的子表名称，需要对顶层父表运行重命名操作。修改将会作用在所有相关的子表  
分区之上。下面示例的命令：

```
ALTER TABLE sales RENAME TO globalsales;
```

将修改相关的子表名称为：

```
globalsales_1_prt_1
```

您可以修改指定分区名称，来更加便捷的识别子分区：

```
ALTER TABLE sales RENAME PARTITION FOR ('2008-01-01') TO jan08;
```

操作将修改相关的子表名称为：

```
sales_1_prt_jan08
```

当使用 ALTER TABLE 命令修改分区表时，需要使用分区名称（jan08），不要使用完整的表名（sales\_1\_prt\_jan08）。

> 注意：在 ALTER TABLE 语句时，你不能提供分区名称。例如：ALTER TABLE sales... 是正确的，ALTER TABLE sales\_1\_part\_jan08... 是不允许的。

### 4.7.18 增加默认分区

您可以使用 ALTER TABLE 来向分区表中增加默认分区。

```
ALTER TABLE sales ADD DEFAULT PARTITION other;
```

如果您的分区表是多层的，那么每一层结构都需要包含默认分区：

```
ALTER TABLE sales ALTER PARTITION FOR (RANK(1)) ADD DEFAULT PARTITION other;

ALTER TABLE sales ALTER PARTITION FOR (RANK(2)) ADD DEFAULT PARTITION other;

ALTER TABLE sales ALTER PARTITION FOR (RANK(3)) ADD DEFAULT PARTITION other;
```

如果输入的数据不满足分区的 CHECK 约束条件，并且没有创建默认分区，数据将被拒绝插入。  
默认分区能够保证在输入数据不满足分区时，能够将数据插入到默认分区。

### 4.7.19 删除分区

您可以通过 ALTER TABLE  
命令从分区表中删除分区。如果您要删除的分区包含子分区，删除操  
作将会自动地将子分区（及其数据）删除。对于范围分区来说，通常是将较老的分区对应范围删除，  
这样来将数据仓库的旧删除删除掉。例如：

```
ALTER TABLE sales DROP PARTITION FOR (RANK(1));
```

### 4.7.20 清空分区

您可以通过 ALTER TABLE  
命令来清空分区。如果您要清空的分区包含子分区，清空操  
作将会自动地将子分区清空。

```
ALTER TABLE sales TRUNCATE PARTITION FOR (RANK(1));
```

### 4.7.21 交换分区

您可以通过 ALTER TABLE  
命令来交换分区。交换分区是将一张数据表与已经存在的分区进行数  
据文件交换。你只能交换分区结构中最底层的分区（只有包含数据的分区才能被交换）。

分区交换对于数据加载非常有帮助。例如：将数据加载到临时表，再食用交换命令将临时表加载到  
分区表中。您还可以使用交换分区的方式将旧表的存储结构更改为追加表格式。例如：

```
CREATE TABLE jan12 (LIKE sales) WITH (appendonly=true);
INSERT INTO jan12 SELECT * FROM sales_1_prt_1 ;
ALTER TABLE sales EXCHANGE PARTITION FOR (DATE '2012-01-01') 
WITH TABLE jan12;
```

注意：这个例子使用的是单层分区定义的 sales 表，这里的 sales  
表是没有运行前面示例操作 时候的状态。 警告：如果您指定了 WITHOUT  
VALIDATION 子句，您必须保证用来交换的表中的数据是符合分区  
约束条件的。否则，当查询涉及到该分区时，返回的查询结果可能不正确。

HashData 数据仓库服务器配置参数 gp\_enable\_exchange\_default\_partition  
参数用来控制 是否允许使用 EXCHANGE DEFAULT PARTITION 子句. 在  
HashData 数据仓库中，此参数默认值 为 off，当您在 ALTER TABLE  
命令中使用此子句时，将会得到错误提示。

警告：在交换默认分区前，您必须确保将要交换的表中的数据（也就是新的默认分区）是符合默认  
分区定义的。例如，新默认分区中的已经存在的数据不能是满足分区表中其他分区条件的数据。  
否则，当查询涉及到使用交换后默认分区的时，查询结果可能不正确。

### 4.7.22 分裂分区

分裂分区能够将一个分区，分成两个分区。您可以使用 ALTER TABLe  
命令来分裂分区。您只能  
在分区结构的最底层进行分裂操作（只能分裂包含数据的分区）。满足您提供用于分裂值的数据，  
将会存放到您提供的第二个分区中。

下面示例向您展示，将一个按月划分的分区，分裂成两个独立的分区。第一个分区包含1月1日到  
1月15日的数据，第二个分区包含1月16日到1月31日的数据：

```
ALTER TABLE sales SPLIT PARTITION FOR ('2008-01-01')
AT ('2008-01-16')
INTO (PARTITION jan081to15, PARTITION jan0816to31);
```

如果您的分区表中包含默认分区，您必须通过分裂默认分区的方式来增加新的分区。

当您使用 INTO  
子句时，您需要将默认分区做为第二个分区名称。下面示例向您展示，将一个  
默认按照范围分区的分区表，增加一个专门保存2009年1月数据的分区的语句：

```
ALTER TABLE sales SPLIT DEFAULT PARTITION 
START ('2009-01-01') INCLUSIVE 
END ('2009-02-01') EXCLUSIVE 
INTO (PARTITION jan09, default partition);
```

### 4.7.23 修改子分区模版

您可以使用 ALTER TABLE SET SUBPARTITION TEMPLATE  
来修改分区表的子分区模版定义。  
在您修改子分区表模版定义后添加的分区将按照新的分区定义创建。但是对于已经存在分区，  
新的定义将不会生效。

下面示例介绍修改分区表的子分区表模版定义：

```
CREATE TABLE sales (trans_id int, date date, amount decimal(9,2), region text)
  DISTRIBUTED BY (trans_id)
  PARTITION BY RANGE (date)
  SUBPARTITION BY LIST (region)
  SUBPARTITION TEMPLATE
    ( SUBPARTITION usa VALUES ('usa'),
      SUBPARTITION asia VALUES ('asia'),
      SUBPARTITION europe VALUES ('europe'),
      DEFAULT SUBPARTITION other_regions )
  ( START (date '2014-01-01') INCLUSIVE
    END (date '2014-04-01') EXCLUSIVE
    EVERY (INTERVAL '1 month') );
```

接下来执行下面命令修改上面的子分区模版定义：

```
ALTER TABLE sales SET SUBPARTITION TEMPLATE
( SUBPARTITION usa VALUES ('usa'), 
  SUBPARTITION asia VALUES ('asia'), 
  SUBPARTITION europe VALUES ('europe'),
  SUBPARTITION africa VALUES ('africa'), 
  DEFAULT SUBPARTITION regions );
```

当您向 sales 表中增加一个按日期分隔的范围分区时，它将包含新的地区列表对应的子分区 Africa。例如下面的示例，将会创建子分区：usa，asia，europe，africa  和一个名叫 regions 的默认分区：

```
ALTER TABLE sales ADD PARTITION "4"
  START ('2014-04-01') INCLUSIVE 
  END ('2014-05-01') EXCLUSIVE ;
```

要查看分区表 sales 对应创建的子表，你可以使用 psql 命令行工具，并使用命令： \d sales\*。

要删除子分区模版定义，使用 SET SUBPARTITION TEMPLATE 子句，并使用圆括号提供一个  
空定义即可。例如下面示例用来清空子分区模版定义：

```
ALTER TABLE sales SET SUBPARTITION TEMPLATE ();
```

### 4.7.24 将叶子分区交换为外部表

您可以将分区表的叶子分区交换为可读外部表（readable external  
table）。外部表数据可 以外部数据源上，例如：青云对象存储。

例如，您有一张按月份分区的分区表，在该表上的查询主要访问较新的数据，您可以将旧数据和访  
问较少的数据拷贝到外部表，最后将该分区与外部表进行交换分区。对于之访问新数据的查询，您  
还可以利用分区消除来阻止扫描数据较旧和不必要的分区。

在下面的情况下，您不能交换叶子分区和外部表：

* 被交换的分区是通过 SUBPARTITION 子句创建或者被交换的分区包含子分区。
* 分区表中某个列上带有 CHECK 约束或非空约束。

要了解包含外部表的分区表限制，可以参考 分区表的限制\_。

示例：将分区交换为外部表

这里给出一个简单的例子，该例子将分区表中的叶子分区交换为一张外部表。分区表包含的数据  
从 2000 年到 2003 年。

```
CREATE TABLE sales (id int, year int, qtr int, day int, region text)
  DISTRIBUTED BY (id) 
  PARTITION BY RANGE (year) 
  ( PARTITION yr START (2000) END (2004) EVERY (1) ) ;
```

这张分区表包含了四张叶子分区。每隔叶子分区包含了一年的数据。叶子分区  
sales\_1\_prt\_yr\_1 包含了 2000 年的数据。下面的步骤将该分区交换为使用  
gpfdist 协议的外部表：

1. 确保 HashData 数据仓库系统开启了外部表协议。 下面示例使用 gpfdist  
   协议。示例命令将会启动 gpfdist 协议服务器：

   ```
   $ gpfdist
   ```

2. 创建可写外部表（writable external table）。 下面的 CREATE WRITABLE  
   EXTENAL TABLE 命令创建一个可写外部表，该表列定义与分区表  
   列定义相同。

   ```
   CREATE WRITABLE EXTERNAL TABLE my_sales_ext ( LIKE sales_1_prt_yr_1 )
     LOCATION ( 'gpfdist://gpdb_test/sales_2000' )
     FORMAT 'csv' 
     DISTRIBUTED BY (id) ;
   ```

3. 创建一张可读外部表，该外部表将会从上一步创建的可写外部表的位置读取数据。  
   下面的 CREATE EXTENAL TABLE  
   命令创建的外部表将会使用与可写外部表相同的数据。

   ```
   CREATE EXTERNAL TABLE sales_2000_ext ( LIKE sales_1_prt_yr_1) 
     LOCATION ( 'gpfdist://gpdb_test/sales_2000' )
     FORMAT 'csv' ;
   ```

4. 将数据从叶子分区拷贝到可写外部表。 下面的 INSERT  
   命令将会把分区表中叶子分区的数据拷贝到外部表中。

   ```
   INSERT INTO my_sales_ext SELECT * FROM sales_1_prt_yr_1 ;
   ```

5. 交换叶子分区和外部表。 下面的 ALTER TABLE 命令指出 EXCHANGE  
   PARTITION 子句，用来将可读外部表和叶子分 区交换。

   ```
   ALTER TABLE sales ALTER PARTITION yr_1 
      EXCHANGE PARTITION yr_1 
      WITH TABLE sales_2000_ext WITHOUT VALIDATION;
   ```

   外部表将会变成叶子分区，并且名称为  
   sales\_1\_prt\_yr\_1，而原来的叶子分区将会成为表 sales\_2000\_ext。

   警告：为了确保运行在分区表上的查询结果正确，外部表数据必须符合叶子分区的  
   CHECK 约 束条件。在这个例子中，数据是从带有 CHECK  
   约束条件的叶子分区表中读取的。

6. 删除从分区表中换出的表。

   ```
   DROP TABLE sales_2000_ext ;
   ```

你可以重命名叶子分区的名称来标识出 sales\_1\_prt\_yr\_1 是一张外部表。

下面示例的命令将会把分区名称改为 yr\_1\_ext 最终的叶子分区表名称为  
sales\_1\_prt\_yr\_1\_ext。

```
ALTER TABLE sales RENAME PARTITION yr_1 TO  yr_1_ext ;
```

## 4.8. 创建和使用序列

通过使用序列，系统可以在新的纪录插入表中时，自动地按照自增方式分配一个唯一ID。使用序列一般就是为插入表中的纪录自动分配一个唯一标识符。您可以通过声明一个  
SERIAL 类型的标识符列，该类型将会自动创建一个序列来分配ID。

### 4.8.1 创建序列

CREATE SEQUENCE  
命令用来创建和初始化一张特殊的单行序列生成器表，该表名称就是指定序列的名称。序列的名称在同一个模式下，不能与其它序列，表，索引或者视图重名。示例：

```
CREATE SEQUENCE myserial START 101;
```

### 4.8.2 使用序列

在使用 CREATE SEQUENCE 创建系列生成器表后，可以通过 nextval  
函数来使用序列。例如下面例子，向表中插入新数据时，自动获得下一个序列值：

```
INSERT INTO vendors VALUES (nextval('myserial'), 'acme');
```

还可以通过使用函数 setval 来重置序列的值。示例：

```
SELECT setval('myserial', 201);
```

请注意 nextval  
操作是不会回滚的，数值一旦被获取，即使最终事务回滚，该数据也被认为已经被分配和使用了。这意味着失败的事务会给序列分配的数值中留下空洞。类似地，setval操作也不支持回滚。

通过下面的查询，可以检查序列的当前值：

```
SELECT * FROM myserial;
```

### 4.8.3 修改序列

ALTER SEQUENCE 命令可以修改已经存在的序列生成器参数。例如：

```
ALTER SEQUENCE myserial RESTART WITH 105;
```

### 4.8.4 删除序列

DROP SEQUENCE 命令删除序列生成表。例如：

```
DROP SEQUENCE myserial;
```

## 4.9. 使用索引

在绝大部分传统数据中，索引都能够极大地提高数据访问速速。然而，在像 HashData 数据仓库这样的分布式数据库系统中，索引的使用需要更加谨慎。

HashData 数据仓库执行顺序扫描的速度非常快，索引只用来随机访问时，在磁盘上定位特定数据。由于数据是分散在多个节点上的，因此每个节点数据相对更少。再加上使用分区表功能，实际的顺序扫描可能更小。因为商业智能\(BI\)类应用通常返回较大的结果数据，因此索引并不高效。

请尝试在没有索引的情况下，运行查询。一般情况下，对于OLTP类型业务，索引对性能的影响更大。因为这类查询一般只返回一条或较少的数据。对于压缩的 append 表来说，对于返回一部分数据的查询来说性能也能得到提高。这是因为优化器可以使用索引访问来避免使用全表的顺序扫描。对于压缩的数据，使用索引访问方法时，只有需要的数据才会被解压缩。

HashData 数据仓库对于包含主键的表自动创建主键约束。要对分区表创建索引，只需要在分区表上创建索引即可。HashData 数据仓库能够自动在分区表下的分区上创建对应索引。HashData 数据仓库  
不支持对分区表下的分区创建单独的索引。

请注意，唯一约束会隐式地创建唯一索引，唯一索引会包含所有数据分布键和分区键。唯一约束是对整个表范围保证唯一性的（包括所有的分区）。

索引会增加数据库系统的运行开销，它们占用存储空间并且在数据更新时，需要额外的维护工作。请确保查询集合在使用您创建的索引后，性能得到了改善（和全表顺序扫描相比）。您可以使用 EXPLAIN 命令来确认索引是否被使用。

创建索引时，您需要注意下面的问题点：

* 您的查询特点。索引对于查询只返回单条记录或者较少的数据集时，性能提升明显。
* 压缩表。对于压缩的 append 表来说，对于返回一部分数据的查询来说性能也能得到提高。对于压缩的数据，使用索引访问方法时，只有需要的数据才会被解压缩。
* 避免在经常改变的列上创建索引。在经常更新的列上创建索引会导致每次更新数据时写操作大量增加。
* 创建选择率高的 B-树索引。索引选择率是列的唯一值除以记录数的比值。例如，一张表有
  1000 条记录，其中有 800 个唯一值，这个列索引的选择率就是
  0.8，这个数值就比较好。唯一索引的选择率总是
  1.0，也是选择率最好的。HashData 数据仓库
  只允许创建包含表数据分布键的唯一索引。
* 对于选择率较低的列，使用 Bitmap 索引。
* 对参与连接操作的列创建索引。对经常用于连接的列（例如：外键列）创建索引，可以让查询优化器使用更多的连接算法，进而提高连接效率。
* 对经常出现在 WHERE 条件中的列创建索引。
* 避免创建冗余的索引。如果索引开头几列重复出现在多个索引中，这些索引就是冗余的。
* 在大量数据加载时，删除索引。如果要向表中加载大量数据，考虑加载数据前删除索引，加载后重新建立索引的方法。这样的操作通常比带着索引加载要快。
* 考虑聚簇索引。聚簇索引是指数据在物理上，按照索引顺序存储。如果您访问的数据在磁盘是随机存储，那么数据库就需要在磁盘上不断变更位置读取您需要的数据。如果数据更佳紧密的存储起来，读取数据的操作效率就会更高。例如：在日期列上创建聚簇索引，数据也是按照日期列顺序存储。一个查询如果读取一个日期范围的数据，那么就可以利用磁盘顺序扫描的快速特性。

### 4.9.1  聚簇索引

对一张非常大的表，使用 CLUSTER  
命令来根据索引对表的物理存储进行重新排序可能花费非常长的时间。您可以通过手工将排序的表数据导入一张中间表，来加上面的操作，例如：

```
CREATE TABLE new_table (LIKE old_table) 
       AS SELECT * FROM old_table ORDER BY myixcolumn;
DROP old_table;
ALTER TABLE new_table RENAME TO old_table;
CREATE INDEX myixcolumn_ix ON old_table;
VACUUM ANALYZE old_table;
```

### 4.9.2 索引类型

HashData 数据仓库支持 Postgres 中索引类型 B树 和 GiST。索引类型 Hash 和  
GIN  
索引不支持。每一种索引都使用不同算法，因此适用的查询也不同。B树索引适用于大部分常见情况，因此也是默认类型。您可以参考  
PostgreSQL 文档中关于索引的相关介绍。

注意：唯一索引使用的列必须和表的分布键值一样（或超集）。append-optimized  
存储类型的表不支持唯一索引。对于分区表来说，唯一索引不能对整张表（对所有子表）来保证唯一性。唯一索引可以对于一个子分区保证唯一性。

### 4.9.3 关于 Bitmap 索引

HashData 数据仓库提供了 Bitmap 索引类型。Bitmap  
索引特别适合大数据量的数据仓库应用和决策支持系统这种查询，临时性查询特别多，数据改动少的业务。

索引提供根据指定键值指向表中记录的指针。一般的索引存储了每个键值对应的所有记录ID映射关系。而  
Bitmap  
索引是将键值存储为位图形式。一般的索引可能会占用实际数据几倍的存储空间，但是  
Bitmap 索引在提供相同功能下，需要的存储远远小于实际的数据大小。

位图中的每一位对应一个记录ID。如果位被设置了，该记录ID指向的记录满足键值。一个映射函数负责将比特位置转换为记录ID。位图使用压缩进行存储。如果键值去重后的数量比较少，bitmap  
索引相比普通的索引来说，体积非常小，压缩效果更好，能够更好的节省存储空间。因此  
bitmap 索引的大小可以近似通过记录总数乘以索引列去重后的数量得出。

对于在 WHERE 子句中包含多个条件的查询来说，bitmap  
索引一般都非常有效。如果在访问数据表之前，就能过滤掉只满足部分条件的记录，那么查询响应时间就会得到巨大的提升。

### 4.9.4 何时使用 Bitmap 索引

Bitmap索引特别适用数据仓库类型的应用程序，因为数据的更新相对非常少。Bitmap索引对于去重后列值在  
100 到 10,0000  
个，并且查询时经常是类似这样的多列参一起使用的查询性能提升非常明显。但是像性别这种只有两个值的类型，实际上索引并不能提供比较好的性能提升。如果去重后的值多余  
10,0000 个，bitmap 索引的性能收益和存储效率都会开始下降。

Bitmap 索引对于临时性的查询性能改进比较明显。在 WHERE 子句中的 AND 和 OR  
条件来说，可以利用 bitmap  
索引信息快速得到满足条件的结果，而不用首先读取记录信息。如果结果集数据很少，查询就不需要使用全表扫描，并且能非常快的返回结果。

### 4.9.5 不适合使用 Bitmap 索引的情况

如果列的数据唯一或者重复非常少，就应该避免使用bitmap索引。bitmap索引的性能优势和存储优势在列的唯一值超过10,0000后就会开始下降。与表中的总纪录数没有任何关系。  
Bitmap索引也不适合并发修改数据事务特别多的OLTP类型应用。  
使用bitmap索引应该谨慎，仔细对比建立索引前后的查询性能。只添加那些对查询性能有帮助的索引。

### 4.9.6 创建索引

CREATE INDEX 命令可以给指定的表定义索引。索引的默认类型是：B 树索引。下面例子给表  
employee 的 gender 列，添加了一个 B 树索引：

```
CREATE INDEX gender_idx ON employee (gender);
```

为 films 表的 title 列创建 bitmap 索引：

```
CREATE INDEX title_bmp_idx ON films USING bitmap (title);
```

### 4.9.7 检查索引的使用情况

HashData 数据仓库索引不需要维护和调优。你可以通过真实的查询来检查索引的使用情况。EXPLAIN  
命令可以用来检查一个查询使用索引的情况。  
查询计划用来显示数据库为了回答您的查询所需要的步骤和使用的计划节点类型，并给出每个节点的时间开销评估。要检查索引的使用情况，可以通过检查  
EXPLAIN 中包含的查询计划节点来进行输出中下面查询：

* Index Scan - 扫描索引
* Bitmap Heap Scan - 根据 BitmapAnd， BitmapOr，或 BitmapIndexScan
  生成位图，从 heap 文件中读取相应的记录。
* Bitmap Index Scan
  -通过底层的索引，生成满足多个查询的条件的位图信息。
* BitmapAnd 或 BitmapOr - 根据多个 BitmapIndexScan
  生成的位图进行位与和位或运算，生成新的位图。

创建索引前，您需要做一些实验来决定如何创建索引，下面是一些您需要考虑的地方：

* 当你创建或更新索引后，最好运行 ANALYZE 命令。ANALYZE
  针对表收集统计信息。查询优化器会利用表的统计信息来评估查询返回的结果数量，并且对每种查询计划估算更真实的时间开销。
* 使用真实数据来进行实验。如果利用测试数据来决定添加索引，那么你的索引只是针对测试数据进行了优化。
* 不要使用可能导致结果不真实或者数据倾斜的小数据集进行测试。
* 设计测试数据时需要非常小心。测试数据如果过于相似，完全随机，按特定顺序导入，都可能导致统计数据与真实数据分布的巨大差异。
* 你可以通过调整运行时参数来禁用某些特定查询类型，这样可以更加针对性对索引使用进行测试。例如：关闭顺序扫描（enable\_seqscan）和嵌套连接（enable\_nestloop），及其它基础查询计划，可以强制系统选择其它类型的查询计划。通过对查询计时和利用
  EXPLAIN ANALYZE 命令来对比使用和不使用索引的查询结果。

### 4.9.8 索引管理

使用 REINDEX 命令可以对性能不好的索引进行重新创建。REINDEX  
重建是对表中数据重建并替换旧索引实现的。

在指定表上重新生成所有索引：

```
REINDEX my_table;
```

对指定索引重新生成：

```
REINDEX my_index;
```

### 4.9.9 删除索引


DROP INDEX 命令删除一个索引，例如：

```
DROP INDEX title_idx;
```

加载数据时，可以通过首先删除索引，加载数据，再重新建立索引的方式加快数据加载速度。

## 4.10. 创建和管理视图

视图能够将您常用或复杂的查询保存起来，并允许您在 SELECT 语句中像访问表一样访问保存的查询。视图并不会导致在磁盘上存储数据，而是在访问视图时，视图定义的查询以自查询的方式被饮用。

如果某个自查询只被某个特定查询使用，考虑使用 SELECT 语句的 WITH 子句来避免创建一张不能被公用的视图。

### 4.10.1 创建视图

CREATE VIEW 命令根据一个查询定义一个视图，例如：

```
CREATE VIEW comedies AS SELECT * FROM films WHERE kind = 'comedy';
```

视图会忽略视图定义查询中的 ORDER BY 和 SORT 的功能。

### 4.10.2 删除视图

DROP VIEW 删除一张视图，例如:

```
DROP VIEW topten;
```



