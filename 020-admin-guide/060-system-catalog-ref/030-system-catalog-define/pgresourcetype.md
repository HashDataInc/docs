# pg\_resourcetype

pg\_resourcetype系统目录表包含那些被指派给 HashData 资源队列的扩展属性的信息。每行详细描述了一个属性及其固有特性，例如它的默认设置、是否必须以及禁用它的值（如果允许）。

该表只在Master上被填充。该表定义在pg\_global表空间中，意味着它会在系统中所有的数据库间共享。

##### 表 1. pg\_catalog.pg\_resourcetype

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| restypid | smallint |  | 资源类型ID。 |
| resname | name |  | 资源类型名。 |
| resrequired | boolean |  | 该资源类型对于一个有效的资源队列是否必需。 |
| reshasdefault | boolean |  | 资源类型是否有默认值。如果为真，默认值在reshasdefaultsetting中指定。 |
| rescandisable | boolean |  | 类型是否能够被移除或者禁用。如果为真，默认值在resdisabledsetting中指定。 |
| resdefaultsetting | text |  | 可用时，资源类型的默认设置。 |
| resdisabledsetting | text |  | 禁用资源类型的值（当允许时）。 |

**上级主题：** [系统目录定义](./README.md)
