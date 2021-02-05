CREATE OR REPLACE PACKAGE cspks_fo_validation AS
    PROCEDURE sp_get_errnum_byname (p_err_code in OUT NUMBER,
                                f_err_name IN VARCHAR,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_price_cefl (p_err_code in OUT NUMBER,
                                f_symbol in VARCHAR,
                                f_price IN NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_ticksize (p_err_code in OUT NUMBER,
                                f_symbol in VARCHAR,
                                f_price IN NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_tradelot (p_err_code in OUT NUMBER,
                                f_symbol in VARCHAR,
                                f_qtty IN NUMBER,
            p_err_msg OUT VARCHAR2);


    PROCEDURE sp_validate_pp_sell(p_err_code in OUT NUMBER,
                                f_account IN VARCHAR,
                                f_side IN VARCHAR,
                                f_symbol IN VARCHAR,
                                f_qtty IN  NUMBER,
                                f_price IN  NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_debit_cash(p_err_code in OUT NUMBER,
                                f_account IN VARCHAR,
                                f_amount IN  NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_debit_instrument(p_err_code in OUT NUMBER,
                                f_account IN VARCHAR,
                                f_symbol IN VARCHAR,
                                f_qtty IN  NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_pool(p_err_code in OUT NUMBER,
                                f_policycd IN VARCHAR,
                                f_amount IN  NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_validate_room(p_err_code in OUT NUMBER,
                                f_policycd IN VARCHAR,
                                f_symbol IN VARCHAR,
                                f_qtty IN  NUMBER,
            p_err_msg OUT VARCHAR2);

    PROCEDURE sp_throw(f_err_code in NUMBER,
            p_err_msg OUT VARCHAR2);

  PROCEDURE sp_validate_amend_order(p_err_code in OUT VARCHAR,
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_exchange IN VARCHAR, --ma san
              p_side IN VARCHAR, --mua :B, ban :S
              p_session_index IN VARCHAR,
            p_err_msg OUT VARCHAR2
              );
  PROCEDURE sp_validate_cancel_order(p_err_code in OUT VARCHAR,
            p_edit_order_id IN VARCHAR, --so hieu lenh goc
            p_exchange IN VARCHAR, --ma san
            p_side IN VARCHAR, --mua :B, ban :S
            p_session_index IN VARCHAR,
            p_err_msg OUT VARCHAR2
            );

END CSPKS_FO_VALIDATION;



/


CREATE OR REPLACE PACKAGE BODY cspks_fo_validation AS
    PROCEDURE sp_get_errnum_byname (p_err_code in OUT NUMBER,
                                f_err_name IN VARCHAR,
            p_err_msg OUT VARCHAR2)
    AS
    BEGIN
        SELECT ERRNUM INTO p_err_code
        FROM DICERRORS WHERE ERRNAME=f_err_name;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1;   --undefined error
    END sp_get_errnum_byname;

    PROCEDURE sp_get_error_byname (p_err_code in OUT NUMBER,
                                p_err_content in OUT VARCHAR,
                                f_err_name IN VARCHAR,
            p_err_msg OUT VARCHAR2)
    AS
    BEGIN
        p_err_msg:='sp_get_error_byname f_err_name=>'||f_err_name;
        SELECT ERRNUM, ERRDESC INTO p_err_code, p_err_content
        FROM DICERRORS WHERE ERRNAME=f_err_name;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1;   --undefined error
            p_err_content := 'The new error code is not defined';
            p_err_msg:='sp_get_error_byname '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_error_byname;

    PROCEDURE sp_validate_price_cefl (p_err_code in OUT NUMBER,
                                f_symbol in VARCHAR,
                                f_price IN NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_refvalue  NUMBER;
        v_referr    VARCHAR2(260);
    BEGIN
        p_err_msg:='sp_validate_price_cefl f_symbol=>'||f_symbol;

        SELECT COUNT(1) INTO v_refvalue
        FROM INSTRUMENTS RF
        WHERE RF.SYMBOL=f_symbol AND RF.PRICE_FL<=f_price AND RF.PRICE_CE>=f_price;

        IF v_refvalue=0 THEN
            sp_get_error_byname(p_err_code, v_referr, 'INVALID_PRICE_CEFL',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1;
            p_err_msg:='sp_validate_price_cefl '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_price_cefl;

    PROCEDURE sp_validate_ticksize (p_err_code in OUT NUMBER,
                                f_symbol in VARCHAR,
                                f_price IN NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_refvalue  NUMBER;
        v_referr    VARCHAR2(260);
    BEGIN
        p_err_msg:='sp_validate_ticksize f_symbol=>'||f_symbol;

        SELECT MOD(f_price, RFVAL) INTO v_refvalue
        FROM
            (SELECT DISTINCT MS.REFTYPE, MS.TICKSIZE RFVAL, MS.FROMPRICE, MS.TOPRICE
            FROM TICKSIZE MS, INSTRUMENTS RF
            WHERE RF.SYMBOL=f_symbol AND MS.FROMPRICE<=f_price AND MS.TOPRICE>f_price
            AND ((MS.REFTYPE='C' AND MS.REFCODE=RF.EXCHANGE || '.' || RF.BOARD)
            OR (MS.REFTYPE='I' AND MS.REFCODE=RF.SYMBOL)) ORDER BY REFTYPE DESC)
        WHERE ROWNUM=1;
        IF v_refvalue>0 THEN
            sp_get_error_byname(p_err_code, v_referr, 'INVALID_TICKSIZE',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1;
            p_err_msg:='sp_validate_ticksize '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_ticksize;

    PROCEDURE sp_validate_tradelot (p_err_code in OUT NUMBER,
                                f_symbol in VARCHAR,
                                f_qtty IN NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_refvalue  NUMBER;
        v_referr    VARCHAR2(260);
    BEGIN
        p_err_msg:='sp_validate_tradelot f_symbol=>'||f_symbol;
        SELECT MOD(f_qtty, RFVAL) INTO v_refvalue
        FROM
            (SELECT DISTINCT MS.REFTYPE, MS.REFCODE, MS.REFNVAL RFVAL
            FROM DEFRULES MS, INSTRUMENTS RF
            WHERE MS.RULENAME = 'TRADELOT' AND RF.SYMBOL=f_symbol
            AND ((MS.REFTYPE='C' AND MS.REFCODE=RF.EXCHANGE || '.' || RF.BOARD)
            OR (MS.REFTYPE='I' AND MS.REFCODE=RF.SYMBOL)) ORDER BY REFTYPE DESC)
        WHERE ROWNUM=1;
        IF v_refvalue>0 THEN
            sp_get_error_byname(p_err_code, v_referr, 'INVALID_TRADELOT',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1;
            p_err_msg:='sp_validate_tradelot '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_tradelot;



    PROCEDURE sp_validate_pp_sell(p_err_code in OUT NUMBER,
                                f_account IN VARCHAR,
                                f_side IN VARCHAR,
                                f_symbol IN VARCHAR,
                                f_qtty IN  NUMBER,
                                f_price IN  NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_referr    VARCHAR2(260);
        v_bodqtty       NUMBER;
        v_odrqtty       NUMBER;
        v_powervalue    NUMBER;
    BEGIN
        p_err_msg:='sp_validate_pp_sell f_account=>'||f_account;
        --Get portfolio information
        SELECT NVL(TRADE,0)+NVL(MORTGAGE,0) INTO v_bodqtty
        FROM PORTFOLIOS WHERE ACCTNO=f_account AND SYMBOL=f_symbol;

        --Get sell orders information
        SELECT SUM(EXEC_QTTY + REMAIN_QTTY) INTO v_odrqtty
        FROM ORDERS WHERE SIDE='S' AND ACCTNO=f_account AND SYMBOL=f_symbol;
        v_odrqtty := nvl(v_odrqtty, 0);

        v_powervalue := v_bodqtty-v_odrqtty;

        --Return value
        IF v_powervalue<f_qtty THEN
            sp_get_error_byname(p_err_code, v_referr, 'PP_SELL_NOT_ENOUGH',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1; --undefined error
            p_err_msg:='sp_validate_pp_sell '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_pp_sell;


    PROCEDURE sp_validate_debit_cash(p_err_code in OUT NUMBER,
                                f_account IN VARCHAR,
                                f_amount IN  NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_referr    VARCHAR2(260);
        v_powervalue    NUMBER;
    BEGIN
        p_err_msg:='sp_validate_debit_cash f_account=>'||f_account;
        v_powervalue:=0;

        --Return value
        IF v_powervalue<0 THEN
            sp_get_error_byname(p_err_code, v_referr, 'AVLCASH_NOT_ENOUGH',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1; --undefined error
            p_err_msg:='sp_validate_debit_cash '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_debit_cash;


    PROCEDURE sp_validate_debit_instrument(p_err_code in OUT NUMBER,
                                f_account IN VARCHAR,
                                f_symbol IN VARCHAR,
                                f_qtty IN  NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_referr    VARCHAR2(260);
        v_powervalue    NUMBER;
    BEGIN
        v_powervalue:=0;
        p_err_msg:='sp_validate_debit_instrument p_order_id=>'||f_account;
        --Return value
        IF v_powervalue<0 THEN
            sp_get_error_byname(p_err_code, v_referr, 'AVLQTTY_NOT_ENOUGH',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1; --undefined error
            p_err_msg:='sp_validate_debit_instrument '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_debit_instrument;


    PROCEDURE sp_validate_pool(p_err_code in OUT NUMBER,
                                f_policycd IN VARCHAR,
                                f_amount IN  NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_referr    VARCHAR2(260);
        v_bodvalue  NUMBER;
        v_dailyvalue    NUMBER;
    BEGIN
        p_err_msg:='sp_validate_pool f_policycd=>'||f_policycd;
        --Get BOD granted value
        SELECT NVL(SUM(GRANTED-INUSED),0) INTO v_bodvalue
        FROM POOLROOM
        WHERE POLICYTYPE='P' AND POLICYCD=f_policycd;

        --Get daily value
        SELECT NVL(SUM(CASE WHEN DOC='D' THEN -NVL(POOLVAL,0) ELSE NVL(POOLVAL,0) END),0) INTO v_dailyvalue
        FROM ALLOCATION
        WHERE POLICYCD=f_policycd;

        --Return value
        IF v_bodvalue+v_dailyvalue<f_amount THEN
            sp_get_error_byname(p_err_code, v_referr, 'POOL_NOT_ENOUGH',p_err_msg);
        ELSE
            p_err_code:=0;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1; --undefined error
            p_err_msg:='sp_validate_pool '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_pool;


    PROCEDURE sp_validate_room(p_err_code in OUT NUMBER,
                                f_policycd IN VARCHAR,
                                f_symbol IN VARCHAR,
                                f_qtty IN  NUMBER,
            p_err_msg OUT VARCHAR2)
    AS
        v_referr    VARCHAR2(260);
        v_bodvalue  NUMBER;
        v_dailyvalue    NUMBER;
    BEGIN
        p_err_msg:='sp_validate_room f_policycd=>'||f_policycd;
        --Get BOD granted value
        SELECT NVL(SUM(GRANTED-INUSED),0) INTO v_bodvalue
        FROM POOLROOM
        WHERE POLICYTYPE='R' AND POLICYCD=f_policycd AND NVL(REFSYMBOL,'')=f_symbol;

        --Get daily value
        SELECT NVL(SUM(CASE WHEN DOC='D' THEN -NVL(ROOMVAL,0) ELSE NVL(ROOMVAL,0) END),0) INTO v_dailyvalue
        FROM ALLOCATION
        WHERE POLICYCD=f_policycd AND SYMBOL=f_symbol;

        --Return value
        IF v_bodvalue+v_dailyvalue<f_qtty THEN
            sp_get_error_byname(p_err_code, v_referr, 'ROOM_NOT_ENOUGH',p_err_msg);
        ELSE
            p_err_code:=0;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := -1; --undefined error
            p_err_msg:='sp_validate_room '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_validate_room;

  PROCEDURE sp_throw(f_err_code in NUMBER,
            p_err_msg OUT VARCHAR2)
  AS
    v_msg VARCHAR(500);
    v_name VARCHAR(20);
    v_num VARCHAR(20);
    v_count NUMBER;
  BEGIN
    p_err_msg:='sp_throw';

    SELECT COUNT(*) into  v_count FROM DICERRORS where ERRNUM = f_err_code;
    IF v_count != null THEN
      SELECT ERRNAME, ERRNUM, ERRDESC INTO v_name, v_num, v_msg FROM DICERRORS WHERE ERRNUM = f_err_code;
    ELSE
      -- ERRORCODE NOT FOUND
      v_msg := '-20990';
    END IF;
    raise_application_error(v_num, v_msg);
  EXCEPTION
       WHEN OTHERS THEN
          --p_err_code := '-90025';
          p_err_msg:='sp_throw '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_throw;

  PROCEDURE sp_validate_amend_order(p_err_code in OUT VARCHAR,
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_exchange IN VARCHAR, --ma san
              p_side IN VARCHAR, --mua :B, ban :S
              p_session_index IN VARCHAR,
            p_err_msg OUT VARCHAR2
              )
  AS
    v_session VARCHAR(6);
    v_subtypecd VARCHAR(20);

  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_validate_amend_order p_edit_order_id=>'||p_edit_order_id;
    --check phien
    IF p_session_index IS NULL  THEN
        SELECT SESSIONEX INTO v_session FROM MARKETINFO WHERE EXCHANGE = p_exchange;
    ELSE
       v_session := p_session_index;
    END IF;

    IF p_exchange = 'HSX' THEN
      IF v_session = 'OPN' /*OR v_session = 'CLS'*/ THEN
        p_err_code := '-95015';
        return;
      END IF;

    ELSIF p_exchange = 'HNX' THEN
      IF v_session = 'L5M' THEN --phien dong cua 5 phut cuoi
        p_err_code := '-95015';
        return;
      END IF;
    END IF;

    /*date: 2014-12-15 : 11h
        author: dung.bui
        descrition: comment doan code nay
        begin
        SELECT SUBTYPECD INTO v_subtypecd FROM ORDERS WHERE ORDERID = p_edit_order_id;
        IF v_subtypecd != 'LO' THEN
          p_err_code := '-95015';
          return;
        END IF;
        */
        /*end*/
     --check loai lenh

     EXCEPTION
         WHEN OTHERS THEN
            p_err_code := '-1';
            return;
            p_err_msg:='sp_validate_amend_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_validate_amend_order;

  PROCEDURE sp_validate_cancel_order(p_err_code in OUT VARCHAR,
              p_edit_order_id IN VARCHAR, --so hieu lenh goc
              p_exchange IN VARCHAR, --ma san
              p_side IN VARCHAR, --mua :B, ban :S
              p_session_index IN VARCHAR,
            p_err_msg OUT VARCHAR2
              )
  AS
    v_session VARCHAR(6);
    v_subtypecd VARCHAR(20);

  BEGIN
     p_err_code := '0';
     p_err_msg:='sp_validate_cancel_order p_edit_order_id=>'||p_edit_order_id;
     --check loai lenh
     SELECT SUBTYPECD INTO v_subtypecd FROM ORDERS WHERE ORDERID = p_edit_order_id;
        /*date: 2014-12-11 : 15h
        author: dung.bui
        descrition: COMMENT CODE
        begin
          IF v_subtypecd != 'LO' AND v_subtypecd != 'ATC' THEN
              p_err_code := '-95024';
              return;
          END IF;
          IF p_session_index = 'OPN' OR p_session_index = 'CLS' THEN
            p_err_code := '-95015';
            return;
          END IF;
        */
        /*end*/

      -- viet code moi
      /*date: 2014-12-17 : 15h
        author: dung.bui
        descrition:
        begin
      */
      IF (p_exchange = 'HSX') THEN
        --ko cho huy lenh trong phien mo cua
        IF p_session_index = 'OPN' THEN --  OR p_session_index = 'CLS'
            p_err_code := '-95015';
            return;
        END IF;
        --ko cho huy lenh thi truong
        IF (v_subtypecd != 'LO') THEN
             p_err_code := '-95024';
            --dbms_output.put_line('khong the huy lenh thi truong');
            return;
        END IF;

      ELSIF (p_exchange = 'HNX') THEN
        IF v_subtypecd != 'LO' AND v_subtypecd != 'ATC' /*AND v_subtypecd != 'MTL'*/ THEN
          p_err_code := '-95024';
          --dbms_output.put_line('khong the huy lenh thi truong');
          return;
        END IF;

        IF v_subtypecd = 'ATC' AND p_session_index != 'CLS' THEN
          p_err_code := '-95015';
          return;
        END IF;

        IF p_session_index = 'L5M' THEN
          p_err_code := '-95015';
          return;
        END IF;
      END IF;

      /*end*/
  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_validate_cancel_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_validate_cancel_order;

END CSPKS_FO_VALIDATION;



/
