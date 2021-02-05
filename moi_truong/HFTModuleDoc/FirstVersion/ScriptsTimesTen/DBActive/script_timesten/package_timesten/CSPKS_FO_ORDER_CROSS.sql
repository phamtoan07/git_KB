-- Start of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_CROSS
-- Generated 16-Oct-2018 10:17:05 from FOTEST@FO

CREATE OR REPLACE 
PACKAGE cspks_fo_order_cross AS

    PROCEDURE sp_process_order_cross(p_err_code OUT VARCHAR,
                p_sell_ord_id OUT VARCHAR,
                p_buy_ord_id OUT VARCHAR,
                p_buy_acctno OUT VARCHAR,
                p_poolval OUT NUMBER,
                p_quote_id IN VARCHAR,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2);

    PROCEDURE sp_process_order_cross_sell(p_err_code OUT VARCHAR,
                p_order_id OUT VARCHAR,
                p_quote_id IN VARCHAR,
                p_acctno IN VARCHAR,
                p_symbol IN VARCHAR,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_userid IN VARCHAR,
                p_typecd IN VARCHAR,
                p_subtypecd IN VARCHAR,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2);

    PROCEDURE sp_process_order_cross_buy(p_err_code OUT VARCHAR,
                p_order_id OUT VARCHAR,
                p_poolval OUT NUMBER,
                p_quote_id IN VARCHAR,
                p_acctno IN VARCHAR2,
                p_symbol IN VARCHAR2,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_userid IN VARCHAR2,
                p_typecd IN VARCHAR2,
                p_subtypecd IN VARCHAR2,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2);

    /*PROCEDURE sp_proces_msg_forward_cross(p_err_code in OUT VARCHAR,
                p_crossid IN VARCHAR,
                p_sell_clordid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_target_comp_id IN VARCHAR,
                p_buy_party_id IN VARCHAR,
                p_sell_party_id IN VARCHAR,
                p_buy_acctno IN VARCHAR,
                p_sell_acctno IN VARCHAR,
                p_adv_id IN VARCHAR);*/

    PROCEDURE sp_proces_msg_forward_cross(p_err_code OUT VARCHAR,
                p_crossid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_side IN VARCHAR,
                p_sell_party_id IN VARCHAR,
                p_buy_acctno IN VARCHAR,
                p_sell_acctno IN VARCHAR,
                p_adv_id IN VARCHAR,
              p_err_msg OUT VARCHAR2);

    PROCEDURE sp_proces_cancel_cross_order(p_err_code OUT VARCHAR,
                p_sell_ord_id OUT VARCHAR,
                p_buy_ord_id OUT VARCHAR,
                p_cancel_order_id IN VARCHAR,
                p_userid IN VARCHAR,
                p_quote_id IN VARCHAR,
              p_err_msg OUT VARCHAR2);

    PROCEDURE sp_proces_confrm_cancel_cross(p_err_code OUT VARCHAR,
                p_orig_order_id IN VARCHAR,
                p_cancel_order_id IN VARCHAR,
              p_err_msg OUT VARCHAR2);

    PROCEDURE sp_proces_reject_cancel_cross(p_err_code OUT VARCHAR,
                p_orig_order_id IN VARCHAR,
                p_cancel_order_id IN VARCHAR,
              p_err_msg OUT VARCHAR2);

    PROCEDURE sp_chk_condition_cancel_cross(p_err_code OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_symbol IN VARCHAR,
                p_subside IN VARCHAR,
                p_exec_qtty IN NUMBER,
                p_exec_price IN NUMBER,
                p_rate_adv IN NUMBER,
                p_rate_tax IN NUMBER,
                p_rate_brk IN NUMBER,
                p_clear_day IN NUMBER,
              p_err_msg OUT VARCHAR2);

    PROCEDURE sp_get_quoteid(p_err_code OUT VARCHAR,
                p_confirm_number IN VARCHAR,
                f_quote_id_s OUT VARCHAR,
                f_quote_id_b OUT VARCHAR,
              p_err_msg OUT VARCHAR2);

    FUNCTION fn_get_amt_match_cross_order(p_err_code OUT VARCHAR,
                p_subside IN VARCHAR,
                p_exec_qtty IN NUMBER,
                p_exec_price IN NUMBER,
                p_rate_adv IN NUMBER,
                p_rate_tax IN NUMBER,
                p_rate_brk IN NUMBER,
                p_clear_day IN NUMBER,
              p_err_msg OUT VARCHAR2) RETURN NUMBER;

