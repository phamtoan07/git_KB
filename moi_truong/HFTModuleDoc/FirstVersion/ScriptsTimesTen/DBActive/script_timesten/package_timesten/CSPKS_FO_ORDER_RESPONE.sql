CREATE OR REPLACE 
PACKAGE cspks_fo_order_respone AS

      PROCEDURE sp_proces_order_trading(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_qtty IN  NUMBER,  --Khoi luong khop
                                p_price IN  NUMBER, --Gia khop
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_txdate in varchar, --ngay giao dich
                p_ExecID IN VARCHAR,
                p_err_msg OUT VARCHAR2
                );

      PROCEDURE sp_proces_order_replace(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_qtty IN  NUMBER,  --Khoi luong khop
                                p_price IN  NUMBER, --Gia khop
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_txdate in varchar, --ngay giao dich
                p_quoteid in varchar,
                p_side in varchar,
                p_sub_side in varchar,
                p_quote_price in number,
                p_symbol in varchar,
                p_rate_tax in number,
                p_rate_brk in number,
                p_err_msg OUT VARCHAR2
                );

      PROCEDURE sp_proces_order_confirm(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_txdate in VARCHAR, --ngay giao dich
                p_LastQty IN NUMBER, --khoi luong co hieu luc tren so
                p_LastPx IN NUMBER, --
                p_LeavesQty IN NUMBER, --khoi luong thay doi so voi lenh goc
                p_OrderQty2 IN NUMBER,
                p_err_msg OUT VARCHAR2
                );

      PROCEDURE sp_proces_order_confirm_edit(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_txdate in VARCHAR, --ngay giao dich
                p_side IN VARCHAR,-- mua hay ban
                p_sub_side IN VARCHAR,
                p_order_status IN VARCHAR, --trang thai cua lenh
                p_sub_status IN VARCHAR,
                p_acctno IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_reforderid IN VARCHAR, --
                p_quote_qtty IN number, --khoi luong quote
                p_remain_qtty IN number, --khoi luong con lai
                p_quote_price IN number, --gia huy/sua
                p_LastQty IN NUMBER, --khoi luong co hieu luc tren so
                p_LastPx IN NUMBER, --
                p_LeavesQty IN NUMBER, --khoi luong thay doi so voi lenh goc
                p_OrderQty2 IN NUMBER,
                p_err_msg OUT VARCHAR2
                );

      PROCEDURE sp_proces_confirm_free_order(p_err_code in OUT VARCHAR,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_subside IN VARCHAR,
                p_acctno IN VARCHAR,
                p_symbol IN VARCHAR,
                p_freed_qtty IN NUMBER,
                p_remain_qtty IN NUMBER,
                p_mort_qtty IN NUMBER,
                p_quote_price IN NUMBER,
                p_err_msg OUT VARCHAR2,
                p_mode IN VARCHAR);--I:internal

      PROCEDURE sp_proces_confirm_cancel(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_txdate in VARCHAR, --ngay giao dich
                p_side IN VARCHAR,-- mua hay ban
                p_sub_side IN VARCHAR,
                p_order_status IN VARCHAR, --trang thai cua lenh
                p_sub_status IN VARCHAR,
                p_acctno IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_reforderid IN VARCHAR, --
                p_quote_qtty IN number, --khoi luong quote
                p_remain_qtty IN integer, --khoi luong con lai
                p_quote_price IN number, --gia huy/sua
                p_typecd IN VARCHAR,
                p_userid IN VARCHAR,
                p_quoteid IN VARCHAR,
                p_sessionnex IN VARCHAR,
                p_LeavesQty IN NUMBER,
                p_err_msg OUT VARCHAR2
              );

      PROCEDURE sp_proces_respone_error(p_err_code in OUT VARCHAR,
                p_msgtype IN VARCHAR, --kieu message tu so
                                p_reject_code in VARCHAR, --ma loi
                p_content in VARCHAR,
                p_err_msg OUT VARCHAR2
              );

      PROCEDURE sp_proces_MTL_order_confirm(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_Symbol IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_OrderQty IN NUMBER, --
                p_OrdType IN VARCHAR, --
                p_Price IN NUMBER,
                p_err_msg OUT VARCHAR2
                );
