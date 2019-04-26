# CLOSE

关闭一个游标。

## 概要

```
CLOSE cursor_name
```

## 描述

CLOSE 释放与一个已打开游标相关的资源。在游标被关闭后，不允许在其上做后续的操作。当不再需要使用一个游标时应该关闭它。

当一个事务被 COMMIT 或 ROLLBACK 终止时，每一个非可保持的已打开游标会被隐式地关闭。 当创建一个可保持游标的事务通过 ROLLBACK 中止时，该可保持游标会被隐式地关闭。如果该创建事务成功地提交，可保持游标会保持打开，直至执行一个显式的 CLOSE 或者客户端连接断开。

## 参数

_cursor\_name_

要关闭的已打开游标的名称。

## 注解

HashData 没有一个显式的 OPEN 游标语句，一个游标在被声明时就被认为是打开的。使用 DECLARE 语句可以声明游标。

通过查询 pg\_cursors 系统视图可以看到所有可用的游标。

## 示例

关闭游标 portala:

```
CLOSE portala;
```

## 兼容性

CLOSE 完全服从 SQL 标准。

## 另见

[DECLARE](./declare.md)， [FETCH](./fetch.md)，[ MOVE](./move.md)

**上级主题：** [SQL命令参考](./README.md)

