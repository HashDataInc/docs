# ALTER CONVERSION

更改一个转换的定义。

## 概要

```
ALTER CONVERSION name RENAME TO newname
ALTER CONVERSION name OWNER TO newowner
```

## 描述

ALTER CONVERSION 更改一个转换的定义。

用户必须拥有使用 ALTER CONVERSION 的转换权限。 要更改所有者，用户还必须是新任命的直接或间接成员，并且该角色必须对转换的模式具有 CREATE 权限。 \(这些限制强制要求拥有者不能通过删除和重新创建转换来组做任何用户不能做的事情，但超级用户可以改变任何转换的所有权。\)

## 参数

name

现有转换的名称（可选方案限定）。

newname

新的转换名称。

newowner

转换的新所有者。

## 示例

要把转换 iso\_8859\_1\_to\_utf8 重命名为 latin1\_to\_unicode：

```
ALTER CONVERSION iso_8859_1_to_utf8 RENAME TO latin1_to_unicode;
```

更改转换iso\_8859\_1\_to\_utf8 的所有者为 joe:

```
ALTER CONVERSION iso_8859_1_to_utf8 OWNER TO joe;
```

## 兼容性

在 SQL 标准中没有 ALTER CONVERSION 语句。

## 另见

[CREATE CONVERSION](./create-conversion.md)，[DROP CONVERSION](./drop-conversion.md)

**上级主题：** [SQL命令参考](./README.md)

