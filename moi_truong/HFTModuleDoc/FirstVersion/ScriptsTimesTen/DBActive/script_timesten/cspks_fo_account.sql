-- Start of DDL Script for Package Body FOTEST.CSPKS_FO_ACCOUNT
-- Generated 16-Oct-2018 10:18:05 from FOTEST@FO

CREATE OR REPLACE 
PACKAGE cspks_fo_account AS
  -- Store lay thong tin cac lenh da khop
  PROCEDURE sp_get_order (
    f_acctno IN VARCHAR,
    f_custodycd IN VARCHAR,
    f_symbol IN VARCHAR,
    f_subside IN VARCHAR,
    f_status IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR
  );

  -- Store lay thong tin cac lenh da d
  PROCEDURE sp_get_match_order (
    f_CUSTODYCD IN VARCHAR,
    f_PLACECUSTID IN VARCHAR,
    f_ROOTORDERID IN VARCHAR,
    f_ORDERID      IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR
   );
   -- Store lay thong tin s?c mua, ti?n m?t, ch? thanh toan, k?t n?i bank tren online:
   PROCEDURE sp_get_summary_info (
    f_price IN NUMBER,
    f_symbol IN VARCHAR,
    p_err_code OUT VARCHAR,
    p_acctno IN OUT VARCHAR,
    p_balance OUT NUMBER,
    p_pp OUT NUMBER,
    p_cash_pending_send OUT NUMBER,
    p_maxqtty OUT NUMBER,
    p_mrratioloan OUT NUMBER,
    p_mrpriceloan OUT NUMBER
  );
  -- Store lay thong tin tien cua tai khoan
  PROCEDURE sp_get_ci_info (
    f_acctno IN OUT VARCHAR,
    p_balance OUT VARCHAR,
    p_cibalance OUT VARCHAR,
    p_tdbalance OUT VARCHAR,
    p_intbalance OUT VARCHAR,
    p_totalseamt OUT VARCHAR,
    p_mrqttyamt OUT VARCHAR,
    p_nonmrqttyamt OUT VARCHAR,
    p_dfqttyamt OUT VARCHAR,
    p_totalodamt OUT VARCHAR,
    p_trfbuyamt OUT VARCHAR,
    p_secureamt OUT VARCHAR,
    p_t0amt OUT VARCHAR,
    p_mramt OUT VARCHAR,
    p_rcvadvamt OUT VARCHAR,
    p_dfodamt OUT VARCHAR,
    p_tdodamt OUT VARCHAR,
    p_depofeeamt OUT VARCHAR,
    p_netassval OUT VARCHAR,
    p_sesecured OUT VARCHAR,
    p_sesecured_avl OUT VARCHAR,
    p_sesecured_buy OUT VARCHAR,
    p_accountvalue OUT VARCHAR,
    p_qttyamt OUT VARCHAR,
    p_cibalance2 OUT VARCHAR,
    p_mrcrlimit OUT VARCHAR,
    p_bankavlbal OUT VARCHAR,
    p_totalodamt2 OUT VARCHAR,
    p_rcvamt OUT VARCHAR,
    p_pp0 OUT VARCHAR,
    p_mrrate OUT VARCHAR,
    p_cash_receiving_t1 OUT VARCHAR,
    p_cash_receiving_t2 OUT VARCHAR,
    p_cash_receiving_t3 OUT VARCHAR,
    p_careceiving OUT VARCHAR,
    p_avladvance OUT VARCHAR,
    p_advanceline OUT VARCHAR,
    p_marginrate OUT VARCHAR,
    p_execbuyamt OUT VARCHAR,
    p_debt OUT VARCHAR,
    p_err_code  OUT VARCHAR,
    p_cash_pending_send OUT VARCHAR,
    p_acctnotype  OUT VARCHAR
  );

    -- Store lay thong tin so lenh
  PROCEDURE sp_get_order_all_info ( --tx6005
    f_userid IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR,
    f_seqnum IN OUT VARCHAR,
    p_placecustid IN VARCHAR,
    p_afacctno IN VARCHAR,
    p_exectype IN VARCHAR,
    p_symbol IN VARCHAR,
    p_orstatusvalue IN VARCHAR,
    p_rowperpage IN VARCHAR,
    p_pageno IN VARCHAR,
    p_isadvanced IN VARCHAR2 DEFAULT NULL
  );

  -- Store lay phi dat lenh
  PROCEDURE sp_get_fee_info (
     p_acctno IN OUT VARCHAR,
    f_symbol IN VARCHAR,
    f_exectype IN VARCHAR,
    f_pricetype IN VARCHAR,
    f_timetype IN VARCHAR,
    f_quoteprice IN NUMBER,
    f_qtty IN NUMBER,
    f_via IN VARCHAR,
    p_secureration OUT NUMBER,
    p_vatrate OUT NUMBER,
    p_maxfeerate OUT NUMBER,
    p_feeratio OUT NUMBER,
    p_err_code OUT VARCHAR
  );

  -- Store lay thong tin chung khoan
  PROCEDURE sp_get_se_info (
    f_acctno IN VARCHAR,
    f_custodycd IN VARCHAR,
    f_symbol IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR
    );

  /*PROCEDURE sp_get_se_info (
    f_acctno IN VARCHAR,
    f_custodycd IN VARCHAR,
    f_symbol IN VARCHAR,
    p_err_code OUT VARCHAR,
    p_trade OUT VARCHAR,
    p_mortgage OUT VARCHAR,
    p_total_qtty OUT VARCHAR,
    p_mrratioloan OUT VARCHAR, --ti le tinh suc mua trong ro (truong rate_margin)
    p_block OUT VARCHAR, --CK bi phong toa
    p_receiving OUT VARCHAR, --CK mua cho ve (gom : mua khop trong ngay + cho ve T1 + cho ve T2)
    p_abstanding OUT VARCHAR, --CK cam co
    p_dftrading OUT VARCHAR, --CK cam co DF
    p_avlqtty OUT VARCHAR,
    p_netting OUT VARCHAR,
    p_securities_receiving_t0 OUT VARCHAR,
    p_securities_receiving_t1 OUT VARCHAR,
    p_securities_receiving_t2 OUT VARCHAR,
    p_securities_receiving_t3 OUT VARCHAR,
    p_securities_sending_t0 OUT VARCHAR,
    p_securities_sending_t1 OUT VARCHAR,
    p_securities_sending_t2 OUT VARCHAR,
    p_securities_sending_t3 OUT VARCHAR,
    p_restrictqtty OUT VARCHAR
    );*/

  FUNCTION fn_get_withdraw(p_account IN varchar) RETURN NUMBER;
  FUNCTION fn_get_withdraw_PP(p_account IN varchar) RETURN  NUMBER;

  --Store lay thong tin tai khoan tren FO
  /*
  dung.bui added, date 19/01/2016
  */
  PROCEDURE sp_get_account_info (
    p_acctno IN VARCHAR,
    p_symbol IN VARCHAR,
    p_price IN NUMBER,
    p_balance OUT NUMBER,--tien mat
    p_debt OUT NUMBER,--tong no
    p_calc_adv OUT NUMBER,--tien ung truoc
    p_ta OUT NUMBER, --tai san quy doi
    p_ordamt OUT NUMBER,  --ki quy mua
    p_pp OUT NUMBER, --suc mua ppse
    p_pp0 OUT NUMBER, --suc mua co ban
    p_err_code OUT VARCHAR);
  FUNCTION fn_get_cash4DebtPayment(p_account IN varchar)
       RETURN  NUMBER;
  PROCEDURE sp_get_account_ppse (
    p_acctno    IN OUT VARCHAR,
    f_price     IN NUMBER,
    f_symbol    IN VARCHAR,
    p_ppse        OUT NUMBER,
    p_ppsemin     OUT NUMBER,
    p_mrrate      OUT NUMBER,
    p_maxqtty     OUT NUMBER,
    p_minqtty     OUT NUMBER,
    p_trade       OUT NUMBER,
    p_receiving   OUT NUMBER,
    p_mrratioloan OUT NUMBER,
    p_err_code OUT VARCHAR
  );

  FUNCTION fn_get_buy_amt_match(p_account IN varchar)
     RETURN  NUMBER;
