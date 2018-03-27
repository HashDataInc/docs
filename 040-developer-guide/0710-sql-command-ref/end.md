# END

提交当前事务。

## 概要

```
END [WORK | TRANSACTION]
```

## 描述

END 提交当前事务。所有该事务做的更改变得对他人可见并且被保证发生崩溃时仍然是持久的。这个命令是一种 HashData 数据库的扩展，它等效于 [COMMIT](./commit.md)。

## 参数

WORK

TRANSACTION

可选关键词，它们没有效果。

## 示例

提交当前事务：

```
END;
```

## 兼容性

END 是一种 HashData 数据库的扩展，它提供和 [COMMIT](./commit.md) 等效的功能，后者是 SQL 标准中指定的。

## 另见

[BEGIN](./begin.md)、[ROLLBACK](./rollback.md)、[COMMIT](./commit.md)

**上级主题：** [SQL命令参考](./README.md)

