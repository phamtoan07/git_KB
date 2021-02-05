select * from cfmast where custodycd = '091C000207';
select * from afmast where custid = '0001000405';
-----------
select * from cmdmenu where cmdid = '020011';--SA.BASKET
select * from grmaster where objname = 'SA.BASKET';
select * from basket;--Thoong tin chung cua rổ.
select * from grmaster where objname like '%AFTYPE';
select * from search where searchcode = 'AFTYPESERISK';
-----------
select * from SECBASKET where basketid like '%PT%'; --SA.SECBASKET -> Thoong tin chứng khoán trong rổ
/*
MRRATIORATE -> Tỉ lệ định giá tài sản
MRRATIOLOAN -> Tỉ lệ cho vay
MRPRICERATE -> Giá tính tài sản
MRPRICELOAN -> Giá cho vay
*/
-----------
select * from LNSEBASKET where basketid = 'PT MG'; 
--> Loại hình tính dụng CL -> Gán loại hình LNTYPE vào rổ
select * from fldmaster where objname like '%LNSEBASKET%';
-- ACTYPE -> Mã loại hình
select * from LNTYPE where ACTYPE = '0110';
-----------
-----------Quản lý loại hình tín dụng
select * from cmdmenu where objname like '%LNTYPE%'; --> Loại hình tín dụng cmdid = 032027
--> Gán lọia hình tín dụng vào loại hình tiểu khoản
select * from LNTYPE;
select * from aftype;
-----------
select * from DFBASKET; --> Chứng khoán cầm cố
select * from AFDFBASKET; --> Loại hình cầm cố
-----------
-----------Quản lý loại hình Margin
select * from afmast where acctno = '0001000601'; --ACTYPE = '0087' -> Loại tiểu khoản
select * from aftype where actype = '0087'; --MRTYPE = '0004'
--> Gán loại hình Margin vào loại hình tiểu khoản
select * from mrtype where actype = '0004'; 
-----------Quản lý loại hình tiểu khoản:
select * from grmaster where objname like '%AFTYPE%';
--Room CL trong ngày -> AFSERISK
select * from fldmaster where objname like '%AFTYPE%'
-----------020012: Quy định CK Credit line mức hệ thống
select * from SECURITIES_RISK where codeid in ('002059','000430'); --020012: Quy định CK Credit line mức hệ thống
select * from SECURITIES_RATE where symbol in ('ABC','ACB','AGM'); -- Quy định tỉ lệ theo bước giá
       --> search tren BDS
-----------insert afserisk
 select * from afserisk where actype = '0087';
 SELECT distinct SB.CODEID,AFT.ACTYPE,
 LEAST(SEC.MRRATIORATE,RATE.MRRATIORATE) MRRATIORATE,
 LEAST(SEC.MRRATIOLOAN,RATE.MRRATIOLOAN) MRRATIOLOAN,
 LEAST(SEC.MRPRICERATE,RSK.MRPRICERATE) MRPRICERATE,
 LEAST(SEC.MRPRICELOAN,RSK.MRPRICELOAN) MRPRICELOAN,ISMARGINALLOW
 FROM LNSEBASKET LNB, SECBASKET SEC, SECURITIES_INFO SB,
      SECURITIES_RISK RSK, SECURITIES_RATE RATE, AFTYPE AFT, LNTYPE LNT
 WHERE LNB.AUTOID= '9601'
       AND LNB.BASKETID=SEC.BASKETID 
       and LNB.actype = lnt.actype 
       and aft.lntype = lnt.actype
       AND TRIM(SEC.SYMBOL)=TRIM(SB.SYMBOL)
       AND SB.CODEID=RSK.CODEID 
       AND RSK.CODEID=RATE.CODEID
       AND RATE.FROMPRICE<=SB.FLOORPRICE
       AND RATE.TOPRICE>SB.FLOORPRICE 
------------
/*=======================*/

1. Sức mua = Giá trị tổng tài sản (Tiền mặt + Giá trị CK đang có) - Nợ Margin (Nợ gốc + lãi)  / Tỉ lệ vay margin
VD: Nhà đầu tư có 10.000.000đ chứng khoán ABC sử dụng 7.000.000 tiền mặt và vay ký quỹ 3.000.000đ
Bây giờ nhà đầu tư muốn mua cổ phiếu XYZ (có mức ký quỹ yêu cầu thông thường là 50%), sức mua là bao nhiêu?
→ Hiện giờ nhà đầu tư đã sử dụng 3.000.000đ từ khoản vay ký quỹ. 
  Còn lại 4.000.000đ chính là sức mua bằng tiền đối với nhà đầu tư.
  Sức mua = 4.000.000đ / 50% = 8.000.000đ (chứng khoán XYZ)
→ Tỉ lệ vay margin: MRRATIOLOAN
2. Tỷ lệ ký quỹ margin là gì?
   - Tỷ lệ ký quỹ hiện tại = Tài sản ròng / Giá trị danh mục
3. Tài sản ròng, giá trị danh mục 
   - Tài sản ròng: giá trị của lượng cổ phiếu bạn đã mua - nợ vay margin (gồm cả gốc và lãi), 
     tính theo giá thị trường hiện tại.
   - Giá trị danh mục: giá trị của lượng cổ phiếu bạn đã mua từ tiền thực có và tiền nợ vay margin 
     (bao gồm cả gốc và lãi vay).
4. https://govalue.vn/margin/
/*=======================*/

091C000207

select * from cfmast where custodycd = '091C000207';
select * from afmast where custid = '0001000405';

select * from AFIDTYPE;
/*=======================*/
1. pr_getppse -> Proc tính sức mua
2. insert Afserisk, AFMRSERISK -> Batch line 9072 (Chuyển ngày làm việc), giao dịch 5503
   select * from tltx where tltxcd = '5503'; -- Đánh dấu lại rổ

select * from fldmaster where objname = 'CF.CFMAST';
