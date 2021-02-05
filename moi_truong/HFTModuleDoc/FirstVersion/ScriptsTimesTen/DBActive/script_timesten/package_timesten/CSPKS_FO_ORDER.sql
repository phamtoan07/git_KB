CREATE OR REPLACE PACKAGE cspks_fo_order AS
PROCEDURE sp_create_quote(p_err_code in OUT VARCHAR,
                                p_quote_id in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                                p_acgroup in OUT VARCHAR,
                f_account IN VARCHAR,
                f_side IN VARCHAR,
                                f_symbol IN VARCHAR,
                f_qtty IN  NUMBER,
                                f_price IN  NUMBER,
                f_expireddt in DATE,
                                f_userid in VARCHAR,
                                f_via in VARCHAR,
                                f_classcd in VARCHAR,
                                f_subclass in VARCHAR,
                                f_typecd in VARCHAR,
                                f_subtype in VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                );

--PROCEDURE sp_process_order_buy(p_err_code in OUT VARCHAR,
--                p_poolval in OUT NUMBER,
--                p_orderid in OUT VARCHAR,
--                f_qtty IN NUMBER,
--                f_price IN NUMBER,
--                f_quote_id IN VARCHAR
--                );

PROCEDURE sp_create_cancel_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_orderid IN VARCHAR,
                f_account IN VARCHAR,
                f_userid IN VARCHAR,
                                f_via IN VARCHAR,
                p_symbol OUT VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                );

PROCEDURE sp_create_amend_quote (p_err_code in out VARCHAR,
                p_quote_id in OUT VARCHAR,
                p_order_id in VARCHAR,
                p_ref_sessionex in OUT VARCHAR,
                p_remain_qtty in OUT NUMBER,
                p_ref_type in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                                p_acgroup in OUT VARCHAR,
                f_account IN VARCHAR,
                f_userid in VARCHAR,
                                f_via in VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_qtty IN NUMBER,
                f_price IN NUMBER,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                  );

PROCEDURE sp_create_cross_quote (p_err_code in OUT VARCHAR,
                p_quote_id in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                                p_acgroup in OUT VARCHAR,
                p_dof in OUT VARCHAR, --nha dau tu nuoc ngoai hay trong nuoc
                p_msgtype IN VARCHAR,
                p_userid IN VARCHAR,
                p_account IN VARCHAR,--neu la lenh TTCTV, la so tk mua
                p_symbol IN OUT VARCHAR,
                p_subside IN VARCHAR,--B: Mua, S: b?th??ng, M : b?c?m c?, T: b?t?ng
                                p_via IN VARCHAR,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_firm IN VARCHAR,--ma thanh vien doi ung
                p_traderid IN VARCHAR, --ma giao dich vien nhap lenh ben doi ung
                p_contraaccount IN VARCHAR,--neu la lenh TTCTV, la so tk ban
                p_orderid IN OUT VARCHAR, --so hieu lenh quang cao trong lenh thoa thuan
                p_text IN VARCHAR, --so dien thoai trong lenh quang cao
                p_classcd in OUT VARCHAR, --loai lenh thoa thuan hay quang cao
                p_typecd in OUT VARCHAR,
                p_crossnumber in OUT VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                  );

PROCEDURE sp_create_cancel_cross_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                p_classcd OUT VARCHAR,
                p_orderid IN VARCHAR,
                p_userid IN VARCHAR,
                                p_via IN VARCHAR,
                p_symbol OUT VARCHAR,
                p_typecd IN VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                );


PROCEDURE sp_create_cancel_adv_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                p_classcd OUT VARCHAR,
                p_orderid IN OUT VARCHAR, --so hieu lenh quang cao
                p_userid IN VARCHAR, --ma user dat lenh
                                p_via IN VARCHAR,
                p_symbol IN VARCHAR,
                p_side IN VARCHAR,
                p_qtty IN VARCHAR,
                p_price IN VARCHAR,
                p_text IN VARCHAR,
                p_firm IN VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                );

PROCEDURE sp_proces_release_block_quote (
      p_err_code OUT VARCHAR,
     p_user_id IN OUT VARCHAR,
     p_acctno IN OUT VARCHAR,
     p_orderid IN OUT VARCHAR,
     p_symbol IN OUT VARCHAR,
     p_via IN OUT VARCHAR,
     f_quote_id OUT VARCHAR,
     f_class_cd OUT VARCHAR,
     p_err_msg OUT VARCHAR2
  );
  
