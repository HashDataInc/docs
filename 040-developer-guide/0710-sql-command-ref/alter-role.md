# ALTER ROLE

更改一个数据库角色（用户或组）。

## 概要

```
ALTER ROLE name RENAME TO newname

ALTER ROLE name SET config_parameter {TO | =} {value | DEFAULT}

ALTER ROLE name RESET config_parameter

ALTER ROLE name RESOURCE QUEUE {queue_name | NONE}

ALTER ROLE name [ [WITH] option [ ... ] ]
```

其中 option 可以是：

```
      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | CREATEEXTTABLE | NOCREATEEXTTABLE 
      [ ( attribute='value'[, ...] ) ]
           where attributes and value are:
           type='readable'|'writable'
           protocol='gpfdist'|'http'
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | CONNECTION LIMIT connlimit
    | [ENCRYPTED | UNENCRYPTED] PASSWORD 'password'
    | VALID UNTIL 'timestamp'
    | [ DENY deny_point ]
    | [ DENY BETWEEN deny_point AND deny_point]
    | [ DROP DENY FOR deny_point ]
```

## 描述

ALTER ROLE 更改 HashData 数据库角色的属性。此命令有几种变体：

* **RENAME** — 更改角色的名称。数据库超级用户可以重命名任何角色。角色有 CREATE ROLE 特权 可以重命名非超级用户角色。无法重命名当前会话用户（以其他用户身份连接重命名角色）。因为 MD5 加密的密码使用角色名称作为密钥，如果密码为 MD5 加密，则重命名角色将清除其密码。
* **SET \| RESET** — 更改指定配置参数的角色的会话默认值。每当角色随后启动新会话时，指定的值将成为会话默认值，覆盖服务器配置文件中存在的任何设置\(postgresql.conf\). 对于没有 LOGIN 权限的角色, 会话默认值没有任何效果。普通角色可以更改自己的会话默认值。超级用户可以更改任何人的会话默认值。 有 CREATE ROLE 特权的角色可以更改非超级用户角色的默认值。
* **RESOURCE QUEUE** — 将角色分配给工作负载管理资源队列。 在发出查询时，角色将受到分配资源队列的限制。指定 NONE 将角色分配给默认资源队列。一个角色只能属于一个资源队列。对于没有 LOGIN  特权的角色，会话默认值没有任何作用。 参考 [CREATE RESOURCE QUEUE](./create-resource-queue.md) 获取更多信息。
* **WITH 选项** — 更改在 [CREATE ROLE](./create-role.md) 中指定的角色的许多属性。命令中未提及的属性保留其以前的设置。 数据库超级用户可以更改任何角色的任何这些设置。角色有 CREATE ROLE 权限可以更改任何这些设置，但只能用于非超级用户角色。普通角色只能改变自己的密码。

## 参数

_name_

角色的名称，其属性将被更改。

_newname_

角色的新名称。

_config\_parameter=value_

将指定配置参数的此角色的会话默认值设置为给定值。如果值为 DEFAULT 或者如果 RESET 被使用时，角色特定的变量设置被删除，因此该角色将在新会话中继承系统范围的默认设置。使用RESET ALL 清除所有特定于角色的设置。 参考 [SET](./set.md) 以获取有关用户可设置的配置参数的信息。

_queue\_name_

要分配用户级角色的资源队列的名称。 只有有 LOGIN 特权的角色 可以分配给资源队列。要从资源队列中取消分配角色并将其置于默认资源队列中，请指定 NONE。 角色只能属于一个资源队列。

SUPERUSER \| NOSUPERUSER

CREATEDB \| NOCREATEDB

CREATEROLE \| NOCREATEROLE

CREATEEXTTABLE \| NOCREATEEXTTABLE \[\(attribute='value'\)\]

如果 CREATEEXTTABLE 被指定， 允许定义的角色创建外部表。默认类型是可读并且默认协议是 gpfdist 。 NOCREATEEXTTABLE （默认）拒绝角色有创建外部表的能力。 注意使用 file 或 execute 协议的外部表只能由超级用户创建。

INHERIT \| NOINHERIT

LOGIN \| NOLOGIN

CONNECTION LIMIT connlimit

PASSWORD password

ENCRYPTED \| UNENCRYPTED

VALID UNTIL 'timestamp'

这些子句通过 [CREATE ROLE](./create-role.md) 改变了原来设置的角色属性。

DENY deny\_point

DENY BETWEEN deny\_point AND deny\_point

DENY 和 DENY BETWEEN 关键字设置了在登录时强制执行的基于时间的约束。DENY 设置一天或一天​​的时间来拒绝访问。DENY BETWEEN 设置访问被拒绝的间隔。 两者都使用以下格式的参数 deny\_point ：

```
DAY day [ TIME 'time' ]
```

deny\_point两部分参数使用以下格式：

对于 day:

```
{'Sunday' | 'Monday' | 'Tuesday' |'Wednesday' | 'Thursday' | 'Friday' | 
'Saturday' | 0-6 }
```

对于 time:

```
{ 00-23 : 00-59 | 01-12 : 00-59 { AM | PM }}
```

DENY BETWEEN 子句使用两个 deny\_point 参数。

```
DENY BETWEEN deny_point AND deny_point
```

DROP DENY FOR deny\_point

该 DROP DENY FOR 子句从角色中删除基于时间的约束。它使用上述的 deny\_point 参数。

## 注解

使用 [GRANT](./grant.md) 和 [REVOKE](./revoke.md) 用于添加和删除角色成员资格。

使用此命令指定未加密的密码时，必须小心。密码将以明文形式发送到服务器，也可能会记录在客户端的命令历史记录或服务器日志中。 该 psql 命令行客户端包含一个元命令 password 可用于安全地更改角色的密码。

还可以将会话默认值与特定数据库绑定而不是角色。如果存在冲突，则特定于角色的设置将覆盖数据库特定的设置。参阅 [ALTER DATABASE](./alter-database.md)。

## 示例

更改角色的密码：

```
ALTER ROLE daria WITH PASSWORD 'passwd123';
```

更改密码失效日期：

```
ALTER ROLE scott VALID UNTIL 'May 4 12:00:00 2015 +1';
```

使密码永久有效：

```
ALTER ROLE luke VALID UNTIL 'infinity';
```

赋予角色创建其他角色和新数据库的能力：

```
ALTER ROLE joelle CREATEROLE CREATEDB;
```

给角色一个非默认设置 maintenance\_work\_mem 参数：

```
ALTER ROLE admin SET maintenance_work_mem = 100000;
```

将角色分配给资源队列：

```
ALTER ROLE sammy RESOURCE QUEUE poweruser;
```

授予创建可写外部表的角色权限：

```
ALTER ROLE load CREATEEXTTABLE (type='writable');
```

更改角色在星期日不允许登录访问：

```
ALTER ROLE user3 DENY DAY 'Sunday';
```

改变角色以消除星期日不允许登录访问的约束：

```
ALTER ROLE user3 DROP DENY FOR DAY 'Sunday';
```

## 兼容性

ALTER ROLE 语句是一个 HashData 数据库扩展。

## 另见

[CREATE ROLE](./create-role.md)，[DROP ROLE](./drop-role.md)，[SET](./set.md)，[CREATE RESOURCE QUEUE](./create-resource-queue.md)，[GRANT](./grant.md)，[REVOKE](./revoke.md)

**上级主题：** [SQL命令参考](./README.md)

