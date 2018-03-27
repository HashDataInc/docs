# pg\_available\_extension\_versions

该 pg\_available\_extension\_versions 视图列出了可用于安装的特定扩展版本。该  [pg\_extension](./pgextension.md) 系统目录表 当前已经安装的扩展。

该视图只读。

##### 表 1. pg\_catalog.pg\_available\_extension\_versions

| 列 | 类型 | 描述 |
| :--- | :--- | :--- |
| name | name | 扩展名字。 |
| version | text | 版本名字。 |
| installed | boolean | 如果此扩展程序的此版本已安装，则为 True ，否则为 False。 |
| superuser | boolean | 如果只允许超级用户安装此扩展，则为 True，否则为False。 |
| relocatable | boolean | 如果扩展可以重新定位到另一个模式，则为 True，否则为False。 |
| schema | name | 扩展必须装入的模式的名称，如果部分或完全可重定位，则为 NULL。 |
| requires | name\[\] | 必备扩展的名称，如果没有则为 NULL。 |
| comment | text | 扩展控制文件的注释字符串。 |

**上级主题：** [系统目录定义](./README.md)
