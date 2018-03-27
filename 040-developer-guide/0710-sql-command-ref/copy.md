# COPY

在一个文件和一个表之间复制数据。

## 概要

```
COPY table [(column [, ...])] FROM {'file' | STDIN}
     [ [WITH] 
       [BINARY]
       [OIDS]
       [HEADER]
       [DELIMITER [ AS ] 'delimiter']
       [NULL [ AS ] 'null string']
       [ESCAPE [ AS ] 'escape' | 'OFF']
       [NEWLINE [ AS ] 'LF' | 'CR' | 'CRLF']
       [CSV [QUOTE [ AS ] 'quote'] 
            [FORCE NOT NULL column [, ...]]
       [FILL MISSING FIELDS]
       [[LOG ERRORS]  
       SEGMENT REJECT LIMIT count [ROWS | PERCENT] ]

COPY {table [(column [, ...])] | (query)} TO {'file' | STDOUT}
      [ [WITH] 
        [ON SEGMENT]
        [BINARY]
        [OIDS]
        [HEADER]
        [DELIMITER [ AS ] 'delimiter']
        [NULL [ AS ] 'null string']
        [ESCAPE [ AS ] 'escape' | 'OFF']
        [CSV [QUOTE [ AS ] 'quote'] 
             [FORCE QUOTE column [, ...]] ]
      [IGNORE EXTERNAL PARTITIONS ]
```

## 描述

COPY 在  HashData 数据库表和标准文件系统文件之间移动数据。 COPY TO 把一个表的内容复制到另一个文件 \(如果复制存在  ON SEGMENT 条件，则根据 Segment 的 ID 复制多个文件\), 而 COPY FROM 则从一个文件复制数据到一个表 \(把数据追加到表中原有数据\)。 COPY TO 也能复制一个 SELECT 查询的结果。

> 注意: COPY FROM 当前不支持带 ON SEGMENT 选项的 COPY TO 产生的 Segment 文件拷贝数据，但是其他工具可以被用来恢复数据。

如果指定了一个列列表，COPY 将只把指定列的数据复制到文件或者从文件复制数据到指定列。如果表中有列不在列列表中， COPY FROM 将会为那些列插入默认值。

带一个文件名的 COPY 指示 HashData 数据库服务器直接从一个文件读取或者写入到一个文件。该 master 主机必须可访问该文件，并且必须从 master 主机的角度指定该名称。当指定 STDIN 或 STDOUT 时，数据通过客户端和 master 主机之间的连接来传输。

当 COPY 和 ON SEGMENT 选项一起被使用时， COPY TO 导致 Segment 创建面向 Segment 的个体文件，这些文件保留在 Segment 主机上。ON SEGMENT 的文件参数是用字符串文字 `<SEGID>` \(必须\) 并使用绝对路径或 `<SEG_DATA_DIR>` 字符串文字。 当运行 COPY 操作时，Segment 的 ID 和 Segment 数据目录的路径被替换为字符串文字值。

ON SEGMENT 选项允许用户将表数据复制到 Segment 主机上的文件，以用于诸如在集群之间迁移数据或执行备份等操作。 通过 ON SEGMENT 选项创建的 Segment 数据可以通过 gpfdist 等工具进行恢复，这对于高速数据加载是有用的。

COPY FROM 当前不支持从带 ON SEGMENT 选项的 COPY TO 产生的 Segment 文件拷贝数据，但是其他工具可以被用来恢复数据。

当指定 STDIN 或 STDOUT 时，通过客户端和主机之间的连接传输数据。 STDOUT 不能与 ON SEGMENT 选项一起使用。

