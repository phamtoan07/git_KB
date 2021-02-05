-- Start of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_AMEND
-- Generated 20-Oct-2016 09:39:37 from FOTEST@FLEX233

-- Drop the old instance of CSPKS_FO_ORDER_AMEND
DROP PACKAGE cspks_fo_order_amend
/

CREATE OR REPLACE 
PACKAGE cspks_fo_order_amend AS
      PROCEDURE sp_proces_edit_order(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh moi
                p_edit_order_id IN VARCHAR, --so hieu lenh goc
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_exchange IN VARCHAR, --ma san
                p_side IN VARCHAR, --mua :B, ban :S
                p_qtty IN  NUMBER,  --Khoi luong sua
                p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
                                p_price IN  NUMBER, --gia ban
                p_session_index IN VARCHAR,--phien giao dich
                                p_quote_id IN VARCHAR, --so hieu yeu cau
                                p_userid in varchar, --ma nguoi dung dat lenh
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2,
                p_corebank_amt OUT NUMBER
                );

      PROCEDURE sp_proces_edit_sell_order_HNX(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh moi
                p_edit_order_id IN VARCHAR, --so hieu lenh goc
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN  NUMBER,  --Khoi luong sua
                p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
                                p_price IN  NUMBER, --gia ban
                p_session_index IN VARCHAR,--phien giao dich
                                p_quote_id IN VARCHAR, --so hieu yeu cau
                                p_userid in varchar, --ma nguoi dung dat lenh
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2
                );

      PROCEDURE sp_proces_edit_buy_order_HNX(p_err_code in OUT VARCHAR,
          p_order_id in OUT VARCHAR, --so hieu lenh moi
          p_edit_order_id IN VARCHAR, --so hieu lenh goc
          p_account IN VARCHAR, --so tieu khoan giao dich
          p_symbol IN VARCHAR, --ma chung khoan
          p_qtty IN  NUMBER,  --Khoi luong sua
          p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
          p_price IN  NUMBER, --gia ban
          p_session_index IN VARCHAR,--phien giao dich
          p_quote_id IN VARCHAR, --so hieu yeu cau
          p_userid in varchar, --ma nguoi dung dat lenh
          p_txdate in varchar,
          p_err_msg OUT VARCHAR2,
          p_corebank_amt OUT NUMBER
          );

      PROCEDURE sp_proces_edit_buy_order_HSX(p_err_code in OUT VARCHAR,
          p_order_id in OUT VARCHAR, --so hieu lenh moi
          p_edit_order_id IN VARCHAR, --so hieu lenh goc
          p_account IN VARCHAR, --so tieu khoan giao dich
          p_symbol IN VARCHAR, --ma chung khoan
          p_qtty IN  NUMBER,  --Khoi luong sua
          p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
          p_price IN  NUMBER, --gia ban
          p_session_index IN VARCHAR,--phien giao dich
          p_quote_id IN VARCHAR, --so hieu yeu cau
          p_userid in varchar, --ma nguoi dung dat lenh
          p_txdate in varchar,
          p_err_msg OUT VARCHAR2,
          p_corebank_amt OUT NUMBER
          );

      PROCEDURE sp_proces_edit_sell_order_HSX(p_err_code in OUT VARCHAR,
          p_order_id in OUT VARCHAR, --so hieu lenh moi
          p_edit_order_id IN VARCHAR, --so hieu lenh goc
          p_account IN VARCHAR, --so tieu khoan giao dich
          p_symbol IN VARCHAR, --ma chung khoan
          p_qtty IN  NUMBER,  --Khoi luong sua
          p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
          p_price IN  NUMBER, --gia ban
          p_session_index IN VARCHAR,--phien giao dich
          p_quote_id IN VARCHAR, --so hieu yeu cau
          p_userid in varchar, --ma nguoi dung dat lenh
          p_txdate in varchar,
          p_err_msg OUT VARCHAR2
          );

       PROCEDURE sp_proces_cancel_gda_order(p_err_code in OUT VARCHAR,
                p_classcd in OUT VARCHAR, --so hieu lenh moi
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN  NUMBER,  --Khoi luong sua
                p_price IN  NUMBER, --gia ban
                p_quote_id IN VARCHAR, --so hieu yeu cau
                p_userid in varchar, --ma nguoi dung dat lenh
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2
                );
--      PROCEDURE sp_proces_cancel_for_edit(p_err_code in OUT VARCHAR,
--                p_order_id in OUT VARCHAR, --so hieu lenh moi
--                p_cancel_order_id IN VARCHAR, --so hieu lenh can huy
--                p_account IN VARCHAR, --so tieu khoan giao dich
--                              p_userid in VARCHAR, --ma nguoi dung dat lenh
--                p_price in number,
--                p_qtty in number,
--                p_quote_id in varchar
--                );

