# ALTER RESOURCE QUEUE

更改资源队列的限制。

## 概要

```
ALTER RESOURCE QUEUE name WITH ( queue_attribute=value [, ... ] )
```

其中 _queue\_attribute_ 是：

```
   ACTIVE_STATEMENTS=integer
   MEMORY_LIMIT='memory_units'
   MAX_COST=float
   COST_OVERCOMMIT={TRUE|FALSE}
   MIN_COST=float
   PRIORITY={MIN|LOW|MEDIUM|HIGH|MAX}
```

```
ALTER RESOURCE QUEUE name WITHOUT ( queue_attribute [, ... ] )
```

其中 _queue\_attribute_ 是：

```
   ACTIVE_STATEMENTS
   MEMORY_LIMIT
   MAX_COST
   COST_OVERCOMMIT
   MIN_COST
```

> 注意： 资源队列必须有一个 ACTIVE\_STATEMENTS 或一个 MAX\_COST 值。不要从资源队列中删除这两个 queue\_attributes 。

## 描述

ALTER RESOURCE QUEUE 更改资源队列的限制。只有超级用户可以更改资源队列。 资源队列必须有一个 ACTIVE\_STATEMENTS 或一个 MAX\_COST 值 \(或者可以同时使用\)。用户还可以设置或重置资源队列的优先级，以控制与队列相关联的查询使用的可用 CPU 资源的相对份额，或资源队列的内存限制，以控制通过队列提交的所有在段主机上查询消耗的内存量。

ALTER RESOURCE QUEUE WITHOUT 删除先前设置的资源的指定限制。资源队列必须有一个 ACTIVE\_STATEMENTS 或一个 MAX\_COST 值。 不要从资源队列中删除这两个 queue\_attributes。

## 参数

_name_

要更改其限制的资源队列的名称。

ACTIVE\_STATEMENTS _integer_

任何时刻系统中允许在该资源队列中的用户提交的活动语句的数量。 ACTIVE\_STATEMENTS 的值应该是一个大于 0 的整数。要把 ACTIVE\_STATEMENTS 重置为没有限制，输入一个 -1.0 值。

MEMORY\_LIMIT _'memory\_units'_

设置从此资源队列中的用户提交的所有语句的总内存配额。内存单位可以用 kB，MB 或 GB 指定。资源队列的最小内存配额为 10MB。没有最大值。然而，查询执行时间的上边界受到段主机的物理内存的限制。默认值为无限制 \(-1\)。

MAX\_COST _float_

任何时刻系统中允许在该资源队列中的用户提交的语句的查询优化器总代价。MAX\_COST 的值被指定为一个浮点数（例如 100.00）或者还可以被指定为一个指数（例如 1e+2）。要把 MAX\_COST 重置为没有限制，输入一个 -1.0 值。

COST\_OVERCOMMIT _boolean_

如果资源队列受到基于查询代价的限制，那么管理员可以允许代价过量使用（COST\_OVERCOMMIT=TRUE，默认）。这意味着一个超过允许的代价阈值的查询将被允许运行，但只能在系统空闲时运行。如果指定COST\_OVERCOMMIT=FALSE，超过代价限制的查询将总是被拒绝并且绝不会被允许运行。

MIN\_COST _float_

代价低于此限制的查询将不会排队而是立即运行。代价是以取得的磁盘页为单位来衡量的。1.0 等于一次顺序磁盘页面读取。MIN\_COST 的值被指定为浮点数（例如 100.00）或者还能被指定为一个指数（例如 1e+2）。要把 MIN\_COST 重置为没有限制，输入一个 -1.0 值。

PRIORITY = {MIN \| LOW \| MEDIUM \| HIGH \| MAX }

设置与资源队列关联的查询的优先级。具有较高优先级的队列中的查询或语句将在竞争中获得更多的可用 CPU 资源份额。低优先级队列中的查询可能会被延迟，同时执行更高优先级的查询。

## 注解

使用[CREATE ROLE](./create-role.md) 或[ALTER ROLE](./alter-role.md)  将角色（用户）添加到资源队列中。

## 示例

更改资源队列的活动查询限制：

```
ALTER RESOURCE QUEUE myqueue WITH (ACTIVE_STATEMENTS=20);
```

更改资源队列的内存限制：

```
ALTER RESOURCE QUEUE myqueue WITH (MEMORY_LIMIT='2GB');
```

将资源队列的最大和最小查询代价限制重置为无限制：

```
ALTER RESOURCE QUEUE myqueue WITH (MAX_COST=-1.0, MIN_COST= -1.0);
```

将资源队列的查询代价限制重置为 3e+10 \(or 30000000000.0\) 不允许过量使用：

```
ALTER RESOURCE QUEUE myqueue WITH (MAX_COST=3e+10, COST_OVERCOMMIT=FALSE);
```

将与资源队列关联的查询的优先级重置为最小级别：

```
ALTER RESOURCE QUEUE myqueue WITH (PRIORITY=MIN);
```

去除 MAX\_COST 和 MEMORY\_LIMIT 资源队列限制：

```
ALTER RESOURCE QUEUE myqueue WITHOUT (MAX_COST, MEMORY_LIMIT);
```

## 兼容性

ALTER RESOURCE QUEUE 语句是一个 HashData 数据库扩展。此命令在标准 PostgreSQL 中不存在。

## 另见

[CREATE RESOURCE QUEUE](./create-resource-queue.md) ，[DROP RESOURCE QUEUE](./drop-resource-queue.md)，[CREATE ROLE](./create-role.md) ，[ALTER ROLE](./alter-role.md)

**上级主题：**[ SQL命令参考](./README.md)

