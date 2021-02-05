CREATE OR REPLACE PACKAGE cspks_fo_reset_sequence AS



  /* TODO enter package declarations (types, exceptions, methods etc) here */

  PROCEDURE sp_reset_sequence(p_err_code in OUT VARCHAR);

  PROCEDURE reset_sequence (seq_name IN VARCHAR2, startvalue IN PLS_INTEGER);

  PROCEDURE sp_reset_seq(V_SEQ_NAME VARCHAR2 ,V_VALUES NUMBER);
  PROCEDURE sp_reset_seq_all;

END CSPKS_FO_RESET_SEQUENCE;
/

CREATE OR REPLACE PACKAGE BODY cspks_fo_reset_sequence AS
  -- reset sequence
  PROCEDURE sp_reset_sequence(p_err_code in OUT VARCHAR)
    AS
       stmt varchar2(4000) := '';

    BEGIN
      p_err_code := 0;

      --1.SEQ_TRANSACTIONS
      stmt := 'DROP SEQUENCE SEQ_TRANSACTIONS';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_TRANSACTIONS
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

       --2.SEQ_POOLROOM
      stmt := 'DROP SEQUENCE SEQ_POOLROOM';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_POOLROOM
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

       --3.SEQ_COMMON
      stmt := 'DROP SEQUENCE SEQ_COMMON';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_COMMON
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

       --4.SEQ_DEALID
      stmt := 'DROP SEQUENCE SEQ_DEALID';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_DEALID
        START WITH     50001
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

      --5.SEQ_BASKETS
      stmt := 'DROP SEQUENCE SEQ_BASKETS';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_BASKETS
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;


        --6.SEQ_ALLOCATION
      stmt := 'DROP SEQUENCE SEQ_ALLOCATION';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_ALLOCATION
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;


      --7.SEQ_ORDERS
      stmt := 'DROP SEQUENCE SEQ_ORDERS';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_ORDERS
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

        --8.SEQ_TRADING
      stmt := 'DROP SEQUENCE SEQ_TRADING';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_TRADING
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

      --9.SEQ_QUOTES
      stmt := 'DROP SEQUENCE SEQ_QUOTES';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_QUOTES
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;


      --10.SEQ_ROOT_ORDERID
      stmt := 'DROP SEQUENCE SEQ_ROOT_ORDERID';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_ROOT_ORDERID
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

        --11.SEQ_EXCERROR
      stmt := 'DROP SEQUENCE SEQ_EXCERROR';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_EXCERROR
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

      --12.SEQ_HNX_ORDERID
      stmt := 'DROP SEQUENCE SEQ_HNX_ORDERID';
      execute immediate stmt;
      stmt := 'CREATE SEQUENCE SEQ_HNX_ORDERID
        START WITH     1
        MAXVALUE       9999999999
        INCREMENT BY   1
        NOCACHE
        CYCLE';
       execute immediate stmt;

    END sp_reset_sequence;

    PROCEDURE reset_sequence (seq_name IN VARCHAR2, startvalue IN PLS_INTEGER)
    AS

      cval   INTEGER;
      inc_by VARCHAR2(25);

    BEGIN
      EXECUTE IMMEDIATE 'ALTER SEQUENCE ' ||seq_name||' MINVALUE 0';

      EXECUTE IMMEDIATE 'SELECT ' ||seq_name ||'.NEXTVAL FROM dual'
      INTO cval;

      cval := cval - startvalue + 1;
      IF cval < 0 THEN
        inc_by := ' INCREMENT BY ';
        cval:= ABS(cval);
      ELSE
        inc_by := ' INCREMENT BY -';
      END IF;

      EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seq_name || inc_by ||
      cval;

      EXECUTE IMMEDIATE 'SELECT ' ||seq_name ||'.NEXTVAL FROM dual'
      INTO cval;

      EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seq_name ||
      ' INCREMENT BY 1';

    END reset_sequence;

    PROCEDURE sp_reset_seq(V_SEQ_NAME VARCHAR2,V_VALUES NUMBER) AS
        V_STR      VARCHAR2(1000);
        BEGIN
          --V_STR:='SELECT '||V_SEQ_NAME||'.NEXTVAL FROM DUAL';
          --EXECUTE IMMEDIATE V_STR INTO V_VALUES;
          --V_VALUES:=V_VALUES+10;
          V_STR   :='DROP SEQUENCE '|| V_SEQ_NAME;
          EXECUTE IMMEDIATE V_STR;
          V_STR:='CREATE SEQUENCE '||V_SEQ_NAME ||'
        INCREMENT BY 1
        START WITH  '|| V_VALUES ||'
        MINVALUE 1
        MAXVALUE 9999999999
        NOORDER
        NOCACHE';
          EXECUTE IMMEDIATE V_STR;
        END sp_reset_seq;
      PROCEDURE sp_reset_seq_all
      AS
      v_value number(20);
      BEGIN



      --sp_reset_seq('SEQ_ALLOCATION',v_value);


      --sp_reset_seq('SEQ_BASKETS',v_value);
      --sequence SEQ_COMMON dung cho bang allocation
      SELECT NVL(max(autoid),0) +10 INTO v_value FROM allocation;
      sp_reset_seq('SEQ_COMMON',v_value);

      SELECT  NVL(max(dealid),0) +10 INTO  v_value FROM orders;
      sp_reset_seq('SEQ_DEALID',v_value);

      SELECT  NVL(max(autoid),0) +10 INTO  v_value FROM DEFRULES;
      sp_reset_seq('SEQ_DEFRULES',v_value);
      SELECT  NVL(max(autoid),0) +10 INTO  v_value FROM EXCERROR;
      sp_reset_seq('SEQ_EXCERROR',v_value);

      SELECT  NVL(max(autoid),0) +10 INTO  v_value FROM GW_MSG_LOGS;
      sp_reset_seq('SEQ_GW_MSG_LOGS',v_value);

      --sp_reset_seq('SEQ_HNX_ORDERID',v_value);

      SELECT  NVL(max(MsgID),0) +10 INTO  v_value FROM TRADING_EXCEPTION;
      sp_reset_seq('SEQ_MSG_832',v_value);

      SELECT NVL(max(to_number(substr(orderid,10))),0) +10 INTO  v_value FROM orders  WHERE length(orderid) >10;
      sp_reset_seq('SEQ_ORDERS',v_value);

      SELECT  NVL(max(autoid),0) +10 INTO  v_value FROM POOLROOM;
      sp_reset_seq('SEQ_POOLROOM',v_value);

      SELECT NVL(max(to_number(substr(quoteid,10))),0) +10 INTO  v_value FROM quotes  WHERE length(quoteid) >10;
      sp_reset_seq('SEQ_QUOTES',v_value);

      SELECT nvl(max(to_number(substr(rootorderid,2))),0) +10 INTO  v_value FROM orders WHERE rootorderid is not null  ;--1.5.3.9|iss1874
      sp_reset_seq('SEQ_ROOT_ORDERID',v_value);

      SELECT NVL(max(to_number(substr(tradeid,10))),0) +10 INTO  v_value FROM trades  WHERE length(tradeid) >10;
      sp_reset_seq('SEQ_TRADING',v_value);

      SELECT  NVL(max(autoid),0) +10 INTO  v_value FROM TRANSACTIONS;
      sp_reset_seq('SEQ_TRANSACTIONS',v_value);

      SELECT  NVL(max(autoid),0) +10 INTO  v_value FROM TTLOGS;
      sp_reset_seq('SEQ_TTLOGS',v_value);
      END;
END CSPKS_FO_RESET_SEQUENCE;
/

