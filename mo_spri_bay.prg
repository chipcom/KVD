***** �ᯥ�⪠ ࠧ����� �ࠢ�筨��� - mo_spri.prg
#include "inkey.ch"
#include "..\_mylib_hbt\function.ch"
#include "..\_mylib_hbt\edit_spr.ch"
#include "chip_mo.ch"

***** 16.09.18 ��ᬮ��/����� ���� �ࠢ�筨���
Function o_sprav(k)
Static sk := 1, sk1 := 1, sk2 := 1
Local str_sem, mas_pmt, mas_msg, mas_fun, j
DEFAULT k TO 0
do case
  case k == 0
    mas_pmt := {"~��㣨",;
                "~��������",;
                "~���ᮭ��",;
                "~���������",;
                "~��㣨� �ࠢ�筨��"}
    mas_msg := {"��㣨",;
                "��������",;
                "���ᮭ��",;
                "��ᬮ�� �ࠢ�筨���, �⭮������ � �ਪ��� ����� �59 �� ���������",;
                "��㣨� �ࠢ�筨��"}
    mas_fun := {"o_sprav(1)",;
                "o_sprav(2)",;
                "o_sprav(3)",;
                "o_sprav(4)",;
                "o_sprav(5)"}
    if mem_kodotd == 2
      aadd(mas_pmt, "���� ~�⤥�����")
      aadd(mas_msg, "���� �⤥�����")
      aadd(mas_fun, "o_sprav(6)")
    endif
    uch_otd := saveuchotd()
    popup_prompt(T_ROW,T_COL-5,sk,mas_pmt,mas_msg,mas_fun)
    restuchotd(uch_otd)
  case k == 1
    fspr_uslugi()
  case k == 2
    spr_info_diagn()
  case k == 3
    spr_personal()
  case k == 4
    mas_pmt := {"��㣨 �������⨪� �� ����᫥������� �� ~���",;
                "��㣨 �� ⨯�� ��祭�� ~���������������",;
                "��易⥫�� ⨯� ��� ��� ��⮤�� ���",;
                "��ࠢ�筨�� N~0..."}
    mas_msg := {"�뢮� ᯨ᪠ ��� �������⨪� �� ����᫥������� � ���ࠢ������ �� ���",;
                "�뢮� ᯨ᪠ ��� �� ⨯�� ��祭�� ���������������",;
                "�뢮� ��易⥫��� ⨯�� ��� ��� ������� ��⮤� ��� � ���������᪨� �����",;
                "��ᯥ�⪠ �ࠢ�筨���, �������� � ���������� ����஫쭮�� ����"}
    mas_fun := {"o_sprav(11)",;
                "o_sprav(12)",;
                "o_sprav(13)",;
                "o_sprav(14)"}
    popup_prompt(T_ROW-3-len(mas_pmt),T_COL-5,sk1,mas_pmt,mas_msg,mas_fun)
  case k == 5
    spr_other()
  case k == 6
    spr_kod_otd()
  case k == 11 // �뢮� ᯨ᪠ ��� �������⨪� �� ����᫥������� � ���ࠢ������ �� ���
    usl_napr_FFOMS()
  case k == 12 // �뢮� ᯨ᪠ ��� �� ⨯�� ��祭�� ���������������
    usl_ksg_FFOMS()
  case k == 13 // ��易⥫�� ⨯� ��� ��� ��⮤�� ���
    pr_sprav_onk_vmp()
  case k == 14
    mas_pmt := {"�����䨪��� �⠤�� (N00~2)",;
                "�����䨪��� Tumor (N00~3)",;
                "�����䨪��� Nodus (N00~4)",;
                "�����䨪��� Metastasis (N00~5)",;
                "��ࠢ�筨� ᮮ⢥��⢨� �⠤�� TNM (N00~6)"}
    mas_msg := {"��ᯥ�⪠ �����䨪��� �⠤�� (N002)",;
                "��ᯥ�⪠ �����䨪��� Tumor (N003)",;
                "��ᯥ�⪠ �����䨪��� Nodus (N004)",;
                "��ᯥ�⪠ �����䨪��� Metastasis (N005)",;
                "��ᯥ�⪠ �ࠢ�筨�� ᮮ⢥��⢨� �⠤�� TNM (N006)"}
    mas_fun := {"o_sprav(21)",;
                "o_sprav(22)",;
                "o_sprav(23)",;
                "o_sprav(24)",;
                "o_sprav(25)"}
    popup_prompt(T_ROW,T_COL-5,sk2,mas_pmt,mas_msg,mas_fun)
  case k == 21 //
    pr_sprav_N002(2)
  case k == 22 //
    pr_sprav_N002(3)
  case k == 23 //
    pr_sprav_N002(4)
  case k == 24 //
    pr_sprav_N002(5)
  case k == 25 // ��ࠢ�筨� ᮮ⢥��⢨� �⠤�� TNM
    pr_sprav_N006()
endcase
if k > 0
  if k > 20
    sk2 := k
  elseif k > 10
    sk1 := k
  else
    sk := k
  endif
endif
return NIL

***** 18.08.18
Function fspr_uslugi(k)
Static _su := 110
Static sk := 1, sk1 := 1, sk2 := 1
Local str_sem, mas_pmt, mas_msg, mas_fun, j, s
DEFAULT k TO 0
do case
  case k == 0
    mas_pmt := {"���� �� ~����",;
                "��㣨 �� �⠭����� ~�����",;
                "��㣨 �����ࠢ� �� (~�����)",;
                "���᮪ ��� �� ~���",;
                "���᮪ ~������ ���",;
                "���᮪ ��� �� ~���",;
                "��㣨 � ~�㫥��� 業��",;
                "����� ~���������� ���"}
    mas_msg := {"��ᬮ�� �����⭮� ��㣨 � ���᪮� �� ����",;
                "��ᯥ�⪠ ᯨ᪠ ��� � 業��� ����� �� ���",;
                "��ᯥ�⪠ ������������ ����樭᪨� ��� �����ࠢ� �� (�����)",;
                "��ᯥ�⪠ ᯨ᪠ ��� � 業��� �� ���",;
                "��ᯥ�⪠ ᯨ᪠ ��� � 業��� �� ����� ��㣨",;
                "��ᯥ�⪠ ᯨ᪠ ��� � 業��� �� ���",;
                "��ᯥ�⪠ ���, ��� ������ ࠧ�蠥��� ���� �㫥��� 業�",;
                "��ᯥ�⪠ ���������� ���"}
    mas_fun := {"fspr_uslugi(1)",;
                "fspr_uslugi(2)",;
                "fspr_uslugi(3)",;
                "fspr_uslugi(4)",;
                "fspr_uslugi(5)",;
                "fspr_uslugi(6)",;
                "fspr_uslugi(7)",;
                "fspr_uslugi(8)"}
    popup_prompt(T_ROW, T_COL-5, sk, mas_pmt, mas_msg, mas_fun)
  case k == 1
    v_1usluga()
  case k == 2
    mas_pmt := {"~���� ᬥ�� 業 �� ��㣨",;
                "~���� �� �������� ����",;
                "��㣨 ����� -> ~��� ��㣨"}
    mas_msg := {"�뢮� ᯨ᪠ ��������� ����� �� 業� ��� �� ������� ��⠬",;
                "�뢮� ᯨ᪠ ��� ����� � 業��� �� 㪠������ ���� ����",;
                "�ਢ離� ���� ��� � ��㣠� �����"}
    mas_fun := {"fspr_uslugi(11)",;
                "fspr_uslugi(12)",;
                "fspr_uslugi(13)"}
    Private su := _su
    popup_prompt(T_ROW-len(mas_pmt)-3, T_COL-5, sk1, mas_pmt, mas_msg, mas_fun)
    _su := su
  case k == 3
    mas_pmt := {"����������� ������ ~�����",;
                "~�⮬�⮫����᪨� ��㣨",;
                "��㣨 ~⥫�����樭�",;
                "����樨 �� ~����� �࣠���",;
                "�����䨪��� ~����� ���",;
                "�����䨪��� ~��⮤�� ���",;
                "��㣨 ����� -> ~��� ��㣨"}
    mas_msg := {"�뢮� ᯨ᪠ ��� �����ࠢ� �� (�����) �� ���ࠧ�����",;
                "�뢮� ᯨ᪠ �⮬�⮫����᪨� ��� �����ࠢ� �� (�����) �� ��㯯��",;
                "��ᯥ�⪠ ᯨ᪠ ��� � �ᯮ�짮������ ⥫�����樭᪨� �孮�����",;
                "��ᯥ�⪠ ᯨ᪠ ����権 �� ����� �࣠��� (����� ⥫�)",;
                "��ᯥ�⪠ �����䨪��� ����� ���",;
                "��ᯥ�⪠ �����䨪��� ��⮤�� ��� (� ��㯯�஢��� �� ����� ���)",;
                "�ਢ離� ���� ��� � ��㣠� �����"}
    mas_fun := {"fspr_uslugi(21)",;
                "fspr_uslugi(22)",;
                "fspr_uslugi(23)",;
                "fspr_uslugi(24)",;
                "fspr_uslugi(25)",;
                "fspr_uslugi(26)",;
                "fspr_uslugi(27)"}
    k := len(mas_pmt)
    use_base("luslc")
    set order to 2
    find (glob_mo[_MO_KOD_TFOMS]+"ds")
    if found()
      aadd(mas_pmt, "��㣨 + ��� (~������� ��樮���)")
      aadd(mas_msg, "�뢮� ᯨ᪠ ࠧ����� ��� ����� ����� � ��� �������� ��樮���")
      aadd(mas_fun, "fspr_uslugi(28)")
    endif
    k := len(mas_pmt)
    find (glob_mo[_MO_KOD_TFOMS]+"st")
    if found()
      aadd(mas_pmt, "��㣨 + ~��� (��樮���)")
      aadd(mas_msg, "�뢮� ᯨ᪠ ࠧ����� ��� ����� ����� � ��� ��樮���")
      aadd(mas_fun, "fspr_uslugi(29)")
    endif
    close databases
    popup_prompt(T_ROW-len(mas_pmt)-3, T_COL-5, sk2, mas_pmt, mas_msg, mas_fun)
  case k == 4
    f4_uslugi(1)
  case k == 5
    f4_uslugi(2)
  case k == 6
    f4_uslugi(3)
  case k == 7
    v_nulusluga()
  case k == 8
    v_k_uslugi()
  case k == 11
    usl1TFOMS()
  case k == 12
    usl2TFOMS()
  case k == 13
    usl3TFOMS()
  case k == 21
    usl1FFOMS()
  case k == 22
    usl_stom_FFOMS()
  case k == 23
    usl_telemedicina()
  case k == 24
    usl_par_organ()
  case k == 25
    usl11FFOMS()
  case k == 26
    usl12FFOMS()
  case k == 27
    usl2FFOMS()
  case k == 28
    usl6FFOMS(2)
  case k == 29
    usl6FFOMS(1)
endcase
if k > 0
  if k > 20
    sk2 := k-20
  elseif k > 10
    sk1 := k-10
  else
    sk := k
  endif
endif
return NIL

***** 03.01.18
Function f4_uslugi(reg)
Local i, s := "���᮪ ��� ", mas[2], buf := save_maxrow(),;
      n_file := "uslugi"+stxt, sh := 80, HH := 60, l, k, j, lshifr, lshifr1, lname
if (j := f_alert({"����室�� �뢮� ᯨ᪠ �⤥�����,",;
                  "� ������ ࠧ�蠥��� ���� ��㣨?",;
                  ""},;
                 {" ~��� "," ~�� "},;
                 1,"N+/BG","R/BG",17,,col1menu )) == 0
  return NIL
endif
mywait()
do case
  case reg == 1
    s += "� 業��� �� ���"
  case reg == 2
    s := "���᮪ ������ ���"
  case reg == 3
    s += "� 業��� �� ���"
endcase
fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
add_string("")
add_string(CENTER(s,sh))
add_string("")
if mem_trudoem == 2
  Private arr_title := {space(sh-15)+"��� "+iif(is_oplata==7,"��.","���")+"���� "+iif(is_oplata==7,"���","���"),;
                        space(sh-15)+"���������������"}
  aeval(arr_title, {|x| add_string(x) } )
  useUch_Usl()
  l := sh-16
else
  l := sh
endif
Use_base("lusl")
Use_base("luslc")
R_Use(dir_server+"mo_uch",,"LPU")
R_Use(dir_server+"mo_otd",,"OTD")
R_Use(dir_server+"usl_otd",dir_server+"usl_otd","UO")
R_Use(dir_server+"uslugi",,"USL")
index on iif(kod>0,"1","0")+fsort_usl(shifr) to (cur_dir+"tmp_usl")
go top
do while !eof()
  lshifr := ""
  if !empty(usl->shifr)
    s := usl->shifr
    lname := alltrim(usl->name)
    lshifr += alltrim(usl->shifr)
    lshifr1 := opr_shifr_TFOMS(usl->shifr1,usl->kod)
    if reg == 1 .and. !empty(lshifr1) .and. !(usl->shifr==lshifr1)
      s := lshifr1
      lshifr += "("+alltrim(lshifr1)+")"
    endif
    lshifr += "."
    //if usl->zf == 1
      //lshifr += " [��] "
    //endif
    s := f42_uslugi(reg,s)
    if !empty(s)
      if mem_trudoem == 2
        if verify_FF(HH, .t., sh)
          aeval(arr_title, {|x| add_string(x) } )
        endif
      else
        verify_FF(HH, .t., sh)
      endif
      if empty(lshifr1) .or. lshifr1 == usl->shifr
        select LUSL
        find (usl->shifr)
        if found()
          lname := alltrim(lusl->name)
        else
          select LUSL18
          find (usl->shifr)
          if found()
            lname := alltrim(lusl18->name)
          endif
        endif
      endif
      k := perenos(mas,lshifr+lname+" ["+s+"]",l," ,;")
      s := padr(mas[1],l)
      if mem_trudoem == 2
        select UU
        find (str(usl->kod,4))
        if is_oplata == 7
          s += put_val_0(uu->vkoef_v,8,4)+put_val_0(uu->akoef_v,8,4)
        else
          s += put_val_0(uu->koef_v,8,4)+put_val_0(uu->koef_r,8,4)
        endif
      endif
      add_string(s)
      for i := 2 to k
        add_string(padl(alltrim(mas[i]),l))
      next
      if j == 2
        select UO
        find (str(usl->kod,4))
        if found()
          k := 1
          do while !(substr(uo->otdel,k,1) == chr(0))
            otd->(dbGoto(asc(substr(uo->otdel,k,1))))
            lpu->(dbGoto(otd->kod_lpu))
            add_string(space(18)+"= "+alltrim(otd->name)+" ["+alltrim(lpu->name)+"]")
            ++k
          enddo
        endif
      endif
    endif
  endif
  select USL
  skip
enddo
close databases
fclose(fp)
viewtext(n_file,,,,,,,2)
RETURN NIL

*****
Function f42_uslugi(reg,_shifr)
Local s := "", v1, v2, fl1del, fl2del
if reg == 1
  select LUSL
  find (_shifr)
  if found()
    v1 := fcena_oms(lusl->shifr,.t.,sys1_date,@fl1del)
    v2 := fcena_oms(lusl->shifr,.f.,sys1_date,@fl2del)
    if fl1del .and. fl2del
      s += "㤠���� �����"
    else
      s += "�="+dellastnul(v1)+";��="+dellastnul(v2)
    endif
  elseif !emptyall(usl->cena,usl->cena_d)
    s += "�="+dellastnul(usl->cena)+";��="+dellastnul(usl->cena_d)
  endif
endif
// ��� ������ ���
if eq_any(reg,2,3,23)
  if eq_any(reg,2,23) .and. !emptyall(usl->pcena,usl->pcena_d)
    s += "���="+dellastnul(usl->pcena)
    if !empty(usl->pnds)
      s += "(���="+dellastnul(usl->pnds)+")"
    endif
    s += ";����="+dellastnul(usl->pcena_d)
    if !empty(usl->pnds_d)
      s += "(���="+dellastnul(usl->pnds_d)+")"
    endif
  endif
  if eq_any(reg,3,23) .and. !empty(usl->dms_cena)
    if !empty(s)
      s += ";"
    endif
    s += "���="+dellastnul(usl->dms_cena)
  endif
endif
return s

*

***** 16.04.18
Static Function v_1usluga()
Local arr_usl, atf := {0,"",""}, i := 1, k, mas[2], sh := 80, HH := 60, j := 0, j1, ;
      sb, fl, lshifr, s, n_file := "usluga_1"+stxt
