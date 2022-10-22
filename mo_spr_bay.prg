***** mo_spr.prg
#include "set.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "function.ch"
#include "edit_spr.ch"
#include "chip_mo.ch"

*****
Function begin_task_sprav()
Static n_zapusk := 0
Local fl := .t.
if n_zapusk == 0
  ++n_zapusk
endif
if copy_Tools_Ini()
  Tools_Ini_OMS(1,0,0)
else
  fl := .f.
endif
return fl


***** ������஢���� �ࠢ�筨�� ���
Function edit_spr_uslugi(k)
Static sk := 1
Local str_sem, mas_pmt, mas_msg, mas_fun, j
DEFAULT k TO 0
do case
  case k == 0
    if ! hb_user_curUser:IsAdmin()
      return func_error(4,err_admin)
    endif
    mas_pmt := {"~������஢���� ���",;
                "��㣨 �����ࠢ� �� (~�����)",;
                "~��������� ��㣨",;
                "������஢���� ~���",;
                "������� �~��",;
                "��ᮢ���⨬���� �� ~���",;
                "��㣨 ��� ~��祩",;
                "��㣨 - ~1 ࠧ � ����",;
                "������஢���� ~�㦡"}
    mas_msg := {"������஢���� �ࠢ�筨�� ��� (����� � ��)",;
                "������஢���� �ࠢ�筨�� ��� ��������⢠ ��ࠢ���࠭���� �� (�������樨 �����)",;
                "������஢���� �ࠢ�筨�� ���������� ��� (��� 㤮��⢠ ����� ������)",;
                "������஢���� �����樥�⮢ ��㤮񬪮�� ��� (���)",;
                "������஢���� �������� ����筮� ��㤮񬪮�� ���ᮭ���",;
                "������஢���� �ࠢ�筨�� ���, ����� �� ������ ���� ������� � ���� ����",;
                "����/।���஢���� ���, � ������ �� �������� ��� (����⥭�)",;
                "����/।���஢���� ���, ����� ����� ���� ������� 祫����� ⮫쪮 ࠧ � ����",;
                "������஢���� �ࠢ�筨�� �㦡"}
    mas_fun := {"edit_spr_uslugi(1)",;
                "edit_spr_uslugi(2)",;
                "edit_spr_uslugi(3)",;
                "edit_spr_uslugi(4)",;
                "edit_spr_uslugi(5)",;
                "edit_spr_uslugi(6)",;
                "edit_spr_uslugi(7)",;
                "edit_spr_uslugi(8)",;
                "edit_spr_uslugi(9)"}
    popup_prompt(T_ROW, T_COL+5, sk, mas_pmt, mas_msg, mas_fun)
  case k == 1
    f1_uslugi()
  case k == 2
    spr_uslugi_FFOMS()
  case k == 3
    f_k_uslugi()
  case k == 4
    f_trkoef()
  case k == 5
    f_trpers()
  case k == 6
    f_ns_uslugi()
  case k == 7
    f_usl_uva()
  case k == 8
    f_usl_raz()
  case k == 9
    f5_uslugi(2,T_COL+10)
endcase
if k > 0
  sk := k
endif
return NIL


***** 02.12.21
FUNCTION f1_uslugi()
Local arr_block, buf := savescreen(), str_sem := "������஢���� ���"
local tmpAlias, i

  if !G_SLock(str_sem)
    return func_error(4,err_slock)
  endif
  if !Use_base("lusl") .or. !Use_base("luslc") .or. ;
      !G_Use(dir_server+"uslugi1",{dir_server+"uslugi1",;
                                dir_server+"uslugi1s"},"USL1") .or. ;
      !G_Use(dir_server+"uslugi",,"USL") .or. ;
      !G_Use(dir_server+"usl_otd",dir_server+"usl_otd","UO") .or. ;
      !R_Use(dir_server+"slugba",dir_server+"slugba","SL")
    close databases
    return NIL
  endif
  mywait()
  if is_otd_dep .and. glob_otd_dep == 0 .and. len(mm_otd_dep) > 0
    glob_otd_dep := mm_otd_dep[1,2] // ���� ���� ��ࢮ� �⤥�����
  endif
  if !(type("arr_date_usl") == "A")
    Public arr_date_usl := {}
    for i := 2018 to WORK_YEAR
      tmpAlias := create_name_alias('LUSLC', i)
      select (tmpAlias)
      index on dtos(datebeg) to (cur_dir + "tmp1") unique
      dbeval({|| aadd(arr_date_usl, (tmpAlias)->datebeg) })
      set index to (cur_dir + prefixFileRefName(i) + "uslc"), (cur_dir + prefixFileRefName(i) + "uslu")
    next
  endif
  Private tmp_V002 := create_classif_FFOMS(0,"V002") // PROFIL
  dbcreate(cur_dir+"tmp_usl1",{{"shifr1",  "C",10,0},;
                             {"name",    "C",77,0},;
                             {"date_b",  "D", 8,0}})
  use (cur_dir+"tmp_usl1") new
  index on dtos(date_b) to (cur_dir+"tmp_usl1")
  select USL
  index on iif(kod>0,"1","0")+fsort_usl(shifr) to (cur_dir+"tmp_usl")
  set index to (cur_dir+"tmp_usl"),;
             (dir_server+"uslugi"),;
             (dir_server+"uslugish"),;
             (dir_server+"uslugis1"),;
             (dir_server+"uslugisl")
  Private str_find := "1", muslovie := "usl->kod > 0"
  arr_block := {{|| FindFirst(str_find)},;
              {|| FindLast(str_find)},;
              {|n| SkipPointer(n, muslovie)},;
              str_find,muslovie;
             }
  find ("1")
  Private fl_found := found()
  if fl_found
    do while empty(shifr) .and. !eof()
      skip
    enddo
  else
    keyboard chr(K_INS)
  endif
  Alpha_Browse(2,0,maxrow()-1,79,"f1_es_uslugi",color0,"������஢���� ���","B/BG",;
             .f.,,arr_block,,"f2_es_uslugi",,;
             {"�","�","�","N/BG,W+/N,B/BG,BG+/B,R/BG,W+/R,N+/BG,W/N,RB/BG,W+/RB",.t.,180} )
  close databases
  G_SUnLock(str_sem)
  restscreen(buf)
  return NIL

***** 15.01.19
Function f0_es_uslugi()
Local k := 3, v1, v2, fl1del, fl2del, s := iif(empty(usl->shifr1), usl->shifr, usl->shifr1)
s := padr(transform_shifr(s),10)
select LUSL
find (s)
if found()
  k := 4  // �������, �� ��� 業�
  v1 := fcena_oms(lusl->shifr,.t.,sys_date,@fl1del)
  v2 := fcena_oms(lusl->shifr,.f.,sys_date,@fl2del)
  if fl1del .and. fl2del
    k := 5  // 㤠����
  elseif !emptyall(v1,v2)
    k := 1  // ���� 業�
  endif
elseif !emptyall(usl->pcena,usl->pcena_d,usl->dms_cena)
  k := 2  // ���� ���⭠� 業�
endif
select USL
return k

