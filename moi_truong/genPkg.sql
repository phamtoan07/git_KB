delete tbl_txpks where tltxcd='DC01';
/
BEGIN
IF NOT fwpks_toolkit.fn_gentransactpkg('DC01','Y','N','N')
THEN
        dbms_output.put_line('Error! SELECT tlog to know why?');
END IF;
END;
/
select * from tbl_txpks where tltxcd='DC01';
rollback;
----
Fssc@123456
fssbo@123
----
git reset --hard 
git clean --f
touch .gitignore
git rm -r --cached .
git config --global credential.helper store
git add .
rm -f .git/index.lock
----
https://docs.fss.com.vn/pages/viewpage.action?pageId=13632347

----check F2. Bật cmd
ssh fo@192.168.1.163 -> điền pass
ttisql
connect "dsn=FOTEST;uid=FOTEST;pwd=FOTEST";
select * from accounts where acctno='0002009108';
exit
!ssh
ssh -p 8101 smx@localhost -> điền pass smx
log:tail  
----
mở firewall
sudo iptables -I INPUT -p tcp -m tcp --dport 1521 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 53397 -j ACCEPT

----
----git bàn giao
git pull origin 2020.11.0.7
git pull (master)
git checkout 2020.11.0.7
git merge master
git diff --name-only master > listfile.txt
/
begin
dbms_utility.compile_schema(schema => 'HOSTKBSVT', compile_all => false);
end;
/
select * from all_objects where owner = 'HOSTKBSVT' and status = 'INVALID';
/
git config http.postBuffer 524288000;
/
git gc --prune=now
/
--alter expire password --login by user sys
ALTER USER scott IDENTIFIED BY password;
/
--kill lock session git -> cannot merge
rm -f .git/index.lock
/
SELECT c.owner,c.object_name,c.object_type,b.sid,b.serial#,b.status,b.osuser,b.machine,
       'ALTER SYSTEM KILL SESSION ' || '''' || b.sid || ',' || b.serial# || ''''
FROM v$locked_object a,v$session b,dba_objects c
WHERE b.sid = a.session_id AND a.object_id = c.object_id;
/
SELECT
       s.blocking_session, 
       b.username blocking_username,
       b.osuser blocking_osuser,
     s.sid, 
   s.serial#, 
   s.seconds_in_wait,
   s.username
FROM
   v$session s,
   v$session b
WHERE
   s.blocking_session = b.sid
order by s.seconds_in_wait desc;
/
begin
update fapostmapexp set refid = fn_get_glmast_parent_id(tltxcd,alias,dorc);
update fapostmapval set refid = fn_get_glmast_parent_id(tltxcd,alias,dorc);
end;
/
--lay package bi drop
declare
BEGIN
  FOR rec in (
SELECT *
FROM all_source WHERE upper(name)='TXPKS_#9606EX')
loop
dbms_output.put(rec.text);
end loop;
end;
/
---
---truncate
SELECT owner, table_name, 'TRUNCATE TABLE ' || table_name || ' ;'  FROM dba_tables where owner = 'FUNDSHVTEST';

SELECT owner, table_name, 'TRUNCATE TABLE ' || table_name || ' ;'  FROM dba_tables where owner = 'FASYN';


DECLARE
BEGIN
  dbms_output.put_line('/');
  FOR rec in( 
select * from (
SELECT CHR(10) || 'BEGIN' || CHR(10) || 'reset_sequence(''' || SEQUENCE_NAME  || ''', 1);'
       || CHR(10) || 'END;' || CHR(10) || '/' srt
FROM
    dba_sequences
WHERE sequence_owner = 'FUNDSHVTEST' order by SEQUENCE_NAME ) )
 loop
   dbms_output.put_line(rec.srt);
 end loop;
END;
/
---
select count(*) No, ipaddress, wsname  from tllog 
group by ipaddress,wsname
order by No desc;
---
select count(*) No, ipaddress, wsname  from tllogall 
where to_date(trunc(createdt),'dd/mm/rrrr') >= '20-AUG-2020'
group by ipaddress,wsname 
order by No desc;
---
 select a.owner, segment_name,segment_type,bytes/1024/1024 MB, a.tablespace_name, 
 'truncate table '|| owner ||'.' || segment_name ||';'
 from dba_segments a
 where segment_type='TABLE' and OWNER = 'HOSTMSBST'
 ORDER BY bytes DESC ;
---
https://docs.fss.com.vn/pages/viewpage.action?pageId=6782996
---
/
---======
select rowc.TABLE_NAME, rowc.NUM_ROWS, dtsize.MB, col.column_name partiion_col,
       'TRUNCATE TABLE ' || rowc.TABLE_NAME || ';'
from
  user_tables rowc,
  (select a.owner, segment_name,segment_type,bytes/1024/1024 MB, a.tablespace_name, 'truncate table '|| owner ||'.' || segment_name ||';'
   from dba_segments a
   where segment_type='TABLE'
   and owner='HOSTKBSVT' ) dtsize,
   (SELECT * FROM ALL_PART_KEY_COLUMNS  col WHERE col.object_type  = 'TABLE' and owner='HOSTKBSVT') col

where rowc.TABLE_NAME=dtsize.segment_name(+)
      and rowc.TABLE_NAME=col.name(+)
      and rowc.TABLE_NAME like '%HIST'
order by MB DESC
---======
Số tk: 091C086523
Mật khẩu đăng nhập: Fss@123456
Mật khẩu đặt lệnh  (PIN  ): Fss@1234567
https://kbtrade.kbsec.com.vn/
---

V_GETSECMARGININFO

con này ko căn cứ theo sectype

thấy mã nào đang setup tỉ lệ tài sản và thiết lập có cho vay (securities_risk) thì lên thôi

nên chỗ này khi sinh mã quyền

nếu mã gốc đang cho vay thì cũng phải tự động sinh cho mã quyền vào securities_risk

tương tự các thay đổi trên mã gốc như thay đổi cho vay, hoặc ko cho vay cũng phải xử lý trên các mã quyền đang có trên hệ thống

Toàn thử ngó lại code trong view xem phải vậy ko nhé

---