如果使用了 SEGMENT REJECT LIMIT ，则 COPY FROM 操作将在单行错误隔离模式下运行。在此版本中，单行错误隔离模式仅适用于具有格式错误的输入文件中的行 - 例如，额外或缺少属性，错误数据类型的属性或无效的客户端编码序列。诸如违反了 NOT NULL, CHECK, 或 UNIQUE 约束的约束错误仍将以 'all-or-nothing' 输入模式进行处理。用户可以指定可接受的错误行数（以每个 Segment 为单位），之后整个 COPY FROM 操作将被终止， 并且不再加载任何行。 错误行的计数以每个 Segment 而不是整个加载操作为基础。如果未达到每 Segment 的拒绝限制，则将加载不包含错误的所有行，并丢弃任何错误行。要保留错误行进一步检查，请指定 LOG ERRORS 子句以捕获错误日志信息。错误信息和行存储在 HashData 数据库中。

**输出**

成功完成后， COPY 命令将返回表单的命令标签，其中 count 是复制的行数：

```
COPY count
```

如果单行隔离模式下运行 COPY FROM 命令， 如果由于格式错误而未加载任何行，则将返回以下通知消息， 其中 count 是拒绝的行数：

```
NOTICE: Rejected count badly formatted rows.
```

## 参数

_table_

一个现有表的名称（可以是方案限定的）。

_column_

可选的要被复制的列列表。如果没有指定列列表，则该表的所有列都会被复制。

当以文本格式复制时，默认为一列数据类型 bytea 最高可达 256MB.

_query_

一个SELECT 或 VALUES 其结果将被复制。请注意，查询需要括号。

_file_

输入或者输出文件的路径名。

PROGRAM '_command_'

指定一个命令行去执行。该命令行必须从 HashData 数据库的 Master 主机系统指定，并且对 HashData 数据库管理员用户（gpadmin）可执行。COPY FROM 命令行从该命令行的标准输出读取数据作为输入，对于  COPY TO 命令的数据被写入该命令行的标准输入中。

该命令行是被 shell 唤起的。当传输参数到 shell 时，要避免或去除任何对于 shell 存在特殊意义的字符。为了安全考虑，最好使用固定的命令行，或者至少应该避免传输任何用户输入到字符串中。

当指定 ON SEGMENT 选项时，该命令必须在所有 HashData 数据库 primary segment 主机上，对于 HashData 数据库管理员用户（gpadmin）是可执行的。每个 HashData Segment Instance 都会执行此命令。此命令需要指定 `<SEGID>` 。

STDIN

指定输入来自客户端应用。

STDOUT

指定输出会去到客户端应用。

ON SEGMENT

单独指定 Segment 主机上面的 Segment 数据文件。每个文件都包含 primary Segment Instance 管理的表的数据。例如，当使用 COPY TO...ON SEGMENT 命令从一个表中拷贝数据到文件时，该命令会为在 segment 主机上面的每个 segment Instance 创建一个文件。每个文件都包含由 segment instance 管理的表的数据。COPY 命令不会从 mirror segment instances 和 segment 数据文件拷贝数据或者写入数据。

STDIN 和 STDOUT 关键字不能与 ON SEGMENT 一起使用。

使用 `<SEG_DATA_DIR>` 和 `<SEGID>` 字符串，通过以下语法指定一个绝对路径和文件名称：

```
COPY table [TO|FROM] '<SEG_DATA_DIR>/gpdumpname<SEGID>_suffix' ON SEGMENT;
```

镜像 Segment 不会将其数据拷贝到 Segment 文件中。

`<SEG_DATA_DIR>`

表示 ON SEGMENT 拷贝的 Segment 数据目录的完整路径的字符串文字。'&lt;' 和 '&gt;' 是用于指定路径的字符串文字的一部分。 COPY 运行时，用字符串文字替换段路径。 可以用绝对路径代替使用 `<SEG_DATA_DIR>` 字符串文字。

`<SEGID>`

表示复制 ON SEGMENT 时要复制的 Segment 的内容 ID 号的字符串文字。 `<SEGID>` 是 ON SEGMENT 选项的必需部分。 '&lt;' 和 '&gt;' 是用于指定路径的字符串文字的一部分。 COPY 运行时， COPY 将使用内容 ID 替换字符串文字。

BINARY

