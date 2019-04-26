# pg\_type\_encoding

pg\_type\_encoding 系统目录表包含了列存储类型信息。

##### 表 1. pg\_catalog.pg\_type\_encoding

| 名称 | 类型 | 修改 | 存储 | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| typeid | oid | not null | plain | [pg\_attribute](./pgattribute.md) 的外键。 |
| typoptions | text \[ \] |  | extended | 实际的选项。 |

**上级主题：** [系统目录定义](./README.md)

