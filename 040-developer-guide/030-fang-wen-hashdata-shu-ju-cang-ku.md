# 访问 HashData 数据仓库

本小节向您介绍使用不同工具连接 HashData 数据仓库建立会话的方法。

## 3.1 建立会话

用户可以通过兼容 postgres 的客户端程序来连接 HashData 数据仓库的 master 节点。你可能需要了解以下连接信息来帮助您配置客户端程序。

| 链接参数 | 参数描述 | 环境变量 |
| :--- | :--- | :--- |
| 应用名称 | 连接到数据库的应用程序名称。 | `$PGAPPNAME` |
| 数据库名称 | 你想要连接到的数据库的名称。 | `$PGDATABASE` |
| 主机名称 | HashData 数据仓库主机的主机名称。 | `$PGHOST` |
| 端口号 | HashData 数据仓库主机的端口号。默认值为 5432。 | `$PGPORT` |
| 用户名 | 要连接的数据库用户 \(角色\) 名称。 | `$PGUSER` |

## 3.2 支持客户端列表

用户可以使用不同的客户端应用程序连接到 HashData 数据仓库:

* 兼容标准 postgres 客户端程序 psql。通过 psql 程序，用户可以使用交互式命令行来访问 HashData 数据仓库。
* pgAdmin III 是一个非常流行的、支持 postgres 和 HashData 数据仓库扩展特性的图形化管理工具。
* 通过使用标准的数据库应用接口（例如：JDBC 和 ODBC），用户可以创建独立的客户端应用程序来访问 HashData 数据仓库。由于 HashData 数据仓库是基于 postgres 实现，因此可以直接使用 postgres 的数据库驱动程序。
* 大部分使用标准数据库访问接口（例如：JDBC 和 ODBC）的第三方客户端程序，通过适当配置就可以连接 HashData 数据仓库。

## 3.3 使用 psql

---

根据您配置的环境变量值，下面的例子展示了如何使用 psql 连接数据库：

```
$ psql -d gpdatabase -h master_host -p 5432 -U gpadmin

$ psql gpdatabase

$ psql
```

当您连接到数据库后，psql  
将会提示您正在使用的数据库名称，每个数据库名称后面跟随着输入提示字符串 =&gt; （如果您使用了超级用户登录，那么提示字符串是 =\#）。如下所示：

```
gpdatabase=>
```

在提示字符串后，你可以输入 SQL 命令。每条 SQL 命令必须以分号（ ; ）结束，这样服务器才能接收并执行该命令。如下所示：

```
=> SELECT * FROM mytable;
```

## 3.4 pgAdmin III

---

如果您喜欢使用图形化接口，可以使用 pgAdmin III 工具。该图形工具能够支持 postgres 数据库所有标准特性，也添加了对 HashData 数据仓库特性的支持。pgAdmin III 支持 HashData 数据仓库的特性包括:

* 外部表支持
* Append 表（包括使用压缩特性的 Append 表）
* 分区表信息
* 资源队列
* 图形化 EXPLAIN ANALYZE

## 3.5 数据库应用接口

---

您也许需要开发专有的客户端程序来连接 HashData 数据仓库系统。 postgres  
为常用的数据库应用接口提供了驱动程序，这些驱动程序可以直接操作  
HashData 数据仓库。具体驱动程序及下载链接如下：

| API | PostgreSQL驱动程序名称 | 下载链接 |
| :--- | :--- | :--- |
| ODBC | pgodbc | [源代码](https://pek3a.qingstor.com/hashdata-public/tools/clients/odbc/psqlodbc-09.05.0210.tar.gz)、[Win64](https://pek3a.qingstor.com/hashdata-public/tools/clients/odbc/psqlodbc_09_05_0210-x64.zip)、[Win32](https://pek3a.qingstor.com/hashdata-public/tools/clients/odbc/psqlodbc_09_05_0210-x86.zip) |
| JDBC | pgjdbc | [JRE6](https://pek3a.qingstor.com/hashdata-public/tools/clients/jdbc/postgresql-9.4-1208.jdbc4.jar)、[JRE7](https://pek3a.qingstor.com/hashdata-public/tools/clients/jdbc/postgresql-9.4-1208.jdbc41.jar)、[JRE8](https://pek3a.qingstor.com/hashdata-public/tools/clients/jdbc/postgresql-9.4-1208.jdbc42.jar) |
| Perl DBI | pgperl | [http://search.cpan.org/dist/DBD-Pg/](http://search.cpan.org/dist/DBD-Pg/) |
| Python DBI | pygresql | [http://www.pygresql.org/](http://www.pygresql.org/) |

使用 HashData 数据仓库应用接口的配置步骤：

1. 根据使用语言和接口，下载相关程序。例如：从 Oracle 官方下载。
2. 根据接口说明，编写您的客户端程序。在编写程序时，请注意 HashData 数据仓库的相关语法，这样可以避免您使用不支持的特性。
3. 下载对应的 postgres 驱动程序，并配置连接 HashData 数据仓库
   主节点的信息。

## 3.6 第三方客户工具

---

大部分第三方 ETL 和商业智能（BI）工具使用标准数据库接口连接  
HashData 数据仓库，例如：ODBC 和 JDBC。目前经过测试支持的应用包括

* Apache Zeppelin
* Tableau Desktop



