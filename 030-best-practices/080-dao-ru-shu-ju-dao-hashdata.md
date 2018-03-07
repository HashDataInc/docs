## 数据库导入

HashData支持各种工具从其它数据库导入数据。

* IBM DataStage：商业解决方案。
  [https://www.informatica.com/](https://www.informatica.com/)
* Infomatica PowerCenter: 商业解决方案。
  [https://www.ibm.com/us-en/marketplace/datastage](https://www.ibm.com/us-en/marketplace/datastage)
* Pentaho Data Integration（Kettle）：开源解决方案。
  [https://github.com/pentaho/pentaho-kettle](https://github.com/pentaho/pentaho-kettle)
* DataX \(HashData Release\)：开源解决方案。
  [https://github.com/HashDataInc/DataX](https://github.com/HashDataInc/DataX)

### 4.1.8.1.1. DataX\(HashData Release\)

* DataX\(HashData Release\)和Alibaba DataX有何不同？

  DataX 是阿里巴巴集团内被广泛使用的离线数据同步工具/平台，实现包括 MySQL、Oracle、HDFS、Hive、OceanBase、HBase、OTS、ODPS 等各种异构数据源之间高效的数据同步功能。DataX\(HashData Release\)在开源的DataX基础上，针对GPDB Writer专门做了性能优化，可以达到10X写入速度。

* 导入HashData该选择哪种Writer？

  GPDB Writer，详细参考：

[https://github.com/HashDataInc/DataX/blob/master/gpdbwriter/doc/gpdbwriter.md](https://github.com/HashDataInc/DataX/blob/master/gpdbwriter/doc/gpdbwriter.md)

## 4.1.8.2. Kafka导入

通过Kafka Comsumer组件读取数据，然后以Copy模式批量写入HashData.

关于Kafka Comsumer如何读取数据，参考Kafka官方文档：[http://kafka.apache.org/10/documentation/](http://kafka.apache.org/10/documentation/)

### 4.1.8.2.1. Java

Copy模式写入示例如下

```
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;

import org.postgresql.copy.CopyManager;
import org.postgresql.core.BaseConnection;

public class PgSqlJdbcCopyStreamsExample {

  public static void main(String[] args) throws Exception {

      if(args.length!=4) {
          System.out.println("Please specify database URL, user, password and file on the command line.");
          System.out.println("Like this: jdbc:postgresql://localhost:5432/test test password file");
      } else {

          System.err.println("Loading driver");
          Class.forName("org.postgresql.Driver");

          System.err.println("Connecting to " + args[0]);
          Connection con = DriverManager.getConnection(args[0],args[1],args[2]);

          System.err.println("Copying text data rows from stdin");

          CopyManager copyManager = new CopyManager((BaseConnection) con);

          FileReader fileReader = new FileReader(args[3]);
          copyManager.copyIn("COPY t FROM STDIN", fileReader );

          System.err.println("Done.");
        }
   }
}
```

关于CopyManager详细参考：[https://jdbc.postgresql.org/documentation/publicapi/org/postgresql/copy/CopyManager.html](https://jdbc.postgresql.org/documentation/publicapi/org/postgresql/copy/CopyManager.html)

### 4.1.8.2.2. GoLang

Copy模式写入示例如下:

```
txn, err := db.Begin()
if err != nil {
        log.Fatal(err)
}

stmt, err := txn.Prepare(pq.CopyIn("users", "name", "age"))
if err != nil {
        log.Fatal(err)
}

for _, user := range users {
      _, err = stmt.Exec(user.Name, int64(user.Age))
        if err != nil {
              log.Fatal(err)
        }
}

_, err = stmt.Exec()
if err != nil {
        log.Fatal(err)
}

err = stmt.Close()
if err != nil {
        log.Fatal(err)
}

err = txn.Commit()
if err != nil {
      log.Fatal(err)
}
```

关于pq包的使用，详细参考：[https://godoc.org/github.com/lib/pq\#hdr-Bulk\_imports](https://godoc.org/github.com/lib/pq#hdr-Bulk_imports)

