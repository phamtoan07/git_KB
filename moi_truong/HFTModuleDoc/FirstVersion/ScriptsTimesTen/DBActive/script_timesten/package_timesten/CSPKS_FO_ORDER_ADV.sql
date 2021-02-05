CREATE OR REPLACE PACKAGE cspks_fo_order_adv AS

    PROCEDURE sp_process_advertisement_order(p_err_code OUT VARCHAR,
        p_adv_id IN VARCHAR,
        p_adv_ref_id IN VARCHAR,
        p_status IN VARCHAR,
        p_symbol IN VARCHAR,
        p_adv_side IN VARCHAR,
        p_qtty IN VARCHAR,
        p_price IN VARCHAR,
        p_member_id IN VARCHAR,
        p_text IN VARCHAR,
        p_err_msg OUT VARCHAR2);

END CSPKS_FO_ORDER_ADV;



/


CREATE OR REPLACE PACKAGE BODY cspks_fo_order_adv AS

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_adv_id:             identifier of advertisement order which HNX generated
     *      p_adv_ref_id:
     *      p_status:             status of advertisement order - New(N); Canceled(C); Dealt(D); Reverted(A); Expired(P)
     *      p_symbol:             symbol of securities for deal
     *      p_adv_side:       side of advertisement order - Sell(S); Buy(B)
     *      p_qtty:               quantity of securities for deal
     *      p_price:              price of securities for deal
     *      p_member_id:      identifier of securities company
     *      p_text:               phone number of customer that throws advertisement
     * Description:
     */
    PROCEDURE sp_process_advertisement_order(p_err_code OUT VARCHAR,
          p_adv_id IN VARCHAR,
          p_adv_ref_id IN VARCHAR,
          p_status IN VARCHAR,
          p_symbol IN VARCHAR,
          p_adv_side IN VARCHAR,
          p_qtty IN VARCHAR,
          p_price IN VARCHAR,
          p_member_id IN VARCHAR,
          p_text IN VARCHAR,
          p_err_msg OUT VARCHAR2)
    AS
      v_order_id        ADVORDERS.ORDERID%TYPE;
      v_txdate        SYSCONFIG.CFGVALUE%TYPE;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_process_advertisement_order p_adv_id=>'||p_adv_id;
      IF(p_status='N') THEN
        -- Generate Identifier of Order
        CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
        -- Get transaction date from SYSCONFIG
        SELECT CFGVALUE INTO v_txdate FROM SYSCONFIG WHERE CFGKEY='TRADE_DATE';
        -- Append new advertisement order into ADVORDERS table
        INSERT INTO ADVORDERS(ORDERID, REFORDERID, TXDATE, STATUS, SYMBOL, SIDE, QTTY, PRICE, MEMBERID, TEXT, LASTCHANGE, REFQUOTEID)
        VALUES(v_order_id, p_adv_id, TO_DATE(v_txdate,'dd-mm-yyyy'), p_status, p_symbol, p_adv_side, p_qtty, p_price, p_member_id, p_text, SYSDATE, p_adv_ref_id);
        -- Update status of advertisement order to 'F'
        UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=p_adv_ref_id;
      ELSIF (p_status='C') THEN
        -- Change status of advertisement order to canceled
        UPDATE ADVORDERS SET STATUS='D', LASTCHANGE=SYSDATE
        WHERE REFORDERID=p_adv_id OR REFORDERID=p_adv_ref_id;
      ELSIF (p_status='D') THEN
        -- Change status of advertisement order to dealt
        UPDATE ADVORDERS SET STATUS='E', LASTCHANGE=SYSDATE
        WHERE REFORDERID=p_adv_id;
      ELSIF (p_status='A') THEN
        -- Change status of advertisement order to reverted
        UPDATE ADVORDERS SET STATUS='N', LASTCHANGE=SYSDATE
        WHERE REFORDERID=p_adv_id;
      ELSE
        -- Change status of advertisement order to expired
        UPDATE ADVORDERS SET STATUS='P', LASTCHANGE=SYSDATE
        WHERE REFORDERID=p_adv_id;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_advertisement_order '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_advertisement_order;

END CSPKS_FO_ORDER_ADV;



/
