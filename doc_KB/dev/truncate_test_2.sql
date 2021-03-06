 create table TLLOGFLDALL_n1 as
 select * from TLLOGFLDALL where txdate >= to_date('03/02/2021','dd/mm/rrrr');
 
 select count(1) from TLLOGFLDALL order by txdate desc;
 select count(1) from TLLOGFLDALL_n where txdate >= to_date('03/02/2021','dd/mm/rrrr');
  
-----
CREATE TABLE TLLOGFLDALL_n AS SELECT * FROM TLLOGFLDALL WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table TLLOGFLDALL;
INSERT INTO TLLOGFLDALL SELECT * FROM TLLOGFLDALL_n;
commit;
---
CREATE TABLE TLLOGALL_n AS SELECT * FROM TLLOGALL WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table TLLOGALL;
INSERT INTO TLLOGALL SELECT * FROM TLLOGALL_n;
commit;
--
CREATE TABLE CITRAN_GEN_n AS SELECT * FROM CITRAN_GEN WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table CITRAN_GEN;
INSERT INTO CITRAN_GEN SELECT * FROM CITRAN_GEN_n;
commit;
select * from CITRAN_GEN;
--

CREATE TABLE CITRANA_n AS SELECT * FROM CITRANA WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table CITRANA;
INSERT INTO CITRANA SELECT * FROM CITRANA_n;
commit;

--

CREATE TABLE SETRAN_GEN_n AS SELECT * FROM SETRAN_GEN WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table SETRAN_GEN;
INSERT INTO SETRAN_GEN SELECT * FROM SETRAN_GEN_n;
commit;
--

CREATE TABLE ODMASTHIST_n AS SELECT * FROM ODMASTHIST WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table ODMASTHIST;
INSERT INTO ODMASTHIST SELECT * FROM ODMASTHIST_n;
commit;
--
CREATE TABLE FOMASTHIST_n AS SELECT * FROM FOMASTHIST WHERE to_date(substr(acctno,1,10),'dd/mm/rrrr') >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table FOMASTHIST;
INSERT INTO FOMASTHIST SELECT * FROM FOMASTHIST_n;
commit;
--
CREATE TABLE SETRANA_n AS SELECT * FROM SETRANA WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table SETRANA;
INSERT INTO SETRANA SELECT * FROM SETRANA_n;
commit;
--
CREATE TABLE SEDEPOBAL_n AS SELECT * FROM SEDEPOBAL WHERE txdate >= TO_DATE('01/01/2010','dd/mm/rrrr');
truncate table SEDEPOBAL;
INSERT INTO SEDEPOBAL SELECT * FROM SEDEPOBAL_n;
commit;
--
CREATE TABLE STSCHDHIST_n AS SELECT * FROM STSCHDHIST WHERE txdate >= TO_DATE('01/01/2010','dd/mm/rrrr');
truncate table STSCHDHIST;
INSERT INTO STSCHDHIST SELECT * FROM STSCHDHIST_n;
commit;
--
CREATE TABLE AFPRALLOCHIST_n AS SELECT * FROM AFPRALLOCHIST WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table AFPRALLOCHIST;
INSERT INTO AFPRALLOCHIST SELECT * FROM AFPRALLOCHIST_n;
commit;
--
CREATE TABLE IODHIST_n AS SELECT * FROM IODHIST WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table IODHIST;
INSERT INTO IODHIST SELECT * FROM IODHIST_n;
commit;
--
CREATE TABLE CIINTTRAN_n AS SELECT * FROM CIINTTRAN WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table CIINTTRAN;
INSERT INTO CIINTTRAN SELECT * FROM CIINTTRAN_n;
commit;
--
CREATE TABLE CFNAVLOG_n AS SELECT * FROM CFNAVLOG WHERE txdate >= TO_DATE('01/01/2020','dd/mm/rrrr');
truncate table CFNAVLOG;
INSERT INTO CFNAVLOG SELECT * FROM CFNAVLOG_n;
commit;

---
