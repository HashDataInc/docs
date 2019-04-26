# ALTER FILESPACE

更改文件空间的定义。

## 概要

```
ALTER FILESPACE name RENAME TO newname

ALTER FILESPACE name OWNER TO newowner
```

## 描述

ALTER FILESPACE 更改一个文件空间的定义。

用户必须拥有文件空间才能使用 ALTER FILESPACE 命令。修改文件空间的所有者，用户还必须是新的角色的直接或间接成员\(请注意，超级用户自动拥有这些权限）。

## 参数

_name_

现有文件空间的名称。

_newname_

文件空间的新名称。新名称不能以 pg\_ 和 gp\_ 开头。\(为系统文件空间保留）。

_newowner_

文件空间的新所有者。

## 示例

重命名文件空间 myfs 为 fast\_ssd:

```
ALTER FILESPACE myfs RENAME TO fast_ssd;
```

更改表空间 myfs 的拥有者：

```
ALTER FILESPACE myfs OWNER TO dba;
```

## 兼容性

在标准 SQL 或 PostgreSQL 中没有 ALTER FILESPACE 语句

## 另见

[DROP FILESPACE](./drop-filespace.md)、gpfilespace

**上级主题：** [SQL命令参考](./README.md)

