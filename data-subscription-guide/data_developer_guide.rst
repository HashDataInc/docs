.. _data_developer_guide:

数据订阅服务 开发指南
========================

数据订阅服务 内部采用 Debezium 结合 Kafka 实现。Debezium 能够监控并且记录 MySQL 数据库的所有行级的变化。当它第一次连接到 MySQL 服务器的时候，它会读取所有数据库的一致性快照。快照完成之后，它会不断读取被提交到 MySQL 5.6 版本或之后版本数据库的数据变化，并且生成相应的 create、update 和 delete 事件。所有的事件都会按照数据库表分类到不同的 Kafka topic 中，然后再被其他应用或服务消费。

综述
------
MySQL 的二进制日志文件，即 binlog，按照提交顺序记录了所有的数据库操作，包括数据表的模式变化和表中数据的变化。MySQL 的复制和恢复以 binlog 为基础。

Debezium 能够读取并处理 MySQL 的二进制日志文件，从而获取数据改变的信息和事件发生的顺序。读取日志文件之后，它会对日志中每一个行级的 create、update 和 delete 操作生成一个对应的事件，并且将这些事件按照不同的表名存储到不同的 Kafka topic 中。用户的客户端应用可以读取相应表对应的 Kafka topic，获取事件信息，并且对每一个行级事件做出反馈。

MySQL 通常会设置为在一段时间后默认清理二进制日志文件，这意味着它的日志文件不会包含全部数据库变化的历史事件。因此，当 Debezium 首次连接到一个 MySQL 服务器，它会尝试获取每个数据库的一致性快照。当 Debezium 完成快照，它会从快照获取位置开始读取二进制日志文件。这样做能够保证不会丢失读取快照过程中数据库产生的变化事件，保证了数据一致性。

Debezium 具有很高的容错性。当它读取日志文件并且产生相应事件时，它会同时记录读取到的日志文件位置。如果 Debezium 由于某些原因停止工作（比如通信失败，网络错误），当重启的时候，它会直接从记录到的日志文件位置继续读取。

配置 MySQL
------------
在 数据订阅服务 成功监控 MySQL 变化之前，必须配置 MySQL 使其采用行级日志模式，并且创建一个具有特定权限的数据库用户。

配置 binlog
~~~~~~~~~~~~~~~
采用行级二进制日志文件模式，更多细节可参考 `MySQL 文档`_。通常在 MySQL 服务器的配置文件里进行配置，并且和以下配置语句类似::

  server-id         = 223344
  log_bin           = mysql-bin
  binlog_format     = row
  binlog_row_image  = full
  expire_logs_days  = 10

其中：

- **server-id**：同一个集群中的每个MySQL服务器和复制客户端必须具有唯一的 server id。
- **log_bin**：二进制日志文件的 base name。
- **binlog_format**：必须为 *row* 或 *ROW*。
- **binlog_row_image**：必须为 *full* 或 *FULL*。
- **expire_logs_days**：自动清理日志文件的时间。默认值为0，意味着“不自动清理日志文件”，所以注意为你的环境设置合适的值。

.. _MySQL 文档: http://dev.mysql.com/doc/refman/5.7/en/replication-options.html

创建MySQL用户
~~~~~~~~~~~~~~~
创建的 MySQL 用户必须对 Debezium 要监控的数据库拥有以下权限：

- **SELECT**：使得 Debezium 能够从表中选取行；仅当快照时使用。
- **RELOAD**：使得 Debezium 能够 *FLUSH* 声明去清理或重载各种内部缓存， *FLUSH* 表，或者获取锁；仅当快照时使用。
- **SHOW DATABASES**：使得 Debezium 能够通过 *SHOW DATABASE* 声明获取数据库名称；仅当快照时使用。
- **REPLICATION SLAVE**：使得 Debezium 能够连接到 MySQL 服务器并且读取二进制日志文件；总是需要。
- **REPLICATION CLIENT**：启用 *SHOW MASTER STATUS*， *SHOW SLAVE STATUS*，和 *SHOW BINARY LOGS*；总是需要。

