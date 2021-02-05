CREATE OR REPLACE 
PACKAGE cspks_fo_gw_hnx AS 

/*
80A: CSPKS_FO_GW_HNX.sp_proces_msg_confirm_order
80M: CSPKS_FO_GW_HNX.sp_proces_msg_confirm_order
832: CSPKS_FO_GW_HNX.sp_proces_msg_respone_trade
843: CSPKS_FO_GW_HNX.sp_proces_msg_confirm_cancel
84A: CSPKS_FO_GW_HNX.sp_proces_msg_confirm_cancel
853: CSPKS_FO_GW_HNX.sp_proces_msg_confirm_amend
888: CSPKS_FO_GW_HNX.sp_proces_msg_reject_order
7: CSPKS_FO_ORDER_ADV.sp_process_advertisement_order
s1: CSPKS_FO_GW_HNX.sp_proces_msg_fowd_cross
u1: CSPKS_FO_GW_HNX.sp_proces_msg_fowd_cancl_cross
3: CSPKS_FO_GW_HNX.sp_proces_reject_order
*/
    --So HNX xac nhan lenh thuong
    PROCEDURE sp_proces_msg_confirm_order(p_err_code in OUT VARCHAR,
            p_MsgSeqNum IN VARCHAR, --
            p_OrdStatus IN VARCHAR, --                          
            p_OrderID IN VARCHAR, --
            p_TransactTime IN VARCHAR, --
            p_ClOrdID IN VARCHAR, --
            p_Symbol IN VARCHAR, --
            p_Side IN VARCHAR, --
            p_OrderQty IN NUMBER, --
            p_OrdType IN VARCHAR, --
            p_Price IN NUMBER, --
            p_Account IN VARCHAR, --
            p_err_msg OUT VARCHAR2
            ); 

    --So HNX xac nhan huy lenh thuong
    PROCEDURE sp_proces_msg_confirm_cancel(p_err_code in OUT VARCHAR,
            p_MsgSeqNum IN VARCHAR, --
            p_OrdStatus IN VARCHAR, --                          
            p_OrderID IN VARCHAR, --
            p_TransactTime IN VARCHAR, --
            p_ClOrdID IN VARCHAR, --
            p_OrigClOrdID IN VARCHAR, --
            p_Symbol IN VARCHAR, --
            p_Side IN VARCHAR, --
            p_OrdType IN VARCHAR, --
            p_Price IN VARCHAR, --
            p_Account IN VARCHAR, --
            p_LeavesQty IN NUMBER,--
            p_err_msg OUT VARCHAR2
            ); 
            
    --So HNX xac nhan sua lenh thuong
    PROCEDURE sp_proces_msg_confirm_amend(p_err_code in OUT VARCHAR,
            p_MsgSeqNum IN VARCHAR, --
            p_OrdStatus IN VARCHAR, --                      
            p_OrderID IN VARCHAR, --
            p_TransactTime IN VARCHAR, --
            p_ClOrdID IN VARCHAR, --
            p_OrigClOrdID IN VARCHAR, --
            p_Symbol IN VARCHAR, --
            p_Side IN VARCHAR, --
            p_OrdType IN VARCHAR, --
            p_Account IN VARCHAR, --
            p_LastQty IN NUMBER, -- khoi luong co hieu luc tren so
            p_LastPx IN NUMBER, -- gia
            p_LeavesQty IN NUMBER, -- khoi luong thay doi so voi lenh goc
            p_OrderQty2 IN NUMBER, --
            p_err_msg OUT VARCHAR2
            ); 
            
    --So HNX tre ve messag khop lenh thuong
    PROCEDURE sp_proces_msg_respone_trade(p_err_code in OUT VARCHAR,
            p_MsgSeqNum IN VARCHAR, --
            p_OrdStatus IN VARCHAR, --                          
            p_ClOrdID IN OUT VARCHAR, --
            p_OrigClOrdID IN VARCHAR, --
            p_SecondaryClOrdID IN VARCHAR, --
            p_OrderID IN VARCHAR, --
            p_TransactTime IN VARCHAR, --
            p_LastQty IN NUMBER, --
            p_LastPx IN NUMBER, --
            p_ExecID IN VARCHAR, --
            p_Side IN VARCHAR, --
            p_Symbol IN VARCHAR, --
            p_Contra_ClOrdID OUT VARCHAR, --
            p_err_msg OUT VARCHAR2
            );
            
   --Khop lenh voi lenh doi ung trong truong hop khop cung cong ty
    PROCEDURE sp_proces_respone_trade_second(p_err_code in OUT VARCHAR,
            p_MsgSeqNum IN VARCHAR, --
            p_OrdStatus IN VARCHAR, --                          
            p_ClOrdID IN OUT VARCHAR, --
            p_OrigClOrdID IN VARCHAR, --
            p_SecondaryClOrdID IN VARCHAR, --
            p_OrderID IN VARCHAR, --
            p_TransactTime IN VARCHAR, --
            p_LastQty IN NUMBER, --
            p_LastPx IN NUMBER, --
            p_ExecID IN VARCHAR, --
            p_Side IN VARCHAR, --
            p_Symbol IN VARCHAR, --
            p_Contra_ClOrdID OUT VARCHAR, --
            p_err_msg OUT VARCHAR2
            );
            
    --So HNX tra ve message tu choi lenh thuong
    PROCEDURE sp_proces_msg_decline_order(p_err_code in OUT VARCHAR,
            p_MsgSeqNum IN VARCHAR, --
            p_OrdStatus IN VARCHAR, --                          
            p_ClOrdID IN OUT VARCHAR, --
            p_OrderID IN VARCHAR, --
            p_TransactTime IN VARCHAR, --
            p_OrdRejReason IN VARCHAR, --
            p_UnderlyingLastQty IN NUMBER, --
            p_Side IN VARCHAR, --
            p_OrdType IN VARCHAR, --
            p_err_msg OUT VARCHAR2
            );
            
    -- HNX forward cross request to buying side
    PROCEDURE sp_proces_msg_fowd_cross(p_err_code OUT VARCHAR,
            p_crossid IN VARCHAR,
            p_sell_clordid IN VARCHAR,
            p_symbol IN VARCHAR,
            p_qtty IN NUMBER,
            p_price IN NUMBER,
            p_sender_comp_id IN VARCHAR,
            p_buy_party_id IN VARCHAR,
            p_sell_party_id IN VARCHAR,
            p_buy_acctno IN VARCHAR,
            p_sell_acctno IN VARCHAR,
            p_adv_id IN VARCHAR,
            p_err_msg OUT VARCHAR2);
    
    -- HNX forward cross cancellation request to buying side
    PROCEDURE sp_proces_msg_fowd_cancl_cross(p_err_code OUT VARCHAR,
            p_orderid OUT VARCHAR,
            p_org_crossid IN VARCHAR,
            p_err_msg OUT VARCHAR2);
            
    -- HNX reject invalid order
    PROCEDURE sp_proces_msg_reject_order(p_err_code OUT VARCHAR,
            p_msgtype IN VARCHAR,
            p_reject_code IN VARCHAR,
            p_content IN VARCHAR,
            p_order_id IN OUT VARCHAR,
            p_contra_order_id OUT VARCHAR,
            p_err_msg OUT VARCHAR2);
            
    /*
     * Author: Trung.Nguyen
     * Date: 11-Dec-2015
     */
    PROCEDURE sp_proces_recover_trading(p_err_code IN OUT VARCHAR, p_err_msg OUT VARCHAR2);
    
    /*
     * Author: Trung.Nguyen
     * Date: 14-Dec-2015
     */
    PROCEDURE sp_proces_recover_sync_bo(p_err_code IN OUT VARCHAR, c_matched_list OUT SYS_REFCURSOR, p_err_msg OUT VARCHAR2);
    
    /*
    * Author: Nam.Vu
    * Description: Store GW XML log
    * Date: 12/12/2015
    */
    PROCEDURE sp_proces_msg_log(p_err_code IN OUT VARCHAR2, 
          p_exchange_code IN OUT VARCHAR2,
          p_xml_content IN OUT VARCHAR2, 
          p_err_msg OUT VARCHAR2);
          
    PROCEDURE sp_proces_sendGW_msg_log(p_err_code IN OUT VARCHAR,
          p_orderid IN VARCHAR,
          p_exchange_code IN OUT VARCHAR,
          p_xml_content IN OUT VARCHAR, 
          p_err_msg OUT VARCHAR2);
            
END CSPKS_FO_GW_HNX;
/


