# HashData的PL/Java语言扩展

本节包含 HashData 数据库的 PL/Java 语言的概述。

## 有关 PL/Java

通过使用 HashData 数据库的 PL/Java 扩展，用户可以使用自己喜欢的 Java IDE 编写 Java 方法，并将包含这些方法的 JAR 文件安装到 HashData 数据库中。

HashData 数据库的 PL/Java 扩展基于开源 PL/Java 1.4.0。HashData 数据库的 PL/Java 提供以下功能。

* 能够使用 Java 1.7 或更高版本执行 PL/Java 函数。
* 能够指定 Java 运行时间。
* 在数据库中安装和维护 Java 代码的标准化实用程序（在 SQL 2003 提案之后设计）
* 参数和结果的标准化映射。支持复杂类型集。
* 使用 HashData 数据库内部 SPI 例程的嵌入式高性能JDBC驱动程序
* 元数据支持 JDBC 驱动程序。 包括 DatabaseMetaData 和 ResultSetMetaData。
* 能够从查询中返回 ResultSet，作为逐行构建 ResultSet 的替代方法。
* 完全支持保存点和异常处理。
* 能够使用 IN，INPUT 和 OUT 参数。
* 两种独立的 HashData 数据库语言:
  * pljava, TRUSTED PL/Java language
  * pljavau, UNTRUSTED PL/Java language
* 当一个事务或者保存点提交或者回滚时，事务和保留点监听器能够被编译执行。
* 在所选平台上与 GNU GCJ 集成。

使用HashData中使用PL/Java的时候，我们需要通过用户自定义函数（UDF）将 SQL 中的一个函数与 Java 类中的一个静态方法绑定。为了使函数能够执行，所指定的类必须能够通过 HashData 数据库服务器上的 pljava\_classpath 配置参数来指定类路径。PL/Java 扩展添加了一组有助于安装和维护 java 类的函数。 类存储在普通的 Java 档案－－JAR 文件中。JAR 文件可以选择性地包含部署描述符，该描述符又包含在部署或取消部署 JAR 时要执行的 SQL 命令。 这些功能是按照 SQL 2003 提出的标准进行设计的。

PL/Java 实现了传递参数和返回值的标准化方法，通过使用标准 JDBC ResultSet 类传递复杂类型和集合。

PL/Java 中包含 JDBC 驱动程序。 此驱动程序调用 HashData 数据库内部 SPI 接口。驱动程序是必不可少的，因为函数通常将调用数据库以获取数据。当 PL/Java 函数提取数据时， 它们必须使用与输入 PL/Java 执行上下文的主函数使用的相同的事务边界。

PL/Java 针对性能进行了优化。Java 虚拟机在与后端相同的进程中执行，以最小化调用开销。 PL/Java 的设计目的是为了使数据库本身能够实现 Java 的强大功能，以便数据库密集型业务逻辑可以尽可能靠近实际数据执行。

当后端和 Java VM 之间的桥梁被调用时，将使用标准 Java 本机接口（JNI）。

## 有关 HashData 数据库的 PL/Java

在标准 PostgreSQL 和 HashData 数据库中实现 PL/Java 有一些关键的区别。

### 函数

以下函数在 HashData 数据库中不被支持. 在分布式的 HashData 数据库环境中，类路径的处理方式与 PostgreSQL 环境下不同。

* sqlj.install\_jar
* sqlj.replace\_jar
* sqlj.remove\_jar
* sqlj.get\_classpath
* sqlj.set\_classpath

HashData 数据库使用 pljava\_classpath 服务器配置参数代替 sqlj.set\_classpath 函数。

### 服务器配置参数

以下服务器配置参数由 PL/Java 在 HashData 数据库中使用。这些参数取代了标准 PostgreSQL PL/Java 实现中使用的 pljava.\* 参数：

* pljava\_classpath

  冒号\(:\) 分离的包含任何 PL/Java 函数中使用的 Java 类的 jar 文件列表。所有的 jar 文件必须安装在所有的 HashData 数据库主机的相同位置。使用可信的 PL/Java 语言处理程序，jar 文件路径必须相对于 `$GPHOME/lib/postgresql/java/` 目录。 使用不受信任的语言处理程序（javau 语言标记），路径可以相对于 `$GPHOME/lib/postgresql/java/` 或使用绝对路径。

  服务器配置参数 `pljava_classpath_insecure` 控制服务器配置参数 pljava\_classpath set by 是否可以由用户设置，无需 HashData 数据库超级用户权限。当启用 pljava\_classpath\_insecure 时,正在开发 PL/Java 函数的 HashData 数据库开发人员不必是数据库超级用户身份才能来更改 pljava\_classpath.

  > 警告： 启用 pljava\_classpath\_insecure 通过为非管理员数据库用户提供能够运行未经授权的 Java 方法暴露了安全风险。