以下语句为示例，为用户名为 *debezium*，密码为 *dbz* 的用户赋予以上权限::

  GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium' IDENTIFIED BY 'dbz';

数据订阅服务 工作原理
-----------------------
这部分文档详细解释了 数据订阅服务 工作原理中的以下方面：

- 追踪表结构的变化
- 读取二进制日志文件
- 把二进制日志文件的事件转化为 Debezium 的事件
- 错误处理

数据库模式 Schema History
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
当一个数据库客户端对数据库发起一个查询请求，它会采用数据库当前的模式。但是数据库的模式随时可能改变，这意味着 Debezium 必须在每一个 create、update 和 delete 操作被记录的时刻都知道数据库的模式信息。它不能够直接使用当前的模式，因为它可能处理的是模式变化之前的旧信息。幸运的是，MySQL 在它的二进制日志文件里记录了数据库模式定义语言（DDL statements）。当 Debezium 读到这些 DDL 语句时，它会解析这些语句并在存储中更新一个相应的表的模式，它还会把所有的 DDL 语句和相应的所在二进制文件的位置记录到一个单独的 database history Kafka topic 中。

当 Debezium 在崩溃或正常停止后重启，它会从一个特定的位置或时间点开始读取日志文。Debezium 通过读取 database history Kafka topic 获取 DDL 语句来重建那个特定位置或时间点的数据表结构。

这个 database history topic 是仅仅为 Debezium 而设计的，Debezium 可以选择性地生成 *schema change events* 到另外一个专为消费者设计的 topic。这部分将在 `Schema Change Topic`_ 部分详细阐述。

.. _Schema Change Topic:

读取 MySQL 日志文件
~~~~~~~~~~~~~~~~~~~~~
Debezium 把绝大多数运行时间花费在读取二进制日志文件上。

当 Debezium 读取日志文件时，它会把日志事件转化为 Debezium 的 create、updata 或 delete 事件，并包括该事件在日志文件中的位置。Debezium 会将这些事件发送给相应的 Kafka topic。Kafka 会读取 Debezium 记录在每个事件中的 *offset* 信息，并且周期性地在 Kafka topic 中更新最新的 *offset*。

当 Kafka 正常停止，它会停止依赖于它的 Debezium，把所有未提交的事件推送到 Kafka，并且记录每个 Debezium 收到的最后的 *offset*。重启时，Kafka 读取 Debezium 最后记录的 *offset* 信息，并且从该位置启动 Debezium。Debezium 用二进制日志文件名称和文件中的位置去请求 MySQL 从该位置开始发送日志文件事件信息。

Kafka Topics
~~~~~~~~~~~~~~~~

Topics 名字
***************
Debezium 把一个表的所有 create、update 和 delete 事件记录到一个单独的 Kafka topic 中。Kafka topic 的名字形式为 *namespace.databaseName.tableName*，其中 *namespace* 是启动服务时要求填写的 *namespace* 参数， *databaseName* 是数据库的名称， *tableName* 是数据表的名称。

比如，考虑一个名字为 *inverntory* 的数据库，它包括四张表： *products*， *products_on_hand*， *customers*，和 *orders*。如果这个数据库的 *namespace* 被配置为 *fulfillment*，那么这个 Connector 会把这四张表产生的事件分别生产到四个 Kafka topic 中：

- *fulfillment.inventory.products*
- *fulfillment.inventory.products_on_hand*
- *fulfillment.inventory.customers*
- *fulfillment.inventory.orders*

Schema Change Topic
************************
通常消费者会需要获取数据库模式改变的信息，Debezium 能够通过配置去生产 *schema change events*。当启用该配置时，Debezium 会把所有的数据库模式改变事件写入一个叫做 *namespace* 的 Kafka topic， *namespace* 就是前文中的 *namespace* 配置参数。在前文的例子中，模式改变事件会被记录到 topic *fulfillment* 中。

