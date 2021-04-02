PROCEDURE FILLTER_SEC_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
v_IRATIO varchar2(50);
v_currdate date;
BEGIN
    v_currdate:= getcurrdate();
    -- Kiem tra neu trung khoa secbaskettemp; Tra ve loi
    BEGIN
    SELECT basketid,symbol, count(1) INTO v_basketid,v_symbol,v_count FROM secbaskettemp
    HAVING count(1) <> 1
    GROUP BY  basketid,symbol;
        -- co 1 truong hop bi trung khoa
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    EXCEPTION
    WHEN no_data_found THEN
        NULL; -- OK khong bi trung khoa
    WHEN OTHERS THEN
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END;

    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE NOT EXISTS (SELECT basketid FROM basket WHERE basket.basketid = secbaskettemp.basketid)
          AND ISEXT = 'N';
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
    
    -- Kiem tra bracketID da duoc khai bao hay chua?
    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE NOT EXISTS (SELECT basketid FROM basketext WHERE basketext.basketid = secbaskettemp.basketid)
          AND ISEXT = 'Y';
    IF v_count > 0 THEN
        p_err_code := -100406;
        p_err_message:= 'Chua khai bao backetid!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
    
    --Kiem tra loai ro import
     SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE ISEXT NOT IN ('N','Y');
    IF v_count > 0 THEN
        p_err_code := -100448;
        p_err_message:= 'Loại rổ chỉ thuộc rổ thường (N) hoặc rổ đặc biệt (Y)!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
    
    --Kiem tra ti le neu ngay hieu luc = ngay hien tai
    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE mrratiorate * mrpricerate < mrratioloan * mrpriceloan;
    IF v_count > 0 THEN
        p_err_code := -100435;
        p_err_message:= 'Ti le * Gia vay tinh tai san phai lon hon hoac bang Ti le * Gia vay tinh suc mua!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
    
    --Kiem tra ti le neu ngay hieu luc > ngay hien tai voi ro thuong
    SELECT COUNT(1) INTO v_count FROM (
       SELECT s.basketid, s.symbol,
              t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
              t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
              s.mrratiorate mrratiorate_old,s.mrpricerate mrpricerate_old,
              case when t.mrratiorate >= s.mrratiorate then t.mrratiorate else s.mrratiorate end newmrratiorate,
              case when t.mrpricerate >= s.mrratiorate then t.mrpricerate else s.mrpricerate end newmrpricerate 
       FROM
          secbasket s, secbaskettemp t
       WHERE s.basketid = t.basketid AND s.symbol = t.symbol
             and t.isext = 'N' and t.effdatemr > getcurrdate
     ) G
    WHERE g.newmrratiorate * g.newmrpricerate < g.mrratioloan * g.mrpriceloan;
    IF v_count > 0 THEN
        p_err_code := -100419;
        p_err_message:= 'Tỷ lệ tài sản mới, giá tài sản mới không được nhỏ hơn Tỷ lệ sức mua, giá sức mua!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
    
    --Kiem tra ti le neu ngay hieu luc > ngay hien tai voi ro dac biet
    SELECT COUNT(1) INTO v_count FROM (
       SELECT s.basketid, s.symbol,
              t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
              t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
              s.mrratiorate mrratiorate_old,s.mrpricerate mrpricerate_old,
              case when t.mrratiorate >= s.mrratiorate then t.mrratiorate else s.mrratiorate end newmrratiorate,
              case when t.mrpricerate >= s.mrratiorate then t.mrpricerate else s.mrpricerate end newmrpricerate 
       FROM
          secbasketext s, secbaskettemp t
       WHERE s.basketid = t.basketid AND s.symbol = t.symbol
             and t.isext = 'Y' and t.effdatemr > getcurrdate
     ) G
    WHERE g.newmrratiorate * g.newmrpricerate < g.mrratioloan * g.mrpriceloan;
    IF v_count > 0 THEN
        p_err_code := -100419;
        p_err_message:= 'Tỷ lệ tài sản mới, giá tài sản mới không được nhỏ hơn Tỷ lệ sức mua, giá sức mua!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
	
	--Kiem tra ti le tai san moi > ti le cho vay voi ro dac biet
    SELECT count(1)
        INTO v_count
    FROM secbaskettemp
    WHERE mrratiorate < mrratioloan and isext = 'Y';
    IF v_count > 0 THEN
        p_err_code := -100449;
        p_err_message:= ' Rổ đặc biệt: Tỉ lệ tài sản mới phải lớn hơn tỉ lệ cho vay!!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;
    
    --Cap nhat thong tin ve nguoi import
    UPDATE secbaskettemp SET TellerID=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END FILLTER_SEC_BASKET;