* pljava\_statement\_cache\_size

  为准备语句设置最近使用（MRU）缓存的大小（KB）。

* pljava\_release\_lingering\_savepoints

  如果为 TRUE,在函数退出后，长期持续的保留点将会释放。 如果为 FALSE, 它们将被回滚。

* pljava\_vmoptions

  定义 HashData 数据库 Java VM 的启动选项。

参阅 HashData 数据库参考指南 有关 HashData 数据库服务器配置参数的信息。

## 启用 PL/Java 并安装 JAR 文件

执行以下步骤作为 HashData 数据库管理员 gpadmin。

1. 通过在使用 PL/Java 的数据库中运行 SQL 脚本 `$GPHOME/share/postgresql/pljava/install.sql` 来启用 PL/Java。例如，此示例启用 PL/Java 在数据库 mytestdb:

   ```
   $ psql -d mytestdb -f $GPHOME/share/postgresql/pljava/install.sql
   ```

   脚本 install.sql 注册可信的和不可信的 PL/Java 语言.

2. 将 Java 归档（JAR 文件）复制到所有 HashData 数据库主机上的同一目录。 本示例使用 HashData 数据库 gpscp 程序将文件 myclasses.jar 复制到目录 `$GPHOME/lib/postgresql/java/`:

   ```
   $ gpscp -f gphosts_file myclasses.jar =:/usr/local/HashData-db/lib/postgresql/java/
   ```

   文件 gphosts\_file 包含一个 HashData 数据库主机的列表。

3. 设置 pljava\_classpath 服务器配置参数在 postgresql.conf 文件中。 对于此示例，参数值是冒号（:\) 分隔的 JAR 文件列表。 例如：

   ```
   $ gpconfig -c pljava_classpath -v 'examples.jar:myclasses.jar'
   ```

   当用户使用 gppkg 实用程序安装 PL/Java 扩展包时， 将安装 examples.jar文件。

   > 注意： 如果将 JAR 文件安装在除 `$GPHOME/lib/postgresql/java/` 则必须指定 JAR 文件的绝对路径。 所有的 HashData 数据库主机上的每个 JAR 文件必须位于相同的位置。 有关指定 JAR 文件位置的更多信息，参阅有关 pljava\_classpath 服务器配置参数的信息在 HashData 数据库 Reference Guide.

4. 重新加载 postgresql.conf 文件。

   ```
   $ gpstop -u
   ```

5. \(可选\) HashData 提供了一个包含可用于测试的示例 PL/Java 函数的 examples.sql 文件。 运行此文件中的命令来创建测试函数 \(它使用 examples.jar 中的 Java 类\)。

   ```
   $ psql -f $GPHOME/share/postgresql/pljava/examples.sql
   ```

## 编写 PL/Java 函数

有关使用 PL/Java 编写函数的信息。

### SQL 声明

一个 Java 函数被声明为该类的一个类的名称和静态方法。该类将用于为该函数声明的模式定义的类路径进行解析。 如果没有为该模式定义类路径，则使用公共模式。如果没有找到类路径，则使用系统类加载器解析该类。

可以声明以下函数来访问 java.lang.System 类上的静态方法 getProperty：

```
CREATE FUNCTION getsysprop(VARCHAR)
  RETURNS VARCHAR
  AS 'java.lang.System.getProperty'
  LANGUAGE java;
```

运行以下命令返回 user.home 属性:

```
SELECT getsysprop('user.home');
```

### 类型映射

标量类型以简单的方式映射。此表列出了当前的映射

表 1. PL/Java数据类型映射

| PostgreSQL | Java |
| :--- | :--- |
| bool | boolean |
| char | byte |
| int2 | short |
| int4 | int |
| int8 | long |
| varchar | java.lang.String |
| text | java.lang.String |
| bytea | byte\[ \] |
| date | java.sql.Date |
| time | java.sql.Time \(stored value treated as local time\) |
| timetz | java.sql.Time |
| timestamp | java.sql.Timestamp \(stored value treated as local time\) |
| timestamptz | java.sql.Timestamp |
| complex | java.sql.ResultSet |
| setof complex | java.sql.ResultSet |

