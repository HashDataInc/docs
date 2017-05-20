.. include:: ../../defines.hrst

导入和导出数据
==============

本节的主题是描述如何高效地往 |product-name| 导入数据和从 |product-name| 往外导出数据，以及如何格式化导入的文件格式。

|product-name| 支持高效地并发导入和导出数据功能，利用 |cloud-provider| 的对象存储，可以与不同系统更加简单地进行数据交换操作。

通过使用外部表，|product-name| 让您能够通过 SQL 命令在数据库内直接利用并行机制访问外部数据资源，例如：SELECT，JOIN，ORDER BY 或者在外部表上创建视图。
外部表一般用来将外部数据导入到数据库内部普通表，例如：

.. code-block:: sql

        CREATE TABLE table AS SELECT * FROM ext_table;


通过外部表访问对象存储
----------------------

CREATE EXTERNAL TABLE 可以创建可读外部表。外部表允许 |product-name| 将外部数据源当作数据库普通表来进行处理。

使用青云对象存储
^^^^^^^^^^^^^^^^

通过在外部表的 LOCATION 子句，您可以指定青云对象存储的位置和访问键值。这样，在每次使用 SQL 命令读取外部表时，|product-name| 会将青云对象存储中该目录下的所有数据文件读取到数据库中进行处理。
如果您需要多次处理该数据，建议您通过 CREATE TABE table AS SELECT * FROM ext_table 的方式，将对象存储的数据导入到 |product-name| 的内置表。这样可以更好的利用优化过的存储结构来优化您的数据分析流程。

您可以通过如下的语法来定义访问青云对象存储上面数据的外部表：

.. code-block:: sql

	CREATE READABLE EXTERNAL TABLE foo (name TEXT, id INT)
	LOCATION ('qs://<your-bucket-name>.pek3a.qingstor.com/<your-data-path> access_key_id=<access-key-id> secret_access_key=<secret-access-key>') FORMAT 'csv';
	
您需要将其中的<your-bucket-name>、<your-data-path>、<access-key-id>和<secret-access-key>替换成您自己相应的值。

下面的示例，向您展示如何从青云对象存储中直接读取 1GB 规模 TPCH 测试数据的例子。由于示例中的bucket hashdata-public是公开只读的，因此您不指定access_key_id
和secret_access_key也能够访问。

.. code-block:: sql

    CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/nation/') FORMAT 'csv';
        
    CREATE READABLE EXTERNAL TABLE e_REGION (LIKE REGION)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/region/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_PART (LIKE PART)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/part/') FORMAT 'csv';
        
    CREATE READABLE EXTERNAL TABLE e_SUPPLIER (LIKE SUPPLIER)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/supplier/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_PARTSUPP (LIKE PARTSUPP)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/partsupp/') FORMAT 'csv';
        
    CREATE READABLE EXTERNAL TABLE e_CUSTOMER (LIKE CUSTOMER)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/customer/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_ORDERS (LIKE ORDERS)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/orders/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_LINEITEM (LIKE LINEITEM)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/lineitem/') FORMAT 'csv';

处理错误
--------

可读外部表最常用于将数据导入到数据库内置表中。您可以通过使用 CREATE TABLE AS SELECT 或 INSERT INTO 命令从外部表读取数据。默认情况下，如果数据中包含格式错误的行，整个命令都会失败，数据不会被成功地加载到目标的数据表中。

SEGMENT REJECT LIMIT 子句允许您将外部表中格式错误的数据进行隔离，继续导入格式正确的数据。使用 SEGMENT REJECT LIMIT 命令设定一个阈值，用 ROWS 指定拒绝的错误记录行数（默认），或者 PERCENT 指定拒绝的错误记录百分比（1-100）。

如果错误的行数到达 SEGMENT REJECT LIMIT 指定的值，整个外部表操作将会终止。错误行数的限制是根据每个加载节点单独计算的。加载操作将会正常处理格式正确的记录，如果错误的记录数没有超过 SEGMENT REJECT LIMIT，跳过格式错误的记录，并将其保存在错误记录中。