事件 Events
~~~~~~~~~~~~~~~~
Debezium 产生的所有事件都有一个 key 和一个 value，key 和 value 的结构根据不同的表结构变化。所有消息的 key 和 value 都由两部分组成： *schema* 和 *payload*。 *schema* 描述 *payload* 的结构， *payload* 包含真正的信息。

事件的 key
******************
对于一个给定的表，事件的 key 包括表的主键。比如 *inventory* 数据库中的 *customers* 表定义如下::

  CREATE TABLE customers (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE KEY
  ) AUTO_INCREMENT=1001;

在这个定义下， *customers* 表的事件都有相同的 key，JSON 格式如下::

  {
    "schema": {
      "type": "struct",
      "name": "mysql-server-1.inventory.customers.Key"
      "optional": false,
      "fields": [
        {
          "field": "id",
          "type": "int32",
          "optional": false
        }
      ]
    },
    "payload": {
      "id": 1004
    }
  }

key 的 *schema* 部分描述了 *payload* 部分的内容，以上例子描述了 *payload* 是不可选的，并且被一个名字是 *mysql-server-1.inventory.customers.Key* 的结构所定义，其中有一个必须项叫做 *id*，它的类型是 *int32*。如果我们看下面的 *payload* 内容，可以看到它确实是一个只包含 *id* 的结构（也即 JSON 对象），它的值是 *1004*。

因此，我们可以认为这个 key 描述了 *inventory.customers* 表中的一行，这一行的 *id* 主键值是 *1004*，并且这个数据库的 *namespace* 是 *mysql-server-1*。

注意：如果一张表没有主键，那么它的事件的 key 会被设为 null。

事件的 value
********************
相比事件的 key，它的 value 要复杂一些。同 key 结构类似，value 也包含一个 *schema* 部分和一个 *payload* 部分。从 Debezium 0.2 开始， *payload* 部分由一个叫做 *envelope* 的结构组成，这个结构包含如下项：

- **op**：必须项，包括一个用来描述操作类型的字符串。 *c* 表示 crete 或 insert， *u* 表示 update， *d* 表示 delete， *r* 表示 read。
- **before**：可选项，描述这个事件发生前这一行的状态。它的结构由 *mysql-server-1.inventory.customers.Value* Kafka schema 描述，这个结构被用来描述 *inventory.customers* 表里的所有行。
- **after**：可选项，描述这个事件发生后这一行的状态。同上，它的结构由 *mysql-server-1.inventory.customers.Value* 描述。
- **source**：必须项，描述这个事件的 source metadata，在 MySQL 中包括如下项：Debezium 的连接器类型名称，事件记录的二进制日志文件名，事件在日志文件中的位置，事件中的哪一行（如果这个事件多于一行），这个事件是否是快照的一部分，以及如果可以获取的话，MySQL 的 server ID 和时间戳。
- **ts_ms**：可选项，描述 Debezium 处理这个事件的时间（使用的是运行 Kafka 的主机的系统时钟）。

同样， value 的 *schema* 部分也由一个 *envelope* 结构组成。

