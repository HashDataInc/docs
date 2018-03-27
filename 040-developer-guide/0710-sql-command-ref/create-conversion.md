# CREATE CONVERSION

定义一种新的编码转换。

## 概要

```
CREATE [DEFAULT] CONVERSION name FOR source_encoding TO 
     dest_encoding FROM funcname
```

## 描述

CREATE CONVERSION 定义一种字符集编码间新的转换。转换名称可能用于转换功能来指定特定的编码转换。另外, 被标记为 DEFAULT 的转换将被自动地用于客户端和服务器之间的编码转换。为了这个目的，必须定义两个转换（从编码 A 到 B 以及从编码 B 到 A）。

要创建一个转换，用户必须拥有该函数上的 EXECUTE 特权以及目标模式上的 CREATE 特权。

## 参数

DEFAULT

表示这个转换是从源编码到目标编码的默认转换。在一个模式中对于每一个编码对，只应该有一个默认转换。

_name_

转换的名称，可以被方案限定。如果没有被方案限定，该转换被定义在当前模式中。在一个模式中，转换名称必须唯一。

_source\_encoding_

源编码名称。

_dest\_encoding_

目标编码名称。

_funcname_

被用来执行转换的函数。函数名可以被方案限定。如果没有，将在路径中查找该函数。该函数必须具有一下的特征：

```
conv_proc(
    integer,  -- source encoding ID
    integer,  -- destination encoding ID
    cstring,  -- source string (null terminated C string)
    internal, -- destination (fill with a null terminated C string)
    integer   -- source string length
) RETURNS void;
```

## 注解

请注意，在本版本的 HashData 数据库中，用户定义的转换中使用的用户定义函数必须定义为 IMMUTABLE。必须将用于自定义函数的任何编译代码（共享库文件）放置在 HashData 数据库数组（Master 和所有 Segment）中每个主机上的相同位置。 该位置也必须位于 LD\_LIBRARY\_PATH 中， 以便服务器可以找到文件。

## 示例

使用 myfunc 创建一个从编码 UTF8 到 LATIN1 的转换:

```
CREATE CONVERSION myconv FOR 'UTF8' TO 'LATIN1' FROM myfunc;
```

## 兼容性

在 SQL 标准中没有 CREATE CONVERSION 语句。

## 另见

[ALTER CONVERSION](./alter-conversion.md)，[CREATE FUNCTION](./create-function.md)，[DROP CONVERSION](./drop-conversion.md)

**上级主题：** [SQL命令参考](./README.md)

