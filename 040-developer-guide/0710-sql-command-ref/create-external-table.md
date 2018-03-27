# CREATE EXTERNAL TABLE

定义一个新的外部表。

## 概要

```
CREATE [READABLE] EXTERNAL TABLE table_name     
    ( column_name data_type [, ...] | LIKE other_table )
     LOCATION ('file://seghost[:port]/path/file' [, ...])
       | ('gpfdist://filehost[:port]/file_pattern[#transform=trans_name]'
           [, ...]
       | ('gpfdists://filehost[:port]/file_pattern[#transform=trans_name]'
           [, ...])
       | ('gphdfs://hdfs_host[:port]/path/file')
       | ('s3://S3_endpoint[:port]/bucket_name/[S3_prefix]
             [region=S3-region]
            [config=config_file]')
     [ON MASTER]
     FORMAT 'TEXT' 
           [( [HEADER]
              [DELIMITER [AS] 'delimiter' | 'OFF']
              [NULL [AS] 'null string']
              [ESCAPE [AS] 'escape' | 'OFF']
              [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
              [FILL MISSING FIELDS] )]
          | 'CSV'
           [( [HEADER]
              [QUOTE [AS] 'quote'] 
              [DELIMITER [AS] 'delimiter']
              [NULL [AS] 'null string']
              [FORCE NOT NULL column [, ...]]
              [ESCAPE [AS] 'escape']
              [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
              [FILL MISSING FIELDS] )]
          | 'AVRO' 
          | 'PARQUET'
          | 'CUSTOM' (Formatter=<formatter_specifications>)
    [ ENCODING 'encoding' ]
      [ [LOG ERRORS] SEGMENT REJECT LIMIT count
      [ROWS | PERCENT] ]

CREATE [READABLE] EXTERNAL WEB TABLE table_name     
   ( column_name data_type [, ...] | LIKE other_table )
      LOCATION ('http://webhost[:port]/path/file' [, ...])
    | EXECUTE 'command' [ON ALL 
                          | MASTER
                          | number_of_segments
                          | HOST ['segment_hostname'] 
                          | SEGMENT segment_id ]
      FORMAT 'TEXT' 
            [( [HEADER]
               [DELIMITER [AS] 'delimiter' | 'OFF']
               [NULL [AS] 'null string']
               [ESCAPE [AS] 'escape' | 'OFF']
               [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
               [FILL MISSING FIELDS] )]
           | 'CSV'
            [( [HEADER]
               [QUOTE [AS] 'quote'] 
               [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [FORCE NOT NULL column [, ...]]
               [ESCAPE [AS] 'escape']
               [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
               [FILL MISSING FIELDS] )]
           | 'CUSTOM' (Formatter=<formatter specifications>)
     [ ENCODING 'encoding' ]
     [ [LOG ERRORS] SEGMENT REJECT LIMIT count
       [ROWS | PERCENT] ]

CREATE WRITABLE EXTERNAL TABLE table_name
    ( column_name data_type [, ...] | LIKE other_table )
     LOCATION('gpfdist://outputhost[:port]/filename[#transform=trans_name]'
          [, ...])
      | ('gpfdists://outputhost[:port]/file_pattern[#transform=trans_name]'
          [, ...])
      | ('gphdfs://hdfs_host[:port]/path')
      FORMAT 'TEXT' 
               [( [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [ESCAPE [AS] 'escape' | 'OFF'] )]
          | 'CSV'
               [([QUOTE [AS] 'quote'] 
               [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [FORCE QUOTE column [, ...]] ]
               [ESCAPE [AS] 'escape'] )]
           | 'AVRO' 
           | 'PARQUET'

           | 'CUSTOM' (Formatter=<formatter specifications>)
    [ ENCODING 'write_encoding' ]
    [ DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY ]

CREATE WRITABLE EXTERNAL TABLE table_name
    ( column_name data_type [, ...] | LIKE other_table )
     LOCATION('s3://S3_endpoint[:port]/bucket_name/[S3_prefix]
            [region=S3-region]
            [config=config_file]')
      [ON MASTER]
      FORMAT 'TEXT' 
               [( [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [ESCAPE [AS] 'escape' | 'OFF'] )]
          | 'CSV'
               [([QUOTE [AS] 'quote'] 
               [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [FORCE QUOTE column [, ...]] ]
               [ESCAPE [AS] 'escape'] )]

CREATE WRITABLE EXTERNAL WEB TABLE table_name
    ( column_name data_type [, ...] | LIKE other_table )
    EXECUTE 'command' [ON ALL]
    FORMAT 'TEXT' 
               [( [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [ESCAPE [AS] 'escape' | 'OFF'] )]
          | 'CSV'
               [([QUOTE [AS] 'quote'] 
               [DELIMITER [AS] 'delimiter']
               [NULL [AS] 'null string']
               [FORCE QUOTE column [, ...]] ]
               [ESCAPE [AS] 'escape'] )]
           | 'CUSTOM' (Formatter=<formatter specifications>)
    [ ENCODING 'write_encoding' ]
    [ DISTRIBUTED BY (column, [ ... ] ) | DISTRIBUTED RANDOMLY ]
```

## 描述

CREATE EXTERNAL TABLE 或 CREATE EXTERNAL WEB TABLE 在 HashData 数据库中创建一个新的可读外部表定义。可读外部表通常用于快速并行数据加载。定义外部表后，可以使用 SQL 命令直接（并行）查询其数据。例如，用户可以 select, join, sort 外部表数据。用户还可以为外部表创建视图。 DML 操作 \(UPDATE, INSERT, DELETE, TRUNCATE\) 在可读外部表上不可操作，用户不能在可读外部表上创建索引。

CREATE WRITABLE EXTERNAL TABLE 或 CREATE WRITABLE EXTERNAL WEB TABLE 在 HashData 数据库中创建一个新的可写外部表定义。可写外部表通常用于将数据从数据库卸载到一组文件或命名管道中。 可写外部 Web 表也可用于将数据输出到可执行程序。可写外部表也可以用作 HashData 并行 MapReduce 计算的输出目标。一旦可写外部表被定义，可以从数据库表中选择数据并将其插入到可写外部表中。可写外部表仅允许 INSERT 操作 – SELECT， UPDATE， DELETE 或 TRUNCATE 不被允许。