*****
Function f1_es_uslugi(oBrow)
Local n := 56
Local oColumn,blk := {|_c| _c:=f0_es_uslugi(), {{1,2},{3,4},{5,6},{7,8},{9,10}}[_c] }
oColumn := TBColumnNew("   ����", {|| usl->shifr })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("���� �����", {|| opr_shifr_TFOMS(usl->shifr1,usl->kod) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
if is_zf_stomat == 1
  oColumn := TBColumnNew("��", {|| iif(usl->zf==1,"��","  ") })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  n -= 3
endif
oColumn := TBColumnNew(center("������������ ��㣨",n), {|| left(usl->name,n) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
status_key("^<Esc>^ ��室 ^<Enter>^ ।���஢���� ^<Ins>^ ���������� ^<Del>^ 㤠����� ^<F2>^ ����")
return NIL

*****
Function f2_es_uslugi(nKey,oBrow)
Static sshifr := "          "
LOCAL j := 0, k := -1, buf := save_maxrow(), buf1, fl := .f., rec,;
      tmp_color := setcolor(), r1 := 14, c1 := 2
do case
  case nKey == K_F2
    rec := recno()
    if (mshifr := input_value(18,10,20,69,color1,;
              "  ������ ����室��� ��� ��㣨 ��� ���᪠",;
              sshifr,"@K@!")) != NIL
      sshifr := mshifr := transform_shifr(mshifr)
      set order to 3
      find (padr(mshifr,10))
      if found()
        rec := recno()
        fl := .t.
      endif
      set order to 1
      if fl
        oBrow:goTop()
        goto (rec)
        k := 0
      else
        goto (rec)
        func_error(4,'��㣠 � ��஬ "'+alltrim(mshifr)+'" �� �������!')
      endif
    endif
  case nKey == K_INS .or. (nKey == K_ENTER .and. usl->kod > 0)
    rec := f3_es_uslugi(nKey)
    select USL
    oBrow:goTop()
    goto (rec)
    k := 0
  case nKey == K_DEL .and. usl->kod > 0
    stat_msg("����! �ந�������� �஢�ઠ �� ����稥 㤠�塞�� ��㣨 � ��㣨� ����� ������.")
    mybell(0.1,OK)
    R_Use(dir_server+"human_u",dir_server+"human_uk","HU")
    find (str(usl->kod,4))
    fl := found()
    hu->(dbCloseArea())
    if !fl
      R_Use(dir_server+"hum_p_u",dir_server+"hum_p_uk","HU")
      find (str(usl->kod,4))
      fl := found()
      hu->(dbCloseArea())
    endif
    if !fl
      R_Use(dir_server+"hum_oru",dir_server+"hum_oruk","HU")
      find (str(usl->kod,4))
      fl := found()
      hu->(dbCloseArea())
    endif
    if !fl
      R_Use(dir_server+"kas_pl_u",dir_server+"kas_pl2u","HU")
      find (str(usl->kod,4))
      fl := found()
      hu->(dbCloseArea())
      if !fl
        R_Use(dir_server+"kas_ortu",dir_server+"kas_or2u","HU")
        find (str(usl->kod,4))
        fl := found()
        hu->(dbCloseArea())
      endif
    endif
    select USL
    if fl
      func_error(4,"������ ��㣠 ����砥��� � ��㣨� ����� ������. �������� ����饭�!")
    elseif f_Esc_Enter(2,.t.)
      mywait()
      useUch_Usl()
      select UU1
      do while .t.
        find (STR(usl->kod,4))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      select UU
      find (STR(usl->kod,4))
      do while uu->kod == usl->kod .and. !eof()
        G_RLock(forever)
        uu->vkoef_v := 0 ; uu->vkoef_r := 0
        uu->akoef_v := 0 ; uu->akoef_r := 0
        uu->koef_v := 0
        uu->koef_r := 0
        UNLOCK
        skip
      enddo
      uu->(dbCloseArea())
      uu1->(dbCloseArea())
      //
      select USL1
      do while .t.
        find (STR(usl->kod,4))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      //
      select USL
      G_RLock(forever)
      replace usl->kod with -1, ;
              usl->slugba with -1, ;
              usl->name with "", ;
              usl->shifr with "", usl->shifr1 with ""
      UNLOCK
      Commit
      stat_msg("��㣠 㤠����!") ; mybell(1,OK)
      oBrow:goTop()
      k := 0
    endif
endcase
rest_box(buf)
return k

** �. 䠩� SERVICES\f3_es_uslugi.prg
***** 03.09.17
Function f3_es_uslugi_1(nKey)
Static menu_nul := {{"���",.f.},{"��",.t.}}
Local tmp_help := chm_help_code, buf := savescreen(), r, r1 := maxrow()-11,;
      k, tmp_color := setcolor(), ret := usl->(recno()), old_m1otd, s, is_full
Private mkod, mname, mpcena, mpcena_d, mshifr, mshifr1, mcena, mcena_d,;
        m1shifr1, m1PROFIL, mPROFIL, mpnds, mpnds_d, mzf, m1zf,;
        mdms_cena, m1is_nul, mis_nul, motdel := space(10), m1otdel:="",;
        mname1:="", mslugba, m1slugba, gl_area,;
        m1is_nulp, mis_nulp, yes_tfoms := .f., pifin := 0, pifinr, pifinc
if (is_full := (is_task(X_ORTO) .or. is_task(X_KASSA) .or. is_task(X_PLATN)))
  r1 -= 4
endif
gl_area := {r1+1, 0, 23, 79, 0}
//
select TMP_USL1
zap
//
mkod      := IF(nKey==K_INS, 0, usl->kod)
mname     := IF(nKey==K_INS, SPACE(65), usl->name)
mfull_name:= IF(nKey==K_INS, SPACE(255),usl->full_name)
mshifr    := if(nKey==K_INS, space(10), usl->shifr)
mshifr1   := if(nKey==K_INS, space(10), usl->shifr1)
m1PROFIL  := IF(nKey==K_INS, 0, usl->profil)
mPROFIL   := inieditspr(A__MENUVERT, glob_V002, m1PROFIL)
mcena     := IF(nKey==K_INS, 0, usl->cena)
mcena_d   := IF(nKey==K_INS, 0, usl->cena_d)
mpcena    := IF(nKey==K_INS, 0, usl->pcena)
mpcena_d  := IF(nKey==K_INS, 0, usl->pcena_d)
mpnds     := IF(nKey==K_INS, 0, usl->pnds)
mpnds_d   := IF(nKey==K_INS, 0, usl->pnds_d)
mdms_cena := IF(nKey==K_INS, 0, usl->dms_cena)
m1slugba  := if(nKey==K_INS, -1, usl->slugba)
m1zf      := if(nKey==K_INS, .f., (usl->zf==1))
mzf       := inieditspr(A__MENUVERT, menu_nul, m1zf)
m1is_nul  := if(nKey==K_INS, .f., usl->is_nul)
mis_nul   := inieditspr(A__MENUVERT, menu_nul, m1is_nul)
m1is_nulp := if(nKey==K_INS, .f., usl->is_nulp)
mis_nulp  := inieditspr(A__MENUVERT, menu_nul, m1is_nulp)
if m1slugba >= 0
  select SL
  find (str(m1slugba,3))
  mslugba := lstr(sl->shifr)+". "+alltrim(sl->name)
else
  mslugba := space(10)
endif
if nKey == K_ENTER // ।���஢����
  if !empty(s := f0_e_uslugi1(mkod,,.t.))
    mshifr1 := s
  endif
  select UO
  find (str(mkod,4))
  if found()
    k := atnum(chr(0),uo->otdel,1)
    motdel := "= "+lstr(k-1)+"��. ="
    m1otdel := left(uo->otdel,k-1)
  endif
endif
m1shifr1 := mshifr1
old_m1otd := m1otdel
chm_help_code := 1//H_Edit_uslugi
//
SETCOLOR(color8)
Scroll( r1, 0, maxrow()-1, maxcol() )
@ r1,0 to r1,maxcol()
status_key("^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ������")
IF nKey == K_INS
  str_center(r1," ���������� ��㣨 ")
ELSE
  str_center(r1, " ������஢���� ")
ENDIF
f4_es_uslugi(0)
DO WHILE .T.
  SETCOLOR(cDataCGet)
  if !m1is_nul
    keyboard chr(K_TAB)
  endif
  r := r1
  @ ++r,1 SAY "����蠥��� ���� ������ ��㣨 �� ������� 業� � ����� ���?" ;
          get mis_nul reader {|x|menu_reader(x,menu_nul,A__MENUVERT,,,.f.)}
  @ ++r,1 SAY "������������ ��㣨 �� �ࠢ�筨�� �����"
  @ ++r,3 GET mname1 when .f. color color14
  @ ++r,1 SAY "���� ��" get mshifr picture "@!" valid f4_es_uslugi(1,.t.,nKey)
  @ row(),col()+5 SAY "��� �����" get mshifr1 ;
                  reader {|x|menu_reader(x,{{|k,r,c| f1_e_uslugi1(k,r,c) }},A__FUNCTION,,,.f.)} ;
                  valid f4_es_uslugi(0) ;
                  color "R/W"
if is_zf_stomat == 1
  @ row(),col()+5 SAY "���� �㡭�� ����" get mzf ;
                  reader {|x|menu_reader(x,menu_nul,A__MENUVERT,,,.f.)}
endif
  @ ++r,1 SAY "������������ ��㣨" GET mname PICTURE "@S59"
if is_full
  @ ++r,1 SAY "������������/�����" GET mfull_name PICTURE "@S58"
endif
  @ ++r,1 SAY "���� ��㣨 ���: ��� ���᫮��" GET mcena PICTURE pict_cena when !yes_tfoms color color14
  @ row(),col() SAY ", ��� ॡ����" GET mcena_d PICTURE pict_cena when !yes_tfoms color color14
  @ ++r,1 say "��䨫�" get MPROFIL ;
          reader {|x|menu_reader(x,tmp_V002,A__MENUVERT_SPACE,,,.f.)}
if is_full
  @ ++r,1 SAY "����蠥��� ���� ������� ��㣨 �� ������� 業�?" ;
          get mis_nulp reader {|x|menu_reader(x,menu_nul,A__MENUVERT,,,.f.)}
  @ ++r,1 SAY "���� ������� ��㣨: ��� ���᫮��" GET mpcena PICTURE pict_cena
  @ row(),col() SAY " (� �.�. ���" GET mpnds PICTURE pict_cena
  @ row(),col() SAY ")"
  @ ++r,1 SAY "   ��� ॡ����" GET mpcena_d PICTURE pict_cena
  @ row(),col() SAY " (� �.�. ���" GET mpnds_d PICTURE pict_cena
  @ row(),col() SAY "); 業� �� ���" GET mdms_cena PICTURE pict_cena
endif

  @ ++r,1 SAY "��㦡�" get mslugba ;
          reader {|x|menu_reader(x,{{|k,r,c|fget_slugba(k,r,c)}},A__FUNCTION,,,.f.)} ;
          color "R/W"
  @ ++r,1 say "� ����� �⤥������ ࠧ�蠥��� ���� ��㣨" get motdel ;
          reader {|x|menu_reader(x,{{|k,r,c|inp_bit_otd(k,r,c)}},A__FUNCTION,,,.f.)}

  myread()
  if LASTKEY() != K_ESC
    fl := .t.
    if EMPTY(mname)
      fl := func_error("�� ������� �������� ��㣨. ��� �����.")
    elseif empty(mshifr)
      fl := func_error("�� ������ ��� ��㣨. ��� �����.")
    endif
    if fl
      mywait()
      select USL
      SET ORDER TO 2
      if nKey == K_INS
        FIND (STR(-1,4))
        if found()
          G_RLock(forever)
        else
          AddRec(4)
        endif
        mkod := recno()
        usl->kod := mkod
      else
        FIND (STR(mkod,4))
        G_RLock(forever)
      endif
      usl->name     := mname
      usl->full_name:= mfull_name
      usl->shifr    := mshifr
      usl->shifr1   := mshifr1
      usl->PROFIL   := m1PROFIL
      usl->zf       := iif(m1zf,1,0)
      usl->is_nul   := m1is_nul
      usl->is_nulp  := m1is_nulp
      usl->slugba   := m1slugba
      if valtype(mcena) == "C"
        usl->cena   := val(mcena)
        usl->cena_d := val(mcena_d)
      else
        usl->cena   := mcena
        usl->cena_d := mcena_d
      endif
      usl->pcena    := mpcena
      usl->pcena_d  := mpcena_d
      usl->dms_cena := mdms_cena
      usl->pnds     := mpnds
      usl->pnds_d   := mpnds_d
      //
      select USL1
      do while .t.
        find (STR(mkod,4))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      select TMP_USL1
      go top
      do while !eof()
        select USL1
        AddRec(4)
        usl1->kod    := mkod
        usl1->shifr1 := tmp_usl1->shifr1
        usl1->date_b := tmp_usl1->date_b
        select TMP_USL1
        skip
      enddo
      //
      if !(old_m1otd == m1otdel)
        select UO
        if len(m1otdel) == 0
          find (str(mkod,4))
          if found()
            DeleteRec(.t.)
          endif
        else
          find (str(mkod,4))
          if found()
            G_RLock(forever)
          else
            AddRec(4)
            uo->kod := mkod
          endif
          uo->otdel := padr(m1otdel,255,chr(0))
        endif
      endif
      UNLOCK ALL
      COMMIT
      ret := mkod
    else
      loop
    ENDIF
  ENDIF
  exit
ENDDO
chm_help_code := tmp_help
restscreen(buf)
setcolor(tmp_color)
select USL
set order to 1
Return ret

***** 15.01.19
Function f4_es_uslugi(k,fl_poisk,nKey)
Local fl, v1, v2, s, rec, fl1del, fl2del
if k > 0
  DEFAULT fl_poisk TO .f.
  Private tmp := readvar()
  &tmp := transform_shifr(&tmp)
  if fl_poisk .and. !empty(mshifr)
    select USL
    rec := recno()
    set order to 1
    v1 := 0
    find (mshifr)
    do while usl->shifr == mshifr .and. !eof()
      if nKey == K_INS
        ++v1
      elseif recno() != rec
        ++v1
      endif
      skip
    enddo
    goto (rec)
    if v1 > 0
      return func_error(4,"����� ��� ��㣨 㦥 ����砥��� � �ࠢ�筨�� ���!")
    endif
    R_Use(dir_server+"mo_su",dir_server+"mo_sush","MOSU")
    find (mshifr)
    if found()
      v1 := 1
    endif
    use
    select USL
    if v1 > 0
      return func_error(4,"����� ��� ��㣨 㦥 ����砥��� � �ࠢ�筨�� ����権!")
    endif
  endif
endif
s := iif(empty(mshifr1), mshifr, mshifr1)
mname1 := space(77)
yes_tfoms := .f.
if !empty(s)
  s := padr(transform_shifr(s),10)
  select LUSL
  find (s)
  if found()
    yes_tfoms := .t.
    mname1 := padr(lusl->name,77)
    if empty(mname)
      mname := padr(mname1,65)
    endif
    v1 := fcena_oms(lusl->shifr,.t.,sys_date,@fl1del,,@pifin)
    v2 := fcena_oms(lusl->shifr,.f.,sys_date,@fl2del,,@pifin)
    if fl1del .and. fl2del
      mcena := mcena_d := padr("㤠����",10)
    else
      mcena := put_kop(v1,10)
      mcena_d := put_kop(v2,10)
    endif
  else
    mname1 := padr("�� �������",77)
  endif
  select USL
endif
return update_gets()

*

*****
Function f0_e_uslugi1(lkod,ldate,is_base)
Local s := "", tmp_select := select()
DEFAULT ldate TO sys_date, is_base TO .f.
select USL1
find (str(lkod,4))
do while usl1->kod == lkod .and. !eof()
  if usl1->date_b <= ldate
    s := usl1->shifr1
  endif
  if is_base .and. !empty(usl1->shifr1)
    select TMP_USL1
    append blank
    tmp_usl1->date_b := usl1->date_b
    tmp_usl1->shifr1 := usl1->shifr1
    select LUSL
    find (padr(usl1->shifr1,10))
    if found()
      tmp_usl1->name := lusl->name
    else
      tmp_usl1->name := "�� ������� ������������ ��㣨"
    endif
  endif
  select USL1
  skip
enddo
if is_base .and. tmp_usl1->(lastrec()) == 0 .and. !empty(mshifr1)
  select TMP_USL1
  append blank
  tmp_usl1->date_b := arr_date_usl[1]
  tmp_usl1->shifr1 := mshifr1
  select LUSL
  find (padr(mshifr1,10))
  tmp_usl1->name := lusl->name
endif
select (tmp_select)
return s

*****
Function f1_e_uslugi1(k,r,c)
Local t_arr := array(BR_LEN), tmp_select := select(), ret := {space(10),space(10)}
t_arr[BR_TOP] := r-10
t_arr[BR_BOTTOM] := r-1
t_arr[BR_LEFT]  := 0
t_arr[BR_RIGHT] := 79
t_arr[BR_COLOR] := color5
t_arr[BR_TITUL] := "������஢���� ��� ����� ��� ��㣨 "+alltrim(mshifr)
t_arr[BR_TITUL_COLOR] := "BG+/GR"
t_arr[BR_ARR_BROWSE] := {"�","�","�",,.t.}
t_arr[BR_OPEN] := {|nk,ob| f2_e_uslugi1(nk,ob,"open") }
t_arr[BR_COLUMN] := {{"   ���;  ��砫�; ����⢨�",{|| full_date(tmp_usl1->date_b) }},;
                     {"���� �����",{|| tmp_usl1->shifr1}},;
                     {" ������������",{|| left(tmp_usl1->name,56)}}}
t_arr[BR_EDIT] := {|nk,ob| f2_e_uslugi1(nk,ob,"edit") }
edit_browse(t_arr)
//
select TMP_USL1
go top
do while !eof()
  if tmp_usl1->date_b > sys_date
    exit
  endif
  ret := {tmp_usl1->shifr1,tmp_usl1->shifr1}
  skip
enddo
select (tmp_select)
return ret

*****
Function f2_e_uslugi1(nKey,oBrow,regim)
Local ret := -1, buf, fl := .f., rec, rec1, r1, r2, tmp_color
do case
  case regim == "open"
    select TMP_USL1
    go top
    if (ret := !eof())
      keyboard chr(K_CTRL_PGDN)  // ����� �� ��᫥���� ������
    endif
  case regim == "edit"
    do case
      case eq_any(nKey,K_INS,K_ENTER)
        rec := recno()
        save screen to buf
        if nkey == K_INS .and. !fl_found
          colorwin(pr1+4,pc1,pr1+4,pc2,"W/W","GR+/R")
        endif
        Private gl_area := {1,0,maxrow()-1,79,0},;
                mdate_b := if(nKey == K_INS, atail(arr_date_usl), tmp_usl1->date_b),;
                mshifr1 := if(nKey == K_INS, space(10), tmp_usl1->shifr1),;
                mname1  := if(nKey == K_INS, space(77), tmp_usl1->name)
        tmp_color := setcolor(cDataCScr)
        box_shadow(pr2-5,0,pr2-1,79,,;
                       if(nKey == K_INS,"����������","������஢����"),;
                       cDataPgDn)
        setcolor(cDataCGet)
        @ pr2-4,2 say "��� ��砫� ����⢨� ��� �����" get mdate_b valid {|g| f3_e_uslugi1(g,mdate_b) }
        @ pr2-3,2 say "���� �����" get mshifr1 pict "@!" valid {|g| f4_e_uslugi1(g) }
        @ pr2-2,2 get mname1 when .f.
        status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
        myread()
        select TMP_USL1
        if lastkey() != K_ESC .and. !emptyany(mdate_b,mshifr1) .and. f_Esc_Enter(1)
          if nKey == K_INS
            fl_found := .t.
            append blank
            rec := recno()
          else
            G_RLock(forever)
          endif
          replace tmp_usl1->date_b with mdate_b, ;
                  tmp_usl1->shifr1 with mshifr1, ;
                  tmp_usl1->name   with mname1
          COMMIT
          oBrow:goTop()
          goto (rec)
          ret := 0
        elseif nKey == K_INS .and. !fl_found
          ret := 1
        endif
        setcolor(tmp_color)
        restore screen from buf
      case nKey == K_DEL .and. !empty(tmp_usl1->date_b) .and. f_Esc_Enter(2)
        Delete
        pack
        oBrow:goTop()
        ret := 0
        if eof()
          ret := 1
        endif
    endcase
endcase
return ret

*****
Function f3_e_uslugi1(get,ldate)
Local i := 1, fl := .t.
if empty(ldate)
  fl := func_error(4,"������ ���� �� ����� ���� �����")
elseif ascan(arr_date_usl,ldate) == 0
  if ldate > atail(arr_date_usl)
    i := len(arr_date_usl)
  elseif ldate > arr_date_usl[1]
    do while ldate > arr_date_usl[1]
      --ldate
      if (i := ascan(arr_date_usl,ldate)) > 0
        exit
      endif
      i := 1
    enddo
  endif
  fl := func_error(4,"����୮� ���祭�� (�������� ��� ᬥ�� 業 "+date_8(arr_date_usl[i])+"�.)")
endif
return fl

***** 16.01.13
Function f4_e_uslugi1(get)
Local fl := .t., fl1del, fl2del
if !empty(mshifr1 := transform_shifr(mshifr1))
  select LUSL
  find (mshifr1)
  if found()
    mname1 := padr(lusl->name,77)
    fcena_oms(lusl->shifr,.t.,mdate_b,@fl1del)
    fcena_oms(lusl->shifr,.f.,mdate_b,@fl2del)
    if fl1del .and. fl2del
      fl := func_error(4,"������ ��㣠 㤠���� ����� �� ���ﭨ� �� "+date_8(mdate_b)+"�.")
    endif
  else
    fl := func_error(4,"�� ������� ��㣠 � ����� ��஬")
  endif
  if !fl
    mshifr1 := get:original
  endif
endif
return fl

*****
Function spr_uslugi_FFOMS()
Static menu_nul := {{"���",.f.},{"��",.t.}}
Local arr_block, buf := savescreen(),  str_sem
str_sem := "������஢���� ���"
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
if !Use_base("luslf") .or. !G_Use(dir_server+"mo_su",,"MOSU")
  close databases
  return NIL
endif
mywait()
Private tmp_V002 := create_classif_FFOMS(0,"V002") // PROFIL
select MOSU
index on iif(kod>0,"1","0")+shifr1 to (cur_dir+"tmp_usl")
set index to (cur_dir+"tmp_usl"),;
             (dir_server+"mo_su"),;
             (dir_server+"mo_sush"),;
             (dir_server+"mo_sush1")
Private str_find := "1", muslovie := "mosu->kod > 0"
arr_block := {{|| FindFirst(str_find)},;
              {|| FindLast(str_find)},;
              {|n| SkipPointer(n, muslovie)},;
              str_find,muslovie;
             }
find ("1")
Private fl_found := found()
if !fl_found
  keyboard chr(K_INS)
endif
Alpha_Browse(2,0,maxrow()-1,79,"f1_FF_uslugi",color0,;
             "������஢���� ��� ��������⢠ ��ࠢ���࠭���� ��","W+/GR",;
             .f.,,arr_block,,"f2_FF_uslugi",,;
             {"�","�","�","N/BG,W+/N,B/BG,BG+/B,R/BG,W+/R,N+/BG,W/N,RB/BG,W+/RB",.t.,180} )
close databases
G_SUnLock(str_sem)
restscreen(buf)
return NIL

***** 05.08.16
Function f1_FF_uslugi(oBrow)
Local n := 46, oColumn, blk
oColumn := TBColumnNew(" ���� �����", {|| mosu->shifr1 })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(" ���� ��", {|| mosu->shifr })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
if is_zf_stomat == 1
  oColumn := TBColumnNew("��", {|| iif(mosu->zf==1,"��","  ") })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  n -= 3
endif
oColumn := TBColumnNew(center("������������ ��㣨",n), {|| left(mosu->name,n) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
status_key("^<Esc>^ ��室 ^<Enter>^ ।���஢���� ^<Ins>^ ���������� ^<Del>^ 㤠����� ^<F2>^ ����")
return NIL

***** 09.09.18
Function f2_FF_uslugi(nKey,oBrow)
Static sshifr := "          "
LOCAL j := 0, k := -1, buf := save_maxrow(), buf1, fl := .f., rec,;
      tmp_color := setcolor(), r1 := maxrow()-10, c1 := 2
do case
  case nKey == K_F2
    rec := recno()
    if (mshifr := input_value(18,10,20,69,color1,;
              "  ������ ����室��� ��� ��㣨 ��� ���᪠",;
              sshifr,"@K@!")) != NIL
      sshifr := mshifr := transform_shifr(mshifr)
      set order to 3
      find (mshifr)
      if found()
        rec := recno()
        fl := .t.
      endif
      set order to 1
      if fl
        oBrow:goTop()
        goto (rec)
        k := 0
      else
        goto (rec)
        func_error(4,'��㣠 � ��஬ "'+alltrim(mshifr)+'" �� �������!')
      endif
    endif
  case nKey == K_INS .or. (nKey == K_ENTER .and. mosu->kod > 0)
    rec := f3_FF_uslugi(nKey)
    select MOSU
    oBrow:goTop()
    goto (rec)
    k := 0
  case nKey == K_DEL .and. mosu->kod > 0
    stat_msg("����! �ந�������� �஢�ઠ �� ����稥 㤠�塞�� ��㣨 � ��㣨� ����� ������.")
    mybell(0.1,OK)
    R_Use(dir_server+"mo_hu",dir_server+"mo_huk","HU")
    find (str(mosu->kod,6))
    fl := found()
    hu->(dbCloseArea())
    if !fl
      R_Use(dir_server+"mo_onkna",,"NAPR") // �������ࠢ�����
      Locate for U_KOD == mosu->kod
      fl := found()
      napr->(dbCloseArea())
    endif
    select MOSU
    if fl
      func_error(4,"������ ��㣠 ����砥��� � ��㣨� ����� ������. �������� ����饭�!")
    elseif f_Esc_Enter(2,.t.)
      G_RLock(forever)
      replace mosu->kod with -1, ;
              mosu->name with "", tip with 0,;
              mosu->shifr with "", mosu->shifr1 with ""
      UNLOCK
      Commit
      stat_msg("��㣠 㤠����!") ; mybell(1,OK)
      oBrow:goTop()
      k := 0
    endif
endcase
rest_box(buf)
return k

*

***** 31.01.17
Function f3_FF_uslugi(nKey)
Static menu_nul := {{"���",.f.},{"��",.t.}}
Local buf := savescreen(), r1 := maxrow()-9,;
      k, tmp_color := setcolor(), ret := mosu->(recno())
Private mkod, mname, mshifr, mshifr1, m1PROFIL, mPROFIL, mzf, m1zf, m1tip,;
        mname1, gl_area := {r1+1, 0, maxrow()-1, maxcol(), 0}
//
m1tip     := IF(nKey==K_INS, 0, mosu->tip)
mkod      := IF(nKey==K_INS, 0, mosu->kod)
mname     := IF(nKey==K_INS, SPACE(65), mosu->name)
mshifr    := if(nKey==K_INS, space(10), mosu->shifr)
mshifr1   := if(nKey==K_INS, space(20), mosu->shifr1)
m1PROFIL  := IF(nKey==K_INS, 0, mosu->profil)
mPROFIL   := inieditspr(A__MENUVERT, glob_V002, m1PROFIL)
m1zf      := if(nKey==K_INS, .f., (mosu->zf==1))
mzf       := inieditspr(A__MENUVERT, menu_nul, m1zf)
//
SETCOLOR(color8)
Scroll( r1, 0, maxrow()-1, maxcol() )
@ r1,0 to r1,maxcol()
status_key("^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ������")
IF nKey == K_INS
  str_center(r1," ���������� ��㣨 ")
ELSE
  str_center(r1, " ������஢���� ")
ENDIF
f4_FF_uslugi(0)
DO WHILE .T.
  SETCOLOR(cDataCGet)
  @ r1+1,1 SAY "���� � ��� (�����)" get mshifr1 picture "@!" ;
           when empty(mshifr1) valid f4_FF_uslugi(1,nKey)
  @ r1+2,1 SAY "������������ ��㣨 �� �ࠢ�筨�� �����ࠢ� (�����)"
  @ r1+3,2 GET mname1 when .f. color color14
  @ r1+4,1 SAY "���� ��㣨 (� ��)" get mshifr picture "@!" valid f4_FF_uslugi(2,nKey)
  @ r1+5,1 SAY "������������ ��㣨" GET mname PICTURE "@S59"
  @ r1+6,1 say "��䨫�" get MPROFIL ;
           reader {|x|menu_reader(x,tmp_V002,A__MENUVERT_SPACE,,,.f.)}
if is_zf_stomat == 1
  @ r1+7,1 SAY "���� �㡭�� ����" get mzf ;
                  reader {|x|menu_reader(x,menu_nul,A__MENUVERT,,,.f.)}
endif
  myread()
  if LASTKEY() != K_ESC
    fl := .t.
    if empty(mshifr1)
      fl := func_error("�� ������ ��� �����ࠢ� (�����). ��� �����.")
    endif
    if fl
      mywait()
      select MOSU
      SET ORDER TO 2
      if nKey == K_INS
        FIND (STR(-1,6))
        if found()
          G_RLock(forever)
        else
          AddRec(6)
        endif
        mkod := recno()
        mosu->kod := mkod
      else
        FIND (STR(mkod,6))
        G_RLock(forever)
      endif
      mosu->name     := mname
      mosu->shifr    := mshifr
      mosu->shifr1   := mshifr1
      mosu->PROFIL   := m1PROFIL
      mosu->zf       := iif(m1zf,1,0)
      UnLock
      commit
      ret := mkod
    else
      loop
    ENDIF
  ENDIF
  exit
ENDDO
restscreen(buf)
setcolor(tmp_color)
select MOSU
set order to 1
Return ret

***** 31.01.17
Function f4_FF_uslugi(k,nKey)
Local fl := .t., rec, v1
select MOSU
rec := recno()
do case
  case k == 0 // ��। �室�� � GET
    mname1 := space(78)
    if !empty(mshifr1)
      if m1tip > 0
        mname1 := padr("㤠����",78)
      else
        select LUSLF
        find (mshifr1)
        if found()
          mname1 := padr(luslf->name,78)
          if empty(mname)
            mname := padr(mname1,65)
          endif
        else
          mname1 := padr("�� �������",78)
        endif
      endif
    endif
  case k == 1
    mshifr1 := transform_shifr(mshifr1)
    select LUSLF
    find (mshifr1)
    if found()
      if nKey == K_INS
        select MOSU
        set order to 4
        find (mshifr1)
        if found()
          fl := func_error(4,"����� ��� ����� 㦥 ����砥��� � �ࠢ�筨��!")
          mshifr1 := space(20)
        endif
      endif
      if fl
        mname1 := padr(luslf->name,78)
        if empty(mname)
          mname := padr(mname1,65)
        endif
        update_gets()
      endif
    else
      fl := func_error(1,"�� ������� ��㣠 � ⠪�� ��஬")
      mshifr1 := space(20)
    endif
  case k == 2
    mshifr := transform_shifr(mshifr)
    if !empty(mshifr)
      v1 := 0
      set order to 3
      find (mshifr)
      do while mosu->shifr == mshifr .and. !eof()
        if nKey == K_INS
          ++v1
        elseif recno() != rec
          ++v1
        endif
        skip
      enddo
      if v1 > 0
        fl := func_error(4,"����� ��� ��㣨 㦥 ����砥��� � �ࠢ�筨��!")
        mshifr := space(10)
      endif
      if fl
        R_Use(dir_server+"uslugi",dir_server+"uslugish","USL")
        find (mshifr)
        if found()
          fl := func_error(4,"����� ��� ��㣨 㦥 ����砥��� � �᭮���� �ࠢ�筨�� ���!")
          mshifr := space(10)
        endif
        Use
      endif
    endif
endcase
select MOSU
set order to 1
goto (rec)
return fl

*

*****
Function inp_bit_otd(k,r,c)
Local mlen, t_mas := {}, buf := savescreen(), ret, ;
      i, tmp_color := setcolor(), m1var := "", s := "",;
      tmp_select := select(), r1, a_uch := {}
mywait()
R_Use(dir_server+"mo_uch",,"LPU")
dbeval({|| iif(between_date(lpu->dbegin,lpu->dend,sys_date), ;
               aadd(a_uch,lpu->(recno())), nil) })
R_Use(dir_server+"mo_otd",,"OTD")
set relation to kod_lpu into LPU
dbeval({|| s := if(chr(recno()) $ k," * ","   ")+;
                padr(otd->name,30)+" "+padr(lpu->short_name,5)+str(recno(),10),;
           aadd(t_mas,s);
       },;
       {|| between_date(otd->dbegin,otd->dend,sys_date) .and. ;
           ascan(a_uch,otd->kod_lpu) > 0 };
      )
otd->(dbCloseArea())
lpu->(dbCloseArea())
if tmp_select > 0
  select(tmp_select)
endif
mlen := len(t_mas)
asort(t_mas,,,{|x,y| if(substr(x,35,5) == substr(y,35,5), ;
                          (substr(x,4,30) < substr(y,4,30)), ;
                          (substr(x,35,5) < substr(y,35,5))) } )
i := 1
status_key("^<Esc>^ - �⪠�; ^<Enter>^ - ���⢥ত����; ^<Ins>^ - ᬥ�� ��樨 ⥪�饩 ����ୠ⨢�")
if (r1 := r-1-mlen-1) < 2
  r1 := 2
endif
if (ret := popup(r1,19,r-1,62,t_mas,i,color0,.t.,"fmenu_reader",,;
                 "� ����� �⤥������ ࠧ�蠥��� ���� ��㣨",col_tit_popup)) > 0
  for i := 1 to mlen
    if "*" == substr(t_mas[i],2,1)
      k := chr(int(val(right(t_mas[i],10))))
      m1var += k
    endif
  next
  s := "= "+lstr(len(m1var))+"��. ="
endif
restscreen(buf)
setcolor(tmp_color)
Return iif(ret==0, NIL, {m1var,s})

*****
Function fget_slugba(k,r,c)
Local tmp_help := chm_help_code, k1
chm_help_code := -1
select SL
find (str(k,3))
if !found()
  go top
endif
if (fl := Alpha_Browse(2,c,r-1,c+50,"f51_uslugi",color0,,,.f.))
  k1 := { sl->shifr, lstr(sl->shifr)+". "+alltrim(sl->name) }
endif
chm_help_code := tmp_help
return k1

*

***** ������஢���� �ࠢ�筨�� ���������� ��� (��� 㤮��⢠ ����� ������)
Function f_k_uslugi(r1)
Local str_sem := "������஢���� ���������� ���"
DEFAULT r1 TO 2
Private pr1 := r1, pc1 := 2, pc2 := 77, fl_found := .t.
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
R_Use(dir_server+"mo_pers",dir_server+"mo_pers","PERSO")
G_Use(dir_server+"uslugi_k",dir_server+"uslugi_k","UK")
go top
if eof()
  fl_found := .f.
  keyboard chr(K_INS)
endif
Alpha_Browse(pr1,pc1,maxrow()-2,pc2,"f1_k_uslugi",color0,,,,,,,"f2_k_uslugi",,;
             {"�","�","�",,.t.} )
close databases
G_SUnLock(str_sem)
return NIL

*****
Function f1_k_uslugi(oBrow)
Local oColumn, n := 49
oColumn := TBColumnNew("   ����", {|| uk->shifr })
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("������������ �������᭮� ��㣨",n), {|| left(uk->name,n) })
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("���",{|| put_val(ret_tabn(uk->kod_vr),5) })
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("���.",{|| put_val(ret_tabn(uk->kod_as),5) })
oBrow:addColumn(oColumn)
if type("pr1") == "N"
  status_key("^<Esc>^ ��室; ^<Enter>^ ।-���; ^<Ins>^ ����������; ^<Del>^ 㤠�.; ^<Ctrl+Enter>^ ��㣨")
else
  status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮� �������᭮� ��㣨")
endif
return NIL

*****
Function f2_k_uslugi(nKey,oBrow)
Local buf, fl := .f., rec, rec1, k := -1, r := maxrow()-9, tmp_color
do case
  case (nKey == K_INS .or. (nKey == K_ENTER .and. !emptyall(uk->shifr,uk->name))) ;
                                                  .and. type("pr1") == "N"
    save screen to buf
    if nkey == K_INS .and. !fl_found
      colorwin(pr1+3,pc1,pr1+3,pc2,"N/N","W+/N")
    endif
    if nKey == K_ENTER
      rec := recno()
    endif
    Private mshifr, mname, gl_area := {1,0,maxrow()-1,79,0}, old_shifr,;
            mkod_vr := if(nKey == K_INS, 0, uk->kod_vr),;
            mkod_as := if(nKey == K_INS, 0, uk->kod_as),;
            mtabn_vr := 0, mtabn_as := 0,;
            mvrach := massist := space(35)
    old_shifr := mshifr := if(nKey == K_INS, space(10), uk->shifr)
    mname := if(nKey == K_INS, space(60), uk->name)
    if mkod_vr > 0
      select PERSO
      goto (mkod_vr)
      mvrach := padr(perso->fio,35)
      mtabn_vr := perso->tab_nom
    endif
    if mkod_as > 0
      select PERSO
      goto (mkod_as)
      massist := padr(perso->fio,35)
      mtabn_as := perso->tab_nom
    endif
    tmp_color := setcolor(cDataCScr)
    box_shadow(r,pc1+1,maxrow()-3,pc2-1,,;
              if(nKey==K_INS,"����������","������஢����"),cDataPgDn)
    setcolor(cDataCGet)
    @ r+1,pc1+3 say "���� ��㣨" get mshifr picture "@!" valid valid_shifr()
    @ r+2,pc1+3 say "������������ �������᭮� ��㣨"
    @ r+3,pc1+5 get mname
    @ r+4,pc1+3 say "���.� ���" get mtabn_vr pict "99999" valid {|g| f5editkusl(g,2,3) }
    @ row(),col()+3 get mvrach when .f. color color14
    @ r+5,pc1+3 say "���.� ����⥭�" get mtabn_as pict "99999" valid {|g| f5editkusl(g,2,4) }
    @ row(),col()+3 get massist when .f. color color14
    status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread()
    select UK
    if lastkey() != K_ESC .and. !emptyany(mshifr,mname)
      fl := .t.
      if !(old_shifr == mshifr)
        find (mshifr)
        do while uk->shifr == mshifr .and. !eof()
          if iif(nKey==K_INS, .t., (recno() != rec))
            fl := func_error(4,"������᭠� ��㣠 � ����� ��஬ 㦥 ��������� � ���� ������!")
            exit
          endif
          skip
        enddo
        if nKey == K_ENTER
          goto (rec)
        endif
      endif
      if fl .and. f_Esc_Enter(1)
        mywait()
        if nKey == K_INS
          AddRecN()
          fl_found := .t.
        else
          G_RLock(forever)
        endif
        replace uk->shifr with mshifr, uk->name with mname,;
                uk->kod_vr with mkod_vr, uk->kod_as with mkod_as
        UNLOCK
        COMMIT
        if nKey == K_ENTER .and. !(old_shifr == mshifr)
          G_Use(dir_server+"uslugi1k",{dir_server+"uslugi1k"},"U1K")
          do while .t.
            find (old_shifr)
            if !found() ; exit ; endif
            G_RLock(forever)
            u1k->shifr := mshifr
            UnLock
          enddo
          u1k->(dbCloseArea())
          select UK
        endif
        oBrow:gotop()
        find (mshifr)
        k := 0
      endif
    elseif nKey == K_INS .and. !fl_found
      k := 1
    endif
    setcolor(tmp_color)
    restore screen from buf
  case nKey == K_DEL .and. !emptyall(uk->shifr,uk->name) ;
                            .and. type("pr1") == "N" ;
                            .and. f_Esc_Enter(2,.t.)
    buf := save_maxrow()
    mywait()
    G_Use(dir_server+"uslugi1k",{dir_server+"uslugi1k"},"U1K")
    do while .t.
      find (uk->shifr)
      if !found() ; exit ; endif
      DeleteRec(.t.)
    enddo
    u1k->(dbCloseArea())
    select UK
    DeleteRec()
    oBrow:gotop()
    go top
    k := 0
    if eof()
      k := 1
    endif
    rest_box(buf)
  case nKey == K_CTRL_ENTER .and. !empty(uk->shifr) ;
                                 .and. type("pr1") == "N"
    f3_k_uslugi()
    k := 0
endcase
return k

*****
Function f3_k_uslugi()
Local buf := savescreen(), adbf
Private fl_found
mywait()
G_Use(dir_server+"uslugi",dir_server+"uslugish","USL")
G_Use(dir_server+"uslugi1k",{dir_server+"uslugi1k"},"U1K")
adbf := dbstruct()
aadd(adbf, {"rec_u1k","N",6,0} )
aadd(adbf, {"name","C",64,0} )
dbcreate(cur_dir+"tmp",adbf)
use (cur_dir+"tmp") new alias TMP
index on shifr1 to (cur_dir+"tmp")
select U1K
find (uk->shifr)
if (fl_found := found())
  adbf := array(fcount())
  do while u1k->shifr == uk->shifr .and. !eof()
    aeval(adbf, {|x,i| adbf[i] := fieldget(i) } )
    select USL
    find (u1k->shifr1)
    select TMP
    append blank
    aeval(adbf, {|x,i| fieldput(i,x) } )
    tmp->rec_u1k := u1k->(recno())
    tmp->name := usl->name
    select U1K
    skip
  enddo
endif
select TMP
go top
if !fl_found ; keyboard chr(K_INS) ; endif
box_shadow(0,2,0,77,"GR+/RB","����ঠ��� �������᭮� ��㣨",,0)
Alpha_Browse(2,1,maxrow()-1,77,"f4_k_uslugi",color0,;
             alltrim(uk->shifr)+". "+alltrim(uk->name),"BG+/GR",;
             .t.,.t.,,,"f5_k_uslugi",,;
             {"�","�","�","N/BG,W+/N,B/BG",.t.,58} )
u1k->(dbCloseArea())
usl->(dbCloseArea())
tmp->(dbCloseArea())
select UK
restscreen(buf)
return NIL

*****
Function f4_k_uslugi(oBrow)
Local oColumn
oColumn := TBColumnNew("   ����", {|| tmp->shifr1 })
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("������������ ��㣨",64), {|| tmp->name })
oBrow:addColumn(oColumn)
status_key("^<Esc>^ - ��室;  ^<Ins>^ - ����������;  ^<Del>^ - 㤠�����")
return NIL

*****
Function f5_k_uslugi(nKey,oBrow)
LOCAL j := 0, k := -1, buf := save_maxrow(), buf1, fl := .f., rec,;
      tmp_color := setcolor(), r1 := maxrow()-9, c1 := 2, ;
      rec_uk := uk->(recno()), rec_tmp := tmp->(recno()),;
      rec_u1k := tmp->rec_u1k
do case
  case nKey == K_INS
    if !fl_found
      colorwin(5,0,5,79,"N/N","W+/N")
    endif
    Private mname := space(60),;
            mshifr := space(10),;
            gl_area := {1,0,maxrow()-1,79,0}
    buf1 := box_shadow(r1,c1,21,77,color8,;
             "���������� ����� ��㣨 � ����������",cDataPgDn)
    setcolor(cDataCGet)
    @ r1+2,pc1+3 say "���� ��㣨" get mshifr picture "@!" ;
                valid f6_k_uslugi()
    @ r1+3,pc1+3 say "������������ ��㣨"
    @ r1+4,pc1+5 get mname when .f.
    status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread()
    if lastkey() != K_ESC .and. !empty(mshifr) .and. f_Esc_Enter(1)
      mywait()
      select U1K
      AddRecN()
      fl_found := .t.
      replace u1k->shifr with uk->shifr, u1k->shifr1 with mshifr
      UNLOCK
      adbf := array(fcount())
      aeval(adbf, {|x,i| adbf[i] := fieldget(i) } )
      rec_u1k := u1k->(recno())
      select TMP
      append blank
      rec_tmp := tmp->(recno())
      aeval(adbf, {|x,i| fieldput(i,x) } )
      tmp->rec_u1k := u1k->(recno())
      tmp->name := mname
      COMMIT
      k := 0
    elseif !fl_found
      k := 1
    endif
    select TMP
    oBrow:goTop()
    goto (rec_tmp)
    setcolor(tmp_color)
    rest_box(buf) ; rest_box(buf1)
  case nKey == K_DEL .and. !empty(tmp->shifr) .and. f_Esc_Enter(2)
    mywait()
    select U1K
    goto (tmp->rec_u1k)
    DeleteRec(.t.)
    select TMP
    DeleteRec(.t.)
    COMMIT
    k := 0
    select TMP
    oBrow:goTop()
    go top
    if eof()
      fl_found := .f. ; k := 1
    endif
    rest_box(buf)
  otherwise
    keyboard ""
endcase
return k

*****
Function f6_k_uslugi()
Local fl := valid_shifr()
if fl
  select USL
  find (mshifr)
  if found()
    mname := usl->name
  else
    fl := func_error(4,"��� ⠪��� ��� � ���� ������ ���!")
  endif
endif
return fl

*

***** ������஢���� �����樥�⮢ ��㤮񬪮�� ��� (���)
Function f_trkoef()
Local uslugi := {{"kod",    "N", 4,0},;
                 {"name",   "C",65,0},;
                 {"shifr",  "C",10,0},;
                 {"vkoef_v","N",7,4},;   // ��� - ��� ��� ���᫮��
                 {"akoef_v","N",7,4},;   // ���. - ��� ��� ���᫮��
                 {"vkoef_r","N",7,4},;   // ��� - ��� ��� ॡ����
                 {"akoef_r","N",7,4},;   // ���. - ��� ��� ॡ����
                 {"koef_v", "N", 7,4},;
                 {"koef_r", "N", 7,4}}
Local k1, k2, buf := save_maxrow(), fl,;
      fl_plat := is_task(X_PLATN), ; // ��� ������ ���
      str_sem := "������஢���� �����樥�⮢ - UCH_USL"
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
mywait()
dbcreate(cur_dir+"tmp",uslugi)
use (cur_dir+"tmp") alias tmp
index on fsort_usl(shifr) to (cur_dir+"tmp")
if useUch_Usl() .and. R_Use(dir_server+"uslugi",,"USL")
  k1 := usl->(lastrec())
  k2 := uu->(lastrec())
  select UU
  do while k2 < k1
    G_RLock(.t.,forever)
    replace kod with recno()
    unlock
    k2++
  enddo
  select USL
  set relation to str(kod,4) into UU
  go top
  do while !eof()
    if usl->kod > 0
      fl := (usl->cena > 0 .or. usl->cena_d > 0)
      if !fl .and. fl_plat
        fl := (usl->pcena > 0 .or. usl->pcena_d > 0 .or. usl->dms_cena > 0)
      endif
      if !fl .and. (usl->is_nul .or. usl->is_nulp) // �᫨ �������� ���� ��㣨 ��� 業�
        fl := .t.
      endif
      if fl
        select TMP
        append blank
        tmp->kod     := usl->kod
        tmp->name    := usl->name
        tmp->shifr   := usl->shifr
        tmp->vkoef_v := uu->vkoef_v
        tmp->akoef_v := uu->akoef_v
        tmp->vkoef_r := uu->vkoef_r
        tmp->akoef_r := uu->akoef_r
        tmp->koef_v  := uu->koef_v
        tmp->koef_r  := uu->koef_r
      endif
    endif
    select USL
    skip
  enddo
  set relation to
  usl->(dbCloseArea())
  select TMP
  dbcommit()
  set relation to str(kod,4) into UU
  go top
  do while empty(shifr) .and. !eof()
    skip
  enddo
  Alpha_Browse(0,0,maxrow()-1,79,"f1_trkoef",color0,;
     "�᫮��� ������� ��㤮������ ��� ��� ������ � ��⥩","BG+/GR",;
     .f.,,,,"f2_trkoef",,;
     {"�","�","�","N/BG,W+/N,B/BG,BG+/B,GR+/BG,BG+/GR,R/BG,BG+/R",.t.,180} )
endif
close databases
rest_box(buf)
G_SUnLock(str_sem)
return NIL

*****
Function f1_trkoef(oBrow)
Local k := 51, oColumn, ;
      blk := {|| if(tmp->koef_v > 0 .and. tmp->koef_r > 0, {1,2},;
                   if(tmp->koef_v > 0, {3,4}, ;
                     if(tmp->koef_r > 0, {5,6}, {7,8}))) }
if is_oplata == 7
  k := 43
endif
oColumn := TBColumnNew("   ����;  ��㣨",{|| tmp->shifr })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("������������ ��㣨",k),{|| left(tmp->name,k) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
if is_oplata == 7
  oColumn := TBColumnNew("���;���;���.",{|| str(tmp->vkoef_v,5,2) })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew("���.;���;���.",{|| str(tmp->akoef_v,5,2) })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew("���;���;���.",{|| str(tmp->vkoef_r,5,2) })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew("���.;���;���.",{|| str(tmp->akoef_r,5,2) })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
else
  oColumn := TBColumnNew("���;���.",{|| tmp->koef_v })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew("���;���.",{|| tmp->koef_r })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
endif
status_key("^<Esc>^ - ��室;  ^<Enter>^ - ।���஢���� �����樥�⮢;  ^<F2>^ - ���� �� ����")
return NIL

*****
Function f2_trkoef(nKey,oBrow)
Static sshifr := "          "
LOCAL flag := -1, buf := save_maxrow(), tmp_color := setcolor(), ;
      mshifr, rec
if nKey == K_F2
  rec := recno()
  if (mshifr := input_value(18,10,20,69,color1,;
            "  ������ ����室��� ��� ��㣨 ��� ���᪠",;
            sshifr,"@K@!")) != NIL
    sshifr := mshifr := transform_shifr(mshifr)
    find (fsort_usl(mshifr))
    if found()
      rec := recno()
      oBrow:goTop()
      goto (rec)
      flag := 0
    else
      goto (rec)
      func_error(4,'��㣠 � ��஬ "'+alltrim(mshifr)+'" �� �������!')
    endif
  endif
elseif nKey == K_ENTER
  if (rec := f3_e_trk(row())) > 0
    select UU1
    goto (rec)
    select UU
    G_RLock(forever)
    if is_oplata == 7
      uu->vkoef_v := uu1->vkoef_v ; uu->vkoef_r := uu1->vkoef_r
      uu->akoef_v := uu1->akoef_v ; uu->akoef_r := uu1->akoef_r
    endif
    uu->koef_v := uu1->koef_v ; uu->koef_r := uu1->koef_r
    UnLock
    Commit
    select TMP
    if is_oplata == 7
      tmp->vkoef_v := uu->vkoef_v ; tmp->vkoef_r := uu->vkoef_r
      tmp->akoef_v := uu->akoef_v ; tmp->akoef_r := uu->akoef_r
    endif
    tmp->koef_v := uu->koef_v ; tmp->koef_r := uu->koef_r
  endif
  select TMP
  flag := 0
endif
return flag

*****
Function f2_e_trk()
Local rec := 0
select UU1
find (str(uu->kod,4))
do while uu1->kod == uu->kod .and. !eof()
  rec := uu1->(recno())
  skip
enddo
select UU
return rec

*****
Function f3_e_trk(r)
Local t_arr := array(BR_LEN), ret
Private str_find := str(uu->kod,4), muslovie := "uu->kod == uu1->kod"
if r > maxrow()/2
  t_arr[BR_TOP] := r-10
  t_arr[BR_BOTTOM] := r-1
else
  t_arr[BR_TOP] := r+1
  t_arr[BR_BOTTOM] := r+10
endif
t_arr[BR_LEFT] := 50
t_arr[BR_RIGHT] := 79
t_arr[BR_COLOR] := color5
t_arr[BR_ARR_BROWSE] := {"�","�","�",,.t.}
t_arr[BR_OPEN] := {|nk,ob| f4_e_trk(nk,ob,"open") }
t_arr[BR_ARR_BLOCK] := {{| | FindFirst(str_find)},;
                        {| | FindLast(str_find)},;
                        {|n| SkipPointer(n, muslovie)},;
                        str_find,muslovie;
                       }
t_arr[BR_COLUMN] := {{"   ���;  ��砫�; ����⢨�",{|| full_date(uu1->date_b) }}}
if is_oplata == 7
  t_arr[BR_LEFT] -= 6
  aadd(t_arr[BR_COLUMN],{"���;���;���.",{|| str(uu1->vkoef_v,5,2)}})
  aadd(t_arr[BR_COLUMN],{"���.;���;���.",{|| str(uu1->akoef_v,5,2)}})
  aadd(t_arr[BR_COLUMN],{"���;���;���.",{|| str(uu1->vkoef_r,5,2)}})
  aadd(t_arr[BR_COLUMN],{"���.;���;���.",{|| str(uu1->akoef_r,5,2)}})
else
  aadd(t_arr[BR_COLUMN],{"���;���.",{|| uu1->koef_v}})
  aadd(t_arr[BR_COLUMN],{"���;���.",{|| uu1->koef_r}})
endif
t_arr[BR_EDIT] := {|nk,ob| f4_e_trk(nk,ob,"edit") }
select UU1
find (str_find)
if !found()
  AddRec(4)
  uu1->kod := uu->kod ; uu1->date_b := stod("19930101")
  uu1->vkoef_v := uu->vkoef_v ; uu1->vkoef_r := uu->vkoef_r
  uu1->akoef_v := uu->akoef_v ; uu1->akoef_r := uu->akoef_r
  uu1->koef_v  := uu->koef_v  ; uu1->koef_r  := uu->koef_r
  UnLock
  Commit
endif
edit_browse(t_arr)
select UU
return f2_e_trk()

*****
Function f4_e_trk(nKey,oBrow,regim)
Local ret := -1
Local buf, fl := .f., rec, rec1, r1, r2, tmp_color
do case
  case regim == "open"
    find (str_find)
    if (ret := found())
      keyboard chr(K_CTRL_PGDN)  // ����� �� ��᫥���� (�� ���) ������
    endif
  case regim == "edit"
    do case
      case nKey == K_INS .or. (nKey == K_ENTER .and. !empty(uu1->kod))
        rec := recno()
        save screen to buf
        if nkey == K_INS .and. !fl_found
          colorwin(pr1+4,pc1,pr1+4,pc2,"W/W","GR+/R")
        endif
        Private gl_area := {1,0,maxrow()-1,79,0}, mpic := "99.99", mpic1 := "99.9999",;
                mdate_b  := if(nKey == K_INS, sys_date, uu1->date_b),;
                mvkoef_v := if(nKey == K_INS, 0, uu1->vkoef_v),;
                mvkoef_r := if(nKey == K_INS, 0, uu1->vkoef_r),;
                makoef_v := if(nKey == K_INS, 0, uu1->akoef_v),;
                makoef_r := if(nKey == K_INS, 0, uu1->akoef_r),;
                mkoef_v  := if(nKey == K_INS, 0, uu1->koef_v),;
                mkoef_r  := if(nKey == K_INS, 0, uu1->koef_r)
        if is_oplata == 7
          r1 := row()-3 ; r2 := r1+6
        else
          r1 := row()-2 ; r2 := r1+4
        endif
        tmp_color := setcolor(cDataCScr)
        box_shadow(r1,pc1-40,r2,pc1-1,,;
                       if(nKey == K_INS,"����������","������஢����"),;
                       cDataPgDn)
        setcolor(cDataCGet)
        @ r1+1,pc1-38 say "��� ��砫� ����⢨� ���" get mdate_b valid func_empty(mdate_b)
        if is_oplata == 7
          @ r1+2,pc1-38 say "��� �� ���᫮� �ਥ�� (���)" get mvkoef_v pict mpic
          @ r1+3,pc1-38 say "��� �� ���᫮� �ਥ�� (���)" get makoef_v pict mpic
          @ r1+4,pc1-38 say "��� �� ���᪮�  �ਥ�� (���.)" get mvkoef_r pict mpic
          @ r1+5,pc1-38 say "��� �� ���᪮�  �ਥ�� (���.)" get makoef_r pict mpic
        else
          @ r1+2,pc1-38 say "��� �� ���᫮� �ਥ��" get mkoef_v pict mpic1
          @ r1+3,pc1-38 say "��� �� ���᪮�  �ਥ��" get mkoef_r pict mpic1
        endif
        status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
        myread()
        if is_oplata == 7
          fl := !emptyall(mvkoef_v,makoef_v,mvkoef_r,makoef_r)
        else
          fl := !emptyall(mkoef_v,mkoef_r)
        endif
        if lastkey() != K_ESC .and. fl .and. f_Esc_Enter(1)
          if nKey == K_INS
            fl_found := .t.
            AddRec(4)
            replace uu1->kod with uu->kod
            rec := recno()
          else
            G_RLock(forever)
          endif
          replace uu1->date_b with mdate_b
          if is_oplata == 7
            uu1->vkoef_v := mvkoef_v ; uu1->vkoef_r := mvkoef_r
            uu1->akoef_v := makoef_v ; uu1->akoef_r := makoef_r
            mkoef_v := mvkoef_v + makoef_v
            mkoef_r := mvkoef_r + makoef_r
          endif
          uu1->koef_v := mkoef_v ; uu1->koef_r := mkoef_r
          UnLock
          COMMIT
          oBrow:goTop()
          goto (rec)
          ret := 0
        elseif nKey == K_INS .and. !fl_found
          ret := 1
        endif
        setcolor(tmp_color)
        restore screen from buf
      case nKey == K_DEL .and. !empty(uu1->kod) .and. f_Esc_Enter(2)
        DeleteRec()
        oBrow:goTop()
        ret := 0
        if eof() .or. !&muslovie
          ret := 1
        endif
    endcase
endcase
return ret

*

***** �������� ����筠� ��㤮������� ���ᮭ���
Function f_trpers()
Static si := 1
Local i, arr_m, mtitle, k1, k2, buf := save_maxrow(),;
      str_sem := "������஢���� �������� ��㤮������ - UCH_PERS"
if (i := popup_prompt(T_ROW,T_COL+5,si,{"�।�������� ���",;
                                        "��� �� ������� �����"})) == 0
  return NIL
endif
si := i
Private lgod := 0, lmes := 0
if i == 1
  mtitle := "������� �।�������� ��� ���ᮭ���"
else
  if (arr_m := year_month(T_ROW,T_COL+5,,3)) == NIL
    return NIL
  endif
  lgod := arr_m[1]
  lmes := arr_m[2]
  mtitle := "������� ��� ���ᮭ��� "+arr_m[4]
endif
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
mywait()
if G_Use(dir_server+"uch_pers",dir_server+"uch_pers","UCHP") .and. ;
   R_Use(dir_server+"mo_pers",,"PERSO")
  index on str(kod,4) to (cur_dir+"tmp_pers") for kod > 0
  select UCHP
  set order to 0
  go top
  do while !eof()
    if empty(uchp->m_trud)
      DeleteRec(.t.)
    else
      select PERSO
      find (str(uchp->kod,4))
      if !found()
        select UCHP
        DeleteRec(.t.)
      endif
    endif
    select UCHP
    skip
  enddo
  Commit
  set order to 1
  select PERSO
  go top
  do while !eof()
    select UCHP
    find (str(perso->kod,4)+str(lgod,4)+str(lmes,2))
    if !found()
      AddRec(4)
      uchp->kod := perso->kod
      uchp->god := lgod
      uchp->mes := lmes
      UnLock
    endif
    select PERSO
    skip
  enddo
  Commit
  select UCHP
  set relation to str(kod,4) into PERSO
  index on upper(perso->fio) to (cur_dir+"tmp_uch") for god == lgod .and. mes == lmes
  set index to (cur_dir+"tmp_uch"),(dir_server+"uch_pers")
  go top
  Alpha_Browse(2,2,maxrow()-2,77,"f1_trpers",color0,mtitle,"BG+/GR",;
               .f.,,,,"f2_trpers",,{,,,"N/BG,W+/N,B/BG,BG+/B",.t.,180} )
endif
close databases
rest_box(buf)
G_SUnLock(str_sem)
return NIL

*****
Function f1_trpers(oBrow)
Local oColumn, blk := {|| if(uchp->m_trud > 0, {1,2}, {3,4} ) }
oColumn := TBColumnNew("���.�",;
           {|| iif(perso->tab_nom > 0, str(perso->tab_nom,5), "-----") })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("�.�.�.",50),{|| perso->fio })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("�.�.�.",{|| uchp->m_trud })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
status_key("^<Esc>^ - ��室;  ^<Enter>^ - ।���஢���� �������� ���")
return NIL

*****
Function f2_trpers(nKey,oBrow)
LOCAL flag := -1, buf := save_maxrow(), tmp_color := setcolor(), ;
      mshifr, rec
Private mm_trud
if nKey == K_ENTER .or. between(nKey,48,57)
  if empty(perso->tab_nom)
    keyboard ""
    return flag
  endif
  setcolor("GR+/RB,GR+/RB,,,G+/RB")
  mm_trud := uchp->m_trud
  if between(nKey,48,57)
    keyboard chr(nkey)
  endif
  @ row(),67 get mm_trud
  status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� ᬥ�� ���")
  myread()
  if lastkey() != K_ESC .and. updated()
    select UCHP
    G_RLock(forever)
    uchp->m_trud := mm_trud
    UnLock
    Commit
  endif
  rest_box(buf)
  setcolor(tmp_color) ; flag := 0
endif
return flag

*

***** ������஢���� �ࠢ�筨�� ���, ����� �� ������ ���� ������� � ���� ����
Function f_ns_uslugi()
Local str_sem, r1 := T_ROW
Private pr1 := r1, pc1 := T_COL+5, pc2 := T_COL+5+33, fl_found := .t.
str_sem := "������஢���� ��ᮢ���⨬�� ���"
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
G_Use(dir_server+"ns_usl",,"UK")
index on upper(name) to (cur_dir+"tmp_usl")
go top
if eof()
  fl_found := .f.
  keyboard chr(K_INS)
endif
Alpha_Browse(pr1,pc1,maxrow()-2,pc2,"f1_ns_uslugi",color0,,,,,,,"f2_ns_uslugi",,;
             {,,,,.t.} )
close databases
G_SUnLock(str_sem)
return NIL

*****
Function f1_ns_uslugi(oBrow)
Local oColumn
oColumn := TBColumnNew(center("��ᮢ���⨬� ��㣨",30), {|| uk->name })
oBrow:addColumn(oColumn)
status_key("^<Esc>^ ��室; ^<Enter>^ ।-���; ^<Ins>^ ����������; ^<Del>^ 㤠�.; ^<Ctrl+Enter>^ ��㣨")
return NIL

*****
Function f2_ns_uslugi(nKey,oBrow)
Local buf, fl := .f., rec, rec1, k := -1, r := maxrow()-7, tmp_color
Local sh := 80, HH := 57
do case
  case nKey == K_F9
    buf := save_maxrow()
    rec := recno()
    mywait()
    fp := fcreate("n_uslugi"+stxt) ; n_list := 1 ; tek_stroke := 0
    add_string("")
    add_string(center("��㣨, �� ᮢ���⨬� �� ���",sh))
    R_Use(dir_server+"uslugi",dir_server+"uslugish","USL")
    R_Use(dir_server+"ns_usl_k",dir_server+"ns_usl_k","U1K")
    set relation to shifr into USL
    select UK
    go top
    do while !eof()
      verify_FF(HH-3, .t., sh)
      add_string("")
      add_string(rtrim(uk->name))
      select U1K
      find (str(uk->(recno()),6))
      do while u1k->kod == uk->(recno()) .and. !eof()
        verify_FF(HH, .t., sh)
        add_string("   "+u1k->shifr+" "+rtrim(usl->name))
        skip
      enddo
      select UK
      skip
    enddo
    fclose(fp)
    viewtext("n_uslugi"+stxt,,,,,,,2)
    usl->(dbCloseArea())
    u1k->(dbCloseArea())
    select UK
    goto (rec)
    rest_box(buf)
  case nKey == K_INS .or. (nKey == K_ENTER .and. !empty(uk->name))
    save screen to buf
    if nkey == K_INS .and. !fl_found
      colorwin(pr1+3,pc1,pr1+3,pc2,"N/N","W+/N")
    endif
    if nKey == K_ENTER
      rec := recno()
    endif
    Private mname, gl_area := {1,0,maxrow()-1,79,0}
    mname := if(nKey == K_INS, space(30), uk->name)
    tmp_color := setcolor(cDataCScr)
    box_shadow(r,pc1+1,maxrow()-3,pc2-1,,;
              if(nKey==K_INS,"����������","������஢����"),cDataPgDn)
    setcolor(cDataCGet)
    @ r+2,pc1+3 say "������������"
    @ r+3,pc1+3 get mname pict "@S29"
    status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread()
    if lastkey() != K_ESC .and. !empty(mname) .and. f_Esc_Enter(1)
      mywait()
      if nKey == K_INS
        AddRecN()
        fl_found := .t.
        rec := recno()
      else
        G_RLock(forever)
      endif
      replace uk->name with mname
      UNLOCK
      COMMIT
      oBrow:gotop()
      goto (rec)
      k := 0
    elseif nKey == K_INS .and. !fl_found
      k := 1
    endif
    setcolor(tmp_color)
    restore screen from buf
  case nKey == K_DEL .and. !empty(uk->name) .and. f_Esc_Enter(2,.t.)
    buf := save_maxrow()
    mywait()
    G_Use(dir_server+"ns_usl_k",dir_server+"ns_usl_k","U1K")
    do while .t.
      find (str(uk->(recno()),6))
      if !found() ; exit ; endif
      DeleteRec(.t.)
    enddo
    u1k->(dbCloseArea())
    select UK
    DeleteRec()
    oBrow:gotop()
    go top
    k := 0
    if eof()
      k := 1
    endif
    rest_box(buf)
  case nKey == K_CTRL_ENTER .and. !empty(uk->name)
    f3_ns_uslugi()
    k := 0
endcase
return k

*****
Function f3_ns_uslugi()
Local buf := savescreen(), adbf
Private fl_found
mywait()
R_Use(dir_server+"uslugi",dir_server+"uslugish","USL")
G_Use(dir_server+"ns_usl_k",dir_server+"ns_usl_k","U1K")
adbf := dbstruct()
aadd(adbf, {"rec_u1k","N",6,0} )
aadd(adbf, {"name","C",64,0} )
dbcreate(cur_dir+"tmp",adbf)
use (cur_dir+"tmp") new alias TMP
index on shifr to (cur_dir+"tmp")
select U1K
find (str(uk->(recno()),6))
if (fl_found := found())
  do while u1k->kod == uk->(recno()) .and. !eof()
    select USL
    find (u1k->shifr)
    select TMP
    append blank
    tmp->kod := uk->(recno())
    tmp->shifr := u1k->shifr
    tmp->rec_u1k := u1k->(recno())
    tmp->name := usl->name
    select U1K
    skip
  enddo
endif
select TMP
go top
if !fl_found ; keyboard chr(K_INS) ; endif
box_shadow(0,2,0,77,"GR+/RB","���᮪ ��ᮢ���⨬�� ���",,0)
Alpha_Browse(2,1,maxrow()-1,77,"f4_ns_uslugi",color0,alltrim(uk->name),"BG+/GR",;
             .t.,.t.,,,"f5_ns_uslugi",,;
             {"�","�","�","N/BG,W+/N,B/BG",.t.,58} )
u1k->(dbCloseArea())
usl->(dbCloseArea())
tmp->(dbCloseArea())
select UK
restscreen(buf)
return NIL

*****
Function f4_ns_uslugi(oBrow)
Local oColumn
oColumn := TBColumnNew("   ����", {|| tmp->shifr })
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("������������ ��㣨",64), {|| tmp->name })
oBrow:addColumn(oColumn)
status_key("^<Esc>^ - ��室;  ^<Ins>^ - ����������;  ^<Del>^ - 㤠�����")
return NIL

*****
Function f5_ns_uslugi(nKey,oBrow)
LOCAL j := 0, k := -1, buf := save_maxrow(), buf1, fl := .f., rec,;
      tmp_color := setcolor(), r1 := maxrow()-10, c1 := 2, ;
      rec_uk := uk->(recno()), rec_tmp := tmp->(recno()),;
      rec_u1k := tmp->rec_u1k
do case
  case nKey == K_INS
    if !fl_found
      colorwin(5,0,5,79,"N/N","W+/N")
    endif
    Private mname := space(60),;
            mshifr := space(10),;
            gl_area := {1,0,maxrow()-1,79,0}
    buf1 := box_shadow(r1,c1,maxrow()-3,77,color8,;
             "���������� ����� ��㣨 � ᯨ᮪ ��ᮢ���⨬��",cDataPgDn)
    setcolor(cDataCGet)
    @ r1+2,pc1+3 say "���� ��㣨" get mshifr picture "@!" ;
                valid f6_ns_uslugi()
    @ r1+3,pc1+3 say "������������ ��㣨"
    @ r1+4,pc1+5 get mname when .f.
    status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread()
    if lastkey() != K_ESC .and. !empty(mshifr) .and. f_Esc_Enter(1)
      mywait()
      select U1K
      AddRecN()
      fl_found := .t.
      replace u1k->kod with uk->(recno()), u1k->shifr with mshifr
      UNLOCK
      rec_u1k := u1k->(recno())
      select TMP
      append blank
      rec_tmp := tmp->(recno())
      tmp->kod := uk->(recno())
      tmp->shifr := mshifr
      tmp->name := mname
      tmp->rec_u1k := u1k->(recno())
      COMMIT
      k := 0
    elseif !fl_found
      k := 1
    endif
    select TMP
    oBrow:goTop()
    goto (rec_tmp)
    setcolor(tmp_color)
    rest_box(buf) ; rest_box(buf1)
  case nKey == K_DEL .and. !empty(tmp->shifr) .and. f_Esc_Enter(2)
    mywait()
    select U1K
    goto (tmp->rec_u1k)
    DeleteRec(.t.)
    select TMP
    DeleteRec(.t.)
    COMMIT
    k := 0
    select TMP
    oBrow:goTop()
    go top
    if eof()
      fl_found := .f. ; k := 1
    endif
    rest_box(buf)
  otherwise
    keyboard ""
endcase
return k

*****
Function f6_ns_uslugi()
Local fl := valid_shifr()
if fl
  select USL
  find (mshifr)
  if found()
    mkod := usl->kod
    mname := usl->name
  else
    fl := func_error(4,"��� ⠪��� ��� � ���� ������ ���!")
  endif
endif
return fl

*

***** ����/।���஢���� ���, � ������ �� �������� ��� (����⥭�)
Function f_usl_uva()
Local t_arr[BR_LEN], ;
      mtitle := "��㣨, ��� �� �������� ��� (���.)"
t_arr[BR_TOP] := T_ROW
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := T_COL+5
t_arr[BR_RIGHT] := t_arr[BR_LEFT] + 41
t_arr[BR_OPEN] := {|| f1_usl_uva(,,"open") }
t_arr[BR_CLOSE] := {|| dbCloseAll() }
t_arr[BR_SEMAPHORE] := mtitle
t_arr[BR_COLOR] := color0
t_arr[BR_TITUL] := mtitle
t_arr[BR_TITUL_COLOR] := "B/BG"
t_arr[BR_ARR_BROWSE] := {,,,,.t.}
t_arr[BR_COLUMN] := {{ "   ����", {|| dbf1->shifr } },;
          { "��� ���?", {|| padc(if(dbf1->kod_vr==1,"**",""),10) } },;
          { "���-� ���?", {|| padc(if(dbf1->kod_as==1,"**",""),12) } }}
t_arr[BR_EDIT] := {|nk,ob| f1_usl_uva(nk,ob,"edit") }
edit_browse(t_arr)
return NIL

*****
Function f1_usl_uva(nKey,oBrow,regim,lrec)
Local ret := -1, mm_da_net := {{"�� ",0},{"���",1}}
Local buf, fl := .f., rec, rec1, k := maxrow()-7, tmp_color
do case
  case regim == "open"
    G_Use(dir_server+"usl_uva",dir_server+"usl_uva","DBF1")
    go top
    if (ret := !eof()) .and. lrec != NIL .and. lrec > 0
      goto (lrec)
    endif
  case regim == "edit"
    do case
      case nKey == K_INS .or. (nKey == K_ENTER .and. !empty(dbf1->shifr))
        save screen to buf
        if nkey == K_INS .and. !fl_found
          colorwin(pr1+3,pc1,pr1+3,pc2,"N/N","W+/N")
        endif
        Private gl_area := {1,0,maxrow()-1,79,0},;
          mshifr := if(nKey == K_INS, space(10), dbf1->shifr),;
          mkod_vr, m1kod_vr := if(nKey == K_INS, 0, dbf1->kod_vr),;
          mkod_as, m1kod_as := if(nKey == K_INS, 0, dbf1->kod_as)
        tmp_color := setcolor(cDataCScr)
        mkod_vr := inieditspr(A__MENUVERT, mm_da_net, m1kod_vr)
        mkod_as := inieditspr(A__MENUVERT, mm_da_net, m1kod_as)
        box_shadow(k,pc1+1,maxrow()-3,pc2-1,,;
                       if(nKey == K_INS,"����������","������஢����"),;
                       cDataPgDn)
        setcolor(cDataCGet)
        @ k+1,pc1+3 say "���� ��㣨 (蠡���)" get mshifr ;
                    valid {|g| f2_usl_diag(g,nKey) }
        @ k+2,pc1+3 say "�������� ��� ���" get mkod_vr ;
               reader {|x|menu_reader(x,mm_da_net,A__MENUVERT,,,.f.)}
        @ k+3,pc1+3 say "�������� ��� ����⥭�" get mkod_as ;
               reader {|x|menu_reader(x,mm_da_net,A__MENUVERT,,,.f.)}
        status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
        myread()
        if lastkey() != K_ESC .and. !empty(mshifr) ;
                      .and. !emptyall(m1kod_vr,m1kod_as) ;
                      .and. f_Esc_Enter(1)
          if nKey == K_INS
            fl_found := .t.
            AddRecN()
          else
            G_RLock(forever)
          endif
          replace dbf1->shifr with mshifr, ;
                  dbf1->kod_vr with m1kod_vr, dbf1->kod_as with m1kod_as
          UNLOCK
          COMMIT
          oBrow:goTop()
          find (mshifr)
          ret := 0
        elseif nKey == K_INS .and. !fl_found
          ret := 1
        endif
        setcolor(tmp_color)
        restore screen from buf
      case nKey == K_DEL .and. !empty(dbf1->shifr) .and. f_Esc_Enter(2)
        DeleteRec()
        oBrow:goTop()
        ret := 0
        if eof()
          ret := 1
        endif
    endcase
endcase
return ret

*****
Function f2_usl_diag(get,nKey)
Local fl := .t., rec := 0
mshifr := transform_shifr(mshifr)
if mshifr != get:original
  rec := recno()
  find (mshifr)
  if found()
    fl := func_error(4,"����� ��� 㦥 ��������� � �ࠢ�筨��!")
  endif
  goto (rec)
  if !fl
    mshifr := get:original
  endif
endif
return fl

*

***** ����/।���஢���� ���, ����� ����� ���� ������� 祫����� ⮫쪮 ࠧ � ����
Function f_usl_raz()
Local buf := savescreen(), adbf, i, n_file := dir_server+"usl1year"+smem
Private fl_found := .f., arr_usl1year := {}
if hb_fileExists(n_file)
  arr_usl1year := rest_arr(n_file)
endif
mywait()
R_Use(dir_server+"uslugi",dir_server+"uslugish","USL")
adbf := {{"kod","N",4,0},;
         {"shifr","C",10,0},;
         {"name","C",64,0}}
dbcreate(cur_dir+"tmp",adbf)
use (cur_dir+"tmp") new alias TMP
index on fsort_usl(shifr) to (cur_dir+"tmp")
for i := 1 to len(arr_usl1year)
  fl_found := .t.
  select USL
  goto (arr_usl1year[i])
  select TMP
  append blank
  tmp->kod := arr_usl1year[i]
  tmp->shifr := usl->shifr
  tmp->name := usl->name
next
select TMP
go top
if !fl_found ; keyboard chr(K_INS) ; endif
box_shadow(0,2,0,77,"GR+/RB","���᮪ ���, ����� ࠧ�蠥��� ������� ⮫쪮 ࠧ � ����",,0)
Alpha_Browse(2,1,maxrow()-1,77,"f4_ns_uslugi",color0,,,.t.,.t.,,,"f1_usl_raz",,;
             {"�","�","�","N/BG,W+/N,B/BG",.t.,58} )
close databases
restscreen(buf)
if f_Esc_Enter(1)
  arr_usl1year := {}
  use (cur_dir+"tmp")
  go top
  do while !eof()
    if !empty(tmp->kod)
      aadd(arr_usl1year, tmp->kod )
    endif
    skip
  enddo
  save_arr(arr_usl1year,n_file)
endif
close databases
return NIL

*****
Function f1_usl_raz(nKey,oBrow)
LOCAL j := 0, k := -1, buf := save_maxrow(), buf1, fl := .f., rec,;
      tmp_color := setcolor(), r1 := maxrow()-10, c1 := 2, ;
      rec_tmp := tmp->(recno())
do case
  case nKey == K_INS
    if !fl_found
      colorwin(5,0,5,79,"N/N","W+/N")
    endif
    Private mkod := 0,;
            mname := space(60),;
            mshifr := space(10),;
            gl_area := {1,0,maxrow()-1,79,0}
    buf1 := box_shadow(r1,c1,maxrow()-3,77,color8,;
             "���������� ����� ��㣨 � ᯨ᮪",cDataPgDn)
    setcolor(cDataCGet)
    @ r1+2,pc1+3 say "���� ��㣨" get mshifr picture "@!" ;
                valid f6_ns_uslugi()
    @ r1+3,pc1+3 say "������������ ��㣨"
    @ r1+4,pc1+5 get mname when .f.
    status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread()
    if lastkey() != K_ESC .and. !empty(mshifr) .and. f_Esc_Enter(1)
      mywait()
      select TMP
      append blank
      tmp->kod := mkod
      tmp->shifr := mshifr
      tmp->name := mname
      rec_tmp := tmp->(recno())
      COMMIT
      k := 0
    elseif !fl_found
      k := 1
    endif
    select TMP
    oBrow:goTop()
    goto (rec_tmp)
    setcolor(tmp_color)
    rest_box(buf) ; rest_box(buf1)
  case nKey == K_DEL .and. !empty(tmp->shifr) .and. f_Esc_Enter(2)
    mywait()
    select TMP
    DeleteRec(.t.)
    COMMIT
    k := 0
    select TMP
    oBrow:goTop()
    go top
    if eof()
      fl_found := .f. ; k := 1
    endif
    rest_box(buf)
  otherwise
    keyboard ""
endcase
return k

*

*****
Function f5_uslugi(r1,c1)
Local c2 := c1 + 50, str_sem := "������஢���� �㦡"
Private pr1 := r1, pc1, pc2
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
if c2 > 77
  c2 := 77 ; c1 := 27
endif
pc1 := c1 ; pc2 := c2
G_Use(dir_server+"slugba",dir_server+"slugba","SL")
go top
if lastrec() == 0
  AddRec(3)
  UnLock
  keyboard chr(K_INS)
elseif lastrec() == 1 .and. sl->shifr == 0 .and. empty(sl->name)
  keyboard chr(K_INS)
endif
Alpha_Browse(r1,c1,maxrow()-2,c2,"f51_uslugi",color0,,,,,,,"f52_uslugi",,;
             {,,,,.t.} )
Use
G_SUnLock(str_sem)
return NIL

*****
Function f51_uslugi(oBrow)
Local oColumn
oColumn := TBColumnNew("����", {|| sl->shifr })
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("������������ �㦡�",40), {|| sl->name })
oBrow:addColumn(oColumn)
if type("pr1") == "N"
  status_key("^<Esc>^ - ��室;  ^<Enter>^ - ।���஢����;  ^<Ins>^ - ����������;  ^<Del>^ - 㤠�����")
else
  status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮� �㦡�")
endif
return NIL

*****
Function f52_uslugi(nKey,oBrow)
Local buf, fl := .f., rec, rec1, k := maxrow()-7, tmp_color
do case
  case nKey == K_INS .or. nKey == K_ENTER
    save screen to buf
    if nkey == K_INS .and. lastrec() == 1 .and. sl->shifr == 0 .and. empty(sl->name)
      colorwin(pr1+3,pc1,pr1+3,pc2,"N/N","W+/N")
    endif
    if nKey == K_ENTER
      rec := recno()
    endif
    Private mshifr, mname, gl_area := {1,0,maxrow()-1,79,0}, old_shifr
    old_shifr := mshifr := if(nKey == K_INS, 0, sl->shifr)
    mname := if(nKey == K_INS, space(40), sl->name)
    tmp_color := setcolor(cDataCScr)
    box_shadow(k,pc1+1,maxrow()-3,pc2-1,,;
              if(nKey==K_INS,"����������","������஢����")+" �㦡�",cDataPgDn)
    setcolor(cDataCGet)
    @ k+1,pc1+3 say "���� �㦡�" get mshifr picture "999"
    @ k+2,pc1+3 say "������������ �㦡�"
    @ k+3,pc1+5 get mname valid func_empty(mname)
    status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
    myread()
    k := -1
    if lastkey() != K_ESC
      fl := .t.
      if nKey == K_ENTER .and. old_shifr != mshifr
        find (str(mshifr,3))
        do while sl->shifr == mshifr .and. !eof()
          if recno() != rec
            fl := func_error(4,"��㦡� � ����� ��஬ 㦥 ��������� � ���� ������!")
            exit
          endif
          skip
        enddo
        goto (rec)
      endif
      if fl .and. f_Esc_Enter(1)
        mywait()
        if nKey == K_INS
          fl := .f.
          if lastrec() == 1
            go top
            if sl->shifr == 0 .and. empty(sl->name)
              G_RLock(forever)
              fl := .t.
            endif
          endif
          if !fl
            AddRec(3)
          endif
        else
          G_RLock(forever)
        endif
        replace sl->shifr with mshifr, sl->name with mname
        UNLOCK
        COMMIT
        if nKey == K_ENTER .and. old_shifr != mshifr
          G_Use(dir_server+"uslugi",{dir_server+"uslugisl"},"USL")
          do while .t.
            find (str(old_shifr,3))
            if !found() ; exit ; endif
            G_RLock(forever)
            usl->slugba := mshifr
            UnLock
          enddo
          usl->(dbCloseArea())
          select SL
        endif
        oBrow:gotop()
        find (str(mshifr,3))
        k := 0
      endif
    elseif nKey == K_INS .and. lastrec() == 1
      go top
      if sl->shifr == 0 .and. empty(sl->name)
        k := 1
      endif
    endif
    setcolor(tmp_color)
    restore screen from buf
    return k
  case nKey == K_DEL .and. !empty(sl->name) .and. f_Esc_Enter(2)
    R_Use(dir_server+"uslugi",{dir_server+"uslugisl"},"USL")
    find (str(sl->shifr,3))
    fl := found()
    Use
    select SL
    if fl
      func_error(4,"������ �㦡� ��������� � �ࠢ�筨�� ���. �������� ����饭�!")
    else
      DeleteRec()
      return 0
    endif
endcase
return -1

*

***** ��稥 �ࠢ�筨��
Function edit_proch_spr(k)
Static sk1 := 1, sk2 := 1
Local str_sem, mas_pmt, mas_msg, mas_fun, j
DEFAULT k TO 0
do case
  case k == 0
    mas_pmt := {"�����ப� ~����",;
                "�����ப� ~���� ࠡ���",;
                "��� ~�뤠� ���㬥��",;
                "~��稥 ��������",;
                "~������� (��)",;
                "�~�ࠧ���⥫�� ��०�����",;
                "��樮���� ��⥩-~���"}
    mas_msg := {"������஢���� �ࠢ�筨�� �����ப� ����",;
                "������஢���� �ࠢ�筨�� �����ப� ���� ࠡ���",;
                "������஢���� �ࠢ�筨�� �࣠����権, �뤠��� ���㬥���",;
                "������஢���� ���ଠ樨 �� ��稬 ��������",;
                "������஢���� ���ଠ樨 �� �����⠬ ��ࠢ���࠭���� (��)",;
                "������஢���� �ࠢ�筨�� ��ࠧ���⥫��� ��०�����",;
                "������஢���� �ࠢ�筨�� ��樮��஢ ��⥩-���"}
    mas_fun := {"edit_proch_spr(1)",;
                "edit_proch_spr(2)",;
                "edit_proch_spr(3)",;
                "edit_proch_spr(4)",;
                "edit_proch_spr(5)",;
                "edit_proch_spr(6)",;
                "edit_proch_spr(7)"}
    if eq_any(is_oplata,5,6,7)
      aadd(mas_pmt, "���ᮡ ~������")
      aadd(mas_msg, "���� / ।���஢���� �ࠢ�筨��� ��� ��襣� ᯮᮡ� ������")
      if eq_any(is_oplata,5,6)
        aadd(mas_fun, "spr_opl_5()")
      elseif is_oplata == 7
        aadd(mas_fun, "spr_opl_7()")
      endif
    endif
    popup_prompt(T_ROW, T_COL+5, sk1, mas_pmt, mas_msg, mas_fun)
  case k == 1
    edit_s_adres()
  case k == 2
    str_sem := "������஢���� ���� ࠡ���"
    if G_SLock(str_sem)
      popup_edit(dir_server+"s_mr",T_ROW,T_COL+5,maxrow()-2,,1)
      G_SUnLock(str_sem)
    else
      func_error(4,err_slock)
    endif
  case k == 3
    mas_pmt := {"~������஢����",;
                "�������� ~�㡫���⮢"}
    mas_msg := {"������஢���� �ࠢ�筨�� �࣠����権, �뤠��� ���㬥���",;
                "�������� �㡫���⮢ �࣠����権"}
    mas_fun := {"edit_proch_spr(11)",;
                "edit_proch_spr(12)"}
    popup_prompt(T_ROW, T_COL+5, sk2, mas_pmt, mas_msg, mas_fun)
  case k == 4
    edit_strah()
  case k == 5
    edit_komit()
  case k == 6
    edit_school()
  case k == 7
    edit_dds_stac()
  case k == 11
    fedit_s_kem()
  case k == 12
    fdeld_s_kem()
endcase
if between(k,1,10)
  sk1 := k
elseif between(k,11,20)
  sk2 := k
endif
return NIL

*

***** �ࠢ�筨� �����ப� ����
Function edit_s_adres()
Local t_arr[BR_LEN], buf := savescreen()
t_arr[BR_TOP] := 2
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := T_COL+5
t_arr[BR_RIGHT] := t_arr[BR_LEFT] + 43
t_arr[BR_OPEN] := {|| f1_s_adres(,,"open") }
t_arr[BR_CLOSE] := {|| sa->(dbCloseArea()) }
t_arr[BR_SEMAPHORE] := "������஢���� ����"
t_arr[BR_COLOR] := color0
t_arr[BR_ARR_BROWSE] := {,,,,.t.,60}
t_arr[BR_COLUMN] := {{ center("�����ப� ����",40),{||sa->name} }}
t_arr[BR_EDIT] := {|nk,ob| f1_s_adres(nk,ob,"edit") }
edit_browse(t_arr)
restscreen(buf)
return NIL

*****
Function f1_s_adres(nKey,oBrow,regim)
Local ret := -1, j := 0, flag := -1, buf := save_maxrow(), buf1, ;
      fl := .f., rec, mkod, tmp_color := setcolor()
do case
  case regim == "open"
    G_Use(dir_server+"s_adres",dir_server+"s_adres","SA")
    go top
    ret := !eof()
  case regim == "edit"
    if nKey == K_INS .or. (nKey == K_ENTER .and. !empty(sa->name))
      rec := recno()
      Private mname := if(nKey == K_INS, space(40), sa->name),;
              gl_area := {1,0,maxrow()-1,79,0}
      buf1 := box_shadow(pr2-3,pc1+1,pr2-1,pc2-1,color8,;
                    iif(nKey==K_INS,"����������","������஢����"),cDataPgDn)
      setcolor(cDataCGet)
      @ pr2-2,pc1+2 get mname
      status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
      myread()
      if lastkey() != K_ESC .and. !empty(mname)
        if nKey == K_INS
          AddRecN()
          rec := recno()
        else
          G_RLock(forever)
        endif
        replace name with mname
        COMMIT
        UNLOCK
        oBrow:goTop()
        goto (rec)
        ret := 0
      endif
      setcolor(tmp_color)
      rest_box(buf) ; rest_box(buf1)
    elseif nKey == K_DEL .and. !empty(sa->name) .and. f_Esc_Enter(2)
      DeleteRec()
      oBrow:goTop()
      ret := 0
    else
      keyboard ""
    endif
endcase
return ret

*

*****
Function fedit_s_kem()
Local t_arr[BR_LEN], buf := savescreen()
t_arr[BR_TOP] := 2
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := 4
t_arr[BR_RIGHT] := 77
t_arr[BR_OPEN] := {|| f1_s_kemvyd(,,"open") }
t_arr[BR_CLOSE] := {|| sa->(dbCloseArea()) }
t_arr[BR_SEMAPHORE] := "��� �����"
t_arr[BR_COLOR] := color0
t_arr[BR_ARR_BROWSE] := {,,,,.t.,60}
t_arr[BR_COLUMN] := {{ center("������������ �࣠����権, �뤠��� ���㬥���",70),{|| padr(sa->name,70) } }}
t_arr[BR_STAT_MSG] := {|| status_key("^<Esc>^ ��室 ^<Enter>^ ।-�� ^<Del>^ 㤠����� ^<Ins>^ ���������� ^<F2>^ ����") }
t_arr[BR_EDIT] := {|nk,ob| f1_s_kemvyd(nk,ob,"edit",1) }
edit_browse(t_arr)
restscreen(buf)
return NIL

***** 12.07.17
Function f1_s_kemvyd(nKey,oBrow,regim,par)
Local ret := -1, j := 0, flag := -1, buf := save_maxrow(), buf1, ;
      fl := .f., rec, mkod, tmp_color := setcolor()
do case
  case regim == "open"
    G_Use(dir_server+"s_kemvyd",dir_server+"s_kemvyd","SA")
    go top
    if par != NIL .and. par > 0
      goto (par)
      if deleted() .or. eof()
        go top
      endif
    endif
    ret := !eof()
  case regim == "edit"
    if nKey == K_INS .or. (nKey == K_ENTER .and. !empty(sa->name))
      rec := recno()
      Private mname := iif(nKey == K_INS, space(150), sa->name), gl_area := {1,0,maxrow()-1,79,0}
      buf1 := box_shadow(pr2-3,pc1+1,pr2-1,pc2-1,color8,;
                         iif(nKey==K_INS,"����������","������஢����"),cDataPgDn)
      setcolor(cDataCGet)
      @ pr2-2,pc1+2 get mname pict "@S70"
      status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
      myread()
      if lastkey() != K_ESC .and. !empty(mname)
        if nKey == K_INS
          AddRecN()
          rec := recno()
        else
          G_RLock(forever)
        endif
        replace name with mname
        COMMIT
        UNLOCK
        oBrow:goTop()
        goto (rec)
        ret := 0
      endif
      setcolor(tmp_color)
      rest_box(buf) ; rest_box(buf1)
    elseif nKey == K_SPACE .and. par == 2
      _fl_space := .t.
      ret := 1
    elseif nKey == K_DEL .and. !empty(sa->name) .and. f_Esc_Enter(2)
      if yes_d_kemvyd(sa->(recno()))
        DeleteRec()
        oBrow:goTop()
        ret := 0
      endif
    elseif nKey == K_F2
      if (rec := poisk_kemvyd(pr1)) != NIL
        oBrow:goTop()
        goto (rec)
        ret := 0
      endif
    else
      keyboard ""
    endif
endcase
return ret

*****
Function poisk_kemvyd(mr1)
Static tmp := ""
Local ret, rec := sa->(recno()), buf := savescreen(), i, tmp1
do while .t.
  tmp1 := padr(tmp,50)
  setcolor(color8)
  box_shadow(13,14,18,67)
  @ 15,15 say center("������ �����ப� ���᪠",52)
  status_key("^<Esc>^ - �⪠�;  ^<Enter>^ - ����")
  @ 16,16 get tmp1 picture "@K@!"
  myread()
  setcolor(color0)
  if lastkey() == K_ESC .or. empty(tmp1)
    exit
  endif
  mywait()
  tmp := alltrim(tmp1)
  i := 0
  Private tmp_mas := {}, tmp_kod := {}, t_len, k1 := mr1+3, k2 := 21, tmp2 := upper(tmp)
  go top
  do while !eof()
    if tmp2 $ upper(sa->name)
      if ++i > 100 ; exit ; endif
      aadd(tmp_mas,sa->name) ; aadd(tmp_kod,sa->(recno()))
    endif
    skip
  enddo
  if (t_len := len(tmp_kod)) = 0
    stat_msg("��㤠�� ����!")
    mybell(2,ERR)
    loop
  else
    box_shadow(mr1,2,22,77)
    SETCOLOR(col_tit_popup)
    @ k1-2,15 say "����: "+tmp2
    SETCOLOR(color0)
    if k1+t_len+2 < 21
      k2 := k1 + t_len + 2
    endif
    i := ascan(tmp_kod,rec)
    @ k1,3 say center(" ������⢮ ��������� ��ப - "+lstr(t_len),74)
    status_key("^<Esc>^ - �⪠� �� �롮�;  ^<Enter>^ - �롮�")
    if (i := popup(k1+1,13,k2,66,tmp_mas,i,color0)) > 0
      ret := tmp_kod[i]
    endif
    exit
  endif
enddo
goto (rec)
restscreen(buf)
return ret

*

*****
Function get_s_kemvyd(k,r,c)
Local r1, r2
if (r1 := r+1) > maxrow()/2
  r2 := r-1 ; r1 := 2
else
  r2 := maxrow()-2
endif
return input_s_kemvyd(k,r1,r2)

*****
Function input_s_kemvyd(k,r1,r2)
Local t_arr[BR_LEN], tmp_select := select(), buf := savescreen(), ret, tmp_keys
Private _fl_space := .f.
t_arr[BR_TOP] := r1
t_arr[BR_BOTTOM] := r2
t_arr[BR_LEFT] := 4
t_arr[BR_RIGHT] := 77
t_arr[BR_OPEN] := {|| f1_s_kemvyd(,,"open",k) }
t_arr[BR_CLOSE] := {|| sa->(dbCloseArea()) }
t_arr[BR_COLOR] := color0
t_arr[BR_COLUMN] := {{ center("������������ �࣠����権, �뤠��� ���㬥���",70),{|| padr(sa->name,70) } }}
t_arr[BR_STAT_MSG] := {|| status_key("^<Esc>^ ��室 ^<Enter>^ �롮� ^<�஡��>^ ���⪠ ���� ^<Ins>^ ���������� ^<F2>^ ����") }
t_arr[BR_EDIT] := {|nk,ob| f1_s_kemvyd(nk,ob,"edit",2) }
t_arr[BR_ENTER] := {|| ret := {sa->(recno()),alltrim(sa->name)} }
tmp_keys := my_savekey()
edit_browse(t_arr)
my_restkey(tmp_keys)
if tmp_select > 0
  select(tmp_select)
endif
restscreen(buf)
if _fl_space
  ret := {0,space(10)}
endif
return ret

*

*****
Function yes_d_kemvyd(rec)
Local tmp_select := select(), fl := .t., arr, i, j, s, kr
R_Use(dir_server+"kartote_",,"TMPKART")
Locate for kemvyd == rec progress
if found()
  fl := func_error(4,'������ �࣠������ 㦥 "�ਢ易��" � ��樥���. �������� ����饭�!')
endif
tmpkart->(dbCloseArea())
if tmp_select > 0
  select(tmp_select)
endif
return fl

***** 㤠����� �㡫���⮢ �࣠����権, �뤠��� ���㬥���
Function fdeld_s_kem()
Static sk
Local buf, s1, s2, k1, k2, hGauge, r
buf := savescreen()
s1 := s2 := ""
r := T_ROW
if ! hb_user_curUser:IsAdmin()
  return func_error(4,"������� ����� � ����� ०�� ����饭!")
endif
if !G_SLock1Task(sem_task,sem_vagno)  // ����� ����㯠 �ᥬ
  return func_error('� ����� ������ �������� ��������� ����饭�. ����⠥� ��㣠� �����.')
endif
n_message({"����� ०�� �।�����祭 ��� 㤠����� ����� ��ப�",;
           '"��� �뤠� ���㬥��" � ��७�� �ᥩ �⭮��饩��',;
           "� ��� ���ଠ樨 ��㣮� ��ப�"},,;
          cColorStMsg,cColorStMsg,,,cColorSt2Msg)
f_message({"�롥�� 㤠�塞�� ��ப�"},,color1,color8,0)
if (k1 := input_s_kemvyd(sk,r,maxrow()-2)) != NIL
  s1 := k1[2]
  restscreen(buf)
  f_message({"�롥�� ��ப�, �� ������ ��७����� ���ଠ��",;
             "�� <.. "+s1+" ..>"},,;
            color1,color8,0)
  if (k2 := input_s_kemvyd(k1[1],r,maxrow()-2)) != NIL
    restscreen(buf)
    if k1[1] == k2[1]
      func_error(4,"��� ࠧ� ��࠭� ���� � � �� �࣠������!")
    else
      restscreen(buf)
      s2 := k2[2]
      f_message({"����塞�� ��ப�:",;
                 '"'+s1+'".',;
                 "��� ���ଠ�� ��७����� � ��ப�:",;
                 '"'+s2+'".'},,;
                color1,color8)
      if f_Esc_Enter("㤠�����",.t.)
        sk := k2[1]
        mywait()
        hGauge := GaugeNew(,,,"",.t.)
        GaugeDisplay( hGauge )
        G_Use(dir_server+"kartote_",,"TMPKART")
        go top
        do while !eof()
          GaugeUpdate( hGauge, recno()/lastrec() )
          if tmpkart->kemvyd == k1[1]
            G_RLock(forever)
            tmpkart->kemvyd := k2[1]
            UnLock
          endif
          skip
        enddo
        CloseGauge(hGauge)
        //
        G_Use(dir_server+"s_kemvyd",dir_server+"s_kemvyd","SA")
        set order to 0
        goto (k1[1])
        DeleteRec(.t.)
        close databases
        stat_msg("������ �����襭�!")
        MyBell(2,OK)
      endif
    endif
  endif
endif
restscreen(buf)
G_SUnLock(sem_vagno)
return NIL

*

***** 29.07.13
Function edit_school()
Local blk, arr[US_LEN]
arr[US_BOTTOM   ] := maxrow()-2
arr[US_LEFT     ] := 2
arr[US_RIGHT    ] := 77
arr[US_BASE     ] := dir_server+"mo_schoo"
arr[US_ARR_BROWSE]:= {"�","�","�",,.t.}
arr[US_COLUMN   ] := {{" ������������",{|| name },blk},;
                      {" ����",{|| left(adres,26) },blk},;
                      {" ���",{|| padr(inieditspr(A__MENUVERT,mm_tip_school,tip),14) },blk}}
arr[US_BLK_DEL  ] := {|_k| fdel_school(_k) }
arr[US_IM_PADEG ] := arr[US_SEMAPHORE] := "��ࠧ���⥫�� ��०�����"
arr[US_ROD_PADEG] := "��ࠧ���⥫��� ��०�����"
arr[US_EDIT_SPR ] := {{"name","C",30,0,,,space(30),,"�����񭭮� ������������"},;
                      {"fname","C",250,0,,,space(250),,"������ ������������"},;
                      {"adres","C",250,0,,,space(250),,"�ਤ��᪨� ����"},;
                      {"tip","N",1,0,,;
                       {|x|menu_reader(x,mm_tip_school,A__MENUVERT,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,mm_tip_school,x)},;
                       "���"};
                     }
edit_u_spr(1,arr)
return NIL

***** 29.07.13
Static Function fdel_school(k)
Local _fl := .t., arr, i
R_Use(dir_server+"human",,"__B")
index on kod to (cur_dir+"tmp_b") for between(ishod,301,309)
go top
do while !eof()
  arr := read_arr_DISPANS(__b->kod)
  for i := 1 to len(arr)
    if valtype(arr[i]) == "A" .and. valtype(arr[i,1]) == "C" ;
                 .and. arr[i,1] == "8" .and. valtype(arr[i,2]) == "N"
      if (arr[i,2] == k)
        _fl := .f.
      endif
      exit
    endif
  next
  if !_fl ; exit ; endif
  select __B
  skip
enddo
dbCloseArea()
return _fl

*

***** 25.05.13
Function edit_dds_stac()
Static mm_vedom := {{"�࣠�� ��ࠢ���࠭����",0},;
                    {"�࣠�� ��ࠧ������",1},;
                    {"�࣠�� �樠�쭮� �����",2},;
                    {"��㣮�",3}}
Local blk, arr[US_LEN]
arr[US_BOTTOM   ] := maxrow()-2
arr[US_LEFT     ] := 2
arr[US_RIGHT    ] := 77
arr[US_BASE     ] := dir_server+"mo_stdds"
arr[US_ARR_BROWSE]:= {"�","�","�",,.t.}
arr[US_COLUMN   ] := {{" ������������",{|| left(name,40) },blk},;
                      {" ����",{|| left(adres,16) },blk},;
                      {"������⢥����;�ਭ����������",{|| padr(inieditspr(A__MENUVERT,mm_vedom,vedom),14) },blk}}
arr[US_BLK_DEL  ] := {|_k| fdel_dds_stac(_k) }
arr[US_IM_PADEG ] := arr[US_SEMAPHORE] := "��樮���� ��⥩-���"
arr[US_ROD_PADEG] := "��०�����"
arr[US_EDIT_SPR ] := {{"name","C",250,0,,,space(250),,"������������ ��樮���"},;
                      {"adres","C",250,0,,,space(250),,"����"},;
                      {"vedom","N",1,0,,;
                       {|x|menu_reader(x,mm_vedom,A__MENUVERT,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,mm_vedom,x)},;
                       "������⢥���� �ਭ����������"};
                     }
edit_u_spr(1,arr)
return NIL

***** 25.05.13
Static Function fdel_dds_stac(k)
Local _fl
R_Use(dir_server+"human",,"__B")
dbLocateProgress( {|| __b->ZA_SMO == k } )
_fl := !found()
dbCloseArea()
return _fl

*

*****
Function spr_opl_5(k)
Static si1 := 1
Local mas_pmt, mas_msg, mas_fun, j, buf
DEFAULT k TO 1
do case
  case k == 1
    mas_pmt := {"����� ~����ᮢ ������ ���ᮭ���",;
                "% ������ ~��砬 (���)",;
                "% ������ ~����⥭⠬ (���)"}
    mas_msg := {"����ன�� ����ᮢ ������ (� �⤠������� ࠡ���) ���ᮭ���",;
                "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ��祩 �� ���)",;
                "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ����⥭⮢ �� ���)"}
    mas_fun := {"spr_opl_5(11)",;
                "spr_opl_5(12)",;
                "spr_opl_5(13)"}
    if is_task(X_PLATN) // ��� ������ ���
      aadd(mas_pmt, "% ������ ��~砬 (�����)")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ��祩 �� ������� �������)")
      aadd(mas_fun, "spr_opl_5(16)")
      aadd(mas_pmt, "% ������ ���~��⥭⠬ (�����)")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ����⥭⮢ �� ������� �������)")
      aadd(mas_fun, "spr_opl_5(17)")
      aadd(mas_pmt, "% ������ �� ~���ࠢ����� �� ��.��㣨")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��業�� ������ �� ���ࠢ����� �� ����� ��㣨)")
      aadd(mas_fun, "spr_opl_5(18)")
    endif
    popup_prompt(T_ROW-len(mas_pmt)-3,T_COL+5,si1,mas_pmt,mas_msg,mas_fun)
  case k == 11
    //spr_opl_52()
	editEmployees( 2 )
  case k == 12
    spr_opl_51(O5_VR_OMS,"��砬 (���)")
  case k == 13
    spr_opl_51(O5_AS_OMS,"����⥭⠬ (���)")
  case k == 16
    spr_opl_51(O5_VR_PLAT,"��砬 (����� ��㣨)")
  case k == 17
    spr_opl_51(O5_AS_PLAT,"����⥭⠬ (����� ��㣨)")
  case k == 18
    spr_opl_51(O5_VR_NAPR,"�� ���ࠢ����� �� ����� ��㣨")