END;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_account AS
 -- pkgctx plog.log_ctx;
 -- logrow tlogdebug%ROWTYPE;
  -- Store lay thong tin cac lenh da dat - tx6007
  PROCEDURE sp_get_order (
    f_acctno IN VARCHAR,
    f_custodycd IN VARCHAR,
    f_symbol IN VARCHAR,
    f_subside IN VARCHAR,
    f_status IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR
  ) AS
  v_count NUMBER;
  BEGIN
    p_err_code := '0';

     OPEN p_recordset FOR
       SELECT
        ord.TIME_SEND AS TXDATE,
        ord.ORDERID AS ORDERID,
        ord.SUBSIDE AS EXECTYPE,
        ord.SYMBOL AS SYMBOL,
        ord.QUOTE_QTTY AS ORDERQTTY,
        ord.QUOTE_PRICE AS QUOTEPRICE,
        ord.EXEC_QTTY AS EXECQTTY,
        ord.EXEC_AMT AS EXECAMT,
        (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0
              THEN 0
              ELSE (ord.EXEC_AMT / ord.EXEC_QTTY)
        End) AS EXECPRICE,
        (CASE
          WHEN ins.CFICODE IN ('ES','CW','ETF') THEN acc.RATE_BRK_S     --MSBS-1852   1.5.2.6
          WHEN ins.CFICODE = 'DB' THEN acc.RATE_BRK_B
          WHEN ins.CFICODE = 'DC' THEN acc.RATE_BRK_B
          ELSE 0
        End) AS FEERATE,
        ((CASE
          WHEN ins.CFICODE IN ('ES','CW','ETF') THEN acc.RATE_BRK_S     --MSBS-1852   1.5.2.6
          WHEN ins.CFICODE = 'DB' THEN acc.RATE_BRK_B
          WHEN ins.CFICODE = 'DC' THEN acc.RATE_BRK_B
          ELSE 0
        End) * ord.EXEC_AMT) / 100 AS FEEACR,
        (acc.RATE_TAX * ord.EXEC_AMT) / 100 AS SELLTAXAMT,
        ord.SUBSTATUS AS ORSTATUS,
        quote.VIA AS VIA,
        ord.CUSTODYCD AS CUSTODYCD,
        ord.ACCTNO AS ACCTNO
      FROM ORDERS ord, QUOTES quote, ACCOUNTS acc, INSTRUMENTS ins
      WHERE
        ord.ACCTNO = acc.ACCTNO
        AND ord.SYMBOL = ins.SYMBOL
        AND ord.QUOTEID = quote.QUOTEID
        AND ord.CUSTODYCD = f_custodycd
        AND ord.ACCTNO = f_acctno
        AND ord.SYMBOL LIKE f_symbol
        AND ord.SUBSIDE LIKE f_subside
        AND ord.STATUS LIKE f_status;

     EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_err_code := '-95014';
          OPEN p_recordset FOR SELECT 1 FROM DUAL;

    CLOSE p_recordset;
  END sp_get_order;


  -- Store lay thong tin cac lenh da khop -tx6006
  PROCEDURE sp_get_match_order (
    f_CUSTODYCD IN VARCHAR,
    f_PLACECUSTID IN VARCHAR,
    f_ROOTORDERID IN VARCHAR,
    f_ORDERID      IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR
  ) AS
    v_count NUMBER;
  BEGIN
    p_err_code := '0';
    IF f_ORDERID IS NULL THEN  --Lay du lieu phuc vu cho Mobile, Online
        OPEN p_recordset FOR

        SELECT ROOTORDERID, ORDERID, ISDETAIL, TXDATE,  TXTIME, ORSTATUSVALUE, QUOTEPRICE,
       ORDERQTTY, REMAINQTTY, MATCHQTTY, MATCHPRICE, CANCELQTTY, ADJUSTQTTY, SYMBOL
         FROM (
       /* --Khong hien thi lenh goc tren man hinh chi tiet khop lenh: tuning mstrade 25/aug/2016
        SELECT  ord.ORIGINORDERID ROOTORDERID, ord.ORDERID ORDERID, 'N' ISDETAIL,
                 ord.TXDATE, TO_CHAR(TIME_CREATED,'HH24:MI:SS') TXTIME,
                (CASE
                  WHEN (ord.SUBSTATUS = 'RR' OR ord.SUBSTATUS = 'DN' OR ord.SUBSTATUS = 'EN') THEN '0'
                  WHEN ((ord.SUBSTATUS = 'SS' AND ord.EXEC_QTTY = 0) OR ord.SUBSTATUS = 'DC' OR ord.SUBSTATUS = 'EC') THEN '2'
                  WHEN (ord.SUBSTATUS = 'DD' OR ord.SUBSTATUS = 'DS') THEN '3'
                  WHEN (ord.SUBSTATUS = 'SE') THEN 'A'
                  WHEN (ord.SUBSTATUS = 'SS' AND ord.EXEC_QTTY > 0 AND ord.REMAIN_QTTY > 0) THEN '4'
                  WHEN (ord.SUBSTATUS = 'FF') THEN '5'
                  WHEN (ord.SUBSTATUS = 'SD' OR ord.SUBSTATUS = 'DE') THEN 'C'
                  WHEN (ord.SUBSTATUS = 'NN') THEN '8'
                  WHEN (ord.SUBSTATUS = 'EE' OR ord.SUBSTATUS = 'ES') THEN '10'
                  WHEN (ord.SUBSTATUS = 'BB') THEN '11'
                  WHEN (ord.SUBSTATUS = 'SS' AND ord.REMAIN_QTTY = 0) THEN '12'
                  WHEN (ord.SUBSTATUS = 'GG') THEN '6'
                  ELSE '-1'
                END) AS ORSTATUSVALUE,
                ord.QUOTE_PRICE QUOTEPRICE,
                ord.QUOTE_QTTY ORDERQTTY,
                ord.REMAIN_QTTY REMAINQTTY,
                ord.EXEC_QTTY MATCHQTTY,
                0 MATCHPRICE,
                ord.CANCEL_QTTY CANCELQTTY,
                ord.ADMEND_QTTY ADJUSTQTTY,
                ord.SYMBOL
              FROM ORDERS ord, CUSTOMERS c
          WHERE ord.CUSTODYCD=c.CUSTODYCD
           AND (   ORD.CUSTODYCD= f_CUSTODYCD
           OR ORD.CUSTODYCD= f_PLACECUSTID
           OR c.CUSTID =   f_CUSTODYCD
           OR c.CUSTID =   f_PLACECUSTID
           OR ord.USERID=  f_PLACECUSTID
           OR ord.USERID=  f_CUSTODYCD
          )
          AND ORD.ORIGINORDERID = f_ROOTORDERID

         UNION ALL
         */
         SELECT ord.ORIGINORDERID ROOTORDERID, ord.ORDERID|| substr(t.TRADEID,-10,10) ORDERID, 'Y' ISDETAIL,
                 ord.TXDATE, TO_CHAR(t.LASTCHANGE,'HH24:MI:SS') TXTIME,
                ' ' AS ORSTATUSVALUE,
                0 QUOTEPRICE,
                0 ORDERQTTY,
                0 REMAINQTTY,
                t.QTTY MATCHQTTY,
                t.PRICE MATCHPRICE,
                0 CANCELQTTY,
                0 ADJUSTQTTY,
                ord.SYMBOL
                FROM
                  ORDERS ord, TRADES t , CUSTOMERS c
                WHERE ord.ORDERID = t.ORDERID
                  AND ord.CUSTODYCD=c.CUSTODYCD
                  AND (ORD.CUSTODYCD= f_CUSTODYCD
                   OR ORD.CUSTODYCD= f_PLACECUSTID
                   OR c.CUSTID =   f_CUSTODYCD
                   OR c.CUSTID =   f_PLACECUSTID
                   OR ord.USERID=  f_PLACECUSTID
                   OR ord.USERID=  f_CUSTODYCD
                  )
                AND ord.ORIGINORDERID = f_ROOTORDERID

          )  ORDER BY TXTIME;

    ELSE --Lay du lieu cho Home, F2.
        OPEN p_recordset FOR
         SELECT ROOTORDERID, ORDERID, ISDETAIL, TXDATE,  TXTIME, ORSTATUSVALUE, QUOTEPRICE,
                ORDERQTTY, REMAINQTTY, MATCHQTTY, MATCHPRICE, CANCELQTTY, ADJUSTQTTY, SYMBOL
         FROM (
          SELECT ord.ORIGINORDERID ROOTORDERID, ord.ORDERID|| substr(t.TRADEID,-10,10) ORDERID, 'Y' ISDETAIL,
                 ord.TXDATE, TO_CHAR(t.LASTCHANGE,'HH24:MI:SS') TXTIME,
                ' ' AS ORSTATUSVALUE,
                0 QUOTEPRICE,
                0 ORDERQTTY,
                0 REMAINQTTY,
                t.QTTY MATCHQTTY,
                t.PRICE MATCHPRICE,
                0 CANCELQTTY,
                0 ADJUSTQTTY,
                ord.SYMBOL
                FROM
                  ORDERS ord, TRADES t
                WHERE ord.ORDERID = t.ORDERID
                  AND ord.ORDERID = f_ORDERID
          )  ORDER BY TXTIME ;

    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_err_code :=  '-95014';
          OPEN p_recordset FOR SELECT 1 FROM DUAL;

  END sp_get_match_order;

   -- Store lay thong tin suc mua, tien mat, ch? thanh toan, ket noi bank tren online: tx6000
  PROCEDURE sp_get_summary_info (
    f_price IN NUMBER,
    f_symbol IN VARCHAR,
    p_err_code OUT VARCHAR,
    p_acctno IN OUT VARCHAR,
    p_balance OUT NUMBER,
    p_pp OUT NUMBER,
    p_cash_pending_send OUT NUMBER,
    p_maxqtty OUT NUMBER,
    p_mrratioloan OUT NUMBER,
    p_mrpriceloan OUT NUMBER
  ) AS
    v_formulacd VARCHAR(60);
    v_basketid VARCHAR(60);
    v_ratebrk NUMBER;
    v_t0value NUMBER;
    v_td NUMBER;
    v_payable NUMBER;
    v_debt NUMBER;
    v_advbal NUMBER;
    v_crlimit NUMBER;
    v_ordamt NUMBER;
    v_rate_margin NUMBER;
    v_price_margin NUMBER;
    v_price NUMBER;
    v_count NUMBER;
    v_bod_adv NUMBER;
    v_roomid VARCHAR(20);
    v_rate_ub NUMBER;
    v_tradelot NUMBER;
    p_err_msg VARCHAR(4000);
  BEGIN
    p_err_code := '0';
/*   INSERT INTO log_err
              (id,date_log, POSITION, text
              )
       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'sp_get_summary_info '
                                                    , ' p_acctno'    || p_acctno ||' f_price'    || f_price ||' f_symbol'    || f_symbol

              );
              COMMIT;*/

    IF((f_price is NULL OR f_price = 0) AND f_symbol IS NOT NULL) THEN
      SELECT PRICE_FL INTO v_price FROM INSTRUMENTS WHERE SYMBOL = f_symbol;
    ELSE
      v_price := f_price;
    END IF;
    /*
    IF(v_price = 0) THEN
      p_err_code := '-90021';
      RETURN;
    END IF;
    */
    -- Get account information
    SELECT  FORMULACD, RATE_BRK_S, BOD_BALANCE, BOD_T0VALUE, BOD_TD, BOD_PAYABLE, BOD_DEBT, BOD_ADV,
            CALC_ADVBAL, BOD_CRLIMIT, BASKETID, ROOMID,RATE_UB,
            SUM(BOD_SCASHT0 + BOD_SCASHT1 + BOD_SCASHT2 + BOD_SCASHT3 + BOD_SCASHTN)
      INTO v_formulacd, v_ratebrk, p_balance,
           v_t0value, v_td, v_payable, v_debt, v_bod_adv,
           v_advbal, v_crlimit, v_basketid, v_roomid,v_rate_ub, p_cash_pending_send
    FROM ACCOUNTS
    WHERE ACCTNO = p_acctno
    GROUP BY  FORMULACD, RATE_BRK_S, BOD_BALANCE, BOD_T0VALUE, BOD_TD,
              BOD_PAYABLE, BOD_DEBT, CALC_ADVBAL, BOD_CRLIMIT, BASKETID,
              CALC_ODRAMT, BOD_ADV,ROOMID,RATE_UB;

    BEGIN
       IF v_BASKETID <> 'NONE' THEN
           SELECT RATE_MARGIN, PRICE_MARGIN
           INTO p_mrratioloan, p_mrpriceloan
           FROM baskets WHERE  BASKETID =v_basketid
           AND symbol = f_symbol;
       ELSE
          p_mrratioloan:=0;
          p_mrpriceloan:=0;
       END IF;
    EXCEPTION WHEN OTHERS THEN
       p_mrratioloan:=0;
       p_mrpriceloan:=0;
    END;

     /*
    tiendt added for buy amount
    date: 2015-08-24
    */
    v_ordamt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
    /*end*/


    IF (f_symbol IS NOT NULL) THEN

        -- GET margin information
        IF (v_basketid = 'NONE') THEN
          v_rate_margin := 0;
          v_price_margin := 0;
        END IF;

        SELECT COUNT(*) INTO v_count FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = f_symbol;
        IF (v_count = 0) THEN
           v_rate_margin := 0;
           v_price_margin := 0;
        ELSE
          SELECT RATE_MARGIN, PRICE_MARGIN
            INTO v_rate_margin, v_price_margin
          FROM BASKETS
          WHERE BASKETID = v_basketid AND SYMBOL = f_symbol;
        END IF;
        -- Get purchase power: v_pp
        CSPKS_FO_COMMON.sp_get_pp(
                p_err_code,
                p_pp,
                p_acctno,
                v_formulacd,
                p_balance,
                v_t0value,
                v_td,
                v_payable,
                v_debt,
                v_ratebrk,
                v_bod_adv,
                v_advbal,
                v_crlimit,
                v_rate_margin,
                v_price_margin,
                v_price,
                v_basketid,
                v_ordamt,
                v_roomid,
                v_rate_ub,
                f_symbol,
                p_err_msg
                );
        p_pp := ROUND(p_pp,0);
        dbms_output.put_line('Suc mua p_ppse : ' || p_pp);
    ELSE
        /*CSPKS_FO_COMMON.sp_get_pp0 (
                p_err_code,
                                p_pp,
                                p_acctno,
                                v_formulacd,
                p_balance,
                v_t0value,
                v_payable,
                v_debt,
                v_bod_adv,
                v_advbal,
                v_crlimit,
                v_ordamt,
                v_roomid,
                v_rate_ub,
                p_err_msg
            ); */

        IF v_formulacd = 'CASH' THEN --tk cash ko dung tien ung truoc
          CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_pp,v_ordamt,p_acctno,p_balance,
          0,v_td,v_payable,v_debt,v_ratebrk,
          0 ,v_crlimit,0,0,v_basketid,
          v_formulacd,0,v_roomid,v_rate_ub,p_err_msg);
        ELSE
          CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_pp,v_ordamt,p_acctno,p_balance,
          0,v_td,v_payable,v_debt,v_ratebrk,
          v_advbal ,v_crlimit,0,0,v_basketid,
          v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);
        END IF;

        p_pp := ROUND(p_pp,0);
        dbms_output.put_line('Suc mua co ban p_pp0 : ' || p_pp);
    END IF;


    IF p_pp is null THEN
      p_pp := p_balance;
    END IF;

    BEGIN
    IF f_symbol IS NOT NULL THEN

      SELECT REFNVAL INTO v_tradelot FROM DEFRULES WHERE RULENAME = 'TRADELOT' AND SUBSTR(REFCODE,1,3) LIKE (SELECT EXCHANGE FROM INSTRUMENTS WHERE SYMBOL = f_symbol) AND ROWNUM = 1;

      IF(v_price is NULL OR v_price = 0) THEN
        p_maxqtty := 0;
      ELSE
        p_maxqtty := FLOOR(p_pp / (v_price*(1 + v_ratebrk/100))/NVL(v_tradelot,1)) * NVL(v_tradelot,1);
      END IF;
    ELSE
      p_maxqtty := 0;
    END IF;

    EXCEPTION WHEN OTHERS THEN
      p_maxqtty := 0;

    END;

/*INSERT INTO log_err
              (id,date_log, POSITION, text
              )
       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'sp_get_summary_info '
                                                    , ' p_acctno'    || p_acctno ||' f_price '|| f_price
                                                    ||' v_ratebrk '|| v_ratebrk
                                                    ||' v_tradelot '|| v_tradelot
                                                    ||' p_maxqtty '|| p_maxqtty
                 );*/

     dbms_output.put_line('p_pp : ' || p_pp);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_err_code :=  '-95014';


  END sp_get_summary_info;

  -- Store lay thong tin tien cua tai khoan tx6003
  PROCEDURE sp_get_ci_info (
    f_acctno IN OUT VARCHAR,
    p_balance OUT VARCHAR,
    p_cibalance OUT VARCHAR,
    p_tdbalance OUT VARCHAR,
    p_intbalance OUT VARCHAR,
    p_totalseamt OUT VARCHAR,
    p_mrqttyamt OUT VARCHAR,
    p_nonmrqttyamt OUT VARCHAR,
    p_dfqttyamt OUT VARCHAR,
    p_totalodamt OUT VARCHAR,
    p_trfbuyamt OUT VARCHAR,
    p_secureamt OUT VARCHAR,
    p_t0amt OUT VARCHAR,
    p_mramt OUT VARCHAR,
    p_rcvadvamt OUT VARCHAR,
    p_dfodamt OUT VARCHAR,
    p_tdodamt OUT VARCHAR,
    p_depofeeamt OUT VARCHAR,
    p_netassval OUT VARCHAR,
    p_sesecured OUT VARCHAR,
    p_sesecured_avl OUT VARCHAR,
    p_sesecured_buy OUT VARCHAR,
    p_accountvalue OUT VARCHAR,
    p_qttyamt OUT VARCHAR,
    p_cibalance2 OUT VARCHAR,
    p_mrcrlimit OUT VARCHAR,
    p_bankavlbal OUT VARCHAR,
    p_totalodamt2 OUT VARCHAR,
    p_rcvamt OUT VARCHAR,
    p_pp0 OUT VARCHAR,
    p_mrrate OUT VARCHAR,
    p_cash_receiving_t1 OUT VARCHAR,
    p_cash_receiving_t2 OUT VARCHAR,
    p_cash_receiving_t3 OUT VARCHAR,
    p_careceiving OUT VARCHAR,
    p_avladvance OUT VARCHAR,
    p_advanceline OUT VARCHAR,
    p_marginrate OUT VARCHAR,
    p_execbuyamt OUT VARCHAR,
    p_debt OUT VARCHAR,
    p_err_code OUT VARCHAR,
    p_cash_pending_send OUT VARCHAR,
    p_acctnotype OUT VARCHAR
  ) AS

    v_formulacd varchar(20);
    v_balance number;
    v_td number;
    v_payable number;
    v_debt number;
    v_bod_adv number;
    v_cal_adv number;
    v_crlimit number;
    v_odramt number;
    v_roomid varchar(20);
    v_rate_ub number;
    v_rate_brk number;
      v_basketid varchar(50);
    p_err_msg varchar2(4000);
    v_t0value number;
    v_temp number;
    v_ta_noroom number;
    v_custodycd varchar(20);
    v_firm varchar(4);
    v_banklink varchar(1);
  BEGIN
    p_err_code := '0';