LOG ERRORS 子句允许您保留错误记录信息，在命令执行后进一步排查问题。要了解 LOG ERRORS 子句的使用方法，请参考 CREATE EXTERNAL TABLE 命令。

当你使用了 SEGMENT REJECT LIMIT 子句，|product-name| 将会在单行错误隔离模式下扫描外部数据。单行错误隔离模式将会为外部数据记录附加额外的格式错误信息，例如：不一致的列值，错误的列数据类型，非法的客户端编码序列。|product-name| 不会进行约束错误检查，但是您可以通过在使用 SELECT 命令处理外部表时，增加必要的过滤限制条件。例如，下面的例子可以消除重复键值的错误：

.. code-block:: sql

	=# INSERT INTO table_with_pkeys 
	   SELECT DISTINCT * FROM external_table;

*注意*：当使用外部表加载数据时，服务器配置参数 gp_initial_bad_row_limit 用来限制在最开始处理时，最多多少行不能遇到错误记录。默认设置为如果在前 1000 行中遇到错误记录，就会停止后续处理。

定义使用单行错误隔离的外部表
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

下面的例子将会将错误记录保存在 |product-name| 内部，并且设置错误阈值为 10 条记录：

.. code-block:: sql

	=# CREATE EXTERNAL TABLE ext_expenses ( name text, 
	   date date,  amount float4, category text, desc1 text ) 
	   LOCATION ('qs://hashdata-public.pek3a.qingstor.com/ext_expenses/')
	   FORMAT 'TEXT' (DELIMITER '|')
	   LOG ERRORS SEGMENT REJECT LIMIT 10 
	   ROWS;

通过使用内置 SQL 函数 gp_read_error_log('external_table') 可以读取错误记录数据。下面的示例命令可以显示 ext_expenses 的错误记录：

.. code-block:: sql

	SELECT gp_read_error_log('ext_expenses');

要了解更多关于错误记录信息，请参考 `在错误日志中查看错误记录`_。

内置 SQL 函数 gp_truncate_error_log('external_table') 可以删除错误记录。下面的例子用来删除之前访问外部表时记录的错误数据：

.. code-block:: sql

	SELECT gp_truncate_error_log('ext_expenses'); 

捕获记录格式错误和声明拒绝错误记录限制
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

下面的 SQL 语句片段用来在 |product-name| 中捕获格式错误，并声明最多拒绝 10 条错误记录的限制。

::

	LOG ERRORS SEGMENT REJECT LIMIT 10 ROWS


在错误日志中查看错误记录
^^^^^^^^^^^^^^^^^^^^^^^^

如果您使用单行错误隔离模式（参考 `定义使用单行错误隔离的外部表`_），格式错误的记录信息将会被记录在数据库内部。


通过使用内置 SQL 函数 gp_read_error_log('external_table') 可以读取错误记录数据。下面的示例命令可以显示 ext_expenses 的错误记录：

.. code-block:: sql

	SELECT gp_read_error_log('ext_expenses');

优化数据加载和查询性能
----------------------

下面的小建议可以帮助您优化数据加载和加载后的查询性能。

* 如果您向已经存在的数据表加载数据，可以考虑先删除索引（如果该表已经建了索引的话）。在数据上重新创建索引的速度远远快于在已有索引上逐行插入的性能。您还可以临时地增加 maintenance_work_mem 服务器参数来优化 CREATE INDEX 命令的创建参数（该参数可能影响数据库加载性能）。建议您在系统没有活跃操作时删除和重新创建索引。
* 如果您向新的数据表加载数据，请在数据加载完毕后再创建索引。推荐的步骤是：创建表，加载数据，创建必要的索引。
* 数据加载完毕后，运行 ANALYZE 命令。如果您操作影响的数据非常多，建议运行 ANALYZE 或者 VACUUM ANALYZE 命令来更新系统的统计信息，这样优化器可以利用最新的信息，更好的优化查询。最新的统计信息能够对查询进行更加精确的优化，从而避免由于统计信息不准确或者不可用时，导致查询性能非常差。
* 在数据加载出错后，运行 VACUUM 命令。如果数据加载操作没有使用错误记录隔离模式，加载操作将在遇到的第一个错误处停止。这时已经加载的数据虽然不会被访问到，但是他们已经占用了磁盘上的存储空间。请运行 VACUUM 命令来回收这些浪费的空间。
* 合理使用表分区技术可以简化数据的维护工作。

