-- Start of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_NEW
-- Generated 16-Oct-2018 10:16:16 from FOTEST@FO

CREATE OR REPLACE 
PACKAGE cspks_fo_order_new

AS

  PROCEDURE sp_process_order_sell(

      p_err_code  IN OUT VARCHAR,

      p_order_id  IN OUT VARCHAR, --so hieu lenh

      p_quote_id  IN VARCHAR,     --so hieu yeu cau

      p_account   IN VARCHAR,     --so tieu khoan giao dich

      p_symbol    IN VARCHAR,     --ma chung khoan

      p_qtty      IN NUMBER,      --Khoi luong ban

      p_price     IN NUMBER,      --gia ban

      p_userid    IN VARCHAR,     --ma nguoi dung dat lenh

      p_ordertype IN VARCHAR,     --Lo?i lenh

      p_sessionex IN VARCHAR,     --phien giao dich

      p_subtypecd IN VARCHAR,     --loai lenh tuong ung voi so

      p_txdate    IN VARCHAR,

      p_err_msg OUT VARCHAR2 );

  PROCEDURE sp_proces_mortage_sell(

      p_err_code  IN OUT VARCHAR,

      p_order_id  IN OUT VARCHAR, --so hieu lenh

      p_quote_id  IN VARCHAR,     --so hieu yeu cau

      p_account   IN VARCHAR,     --so tieu khoan giao dich

      p_symbol    IN VARCHAR,     --ma chung khoan

      p_qtty      IN NUMBER,      --Khoi luong ban

      p_price     IN NUMBER,      --gia ban

      p_userid    IN VARCHAR,     --ma nguoi dung dat lenh

      p_ordertype IN VARCHAR,     --Lo?i lenh

      p_sessionex IN VARCHAR,     --phien giao dich

      p_subtypecd IN VARCHAR,     --loai lenh tuong ung voi so

      p_txdate    IN VARCHAR,

      p_err_msg OUT VARCHAR2

       );

  PROCEDURE sp_proces_total_sell(

      p_err_code  IN OUT VARCHAR,

      p_order_id  IN OUT VARCHAR, --so hieu lenh

      p_quote_id  IN VARCHAR,     --so hieu yeu cau

      p_account   IN VARCHAR,     --so tieu khoan giao dich

      p_symbol    IN VARCHAR,     --ma chung khoan

      p_qtty      IN NUMBER,      --Khoi luong ban

      p_price     IN NUMBER,      --gia ban

      p_userid    IN VARCHAR,     --ma nguoi dung dat lenh

      p_ordertype IN VARCHAR,     --Lo?i lenh

      p_sessionex IN VARCHAR,     --phien giao dich

      p_subtypecd IN VARCHAR,     --loai lenh tuong ung voi so

      p_txdate    IN VARCHAR,

      p_err_msg OUT VARCHAR2 );

  PROCEDURE sp_process_order_buy(

      p_err_code IN OUT VARCHAR,

      p_poolval  IN OUT NUMBER,

      p_orderid  IN OUT VARCHAR,

      f_qtty     IN NUMBER,

      f_price    IN NUMBER,

      f_quote_id IN VARCHAR,

      p_err_msg OUT VARCHAR2 );

  PROCEDURE sp_generate_new_order_HSX(

      p_err_code      IN OUT VARCHAR,

      p_new_orderid   IN OUT VARCHAR,

      p_order_id      IN VARCHAR, --so hieu lenh

      p_exchange_code IN VARCHAR, --ma xac nhan tu so

      p_status        IN VARCHAR, --trang thai tra ve tu so

      p_txdate        IN VARCHAR, --ngay giao dich

      p_side          IN VARCHAR, -- mua hay ban

      p_sub_side      IN VARCHAR,

      p_order_status  IN VARCHAR, --trang thai cua lenh

      p_sub_status    IN VARCHAR,

      p_acctno        IN VARCHAR, --so tieu khoan giao dich

      p_symbol        IN VARCHAR, --ma chung khoan

      p_reforderid    IN VARCHAR, --

      p_quote_qtty    IN NUMBER,  --khoi luong quote

      p_remain_qtty   IN INTEGER, --khoi luong con lai

      p_quote_price   IN NUMBER,  --gia huy/sua

      p_typecd        IN VARCHAR,

      p_userid        IN VARCHAR,

      p_quoteid       IN VARCHAR,

      p_sessionnex    IN VARCHAR,

      p_err_msg OUT VARCHAR2

             );

  PROCEDURE sp_process_corebank_order(

      p_err_code IN OUT VARCHAR,

      p_orderid  IN OUT VARCHAR,

      f_quote_id    IN VARCHAR,

      p_err_msg OUT VARCHAR2

    );





  PROCEDURE sp_update_status_order(p_err_code OUT VARCHAR,

            p_orderid IN VARCHAR,

            p_err_msg OUT VARCHAR2);



   PROCEDURE sp_process_resend_order (

        p_err_code OUT VARCHAR,

        p_err_msg OUT VARCHAR2,

        p_orderid IN VARCHAR2

    );



END CSPKS_FO_ORDER_NEW;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_order_new AS
  PROCEDURE sp_process_order_sell(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh
                p_quote_id IN VARCHAR, --so hieu yeu cau
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN  NUMBER,  --Khoi luong ban
                p_price IN  NUMBER, --gia ban
                p_userid in VARCHAR, --ma nguoi dung dat lenh
                p_ordertype in VARCHAR, --Loai lenh
                p_sessionex in VARCHAR, --phien giao dich
                p_subtypecd in VARCHAR, --loai lenh tuong ung voi so
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_trade           NUMBER;
      v_rate_brk            NUMBER;
      v_price_margin      NUMBER;
    v_price_asset     NUMBER;
      v_count               NUMBER;
    v_custodycd           ACCOUNTS.CUSTODYCD%TYPE;
      v_formulacd         ACCOUNTS.FORMULACD%TYPE;
      v_ratebrk_s         ACCOUNTS.RATE_BRK_S%TYPE;
    v_ratebrk_b           ACCOUNTS.RATE_BRK_B%TYPE;
      v_rate_tax            ACCOUNTS.RATE_TAX%TYPE;
    v_rate_adv          ACCOUNTS.RATE_ADV%TYPE;
    v_status            ORDERS.STATUS%TYPE;
    v_substatus           ORDERS.SUBSTATUS%TYPE;
    v_cficode             INSTRUMENTS.CFICODE%TYPE;
    v_exchange          INSTRUMENTS.EXCHANGE%TYPE;
    v_sesionex            MARKETINFO.SESSIONEX%TYPE;
    v_txdate                SYSCONFIG.CFGVALUE%TYPE;
    v_root_orderid    VARCHAR(20);
    v_currtime          TIMESTAMP;
      --v_dealid VARCHAR(5);
    v_trade_lot       NUMBER;
    v_classcd         VARCHAR(10);
    v_tradeEx         NUMBER;
    v_count_same_orders NUMBER;
    v_number_orders NUMBER :=1000;
    v_orgQTTy       NUMBER(20);
    v_dtlQTTy       NUMBER(20);
    v_orgQTTy_S       NUMBER(20);
    v_dtlQTTy_S       NUMBER(20);
    v_orgQTTy_B       NUMBER(20);
    v_dtlQTTy_B       NUMBER(20);

    v_orgQTTy_1       NUMBER(20);
    v_dtlQTTy_1       NUMBER(20);
    v_orgQTTy_2       NUMBER(20);
    v_dtlQTTy_2       NUMBER(20);

  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_process_order_sell p_quote_id=>'||p_quote_id;
        BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;

        SELECT CFICODE,EXCHANGE INTO v_cficode,v_exchange FROM INSTRUMENTS WHERE SYMBOL=p_symbol;

    IF v_cficode = 'DB' OR v_cficode = 'DC' OR v_cficode = 'FF' THEN
             p_err_code := '-90022';
             RETURN;
        END IF;

        SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE ACCTNO = p_account and SYMBOL= p_symbol;
        IF v_count < 1  THEN
             p_err_code := '-90024';
             RETURN;
        END IF;

        SELECT (TRADE - SELLINGQTTY) INTO v_trade FROM PORTFOLIOS WHERE ACCTNO = p_account and SYMBOL= p_symbol;
        --ThanhNV sua 12/10/2015 lay bang portfoliosEX de tranh lock.
        BEGIN
           SELECT -SELLINGQTTY INTO v_tradeEx FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
        EXCEPTION WHEN OTHERS THEN
           v_tradeEx:=0;
        END;
        v_trade := v_trade + v_tradeEx;

        IF (v_trade >= p_qtty) THEN

            --general orderid
            CSPKS_FO_COMMON.sp_get_orderid(p_err_code,p_order_id,p_err_msg);
            --update portfolios
            UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY + p_qtty WHERE ACCTNO = p_account and SYMBOL = p_symbol;
            -- Save order

            SELECT FORMULACD,CUSTODYCD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX
            INTO v_formulacd,v_custodycd,v_ratebrk_s, v_ratebrk_b,v_rate_adv,v_rate_tax
            FROM ACCOUNTS WHERE ACCTNO = p_account;

            IF v_cficode IN ('ES','CW','ETF') THEN        --MSBS-1852   1.5.2.6
              v_rate_brk := v_ratebrk_s;
            ELSE
              v_rate_brk := v_ratebrk_b;
            END IF;

            IF v_formulacd = 'CASH' OR v_formulacd = 'ADV' THEN
        v_price_margin := 0;
        v_price_asset := 0;
            END IF;

            SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';

            --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_symbol AND M.EXCHANGE=I.EXCHANGE;
            SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;

            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,p_subtypecd,v_exchange,p_err_msg);

            IF v_exchange ='HSX' THEN
              v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
              -- v_dealid := CSPKS_FO_COMMON.fn_get_dealid();

        /*tiendt added for sell lo-le
          date: 24-08-2015
        */
        SELECT REFNVAL INTO v_trade_lot FROM DEFRULES WHERE REFCODE = 'HSX.HSX' AND RULENAME = 'TRADELOT';
        IF p_qtty < v_trade_lot THEN
          p_err_code := '-95034';
          RETURN;
        END IF;

        /*IF p_qtty < 10 THEN --H
          p_err_code := '-90011';
          return;
        END IF; */
      ELSE --HNX
        IF p_qtty < 100 AND p_subtypecd != 'LO' THEN --Lenh lo le khong duoc dat lenh MK
          p_err_code := '-90011';
          return;
        END IF;

        IF p_qtty < 100 AND (v_sesionex = 'END' OR v_sesionex = 'CLS' OR v_sesionex = 'CROSS' OR v_sesionex = 'L5M') THEN --Lenh lo le khong duoc dat lenh trong phien khac phien lien tuc
          p_err_code := '-95037';
          return;
        END IF;

         --HNX check same orders

        SELECT COUNT(1) INTO v_count_same_orders FROM ORDERS o,QUOTES q
        WHERE o.CUSTODYCD=v_custodycd AND o.SYMBOL=p_symbol AND o.QUOTE_QTTY=p_qtty AND
        q.PRICE=p_price AND o.SUBSIDE='NS' AND q.subtypecd=p_subtypecd AND o.quoteid=q.quoteid AND o.NORB ='N';

        IF v_count_same_orders >= v_number_orders THEN
          p_err_code := '-95046';
          return;
        END IF;


        /*end*/
            END IF;

      /*tiendt added for force sell
       date: 2015-03-09
      */
      SELECT CLASSCD INTO v_classcd FROM QUOTES WHERE QUOTEID = p_quote_id;
      IF v_classcd = 'FSO' THEN
        v_classcd := '1';
      ELSE
        v_classcd := '2';
      END IF;
      /*end*/

