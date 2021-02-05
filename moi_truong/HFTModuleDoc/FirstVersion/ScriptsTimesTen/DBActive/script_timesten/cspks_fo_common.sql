-- Start of DDL Script for Package Body FOTEST.CSPKS_FO_COMMON
-- Generated 05/11/2018 3:43:46 PM from FOTEST@FO

CREATE OR REPLACE 
PACKAGE BODY cspks_fo_common AS

    -- Tinh s?c mua
        PROCEDURE sp_get_pp (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                                f_acctno IN VARCHAR,
                                f_fomulacd IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_bod_adv NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_price IN NUMBER,
                f_basketid IN VARCHAR,
                f_ordamt IN NUMBER,
                f_roomid IN VARCHAR,
                f_rate_ub IN NUMBER, -- for MSBS
                f_symbol IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
    AS
      v_ordamt NUMBER;
    Begin
     --dbms_output.put_line('2015-11-24');

      --dbms_output.put_line('f_fomulacd:' || f_fomulacd);
      IF f_fomulacd = 'PPSE' THEN
        sp_get_pp_ppse(p_err_code, p_pp, f_acctno, f_bal,
                       f_t0value,f_td,f_payable,f_debt,f_ratebrk,
                       f_advbal,f_crlimit,f_rate_margin,f_price_margin,
                       f_price,f_basketid, f_ordamt,f_fomulacd,f_bod_adv,f_roomid,f_rate_ub,p_err_msg);
      ELSIF f_fomulacd = 'PPSET0' THEN
        sp_get_pp_ppset0(p_err_code, p_pp, f_acctno, f_bal,
                       f_t0value,f_td,f_payable,f_debt,f_ratebrk,
                       f_advbal,f_crlimit,f_rate_margin,f_price_margin, f_price,f_basketid,
                       f_ordamt,f_fomulacd,f_bod_adv,f_roomid,f_rate_ub,f_symbol,p_err_msg);
      ELSIF f_fomulacd = 'PP0' THEN
        sp_get_pp_pp0(p_err_code, p_pp, f_ordamt, f_acctno, f_bal,
                    f_t0value, f_td, f_payable, f_debt, f_ratebrk,
                    f_advbal,f_crlimit, f_rate_margin, f_price_margin, f_basketid,f_fomulacd,f_bod_adv,f_roomid,f_rate_ub,p_err_msg);
      ELSIF f_fomulacd = 'CASH' THEN
        sp_get_pp_cash(p_err_code, p_pp, f_ordamt, f_acctno, f_bal,
                      f_t0value, f_td, f_payable, f_debt, f_ratebrk,p_err_msg);
      ELSIF f_fomulacd = 'ADV' THEN
        sp_get_pp_adv(p_err_code, p_pp, f_ordamt, f_acctno, f_bal,
                      f_t0value, f_td, f_payable, f_debt, f_ratebrk,f_advbal,f_bod_adv,p_err_msg);

      END IF;
    END sp_get_pp;

  -- Tinh suc mua bang tien hien co
  PROCEDURE sp_get_pp_cash (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                p_ordamt in NUMBER,
                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
    AS

    BEGIN
      p_pp := 0;
      --p_ordamt := 0;

      --sp_get_pp_ordamt(p_err_code, p_ordamt, f_acctno);

      p_pp := f_t0value + f_bal + f_td - f_payable - f_debt - p_ordamt;

--      dbms_output.put_line('f_t0value: ' || f_t0value);
--      dbms_output.put_line('f_bal: ' || f_bal);
--      dbms_output.put_line('f_td: ' || f_td);
--      dbms_output.put_line('f_payable: ' || f_payable);
--      dbms_output.put_line('f_debt: ' || f_debt);
--      dbms_output.put_line('p_ordamt: ' || p_ordamt);
--
--       dbms_output.put_line('=================p_pp: ' || p_pp);

    END sp_get_pp_cash;

  -- Tinh suc mua gom co tien ung truoc
    PROCEDURE sp_get_pp_adv (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                p_ordamt in  NUMBER,
                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_bod_adv IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
    AS

    BEGIN
      p_pp := 0;

      sp_get_pp_cash(p_err_code, p_pp, p_ordamt, f_acctno, f_bal, f_t0value, f_td, f_payable, f_debt, f_ratebrk,p_err_msg);

      p_pp := p_pp + trunc(f_advbal + f_bod_adv);

     --dbms_output.put_line('f_advbal: ' || f_advbal);

    END sp_get_pp_adv;

  -- Tinh s?c mua PP0
    PROCEDURE sp_get_pp_pp0 (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                p_ordamt in NUMBER,
                                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_basketid IN VARCHAR,
                f_fomulacd IN VARCHAR,
                f_bod_adv IN NUMBER,--ung truoc dau ngay
                f_roomid IN VARCHAR,
                f_rate_ub IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
    AS
      v_pp_asset_amt NUMBER default 0;
      v_advbal NUMBER :=0;
      v_bod_adv NUMBER :=0;
    BEGIN
      p_pp := 0;

    /*tiendt fix tam thoi cho sua lenh tai khoan corebank*/
    IF f_fomulacd = 'CASH' THEN
      v_advbal :=0;
      v_bod_adv :=0;
    ELSE
      v_advbal :=f_advbal;
      v_bod_adv :=f_bod_adv;
    END IF;
    /*end */
      sp_get_pp_adv(p_err_code, p_pp, p_ordamt, f_acctno, f_bal, f_t0value, f_td, f_payable, f_debt, f_ratebrk, v_advbal,v_bod_adv,p_err_msg);
      --dbms_output.put_line('tien +++++++ :' || p_pp);
      --sp_get_pp_security_amt(p_err_code, v_pp_security_amt, f_acctno, f_basketid);

      /*tiendt, edit for MSBS
       TA = rate * price * MIN(qtty,ROOM)
       date: 2015-08-28
      */

      -- gia tri tai san chung khoan cua tieu khoan
      --v_pp_asset_amt := fn_get_asset_amt(f_acctno);

      --Chung khoan dang trong bang order cung dc tinh lam suc mua
      --v_pp_asset_amt := v_pp_asset_amt + nvl(fn_get_order_ppse_amt(f_acctno,f_fomulacd),0);

      v_pp_asset_amt := nvl(fn_get_ta(f_acctno,f_roomid,f_rate_ub),0);

      /*end*/
      --dbms_output.put_line('fn_get_ta++++++++++:' || v_pp_asset_amt);
      p_pp := p_pp + LEAST(v_pp_asset_amt, f_crlimit);
      --dbms_output.put_line('p_pp2 +++++++ :' || p_pp);
    END sp_get_pp_pp0;

    --Tinh ppo cho edit order
    --ThanhNV 2016.01.03: Tai san bi tru di phan sua khoi luong giam.
    PROCEDURE sp_get_pp_pp0_edit (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                p_ordamt in NUMBER,
                                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_basketid IN VARCHAR,
                f_fomulacd IN VARCHAR,
                f_bod_adv IN NUMBER,--ung truoc dau ngay
                f_roomid IN VARCHAR,
                f_rate_ub IN NUMBER,
                p_err_msg OUT VARCHAR2,
                f_delta_qtty IN NUMBER,
                f_symbol IN VARCHAR2
                )
    AS
      v_pp_asset_amt NUMBER default 0;
    BEGIN
      p_pp := 0;

      sp_get_pp_adv(p_err_code, p_pp, p_ordamt, f_acctno, f_bal, f_t0value, f_td, f_payable, f_debt, f_ratebrk, f_advbal,f_bod_adv,p_err_msg);
      --dbms_output.put_line('tien +++++++ :' || p_pp);
 --dbms_output.put_line('1117 p_pp011 '||p_pp );
      v_pp_asset_amt := nvl(fn_get_ta_edit_order(f_acctno,f_roomid,f_rate_ub, f_delta_qtty,f_symbol),0);
 --dbms_output.put_line('1117 v_pp_asset_amt '||v_pp_asset_amt );
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'PP0_EDIT',f_acctno,null,'v_pp_asset_amt : ',v_pp_asset_amt);
      --v_pp_asset_amt := v_pp_asset_amt - f_edit_buyamt;
      p_pp := p_pp + LEAST(v_pp_asset_amt, f_crlimit);
 --dbms_output.put_line('1117 p_pp11 '||p_pp );
      --dbms_output.put_line('p_pp2 +++++++ :' || p_pp);
    END sp_get_pp_pp0_edit;

    -- Tinh s?c mua PPSE
    PROCEDURE sp_get_pp_ppse (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_price IN NUMBER,
                f_basketid IN VARCHAR,
                f_ordamt IN NUMBER,
                f_fomulacd IN VARCHAR,
                f_bod_adv IN NUMBER,
                f_roomid IN VARCHAR,
                f_rate_ub IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
    AS
      v_pp_limit NUMBER;
      v_ordamt NUMBER;
    BEGIN
      p_pp := 0;
      v_ordamt :=f_ordamt;

      sp_get_pp_pp0(p_err_code, p_pp, v_ordamt, f_acctno, f_bal,
                    0 -- [gia tri bao lanh t0]
                    , f_td, f_payable, f_debt, f_ratebrk, f_advbal
                    ,f_crlimit, f_rate_margin, f_price_margin, f_basketid,f_fomulacd,f_bod_adv,f_roomid,f_rate_ub,p_err_msg);

      --dbms_output.put_line('p_pp:' || p_pp);
      --dbms_output.put_line('v_ordamt:' || v_ordamt);
      --dbms_output.put_line('f_bal:' || f_bal);
      --dbms_output.put_line('f_payable:' || f_payable);
      --dbms_output.put_line('f_ratebrk:' || f_ratebrk);
      --dbms_output.put_line('f_advbal:' || f_advbal);
      --dbms_output.put_line('f_crlimit:' || f_crlimit);
      --dbms_output.put_line('f_rate_margin:' || f_rate_margin);
      --dbms_output.put_line('f_price_margin:' || f_price_margin);
      --dbms_output.put_line('f_basketid:' || f_basketid);
      --dbms_output.put_line('f_t0value:' || f_t0value);
      --dbms_output.put_line('f_crlimit:' || f_crlimit);

      sp_get_pp_limit(p_err_code, v_pp_limit,v_ordamt,f_bal,f_t0value,
                      f_td,f_payable,f_debt,f_ratebrk,f_advbal,f_crlimit,f_rate_margin,f_price_margin,f_bod_adv,p_err_msg);

      --dbms_output.put_line('Test: ' || f_rate_margin || ';' || f_price_margin || ';' || f_price || ';' || (1 + f_ratebrk));
     -- dbms_output.put_line('Test: ' || (f_rate_margin * f_price_margin) / (f_price * (1 + f_ratebrk)));

        --dbms_output.put_line('f_rate_margin:' || f_rate_margin);
        --dbms_output.put_line('f_price_margin:' || f_price_margin);
        --dbms_output.put_line('f_price:' || f_price);
        --dbms_output.put_line('f_ratebrk:' || f_ratebrk);
        --dbms_output.put_line('v_pp_limit:' || v_pp_limit);
        --dbms_output.put_line('p_pp---------:' || p_pp);
      p_pp := f_t0value + LEAST(p_pp/(1- (f_rate_margin/100 * f_price_margin) / (f_price * (1 + f_ratebrk/100))), v_pp_limit);
        --p_pp := f_t0value + (p_pp/(1- (f_rate_margin/100 * f_price_margin) / (f_price * (1 + f_ratebrk/100))));
      --dbms_output.put_line('p_pp=======:' || p_pp);
      p_pp := LEAST(p_pp,v_pp_limit);
      p_pp := nvl(p_pp,0);

      --dbms_output.put_line('PPSE: ' || p_pp);

    END sp_get_pp_ppse;

    -- Tinh suc mua PPSET0
    PROCEDURE sp_get_pp_ppset0 (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_price IN NUMBER,
                f_basketid IN VARCHAR,
                f_ordamt IN NUMBER,
                f_fomulacd IN VARCHAR,
                f_bod_adv IN NUMBER,
                f_roomid IN VARCHAR,
                f_rate_ub IN NUMBER, -- for MSBS
                f_symbol IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
    AS
      v_pp_limit NUMBER;
      v_ordamt NUMBER;
      v_rate_margin NUMBER;
      v_pp0 NUMBER;
      v_daily_room  NUMBER :=0;
      v_remain_room NUMBER :=0;
      v_daily_count NUMBER := 0;
      v_marked_qtty NUMBER := 0;
      v_marked_ub_qtty NUMBER := 0;
      v_count       NUMBER :=0;
      v_qtty        NUMBER :=0;
      v_sys_qtty    NUMBER :=0;
      v_portfolios_qtty       NUMBER :=0;
      v_prid        VARCHAR(20);
      v_inuse       NUMBER :=0;

      v_markedEX          NUMBER;
      v_markedcomEX       NUMBER;
      v_portfolios_qttyEX NUMBER;

    BEGIN
      p_pp := 0;
      v_ordamt :=f_ordamt;


      sp_get_pp_pp0(p_err_code, v_pp0, v_ordamt, f_acctno, f_bal,
                    f_t0value -- [gia tri bao lanh t0]
                    , f_td, f_payable, f_debt, f_ratebrk, f_advbal
                    ,f_crlimit, f_rate_margin/100, f_price_margin, f_basketid,f_fomulacd,f_bod_adv,f_roomid,f_rate_ub,p_err_msg);

      sp_get_pp_limit(p_err_code, v_pp_limit,v_ordamt,f_bal,f_t0value,
                      f_td,f_payable,f_debt,f_ratebrk,f_advbal,f_crlimit,f_rate_margin/100,f_price_margin,f_bod_adv,p_err_msg);


--       dbms_output.put_line('sp_get_pp_limit=====:' || v_pp_limit);
--       dbms_output.put_line('f_rate_margin=====:' || f_rate_margin);
--       dbms_output.put_line('f_price_margin=====:' || f_price_margin);
--       dbms_output.put_line('f_price=====:' || f_price);
--       dbms_output.put_line('f_ratebrk=====:' || f_ratebrk);

       /*dung.bui add code,date 30/09/2015 */
       IF f_roomid = 'UB' THEN
        v_rate_margin := LEAST((f_rate_ub),f_rate_margin);
        --v_rate_margin := LEAST(f_rate_ub,f_rate_margin);
       ELSE
        v_rate_margin := f_rate_margin;
       END IF;
       --dbms_output.put_line('v_rate_margin=====:' || v_rate_margin);
       /*end*/
      p_pp := LEAST(v_pp0/(1- (/*f_rate_margin*/v_rate_margin/100 * f_price_margin) / (f_price * (1 + (f_ratebrk/100)))), v_pp_limit);
        --dbms_output.put_line('PPSET0: ' || p_pp);
        --dbms_output.put_line('v_pp0==================: ' || v_pp0);

      --tiendt modified for min of buy symbol room , 2015-10-06
      SELECT COUNT(1) INTO v_count FROM PORTFOLIOS WHERE ACCTNO = f_acctno AND SYMBOL = f_symbol;
      IF v_count >0 THEN
        SELECT TRADE+RECEIVING-BOD_ST3+BUYINGQTTY, MARKED, MARKEDCOM
        INTO v_portfolios_qtty,v_marked_qtty,v_marked_ub_qtty
        FROM PORTFOLIOS
        WHERE ACCTNO = f_acctno AND SYMBOL = f_symbol;

        --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
         BEGIN
                SELECT -BOD_ST3+BUYINGQTTY, MARKED,MARKEDCOM INTO v_portfolios_qttyEX , v_markedEX,v_markedcomEX
                FROM PORTFOLIOSEX WHERE ACCTNO = f_acctno AND SYMBOL = f_symbol;
         EXCEPTION WHEN OTHERS THEN
                v_portfolios_qttyEX:=0;
                v_markedEX :=0;
                v_markedcomEX:=0;
         END;
         v_portfolios_qtty:= v_portfolios_qtty +  v_portfolios_qttyEX;
         v_marked_qtty:=v_marked_qtty + v_markedEX;
         v_marked_ub_qtty:=v_marked_ub_qtty +  v_markedcomEX;
      END IF;

       --dbms_output.put_line('v_marked_qtty==================: ' || v_marked_qtty);
       --dbms_output.put_line('v_marked_ub_qtty==================: ' || v_marked_ub_qtty);

      IF f_roomid = 'UB' THEN
        v_marked_qtty := v_marked_ub_qtty;
      END IF;


      --tinh room con lai cua ma mua (SYSTEM)
      SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='SYSTEM' AND SYMBOL=f_symbol;
      IF v_daily_count > 0 THEN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
         FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='SYSTEM' AND SYMBOL=f_symbol;
      END IF;

      --dbms_output.put_line('v_daily_room==================: ' || v_daily_room);

      --dbms_output.put_line('v_daily_room: ' || v_daily_room);
      SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='SYSTEM' AND REFSYMBOL=f_symbol;
      IF v_daily_count > 0 THEN
         SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
         FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='SYSTEM' AND REFSYMBOL=f_symbol;
         v_remain_room := v_remain_room/* +  v_marked_qtty*/;
      END IF;

      --dbms_output.put_line('v_remain_room==================: ' || v_remain_room);

      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = f_acctno AND REFSYMBOL=f_symbol;
      IF v_count = 0 THEN --ma ck khong nam trong room dac biet
        v_sys_qtty := NVL(v_remain_room - v_daily_room,0);
        v_qtty := v_sys_qtty;
      ELSE --ma chung khoan thuoc room dac biet
        RETURN;
        /*
        v_daily_room := 0;
        v_remain_room :=0;
        SELECT PRID,INUSED INTO v_prid,v_inuse FROM OWNPOOLROOM WHERE ACCTNO = f_acctno AND REFSYMBOL=f_symbol;

        SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
        FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=v_prid AND SYMBOL=f_symbol;

        SELECT NVL(GRANTED,0) - NVL(INUSED,0) - v_daily_room
        INTO v_remain_room
        FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=v_prid AND REFSYMBOL=f_symbol;

        v_qtty := v_remain_room + v_inuse;
        v_sys_qtty := v_remain_room + v_inuse;

        v_qtty := v_remain_room + v_inuse;
        v_sys_qtty := v_remain_room + v_inuse;
        */
      END IF;

      --tinh room con lai cua ma mua (UB)
      IF f_roomid = 'UB' AND v_count = 0 THEN
          v_daily_room := 0;
          v_remain_room := 0;
          SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='UB' AND SYMBOL=f_symbol;
          IF v_daily_count > 0 THEN
             SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
             FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='UB' AND SYMBOL=f_symbol;
          END IF;

          SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='UB' AND REFSYMBOL=f_symbol;
          IF v_daily_count > 0 THEN
             SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
             FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='UB' AND REFSYMBOL=f_symbol;
             v_remain_room := v_remain_room /*+  v_marked_qtty */;
          END IF;

          --MIN(ROOM SYSTEM; ROOM UB)
          v_qtty := NVL(LEAST(v_sys_qtty,v_remain_room - v_daily_room),0);

      END IF;

      v_qtty := GREATEST(v_qtty + v_marked_qtty - v_portfolios_qtty,0);

      p_pp := LEAST(p_pp, v_pp0 + v_qtty*v_rate_margin*f_price_margin/100 );

      p_pp := nvl(p_pp,0);

      --dbms_output.put_line('PPSET0: ' || p_pp);

    END sp_get_pp_ppset0;

    -- Tinh tong gia tri ky quy lenh mua trong ngay
   /* PROCEDURE sp_get_exec_buy_amt (p_err_code in OUT VARCHAR,
                                p_exec_buy_amt in OUT NUMBER,
                                f_acctno IN VARCHAR,
                                p_err_msg OUT VARCHAR2
                )
    AS
      v_exec_ba_amt NUMBER;
    BEGIN
      p_err_code := '0';
      p_err_msg  := 'sp_get_exec_buy_amt f_acctno=>'||f_acctno;
      p_exec_buy_amt := 0;

      SELECT SUM((EXEC_AMT + REMAIN_QTTY*QUOTE_PRICE)*(1+RATE_BRK/100))
        INTO p_exec_buy_amt
      FROM ORDERS WHERE SUBSIDE = 'NB' AND ACCTNO = f_acctno;
      p_exec_buy_amt := nvl(p_exec_buy_amt, 0);

      SELECT SUM(GREATEST(0, ((norder.QUOTE_QTTY - oorder.EXEC_QTTY) * norder.QUOTE_PRICE - (oorder.QUOTE_QTTY-oorder.EXEC_QTTY) * oorder.QUOTE_PRICE)) * (1 + norder.RATE_BRK/100))
        INTO v_exec_ba_amt
      FROM ORDERS norder
      INNER JOIN ORDERS oorder on norder.REFORDERID = oorder.ORDERID
      WHERE norder.SUBSIDE = 'AB' AND norder.ACCTNO = f_acctno;
      v_exec_ba_amt := nvl(v_exec_ba_amt,0);

      p_exec_buy_amt := p_exec_buy_amt + v_exec_ba_amt;

     -- dbms_output.put_line('BUYAMT: ' || p_exec_buy_amt);
    EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_get_exec_buy_amt ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_exec_buy_amt;
    */

    -- Tinh gia tr? tai s?n quy d?i vao s?c mua
  /*  PROCEDURE sp_get_pp_security_amt (p_err_code in OUT VARCHAR,
                                p_pp_security_amt in OUT NUMBER,
                                f_acctno IN VARCHAR,
                f_basketid IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
    AS

    BEGIN
      p_pp_security_amt := 0;

      SELECT SUM(property.QTTY * b.RATE_BUY * b.PRICE_ASSET)
      INTO p_pp_security_amt
      FROM BASKETS b
      INNER JOIN
        (SELECT p.SYMBOL, LEAST(p.QTTY, pr.GRANTED - pr.INUSED) as QTTY
        FROM (
          SELECT SYMBOL, SUM(QTTY) as QTTY
          FROM (
          -- Khoi luong ck co the lam tai san dam bao
          SELECT SYMBOL, (TRADE + RECEIVING + BUYINGQTTY - BOD_ST3) as QTTY
          FROM PORTFOLIOS
          WHERE ACCTNO = f_acctno
          UNION
          --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
          SELECT SYMBOL, (BUYINGQTTY - BOD_ST3) as QTTY
          FROM PORTFOLIOSEX
          WHERE ACCTNO = f_acctno
          UNION
          -- Khoi luong ck da duoc danh dau
          SELECT SYMBOL, -SUM(ROOMVAL) as QTTY
          FROM ALLOCATION
          WHERE ACCTNO = f_acctno
          GROUP BY SYMBOL)
          GROUP BY SYMBOL) p
          LEFT JOIN POOLROOM pr on pr.REFSYMBOL = p.SYMBOL) property
        ON b.symbol = property.symbol
        WHERE b.BASKETID = f_basketid;

--      SELECT SUM(property.QTTY * b.RATE_BUY * b.PRICE_ASSET)
--        INTO p_pp_security_amt
--      FROM BASKETS b
--      INNER JOIN
--        (SELECT p.SYMBOL, LEAST(p.QTTY, pr.GRANTED - pr.INUSED) as QTTY
--        FROM (
--          SELECT SYMBOL, SUM(QTTY) as QTTY
--          FROM (
--          -- Kh?i l??ng t? do
--          SELECT SYMBOL, SUM(TRADE) as QTTY
--          FROM PORTFOLIOS
--          WHERE ACCTNO = f_acctno
--          GROUP BY SYMBOL
--          UNION
--          -- Kh?i l??ng mua  l??ng ban th??ng ch?a kh?p
--          -- Todo: Tr? di kh?i l??ng d? c?m c?
--          SELECT SYMBOL, SUM(QUOTE_QTTY) as QTTY
--          FROM ORDERS
--          WHERE ACCTNO = f_acctno
--          AND (SUBSIDE = 'NB' OR (SUBSIDE = 'NS' AND STATUS IN ('N','B')))
--          GROUP BY SYMBOL
--          UNION
--          -- Kh?i l??ng d? danh d?u
--          SELECT SYMBOL, -SUM(ROOMVAL) as QTTY
--          FROM ALLOCATION
--          WHERE ACCTNO = f_acctno
--          GROUP BY SYMBOL)
--          GROUP BY SYMBOL) p
--          LEFT JOIN POOLROOM pr on pr.REFSYMBOL = p.SYMBOL) property
--        ON b.symbol = property.symbol
--        WHERE b.BASKETID = f_basketid;

      --dbms_output.put_line('SECURITY_AMT: ' || p_pp_security_amt);
    END sp_get_pp_security_amt; */

    -- Tinh h?n m?c mua t?i da
    PROCEDURE sp_get_pp_limit (p_err_code in OUT VARCHAR,
                                p_pp_limit in OUT NUMBER,
                f_ordamt IN NUMBER,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_bod_adv IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
    AS

    BEGIN
      p_pp_limit := f_bal + f_td + f_t0value + TRUNC(f_advbal + f_bod_adv) + f_crlimit - f_payable - f_debt - f_ordamt;
      --dbms_output.put_line('LIMIT: ' || p_pp_limit);

    END sp_get_pp_limit;

    -- Tinh t?ng gia tr? ky qu? trong ngay
   /* PROCEDURE sp_get_pp_ordamt (p_err_code in OUT VARCHAR,
                                p_pp_ordamt in OUT NUMBER,
                                f_acctno IN VARCHAR,
                                p_err_msg OUT VARCHAR2
                )
    AS
      v_exec_buy_amt NUMBER;
      v_exec_sc_amt NUMBER;
      v_exec_sa_amt NUMBER;
    BEGIN
      p_pp_ordamt := 0;

      sp_get_exec_buy_amt(p_err_code, v_exec_buy_amt, f_acctno,p_err_msg);

      p_pp_ordamt := v_exec_buy_amt + v_exec_sc_amt + v_exec_sa_amt;

    END sp_get_pp_ordamt;
    */

  PROCEDURE sp_get_orderid (p_err_code in OUT VARCHAR,
              p_order_id in OUT VARCHAR,
              p_err_msg OUT VARCHAR2
              )
    AS
      v_order_seq VARCHAR(20);
      v_date VARCHAR(20);
      v_order_id VARCHAR(20);
    BEGIN
      p_err_msg:='sp_get_orderid';
      select to_char(sysdate,'yyyymmdd') into v_date from dual;

      select SEQ_ORDERS.NEXTVAL into v_order_seq FROM DUAL;
      v_order_id := fn_format_sequenceid(v_order_seq);

      p_order_id := '9' || v_date || v_order_id;
    EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_get_orderid '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_orderid;


    PROCEDURE sp_get_quoteid (p_err_code in OUT VARCHAR,
              p_quote_id in OUT VARCHAR,
              p_err_msg OUT VARCHAR2
              )
    AS
      v_quote_seq VARCHAR(20);
      v_date VARCHAR(20);
      v_quote_id VARCHAR(20);
    BEGIN
      p_err_msg:='sp_get_quoteid';
      --v_date := '20140806';
      select to_char(sysdate,'yyyymmdd') into v_date from dual;

      select SEQ_QUOTES.NEXTVAL into v_quote_seq FROM DUAL;
      v_quote_id := fn_format_sequenceid(v_quote_seq);

      p_quote_id := v_date || v_quote_id;
    EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_get_quoteid '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_quoteid;


    PROCEDURE sp_get_tradeid (p_err_code in OUT VARCHAR,
              p_trade_id in OUT VARCHAR,
              p_err_msg OUT VARCHAR2
              )
    AS
      v_trade_seq VARCHAR(20);
      v_date VARCHAR(20);
      v_trade_id VARCHAR(20);
    BEGIN
      p_err_msg:='sp_get_tradeid';
      --v_date := '20140806';
      select to_char(sysdate,'yyyymmdd') into v_date from dual;

      select SEQ_TRADING.NEXTVAL into v_trade_seq FROM DUAL;
      v_trade_id := fn_format_sequenceid(v_trade_seq);

      p_trade_id := v_date || v_trade_id;
    EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_get_tradeid ' || p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_tradeid;


  FUNCTION fn_get_root_orderid RETURN  varchar AS
        v_root_seq number;
        v_ret varchar(20);
    v_count number;
    BEGIN
    select SEQ_ROOT_ORDERID.NEXTVAL into v_root_seq FROM DUAL;
    /*date 12/10/2015,dung.bui comment code for test thong san */
--      v_ret := '00000000' || v_root_seq;
--      v_count := length(v_ret);
--      v_ret := substr(v_ret, v_count-8+1, 8);
      v_ret := v_root_seq;
      v_ret := '9' || v_ret;
    /*end*/
        RETURN v_ret;
    END;

 FUNCTION fn_get_dealid RETURN  varchar AS
        v_deal_seq number;
        v_ret varchar(20);
    v_count number;
    BEGIN
    select SEQ_DEALID.NEXTVAL into v_deal_seq FROM DUAL;
        /*v_ret := '00000' || v_deal_seq;
        v_count := length(v_ret);
        v_ret := substr(v_ret, v_count-5+1, 5);*/
    v_ret := v_deal_seq;
        RETURN v_ret;
    END;

    PROCEDURE sp_proces_close_market (p_err_code in OUT VARCHAR,
                                      p_date_time IN VARCHAR,
                                      p_err_msg OUT VARCHAR2 )
    AS
      v_trade_seq VARCHAR(20);
      v_date VARCHAR(20);
      v_trade_id VARCHAR(20);
      v_order_amt NUMBER(20,2);
      v_count NUMBER(20,2);
    BEGIN
        p_err_msg:='sp_proces_close_market ';
        --plog.info('Xu ly ket thuc thi truong');
        --1. Giai toa lenh mua
        FOR rec IN --lay ck trong bang portfolios
        (
          SELECT symbol,acctno,remain_qtty,quote_price,rate_brk
          FROM orders
          WHERE side = 'B' AND status IN ('N','S') AND substatus IN ('NN','SS')
        )
        LOOP
           v_order_amt := rec.remain_qtty * rec.quote_price * (1+rec.rate_brk);
           --dbms_output.enable;
           --dbms_output.put_line('v_order_amt:' || v_order_amt);

           --Cap nhat account
           UPDATE accounts SET calc_odramt = calc_odramt - v_order_amt  WHERE ACCTNO = rec.acctno;

           --Cap nhat orders
           UPDATE orders SET status = 'P' WHERE side = 'B' AND status IN ('N','S');
        END LOOP;

        --2. Giai toa lenh ban
        FOR rec IN --lay ck trong bang portfolios
        (
          SELECT symbol,acctno,remain_qtty,subside
          FROM orders
          WHERE side = 'S' AND status IN ('N','S') AND substatus IN ('NN','SS')
        )
        LOOP
          IF rec.subside = 'NS' THEN
              --ThanhNV sua 11/12/2015
              SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = rec.acctno AND symbol=rec.symbol;
              IF v_count > 0 THEN
                 UPDATE portfoliosex SET sellingqtty = sellingqtty - rec.remain_qtty WHERE acctno = rec.acctno AND symbol=rec.symbol;
              ELSE
                 INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (rec.acctno, rec.symbol, 0, -rec.remain_qtty,
                                   0, 0, 0, 0, SYSDATE, 0);
              END IF;

              /*
              UPDATE portfolios SET sellingqtty = sellingqtty + rec.remain_qtty WHERE acctno = rec.acctno AND symbol=rec.symbol;
              */
          ELSE
              --ThanhNV sua 11/12/2015
              SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = rec.acctno AND symbol=rec.symbol;
              IF v_count > 0 THEN
                 UPDATE portfoliosex SET sellingqttymort = sellingqttymort - rec.remain_qtty WHERE acctno = rec.acctno AND symbol=rec.symbol;
              ELSE
                 INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (rec.acctno, rec.symbol, 0, 0,
                                   -rec.remain_qtty, 0, 0, 0, SYSDATE, 0);
              END IF;
              /*
              UPDATE portfolios SET sellingqttymort = sellingqttymort + rec.remain_qtty WHERE acctno = rec.acctno AND symbol=rec.symbol;
              */
          END IF;

           --Cap nhat orders
           UPDATE orders SET status = 'P' WHERE side = 'S' AND status IN ('N','S');
        END LOOP;
    EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_proces_close_market '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_close_market;

  -- Tinh suc mua thieu
  /*    PROCEDURE sp_get_pp_inadequate (p_err_code in OUT VARCHAR,
                                p_pp in OUT NUMBER,
                                f_acctno IN VARCHAR,
                f_bal IN NUMBER,
                f_t0value IN NUMBER,
                f_td IN NUMBER,
                f_payable IN NUMBER,
                f_debt IN NUMBER,
                f_ratebrk IN NUMBER,
                f_advbal IN NUMBER,
                f_crlimit IN NUMBER,
                f_rate_margin IN NUMBER,
                f_price_margin IN NUMBER,
                f_price IN NUMBER,
                f_qtty IN NUMBER,
                f_basketid IN VARCHAR,
                f_ordamt IN NUMBER,
                f_fomulacd IN VARCHAR,
                f_bod_adv IN NUMBER,
                f_room_id IN VARCHAR
                )
    AS
      v_ordamt NUMBER;
    BEGIN
      p_pp := 0;

--      sp_get_pp_pp0(p_err_code, p_pp, f_ordamt, f_acctno, f_bal,
--                    f_t0value -- [gia tri bao lanh t0]
--                    , f_td, f_payable, f_debt, f_ratebrk, f_advbal
--                    ,f_crlimit, f_rate_margin, f_price_margin, f_basketid,f_fomulacd,f_bod_adv,f_room_id);

      p_pp := GREATEST(0,
                      (f_qtty * f_price * (1 + f_ratebrk))
                      * (1 + (f_rate_margin * f_price_margin)/(f_price * (1 + f_ratebrk))
                      - f_t0value - p_pp));

      p_pp := nvl(p_pp,0);

      --dbms_output.put_line('PP_INADEQUATE: ' || p_pp);

    END sp_get_pp_inadequate;
    */

  FUNCTION fn_format_sequenceid(p_str IN varchar) RETURN  varchar AS
        v_count number;
        v_ret varchar(20);
    BEGIN
        v_ret := '0000000000' || p_str;
        v_count := length(v_ret);
        v_ret := substr(v_ret, v_count-10+1, 10);
        RETURN v_ret;
    END;



  --Lay trang thai cua lenh dua vao phien giao dich va loai lenh
  PROCEDURE sp_get_status(p_err_code IN OUT VARCHAR,
            p_status IN OUT VARCHAR,
            p_substatus IN OUT VARCHAR,
            p_sesionex in varchar,
            p_subtypecd in varchar,
            p_exchange in varchar,
            p_err_msg OUT VARCHAR2
            )
    AS
      v_board VARCHAR(20);
    BEGIN
    p_err_msg:='sp_get_status p_sesionex'||p_sesionex;
    IF p_exchange = 'HSX' THEN --San HSX
      IF p_sesionex = 'OPN' THEN --Phien mo cua
        IF p_subtypecd = 'ATO' OR p_subtypecd = 'LO' THEN
          p_status := 'B';
          p_substatus := 'BB';
        ELSE --MP,ATC
          p_status := 'N';
          p_substatus := 'NN';
        END IF;
      ELSIF p_sesionex = 'CNT' THEN --phien lien tuc
        IF p_subtypecd = 'MP' OR p_subtypecd = 'LO' THEN
          p_status := 'B';
          p_substatus := 'BB';
        ELSE --ATO,ATC
          p_status := 'N';
          p_substatus := 'NN';
        END IF;
      ELSIF p_sesionex = 'CLS' THEN --Phien dong cua
        IF p_subtypecd = 'ATC' OR p_subtypecd = 'LO' THEN
          p_status := 'B';
          p_substatus := 'BB';
        ELSE --La lenh ATO,MP
          p_status := 'N';
          p_substatus := 'NN';
        END IF;
      ELSE --Dat lenh truoc phien
          p_status := 'N';
          p_substatus := 'NN';
      END IF;
    ELSIF p_exchange = 'HNX' THEN --San HNX
      IF p_sesionex = 'CNT' THEN --phien lien tuc
        IF p_subtypecd = 'LO' OR p_subtypecd = 'MAK' OR p_subtypecd = 'MOK' OR p_subtypecd = 'MTL' THEN
          p_status := 'B';
          p_substatus := 'BB';
        ELSE --La lenh ATC
          p_status := 'N';
          p_substatus := 'NN';
        END IF;
      ELSIF p_sesionex = 'CLS' OR p_sesionex = 'L5M' THEN
       IF p_subtypecd = 'LO' OR p_subtypecd = 'ATC' THEN
          p_status := 'B';
          p_substatus := 'BB';
        ELSE --La lenh MAK,MOK,MTL
          p_status := 'N';
          p_substatus := 'NN';
        END IF;
      --HNX_update_GL
      ELSIF p_sesionex = 'CROSS' THEN
        IF p_subtypecd = 'PLO' THEN
          p_status := 'B';
          p_substatus := 'BB';
        ELSE
          p_status := 'N';
          p_substatus := 'NN';
        END IF;
      --End HNX_update_GL
      ELSE
        p_status := 'N';
        p_substatus := 'NN';
      END IF;

    END IF;
   EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_get_status '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_status;


-- tien rut tren suc mua thang du
  FUNCTION fn_get_avl_balance(p_account IN varchar,
     p_balance IN NUMBER, --so du tien mat
     p_advbal IN NUMBER, --tien ung truoc
     p_payable IN  NUMBER, --no phi, no thue
     p_debt IN  NUMBER, --no margin
     p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
     p_bod_crlimit IN  NUMBER, --han muc tin dung
     p_roomid IN VARCHAR,
     f_rate_ub IN  NUMBER --for msbs
    ) RETURN  NUMBER
  AS
    v_avl_balance NUMBER;
    v_buy_amt NUMBER;
    v_asset NUMBER;
    v_errcode varchar(20);

    BEGIN
    --tien ki quy cho lenh mua trong ngay
    v_buy_amt := fn_get_buy_amt(p_account);
    --sp_get_exec_buy_amt(v_errcode,v_buy_amt,p_account);
    --dbms_output.put_line('v_buy_amt : ' || v_buy_amt);

    --gia tri tai san CK cua tieu khoan
    v_asset := fn_get_ta(p_account, p_roomid,f_rate_ub);
    --v_asset := fn_get_asset(p_account);
    --v_asset := fn_get_asset_amt(p_account);
    --dbms_output.put_line('v_asset : ' || v_asset);
    --dbms_output.put_line('LEAST(v_asset,p_bod_crlimit):' || LEAST(v_asset,p_bod_crlimit));
    --dbms_output.put_line('GREATEST(0,v_buy_amt - p_td):' || GREATEST(0,v_buy_amt - p_td));

    v_avl_balance := p_balance + p_advbal + LEAST(v_asset,p_bod_crlimit) - p_debt - p_payable - GREATEST(0,v_buy_amt - p_td);

        RETURN v_avl_balance;

     EXCEPTION
      WHEN OTHERS THEN
        v_avl_balance := -1; --undefined error
    END;

  -- tien rut tren so tien co
  FUNCTION fn_get_VNDwithdraw(p_account IN varchar,
     p_balance IN NUMBER, --so du tien mat
     p_advbal IN NUMBER, --tien ung truoc
     p_payable IN  NUMBER, --no phi, no thue
     p_debt IN NUMBER, --no margin
     p_debt_m IN  NUMBER, --no margin den han/qua han
     p_td IN NUMBER, --tien tiet kiem cong vao suc mua
     p_bod_crlimit IN NUMBER, --han muc tin dung,
     p_roomid IN VARCHAR,
     p_rate_ub IN NUMBER --for msbs
    ) RETURN  NUMBER
  AS
    v_avl_balance NUMBER;
    v_VNDwithdraw NUMBER;

  BEGIN
    v_VNDwithdraw := 0;

    v_avl_balance := fn_get_avl_balance(p_account,p_balance,p_advbal,p_payable,p_debt,p_td,p_bod_crlimit,p_roomid,p_rate_ub);
    --DBMS_OUTPUT.PUT_LINE('AAAAA: ' || v_VNDwithdraw);

    v_VNDwithdraw := LEAST(p_balance + p_advbal - p_payable - p_debt_m, v_avl_balance);


--    dbms_output.put_line('v_avl : ' || v_avl_balance);
--    dbms_output.put_line('v_VNDwithdraw : ' || v_VNDwithdraw);
    RETURN v_VNDwithdraw;

    EXCEPTION
      WHEN OTHERS THEN
        v_avl_balance := -1; --undefined error
  END;

  -- tien rut tren so tien co (cho msbs) (msg tx5001)
  /*date : 01/12/2015*/
  FUNCTION fn_get_VNDwithdraw2(p_account IN varchar
    ) RETURN  NUMBER
  AS
    v_VNDwithdraw   NUMBER := 0;
    v_pp0           NUMBER;
    v_buy_amt       NUMBER;
    v_balance       NUMBER;
    v_debt          NUMBER;
    v_debt_m        NUMBER;
    v_bod_adv       NUMBER;
    v_advbal        NUMBER;
    v_payable       NUMBER;
    v_td            NUMBER;
    v_crlimit       NUMBER;
    v_basketid      VARCHAR(60);
    v_roomid        VARCHAR(20);
    v_t0value       NUMBER;
    v_rate_ub       NUMBER;
    v_bod_d_margin_ub NUMBER;
    v_formulacd     VARCHAR(20);
    p_err_code      VARCHAR(20);
    v_cash          NUMBER;
    v_cash_limit    NUMBER;
    v_temp          NUMBER :=0;
    v_temp2         NUMBER :=0;
    v_rtt_ub        NUMBER;
    v_ta_real_ub    NUMBER;
    p_err_msg       varchar2(4000);
    v_bod_scashtn   NUMBER; -- no bao lanh trong han
  BEGIN

    --lay thong tin bang accounts
            SELECT BOD_BALANCE,BOD_DEBT,BOD_DEBT_M,BOD_ADV,CALC_ADVBAL,BOD_PAYABLE,FORMULACD,
                BOD_TD,BOD_CRLIMIT,BASKETID,ROOMID,BOD_T0VALUE,RATE_UB,BOD_D_MARGIN_UB,BOD_SCASHTN
            INTO v_balance,v_debt,v_debt_m,v_bod_adv,v_advbal,v_payable,v_formulacd,
                v_td,v_crlimit,v_basketid,v_roomid,v_t0value,v_rate_ub,v_bod_d_margin_ub,v_bod_scashtn
            FROM ACCOUNTS WHERE ACCTNO = p_account;

    v_cash := v_balance+v_bod_adv+v_advbal-v_debt_m-v_payable;
    --ki quy mua
    v_buy_amt := fn_get_buy_amt(p_account);

    IF (v_formulacd='CASH') THEN
      v_VNDwithdraw:=v_balance-v_debt_m-v_payable -v_buy_amt ;
    ELSIF (v_formulacd='ADV') THEN
      v_VNDwithdraw:=v_cash -v_buy_amt;
    ELSIF (v_formulacd='PPSET0') THEN


      --suc mua PP0

      sp_get_pp_pp0(p_err_code,v_pp0,v_buy_amt,p_account,v_balance,0,v_td,v_payable,
              v_debt,0,v_advbal,v_crlimit,0,0,v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);

      v_cash_limit := v_crlimit + v_td -(v_debt+v_payable-v_balance-v_advbal-v_bod_adv+v_buy_amt);

      IF (v_roomid = 'SYSTEM') THEN --tai khoan khong tuan thu
        v_temp := LEAST(v_pp0,v_cash-v_bod_scashtn);
        v_VNDwithdraw := LEAST(v_temp,v_cash_limit);
      ELSIF (v_roomid = 'UB') THEN  --tai khoan tuan thu
        /*tinh ve 2 trong cong thuc,dinh nghia*/
        --min 3 phan tu
        --MIN[PP0; VNDbal  + UTTB ? OD den han ? OD qua han ? no phi luu ki ; LCL + TD ? (OD + phi luu ki den han - VNDbal ?VNDreceive + ki quy mua trong ngay)]
        v_temp := LEAST(v_pp0,v_cash-v_bod_scashtn);
        v_temp := LEAST(v_temp,v_cash_limit);
        --dbms_output.put_line('v_temp : ' || v_temp);

        /*tinh ve 1 trong cong thuc*/
        --tinh ti le an toan
        v_rtt_ub:= fn_get_rtt_ub(p_account,v_balance,v_advbal+v_bod_adv,v_bod_d_margin_ub);
        --dbms_output.put_line('v_rtt_ub : ' || v_rtt_ub);
        --tinh ta_real_ub
        v_ta_real_ub:=fn_get_ta_real_ub(p_account,'Y','N','UB');
        --dbms_output.put_line('v_ta_real_ub : ' || v_ta_real_ub);
        -- v_temp2:=(Rtt_UB ? RUB)/100 * TArealUB + max(VNDbal  + UTTB ? OD den han ? OD qua han ? no phi luu ky,0);
        v_temp2:=(v_rtt_ub-v_rate_ub/100) * v_ta_real_ub + GREATEST(v_balance+v_advbal+v_bod_adv-v_debt_m-v_payable,0);
        --dbms_output.put_line('v_temp2 : ' || v_temp2);
        v_VNDwithdraw :=LEAST(v_temp2,v_temp);

      END IF;
    END IF;

    v_VNDwithdraw := TRUNC(GREATEST(v_VNDwithdraw,0));

    RETURN v_VNDwithdraw;

    EXCEPTION
      WHEN OTHERS THEN
        v_VNDwithdraw := -1; --undefined error
  END;

  --rut tien tren suc mua thang du (msg tx5107)
  /*dung.bui added code, date : 02/12/2015*/
  FUNCTION fn_get_avl_balance2(p_account IN varchar
    ) RETURN  NUMBER
  AS
    v_VNDwithdraw_PP   NUMBER := 0;
    v_buy_amt       NUMBER;
    v_balance       NUMBER;
    v_debt          NUMBER;
    v_debt_m        NUMBER;
    v_bod_adv       NUMBER;
    v_advbal        NUMBER;
    v_payable       NUMBER;
    v_td            NUMBER;
    v_crlimit       NUMBER;
    v_rate_ub       NUMBER;
    --v_temp          NUMBER :=0;
    --v_temp2         NUMBER :=0;
    --v_ta_mr         NUMBER;

    v_pp0           NUMBER :=0;
    v_t0value       NUMBER;
    v_basketid      VARCHAR(60);
    v_formulacd     VARCHAR(20);
    v_roomid        VARCHAR(20);
    p_err_code      VARCHAR(20);
    p_err_msg       VARCHAR(4000);
  BEGIN

    --lay thong tin bang accounts
    SELECT BOD_BALANCE,BOD_DEBT,BOD_DEBT_M,BOD_ADV,CALC_ADVBAL,BOD_PAYABLE,
      BOD_TD,BOD_CRLIMIT,RATE_UB,BOD_T0VALUE,BASKETID,FORMULACD,ROOMID
    INTO v_balance,v_debt,v_debt_m,v_bod_adv,v_advbal,v_payable,
      v_td,v_crlimit,v_rate_ub,v_t0value,v_basketid,v_formulacd,v_roomid
    FROM ACCOUNTS WHERE ACCTNO = p_account;

    --tinh ki quy mua
    v_buy_amt := fn_get_buy_amt(p_account);
    --tinh suc mua PP0
    sp_get_pp_pp0(p_err_code,v_pp0,v_buy_amt,p_account,v_balance,0,v_td,v_payable,
            v_debt,0,v_advbal,v_crlimit,0,0,v_basketid,v_formulacd,v_bod_adv,v_roomid,v_rate_ub,p_err_msg);
    v_VNDwithdraw_PP := TRUNC(GREATEST(v_pp0-v_td,0));

    /*
    --tinh TAMR
    v_ta_mr := fn_get_ta_real_ub(p_account,'Y','Y','SYSTEM');--Y, Y, co lay MIN voi ROOM, va co nhan voi ti le tinh tai san
     --dbms_output.put_line('v_ta_mr : ' || v_ta_mr);
    --tinh ki quy mua
    v_buy_amt := fn_get_buy_amt(p_account);
     --dbms_output.put_line('v_buy_amt : ' || v_buy_amt);
    --ve 1 cua cong thuc
    --VNDbal + UTTB + min ( TAMR ; LCL ) ? OD ? max ( 0 ; BUYamt ? TD )
    v_temp := v_balance+v_advbal+v_bod_adv+LEAST(v_ta_mr,v_crlimit)-v_debt-v_payable-GREATEST(0,v_buy_amt-v_td);
    --ve 2 cua cong thuc
    --LCL + TD ? OD ?  Ph??u k? ??n h?n + VNDbal + VNDreceive ? BUYamt
    v_temp2 := v_crlimit+v_td-v_debt-v_payable+v_balance+v_advbal+v_bod_adv-v_buy_amt;

    v_VNDwithdraw_PP := LEAST(v_temp,v_temp2);
    v_VNDwithdraw_PP := GREATEST(v_VNDwithdraw_PP,0);
    */
    RETURN v_VNDwithdraw_PP;

    EXCEPTION
      WHEN OTHERS THEN
        v_VNDwithdraw_PP := -1; --undefined error
  END;


  --tiendt: 24/8/2015, modified
  --get Buy Amount from Orders table
  FUNCTION fn_get_buy_amt(p_account IN varchar)
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

       --phan lenh chua khop
       v_buy_amt := v_buy_amt + rec.REMAIN_QTTY * rec.QUOTE_PRICE*(1+rec.RATE_BRK/100);
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

      IF rec.SUBSTATUS ='SE' THEN --Lenh goc dang sua, do dang lay ky quy cua lenh con, can cong them phan chenh.
        FOR rec_ycsua IN (SELECT QUOTE_QTTY, EXEC_QTTY,EXEC_AMT, REMAIN_QTTY, RATE_BRK, QUOTE_PRICE
                           FROM ORDERS  WHERE reforderid  = rec.ORDERID)
        LOOP
            IF rec.REMAIN_QTTY * rec.QUOTE_PRICE > rec_ycsua.REMAIN_QTTY * rec_ycsua.QUOTE_PRICE THEN  --Ky quy lenh goc lon hon ky quy lenh sua.
                v_buy_amt:=   v_buy_amt  + (rec.REMAIN_QTTY * rec.QUOTE_PRICE -  rec_ycsua.REMAIN_QTTY * rec_ycsua.QUOTE_PRICE)*(1+rec.RATE_BRK/100);
            END IF;
        END LOOP;
      END IF;
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

       --phan lenh chua khop
       v_buy_amt := v_buy_amt + v_remain_qtty*v_quote_price*(1+v_rate_brk/100);
    END LOOP;
    /* end */

        RETURN v_buy_amt;

    EXCEPTION
      WHEN OTHERS THEN
        v_buy_amt := -1; --undefined error
    END;

  --get Buy Amount from Orders table
  FUNCTION fn_get_buy_amt_edit_order(p_account IN varchar)
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

       --phan lenh chua khop
       v_buy_amt := v_buy_amt + rec.REMAIN_QTTY * rec.QUOTE_PRICE*(1+rec.RATE_BRK/100);
    END LOOP;

    --lenh da khop mot phan cua lenh giai toa, vd:MOK
     FOR rec IN
     (
      SELECT EXEC_AMT,RATE_BRK
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

       --phan lenh chua khop
       v_buy_amt := v_buy_amt + v_remain_qtty*v_quote_price*(1+v_rate_brk/100);
    END LOOP;
    /* end */

        RETURN v_buy_amt;

    EXCEPTION
      WHEN OTHERS THEN
        v_buy_amt := -1; --undefined error
    END;


  --ai viet?
  /* FUNCTION fn_get_asset(p_account IN varchar)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER;
    v_symbol NUMBER;
    v_quote_qtty NUMBER;
    v_quote_price NUMBER;
    v_rate_brk NUMBER;

    BEGIN
    v_asset_value := 0;
     FOR rec IN --lay ck dang duoc danh dau trong bang portfolios
     (
      --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.trade,p.sellingqtty + NVL(pex.sellingqtty,0) sellingqtty,b.price_margin,b.rate_margin,p.receiving
      --INTO v_symbol,v_quote_qtty,v_quote_price,v_price_asset,v_rate_asset
      FROM portfolios p,accounts a, baskets b, portfoliosex pex
      WHERE p.acctno = p_account AND  p.acctno = a.acctno AND a.basketid = b.basketid AND p.symbol = b.symbol
        AND p.acctno = pex.acctno(+) AND  p.symbol = pex.symbol(+)
     )
     LOOP
       v_asset_value := v_asset_value + (rec.trade-rec.sellingqtty + rec.receiving) * rec.price_margin*rec.rate_margin;
    END LOOP;

    --Lay chung khoan dang cho khop
    FOR rec IN --
     (
      SELECT o.remain_qtty,b.price_margin,b.rate_margin
      --INTO v_symbol,v_quote_qtty,v_quote_price,v_price_asset,v_rate_asset
      FROM orders o,accounts a, baskets b
      WHERE o.acctno = p_account AND o.subside = 'NS' AND  o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
     )
     LOOP
       v_asset_value := v_asset_value + rec.remain_qtty * rec.price_margin*rec.rate_margin;
    END LOOP;

        RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END;
    */

  /*Tinh gia tri tai san chung khoan cua tieu khoan*/
 /* FUNCTION fn_get_asset_amt(p_account IN varchar)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER;
    v_symbol NUMBER;
    v_quote_qtty NUMBER;
    v_quote_price NUMBER;
    v_rate_brk NUMBER;
    v_basketid varchar(60);
  BEGIN
    v_asset_value := 0;


    FOR rec IN --lay ck dang duoc danh dau trong bang portfolios
    (
      --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.trade,p.sellingqtty + NVL(pex.sellingqtty,0) sellingqtty ,b.price_margin,b.rate_margin,p.receiving,p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3
      --INTO v_symbol,v_quote_qtty,v_quote_price,v_price_asset,v_rate_asset
      FROM portfolios p,accounts a, baskets b, portfoliosex pex
      WHERE p.acctno = p_account AND  p.acctno = a.acctno AND a.basketid = b.basketid AND p.symbol = b.symbol
        AND p.acctno = pex.acctno(+) AND  p.symbol = pex.symbol(+)
    )

    LOOP
      v_asset_value := v_asset_value + (rec.trade - rec.sellingqtty + rec.receiving) * rec.price_margin*rec.rate_margin/100;
    END LOOP;

        RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END; */

   /*Tinh gia tri tai san chung khoan cho suc mua trong bang orders*/
 /* FUNCTION fn_get_order_ppse_amt(p_account IN varchar,f_fomulacd IN VARCHAR)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER;
    v_formulacd VARCHAR2(10);
    ori_remain_qtty number;
    v_exec_qtty_ori number;
    BEGIN
    v_asset_value := 0;
    --1.CK Mua da khop
    --2.Mua chua khop
    --3.Ban thuong chua khop
    --4.So luong sua giam cua lenh mua dang sua

    IF f_fomulacd = 'PPSE' OR f_fomulacd = 'PPSET0' THEN

      --Mua da khop va mua chua khop
      FOR rec IN
       (
        SELECT o.exec_qtty,o.remain_qtty,b.price_margin,b.rate_margin
        FROM orders o,accounts a, baskets b
        WHERE o.acctno = p_account AND o.side='B' AND (o.substatus IN ('NN','BB','SS'))
            AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
       )
       LOOP
         v_asset_value := v_asset_value + (rec.exec_qtty+rec.remain_qtty) * rec.price_margin*rec.rate_margin/100;
      END LOOP;
      --dbms_output.put_line('v_asset_value++++++++++1:' || v_asset_value);

      --Lenh Huy
      FOR rec IN
       (
        SELECT o.remain_qtty,b.price_margin,b.rate_margin
        FROM orders o,accounts a, baskets b
        WHERE o.acctno = p_account AND o.side='O' AND o.status='D' AND (o.substatus IN ('NN','SS','DE','BB'))
            AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
       )
       LOOP
         v_asset_value := v_asset_value + rec.remain_qtty * rec.price_margin*rec.rate_margin/100;
      END LOOP;

       --Huy/Sua Lenh goc khop 1 phan
      FOR rec IN
       (
        SELECT o.exec_qtty,b.price_margin,b.rate_margin
        FROM orders o,accounts a, baskets b
        WHERE o.acctno = p_account AND o.side='B'  AND (o.substatus IN ('SD','DD','SE'))
            AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
       )
       LOOP
         v_asset_value := v_asset_value + rec.exec_qtty * rec.price_margin*rec.rate_margin/100;
      END LOOP;

      -- lenh sua mua khop 1 phan
       FOR rec IN
       (
        SELECT o.exec_qtty,b.price_margin,b.rate_margin,o.reforderid
        FROM orders o,accounts a, baskets b
        WHERE o.acctno = p_account AND o.side='O' AND o.status='E' AND o.subside in ('AB','NB')  AND (o.substatus IN ('ES'))
            AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
       )
       LOOP

         v_asset_value := v_asset_value + rec.exec_qtty * rec.price_margin*rec.rate_margin/100;
      END LOOP;


      --Lenh Sua da xac nhan
      FOR rec IN
       (
        SELECT o.remain_qtty,b.price_margin,b.rate_margin
        FROM orders o,accounts a, baskets b
        WHERE o.acctno = p_account AND o.side='O'   AND o.status='E' AND (o.substatus IN ('ES'))
            AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
       )
       LOOP
         v_asset_value := v_asset_value + rec.remain_qtty * rec.price_margin*rec.rate_margin/100;
      END LOOP;

      --Lenh Sua chua xac nhan
        FOR rec IN
       (
        SELECT o.remain_qtty,b.price_margin,b.rate_margin, o.reforderid
        FROM orders o,accounts a, baskets b
        WHERE o.acctno = p_account AND o.side='O'   AND o.status='E' AND (o.substatus IN ('BB'))
            AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
       )
       LOOP
          SELECT remain_qtty INTO ori_remain_qtty FROM orders WHERE orderid = rec.reforderid;
          IF (ori_remain_qtty < rec.remain_qtty) THEN
            v_asset_value := v_asset_value + rec.remain_qtty  * rec.price_margin*rec.rate_margin/100;
          ELSE
            v_asset_value := v_asset_value + ori_remain_qtty  * rec.price_margin*rec.rate_margin/100;
          END IF;

      END LOOP;

    END IF;

    --Ban thuong chua khop ,  danh cho tai khoan pp0,ppse,ppset0
    FOR rec IN
     (
      SELECT o.remain_qtty,b.price_margin,b.rate_margin
      FROM orders o,accounts a, baskets b
      WHERE o.acctno = p_account AND o.side='S' AND o.subside='NS' AND (o.substatus IN ('NN','BB','SS'))
          AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
     )
     LOOP
       v_asset_value := v_asset_value + rec.remain_qtty * rec.price_margin*rec.rate_margin/100;
    END LOOP;

    -- Ban tong chua khop, gia tri tai san gom CKGD trong order
    FOR rec IN
     (
      SELECT o.remain_qtty,b.price_margin,b.rate_margin,o.mort_qtty
      FROM orders o,accounts a, baskets b
      WHERE o.acctno = p_account AND o.side='S' AND o.subside='TS' AND (o.substatus IN ('NN','BB','SS'))
          AND o.acctno = a.acctno AND a.basketid = b.basketid AND o.symbol = b.symbol
     )
     LOOP
       v_asset_value := v_asset_value + (rec.remain_qtty - rec.mort_qtty) * rec.price_margin*rec.rate_margin/100;
    END LOOP;

    --TODO: ky quy sua giam

        RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END; */


 /* FUNCTION fn_get_ratebrk(f_cficode IN VARCHAR,
            f_ratebrk_s IN NUMBER,
            f_ratebrk_b IN NUMBER) RETURN  NUMBER AS

            v_ratebrk NUMBER := 0;
  BEGIN
    CASE
      WHEN f_cficode = 'ES' THEN v_ratebrk := f_ratebrk_s;
      WHEN f_cficode = 'DB' THEN v_ratebrk := f_ratebrk_b;
    END CASE;
    RETURN v_ratebrk;
  END fn_get_ratebrk;*/

  PROCEDURE sp_check_reciprocal(p_err_code OUT NUMBER, --check lenh doi ung
            p_custodycd IN VARCHAR,
            p_symbol IN VARCHAR,
            p_err_msg OUT VARCHAR2,
            p_side IN VARCHAR2,
            p_subtypecd IN VARCHAR2
            )
  AS
      v_count NUMBER;
      v_subside VARCHAR(20);
      v_marketstatus varchar2(100);
      v_board varchar2(100);
      v_ContraSubside varchar2(100);
  BEGIN
      p_err_code := 0;
--    SELECT COUNT(1) INTO v_count FROM ORDERS
--    WHERE REMAIN_QTTY > 0 AND CUSTODYCD= p_custodycd AND SIDE IN (p_side, 'O') AND SYMBOL= p_symbol AND SUBSTATUS  NOT IN ('EE','DS');

     /*ThanhNV sua 30/6/2016 khong check doi ung trong phien lien tuc*/
      --Kiem tra trang thai thi truong, neu la CNT thi return ngay.


      BEGIN
        SELECT sessionex, i.board  INTO v_marketstatus, v_board FROM marketinfo m, instruments i WHERE m.exchange = i.board AND i.symbol =p_symbol;

      EXCEPTION WHEN OTHERS THEN
        v_marketstatus:='CLS'; --cho phien dong cua, de chan mua ban cung phien.
        v_board :='';
      END;

      IF  p_side ='B' THEN
        v_ContraSubside:='AS,NS,MS';
      ELSE
        v_ContraSubside:='NB,AB';
      END IF;
      --  HSX: Lien tuc + nghi trua
      --  HNX: lien tuc + truoc mo cua + nghi trua thi cho dat doi ung.
      --  Lenh khac ATC
      IF (
              (v_board ='HSX' AND  v_marketstatus IN  ('CNT','LB'))
                OR (v_board IN ('HNX','UPCOM') AND v_marketstatus IN ('BCNT','CNT')
              )
          ) OR  v_marketstatus ='CROSS'
      THEN
             IF p_subtypecd <> 'ATC' then
                 p_err_code := 0;
                 RETURN;
             ELSE  --Neu la lenh ATC thi check voi ATC doi ung.
                 SELECT COUNT (orderid)
                  INTO v_count
                  FROM orders
                 WHERE     custodycd = p_custodycd
                       AND symbol = p_symbol
                       AND remain_qtty > 0
                       AND instr(v_ContraSubside,subside) >0
                       AND subtypecd ='ATC'
                       AND substatus IN ('SS', 'BB', 'NN', 'SD', 'SE', 'U1', 'U5','ES');
                      IF v_count=0 THEN
                             p_err_code := 0;
                             RETURN;
                      ELSE
                             p_err_code := 1;
                             RETURN;
                      END IF;
             END IF;

      ELSE   --Phien dinh ky va truoc mo cua san HOSE.
             --Lenh trong phien ATC thi check doi ung voi cac lenh cung dat trong phien ATC.
              IF v_marketstatus in ('CLS','L5M') THEN
                  SELECT COUNT (orderid)
                      INTO v_count
                      FROM orders
                     WHERE     custodycd = p_custodycd
                           AND symbol = p_symbol
                           AND remain_qtty > 0
                           AND instr(v_ContraSubside,subside) >0
                           AND sessionex in ('CLS','L5M')
                           AND substatus IN ('SS', 'BB', 'NN', 'SD', 'SE', 'U1', 'U5','ES');

                       IF v_count = 0 THEN
                             p_err_code := 0;
                             RETURN;
                       ELSE
                             p_err_code := 1;
                             RETURN;
                       END IF;
              ELSE --Truoc phien mo cua va mo cua san HOSE:
                  SELECT COUNT (orderid)
                      INTO v_count
                      FROM orders
                     WHERE     custodycd = p_custodycd
                           AND symbol = p_symbol
                           AND remain_qtty > 0
                           AND instr(v_ContraSubside,subside) >0
                           AND substatus IN ('SS', 'BB', 'NN', 'SD', 'SE', 'U1', 'U5','ES');

                        IF v_count = 0 THEN
                             p_err_code := 0;
                             RETURN;
                        ELSE
                             p_err_code := 1;
                             RETURN;
                        END IF;
              END IF;

      END IF;
      --End TT203
  END;

  FUNCTION fn_get_fee_cash_advance(p_qtty in number, --khoi luong khop
        p_price in number, --gia khop
        p_rate_adv in number,--ti le phi ung truoc
        p_rate_brk in number,
        p_rate_tax in number
        ) RETURN NUMBER
  AS

  v_day number;
  v_fee number;
  v_count number;
  v_today_date date;
  BEGIN
    --DBMS_OUTPUT.PUT_LINE('AAAA');

    select to_date(CFGVALUE,'dd-mm-yyyy') INTO v_today_date from sysconfig where CFGKEY='TRADE_DATE';
    select count(1) into v_count from workingcalendar where todaydate = v_today_date;

    if v_count = 0 then
      v_day :=2;
    else
      select (T2DATE - TODAYDATE) INTO v_day FROM WORKINGCALENDAR WHERE todaydate = v_today_date /*and HOLIDAY = 'N'*/;
      --DBMS_OUTPUT.PUT_LINE('v_day: ' || v_day);
    end if;

    v_fee :=   v_day * p_qtty * p_price * (1 - p_rate_brk/100 - p_rate_tax/100) * p_rate_adv / 100 / 360;

    RETURN v_fee;
  END fn_get_fee_cash_advance;

  /*
   * Author: Trung.Nguyen
   * Date: 29-Dec-2015
   * Parameter:
   *      p_qtty
   *      p_price
   *      p_rate_adv
   *      p_rate_brk:
   *      p_rate_tax:
   *      p_marked: reference to ORDERS.MARKED
   * Description: only used to getting fee cash advance for cross order
   */
  FUNCTION fn_get_fee_cash_adv_cross_ord (p_qtty IN NUMBER,
              p_price IN NUMBER,
              p_rate_adv IN NUMBER,
              p_rate_brk IN NUMBER,
              p_rate_tax IN NUMBER,
              p_marked IN NUMBER) RETURN NUMBER
  AS
      v_day             NUMBER;
      v_fee             NUMBER;
      v_count           NUMBER;
      v_today_date      date;
  BEGIN
    SELECT TO_DATE(CFGVALUE,'dd-mm-yyyy') INTO v_today_date FROM SYSCONFIG WHERE CFGKEY='TRADE_DATE';

    IF (p_marked=1) THEN
      SELECT (T1DATE - TODAYDATE) INTO v_day FROM WORKINGCALENDAR WHERE todaydate = v_today_date /*and HOLIDAY = 'N'*/;
    ELSIF (p_marked=2) THEN
      SELECT (T2DATE - TODAYDATE) INTO v_day FROM WORKINGCALENDAR WHERE todaydate = v_today_date /*and HOLIDAY = 'N'*/;
    ELSIF (p_marked=3) THEN
      SELECT (T3DATE - TODAYDATE) INTO v_day FROM WORKINGCALENDAR WHERE todaydate = v_today_date /*and HOLIDAY = 'N'*/;
    ELSE
      v_day := p_marked;
    END IF;

    v_fee :=   v_day * p_qtty * p_price * (1 - p_rate_brk/100 - p_rate_tax/100) * p_rate_adv / 100 / 360;

    RETURN v_fee;
  END fn_get_fee_cash_adv_cross_ord;

   /*tiendt
     Tinh gia tri tai san chung khoan cua tieu khoan - danh cho ban MSBS
     Qi = MIN(CK, ROOM con lai)
     date: 2015-08-28, 17h
   */
  FUNCTION fn_get_ta(p_account IN varchar,
                    p_roomid IN varchar,
                    p_rate_ub IN NUMBER)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER(20,4);
    v_qtty        NUMBER;
    v_marked_qtty NUMBER;
    v_daily_room    NUMBER :=0;
    v_remain_room NUMBER :=0;
    v_daily_count NUMBER := 0;
    v_rate_margin NUMBER := 0;
    v_count       NUMBER := 0;
    v_roomsystem_ta NUMBER := 0;
  BEGIN
    v_asset_value := 0;


    FOR rec IN --lay ck trong bang portfolios
    ( --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.TRADE,p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) SELLINGQTTY,p.BUYINGQTTY + NVL(pex.BUYINGQTTY,0) BUYINGQTTY,b.PRICE_MARGIN,b.RATE_MARGIN,
             p.RECEIVING, p.BOD_RT3 +  NVL(pex.BOD_RT3,0) BOD_RT3, p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3,
             p.MARKED + NVL(pex.MARKED,0) MARKED,p.MARKEDCOM + NVL(pex.MARKEDCOM,0) MARKEDCOM,p.SYMBOL
      FROM PORTFOLIOS p,ACCOUNTS a, BASKETS b,PORTFOLIOSEX pex
      WHERE p.ACCTNO = p_account AND  p.ACCTNO = a.ACCTNO AND a.BASKETID = b.BASKETID AND p.SYMBOL = b.SYMBOL
         AND p.ACCTNO = pex.ACCTNO(+) AND p.SYMBOL =pex.SYMBOL(+)
    )

    LOOP
      --1. Tinh khoi luong chung khoan cua tai khoan
      v_qtty :=0;
      v_qtty := rec.TRADE - rec.SELLINGQTTY; --Chung khoan kha dung
      v_qtty := v_qtty + rec.SELLINGQTTY - rec.BOD_ST3; --Ban trong ngay chua khop
      v_qtty := v_qtty + rec.RECEIVING; --Chung khoan cho ve
      --v_qtty := v_qtty + rec.BOD_RT3; --Mua khop trong ngay
      --v_qtty := v_qtty + rec.BUYINGQTTY - rec.BOD_RT3 ; --Mua trong ngay chua khop
      v_qtty := v_qtty + rec.BUYINGQTTY;

      --dbms_output.put_line('SYMBOL++++++++++1:' || rec.SYMBOL || ',rec.TRADE:' || rec.TRADE || ',rec.SELLINGQTTY:' || rec.SELLINGQTTY
      --|| ',rec.BOD_ST3:' || rec.BOD_ST3 || ',rec.RECEIVING:' || rec.RECEIVING || ',rec.BUYINGQTTY:' || rec.BUYINGQTTY);

      --2. Tinh chung khoan da duoc danh dau
      IF p_roomid = 'UB' THEN
        v_marked_qtty := rec.MARKEDCOM;
      ELSE
        v_marked_qtty := rec.MARKED;
      END IF;

      v_daily_room := 0;
      v_remain_room := 0;
      --3. Tinh room con lai cua ma ck
      SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
         FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=rec.SYMBOL;
      END IF;

      SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
          --dbms_output.put_line('rec.SYMBOL++++++++++3333:' || rec.SYMBOL);
          --dbms_output.put_line('p_roomid++++++++++3333:' || p_roomid);
         SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
         FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=rec.SYMBOL;
           --Room remain thoi diem hien tai
           v_remain_room:=v_remain_room -v_daily_room;

      END IF;

      --4.Tinh min
      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_account AND REFSYMBOL=rec.SYMBOL;
      IF v_count = 0 THEN
        --Chung khoan toi da co the danh dau cua tk (bao gom so da danh dau)
        v_qtty := LEAST(v_qtty, GREATEST(v_remain_room,0) + v_marked_qtty);

      END IF;

      --5.Tinh values
      IF p_roomid = 'UB' THEN
        /*dung.bui edit, date 30/09/2015*/
        --v_rate_margin := LEAST(p_rate_ub,rec.RATE_MARGIN);
        v_rate_margin := LEAST(p_rate_ub,rec.RATE_MARGIN);
        /*end*/
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_MARGIN*v_rate_margin/100;
      ELSE
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_MARGIN*rec.RATE_MARGIN/100;
      END IF;
      --dbms_output.put_line('SYMBOL:' || rec.SYMBOL || ',v_qtty:' || v_qtty);
    END LOOP;

    --tinh MIN voi room he thong
    IF p_roomid = 'UB' THEN
      v_roomsystem_ta := fn_get_system_ta(p_account);
      v_asset_value :=  LEAST(v_asset_value,v_roomsystem_ta);
    END IF;

    RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END;


  /*ThanhNV: Lay tai san sau khi sua lenh, de check suc mua sau khi giam tai san
     Tinh gia tri tai san chung khoan cua tieu khoan - danh cho ban MSBS
     Qi = MIN(CK - sua_giam_khoiluong, ROOM con lai)
     date: 2016-92-29, 17h
   */
  FUNCTION fn_get_ta_edit_order(p_account IN varchar,
                    p_roomid IN varchar,
                    p_rate_ub IN NUMBER,
                    p_delta_qtty IN NUMBER,  --Khoi luong giam
                    p_symbol IN VARCHAR2)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER(20,4);
    v_qtty        NUMBER;
    v_marked_qtty NUMBER;
    v_daily_room    NUMBER :=0;
    v_remain_room NUMBER :=0;
    v_daily_count NUMBER := 0;
    v_rate_margin NUMBER := 0;
    v_count       NUMBER := 0;
    v_roomsystem_ta NUMBER := 0;
  BEGIN
    v_asset_value := 0;


    FOR rec IN --lay ck trong bang portfolios
    ( --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.TRADE,p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) SELLINGQTTY,p.BUYINGQTTY + NVL(pex.BUYINGQTTY,0) BUYINGQTTY,b.PRICE_MARGIN,b.RATE_MARGIN,
             p.RECEIVING, p.BOD_RT3 +  NVL(pex.BOD_RT3,0) BOD_RT3, p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3,
             p.MARKED + NVL(pex.MARKED,0) MARKED,p.MARKEDCOM + NVL(pex.MARKEDCOM,0) MARKEDCOM,p.SYMBOL
      FROM PORTFOLIOS p,ACCOUNTS a, BASKETS b,PORTFOLIOSEX pex
      WHERE p.ACCTNO = p_account AND  p.ACCTNO = a.ACCTNO AND a.BASKETID = b.BASKETID AND p.SYMBOL = b.SYMBOL
         AND p.ACCTNO = pex.ACCTNO(+) AND p.SYMBOL =pex.SYMBOL(+)
    )

    LOOP
      --1. Tinh khoi luong chung khoan cua tai khoan
      v_qtty :=0;
      v_qtty := rec.TRADE - rec.SELLINGQTTY; --Chung khoan kha dung
      v_qtty := v_qtty + rec.SELLINGQTTY - rec.BOD_ST3; --Ban trong ngay chua khop
      v_qtty := v_qtty + rec.RECEIVING; --Chung khoan cho ve
      --v_qtty := v_qtty + rec.BOD_RT3; --Mua khop trong ngay
      --v_qtty := v_qtty + rec.BUYINGQTTY - rec.BOD_RT3 ; --Mua trong ngay chua khop
      v_qtty := v_qtty + rec.BUYINGQTTY;

      --dbms_output.put_line('SYMBOL++++++++++1:' || rec.SYMBOL || ',rec.TRADE:' || rec.TRADE || ',rec.SELLINGQTTY:' || rec.SELLINGQTTY
      --|| ',rec.BOD_ST3:' || rec.BOD_ST3 || ',rec.RECEIVING:' || rec.RECEIVING || ',rec.BUYINGQTTY:' || rec.BUYINGQTTY);

      --2. Tinh chung khoan da duoc danh dau
      IF p_roomid = 'UB' THEN
        v_marked_qtty := rec.MARKEDCOM;
      ELSE
        v_marked_qtty := rec.MARKED;
      END IF;

      v_daily_room := 0;
      v_remain_room := 0;
      --3. Tinh room con lai cua ma ck
      SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
         FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=rec.SYMBOL;
      END IF;

      SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
          --dbms_output.put_line('rec.SYMBOL++++++++++3333:' || rec.SYMBOL);
          --dbms_output.put_line('p_roomid++++++++++3333:' || p_roomid);
         SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
         FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=rec.SYMBOL;

           --Room remain thoi diem hien tai
           v_remain_room:=v_remain_room -v_daily_room;

      END IF;

      --4.Tinh min
      IF p_symbol = rec.symbol THEN
            v_qtty := v_qtty - p_delta_qtty;
      END IF;
   insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
   values(SEQ_ttlogs.nextval,'fn_get_ta_edit_order',p_account,null,'v_qtty1',v_qtty);
   insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
   values(SEQ_ttlogs.nextval,'fn_get_ta_edit_order',p_account,null,'p_delta_qtty',p_delta_qtty);


      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_account AND REFSYMBOL=rec.SYMBOL;
      IF v_count = 0  THEN
          --Chung khoan toi da co the danh dau cua tk (bao gom so da danh dau)
          v_qtty := LEAST(v_qtty, GREATEST(v_remain_room,0) + v_marked_qtty);

      END IF;
      --dbms_output.put_line('Get TA Loop rec.SYMBOL'||rec.SYMBOL ||' p_symbol ' || p_symbol  ||'  v_qtty' || v_qtty);
 insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'fn_get_ta_edit_order',p_account,null,'v_qtty',v_qtty);
 insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'fn_get_ta_edit_order',p_account,null,'rec.SYMBOL',rec.SYMBOL);
 --COMMIT;
      --5.Tinh values
      IF p_roomid = 'UB' THEN
        /*dung.bui edit, date 30/09/2015*/
        --v_rate_margin := LEAST(p_rate_ub,rec.RATE_MARGIN);
        v_rate_margin := LEAST(p_rate_ub,rec.RATE_MARGIN);
        /*end*/
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_MARGIN*v_rate_margin/100;
      ELSE
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_MARGIN*rec.RATE_MARGIN/100;
      END IF;
      --dbms_output.put_line('SYMBOL:' || rec.SYMBOL || ',v_qtty:' || v_qtty);
    END LOOP;

    --tinh MIN voi room he thong
    IF p_roomid = 'UB' THEN
      v_roomsystem_ta := fn_get_system_ta_edit_order(p_account,p_delta_qtty, p_symbol);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'GET_TA',p_account,null,'v_roomsystem_ta : ',v_roomsystem_ta);
      v_asset_value :=  LEAST(v_asset_value,v_roomsystem_ta);
    END IF;

    RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END;

    /*tiendt
     Tinh gia tri tai san chung khoan theo room SYSTEM cua tieu khoan - danh cho ban MSBS
     Qi = MIN(CK, ROOM con lai)
     date: 2016-02-17, 14h
   */
  FUNCTION fn_get_system_ta(p_account IN varchar)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER(20,4);
    v_qtty        NUMBER;
    v_marked_qtty NUMBER :=0;
    v_daily_room    NUMBER :=0;
    v_remain_room NUMBER :=0;
    v_daily_count NUMBER := 0;
    v_count       NUMBER := 0;
  BEGIN
    v_asset_value := 0;


    FOR rec IN --lay ck trong bang portfolios
    ( --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.TRADE,p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) SELLINGQTTY,p.BUYINGQTTY + NVL(pex.BUYINGQTTY,0) BUYINGQTTY,b.PRICE_MARGIN,b.RATE_MARGIN,
             p.RECEIVING, p.BOD_RT3 +  NVL(pex.BOD_RT3,0) BOD_RT3, p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3,
             p.MARKED + NVL(pex.MARKED,0) MARKED,p.MARKEDCOM + NVL(pex.MARKEDCOM,0) MARKEDCOM,p.SYMBOL
      FROM PORTFOLIOS p,ACCOUNTS a, BASKETS b,PORTFOLIOSEX pex
      WHERE p.ACCTNO = p_account AND  p.ACCTNO = a.ACCTNO AND a.BASKETID = b.BASKETID AND p.SYMBOL = b.SYMBOL
         AND p.ACCTNO = pex.ACCTNO(+) AND p.SYMBOL =pex.SYMBOL(+)
    )

    LOOP
      --1. Tinh khoi luong chung khoan cua tai khoan
      v_qtty :=0;
      v_qtty := rec.TRADE - rec.SELLINGQTTY; --Chung khoan kha dung
      v_qtty := v_qtty + rec.SELLINGQTTY - rec.BOD_ST3; --Ban trong ngay chua khop
      v_qtty := v_qtty + rec.RECEIVING; --Chung khoan cho ve
      --v_qtty := v_qtty + rec.BOD_RT3; --Mua khop trong ngay
      --v_qtty := v_qtty + rec.BUYINGQTTY - rec.BOD_RT3 ; --Mua trong ngay chua khop
      v_qtty := v_qtty + rec.BUYINGQTTY;

      v_daily_room := 0;
      v_remain_room := 0;
      v_marked_qtty := rec.MARKED;
      --3. Tinh room con lai cua ma ck
      SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='SYSTEM' AND SYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
         FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='SYSTEM' AND SYMBOL=rec.SYMBOL;
      END IF;

      SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='SYSTEM' AND REFSYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
         FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='SYSTEM' AND REFSYMBOL=rec.SYMBOL;
           --Room remain thoi diem hien tai
           v_remain_room:=v_remain_room -v_daily_room;

      END IF;

      --4.Tinh min
      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_account AND REFSYMBOL=rec.SYMBOL;
      IF v_count = 0 THEN
        --Chung khoan toi da co the danh dau cua tk (bao gom so da danh dau)
        v_qtty := LEAST(v_qtty, GREATEST(v_remain_room,0) + v_marked_qtty);

      END IF;

      --5.Tinh values
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_MARGIN*rec.RATE_MARGIN/100;
    END LOOP;

    RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END;

     /*ThanhNV: Get TA cho edit order.
     Tinh gia tri tai san chung khoan theo room SYSTEM cua tieu khoan - danh cho ban MSBS
     Qi = MIN(CK, ROOM con lai)
     date: 2016-02-17, 14h
   */
  FUNCTION fn_get_system_ta_edit_order(p_account IN VARCHAR, p_delta_qtty IN NUMBER, p_symbol IN VARCHAR2)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER(20,4);
    v_qtty        NUMBER;
    v_marked_qtty NUMBER :=0;
    v_daily_room    NUMBER :=0;
    v_remain_room NUMBER :=0;
    v_daily_count NUMBER := 0;
    v_count       NUMBER := 0;
  BEGIN
    v_asset_value := 0;


    FOR rec IN --lay ck trong bang portfolios
    ( --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.TRADE,p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) SELLINGQTTY,p.BUYINGQTTY + NVL(pex.BUYINGQTTY,0) BUYINGQTTY,b.PRICE_MARGIN,b.RATE_MARGIN,
             p.RECEIVING, p.BOD_RT3 +  NVL(pex.BOD_RT3,0) BOD_RT3, p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3,
             p.MARKED + NVL(pex.MARKED,0) MARKED,p.MARKEDCOM + NVL(pex.MARKEDCOM,0) MARKEDCOM,p.SYMBOL
      FROM PORTFOLIOS p,ACCOUNTS a, BASKETS b,PORTFOLIOSEX pex
      WHERE p.ACCTNO = p_account AND  p.ACCTNO = a.ACCTNO AND a.BASKETID = b.BASKETID AND p.SYMBOL = b.SYMBOL
         AND p.ACCTNO = pex.ACCTNO(+) AND p.SYMBOL =pex.SYMBOL(+)
    )

    LOOP
      --1. Tinh khoi luong chung khoan cua tai khoan
      v_qtty :=0;
      v_qtty := rec.TRADE - rec.SELLINGQTTY; --Chung khoan kha dung
      v_qtty := v_qtty + rec.SELLINGQTTY - rec.BOD_ST3; --Ban trong ngay chua khop
      v_qtty := v_qtty + rec.RECEIVING; --Chung khoan cho ve
      --v_qtty := v_qtty + rec.BOD_RT3; --Mua khop trong ngay
      --v_qtty := v_qtty + rec.BUYINGQTTY - rec.BOD_RT3 ; --Mua trong ngay chua khop
      v_qtty := v_qtty + rec.BUYINGQTTY;

      v_daily_room := 0;
      v_remain_room := 0;
      v_marked_qtty := rec.MARKED;
      --3. Tinh room con lai cua ma ck
      SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='SYSTEM' AND SYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
         FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID='SYSTEM' AND SYMBOL=rec.SYMBOL;
      END IF;

      SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='SYSTEM' AND REFSYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
         FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD='SYSTEM' AND REFSYMBOL=rec.SYMBOL;
           --Room remain thoi diem hien tai
         v_remain_room:=v_remain_room -v_daily_room;

      END IF;

      --4.Tinh min
      IF p_symbol = rec.symbol THEN
            v_qtty := v_qtty - p_delta_qtty;
      END IF;

      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_account AND REFSYMBOL=rec.SYMBOL;
      IF v_count = 0  THEN
        --Chung khoan toi da co the danh dau cua tk (bao gom so da danh dau)
        v_qtty := LEAST(v_qtty, GREATEST(v_remain_room,0) + v_marked_qtty);

      END IF;

      --5.Tinh values
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_MARGIN*rec.RATE_MARGIN/100;
    END LOOP;

    RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END;

   /*tiendt
     Tinh gia tri tai san chung khoan cua tieu khoan - danh cho ban MSBS
     cho cong thuc rut tien
     date: 2015-12-01, 17h
   */
  FUNCTION fn_get_ta_real_ub(p_account IN varchar,
                    p_room_flag IN varchar,--Y: tinh room con lai, N: khong tinh room con lai
                    p_rate_asset_flag IN varchar, --Y : tinh them ti le tai san
                    p_roomid IN varchar)
     RETURN  NUMBER
  AS
    v_asset_value NUMBER(20,4);
    v_qtty        NUMBER;
    v_marked_qtty NUMBER;
    v_daily_room    NUMBER :=0;
    v_remain_room NUMBER :=0;
    v_daily_count NUMBER := 0;
    v_rate_margin NUMBER := 0;
    v_count       NUMBER := 0;

  BEGIN
    v_asset_value := 0;


    FOR rec IN --lay ck trong bang portfolios
    ( --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.TRADE,p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) SELLINGQTTY, p.BUYINGQTTY + NVL(pex.BUYINGQTTY,0) BUYINGQTTY ,b.PRICE_ASSET,b.RATE_ASSET,
             p.RECEIVING,p.BOD_RT3 +  NVL(pex.BOD_RT3,0) BOD_RT3, p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3,
             p.MARKED + NVL(pex.MARKED,0) MARKED, p.MARKEDCOM + NVL(pex.MARKEDCOM,0) MARKEDCOM, p.SYMBOL
      FROM PORTFOLIOS p,ACCOUNTS a, BASKETS b,PORTFOLIOSEX pex
      WHERE p.ACCTNO = p_account AND  p.ACCTNO = a.ACCTNO AND a.BASKETID = b.BASKETID AND p.SYMBOL = b.SYMBOL
      AND p.ACCTNO = pex.ACCTNO(+) AND p.SYMBOL =pex.SYMBOL(+)
    )

    LOOP
      --1. Tinh khoi luong chung khoan cua tai khoan
      v_qtty :=0;
      v_qtty := rec.TRADE - rec.SELLINGQTTY; --Chung khoan kha dung
      v_qtty := v_qtty + rec.SELLINGQTTY - rec.BOD_ST3; --Ban trong ngay chua khop
      v_qtty := v_qtty + rec.RECEIVING; --Chung khoan cho ve
      v_qtty := v_qtty + rec.BUYINGQTTY;


      --2. Tinh chung khoan da duoc danh dau

      IF p_roomid = 'UB' THEN
        v_marked_qtty := rec.MARKEDCOM;
      ELSE
        v_marked_qtty := rec.MARKED;
      END IF;

      v_daily_room := 0;
      v_remain_room := 0;
      --3. Tinh room con lai cua ma ck
      SELECT COUNT(1) INTO v_daily_count FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
         FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=rec.SYMBOL;
      END IF;

      SELECT COUNT(1) INTO v_daily_count FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=rec.SYMBOL;
      IF v_daily_count > 0 THEN
         SELECT NVL(GRANTED,0) - NVL(INUSED,0) INTO v_remain_room
         FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=rec.SYMBOL;
          --dbms_output.put_line('v_remain_room++++++++++222:' || v_remain_room);
         --v_remain_room := v_remain_room +  v_marked_qtty;

           --Room remain thoi diem hien tai
           v_remain_room:=v_remain_room -v_daily_room;

      END IF;

      --4.Tinh min
      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_account AND REFSYMBOL=rec.SYMBOL;
      IF v_count = 0 AND p_room_flag = 'Y' THEN --Y,co lay MIN voi ROOM
