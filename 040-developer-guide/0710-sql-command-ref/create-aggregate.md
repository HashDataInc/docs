# CREATE AGGREGATE

定义一个新的聚集函数。

## 概要

```
CREATE [ORDERED] AGGREGATE name (input_data_type [ , ... ]) 
      ( SFUNC = sfunc,
        STYPE = state_data_type
        [, PREFUNC = prefunc]
        [, FINALFUNC = ffunc]
        [, INITCOND = initial_condition]
        [, SORTOP = sort_operator] )
```

## 描述

CREATE AGGREGATE 定义一个新的聚集函数。在发布中已经包括了一些基本的和常用的聚集函数，像count、min、max、sum、avg 等在 HashData 数据库中已被提供。如果要定义一个新类型或者需要一个还没有被提供的聚集函数，那么 CREATE AGGREGATE 就可以被用来提供想要的特性。

一个聚集函数需要用它的名称和输入数据类型标识。同一个方案中的两个聚集可以具有相同的名称，只要它们在不同的输入类型上操作即可一个聚集的名称和输入数据类型必须与同一方案中的每一个普通函数区分开。

聚集函数由一个，两个或三个常规函数组成（所有这些函数都必须是 IMMUTABLE 函数）：

* 一个状态转移函数 sfunc
* 一个可选的 Segment 级预备计算函数 prefunc
* 一个可选的最终计算函数 ffunc

这些函数被使用如下：

```
sfunc( internal-state, next-data-values ) ---> next-internal-state
prefunc( internal-state, internal-state ) ---> next-internal-state
ffunc( internal-state ) ---> aggregate-value
```

用户可以指定 PREFUNC 作为优化聚集执行的方法。通过指定 PREFUNC，聚集可以先在 Segment 上并行执行然后再在 Master 上执行。在执行双层聚集时，SFUNC 在 Segment 上被执行以产生部分聚集结果，而 PREFUNC 在 Master 上被执行以聚集来自 Segment 的部分结果。如果执行单层聚集，所有的行都会被发送到 Master，然后在行上应用 sfunc。

单层聚集和双层聚集是等效的执行策略。任何一种聚集类型都可以在查询计划中实现。当用户实现函数 prefunc 和 sfunc 时，必须确保在 Segment 实例上调用 sfunc 接着在 Master 上调用 prefunc 产生的结果和单层聚集（将所有的行发送到 Master 然后只在行上应用 sfunc）相同。

HashData 数据库会创建一个数据类型为 stype 的临时变量来保存聚集函数的内部状态。在每一个输入行，聚集参数值会被计算并且状态转移函数在当前状态值和新的参数值上被调用以计算一个新的内部状态值。在所有的行被处理之后，最终函数被调用一次以计算该聚集的返回值。如果没有最终函数，则最终状态会被原样返回。

聚集函数可以提供一个可选的初始条件，即一个内部状态值的初始值。在数据库中这被指定并且存储为文本类型的值，但是它必须是内部状态之数据类型的一个合法外部表达。如果不支持这种初始值，则状态值会开始于 NULL。

如果状态转移函数被声明为 STRICT，那么就不能用 NULL 输入调用它。对于这样一个转移函数，聚集执行会按下面的方式执行。带有任何空输入值的行会被忽略（该函数不会被调用并且保持之前的状态值）。如果初始状态值为 NULL，那么在第一个具有所有非空输入值的行那里，第一个参数值会替换状态值，并且对后续具有所有非空输入值的行调用转移函数。这对于实现 max 之类的聚集很有用。注意，只有当 state\_data\_type 与第一个 input\_data\_type 相同时，这种行为才可用。当这些类型不同时，用户必须提供一个非空初始条件或者使用一个非严格的转移函数。

如果状态转移函数没有被声明为 STRICT，那么对每一个输入行将无条件调用它，并且它必须自行处理 NULL 输入和 NULL 转移状态。这允许聚集的作者完全控制聚集对 NULL 值的处理。

如果最终函数被声明为 STRICT，那么当结束状态值为 NULL 时不会调用它，而是自动返回一个 NULL 结果（这是 STRICT 函数的通常行为）。在任何情况下，最终函数都有返回一个 NULL 值的选项。例如，avg 的最终函数会在它看到零个输入行时返回 NULL。

单参数聚集函数（例如 min 和 max）有时候可以通过查看索引而不是扫描每个输入行来优化。如果可以这样优化聚集，可通过指定一个排序操作符来指明。基本的要求是该聚集必须得到该操作符产生的排序顺序中的第一个元素，换句话说：

```
SELECT agg(col) FROM tab;
```

必须等效于：

```
SELECT col FROM tab ORDER BY col USING sortop LIMIT 1;
```

进一步的假定是聚集函数会忽略 NULL 输入，并且它只在没有非空输入时才给出一个 NULL 结果。通常，一种数据类型的 &lt; 操作符是用于 MIN 的正确排序操作符，而 &gt; 是用于 MAX 的正确排序操作符。注意除非指定的操作符是 B-树 索引操作符类中的 “小于” 或者 “大于” 策略成员，那么这种优化将不会实际生效。

**有序聚集**

如果出现 ORDERED，则创建的聚集函数是一种 _有序聚集_ 。这种情况下，不能指定预备聚集函数 prefunc。

有序聚集使用下面的语法调用。

```
name ( arg [ , ... ] [ORDER BY sortspec [ , ...]] )
```