常规外部表和外部 Web 表之间的主要区别是它们的数据源。常规可读外部表访问静态平面文件，而外部 Web 表访问动态数据源 - 无论是在 Web 服务器上还是通过执行 OS 命令或脚本。

FORMAT 子句用于描述外部表文件的格式。有效的文件格式是分隔文本 \(TEXT\) 逗号分隔值\(CSV\) 格式, 与 PostgreSQL 可用的格式化选项类似 COPY 命令。 如果文件中的数据不使用默认列分隔符，转义字符，空字符串等，则必须指定其他格式选项，以便外部文件中的数据被 HashData 数据库正确读取。

为了 gphdfs 协议, 用户可以在 FORMAT 子句中指定 AVRO 或 PARQUET 读取或写入 Avro 或 Parquet 格式文件。

在创建写入或从 Amazon Web Services（AWS）S3 存储区中读取的外部表之前，必须配置 HashData 数据库以支持协议。S3 外部表可以使用 CSV 或文本格式的文件可写的 S3 外部表仅支持插入操作。

## 参数

READABLE \| WRITABLE

指定外部表的类型，默认可读。可读外部表用于将数据加载到 HashData 数据库中。可写外部表用于卸载数据。

WEB

在 HashData 数据库中创建可读或可写的外部 Web 表定义。 有两种形式的可读外部 Web 表 - 那些访问文件的形式 `http://` 协议或通过执行 OS 命令访问数据的协议。 可写外部 Web 表将数据输出到可接受数据输入流的可执行程序。在执行查询期间，外部 Web 表不能重新计算。

s3 协议不支持外部 Web 表。但是，用户可以创建一个外部 Web 表，执行第三方工具直接从 S3 读取数据或向 S3 写入数据。

_table\_name_

新外部表的名称。

_column\_name_

在外部表定义中创建的列的名称。与常规表不同，外部表不具有列约束或默认值，因此不要指定。

LIKE _other\_table_

该 LIKE 子句指定新的外部表自动复制所有列名，数据类型和 HashData 分发策略的表。 如果原始表指定了任何列约束或默认列值，那么它们将不会被复制到新的外部表定义中。

_data\_type_

列的数据类型。

LOCATION _\('protocol://host\[:port\]/path/file' \[, ...\]\)_

对于可读外部表，指定用于填充外部表或 Web 表的外部数据源的 URI。常规可读外部表允许 gpfdist 或 文件协议。 外部 Web 表允许 http 协议。 如果端口被省略, 端口 8080 被假定为 http 和 gpfdist 协议端口, 端口 9000 为 gphdfs 协议端口。 如果使用 gpfdist 协议, 路径 是相对于 gpfdist 服务文件的目录 （启动 gpfdist 程序时，gpfdist 指定的目录\)。此外， gpfdist 使用通配符或其他 C-style 模式匹配\(例如，空格符为\[\[:space:\]\]\)表示目录中的多个文件。例如：

```
'gpfdist://filehost:8081/*'
'gpfdist://masterhost/my_load_file'
'file://seghost1/dbfast1/external/myfile.txt'
'http://intranet.example.com/finance/expenses.csv'
```

对于 gphdfs 协议, URI 的 LOCATION 不能包含以下四个字符：_ , ', &lt;, &gt;_。如果 URI 包含任何此类字符，该 CREATE EXTERNAL TABLE 命令将返回错误。

如果用户正在使用 MapR 集群的 gphdfs 协议,用户需要指定一个特定的集群和文件：

* 要指定默认群集，MapR 配置文件中的第一个目录 `/opt/mapr/conf/mapr-clusters.conf`, 使用以下语法指定表的位置：

  ```
   LOCATION ('gphdfs:///file_path')
  ```

  该 file\_path 是文件路径。

* 要指定配置文件中列出的另一个 MapR 集群，请使用以下语法指定文件：

  ```
   LOCATION ('gphdfs:///mapr/cluster_name/file_path')
  ```

  cluster\_name 是在配置文件中指定的集群的名称并且 file\_path 是文件的路径。

对于可写外部表,指定 gpfdist 进程或 S3 协议将会从 HashData 的 Segment 收集输出的数据并将其写入一个或多个命名文件。对于 gpfdist ，该路径是相对于 gpfdist 服务文件的目录 \(启动 gpfdist 程序时指定的目录\)。如果多个 gpfdist 列出了位置, 发送数据的 Segment 将在可用的输出位置间均匀分配例如:

```
'gpfdist://outputhost:8081/data1.out',
'gpfdist://outputhost:8081/data2.out'
```

有两个 gpfdist 如上述示例中列出的位置，一半的 Segment 将其输出数据发送到 `data1.out` 文件，另一半发送到 `data2.out` 文件中。

在可选择的 _\#transform=trans\_name_ 中, 用户可以指定要在加载或提取数据时应用的转换。 trans\_name 是用户运行 gpfdist 实用程序指定的 YAML 配置文件的转换名称。

如果用户指定 gphdfs 协议去读取或写入文件到 Hadoop 文件系统（HDFS）中，你可以通过指定 FORMAT 子句的 AVRO 或 PARQUET 选项，来读写一个 AVRO 或 PARQUET 格式的文件。

有关指定Avro或Parquet文件位置的信息， 参阅 gphdfs协议的HDFS文件格式支持。

当用户用 s3 协议创建一个外部表时,只支持 TEXT 和 CSV 格式。 这些文件可以是 gzip 压缩格式。该S3协议识别 gzip 格式并解压缩文件。只支持 gzip 压缩格式。

用户可以指定 s3 协议，访问 Amazon S3 上的数据或 Amazon S3 兼容服务上的数据。在用户用 s3 协议创建外部表之前, 用户必须配置 HashData 数据库。有关配置 HashData 数据库的信息，参阅 s3 协议配置。

对于 s3 协议来说, LOCATION 子句指定数据文件为表上传的 S3 端点和存储桶名称。对于可写外部表，用户可以为插入到表中的数据创建新文件时指定一个可选的 S3 文件前缀。

如果为只读 S3 表指定了 S3\_prefix ，则 s3 选择那些具有指定的 S3 文件前缀的文件。

> 注解: 尽管 S3\_prefix 是语法的可选部分，但应始终为可写和只读 S3 表包含一个 S3 前缀，以分隔数据集作为 CREATE EXTERNAL TABLE 的语法。

