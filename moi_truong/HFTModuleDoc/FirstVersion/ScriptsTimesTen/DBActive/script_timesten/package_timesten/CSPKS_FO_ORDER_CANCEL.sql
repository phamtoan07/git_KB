CREATE OR REPLACE PACKAGE cspks_fo_order_cancel AS

     PROCEDURE sp_proces_cancel_order(p_err_code in OUT VARCHAR,
              p_order_id in OUT VARCHAR, --so hieu lenh moi
              p_cancel_order_id IN VARCHAR, --so hieu lenh can huy
              p_account IN VARCHAR, --so tieu khoan giao dich
              p_sessionex in VARCHAR, --phien giao dich
              p_userid in VARCHAR, --ma nguoi dung dat lenh
              p_quote_id IN VARCHAR,
              p_err_msg OUT VARCHAR2
              );
     PROCEDURE sp_proces_cancel_da_order(p_err_code in OUT VARCHAR,
              p_classcd IN VARCHAR, --Loai lenh tuong ung voi quote
              p_account IN VARCHAR, --so tieu khoan giao dich
              p_symbol IN VARCHAR, --ma chung khoan
              p_qtty IN  NUMBER,  --Khoi luong huy
              p_price IN  NUMBER, --gia ban
              p_quote_id IN VARCHAR, --so hieu yeu cau
              p_userid in VARCHAR, --ma nguoi dung dat lenh
              p_txdate in varchar,
              p_err_msg OUT VARCHAR2
              );

      PROCEDURE sp_proces_cancel_gtc_order(p_err_code in OUT VARCHAR,
             p_order_id in OUT VARCHAR, --so hieu lenh moi
             p_classcd IN VARCHAR, --Loai lenh tuong ung voi quote
             p_account IN VARCHAR, --so tieu khoan giao dich
             p_symbol IN VARCHAR, --ma chung khoan
             p_qtty IN  NUMBER,  --Khoi luong huy
             p_price IN  NUMBER, --gia ban
             p_sessionex in VARCHAR, --phien giao dich
             p_quote_id IN VARCHAR, --so hieu yeu cau
             p_userid in VARCHAR, --ma nguoi dung dat lenh
             p_txdate in varchar,
            p_err_msg OUT VARCHAR2
             );

      --Giai toa lenh  bang tay
      PROCEDURE sp_proces_release_order(p_err_code in OUT VARCHAR,
             p_account IN VARCHAR, --so tieu khoan giao dich
             p_orderid in VARCHAR, --so hieu lenh giai toan
             p_symbol IN VARCHAR, --ma chung khoan
             p_quote_id IN VARCHAR, --so hieu yeu cau
             p_userid in VARCHAR, --ma nguoi dung dat lenh
             p_via in varchar,
             p_err_msg OUT VARCHAR2
             );

        
        PROCEDURE sp_free_internal_order(
            p_err_code IN OUT VARCHAR,
            p_orderid IN VARCHAR,
            p_err_msg OUT VARCHAR2
    );  
END CSPKS_FO_ORDER_CANCEL;

/


