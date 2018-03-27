# CREATE GROUP

# 创建组

定义一个新的数据库角色。

## 概要

```
CREATE GROUP name [ [WITH] option [ ... ] ]
```

该 _option_ 可以是：

```
  SUPERUSER | NOSUPERUSER
| CREATEDB | NOCREATEDB
| CREATEROLE | NOCREATEROLE
| CREATEUSER | NOCREATEUSER
| INHERIT | NOINHERIT
| LOGIN | NOLOGIN
| [ ENCRYPTED | UNENCRYPTED ] PASSWORD 'password'
| VALID UNTIL 'timestamp' 
| IN ROLE rolename [, ...]
| IN GROUP rolename [, ...]
| ROLE rolename [, ...]
| ADMIN rolename [, ...]
| USER rolename [, ...]
| SYSID uid
```

## 描述

从 HashData 数据库 2.2 版开始，CREATE GROUP 已经被 [CREATE ROLE](./create-role.md) 所取代，不过为了向后兼容，它仍然被接受。

## 兼容性

在 SQL 标准中没有 CREATE GROUP 语句。

## 另见

[CREATE ROLE](./create-role.md)

**上级话题：** [SQL命令参考](./README.md)

