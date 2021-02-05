-- Start of DDL Script for Package FOTEST.CSPKS_FO_TRANS
-- Generated 22/03/2019 4:30:12 PM from FOTEST@FO

CREATE OR REPLACE 
PACKAGE cspks_fo_trans
AS
  /* TODO enter package declarations (types, exceptions, methods etc) here */
  --deploy 14/11
  PROCEDURE sp_increase_money(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_amount   IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_decrease_money(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_amount   IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_increase_stock(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, --ma chung khoan
      p_qtty     IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_decrease_stock(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, --ma chung khoan
      p_qtty     IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_advancePayment(
      p_err_code OUT VARCHAR,
      p_acctno      IN VARCHAR, --so tai khoan
      p_refid       IN VARCHAR, -- so hieu xu li cua FO
      p_bod_balance IN NUMBER,  --so tien mat tang
      p_bod_adv     IN NUMBER,  -- so tien ung t1,t2 bi giam
      p_calc_advbal IN NUMBER,  --so tien ung t3 bi giam
      p_doc         IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );
  PROCEDURE sp_register_mortage(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, -- ma chung khoan
      p_qtty     IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_unregister_mortage(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, --ma chung khoan
      p_qtty     IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_update_pool(
      p_err_code IN OUT VARCHAR,
      p_refid    IN VARCHAR,  -- so hieu xu li cua BO
      p_policycd IN VARCHAR2, --ma nhom chinh sach
      p_amount   IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_update_room(
      p_err_code  IN OUT VARCHAR,
      p_refid     IN VARCHAR,  -- so hieu xu li cua BO
      p_policycd  IN VARCHAR2, --ma nhom chinh sach
      p_refsymbol IN VARCHAR2, --ma chung khoan
      p_amount    IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_deposit_saving(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_amount   IN NUMBER,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_withdrawn_saving(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_amount   IN NUMBER,    --so tien rut tiet kiem
      p_doc      IN VARCHAR2,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_process_trans_log(
      p_txid    IN VARCHAR2,
      p_acctno  IN VARCHAR2,
      p_content IN VARCHAR2,
      p_refid OUT NUMBER,
      p_err_code OUT VARCHAR2,
      p_acclass OUT VARCHAR2,
      p_action IN VARCHAR2,
      p_err_msg OUT VARCHAR2
       );
  PROCEDURE sp_process_money(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan chuyen
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_amount   IN NUMBER,   --so tien
      p_doc      IN VARCHAR,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_process_stock(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan chuyen
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, --ma chung khoan
      p_qtty     IN NUMBER,   -- KL chung khoan giao dich
      p_doc      IN VARCHAR,
      p_err_msg OUT VARCHAR2
    );
  PROCEDURE sp_process_crlimit(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR, --so tai khoan
      p_amount   IN NUMBER,  -- Han muc moi
      p_doc      IN VARCHAR, --D or C
      p_refid    IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );
  PROCEDURE sp_process_guarantee_limit(
      p_err_code IN OUT VARCHAR, --han muc bao lanh
      p_acctno   IN VARCHAR,     --so tai khoan
      p_amount   IN NUMBER,      -- Han muc moi
      p_doc      IN VARCHAR,     --D or C
      p_refid    IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );
  PROCEDURE sp_process_debt(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- no bao lanh
            p_type   IN VARCHAR, -- loai no bao lanh hay margin
            p_doc   IN VARCHAR, --C tang, D giam
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  );
  PROCEDURE sp_process_fee(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR, --so tai khoan
      p_fee      IN NUMBER,  -- phi luu ky
      p_doc      IN VARCHAR, --D or C
      p_refid    IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );
  PROCEDURE sp_open_account(
      p_err_code   IN OUT VARCHAR,
      p_acctno     IN VARCHAR, --so tai khoan
      p_actype     IN VARCHAR,
      p_grname     IN VARCHAR,
      p_policycd   IN VARCHAR,
      p_acclass    IN VARCHAR,
      p_custodycd  IN VARCHAR,
      p_formulacd  IN VARCHAR,
      p_basketid   IN VARCHAR,
      p_trfbuyamt  IN NUMBER,
      p_trfbuyext  IN NUMBER,
      p_banklink   IN VARCHAR,
      p_bankacctno IN VARCHAR,
      p_bankcode   IN VARCHAR,
      p_rate_brk_s IN NUMBER,
      p_rate_brk_b IN NUMBER,
      p_rate_tax   IN NUMBER,
      p_rate_adv   IN NUMBER,
      p_ratio_init IN NUMBER,
      p_ratio_main IN NUMBER,
      p_ratio_exec IN NUMBER,
      p_custid     IN VARCHAR,
      p_dof        IN VARCHAR,
      p_status     IN VARCHAR,
      p_poolid     IN VARCHAR,
      p_roomid     IN VARCHAR,
      p_rate_ub     IN NUMBER,
      p_basketid_ub IN VARCHAR,
      p_bod_d_margin_ub IN NUMBER,
      p_bod_t0value IN NUMBER,     --1.5.7.3 MSBS-1936
      p_err_msg OUT VARCHAR2
      );
  PROCEDURE sp_process_update_money(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR, --so tai khoan
      p_amt      IN NUMBER,  -- so tien
      p_doc      IN VARCHAR,
      p_err_msg OUT VARCHAR2
       );
  PROCEDURE sp_process_update_stock(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR, --so tai khoan
      p_symbol   IN VARCHAR, --ma chung khoan
      p_qtty     IN NUMBER,  -- khoi luong chung khoan
      p_doc      IN VARCHAR,
      p_err_msg OUT VARCHAR2
       );
  PROCEDURE sp_process_balance(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR, --so tai khoan chuyen
      p_amount   IN NUMBER,  -- tong no moi
      p_doc      IN VARCHAR, --D or C
      p_refid    IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );
  PROCEDURE sp_process_money_buyingpower(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR, --so tai khoan chuyen
      p_amount   IN NUMBER,  -- tong no moi
      p_doc      IN VARCHAR, --D or C
      p_refid    IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );
  PROCEDURE sp_process_5105(
      p_err_code    IN OUT VARCHAR,
      p_acctno      IN VARCHAR,
      p_actype      IN VARCHAR,
      p_policycd    IN VARCHAR,
      p_poolid      IN VARCHAR,
      p_roomid      IN VARCHAR,
      p_formulacd   IN VARCHAR,
      p_basketid    IN VARCHAR,
      p_rate_brk_s  IN NUMBER,
      p_rate_brk_b  IN NUMBER,
      p_rate_tax    IN NUMBER,
      p_rate_adv    IN NUMBER,
      p_bod_adv     IN NUMBER,
      p_calc_advbal IN NUMBER,
      p_basketid_ub IN VARCHAR,
      p_bod_d_margin_ub IN NUMBER,
      p_err_msg OUT VARCHAR2
      )
      ;
  PROCEDURE sp_process_5109(
      p_err_code    IN OUT VARCHAR,
      p_acctno      IN VARCHAR, --so tai khoan
      p_rate_brk_s  IN NUMBER,
      p_rate_brk_b  IN NUMBER,
      p_actiontype IN VARCHAR,
      p_err_msg OUT VARCHAR2
       ) ;

  PROCEDURE sp_process_3016(
      p_err_code    IN OUT VARCHAR,
      p_basketid      IN VARCHAR, --so tai khoan
      p_symbol  IN VARCHAR,
      p_price_margin  IN NUMBER,
      p_price_asset in number,
      p_rate_buy in number,
      p_rate_margin in number,
      p_rate_asset in number,
      p_actiontype IN VARCHAR,
      p_err_msg OUT VARCHAR2 );

  PROCEDURE sp_process_update_poolroom(
      p_err_code     IN OUT VARCHAR,
      p_refid     IN VARCHAR,
      p_autoid       IN NUMBER,
      p_policycd IN VARCHAR,
      p_policytype  IN VARCHAR,
      p_refsymbol     IN VARCHAR,
      p_granted  IN NUMBER,
      p_inused   IN NUMBER,
      p_actiontype   IN VARCHAR,
      p_err_msg OUT VARCHAR2
             );

  PROCEDURE sp_process_update_ownpoolroom(
      p_err_code     IN OUT VARCHAR,
      p_refid     IN VARCHAR,
      p_prid       IN varchar,
      p_acctno IN VARCHAR,
      p_policytype  IN VARCHAR,
      p_refsymbol     IN VARCHAR,
      p_inused   IN NUMBER,
      p_actiontype   IN VARCHAR,
      p_err_msg OUT VARCHAR2 );

  PROCEDURE sp_process_5120(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- no bao lanh
            p_type   IN VARCHAR, -- loai no bao lanh hay margin
            p_doc   IN VARCHAR, --C tang, D giam
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2);

  PROCEDURE sp_process_5121(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- so tien
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2);

  PROCEDURE sp_block_stock(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan chuyen
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, --ma chung khoan
      p_qtty     IN NUMBER,   -- KL chung khoan giao dich
      p_doc      IN VARCHAR,
      p_err_msg OUT VARCHAR2
    );
END CSPKS_FO_TRANS;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_trans
AS
  --tang tien tx5001
  PROCEDURE sp_increase_money(p_err_code IN OUT VARCHAR,
              p_acctno   IN VARCHAR2, --so tai khoan
              p_refid    IN VARCHAR2, -- so hieu xu li cua FO
              p_amount   IN NUMBER,
              p_err_msg OUT VARCHAR2
    )
    AS
        v_balance       ACCOUNTS.BOD_BALANCE%TYPE;
        v_debt          ACCOUNTS.BOD_DEBT%TYPE;
        v_advbal        ACCOUNTS.CALC_ADVBAL%TYPE;
        v_payable       ACCOUNTS.BOD_PAYABLE%TYPE;
        v_td            ACCOUNTS.BOD_TD%TYPE;
        v_policycd      ACCOUNTS.POLICYCD%TYPE;
        v_bod_adv       ACCOUNTS.BOD_ADV%TYPE;
        v_poolid        ACCOUNTS.POOLID%TYPE;
        v_roomid        ACCOUNTS.ROOMID%TYPE;
        v_formulacd     ACCOUNTS.FORMULACD%TYPE;
        v_t0value       ACCOUNTS.BOD_T0VALUE%TYPE;
        v_release_pool  NUMBER(20);
        v_currtime      TIMESTAMP;
        v_count         NUMBER;
    v_odramt        NUMBER;
    v_bod_debt_t0   ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin  ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_bod_d_margin_ub ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    BEGIN
    p_err_code := '0';
    p_err_msg:='sp_increase_money p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM dual' INTO v_currtime;
        END;
        SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        IF v_count = 0 THEN
            p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
            RETURN;
        ELSE

            --Lay du lieu cua bang accounts
            SELECT BOD_BALANCE,BOD_DEBT,BOD_ADV,CALC_ADVBAL,BOD_PAYABLE,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB,
                BOD_TD,POLICYCD,POOLID,ROOMID,FORMULACD,BOD_T0VALUE
            INTO v_balance,v_debt,v_bod_adv,v_advbal, v_payable,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,
                v_td,v_policycd, v_poolid,v_roomid,v_formulacd,v_t0value
            FROM ACCOUNTS WHERE ACCTNO = p_acctno;
            /*
            tiendt added for buy amount, date: 2015-08-24
            */
            v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
            /*end*/

            UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE+p_amount WHERE ACCTNO=p_acctno;

            IF (v_formulacd != 'ADV') AND (v_formulacd != 'CASH') THEN
                --Kiem tra trang thai no cua tai khoan
                v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code, p_amount,v_balance,v_bod_adv + v_advbal,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
                --  dbms_output.put_line('so tien giao dich dung pool : ' || v_release_pool);
                IF v_release_pool > 0 AND v_poolid IS NOT NULL THEN
                    --nha poolroom
                    CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code,NULL,NULL,NULL,p_acctno,v_poolid,v_release_pool,0,0,p_err_msg);
                    IF v_roomid IS NOT NULL THEN
--            dbms_output.put_line('v_payable ' || v_payable);
--            dbms_output.put_line('v_bod_debt_t0 ' || v_bod_debt_t0);
--            dbms_output.put_line('v_bod_d_margin ' || v_bod_d_margin);
--            dbms_output.put_line('v_bod_d_margin_ub ' || v_bod_d_margin_ub);
--            dbms_output.put_line('v_odramt ' || v_odramt);
--            dbms_output.put_line('p_amount ' || p_amount);
--            dbms_output.put_line('v_bod_adv ' || v_bod_adv);
--            dbms_output.put_line('v_advbal ' || v_advbal);
--            dbms_output.put_line('v_td ' || v_td);
--            dbms_output.put_line('v_bod_t0value ' || v_bod_t0value);
            /*
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_roomid',v_roomid);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_payable',v_payable);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_ordamt',v_odramt);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'0','0');
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_balance',v_balance+p_amount);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_bod_adv',v_bod_adv);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_advbal',v_advbal);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_td',v_td);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'v_t0value',v_t0value);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'p_order_id',null);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'p_side',null);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'p_symbol',null);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_TIEN',p_acctno,null,'0',0);
            */
                        CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_odramt,0,v_balance+p_amount,v_bod_adv,v_advbal,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);
                    END IF;
                END IF;
            END IF;
            --cap nhat thong tin giao dich vao bang transaction
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                p_err_msg:='sp_increase_money ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_increase_money;

  --giam tien tx5001
  PROCEDURE sp_decrease_money(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_amount   IN NUMBER,
            p_err_msg OUT VARCHAR2
  )
    AS
        v_balance       ACCOUNTS.BOD_BALANCE%TYPE;
        v_debt          ACCOUNTS.BOD_DEBT%TYPE;
        v_debt_m          ACCOUNTS.BOD_DEBT_M%TYPE;
        v_advbal        ACCOUNTS.CALC_ADVBAL%TYPE;
        v_payable       ACCOUNTS.BOD_PAYABLE%TYPE;
        v_odramt        ACCOUNTS.CALC_ODRAMT%TYPE;
        v_td            ACCOUNTS.BOD_TD%TYPE;
        v_crlimit         ACCOUNTS.BOD_CRLIMIT%TYPE;
        v_policycd      ACCOUNTS.POLICYCD%TYPE;
        v_basketid        ACCOUNTS.BASKETID%TYPE;
        v_bod_adv       ACCOUNTS.BOD_ADV%TYPE;
        v_poolid        ACCOUNTS.POOLID%TYPE;
        v_roomid        ACCOUNTS.ROOMID%TYPE;
        v_t0value       ACCOUNTS.BOD_T0VALUE%TYPE;
        v_using_pool      NUMBER;
        v_currtime        TIMESTAMP;
        v_count           NUMBER;
        v_withdraw_cash NUMBER;
    v_bod_debt_t0   ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin  ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_rate_ub       ACCOUNTS.RATE_UB%TYPE;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;

    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_decrease_money p_acctno=>'||p_acctno;
        BEGIN
            EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        SELECT COUNT(1) INTO v_count FROM accounts WHERE acctno = p_acctno;
        IF v_count    = 0 THEN
            p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
            RETURN;
        ELSE
      --lay thong tin bang accounts
            SELECT BOD_BALANCE,BOD_DEBT,BOD_DEBT_M,BOD_ADV,CALC_ADVBAL,BOD_PAYABLE,BOD_D_MARGIN_UB,
                POLICYCD,BOD_TD,BOD_CRLIMIT,BASKETID,POOLID,ROOMID,BOD_T0VALUE,BOD_DEBT_T0,BOD_D_MARGIN,RATE_UB
            INTO v_balance,v_debt,v_debt_m,v_bod_adv,v_advbal,v_payable,v_bod_d_margin_ub,
                v_policycd,v_td,v_crlimit,v_basketid,v_poolid,v_roomid,v_t0value,v_bod_debt_t0,v_bod_d_margin,v_rate_ub
            FROM ACCOUNTS WHERE ACCTNO = p_acctno;

      IF (p_amount = 0) THEN
        p_err_code := '0';
        RETURN;
      END IF;
            /*
            tiendt added for buy amount, date: 2015-08-24
            */
            v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'ki quy mua : ',v_odramt);
            /*end*/
            -- tinh so tien duoc rut
            --v_withdraw_cash := CSPKS_FO_COMMON.fn_get_VNDwithdraw(p_acctno,v_balance,v_bod_adv+v_advbal,v_payable,v_debt,v_debt_m,v_td,v_crlimit,v_roomid,v_rate_ub);
          /*so tien duoc rut theo ban MSBS*/
      v_withdraw_cash := CSPKS_FO_COMMON.fn_get_VNDwithdraw2(p_acctno);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'so tien rut : ',v_withdraw_cash);

            IF (p_amount <= v_withdraw_cash) AND v_policycd IS NULL THEN
                -- thuc hien rut tien va ko can check pool/room
                UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE-p_amount WHERE ACCTNO=p_acctno;
            ELSIF (p_amount <= v_withdraw_cash) AND v_policycd IS NOT NULL THEN
                --Kiem tra trang thai no cua tai khoan
                v_using_pool := CSPKS_FO_POOLROOM.fn_get_using_pool(p_err_code, p_amount,v_balance,v_bod_adv+v_advbal,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
                --dbms_output.put_line('so tien giao dich dung pool  : ' || v_using_pool);
                IF v_using_pool > 0 THEN
                    --Kiem tra pool voi so pool dung them
                    CSPKS_FO_POOLROOM.sp_process_checkpool(p_err_code,v_poolid,v_using_pool,p_err_msg);

                    IF p_err_code != '0' THEN -- khong du pool
                        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                        -- p_err_code := '-90014';
                        RETURN;
                    ELSE
                        CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,p_acctno,v_roomid,p_amount,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,0,NULL,0,v_t0value,p_err_msg);
                    END IF;
                    IF p_err_code = '0' THEN
                        UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE-p_amount WHERE ACCTNO=p_acctno;
                        --Danh dau pool/room tuong ung voi so pool dung them
                        CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code,NULL,NULL,NULL,p_acctno,v_poolid,v_using_pool,0,0,p_err_msg);
            /*
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_roomid',v_roomid);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_payable',v_payable);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_odramt',v_odramt);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'0','0');
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_balance-p_amount',v_balance-p_amount);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_bod_adv',v_bod_adv);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_advbal',v_advbal);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_td',v_td);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_t0value',v_t0value);
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_side','NULL');
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'v_symbol','NULL');
            insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_TIEN',p_acctno,null,'f_qtty',0);
            */
                        CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance-p_amount,v_bod_adv,v_advbal,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);

                    ELSE --khong du room
                        --cap nhat bang transactions
                        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                        -- p_err_code := '-90015';
                        RETURN ;
                    END IF;

                ELSE --v_using_pool = 0
                    -- khong check pool/room, thuc hien update tien tk
                    UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE-p_amount WHERE ACCTNO=p_acctno;
                END IF;
            ELSE --khong du tien
                p_err_code := '-90003';
                UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                RETURN;
            END IF;
            --cap nhat thong tin giao dich thanh cong vao bang transaction
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_decrease_money '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_decrease_money;

  --tang CK tx5005
  PROCEDURE sp_increase_stock(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_symbol   IN VARCHAR2, --ma chung khoan
            p_qtty     IN NUMBER,
            p_err_msg OUT VARCHAR2
  )
    AS
        v_currtime            TIMESTAMP;
        v_count               NUMBER;
        v_count_acctno          NUMBER;
    v_ownroomid         VARCHAR(20);
    v_amount            NUMBER;
    v_rate_asset        NUMBER := 0;
    v_price_asset       NUMBER := 0;
    v_odramt            NUMBER;
    v_balance           ACCOUNTS.BOD_BALANCE%TYPE;
    v_advbal            ACCOUNTS.CALC_ADVBAL%TYPE;
    v_bod_adv           ACCOUNTS.BOD_ADV%TYPE;
    v_payable           ACCOUNTS.BOD_PAYABLE%TYPE;
    v_debt              ACCOUNTS.BOD_DEBT%TYPE;
    v_td                ACCOUNTS.BOD_TD%TYPE;
    v_t0value           ACCOUNTS.BOD_T0VALUE%TYPE;
    v_roomid            ACCOUNTS.ROOMID%TYPE;
    v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_formulacd         ACCOUNTS.FORMULACD%TYPE;
    v_release_pool      NUMBER;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_count_ins         NUMBER;
    v_formulacd_rtn     NUMBER(20,2);

    BEGIN
        p_err_msg:='sp_increase_stock p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        p_err_code := '0';
        SELECT COUNT(1) INTO v_count_acctno FROM accounts WHERE acctno = p_acctno;
        IF v_count_acctno = 0 THEN
            p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
            RETURN;
        ELSE
            --lay thong tin tai khoan
            SELECT BOD_BALANCE,CALC_ADVBAL,BOD_ADV,BOD_PAYABLE,BOD_DEBT,BOD_D_MARGIN_UB,
                BOD_TD,BOD_T0VALUE,ROOMID,BOD_DEBT_T0,BOD_D_MARGIN,FORMULACD
            INTO v_balance,v_advbal,v_bod_adv,v_payable,v_debt,v_bod_d_margin_ub,
                v_td,v_t0value,v_roomid,v_bod_debt_t0,v_bod_d_margin,v_formulacd
            FROM ACCOUNTS WHERE ACCTNO = p_acctno;
      --gia tri ki quy tai khoan
      v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);

            --kiem tra ma CK ton tai trong tai khoan chua
            SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
            /*dung.bui : fix gd cac ma WFT theo yeu cau a Thanh,c Chung*/
            /*date : 24/02/2016*/
            IF (v_count = 0) THEN --luu ki moi
              SELECT COUNT(1) INTO v_count_ins FROM INSTRUMENTS WHERE SYMBOL=p_symbol;
              IF v_count_ins = 0 THEN
                p_err_code :='0';
                RETURN;
              END IF;
            /*end*/
              -- INSERT ban ghi moi vao bang PORTFOLIOS
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
            INSERT INTO PORTFOLIOS (ACCTNO,SYMBOL,TRADE,LASTCHANGE,BOD_RTN) VALUES (p_acctno,p_symbol,p_qtty,v_currtime,v_formulacd_rtn);

        SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
        IF (v_count=1) THEN --ma nam trong room db,danh dau
          --process for ownpoolroom
          SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
          CSPKS_FO_POOLROOM.sp_process_markownroom(p_err_code,p_acctno,v_ownroomid,p_symbol,p_qtty,NULL,NULL,p_err_msg);
        ELSIF (v_count=0) THEN
--          dbms_output.put_line('v_roomid' ||v_roomid);
--          dbms_output.put_line('v_payable'||v_payable);
--          dbms_output.put_line('v_bod_debt_t0'||v_bod_debt_t0);
--          dbms_output.put_line('v_bod_d_margin'||v_bod_d_margin);
--          dbms_output.put_line('v_bod_d_margin_ub'||v_bod_d_margin_ub);
--          dbms_output.put_line('v_odramt'||v_odramt);
--          dbms_output.put_line('v_balance'||v_balance);
--          dbms_output.put_line('v_bod_adv'||v_bod_adv);
--          dbms_output.put_line('v_advbal'||v_advbal);
--          dbms_output.put_line('v_td'||v_td);
--          dbms_output.put_line('v_t0value'||v_t0value);
--          dbms_output.put_line('p_symbol'||p_symbol);
--          dbms_output.put_line('p_qtty'||p_qtty);
          /*
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_roomid',v_roomid);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_payable',v_payable);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_odramt',v_odramt);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'0','0');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_balance',v_balance);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_adv',v_bod_adv);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_advbal',v_advbal);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_td',v_td);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_t0value',v_t0value);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_side','NULL');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_symbol','NULL');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'f_qtty',0);
          */
          --dung.bui fix bug markroom, date 16/11/2015
          CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,null,null,p_symbol,p_qtty,p_err_msg);
          --end--
        END IF;

            ELSE --nop them CK
        --update bang portfolios
        UPDATE PORTFOLIOS SET TRADE=TRADE+p_qtty,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
        SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;

        IF (v_count=1) THEN --ma nam trong room db

          --process for ownpoolroom
          SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
          --danh dau ma nam trong room db trong gd
          CSPKS_FO_POOLROOM.sp_process_markownroom(p_err_code,p_acctno,v_ownroomid,p_symbol,p_qtty,NULL,NULL,p_err_msg);
          /*
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_roomid',v_roomid);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_payable',v_payable);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_odramt',v_odramt);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'0','0');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_balance',v_balance);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_bod_adv',v_bod_adv);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_advbal',v_advbal);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_td',v_td);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_t0value',v_t0value);
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_side','NULL');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'v_symbol','NULL');
          insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TANG_CK',p_acctno,null,'f_qtty',0);
          */
          --nha danh dau ma khac
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
            v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);

        ELSIF v_count = 0 THEN --ma CK ko nam trong room db

          IF (v_formulacd != 'CASH' AND v_formulacd != 'ADV') THEN
            -- tinh so tien quy doi tu KL CK cua giao dich
            SELECT COUNT(1) INTO v_count FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
            WHERE AC.ACCTNO=p_acctno AND PO.SYMBOL=p_symbol AND AC.ACCTNO=PO.ACCTNO AND BA.BASKETID=AC.BASKETID AND PO.SYMBOL=BA.SYMBOL;
            IF (v_count=1) THEN
              SELECT BA.RATE_ASSET,BA.PRICE_ASSET INTO v_rate_asset,v_price_asset FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
              WHERE AC.ACCTNO=p_acctno AND PO.SYMBOL=p_symbol AND AC.ACCTNO=PO.ACCTNO AND BA.BASKETID=AC.BASKETID AND PO.SYMBOL=BA.SYMBOL;
            END IF;
            v_amount := p_qtty * v_rate_asset * v_price_asset/100;
            --dbms_output.put_line('v_amount : ' || v_amount);
            v_release_pool := CSPKS_FO_POOLROOM.fn_get_release_pool(p_err_code,v_amount,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
            --kiem tra trang thai no tai khoan
            IF v_release_pool > 0 THEN
              /*
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_roomid',v_roomid);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_payable',v_payable);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_odramt',v_odramt);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'0','0');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_balance',v_balance);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_adv',v_bod_adv);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_advbal',v_advbal);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_td',v_td);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_t0value',v_t0value);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_side','NULL');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'p_symbol',p_symbol);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'p_qtty',p_qtty);
              */
              --xu li danh dau room
              CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,null,null,p_symbol,p_qtty,p_err_msg);
            END IF;
          END IF;
        END IF;

            END IF;
            -- cap nhat giao dich
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_increase_stock '||p_err_msg||' sqlerrm = '||SQLERRM;

    END sp_increase_stock;

  --giam CK tx5005
  PROCEDURE sp_decrease_stock(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_symbol   IN VARCHAR2, --ma chung khoan
            p_qtty     IN NUMBER,
            p_err_msg OUT VARCHAR2
  )
    AS
        v_odramt            NUMBER;
        v_count             NUMBER;
        v_count_instruments             NUMBER;
        v_cnt_symbol_basketid           NUMBER;
        v_amount            NUMBER;
        v_account           NUMBER;
        v_currtime          TIMESTAMP;
        v_balance             ACCOUNTS.BOD_BALANCE%TYPE;
        v_debt                ACCOUNTS.BOD_DEBT%TYPE;
        v_advbal              ACCOUNTS.CALC_ADVBAL%TYPE;
        v_payable             ACCOUNTS.BOD_PAYABLE%TYPE;
        v_td                  ACCOUNTS.BOD_TD%TYPE;
        v_rate_asset        BASKETS.RATE_ASSET%TYPE;
        v_price_asset       BASKETS.PRICE_ASSET%TYPE;
        v_policycd            ACCOUNTS.POLICYCD%TYPE;
        v_bod_adv             ACCOUNTS.BOD_ADV%TYPE;
        v_bod_t0value         ACCOUNTS.BOD_T0VALUE%TYPE;
        v_roomid              ACCOUNTS.ROOMID%TYPE;
        v_release_qtty      NUMBER;
        v_release_qtty_ub   NUMBER;
        v_release_amt       NUMBER;
        v_release_amt_ub    NUMBER;
        v_marked            PORTFOLIOS.MARKED%TYPE;
        v_markedcom         PORTFOLIOS.MARKEDCOM%TYPE;
        v_trade             PORTFOLIOS.TRADE%TYPE;
    v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
    v_ownroomid         VARCHAR(20);
    v_basketid          ACCOUNTS.BASKETID%TYPE;
    v_basketid_ub       ACCOUNTS.BASKETID_UB%TYPE;
    v_tradeEX           NUMBER;
    v_markedEX          NUMBER;
    v_markedcomEX         NUMBER;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_decrease_stock p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE immediate 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        /*select rate_buy, price_margin, price_asset,rate_asset,rate_margin
        from accounts ac , portfolios po ,baskets ba
        where ac.acctno ='0001000001' and ac.acctno = po.acctno
        and ba.basketid = ac.basketid and po.symbol = ba.symbol and po.symbol ='VTO'; */
        SELECT COUNT(1) INTO v_account FROM ACCOUNTS WHERE ACCTNO=p_acctno;
        IF v_account  = 0 THEN
          p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
          RETURN;
        ELSE
            --kiem tra ma CK ton tai trong tai khoan chua
            SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
            IF (v_count = 0) THEN
                p_err_code :='0';
                RETURN;
                /*
                --Kiem tra ma co trong bang instruments ko?
                SELECT COUNT(1) INTO v_count_instruments FROM INSTRUMENTS WHERE SYMBOL=p_symbol;
                IF v_count_instruments = 0 THEN
                  p_err_code :='0';
                  RETURN;
                ELSE
                  p_err_code := '-90004';
                  --dbms_output.put_line('p_err_code : ' || p_err_code);
                  UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                  RETURN;
                END IF;
                */
            ELSE -- v_count = 1
                --Lay du lieu cua bang accounts
                SELECT BOD_BALANCE,BOD_DEBT,CALC_ADVBAL,BOD_PAYABLE,CALC_ODRAMT,POLICYCD,BOD_TD,BOD_ADV,ROOMID,
        BOD_T0VALUE,BOD_DEBT_T0,BOD_D_MARGIN,BOD_D_MARGIN_UB,BASKETID,BASKETID_UB
                INTO v_balance,v_debt,v_advbal,v_payable,v_odramt,v_policycd,v_td,v_bod_adv,v_roomid,
        v_bod_t0value,v_bod_debt_t0,v_bod_d_margin,v_bod_d_margin_ub,v_basketid,v_basketid_ub
                FROM ACCOUNTS WHERE ACCTNO = p_acctno;
                /*
                tiendt added for buy amount, date: 2015-08-24
                */
                v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
        --dbms_output.put_line('v_odramt ' || v_odramt);
                /*end*/
                SELECT TRADE-SELLINGQTTY INTO v_trade FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;

                --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
                BEGIN
                   SELECT -SELLINGQTTY INTO v_tradeEx FROM PORTFOLIOSEX WHERE ACCTNO = p_acctno and SYMBOL= p_symbol;
                EXCEPTION WHEN OTHERS THEN
                   v_tradeEx:=0;
                END;

                v_trade := v_trade + v_tradeEx;

                --dbms_output.put_line('1111111 : ' || v_trade);
                IF (p_qtty <= v_trade) AND (v_policycd IS NULL) THEN
                    UPDATE PORTFOLIOS SET TRADE=TRADE-p_qtty WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
                ELSIF (p_qtty <= v_trade) AND (v_policycd IS NOT NULL) THEN
                    /*
          SELECT COUNT(1) INTO v_count FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
                    WHERE AC.ACCTNO=p_acctno AND PO.SYMBOL=p_symbol AND AC.ACCTNO=PO.ACCTNO AND BA.BASKETID=AC.BASKETID AND PO.SYMBOL=BA.SYMBOL;
                    IF (v_count = 0) THEN
                        v_rate_asset  := 0;
                        v_price_asset := 0;
                    ELSE
                        SELECT BA.RATE_ASSET,BA.PRICE_ASSET INTO v_rate_asset,v_price_asset
                        FROM BASKETS BA,ACCOUNTS AC,PORTFOLIOS PO
                        WHERE AC.ACCTNO=p_acctno AND PO.SYMBOL=p_symbol AND AC.ACCTNO=PO.ACCTNO
                            AND BA.BASKETID=AC.BASKETID AND PO.SYMBOL=BA.SYMBOL;
                    END IF;
                    -- tinh so tien quy doi tu KL CK cua giao dich
                    v_amount := p_qtty * v_rate_asset * v_price_asset/100;
          dbms_output.put_line('v_amount : ' || v_amount);
          */
                    --Kiem tra room
                    IF (v_roomid IS NOT NULL) THEN
            SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;

            IF v_count = 1 THEN --Ma CK gan trong room db
              --dbms_output.put_line('xu li cho room dac biet');

              SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
              CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,p_acctno,v_roomid,/*v_amount*/0,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance, v_bod_adv,v_advbal,v_td,0,p_symbol,-p_qtty,v_bod_t0value,p_err_msg);

              IF p_err_code = '0' THEN
                UPDATE PORTFOLIOS SET TRADE=TRADE-p_qtty WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
                CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code,p_acctno,v_ownroomid,p_symbol,p_qtty,NULL,NULL,p_err_msg);
                /*
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_roomid',v_roomid);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_payable',v_payable);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_odramt',v_odramt);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_balance',v_balance);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_adv',v_bod_adv);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_advbal',v_advbal);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_td',v_td);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_t0value',v_bod_t0value);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_side','NULL');
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_symbol','NULL');
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'f_qtty',0);
                */
                -- Danh dau sang CK khac
                CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0, v_balance,v_bod_adv,v_advbal,v_td,v_bod_t0value,NULL,NULL,NULL,0,p_err_msg);

                --TODO: tiendt: khong xu ly danh dau sang ma khac
              ELSE
                p_err_code := '-90015';
                UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                RETURN;
              END IF;

            ELSIF v_count=0 THEN --ma thuong
              --ThanhNV sua 2016.09.07 Tat cac ma thuoc ro, hay khong thuoc ro deu check:
              --Kiem tra ma chung khoan co thuoc ro, neu khong thuoc ro thi khong check Room.
              /*
              SELECT count(*) INTO v_cnt_symbol_basketid FROM baskets WHERE (basketid = v_basketid OR basketid =v_basketid_ub) AND  symbol = p_symbol;
              IF v_cnt_symbol_basketid =0 THEN
                p_err_code:='0';
              ELSE
              */

                CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,p_acctno,v_roomid,/*v_amount*/0,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance, v_bod_adv,v_advbal,v_td,0,p_symbol,0,v_bod_t0value,p_err_msg);
              --END IF;
              IF p_err_code = '0' THEN
                -- tk du room, cap nhat CKGD
                UPDATE PORTFOLIOS SET TRADE=TRADE-p_qtty WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
                SELECT MARKED,MARKEDCOM INTO v_marked,v_markedcom FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;

                --ThanhNV sua 10/12/2015 lay bang portfoliosEX de tranh lock.
                BEGIN
                   SELECT MARKED, MARKEDCOM  INTO v_markedEX,v_markedcomEX FROM PORTFOLIOSEX WHERE ACCTNO = p_acctno and SYMBOL= p_symbol;
                EXCEPTION WHEN OTHERS THEN
                   v_markedEX:=0;
                   v_markedcomEX :=0;
                END;

                v_marked := v_marked + v_markedEX;
                v_markedcom := v_markedcom + v_markedcomEX;


                v_release_qtty    := LEAST(v_marked,p_qtty);
                v_release_qtty_ub := LEAST(v_markedcom,p_qtty);
                v_release_amt     := v_release_qtty * (v_price_asset * (v_rate_asset / 100));
                v_release_amt_ub  := v_release_qtty_ub * (v_price_asset * (v_rate_asset / 100));
                --insert allocation
                IF v_roomid = 'SYSTEM' THEN
                  UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                  IF (v_release_qtty > 0) THEN
                    INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                      DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                    VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_acctno,v_release_qtty,NULL,
                                        'C','R',NULL,0,v_roomid,v_release_amt,'P',SYSDATE);
                  END IF;
                  IF (v_basketid !=v_basketid_ub) THEN --tk dong tai tro
                    --dbms_output.put_line('nha room ub');
                    UPDATE PORTFOLIOS SET MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                    IF v_release_qtty_ub > 0 THEN
                      INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                        DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                      VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_acctno,v_release_qtty_ub,NULL,
                        'C','R',NULL,0,'UB',v_release_amt_ub,'P',SYSDATE);
                    END IF;
                  END IF;
                ELSIF v_roomid = 'UB' THEN
                  UPDATE PORTFOLIOS SET MARKED=MARKED-v_release_qtty,MARKEDCOM=MARKEDCOM-v_release_qtty_ub WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
                  IF (v_release_qtty_ub > 0) THEN
                    INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                      DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                    VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_acctno,v_release_qtty_ub,NULL,
                      'C','R',NULL,0,v_roomid,v_release_amt_ub,'P',SYSDATE);
                  END IF;
                  IF (v_release_qtty > 0) THEN
                    INSERT INTO ALLOCATION(AUTOID,ORDERID,SIDE,SYMBOL,ACCTNO,QTTY,PRICE,
                      DOC,POLICYCD,POOLID,POOLVAL,ROOMID,ROOMVAL,STATUS,LASTCHANGE)
                    VALUES(SEQ_COMMON.NEXTVAL,NULL,NULL,p_symbol,p_acctno,v_release_qtty,NULL,
                      'C','R',NULL,0,'SYSTEM',v_release_amt,'P',SYSDATE);
                  END IF;
                END IF;
                /*
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_roomid',v_roomid);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_payable',v_payable);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_odramt',v_odramt);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'0','0');
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_balance',v_balance);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_adv',v_bod_adv);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_advbal',v_advbal);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_td',v_td);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_bod_t0value',v_bod_t0value);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_side','NULL');
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'v_symbol','NULL');
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GIAM_CK',p_acctno,null,'f_qtty',0);
                */
                --nha danh dau
                CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_bod_t0value,NULL,NULL,NULL,0,p_err_msg);

                -- Danh dau sang CK khac neu tai san danh dau < du no
                CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
                v_bod_d_margin_ub,v_odramt,0,v_balance,v_bod_adv,v_advbal,v_td,v_bod_t0value,NULL,NULL,NULL,0,p_err_msg);
              ELSE
                --'Khong du Room'
                UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                RETURN;
              END IF;
            ELSE -- COUNT du lieu ko hop le
              p_err_code := '-90025';
              RETURN;
            END IF;
          END IF;
                ELSE
                    p_err_code := '-90007';
                    -- cap nhat giao dich trang thai bi tu choi
                    UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                END IF;
            END IF;
            -- Cap nhat giao dich thanh cong
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:='sp_decrease_stock '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_decrease_stock;

  --UTTB tx5006
  PROCEDURE sp_advancePayment(
            p_err_code    OUT VARCHAR,
            p_acctno      IN VARCHAR, --so tai khoan
            p_refid       IN VARCHAR, -- so hieu xu li cua FO
            p_bod_balance IN NUMBER,  --so tien mat tang
            p_bod_adv     IN NUMBER,  -- so tien ung t1,t2 bi giam
            p_calc_advbal IN NUMBER,  --so tien ung t3 bi giam
            p_doc         IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
    AS
        v_bod_adv           ACCOUNTS.BOD_ADV%TYPE;
        v_advbal            ACCOUNTS.CALC_ADVBAL%TYPE;
        v_currtime            TIMESTAMP;
        v_account             NUMBER;

    BEGIN
        p_err_msg:='sp_advancePayment p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        p_err_code := '0';
        SELECT COUNT(1) INTO v_account FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        IF v_account  = 0 THEN
            p_err_code := '-90019';
            UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
            RETURN;
        ELSE

            --Lay du lieu cua bang accounts
            SELECT CALC_ADVBAL,BOD_ADV INTO v_advbal,v_bod_adv FROM ACCOUNTS WHERE ACCTNO = p_acctno;
          --dbms_output.put_line('v_advbal '||v_advbal);
          --dbms_output.put_line('v_bod_adv '||v_bod_adv);
            IF (p_doc = 'R') THEN
                UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE-p_bod_balance,
                            CALC_ADVBAL=CALC_ADVBAL+p_calc_advbal,
                            BOD_ADV=BOD_ADV+p_bod_adv
                WHERE ACCTNO=p_acctno;
            ELSE
            --dbms_output.put_line('v_bod_adv '||v_bod_adv);
            --dbms_output.put_line('p_bod_adv '||p_bod_adv);
            --dbms_output.put_line('p_calc_advbal '||p_calc_advbal);
                --check dk ung truoc
                IF p_bod_adv <= v_bod_adv AND p_calc_advbal <= v_advbal THEN
                    -- tang tien mat va giam tien ung truoc
                    UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE+p_bod_balance,
                              CALC_ADVBAL=CALC_ADVBAL-p_calc_advbal,
                              BOD_ADV=BOD_ADV-p_bod_adv
                    WHERE ACCTNO = p_acctno;
                ELSE
                    --dbms_output.put_line('So du khong du');
                    --ko du dk ung truoc
                    UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE+ Trunc(least(p_bod_adv,v_bod_adv) + LEAST(p_calc_advbal,v_advbal)),
                    CALC_ADVBAL=CALC_ADVBAL-least(p_calc_advbal,v_advbal) ,
                    BOD_ADV=BOD_ADV-least(p_bod_adv,v_bod_adv)
                    WHERE ACCTNO = p_acctno;
/*                    p_err_code := '-90003';
                    UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
                    RETURN;*/
                END IF;
            END IF;
            -- cap nhat giao dich
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:='sp_advancePayment '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_advancePayment;

  --cam co CK tx5009
  PROCEDURE sp_register_mortage(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_symbol   IN VARCHAR2, -- ma chung khoan
            p_qtty     IN NUMBER,
            p_err_msg OUT VARCHAR2
  )
    AS
        v_trade         PORTFOLIOS.TRADE%TYPE;
        v_currtime      TIMESTAMP;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_register_mortage p_acctno=>'||p_acctno;
        BEGIN
            EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        SELECT TRADE INTO v_trade FROM PORTFOLIOS WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;

        -- Kiem tra CK giao dich co du cam co khong
        IF (p_qtty <= v_trade) THEN
            -- Giam CK giao dich, tang CK cam co
            UPDATE PORTFOLIOS SET TRADE=TRADE-p_qtty,MORTGAGE=MORTGAGE+p_qtty
            WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
            -- Tang tien mat, tang no
            --UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE + p_amount,BOD_DEBT = BOD_DEBT + p_amount
            --WHERE ACCTNO = p_acctno;
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        ELSE  --khong du CK thuc hien cam co
            -- cap nhat trang thai giao dich
            UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
            p_err_code := '-90007';
            RETURN;
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:='sp_register_mortage '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_register_mortage;

  --giai toa cam co tx5010
  PROCEDURE sp_unregister_mortage(
              p_err_code IN OUT VARCHAR,
              p_acctno   IN VARCHAR2, --so tai khoan
              p_refid    IN VARCHAR2, -- so hieu xu li cua FO
              p_symbol   IN VARCHAR2, --ma chung khoan
              p_qtty     IN NUMBER,
              p_err_msg OUT VARCHAR2
    )
    AS
        v_mortgage            PORTFOLIOS.MORTGAGE%TYPE;
        v_balance           ACCOUNTS.BOD_BALANCE%TYPE;
        v_advbal            ACCOUNTS.CALC_ADVBAL%TYPE;
        v_currtime            TIMESTAMP;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_unregister_mortage p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        SELECT MORTGAGE INTO v_mortgage FROM PORTFOLIOS
        WHERE SYMBOL = p_symbol AND ACCTNO = p_acctno;

        SELECT BOD_BALANCE,CALC_ADVBAL INTO v_balance,v_advbal FROM ACCOUNTS
        WHERE ACCTNO = p_acctno;
        --Kiem tra so tien co du cho giai toa CK khong
        --Kiem tra so du CK cam co co du giai toa khong
        /*IF (p_amount <= (v_balance + v_advbal)) AND (p_qtty <= v_mortgage) THEN
        UPDATE PORTFOLIOS SET TRADE = TRADE + p_qtty,MORTGAGE = MORTGAGE - p_qtty
        WHERE SYMBOL = p_symbol AND ACCTNO = p_acctno;
        UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE - p_amount,BOD_DEBT = BOD_DEBT - p_amount
        WHERE ACCTNO = p_acctno;
        ELSE
        UPDATE TRANSACTIONS SET STATUS = 'R', TIME_EXECUTED = v_currtime, LASTCHANGE = v_currtime
        WHERE REFID = p_refid;
        p_err_code := '-90003';
        END IF;*/

        IF (p_qtty <= v_mortgage) THEN
            --Tang CK giao dich, giam CK cam co
            UPDATE PORTFOLIOS SET TRADE=TRADE+p_qtty,MORTGAGE=MORTGAGE-p_qtty WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
            --cap nhat giao dich
            UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        ELSE
            p_err_code := '-90007';
            UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:='sp_unregister_mortage '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_unregister_mortage;

  --dieu chinh pool quan tri tx5014
  PROCEDURE sp_update_pool(
            p_err_code IN OUT VARCHAR,
            p_refid    IN VARCHAR,  -- so hieu xu li cua BO
            p_policycd IN VARCHAR2, --ma nhom chinh sach
            p_amount   IN NUMBER,
            p_err_msg OUT VARCHAR2
          )
  AS
    v_count         NUMBER;
    v_currtime      TIMESTAMP;
    v_autoid        NUMBER; --ma quy dinh
  BEGIN
    p_err_msg:='sp_update_pool p_refid=>'||p_refid;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM POOLROOM WHERE POLICYCD=p_policycd AND POLICYTYPE='P';
    IF (v_count=0) THEN
      -- them moi
      SELECT SEQ_POOLROOM.NEXTVAL INTO v_autoid FROM DUAL;
      INSERT INTO POOLROOM(AUTOID,POLICYCD,POLICYTYPE,REFSYMBOL,GRANTED,INUSED)
        VALUES(v_autoid,p_policycd,'P','VND',p_amount,0);
    ELSIF (v_count = 1) THEN
      -- thuc hien update
        UPDATE POOLROOM SET GRANTED=p_amount WHERE POLICYCD=p_policycd AND POLICYTYPE = 'P';
    ELSE
      --dbms_output.put_line('Du lieu khong hop le');
      p_err_code := '-90025';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
      RETURN;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
    EXCEPTION
      WHEN OTHERS THEN
      p_err_code := '-90025';
      p_err_msg:='sp_update_pool '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_update_pool;

  --dieu chinh room quan tri tx5015
  PROCEDURE sp_update_room(
            p_err_code  IN OUT VARCHAR,
            p_refid     IN VARCHAR,  -- so hieu xu li cua BO
            p_policycd  IN VARCHAR2, --ma nhom chinh sach
            p_refsymbol IN VARCHAR2, --ma chung khoan)
            p_amount    IN NUMBER,
            p_err_msg OUT VARCHAR2
    )
  AS
    v_count         NUMBER;
    v_currtime      TIMESTAMP;
    v_autoid        NUMBER; --ma quy dinh
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_update_room p_refid=>'||p_refid;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    SELECT COUNT(1) INTO v_count FROM POOLROOM
    WHERE POLICYCD=p_policycd AND REFSYMBOL=p_refsymbol AND POLICYTYPE='R';
    IF (v_count=0) THEN
      -- them moi
      SELECT SEQ_POOLROOM.NEXTVAL INTO v_autoid FROM DUAL;
      INSERT INTO POOLROOM(AUTOID,POLICYCD,POLICYTYPE,REFSYMBOL,GRANTED,INUSED)
      VALUES(v_autoid,p_policycd,'R',p_refsymbol,p_amount,0);
    ELSIF (v_count = 1) THEN
      -- thuc hien update
      UPDATE POOLROOM SET GRANTED=p_amount
      WHERE POLICYCD=p_policycd AND REFSYMBOL=p_refsymbol AND POLICYTYPE='R';
    ELSE
      --dbms_output.put_line('Du lieu khong hop le');
      p_err_code := '-90025';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
      RETURN;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_update_room '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_update_room;

  --gui tiet kiem tx5012
  PROCEDURE sp_deposit_saving(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_amount   IN NUMBER ,
            p_err_msg OUT VARCHAR2
    )
    AS
        v_currtime            TIMESTAMP;
        v_count           NUMBER;
        v_withdraw_cash   NUMBER :=0;
        v_balance           ACCOUNTS.BOD_BALANCE%TYPE;
        v_debt              ACCOUNTS.BOD_DEBT%TYPE;
        v_debt_m            ACCOUNTS.BOD_DEBT_M%TYPE;
        v_advbal            ACCOUNTS.CALC_ADVBAL%TYPE;
        v_bod_adv           ACCOUNTS.BOD_ADV%TYPE;
        v_payable           ACCOUNTS.BOD_PAYABLE%TYPE;
        v_td                ACCOUNTS.BOD_TD%TYPE;
        v_crlimit             ACCOUNTS.BOD_CRLIMIT%TYPE;
        v_odramt              ACCOUNTS.CALC_ODRAMT%TYPE;
        v_basketid            ACCOUNTS.BASKETID%TYPE;
        v_policycd            ACCOUNTS.POLICYCD%TYPE;
        v_roomid            ACCOUNTS.ROOMID%TYPE;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_deposit_saving p_acctno=>'||p_acctno;

        BEGIN
          EXECUTE IMMEDIATE 'SELECT TT_SYSDATE FROM DUAL' INTO v_currtime;
        END;
        SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        IF v_count=0 THEN
            p_err_code := '-90019';
            RETURN;
        ELSE
            SELECT BOD_BALANCE,BOD_DEBT,BOD_ADV,CALC_ADVBAL,BOD_PAYABLE,CALC_ODRAMT,POLICYCD,
                BOD_TD,BOD_DEBT_M,BOD_CRLIMIT,BASKETID,ROOMID
            INTO v_balance,v_debt,v_bod_adv,v_advbal,v_payable,v_odramt,v_policycd,
                v_td,v_debt_m,v_crlimit,v_basketid,v_roomid
            FROM ACCOUNTS WHERE ACCTNO=p_acctno;

            -- tinh so tien rut toi da tren so tien co
            --v_withdraw_cash   := CSPKS_FO_COMMON.fn_get_VNDwithdraw(p_acctno,v_balance,v_advbal+v_bod_adv,v_payable,v_debt,v_debt_m,v_td,v_crlimit,v_roomid);
            --    v_avlbal := CSPKS_FO_COMMON.fn_get_avl_balance(p_acctno,v_balance,v_temp_adv,v_payable,v_debt,v_td,v_crlimit);

                -- giam tien mat, tang tien gui tiet kiem cong vao suc mua
      UPDATE ACCOUNTS SET BOD_TD=BOD_TD+p_amount WHERE ACCTNO = p_acctno;
      -- cap nhat giao dich
      UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:='sp_deposit_saving '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_deposit_saving;

  --rut tiet kiem tx5011
  PROCEDURE sp_withdrawn_saving(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_amount   IN NUMBER,    --so tien rut tiet kiem
            p_doc      IN VARCHAR2,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime        TIMESTAMP;
    v_td                ACCOUNTS.BOD_TD%TYPE;
    v_count           NUMBER;
  BEGIN
    p_err_msg:='sp_withdrawn_saving p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      RETURN;
    ELSE
      IF (p_doc = 'R') THEN
        UPDATE ACCOUNTS SET BOD_TD=BOD_TD+p_amount WHERE ACCTNO = p_acctno;
      ELSE
        SELECT BOD_TD INTO v_td FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        -- kiem tra dieu kien rut tiet kiem
        IF (p_amount <= v_td) THEN
          -- Giam tien tiet kiem voi so tien rut
          UPDATE ACCOUNTS SET BOD_TD=BOD_TD-p_amount WHERE ACCTNO = p_acctno;
          --      CSPKS_FO_TRANS.sp_increase_money(p_err_code,p_acctno,p_refid,v_money);
        ELSE
          --      dbms_output.put_line('so tien khong du thuc hien giao dich');
          UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID= p_refid;
          p_err_code := '-90003';
          RETURN;
        END IF;
      END IF;
      UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025' ;
        p_err_msg:='sp_withdrawn_saving '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_withdrawn_saving;

  --ghi log vao bang transactions
  PROCEDURE sp_process_trans_log(p_txid IN VARCHAR2,
            p_acctno  IN VARCHAR2,
            p_content IN VARCHAR2,
            p_refid OUT NUMBER,
            p_err_code OUT VARCHAR2,
            p_acclass OUT VARCHAR2,
            p_action IN VARCHAR2,
            p_err_msg OUT VARCHAR2)
    AS
        v_sysdate           TIMESTAMP;
        v_count             NUMBER;
        v_account           NUMBER;
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_sysdate;
        END;
        p_err_code := '0';
        p_err_msg:='sp_process_trans_log p_acctno=>'||p_acctno;
        SELECT COUNT(1) INTO v_account FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        IF (p_acctno IS NOT NULL) AND (v_account = 1) THEN
            SELECT ACCLASS INTO p_acclass FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        END IF;
        SELECT SEQ_TRANSACTIONS.NEXTVAL INTO p_refid FROM DUAL;
        SELECT COUNT(1) INTO v_count FROM TRANSACTIONS
        WHERE TXID=p_txid AND ACTION=p_action;

        IF (v_count = 0) THEN
            INSERT INTO TRANSACTIONS(AUTOID,TXID,ACTION,REFID,CONTENT,TIME_CREATED,LASTCHANGE)
            VALUES(p_refid,p_txid,p_action,p_refid,p_content,v_sysdate,v_sysdate);
        ELSE
            -- dbms_output.put_line('Loi trung so chung tu TXNUM');
            p_err_code := '-90029';
            RETURN;
        END IF;
    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_trans_log '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_trans_log;

  PROCEDURE sp_process_money(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan chuyen
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_amount   IN NUMBER,   --so tien chuyen
            p_doc      IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_banklink VARCHAR(2);
  BEGIN
--    DBMS_OUTPUT.ENABLE(1000000);
    p_err_msg:='sp_process_money p_acctno=>'||p_acctno;

    IF (p_doc = 'C') THEN -- Credit (Tang)
      CSPKS_FO_TRANS.sp_increase_money(p_err_code,p_acctno,p_refid,p_amount,p_err_msg);
    ELSIF (p_doc = 'D') THEN -- Debit (Giam)
     /*Thanh NV sua 4.7.2016 Van de giam tien tai khoan Corebank muc dich: de giam HOLD tien*/
     /*
     SELECT BANKLINK INTO v_banklink FROM ACCOUNTS WHERE ACCTNO=p_acctno;
      IF v_banklink = 'B' THEN
        p_err_code := '-92011';
        RETURN;
      END IF;
      */
      CSPKS_FO_TRANS.sp_decrease_money(p_err_code,p_acctno,p_refid,p_amount,p_err_msg);
    END IF;

  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_money '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_money;

  PROCEDURE sp_process_stock(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR2, --so tai khoan chuyen
            p_refid    IN VARCHAR2, -- so hieu xu li cua FO
            p_symbol   IN VARCHAR2, --ma chung khoan
            p_qtty     IN NUMBER,   -- KL chung khoan giao dich
            p_doc      IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_count     number;
    v_currtime  timestamp;
    v_formulacd   ACCOUNTS.FORMULACD%TYPE;
    v_formulacd_rtn     NUMBER(20,2);

  BEGIN
    p_err_code := 0;
    p_err_msg:='sp_process_stock p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    IF (p_doc = 'C') THEN -- Credit (Tang)
      CSPKS_FO_TRANS.sp_increase_stock(p_err_code,p_acctno,p_refid,p_symbol,p_qtty,p_err_msg);
    ELSIF (p_doc = 'D') THEN -- Debit (Giam)
      CSPKS_FO_TRANS.sp_decrease_stock(p_err_code,p_acctno,p_refid,p_symbol,p_qtty,p_err_msg);
    ELSIF (p_doc = 'U') THEN -- Update(cap han muc)
      SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
            IF (v_count = 0) THEN
               BEGIN
                   SELECT formulacd INTO v_formulacd FROM accounts WHERE  ACCTNO = p_acctno;
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
                  EXCEPTION WHEN OTHERS THEN
                   v_formulacd_rtn :=0;
                  END;
              INSERT INTO PORTFOLIOS (ACCTNO,SYMBOL,TRADE,LASTCHANGE,bod_rtn) VALUES (p_acctno,p_symbol,p_qtty,v_currtime,v_formulacd_rtn);

      ELSIF (v_count = 1) THEN
        UPDATE PORTFOLIOS SET TRADE=p_qtty WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
      END IF;
    END IF;

 EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_stock '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_stock;

  --han muc tin dung tx5017
  PROCEDURE sp_process_crlimit(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan
            p_amount   IN NUMBER,  -- Han muc moi
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime          TIMESTAMP;
    v_count             NUMBER;
  BEGIN
    p_err_msg:='sp_process_crlimit p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
        WHERE REFID= p_refid;
      RETURN;
    ELSE
      IF (p_doc = 'C') THEN
        UPDATE ACCOUNTS SET BOD_CRLIMIT=BOD_CRLIMIT+p_amount WHERE ACCTNO=p_acctno;
      ELSIF (p_doc = 'D') THEN
        UPDATE ACCOUNTS SET BOD_CRLIMIT=BOD_CRLIMIT-p_amount WHERE ACCTNO=p_acctno;
      ELSIF (p_doc = 'U') THEN
        UPDATE ACCOUNTS SET BOD_CRLIMIT = p_amount WHERE ACCTNO=p_acctno;
      ELSE
        --dbms_output.put_line('dau vao khong hop le');
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
        WHERE REFID= p_refid;
        RETURN;
      END IF;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
    WHERE REFID = p_refid;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_crlimit '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_crlimit;

  --han muc bao lanh tx5020
  PROCEDURE sp_process_guarantee_limit(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan
            p_amount   IN NUMBER,  -- Han muc moi
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime          TIMESTAMP;
    v_count             NUMBER;
  BEGIN
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    p_err_msg:='sp_process_guarantee_limit p_acctno=>'||p_acctno;

    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
        WHERE REFID= p_refid;
      RETURN;
    ELSE
      IF (p_doc = 'C') THEN
        UPDATE ACCOUNTS SET BOD_T0VALUE = BOD_T0VALUE + p_amount WHERE ACCTNO = p_acctno;
      ELSIF (p_doc = 'D') THEN
        UPDATE ACCOUNTS SET BOD_T0VALUE = BOD_T0VALUE - p_amount WHERE ACCTNO = p_acctno;
      ELSIF (p_doc = 'U') THEN
        UPDATE ACCOUNTS SET BOD_T0VALUE = p_amount WHERE ACCTNO = p_acctno;
      ELSE
        --dbms_output.put_line('dau vao khong hop le');
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
        RETURN;
      END IF;
    END IF;
    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_guarantee_limit '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_guarantee_limit;

  --giao dich tra no tx5018
  PROCEDURE sp_process_debt(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- no bao lanh
            p_type   IN VARCHAR, -- loai no bao lanh hay margin
            p_doc   IN VARCHAR, --C tang, D giam
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime          TIMESTAMP;
    v_count             NUMBER;
    v_cash        NUMBER;
    v_buyamt      NUMBER;
    v_ta_margin   NUMBER;
    v_roomid      VARCHAR(20);
    v_rate_ub     NUMBER;
    v_balance     NUMBER;
    v_advbal      NUMBER;
    v_bodadv      NUMBER;
    v_crlimit     NUMBER;
    v_debt        NUMBER;
    v_debt_t0     NUMBER;

  BEGIN
    p_err_msg:='sp_process_debt p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count    = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
        WHERE REFID= p_refid;
      RETURN;
    ELSE
      /*dung.bui them code check tien tra no, date 30/11/2015*/
      --lay thong tin bang accounts
      SELECT BOD_BALANCE,CALC_ADVBAL,BOD_ADV,BOD_CRLIMIT,BOD_DEBT,BOD_DEBT_T0,ROOMID,RATE_UB
      INTO v_balance,v_advbal,v_bodadv,v_crlimit,v_debt,v_debt_t0,v_roomid,v_rate_ub
      FROM ACCOUNTS WHERE ACCTNO = p_acctno;
      --tinh ki quy mua
      v_buyamt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TRA_NO',p_acctno,null,'v_buyamt',v_buyamt);
      --tinh gia tri tai san (ta)
      v_ta_margin := CSPKS_FO_COMMON.fn_get_ta(p_acctno,v_roomid,v_rate_ub);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TRA_NO',p_acctno,null,'v_ta_margin',v_ta_margin);

      IF (p_doc = 'D') THEN  -- giam no,giam tien
         --tinh so tien dung de tra no
        v_cash := least(v_balance+v_advbal+v_bodadv+greatest(least(v_ta_margin,v_crlimit-v_debt),0)
          ,v_balance+v_advbal+v_bodadv);

        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'TRA_NO',p_acctno,null,'v_cash',v_cash);
        IF p_amount <= v_cash THEN --check dk rut tien tra no
          IF (p_type = 'T0') THEN --no bao lanh trong han
            --v_cash := least(v_balance+v_advbal+greatest(least(v_ta_margin,v_crlimit-v_debt),0)-v_buyamt,v_balance+v_advbal);
            UPDATE ACCOUNTS SET BOD_DEBT_T0 = BOD_DEBT_T0-p_amount,
                                BOD_SCASHTN = BOD_SCASHTN -p_amount,
                                BOD_DEBT = BOD_DEBT-p_amount,
                                BOD_BALANCE = BOD_BALANCE-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'M0') THEN --no margin trong han
            --v_cash := least(v_balance+v_advbal+greatest(least(v_ta_margin,v_crlimit-v_debt),0)-least(v_buyamt,v_debt_t0),v_balance+v_advbal);
            UPDATE ACCOUNTS SET BOD_D_MARGIN = BOD_D_MARGIN-p_amount,
                               BOD_DEBT = BOD_DEBT-p_amount,
                               BOD_BALANCE = BOD_BALANCE-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'U0') THEN --no margin uy ban trong han
            --v_cash := least(v_balance+v_advbal+greatest(least(v_ta_margin,v_crlimit-v_debt),0)-least(v_buyamt,v_debt_t0),v_balance+v_advbal);
            UPDATE ACCOUNTS SET BOD_D_MARGIN=BOD_D_MARGIN-p_amount,
                               BOD_DEBT=BOD_DEBT-p_amount,
                               BOD_D_MARGIN_UB=BOD_D_MARGIN_UB-p_amount,
                               BOD_BALANCE = BOD_BALANCE-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'T1') THEN --no bao lanh qua han
            UPDATE ACCOUNTS SET BOD_DEBT_T0 = BOD_DEBT_T0-p_amount,
                                BOD_DEBT_M = BOD_DEBT_M -p_amount,
                                BOD_DEBT = BOD_DEBT-p_amount,
                                BOD_BALANCE = BOD_BALANCE-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'M1') THEN --no margin qua han
            UPDATE ACCOUNTS SET BOD_D_MARGIN = BOD_D_MARGIN-p_amount,
                               BOD_DEBT = BOD_DEBT-p_amount,
                               BOD_DEBT_M = BOD_DEBT_M -p_amount,
                               BOD_BALANCE = BOD_BALANCE-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'U1') THEN --no margin uy ban
            UPDATE ACCOUNTS SET BOD_D_MARGIN=BOD_D_MARGIN-p_amount,
                               BOD_DEBT=BOD_DEBT-p_amount,
                               BOD_D_MARGIN_UB=BOD_D_MARGIN_UB-p_amount,
                               BOD_DEBT_M = BOD_DEBT_M -p_amount,
                               BOD_BALANCE = BOD_BALANCE-p_amount
            WHERE ACCTNO = p_acctno;

          END IF;
          /*
          --tiendt: update no qua han
          --date: 2015-11-15
          UPDATE ACCOUNTS SET BOD_DEBT_M = GREATEST(BOD_DEBT_M - p_amount, 0) WHERE ACCTNO = p_acctno;
          --end
          */
        ELSE
          p_err_code := '-90003';
          UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
          RETURN;
        END IF;


      ELSIF (p_doc = 'C') THEN
        IF (p_type = 'T0') THEN --no bao lanh trong han
          UPDATE ACCOUNTS SET BOD_DEBT_T0 = BOD_DEBT_T0 + p_amount,
                              BOD_DEBT = BOD_DEBT + p_amount,
                              BOD_BALANCE = BOD_BALANCE+p_amount
          WHERE ACCTNO = p_acctno;
        ELSIF (p_type = 'M0') THEN --no margin trong han
           UPDATE ACCOUNTS SET BOD_D_MARGIN = BOD_D_MARGIN + p_amount,
                               BOD_DEBT = BOD_DEBT + p_amount,
                               BOD_BALANCE = BOD_BALANCE+p_amount
            WHERE ACCTNO = p_acctno;
        ELSIF (p_type = 'U0') THEN --no margin uy ban trong han
           UPDATE ACCOUNTS SET BOD_D_MARGIN=BOD_D_MARGIN+p_amount,
                               BOD_DEBT=BOD_DEBT+p_amount,
                               BOD_D_MARGIN_UB=BOD_D_MARGIN_UB+p_amount,
                               BOD_BALANCE = BOD_BALANCE+p_amount
            WHERE ACCTNO = p_acctno;

        END IF;

      ELSE
        --dbms_output.put_line('dau vao khong hop le');
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
        RETURN;
      END IF;
    END IF;
    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_debt '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_debt;

  --phi luu ky tx5019
  PROCEDURE sp_process_fee(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan
            p_fee      IN NUMBER,  -- phi luu ky
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_payable             ACCOUNTS.BOD_PAYABLE%TYPE;
    v_currtime          TIMESTAMP;
    v_count             NUMBER;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_process_fee p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
      RETURN;
    ELSE
      SELECT BOD_PAYABLE INTO v_payable FROM ACCOUNTS WHERE ACCTNO = p_acctno;
      IF (p_doc = 'C') THEN --tang phi luu ky
        UPDATE ACCOUNTS SET BOD_PAYABLE = BOD_PAYABLE + p_fee WHERE ACCTNO = p_acctno;
      ELSIF (p_doc = 'D') THEN
        IF (p_fee <= v_payable) THEN
          UPDATE ACCOUNTS SET BOD_PAYABLE = BOD_PAYABLE - p_fee WHERE ACCTNO = p_acctno;
        ELSE
          --dbms_output.put_line('dau vao khong hop le');
          UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
          RETURN;
        END IF;
      ELSE
        --dbms_output.put_line('dau vao khong hop le');
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
        RETURN;
      END IF;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_fee '||p_err_msg||' sqlerrm = '||SQLERRM;
    --      dbms_output.put_line('so tien khong du thuc hien giao dich');
  END sp_process_fee;

  --mo moi,cap nhat tai khoan tx5101
  PROCEDURE sp_open_account(p_err_code   IN OUT VARCHAR,
            p_acctno     IN VARCHAR, --so tai khoan
            p_actype     IN VARCHAR,
            p_grname     IN VARCHAR,
            p_policycd   IN VARCHAR,
            p_acclass    IN VARCHAR,
            p_custodycd  IN VARCHAR,
            p_formulacd  IN VARCHAR,
            p_basketid   IN VARCHAR,
            p_trfbuyamt  IN NUMBER,
            p_trfbuyext  IN NUMBER,
            p_banklink   IN VARCHAR,
            p_bankacctno IN VARCHAR,
            p_bankcode   IN VARCHAR,
            p_rate_brk_s IN NUMBER,
            p_rate_brk_b IN NUMBER,
            p_rate_tax   IN NUMBER,
            p_rate_adv   IN NUMBER,
            p_ratio_init IN NUMBER,
            p_ratio_main IN NUMBER,
            p_ratio_exec IN NUMBER,
            p_custid     IN VARCHAR,
            p_dof        IN VARCHAR,
            p_status     IN VARCHAR,
            p_poolid     IN VARCHAR,
            p_roomid     IN VARCHAR,
            p_rate_ub    IN NUMBER,
            p_basketid_ub IN VARCHAR,
            p_bod_d_margin_ub IN NUMBER,
            p_bod_t0value IN NUMBER,     --1.5.7.3 MSBS-1936
            p_err_msg OUT VARCHAR2

    )
    AS
        v_currtime          TIMESTAMP;
        v_count             NUMBER;
        v_count2            NUMBER;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_open_account p_acctno=>'||p_acctno;
        SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        IF v_count >0 THEN
            -- p_err_code := '-92012';
            UPDATE ACCOUNTS SET ACTYPE=p_actype,GRNAME=p_grname,POLICYCD=p_policycd,ACCLASS=p_acclass,POOLID=p_poolid,ROOMID=p_roomid,RATE_UB=p_rate_ub,
                CUSTODYCD=p_custodycd,FORMULACD=p_formulacd,BASKETID=p_basketid,BANKLINK=p_banklink,BANKACCTNO=p_bankacctno,BANKCODE=p_bankcode,
        BASKETID_UB=p_basketid_ub,BOD_D_MARGIN_UB=p_bod_d_margin_ub, bod_t0value = p_bod_t0value    --1.5.7.3 MSBS-1936
            WHERE ACCTNO = p_acctno;
            RETURN;
        END IF;

        INSERT INTO ACCOUNTS(ACCTNO,ACTYPE,GRNAME,POLICYCD,ACCLASS,STATUS,POOLID,ROOMID,
      CUSTODYCD,FORMULACD,BASKETID,TRFBUYAMT,TRFBUYEXT,BANKLINK,BANKACCTNO,BANKCODE,RATE_UB,BASKETID_UB,BOD_D_MARGIN_UB,
      RATE_BRK_S,RATE_BRK_B,RATE_TAX,RATE_ADV,RATIO_INIT,RATIO_MAIN,RATIO_EXEC,LASTCHANGE)
    VALUES(p_acctno,p_actype,p_grname,p_policycd,p_acclass,p_status,p_poolid,p_roomid,
      p_custodycd,p_formulacd,p_basketid,p_trfbuyamt,p_trfbuyext,p_banklink,p_bankacctno,p_bankcode,p_rate_ub,p_basketid_ub,p_bod_d_margin_ub,
      p_rate_brk_s,p_rate_brk_b,p_rate_tax,p_rate_adv,p_ratio_init,p_ratio_main,p_ratio_exec,sysdate);

        SELECT COUNT(1) INTO v_count2 FROM CUSTOMERS WHERE CUSTID = p_custid;
        IF v_count2 <1 THEN
          INSERT INTO CUSTOMERS(CUSTID,CUSTODYCD,DOF) VALUES(p_custid,p_custodycd,p_dof);
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:='sp_open_account '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_open_account;

  --su kien quyen tien theo lo tx5102
  PROCEDURE sp_process_update_money(p_err_code IN OUT VARCHAR,
            p_acctno  IN VARCHAR, --so tai khoan
            p_amt IN NUMBER,  -- so tien
            p_doc IN VARCHAR,
            p_err_msg OUT VARCHAR2
      )
    AS
        v_currtime          TIMESTAMP;
        v_count             NUMBER;
    BEGIN
        p_err_msg:='sp_process_update_money p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
        END;
        p_err_code := '0';
        IF (p_doc = 'C') THEN
            UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE+p_amt,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno;
        ELSIF (p_doc = 'D') THEN
            UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE-p_amt,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno;
        END IF;

        EXCEPTION
            WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:='sp_process_update_money '||p_err_msg||' sqlerrm = '||SQLERRM;
    --      dbms_output.put_line('so tien khong du thuc hien giao dich');
    END sp_process_update_money;

  --su kien quyen chung khoan theo lo tx5102
  PROCEDURE sp_process_update_stock(
            p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan
            p_symbol   IN VARCHAR, --ma chung khoan
            p_qtty     IN NUMBER,  -- khoi luong chung khoan
            p_doc      IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
    AS
        v_currtime        TIMESTAMP;
        v_count           NUMBER;
    BEGIN
        p_err_msg:='sp_process_update_stock p_acctno=>'||p_acctno;
        BEGIN
          EXECUTE IMMEDIATE 'select tt_sysdate from dual' INTO v_currtime;
        END;
        p_err_code := '0';
        SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
        IF v_count > 0 THEN
            IF (p_doc = 'C') THEN
                UPDATE PORTFOLIOS SET TRADE=TRADE+p_qtty,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
            ELSIF (p_doc = 'D') THEN
                UPDATE PORTFOLIOS SET TRADE=TRADE-p_qtty,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
            END IF;
        ELSE
            INSERT INTO PORTFOLIOS(ACCTNO,SYMBOL,TRADE,LASTCHANGE) VALUES(p_acctno,p_symbol,p_qtty,v_currtime);
        END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_err_code := '-90025';
                p_err_msg:='sp_process_update_stock '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_update_stock;

-- xu li tra no cat tien mat tx5021
  PROCEDURE sp_process_balance(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- so tien
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime        TIMESTAMP;
    v_count           NUMBER;
    v_bod_balance     ACCOUNTS.BOD_BALANCE%TYPE;
  BEGIN
    p_err_msg:='sp_process_balance p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      RETURN;
    ELSE
      IF (p_doc = 'C') THEN
        UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE + p_amount WHERE ACCTNO = p_acctno;
      ELSIF (p_doc = 'D') THEN
        SELECT BOD_BALANCE INTO v_bod_balance FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        IF p_amount <= v_bod_balance THEN
          UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE - p_amount WHERE ACCTNO = p_acctno;
        ELSE
          p_err_code := '-90003';
          RETURN;
        END IF;
      ELSE
        --dbms_output.put_line('dau vao khong hop le');
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        RETURN;
      END IF;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_balance '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_balance;

  --rut tien tren suc mua thang du tx5107
  PROCEDURE sp_process_money_buyingpower(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- so tien rut
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_withdraw_cash     NUMBER;
    v_odramt            NUMBER;
    v_count             NUMBER;
    v_using_pool        NUMBER;
    v_currtime          TIMESTAMP;
    v_balance           ACCOUNTS.BOD_BALANCE%TYPE;
    v_debt              ACCOUNTS.BOD_DEBT%TYPE;
    v_debt_m            ACCOUNTS.BOD_DEBT_M%TYPE;
    v_advbal            ACCOUNTS.CALC_ADVBAL%TYPE;
    v_payable           ACCOUNTS.BOD_PAYABLE%TYPE;
    v_td                ACCOUNTS.BOD_TD%TYPE;
    v_crlimit             ACCOUNTS.BOD_CRLIMIT%TYPE;
    v_policycd          ACCOUNTS.POLICYCD%TYPE;
    v_basketid          ACCOUNTS.BASKETID%TYPE;
    v_bod_adv           ACCOUNTS.BOD_ADV%TYPE;
    v_poolid            ACCOUNTS.POOLID%TYPE;
    v_roomid            ACCOUNTS.ROOMID%TYPE;
    v_t0value           ACCOUNTS.BOD_T0VALUE%TYPE;
    v_bod_debt_t0       ACCOUNTS.BOD_DEBT_T0%TYPE;
    v_bod_d_margin      ACCOUNTS.BOD_D_MARGIN%TYPE;
    v_rate_ub           ACCOUNTS.RATE_UB%TYPE;
    v_bod_d_margin_ub   ACCOUNTS.BOD_D_MARGIN_UB%TYPE;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_process_money_buyingpower p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
      RETURN;
    ELSE
      SELECT BOD_BALANCE,BOD_DEBT,BOD_DEBT_M,BOD_ADV,CALC_ADVBAL,BOD_PAYABLE,CALC_ODRAMT,POLICYCD,
          BOD_TD,BOD_CRLIMIT,BASKETID,POOLID,ROOMID,BOD_T0VALUE,BOD_DEBT_T0,BOD_D_MARGIN,RATE_UB,BOD_D_MARGIN_UB
      INTO v_balance,v_debt,v_debt_m,v_bod_adv,v_advbal,v_payable,v_odramt,v_policycd,
          v_td,v_crlimit,v_basketid,v_poolid,v_roomid,v_t0value,v_bod_debt_t0,v_bod_d_margin,v_rate_ub,v_bod_d_margin_ub
      FROM ACCOUNTS WHERE ACCTNO = p_acctno;
      IF (p_doc = 'D') THEN
        /*tiendt added for buy amount, date: 2015-08-24*/
        v_odramt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
        /*end*/
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_odramt',v_odramt);

        -- tinh so tien rut tren suc mua thang du
        --v_withdraw_cash := CSPKS_FO_COMMON.fn_get_avl_balance(p_acctno,v_balance,v_bod_adv+v_advbal,v_payable,v_debt,v_td,v_crlimit,v_roomid,v_rate_ub);
        /*cong thuc rut tien tren suc mua MSBS*/
        v_withdraw_cash := CSPKS_FO_COMMON.fn_get_avl_balance2(p_acctno);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_withdraw_cash',v_withdraw_cash);
        --Kiem tra dieu kien rut tien
        IF (p_amount <= v_withdraw_cash) AND v_policycd IS NULL THEN
          -- thuc hien rut tien va ko can check pool/room
          UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE-p_amount WHERE ACCTNO=p_acctno;
        ELSIF (p_amount <= v_withdraw_cash) AND v_policycd IS NOT NULL THEN
          --Kiem tra trang thai no cua tai khoan
          v_using_pool := CSPKS_FO_POOLROOM.fn_get_using_pool(p_err_code, p_amount,v_balance,v_bod_adv+v_advbal,v_payable,v_debt,v_odramt,v_td,v_t0value,p_err_msg);
          --dbms_output.put_line('so tien giao dich dung pool  : ' || v_using_pool);
          IF v_using_pool > 0 THEN
            --Kiem tra pool voi so pool dung them
            CSPKS_FO_POOLROOM.sp_process_checkpool(p_err_code,v_poolid,v_using_pool,p_err_msg);
            --dbms_output.put_line('p_err_code  : ' || p_err_code);
            IF p_err_code != '0' THEN -- khong du pool
              UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
              -- p_err_code := '-90014';
              RETURN;
            ELSE
              CSPKS_FO_POOLROOM.sp_process_checkroom_v4(p_err_code,p_acctno,v_roomid,p_amount,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0, v_balance,v_bod_adv,v_advbal,v_td,0,NULL,0,v_t0value,p_err_msg);

            END IF;
            IF p_err_code = '0' THEN
              UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE-p_amount WHERE ACCTNO=p_acctno;
              --Danh dau pool/room
              CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code,NULL,NULL,NULL,p_acctno,v_poolid,v_using_pool,0,0,p_err_msg);
              /*
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_roomid',v_roomid);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_payable',v_payable);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_odramt',v_odramt);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'0','0');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_balance',v_balance-p_amount);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_bod_adv',v_bod_adv);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_advbal',v_advbal);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_td',v_td);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_t0value',v_t0value);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_side','NULL');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'v_symbol','NULL');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GT_buyingpower',p_acctno,null,'f_qtty',0);
              */
              CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
              v_bod_d_margin_ub,v_odramt,0,v_balance-p_amount,v_bod_adv,v_advbal,v_td,v_t0value,NULL,NULL,NULL,0,p_err_msg);
            ELSE -- khong du room
              --cap nhat thong tin giao dich vao bang transaction
              UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
              -- p_err_code := '-90015';
              RETURN ;
            END IF;
          ELSE --v_using_pool = 0
            -- khong check pool/room, thuc hien update tien tk
            UPDATE ACCOUNTS SET BOD_BALANCE=BOD_BALANCE - p_amount WHERE ACCTNO = p_acctno;
          END IF;
        ELSE --khong du tien
          p_err_code := '-90003';
          UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
          RETURN;
        END IF;
        --cap nhat thong tin giao dich thanh cong vao bang transaction
        UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

      ELSIF (p_doc = 'C') THEN
          CSPKS_FO_TRANS.sp_increase_money(p_err_code,p_acctno,p_refid,p_amount,p_err_msg);
      END IF;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_money_buyingpower '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_money_buyingpower;

  --thay doi thong tin loai hinh tai khoan tx5105
  PROCEDURE sp_process_5105(p_err_code IN OUT VARCHAR,
              p_acctno      IN VARCHAR,
              p_actype      IN VARCHAR,
              p_policycd    IN VARCHAR,
              p_poolid      IN VARCHAR,
              p_roomid      IN VARCHAR,
              p_formulacd   IN VARCHAR,
              p_basketid    IN VARCHAR,
              p_rate_brk_s  IN NUMBER,
              p_rate_brk_b  IN NUMBER,
              p_rate_tax    IN NUMBER,
              p_rate_adv    IN NUMBER,
              p_bod_adv     IN NUMBER,
              p_calc_advbal IN NUMBER,
              p_basketid_ub IN VARCHAR,
              p_bod_d_margin_ub IN NUMBER,
             p_err_msg OUT VARCHAR2
  )
  AS
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_process_5105 p_acctno=>'||p_acctno;
    UPDATE ACCOUNTS SET ACTYPE = p_actype, POLICYCD = p_policycd, POOLID = p_poolid,
                        ROOMID = p_roomid, FORMULACD = p_formulacd, BASKETID = p_basketid,
                        RATE_BRK_S = p_rate_brk_s, RATE_BRK_B  = p_rate_brk_b, RATE_TAX = p_rate_tax,
                        RATE_ADV = p_rate_adv, BOD_ADV = p_bod_adv, CALC_ADVBAL = p_calc_advbal,
                        BASKETID_UB = p_basketid_ub, BOD_D_MARGIN_UB = p_bod_d_margin_ub
    WHERE ACCTNO  = p_acctno;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_5105 '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_5105;

  --thay doi phi gd theo lo tx5109
  PROCEDURE sp_process_5109(p_err_code IN OUT VARCHAR,
              p_acctno     IN VARCHAR, --so tai khoan
              p_rate_brk_s IN NUMBER,
              p_rate_brk_b IN NUMBER,
              p_actiontype IN VARCHAR,
              p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime TIMESTAMP;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_process_5109 p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE IMMEDIATE 'select tt_sysdate from dual' INTO v_currtime;
    END;

    IF (p_actiontype = 'U') THEN
      UPDATE ACCOUNTS SET rate_brk_s = p_rate_brk_s,rate_brk_b = p_rate_brk_b
      WHERE ACCTNO = p_acctno;
    END IF;
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_5109 '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_5109;

  --thay doi ro CK theo lo tx3016
  PROCEDURE sp_process_3016(p_err_code IN OUT VARCHAR,
              p_basketid     IN VARCHAR,
              p_symbol       IN VARCHAR,
              p_price_margin IN NUMBER,
              p_price_asset  IN NUMBER,
              p_rate_buy     IN NUMBER,
              p_rate_margin  IN NUMBER,
              p_rate_asset   IN NUMBER,
              p_actiontype   IN VARCHAR,
              p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime TIMESTAMP;
    v_count number := 0;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_process_3016 p_basketid=>'||p_basketid;
    BEGIN
      EXECUTE IMMEDIATE 'select tt_sysdate from dual' INTO v_currtime;
    END;

    IF (p_actiontype = 'I') THEN
      select count(1) into v_count
      from baskets
      where basketid = p_basketid and symbol = p_symbol;
      if v_count = 0 then
      INSERT INTO BASKETS(BASKETID,SYMBOL,PRICE_MARGIN,PRICE_ASSET,RATE_BUY,RATE_MARGIN,RATE_ASSET)
      VALUES(p_basketid,p_symbol,p_price_margin,p_price_asset,p_rate_buy,p_rate_margin,p_rate_asset);
      else
      p_err_code := '-90025';
      return;
      end if;
    ELSIF (p_actiontype = 'U') THEN
        UPDATE BASKETS SET PRICE_MARGIN = p_price_margin, PRICE_ASSET = p_price_asset,
                  RATE_BUY = p_rate_buy, RATE_MARGIN = p_rate_margin, RATE_ASSET = p_rate_asset
        WHERE BASKETID = p_basketid and SYMBOL = p_symbol;
    ELSIF (p_actiontype = 'D') THEN
          DELETE FROM BASKETS WHERE BASKETID = p_basketid and symbol = p_symbol;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_3016 '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_3016;

  PROCEDURE sp_process_update_poolroom(p_err_code IN OUT VARCHAR,
              p_refid IN VARCHAR,
              p_autoid IN NUMBER,
              p_policycd IN VARCHAR,
              p_policytype IN VARCHAR,
              p_refsymbol IN VARCHAR,
              p_granted IN NUMBER,
              p_inused IN NUMBER,
              p_actiontype IN VARCHAR,
              p_err_msg OUT VARCHAR2
  )
  AS
     v_currtime TIMESTAMP;
     v_autoid NUMBER;
     v_count_poolroom NUMBER := 0;
  BEGIN
     p_err_msg:='sp_process_update_poolroom p_autoid=>'||p_autoid;
     BEGIN
        EXECUTE IMMEDIATE 'select tt_sysdate from dual' INTO v_currtime;
     END;
     p_err_code := '0';
     IF (p_actiontype = 'I') THEN -- them moi pool
        -- kiem tra da ton tai pool chua
        SELECT count(1) into v_count_poolroom FROM poolroom
        WHERE policycd = p_policycd AND policytype = p_policytype AND refsymbol = p_refsymbol;
        IF v_count_poolroom = 0 THEN -- chua ton tai thi them moi
           SELECT SEQ_POOLROOM.NEXTVAL INTO v_autoid FROM DUAL;
           INSERT INTO POOLROOM(AUTOID,POLICYCD,POLICYTYPE,REFSYMBOL,GRANTED,INUSED)
           VALUES(v_autoid,p_policycd,p_policytype,p_refsymbol,p_granted,p_inused);
        ELSE -- ton tai roi thi bao loi
           p_err_code := '-90025';
           return;
        END IF;
     ELSIF (p_actiontype = 'U') THEN -- sua pool
        UPDATE POOLROOM SET GRANTED = p_granted
        WHERE POLICYCD =  p_policycd AND  POLICYTYPE = p_policytype AND REFSYMBOL = p_refsymbol;
     ELSIF (p_actiontype = 'D') THEN -- xoa pool
        DELETE FROM POOLROOM WHERE POLICYCD =  p_policycd AND  POLICYTYPE = p_policytype AND REFSYMBOL = p_refsymbol;
     END IF;
  --    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
  EXCEPTION
     WHEN OTHERS THEN
        p_err_code := '-90025';
  --    UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        p_err_msg:='sp_process_update_poolroom '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_update_poolroom;

  PROCEDURE sp_process_update_ownpoolroom(p_err_code IN OUT VARCHAR,
            p_refid IN VARCHAR,
            p_prid IN varchar,
            p_acctno IN VARCHAR,
            p_policytype IN VARCHAR,
            p_refsymbol IN VARCHAR,
            p_inused IN NUMBER,
            p_actiontype IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime TIMESTAMP;
    v_tradable_qtty number := 0;
    v_daily_room number := 0;
    v_remain_room number := 0;
    v_qtty number := 0;
    v_count_ownroom number := 0;
    v_mark number := 0;
    v_markcom number := 0;
    v_roomid VARCHAR(20);
    v_balance  number := 0;
    v_bod_debt_t0  number := 0;
    v_bod_d_margin  number := 0;
    v_bod_d_margin_ub number :=0;
    v_t0value  number := 0;
    v_td  number := 0;
    v_payable  number := 0;
    v_bod_adv  number := 0;
    v_advbal  number := 0;
    v_ordamt  number := 0;
    v_poolid VARCHAR(20);
    v_estimated_debt number;
    v_inused number := 0;

    v_markEX    NUMBER;
    v_markcomEX NUMBER;
    v_tradable_qttyEx NUMBER := 0;
    v_daily_own_qtty  NUMBER := 0;


  BEGIN
    BEGIN
      EXECUTE IMMEDIATE 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    p_err_msg:='sp_process_update_ownpoolroom p_acctno=>'||p_acctno;
    IF p_policytype = 'P' THEN --doi voi pool

      IF (p_actiontype = 'I') THEN -- INSERT
        SELECT count(1) INTO v_count_ownroom FROM OWNPOOLROOM WHERE prid = p_prid AND ACCTNO = p_acctno AND REFSYMBOL = p_refsymbol;
        v_estimated_debt := CSPKS_FO_COMMON.fn_get_estimated_debt(p_acctno);
        IF (v_count_ownroom = 0) THEN
          SELECT POOLID INTO v_poolid FROM ACCOUNTS WHERE ACCTNO = p_acctno;
          IF (v_estimated_debt > 0) THEN
            IF v_poolid = 'UB' THEN
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code ,null,null,p_refsymbol,p_acctno , 'SYSTEM' , v_estimated_debt, 0,0,p_err_msg);
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code ,null,null,p_refsymbol,p_acctno , 'UB' , v_estimated_debt, 0,0,p_err_msg);
            ELSE
              CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code ,null,null,p_refsymbol,p_acctno , 'SYSTEM' , v_estimated_debt, 0,0,p_err_msg);
            END IF;
            CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code , null, null, p_refsymbol, p_acctno, p_prid, v_estimated_debt, 0, 0,p_err_msg);
          END IF;
          UPDATE ACCOUNTS SET POOLID = p_prid  WHERE ACCTNO = p_acctno;
          INSERT INTO OWNPOOLROOM(PRID,ACCTNO,POLICYTYPE,REFSYMBOL,INUSED) VALUES(p_prid,p_acctno,p_policytype,p_refsymbol,p_inused);
        END IF;

      ELSIF (p_actiontype = 'D') THEN -- DELETE
        SELECT count(1) INTO v_count_ownroom FROM OWNPOOLROOM WHERE prid = p_prid AND ACCTNO = p_acctno AND REFSYMBOL = p_refsymbol;
        SELECT ROOMID INTO v_roomid FROM ACCOUNTS WHERE ACCTNO = p_acctno;
        v_estimated_debt := CSPKS_FO_COMMON.fn_get_estimated_debt(p_acctno);
        IF (v_count_ownroom = 1) THEN
          UPDATE ACCOUNTS SET POOLID = v_roomid WHERE ACCTNO = p_acctno;
          IF (v_estimated_debt > 0) THEN
            CSPKS_FO_POOLROOM.sp_process_releasepool(p_err_code ,null,null,p_refsymbol,p_acctno ,   p_prid , v_estimated_debt, 0,0,p_err_msg);
            IF (v_roomid = 'UB') THEN
              CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code , null, null, p_refsymbol, p_acctno, 'UB', v_estimated_debt, 0, 0,p_err_msg);
              CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code , null, null, p_refsymbol, p_acctno, 'SYS', v_estimated_debt, 0, 0,p_err_msg);
            ELSIF (v_roomid = 'SYS') THEN
              CSPKS_FO_POOLROOM.sp_process_markpool(p_err_code , null, null, p_refsymbol, p_acctno, 'SYS', v_estimated_debt, 0, 0,p_err_msg);
            END IF;
          END IF;
          DELETE FROM OWNPOOLROOM WHERE prid = p_prid AND ACCTNO = p_acctno AND REFSYMBOL = p_refsymbol;
        END IF;
      END IF;

    ELSE --doi voi room

      IF (p_actiontype = 'I') THEN -- INSERT
        SELECT count(1) INTO v_count_ownroom FROM OWNPOOLROOM
        WHERE prid = p_prid AND ACCTNO = p_acctno and REFSYMBOL = p_refsymbol;

        IF (v_count_ownroom = 0) THEN
          INSERT INTO OWNPOOLROOM(PRID,ACCTNO,POLICYTYPE,REFSYMBOL,INUSED)
          VALUES(p_prid,p_acctno,p_policytype,p_refsymbol,p_inused);

          -- nha danh dau room thuong
          BEGIN
            SELECT MARKED, MARKEDCOM INTO v_mark,v_markcom  FROM PORTFOLIOS WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol;
          EXCEPTION WHEN OTHERS THEN
            v_mark :=0;
            v_markcom :=0;
          END;
          --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.

          BEGIN
             SELECT MARKED, MARKEDCOM INTO v_markEX,v_markcomEX  FROM PORTFOLIOSEX WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol;
          EXCEPTION WHEN OTHERS THEN
             v_markEX :=0;
             v_markcomEX:=0;
          END;
          v_mark:= v_mark + v_markEX;
          v_markcom:=v_markcom + v_markcomEX;

          SELECT ROOMID INTO v_roomid FROM ACCOUNTS WHERE ACCTNO = p_acctno;
          --IF (v_roomid = 'UB') THEN
            --nha danh dau cua tieu khoan
            UPDATE PORTFOLIOS SET MARKED = 0 , MARKEDCOM = 0 WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol;
            --ThanhNV sua 14.04.2016 iss MHFTEX-210
            UPDATE PORTFOLIOSEX SET MARKED = 0 , MARKEDCOM = 0 WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol;

            --nha danh dau cua room UB
            IF (v_markcom > 0) THEN
               CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code,p_acctno,'UB',p_refsymbol,v_markcom,null,null,p_err_msg);

            END IF;
            --nha danh dau cua room he thong
            IF (v_mark > 0) THEN
               CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code,p_acctno,'SYSTEM',p_refsymbol,v_mark,null,null,p_err_msg);

            END IF;
