select * from sbbatchctl where status = 'Y' order by bchsqn;
--111501 -> insert lnmast
select * from cmdmenu where objname like '%LNMAST%';
--CSPKS_LNPROC.FN_OPENLOANACCOUNT
--CREATELNMAST -> Mở TK LNMAST vs CIMAST bị âm tiền
--tltxcd IN ('5541','5568','5569')
--bchmdl = 'CREATELNMAST' -> pr_LNOpenLoanAccount: Tự động mở tài khoản lnmast
--bchmdl = 'CLNSCHD' -> pr_LNCleanSchedule: Đóng và lưu trữ lịch vay
--bchmdl = 'LNDRAWNDOWN_UB' -> pr_LNDrawndown_UyBan -> Tự động giải ngân ủy ban
--bchmdl = 'LNDRAWNDOWN_MARGIN' -> pr_LNAutoDrawndown_MARGIN-> tự động giải ngân margin -> gọi 5566 update lnmast
---------
--pr_LNMovePrinToOverdue -> 5564 -> chuyển gốc sang quá hạn
--pr_LNCalMaturityPrincipal -> Tính toán gốc đến hạn: Update DUEAMT trong CIMAST
--LNINTNMLOVD -> pr_LNMoveIntToOverdue ->5565 ->	Chuyển lãi sang quá hạn
--LNINTNMLACR -> pr_LNNormalInterestAccrue -> Tính lãi vay cộng dồn: UPDATE LNMAST
--LNINTDUE	-> pr_LNAccrueInterest -> Tính lãi vay trong hạn -> 5562
--CICRINTPRN -> pr_CIInterestToPrincipal ->	Lãi nhập gốc: 1162: UPDATE CIMAST tăng balance, cramt,CRINTACR

-------------

--bchmdl = 'CREATELNMAST' -> pr_LNOpenLoanAccount: Tự động mở tài khoản lnmast
/*
Insert LNMAST vs những tài khoản có cimast.trfbuyamt - cimast.BALANCE > 0 (số tiền vay - số dư tài khoản)
       + AFTPYE.T0LNTYPE = LN.ACTYPE union AFTYPE.LNTYPE = LN.ACTYPE
         union
         AFTPYE.actype = AFIDTYPE.aftype and AFIDTYPE.objname = 'LN.LNTYPE' AND LN.ACTYPE = AFIDTYPE.ACTYPE
         
       + Khong co tk lnmast status ('P','R','C'), allcode = 'STATUS', cdtype = 'LN'
       + https://docs.fss.com.vn/pages/viewpage.action?pageId=2031783 LNMAST
       + Cac truong so tien = 0
*/
--bchmdl = 'LNDRAWNDOWN_UB' -> pr_LNDrawndown_UyBan -> Tự động giải ngân ủy ban -> goi 5566
/*
 Neu giai ngna qua tai khoan tien:
 UPDATE CIMAST
         SET
           BALANCE = BALANCE - (ROUND(p_txmsg.txfields('10').value,0)) - (ROUND(p_txmsg.txfields('11').value,0))
 Neu khong:
 UPDATE LNMAST
           ORLSAMT = ORLSAMT + (ROUND(p_txmsg.txfields('11').value,0)), --Tổng số tiền đã giải ngân vay bảo lãnh
           PRINNML = PRINNML + (ROUND(p_txmsg.txfields('10').value,0)), --Gốc trong hạn
           RLSAMT = RLSAMT + (ROUND(p_txmsg.txfields('10').value,0)),   --Tổng số tiền đã giải ngân
           OPRINNML = OPRINNML + (ROUND(p_txmsg.txfields('11').value,0))--Gốc vay bảo lãnh trong hạn
 UPDATE CIMAST
           T0ODAMT = 0,
           ODAMT = ODAMT + (ROUND(p_txmsg.txfields('20').value*(p_txmsg.txfields('10').value+p_txmsg.txfields('11').value),0)),
           BALANCE = BALANCE + (ROUND(p_txmsg.txfields('10').value,0)) + (ROUND(p_txmsg.txfields('11').value,0)),
           OVAMT = OVAMT + (ROUND(p_txmsg.txfields('20').value*p_txmsg.txfields('11').value,0)), LAST_CHANGE = SYSTIMESTAMP

*/


select * from sbbatchctl where bchmdl = 'CREATELNMAST';