使所有数据以二进制格式存储或读取，而不是文本。用户不能指定 DELIMITER, NULL,或 CSV 二进制模式下的选项。

当以二进制格式复制时，一行数据最多可达 1GB。

OIDS

指定复制每行的 OID。（如果为没有 OID 的表指定了 OIDS，或者在复制查询的情况下，则会引发错误。）

_delimiter_

单个 ASCII 字符，用于分隔文件每行（行）中的列。默认是文本模式下的制表符，逗号在 CSV 模式。

_null string_

表示空值的字符串。 文本模式中的默认值为 \N \(反斜杠 - N\) ， CSV 模式中不含引号的空值。 在不想将空值与空字符串区分开的情况下，即使在文本模式下，也可能更喜欢空字符串。 当使用 COPY FROM 时，与字符串匹配的任何数据项将被转储为空值，因为用户应该确保使用与 COPY TO 中使用的字符串相同。

_escape_

指定用于 C 转义序列的单个字符\(如 \n,\t,\100, 等\) 和引用可能被视为行或列分隔符的数据字符。确保选择在实际列数据中的任何地方都不使用的转义字符。默认转义符为 \(反斜杠\)用于文本文件或 " \(双引号\) 用于 CSV 文件, 但是可以指定任何其他字符来表示转义。还可以通过指定值 'OFF' 作为转义值。这对于诸如 Web 日志数据之类的数据非常有用，该数据具有许多嵌入式反斜杠，这些反斜杠不是要转义的。

NEWLINE

指定数据文件中使用的换行符 — LF（换行，0x0A）、CR（回车，0x0D）或者 CRLF（回车加换行，0x0D 0x0A）。如果未指定， HashData 数据库的 Segment 将通过查看其接收的第一行数据并使用遇到的第一个换行符来检测换行类型。

CSV

选择逗号分隔值（CSV）模式。

HEADER

指定一个文件包含一个标题行和文件中每列的名称。在输出时，第一行包含表中的列名，在输入时，第一行将被忽略。

引用

以 CSV 模式指定引用字符。默认是双引号。

FORCE QUOTE

在 CSV COPY TO 模式下，强制引用用于每个指定列中的所有非 NULL 值。 NULL 值输出从不引用。

FORCE NOT NULL

在 CSV COPY FROM 模式下，处理每一个指定的列，就好像它被引用一样， 因此不是 NULL 值。对于  CSV 模式默认的字符串\(两个分割符之间不存在\)，这会导致将值作为零长度字符串计算。

FILL MISSING FIELDS

在 TEXT 和 CSV 中的 COPY FROM 中，指定 FILL MISSING FIELDS 时，当一行数据在行或行的末尾缺少数据字段时，将丢失尾字段值设置为 NULL \(而不是报告错误\)。 空行，具有 NOT NULL 在 TEXT 和 CSV 中的 COPY FROM 中，指定 FILL MISSING FIELDS 时，当一行数据在行或行的末尾缺少数据字段时，将丢失尾字段值设置为 NULL（而不是报告错误）。 空行，具有 NOT NULL 约束的字段和行上的尾随分隔符仍然会报告错误。

LOG ERRORS

这是一个可选子句，可以在 SEGMENT REJECT LIMIT 之前捕获有关格式错误的行的错误日志信息。

错误日志信息在内部存储，并使用数据库内置 SQL 函数 `gp_read_error_log()` 访问。

这是一个可选的子句，可以在 SEGMENT REJECT LIMIT 子句之前捕获有关格式错误的行的错误日志信息。错误日志信息在内部存储， 并使用 HashData 数据库内置 SQL 函数 `gp_read_error_log（）` 访问。

SEGMENT REJECT LIMIT count \[ROWS \| PERCENT\]

