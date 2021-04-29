procedure prc_PoolAlloc(p_type varchar2, p_prcode varchar2, p_aftype varchar2 default '', p_acctno varchar2 default '', p_err_code in out varchar2)
is
l_odamt        number;
l_excamt       number;
l_actype       varchar2(10);
l_count        number;
l_countsys     number;
l_countaf      number;
l_countacct    number;
l_prtype       number;
l_amt          number;
l_T0prin       number;
l_syprcode     varchar2(10);
l_brid   VARCHAR2(10);
l_IsMarginAccount varchar2(1);
begin
  plog.setbeginsection (pkgctx, 'prc_PoolAlloc');
  p_err_code := 0;
  --pool dac biet
  if length(p_acctno) > 0 then
      select odamt, odamt - nvl(t0.t0prin,0) amt, cf.brid, af.actype, nvl(t0.t0prin,0) t0prin
      into   l_odamt, l_excamt, l_brid, l_actype, l_T0prin
      from cimast ci, cfmast cf, afmast af,
           (select trfacctno,
                   sum(oprinnml + oprinovd + ointnmlacr + ointdue + ointovdacr + ointnmlovd) t0prin
            from lnmast ln, lntype lnt
                         where ln.actype = lnt.actype and ln.ftype = 'AF'
                         group by trfacctno) t0
      where ci.acctno = af.acctno
            and cf.custid = af.custid and af.acctno = t0.trfacctno(+)
            and ci.acctno = p_acctno;
      
      select count(1) into l_count
      from afmast af, aftype aft, mrtype mrt, lntype lnt
      where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_acctno;
      --tuan thu uy ban
      if l_count = 0 then
          l_IsMarginAccount:='N';
      else
          l_IsMarginAccount:='Y';
      end if;
      
      if p_type = 'ADD' then
          --thong tin pool truoc do cua tieu khoan
          select prtyp into l_prtype from prmaster where prcode = p_prcode;
          
          select count(1) into l_countaf from prmaster mst, prtypemap map, bridmap br
                          where mst.prcode = map.prcode and mst.prtyp = 'A' and mst.prcode <> p_prcode
                                and mst.prstatus = 'A' and mst.prcode = br.prcode
                                and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                and br.brid = decode(br.brid, 'ALL', br.brid, l_brid);
                                
          select count(1) into l_countacct from prmaster pm, pracctnomap ac
                          where pm.prcode = ac.prcode and ac.acctno = p_acctno
                                and pm.prstatus = 'A' and pm.prtyp in ('P','T') and pm.prcode <> p_prcode;
          if l_countacct = 0 and l_countaf = 0 then
            l_countsys:= 1;
          else
            l_countsys:= 0;
          end if;
          
          --cap nhat prmaster
          if l_odamt > 0 then
              insert into prmasterlog (prcode, prname, prtyp, custbank, prlimit, prinusedold, prinusednew, prstatus)
              select prcode, prname, prtyp, custbank, prlimit, prinused , prinused + decode(prtyp,'S',l_odamt,l_excamt), prstatus
              from prmaster
              where prcode = p_prcode;
              update prmaster set prinused = prinused + decode(prtyp,'S',l_odamt,l_excamt) where prcode = p_prcode;

              for rec in(
                          select mst.prcode --nha pool S neu dang o S va gan vao P,T
                          from prmaster mst
                          where mst.prtyp = 'S' and mst.prstatus = 'A' 
                                and l_countsys > 0 and l_prtype in ('P','T')
                          union all
                          select pm.prcode --nha pull UB neu tuan thu UB, dang o S va gan vao pool P moi
                          from prmaster pm
                          where pm.prstatus = 'A' and pm.prtyp = 'U' and l_countsys > 0
                                and l_IsMarginAccount = 'Y' and l_prtype = 'P'
                          union all       
                          select mst.prcode --nha pool A neu dang o A, gan vao P,T 
                          from prmaster mst, prtypemap map, bridmap br
                          where mst.prcode = map.prcode and mst.prtyp = 'A'
                                and mst.prstatus = 'A' and mst.prcode = br.prcode
                                and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                and br.brid = decode(br.brid, 'ALL', br.brid, l_brid)
                                and l_countaf > 0 and l_countacct = 0
              )loop
                   insert into prmasterlog (prcode, prname, prtyp, custbank, prlimit, prinusedold,prinusednew, prstatus)
                   select prcode, prname, prtyp, custbank, prlimit, prinused , prinused - decode(prtyp,'S',l_odamt,l_excamt), prstatus
                   from prmaster
                   where prcode = rec.prcode;

                   update prmaster set prinused = prinused - decode(prtyp,'S',l_odamt,l_excamt) where prcode = rec.prcode;
              end loop;
          end if;
          --cap nhat prinusedlog
          for rec in(   
               select nvl(sum(amt),0) amt from 
               ( select nvl(log.prinused,0) amt 
                 from prinusedlog log, prmaster mst, afmast af
                 where mst.prtyp = 'S' and mst.prstatus = 'A' and log.prcode = mst.prcode
                       and log.afacctno = p_acctno and log.afacctno = af.acctno and af.isfo = 'N'
                       and l_countsys > 0 and l_prtype in ('P','T')
                 union all
                 select nvl(log.prinused,0) amt 
                 from prinusedlog log, prmaster mst, afmast af
                 where log.prcode = mst.prcode
                       and mst.prtyp = 'U' and mst.prstatus = 'A' and l_countsys > 0
                       and l_IsMarginAccount = 'Y' and l_prtype = 'P'
                       and log.afacctno = p_acctno and log.afacctno = af.acctno and af.isfo = 'N'
                 union all
                 select nvl(log.prinused,0) amt 
                 from prinusedlog log, prmaster mst, afmast af
                 where mst.prtyp = 'A' and mst.prstatus = 'A' and log.prcode = mst.prcode
                       and log.afacctno = p_acctno and log.afacctno = af.acctno and af.isfo = 'N'
                       and l_countaf > 0 and l_countacct = 0)
          )loop
               if rec.amt <> 0 then
                   insert into prinusedlog(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
                   values(p_prcode, rec.amt, 'N', sysdate, seq_prinusedlog.nextval, '', getcurrdate, '', p_acctno,0);
               end if;
          end loop;

          insert into prinusedloghist(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
          select prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt from prinusedlog
          where afacctno = p_acctno
                and prcode in (select mst.prcode --nha pool S neu dang o S va gan vao P,T
                               from prmaster mst
                               where mst.prtyp = 'S' and mst.prstatus = 'A' 
                                     and l_countsys > 0 and l_prtype in ('P','T')
                               union all
                               select pm.prcode --nha pull UB neu tuan thu UB, dang o S va gan vao pool P moi
                               from prmaster pm
                               where pm.prstatus = 'A' and pm.prtyp = 'U' and l_countsys > 0
                                     and l_IsMarginAccount = 'Y' and l_prtype = 'P'
                               union all       
                               select mst.prcode --nha pool A neu dang o A, gan vao P,T 
                               from prmaster mst, prtypemap map, bridmap br
                               where mst.prcode = map.prcode and mst.prtyp = 'A'
                                     and mst.prstatus = 'A' and mst.prcode = br.prcode
                                     and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                     and br.brid = decode(br.brid, 'ALL', br.brid, l_brid)
                                     and l_countaf > 0 and l_countacct = 0);
          delete from prinusedlog
          where afacctno = p_acctno
                and prcode in (select mst.prcode --nha pool S neu dang o S va gan vao P,T
                               from prmaster mst
                               where mst.prtyp = 'S' and mst.prstatus = 'A' 
                                     and l_countsys > 0 and l_prtype in ('P','T')
                               union all
                               select pm.prcode --nha pull UB neu tuan thu UB, dang o S va gan vao pool P moi
                               from prmaster pm
                               where pm.prstatus = 'A' and pm.prtyp = 'U' and l_countsys > 0
                                     and l_IsMarginAccount = 'Y' and l_prtype = 'P'
                               union all       
                               select mst.prcode --nha pool A neu dang o A, gan vao P,T 
                               from prmaster mst, prtypemap map, bridmap br
                               where mst.prcode = map.prcode and mst.prtyp = 'A'
                                     and mst.prstatus = 'A' and mst.prcode = br.prcode
                                     and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                     and br.brid = decode(br.brid, 'ALL', br.brid, l_brid)
                                     and l_countaf > 0 and l_countacct = 0);
      else --delete
          --thong tin pool hien tai cua tieu khoan
          select prtyp into l_prtype from prmaster where prcode = p_prcode;
          
          select count(1) into l_countaf from prmaster mst, prtypemap map, bridmap br
                          where mst.prcode = map.prcode and mst.prtyp = 'A' and mst.prcode <> p_prcode
                                and mst.prstatus = 'A' and mst.prcode = br.prcode
                                and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                and br.brid = decode(br.brid, 'ALL', br.brid, l_brid);
          l_countacct :=0;
          if l_countaf = 0 then
            l_countsys:= 1;
          else
            l_countsys:= 0;
          end if;
          --cap nhat prmaster
          if l_odamt > 0 then
              insert into prmasterlog (prcode, prname, prtyp, custbank, prlimit, prinusedold, prinusednew, prstatus)
              select prcode, prname, prtyp, custbank, prlimit, prinused , prinused - decode(prtyp,'S',l_odamt,l_excamt), prstatus
              from prmaster
              where prcode = p_prcode;
              update prmaster set prinused = prinused - decode(prtyp,'S',l_odamt,l_excamt) where prcode = p_prcode;

              for rec in(
                          select mst.prcode
                          from prmaster mst, prtypemap map, bridmap br
                          where mst.prcode = map.prcode and mst.prtyp = 'A'
                                and mst.prstatus = 'A' and mst.prcode = br.prcode
                                and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                and br.brid = decode(br.brid, 'ALL', br.brid, l_brid)
                                and l_countaf > 0 and l_countsys = 0
                          union all
                          select mst.prcode
                          from prmaster mst
                          where mst.prtyp = 'S' and mst.prstatus = 'A'
                                and l_countsys > 0 and l_prtype in ('P','T')
                          union all
                          select mst.prcode
                          from prmaster mst
                          where mst.prstatus = 'A' and mst.prtyp = 'U' and l_countsys > 0
                                and l_IsMarginAccount = 'Y' and l_prtype = 'P'
              )loop
                   insert into prmasterlog (prcode, prname, prtyp, custbank, prlimit, prinusedold, prinusednew, prstatus)
                   select prcode, prname, prtyp, custbank, prlimit, prinused , prinused + decode(prtyp,'S',l_odamt,l_excamt), prstatus
                   from prmaster
                   where prcode = rec.prcode;

                   update prmaster set prinused = prinused + decode(prtyp,'S',l_odamt,l_excamt) where prcode = rec.prcode;
              end loop;
          end if;
          --cap nhat prinusedlog
          for rec in(
               select nvl(sum(log.prinused),0) amt
               from prinusedlog log, prmaster mst, afmast af
               where mst.prtyp IN ('P','T') and mst.prstatus = 'A' and log.prcode = mst.prcode
                     and log.afacctno = p_acctno and log.prcode = p_prcode
                     and log.afacctno = af.acctno and af.isfo = 'N'
          )loop
               if rec.amt <> 0 then
                   for rec_i in(
                                select mst.prcode
                                from prmaster mst, prtypemap map, bridmap br
                                where mst.prcode = map.prcode and mst.prtyp = 'A'
                                      and mst.prstatus = 'A' and mst.prcode = br.prcode
                                      and map.actype = decode(map.actype,'ALL', map.actype, l_actype)
                                      and br.brid = decode(br.brid, 'ALL', br.brid, l_brid)
                                      and l_countaf > 0 and l_countsys = 0
                                union all
                                select mst.prcode
                                from prmaster mst
                                where mst.prtyp = 'S' and mst.prstatus = 'A'
                                      and l_countsys > 0 and l_prtype in ('P','T')
                                union all
                                select mst.prcode
                                from prmaster mst
                                where mst.prstatus = 'A' and mst.prtyp = 'U' and l_countsys > 0
                                      and l_IsMarginAccount = 'Y' and l_prtype = 'P'
                   )loop
                       insert into prinusedlog(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
                       values(rec_i.prcode, rec.amt, 'N', sysdate, seq_prinusedlog.nextval, '', getcurrdate, '', p_acctno, 0);
                   end loop;
               end if;
          end loop;
          insert into prinusedloghist(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
          select prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt from prinusedlog
          where afacctno = p_acctno and prcode = p_prcode;

          delete from prinusedlog
          where afacctno = p_acctno and prcode = p_prcode;
      end if;
  end if;
  --pool loai hinh
  if length(p_aftype) > 0 then
      if p_type = 'ADD' then
          select prtyp into l_prtype from prmaster where prcode = p_prcode;
          --cap nhat prmaster
          for rec in(
             select nvl(sum(odamt),0) amt, af.acctno
                     from afmast af, cimast ci
                     where af.acctno = ci.acctno and af.actype = p_aftype
                           and af.acctno not in (select acctno from pracctnomap)
                     group by af.acctno
          )loop
                --thong tin pool truoc do cua tieu khoan
                select cf.brid into l_brid from cfmast cf, afmast af where cf.custid = af.custid and af.acctno = rec.acctno;
                
                select count(1) into l_countacct from prmaster pm, pracctnomap ac
                                where pm.prcode = ac.prcode and ac.acctno = rec.acctno
                                      and pm.prstatus = 'A' and pm.prtyp in ('P','T') and pm.prcode <> p_prcode;
                                      
                select count(1) into l_countaf from prmaster mst, prtypemap map, bridmap br
                                where mst.prcode = map.prcode and mst.prtyp = 'A' and mst.prcode <> p_prcode
                                      and mst.prstatus = 'A' and mst.prcode = br.prcode
                                      and map.actype = decode(map.actype,'ALL', map.actype, p_aftype)
                                      and br.brid = decode(br.brid, 'ALL', br.brid, l_brid);
               if l_countacct = 0 and l_countaf = 0 then
                   l_countsys:= 1;
               else
                   l_countsys:= 0;
               end if;
               if rec.amt > 0 then
                   --danh dau pool LH neu pool cu thuoc ht, ko danh dau neu thuoc pool dac biet
                   if l_countsys > 0 and l_countacct = 0 then 
                       insert into prmasterlog (prcode, prname, prtyp, custbank, prlimit, prinusedold, prinusednew, prstatus)
                       select prcode, prname, prtyp, custbank, prlimit, prinused , prinused + rec.amt, prstatus
                       from prmaster
                       where prcode = p_prcode;

                       update prmaster set prinused = prinused + rec.amt where prcode = p_prcode;
                       
                       insert into prinusedlog(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
                       values(p_prcode, l_amt, 'N', sysdate, seq_prinusedlog.nextval, '', getcurrdate, '', rec.acctno, 0);
                   end if;
               end if;
          end loop;
          --cap nhat prinusedlog
          for rec in(
                     select distinct log.afacctno, af.isfo
                     from prinusedlog log, afmast af
                     where log.afacctno = af.acctno and af.actype = p_aftype
                           and af.acctno not in (select acctno from pracctnomap)
                     group by log.afacctno, log.prcode
          )loop
               select nvl(sum(log.prinused),0) amt
               into l_amt
               from prinusedlog log, prmaster mst
               where log.prcode = mst.prcode
                     and mst.prtyp = 'S' and log.afacctno = rec.afacctno;

               select mst.prcode into l_syprcode
               from prmaster mst
               where mst.prtyp = 'S' and mst.prstatus = 'A';

               insert into prinusedloghist(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
               select prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt from prinusedlog
               where afacctno = rec.afacctno and prcode = l_syprcode;

               delete from prinusedlog
               where afacctno = rec.afacctno and prcode = l_syprcode;
        
               if rec.isfo = 'N' then
                    insert into prinusedlog(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
                    values(l_syprcode, l_amt, 'N', sysdate, seq_prinusedlog.nextval, '', getcurrdate, '', rec.afacctno, 0);
               end if;
          end loop;
      else --delete
          --cap nhat prmaster
          for rec in(
                     select nvl(sum(odamt),0) amt, af.acctno
                     from afmast af, cimast ci
                     where af.acctno = ci.acctno and af.actype = p_aftype
                           and af.acctno not in (select acctno from pracctnomap)
                     group by af.acctno
          )loop
                --thong tin pool truoc do cua tieu khoan
                select cf.brid into l_brid from cfmast cf, afmast af where cf.custid = af.custid and af.acctno = rec.acctno;
                
                select count(1) into l_countacct from prmaster pm, pracctnomap ac
                                where pm.prcode = ac.prcode and ac.acctno = rec.acctno
                                      and pm.prstatus = 'A' and pm.prtyp in ('P','T') and pm.prcode <> p_prcode;
                                      
                select count(1) into l_countaf from prmaster mst, prtypemap map, bridmap br
                                where mst.prcode = map.prcode and mst.prtyp = 'A' and mst.prcode <> p_prcode
                                      and mst.prstatus = 'A' and mst.prcode = br.prcode
                                      and map.actype = decode(map.actype,'ALL', map.actype, p_aftype)
                                      and br.brid = decode(br.brid, 'ALL', br.brid, l_brid);
               if l_countacct = 0 and l_countaf = 0 then
                   l_countsys:= 1;
               else
                   l_countsys:= 0;
               end if;
               
               if rec.amt <> 0 then
                   if l_countsys > 0 and l_countacct = 0 then 
                     insert into prmasterlog (prcode, prname, prtyp, custbank, prlimit, prinusedold,prinusednew, prstatus)
                     select prcode, prname, prtyp, custbank, prlimit, prinused , prinused - rec.amt, prstatus
                     from prmaster
                     where prcode = p_prcode;
             
                     update prmaster set prinused = prinused - rec.amt where prcode = p_prcode;
                     --cap nhat prinusedlog
                     insert into prinusedloghist(prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt)
                     select prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref, afacctno, advamt from prinusedlog 
                     where prcode =  p_prcode and afacctno = rec.acctno;

                     delete from prinusedlog where prcode =  p_prcode and afacctno = rec.acctno;
                   end if;
               end if;
          end loop;
      end if;
  end if;
  plog.setendsection (pkgctx, 'prc_PoolAlloc');
exception
  when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_PoolAlloc');
      RAISE errnums.E_SYSTEM_ERROR;
end prc_PoolAlloc;