--          ELSE --system
--              UPDATE PORTFOLIOS SET MARKED = 0 WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol;
--              IF (v_mark > 0) THEN
--                 CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code,p_acctno,'SYSTEM',p_refsymbol,v_mark,null,null);
--              END IF;
--          END IF;

          --tong khoi luong cua ma ck trong tieu khoan
          BEGIN
            SELECT TRADE + RECEIVING + BUYINGQTTY - BOD_ST3 INTO v_tradable_qtty
            FROM PORTFOLIOS
            WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol ;
          EXCEPTION WHEN OTHERS THEN
             v_tradable_qtty:=0;
          END;

          --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
          BEGIN
                  SELECT BUYINGQTTY - BOD_ST3 INTO v_tradable_qttyEx
                  FROM PORTFOLIOSEX
                  WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol ;
          EXCEPTION WHEN OTHERS THEN
             v_tradable_qttyEx:=0;
          END;
          v_tradable_qtty:=v_tradable_qtty + v_tradable_qttyEx;

          CSPKS_FO_POOLROOM.sp_process_markownroom(p_err_code,p_acctno,p_prid,p_refsymbol,v_tradable_qtty,null,null,p_err_msg);

          --tinh lai no, nha danh dau neu gia tri danh dau > gia tri no
          SELECT BOD_BALANCE,BOD_DEBT_T0,BOD_D_MARGIN,BOD_T0VALUE,BOD_TD,
             BOD_PAYABLE,ROOMID,BOD_ADV,CALC_ADVBAL,CALC_ODRAMT,BOD_D_MARGIN_UB
          INTO v_balance,v_bod_debt_t0,v_bod_d_margin,v_t0value,v_td,
             v_payable,v_roomid,v_bod_adv,v_advbal,v_ordamt,v_bod_d_margin_ub
          FROM ACCOUNTS WHERE ACCTNO=p_acctno;

          /*DUNG.BUI THEM CODE LAY KI QUY MUA, 08/04/2016*/
          v_ordamt := cspks_fo_common.fn_get_buy_amt_edit_order(p_acctno);
          /*END*/

          CSPKS_FO_POOLROOM.sp_process_releaseroom_v4(p_err_code, p_acctno, v_roomid, v_payable, v_bod_debt_t0,
              v_bod_d_margin,v_bod_d_margin_ub ,v_ordamt, 0, v_balance, v_bod_adv, v_advbal, v_td, v_t0value, null, null, p_refsymbol, 0,p_err_msg);
        ELSE
          p_err_code := '-90025';
          return;
        END IF;

      ELSIF (p_actiontype = 'U') THEN --tai khoan da ton tai, BO update han muc
        UPDATE OWNPOOLROOM SET INUSED = p_inused
        WHERE PRID = p_prid
          AND ACCTNO = p_acctno
          AND REFSYMBOL = p_refsymbol
          AND POLICYTYPE = p_policytype;

      ELSIF (p_actiontype = 'D') THEN --Xoa tai khoan khoi room dac biet, TODO
        -- nha danh dau cua room dac biet
        BEGIN
          SELECT TRADE + RECEIVING + BUYINGQTTY - BOD_ST3 INTO v_tradable_qtty
          FROM PORTFOLIOS
          WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol ;
        EXCEPTION
          WHEN OTHERS THEN
            v_tradable_qtty := 0;
        END;

        BEGIN
             SELECT BUYINGQTTY - BOD_ST3 INTO v_tradable_qttyEx
              FROM PORTFOLIOSEX
              WHERE ACCTNO = p_acctno AND SYMBOL = p_refsymbol ;
        EXCEPTION WHEN OTHERS THEN
          v_tradable_qttyEx:=0;
        END;
        v_tradable_qtty:=v_tradable_qtty + v_tradable_qttyEx;



        BEGIN
        SELECT INUSED INTO v_inused
        FROM OWNPOOLROOM
        WHERE PRID = p_prid AND ACCTNO = p_acctno AND REFSYMBOL = p_refsymbol AND POLICYTYPE = p_policytype;
        EXCEPTION
          WHEN OTHERS THEN
            v_inused := 0;
        END;
       --Tinh phan danh dau trong ngay.
       BEGIN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_own_qtty
            FROM ALLOCATION WHERE POLICYCD='R' AND ACCTNO=p_acctno AND SYMBOL=p_refsymbol AND ROOMID=p_prid;
       EXCEPTION WHEN OTHERS THEN
            v_daily_own_qtty:=0;
       END;

       v_inused:=v_inused+ v_daily_own_qtty;




        IF v_inused >0  THEN
          CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code,p_acctno,p_prid,p_refsymbol,v_inused,null,null,p_err_msg);
        END IF;


                 --Xoa tai khoan khoi poolroom
        DELETE FROM OWNPOOLROOM WHERE PRID = p_prid AND ACCTNO = p_acctno AND REFSYMBOL = p_refsymbol AND POLICYTYPE = p_policytype;

        --danh dau vao room he thong hoac uy ban
        IF v_tradable_qtty > 0 THEN
          SELECT BOD_BALANCE,BOD_DEBT_T0,BOD_D_MARGIN,BOD_T0VALUE,BOD_TD,BOD_D_MARGIN_UB,
             BOD_PAYABLE,ROOMID,BOD_ADV,CALC_ADVBAL,CALC_ODRAMT
          INTO v_balance,v_bod_debt_t0,v_bod_d_margin,v_t0value,v_td,v_bod_d_margin_ub,
             v_payable,v_roomid,v_bod_adv,v_advbal,v_ordamt
          FROM ACCOUNTS WHERE ACCTNO=p_acctno;
             v_ordamt := CSPKS_FO_COMMON.fn_get_buy_amt(p_acctno);
              /*
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_roomid',v_roomid);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_payable',v_payable);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_bod_debt_t0',v_bod_debt_t0);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_bod_d_margin',v_bod_d_margin);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_bod_d_margin_ub',v_bod_d_margin_ub);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_ordamt',v_ordamt);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'0','0');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_balance',v_balance);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_bod_adv',v_bod_adv);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_advbal',v_advbal);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_td',v_td);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_t0value',v_t0value);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'v_side','NULL');
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'p_refsymbol',p_refsymbol);
              insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'update_ownpoolroom',p_acctno,null,'f_qtty',0);
              */

          CSPKS_FO_POOLROOM.sp_process_markroom_v5(p_err_code,p_acctno,v_roomid,v_payable,v_bod_debt_t0,v_bod_d_margin,
          v_bod_d_margin_ub,v_ordamt,0,v_balance,v_bod_adv,v_advbal,v_td,v_t0value,null,null,p_refsymbol,0,p_err_msg);
        END IF;
      END IF;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
    WHERE REFID=p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
        WHERE REFID=p_refid;
        p_err_msg:='sp_process_update_ownpoolroom '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_update_ownpoolroom;

  --thanh ly tai ky tx5120
  PROCEDURE sp_process_5120(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- no bao lanh
            p_type   IN VARCHAR, -- loai no bao lanh hay margin
            p_doc   IN VARCHAR, --C tang, D giam
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime          TIMESTAMP;
    v_count             NUMBER;
    v_cash        NUMBER;
    v_buyamt      NUMBER;
    v_ta_margin   NUMBER;
    v_roomid      VARCHAR(20);
    v_rate_ub     NUMBER;
    v_balance     NUMBER;
    v_advbal      NUMBER;
    v_bodadv      NUMBER;
    v_crlimit     NUMBER;
    v_debt        NUMBER;
    v_debt_t0     NUMBER;

  BEGIN
    p_err_msg:='sp_process_5120 p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count    = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime
        WHERE REFID= p_refid;
      RETURN;
    ELSE

      --lay thong tin bang accounts
      SELECT BOD_BALANCE,CALC_ADVBAL,BOD_ADV,BOD_CRLIMIT,BOD_DEBT,BOD_DEBT_T0,ROOMID,RATE_UB
      INTO v_balance,v_advbal,v_bodadv,v_crlimit,v_debt,v_debt_t0,v_roomid,v_rate_ub
      FROM ACCOUNTS WHERE ACCTNO = p_acctno;

      IF (p_doc = 'D') THEN  -- giam no
          IF (p_type = 'T0') THEN --no bao lanh trong han

            UPDATE ACCOUNTS SET BOD_DEBT_T0 = BOD_DEBT_T0-p_amount,
                                BOD_SCASHTN = BOD_SCASHTN -p_amount,
                                BOD_DEBT = BOD_DEBT-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'M0') THEN --no margin trong han
            --v_cash := least(v_balance+v_advbal+greatest(least(v_ta_margin,v_crlimit-v_debt),0)-least(v_buyamt,v_debt_t0),v_balance+v_advbal);
            UPDATE ACCOUNTS SET BOD_D_MARGIN = BOD_D_MARGIN-p_amount,
                                BOD_DEBT = BOD_DEBT-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'U0') THEN --no margin uy ban trong han
            UPDATE ACCOUNTS SET BOD_D_MARGIN=BOD_D_MARGIN-p_amount,
                               BOD_DEBT=BOD_DEBT-p_amount,
                               BOD_D_MARGIN_UB=BOD_D_MARGIN_UB-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'T1') THEN --no bao lanh qua han
            UPDATE ACCOUNTS SET BOD_DEBT_T0 = BOD_DEBT_T0-p_amount,
                                BOD_DEBT_M = BOD_DEBT_M -p_amount,
                                BOD_DEBT = BOD_DEBT-p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'M1') THEN --no margin qua han
            UPDATE ACCOUNTS SET BOD_D_MARGIN = BOD_D_MARGIN-p_amount,
                               BOD_DEBT = BOD_DEBT-p_amount,
                               BOD_DEBT_M = BOD_DEBT_M -p_amount
            WHERE ACCTNO = p_acctno;

          ELSIF (p_type = 'U1') THEN --no margin uy ban
            UPDATE ACCOUNTS SET BOD_D_MARGIN=BOD_D_MARGIN-p_amount,
                               BOD_DEBT=BOD_DEBT-p_amount,
                               BOD_D_MARGIN_UB=BOD_D_MARGIN_UB-p_amount,
                               BOD_DEBT_M = BOD_DEBT_M -p_amount
            WHERE ACCTNO = p_acctno;


          END IF;
          /*
          --tiendt: update no qua han
          --date: 2015-11-15
          UPDATE ACCOUNTS SET BOD_DEBT_M = GREATEST(BOD_DEBT_M - p_amount, 0) WHERE ACCTNO = p_acctno;
          --end
          */

      ELSIF (p_doc = 'C') THEN
        IF (p_type = 'T0') THEN --no bao lanh
          UPDATE ACCOUNTS SET BOD_DEBT_T0 = BOD_DEBT_T0 + p_amount,
                              BOD_DEBT = BOD_DEBT + p_amount
          WHERE ACCTNO = p_acctno;
        ELSIF (p_type = 'M0') THEN --no margin
           UPDATE ACCOUNTS SET BOD_D_MARGIN = BOD_D_MARGIN + p_amount,
                               BOD_DEBT = BOD_DEBT + p_amount
            WHERE ACCTNO = p_acctno;
        ELSIF (p_type = 'U0') THEN --no margin uy ban
           UPDATE ACCOUNTS SET BOD_D_MARGIN=BOD_D_MARGIN+p_amount,
                               BOD_DEBT=BOD_DEBT+p_amount,
                               BOD_D_MARGIN_UB=BOD_D_MARGIN_UB+p_amount
            WHERE ACCTNO = p_acctno;
        END IF;

      ELSE
        --dbms_output.put_line('dau vao khong hop le');
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;
        RETURN;
      END IF;
    END IF;
    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_5120 '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_5120;

  --xu li tien mat khong check tx5121

  PROCEDURE sp_process_5121(p_err_code IN OUT VARCHAR,
            p_acctno   IN VARCHAR, --so tai khoan chuyen
            p_amount   IN NUMBER,  -- so tien
            p_doc      IN VARCHAR, --D or C
            p_refid    IN VARCHAR,
            p_err_msg OUT VARCHAR2
  )
  AS
    v_currtime        TIMESTAMP;
    v_count           NUMBER;
    v_bod_balance     ACCOUNTS.BOD_BALANCE%TYPE;
  BEGIN
    p_err_msg:='sp_process_5121 p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE immediate 'select tt_sysdate from dual' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count FROM ACCOUNTS WHERE ACCTNO = p_acctno;
    IF v_count = 0 THEN
      p_err_code := '-90019';
      RETURN;
    ELSE
      IF (p_doc = 'C') THEN
        UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE + p_amount WHERE ACCTNO = p_acctno;
      ELSIF (p_doc = 'D') THEN
          UPDATE ACCOUNTS SET BOD_BALANCE = BOD_BALANCE - p_amount WHERE ACCTNO = p_acctno;
      ELSE
        p_err_code := '-90021';
        UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
        RETURN;
      END IF;
    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID = p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_process_5121 '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_process_5121;

  PROCEDURE sp_block_stock(
      p_err_code IN OUT VARCHAR,
      p_acctno   IN VARCHAR2, --so tai khoan chuyen
      p_refid    IN VARCHAR2, -- so hieu xu li cua FO
      p_symbol   IN VARCHAR2, --ma chung khoan
      p_qtty     IN NUMBER,   -- KL chung khoan giao dich
      p_doc      IN VARCHAR,
      p_err_msg OUT VARCHAR2
    )
  AS
  v_currtime        TIMESTAMP;
  v_count_acctno NUMBER;
  v_count_symbol NUMBER;
  v_bod_stn NUMBER;
  v_count_ins NUMBER;
  v_formulacd   ACCOUNTS.FORMULACD%TYPE;
  v_formulacd_rtn     NUMBER(20,2);

  BEGIN
    p_err_msg:='sp_block_stock p_acctno=>'||p_acctno;
    BEGIN
      EXECUTE IMMEDIATE 'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
    END;
    p_err_code := '0';
    SELECT COUNT(1) INTO v_count_acctno FROM accounts WHERE acctno = p_acctno;
    IF v_count_acctno = 0 THEN
      p_err_code := '-90019';
      UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
      RETURN;
    ELSE

      SELECT COUNT(1) INTO v_count_symbol FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
      IF v_count_symbol = 0 THEN
        SELECT COUNT(1) INTO v_count_ins FROM INSTRUMENTS WHERE SYMBOL=p_symbol;
        IF v_count_ins = 0 THEN
          p_err_code :='0';
          RETURN;
        END IF;
      END IF;

      IF (p_doc = 'C') THEN

        IF v_count_symbol = 0 THEN
         BEGIN
           SELECT formulacd INTO v_formulacd FROM accounts WHERE  ACCTNO = p_acctno;
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
          EXCEPTION WHEN OTHERS THEN
           v_formulacd_rtn :=0;
          END;
          INSERT INTO PORTFOLIOS (ACCTNO,SYMBOL,BOD_STN,LASTCHANGE, bod_rtn) VALUES (p_acctno,p_symbol,p_qtty,v_currtime,v_formulacd_rtn);

        ELSE
          UPDATE PORTFOLIOS SET BOD_STN=BOD_STN+p_qtty,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
        END IF;
      ELSIF (p_doc = 'D') THEN
        IF v_count_symbol = 0 THEN
          p_err_code := '0';
          --dbms_output.put_line('p_err_code : ' || p_err_code);
        ELSE
          SELECT BOD_STN INTO v_bod_stn FROM PORTFOLIOS WHERE SYMBOL=p_symbol AND ACCTNO=p_acctno;
          IF p_qtty <= v_bod_stn THEN
            UPDATE PORTFOLIOS SET BOD_STN=BOD_STN-p_qtty,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
          ELSE
            p_err_code := '-90007';
            UPDATE TRANSACTIONS SET STATUS='R',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;
            RETURN;
          END IF;
        END IF;
      ELSIF (p_doc = 'U') THEN
        UPDATE PORTFOLIOS SET BOD_STN=p_qtty,LASTCHANGE=v_currtime WHERE ACCTNO=p_acctno AND SYMBOL=p_symbol;
      END IF;

    END IF;

    UPDATE TRANSACTIONS SET STATUS='C',TIME_EXECUTED=v_currtime,LASTCHANGE=v_currtime WHERE REFID=p_refid;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_block_stock '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_block_stock;

END CSPKS_FO_TRANS;
/


-- End of DDL Script for Package FOTEST.CSPKS_FO_TRANS
