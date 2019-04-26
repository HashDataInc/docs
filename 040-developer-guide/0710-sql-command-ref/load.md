# LOAD

载入一个共享库文件。

## 概要

```
LOAD 'filename'
```

## 描述

该命令载入一个共享库文件到 HashData 数据库服务器的地址空间。如果文件之前已经被载入，它首先会被卸载。该命令主要用于卸载并重装载一个在服务器第一次装载它之后发生变化的共享库文件。要使用共享库文件，其中的函数需要由 CREATE FUNCTION 命令声明。

文件名采用和 CREATE FUNCTION 中的共享库名称相同的方式指定；特别地，文件名可能依赖于搜索路径以及对系统标准共享库文件名扩展的自动增加。

注意在 HashData 数据库中，共享库文件（.so文件）在 HashData 数据库阵列（Master、Segment 以及镜像）中的每一台主机上都必须位于相同的路径位置。

## 参数

filename

共享库文件的路径以及文件名。该文件在 HashData 阵列中所有的主机上都必须位于相同的位置。

## 示例

载入一个共享库文件：

```
LOAD '/usr/local/ HashData -db/lib/myfuncs.so';
```

## 兼容性

LOAD 是 HashData 扩展。

## 另见

[CREATE FUNCTION](./create-function.md)

**上级主题：** [SQL命令参考](./README.md)