END CSPKS_FO_ORDER_AMEND;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_order_amend AS

  PROCEDURE sp_proces_edit_order(p_err_code in OUT VARCHAR,
              p_order_id in OUT VARCHAR, --so hieu lenh moi
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_account IN VARCHAR, --so tieu khoan giao dich --khong dung
              p_symbol IN VARCHAR, --ma chung khoan --khong dung
              p_exchange IN VARCHAR, --ma san --khong dung
              p_side IN VARCHAR, --mua :AB, ban :AS --khong dung
              p_qtty IN  NUMBER,  --Khoi luong sua
              p_exchange_qtty in OUT NUMBER,  --Khoi luong day len san
              p_price IN  NUMBER, --gia ban
              p_session_index IN VARCHAR,--phien giao dich
              p_quote_id IN VARCHAR, --so hieu yeu cau
              p_userid in VARCHAR, --ma nguoi dung dat lenh
              p_txdate in varchar,
              p_err_msg OUT VARCHAR2,
              p_corebank_amt OUT NUMBER
              )
  AS
    v_subside   VARCHAR(4);
    v_symbol    VARCHAR(15);
    v_acctno    VARCHAR(15);
    v_exchange  VARCHAR(10);
    v_quoteid   VARCHAR(100);
    v_count_chk_advorder number(10);

  BEGIN

    --DBMS_OUTPUT.PUT_LINE('111111:');
    p_err_msg:='sp_proces_msg_confirm_amend p_edit_order_id=>'||p_edit_order_id;
    SELECT o.SUBSIDE, o.SYMBOL, o.ACCTNO, i.EXCHANGE , o.quoteid
    INTO v_subside, v_symbol, v_acctno, v_exchange, v_quoteid
      FROM ORDERS o, INSTRUMENTS i
      WHERE o.SYMBOL = i.SYMBOL AND o.ORDERID = p_edit_order_id;
    /* ThanhNV. 26.07.2016Sua neu symbol lenh sua khac voi symbol lenh goc thi bao loi*/
    IF  v_symbol <>  p_symbol THEN
          p_err_code := '-90022';
          p_err_msg:='sp_proces_edit_order '||p_err_msg||' loi truyen symbol sai tu client: p_edit_order_id'|| p_edit_order_id;
          RETURN;
    END IF;
    --ThanhNV: 2016.10.20 Neu la lenh con cua lenh dieu kien thi khong cho sua:
    SELECT count(*) INTO v_count_chk_advorder FROM quotes WHERE classcd NOT IN ('DLO','FSO') AND quoteid = v_quoteid;
    IF  v_count_chk_advorder > 0 THEN
          p_err_code := '-95024';
          p_err_msg:='sp_proces_edit_order '||p_err_msg||' khong duoc sua lenh con cua lenh dieu kien'|| p_edit_order_id;
          RETURN;
    END IF;
    --End 2016.10.20
    IF v_exchange = 'HSX' THEN
      IF v_subside = 'NB' THEN
      sp_proces_edit_buy_order_HSX(p_err_code,p_order_id,p_edit_order_id,v_acctno,v_symbol,
        p_qtty,p_exchange_qtty,p_price,p_session_index,p_quote_id,p_userid,p_txdate,p_err_msg,p_corebank_amt);
      ELSIF v_subside = 'NS' THEN
        sp_proces_edit_sell_order_HSX(p_err_code,p_order_id,p_edit_order_id,v_acctno,v_symbol,
        p_qtty,p_exchange_qtty,p_price,p_session_index,p_quote_id,p_userid,p_txdate,p_err_msg);
      END IF;

    ELSIF v_exchange = 'HNX' THEN
      IF v_subside = 'NB' OR v_subside = 'AB' THEN
        sp_proces_edit_buy_order_HNX(p_err_code,p_order_id,p_edit_order_id,v_acctno,v_symbol,
          p_qtty,p_exchange_qtty,p_price,p_session_index,p_quote_id,p_userid,p_txdate,p_err_msg,p_corebank_amt);

      ELSIF v_subside = 'NS' OR v_subside = 'AS' OR v_subside = 'AM' THEN
        sp_proces_edit_sell_order_HNX(p_err_code,p_order_id,p_edit_order_id,v_acctno,v_symbol,
          p_qtty,p_exchange_qtty,p_price,p_session_index,p_quote_id,p_userid,p_txdate,p_err_msg);
      END IF;
    END IF;

    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_edit_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_edit_order;

  PROCEDURE sp_proces_edit_sell_order_HNX(p_err_code in OUT VARCHAR,
              p_order_id in OUT VARCHAR, --so hieu lenh moi
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_account IN VARCHAR, --so tieu khoan giao dich
              p_symbol IN VARCHAR, --ma chung khoan
              p_qtty IN  NUMBER,  --Khoi luong sua
              p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
              p_price IN  NUMBER, --gia ban
              p_session_index IN VARCHAR,--phien giao dich
              p_quote_id IN VARCHAR, --so hieu yeu cau
              p_userid in VARCHAR, --ma nguoi dung dat lenh
              p_txdate in varchar,
              p_err_msg OUT VARCHAR2
                )
  AS
    v_currtime                TIMESTAMP;
    v_quote_qtty              ORDERS.QUOTE_QTTY%TYPE;
    v_quote_price             ORDERS.QUOTE_PRICE%TYPE;
    v_exec_qtty               ORDERS.EXEC_QTTY%TYPE;
    v_remain_qtty             ORDERS.REMAIN_QTTY%TYPE;
    v_order_id                VARCHAR(20);
    v_custodycd               ORDERS.CUSTODYCD%TYPE;
    v_subside                 ORDERS.SUBSIDE%TYPE;
    v_typecd                  ORDERS.TYPECD%TYPE;
    v_subtypecd               ORDERS.SUBTYPECD%TYPE;
    v_status                  ORDERS.STATUS%TYPE;
    v_substatus               ORDERS.SUBSTATUS%TYPE;
    v_status_ori              ORDERS.STATUS%TYPE;
    v_substatus_ori           ORDERS.SUBSTATUS%TYPE;
    v_root_orderid            ORDERS.ROOTORDERID%TYPE;
    v_confirmid               ORDERS.CONFIRMID%TYPE;
    v_exec_amt                ORDERS.EXEC_AMT%TYPE;
    v_price_margin            ORDERS.PRICE_MARGIN%TYPE;
    v_price_asset             ORDERS.PRICE_ASSET%TYPE;
    v_rate_tax                ORDERS.RATE_TAX%TYPE;
    v_rate_adv                ORDERS.RATE_ADV%TYPE;
    v_rate_brk                ORDERS.RATE_BRK%TYPE;
    v_sesionex                MARKETINFO.SESSIONEX%TYPE;
    v_sesionex_org            MARKETINFO.SESSIONEX%TYPE;  --Phien day vao cua lenh goc.
    v_exchange                INSTRUMENTS.EXCHANGE%TYPE;
    v_trade_qtty              PORTFOLIOS.TRADE%TYPE;
    v_selling_qtty            PORTFOLIOS.SELLINGQTTY%TYPE;
    v_originorderid           ORDERS.ORIGINORDERID%TYPE;
    v_trade_qttyEX            NUMBER;
    v_selling_qttyEX          NUMBER;
  BEGIN
    p_err_msg:='sp_proces_edit_sell_order_HNX p_edit_order_id=>'||p_edit_order_id;
    BEGIN
      EXECUTE IMMEDIATE
      'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
    END;
    p_err_code := '0';

    --lay thong tin lenh goc
    SELECT QUOTE_QTTY,EXEC_QTTY,REMAIN_QTTY,TYPECD,SUBTYPECD,CONFIRMID,EXEC_AMT,
          SUBSIDE,STATUS,SUBSTATUS,RATE_ADV,RATE_BRK,ORIGINORDERID,
          RATE_TAX,PRICE_MARGIN,PRICE_ASSET,QUOTE_PRICE,ROOTORDERID,CUSTODYCD,SESSIONEX
    INTO v_quote_qtty,v_exec_qtty,v_remain_qtty,v_typecd,v_subtypecd,v_confirmid,v_exec_amt,
          v_subside,v_status_ori,v_substatus_ori,v_rate_adv,v_rate_brk,v_originorderid,
          v_rate_tax,v_price_margin,v_price_asset,v_quote_price,v_root_orderid,v_custodycd,v_sesionex_org
    FROM ORDERS WHERE ORDERID = p_edit_order_id;

    --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL=p_symbol AND M.EXCHANGE=I.EXCHANGE;
    SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
    SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL=p_symbol;
    /*dung.bui add code check phien, date 14/12/2015*/
    IF v_sesionex='END' THEN --dong cua thi truong
      p_err_code := '-95043';
      p_err_msg:='sp_proces_edit_sell_order_HNX p_edit_order_id=>'||p_edit_order_id;
      RETURN;
    END IF;

    IF v_sesionex IN ('CROSS','CLS','L5M') THEN --phien cho lenh thoa thuan
      p_err_code := '-95015';
      RETURN;
    END IF;
    /*end*/

    IF v_subtypecd != 'LO' AND  v_substatus_ori != 'NN' THEN
      --khong duoc sua lenh thi truong
      p_err_code := '-95024';
      RETURN;
    END IF;

    --Khoi luong va gia khong thay doi
    IF p_qtty=v_quote_qtty AND p_price=v_quote_price THEN
      p_err_code := '-95003';
      RETURN;
    END IF;

    --khong cho sua lenh lo le thanh lo lon va nguoc lai
    IF (v_quote_qtty < 100 AND p_qtty >= 100) OR (v_quote_qtty >= 100 AND p_qtty < 100) THEN
      p_err_code := '-95039';
      RETURN;
    END IF;

    IF (v_status_ori='S' AND v_substatus_ori='SE') OR (v_substatus_ori='BB')
      OR (v_substatus_ori='SD') OR (v_substatus_ori='DD')  OR (v_substatus_ori='DC')
      /*OR (v_substatus_ori='EC')*/ OR (v_substatus_ori='EE') OR v_remain_qtty=0  THEN
      p_err_code := '-95023';
      RETURN;
    ELSE
      IF (p_qtty > v_exec_qtty) THEN
        IF(v_subside = 'NS') OR (v_subside = 'AS') THEN
            v_subside := 'AS';
        ELSE
            v_subside := 'AM';
        END IF;

        IF ((p_qtty-v_exec_qtty) < v_remain_qtty) THEN --Sua giam
          --general orderid
          CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);

          IF v_substatus_ori='NN' THEN --lenh chua gui so
            /*dung.bui added code,date: 2015-09-11*/
            IF v_subtypecd = 'LO' THEN
              UPDATE ORDERS SET QUOTE_QTTY=p_qtty,QUOTE_PRICE=p_price,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
              WHERE ORDERID = p_edit_order_id;
            ELSE
              UPDATE ORDERS SET QUOTE_QTTY=p_qtty,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
              WHERE ORDERID = p_edit_order_id;
            END IF;
             /*end*/
            IF(v_subside='NS') OR (v_subside='AS') THEN  --ban/sua ban thuong
                UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY-(v_quote_qtty-p_qtty) WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
            ELSE  --ban cam co
                UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT-(v_quote_qtty-p_qtty) WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
            END IF;

            p_exchange_qtty := p_qtty;
            p_order_id := p_edit_order_id;

          ELSE --lenh da gui so
            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
            p_exchange_qtty := p_qtty - v_exec_qtty;
            IF v_sesionex IN ('L5M','CLS') THEN
                p_err_code := '-95015';
                RETURN;
            END IF;
            --sinh lenh yeu cau sua
            INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,CONFIRMID,
                    USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ORIGINORDERID,
                    SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                    TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT,
                    EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE,ROOTORDERID,FLAGORDER)
                VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex_org, p_quote_id,v_confirmid,
                    p_userid, v_custodycd, p_account, p_symbol, 'O',v_originorderid,
                    v_subside, 'E', v_substatus, v_currtime, v_currtime,
                    v_typecd, v_subtypecd, p_price, p_exchange_qtty,0,
                    0,p_exchange_qtty, 0, 0, p_edit_order_id,
                    v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime,v_root_orderid,'C');

            --Cap nhat trang thai lenh goc
            UPDATE ORDERS SET STATUS='S',SUBSTATUS='SE',lastchange=v_currtime WHERE ORDERID=p_edit_order_id;
            p_order_id := v_order_id;
          END IF;

          --update quotes status
          UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;

        ELSE --Sua tang
          IF(v_subside = 'NS') OR (v_subside = 'AS') THEN --ban/sua ban thuong
              SELECT TRADE,SELLINGQTTY INTO v_trade_qtty,v_selling_qtty FROM PORTFOLIOS WHERE ACCTNO=p_account AND SYMBOL=p_symbol;

              --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
              BEGIN
                 SELECT  SELLINGQTTY INTO v_selling_qttyEx FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
              EXCEPTION WHEN OTHERS THEN
                 v_selling_qttyEx:=0;
              END;
              v_selling_qtty:= v_selling_qtty + v_selling_qttyEx;

          ELSE --ban cam co
              SELECT MORTGAGE,SELLINGQTTYMORT INTO v_trade_qtty,v_selling_qtty FROM PORTFOLIOS WHERE ACCTNO=p_account AND SYMBOL=p_symbol;

              --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
              BEGIN
                 SELECT  SELLINGQTTYMORT INTO v_selling_qttyEx FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
              EXCEPTION WHEN OTHERS THEN
                 v_selling_qttyEx:=0;
              END;
              v_selling_qtty:= v_selling_qtty + v_selling_qttyEx;

          END IF;

          --kiem tra so du CK
          IF (p_qtty-v_remain_qtty-v_exec_qtty) <= (v_trade_qtty-v_selling_qtty) THEN --du chung khoan de sua
            --general orderid
            CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
            IF v_substatus_ori = 'NN' THEN --chua gui so
              IF v_subtypecd = 'LO' THEN
                UPDATE ORDERS SET QUOTE_QTTY=p_qtty,QUOTE_PRICE=p_price,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
                WHERE ORDERID = p_edit_order_id;
              ELSE
                UPDATE ORDERS SET QUOTE_QTTY=p_qtty,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
                WHERE ORDERID = p_edit_order_id;
              END IF;

              p_exchange_qtty := p_qtty;
              p_order_id := p_edit_order_id;
            ELSE -- da gui so
              CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
              p_exchange_qtty := p_qtty - v_exec_qtty;
              IF v_sesionex IN  ('L5M','CLS') THEN
                  p_err_code := '-95015';
                  RETURN;
              END IF;

              --sinh lenh yeu cau sua
              INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,CONFIRMID,
                    USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE,ROOTORDERID,FLAGORDER,
                    SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                    TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT,ORIGINORDERID,
                    EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
                  VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex_org, p_quote_id,v_confirmid,
                      p_userid, v_custodycd, p_account, p_symbol, 'O', v_root_orderid, 'C',
                      v_subside, 'E', v_substatus, v_currtime, v_currtime,
                      v_typecd, v_subtypecd, p_price, p_exchange_qtty, 0,v_originorderid,
                      0,p_exchange_qtty, 0, 0, p_edit_order_id,
                      v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);

              --Cap nhat trang thai lenh goc
              UPDATE ORDERS SET STATUS='S',SUBSTATUS='SE',LASTCHANGE = sysdate/*,ADMEND_QTTY= p_qtty */ WHERE ORDERID = p_edit_order_id;
              p_order_id := v_order_id;
            END IF;

            --Cap nhat bang Portfolios
            IF(v_subside = 'NS') OR (v_subside = 'AS') THEN
                UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY + (p_qtty-v_quote_qtty) WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
            ELSIF (v_subside = 'MS') OR (v_subside = 'AM') THEN
                UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT + (p_qtty-v_quote_qtty) WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
            END IF;

            --update quotes table
            UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;
          ELSE
              p_err_code := '-95003';
              RETURN;
          END IF;
        END IF;

      ELSE
          p_err_code := '-95003';
          RETURN;
      END IF;
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:= 'sp_proces_edit_sell_order_HNX '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_proces_edit_sell_order_HNX;

  PROCEDURE sp_proces_edit_buy_order_HNX(p_err_code in OUT VARCHAR,
              p_order_id in OUT VARCHAR, --so hieu lenh moi
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_account IN VARCHAR, --so tieu khoan giao dich
              p_symbol IN VARCHAR, --ma chung khoan
              p_qtty IN  NUMBER,  --Khoi luong sua
              p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
              p_price IN  NUMBER, --gia mua
              p_session_index IN VARCHAR,--phien giao dich
              p_quote_id IN VARCHAR, --so hieu yeu cau
              p_userid in VARCHAR, --ma nguoi dung dat lenh
              p_txdate in varchar,
              p_err_msg OUT VARCHAR2,
              p_corebank_amt OUT NUMBER
                )
    AS
      v_currtime                TIMESTAMP;
      v_amend_amt               NUMBER;
      v_remain_amt              NUMBER;
      v_p_pp                    NUMBER;
      v_add_pool                NUMBER;
      v_trans_amount            NUMBER;
      v_buyamt                  NUMBER;
      v_count                   NUMBER;
      v_order_id                VARCHAR(20);
      v_quote_qtty              ORDERS.QUOTE_QTTY%TYPE;
      v_quote_price             ORDERS.QUOTE_PRICE%TYPE;
      v_exec_qtty               ORDERS.EXEC_QTTY%TYPE;
      v_remain_qtty             ORDERS.REMAIN_QTTY%TYPE;
      v_side                    ORDERS.SIDE%TYPE;
      v_subside                 ORDERS.SUBSIDE%TYPE;
      v_typecd                  ORDERS.TYPECD%TYPE;
      v_subtypecd               ORDERS.SUBTYPECD%TYPE;
      v_status                  ORDERS.STATUS%TYPE;
      v_substatus               ORDERS.SUBSTATUS%TYPE;
      v_status_ori              ORDERS.STATUS%TYPE;
      v_substatus_ori           ORDERS.SUBSTATUS%TYPE;
      v_custodycd               ORDERS.CUSTODYCD%TYPE;
      v_rate_brk                ORDERS.RATE_BRK%TYPE;
      v_rate_tax                ORDERS.RATE_TAX%TYPE;
      v_rate_adv                ORDERS.RATE_ADV%TYPE;
      v_root_orderid            ORDERS.ROOTORDERID%TYPE;
      v_price_margin            ORDERS.PRICE_MARGIN%TYPE;
      v_price_asset             ORDERS.PRICE_ASSET%TYPE;
      v_confirmid               ORDERS.CONFIRMID%TYPE;
      v_exec_amt                ORDERS.EXEC_AMT%TYPE;
      v_formulacd               ACCOUNTS.FORMULACD%TYPE;
      v_balance                 ACCOUNTS.BOD_BALANCE%TYPE;
      v_t0value                 ACCOUNTS.BOD_T0VALUE%TYPE;
      v_td                      ACCOUNTS.BOD_TD%TYPE;
      v_payable                 ACCOUNTS.BOD_PAYABLE%TYPE;
      v_debt                    ACCOUNTS.BOD_DEBT%TYPE;
      v_advbal                  ACCOUNTS.CALC_ADVBAL%TYPE;
      v_crlimit                 ACCOUNTS.BOD_CRLIMIT%TYPE;
      v_basketid                ACCOUNTS.BASKETID%TYPE;
      v_odramt                  ACCOUNTS.CALC_ODRAMT%TYPE;
      v_poolid                  ACCOUNTS.POOLID%TYPE;
      v_roomid                  ACCOUNTS.ROOMID%TYPE;
      v_bod_adv                 ACCOUNTS.BOD_ADV%TYPE;
      v_rate_ub                 ACCOUNTS.RATE_UB%TYPE;
      v_rate_margin             BASKETS.RATE_MARGIN%TYPE;
      v_sesionex                MARKETINFO.SESSIONEX%TYPE;
      v_sesionex_org            MARKETINFO.SESSIONEX%TYPE;  --Phien day vao cua lenh goc.
      v_exchange                INSTRUMENTS.EXCHANGE%TYPE;
      v_fqtty                   INSTRUMENTS.FQTTY%TYPE;
      v_dof                     CUSTOMERS.DOF%TYPE;
      v_bod_debt_t0             ACCOUNTS.BOD_DEBT_T0%TYPE;
      v_bod_d_margin            ACCOUNTS.BOD_D_MARGIN%TYPE;
      v_originorderid           ORDERS.ORIGINORDERID%TYPE;
      v_ownroomid               VARCHAR(20);
      v_bod_d_margin_ub         ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
      v_buyamt_delta number; -- gia tri ki quy them
      v_ta number; --tai san khac tien
      v_banklink  VARCHAR(2);
      v_count_bankaccorders NUMBER;
      v_odramt_edit_order   NUMBER;


    BEGIN

    p_err_code := '0';
    p_err_msg:='sp_proces_edit_buy_order_HNX p_quote_id=>'||p_quote_id;
    BEGIN
      EXECUTE IMMEDIATE
      'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
    END;

    SELECT QUOTE_QTTY,QUOTE_PRICE,EXEC_QTTY,REMAIN_QTTY,TYPECD,CONFIRMID,EXEC_AMT,
        SUBTYPECD,SIDE,SUBSIDE,STATUS,SUBSTATUS,RATE_ADV,ORIGINORDERID,
        RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,ROOTORDERID,SESSIONEX
    INTO v_quote_qtty,v_quote_price,v_exec_qtty,v_remain_qtty,v_typecd,v_confirmid,v_exec_amt,
        v_subtypecd,v_side,v_subside,v_status,v_substatus,v_rate_adv,v_originorderid,
        v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_root_orderid,v_sesionex_org
    FROM ORDERS WHERE ORDERID = p_edit_order_id;

    SELECT CUSTODYCD,FORMULACD,BOD_BALANCE,BOD_T0VALUE,BOD_TD,BOD_PAYABLE,BOD_DEBT,BOD_DEBT_T0,BOD_D_MARGIN,
        BOD_ADV,CALC_ADVBAL,BOD_CRLIMIT,BASKETID,POOLID,ROOMID,RATE_UB,BOD_D_MARGIN_UB,BANKLINK
    INTO v_custodycd,v_formulacd,v_balance,v_t0value,v_td,v_payable,v_debt,v_bod_debt_t0,v_bod_d_margin,
        v_bod_adv,v_advbal,v_crlimit,v_basketid,v_poolid,v_roomid,v_rate_ub,v_bod_d_margin_ub,v_banklink
    FROM ACCOUNTS WHERE ACCTNO = p_account;

    v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);
    --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_symbol AND M.EXCHANGE=I.EXCHANGE;
    SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
    SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL=p_symbol;

    /*dung.bui add code check phien, date 14/12/2015*/
    IF v_sesionex='END' THEN --dong cua thi truong
        p_err_code := '-95043';
        RETURN;
    END IF;

    IF v_sesionex IN ('CROSS','CLS','L5M')   THEN --phien cho lenh thoa thuan, phien CLOSE --ThanhNV sua 2016.08.31
        p_err_code := '-95015';
        RETURN;
    END IF;
    /*end*/

    --Khoi luong va gia khong thay doi
    IF p_qtty = v_quote_qtty AND p_price = v_quote_price THEN
        p_err_code := '-95003';
        RETURN;
    END IF;

    --khong cho sua lenh lo le thanh lo lon va nguoc lai
    IF (v_quote_qtty < 100 AND p_qtty >= 100) OR (v_quote_qtty >= 100 AND p_qtty < 100) THEN
        p_err_code := '-95039';
        RETURN;
    END IF;
    IF v_subtypecd != 'LO' AND  v_substatus != 'NN' THEN
        p_err_code := '-95024';
        RETURN;
    END IF;
    IF (v_status= 'S' AND v_substatus = 'SE') OR (v_substatus = 'BB')
        OR (v_substatus = 'SD') OR (v_substatus = 'DD')
        OR (v_substatus = 'DC') OR (v_substatus = 'EC') OR (v_substatus = 'EE') OR v_remain_qtty=0  THEN
      p_err_code := '-95023';
      RETURN;
    ELSE
      --lay thong tin ro chung khoan
      SELECT COUNT(1) INTO v_count FROM BASKETS A,ACCOUNTS B where A.BASKETID=B.BASKETID AND A.SYMBOL=p_symbol AND B.acctno = p_account;
      IF (v_count = 0) THEN
        v_rate_margin := 0;
        v_price_margin := 0;
      ELSE
        SELECT RATE_MARGIN,PRICE_MARGIN INTO v_rate_margin,v_price_margin
        FROM BASKETS A,ACCOUNTS B where A.BASKETID=B.BASKETID AND A.SYMBOL = p_symbol AND B.acctno = p_account;
      END IF;
 --dbms_output.put_line('10000 p_qtty'|| p_qtty);
 --dbms_output.put_line('10000 v_exec_qtty'|| v_exec_qtty);
      IF (p_qtty > v_exec_qtty) THEN
        --gia tri lenh sua moi
        v_amend_amt := p_qtty*p_price*(1+v_rate_brk/100);
        --gia tri lenh goc
        v_remain_amt := v_quote_qtty*v_quote_price*(1+v_rate_brk/100);
        /*date: 2015-03-10 : 10h30,author: dung.bui*/
        -- ki quy them cho lenh sua
        v_buyamt := ((p_qtty - v_exec_qtty)*p_price - (v_remain_qtty*v_quote_price))*((1+v_rate_brk/100));
        /*end*/
        --dbms_output.put_line('v_buyamt' || v_buyamt);

        /*dung.bui add code, date 16/02/2016*/
        --v_ta := cspks_fo_common.fn_get_ta(p_account,v_roomid,v_rate_ub);
        --v_buyamt_delta := greatest(0,v_buyamt - greatest((v_quote_qtty-p_qtty)*v_rate_margin*v_price_margin/100 , least(0,v_ta-v_crlimit)));

        /*end*/

        --IF(v_amend_amt >= v_remain_amt) THEN --Sua tang
        --ThanhNV sua 2016.03.04 chi lay ky quy phan chua khop.
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'p_qtty : ',p_qtty);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_exec_qtty : ',v_exec_qtty);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_remain_qtty : ',v_remain_qtty);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_quote_price : ',v_quote_price);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_buyamt : ',v_buyamt);
        --commit;