CREATE OR REPLACE PACKAGE BODY cspks_fo_order_cancel AS

  PROCEDURE sp_proces_cancel_order(p_err_code in OUT VARCHAR,
                p_order_id in OUT VARCHAR, --so hieu lenh moi
                p_cancel_order_id IN VARCHAR, --so hieu lenh can huy
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_sessionex in VARCHAR, --phien giao dich
                p_userid in VARCHAR, --ma nguoi dung dat lenh
                p_quote_id IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
    AS
        v_order_id              VARCHAR(20);
        v_remain_qtty           ORDERS.REMAIN_QTTY%TYPE;
        v_exec_qtty             ORDERS.EXEC_QTTY%TYPE;
        v_quote_qtty            ORDERS.QUOTE_QTTY%TYPE;
        v_custodycd             ORDERS.CUSTODYCD%TYPE;
        v_side                  ORDERS.SIDE%TYPE;
        v_status                ORDERS.STATUS%TYPE;
        v_substatus             ORDERS.SUBSTATUS%TYPE;
        v_rate_brk              ORDERS.RATE_BRK%TYPE;
        v_price_margin          ORDERS.PRICE_MARGIN%TYPE;
        v_price_asset           ORDERS.PRICE_ASSET%TYPE :=0;
        v_rate_asset            NUMBER :=0;
        v_rate_tax              ORDERS.RATE_TAX%TYPE;
        v_rate_adv              ORDERS.RATE_ADV%TYPE;
        v_rate_buy              ORDERS.RATE_BUY%TYPE;
        v_symbol                ORDERS.SYMBOL%TYPE;
        v_subside               ORDERS.SUBSIDE%TYPE;
        v_quote_price           ORDERS.QUOTE_PRICE%TYPE;
        v_txdate                ORDERS.TXDATE%TYPE;
        v_typecd                ORDERS.TYPECD%TYPE;
        v_subtypecd             ORDERS.SUBTYPECD%TYPE;
        v_mort_qtty             ORDERS.MORT_QTTY%TYPE;
        v_root_orderid          ORDERS.ROOTORDERID%TYPE;
        v_sesionex_order        ORDERS.SESSIONEX%TYPE;  -- phien cua lenh dat
        v_confirmid             ORDERS.CONFIRMID%TYPE;
        v_sesionex              MARKETINFO.SESSIONEX%TYPE;
        v_exchange              INSTRUMENTS.EXCHANGE%TYPE;
        v_balance               ACCOUNTS.BOD_BALANCE%TYPE;
        v_payable               ACCOUNTS.BOD_PAYABLE%TYPE;
        v_debt                  ACCOUNTS.BOD_DEBT%TYPE;
        v_advbal                ACCOUNTS.CALC_ADVBAL%TYPE;
        v_bod_adv               ACCOUNTS.BOD_ADV%TYPE;
        v_td                    ACCOUNTS.BOD_TD%TYPE;
        v_odramt                ACCOUNTS.CALC_ODRAMT%TYPE;
        v_t0value               ACCOUNTS.BOD_T0VALUE%TYPE;
        v_poolid                ACCOUNTS.POOLID%TYPE;
        v_roomid                ACCOUNTS.ROOMID%TYPE;
        v_formulacd             ACCOUNTS.FORMULACD%TYPE;
        v_currtime              TIMESTAMP;
        v_cancel_amt            NUMBER;
        v_add_pool              NUMBER;
        v_bod_debt_t0           ACCOUNTS.BOD_DEBT_T0%TYPE;
        v_bod_d_margin          ACCOUNTS.BOD_D_MARGIN%TYPE;
        v_bod_d_margin_ub       ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
        v_acctno                ORDERS.ACCTNO%TYPE;
        v_originorderid         ORDERS.ORIGINORDERID%TYPE;
        v_exec_amt              ORDERS.EXEC_AMT%TYPE;
        v_marked            NUMBER;
        v_markedcom         NUMBER;
        v_release_qtty      NUMBER;
        v_release_qtty_ub   NUMBER;
        v_release_amt       NUMBER;
        v_release_amt_ub    NUMBER;
        v_count             NUMBER;
        v_basketid          ACCOUNTS.BASKETID%TYPE;
        v_basketid_ub       ACCOUNTS.BASKETID_UB%TYPE;
        v_markedEX          NUMBER;
        v_markedcomEX       NUMBER;


  BEGIN
        p_err_code := '0';
        p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
        BEGIN
            EXECUTE IMMEDIATE
            'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;

        -- LAY THONG TIN LENH GOC
        SELECT QUOTE_QTTY,MORT_QTTY,REMAIN_QTTY,EXEC_QTTY,EXEC_AMT,SIDE,RATE_ADV,CONFIRMID,ORIGINORDERID,
            RATE_BRK,RATE_TAX,RATE_BUY,PRICE_MARGIN,PRICE_ASSET,SYMBOL,CUSTODYCD,
            SUBSTATUS,STATUS,SUBSIDE,QUOTE_PRICE,TXDATE,TYPECD,SUBTYPECD,ROOTORDERID,SESSIONEX,ACCTNO
        INTO v_quote_qtty,v_mort_qtty,v_remain_qtty,v_exec_qtty,v_exec_amt,v_side,v_rate_adv,v_confirmid,v_originorderid,
            v_rate_brk,v_rate_tax,v_rate_buy,v_price_margin,v_price_asset,v_symbol,v_custodycd,
            v_substatus,v_status,v_subside,v_quote_price,v_txdate,v_typecd,v_subtypecd,v_root_orderid,v_sesionex_order,v_acctno
        FROM orders WHERE orderid = p_cancel_order_id;

    -- LAY THONG TIN TAI KHOAN
    SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,BOD_ADV,CALC_ADVBAL,BOD_TD,BASKETID,BASKETID_UB,FORMULACD,
    CALC_ODRAMT,POOLID,ROOMID,BOD_T0VALUE,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB
    INTO v_balance,v_payable,v_debt,v_bod_adv,v_advbal,v_td,v_basketid,v_basketid_ub,v_formulacd,
    v_odramt,v_poolid,v_roomid,v_t0value,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub
    FROM ACCOUNTS WHERE acctno = v_acctno;

        --dbms_output.enable;
        SELECT EXCHANGE INTO v_exchange FROM INSTRUMENTS WHERE SYMBOL = v_symbol;
        --SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
        SELECT SESSIONEX INTO v_sesionex FROM MARKETINFO M,INSTRUMENTS I WHERE I.SYMBOL= v_symbol AND M.EXCHANGE=I.BOARD;

        /*dung.bui add code check phien, date 14/12/2015*/
        IF v_sesionex='END' THEN --dong cua thi truong
            p_err_code := '-95043';
            p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
            RETURN;
        END IF;

        IF v_sesionex IN ('CROSS','L5M')   THEN --phien cho lenh thoa thuan, phien CLOSE --ThanhNV sua 2016.08.31
            p_err_code := '-95015';
            p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
            RETURN;
        END IF;
        
        IF v_sesionex IN ('CLS') and v_subtypecd <> 'PLO' THEN --phien dong cua cho huy lenh PLO --ThongPM sua 2018.11.06
            p_err_code := '-95015';
            p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
            RETURN;
        END IF;
        /*end*/

        /* date: 2014-12-18 : 11h ,dung.bui comment code */
  --        IF v_exchange = 'HSX' AND v_subtypecd != 'LO' AND  v_substatus != 'NN' THEN
  --            p_err_code := '-95024';
  --            return;
  --        END IF;
  --        IF v_exchange = 'HNX' AND v_subtypecd != 'LO' AND  v_substatus != 'NN' AND v_subtypecd != 'ATC' THEN
  --            p_err_code := '-95024';
  --            return;
  --            END IF;
        /*end*/

    SELECT COUNT(*) INTO v_count FROM BASKETS WHERE BASKETID = v_basketid AND SYMBOL = v_symbol;
    IF v_count = 1 THEN
      SELECT PRICE_ASSET,RATE_ASSET INTO v_price_asset,v_rate_asset FROM BASKETS WHERE BASKETID=v_basketid AND SYMBOL=v_symbol;
    END IF;
        --general orderid
        CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);
        --DBMS_OUTPUT.PUT_LINE('orderid:' || v_order_id);

    IF (v_substatus = 'NN') THEN --lenh cho gui
            -- UPDATE KL CHO MUA ,CHO BAN TRONG BANG PORTFOLIOS
            IF (v_subside = 'NB') THEN
                UPDATE PORTFOLIOS SET BUYINGQTTY=BUYINGQTTY-v_quote_qtty WHERE ACCTNO=v_acctno AND SYMBOL=v_symbol;
        -- Giam ki quy mua
        v_cancel_amt := v_remain_qtty*v_quote_price*(1+v_rate_brk/100);

       -- UPDATE ACCOUNTS SET CALC_ODRAMT = CALC_ODRAMT-v_cancel_amt WHERE ACCTNO=v_acctno;
        /*
        tiendt added for buy amount,date: 2015-08-24
        */
        v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(v_acctno);
        /*end*/
        --DBMS_OUTPUT.PUT_LINE('v_odramt:' || v_odramt);
        --Nha Pool, nha Room
        IF (v_formulacd != 'CASH') AND (v_formulacd != 'ADV') THEN
            v_add_pool := CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code, v_cancel_amt,v_balance,v_bod_adv+v_advbal,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
            --dbms_output.put_line('v_add_pool:' || v_add_pool);
          IF v_add_pool > 0 AND (v_poolid IS NOT NULL) THEN
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_cancel_order_id,'B',v_symbol,v_acctno,v_poolid,v_add_pool,v_remain_qtty,v_quote_price,p_err_msg);
          END IF;

          IF v_roomid IS NOT NULL THEN
            SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=v_acctno AND SYMBOL=v_symbol;
            BEGIN
                SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO=v_acctno AND SYMBOL=v_symbol;
            EXCEPTION WHEN OTHERS THEN
                v_markedEX :=0;
                v_markedcomEX:=0;
            END;
            v_marked:=v_marked + v_markedEX;
            v_markedcom:=v_markedcom +  v_markedcomEX;
            --so luong chung khoan nha danh dau
            v_release_qtty := LEAST(v_marked,v_remain_qtty);
            v_release_qtty_ub := LEAST(v_markedcom,v_remain_qtty);
            --dbms_output.put_line('v_release_qtty:' || v_release_qtty);
            v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
            v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));

            --insert allocation,nha ma dang danh dau trong gd
            IF v_roomid = 'SYSTEM' THEN
              UPDATE PORTFOLIOS SET MARKED = MARKED-v_release_qtty WHERE ACCTNO=v_acctno AND SYMBOL=v_symbol;
              IF v_release_amt > 0 THEN
                INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,
                  POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL,p_cancel_order_id,v_side,v_symbol,v_acctno,v_release_qtty,null,'C',
                  'R',null,0,v_roomid,v_release_amt,'P',SYSDATE);
              END IF;
              IF (v_basketid !=v_basketid_ub) THEN --tk dong tai tro

                UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=v_acctno AND SYMBOL=v_symbol;
                IF v_release_qtty_ub > 0 THEN
                  INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                  DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                  VALUES(SEQ_COMMON.NEXTVAL,p_cancel_order_id,v_side,v_symbol,v_acctno,v_release_qtty_ub,NULL,
                  'C','R',NULL,0,'UB',v_release_amt_ub,'P',SYSDATE);
                END IF;
              END IF;
            ELSIF v_roomid = 'UB' THEN
              UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub
              WHERE ACCTNO=v_acctno AND SYMBOL=v_symbol;
              IF v_release_amt_ub > 0 THEN
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC,
                  POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_cancel_order_id, v_side, v_symbol, v_acctno, v_release_qtty_ub, null, 'C',
                  'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
              END IF;
              IF v_release_amt > 0 THEN
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC,
                  POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_cancel_order_id, v_side, v_symbol, v_acctno, v_release_qtty, null, 'C',
                  'R', null, 0, 'SYSTEM', v_release_amt, 'P', SYSDATE);
              END IF;
            END IF;
            /*
            dbms_output.put_line('v_payable:' || v_payable);
            dbms_output.put_line('v_bod_debt_t0:' || v_bod_debt_t0);
            dbms_output.put_line('v_bod_d_margin:' || v_bod_d_margin);
            dbms_output.put_line('v_odramt:' || v_odramt);
            dbms_output.put_line('v_cancel_amt:' || v_cancel_amt);
            dbms_output.put_line('v_balance:' || v_balance);
            dbms_output.put_line('v_bod_adv:' || v_bod_adv);
            dbms_output.put_line('v_advbal:' || v_advbal);
            dbms_output.put_line('v_td:' || v_td);
            dbms_output.put_line('v_t0value:' || v_t0value);
            dbms_output.put_line('v_remain_qtty:' || v_remain_qtty);
            */
            /*
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_roomid',v_roomid);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_payable',v_payable);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_bod_debt_t0',v_bod_debt_t0);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_bod_d_margin',v_bod_d_margin);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_bod_d_margin_ub',v_bod_d_margin_ub);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_ordamt',v_odramt-v_cancel_amt);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'0','0');
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_balance',v_balance);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_bod_adv',v_bod_adv);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_advbal',v_advbal);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_td',v_td);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_t0value',v_t0value);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'p_order_id',p_order_id);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_side',v_side);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_symbol',v_symbol);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'HUY_MUA',v_acctno,p_order_id,'v_remain_qtty',v_remain_qtty);
            */
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,v_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_odramt-v_cancel_amt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_cancel_order_id,v_side,v_symbol,v_remain_qtty,p_err_msg);

          END IF;
        END IF;

      ELSIF (v_subside = 'NS') THEN -- BAN THUONG
        UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY - v_quote_qtty WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
            ELSIF (v_subside = 'MS') THEN -- BAN CAM CO
        UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - v_quote_qtty WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
            ELSIF (v_subside = 'TS') THEN -- BAN TONG
        --cap nhat phan bo lai CK bang portfolios
        UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - v_mort_qtty,
                              SELLINGQTTY =  SELLINGQTTY - (v_quote_qtty - v_mort_qtty)
        WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
        UPDATE ORDERS SET MORT_QTTY = MORT_QTTY - v_mort_qtty WHERE ORDERID = p_cancel_order_id;
            END IF;

      p_order_id := p_cancel_order_id;

       --update trang thai, KL lenh goc, ko sinh lenh huy trong orders
      UPDATE ORDERS SET STATUS='D',SUBSTATUS='DD', REMAIN_QTTY = 0, CANCEL_QTTY = v_remain_qtty,LASTCHANGE = v_currtime
            WHERE ORDERID = p_cancel_order_id;
            UPDATE QUOTES SET STATUS= 'F' WHERE QUOTEID = p_quote_id;
        ELSIF (v_substatus = 'SS') OR (v_substatus = 'ES') THEN --lenh da gui so
            IF (v_exec_qtty = v_quote_qtty) THEN
                --DBMS_OUTPUT.PUT_LINE('KHONG THE HUY LENH DO DA KHOP HET');
        p_err_code := '-95023';
        p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
        RETURN;
            END IF;
            IF(v_subside = 'NB') OR (v_subside = 'AB') THEN --cho lenh huy mua
                v_subside := 'CB';
            ELSE --cho lenh huy Ban
                v_subside := 'CS';
            END IF;
            CSPKS_FO_COMMON.sp_get_status(p_err_code,v_status,v_substatus,v_sesionex,v_subtypecd,v_exchange,p_err_msg);
            --check phien va loai lenh
            CSPKS_FO_VALIDATION.sp_validate_cancel_order(p_err_code,p_cancel_order_id,v_exchange,v_side,v_sesionex,p_err_msg);
            IF(p_err_code != '0') THEN
        RETURN;
            END IF;

      -- check them truong hop lenh gia LO cua san HSX
      IF (v_exchange = 'HSX' and v_subtypecd = 'LO') THEN
        IF (v_sesionex_order != 'CLS') and (v_sesionex = 'OPN') THEN
            p_err_code := '-95015';
            p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
            RETURN;
        END IF;
        IF v_sesionex_order IN ('CROSS','CLS','L5M')   THEN --phien cho lenh thoa thuan, phien CLOSE --ThanhNV sua 2016.08.31
            p_err_code := '-95015';
            p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
            RETURN;
        END IF;
      END IF;

      --SINH LENH YEU CAU HUY ORDER MOI
      INSERT INTO ORDERS (ORDERID, TXDATE, NORB, SESSIONEX, QUOTEID, CONFIRMID,
                USERID, CUSTODYCD, ACCTNO, SYMBOL, SIDE, ORIGINORDERID,
                SUBSIDE, STATUS, SUBSTATUS, TIME_CREATED, TIME_SEND,
                TYPECD, SUBTYPECD, QUOTE_PRICE, QUOTE_QTTY, EXEC_AMT,
                EXEC_QTTY, REMAIN_QTTY, CANCEL_QTTY, ADMEND_QTTY,REFORDERID,ROOTORDERID,FLAGORDER,
                RATE_ADV, RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN,
                PRICE_ASSET,LASTCHANGE)
      VALUES (v_order_id, v_txdate, 'N', v_sesionex, p_quote_id, v_confirmid,
                p_userid, v_custodycd, v_acctno, v_symbol, 'O', v_originorderid,
                v_subside, 'D', v_substatus, v_currtime, v_currtime,
                v_typecd, v_subtypecd, v_quote_price, v_remain_qtty, v_exec_amt,
                v_exec_qtty , v_remain_qtty, 0, 0, p_cancel_order_id,v_root_orderid,'C',
                v_rate_adv, v_rate_brk, v_rate_tax, v_rate_buy, v_price_margin,
                v_price_asset, v_currtime);

      --UPDATE TRANG THAI LENH GOC TRONG ORDERS
      UPDATE ORDERS SET STATUS='S',SUBSTATUS='SD',lastchange = v_currtime where orderid = p_cancel_order_id;

      p_order_id := v_order_id;
      --update quotes table
      UPDATE QUOTES SET status= 'F' WHERE QUOTEID = p_quote_id;

    ELSE
      -- DBMS_OUTPUT.PUT_LINE('KHONG THE HUY LENH');
      UPDATE QUOTES SET STATUS= 'R', LASTCHANGE=v_currtime WHERE QUOTEID = p_quote_id;
      p_err_code := '-95023';
      p_err_msg:='sp_proces_cancel_order p_cancel_order_id=>'||p_cancel_order_id;
      RETURN;
    END IF;
