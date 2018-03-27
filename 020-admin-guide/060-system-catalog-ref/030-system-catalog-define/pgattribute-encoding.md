# pg\_attribute\_encoding

该 pg\_attribute\_encoding 系统目录表包含列存储信息。

##### 表 1. pg\_catalog.pg\_attribute\_encoding

| 列 | 类型 | 修饰符 | 存储 | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| attrelid | oid | not null | plain | 外键于pg\_attribute.attrelid |
| attnum | smallint | not null | plain | 外键于pg\_attribute.attnum |
| attoptions | text \[ \] |  | extended | 选项（The options） |

**上级主题：** [系统目录定义](./README.md)