所有其他类型都映射到 java.lang.String，并将使用为各自类型注册的标准 textin/textout 例程。

### NULL 处理

映射到 java 基元的标量类型不能作为 NULL 值传递。要传递 NULL 值, 这些类型可以有一个替代映射。用户可以通过在方法引用中明确的指定该映射来启用映射。

```
CREATE FUNCTION trueIfEvenOrNull(integer)
  RETURNS bool
  AS 'foo.fee.Fum.trueIfEvenOrNull(java.lang.Integer)'
  LANGUAGE java;
```

Java 代码将类似于：

```
package foo.fee;
public class Fum
{
  static boolean trueIfEvenOrNull(Integer value)
  {
    return (value == null)
      ? true
      : (value.intValue() % 2) == 0;
  }
}
```

以下两个语句都产生 true：

```
SELECT trueIfEvenOrNull(NULL);
SELECT trueIfEvenOrNull(4);
```

为了从 Java 方法返回 NULL 值, 可以使用与原始对象相对应的对象类型 \(例如，返回 java.lang.Integer 而不是 int\)。PL/Java 解析机制找不到方法。由于 Java 对于具有相同名称的方法不能具有不同的返回类型，因此不会引入任何歧义。

### 复杂类型

复杂类型将始终作为只读的 java.sql.ResultSet 传递，只有一行。ResultSet 位于其行上，因此不应该调用 next\(\) 。使用 ResultSet 的标准 getter 方法检索复杂类型的值。

例如:

```
CREATE TYPE complexTest
  AS(base integer, incbase integer, ctime timestamptz);
CREATE FUNCTION useComplexTest(complexTest)
  RETURNS VARCHAR
  AS 'foo.fee.Fum.useComplexTest'
  IMMUTABLE LANGUAGE java;
```

在 java 类 Fum 中,，我们添加以下静态方法：

```
public static String useComplexTest(ResultSet complexTest)
throws SQLException
{
  int base = complexTest.getInt(1);
  int incbase = complexTest.getInt(2);
  Timestamp ctime = complexTest.getTimestamp(3);
  return "Base = "" + base +
    "", incbase = "" + incbase +
    "", ctime = "" + ctime + """;
}
```

### 返回复杂类型

Java 没有规定任何创建 ResultSet 的方法。 因此，返回 ResultSet 不是一个选项。 SQL-2003 草案建议将复杂的返回值作为 IN / OUT 参数处理。 PL/Java 以这种方式实现了一个 ResultSet。 如果用户声明一个返回复杂类型的函数，则需要使用带有最后一个参数类型为 java.sql.ResultSet 的布尔返回类型的 Java 方法。 该参数将被初始化为一个空的可更新结果集，它只包含一行。

假设已经创建了上一节中的 complexTest 类型。

```
CREATE FUNCTION createComplexTest(int, int)
  RETURNS complexTest
  AS 'foo.fee.Fum.createComplexTest'
  IMMUTABLE LANGUAGE java;
```

PL/Java 方法解析现在将在 Fum 类中找到以下方法:

```
public static boolean complexReturn(int base, int increment, 
  ResultSet receiver)
throws SQLException
{
  receiver.updateInt(1, base);
  receiver.updateInt(2, base + increment);
  receiver.updateTimestamp(3, new 
    Timestamp(System.currentTimeMillis()));
  return true;
}
```

返回值表示接收方是否应被视为有效的元组（true）或 NULL（false）。

### 函数的返回集

返回结果集时，不要在返回结果集之前构建结果集，因为构建大型结果集将消耗大量资源。最好一次产生一行。 顺便提一句，那就是 HashData 数据库后端期望一个使用 SETOF 返回的函数。 那用户就可以返回 SETOF 的一个标量类型，如 int, float 或 varchar, 或者可以返回一个复合类型的 SETOF。

### 返回 SETOF &lt;标量类型&gt;

为了返回一组标量类型，用户需要创建一个实现 java.util.Iterator 接口的 Java 方法。这是一个返回一个 SETOF 的 varchar 的方法的例子:

```
CREATE FUNCTION javatest.getSystemProperties()
  RETURNS SETOF varchar
  AS 'foo.fee.Bar.getNames'
  IMMUTABLE LANGUAGE java;
```

这个简单的 Java 方法返回一个迭代器:

