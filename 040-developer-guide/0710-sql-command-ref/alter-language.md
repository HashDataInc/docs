# ALTER LANGUAGE

更改一种过程语言的定义。

## 概要

```
ALTER LANGUAGE name RENAME TO newname
```

## 描述

ALTER LANGUAGE 更改特定数据库的过程语言的定义。 用户必须是超级用户或语言的所有者才能使用 ALTER LANGUAGE。

## 参数

_name_

一种语言的名称。

_newname_

该语言的新名称。

## 兼容性

在 SQL 标准中没有 ALTER LANGUAGE 语句。

## 另见

[CREATE LANGUAGE](./create-language.md) ，[DROP LANGUAGE](./drop-language.md)

**上级主题：** [SQL命令参考](./README.md)