LOCATION 子句中的 config 参数，指定包含 Amazon Web Services \(AWS\) 连接凭据和通信参数所需的 s3 协议配置参数文件的位置。 有关 s3 配置文件参数的信息， 参见 s3 协议配置文件。

这是一个使用 s3 协议定义的只读外部表的示例。

```
CREATE READABLE EXTERNAL TABLE S3TBL (date text, time text, amt int)
   LOCATION('s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/
      config=/home/gpadmin/aws_s3/s3.conf')
   FORMAT 'csv';
```

S3 桶位于 S3 端点 `s3-us-west-2.amazonaws.com`， s3 的桶名称为 `s3test.example.com`。 桶中文件的 s3 前缀为 `/dataset1/normal/`。配置文件位于所有 HashData 数据库的 Segment 的 `/home/gpadmin/s3/s3.conf` 中。

这个只读外部表示例指定相同的位置，并使用 region 参数指定 Amazon s3 区域 `us-west-2` 。

```
CREATE READABLE EXTERNAL TABLE S3TBL (date text, time text, amt int)
   LOCATION('s3://amazonaws.com/s3test.example.com/dataset1/normal/
      region=s3-us-west-2 config=/home/gpadmin/aws_s3/s3.conf')
   FORMAT 'csv';
```

该端口在 LOCATION 子句中的 URL 中是可选的。如果在 LOCATION 的子句的 URL 中未指定端口,则 s3 配置文件参数 encryption 会影响 s3 协议使用的端口 \(端口 80 for HTTP 或端口 443 for HTTPS\)。如果指定端口，则使用该端口，而不管 encryption 设置如何。例如，如果在 s3 配置文件中的LOCATION 子句中指定了端口 80，并且 encryption=true，则 HTTPS 请求将发送到端口 80 而不是 443，并记录警告。

LOCATION 子句中的 config 参数指定包含 Amazon Web Services（AWS）连接凭据和通信参数的所需 s3 协议配置文件的位置。 将 s3 的配置文件参数版本设置为 2 并在 LOCATION 子句中指定 region 参数。 \(如果版本是 2， 则 LOCATION 子句中需要 region 参数。\)在 LOCATION 子句中定义服务时，可以在 URL 中指定服务端点，并在 region 参数中指定服务器。这是一个 LOCATION 子句示例， 包含了一个 region 参数并指定了一个 Amazon S3 兼容服务。

```
LOCATION ('s3://test.company.com/s3test.company/dataset1/normal/ **region=local-test**
      config=/home/gpadmin/aws_s3/s3.conf')
```

当版本参数是 2 时， 还可以指定一个 Amazon S3 端点。 此示例指定了 Amazon S3 端点。

```
LOCATION ('s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/ **region=us-west-2**
      config=/home/gpadmin/aws_s3/s3.conf')
```

更多关于s3协议的信息，参阅 HashData 数据库管理员指南中的 `s3://协议`。

ON MASTER

将所有与表相关的操作限制在 HashData 主 Segment。 仅允许使用 s3 或自定义协议创建的可读写的外部表。gpfdist, gpfdists, gphdfs,和文件协议不支持 ON MASTER。

> 注意： 在使用 ON MASTER 子句创建的外部表进行阅读或写入时，请注意潜在的资源影响。将表操作仅限于 HashData 主分区时，可能会遇到性能问题。

EXECUTE 'command' \[ON ...\]

允许只读可读外部 Web 表或可写外部表。 对于可读取的外部 Web 表，要指定由 Segment 实例执行的 OS 命令。该命令可以是单个 OS 命令或脚本。 ON 子句用于指定哪些 Segment 实例将执行给定的命令。

* ON ALL 是默认值。该命令将由 HashData 数据库系统中所有 Segment 主机上的每个活动（主） Segment 实例执行。如果命令执行一个脚本，该脚本必须位于所有 Segment 主机上的相同位置，并且可由 HashData 超级用户 \(gpadmin\)执行。
* ON MASTER 仅在 master 主机上运行命令。

  注意： 当指定ON MASTER子句时，外部web表不支持日志记录 。

* ON number 表示命令将由指定数量的 Segment 执行。 HashData 数据库系统在运行时随机选择特定的 Segment。如果命令执行脚本，该脚本必须位于所有 Segment 主机上的相同位置，并且可由 HashData 超级用户\(gpadmin\)执行。

* HOST 意味着命令将由每个 Segment 主机上的一个 Segment 执行（每个 Segment 主机一次），而不管每个主机的活动 Segment 实例数如何。
* HOST segment\_hostname 表示该命令将由指定 Segment 主机上的所有活动（主）Segment 实例执行。
* SEGMENT segment\_id 表示命令只能由指定的 Segment 执行一次。 用户可以通过查看系统目录表 `gp_segment_configuration` 中的内容编号来确定 Segment 实例的 ID。  HashData 数据库的 Master的内容 ID始终为 -1。

对于可写外部表， EXECUTE 子句中指定的命令必须准备好将数据管道传输到其中。由于具有发送数据的所有 Segment 都将其输出写入指定的命令或程序，因此 ON 的唯一可选项为 ON ALL。

FORMAT 'TEXT \| CSV \| AVRO \| PARQUET' \(options\)

指定外部或 Web 表数据的格式 - 纯文本 \(TEXT\)或或逗号分隔值\(CSV\) 格式。

仅使用 gphdfs 协议支持 AVRO 和 PARQUET 格式。

FORMAT 'CUSTOM' \(formatter=formatter\_specification\)

指定自定义数据格式。 formatter\_specification 指定用于格式化数据的函数，后跟格式化函数的逗号分隔参数。 格式化程序规范的长度，包括 Formatter= 的字符串的长度可以高达约 50K 字节。

有关使用自定义格式的信息，请参阅  HashData 数据库管理员指南中的 “装载和卸载数据”。

DELIMITER

指定单个 ASCII 字符，用于分隔每行（行）数据中的列。 默认值为 TEXT 模式下的制表符， CSV 格式为逗号。在可读外部表的 TEXT 模式下，对于将非结构化数据加载到单列表中的特殊用例，可以将分隔符设置为 OFF

对于 s3 协议，分隔符不能是换行符 \(n\) 或回车字符 \(r\)。