--PROCEDURE sp_proces_update_hft_msg_log (
--      p_err_code OUT VARCHAR,
--      p_err_msg OUT VARCHAR2,
--      p_orderid IN VARCHAR2,
--      p_mode IN VARCHAR2
--  );
--  
PROCEDURE sp_create_resendquote (
      p_err_code OUT VARCHAR,
      p_err_msg OUT VARCHAR2,
      p_orderid IN VARCHAR2
  );
  
PROCEDURE sp_cancel_condition_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                p_acclass in OUT VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_orderid IN VARCHAR,
                f_account IN VARCHAR,
                f_userid IN VARCHAR,
                f_via IN VARCHAR,
                p_symbol OUT VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                );
  
END CSPKS_FO_ORDER;
/


CREATE OR REPLACE PACKAGE BODY cspks_fo_order AS
    PROCEDURE sp_create_quote(p_err_code in OUT VARCHAR,
              p_quote_id in OUT VARCHAR,
              p_acclass in OUT VARCHAR,
              p_acgroup in OUT VARCHAR,
              f_account IN VARCHAR,
              f_side IN VARCHAR,
              f_symbol IN VARCHAR,
              f_qtty IN  NUMBER,
              f_price IN  NUMBER,
              f_expireddt in DATE,
              f_userid in VARCHAR,
              f_via in VARCHAR,
              f_classcd in VARCHAR,
              f_subclass in VARCHAR,
              f_typecd in VARCHAR,
              f_subtype in VARCHAR,
              p_custodycd in OUT VARCHAR,
              p_dof in OUT VARCHAR,
              f_requestid VARCHAR,
              p_err_msg OUT VARCHAR2
  )
    AS
        v_currtime              TIMESTAMP;
        v_count                 NUMBER;
        v_count_acctno          NUMBER;
        v_banklink              ACCOUNTS.BANKLINK%TYPE;
        v_refcode               VARCHAR(50);
        max_qtty                NUMBER;
    BEGIN
    p_err_code := '0';
    p_err_msg  := 'sp_create_quote f_requestid=>'||f_requestid;
        BEGIN
            EXECUTE  IMMEDIATE
            'select tt_sysdate from dual' into v_currtime;
        END;

        SELECT COUNT(1) INTO v_count_acctno FROM ACCOUNTS WHERE ACCTNO = f_account;
        IF v_count_acctno < 1 THEN
            p_err_code := '-90019';
            RETURN;
        END IF;

        SELECT COUNT(1) INTO v_count FROM INSTRUMENTS WHERE SYMBOL = f_symbol;
        IF v_count < 1 THEN
            p_err_code := '-90022';
            RETURN;
        END IF;
        
        CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, p_quote_id,p_err_msg);

        --Get account information
        SELECT GRNAME,ACCLASS,CUSTODYCD,BANKLINK INTO p_acgroup,p_acclass,p_custodycd,v_banklink
        FROM ACCOUNTS WHERE ACCTNO=f_account;
        
        IF v_banklink = 'B' THEN
          SELECT EXCHANGE || '.' || BOARD INTO v_refcode FROM INSTRUMENTS WHERE SYMBOL = f_symbol;
          SELECT REFNVAL INTO max_qtty FROM DEFRULES WHERE RULENAME = 'MAXNMLQTTY' AND REFCODE = v_refcode;
          IF f_qtty > max_qtty THEN 
              p_err_code := '-95018';
              RETURN;
          END IF;
        END IF;
        --Get customer information
        SELECT DOF INTO p_dof FROM CUSTOMERS WHERE CUSTODYCD=p_custodycd;

        --Save quote request
        INSERT INTO QUOTES (QUOTEID,REQUESTID, CREATEDDT, EXPIREDDT, USERID, VIA, CLASSCD, SUBCLASS, ACCTNO,
                            STATUS, SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, REFQUOTEID, SYMBOL,
                            QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND, EXEC_AMT, EXEC_QTTY,
                            PRICE, PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, LASTCHANGE)
        VALUES (p_quote_id,f_requestid, sysdate, f_expireddt, f_userid, f_via, f_classcd, f_subclass ,f_account,
              'P', 'P', v_currtime, v_currtime, f_typecd, f_subtype, f_side, null, f_symbol,
              f_qtty, 0, 0, 0, 0, 0, 0,
              f_price, 0, 0, 0, 0, v_currtime);

