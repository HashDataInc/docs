# DROP CAST

删除一个造型

## 概要

```
DROP CAST [IF EXISTS] (sourcetype AS targettype) [CASCADE | RESTRICT]
```
## 描述

DROP CAST 会删除一个之前定义的造型，为了能够删除造型，用户必须要拥有资源或目标数据类型。用户需要获得以下权限来创建一个造型。

## 参数

IF EXISTS

如果造型不存在不会抛出错误，这种情况会发出一个通知。

sourcetype

造型的源数据类型的名称。

targettype

造型的目标数据类型的名称。

CASCADE

RESTRICT

这些关键词没有效果，因为没有对造型的依赖。

## 示例

删除从 text 到 int 类型的造型：

```
DROP CAST (text AS int);
```
## 兼容性

该 DROP CAST 命令服从 SQL 标准。

## 另见

[CREATE CAST](./create-cast.md)

**上级话题：** [SQL命令参考](./README.md)