/*
    INSERT INTO log_err
             (id,date_log, POSITION, text
              )
       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'sp_get_ci_info '
                                                    , ' f_acctno'    || f_acctno

              );*/

    SELECT cfgvalue INTO v_firm FROM sysconfig WHERE cfgkey = 'FIRM';

    SELECT BOD_BALANCE, BOD_PAYABLE, BOD_DEBT, BOD_RCASHT0, BOD_RCASHT1, BOD_RCASHT2
    INTO p_balance, p_depofeeamt, p_totalodamt2, p_cash_receiving_t1, p_cash_receiving_t2, p_cash_receiving_t3
    FROM ACCOUNTS WHERE ACCTNO = f_acctno;
    p_cibalance := 0;
    p_tdbalance := 0;
    p_intbalance := 0;
    p_totalseamt := 0;
    p_mrqttyamt := 0;
    p_nonmrqttyamt := 0;
    p_dfqttyamt := 0;
    p_totalodamt := 0;
    p_trfbuyamt := 0;
    p_secureamt := 0;
    p_t0amt := 0;
    p_mramt := 0;
    p_rcvadvamt := 0;
    p_dfodamt := 0;
    p_tdodamt := 0;
    p_netassval := 0;
    p_sesecured := 0;
    p_sesecured_avl := 0;
    p_sesecured_buy := 0;
    p_accountvalue := 0;
    p_qttyamt := 0;
    p_cibalance2 := 0;
    p_mrcrlimit := 0;
    p_bankavlbal := 0;
    p_rcvamt := 0;
    p_pp0 := 1;
    p_mrrate := 0;
    p_careceiving := 0;

    p_cash_pending_send := 0;
    p_acctnotype := '';

    SELECT FORMULACD,BOD_BALANCE,BOD_TD,BOD_PAYABLE,BOD_DEBT,BOD_ADV,CALC_ADVBAL,
      BOD_CRLIMIT,ROOMID,RATE_UB,RATE_BRK_S,BASKETID,BOD_T0VALUE, CUSTODYCD, BANKLINK
    INTO v_formulacd,v_balance,v_td,v_payable,v_debt,v_bod_adv,v_cal_adv,
      v_crlimit,v_roomid,v_rate_ub,v_rate_brk,v_basketid,v_t0value, v_custodycd, v_banklink
    FROM ACCOUNTS WHERE ACCTNO = f_acctno;

    IF v_custodycd LIKE TRIM(v_firm) || '%' THEN
        IF v_banklink = 'B' THEN
            p_acctnotype := 'B';
        ELSE
            p_acctnotype := 'C';
        END IF;
    ELSE
        p_acctnotype := 'O';
    END IF;

    v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(f_acctno);
    -- tinh suc mua PP0
    IF v_formulacd = 'CASH' THEN --tk cash ko dung tien ung truoc
      CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_pp0,v_odramt,f_acctno,v_balance,
        0,v_td,v_payable,v_debt,v_rate_brk,
        0 ,v_crlimit,0,0,v_basketid,
        v_formulacd,0,v_roomid,v_rate_ub,p_err_msg);
    ELSE
      CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_pp0,v_odramt,f_acctno,v_balance,
      0,v_td,v_payable,v_debt,v_rate_brk,
      v_cal_adv ,v_crlimit,0,0,v_basketid,
      v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);
    END IF;

    IF (p_pp0 IS NULL) THEN
      p_pp0 := 0;
    END IF;

    /*dung.bui add, date 01/02/2016*/
    --so du tien mat
    p_balance := round(v_balance - v_odramt);
    --tong so tien co the ung
    p_avladvance := trunc(v_bod_adv + v_cal_adv);
    --tong han muc t0
    p_advanceline := v_t0value;
    --tong no cua tieu khoan
    p_debt := v_debt;
    --tinh ti le thuc te cua tai khoan
    v_temp := p_balance + p_avladvance - p_debt;
    IF v_temp >= 0 THEN
      p_marginrate := 100000;
    ELSE
      --tai san ko min room theo gia va ti le tinh tai san
      v_ta_noroom := CSPKS_FO_COMMON.fn_get_ta_real_ub(f_acctno,'N','Y',v_roomid);

      p_marginrate := (v_td + v_ta_noroom) / (v_debt + v_odramt - v_balance - v_bod_adv - v_cal_adv) * 100;
      p_marginrate := trunc(p_marginrate,2);
    END IF;

    --tong ki quy khop lenh ko bao gom phi giao dich
    SELECT NVL(SUM(EXEC_AMT),0) INTO p_execbuyamt FROM ORDERS WHERE ACCTNO = f_acctno AND (SUBSIDE = 'NB' OR SUBSIDE = 'AB');
    /*end*/
    dbms_output.put_line('4'||p_execbuyamt);
    dbms_output.put_line('5'||p_err_code);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_err_code :=  '-95014';
  END sp_get_ci_info;

--Store lay thong tin so lenh: tx6005
PROCEDURE sp_get_order_all_info (
    f_userid IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR,
    f_seqnum IN OUT VARCHAR,
    p_placecustid IN VARCHAR,
    p_afacctno IN VARCHAR,
    p_exectype IN VARCHAR,
    p_symbol IN VARCHAR,
    p_orstatusvalue IN VARCHAR,
    p_rowperpage IN VARCHAR,
    p_pageno IN VARCHAR,
    p_isadvanced IN VARCHAR2 DEFAULT NULL
  ) AS
  v_via VARCHAR(100);
  v_fullname VARCHAR(100);
  v_custcd VARCHAR(100);
  v_max_seqnum VARCHAR(100);
  v_count NUMBER;

  v_afacctno VARCHAR2(20);
  v_exectype VARCHAR2(20);
  v_symbol VARCHAR2(20);
  v_orstatusvalue VARCHAR2(20);
  v_defaultTLID  VARCHAR2(20):='6868';

  v_HNX_SESSIONEX   VARCHAR2(20);
  v_HSX_SESSIONEX   VARCHAR2(20);
  v_UPC_SESSIONEX   VARCHAR2(20);
  v_today           DATE;
  BEGIN

   --plog.setbeginsection (pkgctx, 'sp_get_order_all_info');
  /*INSERT INTO log_err
                  (id,date_log, POSITION, text
                  )
           VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'sp_get_order_all_info '
                                                        , 'f_userid'||f_userid
                                                        ||' p_placecustid '|| p_placecustid
                                                        ||' p_afacctno'    || p_afacctno
                                                        ||' p_exectype'    || p_exectype
                                                        ||' p_symbol'      || p_symbol
                                                        ||' p_orstatusvalue'    || p_orstatusvalue
                                                        ||' f_seqnum'      || f_seqnum
                                                        ||' p_rowperpage'    || p_rowperpage
                                                        ||' p_pageno'    || p_pageno
                                                        ||' p_isadvanced'    || p_isadvanced
                  );
                  COMMIT;*/
   /*
   plog.debug(pkgctx,'begin sp_get_order_all_info f_userid'||f_userid
                                                        ||' p_placecustid '|| p_placecustid
                                                        ||' p_afacctno'    || p_afacctno
                                                        ||' p_exectype'    || p_exectype
                                                        ||' p_symbol'      || p_symbol
                                                        ||' p_orstatusvalue'    || p_orstatusvalue
                                                        ||' f_seqnum'      || f_seqnum
                                                        ||' p_rowperpage'    || p_rowperpage
                                                        ||' p_pageno'    || p_pageno);*/
    p_err_code := '0';

