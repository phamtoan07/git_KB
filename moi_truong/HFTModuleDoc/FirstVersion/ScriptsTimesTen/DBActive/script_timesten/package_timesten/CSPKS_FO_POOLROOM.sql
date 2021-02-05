CREATE OR REPLACE 
PACKAGE cspks_fo_poolroom
  AS
    --FUNCTION FC_TRANS_CHECKROOM(ACCTNO IN VARCHAR2, AMOUNT IN NUMBER) RETURN VARCHAR2;
    
    FUNCTION fn_get_using_pool( p_err_code in OUT VARCHAR, p_trans_amount IN NUMBER,p_balance IN NUMBER,p_advbal IN NUMBER,p_payable IN  NUMBER,p_debt IN  NUMBER,p_odramt IN  NUMBER,p_td IN  NUMBER,p_t0value IN  NUMBER,p_err_msg OUT VARCHAR2) RETURN  NUMBER;
    FUNCTION fn_get_release_pool( p_err_code in OUT VARCHAR, p_trans_amount IN NUMBER,p_balance IN NUMBER,p_advbal IN NUMBER,p_payable IN  NUMBER,p_debt IN  NUMBER,p_odramt IN  NUMBER,p_td IN  NUMBER,p_t0value IN  NUMBER,p_err_msg OUT VARCHAR2) RETURN  NUMBER;
    
    FUNCTION fn_get_Si(p_symbol IN VARCHAR, p_roomid IN VARCHAR) RETURN  NUMBER;
    FUNCTION fn_get_Qi(p_symbol IN VARCHAR, p_roomid IN VARCHAR) RETURN  NUMBER;
    FUNCTION fn_get_Ri(p_symbol IN VARCHAR, p_roomid IN VARCHAR) RETURN  NUMBER;
    FUNCTION fn_get_markable_asset(p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_symbol IN VARCHAR, p_incr_qtty IN NUMBER, p_err_msg OUT VARCHAR2) RETURN NUMBER;
    FUNCTION fn_get_estimated_debt(p_acctno IN VARCHAR, 
                p_derm_ord_amt IN NUMBER,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv  IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_incr_ord_amt IN NUMBER,
                p_bod_t0value IN NUMBER, 
                p_err_msg OUT VARCHAR2) RETURN NUMBER;
    FUNCTION fn_get_marked_asset(p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_basketid IN VARCHAR, p_own_basketid IN VARCHAR, p_err_msg OUT VARCHAR2) RETURN NUMBER;
    PROCEDURE sp_get_markable_symbols(c_considered_symbols OUT SYS_REFCURSOR, p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_basketid IN VARCHAR, p_err_msg OUT VARCHAR2);
    PROCEDURE sp_get_releasable_symbols(c_releasable_symbols OUT SYS_REFCURSOR, p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_basketid IN VARCHAR, p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_markroom_v3(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
                p_orderid IN VARCHAR, --so hieu lenh
                p_side IN VARCHAR, --mua/ban
                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN NUMBER,
                p_roomid in VARCHAR, --ma room
                p_err_msg OUT VARCHAR2
                );
    PROCEDURE sp_process_checkroom_v3(p_err_code in OUT VARCHAR, 
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_derm_ord_amt IN NUMBER,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_incr_ord_amt IN NUMBER,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_checkownroom(p_err_code in OUT VARCHAR,
                p_roomid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_checkroom_v4(p_err_code in OUT VARCHAR, 
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_derm_ord_amt IN NUMBER,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_incr_ord_amt IN NUMBER,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_markroom_v4(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_basketid IN VARCHAR,
                p_own_basketid IN VARCHAR,
                p_bod_payable IN  NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN  NUMBER,
                p_sell_amt IN  NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv  IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN  NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_markownroom(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_markroom_v5(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_releaseroom_v3(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_basketid IN VARCHAR,
                p_own_basketid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_releaseownroom(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_decr_qtty IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2);
    PROCEDURE sp_process_releaseroom_v4(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_symbol IN VARCHAR,
                p_decr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2);
    
    PROCEDURE sp_process_checkpool(p_err_code in OUT VARCHAR,
                f_poolid IN VARCHAR, --ma pool              
                p_pool_amt IN  NUMBER, --So tien dung them pool
                p_err_msg OUT VARCHAR2);
                
    PROCEDURE sp_process_checkroom(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua               
                p_symbol IN VARCHAR,
                p_err_msg OUT VARCHAR2
                );
    
    --Check room dua tren chung khoan mua
    PROCEDURE sp_process_checkroom_v2(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_roomid IN VARCHAR, --roomid               
                p_symbol IN VARCHAR,
                p_price NUMBER,
                p_qtty OUT NUMBER, --khoi luong danh dau
                p_err_msg OUT VARCHAR2);
                
    PROCEDURE sp_process_markpool(p_err_code in OUT NUMBER,
                                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                                p_acctno in VARCHAR, --so tieu khoan giao dich                              
                                f_poolid IN VARCHAR, --ma pool  
                                p_amount in NUMBER, --so tien dung pool
                                p_qtty in NUMBER, --khoi luong chung khoan
                                p_price in NUMBER, --gia
                                p_err_msg OUT VARCHAR2
                );
                
    PROCEDURE sp_process_markroom(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan                               
                                p_roomid in VARCHAR --ma room           
                ,
                p_err_msg OUT VARCHAR2
                );
                
    PROCEDURE sp_process_markroom_v2(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban                    
                                p_roomid in VARCHAR, --ma room
                p_symbol in VARCHAR, --ma ck
                p_qtty in VARCHAR --khoi luong danh dau        
                ,
                p_err_msg OUT VARCHAR2
                );
                
    PROCEDURE sp_process_releasepool(p_err_code in OUT NUMBER,
                                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                                p_acctno in VARCHAR, --so tieu khoan giao dich                              
                                p_poolid in VARCHAR, --ma pool
                                p_amount in NUMBER, --so tien dung pool
                                p_qtty in NUMBER, --khoi luong chung khoan
                                p_price in NUMBER --gia
                ,
                p_err_msg OUT VARCHAR2
                );
                
    PROCEDURE sp_process_releaseroom(p_err_code in OUT VARCHAR,
                p_orderid in VARCHAR, --so hieu lenh
                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan                                       
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_roomid in VARCHAR, --ma room
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER --tien tiet kiem cong vao suc mua
                ,
                p_err_msg OUT VARCHAR2);
                
    PROCEDURE sp_process_releaseroom_v2(p_err_code in OUT VARCHAR,
                p_orderid in VARCHAR, --so hieu lenh
                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan                                       
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_roomid in VARCHAR, --ma room
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_qtty NUMBER, --khoi luong
                p_price NUMBER --gia
                ,
                p_err_msg OUT VARCHAR2);
              
      PROCEDURE sp_get_marked_asset(p_err_code in OUT VARCHAR,
            p_account IN VARCHAR, --so tieu khoan giao dich
            p_amount IN OUT NUMBER --gia tri tai san dang danh dau cua tieu khoan
            ,
                p_err_msg OUT VARCHAR2);  
                
END CSPKS_FO_POOLROOM;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_poolroom AS
      --create type num_array as table of number;
          --TYPE p_type IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
          type num_array is table of number;
      --CREATE OR REPLACE TYPE numarray AS VARRAY(200) OF NUMBER;


--    FUNCTION FC_TRANS_CHECKROOM (ACCTNO IN VARCHAR2, AMOUNT IN NUMBER)
--    RETURN VARCHAR2
--    IS
--      V_PROPERTY number; -- gia tri tai san quy doi.--
--      v_acctno varchar2(10);
--      V_PRICE NUMBER;
--      V_FLOOR NUMBER;
--      V_CEIL NUMBER;
--      V_DEBT NUMBER;
--      BALANCE NUMBER;
--      ADV NUMBER;
--      V_PROPERTY_DEBT NUMBER;
--      BUYAMT NUMBER;
--      V_AMOUNT NUMBER;
--      V_OUTPUT VARCHAR2(15);
--    BEGIN
--    v_acctno:=ACCTNO;
--    V_AMOUNT:=AMOUNT;
--    V_OUTPUT:='KHONG DU ROOM';
--    -- Tinh so tong tai san quy doi --
--    SELECT SUM (RATE_BUY*PRICE_ASSET*QUANTITY) INTO V_PROPERTY
--    FROM (SELECT REFSYMBOL,RATE_BUY,PRICE_ASSET, CASE
--                        WHEN REMAIN > TOTAL THEN TOTAL
--                        ELSE REMAIN
--                        END QUANTITY
--      FROM ( SELECT P.REFSYMBOL,(P.GRANTED - P.INUSED ) REMAIN, T.TOTAL, T.RATE_BUY,T.PRICE_ASSET
--              FROM POOLROOM P, (SELECT P.SYMBOL, (P.TRADE + P.MORTGAGE) TOTAL,AC.BASKETID, B.RATE_BUY, B.PRICE_ASSET
--                                FROM PORTFOLIOS P,ACCOUNTS AC, BASKETS B
--                                WHERE P.ACCTNO = v_acctno AND AC.ACCTNO =P.ACCTNO AND B.BASKETID =AC.BASKETID AND P.SYMBOL = B.SYMBOL) T
--
--      WHERE P.REFSYMBOL = T.SYMBOL ));
--
--    -- Tinh no quy doi sau giao dich --
--    -- Gia tri lenh + phi. = BUYamt
--    SELECT SUM ( QUANTITY*(1+RATE_BRK)*GIATINH) INTO BUYAMT  FROM (
--    SELECT QUANTITY, SYMBOL, RATE_BRK, CASE TYPECD
--                              WHEN 'LO' THEN PRICE
--                              WHEN 'MK' THEN CASE SIDE WHEN 'B' THEN PRICE_CE
--                                                       WHEN 'S' THEN PRICE_FL
--                                                       END
--                             END GIATINH
--    FROM (SELECT Q.PRICE, Q.PRICE_FL,Q.PRICE_CE, ( ORD.EXEC_QTTY + ORD.REMAIN_QTTY) QUANTITY ,ORD.SYMBOL,ORD.TYPECD,ORD.SIDE,ORD.RATE_BRK
--          FROM ORDERS ORD, QUOTES Q WHERE ORD.ACCTNO = v_acctno AND Q.QUOTEID = ORD.QUOTEID)T );
--
--    SELECT BOD_DEBT,BOD_BALANCE,CALC_ADVBAL INTO V_DEBT, BALANCE, ADV FROM ACCOUNTS WHERE ACCTNO = v_acctno;
--    V_PROPERTY_DEBT := BUYAMT + V_DEBT + V_AMOUNT - BALANCE - ADV;
--
--    --SELECT BOD_DEBT,BOD_BALANCE,CALC_ADVBAL FROM ACCOUNTS WHERE ACCTNO ='0001000014';
--    IF V_PROPERTY >= V_PROPERTY_DEBT THEN
--    DBMS_OUTPUT.PUT_LINE( 'DU ROOM');
--    V_OUTPUT:= 'DU ROOM';
--    ELSE
--    --DBMS_OUTPUT.PUT_LINE( 'KO DU ROOM');
--    V_OUTPUT:= 'KHONG DU ROOM';
--    END IF;
--    RETURN V_OUTPUT;
--    EXCEPTION
--    WHEN OTHERS THEN
--    RETURN 'LOI THUC THI';
--    END FC_TRANS_CHECKROOM;

    FUNCTION fn_get_using_pool(p_err_code in OUT VARCHAR,
      p_trans_amount IN NUMBER,
      p_balance IN NUMBER,
      p_advbal IN NUMBER,
      p_payable IN  NUMBER,
      p_debt IN  NUMBER,
      p_odramt IN  NUMBER,
      p_td IN  NUMBER,
      p_t0value IN  NUMBER,
                p_err_msg OUT VARCHAR2) RETURN  number AS
      v_amount number;
      v_sum number;
    BEGIN
      p_err_msg:='fn_get_using_pool';
      v_amount := GREATEST(0,p_balance + p_advbal - p_payable - p_debt - p_odramt);
        --dbms_output.put_line('p_balance==========:' || p_balance );
        --dbms_output.put_line('p_advbal==========:' || p_advbal );
        --dbms_output.put_line('p_payable==========:' || p_payable );
        --dbms_output.put_line('p_debt==========:' || p_debt );
        --dbms_output.put_line('p_odramt==========:' || p_odramt );

        --dbms_output.put_line('p_trans_amount==========:' || p_trans_amount );
        v_sum :=  GREATEST(0,p_trans_amount - v_amount);

      RETURN v_sum;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='fn_get_using_pool' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END;


    FUNCTION fn_get_min_value(p_err_code in OUT VARCHAR, arr_in num_array,
                p_err_msg OUT VARCHAR2) RETURN  number AS
      v_min number :=0;
      v_temp number;
      v_total number;
      v_index number;
    BEGIN
       p_err_msg:='fn_get_min_value';
      --dbms_output.put_line('========================: ');
        v_total := arr_in.count;
        v_min := 9999999999;
        v_index := -1;

        --dbms_output.put_line('========================:v_min: ' || v_min);
        FOR i in 1 .. v_total LOOP
          v_temp := arr_in(i);
           IF(v_temp > 0) AND (v_temp < v_min) THEN
            v_min := v_temp;
            v_index := i;
          END IF;
        END LOOP;
        --dbms_output.put_line('========================:MIN value: ' || arr_in(v_index));
      RETURN v_index;

    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='fn_get_min_value '||p_err_msg||' sqlerrm = '||SQLERRM;
    END;


    FUNCTION fn_get_max_value(p_err_code in OUT VARCHAR, arr_in num_array,
                p_err_msg OUT VARCHAR2) RETURN  number AS
      v_max number :=0;
      v_temp number;
      v_total integer;
      v_index integer;
    BEGIN
      p_err_msg:='fn_get_max_value';
      --dbms_output.put_line('========================:xxxxxxx ');
        v_total := arr_in.count;
        v_max := 0;
        v_index := -1;
        --dbms_output.put_line('========================:v_total: ' || v_total);
        FOR i in 1 .. v_total LOOP
          v_temp := arr_in(i);
          --dbms_output.put_line('========================:arr_in(i): ' || i || arr_in(i));
          --dbms_output.put_line('========================:arr_in: ' || arr_in(i));
           IF(v_temp > 0) AND (v_temp > v_max) THEN
            v_max := v_temp;
            v_index := i;
          END IF;
          --dbms_output.put_line('symbol: ' || symbols_list(i) || ',hi:' || hi_list(i));
        END LOOP;
      --dbms_output.put_line('========================:MAX value: ' || arr_in(v_index));
      RETURN v_index;
    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='fn_get_max_value' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END;

    FUNCTION fn_get_release_pool(p_err_code in OUT VARCHAR,
                  p_trans_amount IN NUMBER,
                  p_balance IN NUMBER,
                  p_advbal IN NUMBER,
                  p_payable IN  NUMBER,
                  p_debt IN  NUMBER,
                  p_odramt IN  NUMBER,
                  p_td IN  NUMBER,
                  p_t0value IN  NUMBER,
                p_err_msg OUT VARCHAR2)

                  RETURN  number AS
      v_amount number;
      v_amount2 number;
      v_amount3 number;
      v_sum number;
    BEGIN
    p_err_msg:='fn_get_release_pool';
--        v_sum := LEAST(p_odramt + p_payable + p_debt - p_balance - p_advbal,p_trans_amount);
--        v_sum := GREATEST(v_sum,0);

      /* v_amount := GREATEST(0,p_odramt + p_payable - p_balance - p_advbal);

      v_amount2 := GREATEST(0,p_debt + p_odramt - p_balance - p_advbal - p_payable);

      v_amount3 := p_trans_amount - v_amount;

      v_sum := LEAST(v_amount3,v_amount2); */

      v_amount := GREATEST(0,p_payable + p_debt + p_odramt - p_balance - p_advbal - p_td);

      v_sum := LEAST(p_trans_amount,v_amount);

      RETURN v_sum;
  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='fn_get_release_pool ' ||p_err_msg||' sqlerrm = '||SQLERRM;

  END;


    /*
     * Author: Trung.Nguyen
     * Return: number
     * Parameter:
     *    p_symbol
     *    p_roomid
     * Description: calculate total quantity of securities(i) of all account
     */
    FUNCTION fn_get_Si(p_symbol IN VARCHAR, p_roomid IN VARCHAR) RETURN  NUMBER
    AS
        v_tradeEx       NUMBER;
        v_Si            NUMBER;
    BEGIN
        /*
         * Editor: Trung.Nguyen
         * Date: 11-Dec-2015
         */
        BEGIN
            SELECT NVL(SUM(P.BUYINGQTTY - P.BOD_ST3),0) INTO v_tradeEx
            FROM PORTFOLIOSEX P, ACCOUNTS A
            WHERE P.ACCTNO = A.ACCTNO
            AND A.FORMULACD IN ('PP0','PPSE','PPSET0')
            AND P.SYMBOL=p_symbol;
            EXCEPTION
                WHEN OTHERS THEN v_tradeEx:=0;
        END;

        SELECT SUM(P.TRADE + P.BUYINGQTTY + P.RECEIVING - P.BOD_ST3) + v_tradeEx INTO v_Si
        FROM PORTFOLIOS P
        WHERE P.BOD_RTN IN ('2','3','4')  --2: PP0, 3: PPSE , 4 PPSET0
        AND P.SYMBOL=p_symbol;
        --AND A.ROOMID=p_roomid;
        RETURN v_Si;
    END fn_get_Si;

    /*
     * Author: Trung.Nguyen
     * Return: number
     * Parameter:
     *    p_symbol
     *    p_roomid
     * Description: calculate total quantity of securities(i) has been used for marking
     */
    FUNCTION fn_get_Qi(p_symbol IN VARCHAR, p_roomid IN VARCHAR) RETURN  NUMBER
    AS
      v_Qi          NUMBER;
      v_Qi_daily    NUMBER;
    BEGIN
      -- Calculate quantity of securities(i) has been marked within a day
      SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0)  INTO v_Qi_daily
      FROM ALLOCATION WHERE POLICYCD='R' AND SYMBOL=p_symbol AND ROOMID=p_roomid;

      -- Calculate total quantity of securities(i) has been marked of previous days
      -- POOLROOM.INUSED is marked quantity of securities(i) of all previous day
      SELECT NVL(SUM(INUSED) + v_Qi_daily,0) INTO v_Qi
      FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=p_symbol;
      RETURN v_Qi;
    END fn_get_Qi;

    /*
     * Author: TrungNQ
     * Return: number
     * Parameter:
     *    p_symbol
     *    p_roomid
     * Description: total quantity of securitites(i) that Comp,... granted
     */
    FUNCTION fn_get_Ri(p_symbol IN VARCHAR, p_roomid IN VARCHAR) RETURN  NUMBER
    AS
      v_Ri          NUMBER;
    BEGIN
      SELECT NVL(SUM(GRANTED),0) INTO v_Ri
      FROM POOLROOM WHERE POLICYTYPE='R' AND REFSYMBOL=p_symbol AND POLICYCD=p_roomid;
      RETURN v_Ri;
    END fn_get_Ri;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *    p_acctno
     *    p_symbol
     *    p_incr_qtty:  incremental quantity of securities(i) which customer need to buy or editing for previous buying order
     *        - For buying order, value of p_incr_qtty is equal order quantity
     *        - For editing previous buying order, value of p_incr_qtty is subtraction between editing quantity and quantity of previous buying order
     * Description: calculating the asset is able to be marked of account
     */
 FUNCTION fn_get_markable_asset(p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_symbol IN VARCHAR, p_incr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2)
  RETURN NUMBER
AS
    --p_account  varchar(100);
    --p_roomid   varchar(100);
    p_rate_ub  NUMBER(20,2);
    p_crlimit  NUMBER(20,2);
    --p_incr_qtty NUMBER(20,2);
    --p_symbol    VARCHAR2(100);
    v_asset_value NUMBER(20,4) := 0;
    v_asset_value_ub NUMBER(20,4) := 0;
    v_asset_value_system NUMBER(20,4):= 0;
    v_qtty_ub        NUMBER;
    v_qtty_system        NUMBER;
    v_marked_qtty_ub NUMBER;
    v_marked_qtty_system NUMBER;
    v_daily_room_ub        NUMBER :=0;
    v_daily_room_system    NUMBER :=0;
    v_remain_room_ub NUMBER :=0;
    v_remain_room_system NUMBER :=0;
    v_daily_count NUMBER := 0;
    v_rate_margin NUMBER := 0;
    v_count       NUMBER := 0;
    v_flag        BOOLEAN:=FALSE ;

  BEGIN
    v_asset_value := 0;
    --
    SELECT  NVL(rate_ub,100), NVL(bod_crlimit,0) INTO  p_rate_ub , p_crlimit
    FROM ACCOUNTS  WHERE  ACCTNO = p_acctno;


    FOR rec IN --lay ck trong bang portfolios
    ( --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
      SELECT p.TRADE,p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) SELLINGQTTY,p.BUYINGQTTY + NVL(pex.BUYINGQTTY,0) BUYINGQTTY,b.PRICE_MARGIN,b.RATE_MARGIN,
             p.RECEIVING, p.BOD_RT3 +  NVL(pex.BOD_RT3,0) BOD_RT3, p.BOD_ST3 + NVL(pex.BOD_ST3,0) BOD_ST3,
             p.MARKED + NVL(pex.MARKED,0) MARKED,p.MARKEDCOM + NVL(pex.MARKEDCOM,0) MARKEDCOM,p.SYMBOL
      FROM PORTFOLIOS p,ACCOUNTS a, BASKETS b,PORTFOLIOSEX pex
      WHERE p.ACCTNO = p_acctno AND  p.ACCTNO = a.ACCTNO AND a.BASKETID = b.BASKETID AND p.SYMBOL = b.SYMBOL
         AND p.ACCTNO = pex.ACCTNO(+) AND p.SYMBOL =pex.SYMBOL(+)
    )

    LOOP
      --1. Tinh khoi luong chung khoan cua tai khoan
      IF p_symbol IS NOT NULL AND  rec.symbol = p_symbol THEN
          v_qtty_ub     :=  p_incr_qtty +  rec.TRADE - rec.BOD_ST3 + rec.RECEIVING + rec.BUYINGQTTY;
          v_qtty_system :=  p_incr_qtty +  rec.TRADE - rec.BOD_ST3 + rec.RECEIVING + rec.BUYINGQTTY;
          v_flag  :=TRUE;
      ELSE
          v_qtty_ub     := rec.TRADE - rec.BOD_ST3 + rec.RECEIVING + rec.BUYINGQTTY;
          v_qtty_system := rec.TRADE - rec.BOD_ST3 + rec.RECEIVING + rec.BUYINGQTTY;
      END IF;
      --dbms_output.put_line('rec.symbol: '||rec.symbol);
      --bms_output.put_line('v_qtty_ub: '||v_qtty_ub);
      --bms_output.put_line('v_qtty_system: '||v_qtty_system);
      --2. Tinh chung khoan da duoc danh dau

      v_marked_qtty_ub := rec.MARKEDCOM;
      v_marked_qtty_system := rec.MARKED;

      v_daily_room_ub := 0;
      v_daily_room_system := 0;

      v_remain_room_ub := 0;
      v_remain_room_system := 0;
      --3. Tinh room con lai cua ma ck
      BEGIN
          SELECT NVL(SUM(CASE WHEN  ROOMID ='SYSTEM' THEN DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)
                      ELSE  0
                      END),0) v_daily_room_system,
                 NVL(SUM(CASE WHEN  ROOMID ='UB' THEN DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)
                      ELSE  0
                      END),0) v_daily_room_ub  INTO  v_daily_room_system, v_daily_room_ub
          FROM   ALLOCATION WHERE POLICYCD='R' AND  SYMBOL=rec.SYMBOL;
      EXCEPTION WHEN OTHERS THEN
         v_daily_room_system:=0;
         v_daily_room_ub    :=0;
         --bms_output.put_line(' Exeption check Daily Room');
      END;
     --bms_output.put_line('v_daily_room_system: '||v_daily_room_system);
     --bms_output.put_line('v_daily_room_ub:     '||v_daily_room_ub);

      BEGIN
          SELECT NVL(SUM(CASE WHEN POLICYCD ='SYSTEM' THEN NVL(GRANTED,0) - NVL(INUSED,0)
                          ELSE 0
                          END
                    ),0) v_remain_room_system ,
                 NVL(SUM(CASE WHEN POLICYCD ='UB' THEN NVL(GRANTED,0) - NVL(INUSED,0)
                          ELSE 0
                          END
                    ),0) v_remain_room_ub INTO   v_remain_room_system,  v_remain_room_ub
             FROM POOLROOM WHERE POLICYTYPE='R' AND REFSYMBOL=rec.SYMBOL;
      EXCEPTION WHEN OTHERS THEN
            v_remain_room_system:=0;
            v_remain_room_ub    :=0;
      END;
      --bms_output.put_line('v_remain_room_system: '||v_remain_room_system);
      --bms_output.put_line('v_remain_room_ub:     '||v_remain_room_ub);

--      v_remain_room_system:= v_remain_room_system      +  v_marked_qtty_system;
--      v_remain_room_ub    := v_remain_room_ub          +  v_marked_qtty_ub;

      v_remain_room_system:= v_remain_room_system      -  v_daily_room_system;
      v_remain_room_ub    := v_remain_room_ub          -  v_daily_room_ub;


      --4.Tinh min
      SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_acctno AND REFSYMBOL=rec.SYMBOL;

      IF v_count = 0 THEN --Room thuong, neu Room dac biet thi lay ca qtty, ko min.

        v_qtty_ub     := LEAST(v_qtty_ub,greatest(v_remain_room_ub,0) + v_marked_qtty_ub);
        v_qtty_system := LEAST(v_qtty_system,greatest(v_remain_room_system,0)+ v_marked_qtty_system);

      END IF;

      --5.Tinh values

      v_asset_value_ub    :=v_asset_value_ub + v_qtty_ub *  rec.PRICE_MARGIN * LEAST(p_rate_ub,rec.RATE_MARGIN)/100;

      v_asset_value_system:=v_asset_value_system + v_qtty_system *  rec.PRICE_MARGIN * rec.RATE_MARGIN/100;

      --bms_output.put_line('v_asset_value_ub: '||v_asset_value_ub);
      --bms_output.put_line('v_asset_value_system: '||v_asset_value_system);
    END LOOP;

    IF p_incr_qtty >0 AND p_symbol IS NOT NULL AND v_flag = FALSE  THEN  --Khoi luong phan phat sinh them
         FOR rec IN (SELECT B.RATE_MARGIN, B.PRICE_MARGIN
                        FROM ACCOUNTS A, BASKETS B
                        WHERE  A.ACCTNO = p_acctno
                        AND   A.BASKETID=B.BASKETID AND B.SYMBOL =p_symbol)
          LOOP
              --2.1. Tinh khoi luong chung khoan cua tai khoan
              v_qtty_ub     := p_incr_qtty;
              v_qtty_system := p_incr_qtty;
              --bms_output.put_line('v_qtty_ub: '||v_qtty_ub);
              --2.2. Tinh chung khoan da duoc danh dau

              v_marked_qtty_ub     := 0;
              v_marked_qtty_system := 0;

              v_daily_room_ub := 0;
              v_daily_room_system := 0;

              v_remain_room_ub := 0;
              v_remain_room_system := 0;
              --3. Tinh room con lai cua ma ck
              BEGIN
                  SELECT NVL(SUM(CASE WHEN  ROOMID ='SYSTEM' THEN DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)
                              ELSE  0
                              END),0) v_daily_room_system,
                         NVL(SUM(CASE WHEN  ROOMID ='UB' THEN DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)
                              ELSE  0
                              END),0) v_daily_room_ub  INTO  v_daily_room_system, v_daily_room_ub
                  FROM   ALLOCATION WHERE POLICYCD='R' AND  SYMBOL=p_symbol;
              EXCEPTION WHEN OTHERS THEN
                 v_daily_room_system:=0;
                 v_daily_room_ub    :=0;
                 --bms_output.put_line(' Exeption check Daily Room');
              END;
             --bms_output.put_line('v_daily_room_system: '||v_daily_room_system);
             --bms_output.put_line('v_daily_room_ub:     '||v_daily_room_ub);

              BEGIN
                  SELECT NVL(SUM(CASE WHEN POLICYCD ='SYSTEM' THEN NVL(GRANTED,0) - NVL(INUSED,0)
                                  ELSE 0
                                  END
                            ),0) v_remain_room_system ,
                         NVL(SUM(CASE WHEN POLICYCD ='UB' THEN NVL(GRANTED,0) - NVL(INUSED,0)
                                  ELSE 0
                                  END
                            ),0) v_remain_room_ub INTO   v_remain_room_system,  v_remain_room_ub
                     FROM POOLROOM WHERE POLICYTYPE='R' AND REFSYMBOL=p_symbol;
              EXCEPTION WHEN OTHERS THEN
                    v_remain_room_system:=0;
                    v_remain_room_ub    :=0;
              END;
              --bms_output.put_line('v_remain_room_system: '||v_remain_room_system);
              --bms_output.put_line('v_remain_room_ub:     '||v_remain_room_ub);

--              v_remain_room_system:= v_remain_room_system      +  v_marked_qtty_system;
--              v_remain_room_ub    := v_remain_room_ub          +  v_marked_qtty_ub;

              v_remain_room_system:= v_remain_room_system      - v_daily_room_system;
              v_remain_room_ub    := v_remain_room_ub          - v_daily_room_ub;


              --4.Tinh min
              SELECT COUNT(1) INTO v_count FROM OWNPOOLROOM WHERE ACCTNO = p_acctno AND REFSYMBOL=p_symbol;
              IF v_count = 0 THEN --Room thuong, neu Room dac biet thi lay ca qtty, ko min.
                v_qtty_ub     := LEAST(v_qtty_ub,greatest(v_remain_room_ub,0) + v_marked_qtty_ub);
                v_qtty_system := LEAST(v_qtty_system,greatest(v_remain_room_system,0) + v_marked_qtty_system);

              END IF;

              --5.Tinh values


               v_asset_value_ub    :=v_asset_value_ub + v_qtty_ub *  rec.PRICE_MARGIN * LEAST(p_rate_ub,rec.RATE_MARGIN)/100;

               v_asset_value_system:=v_asset_value_system + v_qtty_system *  rec.PRICE_MARGIN * rec.RATE_MARGIN/100;


              --bms_output.put_line('v_asset_value_ub: '||v_asset_value_ub);
              --bms_output.put_line('v_asset_value_system: '||v_asset_value_system);
       END LOOP;
   END IF;

    --bms_output.put_line(' p_roomid : '||p_roomid);

    --tinh MIN voi room he thong
    IF p_roomid = 'UB' THEN
      --v_asset_value :=  LEAST(v_asset_value_ub,v_asset_value_system);
      v_asset_value :=  v_asset_value_ub;
    ELSE
      v_asset_value :=  v_asset_value_system;
    END IF;
    --Min voi han muc:
    --bms_output.put_line(' p_crlimit '||p_crlimit);
    v_asset_value:=LEAST(v_asset_value, p_crlimit);
    RETURN v_asset_value;
   EXCEPTION
       WHEN OTHERS THEN
          --p_err_code := '-90025';
          p_err_msg:='fn_get_markable_asset ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END fn_get_markable_asset;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno
     *      p_derm_ord_amt:     decremental amount for buying order
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_incr_ord_amt:     incremental amount for selling order
     *      p_bod_t0value:      guaranteed amount of account
     * Description: Estimate the debt of account after deal
     */
    FUNCTION fn_get_estimated_debt(p_acctno IN VARCHAR,
              p_derm_ord_amt IN NUMBER,
              p_bod_payable IN NUMBER,
              p_bod_debt_t0 IN NUMBER,
              p_bod_d_margin IN NUMBER,
              p_calc_odramt IN NUMBER,
              p_sell_amt IN NUMBER,
              p_bod_balance IN NUMBER,
              p_bod_adv  IN NUMBER,
              p_calc_advbal IN NUMBER,
              p_bod_td IN NUMBER,
              p_incr_ord_amt IN NUMBER,
              p_bod_t0value IN NUMBER,
              p_err_msg OUT VARCHAR2) RETURN NUMBER
    AS
      v_estimated_debt      NUMBER;
    BEGIN
      p_err_msg:='fn_get_estimated_debt p_acctno=>'||p_acctno;
      --DBMS_OUTPUT.put_line('Decremental amount of order: '||TO_CHAR(p_derm_ord_amt,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Custody fees at the begin of day: '||TO_CHAR(p_bod_payable,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Debt at the begin of day: '||TO_CHAR(p_bod_debt_t0 + p_bod_d_margin,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Orders amount: '||TO_CHAR(p_calc_odramt,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Cash balance at the begin of day: '||TO_CHAR(p_bod_balance,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Cash advance at the begin of day of the previous selling orders: '||TO_CHAR(p_bod_adv,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Cash advance of the selling orders in day: '||TO_CHAR(p_calc_advbal,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Total deposit at the begin of day: '||TO_CHAR(p_bod_td,'999,999,999,999'));
      --DBMS_OUTPUT.put_line('Total amount at the begin of T0: '||TO_CHAR(p_bod_t0value,'999,999,999,999'));

      -- The debt is estimated after deal
      v_estimated_debt := p_derm_ord_amt + p_bod_payable + p_bod_debt_t0 + p_bod_d_margin + p_calc_odramt
                        - p_sell_amt - p_bod_balance - TRUNC(p_bod_adv + p_calc_advbal) -
                        LEAST(p_bod_td, p_calc_odramt + p_derm_ord_amt) - p_incr_ord_amt - p_bod_t0value;

      -- The real debt after deal
      --v_estimated_debt := p_bod_payable + p_bod_debt + p_calc_odramt - p_sell_amt - p_bod_balance - (p_bod_adv + p_calc_advbal) - LEAST(p_bod_td, p_calc_odramt);
      --DBMS_OUTPUT.put_line('-----------------------------------');
      --DBMS_OUTPUT.put_line('***** ESTIMATED DEBT: '||TO_CHAR(v_estimated_debt,'999,999,999,999'));
      RETURN v_estimated_debt;

 EXCEPTION
       WHEN OTHERS THEN
          --p_err_code := '-90025';
          p_err_msg:='fn_get_estimated_debt '|| p_err_msg||' sqlerrm = '||SQLERRM;

  END fn_get_estimated_debt;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno
     *    p_roomid
     * Description: calculating the asset of account has been marked
     */
    FUNCTION fn_get_marked_asset(p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_basketid IN VARCHAR, p_own_basketid IN VARCHAR,
                p_err_msg OUT VARCHAR2) RETURN NUMBER
    AS
        CURSOR c_marked_symbols IS
            SELECT P.SYMBOL, P.MARKED, P.MARKEDCOM, B.PRICE_MARGIN, B.RATE_MARGIN, A.RATE_UB FROM PORTFOLIOS P
            INNER JOIN ACCOUNTS A ON (A.ACCTNO=P.ACCTNO)
            INNER JOIN BASKETS B ON (B.BASKETID=p_basketid AND P.SYMBOL=B.SYMBOL)
            WHERE A.ACCTNO=p_acctno;


        CURSOR c_own_marked_symbols IS
            SELECT R.PRID, R.REFSYMBOL AS SYMBOL, R.INUSED AS MARKED, B.PRICE_MARGIN, B.RATE_MARGIN, A.RATE_UB FROM OWNPOOLROOM R
            INNER JOIN ACCOUNTS A ON (R.ACCTNO=A.ACCTNO)
            INNER JOIN BASKETS B ON (B.BASKETID=p_own_basketid AND R.REFSYMBOL=B.SYMBOL)
            WHERE R.POLICYTYPE='R' AND R.ACCTNO=p_acctno;
        recd                        c_marked_symbols%ROWTYPE;
        ored                        c_own_marked_symbols%ROWTYPE;
        v_markedex_qtty             NUMBER := 0;
        v_markedcomex_qtty          NUMBER := 0;
        v_marked_amt                NUMBER := 0;        -- Marked amount of all symbol is in SYSTEM room
        v_markedcom_amt             NUMBER := 0;        -- Marked amount of all symbol is in UB room
        v_markedown_amt_system             NUMBER := 0;
        v_markedown_amt_ub                 NUMBER := 0;
        v_daily_own_qtty            NUMBER := 0;
        v_marked_asset              NUMBER := 0;
    BEGIN
        p_err_msg:='fn_get_marked_asset p_acctno=>'||p_acctno;
        OPEN c_marked_symbols;
        LOOP
        FETCH c_marked_symbols INTO recd;
            EXIT WHEN (c_marked_symbols%NOTFOUND);
            /*
             * Editor: Trung.Nguyen
             * Date: 11-Dec-2015
             */
            BEGIN
                SELECT MARKED, MARKEDCOM INTO v_markedex_qtty, v_markedcomex_qtty
                FROM PORTFOLIOSEX WHERE ACCTNO=p_acctno AND SYMBOL=recd.SYMBOL;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_markedex_qtty:=0;
                        v_markedcomex_qtty:=0;
            END;

            --DBMS_OUTPUT.put_line('SYSTEM - Marked quantity of '||recd.SYMBOL||': '||(recd.MARKED + v_markedex_qtty));
            --DBMS_OUTPUT.put_line('UB - Marked quantity of '||recd.SYMBOL||': '||(recd.MARKEDCOM + v_markedcomex_qtty));
            --DBMS_OUTPUT.put_line('Price margin: '||recd.PRICE_MARGIN);
            --DBMS_OUTPUT.put_line('Rate margin: '||recd.RATE_MARGIN);
            v_marked_amt := v_marked_amt + ((recd.MARKED + v_markedex_qtty) * recd.PRICE_MARGIN * recd.RATE_MARGIN/100);
            v_markedcom_amt := v_markedcom_amt + ((recd.MARKEDCOM + v_markedcomex_qtty) * recd.PRICE_MARGIN * least(recd.RATE_MARGIN,recd.RATE_UB)/100);
        END LOOP;

        OPEN c_own_marked_symbols;
        LOOP
        FETCH c_own_marked_symbols INTO ored;
            EXIT WHEN (c_own_marked_symbols%NOTFOUND);
            SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_own_qtty
            FROM ALLOCATION WHERE POLICYCD='R' AND ACCTNO=p_acctno AND SYMBOL=ored.SYMBOL AND ROOMID=ored.PRID;
            --DBMS_OUTPUT.put_line('OWNROOM - BOD Marked quantity of '||ored.SYMBOL||': '||ored.MARKED);
            --DBMS_OUTPUT.put_line('OWNROOM - Daily Marked quantity of '||ored.SYMBOL||': '||v_daily_own_qtty);
            --DBMS_OUTPUT.put_line('Price margin: '||ored.PRICE_MARGIN);
            --DBMS_OUTPUT.put_line('Rate margin: '||ored.RATE_MARGIN);
            v_markedown_amt_system := v_markedown_amt_system + ((ored.MARKED + v_daily_own_qtty) * ored.PRICE_MARGIN * ored.RATE_MARGIN/100);
            v_markedown_amt_ub     := v_markedown_amt_ub + ((ored.MARKED + v_daily_own_qtty) * ored.PRICE_MARGIN * least(ored.RATE_MARGIN,ored.RATE_UB)/100);
        END LOOP;

        IF (p_roomid='SYSTEM') THEN
            v_marked_asset := v_marked_amt + v_markedown_amt_system;
        ELSIF (p_roomid='UB') THEN
            v_marked_asset := v_markedcom_amt + v_markedown_amt_ub;
        END IF;

        --DBMS_OUTPUT.put_line('-----------------------------------');
        --DBMS_OUTPUT.put_line('***** MARKED ASSET by '||p_roomid||' room: '||TO_CHAR(v_marked_asset,'999,999,999,999'));
        RETURN v_marked_asset;
    EXCEPTION
       WHEN OTHERS THEN
          --p_err_code := '-90025';
          p_err_msg:='fn_get_marked_asset '||p_err_msg||' sqlerrm = '||SQLERRM;
    END fn_get_marked_asset;

    /*
     * Author: TrungNQ
     * Parameters:
     *    c_markable_symbols
     *    p_acctno
     * Description: get list of symbols from portfolios that is able to be marked
     */
    PROCEDURE sp_get_markable_symbols(c_considered_symbols OUT SYS_REFCURSOR, p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_basketid IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
      CURSOR c_portfolios IS
          SELECT    A.ACCTNO, A.ROOMID, P.SYMBOL, B.PRICE_MARGIN, CASE WHEN p_roomid ='SYSTEM' THEN  B.RATE_MARGIN
                                                                       ELSE LEAST(B.RATE_MARGIN, A.RATE_UB)
                                                                       END
                                                                       RATE_MARGIN
          FROM ACCOUNTS A INNER JOIN(
                                   SELECT P.ACCTNO, P.SYMBOL FROM PORTFOLIOS P WHERE P.ACCTNO=p_acctno
                                   INTERSECT
                                   SELECT A.ACCTNO, R.REFSYMBOL AS SYMBOL FROM POOLROOM R
                                   INNER JOIN ACCOUNTS A ON R.POLICYCD=A.ROOMID WHERE R.POLICYTYPE='R' AND A.ACCTNO=p_acctno
                   MINUS
                                   SELECT O.ACCTNO, O.REFSYMBOL AS SYMBOL FROM OWNPOOLROOM O WHERE O.POLICYTYPE='R' AND O.ACCTNO=p_acctno
                                  ) P ON A.ACCTNO=P.ACCTNO
          INNER JOIN BASKETS B ON (B.BASKETID=p_basketid AND P.SYMBOL=B.SYMBOL)
          WHERE B.PRICE_MARGIN > 0 AND B.RATE_MARGIN > 0;
      recd          c_portfolios%ROWTYPE;
      Si                    NUMBER;
      Qi                    NUMBER;
      Ri                    NUMBER;
      v_priority        NUMBER;
      v_currtime_log varchar2(100);
      v_currtime       timestamp;

    BEGIN
      p_err_msg:='sp_get_markable_symbols p_acctno=>'||p_acctno;
      DELETE FROM CONSIDERED_SYMBOLS_TMP;
      --dbms_output.put_line('----- MARKABLE SYMBOLS -----');
      OPEN c_portfolios;
      LOOP
      FETCH c_portfolios INTO recd;
      EXIT WHEN (c_portfolios%NOTFOUND);

        /*BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.2.1  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        Si:=CSPKS_FO_POOLROOM.fn_get_Si(recd.SYMBOL, p_roomid);
        /*  BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.2.2  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        Qi:=CSPKS_FO_POOLROOM.fn_get_Qi(recd.SYMBOL, p_roomid);

        /*BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.2.3  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        Ri:=CSPKS_FO_POOLROOM.fn_get_Ri(recd.SYMBOL, p_roomid);


        /*BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.2.4  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        --dbms_output.put_line('Si of '||recd.SYMBOL||': '||Si);
        --dbms_output.put_line('Qi of '||recd.SYMBOL||': '||Qi);
        --dbms_output.put_line('Ri of '||recd.SYMBOL||': '||Ri);
        --dbms_output.put_line('------------------------------------');
        CONTINUE WHEN Ri<=0;            -- exception zero_divide
        v_priority:=ROUND(Si/Ri,3);     -- Hi
        IF v_priority>1 THEN
          v_priority:= 1 + ROUND(Qi/Ri,3); -- Ki
        END IF;

        IF (v_priority>=0) THEN
          INSERT INTO CONSIDERED_SYMBOLS_TMP(ROOMID, SYMBOL, PRICE_ASSET, RATE_ASSET, PRIORITY)
          --INSERT INTO CONSIDERED_SYMBOLS_TMP(ROOMID, SYMBOL, PRICE_MARGIN, RATE_MARGIN, PRIORITY)
          VALUES (p_roomid, recd.SYMBOL, recd.PRICE_MARGIN, recd.RATE_MARGIN, v_priority);
        END IF;
      END LOOP;

      OPEN c_considered_symbols FOR
        SELECT ROOMID, SYMBOL, PRICE_ASSET, RATE_ASSET, PRIORITY
        FROM CONSIDERED_SYMBOLS_TMP
        ORDER BY PRIORITY ASC;
   EXCEPTION
       WHEN OTHERS THEN
          --p_err_code := '-90025';
          p_err_msg:='sp_get_markable_symbols ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_markable_symbols;

    /*
     * Author: TrungNQ
     * Parameters:
     *    c_releasable_symbols
     *    p_acctno
     * Description: get list of symbols from portfolios that is able to be released
     */
    PROCEDURE sp_get_releasable_symbols(c_releasable_symbols OUT SYS_REFCURSOR, p_acctno IN VARCHAR, p_roomid IN VARCHAR, p_basketid IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
      CURSOR c_portfolios IS
        SELECT  A.ACCTNO, A.ROOMID, P.SYMBOL, B.PRICE_MARGIN, CASE WHEN p_roomid ='SYSTEM' THEN  B.RATE_MARGIN
                                                                       ELSE LEAST(B.RATE_MARGIN, A.RATE_UB)
                                                                       END
                                                                       RATE_MARGIN
        FROM ACCOUNTS A INNER JOIN(
                                   SELECT P.ACCTNO, P.SYMBOL FROM PORTFOLIOS P WHERE P.ACCTNO=p_acctno
                                   INTERSECT
                                   SELECT A.ACCTNO, R.REFSYMBOL AS SYMBOL FROM POOLROOM R
                                   INNER JOIN ACCOUNTS A ON R.POLICYCD=p_roomid WHERE R.POLICYTYPE='R' AND A.ACCTNO=p_acctno
                   MINUS
                                   SELECT O.ACCTNO, O.REFSYMBOL AS SYMBOL FROM OWNPOOLROOM O WHERE O.POLICYTYPE='R' AND O.ACCTNO=p_acctno
                                  ) P ON A.ACCTNO=P.ACCTNO
        INNER JOIN BASKETS B ON (B.BASKETID=p_basketid AND P.SYMBOL=B.SYMBOL)
        WHERE B.PRICE_MARGIN > 0 AND B.RATE_MARGIN > 0;
      recd              c_portfolios%ROWTYPE;
      Si                      NUMBER;
      Qi                      NUMBER;
      Ri                      NUMBER;
      v_priority          NUMBER;
    BEGIN
      p_err_msg:='sp_get_releasable_symbols';
      DELETE FROM CONSIDERED_SYMBOLS_TMP;
      --dbms_output.put_line('----- RELEASABLE SYMBOLS -----');
      OPEN c_portfolios;
      LOOP
        FETCH c_portfolios INTO recd;
        EXIT WHEN (c_portfolios%NOTFOUND);
        Si:=CSPKS_FO_POOLROOM.fn_get_Si(recd.SYMBOL, p_roomid);
        Qi:=CSPKS_FO_POOLROOM.fn_get_Qi(recd.SYMBOL, p_roomid);
        Ri:=CSPKS_FO_POOLROOM.fn_get_Ri(recd.SYMBOL, p_roomid);
        --dbms_output.put_line('Si of '||recd.SYMBOL||': '||Si);
        --dbms_output.put_line('Qi of '||recd.SYMBOL||': '||Qi);
        --dbms_output.put_line('Ri of '||recd.SYMBOL||': '||Ri);
        --dbms_output.put_line('------------------------------------');
        CONTINUE WHEN Ri<=0;                -- exception zero_divide
        v_priority:=ROUND(Si/Ri,3);         -- Hi
        IF v_priority>=1 THEN
          v_priority:= 1 + ROUND(Qi/Ri,3);  -- 1 + Ki
        /*ThanhNV sua 20/Jan: Cac ma co Hi < 1 uu tien sau va uu tien Hi lon hon truoc.
        ELSE
          v_priority:= ROUND(Qi/Ri,3);      -- Ki
        */
        END IF;

        IF (v_priority>=0) THEN
          INSERT INTO CONSIDERED_SYMBOLS_TMP(ROOMID, SYMBOL, PRICE_ASSET, RATE_ASSET, PRIORITY)
          --INSERT INTO CONSIDERED_SYMBOLS_TMP(ROOMID, SYMBOL, PRICE_MARGIN, RATE_MARGIN, PRIORITY)
          VALUES (p_roomid, recd.SYMBOL, recd.PRICE_MARGIN, recd.RATE_MARGIN, v_priority);
        END IF;
      END LOOP;

      OPEN c_releasable_symbols FOR
        SELECT ROOMID, SYMBOL, PRICE_ASSET, RATE_ASSET, PRIORITY
        FROM CONSIDERED_SYMBOLS_TMP
        ORDER BY PRIORITY DESC;
   EXCEPTION
       WHEN OTHERS THEN
          --p_err_code := '-90025';
          p_err_msg:='sp_get_releasable_symbols ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_releasable_symbols;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_derm_ord_amt:     decremental amount of transaction that is applied for these situations
     *                                  - buying order
     *                                  - edit incrementally the quantity of previous buying order
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_incr_ord_amt:     incremental amount of transaction that is applied for these situations
     *                                  - selling order
     *                                  - edit incrementally the quantity of previous selling order
     *      p_symbol:
     *      p_incr_qtty:          incremental quantity of securities(i) which customer need to buy or editing for previous buying order
     *                                  - for buying order, value of p_incr_qtty is equal order quantity
     *                                  - for edit incrementally the quantity of buying order, value of p_incr_qtty is subtraction between editing quantity and quantity of previous buying order
     *      p_bod_t0value:      guaranteed amount of account
     * Description: check remain room before making. Please refer section III. Room (link: https://docs.fss.com.vn/pages/viewpage.action?pageId=3343051)
     */
    PROCEDURE sp_process_checkroom_v3(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_derm_ord_amt IN NUMBER,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_incr_ord_amt IN NUMBER,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
      v_estimated_debt      NUMBER := 0;
      v_markable_asset      NUMBER := 0;
    BEGIN
     p_err_msg:='sp_process_checkroom_v3 p_acctno=>'||p_acctno;
      -- (1). Get the estimated debt after deal

      v_estimated_debt := CSPKS_FO_POOLROOM.fn_get_estimated_debt(p_acctno, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv,  p_calc_advbal, p_bod_td, p_incr_ord_amt, p_bod_t0value,p_err_msg);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'checkroom_v3',p_acctno,null,'v_estimated_debt',v_estimated_debt);
      --dbms_output.put_line('v_estimated_debt : ' || v_estimated_debt);
      -- (2). Get the markable asset after deal
      ---v_markable_asset := fn_get_markable_asset(p_acctno, p_symbol, p_incr_qtty);


      v_markable_asset := CSPKS_FO_POOLROOM.fn_get_markable_asset(p_acctno, p_roomid, p_symbol, p_incr_qtty,p_err_msg);
      insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'checkroom_v3',p_acctno,null,'v_markable_asset',v_markable_asset);

      --dbms_output.put_line('v_markable_asset : ' || v_markable_asset);
      p_err_msg:='sp_process_checkroom_v3 p_acctno'|| p_acctno||' p_derm_ord_amt '||p_derm_ord_amt ||' p_bod_payable '||p_bod_payable||
                                                 ' p_bod_debt_t0 '|| p_bod_debt_t0 || 'p_bod_d_margin '|| p_bod_d_margin||
                                                 ' p_calc_odramt '|| p_calc_odramt || ' p_sell_amt '|| p_sell_amt ||
                                                 ' p_bod_balance '|| p_bod_balance || ' p_bod_adv '|| p_bod_adv ||
                                                 ' p_bod_td '|| p_bod_td || ' p_incr_ord_amt '|| p_incr_ord_amt ||
                                                 ' p_bod_t0value ' || p_bod_t0value;
      p_err_msg:=p_err_msg ||' p_acctno '|| p_acctno||' p_roomid '||p_roomid ||' p_symbol '||p_symbol||
                                                      ' p_incr_qtty '|| p_incr_qtty;

      p_err_msg:=p_err_msg ||' v_estimated_debt: '||v_estimated_debt ||' v_markable_asset: '||v_markable_asset;
      IF (v_estimated_debt <= v_markable_asset) THEN
        p_err_code := '0';
      ELSE
        p_err_code := '-90036';
      END IF;

  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_checkroom_v3 '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_checkroom_v3;

    PROCEDURE sp_process_checkownroom(p_err_code in OUT VARCHAR,
                p_roomid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
      v_daily_room          NUMBER := 0;
      v_remain_room         NUMBER := 0;
    BEGIN
      p_err_msg:='sp_process_checkownroom p_roomid=>'||p_roomid;
      --DBMS_OUTPUT.ENABLE;
          --dbms_output.put_line('1' );
      -- The remain room of securities(i)
      SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
      FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=p_roomid AND SYMBOL=p_symbol;
      --dbms_output.put_line('v_daily_room : ' || v_daily_room);
      --dbms_output.put_line('2' );
      SELECT NVL(GRANTED,0) - NVL(INUSED,0) - v_daily_room
      INTO v_remain_room
      FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=p_symbol;
      --dbms_output.put_line('v_remain_room : ' || v_remain_room);

      IF (p_incr_qtty <= v_remain_room) THEN
        p_err_code := '0';
      ELSE
        p_err_code := '-90015';
      END IF;


   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_checkownroom ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_checkownroom;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_derm_ord_amt:     decremental amount of transaction that is applied for these situations
     *                                  - buying order
     *                                  - edit incrementally the quantity of previous buying order
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *    p_bod_d_margin_ub:
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_incr_ord_amt:     incremental amount of transaction that is applied for these situations
     *                                  - selling order
     *                                  - edit incrementally the quantity of previous selling order
     *      p_symbol:
     *      p_incr_qtty:          incremental quantity of securities(i) which customer need to buy or editing for previous buying order
     *                                  - for buying order, value of p_incr_qtty is equal order quantity
     *                                  - for edit incrementally the quantity of buying order, value of p_incr_qtty is subtraction between editing quantity and quantity of previous buying order
     *      p_bod_t0value:      guaranteed amount of account
     * Description:
     */
    PROCEDURE sp_process_checkroom_v4(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_derm_ord_amt IN NUMBER,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_incr_ord_amt IN NUMBER,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
      cst_system    CONSTANT    VARCHAR(20) := 'SYSTEM';
      cst_ub          CONSTANT  VARCHAR(20) := 'UB';
      v_count                         NUMBER := 0;
      v_ownroomid                   OWNPOOLROOM.PRID%TYPE;
    BEGIN
    p_err_msg:='sp_process_checkroom_v4 p_acctno=>'||p_acctno;
    --DBMS_OUTPUT.ENABLE;
      SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
      IF (v_count>1) THEN
        -- ERROR
        p_err_code := '-90030';
      ELSIF (v_count=1) THEN
        -- PROCESS OWNPOOLROOM
        SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
        CSPKS_FO_POOLROOM.sp_process_checkownroom(p_err_code, v_ownroomid, p_symbol, p_incr_qtty,p_err_msg);
         --dbms_output.put_line('v_ownroomid' || v_ownroomid);
          --dbms_output.put_line('p_symbol' || p_symbol);
           --dbms_output.put_line('p_incr_qtty' || p_incr_qtty);
        IF (p_err_code!='0') THEN
          RETURN;
        END IF;
        IF (p_roomid=cst_ub) THEN
          -- PROCESS UB ROOM
          --CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_ub, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value);
          CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_ub, p_derm_ord_amt, 0, 0, p_bod_d_margin_ub, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value,p_err_msg);
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_system, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value,p_err_msg);
          END IF;
        ELSIF (p_roomid=cst_system) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_system, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value,p_err_msg);
        ELSE
          -- ERROR
          p_err_code := '-90030';
        END IF;

      ELSIF (v_count=0) THEN
        IF (p_roomid=cst_ub) THEN
          -- PROCESS UB ROOM
          --CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_ub, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value);
          CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_ub, p_derm_ord_amt, 0, 0, p_bod_d_margin_ub, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value,p_err_msg);
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_system, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value,p_err_msg);
          END IF;
        ELSIF (p_roomid=cst_system) THEN
          -- PROCESS SYSTEM ROOM

          CSPKS_FO_POOLROOM.sp_process_checkroom_v3(p_err_code, p_acctno, cst_system, p_derm_ord_amt, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_incr_ord_amt, p_symbol, p_incr_qtty, p_bod_t0value,p_err_msg);
        ELSE
          -- ERROR
          p_err_code := '-90030';
        END IF;
      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_checkroom_v4 ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_checkroom_v4;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_bod_t0value:      guaranteed amount of account
     *      p_orderid:            identifier of order using room
     *      p_side:                 side of order using room (B-buying; AB-amend buying)
     * Description: marking selected symbols meeting condition
     */
    PROCEDURE sp_process_markroom_v4(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_basketid IN VARCHAR,
                p_own_basketid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
        v_marked_asset                  NUMBER;             -- the asset has been marked currently
        v_real_debt                     NUMBER;             -- the real debt of account after deal
        v_add_mark_value                NUMBER;             -- the total amount which account additionally need to use for trading
        c_considered_symbols            SYS_REFCURSOR;      -- list of selected symbols that is able to be marked
        v_roomid                        POOLROOM.POLICYCD%TYPE;
        v_symbol                        PORTFOLIOS.SYMBOL%TYPE;
        v_price_margin                  BASKETS.PRICE_MARGIN%TYPE;
        v_rate_margin                   BASKETS.RATE_MARGIN%TYPE;
        v_priority                      NUMBER;
        v_remain_qtty                   NUMBER;             -- the remain quantity of securities(i) of account
        v_remainex_qtty                 NUMBER;
        v_daily_room                    NUMBER;             -- quantity of room is used in day
        v_remain_room                   NUMBER;             -- remain quantity of room has not been used
        v_mark_qtty                     NUMBER;             -- the quantity of securities(i) need to be marked additionally
        v_mark_value                    NUMBER;             -- the amount of securities(i) need to be marked additionally
        p_bod_crlimit                  ACCOUNTS.BOD_CRLIMIT%TYPE;
        v_currtime_log                 varchar2(100);
        v_currtime                     timestamp;
    BEGIN
        p_err_msg:='sp_process_markroom_v4 p_acctno=>'||p_acctno;

        /*BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.1  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        -- The asset has been marked
        v_marked_asset := CSPKS_FO_POOLROOM.fn_get_marked_asset(p_acctno, p_roomid, p_basketid, p_own_basketid,p_err_msg);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'markroom_v4',p_acctno,p_orderid,'v_marked_asset',v_marked_asset);
     /*BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.1.1  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,p_orderid,'v_marked_asset',v_marked_asset);*/

        -- The real debt after deal
        v_real_debt := p_bod_payable + (p_bod_debt_t0 + p_bod_d_margin + p_bod_d_margin_ub) + p_calc_odramt - p_sell_amt - p_bod_balance - TRUNC(p_bod_adv + p_calc_advbal) /*- p_bod_t0value*/;
        --DBMS_OUTPUT.put_line('Real debt after deal: '||TO_CHAR(v_real_debt,'999,999,999,999'));

        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'markroom_v4',p_acctno,p_orderid,'v_real_debt',v_real_debt);
        -- The total amount need be marked
        v_add_mark_value := v_real_debt - v_marked_asset;
        --DBMS_OUTPUT.put_line('Additional Mark Amount: '||TO_CHAR(v_add_mark_value,'999,999,999'));

        SELECT BOD_CRLIMIT INTO p_bod_crlimit FROM ACCOUNTS WHERE ACCTNO=p_acctno;

        v_add_mark_value := Least(p_bod_crlimit, v_real_debt) -   v_marked_asset;

     /*BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.2  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        IF v_add_mark_value > 0 THEN
            p_err_code := '0';
            CSPKS_FO_POOLROOM.sp_get_markable_symbols(c_considered_symbols, p_acctno, p_roomid, p_basketid,p_err_msg);
            --DBMS_OUTPUT.put_line('----- LIST OF CONSIDERED SYMBOLS FOR MARKING -----');
            --v_loan := p_amount;
       BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.3  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');

            LOOP
            FETCH c_considered_symbols INTO v_roomid, v_symbol, v_price_margin, v_rate_margin, v_priority;
                -- Exit LOOP when:
                --    1. Selected symbol list has no rows
                --    2. LOAN(v_add_mark_value) = 0. LOAN is total amount that need be used for buying order
                EXIT WHEN (c_considered_symbols%NOTFOUND OR (v_add_mark_value <= 0));
                --DBMS_OUTPUT.put_line('---Symbol: '||v_symbol);
                --DBMS_OUTPUT.put_line('Priority: '||v_priority);
                --DBMS_OUTPUT.put_line('Price margin: '||v_price_margin);
                --DBMS_OUTPUT.put_line('Rate margin: '||v_rate_margin);
                --CONTINUE WHEN v_priority < 0;
                -- Markable quantity of securities(i) of account
                /*
                 * Editor: Trung.Nguyen
                 * Date: 11-Dec-2015
                 */
                BEGIN
                    SELECT (BUYINGQTTY - (BOD_ST3 + DECODE(v_roomid,'SYSTEM',MARKED,'UB',MARKEDCOM,0))) INTO v_remainex_qtty
                    FROM PORTFOLIOSEX WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                    EXCEPTION
                        WHEN OTHERS THEN v_remainex_qtty:=0;
                END;
                SELECT (TRADE + BUYINGQTTY + RECEIVING - (BOD_ST3 + DECODE(v_roomid,'SYSTEM',MARKED,'UB',MARKEDCOM,0))) + v_remainex_qtty INTO v_remain_qtty
                FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                --DBMS_OUTPUT.put_line('Remain quantity: '||v_remain_qtty);
                CONTINUE WHEN v_remain_qtty <= 0;

                -- Unused quantity of securities(i) of room
                SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
                FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=v_roomid AND SYMBOL=v_symbol;
                --DBMS_OUTPUT.put_line('Daily room: '||v_daily_room);

                SELECT NVL(GRANTED,0) - NVL(INUSED,0) - v_daily_room
                INTO v_remain_room
                FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=v_roomid AND REFSYMBOL=v_symbol;
                --DBMS_OUTPUT.put_line('Remain room: '||v_remain_room);

                -- Quantity of securities(i) that need be marked
                v_mark_qtty := LEAST(CEIL(v_add_mark_value / (v_price_margin * (v_rate_margin / 100))), v_remain_qtty, greatest(v_remain_room,0));
                -- Amount of securities(i) that need be marked
                v_mark_value := v_mark_qtty * (v_price_margin * (v_rate_margin / 100));
                -- Remain additional amount
                v_add_mark_value := v_add_mark_value - v_mark_value;
                --DBMS_OUTPUT.put_line(v_roomid||' - Mark quantity: '||v_mark_qtty);
                --DBMS_OUTPUT.put_line(v_roomid||' - Mark amount: '||v_mark_value);

                -- Update marked quantity of securities(i) to PORTFOLIOS table
                UPDATE PORTFOLIOS SET MARKED = MARKED + DECODE(v_roomid,'SYSTEM',v_mark_qtty,'UB',0), MARKEDCOM = MARKEDCOM + DECODE(v_roomid,'SYSTEM',0,'UB',v_mark_qtty)
                WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;

                -- Insert into ALLOCATION table
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, v_symbol, p_acctno, v_mark_qtty, null, 'D', 'R', null, 0, v_roomid, v_mark_value, 'P', SYSDATE);
                --DBMS_OUTPUT.put_line('--- --- ---');
            END LOOP;
            --DBMS_OUTPUT.put_line('--- FINISH ---');
            CLOSE c_considered_symbols;
       /* BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.4  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/
        END IF;

    /* BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9.5  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/
   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_markroom_v4 '||p_err_msg||' sqlerrm = '||SQLERRM;

    END sp_process_markroom_v4;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_symbol:
     *      p_incr_qtty:    incremental quantity of securities(i) which customer need to buy or editing for previous buying order
     *                      - for buying order, value of p_incr_qtty is equal order quantity
     *                      - for edit incrementally the quantity of buying order, value of p_incr_qtty is subtraction between editing quantity and quantity of previous buying order
     * Description: marking room
     */
    PROCEDURE sp_process_markownroom(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
    BEGIN
      p_err_code := '0';

      -- Insert into ALLOCATION table
      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
      VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, p_symbol, p_acctno, p_incr_qtty, null, 'D', 'R', null, 0, p_roomid, null, 'P', SYSDATE);

--      EXCEPTION
--        WHEN OTHERS THEN p_err_code := '-90025';
    END sp_process_markownroom;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *      p_bod_d_margin_ub:
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_bod_t0value:      guaranteed amount of account
     *      p_orderid:            identifier of order using room
     *      p_side:                 side of order using room (B-buying; AB-amend buying)
     *      p_symbol:
     *      p_incr_qtty: incremental quantity of securities(i) which customer need to buy or editing for previous buying order
     *                             - for buying order, value of p_incr_qtty is equal order quantity
     *                             - for edit incrementally the quantity of buying order, value of p_incr_qtty is subtraction between editing quantity and quantity of previous buying order
     * Description:
     */
     PROCEDURE sp_process_markroom_v5(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_symbol IN VARCHAR,
                p_incr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
      cst_system    CONSTANT    VARCHAR(20) := 'SYSTEM';
      cst_ub          CONSTANT  VARCHAR(20) := 'UB';
      v_count                         NUMBER := 0;
      v_ownroomid                   OWNPOOLROOM.PRID%TYPE;
      v_basketid                    ACCOUNTS.BASKETID%TYPE;
      v_basketid_ub             ACCOUNTS.BASKETID_UB%TYPE;
      p_bod_crlimit               ACCOUNTS.BOD_CRLIMIT%TYPE;
      v_currtime_log varchar2(100);
      v_currtime                  TIMESTAMP;
    BEGIN
      p_err_msg:='sp_process_markroom_v5 p_acctno=>'||p_acctno;
      -- If account has not been granted credit limit then return
      SELECT BOD_CRLIMIT INTO p_bod_crlimit FROM ACCOUNTS WHERE ACCTNO=p_acctno;
      IF (p_bod_crlimit=0) THEN
        RETURN;
      END IF;

/*      BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.1  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

      -- Get the basket is used by account
      SELECT BASKETID, BASKETID_UB INTO v_basketid, v_basketid_ub FROM ACCOUNTS WHERE ACCTNO=p_acctno;
      --dbms_output.put_line('BasketId: '||v_basketid);
      --dbms_output.put_line('BasketId-UB: '||v_basketid_ub);

      SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
      IF (v_count>1) THEN
        -- ERROR
        p_err_code := '-90034';
      ELSIF (v_count=1) THEN

/*           BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.2  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

        -- PROCESS CHECKING FOR OWNPOOLROOM
        SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
        CSPKS_FO_POOLROOM.sp_process_markownroom(p_err_code, p_acctno, v_ownroomid, p_symbol, p_incr_qtty, p_orderid, p_side,p_err_msg);

        IF (p_err_code!='0') THEN
          RETURN;
        END IF;

       /*
       BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.3  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/




        IF (p_roomid=cst_ub AND v_basketid=v_basketid_ub) THEN
          -- PROCESS UB ROOM
          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_ub, v_basketid, v_basketid, 0, 0, p_bod_d_margin_ub, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);


/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.4  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/


          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);

/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.5  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/


          END IF;
        ELSIF (p_roomid=cst_system AND v_basketid=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.6  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/


        ELSIF (p_roomid=cst_system AND v_basketid!=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);


/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.7  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

          -- PROCESS UB ROOM


        CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_ub, v_basketid_ub, v_basketid, 0, 0, 0, p_bod_d_margin_ub, 0, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);

/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.8  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/



         /*
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side);
          END IF;
          */
        ELSE
          -- ERROR
          p_err_code := '-90030';
        END IF;
      ELSIF (v_count=0) THEN
        IF (p_roomid=cst_ub AND v_basketid=v_basketid_ub) THEN
          -- PROCESS UB ROOM
          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_ub, v_basketid, v_basketid, 0, 0, p_bod_d_margin_ub, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
/*      BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.9  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/
        IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.10  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/


          END IF;
        ELSIF (p_roomid=cst_system AND v_basketid=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
/*      BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.11  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/


      ELSIF (p_roomid=cst_system AND v_basketid!=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);

/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.12  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/


          -- PROCESS UB ROOM

          CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_ub, v_basketid_ub, v_basketid, 0, 0, 0, p_bod_d_margin_ub, 0, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);

/*         BEGIN
          EXECUTE IMMEDIATE
          'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
          v_currtime_log:='1.10.2.13  '||v_currtime;
        END;
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue)
        values(SEQ_ttlogs.nextval,'BUY',p_acctno,'',v_currtime_log,'');*/

          /*
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_markroom_v4(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side);
          END IF;
          */
        ELSE
          -- ERROR
          p_err_code := '-90030';
        END IF;
      END IF;

    EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_markroom_v5 '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_markroom_v5;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_bod_t0value:      guaranteed amount of account
     *      p_orderid:            identifier of order using room
     *      p_side:                 side of order using room (CB-cancel buying; AB-amend buying)
     * Description: releasing selected symbols meeting condition
     */
    PROCEDURE sp_process_releaseroom_v3(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_basketid IN VARCHAR,
                p_own_basketid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
        v_marked_asset                  NUMBER;                 -- the asset has been marked currently
        v_real_debt                     NUMBER;                 -- the real debt of account after deal
        v_release_value                 NUMBER;                 -- the total amount which account need to release for trading
        c_releasable_symbols            SYS_REFCURSOR;          -- list of selected symbols that is able to be released
        v_roomid                        POOLROOM.POLICYCD%TYPE;
        v_symbol                        PORTFOLIOS.SYMBOL%TYPE;
        v_price_margin                  BASKETS.PRICE_MARGIN%TYPE;
        v_rate_margin                   BASKETS.RATE_MARGIN%TYPE;
        v_priority                      NUMBER;
        v_marked_qtty                   NUMBER;                 -- the marked quantity of securities(i) of account
        v_remainex_qtty                 NUMBER;
        v_release_qtty                  NUMBER;                 -- the quantity of securities(i) need to be released
        v_release_amt                   NUMBER;                 -- the amount of securities(i) need to be released
        v_count                         NUMBER;
        p_bod_crlimit               ACCOUNTS.BOD_CRLIMIT%TYPE;
    BEGIN
        p_err_msg:='sp_process_releaseroom_v3 p_acctno=>'||p_acctno;
        -- The asset has been marked
        v_marked_asset := CSPKS_FO_POOLROOM.fn_get_marked_asset(p_acctno, p_roomid, p_basketid, p_own_basketid,p_err_msg);
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'releaseroom_v3',p_acctno,p_orderid,'v_marked_asset',v_marked_asset);
        -- The real debt after deal
        v_real_debt := p_bod_payable + (p_bod_debt_t0 + p_bod_d_margin + p_bod_d_margin_ub) + p_calc_odramt - p_sell_amt - p_bod_balance - TRUNC(p_bod_adv + p_calc_advbal) /*- p_bod_t0value*/;
        --DBMS_OUTPUT.put_line('Real debt after deal: '||TO_CHAR(v_real_debt,'999,999,999,999,999'));
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'releaseroom_v3',p_acctno,p_orderid,'v_real_debt',v_real_debt);
        -- The total amount need be released
        SELECT BOD_CRLIMIT INTO p_bod_crlimit FROM ACCOUNTS WHERE ACCTNO=p_acctno;

        v_release_value := v_marked_asset - Least(p_bod_crlimit,v_real_debt);
        --DBMS_OUTPUT.put_line('Total Release Amount: '||TO_CHAR(v_release_value,'999,999,999,999,999'));
        insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'releaseroom_v3',p_acctno,p_orderid,'v_release_value',v_release_value);
        IF v_release_value > 0 THEN
            p_err_code := '0';
            CSPKS_FO_POOLROOM.sp_get_releasable_symbols(c_releasable_symbols, p_acctno, p_roomid, p_basketid,p_err_msg);
            --DBMS_OUTPUT.put_line('----- LIST OF CONSIDERED SYMBOLS FOR RELEASING -----');
            --v_loan := p_amount;
            LOOP
            FETCH c_releasable_symbols INTO v_roomid, v_symbol, v_price_margin, v_rate_margin, v_priority;
                -- Exit LOOP when:
                --    1. Selected symbol list has no rows
                --    2. v_release_value = 0
                EXIT WHEN (c_releasable_symbols%NOTFOUND OR (v_release_value <= 0));
                --DBMS_OUTPUT.put_line('---Symbol: '||v_symbol);
                --DBMS_OUTPUT.put_line('Priority: '||v_priority);
                --DBMS_OUTPUT.put_line('Price margin: '||v_price_margin);
                --DBMS_OUTPUT.put_line('Rate margin: '||v_rate_margin);
                --CONTINUE WHEN v_priority < 0;
                -- Marked quantity of securities(i) of account
                /*
                 * Editor: Trung.Nguyen
                 * Date: 11-Dec-2015
                 */
                BEGIN
                    SELECT DECODE(v_roomid,'SYSTEM',MARKED,'UB',MARKEDCOM,0) INTO v_remainex_qtty
                    FROM PORTFOLIOSEX WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                    EXCEPTION
                        WHEN OTHERS THEN v_remainex_qtty:=0;
                END;

                SELECT DECODE(v_roomid,'SYSTEM',MARKED,'UB',MARKEDCOM,0) + v_remainex_qtty INTO v_marked_qtty
                FROM PORTFOLIOS WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;
                --DBMS_OUTPUT.put_line('Marked quantity: '||v_marked_qtty);
                CONTINUE WHEN v_marked_qtty <= 0;

                -- Quantity of securities(i) that need be released
                --v_release_qtty := LEAST(ROUND(v_release_value / (v_price_asset * (v_rate_asset / 100))), v_marked_qtty);
                v_release_qtty := LEAST(FLOOR(v_release_value / (v_price_margin * (v_rate_margin / 100))), v_marked_qtty);
                insert into ttlogs(autoid,txcode,acctno,orderid,fldname,fldvalue) values(SEQ_ttlogs.nextval,'releaseroom_v3',p_acctno,p_orderid,'v_release_qtty',v_release_qtty);
                CONTINUE WHEN v_release_qtty <= 0;
                -- Amount of securities(i) that need be released
                v_release_amt := v_release_qtty * (v_price_margin * (v_rate_margin / 100));
                -- Remain release value
                v_release_value := v_release_value - v_release_amt;
                --DBMS_OUTPUT.put_line('Release quantity: '||v_release_qtty);
                --DBMS_OUTPUT.put_line('Release amount: '||v_release_amt);
                -- Update marked quantity of securities(i) to PORTFOLIOSEX table

                --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
                  SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = p_acctno AND symbol=v_symbol;
                  IF v_count > 0 THEN
                      UPDATE portfoliosex SET MARKED = MARKED - DECODE(v_roomid,'SYSTEM',v_release_qtty,'UB',0),
                                              MARKEDCOM = MARKEDCOM - DECODE(v_roomid,'SYSTEM',0,'UB',v_release_qtty)
                      WHERE acctno = p_acctno AND symbol=v_symbol;
                  ELSE
                      INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                  VALUES (p_acctno, v_symbol, 0, 0,
                                  0, - DECODE(v_roomid,'SYSTEM',v_release_qtty,'UB',0) , 0, 0, SYSDATE, - DECODE(v_roomid,'SYSTEM',0,'UB',v_release_qtty));
                  END IF;

                --UPDATE PORTFOLIOSEX SET MARKED = MARKED - DECODE(v_roomid,'SYSTEM',v_release_qtty,'UB',0), MARKEDCOM = MARKEDCOM - DECODE(v_roomid,'SYSTEM',0,'UB',v_release_qtty)
                --WHERE ACCTNO=p_acctno AND SYMBOL=v_symbol;

                -- Insert into ALLOCATION table
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, v_symbol, p_acctno, v_release_qtty, null, 'C', 'R', null, 0, v_roomid, v_release_amt, 'P', SYSDATE);
                --DBMS_OUTPUT.put_line('--- --- ---');
            END LOOP;
            --DBMS_OUTPUT.put_line('--- FINISH RELEASEING ---');
            CLOSE c_releasable_symbols;
        END IF;


  EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:=' sp_process_releaseroom_v3 ' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_releaseroom_v3;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_symbol:
     *      p_decr_qtty:  decremental quantity of securities(i) which customer need to cancel buying or editing for previous buying order
     *                              - for cancel buying order, value of p_decr_qtty is equal cancellation order quantity
     *                              - for decreasing the quantity of buying order, value of p_decr_qtty is subtraction between unmatched quantity of previous buying order and editing quantity
     * Description: releasing selected symbols meeting condition
     */
    PROCEDURE sp_process_releaseownroom(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_symbol IN VARCHAR,
                p_decr_qtty IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_err_msg OUT VARCHAR2)
    AS
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_process_releaseownroom p_acctno=>'||p_acctno;
      -- Insert into ALLOCATION table
      --DBMS_OUTPUT.PUT_LINE('Release own room----');
      --DBMS_OUTPUT.PUT_LINE('p_symbol: '||p_symbol);
      --DBMS_OUTPUT.PUT_LINE('p_decr_qtty: '||p_decr_qtty);
      --DBMS_OUTPUT.PUT_LINE('Finish release own room----');
      IF p_decr_qtty > 0 THEN
        INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD, POOLID, POOLVAL, ROOMID, ROOMVAL, STATUS, LASTCHANGE)
        VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, p_symbol, p_acctno, p_decr_qtty, null, 'C', 'R', null, 0, p_roomid, null, 'P', SYSDATE);
      END IF;
   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_releaseownroom '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_releaseownroom;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_acctno:
     *      p_roomid:
     *      p_bod_payable:      custody fees at the begin of day
     *      p_bod_debt:           debt at the begin of day
     *      p_bod_debt_t0:    guaranteed debt at the begin of day
     *      p_bod_d_margin:   margin debt at the begin of day
     *      p_calc_odramt:      total amount has been held for buying orders
     *      p_sell_amt:
     *      p_bod_balance:      cash balance at the begin of day
     *      p_bod_adv:            cash advance at the begin of day of the previous selling orders
     *      p_calc_advbal:      cash advance of the selling orders in day
     *      p_bod_td:               total deposit at the begin of day
     *      p_bod_t0value:
     *      p_orderid:            identifier of order using room
     *      p_side:                 side of order using room (CB-cancel buying; AB-amend buying)
     *      p_symbol:
     *      p_decr_qtty:          decremental quantity of securities(i) which customer need to cancel buying or editing for previous buying order
     *                                  - for cancel buying order, value of p_decr_qtty is equal cancellation order quantity
     *                                  - for decreasing the quantity of buying order, value of p_decr_qtty is subtraction between unmatched quantity of previous buying order and editing quantity
     * Description: releasing selected symbols meeting condition
     */
    PROCEDURE sp_process_releaseroom_v4(p_err_code in OUT VARCHAR,
                p_acctno IN VARCHAR,
                p_roomid IN VARCHAR,
                p_bod_payable IN NUMBER,
                p_bod_debt_t0 IN NUMBER,
                p_bod_d_margin IN NUMBER,
                p_bod_d_margin_ub IN NUMBER,
                p_calc_odramt IN NUMBER,
                p_sell_amt IN NUMBER,
                p_bod_balance IN NUMBER,
                p_bod_adv IN NUMBER,
                p_calc_advbal IN NUMBER,
                p_bod_td IN NUMBER,
                p_bod_t0value IN NUMBER,
                p_orderid IN VARCHAR,
                p_side IN VARCHAR,
                p_symbol IN VARCHAR,
                p_decr_qtty IN NUMBER,
                p_err_msg OUT VARCHAR2)
    AS
      cst_system    CONSTANT    VARCHAR(20) := 'SYSTEM';
      cst_ub          CONSTANT  VARCHAR(20) := 'UB';
      v_count                         NUMBER := 0;
      v_ownroomid                   OWNPOOLROOM.PRID%TYPE;
      v_basketid                    ACCOUNTS.BASKETID%TYPE;
      v_basketid_ub             ACCOUNTS.BASKETID_UB%TYPE;
    BEGIN
      p_err_msg:='sp_process_releaseroom_v4 p_acctno=>'||p_acctno;
      -- Get the basket is used by account
      SELECT BASKETID, BASKETID_UB INTO v_basketid, v_basketid_ub FROM ACCOUNTS WHERE ACCTNO=p_acctno;
      --dbms_output.put_line('BasketId: '||v_basketid);
      --dbms_output.put_line('BasketId-UB: '||v_basketid_ub);

      SELECT COUNT(PRID) INTO v_count FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
      IF (v_count>1) THEN
        -- ERROR
        p_err_code := '-90034';
      ELSIF (v_count=1) THEN
        -- PROCESS OWNPOOLROOM
        SELECT PRID INTO v_ownroomid FROM OWNPOOLROOM WHERE POLICYTYPE='R' AND ACCTNO=p_acctno AND REFSYMBOL=p_symbol;
        CSPKS_FO_POOLROOM.sp_process_releaseownroom(p_err_code, p_acctno, v_ownroomid, p_symbol, p_decr_qtty, p_orderid, p_side,p_err_msg);

        IF (p_err_code!='0') THEN
          RETURN;
        END IF;

        IF (p_roomid=cst_ub AND v_basketid=v_basketid_ub) THEN
          -- PROCESS UB ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_ub, v_basketid, v_basketid, 0, 0, p_bod_d_margin_ub, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          END IF;
        ELSIF (p_roomid=cst_system AND v_basketid=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
        ELSIF (p_roomid=cst_system AND v_basketid!=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          -- PROCESS UB ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_ub, v_basketid_ub, v_basketid, 0, 0, 0, p_bod_d_margin_ub, 0, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          /*
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side);
          END IF;
          */
        ELSE
          -- ERROR
          p_err_code := '-90030';
        END IF;
      ELSIF (v_count=0) THEN
        IF (p_roomid=cst_ub AND v_basketid=v_basketid_ub) THEN
          -- PROCESS UB ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_ub, v_basketid, v_basketid, 0, 0, p_bod_d_margin_ub, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          END IF;
        ELSIF (p_roomid=cst_system AND v_basketid=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
        ELSIF (p_roomid=cst_system AND v_basketid!=v_basketid_ub) THEN
          -- PROCESS SYSTEM ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          -- PROCESS UB ROOM
          CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code,   p_acctno, cst_ub, v_basketid_ub, v_basketid, 0, 0, 0, p_bod_d_margin_ub, 0, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side,p_err_msg);
          /*
          IF (p_err_code='0') THEN
            -- PROCESS SYSTEM ROOM
            CSPKS_FO_POOLROOM.sp_process_releaseroom_v3(p_err_code, p_acctno, cst_system, v_basketid, v_basketid, p_bod_payable, p_bod_debt_t0, p_bod_d_margin, 0, p_calc_odramt, p_sell_amt, p_bod_balance, p_bod_adv, p_calc_advbal, p_bod_td, p_bod_t0value, p_orderid, p_side);
          END IF;
          */
        ELSE
          -- ERROR
          p_err_code := '-90030';
        END IF;
      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_releaseroom_v4' || p_err_msg||' sqlerrm = '||SQLERRM;

    END sp_process_releaseroom_v4;


    /*
     * Author: TrungNQ
     * Parameter: p_acctno
     * Parameter: p_loan
     * Description:
     */
    PROCEDURE sp_process_markroom_v3(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
                p_orderid in VARCHAR, --so hieu lenh
                p_side IN VARCHAR, --mua/ban
                p_symbol IN VARCHAR, --ma chung khoan
                p_qtty IN NUMBER,
                p_roomid IN VARCHAR --ma room
                ,
                p_err_msg OUT VARCHAR2)
    AS
      v_marked_asset_value    NUMBER(20,2); --Gia tri tai san dang duoc danh dau
      v_debt_total                NUMBER(20,2); --Du no quy doi sau giao dich
      v_add_mark_value          NUMBER(20,2); --Gia tri can danh dau them
      c_considered_symbols    SYS_REFCURSOR;
      v_roomid                POOLROOM.POLICYCD%TYPE;
      v_symbol                PORTFOLIOS.SYMBOL%TYPE;
      v_price_asset           BASKETS.PRICE_ASSET%TYPE;
      v_rate_asset            BASKETS.RATE_ASSET%TYPE;
      v_priority              NUMBER;
      v_remain_qtty           NUMBER;
      v_remain_qttyEx         NUMBER;
      v_daily_room            NUMBER;
      v_remain_room           NUMBER;
      v_mark_qtty               NUMBER;
      v_mark_value            NUMBER;
    BEGIN
      p_err_msg:='sp_process_markroom_v3 p_account=>'||p_account;
      --1. Tinh gia tri tai san dang duoc danh dau truoc khi thuc hien danh dau
      CSPKS_FO_POOLROOM.sp_get_marked_asset(p_err_code,p_account,v_marked_asset_value,p_err_msg);
      --DBMS_OUTPUT.put_line('Marked Asset: '||v_marked_asset_value);
      --2. Tinh du no quy doi sau giao dich
      v_debt_total := p_payable + p_debt + p_odramt - p_balance - p_advbal;
       --DBMS_OUTPUT.put_line('p_odramt Total: '||p_odramt);
      --DBMS_OUTPUT.put_line('Debit Total: '||v_debt_total);

      --Gia tri can danh dau
      v_add_mark_value := v_debt_total - v_marked_asset_value;
      --DBMS_OUTPUT.put_line('Additional Mark Amount=============: '||v_add_mark_value);

      IF v_add_mark_value > 0 THEN --thuc hien danh dau
        p_err_code := '0';
        CSPKS_FO_POOLROOM.sp_get_markable_symbols(c_considered_symbols,p_account,null,null,p_err_msg);
        --DBMS_OUTPUT.put_line('--- LIST OF CONSIDERED SYMBOLS FOR MARKING ---');
        --v_loan := p_amount;
        LOOP
          FETCH c_considered_symbols INTO v_roomid, v_symbol, v_price_asset, v_rate_asset, v_priority;
          -- Exit LOOP when:
          --    1. Selected symbol list has no rows
          --    2. LOAN(v_add_mark_value) = 0. LOAN is total amount that need be used for buying order
          EXIT WHEN (c_considered_symbols%NOTFOUND OR (v_add_mark_value <= 0));
          --DBMS_OUTPUT.put_line('Row: '||v_roomid||' ## '||v_symbol||' ## '||v_price_asset||' ## '||v_rate_asset||' ## '||v_priority);
          -- Existing available quantity of securities(i) of account
          SELECT (TRADE + BUYINGQTTY + RECEIVING - (SELLINGQTTY + MARKED)) INTO v_remain_qtty
          FROM PORTFOLIOS WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
          --ThanhNV sua 13/12 check tren bang portfoliosEX de tranh lock row.
          BEGIN
            SELECT (BUYINGQTTY - (SELLINGQTTY + MARKED)) INTO v_remain_qttyEX
            FROM PORTFOLIOSEX WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
          EXCEPTION WHEN OTHERS THEN
            v_remain_qttyEX:=0;
          END;
          v_remain_qtty:=v_remain_qtty + v_remain_qttyEX;
          --
          /*IF v_symbol=p_symbol THEN
            v_remain_qtty := v_remain_qtty + p_qtty;
          END IF;
          */
          --DBMS_OUTPUT.put_line('Remain quantity '||v_symbol||': '||v_remain_qtty);

          -- Unused quantity of securities(i) of room
          SELECT NVL(SUM(DECODE(DOC,'D',NVL(QTTY,0),'C',-NVL(QTTY,0),0)),0) INTO v_daily_room
          FROM ALLOCATION WHERE POLICYCD='R' AND ROOMID=v_roomid AND SYMBOL=v_symbol;
          --DBMS_OUTPUT.put_line('Daily room '||v_symbol||': '||v_daily_room);

          SELECT NVL(GRANTED,0) - NVL(INUSED,0) - v_daily_room
          INTO v_remain_room
          FROM POOLROOM WHERE POLICYTYPE='R' AND POLICYCD=v_roomid AND REFSYMBOL=v_symbol;
          --DBMS_OUTPUT.put_line('Remain room '||v_symbol||': '||v_remain_room);
          -- Quantity of securities(i) that need be marked
          v_mark_qtty := LEAST(CEIL(v_add_mark_value / (v_price_asset * (v_rate_asset / 100))), v_remain_qtty, v_remain_room);
          -- Amount of securities(i) that need be marked
          v_mark_value := v_mark_qtty * (v_price_asset * (v_rate_asset / 100));
          -- Remain additional amount
          v_add_mark_value := v_add_mark_value - v_mark_value;
          --DBMS_OUTPUT.put_line('MRK: '||v_roomid||' ## '||v_symbol||' ## ' ||v_remain_qtty||' ## '||v_remain_room||' ## '||v_mark_qtty||' ## '||v_mark_value);

          -- Update marked quantity of securities(i) to Portfolios table
          UPDATE PORTFOLIOS SET MARKED=MARKED+v_mark_qtty
          WHERE ACCTNO=p_account AND SYMBOL=v_symbol;
          -- Insert into Allocation table
          INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
          VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'D','R', null, 0,p_roomid, v_mark_value, 'P', SYSDATE);
          --DBMS_OUTPUT.put_line('--- Allocation ---');
        END LOOP;
          --DBMS_OUTPUT.put_line('--- FINISH ---');
        CLOSE c_considered_symbols;
      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_markroom_v3 '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_markroom_v3;


    PROCEDURE sp_process_checkpool(p_err_code in OUT VARCHAR,
                f_poolid IN VARCHAR, --ma pool
                p_pool_amt IN  NUMBER  --So tien dung them pool
                ,
                p_err_msg OUT VARCHAR2)
    AS
      v_referr  VARCHAR2(260);
      v_bodvalue    NUMBER;
      v_dailyvalue  NUMBER;
    BEGIN
      p_err_msg:='sp_process_checkpool f_poolid=>'||f_poolid;
      --Get BOD granted value
      SELECT NVL(SUM(GRANTED-INUSED),0) INTO v_bodvalue
      FROM POOLROOM
      WHERE POLICYTYPE='P' AND POLICYCD=f_poolid;
      --dbms_output.put_line('1111111111111111111');
      --Get daily value
      SELECT NVL(SUM(CASE WHEN DOC='D' THEN -NVL(POOLVAL,0) ELSE NVL(POOLVAL,0) END),0) INTO v_dailyvalue
      FROM ALLOCATION
      WHERE POLICYCD= 'P' AND POOLID=f_poolid;
      --Return value
      IF v_bodvalue + v_dailyvalue < p_pool_amt THEN
        p_err_code:='-90014';
        RETURN;
      ELSE
        p_err_code:='0';
      END IF;

      --Neu la UB thi check ca SYSTEM

      IF  f_poolid ='UB' THEN
              SELECT NVL(SUM(GRANTED-INUSED),0) INTO v_bodvalue
              FROM POOLROOM
              WHERE POLICYTYPE='P' AND POLICYCD='SYSTEM';
              --dbms_output.put_line('1111111111111111111');
              --Get daily value
              SELECT NVL(SUM(CASE WHEN DOC='D' THEN -NVL(POOLVAL,0) ELSE NVL(POOLVAL,0) END),0) INTO v_dailyvalue
              FROM ALLOCATION
              WHERE POLICYCD= 'P' AND POOLID='SYSTEM';
              --Return value
              IF v_bodvalue + v_dailyvalue < p_pool_amt THEN
                p_err_code:='-90014';
                RETURN;
              ELSE
                p_err_code:='0';
              END IF;

      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_checkpool '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_checkpool;


    --Check room dua tren tai san
    PROCEDURE sp_process_checkroom(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
                p_symbol IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
    AS
      v_debt_sum  NUMBER;
      v_min_td_odramt NUMBER;
      v_total_value NUMBER;
      v_remain NUMBER;
      v_price_asset NUMBER;
      v_rate_asset NUMBER;
      v_remain_room_value NUMBER;

    BEGIN
      p_err_msg:='sp_process_checkroom p_account=>'||p_account;
    DECLARE
      symbol varchar2(10);
      counter integer :=0;
      v_temp_count integer :=0;
      type symbol_array IS VARRAY(50) OF VARCHAR2(10);
      symbol_list symbol_array := symbol_array();

      BEGIN
        --see FS150
        v_min_td_odramt := p_td;
        IF p_td > p_odramt THEN
            v_min_td_odramt := p_odramt;
        END IF;
        --(1)Du tinh du no quy doi sau giao dich
        -- Trung.Nguyen: please review the factors of this formular
        v_debt_sum := p_amount + p_payable + p_debt + p_odramt + 0 - p_balance - p_advbal - v_min_td_odramt;
        --dbms_output.put_line('1111111111111111111:' || v_debt_sum);

        --(2)Du tinh tong gia tri tai san co the danh dau sau giao dich
        v_total_value := 0;
        --symbol_list.extend;
   /*     SELECT count(1) INTO v_temp_count
        FROM portfolios A,baskets B,accounts C
        WHERE A.acctno = p_account AND C.basketid=B.basketid AND A.symbol = B.symbol and A.acctno=C.acctno AND A.symbol=p_symbol;
        IF v_temp_count > 0 THEN
          SELECT count(1) INTO v_temp_count
          FROM portfolios WHERE symbol=p_symbol;
          IF v_temp_count = 0 THEN
            symbol_list.extend;
            symbol_list(1)  := p_symbol;
          END IF;
        END IF;
        */

        SELECT count(1) INTO v_temp_count FROM portfolios WHERE symbol=p_symbol;
          IF v_temp_count = 0 THEN
            SELECT count(1) INTO v_temp_count
            FROM baskets B,accounts C
            WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol=p_symbol;
            IF v_temp_count > 0 THEN
              symbol_list.extend;
              symbol_list(1)  := p_symbol;
            END IF;
          END IF;

        FOR rec IN --lay ck trong bang portfolios
        (
          SELECT A.symbol,A.trade, A.sellingqtty + NVL(Aex.sellingqtty,0) sellingqtty ,A.buyingqtty + NVL(Aex.buyingqtty,0),B.price_asset,B.rate_asset
          FROM portfolios A,baskets B,accounts C ,portfoliosEX AEX
          WHERE A.acctno = p_account AND C.basketid=B.basketid AND A.symbol = B.symbol and A.acctno=C.acctno
            AND a.acctno = aex.acctno(+) and a.symbol = aex.symbol(+)
        )
        LOOP
           -- Trung.Nguyen: - I think that calculation for available quantity is not right
           --               - Should be: rec.trade + rec.buyingqtty + rec.bod_rt0 + rec.bod_rt1 + rec.bod_rt2
           v_total_value := v_total_value + (rec.trade-rec.sellingqtty)*rec.price_asset*rec.rate_asset;
           counter := counter + 1;
           symbol_list.extend;

           symbol_list(counter)  := rec.symbol;
           --dbms_output.enable;
--           dbms_output.put_line('Symbol:' || symbol_list(counter));
        END LOOP;
--           dbms_output.put_line('22222222222222:');


        FOR rec IN --lay ck trong bang orders
        (
          SELECT A.remain_qtty,A.symbol,B.price_asset,B.rate_asset
          FROM orders A,baskets B,accounts C WHERE A.acctno = p_account
          AND C.basketid=B.basketid AND A.symbol = B.symbol and A.acctno=C.acctno
        )
        LOOP

          v_total_value := v_total_value + rec.remain_qtty*rec.price_asset*rec.rate_asset;

          counter := counter + 1;
          --symbol_list.extend;
          --symbol_list(counter)  := rec.symbol;
          symbol  := rec.symbol;
          --IF symbol member of symbol_list THEN
            --dbms_output.put_line('found');
          --END IF;
          --dbms_output.put_line('v_total_value:' || v_total_value);

        END LOOP;

        --dbms_output.put_line('v_total_value:xxxxxxxxxxxxxxxxxxx' || symbol_list.count);
        --Lay room con lai cua chung khoan
        v_remain_room_value := 0;
--        dbms_output.put_line('33333333333333333: count' || symbol_list.count);
        FOR i IN symbol_list.FIRST..symbol_list.LAST LOOP
        --dbms_output.put_line('99999999999: count' || symbol_list(i));
          SELECT A.granted-inused remain,B.price_asset,B.rate_asset
          INTO v_remain,v_price_asset,v_rate_asset
          FROM poolroom A,baskets B,accounts C
          WHERE A.policytype='R' and A.refsymbol = symbol_list(i) and A.policycd = C.roomid and C.basketid=B.basketid
              and C.acctno = p_account and A.refsymbol = B.symbol;

          v_remain_room_value := v_remain_room_value + (v_remain*v_price_asset*v_rate_asset);

--          DBMS_OUTPUT.PUT_LINE('Element:' || symbol_list(i) || ':' || v_remain);
--          DBMS_OUTPUT.PUT_LINE('v_remain_room_value:' || v_remain_room_value);
        END LOOP;

--        DBMS_OUTPUT.PUT_LINE('v_remain_room_value:222');
--        DBMS_OUTPUT.PUT_LINE('v_remain_room_value:11111' || v_remain_room_value);
        --DBMS_OUTPUT.PUT_LINE('v_total_value:' || v_total_value);
        --lay min cua tai san va room con lai
        IF v_remain_room_value < v_total_value THEN
            v_total_value := v_remain_room_value;
        END IF;
        --DBMS_OUTPUT.PUT_LINE('v_total_value1111111:' || v_total_value);
         --DBMS_OUTPUT.PUT_LINE('v_remain_room_value:' || v_remain_room_value);
        --(3) so sanh
        IF v_debt_sum <= v_remain_room_value THEN --26/12/2014:CU SO SANH VOI v_total_value
            p_err_code := '0'; --du room
        ELSE
          p_err_code := '-90015'; --khong du room
        END IF;

--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := '-90025';
     END;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_process_checkroom' ||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_checkroom;


    --Check room dua tren chung khoan mua
    PROCEDURE sp_process_checkroom_v2(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_roomid IN VARCHAR, --roomid
                p_symbol IN VARCHAR,
                p_price NUMBER,
                p_qtty OUT NUMBER --khoi luong danh dau
                ,
                p_err_msg OUT VARCHAR2)
    AS
      v_mark_qtty  NUMBER;
      v_count INTEGER;
      v_price NUMBER;
      v_rate NUMBER;
      v_bodvalue NUMBER;
      v_dailyvalue NUMBER;
    BEGIN
      p_err_msg:='sp_process_checkroom_v2 p_account=>'||p_account;
      v_count :=0;
      SELECT COUNT(1) INTO v_count FROM baskets B,accounts C
      WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = p_symbol;

      IF v_count >0 THEN
        SELECT B.price_asset, B.rate_asset
        INTO v_price, v_rate
        FROM baskets B,accounts C
        WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = p_symbol;
      ELSE
        p_err_code := '-90015'; --khong du room
        return;
      END IF;


      v_mark_qtty := CEIL(p_amount/(v_price*v_rate/100));
      ---v_mark_qtty := CEIL(p_amount/p_price);
      p_qtty := v_mark_qtty;
         --Get BOD granted value
      SELECT NVL(SUM(GRANTED-INUSED),0) INTO v_bodvalue
      FROM POOLROOM
      WHERE POLICYTYPE='R' AND POLICYCD=p_roomid AND REFSYMBOL=p_symbol;

      --Get daily value
      SELECT NVL(SUM(CASE WHEN DOC='D' THEN -NVL(QTTY,0) ELSE NVL(QTTY,0) END),0) INTO v_dailyvalue
      FROM ALLOCATION
      WHERE POLICYCD= 'R' AND ROOMID=p_roomid AND SYMBOL=p_symbol;

      --Return value
      IF v_bodvalue+v_dailyvalue < v_mark_qtty THEN
        p_err_code:='-90015';
      ELSE
        p_err_code:='0';
      END IF;

   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_checkroom_v2 '||p_err_msg||' sqlerrm = '||SQLERRM;

    END sp_process_checkroom_v2;


    PROCEDURE sp_process_markpool(p_err_code in OUT NUMBER,
                                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                                p_acctno in VARCHAR, --so tieu khoan giao dich
                                f_poolid IN VARCHAR, --ma pool
                                p_amount in NUMBER, --so tien dung pool
                                p_qtty in NUMBER, --khoi luong chung khoan
                                p_price in NUMBER --gia
                ,
                p_err_msg OUT VARCHAR2)
    AS
    BEGIN
--      plog.info('Mark Pool');
      --Mark Pool
      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL, ROOMVAL, STATUS, LASTCHANGE)
      VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, p_symbol, p_acctno, p_qtty, p_price, 'D','P', f_poolid,  p_amount, 0, 'P', SYSDATE);

      --Neu pool UB thi cap nhat ca pool SYSTEM
      IF f_poolid ='UB' THEN
          INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL, ROOMVAL, STATUS, LASTCHANGE)
          VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, p_symbol, p_acctno, p_qtty, p_price, 'D','P', 'SYSTEM',  p_amount, 0, 'P', SYSDATE);
      END IF;
      p_err_code := '0';
