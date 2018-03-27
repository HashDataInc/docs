# CREATE OPERATOR CLASS

# 创建操作符类

定义一个新的操作符类。

## 概要

```
CREATE OPERATOR CLASS name [DEFAULT] FOR TYPE data_type  
  USING index_method AS 
  { 
  OPERATOR strategy_number op_name [(op_type, op_type)] [RECHECK]
  | FUNCTION support_number funcname (argument_type [, ...] )
  | STORAGE storage_type
  } [, ... ]
```

## 描述

CREATE OPERATOR CLASS 创建一个新的操作符类。操作符类定义了能和索引一起使用的特殊的数据类型。该操作符类指定了某些操作符将填充此数据类型和索引方法的特定角色和策略。当操作符类被选定给索引列时，操作符类也指定索引方法所使用的支持的程序。操作符类所使用的所有操作符和函数必须在操作符创建之前就进行定义。用于实现操作符类的所有函数必须被定义为 IMMUTABLE（不可改变的）。

CREATE OPERATOR CLASS 目前不检查操作符类定义是否包括索引方法所需要的所有的操作符和函数。也不检查是否操作符和函数形成自我一致的集合。定义有效的操作符类是用户的责任。

用户必须是超级用户才能创建操作符类。

## 参数

name

要定义的操作符类的（可选方案限定）的名称。同一模式中的两个操作符只有在不同索引方法时才具有相同的名称。

DEFAULT

为其数据类型制定默认的操作符类。对于一个特定类型的数据类型和索引方法，最多可以指定一个默认操作符类。

data\_type

该操作符类对应的列数据类型。

index\_method

该操作符类所对应的索引方法的名称。索引方法有 btree, bitmap, 和 gist。

strategy\_number

与操作符类相关联的操作符由 _strategy numbers_ 来标识，用于在操作符类的上下文中识别每个操作符的语义。例如，B 树对关键字施加了严格的排序，从小到大，因此 _小于_ 和 _大于或者等于_ 的操作符对于 B 树来说是有趣的。这些策略可以被认为是广义的操作符，每个操作符针对特定数据类型指定与每个策略相符的实际操作符和索引语义的解释。每个指标的相应策略编号如下：

##### 表 1. B-tree 和 Bitmap 策略

| Operation | Strategy Number |
| :--- | :--- |
| less than | 1 |
| less than or equal | 2 |
| equal | 3 |
| greater than or equal | 4 |
| greater than | 5 |

##### 表 2. GiST 二维策略（R-Tree）

| Operation | Strategy Number |
| :--- | :--- |
| strictly left of | 1 |
| does not extend to right of | 2 |
| overlaps | 3 |
| does not extend to left of | 4 |
| strictly right of | 5 |
| same | 6 |
| contains | 7 |
| contained by | 8 |
| does not extend above | 9 |
| strictly below | 10 |
| strictly above | 11 |
| does not extend below | 12 |

operator\\_name

和操作符类相关的操作符的（可选方案限定）名称。

op\\_type

操作符的操作数数据类型， 或 NONE 表示左一元或右一元操作符。该操作数数据类型一般情况下，在与操作符数据类型相同的情况下，可以省略操作数数据类型。

RECHECK

如果存在的话，则该索引对该操作符是“有损的”，因此必须重新检查使用索引检索过的行，以验证他们实际上满足涉及该操作符的限定子句。

support\\_number

索引方法需要额外的支持例程才能工作。这些操作是索引方法在内部使用的管理例程。与策略一样，该操作符类指定了哪些特定的函数应该为给定的数据类型和语义解释去使用这些角色。索引方法定义了所需的函数集合，操作符通过将他们分配_支持函数号_ 来识别需要的正确的函数。如下所示：

##### 表 3. B-tree 和 Bitmap 支持函数

| Function | Support Number |
| :--- | :--- |
| Compare two keys and return an integer less than zero, zero, or greater than zero, indicating whether the first key is less than, equal to, or greater than the second. | 1 |

##### 表 4. GiST 支持函数

| Function | Support Number |
| :--- | :--- |
| consistent - determine whether key satisfies the query qualifier. | 1 |
| union - compute union of a set of keys. | 2 |
| compress - compute a compressed representation of a key or value to be indexed. | 3 |
| decompress - compute a decompressed representation of a compressed key. | 4 |
| penalty - compute penalty for inserting new key into subtree with given subtree's key. | 5 |
| picksplit - determine which entries of a page are to be moved to the new page and compute the union keys for resulting pages. | 6 |
| equal - compare two keys and return true if they are equal. | 7 |

## 注意

因为索引机制在使用函数之前不检查它们的访问权限，包括在操作符类中的函数和操作符与授予它的公共执行权限相同。这对于在操作符类中有用的各种函数通常不是问题。

操作符不应该由 SQL 函数定义。调用查询中可能会嵌入 SQL 函数，这会阻止优化程序识别出查询与索引匹配。

用于实现操作符类的任何函数必须定义为 IMMUTABLE。

## 例子

接下来的例子命令定义了数据类型 int4（int4 的数组）的 GiST 索引操作符类：

```
CREATE OPERATOR CLASS gist__int_ops
    DEFAULT FOR TYPE _int4 USING gist AS
        OPERATOR 3 &&,
        OPERATOR 6 = RECHECK,
        OPERATOR 7 @>,
        OPERATOR 8 <@,
        OPERATOR 20 @@ (_int4, query_int),
        FUNCTION 1 g_int_consistent (internal, _int4, int4),
        FUNCTION 2 g_int_union (bytea, internal),
        FUNCTION 3 g_int_compress (internal),
        FUNCTION 4 g_int_decompress (internal),
        FUNCTION 5 g_int_penalty (internal, internal, internal),
        FUNCTION 6 g_int_picksplit (internal, internal),
        FUNCTION 7 g_int_same (_int4, _int4, internal);
```

## 兼容性

CREATE OPERATOR CLASS 是 HashData 数据库扩展。 在 SQL 标准中没有 CREATE OPERATOR CLASS 语句。

## 另见

[ALTER OPERATOR CLASS](./alter-operator-class.md), [DROP OPERATOR CLASS](./drop-operator-class.md), [CREATE FUNCTION](./create-function.md)

**上级话题：** [SQL命令参考](./README.md)