--     p_order_id := NULL;

--    EXCEPTION
--      WHEN OTHERS THEN
--        p_err_code := '-90025';
  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_cancel_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_cancel_order;

  PROCEDURE sp_proces_cancel_da_order(p_err_code in OUT VARCHAR,
            p_classcd IN VARCHAR, --Loai lenh tuong ung voi quote
            p_account IN VARCHAR, --so tieu khoan giao dich
            p_symbol IN VARCHAR, --ma chung khoan
            p_qtty IN  NUMBER,  --Khoi luong huy
            p_price IN  NUMBER, --gia ban
            p_quote_id IN VARCHAR, --so hieu yeu cau
            p_userid in VARCHAR, --ma nguoi dung dat lenh
            p_txdate in varchar,
            p_err_msg OUT VARCHAR2
            )
  AS

  BEGIN
--        plog.info('Huy lenh nhap,quang cao');
        --SELECT status,classcd INTO v_status,v_classcd FROM quotes  WHERE quoteid = p_quote_id;

        --IF v_classcd = 'DRO' OR v_classcd = 'ADO' THEN
            UPDATE quotes SET status = 'R' WHERE quoteid = p_quote_id AND classcd IN('DRO','ADO');
        --ELSIF v_classcd = 'GTC' THEN
            --plog.info('Huy lenh ');
       -- END IF;

        EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-90025';

  END sp_proces_cancel_da_order;

  PROCEDURE sp_proces_cancel_gtc_order(p_err_code in OUT VARCHAR,
            p_order_id in OUT VARCHAR, --so hieu lenh moi
            p_classcd IN VARCHAR, --Loai lenh tuong ung voi quote
            p_account IN VARCHAR, --so tieu khoan giao dich
            p_symbol IN VARCHAR, --ma chung khoan
            p_qtty IN  NUMBER,  --Khoi luong huy
            p_price IN  NUMBER, --gia ban
            p_sessionex in VARCHAR, --phien giao dich
            p_quote_id IN VARCHAR, --so hieu yeu cau
            p_userid in VARCHAR, --ma nguoi dung dat lenh
            p_txdate in varchar,
            p_err_msg OUT VARCHAR2
            )
  AS
        v_status varchar(2);
        v_classcd varchar(3);
        v_orderid varchar(30);
  BEGIN
         p_err_msg:='sp_proces_cancel_gtc_order p_quote_id=>'||p_quote_id;