endcase
if between(k,11,20)
  si1 := k-10
endif
return NIL

*

*****
Function spr_opl_7(k)
Static si1 := 1
Local mas_pmt, mas_msg, mas_fun, j, buf
DEFAULT k TO 1
do case
  case k == 1
    mas_pmt := {"~�⮨����� ���",;
                "% ������ ~��砬 (���)",;
                "% ������ ~����⥭⠬ (���)"}
    mas_msg := {"����ன�� �⮨���� ��� ��� ��� � ����⥭� �� ��㯯�� ���",;
                "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ��祩 �� ���)",;
                "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ����⥭⮢ �� ���)"}
    mas_fun := {"spr_opl_7(11)",;
                "spr_opl_7(12)",;
                "spr_opl_7(13)"}
    if is_task(X_PLATN) // ��� ������ ���
      aadd(mas_pmt, "% ������ ��~砬 (�����)")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ��祩 �� ������� �������)")
      aadd(mas_fun, "spr_opl_7(14)")
      aadd(mas_pmt, "% ������ ���~��⥭⠬ (�����)")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ����⥭⮢ �� ������� �������)")
      aadd(mas_fun, "spr_opl_7(15)")
      aadd(mas_pmt, "% ������ ��砬 (~���)")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ��祩 �� ���)")
      aadd(mas_fun, "spr_opl_7(16)")
      aadd(mas_pmt, "% ������ ����⥭⠬ (�~��)")
      aadd(mas_msg, "����ன�� ��㯯 ��� (��⠭���� ��業⮢ ������ ����⥭⮢ �� ���)")
      aadd(mas_fun, "spr_opl_7(17)")
    endif
    popup_prompt(T_ROW-len(mas_pmt)-3,T_COL+5,si1,mas_pmt,mas_msg,mas_fun)
  case k == 11
    spr_opl_71()
  case k == 12
    spr_opl_51(O5_VR_OMS,"��砬 (���)")
  case k == 13
    spr_opl_51(O5_AS_OMS,"����⥭⠬ (���)")
  case k == 14
    spr_opl_51(O5_VR_PLAT,"��砬 (����� ��㣨)")
  case k == 15
    spr_opl_51(O5_AS_PLAT,"����⥭⠬ (����� ��㣨)")
  case k == 16
    spr_opl_51(O5_VR_DMS,"��砬 (���)")
  case k == 17
    spr_opl_51(O5_AS_DMS,"����⥭⠬ (���)")
