CREATE OR REPLACE PACKAGE CSPKS_FO_MAIN_TEST
AS
  --PROCEDURE main1 (p_err_code in OUT NUMBER);
  PROCEDURE main_order_sell(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_mortage_sell(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_total_sell(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_cancel_order(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_edit_sell_order_HNX(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_edit_buy_order_HNX(
      p_err_code IN OUT NUMBER) ;
  PROCEDURE main_edit_sell_order_HSX(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_edit_buy_order_HSX(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_order_trading(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_proces_order_confirm(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_markroom(
      p_err_code IN OUT NUMBER) ;
  PROCEDURE main_call_function(
      p_err_code IN OUT NUMBER);
  PROCEDURE AAA_main_dung(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_order_test(
      msg IN VARCHAR2);
  PROCEDURE main_order_buy(
      msg IN VARCHAR2);
  PROCEDURE main_test_2b(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_test_2c(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_test_fn_get_buy_amt(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_test_2d(
      p_err_code IN OUT NUMBER);
  PROCEDURE main_test_HNX_confirm_order(
      p_err_code IN OUT NUMBER) ;
  PROCEDURE main_test_HNX_trade(
      p_err_code IN OUT NUMBER);

PROCEDURE sp_get_order_all_info ( --tx6005
    f_userid IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR,
    f_seqnum IN OUT VARCHAR
  );

END CSPKS_FO_MAIN_TEST;
/


CREATE OR REPLACE PACKAGE BODY CSPKS_FO_MAIN_TEST
AS
  --    PROCEDURE main1(p_err_code in OUT NUMBER)
  --      AS
  --       v_balance         NUMBER(20,2);
  --       v_currdate date;
  --      BEGIN
  --      --declare
  --      --temp varchar(20);
  ----      orderid varchar(20);
  ----      symbol varchar(20);
  ----      v_test varchar(20);
  ----      temp_qtty number;
  --
  --
  ----      CURSOR c_customers is
  ----         SELECT A.symbol,A.trade, A.sellingqtty,A.buyingqtty,B.price_asset,B.rate_asset
  ----            FROM portfolios A,baskets B,accounts C
  ----            WHERE A.acctno = '0001000006' AND C.basketid=B.basketid AND A.symbol = B.symbol and A.acctno=C.acctno;
  ----
  ----        --SELECT * FROM portfolios WHERE acctno = '0001000006';
  ----        type c_list is varray (100) of portfolios.symbol%type;
  ----       name_list c_list := c_list();
  ----       counter integer :=0;
  ----      begin
  ----       dbms_output.enable;
  ----
  ----      UPDATE ACCOUNTS SET CALC_ADVBAL = 54444 WHERE ACCTNO='0001000001';
  ----      plog.debug('tai khoan khong ton tai');
  --
  --
  ----     dbms_output.put_line('counter:' || counter);
  ----      WHILE counter < 10
  ----      LOOP
  ----        counter := counter + 1;
  ----
  ----        dbms_output.put_line('counter:' || counter);
  ----      END LOOP;
  --
  --    --    CSPKS_FO_POOLROOM.sp_process_checkroom(temp,
  --    --    '0001000006',--so TK
  --    --    10100000000,--so chung tu BO
  --    --    20,
  --    --    30,
  --    --    40,
  --    --    10,
  --    --    10,10
  --    --    );
  --    --
  --    --     dbms_output.enable;
  --    --     dbms_output.put_line('xin chao');
  --    --     dbms_output.put_line('ouput:' || temp);
  --
  --
  ----        FOR n IN c_customers LOOP
  ----          counter := counter + 1;
  ----          name_list.extend;
  ----          name_list(counter)  := n.symbol;
  ----          dbms_output.put_line('Customer('||counter ||'):'||name_list(counter));
  ----       END LOOP;
  --    --
  --    --    FOR rec IN
  --    --      (
  --    --        SELECT * FROM portfolios WHERE acctno = '0001000006'
  --    --      )
  --    --      LOOP
  --    --        --update afmast set advanceline = rec.amount where acctno = rec.acctno;
  --    --        symbol := rec.symbol;
  --    --         plog.info('55555:');
  --    --      END LOOP;
  --
  --        --dbms_output.enable;
  --        --dbms_output.put_line('Error Code:' || temp);
  --        --commit;
  --
  --      end;
  -- END main1;
  PROCEDURE main_order_sell(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      v_symbol  VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
      v_bodqtty NUMBER;
      v_count   NUMBER;
    BEGIN
      dbms_output.enable;
      --        main_order_test('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      --        begin
      --          select count(1) into v_count from portfolios where acctno = '0001000001' and symbol = 'abc';
      --          dbms_output.put_line('Thuc hien Update');
      --           EXCEPTION
      --           WHEN OTHERS THEN
      --            dbms_output.put_line('Thuc hien Insert');
      --          end;
      --
      --           dbms_output.put_line('================');
      --
      --          begin
      --            select symbol into v_symbol from portfolios where acctno = '0001000001' and symbol = 'abc';
      --            dbms_output.put_line('no Error2');
      --             EXCEPTION
      --             WHEN OTHERS THEN
      --              dbms_output.put_line('Error2');
      --          end;
      --       SELECT NVL(TRADE,0)+NVL(MORTGAGE,0) INTO v_bodqtty
      --      FROM PORTFOLIOS WHERE ACCTNO='6811920016' AND SYMBOL='III';
      --         dbms_output.put_line('v_bodqtty:' || v_bodqtty);
      --          --ban thuong
      CSPKS_FO_ORDER_NEW.sp_process_order_sell(temp, orderid, '201412110000159948', --quoteid
      '0001000015',                                                                 --so TK
      'SSI',                                                                        --ma chung khoan
      2000,                                                                         --khoi luong
      30000,                                                                        --gia ban
      '123',                                                                        --userid
      'LO',                                                                         --loai lenh
      'CNT',                                                                        --phien giao dich
      'LO', '');
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      --        commit;
    END;
  END main_order_sell;
  PROCEDURE main_order_test(
      msg IN VARCHAR2)
  AS
    v_currdate DATE;
  BEGIN
    DECLARE
      temp VARCHAR(20);
    BEGIN
      dbms_output.enable;
      dbms_output.put_line('msg:' || msg);
    END;
  END main_order_test;
  PROCEDURE main_order_buy(
      msg IN VARCHAR2)
  AS
    v_currdate DATE;
  BEGIN
    DECLARE
      temp1 VARCHAR(20);
      temp2 NUMBER;
      temp3 VARCHAR(20);
    BEGIN
      dbms_output.enable;
      dbms_output.put_line('===============');
      CSPKS_FO_ORDER_NEW.sp_process_order_buy(temp1,temp2,temp3,100,14000,'201510060002229267');
      dbms_output.put_line('ERRORCODE==========:' || temp1);
       commit;
      --ROLLBACK;
    END;
  END main_order_buy;
  PROCEDURE main_mortage_sell(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      --ban thuong
      CSPKS_FO_ORDER_NEW.sp_proces_mortage_sell(temp, orderid, '12345', --quoteid
      '0001000005',                                                     --so TK
      'AGM',                                                            --ma chung khoan
      1000,                                                             --khoi luong
      10,                                                               --gia ban
      '123',                                                            --userid
      'LO',                                                             --loai lenh
      'CNT',                                                            --phien giao dich
      'LO', '2014-08-06');
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      COMMIT;
    END;
  END main_mortage_sell;
  PROCEDURE main_total_sell(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      --ban tong
      CSPKS_FO_ORDER_NEW.sp_proces_total_sell(temp, orderid, '12345', --quoteid
      '0001000001',                                                   --so TK
      'FPT',                                                          --ma chung khoan
      51000,                                                          --khoi luong
      52000,                                                          --gia ban
      '0001',                                                         --userid
      'LO',                                                           --loai lenh
      'OPN',                                                          --phien giao dich
      'LO', '2014-08-06');
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
    END;
  END main_total_sell;
  PROCEDURE main_markroom(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      dbms_output.enable;
      --mark rooom
      CSPKS_FO_POOLROOM.sp_process_markroom(temp, '0001000006',--so TK
      1000,                                                    --p_amount
      1000,                                                    --p_balance
      0,                                                       --p_advbal
      0,                                                       --p_payable
      0,                                                       --p_debt
      0,                                                       --p_odramt
      0,                                                       --td
      '12345',                                                 --orderid
      'S',                                                     --side
      'SSI',                                                   --ma chung khoan
      'A'                                                      --ma nhom chinh sach
      );
      dbms_output.put_line('Error Code:' || temp);
      COMMIT;
    END;
  END main_markroom;
  PROCEDURE main_cancel_order(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_CANCEL.sp_proces_cancel_order(temp, orderid, '201504020001875653',--so hieu lenh de huy
      '0001000008',                                                                    --so TK
      'CNT',                                                                           --phien giao dich
      '123',                                                                           --userid
      '201504020002178651'                                                             --quoteid
      );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
      --commit;
    END;
  END main_cancel_order;
  PROCEDURE main_edit_sell_order_HNX(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_AMEND.sp_proces_edit_sell_order_HNX(temp, orderid, '201412040000059113',--so hieu lenh de sua
      '201412040000159368',                                                                  --so TK
      'ACB',                                                                                 --ma chung khoan
      600,                                                                                   --khoi luong
      temp_qtty, 14000,                                                                      --gia sua
      'CNT',                                                                                 --phien giao dich
      '201412040000159366',                                                                  --quoteid
      '123',                                                                                 --userid
      '2014-08-06' );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
      --commit;
    END;
  END main_edit_sell_order_HNX;
  PROCEDURE main_edit_buy_order_HNX(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_AMEND.sp_proces_edit_order(temp, orderid, '201411030000021683',--so hieu lenh de sua
      '0001000020',                                                                 --so TK
      'ACB',                                                                        --ma chung khoan
      'HNX', 'AB', 700,                                                             --khoi luong
      temp_qtty, 14000,                                                             --gia sua
      NULL,                                                                         --phien giao dich
      '201411030000022609',                                                         --quoteid
      '0001',                                                                       --userid
      '2014-10-30' );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
    END;
  END main_edit_buy_order_HNX;
  PROCEDURE main_edit_sell_order_HSX(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_AMEND.sp_proces_edit_order(temp, orderid, '201409300000006989',--so hieu lenh de sua
      '0001000006',                                                                 --so TK
      'SSI',                                                                        --ma chung khoan
      'HSX', 'S', 500,                                                              --khoi luong
      temp_qtty, 15,                                                                --gia sua
      'CNT',                                                                        --phien giao dich
      '12345',                                                                      --quoteid
      '123',                                                                        --userid
      '2014-08-06' );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      COMMIT;
    END;
  END main_edit_sell_order_HSX;
  PROCEDURE main_edit_buy_order_HSX(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_AMEND.sp_proces_edit_order(temp, orderid, '201509300002816388',--so hieu lenh de sua
      '0001000080',                                                                 --so TK
      'SSI',                                                                        --ma chung khoan
      'HSX', 'AB', 2000,                                                             --khoi luong
      temp_qtty, 24500,                                                             --gia sua
      NULL,                                                                         --phien giao dich
      '201509300002228715',                                                         --quoteid
      '123',                                                                        --userid
      '2014-08-06' );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
    END;
  END main_edit_buy_order_HSX;
  PROCEDURE main_order_trading(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(temp, '201412300000072893', --so hieu lenh
      '0001000089',                                                              --so TK
      100,                                                                       --khoi luong
      14000,                                                                     --gia khop
      'ex12345',                                                                 --so hieu xac nhan tu so
      '2014-08-06' );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      --commit;
      ROLLBACK;
    END;
  END main_order_trading;
  PROCEDURE main_proces_order_confirm(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      orderid   VARCHAR(20);
      symbol    VARCHAR(20);
      v_test    VARCHAR(20);
      temp_qtty NUMBER;
    BEGIN
      CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(temp, '201504020001875658', --so hieu lenh
      '22222',                                                                   --so hieu xac nhan tu so
      'S',                                                                       --Trang thai
      '2014-08-06' );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
      --commit;
    END;
  END main_proces_order_confirm;
  
  PROCEDURE main_call_function(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      v_custodycd         VARCHAR2(20);
      v_currdate          DATE;
      v_sesionex          VARCHAR2(6);
      v_currtime          TIMESTAMP;
      v_acctno            VARCHAR2(20);
      v_side              VARCHAR2(6);
      v_symbol            VARCHAR2(20);
      v_userid            VARCHAR2(20);
      v_typecd            VARCHAR2(6);
      v_subtypecd         VARCHAR2(6);
      v_formulacd         VARCHAR2(10);
      v_ratebrk           NUMBER;
      v_ratebrk_s         NUMBER;
      v_ratebrk_b         NUMBER;
      v_pp                NUMBER;
      v_order_value       NUMBER;
      v_balance           NUMBER;
      v_t0value           NUMBER;
      v_td                NUMBER;
      v_payable           NUMBER;
      v_debt              NUMBER;
      v_advbal            NUMBER;
      v_crlimit           NUMBER;
      v_rate_tax          NUMBER;
      v_rate_buy          NUMBER;
      v_rate_adv          NUMBER;
      v_basketid          VARCHAR(60);
      v_rate_margin       NUMBER;
      v_price_margin      NUMBER;
      v_price_asset       NUMBER;
      v_ordamt            NUMBER;
      v_buying            NUMBER;
      v_policycd          VARCHAR(20);
      v_cficode           VARCHAR(6);
      v_poolid            VARCHAR(10);
      v_roomid            VARCHAR(10);
      v_count             NUMBER;
      v_countNo           NUMBER;
      v_countBasket       NUMBER;
      v_txdate            VARCHAR(20);
      v_exchange          VARCHAR(6);
      v_status            VARCHAR(3);
      v_substatus         VARCHAR(3);
      p_balance           NUMBER;
      p_pp                NUMBER;
      p_cash_pending_send NUMBER;
      v_bod_adv           NUMBER;
      v_rate_ub           NUMBER;
    BEGIN
      --      dbms_output.enable;
      --      temp_qtty := LEAST(50,30);
      --      dbms_output.put_line('temp_qtty:' || temp_qtty);
      --      temp_qtty := GREATEST(0,100 - 600);
      --      dbms_output.put_line('temp_qtty:' || temp_qtty);
      --        --LEAST(v_pp_security_amt, p_crlimit) - p_debt - GREATEST(0,v_exec_buy_amt - p_bod_td);
      --      --temp_qtty := CSPKS_FO_COMMON.fn_get_buy_amt('0001000006');
      --      SELECT BOD_BALANCE, BOD_DEBT,CALC_ADVBAL,BOD_PAYABLE,CALC_ODRAMT,POLICYCD,BOD_TD,bod_crlimit
      --            INTO v_balance,v_debt,v_advbal,v_payable,v_odramt,v_policycd,v_td,v_bod_crlimit
      --            FROM ACCOUNTS
      --            WHERE ACCTNO = '0001000005';
      --temp_qtty := CSPKS_FO_COMMON.fn_get_avl_balance('0001000005',v_balance,v_advbal,v_payable,v_debt,v_td,v_bod_crlimit);
      --temp_qtty := CSPKS_FO_COMMON.fn_get_asset('0001000005');
      --dbms_output.put_line('Tien toi da co the rut:' || temp_qtty);
      v_acctno := '0001022216';
      SELECT FORMULACD,RATE_BRK_S,RATE_BRK_B,RATE_ADV,RATE_TAX,BOD_BALANCE,BOD_T0VALUE,BOD_TD,BOD_PAYABLE,
        BOD_DEBT,BOD_ADV,CALC_ADVBAL,BOD_CRLIMIT,BASKETID,CALC_ODRAMT,POOLID,ROOMID,CUSTODYCD,RATE_UB
      INTO v_formulacd, v_ratebrk_s,v_ratebrk_b,v_rate_adv,v_rate_tax,v_balance,
        v_t0value,v_td, v_payable,v_debt,v_bod_adv,v_advbal,v_crlimit, v_basketid,
        v_ordamt,v_poolid,v_roomid, v_custodycd,v_rate_ub
      FROM ACCOUNTS
      WHERE ACCTNO = v_acctno;
      
        CSPKS_FO_COMMON.sp_get_pp(p_err_code,v_pp,v_acctno, v_formulacd, v_balance,
      v_t0value,
      v_td,
      v_payable,
      v_debt,
      0.25,--v_ratebrk,
      v_bod_adv,
      v_advbal,
      v_crlimit,
      20,--rate_margin
      3300,--v_price_margin
      3000,--f_price
      v_basketid,
      v_ordamt,
      v_roomid,v_rate_ub,
      'DCS');
              
      dbms_output.put_line('v_pp=====:' || v_pp); 
      /*   CSPKS_FO_ACCOUNT.sp_get_summary_info (
      12000,--f_price IN NUMBER,
      'KLS',--f_symbol IN VARCHAR,
      p_err_code,-- OUT VARCHAR,
      v_acctno,--p_acctno IN OUT VARCHAR,
      p_balance,-- OUT NUMBER,
      p_pp,-- OUT NUMBER,
      p_cash_pending_send);-- OUT NUMBER
      dbms_output.put_line('p_pp:' || p_pp); */
      --commit;
      ROLLBACK;
    END;
  END main_call_function;
--============================================================================
  PROCEDURE AAA_main_dung(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp    VARCHAR(20);
      orderid VARCHAR(20);
    BEGIN
      --      dbms_output.enable();
      CSPKS_FO_TRANS.sp_decrease_money(temp, '0001000094', --so tai khoan
      '12345',                                             --so hieu xu li cua FO
      200000                                               -- so tien
      );
      dbms_output.put_line('Error Code:' || temp);
      ROLLBACK;
      --plog.info('ouput:' || temp);
    END;
  END AAA_main_dung;
--Xac nhan lenh
  PROCEDURE main_test_2b(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      p_orderid VARCHAR(20);
    BEGIN
      CSPKS_FO_GW_HSX.sp_proces_msg_2b(temp, '123', --firm
      '00000092',                                   --orderid
      '2014-08-06', p_orderid );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      --rollback;
      COMMIT;
    END;
  END main_test_2b;
--Xac nhan huy
  PROCEDURE main_test_2c(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp          VARCHAR(20);
      p_orderid     VARCHAR(20);
      p_new_orderid VARCHAR(20);
    BEGIN
      CSPKS_FO_GW_HSX.sp_proces_msg_2c(temp, p_new_orderid, '123', --firm
      1000,                                                        --Khoi luong huy
      '00008549',                                                  --orderid, --truong rootorderid
      '', 'S', p_orderid                                         ----So hieu lenh cua cong ty chung khoan
      );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      IF temp = '0' THEN
        --commit;
        dbms_output.put_line('p_orderid :' || p_orderid);
      END IF;
      ROLLBACK;
    END;
  END main_test_2c;
--khop lenh
  PROCEDURE main_test_2d(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      p_orderid VARCHAR(20);
    BEGIN
      CSPKS_FO_GW_HSX.sp_proces_msg_2d(temp, NULL, --firm
      '00000116',                                  --orderid
      '12/12/2014',                                --p_orderentrydate
      '060',                                       --p_clientid_alph
      'C',                                         --p_port_clientflag_alph
      100,                                         --qtty
      28200,                                       --price
      '',                                          --p_filler
      p_orderid );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      --rollback;
      --if  temp = '0' then
      --commit;
      --end if;
      ROLLBACK;
    END;
  END main_test_2d;
--xac nhan lenh lenh
  PROCEDURE main_test_HNX_confirm_order(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp      VARCHAR(20);
      p_orderid VARCHAR(20);
    BEGIN
      CSPKS_FO_GW_HNX.sp_proces_msg_confirm_order(temp, NULL, --p_MsgSeqNum
      'S',                                                    --p_OrdStatus
      --SEQ_HNX_ORDERID.NEXTVAL,--p_OrderID
      '23454', '12/12/2004',--p_TransactTime
      '201412190000067466', --p_ClOrdID, so hieu lenh cua cong ty ck
      'ACB',                --p_Symbol
      NULL,                 --p_Side
      NULL, NULL, NULL, NULL );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      --rollback;
      IF temp = '0' THEN
        COMMIT;
      END IF;
      --rollback;
    END;
  END main_test_HNX_confirm_order;
--khop lenh
  PROCEDURE main_test_HNX_trade(
      p_err_code IN OUT NUMBER)
  AS
    v_balance  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp       VARCHAR(20);
      p_orderid  VARCHAR(20);
      p_LastPx   NUMBER;
      v_price    NUMBER;
      v_price_ce NUMBER;
      v_price_fl NUMBER;
    BEGIN
      p_LastPx  := 14000;
      v_price_ce:= 15000;
      --v_price := nvl(0,p_LastPx + 100);
      dbms_output.put_line('v_price :' || v_price);
      v_price := LEAST(p_LastPx, v_price_ce);
      dbms_output.put_line('v_price :' || v_price);
      v_price := NVL(0,p_LastPx - 100);
      v_price := GREATEST(v_price, v_price_fl);
      --      CSPKS_FO_GW_HNX.sp_proces_msg_respone_trade(temp,
      --         null, --p_MsgSeqNum
      --         null,  --p_OrdStatus
      --         null,--p_ClOrdID
      --         null,--p_OrigClOrdID
      --         null,--p_SecondaryClOrdID
      --         '201412290000072441',
      --         '2014-05-12 15:22:22',--p_TransactTime
      --         500,--khoi luong khop lenh
      --         6500,--Gia khop lenh,
      --         null,--p_ExecID
      --         null,--p_Side
      --         'CMC'--p_Symbol
      --        );
      dbms_output.enable;
      dbms_output.put_line('Error Code:' || temp);
      --rollback;
      --if  temp = '0' then
      --commit;
      --end if;
      --rollback;
    END;
  END main_test_HNX_trade;
  PROCEDURE main_test_fn_get_buy_amt(
      p_err_code IN OUT NUMBER)
  AS
    v_buy_amt  NUMBER(20,2);
    v_currdate DATE;
  BEGIN
    DECLARE
      temp          VARCHAR(20);
      p_orderid     VARCHAR(20);
      p_new_orderid VARCHAR(20);
    BEGIN
      v_buy_amt := CSPKS_FO_COMMON.fn_get_buy_amt('0001000003');
      dbms_output.enable;
      dbms_output.put_line('v_buy_amt:' || v_buy_amt);
      ROLLBACK;
    END;
  END main_test_fn_get_buy_amt;
 
PROCEDURE sp_get_order_all_info ( --tx6005
    f_userid IN VARCHAR,
    p_recordset OUT SYS_REFCURSOR,
    p_err_code OUT VARCHAR,
    f_seqnum IN OUT VARCHAR
  ) AS
  v_via VARCHAR(100);
  v_fullname VARCHAR(100);
  v_custcd VARCHAR(100);
  v_max_seqnum VARCHAR(100);
  v_count NUMBER;
  
  BEGIN
   p_err_code := '0';
   
--   OPEN p_recordset FOR SELECT * FROM ORDERS WHERE 1=0;
    
   SELECT COUNT(*) INTO v_count FROM ORDERS WHERE USERID = f_userid;
   IF (v_count = 0) THEN 
      p_err_code := 'ERA5014';
      OPEN p_recordset FOR SELECT 1 FROM DUAL;
     RETURN;
   END IF;
   
   BEGIN
       
     SELECT ords.CUSTODYCD INTO v_custcd FROM ORDERS ords WHERE  ords.USERID = f_userid AND ROWNUM <=1;
     SELECT quo.VIA INTO v_via FROM QUOTES quo WHERE quo.USERID = f_userid AND ROWNUM <=1;
     SELECT cust.FULLNAME INTO v_fullname FROM CUSTOMERS cust WHERE cust.CUSTODYCD = v_custcd AND ROWNUM <=1;
     SELECT MAX(to_number(to_char(lastchange, 'yyyymmddhh24missFF'))) INTO v_max_seqnum FROM orders WHERE (USERID = f_userid) ;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      OPEN p_recordset FOR SELECT 1 FROM DUAL;
      p_err_code := 'ERA5014';
      RETURN;
   END;
   
   OPEN p_recordset FOR  
      SELECT 
        ord.TXDATE, ord.CUSTODYCD, ord.ACCTNO, 
        ord.SYMBOL, ord.TIME_SEND, ord.SUBSIDE,
         (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0
               THEN ord.STATUS || ord.SUBSTATUS
               ELSE ord.STATUS || ord.SUBSTATUS || ' ' || ord.EXEC_QTTY || '/' || ord.QUOTE_QTTY
         END) AS  STATUS,
        ord.SUBTYPECD, v_via AS VIA, 
        v_fullname AS FULLNAME, ord.QUOTE_QTTY, ord.QUOTE_PRICE, 
        ord.EXEC_QTTY, ord.EXEC_AMT, ord.REMAIN_QTTY, 
        ord.CANCEL_QTTY, ord.ADMEND_QTTY, ord.ORDERID, ord.EXEC_AMT,
        ord.SUBSTATUS AS SUBSTATUS,
        (CASE WHEN ord.EXEC_QTTY IS NULL OR ord.EXEC_QTTY = 0
              THEN 0
              ELSE (ord.EXEC_AMT / ord.EXEC_QTTY) 
        End) AS EXECPRICE,
        (CASE WHEN ord.RATE_BRK IS NULL THEN 0 ELSE ord.RATE_BRK END) AS FEERATE,
        (CASE WHEN ord.RATE_BRK IS NULL THEN 0 ELSE ord.RATE_BRK END) AS FEEAMT,
        (CASE WHEN ((ord.SUBSTATUS = 'SS' OR ord.SUBSTATUS = 'EC' OR ord.SUBSTATUS = 'ES') AND (ord.SUBTYPECD = 'LO')) OR (ord.SUBSTATUS = 'NN')  
              THEN 'Y' 
              ELSE 'N'
        End) AS ISAMEND,
        (CASE WHEN ((ord.SUBSTATUS = 'SS' OR ord.SUBSTATUS = 'EC' OR ord.SUBSTATUS = 'ES') AND (ord.SUBTYPECD = 'LO')) OR (ord.SUBSTATUS = 'NN')  
              THEN 'Y' 
              ELSE 'N'
        End) AS ISCANCEL,
        (CASE WHEN ord.REFORDERID IS NULL THEN '' ELSE ord.REFORDERID END) AS ROOTORDER,
        'N' AS ISDISPOSAL,
        ord.REMAIN_QTTY * ord.QUOTE_PRICE AS REMAINAMT
        ,v_max_seqnum AS SEQNUM
        ,ord.LASTCHANGE AS LASTCHANGE
        ,instr.BOARD AS TRADEPLACE
        ,ord.ORDERID AS FOACCTNO
       -- ,ord.STATUS || ord.SUBSTATUS AS ORSTATUSVALUE -- anhht s?a
       ,(case 
            when (ord.SUBSTATUS = 'RR' or ord.SUBSTATUS = 'DN' or ord.SUBSTATUS = 'EN') then '0' 
            when ((ord.SUBSTATUS = 'SS' and ord.EXEC_QTTY = 0) or ord.SUBSTATUS = 'DC' or ord.SUBSTATUS = 'EC') then '2'
            when (ord.SUBSTATUS = 'DD' or ord.SUBSTATUS = 'DS') then '3'
            when (ord.SUBSTATUS = 'SE') then 'A'
            when (ord.SUBSTATUS = 'SS' and ord.EXEC_QTTY > 0 and ord.REMAIN_QTTY > 0) then '4'
            when (ord.SUBSTATUS = 'FF') then '5'
            when (ord.SUBSTATUS = 'SD' or ord.SUBSTATUS = 'DE') then 'C'
            when (ord.SUBSTATUS = 'NN') then '8'
            when (ord.SUBSTATUS = 'EE' or ord.SUBSTATUS = 'ES') then '10'
            when (ord.SUBSTATUS = 'BB') then '11'
            when (ord.SUBSTATUS = 'SS' and ord.REMAIN_QTTY = 0) then '12'
         end) as ORSTATUSVALUE -- end anhht
      FROM ORDERS ord, INSTRUMENTS instr
      
      WHERE (ord.USERID = f_userid)
      AND f_seqnum < (to_number(to_char(lastchange, 'yyyymmddhh24missFF')))
      AND ord.SYMBOL = instr.SYMBOL
      AND ord.STATUS || ord.SUBSTATUS IN ('NNN','BBB','SSS','SSD','DDD','SSE','EEE','EBB','EES','EEN','FFF','MMM')
      AND ord.NORB NOT IN ('B');
      
      
      EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
          p_err_code := 'ERA5014';
          OPEN p_recordset FOR SELECT 1 FROM DUAL;
   
  END sp_get_order_all_info;
  

END CSPKS_FO_MAIN_TEST;
/
