# CREATE TYPE

# 创建类型

描述一个新的数据类型。

## 概要

```
CREATE TYPE name AS ( attribute_name data_type [, ... ] )

CREATE TYPE name AS ENUM ( 'label' [, ... ] )

CREATE TYPE name (
    INPUT = input_function,
    OUTPUT = output_function
    [, RECEIVE = receive_function]
    [, SEND = send_function]
    [, TYPMOD_IN = type_modifier_input_function ]
    [, TYPMOD_OUT = type_modifier_output_function ]
    [, INTERNALLENGTH = {internallength | VARIABLE}]
    [, PASSEDBYVALUE]
    [, ALIGNMENT = alignment]
    [, STORAGE = storage]
    [, DEFAULT = default]
    [, ELEMENT = element]
    [, DELIMITER = delimiter] )

CREATE TYPE name
```

## 描述

CREATE TYPE 在当前数据库中注册了一个新的要使用的数据类型。定义该类型的用户是他的拥有者。

如果给定了模式，则该类型就会在指定的模式中创建。否则，会在当前的模式中创建。该类型的名字必须和该模式中任何存在的类型或域的名字不同。该类型的名字也必须和同模式中存在的表的名字不同。

**复合类型**

该 CREATE TYPE 的第一个形式创建了一个复合类型。该复合类型由属性名字和数据类型的列表指定。这本质上和表的行类型一样，但是，当仅需要定义一个类型时，使用 CREATE TYPE 避免了需要去创建实际的表。独立复合类型作为参数或者函数的返回类型来说是有用的。

**枚举类型**

该 CREATE TYPE 的第二种形式创建了一个（ENUM）的枚举类型，正如在 PostgreSQL 文档中描述的 [枚举类型](https://www.postgresql.org/docs/8.3/static/datatype-enum.html)。枚举类型列出一个或多个引用的标签，每个标签必须小于 NAMEDATALEN 个字节长（标准中为 64）。

**基础类型**

该 CREATE TYPE 的第三种形式创建了一个新的基础类型（标量类型）。该参数可能会以任何顺序出现，不仅在语法中显示，大多数都是可选的。用户在定义类型之前，必须注册 2 个或更多函数（使用 CREATE FUNCTION）。支持函数 `input_function` 和 `output_function` 时必须的， 然而 `receive_function`，`send_function`，`type_modifier_input_function`，`type_modifier_output_function` 和 `analyze_function` 函数是可选的。一般来说，这些函数必须是以 c 编写或者其他低级语言。在 HashData 数据库中，任何用于实现一个数据类型的函数必须定义成 IMMUTABLE。

该 `input_function` 将类型的外部文本表示转换为为之定义的操作符和函数使用的内部表示形式。`output_function` 执行反向转换，该输入函数可以被声明为采用一个 cstring 类型参数，或者声明为采用 cstring, oid，integer 三个参数。第一个参数是输入文本作为 C 字符串，第二个参数是类型自己的 OID（数组类型除外，它是接收它元素类型的 OID），第三个参数是目标列的 typmod，（如果已知的话）（如果未知的话，会传递-1）。该输入函数必须返回数据类型本身的值。通常，一个输入函数应该被声明为 STRICT；如果不是，当读取 NULL 输入值时，将使用 NULL 作为第一个参数来调用函数。这种情况下，该函数必须仍然返回 NULL 值，除非他引发错误。（这种情况主要是为了支持域输入功能，该可能需要拒绝 NULL 输入。）输出函数必须声明为采用新数据类型的一个参数。该输出函数必须返回 cstring。输出函数不会为 NULL 值调用。

该可选函数 `receive_function` 转换类型的外部二进制表示到内部表示。如果不支持这个函数，则该类型不能参与二进制输入。该二进制表示应该被选择为便于转换为内部形式，同时可以相当便携。（例如，标准整数数据类型使用网络字节顺序作为外部二进制表示，而内部表示是本地机器字节顺序）接收函数应执行足够的检查来确保值是有效的。接收函数可以被声明为使用一个参数类型为 internal 的函数，或者使用 internal，oid，integer 三个参数类型。第一个参数是一个指向 StringInfo 缓冲区的指针，它保存接收到的字节串；可选参数与文本输入函数相同。接收函数必须返回该数据类型的值。通常，接收函数应声明为 STRICT；如果不是，当读取 NULL 输入值时，将使用 NULL 为第一个参数调用此函数，这种情况下，函数必须返回 NULL，除非它引发错误。（这种情况主要是为了支持域接收功能，可能需要拒绝 NULL 输入。\)同样，可选的 `send_function` 将从内部表示转换为外部二进制表示。如果未提供此功能，则该类型不能参与二进制输出。发送函数必须声明为采用新数据类型为一个参数，该发送函数必须返回类型为 bytea 的数据。发送函数必须为 NULL 值调用。