--dbms_output.put_line('1111 v_buyamt'|| v_buyamt);
        IF v_buyamt >0 THEN --Sua tang
          -- check room neu la tk nuoc ngoai
          SELECT DOF INTO v_dof FROM CUSTOMERS WHERE CUSTODYCD = v_custodycd;
          SELECT FQTTY INTO v_fqtty FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
          IF v_dof = 'F' AND p_qtty-v_exec_qtty > v_fqtty THEN --tk nha dau tu nuoc ngoai
              p_err_code := '-95012';
              RETURN;
          END IF;

          -- Tinh PP0 + bao lanh
          /*date: 2014-03-12 : 13h30,author: dung.bui*/
          CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,v_p_pp,v_odramt,p_account,v_balance,0,v_td,
                v_payable,v_debt,v_rate_brk,v_advbal,v_crlimit,v_rate_margin,v_price_margin,
                v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);
          v_p_pp := GREATEST(0,v_p_pp + v_t0value);
          v_trans_amount := v_buyamt + LEAST(0,v_quote_qtty-p_qtty)*v_rate_margin*v_price_margin/100;
          /*end*/
--dbms_output.put_line('1113 v_trans_amount '||v_trans_amount);
          /*date: 2016-02-17 : 13h30,author: tien.do*/
          /*edit for corebank*/

          IF(v_banklink = 'B' AND (v_p_pp < v_trans_amount)) THEN
             --p_err_code := '-95555';
            p_corebank_amt :=  ceil(v_trans_amount - v_p_pp); --Dung fix , lam tron len tien hold
            /*dung.bui fix for edit corebank, date 20/2/2016*/

              SELECT COUNT(1) INTO v_count_bankaccorders FROM BANKACCORDERS WHERE QUOTEID = p_quote_id;
              IF v_count_bankaccorders > 0 THEN
                p_err_code := '-95036';
              ELSE
                 INSERT INTO BANKACCORDERS(QUOTEID,ACCTNO,AMOUNT,STATUS,LASTCHANGE)
                 VALUES(p_quote_id,p_account,p_corebank_amt,'N', v_currtime);
                 p_err_code := '-95555';
                 p_order_id := p_quote_id;
                 UPDATE QUOTES SET STATUS='B', LASTCHANGE=v_currtime WHERE QUOTEID=p_quote_id; --for show wait order on interface
              END IF;

              SELECT COUNT(1) INTO v_count_bankaccorders FROM QUOTES WHERE REFQUOTEID = p_edit_order_id AND STATUS = 'B';
              IF v_count_bankaccorders >=2 THEN
                p_err_code := '-95023';
                RETURN;
              END IF;

              RETURN;
          END IF;
          /*end*/
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_p_pp : ',v_p_pp);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_trans_amount : ',v_trans_amount);
          --commit;
   --dbms_output.put_line('1114 v_trans_amount '||v_trans_amount ||' v_p_pp '||v_p_pp);
          IF(v_p_pp >= v_trans_amount) THEN  -- kiem tra du suc mua?
            IF v_formulacd != 'ADV' AND v_formulacd != 'CASH' THEN
              v_add_pool := CSPKS_FO_POOLROOM.fn_get_using_pool( p_err_code,v_buyamt,v_balance,
                    v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);

              --Kiem tra pool , Trung mo doan code nay ra nhe
              IF v_add_pool > 0 AND v_poolid is not null THEN
                  CSPKS_FO_POOLROOM.sp_process_checkpool(p_err_code,v_poolid,v_add_pool,p_err_msg);
              END IF;

              --Kiem tra room, Trung mo doan code nay ra nhe
              IF v_add_pool > 0 AND p_err_code = '0' AND v_roomid is not null THEN
                CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,p_account,v_roomid,v_buyamt,v_payable,v_bod_debt_t0,v_bod_d_margin,
                  v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,0,p_symbol,p_qtty-v_quote_qtty,v_t0value,p_err_msg);
                --dbms_output.put_line('p_err_code : '  || p_err_code);
              END IF;
            END IF;
 --dbms_output.put_line('1115 v_trans_amount '||v_trans_amount ||' p_err_code '||p_err_code);
            IF p_err_code = '0' THEN
              --general orderid
              CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
              IF v_substatus = 'NN' THEN  --lenh chua gui so
                IF v_subtypecd = 'LO' THEN
                  UPDATE ORDERS SET QUOTE_QTTY=p_qtty,QUOTE_PRICE=p_price,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
                  WHERE ORDERID = p_edit_order_id;
                ELSE
                  UPDATE ORDERS SET QUOTE_QTTY=p_qtty,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
                  WHERE ORDERID = p_edit_order_id;
                END IF;
                p_exchange_qtty := p_qtty;
                p_order_id := p_edit_order_id;

                UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY - (v_quote_qtty - p_qtty) WHERE SYMBOL = p_symbol AND ACCTNO = p_account;
                --Thuc hien danh dau
                IF  v_formulacd != 'ADV' AND v_formulacd != 'CASH' THEN
                  IF (v_add_pool > 0) THEN
                    CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code,p_edit_order_id,'B',p_symbol,p_account,v_poolid,v_add_pool,0,null,p_err_msg);
                  END IF;

                  CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                    v_bod_d_margin_ub,v_odramt+v_buyamt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_order_id,v_side,p_symbol,p_qtty-v_quote_qtty,p_err_msg);
                END IF;

              ELSE --lenh goc da gui so
                p_exchange_qtty := p_qtty - v_exec_qtty;

                CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
                IF v_sesionex IN  ('L5M','CLS') THEN
                    p_err_code := '-95015';
                    RETURN;
                END IF;
                /*ThanhNV sua 4.7.2016 lay sessionex cua lenh goc. Dung de check doi ung*/
                INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,CONFIRMID,
                    USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE,ROOTORDERID,FLAGORDER,
                    SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                    TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, ORIGINORDERID,
                    EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
                  VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex_org, p_quote_id,v_confirmid,
                    p_userid, v_custodycd, p_account, p_symbol, 'O', v_root_orderid, 'C',
                    'AB', 'E', v_substatus, v_currtime, v_currtime,
                    v_typecd, v_subtypecd, p_price, p_exchange_qtty, 0, v_originorderid,
                    0,p_exchange_qtty, 0, 0, p_edit_order_id,
                    v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);

                p_order_id := v_order_id;

                --cap nhat tang buyingqtty khi yc sua lenh
                UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY-(v_quote_qtty - p_qtty) WHERE SYMBOL = p_symbol AND ACCTNO = p_account;

                IF v_formulacd != 'ADV' AND v_formulacd != 'CASH' THEN
                  IF (v_add_pool > 0) THEN
                    CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code,v_order_id,'B',p_symbol,p_account,v_poolid,v_add_pool,0,null,p_err_msg);
                  END IF;

                  CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                    v_bod_d_margin_ub,v_odramt+v_buyamt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_order_id,v_side,p_symbol,p_qtty-v_quote_qtty,p_err_msg);
                END IF;

                --Cap nhat trang thai lenh goc
                UPDATE ORDERS SET STATUS='S',SUBSTATUS='SE',LASTCHANGE = v_currtime where ORDERID = p_edit_order_id;

              END IF;

              --Tang ky quy mua
              -- UPDATE accounts SET CALC_ODRAMT = /*CALC_ODRAMT + v_trans_amount*/ CALC_ODRAMT + v_buyamt - (v_remain_qtty*v_quote_price + v_exec_amt)*(1+v_ratebrk/100)
              --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT + v_buyamt WHERE ACCTNO=p_account;
              UPDATE QUOTES SET STATUS= 'F',LASTCHANGE = v_currtime WHERE QUOTEID = p_quote_id;

            ELSE
              --ma loi la : p_err_code := '-90014';
              RETURN;
            END IF;
          ELSE
            --('Khong du suc mua');
            p_err_code := '-90016';
            RETURN;
          END IF;

        ELSE --Sua giam
   --dbms_output.put_line('1112 sua giam');
          --general orderid
          CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
          IF v_substatus = 'NN' THEN  --chua gui so
            IF v_subtypecd = 'LO' THEN
              UPDATE ORDERS SET QUOTE_QTTY=p_qtty,QUOTE_PRICE=p_price,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
              WHERE ORDERID = p_edit_order_id;
            ELSE
              UPDATE ORDERS SET QUOTE_QTTY=p_qtty,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
              WHERE ORDERID = p_edit_order_id;
            END IF;

            p_exchange_qtty := p_qtty;
            p_order_id := p_edit_order_id;
            UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY-(v_quote_qtty-p_qtty) WHERE SYMBOL=p_symbol AND ACCTNO=p_account;
            --Giam ky quy mua
            --v_trans_amount := v_remain_amt - v_amend_amt ;
            --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT - v_trans_amount WHERE ACCTNO = p_account;
          ELSE --da gui
