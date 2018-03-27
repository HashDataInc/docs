# ALTER GROUP

更改角色名称或成员关系。

## 概要

```
ALTER GROUP groupname ADD USER username [, ... ]

ALTER GROUP groupname DROP USER username [, ... ]

ALTER GROUP groupname RENAME TO newname
```

## 描述

ALTER GROUP 该表用户组的属性。这是一个被废弃的命令，不过为了向后兼容还是被接受。 用户组（和用户）已被角色的更一般概念所取代。 参阅 [ALTER ROLE](./alter-role.md) 获取更多信息

## 参数

_groupname_

要修改的组（角色）的名称

_username_

要添加到组或从组中删除的用户（角色）。用户（角色）必须已经存在。

_newname_

组（角色）的新名称。

## 示例

要将用户添加到组中：

```
ALTER GROUP staff ADD USER karl, john;
```

从组中删除用户:

```
ALTER GROUP workers DROP USER beth;
```

## 兼容性

在 SQL 标准中没有 ALTER GROUP 语句。

## 另见

[ALTER ROLE](./alter-role.md) ，[GRANT](./grant.md)，[REVOKE](./revoke.md)

**上级主题：** [SQL命令参考](./README.md)

