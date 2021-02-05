create or replace PACKAGE CSPKS_FO_GW_HSX AS

   PROCEDURE sp_proces_msg_2b(p_err_code in OUT VARCHAR,
            p_firm IN VARCHAR, --Ma cong ty thanh vien
            p_order_number IN VARCHAR, --so hieu lenh cua so
            p_order_entry_date IN VARCHAR, --
            p_order_id OUT VARCHAR,
            p_err_msg OUT VARCHAR2
            );

   PROCEDURE sp_proces_msg_2c(p_err_code in OUT VARCHAR,
            p_new_orderid in OUT VARCHAR,--order id cua lenh moi (phan sua lenh)
            p_firm IN VARCHAR, --Ma cong ty thanh vien
            p_cancel_shares IN NUMBER, --
            p_order_number IN VARCHAR, --
            p_order_entry_date IN VARCHAR,
            p_order_cancel_status_alph IN VARCHAR,
            p_order_id OUT VARCHAR,
            p_err_msg OUT VARCHAR2
          );
    PROCEDURE sp_proces_msg_2c_fail(p_err_code in OUT VARCHAR,
            p_new_orderid in OUT VARCHAR,--order id cua lenh moi (phan sua lenh)
            p_firm IN VARCHAR, --Ma cong ty thanh vien
            p_cancel_shares IN NUMBER, --
            p_order_number IN VARCHAR, --
            p_order_entry_date IN VARCHAR,
            p_order_cancel_status_alph IN VARCHAR,
            p_order_id OUT VARCHAR,
            p_err_msg OUT VARCHAR2
          );

     --thong tin thay doi lenh, cho lenh MP
   PROCEDURE sp_proces_msg_2d(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_ordernumber IN VARCHAR, --
          p_orderentrydate IN VARCHAR, --
          p_clientid_alph IN VARCHAR,
          p_port_clientflag_alph IN VARCHAR,
          p_published_volume IN NUMBER,
          p_price IN NUMBER,
          p_filler IN VARCHAR,
          p_order_id OUT VARCHAR,
          p_err_msg OUT VARCHAR2
        );

   PROCEDURE sp_proces_msg_2g(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_reject_reason_code IN VARCHAR, --
          p_original_message_text IN VARCHAR,
          p_order_id IN OUT VARCHAR, --So hieu lenh cua cong ty chung khoan
          f_cancel_qtty OUT NUMBER,
          p_err_msg OUT VARCHAR2
        );

    --Khop cung cong ty
    PROCEDURE sp_proces_msg_2i(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_order_number_buy IN VARCHAR, -- so hieu lenh mua
          p_order_entry_date_buy IN VARCHAR, --ngay giao dich lenh mua
          p_order_number_sell IN VARCHAR,--so hieu lenh ban
          p_order_entry_date_sell IN VARCHAR,--ngay giao dich lenh ban
          p_volume IN NUMBER,--khoi luong khop
          p_price IN NUMBER,--gia khop
          p_confirm_number IN VARCHAR,
          p_order_id_buy OUT VARCHAR, --So hieu lenh cua cong ty chung khoan, mua
          p_order_id_sell OUT VARCHAR,
          p_err_msg OUT VARCHAR2
        );

    --Khop khac cong ty
    PROCEDURE sp_proces_msg_2e(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_side IN VARCHAR, -- mua hay ban
          p_order_number IN VARCHAR, --so hieu lenh
          p_order_entry_date IN VARCHAR,--ngay giao dich lenh
          p_fillter IN VARCHAR,--
          p_volume IN NUMBER,--khoi luong khop
          p_price IN NUMBER,--gia khop
          p_confirm_number IN VARCHAR,
          p_order_id OUT VARCHAR,
          p_err_msg OUT VARCHAR2
        );

     --
    PROCEDURE sp_proces_msg_2f(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_trader_id_buy IN VARCHAR, --
          p_side IN VARCHAR, -- mua hay ban
          p_contra_firm IN VARCHAR, --ma thanh vien ben ban
          p_trader_id_sell IN VARCHAR, --
          p_symbol IN VARCHAR, --ma chung khoan
          p_volume IN NUMBER,--khoi luong khop
          p_price IN NUMBER,--gia khop
          p_confirm_number IN VARCHAR,
          p_err_msg OUT VARCHAR2
        );

      PROCEDURE sp_proces_msg_2l(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_side IN VARCHAR, -- mua hay ban
          p_deal_id IN VARCHAR, --
          p_contra_firm IN VARCHAR, --
          p_volume IN NUMBER,--khoi luong khop
          p_price IN NUMBER,--gia khop
          p_confirm_number IN VARCHAR,
          f_orderid_s OUT VARCHAR,
          f_orderid_b OUT VARCHAR,
          p_err_msg OUT VARCHAR2
      );


       PROCEDURE sp_proces_msg_3b(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_confirm_number IN VARCHAR,
          p_deal_id IN VARCHAR, --
          p_client_id IN VARCHAR, --
          p_reply_code IN VARCHAR, --
          f_orderid OUT VARCHAR,
          f_cancel_number OUT VARCHAR,
          p_err_msg OUT VARCHAR2
      );

       PROCEDURE sp_proces_msg_3c(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_confirm_number IN VARCHAR,
          p_contra_firm IN VARCHAR, --
          p_symbol IN VARCHAR, --
          p_side IN VARCHAR, --
          p_trader_id IN VARCHAR,
          p_err_msg OUT VARCHAR2
      );

       PROCEDURE sp_proces_msg_3d(p_err_code in OUT VARCHAR,
          p_firm IN VARCHAR, --Ma cong ty thanh vien
          p_confirm_number IN VARCHAR,--Ma xac nhan tu so
          p_reply_code IN VARCHAR,
          p_err_msg OUT VARCHAR2
      );

      PROCEDURE sp_proces_msg_aa(p_err_code in OUT VARCHAR,
          p_security_number IN VARCHAR, --Ma cong ty thanh vien
          p_volume IN VARCHAR, -- so luong
          p_price IN VARCHAR,
          p_firm IN VARCHAR,
          p_trader IN VARCHAR,
          p_side IN VARCHAR,
          p_board IN VARCHAR,
          p_add_cancel_flag IN VARCHAR,
          p_contact IN VARCHAR,
          p_err_msg OUT VARCHAR2
       );

END CSPKS_FO_GW_HSX;
/



