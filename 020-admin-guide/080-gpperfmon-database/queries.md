# queries\_\*

queries\_\* 表存储高级的查询状态信息。

tmid、ssid 以及 ccnt 列是唯一标识一个特定查询的组合键。

有三种查询表，所有表都有相同的列：

* queries\_now 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。在从数据收集代理收集数据和自动提交到queries\_history表之间的时段，当前查询状态存储在queries\_now中。

* queries\_tail 是一个外部表，其数据文件存储在 $MASTER\_DATA\_DIRECTORY/gpperfmon/data 中。这是一个过渡表，其中存放着已经从 queries\_now 中清除但是还没有提交到 queries\_history 的查询状态数据。它通常只包含了几分钟的数据。

* queries\_history 是一个常规表，它存储数据库范围的历史查询状态数据。它被预分区为每月的分区表。分区会根据需要进行两个月的增量添加。管理员必须要删除那些不再需要的月份的旧分区。

| Column | Type | Description |
| :--- | :--- | :--- |
| ctime | timestamp | 该行被创建的时间。 |
| tmid | int | 一个特定查询的时间标识符。与一个查询关联的所有记录将有同样的tmid。 |
| ssid | int | gp\_session\_id所显示的会话id。与一个查询关联的所有记录将有同样的ssid。 |
| ccnt | int | gp\_command\_count所显示的当前会话的命令数。与一个查询关联的所有记录将有同样的ccnt。 |
| username | varchar\(64\) | 发出该查询的 HashData 角色名。 |
| db | varchar\(64\) | 被查询的数据库名。 |
| cost | int | 在这个版本中没有实现。 |
| tsubmit | timestamp | 查询被提交的时间。 |
| tstart | timestamp | 查询开始的时间。 |
| tfinish | timestamp | 查询结束的时间。 |
| status | varchar\(64\) | 查询的状态 -- start、done或者 abort。 |
| rows\_out | bigint | 该查询输出的行。 |
| cpu\_elapsed | bigint | 所有Segment上执行该查询的所有进程使用的CPU总量（以秒计）。它是在数据库系统中所有活动主Segment的CPU使用值的综合。注意：如果查询的执行时间短于定额的值，那么该值被记录为0。这种情况即使在查询执行时间大于min\_query\_time的值以及这个值低于定额的值时也会发生。 |
| cpu\_currpct | float | 执行此查询的所有进程的当前CPU 平均百分比。运行在每个Segment上的所有进程的百分比都会被用于计算平均，然后所有那些值的平均值被算出来提供这个度量。在历史和尾部数据中，当前CPU的百分比平均数总为零。 |
| skew\_cpu | float | 显示此查询在系统中的处理倾斜量。当一个Segment为一个查询执行不成比例的处理量时，就发生了处理/CPU倾斜。这个值是所有Segment上这一查询的CPU%度量的变异系数乘以100。例如, .95的值显示为95。 |
| skew\_rows | float | 显示在系统中行倾斜的量。当一个Segment为一个查询产生不成比例的行数时，就发生了行倾斜。这个值是所有Segment上这一查询的rows\_in度量的变异系数乘以100。例如, .95的值显示为95。 |
| query\_hash | bigint | 在这个版本中没有实现。 |
| query\_text | text | 查询的SQL文本。 |
| query\_plan | text | 查询计划的文本。在这个版本中没有实现。 |
| application\_name | varchar\(64\) | 应用名。 |
| rsqname | varchar\(64\) | 资源队列名。 |
| rqppriority | varchar\(64\) | 查询的优先级--max、high、med、low、或 min。 |