/*    SELECT COUNT(*) INTO v_count FROM ORDERS WHERE USERID = f_userid;

    IF (v_count = 0) THEN
      p_err_code := '-95014';
      OPEN p_recordset FOR SELECT 1 FROM DUAL;
      RETURN;
    END IF;*/

    IF (p_afacctno IS NULL) THEN
      v_afacctno := '%%';
    ELSE
      v_afacctno := '%' || p_afacctno || '%';
    END IF;

    IF (p_exectype IS NULL) THEN
      v_exectype := '%%';
    ELSE
      v_exectype := '%' || p_exectype || '%';
    END IF;

    IF (p_symbol IS NULL) THEN
      v_symbol := '%%';
    ELSE
      v_symbol := '%' || p_symbol || '%';
    END IF;

    IF (p_orstatusvalue IS NULL) THEN
      v_orstatusvalue := '%%';
    ELSE
      v_orstatusvalue :=  p_orstatusvalue;
    END IF;
    --Lay trang thai cac So:
    SELECT SESSIONEX INTO v_HNX_SESSIONEX FROM MARKETINFO WHERE  EXCHANGE='HNX';
    SELECT SESSIONEX INTO v_HSX_SESSIONEX FROM MARKETINFO WHERE  EXCHANGE='HSX';
    SELECT SESSIONEX INTO v_UPC_SESSIONEX FROM MARKETINFO WHERE   EXCHANGE='UPCOM';
    SELECT TODAYDATE INTO v_today  FROM WORKINGCALENDAR;


    /*BEGIN
      SELECT ords.CUSTODYCD INTO v_custcd FROM ORDERS ords WHERE  ords.USERID = f_userid AND ROWNUM <=1;
      SELECT quo.VIA INTO v_via FROM QUOTES quo WHERE quo.USERID = f_userid AND ROWNUM <=1;
      SELECT cust.FULLNAME INTO v_fullname FROM CUSTOMERS cust WHERE cust.CUSTODYCD = v_custcd AND ROWNUM <=1;
      SELECT MAX(to_number(to_char(lastchange, 'yyyymmddhh24missFF'))) INTO v_max_seqnum FROM orders WHERE (USERID = f_userid) ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OPEN p_recordset FOR SELECT 1 FROM DUAL;
        p_err_code := '-95014';
        RETURN;
    END;*/


    SELECT MAX(to_number(to_char(lastchange, 'yyyymmddhh24missFF'))) INTO v_max_seqnum
    FROM (SELECT  lastchange, userid from  orders WHERE USERID =  f_userid
          UNION ALL
          SELECT   lastchange, userid from  quotes WHERE USERID = f_userid  and status ='B'
         );


    IF p_pageno IS NOT NULL THEN
      OPEN p_recordset FOR
        SELECT rn, TXDATE, CUSTODYCD , ACCTNO , SYMBOL ,  TIME_SEND,
              SUBSIDE, STATUS, SUBTYPECD, VIA,FULLNAME, QUOTE_QTTY, QUOTE_PRICE,
              EXEC_QTTY, EXEC_AMT, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, ORDERID,
              SUBSTATUS, EXECPRICE, FEERATE, FEEAMT, ISAMEND, ISCANCEL, REFORDERID,
              ROOTORDERID, ISDISPOSAL, REMAINAMT, SEQNUM, LASTCHANGE, TRADEPLACE,
              FOACCTNO, ORSTATUSVALUE,CUSTID, HOSESESSION, CASE WHEN INSTR(CLASSCD,'.') >0  THEN 'Y' ELSE 'N' END ISADVORD
       FROM (
        SELECT
              ROWNUM rn,TXDATE, CUSTODYCD , ACCTNO , SYMBOL , TIME_SEND,
              SUBSIDE, STATUS, SUBTYPECD, VIA,FULLNAME, QUOTE_QTTY, QUOTE_PRICE,
              EXEC_QTTY, EXEC_AMT, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, ORDERID,
              SUBSTATUS, EXECPRICE, FEERATE, FEEAMT, ISAMEND, ISCANCEL, REFORDERID,
              ROOTORDERID, ISDISPOSAL, REMAINAMT, SEQNUM, LASTCHANGE, TRADEPLACE,
              FOACCTNO, ORSTATUSVALUE,CUSTID, HOSESESSION,CLASSCD
          FROM
        (

         SELECT rownum rn,TXDATE, CUSTODYCD , ACCTNO , SYMBOL , to_char(time_send,'hh24:mi:ss') TIME_SEND,
              SUBSIDE, STATUS, SUBTYPECD, VIA,FULLNAME, QUOTE_QTTY, QUOTE_PRICE,
              EXEC_QTTY, EXEC_AMT, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, ORDERID,
              SUBSTATUS, EXECPRICE, FEERATE, FEEAMT, ISAMEND, ISCANCEL, REFORDERID,
              ROOTORDERID, ISDISPOSAL, REMAINAMT, SEQNUM, LASTCHANGE, TRADEPLACE,
              FOACCTNO, ORSTATUSVALUE,CUSTID, HOSESESSION, CLASSCD
           FROM
           (
               SELECT t.TXDATE, t.CUSTODYCD, t.ACCTNO, t.SYMBOL, t.TIME_SEND,
                  CASE WHEN t.SUBSIDE IN ('AS') THEN 'NS'
                  WHEN t.SUBSIDE IN ('AB') THEN 'NB'
                  ELSE t.SUBSIDE END SUBSIDE,
                  t.STATUS, t.SUBTYPECD, t.VIA,
                  t.FULLNAME, t.QUOTE_QTTY, t.QUOTE_PRICE, t.EXEC_QTTY, t.EXEC_AMT, t.REMAIN_QTTY, t.CANCEL_QTTY, t.ADMEND_QTTY, t.ORDERID,
                  t.SUBSTATUS, Round(t.EXECPRICE) EXECPRICE, t.FEERATE, t.FEEAMT, t.ISAMEND, t.ISCANCEL,
                  case when t.REFORDERID = t.ORDERID then ' ' else t.REFORDERID end REFORDERID,
                  NVL(t.ORIGINORDERID,t.ORDERID) ROOTORDERID,
                  t.ISDISPOSAL, t.REMAINAMT, t.SEQNUM, t.LASTCHANGE, t.TRADEPLACE, t.FOACCTNO, t.ORSTATUSVALUE, t.CUSTID, t.HOSESESSION, t.CLASSCD
                FROM (
                  SELECT
                    ord.TXDATE, ord.CUSTODYCD, ord.ACCTNO, ord.SYMBOL, ord.TIME_SEND, ord.SUBSIDE,
                    (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0
                         THEN ord.STATUS || ord.SUBSTATUS
                         ELSE ord.STATUS || ord.SUBSTATUS || ' ' || ord.EXEC_QTTY || '/' || ord.QUOTE_QTTY
                    END) AS  STATUS,
                    ord.SUBTYPECD, q.VIA AS VIA,
                    c.FULLNAME AS FULLNAME,
                    ord.QUOTE_QTTY,
                    ord.QUOTE_PRICE,
                    ord.EXEC_QTTY,
                    ord.EXEC_AMT, ord.REMAIN_QTTY,
                    ord.CANCEL_QTTY, ord.ADMEND_QTTY, ord.ORDERID, --ord.EXEC_AMT,
                    ord.SUBSTATUS AS SUBSTATUS,
                    (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0
                        THEN 0
                        ELSE (ord.EXEC_AMT / ord.EXEC_QTTY)
                    End) AS EXECPRICE,
                    (CASE WHEN ord.RATE_BRK IS NULL THEN 0 ELSE ord.RATE_BRK END) AS FEERATE,
                    (CASE WHEN ord.RATE_BRK IS NULL THEN 0 ELSE ord.RATE_BRK END) AS FEEAMT,
                    (CASE WHEN ord.NORB <> 'B' AND q.via <> 'L' AND INSTR(q.classcd,'.') =0 AND (((ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES')
                                AND (ord.SUBTYPECD = 'LO')
                                AND (ord.REMAIN_QTTY > 0)
                                AND NOT (  --Cac lenh huy san HSX
                                          (instr.BOARD='HSX' AND (
                                                                  --(v_HSX_SESSIONEX IN ('OPN','BOPN') AND ord.SESSIONEX='OPN')
                                                                  --Or
                                                                  (v_HSX_SESSIONEX ='CLS' --AND ord.SESSIONEX='CLS'
                                                                  )
                                                                 )
                                           )
                                          OR
                                          (instr.BOARD='HNX' AND v_HNX_SESSIONEX IN ('L5M','CLS'))
                                         )
                               ) OR ((instr.BOARD='UPCOM') AND (ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES') AND ord.REMAIN_QTTY > 0))
                               --OR (ord.SUBSTATUS = 'NN')
                        THEN 'Y'
                        ELSE 'N'
                    End) AS ISAMEND,
                   (CASE WHEN ord.NORB <> 'B' AND q.via <> 'L' AND (((ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES')
                                AND (ord.SUBTYPECD = 'LO')
                                AND (ord.REMAIN_QTTY > 0)
                                AND NOT (  --Cac lenh huy san HSX
                                          (instr.BOARD='HSX' AND (
                                                                  --(v_HSX_SESSIONEX IN ('OPN','BOPN') AND ord.SESSIONEX='OPN')
                                                                  --Or
                                                                  (v_HSX_SESSIONEX ='CLS' --AND ord.SESSIONEX='CLS'
                                                                  )
                                                                 )
                                           )
                                          OR
                                          (instr.BOARD='HNX' AND v_HNX_SESSIONEX IN ('L5M','CLS'))
                                         )
                               )
                               OR (ord.SUBSTATUS = 'NN') AND ord.NORB <> 'B')
                               OR ((instr.BOARD='UPCOM') AND (ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES') AND ord.REMAIN_QTTY > 0)
                        THEN 'Y'
                        ELSE 'N'
                    End) AS ISCANCEL,
                    (CASE WHEN ord.REFORDERID IS NULL THEN ord.ORDERID ELSE ord.REFORDERID END) AS REFORDERID,
                    (CASE WHEN q.CLASSCD ='FSO' THEN 'Y' ELSE 'N' END)  ISDISPOSAL,
                    ord.REMAIN_QTTY * ord.QUOTE_PRICE AS REMAINAMT, v_max_seqnum AS SEQNUM, ord.LASTCHANGE AS LASTCHANGE,
                    instr.BOARD AS TRADEPLACE, ord.ORDERID AS FOACCTNO,
                     -- ,ord.STATUS || ord.SUBSTATUS AS ORSTATUSVALUE -- anhht s?a
                    (CASE
                      WHEN (ord.SUBSTATUS = 'RR' OR ord.SUBSTATUS = 'DN' OR ord.SUBSTATUS = 'EN') THEN '0'
                      WHEN ((ord.SUBSTATUS = 'SS' AND ord.EXEC_QTTY = 0) OR ord.SUBSTATUS = 'DC'
                            OR ord.SUBSTATUS = 'EC' OR (ord.SUBSTATUS = 'ES' AND ord.EXEC_QTTY = 0)) THEN '2'
                      WHEN (ord.SUBSTATUS = 'DD' OR ord.SUBSTATUS = 'DS') THEN '3'
                      WHEN (ord.SUBSTATUS = 'SE') THEN 'A'
                      WHEN (
                            (ord.SUBSTATUS = 'SS' AND ord.EXEC_QTTY > 0 AND ord.REMAIN_QTTY > 0)
                            OR (ord.SUBSTATUS = 'ES' AND ord.EXEC_QTTY > 0 AND ord.REMAIN_QTTY > 0)
                           ) THEN '4'
                      WHEN (ord.SUBSTATUS = 'FF' OR (ord.cancel_qtty >0 and ord.SUBSTATUS <> 'GG')) THEN '5'
                      WHEN (ord.SUBSTATUS = 'SD' OR ord.SUBSTATUS = 'DE') THEN 'C'
                      WHEN (ord.SUBSTATUS = 'NN') THEN '8'
                      WHEN (ord.SUBSTATUS = 'EE')  THEN '10'
                      WHEN (ord.SUBSTATUS = 'BB') THEN '11'
                      WHEN (ord.SUBSTATUS IN ('U1','U5')) THEN 'C'
                      WHEN ((ord.SUBSTATUS = 'SS' OR ord.SUBSTATUS = 'ES') AND ord.REMAIN_QTTY = 0 AND ord.cancel_qtty =0) THEN '12'
                      WHEN (ord.SUBSTATUS = 'GG') THEN '6'
                      ELSE '-1'
                    END) AS ORSTATUSVALUE , ord.ORIGINORDERID,
                    (CASE WHEN length(ord.userid) > 4 THEN ord.userid ELSE '' END) CUSTID,
                    CASE WHEN instr.BOARD='HSX' AND ord.SESSIONEX IN ('BCNT','BOPN','CNT') THEN 'O' ELSE
                    CASE WHEN instr.BOARD='HSX' AND ord.SESSIONEX IN ('OPN') THEN 'P' ELSE
                    CASE WHEN instr.BOARD='HNX' AND ord.SESSIONEX ='L5M' THEN 'A' ELSE
                    CASE WHEN instr.BOARD='HNX' AND ord.SESSIONEX IN('BCNT','CNT') THEN 'O' ELSE
                    CASE WHEN instr.BOARD='UPCOM' AND ord.SESSIONEX = 'CNT' THEN 'O' ELSE '' END END END END END HOSESESSION, q.CLASSCD
                  FROM ORDERS ord, INSTRUMENTS instr, CUSTOMERS c, quotes q
                  WHERE ord.CUSTODYCD = c.CUSTODYCD
                    AND
                    (ord.USERID = NVL(f_userid,'0')
                    OR c.CUSTID = NVL(p_placecustid,'0')
                    OR c.CUSTODYCD = NVL(p_placecustid,'0')
                    OR c.CUSTODYCD = NVL(f_userid,'0')
                    OR ord.USERID = NVL(p_placecustid,'0')
                    OR c.CUSTID = NVL(f_userid,'0')
                    OR (ord.ACCTNO LIKE v_afacctno AND  p_isadvanced ='Y')
                    )
                    AND ord.QUOTEID = q.QUOTEID
                    AND ord.SYMBOL = instr.SYMBOL
                    AND ord.STATUS || ord.SUBSTATUS IN ('NNN','BBB','SSS','SSD','DDD','SSE','EEE','EBB','EES','EEN','FFF','MMM','UU1','UU5','GGG','RRR')
                    --AND ord.NORB NOT IN ('B')
                    AND ord.ACCTNO LIKE v_afacctno
                    AND ord.subside LIKE v_exectype
                    AND ord.SUBSTATUS <> 'MM'
                    AND ord.SUBSIDE NOT IN ('CB','CS')
                    AND ord.SYMBOL LIKE v_symbol
                    AND (NVL(p_isadvanced,'N') ='N'
                          OR (p_isadvanced ='Y' AND (q.classcd ='DLO' OR q.classcd = 'CPO.DL' ) AND ord.SUBSTATUS = 'SS' AND ord.remain_qtty >0)
                         )
                    ORDER BY ord.LASTCHANGE DESC
                ) t
              WHERE t.ORSTATUSVALUE LIKE v_orstatusvalue
         UNION ALL
            select v_today txdate, a.CUSTODYCD, a.ACCTNO, q.SYMBOL, q.TIME_SEND TIME_SEND,
                decode(q.side,'N', 'NS', 'NB')  SUBSIDE,
                --CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '5' ELSE '7' END STATUS,
                CASE WHEN (NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status <> 'R') THEN 'W'
                    ELSE CASE WHEN ( NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status = 'R') THEN '6'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '0'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus NOT IN ('MM','SS')) THEN '5' ELSE  '7' END END END END STATUS,
                q.SUBTYPECD ,
                q.VIA, c.FULLNAME, q.QTTY  QUOTE_QTTY, q.PRICE QUOTE_PRICE, 0  EXEC_QTTY,  0 EXEC_AMT,
                q.QTTY  REMAIN_QTTY, 0 CANCEL_QTTY,0 ADMEND_QTTY, q.QUOTEID  ORDERID,
                --CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '5' ELSE '7' END SUBSTATUS,
                 CASE WHEN (NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status <> 'R') THEN 'W'
                    ELSE CASE WHEN ( NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status = 'R') THEN '6'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '0'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus NOT IN ('MM','SS')) THEN '5' ELSE  '7' END END END END SUBSTATUS,
                q.PRICE EXECPRICE,
                0 FEERATE, 0 FEEAMT, 'N'  ISAMEND, 'N' ISCANCEL, ' '  REFORDERID, q.QUOTEID ROOTORDERID ,
                (CASE WHEN q.CLASSCD ='FSO' THEN 'Y' ELSE 'N' END)  ISDISPOSAL,
                q.QTTY * q.PRICE AS REMAINAMT,
                v_max_seqnum AS SEQNUM,
                q.LASTCHANGE  LASTCHANGE,
                intrs.BOARD AS TRADEPLACE,
                q.QUOTEID FOACCTNO,
                --CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '5' ELSE '7' END ORSTATUSVALUE,
                CASE WHEN (NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status <> 'R') THEN 'W'
                    ELSE CASE WHEN ( NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status = 'R') THEN '6'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '0'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus NOT IN ('MM','SS')) THEN '5' ELSE  '7' END END END END ORSTATUSVALUE,
                --q.QUOTEID ORIGINORDERID,
                (CASE WHEN length(q.userid) > 4 THEN q.userid ELSE '' END) CUSTID, ' ' HOSESESSION, q.CLASSCD
                from  quotes q, --WORKINGCALENDAR w,
                customers C , ACCOUNTS a  ,INSTRUMENTS intrs--, accounts act
                where q.ACCTNO = a.ACCTNO
                and a.CUSTODYCD =c.CUSTODYCD
                and intrs.SYMBOL = q.SYMBOL
                --AND q.acctno = act.acctno
                AND a.banklink = 'B'
                AND q.side = 'B'
                --AND q.status NOT IN ('R')
                --and q.STATUS IN ('B')
                --AND NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus <> 'MM')
                AND
                (q.USERID = NVL(f_userid,'0')
                OR c.CUSTID = NVL(p_placecustid,'0')
                OR c.CUSTODYCD = NVL(p_placecustid,'0')
                OR c.CUSTODYCD = NVL(f_userid,'0')
                OR q.USERID = NVL(p_placecustid,'0')
                OR c.CUSTID = NVL(f_userid,'0')
                )
            --    AND f_seqnum < (to_number(to_char(q.lastchange, 'yyyymmddhh24missFF')))
                AND q.ACCTNO LIKE v_afacctno
                AND decode(q.side,'N', 'NS', 'NB') LIKE v_exectype
                AND q.SYMBOL LIKE v_symbol
                AND NVL(p_isadvanced,'N') ='N'
             )
          ORDER BY LASTCHANGE DESC
           )
          )
       WHERE    RN >= p_rowperpage * (p_pageno -1) + 1
         AND    RN <= p_rowperpage * (p_pageno)
       ;
    --IF f_seqnum IS NOT NULL THEN

    ELSE
      OPEN p_recordset FOR
       SELECT TXDATE, CUSTODYCD , ACCTNO , SYMBOL , to_char(time_send,'hh24:mi:ss') TIME_SEND,
              SUBSIDE, STATUS, SUBTYPECD, VIA,FULLNAME, QUOTE_QTTY, QUOTE_PRICE,
              EXEC_QTTY, EXEC_AMT, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, ORDERID,
              SUBSTATUS, Round(EXECPRICE,2) EXECPRICE, FEERATE, FEEAMT, ISAMEND, ISCANCEL, REFORDERID,
              ROOTORDERID, ISDISPOSAL, REMAINAMT, SEQNUM, LASTCHANGE, TRADEPLACE,
              FOACCTNO, ORSTATUSVALUE,CUSTID, HOSESESSION, CASE WHEN INSTR(CLASSCD,'.') >0  THEN 'Y' ELSE 'N' END ISADVORD
           FROM
           (
           SELECT t.TXDATE, t.CUSTODYCD, t.ACCTNO, t.SYMBOL, t.TIME_SEND,
              CASE WHEN t.SUBSIDE IN ('AS') THEN 'NS'
              WHEN t.SUBSIDE IN ('AB') THEN 'NB'
              ELSE t.SUBSIDE END SUBSIDE,
              t.STATUS, t.SUBTYPECD, t.VIA,
              t.FULLNAME, t.QUOTE_QTTY, t.QUOTE_PRICE, t.EXEC_QTTY, t.EXEC_AMT, t.REMAIN_QTTY,
              t.CANCEL_QTTY, t.ADMEND_QTTY, t.ORDERID,
              t.SUBSTATUS, t.EXECPRICE, t.FEERATE, t.FEEAMT, t.ISAMEND, t.ISCANCEL,
              case when t.REFORDERID = t.ORDERID then ' ' else t.REFORDERID end REFORDERID,
                NVL(t.ORIGINORDERID,t.ORDERID) ROOTORDERID,
              t.ISDISPOSAL, t.REMAINAMT, t.SEQNUM, t.LASTCHANGE, t.TRADEPLACE, t.FOACCTNO, t.ORSTATUSVALUE,
              NVL(t.CUSTID,v_defaultTLID) CUSTID, t.HOSESESSION, t.CLASSCD
            FROM(
              SELECT ord.TXDATE, ord.CUSTODYCD, ord.ACCTNO, ord.SYMBOL, ord.TIME_SEND, ord.SUBSIDE,
                (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0
                     THEN ord.STATUS || ord.SUBSTATUS
                     ELSE ord.STATUS || ord.SUBSTATUS || ' ' || ord.EXEC_QTTY || '/' || ord.QUOTE_QTTY
                END) AS  STATUS,
                ord.SUBTYPECD, q.VIA AS VIA, c.FULLNAME AS FULLNAME,
                ord.QUOTE_QTTY,
                ord.QUOTE_PRICE,
                ord.EXEC_QTTY,
                ord.EXEC_AMT,
                ord.REMAIN_QTTY,
                ord.CANCEL_QTTY,
                ord.ADMEND_QTTY,
                ord.ORDERID,-- ord.EXEC_AMT,
                ord.SUBSTATUS AS SUBSTATUS,
                (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0 THEN 0
                    ELSE (ord.EXEC_AMT / ord.EXEC_QTTY)
                End) AS EXECPRICE,
                (CASE WHEN ord.RATE_BRK IS NULL THEN 0 ELSE ord.RATE_BRK END) AS FEERATE,
                (CASE WHEN ord.RATE_BRK IS NULL THEN 0 ELSE ord.RATE_BRK END) AS FEEAMT,
                (CASE WHEN ord.NORB <> 'B' AND q.via <> 'L' AND INSTR(q.classcd,'.') =0 AND (((ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES')
                            AND (ord.SUBTYPECD = 'LO')
                            AND (ord.REMAIN_QTTY > 0)
                            AND NOT (  --Cac lenh huy san HSX
                                      (instr.BOARD='HSX' AND (
                                                              --(v_HSX_SESSIONEX IN ('OPN','BOPN') AND ord.SESSIONEX='OPN')
                                                              --Or
                                                              (v_HSX_SESSIONEX ='CLS' --AND ord.SESSIONEX='CLS' ThanhNV sua 2016.08.31
                                                              )
                                                             )
                                       )
                                      OR
                                      (instr.BOARD='HNX' AND v_HNX_SESSIONEX IN ('L5M','CLS'))
                                     )
                           ) OR ((instr.BOARD='UPCOM') AND (ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES') AND ord.REMAIN_QTTY > 0))

                    THEN 'Y'
                    ELSE 'N'
                End) AS ISAMEND,
               (CASE WHEN ord.NORB <> 'B' AND q.via <> 'L' AND (((ord.SUBSTATUS = 'SS'  OR ord.SUBSTATUS = 'ES')
                            AND ((ord.SUBTYPECD = 'LO' AND instr.BOARD='HSX') OR (ord.SUBTYPECD IN  ('LO','ATC') AND instr.BOARD IN ('HNX','UPCOM')))
                            AND (ord.REMAIN_QTTY > 0)
                            AND NOT (  --Cac lenh huy san HSX
                                      (instr.BOARD='HSX' AND (
                                                              --(v_HSX_SESSIONEX IN ('OPN','BOPN') AND ord.SESSIONEX='OPN')
                                                              --Or
                                                              (v_HSX_SESSIONEX ='CLS' --AND ord.SESSIONEX='CLS' ThanhNV sua 2016.08.31
                                                              )
                                                             )
                                       )
                                      OR
                                      (instr.BOARD='HNX' AND v_HNX_SESSIONEX IN ('L5M','CLS'))
                                     )
                           )
                           OR (ord.SUBSTATUS = 'NN') AND ord.NORB <> 'B')
                    THEN 'Y'
                    ELSE 'N'
                End) AS ISCANCEL,
                (CASE WHEN ord.REFORDERID IS NULL THEN ord.ORDERID ELSE ord.REFORDERID END) AS REFORDERID,
                (CASE WHEN q.CLASSCD ='FSO' THEN 'Y' ELSE 'N' END)  ISDISPOSAL,
                ord.REMAIN_QTTY * ord.QUOTE_PRICE AS REMAINAMT,
                v_max_seqnum AS SEQNUM, ord.LASTCHANGE AS LASTCHANGE,
                instr.BOARD AS TRADEPLACE, ord.ORDERID AS FOACCTNO,
                 -- ,ord.STATUS || ord.SUBSTATUS AS ORSTATUSVALUE -- anhht s?a
                (CASE
                  WHEN (ord.SUBSTATUS = 'RR' OR ord.SUBSTATUS = 'DN' OR ord.SUBSTATUS = 'EN') THEN '0'
                  WHEN ((ord.SUBSTATUS = 'SS' AND ord.EXEC_QTTY = 0) OR ord.SUBSTATUS = 'DC'
                        OR ord.SUBSTATUS = 'EC' OR (ord.SUBSTATUS = 'ES' AND ord.EXEC_QTTY = 0)) THEN '2'
                  WHEN (ord.SUBSTATUS = 'DD' OR ord.SUBSTATUS = 'DS') THEN '3'
                  WHEN (ord.SUBSTATUS = 'SE') THEN 'A'
                  WHEN (
                        (ord.SUBSTATUS = 'SS' AND ord.EXEC_QTTY > 0 AND ord.REMAIN_QTTY > 0)
                        OR (ord.SUBSTATUS = 'ES' AND ord.EXEC_QTTY > 0 AND ord.REMAIN_QTTY > 0)
                       ) THEN '4'
                  WHEN (ord.SUBSTATUS = 'FF' OR (ord.cancel_qtty >0 and ord.SUBSTATUS <> 'GG')) THEN '5'
                  WHEN (ord.SUBSTATUS = 'SD' OR ord.SUBSTATUS = 'DE') THEN 'C'
                  WHEN (ord.SUBSTATUS = 'NN') THEN '8'
                  WHEN (ord.SUBSTATUS = 'EE')  THEN '10'
                  WHEN (ord.SUBSTATUS = 'BB') THEN '11'
                  WHEN (ord.SUBSTATUS IN ('U1','U5')) THEN 'C'
                  WHEN ((ord.SUBSTATUS = 'SS' OR ord.SUBSTATUS = 'ES') AND ord.REMAIN_QTTY = 0 AND ord.cancel_qtty =0 ) THEN '12'
                  WHEN (ord.SUBSTATUS = 'GG') THEN '6'
                  ELSE '-1'
                END) AS ORSTATUSVALUE, ord.ORIGINORDERID,
                (CASE WHEN length(ord.userid) > 4 THEN ord.userid ELSE '' END) CUSTID,
                CASE WHEN instr.BOARD='HSX' AND ord.SESSIONEX IN ('BCNT','BOPN','CNT') THEN 'O' ELSE
                CASE WHEN instr.BOARD='HSX' AND ord.SESSIONEX IN ('OPN') THEN 'P' ELSE
                CASE WHEN instr.BOARD='HNX' AND ord.SESSIONEX ='L5M' THEN 'A' ELSE
                CASE WHEN instr.BOARD='HNX' AND ord.SESSIONEX IN('BCNT','CNT') THEN 'O' ELSE
                CASE WHEN instr.BOARD='UPCOM' AND ord.SESSIONEX = 'CNT' THEN 'O' ELSE '' END END END END END HOSESESSION, q.CLASSCD
              FROM ORDERS ord, INSTRUMENTS instr, customers c, quotes q
              WHERE ord.CUSTODYCD = c.CUSTODYCD
               AND
                (ord.USERID = NVL(f_userid,'0')
                OR c.CUSTID = NVL(p_placecustid,'0')
                OR c.CUSTODYCD = NVL(p_placecustid,'0')
                OR c.CUSTODYCD = NVL(f_userid,'0')
                OR ord.USERID = NVL(p_placecustid,'0')
                OR c.CUSTID = NVL(f_userid,'0')
                OR (ord.ACCTNO LIKE v_afacctno AND  p_isadvanced ='Y')
                )
                AND ord.QUOTEID = q.QUOTEID
                AND f_seqnum < (to_number(to_char(ord.lastchange, 'yyyymmddhh24missFF')))
                AND ord.SYMBOL = instr.SYMBOL
                AND ord.STATUS || ord.SUBSTATUS IN ('NNN','BBB','SSS','SSD','DDD','SSE','EEE','EBB','EES','EEN','FFF','MMM','UU1','UU5','GGG','RRR')
                --AND ord.NORB NOT IN ('B')
                AND ord.ACCTNO LIKE v_afacctno
                AND ord.SUBSIDE LIKE v_exectype
                AND ord.SUBSIDE NOT IN ('CB','CS')
                AND ord.SYMBOL LIKE v_symbol
                AND ord.SUBSTATUS <> 'MM'
                AND (NVL(p_isadvanced,'N') ='N'
                      OR (p_isadvanced ='Y' AND (q.classcd ='DLO' OR q.classcd = 'CPO.DL' ) AND ord.SUBSTATUS = 'SS' AND ord.remain_qtty >0)
                     )
                ORDER BY ord.ORDERID DESC
            ) t
            WHERE t.ORSTATUSVALUE LIKE v_orstatusvalue
       UNION ALL
            select v_today txdate, a.CUSTODYCD, a.ACCTNO, q.SYMBOL, q.TIME_SEND TIME_SEND,
                decode(q.side,'N', 'NS', 'NB')  SUBSIDE,
                --CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '5' ELSE '7' END STATUS,
                CASE WHEN (NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status <> 'R') THEN 'W'
                    ELSE CASE WHEN ( NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status = 'R') THEN '6'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '0'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus NOT IN ('MM','SS')) THEN '5' ELSE  '7' END END END END  STATUS,
                q.SUBTYPECD ,
                q.VIA, c.FULLNAME, q.QTTY  QUOTE_QTTY, q.PRICE QUOTE_PRICE, 0  EXEC_QTTY,  0 EXEC_AMT,
                q.QTTY  REMAIN_QTTY, 0 CANCEL_QTTY,0 ADMEND_QTTY, q.QUOTEID  ORDERID,
                --CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '5' ELSE '7' END SUBSTATUS,
                CASE WHEN (NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status <> 'R') THEN 'W'
                    ELSE CASE WHEN ( NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status = 'R') THEN '6'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '0'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus NOT IN ('MM','SS')) THEN '5' ELSE  '7' END END END END SUBSTATUS,
                q.PRICE EXECPRICE,
                0 FEERATE, 0 FEEAMT, 'N'  ISAMEND, 'N' ISCANCEL, ' '  REFORDERID, q.QUOTEID ROOTORDERID ,
                (CASE WHEN q.CLASSCD ='FSO' THEN 'Y' ELSE 'N' END)  ISDISPOSAL,
                q.QTTY * q.PRICE AS REMAINAMT,
                v_max_seqnum AS SEQNUM,
                q.LASTCHANGE  LASTCHANGE,
                intrs.BOARD AS TRADEPLACE,
                q.QUOTEID FOACCTNO,
                --CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '5' ELSE '7' END ORSTATUSVALUE,
                CASE WHEN (NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status <> 'R') THEN 'W'
                    ELSE CASE WHEN ( NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID) AND q.status = 'R') THEN '6'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus = 'MM') THEN '0'
                    ELSE CASE WHEN EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus NOT IN ('MM','SS')) THEN '5' ELSE  '7' END END END END ORSTATUSVALUE,
                --q.QUOTEID ORIGINORDERID,
                (CASE WHEN length(q.userid) > 4 THEN q.userid ELSE '' END) CUSTID, ' ' HOSESESSION, q.CLASSCD
                from  quotes q, --WORKINGCALENDAR w,
                customers C , ACCOUNTS a  ,INSTRUMENTS intrs--, accounts act
                where q.ACCTNO = a.ACCTNO
                and a.CUSTODYCD =c.CUSTODYCD
                and intrs.SYMBOL = q.SYMBOL
                --AND q.acctno = act.acctno
                AND a.banklink = 'B'
                AND q.side = 'B'
                --AND q.status NOT IN ('R')
                /*and q.STATUS = 'B'
                AND NOT EXISTS (SELECT 1 FROM orders o WHERE o.QUOTEID = q.QUOTEID And o.substatus <> 'MM')*/
                AND
                (q.USERID = NVL(f_userid,'0')
                OR c.CUSTID = NVL(p_placecustid,'0')
                OR c.CUSTODYCD = NVL(p_placecustid,'0')
                OR c.CUSTODYCD = NVL(f_userid,'0')
                OR q.USERID = NVL(p_placecustid,'0')
                OR c.CUSTID = NVL(f_userid,'0')
                )
                AND f_seqnum < (to_number(to_char(q.lastchange, 'yyyymmddhh24missFF')))
                AND q.ACCTNO LIKE v_afacctno
                AND decode(q.side,'N', 'NS', 'NB') LIKE v_exectype
                AND q.SYMBOL LIKE v_symbol
                AND NVL(p_isadvanced,'N') ='N'
           )
           ORDER BY LASTCHANGE DESC
          ;

    END IF;

    --plog.debug(pkgctx,'sp_get_order_all_info end  f_seqnum: ' || f_seqnum );

    --plog.setendsection (pkgctx, 'sp_get_order_all_info');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_err_code :=  '-95014';
        OPEN p_recordset FOR SELECT 1 FROM DUAL;
        CLOSE p_recordset;
       --plog.setendsection (pkgctx, 'sp_get_order_all_info');
  END sp_get_order_all_info;


  -- Store lay phi dat lenh: tx6001
  PROCEDURE sp_get_fee_info (
    p_acctno IN OUT VARCHAR,
    f_symbol IN VARCHAR,
    f_exectype IN VARCHAR,
    f_pricetype IN VARCHAR,
    f_timetype IN VARCHAR,
    f_quoteprice IN NUMBER,
    f_qtty IN NUMBER,
    f_via IN VARCHAR,
    p_secureration OUT NUMBER,
    p_vatrate OUT NUMBER,
    p_maxfeerate OUT NUMBER,
    p_feeratio OUT NUMBER,
    p_err_code OUT VARCHAR
  )AS
    v_symbol VARCHAR(60);
    v_rate_brk_s NUMBER;
    v_rate_brk_b NUMBER;
    v_refnval NUMBER;
  BEGIN
    p_err_code := '0';
    p_secureration := 0;
    p_vatrate := 0;
    p_maxfeerate := 0;
    p_feeratio := 0;

    SELECT CFICODE INTO v_symbol FROM INSTRUMENTS WHERE SYMBOL = f_symbol;

      IF v_symbol = 'ES' THEN
        SELECT RATE_BRK_S INTO v_rate_brk_s FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        p_secureration := v_rate_brk_s;
        p_feeratio := (f_qtty * f_quoteprice * v_rate_brk_s) / 100;
      ELSE
        SELECT RATE_BRK_S INTO v_rate_brk_b FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        p_secureration := v_rate_brk_b;
        p_feeratio := (f_qtty * f_quoteprice * v_rate_brk_b) /100 ;
      END IF;

    IF f_exectype = 'NB' OR f_exectype = 'AB' THEN
      p_vatrate := 0;
    END IF;

    IF f_exectype = 'NS' OR f_exectype = 'MS' OR f_exectype = 'TS' OR f_exectype = 'AS' THEN
      SELECT REFNVAL INTO v_refnval FROM DEFRULES WHERE REFCODE = 'VAT' AND RULENAME = 'VAT';
      p_vatrate := v_refnval/100;
    END IF;

    p_maxfeerate := p_secureration + p_vatrate;

    p_feeratio := p_secureration;

  EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-95014';
  END sp_get_fee_info;

   FUNCTION fn_get_withdraw(p_account IN varchar)
       RETURN  NUMBER
        AS
          v_cash NUMBER;
          v_temp   NUMBER;
          v_temp2  NUMBER;
          v_ta_real_ub_noroom NUMBER;
      BEGIN
        v_cash := CSPKS_FO_COMMON.fn_get_VNDwithdraw2(p_account);
        dbms_output.put_line('v_cash' || v_cash);
        RETURN v_cash;

        EXCEPTION
            WHEN OTHERS THEN
              v_cash := -1;
    END;

    FUNCTION fn_get_withdraw_PP(p_account IN varchar)
       RETURN  NUMBER
        AS
          v_cash NUMBER;

      BEGIN
        v_cash := CSPKS_FO_COMMON.fn_get_avl_balance2(p_account);
        RETURN v_cash;

        EXCEPTION
            WHEN OTHERS THEN
              v_cash := -1;
    END;
    --Lay so tien tra no, hien thi min vo so tien tra no tren 5540
    FUNCTION fn_get_cash4DebtPayment(p_account IN varchar)
       RETURN  NUMBER
        AS
          v_cash NUMBER;
          v_ta_margin NUMBER;

      BEGIN
        FOR i IN (SELECT * FROM Accounts WHERE acctno  = p_account)
        LOOP
          v_ta_margin := CSPKS_FO_COMMON.fn_get_ta(p_account,i.roomid, i.rate_ub);
          v_cash := least(i.bod_balance +  i.calc_advbal +  i.bod_adv + GREATEST(least (v_ta_margin, i.bod_crlimit- i.bod_debt),0),
                          i.bod_balance +  i.calc_advbal +  i.bod_adv);
        END LOOP;

        RETURN v_cash;

        EXCEPTION
            WHEN OTHERS THEN
              v_cash := -1;
              RETURN v_cash;
    END;
  -- Store lay thong tin chung khoan tx6004
  PROCEDURE sp_get_se_info (
    f_acctno IN VARCHAR,
    f_custodycd IN VARCHAR,
    f_symbol IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR
    )
  AS
    p_mrratioloan NUMBER;
    v_count NUMBER;
  BEGIN
    p_err_code := '0';

    /*SELECT COUNT(*) INTO v_count FROM (SELECT acctno, symbol FROM PORTFOLIOS UNION ALL SELECT acctno, symbol FROM PORTFOLIOSEX) p
    WHERE p.ACCTNO = f_acctno AND p.SYMBOL = f_symbol;
    IF (v_count = 0) THEN
      p_err_code := 'ERA0024';
      return;
    ELSE*/

     --ti le tinh suc mua trong ro (truong rate_margin)
      SELECT COUNT(1) INTO v_count FROM BASKETS B,ACCOUNTS A
        WHERE A.ACCTNO=f_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=f_symbol;
      IF v_count=0 THEN
        p_mrratioloan :=0;
      ELSIF v_count=1 THEN
          SELECT RATE_MARGIN INTO p_mrratioloan
          FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO=f_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=f_symbol;
      END IF;
     --Kiem tra co du lieu hay khong:
     SELECT count(*) INTO v_count FROM PORTFOLIOS WHERE  ACCTNO = f_acctno AND symbol =f_symbol;
     IF v_count = 0 AND f_symbol IS NOT NULL THEN
        OPEN p_recordset FOR
          SELECT f_acctno AFACCTNO, f_custodycd CUSTODYCD, f_symbol SYMBOL,
            0 TRADE,
            0 MORTGAGE,
            0 RECEIVING, --ck mua cho ve
            0 BLOCK, --ck bi phong toa dung tam truong BOD_STN
            0 SECURITIES_RECEIVING_T0,
            0 SECURITIES_RECEIVING_T1,
            0 SECURITIES_RECEIVING_T2,
            0 SECURITIES_RECEIVING_T3, --ck cho ve ngay t0 t1 t2 t3
            0 SECURITIES_SENDING_T0,
            0 SECURITIES_SENDING_T1,
            0 SECURITIES_SENDING_T2,
            0 SECURITIES_SENDING_T3, --ck cho giao t0 t1 t2 t3
            0 SELLINGQTTY,
            0 TOTAL_QTTY,
            0 NETTING,
            0 AVLQTTY, p_mrratioloan MRRATIOLOAN,
            0 RESTRICTQTTY, 0 DFTRADING
          FROM  dual;
       ELSE
         OPEN p_recordset FOR
          SELECT f_acctno AFACCTNO, f_custodycd CUSTODYCD, p.symbol SYMBOL,
            (nvl(p.TRADE,0) - nvl(p.SELLINGQTTY,0) - nvl(px.SELLINGQTTY,0)) TRADE,
            (nvl(p.MORTGAGE,0) - nvl(p.SELLINGQTTYMORT,0) - nvl(px.SELLINGQTTYMORT,0)) MORTGAGE,
            --(nvl(p.BOD_RT3,0) + nvl(px.BOD_RT3,0) + nvl(p.BOD_RT1,0) + nvl(p.BOD_RT2,0)) RECEIVING, --ck mua cho ve
            (nvl(px.BOD_RT3,0) + nvl(p.BOD_RT0,0) + nvl(p.BOD_RT1,0) + nvl(p.BOD_RT2,0)) RECEIVING, --ck mua cho ve
            nvl(p.BOD_STN,0) BLOCK, --ck bi phong toa dung tam truong BOD_STN
            nvl(p.BOD_RT0,0) SECURITIES_RECEIVING_T0,
            nvl(p.BOD_RT1,0) SECURITIES_RECEIVING_T1,
            nvl(p.BOD_RT2,0) + nvl(px.bod_rt3,0) SECURITIES_RECEIVING_T2,
            nvl(p.BOD_RT3,0) SECURITIES_RECEIVING_T3, --ck cho ve ngay t0 t1 t2 t3
            nvl(p.BOD_ST0,0) SECURITIES_SENDING_T0,
            nvl(p.BOD_ST1,0) SECURITIES_SENDING_T1,
            nvl(p.BOD_ST2,0) SECURITIES_SENDING_T2,
            nvl(p.BOD_ST3,0) SECURITIES_SENDING_T3, --ck cho giao t0 t1 t2 t3
            (nvl(p.SELLINGQTTY,0) + nvl(px.SELLINGQTTY,0)) SELLINGQTTY,
            (nvl(p.TRADE,0) - nvl(p.SELLINGQTTY,0) - nvl(px.SELLINGQTTY,0)) + (nvl(p.MORTGAGE,0) - nvl(p.SELLINGQTTYMORT,0) - nvl(px.SELLINGQTTYMORT,0)) TOTAL_QTTY,
            (nvl(p.BOD_ST0,0) + nvl(p.BOD_ST1,0) + nvl(p.BOD_ST2,0) + nvl(p.BOD_ST3,0)) NETTING,
            (nvl(p.TRADE,0) - nvl(p.SELLINGQTTY,0) - nvl(px.SELLINGQTTY,0) +
             nvl(p.BOD_ST0,0) + nvl(p.BOD_ST1,0) + nvl(p.BOD_ST2,0) + nvl(p.BOD_ST3,0) +
             nvl(p.SELLINGQTTY,0) + nvl(px.SELLINGQTTY,0) +
             nvl(p.MORTGAGE,0) - nvl(p.SELLINGQTTYMORT,0) - nvl(px.SELLINGQTTYMORT,0) +
             nvl(p.BOD_STN,0)) AVLQTTY, p_mrratioloan MRRATIOLOAN,
             0 RESTRICTQTTY, 0 DFTRADING
          FROM PORTFOLIOS p , PORTFOLIOSEX px
          WHERE p.acctno = px.acctno(+) AND p.symbol = px.symbol(+)
          AND p.ACCTNO = f_acctno
          AND (f_symbol IS NULL OR p.SYMBOL = f_symbol);
      END IF;
      /*p_trade := v_trade;
      p_mortgage := v_mortgage;
      p_total_qtty := p_trade + p_mortgage;

      --CK cam co DF
      p_dftrading := 0;
      --CK cam co
      p_abstanding :=v_mortgage;
      --CK han che chuyen nhuong
      p_restrictqtty :=0;
      --netting
      p_netting := p_securities_sending_t0 + p_securities_sending_t1 + p_securities_sending_t2 + p_securities_sending_t3;
      --avlqtty
      p_avlqtty := p_trade + p_netting + v_sellingqtty + p_mortgage + p_restrictqtty + p_block;*/


    --END IF;
  EXCEPTION WHEN OTHERS THEN
       p_err_code := '-95014';
          OPEN p_recordset FOR SELECT 1 FROM DUAL;

    CLOSE p_recordset;

  END sp_get_se_info;
/*
  -- Store lay thong tin chung khoan tx6004
  PROCEDURE sp_get_se_info (
    f_acctno IN VARCHAR,
    f_custodycd IN VARCHAR,
    f_symbol IN VARCHAR,
    p_err_code OUT VARCHAR,
    p_trade OUT VARCHAR,
    p_mortgage OUT VARCHAR,
    p_total_qtty OUT VARCHAR,
    p_mrratioloan OUT VARCHAR, --ti le tinh suc mua trong ro (truong rate_margin)
    p_block OUT VARCHAR, --CK bi phong toa
    p_receiving OUT VARCHAR, --CK mua cho ve (gom : mua khop trong ngay + cho ve T1 + cho ve T2)
    p_abstanding OUT VARCHAR, --CK cam co
    p_dftrading OUT VARCHAR, --CK cam co DF
    p_avlqtty OUT VARCHAR,
    p_netting OUT VARCHAR,
    p_securities_receiving_t0 OUT VARCHAR,--CK cho nhan t0
    p_securities_receiving_t1 OUT VARCHAR,--CK cho nhan t1
    p_securities_receiving_t2 OUT VARCHAR,--CK cho nhan t2
    p_securities_receiving_t3 OUT VARCHAR,--CK cho nhan t3
    p_securities_sending_t0 OUT VARCHAR,--CK cho giao t0
    p_securities_sending_t1 OUT VARCHAR,--CK cho giao t1
    p_securities_sending_t2 OUT VARCHAR,--CK cho giao t2
    p_securities_sending_t3 OUT VARCHAR,--CK cho giao t3
    p_restrictqtty OUT VARCHAR --CK han che chuyen nhuong
    )
  AS
    v_trade NUMBER;
    v_mortgage NUMBER;
    v_total_qtty NUMBER;
    v_count NUMBER;
    v_sellingqtty NUMBER;
  BEGIN
    p_err_code := '0';

    SELECT COUNT(*) INTO v_count FROM (SELECT acctno, symbol FROM PORTFOLIOS UNION ALL SELECT acctno, symbol FROM PORTFOLIOSEX) p
    WHERE p.ACCTNO = f_acctno AND p.SYMBOL = f_symbol;
    IF (v_count = 0) THEN
      p_err_code := 'ERA0024';
      return;
    ELSE
      SELECT (nvl(p.TRADE,0) - nvl(p.SELLINGQTTY,0) - nvl(px.SELLINGQTTY,0)),
        (nvl(p.MORTGAGE,0) - nvl(p.SELLINGQTTYMORT,0) - nvl(px.SELLINGQTTYMORT,0)),
        (nvl(p.BOD_RT3,0) + nvl(px.BOD_RT3,0) + nvl(p.BOD_RT1,0) + nvl(p.BOD_RT2,0)), --ck mua cho ve
        nvl(p.BOD_STN,0), --ck bi phong toa dung tam truong BOD_STN
        nvl(p.BOD_RT0,0),nvl(p.BOD_RT1,0),nvl(p.BOD_RT2,0),nvl(p.BOD_RT3,0), --ck cho ve ngay t0 t1 t2 t3
        nvl(p.BOD_ST0,0),nvl(p.BOD_ST1,0),nvl(p.BOD_ST2,0),nvl(p.BOD_ST3,0), --ck cho giao t0 t1 t2 t3
        (nvl(p.SELLINGQTTY,0) + nvl(px.SELLINGQTTY,0))
      INTO v_trade, v_mortgage, p_receiving, p_block,
      p_securities_receiving_t0,p_securities_receiving_t1,p_securities_receiving_t2,p_securities_receiving_t3,
      p_securities_sending_t0,p_securities_sending_t1,p_securities_sending_t2,p_securities_sending_t3,
      v_sellingqtty
      FROM PORTFOLIOS p , PORTFOLIOSEX px
      WHERE p.acctno = px.acctno(+) AND p.symbol = px.symbol(+)
      AND p.ACCTNO = f_acctno AND p.SYMBOL = f_symbol;

      p_trade := v_trade;
      p_mortgage := v_mortgage;
      p_total_qtty := p_trade + p_mortgage;

      --CK cam co DF
      p_dftrading := 0;
      --CK cam co
      p_abstanding :=v_mortgage;
      --CK han che chuyen nhuong
      p_restrictqtty :=0;
      --netting
      p_netting := p_securities_sending_t0 + p_securities_sending_t1 + p_securities_sending_t2 + p_securities_sending_t3;
      --avlqtty
      p_avlqtty := p_trade + p_netting + v_sellingqtty + p_mortgage + p_restrictqtty + p_block;

      --ti le tinh suc mua trong ro (truong rate_margin)
      SELECT COUNT(1) INTO v_count FROM BASKETS B,ACCOUNTS A
        WHERE A.ACCTNO=f_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=f_symbol;
      IF v_count=0 THEN
        p_mrratioloan :=0;
      ELSIF v_count=1 THEN
          SELECT RATE_MARGIN INTO p_mrratioloan
          FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO=f_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=f_symbol;
      END IF;
    END IF;

  END sp_get_se_info;
*/
  PROCEDURE sp_get_account_info (
            p_acctno IN VARCHAR,
            p_symbol IN VARCHAR,
            p_price IN NUMBER,
            p_balance OUT NUMBER,--tien mat
            p_debt OUT NUMBER,--tong no
            p_calc_adv OUT NUMBER,--tien ung truoc
            p_ta OUT NUMBER, --tai san quy doi
            p_ordamt OUT NUMBER,  --ki quy mua
            p_pp OUT NUMBER, --suc mua ppse
            p_pp0 OUT NUMBER, --suc mua co ban
            p_err_code OUT VARCHAR)

    AS
        v_count                 NUMBER;
        v_rate_margin       NUMBER :=0;
        v_price_margin      NUMBER :=0;
        v_ratebrk             NUMBER :=0;
        v_basketid            VARCHAR(20);
        v_formulacd           VARCHAR(20);
        v_roomid                VARCHAR(20);
        v_tovalue             NUMBER;
        v_td                      NUMBER;
        v_payable             NUMBER;
        v_bod_adv               NUMBER;
        v_calc_adv            NUMBER;
        v_crlimit               NUMBER;
        v_rate_ub               NUMBER;
        p_err_msg               VARCHAR(4000);
    BEGIN
        p_err_code := '0';
    p_pp0 :=0;
    p_pp:=0;
        --lay thong tin tai khoan
        SELECT  FORMULACD,BASKETID,ROOMID,RATE_BRK_S,BOD_BALANCE,BOD_T0VALUE,BOD_TD,
        BOD_PAYABLE,BOD_DEBT,BOD_ADV,CALC_ADVBAL,BOD_CRLIMIT,RATE_UB
        INTO v_formulacd,v_basketid,v_roomid,v_ratebrk,p_balance,v_tovalue,v_td,
           v_payable,p_debt,v_bod_adv,v_calc_adv,v_crlimit,v_rate_ub
        FROM ACCOUNTS
        WHERE ACCTNO = p_acctno;

        --lay ra tien ung truoc
        p_calc_adv := v_bod_adv + v_calc_adv;
        --lay ra ky quy mua
        p_ordamt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
        --lay ra tai san quy doi
        p_ta := CSPKS_FO_COMMON.fn_get_ta(p_acctno,v_roomid,v_rate_ub);

        --lay thong tin suc mua
    --tra ra suc mua co ban PP0

    CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_pp0,p_ordamt,p_acctno,p_balance,0/*t0value*/,v_td,
      v_payable,p_debt,v_ratebrk,v_calc_adv,v_crlimit,0,0,v_basketid,
      v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);

    p_pp0 := ROUND(p_pp0,0);
    --dbms_output.put_line('Suc mua co ban p_pp0 : ' || p_pp0);
    IF (p_symbol IS NOT NULL) THEN
      --tra ra suc mua PPSE
      IF (p_price IS NULL OR p_price = 0) THEN
        p_pp := p_pp0;
      ELSE
        SELECT COUNT(*) INTO v_count FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = p_symbol;
        IF (v_count = 1) THEN
          SELECT RATE_MARGIN,PRICE_MARGIN INTO v_rate_margin,v_price_margin FROM BASKETS
          WHERE BASKETID = v_basketid AND SYMBOL = p_symbol;
        END IF;
        CSPKS_FO_COMMON.sp_get_pp(p_err_code,p_pp,p_acctno,v_formulacd,p_balance,v_tovalue,v_td,
                v_payable,p_debt,v_ratebrk,v_bod_adv,v_calc_adv,v_crlimit,v_rate_margin,v_price_margin,
        p_price,v_basketid,p_ordamt,v_roomid,v_rate_ub,p_symbol,p_err_msg);

        p_pp := ROUND(p_pp,0);
        --dbms_output.put_line('Suc mua p_ppse : ' || p_pp);
      END IF;
    ELSE
      p_pp := p_pp0;
    END IF;

    END sp_get_account_info;


 PROCEDURE sp_get_account_ppse (
    p_acctno    IN OUT VARCHAR,
    f_price     IN NUMBER,
    f_symbol    IN VARCHAR,
    p_ppse        OUT NUMBER,
    p_ppsemin     OUT NUMBER,
    p_mrrate      OUT NUMBER,
    p_maxqtty     OUT NUMBER,
    p_minqtty     OUT NUMBER,
    p_trade       OUT NUMBER,
    p_receiving   OUT NUMBER,
    p_mrratioloan OUT NUMBER,
    p_err_code OUT VARCHAR
  )

  AS

    v_formulacd VARCHAR(60);
    v_basketid VARCHAR(60);
    v_ratebrk NUMBER;
    v_t0value NUMBER;
    v_td NUMBER;
    v_payable NUMBER;
    v_debt NUMBER;
    v_advbal NUMBER;
    v_crlimit NUMBER;
    v_ordamt NUMBER;
    v_rate_margin NUMBER;
    v_price_margin NUMBER;
    v_floor_price NUMBER;
    v_ceil_price NUMBER;
    v_count NUMBER;
    v_bod_adv NUMBER;
    v_roomid VARCHAR(20);
    v_rate_ub NUMBER;
    v_tradelot NUMBER;
    v_cash_pending_send NUMBER;
    v_balance           NUMBER;
    v_mrpriceloan       NUMBER;
    p_err_msg VARCHAR(4000);
    v_ta_noroom        NUMBER;
    v_cal_adv          NUMBER;
    v_total_debt             NUMBER(30,2);
    v_mrrate           NUMBER(20,2);

  BEGIN
    INSERT INTO log_err
              (id,date_log, POSITION, text
              )
       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'sp_get_account_ppse '
                                                    , ' p_acctno'    || p_acctno
                                                    || ' f_price'    || f_price
                                                    || ' f_symbol'    || f_symbol

              );
              COMMIT;

    p_err_code:='0';
    p_ppse    :='0';
    p_ppseMin:='0';
    p_mrrate :='0';
    p_maxQtty:='0';
    p_minQtty:='0';
    p_trade  :='0';
    p_receiving:='0';
    p_mrratioloan:='0';
    v_mrrate:=0;


     IF(f_symbol IS NOT NULL) THEN
       BEGIN
        SELECT PRICE_FL, PRICE_CE INTO v_floor_price,v_ceil_price FROM INSTRUMENTS WHERE SYMBOL = f_symbol;
       EXCEPTION WHEN OTHERS THEN
         p_err_code :=  '-95014';
         RETURN;
       END;
    END IF;


    -- Get account information
    SELECT  FORMULACD, RATE_BRK_S, BOD_BALANCE, BOD_T0VALUE, BOD_TD, BOD_PAYABLE, BOD_DEBT, BOD_ADV,
            CALC_ADVBAL, BOD_CRLIMIT, BASKETID, ROOMID,RATE_UB,
            SUM(BOD_SCASHT0 + BOD_SCASHT1 + BOD_SCASHT2 + BOD_SCASHT3 + BOD_SCASHTN),CALC_ADVBAL
      INTO v_formulacd, v_ratebrk, v_balance,
           v_t0value, v_td, v_payable, v_debt, v_bod_adv,
           v_advbal, v_crlimit, v_basketid, v_roomid,v_rate_ub, v_cash_pending_send, v_cal_adv
    FROM ACCOUNTS
    WHERE ACCTNO = p_acctno
    GROUP BY  FORMULACD, RATE_BRK_S, BOD_BALANCE, BOD_T0VALUE, BOD_TD,
              BOD_PAYABLE, BOD_DEBT, CALC_ADVBAL, BOD_CRLIMIT, BASKETID,
              CALC_ODRAMT, BOD_ADV,ROOMID,RATE_UB;

    BEGIN
       IF v_BASKETID <> 'NONE' THEN
           SELECT RATE_MARGIN, PRICE_MARGIN
           INTO p_mrratioloan, v_mrpriceloan
           FROM baskets WHERE  BASKETID =v_basketid
           AND symbol = f_symbol;
       ELSE
          p_mrratioloan:=0;
          v_mrpriceloan:=0;
       END IF;
    EXCEPTION WHEN OTHERS THEN
       p_mrratioloan:=0;
       v_mrpriceloan:=0;
    END;

     /*
    tiendt added for buy amount
    date: 2015-08-24
    */
    v_ordamt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
    /*end*/



   /*
    Neu (symbol = null) thi PPSE = PPSEMIN = PPO va MAXQTTY = MINQTTY = 0
    Neu (symbol != null  va price = 0) thi  PPSE = PPSE(gia san), PPSEMIN= PPSE(gia tran), MAXQTTY=QTTY(gia san), MINQTTY=QTTY(gia tran)
    Neu (symbol != null  va price != 0) thi  PPSE = PPSEMIN = PPSE (theo price) v? MAXQTTY = MINQTTY = QTTY(theo price)
    */

    IF f_symbol IS NULL THEN
    --Neu (symbol = null) thi PPSE = PPSEMIN = PPO va MAXQTTY = MINQTTY = 0

       IF v_formulacd = 'CASH' THEN --tk cash ko dung tien ung truoc
          CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_ppse,v_ordamt,p_acctno,v_balance,
          0,v_td,v_payable,v_debt,v_ratebrk,
          0 ,v_crlimit,0,0,v_basketid,
          v_formulacd,0,v_roomid,v_rate_ub,p_err_msg);
        ELSE
          CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,p_ppse,v_ordamt,p_acctno,v_balance,
          0,v_td,v_payable,v_debt,v_ratebrk,
          v_advbal ,v_crlimit,0,0,v_basketid,
          v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);
        END IF;

        p_ppse := ROUND(NVL(p_ppse,v_balance),0);


        p_ppsemin  :=p_ppse;
        p_maxqtty  :=0;
        p_minqtty  :=0;

        dbms_output.put_line('Suc mua p_ppse =p_ppsemin: ' || p_ppse);


    ELSIF f_symbol IS NOT NULL  THEN
        --Neu (symbol != null  va price = 0) thi  PPSE = PPSE(gia san), PPSEMIN= PPSE(gia tran), MAXQTTY=QTTY(gia san), MINQTTY=QTTY(gia tran)

        -- GET margin information
        IF (v_basketid = 'NONE') THEN
          v_rate_margin := 0;
          v_price_margin := 0;
        END IF;

        SELECT COUNT(*) INTO v_count FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = f_symbol;
        IF (v_count = 0) THEN
           v_rate_margin := 0;
           v_price_margin := 0;
        ELSE
          SELECT RATE_MARGIN, PRICE_MARGIN
            INTO v_rate_margin, v_price_margin
          FROM BASKETS
          WHERE BASKETID = v_basketid AND SYMBOL = f_symbol;
        END IF;

        SELECT REFNVAL INTO v_tradelot FROM DEFRULES WHERE RULENAME = 'TRADELOT' AND SUBSTR(REFCODE,1,3) LIKE (SELECT EXCHANGE FROM INSTRUMENTS WHERE SYMBOL = f_symbol) AND ROWNUM = 1;
        IF (f_price is NULL OR f_price = 0)  THEN
              -- Get purchase power: PPSE (gia san)
            CSPKS_FO_COMMON.sp_get_pp(
                    p_err_code,
                    p_ppse,
                    p_acctno,
                    v_formulacd,
                    v_balance,
                    v_t0value,
                    v_td,
                    v_payable,
                    v_debt,
                    v_ratebrk,
                    v_bod_adv,
                    v_advbal,
                    v_crlimit,
                    v_rate_margin,
                    v_price_margin,
                    v_floor_price,
                    v_basketid,
                    v_ordamt,
                    v_roomid,
                    v_rate_ub,
                    f_symbol,
                    p_err_msg
                    );
                dbms_output.put_line('ppse 01: '||p_ppse);
            p_ppse := ROUND(NVL(p_ppse,v_balance),0);

            p_maxqtty := FLOOR(p_ppse / (v_floor_price*(1 + v_ratebrk/100))/NVL(v_tradelot,1)) * NVL(v_tradelot,1);

            --PPSEMIN
            -- Get purchase power: PPSE (gia tran)
            CSPKS_FO_COMMON.sp_get_pp(
                    p_err_code,
                    p_ppsemin,
                    p_acctno,
                    v_formulacd,
                    v_balance,
                    v_t0value,
                    v_td,
                    v_payable,
                    v_debt,
                    v_ratebrk,
                    v_bod_adv,
                    v_advbal,
                    v_crlimit,
                    v_rate_margin,
                    v_price_margin,
                    v_ceil_price,
                    v_basketid,
                    v_ordamt,
                    v_roomid,
                    v_rate_ub,
                    f_symbol,
                    p_err_msg
                    );
                    dbms_output.put_line('ppsemin 01: '||p_ppse);
            p_ppsemin := ROUND(NVL(p_ppsemin,v_balance),0);

            p_minqtty := FLOOR(p_ppsemin / (v_ceil_price*(1 + v_ratebrk/100))/NVL(v_tradelot,1)) * NVL(v_tradelot,1);

            dbms_output.put_line('Suc mua p_ppse : ' || p_ppse);
            dbms_output.put_line('Suc mua ppsemin : ' || p_ppsemin);
            dbms_output.put_line('Khoi luong p_maxqtty : ' || p_maxqtty);
            dbms_output.put_line('Khoi luong p_minqtty : ' || p_minqtty);
      ELSIF NVL(f_price,0) <> '0' then
        --Neu (symbol != null  va price != 0) thi  PPSE = PPSEMIN = PPSE (theo price) v? MAXQTTY = MINQTTY = QTTY(theo price)
        CSPKS_FO_COMMON.sp_get_pp(
                p_err_code,
                p_ppse,
                p_acctno,
                v_formulacd,
                v_balance,
                v_t0value,
                v_td,
                v_payable,
                v_debt,
                v_ratebrk,
                v_bod_adv,
                v_advbal,
                v_crlimit,
                v_rate_margin,
                v_price_margin,
                f_price,
                v_basketid,
                v_ordamt,
                v_roomid,
                v_rate_ub,
                f_symbol,
                p_err_msg
                );

        p_ppse := ROUND(NVL(p_ppse,v_balance),0);

        p_maxqtty := FLOOR(p_ppse / (f_price*(1 + v_ratebrk/100))/NVL(v_tradelot,1)) * NVL(v_tradelot,1);
        p_ppsemin := p_ppse;
        p_minqtty :=  p_maxqtty;