CREATE OR REPLACE 
PACKAGE BODY cspks_fo_gw_hnx AS

  PROCEDURE sp_proces_msg_confirm_order(p_err_code in OUT VARCHAR,
                p_MsgSeqNum IN VARCHAR, --
                p_OrdStatus IN VARCHAR, --use
                p_OrderID IN VARCHAR, --so hieu lenh so tra ve, use
                p_TransactTime IN VARCHAR, --time,use
                p_ClOrdID IN VARCHAR, --So hieu lenh cua cong ty ck (FO ORDERID),use
                p_Symbol IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_OrderQty IN NUMBER, --
                p_OrdType IN VARCHAR, --
                p_Price IN NUMBER, --
                p_Account IN VARCHAR,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_count NUMBER;
    v_sessionex VARCHAR(20);
    BEGIN
      ---test deploy
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_confirm_order p_OrderID=>'||p_OrderID;
       SELECT COUNT(*) INTO v_count FROM orders WHERE orderid = p_ClOrdID;
       IF (v_count = 0) THEN
          p_err_code := '00';
          RETURN;
       END IF;
       /*dung.bui added code cap nhat phien, date 10/12/2015*/
       SELECT SESSIONEX INTO v_sessionex FROM MARKETINFO M,INSTRUMENTS I WHERE SYMBOL= p_Symbol AND M.EXCHANGE=I.EXCHANGE;
       UPDATE ORDERS SET SESSIONEX = v_sessionex WHERE ORDERID = p_ClOrdID;
       /*end*/
       IF (p_OrdStatus = 'M') THEN --8.0.M -> for remain qty MTL order
          CSPKS_FO_ORDER_RESPONE.sp_proces_MTL_order_confirm(p_err_code,p_ClOrdID,p_OrderID,
            p_OrdStatus,p_Symbol,p_Side,p_OrderQty,p_OrdType,p_Price,p_err_msg);
        ELSE
           CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_ClOrdID,p_OrderID,'S',p_TransactTime,0,0,0,0,p_err_msg);
        END IF;


      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_confirm_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_confirm_order;

  /*
   * Author: Tien.Do
   * Editor: Trung.Nguyen
   * Date: 15-May-2015
   null:
   */
  PROCEDURE sp_proces_msg_confirm_cancel(p_err_code in OUT VARCHAR,
                p_MsgSeqNum IN VARCHAR, --
                p_OrdStatus IN VARCHAR, --
                p_OrderID IN VARCHAR, --
                p_TransactTime IN VARCHAR, --
                p_ClOrdID IN VARCHAR, --so hieu lenh cua cong ty CK
                p_OrigClOrdID IN VARCHAR, --
                p_Symbol IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_OrdType IN VARCHAR, --
                p_Price IN VARCHAR, --
                p_Account IN VARCHAR,
                p_LeavesQty IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
  AS
    --v_ClOrdID VARCHAR(20);
    --v_OrigClOrdID VARCHAR(20);
    v_orig_order_id               ORDERS.ORDERID%TYPE;
    v_cancel_order_id             ORDERS.ORDERID%TYPE;
    v_cancel_quote_id             ORDERS.QUOTEID%TYPE;
    v_acctno                      ORDERS.ACCTNO%TYPE;
    v_symbol                      ORDERS.SYMBOL%TYPE;
    v_qtty                        ORDERS.QUOTE_QTTY%TYPE;
    v_count                       NUMBER;
    v_currtime timestamp;
    BEGIN
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_confirm_cancel p_OrderID =>'||p_OrderID;

       BEGIN
          execute immediate
          'select tt_sysdate from dual' into v_currtime;
       END;

       -- Mr.Tien:
       --CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_ClOrdID,p_OrigClOrdID,p_OrdStatus,p_TransactTime);

       /*
        * @author: trung.nguyen
        * @date: 20-Jan-2015
        * @description:
        *   - Value of p_OrigClOrdID parameter is confirmation code for original single order
        *   - HNX always returns value of p_ClOrdID parameter is original single order identifier of Securities Comp,.
        */
       IF (p_Side='8') THEN  -- process cross order
          SELECT COUNT(ORDERID) INTO v_count FROM ORDERS WHERE CONFIRMID = p_OrigClOrdID;
          -- If v_count=0, it means the buying side denies cross request from selling side
          IF (v_count=0) THEN
            --dbms_output.put_line('Change order status.......'||v_count);
            UPDATE QUOTES SET STATUS='R', LASTCHANGE=v_currtime  WHERE REFQUOTEID = p_OrigClOrdID;
            UPDATE ORDERS SET STATUS='R', SUBSTATUS='RR', CANCEL_QTTY=REMAIN_QTTY, REMAIN_QTTY=0 WHERE CONFIRMID = p_OrigClOrdID;
          ELSIF (v_count=1) THEN
            UPDATE QUOTES SET STATUS='R', LASTCHANGE=v_currtime WHERE REFQUOTEID = p_OrigClOrdID;
            UPDATE ORDERS SET STATUS='R', SUBSTATUS='RR', CANCEL_QTTY=REMAIN_QTTY, REMAIN_QTTY=0 WHERE CONFIRMID = p_OrigClOrdID;
            -- Free selling quantity from SELLINGQTTY of PORTFOLIOS table
            SELECT ACCTNO, SYMBOL, QUOTE_QTTY INTO v_acctno, v_symbol, v_qtty FROM ORDERS WHERE CONFIRMID = p_OrigClOrdID;
            --dbms_output.put_line('v_qtty: '||v_qtty);

            --ThanhNV sua 11/12/2015 lay bang portfoliosEX de tranh lock.
            SELECT count(*) INTO v_count FROM  PORTFOLIOSEX  WHERE acctno = v_acctno AND symbol=v_symbol;
            IF v_count > 0 THEN
                 UPDATE portfoliosex SET sellingqtty = sellingqtty - v_qtty WHERE acctno = v_acctno AND symbol=v_symbol;
            ELSE
                 INSERT INTO portfoliosex (acctno, symbol, buyingqtty, sellingqtty,
                                  sellingqttymort,marked, bod_rt3, bod_st3, lastchange,markedcom)
                                   VALUES (v_acctno, v_symbol, 0, -v_qtty,
                                   0, 0, 0, 0, SYSDATE, 0);
            END IF;
            /*
            UPDATE PORTFOLIOS SET SELLINGQTTY = SELLINGQTTY - v_qtty WHERE ACCTNO=v_acctno and SYMBOL=v_symbol;
            */

            SELECT p.SELLINGQTTY + NVL(pex.SELLINGQTTY,0) INTO v_qtty FROM PORTFOLIOS p, portfoliosex pex
            WHERE p.ACCTNO=v_acctno and p.SYMBOL=v_symbol
             AND  p.ACCTNO= pex.ACCTNO(+) AND p.SYMBOL=pex.SYMBOL(+);

            /*
            SELECT SELLINGQTTY INTO v_qtty FROM PORTFOLIOS WHERE ACCTNO=v_acctno and SYMBOL=v_symbol;
            */
            --dbms_output.put_line('SELLINGQTTY: '||v_qtty);
          ELSIF (v_count=2) THEN
            /*
             * If v_count=2, it means the buying side agrees cross cancellation request from selling side
             * This case, the selling side or the buying side is outside a company
             * Get identifier of cancellation order based on original cross order
             */
            --dbms_output.put_line('v_count.......: '||v_count);
            --dbms_output.put_line('p_ClOrdID: '||p_ClOrdID);
            /*
            SELECT ORDERID, REFORDERID, QUOTEID INTO v_cancel_order_id, v_orig_order_id, v_cancel_quote_id
            FROM ORDERS
            WHERE ORDERID=p_ClOrdID OR REFORDERID=p_ClOrdID OR (CONFIRMID = p_OrigClOrdID AND SIDE='O');
            */
            SELECT ORDERID, REFORDERID, QUOTEID INTO v_cancel_order_id, v_orig_order_id, v_cancel_quote_id
            FROM ORDERS
            WHERE CONFIRMID = p_OrigClOrdID AND SIDE='O';
            -- Process cross cancellation order
            CSPKS_FO_ORDER_CROSS.sp_proces_confrm_cancel_cross(p_err_code,v_orig_order_id,v_cancel_order_id,p_err_msg);
            --dbms_output.put_line('v_cancel_order_id: '||v_cancel_order_id);
            --dbms_output.put_line('v_orig_order_id: '||v_orig_order_id);
            --dbms_output.put_line('v_cancel_quote_id: '||v_cancel_quote_id);
            --dbms_output.put_line('p_err_code: '||p_err_code);
            -- Update status of QUOTES
            UPDATE QUOTES SET STATUS=DECODE(TYPECD,'N','D',STATUS) WHERE QUOTEID=v_cancel_quote_id;
          ELSIF (v_count=4) THEN
            /*
             * If v_count=4, it means the buying side agrees cross cancellation request from selling side
             * This case, both the selling side and the buying side are inside a company
             * Get cancellation identifier based on original cross order
             */
            SELECT ORDERID, REFORDERID, QUOTEID INTO v_cancel_order_id, v_orig_order_id, v_cancel_quote_id
            FROM ORDERS
            WHERE REFORDERID=p_ClOrdID;
            --dbms_output.put_line('v_cancel_order_id: '||v_cancel_order_id);
            --dbms_output.put_line('v_orig_order_id: '||v_orig_order_id);
            --dbms_output.put_line('v_cancel_quote_id: '||v_cancel_quote_id);
            -- Process cancel first side of cross order
            CSPKS_FO_ORDER_CROSS.sp_proces_confrm_cancel_cross(p_err_code,v_orig_order_id,v_cancel_order_id,p_err_msg);
            --dbms_output.put_line('p_err_code: '||p_err_code);
            -- Get cancellation identifier of contract side of original cross order
            SELECT ORDERID, REFORDERID, QUOTEID INTO v_cancel_order_id, v_orig_order_id, v_cancel_quote_id
            FROM ORDERS
            --WHERE QUOTEID=v_cancel_quote_id AND ORDERID!=v_cancel_order_id;
            WHERE CONFIRMID=p_OrigClOrdID AND ORDERID!=v_cancel_order_id AND SIDE='O';
            --dbms_output.put_line('v_cancel_order_id: '||v_cancel_order_id);
            --dbms_output.put_line('v_orig_order_id: '||v_orig_order_id);
            --dbms_output.put_line('v_cancel_quote_id: '||v_cancel_quote_id);
            -- Process cancel contract side of cross order
            CSPKS_FO_ORDER_CROSS.sp_proces_confrm_cancel_cross(p_err_code,v_orig_order_id,v_cancel_order_id,p_err_msg);
            --dbms_output.put_line('p_err_code: '||p_err_code);
          END IF;
       ELSE  -- process single order
          -- Check BO Order
          SELECT COUNT(*) INTO v_count FROM orders WHERE ORDERID = p_ClOrdID;
          IF (v_count = 0) THEN
              p_err_code := '00';
              RETURN;
          END IF;

           /*dung.bui fix confirm for cancel, date: 2015-08-21*/
          /*SELECT ORDERID, REFORDERID, QUOTEID INTO v_cancel_order_id, v_orig_order_id, v_cancel_quote_id
          FROM ORDERS
          WHERE ORDERID=p_ClOrdID;
          -- Updating status of cancellation order
          CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,v_cancel_order_id,v_orig_order_id,p_OrdStatus,p_TransactTime);*/
          CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_ClOrdID,p_OrigClOrdID,'S',p_TransactTime,0,0,p_LeavesQty,0,p_err_msg);
          /*end*/

       END IF;

       EXCEPTION
        WHEN OTHERS THEN
          p_err_code := 'ERA0025';
          p_err_msg:='sp_proces_msg_confirm_cancel '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_confirm_cancel;


  PROCEDURE sp_proces_msg_confirm_amend(p_err_code in OUT VARCHAR,
                p_MsgSeqNum IN VARCHAR, --
                p_OrdStatus IN VARCHAR, --
                p_OrderID IN VARCHAR, --
                p_TransactTime IN VARCHAR, --
                p_ClOrdID IN VARCHAR, --so hieu lenh cua cong ty chung khoan (FO OrderID)
                p_OrigClOrdID IN VARCHAR,--so hieu lenh cua So
                p_Symbol IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_OrdType IN VARCHAR, --
                p_Account IN VARCHAR, --
                p_LastQty IN NUMBER, --khoi luong co hieu luc tren so
                p_LastPx IN NUMBER, --
                p_LeavesQty IN NUMBER, --khoi luong thay doi so voi lenh goc
                p_OrderQty2 IN NUMBER,
                p_err_msg OUT VARCHAR2
                )
  AS
    v_count number;
    BEGIN
      p_err_code := '0';
      p_err_msg:='sp_proces_msg_confirm_amend p_OrderID=>'||p_OrderID;
      -- Check BO Order
      SELECT COUNT(*) INTO v_count FROM orders WHERE orderid = p_ClOrdID;
      IF (v_count = 0) THEN
        p_err_code := '00';
        RETURN;
      END IF;
      /*tiendt fix bug, cancel for amend
      date: 2015-08-21*/
      --CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_ClOrdID,p_OrderID,'S',p_TransactTime);
      CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_ClOrdID,p_OrigClOrdID,'S',p_TransactTime,p_LastQty,p_LastPx,p_LeavesQty,p_OrderQty2,p_err_msg);
      --end
      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_msg_confirm_amend '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_confirm_amend;


  PROCEDURE sp_proces_msg_respone_trade(p_err_code in OUT VARCHAR,
                p_MsgSeqNum IN VARCHAR, --
                p_OrdStatus IN VARCHAR, --
                p_ClOrdID IN OUT VARCHAR, --So hieu lenh cua cong ty chung khoan,N
                p_OrigClOrdID IN VARCHAR, --
                p_SecondaryClOrdID IN VARCHAR, --
                p_OrderID IN VARCHAR, --So hieu lenh cua So,use
                p_TransactTime IN VARCHAR, --use format: yyyyMMdd-HH24:MI:SS
                p_LastQty IN NUMBER, --Khoi luong khop lenh,use
                p_LastPx IN NUMBER, --Gia khop lenh,use
                p_ExecID IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_Symbol IN VARCHAR, --Ma chung khoan, use
                p_Contra_ClOrdID OUT VARCHAR, --So hieu lenh doi ung cua lenh thoa thuan cung cong ty
                p_err_msg OUT VARCHAR2)
  AS
    v_orderid VARCHAR(20);
    v_cancl_orderid VARCHAR(20);
    v_acctno VARCHAR(20);
    v_subtypecd VARCHAR(4);
    v_quote_qtty NUMBER;
    v_remain_qtty NUMBER; --khoi luong con lai cua lenh truoc khi khop
    v_qtty NUMBER; --khoi luong con lai cua lenh sau khi khop
    v_price NUMBER;
    v_price_ce NUMBER;
    v_price_fl NUMBER;
    v_subside VARCHAR(2);
    v_side varchar(1);
    v_status varchar(2);
    v_sub_status varchar(2);
    v_symbol varchar(15);
    v_reforderid varchar(20);
    v_rootorderid varchar(20);
    v_quote_price number;
    v_typecd varchar(10);
    v_userid varchar(10);
    v_quoteid varchar(20);
    v_sessionnex varchar(5);
    v_count NUMBER;
    v_count_second NUMBER;

    BEGIN
    --dbms_output.enable(10000);
       p_err_code := '0';
       p_err_msg:='sp_proces_msg_respone_trade p_OrderID=>'||p_OrderID;
       IF(p_Side='8') THEN  -- process cross order
        --dbms_output.put_line('Fuck..........');
        SELECT COUNT(ORDERID) INTO v_count FROM ORDERS WHERE ORDERID=p_ClOrdID;
        --dbms_output.put_line('Bla ble..........'||p_ClOrdID);
        IF(v_count=1) THEN  -- Cross Order: selling side and buying side are inside a company
          -- Get general information of first side of original cross order
          SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                 SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID, ROOTORDERID,
                 QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
          INTO v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
               v_side, v_status, v_sub_status, v_symbol, v_reforderid, v_rootorderid,
               v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
          FROM ORDERS
          WHERE ORDERID=p_ClOrdID;
          --dbms_output.put_line('Hahaha..........'||p_ClOrdID);
          -- If ORDERS.ROOTORDERID = p_ExecID, it means the cross order was matched
          -- In this case, either HNX disapproves cross cancellation request or the buying side denies cross cancellation request
          IF (v_rootorderid=p_ExecID) THEN
            --DBMS_OUTPUT.PUT_LINE('v_rootorderid: '||v_rootorderid);
            --DBMS_OUTPUT.PUT_LINE('p_ExecID: '||p_ExecID);
            IF (v_side='O') THEN
              -- p_ClOrdID is identifier of buying cancellation order
              SELECT REFORDERID INTO v_cancl_orderid FROM ORDERS WHERE ORDERID=p_ClOrdID;
              CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code, v_cancl_orderid, p_ClOrdID,p_err_msg);
              --DBMS_OUTPUT.PUT_LINE('v_cancl_orderid: '||v_cancl_orderid);
              --DBMS_OUTPUT.PUT_LINE('p_ClOrdID: '||p_ClOrdID);
              --DBMS_OUTPUT.PUT_LINE('p_err_code: '||p_err_code);
            ELSE
              -- p_ClOrdID is identifier of original buying order
              SELECT ORDERID INTO v_cancl_orderid FROM ORDERS WHERE REFORDERID=p_ClOrdID;
              CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code, p_ClOrdID, v_cancl_orderid,p_err_msg);
              --DBMS_OUTPUT.PUT_LINE('v_cancl_orderid: '||v_cancl_orderid);
              --DBMS_OUTPUT.PUT_LINE('p_ClOrdID: '||p_ClOrdID);
              --DBMS_OUTPUT.PUT_LINE('p_err_code: '||p_err_code);
            END IF;
            p_ClOrdID := NULL;
            --RETURN;
          ELSE
            -- Confirm
            CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,v_orderid,p_OrderID,'S',p_TransactTime,0,0,0,0,p_err_msg);
            --DBMS_OUTPUT.PUT_LINE('Confirm............:'||p_err_code);
            --DBMS_OUTPUT.PUT_LINE('v_orderid: '||v_orderid);
            --DBMS_OUTPUT.PUT_LINE('p_OrderID: '||p_OrderID);
            --DBMS_OUTPUT.PUT_LINE('p_err_code: '||p_err_code);
            -- Trading
            CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,p_LastQty,p_LastPx,p_OrderID,p_TransactTime,p_ExecID,p_err_msg);
            IF p_err_code != '0' THEN
              RETURN;
            END IF;
            --DBMS_OUTPUT.PUT_LINE('Trading............:'||p_err_code);
            --DBMS_OUTPUT.PUT_LINE('v_orderid: '||v_orderid);
            --DBMS_OUTPUT.PUT_LINE('p_OrderID: '||p_OrderID);
            --DBMS_OUTPUT.PUT_LINE('p_err_code: '||p_err_code);
            -- Update ExecID
            UPDATE ORDERS SET ROOTORDERID = p_ExecID WHERE ORDERID = v_orderid;
          END IF;

          -- Get general information of contract side of original cross order
          IF (v_side='B' OR v_side='S') THEN
            SELECT COUNT(ORDERID) INTO v_count_second FROM ORDERS
            WHERE ORDERID!=DECODE(p_ClOrdID,NULL,v_orderid,p_ClOrdID) AND QUOTEID=v_quoteid;
            IF (v_count_second=0) THEN
              RETURN;
            END IF;

            --DBMS_OUTPUT.PUT_LINE('Bef getting contract: v_quoteid='||v_quoteid||' v_orderid='||v_orderid);
            SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                   SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID, ROOTORDERID,
                   QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
            INTO v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
                 v_side, v_status, v_sub_status, v_symbol, v_reforderid, v_rootorderid,
                 v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
            FROM ORDERS
            WHERE ORDERID!=DECODE(p_ClOrdID,NULL,v_orderid,p_ClOrdID)
            AND QUOTEID=v_quoteid;
            --DBMS_OUTPUT.PUT_LINE('After getting contract: v_quoteid='||v_quoteid||' v_orderid='||v_orderid);
          ELSE
            SELECT COUNT(ORDERID) INTO v_count_second FROM ORDERS
            WHERE ORDERID!=DECODE(p_ClOrdID,NULL,v_orderid,p_ClOrdID) AND CONFIRMID=p_OrigClOrdID AND SIDE='O';
            IF (v_count_second=0) THEN
              RETURN;
            END IF;

            --DBMS_OUTPUT.PUT_LINE('Before getting contract: v_quoteid='||v_quoteid||' v_orderid='||v_orderid);
            SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                   SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID, ROOTORDERID,
                   QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
            INTO v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
                 v_side, v_status, v_sub_status, v_symbol, v_reforderid, v_rootorderid,
                 v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
            FROM ORDERS
            WHERE ORDERID!=DECODE(p_ClOrdID,NULL,v_orderid,p_ClOrdID) AND CONFIRMID=p_OrigClOrdID AND SIDE='O';
            --DBMS_OUTPUT.PUT_LINE('After getting contract: '||v_quoteid);
          END IF;
          -- If ORDERS.ROOTORDERID = p_ExecID, it means the cross order was matched
          -- In this case, either HNX disapproves cross cancellation request or the buying side denies cross cancellation request
          IF (v_rootorderid=p_ExecID) THEN
            --DBMS_OUTPUT.PUT_LINE('v_rootorderid: '||v_rootorderid);
            --DBMS_OUTPUT.PUT_LINE('p_ExecID: '||p_ExecID);
            IF (v_side='O') THEN
              -- v_orderid is identifier of selling cancellation order
              SELECT REFORDERID INTO v_cancl_orderid FROM ORDERS WHERE ORDERID=v_orderid;
              CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code, v_cancl_orderid, v_orderid,p_err_msg);
              --DBMS_OUTPUT.PUT_LINE('v_cancl_orderid: '||v_cancl_orderid);
              --DBMS_OUTPUT.PUT_LINE('v_orderid: '||v_orderid);
              --DBMS_OUTPUT.PUT_LINE('p_err_code: '||p_err_code);
            ELSE
              -- v_orderid is identifier of original selling order
              SELECT ORDERID INTO v_cancl_orderid FROM ORDERS WHERE REFORDERID=v_orderid;
              CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code, v_orderid, v_cancl_orderid,p_err_msg);
              --DBMS_OUTPUT.PUT_LINE('v_cancl_orderid: '||v_cancl_orderid);
              --DBMS_OUTPUT.PUT_LINE('v_orderid: '||v_orderid);
              --DBMS_OUTPUT.PUT_LINE('p_err_code: '||p_err_code);
            END IF;
            p_ClOrdID := NULL;
            --RETURN;
          ELSE
            -- Return orderid for synchronizing to BO
            p_Contra_ClOrdID := v_orderid;
            --DBMS_OUTPUT.PUT_LINE('p_Contra_ClOrdID: '||p_Contra_ClOrdID);
            -- Confirm
            CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,v_orderid,p_OrderID,'S',p_TransactTime,0,0,0,0,p_err_msg);
            -- Trading
            CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,p_LastQty,p_LastPx,p_OrderID,p_TransactTime,p_ExecID,p_err_msg);
            IF p_err_code != '0' THEN
              RETURN;
            END IF;
            -- Update ExecID
            UPDATE ORDERS SET ROOTORDERID = p_ExecID WHERE ORDERID = v_orderid;
          END IF;

        ELSE  -- Cross Order: selling side or buying side is outside Company
          -- Get general information of original cross order
          SELECT COUNT(ORDERID) INTO v_count_second FROM ORDERS WHERE CONFIRMID=p_OrderID;
          IF (v_count_second=1) THEN
            SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                   SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID, ROOTORDERID,
                   QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
            INTO  v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
                  v_side, v_status, v_sub_status, v_symbol, v_reforderid, v_rootorderid,
                  v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
            FROM ORDERS
            WHERE CONFIRMID=p_OrderID;
          ELSIF (v_count_second=2) THEN
            SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                   SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID, ROOTORDERID,
                   QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
            INTO  v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
                  v_side, v_status, v_sub_status, v_symbol, v_reforderid, v_rootorderid,
                  v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
            FROM ORDERS
            WHERE CONFIRMID=p_OrderID AND REFORDERID IS NULL /*REFORDERID IS NOT NULL*/;
          END IF;
          -- If ORDERS.ROOTORDERID = p_ExecID, it means the cross order was matched
          -- In this case, either HNX disapproves cross cancellation request or the buying side denies cross cancellation request
          IF (v_rootorderid=p_ExecID) THEN
            SELECT ORDERID, QUOTEID INTO v_cancl_orderid, v_quoteid FROM ORDERS WHERE REFORDERID=v_orderid;
            --dbms_output.put_line('v_cancl_orderid: '||v_cancl_orderid);
            CSPKS_FO_ORDER_CROSS.sp_proces_reject_cancel_cross(p_err_code, v_orderid, v_cancl_orderid,p_err_msg);
            --dbms_output.put_line('p_err_code: '||p_err_code);
            -- Update status of QUOTES
            UPDATE QUOTES SET STATUS=DECODE(TYPECD,'N','R',STATUS) WHERE QUOTEID=v_quoteid;
            p_ClOrdID := NULL;
            --RETURN;
          ELSE
            -- Return orderid for synchronizing to BO
            p_ClOrdID := v_orderid;
            -- Update order status for buying side
            IF (v_side='B') THEN
              CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,v_orderid,p_OrderID,'A',p_TransactTime,0,0,0,0,p_err_msg);
            ELSIF (v_side='S') THEN
              UPDATE QUOTES SET STATUS='F' WHERE QUOTEID=v_quoteid;
            END IF;
            -- Trading
            CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,p_LastQty,p_LastPx,p_OrderID,p_TransactTime,p_ExecID,p_err_msg);
            IF p_err_code != '0' THEN
              RETURN;
            END IF;
            -- Update ExecID
            UPDATE ORDERS SET ROOTORDERID = p_ExecID WHERE ORDERID = v_orderid;
          END IF;
        END IF;
       ELSE  -- process single order
          --Check BO order
         SELECT COUNT(*) INTO v_count FROM orders WHERE CONFIRMID=p_OrigClOrdID;
         IF (v_count = 0) THEN
            /*
             * Ediotr: Trung.Nguyen
             * Date: 11-Dec-2015
             */
            p_err_code := '0';
            p_ClOrdID := null;
            INSERT INTO TRADING_EXCEPTION(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time)
            VALUES (SEQ_MSG_832.NEXTVAL,p_MsgSeqNum, p_OrdStatus, p_ClOrdID, p_OrigClOrdID, p_SecondaryClOrdID, p_OrderID, p_TransactTime, p_LastQty, p_LastPx, p_ExecID, p_Side, p_Symbol, p_Contra_ClOrdID, sysdate);
            --COMMIT;
            RETURN;
         END IF;
         --dbms_output.put_line('v_count' || v_count) ;
          -- Trade Orig Order
          SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                 SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID,
                 QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
          INTO  v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
                v_side, v_status, v_sub_status, v_symbol, v_reforderid,
                v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
          FROM ORDERS
          WHERE CONFIRMID=p_OrigClOrdID
          AND (SUBSTATUS = 'SS' OR SUBSTATUS = 'ES' OR SUBSTATUS = 'SE' OR SUBSTATUS = 'SD' OR SUBSTATUS = 'DD' OR SUBSTATUS = 'FF');
          --dbms_output.put_line('3333 :');
          -- Return orderid for synchronizing to BO
          p_ClOrdID := v_orderid;
          -- Trading
          CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,p_LastQty,p_LastPx,p_OrigClOrdID,p_TransactTime,p_ExecID,p_err_msg);
          IF p_err_code != '0' THEN
            /*
             * Ediotr: Trung.Nguyen
             * Date: 18-Dec-2015
             */
            IF (p_err_code = '-95042') THEN
              p_err_code := '0';
              INSERT INTO TRADING_EXCEPTION(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time)
              VALUES (SEQ_MSG_832.NEXTVAL,p_MsgSeqNum, p_OrdStatus, v_orderid, p_OrigClOrdID, p_SecondaryClOrdID, p_OrderID, p_TransactTime, p_LastQty, p_LastPx, p_ExecID, p_Side, p_Symbol, p_Contra_ClOrdID, sysdate);
              --24/12/2015, AnhHT: sua cho truong hop confirm sua gia ve sau msg khop, tra ra errorcode = 0, nhung ko dong bo
              p_ClOrdID := null;

            END IF;
            RETURN;
          END IF;
          --dbms_output.put_line('44444 :');
          -- Trade Secondary order
