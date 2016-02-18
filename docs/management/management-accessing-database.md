## 访问<&product-name> ##
本小结向您介绍使用不同工具连接 <&product-name> 系统会话的方法。

### 建立会话 ###
用户可以通过兼容 PostgreSQL 的客户端程序来连接 <&product-name>。用户只能连接 Master 节点，其他的计算节点不允许用户直接访问。

为了建立到 <&product-name> Master 节点的连接，你需要了解以下连接信息并配置您使用的客户端程序。

| 链接参数 | 参数描述 | 环境变量 |
| --- | --- | --- |
| 应用名称 | 连接到数据库的应用程序名称。| $PGAPPNAME |
| 数据库名称 | 你想要连接到的数据库的名称。| $PGDATABASE |
| 主机名称 | <&product-name> 主机的主机名称。 | $PGHOST |
| 端口号 | <&product-name> 主机的端口号。默认值为 5432。 | $PGPORT |
| 用户名 | 要连接的数据库用户 (角色) 名称。 | $PGUSER |

### 支持客户端列表 ###
用户可以使用不同的客户端应用程序连接到 <&product-name>:

* 兼容标准 PostgreSQL 客户端程序 psql。通过 psql 程序，允许用户使用交互式命令行来访问 <&product-name>。
* pgAdmin III 是一个非常流行的图形化管理工具，能够支持 PostgreSQL 和 <&product-name> 的扩展特性。
* 通过使用标准的数据库应用接口（例如：JDBC 和 ODBC），用户可以创建独立的客户端应用程序来访问 <&product-name>。由于 <&product-name> 是基于 PostgreSQL 实现，因此可以直接使用 PostgreSQL 的数据库驱动程序。
* 大部分使用标准数据库访问接口（例如：JDBC 和 ODBC）的第三方客户端程序，通过适当配置就可以连接 <&product-name>。

### 使用 psql
根据您配置的环境变量值，下面的例子展示了如何使用 psql 连接数据库：

	$ psql -d gpdatabase -h master_host -p 5432 -U gpadmin

	$ psql gpdatabase

	$ psql

当您连接到数据库后，psql 将会提示您正在使用的数据库名称，每个数据库名称后面跟随着输入提示字符串 => （如果您使用了超级用户登录，那么提示字符串是 =#）。如下所示：

	gpdatabase=>

在提示字符串后，你可以输入 SQL 命令。每条 SQL 命令必须以分号（ ; ）结束，这样服务器才能接收并执行该命令。如下所示：

	=> SELECT * FROM mytable;


### pgAdmin III
如果您喜欢使用图形化接口，可以使用 pgAdmin III 工具。该图形工具能够支持 PostgreSQL 数据库所有标准特性，也添加了对 <&product-name> 特性的支持。
pgAdmin III 支持 <&product-name> 的特性包括:

* 外部表支持
* Append 表（包括压缩的 Append 表）
* 表分区信息
* 资源队列
* 图形化 EXPLAIN ANALYZE
* 服务器参数配置（禁用？）

### 数据库应用接口
您也许需要开发专有的客户端程序来连接 <&product-name> 系统。
PostgreSQL 为常用的数据库应用接口提供了驱动程序，这些驱动程序可以直接操作 <&product-name>。具体驱动程序及下载链接如下：

| API | PostgreSQL 驱动程序名称 | 下载链接 |
| --- | --- | --- |
| ODBC | pgodbc | Available in the Greenplum Database Connectivity package, which can be downloaded from https://network.pivotal.io/ products. |
| JDBC | pgjdbc | Available in the Greenplum Database Connectivity package, which can be downloaded from https://network.pivotal.io/ products. |
| Perl DBI | pgperl | http://search.cpan.org/dist/DBD-Pg/ |
| Python DBI | pygresql | http://www.pygresql.org/ |

使用 <&product-name> 应用接口的配置步骤：

1. 根据使用语言和接口，下载相关程序。例如：从 Oracle 官方下载。

1. 根据接口说明，编写您的客户端程序。在编写程序时，请注意 <&product-name> 的相关语法，这样可以避免您使用不支持的特性。

1. 下载对应的 PostgreSQL 驱动程序，并配置连接 <&product-name> 主节点的信息。

### 第三方客户工具 ###
大部分第三方 ETL 和商业智能（BI）工具使用标准数据库接口连接 <&product-name>，例如：ODBC 和 JDBC。目前支持的应用包括

* Business Objects
* Microstrategy
* Informatica Power Center
* Microsoft SQL Server Integration Services (SSIS) 和 Reporting Services (SSRS)
* Ascential Datastage
* SAS
* IBM Cognos