如果该类型支持修饰符，则需要可选的 `type_modifier_input_function` 和 `type_modifier_output_function`。修饰符是附加到类型声明上的约束，例如 char\(5\) 或 numeric\(30,2\)。然而 HashData 数据库允许用户定义的类型将一个或多个简单常量或者标识符作为修饰符，但是该信息必须适合单个非负整数值，以便在系统目录中存储。 HashData 数据库将声明的修饰符以cstring 数组的形式传递给 `type_modifier_input_function`。该修饰符输入函数必须检查值的有效性，如果不正确抛出异常。如果值正确，该修饰符输入函数返回单个非负整数值， HashData 数据库将把之作为列 typmod 存储。如果该类型未使用 `type_modifier_input_function` 定义，则类型修饰符将被拒绝。该 `type_modifier_output_function` 将内部整数 typmod 值转换为正确的表单，以供用户显示。该修饰符输出函数必须返回一个 cstring 值，该值是要附加到类型名称的确切的字符串。例如， numeric's 函数可能返回 \(30,2\)。 该 `type_modifier_output_function` 是可选的。当没有指定时，该默认显示形式是存储的括号中的 typmod 整数值。

当必须在创建新类型之前创建他们，用户应该在这一点上想知道输入和输出函数如何被声明为具有新类型的结果或参数。答案应该是首先将该类型定义为一个 shell 类型，他是一个占位符，除名字和所有者之外没有其他属性。这可以通过发出命令 CREATE TYPE name 来完成，没有其他参数。然后可以引用 shell 类型定义 I/O 函数。最后，具有完整定义的 CREATE TYPE 将使用完整的有效的类型定义替换 shell 条目，之后，可以正常使用新的类型定义了。

虽然新类型的内部表示的细节只有 I/O 函数和用户创建的该类型的其他函数才了解，但是内部表示的几个属性必须声明到 HashData 数据库。其中最重要的额是 internallength。基本数据类型可以使固定长度的，这种情况下，internallength 是一个正整数，或者可变长度，通过将 internallength 设置为  VARIABLE 来表示。（在内部，这通过将 typlen 设置成 -1 来表示。\) 所有可变长度类型的内部表示必须以 4 字节整数开头，给出此类型值的总长度。

该可选标志 PASSEDBYVALUE 表示此数据类型的值通过值传递而不是引用传递。用户不能通过类型来传递，该类型的内部表示比 Datum 类型内部表示大小（size）大（大多数机器上为 4 个字节，少数机器上为 8 字节）。

该 aligment 参数指定数据类型所需的存储对齐。允许的值等于 1，2，4 或 8 字节边界上的对齐。注意，可变长度类型必须具有至少 4 的对齐，因为它们必须包含 int4 作为其第一个组成数。

该 storage 参数允许变长数据类型存储策略的选择。（对于固定长度类型，只允许 plain 策略）plain 指定类型的数据将始终线性存储，而不是压缩。extended 指定系统将首先尝试压缩长数据值，如果它仍然太长，将值移动到主表行之外。external 允许将值移出主表，但是该系统不会尝试压缩它。main 允许压缩，但是不鼓励将数据移出主表。（如果没有其他的方式使得数据适应行，指定该策略的数据项可能还是会被移出主表，但是它会优先于 extended 和 external 选项将之保留在主表中\)

可以指定默认值，以防用户希望数据类型的列默认为非空值。使用 DEFAULT 关键字来指定默认值。（这样的默认值可能会被附加到该列显式的 DEFAULT 子句覆盖。）

要指定类型为数组，请使用关键字 ELEMENT 关键字指定数组元素的类型。例如，要定义一个 4 字节整数的（int4）的数组，请指定 ELEMENT = int4。更多关于数组类型的更多细节如下所示。

要指定在该类型数组内部表示值之间的分隔符，可以将 delimiter 设定为特殊的字符。默认的分隔符是逗号（，）。注意，该分隔符号与数组元素类型相关联，而不是数组类型本身。

**数组类型**

每当创建用户定义的基本数据类型时， HashData 数据库自动创建相关联的数组类型，其名称由前缀为下划线的基本类型名称组成。解析器了解这个命名约定，并将类型为 foo\[\] 的列的请求转换为类型为 \_foo 的请求。隐式创建的数组类型是可变长度，并使用内置的输入和输出函数 `array_in` 和 `array_out`。

如果系统自动创建正确的数组类型，用户可能会合理地问为什么有一个 ELEMENT 选项。使用 ELEMENT 有用的唯一的情况是当用户创建固定长度的类型时，恰好在内部是相同数字的数组，用户希望允许直接通过下标访问这些东西，除了用户计划为该类型整体提供的任何操作。例如，类型 name 允许以这种方式访问其组成的 char 元素。2-D 点类型可以允许其两个组成数字可以像 point\[0\] 和 point\[1\] 被访问。注意，该便利，仅适用于固定长度类型，其内部格式正好是相同固定长度字段的序列。可下标表示的可变长度类型必须有由 `array_in` 和 `array_out` 使用的广义内部表示。由于历史原因，固定长度数组类型的下标从零开始，而可变长度类型却不行。

