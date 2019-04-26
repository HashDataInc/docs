# CREATE LANGUAGE

# 创建语言

定义一个新的程序化语言

## 概要

```
CREATE [PROCEDURAL] LANGUAGE name

CREATE [TRUSTED] [PROCEDURAL] LANGUAGE name
       HANDLER call_handler [ INLINE inline_handler ] [VALIDATOR valfunction]
```

## 描述

CREATE LANGUAGE 在 HashData 数据库中注册一个新的程序化语言。此后，可以使用这种新语言来定义函数和触发程序。

超级用户可以在 HashData 数据库中注册新的语言。数据库所有者也可以在该数据库中注册 pg\_pltemplate 目录中列出的任何语言，其中tmpldbacreate 字段为真。默认配置值允许数据库所有者注册仅受信任的语言。语言的创建者变成它的所有者，之后也可以删除它，重命名它，或将其所有权分配给其他用户。

CREATE LANGUAGE 有效地将语言名称与负责执行以该语言编写的函数的调用程序相关联。对于以程序语言（C 或 SQL 以外的语言）编写的函数，数据库服务器没有关于如何解释数据库源码的内置知识。该任务被传递到一个知道语言细节的特殊处理程序。处理程序可以执行解析，语法分析，执行等所有工作。也可以作为 HashData 数据库与编程语言现有实现之间的桥梁。处理程序本身就是编译成一个共享对象并按需加载，就像任何其他 C 函数一样。目前已经有四种程序语言包包含在标准的 HashData 数据库分布中：PL/pgSQL, PL/Perl, and PL/Python. 还为 PL/Java and PL/R 添加了语言处理程序，但是这些语言未预先安装在 HashData 中。

该 PL/Perl, PL/Java, and PL/R 库要求分别安装 Perl, Java, 和 R 的正确版本。

有两种形式的 CREATE LANGUAGE 命令。在第一种形式中，用户指定了所需语言的名称，并指定 HashData 数据库服务器使用 pg\_pltemplate 系统目录来确定正确的参数。在第二种形式中，用户指明了语言参数和语言名称，用户可以使用第二种形式创建一个未在 pg\_pltemplate 中定义的语言。

当服务器在 pg\_pltemplate 目录中找到给定语言名称的条目时，即使该命令包含语言参数，它也将使用目录数据。此行为简化了旧的储存文件的加载，那些文件可能包含有关语言支持功能的过时信息。

## 参数

TRUSTED

如果服务器在 pg\_pltemplate 中具有指定语言名称的条目，则将忽视该语句。该关键字指定该语言的调用处理程序是安全的，并且不会提供无权用户任何用以绕过访问限制的功能，如果注册时省略此关键字，只有超级权限的用户才能使用此语言创建函数。

PROCEDURAL

这是一个申明（noise）字。

name

新程序语言的名字。该语言名字大小写不敏感。该名字在数据库语言中必须唯一。 内置的语言支持有 plpgsql, plperl, plpython, plpythonu, 和 plr。 plpgsql \(PL/pgSQL\) 和 plpythonu \(PL/Python\) 默认在 HashData 数据库中安装。

HANDLER _call\_handler_

如果服务器在 pg\_pltemplate 中具有指定语言名称的条目，则该关键字将被忽略。是将被调用去执行程序语言函数的先前注册函数的名称。程序语言的调用处理程序必须以编译的语言来写，例如版本 1 的 C 的调用约定，并在 HashData 数据库中注册成函数，该函数不需要参数并返回 language\_handler 类型，language\_handler 是一个用来将函数标识成调用处理程序的占位符类型。

INLINE _inline\_handler_

先前注册函数的名称，该函数是使用 [DO](./do.md) 命令创建的以该语言执行的匿名代码块。如果未指定 inline\_handler 函数，则该函数不支持匿名代码块。处理程序函数必须使用一个 internal类型的参数，即 [DO](./do.md) 命令内部的表现形式。内部匿名函数通常返回 void。处理程序的返回值将被忽略。

VALIDATOR _valfunction_

如果服务器在 pg\_pltemplate 中具有指定语言名称的条目，则该字段将被忽略。该字段是之前注册函数的名称，该函数将被调用来执行程序语言函数。程序语言的调用处理程序必须以编译语言来写，例如版本 1 的 C 调用约定，并在 HashData 数据库中注册成函数，该函数不需要输入参数，并返回language\_handler 类型，该类型是用来标识函数成调用处理程序的占位符类型。

## 注意

PL/pgSQL 和 PL/Python 语言扩展已经默认安装在 HashData 数据库中。

该系统目录 pg\_language 记录了当前注册语言的信息。

在程序化语言中创建函数，一个用户必须要有关于该语言的 USAGE 权限。默认情况下，对信任的语言， USAGE 权限被授予给 PUBLIC（每个人）如果需要，该操作可以被撤销。

程序语言是个人数据库的本地语言。用户可以在个人数据库中创建和删除语言。

如果服务器没有 pg\_pltemplate 的语言条目，那么调用处理函数和验证函数（如果有的话）必须已经存在。但是当有条目时，这些函数不一定存在；如果数据库中不存在，他们将被自动定义。

实现语言的任何共享库必须位于 HashData 数据库数组中所有 segments 主机的同一个 LD\_LIBRARY\_PATH 位置。

## 例子

创建任何标准程序语言的首选方式：

```
CREATE LANGUAGE plpgsql;
CREATE LANGUAGE plr;
```

对于一个在 pg\_pltemplate 目录中不知名的语言:

```
CREATE FUNCTION plsample_call_handler() RETURNS 
language_handler
    AS '$libdir/plsample'
    LANGUAGE C;
CREATE LANGUAGE plsample
    HANDLER plsample_call_handler;
```

## 兼容性

CREATE LANGUAGE 是 HashData 数据库的扩展。

## 另见

[ALTER LANGUAGE](./alter-language.md), [CREATE FUNCTION](./create-function.md), [DROP LANGUAGE](./drop-language.md), [DO ](./do.md)

**上级话题：** [SQL命令参考](./README.md)

