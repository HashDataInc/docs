# gp\_id

gp\_id 系统目录表标识了 HashData 数据库系统名称和系统的 Segment 数量。它还具有表所在的特定数据库实例（Segment 或 Master）的本地值。 该表在pg\_global表空间中定义，这意味着它在系统中的所有数据库之间全局共享。

##### 表 1. pg\_catalog.gp\_id

| 列 | 类型 | 引用 | 描述 |
| :--- | :--- | :--- | :--- |
| gpname | name |  | 这个 HashData 数据库系统的名称。 |
| numsegments | integer |  | HashData 数据库系统中的Segment数量。 |
| dbid | integer |  | 此Segment（或Master）实例的唯一标识符。 |
| content | integer |  | 该Segment实例上的这部份数据的ID。主Segment及其镜像Segment将具有相同的内容ID。对于Segment，值为0-_N_， 其中_N_ 是 HashData 数据库中的Segment数量。对于Master,其值为-1。 |

**上级主题：** [系统目录定义](./README.md)