END CSPKS_FO_ORDER_RESPONE;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_order_respone AS

  PROCEDURE sp_proces_order_trading(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_qtty IN  NUMBER,  --Khoi luong khop
                                p_price IN  NUMBER, --Gia khop
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_txdate in varchar, --ngay giao dich
                p_ExecID IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_side              ORDERS.SIDE%TYPE;
    v_sub_side              ORDERS.SUBSIDE%TYPE;
    v_quoteid               ORDERS.QUOTEID%TYPE;
    v_quote_price         ORDERS.QUOTE_PRICE%TYPE;
    v_symbol                  ORDERS.SYMBOL%TYPE;
    v_rate_tax              ORDERS.RATE_TAX%TYPE;
    v_rate_brk              ORDERS.RATE_BRK%TYPE;
    v_rate_adv              ORDERS.RATE_ADV%TYPE;
    v_quote_qtty          ORDERS.QUOTE_QTTY%TYPE;
    v_remain_qtty         ORDERS.REMAIN_QTTY%TYPE;
    v_mort_qtty             ORDERS.MORT_QTTY%TYPE;
    v_debt                    ACCOUNTS.BOD_DEBT%TYPE;
    v_payable               ACCOUNTS.BOD_PAYABLE%TYPE;
    v_balance               ACCOUNTS.BOD_BALANCE%TYPE;
    v_odramt                  ACCOUNTS.CALC_ODRAMT%TYPE;
    v_advbal                  ACCOUNTS.CALC_ADVBAL%TYPE;
    v_td                      ACCOUNTS.BOD_TD%TYPE;
    v_t0value               ACCOUNTS.BOD_T0VALUE%TYPE;
    v_poolid                  ACCOUNTS.POOLID%TYPE;
    v_roomid                  ACCOUNTS.ROOMID%TYPE;
    v_bod_adv               ACCOUNTS.BOD_ADV%TYPE;
    v_formulacd             ACCOUNTS.FORMULACD%TYPE;
    v_release_pool        NUMBER;
    v_trade                   NUMBER;
    v_mortgage              NUMBER;
    v_fee                     NUMBER;
    v_trade_id              VARCHAR(20);
    v_currtime              TIMESTAMP;
    v_release_amt         NUMBER;
    v_release_amt_ub      NUMBER;
    v_release_qtty        NUMBER;
    v_release_qtty_ub   NUMBER;
    v_rate_asset            NUMBER := 0;
    v_price_asset         NUMBER := 0;
    v_add_amt               NUMBER;
    v_count                   NUMBER;
    v_marked                  PORTFOLIOS.MARKED%TYPE;
    v_markedcom             PORTFOLIOS.MARKEDCOM%TYPE;
    v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_ownroomid         VARCHAR(20);
    v_basketid          ACCOUNTS.BASKETID%TYPE;
    v_basketid_ub       ACCOUNTS.BASKETID_UB%TYPE;
    v_temp_advbalance   NUMBER;
    v_markedEX            NUMBER;
    v_markedcomEX         NUMBER;
    v_norb            ORDERS.NORB%TYPE;
    v_clearday          ORDERS.MARKED%TYPE;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_proces_order_trading p_order_id=>'||p_order_id;
    BEGIN
      execute immediate
      'select tt_sysdate from dual' into v_currtime;
    END;

    --lay thong tin lenh goc
    SELECT QUOTEID,SIDE,SUBSIDE,QUOTE_PRICE,SYMBOL,RATE_TAX,RATE_BRK,
      QUOTE_QTTY,MORT_QTTY,REMAIN_QTTY,RATE_ADV,NORB,MARKED
    INTO v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,
      v_quote_qtty,v_mort_qtty,v_remain_qtty,v_rate_adv,v_norb,v_clearday
    FROM ORDERS WHERE ORDERID = p_order_id;

    /*dung.bui added code check gia so tra ve, date 27/11/2015*/
    IF (v_sub_side = 'NB' OR v_sub_side = 'AB') THEN
      IF p_price > v_quote_price THEN
        p_err_code := '-95042';
        RETURN;
      END IF;
    ELSIF (v_sub_side = 'NS' OR v_sub_side = 'AS') THEN
      IF p_price < v_quote_price THEN
        p_err_code := '-95042';
        RETURN;
      END IF;
    END IF;
    /*end*/
    --backup 26/11/2015
    /*tiendt: check duplicate trading for 2 times
     date:28/10/2015*/
    SELECT COUNT(1) INTO v_count FROM TRADES WHERE ORDERID=p_order_id AND EXECID=p_ExecID;
    IF v_count > 0 THEN
      p_err_code := '-95041';
      return;
    END IF;
    /*end*/
    --general orderid
    CSPKS_FO_COMMON.sp_get_tradeid(p_err_code,v_trade_id,p_err_msg);

    INSERT INTO TRADES(TRADEID,ORDERID,QTTY,PRICE,EXECID,TIME_EXEC,STATUS,LASTCHANGE)
    VALUES(v_trade_id,p_order_id,p_qtty,p_price,p_ExecID,TO_DATE(p_txdate,'yyyyMMdd-HH24:MI:SS'),'P',v_currtime);

    SELECT BOD_DEBT,BOD_PAYABLE,BOD_BALANCE,CALC_ODRAMT,CALC_ADVBAL,POOLID,ROOMID,BASKETID,BASKETID_UB,
        BOD_TD,BOD_T0VALUE,BOD_ADV,FORMULACD,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB
    INTO v_debt,v_payable,v_balance,v_odramt,v_advbal,v_poolid,v_roomid,v_basketid,v_basketid_ub,
        v_td,v_t0value,v_bod_adv,v_formulacd,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub
    FROM ACCOUNTS WHERE ACCTNO = p_account;

    insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_advbal1',v_advbal);

    IF (v_remain_qtty < p_qtty) THEN
      p_err_code := '-90011';
      INSERT INTO EXCERROR(AUTOID,MSGTYPE,STATUS,REJCODE,CONTENT,LASTCHANGE)
      VALUES (SEQ_EXCERROR.NEXTVAL,NULL,'P','-90011','LOI KHOP LENH ,ORDERID : ' || p_order_id,v_currtime);

      RETURN;
    END IF;
    --mua : gia tri khop co the <=gia tri dat lenh
    --ban : gia tri khop co the >= gia tri dat lenh
    --update ORDERS

    UPDATE ORDERS SET EXEC_AMT=EXEC_AMT+(p_qtty*p_price),EXEC_QTTY=EXEC_QTTY+p_qtty,REMAIN_QTTY=GREATEST(0,REMAIN_QTTY - p_qtty),LASTCHANGE = v_currtime
    WHERE ORDERID = p_order_id;

    --update Quotes
    UPDATE QUOTES SET EXEC_AMT=EXEC_AMT+(p_qtty*p_price),EXEC_QTTY=EXEC_QTTY+p_qtty
    WHERE QUOTEID = v_quoteid;

    v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);


    SELECT COUNT(1) INTO v_count FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
    WHERE AC.ACCTNO=p_account AND PO.SYMBOL=v_symbol AND AC.ACCTNO=PO.ACCTNO AND BA.BASKETID=AC.BASKETID AND PO.SYMBOL=BA.SYMBOL;

    IF (v_count = 1) THEN
      --Lay du lieu cua bang baskets
      SELECT BA.RATE_ASSET,BA.PRICE_ASSET INTO v_rate_asset,v_price_asset
      FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
      WHERE AC.ACCTNO=p_account AND PO.SYMBOL=v_symbol AND AC.ACCTNO=PO.ACCTNO
        AND BA.BASKETID=AC.BASKETID AND PO.SYMBOL =BA.SYMBOL;
    END IF;

    IF(v_sub_side = 'NB') OR (v_sub_side = 'AB') THEN --mua
      /*
      --dung.bui comment code release room for order buy trade, 24/11/2015, ko nha room khi khop mua
      v_add_amt := p_qtty*(v_quote_price-p_price)*(1 + v_rate_brk/100); --phan chenh khop lenh
      IF (v_formulacd != 'CASH' AND v_formulacd != 'ADV') THEN
        v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool( p_err_code,v_add_amt,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value);
        --dbms_output.put_line('v_release_pool:' || v_release_pool);
        IF v_release_pool > 0 THEN
          IF v_poolid IS NOT NULL THEN
            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,null,v_symbol,p_account,v_poolid,v_release_pool,0,null);
          END IF;
          -- nha room
          IF v_roomid IS NOT NULL THEN
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_odramt-v_add_amt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_order_id,v_side,v_symbol,0);
          END IF;
        END IF;
      END IF;
      */
      --Giam gia tri ky quy mua
      --UPDATE ACCOUNTS SET CALC_ODRAMT=CALC_ODRAMT-v_add_amt WHERE ACCTNO=p_account;
      --Cap nhat Portfolios

      --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=v_symbol;
      IF v_count > 0 THEN
         UPDATE portfoliosex SET BOD_RT3=BOD_RT3+p_qtty WHERE acctno = p_account AND symbol=v_symbol;
      ELSE
         INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                           VALUES (p_account, v_symbol, 0, 0,
                           0, 0, p_qtty, 0, SYSDATE, 0);
      END IF;

      /*
      UPDATE PORTFOLIOS SET BOD_RT3=BOD_RT3+p_qtty WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
       */
    ELSE --ban
      v_add_amt := p_qtty*p_price*(1-(v_rate_tax/100)-(v_rate_brk/100));
      -- cap nhat CK ban cho ve

      --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=v_symbol;
      IF v_count > 0 THEN
         UPDATE portfoliosex SET BOD_ST3=BOD_ST3+p_qtty WHERE acctno = p_account AND symbol=v_symbol;
      ELSE
         INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                           VALUES (p_account, v_symbol, 0, 0,
                           0, 0, 0, p_qtty, SYSDATE, 0);
      END IF;
      /*
      UPDATE PORTFOLIOS SET BOD_ST3=BOD_ST3+p_qtty WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
      */
       -- tinh phi UTTB :
      IF (v_norb = 'N') THEN
        v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_advance(p_qtty,p_price,v_rate_adv,v_rate_brk,v_rate_tax);
      ELSIF (v_norb = 'B') THEN
        v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_adv_cross_ord(p_qtty,p_price,v_rate_adv,v_rate_brk,v_rate_tax,v_clearday);
      ELSE
        v_fee := 0;
      END IF;

      --Tang ung truoc tien ban
      IF (v_sub_side = 'NS') OR (v_sub_side = 'AS') THEN -- ban/sua ban thuong
        UPDATE ACCOUNTS SET CALC_ADVBAL=CALC_ADVBAL + TRUNC(v_add_amt-v_fee,2) WHERE ACCTNO=p_account;
      ELSIF (v_sub_side = 'MS') OR (v_sub_side = 'AM') THEN -- ban/sua ban cam co
        UPDATE ACCOUNTS SET CALC_SELLMORT=CALC_SELLMORT + TRUNC(v_add_amt-v_fee,2) WHERE ACCTNO=p_account;
      ELSIF (v_sub_side = 'TS') THEN
        IF (p_qtty >= v_remain_qtty-v_mort_qtty) THEN
          v_trade := (v_remain_qtty-v_mort_qtty)*p_price*(1-(v_rate_tax/100)-(v_rate_brk/100));
          v_mortgage := (p_qtty-(v_remain_qtty-v_mort_qtty))*p_price*(1-(v_rate_tax/100)-(v_rate_brk/100));
          UPDATE ACCOUNTS SET CALC_ADVBAL=CALC_ADVBAL+TRUNC(v_trade-v_fee,2),CALC_SELLMORT=CALC_SELLMORT+TRUNC(v_mortgage-v_fee,2)
          WHERE ACCTNO=p_account;
          UPDATE ORDERS SET MORT_QTTY=MORT_QTTY-(p_qtty-(v_remain_qtty-v_mort_qtty)) WHERE ORDERID=p_order_id;
        ELSE
          UPDATE ACCOUNTS SET CALC_ADVBAL=CALC_ADVBAL+TRUNC(v_add_amt-v_fee,2) WHERE ACCTNO=p_account;
        END IF;
      END IF;

      SELECT CALC_ADVBAL INTO v_temp_advbalance FROM ACCOUNTS WHERE ACCTNO = p_account;

      IF (v_formulacd != 'CASH' AND v_formulacd != 'ADV') THEN
        v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code,v_add_amt -Ceil(v_fee) ,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_fee',v_fee);
        --dbms_output.put_line('v_release_pool' || v_release_pool);
        SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_account AND REFSYMBOL=v_symbol;

        IF (v_count = 1) THEN --Ma CK nam trong room db
          SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_account AND REFSYMBOL=v_symbol;
          --dbms_output.put_line('v_ownroomid' || v_ownroomid);
          IF (v_release_pool > 0) THEN
            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,null,v_symbol,p_account,v_poolid,v_release_pool,0,null,p_err_msg);
          END IF;
          /*date:27/10/2015,author : dung.bui
          description : fix bug for process poolroom
          */
          --CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code,p_account,v_ownroomid,v_symbol,p_qtty,p_order_id,v_side);
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
          v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_temp_advbalance/*v_advbal+v_add_amt-v_fee*/,v_td,v_t0value,p_order_id,v_side,v_symbol,p_qtty,p_err_msg);
          /*end*/
        ELSIF (v_count = 0) THEN
          IF v_release_pool > 0 THEN
            IF v_poolid IS NOT NULL THEN
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,null,v_symbol,p_account,v_poolid,v_release_pool,0,null,p_err_msg);
            END IF;

            --nha room
            IF v_roomid IS NOT NULL THEN
              SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS   WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
              BEGIN
                SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX   WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
              EXCEPTION WHEN OTHERS THEN
                v_markedEX:=0;
                v_markedcomEX :=0;
              END;

               v_marked:=v_marked +  v_markedEX;
               v_markedcom:= v_markedcom +  v_markedcomEX;

              --so luong chung khoan nha danh dau
              v_release_qtty := LEAST(v_marked,p_qtty);
              v_release_qtty_ub := LEAST(v_markedcom,p_qtty);

              v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
              v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));

              --nha room ma da danh dau trong gd,insert allocation
              IF v_roomid = 'SYSTEM' THEN

                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=v_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKED=MARKED-v_release_qtty WHERE acctno = p_account AND symbol=v_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_account, v_symbol, 0, 0,
                                   0, -v_release_qtty, 0, 0, SYSDATE, 0);
                END IF;
               /*
                UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
                */
                IF (v_release_qtty > 0) THEN
                  INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                    VALUES (SEQ_COMMON.NEXTVAL,p_order_id,v_side,v_symbol,p_account,v_release_qtty,null,'C','R',null,0,v_roomid,v_release_amt,'P',SYSDATE);
                END IF;
                IF v_basketid != v_basketid_ub THEN --tk dong tai tro

                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=v_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_account AND symbol=v_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_account, v_symbol, 0, 0,
                                   0, 0, 0, 0, SYSDATE, -v_release_qtty_ub);
                END IF;
                  /*
                  UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
                  */
                  IF (v_release_qtty_ub > 0) THEN
                    INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                    VALUES (SEQ_COMMON.NEXTVAL,p_order_id,v_side,v_symbol,p_account,v_release_qtty_ub,null,'C','R',null,0,'UB', v_release_amt_ub, 'P', SYSDATE);
                  END IF;
                END IF;
              ELSIF v_roomid = 'UB' THEN

                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=v_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_account AND symbol=v_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_account, v_symbol, 0, 0,
                                   0, -v_release_qtty, 0, 0, SYSDATE, -v_release_qtty_ub);
                END IF;

                /*
                UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
                */
                IF (v_release_qtty_ub > 0) THEN
                  INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                  VALUES (SEQ_COMMON.NEXTVAL, p_order_id, v_side, v_symbol, p_account, v_release_qtty_ub, null, 'C', 'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
                END IF;
                IF (v_release_qtty > 0) THEN
                  INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                  VALUES (SEQ_COMMON.NEXTVAL,p_order_id,v_side,v_symbol,p_account,v_release_qtty,null,'C','R',null,0,'SYSTEM',v_release_amt,'P',SYSDATE);
                END IF;
              END IF;

              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_roomid',v_roomid);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_payable',v_payable);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_debt_t0',v_bod_debt_t0);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_d_margin',v_bod_d_margin);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_d_margin_ub',v_bod_d_margin_ub);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_ordamt',v_odramt);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'0','0');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_balance',v_balance);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_adv',v_bod_adv);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_advbal2',v_advbal);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_advbal',v_advbal+v_add_amt-v_fee);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_temp_advbalance',v_temp_advbalance);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_td',v_td);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_t0value',v_t0value);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'p_order_id',p_order_id);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_side',v_side);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_symbol',v_symbol);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'0',0);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_fee',v_fee);

              CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_temp_advbalance/*v_advbal+v_add_amt-v_fee*/,v_td,v_t0value,p_order_id,v_side,v_symbol,p_qtty,p_err_msg);

              /*dung.bui added code xu li room, 24/11/2015 */
              -- Danh dau sang CK khac neu tai san danh dau != du no

              CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_temp_advbalance/*v_advbal+v_add_amt-v_fee*/,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);
              /*end*/
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
      p_err_code := '-90025';
      p_err_msg:='sp_proces_order_trading '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_order_trading;

  --khop lenh HSX
  PROCEDURE sp_proces_order_replace(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_qtty IN  NUMBER,  --Khoi luong khop
                                p_price IN  NUMBER, --Gia khop
                                p_exchange_code IN VARCHAR, --ma xac nhan tu so
                p_txdate IN VARCHAR, --ngay giao dich
                p_quoteid IN VARCHAR,
                p_side IN VARCHAR,
                p_sub_side IN VARCHAR,
                p_quote_price IN NUMBER,
                p_symbol IN VARCHAR,
                p_rate_tax IN NUMBER,
                p_rate_brk IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
  AS

    v_debt                    ACCOUNTS.BOD_DEBT%TYPE;
    v_payable               ACCOUNTS.BOD_PAYABLE%TYPE;
    v_balance               ACCOUNTS.BOD_BALANCE%TYPE;
    v_odramt                  ACCOUNTS.CALC_ODRAMT%TYPE;
    v_advbal                  ACCOUNTS.CALC_ADVBAL%TYPE;
    v_bod_adv               ACCOUNTS.BOD_ADV%TYPE;
    v_td                      ACCOUNTS.BOD_TD%TYPE;
    v_t0value               ACCOUNTS.BOD_T0VALUE%TYPE;
    v_poolid                  ACCOUNTS.POOLID%TYPE;
    v_roomid                  ACCOUNTS.ROOMID%TYPE;
    v_formulacd             ACCOUNTS.FORMULACD%TYPE;
    v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_quote_qtty          ORDERS.QUOTE_QTTY%TYPE;
    v_remain_qtty         ORDERS.REMAIN_QTTY%TYPE;
    v_mort_qtty             ORDERS.MORT_QTTY%TYPE;
    v_rate_brk              ORDERS.RATE_BRK%TYPE;
    v_rate_adv              ORDERS.RATE_ADV%TYPE;
    v_trade                     NUMBER;
    v_mortgage                NUMBER;
    v_fee                       NUMBER;
    v_release_qtty          NUMBER;
    v_release_qtty_ub   NUMBER;
    v_release_amt           NUMBER;
    v_release_amt_ub        NUMBER;
    v_rate_asset              NUMBER := 0;
    v_price_asset           NUMBER := 0;
    v_count                     NUMBER;
    v_trade_id                VARCHAR(20);
    v_currtime                TIMESTAMP;
    v_release_pool          NUMBER;
    v_add_amt               NUMBER;
    v_marked                  PORTFOLIOS.MARKED%TYPE;
    v_markedcom             PORTFOLIOS.MARKEDCOM%TYPE;
    v_ownroomid         VARCHAR(20);
    v_basketid          ACCOUNTS.BASKETID%TYPE;
    v_basketid_ub       ACCOUNTS.BASKETID_UB%TYPE;
    v_quote_price         ORDERS.QUOTE_PRICE%TYPE;
    v_markedEX          NUMBER;
    v_markedcomEX       NUMBER;
    v_norb            ORDERS.NORB%TYPE;
    v_clearday          ORDERS.MARKED%TYPE;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_proces_order_replace p_order_id=>'||p_order_id;
    BEGIN
      execute immediate
      'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
    END;

    --lay thong tin lenh goc
    SELECT QUOTE_QTTY,MORT_QTTY,REMAIN_QTTY,RATE_BRK,RATE_ADV,QUOTE_PRICE,NORB,MARKED
    INTO v_quote_qtty,v_mort_qtty,v_remain_qtty,v_rate_brk,v_rate_adv,v_quote_price,v_norb,v_clearday
    FROM ORDERS WHERE ORDERID = p_order_id;
    /*dung.bui added code check gia so tra ve, date 28/11/2015*/
    IF (p_sub_side = 'NB' OR p_sub_side = 'AB') THEN
      IF p_price > v_quote_price THEN
        p_err_code := '-95042';
        RETURN;
      END IF;
    ELSIF (p_sub_side = 'NS' OR p_sub_side = 'AS') THEN
      IF p_price < v_quote_price THEN
        p_err_code := '-95042';
        RETURN;
      END IF;
    END IF;
    /*end*/
    --general orderid
    CSPKS_FO_COMMON.sp_get_tradeid(p_err_code,v_trade_id,p_err_msg);

    INSERT INTO TRADES(TRADEID,ORDERID,QTTY,PRICE,TIME_EXEC,STATUS,LASTCHANGE)
    VALUES(v_trade_id,p_order_id,p_qtty,p_price,TO_DATE(p_txdate,'yyyyMMdd-HH24:MI:SS'/*'yyyy-mm-dd'*/),'P',v_currtime);

    --lay thong tin tu bang accounts
    SELECT BOD_DEBT,BOD_PAYABLE,BOD_BALANCE,CALC_ODRAMT,CALC_ADVBAL,POOLID,ROOMID,BOD_TD,BOD_T0VALUE,BOD_ADV,
      FORMULACD,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB,BASKETID,BASKETID_UB
    INTO v_debt,v_payable,v_balance,v_odramt,v_advbal,v_poolid,v_roomid,v_td,v_t0value,v_bod_adv,
      v_formulacd,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_basketid,v_basketid_ub
    FROM ACCOUNTS WHERE ACCTNO = p_account;

    --update ORDERS
    UPDATE ORDERS SET EXEC_AMT=EXEC_AMT+(p_qtty*p_price),EXEC_QTTY=EXEC_QTTY+p_qtty,REMAIN_QTTY=GREATEST(0,REMAIN_QTTY-p_qtty),LASTCHANGE=v_currtime
    WHERE ORDERID = p_order_id;

    --update Quotes
    UPDATE QUOTES SET EXEC_AMT=EXEC_AMT+(p_qtty*p_price),EXEC_QTTY=EXEC_QTTY + p_qtty,LASTCHANGE=v_currtime
    WHERE QUOTEID = p_quoteid;

    /*
    tiendt added for buy amount , date: 2015-08-24
    */
    v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);
    /*end*/

    SELECT COUNT(1) INTO v_count
    FROM BASKETS BA, ACCOUNTS AC, PORTFOLIOS PO
        WHERE AC.ACCTNO = p_account AND PO.SYMBOL = p_symbol AND AC.ACCTNO = PO.ACCTNO
          AND BA.BASKETID = AC.BASKETID AND PO.SYMBOL = BA.SYMBOL;

    IF (v_count = 1) THEN
      --Lay du lieu cua bang baskets
      SELECT BA.RATE_ASSET,BA.PRICE_ASSET INTO v_rate_asset,v_price_asset FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
      WHERE AC.ACCTNO = p_account AND PO.SYMBOL = p_symbol AND AC.ACCTNO = PO.ACCTNO
            AND BA.BASKETID = AC.BASKETID AND PO.SYMBOL = BA.SYMBOL;
    END IF;

    IF(p_sub_side = 'NB') OR (p_sub_side = 'AB') THEN --mua
      /*
      dung.bui comment code release room for order buy trade, 24/11/2015
      v_add_amt := p_qtty*(p_quote_price-p_price)*(1 + v_rate_brk/100); --phan chenh khop lenh
      IF (v_formulacd != 'CASH' AND v_formulacd != 'ADV') THEN
        v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool( p_err_code, v_add_amt,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value);
        IF v_release_pool > 0 THEN
          -- nha pool
          IF v_poolid IS NOT NULL THEN
            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,null,p_symbol,p_account,v_poolid,v_release_pool,0,null);
          END IF;

          -- nha room
          IF v_roomid IS NOT NULL THEN
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_odramt-v_add_amt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_order_id,p_side,p_symbol,0);

          END IF;
        END IF;
      END IF;
      */
      --Cap nhat Portfolios

      --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=p_symbol;
      IF v_count > 0 THEN
         UPDATE portfoliosex SET BOD_RT3=BOD_RT3+p_qtty WHERE acctno = p_account AND symbol=p_symbol;
      ELSE
         INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                           VALUES (p_account, p_symbol, 0, 0,
                           0, 0, p_qtty, 0, SYSDATE, 0);
      END IF;
      /*
      UPDATE PORTFOLIOS SET BOD_RT3=BOD_RT3+p_qtty WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
      */


    ELSE --ban
      v_add_amt := p_qtty*p_price*(1-(p_rate_tax/100)-(p_rate_brk/100));
      -- tinh phi UTTB :
      --v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_advance(p_qtty,p_price,v_rate_adv,v_rate_brk,p_rate_tax);
      IF (v_norb = 'N') THEN
        v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_advance(p_qtty,p_price,v_rate_adv,v_rate_brk,p_rate_tax);
      ELSIF (v_norb = 'B') THEN
        v_fee := CSPKS_FO_COMMON.fn_get_fee_cash_adv_cross_ord(p_qtty,p_price,v_rate_adv,v_rate_brk,p_rate_tax,v_clearday);
      ELSE
        v_fee := 0;
      END IF;
      --Cap nhat Portfolios

      --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=p_symbol;
      IF v_count > 0 THEN
         UPDATE portfoliosex SET BOD_ST3=BOD_ST3+p_qtty WHERE acctno = p_account AND symbol=p_symbol;
      ELSE
         INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                           VALUES (p_account, p_symbol, 0, 0,
                           0, 0, 0, p_qtty, SYSDATE, 0);
      END IF;

      /*
      UPDATE PORTFOLIOS SET BOD_ST3=BOD_ST3+p_qtty WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
      */


      IF (v_formulacd != 'CASH' AND v_formulacd != 'ADV') THEN
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'REPLACE',p_account,p_order_id,'v_fee',v_fee);

        v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool( p_err_code, v_add_amt - Ceil(v_fee),v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
        --check room dac biet
        SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_account AND REFSYMBOL=p_symbol;

        IF v_count = 1 THEN --Ma CK gan trong room db
          SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_account AND REFSYMBOL=p_symbol;
          IF v_release_pool > 0 AND (v_poolid IS NOT NULL)THEN
            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,null,p_symbol,p_account,v_poolid,v_release_pool,0,null,p_err_msg);
          END IF;

          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_roomid',v_roomid);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_payable',v_payable);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_debt_t0',v_bod_debt_t0);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_d_margin',v_bod_d_margin);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_d_margin_ub',v_bod_d_margin_ub);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_ordamt',v_odramt);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'0','0');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_balance',v_balance);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_bod_adv',v_bod_adv);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_advbal',v_advbal+v_add_amt-v_fee);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_td',v_td);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'v_t0value',v_t0value);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'p_order_id',p_order_id);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'p_side',p_side);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'p_symbol',p_symbol);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'KHOP_BAN',p_account,p_order_id,'0',0);

          CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
          v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal+v_add_amt-v_fee,v_td,v_t0value,p_order_id,p_side,p_symbol,p_qtty,p_err_msg);
        ELSIF v_count = 0 THEN
          IF v_release_pool > 0 THEN
            IF v_poolid IS NOT NULL THEN
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,null,p_symbol,p_account,v_poolid,v_release_pool,0,null,p_err_msg);
            END IF;
            IF v_roomid IS NOT NULL THEN
              SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
              --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
              BEGIN
                SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
              EXCEPTION WHEN OTHERS THEN
                v_markedEX :=0;
                v_markedcomEX:=0;
              END;
              v_marked:=v_marked + v_markedEX;
              v_markedcom:=v_markedcom +  v_markedcomEX;

              --so luong chung khoan nha danh dau
              v_release_qtty := LEAST(v_marked,p_qtty);
              v_release_qtty_ub := LEAST(v_markedcom,p_qtty);
              v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
              v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));

              --insert allocation
              IF v_roomid = 'SYSTEM' THEN

                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                  SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=p_symbol;
                  IF v_count > 0 THEN
                     UPDATE portfoliosex SET MARKED = MARKED - v_release_qtty WHERE acctno = p_account AND symbol=p_symbol;
                  ELSE
                     INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_account, p_symbol, 0, 0,
                                       0, - v_release_qtty, 0, 0, SYSDATE, 0);
                  END IF;
                /*
                UPDATE PORTFOLIOS SET MARKED = MARKED - v_release_qtty WHERE ACCTNO = p_account AND SYMBOL = p_symbol;
                */
                IF (v_release_qtty > 0) THEN
                  INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                  VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, p_symbol, p_account, v_release_qtty, null, 'C', 'R', null, 0, v_roomid, v_release_amt, 'P', SYSDATE);
                END IF;
                IF (v_basketid != v_basketid_ub) THEN --tk dong tai tro

                     --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_account AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_account, p_symbol, 0, 0,
                                       0, 0, 0, 0, SYSDATE, -v_release_qtty_ub);
                    END IF;

                    /*
                    UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
                    */
                    IF v_release_qtty_ub > 0 THEN
                      INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                        DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                      VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_account,v_release_qtty_ub,NULL,
                        'C','R',NULL,0,'UB',v_release_amt_ub,'P',SYSDATE);
                    END IF;
                END IF;
              ELSIF v_roomid = 'UB' THEN

                    --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_account AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET MARKED = MARKED - v_release_qtty,MARKEDCOM = MARKEDCOM - v_release_qtty_ub
                      WHERE acctno = p_account AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_account, p_symbol, 0, 0,
                                       0, -v_release_qtty, 0, 0, SYSDATE, -v_release_qtty_ub);
                    END IF;

               /*
                UPDATE PORTFOLIOS SET MARKED = MARKED - v_release_qtty,MARKEDCOM = MARKEDCOM - v_release_qtty_ub
                WHERE ACCTNO = p_account AND SYMBOL = p_symbol;
                */
                IF (v_release_qtty_ub >0) THEN
                  INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                  VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, p_symbol, p_account, v_release_qtty_ub, null, 'C', 'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
                END IF;
                IF (v_release_qtty >0) THEN
                  INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                  VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, p_symbol, p_account, v_release_qtty, null, 'C', 'R', null, 0, 'SYSTEM', v_release_amt, 'P', SYSDATE);
                END IF;
              END IF;
              --nha room
              CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal+v_add_amt-v_fee,v_td,v_t0value,p_order_id,p_side,p_symbol,p_qtty,p_err_msg);
              /* dung.bui added code , date 25/11/2015 */
              -- Danh dau sang CK khac neu tai san danh dau < du no
              CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal+v_add_amt-v_fee,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);
              /*end*/
            END IF;
          END IF;
        END IF;
      END IF;

      --Tang ung truoc tien ban
      IF (p_sub_side = 'NS') THEN -- ban thuong
        UPDATE accounts set CALC_ADVBAL = CALC_ADVBAL + TRUNC(v_add_amt-v_fee,2) WHERE ACCTNO = p_account;
      ELSIF (p_sub_side = 'MS') THEN -- ban cam co
        UPDATE accounts set CALC_SELLMORT = CALC_SELLMORT + TRUNC(v_add_amt-v_fee,2) WHERE ACCTNO = p_account;
      ELSIF (p_sub_side = 'TS') THEN
        IF (p_qtty >= v_remain_qtty - v_mort_qtty) THEN
          v_trade := (v_remain_qtty - v_mort_qtty)*p_price*(1-(p_rate_tax/100)-(p_rate_brk/100));
          v_mortgage := (p_qtty - (v_remain_qtty - v_mort_qtty)) * p_price*(1-(p_rate_tax/100)-(p_rate_brk/100));

          UPDATE ACCOUNTS SET CALC_ADVBAL=CALC_ADVBAL+TRUNC(v_trade-v_fee,2),CALC_SELLMORT=CALC_SELLMORT+TRUNC(v_mortgage-v_fee,2)
          WHERE ACCTNO = p_account;

          UPDATE ORDERS SET MORT_QTTY=MORT_QTTY-(p_qtty-(v_remain_qtty-v_mort_qtty)) WHERE ORDERID=p_order_id;
        ELSE
          UPDATE ACCOUNTS SET CALC_ADVBAL = CALC_ADVBAL + TRUNC(v_add_amt-v_fee,2) WHERE ACCTNO=p_account;
        END IF;
      END IF;
    END IF;

        EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:='sp_proces_order_replace '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_order_replace;


  PROCEDURE sp_proces_order_confirm(p_err_code in OUT VARCHAR,
        p_order_id IN VARCHAR, --so hieu lenh
        p_exchange_code in VARCHAR, --ma xac nhan tu so
        p_status in VARCHAR, --trang thai tra ve tu so
        p_txdate in varchar, --ngay giao dich
        p_LastQty IN NUMBER, --khoi luong co hieu luc tren so
        p_LastPx IN NUMBER, --
        p_LeavesQty IN NUMBER, --khoi luong thay doi so voi lenh goc
        p_OrderQty2 IN NUMBER,
        p_err_msg OUT VARCHAR2
    )
  AS
    v_side                ORDERS.SIDE%TYPE;
    v_sub_side        ORDERS.SUBSIDE%TYPE;
    v_status              ORDERS.STATUS%TYPE;
    v_sub_status      ORDERS.SUBSTATUS%TYPE;
    v_acctno              ORDERS.ACCTNO%TYPE;
    v_symbol              ORDERS.SYMBOL%TYPE;
    v_reforderid      ORDERS.REFORDERID%TYPE;
    v_quote_qtty      ORDERS.QUOTE_QTTY%TYPE;
    v_remain_qtty   ORDERS.REMAIN_QTTY%TYPE;
    v_quote_price   ORDERS.QUOTE_PRICE%TYPE;
    v_typecd              ORDERS.TYPECD%TYPE;
    v_userid              ORDERS.USERID%TYPE;
    v_quoteid           ORDERS.QUOTEID%TYPE;
    v_sessionnex        ORDERS.SESSIONEX%TYPE;
    v_new_orderid   VARCHAR(20);
    v_currtime          TIMESTAMP;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_order_confirm p_order_id=>'||p_order_id;
      BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
      END;

      --lay thong tin lenh duoc xac nhan(co the la lenh huy/sua)
      SELECT SIDE,SUBSIDE,STATUS,SUBSTATUS,ACCTNO,SYMBOL,REFORDERID,QUOTE_QTTY,
          REMAIN_QTTY,QUOTE_PRICE,TYPECD,USERID,QUOTEID,SESSIONEX
      INTO v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,
          v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex
      FROM ORDERS WHERE ORDERID = p_order_id;
      IF v_status !='D' AND v_status !='E'  THEN
          --dbms_output.put_line('Xac nhan lenh cua so cho lenh moi');
          UPDATE ORDERS SET CONFIRMID=p_exchange_code,STATUS='S',SUBSTATUS='SS',LASTCHANGE=v_currtime
          WHERE ORDERID = p_order_id AND SUBSTATUS='BB';
          --23/12/2015,AnhHT sua cho truong hop confirm ve sau giai toa
          UPDATE ORDERS SET CONFIRMID=p_exchange_code,LASTCHANGE=v_currtime
          WHERE ORDERID = p_order_id AND SUBSTATUS='FF' AND CONFIRMID IS NULL;
      ELSE  --tin hieu xac nhan cho lenh huy sua
        IF v_status = 'D' THEN --lenh huy

          sp_proces_confirm_cancel(p_err_code,p_order_id,p_exchange_code,p_status,p_txdate,v_side,v_sub_side,
              v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,v_remain_qtty,v_quote_price,
              v_typecd,v_userid,v_quoteid,v_sessionnex,p_LeavesQty,p_err_msg);

          IF v_sub_status = 'DE' THEN --voi lenh huy san HSX sinh lenh moi
            --lay thong tin lenh goc
            SELECT SIDE INTO v_side FROM ORDERS WHERE ORDERID = v_reforderid;
            --cap nhat yc dat lenh
            UPDATE QUOTES SET SIDE = v_side WHERE QUOTEID = v_quoteid;

            CSPKS_FO_ORDER_NEW.sp_generate_new_order_HSX(p_err_code,v_new_orderid,p_order_id,'','S',p_txdate,
              v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,
              v_remain_qtty,v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex,p_err_msg);
          END IF;

        ELSIF v_status = 'E' THEN --lenh sua
          sp_proces_order_confirm_edit(p_err_code,p_order_id,p_exchange_code,p_status,p_txdate,
              v_side,v_sub_side,v_status,v_sub_status,v_acctno,
              v_symbol,v_reforderid,v_quote_qtty,v_remain_qtty,v_quote_price,p_LastQty,p_LastPx,p_LeavesQty,p_OrderQty2,p_err_msg);
        ELSE
              p_err_code := '-90017';
        END IF;
      END IF;

  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_order_confirm '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_order_confirm;

  -- Xac nhan lenh sua cho san HNX
  PROCEDURE sp_proces_order_confirm_edit(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_txdate in VARCHAR, --ngay giao dich
                p_side IN VARCHAR,-- mua hay ban
                p_sub_side IN VARCHAR,
                p_order_status IN VARCHAR, --trang thai cua lenh
                p_sub_status IN VARCHAR,
                p_acctno IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_reforderid IN VARCHAR, -- thong tin lenh goc
                p_quote_qtty IN number, --khoi luong quote
                p_remain_qtty IN number, --khoi luong con lai
                p_quote_price IN number, --gia huy/sua
                p_LastQty IN NUMBER, --khoi luong co hieu luc tren so
                p_LastPx IN NUMBER, --
                p_LeavesQty IN NUMBER, --khoi luong thay doi so voi lenh goc
                p_OrderQty2 IN NUMBER,
                p_err_msg OUT VARCHAR2
              )
  AS
        v_currtime                TIMESTAMP;
    v_stock_value           NUMBER;
    v_stock_value_ub        NUMBER;
    v_release_qtty          NUMBER;
    v_release_qtty_ub     NUMBER;
    v_release_amt           NUMBER;
    v_release_amt_ub        NUMBER;
    v_price_asset           NUMBER;
    v_rate_asset              NUMBER;
    v_count                     NUMBER;
        v_buyamt                    NUMBER;
        v_add_pool                NUMBER;
        v_remain_value          NUMBER; --phan chenh dat lenh
    v_side                      ORDERS.SIDE%TYPE;
    v_sub_side                ORDERS.SUBSIDE%TYPE;
    v_acctno                    ORDERS.ACCTNO%TYPE;
    v_symbol                    ORDERS.SYMBOL%TYPE;
    v_quote_qtty              ORDERS.QUOTE_QTTY%TYPE;
    v_remain_qtty           ORDERS.REMAIN_QTTY%TYPE;
    v_quote_price           ORDERS.QUOTE_PRICE%TYPE;
    v_exec_qtty               ORDERS.EXEC_QTTY%TYPE;
    v_rate_brk                ORDERS.RATE_BRK%TYPE;
    v_balance                 ACCOUNTS.BOD_BALANCE%TYPE;
    v_payable                 ACCOUNTS.BOD_PAYABLE%TYPE;
    v_debt                      ACCOUNTS.BOD_DEBT%TYPE;
    v_advbal                    ACCOUNTS.CALC_ADVBAL%TYPE;
    v_odramt                    ACCOUNTS.CALC_ODRAMT%TYPE;
    v_formulacd               ACCOUNTS.FORMULACD%TYPE;
        v_poolid                    ACCOUNTS.POOLID%TYPE;
        v_roomid                    ACCOUNTS.ROOMID%TYPE;
    v_td                        ACCOUNTS.BOD_TD%TYPE;
    v_t0value                 ACCOUNTS.BOD_T0VALUE%TYPE;
    v_bod_adv                 ACCOUNTS.BOD_ADV%TYPE;
        v_basketid                ACCOUNTS.BASKETID%TYPE;
    v_basketid_ub             ACCOUNTS.BASKETID_UB%TYPE;
    v_bod_debt_t0         ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin        ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_bod_d_margin_ub     ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_marked                    PORTFOLIOS.MARKED%TYPE;
    v_markedcom               PORTFOLIOS.MARKEDCOM%TYPE;
        v_ownroomid           VARCHAR(20);
        v_release_pool        NUMBER;
    v_edit_qtty           NUMBER; --khoi luong sua ma nguoi dung nhap vao

    v_markedEX          NUMBER;
    v_markedcomEX       NUMBER;
  BEGIN
    p_err_msg:='sp_proces_order_confirm_edit p_order_id=>'||p_order_id;
    BEGIN
      execute immediate
      'select tt_sysdate from dual' into v_currtime;
    END;

    --Lay thong tin lenh goc
    SELECT SIDE,SUBSIDE,ACCTNO,SYMBOL,QUOTE_QTTY,REMAIN_QTTY,QUOTE_PRICE,EXEC_QTTY,RATE_BRK
    INTO v_side,v_sub_side,v_acctno,v_symbol,v_quote_qtty,v_remain_qtty,v_quote_price,v_exec_qtty,v_rate_brk
    FROM ORDERS WHERE ORDERID = p_reforderid;

    --Lay thong tin accounts
    SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,CALC_ADVBAL,BOD_TD,CALC_ODRAMT,POOLID,ROOMID,
      BOD_T0VALUE,BOD_ADV,BASKETID,BASKETID_UB,FORMULACD,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB
    INTO v_balance,v_payable,v_debt,v_advbal,v_td,v_odramt,v_poolid,v_roomid,
      v_t0value,v_bod_adv,v_basketid,v_basketid_ub,v_formulacd,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub
    FROM ACCOUNTS WHERE acctno = p_acctno;

    --    v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
    v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt_edit_order(p_acctno);

    /*tiendt fix bug for show valid qtty on scress
     date: 22/10/2015
    */
    v_edit_qtty :=   p_quote_qtty + v_exec_qtty;
    /*end*/
    --tinh phan chenh sua lenh = gia tri lenh goc - gia tri lenh sua
    --v_remain_value := (v_quote_qtty * v_quote_price) - (v_edit_qtty * p_quote_price);
    --ThanhNV sua 2016.03.04
    v_remain_value := (v_remain_qtty * v_quote_price) - (p_quote_qtty * p_quote_price);  --phan con lai goc - phan con lai sua.

    v_buyamt := ((v_edit_qtty - v_exec_qtty)*p_quote_price - (v_remain_qtty*v_quote_price))*((1+v_rate_brk/100));

    IF p_status = 'S' THEN --trang thai tra ve thanh cong

      IF v_remain_value > 0 THEN --Lenh sua giam
        v_remain_value := v_remain_value * (1+v_rate_brk/100);

        IF v_sub_side = 'NB' OR v_sub_side = 'AB' THEN --sua mua

          SELECT COUNT(1) INTO v_count FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = p_symbol;
          IF (v_count = 0) THEN
            v_price_asset:=0;
            v_rate_asset:=0;
          ELSE
            --lay thong tin bang basket
            SELECT PRICE_ASSET,RATE_ASSET INTO v_price_asset,v_rate_asset FROM BASKETS WHERE BASKETID=v_basketid AND SYMBOL=p_symbol;
          END IF;

          --Giam ky quy mua
          --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT + v_buyamt WHERE ACCTNO = p_acctno;

          /*dung.bui fix kl sua so tra ve, date 23/11/2015*/
          IF (p_remain_qtty > p_LastQty) THEN

            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
            IF v_count > 0 THEN
              UPDATE portfoliosex SET BUYINGQTTY=BUYINGQTTY-(v_quote_qtty-v_edit_qtty)-(p_remain_qtty-p_LastQty) WHERE acctno = p_acctno AND symbol=p_symbol;
            ELSE
              INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                              sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                               VALUES (p_acctno, p_symbol, -(v_quote_qtty-v_edit_qtty)-(p_remain_qtty-p_LastQty), 0,
                               0, 0, 0, 0, SYSDATE, 0);
            END IF;
            /*
            UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-(v_quote_qtty-v_edit_qtty)-(p_remain_qtty-p_LastQty)
            WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
            */

            UPDATE ORDERS SET REMAIN_QTTY =  p_LastQty,QUOTE_QTTY =  p_LastQty WHERE ORDERID = p_order_id;
          ELSE
            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
            IF v_count > 0 THEN
              UPDATE portfoliosex SET BUYINGQTTY=BUYINGQTTY-(v_quote_qtty-v_edit_qtty) WHERE acctno = p_acctno AND symbol=p_symbol;
            ELSE
              INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                              sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                               VALUES (p_acctno, p_symbol, -(v_quote_qtty-v_edit_qtty), 0,
                               0, 0, 0, 0, SYSDATE, 0);
            END IF;
            /*
            UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-(v_quote_qtty-v_edit_qtty) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
            */
          END IF;
          --Cap nhat bang portfolios
          --UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-(v_quote_qtty-v_edit_qtty) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
          /*end*/
          --Nha Pool, nha Room
          IF (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
            v_release_pool:=CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code,v_remain_value,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
            IF v_release_pool > 0 AND (v_poolid IS NOT NULL) THEN
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,p_side,p_symbol,p_acctno,v_poolid,v_release_pool,v_edit_qtty,p_quote_price,p_err_msg);
            END IF;

            IF (v_roomid IS NOT NULL) THEN
                SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                BEGIN
                   SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                EXCEPTION WHEN OTHERS THEN
                    v_markedEX :=0;
                    v_markedcomEX:=0;
                END;
                v_marked:=v_marked + v_markedEX;
                v_markedcom:=v_markedcom +  v_markedcomEX;


                v_release_qtty := LEAST(v_marked,ABS(v_quote_qtty-v_edit_qtty));
                v_release_qtty_ub := LEAST(v_markedcom,ABS(v_quote_qtty-v_edit_qtty));

                v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
                v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));

                --insert allocation
                IF v_roomid = 'SYSTEM' THEN

                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET MARKED= MARKED - v_release_qtty WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, 0,
                                       0, -v_release_qtty, 0, 0, SYSDATE, 0);
                    END IF;
                  --UPDATE PORTFOLIOS SET MARKED = MARKED - v_release_qtty WHERE ACCTNO = p_acctno AND SYMBOL = p_symbol;

                  IF (v_release_qtty > 0) THEN
                    INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                    VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, v_symbol, p_acctno, v_release_qtty, null, 'C', 'R', null, 0, v_roomid, v_release_amt, 'P', SYSDATE);
                  END IF;
                  IF (v_basketid !=v_basketid_ub) THEN --tk dong tai tro
                    --dbms_output.put_line('nha room ub');

                    --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, 0,
                                       0, 0, 0, 0, SYSDATE, -v_release_qtty_ub);
                    END IF;
                    /*
                    UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                    */

                    IF v_release_qtty_ub > 0 THEN
                      INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                        DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                      VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_acctno,v_release_qtty_ub,NULL,
                        'C','R',NULL,0,'UB',v_release_amt_ub,'P',SYSDATE);
                  END IF;
                END IF;
                ELSIF v_roomid = 'UB' THEN
                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, 0,
                                       0, -v_release_qtty, 0, 0, SYSDATE, -v_release_qtty_ub);
                    END IF;
                  /*
                  UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                  */

                  IF (v_release_qtty_ub > 0) THEN
                    INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                    VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, v_symbol, p_acctno, v_release_qtty_ub, null, 'C', 'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
                  END IF;
                  IF (v_release_qtty > 0) THEN
                    INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                    VALUES (SEQ_COMMON.NEXTVAL,p_order_id,p_side,v_symbol,p_acctno,v_release_qtty,null,'C','R',null,0,'SYSTEM',v_release_amt,'P',SYSDATE);
                  END IF;
                END IF;

                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_roomid',v_roomid);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_payable',v_payable);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_bod_debt_t0',v_bod_debt_t0);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_bod_d_margin',v_bod_d_margin);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_bod_d_margin_ub',v_bod_d_margin_ub);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_ordamt',v_odramt);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'0','0');
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_balance',v_balance);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_bod_adv',v_bod_adv);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_advbal',v_advbal);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_td',v_td);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_t0value',v_t0value);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'p_order_id',p_order_id);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'p_side',p_side);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'p_symbol',p_symbol);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUAMUA_GIAM',p_acctno,p_order_id,'v_remain_qtty',p_LastQty);

                --nha danh dau
                CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_order_id,p_side,p_symbol,v_quote_qtty-v_edit_qtty/*p_quote_qtty*/,p_err_msg);

                -- Danh dau sang CK khac neu tai san danh dau < du no
                CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);
