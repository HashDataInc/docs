# pg\_authid

pg\_authid 表包含了有关数据库认证标识符（角色）的信息。角色包含用户和组的概念。用户是设置了rolcanlogin标志的角色。任何角色（有或者没有 rolcanlogin）可能有其他角色作为其成员。请参阅 [pg\_auth\_members](./pgauth-members.md)。

由于此目录包含密码，因此不是公众可读的。[pg\_roles](./pgroles.md)是pg\_authid 上的一个公开可读的视图，其中模糊化了密码字段。

由于用户身份是全系统范围的，因此pg\_authid在 HashData 数据库系统中的所有数据库之间共享：每个系统只有一个pg\_authid副本，而不是每个数据库一个。

##### 表 1. pg\_catalog.pg\_authid

| 列 | 类型 | 参考 | 描述 |
| :--- | :--- | :--- | :--- |
| rolname | name |  | 角色名称 |
| rolsuper | boolean |  | 角色具有超级用户特权 |
| rolinherit | boolean |  | 角色自动继承其所属角色的权限 |
| rolcreaterole | boolean |  | 角色可以创建其他更多角色 |
| rolcreatedb | boolean |  | 角色可以创建数据库 |
| rolcatupdate | boolean |  | 角色可以直接更新系统目录（即使超级用户也不能这样做，除非此列为真） |
| rolcanlogin | boolean |  | 角色可以登录。也就是说，该角色可以作为初始会话授权标识符。 |
| rolconnlimit | int4 |  | 对于那些可以登录的角色，这一列设置此角色可以创建的最大并发连接数。-1表示没有限制。 |
| rolpassword | text |  | 密码（可能加密）；如果没有则为NULL |
| rolvaliduntil | timestamptz |  | 密码到期时间（仅用于密码验证）；不过期则为NULL |
| rolconfig | text\[\] |  | 服务器配置参数的会话默认值 |
| relresqueue | oid |  | _pg\_resqueue_ 中相关的资源队列ID的对象ID。 |
| rolcreaterextgpfd | boolean |  | 使用gpfdist或gpfdists协议创建可读外部表的特权。 |
| rolcreaterexhttp | boolean |  | 使用http协议创建可读外部表的特权。 |
| rolcreatewextgpfd | boolean |  | 使用gpfdist或gpfdists协议创建可写外部表的特权。 |
| rolcreaterexthdfs | boolean |  | 使用gphdfs协议协议创建可读外部表的特权。 |
| rolcreatewexthdfs | boolean |  | 使用gphdfs协议创建可写外部表的特权。 |

**上级主题：** [系统目录定义](./README.md)
