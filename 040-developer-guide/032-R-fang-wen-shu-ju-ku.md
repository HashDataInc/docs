# 使用 R 语言访问数据仓库

本文将介绍如何使用 R 语言，访问 HashData 数据仓库。本文以 CentOS 7 操作系统为例进行讲解，其它操作系统的操作类似。

RPostgreSQL 是一个用于访问 PostgreSQL 数据库的开源 R 模块，由于 HashData 数据仓库完全兼容 PostgreSQL 的客户端协议，所以我们通过 RPostgreSQL 模块来访问 HashData 数据仓库。
## R & RPostgreSQL 安装

R 已经集成到 epel 中管理，可以通过 YUM 来安装

```
yum install epel-release
yum install R
```

在准备好 R 语言环境之后，需要安装 [RPostgreSQL 扩展](https://cran.r-project.org/src/contrib/Archive/RPostgreSQL/)，在官网下载即可。

安装指令如下：

```
R CMD INSTALL RPostgreSQL_0.4-1.tar.gz
```

在安装过程中可能会出现各种问题，可以通过以下两步解决：

* 如果出现缺少 libpq-fe.h 文件的错误，则通过安装 postgresql-devel 可以解决，指令如下：
	
	```
	yum install postgresql-devel
	```
* 如果出现 DBI 版本不对的问题，则可以通过安装合适版本的 DBI 来解决，下载地址 [DBI archive](https://cran.r-project.org/src/contrib/Archive/DBI/)

	```
	# install DBI
	R CMD INSTALL DBI_0.4-1.tar.gz
	```

至此我们就可以使用 R 来操作 HashData 数据仓库了。
## 连接 HashData 数据仓库
RPostgreSQL 实现了 R 连接并操作 HashData 数据仓库。

我们首先尝试创建一个数据库连接。接下来的所有操作，我们都使用交互式 R 的方式进行演示。

```
# 导入 RPostgreSQL 模块
> require(RPostgreSQL)

# 创建数据库连接
> drv = dbDriver("PostgreSQL")
> pgdb_con = dbConnect(drv, user="hashdata", password="123456", host="192.168.111.5")
```

以上代码非常直观且易于理解，我们通过指定 HashData 数据仓库的连接信息，创建了一个数据库连接。接下来，我们将通过这个数据库连接，进行一些数据库操作。关于创建数据库连接，您可以访问[RPostgreSQL 内置数据库操作方法](https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf)获取更多的信息。


## 执行语句
在 RPostgreSQL 中继承了很多的以 db 开头的方法，我们今后会经常用到它们 [RPostgreSQL 内置数据库操作方法](https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf)。我们接下来要创建一张表，并且插入一些数据。

```
# 创通过 dbGetQuery 创建一个表
> dbGetQuery(pgdb_con, "create table test(id int);")

# 插入一些数据
> dbGetQuery(pgdb_con, "insert into test values(1);")
```

接下来，我们查询一下刚刚插入的数据。并将查询结果展示出来。

```
# 查询
> dbGetQuery(pgdb_con, "select * from test;")
```

在上面的例子中我们使用了 dbGetQuery function 来进行了表的创建，数据插入，查询操作。更多数据库操作相关的函数使用，请参考 [RPostgreSQL 内置数据库操作方法](https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf) 。

我们在操作完成之后，需要释放所有的资源。

```
> dbDisconnect(pgdb_con)
> dbUnloadDriver(drv)
```
## 错误处理

可以通过 dbGetException 函数获取一些标准报错信息列表

```
 > dbGetException(pgdb_con)
```