--        v_qtty := LEAST(v_qtty,v_remain_room - v_daily_room);
        --Chung khoan toi da co the danh dau cua tk (bao gom so da danh dau)
        v_qtty := LEAST(v_qtty, GREATEST(v_remain_room,0) + v_marked_qtty);

      END IF;

      IF p_rate_asset_flag = 'Y'  THEN
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_ASSET*rec.RATE_ASSET/100;
      ELSIF p_rate_asset_flag = 'N' THEN
        v_asset_value := v_asset_value + v_qtty * rec.PRICE_ASSET/*rec.RATE_ASSET/100*/;
      END IF;

    END LOOP;

    RETURN v_asset_value;

    EXCEPTION
      WHEN OTHERS THEN
        v_asset_value := -1; --undefined error
    END;

  FUNCTION fn_get_estimated_debt(p_account IN varchar)
       RETURN  NUMBER
    AS
      v_estimated_debt NUMBER;
      v_buy_amt NUMBER;
  BEGIN
    v_buy_amt := fn_get_buy_amt(p_account);
    SELECT BOD_PAYABLE + BOD_DEBT + v_buy_amt - BOD_BALANCE - (BOD_ADV + CALC_ADVBAL) - LEAST(BOD_TD, v_buy_amt) - BOD_T0VALUE into v_estimated_debt
    FROM ACCOUNTS WHERE ACCTNO = p_account;

    RETURN v_estimated_debt;

    EXCEPTION
        WHEN OTHERS THEN
          v_estimated_debt := -1;
  END;


    --lay suc mua co ban PP0, dung.bui add ,date 30/09/2015