--dbms_output.put_line('1112 dagui');
            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
                p_exchange_qtty := p_qtty - v_exec_qtty;
            IF v_sesionex IN  ('L5M','CLS') THEN
                p_err_code := '-95015';
                RETURN;
            END IF;
            --Sinh lenh sua
            INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, CONFIRMID,
                USERID, CUSTODYCD, ACCTNO, SYMBOL, ROOTORDERID, FLAGORDER,
                SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, ORIGINORDERID,
                EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
            VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex_org, p_quote_id,v_confirmid,
                p_userid, v_custodycd, p_account, p_symbol, v_root_orderid, 'C',
                'O', 'AB', 'E', v_substatus, v_currtime, v_currtime,
                v_typecd, v_subtypecd, p_price, /*p_qtty*/p_exchange_qtty,0, v_originorderid,
                /*v_exec_qtty*/0,p_exchange_qtty, 0, 0, p_edit_order_id,
                v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);

            --cap nhat lenh goc
            UPDATE ORDERS SET STATUS='S',SUBSTATUS='SE',LASTCHANGE = v_currtime WHERE ORDERID = p_edit_order_id;
            p_order_id := v_order_id;

          END IF;
            UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;

            /*
            dung.bui : hotfix check suc mua sau khi sua giam, date 27/01/2016
            */
  --dbms_output.put_line('1113 v_quote_qtty'||v_quote_qtty);
            IF (v_quote_qtty - p_qtty) > 0 AND v_rate_margin > 0 AND v_price_margin > 0 THEN
              --v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);
              v_odramt_edit_order := CSPKS_FO_COMMON.fn_get_buy_amt_edit_order(p_account);

  --dbms_output.put_line('1116 v_odramt1 '||v_odramt);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_odramt : ',v_odramt);
              --Phan giam tai san = (v_quote_qtty - p_qtty)*v_rate_margin*v_price_margin/100;
              --v_odramt := v_odramt + (v_quote_qtty - p_qtty)*v_rate_margin*v_price_margin/100;
             --ThanhNV sua 2016.03.01 truong hop sua lenh tinh Delta tai san giam.
             CSPKS_FO_COMMON.sp_get_pp_pp0_edit (p_err_code,v_p_pp,v_odramt_edit_order,p_account,v_balance,v_t0value,v_td,
                    v_payable,v_debt,v_rate_brk,v_advbal,v_crlimit,v_rate_margin,v_price_margin,
                    v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg, (v_quote_qtty - p_qtty), p_symbol );

            --dbms_output.put_line('1116 v_quote_qtty '||v_quote_qtty  ||' p_qtty '||p_qtty);

             insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_p_pp : ',v_p_pp);

