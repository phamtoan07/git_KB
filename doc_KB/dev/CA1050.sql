  SELECT mr.autoid, mr.createdate, mr.createtime, mr.expdate, mr.camastid, ca.catype catypecd,
           ca.reportdate,a1.cdcontent catype, ca.codeid execcodeid, sb1.symbol excecsymbol,
           mr.mrseccodeid, mr.mrsecsymbol, nvl(r.ranksec,mr.secrank) secrank,
           case when ca.catype = '014' then ca.tocodeid else ca.codeid end refcodeid, sb2.symbol refsymbol,
           mr.createdate + 90 date_end, to_date('29-10-2019','dd-mm-rrrr') - mr.createdate age,
           mr.status statuscd, a2.cdcontent status, ca.description
    FROM SECMRCAMAP mr, CAMAST ca, ALLCODE a1, ALLCODE a2, sbsecurities sb1, secrank r, sbsecurities sb2
    WHERE mr.camastid = ca.camastid
          and a1.cdname = 'CATYPE' and a1.cdtype = 'CA' and a1.cdval = ca.catype
          and a2.cdname = 'CFSTATUS' and a2.cdtype = 'CF' and a2.cdval = mr.status
          and sb1.codeid = ca.codeid
          and sb2.codeid = (case when ca.catype = '014' then ca.tocodeid else ca.codeid end)
          and r.codeid(+) = (case when ca.catype = '014' then ca.tocodeid else ca.codeid end)
          --and sb2.codeid = mr.mrseccodeid
          and (mr.createdate + 90 <= '29-OCT-2019' or mr.expdate <= '29-OCT-2019')