--    PROCEDURE sp_get_pp0 (p_err_code in OUT VARCHAR,
--                                p_pp0 in OUT NUMBER,
--                                f_acctno IN VARCHAR,
--                                f_fomulacd IN VARCHAR,
--                f_bal IN NUMBER,
--                f_td IN NUMBER,
--                f_payable IN NUMBER,
--                f_debt IN NUMBER,
--                f_bod_adv NUMBER,
--                f_advbal IN NUMBER,
--                f_crlimit IN NUMBER,
--                f_ordamt IN NUMBER,
--                f_roomid IN VARCHAR,
--                f_rate_ub IN NUMBER,
--                p_err_msg OUT VARCHAR2
--                )
--    AS
--
--    BEGIN
--
--      --dbms_output.put_line('f_fomulacd:' || f_fomulacd);
--
--      IF f_fomulacd = 'PPSET0' THEN
--        sp_get_pp_pp0(p_err_code, p_pp0, f_ordamt, f_acctno, f_bal,
--                    0, f_td, f_payable, f_debt, 0,
--                    f_advbal,f_crlimit, 0, 0, null,f_fomulacd,f_bod_adv,f_roomid,f_rate_ub,p_err_msg);
--      ELSIF f_fomulacd = 'CASH' THEN
--        sp_get_pp_cash(p_err_code, p_pp0, f_ordamt, f_acctno, f_bal,
--                      0, f_td, f_payable, f_debt, 0,p_err_msg);
--      ELSIF f_fomulacd = 'ADV' THEN
--        sp_get_pp_adv(p_err_code, p_pp0, f_ordamt, f_acctno, f_bal,
--                      0, f_td, f_payable, f_debt, 0,f_advbal,f_bod_adv,p_err_msg);
--
--      END IF;
--    END sp_get_pp0;


    /*tiendt create for withdraw
    date: 01-12-2015
    */
    FUNCTION fn_get_rtt_ub(p_account IN varchar,
            p_balance IN NUMBER, p_adv IN NUMBER,p_debt_ub IN NUMBER)
       RETURN  NUMBER
        AS
          v_rtt_ub NUMBER;
          v_temp   NUMBER;
          v_temp2  NUMBER;
          v_ta_real_ub_noroom NUMBER;
      BEGIN
        v_ta_real_ub_noroom := fn_get_ta_real_ub(p_account,'N','N','UB');
        v_temp := p_balance + p_adv + v_ta_real_ub_noroom - p_debt_ub;
        IF v_temp = 0 THEN
          v_rtt_ub := -100000; --BO bat FO hard code
        ELSIF v_temp >0 THEN
          v_temp2 := v_ta_real_ub_noroom + GREATEST(p_balance + p_adv - p_debt_ub,0);
          IF v_temp2 != 0 THEN
             v_rtt_ub := v_temp/v_temp2;
          ELSE--mau so =0
             v_rtt_ub := -1111111;
          END IF;
        ELSIF v_temp <0 THEN
           v_rtt_ub := 0;
        END IF;

        RETURN v_rtt_ub;

        EXCEPTION
            WHEN OTHERS THEN
              v_rtt_ub := -111111111;
    END;

    PROCEDURE sp_update_status_order(p_err_code OUT VARCHAR,
            p_orderid IN VARCHAR,
            p_err_msg OUT VARCHAR2)

    AS

    v_status  VARCHAR(20);
    v_currtime TIMESTAMP;
    BEGIN
      p_err_code := 0;
      p_err_msg:='sp_update_status_order ';
      BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
      END;
      --lay thong tin bang orders
      SELECT STATUS INTO v_status FROM ORDERS WHERE ORDERID = p_orderid;
      IF (v_status = 'N') THEN-- lenh moi
        UPDATE ORDERS SET STATUS = 'B', SUBSTATUS = 'BB',LASTCHANGE = v_currtime WHERE ORDERID = p_orderid;
      ELSIF (v_status = 'D' OR v_status = 'E') THEN -- lenh huy/sua
        UPDATE ORDERS SET SUBSTATUS = 'BB',LASTCHANGE = v_currtime WHERE ORDERID = p_orderid;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_update_status_order '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_update_status_order;

END CSPKS_FO_COMMON;
/



-- End of DDL Script for Package Body FOTEST.CSPKS_FO_COMMON

