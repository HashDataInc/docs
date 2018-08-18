# 数据加密

本节的主题是描述如何使用HashData数据仓库的数据加密功能。

HashData 数据仓库中追加表(AO table)及追加列存表(AOCS table)中的数据存储于青云对象存储服务之上，为进一步保证数据安全性， HashData数据仓库支持对AO/AOCS表中数据的加密功能。

## 使用方式

### 通过ENCRYPTION存储选项控制

用户可以在创建AO或AOCS表时，指定ENCRYPTION存储选项：

1. ENCRYPTION=TRUE :  未来表中数据将会被加密存储
2. ENCRYPTION=FALSE : 未来表中数据将不会被加密

**创建加密AO表 示例**：

```
CREATE TABLE t1 (col0 int) 
WITH (APPENDONLY=TRUE, ... , ENCRYPTION=TRUE) 
DISTRIBUTED BY (col0); 
```

**创建加密AOCS表 示例**：

```
CREATE TABLE t1 (col0 int) 
WITH (APPENDONLY=TRUE, ORIENTATION=COLUMN, ..., ENCRYPTION=TRUE) 
DISTRIBUTED BY (col0); 
```

### 通过GUC值控制

当用户创建AO/AOCS表时，如果没有指定ENCRYPTION选项，则是否加密将由GUC值hashdata_skip_appendonly_encryption控制。

hashdata_skip_appendonly_encryption 默认为true， 即不对AO/AOCS表中数据进行加密， 用户可以通过以下命令开启追加表的默认加密功能。

```
set hashdata_skip_appendonly_encryption=false;
```

注意，ENCRYPTION存储选项相比hashdata_skip_appendonly_encryption拥有更高的优先级，hashdata_skip_appendonly_encryption只有在没有指定ENCRYPTION存储选项时才会生效。