if (arr_usl := input_usluga(atf)) != NIL
  mywait()
  fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
  R_Use(dir_exe+"_mo9dep",cur_dir+"_mo9dep","DEP")
  Use_base("lusl")
  Use_base("luslc")
  R_Use(dir_server+"uslugi",dir_server+"uslugi","USL")
  add_string("")
  add_string(center("�������� ������",sh))
  add_string("")
  add_string(center("(�� ��襬� �ࠢ�筨��)",sh))
  add_string("")
  if arr_usl[1] == 0
    add_string("�� �������!")
  else
    select USL
    find (str(arr_usl[1],4))
    lshifr := ""
    if !empty(usl->shifr)
      s := usl->shifr
      lshifr += alltrim(usl->shifr)
      lshifr1 := opr_shifr_TFOMS(usl->shifr1,usl->kod)
      if !empty(lshifr1) .and. !(usl->shifr==lshifr1)
        lshifr += "("+alltrim(lshifr1)+")"
        s := lshifr1
      endif
      lshifr += "."
    endif
    k := perenos(mas,lshifr+" "+alltrim(usl->name)+" ["+f42_uslugi(1,s)+"]",sh," ,;")
    add_string(mas[1])
    if k > 1
      add_string(padl(alltrim(mas[2]),sh))
    endif
    if !emptyall(usl->pcena,usl->pcena_d,usl->dms_cena)
      add_string("")
      add_string(SPACE(2)+"* ���� ���⭮� ��㣨"+" ["+f42_uslugi(23)+"]")
    endif
    if mem_trudoem == 2
      useUch_Usl()
      select UU
      find (str(arr_usl[1],4))
      add_string("")
      if is_oplata == 7
        if !emptyall(uu->koef_v,uu->vkoef_v,uu->akoef_v)
          s := "  ��� ��� ������ "+str_0(uu->koef_v,7,4)+;
               " [��� "+alltrim(str_0(uu->vkoef_v,7,4))+", ���. "+alltrim(str_0(uu->akoef_v,7,4))+"]"
          add_string(s)
        endif
        if !emptyall(uu->koef_r,uu->vkoef_r,uu->akoef_r)
          s := "  ��� ��� ��⥩    "+str_0(uu->koef_r,7,4)+;
               " [��� "+alltrim(str_0(uu->vkoef_r,7,4))+", ���. "+alltrim(str_0(uu->akoef_r,7,4))+"]"
          add_string(s)
        endif
      else
        if !empty(uu->koef_v)
          add_string("  ��� ��� ������ "+str_0(uu->koef_v,7,4))
        endif
        if !empty(uu->koef_r)
          add_string("  ��� ��� ��⥩    "+str_0(uu->koef_r,7,4))
        endif
      endif
    endif
  endif
  add_string("")
  add_string(replicate("-",sh))
  add_string("")
  add_string(center("(�� �ࠢ�筨�� �����)",sh))
  add_string("")
  if atf[1] == 0
    add_string("�� �������!")
  else
    k := perenos(mas,atf[2],sh)
    add_string(mas[1])
    for i := 2 to k
      add_string(padl(alltrim(mas[i]),sh))
    next
    select LUSLC18
    set order to 1
    find (atf[3])
    do while luslc18->shifr == atf[3] .and. !eof()
      s := space(2)+"c "+date_8(luslc18->datebeg)+" �� "+date_8(luslc18->dateend)+": ���� "+;
           iif(luslc18->VZROS_REB==0,'���᫠�=','���᪠� =')+dellastnul(luslc18->cena)
      if is_otd_dep .and. luslc18->depart > 0
        select DEP
        find (str(luslc18->depart,3))
        if found()
          s += "  ("+alltrim(dep->name_short)+")"
        endif
      endif
      verify_FF(HH)
      add_string(s)
      select LUSLC18
      skip
    enddo
    select LUSLC
    set order to 1
    find (atf[3])
    do while luslc->shifr == atf[3] .and. !eof()
      s := space(2)+"c "+date_8(luslc->datebeg)+" �� "+date_8(luslc->dateend)+": ���� "+;
           iif(luslc->VZROS_REB==0,'���᫠�=','���᪠� =')+dellastnul(luslc->cena)
      if is_otd_dep .and. luslc->depart > 0
        select DEP
        find (str(luslc->depart,3))
        if found()
          s += "  ("+alltrim(dep->name_short)+")"
        endif
      endif
      verify_FF(HH)
      add_string(s)
      select LUSLC
      skip
    enddo
  endif
  close databases
  fclose(fp)
  viewtext(n_file,,,,,,,2)
endif
return NIL

*

*****
Static Function v_k_uslugi()
Local sh := 80, HH := 57, n_file := "k_uslugi"+stxt
mywait()
fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
add_string("")
add_string(center("����������� ������",sh))
add_string("")
R_Use(dir_server+"uslugi",dir_server+"uslugish","USL")
R_Use(dir_server+"uslugi1k",dir_server+"uslugi1k","U1K")
set relation to shifr1 into USL
R_Use(dir_server+"uslugi_k",dir_server+"uslugi_k","UK")
go top
do while !eof()
  verify_FF(HH-3, .t., sh)
  add_string("")
  add_string(uk->shifr+" "+rtrim(uk->name))
  select U1K
  find (uk->shifr)
  do while u1k->shifr == uk->shifr .and. !eof()
    verify_FF(HH, .t., sh)
    add_string("   "+u1k->shifr1+" "+rtrim(usl->name))
    skip
  enddo
  select UK
  skip
enddo
close databases
fclose(fp)
viewtext(n_file,,,,,,,2)
return NIL

*

*****
Static Function v_nulusluga()
Local mas[2], k, l, s, sh := 80, HH := 57, n_file := "n_uslugi"+stxt
mywait()
fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
add_string("")
add_string(center("������, ��� ������ ࠧ�蠥��� ���� �㫥��� 業�",sh))
if mem_trudoem == 2
  Private arr_title := {space(sh-15)+"��� "+iif(is_oplata==7,"��.","���")+"���� "+iif(is_oplata==7,"���","���"),;
                        space(sh-15)+"���������������"}
  aeval(arr_title, {|x| add_string(x) } )
  useUch_Usl()
  l := sh-16
else
  l := sh
endif
R_Use(dir_server+"uslugi",,"USL")
for i := 1 to 2
  add_string("")
  add_string(center(iif(i==1,"[ ��� ]","[ ����� ��㣨 ]"),sh))
  add_string("")
  index on iif(kod>0,"1","0")+fsort_usl(shifr) to (cur_dir+"tmp_usl") ;
        for !empty(shifr) .and. iif(i==1,is_nul,is_nulp)
  go top
  do while !eof()
    if mem_trudoem == 2
      if verify_FF(HH, .t., sh)
        aeval(arr_title, {|x| add_string(x) } )
      endif
    else
      verify_FF(HH, .t., sh)
    endif
    s := rtrim(usl->shifr)+" "
    //if usl->zf == 1
      //s += "[��] "
    //endif
    k := perenos(mas,s+alltrim(usl->name),l," ,;")
    s := padr(mas[1],l)
    if mem_trudoem == 2
      select UU
      find (str(usl->kod,4))
      if is_oplata == 7
        s += put_val_0(uu->vkoef_v,8,4)+put_val_0(uu->akoef_v,8,4)
      else
        s += put_val_0(uu->koef_v,8,4)+put_val_0(uu->koef_r,8,4)
      endif
    endif
    add_string(s)
    if k > 1
      add_string(padl(alltrim(mas[2]),l))
    endif
    select USL
    skip
  enddo
next
close databases
fclose(fp)
viewtext(n_file,,,,,,,2)
return NIL

*

***** 23.10.19 ���� ᬥ�� 業
Function usl1TFOMS()
Local k, buf := save_maxrow(), name_file := "uslugi"+stxt, sh := 80, HH := 60, ;
      i, s, fl, v1, v2, mdate, pole, nu, t_arr[BR_LEN], ret, ret_arr, scode, dy
mywait()
dbcreate(cur_dir+"tmp",{{"ibeg","N",1,0},{"iend","N",1,0},{"data","D",8,0}})
use (cur_dir+"tmp") new
index on dtos(data) to (cur_dir+"tmp")
use_base("luslc")
select LUSLC18
index on datebeg to (cur_dir+"tmp_uslc18") for !empty(datebeg) .and. codemo == glob_mo[_MO_KOD_TFOMS] unique
go top
do while !eof()
  select TMP
  append blank
  tmp->ibeg := 1
  tmp->data := luslc18->datebeg
  select LUSLC18
  skip
enddo
select LUSLC18
index on dateend to (cur_dir+"tmp_uslc18") for !empty(dateend) .and. codemo == glob_mo[_MO_KOD_TFOMS] unique
go top
do while !eof()
  select TMP
  find (dtos(luslc18->dateend))
  if !found()
    append blank
    tmp->data := luslc18->dateend
  endif
  tmp->iend := 1
  select LUSLC18
  skip
enddo
//
select LUSLC
index on datebeg to (cur_dir+"tmp_uslc") for !empty(datebeg) .and. codemo == glob_mo[_MO_KOD_TFOMS] unique
go top
do while !eof()
  select TMP
  append blank
  tmp->ibeg := 1
  tmp->data := luslc->datebeg
  select LUSLC
  skip
enddo
select LUSLC
index on dateend to (cur_dir+"tmp_uslc") for !empty(dateend) .and. codemo == glob_mo[_MO_KOD_TFOMS] unique
go top
do while !eof()
  select TMP
  find (dtos(luslc->dateend))
  if !found()
    append blank
    tmp->data := luslc->dateend
  endif
  tmp->iend := 1
  select LUSLC
  skip
enddo
close databases
rest_box(buf)
t_arr[BR_TOP] := T_ROW
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := T_COL-5
t_arr[BR_RIGHT] := t_arr[BR_LEFT]+26
t_arr[BR_COLOR] := color0
t_arr[BR_COLUMN] := {{ "���� ᬥ��;   業",{|| iif(tmp->ibeg==1,full_date(tmp->data),space(10)) } },;
                     { "����砭��; ����⢨�;  ���",{|| iif(tmp->iend==1,full_date(tmp->data),space(10)) } }}
