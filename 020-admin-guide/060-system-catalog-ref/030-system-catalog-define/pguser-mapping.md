# pg\_user\_mapping

pg\_user\_mapping 存储从本地用户到远程用户的映射。 必须有管理员权限才能访问该目录。

##### 表 1. pg\_catalog.pg\_user\_mapping

| 名称 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| umuser | oid | pg\_authid.oid | 将要被映射的本地角色的OID，如果用户映射是公共的则为0。 |
| umserver | oid | pg\_foreign\_server.oid | 包含此映射的外部服务器的OID。 |
| umoptions | text \[ \] |  | 用户映射相关选项，以"keyword=value"字符串形式。 |

**上级主题：** [系统目录定义](./README.md)