endcase
if between(k,11,20)
  si1 := k-10
endif
return NIL

*

*****
Function spr_opl_51(reg,s)
Local blk, t_arr[BR_LEN], mtitle := "% ������ "+s
Private str_find := str(reg,2), muslovie := "u5->tip=="+lstr(reg)
t_arr[BR_TOP] := 2
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := 13
t_arr[BR_RIGHT] := t_arr[BR_LEFT]+52
t_arr[BR_OPEN] := {|| fs_opl_51(,,"open",reg) }
t_arr[BR_CLOSE] := {|| dbCloseAll() }
t_arr[BR_ARR_BLOCK] := {{| | FindFirst(str_find)},;
                        {| | FindLast(str_find)},;
                        {|n| SkipPointer(n, muslovie)},;
                        str_find,muslovie;
                       }
t_arr[BR_SEMAPHORE] := mtitle
t_arr[BR_COLOR] := color0
t_arr[BR_TITUL] := mtitle
t_arr[BR_TITUL_COLOR] := "W+/GR"
t_arr[BR_ARR_BROWSE] := {"�","�","�","N/BG,W+/N,B/BG,W+/B",.t.,300}
blk := {|| if(empty(u5->razryad), {3,4}, {1,2}) }
t_arr[BR_COLUMN] := {}
aadd(t_arr[BR_COLUMN], { "�����;������",{|| put_val(u5->razryad,2) }, blk })
aadd(t_arr[BR_COLUMN], { "�⤠���-;�����",{|| padc(iif(u5->otdal==1,"�",""),9) }, blk })
aadd(t_arr[BR_COLUMN], { "��㣨 �:",{|| u5->usl_1 }, blk })
aadd(t_arr[BR_COLUMN], { "  ��:",{|| u5->usl_2 }, blk })
aadd(t_arr[BR_COLUMN], { "  ��業�;  ������",{|| ft_opl_51(u5->procent,u5->procent2,10) }, blk })
t_arr[BR_STAT_MSG] := {|| ;
  status_key("^<Esc>^ ��室 ^<Enter>^ ।���஢���� ^<Ins>^ ���������� ^<Del>^ 㤠����� ^<F9>^ �����") }
