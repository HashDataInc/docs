# PL/Python 语言扩展

本节包含 HashData 数据库的 PL/Python 语言的概述。

* [关于 HashData 的 PL/Python ](#topic2_1) 
* [启用和删除 PL/Python 的支持](#topic2_2)
* [使用 PL/Python 开发函数](#topic2_3)
* [安装 Python 模块](#topic2_4)
* [示例](#topic2_5)
* [参考](#topic2_6)

**上一个话题:** [HashData 数据库参考指南](./README.md)

## <h2 id='topic2_1'> 关于 HashData 的 PL/Python

PL/Python 是一种可加载的程序语言。使用 HashData 数据库的 PL/Python 扩展，用户可以在  Python 中编写一个 HashData 数据库用户定义的函数，利用 Python 功能和模块的优势可以快速构建强大的数据库应用程序。

用户可以将 PL/Python 代码块作为匿名代码块运行。见 HashData 数据库参考指南中的 [DO](./0710-sql-command-ref/do.md) 命令。

HashData 数据库的 PL/Python 扩展默认安装在 HashData 数据库中。HashData 数据库安装了一个 Python 和 PL/Python 版本。这是 HashData 数据库使用的 Python 的安装位置。

```
$GPHOME/ext/Python/
```

### HashData 数据库的 PL/Python 的限制

* HashData 数据库不支持 PL/Python 触发器。
* PL/Python 仅作为 HashData 数据库不可信的语言使用。
* 不支持可更新的游标 \(UPDATE...WHERE CURRENT OF and DELETE...WHERE CURRENT OF\)。

## <h2 id='topic2_2'> 启用和删除 PL/Python 支持

PL/Python 语言与 HashData 数据库一起安装。为了在数据库中创建和运行 PL/Python 用户定义的函数（ UDF ）,用户必须使用数据库注册 PL/Python 语言。

### 启用 PL/Python 支持

对于每个需要使用的数据库，请使用 SQL 命令 CREATE LANGUAGE 或 HashData 数据库功能 createlang 注册 PL/Python 语言。因为 PL/Python 是不可信的语言，只有超级用户可以使用数据库注册 PL/Python。例如，作为 gpadmin 系统用户使用名为 testdb 的数据库注册 PL/Python 时运行以下命令:

```
$ createlang pl Python u -d testdb
```
 PL/Python 被注册了成一种不可信语言。

### 删除 PL/Python 支持

对于一个不再需要 PL/Python 语言支持的数据库来说, 可以使用 SQL 命令 DROP LANGUAGE 或者  HashData 数据库 droplang 功能删除对 PL/Python  的支持。 因为 PL/Python  是一种不可信语言, 只有超级用户能够从数据库中删除对 PL/Python  语言的支持。例如，作为 gpadmin 系统用户使用名为testdb的数据库删除对 PL/Python  语言的支持时运行以下命令:

```
$ droplang plPython u -d testdb
```

当用户删除对 PL/Python  语言的支持时, 用户在数据库中创建的 PL/Python  用户自定义函数将不再有效。

## <h2 id='topic2_3'> 使用 PL/Python  开发函数

PL/Python   用户定义函数的主体是  Python  脚本。 当函数被调用时，其参数被作为数组 args\[\] 的元素传递。命名参数也作为普通变量传递给  Python  脚本。 结果是通过 PL/Python  函数中的 return 语句返回的, 或者是通过 yield 语句返回结果集。

### 数组和列表

用户将 SQL 列表的值传递给具有  Python  列表的 PL/Python  函数。同样的, PL/Python  函数将 SQL 数组值作为  Python  列表返回。 在典型的 PL/Python  使用模式中, 用户将使用 \[\] 来指定数组。

以下的列子创建了一个 PL/Python  函数并返回整数数组:

```
CREATE FUNCTION return_py_int_array()
  RETURNS int[]
AS $$
  return [1, 11, 21, 31]
$$ LANGUAGE pl Python u;

SELECT return_py_int_array();
 return_py_int_array 
---------------------
 {1,11,21,31}
(1 row)
```

PL/Python  将多维数组视为列表的列表。用户使用嵌套的 Python 列表将多维数组传递给 PL/Python  函数。当 PL/Python  函数返回多维数组时, 每个级别的内部列表必须具有相同的大小。

接下来的示例创建了一个 PL/Python  函数，该函数以多维整数数组作为输入。该函数显示所提供参数的类型，并返回该多维数组:

```
CREATE FUNCTION return_multidim_py_array(x int4[]) 
  RETURNS int4[]
AS $$
  plpy.info(x, type(x))
  return x
$$ LANGUAGE pl Python u;

SELECT * FROM return_multidim_py_array(ARRAY[[1,2,3], [4,5,6]]);
INFO:  ([[1, 2, 3], [4, 5, 6]], <type 'list'>)
CONTEXT:  PL/Python  function "return_multidim_py_type"
 return_multidim_py_array 
--------------------------
 {{1,2,3},{4,5,6}}
(1 row)
```

PL/Python   还接受其他  Python  序列,列如元组,作为与不支持多维数组的 HashData 版本向后兼容的函数参数。在这种情况下， Python  序列总是被作为一维数组对待，因为它们与复合类型不一致。

### 复合类型

用户可以使用  Python  映射传送一个复合类型的参数给 PL/Python  函数。映射的元素名称是复合类型的属性名称。如果属性有空值，则其映射为 None。

用户可以将复合类型结果作为序列类型（列表或者元组）返回。在多维数组的使用中时，用户必须将复合类型指定为元组，而不是列表。用户不能将复合类型数组作为列表返回，因为确定列表是否表示复合类型或另一个数组维度是不明确的。在典型的使用模式中，用户将使用 \(\) 指定复合类型元组。

在接下来的列子中, 用户可以创建一个复合类型和一个返回复合类型数组的 PL/Python  函数:

```
CREATE TYPE type_record AS (
  first text,
  second int4
);

CREATE FUNCTION composite_type_as_list()
  RETURNS type_record[]
AS $$              
  return [[('first', 1), ('second', 1)], [('first', 2), ('second', 2)], [('first', 3), ('second', 3)]];
$$ LANGUAGE pl Python u;

SELECT * FROM composite_type_as_list();
                               composite_type_as_list                           
------------------------------------------------------------------------------------
 {{"(first,1)","(second,1)"},{"(first,2)","(second,2)"},{"(first,3)","(second,3)"}}
(1 row)
```

参考 PostgreSQL 中的 [Arrays, Lists](https://www.postgresql.org) 文档寻求关于 PL/Python 处理数组和复合类型的附加信息。

### 执行和准别 SQL 查询

PL/Python  中的plpy 模块提供了两个  Python  函数去为一个查询语句执行 SQL 查询和准备执行计划, plpy.execute and plpy.prepare。 准备查询的执行计划是有用的，如果用户从多个  Python  函数中运行查询。

#### plpy.execute

使用查询字符串和可选的限制参数调用 plpy.execute 会导致运行查询，并且在  Python  结果对象中返回结果。结果对象模拟列表或字典对象。可以通过行号和列名访问结果对象中返回的行。结果集行号从 0 开始。结果对象可以修改。结果对象有这些附加的方法：

* nrows 返回查询返回的函数
* status 是 SPI\_execute\(\) 返回的值

例如，这个 PL/Python  用户自定义函数中的  Python  语句执行了一个查询：

```
rv = plpy.execute("SELECT * FROM my_table", 5)
```

这个 plpy.execute 函数从 my\_table 中返回最多 5 行。 结果集储存在 the rv 对象中。 如果 my\_table 有一列 my\_column， 那它可以通过如下访问：

```
my_col_data = rv[i]["my_column"]
```

由于这个函数做多返回 5 行, 下标 i 是 0-4 之间的整数。

#### plpy.prepare

函数 plpy.prepare 为查询准备了执行计划。 如果查询中有参数引用，则用查询字符串和参数类型列表调用该函数。例如，该语句可以在 PL/Python  用户自定义的函数中：

```
plan = plpy.prepare("SELECT last_name FROM my_users WHERE 
  first_name = $1", [ "text" ])
```

字符串 text 是变量 `$1` 传递的数据类型。 在准备好语句之后, 用户可以使用函数 plpy.execute 去运行它:

```
rv = plpy.execute(plan, [ "Fred" ], 5)
```

第三个参数就是可选的返回结果的行数限制。

当用户使用使用 PL/Python  模块准备一个执行计划的时候，该计划是自动保存的。更多执行计划的信息请参见 Postgres 服务器编程接口 \(SPI\) 文档 [https://www.postgresql.org/docs/8.3/static/spi.html](https://www.postgresql.org/docs/8.3/static/spi.html)。

为了在函数调用中有效的使用保存的计划，用户可以使用一个  Python  持久存储字典 SD 或 GD。

全局字典 SD 可用于在函数调用之间存储数据。该变量是私有静态变量。全局字典 GD 是公共数据，可用于会话内的所有  Python  函数。小心使用 GD。

每个函数在  Python  解释器中都有自己的执行环境，所以 myfunc 的全局数据和函数参数对 myfunc2 不可见。 除非该数据在 GD 字典中, 正如前所述。

使用 SD 字典的例子:

```
CREATE FUNCTION usesavedplan() RETURNS trigger AS $$
  if SD.has_key("plan"):
    plan = SD["plan"]
  else:
    plan = plpy.prepare("SELECT 1")
    SD["plan"] = plan

  # rest of function

$$ LANGUAGE pl Python u;
```

### 处理  Python  错误和消息

Python  模块 plpy 实现了这个函数来管理错误和消息：

* plpy.debug
* plpy.log
* plpy.info
* plpy.notice
* plpy.warning
* plpy.error
* plpy.fatal
* plpy.debug

消息函数 plpy.error and plpy.fatal 抛出一个 Python 异常，该异常如果没有被捕获, 则会被传播到调用查询, 导致当前事务和子事务终止。 该函数 raise plpy.ERROR\(msg\) 和 raise plpy.FATAL\(msg\) 分别等效于调用 plpy.error 和 plpy.fatal。 其他消息函数仅仅生成不同优先级的消息。

是否向客户端报告特定优先级的消息，写入服务器日志或两者都由 HashData 数据库服务器配置参数log\_min\_messages 和 client\_min\_messages 控制。有关参数的信息，请参阅  HashData 数据库参考指南。

### 使用字典 GD 提升 PL/Python  性能

在性能方面，导入  Python  模块操作代价高昂，而且影响性能。如果用户频繁导入相同的模块，用户可以使用  Python  全局变量在第一次调用的时候加载该模块而不需要在子调用中导入该模块。接下来的 PL/Python  函数使用 GD 持久存储字典从而避免导入已经导入过的且在 GD 中的模块。

```
psql=#
   CREATE FUNCTION pytest() returns text as $$ 
      if 'mymodule' not in GD:
        import mymodule
        GD['mymodule'] = mymodule
    return GD['mymodule'].sumd([1,2,3])
$$;
```

## <h2 id='topic2_4'> 安装  Python  模块

当用户在  HashData 数据库中安装  Python  模块的时候， HashData 数据库  Python  环境必须将该模块添加到集群中所有的段主机和镜像主机上。当扩展  HashData 数据库时，用户必须添加该  Python  模块到新的段主机中。用户可以使用  HashData 数据库实用程序 gpssh 和 gpscp 在  HashData 数据库主机上运行命令并将文件复制到主机。 更多关于实用程序的信息，请参阅  HashData 数据库实用程序指南 。

作为  HashData 数据库安装的一个部分， gpadmin 用户环境配置为使用与 HashData 数据库一起的安装的  Python 。

为了检查  Python  环境，用户可以使用 which 命令：

```
which  Python
```

该命令返回  Python  的安装路径。和  HashData 数据库一起安装的  Python  实在  HashData 数据库中 ext/ Python  目录下。

```
/path_to_ HashData -db/ext/ Python /bin/ Python
```

如果用户正在构建  Python  模块，则必须确保构建创建正确的可执行文件。例如在 Linux 系统上，构建应创建一个 64 位的可执行文件。

在构建一个安装的模块之前，请确保安装并正确配置相应的构建模块的软件。构建环境仅在构建模块的主机上需要。

安装和测试  Python  模块的列子：

* [简单 Python 模块安装例子 \(setuptools\)](#simple-python-model)
* [复杂 Python 安装例子 \( NumPy \)](#complex-python-case)
* [测试安装的 Python 模块](#test-installed-python)

### <h3 id='simple-python-model'> 简单 Python 模块安装例子 \(setuptools\)

此例从  Python  包索引储存库手动安装  Python  setuptools 模块。该模块可让用户轻松下载，构建，安装，升级和卸载  Python  包。

该示例首先从一个程序包生成模块，并将该模块安装到在一单个主机上，然后该模块将被构建并安装在段主机上。

1. 从  Python  包索引站点获取模块包，例如，以 gpadmin 用户身份在  HashData 数据库主机上运行  wget 命令，来获得 tar 文件

   ```
   wget --no-check-certificate https://pypi.Python.org/packages/source/s/setuptools/setuptools-18.4.tar.gz
   ```

2. 从 tar 文件中提取文件。

   ```
   tar -xzvf distribute-0.6.21.tar.gz
   ```

3. 转到包含包文件的目录，并运行  Python  脚本来构建和安装  Python  包

   ```
   cd setuptools-18.4
    Python  setup.py build &&  Python  setup.py install
   ```

4. 如果模块已经安装好，则接下来的  Python  命令将不返回错误。

   ```
    Python  -c "import setuptools"
   ```

5. 使用 gpscp 工具将包复制到  HashData 数据库主机。例如，这个命令从当前主机复制 tar 文件到文件 remote-hosts 中所列的主机中。

   ```
   gpscp -f remote-hosts setuptools-18.4.tar.gz =:/home/gpadmin
   ```

6. 使用 gpssh 在 remote-hosts 文件列出的主机中运行命令构建, 安装和测试该软件包。该文件 remote-hosts 列出了所有 HashData 数据库的段主机：

   ```
   gpssh -f remote_hosts
   >>> tar -xzvf distribute-0.6.21.tar.gz
   >>> cd setuptools-18.4
   >>>  Python  setup.py build &&  Python  setup.py install
   >>>  Python  -c "import setuptools"
   >>> exit
   ```

setuptools 包安装了 easy\_install 使用程序，该程序可以使用从  Python  包索引存储库安装  Python  包。例如，这个命令从  Python  索引站点安装  Python  PIP 实用程序。

```
easy_install pip
```

用户可以使用 gpssh 实用程序在所有 HashData 数据库段主机中运行 easy-install 命令。

### <h3 id='complex-python-case'> 复杂的 Python 安装例子 \( NumPy \)

这个例子构建和安装了  Python  模块  NumPy 。 NumPy  是  Python  的一个科学计算模块。更多关于  NumPy  的信息，请参阅 [http://www.NumPy.org/](http://www.NumPy.org/)。

构建  NumPy  包所需的软件：

* OpenBLAS 库,一个开源的 BLAS 实现\(基础线性代数子程序\)。
* gcc 编译器: gcc, gcc-gfortran, and gcc-c++。这些编译器需要来构建 OpenBLAS 库。

这个例子过程假定 yum 安装在 HashData 数据库段主机上，而且 gpadmin 用户是主机上具有root权限的 sudoers 成员。

下载 OpenBLAS 和  NumPy  源文件。例如，这些 wget 命令下载 tar 文件到目录 packages 中：

```
wget --directory-prefix=packages http://github.com/xianyi/OpenBLAS/tarball/v0.2.8
wget --directory-prefix=packages http://sourceforge.net/projects/ NumPy /files/ NumPy /1.8.0/ NumPy -1.8.0.tar.gz/download
```

将软件分发到 HashData 数据库主机。例如，如果用户将软件下载到/home/gpadmin/packages 这些命令在主机中创建文件夹并且将软件复制到 gpdb\_remotes 文件所列的主机中。

```
gpssh -f gpdb_remotes mkdir packages 
gpscp -f gpdb_remotes packages/* =:/home/gpadmin/packages
```

#### OpenBLAS 先决条件

如果需要的话，使用 yum 从系统仓库安装 gcc 编译器。所有用户编译 OpenBLAS 的主机都需要该编译器：

```
sudo yum -y install gcc gcc-gfortran gcc-c++
```

> 注意： 如果用户不能使用 yum 安装正确的编译器版本，用户可以从源文件下载 gcc 编译器（包括gfortran），并进行安装。这两个命令下载并安装该编译器：

```
wget http://gfortran.com/download/x86_64/snapshots/gcc-4.4.tar.xz
tar xf gcc-4.4.tar.xz -C /usr/local/
```

如果用户是从 tar 文件手动安装的 gcc 编译器，添加新的 gcc 库到 PATH 和 LD\_LIBRARY\_PATH中：

```
export PATH=$PATH:/usr/local/gcc-4.4/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/gcc-4.4/lib
```

创建一个符号链接到 g++ 并称其为 gxx

```
sudo ln -s /usr/bin/g++ /usr/bin/gxx
```

用户可能也需要创建一个符号链接到具有不同版本的库例如 libppl\_c.so.4 到 libppl\_c.so.2.

如果需要的话，用户可以使用 gpscp 实用工具来复制文件到  HashData  数据库的主机中，并使用 gpssh 实用工具在主机上运行命令。

### 构建和安装 OpenBLAS 库

在构建和安装  NumPy  模块之前，用户应安装 OpenBLAS 库。本节介绍如何在单个主机上构建和安装该库。

1. 这些命令从 OpenBLAS tar文件中提取文件，并简化了包含 OpenBLAS 文件的目录名。

   ```
   tar -xzf packages/v0.2.8 -C /home/gpadmin/packages
   mv /home/gpadmin/packages/xianyi-OpenBLAS-9c51cdf /home/gpadmin/packages/OpenBLAS
   ```

2. 编译 OpenBLAS。这些命令设置 LIBRARY\_PATH 环境变量并运行 make 命令构建 OpenBLAS 库。

   ```
   cd /home/gpadmin/packages/OpenBLAS
   export LIBRARY_PATH=$LD_LIBRARY_PATH
   make FC=gfortran USE_THREAD=0
   ```

3. 这些命令作为 root 用户在 /usr/local 目录下安装 OpenBLAS 库并且将文件的所有者改为 gpadmin 用户。

   ```
   cd /home/gpadmin/packages/OpenBLAS/
   sudo make PREFIX=/usr/local install
   sudo ldconfig
   sudo chown -R gpadmin /usr/local/lib
   ```

这些是安装的库和创建的符号链接：

```
libopenblas.a -> libopenblas_sandybridge-r0.2.8.a
libopenblas_sandybridge-r0.2.8.a
libopenblas_sandybridge-r0.2.8.so
libopenblas.so -> libopenblas_sandybridge-r0.2.8.so
libopenblas.so.0 -> libopenblas_sandybridge-r0.2.8.so
```

用户可以使用 gpssh 工具来在多主机中构建和安装 OpenBLAS 库。

所有的 HashData 数据库主机 \(主机和段主机\) 都有相同的配置。用户可以从构建它们的系统中复制  OpenBLAS 库，而不是在所有主机上构建 OpenBlas 库。例如，这些 gpssh 和 gpscp 命令在 gpdb\_remotes 文件列出的主机中复制并且安装了 OpenBLAS 库。

```
gpssh -f gpdb_remotes -e 'sudo yum -y install gcc gcc-gfortran gcc-c++'
gpssh -f gpdb_remotes -e 'ln -s /usr/bin/g++ /usr/bin/gxx'
gpssh -f gpdb_remotes -e sudo chown gpadmin /usr/local/lib
gpscp -f gpdb_remotes /usr/local/lib/libopen*sandy* =:/usr/local/lib

gpssh -f gpdb_remotes
>>> cd /usr/local/lib
>>> ln -s libopenblas_sandybridge-r0.2.8.a libopenblas.a
>>> ln -s libopenblas_sandybridge-r0.2.8.so libopenblas.so
>>> ln -s libopenblas_sandybridge-r0.2.8.so libopenblas.so.0
>>> sudo ldconfig
```

### <h3 id='topic3-0-1'> 构建和安装 NumPy

在用户安装完 OpenBLAS 库之后，用户可以构建和安装  NumPy  模块。 这些步骤可以在单个主机中安装  NumPy  模块。用户可以使用 gpssh 工具在多主机中构建和安装  NumPy  模块。

1. 转到 packages 子目录并且获取 NumPy 模块源码并解压该文件。

   ```
   cd /home/gpadmin/packages
   tar -xzf  NumPy -1.8.0.tar.gz
   ```

2. 为构建和安装  NumPy 设置环境。

   ```
   export BLAS=/usr/local/lib/libopenblas.a
   export LAPACK=/usr/local/lib/libopenblas.a
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
   export LIBRARY_PATH=$LD_LIBRARY_PATH
   ```

3. 转到 NumPy 目录并构建和安装 NumPy 。构建 NumPy 包可能需要一些时间。

   ```
   cd  NumPy -1.8.0
    Python  setup.py build
    Python  setup.py install
   ```

   > 注意： 如果 NumPy 模块没有成功构建，那 NumPy 构建过程可能需要一个指定OpenBLAS库位置的 site.cfg 。 创建文件 site.cfg 在 NumPy 包目录中：

   ```
   cd ~/packages/ NumPy -1.8.0
   touch site.cfg
   ```

   添加以下脚本到 site.cfg 文件中并再次运行 NumPy 构建命令：

   ```
   [default]
   library_dirs = /usr/local/lib

   [atlas]s
   atlas_libs = openblas
   library_dirs = /usr/local/lib

   [lapack]
   lapack_libs = openblas
   library_dirs = /usr/local/lib

   # added for scikit-learn 
   [openblas]
   libraries = openblas
   library_dirs = /usr/local/lib
   include_dirs = /usr/local/include
   ```

4. 以下的  Python  命令确保该模块可用于在主机系统上由 Python 导入。

   ```
    Python  -c "import  NumPy "
   ```

如同在简单的模块安装中一样，用户可以使用 gpssh 工具来构建，安装和测试 HashData 数据库中段主机中的模块。

在构建 NumPy 时所需的环境变量，在 gpadmin 用户环境中运行 Python NumPy 函数时同样需要。用户可以使用 gpssh 工具 和 echo 命令将环境变量添加到 .bashrc 文件中。例如，这些 echo 命令添加环境变量到用户家（user home）目录下的 .bashrc 文件中。

```
echo -e 'n#Needed for  NumPy ' >> ~/.bashrc
echo -e 'export BLAS=/usr/local/lib/libopenblas.a' >> ~/.bashrc
echo -e 'export LAPACK=/usr/local/lib/libopenblas.a' >> ~/.bashrc
echo -e 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> ~/.bashrc
echo -e 'export LIBRARY_PATH=$LD_LIBRARY_PATH' >> ~/.bashrc
```

### <h3 id='test-installed-python'> 测试安装的 Python 模块

用户可以创建一个简单的 PL/Python  用户自定义函数 \(UDF\) 来验证 HashData 数据库中的 Python 模块可用。这个例子测试的是  NumPy  模块。

这个 PL/Python  UDF 导入  NumPy  模块。如果模块被正确导入，则该函数返回 SUCCESS ，否则返回 FAILURE 。

```
CREATE OR REPLACE FUNCTION plpy_test(x int)
returns text
as $$
  try:
      from  NumPy  import *
      return 'SUCCESS'
  except ImportError, e:
      return 'FAILURE'
$$ language pl Python u;
```

创建一个包含每个 HashData 数据库段实例上的数据的表。根据用户的 HashData 数据库安装的大小，用户可能需要生成更多数据，以确保数据分发到所有段实例。

```
CREATE TABLE DIST AS (SELECT x FROM generate_series(1,50) x ) DISTRIBUTED RANDOMLY ;
```

该 SELECT 命令在数据存储在主段实例中的段主机上运行 UDF。

```
SELECT gp_segment_id, plpy_test(x) AS status
  FROM dist
  GROUP BY gp_segment_id, status
  ORDER BY gp_segment_id, status;
```

如果在 HashData 数据库段实例中UDF成功导入 Python 模块，该 SELECT 命令返回 SUCCESS 。如果该 SELECT 命令返回 FAILURE，用户可以找到段实例主机的段主机。 HashData 数据库系统表 gp\_segment\_configuration 包含镜像和段配置信息。该命令返回段ID的主机名。

```
SELECT hostname, content AS seg_ID FROM gp_segment_configuration
  WHERE content = seg_id ;
```

如果返回 FAILURE，有以下几种可能：

* 访问所需库时遇到问题。对于 NumPy 例子， HashData 数据库可能在访问段主机上的OpenBLAS库或者 Python 库时遇到问题。

  请确保用户以 gpadmin 用户在端主机上运行命令时没有返回错误。该 gpssh 命令测试在段主机 mdw1上导入 NumPy 模块。

  ```
  gpssh -h mdw1  Python  -c "import  NumPy "
  ```

* 如果 Python import 命令没有返回错误， 则环境变量可能没有在 HashData 数据库环境中配置。例如，变量不在 .bashrc 文件中，或者 HashData 数据库在向 .bashrc 文件中添加环境变量之后没有重启。

  确保环境变量被正确设置，然后重新启动 HashData 数据库。对于 NumPy 例子，确保被列在 [构建和安装 NumPy](#topic3-0-1)  末尾部分的环境变量被定义在主机和段主机上 gpadmin 用户的.bashrc文件中。

  > 注意: 在 HashData 数据库主机和段主机上，gpadmin 用户的 .bashrc 文件必须来源于文件 `$GPHOME/HashData\_path.sh`。

## <h2 id='topic2_5'> 例子

该 PL/Python  UDF（用户自定义函数）返回两个整数的较大者：

```
CREATE FUNCTION pymax (a integer, b integer)
  RETURNS integer
AS $$
  if (a is None) or (b is None):
      return None
  if a > b:
     return a
  return b
$$ LANGUAGE pl Python u;
```

用户可以使用 STRICT 属性来执行空处理而不是使用两个条件语句。

```
CREATE FUNCTION pymax (a integer, b integer) 
  RETURNS integer AS $$ 
return max(a,b) 
$$ LANGUAGE pl Python u STRICT ;
```

用户可以运行用户自定义函数 pymax 通过用 SELECT 命令。该例子运行用户自定义函数并且显示了输出。

```
SELECT ( pymax(123, 43));
column1
---------
     123
(1 row)
```

该例子从针对表运行的SQL查询返回数据。这两个命令创建了一个简单的表，并向表中添加了数据。

```
CREATE TABLE sales (id int, year int, qtr int, day int, region text)
  DISTRIBUTED BY (id) ;

INSERT INTO sales VALUES
 (1, 2014, 1,1, 'usa'),
 (2, 2002, 2,2, 'europe'),
 (3, 2014, 3,3, 'asia'),
 (4, 2014, 4,4, 'usa'),
 (5, 2014, 1,5, 'europe'),
 (6, 2014, 2,6, 'asia'),
 (7, 2002, 3,7, 'usa') ;
```

该 PL/Python  UDF 执行了一个从表中返回 5 行的 SELECT 命令。 Python 函数从输入值指定的行返回 REGION 值。在 Python 函数中，行标从 0 开始。该函数有效的输入是0到4之间的整数。

```
CREATE OR REPLACE FUNCTION mypytest(a integer) 
  RETURNS text 
AS $$ 
  rv = plpy.execute("SELECT * FROM sales ORDER BY id", 5)
  region = rv[a]["region"]
  return region
$$ language pl Python u;
```

运行该 SELECT 语句从结果集的第三行返回 REGION 列值。

```
SELECT mypytest(2) ;
```

该从数据库中删除了 UDF（用户自定义函数）。

```
DROP FUNCTION mypytest(integer) ;
```

该例子在前面的示例中使用 DO 命令作为匿名块执行 PL/Python  函数。在该例子中，匿名块从临时表中检索输入值。

```
CREATE TEMP TABLE mytemp AS VALUES (2) DISTRIBUTED RANDOMLY;

DO $$ 
  temprow = plpy.execute("SELECT * FROM mytemp", 1)
  myval = temprow[0]["column1"]
  rv = plpy.execute("SELECT * FROM sales ORDER BY id", 5)
  region = rv[myval]["region"]
  plpy.notice("region is %s" % region)
$$ language pl Python u;
```

## <h2 id='topic2_6'> 参考

### 技术参考

更多关于 Python 语言的信息，请参阅 [https://www.Python.org/](https://www.Python.org/)。

更多关于 PL/Python 的信息，请参阅 PostgreSQL 文档。

更多关于 Python 包索引（PyPI）的信息，请参阅 [https://pypi.Python.org/pypi](https://pypi.Python.org/pypi)。

这些是一些可以下载的 Python 模块：

* SciPy 库提供用户友好和高效的数值例程，例如数值积分和优化的例程 [http://www.scipy.org/scipylib/index.html](http://www.scipy.org/scipylib/index.html)。该 wget 命令可以下载 SciPy 包的tar文件。

  ```
  wget http://sourceforge.net/projects/scipy/files/scipy/0.10.1/scipy-0.10.1.tar.gz/download
  ```

* 自然语言工具包 \(nltk\) 是一个构建 Python 程序以处理人数语言数据的平台。[http://www.nltk.org/](http://www.nltk.org/)。该 wget 命令下载 nltk 包的tar文件。

  ```
  wget http://pypi.Python.org/packages/source/n/nltk/nltk-2.0.2.tar.gz#md5=6e714ff74c3398e88be084748df4e657
  ```

  > 注意： 对 nltk 来说， Python  Distribute 包 [https://pypi.Python.org/pypi/distribute](https://pypi.Python.org/pypi/distribute)是必须的。该 Distribute 模块应该安装ntlk包。该 wget 命令可以下载 Distribute 包的 tar 文件。

  ```
  wget http://pypi.Python.org/packages/source/d/distribute/distribute-0.6.21.tar.gz
  ```



