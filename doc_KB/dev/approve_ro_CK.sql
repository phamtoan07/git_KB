PROCEDURE CAL_SEC_BASKET (p_tlid in varchar2,p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_count NUMBER;
v_basketid varchar2(100);
v_symbol varchar2(100);
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
        RETURN;
    EXCEPTION
    WHEN no_data_found THEN
        NULL; -- OK khong bi trung khoa
    WHEN OTHERS THEN
        p_err_code := -100407;
        p_err_message:= 'Dupplicate key of secbaskettemp!';
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
    WHERE ISEXT NOT IN ('N','Y') OR ISEXT IS NULL;
    IF v_count > 0 THEN
        p_err_code := -100448;
        p_err_message:= 'Loáº¡i rá»• chá»‰ thuá»™c rá»• thÆ°á»ng (N) hoáº·c rá»• Ä‘áº·c biá»‡t (Y)!';
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
        p_err_message:= 'Tá»· lá»‡ tÃ i sáº£n má»›i, giÃ¡ tÃ i sáº£n má»›i khÃ´ng Ä‘Æ°á»£c nhá» hÆ¡n Tá»· lá»‡ sá»©c mua, giÃ¡ sá»©c mua!';
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
        p_err_message:= 'Tá»· lá»‡ tÃ i sáº£n má»›i, giÃ¡ tÃ i sáº£n má»›i khÃ´ng Ä‘Æ°á»£c nhá» hÆ¡n Tá»· lá»‡ sá»©c mua, giÃ¡ sá»©c mua!';
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
        p_err_message:= ' Rá»• Ä‘áº·c biá»‡t: Tá»‰ lá»‡ tÃ i sáº£n má»›i pháº£i lá»›n hÆ¡n tá»‰ lá»‡ cho vay!!';
        DELETE FROM SECBASKETTEMP;
        RETURN;
    END IF;

    --sua ma CK trong ro thuong
    FOR rec IN
    (
      SELECT s.autoid, s.basketid, s.symbol,
            t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
            t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
            t.effdatemr effdate,
            s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
            s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old,
            nvl(s.newmrratiorate,0) newmrratiorate_old, nvl(s.newmrpricerate,0) newmrpricerate_old,
            s.effdate effdate_old, t.tellerid,
            case when t.mrratiorate >= s.mrratiorate then t.mrratiorate else s.mrratiorate end newmrratiorate_temp,
            case when t.mrpricerate >= s.mrratiorate then t.mrpricerate else s.mrpricerate end newmrpricerate_temp,
            t.description
      FROM
        secbasket s, secbaskettemp t
      WHERE s.basketid = t.basketid AND s.symbol = t.symbol and t.isext = 'N' and t.effdatemr >= v_currdate and t.status <> 'N'
    )
    LOOP
      IF rec.effdate > v_currdate THEN --ngay hieu luc moi lon hon ngay hien tai
      INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                     MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                     NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                     AUTOID,REFID)
      VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec.basketid,rec.symbol,rec.newmrratiorate_temp,rec.mrratioloan,rec.newmrpricerate_temp,
           rec.mrpriceloan,rec.mrratiorate_old,rec.mrratioloan_old,rec.mrpricerate_old,rec.mrpriceloan_old,rec.tellerid,p_tlid,'I002-EDIT',
           rec.mrratiorate,rec.mrpricerate,rec.effdate,rec.newmrratiorate_old,rec.newmrpricerate_old,rec.effdate_old,seq_SECBASKET_LOG.nextval,rec.autoid);
      --Insert bang tam de cap nhat new rate
      insert into secbasketexteffdt(autoid,basketid,symbol,newmrratiorate,newmrpricerate,effdate,createdt,isprocess,deltd,refid,isext)
      select seq_secbasketexteffdt.nextval,rec.basketid,rec.symbol,rec.mrratiorate,rec.mrpricerate,rec.effdate,sysdate,'N','N', rec.autoid,'N' from dual;
      --insert secbaskethist
      insert into secbaskethist(basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
                    backupdt,importdt,autoid,expdate,newmrratiorate,newmrpricerate,effdate)
      select basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
           to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),importdt,autoid,expdate,newmrratiorate,newmrpricerate,effdate
      from secbasket where autoid = rec.autoid and basketid = rec.basketid and symbol = rec.symbol;

      --update secbasket
      UPDATE secbasket SET mrratiorate = rec.newmrratiorate_temp,
                 mrpricerate = rec.newmrpricerate_temp,
                 mrratioloan = rec.mrratioloan,
                 mrpriceloan = rec.mrpriceloan,
                 newmrratiorate = rec.mrratiorate,
                 newmrpricerate = rec.mrpricerate,
                 effdate = rec.effdate,
                 description = rec.description
      WHERE autoid  = rec.autoid and symbol = rec.symbol and basketid = rec.basketid;
    ELSE
      INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                     MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                     NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                     AUTOID,REFID)
      VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec.basketid,rec.symbol,rec.mrratiorate,rec.mrratioloan,rec.mrpricerate,
           rec.mrpriceloan,rec.mrratiorate_old,rec.mrratioloan_old,rec.mrpricerate_old,rec.mrpriceloan_old,rec.tellerid,p_tlid,'I002-EDIT',
           0,0,rec.effdate,rec.newmrratiorate_old,rec.newmrpricerate_old,rec.effdate_old,seq_SECBASKET_LOG.nextval,rec.autoid);
        --insert secbaskethist
      insert into secbaskethist(basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
                    backupdt,importdt,autoid,expdate,newmrratiorate,newmrpricerate,effdate)
      select basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
           to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),importdt,autoid,expdate,newmrratiorate,newmrpricerate,effdate
      from secbasket where autoid = rec.autoid and rec.symbol = symbol and rec.basketid = basketid;
      --update secbasket
      UPDATE secbasket SET mrratiorate = rec.mrratiorate,
                 mrpricerate = rec.mrpricerate,
                 mrratioloan = rec.mrratioloan,
                 mrpriceloan = rec.mrpriceloan,
                 newmrratiorate = 0,
                 newmrpricerate = 0,
                 effdate = rec.effdate,
                 description = rec.description
      WHERE autoid  = rec.autoid and symbol = rec.symbol and basketid = rec.basketid;
    END IF;
    END LOOP;

  --sua ma CK trong ro thuong dac biet
    FOR rec IN
    (
      SELECT s.autoid, s.basketid, s.symbol,
            t.mrratiorate mrratiorate, t.mrratioloan mrratioloan,
            t.mrpricerate mrpricerate, t.mrpriceloan mrpriceloan,
            t.effdatemr effdate,
            s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
            s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old,
            nvl(s.newmrratiorate,0) newmrratiorate_old, nvl(s.newmrpricerate,0) newmrpricerate_old,
            s.effdate effdate_old, t.tellerid,
            case when t.mrratiorate >= s.mrratiorate then t.mrratiorate else s.mrratiorate end newmrratiorate_temp,
            case when t.mrpricerate >= s.mrratiorate then t.mrpricerate else s.mrpricerate end newmrpricerate_temp,
            t.description
      FROM
        secbasketext s, secbaskettemp t
      WHERE s.basketid = t.basketid AND s.symbol = t.symbol and t.isext = 'Y' and t.effdatemr >= v_currdate and t.status <> 'N'
    )
    LOOP
      IF rec.effdate > v_currdate THEN --ngay hieu luc moi lon hon ngay hien tai
      INSERT INTO secbasketext_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                     MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                     NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                     AUTOID,REFID)
      VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec.basketid,rec.symbol,rec.newmrratiorate_temp,rec.mrratioloan,rec.newmrpricerate_temp,
           rec.mrpriceloan,rec.mrratiorate_old,rec.mrratioloan_old,rec.mrpricerate_old,rec.mrpriceloan_old,rec.tellerid,p_tlid,'I002-EDIT',
           rec.mrratiorate,rec.mrpricerate,rec.effdate,rec.newmrratiorate_old,rec.newmrpricerate_old,rec.effdate_old,seq_SECBASKETEXT_LOG.nextval,rec.autoid);
      --Insert bang tam de cap nhat new rate
      insert into secbasketexteffdt(autoid,basketid,symbol,newmrratiorate,newmrpricerate,effdate,createdt,isprocess,deltd,refid,isext)
      select seq_secbasketexteffdt.nextval,rec.basketid,rec.symbol,rec.mrratiorate,rec.mrpricerate,rec.effdate,sysdate,'N','N', rec.autoid,'Y' from dual;
      --insert secbasketexthist
      insert into secbasketexthist(basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
                    backupdt,importdt,autoid,newmrratiorate,newmrpricerate,effdate)
      select basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
           to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),importdt,autoid,newmrratiorate,newmrpricerate,effdate
      from secbasketext where autoid = rec.autoid and symbol = rec.symbol and basketid = rec.basketid;

      --update secbasketext
      UPDATE secbasketext SET mrratiorate = rec.newmrratiorate_temp,
                 mrpricerate = rec.newmrpricerate_temp,
                 mrratioloan = rec.mrratioloan,
                 mrpriceloan = rec.mrpriceloan,
                 newmrratiorate = rec.mrratiorate,
                 newmrpricerate = rec.mrpricerate,
                 effdate = rec.effdate,
                 description = rec.description
      WHERE autoid  = rec.autoid and symbol = rec.symbol and basketid = rec.basketid;
    ELSE
      INSERT INTO secbasketext_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                     MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                     NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                     AUTOID,REFID)
      VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec.basketid,rec.symbol,rec.mrratiorate,rec.mrratioloan,rec.mrpricerate,
           rec.mrpriceloan,rec.mrratiorate_old,rec.mrratioloan_old,rec.mrpricerate_old,rec.mrpriceloan_old,rec.tellerid,p_tlid,'I002-EDIT',
           0,0,rec.effdate,rec.newmrratiorate_old,rec.newmrpricerate_old,rec.effdate_old,seq_SECBASKETEXT_LOG.nextval,rec.autoid);
        --insert secbasketexthist
      insert into secbasketexthist(basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
                    backupdt,importdt,autoid,newmrratiorate,newmrpricerate,effdate)
      select basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
           to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),importdt,autoid,newmrratiorate,newmrpricerate,effdate
      from secbasketext where autoid = rec.autoid and symbol = rec.symbol and basketid = rec.basketid;
      --update secbasket
      UPDATE secbasketext SET mrratiorate = rec.mrratiorate,
                 mrpricerate = rec.mrpricerate,
                 mrratioloan = rec.mrratioloan,
                 mrpriceloan = rec.mrpriceloan,
                 newmrratiorate = 0,
                 newmrpricerate = 0,
                 effdate = rec.effdate,
                 description = rec.description
      WHERE autoid  = rec.autoid and symbol = rec.symbol and basketid = rec.basketid;
    END IF;
    END LOOP;

    --xoa ma CK trong ro thuong
    FOR rec1 IN
    (
        SELECT s.autoid, s.basketid, s.symbol, 0 mrratiorate, 0 mrratioloan, 0 mrpricerate, 0 mrpriceloan,
               0 newmrratiorate, 0 newmrpricerate, null effdate,
               s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
               s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old,
               s.newmrratiorate newmrratiorate_old, s.newmrpricerate newmrpricerate_old, s.effdate effdate_old,
               (SELECT max(t.tellerid) FROM secbaskettemp t) tellerid
        FROM secbasket s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbaskettemp t WHERE t.basketid = s.basketid and t.isext = 'N'and t.status <> 'N')
        AND s.basketid IN (SELECT t.basketid FROM secbaskettemp t where t.isext = 'N' and t.status <> 'N')
    )
    LOOP
      INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                   MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                   NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                   AUTOID,REFID)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec1.basketid,rec1.symbol,rec1.mrratiorate,rec1.mrratioloan,rec1.mrpricerate,rec1.mrpriceloan,
               rec1.mrratiorate_old,rec1.mrratioloan_old,rec1.mrpricerate_old,rec1.mrpriceloan_old,rec1.tellerid,p_tlid,'I002-DELETE',
         rec1.newmrratiorate,rec1.newmrpricerate,rec1.effdate,rec1.newmrratiorate_old,rec1.newmrpricerate_old,rec1.effdate_old,
         seq_SECBASKET_LOG.nextval,rec1.autoid);
      --insert secbaskethist
    insert into secbaskethist(basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
                    backupdt,importdt,autoid,expdate,newmrratiorate,newmrpricerate,effdate)
    select basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
           to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),importdt,autoid,expdate,newmrratiorate,newmrpricerate,effdate
    from secbasket where autoid = rec1.autoid and symbol = rec1.symbol and basketid = rec1.basketid;
    --delete secbasket
    DELETE from secbasket where autoid = rec1.autoid and BASKETID = rec1.BASKETID and SYMBOL = rec1.symbol;
    END LOOP;

  --xoa ma CK trong ro dac biet
    FOR rec1 IN
    (
        SELECT s.autoid, s.basketid, s.symbol, 0 mrratiorate, 0 mrratioloan, 0 mrpricerate, 0 mrpriceloan,
               0 newmrratiorate, 0 newmrpricerate, null effdate,
               s.mrratiorate mrratiorate_old, s.mrratioloan mrratioloan_old,
               s.mrpricerate mrpricerate_old, s.mrpriceloan mrpriceloan_old,
               s.newmrratiorate newmrratiorate_old, s.newmrpricerate newmrpricerate_old, s.effdate effdate_old,
      (SELECT max(t.tellerid) FROM secbaskettemp t) tellerid
        FROM secbasketext s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbaskettemp t WHERE t.basketid = s.basketid and t.isext = 'Y' and t.status <> 'N')
        AND s.basketid IN (SELECT t.basketid FROM secbaskettemp t where t.isext = 'Y' and t.status <> 'N')
    )
    LOOP
      INSERT INTO secbasketext_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                   MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                   NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                   AUTOID,REFID)
      VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec1.basketid,rec1.symbol,rec1.mrratiorate,rec1.mrratioloan,rec1.mrpricerate,rec1.mrpriceloan,
               rec1.mrratiorate_old,rec1.mrratioloan_old,rec1.mrpricerate_old,rec1.mrpriceloan_old,rec1.tellerid,p_tlid,'I002-DELETE',
         rec1.newmrratiorate,rec1.newmrpricerate,rec1.effdate,rec1.newmrratiorate_old,rec1.newmrpricerate_old,rec1.effdate_old,
         seq_SECBASKETEXT_LOG.nextval,rec1.autoid);
      --insert secbaskethist
    insert into secbasketexthist(basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
                    backupdt,importdt,autoid,newmrratiorate,newmrpricerate,effdate)
    select basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,
           to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),importdt,autoid,newmrratiorate,newmrpricerate,effdate
    from secbasketext where autoid = rec1.autoid and symbol = rec1.symbol and basketid = rec1.basketid;
    --delete secbasket
    DELETE from secbasketext where autoid = rec1.autoid and BASKETID = rec1.BASKETID and SYMBOL = rec1.symbol;
    END LOOP;

    --them ma CK trong ro thuong
    FOR rec2 IN
    (
        SELECT s.*,
            0 mrratiorate_old, 0 mrratioloan_old,
            0 mrpricerate_old, 0 mrpriceloan_old,
      0 newmrratiorate_old, 0 newmrpricerate_old, null effdate_old
        FROM secbaskettemp s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbasket t WHERE t.basketid = s.basketid) AND S.ISEXT = 'N' AND S.STATUS <> 'N'
    )
    LOOP
        INSERT INTO secbasket_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                   MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                   NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                   AUTOID,REFID)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec2.basketid,rec2.symbol,rec2.mrratiorate,rec2.mrratioloan,rec2.mrpricerate,rec2.mrpriceloan,
               rec2.mrratiorate_old,rec2.mrratioloan_old,rec2.mrpricerate_old,rec2.mrpriceloan_old,rec2.tellerid,p_tlid,'I002-ADD',
         0,0,rec2.effdatemr,rec2.newmrratiorate_old,rec2.newmrpricerate_old,rec2.effdate_old,seq_SECBASKET_LOG.nextval,null);

      INSERT INTO secbasket  (autoid,basketid, symbol, mrratiorate, mrratioloan,mrpricerate, mrpriceloan, description, importdt, expdate,
                newmrratiorate,newmrpricerate,effdate)
        VALUES(seq_secbasket.nextval,rec2.basketid,rec2.symbol,rec2.mrratiorate,rec2.mrratioloan,rec2.mrpricerate,rec2.mrpriceloan, rec2.description,
         to_char(sysdate,'DD/MM/YYYY:HH:MI:SS'),null,0,0,rec2.effdatemr);
    END LOOP;

  --them ma CK trong ro dac biet
    FOR rec2 IN
    (
        SELECT s.*,
            0 mrratiorate_old, 0 mrratioloan_old,
            0 mrpricerate_old, 0 mrpriceloan_old,
      0 newmrratiorate_old, 0 newmrpricerate_old, null effdate_old
        FROM secbaskettemp s
        WHERE s.symbol NOT IN (SELECT t.symbol FROM secbasketext t WHERE t.basketid = s.basketid) AND S.ISEXT = 'N' AND S.STATUS <> 'N'
    )
    LOOP
        INSERT INTO secbasketext_log (TXDATE,TXTIME,BASKETID,SYMBOL,MRRATIORATE,MRRATIOLOAN,MRPRICERATE,MRPRICELOAN,
                   MRRATIORATE_OLD,MRRATIOLOAN_OLD,MRPRICERATE_OLD,MRPRICELOAN_OLD,MAKERID,CHECKERID,ACTION,
                   NEWMRRATIORATE,NEWMRPRICERATE,EFFDATE,NEWMRRATIORATE_OLD,NEWMRPRICERATE_OLD,EFFDATE_OLD,
                   AUTOID,REFID)
        VALUES(getcurrdate,to_char(SYSDATE,'hh24:mi:ss'),rec2.basketid,rec2.symbol,rec2.mrratiorate,rec2.mrratioloan,rec2.mrpricerate,rec2.mrpriceloan,
               rec2.mrratiorate_old,rec2.mrratioloan_old,rec2.mrpricerate_old,rec2.mrpriceloan_old,rec2.tellerid,p_tlid,'I002-ADD',
         0,0,null,rec2.newmrratiorate_old,rec2.newmrpricerate_old,rec2.effdate_old,seq_SECBASKET_LOG.nextval,null);

      INSERT INTO secbasketext (autoid,basketid,symbol,mrratiorate,mrratioloan,mrpricerate,mrpriceloan,description,importdt,
                                newmrratiorate,newmrpricerate,effdate)
        VALUES(seq_secbasketext.nextval,rec2.basketid,rec2.symbol,rec2.mrratiorate,rec2.mrratioloan,rec2.mrpricerate,rec2.mrpriceloan,rec2.description,
         sysdate,0,0,rec2.effdatemr);
    END LOOP;

    update secbaskettemp set approved='Y', aprid=p_tlid;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';


exception
when others then
    rollback;
    p_err_code := -100800; --File du lieu dau vao khong hop le
    p_err_message:= 'System error. Invalid file format';
RETURN;
END CAL_SEC_BASKET;