如下是 *customer* 表中一个事件的 value::

  {
    "schema": {
      "type": "struct",
      "optional": false,
      "name": "mysql-server-1.inventory.customers.Envelope",
      "version": 1,
      "fields": [
        {
          "field": "op",
          "type": "string",
          "optional": false
        },
        {
          "field": "before",
          "type": "struct",
          "optional": true,
          "name": "mysql-server-1.inventory.customers.Value",
          "fields": [
            {
              "type": "int32",
              "optional": false,
              "field": "id"
            },
            {
              "type": "string",
              "optional": false,
              "field": "first_name"
            },
            {
              "type": "string",
              "optional": false,
              "field": "last_name"
            },
            {
              "type": "string",
              "optional": false,
              "field": "email"
            }
          ]
        },
        {
          "field": "after",
          "type": "struct",
          "name": "mysql-server-1.inventory.customers.Value",
          "optional": true,
          "fields": [
            {
              "type": "int32",
              "optional": false,
              "field": "id"
            },
            {
              "type": "string",
              "optional": false,
              "field": "first_name"
            },
            {
              "type": "string",
              "optional": false,
              "field": "last_name"
            },
            {
              "type": "string",
              "optional": false,
              "field": "email"
            }
          ]
        },
        {
          "field": "source",
          "type": "struct",
          "name": "io.debezium.connector.mysql.Source",
          "optional": false,
          "fields": [
            {
              "type": "string",
              "optional": false,
              "field": "name"
            },
            {
              "type": "int64",
              "optional": false,
              "field": "server_id"
            },
            {
              "type": "int64",
              "optional": false,
              "field": "ts_sec"
            },
            {
              "type": "string",
              "optional": true,
              "field": "gtid"
            },
            {
              "type": "string",
              "optional": false,
              "field": "file"
            },
            {
              "type": "int64",
              "optional": false,
              "field": "pos"
            },
            {
              "type": "int32",
              "optional": false,
              "field": "row"
            },
            {
              "type": "boolean",
              "optional": true,
              "field": "snapshot"
            }
          ]
        },
        {
          "field": "ts_ms",
          "type": "int64",
          "optional": true
        }
      ]
    },
    "payload": {
      "op": "c",
      "ts_ms": 1465491411815,
      "before": null,
      "after": {
        "id": 1004,
        "first_name": "Anne",
        "last_name": "Kretchmar",
        "email": "annek@noanswer.org"
      },
      "source": {
        "name": "mysql-server-1",
        "server_id": 0,
        "ts_sec": 0,
        "gtid": null,
        "file": "mysql-bin.000003",
        "pos": 154,
        "row": 0,
        "snapshot": true
      }
    }
  }

在 value 中的 *schema* 部分，我们可以看到 *envelope* 的 schema， *source* 的 schema（对每一个 MySQL 是特定的），和 *before* 以及 *after* 的 schema （对每一张表是特定的）。

在 value 的 *payload* 部分，我们可以看到这个事件的具体信息。以上例子描述了在表中创建一行（因为 *op = c*），并且 *after* 项中描述了新创建行的 *id*， *first_name*， *last_name* 和 *email*。

上面是 create 事件的 value 例子，同一张表的 update 事件的 value 会和以上 create 事件有完全相同 *schema*，它的 *payload* 会和 create 事件结构相同但值不同。例如::

  {
    "schema": { ... },
    "payload": {
      "before": {
        "id": 1004,
        "first_name": "Anne",
        "last_name": "Kretchmar",
        "email": "annek@noanswer.org"
      },
      "after": {
        "id": 1004,
        "first_name": "Anne Marie",
        "last_name": "Kretchmar",
        "email": "annek@noanswer.org"
      },
      "source": {
        "name": "mysql-server-1",
        "server_id": 223344,
        "ts_sec": 1465581,
        "gtid": null,
        "file": "mysql-bin.000003",
        "pos": 484,
        "row": 0,
        "snapshot": null
      },
      "op": "u",
      "ts_ms": 1465581029523
    }
  }

比较 update 事件和 create 事件的 value，我们可以看到 update 在 *payload* 中和 create 有以下几点不同：

- *op* 值为 *u*，表名这一行的改变是因为一个 update 操作
- *before* 值描述的是更新前这一行的信息
- *after* 值描述更新后这一行的信息，比如上面例子中更新后 *first_name* 值变成了 *Anne Marie*
- *source* 的结构和之前一样，但是值有所不同，因为这两个事件在日志文件中的位置不同
- *ts_ms* 描述了 Debezium 处理这个事件的时间戳