如果 ORDER BY 被省略，则会使用一种系统定义的排序。有序聚集函数的转移函数 sfunc 会在其输入参数上以指定顺序在单个 Segment 上被调用。在 pg\_aggregate 表中有一个新列 aggordered 来指定聚集函数是否被定义为有序聚集。

## 参数

_name_

要创建的聚集函数的名称（可以被方案限定）。

_input\_data\_type_

这个聚集函数在其上进行操作的输入数据类型。要创建一个零参数的聚集函数，在输入数据类型的列表位置写上 \* 。这类聚集的例子是 count\(\*\)。

_sfunc_

为每一个输入行调用的状态转移函数的名称。对于一个 N- 参数的聚集函数，sfunc 必须接收 N+1 个参数，第一个参数类型为 state\_data \_type 而其他的匹配该聚集声明的输入数据类型。该函数必须返回一个类型为 state\_data\_type 的值。这个函数会拿到当前状态值和当前的输入数据值，并且返回下一个状态值。

_state\_data\_type_

聚集状态值的数据类型。

_prefunc_

预备聚集函数的名称。这是一个有两个参数的函数，参数的类型都是 state\_data\_type。它必须返回一个 state\_data\_type 类型的值。预备函数会拿到两个转移状态值并且返回一个新的转移状态值来表示组合的聚集。在 HashData 数据库中，如果聚集函数的结果是以分 Segment 的方式计算，预备聚集函数就会在一个个内部状态上调用以便把它们组合成一个结束内部状态。

注意在 Segment 内部的哈希聚集模式中也会调用这个函数。因此，如果用户调用这个没有预备函数的聚集函数，则绝不会选中哈希聚集。由于哈希聚集很有效，因此只要可能，还是应该考虑定义预备函数。

_ffunc_

在所有的输入行都已经被遍历过后，要调用来计算聚集结果的最终函数的名称。这个函数必须接收类型为 state\_data\_type 的单个参数。该聚集的返回数据被定义为这个函数的返回类型。如果没有指定 ffunc，那么结束状态值会被用作聚集结果并且该返回类型为 state\_data\_type。

_initial\_condition_

状态值的初始设置。这必须是一个数据类型 state\_data\_type 可接受形式的字符串常量。如果没有指定，状态值会开始于 NULL。

_sort\_operator_

用于 MIN- 或者 MAX 类聚集函数的相关排序操作符。这只是一个操作符名称（可能被方案限定）。该操作符被假定为具有与聚集函数（必须是一个单参数聚集函数）相同的输入数据类型。

## 注解

用于定义新聚集函数的普通函数必须先被定义。注意在这个 HashData 数据库的发行中，要求用于创建聚集的 sfunc、ffunc 以及 prefunc 函数被定义为 IMMUTABLE。

如果在窗口表达式中使用用户定义的聚集，必须为该聚集定义 prefunc 函数。

如果 HashData 数据库服务器配置参数 gp\_enable\_multiphase\_agg 的值为 off，只有单层聚集会被执行。

任何用于自定义函数的已编译代码（共享库文件）在用户的 HashData 数据库阵列（Master 和所有 Segment）中的每一台主机上都必须被放置在相同的位置。这个位置还必须在 LD\_LIBRARY\_PATH 中，这样服务器可以定位到文件。

## 示例

下面的简单例子创建一个计算两列总和的聚集函数。

在创建聚集函数之前，创建两个被用作该函数的 SFUNC 和 PREFUNC 函数的函数。

这个函数被指定为该聚集函数中的 SFUNC 函数。

```
CREATE FUNCTION mysfunc_accum(numeric, numeric, numeric) 
  RETURNS numeric
   AS 'select $1 + $2 + $3'
   LANGUAGE SQL
   IMMUTABLE
   RETURNS NULL ON NULL INPUT;
```

这个函数被指定为该聚集函数中的 PREFUNC 函数。

```
CREATE FUNCTION mypre_accum(numeric, numeric )
  RETURNS numeric
   AS 'select $1 + $2'
   LANGUAGE SQL
   IMMUTABLE
   RETURNS NULL ON NULL INPUT;
```

这个 CREATE AGGREGATE 命令会创建将两列相加的聚集函数。

```
CREATE AGGREGATE agg_prefunc(numeric, numeric) (
   SFUNC = mysfunc_accum,
   STYPE = numeric,
   PREFUNC = mypre_accum,
   INITCOND = 0 );
```

下列命令创建一个表，增加一些行并且运行聚集函数。

```
create table t1 (a int, b int) DISTRIBUTED BY (a);
insert into t1 values
   (10, 1),
   (20, 2),
   (30, 3);
select agg_prefunc(a, b) from t1;
```

这个 EXPLAIN 命令显示两阶段聚集。

```
explain select agg_prefunc(a, b) from t1;

QUERY PLAN
-------------------------------------------------------------------------- 
Aggregate (cost=1.10..1.11 rows=1 width=32)  
 -> Gather Motion 2:1 (slice1; segments: 2) (cost=1.04..1.08 rows=1
      width=32)
     -> Aggregate (cost=1.04..1.05 rows=1 width=32)
       -> Seq Scan on t1 (cost=0.00..1.03 rows=2 width=8)
 (4 rows)
```

## 兼容性

CREATE AGGREGATE 是一种 HashData 数据库的语言扩展。SQL 标准不提供用户定义的聚集函数。

## 另见

[ALTER AGGREGATE](./alter-aggregate.md)，[DROP AGGREGATE](./drop-aggregate.md)，[CREATE FUNCTION](./create-function.md)

**上级主题：** [SQL命令参考](./README.md)

