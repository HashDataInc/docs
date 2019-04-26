# REASSIGN OWNED

更改一个数据库角色拥有的数据库对象的拥有关系。

## 概要

```
REASSIGN OWNED BY old_role [, ...] TO new_role
```

## 描述

REASSIGN OWNED 指示系统把 old\_role 们拥有的任何数据库对象的拥有关系更改为 new\_role。注意它并不改变数据库本身的拥有关系。

## 参数

old\_role

一个角色的名称。这个角色在当前数据库中所拥有的所有对象以及所有共享对象（数据库、表空间）的所有权都将被重新赋予给 new\_role。

new\_role

将作为受影响对象的新拥有者的角色名称。

## 注解

REASSIGN OWNED 经常被用来为移除一个或者多个角色做准备。因为 REASSIGN OWNED 只影响当前数据库中的对象，通常需要在包含有被删除的角色所拥有的对象的每一个数据库中都执行这个命令。

DROP OWNED 命令可以简单地删掉一个或者多个角色所拥有的所有数据库对象。

REASSIGN OWNED 命令不会影响授予给 old\_role 们的在它们不拥有的对象上的任何特权。DROP OWNED 可以回收那些特权。

## 示例

重新将 sally 和 bob 拥有的对象改为 admin 拥有的：

```
REASSIGN OWNED BY sally, bob TO admin;
```

## 兼容性

REASSIGN OWNED 语句是 HashData 数据库的扩展。

## 另见

[DROP OWNED](./drop-owned.md), [DROP ROLE](./drop-role.md)

**上级主题：** [SQL命令参考](./README.md)