--    EXCEPTION
--      WHEN OTHERS THEN
--        p_err_code := '-90025';
    END sp_process_markpool;

    --danh dau tren ca tai san cua khach hang
    /*PROCEDURE sp_process_markroom(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                                p_roomid in VARCHAR --ma room
                )
    AS
      v_marked_asset_value  NUMBER(20,2); --Gia tri tai san dang duoc danh dau
      v_debt_total  NUMBER(20,2); --Du no quy doi sau giao dich
      v_add_mark_value  NUMBER(20,2); --Gia tri can danh dau them
      v_mark_value  NUMBER(20,2); --Gia tri danh dau cho mot ma
      type symbolarray IS VARRAY(50) OF VARCHAR2(10);
      --type unmarkarray IS VARRAY(50) OF NUMBER;
      symbols_list symbolarray := symbolarray();
      unmarks_list num_array := num_array();
      v_symbol VARCHAR2(10);
      v_price NUMBER;
      v_rate NUMBER;
      v_mark_qtty NUMBER;
      --v_mark_value NUMBER;
      v_counter integer :=0;
      hi_list num_array := num_array();
      ki_list num_array := num_array();
      ri_list num_array := num_array();
      v_qi NUMBER;
      v_si NUMBER;
      v_ri NUMBER;
      v_ki NUMBER;
      v_hi NUMBER;
      v_total integer;
      v_index integer;
      v_seq VARCHAR2(20);
    BEGIN
--      plog.info('Begin mark room .....');
      --1. Tinh gia tri tai san dang duoc danh dau truoc khi thuc hien danh dau
      CSPKS_FO_POOLROOM.sp_get_marked_asset(p_err_code,p_account,v_marked_asset_value);
      --2. Tinh du no quy doi sau giao dich
      v_debt_total := p_payable + p_debt + p_odramt - p_balance - p_advbal;

      --Gia tri can danh dau
      v_add_mark_value := v_debt_total - v_marked_asset_value;
      dbms_output.enable;
       dbms_output.put_line('DANH DAU ROOM================================:' || v_add_mark_value);
      --3.Thuc hien danh dau theo thuat toan
      IF v_add_mark_value >0 THEN --thuc hien danh dau
           --plog.info('Bat dau thuc hien danh dau Room');
           --SELECT count(1) into v_count FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO = v_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=v_symbol;
           --lay thong tin
            FOR rec IN
            (
              select p.symbol,(p.trade - p.sellingqtty -p.marked) unmarkeqtty
              from portfolios p, accounts a,baskets b
              where p.acctno = p_account and p.acctno=a.acctno and a.basketid=b.basketid and p.symbol=b.symbol
              --union all SELECT symbol,remain_qtty qtty FROM orders WHERE acctno = '0001000006'
            )
            LOOP
              v_counter := v_counter + 1;

              symbols_list.extend;
              unmarks_list.extend;
              hi_list.extend;
              ki_list.extend;
              symbols_list(v_counter)  := rec.symbol;
              unmarks_list(v_counter) := rec.unmarkeqtty;
              dbms_output.put_line('CHUNG KHOAN CHUA BI DANH DAU, unmarks_list(' || v_counter || '):' || unmarks_list(v_counter));
              --tinh hi,ki
              SELECT SUM(PORTFOLIOS.MARKED), SUM(PORTFOLIOS.TRADE+PORTFOLIOS.MORTGAGE+PORTFOLIOS.RECEIVING)
              INTO v_qi,v_si
              FROM PORTFOLIOS WHERE PORTFOLIOS.SYMBOL = rec.symbol;

              SELECT GRANTED INTO v_ri FROM POOLROOM WHERE REFSYMBOL = rec.symbol AND policycd = p_roomid;

              --dbms_output.put_line('v_ri:' || v_ri);
              IF v_ri > 0 THEN
                  hi_list(v_counter) := v_si/v_ri;
                  ki_list(v_counter) := v_qi/v_ri;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              ELSE
                  hi_list(v_counter) := -1;
                  ki_list(v_counter) := -1;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              END IF;

            END LOOP;

            --thuc hien danh dau
            WHILE v_add_mark_value > 0
            LOOP
              --tim hi nho nhat va >0
               dbms_output.put_line('v_index======1:' || v_index);
              v_index := fn_get_min_value(p_err_code,hi_list);
              IF v_index=-1 THEN
                v_add_mark_value := 0;
                continue;
              END IF;
              v_hi := hi_list(v_index);
              v_symbol := symbols_list(v_index);
              dbms_output.put_line('Chung khoan bi danh dau======:' || v_symbol);
              dbms_output.put_line('hi tuong ung======:' || v_hi);
               --lay gia,ti le cua chung khoan
              SELECT B.price_asset, B.rate_asset
              INTO v_price, v_rate
              FROM baskets B,accounts C
              WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = v_symbol;

              select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

              IF v_hi <=1 THEN
                  v_mark_qtty := ROUND(v_add_mark_value/(v_price*v_rate/100));
                  select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

                  IF v_mark_qtty > unmarks_list(v_index) THEN --can danh dau sang ca ma ck khac
                   dbms_output.put_line('=========================111111:danh dau nhieu ma chung khoan');
                      --TODO: Can lam tron
                      --UPDATE PORTFOLIOS SET MARKED = MARKED + unmarks_list(v_index) WHERE SYMBOL = v_symbol AND acctno = p_account;

                      v_mark_value := (v_price*v_rate/100)*unmarks_list(v_index);
                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account,  unmarks_list(v_index), null, 'D','R', null, 0,p_roomid, v_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - v_mark_value;
                      hi_list(v_index) := -100; --chung khoan nay da dc danh dau va bo ra khoi list
                      ki_list(v_index) := -100;
                  ELSE --chi danh dau ma ck nay
                     -- UPDATE PORTFOLIOS SET MARKED = MARKED + v_mark_qtty WHERE SYMBOL = v_symbol AND acctno = p_account;

                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'D','R', null, 0,p_roomid, v_add_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - (v_price*v_rate/100)*v_mark_qtty;
                      dbms_output.put_line('update qtty:' || unmarks_list(v_index));
                      hi_list(v_index) := -100;
                      ki_list(v_index) := -100;
                      dbms_output.put_line('=========================2222:');
                  END IF;
              ELSE --hi>1
                  --lay ki nho nhat
                  dbms_output.put_line('=========================3333:');
                  v_index := fn_get_min_value(p_err_code,ki_list);
                  IF v_index=-1 THEN
                    v_add_mark_value := 0;
                    continue;
                  END IF;
                  dbms_output.put_line('=========================3333_1:' || v_index);
                  dbms_output.put_line('=========================3333_2:' || hi_list.count);
                  dbms_output.put_line('=========================3333_3:' || hi_list(v_index));
                  v_hi := hi_list(v_index);
                  dbms_output.put_line('=========================3333_2:');
                  v_symbol := symbols_list(v_index);
                  dbms_output.put_line('=========================3333_3:');
                  dbms_output.put_line('v_symbol:' || v_symbol);
                   --lay gia,ti le cua chung khoan
                  SELECT B.price_asset, B.rate_asset
                  INTO v_price, v_rate
                  FROM baskets B,accounts C
                  WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = v_symbol;

                  v_mark_qtty := ROUND(v_add_mark_value/(v_price*v_rate/100));
                  dbms_output.put_line('v_mark_qtty:' || v_mark_qtty);
                  dbms_output.put_line('unmarks_list:' || unmarks_list(v_index));
                  IF v_mark_qtty > unmarks_list(v_index) THEN --can danh dau sang ca ma ck khac
                      --TODO: Can lam tron
                      dbms_output.put_line('=========================4444:');
                      --UPDATE PORTFOLIOS SET MARKED = MARKED + unmarks_list(v_index) WHERE SYMBOL = v_symbol AND acctno = p_account;

                      v_mark_value := (v_price*v_rate/100)*unmarks_list(v_index);

                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'D','R', null, 0,p_roomid, v_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - v_mark_value;
                      hi_list(v_index) := -100; --chung khoan nay da dc danh dau va bo ra khoi list
                      ki_list(v_index) := -100; --chung khoan nay da dc danh dau va bo ra khoi list
                  ELSE --chi danh dau ma ck nay
                       dbms_output.put_line('=========================55555:');
                      --UPDATE PORTFOLIOS SET MARKED = MARKED + v_mark_qtty WHERE SYMBOL = v_symbol AND acctno = p_account;
                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'D','R', null, 0,p_roomid, v_add_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - (v_price*v_rate/100)*v_mark_qtty;
                      dbms_output.put_line('update qtty:' || unmarks_list(v_index));
                      hi_list(v_index) := -100;
                      ki_list(v_index) := -100;
                      dbms_output.put_line('=========================55555:');
                  END IF;

              END IF;
              dbms_output.put_line('v_add_mark_value:=============' || v_add_mark_value);
            END LOOP;
      END IF;

      dbms_output.put_line('KET THUC' );
--      plog.info('End mark room .....');
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
    END sp_process_markroom;
    */

    --Danh dau dua tren hi,ki, chi danh dau tren room tong
    PROCEDURE sp_process_markroom(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER, --tien tiet kiem cong vao suc mua
                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                                p_roomid in VARCHAR --ma room
                ,
                p_err_msg OUT VARCHAR2)
    AS
      v_marked_asset_value  NUMBER(20,2); --Gia tri tai san dang duoc danh dau
      v_debt_total  NUMBER(20,2); --Du no quy doi sau giao dich
      v_add_mark_value  NUMBER(20,2); --Gia tri can danh dau them
      v_mark_value  NUMBER(20,2); --Gia tri danh dau cho mot ma
      type symbolarray IS VARRAY(50) OF VARCHAR2(10);
      symbols_list symbolarray := symbolarray();
      unmarks_list num_array := num_array();
      v_symbol VARCHAR2(10);
      v_price NUMBER;
      v_rate NUMBER;
      v_mark_qtty NUMBER;
      v_counter integer :=0;
      hi_list num_array := num_array();
      ki_list num_array := num_array();
      ri_list num_array := num_array();
      v_qi NUMBER;
      v_si NUMBER;
      v_ri NUMBER;
      v_ki NUMBER;
      v_hi NUMBER;
      v_total integer;
      v_index integer;
      v_seq VARCHAR2(20);
    BEGIN
      --1. Tinh gia tri tai san dang duoc danh dau truoc khi thuc hien danh dau
      CSPKS_FO_POOLROOM.sp_get_marked_asset(p_err_code,p_account,v_marked_asset_value,p_err_msg);
      --2. Tinh du no quy doi sau giao dich
      v_debt_total := p_payable + p_debt + p_odramt - p_balance - p_advbal;

      --Gia tri can danh dau
      v_add_mark_value := v_debt_total - v_marked_asset_value;
      --dbms_output.enable;
       --dbms_output.put_line('DANH DAU ROOM================================:' || p_symbol);
       v_counter := 1;
       symbols_list.extend;
       unmarks_list.extend;
       hi_list.extend;
       ki_list.extend;
       symbols_list(1)  := p_symbol;
       unmarks_list(1) := 1000;
       hi_list(1) := 10;
       ki_list(1) := 10;
      --3.Thuc hien danh dau theo thuat toan
      IF v_add_mark_value >0 THEN --thuc hien danh dau
           --lay thong tin
            FOR rec IN
            (
              select p.symbol,(p.trade - p.sellingqtty -p.marked - NVL(pex.sellingqtty,0) - NVL(pex.marked,0)) unmarkeqtty
              from portfolios p, accounts a,baskets b , portfoliosex pex
              where p.acctno = p_account and p.acctno=a.acctno and a.basketid=b.basketid and p.symbol=b.symbol
                and p.acctno = pex.acctno(+) and p.symbol =pex.symbol(+)
            )
            LOOP
              v_counter := v_counter + 1;

              symbols_list.extend;
              unmarks_list.extend;
              hi_list.extend;
              ki_list.extend;
              symbols_list(v_counter)  := rec.symbol;
              unmarks_list(v_counter) := rec.unmarkeqtty;
              --dbms_output.put_line('CHUNG KHOAN CHUA BI DANH DAU, unmarks_list(' || v_counter || '):' || unmarks_list(v_counter));
              --tinh hi,ki
              SELECT SUM(PORTFOLIOS.MARKED + NVL(PEX.MARKED,0)), SUM(PORTFOLIOS.TRADE+PORTFOLIOS.MORTGAGE+PORTFOLIOS.RECEIVING)
              INTO v_qi,v_si
              FROM PORTFOLIOS, PORTFOLIOSEX PEX  WHERE PORTFOLIOS.SYMBOL = rec.symbol AND PORTFOLIOS.SYMBOL =PEX.SYMBOL(+);

              SELECT GRANTED INTO v_ri FROM POOLROOM WHERE REFSYMBOL = rec.symbol AND policycd = p_roomid;

              --dbms_output.put_line('v_ri:' || v_ri);
              IF v_ri > 0 THEN
                  hi_list(v_counter) := v_si/v_ri;
                  ki_list(v_counter) := v_qi/v_ri;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              ELSE
                  hi_list(v_counter) := -1;
                  ki_list(v_counter) := -1;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              END IF;

            END LOOP;

            --thuc hien danh dau
            --tim hi nho nhat va >0
            --dbms_output.put_line('v_index======1:' || v_index);
            --dbms_output.put_line('hi_list======1:' || hi_list.COUNT);
            v_index := fn_get_min_value(p_err_code,hi_list,p_err_msg);
            --dbms_output.put_line('v_index======2:' || v_index);
            --dbms_output.put_line('symbols_list======1:' || symbols_list(1));
            v_hi := hi_list(v_index);
            v_symbol := symbols_list(v_index);
            --dbms_output.put_line('Chung khoan bi danh dau======:' || v_symbol);
            --dbms_output.put_line('hi tuong ung======:' || v_hi);
             --lay gia,ti le cua chung khoan
            SELECT B.price_asset, B.rate_asset
            INTO v_price, v_rate
            FROM baskets B,accounts C
            WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = v_symbol;

            select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

           --v_mark_qtty := ROUND(v_add_mark_value/(v_price*v_rate/100));
            v_mark_qtty := CEIL(v_add_mark_value/(v_price*v_rate/100));
            IF v_hi <=1 THEN
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'D','R', null, 0,p_roomid, v_add_mark_value, 'P', SYSDATE);
            ELSE --hi>1 TODO
                INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'D','R', null, 0,p_roomid, v_add_mark_value, 'P', SYSDATE);
            END IF;
      END IF;

      --dbms_output.put_line('KET THUC' );