t_arr[BR_EDIT] := {|nk,ob| fs_opl_51(nk,ob,"edit",reg) }
edit_browse(t_arr)
return NIL

*****
Function fs_opl_51(nKey,oBrow,regim,lregim)
Local ret := -1
Local buf, fl := .f., rec, rec1, k := 14, tmp_color
do case
  case regim == "open"
    buf := save_maxrow()
    mywait()
    G_Use(dir_server+"u_usl_5",,"U5")
    go top
    do while !eof()
      G_RLock(forever)
      u5->_usl_1 := fsort_usl(u5->usl_1)
      u5->_usl_2 := fsort_usl(iif(empty(u5->usl_2), u5->usl_1, u5->usl_2))
      UnLock
      skip
    enddo
    Commit
    index on str(tip,2)+_usl_1+str(razryad,2)+str(otdal,1) to (cur_dir+"tmp_u5")
    find (str_find)
    ret := found()
    rest_box(buf)
  case regim == "edit"
    do case
      case nKey == K_F9
        buf := save_maxrow()
        mywait()
        rec := recno()
        arr_title := {;
          "�������������������������������������������������������",;
          "����᳎⤠-�       ��㣨        �   % ������ �� ���   ",;
          "����-����- ��������������������������������������������",;
          "��   ������    �     �    ��    �   ���   �����⥭� ",;
          "�������������������������������������������������������"}
        if is_task(X_PLATN) // ��� ������ ���
          if is_oplata == 7
            arr_title[1] := arr_title[1]+"����������������������������"
            arr_title[2] := arr_title[2]+"�% ������ �� ����� ��㣠�"
            arr_title[3] := arr_title[3]+"����������������������������"
            arr_title[4] := arr_title[4]+"� ��� � ���. ���.������ᄌ�"
            arr_title[5] := arr_title[5]+"����������������������������"
          else
            arr_title[1] := arr_title[1]+"���������������������"
            arr_title[2] := arr_title[2]+"� % ������ �� ��.��."
            arr_title[3] := arr_title[3]+"���������������������"
            arr_title[4] := arr_title[4]+"� ��� � ���. ����ࠢ"
            arr_title[5] := arr_title[5]+"���������������������"
          endif
        endif
        n_file := "pers_o51"+stxt
        HH := 58 ; sh := 60
        Private reg_print := f_reg_print(arr_title,@sh)
        fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
        add_string("")
        add_string(center("��業�� ������ ���ᮭ���",sh))
        add_string(center("�� "+date_month(sys_date,.t.),sh))
        add_string("")
        aeval(arr_title, {|x| add_string(x) } )
        go top
        do while !eof()
          if verify_FF(HH, .t., sh)
            aeval(arr_title, {|x| add_string(x) } )
          endif
          s := put_val(u5->razryad,4)+;
               iif(u5->otdal==1,"   ��",space(5))+;
               space(3)+;
               u5->usl_1+" "+;
               if(empty(u5->usl_2), u5->usl_1, u5->usl_2)
          s1 := ""
          do case
            case u5->tip == O5_VR_OMS
              s1 := " "+ft_opl_51(u5->procent,u5->procent2,10)
            case u5->tip == O5_AS_OMS
              s1 := space(12)+ft_opl_51(u5->procent,u5->procent2,10)
            case u5->tip == O5_VR_PLAT
              s1 := space(22)+put_val_0(u5->procent,7,2)
            case u5->tip == O5_AS_PLAT
              s1 := space(22+7)+put_val_0(u5->procent,7,2)
            case u5->tip == O5_VR_NAPR .or. (u5->tip == O5_VR_DMS .and. is_oplata == 7)
              s1 := space(22+7+7)+put_val_0(u5->procent,7,2)
            case (u5->tip == O5_AS_DMS .and. is_oplata == 7)
              s1 := space(22+7+7+7)+put_val_0(u5->procent,7,2)
          endcase
          if !empty(s1)
            add_string(s+s1)
          endif
          skip
        enddo
        goto (rec)
        fclose(fp)
        rest_box(buf)
        viewtext(n_file,,,,(sh > 80),,,reg_print)
      case nKey == K_INS .or. (nKey == K_ENTER .and. !empty(u5->usl_1))
        save screen to buf
        if nkey == K_INS .and. !fl_found
          colorwin(pr1+4,pc1,pr1+4,pc2,"N/N","W+/N")
          colorwin(pr1+4,pc1,pr1+4,pc2,"N/N","W+/B")
        endif
        rec := recno()
        Private mrazryad := if(nkey==K_INS, 0, u5->razryad),;
                motdal := if(nkey==K_INS, " ", iif(u5->otdal==1, "�", " ")),;
                musl_1 := if(nkey==K_INS, space(10), u5->usl_1),;
                musl_2 := if(nkey==K_INS, space(10), u5->usl_2),;
                mprocent := if(nkey==K_INS, 0, u5->procent),;
                mprocent2 := if(nkey==K_INS, 0, u5->procent2),;
                bg := {|o,k| get_c_symb(o,k,"�") },;
                gl_area := {1,0,maxrow()-1,79,0}
        tmp_color := setcolor(cDataCScr)
        k := maxrow()-10
        box_shadow(k,pc1+1,maxrow()-3,pc2-1,,;
                       if(nKey == K_INS,"����������","������஢����"),;
                       cDataPgDn)
        setcolor(cDataCGet)
        @ k+1,pc1+3 say "����� ������" get mrazryad pict "99" range 0,99
        @ k+2,pc1+3 say "�⤠��������" get motdal reader {|o| MyGetReader(o,bg) }
        @ k+3,pc1+3 say "��㣨 �:" get musl_1
        @ k+4,pc1+3 say "      ��:" get musl_2
        @ k+5,pc1+3 say "��業� ������" get mprocent pict "99.99"
        if eq_any(lregim,O5_VR_OMS,O5_VR_PLAT,O5_VR_DMS)
          @ k+6,pc1+3 say "��業� ������ ���� ��� ����⥭�" get mprocent2 pict "99.99"
        elseif eq_any(lregim,O5_AS_OMS,O5_AS_PLAT,O5_AS_DMS)
          @ k+6,pc1+3 say "��業� ������ ����⥭�� ��� ���" get mprocent2 pict "99.99"
        endif
        status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
        myread()
        if lastkey() != K_ESC .and. !emptyany(musl_1,mprocent) .and. f_Esc_Enter(1)
          if nKey == K_INS
            fl_found := .t.
            AddRec(2)
            replace u5->tip with lregim
            rec := recno()
          else
            G_RLock(forever)
          endif
          u5->usl_1    := musl_1
          u5->usl_2    := musl_2
          u5->procent  := mprocent
          u5->procent2 := mprocent2
          u5->razryad  := mrazryad
          u5->otdal    := iif(empty(motdal), 0, 1)
          u5->_usl_1   := fsort_usl(musl_1)
          u5->_usl_2   := fsort_usl(iif(empty(musl_2), musl_1, musl_2))
          UNLOCK
          COMMIT
          oBrow:goTop()
          goto (rec)
          ret := 0
        elseif nKey == K_INS .and. !fl_found
          ret := 1
        endif
        setcolor(tmp_color)
        restore screen from buf
      case nKey == K_DEL .and. !empty(u5->usl_1) .and. f_Esc_Enter(2)
        DeleteRec()
        oBrow:goTop()
        find (str_find)
        ret := 0
        if !found()
          ret := 1
        endif
    endcase