t_arr[BR_STAT_MSG] := {|| status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮�") }
t_arr[BR_ENTER] := {|| ret := {tmp->data,tmp->ibeg,tmp->iend} }
use (cur_dir+"tmp") index (cur_dir+"tmp") new
keyboard chr(K_END)
edit_browse(t_arr)
close databases
if ret != NIL
  mdate := ret[1]
  dy := year(mdate)
  scode := glob_mo[_MO_KOD_TFOMS]
  mywait()
  dbcreate(cur_dir+"tmp1",{{"shifr","C",10,0},;
                           {"flv","L",1,0},;
                           {"fld","L",1,0},;
                           {"depart","N",3,0},;
                           {"cenav","N",10,2},;
                           {"cenad","N",10,2}})
  R_Use(dir_exe+"_mo9dep",cur_dir+"_mo9dep","DEP")
  use (cur_dir+"tmp1") new
  index on shifr+str(depart,3) to (cur_dir+"tmp1")
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  add_string(glob_mo[_MO_SHORT_NAME]+iif(valtype(ret_arr)=="A", " ("+ret_arr[2]+" - "+ret_arr[1]+")",""))
  if ret[2] == 1
    add_string("")
    add_string(center("���᮪ 業 �� ��㣨",sh))
    add_string(center("[ 業� ��⠭������ "+date_8(mdate)+"�. ]",sh))
    add_string("")
    use_base("luslc")
    if dy < 2019
      select LUSLC18
      set order to 2 // ࠡ�⠥� � ᮡ�⢥��묨 業���
      find (scode)
      do while luslc18->CODEMO == scode .and. !eof()
        if luslc18->datebeg == mdate
          select TMP1
          find (luslc18->shifr+str(luslc18->depart,3))
          if !found()
            append blank
            tmp1->shifr := luslc18->shifr
            tmp1->depart := luslc18->depart
          endif
          if luslc18->VZROS_REB == 0
            tmp1->flv := .t.
            tmp1->cenav := luslc18->CENA
          else
            tmp1->fld := .t.
            tmp1->cenad := luslc18->CENA
          endif
        endif
        select LUSLC18
        skip
      enddo
    else
      select LUSLC
      go top
      do while !eof()
        if luslc->datebeg == mdate
          select TMP1
          find (luslc->shifr+str(luslc->depart,3))
          if !found()
            append blank
            tmp1->shifr := luslc->shifr
            tmp1->depart := luslc->depart
          endif
          if luslc->VZROS_REB == 0
            tmp1->flv := .t.
            tmp1->cenav := luslc->CENA
          else
            tmp1->fld := .t.
            tmp1->cenad := luslc->CENA
          endif
        endif
        select LUSLC
        skip
      enddo
    endif
    use_base("lusl")
    select TMP1
    if dy < 2019
      set relation to shifr into LUSL18
    else
      set relation to shifr into LUSL
    endif
    index on fsort_usl(shifr) to (cur_dir+"tmp1")
    go top
    old := space(10)
    do while !eof()
      n := iif(empty(tmp1->depart), 50, 70)
      k := perenos(t_arr,iif(dy < 2019, lusl18->name, lusl->name),n)
      if empty(tmp1->depart)
        s := tmp1->shifr+padr(t_arr[1],n)
        if emptyall(tmp1->cenav,tmp1->cenad)
          s += iif(tmp1->flv,put_kop(tmp1->cenav,10),space(10))
          s += iif(tmp1->fld,put_kop(tmp1->cenad,10),space(10))
        else
          s += put_kopE(tmp1->cenav,10)+put_kopE(tmp1->cenad,10)
        endif
        verify_FF(HH-k,.t.,sh)
        add_string(s)
        for i := 2 to k
          add_string(space(10)+t_arr[i])
        next
      endif
      if !empty(tmp1->depart)
        if !(old == tmp1->shifr)
          verify_FF(HH-k-1,.t.,sh)
          for i := 1 to k
            add_string(iif(i==1,tmp1->shifr,space(10))+t_arr[i])
          next
        endif
        select DEP
        find (str(tmp1->depart,3))
        if found()
          s := padl(alltrim(dep->name_short),60)
          s += put_kopE(tmp1->cenav,10)+put_kopE(tmp1->cenad,10)
          verify_FF(HH,.t.,sh)
          add_string(s)
        endif
      endif
      old := tmp1->shifr
      select TMP1
      skip
    enddo
  endif
  if ret[3] == 1
    add_string("")
    add_string(center("���᮪ ���, �����稢�� ����⢨�",sh))
    add_string(center(date_month(mdate,.t.),sh))
    add_string("")
    use_base("luslc")
    if dy < 2019
      select LUSLC18
      set order to 2 // ࠡ�⠥� � ᮡ�⢥��묨 業���
      find (scode)
      do while luslc18->CODEMO == scode .and. !eof()
        if !empty(luslc18->dateend) .and. luslc18->dateend == mdate
          select TMP1
          find (luslc18->shifr+str(luslc18->depart,3))
          if !found()
            append blank
            tmp1->shifr := luslc18->shifr
            tmp1->depart := luslc18->depart
          endif
          if luslc18->VZROS_REB == 0
            tmp1->flv := .t.
            tmp1->cenav := luslc18->CENA
          else
            tmp1->fld := .t.
            tmp1->cenad := luslc18->CENA
          endif
        endif
        select LUSLC18
        skip
      enddo
    else
      select LUSLC
      go top
      do while !eof()
        if !empty(luslc->dateend) .and. luslc->dateend == mdate
          select TMP1
          find (luslc->shifr+str(luslc->depart,3))
          if !found()
            append blank
            tmp1->shifr := luslc->shifr
            tmp1->depart := luslc->depart
          endif
          if luslc->VZROS_REB == 0
            tmp1->flv := .t.
            tmp1->cenav := luslc->CENA
          else
            tmp1->fld := .t.
            tmp1->cenad := luslc->CENA
          endif
        endif
        select LUSLC
        skip
      enddo
    endif
    use_base("lusl")
    select TMP1
    if dy < 2019
      set relation to shifr into LUSL18
    else
      set relation to shifr into LUSL
    endif
    index on fsort_usl(shifr) to (cur_dir+"tmp1")
    go top
    old := space(10)
    do while !eof()
      n := iif(empty(tmp1->depart), 50, 70)
      k := perenos(t_arr,iif(dy < 2019, lusl18->name, lusl->name),n)
      if empty(tmp1->depart)
        s := tmp1->shifr+padr(t_arr[1],n)
        if emptyall(tmp1->cenav,tmp1->cenad)
          s += iif(tmp1->flv,put_kop(tmp1->cenav,10),space(10))
          s += iif(tmp1->fld,put_kop(tmp1->cenad,10),space(10))
        else
          s += put_kopE(tmp1->cenav,10)+put_kopE(tmp1->cenad,10)
        endif
        verify_FF(HH-k,.t.,sh)
        add_string(s)
        for i := 2 to k
          add_string(space(10)+t_arr[i])
        next
      endif
      if !empty(tmp1->depart)
        if !(old == tmp1->shifr)
          verify_FF(HH-k-1,.t.,sh)
          for i := 1 to k
            add_string(iif(i==1,tmp1->shifr,space(10))+t_arr[i])
          next
        endif
        select DEP
        find (str(tmp1->depart,3))
        if found()
          s := padl(alltrim(dep->name_short),60)
          s += put_kopE(tmp1->cenav,10)+put_kopE(tmp1->cenad,10)
          verify_FF(HH,.t.,sh)
          add_string(s)
        endif
      endif
      old := tmp1->shifr
      select TMP1
      skip
    enddo
  endif
  close databases
  rest_box(buf)
  fclose(fp)
  viewtext(name_file,,,,.t.,,,2)
endif
return NIL

***** 15.01.18
Function ret_otd_dep()
Local ret_arr
if !(valtype(glob_otd_dep) == "N")
  glob_otd_dep := 0
endif
popup_2array(mm_otd_dep,T_ROW,T_COL-5,glob_otd_dep,1,@ret_arr,"�롮� �⤥����� ��樮���","B/BG")
if valtype(ret_arr) == "A"
  glob_otd_dep := ret_arr[2]
endif
return ret_arr

***** 07.08.17
Function f_spr_usl_adres_podr()
Static arr := {}
Local i, j, ret_arr
if (i := ascan(glob_adres_podr, {|x| x[1] == glob_mo[_MO_KOD_TFOMS] })) > 0
  if empty(arr)
    for j := 1 to len(glob_adres_podr[i,2])
      aadd(arr,{glob_adres_podr[i,2,j,3],glob_adres_podr[i,2,j,1]})
    next
  endif
  popup_2array(arr,T_ROW,T_COL-5,glob_podr,1,@ret_arr,"���� 㤠�񭭮�� ���ࠧ�������","B/BG")
  if valtype(ret_arr) == "A"
    glob_podr := ret_arr[2]
  endif
endif
if empty(ret_arr)
  glob_podr := glob_mo[_MO_KOD_TFOMS] // �� 㬮�砭��
endif
return ret_arr

***** 03.01.19
Function usl2TFOMS()
Static sdate
Local k, buf := save_maxrow(), name_file := "uslugi"+stxt, nu, ret_arr,;
      sh := 80, HH := 60, t_arr, i, s, fl, v1, v2, mdate, fl1uslc, fl2uslc,;
      ta[2], lyear, fl1del, fl2del, len_ksg := 7
DEFAULT sdate TO sys1_date
mdate := input_value(20,5,22,73,color1,;
                     "���, �� ���ﭨ� �� ������ �뢮����� 業� �� ��㣨",;
                     sdate)
if mdate == NIL
  return NIL
endif
if (lyear := year(mdate)) < 2018
  return func_error(4,"�� ����訢��� ᫨誮� ����� ���ଠ��")
endif
sdate := mdate
if (k := popup_2array(usl9TFOMS(mdate),T_ROW,T_COL-5,su,1,@t_arr,;
                      "�롥�� ��㯯� ���","B/BG",color0)) > 0
  glob_podr := ""
  if is_otd_dep .and. t_arr[2] == 501
    if (ret_arr := ret_otd_dep()) == NIL
      return NIL
    endif
  else
    glob_otd_dep := 0
  endif
  mywait()
  su := k
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  nu := get_uroven(mdate)
  /*if between(nu,1,3)
    s := "�஢��� 業 �� ���.��㣨: "+lstr(nu)
  else
    s := "�������㠫�� ���� �� ���.��㣨"
  endif*/
  add_string(glob_mo[_MO_SHORT_NAME]+iif(valtype(ret_arr)=="A", " ("+ret_arr[1]+")",""))
  add_string('')
  add_string(center("���᮪ ��� �� ��㯯�",sh))
  add_string(center('"'+alltrim(t_arr[1])+'"',sh))
  add_string(center("[ 業� �� ���ﭨ� �� "+date_8(mdate)+"�. ]",sh))
  add_string("")
  if t_arr[2] > 500
    add_string('����: 1 - �� 1 ����(����=1.1), 2 - �� 1 ���� �� 3-� ��� ������.(����=1.1)')
    add_string('      4 - 75 ��� � ����(����=1.02), 5 - 60 ��� � ���� � ��⥭��(����=1.1)')
   if t_arr[2] == 502
    add_string('      12 - ��� 1 �⠯(����=0.6), 13 - ��� ���� � �ਮ(����=1.1), 14 - ��� ���ᠤ��(����=0.19)')
   endif
    add_string('����: 1 - ����� 4-� ����, �믮����� ����.����⥫��⢮(����=0.8)')
    add_string('      2 - ����� 4-� ����, ����.��祭�� �� �஢�������(����=0.2)')
    add_string('      3 - ����� 3-� ����, �믮����� ����.����⥫��⢮, ��祭�� ��ࢠ��(����=0.9)')
    add_string('      4 - ����� 3-� ����, ����.��祭�� �� �஢�������, ��祭�� ��ࢠ��(����=0.9)')
    add_string('      5 - ����� 4-� ����, ��ᮡ��� ०�� �������� ���.�९���(����=0.2)')
    add_string('      6 - ����� 3-� ����, ��ᮡ��� ०�� �������� ���.�९���, ��祭�� ��ࢠ��(����=0.9)')
    if lyear > 2018
      R_Use(exe_dir+"_mo9k006",,"K006")
      len_ksg := 10
    else
      R_Use(exe_dir+"_mo8k006",,"K006")
      len_ksg := 6
    endif
    index on SHIFR+str(ns,6) to (cur_dir+"tmp_k006") unique
    index on SHIFR+str(ns,6)+ds+sy to (cur_dir+"tmp_k006_")
    set index to (cur_dir+"tmp_k006"),(cur_dir+"tmp_k006_")
  endif
  use_base("luslc")
  use_base("lusl")
  lal := "lusl"
  if lyear == 2018
    lal += "18"
  endif
  dbSelectArea(lal)
  if t_arr[2] > 500
    index on fsort_usl(shifr) to (cur_dir+"tmplu") for is_ksg(shifr,t_arr[2]-500) .and. datebeg >= boy(mdate)
  else
    index on fsort_usl(shifr) to (cur_dir+"tmp") for usl2arr(shifr)[1]==k .and. !is_ksg(shifr)
  endif
  go top
  do while !eof()
    v1 := fcena_oms(&lal.->shifr,.t.,mdate,@fl1del,@fl1uslc)
    v2 := fcena_oms(&lal.->shifr,.f.,mdate,@fl2del,@fl2uslc)
    if !(fl1del .and. fl2del)
      s := alltrim(&lal.->name)
      k := perenos(ta,s,50)
      verify_FF(HH-k-1,.t.,sh)
      if t_arr[2] > 100
        add_string(replicate("�",sh))
      endif
      add_string(&lal.->shifr+ta[1]+;
                 iif(fl1del,"      -   ",put_kop(v1,10))+;
                 iif(fl2del,"      -   ",put_kop(v2,10)))
      s := space(10)+padr(ta[2],50)
      if !empty(s)
        add_string(s)
      endif
      for i := 3 to k
        add_string(space(10)+ta[i])
      next
      if t_arr[2] > 500
        select K006
        set order to 1
        find (padr(&lal.->shifr,len_ksg))
        s1 := f_ret_kz_ksg(k006->kz,&lal.->kslps,&lal.->kiros)
        add_string(space(10)+s1)
        do while padr(&lal.->shifr,len_ksg) == k006->shifr .and. !eof()
          if between_date(k006->DATEBEG,k006->DATEEND,mdate)
            lrec := k006->(recno())
            lns := k006->ns
            i := 0
            s := s1 := ""
            set order to 2
            find (padr(&lal.->shifr,len_ksg)+str(lns,6))
            do while padr(&lal.->shifr,len_ksg) == k006->shifr .and. lns == k006->ns .and. !eof()
              if !empty(k006->DS)
                s1 += alltrim(k006->DS)+" "
              endif
              if ++i == 1
                if !empty(k006->DS1)
                  s += "�����.������� "+alltrim(k006->DS1)+"; "
                endif
                if !empty(k006->DS2)
                  s += "������� ���������� "+alltrim(k006->DS2)+"; "
                endif
                if !empty(k006->SY)
                  s += "������ "+alltrim(k006->sy)+"; "
                endif
                if !empty(k006->AGE)
                  if lyear > 2018
                    s += "������� "+ret_vozrast_t006(k006->AGE)+"; "
                  else
                    s += "������� "+ret_vozrast_t006_18(k006->AGE)+"; "
                  endif
                endif
                if !empty(k006->SEX)
                  s += "��� "+iif(k006->SEX=='1',"��᪮�","���᪨�")+"; "
                endif
                if !empty(k006->LOS)
                  s += ret_duration_t006(k006->LOS,iif(left(&lal.->shifr,1)=='1',"�����","��樥��")+"-")+"; "
                endif
                if k006->(fieldpos("RSLT")) > 0 .and. !empty(k006->RSLT)
                  s += "��������� "+alltrim(k006->RSLT)+"; "
                endif
                if k006->(fieldpos("AD_CR")) > 0 .and. !empty(k006->AD_CR)
                  s += "���.�������� "+alltrim(k006->AD_CR)+"; "
                endif
                if k006->(fieldpos("AD_CR1")) > 0 .and. !empty(k006->AD_CR1)
                  s += "���� �������� "+alltrim(k006->AD_CR1)+"; "
                endif
              endif
              skip
            enddo
            if !empty(s1)
              s1 := "���.������� "+left(s1,len(s1)-1)+"; "
            endif
            s := s1+s
            s := left(s,len(s)-2)
            k := perenos(ta,s,70)
            for i := 1 to k
              verify_FF(HH,.t.,sh)
              add_string(iif(i==1,space(8)+"- ",space(10))+ta[i])
            next
            select K006
            goto (lrec)
            set order to 1
          endif
          skip
        enddo
      endif
    endif
    dbSelectArea(lal)
    skip
  enddo
  close databases
  rest_box(buf)
  fclose(fp)
  viewtext(name_file,,,,.t.,,,2)
endif
return NIL

***** 12.01.19
Function ret_vozrast_t006(s)
Local ret := ""
do case
  case s == '1'
    ret := "0-28 ����"
  case s == '2'
    ret := "29-90 ����"
  case s == '3'
    ret := "�� 91 ��� �� 1 ����"
  case s == '4'
    ret := "�� 2 ��� �����⥫쭮"
  case s == '5'
    ret := "ॡ񭮪"
  case s == '6'
    ret := "�����"
endcase
return ret

***** 28.01.17
Function ret_vozrast_t006_18(s)
Local ret := ""
do case
  case s == '1'
    ret := "0-28 ����"
  case s == '2'
    ret := "29-90 ����"
  case s == '3'
    ret := "�� 91 ��� �� 1 ����"
  case s == '4'
    ret := "ॡ񭮪"
  case s == '5'
    ret := "�����"
  case eq_any(s,'6','7')
    ret := "�� 2 ���"
endcase
return ret

***** 10.03.16
Function ret_duration_t006(s,s1)
Static sd := "����", sdr := "���", sdm := "����"
Local arr := {"1-3 "+s1+sdr,;
              "4 "+s1+sdr+" � �����",;
              "1-6 "+s1+sdm,;
              "7 "+s1+sdm+" � �����",;
              "21 "+s1+sd+" � �����",;
              "1-20 "+s1+sdm,;
              "1 "+s1+sd}
Local i := int(val(s))
return "��-�� "+iif(between(i,1,7), arr[i], "")

***** 14.01.19
Static Function f_ret_kz_ksg(lkz,lkslp,lkiro)
Local s := '����-� �����񬪮�� '+lstr(lkz,5,2)
if !empty(lkslp)
  s += '; ����: '+alltrim(lkslp)
endif
if !empty(lkiro)
  s += '; ����: '+alltrim(lkiro)
endif
return s

***** 03.01.19
Function usl3TFOMS()
Local i, k, buf := save_maxrow(), name_file := "uslugi"+stxt,;
      sh := 85, HH := 80, mas1[5], mas2[5], arr[5], k1, k2, t_arr, mdate, lyear
//
if (mdate := input_value(20,5,22,74,color1,;
        "������ ����, �� ������ ����室��� ������� ���ଠ��",;
        sys_date)) == NIL
  return NIL
endif
if (lyear := year(mdate)) < 2018
  return func_error(4,"�� ����訢��� ᫨誮� ����� ���ଠ��")
endif
if (k := popup_2array(usl9TFOMS(mdate),T_ROW,T_COL-5,su,1,@t_arr,"�롥�� ��㯯� ���","B/BG",color0)) > 0
  su := k
  mywait()
  arr_title := {;
"�������������������������������������������������������������������������������������",;
" ��ࠢ�筨� �����                         � ��� �ࠢ�筨� ���                     ",;
"�������������������������������������������������������������������������������������"}
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  add_string(center("���᮪ ��� �� ��㯯�",sh))
  add_string(center('"'+alltrim(t_arr[1])+'"',sh))
  add_string(center('�� ���ﭨ� �� '+date_month(mdate,.t.),sh))
  add_string("")
  aeval(arr_title, {|x| add_string(x) } )
  dbcreate(cur_dir+"tmp",{{"shifr","C",10,0}})
  use (cur_dir+"tmp") new
  R_Use(dir_server+"uslugi",,"USL")
  go top
  do while !eof()
    lshifr1 := opr_shifr_TFOMS(usl->shifr1,usl->kod,mdate)
    select TMP
    do while tmp->(lastrec()) < usl->(recno())
      append blank
    enddo
    goto (usl->(recno()))
    tmp->shifr := iif(empty(lshifr1), usl->shifr, lshifr1)
    select USL
    skip
  enddo
  select TMP
  set relation to recno() into USL
  index on shifr+fsort_usl(usl->shifr) to (cur_dir+"tmp")
  use_base("lusl")
  lal := "lusl"
  if lyear == 2018
    lal += "18"
  endif
  dbSelectArea(lal)
  if t_arr[2] > 500
    index on fsort_usl(shifr) to (cur_dir+"tmplu") for is_ksg(shifr,t_arr[2]-500) .and. datebeg >= boy(mdate)
  else
    index on fsort_usl(shifr) to (cur_dir+"tmplu") for usl2arr(shifr)[1]==k .and. !is_ksg(shifr)
  endif
  go top
  do while !eof()
    k1 := perenos(mas1,alltrim(&lal.->shifr)+" "+&lal.->name,42)
    for i := 2 to k1
      mas1[i] := padl(alltrim(mas1[i]),42)
    next
    mas2 := {} ; k2 := 0
    select TMP
    find (&lal.->shifr)
    do while &lal.->shifr == tmp->shifr .and. !eof()
      k := perenos(arr,alltrim(usl->shifr)+" "+usl->name,42)
      for i := 1 to k
        if i == 1
          aadd(mas2,arr[1])
        else
          aadd(mas2,padl(alltrim(arr[i]),42))
        endif
      next
      k2 += k
      select TMP
      skip
    enddo
    for i := 1 to max(k1,k2)
      if verify_FF(HH,.t.,sh)
        aeval(arr_title, {|x| add_string(x) } )
      endif
      s := ""
      if i <= k1
        s := mas1[i]
      endif
      if i <= k2
        s := padr(s,43)+mas2[i]
      endif
      add_string(s)
    next
    add_string(replicate("�",sh))
    dbSelectArea(lal)
    skip
  enddo
  close databases
  rest_box(buf)
  fclose(fp)
  viewtext(name_file,,,,.t.,,,5)
endif
return NIL

*

***** 03.01.19
Static Function usl9TFOMS(mdate)
Static sdate, sarr1
Local arr := {{" 1. �����-��� �� ��䨫�",1},;
              {" 2. ��祡�� ���� �� ��䨫�",2},;
              {" 3. ��楤��� � �������樨",3},;
              {" 4. �������� ��᫥�������",4},;
              {" 7. ���⣥�������᪨� ��᫥�������",7},;
              {" 8. ����ࠧ�㪮�� ��᫥�������",8},;
              {"10. ����᪮���᪨� ��᫥�������",10},;
              {"13. �����ப�न�����᪨� ��᫥�������",13},;
              {"14. �����䠫�����",14},;
              {"16. ��稥 ��᫥�������",16},;
              {"19. ������࠯����᪮� ��祭��",19},;
              {"20. ��祡��� 䨧������",20},;
              {"21. ���ᠦ",21},;
              {"22. ��䫥���࠯��",22},;
              {"55. ������ ��樮����",55},;
              {"56. ��稥 ��㣨",56},;
              {"60. ����� �� �⤥��� ����樭᪨� ��㣨",60},;
              {"70. ��ᯠ��ਧ���",70},;
              {"71. ����� ����樭᪠� ������",71},;
              {"72. ��䨫����᪨� ����樭᪨� �ᬮ���",72}}
Local i, ls, sShifr, arr1 := {}, lyear, fl_delete := .t., fl_yes := .f., lal := "luslc"
if empty(sdate) .or. sdate != mdate
  if (lyear := year(mdate)) == 2018
    lal += "18"
  endif
  Ins_Array(arr,1,{"��� � ������� ��樮���",502})
  Ins_Array(arr,1,{"��� � ����������",501})
  use_base("luslc")
  for i := 1 to len(arr)
    if arr[i,2] > 500
      if year(mdate) == 2019 // 2019 ���
        sShifr := iif(arr[i,2] == 501, "st", "ds")
      else
        sShifr := right(lstr(arr[i,2]),1)
      endif
    else
      sShifr := lstr(arr[i,2])+"."
    endif
    ls := len(sShifr)
    dbselectArea(lal)
    set order to 1
    find (sShifr)
    do while sShifr == left(&lal.->shifr,ls) .and. !eof()
      if iif(arr[i,2] > 500, is_ksg(&lal.->shifr), .t.)
        fl_yes := .t.
        // ���� 業� �� ��� ����砭�� ��祭��
        if between_date(&lal.->datebeg,&lal.->dateend,mdate)
          fl_delete := .f. ; exit
        endif
      endif
      skip
    enddo
    if fl_yes .and. !fl_delete
      aadd(arr1,arr[i])
    endif
  next
  close databases
else
  arr1 := aclone(sarr1)
endif
sdate := mdate
sarr1 := aclone(arr1)
return arr1

*

***** 25.02.15
Static Function usl3FFOMS()
// A,B - ����� �����㣨
// XX - ࠧ��� �����㣨
Local arr := {;
  "A01 �㭪樮���쭮� ��᫥������� ��� �ᯮ�짮����� ��ᯮᮡ����� �/��� �ਡ�஢ � �믮��塞�� �����।�⢥��� ����樭᪨�� ࠡ�⭨���� (䨧������ ��᫥�������, ������ ᡮ� �����, ��������, �������, ���쯠�� � ��������)",;
  "A02 �㭪樮���쭮� ��᫥������� � �ᯮ�짮������ ������ ��ᯮᮡ�����, �ਡ�஢, �� �ॡ��饥 ᯥ樠���� ���몮� � ����� ����⥭�",;
  "A03 ���㠫쭮� ��᫥�������, �ॡ��饥 ᯥ樠���� �ਡ�஢, ���몮� � ����� ����⥭�",;
  "A04 ॣ������ ��㪮��� ᨣ�����, ���������� ��� ��ࠦ������ �࣠���� ��� ⪠�ﬨ � �� ��᫥���饩 ����஢��� � ���ᠭ���",;
  "A05 ॣ������ ���஬������� ᨣ�����, ���᪠���� ��� ��⥭�஢����� � �࣠��� � ⪠��� � �� ��᫥���饩 ����஢��� � ���ᠭ���",;
  "A06 ७⣥�������᪨� ��᫥������� � �� ��᫥���騬 ���ᠭ��� � ७⣥���࠯��",;
  "A07 ��᫥������� � ������� ࠤ���㪫���� � ��⮤� ࠤ��樮���� �࠯��",;
  "A08 ���䮫����᪨� ��᫥������� ⪠���",;
  "A09 ��᫥������� ��������᪨� ������⥩, � ������� ������ ��᫥������ ���業��樨 ����� � ������ �।�� �࣠����� � ��⨢����� �ଥ��⨢��� ��⥬",;
  "A10 ���������᪨� ��᫥�������, �믮��塞� � ����� ��祭��",;
  "A11 ᯥ樠��� ��⮤� ����祭�� ��᫥�㥬�� ��ࠧ殢, ����㯠 � ��������",;
  "A12 ��᫥������� �㭪樨 �࣠��� ��� ⪠��� � �ᯮ�짮������ ᯥ樠���� ��楤��, ��ᯮᮡ����� � ��⮤��, �� ������祭��� � ��㣨� ��ਪ��, ���ࠢ������ �� ��אַ� ��᫥������� �㭪樨 �࣠��� ��� ⪠���, - ���������⮧�� � 䨧��᪨� �஡�, ��᫥������� �ᥤ���� �����⮢, ���㭭� ॠ�樨, � ⮬ �᫥ ��।������ ��㯯� �஢� � १��-䠪��, ��᫥������� ��⥬� �����⠧� (�� �᪫�祭��� �஢�� 䠪�஢ ᢥ��뢠�饩 ��⥬�) � ��.",;
  "A13 ��᫥������� � �������⢨� �� ᮧ����� � ������� ����",;
  "A14 �室 �� ����묨 ��� �⤥��묨 ���⮬�-䨧�������᪨�� ����⠬� �࣠����� (�⮢�� �������, ���孨� ���⥫�� ��� � �.�.)",;
  "A15 ����ࣨ�, ������������, �������, ��⮯����᪨� ��ᮡ��",;
  "A16 ����⨢��� ��祭��",;
  "A17 ���஬����⭮� ��祡��� �������⢨� �� �࣠�� � ⪠��",;
  "A18 ���ࠪ�௮ࠫ쭮� �������⢨� �� �஢� � �࠭��㧨������᪨� ��ᮡ��",;
  "A19 ��祡��� 䨧������, �ਬ��塞�� �� ������������ ��।������� �࣠��� � ��⥬",;
  "A20 ��祭�� �������᪨�� �������⢨ﬨ (����, ������ � ��.)",;
  "A21 ��祭�� � ������� ������ 䨧��᪨� �������⢨� �� ��樥�� (���ᠦ, �����䫥���࠯��, ���㠫쭠� �࠯��)",;
  "A22 ��祭�� � ������� ��祢��� (��㪮����, ᢥ⮢���, ����䨮��⮢���, ����୮��) �������⢨�",;
  "A23 �������⨪� � ��祭��, �� ������祭�� � ��㣨� ��ਪ��",;
  "A24 �������⨪� � ��祭��, �᭮����� �� ⥯����� ��䥪��",;
  "A25 �����祭��",;
  "A26 ���஡�������᪨� ��᫥������� �᭮���� ����㤨⥫�� ��䥪樮���� �����������",;
  "B01 ��祡��� ��祡��-���������᪠� ��㣠",;
  "B02 ���ਭ᪨� �室",;
  "B03 ᫮���� ���������᪠� ��㣠 (��⮤� ��᫥�������: ��������, �㭪樮�����, �����㬥�⠫��, ७⣥��ࠤ�������᪨� � ��.), �ନ���騥 ���������᪨� ���������",;
  "B04 ����樭᪨� ��㣨 �� ��䨫��⨪�, ⠪�� ��� ��ᯠ��୮� �������, ���樭���, ����樭᪨� 䨧�����୮-����஢�⥫�� ��ய����",;
  "B05 ����樭᪨� ��㣨 �� ������-�樠�쭮� ॠ�����樨";
 }
Local i
for i := 1 to len(arr)
  arr[i] := {arr[i],left(arr[i],3)}
next
return arr

*

***** 12.01.14
Static Function usl4FFOMS()
// A - ����� �����㣨
// XX - ࠧ��� �����㣨
// XX - ���ࠧ��� �����㣨 (��⥬ "001"-��㯯� � �.�. ".001"-�����㯯�)
Local arr := {;
  "01 ����, ��������-��஢�� �����⪠, �ਤ�⪨ ����",;
  "02 ���筠� ��⥬�",                               ;
  "03 ���⭠� ��⥬�",                                ;
  "04 ���⠢�",                                        ;
  "05 ���⥬� �࣠��� �஢�⢮७�� � �஢�",          ;
  "06 ���㭭�� ��⥬�",                               ;
  "07 ������� �� � ���",                             ;
  "08 ���孨� ���⥫�� ���",                       ;
  "09 ������ ���⥫�� ��� � ����筠� ⪠��",       ;
  "10 ���� � ��ਪ��",                              ;
  "11 �।��⥭��",                                    ;
  "12 ��㯭� �஢����� ����",                     ;
  "13 ���⥬� ��������樨",                        ;
  "14 ��祭� � ���祢뢮��騥 ���",                   ;
  "15 ������㤮筠� ������",                           ;
  "16 ��饢��, ���㤮�, �������⨯���⭠� ��誠",     ;
  "17 ������ ��誠",                                   ;
  "18 ������ ��誠",                                  ;
  "19 ����������� � ��ﬠ� ��誠",                     ;
  "20 ���᪨� ������ �࣠��",                         ;
  "21 ��᪨� ������ �࣠��",                         ;
  "22 ������ ����७��� ᥪ�樨",                     ;
  "23 ����ࠫ쭠� ��ࢭ�� ��⥬� � �������� ����",    ;
  "24 ������᪠� ��ࢭ�� ��⥬�",                 ;
  "25 �࣠� ���",                                    ;
  "26 �࣠� �७��",                                   ;
  "27 �࣠� ����ﭨ�",                                 ;
  "28 ��窨 � ��祢뤥��⥫쭠� ��⥬�",              ;
  "29 ����᪠� ���",                              ;
  "30 ��稥"                                          ;
 }
Local i
for i := 1 to len(arr)
  arr[i] := {arr[i],left(arr[i],2)}
next
return arr

*

***** 12.01.14
Static Function usl5FFOMS()
// B - ����� �����㣨
// XX - ࠧ��� �����㣨
// XXX - ���ࠧ��� �����㣨 (��⥬ "001"-��㯯� � �.�. ".001"-�����㯯�)
Local arr := {;
  "001 ������⢮ � �����������",;
  "002 ����࣮����� � ���㭮�����",;
  "003 ����⥧������� � ॠ����⮫����",;
  "004 �������஫����",;
  "005 ����⮫����",;
  "006 ����⨪�",;
  "007 ��ਠ���",;
  "008 ��ଠ⮢���஫���� � ��ᬥ⮫����",;
  "009 ���᪠� ���������",;
  "010 ���᪠� ���ࣨ�",;
  "011 ���᪠� ���ਭ������",;
  "012 �����⮫����",;
  "013 ���⮫����",;
  "014 ��䥪樮��� �������",;
  "015 ��न������, ���᪠� ��न������",;
  "016 ������᪠� ������ୠ� �������⨪�",;
  "017 ������᪠� �ଠ�������",;
  "018 �����ப⮫����",;
  "019 ������ୠ� ����⨪�",;
  "020 ��祡��� 䨧������ � ᯮ�⨢��� ����樭�",;
  "021 �樠�쭠� �������, ᠭ���� � �����������",;
  "022 ���㠫쭠� �࠯��",;
  "023 ���஫����",;
  "024 �������ࣨ�",;
  "025 ���஫����",;
  "026 ���� ��祡��� �ࠪ⨪� (ᥬ����� ����樭�)",;
  "027 ���������",;
  "028 ��ਭ���ਭ�������",;
  "029 ��⠫쬮�����",;
  "030 ��⮫����᪠� ���⮬��",;
  "031 ��������",;
  "032 �����⮫����",;
  "033 ��䯠⮫����",;
  "034 ����࠯��",;
  "035 ��娠��� � �㤥���-��娠���᪠� �ᯥ�⨧�",;
  "036 ��娠���-��મ�����",;
  "037 ��쬮�������",;
  "038 ࠤ������� � ࠤ���࠯��",;
  "039 ७⣥�������",;
  "040 ॢ��⮫����",;
  "041 �䫥���࠯��",;
  "042 ᥪ᮫����",;
  "043 �थ筮-��㤨��� ���ࣨ�, ७⣥��������ୠ� �������⨪� � ��祭��",;
  "044 ᪮�� ����樭᪠� ������",;
  "045 �㤥���-����樭᪠� �ᯥ�⨧�",;
  "046 ��म�����-��ਭ���ਭ�������",;
  "047 �࠯��",;
  "048 ⮪ᨪ������",;
  "049 �ࠪ��쭠� ���ࣨ�",;
  "050 �ࠢ��⮫���� � ��⮯����",;
  "051 �࠭��㧨������",;
  "052 ���ࠧ�㪮��� �������⨪�",;
  "053 �஫����, ���᪠� �஫����-���஫����",;
  "054 䨧���࠯��",;
  "055 �⨧�����",;
  "056 �㭪樮���쭠� �������⨪�",;
  "057 ���ࣨ�, ��㣨� (�࠭ᯫ����� �࣠��� � ⪠���) � ������⨮�����",;
  "058 ���ਭ������",;
  "059 ��᪮���",;
  "060 ����ਮ�����",;
  "061 ����᮫����",;
  "062 �����������",;
  "063 ��⮤����",;
  "064 �⮬�⮫���� � �⮬�⮫���� ���᪠�",;
  "065 �⮬�⮫���� �࠯����᪠�",;
  "066 �⮬�⮫���� ��⮯����᪠�",;
  "067 �⮬�⮫���� ���ࣨ�᪠�",;
  "068 祫��⭮-��楢�� ���ࣨ�",;
  "069 ��稥";
 }
Local i
for i := 1 to len(arr)
  arr[i] := {arr[i],left(arr[i],3)}
next
return arr

***** 03.01.19
Function usl_stom_FFOMS()
Static arr_gr := {"��饯�䨫��","��⮤����","��࠯����᪠� �⮬�⮫����","������࠯��","����ࣨ�᪠� �⮬�⮫����"}
Local i, j, k, s, buf := save_maxrow(), name_file := "uslugiS"+stxt, sh := 80, HH := 60, t_arr[2], fl
mywait()
R_Use_base("luslf")
index on str(grp,1)+shifr to (cur_dir+"tmp_uslf")
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string("2019 ���")
add_string(center("����������� �⮬�⮫����᪨� ��� �����ࠢ� �� (�����)",sh))
add_string("")
for j := 1 to len(arr_gr)
  fl := .t.
  find (str(j,1))
  do while luslf->grp == j .and. !eof()
    s := alltrim(luslf->shifr)+" "+rtrim(luslf->name)
    if luslf->zf == 1
     s += " [��]"
    endif
    k := perenos(t_arr,s,sh-12)
    if fl
      verify_FF(HH-k-3,.t.,sh)
      add_string(replicate("=",sh))
      add_string(center(arr_gr[j],sh))
      add_string(replicate("=",sh))
      fl := .f.
    endif
    verify_FF(HH-k,.t.,sh)
    add_string(padr(t_arr[1],sh-12)+put_val_0(luslf->uetv,6,2)+put_val_0(luslf->uetd,6,2))
    for i := 2 to k
      add_string(padl(alltrim(t_arr[i]),sh-12))
    next
    skip
  enddo
next
close databases
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 03.01.19 ��ᯥ�⪠ ᯨ᪠ ��� � �ᯮ�짮������ ⥫�����樭᪨� �孮�����
Function usl_telemedicina()
Local i, j, k, buf := save_maxrow(), name_file := "uslugiT"+stxt, sh := 80, HH := 60, t_arr[2], fl
mywait()
R_Use_base("luslf")
index on shifr to (cur_dir+"tmp_uslf") for telemed == 1
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string("2019 ���")
add_string(center("��㣨 � �ᯮ�짮������ ⥫�����樭᪨� �孮����� �����ࠢ� �� (�����)",sh))
add_string("")
go top
do while !eof()
  k := perenos(t_arr,alltrim(luslf->shifr)+" "+luslf->name,sh)
  verify_FF(HH-k,.t.,sh)
  add_string(t_arr[1])
  for i := 2 to k
    add_string(padl(alltrim(t_arr[i]),sh))
  next
  skip
enddo
close databases
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 22.01.19 ��ᯥ�⪠ ᯨ᪠ ����権 �� ����� �࣠���
Function usl_par_organ()
***** 03.01.19 ��ᯥ�⪠ ᯨ᪠ ��� � �ᯮ�짮������ ⥫�����樭᪨� �孮�����
Local i, j, k, buf := save_maxrow(), name_file := "uslugiT"+stxt, sh := 80, HH := 60, t_arr[2], fl
mywait()
R_Use_base("luslf")
index on shifr to (cur_dir+"tmp_uslf") for !empty(par_org)
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string("2019 ���")
add_string("")
add_string("=== ���ᠭ�� ������祭�� �࣠�� (��� ⥫�)")
for i := 1 to len(garr_par_org)
  add_string(" "+garr_par_org[i,1])
next
add_string("===")
add_string(center("����樨 �� ����� �࣠��� (����� ⥫�) �����ࠢ� �� (�����)",sh))
add_string("")
go top
do while !eof()
  k := perenos(t_arr,alltrim(luslf->shifr)+" ("+alltrim(luslf->par_org)+") "+luslf->name,sh)
  verify_FF(HH-k,.t.,sh)
  add_string(t_arr[1])
  for i := 2 to k
    add_string(padl(alltrim(t_arr[i]),sh))
  next
  skip
enddo
close databases
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 03.01.19 �뢮� ᯨ᪠ ��� �������⨪� �� ����᫥������� � ���ࠢ������ �� ���
Function usl_napr_FFOMS()
Static arr_gr := {;
  {"1 - ������ୠ� �������⨪�",1},;
  {"2 - �����㬥�⠫쭠� �������⨪�",2},;
  {"3 - ��⮤� ��祢�� �������⨪�, �� �᪫�祭��� ��ண������",3},;
  {"4 - ��ண����騥 ��⮤� ��祢�� �������⨪� (��, ���, ���������)",4}}
Local i, j, k, buf := save_maxrow(), name_file := "uslugiON"+stxt, sh := 80, HH := 60, t_arr[2], fl, ar
if (t_arr := bit_popup(T_ROW,T_COL-5,arr_gr,,color0,1,"��⮤ ���������᪮�� ��᫥�������","B/BG")) == NIL
  return NIL
endif
ar := aclone(t_arr)
mywait()
R_Use_base("luslf")
index on str(onko_napr,1)+shifr to (cur_dir+"tmp_uslf")
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string("2019 ���")
add_string(center("����������� ��� �������⨪� �� ����᫥������� �� ��� ���� (�����)",sh))
add_string(center("(��㣨 � ���ࠢ������ �� �����७�� �� ���)",sh))
for j := 1 to len(ar)
  fl := .t.
  find (str(ar[j,2],1))
  do while luslf->onko_napr == ar[j,2] .and. !eof()
    k := perenos(t_arr,alltrim(luslf->shifr)+" "+luslf->name,sh)
    if fl
      verify_FF(HH-k-3,.t.,sh)
      add_string(replicate("=",sh))
      add_string(center(ar[j,1],sh))
      add_string(replicate("=",sh))
      fl := .f.
    endif
    verify_FF(HH-k,.t.,sh)
    add_string(padr(t_arr[1],sh))
    for i := 2 to k
      add_string(padl(alltrim(t_arr[i]),sh))
    next
    skip
  enddo
next
close databases
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 04.01.19 �뢮� ᯨ᪠ ��� �� ⨯�� ��祭�� ���������������
Function usl_ksg_FFOMS()
Static arr_gr := {;
  {"1 - ����ࣨ�᪮� ��祭��",1},;
  {"2 - ������⢥���� ��⨢����宫���� �࠯��",2},;
  {"3 - ��祢�� �࠯��",3},;
  {"4 - �������祢�� �࠯��",4},;
  {"5 - ��ᯥ���᪮� ��祭�� (�᫮������ ��⨢����宫���� �࠯��, ��⠭����/������ ���� ��⥬� (�����))",5},;
  {"6 - �������⨪�",6}}
Local i, j, k, buf := save_maxrow(), name_file := "uslugiOK"+stxt, sh := 80, HH := 60, t_arr[2], fl, ar
if (t_arr := bit_popup(T_ROW,T_COL-5,arr_gr,,color0,1,"��� ��祭�� ���������᪨� �����������","B/BG")) == NIL
  return NIL
endif
ar := aclone(t_arr)
mywait()
R_Use_base("luslf")
index on str(onko_ksg,1)+shifr to (cur_dir+"tmp_uslf")
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string("2019 ���")
add_string(center("����������� ��� �� ⨯�� ��祭�� ��������������� ���� (�����)",sh))
for j := 1 to len(ar)
  fl := .t.
  find (str(ar[j,2],1))
  do while luslf->onko_ksg == ar[j,2] .and. !eof()
    k := perenos(t_arr,alltrim(luslf->shifr)+" "+luslf->name,sh)
    if fl
      verify_FF(HH-k-3,.t.,sh)
      add_string(replicate("=",sh))
      k := perenos(t_arr,ar[j,1],sh)
      add_string(center(alltrim(t_arr[1]),sh))
      if k > 1
        add_string(center(alltrim(t_arr[2]),sh))
      endif
      add_string(replicate("=",sh))
      fl := .f.
      k := perenos(t_arr,alltrim(luslf->shifr)+" "+luslf->name,sh)
    endif
    verify_FF(HH-k,.t.,sh)
    add_string(padr(t_arr[1],sh))
    for i := 2 to k
      add_string(padl(alltrim(t_arr[i]),sh))
    next
    skip
  enddo
next
close databases
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 12.01.14
Function usl1FFOMS()
Static su := "A01", suA := "01", suB := "001"
Local k, buf := save_maxrow(), name_file := "uslugiF"+stxt, arr[2],;
      sh := 80, HH := 60, t_arr[2], t_aA[2], t_aB[2], i, n, s, fl := .f.
if !empty(popup_2array(usl3FFOMS(),T_ROW,T_COL-5,su,1,@t_arr,;
          "�롥�� ࠧ��� ������������ ����樭᪨� ���","B/W",color5))
  su := t_arr[2]
  s := su+"." ; n := 4
  if left(su,1) == "A"
    if (i := popup_prompt(T_ROW,T_COL-5,2,;
        {"� 楫�� �� ࠧ����","�� ����� ���⮬�-�㭪樮���쭮� ������"})) == 0
      return NIL
    elseif i == 1
      fl := .t.
    elseif !empty(popup_2array(usl4FFOMS(),T_ROW,T_COL-5,suA,1,@t_aA,;
                "�롥�� ���⮬�-�㭪樮������ �������","B/BG",color0))
      suA := t_aA[2] ; fl := .t.
      s += suA+"." ; n := 7
    endif
  else
    if (i := popup_prompt(T_ROW,T_COL-5,1,;
          {"� 楫�� �� ࠧ����","�� ����� ����樭᪮� ᯥ樠�쭮��"})) == 0
      return NIL
    elseif i == 1
      fl := .t.
    elseif !empty(popup_2array(usl5FFOMS(),T_ROW,T_COL-5,suB,1,@t_aB,;
               "�롥�� ����樭��� ᯥ樠�쭮���","B/BG",color0))
      suB := t_aB[2] ; fl := .t.
      s += suB+"." ; n := 8
    endif
  endif
endif
if fl
  mywait()
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  add_string("")
  add_string(center("������ ������������ ����樭᪨� ��� �����:",sh))
  for i := 1 to perenos(arr,'"'+t_arr[1]+'"',sh)
    add_string(center(alltrim(arr[i]),sh))
  next
  if n > 4
    if left(su,1) == "A"
      add_string(center("���⮬�-�㭪樮���쭠� �������:",sh))
      for i := 1 to perenos(arr,'"'+t_aA[1]+'"',sh)
        add_string(center(alltrim(arr[i]),sh))
      next
    else
      add_string(center("����樭᪠� ᯥ樠�쭮���",sh))
      for i := 1 to perenos(arr,t_aB[1],sh)
        add_string(center(alltrim(arr[i]),sh))
      next
    endif
  endif
  add_string("")
  use_base("luslf")
  find (s)
  do while s == left(luslf->shifr,n) .and. !eof()
    k := perenos(t_arr,luslf->name,65)
    verify_FF(HH-k+1,.t.,sh)
    add_string(luslf->shifr+t_arr[1])
    for i := 2 to k
      add_string(space(20)+t_arr[i])
    next
    skip
  enddo
  close databases
  rest_box(buf)
  fclose(fp)
  viewtext(name_file,,,,.t.,,,2)
endif
return NIL

***** 03.01.19
Function usl2FFOMS()
Local i, k, buf := save_maxrow(), name_file := "uslugiF"+stxt, sh := 85, HH := 80, mas1[5]
//
mywait()
arr_title := {;
"�������������������������������������������������������������������������������������",;
" ���� �����        � ���� �� � ������������ ��㣨                                   ",;
"�������������������������������������������������������������������������������������"}
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string(center("���᮪ ��� ����� � ��襬 �ࠢ�筨��",sh))
add_string("")
aeval(arr_title, {|x| add_string(x) } )
use_base("luslf")
R_Use(dir_server+"mo_su",dir_server+"mo_sush1","MOSU")
go top
do while !eof()
  k := 1 ; afill(mas1,"")
  if mosu->tip == 5
    select LUSLF18
    find (mosu->shifr1)
    if found()
      k := perenos(mas1,"...㤠����..."+luslf18->name,55)
    endif
  else
    select LUSLF
    find (mosu->shifr1)
    if found()
      k := perenos(mas1,luslf->name,55)
    else
      select LUSLF18
      find (mosu->shifr1)
      if found()
        k := perenos(mas1,"...㤠����..."+luslf18->name,55)
      endif
    endif
  endif
  if verify_FF(HH-k+1,.t.,sh)
    aeval(arr_title, {|x| add_string(x) } )
  endif
  add_string(mosu->shifr1+mosu->shifr+mas1[1])
  for i := 2 to k
    add_string(space(30)+mas1[i])
  next
  select MOSU
  skip
enddo
close databases
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,5)
return NIL

