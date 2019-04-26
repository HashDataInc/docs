# DROP OWNED

删除一个数据库角色拥有的数据库对象。

## 概要

```
DROP OWNED BY name [, ...] [CASCADE | RESTRICT]
```

## 描述

DROP OWNED 删除当前数据库中指定角色之一所拥有的所有对象。授予当前数据库中对象的给定角色的任何权限也将被撤销。

## 参数

name

要删除对象的拥有者的名字和要撤销权限的拥有者的名字。

CASCADE

自动删除依赖所影响对象的的对象。

RESTRICT

如果有任何其他数据库对象依赖所影响的对象之一，则拒绝删除该角色所拥有的对象。这是默认的。

## 注意

DROP OWNED 经常被使用来准备移除一个或多个角色。因为 DROP OWNED 仅影响当前数据的对象，通常需要在每个数据库中执行此命令，该数据库要包含要删除对象所拥有的对象。

使用 CASCADE 选项可能使命令递归到其他用户所拥有的对象。

该 REASSIGN OWNED 命令是重新分配由一个或多个角色所拥有的数据库对象所有权的替代方法。

## 示例

删除由 sally 角色所拥有的任何数据库对象：

```
DROP OWNED BY sally;
```

## 兼容性

该 DROP OWNED 语句是 HashData 数据库扩展。

## 另见

[REASSIGN OWNED](./reassign-owned.md), [DROP ROLE](./drop-role.md)

**上级话题：** [SQL命令参考](./README.md)