在单行模式下运行 COPY FROM 操作。 如果输入行具有格式错误，则它们将被丢弃，前提是在加载操作期间在任何 HashData 数据库 Segment 实例上未达到拒绝限制计数。拒绝限制计数可以指定为行数（默认值）或总行数百分比（1-100）。 如果 PERCENT 被使用，每个 Segment 只有在处理参数 `gp_reject_percent_threshold` 所指定的行数之后才开始计算行百分比。  `gp_reject_percent_threshold` 默认值为 300 行。 诸如违反 NOT NULL， CHECK, 或 UNIQUE的约束错误仍将以 'all-or-nothing' 输入模式进行处理。如果没有达到限制，所有好的行将被加载，任何错误将被丢弃。

> 注意：HashData 数据库限制了可能包含格式错误的初始行数 SEGMENT REJECT LIMIT 不是首先被触发或没有被指定。 如果前 1000 行被拒绝，COPY 操作停止并回滚。

可以使用 HashData  Database 服务器配置参数更改初始拒绝行数的限制 `gp_initial_bad_row_limit`。

IGNORE EXTERNAL PARTITIONS

从分区表复制数据时，数据不会从作为外部表的叶子分区复制。当不复制数据时，会将消息添加到日志文件中。

如果未指定此子句，并且 HashData 数据库尝试从作为外部表的叶子分区复制数据，则会返回错误。

## 注解

COPY 只能与表一起使用，而不能与外部表或视图一起使用。 但是，用户可以写 COPY \(SELECT \* FROM viewname\) TO ...

要从具有作为外部表的叶子分区的分区表复制数据，请使用 SQL 查询来复制数据。例如，如果表 my\_sales 包含一个叶子子分区，这是一个外部表，这个命令 COPY my\_sales TO stdout 返回错误。 此命令将数据发送到 stdout：

```
COPY (SELECT * from my_sales ) TO stdout
```

该 BINARY 关键字将所有数据存储/读取为二进制格式而不是文本。它比正常的文本模式要快一点，但二进制格式的文件在机器架构和 HashData 数据库版本之间的移植性更低。 另外，如果数据是二进制格式, 用户不能运行 COPY FROM  在单行错误隔离模式下。

用户必须对其值由 COPY TO 读取的表具有 SELECT 权限，并在 COPY FROM 插入的值上插入特权。

在 COPY 命令中命名的文件由数据库服务器直接读取或写入，而不是由客户端应用程序读取或写入。 因此，它们必须驻留在 HashData 数据库 master 主机上或可访问，而不是客户端。 它们必须由 HashData 数据库系统用户（服务器运行的用户 ID）而不是客户机可访问和可读写。 COPY 命名文件只允许数据库超级用户使用，因为它允许读取或写入服务器具有访问权限的任何文件。

COPY FROM 将调用目标表上的任何触发器和检查约束。 但是，它不会调用重写规则。 请注意，在此版本中，不对单行错误隔离模式评估对约束的违规。

COPY 的输入输出受 DateStyle 影响。为了确保对可能使用非默认 DateStyle 设置的其他 HashData 数据库安装的可移植性，在使用 COPY TO 之前， 应将 DateStyle 设置为 ISO。

在文本模式下从文件复制 XML 数据时，服务器配置参数 xmloption 影响复制的 XML 数据的验证。 如果值为 content \(默认\)， XML 数据被验证为 XML 内容片段。如果参数值为 document, XML 数据被验证为 XML 文档。如果 XML 数据无效， COPY 返回错误。

默认情况下， COPY 在第一个错误时停止运行。 在 COPY TO 的情况下，这不应该导致问题但是目标表已经在 COPY FROM 中接受了较早的行。这些行将不可见或可访问，但他们仍占用磁盘空间，如果故障发生在大的 COPY FROM 操作中这可能会相当大量的浪费磁盘空间。用户可能希望 VACUUM 来恢复浪费的空间。 另一个选择是使用单行错误隔离模式来过滤错误行，同时仍然加载好的行。

当用户指定 LOG ERRORS 子句时， HashData 数据库捕获读取外部表数据时发生的错误。用户可以查看和管理捕获的错误日志数据。