--      EXCEPTION
--          WHEN OTHERS THEN
--              p_err_code := '-90025'; --undefined error
    EXCEPTION
        WHEN OTHERS THEN
          p_err_msg:='sp_create_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
		  p_err_code := '-90025';
    END sp_create_quote;


    PROCEDURE sp_create_cancel_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                p_acclass in OUT VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_orderid IN VARCHAR,
                f_account IN VARCHAR,
                f_userid IN VARCHAR,
                f_via IN VARCHAR,
                p_symbol OUT VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
  )
    AS
        v_currtime                  TIMESTAMP;
        v_symbol                    VARCHAR(20);
        v_quoteid                   VARCHAR(20);
        v_typecd                    VARCHAR(6);
        v_subtypecd                 VARCHAR(6);
        v_side                      VARCHAR(1);
        v_qtty                      NUMBER;
        v_price                     NUMBER;
        v_quoteid_new       VARCHAR(20);
    v_acctno          VARCHAR(10);

    BEGIN
    p_err_code :='0';
    p_err_msg:='sp_create_cancel_quote f_requestid=>'||f_requestid;
        -- GET CURRENT DATE SET INTO v_currtime
        BEGIN
        EXECUTE  IMMEDIATE
        'select tt_sysdate from dual' into v_currtime;
        END;

        -- LAY THONG TIN BANG ORDERS
        SELECT SYMBOL,QUOTEID,TYPECD,SUBTYPECD,QUOTE_QTTY,ACCTNO
        INTO v_symbol,v_quoteid,v_typecd,v_subtypecd,v_qtty,v_acctno
        FROM ORDERS WHERE ORDERID = f_orderid;

        CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, v_quoteid_new,p_err_msg);
        --dbms_output.put_line('v_quoteid_new' || v_quoteid_new);

        --Get account information
        SELECT ACCLASS, CUSTODYCD INTO  p_acclass, p_custodycd FROM ACCOUNTS WHERE ACCTNO=v_acctno;

        --Get customer information
        SELECT DOF INTO p_dof FROM CUSTOMERS WHERE CUSTODYCD=p_custodycd;

        INSERT INTO QUOTES (QUOTEID,REQUESTID, REFQUOTEID, CREATEDDT, USERID, VIA, ACCTNO,
                    SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, SYMBOL,
                    QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND,
                    PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
        VALUES (v_quoteid_new,f_requestid, v_quoteid, v_currtime, f_userid, f_via, v_acctno,
                    'P', v_currtime, v_currtime, v_typecd, v_subtypecd, 'C', v_symbol,
                    v_qtty,0,0,0,0,
                    0,0,0,0,0,0,v_currtime);

        p_quoteid := v_quoteid_new;
        p_symbol := v_symbol;

        EXCEPTION
            WHEN OTHERS THEN
                p_err_code :='-90025';
                p_err_msg:='sp_create_cancel_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
    END;

  PROCEDURE sp_create_amend_quote (p_err_code in out VARCHAR,
                p_quote_id in OUT VARCHAR,
                p_order_id in VARCHAR,
                p_ref_sessionex in OUT VARCHAR,
                p_remain_qtty in OUT NUMBER,
                p_ref_type in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                                p_acgroup in OUT VARCHAR,
                f_account IN VARCHAR,
                f_userid in VARCHAR,
                                f_via in VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_qtty IN NUMBER,
                f_price IN NUMBER,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                  )
  IS
    v_currtime            TIMESTAMP;
    v_status            VARCHAR2(1);
    v_refquoteid        VARCHAR2(20);
    v_symbol            VARCHAR(15);
    v_typecd            VARCHAR(6);
    v_subtypecd         VARCHAR(6);
    v_acctno            VARCHAR(12);
    v_classcd           VARCHAR(6);
    v_banklink           VARCHAR(2);
  BEGIN
    p_err_code :='0';
    p_err_msg:='sp_create_amend_quote f_requestid=>'||f_requestid;
    BEGIN
      EXECUTE  IMMEDIATE
      'select tt_sysdate from dual' into v_currtime;
    END;
    --Get QuoteID
        --SELECT VARVALUE, TO_CHAR(VARVALUE,'DDMMRRRR') || LPAD(SEQ_QUOTES.NEXTVAL,10,'0')
            --INTO v_currdate,  p_quote_id
        --FROM SYSVARDATE WHERE VARNAME='CURRDATE';
    CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, p_quote_id,p_err_msg);


    SELECT REMAIN_QTTY,SESSIONEX,STATUS,TYPECD,QUOTEID,SYMBOL,TYPECD,SUBTYPECD,ACCTNO
    INTO p_remain_qtty,p_ref_sessionex,v_status,p_ref_type,v_refquoteid,v_symbol,v_typecd,v_subtypecd,v_acctno
    FROM ORDERS WHERE ORDERID = p_order_id;

    SELECT CLASSCD INTO v_classcd FROM QUOTES WHERE QUOTEID = v_refquoteid;

     --Get account information
        SELECT GRNAME, ACCLASS, CUSTODYCD,BANKLINK INTO p_acgroup, p_acclass, p_custodycd,v_banklink FROM ACCOUNTS WHERE ACCTNO=v_acctno;

    --Get customer information
    SELECT DOF INTO p_dof FROM CUSTOMERS WHERE CUSTODYCD = p_custodycd;

    IF v_banklink = 'B' THEN
      v_refquoteid := p_order_id;
    END IF;

    --- Luu vao bang quote, khong check bat cu dk gi
    INSERT INTO QUOTES (QUOTEID,REQUESTID, REFQUOTEID, CREATEDDT, USERID, VIA, ACCTNO,CLASSCD,
          SYMBOL,TYPECD,SUBTYPECD,SIDE,TIME_QUOTE,TIME_SEND,QTTY, PRICE, LASTCHANGE)
    VALUES (p_quote_id,f_requestid, v_refquoteid, sysdate, f_userid, f_via, v_acctno, v_classcd,
          v_symbol, v_typecd, v_subtypecd, 'A', sysdate, sysdate,f_qtty, f_price, sysdate);

     --plog.info('Result : '||p_ref_sessionex ||' , '||p_remain_qtty||' , '||p_custodycd||' , '|| p_dof);
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code :='-90025';
        p_err_msg:='sp_create_amend_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
  END;


  PROCEDURE sp_create_cross_quote (p_err_code in out VARCHAR,
              p_quote_id in OUT VARCHAR,
              p_acclass in OUT VARCHAR,
              p_acgroup in OUT VARCHAR,
              p_dof in OUT VARCHAR, --nha dau tu nuoc ngoai hay trong nuoc
              p_msgtype IN VARCHAR,
              p_userid IN VARCHAR,
              p_account IN VARCHAR,--neu la lenh TTCTV, la so tk ban
              p_symbol IN OUT VARCHAR,
              p_subside IN VARCHAR,--B: Mua, S: b?th??ng, M : b?c?m c?, T: b?t?ng
              p_via IN VARCHAR,
              p_qtty IN NUMBER,
              p_price IN NUMBER,
              p_firm IN VARCHAR,--ma thanh vien doi ung
              p_traderid IN VARCHAR, --ma giao dich vien nhap lenh ben doi ung
              p_contraaccount IN VARCHAR,--neu la lenh TTCTV, la so tk mua
              p_orderid IN OUT VARCHAR, --so hieu lenh quang cao trong lenh thoa thuan
              p_text IN VARCHAR, --so dien thoai trong lenh quang cao
              p_classcd in OUT VARCHAR, --loai lenh thoa thuan hay quang cao
              p_typecd in OUT VARCHAR, -- loai yc cho lenh tt
              p_crossnumber in OUT VARCHAR,
              f_requestid VARCHAR,
              p_err_msg OUT VARCHAR2
  )
  IS
        v_currtime              TIMESTAMP;
      v_acctno              VARCHAR(20);
      v_side                VARCHAR(1);
      v_crosstype           VARCHAR(2);
      v_contraaccount       VARCHAR(20); --tai khoan doi ung
      v_count1              NUMBER;
      v_count2              NUMBER;
      v_count_symbol        NUMBER;
      v_count_advorder      NUMBER;

      v_symbol              VARCHAR(20);
      v_price               NUMBER;
      v_qtty                NUMBER;
      v_status              VARCHAR(20);
      v_cust1               VARCHAR(20);
      v_cust2               VARCHAR(20);
      v_fqtty               NUMBER;

      v_dof1                VARCHAR(20);
      v_dof2                VARCHAR(20);
  BEGIN
      p_err_code :='0';
      p_err_msg:='sp_create_cross_quote f_requestid=>'||f_requestid;
      CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, p_quote_id,p_err_msg);
      v_side :=p_subside;

      SELECT FQTTY INTO v_fqtty FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
      SELECT COUNT(1) INTO v_count1 FROM ACCOUNTS WHERE ACCTNO = p_account;
      SELECT COUNT(1) INTO v_count2 FROM ACCOUNTS WHERE ACCTNO = p_contraaccount;

      -- check symbol
      SELECT COUNT(1) INTO v_count_symbol FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
      IF (v_count_symbol < 1) THEN
          p_err_code := '-90022';
          RETURN;
      END IF;

      IF p_msgtype = 'tx2003' THEN
          p_classcd := 'ADO'; --lenh QC
      ELSE
        p_classcd := 'DBO'; --lenh TT
        SELECT COUNT(1) INTO v_count_advorder FROM ADVORDERS WHERE REFORDERID = p_orderid;
        IF (v_count_advorder = 1) THEN
            SELECT SYMBOL,PRICE,QTTY,STATUS INTO v_symbol,v_price,v_qtty,v_status FROM ADVORDERS WHERE REFORDERID = p_orderid;
            IF (v_symbol != p_symbol) THEN
                p_err_code := '-95028';
                RETURN;
            END IF;
            IF (v_qtty < p_qtty) OR (v_qtty > p_qtty) THEN
                p_err_code := '-95029';
                RETURN;
            END IF;
            IF (v_price < p_price) OR (v_price > p_price) THEN
                p_err_code := '-95030';
                RETURN;
            END IF;
            IF v_status != 'N'/*NOT IN ('A','N')*/ THEN
                p_err_code := '-95031';
                RETURN;
            END IF;
        END IF;
      END IF;

      IF (p_msgtype = 'tx2001') then --lenh TTCTV
          v_crosstype := 'S';
          v_side :='S';
          -- check accounts
          SELECT CUSTODYCD INTO v_cust1 FROM ACCOUNTS WHERE ACCTNO = p_account;
          SELECT CUSTODYCD INTO v_cust2 FROM ACCOUNTS WHERE ACCTNO = p_contraaccount;
          SELECT DOF INTO v_dof1 FROM CUSTOMERS WHERE CUSTODYCD = v_cust1;
          SELECT DOF INTO v_dof2 FROM CUSTOMERS WHERE CUSTODYCD = v_cust2;
          IF  (/*v_dof1 = 'F' OR*/ v_dof2 = 'F') AND (v_dof1 != v_dof2) THEN  -- v_dof1='D' and v_dof2='F'
            -- check room nuoc ngoai
            IF (p_qtty > v_fqtty) THEN
              p_err_code := '-95012';
              RETURN;
            END IF;
          END IF;
          --select COUNT(1) INTO v_count_advorder from advorders ad inner join quotes q on (ad.refquoteid=q.quoteid) where reforderid=p_orderid;
          IF v_count_advorder = 1 THEN
            SELECT CASE a.memberid WHEN c.firm THEN 1 ELSE 0 END INTO v_count_advorder FROM ADVORDERS a INNER JOIN CROSSINFO c ON (a.REFQUOTEID=c.QUOTEID) WHERE REFORDERID=p_orderid;
            IF (v_count_advorder < 1) THEN
              p_err_code := '-95033';
              RETURN;
            END IF;
          END IF;
          IF (v_count1 < 1) or (v_count2 < 1) THEN
              p_err_code := '-90019';
              RETURN;
          END IF;
          IF (p_account = p_contraaccount) THEN
              p_err_code := '-95027';
              RETURN;
          END IF;
          IF (v_cust1 = v_cust2) THEN
              --DBMS_OUTPUT.PUT_LINE('Tai khoan cung so luu ky ');
              p_err_code := '-99999';
              RETURN;
          END IF;
          v_acctno := p_account;
          v_contraaccount := p_contraaccount;

      ELSIF (p_msgtype = 'tx2002') then  -- lenh TT khac thanh vien
          SELECT COUNT(1) INTO v_count1 FROM ACCOUNTS WHERE ACCTNO = p_account;
          IF (v_count1 < 1) THEN
              p_err_code := '-90019';
              RETURN;
          END IF;
          v_crosstype := 'D';
          v_acctno := p_account;
          v_contraaccount := null;
          v_cust2 := p_contraaccount;
          --lay thong tin tk lenh TT ben minh
          SELECT c.dof INTO v_dof1 FROM ACCOUNTS a, CUSTOMERS c WHERE a.CUSTODYCD = c.CUSTODYCD AND a.ACCTNO = p_account;
          --check room nuoc ngoai
          IF (v_side='B') AND (v_dof1 = 'F') AND (p_qtty > v_fqtty) THEN
              p_err_code := '-95012';
              RETURN;
          END IF;

      END IF;

      -- insert quotes table
      INSERT INTO QUOTES (QUOTEID,REQUESTID, CREATEDDT, EXPIREDDT, USERID, VIA, CLASSCD, SUBCLASS, ACCTNO,
                            STATUS, SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, REFQUOTEID, SYMBOL,
                            QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND, EXEC_AMT, EXEC_QTTY,
                            PRICE, PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, LASTCHANGE)
      VALUES (p_quote_id,f_requestid, sysdate, null, p_userid, p_via, p_classcd, null ,v_acctno,
              'P', 'P', sysdate, sysdate, p_typecd, 'LO', v_side, p_crossnumber, p_symbol,
              p_qtty, 0, 0, 0, 0, 0, 0,
              p_price, 0, 0, 0, 0, sysdate);

      -- insert crossinfo table
      INSERT INTO CROSSINFO(QUOTEID,CROSSTYPE,FIRM,TRADERID,ACCTNO,ORDERID,TEXT,CUSTODYCD)
        VALUES (p_quote_id,v_crosstype,p_firm,p_traderid,v_contraaccount,p_orderid,p_text,v_cust2);

      -- update status advorders
      IF (p_msgtype != 'tx2003') AND (v_count_advorder = 1) THEN
        UPDATE ADVORDERS SET STATUS = 'A' WHERE REFORDERID = p_orderid;
      END IF;

      -- update status quotes of cross
      IF (p_typecd = 'R') THEN
        UPDATE QUOTES SET STATUS = p_typecd WHERE REFQUOTEID = p_crossnumber;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code :='-90025';
          p_err_msg:='sp_create_cross_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
  END ;

   PROCEDURE sp_create_cancel_cross_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                p_classcd OUT VARCHAR,
                p_orderid IN VARCHAR, -- so hieu lenh thoa thuan
                p_userid IN VARCHAR,
                                p_via IN VARCHAR,
                p_symbol OUT VARCHAR,
                p_typecd IN VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_symbol VARCHAR(20);
    v_quoteid VARCHAR(20);
    v_typecd VARCHAR(6);
    v_subtypecd VARCHAR(6);
    v_qtty NUMBER;
    v_quoteid_new VARCHAR(20);
    v_acctno VARCHAR(20);
  BEGIN
    p_err_code :='0';
    p_err_msg:='sp_create_cancel_cross_quote p_orderid=>'||p_orderid;
    p_classcd := 'DBO';

    SELECT SYMBOL,QUOTEID,TYPECD,SUBTYPECD,QUOTE_QTTY,ACCTNO
      INTO v_symbol,v_quoteid,v_typecd,v_subtypecd,v_qtty,v_acctno
      FROM ORDERS
      WHERE ORDERID = p_orderid;

    p_symbol := v_symbol;

    CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, v_quoteid_new,p_err_msg);