NULL

指定表示 NULL 值的字符串。在 TEXT 模式下，默认值是 \N（反斜杠-N）， CSV 模式中不含引号的空值。在 TEXT 模式下用户可能更希望不想将 NULL 值与空字符串区分开的情况下，也能使用 NULL 字符串。使用外部和 Web 表时，与此字符串匹配的任何数据项将被视为 NULL 值。使用外部和 Web 表时，与此字符串匹配的任何数据项将被视为 NULL 值。

作为 text 格式的示例，此 FORMAT 子句可用于指定两个单引号 \(''\) 的字符串为 NULL 值。

```
FORMAT 'text' (delimiter ',' null '''''' )
```

ESCAPE

指定用于 C 转义序列的单个字符 \(例如 \n,\t,\100, 等等\) 以及用于转义可能被视为行或列分隔符的数据字符。确保选择在实际列数据中的任何地方都不使用的转义字符。默认转义字符是文本格式文件的（反斜杠）和 csv 格式文件的 " \(双引号\) ，但是可以指定其他字符来表示转义，也可以禁用文本转义通过指定值'OFF'作为转义值，格式化的文件对于诸如文本格式的 Web 日志数据之类的数据非常有用，这些数据具有许多不希望转义的嵌入式反斜杠。

NEWLINE

指定数据文件中使用的换行符 – LF \(换行符, 0x0A\)， CR \(回车符号, 0x0D\), 或 CRLF \(回车加换行， 0x0D 0x0A\)。 如果未指定， HashData 数据库的 Segment 将通过查看其接收的第一行数据并使用遇到的第一个换行符来检测换行类型。

HEADER

对于可读外部表，指定数据文件中的第一行是标题行（包含表列的名称），不应作为表的数据包含。如果使用多个数据源文件，则所有文件必须有标题行。

对于 s3 协议，标题行中的列名不能包含换行符 \(n\) 或回车符 \(r\)。

QUOTE