* 使用内置的 SQL 函数 `gp_read_error_log('table_name')`。需要在 table\_name 上有 SELECT 特权。 此示例显示使用 COPY 命令加载到表 ext\_expenses 中的数据错误日志信息：

  ```
  SELECT * from gp_read_error_log('ext_expenses');
  ```

  如果 table\_name 表不存在该函数返回 FALSE 。

* 如果指定的表存在错误日志数据，新的错误日志数据将附加到现有的错误日志数据。错误日志信息不会复制到镜像 Segment。

* 使用内置的 SQL 函数 `gp_truncate_error_log('table_name')` 删除 table\_name中的错误日志数据。它需要表所有者权限。此示例删除将数据移动到表中时捕获的错误日志信息 ext\_expenses:

  ```
  SELECT gp_truncate_error_log('ext_expenses');
  ```

  如果 table\_name 表不存在函数返回 FALSE 。

  指定 \* 通配符删除当前数据库中现有表的错误日志信息。指定字符串 \*.\* 删除所有数据库错误日志信息，包括由于以前的数据库问题而未被删除的错误日志信息。如果 \* 没被指定， 则需要数据库所有者权限。如果 \*.\* 被指定，需要操作系统超级用户权限。

当不是超级用户的 HashData 数据库用户运行 COPY 命令时， 命令可以由资源队列控制。必须配置资源队列 ACTIVE\_STATEMENTS 参数，指定分配给该队列的角色可以执行的查询数量的最大限制。 HashData 数据库不会将消耗值或内存值应用于 COPY 命令， 只有消耗或内存限制的资源队列不影响运行 COPY 命令。

非超级用户只能运行这些类型 COPY 命令：

* COPY FROM 命令，其中源为 stdin
* COPY TO 命令，其中源为 stdout

## 文件格式

文件格式支持 COPY。

**文本格式**

当使用的 COPY 不带 BINARY 或 CSV 选项时，读取或写入的数据是每个表行一行的文本文件。一行中的列由分隔符字符 \(默认选项卡\)分割。列值本身是由每个属性的数据类型的输出函数生成的或输入函数可接受的字符串。使用指定的空字符串代替为空的列。如果输入文件的任何行包含比预期的更多或更少的列， COPY FROM 将引发错误。如果 OIDS 被指定，OID作为被读取或写入第一列，位于用户数据列之前。

数据文件有两个具有 COPY 特殊含义的保留字符:

* 指定的分隔符（默认为 tab），用于分隔数据文件中的字段。
* UNIX 样式换行符 \(n 或 0x0a\), 用于指定数据文件中的新行。强烈建议应用程序生成 COPY 数据的应用程序将数据换行符转换为 UNIX 样式的换行符，而不是 Microsoft Windows 样式回车换行 \(rn 或0x0a 0x0d\)。

如果用户的数据包含这些字符，用户必须转义该字符，因此 COPY 将其视为数据而不是字段分隔符或新行。

默认情况下，转义字符是文本格式文件的（反斜杠）和 " \(双引号\) 为 csv 格式的文件。如果要使用不同的转义字符，可以使用 ESCAPE AS 子句。 确保选择一个在数据文件中的任何位置不被用作实际数据值的转义字符。用户还可以通过使用禁用文本格式文件中的转义 ESCAPE 'OFF'。

例如，假设用户有一个具有三列的表，并且用户想使用 COPY 加载以下三个字段。

* 百分比 = %
* 垂直条 = \|
* 反斜杠 = 

指定的分隔符是 \| \(管道字符\), 用户指定的转义字符是 \* \(星号\)。数据文件中格式化的行将如下所示：

```
percentage sign = % | vertical bar = ***|** | backslash =
```

请注意，使用星号（\*）转义数据的一部分的管道字符。 还要注意，由于我们使用替代转义字符，我们不需要转义反斜杠。

以下字符必须在转义字符前面，如果它们显示为列值的一部分：转义字符本身，换行符，回车符和当前分隔符字符。用户可以使用 ESCAPE AS 子句指定其他转义符。

**CSV Format**