***** 03.01.19
Function usl6FFOMS(lksg)
Local k, buf := save_maxrow(), name_file := "usl_ksg"+stxt, nu, sh := 80, HH := 78, ;
      t_arr, i, s, fl, v1, v2, mdate, fl1uslc, fl2uslc, ta[2], fl1del, fl2del, ret_arr
glob_otd_dep := 0
if is_otd_dep .and. lksg == 1 .and. (ret_arr := ret_otd_dep()) == NIL
  return NIL
endif
mywait()
dbcreate(cur_dir+"tmp",{;
   {"SHIFR",      "C",     10,      0},;
   {"NAME",       "C",    255,      0},;
   {"CENA_V",     "C",     10,      0},;
   {"CENA_D",     "C",     10,      0}})
use (cur_dir+"tmp") new
dbcreate(cur_dir+"tmp1",{;
   {"SHIFR",      "C",     10,      0},;
   {"SHIFR1",     "C",     20,      0}})
use (cur_dir+"tmp1") new
index on shifr1+shifr to (cur_dir+"tmp1")
mdate := sys_date
R_Use(exe_dir+"_mo9k006",,"K006")
index on SHIFR+SY to (cur_dir+"tmp_t009")
use_base("luslc")
use_base("lusl")
index on fsort_usl(shifr) to (cur_dir+"tmp_lusl") for is_ksg(shifr,lksg) .and. datebeg >= boy(mdate)
go top
do while !eof()
  v1 := fcena_oms(lusl->shifr,.t.,mdate,@fl1del,@fl1uslc)
  v2 := fcena_oms(lusl->shifr,.f.,mdate,@fl2del,@fl2uslc)
  if !(fl1del .and. fl2del)
    select TMP
    append blank
    tmp->SHIFR  := lusl->shifr
    tmp->NAME   := alltrim(lusl->name)
    tmp->CENA_V := iif(fl1del,"      -   ",str(v1,10,2))
    tmp->CENA_D := iif(fl2del,"      -   ",str(v2,10,2))
    select K006
    find (padr(lusl->shifr,10))
    do while (padr(lusl->shifr,10)) == k006->shifr .and. !eof()
      if !empty(k006->sy)
        select TMP1
        find (padr(k006->sy,20)+padr(lusl->shifr,10))
        if !found()
          append blank
          tmp1->SHIFR  := lusl->shifr
          tmp1->SHIFR1 := k006->sy
        endif
      endif
      select K006
      skip
    enddo
  endif
  select LUSL
  skip