```
package foo.fee;
import java.util.Iterator;

public class Bar
{
    public static Iterator getNames()
    {
        ArrayList names = new ArrayList();
        names.add("Lisa");
        names.add("Bob");
        names.add("Bill");
        names.add("Sally");
        return names.iterator();
    }
}
```

### 返回 SETOF &lt;复杂类型&gt;

返回 SETOF \&lt;复杂类型&gt; 的方法必须使用接口 org.postgresql.pljava.ResultSetProvider 或 org.postgresql.pljava.ResultSetHandle。具有两个接口的原因是它们满足两种不同用例的最佳处理。前者适用于要动态创建要从SETOF函数返回的每一行的情况。 在用户要返回执行查询的结果的情况下，后者将生成。

#### 使用 ResultSetProvider 接口

该接口有两种方法。布尔型 assignRowValues\(java.sql.ResultSet tupleBuilder, int rowNumber\) 和 void close\(\) 方法。 HashData 数据库的查询执行器将重复调用 assignRowValues 直到它返回假或者直到执行器决定不需要更多行为止。然后它会调用 close。

用户可以通过以下方式使用此接口：

```
CREATE FUNCTION javatest.listComplexTests(int, int)
  RETURNS SETOF complexTest
  AS 'foo.fee.Fum.listComplexTest'
  IMMUTABLE LANGUAGE java;
```

该函数映射到一个返回实现 ResultSetProvider 接口实例的静态 java 方法。

```
public class Fum implements ResultSetProvider
{
  private final int m_base;
  private final int m_increment;
  public Fum(int base, int increment)
  {
    m_base = base;
    m_increment = increment;
  }
  public boolean assignRowValues(ResultSet receiver, int 
currentRow)
  throws SQLException
  {
    // Stop when we reach 12 rows.
    //
    if(currentRow >= 12)
      return false;
    receiver.updateInt(1, m_base);
    receiver.updateInt(2, m_base + m_increment * currentRow);
    receiver.updateTimestamp(3, new 
Timestamp(System.currentTimeMillis()));
    return true;
  }
  public void close()
  {
   // Nothing needed in this example
  }
  public static ResultSetProvider listComplexTests(int base, 
int increment)
  throws SQLException
  {
    return new Fum(base, increment);
  }
}
```

listComplextTests 方法被调用一次。 如果没有可用结果或 ResultSetProvider 实例，将返回 NULL。这里的 Java 类 Fum 实现了这个接口，所以它返回一个自己的实例。 然后将重复调用 assignRowValues 方法，直到返回 false。 到那候，将会调用 close。

#### 使用 ResultSetHandle 接口

该接口类似于 ResultSetProvider 接口因为它也有将在最后调用的 close\(\) 方法， 但是，不是让 evaluator 调用一次构建一行的方法，而是返回一个 ResultSet 的方法。 查询 evaluator 将遍历该集合，并将 RestulSet 内容（一次一个元组）传递给调用者，直到对 next\(\) 的调用返回 false 或者 evaluator 决定不需要更多行。

这是一个使用默认连接获取的语句执行查询的示例。适用于部署描述符的 SQL 看起来像这样:

```
CREATE FUNCTION javatest.listSupers()
  RETURNS SETOF pg_user
  AS 'org.postgresql.pljava.example.Users.listSupers'
  LANGUAGE java;
CREATE FUNCTION javatest.listNonSupers()
  RETURNS SETOF pg_user
  AS 'org.postgresql.pljava.example.Users.listNonSupers'
  LANGUAGE java;
```

并且在 Java 包中 org.postgresql.pljava.example 加入了一个类 Users：

```
public class Users implements ResultSetHandle
{
  private final String m_filter;
  private Statement m_statement;
  public Users(String filter)
  {
    m_filter = filter;
  }
  public ResultSet getResultSet()
  throws SQLException
  {
    m_statement = 
      DriverManager.getConnection("jdbc:default:connection").cr
eateStatement();
    return m_statement.executeQuery("SELECT * FROM pg_user 
       WHERE " + m_filter);
  }

  public void close()
  throws SQLException
  {
    m_statement.close();
  }

  public static ResultSetHandle listSupers()
  {
    return new Users("usesuper = true");
  }

  public static ResultSetHandle listNonSupers()
  {
    return new Users("usesuper = false");
  }
}
```

## 使用 JDBC