比较了 create 事件和 update 事件，接下来是 delete 事件。同样，value 的 *schema* 部分完全相同::

  {
    "schema": { ... },
    "payload": {
      "before": {
        "id": 1004,
        "first_name": "Anne Marie",
        "last_name": "Kretchmar",
        "email": "annek@noanswer.org"
      },
      "after": null,
      "source": {
        "name": "mysql-server-1",
        "server_id": 223344,
        "ts_sec": 1465581,
        "gtid": null,
        "file": "mysql-bin.000003",
        "pos": 805,
        "row": 0,
        "snapshot": null
      },
      "op": "d",
      "ts_ms": 1465581902461
    }
  }

*payload* 部分，delete 与 create 和 update 有如下不同：

- *op* 部分的值为 *d*，说明这一行被删除
- *before* 部分描述这一行删除前的信息
- *after* 部分为 null， 说明这一行不再存在
- *source* 部分和之前类似，不同的地方在于 *ts_sec* 和 *pos* 发生变化
- *ts_ms* 部分描述了 Debezium 处理这个时间的时间戳

Debezium 的事件模式适用于 `Kafka log compaction`_，它允许 Kafka 删除一些旧信息，只要 Kafka 还保留着每一个 key 的最新信息。这使得 Kafka 可以在保证 Kafka topic 保存了数据集的所有信息的前提下，回收利用存储空间。

当一行被删除时，Kafka 可以移除和这个删除事件的 key 相同的所有之前事件信息，这通过一个 value 是 null 的特殊事件来实现。Debezium 在产生一个 delete 事件之后，会紧接着产生一个特殊的 *tombstone* 事件，这个事件的 value 为 null，Kafka 可以识别出这个事件并实现日志压缩。

当表中一行数据的主键信息被更新时，这一行事件的 key 的值发生变化，Debezium 处理的方式是产生三个事件：一个 delete 事件，一个包括旧的 key 值的 *tombstome* 事件，和一个包括新的 key 值的 insert 事件。

.. _kafka log compaction: https://cwiki.apache.org/confluence/display/KAFKA/Log+Compaction

错误处理
~~~~~~~~~~
当系统正常运行时，Debezium 提供 *exactly once delivery* 的事件处理模式。当错误发生时，为了保证信息不丢失，Debezium 可能会重复处理部分事件。因此在非正常情况下，Debezium 同 Kafka 一样采用 *at least once delivery* 的事件处理模式。

以下部分详细描述了 数据订阅服务 如何处理各种类型的错误。

配置与启动错误
****************
当依赖的 Zookeeper 不可用，或依赖的 Kafka 不可用，或当 Debezium 无法成功连接到 MySQL（比如 MySQL ip 无法连接，用户名或密码错误），它会在日志中报错并停止运行。

MySQL 错误
**************
当服务正常运行过程中，它连接到的 MySQL 服务器发生错误，服务会在日志中报错并停止。当 MySQL 服务器恢复正常后，重启服务即可。

Kafka Connect 进程错误
*************************
如果 Kafka Connect 进程意外停止，它运行的 Connector tasks 也会停止，并且不会记录到最新的 *offset* 信息。服务监测到 connector 和 task 的异常状态，会报错尝试重启服务。重启服务后，Debezium 会从之前记录的位置重新开始，所以有可能产生重复的事件。

Kafka 或 Zookeeper 服务错误
******************************
当依赖的 Kafka 和 Zookeeper 服务发生错误，Connector 和 task 的状态均会变为异常，服务监测到异常状态会报出错误信息，并尝试重启服务。

  更多信息请参考：

  - `Debezium`_
  - `Debezium MySQL Connector`_
  - `Kafka`_
  - `Kafka Connect`_

.. _Debezium: http://debezium.io/docs/tutorial/
.. _Debezium MySQL Connector: http://debezium.io/docs/connectors/mysql/
.. _Kafka: http://kafka.apache.org/documentation/#gettingStarted
.. _Kafka Connect: https://docs.confluent.io/current/connect/index.html
