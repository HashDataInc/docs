# pg\_auth\_members

pg\_auth\_members 系统目录表显示角色之间的成员关系。允许任何非循环关系。因为角色是系统范围的，所以pg\_auth\_members表在Greenplum数据库系统的所有数据库之间共享。

表 1. pg\_catalog.pg\_auth\_members

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| roleid | oid | pg\_authid.oid | 父级（组）角色的ID |
| member | oid | pg\_authid.oid | 成员角色的ID |
| grantor | oid | pg\_authid.oid | 授予此成员关系的角色的ID |
| admin\_option | boolean |  | 如果角色成员可以向其他人授予成员关系，则为true |

**上级主题：** [系统目录定义](./README.md)