--ThanhNV modify on 17-jan-2017: Check total quantity of suborder is less then quantity of origin order.
        /*IF instr(v_classcd,'.') > 0 THEN  --suborder of advanced order.


           IF v_classcd IN ('TSO.DL','STO.DL','SEO.DL','SO.DL','MCO.DL','ICO.DL','CPO.DL') THEN

            --Kluong lenh goc
            BEGIN
              SELECT qtty INTO v_orgQTTy FROM quotes WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid  = p_quote_id);
            EXCEPTION WHEN OTHERS THEN
              v_orgQTTy:=0;
            END;

             --Tong khoi luong lenh con
             BEGIN
              SELECT sum(qtty) INTO v_dtlQTTy FROM quotes WHERE quoteid IN
                 (SELECT subquoteid FROM active_orders WHERE quoteid  IN (SELECT quoteid FROM active_orders WHERE subquoteid  = p_quote_id));
             EXCEPTION WHEN OTHERS THEN
               v_dtlQTTy:=0;
             END;
             IF v_dtlQTTy > v_orgQTTy THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
             END IF;

          ELSIF v_classcd IN ('OTO.DL') THEN

            --Khoi luong lenh goc
            BEGIN
                SELECT qtty qtty_S, qtty2 qtty_b INTO v_orgQTTy_S, v_orgQTTy_B FROM oto
                WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid = p_quote_id);
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_S:=0;
               v_orgQTTy_B:=0;
             END;
            --Khoi luong lenh con
            BEGIN
                SELECT SUM(NVL(Decode(q_dtl.side,'S', q_dtl.qtty, 0),0)) dtlQTTy_S  ,
                       SUM(NVL(Decode(q_dtl.side,'B', q_dtl.qtty, 0),0)) dtlQTTy_B
                       INTO v_dtlQTTy_S, v_dtlQTTy_B FROM  quotes q_org, quotes q_dtl, active_orders a
                WHERE q_org.quoteid = a.quoteid AND q_dtl.quoteid = a.subquoteid
                AND  q_dtl.quoteid  = p_quote_id;
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_S:=0;
               v_orgQTTy_B:=0;
             END;

            IF v_dtlQTTy_S > v_orgQTTy_S OR v_dtlQTTy_B > v_orgQTTy_B  THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
             END IF;

          ELSIF v_classcd IN ('OCO.DL') THEN
           --Khoi luong lenh goc
           BEGIN
                SELECT qtty1 qtty_1, qtty2 qtty_2 INTO v_orgQTTy_1, v_orgQTTy_2 FROM oco
                WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid = p_quote_id);
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_1:=0;
               v_orgQTTy_2:=0;
             END;
            --Khoi luong lenh con
            BEGIN
                SELECT SUM(NVL(Decode(a.parentno,'1', q_dtl.qtty, 0),0)) dtlQTTy_1  ,
                       SUM(NVL(Decode(a.parentno,'2', q_dtl.qtty, 0),0)) dtlQTTy_2
                       INTO v_dtlQTTy_1, v_dtlQTTy_2 FROM  quotes q_org, quotes q_dtl, active_orders a
                WHERE q_org.quoteid = a.quoteid AND q_dtl.quoteid = a.subquoteid
                AND  q_dtl.quoteid  = p_quote_id;
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_1:=0;
               v_orgQTTy_2:=0;
             END;

            IF v_dtlQTTy_1 > v_orgQTTy_1 OR v_dtlQTTy_2 > v_orgQTTy_2  THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
            END IF;

          ELSIF v_classcd IN ('PCO.DL') THEN
              --Khoi luong lenh goc
            BEGIN
                SELECT p.qtty - NVL(p.exec_qtty,0) INTO v_orgQTTy FROM pco p
                WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid = p_quote_id);
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy:=0;
            END;
            --Tong khoi luong lenh con
             BEGIN
              SELECT SUM(o.remain_qtty + o.exec_amt) INTO v_dtlQTTy FROM orders o WHERE o.orderid IN
                 (SELECT orderid FROM active_orders WHERE quoteid  IN (SELECT quoteid FROM active_orders WHERE subquoteid  = p_quote_id));
             EXCEPTION WHEN OTHERS THEN
               v_dtlQTTy:=0;
             END;

            IF v_dtlQTTy + p_qtty  > v_orgQTTy   THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
            END IF;

          END IF;
        END IF;*/
        --End modify on 17-jan-2017


            INSERT INTO ORDERS (ORDERID,TXDATE,NORB,SESSIONEX,QUOTEID,USERID,CUSTODYCD,ACCTNO,SYMBOL,
          SIDE,SUBSIDE,STATUS,SUBSTATUS,TIME_CREATED,TIME_SEND,TYPECD,SUBTYPECD,ORIGINORDERID,
          QUOTE_PRICE,QUOTE_QTTY,EXEC_AMT,EXEC_QTTY,REMAIN_QTTY,CANCEL_QTTY,ADMEND_QTTY,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,ROOTORDERID,FLAGORDER,LASTCHANGE,PRIORITY)
            VALUES (p_order_id,to_date(v_txdate,'dd-mm-yyyy'),'N',v_sesionex,p_quote_id,p_userid,v_custodycd,p_account,p_symbol,
          'S','NS',v_status,v_substatus,v_currtime,v_currtime,p_ordertype,p_subtypecd,p_order_id,
          p_price,p_qtty,0,0,p_qtty,0,0,
                    v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_root_orderid,'C',v_currtime,v_classcd);

            -- update quotes table
            UPDATE QUOTES SET status= 'F' WHERE QUOTEID = p_quote_id;

        ELSE --Khong du CK giao dich
            p_err_code := '-90007';
            RETURN;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
       p_err_code := '-90025';
       p_err_msg:='sp_process_order_sell '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_order_sell;


  PROCEDURE sp_proces_mortage_sell(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh
                                p_quote_id IN VARCHAR, --so hieu yeu cau
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN  NUMBER,  --Khoi luong ban
                                p_price IN  NUMBER, --gia ban
                                p_userid in VARCHAR, --ma nguoi dung dat lenh
                                p_ordertype in VARCHAR, --Loai lenh
                                p_sessionex in VARCHAR, --phien giao dich
                                p_subtypecd in VARCHAR, --loai lenh tuong ung voi so
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2
                )
    AS
        v_mortage                   NUMBER;
        v_rate_brk                  NUMBER;
        v_price_margin            NUMBER;
        v_price_asset             NUMBER;
        temp                            VARCHAR(20);
    v_root_orderid            VARCHAR(20);
        v_custodycd                 ACCOUNTS.CUSTODYCD%TYPE;
        v_status                  ORDERS.STATUS%TYPE;
        v_substatus                 ORDERS.SUBSTATUS%TYPE;
        v_formulacd                 ACCOUNTS.FORMULACD%TYPE;
        v_ratebrk_s                 ACCOUNTS.RATE_BRK_S%TYPE;
        v_ratebrk_b                 ACCOUNTS.RATE_BRK_B%TYPE;
        v_rate_tax                ACCOUNTS.RATE_TAX%TYPE;
        v_rate_adv                ACCOUNTS.RATE_ADV%TYPE;
        v_cficode                     INSTRUMENTS.CFICODE%TYPE;
        v_exchange                INSTRUMENTS.EXCHANGE%TYPE;
        v_sesionex                  MARKETINFO.SESSIONEX%TYPE;
        v_txdate                      SYSCONFIG.CFGVALUE%TYPE;
        v_currtime              TIMESTAMP;
        v_tradeEx         NUMBER;
    --v_dealid VARCHAR(5);
  BEGIN
        p_err_code := '0';
        p_err_msg:='sp_proces_mortage_sell p_quote_id=>'||p_quote_id;
        BEGIN
            EXECUTE IMMEDIATE
            'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;

        -- Get symbol information
        SELECT CFICODE,EXCHANGE INTO v_cficode,v_exchange FROM INSTRUMENTS WHERE SYMBOL = p_symbol;

        IF v_cficode = 'DB' OR v_cficode = 'DC' OR v_cficode = 'FF' THEN
            p_err_code := '-90022';
            RETURN;
        END IF;

        SELECT (MORTGAGE-SELLINGQTTYMORT) INTO v_mortage FROM PORTFOLIOS WHERE ACCTNO = p_account and SYMBOL= p_symbol;

        --ThanhNV sua 12/10/2015 lay bang portfoliosEX de tranh lock.
        BEGIN
           SELECT -SELLINGQTTYMORT INTO v_tradeEx FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
        EXCEPTION WHEN OTHERS THEN
           v_tradeEx:=0;
        END;

        v_mortage := v_mortage + v_tradeEx;

        IF (v_mortage >= p_qtty) THEN --du chung khoan
            --general orderid
            CSPKS_FO_COMMON.sp_get_orderid(temp,p_order_id,p_err_msg);
            --update portfolios
            UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT + p_qtty WHERE ACCTNO = p_account and SYMBOL = p_symbol;
            -- Save order
            SELECT FORMULACD,CUSTODYCD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX
            INTO v_formulacd,v_custodycd,v_ratebrk_s, v_ratebrk_b,v_rate_adv,v_rate_tax
            FROM ACCOUNTS WHERE ACCTNO = p_account;

            IF v_cficode IN ('ES','CW','ETF') THEN        --MSBS-1852   1.5.2.6
                v_rate_brk := v_ratebrk_s;
            ELSE
                v_rate_brk := v_ratebrk_b;
            END IF;

            IF v_formulacd = 'CASH' OR v_formulacd = 'ADV' THEN
                v_price_margin := 0;
                v_price_asset := 0;
            END IF;

            --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_symbol AND M.EXCHANGE=I.EXCHANGE;
            SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
            SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';

            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,p_subtypecd,v_exchange,p_err_msg);

            IF v_exchange ='HSX' THEN
                v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
                --v_dealid := CSPKS_FO_COMMON.fn_get_dealid();
            END IF;

            INSERT INTO ORDERS (ORDERID,TXDATE,NORB,SESSIONEX,QUOTEID,USERID,CUSTODYCD,ACCTNO,SYMBOL,
          SIDE,SUBSIDE,STATUS,SUBSTATUS,TIME_CREATED,TIME_SEND,TYPECD,SUBTYPECD,ORIGINORDERID,
          QUOTE_PRICE,QUOTE_QTTY,EXEC_AMT,EXEC_QTTY,REMAIN_QTTY,CANCEL_QTTY,ADMEND_QTTY,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,ROOTORDERID,FLAGORDER,LASTCHANGE)
            VALUES (p_order_id,to_date(v_txdate,'dd-mm-yyyy'),'N',v_sesionex,p_quote_id,p_userid,v_custodycd,p_account,p_symbol,
          'S','MS',v_status,v_substatus,v_currtime,v_currtime,p_ordertype,p_subtypecd,p_order_id,
          p_price,p_qtty,0,0,p_qtty, 0, 0,
          v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_root_orderid,'C',v_currtime);

            --update quotes table
            UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;

        ELSE  --khong du chung khoan
            p_err_code := '-90007';

        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:= 'sp_proces_mortage_sell '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_mortage_sell;


  PROCEDURE sp_proces_total_sell(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh
                                p_quote_id IN VARCHAR, --so hieu yeu cau
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN  NUMBER,  --Khoi luong ban
                                p_price IN  NUMBER, --gia ban
                                p_userid in VARCHAR, --ma nguoi dung dat lenh
                                p_ordertype in VARCHAR, --Loai lenh
                                p_sessionex in VARCHAR, --phien giao dich
                                p_subtypecd in VARCHAR, --loai lenh tuong ung voi so
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2
                )
    AS
        v_total_qtty                NUMBER;
        v_mort_qtty                     NUMBER;
        v_rate_brk                      NUMBER;
        v_price_margin                NUMBER;
        v_price_asset                 NUMBER;
        temp                                VARCHAR(20);
        v_root_orderid                VARCHAR(20);
        v_currtime                      TIMESTAMP;
        v_custodycd                     ACCOUNTS.CUSTODYCD%TYPE;
        v_status                      ORDERS.STATUS%TYPE;
        v_substatus                     ORDERS.SUBSTATUS%TYPE;
        v_formulacd                     ACCOUNTS.FORMULACD%TYPE;
        v_ratebrk_s                     ACCOUNTS.RATE_BRK_S%TYPE;
        v_ratebrk_b                     ACCOUNTS.RATE_BRK_B%TYPE;
        v_rate_tax                    ACCOUNTS.RATE_TAX%TYPE;
        v_rate_adv                    ACCOUNTS.RATE_ADV%TYPE;
        v_cficode                         INSTRUMENTS.CFICODE%TYPE;
        v_exchange                    INSTRUMENTS.EXCHANGE%TYPE;
        v_sesionex                      MARKETINFO.SESSIONEX%TYPE;
        v_txdate                          SYSCONFIG.CFGVALUE%TYPE;
        v_total_qttyEx                   NUMBER;
        v_mort_qttyEx                    NUMBER;
        --v_dealid VARCHAR(5);
    BEGIN
        v_currtime := sysdate;
        p_err_code := '0';
        p_err_msg:='sp_proces_total_sell p_quote_id=>'||p_quote_id;
        SELECT CFICODE,EXCHANGE INTO v_cficode,v_exchange FROM INSTRUMENTS WHERE SYMBOL=p_symbol;

        IF v_cficode = 'DB' OR v_cficode = 'DC' OR v_cficode = 'FF' THEN
            p_err_code := '-90022';
            RETURN;
        END IF;

        SELECT (TRADE + MORTGAGE - SELLINGQTTY - SELLINGQTTYMORT),(MORTGAGE - SELLINGQTTYMORT) /*mort_qtty*/
        INTO v_total_qtty,v_mort_qtty FROM PORTFOLIOS WHERE ACCTNO = p_account and SYMBOL= p_symbol;

        --ThanhNV sua 12/10/2015 lay bang portfoliosEX de tranh lock.
        BEGIN
           SELECT - SELLINGQTTY - SELLINGQTTYMORT, - SELLINGQTTYMORT INTO v_total_qttyEx, v_mort_qttyEx
           FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
        EXCEPTION WHEN OTHERS THEN
           v_total_qttyEx:=0;
           v_mort_qttyEx:=0;
        END;
        v_total_qtty := v_total_qtty + v_total_qttyEx;
        v_mort_qtty  := v_mort_qtty + v_mort_qttyEx;
        --ThanhNV end modify

        IF (v_total_qtty = p_qtty) THEN  --du chung khoan tong
            --general orderid
            CSPKS_FO_COMMON.sp_get_orderid(temp,p_order_id,p_err_msg);

            --update portfolios
            UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY + (TRADE-SELLINGQTTY),
                                SELLINGQTTYMORT = SELLINGQTTYMORT + (MORTGAGE-SELLINGQTTYMORT)
            WHERE ACCTNO = p_account AND SYMBOL = p_symbol;

            SELECT FORMULACD,CUSTODYCD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX
            INTO v_formulacd,v_custodycd,v_ratebrk_s, v_ratebrk_b,v_rate_adv,v_rate_tax
            FROM accounts WHERE acctno = p_account;
            --SELECT B.RATE_BUY,B.PRICE_MARGIN,B.PRICE_ASSET INTO v_rate_buy ,v_price_margin,v_price_asset
            --FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO = p_account AND A.BASKETID=B.BASKETID AND B.SYMBOL=p_symbol;

            IF v_cficode IN ('ES','CW','ETF') THEN        --MSBS-1852   1.5.2.6
              v_rate_brk := v_ratebrk_s;
            ELSE
              v_rate_brk := v_ratebrk_b;
            END IF;

            IF v_formulacd = 'CASH' OR v_formulacd = 'ADV' THEN
                v_price_margin := 0;
                v_price_asset := 0;
            END IF;
             --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_symbol AND M.EXCHANGE=I.EXCHANGE;
             SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
            SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';

            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,p_subtypecd,v_exchange,p_err_msg);

            IF v_exchange ='HSX' THEN
                v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
                --v_dealid := CSPKS_FO_COMMON.fn_get_dealid();
            END IF;
      -- Save order
            INSERT INTO ORDERS (ORDERID,TXDATE,NORB,SESSIONEX,QUOTEID,USERID,CUSTODYCD,ACCTNO,SYMBOL,
                    SIDE,SUBSIDE,STATUS,SUBSTATUS,TIME_CREATED,TIME_SEND,TYPECD,SUBTYPECD,ORIGINORDERID,
                    QUOTE_PRICE, QUOTE_QTTY,EXEC_AMT,EXEC_QTTY,REMAIN_QTTY,CANCEL_QTTY,ADMEND_QTTY,LASTCHANGE,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,MORT_QTTY,ROOTORDERID,FLAGORDER)
            VALUES (p_order_id, to_date(v_txdate,'dd-mm-yyyy'),'N',v_sesionex,p_quote_id,p_userid,v_custodycd,p_account,p_symbol,
                    'S','TS',v_status,v_substatus,v_currtime,v_currtime,p_ordertype,p_subtypecd,p_order_id,
                    p_price,p_qtty,0,0,p_qtty,0,0,v_currtime,
                    v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_mort_qtty,v_root_orderid,'C');

            --update quotes table
            UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;

        ELSE  --Khong du so du chung khoan tong
            p_err_code := '-90026';
            RETURN;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_total_sell '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_total_sell;

  PROCEDURE sp_process_order_buy(p_err_code in OUT VARCHAR,
                p_poolval in OUT NUMBER, --gia tri thieu tien cua tk corebank
                p_orderid in OUT VARCHAR,
                f_qtty IN NUMBER,
                f_price IN NUMBER,
                f_quote_id IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_currtime                  TIMESTAMP;
        v_sesionex                  MARKETINFO.SESSIONEX%TYPE;
        v_acctno                    QUOTES.ACCTNO%TYPE;
        v_side                        QUOTES.SIDE%TYPE;
        v_symbol                      QUOTES.SYMBOL%TYPE;
        v_userid                      QUOTES.USERID%TYPE;
        v_typecd                      QUOTES.TYPECD%TYPE;
        v_subtypecd                 QUOTES.SUBTYPECD%TYPE;
        v_formulacd                 ACCOUNTS.FORMULACD%TYPE;
        v_custodycd                 ACCOUNTS.CUSTODYCD%TYPE;
        v_ratebrk_s                 ACCOUNTS.RATE_BRK_S%TYPE;
        v_ratebrk_b                 ACCOUNTS.RATE_BRK_B%TYPE;
        v_balance                   ACCOUNTS.BOD_BALANCE%TYPE;
        v_t0value                   ACCOUNTS.BOD_T0VALUE%TYPE;
        v_td                            ACCOUNTS.BOD_TD%TYPE;
        v_payable                   ACCOUNTS.BOD_PAYABLE%TYPE;
        v_debt                        ACCOUNTS.BOD_DEBT%TYPE;
        v_advbal                      ACCOUNTS.CALC_ADVBAL%TYPE;
        v_bod_adv                   ACCOUNTS.BOD_ADV%TYPE;
        v_crlimit                   ACCOUNTS.BOD_CRLIMIT%TYPE;
        v_rate_tax              ACCOUNTS.RATE_TAX%TYPE;
        v_rate_adv              ACCOUNTS.RATE_ADV%TYPE;
    v_rate_ub           ACCOUNTS.RATE_UB%TYPE;
        v_basketid                  ACCOUNTS.BASKETID%TYPE;
        v_ordamt                      ACCOUNTS.CALC_ODRAMT%TYPE;
        v_poolid                      ACCOUNTS.POOLID%TYPE;
        v_roomid                      ACCOUNTS.ROOMID%TYPE;
        v_ratebrk                   NUMBER;
        v_pp                            NUMBER;
        v_order_value               NUMBER;
        v_rate_buy                  BASKETS.RATE_BUY%TYPE :=0;
        v_rate_margin           BASKETS.RATE_MARGIN%TYPE :=0;
        v_price_margin          BASKETS.PRICE_MARGIN%TYPE :=0;
        v_price_asset           BASKETS.PRICE_ASSET%TYPE :=0;
        v_cficode                     INSTRUMENTS.CFICODE%TYPE;
        v_exchange            INSTRUMENTS.EXCHANGE%TYPE;
        v_count                       NUMBER;
        v_countNo                 NUMBER;
        v_countBasket         NUMBER;
        v_txdate                      SYSCONFIG.CFGVALUE%TYPE;
        v_status                ORDERS.STATUS%TYPE;
        v_substatus                 ORDERS.SUBSTATUS%TYPE;
        v_root_orderid          VARCHAR(20);
        v_count_ownpoolroom NUMBER;
    v_banklink          VARCHAR(2);
    v_count_bankaccorders NUMBER;
    v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_ownroomid     VARCHAR(20);
    v_count_same_orders NUMBER;
    v_number_orders NUMBER :=1000;
    v_formulacd_rtn number(20);
    v_firm varchar2(100);
    v_count_blacklist_ex number(20);
    v_classcd     VARCHAR(20);
    v_orgQTTy       NUMBER(20);
    v_dtlQTTy       NUMBER(20);
    v_orgQTTy_S       NUMBER(20);
    v_dtlQTTy_S       NUMBER(20);
    v_orgQTTy_B       NUMBER(20);
    v_dtlQTTy_B       NUMBER(20);

    v_orgQTTy_1       NUMBER(20);
    v_dtlQTTy_1       NUMBER(20);
    v_orgQTTy_2       NUMBER(20);
    v_dtlQTTy_2       NUMBER(20);
  BEGIN
    --DBMS_OUTPUT.ENABLE;
        p_err_msg:='sp_process_order_buy f_quote_id=>'||f_quote_id;
        BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;

        p_err_code := '0';

        -- Get quote information
        SELECT ACCTNO,SIDE,SYMBOL,USERID,TYPECD,SUBTYPECD, CLASSCD
        INTO v_acctno,v_side,v_symbol,v_userid,v_typecd,v_subtypecd,v_classcd
        FROM QUOTES WHERE QUOTEID=f_quote_id;


        --ThanhNV modify on 17-jan-2017: Check total quantity of suborder is less then quantity of origin order.
        /*IF instr(v_classcd,'.') > 0 THEN  --suborder of advanced order.


           IF v_classcd IN ('TSO.DL','STO.DL','SEO.DL','SO.DL','MCO.DL','ICO.DL','CPO.DL') THEN

            --Kluong lenh goc
            BEGIN
              SELECT qtty INTO v_orgQTTy FROM quotes WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid  = f_quote_id);
            EXCEPTION WHEN OTHERS THEN
              v_orgQTTy:=0;
            END;

             --Tong khoi luong lenh con
             BEGIN
              SELECT sum(qtty) INTO v_dtlQTTy FROM quotes WHERE quoteid IN
                 (SELECT subquoteid FROM active_orders WHERE quoteid  IN (SELECT quoteid FROM active_orders WHERE subquoteid  = f_quote_id));
             EXCEPTION WHEN OTHERS THEN
               v_dtlQTTy:=0;
             END;
             IF v_dtlQTTy > v_orgQTTy THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
             END IF;

          ELSIF v_classcd IN ('OTO.DL') THEN

            --Khoi luong lenh goc
            BEGIN
                SELECT qtty qtty_S, qtty2 qtty_b INTO v_orgQTTy_S, v_orgQTTy_B FROM oto
                WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid = f_quote_id);
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_S:=0;
               v_orgQTTy_B:=0;
             END;
            --Khoi luong lenh con
            BEGIN
                SELECT SUM(NVL(Decode(q_dtl.side,'S', q_dtl.qtty, 0),0)) dtlQTTy_S  ,
                       SUM(NVL(Decode(q_dtl.side,'B', q_dtl.qtty, 0),0)) dtlQTTy_B
                       INTO v_dtlQTTy_S, v_dtlQTTy_B FROM  quotes q_org, quotes q_dtl, active_orders a
                WHERE q_org.quoteid = a.quoteid AND q_dtl.quoteid = a.subquoteid
                AND  q_dtl.quoteid  = f_quote_id;
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_S:=0;
               v_orgQTTy_B:=0;
             END;

            IF v_dtlQTTy_S > v_orgQTTy_S OR v_dtlQTTy_B > v_orgQTTy_B  THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
             END IF;

          ELSIF v_classcd IN ('OCO.DL') THEN
           --Khoi luong lenh goc
           BEGIN
                SELECT qtty1 qtty_1, qtty2 qtty_2 INTO v_orgQTTy_1, v_orgQTTy_2 FROM oco
                WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid = f_quote_id);
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_1:=0;
               v_orgQTTy_2:=0;
             END;
            --Khoi luong lenh con
            BEGIN
                SELECT SUM(NVL(Decode(a.parentno,'1', q_dtl.qtty, 0),0)) dtlQTTy_1  ,
                       SUM(NVL(Decode(a.parentno,'2', q_dtl.qtty, 0),0)) dtlQTTy_2
                       INTO v_dtlQTTy_1, v_dtlQTTy_2 FROM  quotes q_org, quotes q_dtl, active_orders a
                WHERE q_org.quoteid = a.quoteid AND q_dtl.quoteid = a.subquoteid
                AND  q_dtl.quoteid  = f_quote_id;
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy_1:=0;
               v_orgQTTy_2:=0;
             END;

            IF v_dtlQTTy_1 > v_orgQTTy_1 OR v_dtlQTTy_2 > v_orgQTTy_2  THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
            END IF;

          ELSIF v_classcd IN ('PCO.DL') THEN
              --Khoi luong lenh goc
            BEGIN
                SELECT p.qtty - NVL(p.exec_qtty,0) INTO v_orgQTTy FROM pco p
                WHERE quoteid IN (SELECT quoteid FROM active_orders WHERE subquoteid = f_quote_id);
            EXCEPTION WHEN OTHERS THEN
               v_orgQTTy:=0;
            END;
            --Tong khoi luong lenh con
             BEGIN
              SELECT SUM(o.remain_qtty + o.exec_amt) INTO v_dtlQTTy FROM orders o WHERE o.orderid IN
                 (SELECT orderid FROM active_orders WHERE quoteid  IN (SELECT quoteid FROM active_orders WHERE subquoteid  = f_quote_id));
             EXCEPTION WHEN OTHERS THEN
               v_dtlQTTy:=0;
             END;

            IF v_dtlQTTy + f_qtty  > v_orgQTTy   THEN
               p_err_code := '-95018'; --Khoi luong khong hop le
               RETURN;
            END IF;

          END IF;
        END IF;*/
        --End modify on 17-jan-2017


        -- Get symbol information
        SELECT CFICODE,EXCHANGE INTO v_cficode,v_exchange FROM INSTRUMENTS WHERE SYMBOL=v_symbol;
        --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
        SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= v_symbol AND M.EXCHANGE=I.BOARD;

        -- Get account information
        SELECT FORMULACD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX,BOD_BALANCE,BOD_DEBT_T0,
      BOD_D_MARGIN,BOD_D_MARGIN_UB,BOD_T0VALUE,BOD_TD,BOD_PAYABLE,BOD_DEBT,POOLID,ROOMID,CUSTODYCD,
      BOD_ADV,CALC_ADVBAL,BOD_CRLIMIT,BASKETID,CALC_ODRAMT,BANKLINK,RATE_UB
        INTO v_formulacd,v_ratebrk_s,v_ratebrk_b,v_rate_adv,v_rate_tax,v_balance,v_bod_debt_t0,
      v_bod_d_margin,v_bod_d_margin_ub,v_t0value,v_td,v_payable,v_debt,v_poolid,v_roomid,v_custodycd,
      v_bod_adv,v_advbal,v_crlimit,v_basketid,v_ordamt,v_banklink,v_rate_ub
        FROM ACCOUNTS WHERE ACCTNO=v_acctno;

    --check lenh lo le
    IF v_exchange = 'HSX' THEN
      IF f_qtty < 10 THEN
        p_err_code := '-90011';
        return;
      END IF;
    ELSE --HNX
      IF f_qtty < 100 AND v_typecd != 'LO' THEN --Lenh lo le khong duoc dat lenh MK
        p_err_code := '-90011';
        return;
      END IF;

      IF f_qtty < 100 AND (v_sesionex = 'END' OR v_sesionex = 'CLS' OR v_sesionex = 'CROSS' OR v_sesionex = 'L5M') THEN --Lenh lo le khong duoc dat lenh trong phien khac phien lien tuc
        p_err_code := '-95037';
        return;
      END IF;

      --HNX check same orders
      SELECT COUNT(1) INTO v_count_same_orders FROM ORDERS o,QUOTES q
      WHERE o.CUSTODYCD=v_custodycd AND o.SYMBOL=v_symbol AND o.QUOTE_QTTY=f_qtty AND
        q.PRICE=f_price AND o.SUBSIDE='NB' AND q.subtypecd=v_subtypecd AND o.quoteid=q.quoteid  AND o.NORB ='N';

      IF v_count_same_orders >= v_number_orders THEN
        p_err_code := '-95046';
        return;
      END IF;
      /*
      SELECT COUNT(1) v_count_same_orders
      FROM  (SELECT ORDERID,SYMBOL,QUOTE_QTTY,QUOTE_PRICE,CUSTODYCD,SUBSIDE  FROM ORDERS
                   WHERE CUSTODYCD='091C000952' AND ROWNUM <=29 ORDER BY ORDERID) O
      WHERE SYMBOL=v_symbol AND QUOTE_QTTY=f_qtty AND QUOTE_PRICE=f_price AND SUBSIDE='NB' AND SUBTYPECD=v_subtypecd;
      IF v_count_same_orders >= 29 THEN
        p_err_code := '-95046';
        return;
      END IF;
      */
    END IF;

        IF v_cficode = 'DB' OR v_cficode = 'DC' OR v_cficode = 'FF' THEN
            p_err_code := '-90022';
            RETURN;
        END IF;



        IF v_cficode IN ('ES','CW','ETF') THEN        --MSBS-1852   1.5.2.6
          v_ratebrk := v_ratebrk_s;
        ELSE
          v_ratebrk := v_ratebrk_b;
        END IF;

        SELECT COUNT(1) INTO v_count FROM BASKETS B,ACCOUNTS A
        WHERE A.ACCTNO=v_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=v_symbol;

        IF v_formulacd != 'CASH' AND v_formulacd != 'ADV' THEN
            IF v_cficode = 'CW' THEN
              p_err_code := '-90031';
              RETURN;
            END IF;
            IF v_count=1 THEN
                SELECT B.RATE_BUY,RATE_MARGIN,B.PRICE_MARGIN,B.PRICE_ASSET INTO v_rate_buy,v_rate_margin,v_price_margin,v_price_asset
                FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO = v_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=v_symbol;
            END IF;
        END IF;

        -- Validate purchase power
        -- Calculate order buy value
        v_order_value := f_qtty * f_price * (1 + v_ratebrk/100);
        --dbms_output.put_line('ORDER VALUE: ' || v_order_value);
    v_ordamt := CSPKS_FO_COMMON.fn_get_buy_amt(v_acctno);
    --dbms_output.put_line('v_ordamt : ' || v_ordamt);

      /*
    tiendt added for t0value can not buy symbol in BLACK_LIST
    date: 2015-08-26
    */
    SELECT COUNT(1) INTO v_count FROM BASKETS WHERE BASKETID='BLACK_LIST' AND SYMBOL=v_symbol;
    --dung.bui comment and edit code below, date 28/08/2015
    IF v_count > 0 AND v_t0value > 0 THEN

      --ThanhNV sua 29.9 kiem tra tk co phai loai tru voi ma BLACKLIST ko, neu loai tru thi ko check.
      SELECT count(*) INTO v_count_blacklist_ex FROM BASKETS
      WHERE instr(basketid,'BLACK_LIST') > 0 AND instr(basketid,v_acctno)>0 AND SYMBOL=v_symbol;

      --Kiem tra firm, neu la luu ky nuoc ngoai thi ko check:
      SELECT cfgvalue INTO v_Firm FROM sysconfig WHERE  cfgkey ='FIRM';
      IF  substr(v_custodycd,1,3) =  v_Firm  AND v_count_blacklist_ex =0  THEN

        p_err_code := '-95035';
        RETURN;
      END IF;
    ELSE

      CSPKS_FO_COMMON.sp_get_pp(p_err_code,v_pp,v_acctno,v_formulacd,v_balance,v_t0value,v_td,v_payable,
        v_debt,v_ratebrk,v_bod_adv,v_advbal,v_crlimit,v_rate_margin,v_price_margin,f_price,
        v_basketid,v_ordamt,v_roomid,v_rate_ub,v_symbol,p_err_msg);
    END IF;

        IF v_order_value > v_pp THEN
      IF v_banklink = 'B' THEN --tlk corebank
        p_poolval := ceil(v_order_value - v_pp); --lam tron phan tien hold
        SELECT COUNT(1) INTO v_count_bankaccorders FROM BANKACCORDERS WHERE QUOTEID = f_quote_id;
        IF v_count_bankaccorders > 0 THEN
           p_err_code := '-95036';
        ELSE
           INSERT INTO BANKACCORDERS(QUOTEID,ACCTNO,AMOUNT,STATUS,LASTCHANGE)
           VALUES(f_quote_id,v_acctno,p_poolval,'N', v_currtime);
           p_err_code := '-95555';
           p_orderid := f_quote_id;
           UPDATE QUOTES SET STATUS='B', LASTCHANGE=v_currtime WHERE QUOTEID=f_quote_id; --for show wait order on interface
        END IF;

        RETURN;
      END IF;

            p_err_code := '-90016';
            UPDATE QUOTES SET STATUS='R', LASTCHANGE=v_currtime WHERE QUOTEID=f_quote_id;
      --Xu ly tra ve ma loi cho viec dung bao lanh mua ck dac biet
      /*IF v_count > 0 THEN
        CSPKS_FO_COMMON.sp_get_pp(p_err_code,v_pp,v_acctno,v_formulacd,v_balance,v_t0value,v_td,v_payable,
                v_debt,v_ratebrk,v_bod_adv,v_advbal,v_crlimit,v_rate_margin,v_price_margin,f_price,v_basketid,v_ordamt,v_roomid,v_rate_ub);
        IF v_order_value <= v_pp THEN -- dung tien bao lanh thi du suc mua
          p_err_code := '-95035';
        END IF;
      END IF; */
            RETURN;
        END IF;
    /*end*/

        CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_orderid,p_err_msg);

        -- Check pool
        IF (v_poolid is not null) AND (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
            -- Gia tri pool dung them
            p_poolval := CSPKS_FO_POOLROOM.fn_get_using_pool(p_err_code,v_order_value,v_balance,v_bod_adv+v_advbal,
                                  v_payable,v_debt,v_ordamt,v_td,v_t0value,p_err_msg);
            --dbms_output.put_line('p_poolval==========:' || p_poolval );

            IF p_poolval > 0 THEN  --check pool
                CSPKS_FO_POOLROOM.sp_process_checkpool(p_err_code,v_poolid,p_poolval,p_err_msg);
                --dbms_output.put_line('p_err_code : ' || p_err_code);
                IF p_err_code != '0' THEN
                    RETURN;
                END IF;
            END IF;
        END IF;

        --Check room
        --IF v_formulacd != 'ADV' AND v_formulacd != 'CASH' THEN
      SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=v_acctno AND REFSYMBOL=v_symbol;
            IF p_poolval > 0 OR v_count >= 1 THEN

              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'gia tri dat lenh',v_order_value);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'ki quy truoc dat lenh',v_ordamt);

                CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,v_acctno,v_roomid,v_order_value,v_payable,v_bod_debt_t0,v_bod_d_margin,
        v_bod_d_margin_ub,v_ordamt,0,v_balance,v_bod_adv,v_advbal,v_td,0,v_symbol,f_qtty,v_t0value,p_err_msg);

                IF p_err_code != '0' THEN
                    RETURN;
                END IF;
            END IF;
        --END IF;

        -- Change quote status
        UPDATE QUOTES SET STATUS='F', LASTCHANGE=v_currtime WHERE QUOTEID=f_quote_id;

        CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);

        SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';
        -- Save order
        -- to_date(p_txdate,'yyyy-mm-dd')
        IF v_exchange ='HSX' THEN
            v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
            --v_dealid := CSPKS_FO_COMMON.fn_get_dealid();
        END IF;

        INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,ORIGINORDERID,
                CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,ROOTORDERID,FLAGORDER,
                SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND, TYPECD, SUBTYPECD,
                RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE)
        VALUES (p_orderid,to_date(v_txdate,'dd-mm-yyyy'), 'N', v_sesionex, f_quote_id,p_orderid,
              null, v_userid, v_custodycd, v_acctno, v_symbol,v_root_orderid,'C',
              v_side, 'NB', v_status, v_substatus, v_currtime, v_currtime, v_typecd, v_subtypecd,
              v_rate_adv, v_ratebrk, v_rate_tax, v_rate_buy, v_price_margin, v_price_asset,
              f_price, f_qtty, 0, 0, f_qtty, 0, 0, v_currtime);

        --Todo: check symbol if existed
        SELECT COUNT(1) INTO v_countNo FROM PORTFOLIOS WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
        IF (v_countNo = 0) THEN --mua ma CK moi, insert portfolios
            IF v_formulacd ='CASH' THEN
               v_formulacd_rtn:='0';
            ELSIF v_formulacd ='ADV' THEN
               v_formulacd_rtn:='1';
            ELSIF   v_formulacd ='PP0' THEN
               v_formulacd_rtn:='2';
            ELSIF  v_formulacd ='PPSET0' THEN
               v_formulacd_rtn:='4';
            ELSE
               v_formulacd_rtn:='0';
            END IF;

            INSERT INTO PORTFOLIOS(ACCTNO,SYMBOL,BUYINGQTTY, BOD_RTN) VALUES(v_acctno,v_symbol,f_qtty, v_formulacd_rtn);

        ELSE -- Update portfolios
            UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY + f_qtty
            WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
        END IF;

        -- Update order amount (gia tri ky quy mua trong ngay)
        --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT + v_order_value WHERE ACCTNO = v_acctno;

    IF p_poolval > 0 THEN
        IF (v_poolid is not null) AND (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
          CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code,p_orderid,'B',v_symbol,v_acctno,v_poolid,p_poolval,0,null,p_err_msg);
        END IF;
    END IF;
    --Danh dau Room
    IF v_formulacd != 'ADV'  AND v_formulacd != 'CASH' THEN
      v_ordamt := v_ordamt + v_order_value;
          /*
          dbms_output.put_line('v_roomid ' ||v_roomid);
          dbms_output.put_line('v_payable '||v_payable);
          dbms_output.put_line('v_bod_debt_t0 '||v_bod_debt_t0);
          dbms_output.put_line('v_bod_d_margin '||v_bod_d_margin);
          dbms_output.put_line('v_bod_d_margin_ub '||v_bod_d_margin_ub);
          dbms_output.put_line('v_odramt '||v_ordamt);
          dbms_output.put_line('v_balance '||v_balance);
          dbms_output.put_line('v_bod_adv '||v_bod_adv);
          dbms_output.put_line('v_advbal '||v_advbal);
          dbms_output.put_line('v_td '||v_td);
          dbms_output.put_line('v_t0value '||v_t0value);
          dbms_output.put_line('v_symbol '||v_symbol);
          dbms_output.put_line('f_qtty '||f_qtty);
          */

      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_roomid',v_roomid);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_payable',v_payable);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_bod_debt_t0',v_bod_debt_t0);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_bod_d_margin',v_bod_d_margin);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_bod_d_margin_ub',v_bod_d_margin_ub);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_ordamt',v_ordamt);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'0','0');
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_balance',v_balance);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_bod_adv',v_bod_adv);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_advbal',v_advbal);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_t0value',v_t0value);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_side',v_side);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'v_symbol',v_symbol);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'BUY',v_acctno,p_orderid,'f_qtty',f_qtty);

      CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,v_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
      v_bod_d_margin_ub,v_ordamt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_orderid,v_side,v_symbol,f_qtty,p_err_msg);

    END IF;