--              END IF;
            END IF;
          END IF;

        ELSE --sua ban;
          /*tiendt:modified cho khoi luong xac nhan sua tu so khac khoi luong con lai cua lenh
          date: 2015-11-19
          */
--          IF(v_sub_side = 'NS') OR (v_sub_side = 'AS') THEN
--            UPDATE PORTFOLIOS SET SELLINGQTTY=SELLINGQTTY-(v_quote_qtty-v_edit_qtty/*p_quote_qtty*/) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
--          ELSIF (v_sub_side = 'MS') OR (v_sub_side = 'AM') THEN
--            UPDATE PORTFOLIOS SET SELLINGQTTYMORT=SELLINGQTTYMORT-(v_quote_qtty-v_edit_qtty/*p_quote_qtty*/) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
--          END IF;
           insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUA_BAN_GIAM',p_acctno,p_order_id,'p_remain_qtty',p_remain_qtty);
           insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUA_BAN_GIAM',p_acctno,p_order_id,'p_LastQty',p_LastQty);
           insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUA_BAN_GIAM',p_acctno,p_order_id,'v_edit_qtty',v_edit_qtty);
           insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUA_BAN_GIAM',p_acctno,p_order_id,'v_quote_qtty',v_quote_qtty);
           insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUA_BAN_GIAM',p_acctno,p_order_id,'p_remain_qtty',p_remain_qtty);
           insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'SUA_BAN_GIAM',p_acctno,p_order_id,'p_LastQty',p_LastQty);
           IF (p_remain_qtty - p_LastQty) > 0 THEN
              UPDATE ORDERS SET REMAIN_QTTY =  p_LastQty,QUOTE_QTTY =  p_LastQty WHERE ORDERID = p_order_id;
              IF(v_sub_side = 'NS') OR (v_sub_side = 'AS') THEN
                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET SELLINGQTTY = SELLINGQTTY-(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty) WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, -(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty),
                                       0, 0, 0, 0, SYSDATE, 0);
                    END IF;

                  /*
                  UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY-(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty)
                  WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                  */
              ELSIF (v_sub_side = 'MS') OR (v_sub_side = 'AM') THEN
                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET SELLINGQTTYMORT=SELLINGQTTYMORT-(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty)
                      WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, 0,
                                       -(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty), 0, 0, 0, SYSDATE, 0);
                    END IF;
                  /*
                  UPDATE PORTFOLIOS SET SELLINGQTTYMORT=SELLINGQTTYMORT-(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty)
                  WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                  */
              END IF;
          ELSE
              IF(v_sub_side = 'NS') OR (v_sub_side = 'AS') THEN
                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET SELLINGQTTY = SELLINGQTTY-(v_quote_qtty-v_edit_qtty)
                      WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, -(v_quote_qtty-v_edit_qtty),
                                       0, 0, 0, 0, SYSDATE, 0);
                    END IF;
                  /*
                  UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY-(v_quote_qtty-v_edit_qtty)
                  WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                  */
              ELSIF (v_sub_side = 'MS') OR (v_sub_side = 'AM') THEN
                  --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET SELLINGQTTYMORT=SELLINGQTTYMORT-(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty)
                      WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, 0,
                                       (v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty), 0, 0, 0, SYSDATE, 0);
                    END IF;
                  /*
                  UPDATE PORTFOLIOS SET SELLINGQTTYMORT=SELLINGQTTYMORT-(v_quote_qtty-v_edit_qtty) + (p_remain_qtty - p_LastQty)
                  WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                  */
              END IF;
           END IF;
          /*end*/

        END IF;

      /*tien.do added, cho truong hop msg khop ve truoc confirm sua */
      ELSIF v_remain_value < 0 THEN --Lenh sua tang
        UPDATE ORDERS SET REMAIN_QTTY =  p_LastQty,QUOTE_QTTY =  p_LastQty WHERE ORDERID = p_order_id;
      END IF;
      /*end*/
      --Cap nhat lenh sua
      UPDATE ORDERS SET CONFIRMID = p_exchange_code,SUBSTATUS='ES',LASTCHANGE = v_currtime WHERE ORDERID = p_order_id;
      --Cap nhat lenh goc
      UPDATE ORDERS SET STATUS = 'E',SUBSTATUS='EE', ADMEND_QTTY= p_quote_qtty/*v_remain_qtty*/,
      REMAIN_QTTY = 0,LASTCHANGE = v_currtime WHERE ORDERID = p_reforderid;

    ELSE --Trang thai tra ve khong thanh cong
      --Cap nhat lenh sua
      UPDATE ORDERS SET CONFIRMID = p_exchange_code,SUBSTATUS='EN', LASTCHANGE = v_currtime WHERE ORDERID = p_order_id;
      --Cap nhat lenh goc
      IF (v_side = 'B') OR (v_side = 'S') THEN --lenh mua hoac ban
        UPDATE ORDERS SET STATUS = 'S',SUBSTATUS='SS', LASTCHANGE = v_currtime WHERE ORDERID = p_reforderid;
      ELSE --lenh sua
        UPDATE ORDERS SET STATUS = 'E',SUBSTATUS='ES', LASTCHANGE = v_currtime WHERE ORDERID = p_reforderid;
      END IF;

      IF v_remain_value < 0 THEN --Lenh sua tang
        IF v_sub_side = 'NB' OR v_sub_side = 'AB' THEN --sua mua
          --Lay thong tin accounts
          SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,CALC_ADVBAL,BOD_TD,CALC_ODRAMT,POOLID,ROOMID,BOD_ADV,FORMULACD
          INTO v_balance,v_payable,v_debt,v_advbal,v_td,v_odramt,v_poolid,v_roomid,v_bod_adv,v_formulacd
          FROM ACCOUNTS WHERE ACCTNO = p_acctno;

          v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);

          --Nha Pool, nha Room
          IF (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
            v_add_pool := CSPKS_FO_POOLROOM.fn_get_using_pool(p_err_code, /*v_remain_value*/v_buyamt,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
            IF v_add_pool > 0 AND (v_poolid IS NOT NULL) THEN
                CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,p_side,p_symbol,p_acctno,v_poolid,v_add_pool,v_edit_qtty/*p_quote_qtty*/,p_quote_price,p_err_msg);
            END IF;
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_payable,
              v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,
                v_td,v_t0value,p_order_id,p_side,p_symbol,/*p_quote_qtty*/v_edit_qtty-v_quote_qtty,p_err_msg);
          END IF;

          --Giam ky quy mua
          --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT - v_buyamt WHERE ACCTNO = p_acctno;

          /*date: 2014-12-03 : 5h,author: dung.bui
          descrition: sua doan code cap nhat gia tri portfolios
          */
          --UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY - (v_quote_qtty - p_quote_qtty) WHERE acctno = p_acctno AND symbol=v_symbol;
          --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            IF v_edit_qtty > v_quote_qtty THEN --Chi giai toa lenh sua mua tang khoi luong.
              SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=v_symbol;
              IF v_count > 0 THEN
                UPDATE portfoliosex SET BUYINGQTTY=BUYINGQTTY-(v_edit_qtty-v_quote_qtty) WHERE acctno = p_acctno AND symbol=v_symbol;
              ELSE
                INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                 VALUES (p_acctno, v_symbol, -(v_edit_qtty-v_quote_qtty), 0,
                                 0, 0, 0, 0, SYSDATE,0);
              END IF;

          /*
          UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-(v_edit_qtty-v_quote_qtty) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
          */
          /*end*/
            END IF;
        ELSE --sua ban
          IF(v_sub_side = 'NS') OR (v_sub_side = 'AS') THEN

              --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
              IF v_edit_qtty > v_quote_qtty THEN --Chi giai toa lenh sua ban tang khoi luong.
                  SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=v_symbol;
                  IF v_count > 0 THEN
                    UPDATE portfoliosex SET SELLINGQTTY = SELLINGQTTY-(v_edit_qtty-v_quote_qtty) WHERE acctno = p_acctno AND symbol=v_symbol;
                  ELSE
                    INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                    sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                     VALUES (p_acctno, v_symbol, 0, -(v_edit_qtty-v_quote_qtty),
                                     0, 0, 0, 0, SYSDATE,0);
                  END IF;
                  /*
                  UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY-(v_edit_qtty-v_quote_qtty) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                  */
              END IF;
          ELSIF (v_sub_side = 'MS') OR (v_sub_side = 'AM') THEN
                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=v_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET SELLINGQTTYMORT = SELLINGQTTYMORT - (v_edit_qtty-v_quote_qtty) WHERE acctno = p_acctno AND symbol=v_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, v_symbol, 0, 0,
                                   - (v_edit_qtty-v_quote_qtty), 0, 0, 0, SYSDATE,0);
                END IF;
              /*
              UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - (v_edit_qtty-v_quote_qtty) WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
              */
          END IF;
        END IF;
      END IF;

    END IF;

  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_order_confirm_edit '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_proces_order_confirm_edit;

    PROCEDURE sp_proces_confirm_free_order(p_err_code in OUT VARCHAR,
            p_orderid IN VARCHAR,
            p_side IN VARCHAR,
            p_subside IN VARCHAR,
            p_acctno IN VARCHAR,
            p_symbol IN VARCHAR,
            p_freed_qtty IN NUMBER,
            p_remain_qtty IN NUMBER,
            p_mort_qtty IN NUMBER,
            p_quote_price IN NUMBER,
            p_err_msg OUT VARCHAR2,
            p_mode IN VARCHAR)--I:internal
    AS
      v_bod_balance               ACCOUNTS.BOD_BALANCE%TYPE;
      v_bod_payable               ACCOUNTS.BOD_PAYABLE%TYPE;
      v_bod_debt                ACCOUNTS.BOD_DEBT%TYPE;
      v_calc_advbal               ACCOUNTS.CALC_ADVBAL%TYPE;
      v_bod_td                    ACCOUNTS.BOD_TD%TYPE;
      v_calc_odramt               ACCOUNTS.CALC_ODRAMT%TYPE;
      v_poolid                    ACCOUNTS.POOLID%TYPE;
      v_roomid                    ACCOUNTS.ROOMID%TYPE;
      v_ratebrk_s               ACCOUNTS.RATE_BRK_S%TYPE;
      v_ratebrk_b               ACCOUNTS.RATE_BRK_B%TYPE;
      v_bod_t0value               ACCOUNTS.BOD_T0VALUE%TYPE;
      v_bod_adv                     ACCOUNTS.BOD_ADV%TYPE;
      v_basketid                    ACCOUNTS.BASKETID%TYPE;
      v_cficode                     INSTRUMENTS.CFICODE%TYPE;
      v_price_asset               BASKETS.PRICE_ASSET%TYPE :=0;
      v_rate_asset              BASKETS.RATE_ASSET%TYPE :=0;
      v_add_pool                    NUMBER;
      v_freed_amt               NUMBER;
      v_ratebrk                     NUMBER;
      v_currtime                    TIMESTAMP;
      v_release_qtty_sys        NUMBER;
      v_release_qtty_ub         NUMBER;
      v_stock_value_sys         NUMBER;
      v_stock_value_ub        NUMBER;
      v_release_amt_sys         NUMBER;
      v_release_amt_ub        NUMBER;
      v_count                     NUMBER;
      v_bod_debt_t0         ACCOUNTS.BOD_DEBT_T0%TYPE;
      v_bod_d_margin        ACCOUNTS.BOD_D_MARGIN%TYPE;
      v_bod_d_margin_ub     ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
      v_release_pool        NUMBER;
      v_marked              PORTFOLIOS.MARKED%TYPE;
      v_markedcom           PORTFOLIOS.MARKEDCOM%TYPE;
      v_formulacd           ACCOUNTS.FORMULACD%TYPE;
      v_basketid_ub                 ACCOUNTS.BASKETID_UB%TYPE;
      v_markedEX          NUMBER;
      v_markedcomEX       NUMBER;
    BEGIN
    p_err_code := '0';
    p_err_msg:='sp_proces_confirm_free_order p_orderid=>'||p_orderid;
      BEGIN
        EXECUTE IMMEDIATE 'select tt_sysdate from dual' INTO v_currtime;
      END;

      -- Selling or amend selling order
      IF (p_subside = 'NS') OR (p_subside = 'AS') THEN
         --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
        SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
        IF v_count > 0 THEN
          UPDATE portfoliosex SET  sellingqtty = sellingqtty - p_freed_qtty  WHERE acctno = p_acctno AND symbol=p_symbol;
        ELSE
          INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                           VALUES (p_acctno, p_symbol, 0, - p_freed_qtty,
                           0, 0, 0, 0, SYSDATE, 0);
        END IF;
         /*
         UPDATE portfolios SET sellingqtty = sellingqtty - p_freed_qtty WHERE acctno=p_acctno AND symbol=p_symbol;
         */
      ELSIF (p_subside = 'MS') OR (p_subside = 'AM') THEN
          --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
            IF v_count > 0 THEN
              UPDATE portfoliosex SET  sellingqttymort = sellingqttymort - p_freed_qtty WHERE acctno = p_acctno AND symbol=p_symbol;
            ELSE
              INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                              sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                               VALUES (p_acctno, p_symbol, 0, 0,
                               - p_freed_qtty, 0, 0, 0, SYSDATE, 0);
            END IF;
         /*
         UPDATE portfolios SET sellingqttymort = sellingqttymort - p_freed_qtty WHERE acctno=p_acctno AND symbol=p_symbol;
         */
      ELSIF (p_subside = 'TS') THEN
        IF (p_remain_qtty <= p_mort_qtty) THEN

          --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
            IF v_count > 0 THEN
              UPDATE portfoliosex SET  SELLINGQTTYMORT = SELLINGQTTYMORT - p_remain_qtty WHERE acctno = p_acctno AND symbol=p_symbol;
            ELSE
              INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                              sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                               VALUES (p_acctno, p_symbol, 0, 0,
                               - p_freed_qtty, 0, 0, 0, SYSDATE, 0);
            END IF;

          /*
          UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - p_remain_qtty
          WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
          */
        ELSE
            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
            IF v_count > 0 THEN
              UPDATE portfoliosex SET  SELLINGQTTYMORT = SELLINGQTTYMORT - p_mort_qtty, SELLINGQTTY =  SELLINGQTTY - (p_remain_qtty - p_mort_qtty)
              WHERE acctno = p_acctno AND symbol=p_symbol;
            ELSE
              INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                              sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                               VALUES (p_acctno, p_symbol, 0, - (p_remain_qtty - p_mort_qtty),
                               - p_mort_qtty, 0, 0, 0, SYSDATE, 0);
            END IF;

          /*
          UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - p_mort_qtty, SELLINGQTTY =  SELLINGQTTY - (p_remain_qtty - p_mort_qtty)
          WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
          */
        END IF;

        UPDATE ORDERS SET MORT_QTTY = MORT_QTTY - p_mort_qtty WHERE ORDERID=p_orderid;

      -- Buying or amend buying order
      ELSIF (p_subside = 'NB') OR (p_subside = 'AB') THEN

        SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,CALC_ADVBAL,BOD_TD,POOLID,ROOMID,RATE_BRK_S,RATE_BRK_B,
          BOD_T0VALUE,BOD_ADV,BASKETID,FORMULACD,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB,BASKETID_UB
        INTO v_bod_balance,v_bod_payable,v_bod_debt,v_calc_advbal,v_bod_td,v_poolid,v_roomid,v_ratebrk_s,v_ratebrk_b,
        v_bod_t0value,v_bod_adv,v_basketid,v_formulacd,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_basketid_ub
        FROM ACCOUNTS WHERE ACCTNO=p_acctno;
          /*
        tiendt added for buy amount
        date: 2015-08-24
        */
        v_calc_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
        /*end*/
        SELECT COUNT(1) INTO v_count FROM BASKETS WHERE BASKETID=v_basketid AND SYMBOL=p_symbol;
        IF (v_count = 1) THEN
          SELECT PRICE_ASSET, RATE_ASSET INTO v_price_asset, v_rate_asset FROM BASKETS WHERE BASKETID=v_basketid AND SYMBOL=p_symbol;
        END IF;

        SELECT CFICODE INTO v_cficode FROM INSTRUMENTS WHERE SYMBOL=p_symbol;
        IF v_cficode = 'ES' THEN
          v_ratebrk := v_ratebrk_s;
        ELSE
          v_ratebrk := v_ratebrk_b;
        END IF;

        --Cap nhat ky quy mua
        v_freed_amt := NVL(p_freed_qtty * p_quote_price * (1+v_ratebrk/100),0);

        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAI_TOA',p_acctno,null,'p_freed_qtty',p_freed_qtty);
       -- UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT - v_freed_amt WHERE ACCTNO=p_acctno;

       --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
        SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
        IF v_count > 0 THEN
          UPDATE portfoliosex SET BUYINGQTTY = BUYINGQTTY - p_freed_qtty
          WHERE acctno = p_acctno AND symbol=p_symbol;
        ELSE
          INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                           VALUES (p_acctno, p_symbol, -p_freed_qtty, 0,
                          0, 0, 0, 0, SYSDATE, 0);
        END IF;

       /*
        UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY - p_freed_qtty WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
         */
        /*date 30/10/2015, dung.bui add code for fix bug process poolroom free order */
        -- Xu li poolroom
        IF (v_formulacd != 'CASH') AND (v_formulacd != 'ADV') THEN
          v_release_pool:=CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code,v_freed_amt,v_bod_balance,
            v_calc_advbal+v_bod_adv,v_bod_payable,v_bod_debt,v_calc_odramt,v_bod_td,v_bod_t0value,p_err_msg);

          IF v_release_pool > 0 AND (v_poolid IS NOT NULL) THEN
            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_orderid,p_side,p_symbol,p_acctno,v_poolid,v_release_pool,0,null,p_err_msg);

          END IF;
          IF v_roomid IS NOT NULL THEN
            SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            BEGIN
                SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
            EXCEPTION WHEN OTHERS THEN
                v_markedEX :=0;
                v_markedcomEX:=0;
            END;
            v_marked:=v_marked + v_markedEX;
            v_markedcom:=v_markedcom +  v_markedcomEX;

            --so luong chung khoan nha danh dau
            v_release_qtty_sys := LEAST(v_marked,p_freed_qtty);
            v_release_qtty_ub := LEAST(v_markedcom,p_freed_qtty);

            v_release_amt_sys := v_release_qtty_sys * (v_price_asset * (v_rate_asset / 100));
            v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));
            --insert allocation

            IF v_roomid = 'SYSTEM' THEN

              --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
            IF v_count > 0 THEN
              UPDATE portfoliosex SET MARKED=MARKED-v_release_qtty_sys WHERE acctno = p_acctno AND symbol=p_symbol;
            ELSE
              INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                              sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                               VALUES (p_acctno, p_symbol, 0, 0,
                               0, -v_release_qtty_sys, 0, 0, SYSDATE, 0);
            END IF;

              /*
              UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty_sys WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
              */
              IF (v_release_amt_sys >0) THEN
                INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL,null,null,p_symbol,p_acctno,v_release_qtty_sys,null,'C','R',null,0,v_roomid,v_release_amt_sys,'P',SYSDATE);
              END IF;
              /* dung.bui fix bug releaseroom tk dong tai tro, 18/11/2015 */
              IF (v_basketid != v_basketid_ub) THEN --tk dong tai tro
                 --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_acctno AND symbol=p_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, p_symbol, 0, 0,
                                   0, 0, 0, 0, SYSDATE, -v_release_qtty_ub);
                END IF;

                /*
                UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                */
                IF (v_release_amt_ub >0) THEN
                  INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                  VALUES (SEQ_COMMON.NEXTVAL,null,null,p_symbol,p_acctno,v_release_qtty_ub,null,'C','R',null,0,'UB',v_release_amt_ub,'P',SYSDATE);
                END IF;
              END IF;
              /*end*/
            ELSIF v_roomid = 'UB' THEN
               --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKED=MARKED-v_release_qtty_sys,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_acctno AND symbol=p_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, p_symbol, 0, 0,
                                   0, -v_release_qtty_sys, 0, 0, SYSDATE, -v_release_qtty_ub);
                END IF;
              /*
              UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty_sys,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
             */
              IF (v_release_amt_ub >0) THEN
                INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL,null,null,p_symbol,p_acctno,v_release_qtty_ub,null,'C','R',null,0,v_roomid,v_release_amt_ub,'P',SYSDATE);
              END IF;
              IF (v_release_amt_sys>0) THEN
                INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL,null,null,p_symbol,p_acctno,v_release_qtty_sys,null,'C','R',null,0,'SYSTEM',v_release_amt_sys,'P',SYSDATE);
              END IF;
            END IF;

            CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_bod_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_calc_odramt-v_freed_amt,0,v_bod_balance,v_bod_adv,v_calc_advbal,v_bod_td,v_bod_t0value,p_orderid,p_side,p_symbol,p_freed_qtty,p_err_msg);

            --danh dau ma CK khac neu tai san danh dau < du no
            CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_bod_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_calc_odramt-v_freed_amt,0,v_bod_balance,v_bod_adv,v_calc_advbal,v_bod_td,v_bod_t0value,null,null,null,0,p_err_msg);

          END IF;
        END IF;
      END IF;


      -- Update status and quantity of original order
      IF p_mode = 'I' THEN
        UPDATE ORDERS SET STATUS='G', SUBSTATUS='GG', CANCEL_QTTY = p_freed_qtty, REMAIN_QTTY = REMAIN_QTTY - p_freed_qtty, FLAGORDER='E', LASTCHANGE=v_currtime
        WHERE ORDERID = p_orderid
        AND (SUBSTATUS='SS' OR SUBSTATUS='ES' OR SUBSTATUS='BB' OR SUBSTATUS='NN');
      ELSE
        UPDATE ORDERS SET STATUS='F', SUBSTATUS='FF', CANCEL_QTTY = p_freed_qtty, REMAIN_QTTY = REMAIN_QTTY - p_freed_qtty, FLAGORDER='E', LASTCHANGE=v_currtime
        WHERE ORDERID = p_orderid
        AND (SUBSTATUS='SS' OR SUBSTATUS='ES' OR SUBSTATUS='BB' OR SUBSTATUS='NN');
      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_confirm_free_order '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_confirm_free_order;

  --new function (san HSX)
    PROCEDURE sp_proces_confirm_cancel(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_txdate in VARCHAR, --ngay giao dich
                p_side IN VARCHAR,-- mua hay ban
                p_sub_side IN VARCHAR,
                p_order_status IN VARCHAR, --trang thai cua lenh
                p_sub_status IN VARCHAR,
                p_acctno IN VARCHAR, --so tieu khoan giao dich
                p_symbol IN VARCHAR, --ma chung khoan
                p_reforderid IN VARCHAR, --
                p_quote_qtty IN number, --khoi luong quote
                p_remain_qtty IN integer, --khoi luong con lai
                p_quote_price IN number, --gia huy/sua
                p_typecd IN VARCHAR,
                p_userid IN VARCHAR,
                p_quoteid IN VARCHAR,
                p_sessionnex IN VARCHAR,
                p_LeavesQty IN NUMBER,
                p_err_msg OUT VARCHAR2
              )
    AS
        v_add_pool                NUMBER;
        v_cancel_value          NUMBER;
        v_order_id                VARCHAR(20);
        v_currtime                TIMESTAMP;
        v_balance               ACCOUNTS.BOD_BALANCE%TYPE;
        v_payable               ACCOUNTS.BOD_PAYABLE%TYPE;
        v_debt                    ACCOUNTS.BOD_DEBT%TYPE;
        v_advbal                  ACCOUNTS.CALC_ADVBAL%TYPE;
        v_bod_adv               ACCOUNTS.BOD_ADV%TYPE;
        v_odramt                  ACCOUNTS.CALC_ODRAMT%TYPE;
        v_poolid                  ACCOUNTS.POOLID%TYPE;
        v_roomid                  ACCOUNTS.ROOMID%TYPE;
        v_td                      ACCOUNTS.BOD_TD%TYPE;
        v_basketid                ACCOUNTS.BASKETID%TYPE;
        v_basketid_ub       ACCOUNTS.BASKETID_UB%TYPE;
        v_ratebrk                   ORDERS.RATE_BRK%TYPE;
        v_old_side                ORDERS.SIDE%TYPE;
        v_old_subside           ORDERS.SUBSIDE%TYPE;
        v_mort_qtty             ORDERS.MORT_QTTY%TYPE;
        v_remain_qtty         ORDERS.REMAIN_QTTY%TYPE;
        v_quote_price           ORDERS.QUOTE_PRICE%TYPE;
        v_t0value               ACCOUNTS.BOD_T0VALUE%TYPE;
        v_formulacd             ACCOUNTS.FORMULACD%TYPE;
        v_release_qtty          NUMBER;
        v_release_qtty_ub   NUMBER;
        v_release_amt           NUMBER;
        v_release_amt_ub        NUMBER;
        v_price_asset           NUMBER;
        v_rate_asset              NUMBER;
        v_count                     NUMBER;
        v_marked                  PORTFOLIOS.MARKED%TYPE;
        v_markedcom             PORTFOLIOS.MARKEDCOM%TYPE;
        v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
        v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
        v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
        v_ownroomid         VARCHAR(20);
        v_release_pool      NUMBER;
        v_markedEX          NUMBER;
        v_markedcomEX       NUMBER;


    BEGIN

        p_err_code := '0';
        p_err_msg:='sp_proces_confirm_cancel p_order_id=>'||p_order_id;
        BEGIN
            execute immediate
            'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        -- lay thong tin lenh goc
        SELECT SIDE,SUBSIDE,MORT_QTTY,REMAIN_QTTY,QUOTE_PRICE,RATE_BRK INTO v_old_side,v_old_subside,v_mort_qtty,v_remain_qtty,v_quote_price,v_ratebrk
        FROM ORDERS WHERE ORDERID = p_reforderid;
        --Lay thong tin tai khoan
        SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,CALC_ADVBAL,BOD_ADV,BOD_TD,CALC_ODRAMT,POOLID,ROOMID,
            BOD_T0VALUE,BASKETID,BASKETID_UB,FORMULACD,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB
        INTO v_balance,v_payable,v_debt,v_advbal,v_bod_adv,v_td,v_odramt,v_poolid,v_roomid,
            v_t0value,v_basketid,v_basketid_ub,v_formulacd,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub
        FROM ACCOUNTS WHERE ACCTNO = p_acctno;

        IF (p_status = 'S') THEN --so tra ve thanh cong
            IF p_sub_side = 'CS'  THEN --lenh huy ban
                --cap nhat CK bang Portfolios
                IF(v_old_subside = 'NS') OR (v_old_subside = 'AS') THEN
                   --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET SELLINGQTTY=SELLINGQTTY-p_LeavesQty WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, -p_LeavesQty,
                                       0, 0, 0, 0, SYSDATE, 0);
                    END IF;

                  /*
                  UPDATE PORTFOLIOS SET SELLINGQTTY=SELLINGQTTY-p_LeavesQty  WHERE acctno=p_acctno AND symbol=p_symbol;
                  */
                ELSIF (v_old_subside = 'MS') OR (v_old_subside = 'AM') THEN
                    --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                    SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                    IF v_count > 0 THEN
                      UPDATE portfoliosex SET SELLINGQTTYMORT=SELLINGQTTYMORT - p_LeavesQty WHERE acctno = p_acctno AND symbol=p_symbol;
                    ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                      sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                       VALUES (p_acctno, p_symbol, 0, 0,
                                       - p_LeavesQty, 0, 0, 0, SYSDATE, 0);
                    END IF;
                    /*
                    UPDATE PORTFOLIOS SET SELLINGQTTYMORT=SELLINGQTTYMORT - p_LeavesQty WHERE acctno=p_acctno AND symbol=p_symbol;
                    */
                ELSIF (v_old_subside = 'TS') THEN
                    IF (p_LeavesQty/*v_remain_qtty*/ <= v_mort_qtty) THEN -- khop het CKGD
                        --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                        SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                        IF v_count > 0 THEN
                          UPDATE portfoliosex SET SELLINGQTTYMORT=SELLINGQTTYMORT-p_LeavesQty WHERE acctno = p_acctno AND symbol=p_symbol;
                        ELSE
                          INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                           VALUES (p_acctno, p_symbol, 0, 0,
                                           - p_LeavesQty, 0, 0, 0, SYSDATE, 0);
                        END IF;
                       /*
                        UPDATE PORTFOLIOS SET SELLINGQTTYMORT=SELLINGQTTYMORT-p_LeavesQty  WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                        */
                    ELSE -- v_remain_qtty > v_mort_qtty
                        --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                        SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                        IF v_count > 0 THEN
                          UPDATE portfoliosex SET SELLINGQTTYMORT=SELLINGQTTYMORT-v_mort_qtty,SELLINGQTTY=SELLINGQTTY-(p_LeavesQty -v_mort_qtty)
                          WHERE acctno = p_acctno AND symbol=p_symbol;
                        ELSE
                          INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                          sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                           VALUES (p_acctno, p_symbol, 0, -(p_LeavesQty -v_mort_qtty),
                                           -v_mort_qtty, 0, 0, 0, SYSDATE, 0);
                        END IF;

                        /*
                        UPDATE PORTFOLIOS SET SELLINGQTTYMORT=SELLINGQTTYMORT-v_mort_qtty,SELLINGQTTY=SELLINGQTTY-(p_LeavesQty -v_mort_qtty)
                        WHERE ACCTNO = p_acctno AND SYMBOL = p_symbol;
                        */
                    END IF;
                    --cap nhat KL CK cam co trong Orders
                    UPDATE ORDERS SET MORT_QTTY = MORT_QTTY - v_mort_qtty WHERE ORDERID = p_reforderid;
                END IF;
            ELSIF p_sub_side = 'CB' THEN --lenh huy mua
                v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);

                --lay thong tin bang baskets
                SELECT COUNT(*) INTO v_count FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = p_symbol;
                IF (v_count = 0) THEN
                    v_price_asset :=0;
                    v_rate_asset :=0;
                ELSE
                    SELECT PRICE_ASSET,RATE_ASSET INTO v_price_asset,v_rate_asset FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = p_symbol;
                END IF;

                --Cap nhat ky quy mua,ck
                v_cancel_value := p_LeavesQty/*v_remain_qtty*/ * v_quote_price * (1+v_ratebrk/100);
                --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT - v_cancel_value  WHERE ACCTNO = p_acctno;
                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET BUYINGQTTY = BUYINGQTTY - p_LeavesQty
                  WHERE acctno = p_acctno AND symbol=p_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, p_symbol, - p_LeavesQty, 0,
                                   0, 0, 0, 0, SYSDATE, 0);
                END IF;
                /*
                UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY - p_LeavesQty WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                */
                --Nha Pool, nha Room
                IF (v_formulacd != 'CASH') AND (v_formulacd != 'ADV') THEN
          v_release_pool:=CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code,v_cancel_value,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
          --dbms_output.put_line('v_release_pool:' || v_release_pool);
          IF v_release_pool > 0 AND (v_poolid IS NOT NULL) THEN
                            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,p_side,p_symbol,p_acctno,v_poolid,v_release_pool,0,null,p_err_msg);
          END IF;

          IF v_roomid IS NOT NULL THEN

            SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;

            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            BEGIN
                SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
            EXCEPTION WHEN OTHERS THEN
                v_markedEX :=0;
                v_markedcomEX:=0;
            END;
            v_marked:=v_marked + v_markedEX;
            v_markedcom:=v_markedcom +  v_markedcomEX;

            --so luong chung khoan nha danh dau
            v_release_qtty := LEAST(v_marked,p_LeavesQty/*v_remain_qtty*/);
            v_release_qtty_ub := LEAST(v_markedcom,p_LeavesQty/*v_remain_qtty*/);
            /* end */
            v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
            v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));
            --insert allocation
            IF v_roomid = 'SYSTEM' THEN

            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKED = MARKED - v_release_qtty WHERE acctno = p_acctno AND symbol=p_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, p_symbol, 0, 0,
                                   0, - v_release_qtty , 0, 0, SYSDATE,0);
                END IF;

              /*
              UPDATE PORTFOLIOS SET MARKED = MARKED - v_release_qtty WHERE ACCTNO = p_acctno AND SYMBOL = p_symbol;
              */
              IF v_release_amt > 0 THEN
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, p_symbol, p_acctno, v_release_qtty, null, 'C', 'R', null, 0, v_roomid, v_release_amt, 'P', SYSDATE);
              END IF;
              IF (v_basketid !=v_basketid_ub) THEN --tk dong tai tro
                --dbms_output.put_line('nha room ub');

                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE acctno = p_acctno AND symbol=p_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, p_symbol, 0, 0,
                                   0, 0 , 0, 0, SYSDATE,-v_release_qtty_ub);
                END IF;

                /*
                UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                */

                IF v_release_qtty_ub > 0 THEN
                  INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                    DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                  VALUES(SEQ_COMMON.NEXTVAL,p_order_id,p_side,p_symbol,p_acctno,v_release_qtty_ub,NULL,
                    'C','R',NULL,0,'UB',v_release_amt_ub,'P',SYSDATE);
                END IF;
              END IF;
            ELSIF v_roomid = 'UB' THEN

              --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=p_symbol;
                IF v_count > 0 THEN
                  UPDATE portfoliosex SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub
                  WHERE acctno = p_acctno AND symbol=p_symbol;
                ELSE
                  INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (p_acctno, p_symbol, 0, 0,
                                   0, -v_release_qtty , 0, 0, SYSDATE,-v_release_qtty_ub);
                END IF;

              /*
              UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
              */
              IF v_release_amt_ub > 0 THEN
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, p_symbol, p_acctno, v_release_qtty_ub, null, 'C', 'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
              END IF;
              IF v_release_amt > 0 THEN
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, p_symbol, p_acctno, v_release_qtty, null, 'C', 'R', null, 0, 'SYSTEM', v_release_amt, 'P', SYSDATE);
              END IF;
            END IF;

            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_roomid',v_roomid);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_payable',v_payable);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_bod_debt_t0',v_bod_debt_t0);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_bod_d_margin',v_bod_d_margin);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_bod_d_margin_ub',v_bod_d_margin_ub);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_ordamt',v_odramt-v_cancel_value);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'0','0');
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_balance',v_balance);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_bod_adv',v_bod_adv);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_advbal',v_advbal);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_td',v_td);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_t0value',v_t0value);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'p_order_id',p_order_id);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'p_side',p_side);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'p_symbol',p_symbol);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'CANCEL_ORDER',p_acctno,p_order_id,'v_remain_qtty',p_LeavesQty/*v_remain_qtty*/);

            CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,
            v_odramt-v_cancel_value,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_order_id,p_side,p_symbol,p_LeavesQty/*v_remain_qtty*/,p_err_msg);

            --danh dau ma CK khac neu tai san danh dau < du no
            CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,
            v_odramt-v_cancel_value,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,null,null,null,0,p_err_msg);
          END IF;