enddo
delFRfiles()
dbcreate(fr_titl, {;
  {"mo","C",90,0},;
  {"str1","C",90,0},;
  {"str2","C",90,0};
 })
use (fr_titl) new alias FRT
append blank
frt->mo := glob_mo[_MO_SHORT_NAME]+iif(valtype(ret_arr)=="A", " ("+ret_arr[1]+")","")
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string(glob_mo[_MO_SHORT_NAME]+iif(valtype(ret_arr)=="A", " ("+ret_arr[1]+")",""))
add_string("")
s := "��㣨 ����� + ��� � "+iif(lksg==1,"��樮���","������� ��樮���")
frt->str1 := s
add_string(center(s,sh))
s := "[ 業� �� ���ﭨ� �� "+date_8(mdate)+"�. ]"
frt->str2 := s
add_string(center(s,sh))
add_string("")
dbcreate(fr_data,{{"SHIFR1","C", 20,0},;
                  {"NAME",  "C",255,0}})
use (fr_data) new alias _d
//
dbcreate(fr_data+'1',{{"SHIFR1","C", 20,0},;
                      {"SHIFR", "C", 10,0},;
                      {"NAME",  "C",255,0},;
                      {"CENA_V","C", 10,0},;
                      {"CENA_D","C", 10,0}})
use (fr_data+'1') new alias _d1
use_base("luslf")
old_shifr := space(20)
select TMP
index on shifr to (cur_dir+"tmp")
select TMP1
go top
do while !eof()
  if !(old_shifr == tmp1->shifr1)
    add_string(replicate("�",sh))
    select LUSLF
    find (tmp1->shifr1)
    k := perenos(ta,luslf->name,sh-15)
    for i := 1 to k
      verify_FF(HH,.t.,sh)
      add_string(iif(i==1,tmp1->shifr1,space(20))+ta[i])
    next
    add_string(replicate("-",sh))
    select _D
    append blank
    _d->shifr1 := tmp1->shifr1
    _d->name := luslf->name
  endif
  old_shifr := tmp1->shifr1
  select TMP
  find (tmp1->shifr)
  k := perenos(ta,alltrim(tmp->name),45)
  for i := 1 to k
    verify_FF(HH,.t.,sh)
    add_string(iif(i==1,padl(alltrim(tmp->shifr),19)+" ",space(20))+ta[i]+;
               iif(i==1,tmp->cena_v+tmp->cena_d,""))
  next
  select _D1
  append blank
  _d1->shifr1 := tmp1->shifr1
  _d1->shifr := tmp->shifr
  _d1->name := tmp->name
  _d1->cena_v := tmp->cena_v
  _d1->cena_d := tmp->cena_d
  select TMP1
  skip
enddo
select _d1
index on shifr1+shifr to (fr_data+'1')
close databases
rest_box(buf)
fclose(fp)
name_fr := "mo_v1ksg"+sfr3
if _upr_epson() .or. !file(dir_exe+name_fr)
  viewtext(name_file,,,,.t.,,,5)
else
  call_fr(name_fr,,,{|| FrPrn:SetMasterDetail("_data","_data1",{|| _data->shifr1 }) })
endif
return NIL

***** 03.01.19
Function usl11FFOMS()
Local buf := save_maxrow(), name_file := "vidVMP"+stxt, sh := 80, HH := 60, t_arr[2], i, j, k
mywait()
make_V018_V019(0d20190101)
fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
add_string("")
add_string(center("�����䨪��� ����� ���",sh))
add_string("")
for j := 1 to len(glob_V018)
  k := perenos(t_arr,glob_V018[j,2],67)
  verify_FF(HH-k+1,.t.,sh)
  add_string(padr(glob_V018[j,1],13)+t_arr[1])
  for i := 2 to k
    add_string(space(13)+t_arr[i])
  next
next
rest_box(buf)
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 19.01.18
Function usl12FFOMS()
Static sast, sarr
Local buf := save_maxrow(), name_file := "metodVMP"+stxt, sh := 80, HH := 60, t_arr[2], a, i, j, k, n, s
make_V018_V019(0d20190101)
if sast == NIL
  sast := {} ; sarr := {}
  for j := 1 to len(glob_V018)
    aadd(sast,.t.)
    aadd(sarr,{padr(glob_V018[j,1],13)+left(glob_V018[j,2],67),glob_V018[j,1]})
  next