/*        dbms_output.put_line('Suc mua p_ppse = ppsemin : ' || p_ppse);
        dbms_output.put_line('Khoi luong p_maxqtty = p_minqtty : ' || p_maxqtty);*/
     END IF;
    END IF;


   --Lay chung khoan duoc phep giao dich va cho ve: p_trade, p_receving
   IF f_symbol IS NOT NULL THEN
    BEGIN
        SELECT  (nvl(p.TRADE,0) - nvl(p.SELLINGQTTY,0) - nvl(px.SELLINGQTTY,0)) TRADE,
                (nvl(p.BOD_RT0,0) + nvl(px.BOD_RT3,0) + nvl(p.BOD_RT1,0) + nvl(p.BOD_RT2,0)) RECEIVING
        INTO p_trade, p_receiving
          FROM PORTFOLIOS p , PORTFOLIOSEX px
         WHERE p.acctno = px.acctno(+) AND p.symbol = px.symbol(+)
              AND p.ACCTNO = p_acctno
              AND (f_symbol IS NULL OR p.SYMBOL = f_symbol);
    EXCEPTION WHEN OTHERS THEN
       p_trade:=0;
       p_receiving:=0;
    END;

   END IF;

   --lay p_mrrate

   v_ta_noroom := CSPKS_FO_COMMON.fn_get_ta_real_ub(p_acctno,'N','Y',v_roomid);

   v_total_debt :=v_debt + v_ordamt - v_balance - v_bod_adv - v_cal_adv;

   IF v_total_debt <=0 THEN --Tai khoan khong co no.
      v_mrrate:=10000;
   ELSE
      v_mrrate := (v_td + v_ta_noroom) / (v_total_debt) * 100;
   END IF;

   p_mrrate := trunc(v_mrrate,2);