--      dbms_output.put_line('v_quoteid_new' || v_quoteid_new);

    --Get account information
        --SELECT ACCLASS, CUSTODYCD INTO  p_acclass, p_custodycd
        --FROM ACCOUNTS WHERE ACCTNO=f_account;

    --Get customer information
    --SELECT DOF INTO p_dof
    --FROM CUSTOMERS WHERE CUSTODYCD = p_custodycd;

    INSERT INTO QUOTES (QUOTEID,REQUESTID, REFQUOTEID, CREATEDDT, USERID, VIA, ACCTNO,
                        SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, SYMBOL,
                        QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND, CLASSCD,
                        PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
                VALUES (v_quoteid_new,f_requestid, v_quoteid, sysdate, p_userid, p_via, v_acctno,
                        'P', sysdate, sysdate, p_typecd, v_subtypecd, 'C', v_symbol,
                        v_qtty,0,0,0,0,'DBO',
                        0,0,0,0,0,0,sysdate);

    p_quoteid := v_quoteid_new;


    EXCEPTION
      WHEN OTHERS THEN
        p_err_code :='-90025';
        p_err_msg:='sp_create_cancel_cross_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
  END;


  PROCEDURE sp_create_cancel_adv_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                                p_acclass in OUT VARCHAR,
                p_classcd OUT VARCHAR,
                p_orderid IN OUT VARCHAR, --so hieu lenh quang cao
                p_userid IN VARCHAR, --ma user dat lenh
                                p_via IN VARCHAR,
                p_symbol IN VARCHAR,
                p_side IN VARCHAR,
                p_qtty IN VARCHAR,
                p_price IN VARCHAR,
                p_text IN VARCHAR,
                p_firm IN VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_count number;
    v_quoteid varchar(20);
    v_refquoteid varchar(20);
    v_symbol varchar(20);
    v_qtty number;
    v_price number;
    v_status varchar(20);
    v_firm varchar(20);

  BEGIN

    p_classcd := 'ADO';
    p_err_code :='0';
    p_err_msg:='sp_create_cancel_adv_quote p_orderid=>'||p_orderid;
    CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, p_quoteid,p_err_msg);
    SELECT COUNT(1) INTO v_count FROM ADVORDERS WHERE REFORDERID = p_orderid;

    IF (v_count = 1) THEN

        SELECT REFQUOTEID,SYMBOL,QTTY,PRICE,STATUS
        INTO v_refquoteid,v_symbol,v_qtty,v_price,v_status
        FROM ADVORDERS
        WHERE REFORDERID = p_orderid;

        IF (v_status != 'N')/*NOT IN ('A','N')*/ THEN
          p_err_code := '-95023';
          RETURN;
        END IF;
    ELSE
        v_symbol := p_symbol;
        v_qtty  := p_qtty;
        v_price := p_price;