endif
if (a := bit_popup(T_ROW,T_COL-5,sarr,sast)) != NIL
  afill(sast,.f.)
  for i := 1 to len(a)
    if (j := ascan(sarr,{|x| x[2]==a[i,2] })) > 0
      sast[j] := .t.
    endif
  next
  mywait()
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  add_string("")
  add_string(center("�����䨪��� ��⮤�� ���",sh))
  add_string("")
  for n := 1 to len(a)
    if (j := ascan(glob_V018, {|x| x[1] == a[n,2] })) > 0
      k := perenos(t_arr,glob_V018[j,2],67)
      verify_FF(HH-k+3,.t.,sh)
      add_string(replicate("-",sh))
      add_string(padr(glob_V018[j,1],13)+t_arr[1])
      for i := 2 to k
        add_string(space(13)+t_arr[i])
      next
      add_string(replicate("-",sh))
      for l := 1 to len(glob_V019)
        if glob_V019[l,4] == glob_V018[j,1]
          s := glob_V019[l,2]+" (�������"+iif(len(glob_V019[l,3]) > 1, "�", "")+;
               " "+print_array(glob_V019[l,3])+")"
          k := perenos(t_arr,s,66)
          verify_FF(HH-k+1,.t.,sh)
          add_string(str(glob_V019[l,1],13)+" "+t_arr[1])
          for i := 2 to k
            add_string(space(14)+t_arr[i])
          next
        endif
      next
    endif
  next
  rest_box(buf)
  fclose(fp)
  viewtext(name_file,,,,.t.,,,2)
endif
return NIL

*****
Function spr_other()
Local mas_pmt, mas_msg, mas_fun, j, r, c := T_COL-5
mas_pmt := {"~��稥 �࣠����樨",;
            "~������� (��)",;
            "~��㦡�",;
            "~��㣨 ��� �㦡�";
           }
mas_msg := {"��稥 �࣠����樨",;
            "������� �� ��ࠢ���࠭���� (��)",;
            "���᮪ �㦡 � ������������ �ᯥ�⪨ ��� �� �����⭮� �㦡�",;
            "��ᯥ�⪠ ���, � ������ �� ���⠢���� �㦡�";
           }
mas_fun := {"f1spr_other(1)",;
            "f1spr_other(2)",;
            "f1spr_other(3)",;
            "f1spr_other(4)"}
if (r := T_ROW-len(mas_pmt)-3) < 0
  r := 2 ; c := T_COL+10
endif
popup_prompt(r,c,1,mas_pmt,mas_msg,mas_fun)
return NIL

*****
Function f1spr_other(k)
Local buf := save_maxrow(), mas1 := {}, mas2
do case
  case k == 1
    popup_edit(dir_server+"str_komp",T_ROW,T_COL-5,T_ROW+8,,PE_VIEW,,,,{||!between(tfoms,44,47)})
  case k == 2
    popup_edit(dir_server+"komitet",T_ROW,T_COL-5,T_ROW+8,,PE_VIEW)
  case k == 3
    if R_Use(dir_server+"slugba",dir_server+"slugba","SL")
      go top
      do while Alpha_Browse(T_ROW,T_COL-5,maxrow()-2,T_COL+45,"f2spr_other",color0)
        f3spr_other(1)
      enddo
    endif
  case k == 4
    f3spr_other(2)
endcase
close databases
rest_box(buf)
return NIL

*****
Function f2spr_other(oBrow)
oBrow:addColumn(TBColumnNew("����", {|| sl->shifr }) )
oBrow:addColumn(TBColumnNew(center("������������ �㦡�",40), {|| sl->name }) )
status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮� �㦡�")
return NIL

*****
Static Function f3spr_other(reg)
Local buf := save_maxrow(), n_file := "uslugi"+stxt, sh := 80, HH := 60, l, k,;
      mas[2]
mywait()
fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
add_string("")
if mem_trudoem == 2
  Private arr_title := {space(sh-15)+"��� "+iif(is_oplata==7,"��.","���")+"���� "+iif(is_oplata==7,"���","���"),;
                        space(sh-15)+"���������������"}
  useUch_Usl()
  l := sh-16
else
  l := sh
endif
Use_base("lusl")
Use_base("luslc")
R_Use(dir_server+"uslugi",dir_server+"uslugisl","USL")
if reg == 1
  add_string(CENTER("���᮪ ��� �� �㦡�:",80))
  add_string(CENTER(lstr(sl->shifr)+". "+alltrim(sl->name),80))
  find (str(sl->shifr,3))
  index on fsort_usl(shifr) to (cur_dir+"tmp") for kod > 0 while slugba == sl->shifr
else
  add_string(CENTER("���᮪ ��� � �����⠢������ �㦡��",80))
  index on fsort_usl(shifr) to (cur_dir+"tmp") for f5spr_other()
endif
add_string("")
if mem_trudoem == 2
  aeval(arr_title, {|x| add_string(x) } )
endif
go top
do while !eof()
  lshifr := ""
  if !empty(usl->shifr)
    s := usl->shifr
    lshifr += alltrim(usl->shifr)
    lshifr1 := opr_shifr_TFOMS(usl->shifr1,usl->kod)
    if !empty(lshifr1) .and. !(usl->shifr==lshifr1)
      s := lshifr1
      lshifr += "("+alltrim(lshifr1)+")"
    endif
    lshifr += "."
    s := f42_uslugi(1,s)
    s1 := f42_uslugi(23)
    if !emptyall(s,s1) .or. usl->is_nul
      if mem_trudoem == 2
        if verify_FF(HH, .t., sh)
          aeval(arr_title, {|x| add_string(x) } )
        endif
      else
        verify_FF(HH, .t., sh)
      endif
      if empty(s)
        s := s1
      elseif !empty(s1)
        s += ";"+s1
      endif
      k := perenos(mas,lshifr+alltrim(usl->name)+" ["+s+"]",l," ,;")
      s := padr(mas[1],l)
      if mem_trudoem == 2
        select UU
        find (str(usl->kod,4))
        if is_oplata == 7
          s += put_val_0(uu->vkoef_v,8,4)+put_val_0(uu->akoef_v,8,4)
        else
          s += put_val_0(uu->koef_v,8,4)+put_val_0(uu->koef_r,8,4)
        endif
      endif
      add_string(s)
      if k > 1
        add_string(padl(alltrim(mas[2]),l))
      endif
    endif
  endif
  select USL
  skip
enddo
luslc->(dbCloseArea())
luslc18->(dbCloseArea())
lusl->(dbCloseArea())
lusl18->(dbCloseArea())
usl->(dbCloseArea())
if mem_trudoem == 2
  uu->(dbCloseArea())
  uu1->(dbCloseArea())
endif
if reg == 1
  select SL
endif
fclose(fp)
viewtext(n_file,,,,,,,2)
rest_box(buf)
return NIL

*****
Function f5spr_other()
Local fl := !empty(shifr)
if fl
  fl := is_nul .or. !emptyall(cena,cena_d)
endif
if fl
  fl := (slugba <= 0)
endif
return fl

*

***** ᯨ᮪ ���ᮭ���
Function spr_personal()
Local k, sh := 80, HH := 57, fl := .t., s
mywait()
fp := fcreate("spisok"+stxt) ; n_list := 1 ; tek_stroke := 0
add_string("")
add_string(center("������ ��⠢ ���ᮭ��� � ⠡���묨 ����ࠬ�",sh))
add_string("")
add_string(center(alltrim(glob_uch[2])+" ("+alltrim(glob_otd[2])+")",sh))
add_string(padl(date_8(sys_date)+"�.",sh))
if R_Use(dir_server+"mo_pers",,"PERSO")
  index on upper(fio) to (cur_dir+"tmp_pers") for kod > 0
  do while !eof()
    if fl .or. tek_stroke > HH
      if !fl
        add_string(chr(12))
        tek_stroke := 0
        n_list++
        next_list(sh)
      endif
      add_string("�������������������������������������������������������������������������������")
      add_string("���.��                       �.�.�.                     � ���樠�쭮���        ")
      add_string("�������������������������������������������������������������������������������")
    endif
    fl := .f.
    s := put_val(perso->tab_nom,5)+;
         iif(empty(perso->svod_nom), space(7), padl("("+lstr(perso->svod_nom)+")",7))+;
         " "+alltrim(perso->fio)
    if !emptyall(perso->prvs,perso->prvs_new)
      s += " ("+ret_tmp_prvs(perso->prvs,perso->prvs_new)+")"
    endif
    add_string(s)
    select PERSO
    skip
  enddo
endif
close databases
fclose(fp)
viewtext("spisok"+stxt,,,,,,,2)
return NIL

*

***** ᯨ᮪ �⤥����� � ������
Function spr_kod_otd()
Local sh := 64, HH := 57, buf := save_maxrow(), n_file := "kod_otd"+stxt
mywait()
Private t_arr := {}, count_uch := 0
R_Use(dir_server+"mo_uch",,"UCH")
dbeval({|| count_uch++, aadd(t_arr,{kod,alltrim(name)}) } )
if count_uch == 0
  func_error(4,"���� ��०����� ����!")
else
  R_Use(dir_server+"mo_otd",,"OTD")
  index on str(kod_lpu,3)+upper(name) to (cur_dir+"tmp_otd") for !empty(name)
  fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
  add_string("")
  add_string(center(expand("���� ���������"),sh))
  add_string("")
  select UCH
  index on upper(name) to (cur_dir+"tmp_uch") for !empty(name)
  go top
  do while !eof()
    add_string("")
    add_string(upper(uch->name))
    select OTD
    find (str(uch->kod,3))
    do while otd->kod_lpu == uch->kod
      add_string(str(otd->kod,14)+"   "+otd->name)
      select OTD
      skip
    enddo
    select UCH
    skip
  enddo
endif
close databases
fclose(fp)
rest_box(buf)
viewtext(n_file)
return NIL

*

***** ��ᬮ��/����� �ࠢ�筨�� ���������
Function spr_info_diagn(k)
Static sk := 1
Local str_sem, mas_pmt, mas_msg, mas_fun, j
DEFAULT k TO 0
do case
  case k == 0
    mas_pmt := {"~������� ���-10",;
                "~��㯯� (������)",;
                "~�����㯯�",;
                "��~��� �� ��㯯��",;
                "���~��� �� �����㯯��"}
    mas_msg := {"��ᬮ�� �ࠢ�筨�� ���-10 (���� �� ���� ��� ������������)",;
                "��ᬮ�� �ࠢ�筨�� ��㯯 ��������� (����ᮢ)",;
                "��ᬮ�� �ࠢ�筨�� �����㯯 ���������",;
                "����� �ࠢ�筨�� ���-10 �� ��㯯��",;
                "����� �ࠢ�筨�� ���-10 �� �����㯯��"}
    mas_fun := {"spr_info_diagn(1)",;
                "spr_info_diagn(2)",;
                "spr_info_diagn(3)",;
                "spr_info_diagn(4)",;
                "spr_info_diagn(5)"}
    popup_prompt(T_ROW, T_COL-5, sk, mas_pmt, mas_msg, mas_fun)
  case k > 0
    f_10diag_bay(k)
endcase
if k > 0
  sk := k
endif
return NIL

*

*****
Function f_10diag(k)
Local buf := savescreen(), i := 1, c1 := 1, c2 := 77, msh_b, msh_e, arr_t, s, s1
Private pregim := k, uregim := 1
change_attr()
do case
  case k == 1
    mywait()
    R_Use(dir_exe+"_mo_mkb",cur_dir+"_mo_mkb","DIAG")
    go top
    Alpha_Browse(2,c1,maxrow()-2,c2,"f1_10diag",color0,,,.t.,,,,"f2_10diag",,;
                 {,,,"N/BG,W+/N,B/BG,BG+/B,GR/BG,BG+/GR",.t.} )
  case k == 2
    R_Use(dir_exe+"_mo_mkbk")
    index on sh_b+str(ks,1) to (cur_dir+"tmp")
    go top
    Alpha_Browse(2,0,maxrow()-2,79,"f1_10diag",color0,,,.t.,,,,,,;
                 {'�','�','�',"N/BG,W+/N,B/BG,BG+/B"})
  case k == 3
    R_Use(dir_exe+"_mo_mkbg")
    index on sh_b+str(ks,1) to (cur_dir+"tmp")
    go top
    Alpha_Browse(2,c1,maxrow()-2,c2,"f1_10diag",color0,,,.t.,,,,,,;
                 {'�','�','�',"N/BG,W+/N,B/BG,BG+/B"})
  case k == 4 .or. k == 5
    R_Use(dir_exe+"_mo_mkb"+iif(pregim==4,"k","g"))
    index on sh_b+str(ks,1) to (cur_dir+"tmp_d")
    Use
    do while .t.
      R_Use(dir_exe+"_mo_mkb"+iif(pregim==4,"k","g"))
      set index to "tmp_d"
      goto (i)
      if pregim == 4
        c1 := 0 ; c2 := 79
      endif
      if Alpha_Browse(2,c1,maxrow()-2,c2,"f1_10diag",color0,,,.t.,,,,,,;
                      {'�','�','�',"N/BG,W+/N,B/BG,BG+/B"})
        mywait()
        arr_t := {}
        do while ks > 0
          skip -1
        enddo
        i := recno()
        if pregim == 4
          aadd(arr_t, "����� "+alltrim(klass))
        endif
        msh_b := sh_b ; msh_e := sh_e
        do while sh_e == msh_e
          aadd(arr_t, alltrim(name))
          skip
        enddo
        Use
        if msh_b == msh_e
          aadd(arr_t, "( "+alltrim(msh_b)+" )")
        else
          aadd(arr_t, "( "+alltrim(msh_b)+" - "+alltrim(msh_e)+" )")
        endif
        Private sh := 76, HH := 77
        fp := fcreate("diagtmp.txt") ; n_list := 1 ; tek_stroke := 0
        add_string("")
        R_Use(dir_exe+"_mo_mkb",cur_dir+"_mo_mkb","DIAG")
        for k := 1 to len(arr_t)
          add_string(center(arr_t[k],sh))
        next
        add_string("")
        add_string(center('[ ������ "-" ��। ��஬ �⬥祭� ��������, �� �室�騥 � ��� ]',sh))
        add_string("")
        find (padr(msh_b,5))
        do while left(shifr,3) <= msh_e .and. !eof()
          if ks == 0
            verify_FF(HH,.t.,sh)
          endif
          if !("." $ shifr) .and. ks == 0
            add_string("")
          endif
          s1 := iif(ks==0 .and. !empty(diag->pol),;
                      iif(diag->pol=="�","<��.>","<���.>"), space(6))
          s := iif("." $ shifr, s1, "")
          s += iif(ks==0 .and. !between_date(diag->dbegin,diag->dend) , "-", " ")
          s += padr(if(ks == 0, shifr, ""), 6)
          s += " "+rtrim(name)
          add_string(s)
          skip
        enddo
        close databases
        fclose(fp)
        viewtext("diagtmp.txt",,,,,,,5)
      else
        exit
      endif
    enddo
endcase
close databases
restscreen(buf)
return NIL

*****
Function f1_10diag(oBrow)
Local oColumn, blk, n := 65
if pregim == 1
  blk := {|| iif(!between_date(diag->dbegin,diag->dend), {3,4}, iif(!empty(diag->pol), {5,6}, {1,2})) }
  oColumn := TBColumnNew("����",{|| padr(if(ks==0,shifr+diag->pol,""),7) })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew(center("������������ ��������� �����������",n),{||name})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  if uregim > 0
    status_key("^<Esc>^ - ��室;  ^<F2>^ - ���� �� ����;  ^<F3>^ - ���� �� �����ப�"+;
                              if(uregim==1,"",";  ^<Enter>^ - �롮�"))
  endif
else
  if equalany(pregim,2,4)
    oColumn := TBColumnNew("�����",{||if(ks==0,klass,"    ")})
    oColumn:colorBlock := blk
    oBrow:addColumn(oColumn)
    n := 64
  endif
  oColumn := TBColumnNew("",{||if(ks==0,sh_b,"    ")})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew("",{||if(ks==0,sh_e,"    ")})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew(center("������������ "+;
       if(pregim==2.or.pregim==4,"","���")+"��㯯� �����������",n),{||left(name,n)})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  if uregim > 0
    if equalany(pregim,4,5)
      status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮� "+;
                      if(pregim==4,"","���")+"��㯯� ��� ����")
    else
      status_key("^^ - ��ᬮ��;  ^<Esc>^ - ��室"+;
                              if(uregim==1,"",";  ^<Enter>^ - �롮�"))
    endif
  endif
endif
return NIL

