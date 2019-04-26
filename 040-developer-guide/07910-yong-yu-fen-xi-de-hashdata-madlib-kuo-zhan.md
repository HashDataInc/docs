# 用于分析的 MADlib 扩展

本章节包含了以下信息：

*   [关于 MADlib](#topic1)
*   [示例](#topic2)
*   [参考](#topic3)

**上级主题：** [HashData 数据库参考指南](./README.md)

## <h2 id='topic1'> 关于 MADlib

MADlib 是一个可扩展数据库分析的开源库。通过 HashData 的 MADlib 扩展，用户可以在 HashData 数据库中使用 MADlib 功能。

MADlib 为结构化数据以及非结构化数据提供了数学、统计学以及机器学习方法的数据并行的实现。它提供了一整套基于 SQL 的机器学习、数据挖掘以及统计学算法，只需要运行在数据库引擎中，而不需要在 HashData 和其它工具之间进行数据的传递。

MADlib 可以与 PivotalR 一同使用，一个 PivotalR 包允许用户使用 R 客户端同 HashData 的数据进行交互。见 [关于 MADlib、R、PivotalR](#topic3_1)。

> 注意：当使用 MADlib，设置配置参数 optimizer_control 为 on （默认值）。如果该参数被设置为 off，那么这些 MADlib 函数将不会工作：决策树、随机森林、LDA、决策树的 PMML、随机森林的 PMML。参数 optimizer_control 控制是配置参数 optimizer 能够被修改。参数 optimizer 控制在执行 SQL 查询时 GPORCA 优化器是否被打开。一些 MADlib 安装检查和函数改变 optimizer 的值来提高性能。如果将 optimizer_control 设置为 off，那么 optimizer 的值不能修改，同时函数会失败。

## <h2 id='topic2'> 示例

下面是使用 HashData MADlib 扩展的示例：

*   [线性回归](#topic3_2)
*   [关联规则](#topic3_3)
*   [朴素贝叶斯分类](#topic3_4)

见 MADlib 文档获取更多的示例。

### <h3 id='topic3_2'> 线性回归

该示例是在表 regr_example 执行一个线性回归。因变量数据在 y 列中，独立变量数据在 x1 和 x2 列中。

下面的语句创建 regr_example 表同时加载样本数据：

```
DROP TABLE IF EXISTS regr_example;
CREATE TABLE regr_example (
   id int,
   y int,
   x1 int,
   x2 int
);
INSERT INTO regr_example VALUES 
   (1,  5, 2, 3),
   (2, 10, 7, 2),
   (3,  6, 4, 1),
   (4,  8, 3, 4);
```
MADlib 的 linregr\_train() 函数产生一个根据一个输入表包含的训练数据产生一个回归模型。下面的SELECT 语句在表 regr_example 执行一个简单的多元回归同时保存模型在表 reg\_example\_model中。

```
SELECT madlib.linregr_train (
   'regr_example',         -- source table
   'regr_example_model',   -- output model table
   'y',                    -- dependent variable 
   'ARRAY[1, x1, x2]'      -- independent variables
);
```
madlib.linregr_train() 函数能够添加参数来设置分组的列以及计算模型的异方差性。

> 注释:截距通过将一个独立变量设置为常数1来计算，如前一个例子所示。

在表 regr_example 上执行该查询并创建带有一行数据的 regr\_example\_model 表：

```
SELECT * FROM regr_example_model;
-[ RECORD 1 ]------------+------------------------
coef                     | {0.111111111111127,1.14814814814815,1.01851851851852}
r2                       | 0.968612680477111
std_err                  | {1.49587911309236,0.207043331249903,0.346449758034495}
t_stats                  | {0.0742781352708591,5.54544858420156,2.93987366103776}
p_values                 | {0.952799748147436,0.113579771006374,0.208730790695278}
condition_no             | 22.650203241881
num_rows_processed       | 4
num_missing_rows_skipped | 0
variance_covariance      | {{2.23765432098598,-0.257201646090342,-0.437242798353582},
                            {-0.257201646090342,0.042866941015057,0.0342935528120456},
                            {-0.437242798353582,0.0342935528120457,0.12002743484216}}
```
被保存到 regr\_example\_model 表中的模型能够同 MADlib 线性回归预测函数使用， madlib.linregr_predict() 来查看残差：

```
SELECT regr_example.*, 
        madlib.linregr_predict ( ARRAY[1, x1, x2], m.coef ) as predict,
        y - madlib.linregr_predict ( ARRAY[1, x1, x2], m.coef ) as residual
FROM regr_example, regr_example_model m;
 id | y  | x1 | x2 |     predict      |      residual
----+----+----+----+------------------+--------------------
  1 |  5 |  2 |  3 | 5.46296296296297 | -0.462962962962971
  3 |  6 |  4 |  1 | 5.72222222222224 |  0.277777777777762
  2 | 10 |  7 |  2 | 10.1851851851852 | -0.185185185185201
  4 |  8 |  3 |  4 | 7.62962962962964 |  0.370370370370364
(4 rows)
```
### <h3 id='topic3_3'> 关联规则

这个例子说明了关联规则的数据挖掘技术在交易数据集。关联规则挖掘是发现大数据集中的变量之间关系的技术。这个例子将考虑那些在商店中通常一起购买的物品。除了购物篮分析，关联规则也应用在生物信息学中，网络分析，和其他领域。

这个例子分析利用 MADlib 函数 MADlib.assoc_rules 分析存储在表中的关于七个交易的购买信息。函数假定数据存储在两列中，每行有一个物品和交易 ID。多个物品的交易，包括多个行，每行一个物品。

这些命令创建表。

```
DROP TABLE IF EXISTS test_data;
CREATE TABLE test_data (
   trans_id INT,
   product text
);
```
该 INSERT 命令向表中添加数据。

```
INSERT INTO test_data VALUES 
   (1, 'beer'),
   (1, 'diapers'),
   (1, 'chips'),
   (2, 'beer'),
   (2, 'diapers'),
   (3, 'beer'),
   (3, 'diapers'),
   (4, 'beer'),
   (4, 'chips'),
   (5, 'beer'),
   (6, 'beer'),
   (6, 'diapers'),
   (6, 'chips'),
   (7, 'beer'),
   (7, 'diapers');
```
MADlib 函数 madlib.assoc_rules() 分析数据同时确定具有以下特征的关联规则。

*   一个值至少为 .40 的支持率。支持率表示包含 X 的交易与所有交易的比。
*   一个值至少为 .75 的置信率。置信率表示包含 X 的交易与包含Y的交易的比。可以将该度量看做给定 Y 下 X 的条件概率。

该 SELECT 命令确定关联规则，创建表 assoc_rules 同时天啊件统计信息到表中。

```
SELECT * FROM madlib.assoc_rules (
   .40,          -- support
   .75,          -- confidence
   'trans_id',   -- transaction column
   'product',    -- product purchased column
   'test_data',  -- table name
   'public',     -- schema name
   false);       -- display processing details
```
这是 SELECT 命令的输出。这有两条符合特征的规则。

```
 output_schema | output_table | total_rules | total_time 
------------------------------------------------------------------ 
public        | assoc_rules  |           2 | 00:00:01.153283 
(1 row)
```
为了查看关联规则，用户可以使用该 SELECT 命令。

```
SELECT pre, post, support FROM assoc_rules 
   ORDER BY support DESC;
```
这是输出。pre 和 post 列分别是关联规则左右两边的项集。

```
    pre    |  post  |      support
-----------+--------+-------------------
 {diapers} | {beer} | 0.714285714285714
 {chips}   | {beer} | 0.428571428571429
(2 rows)
```
基于数据，啤酒和尿布经常一起购买。为了增加销售额，用户可以考虑将啤酒和尿布放在一个架子上。

### <h3 id='topic3_3'> 朴素贝叶斯分类

朴素贝叶斯分析，基于一个或多个独立变量或属性，预测一类变量或类结果的可能性。类变量是非数值类型变量，一个变量可以有一个数量有限的值或类别。类变量表示的整数，每个整数表示一个类别。例如，如果类别可以是一个“真”、“假”，或“未知”的值，那么变量可以表示为整数 1, 2 或 3。

属性可以是数值类型、非数值类型以及类类型。训练函数有两个签名 \- 一个用于所有属性为数值 另外一个用于混合数值和类类型的情况。后者的附加参数标识那些应该被当做数字值处理的属性。属性以数组的形式提交给训练函数。

MADlib 朴素贝叶斯训练函数产生一个特征概率表和一个类的先验表，该表可以同预测函数使用为属性集提供一个类别的概率。

**朴素贝叶斯示例 1 - 简单的所有都是数值属性**

在第一个示例中，类别变量取值为 1 或者 2，同时这里有三个整型属性。

1.  下面的命令创建输入表以及加载样本数据。
    
    ```
    DROP TABLE IF EXISTS class_example CASCADE;
    CREATE TABLE class_example (
       id int, class int, attributes int[]);
    INSERT INTO class_example VALUES
       (1, 1, '{1, 2, 3}'),
       (2, 1, '{1, 4, 3}'),
       (3, 2, '{0, 2, 2}'),
       (4, 1, '{1, 2, 1}'),
       (5, 2, '{1, 2, 2}'),
       (6, 2, '{0, 1, 3}');
    ```
    在生产环境中的实际数据比该示例中的数据量更大，也能获得更好的结果。更大的训练数据集能够显著地提高分类的精确度。
    
2.  使用 create\_nb\_prepared\_data\_tables() 函数训练模型。
    
    ```
    SELECT * FROM madlib.create_nb_prepared_data_tables (
       'class_example',         -- name of the training table 
       'class',                 -- name of the class (dependent) column
       'attributes',            -- name of the attributes column
       3,                       -- the number of attributes
       'example_feature_probs', -- name for the feature probabilities output table
       'example_priors'         -- name for the class priors output table
        );
    ```
3.  为了使用模型进行分类，创建带有数据的表。
    
    ```
    DROP TABLE IF EXISTS class_example_topredict;
    CREATE TABLE class_example_topredict ( 
       id int, attributes int[]);
    INSERT INTO class_example_topredict VALUES 
       (1, '{1, 3, 2}'),
       (2, '{4, 2, 2}'),
       (3, '{2, 1, 1}');
    ```
4.  用特征概率、类的先验和 class\_example\_topredict 表创建一个分类视图。
    
    ```
    SELECT madlib.create_nb_probs_view (
       'example_feature_probs',    -- 特征概率输出表
       'example_priors',           -- 先验输出表
       'class_example_topredict',  -- 带有要分类数据的表
       'id',                       -- 关键字的列名
       'attributes',               -- 属性列的名称
        3,                         -- 属性的数目
        'example_classified'       -- 要创建的视图的名称
        );
    ```
5.  显示分类结果。
    
    ```
    SELECT * FROM example_classified;
     key | class | nb_prob
    -----+-------+---------
       1 |     1 |     0.4
       1 |     2 |     0.6
       3 |     1 |     0.5
       3 |     2 |     0.5
       2 |     1 |    0.25
       2 |     2 |    0.75
    (6 rows)
    ```

**朴素贝叶斯示例 2 – 天气和户外运动**

该示例计算在给定的天气条件下，用户要进行户外运动，例如高尔夫、网球等的概率。

表 weather_example 包含了样本值。

表的标识列是 day，整型类型。

play 列包含了因变量以及两个类别：

*   0 - No
*   1 - Yes

有四个属性：outlook、temperature、humidity、以及 wind。他们是类变量。 MADlib create\_nb\_classify_view() 函数希望属性提供的是 INTEGER、NUMERIC、 或者 FLOAT8 值类型的数组，所以该示例的属性均用为整型进行编码：

*   _outlook_ 可能取值为 sunny (1), overcast (2), or rain (3)。
*   _temperature_ 可能取值为 hot (1), mild (2), or cool (3).
*   _humidity_ 可能取值为 high (1) or normal (2).
*   _wind_ 可能取值为 strong (1) or weak (2).

下面的表显示了编码钱的训练数据。

```
  day | play | outlook  | temperature | humidity | wind
-----+------+----------+-------------+----------+--------
 2   | No   | Sunny    | Hot         | High     | Strong
 4   | Yes  | Rain     | Mild        | High     | Weak
 6   | No   | Rain     | Cool        | Normal   | Strong
 8   | No   | Sunny    | Mild        | High     | Weak
10   | Yes  | Rain     | Mild        | Normal   | Weak
12   | Yes  | Overcast | Mild        | High     | Strong
14   | No   | Rain     | Mild        | High     | Strong
 1   | No   | Sunny    | Hot         | High     | Weak
 3   | Yes  | Overcast | Hot         | High     | Weak
 5   | Yes  | Rain     | Cool        | Normal   | Weak
 7   | Yes  | Overcast | Cool        | Normal   | Strong
 9   | Yes  | Sunny    | Cool        | Normal   | Weak
11   | Yes  | Sunny    | Mild        | Normal   | Strong
13   | Yes  | Overcast | Hot         | Normal   | Weak
(14 rows)
```
1.  创建一个训练表。
    
    ```
    DROP TABLE IF EXISTS weather_example;
    CREATE TABLE weather_example (
       day int,
       play int,
       attrs int[]
    );
    INSERT INTO weather_example VALUES
       ( 2, 0, '{1,1,1,1}'), -- sunny, hot, high, strong
       ( 4, 1, '{3,2,1,2}'), -- rain, mild, high, weak
       ( 6, 0, '{3,3,2,1}'), -- rain, cool, normal, strong
       ( 8, 0, '{1,2,1,2}'), -- sunny, mild, high, weak
       (10, 1, '{3,2,2,2}'), -- rain, mild, normal, weak
       (12, 1, '{2,2,1,1}'), -- 等
       (14, 0, '{3,2,1,1}'),
       ( 1, 0, '{1,1,1,2}'),
       ( 3, 1, '{2,1,1,2}'),
       ( 5, 1, '{3,3,2,2}'),
       ( 7, 1, '{2,3,2,1}'),
       ( 9, 1, '{1,3,2,2}'),
       (11, 1, '{1,2,2,1}'),
       (13, 1, '{2,1,2,2}');
    ```
2.  根据训练表创建模型。
    
    ```
    SELECT madlib.create_nb_prepared_data\_tables (
       'weather_example',  -- 训练源数据
       'play',             -- 因变类别列
       'attrs',            -- 属性列
       4,                  -- 属性数目
       'weather_probs',    -- 特征概率输出表
       'weather_priors'    -- 类别先验
       );
    ```
3.  查看特征概率：
    
    ```
    SELECT * FROM weather_probs;
     class | attr | value | cnt | attr_cnt
    -------+------+-------+-----+----------
         1 |    3 |     2 |   6 |        2
         1 |    1 |     2 |   4 |        3
         0 |    1 |     1 |   3 |        3
         0 |    1 |     3 |   2 |        3
         0 |    3 |     1 |   4 |        2
         1 |    4 |     1 |   3 |        2
         1 |    2 |     3 |   3 |        3
         1 |    2 |     1 |   2 |        3
         0 |    2 |     2 |   2 |        3
         0 |    4 |     2 |   2 |        2
         0 |    3 |     2 |   1 |        2
         0 |    1 |     2 |   0 |        3
         1 |    1 |     1 |   2 |        3
         1 |    1 |     3 |   3 |        3
         1 |    3 |     1 |   3 |        2
         0 |    4 |     1 |   3 |        2
         0 |    2 |     3 |   1 |        3
         0 |    2 |     1 |   2 |        3
         1 |    2 |     2 |   4 |        3
         1 |    4 |     2 |   6 |        2
    (20 rows)
    ```
4.  用模型分类一组记录，首先装载数据到一个表中。在该示例中，表 t1 有四个行将要分类。
    
    ```
    DROP TABLE IF EXISTS t1;
    CREATE TABLE t1 (
       id integer,
       attributes integer[]);
    insert into t1 values 
       (1, '{1, 2, 1, 1}'),
       (2, '{3, 3, 2, 1}'),
       (3, '{2, 1, 2, 2}'),
       (4, '{3, 1, 1, 2}');
    ```
5.  使用 create\_nb\_classify_view() 函数对表中的行进行分类。
    
    ```
    SELECT madlib.create_nb_classify_view (
       'weather_probs',      -- 特征概率表
       'weather_priors',     -- 类先验名
       't1',                 -- 包含要分类值的表
       'id',                 -- 主键列
       'attributes',         -- 属性列
       4,                    -- 属性数目
       't1_out'              -- 输出表的名称
    );
    ```
    结果有四行，每行对应表 t1 中的一条记录。
    
    ```
    SELECT * FROM t1_out ORDER BY key;
     key | nb_classification
    -----+-------------------
     1 | {0}
     2 | {1}
     3 | {1}
     4 | {0}
     (4 rows)
    ```

## <h2 id='topic3'> 参考

MADlib 网站在 [http://madlib.incubator.apache.org/](http://madlib.incubator.apache.org/).

MADlib 文档在 [http://madlib.incubator.apache.org/documentation.html](http://madlib.incubator.apache.org/documentation.html).

PivotalR 是第一类能够让用户使用R客户端对 HashData 驻留的数据和 MADLib 进行交互的R包。

### <h3 id='topic3_1'> 关于 MADlib、R、PivotalR

R 语言是一门用于统计计算的开源编程语言。PivotalR 是一个能够让用户通过 R 客户端与常驻 HashData 数据库的数据进行交互的R语言包。使用 PivotalR 要求 MADlib 已经安装在了 HashData 数据库中。

PivotalR 允许 R 用户不用离开R命令行就能利用数据库内分析的可扩展性和性能。计算工作在数据库内执行，而终端用户受益于熟悉的R语言接口。与相应的原生 R 函数相比，在可扩展性上得到提同时在执行时间上有降低。此外，PivotalR 消除了对于非常大的数据集需要花费几个小时完成的数据移动。

PivotalR 包的关键特征：

*   以R语法的方式探索和操作数据库内的数据。SQL 翻译由 PivotalR 来执行。
*   使用熟悉的 R 语法的预测分析算法，例如线性和逻辑回归。 PivotalR 访问 MADlib 数据库内分析函数调用。
*   对于广泛关于以标准 R 格式的示例文档包能够通过 R 客户端来访问。
*   PivotalR 包也支持 MADlib 功能的访问。

更多关于 PivotalR 的信息包括支持的 MADlib 功能的信息，见 [https://cwiki.apache.org/confluence/display/MADLIB/PivotalR](https://cwiki.apache.org/confluence/display/MADLIB/PivotalR)。

PivotalR 的 R 语言包可以在[https://cran.r-project.org/web/packages/PivotalR/index.html](https://cran.r-project.org/web/packages/PivotalR/index.html)找到。