--          SELECT COUNT(*) INTO v_count_second FROM ORDERS WHERE CONFIRMID=p_SecondaryClOrdID;
--          IF v_count_second = 0 THEN
--             p_err_code := '11';
--             return;
--          END IF;

--          IF v_count_second >= 1 THEN
--            SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
--                   SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID,
--                   QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
--            INTO  v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
--                  v_side, v_status, v_sub_status, v_symbol, v_reforderid,
--                  v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
--            FROM ORDERS
--            WHERE CONFIRMID=p_SecondaryClOrdID
--            AND (SUBSTATUS = 'SS' OR SUBSTATUS = 'ES');
--            -- Return orderid for synchronizing to BO
--            p_ClOrdID := v_orderid;
--            -- Trading
--            CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,p_LastQty,p_LastPx,p_SecondaryClOrdID,p_TransactTime);
              --IF p_err_code != '0' THEN
                --RETURN;
              --END IF;
--          END IF;
       END IF;

       --dbms_output.put_line('Error Code1111:' || p_err_code);
--      v_qtty := v_remain_qtty - p_LastQty;
--       IF v_qtty > 0 THEN
--           IF v_subtypecd = 'MAK' THEN
--               --Khop khong het thi huy phan con lai
--               /*CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm_cancel(
--                    p_err_code,v_orderid,p_OrderID,'S',p_TransactTime,
--                    v_side,v_subside,v_status,v_sub_status,v_acctno,
--                    v_symbol,v_reforderid,v_quote_qtty,v_remain_qtty,v_quote_price,
--                    v_typecd,v_userid,v_quoteid,v_sessionnex);   */
--               p_err_code := '0';
--           ELSIF v_subtypecd = 'MTL' THEN
--              SELECT PRICE_CE,PRICE_FL INTO v_price_ce,v_price_fl FROM INSTRUMENTS WHERE SYMBOL=p_Symbol;
--              IF v_subside='NB' OR v_subside='AB' THEN
--                  --v_price := nvl(0,p_LastPx + 100);
--                  v_price := LEAST(p_LastPx + 100, v_price_ce);
--                  -- dbms_output.put_line('p_LastPx :' || p_LastPx);
--                  -- dbms_output.put_line('v_price_ce :' || v_price_ce);
--                  -- dbms_output.put_line('v_price :' || v_price);
--              ELSE --lenh ban
--                  --v_price := nvl(0,p_LastPx - 100);
--                  v_price := GREATEST(p_LastPx + 100, v_price_fl);
--                  --dbms_output.put_line('p_LastPx :' || p_LastPx);
--                  --dbms_output.put_line('v_price_fl :' || v_price_fl);
--                  --dbms_output.put_line('v_price :' || v_price);
--              END IF;
--              --chuyen thanh lenh LO
--              UPDATE ORDERS SET TYPECD='LO', SUBTYPECD='LO',QUOTE_PRICE=v_price WHERE CONFIRMID=p_OrderID;
--           END IF;
--       END IF;
--