/*               CSPKS_FO_COMMON.sp_get_pp_pp0_edit (p_err_code,v_p_pp,v_odramt,p_account,v_balance,v_t0value,v_td,
                    v_payable,v_debt,v_rate_brk,v_advbal,v_crlimit,v_rate_margin,v_price_margin,
                    v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg, (v_quote_qtty - p_qtty)*v_rate_margin*v_price_margin/100 );*/

--                    CSPKS_FO_COMMON.sp_get_pp(p_err_code,v_p_pp,p_account,v_formulacd,v_balance,v_t0value,v_td,v_payable,
--                      v_debt,v_rate_brk,v_bod_adv,v_advbal,v_crlimit,v_rate_margin,v_price_margin,p_price,
--                      v_basketid,v_odramt,v_roomid,v_rate_ub,p_symbol,p_err_msg);
--dbms_output.put_line('1116 v_p_pp1 '||v_p_pp ||' p_err_code '||p_err_code);
              IF v_p_pp <0 THEN
                p_err_code := '-90016';
                RETURN;
              END IF;
            END IF;
            /*end*/

        END IF;

        /*dung.bui : hotfix check suc mua sau khi sua lenh, date 03/02/2016*/
        IF v_rate_margin > 0 AND v_price_margin > 0 THEN
          v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'v_odramt : ',v_odramt);
          CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,v_p_pp,v_odramt,p_account,v_balance,v_t0value,v_td,
                v_payable,v_debt,v_rate_brk,v_advbal,v_crlimit,v_rate_margin,v_price_margin,
                v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'AMEND',p_account,null,'sp_get_pp_pp0 : ',v_p_pp);
          --commit;
  --dbms_output.put_line('1117 v_p_pp2 '||v_p_pp ||' p_err_code '||p_err_code);
          IF v_p_pp <0 THEN
            p_err_code := '-90016';
            RETURN;
          END IF;
        END IF;
        /*end*/

      ELSE
          --Khoi luong chung khoan sua khong hop le;
          p_err_code := '-95003';
          RETURN;
      END IF;
    END IF;