create or replace PACKAGE BODY CSPKS_FO_GW_HSX AS
  --Xac nhan lenh dat
  PROCEDURE sp_proces_msg_2b(p_err_code in OUT VARCHAR,
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_order_number IN VARCHAR, --so hieu lenh cua so
                p_order_entry_date IN VARCHAR, --so tieu khoan giao dich
                p_order_id OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_order_id varchar2(20);
    v_currtime timestamp;
    v_count number;
    v_root_orderid varchar2(20);
    v_sessionex varchar2(20);
    v_symbol varchar(20);
    BEGIN
       p_err_msg:='sp_proces_msg_2b p_order_number=>'||p_order_number;
       BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
        END;
       p_err_code := '0';

       v_root_orderid := TRIM(p_order_number);

       --Check BO order
      SELECT COUNT(*) INTO v_count FROM orders WHERE rootorderid = v_root_orderid  AND (side='B' OR side='S');
       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;

       SELECT orderid,symbol INTO v_order_id,v_symbol FROM orders WHERE rootorderid = v_root_orderid AND (side='B' OR side='S');
       p_order_id := v_order_id;

       --Cap nhat trang thai lenh
       /*dung.bui added code cap nhat phien cua lenh, date 10/12/2015*/

       --UPDATE orders SET confirmid=v_root_orderid,flagorder='T', status='S',substatus='SS',lastchange = v_currtime
       --WHERE rootorderid = v_root_orderid AND (side='B' OR side='S');

       SELECT SESSIONEX INTO v_sessionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
       UPDATE orders SET confirmid=v_root_orderid,flagorder='T', status='S',substatus='SS',lastchange = v_currtime,sessionex=v_sessionex
       WHERE rootorderid = v_root_orderid AND (side='B' OR side='S');
       /*end*/


      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_2b '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2b;

  --Xac nhan huy lenh
  --CTCK yeu cau huy lenh va duoc HOSE chap nhan
  --Lenh MP khong duoc khop het
  --Lenh ATO, ATC khong duoc khop het
  PROCEDURE sp_proces_msg_2c(p_err_code in OUT VARCHAR,
                p_new_orderid in OUT VARCHAR,--orderid cua lenh moi (phan sua lenh)
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_cancel_shares IN NUMBER, --Khoi luong huy
                p_order_number IN VARCHAR, --truong rootorderid
                p_order_entry_date IN VARCHAR,
                p_order_cancel_status_alph IN VARCHAR,
                p_order_id OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
        v_orderid varchar(20);
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
        v_count number;
        v_mort_qtty number;
        v_root_orderid varchar(20);
    BEGIN
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_2c p_order_number=>'||p_order_number;
       -- Check BO order
       v_root_orderid := TRIM(p_order_number);
       SELECT COUNT(*) INTO v_count FROM orders
       WHERE rootorderid = v_root_orderid
       -- AND side='O' AND flagorder='C'
       ;
       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;

       --UPDATE orders SET confirmid=p_order_number,flagorder='T', status='D',substatus='DS'
       --WHERE rootorderid = p_order_number AND side='O';
       IF  (v_count > 1) THEN
          --lay thong tin lenh huy
          SELECT ORDERID,SIDE,SUBSIDE,STATUS,SUBSTATUS,ACCTNO,SYMBOL,REFORDERID,QUOTE_QTTY,
                  REMAIN_QTTY,QUOTE_PRICE,TYPECD,USERID,QUOTEID,SESSIONEX,MORT_QTTY
          INTO v_orderid,v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,
                v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex,v_mort_qtty
          FROM orders
          WHERE ROOTORDERID = v_root_orderid AND side='O' /*AND flagorder='C'*/ ;
        ELSE
           --lay thong tin lenh duoc xac nhan
          SELECT ORDERID,SIDE,SUBSIDE,STATUS,SUBSTATUS,ACCTNO,SYMBOL,REFORDERID,QUOTE_QTTY,
                  REMAIN_QTTY,QUOTE_PRICE,TYPECD,USERID,QUOTEID,SESSIONEX,MORT_QTTY
          INTO v_orderid,v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,
                v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex,v_mort_qtty
          FROM orders
          WHERE ROOTORDERID = v_root_orderid;
        END IF;

        IF (v_reforderid IS NOT NULL) THEN
          p_order_id := v_reforderid;
        ELSE
          p_order_id := v_orderid;
        END IF;
        --Xac nhan huy lenh
        IF v_side='O' AND (v_sub_side = 'CB' OR v_sub_side = 'CS') THEN
           CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_cancel(p_err_code,v_orderid,p_order_id,'S',p_order_entry_date,
                    v_side,v_sub_side,v_status,v_sub_status,v_acctno,
                    v_symbol,v_reforderid,v_quote_qtty,v_remain_qtty,v_quote_price,
                    v_typecd,v_userid,v_quoteid,v_sessionnex,p_cancel_shares,p_err_msg);
        END IF;

        --lenh thi truong MP, ATO, ATC
        IF v_side != 'O' AND v_typecd = 'MK' THEN
            -- Giai toa lenh goc
            CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_sub_side, v_acctno,
            v_symbol , p_cancel_shares , v_remain_qtty , v_mort_qtty, v_quote_price,p_err_msg, '');
        END IF;

       -- Giai toa lenh thuong chua sinh lenh huy
        IF v_side = 'B' OR v_side = 'S' THEN
            -- Giai toa lenh goc
            CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_sub_side, v_acctno,
            v_symbol , p_cancel_shares , v_remain_qtty , v_mort_qtty, v_quote_price,p_err_msg, '');
            --dbms_output.put_line(' Giai toa lenh goc voi lenh MP hoac lenh het hieu luc' || v_orderid);
        END IF;

        --dbms_output.put_line('222222222222222' || p_err_code);
        IF v_status = 'D' AND v_sub_status = 'DE' THEN
          --Sinh lenh moi day len san HSX
          --lay thong tin lenh goc
          SELECT SIDE INTO v_side FROM ORDERS WHERE ORDERID = v_reforderid;
          --cap nhat yc dat lenh
          UPDATE QUOTES SET SIDE = v_side WHERE QUOTEID = v_quoteid;
          CSPKS_FO_ORDER_NEW.sp_generate_new_order_HSX(p_err_code,v_new_orderid,v_orderid,p_order_id/*'HSX'*/,'S',p_order_entry_date,
                    v_side,v_sub_side,v_status,v_sub_status,v_acctno,
                    v_symbol,v_reforderid,v_remain_qtty,v_remain_qtty,v_quote_price,
                    v_typecd,v_userid,v_quoteid,v_sessionnex,p_err_msg);
          --dbms_output.put_line('33333333333333' || p_err_code);
          IF (p_err_code != '0') THEN
            p_err_msg:= 'sp_proces_msg_2c '||p_err_msg||' LOI SINH LENH MOI ...';
            p_new_orderid := NULL;
            p_err_code := '-95048';
          ELSE
            p_new_orderid := v_new_orderid;
          END IF;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_msg_2c '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2c;
  
  PROCEDURE sp_proces_msg_2c_fail(p_err_code in OUT VARCHAR,
                p_new_orderid in OUT VARCHAR,--orderid cua lenh moi (phan sua lenh)
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_cancel_shares IN NUMBER, --Khoi luong huy
                p_order_number IN VARCHAR, --truong rootorderid
                p_order_entry_date IN VARCHAR,
                p_order_cancel_status_alph IN VARCHAR,
                p_order_id OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
        v_orderid varchar(20);
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
        v_count number;
        v_mort_qtty number;
        v_root_orderid varchar(20);
    BEGIN
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_2c p_order_number=>'||p_order_number;
       -- Check BO order
       v_root_orderid := TRIM(p_order_number);
       SELECT COUNT(*) INTO v_count FROM orders
       WHERE rootorderid = v_root_orderid
       -- AND side='O' AND flagorder='C'
       ;
       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;

       --UPDATE orders SET confirmid=p_order_number,flagorder='T', status='D',substatus='DS'
       --WHERE rootorderid = p_order_number AND side='O';
       IF  (v_count > 1) THEN
          --lay thong tin lenh huy
          SELECT ORDERID,SIDE,SUBSIDE,STATUS,SUBSTATUS,ACCTNO,SYMBOL,REFORDERID,QUOTE_QTTY,
                  REMAIN_QTTY,QUOTE_PRICE,TYPECD,USERID,QUOTEID,SESSIONEX,MORT_QTTY
          INTO v_orderid,v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,
                v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex,v_mort_qtty
          FROM orders
          WHERE ROOTORDERID = v_root_orderid AND side='O' /*AND flagorder='C'*/ ;
        ELSE
           --lay thong tin lenh duoc xac nhan
          SELECT ORDERID,SIDE,SUBSIDE,STATUS,SUBSTATUS,ACCTNO,SYMBOL,REFORDERID,QUOTE_QTTY,
                  REMAIN_QTTY,QUOTE_PRICE,TYPECD,USERID,QUOTEID,SESSIONEX,MORT_QTTY
          INTO v_orderid,v_side,v_sub_side,v_status,v_sub_status,v_acctno,v_symbol,v_reforderid,v_quote_qtty,
                v_remain_qtty,v_quote_price,v_typecd,v_userid,v_quoteid,v_sessionnex,v_mort_qtty
          FROM orders
          WHERE ROOTORDERID = v_root_orderid;
        END IF;

        IF (v_reforderid IS NOT NULL) THEN
          p_order_id := v_reforderid;
        ELSE
          p_order_id := v_orderid;
        END IF;
        --Xac nhan huy lenh
        IF v_side='O' AND (v_sub_side = 'CB' OR v_sub_side = 'CS') THEN
           CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_cancel(p_err_code,v_orderid,p_order_id,'S',p_order_entry_date,
                    v_side,v_sub_side,v_status,v_sub_status,v_acctno,
                    v_symbol,v_reforderid,v_quote_qtty,v_remain_qtty,v_quote_price,
                    v_typecd,v_userid,v_quoteid,v_sessionnex,p_cancel_shares,p_err_msg);
        END IF;

        --lenh thi truong MP, ATO, ATC
        IF v_side != 'O' AND v_typecd = 'MK' THEN
            -- Giai toa lenh goc
            CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_sub_side, v_acctno,
            v_symbol , p_cancel_shares , v_remain_qtty , v_mort_qtty, v_quote_price,p_err_msg, '');
        END IF;

       -- Giai toa lenh thuong chua sinh lenh huy
        IF v_side = 'B' OR v_side = 'S' THEN
            -- Giai toa lenh goc
            CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_sub_side, v_acctno,
            v_symbol , p_cancel_shares , v_remain_qtty , v_mort_qtty, v_quote_price,p_err_msg, '');
            --dbms_output.put_line(' Giai toa lenh goc voi lenh MP hoac lenh het hieu luc' || v_orderid);
        END IF;
      
      p_new_orderid := null;
      
      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:= 'sp_proces_msg_2c_fail '||p_err_msg||' sqlerrm = '||SQLERRM;
          p_new_orderid := null;
  END sp_proces_msg_2c_fail;

  --thong tin thay doi lenh, cho lenh MP
  PROCEDURE sp_proces_msg_2d(p_err_code in OUT VARCHAR,
               p_firm IN VARCHAR, --Ma cong ty thanh vien
               p_ordernumber IN VARCHAR, --
               p_orderentrydate IN VARCHAR, --
               p_clientid_alph IN VARCHAR,
               p_port_clientflag_alph IN VARCHAR,
               p_published_volume IN NUMBER,
               p_price IN NUMBER,
               p_filler IN VARCHAR,
               p_order_id OUT VARCHAR,
               p_err_msg OUT VARCHAR2
                )
  AS
        v_side VARCHAR(2);
        v_sub_side VARCHAR(2);
        v_quoteid VARCHAR(20);
        v_quote_price NUMBER(20,2);
        v_symbol VARCHAR(20);
        v_rate_tax NUMBER;
        v_rate_brk NUMBER;
        v_acctno VARCHAR(20);
        v_orderid VARCHAR(20);
        v_count NUMBER;
        v_currtime timestamp;
        v_root_orderid VARCHAR(20);
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_msg_2d p_order_number=>'||p_ordernumber;
      BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
        END;
        -- Check BO order
        v_root_orderid := TRIM(p_ordernumber);
       SELECT COUNT(*) INTO v_count
       FROM orders WHERE rootorderid = v_root_orderid ;
       -- AND flagorder='T';
       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;

        SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno
        INTO v_orderid,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno
        FROM orders WHERE rootorderid = v_root_orderid;
        -- AND flagorder='T';

        --return orderid goc
        p_order_id := v_orderid;

        --UPDATE orders SET quote_price = p_price WHERE orderid = v_orderid;
         UPDATE ORDERS SET/* REMAIN_QTTY = p_published_volume,*/ QUOTE_PRICE = p_price, TYPECD = 'LO', SUBTYPECD='LO', LASTCHANGE = v_currtime
           WHERE ORDERID = p_order_id;
       /* CSPKS_FO_ORDER_RESPONE.sp_proces_order_replace(p_err_code,
                v_orderid, --so hieu lenh
                v_acctno, --so tieu khoan giao dich
                p_published_volume,  --Khoi luong khop
                                p_price, --Gia khop
                                p_ordernumber, --ma xac nhan tu so
                p_orderentrydate, --ngay giao dich
                v_quoteid,
                v_side,
                v_sub_side,
                v_quote_price,
                v_symbol,
                v_rate_tax,
                v_rate_brk); */

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_2d '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2d;

  --tu choi
   PROCEDURE sp_proces_msg_2g(p_err_code in OUT VARCHAR,
               p_firm IN VARCHAR, --Ma cong ty thanh vien
               p_reject_reason_code IN VARCHAR, --
               p_original_message_text IN VARCHAR, --
               p_order_id IN OUT VARCHAR, --So hieu lenh gui so HSX(truong rootoderid)
               f_cancel_qtty OUT NUMBER,
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
    v_root_orderid VARCHAR(20);
    v_reforderid VARCHAR(20);
      v_original_message_text VARCHAR(1000);
    v_substatus VARCHAR(3);
    BEGIN
      
       --dbms_output.enable(150);
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_2g p_original_message_text=>'||p_original_message_text;

       v_root_orderid := TRIM(p_order_id);
         v_original_message_text := TRIM(p_original_message_text);
       
       --p_err_msg:='sp_proces_msg_2g p_original_message_text=>'||v_original_message_text;
       
       -- Check BO order
       SELECT COUNT(*) INTO v_count FROM orders WHERE ROOTORDERID = v_root_orderid;
       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;

      -- Ghi vao bang loi
      CSPKS_FO_ORDER_RESPONE.sp_proces_respone_error(p_err_code, '2G', p_reject_reason_code, v_original_message_text,p_err_msg);

      -- Giai toa lenh
      IF v_count = 1 THEN --2G for 1I
        SELECT  ORDERID, ACCTNO, QUOTE_QTTY, MORT_QTTY, REMAIN_QTTY, SIDE, SUBSIDE, SYMBOL, QUOTE_PRICE
        INTO    v_orderid, v_acctno, v_quote_qtty, v_mort_qtty, v_remain_qtty, v_side, v_sub_side, v_symbol, v_quote_price
        FROM ORDERS
        WHERE ROOTORDERID=v_root_orderid;

         v_freed_qtty := v_quote_qtty;

        CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_sub_side, v_acctno,
        v_symbol , v_freed_qtty , v_remain_qtty , v_mort_qtty, v_quote_price,p_err_msg, '');
     
      ELSIF v_count >= 2 THEN --2G for 1C
        --Tiendt fixed bug for cancel >=2 times
        SELECT  ORDERID,REFORDERID,SUBSTATUS 
        INTO    v_orderid,v_reforderid, v_substatus
        FROM ORDERS
        WHERE ROOTORDERID=v_root_orderid AND SIDE='O' AND (SUBSTATUS = 'DE' OR SUBSTATUS = 'BB');
       /*
        UPDATE ORDERS SET STATUS='D', SUBSTATUS='DN' WHERE ORDERID=v_orderid AND SIDE='O' AND SUBSTATUS= v_substatus;
        UPDATE ORDERS SET STATUS='S', SUBSTATUS='SS' WHERE ORDERID=v_reforderid;
        */
      END IF;

      f_cancel_qtty := v_quote_qtty;

      p_order_id := v_orderid;

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_2g '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2g;

  --Khop cung cong ty
  PROCEDURE sp_proces_msg_2i(p_err_code in OUT VARCHAR,
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_order_number_buy IN VARCHAR, --   so hieu lenh mua
                p_order_entry_date_buy IN VARCHAR, --ngay giao dich lenh mua, format: yyyyMMdd-HH24:MI:SS
                p_order_number_sell IN VARCHAR,--so hieu lenh ban
                p_order_entry_date_sell IN VARCHAR,--ngay giao dich lenh ban
                p_volume IN NUMBER,--khoi luong khop
                p_price IN NUMBER,--gia khop
                p_confirm_number IN VARCHAR,
                p_order_id_buy OUT VARCHAR, --So hieu lenh cua cong ty chung khoan, mua
                p_order_id_sell OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
      v_side VARCHAR(10);
      v_sub_side VARCHAR(10);
      v_quoteid VARCHAR(30);
      v_quote_price NUMBER;
      v_symbol VARCHAR(20);
      v_rate_tax NUMBER;
      v_rate_brk NUMBER;
      v_acctno VARCHAR(30);
      v_orderid_buy VARCHAR(30);
      v_orderid_sell VARCHAR(30);
      v_count NUMBER;
      v_root_orderid_buy VARCHAR(20);
      v_root_orderid_sell VARCHAR(20);
      v_sessionex_buy VARCHAR(20);
      v_sessionex_sell VARCHAR(20);
    BEGIN
        p_err_code := '0';
       p_err_msg:='sp_proces_msg_2i p_confirm_number=>'||p_confirm_number;
        v_root_orderid_buy := TRIM(p_order_number_buy);
        v_root_orderid_sell := TRIM(p_order_number_sell);
        -- Check BO order
--        SELECT COUNT(*) INTO v_count FROM orders WHERE rootorderid = v_root_orderid_buy;
--        IF (v_count = 0) THEN
--          p_err_code := '00';
--          RETURN;
--        END IF;
        --dbms_output.put_line('v_root_orderid_buy' || v_root_orderid_buy);
        SELECT COUNT(*) INTO v_count FROM orders WHERE rootorderid = v_root_orderid_buy;
        IF (v_count > 0) THEN
          --ben mua
          IF (v_count = 1) THEN
            SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno,sessionex
            INTO v_orderid_buy,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno,v_sessionex_buy
            FROM orders WHERE rootorderid = v_root_orderid_buy /*AND flagorder='T' */;
          ELSIF (v_count > 1) THEN
            SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno,sessionex
            INTO v_orderid_buy,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno,v_sessionex_buy
            FROM orders WHERE rootorderid = v_root_orderid_buy AND SIDE != 'O' /*AND flagorder='T' */;
          END IF;

          update orders set status = 'S',substatus = 'SS' where orderid = v_orderid_buy;

          /*dung.bui added code cap nhat phien cua lenh, date 10/12/2015*/
          IF (v_sessionex_buy NOT IN ('OPN','CNT','CLS')) THEN
            SELECT SESSIONEX INTO v_sessionex_buy FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
            UPDATE ORDERS SET SESSIONEX=v_sessionex_buy WHERE ORDERID=v_orderid_buy;
          END IF;
          /*end*/

          --dbms_output.put_line('Khop mua: ' || v_orderid_buy);
          CSPKS_FO_ORDER_RESPONE.sp_proces_order_replace(p_err_code,
                  v_orderid_buy, --so hieu lenh
                  v_acctno, --so tieu khoan giao dich
                  p_volume,  --Khoi luong khop
                  p_price, --Gia khop
                  v_orderid_buy, --ma xac nhan tu so, hien ko dung
                  p_order_entry_date_buy, --ngay giao dich
                  v_quoteid,
                  v_side,
                  v_sub_side,
                  v_quote_price,
                  v_symbol,
                  v_rate_tax,
                  v_rate_brk,
                  p_err_msg);
            IF (p_err_code = 0 AND v_orderid_buy IS NOT NULL) THEN
              --return orderid goc mua
              p_order_id_buy := v_orderid_buy;
            END IF;
        END IF;

        SELECT COUNT(*) INTO v_count FROM orders WHERE rootorderid = v_root_orderid_sell;
        IF (v_count > 0) THEN
          --dbms_output.put_line('v_count:' || v_count);

          IF (v_count = 1) THEN
            --ben ban
            SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno
            INTO v_orderid_sell,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno
            FROM orders WHERE rootorderid = v_root_orderid_sell /*AND flagorder='T'*/;
          ELSIF (v_count > 1) THEN
            SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno
            INTO v_orderid_sell,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno
            FROM orders WHERE rootorderid = v_root_orderid_sell AND side != 'O' /*flagorder='T'*/;
          END IF;

          update orders set status = 'S',substatus = 'SS' where orderid = v_orderid_sell;

          /*dung.bui added code cap nhat phien cua lenh, date 10/12/2015*/
          IF (v_sessionex_sell NOT IN ('OPN','CNT','CLS')) THEN
            SELECT SESSIONEX INTO v_sessionex_sell FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
            UPDATE ORDERS SET SESSIONEX=v_sessionex_sell WHERE ORDERID=v_orderid_sell;
          END IF;
          /*end*/

          --dbms_output.put_line('Khop ban: ' || v_root_orderid_sell);
          CSPKS_FO_ORDER_RESPONE.sp_proces_order_replace(p_err_code,
                  v_orderid_sell, --so hieu lenh
                  v_acctno, --so tieu khoan giao dich
                  p_volume,  --Khoi luong khop
                  p_price, --Gia khop
                  v_orderid_sell, --ma xac nhan tu so, hien ko dung
                  p_order_entry_date_sell, --ngay giao dich
                  v_quoteid,
                  v_side,
                  v_sub_side,
                  v_quote_price,
                  v_symbol,
                  v_rate_tax,
                  v_rate_brk,
                  p_err_msg);
           IF (p_err_code = 0 AND v_orderid_sell IS NOT NULL) THEN
             --return orderid goc ban
             p_order_id_sell := v_orderid_sell;
           END IF;

         END IF;
  EXCEPTION
        WHEN OTHERS THEN
          p_err_msg:='sp_proces_msg_2i '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2i;

   --Khop khac cong ty
  PROCEDURE sp_proces_msg_2e(p_err_code in OUT VARCHAR,
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_side IN VARCHAR, --   mua hay ban
                p_order_number IN VARCHAR, --so hieu lenh gui so HSX (rootoderid)
                p_order_entry_date IN VARCHAR,--ngay giao dich lenh
                p_fillter IN VARCHAR,--
                p_volume IN NUMBER,--khoi luong khop
                p_price IN NUMBER,--gia khop
                p_confirm_number IN VARCHAR,
                p_order_id OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
      v_side VARCHAR(2);
      v_sub_side VARCHAR(2);
      v_quoteid VARCHAR(20);
      v_quote_price NUMBER(20,2);
      v_symbol VARCHAR(20);
      v_rate_tax NUMBER;
      v_rate_brk NUMBER;
      v_acctno VARCHAR(20);
      v_orderid VARCHAR(20);
      v_count NUMBER;
      v_root_orderid VARCHAR(20);
      v_sessionex VARCHAR(20);
    BEGIN
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_2e p_order_number=>'||p_order_number;
       -- Check BO order
       v_root_orderid := TRIM(p_order_number);
       SELECT COUNT(*) INTO v_count FROM orders WHERE rootorderid = v_root_orderid;

       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;

       IF (v_count = 1) THEN
            --ben mua
          SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno,sessionex
          INTO v_orderid,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno ,v_sessionex
          FROM orders WHERE rootorderid = v_root_orderid
          -- TODO for case not recevice 2B message confirm
          -- AND flagorder='T'
          ;
        ELSIF (v_count > 1) THEN
          SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno,sessionex
          INTO v_orderid,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno ,v_sessionex
          FROM orders WHERE rootorderid = v_root_orderid AND SIDE != 'O';
        END IF;
        
       --ben mua
       --SELECT orderid,quoteid,side,subside,quote_price,symbol,rate_tax,rate_brk,acctno,sessionex
        --INTO v_orderid,v_quoteid,v_side,v_sub_side,v_quote_price,v_symbol,v_rate_tax,v_rate_brk,v_acctno ,v_sessionex
        --FROM orders WHERE rootorderid = v_root_orderid
        -- TODO for case not recevice 2B message confirm
        -- AND flagorder='T'
        --;

        update orders set status = 'S',substatus = 'SS' where orderid = v_orderid;
        /*dung.bui added code cap nhat phien cua lenh, date 10/12/2015*/
        IF (v_sessionex NOT IN ('OPN','CNT','CLS')) THEN
          SELECT SESSIONEX INTO v_sessionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= v_symbol AND M.EXCHANGE=I.EXCHANGE;
          UPDATE ORDERS SET SESSIONEX=v_sessionex WHERE ORDERID=v_orderid;
        END IF;
        /*end*/

--        dbms_output.put_line('aaaaaaaa : ' || v_side);
        --return orderid goc
        p_order_id := v_orderid;
        --dbms_output.put_line('222222222222222' || p_err_code);
        --ben mua
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_replace(p_err_code,
                v_orderid, --so hieu lenh
                v_acctno, --so tieu khoan giao dich
                p_volume,  --Khoi luong khop
                                p_price, --Gia khop
                                v_orderid, --ma xac nhan tu so, hien ko dung
                p_order_entry_date, --ngay giao dich
                v_quoteid,
                v_side,
                v_sub_side,
                v_quote_price,
                v_symbol,
                v_rate_tax,
                v_rate_brk,
                p_err_msg);

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_2e '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2e;

  --Minh la ben mua, so gui cho minh thong tin ben ban
  PROCEDURE sp_proces_msg_2f(p_err_code in OUT VARCHAR,
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_trader_id_buy IN VARCHAR, --
                p_side IN VARCHAR, --   mua hay ban
                p_contra_firm IN VARCHAR, --ma thanh vien ben ban
                p_trader_id_sell IN VARCHAR, --
                p_symbol IN VARCHAR, --ma chung khoan
                p_volume IN NUMBER,--khoi luong khop
                p_price IN NUMBER,--gia khop
                p_confirm_number IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
      v_acctno VARCHAR(20);
      v_quote_id VARCHAR(20);
      v_confirm_number VARCHAR(20);
    BEGIN

        p_err_code := '0';
        p_err_msg:='sp_proces_msg_2f p_confirm_number=>'||p_confirm_number;
        v_confirm_number := TRIM(p_confirm_number);

        CSPKS_FO_COMMON.sp_get_quoteid(p_err_code,v_quote_id,p_err_msg);
        INSERT INTO QUOTES(QUOTEID, REQUESTID, CREATEDDT, EXPIREDDT, USERID, CLASSCD, SUBCLASS, VIA, STATUS, SUBSTATUS, TIME_QUOTE,
                            TIME_SEND, TYPECD, SUBTYPECD, SIDE, REFQUOTEID, SYMBOL, QTTY, QTTY_BASED, QTTY_DELTA, QTTY_CANCEL, QTTY_ADMEND,
                            DISTRIBUTECD, ACCTNO, PRICE, PRICE_RF, PRICE_CE, PRICE_FL, PRICE_DELTA, EXEC_AMT, EXEC_QTTY, LASTCHANGE)
        VALUES(v_quote_id, v_quote_id, NULL, NULL, NULL, 'DBO', 'CCO', 'F', 'P', 'P', NULL,
              NULL, 'LO', 'LO', 'B', v_confirm_number, p_symbol, p_volume, 0, 0, 0, 0,
              'A', null, p_price, 0, 0, 0, 0, 0, 0, SYSDATE);

        INSERT INTO CROSSINFO(QUOTEID, CROSSTYPE, FIRM, TRADERID, ACCTNO, ORDERID, TEXT)
        VALUES(v_quote_id, 'D', p_firm, p_trader_id_buy, null, null, NULL);


        EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:='sp_proces_msg_2f '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2f;

  --Xac nhan khop giao dich thoa thuan tra ve tu HOSE
  PROCEDURE sp_proces_msg_2l(p_err_code in OUT VARCHAR,
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_side IN VARCHAR, --   mua hay ban
                p_deal_id IN VARCHAR, --
                p_contra_firm IN VARCHAR, --
                p_volume IN NUMBER,--khoi luong khop
                p_price IN NUMBER,--gia khop
                p_confirm_number IN VARCHAR,
                f_orderid_s OUT VARCHAR,
                f_orderid_b OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
      v_amount NUMBER;
      v_currtime            timestamp;
      v_trade_id            VARCHAR(20);
      v_orderid             VARCHAR(20);
      v_acctno              VARCHAR(20);
      v_add_amt             NUMBER;
      v_rate_tax            NUMBER;
      v_rate_brk            NUMBER;
      v_quote_id            VARCHAR(20);
      v_acctno_b            VARCHAR(20);
      v_orderid_b           VARCHAR(20);
      v_txdate              VARCHAR(20);
      v_cancel_quote_id_b   VARCHAR(50);
      v_cancel_quote_id_s   VARCHAR(50);
      v_firm                VARCHAR(50);
      v_deal_id             VARCHAR(20);
      v_confirm_number      VARCHAR(20);
    BEGIN
      p_err_msg:='sp_proces_msg_2l v_orderid=>'||v_orderid;
      v_deal_id := TRIM(p_deal_id);
      v_confirm_number := TRIM(p_confirm_number);

      IF (v_deal_id IS NULL) THEN
        SELECT MAX(QUOTEID) INTO v_quote_id FROM QUOTES WHERE REFQUOTEID = v_confirm_number;
        SELECT DEALID INTO v_deal_id FROM ORDERS WHERE QUOTEID = v_quote_id;
      END IF;

       BEGIN
          execute immediate
          'select sysdate from dual' into v_currtime;
       END;
       p_err_code := '0';
       --v_txdate := TO_CHAR(v_currtime, 'yyyy-mm-dd');
       v_txdate := null;

        --general tradeid
        CSPKS_FO_COMMON.sp_get_tradeid(p_err_code,v_trade_id,p_err_msg);
        INSERT INTO trades(TRADEID,ORDERID,QTTY,PRICE,TIME_EXEC,STATUS,LASTCHANGE)
        VALUES(v_trade_id,v_deal_id,p_volume,p_price,v_currtime,'P',v_currtime);

        --dbms_output.put_line('insert trade ' || v_trade_id);
      --Update Quotes
      /*IF (p_side = 'B') THEN
        CSPKS_FO_ORDER_CROSS.sp_get_quoteid(p_err_code, v_confirm_number, v_cancel_quote_id_s, v_cancel_quote_id_b);
        --dbms_output.put_line('update quote ' || v_cancel_quote_id_s || ' - ' || v_cancel_quote_id_b);

        IF (v_cancel_quote_id_b IS NOT NULL) THEN
          UPDATE QUOTES SET STATUS = 'C' WHERE QUOTEID = v_cancel_quote_id_b;
        END IF;
        IF (v_cancel_quote_id_s IS NOT NULL) THEN
          UPDATE QUOTES SET STATUS = 'F' WHERE QUOTEID = v_cancel_quote_id_s;
        END IF;
      ELSE
        SELECT QUOTEID INTO v_cancel_quote_id_s
          FROM ORDERS
          WHERE DEALID = v_deal_id
            AND QUOTEID = (SELECT MAX(QUOTEID) FROM ORDERS WHERE DEALID = v_deal_id)
            AND ROWNUM = 1;
            --dbms_output.put_line('update quote ' || v_cancel_quote_id_s );
          IF (v_cancel_quote_id_s IS NOT NULL) THEN
            UPDATE QUOTES SET STATUS = 'F' WHERE QUOTEID = v_cancel_quote_id_s;
          END IF;
      END IF;  */

       --update orders
       v_amount := p_volume*p_price;
       --dbms_output.put_line('update orders: ' || v_amount);
       UPDATE ORDERS SET STATUS = 'S',SUBSTATUS = 'SS',
                         CONFIRMID = v_confirm_number,
                         LASTCHANGE = v_currtime WHERE DEALID = v_deal_id;

      --dbms_output.put_line('update orders: ' || v_amount);
      --Update Orders
      -- Mua - Buyes
      IF p_side = 'B' THEN
        SELECT ORDERID,RATE_TAX,RATE_BRK,ACCTNO INTO v_orderid_b,v_rate_tax,v_rate_brk,v_acctno_b
        FROM ORDERS WHERE DEALID = v_deal_id AND SIDE = 'B';

        -- Khop mua
        -- Trading
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code, v_orderid_b,
        v_acctno_b, p_volume, p_price, v_confirm_number, v_txdate,p_confirm_number,p_err_msg);
--        dbms_output.put_line('Khop mua: ' || v_orderid_b || '-' ||v_acctno_b);

      -- Ban - Seller
      ELSIF p_side = 'S' THEN
        SELECT ORDERID,RATE_TAX,RATE_BRK,ACCTNO INTO v_orderid,v_rate_tax,v_rate_brk,v_acctno
        FROM ORDERS WHERE DEALID=v_deal_id AND SIDE='S';

        -- Khop ban
        -- Trading
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code, v_orderid, v_acctno, p_volume, p_price, v_confirm_number, v_txdate,p_confirm_number,p_err_msg);
--        dbms_output.put_line('Khop ban: ' || v_orderid || '-' ||v_acctno);
        v_add_amt := p_volume*p_price*(1-(v_rate_tax/100)-(v_rate_brk/100));

      --Cung thanh vien - Cross order inside company
      ELSIF p_side = 'X' THEN
        -- Khop Ban
        SELECT ORDERID,RATE_TAX,RATE_BRK,ACCTNO,QUOTEID INTO v_orderid,v_rate_tax,v_rate_brk,v_acctno,v_quote_id
        FROM ORDERS WHERE DEALID=v_deal_id AND SIDE='S';

        -- Trading
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code, v_orderid, v_acctno, p_volume, p_price, v_confirm_number, v_txdate,p_confirm_number,p_err_msg);
--        dbms_output.put_line('Khop ban: ' || v_orderid || '-' ||v_acctno);

        -- Khop mua
        SELECT ORDERID,RATE_TAX,RATE_BRK,ACCTNO,QUOTEID INTO v_orderid_b,v_rate_tax,v_rate_brk,v_acctno_b,v_quote_id
        FROM ORDERS WHERE DEALID=v_deal_id AND SIDE='B';

         -- Trading
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code, v_orderid_b, v_acctno_b, p_volume, p_price, v_confirm_number, v_txdate,p_confirm_number,p_err_msg);
--        dbms_output.put_line('Khop mua: ' || v_orderid_b || '-' ||v_acctno_b);

      ELSE --loi
        p_err_code := '-90030';
        return;
      END IF;
      f_orderid_s := v_orderid;
      f_orderid_b := v_orderid_b;

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_2l '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_2l;

  --Thong tin ma HOSE forward tu ben mua sang ben ban(minh la ben ban)
  --Giao dich khong chap nhan boi HOSE, HOSE gui cho ca ben mua va ben ban
   PROCEDURE sp_proces_msg_3b(p_err_code in OUT VARCHAR,
                p_firm IN VARCHAR, --Ma cong ty thanh vien
                p_confirm_number IN VARCHAR,
                p_deal_id IN VARCHAR, --
                p_client_id IN VARCHAR, --
                p_reply_code IN VARCHAR, --
                f_orderid OUT VARCHAR,
                f_cancel_number OUT VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
      v_acctno              VARCHAR(20);
      v_currtime            timestamp;
      v_cancel_quote_id_b   VARCHAR(50);
      v_cancel_quote_id_s   VARCHAR(50);
      v_firm                VARCHAR(50);
      v_count               NUMBER;
      v_confirm_number      VARCHAR(50);
      v_deal_id             VARCHAR(50);
      v_cancel_qtty         NUMBER;
      v_side                VARCHAR(2);
      v_symbol              VARCHAR(15);
    BEGIN
        p_err_msg:='sp_proces_msg_3b p_confirm_number=>'||p_confirm_number;
        v_confirm_number := TRIM(p_confirm_number);
        v_deal_id := TRIM(p_deal_id);

        BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
        END;

        --CSPKS_FO_ORDER_CROSS.sp_get_quoteid(p_err_code, v_confirm_number, v_cancel_quote_id_s, v_cancel_quote_id_b);

        p_err_code := '0';
        IF p_reply_code = 'A' THEN --ben mua chap nhan, minh la ben ban
          -- Update Quotes status
          --IF (v_cancel_quote_id_b IS NOT NULL) THEN
            --UPDATE QUOTES SET STATUS = 'C' WHERE QUOTEID = v_cancel_quote_id_b;
          --END IF;

          --IF (v_cancel_quote_id_s IS NOT NULL) THEN
            --UPDATE QUOTES SET STATUS = 'F' WHERE QUOTEID = v_cancel_quote_id_s;
          --ELSE
            --SELECT QUOTEID INTO v_cancel_quote_id_s FROM ORDERS WHERE DEALID = v_deal_id;
            --UPDATE QUOTES SET STATUS = 'F' WHERE QUOTEID = v_cancel_quote_id_s;
          --END IF;

          --Update Orders status
          UPDATE ORDERS SET STATUS = 'S',SUBSTATUS = 'SS', LASTCHANGE = v_currtime WHERE DEALID = v_deal_id;
          SELECT ORDERID, QUOTE_QTTY INTO f_orderid, f_cancel_number FROM ORDERS WHERE DEALID = v_deal_id;
        ELSE --ben mua khong chap nhan hoac HOSE khong chap nhan
          -- Update Quotes status
         /* SELECT COUNT(*) INTO v_count FROM QUOTES WHERE REFQUOTEID = v_confirm_number;

          IF (v_count > 0) THEN
            UPDATE QUOTES SET STATUS = 'R' WHERE REFQUOTEID = v_confirm_number;
          ELSE
            SELECT QUOTEID INTO v_cancel_quote_id_s FROM ORDERS WHERE DEALID = v_deal_id;
            UPDATE QUOTES SET STATUS = 'R' WHERE QUOTEID = v_cancel_quote_id_s;
          END IF;
          */

          --Update Orders status
          SELECT COUNT(1) INTO v_count FROM ORDERS WHERE DEALID = v_deal_id;
          IF (v_count = 1) THEN --Thoa thuan khac cong ty
            SELECT ORDERID, QUOTE_QTTY,QUOTE_QTTY,SIDE,ACCTNO,SYMBOL
              INTO f_orderid, f_cancel_number,v_cancel_qtty, v_side,v_acctno,v_symbol
              FROM ORDERS WHERE DEALID = v_deal_id;

            UPDATE ORDERS SET STATUS = 'R',SUBSTATUS = 'RR', REMAIN_QTTY = 0, CANCEL_QTTY = v_cancel_qtty,
              LASTCHANGE = v_currtime WHERE ORDERID = f_orderid;

          /*ELSIF (v_count = 2) THEN --thoa thuan cung cong ty
            UPDATE ORDERS SET STATUS = 'R',SUBSTATUS = 'RR', REMAIN_QTTY = 0, CANCEL_QTTY = v_cancel_qtty,
              LASTCHANGE = v_currtime WHERE DEALID = v_deal_id;
              */
            IF v_side = 'S' THEN

              --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
              SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = v_acctno AND symbol=v_symbol;
              IF v_count > 0 THEN
                 UPDATE portfoliosex SET sellingqtty = sellingqtty - v_cancel_qtty WHERE acctno = v_acctno AND symbol=v_symbol;
              ELSE
                 INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (v_acctno, v_symbol, 0, -v_cancel_qtty,
                                   0, 0, 0, 0, SYSDATE, 0);
              END IF;
            /*
              UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY -  v_cancel_qtty
              WHERE ACCTNO = v_acctno AND SYMBOL = v_symbol;
            */


            END IF;

            SELECT ORDERID, QUOTE_QTTY INTO f_orderid, f_cancel_number FROM ORDERS WHERE DEALID = v_deal_id;

          END IF;
        END IF;

        EXCEPTION
          WHEN OTHERS THEN
            p_err_code := '-90025';
            p_err_msg:='sp_proces_msg_3b '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_3b;

  PROCEDURE sp_proces_msg_3c(p_err_code in OUT VARCHAR,
              p_firm IN VARCHAR, --Ma cong ty thanh vien
              p_confirm_number IN VARCHAR,
              p_contra_firm IN VARCHAR, --
              p_symbol IN VARCHAR, --
              p_side IN VARCHAR, --
              p_trader_id IN VARCHAR,
              p_err_msg OUT VARCHAR2
          )
  AS
      v_qtty NUMBER;
      v_price NUMBER;
      v_sell_party_id VARCHAR(20);
      v_buy_acctno VARCHAR(20);
      v_sell_acctno VARCHAR(20);
      v_currtime timestamp;
      v_quote_acctno VARCHAR(20);
      v_cross_acctno VARCHAR(20);
      v_quoteid VARCHAR(50);
      v_side VARCHAR(50);
      v_confirm_number VARCHAR(20);
    BEGIN
       p_err_msg:='sp_proces_msg_confirm_amend p_confirm_number=>'||p_confirm_number;
       v_confirm_number := TRIM(p_confirm_number);
       BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
       END;

       p_err_code := '0';

       SELECT QUOTEID, EXEC_QTTY, QUOTE_PRICE, ACCTNO, SIDE INTO v_quoteid, v_qtty, v_price, v_quote_acctno, v_side
       FROM ORDERS
       WHERE CONFIRMID = v_confirm_number
       AND ORDERID = ( SELECT MAX(ORDERID) FROM ORDERS WHERE CONFIRMID = v_confirm_number);

       SELECT ACCTNO INTO v_cross_acctno FROM CROSSINFO WHERE QUOTEID = v_quoteid;

       IF(v_side = 'S') THEN
        v_sell_acctno := v_quote_acctno;
        v_buy_acctno := v_cross_acctno;

       ELSIF (v_side = 'B') THEN
        v_buy_acctno := v_quote_acctno;
        v_sell_acctno := v_cross_acctno;
       END IF;

       v_sell_party_id := p_contra_firm;

       CSPKS_FO_ORDER_CROSS.sp_proces_msg_forward_cross(
       p_err_code, v_confirm_number, p_symbol, v_qtty, v_price, 'C', v_sell_party_id, v_buy_acctno, v_sell_acctno, NULL,p_err_msg);

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_3c '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_proces_msg_3c;

--Thong tin tra loi yeu cau huy lenh cua ben mua hoac HOSE
 PROCEDURE sp_proces_msg_3d(p_err_code in OUT VARCHAR,
               p_firm IN VARCHAR, --Ma cong ty thanh vien
               p_confirm_number IN VARCHAR,--Ma xac nhan tu so
               p_reply_code IN VARCHAR,
               p_err_msg OUT VARCHAR2
              )
  AS
    v_orig_order_id         VARCHAR(50);
    v_cancel_order_id       VARCHAR(50);
    v_count                 NUMBER;
    v_currtime              timestamp;
    v_firm                VARCHAR(50);
    v_confirm_number      VARCHAR(50);
    v_orderid_s               VARCHAR(50);
    v_orderid_b               VARCHAR(50);
  BEGIN
       p_err_msg:='sp_proces_msg_3d p_confirm_number=>'||p_confirm_number;
       v_confirm_number := TRIM(p_confirm_number);
       BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
       END;
        p_err_code := '0';
            --dbms_output.put_line('v_count ' || v_count);
        -- Lay ra OrderID cua lenh Goc (v_orig_order_id)
        SELECT ORDERID, REFORDERID INTO v_cancel_order_id, v_orig_order_id
        FROM ORDERS
        WHERE CONFIRMID = v_confirm_number
        AND ORDERID = ( SELECT MAX(ORDERID) FROM ORDERS WHERE CONFIRMID = v_confirm_number);

        -- Acceted Cancel Cross
        IF ((p_reply_code IS NOT NULL) AND (p_reply_code = 'A')) THEN
          -- In case, HSX response to accept for cancellation cross request
          -- Cancel selling order of cross request
          CSPKS_FO_ORDER_CROSS.sp_proces_confrm_cancel_cross(p_err_code,v_orig_order_id,v_cancel_order_id,p_err_msg);

          -- If both the selling side and buying side are inside a company then v_count will return 2
          SELECT COUNT(1) INTO v_count
          FROM ORDERS
          WHERE ORDERID != v_cancel_order_id AND CONFIRMID = v_confirm_number;

          -- Both the selling side and buying side are inside a company
          IF ((p_err_code = '0') AND v_count > 1) THEN
            SELECT ORDERID INTO v_orderid_s FROM ORDERS
            WHERE CONFIRMID = v_confirm_number AND SIDE = 'S';
            -- Cancel selling order of cross request
            CSPKS_FO_ORDER_CROSS.sp_proces_confrm_cancel_cross(p_err_code,v_orderid_s, null,p_err_msg);

            SELECT ORDERID INTO v_orderid_b
            FROM ORDERS
            WHERE CONFIRMID = v_confirm_number AND SIDE = 'B';
            -- Cancel selling order of cross request
            CSPKS_FO_ORDER_CROSS.sp_proces_confrm_cancel_cross(p_err_code,v_orderid_b, null,p_err_msg);
          END IF;

        -- Reject Cancel Cross
        ELSE
          -- In case, buying side deny cross request
          -- Reject cancel selling order of cross request
          CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code,v_orig_order_id,v_cancel_order_id,p_err_msg);

                -- If both the selling side and buying side are inside a company then v_count will return 2
          SELECT COUNT(1) INTO v_count
          FROM ORDERS
          WHERE ORDERID != v_cancel_order_id AND CONFIRMID = v_confirm_number;
          IF ((p_err_code = '0') AND v_count > 1) THEN
            -- Cancel selling order of cross request
            SELECT ORDERID INTO v_orderid_s FROM ORDERS
            WHERE CONFIRMID = v_confirm_number AND SIDE = 'S';
            CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code,v_orderid_s, null,p_err_msg);

              -- Cancel buying order of cross request
            SELECT ORDERID INTO v_orderid_b FROM ORDERS
            WHERE CONFIRMID = v_confirm_number AND SIDE = 'B';
            CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code,v_orderid_b, null,p_err_msg);
          END IF;
        END IF;

      EXCEPTION
        WHEN OTHERS THEN
         p_err_code := '-90025';
         p_err_msg:='sp_proces_msg_3d '||p_err_msg||' sqlerrm = '||SQLERRM;

  END sp_proces_msg_3d;

  --Thong bao ve giao dich thoa thuan
  PROCEDURE sp_proces_msg_aa(p_err_code in OUT VARCHAR,
          p_security_number IN VARCHAR, --Ma cong ty thanh vien
          p_volume IN VARCHAR,-- so luong
          p_price IN VARCHAR, --    gia
          p_firm IN VARCHAR, -- firm code
          p_trader IN VARCHAR, --   trader code
          p_side IN VARCHAR, -- mua hoac ban
          p_board IN VARCHAR, --    board (B-M-O)
          p_add_cancel_flag IN VARCHAR, --
          p_contact IN VARCHAR,
          p_err_msg OUT VARCHAR2
      ) AS
      v_order_id VARCHAR(50);
      v_currtime timestamp;
      v_status VARCHAR(20);
      v_symbol VARCHAR(20);
      v_member_id VARCHAR(20);
  BEGIN
     p_err_msg:='sp_proces_msg_aa p_security_number=>'||p_security_number;
     BEGIN
        execute immediate
        'select tt_sysdate from dual' into v_currtime;
    END;
    p_err_code := '0';
    CSPKS_FO_COMMON.sp_get_orderid(p_err_code,v_order_id,p_err_msg);

    IF (p_add_cancel_flag = 'A') THEN
      v_status := 'N';
    ELSIF (p_add_cancel_flag = 'C') THEN
      v_status := 'D';
    END IF;

    SELECT SYMBOL INTO v_symbol FROM INSTRUMENTS WHERE SYMBOLNUM = p_security_number;

    v_member_id := p_firm || '-' || p_trader;

    INSERT INTO ADVORDERS (ORDERID, REFORDERID, REFQUOTEID, TXDATE, STATUS, SYMBOL, SIDE, QTTY, PRICE, MEMBERID, TEXT, LASTCHANGE)
    VALUES (v_order_id, NULL, NULL, v_currtime, v_status, v_symbol, p_side, p_volume, p_price, v_member_id, p_contact, v_currtime);
  EXCEPTION
        WHEN OTHERS THEN
          p_err_msg:='sp_proces_msg_aa '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_aa;


END CSPKS_FO_GW_HSX;

/