此格式用于导入和导出许多其他程序（如电子表格）使用的逗号分隔值（CSV）文件格式。 而不是 HashData  Database 标准文本模式使用的转义，它会生成并识别常用的 CSV 转义机制。

每个记录的值由 DELIMITER 字符分隔。 如果值包含分隔符字符，则 QUOTE 字符， ESCAPE 字符\(默认为双引号\), NULL 字符串， 回车符或换行字符，则整个值为前缀，后缀为 QUOTE 字符。用户可以使用 FORCE QUOTE 强制引用在特定列中输出非NULL 。

CSV 格式没有标准的方法来区分 NULL 值和空字符串。  HashData 数据库通过 COPY 引用来处理 。一个 NULL 作为 NULL 字符串输出，不引用， 而与 NULL 字符串匹配的数据值被引用。 因此，使用默认设置，NULL 写为无引号的空字符串，而空字符串用双引号（“”）写入。阅读值遵循相似的规则。用户可以使用 FORCE NOT NULL 来阻止特定列的 NULL 输出比较。

因为反斜杠不是一个特殊的字符 CSV 格式，出现在行上的单个条目的数据值在输出上自动引用，并且在输入时（如果引用）不会被解释为数据结尾标记。 如果用户正在加载另一个应用程序创建的文件，该应用程序具有单个未引用的列， 并且值可能为 . ， 用户可能需要在输入文件中引用该值。

> 注解： 在 CSV 模式，所有字符都很重要。由空格或 DELIMITER 以外的任何字符包围的引用值将包含这些字符。如果用户从系统中将数据从白色空间填充到某些固定宽度的系统中，则可能会导致错误。如果出现这种情况，则在将数据导入到 HashData 数据库之前，用户可能需要预处理 CSV 文件以删除尾随的空格。

CSV 模式将会识别并生成包含嵌入回车符和换行符的引用值的 CSV 文件。因此，文件不是每个表行严格一行，如文本模式文件。

注解： 许多程序产生奇怪且偶然的 CSV 文件，因此文件格式比标准更为常规。因此，用户可能会遇到一些无法使用此机制导入的文件，COPY 可能会生成 其他程序无法处理的文件。

**二进制格式**

该 BINARY 格式由文件头，包含行数据的零个或多个元组和文件预告片组成。标题和数据是网络字节顺序

* **文件头** — 文件头由 15 个字节的固定字段组成，后面是可变长度的标题扩展区。固定字段是：
  * **签名** — 11 字节序列 PGCOPY  n  377  r  n  0 - 请注意，零字节是签名的必需部分。（签名被设计为容易地识别由非8位清理传输所掩盖的文件，该签名将通过行尾转换过滤器，丢弃的零字节，丢弃的高位或奇偶变化。）
  * **标志字段** — 32 位整数位掩码，用于表示文件格式的重要方面。位从 0（LSB）到31（MSB）编号。请注意，该字段以网络字节顺序（最高有效字节优先）存储，以及文件格式中使用的所有整数字段。位 16-31 保留以表示关键文件格式问题; 如果发现在此范围内设置了意外的位，读取器将中止。bit 0-15 被保留以表示向后兼容的格式问题; 读者应该简单地忽略在此范围内设置的任何意外的位。目前只定义了一个标志，其余的标志位必须为零（如果数据有 OID，则为16：1，否则为 0）。
  * **标题扩展区长度** — 32 位整数，标题剩余字节长度，不包括自身。目前，这是零，第一个元组立即跟随。格式的未来更改可能允许在标题中存在附加数据。读者应该默默地跳过任何不知道该怎么做的标题扩展名数据。标题扩展区域被设想为包含一系列自识别块。 标志字段不是要告诉读者扩展区域是什么。标题扩展内容的具体设计留待以后发布。