*****
Function f2_10diag(nKey,oBrow)
Static sshifr := "     ", sname := ""
Local buf, buf24, fl := .f., s, rec, k := -1, bg := {|o,k| get_MKB10(o,k) }
do case
  case nKey == K_F2
    buf := save_box(18,0,24,79)
    Private mshifr := sshifr
    box_shadow(18,20,20,59,color8)
    @ 19,32 say "������ ���" color color1 ;
                get mshifr PICTURE "@K@!" ;
                reader {|o| MyGetReader(o,bg) } ;
                valid val1_10diag(.f.) color color1
    status_key("^<Esc>^ - �⪠� �� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread({"confirm"})
    if lastkey() != K_ESC .and. !empty(mshifr)
      rec := recno()
      find (rtrim(mshifr))
      if found()
        sshifr := mshifr
        k := 0
      else
        goto rec
        func_error(4,"������� � ⠪�� ��஬ �� ������!")
      endif
    endif
    rest_box(buf)
    if k == 0
      oBrow:goTop()
      find (rtrim(mshifr))
    endif
  case nKey == K_F3
    Private mname := padr(alltrim(sname),30)
    if (mname := input_value(18,4,20,75,color8,;
                  "������ �����ப� �������� ��� ���᪠",;
                  mname,"@K@!")) != NIL .and. !empty(mname)
      mname := alltrim(mname)
      rec := recno()
      //
      Private i := j := 0, lshifr := "", lname := "",;
              tmp_mas := {}, tmp_kod := {}, t_len
      hGauge := GaugeNew(,,{color8,color1,"G+/B"},;
                         "���� �����ப� <."+mname+".>",.t.)
      GaugeDisplay( hGauge )
      buf24 := save_maxrow()
      s := "^<Esc>^ - ��ࢠ�� ����"
      status_key(s) ; s += ".   ������� ��������� -"
      go top
      do while !eof()
        GaugeUpdate( hGauge, ++j/lastrec() )
        if inkey() == K_ESC
          exit
        endif
        if FIELD->ks == 0
          if !empty(lname) // �஢���� �।����� ������
            if mname $ upper(lname)
              if ++i > 4000 ; exit ; endif
              aadd(tmp_mas, lshifr+" "+lname)
              aadd(tmp_kod, lshifr)
              status_key(s+"^ "+lstr(i)+".^")
            endif
          endif
          lshifr := FIElD->shifr ; lname := ""
        endif
        lname += alltrim(FIELD->name)+" "
        skip
      enddo
      if !empty(lname) .and. mname $ upper(lname)
        aadd(tmp_mas, lshifr+" "+lname)
        aadd(tmp_kod, lshifr)
      endif
      CloseGauge(hGauge)
      goto rec
      rest_box(buf24)
      //
      if (t_len := len(tmp_kod)) = 0
        func_error(3,"��㤠�� ����!")
      else
        sname := mname
        Private r1 := 2, c1 := 1, r2 := maxrow()-2, c2 := 77
        Private k1 := r1+3, k2 := r2-1
        buf := box_shadow(r1,c1,r2,c2,color0)
        buf24 := save_maxrow()
        @ r1+1,c1+1 say "�����ப�: "+mname color "B/BG"
        SETCOLOR(color0)
        if t_len < k2-k1-1
          k2 := k1 + t_len + 2
        endif
        @ k1,c1+1 say padc("���-�� ��������� ��ப - "+lstr(t_len),c2-c1-1)
        i := ascan(tmp_kod, sshifr)
        status_key("^<Esc>^ - �⪠� �� �롮�;  ^<Enter>^ - �롮�;  ^<F9>^ - �����")
        if (i := popup(k1+1,c1+1,k2,c2-1,tmp_mas,i,color0,.t.,"f3_10diag")) > 0
          sshifr := tmp_kod[i]
          k := 0
        endif
        rest_box(buf)
        rest_box(buf24)
      endif
      //
    endif
    if k == 0
      oBrow:goTop()
      find (sshifr)
    endif
endcase
return k

*****
Function f3_10diag(nKey,nInd)
Local rec, i
if nKey == K_F9
  rec := recno()
  Private sh := 76, HH := 77
  fp := fcreate("diagtmp.txt") ; n_list := 1 ; tek_stroke := 0
  add_string("")
  add_string(center("������� ���᪠ �� �����ப�: "+mname,sh))
  add_string("")
  for i := 1 to len(parr)
    find (left(parr[i],6))
    do while shifr == left(parr[i],6) .and. !eof()
      if ks == 0
        verify_FF(HH,.t.,sh)
      endif
      s := padr(if(ks == 0, shifr, ""), 7)
      s += " "+rtrim(name)
      add_string(s)
      skip
    enddo
  next
  fclose(fp)
  viewtext("diagtmp.txt",,,,,,,5)
  goto (rec)
endif
return -1

*

*****
Function f10_diagnoz()
Static srec
Local buf := savescreen(), c1 := 1, c2 := 77, tmp_select := select()
Private pregim := 1, uregim := 1
change_attr()
mywait()
R_Use(dir_exe+"_mo_mkb",cur_dir+"_mo_mkb","DIAG")
go top
if srec != NIL
  goto (srec)
endif
Alpha_Browse(2,c1,maxrow()-2,c2,"f1_10diag",color0,,,.t.,,,,"f2_10diag",,;
             {,,,"N/BG,W+/N,B/BG,BG+/B",.t.} )
srec := diag->(recno())
diag->(dbCloseArea())
restscreen(buf)
if tmp_select > 0
  select (tmp_select)
endif
return NIL

*

*****
Function diag_to_num(lshifr,j)
Local s, c5, c6, i, l, lnum := 0
lshifr := alltrim(lshifr)
if (l := len(lshifr)) > 0
  c5 := c6 := {"0","9"}[j]  // �� ���� 0 - ��� ��砫� ���ࢠ��, 9 - ��� ����
  if l > 3
    if l >= 5
      c5 := substr(lshifr,5,1)
    endif
    if l == 6
      c6 := right(lshifr,1)
    endif
    // �� ��直� ��砩
    lshifr := padr(lshifr,3,"0") ; l := 3
  endif
  lshifr += c5+c6 ; l := len(lshifr)
  // ���� ᨬ��� �㪢�, ��⠫�� - ����
  s := lstr(asc(left(lshifr,1)))
  for i := 2 to l
    s += substr(lshifr,i,1)
  next
  lnum := int(val(s))
endif
return lnum

*

***** 09.12.18 ���樠����஢��� �� mem (public) - ��६����
Function init_all_mem_public()
// ����ࠨ����� �� ��� �����
Public mem_smp_input := 0
Public mem_smp_tel := 0
Public mem_dom_aktiv := 0
Public mem_beg_rees := 1
Public mem_end_rees := 999999
Public mem_bnn_rees := 1
Public mem_enn_rees := 99
Public mem_bnn13rees := -1
Public mem_enn13rees := -1
Public okato_umolch := "18401395000"
Public public_date := ctod("") // ���a, �� ������ (�����⥫쭮) ����饭� ।���஢��� �����
Public mem_kart_error := 0  // 1 - ࠧ���� ������������ ��⠭�������� ����� ���㫠�୮� �����
Public mem_kodkrt  := 1     // 2 - �᫨ ���� ॣ�������???
Public mem_trudoem := 1
Public mem_tr_plan := 2     // ��
Public mem_sound   := 2     // ��
Public mem_pol     := 1
Public mem_diag4   := 2     // ��
Public mem_diagno  := 2     // ��
Public mem_kodotd  := 1
Public mem_otdusl  := 1
Public mem_ordusl  := 1
Public mem_ordu_1  := 2     // ��
Public mem_kat_va  := 2     // ��
Public mem_vv_v_a  := 2
Public mem_por_vr  := 1
Public mem_por_ass := 2
Public mem_por_kol := 3
Public mem_date_1  := ctod("")
Public mem_date_2  := ctod("")
Public yes_many_uch := .f.  // �롮� �⤥����� ⮫쪮 �� "᢮���" ��०�����
Public mem_ff_lu := 1
// ���� �����
Public pp_NOVOR     := 1  // ������� ����஦�������
Public pp_KEM_NAPR  := "" // ᯨ᮪ �������� ��� ���������� ���ࠢ����� ���
Public pp_POB_D_LEK := 1  // ������� ����筮� ����⢨� �������
Public pp_KOD_VR    := 1  // ������� ���� ��� ��񬭮�� �⤥�����
Public pp_TRAVMA    := 1  // ������� ��� �ࠢ��
Public pp_NE_ZAK    := 1  // ����� �����, �᫨ �� �� �����稫 ��祭�� �� �।��饬� ����
// ���
Public mem_KEM_NAPR := "" // ᯨ᮪ �������� ��� ���������� ���ࠢ����� ���
Public mem_edit_ist := 2
Public mem_e_istbol := 1
Public mem_op_out  := 1    // ���
Public mem_st_kat  := 1
Public mem_st_pov  := 1
Public mem_st_trav := 1
Public mem_zav_l   := 3     // ���������� �।��騩
Public mem_pom_va   := 1    // ���
Public mem_coplec   := 1    // ���
Public mem_dni_vr  := 365  // ��� ᮢ���⨬��� - �� �࠭��
Public is_uchastok := 0
Public is_oplata := 5       // ᯮᮡ ������
Public yes_h_otd := 1
Public yes_vypisan := B_STANDART // ��� B_END  �� ࠡ�� � "�����襭��� ��祭��"
Public yes_num_lu := 0      // =1 - ����� �/� ࠢ�� ������ �����
Public yes_d_plus := "+-"   // �� 㬮�砭�� ��᫥ ��������
Public yes_bukva := .f.     // �᫨ ࠧ�蠥��� ���� �㪢
Public is_zf_stomat := 0    // �㡭�� ��㫠 = ���
Public mem_ls_parakl := 0   // ������� ����������� � �㬬� ������� ���
Public is_0_schet := 0
Public pp_OMS := .t.    // �����뢠�� �� ��񬭮�� ����� �/� � ������ ���
Public pp_date_OMS      // � ����� ����
// ��� ����� "����� ��㣨" � "���-����"
Public delta_chek := 0  // ������� �� "lpu.ini"-䠩��
// ��� ����� "����� ��㣨"
Public mem_anonim := 0  // ࠡ���� � ���������
Public glob_pl_reg := 0 // ��� ����.������, 1 - ����
Public glob_close := 0  // �����⨥ �/���: ����� � �/���� ������, ��� �� �����
Public glob_kassa := 0  // ��� ���ᮢ��� ������, 1 - ���ᮢ� ������: ����-��-�
Public mem_naprvr  := 2  // ��� ������ ���
Public mem_plsoput := 1  // ��� ������ ���
Public mem_dogovor := "_DOGOVOR.SHB"  // ��� ������ ���
Public mem_pl_ms   := 0  // ��� ������ ���
Public mem_pl_sn   := 0  // ��� ������ ���
Public mem_edit_s  := 2
// ��� ����� "��⮯����"
Public mem_ort_na  := space(10) // ��⮯����
Public mem_ort_sl  := space(10) // ��⮯����
Public mem_ort_ysl := 1     // ��� // ��⮯����
Public mem_ortotd  := 0            // ��⮯����
Public mem_ortot1  := 1            // ��⮯����
Public mem_ort_ms  := 2     // ��  // ��⮯����
Public mem_ort_bp  := "ZAKAZ_BP.SMY"// ��⮯����
Public mem_ort_pl  := "ZAKAZ_PL.SMY"// ��⮯����
Public mem_ort_dat := 1             // ��⮯����
Public mem_ort_f8  := "LIST_U_8.SHB" // ��⮯����
Public mem_ortfflu := 1              // ��⮯����
Public mem_ort_dog := space(3)   // ���७�� �����. ��⮯����
Public mem_ort_f39 := 0  // ࠡ���� � �ମ� 39

Public MUSIC_ON_OFF := (mem_sound == 2)

if (j := search_file("lpu"+sini,2)) != NIL
  /*i := GetIniVar( j, {{"kartoteka","uchastok",}} )
  if i[1] != NIL .and. eq_any(i[1],"1","2")
    is_uchastok := int(val(i[1]))
  endif
  i := GetIniVar( j, {{"diagnoz","bukva",}} )
  if i[1] != NIL
    yes_d_plus := i[1]
    for i := 1 to len(yes_d_plus)
      if asc(substr(yes_d_plus,i,1)) > 64
        yes_bukva := .t. ; exit
      endif
    next
  endif
  i := GetIniVar( j, {{"uslugi","oplata",}} )
  if i[1] != NIL
    is_oplata := int(val(i[1]))
    if !between(is_oplata,5,7)
      is_oplata := 5
    endif
  endif
  // ����蠥��� �믨�뢠�� ��� � �㫥��� �㬬�� (�� ��ࠪ������):
  i := GetIniVar( j, {{"uslugi","schet_nul",}} )
  if i[1] != NIL
    is_0_schet := int(val(i[1]))
    if !between(is_0_schet,0,1)
      is_0_schet := 0
    endif
  endif
  i := GetIniVar( j, {{"lechenie","human_otd",},;
                      {"lechenie","standart",},;
                      {"lechenie","many_uch",}} )
  if i[1] != NIL .and. i[1] == "2"
    yes_h_otd := 2        // ࠡ�⠥� ��� �롮� �⤥�����
  endif
  if i[2] != NIL .and. i[2] == "2"
    yes_vypisan := B_END  // ��⠭������ ����� "�����襭�� ��祭��"
  endif
  if i[3] != NIL .and. i[3] == "2"
    yes_many_uch := .t.  // �롮� �⤥����� �� ��� ����㯭�� ��०�����
  endif
  //
  i := GetIniVar( j, {{"list_uch","nomer",}} )
  if i[1] != NIL
    if upper(i[1]) == "RECNO"
      yes_num_lu := 1  // ����� �/� ࠢ�� ������ �����
    endif
  endif
  // ��� ����� "����� ��㣨"
  i := GetIniVar( j, {{"lpu_plat","regi_plat",},;
                      {"lpu_plat","close",},;
                      {"lpu_plat","kassa",}} )
  if i[1] != NIL .and. i[1] == "1"
    glob_pl_reg := 1  // ������ ���⠭樮���� ������ � ����� "����� ��㣨"
  endif
  if i[2] != NIL .and. i[1] == "1"
    glob_close := 1  // �����⨥ ���� ��� - ������
  endif
  if i[3] != NIL .and. eq_any(i[3],"elves","fr")
    glob_kassa := 1   // ���ᮢ� ������: ����-��-�
    glob_pl_reg := 0  // 㡨ࠥ� ���⠭樮���� ������
  endif*/
  // ��� ����� "����� ��㣨" � "���-����"
  i := GetIniVar( j, {{"kassa","delta_chek",}} )
  if i[1] != NIL
    delta_chek := int(val(i[1]))
  endif
endif
//
if (j := search_file("lpu_stom"+sini)) != NIL
  k := GetIniSect( j, "��⥣���" )
  if !empty(k)
    stm_kategor2 := {}
    for i := 1 to len(k)
      aadd(stm_kategor2, { k[i,1], int(val(k[i,2])) } )
    next
  endif
  k := GetIniSect( j, "�����" )
  if !empty(k)
    stm_povod := {}
    for i := 1 to len(k)
      aadd(stm_povod, { k[i,1], int(val(k[i,2])) } )
    next
  endif
  k := GetIniSect( j, "�ࠢ��" )
  if !empty(k)
    stm_travma := {}
    for i := 1 to len(k)
      aadd(stm_travma, { k[i,1], int(val(k[i,2])) } )
    next
  endif
endif
//
Public dlo_version := 4
Public is_r_mu := .f.
Public gpath_reg := "" // ���� � 䠩��� R_MU.DBF
return NIL

  

***** 24.02.19 㤠���� ���(�) �� ������ ॥���� �� � �� � �� �⨬ ��� ᮧ���� ������ ��� (�.�.��㣮� ���-�� ��⮢)
Function ReCreate_some_Schet_From_FILE_SP(arr)
Local arr_XML_info[8], cFile, arr_f, k, n, oXmlDoc, aerr := {}, t_arr[2],;
      i, s, rec_schet, rec_schet_xml, go_to_schet := .f., arr_schet := {}
Private name_schet, _date_schet, mXML_REESTR
for i := 1 to len(arr)
  select SCHET
  goto (arr[i])
  if emptyany(schet_->name_xml,schet_->kod_xml) .or. schet_->IS_MODERN == 1
    return func_error(4,"�����४⭮ ��������� ���� ���� "+rtrim(schet_->nschet)+". ������ ����饭�.")
  endif
  if i == 1
    mXML_REESTR := schet_->XML_REESTR // ��뫪� �� ॥��� �� � ��
  elseif mXML_REESTR != schet_->XML_REESTR
    return func_error(4,"���� "+rtrim(schet_->nschet)+" �� ��㣮�� ॥��� �� � ��. ������ ����饭�.")
  endif
  aadd(arr_schet, {;
    arr[i],;                  // 1 - schet->(recno())
    schet_->kod_xml,;         // 2 - ��뫪� �� 䠩� "mo_xml"
    schet_->name_xml,;        // 3 - ��� XML-䠩�� ��� ���७�� (� ZIP-��娢�)
    alltrim(schet_->nschet),; // 4 - ����� ���
    schet_->dschet ;          // 5 - ��� �ନ஢���� ���
   })
next
//
mo_xml->(dbGoto(mXML_REESTR))
if empty(mo_xml->REESTR)
  return func_error(4,"��������� ��뫪� �� ��ࢨ�� ॥���! ������ ����饭�.")
endif
Private cReadFile := alltrim(mo_xml->FNAME) // ��� 䠩�� ॥��� �� � ��
Private cFileProtokol := cReadFile+stxt     // ��� 䠩�� ��⮪��� �⥭�� ॥��� �� � ��
Private mkod_reestr := mo_xml->REESTR       // ��� ��ࢨ筮�� ॥���
Private cTimeBegin := hour_min(seconds())
Private name_zip := cReadFile+szip          // ��� ��娢� 䠩�� ॥��� �� � ��
cFile := cReadFile+sxml                     // ��� XML-䠩�� ॥��� �� � ��
//
rees->(dbGoto(mkod_reestr))
Private name_reestr := alltrim(rees->name_xml)+szip // ��� ��娢� 䠩�� ��ࢨ筮�� ॥���
// �ᯠ���뢠�� ��ࢨ�� ॥���
if (arr_f := Extract_Zip_XML(dir_server+dir_XML_MO+cslash,name_reestr)) == NIL
  return func_error(4,"�訡�� � �ᯠ����� ��娢� ॥��� "+name_reestr)
endif
// �ᯠ���뢠�� ॥��� �� � ��
if (arr_f := Extract_Zip_XML(dir_server+dir_XML_TF+cslash,name_zip)) == NIL
  return func_error(4,"�訡�� � �ᯠ����� ��娢� ॥��� �� � �� "+name_zip)
endif
if (n := ascan(arr_f,{|x| upper(Name_Without_Ext(x)) == upper(cReadFile)})) == 0
  return func_error(4,"� ��娢� "+name_zip+" ��� 䠩�� "+cReadFile+sxml)
endif
close databases
if G_SLock1Task(sem_task,sem_vagno) // ����� ����㯠 �ᥬ
  k := len(arr_schet)
  s := iif(k == 1, "���� ", lstr(k)+" ��⮢ ")
  if involved_password(3,arr_schet[1,4],"���ᮧ����� "+s+arr_schet[1,4]) ;
     .and. f_Esc_Enter("���ᮧ����� "+s) // .and. m_copy_DB_from_end(.t.) // १�ࢭ�� ����஢����
    Private fl_open := .t.
    index_base("schet") // ��� ��⠢����� ��⮢
    index_base("human") // ��� ࠧ��᪨ ��⮢
    index_base("human_3") // ������ ��砨
    use (dir_server+"human_u") new READONLY
    index on str(kod,7)+date_u to (dir_server+"human_u") progress
    use
    Use (dir_server+"mo_hu") new READONLY
    index on str(kod,7)+date_u to (dir_server+"mo_hu") progress
    Use
    index_base("mo_refr")  // ��� ����� ��稭 �⪠���
    //
    mywait()
    strfile(hb_eol()+;
            space(10)+"����ୠ� ��ࠡ�⪠ 䠩��: "+cFile+;
            hb_eol(),cFileProtokol)
    strfile(space(10)+full_date(sys_date)+"�. "+cTimeBegin+;
            hb_eol(),cFileProtokol,.t.)
    mywait("�ந�������� ������ 䠩�� "+cFile)
    // �⠥� 䠩� � ������
    oXmlDoc := HXMLDoc():Read(_tmp_dir1+cFile)
    if oXmlDoc == NIL .or. empty( oXmlDoc:aItems )
      aadd(aerr,"�訡�� � �⥭�� 䠩�� "+cFile)
    else
      reestr_sp_tk_tmpfile(oXmlDoc,aerr,cReadFile)
    endif
    if empty(aerr)
      R_Use(dir_server+"mo_rees",,"REES")
      goto (mkod_reestr)
      if !extract_reestr(rees->(recno()),rees->name_xml)
        aadd(aerr,center("�� ������ ZIP-��娢 � �������� � "+lstr(mnschet)+" �� "+date_8(tmp1->_DSCHET),80))
        aadd(aerr,"")
        aadd(aerr,center(dir_server+dir_XML_MO+cslash+alltrim(rees->name_xml)+szip,80))
        aadd(aerr,"")
        aadd(aerr,center("��� ������� ��娢� ���쭥��� ࠡ�� ����������!",80))
      endif
    endif
    close databases
    if empty(aerr)
      dbcreate(cur_dir+"tmpsh",{{"kod_h","N",7,0}})
      use (cur_dir+"tmpsh") new
      R_Use(dir_server+"human",dir_server+"humans","HUMAN")
      for i := 1 to len(arr_schet)
        find (str(arr_schet[i,1],6))
        do while human->schet == arr_schet[i,1] .and. !eof()
          select tmpsh
          append blank
          replace kod_h with human->kod
          select HUMAN
          skip
        enddo
      next
      select tmpsh
      index on str(kod_h,7) to (cur_dir+"tmpsh")
      R_Use(dir_server+"mo_rhum",,"RHUM")
      index on str(REES_ZAP,6) to (cur_dir+"tmp_rhum") for reestr == mkod_reestr
      // ������ �ᯠ������� ॥���
      use (cur_dir+"tmp_r_t1") new alias T1
      index on str(val(n_zap),6) to (cur_dir+"tmpt1")
      use (cur_dir+"tmp_r_t2") new alias T2
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt2")
      use (cur_dir+"tmp_r_t3") new alias T3
      index on upper(ID_PAC) to (cur_dir+"tmpt3")
      use (cur_dir+"tmp_r_t4") new alias T4
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt4")
      use (cur_dir+"tmp_r_t5") new alias T5
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt5")
      use (cur_dir+"tmp_r_t6") new alias T6
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt6")
      use (cur_dir+"tmp_r_t7") new alias T7
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt7")
      use (cur_dir+"tmp_r_t8") new alias T8
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt8")
      use (cur_dir+"tmp_r_t9") new alias T
      index on IDCASE+str(sluch,6) to (cur_dir+"tmpt9")
      use (cur_dir+"tmp_r_t10") new alias T10
      index on IDCASE+str(sluch,6)+regnum+code_sh+date_inj to (cur_dir+"tmpt10")
      use (cur_dir+"tmp_r_t11") new alias T11
      index on IDCASE to (cur_dir+"tmpt11")
      use (cur_dir+"tmp2file") new alias TMP2
      is_new_err := .f.  // �諨 �� �����-���� ��砨 � �訡�� (�.�. ���� �訡��)
      go top
      do while !eof()
        if tmp2->_OPLATA == 1
          select T1
          find (str(tmp2->_N_ZAP,6))
          if found()
            t1->VPOLIS := lstr(tmp2->_VPOLIS)
            t1->SPOLIS := tmp2->_SPOLIS
            t1->NPOLIS := tmp2->_NPOLIS
            t1->ENP    := tmp2->_ENP
            t1->SMO    := tmp2->_SMO
            t1->SMO_OK := tmp2->_SMO_OK
            t1->MO_PR  := tmp2->_MO_PR
          endif
        endif
        select RHUM
        find (str(tmp2->_N_ZAP,6))
        if found() .and. rhum->KOD_HUM > 0
          select tmpsh
          find (str(rhum->KOD_HUM,7))
          if found()
            tmp2->kod_human := rhum->KOD_HUM
            if tmp2->_OPLATA > 1
              is_new_err := .t. // �.�. � ����� ॥��� �� � �� 祫���� ��� � �訡�� (� ࠭�� ������� � ����)
            endif
          endif
        else
          aadd(aerr,"")
          aadd(aerr," - �� ������ ��樥�� � ����஬ ����� "+lstr(tmp2->_N_ZAP))
        endif
        select TMP2
        skip
      enddo
      select TMP2
      delete for kod_human == 0 // 㤠��� ��, �� �� �室�� � ��࠭�� ���
      pack
    endif
    close databases
    if empty(aerr) .and. is_new_err
      R_Use(dir_server+"mo_otd",,"OTD")
      G_Use(dir_server+"human_",,"HUMAN_")
      G_Use(dir_server+"human",{dir_server+"humann",dir_server+"humans"},"HUMAN")
      set order to 0 // ������� ������ ��� ४������樨 �� ��१���� ���
      set relation to recno() into HUMAN_, to otd into OTD
      G_Use(dir_server+"human_3",{dir_server+"human_3",dir_server+"human_32"},"HUMAN_3")
      G_Use(dir_server+"mo_rhum",,"RHUM")
      index on str(REES_ZAP,6) to (cur_dir+"tmp_rhum") for reestr == mkod_reestr
      G_Use(dir_server+"mo_refr",dir_server+"mo_refr","REFR")
      use (cur_dir+"tmp3file") new alias TMP3
      index on str(_n_zap,8) to (cur_dir+"tmp3")
      use (cur_dir+"tmp2file") new alias TMP2
      go top
      do while !eof()
        if tmp2->_OPLATA > 1 // 㤠�塞 �� ����, 㤠�塞 �� ॥���, ��ଫ塞 �訡��
          select RHUM
          find (str(tmp2->_N_ZAP,6))
          G_RLock(forever)
          rhum->OPLATA := tmp2->_OPLATA
          is_2 := 0
          select HUMAN
          goto (rhum->KOD_HUM)
          if eq_any(human->ishod,88,89)
            select HUMAN_3
            if human->ishod == 88
              set order to 1
              is_2 := 1
            else
              set order to 2
              is_2 := 2
            endif
            find (str(rhum->KOD_HUM,7))
            if found() // �᫨ ��諨 ������� ��砩
              select HUMAN
              if human->ishod == 88  // �᫨ ॥��� ��⠢��� �� 1-�� �����
                goto (human_3->kod2)  // ����� �� 2-��
              else
                goto (human_3->kod)   // ���� - �� 1-�
              endif
              human->(G_RLock(forever))
              human->schet := 0 ; human->tip_h := B_STANDART
              //
              human_->(G_RLock(forever))
              human_->OPLATA := tmp2->_OPLATA
              human_->REESTR := 0 // ���ࠢ����� �� ���쭥�襥 ।���஢����
              human_->ST_VERIFY := 0 // ᭮�� ��� �� �஢�७
              if human_->REES_NUM > 0
                human_->REES_NUM := human_->REES_NUM-1
              endif
              human_->REES_ZAP := 0
              if human_->schet_zap > 0
                if human_->SCHET_NUM > 0
                  human_->SCHET_NUM := human_->SCHET_NUM-1
                endif
                human_->schet_zap := 0
              endif
              //
              human_3->(G_RLock(forever))
              human_3->OPLATA := tmp2->_OPLATA
              human_3->schet := 0
              human_3->REESTR := 0
              if human_3->REES_NUM > 0
                human_3->REES_NUM := human_3->REES_NUM-1
              endif
              human_3->REES_ZAP := 0
              if human_3->SCHET_NUM > 0
                human_3->SCHET_NUM := human_3->SCHET_NUM - 1
              endif
              human_3->schet_zap := 0
            endif
          endif
          select HUMAN
          goto (rhum->KOD_HUM)
          G_RLock(forever)
          human->schet := 0 ; human->tip_h := B_STANDART
          human_->(G_RLock(forever))
          human_->OPLATA := tmp2->_OPLATA
          human_->REESTR := 0 // � ���ࠢ����� �� ���쭥�襥 ।���஢����
          human_->ST_VERIFY := 0 // ᭮�� ��� �� �஢�७
          if human_->REES_NUM > 0
            human_->REES_NUM := human_->REES_NUM-1
          endif
          human_->REES_ZAP := 0
          if human_->SCHET_NUM > 0
            human_->SCHET_NUM := human_->SCHET_NUM-1
          endif
          human_->schet_zap := 0
          //
          lal := "human"
          if is_2 > 0
            lal += "_3"
          endif
          strfile("!!! "+alltrim(human->fio)+", "+full_date(human->date_r)+;
                       iif(empty(otd->SHORT_NAME), "", " ["+alltrim(otd->SHORT_NAME)+"]")+;
                       " "+alltrim(human->KOD_DIAG)+;
                       " "+date_8(&lal.->n_data)+"-"+date_8(&lal.->k_data)+;
                       hb_eol(),cFileProtokol,.t.)
          select REFR
          do while .t.
            find (str(1,1)+str(mkod_reestr,6)+str(1,1)+str(rhum->KOD_HUM,8))
            if !found() ; exit ; endif
            DeleteRec(.t.)
          enddo
          select TMP3
          find (str(tmp2->_N_ZAP,8))
          do while tmp2->_N_ZAP == tmp3->_N_ZAP .and. !eof()
            select REFR
            AddRec(1)
            refr->TIPD := 1
            refr->KODD := mkod_reestr
            refr->TIPZ := 1
            refr->KODZ := rhum->KOD_HUM
            refr->IDENTITY := tmp2->_IDENTITY
            refr->REFREASON := tmp3->_REFREASON
            if empty(s := ret_t005(refr->REFREASON))
              s := lstr(refr->REFREASON)+" �������⭠� ��稭� �⪠��"
            endif
            k := perenos(t_arr,s,75)
            for i := 1 to k
              strfile(space(5)+t_arr[i]+hb_eol(),cFileProtokol,.t.)
            next
            select TMP3
            skip
          enddo
          if is_2 > 0
            strfile(space(5)+'- ࠧ���� ������� ��砩 � ०��� "���/������ ��砨/���������"'+;
                    hb_eol(),cFileProtokol,.t.)
            strfile(space(5)+'- ��।������ ����� �� ��砥� � ०��� "���/������஢����"'+;
                    hb_eol(),cFileProtokol,.t.)
            strfile(space(5)+'- ᭮�� ᮡ��� ��砩 � ०��� "���/������ ��砨/�������"'+;
                    hb_eol(),cFileProtokol,.t.)
          endif
        endif
        select TMP2
        skip
      enddo
      close databases
      strfile(hb_eol(),cFileProtokol,.t.)
    endif
    if empty(aerr)
      arr_f := {}
      // ᮧ����� ���� ���
      go_to_schet := create_schet_from_XML(arr_XML_info,aerr,,arr_f,cReadFile)
      close databases
      if empty(aerr) // �᫨ ��� �訡��
        use_base("schet")
        set relation to
        G_Use(dir_server+"mo_xml",,"MO_XML")
        // 㤠��� ���� ���
        for i := 1 to len(arr_schet)
          strfile(hb_eol()+;
                  "㤠�� ���� ���� � "+arr_schet[i,4]+" �� "+full_date(arr_schet[i,5])+;
                  hb_eol(),cFileProtokol,.t.)
          select SCHET_
          goto (arr_schet[i,1])
          DeleteRec(.t.,.f.)  // ��� ����⪨ �� 㤠�����
          //
          select SCHET
          goto (arr_schet[i,1])
          DeleteRec(.t.)
          //
          select MO_XML
          goto (arr_schet[i,2])
          DeleteRec(.t.)
        next
        close databases
      endif
    endif
    if empty(aerr)
      // ������襬 �।��騩 䠩� ��⮪��� ��ࠡ�⪨ ���� ��⮪����
      f_append_file(dir_server+dir_XML_TF+cslash+cFileProtokol,cFileProtokol)
      viewtext(Devide_Into_Pages(dir_server+dir_XML_TF+cslash+cFileProtokol,60,80),,,,.t.,,,2)
    else
      aeval(aerr,{|x| strfile(x+hb_eol(),cFileProtokol,.t.) })
      viewtext(Devide_Into_Pages(cFileProtokol,60,80),,,,.t.,,,2)
    endif
    delete file (cFileProtokol)
  endif
  close databases
  // ࠧ�襭�� ����㯠 �ᥬ
  G_SUnLock(sem_vagno)
  keyboard ""
  if go_to_schet // �᫨ �믨ᠭ� ���
    keyboard chr(K_ENTER)
  endif
else
  func_error(4,"� ����� ������ ࠡ���� ��㣨� �����. ������ ����饭�!")
endif
return NIL

***** 03.04.13 ��������� 䠩� ofile ��ப��� �� 䠩�� nfile
Function f_append_file(ofile,nfile)
Local s
ft_use(nfile)
ft_gotop()
do while !ft_eof()
  s := ft_ReadLn()
  strfile(s+hb_eol(),ofile,.t.)
  ft_skip()
enddo
ft_use()
return NIL