--      EXCEPTION
--        WHEN OTHERS THEN
--          p_err_code := 'ERA0025';
EXCEPTION
        WHEN OTHERS THEN
          p_err_msg:='sp_proces_msg_respone_trade '||p_err_msg||' sqlerrm = '||SQLERRM;
END sp_proces_msg_respone_trade;

  --For trading second
  PROCEDURE sp_proces_respone_trade_second(p_err_code in OUT VARCHAR,
                p_MsgSeqNum IN VARCHAR, --
                p_OrdStatus IN VARCHAR, --
                p_ClOrdID IN OUT VARCHAR, --So hieu lenh cua cong ty chung khoan,N
                p_OrigClOrdID IN VARCHAR, --
                p_SecondaryClOrdID IN VARCHAR, --
                p_OrderID IN VARCHAR, --So hieu lenh cua So,use
                p_TransactTime IN VARCHAR, --use format: yyyyMMdd-HH24:MI:SS
                p_LastQty IN NUMBER, --Khoi luong khop lenh,use
                p_LastPx IN NUMBER, --Gia khop lenh,use
                p_ExecID IN VARCHAR, --
                p_Side IN VARCHAR, --
                p_Symbol IN VARCHAR, --Ma chung khoan, use
                p_Contra_ClOrdID OUT VARCHAR, --So hieu lenh doi ung cua lenh thoa thuan cung cong ty
                p_err_msg OUT VARCHAR2)
  AS
    v_orderid VARCHAR(20);
    v_cancl_orderid VARCHAR(20);
    v_acctno VARCHAR(20);
    v_subtypecd VARCHAR(4);
    v_quote_qtty NUMBER;
    v_remain_qtty NUMBER; --khoi luong con lai cua lenh truoc khi khop
    v_qtty NUMBER; --khoi luong con lai cua lenh sau khi khop
    v_price NUMBER;
    v_price_ce NUMBER;
    v_price_fl NUMBER;
    v_subside VARCHAR(2);
    v_side varchar(1);
    v_status varchar(2);
    v_sub_status varchar(2);
    v_symbol varchar(15);
    v_reforderid varchar(20);
    v_rootorderid varchar(20);
    v_quote_price number;
    v_typecd varchar(10);
    v_userid varchar(10);
    v_quoteid varchar(20);
    v_sessionnex varchar(5);
    v_count NUMBER;
    v_count_second NUMBER;

    BEGIN
       p_err_code := '0';
       p_err_msg:='sp_proces_respone_trade_second p_OrderID=>'||p_OrderID;
       IF(p_Side!='8') THEN  -- process single order
          -- Trade Secondary order
          SELECT COUNT(*) INTO v_count_second FROM ORDERS WHERE CONFIRMID=p_SecondaryClOrdID;
          IF v_count_second = 0 THEN
            /*
             * Editor: Trung.Nguyen
             * Date: 11-Dec-2015
             */
            p_err_code := '0';

            INSERT INTO TRADING_EXCEPTION(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time)
            VALUES (SEQ_MSG_832.NEXTVAL,p_MsgSeqNum, p_OrdStatus, p_ClOrdID, p_SecondaryClOrdID, NULL, p_OrderID, p_TransactTime, p_LastQty, p_LastPx, p_ExecID, p_Side, p_Symbol, p_Contra_ClOrdID, sysdate);
             p_ClOrdID := null;
            RETURN;
          END IF;
            SELECT ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE,
                   SIDE, STATUS, SUBSTATUS, SYMBOL, REFORDERID,
                   QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
            INTO  v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside,
                  v_side, v_status, v_sub_status, v_symbol, v_reforderid,
                  v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
            FROM ORDERS
            WHERE CONFIRMID=p_SecondaryClOrdID
            AND (SUBSTATUS = 'SS' OR SUBSTATUS = 'ES' OR SUBSTATUS = 'SE' OR SUBSTATUS = 'SD' OR SUBSTATUS = 'DD'  OR SUBSTATUS = 'FF');
            -- Return orderid for synchronizing to BO
            p_ClOrdID := v_orderid;
            -- Trading
            CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,p_LastQty,p_LastPx,p_SecondaryClOrdID,p_TransactTime,p_ExecID,p_err_msg);
            IF p_err_code != '0' THEN
              IF p_err_code = '-95042' THEN
                /*
                 * Ediotr: Trung.Nguyen
                 * Date: 18-Dec-2015
                 */
                p_err_code := '0';
                INSERT INTO TRADING_EXCEPTION(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time)
                VALUES (SEQ_MSG_832.NEXTVAL,p_MsgSeqNum, p_OrdStatus, v_orderid, p_SecondaryClOrdID, NULL, p_OrderID, p_TransactTime, p_LastQty, p_LastPx, p_ExecID, p_Side, p_Symbol, p_Contra_ClOrdID, sysdate);
               --24/12/2015, AnhHT: sua cho truong hop confirm sua gia ve sau msg khop, tra ra errorcode = 0, nhung ko dong bo
                p_ClOrdID := null;

              END IF;
              RETURN;
            END IF;
      ELSE
        p_err_code := '00';

      END IF;

      EXCEPTION
        WHEN OTHERS THEN
          p_err_code := '-90025';
          p_err_msg:='sp_proces_respone_trade_second '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_respone_trade_second;


  /*
   * Author: Trung.Nguyen
   * Parameters:
   *        p_MsgSeqNum
   *        p_OrdStatus
   *        p_ClOrdID:                  order identifier of Securities Comp,...
   *        p_OrderID:                  order identifier that to be rejected (ID was generated by HNX)
   *        p_TransactTime:
   *        p_OrdRejReason:           the reason why HNX rejects order
   *        p_UnderlyingLastQty:    stock quantity that is rejected by HNX
   *        p_Side:                       (1)-Buying; (2)-Selling
   *        p_OrdType:                  order types- LO, MTL, MOK, MAK,...
   * Description:
   */
  PROCEDURE sp_proces_msg_decline_order(p_err_code IN OUT VARCHAR,
              p_MsgSeqNum IN VARCHAR,
              p_OrdStatus IN VARCHAR,
              p_ClOrdID IN OUT VARCHAR,
              p_OrderID IN VARCHAR,
              p_TransactTime IN VARCHAR,
              p_OrdRejReason IN VARCHAR,
              p_UnderlyingLastQty IN NUMBER,
              p_Side IN VARCHAR,
              p_OrdType IN VARCHAR,
              p_err_msg OUT VARCHAR2)
  AS
    v_orderid             ORDERS.ORDERID%TYPE;
    v_acctno                ORDERS.ACCTNO%TYPE;
    v_subtypecd           ORDERS.SUBTYPECD%TYPE;
    v_quote_qtty          ORDERS.QUOTE_QTTY%TYPE;
    v_mort_qtty           ORDERS.MORT_QTTY%TYPE;
    v_remain_qtty     ORDERS.REMAIN_QTTY%TYPE;
    v_side                  ORDERS.SIDE%TYPE;
    v_subside             ORDERS.SUBSIDE%TYPE;
    v_status                ORDERS.STATUS%TYPE;
    v_substatus           ORDERS.SUBSTATUS%TYPE;
    v_symbol                ORDERS.SYMBOL%TYPE;
    v_reforderid          ORDERS.REFORDERID%TYPE;
    v_quote_price       ORDERS.QUOTE_PRICE%TYPE;
    v_typecd                ORDERS.TYPECD%TYPE;
    v_userid                ORDERS.USERID%TYPE;
    v_quoteid             ORDERS.QUOTEID%TYPE;
    v_sessionnex          ORDERS.SESSIONEX%TYPE;
  BEGIN
  --dbms_output.enable();
    p_err_code := '0';
    p_err_msg:='sp_proces_msg_decline_order p_OrderID=>'||p_OrderID;
    SELECT  ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, MORT_QTTY, REMAIN_QTTY, SIDE, SUBSIDE, STATUS,
            SUBSTATUS, SYMBOL, REFORDERID, QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
    INTO    v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_mort_qtty, v_remain_qtty, v_side, v_subside, v_status,
          v_substatus, v_symbol, v_reforderid, v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
    FROM ORDERS
    --WHERE ORDERID=p_ClOrdID;
    WHERE (CONFIRMID=p_OrderID OR ORDERID=p_ClOrdID)
    AND (SUBSTATUS='SS' OR SUBSTATUS='ES' OR SUBSTATUS = 'BB');

    -- If freed quantity is more than order remain quantity then do nothing and return
    IF (p_UnderlyingLastQty > v_remain_qtty) THEN
      p_err_code := '-90033';
      RETURN;
    END IF;
  /*
  dbms_output.put_line('p_err_code:' || p_err_code);
dbms_output.put_line('p_order_id:' || v_orderid);
dbms_output.put_line('v_side:' || v_side);
dbms_output.put_line('v_sub_side:' || v_subside);
dbms_output.put_line('v_acctno:' || v_acctno);
dbms_output.put_line('v_symbol:' || v_symbol);
dbms_output.put_line('v_remain_qtty:' || v_remain_qtty);
dbms_output.put_line('v_mort_qtty:' || v_mort_qtty);
dbms_output.put_line('v_quote_price:' || v_quote_price);
 dbms_output.put_line('p_UnderlyingLastQty:' || p_UnderlyingLastQty);
  */
    --dbms_output.put_line('Starting free order.....');
    CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, v_orderid, v_side, v_subside, v_acctno, v_symbol, p_UnderlyingLastQty, v_remain_qtty, v_mort_qtty, v_quote_price, p_err_msg, '');
    --23/12/2015,AnhHT lay orderid cua lenh sua con hieu luc
    p_ClOrdID := v_orderid;
    -- EXCEPTION
    -- WHEN TOO_MANY_ROWS THEN p_err_msg := 'sp_proces_msg_decline_order: ORA-01422: exact fetch returns more than requested number of rows';
 EXCEPTION WHEN OTHERS THEN
      p_err_code := '-90025';
      p_err_msg:='sp_proces_msg_decline_order '||p_err_msg||' sqlerrm = '||SQLERRM;
