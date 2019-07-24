### 与Oracle语法上的差异
在这一章节中，我们简单比较一下，HashData 在语法层面与 Oracle 的差异。

#### 数据类型

**字符类型**

Oracle | HashData  | 备注
:-: | :-: | :-:
char(n) |  char(n)| 字节为单位，定长，不足用空格填充
nchar(n) | char(n) | 字符为单位，定长，不足用空格填充
varchar2(n) | varchar(n) | 字节为单位，变长，有长度限制
nvarchar2(n) | varchar(n) | 字符为单位，变长，有长度限制
string| text | 字符为单位，变长，没有长度限制

一般情况下，对于 Oracle 的 char 和 nchar 类型，直接换成 HashData 的 char 是没有问题的；而对于变长的 varchar2 和 nvarchar2，想图省事的话，直接换成 HashData 的 TEXT 就可以。

**数值类型**

Oracle | HashData  | 备注
:-: | :-: | :-:
SMALLINT | SMALLINT | 2个字节
INTEGER | INTEGER | 4个字节
BIGINT | BIGINT | 8个字节
BINARY_FLOAT | DOUBLE PRECISION | 8个字节，15位精度
BINARY_DOUBLE | DOUBLE PRECISION | 8个字节，15位精度
FLOAT | DOUBLE PRECISION | 8个字节，15位精度
DOUBLE PRECISION | DOUBLE PRECISION | 8个字节，15位精度
REAL | REAL | 4个字节，6位精度
DECIMAL | DECIMAL | 没有精度限制
NUMBER | NUMERIC | 没有精度限制

Oracle 的数值类型向 HashData 的数值类型迁移过程中，只要根据 Oracle 数据的精度，在 HashData 中选择相同或者更大精度的类型，数据就能够顺利地迁移过来。但是为了转换过来后数据库的效率（特别是整数类型的时候），需要选择合适的数据类型，才能够完整、正确并且高效地完成 Oracle 数据类型向 HashData 数据类型的迁移。

**时间类型**

Oracle | HashData  | 备注
:-: | :-: | :-:
Date | Timestamp(0) without time zone | 包含年，月，日，时，分和秒6个字段
 | Date | 只包含年，月和日3个字段
Timestamp | Timestamp without time zone | 包含年，月，日，时，分，秒和毫秒
Timestamp with time zone | Timestamp with time zone | 带时区的时间戳
Timestamp with local time zone | Timestamp with time zone | 带时区的时间戳
Interval | Interval | 时间间隔

Oracle 的日期时间类型向 HashData 的数据迁移相对来说简单一些。由于 HashData 的数据类型的极值超越 Oracle，因此，数据迁移过程中，只要根据 Oracle 的数据精度，在 HashData 中选择正确的数据类型，并留意一下二者写法的不同，应该就能够完整正确地迁移过来。

**大对象**

Oracle | HashData  | 备注
:-: | :-: | :-:
BLOB | BYTEA | 字节
CLOB | TEXT | 字符

**其他类型**

Oracle | HashData  | 备注
:-: | :-: | :-:
RAW | BYTEA | 
RAWID | OID | 

#### 常用函数

**字符串操作函数**

Oracle | HashData  | 备注
:-: | :-: | :-:
 \|\| | \|\| | 字符串连接符|
