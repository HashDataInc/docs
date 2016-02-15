# <&product-name> 创建和管理 #
## 创建 <&product-name> 集群 ##
集群详情

* 集群名称
* 初始化数据库名称（默认）
* 端口
* 初始用户名
* 密码

节点配置

* 版本：软件大版本
* 类型
	* 低配大容量
	* 高配大容量
	* 低配高速存储
	* 高配高速存储

* 集群类型
	* 单节点集群（1节点）
	* 多节点集群（1-16节点）

额外配置

* 默认配置组
* 加密(不支持)
* VPC 配置
* 公网访问
* 选择公网ip
* 选择机房

## 开始使用 ##
丽荣部分？

## 访问<&product-name> ##
本小结向您介绍使用不同工具连接 <&product-name> 系统会话的方法。
### 建立会话 ###
Users can connect to Greenplum Database using a PostgreSQL-compatible client program, such as psql. Users and administrators always connect to Greenplum Database through the master; the segments cannot accept client connections.
In order to establish a connection to the Greenplum Database master, you will need to know the following connection information and configure your client program accordingly.

| Connection Parameter | Description | Environment Variable |
| --- | --- | --- |
| Application name | The application name that is connecting to the database. The default value, held in the application_name connection parameter is psql. | $PGAPPNAME |
| Database name | The name of the database to which you want to connect. For a newly initialized system, use the template1 database to connect for the first time. | $PGDATABASE |
| Host name | The host name of the Greenplum Database master. The default host is the local host. | $PGHOST |
| Port | The port number that the Greenplum Database master instance is running on. The default is 5432. | $PGPORT |
| User name | The database user (role) name to connect as. This is not necessarily the same as your OS user name. Check with your Greenplum administrator if you are not sure what you database user name is. Note that every Greenplum Database system has one superuser account that is created automatically at initialization time. This account has the same name as the OS name of the user who initialized the Greenplum system (typically gpadmin). | $PGUSER |

### 支持客户端列表 ###
Users can connect to Greenplum Database using various client applications:
* A number of Greenplum Database Client Applications are provided with your Greenplum installation.
The psql client application provides an interactive command-line interface to Greenplum Database.
* pgAdmin III for Greenplum Database is an enhanced version of the popular management tool pgAdmin III. Since version 1.10.0, the pgAdmin III client available from PostgreSQL Tools includes support
for Greenplum-specific features. Installation packages are available for download from the pgAdmin download site .
* Using standard Database Application Interfaces, such as ODBC and JDBC, users can create their own client applications that interface to Greenplum Database. Because Greenplum Database is based on PostgreSQL, it uses the standard PostgreSQL database drivers.
* Most Third-Party Client Tools that use standard database interfaces, such as ODBC and JDBC, can be configured to connect to Greenplum Database.

### Connecting with psql ###
Depending on the default values used or the environment variables you have set, the following examples show how to access a database via psql:

	$ psql -d gpdatabase -h master_host -p 5432 -U gpadmin

	$ psql gpdatabase

	$ psql

If a user-defined database has not yet been created, you can access the system by connecting to the template1 database. For example:

    $ psql template1

After connecting to a database, psql provides a prompt with the name of the database to which psql is currently connected, followed by the string => (or =# if you are the database superuser). For example:

	gpdatabase=>

At the prompt, you may type in SQL commands. A SQL command must end with a ; (semicolon) in order to be sent to the server and executed. For example:

	=> SELECT * FROM mytable;

See the Greenplum Reference Guide for information about using the psql client application and SQL commands and syntax.

### pgAdmin III for Greenplum Database ###

If you prefer a graphic interface, use pgAdmin III for Greenplum Database. This GUI client supports PostgreSQL databases with all standard pgAdmin III features, while adding support for Greenplum-specific features.
pgAdmin III for Greenplum Database supports the following Greenplum-specific features:

* External tables
* Append-optimized tables, including compressed append-optimized tables
* Table partitioning
* Resource queues
* Graphical EXPLAIN ANALYZE
* Greenplum server configuration parameters

### Database Application Interfaces ###
You may want to develop your own client applications that interface to Greenplum Database. PostgreSQL provides a number of database drivers for the most commonly used database application programming interfaces (APIs), which can also be used with Greenplum Database. These drivers are available as
a separate download. Each driver is an independent PostgreSQL development project and must be downloaded, installed and configured to connect to Greenplum Database. The following drivers are available:

| API | PostgreSQL Driver | Download Link |
| --- | --- | --- |
| ODBC | pgodbc | Available in the Greenplum Database Connectivity package, which can be downloaded from https://network.pivotal.io/ products. |
| JDBC | pgjdbc | Available in the Greenplum Database Connectivity package, which can be downloaded from https://network.pivotal.io/ products. |
| Perl DBI | pgperl | http://search.cpan.org/dist/DBD-Pg/ |
| Python DBI | pygresql | http://www.pygresql.org/ |

General instructions for accessing a Greenplum Database with an API are:
1. Download your programming language platform and respective API from the appropriate source. For example, you can get the Java Development Kit (JDK) and JDBC API from Sun.

1. Write your client application according to the API specifications. When programming your application, be aware of the SQL support in Greenplum Database so you do not include any unsupported SQL syntax.

Download the appropriate PostgreSQL driver and configure connectivity to your Greenplum Database master instance. Greenplum Database provides a client tools package that contains the supported database drivers for Greenplum Database. Download the client tools package from Pivotal Network and documentation from Pivotal Documentation.

### Third-Party Client Tools ###
Most third-party extract-transform-load (ETL) and business intelligence (BI) tools use standard database interfaces, such as ODBC and JDBC, and can be configured to connect to Greenplum Database. Pivotal has worked with the following tools on previous customer engagements and is in the process of becoming officially certified:

* Business Objects
* Microstrategy
* Informatica Power Center
* Microsoft SQL Server Integration Services (SSIS) and Reporting Services (SSRS)
* Ascential Datastage
* SAS
* IBM Cognos

Pivotal Professional Services can assist users in configuring their chosen third-party tool for use with Greenplum Database.

## 使用数据库 ##

### 定义数据库对象
### 管理数据 ###
### 查询数据 ###

## 数据库安全管理 ##
## 数据的导入导出 ##
## 性能优化 ##