endcase
return ret

*****
Function ft_opl_51(p1,p2,n)
Local s1 := alltrim(put_val_0(p1,5,2)), s2
if !empty(p2)
  s2 := alltrim(put_val_0(p2,5,2))
  if len(s1)+len(s2)+3 <= n
    s1 += " "
  endif
  s1 += "("+s2+")"
endif
return padc(s1,n)

*

*****
Function spr_opl_52()
Local i, buf := savescreen(), t_arr[BR_LEN], n := 36
Private menu_kateg := {{" ���",0},;
                       {"2-��",1},;
                       {"1-��",2},;
                       {"����",3}}
mywait()
G_Use(dir_server+"mo_pers",,"PERSO")
index on upper(fio) to (cur_dir+"tmp_pers")
go top
t_arr[BR_TOP] := 2
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := 2
t_arr[BR_RIGHT] := 77
t_arr[BR_COLOR] := color0
t_arr[BR_TITUL] := "���४�஢�� �஢��� ������ ���ᮭ���"
t_arr[BR_TITUL_COLOR] := "W+/GR"
t_arr[BR_ARR_BROWSE] := {,,,"N/BG,W+/N,B/BG,W+/B,N+/BG",.t.,300}
t_arr[BR_FL_INDEX] := .t.
t_arr[BR_FL_NOCLEAR] := .t.
t_arr[BR_SEMAPHORE] := t_arr[BR_TITUL]
blk := {|| if(empty(perso->uroven), {3,4}, {1,2}) }
t_arr[BR_COLUMN] := {{ padc("�.�.�.",n),{|| left(perso->fio,n) }, blk }}
aadd(t_arr[BR_COLUMN], { " ���.;�����",{|| put_val(perso->tab_nom,5) }, blk })
aadd(t_arr[BR_COLUMN], { "���;���.",{|| padr(inieditspr(A__MENUVERT,menu_kateg,perso->kateg),4) }, {|| {5,5}}, {5,5} })
aadd(t_arr[BR_COLUMN], { "�����;������",{|| put_val(perso->uroven,2) }, blk })
aadd(t_arr[BR_COLUMN], { "�⤠���-;�����",{|| padc(iif(perso->otdal==1,"�",""),9) }, blk })
t_arr[BR_STAT_MSG] := {|| ;
  status_key("^<Esc>^ - ��室;  ^<Enter>^ - ।���஢����;  ^<F9>^ - �����") }
t_arr[BR_EDIT] := {|nk,ob| fs_opl_52(nk,ob,"edit") }
edit_browse(t_arr)
close databases
restscreen(buf)
return NIL

*****
Function fs_opl_52(nKey,oBrow,cregim)
Local ret := -1, r := row(), c := col(), buf, fl := .f.,;
      tmp_color := setcolor(), n_file, sh, HH
do case
  case cregim == "edit"
    do case
      case nKey == K_F9
        buf := save_maxrow()
        mywait()
        rec := recno()
        arr_title := {;
          "��������������������������������������������������������������",;
          "                                                  �����᳎⤠-",;
          "                     �.�.�.                       �����-����- ",;
          "                                                  ���   ������",;
          "��������������������������������������������������������������"}
        n_file := "pers_o52"+stxt
        sh := len(arr_title[1]) ; HH := 57
        fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
        add_string("")
        add_string(center("���᮪ ���ᮭ���",sh))
        add_string(center("�� "+date_month(sys_date,.t.),sh))
        add_string("")
        aeval(arr_title, {|x| add_string(x) } )
        go top
        do while !eof()
          if !(emptyall(perso->UROVEN,perso->otdal))
            if verify_FF(HH, .t., sh)
              aeval(arr_title, {|x| add_string(x) } )
            endif
            lfio := padr("["+lstr(perso->tab_nom)+"]",8)
            lfio += perso->fio
            add_string(left(lfio,50)+;
                       put_val(perso->UROVEN,5)+;
                       iif(perso->otdal==1,"   ��",""))
          endif
          skip
        enddo
        goto (rec)
        fclose(fp)
        rest_box(buf)
        viewtext(n_file,,,,(sh > 80),,,2)
      case nKey == K_ENTER
        buf := save_maxrow()
        Private mrazryad := perso->UROVEN,;
                motdal := iif(perso->otdal==1, "�", " "),;
                bg := {|o,k| get_c_symb(o,k,"�") },;
                gl_area := {1,0,maxrow()-1,79,0}
        setcolor(cDataCGet)
        @ row(),58 clear to row(),76
        @ row(),58 get mrazryad pict "99" range 0,99
        @ row(),71 get motdal reader {|o| MyGetReader(o,bg) }
        status_key("^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����")
        myread()
        if lastkey() != K_ESC
          G_RLock(forever)
          perso->UROVEN := mrazryad
          perso->otdal := iif(empty(motdal), 0, 1)
          UnLock
          Commit
          oBrow:down()
        endif
        rest_box(buf)
        setcolor(tmp_color) ; ret := 0
    endcase
endcase
@ r,c say ""
return ret

*****
Function get_c_symb(oGet,nKey,char_symbol)
Local mvar
if nKey >= 32
  mvar := readvar()
  if empty(&mvar)
    cKey := char_symbol
  else
    cKey := " "  // �஡��
  endif
  oGet:overstrike( cKey )
  IF ( oGet:typeOut )
    IF ( !SET( _SET_CONFIRM ) )
      oGet:exitState := GE_ENTER
    ENDIF
  ENDIF
ENDIF
return NIL

*

*****
Function spr_opl_71()
Local blk, t_arr[BR_LEN], mtitle := "�⮨����� ��� ��� ��㯯� ���"
t_arr[BR_TOP] := 2
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT] := 0
t_arr[BR_RIGHT] := 79
t_arr[BR_OPEN] := {|| fs_opl_71(,,"open") }
t_arr[BR_CLOSE] := {|| dbCloseAll() }
t_arr[BR_SEMAPHORE] := mtitle
t_arr[BR_COLOR] := color0
t_arr[BR_TITUL] := mtitle
t_arr[BR_TITUL_COLOR] := "W+/GR"
t_arr[BR_ARR_BROWSE] := {"�","�","�","N/BG,W+/N,B/BG,W+/B",.t.,300}
blk := {|| if(empty(u7->usl_ins), {3,4}, {1,2}) }
t_arr[BR_COLUMN] := {}
aadd(t_arr[BR_COLUMN], { "������������ ���",{|| u7->name }, blk })
aadd(t_arr[BR_COLUMN], { "���;��;��",{|| iif(u7->variant==1," 1 "," 2 ") }, blk })
aadd(t_arr[BR_COLUMN], { "���; ���; ���",{|| put_val_0(u7->v_uet_oms,6,2) }, blk })
aadd(t_arr[BR_COLUMN], { "����.; ���; ���",{|| put_val_0(u7->a_uet_oms,6,2) }, blk })
aadd(t_arr[BR_COLUMN], { "���; ���;����.",{|| put_val_0(u7->v_uet_pl ,6,2) }, blk })
aadd(t_arr[BR_COLUMN], { "����.; ���;����.",{|| put_val_0(u7->a_uet_pl ,6,2) }, blk })
aadd(t_arr[BR_COLUMN], { "���; ���; ���",{|| put_val_0(u7->v_uet_dms,6,2) }, blk })
aadd(t_arr[BR_COLUMN], { "����.; ���; ���",{|| put_val_0(u7->a_uet_dms,6,2) }, blk })
aadd(t_arr[BR_COLUMN], { "��㣨",{|| padr(u7->usl_ins,11) }, blk })
t_arr[BR_STAT_MSG] := {|| ;
  status_key("^<Esc>^ ��室 ^<Enter>^ ।-� ^<Ins>^ ���. ^<Del>^ 㤠�. ^<Ctrl+Enter>^ ��㣨 ^<F9>^ �����") }
t_arr[BR_EDIT] := {|nk,ob| fs_opl_71(nk,ob,"edit",mtitle) }
edit_browse(t_arr)
return NIL

*****
Function fs_opl_71(nKey,oBrow,regim,mtitle)
Static menu_variant := {{"1 - �� ������⢨� ���-� ���� ���-�� ��� ��� � ���-�",1},;
                        {"2 - �� ������⢨� ���-� ���� ��-�� ��� ��� � ���-�",0}}
Local ret := -1, sh
Local buf, fl := .f., rec, rec1, k := 12, tmp_color, a_da, a_net, t_arr[2]
do case
  case regim == "open"
    G_Use(dir_server+"u_usl_7",,"U7")
    index on upper(name) to (cur_dir+"tmp_u7")
    go top
    ret := !eof()
  case regim == "edit"
    do case
      case nKey == K_F9
        buf := save_maxrow()
        mywait()
        rec := recno()
        arr_title := {;
          "��������������������������������������������������������������������������������",;
          "                                                                    � ��糀���",;
          "           ������������ ��㣨                                      � ��� � ��� ",;
          "��������������������������������������������������������������������������������"}
        n_file := "pers_o71"+stxt
        HH := 58
        Private reg_print := f_reg_print(arr_title,@sh)
        fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
        add_string("")
        add_string(center(mtitle+' "'+alltrim(u7->name)+'"',sh))
        add_string(center("�� "+date_month(sys_date,.t.),sh))
        add_string("")
        s := "C⮨����� ��� "
        add_string(s+"��� ��� ���          :"+str(u7->v_uet_oms,7,2))
        add_string(s+"��� ��� ����⥭�     :"+str(u7->a_uet_oms,7,2))
        add_string(s+"��.��� ��� ���     :"+str(u7->v_uet_pl ,7,2))
        add_string(s+"��.��� ��� ����⥭�:"+str(u7->a_uet_pl ,7,2))
        add_string(s+"��� ��� ���          :"+str(u7->v_uet_dms,7,2))
        add_string(s+"��� ��� ����⥭�     :"+str(u7->a_uet_dms,7,2))
        add_string("")
        aeval(arr_title, {|x| add_string(x) } )
        a_da := Slist2arr(u7->usl_ins)
        a_net := Slist2arr(u7->usl_del)
        useUch_Usl()
        R_Use(dir_server+"uslugi",,"USL")
        index on fsort_usl(shifr) to (cur_dir+"tmpu")
        go top
        do while !eof()
          if _f_usl_danet(a_da,a_net)
            if verify_FF(HH, .t., sh)
              aeval(arr_title, {|x| add_string(x) } )
            endif
            select UU
            find (str(usl->kod,4))
            k := perenos(t_arr,usl->name,sh-11-12)
            add_string(usl->shifr+" "+padr(t_arr[1],sh-11-12)+;
                       put_val_0(uu->vkoef_v,6,2)+put_val_0(uu->akoef_v,6,2))
            for i := 2 to k
              add_string(space(11)+t_arr[i])
            next
          endif
          select USL
          skip
        enddo
        uu->(dbCloseArea())
        usl->(dbCloseArea())
        fclose(fp)
        rest_box(buf)
        viewtext(n_file,,,,(sh > 80),,,reg_print)
        select U7
      case nKey == K_INS .or. (nKey == K_ENTER .and. !empty(u7->name))
        save screen to buf
        if nkey == K_INS .and. !fl_found
          colorwin(pr1+4,pc1,pr1+4,pc2,"N/N","W+/N")
          colorwin(pr1+4,pc1,pr1+4,pc2,"N/N","W+/B")
        endif
        rec := recno()
        Private mname := if(nkey==K_INS, space(20), u7->name),;
                m1variant := if(nkey==K_INS, 0, u7->variant),;
                mv_uet_oms := if(nkey==K_INS, 0, u7->v_uet_oms),;
                ma_uet_oms := if(nkey==K_INS, 0, u7->a_uet_oms),;
                mv_uet_pl  := if(nkey==K_INS, 0, u7->v_uet_pl),;
                ma_uet_pl  := if(nkey==K_INS, 0, u7->a_uet_pl),;
                mv_uet_dms := if(nkey==K_INS, 0, u7->v_uet_dms),;
                ma_uet_dms := if(nkey==K_INS, 0, u7->a_uet_dms),;
                mvariant, gl_area := {1,0,maxrow()-1,79,0}
        k := maxrow()-12
        mvariant := inieditspr(A__MENUVERT, menu_variant, m1variant)
        tmp_color := setcolor(cDataCScr)
        box_shadow(k,pc1+1,maxrow()-3,pc2-1,,;
                       if(nKey == K_INS,"����������","������஢����"),;
                       cDataPgDn)
        setcolor(cDataCGet)
        @ k+1,pc1+3 say "������������ ��㯯� ���" get mname
        @ k+2,pc1+3 say "��ਠ�� ����" get mvariant ;
                    reader {|x|menu_reader(x,menu_variant,A__MENUVERT,,,.f.)}
        @ k+3,pc1+3 say "C⮨����� ��� ��� ��� ���          " get mv_uet_oms pict "999.99"
        @ k+4,pc1+3 say "C⮨����� ��� ��� ��� ����⥭�     " get ma_uet_oms pict "999.99"
        @ k+5,pc1+3 say "C⮨����� ��� ��.��� ��� ���     " get mv_uet_pl  pict "999.99"
        @ k+6,pc1+3 say "C⮨����� ��� ��.��� ��� ����⥭�" get ma_uet_pl  pict "999.99"
        @ k+7,pc1+3 say "C⮨����� ��� ��� ��� ���          " get mv_uet_dms pict "999.99"
        @ k+8,pc1+3 say "C⮨����� ��� ��� ��� ����⥭�     " get ma_uet_dms pict "999.99"
        status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
        myread()
        if lastkey() != K_ESC .and. !empty(mname) .and. f_Esc_Enter(1)
          if nKey == K_INS
            fl_found := .t.
            AddRecN()
            rec := recno()
          else
            G_RLock(forever)
          endif
          u7->name      := mname
          u7->variant   := m1variant
          u7->v_uet_oms := mv_uet_oms
          u7->a_uet_oms := ma_uet_oms
          u7->v_uet_pl  := mv_uet_pl
          u7->a_uet_pl  := ma_uet_pl
          u7->v_uet_dms := mv_uet_dms
          u7->a_uet_dms := ma_uet_dms
          UNLOCK
          COMMIT
          oBrow:goTop()
          goto (rec)
          ret := 0
        elseif nKey == K_INS .and. !fl_found
          ret := 1
        endif
        setcolor(tmp_color)
        restore screen from buf
      case nKey == K_DEL .and. !empty(u7->name) .and. f_Esc_Enter(2)
        DeleteRec()
        oBrow:goTop()
        ret := 0
        if !found()
          ret := 1
        endif
      case nKey == K_CTRL_ENTER .and. !empty(u7->name)
        fs_opl_72({Slist2arr(u7->usl_ins),Slist2arr(u7->usl_del)})
        ret := 0
    endcase
endcase
return ret
return NIL

*****
Function fs_opl_72(arr)
Local s, ar, is_write := .f.
s := '���᮪ ��� ��� ��㯯� "'+alltrim(u7->name)+'"'
ar := forma_nastr(s,{s},,arr,@is_write)
select U7
if is_write
  G_RLock(forever)
  replace u7->usl_ins with arr2Slist(ar[1]),;
          u7->usl_del with arr2Slist(ar[2])
  UnLock
endif
return NIL

*

***** ।���஢���� �ࠢ�筨��� ���ᮭ���, �⤥�����, ��०�����, �࣠����樨
Function spr_struct_org(k)
Static sk := 1
Local str_sem, mas_pmt, mas_msg, mas_fun, j
DEFAULT k TO 0
do case
  case k == 0
    mas_pmt := {"~���ᮭ��",;
                "~�⤥�����",;
                "~��०�����",;
                "~��� �࣠������"}
    mas_msg := {"������஢���� �ࠢ�筨�� ���ᮭ���",;
                "������஢���� �ࠢ�筨�� �⤥�����",;
                "������஢���� �ࠢ�筨�� ��०�����",;
                "������஢���� ������������, ���� � ������᪨� ४����⮢ ��襩 �࣠����樨"}
    mas_fun := {"spr_struct_org(1)",;
                "spr_struct_org(2)",;
                "spr_struct_org(3)",;
                "spr_struct_org(4)"}
    if is_uchastok > 0
      aadd(mas_pmt, "�~��⪮�� ���")
      aadd(mas_msg, "�ਢ離� ���⪮��� ��祩 � ���⪠�")
      aadd(mas_fun, "spr_struct_org(5)")
    endif
    popup_prompt(T_ROW, T_COL+5, sk, mas_pmt, mas_msg, mas_fun)
  case k == 1
    edit_pers()
  case k == 2
    edit_otd()
  case k == 3
    edit_uch()
  case k == 4
    str_sem := "������஢���� ४����⮢ �࣠����樨"
    if G_SLock(str_sem)
      f_edit_spr(A__EDIT,gmenu_organ,"४����⠬ ��襩 �࣠����樨",;
                 "use_base('organiz')",0,1)
      G_SUnLock(str_sem)
      reRead_glob_MO() // ������� ���ᨢ glob_MO
    else
      func_error(4,err_slock)
    endif
  case k == 5
    str_sem := "�ਢ離� ���⪮��� ��祩 � ���⪠�"
    if G_SLock(str_sem)
      f_attach_uch_vrach()
      G_SUnLock(str_sem)
    else
      func_error(4,err_slock)
    endif
endcase
if k > 0
  sk := k
endif
return NIL


*

***** 11.10.15 �ਢ離� ���⪮��� ��祩 � ���⪠�
Function f_attach_uch_vrach()
Local i, blk, arr := {}, t_arr[BR_LEN]
R_Use(dir_server+"kartotek",dir_server+"kartoteu","KART")
for i := 1 to 99
  find (strzero(i,2))
  if found()
    aadd(arr,i)
  endif
next
use
if len(arr) == 0
  return func_error(4,"� ����⥪� �� ����஥�� ���⪨!")
endif
Private p2blk := {|i| i := iif(between(p2->kateg,1,4), p2->kateg, 1),;
                                      " ("+{"��","��","��","��"}[i]+".) " }
G_Use(dir_server+"mo_uchvr",,"UV")
index on str(uch,2) to (cur_dir+"tmp")
for i := 1 to len(arr)
  find (str(arr[i],2))
  if !found()
    AddRec(2)
    uv->uch := arr[i]
  else
    G_RLock(forever)
  endif
  uv->is := 1
next
dbUnLockAll()
set index to
go top
do while !eof()
  if ascan(arr,uv->uch) == 0
    G_RLock(forever)
    uv->is := 0
  endif
  skip
enddo
dbUnLockAll()
index on str(uch,2) to (cur_dir+"tmp") for is == 1
t_arr[BR_TOP] := T_ROW
t_arr[BR_BOTTOM] := maxrow()-2
t_arr[BR_LEFT]  := 2
t_arr[BR_RIGHT] := 77
t_arr[BR_COLOR] := color0
t_arr[BR_TITUL] := '"�ਢ離�" ���⪮��� ��祩 � ���⪠�'
t_arr[BR_TITUL_COLOR] := "BG+/GR"
t_arr[BR_ARR_BROWSE] := {"�","�","�",,.t.}
t_arr[BR_COLUMN] := {{"��-�",{|| str(uv->uch,3)+" " },blk},;
                     {" ���⪮�� ���",{|| padr(f1_attach_uch_vrach(),67) },blk}}
t_arr[BR_EDIT] := {|nk,ob| f2_attach_uch_vrach(nk,ob,"edit") }
t_arr[BR_STAT_MSG] := {|| status_key("^<Esc>^ - ��室;  ^<Enter>^ - ।���஢���� ���⪮���� ���") }
R_Use(dir_server+"mo_pers",dir_server+"mo_pers","P2")
select UV
go top
edit_browse(t_arr)
close databases
return NIL

***** 11.10.15
Function f1_attach_uch_vrach()
Local s := ""
select P2
if uv->vrach > 0
  goto (uv->vrach)
  s := alltrim(p2->fio)+eval(p2blk)+" ["+lstr(p2->tab_nom)+"]"
elseif uv->vrachv > 0
  goto (uv->vrachv)
  if uv->vrachd > 0
    s := "���.: "+fam_i_o(p2->fio)+eval(p2blk)+" ["+lstr(p2->tab_nom)+"]"
    goto (uv->vrachd)
    s += ", ���: "+fam_i_o(p2->fio)+eval(p2blk)+" ["+lstr(p2->tab_nom)+"]"
  else
    s := "�����: "+alltrim(p2->fio)+eval(p2blk)+" ["+lstr(p2->tab_nom)+"]"
  endif