--        plog.info('Huy lenh GTC');
        SELECT status,classcd INTO v_status,v_classcd FROM quotes  WHERE quoteid = p_quote_id;
        SELECT orderid INTO v_orderid FROM orders WHERE quoteid = p_quote_id;
        IF v_classcd = 'GTC' THEN
            UPDATE quotes SET status = 'R' WHERE quoteid = p_quote_id AND classcd IN('GTC');
            IF v_status = 'F' THEN --lenh GTC da Active
                sp_proces_cancel_order(p_err_code,p_order_id,v_orderid,p_account,p_sessionex,p_userid,p_quote_id,p_err_msg);
            END IF;
        END IF;

        EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:= 'sp_proces_cancel_gtc_order '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_proces_cancel_gtc_order;

  --giai toa lenh dang gui GW (trang thai lenh BB)
  PROCEDURE sp_proces_release_order(p_err_code in OUT VARCHAR,
             p_account IN VARCHAR, --so tieu khoan giao dich
             p_orderid in VARCHAR, --so hieu lenh giai toan
             p_symbol IN VARCHAR, --ma chung khoan
             p_quote_id IN VARCHAR, --so hieu yeu cau
             p_userid in VARCHAR, --ma nguoi dung dat lenh
             p_via in varchar ,
             p_err_msg OUT VARCHAR2
             )
  AS
        v_status varchar(2);
        v_substatus varchar(3);
        v_reforderid varchar(30);
        v_side varchar(2);
        v_subside varchar(2);
        v_release_value number;
        v_add_pool number;
        v_qtty number;
        v_exec_qtty number;
        v_remain_qtty number;
        v_quote_price number;
        v_mort_qtty number;
        v_rate_brk number;
        v_count number;
        v_currtime timestamp;
        v_balance number;
        v_payable number;
        v_debt number;
        v_bod_adv number;
        v_advbal number;
        v_td number;
        v_odramt number;
        v_poolid number;
        v_roomid number;
        v_t0value number;
        v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
        v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
        v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
        v_basketid          ACCOUNTS.BASKETID%TYPE;
        v_basketid_ub       ACCOUNTS.BASKETID_UB%TYPE;
        v_marked            PORTFOLIOS.MARKED%TYPE;
        v_markedcom         PORTFOLIOS.MARKEDCOM%TYPE;
        v_release_qtty      NUMBER;
        v_release_amt       NUMBER;
        v_release_qtty_ub   NUMBER;
        v_release_amt_ub    NUMBER;
        v_formulacd         ACCOUNTS.FORMULACD%TYPE;
        v_price_asset       NUMBER := 0;
        v_rate_asset        NUMBER := 0;
        v_markedEX          NUMBER;
        v_markedcomEX       NUMBER;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_proces_release_order p_orderid=>'||p_orderid;
        BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
        END;

        SELECT STATUS,SUBSTATUS,SIDE,SUBSIDE,QUOTE_QTTY,EXEC_QTTY,MORT_QTTY,QUOTE_PRICE
        INTO v_status,v_substatus, v_side,v_subside,v_qtty,v_exec_qtty,v_mort_qtty,v_quote_price
        FROM ORDERS WHERE ORDERID = p_orderid;

        IF (v_status = 'F' AND v_substatus = 'FF') THEN
          p_err_code := '-95032';
          RETURN;
        END IF;
        v_remain_qtty := v_qtty - v_exec_qtty;

        CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, p_orderid, v_side, v_subside,
        p_account, p_symbol, v_remain_qtty , v_remain_qtty , v_mort_qtty, v_quote_price, p_err_msg, '');