--    EXCEPTION
--          WHEN OTHERS THEN
--              p_err_code := '-90025';
  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_order_buy '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_order_buy;

  PROCEDURE sp_generate_new_order_HSX(p_err_code in OUT VARCHAR,
                p_new_orderid in OUT VARCHAR, -- so hieu lenh moi
                p_order_id IN VARCHAR, --so hieu lenh cua lenh huy
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_txdate in VARCHAR, --ngay giao dich
                p_side IN VARCHAR,-- mua hay ban
                p_sub_side IN VARCHAR,
                p_order_status IN VARCHAR, --trang thai cua lenh
                p_sub_status IN VARCHAR,
                p_acctno IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_reforderid IN VARCHAR, --orderid cua lenh goc
                p_quote_qtty IN number, --khoi luong quote
                p_remain_qtty IN integer, --khoi luong con lai
                p_quote_price IN number, --gia huy/sua
                p_typecd IN VARCHAR,
                p_userid IN VARCHAR,
                p_quoteid IN VARCHAR,
                p_sessionnex IN VARCHAR,
                p_err_msg OUT VARCHAR2
              )
  AS
        v_add_pool              NUMBER;
        v_old_subside           ORDERS.SUBSIDE%TYPE;
        v_marketstatus          VARCHAR2(100) ;
        v_board                 VARCHAR2(100);
        v_custodycd             ACCOUNTS.CUSTODYCD%TYPE;
        v_cnt_contra_ord        NUMBER(20);
  BEGIN

    -- Save order
    p_err_code := '0';
    --ThanhNV sua 28/6/2016: Kiem tra neu tai thoi diem sinh lenh moi co lenh doi ung thi khong thuc hien.
    BEGIN
      SELECT sessionex, i.board  INTO v_marketstatus, v_board FROM marketinfo m, instruments i WHERE m.exchange = i.board AND i.symbol =p_symbol;

    EXCEPTION WHEN OTHERS THEN
        v_marketstatus:='CLS'; --cho phien dong cua, de chan mua ban cung phien.
        v_board :='';
    END;
    IF  v_marketstatus = 'CLS' THEN  --Phien dinh ky ATC san HOSE
        BEGIN
               SELECT CUSTODYCD INTO v_custodycd
               FROM ACCOUNTS
               WHERE ACCTNO=p_acctno;
        EXCEPTION WHEN OTHERS THEN
               v_custodycd:=NULL;
        END;

        SELECT COUNT (orderid)
          INTO v_cnt_contra_ord
          FROM orders
         WHERE     custodycd = v_custodycd
               AND symbol = p_symbol
               AND remain_qtty > 0
               AND side IN ('B', 'S')
               AND side <> p_side
               AND sessionex in ('CLS')
               AND substatus IN ('SS', 'BB', 'NN', 'SD', 'SE', 'U1', 'U5');

              IF v_cnt_contra_ord>0 THEN
                 p_err_code := '-95013';
                 RETURN;
              END IF;
    END IF;

    --End sua.

    --lay thong tin tu lenh goc
    SELECT SUBSIDE INTO v_old_subside FROM ORDERS WHERE ORDERID = p_reforderid;
    IF (p_remain_qtty > 0) THEN
      IF (p_sub_side = 'CB') THEN -- lenh huy mua
        -- sinh lenh mua moi
        sp_process_order_buy(p_err_code,v_add_pool,p_new_orderid,p_remain_qtty,p_quote_price,p_quoteid,p_err_msg);
      ELSIF (p_sub_side = 'CS') THEN --lenh huy ban
        -- sinh lenh ban moi
        IF (v_old_subside = 'NS') THEN --ban thuong
          sp_process_order_sell(p_err_code,p_new_orderid,p_quoteid,p_acctno,p_symbol,p_remain_qtty,
            p_quote_price,p_userid,p_typecd,p_sessionnex,p_typecd,'',p_err_msg);
        ELSIF ((v_old_subside = 'MS')) THEN --ban cam co
          sp_proces_mortage_sell(p_err_code,p_new_orderid,p_quoteid,p_acctno,p_symbol,p_remain_qtty,
            p_quote_price,p_userid,p_typecd,p_sessionnex,p_typecd,'',p_err_msg);
          ELSIF ((v_old_subside = 'TS')) THEN  --ban tong
            sp_proces_total_sell(p_err_code,p_new_orderid,p_quoteid,p_acctno,p_symbol,p_remain_qtty,
              p_quote_price,p_userid,p_typecd,p_sessionnex,p_typecd,'',p_err_msg);
        END IF;
      END IF;

    ELSE
      p_err_code := '-95003';
      RETURN;
    END IF;