elseif uv->vrachd > 0
  goto (uv->vrachd)
  s := "���: "+alltrim(p2->fio)+eval(p2blk)+" ["+lstr(p2->tab_nom)+"]"
endif
select UV
return s

***** 11.10.15
Function f2_attach_uch_vrach(nKey,oBrow,regim)
Local ret := -1, buf, r1, r2
if regim == "edit" .and. nKey == K_ENTER
  save screen to buf
  if nkey == K_INS .and. !fl_found
    colorwin(pr1+4,pc1,pr1+4,pc2,"W/W","GR+/R")
  endif
  Private gl_area := {1,0,maxrow()-1,79,0},;
          m1vrach  := uv->vrach ,;
          m1vrachv := uv->vrachv,;
          m1vrachd := uv->vrachd,;
          mvrach  := space(36),;
          mvrachv := space(36),;
          mvrachd := space(36),;
          mtab_nom  := 0,;
          mtab_nomv := 0,;
          mtab_nomd := 0
  select P2
  if m1vrach > 0
    goto (m1vrach)
    MTAB_NOM := p2->tab_nom
    mvrach := padr(fam_i_o(p2->fio)+eval(p2blk)+" "+ret_tmp_prvs(p2->prvs,p2->prvs_new),36)
  endif
  if m1vrachv > 0
    goto (m1vrachv)
    MTAB_NOMv := p2->tab_nom
    mvrachv := padr(fam_i_o(p2->fio)+eval(p2blk)+" "+ret_tmp_prvs(p2->prvs,p2->prvs_new),36)
  endif
  if m1vrachd > 0
    goto (m1vrachd)
    MTAB_NOMd := p2->tab_nom
    mvrachd := padr(fam_i_o(p2->fio)+eval(p2blk)+" "+ret_tmp_prvs(p2->prvs,p2->prvs_new),36)
  endif
  select UV
  tmp_color := setcolor(cDataCScr)
  box_shadow(pr2-5,2,pr2-1,77,,"������஢���� ���⪮���� ���",cDataPgDn)
  setcolor(cDataCGet)
  @ pr2-4,4 say "����.��� (�� ������)" get mtab_nom pict "99999" ;
            valid {|g| v_kart_vrach(g,1) } ;
            when emptyall(m1vrachv,m1vrachd)
  @ row(),col()+1 get mvrach when .f. color color14
  @ pr2-3,4 say "����.��� (�����)" get mtab_nomv pict "99999" ;
            valid {|g| v_kart_vrach(g,2) } ;
            when empty(m1vrach)
  @ row(),col()+1 get mvrachv when .f. color color14
  @ pr2-2,4 say "����.��� (���)" get mtab_nomd pict "99999" ;
            valid {|g| v_kart_vrach(g,3) } ;
            when empty(m1vrach)
  @ row(),col()+1 get mvrachd when .f. color color14
  status_key("^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����")
  myread()
  if lastkey() != K_ESC .and. f_Esc_Enter(1)
    G_RLock(forever)
    uv->vrach  := m1vrach
    uv->vrachv := m1vrachv
    uv->vrachd := m1vrachd
    UnLock
    COMMIT
    ret := 0
  endif
  setcolor(tmp_color)
  restore screen from buf
endif
return ret

***** 11.10.15 ��।����� ��� �� ⠡��쭮�� ������
Static Function v_kart_vrach(get,k)
Local fl := .t.
Private tmp := readvar()
if &tmp != get:original
  if &tmp == 0
    do case
      case k == 1
        m1vrach := 0 ; mvrach := space(36)
      case k == 2
        m1vrachv := 0 ; mvrachv := space(36)
      case k == 3
        m1vrachd := 0 ; mvrachd := space(36)
    endcase
  elseif &tmp != 0
    select P2
    find (str(&tmp,5))
    if found()
      do case
        case k == 1
          m1vrach := p2->kod
          mvrach := padr(fam_i_o(p2->fio)+eval(p2blk)+" "+ret_tmp_prvs(p2->prvs,p2->prvs_new),36)
        case k == 2
          m1vrachv := p2->kod
          mvrachv := padr(fam_i_o(p2->fio)+eval(p2blk)+" "+ret_tmp_prvs(p2->prvs,p2->prvs_new),36)
        case k == 3
          m1vrachd := p2->kod
          mvrachd := padr(fam_i_o(p2->fio)+eval(p2blk)+" "+ret_tmp_prvs(p2->prvs,p2->prvs_new),36)
      endcase
    else
      fl := func_error(3,"�� ������ ���㤭�� � ⠡���� ����஬ "+lstr(&tmp)+" � �ࠢ�筨�� ���ᮭ���!")
    endif
    select UV
  endif
  if !fl
    &tmp := get:original
    return .f.
  endif
  do case
    case k == 1
      update_get("mvrach")
    case k == 2
      update_get("mvrachv")
    case k == 3
      update_get("mvrachd")
  endcase
endif
return .t.

*

***** 03.02.13 �஢�ઠ �ࠢ��쭮�� ���������� ���� �����
Function valid_kod_tfoms(get)
Local fl := .t., i, cCode := left(mkod_tfoms,6)
if (i := ascan(glob_arr_mo, {|x| x[_MO_KOD_TFOMS] == cCode})) > 0
  glob_mo := glob_arr_mo[i]
  mname_tfoms := padr(glob_mo[_MO_SHORT_NAME],60)
  muroven := get_uroven()
else
  fl := func_error(4,'�� ����� ���������騩 ��� �� "'+cCode+'". ���஡�� ��� ࠧ.')
  mkod_tfoms := get:original
endif
return fl

*

***** 15.08.17 ।���஢���� �ࠢ�筨�� ���ᮭ���
Function edit_pers()
Local buf, fl := .f., arr_blk, str_sem := "������஢���� ���ᮭ���"
if G_SLock(str_sem)
  buf := save_maxrow()
  mywait()
  Private tmp_V002 := create_classif_FFOMS(0,"V002") // PROFIL
  Private str_find := "1", muslovie := "p2->kod > 0"
  arr_blk := {{|| FindFirst(str_find)},;
              {|| dbGoBottom()},;
              {|n| SkipPointer(n, muslovie)},;
              str_find,muslovie;
             }
  if Use_base("mo_pers")
    index on iif(kod>0,'1','0')+upper(fio) to (cur_dir+"tmp_pers")
    set index to (cur_dir+"tmp_pers"),(dir_server+"mo_pers")
    find (str_find)
    if !found()
      keyboard chr(K_INS)
    endif
    Private mr := T_ROW
    rest_box(buf)
    Alpha_Browse(T_ROW,0,maxrow()-1,79,"f1edit_pers",color0,,,,,arr_blk,,"f2edit_pers",,;
                 {"�","�","�","N/BG,W+/N,B/BG,BG+/B,N+/BG,W/N",.t.} )
  endif
  close databases
  G_SUnLock(str_sem)
  rest_box(buf)
else
  func_error(4,err_slock)
endif
return NIL

***** 05.04.15
Function f1edit_pers(oBrow)
Static ak := {"   ","��.","��.","��.","��."}
Local oColumn, nf := 27, n := 19,;
      blk := {|| iif(between_date(dbegin,dend), ;
                        iif(P2->tab_nom > 0, {1,2}, {5,6}), ;
                        {3,4}) }
