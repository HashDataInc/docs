# pg_roles

pg_roles 视图提供关提供了关于数据库角色的信息。这是 [pg_authid](./pgauthid.md) 的一个公共可读视图，它隐去了口令域。此视图显示了低层表的OID列，因为需要它来和其他目录做连接。

##### 表 1\. pg\_catalog.pg\_roles

|列|类型|参考|描述|
|:---|:---|:---|:---|
|rolname|name||角色名。
|rolsuper|bool||角色是否具有超级用户权限？
|rolinherit|bool||如果此角色是另一个角色的成员，角色是否能自动继承另一个角色的权限？
|rolcreaterole|bool||角色能否创建更多角色？
|rolcreatedb|bool||角色能否创建数据库？
|rolcatupdate|bool||角色能够更新直接更新系统目录（除非该列设置为真，否则超级用户也不能执行该操作）？
|rolcanlogin|bool||角色是否能登录？即此角色能否被作为初始会话授权标识符？
|rolconnlimit|int4||对于一个可登录的角色，这里设置角色可以发起的最大并发连接数。-1表示无限制。
|rolpassword|text||不是口令（看起来是********）。
|rolvaliduntil|timestamptz||口令失效时间（只用于口令认证），如果永不失效则为空。
|rolconfig|text\[\]||运行时配置变量的角色特定默认值。
|rolresqueue|oid|pg_resqueue.oid|该角色指定的资源队列的对象ID。
|oid|oid|pg_authid.oid|角色的ID。
|rolcreaterextgpfd|bool||角色能够创建使用gpfdist协议的可读的外部表？
|rolcreaterexthttp|bool||角色能够创建使用http协议的可读的外部表？
|rolcreatewextgpfd|bool||角色能否创建使用了gpfdist协议的可写外部表？

**上级主题：** [系统目录定义](./README.md)