--        SELECT COUNT(1) INTO v_count FROM ORDERS WHERE ORDERID = p_orderid AND ACCTNO=p_account AND SYMBOL=p_symbol;
--        IF v_count < 1 THEN
--          p_err_code := '-90021';
--          return;
--        ELSE
--          --lay thong tin lenh goc
--          /*SELECT QUOTE_QTTY, MORT_QTTY, REMAIN_QTTY, EXEC_QTTY, SIDE, RATE_ADV, CONFIRMID,
--              RATE_BRK, RATE_TAX, RATE_BUY, PRICE_MARGIN, PRICE_ASSET, SYMBOL,
--              SUBSTATUS, STATUS, SUBSIDE, QUOTE_PRICE, TXDATE, TYPECD, SUBTYPECD,ROOTORDERID,SESSIONEX
--          INTO v_quote_qtty, v_mort_qtty, v_remain_qtty, v_exec_qtty, v_side, v_rate_adv, v_confirmid,
--              v_rate_brk, v_rate_tax, v_rate_buy, v_price_margin, v_price_asset, v_symbol,
--              v_substatus, v_status, v_subside_original, v_quote_price, v_txdate, v_typecd, v_subtypecd,v_root_orderid,v_sesionex_order
--          FROM orders WHERE ORDERID = p_orderid AND ACCTNO=p_account AND SYMBOL=p_symbol; */
--
--          SELECT STATUS,SUBSTATUS,REFORDERID,SIDE,SUBSIDE,QUOTE_QTTY,QUOTE_PRICE,MORT_QTTY,RATE_BRK
--          INTO v_status,v_substatus,v_reforderid,v_side,v_subside,v_qtty,v_quote_price,v_mort_qtty,v_rate_brk
--          FROM ORDERS WHERE ORDERID = p_orderid AND ACCTNO=p_account AND SYMBOL=p_symbol;
--
--          --Lay thong tin bang accounts
--          SELECT BOD_BALANCE,BOD_PAYABLE,BOD_DEBT,BOD_ADV,CALC_ADVBAL,BOD_TD,POOLID,ROOMID,BOD_T0VALUE,FORMULACD,
--            BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB,BASKETID,BASKETID_UB
--          INTO v_balance,v_payable,v_debt,v_bod_adv,v_advbal,v_td,v_poolid,v_roomid,v_t0value,v_formulacd,
--            v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_basketid,v_basketid_ub
--          FROM ACCOUNTS WHERE acctno = p_account;
--
--          IF v_status !='B' AND v_substatus != 'BB' THEN
--            p_err_code := '-95032';
--            return;
--          END IF;
--          --Chi giai toa lenh don
--          IF v_reforderid is not null THEN
--            p_err_code := '-95032';
--            return;
--          END IF;
--          IF v_subside = 'NB' THEN  --lenh mua
--            --gia tri lenh giai toa
--            v_release_value := v_qtty*v_quote_price*(1+v_rate_brk/100);
--              /*
--              tiendt added for buy amount, date: 2015-08-24
--              */
--              v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_account);
--              /*end*/
--
--            --Nha Pool, nha Room
--            IF (v_formulacd != 'CASH') AND (v_formulacd != 'ADV') THEN
--              v_add_pool := CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code,v_release_value,v_balance,v_bod_adv+v_advbal,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
--              IF v_add_pool > 0 AND (v_poolid IS NOT NULL) THEN
--                CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_orderid,'B',p_symbol,p_account,v_poolid,v_add_pool,v_qtty,v_quote_price,p_err_msg);
--              END IF;
--
--              IF v_roomid IS NOT NULL THEN
--                SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
--
--
--                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
--                BEGIN
--                    SELECT MARKED,MARKEDCOM INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
--                EXCEPTION WHEN OTHERS THEN
--                    v_markedEX :=0;
--                    v_markedcomEX:=0;
--                END;
--                v_marked:=v_marked + v_markedEX;
--                v_markedcom:=v_markedcom +  v_markedcomEX;
--
--                --so luong chung khoan nha danh dau
--                v_release_qtty := LEAST(v_marked,v_qtty);
--                v_release_qtty_ub := LEAST(v_markedcom,v_qtty);
--
--                v_release_amt := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
--                v_release_amt_ub := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));
--
--                --insert allocation,nha ma dang danh dau trong gd
--                IF v_roomid = 'SYSTEM' THEN
--                  UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
--                  IF v_release_amt > 0 THEN
--                    INSERT INTO ALLOCATION (AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,DOC,
--                      POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
--                    VALUES (SEQ_COMMON.NEXTVAL,p_orderid,v_side,p_symbol,p_account,v_release_qtty,null,'C',
--                      'R',null,0,v_roomid,v_release_amt,'P',SYSDATE);
--                  END IF;
--                  IF (v_basketid != v_basketid_ub) THEN --tk dong tai tro
--                    UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
--                    IF v_release_qtty_ub > 0 THEN
--                      INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
--                      DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
--                      VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_account,v_release_qtty_ub,NULL,
--                      'C','R',NULL,0,'UB',v_release_amt_ub,'P',SYSDATE);
--                    END IF;
--                  END IF;
--                ELSIF v_roomid = 'UB' THEN
--                  UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub
--                  WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
--                  IF v_release_amt_ub > 0 THEN
--                    INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC,
--                      POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
--                    VALUES (SEQ_COMMON.NEXTVAL, p_orderid, v_side, p_symbol, p_account, v_release_qtty_ub, null, 'C',
--                      'R', null, 0, v_roomid, v_release_amt_ub, 'P', SYSDATE);
--                  END IF;
--                  IF v_release_amt > 0 THEN
--                    INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC,
--                      POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
--                    VALUES (SEQ_COMMON.NEXTVAL, p_orderid, v_side, p_symbol, p_account, v_release_qtty, null, 'C',
--                      'R', null, 0, 'SYSTEM', v_release_amt, 'P', SYSDATE);
--                  END IF;
--                END IF;
--
--                CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
--                v_bod_d_margin_ub,v_odramt-v_release_value,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,p_orderid,v_side,p_symbol,v_qtty,p_err_msg);
--
--              END IF;
--            END IF;
--
--            /*
--            --Nha Pool, nha Room
--            IF v_poolid IS NOT NULL THEN
--                -- gia tri pool dung them
--                v_add_pool := CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code, v_release_value,v_balance,v_bod_adv + v_advbal,v_payable,v_debt,v_odramt,v_td,v_t0value);
--                  dbms_output.put_line('v_add_pool:' || v_add_pool);
--                IF v_add_pool > 0  THEN
--                    CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,p_orderid,'B',p_symbol,p_account,v_poolid,v_add_pool,v_qtty,v_quote_price);
--
--                    CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_account,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_odramt-v_release_value,0,v_balance,v_bod_adv,v_advbal,
--                            v_td,v_t0value,p_orderid,v_side,p_symbol,v_qtty);
--
--                END IF;
--            END IF;
--            */
--            -- giai toa ki quy
--            --UPDATE accounts SET calc_odramt = calc_odramt-v_release_value  WHERE ACCTNO=p_account;
--            --cap nhat KL CK cho mua trong bang portfolios
--            UPDATE PORTFOLIOS SET BUYINGQTTY = BUYINGQTTY-v_qtty WHERE ACCTNO=p_account AND SYMBOL=p_symbol;
--
--          -- lenh ban
--          ELSIF v_subside = 'NS' THEN  --ban thuong
--             UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY - v_qtty WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
--          ELSIF (v_subside = 'MS') THEN  --ban cam co
--                UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - v_qtty WHERE ACCTNO = p_account AND SYMBOL = p_symbol;
--           ELSIF (v_subside = 'TS') THEN --ban tong
--                UPDATE PORTFOLIOS SET SELLINGQTTYMORT = SELLINGQTTYMORT - v_mort_qtty, SELLINGQTTY =  SELLINGQTTY - (v_qtty - v_mort_qtty)
--                WHERE ACCTNO = p_account AND SYMBOL = p_symbol;
--                UPDATE ORDERS SET MORT_QTTY = MORT_QTTY - v_mort_qtty WHERE ORDERID = p_orderid;
--          END IF;
--
--          --cap nhat thong tin,trang thai quotes
--          UPDATE QUOTES SET STATUS = 'F',QTTY_CANCEL = v_qtty WHERE QUOTEID = p_quote_id;
--          --cap nhat thong tin,trang thai lenh
--          UPDATE ORDERS SET STATUS = 'F', SUBSTATUS= 'FF',REMAIN_QTTY = 0,CANCEL_QTTY = v_qtty,lastchange = v_currtime WHERE ORDERID = p_orderid AND ACCTNO=p_account AND SYMBOL=p_symbol;
--
--        END IF;



        EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:= 'sp_proces_release_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_release_order;

  PROCEDURE sp_free_internal_order(
            p_err_code IN OUT VARCHAR,
            p_orderid IN VARCHAR,
            p_err_msg OUT VARCHAR2
    )
    AS
      v_count NUMBER;
      v_side VARCHAR(2);
      v_sub_side VARCHAR(2);
      v_acctno VARCHAR(20);
      v_symbol VARCHAR(20);
      v_freed_qtty NUMBER;
      v_remain_qtty NUMBER;
      v_mort_qtty NUMBER;
      v_quote_price NUMBER;
      v_quote_qtty NUMBER;
      v_orderid VARCHAR(20);
    BEGIN
      p_err_code := '0';
        SELECT  ORDERID, ACCTNO, QUOTE_QTTY, MORT_QTTY, REMAIN_QTTY, SIDE, SUBSIDE, SYMBOL, QUOTE_PRICE
        INTO    v_orderid, v_acctno, v_quote_qtty, v_mort_qtty, v_remain_qtty, v_side, v_sub_side, v_symbol, v_quote_price
        FROM ORDERS
        WHERE ORDERID=p_orderid;

        v_freed_qtty := v_quote_qtty;

        CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_sub_side, v_acctno,
        v_symbol , v_freed_qtty , v_remain_qtty , v_mort_qtty, v_quote_price,p_err_msg,'I');

      EXCEPTION
        WHEN OTHERS THEN p_err_code := '-90025';
  END sp_free_internal_order;

END CSPKS_FO_ORDER_CANCEL;

/
