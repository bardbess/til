# Admin SQL

Make sure the oracle variables are correctly set up before making changes to the database. `. oraenv`

Use `lnsctl` to control the tnslistener

Find out the database name
```plsql
  select name from v$database;
```
Find the database location
```plsql
  select file_name from dba_data_files;
```
Find database dump location
```plsql
  show parameter user_dump_dest;
```

## Sessions

Dropping/Killing a user session
```plsql
  select sid,serial# from v$session where username = '';
  alter system kill session '<sid>,<serial#>';
```
Disable/Enable new connections from being created
```plsql
  alter system disable/enable restricted session;
```
Increasing oracle SESSION parameter `ORA-00018 maximum number of sessions exceeded`

If you are planning on increasing "sessions" you should also plan to increase "processes" and "transactions" parameters.
A basic formula for determining  these parameter values is as follows

> processes=x
> sessions=x*1.1+5
> transactions=sessions*1.1
 
Check Current Setting of Parameters
```plsql
  show parameter sessions
  show parameter processes
  show parameter transactions
```
  
Parameters cant be modified in memory. You have to modify the spfile (scope=spfile) and bounce the instance.
```plsql
  alter system set processes=500 scope=spfile;
  alter system set sessions=555 scope=spfile;
  alter system set transactions=610 scope=spfile;
  shutdown abort
  startup 
```
----
Creating a public database link
```plsql
   create public database link linkname using 'databasename';
```
Create a database directory
```plsql
  create DIRECTORY dmpdir as '/tmp';
  grant read,write on DIRECTORY dmpdir to user1,user2;
```
Drop a database directory
```plsql
  drop DIRECTORY dmpdir;
```
Find a database directory
```plsql
  select directory_path from dba_directories
  where directory_name = 'DMPDIR';
```
----
datadump help. `impdp help=y`

Datapump over a database link
```
  impdp dbname/dbpass DIRECTORY=dmpdir TABLE_EXIST_ACTION=[TRUNCATE/APPEND] CONTENT=METADATA_ONLY REMAP_SCHEMA=old:new DATA_OPTIONS=SKIP_CONSTRAINT_ERRORS NETWORK_LINK=linkname EXCLUDE=TRIGGER:\"LIKE \'%_CHECK\'\"
```
Export to an older version of oracle from a newer version
```bash
  expdp dbname/dbpass compression=all directory=backups dumpfile=dbname_v11.dmp version=11.2
```
### Tablespace

To get a list of tablespaces, in this example temp tablespaces.

```plsql
  SELECT tablespace_name, file_name, bytes FROM dba_temp_files WHERE tablespace_name like 'TEMP%';
```

**Shrink the temporary tablespace** - rather than having to drop and recreate a smaller tablespace oracle introduced this handy command in 11g.

```plsql
  alter tablespace <your_temp_ts> shrink space keep 128M;
```

** Finding the largest tables **

```plsql
  select * from ( select owner, segment_name, bytes/1024/1024 Size_Mb from dba_segments order by bytes/1024/1024  DESC ) where rownum <= 20
```


