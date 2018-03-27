# pg\_pltemplate

pg\_pltemplate 系统目录表存储了过程语言的“模板”信息。一种语言的模板允许我们在一个特定数据库中以简单的 CREATE LANGUAGE 命令创建该语言，而不需要指定实现细节。和大部分系统目录不同，pg\_pltemplate 在 HashData 系统的所有数据库之间共享：在一个系统中只有一份 pg\_pltemplate 拷贝，而不是每个数据库一份。这使得在每个需要的数据库中都可以访问该信息。

目前任何命令都不能操纵过程语言模板。要改变内建信息，超级用户必须使用普通的 INSERT、DELETE或UPDATE 命令修改该表。

##### 表 1. pg\_catalog.pg\_pltemplate

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| tmplname | name |  | 该模板适用的语言名称 |
| tmpltrusted | boolean |  | 如果该语言被认为是可信的则为真 |
| tmplhandler | text |  | 调用处理器函数的名字 |
| tmplvalidator | text |  | 验证器函数的名字，如果没有则为空 |
| tmpllibrary | text |  | 实现语言的共享库的路径 |
| tmplacl | aclitem\[\] |  | 模板的访问特权（并未实现）。 |

**上级主题：** [系统目录定义](./README.md)