PL/Java 包含映射到 PostgreSQL SPI 函数的 JDBC 驱动程序。可以使用以下语句获取映射到当前事务的连接：

```
Connection conn = DriverManager.getConnection("jdbc:default:connection");
```

获取连接后，可以准备和执行类似于其他 JDBC 连接的语句。 这些是 PL/Java JDBC 驱动程序的限制:

* 事务无法以任何方式进行管理。 因此，连接后用户不能用如下方法:
  * commit\(\)
  * rollback\(\)
  * setAutoCommit\(\)
  * setTransactionIsolation\(\)
* 在保存点上也有一些限制。 保存点不能超过其设置的功能，并且必须由同一功能回滚或释放。
* 从 executeQuery\(\) 返回的结果集始终为 FETCH\_FORWARD 和 CONCUR\_READ\_ONLY.
* 元数据仅在 PL/Java 1.1 或更高版本中可用。
* CallableStatement （用于存储过程）没有实现。
* Clob 和 Blob 类型未完全实现， 需要更多工作。 byte\[\] 和 String 可分别用于 bytea 和text 。

## 异常处理

用户可以像 HashData 数据库后端一样捕获并处理异常，就像任何其他异常一样。 后端的 ErrorData 结构作为一个名为 org.postgresql.pljava.ServerException \(从 java.sql.SQLException 中派生\)的类中的属性公开，并且 Java try / catch 机制与后端机制同步。

> 重点：在函数返回之前，用户将无法继续执行后端函数，并且在后端生成异常时传播错误，除非用户使用了保存点 。当回滚保存点时，异常条件被重置，用户可以继续执行。

## 保存点

HashData 数据库保存点使用 java.sql.Connection 接口公开。有两个限制。

* 必须在设置的函数中回滚或释放保存点。
* 保存点不能超过其设置的功能

## 日志

PL/Java 使用标准的 Java Logger。 因此，用户可以如下写：

```
Logger.getAnonymousLogger().info( "Time is " + new 
Date(System.currentTimeMillis()));
```

目前，记录器使用一个处理程序来映射 HashData 数据库配置设置的当前状态 log\_min\_messages 到有效的 Logger 级别，并使用 HashData 数据库后端功能输出所有消息 elog\(\)。

> 注解： log\_min\_messages 该 log\_min\_messages 首次在执行会话中的 PL/Java 函数时，从数据库读取设置。在 Java 方面，在使用 PL/Java 的 HashData 数据库会话重新启动之前 ，特定会话中第一个 PL/Java 函数执行后，该设置不会更改。

Logger 级别和 HashData 数据库后端级别之间适用以下映射。

表 2. PL/Java 日志 Levels

| java.util.logging.Level | HashData 数据库 Level |
| :--- | :--- |
| SEVERE ERROR | ERROR |
| WARNING | WARNING |
| CONFIG | LOG |
| INFO | INFO |
| FINE | DEBUG1 |
| FINER | DEBUG2 |
| FINEST | DEBUG3 |

## 安全

### 安装

只有数据库超级用户可以安装 PL/Java。使用 SECURITY DEFINER 安装 PL/Java 实用程序函数，以便它们以授予函数创建者的访问权限执行。

### 可信语言

PL/Java 是一种可信语言。 可信的 PL/Java 语言无法访问 PostgreSQL 定义可信语言所规定的文件系统。任何数据库用户都可以创建和访问受信任的语言的函数。

PL/Java 还为语言 javau 安装语言处理程序。 此版本不受信任，只有超级用户可以创建使用它的新函数。 任何用户都可以调用这些函数。

## 一些 PL/Java 问题和解决方案

当编写 PL/Java 时，将 JVM 映射到与 HashData 数据库后端代码相同的进程空间中，对于多个线程， 异常处理和内存管理，已经出现了一些问题。 这里是简要说明如何解决这些问题。

