
# 使用 Jmeter、pgbouncer 对 hashdata 数据库进行压力测试

本章节主要介绍了如何使用 Jmeter 与 pgbouncer 对 HashData 数据仓库进行压力测试。

## Jmeter 概述
Jmeter 是压力测试和性能测量的工具，能够对 HTTP 和 FTP 服务器等进行压力和性能测试，也可以对任何数据库进行同样的测试。

Jmeter 使用 jdbc 发送请求，完成对数据库的测试，一个数据库的测试计划，有如下结构：

* jdbc 连接配置：负责数据库连接配置相关的信息

* jdbc 请求：负责发送请求进行测试

* 汇总结果：收集显示测试结果

## pgbouncer 概述
Pgbouncer 是一个针对 PostgreSQL 数据库的轻量级连接池，任何目标应用都可以把 pgbouncer 当作一个 PostgreSQL 服务器来连接，然后 pgbouncer 会处理与服务器连接，或者是重用已存在的连接。

pgbouncer 的目标是降低因为新建到 PostgreSQL 的连接而导致的性能损失。

pgbouncer 同样用于 hashdata 数据库。

## centos7.4 下 Jmeter 安装配置
下载 Jmeter 二进制包地址：http://mirrors.shu.edu.cn/apache//jmeter/binaries/apache-jmeter-5.1.1.tgz

解压

```
# tar xvf apache-jmeter-5.1.1.tar -C /opt
```

解压后直接使用即可

## centos7.4 下 pgbouncer 安装配置
下载地址：[http://pgbouncer.github.io/downloads/files/1.9.0/pgbouncer-1.9.0.tar.gz](http://pgbouncer.github.io/downloads/files/1.9.0/pgbouncer-1.9.0.tar.gz)

将下载文件，使用以下命令进行解压

```
# cd /root 
# tar zxvf pgbouncer-1.9.0.tar.gz
```

解压之后使用以下命令进行安装

```
# cd /root/pgbouncer-1.9.0
# ./configure --prefix=/opt/pgbouncer
# make && make install
```

调整 pgbouncer 的配置文件 `/etc/pgbouncer.ini`

```
[databases] 
# pg_bouncer_hashdata 配置前端数据库名，使用 pgbouncer 连接的数据库名称
# poolsize 配置不要超过4倍cpu核数
pg_bouncer_hashdata=host=192.168.111.10 dbname=hashdata port=5432 pool_size=64
   
[pgbouncer]  
# 连接池模式
pool_mode = transaction  
listen_port = 1999  
unix_socket_dir = /data/pgbouncer/
listen_addr = *  
auth_type = md5  
auth_file = /data/pgbouncer/users1999.txt 
logfile = /data/pgbouncer/pgbouncer1999.log  
pidfile = /data/pgbouncer/pgbouncer1999.pid 

# 允许的最大连接数
max_client_conn = 1000 
reserve_pool_timeout = 0 
admin_users = pgbouncer_admin  
stats_users = pgbouncer_guest 
ignore_startup_parameters = extra_float_digits
```

启动 pgbouncer

```
# su - pgbouner
# /opt/pgbouncer/bin/pgbouncer -d /etc/pgbouncer.ini    
```

-d 是后台执行

`/etc/pgbouncer.ini` 是 pgbouncer 的配置文件


##测试步骤

### 测试场景一：jmeter 通过 pgbouncer 连接数据库进行测试。

系统：centos7.4

数据库：hashdata

数据库缓冲池：pgbouncer-1.9.0

#### 测试命令：

```
/opt/apache-jmeter-5.1.1/bin/jmeter -n -t hashdata.jmx  -l hashdata.res -j hashdata.log -e -o /home/pgbouncer/result/   
```
参数介绍：

* -n：非GUI模式下运行的jmeter
* -t：运行jmeter测试(.jmx)文件
* -l：文件记录样本
* -j：jmeter运行的日志文件
* -e：生成测试报告
* -o：测试报告存放位置

测试结果：

|线程数|效率|
|:--:|:--:|
|50|throughput 是 4.7/sec
|100|throughput 是 5.3/sec
|120|throughput 是 5.5/sec
|150|throughput 是 5.5/sec
|200|throughput 是 5.1/sec

### 测试场景二：jemter直连数据库进行测试

系统：centos7.4

数据库：hashdata

测试命令：

```
/opt/apache-jmeter-5.1.1/bin/jmeter -n -t hashdata.jmx  -l hashdata.res -j hashdata.log -e -o /home/pgbouncer/result/
```
测试结果：

|线程数|效率|
|:--:|:--:|
|50|throughput 是 4.8/sec
|100|throughput 是 5.1/sec
|120|throughput 是 5.5/sec
|150|throughput 是 5.0/sec
|200|throughput 是 5.0/sec