--    EXCEPTION
--      WHEN OTHERS THEN
--        p_err_code := '-90025';
    END sp_process_markroom;

     --Danh dau tren chung khoan mua
    PROCEDURE sp_process_markroom_v2(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_roomid in VARCHAR, --ma room
                p_symbol in VARCHAR, --ma ck
                p_qtty in VARCHAR --khoi luong danh dau
               ,
                p_err_msg OUT VARCHAR2 )
    AS
      v_seq VARCHAR2(20);
    BEGIN

      SELECT SEQ_COMMON.NEXTVAL INTO v_seq FROM DUAL;
      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO,
                  QTTY, PRICE, DOC, POLICYCD,POOLID,
                  POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
          VALUES (v_seq, p_orderid, p_side, p_symbol, p_account,
                  p_qtty, null, 'D','R', null,
                  0,p_roomid, p_amount, 'P', SYSDATE);

      UPDATE PORTFOLIOS SET MARKED = MARKED + p_qtty WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
      --dbms_output.put_line('KET THUC' );
--    EXCEPTION
--      WHEN OTHERS THEN
--        p_err_code := '-90025';
    END sp_process_markroom_v2;

    PROCEDURE sp_get_marked_asset(p_err_code in OUT VARCHAR,
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_amount IN OUT NUMBER --gia tri tai san dang danh dau cua tieu khoan
               ,
                p_err_msg OUT VARCHAR2)
    AS
      --v_referr    VARCHAR2(260);
      --v_bodvalue  NUMBER;
      v_total_value NUMBER(20,2);
    BEGIN
       p_err_msg:='sp_get_marked_asset';
       v_total_value :=0;
        FOR rec IN --lay ck dang duoc danh dau trong bang portfolios
        (
          SELECT A.symbol,A.marked + NVL(Aex.marked,0) marked, B.price_asset,B.rate_asset
          FROM portfolios A,baskets B,accounts C , portfoliosEx Aex
          WHERE A.acctno = p_account AND C.basketid=B.basketid AND A.symbol = B.symbol and A.acctno=C.acctno
            AND A.acctno = Aex.acctno(+) AND A.symbol =Aex.symbol(+)
        )
        LOOP
           v_total_value := v_total_value + rec.marked*rec.price_asset*rec.rate_asset/100;
           --dbms_output.enable;
           --dbms_output.put_line('v_total_value1111:' || v_total_value);
        END LOOP;


        FOR rec IN --lay ck dang duoc danh dau trong bang orders
        (
          SELECT A.marked,A.symbol,B.price_asset,B.rate_asset
          FROM orders A,baskets B,accounts C WHERE A.acctno = p_account
          AND C.basketid=B.basketid AND A.symbol = B.symbol and A.acctno=C.acctno
        )
        LOOP
          v_total_value := v_total_value + rec.marked*rec.price_asset*rec.rate_asset/100;
          --dbms_output.put_line('v_total_value:22222' || v_total_value);

        END LOOP;

        p_amount := nvl(v_total_value,0);
   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_get_marked_asset '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_get_marked_asset;



    PROCEDURE sp_process_releasepool(p_err_code in OUT NUMBER,
                                p_orderid in VARCHAR, --so hieu lenh
                                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                                p_acctno in VARCHAR, --so tieu khoan giao dich
                                p_poolid in VARCHAR, --ma pool
                                p_amount in NUMBER, --so tien dung pool
                                p_qtty in NUMBER, --khoi luong chung khoan
                                p_price in NUMBER --gia
                ,
                p_err_msg OUT VARCHAR2)
    AS
      --v_referr    VARCHAR2(260);
      --v_bodvalue  NUMBER;
      --v_dailyvalue    NUMBER;
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_process_releasepool p_orderid=>'||p_orderid;
--      plog.info('Release Pool');
      --Mark Pool
       --dbms_output.put_line('ALLOCATION=================================');
      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL, ROOMVAL, STATUS, LASTCHANGE)
      VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, p_symbol, p_acctno, p_qtty, p_price, 'C','P', p_poolid,  p_amount, 0, 'P', SYSDATE);

      --Neu pool UB thi cap nhat ca pool SYSTEM
      IF p_poolid ='UB' THEN
            INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL, ROOMVAL, STATUS, LASTCHANGE)
                VALUES (SEQ_COMMON.NEXTVAL, p_orderid, p_side, p_symbol, p_acctno, p_qtty, p_price, 'C','P', 'SYSTEM',  p_amount, 0, 'P', SYSDATE);
      END IF;

      --dbms_output.put_line('ALLOCATION=================================');

      --dbms_output.put_line('p_amount : ' || p_amount);



   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_releasepool '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_releasepool;

    /*
    PROCEDURE sp_process_releaseroom(p_err_code in OUT VARCHAR,
                p_orderid in VARCHAR, --so hieu lenh
                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_roomid in VARCHAR, --ma room
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER --tien tiet kiem cong vao suc mua
                )
    AS
      v_marked_asset_value  NUMBER(20,2); --Gia tri tai san dang duoc danh dau
      v_debt_total  NUMBER(20,2); --Du no quy doi sau giao dich
      v_add_mark_value  NUMBER(20,2); --Gia tri can danh dau them
      v_mark_value  NUMBER(20,2); --Gia tri danh dau cho mot ma
      type symbolarray IS VARRAY(50) OF VARCHAR2(10);
      --type unmarkarray IS VARRAY(50) OF NUMBER;
      symbols_list symbolarray := symbolarray();
      unmarks_list num_array := num_array();
      v_symbol VARCHAR2(10);
      v_price NUMBER;
      v_rate NUMBER;
      v_mark_qtty NUMBER;
      --v_mark_value NUMBER;
      v_counter integer :=0;
      hi_list num_array := num_array();
      ki_list num_array := num_array();
      ri_list num_array := num_array();
      v_qi NUMBER;
      v_si NUMBER;
      v_ri NUMBER;
      v_ki NUMBER;
      v_hi NUMBER;
      v_total integer;
      v_index integer;
      v_seq VARCHAR2(20);
    BEGIN
--      plog.info('Begin mark room .....');
      --1. Tinh gia tri tai san dang duoc danh dau truoc khi thuc hien danh dau
      CSPKS_FO_POOLROOM.sp_get_marked_asset(p_err_code,p_account,v_marked_asset_value);
      --2. Tinh du no quy doi sau giao dich
      v_debt_total := p_payable + p_debt + p_odramt - p_balance - p_advbal;

      --Gia tri can danh dau
      v_add_mark_value := v_debt_total - v_marked_asset_value;
      dbms_output.enable;
       dbms_output.put_line('NHA DANH DAU ROOM================================:');
      --3.Thuc hien danh dau theo thuat toan
      IF v_add_mark_value >0 THEN --thuc hien danh dau
           --plog.info('Bat dau thuc hien danh dau Room');
           --SELECT count(1) into v_count FROM BASKETS B,ACCOUNTS A WHERE A.ACCTNO = v_acctno AND A.BASKETID=B.BASKETID AND B.SYMBOL=v_symbol;
           --lay thong tin
            FOR rec IN
            (
              select p.symbol,(p.trade - p.sellingqtty -p.marked) unmarkeqtty
              from portfolios p, accounts a,baskets b
              where p.acctno = p_account and p.acctno=a.acctno and a.basketid=b.basketid and p.symbol=b.symbol
              --union all SELECT symbol,remain_qtty qtty FROM orders WHERE acctno = '0001000006'
            )
            LOOP
              v_counter := v_counter + 1;

              symbols_list.extend;
              unmarks_list.extend;
              hi_list.extend;
              ki_list.extend;
              symbols_list(v_counter)  := rec.symbol;
              unmarks_list(v_counter) := rec.unmarkeqtty;
              dbms_output.put_line('CHUNG KHOAN CHUA BI DANH DAU, unmarks_list(' || v_counter || '):' || unmarks_list(v_counter));
              --tinh hi,ki
              SELECT SUM(PORTFOLIOS.MARKED), SUM(PORTFOLIOS.TRADE+PORTFOLIOS.MORTGAGE+PORTFOLIOS.RECEIVING)
              INTO v_qi,v_si
              FROM PORTFOLIOS WHERE PORTFOLIOS.SYMBOL = rec.symbol;

              SELECT GRANTED INTO v_ri FROM POOLROOM WHERE REFSYMBOL = rec.symbol AND policycd = p_roomid;

              --dbms_output.put_line('v_ri:' || v_ri);
              IF v_ri > 0 THEN
                  hi_list(v_counter) := v_si/v_ri;
                  ki_list(v_counter) := v_qi/v_ri;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              ELSE
                  hi_list(v_counter) := -1;
                  ki_list(v_counter) := -1;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              END IF;

            END LOOP;

            --thuc hien danh dau
            WHILE v_add_mark_value > 0
            LOOP
              --tim hi nho nhat va >0
              v_index := fn_get_max_value(p_err_code,hi_list);
              IF v_index=-1 THEN
                v_add_mark_value := 0;
                continue;
              END IF;

              v_hi := hi_list(v_index);
              v_symbol := symbols_list(v_index);
              dbms_output.put_line('Chung khoan bi danh dau======:' || v_symbol);
              dbms_output.put_line('hi tuong ung======:' || v_hi);
               --lay gia,ti le cua chung khoan
              SELECT B.price_asset, B.rate_asset
              INTO v_price, v_rate
              FROM baskets B,accounts C
              WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = v_symbol;

              select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

              IF v_hi <=1 THEN
                  v_mark_qtty := ROUND(v_add_mark_value/(v_price*v_rate/100));
                  select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

                  IF v_mark_qtty > unmarks_list(v_index) THEN --can danh dau sang ca ma ck khac
                   dbms_output.put_line('=========================111111:danh dau nhieu ma chung khoan');
                      --TODO: Can lam tron
                     -- UPDATE PORTFOLIOS SET MARKED = MARKED + unmarks_list(v_index) WHERE SYMBOL = v_symbol AND acctno = p_account;

                      v_mark_value := (v_price*v_rate/100)*unmarks_list(v_index);
                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account,  unmarks_list(v_index), null, 'C','R', null, 0,p_roomid, v_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - v_mark_value;
                      hi_list(v_index) := -100; --chung khoan nay da dc danh dau va bo ra khoi list
                      ki_list(v_index) := -100;
                  ELSE --chi danh dau ma ck nay
                      --UPDATE PORTFOLIOS SET MARKED = MARKED + v_mark_qtty WHERE SYMBOL = v_symbol AND acctno = p_account;

                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'C','R', null, 0,p_roomid, v_add_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - (v_price*v_rate/100)*v_mark_qtty;
                      dbms_output.put_line('update qtty:' || unmarks_list(v_index));
                      hi_list(v_index) := -100;
                      ki_list(v_index) := -100;
                      dbms_output.put_line('=========================2222:');
                  END IF;
              ELSE --hi>1
                  --lay ki nho nhat
                  dbms_output.put_line('=========================333322:');
                  v_index := fn_get_max_value(p_err_code,ki_list);
                  v_hi := hi_list(v_index);
                  v_symbol := symbols_list(v_index);
                  dbms_output.put_line('v_symbol:' || v_symbol);
                   --lay gia,ti le cua chung khoan
                  SELECT B.price_asset, B.rate_asset
                  INTO v_price, v_rate
                  FROM baskets B,accounts C
                  WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = v_symbol;

                  v_mark_qtty := ROUND(v_add_mark_value/(v_price*v_rate/100));
                  dbms_output.put_line('v_mark_qtty:' || v_mark_qtty);
                  dbms_output.put_line('unmarks_list:' || unmarks_list(v_index));
                  IF v_mark_qtty > unmarks_list(v_index) THEN --can danh dau sang ca ma ck khac
                      --TODO: Can lam tron
                      dbms_output.put_line('=========================4444:');
                      --UPDATE PORTFOLIOS SET MARKED = MARKED + unmarks_list(v_index) WHERE SYMBOL = v_symbol AND acctno = p_account;

                      v_mark_value := (v_price*v_rate/100)*unmarks_list(v_index);

                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'C','R', null, 0,p_roomid, v_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - v_mark_value;
                      hi_list(v_index) := -100; --chung khoan nay da dc danh dau va bo ra khoi list
                      ki_list(v_index) := -100; --chung khoan nay da dc danh dau va bo ra khoi list
                  ELSE --chi danh dau ma ck nay
                       dbms_output.put_line('=========================55555:');
                      --UPDATE PORTFOLIOS SET MARKED = MARKED + v_mark_qtty WHERE SYMBOL = v_symbol AND acctno = p_account;
                      INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
                      VALUES (v_seq, p_orderid, p_side, v_symbol, p_account, v_mark_qtty, null, 'C','R', null, 0,p_roomid, v_add_mark_value, 'P', SYSDATE);

                      v_add_mark_value := v_add_mark_value - (v_price*v_rate/100)*v_mark_qtty;
                      dbms_output.put_line('update qtty:' || unmarks_list(v_index));
                      hi_list(v_index) := -100;
                      ki_list(v_index) := -100;
                      dbms_output.put_line('=========================55555:');
                  END IF;

              END IF;
              dbms_output.put_line('v_add_mark_value:' || v_add_mark_value);
            END LOOP;
      END IF;

      dbms_output.put_line('KET THUC' );
--      plog.info('End mark room .....');
    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
    END sp_process_releaseroom; */

    --Nha danh dau tren chung khoan co trong tai khoan
    PROCEDURE sp_process_releaseroom(p_err_code in OUT VARCHAR,
                p_orderid in VARCHAR, --so hieu lenh
                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_roomid in VARCHAR, --ma room
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_balance IN NUMBER, --so du tien mat
                p_advbal IN NUMBER, --tien ung truoc tu dong
                p_payable IN  NUMBER, --no phi, no thue
                p_debt IN  NUMBER, --no margin
                p_odramt IN  NUMBER, --ky quy mua trong ngay
                p_td IN  NUMBER --tien tiet kiem cong vao suc mua
                ,
                p_err_msg OUT VARCHAR2)
    AS
      v_marked_asset_value  NUMBER(20,2); --Gia tri tai san dang duoc danh dau
      v_debt_total  NUMBER(20,2); --Du no quy doi sau giao dich
      v_add_mark_value  NUMBER(20,2); --Gia tri can danh dau them
      v_mark_value  NUMBER(20,2); --Gia tri danh dau cho mot ma
      type symbolarray IS VARRAY(50) OF VARCHAR2(10);
      --type unmarkarray IS VARRAY(50) OF NUMBER;
      symbols_list symbolarray := symbolarray();
      unmarks_list num_array := num_array();
      v_symbol VARCHAR2(10);
      v_price NUMBER;
      v_rate NUMBER;
      v_mark_qtty NUMBER;
      --v_mark_value NUMBER;
      v_counter integer :=0;
      hi_list num_array := num_array();
      ki_list num_array := num_array();
      ri_list num_array := num_array();
      v_qi NUMBER;
      v_si NUMBER;
      v_ri NUMBER;
      v_ki NUMBER;
      v_hi NUMBER;
      v_total integer;
      v_index integer;
      v_seq VARCHAR2(20);
    BEGIN
      p_err_msg:='sp_process_releaseroom p_orderid=>'||p_orderid;
