# pg\_partition

pg\_partition 系统目录表被用来跟踪分区表以及它们的继承层级关系。pg\_partition 中的每一行要么代表了一个分区表在分区层级关系中的等级，要么是一个子分区模板的描述。 paristemplate 的属性值决定了一个特定行代表的含义。

##### 表 1. pg\_catalog.pg\_partition

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| parrelid | oid | pg\_class.oid | 表的对象标识符。 |
| parkind | char |  | 分区类型 - R（范围）或者 L（列表）。 |
| parlevel | smallint |  | 该行的分区级别：0代表最顶层的父表，1代表父表下的第一个级别，2代表第二个级别，以此类推。 |
| paristemplate | boolean |  | 该行是否代表一个子分区模板定义（true）或者实际分区级别（false）。 |
| parnatts | smallint |  | 定义该级别的属性数目。 |
| paratts | smallint\(\) |  | 参与定义该级别的属性编号（正如在 pg\_attribute.attnum 中的）数组。 |
| parclass | oidvector | pg\_opclass.oid | 分区列上的操作符类的标识符。 |

**上级主题：** [系统目录定义](./README.md)