--    p_order_id := null;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:= 'sp_proces_edit_buy_order_HNX '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_edit_buy_order_HNX;

  PROCEDURE sp_proces_edit_buy_order_HSX(p_err_code in OUT VARCHAR,
              p_order_id in OUT VARCHAR, --so hieu lenh moi
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_account IN VARCHAR, --so tieu khoan giao dich
              p_symbol IN VARCHAR, --ma chung khoan
              p_qtty IN  NUMBER,  --Khoi luong sua
              p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
              p_price IN  NUMBER, --gia ban
              p_session_index IN VARCHAR,--phien giao dich
              p_quote_id IN VARCHAR, --so hieu yeu cau
              p_userid in VARCHAR, --ma nguoi dung dat lenh
              p_txdate in varchar,
              p_err_msg OUT VARCHAR2,
              p_corebank_amt OUT NUMBER
              )
  AS
    v_quote_qtty            ORDERS.QUOTE_QTTY%TYPE;
    v_quote_price           ORDERS.QUOTE_PRICE%TYPE;
    v_exec_qtty             ORDERS.EXEC_QTTY%TYPE;
    v_remain_qtty           ORDERS.REMAIN_QTTY%TYPE;
    v_typecd                ORDERS.TYPECD%TYPE;
    v_subtypecd             ORDERS.SUBTYPECD%TYPE;
    v_status                ORDERS.STATUS%TYPE;
    v_substatus             ORDERS.SUBSTATUS%TYPE;
    v_price_margin          ORDERS.PRICE_MARGIN%TYPE;
    v_price_asset           ORDERS.PRICE_ASSET%TYPE;
    v_rate_brk              ORDERS.RATE_BRK%TYPE;
    v_rate_tax              ORDERS.RATE_TAX%TYPE;
    v_rate_adv              ORDERS.RATE_ADV%TYPE;
    v_root_orderid          ORDERS.ROOTORDERID%TYPE;
    v_sesionex_order        ORDERS.SESSIONEX%TYPE;
    v_exec_amt              ORDERS.EXEC_AMT%TYPE;
    v_p_pp                  NUMBER;
    v_add_pool              NUMBER;
    v_trans_amount          NUMBER;
    v_buyamt                NUMBER;
    v_count                 NUMBER;
    v_edit_amt              NUMBER; --ky quy sua
    v_remain_amt            NUMBER; --ky quy cho khop
    v_order_id              VARCHAR(20);
    v_currtime              TIMESTAMP;
    v_custodycd             ACCOUNTS.CUSTODYCD%TYPE;
    v_formulacd             ACCOUNTS.FORMULACD%TYPE;
    v_balance               ACCOUNTS.BOD_BALANCE%TYPE;
    v_t0value               ACCOUNTS.BOD_T0VALUE%TYPE;
    v_td                    ACCOUNTS.BOD_TD%TYPE;
    v_payable               ACCOUNTS.BOD_PAYABLE%TYPE;
    v_debt                  ACCOUNTS.BOD_DEBT%TYPE;
    v_advbal                ACCOUNTS.CALC_ADVBAL%TYPE;
    v_crlimit               ACCOUNTS.BOD_CRLIMIT%TYPE;
    v_basketid              ACCOUNTS.BASKETID%TYPE;
    v_odramt                ACCOUNTS.CALC_ODRAMT%TYPE;
    v_poolid                ACCOUNTS.POOLID%TYPE;
    v_roomid                ACCOUNTS.ROOMID%TYPE;
    v_bod_adv               ACCOUNTS.BOD_ADV%TYPE;
    v_sesionex              MARKETINFO.SESSIONEX%TYPE;
    v_rate_margin           BASKETS.RATE_MARGIN%TYPE;
    v_dof                   CUSTOMERS.DOF%TYPE;
    v_exchange              INSTRUMENTS.EXCHANGE%TYPE;
    v_fqtty                 INSTRUMENTS.FQTTY%TYPE;
    v_txdate                VARCHAR(20);
    v_bod_debt_t0           ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin          ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_rate_ub               ACCOUNTS.RATE_UB%TYPE;
    v_originorderid         ORDERS.ORIGINORDERID%TYPE;
    v_bod_d_margin_ub       ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_side                  ORDERS.SIDE%TYPE;
    v_banklink VARCHAR(2);
    v_count_bankaccorders NUMBER;
    v_count_blacklist_ex NUMBER;
    v_Firm varchar2(100);
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_edit_buy_order_HSX p_edit_order_id=>'||p_edit_order_id;

      BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
      END;
      --Lay thong tin lenh goc
      SELECT QUOTE_QTTY,EXEC_QTTY,REMAIN_QTTY,TYPECD,SUBTYPECD,
              EXEC_AMT,QUOTE_PRICE,STATUS,SUBSTATUS,RATE_ADV,
              ORIGINORDERID,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,
              ROOTORDERID,SESSIONEX, SIDE
      INTO   v_quote_qtty,v_exec_qtty,v_remain_qtty,v_typecd,v_subtypecd,
              v_exec_amt,v_quote_price,v_status,v_substatus,v_rate_adv,
              v_originorderid,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,
              v_root_orderid,v_sesionex_order, v_side
      FROM ORDERS WHERE ORDERID = p_edit_order_id;
      --Lay thong tin tai khoan
      SELECT CUSTODYCD,FORMULACD,BOD_BALANCE,BOD_T0VALUE,BOD_TD,
             BOD_PAYABLE,BOD_DEBT,BOD_ADV,RATE_UB,BOD_D_MARGIN_UB,
             CALC_ADVBAL,BOD_CRLIMIT,BASKETID,POOLID,ROOMID,
             BOD_DEBT_T0,BOD_D_MARGIN,BANKLINK
      INTO   v_custodycd,v_formulacd,v_balance,v_t0value,v_td,
             v_payable,v_debt,v_bod_adv,v_rate_ub,v_bod_d_margin_ub,
             v_advbal,v_crlimit,v_basketid,v_poolid,v_roomid,
             v_bod_debt_t0,v_bod_d_margin,v_banklink
      FROM   ACCOUNTS WHERE ACCTNO = p_account;


      --ThanhNV 04.07.2016 sua kiem tra lenh doi ung theo thong tu 203
      cspks_fo_common.sp_check_reciprocal(p_err_code  => p_err_code,
                                          p_custodycd => v_custodycd,
                                          p_symbol    => p_symbol,
                                          p_err_msg   => p_err_msg,
                                          p_side      => v_side,
                                          p_subtypecd => v_subtypecd);
      IF (p_err_code <> '0') THEN
        p_err_code := '-95013';
        RETURN;
      END IF;

      --lay thong tin phien, san gd
      --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_symbol AND M.EXCHANGE=I.EXCHANGE;
      SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
      SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
      --lay thong tin ngay gd
      SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';
      v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);

      IF v_remain_qtty = 0 THEN
        p_err_code := '-95003';
        RETURN;
      END IF;

      IF p_qtty = v_quote_qtty AND p_price = v_quote_price THEN
        p_err_code := '-95003';
        RETURN;
      END IF;

      /*dung.bui add code 20/10/2015 */
      /*description: khong cho sua lenh neu khoi luong sua = khoi luong con lai*/
      IF p_qtty = v_remain_qtty AND p_price = v_quote_price THEN
        p_err_code := '-95003';
        RETURN;
      END IF;
      /*end*/

      /*dung.bui add code check phien, date 14/12/2015*/
      IF v_sesionex='END' THEN --dong cua thi truong
          p_err_code := '-95043';
          RETURN;
      END IF;

      IF v_sesionex IN ('CROSS','CLS','L5M') THEN --phien cho lenh thoa thuan
          p_err_code := '-95015';
          RETURN;
      END IF;
      /*end*/

      IF v_subtypecd != 'LO' AND  v_substatus != 'NN' THEN
        p_err_code := '-95024';
  --          dbms_output.put_line('khong duoc huy lenh thi truong');
            RETURN;
      END IF;

      IF (v_status= 'S' AND v_substatus = 'SE') OR (v_substatus = 'BB')
               OR (v_substatus = 'SD') OR (v_substatus = 'DD')
               OR (v_substatus = 'DC') OR (v_substatus = 'EC') OR (v_substatus = 'EE') THEN
        p_err_code := '-95006';
        RETURN;
      ELSIF v_substatus= 'NN' THEN --chua day len so
        /*
        dung.bui added code,date: 2015-09-11
        */
        IF v_subtypecd = 'LO' THEN
          UPDATE ORDERS SET QUOTE_QTTY=p_qtty,QUOTE_PRICE=p_price,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
          WHERE ORDERID = p_edit_order_id;
        ELSE
          UPDATE ORDERS SET QUOTE_QTTY=p_qtty,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
          WHERE ORDERID = p_edit_order_id;
        END IF;
        /*end*/

        p_order_id := p_edit_order_id;
        UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_quote_id;
        UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-(v_quote_qtty-p_qtty) WHERE SYMBOL=p_symbol AND ACCTNO=p_account;

      ELSE -- lenh da day len so

        /*
        dung.bui added for t0value can not edit buy symbol in BLACK_LIST
        date: 2016-06-03
        */

        /*ThanhNV sua hotfix neu Blaclist ma co T0 thi ko cho dat lenh*/
        SELECT COUNT(1) INTO v_count FROM BASKETS WHERE BASKETID='BLACK_LIST' AND SYMBOL=p_symbol;

        IF v_count > 0 AND v_t0value > 0 THEN

          --ThanhNV sua 29.9 kiem tra tk co phai loai tru voi ma BLACKLIST ko, neu loai tru thi ko check.
          SELECT count(*) INTO v_count_blacklist_ex FROM BASKETS
          WHERE instr(basketid,'BLACK_LIST') > 0 AND instr(basketid,p_account)>0 AND SYMBOL=p_symbol;

          --Kiem tra firm, neu la luu ky nuoc ngoai thi ko check:
          SELECT cfgvalue INTO v_Firm FROM sysconfig WHERE  cfgkey ='FIRM';
          IF  substr(v_custodycd,1,3) =  v_Firm AND v_count_blacklist_ex =0  THEN
                p_err_code := '-95035';
                RETURN;
          END IF;
        END IF;




        IF (p_qtty > v_exec_qtty) THEN
          v_edit_amt := p_qtty*p_price*(1+v_rate_brk/100);
          v_remain_amt := v_quote_qtty*v_quote_price*(1+v_rate_brk/100);

          IF(v_edit_amt > v_remain_amt) THEN --Sua tang
            -- check room neu la tk nuoc ngoai
            SELECT DOF INTO v_dof FROM CUSTOMERS WHERE CUSTODYCD = v_custodycd;
            SELECT FQTTY INTO v_fqtty FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
            IF v_dof = 'F' AND p_qtty-v_exec_qtty > v_fqtty THEN --tk nha dau tu nuoc ngoai
              p_err_code := '-95012';
              RETURN;
            END IF;

            --lay thong tin ro chung khoan
             v_rate_margin := 0;
             v_price_margin := 0;
            SELECT COUNT(1) INTO v_count FROM BASKETS A,ACCOUNTS B WHERE A.BASKETID=B.BASKETID AND A.SYMBOL=p_symbol AND B.acctno=p_account;
            IF (v_count = 1) THEN
              SELECT RATE_MARGIN,PRICE_MARGIN INTO v_rate_margin,v_price_margin
              FROM BASKETS A,ACCOUNTS B WHERE A.BASKETID=B.BASKETID AND A.SYMBOL=p_symbol AND B.acctno=p_account;
            ELSIF   (v_count > 1) THEN
              --chac ko the xay ra case nay
              p_err_code := '-9888';
            END IF;

            --Kiem tra suc mua
            v_buyamt := ((p_qtty - v_exec_qtty)*p_price - (v_remain_qtty*v_quote_price))*((1+v_rate_brk/100));
            -- Tinh PP0 + bao lanh
            CSPKS_FO_COMMON.sp_get_pp_pp0 (p_err_code,v_p_pp,v_odramt,p_account,v_balance,0,v_td,
              v_payable,v_debt,v_rate_brk,v_advbal,v_crlimit,v_rate_margin,v_price_margin,
              v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);

            v_p_pp := GREATEST(0,v_p_pp + v_t0value);

            /*date: 2014-03-12 : 13h30,author: dung.bui
            descrition: sua doan code nay
            begin
            */
            v_trans_amount := v_buyamt + LEAST(0,v_quote_qtty-p_qtty)*v_rate_margin*v_price_margin/100;
            /*end*/

            /*date: 2016-02-17 : 13h30,author: tien.do*/
          /*edit for corebank*/

          IF(v_banklink = 'B' AND (v_p_pp < v_trans_amount)) THEN
             --p_err_code := '-95555';
             p_corebank_amt :=  ceil(v_trans_amount - v_p_pp); --Dung fix , lam tron len tien hold

             SELECT COUNT(1) INTO v_count_bankaccorders FROM BANKACCORDERS WHERE QUOTEID = p_quote_id;
            IF v_count_bankaccorders > 0 THEN
              p_err_code := '-95036';
            ELSE
               INSERT INTO BANKACCORDERS(QUOTEID,ACCTNO,AMOUNT,STATUS,LASTCHANGE)
               VALUES(p_quote_id,p_account,p_corebank_amt,'N', v_currtime);
               p_err_code := '-95555';
               p_order_id := p_quote_id;
               UPDATE QUOTES SET STATUS='B', LASTCHANGE=v_currtime WHERE QUOTEID=p_quote_id; --for show wait order on interface
            END IF;

            SELECT COUNT(1) INTO v_count_bankaccorders FROM QUOTES WHERE REFQUOTEID = p_edit_order_id AND STATUS = 'B';
            IF v_count_bankaccorders >=2 THEN
              p_err_code := '-95023';
              RETURN;
            END IF;

            RETURN;
          END IF;
          /*end*/


            IF (v_p_pp >= v_trans_amount) /*(v_p_pp > 0)*/ THEN --kiem tra suc mua
              IF  v_formulacd != 'ADV' AND v_formulacd != 'CASH' THEN
                v_add_pool := CSPKS_FO_POOLROOM.fn_get_using_pool( p_err_code,v_buyamt,
                            v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
                --Kiem tra Pool
                IF v_add_pool > 0 AND v_poolid is not null THEN
                  CSPKS_FO_POOLROOM.sp_process_checkpool(p_err_code,v_poolid,v_add_pool,p_err_msg);
                END IF;
                IF p_err_code != 0 THEN
                  p_err_code := '-90014';
                  RETURN;
                END IF;

                --Kiem tra room
                IF v_add_pool > 0 AND v_roomid is not null THEN
                  CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,p_account,v_roomid,v_buyamt,v_payable,v_bod_debt_t0,v_bod_d_margin,
                  v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv, v_advbal,v_td,0,p_symbol,p_qtty-v_quote_qtty,v_t0value,p_err_msg);
                END IF;
              END IF;

              IF p_err_code = '0' THEN
                --Sinh lenh huy
                --general orderid
                CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);

                CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
                p_exchange_qtty :=  p_qtty - v_exec_qtty;
                --check phien
                IF v_sesionex = 'OPN' THEN
                  p_err_code := '-95015';
                  RETURN;
                END IF;
                IF (v_sesionex_order != 'CLS') and (v_sesionex = 'OPN') THEN
                  p_err_code := '-95015';
                  RETURN;
                END IF;
                IF (v_sesionex_order = 'CLS') THEN
                  p_err_code := '-95015';
                  RETURN;
                END IF;

                --Get substatus
                IF v_substatus ='BB' THEN
                  v_substatus := 'DE';
                END IF;
                --IF v_status = 'B' THEN
                  --v_status := 'D';
                --END IF;
                -- sinh lenh yeu cau huy de sua
                INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                            USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ROOTORDERID,FLAGORDER,
                            SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                            TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, ORIGINORDERID,
                            EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                            RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
                VALUES (v_order_id, to_date(v_txdate,'dd-mm-yyyy'), 'N', v_sesionex, p_quote_id,
                            p_userid, v_custodycd, p_account, p_symbol, 'O', v_root_orderid,'C',
                            'CB', 'D', v_substatus, v_currtime, v_currtime,
                            v_typecd, v_subtypecd, p_price, v_quote_qtty, v_exec_amt, v_originorderid,
                            v_exec_qtty,p_exchange_qtty, 0, 0, p_edit_order_id,
                            v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);
                -- (sinh yc huy ko tang ki quy)
                --Cap nhat lenh goc
                UPDATE ORDERS SET STATUS='S',SUBSTATUS='SD',LASTCHANGE = v_currtime WHERE ORDERID=p_edit_order_id;
                --Cap nhat bang quotes
                UPDATE QUOTES SET STATUS='F',LASTCHANGE = v_currtime WHERE QUOTEID=p_quote_id;
                p_order_id := v_order_id;
              ELSE
                --dbms_output.put_line('khong du poolroom');
                p_err_code := '-90015';
                RETURN;
              END IF;
            ELSE
              --dbms_output.put_line('Khong du suc mua');
              p_err_code := '-90016';
              RETURN;
            END IF;
          ELSE --Sua giam
            --general orderid
            CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
            --Sinh lenh yeu cau huy de sua
            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
            p_exchange_qtty :=  p_qtty - v_exec_qtty;

            IF v_substatus ='BB' THEN
              v_substatus := 'DE';
            END IF;

            IF v_sesionex = 'OPN' THEN
              p_err_code := '-95015';
              RETURN;
            END IF;
            IF (v_sesionex_order != 'CLS') and (v_sesionex = 'OPN') THEN
              p_err_code := '-95015';
              RETURN;
            END IF;
            IF (v_sesionex_order = 'CLS') THEN
              p_err_code := '-95015';
              RETURN;
            END IF;

            --sinh lenh yeu cau huy
            INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                        USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ROOTORDERID,FLAGORDER,
                        SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                        TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, ORIGINORDERID,
                        EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                        RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
            VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex, p_quote_id,
                        p_userid, v_custodycd, p_account, p_symbol, 'O',v_root_orderid,'C',
                        'CB', 'D', v_substatus, v_currtime, v_currtime,
                        v_typecd, v_subtypecd, p_price, v_quote_qtty, v_exec_amt, v_originorderid,
                        v_exec_qtty,p_exchange_qtty, 0, 0, p_edit_order_id,
                        v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);

            UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_quote_id;
            UPDATE ORDERS SET STATUS='S',SUBSTATUS='SD',LASTCHANGE = v_currtime WHERE ORDERID = p_edit_order_id;
            p_order_id := v_order_id;
          END IF;

        ELSE
          -- plog.info('Khoi luong chung khoan sua khong hop le');
          p_err_code := '-95003';
          RETURN;
        END IF;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_msg:='sp_proces_edit_buy_order_HSX '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_edit_buy_order_HSX;

  PROCEDURE sp_proces_edit_sell_order_HSX(p_err_code in OUT VARCHAR,
            p_order_id in OUT VARCHAR, --so hieu lenh moi
            p_edit_order_id IN VARCHAR, --so hieu lenh goc
            p_account IN VARCHAR, --so tieu khoan giao dich
            p_symbol IN VARCHAR, --ma chung khoan
            p_qtty IN  NUMBER,  --Khoi luong sua
            p_exchange_qtty in OUT  NUMBER,  --Khoi luong day len san
            p_price IN  NUMBER, --gia ban
            p_session_index IN VARCHAR,--phien giao dich
            p_quote_id IN VARCHAR, --so hieu yeu cau
            p_userid in VARCHAR, --ma nguoi dung dat lenh
            p_txdate in varchar,
            p_err_msg OUT VARCHAR2
            )
  AS
    v_order_id                VARCHAR(20);
    v_currtime                TIMESTAMP;
    v_quote_qtty              ORDERS.QUOTE_QTTY%TYPE;
    v_quote_price             ORDERS.QUOTE_PRICE%TYPE;
    v_exec_qtty               ORDERS.EXEC_QTTY%TYPE;
    v_remain_qtty             ORDERS.REMAIN_QTTY%TYPE;
    v_subside                 ORDERS.SUBSIDE%TYPE;
    v_typecd                  ORDERS.TYPECD%TYPE;
    v_subtypecd               ORDERS.SUBTYPECD%TYPE;
    v_status                  ORDERS.STATUS%TYPE;
    v_substatus               ORDERS.SUBSTATUS%TYPE;
    v_sesionex_order          ORDERS.SESSIONEX%TYPE;
    v_rate_brk                ORDERS.RATE_BRK%TYPE;
    v_price_margin            ORDERS.PRICE_MARGIN%TYPE;
    v_price_asset             ORDERS.PRICE_ASSET%TYPE;
    v_rate_tax                ORDERS.RATE_TAX%TYPE;
    v_rate_adv                ORDERS.RATE_ADV%TYPE;
    v_exec_amt                ORDERS.EXEC_AMT%TYPE;
    v_root_orderid            ORDERS.ROOTORDERID%TYPE;
    v_custodycd               ORDERS.CUSTODYCD%TYPE;
    v_trade_qtty              PORTFOLIOS.TRADE%TYPE;
    v_selling_qtty            PORTFOLIOS.SELLINGQTTY%TYPE;
    v_exchange                INSTRUMENTS.EXCHANGE%TYPE;
    v_sesionex                MARKETINFO.SESSIONEX%TYPE;
    v_originorderid           ORDERS.ORIGINORDERID%TYPE;
    v_trade_qttyEX            NUMBER;
    v_selling_qttyEX          NUMBER;
    v_side                  ORDERS.SIDE%TYPE;
  BEGIN

    p_err_code := '0';
    p_err_msg:='sp_proces_edit_sell_order_HSX p_quote_id=>'||p_quote_id;
    BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
    END;

    --lay thong tin lenh goc
    SELECT QUOTE_QTTY,QUOTE_PRICE,EXEC_QTTY,REMAIN_QTTY,TYPECD,SUBTYPECD,SUBSIDE,STATUS,SUBSTATUS,SESSIONEX,
        RATE_BRK,RATE_ADV,RATE_ADV,PRICE_MARGIN,PRICE_ASSET,EXEC_AMT,ROOTORDERID,CUSTODYCD,ORIGINORDERID, SIDE
    INTO v_quote_qtty,v_quote_price,v_exec_qtty,v_remain_qtty,v_typecd,v_subtypecd,v_subside,v_status,v_substatus,v_sesionex_order,
        v_rate_brk,v_rate_adv,v_rate_tax,v_price_margin,v_price_asset,v_exec_amt,v_root_orderid,v_custodycd,v_originorderid, v_side
    FROM ORDERS WHERE ORDERID = p_edit_order_id;


     --ThanhNV 04.07.2016 sua kiem tra lenh doi ung theo thong tu 203
      cspks_fo_common.sp_check_reciprocal(p_err_code  => p_err_code,
                                          p_custodycd => v_custodycd,
                                          p_symbol    => p_symbol,
                                          p_err_msg   => p_err_msg,
                                          p_side      => v_side,
                                          p_subtypecd => v_subtypecd);
      IF (p_err_code <> '0') THEN
        p_err_code := '-95013';
        RETURN;
      END IF;


    --lay thong tin phien, san gd
    --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_symbol AND M.EXCHANGE=I.EXCHANGE;
    SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
    SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL = p_symbol;

    IF v_subtypecd != 'LO' AND  v_substatus != 'NN' THEN
        p_err_code := '-95024';
        RETURN;
    END IF;

    --Khoi luong va gia khong thay doi
    IF p_qtty = v_quote_qtty AND p_price = v_quote_price THEN
        p_err_code := '-95003';
        RETURN;
    END IF;

    IF v_remain_qtty = 0 THEN
      p_err_code := '-95003';
      RETURN;
    END IF;

    /*dung.bui add code 20/10/2015 */
    /*description: khong cho sua lenh neu khoi luong sua = khoi luong con lai*/
    IF p_qtty = v_remain_qtty AND p_price = v_quote_price THEN
      p_err_code := '-95003';
      RETURN;
    END IF;
    /*end*/

    /*dung.bui add code check phien, date 14/12/2015*/
    IF v_sesionex='END' THEN --dong cua thi truong
        p_err_code := '-95043';
        RETURN;
    END IF;

    IF v_sesionex IN ('CROSS','CLS','L5M') THEN --phien cho lenh thoa thuan
        p_err_code := '-95015';
        RETURN;
    END IF;
    /*end*/

    IF (v_status = 'S' AND v_substatus = 'SE') OR (v_substatus = 'BB')
        OR (v_substatus = 'SD') OR (v_substatus = 'DD')
        OR (v_substatus = 'DC') OR (v_substatus = 'EC') OR (v_substatus = 'EE') OR v_remain_qtty=0 THEN

        p_err_code := '-95023';
        RETURN;
    ELSIF v_substatus= 'NN' THEN --chua day len so
      /*
      dung.bui added code,date: 2015-09-11
      */
      IF v_subtypecd = 'LO' THEN
        UPDATE ORDERS SET QUOTE_QTTY=p_qtty,QUOTE_PRICE=p_price,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
        WHERE ORDERID = p_edit_order_id;
      ELSE
        UPDATE ORDERS SET QUOTE_QTTY=p_qtty,REMAIN_QTTY=p_qtty,QUOTEID=p_quote_id,LASTCHANGE=v_currtime
        WHERE ORDERID = p_edit_order_id;
      END IF;

      --Cap nhat bang Portfolios
      IF(v_subside = 'NS') THEN
          UPDATE PORTFOLIOS SET SELLINGQTTY=SELLINGQTTY-(v_quote_qtty-p_qtty) WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
      ELSIF (v_subside = 'MS') THEN
          UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT-(v_quote_qtty-p_qtty) WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
      END IF;

      UPDATE QUOTES SET status= 'F' WHERE QUOTEID = p_quote_id;
      RETURN;

    ELSE  --da day len so

      --general orderid
      CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
      CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
      p_exchange_qtty :=  p_qtty - v_exec_qtty;

      --convert substatus for edit HSX
      IF v_substatus ='BB' THEN
          v_substatus := 'DE';
      END IF;
      -- CHECK PHIEN
      IF v_sesionex = 'OPN' THEN
          p_err_code := '-95015';
          RETURN;
      END IF;
      IF (v_sesionex_order != 'CLS') and (v_sesionex = 'OPN') THEN
          p_err_code := '-95015';
          RETURN;
      END IF;
      IF (v_sesionex_order = 'CLS') THEN
          p_err_code := '-95015';
          RETURN;
      END IF;

      IF (p_qtty > v_exec_qtty) THEN
          IF (p_qtty <= v_remain_qtty) THEN --Sua giam
              --sinh lenh yeu cau huy de sua
              INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                  USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ROOTORDERID,FLAGORDER,
                  SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                  TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT,
                  EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                  RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
              VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex, p_quote_id,
                  p_userid, v_custodycd, p_account, p_symbol, 'O',v_root_orderid,'C',
                  'CS', 'D', v_substatus, v_currtime, v_currtime,
                  v_typecd, v_subtypecd, p_price, v_quote_qtty, v_exec_amt,
                  v_exec_qtty,p_exchange_qtty, 0, 0, p_edit_order_id,
                  v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);

              -- update status order
              UPDATE ORDERS SET STATUS = 'S', SUBSTATUS = 'SD',LASTCHANGE = SYSDATE WHERE ORDERID = p_edit_order_id;
              UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;
              p_order_id := v_order_id;
          ELSE --Sua tang
              IF(v_subside = 'NS') THEN
                  SELECT TRADE,SELLINGQTTY INTO v_trade_qtty,v_selling_qtty FROM PORTFOLIOS WHERE ACCTNO = p_account AND SYMBOL=p_symbol;

                  --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
                  BEGIN
                     SELECT SELLINGQTTY INTO v_selling_qttyEx FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
                  EXCEPTION WHEN OTHERS THEN
                     v_selling_qttyEx:=0;
                  END;
                  v_selling_qtty := v_selling_qtty + v_selling_qttyEx;

              ELSE
                  SELECT MORTGAGE,SELLINGQTTYMORT INTO v_trade_qtty,v_selling_qtty FROM portfolios WHERE ACCTNO = p_account AND SYMBOL=p_symbol;

                  --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
                  BEGIN
                     SELECT SELLINGQTTYMORT INTO v_selling_qttyEx FROM PORTFOLIOSEX WHERE ACCTNO = p_account and SYMBOL= p_symbol;
                  EXCEPTION WHEN OTHERS THEN
                     v_selling_qttyEx:=0;
                  END;
                  v_selling_qtty := v_selling_qtty + v_selling_qttyEx;

              END IF;

              IF(p_qtty-v_remain_qtty-v_exec_qtty) <= (v_trade_qtty-v_selling_qtty) THEN --du chung khoan
                  --sinh lenh yeu cau huy de sua
                  INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                        USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ROOTORDERID,FLAGORDER,
                        SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                        TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, ORIGINORDERID,
                        EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                        RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
                  VALUES (v_order_id, to_date(p_txdate,'dd-mm-yyyy'), 'N', v_sesionex, p_quote_id,
                        p_userid, v_custodycd, p_account, p_symbol, 'O',v_root_orderid,'C',
                        'CS', 'D', v_substatus, v_currtime, v_currtime,
                        v_typecd, v_subtypecd, p_price, v_quote_qtty, v_exec_amt, v_originorderid,
                        v_exec_qtty,p_exchange_qtty, 0, 0, p_edit_order_id,
                        v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);
                  --update status order
                  UPDATE ORDERS SET STATUS = 'S', SUBSTATUS = 'SD',lastchange = v_currtime WHERE ORDERID = p_edit_order_id;
                  UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;
                  p_order_id := v_order_id;
              ELSE --khong du chung khoan de sua lenh
                  --Khoi luong chung khoan sua khong hop le
                  p_err_code := '-95003';
                  RETURN;
              END IF;
          END IF;
      ELSE
          --Khoi luong sua khong duoc nho hon hoac bang khoi luong khop
          p_err_code := '-95003';
          RETURN;
      END IF;
    END IF;

    EXCEPTION
     WHEN OTHERS THEN
       p_err_code := '-90025';
       p_err_msg:= 'sp_proces_edit_sell_order_HSX '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_edit_sell_order_HSX;


    --Huy lenh GTC, lenh nhap, lenh quang cao
    PROCEDURE sp_proces_cancel_gda_order(p_err_code in OUT VARCHAR,
                p_classcd in OUT VARCHAR, --so hieu lenh moi
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN  NUMBER,  --Khoi luong sua
                p_price IN  NUMBER, --gia ban
                p_quote_id IN VARCHAR, --so hieu yeu cau
                p_userid in VARCHAR, --ma nguoi dung dat lenh
                p_txdate in varchar,
                p_err_msg OUT VARCHAR2
                )
    AS
       v_count integer;

    BEGIN
      p_err_msg:='sp_proces_cancel_gda_order p_quote_id=>'||p_quote_id;
      SELECT count(QUOTEID) INTO  v_count FROM QUOTES WHERE  QUOTEID = p_quote_id AND CLASSCD IN ('GTC','DRO','ADO');
      IF v_count = 1 THEN
          --update quotes table
          UPDATE quotes SET status= 'R' WHERE QUOTEID = p_quote_id AND CLASSCD IN ('GTC','DRO','ADO');
          p_err_code := '0';
      ELSE
          p_err_code := '-95005';
      END IF;

       EXCEPTION
         WHEN OTHERS THEN
           p_err_code := '-90025';
           p_err_msg:='sp_proces_cancel_gda_order '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_cancel_gda_order;

    --Sinh lenh huy de sua cho HSX
    /*PROCEDURE sp_proces_cancel_for_edit(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh moi
                p_cancel_order_id IN VARCHAR, --so hieu lenh can huy
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_userid in VARCHAR, --ma nguoi dung dat lenh
                p_price in number,
                p_qtty in number,
                p_quote_id varchar
                )
  AS
      v_remain_qtty   NUMBER(20);
      v_order_id VARCHAR(20);
      v_custodycd VARCHAR(20);
      v_rate_brk NUMBER;
      v_price_margin NUMBER;
      v_price_asset NUMBER;
      v_rate_tax NUMBER;
      v_rate_adv NUMBER;
      v_price NUMBER;
      v_quote_id VARCHAR2(20);
      v_sessionex VARCHAR2(10);
      v_symbol VARCHAR2(20);
      v_root_orderid varchar(20);
      v_exec_qtty NUMBER;
      v_exec_amt NUMBER;
      v_quote_qtty NUMBER;
      v_txdate varchar(30);
      v_currtime timestamp;
    BEGIN
       p_err_code := '0';
       BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
       END;
       --lay thong tin lenh goc
       SELECT QUOTE_QTTY,RATE_ADV,RATE_BRK,RATE_TAX,EXEC_QTTY,EXEC_AMT,
       PRICE_MARGIN,PRICE_ASSET,QUOTE_PRICE,QUOTEID,SESSIONEX,SYMBOL,ROOTORDERID,CUSTODYCD
       INTO v_quote_qtty,v_rate_adv,v_rate_brk,v_rate_tax,v_exec_qtty,v_exec_amt,
       v_price_margin,v_price_asset,v_price,v_quote_id,v_sessionex,v_symbol,v_root_orderid,v_custodycd
       FROM orders WHERE orderid = p_cancel_order_id;

          --general orderid
          CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id);
          -- Save order

          SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY = 'TRADE_DATE';
          v_remain_qtty := p_qtty - v_exec_qtty;
          -- sinh lenh yeu cau huy de sua
          INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                    USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ROOTORDERID,FLAGORDER,
                    SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                    TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT,
                    EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,
                    RATE_ADV,RATE_BRK,RATE_TAX,PRICE_MARGIN,PRICE_ASSET,LASTCHANGE)
          VALUES (v_order_id, to_date(v_txdate,'dd-mm-yyyy'), 'N', v_sessionex, p_quote_id,
                  p_userid, v_custodycd, p_account, v_symbol, 'O',v_root_orderid,'C',
                  'CS', 'D', 'DE', v_currtime, v_currtime,
                  'LO', 'LO',p_price, v_quote_qtty, v_exec_amt,
                  v_exec_qtty,v_remain_qtty, 0, 0,p_cancel_order_id,
                  v_rate_adv,v_rate_brk,v_rate_tax,v_price_margin,v_price_asset,v_currtime);

          p_order_id := v_order_id;

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
    END sp_proces_cancel_for_edit;
    */

END CSPKS_FO_ORDER_AMEND;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_AMEND

