# pg\_available\_extensions

该 pg\_available\_extensions 视图列出了可用于安装的扩展。该 [pg\_extension](./pgextension.md) 系统目录表显示当前安装的扩展。

该视图只读。

##### 表 1. pg\_catalog.pg\_available\_extensions

| 列 | 类型 | 描述 |
| :--- | :--- | :--- |
| name | name | 扩展名 |
| default\_version | text | 默认版本名，如果没指定的话为NULL。 |
| installed\_version | text | 当前安装的扩展的版本，如果未安装则为 NULL。 |
| comment | text | 扩展控制文件的注释字符串。 |

**上级主题：** [系统目录定义](./README.md)