END CSPKS_FO_ORDER_CROSS;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_order_cross AS

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_sell_ord_id
     *      p_buy_ord_id
     *      p_quote_id
     * Description:
     */
    PROCEDURE sp_process_order_cross(p_err_code OUT VARCHAR,
              p_sell_ord_id OUT VARCHAR,
              p_buy_ord_id OUT VARCHAR,
              p_buy_acctno OUT VARCHAR,
              p_poolval OUT NUMBER,
              p_quote_id IN VARCHAR,
              p_clear_day IN NUMBER,
              p_err_msg OUT VARCHAR2)
    AS
        v_acctno                    QUOTES.ACCTNO%TYPE;               -- Side=B: v_acctno=Buyer; Side=S: v_acctno=Seller;
        v_side                      QUOTES.SIDE%TYPE;
        v_symbol                    QUOTES.SYMBOL%TYPE;
        v_userid                    QUOTES.USERID%TYPE;               -- Identifier of Customer who requests
        v_typecd                    QUOTES.TYPECD%TYPE;
        v_subtypecd                 QUOTES.SUBTYPECD%TYPE;
        v_qtty                      QUOTES.QTTY%TYPE;
        v_price                     QUOTES.PRICE%TYPE;
        v_refquoteid                QUOTES.REFQUOTEID%TYPE;
        v_crosstype                 CROSSINFO.CROSSTYPE%TYPE;         -- D: outside Company ; S: inside Company
        v_firm                      CROSSINFO.FIRM%TYPE;
        v_contra_acctno             CROSSINFO.ACCTNO%TYPE;            -- Side=B: v_contra_acctno=Seller; Side=S: v_contra_acctno=Buyer;
        v_orderid                   CROSSINFO.ORDERID%TYPE;           -- Identifier of Advertisement Order which Cross Order bases on
        v_text                      CROSSINFO.TEXT%TYPE;
        v_dealid                    ORDERS.DEALID%TYPE;               -- Only used for HSX
        v_custodycd                 ACCOUNTS.CUSTODYCD%TYPE;
        v_contra_custodycd          ACCOUNTS.CUSTODYCD%TYPE;
        v_cnt_contra_ord            NUMBER;
    BEGIN
      p_err_code :=0;
      p_err_msg:='sp_process_order_cross p_quote_id=>'||p_quote_id;
      -- Getting general information of request from QUOTES and CROSSINFO
      SELECT Q.ACCTNO, Q.SIDE, Q.SYMBOL, Q.USERID, Q.TYPECD, Q.SUBTYPECD, Q.QTTY, Q.PRICE, Q.REFQUOTEID, C.CROSSTYPE, C.FIRM, C.ACCTNO, C.ORDERID, C.TEXT
      INTO v_acctno, v_side, v_symbol, v_userid, v_typecd, v_subtypecd, v_qtty, v_price, v_refquoteid, v_crosstype, v_firm, v_contra_acctno, v_orderid, v_text
      FROM QUOTES Q
      INNER JOIN CROSSINFO C ON (Q.QUOTEID=C.QUOTEID)
      WHERE Q.QUOTEID=p_quote_id;

      /*
       * Editor: Trung.Nguyen
       * Date: 05-Jan-2016
       * Description: check the exists of contra order
       */
      SELECT CUSTODYCD INTO v_custodycd
      FROM ACCOUNTS WHERE ACCTNO=v_acctno;

      --ThanhNV 30.06.2016 sua kiem tra lenh doi ung theo thong tu 203
      cspks_fo_common.sp_check_reciprocal(p_err_code  => p_err_code,
                                          p_custodycd => v_custodycd,
                                          p_symbol    => v_symbol,
                                          p_err_msg   => p_err_msg,
                                          p_side      => v_side,
                                          p_subtypecd => v_subtypecd);
      IF (p_err_code <> '0') THEN
        p_err_code := '-95013';
        RETURN;
      END IF;



     --ThanhNV sua 30.06.2016 check them lenh thoa thuan mua cung thanh vien:
      IF v_crosstype='S' AND v_contra_acctno IS NOT NULL THEN
        BEGIN
            SELECT CUSTODYCD INTO v_contra_custodycd
            FROM ACCOUNTS WHERE ACCTNO=v_contra_acctno;
        EXCEPTION WHEN OTHERS THEN
            v_contra_custodycd:=NULL;
        END;
        IF  v_contra_custodycd IS NOT NULL THEN

               cspks_fo_common.sp_check_reciprocal(p_err_code  => p_err_code,
                                              p_custodycd => v_contra_custodycd,
                                              p_symbol    => v_symbol,
                                              p_err_msg   => p_err_msg,
                                              p_side      => 'B',   --Lenh mua
                                              p_subtypecd => v_subtypecd);
              IF (p_err_code <> '0') THEN
                p_err_code := '-95013';
                RETURN;
              END IF;
        END IF;
      END IF;


      -- In case, both buying side and selling side are inside Company
      IF (v_crosstype='S') THEN
        -- For selling side: sp_process_order_cross_sell
        -- And for buying side: sp_process_order_cross_buy
        IF (v_side='S') THEN
          --CSPKS_FO_ORDER_CROSS.sp_process_order_cross_sell(p_err_code,p_sell_ord_id,p_quote_id,v_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd);
          CSPKS_FO_ORDER_CROSS.sp_process_order_cross_buy(p_err_code,p_buy_ord_id,p_poolval,p_quote_id,v_contra_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd,p_clear_day,p_err_msg);
          p_buy_acctno := v_contra_acctno;
          IF (p_err_code='0') THEN
            --CSPKS_FO_ORDER_CROSS.sp_process_order_cross_buy(p_err_code,p_buy_ord_id,p_poolval,p_quote_id,v_contra_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd);
            CSPKS_FO_ORDER_CROSS.sp_process_order_cross_sell(p_err_code,p_sell_ord_id,p_quote_id,v_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd,p_clear_day,p_err_msg);
            IF(p_err_code!='0') THEN
              RETURN;
            END IF;
            SELECT DEALID INTO v_dealid FROM ORDERS WHERE ORDERID = p_sell_ord_id;
            UPDATE ORDERS SET DEALID = v_dealid WHERE ORDERID = p_buy_ord_id;
          END IF;
        ELSIF (v_side='B') THEN
          --CSPKS_FO_ORDER_CROSS.sp_process_order_cross_sell(p_err_code,p_sell_ord_id,p_quote_id,v_contra_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd);
          CSPKS_FO_ORDER_CROSS.sp_process_order_cross_buy(p_err_code,p_buy_ord_id,p_poolval,p_quote_id,v_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd,p_clear_day,p_err_msg);
          p_buy_acctno := v_acctno;
          IF (p_err_code='0') THEN
            --CSPKS_FO_ORDER_CROSS.sp_process_order_cross_buy(p_err_code,p_buy_ord_id,p_poolval,p_quote_id,v_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd);
            CSPKS_FO_ORDER_CROSS.sp_process_order_cross_sell(p_err_code,p_sell_ord_id,p_quote_id,v_contra_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd,p_clear_day,p_err_msg);
            IF(p_err_code!='0') THEN
              RETURN;
            END IF;
            SELECT DEALID INTO v_dealid FROM ORDERS WHERE ORDERID = p_sell_ord_id;
            UPDATE ORDERS SET DEALID = v_dealid WHERE ORDERID = p_buy_ord_id;
          END IF;
        END IF;
      -- In case, buying side or selling side is outside Company
      ELSIF (v_crosstype='D') THEN
        -- If selling side: sp_process_order_cross_sell
        -- Or if buying side: sp_process_order_cross_buy
        IF (v_side='S') THEN
          CSPKS_FO_ORDER_CROSS.sp_process_order_cross_sell(p_err_code,p_sell_ord_id,p_quote_id,v_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd,p_clear_day,p_err_msg);
        ELSIF (v_side='B') THEN
          CSPKS_FO_ORDER_CROSS.sp_process_order_cross_buy(p_err_code,p_buy_ord_id,p_poolval,p_quote_id,v_acctno,v_symbol,v_qtty,v_price,v_userid,v_typecd,v_subtypecd,p_clear_day,p_err_msg);
          -- Update confirmation code getting from HNX for buying order
          UPDATE ORDERS SET CONFIRMID=v_refquoteid WHERE ORDERID = p_buy_ord_id;
          p_buy_acctno := v_acctno;
        END IF;
      END IF;

      -- Update request status of QUOTES table
      CASE
        WHEN (p_err_code='0') THEN
          -- In case p_err_code returns zero
          IF (v_crosstype='S') THEN
            UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_quote_id;
          ELSIF (v_crosstype='D') AND (v_side='B') THEN
            UPDATE QUOTES SET STATUS=DECODE(v_typecd,'A','C','R','R',STATUS) WHERE REFQUOTEID=(SELECT REFQUOTEID FROM QUOTES WHERE QUOTEID=p_quote_id);
          END IF;
          --p_order_id := v_sell_ord_id;
        ELSE
          -- In case p_err_code returns error code, reverting all process and changing request status to R (Rejected)
          ROLLBACK;
          UPDATE QUOTES SET STATUS='R' WHERE QUOTEID=p_quote_id;
      END CASE;
    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_process_order_cross ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_order_cross;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_order_id:       identifier of selling order
     *      p_quote_id:       identifier of selling request
     *      p_acctno:         account number of seller
     *      p_symbol:         symbol for crossing
     *      p_qtty:           quantity of securities(i) that be crossed
     *      p_price:          price of securities(i) that be crossed
     *      p_userid:         identifier of seller
     *      p_typecd:
     *      p_subtypecd:
     * Description: Selling side of cross order that is processed as normal selling request. Should refer CSPKS_FO_ORDER_NEW.sp_process_order_sell for more detail
     */
    PROCEDURE sp_process_order_cross_sell(p_err_code OUT VARCHAR,
                p_order_id OUT VARCHAR,
                p_quote_id IN VARCHAR,
                p_acctno IN VARCHAR,
                p_symbol IN VARCHAR,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_userid IN VARCHAR,
                p_typecd IN VARCHAR,
                p_subtypecd IN VARCHAR,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
        v_trade               NUMBER;
        v_rate_brk            NUMBER;
        v_custodycd           ACCOUNTS.CUSTODYCD%TYPE;
        v_formulacd           ACCOUNTS.FORMULACD%TYPE;
        v_ratebrk_s           ACCOUNTS.RATE_BRK_S%TYPE;
        v_ratebrk_b           ACCOUNTS.RATE_BRK_B%TYPE;
        v_rate_tax            ACCOUNTS.RATE_TAX%TYPE;
        v_rate_adv            ACCOUNTS.RATE_ADV%TYPE;
        v_cficode             INSTRUMENTS.CFICODE%TYPE;
        v_sessionex           MARKETINFO.SESSIONEX%TYPE;
        v_exchange            MARKETINFO.EXCHANGE%TYPE;
        v_price_margin        ORDERS.PRICE_MARGIN%TYPE;
        v_price_asset         ORDERS.PRICE_ASSET%TYPE;
        v_side                ORDERS.SIDE%TYPE := 'S';
        v_status              ORDERS.STATUS%TYPE;
        v_substatus           ORDERS.SUBSTATUS%TYPE;
        v_root_orderid        ORDERS.ROOTORDERID%TYPE := NULL;
        v_dealid              ORDERS.DEALID%TYPE := NULL;
        v_txdate              SYSCONFIG.CFGVALUE%TYPE;
        v_currtime            TIMESTAMP;
        v_count               NUMBER;
        v_tradeEx             NUMBER;
    BEGIN
      p_err_msg:='sp_process_order_cross_sell p_quote_id=>'||p_quote_id;
      BEGIN
        execute immediate
          'select tt_sysdate from dual' into v_currtime;
      END;

      SELECT CFICODE INTO v_cficode FROM INSTRUMENTS WHERE SYMBOL=p_symbol;
      IF v_cficode = 'FF' THEN
        p_err_code := '-90022';
        RETURN;
      END IF;

      SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
      IF v_count < 1  THEN
        p_err_code := '-90024';
        RETURN;
      END IF;

      SELECT (TRADE - SELLINGQTTY) INTO v_trade FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;

      --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
      BEGIN
         SELECT -SELLINGQTTY INTO v_tradeEx FROM PORTFOLIOSEX WHERE ACCTNO = p_acctno and SYMBOL= p_symbol;
      EXCEPTION WHEN OTHERS THEN
         v_tradeEx:=0;
      END;

      v_trade := v_trade + v_tradeEx;


      IF (v_trade >= p_qtty) THEN
        p_err_code := '0';
        SELECT FORMULACD, CUSTODYCD, RATE_BRK_S, RATE_BRK_B, RATE_ADV, RATE_TAX
        INTO v_formulacd, v_custodycd, v_ratebrk_s, v_ratebrk_b, v_rate_adv, v_rate_tax
        FROM ACCOUNTS WHERE ACCTNO=p_acctno;

        IF v_cficode IN ('ES','CW','ETF') THEN        --MSBS-1852   1.5.2.6
            v_rate_brk := v_ratebrk_s;
        ELSE
            v_rate_brk := v_ratebrk_b;
        END IF;

        IF (v_formulacd = 'CASH') OR (v_formulacd = 'ADV') THEN
          v_price_margin := 0;
          v_price_asset := 0;
        END IF;

        SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY='TRADE_DATE';
        --SELECT M.SESSIONEX, M.EXCHANGE INTO v_sessionex, v_exchange FROM MARKETINFO M, INSTRUMENTS I WHERE I.SYMBOL=p_symbol AND M.EXCHANGE=I.EXCHANGE;
        SELECT M.SESSIONEX, M.EXCHANGE INTO v_sessionex, v_exchange FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
        CSPKS_FO_COMMON.sp_get_status(p_err_code, v_status, v_substatus, v_sessionex, p_subtypecd, v_exchange,p_err_msg);

        /*
         * Editor: Trung.Nguyen
         * Date: 21-Dec-2015
         */
        IF (v_sessionex = 'CROSS' OR v_sessionex = 'CNT' OR v_sessionex = 'L5M' OR v_sessionex = 'CLS' OR v_sessionex = 'OPN') THEN
          v_status := 'B';
          v_substatus := 'BB';
        ELSE
          v_status := 'N';
          v_substatus := 'NN';
        END IF;

        -- Generate Identifier of Order
        CSPKS_FO_COMMON.sp_get_orderid(p_err_code,p_order_id,p_err_msg);

        -- ROOTORDERID is only used  for HSX
        IF v_exchange ='HSX' THEN
          --v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
          v_dealid := CSPKS_FO_COMMON.fn_get_dealid();
        END IF;

        -- Adding selling quantity into SELLINGQTTY of PORTFOLIOS table
        UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY + p_qtty WHERE ACCTNO=p_acctno and SYMBOL=p_symbol;

        -- Append new order into ORDERS table
        INSERT INTO ORDERS (ORDERID, ORIGINORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, SUBSIDE, STATUS, SUBSTATUS,
                            TIME_CREATED, TIME_SEND, TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY,
                            ADMEND_QTTY, RATE_ADV, RATE_BRK, RATE_TAX, PRICE_MARGIN, PRICE_ASSET, ROOTORDERID, DEALID, FLAGORDER, LASTCHANGE, MARKED)
        VALUES (p_order_id, p_order_id, to_date(v_txdate,'dd-mm-yyyy'), 'B', v_sessionex, p_quote_id, p_userid, v_custodycd, p_acctno, p_symbol, v_side, 'NS', v_status, v_substatus,
                v_currtime, v_currtime, p_typecd, p_subtypecd, p_price, p_qtty, 0, 0, p_qtty, 0,
                0, v_rate_adv, v_rate_brk, v_rate_tax, v_price_margin, v_price_asset, v_root_orderid, v_dealid, 'C', v_currtime, p_clear_day);
      ELSE
        -- Account has not enough quantity of securities(i) for trading
        p_err_code := '-90007';
        RETURN;
      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_process_order_cross_sell '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_order_cross_sell;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_order_id:     identifier of buying order
     *      p_quote_id:     identifier of buying request
     *      p_acctno:         account number of buyer
     *      p_symbol:         symbol of crossing
     *      p_qtty:           quantity of securities(i) that be crossed
     *      p_price:          price of securities(i) that be crossed
     *      p_userid:         identifier of buyer
     *      p_typecd:
     *      p_subtypecd:
     * Description: Buying side of cross order that is processed as normal buying request. Should refer CSPKS_FO_ORDER_NEW.sp_process_order_buy for more detail
     */
    PROCEDURE sp_process_order_cross_buy(p_err_code OUT VARCHAR,
                p_order_id OUT VARCHAR,
                p_poolval OUT NUMBER,
                p_quote_id IN VARCHAR,
                p_acctno IN VARCHAR2,
                p_symbol IN VARCHAR2,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_userid IN VARCHAR2,
                p_typecd IN VARCHAR2,
                p_subtypecd IN VARCHAR2,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
        v_pp                    NUMBER;
        v_order_value           NUMBER;
        v_ratebrk               NUMBER;
        v_exchange              MARKETINFO.EXCHANGE%TYPE;
        v_sessionex             MARKETINFO.SESSIONEX%TYPE;
        v_custodycd             ACCOUNTS.CUSTODYCD%TYPE;
        v_formulacd             ACCOUNTS.FORMULACD%TYPE;
        v_ratebrk_s             ACCOUNTS.RATE_BRK_S%TYPE;
        v_ratebrk_b             ACCOUNTS.RATE_BRK_B%TYPE;
        v_bod_balance           ACCOUNTS.BOD_BALANCE%TYPE;
        v_bod_t0value           ACCOUNTS.BOD_T0VALUE%TYPE;
        v_bod_td                ACCOUNTS.BOD_TD%TYPE;
        v_bod_payable           ACCOUNTS.BOD_PAYABLE%TYPE;
        v_bod_debt              ACCOUNTS.BOD_DEBT%TYPE;
        v_bod_adv               ACCOUNTS.BOD_ADV%TYPE;
        v_calc_advbal           ACCOUNTS.CALC_ADVBAL%TYPE;
        v_calc_odramt           ACCOUNTS.CALC_ODRAMT%TYPE;
        v_bod_crlimit           ACCOUNTS.BOD_CRLIMIT%TYPE;
        v_rate_tax              ACCOUNTS.RATE_TAX%TYPE;
        v_rate_adv              ACCOUNTS.RATE_ADV%TYPE;
        v_basketid              ACCOUNTS.BASKETID%TYPE;
        v_poolid                ACCOUNTS.POOLID%TYPE;
        v_roomid                ACCOUNTS.ROOMID%TYPE;
        v_bod_debt_t0           ACCOUNTS.BOD_DEBT_T0%TYPE;
        v_bod_d_margin          ACCOUNTS.BOD_D_MARGIN%TYPE;
        v_rate_ub               ACCOUNTS.RATE_UB%TYPE;
        v_rate_buy              BASKETS.RATE_BUY%TYPE;
        v_rate_margin           BASKETS.RATE_MARGIN%TYPE;
        v_price_margin          BASKETS.PRICE_MARGIN%TYPE;
        v_price_asset           BASKETS.PRICE_ASSET%TYPE;
        v_side                  ORDERS.SIDE%TYPE := 'B';
        v_status                ORDERS.STATUS%TYPE;
        v_substatus             ORDERS.SUBSTATUS%TYPE;
        v_root_orderid          ORDERS.ROOTORDERID%TYPE := NULL;
        v_dealid                ORDERS.DEALID%TYPE := NULL;
        v_cficode               INSTRUMENTS.CFICODE%TYPE;
        v_txdate                SYSCONFIG.CFGVALUE%TYPE;
        v_banklink              VARCHAR(2);
        v_currtime              TIMESTAMP;
        v_count                 NUMBER;
        v_countNo               NUMBER;
        v_countBasket           NUMBER;
        v_count_bankaccord      NUMBER;
        v_bod_d_margin_ub       ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
        v_formulacd_rtn         NUMBER(20,2);
        v_firm                  varchar2(20);
        v_count_blacklist_ex number(20);
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_process_order_cross_buy p_quote_id=>'||p_quote_id;
      BEGIN
        execute immediate
          'select tt_sysdate from dual' into v_currtime;
      END;
      -- Get symbol information
      SELECT CFICODE INTO v_cficode
      FROM INSTRUMENTS
      WHERE SYMBOL=p_symbol;

      -- Get account information
      SELECT  FORMULACD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX,BOD_BALANCE,
              BOD_T0VALUE,BOD_TD,BOD_PAYABLE,BOD_DEBT,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB,
              BOD_ADV,CALC_ADVBAL,BOD_CRLIMIT,BASKETID,CALC_ODRAMT,POOLID,ROOMID,CUSTODYCD,BANKLINK,RATE_UB
      INTO    v_formulacd,v_ratebrk_s,v_ratebrk_b,v_rate_adv,v_rate_tax,v_bod_balance,
              v_bod_t0value,v_bod_td,v_bod_payable,v_bod_debt,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,
              v_bod_adv,v_calc_advbal,v_bod_crlimit,v_basketid,v_calc_odramt,v_poolid,v_roomid,v_custodycd,v_banklink,v_rate_ub
      FROM ACCOUNTS WHERE ACCTNO=p_acctno;


    /*ThanhNV sua hotfix neu Blaclist ma co T0 thi ko cho dat lenh*/
    SELECT COUNT(1) INTO v_count FROM BASKETS WHERE BASKETID='BLACK_LIST' AND SYMBOL=p_symbol;

    IF v_count > 0 AND v_bod_t0value > 0 THEN

      --ThanhNV sua 29.9 kiem tra tk co phai loai tru voi ma BLACKLIST ko, neu loai tru thi ko check.
      SELECT count(*) INTO v_count_blacklist_ex FROM BASKETS
      WHERE instr(basketid,'BLACK_LIST') > 0 AND instr(basketid,p_acctno)>0 AND SYMBOL=p_symbol;

      --Kiem tra firm, neu la luu ky nuoc ngoai thi ko check:
      SELECT cfgvalue INTO v_Firm FROM sysconfig WHERE  cfgkey ='FIRM';
      IF  substr(v_custodycd,1,3) =  v_Firm AND v_count_blacklist_ex =0  THEN
            p_err_code := '-95035';
            RETURN;
      END IF;
    END IF;


      /*
    tiendt added for buy amount
    date: 2015-08-24
    */
    v_calc_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
    /*end*/

      SELECT COUNT(1) INTO v_count FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO=p_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=p_symbol;
      IF v_count > 0 THEN
        SELECT B.RATE_BUY, B.PRICE_MARGIN, B.PRICE_ASSET INTO v_rate_buy, v_price_margin, v_price_asset
        FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO=p_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=p_symbol;
      END IF;

      IF v_cficode IN ('ES','CW','ETF') THEN        --MSBS-1852   1.5.2.6
        v_ratebrk := v_ratebrk_s;
      ELSE
        v_ratebrk := v_ratebrk_b;
      END IF;

      IF v_formulacd = 'CASH' OR v_formulacd = 'ADV' THEN
        v_price_margin := 0;
        v_price_asset := 0;
      ELSE
        -- GET margin information
        SELECT COUNT(1) INTO v_countBasket FROM BASKETS WHERE BASKETID=v_basketid AND SYMBOL=p_symbol;
        IF (v_countBasket = 0) THEN
          v_rate_margin := 0;
          v_price_margin := 0;
        ELSE
          SELECT RATE_MARGIN, PRICE_MARGIN INTO v_rate_margin, v_price_margin FROM BASKETS
          WHERE BASKETID=v_basketid AND SYMBOL=p_symbol;
        END IF;
      END IF;

      -- Validate purchase power
      -- Calculate order buy value
      v_order_value := p_qtty * p_price * (1 + v_ratebrk/100);
      --dbms_output.put_line('ORDER VALUE: ' || v_order_value);

      -- Get purchase power: v_pp
      CSPKS_FO_COMMON.sp_get_pp(p_err_code,
            v_pp,
            p_acctno,
            v_formulacd,
            v_bod_balance,
            v_bod_t0value,
            v_bod_td,
            v_bod_payable,
            v_bod_debt,
            v_ratebrk,
            v_bod_adv,
            v_calc_advbal,
            v_bod_crlimit,
            v_rate_margin,
            v_price_margin,
            p_price,
            v_basketid,
            v_calc_odramt,
            v_roomid,
            v_rate_ub,
            p_symbol,p_err_msg
            );
      --dbms_output.put_line('V_PP : ' || v_pp);

      IF v_order_value > v_pp THEN
        IF v_banklink = 'B' THEN
          p_poolval := v_order_value - v_pp;
          SELECT COUNT(1) INTO v_count_bankaccord FROM BANKACCORDERS WHERE QUOTEID = p_quote_id;
          IF v_count_bankaccord > 0 THEN
            p_err_code := '-95036';
          ELSE
            INSERT INTO BANKACCORDERS(QUOTEID,ACCTNO,AMOUNT,STATUS,LASTCHANGE)
            VALUES(p_quote_id,p_acctno,p_poolval,'N', v_currtime);
            COMMIT;
            p_err_code := '-95555';
            p_order_id := p_quote_id;
            UPDATE QUOTES SET STATUS='B' WHERE QUOTEID=p_quote_id; --for show wait order on interface
            RETURN;
          END IF;
        END IF;
        p_err_code := '-90016';
        UPDATE QUOTES SET STATUS='R' WHERE QUOTEID = p_quote_id;
        RETURN;
      END IF;

      -- Check pool
      IF (v_poolid is not null) AND (v_formulacd != 'ADV')  AND (v_formulacd != 'CASH') THEN
        p_poolval := CSPKS_FO_POOLROOM.fn_get_using_pool(p_err_code,
                        v_order_value,
                        v_bod_balance,
                        v_bod_adv+v_calc_advbal,
                        v_bod_payable,
                        v_bod_debt,
                        v_calc_odramt,
                        v_bod_td,
                        v_bod_t0value,p_err_msg);
        --dbms_output.put_line('V_POOLVAL==========:' || p_poolval );

        IF p_poolval > 0 THEN
          CSPKS_FO_POOLROOM.sp_process_checkpool(p_err_code, v_poolid, p_poolval,p_err_msg);
          IF p_err_code != '0' THEN
            RETURN;
          END IF;
        END IF;
      END IF;

      --Check room
      IF (v_roomid IS NOT NULL) AND (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
        IF p_poolval > 0 THEN
          CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,
                p_acctno,
                v_roomid,
                v_order_value,
                v_bod_payable,
                v_bod_debt_t0,
                v_bod_d_margin,
                v_bod_d_margin_ub,
                v_calc_odramt,
                0,
                v_bod_balance,
                v_bod_adv,
                v_calc_advbal,
                v_bod_td,
                0,
                p_symbol,
                p_qtty,
                v_bod_t0value,p_err_msg);

          IF p_err_code != '0' THEN
            RETURN;
          END IF;
        END IF;
      END IF;

      SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY='TRADE_DATE';
      SELECT M.SESSIONEX, M.EXCHANGE INTO v_sessionex, v_exchange FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= p_symbol AND M.EXCHANGE=I.BOARD;
      --SELECT I.EXCHANGE, M.SESSIONEX INTO v_exchange, v_sessionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL=p_symbol AND M.EXCHANGE=I.EXCHANGE;
      --SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL = p_symbol;
      CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sessionex,p_subtypecd,v_exchange,p_err_msg);

      /*
       * Editor: Trung.Nguyen
       * Date: 21-Dec-2015
       */
      IF (v_sessionex = 'CROSS' OR v_sessionex = 'CNT' OR v_sessionex = 'L5M' OR v_sessionex = 'CLS' OR v_sessionex = 'OPN') THEN
        v_status := 'B';
        v_substatus := 'BB';
      ELSE
        v_status := 'N';
        v_substatus := 'NN';
      END IF;

      -- Generate Identifier of Order
      CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_order_id,p_err_msg);

      -- ROOTORDERID is only used for HSX
      IF v_exchange ='HSX' THEN
        v_root_orderid := CSPKS_FO_COMMON.fn_get_root_orderid();
        v_dealid := CSPKS_FO_COMMON.fn_get_dealid();
      END IF;

      -- Save order
      INSERT INTO ORDERS (ORDERID, ORIGINORDERID, TXDATE, NORB, SESSIONEX, QUOTEID,
                          CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,ROOTORDERID, DEALID, FLAGORDER,
                          SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND, TYPECD, SUBTYPECD,
                          RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                          QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE, MARKED)
      VALUES (p_order_id, p_order_id, to_date(v_txdate,'dd-mm-yyyy'), 'B', v_sessionex, p_quote_id,
              null, p_userid, v_custodycd, p_acctno, p_symbol,v_root_orderid, v_dealid, 'C',
              v_side, 'NB', v_status, v_substatus, v_currtime, v_currtime, p_typecd, p_subtypecd,
              v_rate_adv, v_ratebrk, v_rate_tax, v_rate_buy, v_price_margin, v_price_asset,
              p_price, p_qtty, 0, 0, p_qtty, 0, 0, v_currtime, p_clear_day);

      SELECT COUNT(1) INTO v_countNo FROM PORTFOLIOS WHERE ACCTNO = p_acctno AND SYMBOL = p_symbol;
      --dbms_output.put_line('11111111 : ' || v_countNo);
      IF (v_countNo = 0) THEN
        -- In case, securities(i) has not been in portfolios


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

        INSERT INTO PORTFOLIOS(ACCTNO,SYMBOL,BUYINGQTTY, BOD_RTN) VALUES(p_acctno,p_symbol,p_qtty,v_formulacd_rtn);
        --DBMS_OUTPUT.PUT_LINE('v_countNo: '||v_countNo);
      ELSE
        -- In case, securities(i) has been in portfolios
        UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY + p_qtty
        WHERE ACCTNO = p_acctno AND SYMBOL = p_symbol;
        --DBMS_OUTPUT.PUT_LINE('v_countNo: '||v_countNo);
      END IF;

      -- Update CALC_ODRAMT of ACCOUNTS table
      --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT + v_order_value WHERE ACCTNO = p_acctno;

      IF p_poolval > 0 THEN
        -- Mark Pool
        IF (v_poolid IS NOT NULL)  AND (v_formulacd != 'ADV')  AND (v_formulacd != 'CASH') THEN
          CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code,p_order_id,'B',p_symbol,p_acctno,v_poolid,p_poolval,0,null,p_err_msg);
          --DBMS_OUTPUT.PUT_LINE('Marking Pool.....................');
        END IF;

        -- Mark Room
        IF (v_roomid IS NOT NULL) AND (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
          v_calc_odramt := v_calc_odramt + v_order_value;
          --DBMS_OUTPUT.PUT_LINE('Marking Room.....................');
--          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code,
--                p_acctno,
--                v_bod_payable,
--                v_bod_debt,
--                v_calc_odramt,
--                0,
--                v_bod_balance,
--                v_bod_adv,
--                v_calc_advbal,
--                v_bod_td,
--                p_order_id,
--                v_side);

          CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,
                p_acctno,
                v_roomid,
                v_bod_payable,
                v_bod_debt_t0,
                v_bod_d_margin,
                v_bod_d_margin_ub,
                v_calc_odramt,
                0,
                v_bod_balance,
                v_bod_adv,
                v_calc_advbal,
                v_bod_td,
                v_bod_t0value,
                p_order_id,
                v_side,
                p_symbol,
                p_qtty,p_err_msg);

        END IF;
      END IF;
   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_process_order_cross_buy '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_order_cross_buy;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_crossid:            identifier of cross order which HNX generated and forwarded to all
     *      p_sell_clordid:     identifier of request which seller sent to HNX
     *      p_symbol:               symbol of securities
     *      p_qtty:                 quantity of securities
     *      p_price:                price of securities
     *      p_target_comp_id:   identifier of company that gets request from HNX
     *      p_buy_party_id:     identifier of buying side
     *      p_sell_party_id:    identifier of selling side
     *      p_buy_acctno:         account number of buyer
     *      p_sell_acctno:      account number of seller
     *      p_adv_id:               identifier of advertisement order in that case cross order bases on
     * Description:
     */
    /*PROCEDURE sp_proces_msg_forward_cross(p_err_code in OUT VARCHAR,
                p_crossid IN VARCHAR,
                p_sell_clordid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_qtty IN NUMBER,
                p_price IN NUMBER,
                p_target_comp_id IN VARCHAR,
                p_buy_party_id IN VARCHAR,
                p_sell_party_id IN VARCHAR,
                p_buy_acctno IN VARCHAR,
                p_sell_acctno IN VARCHAR,
                p_adv_id IN VARCHAR)
    AS
        v_quote_id      QUOTES.QUOTEID%TYPE;
    BEGIN
      p_err_code := '0';
      IF ((p_target_comp_id = p_buy_party_id) AND (p_target_comp_id = p_sell_party_id)) THEN
        p_err_code := '-90025';
      ELSIF(p_target_comp_id = p_sell_party_id) THEN
        -- Confirm
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_sell_clordid,p_crossid,'A',NULL);
      ELSIF(p_target_comp_id = p_buy_party_id) THEN
        -- Generate identifier of quote
        CSPKS_FO_COMMON.sp_get_quoteid(p_err_code,v_quote_id);

        -- Append request into QUOTES table
        INSERT INTO QUOTES(QUOTEID, REQUESTID, CREATEDDT, EXPIREDDT, USERID, CLASSCD, SUBCLASS, VIA, STATUS, SUBSTATUS, TIME_QUOTE,
                            TIME_SEND, TYPECD, SUBTYPECD, SIDE, REFQUOTEID, SYMBOL, QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND,
                            DISTRIBUTECD, ACCTNO, PRICE, PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
        VALUES(v_quote_id, NULL, NULL, NULL, NULL, 'DBO', 'CCO', 'F', 'P', 'P', NULL,
              NULL, 'LO', 'LO', 'B', p_crossid, p_symbol, p_qtty, 0, 0, 0, 0,
              'A', p_buy_acctno, p_price, 0, 0, 0, 0, 0, 0, SYSDATE);

        -- Append contract side into CROSSINFO table
        INSERT INTO CROSSINFO(QUOTEID, CROSSTYPE, FIRM, TRADERID, ACCTNO, ORDERID, TEXT)
        VALUES(v_quote_id, 'D', p_sell_party_id, NULL, p_sell_acctno, p_adv_id, NULL);
      END IF;

      EXCEPTION
        WHEN OTHERS THEN p_err_code := '-90025';
    END sp_proces_msg_forward_cross;
    */

    PROCEDURE sp_proces_msg_forward_cross(p_err_code OUT VARCHAR,
              p_crossid IN VARCHAR,
              p_symbol IN VARCHAR,
              p_qtty IN NUMBER,
              p_price IN NUMBER,
              p_side IN VARCHAR,
              p_sell_party_id IN VARCHAR,
              p_buy_acctno IN VARCHAR,
              p_sell_acctno IN VARCHAR,
              p_adv_id IN VARCHAR,
              p_err_msg OUT VARCHAR2)
    AS
        v_quote_id      QUOTES.QUOTEID%TYPE;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_msg_forward_cross p_crossid=>'||p_crossid;

      -- Generate identifier of quote
      CSPKS_FO_COMMON.sp_get_quoteid(p_err_code,v_quote_id,p_err_msg);

      -- Append request into QUOTES table
      INSERT INTO QUOTES(QUOTEID, REQUESTID, CREATEDDT, EXPIREDDT, USERID, CLASSCD, SUBCLASS, VIA, STATUS, SUBSTATUS, TIME_QUOTE,
                      TIME_SEND, TYPECD, SUBTYPECD, SIDE, REFQUOTEID, SYMBOL, QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND,
                      DISTRIBUTECD, ACCTNO, PRICE, PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
      VALUES(v_quote_id, v_quote_id, NULL, NULL, NULL, 'DBO', 'CCO', 'F', 'P', 'P', NULL,
            NULL, 'LO', 'LO', p_side, p_crossid, p_symbol, p_qtty, 0, 0, 0, 0,
            'A', p_buy_acctno, p_price, 0, 0, 0, 0, 0, 0, SYSDATE);

      -- Append contract side into CROSSINFO table
      INSERT INTO CROSSINFO(QUOTEID, CROSSTYPE, FIRM, TRADERID, ACCTNO, ORDERID, TEXT)
      VALUES(v_quote_id, 'D', p_sell_party_id, NULL, p_sell_acctno, p_adv_id, NULL);

      EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:= 'sp_proces_msg_forward_cross '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_msg_forward_cross;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_sell_ord_id:            identifier of selling side for cancel cross
     *      p_buy_ord_id:               identifier of buying side for cancel cross
     *      p_cancel_order_id:      identifier of original order that is cancelled
     *      p_userid:                     identifier of user sent request
     *      p_quote_id:                 identifier of cancel request
     * Description:
     */
    PROCEDURE sp_proces_cancel_cross_order(p_err_code OUT VARCHAR,
              p_sell_ord_id OUT VARCHAR,
              p_buy_ord_id OUT VARCHAR,
              p_cancel_order_id IN VARCHAR,
              p_userid IN VARCHAR,
              p_quote_id IN VARCHAR,
              p_err_msg OUT VARCHAR2)
    AS
      ord_recd                    ORDERS%ROWTYPE;
      ord_contra_recd           ORDERS%ROWTYPE;
      v_sell_root_ordid     ORDERS.ROOTORDERID%TYPE;
      v_buy_root_ordid      ORDERS.ROOTORDERID%TYPE;
      v_sell_dealid             ORDERS.DEALID%TYPE;
      v_buy_dealid              ORDERS.DEALID%TYPE;
      v_typecd                    QUOTES.TYPECD%TYPE;
      v_exchange                    INSTRUMENTS.EXCHANGE%TYPE;
      v_matched_amt             NUMBER;
      v_currtime                    TIMESTAMP;
      v_count                         NUMBER;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_cancel_cross_order p_cancel_order_id=>'||p_cancel_order_id;
      BEGIN
        execute immediate
          'select tt_sysdate from dual' into v_currtime;
      END;

      -- Query original information of cross order base on the cancel identifier (p_cancel_order_id)
      --    1. p_cancel_order_id identifies selling order or buying order of the original cross request in case the selling side and buying side those are inside the company
      --    2. p_cancel_order_id must be selling order in case the buying side that is outside the company
      --    3. p_cancel_order_id must be buying side in case the selling order that is outside the company
      SELECT * INTO ord_recd FROM ORDERS WHERE ORDERID = p_cancel_order_id;

      -- Get exchange name base on symbol
      SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL = ord_recd.SYMBOL;

      -- In case the cross order was dealt (ORDERS.QUOTE_QTTY = ORDERS.EXEC_QTTY)
      IF ((ord_recd.SUBSIDE = 'NS' OR ord_recd.SUBSIDE = 'AS') AND (ord_recd.QUOTE_QTTY = ord_recd.EXEC_QTTY)) THEN
        /*
        sp_chk_condition_cancel_cross(p_err_code, ord_recd.ACCTNO, ord_recd.SYMBOL, ord_recd.SUBSIDE, ord_recd.EXEC_QTTY, ord_recd.QUOTE_PRICE, ord_recd.RATE_ADV, ord_recd.RATE_TAX, ord_recd.RATE_BRK);
        IF (p_err_code != '0') THEN
          RETURN;
        END IF;
        */
        -- Generate Identifier of Order
        CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_sell_ord_id,p_err_msg);
        -- ROOTORDERID is only used for HSX
        IF v_exchange ='HSX' THEN
          v_sell_root_ordid := CSPKS_FO_COMMON.fn_get_root_orderid();
          v_sell_dealid := CSPKS_FO_COMMON.fn_get_dealid();
        END IF;

        -- Hold the matched amount of selling side (including fee and tax) of original cross request
        v_matched_amt := fn_get_amt_match_cross_order(p_err_code, ord_recd.SUBSIDE, ord_recd.EXEC_QTTY, ord_recd.QUOTE_PRICE, ord_recd.RATE_ADV, ord_recd.RATE_TAX, ord_recd.RATE_BRK, ord_recd.MARKED,p_err_msg);
        UPDATE ACCOUNTS SET CALC_ADVBAL = CALC_ADVBAL - v_matched_amt WHERE ACCTNO = ord_recd.ACCTNO;

        -- Save cancel selling order of cross request into ORDERS
        INSERT INTO ORDERS (ORDERID, ORIGINORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,
                            REFORDERID, ROOTORDERID, DEALID, FLAGORDER, SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED,
                            TIME_SEND, TYPECD, SUBTYPECD, RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                            QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE)
        VALUES (p_sell_ord_id, ord_recd.ORIGINORDERID, ord_recd.TXDATE, ord_recd.NORB, ord_recd.SESSIONEX, p_quote_id, ord_recd.CONFIRMID, ord_recd.USERID, ord_recd.CUSTODYCD, ord_recd.ACCTNO, ord_recd.SYMBOL,
                ord_recd.ORDERID, DECODE(v_exchange,'HSX',v_sell_root_ordid,ord_recd.ROOTORDERID), v_sell_dealid, ord_recd.FLAGORDER, 'O', 'CS', 'B', 'BB', v_currtime,
                v_currtime, ord_recd.TYPECD, ord_recd.SUBTYPECD, ord_recd.RATE_ADV, ord_recd.RATE_BRK, ord_recd.RATE_TAX, ord_recd.RATE_BUY, ord_recd.PRICE_MARGIN, ord_recd.PRICE_ASSET,
                ord_recd.QUOTE_PRICE, ord_recd.QUOTE_QTTY, 0, 0, 0, 0, 0, v_currtime);
        -- Update STATUS of original cross selling order
        UPDATE ORDERS SET STATUS='U', SUBSTATUS='U1' WHERE ORDERID = p_cancel_order_id;
        -- Update status of QUOTES
        UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_quote_id;
      ELSIF ((ord_recd.SUBSIDE = 'NB' OR ord_recd.SUBSIDE = 'AB') AND (ord_recd.QUOTE_QTTY = ord_recd.EXEC_QTTY)) THEN
        /*
        sp_chk_condition_cancel_cross(p_err_code, ord_recd.ACCTNO, ord_recd.SYMBOL, ord_recd.SUBSIDE, ord_recd.EXEC_QTTY, ord_recd.QUOTE_PRICE, ord_recd.RATE_ADV, ord_recd.RATE_TAX, ord_recd.RATE_BRK);
        IF (p_err_code != '0') THEN
          RETURN;
        END IF;
        */
        -- Generate Identifier of Order
        CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_buy_ord_id,p_err_msg);
        -- ROOTORDERID is only used for HSX
        IF v_exchange ='HSX' THEN
          v_buy_root_ordid := CSPKS_FO_COMMON.fn_get_root_orderid();
          v_buy_dealid := CSPKS_FO_COMMON.fn_get_dealid();
        END IF;

        -- Save cancel buying order of cross request into ORDERS
        INSERT INTO ORDERS (ORDERID, ORIGINORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,
                            REFORDERID, ROOTORDERID, DEALID, FLAGORDER, SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED,
                            TIME_SEND, TYPECD, SUBTYPECD, RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                            QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE)
        VALUES (p_buy_ord_id, ord_recd.ORIGINORDERID, ord_recd.TXDATE, ord_recd.NORB, ord_recd.SESSIONEX, p_quote_id, ord_recd.CONFIRMID, ord_recd.USERID, ord_recd.CUSTODYCD, ord_recd.ACCTNO, ord_recd.SYMBOL,
                ord_recd.ORDERID, DECODE(v_exchange,'HSX',v_buy_root_ordid,ord_recd.ROOTORDERID), v_buy_dealid, ord_recd.FLAGORDER, 'O', 'CB', 'B', 'BB', v_currtime,
                v_currtime, ord_recd.TYPECD, ord_recd.SUBTYPECD, ord_recd.RATE_ADV, ord_recd.RATE_BRK, ord_recd.RATE_TAX, ord_recd.RATE_BUY, ord_recd.PRICE_MARGIN, ord_recd.PRICE_ASSET,
                ord_recd.QUOTE_PRICE, ord_recd.QUOTE_QTTY, 0, 0, 0, 0, 0, v_currtime);
        -- Update STATUS of original cross buying order
        SELECT TYPECD INTO v_typecd FROM QUOTES WHERE QUOTEID=p_quote_id;
        IF (v_typecd='A') THEN
          UPDATE ORDERS SET STATUS='U', SUBSTATUS='U5' WHERE ORDERID = p_cancel_order_id;
        ELSIF (v_typecd='R') THEN
          UPDATE ORDERS SET STATUS='U', SUBSTATUS='U6' WHERE ORDERID = p_cancel_order_id;
          UPDATE ORDERS SET STATUS='U', SUBSTATUS='U6' WHERE QUOTEID = ord_recd.QUOTEID AND ORDERID != p_cancel_order_id;
        END IF;
        -- Update status of QUOTES
        UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_quote_id;

      -- In case the cross order has not dealt yet (ORDERS.QUOTE_QTTY = ORDERS.REMAIN_QTTY)
      ELSIF ((ord_recd.SUBSIDE = 'NS' OR ord_recd.SUBSIDE = 'AS') AND (ord_recd.QUOTE_QTTY = ord_recd.REMAIN_QTTY)) THEN
        -- In case the selling side and buying side those are inside the company, query order information of agreement side
        SELECT COUNT(ORDERID) INTO v_count FROM ORDERS WHERE ORDERID != p_cancel_order_id AND QUOTEID = ord_recd.QUOTEID;
        IF (v_count = 1) THEN
          SELECT * INTO ord_contra_recd FROM ORDERS WHERE ORDERID != p_cancel_order_id AND QUOTEID = ord_recd.QUOTEID;
        END IF;

        -- Generate Identifier of Order
        CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_sell_ord_id,p_err_msg);
        -- ROOTORDERID is only used for HSX
        IF v_exchange ='HSX' THEN
          v_sell_root_ordid := CSPKS_FO_COMMON.fn_get_root_orderid();
          v_sell_dealid := CSPKS_FO_COMMON.fn_get_dealid();
        END IF;

        -- Append cancel selling order of cross request into ORDERS
        INSERT INTO ORDERS (ORDERID, ORIGINORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,
                            REFORDERID, ROOTORDERID, DEALID, FLAGORDER, SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED,
                            TIME_SEND, TYPECD, SUBTYPECD, RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                            QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE)
        VALUES (p_sell_ord_id, ord_recd.ORIGINORDERID, ord_recd.TXDATE, ord_recd.NORB, ord_recd.SESSIONEX, p_quote_id, ord_recd.CONFIRMID, ord_recd.USERID, ord_recd.CUSTODYCD, ord_recd.ACCTNO, ord_recd.SYMBOL,
                ord_recd.ORDERID, DECODE(v_exchange,'HSX',v_sell_root_ordid,ord_recd.ROOTORDERID), v_sell_dealid, ord_recd.FLAGORDER, 'O', 'CS', 'D', 'BB', v_currtime,
                v_currtime, ord_recd.TYPECD, ord_recd.SUBTYPECD, ord_recd.RATE_ADV, ord_recd.RATE_BRK, ord_recd.RATE_TAX, ord_recd.RATE_BUY, ord_recd.PRICE_MARGIN, ord_recd.PRICE_ASSET,
                ord_recd.QUOTE_PRICE, ord_recd.QUOTE_QTTY, 0, 0, ord_recd.REMAIN_QTTY, 0, 0, v_currtime);

        IF (ord_contra_recd.ORDERID IS NOT NULL) THEN
          /*
          sp_chk_condition_cancel_cross(p_err_code, ord_contra_recd.ACCTNO, ord_contra_recd.SYMBOL, ord_contra_recd.SUBSIDE, ord_contra_recd.EXEC_QTTY, ord_contra_recd.QUOTE_PRICE, ord_recd.RATE_ADV, ord_contra_recd.RATE_TAX, ord_contra_recd.RATE_BRK);
            IF (p_err_code != '0') THEN
            RETURN;
          END IF;
          */
          -- Generate Identifier of Order
          CSPKS_FO_COMMON.sp_get_orderid(p_err_code, p_buy_ord_id,p_err_msg);
          -- ROOTORDERID is only used for HSX
          IF v_exchange ='HSX' THEN
              v_buy_root_ordid := CSPKS_FO_COMMON.fn_get_root_orderid();
              v_buy_dealid := CSPKS_FO_COMMON.fn_get_dealid();
          END IF;

          -- Append cancel buying order of cross request into ORDERS
          INSERT INTO ORDERS (ORDERID, ORIGINORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, CONFIRMID, USERID, CUSTODYCD, ACCTNO, SYMBOL,
                              REFORDERID, ROOTORDERID, DEALID, FLAGORDER, SIDE, SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED,
                              TIME_SEND, TYPECD, SUBTYPECD, RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET,
                              QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT, EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY, LASTCHANGE)
          VALUES (p_buy_ord_id, ord_contra_recd.ORIGINORDERID,ord_contra_recd.TXDATE, ord_contra_recd.NORB, ord_contra_recd.SESSIONEX, p_quote_id, ord_contra_recd.CONFIRMID, ord_contra_recd.USERID, ord_contra_recd.CUSTODYCD, ord_contra_recd.ACCTNO, ord_contra_recd.SYMBOL,
                  ord_contra_recd.ORDERID, DECODE(v_exchange,'HSX',v_buy_root_ordid,ord_recd.ROOTORDERID), v_buy_dealid, ord_contra_recd.FLAGORDER, 'O', 'CB', 'D', 'BB', v_currtime,
                  v_currtime, ord_contra_recd.TYPECD, ord_contra_recd.SUBTYPECD, ord_contra_recd.RATE_ADV, ord_contra_recd.RATE_BRK, ord_contra_recd.RATE_TAX, ord_contra_recd.RATE_BUY, ord_contra_recd.PRICE_MARGIN, ord_contra_recd.PRICE_ASSET,
                  ord_contra_recd.QUOTE_PRICE, ord_contra_recd.QUOTE_QTTY, 0, 0, ord_contra_recd.REMAIN_QTTY, 0, 0, v_currtime);
          -- Update status of QUOTES
          UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_quote_id;
        END IF;
      ELSE
        p_err_code := '-95023';
        RETURN;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_proces_cancel_cross_order ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_cancel_cross_order;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_orig_order_id:
     *      p_cancel_order_id:
     * Description:
     */
    PROCEDURE sp_proces_confrm_cancel_cross(p_err_code OUT VARCHAR,
                p_orig_order_id IN VARCHAR,
                p_cancel_order_id IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
        ord_rec                   ORDERS%ROWTYPE;
        acc_rec                   ACCOUNTS%ROWTYPE;
        v_matched_amt           NUMBER;
        v_currtime              TIMESTAMP;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_confrm_cancel_cross p_orig_order_id=>'||p_orig_order_id;

      BEGIN
        execute immediate
        'select tt_sysdate from dual' into v_currtime;
      END;
      -- Query information of original order that be cancelled
      SELECT * INTO ord_rec FROM ORDERS WHERE ORDERID = p_orig_order_id;

      IF (ord_rec.SUBSIDE = 'NS' OR ord_rec.SUBSIDE = 'AS') THEN
        -- Decrease cash advance of customer
        --UPDATE ACCOUNTS SET CALC_ADVBAL=CALC_ADVBAL-ord_rec.EXEC_AMT WHERE ACCTNO = ord_rec.ACCTNO;
        -- Decrease selling quantity and sending quantity of securities(i) of customer portfolios
        UPDATE PORTFOLIOS SET SELLINGQTTY=SELLINGQTTY-ord_rec.QUOTE_QTTY, BOD_ST3=BOD_ST3-ord_rec.EXEC_QTTY WHERE ACCTNO = ord_rec.ACCTNO and SYMBOL = ord_rec.SYMBOL;
        -- Update status of cancellation order
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DS', FLAGORDER='E', LASTCHANGE=v_currtime WHERE ORDERID = p_cancel_order_id;
        -- Update status of original order that was canceled
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DD', FLAGORDER='E', CANCEL_QTTY=QUOTE_QTTY, EXEC_QTTY=0, EXEC_AMT=0, LASTCHANGE=v_currtime WHERE ORDERID = p_orig_order_id;
      ELSIF (ord_rec.SUBSIDE = 'NB' OR ord_rec.SUBSIDE = 'AB') THEN
        -- Decrease amount for buying orders of customer
        v_matched_amt := CSPKS_FO_ORDER_CROSS.fn_get_amt_match_cross_order(p_err_code, ord_rec.SUBSIDE, ord_rec.EXEC_QTTY, ord_rec.QUOTE_PRICE, ord_rec.RATE_ADV, ord_rec.RATE_TAX, ord_rec.RATE_BRK, ord_rec.MARKED,p_err_msg);
        --UPDATE ACCOUNTS SET CALC_ODRAMT=CALC_ODRAMT-v_matched_amt WHERE ACCTNO = ord_rec.ACCTNO;
        -- Decrease buying quantity of securities(i) of customer portfolios
        UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-ord_rec.EXEC_QTTY, BOD_RT3=BOD_RT3-ord_rec.EXEC_QTTY WHERE ACCTNO = ord_rec.ACCTNO and SYMBOL = ord_rec.SYMBOL;
        -- Update status of cancellation order
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DS', FLAGORDER='E', LASTCHANGE=v_currtime WHERE ORDERID = p_cancel_order_id;
        -- Update status of original order that was canceled
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DD', FLAGORDER='E', CANCEL_QTTY=QUOTE_QTTY, EXEC_QTTY=0, EXEC_AMT=0, LASTCHANGE=v_currtime WHERE ORDERID = p_orig_order_id;
      ELSE
        p_err_code := 'ERA0025';
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
           p_err_code := 'ERA0025';
           p_err_msg:= 'sp_proces_confrm_cancel_cross '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_confrm_cancel_cross;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_orig_order_id:          identifier of original cross order
     *      p_cancel_order_id:      identifier of cross cancellation order
     * Description:
     */
    PROCEDURE sp_proces_reject_cancel_cross(p_err_code OUT VARCHAR,
                p_orig_order_id IN VARCHAR,
                p_cancel_order_id IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
        ord_rec                   ORDERS%ROWTYPE;
        acc_rec                   ACCOUNTS%ROWTYPE;
        v_matched_amt           NUMBER;
        v_currtime              TIMESTAMP;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_reject_cancel_cross p_orig_order_id=>'||p_orig_order_id;
      BEGIN
        execute immediate
        'select tt_sysdate from dual' into v_currtime;
      END;
      -- Query information of original order that be cancelled
      SELECT * INTO ord_rec FROM ORDERS WHERE ORDERID = p_orig_order_id;

      IF (ord_rec.SUBSIDE = 'NS' OR ord_rec.SUBSIDE = 'AS') THEN
        -- Reverse cash advance of customer
        v_matched_amt := fn_get_amt_match_cross_order(p_err_code, ord_rec.SUBSIDE, ord_rec.EXEC_QTTY, ord_rec.QUOTE_PRICE, ord_rec.RATE_ADV, ord_rec.RATE_TAX, ord_rec.RATE_BRK, ord_rec.MARKED,p_err_msg);
        --DBMS_OUTPUT.PUT_LINE('v_matched_amt: '||v_matched_amt);
        UPDATE ACCOUNTS SET CALC_ADVBAL=CALC_ADVBAL+v_matched_amt WHERE ACCTNO = ord_rec.ACCTNO;
        SELECT CALC_ADVBAL INTO v_matched_amt FROM ACCOUNTS WHERE ACCTNO = ord_rec.ACCTNO;
        --DBMS_OUTPUT.PUT_LINE('CALC_ADVBAL: '||v_matched_amt);
        -- Update status of cancellation order
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DN', FLAGORDER='E', LASTCHANGE=v_currtime WHERE ORDERID = p_cancel_order_id;
        -- Update status of original order that was cancelled
        UPDATE ORDERS SET STATUS='S', SUBSTATUS='SS', FLAGORDER='E', LASTCHANGE=v_currtime WHERE ORDERID = p_orig_order_id;
      ELSIF (ord_rec.SUBSIDE = 'NB' OR ord_rec.SUBSIDE = 'AB') THEN
        -- Update status of cancellation order
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DN', FLAGORDER='E', LASTCHANGE=v_currtime WHERE ORDERID = p_cancel_order_id;
        -- Update status of original order that was cancelled
        UPDATE ORDERS SET STATUS='S', SUBSTATUS='SS', FLAGORDER='E', LASTCHANGE=v_currtime WHERE ORDERID = p_orig_order_id;
      ELSE
        p_err_code := 'ERA0025';
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
               p_err_code := 'ERA0025';
               p_err_msg:= 'sp_proces_reject_cancel_cross '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_reject_cancel_cross;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_symbol:
     *      p_subside:
     *      p_exec_qtty:
     *      p_exec_price:
     *      p_rate_tax:
     *      p_rate_brk:
     * Description:
     */
    PROCEDURE sp_chk_condition_cancel_cross(p_err_code OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_symbol IN VARCHAR,
                p_subside IN VARCHAR,
                p_exec_qtty IN NUMBER,
                p_exec_price IN NUMBER,
                p_rate_adv IN NUMBER,
                p_rate_tax IN NUMBER,
                p_rate_brk IN NUMBER,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
        v_available_cash                NUMBER;
        v_fee                                 NUMBER;
        v_cash_advance                  NUMBER;
        v_available_qtty                NUMBER;
        v_available_qttyEX              NUMBER;
    BEGIN
      p_err_msg:='sp_chk_condition_cancel_cross p_acctno=>'||p_acctno;

      IF ((p_subside = 'NS') OR (p_subside = 'AS')) THEN
        -- For selling side, checking available cash of account
        SELECT BOD_BALANCE + BOD_ADV + CALC_ADVBAL + BOD_TD - BOD_PAYABLE - BOD_DEBT - CALC_ODRAMT
        INTO v_available_cash FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        -- Cash advance amount of selling side (including fee and tax) of cross order
        --v_cash_advance := p_exec_qtty * p_exec_price * (1 - (p_rate_tax/100) - (p_rate_brk/100));
        --v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_advance(p_exec_qtty, p_exec_price, p_rate_adv, p_rate_brk, p_rate_tax);
        v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_adv_cross_ord(p_exec_qtty, p_exec_price, p_rate_adv, p_rate_brk, p_rate_tax, p_clear_day);
        --v_cash_advance := p_exec_qtty * p_exec_price - v_fee;
        v_cash_advance := p_exec_qtty * p_exec_price * (1 - (p_rate_tax/100) - (p_rate_brk/100)) - v_fee;
        -- Allowing cancel cross once available cash is more than executed cross amount
        IF (v_available_cash >= v_cash_advance) THEN
          p_err_code := '0';
        ELSE
          p_err_code := '-90003';
        END IF;
      ELSIF ((p_subside = 'NB') OR (p_subside = 'AB')) THEN
        -- For buying side, checking available quantity of securities(i) in portfolios
        SELECT TRADE + RECEIVING + BOD_RT3 - SELLINGQTTY
        INTO v_available_qtty FROM PORTFOLIOS WHERE ACCTNO = p_acctno AND SYMBOL = p_symbol;

        --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
        BEGIN
           SELECT BOD_RT3 - SELLINGQTTY INTO v_available_qttyEx FROM PORTFOLIOSEX WHERE ACCTNO = p_acctno and SYMBOL= p_symbol;
        EXCEPTION WHEN OTHERS THEN
           v_available_qttyEx:=0;
        END;

        v_available_qtty := v_available_qtty + v_available_qttyEx;


        -- Allowing cancel cross once available quantity of securities(i) is more than executed cross quantity
        IF (v_available_qtty >= p_exec_qtty) THEN
          p_err_code := '0';
        ELSE
          p_err_code := '-90007';
        END IF;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
         p_err_code := '-90025';
         p_err_msg:= 'sp_chk_condition_cancel_cross '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_chk_condition_cancel_cross;


    PROCEDURE sp_get_quoteid(p_err_code OUT VARCHAR,
                p_confirm_number IN VARCHAR,
                f_quote_id_s OUT VARCHAR,
                f_quote_id_b OUT VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
      v_firm                VARCHAR(50);
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_get_quoteid p_confirm_number=>'||p_confirm_number;
      SELECT CFGVALUE INTO v_firm FROM SYSCONFIG WHERE CFGKEY = 'FIRM';

      SELECT quote.QUOTEID INTO f_quote_id_b
        FROM QUOTES quote, CROSSINFO cross_info
          WHERE quote.REFQUOTEID = p_confirm_number
            AND cross_info.QUOTEID = quote.QUOTEID
            AND cross_info.FIRM != v_firm
            AND quote.QUOTEID =
              (SELECT MAX(q.QUOTEID) FROM QUOTES q, CROSSINFO cf
              WHERE q.REFQUOTEID = p_confirm_number AND cf.QUOTEID = q.QUOTEID AND cf.FIRM != v_firm);

      SELECT quote.QUOTEID INTO f_quote_id_s
        FROM QUOTES quote, CROSSINFO cross_info
          WHERE quote.REFQUOTEID = p_confirm_number
            AND cross_info.QUOTEID = quote.QUOTEID
            AND cross_info.FIRM = v_firm
            AND quote.QUOTEID =
              (SELECT MAX(q.QUOTEID) FROM QUOTES q, CROSSINFO cf
              WHERE q.REFQUOTEID = p_confirm_number AND cf.QUOTEID = q.QUOTEID AND cf.FIRM = v_firm);

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_get_quoteid '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_quoteid;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_subside:
     *      p_exec_qtty:
     *      p_exec_price:
     *      p_rate_tax:
     *      p_rate_brk:
     * Description:
     */
    FUNCTION fn_get_amt_match_cross_order(p_err_code OUT VARCHAR,
                p_subside IN VARCHAR,
                p_exec_qtty IN NUMBER,
                p_exec_price IN NUMBER,
                p_rate_adv IN NUMBER,
                p_rate_tax IN NUMBER,
                p_rate_brk IN NUMBER,
                p_clear_day IN NUMBER,
                p_err_msg OUT VARCHAR2)
    RETURN NUMBER AS
        v_ord_amt           NUMBER := 0;
        v_fee                 NUMBER := 0;
    BEGIN
      p_err_code := '0';
      p_err_msg:='fn_get_amt_match_cross_order p_exec_qtty=>'||p_exec_qtty;
      IF (p_subside = 'NS' OR p_subside = 'AS') THEN
        --v_ord_amt := p_exec_qtty * p_exec_price * (1 - (p_rate_tax/100) - (p_rate_brk/100));
        --v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_advance(p_exec_qtty, p_exec_price, p_rate_adv, p_rate_brk, p_rate_tax);
        v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_adv_cross_ord(p_exec_qtty, p_exec_price, p_rate_adv, p_rate_brk, p_rate_tax, p_clear_day);
        v_ord_amt := p_exec_qtty * p_exec_price * (1 - (p_rate_tax/100) - (p_rate_brk/100)) - v_fee;
        /*dung.bui add code 12/11/20015*/
        v_ord_amt := TRUNC(v_ord_amt,2);
        /*end*/
      ELSIF (p_subside = 'NB' OR p_subside = 'AB') THEN
        v_ord_amt := p_exec_qtty * p_exec_price * (1 + (p_rate_brk/100));
        /*dung.bui add code 12/11/20015*/
        v_ord_amt := TRUNC(v_ord_amt,2);
        /*end*/
      ELSE
        p_err_code := '-90025';
      END IF;

      RETURN v_ord_amt;
    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='fn_get_amt_match_cross_order '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END fn_get_amt_match_cross_order;

END CSPKS_FO_ORDER_CROSS;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_CROSS