--      plog.info('Begin mark room .....');
      --1. Tinh gia tri tai san dang duoc danh dau truoc khi thuc hien danh dau
      CSPKS_FO_POOLROOM.sp_get_marked_asset(p_err_code,p_account,v_marked_asset_value,p_err_msg);
      --2. Tinh du no quy doi sau giao dich
      v_debt_total := p_payable + p_debt + p_odramt - p_balance - p_advbal;

      --Gia tri can danh dau
      v_add_mark_value := v_debt_total - v_marked_asset_value;
      --dbms_output.enable;
       --dbms_output.put_line('NHA DANH DAU ROOM================================:');
      --3.Thuc hien danh dau theo thuat toan
      IF v_add_mark_value >0 THEN --thuc hien nha danh dau
           --lay thong tin
            FOR rec IN
            (
              select p.symbol,(p.trade - p.sellingqtty -p.marked - NVL(pex.sellingqtty,0) -NVL(pex.marked,0)) unmarkeqtty
              from portfolios p, accounts a,baskets b , portfoliosEX pex
              where p.acctno = p_account and p.acctno=a.acctno and a.basketid=b.basketid and p.symbol=b.symbol
              and   p.acctno =pex.acctno(+) and  p.symbol= pex.symbol(+)
              --union all SELECT symbol,remain_qtty qtty FROM orders WHERE acctno = '0001000006'
            )
            LOOP
              v_counter := v_counter + 1;

              symbols_list.extend;
              unmarks_list.extend;
              hi_list.extend;
              ki_list.extend;
              symbols_list(v_counter)  := rec.symbol;
              unmarks_list(v_counter) := rec.unmarkeqtty;
              --dbms_output.put_line('CHUNG KHOAN CHUA BI DANH DAU, unmarks_list(' || v_counter || '):' || unmarks_list(v_counter));
              --tinh hi,ki
              SELECT SUM(PORTFOLIOS.MARKED + NVL(PEX.MARKED,0)), SUM(PORTFOLIOS.TRADE+PORTFOLIOS.MORTGAGE+PORTFOLIOS.RECEIVING)
              INTO v_qi,v_si
              FROM PORTFOLIOS, PORTFOLIOSEX PEX  WHERE  PORTFOLIOS.SYMBOL = PEX.SYMBOL(+) AND PORTFOLIOS.SYMBOL = rec.symbol;

              SELECT GRANTED INTO v_ri FROM POOLROOM WHERE REFSYMBOL = rec.symbol AND policycd = p_roomid;

              --dbms_output.put_line('v_ri:' || v_ri);
              IF v_ri > 0 THEN
                  hi_list(v_counter) := v_si/v_ri;
                  ki_list(v_counter) := v_qi/v_ri;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              ELSE
                  hi_list(v_counter) := -1;
                  ki_list(v_counter) := -1;
                  --dbms_output.put_line('hi:' || v_si/v_ri);
              END IF;

            END LOOP;

            --thuc hien nha danh dau
            --tim hi nho nhat va >0
            v_index := fn_get_max_value(p_err_code,hi_list,p_err_msg);
            v_hi := hi_list(v_index);
            v_symbol := symbols_list(v_index);
            --dbms_output.put_line('Chung khoan bi danh dau======:' || v_symbol);
            --dbms_output.put_line('hi tuong ung======:' || v_hi);
             --lay gia,ti le cua chung khoan
            SELECT B.price_asset, B.rate_asset
            INTO v_price, v_rate
            FROM baskets B,accounts C
            WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = v_symbol;

            select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

            v_mark_qtty := FLOOR(v_add_mark_value/(v_price*v_rate/100));
            select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;

            v_mark_value := (v_price*v_rate/100)*unmarks_list(v_index);
            INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO, QTTY, PRICE, DOC, POLICYCD,POOLID, POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
            VALUES (v_seq, p_orderid, p_side, v_symbol, p_account,  unmarks_list(v_index), null, 'C','R', null, 0,p_roomid, p_amount/*v_mark_value*/, 'P', SYSDATE);
            --dbms_output.put_line('=========================insert success1');

      END IF;

      --dbms_output.put_line('KET THUC' );