oColumn := TBColumnNew(center("�.�.�.",nf), {|| left(P2->fio,nf) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("���.�",{|| put_val(P2->tab_nom,5) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(padc("�����",14),{|| transform(p2->SNILS,picture_pf) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("���",{|| ak[P2->kateg+1] })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("���樠�쭮���",n), {|| padr(ret_tmp_prvs(p2->prvs,p2->prvs_new),n) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("����.;⠡.�",{|| put_val(P2->svod_nom,5) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
status_key("^<Esc>^ ��室 ^<Enter>^ ।���஢���� ^<Ins>^ ���������� ^<Del>^ 㤠����� ^<F9>^ �����")
@ mr,62 say " <F2> - ���� " color "GR+/BG"
mark_keys({"<F2>"},"R/BG")
return NIL

***** 15.08.17
Function f2edit_pers(nKey,oBrow)
Static gmenu_kateg := {{"���                ",1},;
                       {"�।��� ���.���ᮭ��",2},;
                       {"����訩 ���.���ᮭ��",3},;
                       {"��稥              ",4}}
Static menu_vr_kateg := {{"��� ��⥣�ਨ   ",0},;
                         {"2-�� ��⥣���  ",1},;
                         {"1-�� ��⥣���  ",2},;
                         {"����� ��⥣���",3}}
Static osn_sovm := {{"�᭮���� ࠡ��",0},;
                    {"ᮢ��饭��     ",1}}
Local buf, fl := .f., rec, rec1, j, k, tmp_color, mkod, tmp_nhelp, r, ret := -1
do case
  case nKey == K_F2
    return f4edit_pers(K_F2)
  case nKey == K_F9
    if (j := f_alert({padc("�롥�� ���冷� ���஢�� �� ����",60,".")},;
                     {" �� ��� "," �� ⠡.������ "},;
                     1,"W+/N","N+/N",maxrow()-2,,"W+/N,N/BG" )) == 0
      return ret
    endif
    rec := p2->(recno())
    buf := save_maxrow()
    mywait()
    name_file := "tab_nom"+stxt
    fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
    sh := 81 ; HH := 60
    add_string("")
    add_string(center("���᮪ ࠡ���饣� ���ᮭ��� � ⠡���묨 ����ࠬ�",sh))
    add_string("")
    if j == 1
      set order to 1
      find (str_find)
      do while !eof()
        if between_date(dbegin,dend)
          verify_FF(HH,.t.,sh)
          s := str(p2->tab_nom,5)+;
            iif(empty(p2->svod_nom), space(7), padl("("+lstr(p2->svod_nom)+")",7))+;
            " "+padr(p2->fio,40)+" "+transform(p2->SNILS,picture_pf)+" "+;
            ret_tmp_prvs(p2->prvs,p2->prvs_new)
          add_string(s)
        endif
        skip
      enddo
    else
      set order to 2
      go top
      do while !eof()
        if kod > 0 .and. between_date(dbegin,dend)
          verify_FF(HH,.t.,sh)
          s := str(p2->tab_nom,5)+;
            iif(empty(p2->svod_nom), space(7), padl("("+lstr(p2->svod_nom)+")",7))+;
            " "+padr(p2->fio,40)+" "+transform(p2->SNILS,picture_pf)+" "+;
            ret_tmp_prvs(p2->prvs,p2->prvs_new)
          add_string(s)
        endif
        skip
      enddo
    endif
    set order to 2
    go bottom
    max_nom := p2->tab_nom
    verify_FF(HH-3,.t.,sh)
    add_string(replicate("=",sh))
    add_string(center("���᮪ ᢮������ ⠡����� ����஢:",sh))
    s := "" ; k := 0
    for i := 1 to max_nom
      find (str(i,5))
      if !found()
        s += lstr(i)+", "
        if len(s) > sh
          verify_FF(HH,.t.,sh)
          add_string(s)
          s := ""
          if ++k > 10
            add_string("...")
            exit
          endif
        endif
      endif
    next
    if !empty(s)
      add_string(s)
    endif
    set order to 1
    goto (rec)
    fclose(fp)
    rest_box(buf)
    viewtext(name_file,,,,.t.,,,2)
  case nKey == K_INS .or. (nKey == K_ENTER .and. kod > 0)
    save screen to buf
    Private mfio := space(50), m1uch := 0, m1otd := 0, m1kateg := 1, ;
            much, motd, mname_dolj := space(30), mkateg, mstavka := 1,;
            mvid, m1vid := 0, mtab_nom := 0, msvod_nom := 0, mkod_dlo := 0,;
            mvr_kateg, m1vr_kateg := 0, msnils := space(11), mprofil, m1profil := 0, fl_profil := .f.,;
            mDOLJKAT := space(15), mD_KATEG := ctod(""),;
            mSERTIF, m1sertif := 0, mD_SERTIF := ctod(""),;
            mPRVS, m1prvs := 0, muroven := 0, motdal := 0,;
            mDBEGIN := boy(sys_date), mDEND := ctod(""),;
            gl_area := {1,0,maxrow()-1,79,0}
    if nKey == K_ENTER
      mkod       := recno()
      mfio       := p2->fio
      mtab_nom   := p2->tab_nom
      msvod_nom  := p2->svod_nom
      m1uch      := p2->uch
      m1otd      := p2->otd
      m1kateg    := p2->kateg
      mname_dolj := p2->name_dolj
      mstavka    := p2->stavka
      m1vid      := p2->vid
      mtab_nom   := p2->tab_nom
      msvod_nom  := p2->svod_nom
      mkod_dlo   := p2->kod_dlo
      m1vr_kateg := p2->vr_kateg
      mDOLJKAT   := p2->DOLJKAT
      mD_KATEG   := p2->D_KATEG
      m1sertif   := p2->sertif
      mD_SERTIF  := p2->D_SERTIF
      m1prvs     := ret_new_spec(p2->prvs,p2->prvs_new)
      if fieldpos("profil") > 0
        fl_profil := .t.
        m1profil := p2->profil
      endif
      muroven    := p2->uroven
      motdal     := p2->otdal
      msnils     := p2->snils
      mDBEGIN    := p2->DBEGIN
      mDEND      := p2->DEND
    endif
    if mstavka <= 0
      mstavka := 1
    endif
    much      := inieditspr(A__POPUPBASE,dir_server+"mo_uch",m1uch)
    motd      := inieditspr(A__POPUPBASE,dir_server+"mo_otd",m1otd)
    mkateg    := inieditspr(A__MENUVERT,gmenu_kateg,m1kateg)
    mvid      := inieditspr(A__MENUVERT,osn_sovm,m1vid)
    mvr_kateg := inieditspr(A__MENUVERT,menu_vr_kateg,m1vr_kateg)
    msertif   := inieditspr(A__MENUVERT,mm_danet,m1sertif)
    m1prvs    := iif(empty(m1prvs), space(4), padr(lstr(m1prvs),4))
    mprvs     := ret_tmp_prvs(0,m1prvs)
    tmp_color := setcolor(cDataCScr)
    k := maxrow()-19
    if fl_profil
      --k
      mprofil := inieditspr(A__MENUVERT,glob_V002,m1profil)
    endif
    box_shadow(k-1,0,maxrow()-1,79,,;
            if(nKey == K_INS,"����������","������஢����")+" ���ଠ樨 � ���㤭���",color8)
    setcolor(cDataCGet)
    r := k
    ++r ; @ r,2 say "������� �����" get mtab_nom picture "99999" ;
                valid {|g| val_tab_nom(g,nKey) }
          @ r,36 say "������ ⠡���� �����" get msvod_nom picture "99999"
    ++r ; @ r,2 say "�.�.�." get mfio
    ++r ; @ r,2 say "�����" get msnils picture picture_pf valid val_snils(msnils,1)
    ++r ; @ r,2 say "���.ᯥ樠�쭮���" get mPRVS ;
                reader {|x|menu_reader(x,{{|k,r,c| fget_tmp_V015(k,r,c)}},A__FUNCTION,,,.f.)}
    if fl_profil
      ++r ; @ r,2 say "��䨫�" get mprofil ;
                  reader {|x|menu_reader(x,tmp_V002,A__MENUVERT_SPACE,,,.f.)}
    endif
    ++r ; @ r,2 say "���-�" get much ;
                reader {|x|menu_reader(x,{{|k,r,c| ret_uch_otd(k,r,c)}},A__FUNCTION,,,.f.)}
          @ r,39 say "�⤥�����" get motd when .f.
    ++r ; @ r,2 say "��⥣���" get mkateg ;
                reader {|x|menu_reader(x,gmenu_kateg,A__MENUVERT,,,.f.)}
    ++r ; @ r,2 say "������������ ��������" get mname_dolj
    ++r ; @ r,2 say "��� ࠡ���" get mvid ;
                reader {|x|menu_reader(x,osn_sovm,A__MENUVERT,,,.f.)}
    ++r ; @ r,36 say "�⠢��" color color8 get mstavka picture "9.99"
    ++r ; @ r,2 say "����樭᪠� ��⥣���" get mvr_kateg ;
                reader {|x|menu_reader(x,menu_vr_kateg,A__MENUVERT,,,.f.)}
    ++r ; @ r,2 say "������������ �������� �� ���.��⥣�ਨ" get mDOLJKAT
    ++r ; @ r,2 say "��� ���⢥ত���� ���.��⥣�ਨ" get mD_KATEG
    ++r ; @ r,2 say "����稥 ���䨪��" get mSERTIF ;
                reader {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)}
    ++r ; @ r,2 say "��� ���⢥ত���� ���䨪��" get mD_SERTIF
    ++r ; @ r,2 say "��� ��� ��� �믨᪨ �楯⮢ �� ���" get mKOD_DLO pict "99999"
    ++r ; @ r,2 say "��� ��砫� ࠡ��� � ��������" get mDBEGIN
    ++r ; @ r,2 say "��� ����砭�� ࠡ���" get mDEND
    status_key("^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����")
    myread()
    if lastkey() != K_ESC .and. !empty(mfio) .and. f_Esc_Enter(1)
      select P2
      if nKey == K_INS
        find ('0')
        if found()
          G_RLock(forever)
        else
          AddRecN()
        endif
        mkod := recno()
        replace kod with recno()
      else
        goto (mkod)
        G_RLock(forever)
      endif
      p2->fio      := mfio
      p2->tab_nom  := mtab_nom
      p2->svod_nom := msvod_nom
      p2->uch      := m1uch
      p2->otd      := m1otd
      p2->kateg    := m1kateg
      p2->name_dolj:= mname_dolj
      p2->stavka   := mstavka
      p2->vid      := m1vid
      p2->vr_kateg := m1vr_kateg
      p2->DOLJKAT  := mDOLJKAT
      p2->D_KATEG  := mD_KATEG
      p2->sertif   := m1sertif
      p2->D_SERTIF := mD_SERTIF
      p2->prvs_new := val(m1prvs)
      if fl_profil
        p2->profil := m1profil
      endif
      p2->uroven   := muroven
      p2->otdal    := motdal
      p2->kod_dlo  := mkod_dlo
      p2->snils    := msnils
      p2->DBEGIN   := mDBEGIN
      p2->DEND     := mDEND
      UNLOCK
      COMMIT
      oBrow:goTop()
      goto (mkod)
      ret := 0
    endif
    setcolor(tmp_color)
    restore screen from buf
  case nKey == K_DEL .and. (k := p2->kod) > 0
    buf := save_maxrow()
    s := "����! �ந�������� �஢�ઠ �� �����⨬���� 㤠����� "
    mywait(s+"human_u")
    R_Use(dir_server+"human_u",,"HU")
    set index to (dir_server+"human_uv")
    find (str(k,4))
    if !(fl := found())
      set index to (dir_server+"human_ua")
      find (str(k,4))
      fl := found()
    endif
    hu->(dbCloseArea())
    if !fl
      mywait(s+"hum_p_u")
      R_Use(dir_server+"hum_p_u",,"HU")  // �஢���� ����� ��㣨
      set index to (dir_server+"hum_p_uv")
      find (str(k,4))
      if !(fl := found())
        set index to (dir_server+"hum_p_ua")
        find (str(k,4))
        fl := found()
      endif
      hu->(dbCloseArea())
    endif
    if !fl
      mywait(s+"hum_oru")
      R_Use(dir_server+"hum_oru",,"HU") // �஢���� ��⮯����
      set index to (dir_server+"hum_oruv")
      find (str(k,4))
      if !(fl := found())
        set index to (dir_server+"hum_orua")
        find (str(k,4))
        fl := found()
      endif
      hu->(dbCloseArea())
    endif
    if !fl
      mywait(s+"kas_pl_u")
      R_Use(dir_server+"kas_pl_u",,"HU") // �஢���� �����
      index on str(kod_vr,4) to (cur_dir+"tmp_hu") for kod_vr > 0
      find (str(k,4))
      fl := found()
      hu->(dbCloseArea())
      if !fl
        mywait(s+"kas_ort")
        R_Use(dir_server+"kas_ort",,"HU")
        index on str(kod_vr,4) to (cur_dir+"tmp_hu") for kod_vr > 0
        find (str(k,4))
        if !(fl := found())
          index on str(kod_tex,4) to (cur_dir+"tmp_hu") for kod_tex > 0
          find (str(k,4))
          fl := found()
        endif
        hu->(dbCloseArea())
      endif
    endif
    rest_box(buf)
    select P2
    if fl
      func_error(4,"����� 祫���� ����砥��� � ��㣨� ����� ������. �������� ����饭�!")
    elseif f_Esc_Enter(2)
      DeleteRec(,.f.)   // ������ ��� ����⪨ �� 㤠�����
      find (str_find)
      oBrow:goTop()
      ret := 0
    endif
endcase
return ret

***** �஢�ઠ �� �����⨬���� ⠡��쭮�� �����
Function val_tab_nom(get,nKey)
Local fl := .t., rec := 0, norder
if mtab_nom > 0 .and. !(mtab_nom == get:original)
  rec := recno()
  set order to 2
  find (str(mtab_nom,5))
  do while tab_nom == mtab_nom .and. !eof()
    if nKey == K_ENTER
      if rec != recno()
        fl := .f. ; exit
      endif
    elseif nKey == K_INS
      fl := .f. ; exit
    endif
    skip
  enddo
  if !fl
    func_error(4,"������� � ����� ⠡���� ����஬ 㦥 ��������� � �ࠢ�筨�� ���ᮭ���!")
  endif
  set order to 1
  goto (rec)
  if !fl
    mtab_nom := get:original
  endif
endif
return fl

*

*****
Function f4edit_pers(nkey)
Static tmp := " "
Local buf := savescreen(), buf1, rec1 := recno(), fl := -1, tmp1, ;
      i, s, fl1
if nkey != K_F2
  return -1
endif
buf1 := savescreen(13,4,19,77)
do while .t.
  tmp1 := padr(tmp,50)
  setcolor(color8)
  box_shadow(13,14,18,67)
  @ 15,15 say center("������ �����ப� (��� ⠡���� �����) ��� ���᪠",52)
  status_key("^<Esc>^ - �⪠� �� �����")
  @ 16,16 get tmp1 picture "@K@!"
  myread()
  setcolor(color0)
  if lastkey() == K_ESC .or. empty(tmp1)
    exit
  endif
  mywait()
  tmp := alltrim(tmp1)
  // �஢�ઠ �� ���� �� ⠡.������
  fl1 := .t.
  for i := 1 to len(tmp)
    if !(substr(tmp,i,1) $ "0123456789")
      fl1 := .f. ; exit
    endif
  next
  Private tmp_mas := {}, tmp_kod := {}, t_len, k1 := mr+3, k2 := 21
  i := 0
  if fl1  // ���� �� ⠡��쭮�� ������
    set order to 2
    tmp1 := int(val(tmp))
    find (str(tmp1,5))
    do while tab_nom == tmp1 .and. !eof()
      if kod > 0
        aadd(tmp_mas,P2->fio) ; aadd(tmp_kod,P2->kod)
      endif
      skip
    enddo
    set order to 1
  else
    find (str_find)
    do while !eof()
      if tmp $ upper(fio)
        aadd(tmp_mas,P2->fio) ; aadd(tmp_kod,P2->kod)
      endif
      skip
    enddo
  endif
  if (t_len := len(tmp_kod)) = 0
    stat_msg("�� ������� �� ����� �����, 㤮���⢮���饩 ������� ������!")
    mybell(2)
    restscreen(13,4,19,77,buf1)
    loop
  elseif t_len == 1  // �� ⠡��쭮�� ����� ������� ���� ��ப�
    goto (tmp_kod[1])
    fl := 0
    exit
  else
    box_shadow(mr,2,22,77)
    SETCOLOR("B/BG")
    @ k1-2,15 say "�����ப�: "+tmp
    SETCOLOR(color0)
    if k1+t_len+2 < 21
      k2 := k1 + t_len + 2
    endif
    @ k1,3 say center(" ������⢮ ��������� 䠬���� - "+lstr(t_len),74)
    status_key("^<Esc>^ - �⪠� �� �롮�")
    if (i := popup(k1+1,13,k2,66,tmp_mas,,color0)) > 0
      goto (tmp_kod[i])
      fl := 0
    endif
    exit
  endif
enddo
if fl == -1
  goto rec1
endif
restscreen(buf)
return fl

***** 23.01.17 ���樠����஢��� tmp-䠩� �� ����樭᪨� ᯥ樠�쭮�⥩
Function init_tmp_prvs(_date,is_all)
Local i, s, len1, fl_is, rec, tmp_select := select()
DEFAULT is_all TO .f.
len1 := 0
_glob_array := glob_V004
for i := 1 to len(_glob_array)
  if iif(is_all, .t., between_date(_glob_array[i,3],_glob_array[i,4],_date))
    len1 := max(len1,len(lstr(_glob_array[i,2])+alltrim(_glob_array[i,1]))+1)
  endif
next
dbcreate(cur_dir+"tmp_V004",{{"name","C",len1,0},;
                             {"kod","C",9,0},;
                             {"is","L",1,0}})
use (cur_dir+"tmp_V004") new
for i := 1 to len(_glob_array)
  fl_is := between_date(_glob_array[i,3],_glob_array[i,4],_date)
  if iif(is_all, .t., fl_is)
    append blank
    replace name with lstr(_glob_array[i,2])+'.'+_glob_array[i,1], ;
            kod with padr(lstr(_glob_array[i,2]),9), ;
            is with fl_is
  endif
next
index on upper(name) to (cur_dir+"tmp_V004")
index on kod to (cur_dir+"tmpkV004")
tmp_V004->(dbCloseArea())
//
len1 := 0
// _glob_array := glob_V015
_glob_array := getV015()
for i := 1 to len(_glob_array)
  if iif(is_all, .t., between_date(_glob_array[i,5],_glob_array[i,6],_date))
    len1 := max(len1,len(lstr(_glob_array[i,2])+alltrim(_glob_array[i,1]))+1)
  endif
next
dbcreate(cur_dir+"tmp_V015",{{"name","C",len1,0},;
                             {"kod","C",4,0},;
                             {"kod_up","C",4,0},;
                             {"vs","C",4,0},;
                             {"name_up","C",50,0},;
                             {"uroven","N",1,0},;
                             {"sindex","C",56,0},;
                             {"isn","N",1,0},;
                             {"is","L",1,0}})
use (cur_dir+"tmp_V015") new
for i := 1 to len(_glob_array)
  fl_is := between_date(_glob_array[i,5],_glob_array[i,6],_date)
  if iif(is_all, .t., fl_is)
    append blank
    replace name with lstr(_glob_array[i,2])+'.'+_glob_array[i,1], ;
            kod with lstr(_glob_array[i,2]), ;
            kod_up with _glob_array[i,3], ;
            is with fl_is
  endif
next
index on upper(name) to (cur_dir+"tmp_V015")
index on kod to (cur_dir+"tmpkV015")
set order to 0
go top
do while !eof()
  rec := recno()
  i := 0 ; s := upper(padr(afteratnum(".",tmp_V015->name,1),10))+tmp_V015->kod
  svs := "" ; anu := {}
  set order to 1
  do while .t.
    if empty(tmp_V015->kod_up)
      svs := iif(int(val(tmp_V015->kod)) == 0, "���", "�।")
      exit
    endif
    find (tmp_V015->kod_up)
    if found()
      if i == 9 ; exit ; endif
      s := upper(padr(afteratnum(".",tmp_V015->name,1),10))+tmp_V015->kod+s
      if !empty(tmp_V015->kod_up)
        aadd(anu,tmp_V015->name)
      endif
      ++i
    else
      exit
    endif
  enddo
  set order to 0
  goto (rec)
  tmp_V015->uroven := i
  tmp_V015->sindex := s
  tmp_V015->vs := svs
  s := ""
  for i := 1 to min(2,len(anu))
    if !empty(s)
      s := left(s,10)+"/"
    endif
    s += anu[i]
  next
  tmp_V015->name_up := s
  skip
enddo
index on sindex to (cur_dir+"tmpsV015")
tmp_V015->(dbCloseArea())
select (tmp_select)
return NIL

***** 09.08.16 ������ ����樭��� ᯥ樠�쭮��� �� tmp-䠩��
Function ret_tmp_prvs(kod_old,kod_new)
Local i, k, tmp_select := select(), ret := space(10)
if empty(kod_new)
  if valtype(kod_old) == "C"
    k := int(val(kod_old))
  else
    k := kod_old
  endif
  if k < 0 // ����� ᯥ樠�쭮��� ����ᥭ� � ���� ����
    k := abs(k)
    k := padr(lstr(k),4)
    use (cur_dir+"tmp_V015") index (cur_dir+"tmpkV015") new
    find (k)
    if found()
      ret := alltrim(tmp_V015->name)
    endif
    tmp_V015->(dbCloseArea())
    select (tmp_select)
    return ret
  endif
  if (i := ascan(glob_arr_V004_V015, {|x| x[1] == k })) > 0
    return lstr(glob_arr_V004_V015[i,2])+"."+glob_arr_V004_V015[i,3]
  endif
  if valtype(kod_old) == "N"
    k := padr(lstr(kod_old),9)
  else
    k := kod_old
  endif
  use (cur_dir+"tmp_V004") index (cur_dir+"tmpkV004") new
  find (k)
  if found()
    ret := alltrim(tmp_V004->name)
  endif
  tmp_V004->(dbCloseArea())
else
  if valtype(kod_new) == "N"
    k := padr(lstr(kod_new),4)
  else
    k := kod_new
  endif
  use (cur_dir+"tmp_V015") index (cur_dir+"tmpkV015") new
  find (k)
  if found()
    ret := alltrim(tmp_V015->name)
  endif
  tmp_V015->(dbCloseArea())
endif
select (tmp_select)
return ret

** 17.05.22 ।���஢���� �ࠢ�筨�� �⤥�����
Function edit_otd()
Local i, j, blk, arr[US_LEN], fl
if input_uch(T_ROW-1,T_COL+5) == NIL
  return NIL
endif
Private tmp_V002 := create_classif_FFOMS(1,"V002") // PROFIL
Private tmp_V020 := create_classif_FFOMS(1,"V020") // PROFIL_K
Private tmp_V006 := create_classif_FFOMS(1,"V006") // USL_OK
//Private tmp_V008 := create_classif_FFOMS(1,"V008") // VIDPOM
//Private tmp_V010 := create_classif_FFOMS(1,"V010") // IDSP
Private mm_adres_podr := {}
Private mm_tiplu := {;
  {"�⠭�����"                          ,0           },;  // 1
  {"᪮�� ����樭᪠� ������"            ,TIP_LU_SMP  },;  // 2
  {"���-�� ��⥩-��� � ��樮���"     ,TIP_LU_DDS  },;  // 3
  {"���-�� ��⥩-��� ��� ������"       ,TIP_LU_DDSOP},;  // 4
  {"��䨫��⨪� ��ᮢ�襭����⭨�"       ,TIP_LU_PN   },;  // 5
  {"�।����.�ᬮ��� ��ᮢ�襭����⭨�"  ,TIP_LU_PREDN},;  // 6
  {"��ਮ���.�ᬮ��� ��ᮢ�襭����⭨�"   ,TIP_LU_PERN },;  // 7
  {"��ᯠ��ਧ���/���ᬮ�� ������"  ,TIP_LU_DVN  },;  // 8
  {"�७�⠫쭠� �������⨪�"             ,TIP_LU_PREND},;  // 9
  {"����������"                           ,TIP_LU_H_DIA},;  // 10
  {"���⮭����� ������"                ,TIP_LU_P_DIA},;  // 11
  {"COVID - 㣫㡫����� ��ᯠ��ਧ���" ,TIP_LU_DVN_COVID},;  // 15
  {"����樭᪠� ॠ�������"            ,TIP_LU_MED_REAB}}  // 16
if glob_mo[_MO_KOD_TFOMS] == '126501'
  Ins_Array(mm_tiplu, 3, {"���⫮���� ����樭᪠� ������",TIP_LU_NMP})
endif
if ascan(glob_klin_diagn,1) > 0
  aadd(mm_tiplu, {"������⭠� �⮫���� ࠪ� 襩�� ��⪨",TIP_LU_G_CIT})
elseif ascan(glob_klin_diagn,2) > 0
  aadd(mm_tiplu, {"�७�⠫�� �ਭ��� �����.�����.ࠧ�.",TIP_LU_G_CIT})
endif
Private mm1tiplu := aclone(mm_tiplu)
hb_ADel( mm1tiplu, 7 , .t. )
hb_ADel( mm1tiplu, 6 , .t. )
blk := {|| iif(between_date(dbegin,dend), {1,2}, {3,4}) }
arr[US_BOTTOM   ] := maxrow()-2
arr[US_LEFT     ] := 2
arr[US_RIGHT    ] := 77
arr[US_BASE     ] := dir_server+"mo_otd"
arr[US_TITUL    ] := glob_uch[2]
arr[US_TITUL_COLOR] := "BG+/GR"
arr[US_ARR_BROWSE]:= {"�","�","�","N/BG,W+/N,B/BG,W+/B",.t.}
arr[US_BLK_FILTER]:= {|| dbSetFilter( {|| kod_lpu == glob_uch[1]}, "kod_lpu == glob_uch[1]" ) }
arr[US_BLK_WRITE] := {|| __us->kod_lpu := glob_uch[1] }
arr[US_COLUMN   ] := {{" ������������ �⤥�����",{|| name},blk},;
                      {" ",{|| iif(empty(KOD_PODR)," ","�")},blk},;
                      {"����.",{|| short_name},blk},;
                      {" ��� ���� ����",{|| padr(inieditspr(A__MENUVERT,mm_tiplu,tiplu),19)},blk},;
                      {" ��䨫�",{|| padr(inieditspr(A__MENUVERT,glob_V002,profil),15)},blk};
                     }
arr[US_BLK_DEL  ] := {|_k| fdel_otd(_k) }
arr[US_IM_PADEG ] := arr[US_SEMAPHORE] := "�⤥�����"
arr[US_ROD_PADEG] := "�⤥�����"
arr[US_EDIT_SPR ] := {{"name","C",30,0,,,space(30),,"������������ �⤥�����"},;
                      {"short_name","C",5,0,,,space(5),,"�����񭭮� ������������ �⤥�����"},;
                      {"TIPLU","N",2,0,,;
                       {|x|menu_reader(x,mm1tiplu,A__MENUVERT,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,mm_tiplu,x)},;
                       "��� ���� ���� �� ����� ������"},;
                      {"TIP_OTD","N",2,0,,;
                       {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,mm_danet,x)},;
                       "������� ������ �⤥����� ���� ������ ��樮���"},;
                      {"PROFIL","N",3,0,,;
                       {|x|menu_reader(x,tmp_V002,A__MENUVERT_SPACE,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,glob_V002,x)},;
                       "��䨫� ���.�����"},;
                      {"PROFIL_K","N",3,0,,;
                       {|x|menu_reader(x,tmp_V020,A__MENUVERT_SPACE,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT, getV020(), x)},;
                       "��䨫� �����"},;
                      {"IDUMP","N",2,0,,;
                       {|x|menu_reader(x,tmp_V006,A__MENUVERT,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,glob_V006,x)},;
                       "�᫮��� �������� ����樭᪮� �����"},;
                      {"KOD_PODR","C",25,0,,;
                       {|x| menu_reader(x,{{|k,r,c| get_kod_podr(k,r,c)}},A__FUNCTION,,,.f.)},;
                       "",{|x| ini_kod_podr(x)},;
                       "��� ���ࠧ������� �� ��ᯮ�� ���"},;
                      {"ADDRESS","C",150,0,,,space(150),,"����"},;
                      {"dbegin","D",8,0,,,boy(sys_date),,;
                       "��� ��砫� ࠡ��� � ����� ���"},;
                      {"dend","D",8,0,,,ctod(""),,;
                       "     ��� ����砭�� ࠡ��� � ����� ���"};
                      }
if is_otd_dep
  Ins_Array(arr[US_EDIT_SPR],6,{"CODE_DEP","N",2,0,,;
                                {|x|menu_reader(x,mm_otd_dep,A__MENUVERT_SPACE,,,.f.)},;
                                0,{|x|inieditspr(A__MENUVERT,mm_otd_dep,x)},;
                                "�� �ࠢ�筨�� �����"})
endif
/*if is_adres_podr
  if (i := ascan(glob_adres_podr, {|x| x[1] == glob_mo[_MO_KOD_TFOMS] })) > 0
    for j := 1 to len(glob_adres_podr[i,2])
      aadd(mm_adres_podr, {glob_adres_podr[i,2,j,3],glob_adres_podr[i,2,j,2]})
    next
  endif
  Ins_Array(arr[US_EDIT_SPR],7,{"ADRES_PODR","N",2,0,,;
                                {|x|menu_reader(x,mm_adres_podr,A__MENUVERT,,,.f.)},;
                                0,{|x|inieditspr(A__MENUVERT,mm_adres_podr,x)},;
                                "���� 㤠�񭭮�� ���ࠧ������� ��� ��樮���"})
endif
if is_adres_podr .and. (i := ascan(glob_adres_podr, {|x| x[1] == glob_mo[_MO_KOD_TFOMS] })) > 0
  G_Use(dir_server+"mo_otd",,"OTD")
  go top
  do while !eof()
    if otd->ADRES_PODR > 0 .and. (j := ascan(glob_adres_podr[i,2], {|x| x[2] == otd->ADRES_PODR })) > 0 ;
                           .and. !(otd->CODE_TFOMS == glob_adres_podr[i,2,j,1])
      G_RLock(forever)
      otd->CODE_TFOMS := glob_adres_podr[i,2,j,1]
      UnLock
    endif
    skip
  enddo
  close databases
endif*/
if is_task(X_PLATN)
  aadd(arr[US_EDIT_SPR],{"dbeginp","D",8,0,,,boy(sys_date),,;
                         '��� ��砫� ࠡ��� � ����� "����� ��㣨"'})
  aadd(arr[US_EDIT_SPR],{"dendp","D",8,0,,,ctod(""),,;
                         '     ��� ����砭�� ࠡ��� � ����� "����� ��㣨"'})
endif
if is_task(X_ORTO)
  aadd(arr[US_EDIT_SPR],{"dbegino","D",8,0,,,boy(sys_date),,;
                         '��� ��砫� ࠡ��� � ����� "��⮯����"'})
  aadd(arr[US_EDIT_SPR],{"dendo","D",8,0,,,ctod(""),,;
                         '     ��� ����砭�� ࠡ��� � ����� "��⮯����"'})
endif
aadd(arr[US_EDIT_SPR], {"PLAN_VP","N",6,0,,,0,,"���� ��祡��� �ਥ��� �� �����"})
aadd(arr[US_EDIT_SPR], {"PLAN_PF","N",6,0,,,0,,"���� ��䨫��⨪ �� �����"})
aadd(arr[US_EDIT_SPR], {"PLAN_PD","N",6,0,,,0,,"���� �ਥ��� �� ���� �� �����"})
edit_u_spr(1,arr)
/*if is_adres_podr .and. (i := ascan(glob_adres_podr, {|x| x[1] == glob_mo[_MO_KOD_TFOMS] })) > 0
  G_Use(dir_server+"mo_otd",,"OTD")
  go top
  do while !eof()
    if otd->ADRES_PODR > 0 .and. (j := ascan(glob_adres_podr[i,2], {|x| x[2] == otd->ADRES_PODR })) > 0 ;
                           .and. !(otd->CODE_TFOMS == glob_adres_podr[i,2,j,1])
      G_RLock(forever)
      otd->CODE_TFOMS := glob_adres_podr[i,2,j,1]
      UnLock
    endif
    skip
  enddo
  close databases
endif*/
return NIL

*****
Static Function fdel_otd(k)
Local _fl, i, tmp_select := select()
R_Use(dir_server+"mo_pers",,"__B")
dbLocateProgress( {|| __b->otd == k} )
_fl := !found()
dbCloseArea()
if _fl
  R_Use(dir_server+"human",dir_server+"humann","__B")
  for i := 0 to 9
    find (str(i,1)+str(k,3)) // index on str(tip_h,1)+str(otd,3)+...
    if found()
      _fl := .f. ; exit
    endif
  next
  dbCloseArea()
endif
if _fl
  R_Use(dir_server+"hum_p",dir_server+"hum_pn","__B")
  find (str(k,3)) // index on str(otd,3)+...
  _fl := !found()
  dbCloseArea()
endif
select (tmp_select)
return _fl

***** 06.06.15
Static Function get_kod_podr(k,r,c)
Static arr
Local ret, ret_arr, tmp_select
if arr == NIL // ⮫쪮 �� ��ࢮ� �맮��
  arr := {}
  tmp_select := select()
  R_Use(exe_dir+"_mo_podr",cur_dir+"_mo_podr","PODR")
  find (glob_mo[_MO_KOD_TFOMS])
  do while podr->codemo == glob_mo[_MO_KOD_TFOMS] .and. !eof()
    aadd(arr,{"("+alltrim(podr->KODOTD)+") "+alltrim(podr->NAMEOTD),podr->KODOTD})
    skip
  enddo
  Use
  select (tmp_select)
endif
popup_2array(arr,-r,c,k,1,@ret_arr,"�롮� �� ��ᯮ�� ���","GR+/RB","BG+/RB,N/BG")
if valtype(ret_arr) == "A"
  ret := array(2)
  ret[1] := ret_arr[2]
  ret[2] := ret_arr[1]
endif
return ret
return {lkod,s}

***** 06.06.15
Static Function ini_kod_podr(lkod)
Local s := space(10), tmp_select := select()
R_Use(exe_dir+"_mo_podr",cur_dir+"_mo_podr","PODR")
find (glob_mo[_MO_KOD_TFOMS]+padr(upper(lkod),25))
if found()
  s := "("+alltrim(podr->KODOTD)+") "+alltrim(podr->NAMEOTD)
endif
Use
select (tmp_select)
return s

*

***** ।���஢���� �ࠢ�筨�� ��०�����
Function edit_uch()
Local blk, arr[US_LEN]
blk := {|| iif(between_date(dbegin,dend), {1,2}, {3,4}) }
arr[US_BOTTOM   ] := maxrow()-2
arr[US_LEFT     ] := T_COL+5
arr[US_RIGHT    ] := arr[US_LEFT]+48
arr[US_BASE     ] := dir_server+"mo_uch"
arr[US_ARR_BROWSE]:= {"�","�","�","N/BG,W+/N,B/BG,W+/B",.t.}
arr[US_COLUMN   ] := {{" ������������",{|| name},blk},;
                      {"����.;����.",{|| SHORT_NAME },blk},;
                      {"����� �;⠫����",{|| padc(inieditspr(A__MENUVERT,mm_danet,is_talon),8) },blk}}
arr[US_BLK_DEL  ] := {|_k| fdel_uch(_k) }
arr[US_IM_PADEG ] := arr[US_SEMAPHORE] := "��०�����"
arr[US_ROD_PADEG] := "��०�����"
arr[US_EDIT_SPR ] := {{"name","C",30,0,,,space(30),,"������������ ��०�����"},;
                      {"short_name","C",5,0,,,space(5),,"�����񭭮� ������������"},;
                      {"ADDRESS","C",150,0,,,space(150),,"����"},;
                      {"is_talon","N",1,0,,;
                       {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)},;
                       0,{|x|inieditspr(A__MENUVERT,mm_danet,x)},;
                       "����⠥� � ���.⠫����?"},;
                      {"dbegin","D",8,0,,,boy(sys_date),,;
                       "��� ��砫� ࠡ��� � ��०������"},;
                      {"dend","D",8,0,,,ctod(""),,;
                       "     ��� ����砭�� ࠡ���"};
                     }
edit_u_spr(1,arr)
return NIL

*****
Static Function fdel_uch(k)
Local _fl, tmp_select := select()
R_Use(dir_server+"mo_otd",,"__B")
dbLocateProgress( {|| __b->kod_lpu == k} )
_fl := !found()
dbCloseArea()
select (tmp_select)
return _fl

*

***** ।���஢���� �ࠢ�筨�� ���� ��������
Function edit_strah()
Static mas_edit := { "~��ᬮ��",;
                     "~������஢����",;
                     "~����������",;
                     "~��������"}
Local arr := aclone(gmenu_strah)
Local i := 1, k, buf := savescreen(), str_sem := "������஢���� ���� ��������"
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
if (k := ascan(arr,{|x| lower(x[1]) == "tfoms"})) > 0
  Del_Array(arr,k)
endif
do while i > 0
  if (i := popup_prompt(T_ROW, T_COL+5, i, mas_edit,,,,.f.)) == A__APPEND
    if (k := f_edit_spr(A__APPEND,arr,"��祩 ��������",;
                        "use_base('str_komp')",2,,,,,,"f_emp_strah")) > 0
      glob_strah[1] := k
    endif
  elseif i != 0 .and. ;
     (k := popup_edit(dir_server+"str_komp",T_ROW+i+1,T_COL+5,;
        T_ROW+i+7,glob_strah[1],PE_RETURN,,,,{||!between(tfoms,44,47)})) != NIL
    glob_strah := k
    f_edit_spr(i,arr,"��祩 ��������",;
               "use_base('str_komp')",2,k[1],,"fdel_strah",,,"f_emp_strah")
  endif
enddo
G_SUnLock(str_sem)
restscreen(buf)
return NIL

***** ।���஢���� �ࠢ�筨�� �����⮢ (��)
Function edit_komit(d)
Static mas_edit := { "~��ᬮ��",;
                     "~������஢����",;
                     "~����������",;
                     "~��������"}
Local i := 1, k, buf := savescreen(), str_sem := "������஢���� �����⮢ (��)"
if !G_SLock(str_sem)
  return func_error(4,err_slock)
endif
do while i > 0
  if (i := popup_prompt(T_ROW, T_COL+5, i, mas_edit,,,,.f.)) == A__APPEND
    if (k := f_edit_spr(A__APPEND,gmenu_komit,"������� (��)",;
                        "use_base('komitet')",2,,,,,,"f_emp_strah")) > 0
      glob_komitet[1] := k
    endif
  elseif i != 0 .and. ;
         (k := popup_edit(dir_server+"komitet",T_ROW+i+1,T_COL+5,;
                          T_ROW+i+7,glob_komitet[1],PE_RETURN)) != NIL
    glob_komitet := k
    f_edit_spr(i,gmenu_komit,"������� (��)",;
               "use_base('komitet')",2,k[1],,"fdel_komit",,,"f_emp_strah")
  endif
enddo
G_SUnLock(str_sem)
restscreen(buf)
return NIL

*****
Function fdel_strah(k)
Local fl := fdel_ksc(1,k)
if !fl
  func_error(4,"������ �������� ����砥��� � ��㣨� ����� ������!")
endif
return fl

*****
Function fdel_komit(k)
Local fl := fdel_ksc(3,k)
if !fl
  func_error(4,"����� ������ (��) ����砥��� � ��㣨� ����� ������!")
endif
return fl

*****
Function fdel_ksc(n,k)
Local fl := .t., buf, i, afile := {"kartotek","human"}
if k == 1
  buf := save_maxrow()
  stat_msg("����! �ந�������� �஢�ઠ �� �����⨬���� 㤠�����.")
  for i := 1 to len(afile)
    R_Use(dir_server+afile[i],,"KK")
    Locate for kk->komu == n .and. kk->str_crb == mkod ;
               progress {"GR+/B","GR+/B","W*/B"} NUMPROCENT
    fl := !found()
    Use
    if !fl ; exit ; endif
  next
  rest_box(buf)
endif
return fl

*****
Function f_emp_strah(k)
Local fl := .t.
if k == 1 .and. empty(mname)
  fl := func_error(4,"���� �������� �� ������ ���� �����!")
endif
return fl
