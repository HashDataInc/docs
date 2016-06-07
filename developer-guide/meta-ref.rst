:orphan:

.. include:: ../defines.hrst

System Catalog Reference
========================

This reference describes the Greenplum Database system catalog tables
and views. System tables prefixed with *gp\_* relate to the parallel
features of Greenplum Database. Tables prefixed with *pg\_* are either
standard PostgreSQL system catalog tables supported in Greenplum
Database, or are related to features Greenplum that provides to enhance
PostgreSQL for data warehousing workloads. Note that the global system
catalog for Greenplum Database resides on the master instance.

System Tables
-------------

System Views
------------

System Catalogs Definitions
---------------------------

gp\_configuration\_history
~~~~~~~~~~~~~~~~~~~~~~~~~~

gp\_db\_interfaces
~~~~~~~~~~~~~~~~~~

gp\_distributed\_log
~~~~~~~~~~~~~~~~~~~~

gp\_distributed\_xacts
~~~~~~~~~~~~~~~~~~~~~~

gp\_distribution\_policy
~~~~~~~~~~~~~~~~~~~~~~~~

gpexpand.expansion\_progress
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gpexpand.status
~~~~~~~~~~~~~~~

gpexpand.status\_detail
~~~~~~~~~~~~~~~~~~~~~~~

gp\_fastsequence
~~~~~~~~~~~~~~~~

gp\_fault\_strategy
~~~~~~~~~~~~~~~~~~~

gp\_global\_sequence
~~~~~~~~~~~~~~~~~~~~

gp\_id
~~~~~~

gp\_interfaces
~~~~~~~~~~~~~~

gp\_persistent\_database\_node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gp\_persistent\_filespace\_node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gp\_persistent\_relation\_node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gp\_persistent\_tablespace\_node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gp\_pgdatabase
~~~~~~~~~~~~~~

gp\_relation\_node
~~~~~~~~~~~~~~~~~~

gp\_resqueue\_status
~~~~~~~~~~~~~~~~~~~~

gp\_san\_configuration
~~~~~~~~~~~~~~~~~~~~~~

gp\_segment\_configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~

gp\_transaction\_log
~~~~~~~~~~~~~~~~~~~~

gp\_version\_at\_initdb
~~~~~~~~~~~~~~~~~~~~~~~

pg\_aggregate
~~~~~~~~~~~~~

pg\_am
~~~~~~

pg\_amop
~~~~~~~~

pg\_amproc
~~~~~~~~~~

pg\_appendonly
~~~~~~~~~~~~~~

pg\_attrdef
~~~~~~~~~~~

pg\_attribute
~~~~~~~~~~~~~

pg\_attribute\_encoding
~~~~~~~~~~~~~~~~~~~~~~~

pg\_auth\_members
~~~~~~~~~~~~~~~~~

pg\_authid
~~~~~~~~~~

pg\_cast
~~~~~~~~

pg\_class
~~~~~~~~~

pg\_compression
~~~~~~~~~~~~~~~

pg\_constraint
~~~~~~~~~~~~~~

pg\_conversion
~~~~~~~~~~~~~~

pg\_database
~~~~~~~~~~~~

pg\_depend
~~~~~~~~~~

pg\_description
~~~~~~~~~~~~~~~

pg\_exttable
~~~~~~~~~~~~

pg\_filespace
~~~~~~~~~~~~~

pg\_filespace\_entry
~~~~~~~~~~~~~~~~~~~~

pg\_index
~~~~~~~~~

pg\_inherits
~~~~~~~~~~~~

pg\_language
~~~~~~~~~~~~

pg\_largeobject
~~~~~~~~~~~~~~~

pg\_listener
~~~~~~~~~~~~

pg\_locks
~~~~~~~~~

pg\_namespace
~~~~~~~~~~~~~

pg\_opclass
~~~~~~~~~~~

pg\_operator
~~~~~~~~~~~~

pg\_partition
~~~~~~~~~~~~~

pg\_partition\_columns
~~~~~~~~~~~~~~~~~~~~~~

pg\_partition\_encoding
~~~~~~~~~~~~~~~~~~~~~~~

pg\_partition\_rule
~~~~~~~~~~~~~~~~~~~

pg\_partition\_templates
~~~~~~~~~~~~~~~~~~~~~~~~

pg\_partitions
~~~~~~~~~~~~~~

pg\_pltemplate
~~~~~~~~~~~~~~

pg\_proc
~~~~~~~~

pg\_resourcetype
~~~~~~~~~~~~~~~~

pg\_resqueue
~~~~~~~~~~~~

pg\_resqueue\_attributes
~~~~~~~~~~~~~~~~~~~~~~~~

pg\_resqueuecapability
~~~~~~~~~~~~~~~~~~~~~~

pg\_rewrite
~~~~~~~~~~~

pg\_roles
~~~~~~~~~

pg\_shdepend
~~~~~~~~~~~~

pg\_shdescription
~~~~~~~~~~~~~~~~~

pg\_stat\_activity
~~~~~~~~~~~~~~~~~~

pg\_stat\_last\_operation
~~~~~~~~~~~~~~~~~~~~~~~~~

pg\_stat\_last\_shoperation
~~~~~~~~~~~~~~~~~~~~~~~~~~~

pg\_stat\_operations
~~~~~~~~~~~~~~~~~~~~

pg\_stat\_partition\_operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

pg\_stat\_replication
~~~~~~~~~~~~~~~~~~~~~

pg\_statistic
~~~~~~~~~~~~~

pg\_stat\_resqueues
~~~~~~~~~~~~~~~~~~~

pg\_tablespace
~~~~~~~~~~~~~~

pg\_trigger
~~~~~~~~~~~

pg\_type
~~~~~~~~

pg\_type\_encoding
~~~~~~~~~~~~~~~~~~

pg\_user\_mapping
~~~~~~~~~~~~~~~~~

pg\_window
~~~~~~~~~~