--      plog.info('End mark room .....');
   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_releaseroom '|| p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_releaseroom;

    --Nha danh dau dua tren chung khoan dang giao dich
    PROCEDURE sp_process_releaseroom_v2(p_err_code in OUT VARCHAR,
                p_orderid in VARCHAR, --so hieu lenh
                p_side in VARCHAR, --mua/ban
                                p_symbol in VARCHAR, --ma chung khoan
                p_account IN VARCHAR, --so tieu khoan giao dich
                p_roomid in VARCHAR, --ma room
                                p_amount IN NUMBER, --so tien dung them cua giao dich
                p_qtty NUMBER, --khoi luong
                p_price NUMBER --gia
                ,
                p_err_msg OUT VARCHAR2)
    AS
      v_seq VARCHAR2(20);
      v_unmark_qtty NUMBER;
      v_count NUMBER;
      v_price NUMBER;
      v_rate NUMBER;
      v_mark NUMBER;
      v_markEX NUMBER;
    BEGIN
      p_err_msg:='sp_process_releaseroom_v2 p_orderid=>'||p_orderid;
      SELECT COUNT(1)  INTO v_count FROM PORTFOLIOS WHERE ACCTNO = p_account AND SYMBOL=p_symbol AND MARKED > 0;
      IF v_count <=0 THEN
        return;
      ELSE
          v_count :=0;
          SELECT COUNT(1) INTO v_count FROM baskets B,accounts C
          WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = p_symbol;

          SELECT MARKED  INTO v_mark FROM PORTFOLIOS WHERE ACCTNO = p_account AND SYMBOL=p_symbol AND MARKED > 0;
          BEGIN
             SELECT MARKED  INTO v_markEX FROM PORTFOLIOSEX WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
          EXCEPTION WHEN OTHERS THEN
            v_markEX:=0;
          END;
          v_mark:= v_mark + v_markEX;

          IF v_count >0 THEN
            SELECT B.price_asset, B.rate_asset
            INTO v_price, v_rate
            FROM baskets B,accounts C
            WHERE C.acctno = p_account AND C.basketid=B.basketid AND B.symbol = p_symbol;

            v_unmark_qtty := CEIL(p_amount/(v_price*v_rate/100));
            v_unmark_qtty := LEAST(v_mark,v_unmark_qtty);
          ELSE
            v_unmark_qtty := LEAST(v_mark,p_qtty);
          END IF;

          select SEQ_COMMON.NEXTVAL into v_seq FROM DUAL;
          INSERT INTO ALLOCATION (AUTOID, ORDERID, SIDE, SYMBOL, ACCTNO,
                      QTTY, PRICE, DOC, POLICYCD,POOLID,
                      POOLVAL,ROOMID, ROOMVAL, STATUS, LASTCHANGE)
          VALUES (v_seq, p_orderid, p_side, p_symbol, p_account,
                  v_unmark_qtty, null, 'C','R', null,
                  0,p_roomid, p_amount/*v_mark_value*/, 'P', SYSDATE);

          UPDATE PORTFOLIOS SET MARKED = MARKED - v_unmark_qtty WHERE ACCTNO = p_account AND SYMBOL=p_symbol;
      END IF;


      --dbms_output.put_line('KET THUC' );
   EXCEPTION
       WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_process_releaseroom_v2 '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_process_releaseroom_v2;

END CSPKS_FO_POOLROOM;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_POOLROOM

