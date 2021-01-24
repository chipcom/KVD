***** 28.01.20 ��।������ ��� �� ��⠫�� ������ ���� ����� - 2019-20 ���
Function definition_KSG(par,k_data2)
    // 䠩�� "human", "human_" � "human_2" ������ � ���� �� �㦭�� �����
    //       "human" ����� ��� ����� �㬬� ����
    // �믮����� use_base("human_u","HU") - ��� �����
    // �믮����� use_base("mo_hu","MOHU") - ��� �����
    Static ver_year := 0 // ��᫥���� �஢��塞� ���
    Static ad_ksg_3, ad_ksg_4
    Static sp0, sp1, sp6, sp15
    Static a_iskl_1 := {; // �᪫�祭�� �� �ࠢ�� �1
      {"st02.010","st02.008"},;
      {"st02.011","st02.008"},;
      {"st02.010","st02.009"},;
      {"st14.001","st04.002"},;
      {"st14.004","st04.002"},;
      {"st21.001","st21.007"},;
      {"st34.002","st34.001"},;
      {"st34.002","st26.001"},;
      {"st34.006","st30.003"},;
      {"st09.001","st30.005"},;
      {"st31.002","st31.017"},;
      {"st37.001",""},;
      {"st37.002",""},;
      {"st37.003",""},;
      {"st37.004",""},;
      {"st37.005",""},;
      {"st37.006",""},;
      {"st37.007",""},;
      {"st37.008",""},;
      {"st37.009",""},;
      {"st37.010",""},;
      {"st37.011",""},;
      {"st37.012",""},;
      {"st37.013",""},;
      {"st37.014",""},;
      {"st37.015",""},;
      {"st37.016",""},;
      {"st37.017",""},;
      {"st37.018",""},;
      {"ds37.001",""},;
      {"ds37.002",""},;
      {"ds37.003",""},;
      {"ds37.004",""},;
      {"ds37.005",""},;
      {"ds37.006",""},;
      {"ds37.007",""},;
      {"ds37.008",""},;
      {"ds37.009",""},;
      {"ds37.010",""},;
      {"ds37.011",""},;
      {"ds37.012",""};
     }
    Local mdiagnoz, aHirKSG := {}, aTerKSG := {}, fl_cena := .f., lvmp, lvidvmp := 0, lstentvmp := 0,;
          i, j, k, c, s, ar, ar1, fl, im, lshifr, ln_data, lk_data, lvr, ldni, ldate_r, lpol, lprofil_k,;
          lfio, cenaTer := 0, cenaHir := 0, ksgHir, ars := {}, arerr := {}, ;
          lksg := "", lcena := 0, osn_diag3, lprofil, ldnej := 0, y := 0, m := 0, d := 0,;
          osn_diag := space(6), sop_diag := {}, osl_diag := {}, tmp, lrslt, akslp, akiro,;
          lad_cr := "", lad_cr1 := "", lis_err := 0, akslp2, lpar_org := 0, lyear,;
          kol_ter := 0, kol_hir := 0, lkoef, fl_reabil, lkiro := 0, lkslp := "", lbartell := "",;
          lusl, susl, s_dializ := 0, ahu := {}, amohu := {}, date_usl := stod("20200101")
    DEFAULT par TO 1, sp0 TO "", sp1 TO space(1), sp6 TO space(6), sp15 TO space(20)
    Private pole
    if par == 1
      uch->(dbGoto(human->LPU))
      otd->(dbGoto(human->OTD))
      if (lvmp := human_2->VMP) == 1
        lvidvmp := human_2->METVMP
      endif
      lad_cr  := alltrim(human_2->pc3)
      lfio    := alltrim(human->fio)
      ln_data := human->n_data
      if valtype(k_data2) == "D"
        lk_data := k_data2
      else
        lk_data := human->k_data
      endif
      lusl    := human_->USL_OK
      ldate_r := iif(human_->NOVOR > 0, human_->date_r2, human->date_r)
      lpol    := iif(human_->NOVOR > 0, human_->pol2,    human->pol)
      lvr     := iif(human->VZROS_REB==0, 0, 1) // 0-�����, 1-ॡ����
      lprofil := human_->profil
      lprofil_k := human_2->profil_k
      lrslt   := human_->rslt_new
      // ���ᨢ ��������� (������ ���)
      mdiagnoz := diag_to_array(,,,,.t.)
      if len(mdiagnoz) > 0
        osn_diag := mdiagnoz[1]
        if len(mdiagnoz) > 1
          sop_diag := aclone(mdiagnoz)
          Del_Array(sop_diag,1) // ��稭�� � 2-�� - ᮯ������騥 ��������
        endif
      endif
      if !empty(human_2->OSL1)
        aadd(osl_diag,human_2->OSL1)
      endif
      if !empty(human_2->OSL2)
        aadd(osl_diag,human_2->OSL2)
      endif
      if !empty(human_2->OSL3)
        aadd(osl_diag,human_2->OSL3)
      endif
      if lusl < 3 .and. lVMP == 0 .and. f_is_oncology(1) == 2
        if select("ONKSL") == 0
          G_Use(dir_server+"mo_onksl",dir_server+"mo_onksl","ONKSL") // �������� � ��砥 ��祭�� ���������᪮�� �����������
        endif
        select ONKSL
        find (str(human->kod,7))
        lad_cr := alltrim(onksl->crit)
        if lad_cr == "���"
          lad_cr := ""
        endif
        lad_cr1 := alltrim(onksl->crit2)
        lis_err := onksl->is_err
      endif
    else // �� ०��� ������ ��砥�
      if (lvmp := iif(empty(ihuman->VID_HMP), 0, 1)) == 1
        lvidvmp := ihuman->METOD_HMP
      endif
      lad_cr  := alltrim(ihuman->ad_cr)
      if lad_cr == "���"
        lad_cr := ""
      endif
      lad_cr1 := alltrim(ihuman->ad_cr2)
      lis_err := ihuman->is_err
      lusl    := ihuman->USL_OK
      lfio    := alltrim(ihuman->fio)
      ln_data := ihuman->date_1
      if valtype(k_data2) == "D"
        lk_data := k_data2
      else
        lk_data := ihuman->date_2
      endif
      ldate_r := iif(ihuman->NOVOR > 0, ihuman->reb_dr,  ihuman->dr)
      lpol    := iif(ihuman->NOVOR > 0, ihuman->reb_pol, ihuman->w)
      lpol    := iif(lpol == 1, "�","�")
      lvr     := iif(m1VZROS_REB==0, 0, 1) // 0-�����, 1-ॡ����
      lprofil := ihuman->profil
      lprofil_k := ihuman->profil_k
      lrslt   := ihuman->rslt
      osn_diag := padr(ihuman->DS1,6)
      if !empty(ihuman->DS2)
        aadd(sop_diag, padr(ihuman->DS2,6))
      endif
      if !empty(ihuman->DS2_2)
        aadd(sop_diag, padr(ihuman->DS2_2,6))
      endif
      if !empty(ihuman->DS2_3)
        aadd(sop_diag, padr(ihuman->DS2_3,6))
      endif
      if !empty(ihuman->DS2_4)
        aadd(sop_diag, padr(ihuman->DS2_4,6))
      endif
      if !empty(ihuman->DS2_5)
        aadd(sop_diag, padr(ihuman->DS2_5,6))
      endif
      if !empty(ihuman->DS2_6)
        aadd(sop_diag, padr(ihuman->DS2_6,6))
      endif
      if !empty(ihuman->DS2_7)
        aadd(sop_diag, padr(ihuman->DS2_7,6))
      endif
      mdiagnoz := aclone(sop_diag)
      Ins_Array(mdiagnoz,1,osn_diag)
      if !empty(ihuman->DS3)
        aadd(osl_diag, padr(ihuman->DS3,6))
      endif
      if !empty(ihuman->DS3_2)
        aadd(osl_diag, padr(ihuman->DS3_2,6))
      endif
      if !empty(ihuman->DS3_3)
        aadd(osl_diag, padr(ihuman->DS3_3,6))
      endif
    endif
    lyear := year(lk_data)
    if eq_any(lad_cr,'60','61')
      lbartell := lad_cr
      lad_cr := ""
    endif
    ldni := ln_data - ldate_r // ��� ॡ񭪠 ������ � ����
    count_ymd(ldate_r,ln_data,@y,@m,@d)
    date_usl := lk_data //!!!!!!!!!!!!�᪮�����஢��� ��᫥ ���!!!!!!!!!!!!!!!
    if lusl == 1 // ��樮���
      if (ldnej := lk_data - ln_data) == 0
        ldnej := 1
      endif
    endif
    aadd(ars,lfio+" "+date_8(ln_data)+"-"+date_8(lk_data)+" ("+lstr(ldnej)+"��.)")
    s := iif(lVMP==1,'��� ',' ')
    if par == 1
      s += alltrim(uch->name)+'/'+alltrim(otd->name)+'/'
    endif
    s += '��䨫� "'+inieditspr(A__MENUVERT, glob_V002, lprofil)+'"'
    aadd(ars,s)
    aadd(ars,' �.�.'+full_date(ldate_r)+iif(lvr==0,'(���.','(ॡ.')+'), '+iif(lpol=='�','��.','���.')+;
             ', ��.����.'+osn_diag+;
             iif(empty(sop_diag), '', ', ᮯ.����.'+charrem(' ',print_array(sop_diag)))+;
             iif(empty(osl_diag), '', ', ����.��.'+charrem(' ',print_array(osl_diag))))
    if empty(osn_diag)
      aadd(arerr,' �� ����� �᭮���� �������')
      return {ars,arerr,lksg,lcena,{},{}}
    endif
    if f_put_glob_podr(lusl,date_usl,arerr) // �᫨ �� �������� ��� ���ࠧ�������
      return {ars,arerr,lksg,lcena,{},{}}
    endif
    if lvmp > 0
      if lvidvmp == 0
        aadd(arerr,' �� ����� ��⮤ ���')
      elseif ascan(arr_12_VMP,lvidvmp) == 0
        aadd(arerr,' ��� ��⮤� ��� '+lstr(lvidvmp)+' ��� ��㣨 �����')
      else
        lksg := "1.12."+lstr(lvidvmp)
        aadd(ars," ��� "+lstr(lvidvmp)+" ��⮤� ��� ������� ��㣠 "+lksg)
        lcena := ret_cena_KSG(lksg,lvr,date_usl)
        if lcena > 0
          aadd(ars," ���������: ��࠭� ��㣠="+lksg+" � 業�� "+lstr(lcena,11,0))
        else
          aadd(arerr,' ��� ��襩 �� � �ࠢ�筨�� ����� �� ������� ��㣠: '+lksg)
        endif
      endif
      return {ars,arerr,alltrim(lksg),lcena,{},{}}
    endif
    lal := "LUSL"+iif(lyear==2020,"","19")
    lalf := "LUSLF"+iif(lyear==2020,"","19")
    if select("LUSLF") == 0
      use_base("LUSLF")
    endif
    // ��⠢�塞 ���ᨢ ��� � ���ᨢ �������権
    if par == 1
      select HU
      find (str(human->kod,7))
      do while hu->kod == human->kod .and. !eof()
        usl->(dbGoto(hu->u_kod))
        if empty(lshifr := opr_shifr_TFOMS(usl->shifr1,usl->kod,date_usl))
          lshifr := usl->shifr
        endif
        lshifr := alltrim(lshifr)
        if left(lshifr,5) == "60.3."
          s_dializ += hu->stoim_1
        endif
        if ascan(ahu,lshifr) == 0
          aadd(ahu,lshifr)
        endif
        if lusl == 2 .and. left(lshifr,5)=='55.1.'
          ldnej += hu->kol_1
        endif
        select HU
        skip
      enddo
      if select("MOSU") == 0
        R_Use(dir_server+"mo_su",,"MOSU")
      endif
      select MOHU
      find (str(human->kod,7))
      do while mohu->kod == human->kod .and. !eof()
        if mosu->(recno()) != mohu->u_kod
          mosu->(dbGoto(mohu->u_kod))
        endif
        if ascan(amohu,mosu->shifr1) == 0
          aadd(amohu,mosu->shifr1)
        endif
        dbSelectArea(lalf)
        find (padr(mosu->shifr1,20))
        if found() .and. !empty(&lalf.->par_org)
          lpar_org += len(List2Arr(mohu->zf))
        endif
        select MOHU
        skip
      enddo
    else
      select IHU
      find (str(ihuman->kod,10))
      do while ihu->kod == ihuman->kod .and. !eof()
        if eq_any(left(ihu->CODE_USL,1),"A","B")
          if ascan(amohu,ihu->CODE_USL)==0
            aadd(amohu,ihu->CODE_USL)
          endif
          dbSelectArea(lalf)
          find (padr(ihu->CODE_USL,20))
          if found() .and. !empty(&lalf.->par_org)
            lpar_org += len(List2Arr(ihu->par_org))
          endif
        else
          if ascan(ahu,alltrim(ihu->CODE_USL)) == 0
            aadd(ahu,alltrim(ihu->CODE_USL))
          endif
          if left(ihu->CODE_USL,5) == "60.3."
            s_dializ += ihu->SUMV_USL
          endif
          if lusl == 2 .and. left(ihu->CODE_USL,5)=='55.1.'
            ldnej += ihu->KOL_USL
          endif
        endif
        select IHU
        skip
      enddo
    endif
    if lvr == 0 //
      lage := '6'
      s := "���."
    else
      lage := '5'
      s := "���"
      fl := .t.
      if ldni <= 28
        lage += '1' // ��� �� 28 ����
        s := "0-28��."
        fl := .f.
      elseif ldni <= 90
        lage += '2' // ��� �� 90 ����
        s := "29-90��."
        fl := .f.
      elseif y < 1 // �� 1 ����
        lage += '3' // ��� �� 91 ��� �� 1 ����
        s := "91����-1���"
        fl := .f.
      endif
      if y <= 2 // �� 2 ��� �����⥫쭮
        lage += '4' // ��� �� 2 ���
        if fl
          s := "��2��� �����."
        endif
      endif
    endif
    ars[1] := lfio+" "+date_8(ln_data)+"-"+date_8(lk_data)+" ("+lstr(ldnej)+"��.)"
    ars[3] := ' �.�.'+full_date(ldate_r)+'('+s+'), '+iif(lpol=='�','��.','���.')+;
              ', ��.����.'+osn_diag+;
              iif(empty(sop_diag), '', ', ᮯ.����.'+charrem(' ',print_array(sop_diag)))+;
              iif(empty(osl_diag), '', ', ����.��.'+charrem(' ',print_array(osl_diag)))
    lsex := iif(lpol=='�','1','2')
    llos := {} //''
    if ldnej < 4
      aadd(llos,'1') //llos += '1'
    elseif between(ldnej,4,7)
      aadd(llos,'8')
    elseif between(ldnej,8,10)
      aadd(llos,'9')
    else
      aadd(llos,'10')
    endif
    /*
    0 - ���� �� �ਬ������
    1 - ���⥫쭮��� ���� 3 �����-��� (���� ��祭��) � ����� � ��樥��� �믮����� ���ࣨ�᪠� ������
        ���� ��㣮� ����⥫��⢮, ��騥�� �����䨪�樮��� ���ਥ� �⭥ᥭ�� ������� ���� ��祭��
        � �����⭮� ��� ��� ����ᨬ��� �� ��⠭�� � १���⠬� ���饭�� �� ����樭᪮� �������
    2 - ���⥫쭮��� ���� 3 �����-��� (���� ��祭��) � �����, �� ���ࣨ�᪮� ��祭�� ���� ��㣮� ����⥫��⢮,
        ��।����饥 �⭥ᥭ�� � ��� �� �஢������� � ���ਥ� �⭥ᥭ�� � ��砥 ���� ��� �������� �� ��� 10
        ��� ����ᨬ��� �� ��⠭�� � १���⠬� ���饭�� �� ����樭᪮� �������;
    3 - ���⥫쭮��� ���� 4 �����-��� (���� ��祭��) � ����� � ��樥��� �믮����� ���ࣨ�᪠� ������
        ���� ��㣮� ����⥫��⢮, ��騥�� �����䨪�樮��� ���ਥ� �⭥ᥭ�� ������� ���� ��祭��
        � �����⭮� ��� � ��⠭�� � १���⠬� ���饭�� �� ����樭᪮� �������
        (�����䨪��� V009) 102, 105, 107, 110, 202, 205, 207
    4 - ���⥫쭮��� ���� 4 �����-��� (���� ��祭��) � �����, �� ���ࣨ�᪮� ��祭�� ���� ��㣮� ����⥫��⢮,
        ��।����饥 �⭥ᥭ�� � ��� �� �஢�������, � ��⠭�� � १���⠬� ���饭�� �� ����樭᪮� �������
        (�����䨪��� V009) 102, 105, 107, 110, 202, 205, 207
    5 - ��砨 � ��ᮡ����� ०��� �������� ������⢥����� �९��� (���� �������� � �奬�) ᮣ��᭮ ������樨
        � �९���� �� ���⥫쭮�� ���� 3 �����-��� (��� ��祭��) � ����� ��� ����ᨬ��� �� १���� ���饭��
        �� ����樭᪮� �������
    6 - ��砨 � ��ᮡ����� ०��� �������� ������⢥����� �९��� (���� �������� � �奬�) ᮣ��᭮ ������樨
        � �९���� �� ���⥫쭮�� ���� 4 �����-��� (��� ��祭��) � ����� � ��⠭�� � १���⠬� ���饭��
        �� ����樭᪮� ������� (�����䨪��� V009) 102, 105, 107, 110, 202, 205, 207
    */
    //aadd(ars,'   �age='+lage+' sex='+lsex+' los='+print_array(llos))
    nfile := "_mo"+iif(lyear==2020,"0","9")+"k006"
    if select("K006") == 0
      R_Use(exe_dir+nfile,{cur_dir+nfile,cur_dir+nfile+"_"},"K006")
      /*{"SHIFR",      "C",     10,      0},;
        {"DS",         "C",      6,      0},;
        {"DS1",        "M",     10,      0},;
        {"DS2",        "M",     10,      0},;
        {"SY",         "C",     20,      0},;
        {"AGE",        "C",      1,      0},;
        {"SEX",        "C",      1,      0},;
        {"LOS",        "C",      1,      0},;
        {"AD_CR",      "C",     10,      0},;
        {"AD_CR1",     "C",     10,      0},;
      index on substr(shifr,1,2)+ds+sy+age+sex+los to (cur_dir+sbase) // �� ��������/����樨
      index on substr(shifr,1,2)+sy+ds+age+sex+los to (cur_dir+sbase+"_") // �� ����樨/��������
      */
    else
      if ver_year == lyear // �஢��塞: �᫨ �� �� ���, �� ⮫쪮 �� �஢��﫨
        // ��祣� �� ���塞
      else // ���� ��८��뢠�� ����� 䠩� � ����室��� ����� � ⥬ �� ����ᮬ
        k006->(dbCloseArea())
        R_Use(exe_dir+nfile,{cur_dir+nfile,cur_dir+nfile+"_"},"K006")
      endif
    endif
    ver_year := lyear
    fl_reabil := (ascan(ahu,"1.11.2") > 0 .or. ascan(ahu,"55.1.4") > 0)
    susl := iif(lusl == 1, "st", "ds")
    // ᮡ�ࠥ� ��� �� ��.�������� (�࠯����᪨� � �������஢����)
    ar := {}
    tmp := {}
    select K006
    set order to 1
    find (susl+padr(osn_diag,6))
    do while left(k006->shifr,2)==susl .and. k006->ds==padr(osn_diag,6) .and. !eof()
      lkoef := k006->kz
      dbSelectArea(lal)
      find (padr(k006->shifr,10))
      fl := lkoef > 0 .and. between_date(&lal.->DATEBEG,&lal.->DATEEND,date_usl)
      if fl
        fl := between_date(k006->DATEBEG,k006->DATEEND,date_usl)
      endif
      if fl
        sds1 := iif(empty(k006->ds1), sp0, alltrim(k006->ds1)+sp6) // ᮯ.�������
        sds2 := iif(empty(k006->ds2), sp0, alltrim(k006->ds2)+sp6) // �����.�᫮������
      endif
      j := 0
      if fl .and. !empty(k006->sy)
        if (i := ascan(amohu,k006->sy)) > 0
          j += 10
        else
          fl := .f.
        endif
      endif
      if fl .and. !empty(k006->age)
        if (fl := (k006->age $ lage))
          if k006->age == '1'
            j += 5
          elseif k006->age == '2'
            j += 4
          elseif k006->age == '3'
            j += 3
          elseif k006->age == '4'
            j += 2
          else
            j ++
          endif
        endif
      endif
      if fl .and. !empty(k006->sex)
        fl := (k006->sex == lsex)
        if fl ; j ++ ; endif
      endif
      if fl .and. !empty(k006->los)
        fl := ascan(llos,alltrim(k006->los)) > 0  // (k006->los $ llos)
        if fl ; j ++ ; endif
      endif
      if fl
        if empty(lad_cr) // � ��砥 ��� ���.�����
          if !empty(k006->ad_cr) // � � �ࠢ�筨�� ���� ���.���਩
            fl := .f.
          endif
        else // � ��砥 ���� ���.���਩
          if empty(k006->ad_cr) // � � �ࠢ�筨�� ��� ���.�����
            fl := .f.
          else                  // � � �ࠢ�筨�� ���� ���.���਩
            fl := (lad_cr == alltrim(k006->ad_cr))
            if fl ; j ++ ; endif
          endif
        endif
      endif
      if fl
        if empty(lad_cr1) // � ��砥 ��� ���.�����2
          if !empty(k006->ad_cr1) // � � �ࠢ�筨�� ���� ���.���਩2
            fl := .f.
          endif
        else // � ��砥 ���� ���.���਩2
          if empty(k006->ad_cr1) // � � �ࠢ�筨�� ��� ���.�����2
            fl := .f.
          else                  // � � �ࠢ�筨�� ���� ���.���਩2
            fl := (lad_cr1 == alltrim(k006->ad_cr1))
            if fl ; j ++ ; endif
          endif
        endif
      endif
      if fl .and. !empty(sds1)
        fl := .f.
        for i := 1 to len(sop_diag)
          if alltrim(sop_diag[i]) $ sds1
            fl := .t. ; exit
          endif
        next
        if fl ; j ++ ; endif
      endif
      if fl .and. !empty(sds2)
        fl := .f.
        for i := 1 to len(osl_diag)
          if alltrim(osl_diag[i]) $ sds2
            fl := .t. ; exit
          endif
        next
        if fl ; j ++ ; endif
      endif
      if fl
        if !empty(k006->sy) .and. (i := ascan(amohu,k006->sy)) > 0
          aadd(tmp,i)
        endif
        aadd(ar,{k006->shifr,; //  1
                 0,;           //  2
                 lkoef,;       //  3
                 &lal.->kiros,; //  4
                 osn_diag,;    //  5
                 k006->sy,;    //  6
                 k006->age,;   //  7
                 k006->sex,;   //  8
                 k006->los,;   //  9
                 k006->ad_cr,; // 10
                 sds1,;        // 11
                 sds2,;        // 12
                 j,;           // 13
                 &lal.->kslps,; // 14
                 k006->ad_cr1}) // 15
      endif
      select K006
      skip
    enddo
    ar1 := {}
    if lusl == 2 .and. !empty(lad_cr) .and. lad_cr == "mgi"
      select K006
      Locate for k006->ad_cr == padr("mgi",20)
      if found() // <CODE>ds19.033</CODE>
        lkoef := k006->kz
        dbSelectArea(lal)
        find (padr(k006->shifr,10))
        fl := lkoef > 0 .and. between_date(&lal.->DATEBEG,&lal.->DATEEND,date_usl)
        if fl
          fl := between_date(k006->DATEBEG,k006->DATEEND,date_usl)
        endif
        if fl
          sds1 := iif(empty(k006->ds1), sp0, alltrim(k006->ds1)+sp6) // ᮯ.�������
          sds2 := iif(empty(k006->ds2), sp0, alltrim(k006->ds2)+sp6) // �����.�᫮������
          j := 1
          ar := {}
          aadd(ar1,{k006->shifr,; //  1
                    0,;           //  2
                    lkoef,;       //  3
                    &lal.->kiros,; //  4
                    k006->ds,;    //  5
                    lshifr,;      //  6
                    k006->age,;   //  7
                    k006->sex,;   //  8
                    k006->los,;   //  9
                    k006->ad_cr,; // 10
                    sds1,;        // 11
                    sds2,;        // 12
                    j,;           // 13
                    &lal.->kslps,; // 14
                    k006->ad_cr1}) // 15
        endif
      endif
    endif
    if len(ar) > 0
      for i := 1 to len(tmp)
        im := tmp[i]
        amohu[im] := "" // ������, �⮡� �� ������� � ���ࣨ���� ���
      next
      for i := 1 to len(ar)
        ar[i,2] := ret_cena_KSG(ar[i,1],lvr,date_usl)
        if ar[i,2] > 0
          fl_cena := .t.
        endif
      next
      aTerKSG := aclone(ar)
      if len(aTerKSG) > 1
        asort(aTerKSG,,,{|x,y| iif(x[13]==y[13], x[3] > y[3], x[13] > y[13]) })
      endif
      /*aadd(ars,"   ����: "+print_array(aTerKSG[1]))
      for j := 2 to len(aTerKSG)
        aadd(ars,"   �     "+print_array(aTerKSG[j]))
      next*/
      if (kol_ter := f_put_debug_KSG(0,aTerKSG,ars)) > 1
        aadd(ars," ��> �롨ࠥ� ���="+rtrim(aTerKSG[1,1])+" [��="+lstr(aTerKSG[1,3])+"]")
      endif
    endif
    // ᮡ�ࠥ� ��� �� ��������� (���ࣨ�᪨� � �������஢����)
    ar := ar1
    for im := 1 to len(amohu)
      if !empty(lshifr := alltrim(amohu[im]))
        _a1 := {}
        select K006
        set order to 2
        find (susl+padr(lshifr,20))
        do while left(k006->shifr,2)==susl .and. k006->sy==padr(lshifr,20) .and. !eof()
          lkoef := k006->kz
          dbSelectArea(lal)
          find (padr(k006->shifr,10))
          fl := lkoef > 0 .and. between_date(&lal.->DATEBEG,&lal.->DATEEND,date_usl)
          if fl
            fl := between_date(k006->DATEBEG,k006->DATEEND,date_usl)
          endif
          if fl
            sds1 := iif(empty(k006->ds1), sp0, alltrim(k006->ds1)+sp6) // ᮯ.�������
            sds2 := iif(empty(k006->ds2), sp0, alltrim(k006->ds2)+sp6) // �����.�᫮������
          endif
          j := 0
          if fl .and. !empty(k006->ds)
            fl := (k006->ds == osn_diag)
            if fl ; j += 10 ; endif
          endif
          if fl .and. !empty(k006->age)
            if (fl := (k006->age $ lage))
              if k006->age == '1'
                j += 5
              elseif k006->age == '2'
                j += 4
              elseif k006->age == '3'
                j += 3
              elseif k006->age == '4'
                j += 2
              else
                j ++
              endif
            endif
          endif
          if fl .and. !empty(k006->sex)
            fl := (k006->sex == lsex)
            if fl ; j ++ ; endif
          endif
          if fl .and. !empty(k006->los)
            fl := ascan(llos,alltrim(k006->los)) > 0  // (k006->los $ llos)
            if fl ; j ++ ; endif
          endif
          if fl .and. !empty(k006->ad_cr)  // � �ࠢ�筨�� ���� ���.���਩
            fl := .f.
            if !empty(lad_cr)        // � ��砥 ���� ���.���਩
              fl := (lad_cr == alltrim(k006->ad_cr))
              if fl ; j ++ ; endif
            endif
          endif
          if fl .and. !empty(k006->ad_cr1)  // � �ࠢ�筨�� ���� ���.���਩2
            fl := .f.
            if !empty(lad_cr1)        // � ��砥 ���� ���.���਩2
              fl := (lad_cr1 == alltrim(k006->ad_cr1))
              if fl ; j ++ ; endif
            endif
          endif
          if fl .and. !empty(sds1)
            fl := .f.
            for i := 1 to len(sop_diag)
              if alltrim(sop_diag[i]) $ sds1
                fl := .t. ; exit
              endif
            next
            if fl ; j ++ ; endif
          endif
          if fl .and. !empty(sds2)
            fl := .f.
            for i := 1 to len(osl_diag)
              if alltrim(osl_diag[i]) $ sds2
                fl := .t. ; exit
              endif
            next
            if fl ; j ++ ; endif
          endif
          if fl
            aadd(_a1,{k006->shifr,; //  1
                      0,;           //  2
                      lkoef,;       //  3
                      &lal.->kiros,; //  4
                      k006->ds,;    //  5
                      lshifr,;      //  6
                      k006->age,;   //  7
                      k006->sex,;   //  8
                      k006->los,;   //  9
                      k006->ad_cr,; // 10
                      sds1,;        // 11
                      sds2,;        // 12
                      j,;           // 13
                      &lal.->kslps,; // 14
                      k006->ad_cr1}) // 15
          endif
          select K006
          skip
        enddo
        if len(_a1) > 1 // �᫨ �� ������ ��㣥 ����� ����� ���, ����㥬 �� �뢠��� ���ਥ�
          asort(_a1,,,{|x,y| iif(x[13]==y[13], x[3] > y[3], x[13] > y[13]) })
        endif
        if len(_a1) > 0
          aadd(ar,aclone(_a1[1]))
        endif
      endif
    next
    if len(ar) > 0
      for i := 1 to len(ar)
        ar[i,2] := ret_cena_KSG(ar[i,1],lvr,date_usl)
        if ar[i,2] > 0
          fl_cena := .t.
        endif
      next
      aHirKSG := aclone(ar)
      if len(aHirKSG) > 1
        asort(aHirKSG,,,{|x,y| iif(x[3]==y[3], x[13] > y[13], x[3] > y[3]) })
      endif
      /*aadd(ars,"   ����: "+print_array(aHirKSG[1]))
      for j := 2 to len(aHirKSG)
        aadd(ars,"   �     "+print_array(aHirKSG[j]))
      next*/
      if (kol_hir := f_put_debug_KSG(0,aHirKSG,ars)) > 1
        aadd(ars," ��> �롨ࠥ� ���="+rtrim(aHirKSG[1,1])+" [��="+lstr(aHirKSG[1,3])+"]")
      endif
    endif
    if kol_ter > 0 .and. kol_hir > 0
      aTerKSG[1,1] := alltrim(aTerKSG[1,1])
      aHirKSG[1,1] := alltrim(aHirKSG[1,1])
      //i := int(val(substr(aTerKSG[1,1],2,3)))
      //j := int(val(substr(aHirKSG[1,1],2,3)))
      if !empty(aTerKSG[1,6]) // �.�. ������� + ��㣠
        lksg  := aTerKSG[1,1]
        lcena := aTerKSG[1,2]
        lkiro := list2arr(aTerKSG[1,4])
        lkslp := aTerKSG[1,14]
        aadd(ars," �롨ࠥ� ���="+lksg+" (��.�������+��㣠 "+rtrim(aTerKSG[1,6])+")")
      //elseif ascan(a_iskl_1, {|x| x[1]==j .and. eq_any(x[2],0,i) .and. lusl==x[3] }) > 0 // �᪫�祭�� �� �ࠢ�� �1
      elseif ascan(a_iskl_1, {|x| x[1]==aHirKSG[1,1] .and. (empty(x[2]) .or. x[2]==aTerKSG[1,1]) }) > 0 // �᪫�祭�� �� �ࠢ�� �1
        lksg  := aHirKSG[1,1]
        lcena := aHirKSG[1,2]
        lkiro := list2arr(aHirKSG[1,4])
        lkslp := aHirKSG[1,14]
        aadd(ars," � ᮮ⢥��⢨� � ����������� �� ��� �롨ࠥ� "+aHirKSG[1,1]+" ����� "+aTerKSG[1,1])
      else
        if aTerKSG[1,3] > aHirKSG[1,3] // "�᫨ ����.�� ����� �࠯����᪮�� ��"
          lksg  := aTerKSG[1,1]
          lcena := aTerKSG[1,2]
          lkiro := list2arr(aTerKSG[1,4])
          lkslp := aTerKSG[1,14]
          aadd(ars," �롨ࠥ� ��� ="+aTerKSG[1,1]+" � ������� �����樥�⮬ �����񬪮�� "+lstr(aTerKSG[1,3]))
        else
          lksg  := aHirKSG[1,1]
          lcena := aHirKSG[1,2]
          lkiro := list2arr(aHirKSG[1,4])
          lkslp := aHirKSG[1,14]
          aadd(ars," ��⠢�塞 ���="+aHirKSG[1,1]+" � �����樥�⮬ �����񬪮�� "+lstr(aHirKSG[1,3]))
        endif
      endif
    elseif kol_ter > 0
      aTerKSG[1,1] := alltrim(aTerKSG[1,1])
      lksg  := aTerKSG[1,1]
      lcena := aTerKSG[1,2]
      lkiro := list2arr(aTerKSG[1,4])
      lkslp := aTerKSG[1,14]
    elseif kol_hir > 0
      aHirKSG[1,1] := alltrim(aHirKSG[1,1])
      lksg  := aHirKSG[1,1]
      lcena := aHirKSG[1,2]
      lkiro := list2arr(aHirKSG[1,4])
      lkslp := aHirKSG[1,14]
    endif
    akslp := {} ; akiro := {}
    if lksg == 'ds18.001' .and. s_dializ > 0
      lksg := ""
    endif
    if !empty(lksg)
      s := " ���������: ��࠭� ���="+lksg
      if empty(lcena)
        s += ", �� �� ��।����� 業� � �ࠢ�筨�� �����"
        aadd(arerr,s)
      else
        s += ", 業� "+lstr(lcena,11,0)+"�. "
        aadd(ars,s)
        s := ""
        if lksg == 'st38.001' .and. lbartell == '61' // ����᪠� ��⥭�� (�� �ࠢ��� 㦥 ���५� � �� �ਬ������)
          lkslp := ""                                                       // �.�. � ������ ��� ��� ����
        endif
        akslp := f_cena_kslp(@lcena,;
                             lksg,;
                             ldate_r,;
                             ln_data,;
                             lk_data,;
                             lkslp,;
                             amohu,;
                             lprofil_k,;
                             mdiagnoz,;
                             lpar_org,;
                             lad_cr)
        if !empty(akslp)
          s += "  (���� = "+str(akslp[2],4,2)
          if len(akslp) >= 4
            s += "+"+str(akslp[4],4,2)
          endif
          s += ", 業� "+lstr(lcena,11,0)+"�.)"
        endif
        if !empty(lkiro)
          vkiro := 0
          if ldnej < 4 // ����� 4-� ����
            if ascan(lkiro,1) > 0
              vkiro := 1
            elseif ascan(lkiro,2) > 0
              vkiro := 2
              if lksg == 'ds02.005' //; // ����ࠪ�௮ࠫ쭮� ������⢮७��
                     //.and. lk_data >= 0d20190301 // � 1 ���� ����=2 �� �������
                vkiro := 0
              endif
            elseif lis_err == 1 .and. ascan(lkiro,5) > 0 // ������塞 ��� ��ᮡ���� �奬� 娬���࠯�� (����=5)
              vkiro := 5
            endif
          elseif ascan({102,105,107,110,202,205,207},lrslt) > 0 // ����� 3-� ����, ��祭�� ��ࢠ��
            if ascan(lkiro,3) > 0
              vkiro := 3
            elseif ascan(lkiro,4) > 0
              vkiro := 4
            elseif lis_err == 1 .and. ascan(lkiro,6) > 0 // ������塞 ��� ��ᮡ���� �奬� 娬���࠯�� (����=6)
              vkiro := 6
            endif
          endif
          if vkiro > 0
            akiro := f_cena_kiro(@lcena,vkiro)
            s += "  (���� = "+str(akiro[2],4,2)+", 業� "+lstr(lcena,11,0)+"�.)"
          endif
        endif
        if !empty(s)
          aadd(ars,s)
        endif
      endif
    else
      if lusl == 2 .and. s_dializ > 0
        return {{},{},"",0,{},{},s_dializ}
      else
        aadd(arerr," ���������: �� ����稫��� ����� ���"+iif(fl_reabil,' ��� ���� ����樭᪮� ॠ�����樨',''))
      endif
    endif
    return {ars,arerr,alltrim(lksg),lcena,akslp,akiro,s_dializ}
    //       1     2      3            4     5     6       7
    