--                  END IF;
                END IF;

            END IF;

            --Cap nhat lenh yeu cau huy
            UPDATE ORDERS SET CONFIRMID = p_exchange_code,substatus='DS',flagorder='E',CANCEL_QTTY=p_LeavesQty, LASTCHANGE = v_currtime WHERE ORDERID = p_order_id;
            /*dung.bui fix so tra ve kl huy, date 25/11/2015 */
      IF (v_remain_qtty > p_LeavesQty) THEN --HUY MOT PHAN
        --Cap nhat lenh goc
        UPDATE ORDERS SET STATUS='D',SUBSTATUS='DD',CANCEL_QTTY=p_LeavesQty/*v_remain_qtty*/,REMAIN_QTTY=REMAIN_QTTY-p_LeavesQty,FLAGORDER='E',LASTCHANGE=v_currtime
        WHERE ORDERID=p_reforderid;
      ELSE -- HUY TOAN BO
        --Cap nhat lenh goc
        UPDATE ORDERS SET STATUS='D',SUBSTATUS='DD',CANCEL_QTTY=p_LeavesQty/*v_remain_qtty*/,REMAIN_QTTY=0,FLAGORDER='E',LASTCHANGE=v_currtime
        WHERE ORDERID=p_reforderid;
      END IF;
      /*end*/
        ELSE --so tra ve khong thanh cong (reject lenh)
            --cap nhat trang thai lenh yeu cau huy
            UPDATE ORDERS SET CONFIRMID=p_exchange_code,SUBSTATUS='DN',LASTCHANGE=v_currtime WHERE ORDERID=p_order_id;
            --cap nhat trang thai lenh goc
            IF (v_old_side = 'B') OR (v_old_side = 'S') THEN --lenh thuong
                UPDATE ORDERS SET STATUS='S',SUBSTATUS='SS',LASTCHANGE=v_currtime WHERE ORDERID=p_reforderid;
            ELSIF v_old_side = 'O' THEN --lenh sua
                UPDATE ORDERS SET STATUS='E',SUBSTATUS='ES',LASTCHANGE=v_currtime WHERE ORDERID=p_reforderid;
            END IF;
        END IF;

  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_confirm_cancel '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_proces_confirm_cancel;

    PROCEDURE sp_proces_respone_error(p_err_code in OUT VARCHAR,
                p_msgtype IN VARCHAR, --kieu message tu so
                                p_reject_code in VARCHAR, --ma loi
                p_content in VARCHAR,
                p_err_msg OUT VARCHAR2
              )
    AS
        v_currtime timestamp;

    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_proces_respone_error p_content=>'||p_content;
        BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
        END;

        INSERT INTO EXCERROR(AUTOID,MSGTYPE,REJCODE,CONTENT,LASTCHANGE)
        VALUES (SEQ_EXCERROR.NEXTVAL,p_msgtype,p_reject_code,p_content,v_currtime);


   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_respone_error '||p_err_msg||' sqlerrm = '||SQLERRM;

    END sp_proces_respone_error;

    --8.0.M, HNX, confirm MTL->LO
    PROCEDURE sp_proces_MTL_order_confirm(p_err_code in OUT VARCHAR,
                p_order_id IN VARCHAR, --so hieu lenh
                                p_exchange_code in VARCHAR, --ma xac nhan tu so
                p_status in VARCHAR, --trang thai tra ve tu so
                p_Symbol IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_OrderQty IN NUMBER, --
                p_OrdType IN VARCHAR, --
                p_Price IN NUMBER,
                p_err_msg OUT VARCHAR2
              )
    AS
        v_side varchar(1);
        v_sub_side varchar(2);
        v_status varchar(2);
        v_sub_status varchar(2);
        v_acctno varchar(20);
        v_symbol varchar(15);
        v_reforderid varchar(20);
        v_quote_qtty integer;
        v_remain_qtty integer;
        v_quote_price number;
        v_typecd varchar(10);
        v_userid varchar(10);
        v_quoteid varchar(20);
        v_sessionnex varchar(5);
        v_new_orderid varchar(20);
        v_currtime timestamp;
        v_ceil_price number;
        v_buy_amt number;
        v_rate_brk number;
        v_release_pool  NUMBER(20,2);
        v_balance  NUMBER(20,2);
        v_payable  NUMBER(20,2);
        v_debt  NUMBER(20,2);
        v_advbal  NUMBER(20,2);
        v_bod_adv NUMBER(20,2);
        v_odramt  NUMBER(20,2);
        v_poolid VARCHAR(20);
        v_roomid VARCHAR(20);
        v_td  NUMBER(20,2);
        v_t0value NUMBER;
        v_formulacd varchar(20);
        v_stock_value NUMBER;
        v_stock_value_ub NUMBER;
        v_release_qtty NUMBER;
        v_release_qtty_ub NUMBER;
        v_release_amt NUMBER;
        v_release_amt_ub NUMBER;
        v_price_asset NUMBER;
        v_rate_asset NUMBER;
        v_basketid ACCOUNTS.BASKETID%TYPE;
        v_count number;
        v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
        v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
        v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    BEGIN
        p_err_msg:='sp_proces_MTL_order_confirm p_order_id=>'||p_order_id;
        BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
        END;

        p_err_code := '0';

        SELECT SIDE,SUBSIDE,STATUS,SUBSTATUS,ACCTNO,SYMBOL,REFORDERID,QUOTE_QTTY,
                REMAIN_QTTY,QUOTE_PRICE,TYPECD,USERID,QUOTEID,SESSIONEX,RATE_BRK
        INTO v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,
              v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex,v_rate_brk
        FROM ORDERS
        WHERE ORDERID = p_order_id;

        --1. Update order
        UPDATE ORDERS SET /*REMAIN_QTTY = p_OrderQty,*/ QUOTE_PRICE = p_Price, TYPECD = 'LO', SUBTYPECD='LO', LASTCHANGE = v_currtime
          WHERE ORDERID = p_order_id AND SUBSTATUS IN ('BB','SS');

        --2.free buy amount, pool, room
        IF v_side = 'B' THEN
            SELECT PRICE_CE INTO v_ceil_price FROM INSTRUMENTS WHERE SYMBOL = v_symbol;
            v_buy_amt := p_OrderQty * (v_ceil_price - p_Price) * (1+v_rate_brk);

            --2.1 free buy amount
            --UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT - v_buy_amt WHERE ACCTNO = v_acctno;

              --2.2 free pool
            SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,CALC_ADVBAL,BOD_ADV,BOD_TD,CALC_ODRAMT,POOLID,ROOMID,
                    BOD_T0VALUE,BASKETID,FORMULACD,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB
            INTO v_balance,v_payable,v_debt,v_advbal,v_bod_adv,v_td,v_odramt,v_poolid,v_roomid,
                    v_t0value,v_basketid,v_formulacd,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub
            FROM ACCOUNTS WHERE ACCTNO = v_acctno;

            /*
            tiendt added for buy amount
            date: 2015-08-24
            */
            v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(v_acctno);
            /*end*/

            /*
            IF (v_poolid IS NOT NULL) AND (v_formulacd != 'CASH') AND (v_formulacd != 'ADV') THEN
                v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool( p_err_code,
                  v_buy_amt,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value);
                IF v_release_pool > 0  THEN
                    CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_order_id,p_Side,v_symbol,v_acctno,v_poolid,v_release_pool,0,null);

                    --Xu li nha Room
                    SELECT (MARKED-TRADE+BOD_ST3-BUYINGQTTY-RECEIVING) INTO v_stock_value FROM PORTFOLIOS WHERE acctno = v_acctno AND symbol=v_symbol;
                    SELECT (MARKEDCOM-TRADE+BOD_ST3-BUYINGQTTY-RECEIVING) INTO v_stock_value_ub FROM PORTFOLIOS
                    WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;

                    --so luong chung khoan nha danh dau
                    v_release_qtty := GREATEST(0,v_stock_value);
                    v_release_qtty_ub := GREATEST(0,v_stock_value_ub);

                    v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
                    v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));

                    --insert allocation
                    IF v_roomid = 'SYSTEM' THEN
                      UPDATE PORTFOLIOS SET MARKED = MARKED - v_release_qtty WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
                      IF v_release_amt > 0 THEN
                          INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                              VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, v_symbol, v_acctno, v_release_qtty, null, 'C', 'R', null, 0, v_roomid, v_release_amt, 'P', SYSDATE);
                      END IF;
                    ELSIF v_roomid = 'UB' THEN
                      UPDATE PORTFOLIOS SET MARKED = MARKED - v_release_qtty,MARKEDCOM = MARKEDCOM - v_release_qtty_ub WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
                      IF v_release_amt_ub > 0 THEN
                          INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                              VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, v_symbol, v_acctno, v_release_qtty_ub, null, 'C', 'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
                      END IF;
                      IF v_release_amt > 0 THEN
                          INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                              VALUES (SEQ_COMMON.NEXTVAL, p_order_id, p_side, v_symbol, v_acctno, v_release_qtty, null, 'C', 'R', null, 0, 'SYSTEM', v_release_amt, 'P', SYSDATE);
                      END IF;
                    END IF;

                    CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,v_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_buy_amt,0,v_balance,v_bod_adv,v_advbal,
                                v_td,v_t0value,p_order_id,p_side,v_symbol,v_remain_qtty);
                END IF;
            END IF;
            */
        END IF;

    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_MTL_order_confirm '||p_err_msg||' sqlerrm = '||SQLERRM;


    END sp_proces_MTL_order_confirm;

END CSPKS_FO_ORDER_RESPONE;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_ORDER_RESPONE

