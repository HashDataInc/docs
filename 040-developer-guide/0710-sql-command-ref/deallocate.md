# DEALLOCATE

# 释放

释放预预备语句

## 概要

```
DEALLOCATE [PREPARE] name
```

## 描述

DEALLOCATE 用来释放一个预先准备好对的 SQL 语句。如果用户不明确释放预备语句，它将会在会话结束时释放。

更多关于预备语句的信息，请参阅 [PREPARE](./prepare.md)。

## 参数

PREPARE

被忽略的可选关键字

name

要释放的预备语句的名字

## 示例

释放预先准备好的叫做 `insert_names` 的语句：

```
DEALLOCATE insert_names;
```

## 兼容性

该 SQL 标准包含了 DEALLOCATE 语句，但是它只在嵌入式 SQL 中使用。

## 另见

[EXECUTE](./execute.md), [PREPARE](./prepare.md)

**上级话题：** [SQL命令参考](./README.md)

