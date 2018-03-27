# 字符集支持

HashData 数据库里面的字符集支持用户能够以各种字符集存储文本，包括单字节字符集， 比如 ISO 8859 系列，以及多字节字符集 ，比如EUC（扩展 Unix 编码 Extended Unix Code）、UTF-8 和 Mule 内部编码。 所有被支持的字符集都可以被客户端透明地使用，但少数只能在服务器上使用（即作为一种服务器端编码）。 初始化用户的HashData 数据库数组时，会选择默认字符集 gpinitsystem。 在用户创建一个数据库时可以重载它，因此用户可能会有多个数据库并且每一个使用不同的字符集。

##### 表 1. HashData 数据库字符集 [1](#fntarg_1)

| Name | Description | Language | Server? | Bytes/Char | Aliases |
| :--- | :--- | :--- | :--- | :--- | :--- |
| BIG5 | Big Five | Traditional Chinese | No | 1-2 | WIN950, Windows950 |
| EUC\_CN | Extended UNIX Code-CN | Simplified Chinese | Yes | 1-3 |  |
| EUC\_JP | Extended UNIX Code-JP | Japanese | Yes | 1-3 |  |
| EUC\_KR | Extended UNIX Code-KR | Korean | Yes | 1-3 |  |
| EUC\_TW | Extended UNIX Code-TW | Traditional Chinese, Taiwanese | Yes | 1-3 |  |
| GB18030 | National Standard | Chinese | No | 1-2 |  |
| GBK | Extended National Standard | Simplified Chinese | No | 1-2 | WIN936, Windows936 |
| ISO\_8859\_5 | ISO 8859-5, ECMA 113 | Latin/Cyrillic | Yes | 1 |  |
| ISO\_8859\_6 | ISO 8859-6, ECMA 114 | Latin/Arabic | Yes | 1 |  |
| ISO\_8859\_7 | ISO 8859-7, ECMA 118 | Latin/Greek | Yes | 1 |  |
| ISO\_8859\_8 | ISO 8859-8, ECMA 121 | Latin/Hebrew | Yes | 1 |  |
| JOHAB | JOHA | Korean \(Hangul\) | Yes | 1-3 |  |
| KOI8 | KOI8-R\(U\) | Cyrillic | Yes | 1 | KOI8R |
| LATIN1 | ISO 8859-1, ECMA 94 | Western European | Yes | 1 | ISO88591 |
| LATIN2 | ISO 8859-2, ECMA 94 | Central European | Yes | 1 | ISO88592 |
| LATIN3 | ISO 8859-3, ECMA 94 | South European | Yes | 1 | ISO88593 |
| LATIN4 | ISO 8859-4, ECMA 94 | North European | Yes | 1 | ISO88594 |
| LATIN5 | ISO 8859-9, ECMA 128 | Turkish | Yes | 1 | ISO88599 |
| LATIN6 | ISO 8859-10, ECMA 144 | Nordic | Yes | 1 | ISO885910 |
| LATIN7 | ISO 8859-13 | Baltic | Yes | 1 | ISO885913 |
| LATIN8 | ISO 8859-14 | Celtic | Yes | 1 | ISO885914 |
| LATIN9 | ISO 8859-15 | LATIN1 with Euro and accents | Yes | 1 | ISO885915 |
| LATIN10 | ISO 8859-16, ASRO SR 14111 | Romanian | Yes | 1 | ISO885916 |
| MULE\_INTERNAL | Mule internal code | Multilingual Emacs | Yes | 1-4 |  |
| SJIS | Shift JIS | Japanese | No | 1-2 | Mskanji, ShiftJIS, WIN932, Windows932 |
| SQL\_ASCII | unspecified[2](http://gpdb.docs.pivotal.io/43170/ref_guide/character_sets.html#fntarg_2) | any | No | 1 |  |
| UHC | Unified Hangul Code | Korean | No | 1-2 | WIN949, Windows949 |
| UTF8 | Unicode, 8-bit | all | Yes | 1-4 | Unicode |
| WIN866 | Windows CP866 | Cyrillic | Yes | 1 | ALT |
| WIN874 | Windows CP874 | Thai | Yes | 1 |  |
| WIN1250 | Windows CP1250 | Central European | Yes | 1 |  |
| WIN1251 | Windows CP1251 | Cyrillic | Yes | 1 | WIN |
| WIN1252 | Windows CP1252 | Western European | Yes | 1 |  |
| WIN1253 | Windows CP1253 | Greek | Yes | 1 |  |
| WIN1254 | Windows CP1254 | Turkish | Yes | 1 |  |
| WIN1255 | Windows CP1255 | Hebrew | Yes | 1 |  |
| WIN1256 | Windows CP1256 | Arabic | Yes | 1 |  |
| WIN1257 | Windows CP1257 | Baltic | Yes | 1 |  |
| WIN1258 | Windows CP1258 | Vietnamese | Yes | 1 | ABC, TCVN, TCVN5712, VSCII |

**上级主题：** [HashData 数据库参考指南](./README.md)

## 设置字符集

gpinitsystem通过在初始化时间读取gp\_init\_config 文件中的 ENCODING参数的设置来定义HashData 数据库系统的默认字符集。 默认的字符集是UNICODE 或UTF8.

除了用作系统级默认值之外，还可以创建一个不同字符集的数据库。例如:

```
=> CREATE DATABASE korean WITH ENCODING 'EUC_KR';
```

**重点：** 虽然用户可以指定数据库所需的任何编码， 但选择不是用户所选择的语言环境所期望的编码是不明智的。该LC\_COLLATE和 LC\_CTYPE设置意味着特定的编码，并且依赖于区域设置的操作（例如排序）可能会误解处于不兼容编码的数据。

由于这些区域设置被 gpinitsystem 系统冻结，因此在不同数据库中使用不同编码的灵活性明显比实际更理论

一种安全使用多个编码的方法是在初始化时间内将语言环境设置为C 或POSIX ，从而禁止任何真正的区域意识。

## 服务器和客户端之间的字符集转换

HashData 数据库支持服务器和客户端之间的某些字符集组合的自动字符集转换。 转换信息存储在主 _pg\_conversion_系统目录表中。 HashData 数据库带有一些预定义的转换，或者用户可以使用SQL命令创建一个新的转换CREATE CONVERSION.

##### 表 2. 客户端/服务器字符集转换

| Server Character Set | Available Client Character Sets |
| :--- | :--- |
| BIG5 | not supported as a server encoding |
| EUC\_CN | EUC\_CN, MULE\_INTERNAL, UTF8 |
| EUC\_JP | EUC\_JP, MULE\_INTERNAL, SJIS, UTF8 |
| EUC\_KR | EUC\_KR, MULE\_INTERNAL, UTF8 |
| EUC\_TW | EUC\_TW, BIG5, MULE\_INTERNAL, UTF8 |
| GB18030 | not supported as a server encoding |
| GBK | not supported as a server encoding |
| ISO\_8859\_5 | ISO\_8859\_5, KOI8, MULE\_INTERNAL, UTF8, WIN866, WIN1251 |
| ISO\_8859\_6 | ISO\_8859\_6, UTF8 |
| ISO\_8859\_7 | ISO\_8859\_7, UTF8 |
| ISO\_8859\_8 | ISO\_8859\_8, UTF8 |
| JOHAB | JOHAB, UTF8 |
| KOI8 | KOI8, ISO\_8859\_5, MULE\_INTERNAL, UTF8, WIN866, WIN1251 |
| LATIN1 | LATIN1, MULE\_INTERNAL, UTF8 |
| LATIN2 | LATIN2, MULE\_INTERNAL, UTF8, WIN1250 |
| LATIN3 | LATIN3, MULE\_INTERNAL, UTF8 |
| LATIN4 | LATIN4, MULE\_INTERNAL, UTF8 |
| LATIN5 | LATIN5, UTF8 |
| LATIN6 | LATIN6, UTF8 |
| LATIN7 | LATIN7, UTF8 |
| LATIN8 | LATIN8, UTF8 |
| LATIN9 | LATIN9, UTF8 |
| LATIN10 | LATIN10, UTF8 |
| MULE\_INTERNAL | MULE\_INTERNAL, BIG5, EUC\_CN, EUC\_JP, EUC\_KR, EUC\_TW, ISO\_8859\_5, KOI8, LATIN1 to LATIN4, SJIS, WIN866, WIN1250, WIN1251 |
| SJIS | not supported as a server encoding |
| SQL\_ASCII | not supported as a server encoding |
| UHC | not supported as a server encoding |
| UTF8 | all supported encodings |
| WIN866 | WIN866 |
| ISO\_8859\_5 | KOI8, MULE\_INTERNAL, UTF8, WIN1251 |
| WIN874 | WIN874, UTF8 |
| WIN1250 | WIN1250, LATIN2, MULE\_INTERNAL, UTF8 |
| WIN1251 | WIN1251, ISO\_8859\_5, KOI8, MULE\_INTERNAL, UTF8, WIN866 |
| WIN1252 | WIN1252, UTF8 |
| WIN1253 | WIN1253, UTF8 |
| WIN1254 | WIN1254, UTF8 |
| WIN1255 | WIN1255, UTF8 |
| WIN1256 | WIN1256, UTF8 |
| WIN1257 | WIN1257, UTF8 |
| WIN1258 | WIN1258, UTF8 |

要启用自动字符集转换，用户必须告诉HashData 数据库用户要在客户端中使用的字符集（编码）。有几种方法可以实现这一点：

* 使用\encoding 命令在psql中, 它允许用户即时更改客户端编码。
* 使用SETclient\_encoding TO。

  要设置客户端编码，请使用以下SQL命令：

```
  => SET CLIENT_ENCODING TO 'value';
```

要查询当前的客户端编码：

```
  => SHOW client_encoding;
```

要返回到默认编码：

```
  => RESET client_encoding;
```

* 使用PGCLIENTENCODING 环境变量。当在客户端的环境变量定义为 PGCLIENTENCODING 时，与服务器建立连接时会自动选择该客户端编码。\(这可以随后使用上述其他任何方法重写\)

* 设置配置参数client\_encoding。 如果client\_encoding被设置为主 postgresql.conf 文件，当建立与HashData 数据库的连接时，会自动选择该客户端编码。 \(这可以随后使用上述其他任何方法重写。\)

如果特定字符的转换是不可能的 " 假设 用户为服务器选择了 EUC\_JP 而为客户端选择了 LATIN1 则一些日文字符在LATIN1 没有表现形式" 则会报告错误。

如果客户端字符集被定义为SQL\_ASCII， 无论服务器的字符集如何，禁止编码转换。 除非用户使用所有ASCII数据，否则SQL\_ASCII 是不明智的。 不支持SQL\_ASCII 作为服务器编码。

[1](#fnsrc_1) 并非所有API都支持所有列出的字符集。例如，JDBC驱动程序不支持MULE\_INTERNAL，LATIN6，LATIN8和LATIN10。

[2](#fnsrc_2) SQL\_ASCII设置与其他设置的行为大不相同。字节值0-127根据ASCII标准进行解释，字节值128-255作为未解释的字符。如果使用任何非ASCII数据，则将SQL\_ASCII设置用作客户端编码是不明智的。不支持SQL\_ASCII作为服务器编码。

