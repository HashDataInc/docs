# DROP GROUP

删除一个数据库角色。

## 概要

```
DROP GROUP [IF EXISTS] name [, ...]
```
## 描述

DROP GROUP 是一个过时的命令，尽管为了向后兼容还被支持。组（和用户）已经被更一般的角色的概念所替代。 参阅 [DROP ROLE](./drop-role.md) 获取更多信息。

## 参数

IF EXISTS

如果角色不存在，也不会抛出错误。这种情况下会发出通知。

name

存在角色的名字。

## 兼容性

SQL标准中没有 DROP GROUP 语句。

## 另见

[DROP ROLE](./drop-role.md)

**上级话题：** [SQL命令参考](./README.md)