* [Multi-threading](#多线程)
* [异常处理](#异常处理)
* [Java Garbage Collector Versus palloc\(\) and Stack Allocation](#异常处理)

### 多线程

Java 本身就是多线程的。HashData 数据库后端不是。没有什么可以阻止开发人员在 Java 代码中使用多个 Threads 类。调用后端的终结器可能是从背景垃圾回收线程中产生的。 可能使用的几个第三方 Java 包使用多个线程。该模式在同一过程中如何与 HashData 数据库后端共存？

#### 解决方案

解决方案很简单。PL/Java 定义了一个特殊对象 Backend.THREADLOCK.。当初始化 PL/Java 时，后端立即抓取该对象监视器（即它将在​​此对象上同步）。当后端调用 Java 函数时，监视器将被释放，然后在调用返回时立即恢复。来自 Java 的所有呼叫到后端代码都在同一个锁上同步。 这确保一次只能有一个线程可以从 Java 调用后端，并且只能在后端正在等待返回 Java 函数调用的时候调用。

### 异常处理

Java 经常使用 try / catch / finally 块。HashData 数据库有时会使用一个异常机制来调用 excelongjmp 来将控件转移到已知状态。 这样的跳转通常会有效地绕过 JVM。

#### 解决方案

后端现在允许使用宏 PG\_TRY/PG\_CATCH/PG\_END\_TRY 捕获错误， 并且在 catch 块中，可以使用 ErrorData 结构检查错误。 PL/Java 实现了一个名为 org.postgresql.pljava.ServerException 的 java.sql.SQLException 子类.，可以从该异常中检索和检查 ErrorData。允许捕获处理程序发送回滚到保存点。回滚成功后，执行可以继续。

### Java 垃圾收集器与 palloc（）和堆栈分配

原始类型始终按值传递。包括 String type \(这是必需的，因为 Java 使用双字节字符\)。复杂类型通常包含在 Java 对象中并通过引用传递。例如，Java 对象可以包含指向 palloced 或 stack 分配的内存的指针， 并使用本机 JNI 调用来提取和操作数据。一旦调用结束，这些数据将变得陈旧。进一步尝试访问这些数据最多只会产生非常不可预知的结果，但更有可能导致内存错误和崩溃。

#### 解决方案

PL/Java 包含的代码可以确保当 MemoryContext 或堆栈分配超出范围时，陈旧的指针被清除。 Java 包装器对象可能会生效，但是使用它们的任何尝试将导致陈旧的本机处理异常。

## 示例

以下简单的 Java 示例创建一个包含单个方法并运行该方法的 JAR 文件。

> 注意： 该示例需要 Java SDK 来编译 Java 文件。

以下方法返回一个子字符串。

```
{
public static String substring(String text, int beginIndex,
  int endIndex)
    {
    return text.substring(beginIndex, endIndex);
    }
}
```

在文本文件 example.class 中输入这些 Java 代码。

manifest.txt 文件的内容：

```
Manifest-Version: 1.0
Main-Class: Example
Specification-Title: "Example"
Specification-Version: "1.0"
Created-By: 1.6.0_35-b10-428-11M3811
Build-Date: 01/20/2013 10:09 AM
```

编译 java 代码：

```
javac *.java
```

创建名为 analytics.jar 的 JAR 存档，其中包含 JAR 中的类文件和清单文件 MANIFEST 文件。

```
jar cfm analytics.jar manifest.txt *.class
```

将 jar 文件上传到 HashData 主机。

运行 gpscp 将 jar 文件复制到 HashData Java 目录的实用程序。 使用 -f 选项指定包含主节点和分段主机列表的文件。

```
gpscp -f gphosts_file analytics.jar 
=:/usr/local/HashData-db/lib/postgresql/java/
```

使用 gpconfig 程序设置 HashData pljava\_classpath 服务器配置参数。该参数列出已安装的 jar 文件。

```
gpconfig -c pljava_classpath -v 'analytics.jar'
```

运行 gpstop 实用程序 -u 选项重新加载配置文件。

```
gpstop -u
```

来自 psql 命令行, 运行以下命令显示已安装的 jar 文件。

```
show pljava_classpath
```

以下 SQL 命令创建一个表并定义一个 Java 函数来测试 jar 文件中的方法：

```
create table temp (a varchar) distributed randomly; 
insert into temp values ('my string'); 
--Example function 
create or replace function java_substring(varchar, int, int) 
returns varchar as 'Example.substring' language java; 
--Example execution 
select java_substring(a, 1, 5) from temp;
```

用户可以将内容放在一个文件 mysample.sql 中，并从 psql 命令行运行该命令:

```
> i mysample.sql
```

输出类似于：

```
java_substring
----------------
 y st
(1 row)
```

## 参考

The PL/Java Github wiki page - [https://github.com/tada/pljava/wiki](https://github.com/tada/pljava/wiki).

PL/Java 1.4.0 release - [https://github.com/tada/pljava/tree/B1\_4](https://github.com/tada/pljava/tree/B1_4).

