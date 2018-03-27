# SHOW

显示一个运行时参数的值。

## 概要

```
SHOW configuration_parameter

SHOW ALL
```

## 描述

SHOW 将显示当前  HashData  数据库系统配置参数的当前设置。 这些变量可以使用 SET 语句、编辑 HashData 数据库 Master 上的 postgresql.conf 配置参数。注意 ：一些能够使用 SHOW 查看的参数是只读的，它们的值只能被查看，不能被修改。见 HashData 数据库参考指南了解细节信息。

## 参数

configuration\_parameter

系统配置参数的名称。

ALL

所有配置参数的当前值。

## 示例

显示参数 search\_path 的当前设置：

```
SHOW search_path;
```

显示所有配置参数的当前的值：

```
SHOW ALL;
```

## 兼容性

SHOW 是 HashData 数据库的扩展。

## 另见

[SET](./set.md), [RESET](./reset.md)

**上级话题：** [SQL命令参考](./README.md)

