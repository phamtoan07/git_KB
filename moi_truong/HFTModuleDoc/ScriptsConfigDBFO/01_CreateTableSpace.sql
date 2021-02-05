--- Sử dụng user có quyền SYSTEM hoặc SYS... để tạo TableSpace

--- Script tạo tablespace
--- tablespace name: ttusers
--- size: 4000 MB 
drop tablespace ttusers including contents and datafiles;
create tablespace ttusers datafile 'ttusers.dbf' SIZE 4000M;
--- hoặc có thể chọn đường dẫn file
--- create tablespace ttusers datafile '/usr/oracle/app/product/11.2.0/dbhome_1/dbs/ttusers.dbf' SIZE 4000M;
--- RAC
--- create tablespace ttusers datafile '+DATA/ORATTDB/DATAFILE/ttusers.dbf' SIZE 4000M;