END sp_proces_msg_decline_order;

  /*
   * Author: Trung.Nguyen
   * Parameters:
   *        p_crossid:            identifier of cross order which HNX generated and forwarded to all
   *        p_sell_clordid:     identifier of request which seller sent to HNX
   *        p_symbol:               symbol of securities
   *        p_qtty:                 quantity of securities
   *        p_price:                price of securities
   *        p_sender_comp_id:   identifier of company that sends request from HNX
   *        p_buy_party_id:     identifier of buying side
   *        p_sell_party_id:    identifier of selling side
   *        p_buy_acctno:         account number of buyer
   *        p_sell_acctno:      account number of seller
   *        p_adv_id:               identifier of advertisement order in that case cross order bases on
   * Description:
   */
  PROCEDURE sp_proces_msg_fowd_cross(p_err_code OUT VARCHAR,
              p_crossid IN VARCHAR,
              p_sell_clordid IN VARCHAR,
              p_symbol IN VARCHAR,
              p_qtty IN NUMBER,
              p_price IN NUMBER,
              p_sender_comp_id IN VARCHAR,
              p_buy_party_id IN VARCHAR,
              p_sell_party_id IN VARCHAR,
              p_buy_acctno IN VARCHAR,
              p_sell_acctno IN VARCHAR,
              p_adv_id IN VARCHAR,
              p_err_msg OUT VARCHAR2)
  AS
    cst_target_comp_id      CONSTANT    VARCHAR(5) := '091';        -- identifier of MSBS
    v_quote_id                        QUOTES.QUOTEID%TYPE;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_proces_msg_fowd_cross p_crossid=>'||p_crossid;
    IF ((cst_target_comp_id = p_buy_party_id) AND (cst_target_comp_id = p_sell_party_id)) THEN
      p_err_code := '-90025';
    ELSIF(cst_target_comp_id = p_sell_party_id) THEN
      -- Confirm
      CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_sell_clordid,p_crossid,'S',NULL,0,0,0,0,p_err_msg);
    ELSIF(cst_target_comp_id = p_buy_party_id) THEN
      CSPKS_FO_ORDER_CROSS.sp_proces_msg_forward_cross(p_err_code, p_crossid, p_symbol, p_qtty, p_price, 'B', p_sell_party_id, p_buy_acctno, p_sell_acctno, p_adv_id,p_err_msg);
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_proces_msg_fowd_cross '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_fowd_cross;

  /*
   * Author: Trung.Nguyen
   * Parameters:
   *        p_org_crossid:          identifier of cross order which HNX generated and forwarded to all
   * Description: used in package CSPKS_FO_GW_HNX
   */
  PROCEDURE sp_proces_msg_fowd_cancl_cross(p_err_code OUT VARCHAR,
            p_orderid OUT VARCHAR,
            p_org_crossid IN VARCHAR,
      p_err_msg OUT VARCHAR2)
  AS
    v_count                     NUMBER;
    v_cnt                         NUMBER;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_proces_msg_fowd_cancl_cross p_org_crossid=>'||p_org_crossid;
    SELECT COUNT(ORDERID) INTO v_count FROM ORDERS WHERE CONFIRMID = p_org_crossid AND SIDE IN ('B','S');

    IF (v_count = 0) THEN
      p_err_code := '-90025';
    ELSE
      UPDATE ORDERS SET STATUS='U', SUBSTATUS='U1' WHERE CONFIRMID = p_org_crossid AND SUBSIDE = 'CS';
      UPDATE ORDERS SET STATUS='U', SUBSTATUS='U5' WHERE CONFIRMID = p_org_crossid AND SUBSIDE = 'NS';
      UPDATE ORDERS SET STATUS='U', SUBSTATUS='U1' WHERE CONFIRMID = p_org_crossid AND SUBSIDE = 'NB';

      SELECT COUNT(ORDERID) INTO v_cnt FROM ORDERS WHERE CONFIRMID = p_org_crossid AND SIDE = 'B';
      IF (v_cnt=1) THEN
        SELECT ORDERID INTO p_orderid FROM ORDERS WHERE CONFIRMID = p_org_crossid AND SIDE = 'B';
      END IF;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN
       p_err_code := '-90025';
       p_err_msg:=p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_fowd_cancl_cross;

  /*
   * Author: Trung.Nguyen
   * Parameters:
   *    p_msgtype:      error message type (MsgType=3)
   *    p_reject_code:  error code describes error content
   *    p_content:
   *    p_order_id:     order identifier was generated by Securities Comp.,
   * Description
   */
  PROCEDURE sp_proces_msg_reject_order(p_err_code OUT VARCHAR,
            p_msgtype IN VARCHAR,
            p_reject_code IN VARCHAR,
            p_content IN VARCHAR,
            p_order_id IN OUT VARCHAR,
            p_contra_order_id OUT VARCHAR,
            p_err_msg OUT VARCHAR2)
  AS
    v_quote_id          ORDERS.QUOTEID%TYPE;
    v_acctno            ORDERS.ACCTNO%TYPE;
    v_quote_qtty        ORDERS.QUOTE_QTTY%TYPE;
    v_mort_qtty         ORDERS.MORT_QTTY%TYPE;
    v_remain_qtty       ORDERS.REMAIN_QTTY%TYPE;
    v_side              ORDERS.SIDE%TYPE;
    v_sub_side          ORDERS.SUBSIDE%TYPE;
    v_symbol            ORDERS.SYMBOL%TYPE;
    v_quote_price       ORDERS.QUOTE_PRICE%TYPE;
    v_confirm_id        ORDERS.CONFIRMID%TYPE;
    v_freed_qtty        NUMBER;
    v_count             NUMBER;
  BEGIN
    p_err_code := '0';
    p_err_msg:='sp_proces_msg_reject_order p_order_id=>'||p_order_id;
    SELECT  ORDERID, QUOTEID, ACCTNO, QUOTE_QTTY, MORT_QTTY, REMAIN_QTTY, SIDE, SUBSIDE, SYMBOL, QUOTE_PRICE, CONFIRMID
    INTO    p_order_id, v_quote_id, v_acctno, v_quote_qtty, v_mort_qtty, v_remain_qtty, v_side, v_sub_side, v_symbol, v_quote_price, v_confirm_id
    FROM ORDERS
    WHERE ORDERID=p_order_id;

    -- For cross order 1 firm
    SELECT COUNT(ORDERID) INTO v_count
    FROM ORDERS
    WHERE QUOTEID=v_quote_id AND ORDERID!=p_order_id;

    v_freed_qtty := v_quote_qtty;
    -- Ghi vao bang log
    CSPKS_FO_ORDER_RESPONE.sp_proces_respone_error(p_err_code, p_msgtype, p_reject_code, p_content,p_err_msg);

    IF v_side = 'O' THEN
      -- Giai toa lenh huy sua
      CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_order_id,v_confirm_id,'F',null,0,0,0,0,p_err_msg);
      /*
       * Editor: Trung.Nguyen
       * Date: 30-Dec-2015
       * Description: confirm contra side for cross order 1 firm
       */
      IF (v_count=1) THEN
        SELECT  ORDERID, CONFIRMID
        INTO    p_contra_order_id, v_confirm_id
        FROM ORDERS
        WHERE QUOTEID=v_quote_id AND ORDERID!=p_order_id;
        CSPKS_FO_ORDER_RESPONE.sp_proces_order_confirm(p_err_code,p_contra_order_id,v_confirm_id,'F',null,0,0,0,0,p_err_msg);
      END IF;
    ELSE
      -- Giai toa lenh goc
      CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, p_order_id, v_side, v_sub_side, v_acctno, v_symbol, v_freed_qtty , v_remain_qtty , v_mort_qtty, v_quote_price, p_err_msg, '');
      /*
       * Editor: Trung.Nguyen
       * Date: 30-Dec-2015
       * Description: release contra side for cross order 1 firm
       */
      IF (v_count=1) THEN
        SELECT  ORDERID, QUOTEID, ACCTNO, QUOTE_QTTY, MORT_QTTY, REMAIN_QTTY, SIDE, SUBSIDE, SYMBOL, QUOTE_PRICE, CONFIRMID
        INTO    p_contra_order_id, v_quote_id, v_acctno, v_quote_qtty, v_mort_qtty, v_remain_qtty, v_side, v_sub_side, v_symbol, v_quote_price, v_confirm_id
        FROM ORDERS
        WHERE QUOTEID=v_quote_id AND ORDERID!=p_order_id;
        v_freed_qtty := v_quote_qtty;
        CSPKS_FO_ORDER_RESPONE.sp_proces_confirm_free_order(p_err_code, p_contra_order_id, v_side, v_sub_side, v_acctno, v_symbol, v_freed_qtty , v_remain_qtty , v_mort_qtty, v_quote_price, p_err_msg, '');
      END IF;
    END IF;
    --COMMIT;