--    EXCEPTION
--      WHEN OTHERS THEN
--        p_err_code := '-90025';

  END sp_generate_new_order_HSX;

    PROCEDURE sp_process_corebank_order(
      p_err_code IN OUT VARCHAR,
      p_orderid  IN OUT VARCHAR,
      f_quote_id    IN VARCHAR,
      p_err_msg OUT VARCHAR2
    )
    AS
    v_currtime                  TIMESTAMP;
        v_sesionex                  MARKETINFO.SESSIONEX%TYPE;
        v_acctno                    QUOTES.ACCTNO%TYPE;
        v_side                        QUOTES.SIDE%TYPE;
        v_symbol                      QUOTES.SYMBOL%TYPE;
        v_userid                      QUOTES.USERID%TYPE;
        v_typecd                      QUOTES.TYPECD%TYPE;
        v_subtypecd                 QUOTES.SUBTYPECD%TYPE;
        v_formulacd                 ACCOUNTS.FORMULACD%TYPE;
        v_custodycd                 ACCOUNTS.CUSTODYCD%TYPE;
        v_ratebrk_s                 ACCOUNTS.RATE_BRK_S%TYPE;
        v_ratebrk_b                 ACCOUNTS.RATE_BRK_B%TYPE;
        v_balance                   ACCOUNTS.BOD_BALANCE%TYPE;
        v_t0value                   ACCOUNTS.BOD_T0VALUE%TYPE;
        v_td                            ACCOUNTS.BOD_TD%TYPE;
        v_payable                   ACCOUNTS.BOD_PAYABLE%TYPE;
        v_debt                        ACCOUNTS.BOD_DEBT%TYPE;
        v_advbal                      ACCOUNTS.CALC_ADVBAL%TYPE;
        v_bod_adv                   ACCOUNTS.BOD_ADV%TYPE;
        v_crlimit                   ACCOUNTS.BOD_CRLIMIT%TYPE;
        v_rate_tax              ACCOUNTS.RATE_TAX%TYPE;
        v_rate_adv              ACCOUNTS.RATE_ADV%TYPE;
        v_basketid                  ACCOUNTS.BASKETID%TYPE;
        v_ordamt                      ACCOUNTS.CALC_ODRAMT%TYPE;
        v_poolid                      ACCOUNTS.POOLID%TYPE;
        v_roomid                      ACCOUNTS.ROOMID%TYPE;
        v_ratebrk                   NUMBER;
        v_pp                            NUMBER;
        v_order_value               NUMBER;
        v_rate_buy                  BASKETS.RATE_BUY%TYPE :=0;
        v_rate_margin           BASKETS.RATE_MARGIN%TYPE :=0;
        v_price_margin          BASKETS.PRICE_MARGIN%TYPE :=0;
        v_price_asset           BASKETS.PRICE_ASSET%TYPE :=0;
        v_cficode                     INSTRUMENTS.CFICODE%TYPE;
        v_exchange            INSTRUMENTS.EXCHANGE%TYPE;
        v_count                       NUMBER;
        v_countNo                 NUMBER;
        v_countBasket         NUMBER;
        v_txdate                      SYSCONFIG.CFGVALUE%TYPE;
        v_status                ORDERS.STATUS%TYPE;
        v_substatus                 ORDERS.SUBSTATUS%TYPE;
        v_root_orderid          VARCHAR(20);
        v_count_ownpoolroom NUMBER;
    v_banklink          VARCHAR(2);
    v_price number := 0;
    v_qtty number := 0;
    BEGIN
        BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        p_err_code := '0';

    -- Get quote information
        SELECT ACCTNO,SIDE,SYMBOL,USERID,TYPECD,SUBTYPECD,PRICE,QTTY
        INTO v_acctno,v_side,v_symbol,v_userid,v_typecd,v_subtypecd,v_price,v_qtty
        FROM QUOTES WHERE QUOTEID=f_quote_id;

        -- Get symbol information
        SELECT CFICODE,EXCHANGE INTO v_cficode,v_exchange FROM INSTRUMENTS WHERE SYMBOL=v_symbol;

        -- Get account information
        SELECT FORMULACD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX,BOD_BALANCE,
             BOD_T0VALUE,BOD_TD,BOD_PAYABLE,BOD_DEBT,POOLID,ROOMID,CUSTODYCD,
             BOD_ADV,CALC_ADVBAL,BOD_CRLIMIT,BASKETID,CALC_ODRAMT,BANKLINK
        INTO v_formulacd,v_ratebrk_s,v_ratebrk_b,v_rate_adv,v_rate_tax,v_balance,
             v_t0value,v_td,v_payable,v_debt,v_poolid,v_roomid,v_custodycd,
             v_bod_adv,v_advbal,v_crlimit,v_basketid,v_ordamt,v_banklink
        FROM ACCOUNTS WHERE ACCTNO=v_acctno;

    p_orderid := f_quote_id;

    CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_orderid,p_err_msg);

    --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
    SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= v_symbol AND M.EXCHANGE=I.BOARD;
        CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
    SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';
        -- Save order
        -- to_date(p_txdate,'yyyy-mm-dd')
        IF v_exchange ='HSX' THEN
            v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
            --v_dealid := CSPKS_FO_COMMON.fn_get_dealid();
        END IF;

        INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,ROOTORDERID,FLAGORDER,
                SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND, TYPECD, SUBTYPECD,
                RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE)
        VALUES (p_orderid,to_date(v_txdate,'dd-mm-yyyy'), 'N', v_sesionex, f_quote_id,
              null, v_userid, v_custodycd, v_acctno, v_symbol,null,'C',
              v_side, 'NB', 'M', 'MM', v_currtime, v_currtime, v_typecd, v_subtypecd,
              v_rate_adv, null, v_rate_tax, v_rate_buy, v_price_margin, v_price_asset,
              v_price, v_qtty, 0, 0, 0, 0, 0, v_currtime);

    UPDATE QUOTES SET STATUS = 'R',LASTCHANGE=v_currtime WHERE QUOTEID=f_quote_id;

     EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
    END sp_process_corebank_order;


  PROCEDURE sp_update_status_order(p_err_code OUT VARCHAR,
            p_orderid IN VARCHAR,
            p_err_msg OUT VARCHAR2) --update trang thai lenh khi boc lenh phien giua trua

    AS

    v_status  VARCHAR(20);
    v_currtime TIMESTAMP;
    v_reforderid VARCHAR(20);
    v_quote_price_ori NUMBER; --gia lenh goc
    v_quote_price_rq NUMBER; --gia lenh yeu cau gui
    v_symbol VARCHAR(20);
    v_exchange VARCHAR(20);
    v_norb VARCHAR(20);
    v_crosstype VARCHAR(50);
    v_quoteid   VARCHAR(50);
    BEGIN
      p_err_code := 0;
      p_err_msg:='sp_update_status_order p_orderid=>'||p_orderid;
      BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
      END;
      --lay thong tin bang orders
      SELECT STATUS,REFORDERID,QUOTE_PRICE,SYMBOL, NORB, QUOTEID INTO v_status,v_reforderid,v_quote_price_rq,v_symbol,v_norb,v_quoteid
      FROM ORDERS WHERE ORDERID = p_orderid;
      --lay thong tin san gd
      SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL = v_symbol;
      IF (v_status = 'N') THEN-- lenh moi
        UPDATE ORDERS SET STATUS = 'B', SUBSTATUS = 'BB',LASTCHANGE = v_currtime WHERE ORDERID = p_orderid;
        IF v_norb ='B' THEN  --Neu lenh thoa thuan cung cong ty thi cap nhat BB cho lenh doi ung

          BEGIN
           SELECT crosstype INTO v_crosstype FROM crossinfo WHERE  quoteid = v_quoteid;
          EXCEPTION WHEN OTHERS THEN
            v_crosstype:='D';
          END;
          IF v_crosstype ='S' THEN
             UPDATE ORDERS SET STATUS = 'B', SUBSTATUS = 'BB',LASTCHANGE = v_currtime WHERE quoteid = v_quoteid AND subside ='NB';
          END IF;
        END IF;

      ELSIF (v_status = 'D' OR v_status = 'E') THEN -- lenh huy/sua
        IF (v_exchange = 'HSX') THEN
          --lay thong tin lenh goc
          SELECT QUOTE_PRICE INTO v_quote_price_ori FROM ORDERS WHERE ORDERID = v_reforderid;
          IF (v_quote_price_rq <> v_quote_price_ori) THEN
            UPDATE ORDERS SET SUBSTATUS = 'DE',LASTCHANGE = v_currtime WHERE ORDERID = p_orderid;
          ELSE
            UPDATE ORDERS SET SUBSTATUS = 'BB',LASTCHANGE = v_currtime WHERE ORDERID = p_orderid;
          END IF;
        ELSIF (v_exchange = 'HNX') THEN
          UPDATE ORDERS SET SUBSTATUS = 'BB',LASTCHANGE = v_currtime WHERE ORDERID = p_orderid;
        END IF;
      END IF;

    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_update_status_order '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_update_status_order;


    --tiendt createde, 14-03
    --for resend order
    PROCEDURE sp_process_resend_order(p_err_code OUT VARCHAR,
      p_err_msg OUT VARCHAR2,
      p_orderid IN VARCHAR2)
    AS
      v_count_order     NUMBER;
      v_count_hft       NUMBER;
      v_status varchar(2);
    BEGIN
      p_err_code := 0;
      p_err_msg:='sp_process_resend_order p_OrderID=>'||p_orderid;

      SELECT COUNT(1) INTO v_count_order FROM ORDERS WHERE ORDERID = p_orderid /*AND STATUS='B'*/ AND SUBSTATUS IN ('BB','DE');

      IF v_count_order = 1 THEN
         SELECT COUNT(1) INTO v_count_hft FROM HFT_MSG_LOGS WHERE ORDERID = p_orderid;
         IF v_count_hft = 1 THEN
            --delete HFT_MSG_LOGS
            DELETE FROM HFT_MSG_LOGS  WHERE ORDERID = p_orderid;
            SELECT STATUS INTO v_status FROM ORDERS WHERE SUBSTATUS IN ('BB','DE') and ORDERID = p_orderid;
            IF v_status = 'B' THEN --lenh moi dang block
              --update orders
              UPDATE ORDERS SET STATUS='N', SUBSTATUS='NN' WHERE ORDERID = p_orderid /*AND STATUS='B'*/ AND SUBSTATUS='BB';
            ELSE --lenh huy/sua dang block
              UPDATE ORDERS SET SUBSTATUS='NN' WHERE ORDERID = p_orderid /*AND STATUS='B'*/ AND SUBSTATUS IN ('BB','DE');
            END IF;
         ELSE
          p_err_code := '-95047';
          return;
         END IF;
      ELSE
        p_err_code := '-95047';
        return;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_resend_order '||p_err_msg||' sqlerrm = '||SQLERRM;
    END;
END CSPKS_FO_ORDER_NEW;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_NEW
