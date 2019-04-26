# pg\_partition\_encoding

pg\_partition\_encoding 系统目录表描述一个分区模板的可用的列压缩选项。

##### 表 1. pg\_catalog.pg\_attribute\_encoding

| 名称 | 类型 | 修改 | 存储 | 描述 |
| :--- | :--- | :--- | :--- | :--- |
| parencoid | oid | not null | plain |  |
| parencattnum | snallint | not null | plain |  |
| parencattoptions | text \[ \] |  | extended |  |

**上级主题：** [系统目录定义](./README.md)
