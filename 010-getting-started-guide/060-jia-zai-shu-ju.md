## 步骤5: 将样例数据从对象存储加载到 HashData 数据仓库中


现在你已经有了一个名为 postgres 的数据库，并且你已经成功地连接上它了。接下来你可以在数据库中创建一些新表，然后加载数据到这些表中，并尝试一些查询语句。为了方便你的测试，我们准备了一些TPC-H的样例数据存储在青云对象存储中。

1.  创建表

    拷贝并执行下面的建表语句在 postgres 数据库中创建相应的表对象。你可以通过 HashData 数据仓库 [开发者指南](http://www.hashdata.cn/docs/developer-guide/welcome.html) 查看更详细的建表语法。

    其中定义的外部表（READABLE EXTERNAL TABLE）用来访问青云对象存储上面的数据。我们提供了 TPC-H 1GB、10GB、100GB 的公共测试数据集，在此示例中我们使用 1GB 的 TPCH 数据集。

```
    CREATE TABLE NATION  ( 
        N_NATIONKEY  INTEGER NOT NULL,
        N_NAME       CHAR(25) NOT NULL,
        N_REGIONKEY  INTEGER NOT NULL,
        N_COMMENT    VARCHAR(152));

    CREATE TABLE REGION  ( 
        R_REGIONKEY  INTEGER NOT NULL,
        R_NAME       CHAR(25) NOT NULL,
        R_COMMENT    VARCHAR(152));

    CREATE TABLE PART  ( 
        P_PARTKEY     INTEGER NOT NULL,
        P_NAME        VARCHAR(55) NOT NULL,
        P_MFGR        CHAR(25) NOT NULL,
        P_BRAND       CHAR(10) NOT NULL,
        P_TYPE        VARCHAR(25) NOT NULL,
        P_SIZE        INTEGER NOT NULL,
        P_CONTAINER   CHAR(10) NOT NULL,
        P_RETAILPRICE DECIMAL(15,2) NOT NULL,
        P_COMMENT     VARCHAR(23) NOT NULL );

    CREATE TABLE SUPPLIER ( 
        S_SUPPKEY     INTEGER NOT NULL,
        S_NAME        CHAR(25) NOT NULL,
        S_ADDRESS     VARCHAR(40) NOT NULL,
        S_NATIONKEY   INTEGER NOT NULL,
        S_PHONE       CHAR(15) NOT NULL,
        S_ACCTBAL     DECIMAL(15,2) NOT NULL,
        S_COMMENT     VARCHAR(101) NOT NULL);

    CREATE TABLE PARTSUPP ( 
        PS_PARTKEY     INTEGER NOT NULL,
        PS_SUPPKEY     INTEGER NOT NULL,
        PS_AVAILQTY    INTEGER NOT NULL,
        PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
        PS_COMMENT     VARCHAR(199) NOT NULL );

    CREATE TABLE CUSTOMER ( 
        C_CUSTKEY     INTEGER NOT NULL,
        C_NAME        VARCHAR(25) NOT NULL,
        C_ADDRESS     VARCHAR(40) NOT NULL,
        C_NATIONKEY   INTEGER NOT NULL,
        C_PHONE       CHAR(15) NOT NULL,
        C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
        C_MKTSEGMENT  CHAR(10) NOT NULL,
        C_COMMENT     VARCHAR(117) NOT NULL);

    CREATE TABLE ORDERS (
        O_ORDERKEY       INT8 NOT NULL,
        O_CUSTKEY        INTEGER NOT NULL,
        O_ORDERSTATUS    CHAR(1) NOT NULL,
        O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
        O_ORDERDATE      DATE NOT NULL,
        O_ORDERPRIORITY  CHAR(15) NOT NULL,
        O_CLERK          CHAR(15) NOT NULL,
        O_SHIPPRIORITY   INTEGER NOT NULL,
        O_COMMENT        VARCHAR(79) NOT NULL);

    CREATE TABLE LINEITEM ( 
        L_ORDERKEY    INT8 NOT NULL,
        L_PARTKEY     INTEGER NOT NULL,
        L_SUPPKEY     INTEGER NOT NULL,
        L_LINENUMBER  INTEGER NOT NULL,
        L_QUANTITY    DECIMAL(15,2) NOT NULL,
        L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
        L_DISCOUNT    DECIMAL(15,2) NOT NULL,
        L_TAX         DECIMAL(15,2) NOT NULL,
        L_RETURNFLAG  CHAR(1) NOT NULL,
        L_LINESTATUS  CHAR(1) NOT NULL,
        L_SHIPDATE    DATE NOT NULL,
        L_COMMITDATE  DATE NOT NULL,
        L_RECEIPTDATE DATE NOT NULL,
        L_SHIPINSTRUCT CHAR(25) NOT NULL,
        L_SHIPMODE     CHAR(10) NOT NULL,
        L_COMMENT      VARCHAR(44) NOT NULL);

    CREATE READABLE EXTERNAL TABLE e_NATION (LIKE NATION)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/nation/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_REGION (LIKE REGION)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/region/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_PART (LIKE PART)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/part/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_SUPPLIER (LIKE SUPPLIER)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/supplier/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_PARTSUPP (LIKE PARTSUPP)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/partsupp/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_CUSTOMER (LIKE CUSTOMER)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/customer/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_ORDERS (LIKE ORDERS)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/orders/') FORMAT 'csv';

    CREATE READABLE EXTERNAL TABLE e_LINEITEM (LIKE LINEITEM)
    LOCATION ('qs://hashdata-public.pek3a.qingstor.com/tpch/1g/lineitem/') FORMAT 'csv';
```

1. 执行如下命令将保存在对象存储上面的 TPC-H 数据拷贝插入到数据仓库表中。

```
INSERT INTO NATION SELECT * FROM e_NATION;  
INSERT INTO REGION SELECT * FROM e_REGION;  
INSERT INTO PART SELECT * FROM e_PART;  
INSERT INTO SUPPLIER SELECT * FROM e_SUPPLIER;  
INSERT INTO PARTSUPP SELECT * FROM e_PARTSUPP;  
INSERT INTO CUSTOMER SELECT * FROM e_CUSTOMER;  
INSERT INTO ORDERS SELECT * FROM e_ORDERS;  
INSERT INTO LINEITEM SELECT * FROM e_LINEITEM;
```

1. 现在可以开始运行样例查询了。

   这里所采用的数据集和查询是商业智能计算测试 TPC-H。TPC-H 是美国交易处理效益委员会组织制定的用来模拟决策支持类应用的一个测试集。TPC-H 实现了一个数据仓库，共包含8个基本表，其数据量可以设定从 1G 到 3T 不等。在这个样例中，我们选择了 1G 的数据集。TPC-H 基准测试包括 22 个查询，其主要评价指标是各个查询的响应时间，即从提交查询到结果返回所需时间。这里只提供了前三条查询语句。关于 TPC-H 完整 22 条查询语句以及详细介绍可参考 [TPC-H 主页](http://www.tpc.org/tpch/)。

```
-- This query reports the amount of business that was billed, shipped, and returned.

select  
       l_returnflag,  
       l_linestatus,  
       sum(l_quantity) as sum_qty,  
       sum(l_extendedprice) as sum_base_price,  
       sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,  
       sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,  
       avg(l_quantity) as avg_qty,  
       avg(l_extendedprice) as avg_price,  
       avg(l_discount) as avg_disc,  
       count(*) as count_order  
   from  
       lineitem

where  
       l_shipdate <=  '1998-12-01'  
   group by  
       l_returnflag,  
       l_linestatus  
   order by  
       l_returnflag,  
       l_linestatus;

-- This query finds which supplier should be selected to place an order for a given part in a given region.

select  
       s.s_acctbal,  
       s.s_name,  
       n.n_name,  
       p.p_partkey,  
       p.p_mfgr,  
       s.s_address,  
       s.s_phone,  
       s.s_comment  
   from  
       supplier s,  
       partsupp ps,  
       nation n,  
       region r,  
       part p,  
       (select p_partkey, min(ps_supplycost) as min_ps_cost  
               from  
                       part,  
                       partsupp ,  
                       supplier,  
                       nation,  
                       region  
               where  
                       p_partkey=ps_partkey  
                       and s_suppkey = ps_suppkey  
                       and s_nationkey = n_nationkey  
                       and n_regionkey = r_regionkey  
                       and r_name = 'EUROPE'  
               group by p_partkey ) g  
   where  
       p.p_partkey = ps.ps_partkey  
       and g.p_partkey = p.p_partkey  
       and g. min_ps_cost = ps.ps_supplycost  
       and s.s_suppkey = ps.ps_suppkey  
       and p.p_size = 45  
       and p.p_type like '%NICKEL'  
       and s.s_nationkey = n.n_nationkey  
       and n.n_regionkey = r.r_regionkey  
       and r.r_name = 'EUROPE'  
   order by  
       s.s_acctbal desc,  
       n.n_name,  
       s.s_name,  
       p.p_partkey  
   LIMIT 100;

-- This query retrieves the 10 unshipped orders with the highest value.

select  
       l_orderkey,  
       sum(l_extendedprice * (1 - l_discount)) as revenue,  
       o_orderdate,  
       o_shippriority  
   from  
       customer,  
       orders,  
       lineitem  
   where  
       c_mktsegment = 'MACHINERY'  
       and c_custkey = o_custkey  
       and l_orderkey = o_orderkey  
       and o_orderdate < '1995-03-15'  
       and l_shipdate >  '1995-03-15'  
   group by  
       l_orderkey,  
       o_orderdate,  
       o_shippriority  
   order by  
       revenue desc,  
       o_orderdate  
   LIMIT 10;  
```