从 |product-name| 导出数据
--------------------------

通过使用可写外部表，您可以将 |product-name| 中的数据表导出成外部通用文件格式。通过可写外部数据表，您可以简单的实现多系统互联。未来，|product-name| 还会支持更多导出功能，让您能够轻松的利用不同数据处理平台，来优化您的数据处理体验。

本章节向您介绍如何利用可写外部表将数据库内部数据导出到外部存储。

使用青云对象存储
^^^^^^^^^^^^^^^^

|product-name| 充分考虑云平台优势，因此提供利用高效的青云对象存储来作为数据导出目的地。|product-name| 将会利用其自身并行的架构将数据并行写入到青云对象存储。

下面的例子向您介绍如何利用青云对象存储作为可写外部表的输出目标。

.. code-block:: sql

    CREATE WRITABLE EXTERNAL TABLE test_writable_table (id INT, date DATE, desc TEXT)
        location('qs://<your-bucket-name>.pek3a.qingstor.com/<your-data-path> access_key_id=<access-key-id> secret_access_key=<secret-access-key>') FORMAT 'csv';

    INSERT INTO test_writable_table VALUES(1, '2016-01-01', 'qingstor test');

在实际使用的时候，您需要将<your-bucket-name>、<your-data-path>、<access-key-id>和<secret-access-key>换成您自己相应的值。

格式化数据文件
--------------

在使用 |cloud-provider| 对象存储来进行数据的导入导出时，需要您指定数据的格式信息。CREATE EXTERNAL TABLE 允许您描述数据的存储格式。数据可以是使用特定分隔符的文本文件或者逗号分隔值的 CSV 格式。只有格式正确的数据才能被 |product-name| 正确读取。本小结向您介绍 |product-name| 期望的数据文件格式。

数据行的格式
^^^^^^^^^^^^

|product-name| 期望数据行使用 LF 字符（Line feed，0x0A），CR（Carriage return，0x0D），或者 CR 和 LF（CR+LF，0x0D 0x0A）。LF 是 UNIX 或类 UNIX 操作系统上标准的换行符。像 Windows 或者 Mac OS X 使用 CR 或 CR+LF。|product-name| 能够支持前面提到的三种换行的表示形式。

数据列的格式
^^^^^^^^^^^^

对于文本文件和 CSV 文件来说，默认的列分隔符分别是 TAB 字符（0x09）和逗号（0x2C）。您也可以通过 CREATE EXTERNAL TABLE 语句的  DELIMITER 子句为数据文件指定一个字符作为分隔符。分隔符字符需要在两个数据字段之间使用。每行的开头和结尾不需要指定分隔符。下面的示例是一个使用（|）字符的示例输入：

::

	data value 1|data value 2|data value 3

下面的示例语句介绍如何在语句中指定（|）作为分隔符：

.. code-block:: sql

	=# CREATE EXTERNAL TABLE ext_table (name text, date date)
	LOCATION ('qs://<your-bucket-name>.pek3a.qingstor.com/filename.txt')
	FORMAT 'TEXT' (DELIMITER '|');

在数据中表示空值
^^^^^^^^^^^^^^^^

数据库中的空值（NULL）表示列值未知。在您提供的数据文件中，可以指定一个字符串来表示空值。对于文本文件来说，默认的字符串是 \N，对于 CSV 文件来说，使用没有双引号保护的空值。您还可以在 CREATE EXTERNAL TABLE 的 NULL 子句中指定其他的字符串来表示空值。例如，如果您不需要区分空值和空字符串的话，可以使用空字符串来表示空值。在数据加载时，任何数据值和指定的空值字符串相同时，就会被解释为空值。

转义
^^^^

