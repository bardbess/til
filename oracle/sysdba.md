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
Dropping/Killing a user session
```plsql
  select sid,serial# from v$session where username = '';
  alter system kill session '<sid>,<serial#>';
```
Disable/Enable new connections from being created
```plsql
  alter system disable/enable restricted session;
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