--    EXCEPTION
--      WHEN OTHERS THEN p_err_code := '00';
  EXCEPTION WHEN OTHERS THEN
      p_err_msg:='sp_proces_msg_reject_order '||p_err_msg||' sqlerrm = '||SQLERRM;
  END sp_proces_msg_reject_order;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *      p_err_code
     *      p_err_msg
     * Description:
     */
    PROCEDURE sp_proces_recover_trading(p_err_code IN OUT VARCHAR, p_err_msg OUT VARCHAR2)
    AS
        v_orderid               ORDERS.ORDERID%TYPE;
        v_acctno                ORDERS.ACCTNO%TYPE;
        v_subtypecd             ORDERS.SUBTYPECD%TYPE;
        v_quote_qtty            ORDERS.QUOTE_QTTY%TYPE;
        v_remain_qtty           ORDERS.REMAIN_QTTY%TYPE;
        v_subside               ORDERS.SUBSIDE%TYPE;
        v_side                  ORDERS.SIDE%TYPE;
        v_status                ORDERS.STATUS%TYPE;
        v_sub_status            ORDERS.SUBSTATUS%TYPE;
        v_symbol                ORDERS.SYMBOL%TYPE;
        v_reforderid            ORDERS.REFORDERID%TYPE;
        v_quote_price           ORDERS.QUOTE_PRICE%TYPE;
        v_typecd                ORDERS.TYPECD%TYPE;
        v_userid                ORDERS.USERID%TYPE;
        v_quoteid               ORDERS.QUOTEID%TYPE;
        v_sessionnex            ORDERS.SESSIONEX%TYPE;
        v_count                 NUMBER;
    BEGIN
        p_err_code:='0';
        p_err_msg:='sp_proces_recover_trading';
        FOR recd IN (
            SELECT MSGID, MSGSEQNUM, ORDSTATUS, CLORDID, ORIGCLORDID, SECONDARYCLORDID, ORDERID,
                   TRANSACTTIME, LASTQTY, LASTPX, EXECID, SIDE, SYMBOL, CONTRA_CLORDID, CREATE_TIME
            FROM TRADING_EXCEPTION WHERE CREATE_TIME <= SYSDATE - 1/24/120 AND ROWNUM <=20
            ORDER BY CREATE_TIME
        )
        LOOP
          IF (recd.SIDE != '8') THEN
            SELECT COUNT(ORDERID) INTO v_count FROM ORDERS
            WHERE CONFIRMID=recd.OrigClOrdID
            AND (SUBSTATUS = 'SS' OR SUBSTATUS = 'ES' OR SUBSTATUS = 'SE' OR SUBSTATUS = 'SD' OR SUBSTATUS = 'DD'  OR SUBSTATUS = 'FF');
            IF (v_count=0) THEN
              p_err_code:='00';
              v_orderid := NULL;
            ELSIF (v_count=1) THEN
              SELECT  ORDERID, ACCTNO, SUBTYPECD, QUOTE_QTTY, REMAIN_QTTY, SUBSIDE, SIDE, STATUS,
                      SUBSTATUS, SYMBOL, REFORDERID, QUOTE_PRICE, TYPECD, USERID, QUOTEID, SESSIONEX
              INTO    v_orderid, v_acctno, v_subtypecd, v_quote_qtty, v_remain_qtty, v_subside, v_side, v_status,
                      v_sub_status, v_symbol, v_reforderid, v_quote_price, v_typecd, v_userid, v_quoteid, v_sessionnex
              FROM ORDERS
              WHERE CONFIRMID=recd.OrigClOrdID
              AND (SUBSTATUS = 'SS' OR SUBSTATUS = 'ES' OR SUBSTATUS = 'SE' OR SUBSTATUS = 'SD' OR SUBSTATUS = 'DD'  OR SUBSTATUS = 'FF');
              -- Retry Trading
              CSPKS_FO_ORDER_RESPONE.sp_proces_order_trading(p_err_code,v_orderid,v_acctno,recd.LastQty,recd.LastPx,recd.OrigClOrdID,recd.TransactTime,recd.ExecID,p_err_msg);
            ELSE
              p_err_code:='-90035';
              v_orderid := NULL;
            END IF;
            -- Write log for retrying
            IF (p_err_code='0') THEN
              INSERT INTO TRADING_EXCEPTION_LOG(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time, Err_Code, Status)
              VALUES (recd.MsgID, recd.MsgSeqNum, recd.OrdStatus, v_orderid, recd.OrigClOrdID, recd.SecondaryClOrdID, recd.OrderID, recd.TransactTime, recd.LastQty, recd.LastPx, recd.ExecID, recd.Side, recd.Symbol, recd.Contra_ClOrdID, SYSDATE, p_err_code, 'P');
              -- Insert successful transaction into TBL_MATCHED_TRANS
              INSERT INTO TBL_MATCHED_TRANS(MsgID, ClOrdID, OrigClOrdID, ExecID, LastQty, LastPx)
              VALUES (recd.MsgID, v_orderid, recd.OrigClOrdID, recd.ExecID, recd.LastQty, recd.LastPx);
            ELSE
              INSERT INTO TRADING_EXCEPTION_LOG(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time, Err_Code, Status)
              VALUES (recd.MsgID, recd.MsgSeqNum, recd.OrdStatus, v_orderid, recd.OrigClOrdID, recd.SecondaryClOrdID, recd.OrderID, recd.TransactTime, recd.LastQty, recd.LastPx, recd.ExecID, recd.Side, recd.Symbol, recd.Contra_ClOrdID, SYSDATE, p_err_code, 'F');
            END IF;
            -- Remove data from TRADING_EXCEPTION
            DELETE FROM TRADING_EXCEPTION WHERE MSGID=recd.MsgID;
          ELSE
            -- Do nothing for cross orders (Side='8')
            INSERT INTO TRADING_EXCEPTION_LOG(MsgID, MsgSeqNum, OrdStatus, ClOrdID, OrigClOrdID, SecondaryClOrdID, OrderID, TransactTime, LastQty, LastPx, ExecID, Side, Symbol, Contra_ClOrdID, Create_Time, Err_Code, Status)
            VALUES (recd.MsgID, recd.MsgSeqNum, recd.OrdStatus, recd.ClOrdID, recd.OrigClOrdID, recd.SecondaryClOrdID, recd.OrderID, recd.TransactTime, recd.LastQty, recd.LastPx, recd.ExecID, recd.Side, recd.Symbol, recd.Contra_ClOrdID, SYSDATE, NULL, 'C');
            -- Remove data from TRADING_EXCEPTION
            DELETE FROM TRADING_EXCEPTION WHERE MSGID=recd.MsgID;
          END IF;
        END LOOP;
        -- Commit batch
        p_err_code:='0';
    EXCEPTION
        WHEN OTHERS THEN
          p_err_msg:='sp_proces_recover_trading '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_recover_trading;

    /*
     * Author: Trung.Nguyen
     * Parameters:
     *    p_err_code
     *      c_matched_list
     * Description:
     */
    PROCEDURE sp_proces_recover_sync_bo(p_err_code IN OUT VARCHAR, c_matched_list OUT SYS_REFCURSOR, p_err_msg OUT VARCHAR2)
    AS
    BEGIN
        p_err_code := '0';
        p_err_msg:='sp_proces_recover_sync_bo';
        OPEN c_matched_list FOR
            SELECT MSGID, CLORDID, EXECID, LASTQTY, LASTPX FROM TBL_MATCHED_TRANS WHERE ROWNUM <= 100;
        EXCEPTION
        WHEN OTHERS THEN
          p_err_msg:='sp_proces_recover_sync_bo '||p_err_msg||' sqlerrm = '||SQLERRM;
    END sp_proces_recover_sync_bo;

   /*
    * Author: Nam.Vu
    * Description: Store GW XML log
    * Date: 12/12/2015
    */
    PROCEDURE sp_proces_msg_log(p_err_code IN OUT VARCHAR2,
          p_exchange_code IN OUT VARCHAR2,
          p_xml_content IN OUT VARCHAR2,
          p_err_msg OUT VARCHAR2)
          AS
      v_currtime                    TIMESTAMP;
    BEGIN
      p_err_code := 0;
      p_err_msg:='sp_proces_msg_log';
      BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
      END;

      INSERT INTO GW_MSG_LOGS (AUTOID, GW_DATE, EXCHANGE, XMLCONTENT)
      VALUES(SEQ_GW_MSG_LOGS.nextval, v_currtime, p_exchange_code, p_xml_content);

      EXCEPTION
        WHEN OTHERS THEN
        p_err_code := '-90025';
        p_err_msg:='sp_proces_msg_log '||p_err_msg||' sqlerrm = '||SQLERRM;
    END;

    /*
    * Author: dung.bui
    * Description: Store HFT XML log
    * Date: 12/12/2015
    */
    PROCEDURE sp_proces_sendGW_msg_log(p_err_code IN OUT VARCHAR,
          p_orderid IN VARCHAR,
          p_exchange_code IN OUT VARCHAR,
          p_xml_content IN OUT VARCHAR,
          p_err_msg OUT VARCHAR2)
          AS
      v_currtime                    TIMESTAMP;
    BEGIN
      p_err_code := 0;
      p_err_msg:='sp_proces_sendGW_msg_log p_OrderID=>'||p_OrderID;
      BEGIN
        EXECUTE IMMEDIATE
        'SELECT tt_sysdate FROM DUAL' INTO v_currtime;
      END;

      INSERT INTO HFT_MSG_LOGS (ORDERID, EXCHANGE, XMLCONTENT, HFT_DATE)
      VALUES(p_orderid, p_exchange_code, p_xml_content, v_currtime);

      EXCEPTION
        WHEN OTHERS THEN
        --p_err_code := '-90025';
        p_err_msg:='sp_proces_sendGW_msg_log '||p_err_msg||' sqlerrm = '||SQLERRM;
    END;

END CSPKS_FO_GW_HNX;
/


-- End of DDL Script for Package Body FOTEST.CSPKS_FO_GW_HNX