* **元组** — 每个元组从元组中的字段数的 16 位整数开始。（目前，表中的所有元组都将具有相同的计数，但可能并不总是如此）。然后，对于元组中的每个字段重复，都有一个 32 位长度的字， 后跟多个字段的字段数据。（长度字不包括本身，可以为零）。作为特殊情况，-1 表示 NULL 字段值。在 NULL 的情况下没有值字节。

  字段之间没有对齐填充或任何其他额外的数据。

  目前，COPY BINARY 文件中的所有数据值都被假定为二进制格式（格式代码一）。预计未来的扩展可能会添加一个头域，允许指定每列格式代码。

  如果 OID 包含在文件中，则 OID 字段紧跟在字段计数字之后。 这是一个正常的字段，除了它不包括在字段计数中。 特别是它有一个长度字 - 这将允许处理 4 字节与 8 字节 OID 没有太多的痛苦，并将允许 OID 显示为 null，如果有证明是可取的。

* **File Trailer** — file trailer 由包含 -1 的 16 位整数组成。 这很容易与元组的字段计数字区分开。 如果字段计数字不是 -1 -1也不是预期的列数，读者应该报告错误。 这提供额外的检查，以防止与数据不同步。

## 示例

使用垂直条（\|）作为字段分隔符将表复制到客户端：

```
COPY country TO STDOUT WITH DELIMITER '|';
```

从文件中复制数据到 country 表中:

```
COPY country FROM '/home/usr1/sql/country_data';
```

复制到名称以 'A' 开头的国家/地区的文件:

```
COPY (SELECT * FROM country WHERE country_name LIKE 'A%') TO 
'/home/usr1/sql/a_list_countries.copy';
```

将数据从文件复制到 sales 表使用单行错误隔离模式和日志错误：

```
COPY sales FROM '/home/usr1/sql/sales_data' LOG ERRORS 
   SEGMENT REJECT LIMIT 10 ROWS;
```

要拷贝 Segment 数据供以后使用，使用 ON SEGMENT 语句。 使用 ON SEGMENT 语句的形式为:

```
COPY table TO '<SEG_DATA_DIR>/gpdumpname<SEGID>_suffix' ON SEGMENT;
```

该 `<SEGID>` 是必须的。 但是，用户可以替换绝对路径 `<SEG_DATA_DIR>` 字符串文字在路径中。

当用户传递字符串文字 `<SEG_DATA_DIR>` 和 `<SEGID>` 到 COPY, COPY 将在运行操作时填写适当的值。

例如, 如果用户有表 mytable 以及如下所示的 Segment 和镜像 Segment：

```
contentid | dbid | file segment location 
    0     |  1   |/home/usr1/data1/gpsegdir0

    0     |  3   | /home/usr1/data_mirror1/gpsegdir0 

    1     |  4   | /home/usr1/data2/gpsegdir1

    1     |  2   | /home/usr1/data_mirror2/gpsegdir1
```

运行命令:

```
COPY mytable TO '<SEG_DATA_DIR>/gpbackup<SEGID>.txt' ON SEGMENT;
```

将导致以下文件:

```
/home/usr1/data1/gpsegdir0/gpbackup0.txt
/home/usr1/data2/gpsegdir1/gpbackup1.txt
```

第一列中的内容 ID 是插入到文件路径中的标识符 \(例如， gpsegdir0/gpbackup0.txt above\) 文件是在 Segment 主机上创建的，而不是在主服务器上，因为它们将在标准中 COPY 操作。 使用时，不会为镜像 Segment 创建任何数据文件 ON SEGMENT 复制。

如果指定绝对路径，而不是 `<SEG_DATA_DIR>`,如在声明中

```
COPY mytable TO '/tmp/gpdir/gpbackup_<SEGID>.txt' ON SEGMENT;
```

文件将被放置在每个段上的 /tmp/gpdir 中。

> 注解： 该 COPY FROM 操作目前还不支持 ON SEGMENT 语句。像 gpfdist 这样的工具可以恢复数据。

## 兼容性

在 SQL 标准中没有 COPY 语句。

## 另见

[CREATE EXTERNAL TABLE](./create-external-table.md)

**上级主题：** [SQL命令参考](./README.md)