## 参数

name

要创建类型的名字（可选方案限定）。

`attribute_name`

复合类型属性的（列）名字。

`data_type`

成为复合类型列的存在的数据类型的名字。

label

表示和枚举类型一个值相关联的文字标签的字符串文字。

`input_function`

将数据从类型的外部文本形式转换为内部表单的函数的名称。

`output_function`

将数据从类型的内部表单转换为外部文本形式的函数的名称。

`receive_function`

将数据类型的外部二进制形式转换为其内部形式的函数的名称。

`send_function`

将数据类型的内部表单转换为其外部二进制形式的函数的名称。

`type_modifier_input_function`

将类型的修饰符数组转化为内部形式的函数的名称。

`type_modifier_output_function`

将类型修饰符的内部形式转化为外部文本形式的函数的名称。

internallength

一个数字常量，用于指定新类型内部表示的字节长度。默认假设是变长的。

alignment

数据类型的存储对齐要求。必须是 char，int2，int4， 或 double 之一。默认值是 int4。

storage

数据类型的存储策略，必须是 plain， external，extended，或 main 之一。 默认为 plain。

default

数据类型的默认值，如果省略，默认值为 null。

element

正在创建的类型是数组；这指定了数组元素的类型。

delimiter

此类型数组中值之间要使用的分隔符。

## 注意

用户定义的类型名称不能以下划线字符（\_）开头，并且必须是 62 个字符长（或者一般为 NAMEDATALEN - 2，而不是允许的其他名称的 NAMEDATALEN - 1 字符）。以下划线开头的类型名称为内部创建的数组类型名称保留。

因为一旦数据类型被闯创建，使用数据类型就没有任何限制，所以创建基础类型就等同于为类型定义中提到的函数授予公共执行权限。（因此，该类型的创建者需要拥有这些函数。）对于类型定义中有用的各种函数，这通常不是问题。但是，在设计一种类型之前，用户可能需要三思而后行，因为该设计思路上，在将其作为转化的源或者目标类型时，可能需要一些“秘密”信息。

创建新基础类型的方法就是先创建一个输入函数。在这种方法中， HashData 数据库会首先看到新数据类型的名称作为输入函数的返回类型。这种情况下，shell 类型是隐式创建的，然后可以在其余的 I/O 函数的定义中引用它。这种方法仍然有效，但是已经弃用了，可能会在将来的某个版本中禁用掉。另外，为了避免由于函数定义中简单拼写错误而导致 shell 类型目录的异常混乱，当输入函数是用 c 写的时候，shell 类型只能以这种方式创建。

## 示例

该示例创建了一个复合类型，并且在函数定义中使用了它：

```
CREATE TYPE compfoo AS (f1 int, f2 text);

CREATE FUNCTION getfoo() RETURNS SETOF compfoo AS $$
    SELECT fooid, fooname FROM foo
$$ LANGUAGE SQL;
```

该例子创建了枚举类型 mood 并且在表定义中使用了它。

```
CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');
CREATE TABLE person (
    name text,
    current_mood mood
);
INSERT INTO person VALUES ('Moe', 'happy');
SELECT * FROM person WHERE current_mood = 'happy';
 name | current_mood 
------+--------------
 Moe  | happy
(1 row)
```

该例子创建了一个基础数据类型 box 然后在表定义中使用了它：

```
CREATE TYPE box;

CREATE FUNCTION my_box_in_function(cstring) RETURNS box AS 
... ;

CREATE FUNCTION my_box_out_function(box) RETURNS cstring AS 
... ;

CREATE TYPE box (
    INTERNALLENGTH = 16,
    INPUT = my_box_in_function,
    OUTPUT = my_box_out_function
);

CREATE TABLE myboxes (
    id integer,
    description box
);
```

如果 box 的内部结构是 4 个 float4 元素的数组，我们可以替代使用：

```
CREATE TYPE box (
    INTERNALLENGTH = 16,
    INPUT = my_box_in_function,
    OUTPUT = my_box_out_function,
    ELEMENT = float4
);
```

这将允许通过下标访问一个 box 值的成员数字。否则类型的行为与以前相同。

该例子创建了一个大对象类型并在表的定义中使用了它

```
CREATE TYPE bigobj (
    INPUT = lo_filein, OUTPUT = lo_fileout,
    INTERNALLENGTH = VARIABLE
);

CREATE TABLE big_objs (
    id integer,
    obj bigobj
);
```

## 兼容性

该 CREATE TYPE 命令是 HashData 数据库扩展。 SQL 标准中有 CREATE TYPE 语句，但是细节上很是不同。

## 另见

[CREATE FUNCTION](./create-function.md), [ALTER TYPE](./alter-type.md), [DROP TYPE](./drop-type.md), [CREATE DOMAIN](./create-domain.md)

**上级话题：** [SQL命令参考](./README.md)

