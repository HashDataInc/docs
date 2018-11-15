# 使用 Python 访问 HashData 数据仓库

本文将介绍如何使用 python 编程语言，访问 HashData 数据仓库。本文以 CentOS 7  操作系统为例进行讲解，其它操作系统的操作类似。本文如果没有特殊说明，相关代码在 python 2 与 python 3 两个版本上都可以使用。

[Psycopg](http://initd.org/psycopg/docs/index.html) 是一个用于访问 PostgreSQL 数据库的开源 python 模块，由于 HashData 数据仓库完全兼容 PostgreSQL 的客户端协议，所以我们通过 psycopg 模块来访问 HashData 数据仓库。

## 安装 psycopg

我们推荐使用 pip 工具安装 psycopg。如果你使用的是 Python 2 >=2.7.9 或者 Python 3 >=3.4 版本，那么 pip 很可能已经安装好了。如果pip没有被安装，我们首先需要安装 pip。执行以下命令即可完成 pip 的安装。

```
# curl https://bootstrap.pypa.io/get-pip.py | python
```

接下来，我们开始安装 psycopg。执行以下命令即可完成 psycopg 的安装。

```
# pip install psycopg2-binary
```

至此，我们成功的安装了 psycopg 模块。如果您在安装的过程中遇到问题，可以参考[此文档](http://initd.org/psycopg/docs/install.html)获取更详细的信息。



## Python 3 环境

安装 Python 3.6

```
# yum install centos-release-scl
# yum install rh-python36
# scl enable rh-python36 bash
# python --version
Python 3.6.3
```

安装 psycopg 模块

```
# pip install psycopg2-binary
```



## 连接 HashData 数据仓库

Psycopg 实现了 Python [DB API 2.0](https://www.python.org/dev/peps/pep-0249/) 规范，因此如果您有使用 Python DB API 2.0 连接其它数据库的经验，那么您将很容的将此经验用于连接 HashData 数据仓库。

我们首先尝试创建一个数据库连接。接下来的所有操作，我们都使用交互式 Python 的方式进行演示。

```
# 导入 pyscopg 模块
>>> import psycopg2

# 创建数据库连接
>>> conn = psycopg2.connect(host="127.0.0.1", port=5432, dbname="postgres", user="hashdata", password="hashdata")
```

以上代码非常直观且易于理解，我们通过指定 HashData 数据仓库的连接信息，创建了一个数据库连接。接下来，我们将通过这个数据库连接，进行一些数据库操作。关于创建数据库连接，您可以访问[此文档](http://initd.org/psycopg/docs/module.html#psycopg2.connect)获取更多的信息。



## 执行 DDL 语句

通过数据库连接，我们可以创建`游标`，游标是用来进行数据库操作的对象，我们今后会经常用到它。我们接下来要创建一张表，并且插入一些数据。

```
# 创建一个游标对象，用于执行数据库操作
>>> cur = conn.cursor()

# 创建一张表
>>> cur.execute("CREATE TABLE test (num integer);")

# 插入一些数据
>>> cur.execute("INSERT INTO test SELECT generate_series(%s, %s)", (1, 1000))
```

注意以上例子中插入数据的语句，我们通过参数的方式，指定了序列的开始和结束。我们并没有在这拼接 SQL 字符串，因此我们不在担心 SQL 注入的安全风险。




接下来，我们查询一下刚刚插入的数据。并将查询结果展示出来。

```
# 查询
>>> cur.execute("SELECT sum(num) FROM test;")
>>> cur.fetchone()
(500500L,)
```

在上面这个例子中，我们通过游标的`fetchone`方法获取一个查询结果。游标提供了丰富多样的方法处理返回结果。更详细的说明，可以参考[此文档](http://initd.org/psycopg/docs/cursor.html)。

我们需要提交事务，才能使得之前插入的数据持久化的保存在数据库中。事务提交是通过数据库连接对象完成的。

最会，我们需要关闭游标和数据库连接，释放所有的资源。



```
# 提交事务
>>> conn.commit()

# 关闭游标和数据库连接
>>> cur.close()
>>> conn.close()
```



## 错误处理

当 psycopg 遇到错误的时候，会抛出异常。Psycopg 的所有异常都是集成自`psycopg2.Error`, 可以通过 Python 的异常处理机制，方便的处理各种数据库和客户端的异常情况。




























