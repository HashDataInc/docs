# DROP DOMAIN

# 删除域

删除一个域

## 概要

```
DROP DOMAIN  [IF EXISTS ] name  [, ... ]   [CASCADE | RESTRICT ]
```

## 描述

DROP DOMAIN 删除一个之前定义的域。用户必须是该域的所有者才能删除它。

## 参数

IF EXISTS

如果该域不存在不会抛出异常。这种情况下会发出通知。

name

存在的该域的名字（可选方案限定）。

CASCADE

自动删除依赖于域的对象（如表列）。

RESTRICT

如果有任何对象依赖于该域则拒绝删除该域，这是默认的。

## 示例

删除叫 zipcode 的域：

```
DROP DOMAIN zipcode;
```

## 兼容性

该命令是服从 SQL 标准的，除了 IF EXISTS 选项，该选项是 HashData 数据库扩展的。

## 另见

[ALTER DOMAIN](./alter-domain.md), [CREATE DOMAIN](./create-domain.md)

**上级话题：** [SQL命令参考](./README.md)