concat | \|\| | 字符串连接函数|
to_number | to_number | 将字符串转换成数值
to_char | ::TEXT | 类型转换
to_date | to_timestamp | 将字符串转化为时间戳
last_date | (date_trun('MONTH', mydate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')::DATE | 当月的最后一天
instr | position | 在一个字符串中，查找另外一个字符串出现的位置
substr | substr | 截取字符串的一部分
length | length | 获取字符串的长度
trim | trim | 出去字符串开始和结束的指定字符
initcap | initcap | 首字母大写
upper | upper | 转大写
lower | lower | 转小写
regexp_replace | regexp_replace | 正则表达式替换
regexp_substr | substring | 根据正则表达式寻找子串
regexp_instr | position(substring) | 在一个字符串中查找符合正则表达式的字符串的位置
regexp_like | length(substring) | 判断是否有满足条件的子串

**数值函数**

Oracle | HashData  | 备注
:-: | :-: | :-:
BITAND | & | 对数值按位进行 与 运算
REMAINDER | % | 取模
abs | abs | 取绝对值

**日期函数**

Oracle | HashData  | 备注
:-: | :-: | :-:
SYSDATE | CURRENT_DATE | 当前日期
CURRENT_TIMESTAMP | CURRENT_TIMESTAMP/NOW() | 当前时间戳
ADD_MONTHS | DATE + INTERVAL | 将日期往期推
EXTRACT | EXTRACT | 从日期和时间戳中取出年，月，日等

**其他函数**

decode 是 Oracle 固有的一个函数，用于条件判断。其格式为：

	decode(条件，值1，返回值1，值2，返回值2，...，值n，返回值n，缺省值)
	
当条件等于值 1 的时候返回返回值 1，等于值 n 的时候返回返回值 n，都不等于的时候返回缺省值。

在 HashData 中，decode 函数是用来解码的，和 encode 函数相对。对于 Oracle 的 decode 函数，可以把它转换成 case when 的 SQL 语句，得到一样的效果。另外，Oracle 也支持 case when 的语法，用法和 HashData 一样。

	-- Oracle
	select decode(y.studentcode, null, '0', '1') studenttype from y;
	
	-- HashData 
	select case when y.studentcode is null then '0' else '1' end studenttype from y;


#### 存储过程

**最简单的存储过程**

Oracle

	CREATE OR REPLACE PROCEDURE procedure_name
	AS
	BEGIN
		-- comments
		NULL;
	END;

HashData 

	CREATE OR REPLACE FUNCTION function_name() RETURNS VOID AS
	$$
	BEGIN
		-- comments
		NULL;
	END;
	$$ LANGUAGE PLPGSQL;

**带输入输出参数的存储过程**

Oracle

	CREATE OR REPLACE PROCEDURE sum_n_product(x IN INTEGER, y IN INTEGER, sum OUT INTEGER, prod OUT INTEGER)
	AS
	BEGIN
		sum := x + y;
		prod := x * y;
	END;

HashData 

	CREATE OR REPLACE FUNCTION sum_n_product(x INTEGER, y INTEGER, OUT sum INTEGER, OUT prod INTEGER) AS
	$$
	BEGIN
		sum := x + y;
		prod := x * y;
	END;
	$$ LANGUAGE PLPGSQL;

**SELECT INTO**

Oracle

	CREATE OR REPLACE PROCEDURE find_record(key IN INTEGER, value OUT INTEGER)
	AS
	BEGIN
		SELECT val INTO value FROM mytable WHERE id = key;
	END;

HashData 

	CREATE OR REPLACE FUNCTION find_record(key INTEGER, OUT value INTEGER) AS
	$$
	BEGIN
		SELECT val INTO value FROM mytable WHERE id = key;
	END;
	$$ LANGUAGE PLPGSQL;

**带条件判断的存储过程**

Oracle

	CREATE OR REPLACE PROCEDURE fib(num IN INTEGER, result OUT INTEGER)
	AS
	BEGIN
		IF NUM <= 0 THEN
			result := 0;
		ELSEIF num = 1 THEN
			result := 1;
		ELSE
			result := fib (num - 1) + fib (num - 2);
		END IF;
	END;

HashData 

	CREATE OR REPLACE FUNCTION fib(INTEGER) RETURNS INTEGER AS
	$$
	DECLARE
		result INTEGER := 0;
		num ALIAS FOR $1;
	BEGIN
		IF num = 1 THEN
			result := 1;
		ELSEIF num > 1 THEN
			result := fib(num - 1) + fib(num - 2);
		END IF;
		RETURN result;
	END;
	$$ LANGUAGE PLPGSQL;

**动态执行**

Oracle 和 HashData 基本是一样的：

	EXECUTE 'DELETE FROM mytable WHERE id = key';

**执行没有返回值的查询**

Oracle 和 HashData 基本也是一样的：

	UPDATE mytable SET val = val + delta WHERE id = key;
	INSERT INTO mytable VALUES(key, value);
	TRUNCATE TABLE mytable;
	DELETE FROM mytable WHERE id = key;

**LOOP循环**

简单的 LOOP 循环

`EXIT`

	LOOP
		-- some computations
		IF count > 0 THEN
			EXIT; -- exit loop
		END IF;
	END LOOP;
	
	LOOP
		-- some computations
		EXIT WHEN count > 0; -- same result as previous example
	END LOOP;
	
	BEGIN
		-- some computations
		IF stocks > 10000 THEN
			EXIT; -- cause exit from the BEGIN block
		END IF;
	END;

`CONTINUE`

	LOOP
		-- some computations
		EXIT WHEN count > 100;
		CONTINUE WHEN count < 50;
		-- some computations for count IN [50 ... 100]	END LOOP;

`WHILE`

	WHILE amount_owed > 0 AND gift_certificate_balance > 0 LOOP
		-- some computations here
	END LOOP;
	
	WHILE NOT boolean_expression LOOP
	-- some computations here
	END LOOP;

`FOR (integer variant)`

	FOR i IN 1..10 LOOP
		-- some computations here
		RAISE NOTICE 'i is %', i;
	END LOOP;
	
	FOR i IN REVERSE 10..1 LOOP
		-- some computations here
	END LOOP;
	
	FOR i IN REVERSE 10..1 BY 2 LOOP
		-- some computations here
		RAISE NOTICE 'i is %', i;
	END LOOP;

**返回结果集的 LOOP**

	CREATE OR REPLACE FUNCTION cs_refresh_mviews() RETURNS INTEGER AS $$
	DECLARE
		mviews RECORD;
	BEGIN
		FOR mviews IN SELECT * FROM cs_materialized_views ORDER BY sort_key LOOP
			EXECUTE 'TRUNCATE TABLE ' || quote_ident(mviews.mv_name);
			EXECUTE 'INSERT INTO ' || quote_ident(mviews.mv_name) || ' ' || mviews.mv_query;
		END LOOP;
		RETURN 1;
	END;
	$$ LANGUAGE PLPGSQL;


#### 游标


在 HashData 中，我们一般很少使用游标，因为当我们使用 **FOR LOOP** 的时候，数据库后台自动就会转化成游标。不过，这里我们还是可以简单介绍一下HashData 中游标的使用。

**游标的声明**

	DECLARE
		curs1 refcursor;
		curs2 CURSOR FOR SELECT * FROM tenk1;
		curs3 CURSOR (key INTEGER) IS SELECT * FROM tenk1 WHERE unique1 = key;
		
第一个游标 curs1 是一个通用游标，没有绑定具体的查询；第二个游标 curs2 绑定了具体的查询；第三个游标 curs3 也是一个绑定游标，而且是一个带参数的游标。

**打开没有绑定查询的游标**

普通查询

	OPEN curs1 FOR SELECT * FROM foo WHERE key = mykey;

动态查询

	OPEN curs1 FOR EXECUTE 'SELECT * FROM ' || quote_ident($1);

**打开已经绑定查询的游标**

	OPEN curs2;
	OPEN curs3(42);

**使用游标**

	FETCH curs1 INTO rowvar;
	FETCH curs2 INTO foo, bar, baz;

**关闭游标**

	CLOSE curs1;