在 |product-name| 中有两个保留字符具有特殊含义：

* 被用来在数据文件中作为列的分隔符的字符。
* 被用来在数据文件中作为换行的字符。

如果您提供的数据中包含上面的字符，需要将该字符进行转义，这样 |product-name| 就会将其解释为数据，而不会解释为列分隔符或换行。默认情况下，文本文件的转义字符是 \（反斜线），CSV 文件是 "（双引号）。


文本文件中的转义操作
""""""""""""""""""""

默认情况下，文本格式文件的转义字符是 \ （反斜线）。您可以在 CREATE EXTERNAL TABLE 的 ESCAPE 语句中指定其他的转义字符。如果您的数据中包含了转义字符本身，可以使用转义字符来转义它自己。

让我们来看一下例子，假设您有一张包含三个列的表，您希望将下面三列作为列值加载到表中：

* backslash = \
* vertical bar = |
* exclamation point = !

您指定 | 作为列分隔符，\ 作为转义字符。您数据文件中，格式化后的数据行应该类似下面的样子：

::

	backslash = \\ | vertical bar = \| | exclamation point = !

这里请您注意反斜线是一部分数据，因此需要使用另一个反斜线进行转义。另外 | 字符也是数据的一部分，因此需要使用反斜线将其转义。

您还可以使用转义字符来转义八进制和十六进制序列。在 |product-name| 加载数据时，转义的值将会被转换为对应的字符。例如，要加载 & 字符，可以用转义字符来转义该字符的十六进制（\0x26）或者八进制（\046）表示。

您也可以在文件格式文件中，利用 ESCAPE 语句来禁用转义功能，例如：

:: 

	ESCAPE 'OFF'

如果您要加载包含大量反斜线的数据时（例如，互联网类日志），禁用转义功能将会非常方便。

CSV 文件中的转义操作
""""""""""""""""""""""

默认情况下，CSV 格式文件的转义字符是 "（双引号）。您可以在 CREATE EXTERNAL TABLE 的 ESCAPE 语句中指定其他的转义字符。如果您的数据中包含了转义字符本身，可以使用转义字符来转义它自己。

让我们来看一下例子，假设您有一张包含三个列的表，您希望将下面三列作为列值加载到表中：

* Free trip to A,B
* 5.89
* Special rate "1.79"

您指定 , （逗号）作为列分隔符，"（双引号） 作为转义字符。您数据文件中，格式化后的数据行应该类似下面的样子：

::

         "Free trip to A,B","5.89","Special rate ""1.79"""

如果逗号是数据的一部分，需要使用双引号来保护。如果双引号是数据的一部分，即使整个数据是用双引号来保护的，还是需要用双引号来转义双引号的。

使用双引号保护整个数据字段可以保证数据开头和结尾的空白字符被正确解释。

::

	"Free trip to A,B ","5.89 ","Special rate ""1.79"" "

**注意**：在 CSV 格式中，字符解释的处理非常严格。例如：被引号保护的空白字符或者其他非分隔字符。由于上面的原因，如果向系统导入的数据在末尾补充了保持每行相同长度的空白字符，将会引起错误。因此，在使用 |product-name| 读取数据时，需要先将 CSV 文件进行预处理，移除不必要的末尾空白字符。

字符编码的处理
^^^^^^^^^^^^^^

字符编码系统是通过一种编码方法，将字符集中的字符和特定数值组成一个固定映射关系，来允许对数据传输和存储。|product-name| 支持多种不同的字符集，例如：单字节的字符集 ISO 8859 及其衍生字符集，多字节字符集 EUC（扩展 UNIX 编码），UTF-8 等。虽然有一小部分字符集不支持作为服务器端存储编码，但是客户端可以使用所有的字符集。

数据文件使用的编码必须是 |product-name| 能够识别的。
在数据加载时，如果数据文件包含无效或不支持的编码序列时，将会导致错误。

**注意**：如果数据文件是在微软的 Windows 操作系统上生成的，请在进行数据加载前，运行 dos2unix 命令来删除原始文件中 Windows 平台的特殊字符。