--        p_orderid := v_quoteid_new;
    END IF;


    -- insert to quotes
    INSERT INTO QUOTES (QUOTEID,REQUESTID, REFQUOTEID, CREATEDDT, USERID, VIA, ACCTNO,
                    STATUS,SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, SYMBOL,
                    QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND, CLASSCD,
                    PRICE,PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
    VALUES (p_quoteid,f_requestid, v_refquoteid, sysdate, p_userid, p_via, null,
                    'P','P', sysdate, sysdate, 'LO', 'LO', p_side, v_symbol,
                    v_qtty,0,0,0,0,p_acclass,
                    v_price,0,0,0,0,0,0,sysdate);


        -- insert to crossinfo
    INSERT INTO CROSSINFO(QUOTEID,CROSSTYPE,FIRM,TRADERID,ACCTNO,ORDERID,TEXT)
        VALUES (p_quoteid,null,p_firm,null,null,p_orderid,p_text);
         --dbms_output.put_line ('44444444444444');

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code :='-90025';
        p_err_msg:='sp_create_cancel_adv_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
  END;

  PROCEDURE sp_proces_release_block_quote (
      p_err_code OUT VARCHAR,
      p_user_id IN OUT VARCHAR,
      p_acctno IN OUT VARCHAR,
      p_orderid IN OUT VARCHAR,
      p_symbol IN OUT VARCHAR,
      p_via IN OUT VARCHAR,
      f_quote_id OUT VARCHAR,
      f_class_cd OUT VARCHAR,
      p_err_msg OUT VARCHAR2
  ) AS
    v_count_symbol NUMBER;
  BEGIN
    p_err_code := 0;
    p_err_msg:='sp_proces_release_block_quote p_OrderID=>'||p_OrderID;
    f_class_cd := 'RBO';

    -- check symbol
    SELECT COUNT(*) INTO v_count_symbol FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
    
    IF (v_count_symbol = 0) THEN
        p_err_code := '-90022';
        RETURN;
    END IF;

    CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, f_quote_id,p_err_msg);
    
    INSERT INTO QUOTES (QUOTEID,REQUESTID, REFQUOTEID, CREATEDDT, USERID, VIA, ACCTNO,
                    STATUS,SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, SYMBOL,
                    QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND, CLASSCD,
                    PRICE,PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
    VALUES (f_quote_id,f_quote_id, p_orderid, sysdate, p_user_id, p_via, p_acctno,
                    'P','P', sysdate, sysdate, 'LO', 'LO', 'C', p_symbol,
                    0,0,0,0,0,f_class_cd,
                    0,0,0,0,0,0,0,sysdate);
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code :='-90025';
        p_err_msg:='sp_proces_release_block_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
  END;

-- PROCEDURE sp_proces_update_hft_msg_log(p_err_code OUT VARCHAR,
--      p_err_msg OUT VARCHAR2,
--      p_orderid IN VARCHAR2,
--      p_mode IN VARCHAR2)
--    AS
--      v_currtime                    TIMESTAMP;
--    BEGIN
--      p_err_code := 0;
--      p_err_msg:='sp_proces_release_block_quote p_OrderID=>'||p_orderid;
--      IF p_mode = 'FIRST' THEN
--         UPDATE HFT_MSG_LOGS SET STATUS = 'PTR' WHERE ORDERID = p_orderid; --PTR: pending to  resend
--      ELSIF p_mode = 'RESEND' THEN
--         UPDATE HFT_MSG_LOGS SET STATUS = 'RSS' WHERE ORDERID = p_orderid; --SUC: resend sucessful
--      END IF;
--
--      EXCEPTION
--        WHEN OTHERS THEN
--        p_err_code := '-90025';
--        p_err_msg:='sp_proces_msg_log '||p_err_msg||' sqlerrm = '||SQLERRM;
--    END;

 PROCEDURE sp_create_resendquote(p_err_code OUT VARCHAR,
      p_err_msg OUT VARCHAR2,
      p_orderid IN VARCHAR2)
    AS
      v_currtime            TIMESTAMP;
      v_quote_id            VARCHAR2(25);
    BEGIN
      p_err_code := 0;
      p_err_msg:='sp_create_resendquote p_OrderID=>'||p_orderid;
      
      BEGIN
          EXECUTE  IMMEDIATE
          'select tt_sysdate from dual' into v_currtime;
      END;
      
      CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, v_quote_id,p_err_msg);
      
      INSERT INTO QUOTES (QUOTEID,REQUESTID, CREATEDDT, REFQUOTEID, LASTCHANGE)
        VALUES (v_quote_id,v_quote_id, v_currtime, p_orderid, v_currtime);

      EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_create_resendquote '||p_err_msg||' sqlerrm = '||SQLERRM;
    END;
    
  PROCEDURE sp_cancel_condition_quote ( p_err_code in OUT VARCHAR,
                p_quoteid in OUT VARCHAR,
                p_acclass in OUT VARCHAR,
                p_custodycd in OUT VARCHAR,
                p_dof in OUT VARCHAR,
                f_orderid IN VARCHAR,
                f_account IN VARCHAR,
                f_userid IN VARCHAR,
                f_via IN VARCHAR,
                p_symbol OUT VARCHAR,
                f_requestid VARCHAR,
                p_err_msg OUT VARCHAR2
  )
    AS
        
        v_currtime                  TIMESTAMP;
        v_symbol                    VARCHAR(20);
        v_typecd                    VARCHAR(6);
        v_subtypecd                 VARCHAR(6);
        v_side                      VARCHAR(1);
        v_qtty                      NUMBER;
        v_price                     NUMBER;

    BEGIN
    p_err_code :='0';
    p_err_msg:='sp_cancel_condition_quote f_requestid=>'||f_requestid;
        -- GET CURRENT DATE SET INTO v_currtime
        BEGIN
        EXECUTE  IMMEDIATE
        'select tt_sysdate from dual' into v_currtime;
        END;

        CSPKS_FO_COMMON.sp_get_quoteid(p_err_code, p_quoteid,p_err_msg);
        --dbms_output.put_line('v_quoteid_new' || v_quoteid_new);

        --Get account information
        SELECT ACCLASS, CUSTODYCD INTO p_acclass, p_custodycd FROM ACCOUNTS WHERE ACCTNO=f_account;

        --Get customer information
        SELECT DOF INTO p_dof FROM CUSTOMERS WHERE CUSTODYCD=p_custodycd;

        INSERT INTO QUOTES (QUOTEID, REQUESTID, REFQUOTEID, CREATEDDT, USERID, VIA, ACCTNO,
                    SUBSTATUS, TIME_QUOTE, TIME_SEND, TYPECD, SUBTYPECD, SIDE, SYMBOL,
                    QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND, CLASSCD,
                    PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
        VALUES (p_quoteid,p_quoteid, f_orderid, v_currtime, f_userid, f_via, f_account,
                    'P', v_currtime, v_currtime, v_typecd, v_subtypecd, 'C', v_symbol,
                    v_qtty,0,0,0,0,null,
                    0,0,0,0,0,0,v_currtime);


        EXCEPTION
            WHEN OTHERS THEN
                p_err_code :='-90025';
                p_err_msg:='sp_create_cancel_quote '||p_err_msg||' sqlerrm = '||SQLERRM;
    
    END sp_cancel_condition_quote;  
  

END CSPKS_FO_ORDER;
/