INSERT INTO log_err
              (id,date_log, POSITION, text
              )
       VALUES ( seq_log_err.NEXTVAL,SYSDATE, 'sp_get_account_ppse '
                                                    , ' p_acctno'    || p_acctno ||' p_ppse: '|| p_ppse
                                                    ||' ppsemin: '|| p_ppsemin

                 );


    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_err_code :=  '-95014';

END;

--Lay ky quy tuong ung phan khop lenh
--Dung tinh NAV
FUNCTION fn_get_buy_amt_match(p_account IN varchar)
     RETURN  NUMBER
  AS
    v_buy_amt NUMBER;
    v_quote_qtty NUMBER;
    v_exec_qtty NUMBER;
    v_exec_amt NUMBER;
    v_remain_qtty NUMBER;
    v_rate_brk NUMBER;
    v_quote_price NUMBER;
    BEGIN
    v_buy_amt := 0;

     FOR rec IN
     (
      SELECT QUOTE_QTTY, EXEC_QTTY,EXEC_AMT, REMAIN_QTTY, RATE_BRK, QUOTE_PRICE
      FROM ORDERS
      --WHERE SUBSIDE IN ('NB','AB','CB')  AND SUBSTATUS IN ('NN','BB','SS','ES','SD') AND  ACCTNO = p_account
      --tiendt add 'EE','DD' status, date: 24/10/2015
      WHERE SUBSIDE IN ('NB','AB','CB') AND SUBSTATUS IN ('NN','BB','SS','ES','U1','U5'/*,'SD'*/,'EE','DD') AND  ACCTNO = p_account
     )
     LOOP
       --phan lenh da khop
      v_buy_amt := v_buy_amt + rec.EXEC_AMT * (1+rec.RATE_BRK/100);

     END LOOP;

    --lenh da khop mot phan cua lenh giai toa, vd:MOK
     FOR rec IN
     (
      SELECT EXEC_AMT,RATE_BRK,SUBSTATUS, ORDERID,REMAIN_QTTY,QUOTE_PRICE
      FROM ORDERS
      /*dung.bui them trang thai SE cho lenh goc doi sua, date 27/11/2015*/
      WHERE SUBSIDE IN ('NB','AB','CB') AND SUBSTATUS IN ('FF','SE') AND  ACCTNO = p_account
     )
     LOOP
      v_buy_amt := v_buy_amt + rec.EXEC_AMT * (1+rec.RATE_BRK/100);

     END LOOP;


    /* dung.bui them doan code, date 29/09/2015*/
    -- cho lenh yeu cau huy san HSX
    FOR rec IN
     (
      SELECT REFORDERID
      FROM ORDERS
      WHERE SUBSIDE IN ('CB') AND SUBSTATUS IN ('DE') AND ACCTNO = p_account
     )
     LOOP
      SELECT QUOTE_QTTY,EXEC_QTTY,EXEC_AMT,REMAIN_QTTY,RATE_BRK,QUOTE_PRICE
      INTO v_quote_qtty,v_exec_qtty,v_exec_amt,v_remain_qtty,v_rate_brk,v_quote_price
      FROM ORDERS WHERE ORDERID = rec.REFORDERID;
       --phan lenh da khop
       v_buy_amt := v_buy_amt + v_exec_amt * (1+v_rate_brk/100);

    END LOOP;
    /* end */

        RETURN v_buy_amt;

    EXCEPTION
      WHEN OTHERS THEN
        v_buy_amt := -1; --undefined error
    END;


/*
  BEGIN
  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('txpks_msg',
                      plevel => NVL(logrow.loglevel,30),
                      plogtable => (NVL(logrow.log4table,'Y') = 'Y'),
                      palert => (logrow.log4alert = 'Y'),
                      ptrace => (logrow.log4trace = 'Y'));*/
END;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_ACCOUNT
