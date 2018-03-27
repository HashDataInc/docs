# ABORT {#toc_1}

终止当前事务。[TEST](#toc_5)

## 概要 {#toc_2}

`ABORT [WORK | TRANSACTION]`

## 描述 {#toc_3}

ABORT 当前事务并导致事务所做的所有更新都被丢弃。出于历史原因，此命令与标准 SQL 命令的行为相同。

## 参数 {#toc_4}

WORK

TRANSACTION

可选关键字，它们没有效果。

## 注解 {#toc_5}

使用 COMMIT 成功终止一个事务。

在一个事务块之外发出 ABORT 会发出一个警告信息并且不会产生效果。

## 兼容性 {#toc_6}

由于历史原因，此命令是 HashData 数据库扩展名。 ROLLBACK 是等效的标准 SQL 命令。ROLLBACK 是等效的标准 SQL 命令。

## 另见 {#toc_7}

[BEGIN](./begin.md)，[COMMIT](./commit.md)，[ROLLBACK](./rollback.md)

**上级主题：**[SQL命令参考](./README.md)