指定 CSV 模式的报价字符。 默认值为双引号 \("\)。

FORCE NOT NULL

在 CSV 模式下，处理每个指定的列，就像它被引用一样，因此不是一个 NULL 值。对于 CSV 模式中的默认空字符串（两个分隔符之间不存在），这将导致将缺少的值作为零长度字符串计算。

FORCE QUOTE

在可写外部表的 CSV 模式下，强制引用用于每个指定列中的所有非 NULL 值。 NULL 输出从不引用。

FILL MISSING FIELDS

在可读外部表的 TEXT 和 CSV 模式下， 指定 FILL MISSING FIELDS 时，当一行数据在行或行的末尾缺少数据字段时，将丢失尾字段值设置为 NULL （而不是报告错误）。空行，具有 NOT NULL约束的字段和行上的尾随分隔符仍然会报告错误。

ENCODING _'encoding'_

字符集编码用于外部表。 指定一个字符串常量 \(如 'SQL\_ASCII'\), 一个整数编码号或者 DEFAULT 来使用默认的客户端编码。 参见字符集支持。

LOG ERRORS

这是一个可选的子句，可以在 SEGMENT REJECT LIMIT 子句之前记录有关具有格式错误的行的信息。 错误日志信息在内部存储，并使用 HashData 数据库内置 SQL 函数 `gp_read_error_log()` 访问。

SEGMENT REJECT LIMIT _count_ \[ROWS \| PERCENT\]

在单行错误隔离模式下运行 COPY FROM 操作。如果输入行具有格式错误，则它们将被丢弃，前提是在加载操作期间在任何 HashData 的 Segment 实例上未达到拒绝限制计数。拒绝限制计数可以指定为行数（默认值）或总行数百分比（1-100）。如果使用 PERCENT，则每个 Segment 只有在处理了参数  `gp_reject_percent_threshold` 所指定的行数之后才开始计算坏行百分比。 `gp_reject_percent_threshold` 的默认值为 300 行。诸如违反 NOT NULL, CHECK， 或 UNIQUE 约束的约束错误仍将以 “all-or-nothing” 输入模式进行处理。 如果没有达到限制，所有好的行将被加载，任何错误行被丢弃。

> 注解：读取外部表时，如果未首先触发 SEGMENT REJECT LIMIT 或未指定 SEGMENT REJECT LIMIT，则 HashData 数据库将限制可能包含格式错误的初始行数。如果前 1000 行被拒绝，则 COPY 操作将被停止并回滚。

可以使用 HashData 数据库服务器配置参数 `gp_initial_bad_row_limit` 更改初始拒绝行的数量限制。有关参数的信息，请参阅服务器配置参数。

DISTRIBUTED BY \(column, \[ ... \] \)

DISTRIBUTED RANDOMLY

用于为可写外部表声明 HashData 数据库分发策略。默认情况下，可写外部表是随机分布的。如果要从中导出数据的源表具有散列分发策略，则为可写外部表定义相同的分发密钥列可以通过消除在互连上移动行的需要来改善卸载性能。 当用户发出诸如 `INSERT INTO wex_table SELECT * FROM source_table`，的卸载命令时，如果两个表具有相同的散列分布策略，则可以将卸载的行直接从 Segment 发送到输出位置。

## 示例

在端口 8081 的后台启动 gpfdist 文件服务器程序，从目录 `/var/data/staging` 提供文件：

```
gpfdist -p 8081 -d /var/data/staging -l /home/gpadmin/log &
```

创建一个名为 `ext_customer` 的可读外部表使用的 gpfdist 协议和 gpfdist 目录中找到的任何文本格式的文件（\*.txt） 文件格式化为管道 \(\|\)作为列分隔符，空格为 NULL。 也可以在单行错误隔离模式下访问外部表：

```
CREATE EXTERNAL TABLE ext_customer
   (id int, name text, sponsor text) 
   LOCATION ( 'gpfdist://filehost:8081/*.txt' ) 
   FORMAT 'TEXT' ( DELIMITER '|' NULL ' ')
   LOG ERRORS SEGMENT REJECT LIMIT 5;
```

创建与上述相同的可读外部表定义，但使用 CSV 格式的文件：

```
CREATE EXTERNAL TABLE ext_customer 
   (id int, name text, sponsor text) 
   LOCATION ( 'gpfdist://filehost:8081/*.csv' ) 
   FORMAT 'CSV' ( DELIMITER ',' );
```

使用文件协议和具有标题行的几个 CSV 格式的文件创建名为 _ext\_expenses_ 的可读外部表：

```
CREATE EXTERNAL TABLE ext_expenses (name text, date date, 
amount float4, category text, description text) 
LOCATION ( 
'file://seghost1/dbfast/external/expenses1.csv',
'file://seghost1/dbfast/external/expenses2.csv',
'file://seghost2/dbfast/external/expenses3.csv',
'file://seghost2/dbfast/external/expenses4.csv',
'file://seghost3/dbfast/external/expenses5.csv',
'file://seghost3/dbfast/external/expenses6.csv' 
)
FORMAT 'CSV' ( HEADER );
```

创建一个可读的外部 Web 表，每个 Segment 主机执行一次脚本：

```
CREATE EXTERNAL WEB TABLE log_output (linenum int, message 
text)  EXECUTE '/var/load_scripts/get_log_data.sh' ON HOST 
 FORMAT 'TEXT' (DELIMITER '|');
```

创建一个名为 sales\_out 的可写外部表，它使用 gpfdist 将输出数据写入名为 sales.out 的文件。 文件格式化为管道 \(\|\) 作为列分隔符，空格空。

```
CREATE WRITABLE EXTERNAL TABLE sales_out (LIKE sales) 
   LOCATION ('gpfdist://etl1:8081/sales.out')
   FORMAT 'TEXT' ( DELIMITER '|' NULL ' ')
   DISTRIBUTED BY (txn_id);
```

创建一个可写的外部 Web 表，其将 Segment 接收的输出数据管理到名为 `to_adreport_etl.sh` 的可执行脚本：

```
CREATE WRITABLE EXTERNAL WEB TABLE campaign_out 
(LIKE campaign) 
 EXECUTE '/var/unload_scripts/to_adreport_etl.sh'
 FORMAT 'TEXT' (DELIMITER '|');
```

使用上面定义的可写外部表来卸载所选数据：

```
INSERT INTO campaign_out SELECT * FROM campaign WHERE 
customer_id=123;
```

## 注解

指定 LOG ERRORS 子句时，HashData 数据库会捕获读取外部表数据时发生的错误。用户可以查看和管理捕获的错误日志数据。

* 使用内置的SQL函数 gp\_read\_error\_log\('table\_name'\)。它需要对table\_name具有 SELECT特权。 此示例显示使用COPY命令加载到表 ext\_expenses 中的数据的错误日志信息：

```
    SELECT * from gp_read_error_log('ext_expenses');
```

有关错误日志格式的信息，请参阅  HashData 数据库管理员指南中的在错误日志中查看不正确的行。

如果 table\_name 不存在，该函数返回 FALSE。

* 如果指定的表存在错误日志数据，新的错误日志数据将附加到现有的错误日志数据。错误日志信息不会复制到镜像 Segment。
* 使用内置的 SQL 函数 `gp_truncate_error_log('table_name')` 删除 table\_name 的错误日志数据。它需要表所有者权限,此示例删除将数据移动到表中时捕获的错误日志信息 ext\_expenses:

  ```
  SELECT gp_truncate_error_log('ext_expenses');
  ```

  如果 table\_name 不存在，该函数返回 FALSE。

  指定 \* 通配符以删除当前数据库中现有表的错误日志信息。指定字符串 `*.*` 以删除所有数据库错误日志信息，包括由于以前的数据库问题而未被删除的错误日志信息。如果指定 \*，则需要数据库所有者权限。 如果指定了 `*.*` 则需要操作系统超级用户权限。

## HDFS 文件格式支持 gphdfs 协议

如果用户指定了 gphdfs 协议将文件读取或写入 Hadoop 文件系统（HDFS）， 则可以通过使用 FORMAT 子句指定文件格式来读取或写入 Avro 或 Parquet 格式文件。

要从 Avro 或 Parquet 文件读取数据或将数据写入到 Avro 或 Parquet 文件中，用户可以使用 CREATE EXTERNAL TABLE 命令创建一个外部表，并指定 LOCATION 子句中的 Avro 文件的位置和 FORMAT 子句中 'AVRO' 。此示例用于从 Avro 文件读取的可读外部表。

```
CREATE EXTERNAL TABLE tablename (column_spec) LOCATION ( 'gphdfs://location') **FORMAT 'AVRO'**
```

该位置可以是包含一组文件的文件名或目录。对于文件名，用户可以指定通配符 `*` 来匹配任意数量的字符。 如果位置在读取文件时指定了多个文件，HashData 数据库将使用第一个文件中的模式作为其他文件的模式。

作为 LOCATION 参数的一部分，用户可以指定读取或写入文件的选项。在文件名后，用户可以使用 HTTP 查询字符串语法指定参数 \？并在字段值对之间使用 \＆。

对于此示例 LOCATION 参数，此 URL 设置 Avro 格式可写外部表的压缩参数。

```
'gphdfs://myhdfs:8081/avro/singleAvro/array2.avro?compress=true&compression_type=block&codec=snappy' FORMAT 'AVRO'
```

有关使用外部表读取和编写 Avro 和 Parquet 格式文件的信息，请参阅 HashData 数据库管理员指南中的 “装载和卸载数据”。

**Avro文件**

对于可读外部表，唯一有效的参数是 schema。阅读多个 Avro 文件时，可以指定包含 Avro 模式的文件。

对于可写外部表，可以指定 schema, namespace, 压缩参数。

##### 表1. Avro 格式外部表 location 参数

| 参数 | 值 | 可读/可写 | 默认值 |
| :---: | :---: | :---: | :---: |
| schema | `URL_to_schema_file` | Read and Write | None. For a readable external table,The specified schema overrides the schema in the Avro file. See "Avro Schema Overrides" If not specified, Hashdata Database uses the Avro file schema.For a writable external table,Uses the specified schema when creating the Avro file.If not specified, Hashdata Database creates a schema according to the external table definition. |
| namespace | `avro_namespace` | Write only | public.avro If specified, a valid Avro namespace. |
| compress | true or false | Write only | false |
| `compression_type` | block | Write only | Optional.  For avro format, compression\_type must be block if compress is true. |
| codec | deflate or snappy | Write only | deflate |
| codec\_level \(deflate codec only\) | integer between 1 and 9 | Write only | 6   The level controls the trade-off between speed and compression. Valid values are 1 to 9, where 1 is the fastest and 9 is the most compressed. |

这组参数指定 snappy 压缩:

```
 'compress=true&codec=snappy'
```

这两组参数指定 deflate 压缩并且等效:

```
 'compress=true&codec=deflate&codec_level=1'
 'compress=true&codec_level=1'
```

**gphdfs Avro文件的限制**

对于 HashData 数据库可写外部表定义，列不能指定 NOT NULL 子句。

HashData 数据库仅支持 Avro 文件中的单个顶级模式，或者在 CREATE EXTERNAL TABLE 命令中使用 schema 参数指定。 如果 HashData 数据库检测到多个顶级模式，则会返回错误。

HashData 数据库不支持 Avro 地图数据类型，并在遇到错误时返回错误。

当 HashData 数据库从 Avro 文件读取数组时，数组将转换为文本文本值。例如，数组 \[1,3\] 转换为 '{1,3}'。

支持用户定义的类型（UDT），包括数组UDT。 对于可写外部表，类型将转换为字符串。

**Parquet 文件**

对于外部表，可以在该位置指定的文件之后添加参数。此表列出了有效的参数和值。

##### 表 2. Parquet 格式外部表位置参数

| 选项 | 值 | 可读/可写 | 默认值 |
| :---: | :---: | :---: | :---: |
| schema | `URL_to_schema` | Write only | None.If not specified, HashData Database creates a schema according to the external table definition. |
| pagesize | &gt; 1024 Bytes | Write only | 1 MB |
| rowgroupsize | &gt; 1024 Bytes | Write only | 8 MB |
| version | v1, v2 | Write only | v1 |
| codec | UNCOMPRESSED, GZIP, LZO, snappy | Write only | UNCOMPRESSED |
| dictionaryenable | true, false | Write only | false |
| dictionarypagesize | &gt; 1024 Bytes | Write only | 512 KB |

> 注解：  
> 1.  创建一个内部字典。 如果文本列包含相似或重复的数据，启用字典可能会改进 Parquet 文件压缩。

## s3协议配置

s3 协议与 URI 一起使用以指定 Amazon Simple Storage Service（Amazon S3）存储区中文件的位置。该协议创建或下载 LOCATION 子句指定的所有文件。每个 HashData 数据库的 Segment 实例一次使用多个线程下载或上传一个文件。

## 配置和使用S3外部表

按照以下基本步骤配置 S3 协议并使用 S3 外部表，使用可用链接获取更多信息：

1. 配置每个数据库以支持 s3 协议：  
   1.  在每个将使用 s3 协议, 访问 S3 存储区的数据库中，为 s3 协议库创建读写功能：

   ```
       CREATE OR REPLACE FUNCTION write_to_s3() RETURNS integer AS
          '$libdir/gps3ext.so', 's3_export' LANGUAGE C STABLE;
   ```

   ```
       CREATE OR REPLACE FUNCTION read_from_s3() RETURNS integer AS
          '$libdir/gps3ext.so', 's3_import' LANGUAGE C STABLE;
   ```

   1. 在访问 S3 存储区的每个数据库中，声明 s3 协议并指定在上一步中创建的读写功能：

      ```
      CREATE PROTOCOL s3 (writefunc = write_to_s3, readfunc = read_from_s3);
      ```

      > 注解：协议名称 s3 必须与为创建用于访问 S3 资源的外部表指定的 URL 的协议相同。

      每个 HashData 数据库的 Segment 实例调用相应的功能。所有 Segment 主机都必须具有访问 S3 存储桶的权限。

2. 在每个 HashData 数据库的 Segment，创建并安装 s3 协议配置文件：  
   1.  使用 gpcheckcloud 实用程序创建模板 s3 协议配置文件：

   ```
       gpcheckcloud -t > ./mytest_s3.config
   ```

   1. 编辑模板文件以指定连接到 S3 位置所需的 accessid 和 secret。
   2. 将文件复制到所有主机上所有 HashData 数据库 Segment 的相同位置和文件名。默认的文件位置是 `gpseg_data_dir/gpseg_prefixN/s3/s3.conf`。 `gpseg_data_dir` 是 HashData 数据库 Segment 的数据目录的路径，`gpseg_prefix` 是 Segment 前缀， N 是 Segment 的 ID。在初始化 HashData 数据库系统时，会设置 Segment 数据目录，前缀和ID。

      如果将文件复制到其他位置或文件名，则必须使用 s3 协议 URL 中的配置参数。

   3. 使用 gpcheckcloud 实用程序验证与 S3 存储桶的连接：

      ```
      gpcheckcloud -c "s3://<s3-endpoint>/<s3-bucket> config=./mytest_s3.config"
      ```

      指定系统配置文件的正确路径，以及要检查的 S3 端点名称和存储桶。 gpcheckcloud 尝试连接到 S3 端点并列出 s3 存储区中的任何文件（如果可用）。 成功的连接以消息结束：

      ```
      Your configuration works well.
      ```

      用户可以选择使用 gpcheckcloud 来验证是否从 S3 存储区中上载和下载。

3. 完成以前创建和配置 S3 协议的步骤之后，用户可以在 CREATE EXTERNAL TABLE 命令中指定 S3 协议 URL 来定义 S3 外部表。 对于只读 S3 表，URL 定义用于选择构成 S3 表的现有数据文件的位置和前缀。 例如：

   ```
   CREATE READABLE EXTERNAL TABLE S3TBL (date text, time text, amt int)
      LOCATION('s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/
         config=/home/gpadmin/aws_s3/s3.conf')
      FORMAT 'csv';
   ```

   对于可写的 S3 表，协议 URL 定义了 HashData 数据库存储表的数据文件的 S3 位置，以及为表 INSERT 操作创建文件时使用的前缀。例如：

   ```
   CREATE WRITABLE EXTERNAL TABLE S3WRIT (LIKE S3TBL)
      LOCATION('s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/
         config=/home/gpadmin/aws_s3/s3.conf')
      FORMAT 'csv';
   ```

## s3协议限制

这些是 s3 的协议限制：

* 只支持 S3 路径样式的 URL。

  ```
  s3://S3_endpoint/bucketname/[S3_prefix]
  ```

* 只支持 S3 端点。该协议不支持 S3 桶的虚拟主机（将域名绑定到 S3 桶）。
* 支持 AWS 签名版本 2 和版本 4 的签名过程。  
* CREATE EXTERNAL TABLE 命令的 LOCATION 子句中只支持一个 URL 和可选的配置文件。
* 如果在 CREATE EXTERNAL TABLE 命令中未指定 NEWLINE 参数，则在特定前缀的所有数据文件中，换行符必须相同。如果某些具有相同前缀的数据文件中的换行字符不同，则对文件的读取操作可能会失败。
* 对于可写入的 S3 外部表，只支持 INSERT 操作。不支持 UPDATE, DELETE, 和 TRUNCATE 操作。
* 由于 Amazon S3 允许最多 10,000 个部分用于多部分上传,所以最大支持每个数据块为 128MB HashData 数据库 Segment 的可写入 s3 表的最大插入大小 1.28TB。 用户必须确保 chunksize 设置可以支持表的预期表大小。 有关上传到 S3 的更多信息，请参阅 S3 文档中的[多部分上传概述](http://docs.aws.amazon.com/AmazonS3/latest/dev/mpuoverview.html) 。
* 利用 HashData 数据库执行的并行处理 Segment 实例中，只读 S3 表的 S3 位置中的文件的大小应类似，文件数量应允许多个 Segment 从 S3 位置下载数据。 例如，如果 HashData 数据库系统由16个 Segment 组成，网络带宽足够，在 S3 位置创建 16 个文件允许每个 Segment 从一个文件下载 S3 位置。 相比之下，如果位置只包含 1 或 2 个文件，则只有 1 个或 2 个 Segment 下载数据。

## 关于S3协议URL

对于 s3 协议，用户可以在 CREATE EXTERNAL TABLE 命令的 LOCATION 子句中指定文件的位置和可选的配置文件位置。语法如下：

```
's3://S3_endpoint[:port]/bucket_name/[S3_prefix] [region=S3_region] [config=config_file_location]'
```

s3 协议要求用户指定 S3 端点和 S3 桶名称。 每个 HashData 数据库 Segment 实例必须能够访问 S3 位置。 可选的`S3_prefix` 值用于为只读 S3 表选择文件，也可用作为 S3 可写表上传文件时使用的文件名前缀。

> 注意： HashData 数据库 s3 协议 URL 必须包含 S3 端点主机名。

要在 LOCATION 子句中指定 ECS 端点（Amazon S3兼容服务），必须将 s3 配置文件参数设置为版本 2。 版本参数控制 LOCATION 中是否使用 region 参数。 用户还可以在版本参数为 2 时指定 Amazon S3 位置。

> 注意： 虽然 `S3_prefix` 是语法的可选部分， 但是用户应该始终为可写和只读 S3 表包含一个 S3 前缀，以分隔数据集作为 CREATE EXTERNAL TABLE 语法的一部分。

对于可写的 S3 表，s3 协议 URL 指定了 HashData 数据库上传表的数据文件的端点和存储桶名称。 对于上传文件的 S3 用户标识， S3 桶权限必须为 Upload/Delete。 由于将数据插入到表中，S3 文件前缀用于上传到 S3 位置的每个新文件。

对于只读 S3 表，S3 文件前缀是可选的。 如果指定了 `S3_prefix`，则 s3 协议将以指定前缀开头的所有文件选择为外部表的数据文件。 s3 协议不使用斜杠字符 \(/\) 作为分隔符，因此前缀后面的斜杠字符将被视为前缀本身的一部分。

例如，考虑以下 5 个文件，每个文件都有名为 `S3_endpoint` 的 `s3-us-west-2.amazonaws.com` 和 `bucket_name` test1:

```
s3://s3-us-west-2.amazonaws.com/test1/abc
s3://s3-us-west-2.amazonaws.com/test1/abc/
s3://s3-us-west-2.amazonaws.com/test1/abc/xx
s3://s3-us-west-2.amazonaws.com/test1/abcdef
s3://s3-us-west-2.amazonaws.com/test1/abcdefff
```

* 如果 S3 URL 是作为 `s3://s3-us-west-2.amazonaws.com/test1/abc` 提供的， 那么  abc 前缀会选择所有 5 个文件。
* 如果 S3 URL 被提供为 `s3://s3-us-west-2.amazonaws.com/test1/abc/`, 则 `abc/ prefix` 选择文件 `s3://s3-us-west-2.amazonaws.com/test1/abc/` 和 `s3://s3-us-west-2.amazonaws.com/test1/abc/xx`.
* 如果 S3 URL 以 `s3://s3-us-west-2.amazonaws.com/test1/abcd` 提供，则 abcd 前缀会选择文件 `s3://s3-us-west-2.amazonaws.com/test1/abcdef` 和 `s3://s3-us-west-2.amazonaws.com/test1/abcdefff`

`S3_prefix` 中不支持通配符；然而，S3 前缀的功能就好像一个通配符紧随着前缀本身。

由 S3 URL \(S3\_endpoint/bucket\_name/S3\_prefix\) 选择的所有文件都用作外部表的源，因此它们必须具有相同的格式。 每个文件还必须包含完整的数据行。数据行不能在文件之间分割。对于正在访问文件的 S3 用户标识，S3 文件权限必须是 Open/Download 和View

有关 Amazon S3 端点的信息，请参阅 [http://docs.aws.amazon.com/general/latest/gr/rande.html\#s3\_region](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region)。 有关 S3 桶和文件夹的信息，请参阅 Amazon S3 文档[https://aws.amazon.com/documentation/s3/](https://aws.amazon.com/documentation/s3/)。 有关 S3 文件前缀的信息，请参阅[Amazon S3文档列出密钥分层使用前缀和分隔符](http://docs.aws.amazon.com/AmazonS3/latest/dev/ListingKeysHierarchy.html)。

config 参数指定包含AWS连接凭据和通信参数的所需 s3 协议配置文件的位置。

## s3协议配置文件

使用 s3 协议时，所有的 HashData 数据库                                                                                                                    Segment都需要一个s3 协议配置文件。 默认位置是：

```
gpseg_data_dir/gpseg-prefixN/s3/s3.conf
```

`gpseg_data_dir` 是 HashData 数据库 Segment 数据目录的路径， gpseg-prefix 是 Segment 前缀， N 是 Segment 的 ID。 在初始化 HashData 数据库系统时，会设置 Segment 数据目录，前缀和 ID。

如果 Segment 主机上有多个 Segment 实例，则可以通过在每个 Segment 主机上创建单个位置来简化配置。 然后可以使用 s3 协议 LOCATION 子句中的 config 参数指定位置的绝对路径。但是，请注意，只读和可写S3外部表对于它们的连接使用相同的参数值。 如果要为只读和可写 S3 表配置协议参数不同，则在创建每个表时，必须使用两种不同的 s3 协议配置文件， 并在 CREATE EXTERNAL TABLE语句中指定正确的文件。

次示例指定 gpadmin 主目录的 the s3 目录中的单个文件位置：

```
config=/home/gpadmin/s3/s3.conf
```

主机上的所有 Segment 实例都使用文件 `/home/gpadmin/s3/s3.conf`。

s3 协议配置文件是由 \[default\] 部分和参数组成的文本文件。这是一个配置文件示例：

```
[default]
secret = "secret"
accessid = "user access id"
threadnum = 3
chunksize = 67108864
```

用户可以使用 HashData 数据库 gpcheckcloud 实用程序来测试S3配置文件。

**s3配置文件参数**

accessid

必需。AWS S3 ID 访问s3的桶

secret

必需。AWS S3的S3代码访问S3存储区。

autocompress

对于可写入的S3外部表，此参数指定在上传到S3之前是否压缩文件（使用gzip）。如果不指定此参数，文件将默认压缩。

chunksize

每个Segment线程用于读取或写入到S3服务器的缓冲大小。默认值为64 MB。最小为8MB，最大为128MB。

当将数据插入到可写S3表中时，每个 HashData 数据库Segment将数据写入其缓冲区\(using multiple threads up to the threadnum value\) 直到缓冲区满为止，然后将缓冲区写入S3存储区中的一个文件。 然后根据需要在每个Segment上重复该过程，直到插入操作完成。

由于Amazon S3允许最多10,000个部分用于多部分上传，因此最小的 块 大小为 8MB， 支持每个 HashData 数据库Segment的最大插入大小为80GB。 最大的 块大小是128MB 支持每个 HashData 数据库Segment的最大插入大小为1.28TB.对于可写的S3表，用户必须确保 chunksize 设置可以支持表的预期表格大小。

encryption

使用通过安全套接字层（SSL）保护的连接。 默认值为true。 值为true, t, on, yes, 和 y （不区分大小写）被视为true。 任何其他值被视为false。

如果在 CREATE EXTERNAL TABLE命令的 LOCATION 子句中的URL中未指定端口，则配置文件的 加密参数会影响 s3 协议使用的端口（HTTP端口80或HTTPS端口443）。 如果指定端口，则使用该端口，而不管加密设置如何。

low\_speed\_limit

上传/下载速度下限，以字节/秒为单位。 默认速度为10240（10K）。 如果上传或下载 速度低于由 low\_speed\_time, 指定的时间长于限制，则连接将中止并重试。 3次重试后，s3 协议返回错误。 值0指定没有下限。

low\_speed\_time

当连接速度小于 low\_speed\_limit时，此参数指定中止上载或从S3存储桶下载之前等待的时间（以秒为单位）。默认值为60秒。 值0指定没有时间限制。

server\_side\_encryption

已为桶配置的S3服务器端加密方法。  HashData 数据库仅支持使用Amazon S3管理的密钥进行服务器端加密，由配置参数值 sse-s3标识。 默认情况下禁用服务器端加密\(无\) 。

threadnum

在将数据上传到S3桶中的数据或从S3桶中下载数据时，Segment可以创建的最大并发线程数。 默认值为4.最小值为1，最大值为8。

verifycert

控制在客户端和s3 数据源之间通过HTTPS建立加密通信时，s3协议如何处理身份验证。 该值为 true 或 false。默认值为 true。

* verifycert=false - 忽略身份验证错误，并通过HTTPS进行加密通信。
* verifycert=true - 需要通过HTTPS进行加密通信的有效身份验证（特有的证书）。

将值设置为 false 可用于测试和开发环境， 以允许通信而不更改证书。

警告： 将值设置为 false通过在客户端和S3数据存储之间建立通信时忽略无效凭据来暴露安全风险。

version

指定 CREATE EXTERNAL TABLE 命令的LOCATION 子句中 指定的信息版本。值为1或 2。 默认值为1。

如果值为1，则LOCATION 子句支持Amazon S3 URL， 并且不包含 region 参数。如果值为 2，the LOCATION 子句支持S3兼容服务，并且必须包含 region 参数。region 参数指定S3数据源区域。 对于这个S3 URL s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/, AWS S3区域是 us-west-2。

如果版本 是1或者没被指定，则这是一个示例 LOCATION 子句， CREATE EXTERNAL TABLE命令指定一个Amazon S3端点。

LOCATION \('s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/  
      config=/home/gpadmin/aws\_s3/s3.conf'\)

如果版本是2, 一个示例 LOCATION子句，其中包括AWS兼容服务的 region 参数。 .

LOCATION \('s3://test.company.com/s3test.company/test1/normal/ region=local-test  
      config=/home/gpadmin/aws\_s3/s3.conf'\)

如果版本 是2，LOCATION 子句也可以指定一个Amazon S3端点。 此示例指定使用该Amazon S3端点 region 参数。

LOCATION \('s3://s3-us-west-2.amazonaws.com/s3test.example.com/dataset1/normal/ region=us-west-2  
      config=/home/gpadmin/aws\_s3/s3.conf'\)

注解： 当上传或下载S3文件时， HashData 数据库可能需要在每个分Segment主机上最多可以使用 threadnum \* chunksize 的内存。 当用户配置总体的 HashData 数据库内存时，请考虑此s3 协议内存要求，并根据需要增加 gp\_vmem\_protect\_limit 的值。

## 兼容性

CREATE EXTERNAL TABLE 是 HashData 数据库扩展。SQL标准没有规定外部表。

## 另见

[CREATE TABLE AS](./create-table-as.md), [CREATE TABLE](./create-table.md), [COPY](./copy.md), [SELECT INTO](./select-into.md), [INSERT](./insert.md)

**上级主题：** [SQL命令参考](./README.md)

