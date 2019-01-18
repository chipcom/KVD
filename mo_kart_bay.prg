***** mo_kart.prg - ०��� ࠡ��� � ����⥪��
#include "inkey.ch"
#include "..\_mylib_hbt\function.ch"
#include "..\_mylib_hbt\edit_spr.ch"
#include "chip_mo.ch"

***** 10.03.13 ����� � ����⥪�� � ����� ���
Function oms_kartoteka(k)
Static si1 := 1
Local mas_pmt, mas_msg, mas_fun, j
DEFAULT k TO 0
do case
  case k == 0
    mas_pmt := {"~����������",;
                "~������஢����",;
                "�㡫����騥�� ~�����",;
                "~��������",;
                "��ᬮ�� / ~�����"}
    mas_msg := {"���������� � ����⥪� ���ଠ樨 � ���쭮�",;
                "������஢���� ���ଠ樨 �� ����窨 ���쭮��",;
                "���� � 㤠����� �㡫�������� ����ᥩ � ����⥪�",;
                "�������� ����窨 ���쭮�� �� ����⥪�",;
                "��ᬮ�� / ����� ᯨ᪮� �� ��⥣���, ��������, ࠩ����, ���⪠�,..."}
    mas_fun := {"oms_kartoteka(1)",;
                "oms_kartoteka(2)",;
                "oms_kartoteka(3)",;
                "oms_kartoteka(4)",;
                "oms_kartoteka(5)"}
    if glob_mo[_MO_IS_UCH]
      aadd(mas_pmt, "�ਪ९�񭭮� ~��ᥫ����")
      aadd(mas_msg, "����� � �ਪ९��� ��ᥫ�����")
      aadd(mas_fun, "oms_kartoteka(6)")
    endif
    popup_prompt(T_ROW,T_COL+5,si1,mas_pmt,mas_msg,mas_fun)
  case k == 1
    append_kart()
  case k == 2
    regi_kart()
  case k == 3
    dubl_zap()
  case k == 4
    view_kart(2)
  case k == 5
    prn_kartoteka()
  case k == 6
    pripisnoe_naselenie()
endcase
if between(k,1,9)
  si1 := k
endif
return NIL

*****
Function regi_kart()
if (lkod := polikl1_kart()) >= 0
  view_kart(1)
endif
return NIL

*

***** ���������� � ����⥪�
Function append_kart()
Local k := edit_kartotek(0)
if k > 0
  if mem_kodkrt == 2 .and. !(is_uchastok == 1)
    f_message({"",;
       "�������樮��� ����� ������������ ���쭮�� - "+lstr(k),""},;
       "W",,,16)
    if glob_task == X_REGIST // ॣ�������
      keyboard chr(K_UP)+chr(K_ENTER)
    endif
  endif
endif
return NIL

*

***** 03.09.17
Function edit_kartotek1(mkod,_top_r,_bot_r,fl_oms,_Human_kod)
Local ar := GetIniVar(tmp_ini,{{"RAB_MESTO","kart_polis","1"}} )
Private p_edit_kartoteka := .f., p_find_polis := int(val(ar[1]))
mkod := edit_kartotek_(mkod,_top_r,_bot_r,fl_oms,_Human_kod)
if p_edit_kartoteka
  glob_kartotek := mkod
  p_edit_kartoteka := .f.
  mkod := edit_kartotek_(mkod,_top_r,_bot_r,fl_oms,_Human_kod)
endif
return mkod

***** 29.08.17
Function edit_kartotek_1(mkod,_top_r,_bot_r,fl_oms,_Human_kod)
Static mm_kart_error := {{"��� ����砭��",0},{"����� ������⢨⥫��",-8},{"�訡�� � ४������",-9}}
Static mm_invalid := {{"���",0},{"1 ��㯯�",1},{"2 ��㯯�",2},{"3 ��㯯�",3},{"���-��������",4}}
Static mm_where_kart := {{"� ॣ�������",0},{"� ���",1},{"�� �㪠�",2}}
Static st_rab_nerab := 0
Local tmp_color := setcolor(), tmp_help := chm_help_code, buf := savescreen(),;
      i, c, arr, arr1, dolya := 1, lapp_edit, llen, ldec, in_array, out_array, ;
      is_append := (mkod == 0), old_arr_kart, flag_DVN,;
      pos_read := 0, k_read := 0, count_edit := 0,;
      count_row := 0, title_top, fl_mr_dol := .f., fl_kis := .f.
DEFAULT fl_oms TO .f., _Human_kod TO 0
change_attr()
if !(type("_task_263_") == "L")
  Private _task_263_ := .f.
endif
Private is_smp := fl_oms .and. ((type("m1usl_ok")=="N" .and. m1usl_ok==4) .or.;
                                (len(glob_otd) > 2 .and. glob_otd[3] == 4))
Private M1NOVOR := 0 // ��।����� ����� ���祭�� � "�����" ��஥
Private is_talon := ret_is_talon()
Private mbukva := " ", muchast := 0, mkod_vu := 0, mkod_AK := space(6),;
    mkart_error, m1kart_error := 0,;
    MFIO        := space(50)         ,; // �.�.�. ���쭮��
    mfam := space(40), mim := space(40), mot := space(40),;
    mpol        := "�"            ,;
    mdate_r     := boy(addmonth(sys_date,-12*30)) ,;
    MANONIM, M1ANONIM := 0,;
    MVZROS_REB, M1VZROS_REB := 0,;
    MADRES      := space(50)         ,; // ���� ���쭮��
    MMR_DOL     := space(50)         ,; // ���� ࠡ��� ��� ��稭� ���ࠡ�⭮��
    MRAB_NERAB, M1RAB_NERAB := st_rab_nerab,; // 0-ࠡ���騩, 1 -��ࠡ���騩
    m1MEST_INOG := 0, newMEST_INOG := 0,;
    s_prim1     := ""                ,;
    MVID_UD                          ,; // ��� 㤮�⮢�७��
    M1VID_UD    := 14                ,; // 1-18
    mser_ud := space(10), mnom_ud := space(20), ;
    MKEMVYD, M1KEMVYD := 0, MKOGDAVYD := ctod(""),; // ��� � ����� �뤠� ��ᯮ��
    mspolis := space(10), mnpolis := space(20), msmo := space(5),;
    mnamesmo, m1namesmo,;
    m1company := 0, mcompany, mm_company, ;
    m1KOMU := 0, MKOMU, M1STR_CRB := 0, ;
    mBEG_POLIS := ctod(""), MSROK_POLIS := ctod(""),; // �ப ����⢨� ���客��� �����
    mSTRANA := space(10), m1strana := "",;
    mosn_preb, m1osn_preb := 0,;
    mvidpolis, m1vidpolis := 1, mmesto_r := space(100),;
    mgragd, m1gragd,;
    msnils := space(11),;
    m1gorod_selo := 1, mgorod_selo,;
    mkategor, m1kategor := atail(stm_kategor)[2],;  // �.�. ��稥
    mkategor2, m1kategor2 := 0,;
    mokatog := padr(alltrim(okato_umolch),11,"0"), mokatop := space(11), madresp := space(50),;
    m1adres_reg := 1, madres_reg,;
    m1adres_pre := 1, madres_pre,;
    mPHONE_H := space(11), mPHONE_M := space(11), mPHONE_W := space(11),;
    m1KOD_LGOT := space(3), mKOD_LGOT,;
    m1PENSIONER := 0, mPENSIONER,;
    fl_invalid := .f., m1INVALID := 0, mINVALID, mINVALID_ST := 0,;
    MDATE_INV := CTOD(""),; // ��� ��ࢨ筮�� ��⠭������� �����������
    MPRICH_INV := SPACE(10), M1PRICH_INV := 0,; // ��稭� ��ࢨ筮�� ��⠭������� �����������
    mDIAG_INV := space(5),;  // 
    mBLOOD_G := 0, mBLOOD_R := " ", mWEIGHT := 0, mHEIGHT := 0,;
    m1WHERE_KART := 0, mWHERE_KART, rec_inogSMO := 0, ;
    mokato, m1okato := "", mismo, m1ismo := "", mnameismo := space(100),;
    MADRES_PRO := space(60)          ,; // ���� �஦������ � ����.���.
    MMIGR_KARTA := space(20)         ,; // ����� ����樮���� �����
    MDATE_P_G := ctod("")            ,; // ��� ����祭�� �࠭���
    MDATE_R_M := ctod("")            ,; // ��� ॣ����樨 � ����樮���� �㦡�
    MKOL_PRED := 0,;
    MFIO_PR1 := space(50),;
    M1STATUS_PR1 := 0,;
    M1IS_UHOD_PR1 := 0,;
    M1IS_FOOD_PR1 := 0,;
    MDATE_R_PR1 := ctod(""),;
    MADRES_PR1 := space(50),;
    MMR_DOL_PR1 := space(50),;
    MPHONE_PR1 := space(11),;
    MPASPORT_PR1 := space(15),;
    MPOLIS_PR1 := space(25),;
    MFIO_PR2 := space(50),;
    M1STATUS_PR2 := 0,;
    MDATE_R_PR2 := ctod(""),;
    MADRES_PR2 := space(50),;
    MMR_DOL_PR2 := space(50),;
    MPHONE_PR2 := space(11),;
    MPASPORT_PR2 := space(15),;
    MPOLIS_PR2 := space(25),;
    mmo_pr := "",;
    gl_area := {1,0,maxrow()-1,79,0}
//
if !is_append .and. R_Use(dir_server+"kartote_",,"KART_") ;
              .and. R_Use(dir_server+"kartote2",,"KART2") ;
              .and. R_Use(dir_server+"kartotek",,"KART")
  select KART
  goto (mkod)
  in_array := get_field()
  m1kart_error := kart->ZA_SMO
  mFIO        := kart->FIO
  mpol        := kart->pol
  mDATE_R     := kart->DATE_R
  m1VZROS_REB := kart->VZROS_REB
  mADRES      := kart->ADRES
  mMR_DOL     := kart->MR_DOL
  msrok_polis := c4tod(kart->srok_polis)
  m1RAB_NERAB := kart->RAB_NERAB
  msnils      := kart->snils
  if kart->MI_GIT == 9
    m1KOMU    := kart->KOMU
    M1STR_CRB := kart->STR_CRB
  endif
  if kart->MEST_INOG == 8 // �.�. ������
    if eq_any(glob_task,X_PLATN,X_KASSA) .and. mem_anonim == 1
      M1ANONIM := 1
    endif
  elseif kart->MEST_INOG == 9 // �.�. �⤥�쭮 ����ᥭ� �.�.�.
    m1MEST_INOG := kart->MEST_INOG
  endif
  if is_uchastok > 0
    mbukva  := kart->bukva
    muchast := kart->uchast
    mkod_vu := kart->kod_vu
  endif
  select KART2
  goto (mkod)
  if !eof()
    if is_uchastok == 3
      mkod_AK := left(kart2->kod_AK,6)
    endif
    if glob_mo[_MO_IS_UCH]
      if left(kart2->PC2,1) == "1"
        mmo_pr := "�� ���ଠ樨 �� ����� ��樥�� �_�_�_�"
      elseif kart2->MO_PR == glob_mo[_MO_KOD_TFOMS]
        mmo_pr := "�ਪ९�� "
        if !empty(kart2->pc4)
          mmo_pr += "� "+alltrim(kart2->pc4)+" "
        elseif !empty(kart2->DATE_PR)
          mmo_pr += "� "+date_8(kart2->DATE_PR)+" "
        endif
        mmo_pr += "� ��襩 ��"
      else
        s := alltrim(inieditspr(A__MENUVERT,glob_arr_mo,kart2->mo_pr))
        if empty(s)
          mmo_pr := "�ਪ९����� --- �������⭮ ---"
        else
          mmo_pr := ""
          if !empty(kart2->pc4)
            mmo_pr += "� "+alltrim(kart2->pc4)+" "
          elseif !empty(kart2->DATE_PR)
            mmo_pr += "� "+date_8(kart2->DATE_PR)+" "
          endif
          mmo_pr += "�ਪ९�� � " + s
        endif
      endif
    endif
  endif
  select KART_
  goto (mkod)
  m1vidpolis  := kart_->VPOLIS // ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����
  mspolis     := kart_->SPOLIS // ��� �����
  mnpolis     := kart_->NPOLIS // ����� �����
  msmo        := kart_->SMO    // ॥��஢� ����� ���
  mBEG_POLIS  := c4tod(kart_->beg_polis) // ��� ��砫� ����⢨� �����
  m1strana    := kart_->strana // �ࠦ����⢮ ��樥�� (��࠭�)
  m1gorod_selo:= kart_->gorod_selo // ��⥫�?;1-��த, 2-ᥫ�, 3-ࠡ�稩 ��ᥫ��
  m1vid_ud    := kart_->vid_ud   // ��� 㤮�⮢�७�� ��筮��
  mser_ud     := kart_->ser_ud   // ��� 㤮�⮢�७�� ��筮��
  mnom_ud     := kart_->nom_ud   // ����� 㤮�⮢�७�� ��筮��
  m1kemvyd    := kart_->kemvyd   // ��� �뤠� ���㬥��
  mkogdavyd   := kart_->kogdavyd // ����� �뤠� ���㬥��
  m1kategor   := kart_->kategor  // ��⥣��� ��樥��
  m1kategor2  := kart_->kategor2 // ��⥣��� ��樥�� (ᮡ�⢥���� ��� ��)
  mmesto_r    := kart_->mesto_r      // ���� ஦�����;;
  mokatog     := kart_->okatog       // ��� ���� ��⥫��⢠ �� �����
  mokatop     := kart_->okatop       // ��� ���� �ॡ뢠��� �� �����
  madresp     := kart_->adresp       // ���� ���� �ॡ뢠���
  mPHONE_H    := kart_->PHONE_H      // ⥫�䮭 ����譨�;;
  mPHONE_M    := kart_->PHONE_M      // ⥫�䮭 �������;;
  mPHONE_W    := kart_->PHONE_W      // ⥫�䮭 ࠡ�稩;;
  m1KOD_LGOT  := kart_->KOD_LGOT     // ��� �죮�� �� ���;;
  m1PENSIONER := kart_->PENSIONER    // ���� ���ᨮ��஬?;0-���, 1-��;
  m1INVALID   := kart_->INVALID      // ������������;0-���,1,2,3-��㯯�, 4-���-��������;
  mINVALID_ST := kart_->INVALID_ST   // �⥯��� �����������;1 ��� 2;
  mBLOOD_G    := kart_->BLOOD_G      // ��㯯� �஢�;�� 1 �� 4;
  mBLOOD_R    := kart_->BLOOD_R      // १��-䠪��;"+" ��� "-";
  mWEIGHT     := kart_->WEIGHT       // ��� � ��;;
  mHEIGHT     := kart_->HEIGHT       // ��� � �;;
  m1WHERE_KART:= kart_->WHERE_KART   // ��� ���㫠�ୠ� ����;0-� ॣ�������, 1-� ���, 2-�� �㪠�;
  m1okato     := kart_->KVARTAL_D    // ����� ��ꥪ� �� ����ਨ ���客����
  //
  arr := retFamImOt(1,.f.)
  mfam := padr(arr[1],40)
  mim  := padr(arr[2],40)
  mot  := padr(arr[3],40)
  //
  if between(m1invalid,1,4)
    R_Use(dir_server+"kart_inv",,"INV")
    index on str(kod,7) to (cur_dir+"tmp_inv")
    find (str(mkod,7))
    if (fl_invalid := found())
      MDATE_INV := inv->DATE_INV
      M1PRICH_INV := inv->PRICH_INV
      MPRICH_INV := inieditspr(A__MENUVERT, mm_prich_inv, M1PRICH_INV) 
      mDIAG_INV := inv->DIAG_INV
    endif
  endif 
  R_Use(dir_server+"k_prim1",dir_server+"k_prim1","K_PRIM1")
  find (str(mkod,7))
  do while k_prim1->kod == mkod .and. !eof()
    s_prim1 += rtrim(k_prim1->name) + eos
    skip
  enddo
  if alltrim(msmo) == '34'
    mnameismo := ret_inogSMO_name(1,@rec_inogSMO,.t.)
  elseif left(msmo,2) == '34'
    // ������ࠤ᪠� �������
  elseif !empty(msmo)
    m1ismo := msmo ; msmo := '34'
  endif
  R_Use(dir_server+"mo_kinos",dir_server+"mo_kinos","KIS")
  find (str(mkod,7))
  if found()
    fl_kis := .t.
    m1osn_preb  := kis->osn_preb   // �᭮����� �ॡ뢠��� � ��
    MADRES_PRO  := kis->ADRES_PRO  // ���� �஦������ � ����.���.
    MMIGR_KARTA := kis->MIGR_KARTA // ����� ����樮���� �����
    MDATE_P_G   := kis->DATE_P_G   // ��� ����祭�� �࠭���
    MDATE_R_M   := kis->DATE_R_M   // ��� ॣ����樨 � ����樮���� �㦡�
  endif
  R_Use(dir_server+"mo_kpred",dir_server+"mo_kpred","KPR")
  find (str(mkod,7))
  do while mkod == kpr->kod .and. !eof()
    if kpr->nn == 1
      ++mkol_pred
      m1is_uhod_pr1 := kpr->is_uhod
      m1is_food_pr1 := kpr->is_food
      mFIO_PR1 := kpr->fio
      mDATE_R_PR1 := kpr->DATE_R
      m1status_PR1 := kpr->STATUS
      mADRES_PR1 := kpr->ADRES
      mMR_DOL_PR1 := kpr->MR_DOL
      mphone_PR1 := kpr->PHONE
      mpasport_PR1 := kpr->PASPORT
      mpolis_PR1 := kpr->POLIS
    elseif kpr->nn == 2
      ++mkol_pred
      mFIO_PR2 := kpr->fio
      mDATE_R_PR2 := kpr->DATE_R
      m1status_pr2 := kpr->STATUS
      mADRES_PR2 := kpr->ADRES
      mMR_DOL_PR2 := kpr->MR_DOL
      mphone_PR2 := kpr->PHONE
      mpasport_PR2 := kpr->PASPORT
      mpolis_PR2 := kpr->POLIS
    endif
    skip
  enddo
endif
close databases
fv_date_r()
mkart_error := inieditspr(A__MENUVERT, mm_kart_error, m1kart_error)
mwhere_kart := inieditspr(A__MENUVERT, mm_where_kart, m1where_kart)
mokato := inieditspr(A__MENUVERT, glob_array_srf, m1okato)
mismo := init_ismo(m1ismo)
mvidpolis := inieditspr(A__MENUVERT, mm_vid_polis, m1vidpolis)
mgorod_selo := inieditspr(A__MENUVERT, mm_gorod_selo, m1gorod_selo)
m1gragd := iif(empty(mSTRANA := ini_strana(m1strana)), 1, 0)
mgragd := inieditspr(A__MENUVERT, mm_danet, m1gragd)
manonim := inieditspr(A__MENUVERT, mm_danet, m1anonim)
mPENSIONER := inieditspr(A__MENUVERT, mm_danet, m1PENSIONER)
mvid_ud  := inieditspr(A__MENUVERT, menu_vidud, m1vid_ud)
MKEMVYD := inieditspr(A__POPUPMENU, dir_server+"s_kemvyd", M1KEMVYD)
mvzros_reb := inieditspr(A__MENUVERT, menu_vzros, m1vzros_reb)
mrab_nerab := inieditspr(A__MENUVERT, menu_rab, m1rab_nerab)
mkategor   := inieditspr(A__MENUVERT, stm_kategor, m1kategor)
mkategor2  := inieditspr(A__MENUVERT, stm_kategor2, m1kategor2)
mKOD_LGOT  := inieditspr(A__MENUVERT, glob_katl, m1KOD_LGOT)
mkomu      := inieditspr(A__MENUVERT, mm_komu, m1komu)
minvalid   := inieditspr(A__MENUVERT, mm_invalid, m1invalid)
mosn_preb  := inieditspr(A__MENUVERT, menu_osn_preb_RF, m1osn_preb)
madres_reg := ini_adres(1)
madres_pre := ini_adres(2)
if empty(m1namesmo := int(val(msmo)))
  m1namesmo := glob_arr_smo[1,2] // �� 㬮�砭�� = ����⠫� �������
endif
mnamesmo := inieditspr(A__MENUVERT,glob_arr_smo,m1namesmo)
if m1namesmo == 34
  if !empty(mismo)
    mnamesmo := padr(mismo,41)
  elseif !empty(mnameismo)
    mnamesmo := padr(mnameismo,41)
  endif
endif
f_valid_komu(,-1)
//my_debug(,lstr(m1company)+" "+mcompany)
if eq_any(m1komu,1,3)
  m1company := m1str_crb
endif
//my_debug(,lstr(m1company)+" "+mcompany)
mcompany := inieditspr(A__MENUVERT, mm_company, m1company)
//my_debug(,lstr(m1company)+" "+mcompany)
chm_help_code := 3001
// ������ ���-�� ��ப
if eq_any(glob_task,X_PLATN,X_KASSA) .and. mem_anonim == 1
  ++count_row // ������
endif
if !is_append .and. tip_polzovat == 0 .and. mem_kart_error == 1
  ++count_row
endif
if glob_task != X_PPOKOJ .and. (is_uchastok > 0 .or. !empty(mmo_pr)) .and. !is_smp
  ++count_row
endif
count_row += 2 // �.�.�.
++count_row // ��� ஦�����
++count_row // ����⮢�७�� ��筮��: ���, ��� � �����
if !is_smp
  ++count_row // ���� ஦�����
endif
if eq_any(glob_task,X_REGIST,X_PLATN,X_ORTO,X_KASSA,X_PPOKOJ,X_MO)
  ++count_row // ��� � ����� �뤠��
endif
++count_row // ���� ॣ����樨
if !is_smp
  ++count_row // ���� �ॡ뢠���
endif
++count_row // ����� ���: ���
++count_row // ���
if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ,X_PLATN,X_ORTO)
  ++count_row // �ਭ���������� ����
endif
flag_DVN := (type("oms_sluch_DVN") == "L" .and. oms_sluch_DVN)
if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ,X_MO) .or. flag_DVN
  if is_talon .or. flag_DVN
    ++count_row // ��⥣��� �� ���.⠫���
  endif
  if !empty(stm_kategor2)
    ++count_row // ��⥣��� ��
  endif
  ++count_row // ������騩?
endif
if eq_any(glob_task,X_REGIST,X_PLATN,X_ORTO,X_KASSA,X_PPOKOJ,X_MO)
  ++count_row // ���� ࠡ���, ���������
endif
++count_row // ⥫�䮭�
if !eq_any(glob_task,X_PLATN,X_ORTO,X_KASSA,X_MO)
  ++count_row // ������������
endif
if eq_any(glob_task,X_MO)
  ++count_row // �죮� �� ���
endif
++count_row // ��⥫�:��த/ᥫ� + �ࠦ����� ��?
if eq_any(glob_task,X_PPOKOJ)
  ++count_row // ��� � ���
endif
if (title_top := (_top_r == NIL))
  DEFAULT _bot_r TO maxrow()-1
  if (_top_r := _bot_r - count_row - 1) < 0
    _top_r := 0
  endif
else
  if (_bot_r := _top_r + count_row + 1) > maxrow()-1
    _bot_r := maxrow()-1
    _top_r := _bot_r - count_row - 1
  endif
endif
do while .t.
  setcolor(cDataCGet)
  ClrLines(_top_r,maxrow()-1)
  if title_top
    @ _top_r,0 say padc(iif(mkod==0,"���������� � ����⥪�","������஢���� ����⥪�"),80) color "B/B*"
  else
    @ _top_r,0 say padc("��������� ४����⮢ ��樥�� � ����⥪�",80) color "B/B*"
    @ _bot_r,0 say replicate(" ",80) color "B/B*"
  endif
  ix := _top_r
  if eq_any(glob_task,X_PLATN,X_KASSA) .and. mem_anonim == 1
    ++ix ; @ ix,50 say "������?" get manonim ;
          reader {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)}
    keyboard chr(K_TAB)
  endif
  if !is_append .and. tip_polzovat == 0 .and. mem_kart_error == 1
    ++ix ; @ ix,50 say "�����" get mkart_error ;
          reader {|x|menu_reader(x,mm_kart_error,A__MENUVERT,,,.f.)}
    keyboard chr(K_TAB)
  elseif m1kart_error < 0
    n_message({"��������!",;
               "��� ����窨 ��樥�� ��⠭����� �����",;
               '" '+upper(mkart_error)+' "'},,"GR+/R","W+/R",ix+2,,"G+/R")
  endif
  if glob_task != X_PPOKOJ .and. (is_uchastok > 0 .or. !empty(mmo_pr)) .and. !is_smp
    ++ix ; c := 1
    if is_uchastok > 0
      @ ix,c say "���" get mbukva pict "@!"
      @ ix,col()+3 say "���⮪" get muchast pict "99" ;
                      valid {|g| e_k_uchast(g) }
      if is_uchastok == 1
        @ ix,col()+3 say "��� � ���⪥" get mkod_vu pict "99999" ;
                        when e_k_kod_vu()
      elseif is_uchastok == 3
        @ ix,col()+3 say "����� �� ���" get mkod_AK pict "999999"
      endif
      c := col()+3
    endif
    if !empty(mmo_pr)
      @ ix,c say mmo_pr color color8
    endif
  endif
  ++ix ; @ ix,1 say "�������" get mfam pict "@S33" ;
                valid {|g| lastkey()==K_UP .or. m1anonim==1 .or. valFamImOt(1,mfam) }
    @ row(),col()+1 say "���" get mim pict "@S32" ;
                valid {|g| m1anonim==1 .or. valFamImOt(2,mim) }
  ++ix ; @ ix,1 say "����⢮" get mot ;
                valid {|g| m1anonim==1 .or. valFamImOt(3,mot) }
  if mem_pol == 1
    @ row(),70 say "���" get mpol ;
            reader {|x|menu_reader(x,menupol,A__MENUVERT,,,.f.)}
  else
    @ row(),70 say "���" get mpol pict "@!" valid {|g| mpol $ "��" }
  endif
  ++ix ; @ ix,1 say "��� ஦�����" get mdate_r ;
         valid {|g| iif(mdate_r==g:original, .t., fv_date_r()), findKartoteka(1,@mkod) }
  @ row(),30 say "==>" get mvzros_reb when .f. color cDataCSay
  @ row(),50 say "�����" get msnils pict picture_pf ;
         valid {|| val_snils(msnils,1), findKartoteka(3,@mkod) } 
  ++ix ; @ ix,1 say "��-�� ��筮��:" get mvid_ud ;
         reader {|x|menu_reader(x,menu_vidud,A__MENUVERT,,,.f.)}
         @ ix,42 say "����" get mser_ud pict "@!" valid val_ud_ser(1,m1vid_ud,mser_ud)
         @ ix,col()+1 say "�" get mnom_ud pict "@!S18" valid val_ud_nom(1,m1vid_ud,mnom_ud)
  if !is_smp
    ++ix ; @ ix,2 say "���� ஦�����" get mmesto_r pict "@S62"
  endif
  if eq_any(glob_task,X_REGIST,X_PLATN,X_ORTO,X_KASSA,X_PPOKOJ,X_MO)
    ++ix ; @ ix,2 say "�뤠��" get mkogdavyd
           @ ix,col() say "," get mkemvyd ;
        reader {|x|menu_reader(x,{{|k,r,c|get_s_kemvyd(k,r,c)}},A__FUNCTION,,,.f.)}
  endif
  ++ix ; @ ix,1 say "���� ॣ����樨" get madres_reg ;
        reader {|x| menu_reader(x,{{|k,r,c| get_adres(1,k,r,c)}},A__FUNCTION,,,.f.)}
  if !is_smp
    ++ix ; @ ix,1 say "���� �ॡ뢠���" get madres_pre ;
          reader {|x| menu_reader(x,{{|k,r,c| get_adres(2,k,r,c)}},A__FUNCTION,,,.f.)}
  endif
  ++ix ; @ ix,1 say "����� ���: ���" get mspolis
       @ row(),col()+3 say "�����" get mnpolis valid {|| findKartoteka(2,@mkod) }
       @ row(),col()+3 say "���" get mvidpolis ;
                    reader {|x|menu_reader(x,mm_vid_polis,A__MENUVERT,,,.f.)} ;
                    valid func_valid_polis(m1vidpolis,mspolis,mnpolis)
  ++ix ; @ ix,1 say "���" get mnamesmo ;
                    reader {|x|menu_reader(x,glob_arr_smo,A__MENUVERT,,,.f.)} ;
                    valid {|g| func_valid_ismo(g,0,41,"namesmo") }
       @ row(),47 say "����� �" get mbeg_polis
       @ row(),col()+1 say "��" get msrok_polis
  if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ,X_PLATN,X_ORTO)
    ++ix ; @ ix,1 SAY "�ਭ���������� ���" GET mkomu ;
               reader {|x|menu_reader(x,mm_komu,A__MENUVERT,,,.f.)} ;
               valid {|g,o| f_valid_komu(g,o) }
         @ row(),col()+1 say "==>" get mcompany ;
             reader {|x|menu_reader(x,mm_company,A__MENUVERT,,,.f.)} ;
             when eq_any(m1komu,1,3)
  endif
  if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ,X_MO) .or. flag_DVN
    if is_talon .or. flag_DVN
      ++ix ; @ ix,1 say "��� ��⥣�ਨ �죮��"
      c := col()+1
      if .t.//mem_st_kat == 1
        @ ix,c get mkategor ;
                   reader {|x|menu_reader(x,mo_cut_menu(stm_kategor),A__MENUVERT,,,.f.)}
        c += 24
      else
        @ ix,c get m1kategor pict "99" ;
                   valid {|g| val_st_kat(g) }
        @ row(),col()+3 get mkategor color color14 when .f.
        c += 27
      endif
    endif
    if !empty(stm_kategor2)
      ++ix ; @ ix,c say "��⥣��� ��" get mkategor2 ;
                 reader {|x|menu_reader(x,stm_kategor2,A__MENUVERT,,,.f.)}
    endif
    ++ix ; @ ix,1 say "������騩?" get mrab_nerab ;
          reader {|x|menu_reader(x,menu_rab,A__MENUVERT,,,.f.)}
    @ row(),col()+5 say "���ᨮ���?" get mpensioner ;
       reader {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)}
  endif
  if eq_any(glob_task,X_REGIST,X_PLATN,X_ORTO,X_KASSA,X_PPOKOJ,X_MO)
    fl_mr_dol := .t.
    ++ix ; @ ix,1 say "���� ࠡ���, ���������" get mmr_dol
  endif
  ++ix ; @ ix,1 say "����䮭�: ����譨�" get mPHONE_H valid {|g| valid_phone_bay(g) }
       @ row(),col()+1 say ", �������" get mPHONE_M valid {|g| valid_phone_bay(g,.t.) }
       @ row(),col()+1 say   ", ࠡ�稩" get mPHONE_W valid {|g| valid_phone_bay(g) }
  if !eq_any(glob_task,X_PLATN,X_ORTO,X_KASSA) // ������������
    ++ix ; @ ix,1 SAY "������������" GET minvalid ;
                  reader {|x| menu_reader(x,mm_invalid,A__MENUVERT,,,.f.)} ;
                  valid {|| f_kart_valid_inv(ix) }
  endif
  if eq_any(glob_task,X_MO)
    ++ix ; @ ix,1 say "�죮� �� ���" get mKOD_LGOT ;
          reader {|x|menu_reader(x,glob_katl,A__MENUVERT,,,.f.)}
  endif
  ++ix ; @ ix,1 say "��⥫�:" GET mgorod_selo ;
               reader {|x| menu_reader(x,mm_gorod_selo,A__MENUVERT,,,.f.)}
         @ ix,col()+6 say "�ࠦ����� ��?" get mgragd ;
               reader {|x| menu_reader(x,mm_danet,A__MENUVERT,,,.f.)} ;
               valid {|| iif(m1gragd==1, .t., get_oksm(ix) ) }
         @ ix,col()+5 get mstrana when .f. color color14
  if eq_any(glob_task,X_PPOKOJ)
    ++ix ; @ ix,1 SAY "����" GET mHEIGHT pict "999"
         @ ix,col()+1 SAY "�,  ���" GET mWEIGHT pict "999"
         @ ix,col()+1 SAY "��"
         @ ix,col()+5 SAY "������⢮ �।�⠢�⥫��" GET mkol_pred pict "9" ;
               valid {|| between(mkol_pred,0,2) .and. f_kart_valid_pred(ix) }
  endif
  if pos_read > 0
    if lower(GetList[pos_read]:name) == "mgragd"
      --pos_read
    endif
    if lower(GetList[pos_read]:name) == "mgorod_selo"
      --pos_read
    endif
    if lower(GetList[pos_read]:name) == "minvalid"
      --pos_read
    endif
  endif
  status_key("^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����")
  set key K_F2 TO f_prim1
  if fl_mr_dol
    set key K_F4 TO v_vvod_mr
  endif
  count_edit := myread(,@pos_read,++k_read)
  if fl_mr_dol
    set key K_F4 TO
  endif
  set key K_F2 TO
  if p_edit_kartoteka // �� ���������� ��諨 � ����⥪� ⠪��� ��樥��
    exit 
  endif
  if lastkey() != K_ESC
    MFIO := rtrim(mfam)+" "+rtrim(mim)+" "+mot
    if empty(mfio)
      func_error(4,"�� ������� �.�.�. ��� �����!")
      loop
    endif
    if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ) .and. m1KOMU == 0
      if empty(mdate_r)
        func_error(4,'�� ��������� ��� ஦�����')
        loop
      endif
      if empty(mnpolis) .and. !_task_263_
        func_error(4,'�� �������� ����� �����')
        loop
      endif
      if !is_smp .and. eq_any(m1vid_ud,3,14) .and. ;
                       !empty(mser_ud) .and. empty(del_spec_symbol(mmesto_r))
        func_error(4,iif(m1vid_ud==3,'��� ᢨ�-�� � ஦�����','��� ��ᯮ�� ��')+;
                     ' ��易⥫쭮 ���������� ���� "���� ஦�����"')
        if !(glob_mo[_MO_KOD_TFOMS] == '126501')
          loop
        endif
      endif
    endif
    func_valid_polis(m1vidpolis,mspolis,mnpolis,between(m1namesmo,34001,34007))
    close databases
    if f_Esc_Enter(1)
      mywait()
      if m1anonim == 1
        newMEST_INOG := 8
      elseif TwoWordFamImOt(mfam) .or. TwoWordFamImOt(mim) .or. TwoWordFamImOt(mot)
        newMEST_INOG := 9
      endif
      if between(m1INVALID,1,4) .and. emptyany(MDATE_INV,MPRICH_INV)
        m1INVALID := 0
      endif
      fl_write_kartoteka := .t.
      st_rab_nerab := M1RAB_NERAB
      G_Use(dir_server+"k_prim1",dir_server+"k_prim1","K_PRIM1")
      Use_base("kartotek")
      if is_append  // ���������� � ����⥪�
        Add1Rec(7)
        glob_kartotek := mkod := kart->kod := recno()
      else
        find (str(mkod,7))
        if found()
          G_RLock(forever)
        else
          Add1Rec(7)
          glob_kartotek := mkod := kart->kod := recno()
        endif
      endif
      glob_k_fio := alltrim(mfio)
      //
      kart->FIO       := mFIO
      kart->pol       := mpol
      kart->DATE_R    := mdate_r
      kart->VZROS_REB := m1VZROS_REB
      kart->ADRES     := mADRES
      kart->MR_DOL    := mMR_DOL
      kart->POLIS     := make_polis(mspolis,mnpolis) // ��� � ����� ���客��� �����
      kart->srok_polis:= dtoc4(msrok_polis)
      kart->RAB_NERAB := m1RAB_NERAB
      kart->snils     := msnils
      kart->ZA_SMO    := m1kart_error
      if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ)
        kart->KOMU    := m1KOMU
        kart->STR_CRB := iif(m1komu==0, 0, m1company)
        kart->MI_GIT  := 9
      endif
      kart->MEST_INOG := newMEST_INOG
      if is_uchastok > 0
        kart->bukva  := mbukva
        kart->uchast := muchast
        kart->kod_vu := mkod_vu
      endif
      select KART2
      do while kart2->(lastrec()) < mkod
        APPEND BLANK
      enddo
      goto (mkod)
      G_RLock(forever)
      if is_append  // ���������� � ����⥪�
        kart2->kod_tf := 0
        kart2->kod_mis := ""
        kart2->kod_AK := ""
        kart2->MO_PR := ""
        kart2->TIP_PR := 0
        kart2->DATE_PR := ctod("")
        kart2->SNILS_VR := "" // ��.��� ��� �� �ਢ易�
        kart2->PC1 := kod_polzovat+c4sys_date+hour_min(seconds())
        kart2->PC2 := ""
        kart2->PC4 := ""
      endif
      if is_uchastok == 3
        kart2->kod_AK := mkod_AK
      endif
      select KART_
      do while kart_->(lastrec()) < mkod
        APPEND BLANK
      enddo
      goto (mkod)
      G_RLock(forever)
      kart_->VPOLIS := m1vidpolis
      kart_->SPOLIS := mSPOLIS
      kart_->NPOLIS := mNPOLIS
      kart_->SMO    := lstr(m1namesmo)
      kart_->beg_polis := dtoc4(mbeg_polis)
      kart_->strana    := iif(m1gragd == 0, m1strana, "")
      kart_->gorod_selo := m1gorod_selo
      kart_->vid_ud   := m1vid_ud
      kart_->ser_ud   := mser_ud
      kart_->nom_ud   := mnom_ud
      kart_->kemvyd   := m1kemvyd
      kart_->kogdavyd := mkogdavyd
      kart_->kategor  := m1kategor
      kart_->kategor2 := m1kategor2
      kart_->mesto_r  := mmesto_r
      kart_->okatog   := mokatog
      kart_->okatop   := mokatop
      kart_->adresp   := madresp
      kart_->PHONE_H  := mPHONE_H
      kart_->PHONE_M  := mPHONE_M
      kart_->PHONE_W  := mPHONE_W
      kart_->KOD_LGOT := m1KOD_LGOT
      kart_->PENSIONER:= m1PENSIONER
      kart_->INVALID  := m1INVALID
      //kart_->INVALID_ST := mINVALID_ST
      kart_->BLOOD_G  := mBLOOD_G
      kart_->BLOOD_R  := mBLOOD_R
      kart_->WEIGHT   := mWEIGHT
      kart_->HEIGHT   := mHEIGHT
      kart_->WHERE_KART := m1WHERE_KART
      Private fl_nameismo := .f.
      if m1namesmo == 34
        kart_->KVARTAL_D := m1okato // ����� ��ꥪ� �� ����ਨ ���客����
        if empty(m1ismo)
          if !empty(mnameismo)
            fl_nameismo := .t.
          endif
        else
          kart_->SMO := m1ismo  // �����塞 "34" �� ��� �����த��� ���
        endif
      endif
      if m1MEST_INOG == 9 .or. newMEST_INOG == 9
        G_Use(dir_server+"mo_kfio",,"KFIO")
        index on str(kod,7) to (cur_dir+"tmp_kfio")
        find (str(mkod,7))
        if found()
          if newMEST_INOG == 9
            G_RLock(forever)
            kfio->FAM := mFAM
            kfio->IM  := mIM
            kfio->OT  := mOT
          else
            DeleteRec(.t.)
          endif
        else
          if newMEST_INOG == 9
            AddRec(7)
            kfio->kod := mkod
            kfio->FAM := mFAM
            kfio->IM  := mIM
            kfio->OT  := mOT
          endif
        endif
      endif
      if between(m1invalid,1,4) .or. fl_invalid
        G_Use(dir_server+"kart_inv",,"INV")
        index on str(kod,7) to (cur_dir+"tmp_inv")
        find (str(mkod,7))
        if found()
          if m1invalid == 0
            DeleteRec(.t.)
          else
            G_RLock(forever)
            inv->DATE_INV := MDATE_INV
            inv->PRICH_INV := M1PRICH_INV
            inv->DIAG_INV := mDIAG_INV
          endif
        else
          AddRec(7)
          inv->kod := mkod
          inv->DATE_INV := MDATE_INV
          inv->PRICH_INV := M1PRICH_INV
          inv->DIAG_INV := mDIAG_INV
        endif
      endif 
      if fl_nameismo .or. rec_inogSMO > 0
        G_Use(dir_server+"mo_kismo",,"SN")
        index on str(kod,7) to (cur_dir+"tmp_ismo")
        find (str(mkod,7))
        if found()
          if fl_nameismo
            G_RLock(forever)
            sn->smo_name := mnameismo
          else
            DeleteRec(.t.)
          endif
        else
          if fl_nameismo
            AddRec(7)
            sn->kod := mkod
            sn->smo_name := mnameismo
          endif
        endif
      endif
      //
      select K_PRIM1
      do while .t.
        find (str(glob_kartotek,7))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      if !empty(s_prim1)
        for i := 1 to mlcount(s_prim1,100)
          AddRec(7)
          k_prim1->kod := glob_kartotek
          k_prim1->stroke := if(i < 10, i, 9)
          k_prim1->name := rtrim(memoline(s_prim1,100,i))
        next
      endif
      if mkol_pred > 1
        if empty(mFIO_PR2)
          mkol_pred := 1
        endif
      endif
      if mkol_pred > 0
        if empty(mFIO_PR1)
          mkol_pred := 0
        endif
      endif
      G_Use(dir_server+"mo_kpred",dir_server+"mo_kpred","KPR")
      fl := .f.
      find (str(mkod,7)+"1")
      if found()
        if mkol_pred > 0
          G_RLock(forever)
          fl := .t.
        else
          DeleteRec(.t.)
        endif
      elseif mkol_pred > 0
        AddRec(7)
        kpr->kod := mkod
        kpr->nn := 1
        fl := .t.
      endif
      if fl
        kpr->is_uhod := m1is_uhod_pr1
        kpr->is_food := m1is_food_pr1
        kpr->fio     := mFIO_PR1
        kpr->DATE_R  := mDATE_R_PR1
        kpr->STATUS  := m1status_PR1
        kpr->ADRES   := mADRES_PR1
        kpr->MR_DOL  := mMR_DOL_PR1
        kpr->PHONE   := mphone_PR1
        kpr->PASPORT := mpasport_PR1
        kpr->POLIS   := mpolis_PR1
      endif
      fl := .f.
      find (str(mkod,7)+"2")
      if found()
        if mkol_pred > 1
          G_RLock(forever)
          fl := .t.
        else
          DeleteRec(.t.)
        endif
      elseif mkol_pred > 1
        AddRec(7)
        kpr->kod := mkod
        kpr->nn := 2
        fl := .t.
      endif
      if fl
        kpr->fio     := mFIO_PR2
        kpr->DATE_R  := mDATE_R_PR2
        kpr->STATUS  := m1status_PR2
        kpr->ADRES   := mADRES_PR2
        kpr->MR_DOL  := mMR_DOL_PR2
        kpr->PHONE   := mphone_PR2
        kpr->PASPORT := mpasport_PR2
        kpr->POLIS   := mpolis_PR2
      endif
      if fl_kis .or. m1gragd == 0
        G_Use(dir_server+"mo_kinos",dir_server+"mo_kinos","KIS")
        find (str(glob_kartotek,7))
        if found()
          if m1gragd == 0
            G_RLock(forever)
          else
            DeleteRec(.t.) // �.�. �ࠦ����� ��
          endif
        else
          if m1gragd == 0
            AddRec(7)
            kis->kod := glob_kartotek
          endif
        endif
        if m1gragd == 0
          kis->osn_PREB   := m1osn_preb
          kis->ADRES_PRO  := MADRES_PRO  // ���� �஦������ � ����.���.
          kis->MIGR_KARTA := MMIGR_KARTA // ����� ����樮���� �����
          kis->DATE_P_G   := MDATE_P_G   // ��� ����祭�� �࠭���
          kis->DATE_R_M   := MDATE_R_M   // ��� ॣ����樨 � ����樮���� �㦡�
        endif
      endif
      close databases
      write_work_oper(glob_task,OPER_KART,iif(is_append,1,2),1,count_edit)
      // �᫨ ��室���� � ����� "���" � ।����㥬 ������ ��樥��
      if glob_task == X_OMS .and. !is_append
        arr := {}
        Use_base("human")
        set order to 2
        find (str(mkod,7))
        do while human->kod_k == mkod .and. !eof()
          if emptyall(human->schet,human_->reestr) .and. _Human_kod != human->kod
            aadd(arr,human->kod)
          endif
          skip
        enddo
        if (i := len(arr)) > 0
          keyboard ""
          if f_alert({'�� ��樥��� "'+alltrim(mfio)+'" �������',;
                      '���⮢ ����, �� ������� � ॥���: '+lstr(i)+'.',;
                      '��� �।�������� ��१������ ��।���஢����',;
                      '४������ ��樥�� � ����� ����� ����',;
                      '',;
                      '�롥�� ����⢨�:'},;
                     {" �⪠� "," ��१������ "},;
                     2,"GR+/R","W+/R",_top_r+1,,"GR+/R,N/BG") == 2
            R_Use(dir_server+"kartote_",,"KART_")
            goto (mkod)
            R_Use(dir_server+"kartotek",,"KART")
            goto (mkod)
            mfio        := kart->fio
            mpol        := kart->pol
            mdate_r     := kart->date_r
            mADRES      := kart->ADRES
            mMR_DOL     := kart->MR_DOL
            m1RAB_NERAB := kart->RAB_NERAB
            mPOLIS      := kart->POLIS
            m1VIDPOLIS  := kart_->VPOLIS
            mSPOLIS     := kart_->SPOLIS
            mNPOLIS     := kart_->NPOLIS
            m1komu      := kart->komu
            msmo        := kart_->SMO
            m1okato     := kart_->KVARTAL_D    // ����� ��ꥪ� �� ����ਨ ���客����
            G_Use(dir_server+"mo_hismo",,"SN")
            index on str(kod,7) to (cur_dir+"tmp_ismo")
            select HUMAN
            set order to 0
            for i := 1 to len(arr)
              select HUMAN
              goto (arr[i])
              G_RLock(forever)
              select HUMAN_
              do while human_->(lastrec()) < arr[i]
                APPEND BLANK
              enddo
              goto (arr[i])
              G_RLock(forever)
              M1NOVOR := human_->NOVOR
              fv_date_r(human->N_DATA)
              //
              human->FIO       := MFIO          // �.�.�. ���쭮��
              human->POL       := MPOL          // ���
              human->DATE_R    := MDATE_R       // ��� ஦����� ���쭮��
              human->VZROS_REB := M1VZROS_REB   // 0-�����, 1-ॡ����, 2-�����⮪
              human->ADRES     := MADRES        // ���� ���쭮��
              human->MR_DOL    := MMR_DOL       // ���� ࠡ��� ��� ��稭� ���ࠡ�⭮��
              human->RAB_NERAB := M1RAB_NERAB   // 0-ࠡ���騩, 1-��ࠡ���騩
              human->KOMU      := M1KOMU        // �� 0 �� 5
              human_->SMO      := msmo
              human->POLIS     := mpolis
              human_->VPOLIS   := m1vidpolis
              human_->SPOLIS   := ltrim(mspolis)
              human_->NPOLIS   := ltrim(mnpolis)
              human_->OKATO    := m1okato // ����� ��ꥪ� �� ����ਨ ���客����
              select SN
              find (str(arr[i],7))
              if found()
                if fl_nameismo
                  G_RLock(forever)
                  sn->smo_name := mnameismo
                else
                  DeleteRec(.t.)
                endif
              else
                if fl_nameismo
                  AddRec(7)
                  sn->kod := arr[i]
                  sn->smo_name := mnameismo
                endif
              endif
            next
            stat_msg("������ �����襭�!") ; mybell(2,OK)
          endif
        endif
      endif
    endif
    close databases
  endif
  exit
enddo
setcolor(tmp_color)
chm_help_code := tmp_help
restscreen(buf)
return mkod

***** 20.07.17 ���� �����������
Function f_kart_valid_inv(r)
Local c := 2, r1, r2, buf, tmp_help, tmp_list, tmp_color, tek_sost, tmp_keys, ;
      pic_diag := "@K@!", bg := {|o,k| get_MKB10(o,k,.t.) }
if !between(m1invalid,1,4)
  return .t.
endif
Private gl_area := {1,3,maxrow()-1,76,0}
r2 := r-1
r1 := r2-6
buf := savescreen()
SAVE GETS TO tmp_list
tmp_keys := my_savekey()
change_attr()
box_shadow(r1,c,r2,77,,"���� ���ଠ樨 �� �����������","G+/B+")
@ r1+1,c+1 say "������������" get MINVALID WHEN .F. 
@ r1+2,c+1 say "��� ��ࢨ筮�� ��⠭������� �����������" get MDATE_INV ;
           valid {|| !empty(MDATE_INV) .and. mdate_r < MDATE_INV .and. MDATE_INV < sys_date }
@ r1+3,c+1 say "��稭� ��ࢨ筮�� ��⠭������� �����������"
@ r1+4,c+3 get MPRICH_INV reader {|x|menu_reader(x,mm_prich_inv,A__MENUVERT,,,.f.)} ;
           valid M1PRICH_INV > 0
@ r1+5,c+1 say '��� �᭮����� ����������� (�.4 ��."�")' get MDIAG_INV picture pic_diag ;
                reader {|o| MyGetReader(o,bg)} ;
                valid  val1_10diag(.t.,.f.,.f.,MDATE_INV,mpol)
status_key("^<PgDn>^ - ������ � ���室 � ������ ��樥��")
myread()
restscreen(buf)
my_restkey(tmp_keys)
setcolor(tmp_color)
RESTORE GETS FROM tmp_list
return .t.

* 26.11.18 �஢�ઠ �� �ࠢ��쭮��� � ��ࠢ����� ����� ⥫�䮭�
function valid_phone_bay( oGet, is_mobil )
	local fl := .t., s, s1

	&& private tmp := readvar()
	&& s := &tmp
	s := oGet:buffer
	if !empty( s )
		s := charrem( '-', s )
		s := charrem( ' ', s )
		s1 := CHARREPL( '0123456789', s, space( 10 ) )
		if !empty( s1 ) .or. !( left( s, 1 ) == '8' )
			DEFAULT is_mobil TO .f.
			if is_mobil
				fl := func_error( 4, '�ࠢ���� ����� �����쭮�� ⥫�䮭�: "8" + ��� 10 ���' )
			else
				fl := func_error( 4, '�ࠢ���� ����� ⥫�䮭�: "8"+"��� ��த�" + "����" (�ᥣ� 11 ���)' )
			endif
		endif
		if fl .and. len( s ) < 11
			fl := func_error( 4, '� ����� ⥫�䮭� ������ ���� 11 ������' )
		endif
		&& &tmp := padr( s, 11 )
		oGet:buffer := padr( s, 11 )
	endif
	return fl

***** 29.08.18 ���� ��樥�� � ����⥪� �� �६� ०��� ����������
Function findKartoteka(k,/*@*/lkod_k)
Local s, buf, rec := 0
if lkod_k > 0 ; return .t. ; endif
//
R_Use(dir_server+"kartotek",,"KART")
if k == 1 .and. !emptyany(mfam,mim,mdate_r)
  mfio := padr(upper(rtrim(mfam)+" "+rtrim(mim)+" "+mot),50)
  set index to (dir_server+"kartoten")
  find ("1"+mfio+dtos(mdate_r))
  if found()
    rec := recno()
  endif
elseif k == 2 .and. !empty(mnpolis) .and. p_find_polis > 0
  mpolis := make_polis(mspolis,mnpolis) // ��� � ����� ���客��� �����
  set index to (dir_server+"kartotep")
  find ("1"+padr(mpolis,17))
  if found()
    rec := recno()
  endif
elseif k == 3 .and. !empty(CHARREPL("0",msnils," "))
  set index to (dir_server+"kartotes")
  find ("1"+msnils)
  if found()
    rec := recno()
  endif
endif
if rec > 0
  R_Use(dir_server+"kartote2",,"KART2")
  goto (rec)
  R_Use(dir_server+"kartote_",,"KART_")
  goto (rec)
  buf := savescreen()
  kartotek_to_screen(11,18)
  @ 10,0 to 19,79 color "G+/B"
  str_center(10," � ����⥪� ������ ��樥�� "+iif(k==1,"",iif(k==2,"� ⠪�� ����ᮬ ","� ⠪�� ����� ")),"G+/RB")
  keyboard ""
  music_m("OK")
  Millisec(100)  // ����প� �� 0.1 �
  keyboard ""
  if f_alert({"����� �⮣� ��樥�� �� ����⥪� ��� �த������ ������� ������?"},;
             {" ���� ��樥�� "," ����� �� ����⥪� "},;
             2,"W+/N","N+/N",20,,"W+/N,N/BG" ) == 2
    lkod_k := rec
    mFIO        := kart->FIO
    mpol        := kart->pol
    mDATE_R     := kart->DATE_R
    m1VZROS_REB := kart->VZROS_REB
    mADRES      := kart->ADRES
    mMR_DOL     := kart->MR_DOL
    m1RAB_NERAB := kart->RAB_NERAB
    msnils      := kart->snils
    if kart->MI_GIT == 9
      m1KOMU    := kart->KOMU
      M1STR_CRB := kart->STR_CRB
    endif
    if kart->MEST_INOG == 9 // �.�. �⤥�쭮 ����ᥭ� �.�.�.
      m1MEST_INOG := kart->MEST_INOG
    endif
    m1vidpolis  := kart_->VPOLIS // ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����
    mspolis     := kart_->SPOLIS // ��� �����
    mnpolis     := kart_->NPOLIS // ����� �����
    msmo        := kart_->SMO    // ॥��஢� ����� ���
    m1vid_ud    := kart_->vid_ud   // ��� 㤮�⮢�७�� ��筮��
    mser_ud     := kart_->ser_ud   // ��� 㤮�⮢�७�� ��筮��
    mnom_ud     := kart_->nom_ud   // ����� 㤮�⮢�७�� ��筮��
    mokatog     := kart_->okatog       // ��� ���� ��⥫��⢠ �� �����
    mmesto_r    := kart_->mesto_r      // ���� ஦�����
    m1okato     := kart_->KVARTAL_D    // ����� ��ꥪ� �� ����ਨ ���客����
    //
    arr := retFamImOt(1,.f.)
    mfam := padr(arr[1],40)
    mim  := padr(arr[2],40)
    mot  := padr(arr[3],40)
    if alltrim(msmo) == '34'
      mnameismo := ret_inogSMO_name(1,@rec_inogSMO,.t.)
    elseif left(msmo,2) == '34'
      // ������ࠤ᪠� �������
    elseif !empty(msmo)
      m1ismo := msmo ; msmo := '34'
    endif
    mvidpolis := inieditspr(A__MENUVERT, mm_vid_polis, m1vidpolis)
    mokato    := inieditspr(A__MENUVERT, glob_array_srf, m1okato)
    mkomu     := inieditspr(A__MENUVERT, mm_komu, m1komu)
    mismo     := init_ismo(m1ismo)
    mvid_ud   := padr(inieditspr(A__MENUVERT, menu_vidud, m1vid_ud),23)
    madres_reg := ini_adres(1)
    f_valid_komu(,-1)
    if m1komu == 0
      m1company := int(val(msmo))
    elseif eq_any(m1komu,1,3)
      m1company := m1str_crb
    endif
    mcompany := padr(inieditspr(A__MENUVERT, mm_company, m1company),38)
    if m1company == 34
      if !empty(mismo)
        mcompany := padr(mismo,38)
      elseif !empty(mnameismo)
        mcompany := padr(mnameismo,38)
      endif
    endif
  endif
  kart_->(dbCloseArea())
  kart2->(dbCloseArea())
endif
kart->(dbCloseArea())
restscreen(buf)
if rec > 0 .and. lkod_k == rec
  if type("p_edit_kartoteka") == "L"   
    p_edit_kartoteka := .t.
    ReadKill(.t.)
  else
    update_gets()
  endif
endif
return .t.

***** 11.09.18
Function get_oksm(r)
Local c := 7, r1, r2, buf, tmp_help, tmp_list, tmp_color, tmp_cursor, tek_sost, tmp_keys
if r < int(maxrow()/2)
  r1 := r+1
  r2 := r1+8
else
  r2 := r-1
  r1 := r2-8
endif
buf := savescreen()
//tmp_help := help_code
SAVE GETS TO tmp_list
//help_code := H_Inostr
tmp_color := setcolor(color0+",,,B/BG")
tmp_cursor := setcursor(0)
//tek_sost := CSETALL()
tmp_keys := my_savekey()
change_attr()
box_shadow(r1,c,r2,77,,"���� �������⥫��� ᢥ����� �� �����࠭��","GR+/BG")
setcursor()
@ r1+1,c+2 say "��࠭�" get mstrana ;  //reader {|x|menu_reader(x,glob_O001,A__MENUVERT,,,.f.)}
           reader {|x|menu_reader(x,{{|k,r,c|f1get_oksm(k,r,c)}},A__FUNCTION,,,.f.)}
@ r1+2,c+2 say "�᭮����� �ॡ뢠��� � ��" get mosn_preb ;  
           reader {|x|menu_reader(x,menu_osn_preb_RF,A__MENUVERT,,,.f.)}
@ r1+3,c+2 say "���� �஦������ � ������ࠤ᪮� ������"
@ r1+4,c+3 get MADRES_PRO
@ r1+5,c+2 say "����樮���� ����" get MMIGR_KARTA
@ r1+6,c+2 say "��� ����祭�� �࠭���" get MDATE_P_G
@ r1+7,c+2 say "��� ॣ����樨 � ����樮���� �㦡�" get MDATE_R_M
status_key("^<PgDn>^ - ������ � ���室 � ������ ��樥��")
myread()
restscreen(buf)
my_restkey(tmp_keys)
setcolor(tmp_color)
//help_code := tmp_help
RESTORE GETS FROM tmp_list
//CSETALL(tek_sost)
if tmp_cursor != 0
  setcursor()
endif
return .t.

***** 01.08.18
Function f1get_oksm(k,r,c)
Static skodN := ""
Static arr_sng := {;
  "895",;//"�������"
  "031",;//"�����������"
  "051",;//"�������"
  "112",;//"��������"
  "268",;//"������"
  "398",;//"���������"
  "417",;//"��������"
  "428",;//"������"
  "440",;//"�����"
  "498",;//"�������, ����������"
  "762",;//"�����������"
  "795",;//"���������"
  "860",;//"����������"
  "804",;//"�������"
  "233",;//"�������"
  "896" ;//"����� ������"
 }
Local ret, r1, r2, i, lcolor, tmp_select := select()
if (r1 := r+1) > int(maxrow()/2)
  r2 := r-1 ; r1 := 2
else
  r2 := maxrow()-2
endif
Private p_oksm, lsng := 1, pkodN := skodN
if valtype(k) == "C" .and. !empty(k)
  pkodN := k
  if ascan(arr_sng,k) == 0
    lsng := 0
  endif
endif
dbcreate(cur_dir+"tmp_oksm",{;
  {"kodN","C", 3,0},;
  {"kodA","C", 3,0},;
  {"sng", "N", 1,0},;
  {"name","C",60,0};
 })
use (cur_dir+"tmp_oksm") new alias RG
do while .t.
  zap
  if lsng == 0
    lcolor := color5
    for i := 1 to len(glob_O001)
      if !(glob_O001[i,2] == "643") // �� ������� �����
        append blank
        rg->kodN := glob_O001[i,2]
        rg->kodA := glob_O001[i,6]
        rg->name := glob_O001[i,1]
        if ascan(arr_sng,rg->kodN) > 0
          rg->sng := 1
        endif
      endif
    next
  else
    lcolor := "N/W*,GR+/R"
    for j := 1 to len(arr_sng)
      if (i := ascan(glob_O001,{|x| x[2] == arr_sng[j] })) > 0
        append blank
        rg->kodN := glob_O001[i,2]
        rg->kodA := glob_O001[i,6]
        rg->name := glob_O001[i,1]
        rg->sng := 1
      endif
    next
  endif
  index on name to (cur_dir+"tmp_oksm")
  go top
  if !empty(pkodN)
    Locate for kodN == pkodN
    if !found()
      go top
    endif
  endif
  p_oksm := 0
  if Alpha_Browse(r1,2,r2,77,"f2get_oksm",lcolor,,,,,,,"f3get_oksm")
    if p_oksm == 0
      skodN := rg->kodN
      ret := { rg->kodN, alltrim(rg->name) }
      exit
    endif
  elseif p_oksm == 0
    exit
  endif
enddo
rg->(dbCloseArea())
select (tmp_select)
return ret

*****
Function f2get_oksm(oBrow)
Local n := 60
oBrow:addColumn(TBColumnNew("���", {|| rg->kodN }) )
oBrow:addColumn(TBColumnNew("   ", {|| rg->kodA }) )
if lsng == 0
  oBrow:addColumn(TBColumnNew(center("������������ ��࠭�",n), {|| padr(rg->name,n) }) )
  status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮� ��࠭�;  ^<F3>^ - ��࠭� �������� ���㡥���")
else
  oBrow:addColumn(TBColumnNew(center("��࠭� �������� ���㡥���",n), {|| padr(rg->name,n) }) )
  status_key("^<Esc>^ - ��室;  ^<Enter>^ - �롮� ��࠭�;  ^<F3>^ - �� ��࠭�")
endif
return NIL

*****
Function f3get_oksm(nkey)
Local ret := -1
if nKey == K_F3
  ret := 1
  p_oksm := 1
  pkodN := rg->kodN
  lsng := iif(lsng == 0, 1, 0)
  if lsng == 1 .and. rg->sng != lsng
    pkodN := ""
  endif
endif
return ret

*

***** ���� �।�⠢�⥫��
Function f_kart_valid_pred(r)
Local c := 2, r1, r2, buf, tmp_help, tmp_list, tmp_color, h := 7,;
      tek_sost, tmp_keys
if mkol_pred == 0
  return .t.
endif
Private MIS_UHOD_PR1 := inieditspr(A__MENUVERT,mm_danet,M1IS_UHOD_PR1),;
        MIS_FOOD_PR1 := inieditspr(A__MENUVERT,mm_danet,M1IS_FOOD_PR1),;
        mstatus_PR1 := inieditspr(A__MENUVERT,menu_predst,m1status_PR1),;
        mstatus_pr2 := inieditspr(A__MENUVERT,menu_predst,m1status_pr2),;
        gl_area := {1,0,maxrow()-1,79,0}
if mkol_pred == 2
  h := 14
endif
++h
if r < int(maxrow()/2)
  r1 := r+1
  r2 := r1+h
else
  r2 := r-1
  r1 := r2-h
endif
if r1 < 0
  r1 := 0
  r2 := r1+h
endif
if r2 > maxrow()-2
  r2 := maxrow()-2
  r1 := r2-h
endif
buf := savescreen()
SAVE GETS TO tmp_list
tmp_keys := my_savekey()
change_attr()
box_shadow(r1,c,r2,77,,"���� ���ଠ樨 � �।�⠢�⥫��","G+/B+")
@ r1+1,c+1 say "�।�⠢�⥫�:"
@ r1+2,c+3 say "���" get MFIO_PR1
@ row(),col()+3 say "�.�." get MDATE_R_PR1
@ r1+3,c+3 say "�����" get MSTATUS_PR1 ;
         reader {|x|menu_reader(x,menu_predst,A__MENUVERT,,,.f.)}
@ row(),23 say "��ᯨ⠫���஢��?" get MIS_UHOD_PR1 ;
         reader {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)} ;
         valid {|| iif(M1IS_UHOD_PR1==0,(MIS_FOOD_PR1:="���",M1IS_FOOD_PR1:=0),nil),;
                   update_get("MIS_FOOD_PR1") }
@ row(),48 say "� ��⠭���?" get MIS_FOOD_PR1 ;
         reader {|x|menu_reader(x,mm_danet,A__MENUVERT,,,.f.)} ;
         when M1IS_UHOD_PR1==1
@ r1+4,c+3 say "����" get MADRES_PR1
@ r1+5,c+3 say "���� ࠡ���" get MMR_DOL_PR1
@ r1+6,c+3 say "���⠪�� ⥫�䮭" get MPHONE_PR1
@ r1+7,c+3 say "��ᯮ��" get MPASPORT_PR1
@ row(),col()+5 say "�����" get MPOLIS_PR1
if mkol_pred == 2
  r1 := r1+7
  @ r1+1,c+1 say "��ன �।�⠢�⥫�:"
  @ r1+2,c+3 say "���" get MFIO_PR2
  @ row(),col()+3 say "�.�." get MDATE_R_PR2
  @ r1+3,c+3 say "�����" get MSTATUS_PR2 ;
           reader {|x|menu_reader(x,menu_predst,A__MENUVERT,,,.f.)}
  @ r1+4,c+3 say "����" get MADRES_PR2
  @ r1+5,c+3 say "���� ࠡ���" get MMR_DOL_PR2
  @ r1+6,c+3 say "���⠪�� ⥫�䮭" get MPHONE_PR2
  @ r1+7,c+3 say "��ᯮ��" get MPASPORT_PR2
  @ row(),col()+5 say "�����" get MPOLIS_PR2
endif
status_key("^<PgDn>^ - ������ � ���室 � ������ ��樥��")
myread()
restscreen(buf)
my_restkey(tmp_keys)
setcolor(tmp_color)
RESTORE GETS FROM tmp_list
return .t.

* ����᪨� �㭪樨 ��� edit_kartotek()

******
Static Function e_k_uchast(get)
if is_uchastok == 1 .and. muchast != get:original
  mkod_vu := 0
  update_get("mkod_vu")
endif
return .t.

******
Static Function e_k_kod_vu()
Local t_kod_vu := 0, vr_kod_vu, buf := save_maxrow(), is_f := 0
if muchast > 0 .and. mkod_vu == 0 .and. ;
     R_Use(dir_server+"kartotek",dir_server+"kartoteu","KART")
  mywait("����! �ந�������� ���� ᢮������� ���� � ���⪥...")
  // �஢��塞 ���� �� ⠪�� ���⮪ � ����
  find (strzero(muchast,2))
  if !found()
    t_kod_vu := 1  // ���� ���⮪
  else
    go bottom // �᫨ ���⮪ ��᫥���� � ᯨ᪥
    if muchast == kart->uchast
      if kart->kod_vu < 99999 // ���� ����� �� ����ࠬ
        t_kod_vu := kart->kod_vu+1 ; is_f := 1
      else // ��諨 �� 99999
        is_f := 2
      endif
    endif
    if is_f == 0
      dbseek(strzero(muchast+1,2),.t.)
      if eof()
        go bottom
      else
        skip -1 // ��室�� �� �㦭� ��� ���⮪
      endif
      if muchast == kart->uchast
        if kart->kod_vu < 99999 // ���� ����� �� ����ࠬ
          t_kod_vu := kart->kod_vu+1 ; is_f := 1
        else // ��諨 �� 99999
          is_f := 2
        endif
      endif
    endif
    if is_f == 2
      vr_kod_vu := 0
      find (strzero(muchast,2))
      do while muchast == kart->uchast .and. !eof()
        if kart->kod_vu - vr_kod_vu > 1
          t_kod_vu := vr_kod_vu+1 ; exit
        endif
        vr_kod_vu := kart->kod_vu
        skip
      enddo
    endif
  endif
  kart->(dbCloseArea())
  rest_box(buf)
  if t_kod_vu > 0
    mkod_vu := t_kod_vu
    update_get("mkod_vu")
  endif
endif
return .t.

*****
Function f_prim1()
Static r1 := 14, c1 := 10, r2 := 22, c2 := 69
Local i, j, mas, tmp, s1, buf, tmp_color, tmp_help := chm_help_code, fl, ;
      tmp_keys, updt_prim1 := .f., bSaveHandler
buf := savescreen()
tmp_keys := my_savekey()
change_attr()
setkey(K_ESC, {|| __keyboard(CHR(23)) } )  // KS_CTRL_W
bSaveHandler := ERRORBLOCK( {|x| BREAK(x)} )
BEGIN SEQUENCE
  chm_help_code := 10 // H_MemoEdit
  tmp_color := setcolor("N/W")
  box_shadow(r1,c1,r2,c2,"W+/W","����� �ਬ�砭��","B/W")
  status_key("^<Esc>^ - ����砭�� ।���஢����;  ^<F1>^ - ������")
  SETCURSOR()
  if (s1 := memoedit(s_prim1,r1+1,c1+1,r2-1,c2-1,.t.,)) != s_prim1
    updt_prim1 := .t.
    tmp := strtran(s1,Hos,eos)
  endif
RECOVER USING error
  func_error(4,"�訡�� ����᪠ ����७���� ।����")
END
// ����⠭������� ��砫쭮� �ணࠬ�� ��ࠡ�⪨ �訡��
ERRORBLOCK(bSaveHandler)
if updt_prim1
  mas := {} ; fl := .f.
  for i := 1 to mlcount(tmp,100)
    aadd(mas, rtrim(memoline(s1,100,i)))
    if !fl
      fl := !empty(mas[i])
    endif
  next
  s_prim1 := ""
  if fl
    for i := 1 to len(mas)
      if !empty(mas[i])
        s_prim1 += mas[i]+eos
      endif
    next
  endif
endif
chm_help_code := tmp_help
setcolor(tmp_color)
setkey(K_ESC, NIL)
my_restkey(tmp_keys)
restscreen(buf)
return NIL

***** ������ ��࠭�
Function ini_strana(lstrana)
Static kod_RF := "643"
Local s := space(10), i
if !empty(lstrana) .and. lstrana != kod_RF ;
       .and. (i := ascan(glob_O001, {|x| x[2] == lstrana })) > 0
  s := glob_O001[i,1]
endif
return s

*****
Static Function val_st_kat1(get)
Local i, fl := .t.
if (i := ascan(stm_kategor, {|x| x[2] == m1kategor } )) > 0
  mkategor := padr(stm_kategor[i,1],38) ; update_get("mkategor")
else
  fl := func_error(4,"�������⨬� ��� ��⥣�ਨ")
  m1kategor := get:original
endif
return fl

*****
Function ini_adres(reg)
Local s := space(10)
if reg == 1
  if mo_nodigit(mokatog)
    mokatog := s
  endif
  if !emptyall(mokatog,madres)
    s := ret_okato_ulica(madres,mokatog)
  endif
else
  if mo_nodigit(mokatop)
    mokatop := s
  endif
  if emptyall(mokatop,madresp)
    s := "�� ��"
    m1adres_pre := 1
  else
    s := ret_okato_ulica(madresp,mokatop)
    m1adres_pre := 2
  endif
endif
return s

*****
Function get_adres(reg,k,r,c)
Local ret, ret1, oldk, s, mm_menu := {"�� ��","��㣮�"}
if reg == 1
  if (ret1 := get_okato_ulica(mokatog,r,c,{mokatog,madres_reg,madres})) != NIL
    mokatog := ret1[1] ; madres_reg := ret1[2] ; madres := ret1[3]
    ret := {1,madres_reg}
  endif
else
  if !emptyall(mokatop,madresp)
    mm_menu[2] := madres_pre
  endif
  if c+len(mm_menu[2])+3 > 77
    mm_menu[2] := left(mm_menu[2],77-3-c)
  endif
  oldk := k
  if (k := popup_prompt(r+1,c,oldk,mm_menu)) > 0
    if k == 1
      mokatop := space(11) ; madres_pre := mm_menu[1] ; madresp := space(50)
      ret := {1,madres_pre}
    else
      s := iif(oldk == 1, okato_umolch, mokatop)
      if (ret1 := get_okato_ulica(s,r,c,{s,madres_pre,madresp})) != NIL ;
                                             .and. !(ret1[2] == mm_menu[1])
        mokatop := ret1[1] ; madres_pre := ret1[2] ; madresp := ret1[3]
        ret := {2,madres_pre}
      endif
    endif
  endif
endif
return ret

*

*****
Function view_kart(regim,r1,r2)
Local buf := savescreen(), i, mkod := 0, k, ;
      fl := .f., mtitul, l_color, str_sem,;
      arr_blk, fl_schet := .f., n_func := ""
DEFAULT regim TO 0, r1 TO 2, r2 TO maxrow()-2
Private mr1 := r1, mr2 := r2, str_find := "1", muslovie := "kart->kod > 0",;
        p_regim := regim, mstr_crb, top_frm := 14, blk_open
arr_blk := {{|| FindFirst(str_find)},;
            {|| FindLast(str_find)},;
            {|n| SkipPointer(n, muslovie)},;
            str_find,muslovie;
           }
mywait()
if glob_task == X_REGIST // ॣ�������
  chm_help_code := 1//H_Input_fioR
  n_func := "fluorogr_lpu"
else
  chm_help_code := 1//H_Input_fio
endif
if regim == 3
  mr1 := r1 := 1 ; mr2 := r2 := 11 ; n_func := "f2_v_fio"
  chm_help_code := 1//H3_Input_fio
endif
if !(type("is_r_mu") == "L")
  Public is_r_mu := .f.
endif
if is_r_mu
  blk_open := {|_rec,_ret| dbCloseAll(),;
                  _ret := use_base("r_mushrt") .and. use_base("kartotek"),;
                  if(_ret, (dbSelectArea("kart"), ordSetFocus( 2 )), nil),;
                  if(_ret, dbSetRelation( "R_MUSHRT", ;
                      {|| upper(kart->fio)+dtos(kart->date_r)}, ;
                      "upper(kart->fio)+dtos(kart->date_r)" ), nil),;
                  if(_ret, dbGoto(_rec), nil),;
                  _ret ;
              }
else
  blk_open := {|_rec,_ret| dbCloseAll(),;
                           _ret := use_base("kartotek"),;
                           if(_ret, ordSetFocus( 2 ), nil),;
                           if(_ret, dbGoto(_rec), nil),;
                           _ret ;
              }
endif
if eval(blk_open,1)
  if regim == 3
    select KART
    @ 13,0 say padc("_��ᬮ�� ����⥪�_",80,"�") color "R/BG"
  endif
  if glob_kartotek > 0
    set order to 1
    find (STR(glob_kartotek,7))
    fl := found()
  endif
  set order to 2
  if !fl
    find (str_find)
    if !found()
      Use
      return func_error(4,"�� ������� �㦭�� ����ᥩ!")
    endif
  endif
  if Alpha_Browse(mr1,2,mr2,77,"f1_v_kart",color0,mtitul,col_tit_popup,,;
                  .t.,arr_blk,n_func,"f2_v_kart",,;
                  {'�','�','�',"N/BG,W+/N,B/BG,W+/B,R/BG,W+/R",,300} )
    if (glob_kartotek := kart->kod) == 0
      func_error(4,"�� ������� �㦭�� ����ᥩ!")
    else
      mkod := glob_kartotek
      glob_k_fio := alltrim(kart->fio)
      mstr_crb := kart->str_crb
      Private mbukva := " ", muchast := 0, mkod_vu := 0
      if is_uchastok > 0
        mbukva := kart->bukva
        muchast := kart->uchast
        mkod_vu := kart->kod_vu
      endif
      if empty(kart->snils) .and. is_r_mu .and. !r_mushrt->(eof())
        select KART
        G_RLock(forever)
        kart->snils := charrem("- ",r_mushrt->snils)
      endif
      close databases
      if regim == 1 .or. regim == 2 // ।���஢���� ��� 㤠�����
        str_sem := "������஢���� ����⥪� "+lstr(glob_kartotek)
        if !G_SLock(str_sem)
          func_error(4,"� ����� ������ � ����窮� �⮣� 祫����� ࠡ�⠥� ��㣮� ���짮��⥫�.")
        else
          if regim == 1  // ।���஢����
            k := edit_kartotek(glob_kartotek)
          else   // 㤠�����
            // �஢�ઠ �� �� human �� ������� 祫�����
            R_Use(dir_server+"human",dir_server+"humankk","HUMAN")
            find (str(glob_kartotek,7))
            fl := found()
            if !fl  // ����� ��㣨
              R_Use(dir_server+"hum_p",dir_server+"hum_pkk","HUM_P")
              find (str(glob_kartotek,7))
              fl := found()
            endif
            if !fl  // ��⮯����
              R_Use(dir_server+"hum_ort",dir_server+"hum_ortk","HUM_O")
              find (str(glob_kartotek,7))
              fl := found()
            endif
            if !fl  // �ਥ��� �����
              R_Use(dir_server+"mo_pp",dir_server+"mo_pp_r","HU_PP")
              find (str(glob_kartotek,7))
              fl := found()
            endif
            if !fl  // ����
              R_Use(dir_server+"kas_pl",dir_server+"kas_pl1","KASP")
              find (str(glob_kartotek,7))
              fl := found()
            endif
            if !fl  // ����
              R_Use(dir_server+"kas_ort",dir_server+"kas_ort1","KASO")
              find (str(glob_kartotek,7))
              fl := found()
            endif
            /*if !fl  // ᯨ᮪ ��樥�⮢ � ॥���� ����� ��ᯠ��ਧ�権
              R_Use(dir_server+"mo_r01k",,"R01K")
              Locate for kod_k == glob_kartotek
              fl := found()
            endif*/
            if !fl  // ���ࠢ����� �� ��ᯨ⠫�����
              R_Use(dir_server+"mo_nnapr",,"NAPR")
              Locate for kod_k == glob_kartotek
              fl := found()
            endif
            if !fl .and. file(dir_server+"vouncnaz"+sdbf) // �����
              R_Use(dir_server+"vouncnaz",,"NAZ")
              Locate for kod_k == glob_kartotek
              fl := found()
              if !fl
                R_Use(dir_server+"vouncrec",,"RCP")
                Locate for kod_k == glob_kartotek
                fl := found()
              endif
            endif
            close databases
            if fl
              func_error(4,"�� ������� ���쭮�� �믨ᠭ ���� ���. �������� ����饭�!")
            elseif f_Esc_Enter(2)
              mywait()
              if hb_fileExists(dir_server+"mo_dnab"+sntx)
                Use_base("mo_dnab")
                do while .t.
                  find (str(glob_kartotek,7))
                  if !found() ; exit ; endif
                  DeleteRec(.t.)
                enddo
              endif
              G_Use(dir_server+"mo_kinos",dir_server+"mo_kinos","KIS")
              do while .t.
                find (str(glob_kartotek,7))
                if !found() ; exit ; endif
                DeleteRec(.t.)
              enddo
              //
              G_Use(dir_server+"mo_kismo",,"SN")
              index on str(kod,7) to (cur_dir+"tmp_ismo")
              do while .t.
                find (str(glob_kartotek,7))
                if !found() ; exit ; endif
                DeleteRec(.t.)
              enddo
              // ������� ॣ���� �����客�����
              G_Use(dir_server+"kart_etk")
              index on str(kod_k,7) to (cur_dir+"tmp_kart_etk")
              do while .t.
                find (str(glob_kartotek,7))
                if !found() ; exit ; endif
                DeleteRec(.t.)
              enddo
              G_Use(dir_server+"k_prim1",dir_server+"k_prim1","K_PRIM1")
              do while .t.
                find (str(glob_kartotek,7))
                if !found() ; exit ; endif
                DeleteRec(.t.)
              enddo
              Use_base("kartotek")
              set order to 0
              select KART
              goto (glob_kartotek)
              // �.�. relation
              select KART2
              goto (glob_kartotek)
              if !eof()
                DeleteRec(.t.,.f.)  // ���⪠ ����� ��� ����⪨ �� 㤠�����
              endif
              select KART_
              goto (glob_kartotek)
              if !eof()
                DeleteRec(.t.,.f.)  // ���⪠ ����� ��� ����⪨ �� 㤠�����
              endif
              select KART
              goto (glob_kartotek)
              DeleteRec(.t.,.f.)  // ���⪠ ����� ��� ����⪨ �� 㤠�����
              close databases
              write_work_oper(glob_task,OPER_KART,3)
              glob_kartotek := 0
              stat_msg("�������� �����襭�!") ; mybell(2,OK)
            endif
          endif
          G_SUnLock(str_sem)
        endif
        keyboard chr(K_ENTER)
      endif
    endif
  endif
  close databases
endif
chm_help_code := -1
close databases
restscreen(buf)
return (mkod > 0)

***** 20.02.14
Function f1_v_kart(oBrow)
Local oColumn, blk := {|| {1,2} }, n := 43
if p_regim == 3
  blk := {|| if(recno()==dubl1_kart, {3,4}, ;
                             if(recno()==dubl2_kart, {5,6}, {1,2} ) ) }
elseif glob_mo[_MO_IS_UCH]
  blk := {|| iif(kart2->mo_pr==glob_MO[_MO_KOD_TFOMS], {1,2},;
                             iif(empty(kart2->mo_pr), {3,4}, {5,6})) }
endif
if mem_kodkrt == 2
  if is_uchastok == 1
    n -= 11
  elseif eq_any(is_uchastok,2,3)
    n -= 12
  else
    n -= 7
  endif
endif
oColumn := TBColumnNew(center("�������, ���, ����⢮",n),{|| left(kart->fio,n)})
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
if mem_kodkrt == 2
  if is_uchastok > 0
    oColumn := TBColumnNew(" ",{|| kart->bukva})
    oColumn:defColor := {3,3}
    oColumn:colorBlock := {|| {3,3} }
    oBrow:addColumn(oColumn)
    oColumn := TBColumnNew("��",{|| put_val(kart->uchast,2)})
    oColumn:defColor := {3,3}
    oColumn:colorBlock := {|| {3,3} }
    oBrow:addColumn(oColumn)
  endif
  if is_uchastok == 1
    oColumn := TBColumnNew(" ���",{|| put_val(kart->kod_vu,5) })
    oColumn:defColor := {3,3}
    oColumn:colorBlock := {|| {3,3} }
    oBrow:addColumn(oColumn)
  elseif is_uchastok == 2
    oColumn := TBColumnNew("  ���",{|| kart->kod })
    oColumn:defColor := {3,3}
    oColumn:colorBlock := {|| {3,3} }
    oBrow:addColumn(oColumn)
  elseif is_uchastok == 3
    oColumn := TBColumnNew("��� ��",{|| left(kart2->kod_AK,6) })
    oColumn:defColor := {3,3}
    oColumn:colorBlock := {|| {3,3} }
    oBrow:addColumn(oColumn)
  endif
endif
oColumn := TBColumnNew("��� ஦�.",{|| kart->date_r})
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("�����",17),{|| " "+kart->polis})
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
if p_regim == 1
  if is_task(X_REGIST) // �᫨ ���� ����� "����������"
    status_key("^<Esc>^ ��室; ^<Enter>^ ।���஢����; ^<F8>^ ����� �����; ^<F9>^ ����� ���� ���")
  else
    status_key("^^ ��� ���.�㪢� - ��ᬮ��;  ^<Esc>^ - ��室;  ^<Enter>^ - ।���஢����")
  endif
elseif p_regim == 2
  status_key("^^ ��� ���.�㪢� - ��ᬮ��;  ^<Esc>^ - ��室;  ^<Enter>^ - 㤠�����")
elseif p_regim == 3
  status_key("^^ ��� ���.�㪢� - ��ᬮ��; ^<Esc>^ - �⪠�; ^<Ins>^ - ���� ��७����� ���ଠ��")
endif
@ mr1,48 say " <F2> - ���� �� 蠡���� " color "W+/BG"
mark_keys({"<F2>"},"GR+/BG")
return NIL

***** 05.07.16
Function ret_last3_pos()
Local i, s, arr := {}, mes_arr := {}      
R_Use(dir_server+"mo_regi",dir_server+"mo_regi3","RU")
find (str(kart->kod,7))
if found()
  do while ru->kod_k == kart->kod .and. !eof()
    aadd(arr, {ru->pdate,ru->CTIME,ru->tip,ru->op})
    if len(arr) == 3 ; exit ; endif
    skip
  enddo
  if len(arr) == 1
    aadd(mes_arr, "��᫥���� ���饭��")
    aadd(mes_arr, date_month(c4tod(arr[1,1]),.t.))
    if arr[1,3] == 1
      aadd(mes_arr, "� �⤥�����:")
      aadd(mes_arr, alltrim(inieditspr(A__POPUPMENU,dir_server+"mo_otd",arr[1,4])))
    else
      aadd(mes_arr, "��祡�� �ਥ�:")
      aadd(mes_arr, alltrim(inieditspr(A__POPUPMENU,dir_server+"p_priem",arr[1,4])))
    endif
  elseif len(arr) > 1
    asort(arr,,,{|x,y| iif(x[1]==y[1], x[2] < y[2], x[1] < y[1]) })
    aadd(mes_arr, "��᫥���� ���饭��:")
    for i := 1 to len(arr)
      s := date_8(c4tod(arr[i,1]))+"�."
      if !empty(arr[i,2])
        s += " � "+arr[i,2]
      endif
      s += " ["
      if arr[i,3] == 1
        s += alltrim(inieditspr(A__POPUPMENU,dir_server+"mo_otd",arr[i,4]))
      else
        s += alltrim(inieditspr(A__POPUPMENU,dir_server+"p_priem",arr[i,4]))
      endif
      aadd(mes_arr, s+"]")
    next
  endif
endif
ru->(dbCloseArea())
select KART
return mes_arr 

***** 05.07.16
Function f2_v_kart(nkey,oBrow)
Static s_regim := 1, s_shablon := "", s_polis := "", s_snils := ""
Local buf := savescreen(), rec1 := recno(), fl := -1, fr := 13,;
      tmp := "", i, s, fl_number := .t., arr := {}, mes_arr := {}
if p_regim == 3 ; fr := 7 ; endif
Private tmp1
if p_regim == 1 .and. is_task(X_REGIST) // �᫨ ���� ����� "����������"
  begin_task_regist() // ������ mem-��६���� �� �����������
  select KART
  do case
    case nkey == K_F4
      r_list_uch(5,"f_f066")
    case nkey == K_F5
      pr_sh_F5()
    case nkey == K_F6
      if mem_6op == 0
        new_list_uch(4,"f_talon025")
      else
        if mem_posl_p == 1
          mes_arr := ret_last3_pos()
        endif
        if !empty(mes_arr)
          f_message(mes_arr,,cColorSt2Msg,cColorStMsg,0,0)
        endif
        if mem_6op == 1
          if input_uch(0,44,sys_date) != NIL .and. input_otd(0,44,sys_date) != NIL
            new_list_uch(4,"f_talon025")
          endif
        else
          if input_uch(0,44,sys_date) != NIL .and. ;
               (fr := popup_edit(dir_server+"p_priem",0,49,12,glob_priem[1],;
                   PE_RETURN,color5,,,,,,,"��ࢨ�� �ਥ��",col_tit_popup)) != NIL
            glob_priem := fr
            new_list_uch(4,"f_talon025")
          endif
        endif
      endif
      restscreen(buf)
    case nkey == K_F8
      if mem_t_025u == 0
        r_list_uch(0,"ind_karta")
      else
        new_list_uch(0,"f_f025u")
      endif
    case nkey == K_F9
      if mem_posl_p == 1
        mes_arr := ret_last3_pos()
      endif
      if !empty(mes_arr)
        f_message(mes_arr,,cColorSt2Msg,cColorStMsg,0,0)
      endif
      tmp := "list_uch"
      if is_r_mu .and. !r_mushrt->(eof())
        tmp += "(.t.)"
      endif
      if mem_op == 1
        if input_uch(0,44,sys_date) != NIL .and. input_otd(0,44,sys_date) != NIL
          r_list_uch(1,tmp)
        endif
      else
        if input_uch(0,44,sys_date) != NIL .and. ;
             (fr := popup_edit(dir_server+"p_priem",0,49,12,glob_priem[1],;
                 PE_RETURN,color5,,,,,,,"��ࢨ�� �ਥ��",col_tit_popup)) != NIL
          glob_priem := fr
          r_list_uch(2,tmp)
        endif
      endif
      restscreen(buf)
  endcase
  close databases
  eval(blk_open,rec1)
  select KART
elseif p_regim == 3 .and. nkey == K_INS
  if dubl1_kart == 0
    dubl1_kart := kart->kod
    status_key("^^ ��� ���.�㪢� - ��ᬮ��; ^<Esc>^ - �⪠�; ^<Ins>^ - �⬥��� 㤠�塞��� 祫�����")
    chm_help_code := 1//H4_Input_fio
  else
    if dubl1_kart == kart->kod
      func_error(4,"����� 祫���� 㦥 �⬥祭 ��� ��७�� � ���� �ᥩ ���ଠ樨 �� 㤠�塞���.")
    else
      dubl2_kart := kart->kod
      keyboard replicate(chr(K_LEFT)+chr(K_RIGHT),5)+chr(K_ENTER)
    endif
  endif
  return -1
endif
if nkey != K_F2
  return -1
endif
do while .t.
  do while .t.
    if s_regim == 1
      chm_help_code := 1//HK_shablon_fio
      tmp := padr(s_shablon,50)
      setcolor(color8)
      box_shadow(fr,14,fr+5,67)
      @ fr+2,15 say center(" ������ 蠡��� ��� ���᪠ 䠬����",52)
      @ fr+3,16 get tmp picture "@K@!"
      status_key("^<Esc>^ �⪠� �� �����;  ^<Enter>^ ���⢥ত���� �����;  ^<F10>^ ���� �� ������")
    elseif s_regim == 2
      chm_help_code := -1
      tmp := padr(s_polis,17)
      setcolor(color8)
      box_shadow(fr,14,fr+5,67)
      @ fr+2,15 say center("������ ����� ��� ���᪠ � ����⥪�",52)
      @ fr+3,32 get tmp picture "@K@!"
      status_key("^<Esc>^ �⪠� �� �����;  ^<Enter>^ ���⢥ত���� �����;  ^<F10>^ ���� �� �����")
    elseif s_regim == 3
      chm_help_code := -1
      tmp := padr(s_snils,11)
      tmp_color := setcolor(color14)
      box_shadow(fr,14,fr+5,67)
      @ fr+2,15 say center("������ ����� ��� ���᪠ � ����⥪�",52)
      @ fr+3,33 get tmp picture "@K"+picture_pf valid val_snils(tmp,1)
      status_key("^<Esc>^ �⪠� �� �����;  ^<Enter>^ ���⢥ত���� �����;  ^<F10>^ ���� �� �.�.�.")
    endif
    set key K_F10 TO clear_gets
    myread({"confirm"})
    setcolor(color0)
    set key K_F10 TO
    if lastkey() == K_F10
      s_regim := iif(++s_regim == 4, 1, s_regim)
    else
      if lastkey() == K_ESC .or. empty(tmp)
        tmp := NIL
      else
        if s_regim == 1
          s_shablon := alltrim(tmp)
        elseif s_regim == 2
          s_polis := tmp
        else
          s_snils := tmp
        endif
      endif
      exit
    endif
  enddo
  if tmp == NIL ; exit ; endif
  mywait()
  tmp := alltrim(tmp)
  if s_regim == 1
    if is_uchastok == 1
      tmp1 := tmp
      if !(left(tmp,1) $ "0123456789")
        tmp1 := substr(tmp1,2)  // ������ ����� �㪢�
      endif
      for i := 1 to len(tmp1)
        if !(substr(tmp1,i,1) $ "0123456789/")
          fl_number := .f. ; exit
        endif
      next
      if fl_number
        if (i := at("/",tmp1)) == 0
          fl_number := .f.
        else
          tmp1 := padl(alltrim(substr(tmp1,1,i-1)),2,"0") + ;
                  padl(alltrim(substr(tmp1,i+1)),4,"0")
        endif
      endif
    else
      for i := 1 to len(tmp)
        if !(substr(tmp,i,1) $ "0123456789")
          fl_number := .f. ; exit
        endif
      next
    endif
    if fl_number
      if is_uchastok == 1
        select KART
        set order to 4
        find (tmp1)
        if found()
          fl := 0 ; i := recno()
        endif
        set order to 2
        if fl == 0
          oBrow:gotop()
          goto (i)
          exit
        else
          func_error(4,"� ����⥪� ��� 祫����� � ����� "+tmp+".")
          restscreen(buf)
          loop
        endif
      else
        goto (int(val(tmp)))
        if !eof() .and. kart->kod > 0 .and. !deleted()
          oBrow:gotop()
          goto (int(val(tmp)))
          fl := 0 ; exit
        else
          func_error(4,"� ����⥪� ��� 祫����� � ����� "+tmp+".")
          restscreen(buf)
          loop
        endif
      endif
    else
      Private tmp_mas := {}, tmp_kod := {}, t_len, k1 := mr1+3, ;
              k2 := mr2-1, tmp2 := upper(tmp), ch := left(tmp,1)
      i := 0
      if !(ch == "*" .or. ch == "?")
        tmp1 := tmp2
        if "*" $ tmp1 ; tmp1 := beforatnum("*",tmp1,1) ; endif
        if "?" $ tmp1 ; tmp1 := beforatnum("?",tmp1,1) ; endif
        if len(tmp1) > 20 ; tmp1 := left(tmp1,20) ; endif
        ch := len(tmp1)
        find (str_find+tmp1)
        do while &(muslovie+" .and. tmp1 == left(upper(fio),ch) .and. !eof()")
          if like(tmp2,upper(fio))
            if ++i > 4000 ; exit ; endif
            aadd(tmp_mas,left(kart->fio,39)+" � "+date_8(kart->date_r)+;
                                            " � "+alltrim(kart->polis))
            aadd(tmp_kod,kart->kod)
          endif
          skip
        enddo
      else
        find (str_find)
        do while &(muslovie+" .and. !eof()")
          if like(tmp2,upper(fio))
            if ++i > 4000 ; exit ; endif
            aadd(tmp_mas,left(kart->fio,39)+" � "+date_8(kart->date_r)+;
                                            " � "+alltrim(kart->polis))
            aadd(tmp_kod,kart->kod)
          endif
          skip
        enddo
      endif
      if (t_len := len(tmp_kod)) = 0
        func_error(4,"�� ������� �� ����� �����, 㤮���⢮���饩 ������� 蠡����!")
        restscreen(buf)
        loop
      else
        box_shadow(mr1,2,mr2,77)
        SETCOLOR(col_tit_popup)
        @ k1-2,15 say "������: "+tmp2
        SETCOLOR(color0)
        if k1+t_len+2 < mr2-1
          k2 := k1 + t_len + 2
        endif
        @ k1,3 say center(" ������⢮ ��������� 䠬���� - "+lstr(t_len),74)
        i := ascan(tmp_kod, glob_perso)
        status_key("^<Esc>^ - �⪠� �� �롮�;  ^<Enter>^ - �롮�")
        if (i := popup(k1+1,3,k2,76,tmp_mas,i,color0)) > 0
          set order to 1
          find (STR(tmp_kod[i],7))
          set order to 2
          fl := 0
        endif
        exit
      endif
    endif
  elseif s_regim == 2 // ���� �� ������
    Private tmp_mas := {}, tmp_kod := {}, t_len, k1 := mr1+3, ;
            k2 := mr2-1, tmp2 := padr(upper(tmp),17)
    i := 0
    set order to 3
    find ("1"+tmp2)
    do while kart->polis == tmp2 .and. kart->kod > 0 .and. !eof()
      if ++i > 4000 ; exit ; endif
      aadd(tmp_mas,left(kart->fio,39)+" � "+date_8(kart->date_r)+;
                                      " � "+alltrim(kart->polis))
      aadd(tmp_kod,kart->kod)
      skip
    enddo
    set order to 2
    if (t_len := len(tmp_kod)) = 0
      func_error(4,"�� ������� �� ������ 祫����� � ����� ����ᮬ!")
      restscreen(buf)
      loop
    else
      box_shadow(mr1,2,mr2,77)
      SETCOLOR(col_tit_popup)
      @ k1-2,15 say "�����: "+tmp2
      SETCOLOR(color0)
      if k1+t_len+2 < mr2-1
        k2 := k1 + t_len + 2
      endif
      @ k1,3 say center(" ������⢮ ��������� 䠬���� - "+lstr(t_len),74)
      i := ascan(tmp_kod, glob_perso)
      status_key("^<Esc>^ - �⪠� �� �롮�;  ^<Enter>^ - �롮�")
      if (i := popup(k1+1,3,k2,76,tmp_mas,i,color0)) > 0
        set order to 1
        find (STR(tmp_kod[i],7))
        set order to 2
        fl := 0
      endif
      exit
    endif
  elseif s_regim == 3 // ���� �� �����
    Private tmp_mas := {}, tmp_kod := {}, t_len, k1 := mr1+3, ;
            k2 := mr2-1, tmp2 := tmp
    i := 0
    set order to 5
    find ("1"+tmp2)
    do while kart->snils == tmp2 .and. kart->kod > 0 .and. !eof()
      if ++i > 4000 ; exit ; endif
      aadd(tmp_mas,left(kart->fio,39)+" � "+date_8(kart->date_r)+;
                                      " � "+alltrim(kart->polis))
      aadd(tmp_kod,kart->kod)
      skip
    enddo
    set order to 2
    if (t_len := len(tmp_kod)) = 0
      func_error(4,"�� ������� �� ������ 祫����� � ����� �����!")
      restscreen(buf)
      loop
    else
      box_shadow(mr1,2,mr2,77)
      SETCOLOR(col_tit_popup)
      @ k1-2,15 say "�����: "+transform(tmp2,picture_pf)
      SETCOLOR(color0)
      if k1+t_len+2 < mr2-1
        k2 := k1 + t_len + 2
      endif
      @ k1,3 say center(" ������⢮ ��������� 䠬���� - "+lstr(t_len),74)
      i := ascan(tmp_kod, glob_perso)
      status_key("^<Esc>^ - �⪠� �� �롮�;  ^<Enter>^ - �롮�")
      if (i := popup(k1+1,3,k2,76,tmp_mas,i,color0)) > 0
        set order to 1
        find (STR(tmp_kod[i],7))
        set order to 2
        fl := 0
      endif
      exit
    endif
  endif
enddo
if fl == -1
  goto rec1
endif
restscreen(buf)
if glob_task == X_REGIST // ॣ�������
  chm_help_code := 1//H_Input_fioR
else
  chm_help_code := 1//H_Input_fio
endif
return fl

*****
Function dubl_zap(r,c)
Local mas_pmt := {"~���� �㡫�������� ����ᥩ",;
                  "~�������� �㡫�������� ����ᥩ"}
Local mas_msg := {"���� �㡫�������� ����ᥩ � ����⥪�",;
                  "�������� �㡫�������� ����ᥩ �� ����⥪�"}
&& Local mas_fun := {"f1dubl_zap()",;
Local mas_fun := {"viewDuplicateRecords()",;
                  "f2dubl_zap()"}
DEFAULT r TO T_ROW,c TO T_COL+5
popup_prompt(r,c,1,mas_pmt,mas_msg,mas_fun)
return NIL

***** 09.07.18
Function f1dubl_zap()
Static si := 1
Local hGauge, sh, HH := 77, name_file := "dubl_zap"+stxt, j1, ;
      fl := .t., sfio, old_fio, k := 0, rec1, curr := 0, buf,;
      mfio, mdate_r, mpolis, arr_title, reg_print := 4, ;
      arr := {" �� ~���+��� ஦�. "," �� ~������ "," �� ~����� "," �� ~��� "}
if (i := f_alert({'�롥��, ����� ��ࠧ�� �㤥� �����⢫����� ���� �㡫���⮢ ����ᥩ:',;
                  ""},;
                  arr,;
                  si,"N+/BG","R/BG",15,,col1menu )) == 0
  return NIL
endif
si := i
if !myFileDeleted(cur_dir+"tmp"+sdbf)
  return NIL
endif
if !myFileDeleted(cur_dir+"tmpitg"+sdbf)
  return NIL
endif
dbcreate(cur_dir+"tmpitg",{;
  {"ID","N",8,0},;
  {"fio","C",50,0},;
  {"DATE_R","D",8,0},;
  {"kod_kart","N",8,0},;
  {"kod_tf","N",10,0},;
  {"kod_mis","C",20,0},;
  {"adres","C",50,0},;
  {"fio","C",50,0},;
  {"pol","C",1,0},;
  {"polis","C",17,0},;
  {"uchast","N",2,0},;
  {"KOD_VU","N",5,0},; // ��� � ���⪥
  {"snils","C",17,0},;
  {"DATE_PR","D",8,0},;
  {"MO_PR","C",6,0};
})
use (cur_dir+"tmpitg") new
R_Use(dir_server+"kartote2",,"KART2")
//
status_key("^<Esc>^ - ��ࢠ�� ����")
hGauge := GaugeNew(,,,"���� �㡫�������� ����ᥩ",.t.)
GaugeDisplay( hGauge )
if i == 1
  arr_title := {"������������������������������������������������������������������",;
                " NN �                   �.�.�.                    � ��� �.����-��",;
                "������������������������������������������������������������������"}
  sh := len(arr_title[1])              
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  add_string("")
  add_string(center("���᮪ �㡫�������� ����ᥩ � ����⥪�",sh))
  add_string(center('(�ࠢ����� �� ���� "�.�.�." + "��� ஦�����")',sh))
  add_string("")
  aeval(arr_title, {|x| add_string(x) })
  dbcreate(cur_dir+"tmp",{{"fio","C",50,0},{"DATE_R","D",8,0}})
  use (cur_dir+"tmp") new
  index on upper(fio)+dtos(date_r) to (cur_dir+"tmp")
  R_Use(dir_server+"kartotek",dir_server+"kartoten","KART")
  set relation to recno() into KART2
  index on upper(fio)+dtos(date_r) to (cur_dir+"tmp_kart") for kod > 0
  go top
  do while !eof()
    GaugeUpdate( hGauge, ++curr/lastrec() )
    if inkey() == K_ESC
      add_string(replicate("*",sh))
      add_string(expand("����� �������"))
      stat_msg("���� ��ࢠ�!") ; mybell(1,OK)
      exit
    endif
    mfio := upper(kart->fio) ; mdate_r := kart->date_r
    rec1 := recno() ; j1 := 0
    find (mfio+dtos(mdate_r))
    do while upper(kart->fio) == mfio .and. kart->date_r == mdate_r .and. !eof()
      if kart->(recno()) != rec1
        j1++
      endif
      skip
    enddo
    goto (rec1)
    if j1 > 0
      select TMP
      find (mfio+dtos(mdate_r))
      if !found()
        append blank
        tmp->fio := mfio
        tmp->date_r := mdate_r
        if verify_FF(HH,.t.,sh)
          aeval(arr_title, {|x| add_string(x) } )
        endif
        ++k
        add_string(put_val(k,4)+". "+padr(mfio,44)+" "+date_8(mdate_r)+str(j1+1,5))
        select TMPITG
        append blank
        TMPITG->id       := k
        TMPITG->fio      := kart->fio
        TMPITG->DATE_R   := kart->date_r
        TMPITG->kod_kart := kart->kod
        TMPITG->adres    := kart->adres
        TMPITG->pol      := kart->pol
        TMPITG->polis    := kart->polis
        TMPITG->uchast   := kart->uchast
        TMPITG->kod_vu   := kart->kod_vu
        TMPITG->snils    := transform(kart->snils,picture_pf)
        TMPITG->DATE_PR  := kart2->date_pr
        TMPITG->MO_PR    := kart2->mo_pr
        TMPITG->kod_tf   := kart2->kod_tf
        TMPITG->kod_mis  := kart2->kod_mis
        if lastrec() % 1000 == 0
          commit
        endif
      endif
    endif
    @ maxrow(),1 say lstr(curr) color "W+/R"
    @ row(),col() say "/" color "W/R"
    @ row(),col() say lstr(k) color "G+/R"
    select KART
    skip
  enddo
elseif i == 2
  mpolis := space(17)
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  arr_title := {;
    "��������������������������������������������������������������������������������������������",;
    " NN �      �����      �� ���.�. �                      �.�.�.                      � ��� �.",;
    "��������������������������������������������������������������������������������������������"}
  sh := len(arr_title[1]) ; reg_print := 5
  add_string("")
  add_string(center("���᮪ �㡫�������� ����ᥩ � ����⥪�",sh))
  add_string(center('(�ࠢ����� �� ���� "�����")',sh))
  add_string("")
  aeval(arr_title, {|x| add_string(x) } )
  dbcreate(cur_dir+"tmp",{{"POLIS","C",17,0}})
  use (cur_dir+"tmp") new
  index on polis to (cur_dir+"tmp")
  R_Use(dir_server+"kartotek",dir_server+"kartotep","KART")
  set relation to recno() into KART2
  find ("1")
  do while !eof()
    GaugeUpdate( hGauge, ++curr/lastrec() )
    if inkey() == K_ESC
      add_string(replicate("*",sh))
      add_string(expand("����� �������"))
      stat_msg("���� ��ࢠ�!") ; mybell(1,OK)
      exit
    endif
    if kart->kod > 0 .and. !empty(CHARREPL("*-0",kart->polis,space(3)))
      mpolis := kart->polis ; mfio := kart->fio
      rec1 := recno() ; j1 := 0
      find ("1"+mpolis)
      do while kod > 0 .and. kart->polis == mpolis .and. !eof()
        if recno() != rec1
          j1++
        endif
        skip
      enddo
      goto (rec1)
      if j1 > 0
        select TMP
        find (mpolis)
        if !found()
          append blank
          tmp->polis := mpolis
          ++k ; j1 := 0
          select KART
          find ("1"+mpolis)
          do while kod > 0 .and. kart->polis == mpolis .and. !eof()
            if verify_FF(HH,.t.,sh)
              aeval(arr_title, {|x| add_string(x) } )
            endif
            ++j1
            s := iif(j1==1, padr(lstr(k)+".",5), space(5))
            add_string(s+mpolis+" "+padr(amb_kartaN(.t.),10)+;
                       padr(kart->fio,50)+" "+date_8(kart->date_r))
            select TMPITG
            append blank
            TMPITG->id       := k
            TMPITG->fio      := kart->fio
            TMPITG->DATE_R   := kart->date_r
            TMPITG->kod_kart := kart->kod
            TMPITG->adres    := kart->adres
            TMPITG->pol      := kart->pol
            TMPITG->polis    := kart->polis
            TMPITG->uchast   := kart->uchast
            TMPITG->kod_vu   := kart->kod_vu
            TMPITG->snils    := transform(kart->snils,picture_pf)
            TMPITG->DATE_PR  := kart2->date_pr
            TMPITG->MO_PR    := kart2->mo_pr
            TMPITG->kod_tf   := kart2->kod_tf
            TMPITG->kod_mis  := kart2->kod_mis
            if lastrec() % 1000 == 0
              commit
            endif
            select KART
            skip
          enddo
          goto (rec1)
        endif
        select KART
      endif
    endif
    @ maxrow(),1 say lstr(curr) color "W+/R"
    @ row(),col() say "/" color "W/R"
    @ row(),col() say lstr(k) color "G+/R"
    skip
  enddo
elseif i == 3
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  arr_title := {;
    "�����������������������������������������������������������������������������������������",;
    " NN �    �����     �� ���.�. �                      �.�.�.                      � ��� �.",;
    "�����������������������������������������������������������������������������������������"}
  sh := len(arr_title[1]) ; reg_print := 5
  add_string("")
  add_string(center("���᮪ �㡫�������� ����ᥩ � ����⥪�",sh))
  add_string(center('(�ࠢ����� �� ���� "�����")',sh))
  add_string("")
  aeval(arr_title, {|x| add_string(x) } )
  dbcreate(cur_dir+"tmp",{{"SNILS","C",11,0}})
  use (cur_dir+"tmp") new
  index on snils to (cur_dir+"tmp")
  R_Use(dir_server+"kartotek",dir_server+"kartotes","KART")
  set relation to recno() into KART2
  find ("1")
  do while !eof()
    GaugeUpdate( hGauge, ++curr/lastrec() )
    if inkey() == K_ESC
      add_string(replicate("*",sh))
      add_string(expand("����� �������"))
      stat_msg("���� ��ࢠ�!") ; mybell(1,OK)
      exit
    endif
    if kart->kod > 0 .and. !empty(CHARREPL("0",kart->snils," "))
      msnils := kart->snils ; mfio := kart->fio
      rec1 := recno() ; j1 := 0
      find ("1"+msnils)
      do while kod > 0 .and. kart->snils == msnils .and. !eof()
        if recno() != rec1
          j1++
        endif
        skip
      enddo
      goto (rec1)
      if j1 > 0
        select TMP
        find (msnils)
        if !found()
          append blank
          tmp->snils := msnils
          ++k ; j1 := 0
          select KART
          find ("1"+msnils)
          do while kod > 0 .and. kart->snils == msnils .and. !eof()
            if verify_FF(HH,.t.,sh)
              aeval(arr_title, {|x| add_string(x) } )
            endif
            ++j1
            s := iif(j1==1, padr(lstr(k)+".",5), space(5))
            add_string(s+transform(msnils,picture_pf)+" "+padr(amb_kartaN(.t.),10)+;
                       padr(kart->fio,50)+" "+date_8(kart->date_r))
            select TMPITG
            append blank
            TMPITG->id       := k
            TMPITG->fio      := kart->fio
            TMPITG->DATE_R   := kart->date_r
            TMPITG->kod_kart := kart->kod
            TMPITG->adres    := kart->adres
            TMPITG->pol      := kart->pol
            TMPITG->polis    := kart->polis
            TMPITG->uchast   := kart->uchast
            TMPITG->kod_vu   := kart->kod_vu
            TMPITG->snils    := transform(kart->snils,picture_pf)
            TMPITG->DATE_PR  := kart2->date_pr
            TMPITG->MO_PR    := kart2->mo_pr
            TMPITG->kod_tf   := kart2->kod_tf
            TMPITG->kod_mis  := kart2->kod_mis
            if lastrec() % 1000 == 0
              commit
            endif
            select KART
            skip
          enddo
          goto (rec1)
        endif
        select KART
      endif
    endif
    @ maxrow(),1 say lstr(curr) color "W+/R"
    @ row(),col() say "/" color "W/R"
    @ row(),col() say lstr(k) color "G+/R"
    skip
  enddo
elseif i == 4
  arr_title := {;
      "�������������������������������������������������������������������������������������������",;
      " NN �       ���      � � ���.�.�                     �.�.�.                       � ��� �.",;
      "�������������������������������������������������������������������������������������������"}
  sh := len(arr_title[1]) ; reg_print := 5
  fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
  add_string("")
  add_string(center("���᮪ �㡫�������� ����ᥩ � ����⥪�",sh))
  add_string(center('(�ࠢ����� �� ���� ��� "����� ����� �����")',sh))
  add_string("")
  aeval(arr_title, {|x| add_string(x) } )
  dbcreate(cur_dir+"tmp",{{"kod_mis","C",20,0}})
  use (cur_dir+"tmp") new
  index on kod_mis to (cur_dir+"tmp")
  R_Use(dir_server+"kartote_",,"KART_")
  R_Use(dir_server+"kartotek",,"KART")
  select KART2
  set relation to recno() into KART, to recno() into KART_
  index on kod_mis to (cur_dir+"tmp_kodmis") for !empty(kod_mis) .and. !empty(kart->kod) 
  go top
  do while !eof()
    GaugeUpdate( hGauge, ++curr/lastrec() )
    if inkey() == K_ESC
      add_string(replicate("*",sh))
      add_string(expand("����� �������"))
      stat_msg("���� ��ࢠ�!") ; mybell(1,OK)
      exit
    endif
    mkod_mis := kart2->kod_mis ; mfio := kart->fio
    rec1 := recno() ; j1 := 0
    find (mkod_mis)
    do while kart2->kod_mis == mkod_mis .and. !eof()
      if recno() != rec1
        j1++
      endif
      skip
    enddo
    goto (rec1)
    if j1 > 0
      select TMP
      find (mkod_mis)
      if !found()
        append blank
        tmp->kod_mis := mkod_mis
        ++k ; j1 := 0
        select KART2
        find (mkod_mis)
        do while kart2->kod_mis == mkod_mis .and. !eof()
          if verify_FF(HH,.t.,sh)
            aeval(arr_title, {|x| add_string(x) } )
          endif
          ++j1
          s := iif(j1==1, padr(lstr(k)+".",5), space(5))
          add_string(s+left(mkod_mis,16)+" "+padr(amb_kartaN(.t.),10)+;
                     padr(alltrim(kart->fio)+" ("+alltrim(inieditspr(A__MENUVERT,mm_vid_polis,kart_->VPOLIS))+;
                          " �����)",50)+" "+date_8(kart->date_r))
          select TMPITG
          append blank
          TMPITG->id       := k
          TMPITG->fio      := kart->fio
          TMPITG->DATE_R   := kart->date_r
          TMPITG->kod_kart := kart->kod
          TMPITG->adres    := kart->adres
          TMPITG->pol      := kart->pol
          TMPITG->polis    := kart->polis
          TMPITG->uchast   := kart->uchast
          TMPITG->kod_vu   := kart->kod_vu
          TMPITG->snils    := transform(kart->snils,picture_pf)
          TMPITG->DATE_PR  := kart2->date_pr
          TMPITG->MO_PR    := kart2->mo_pr
          TMPITG->kod_tf   := kart2->kod_tf
          TMPITG->kod_mis  := kart2->kod_mis
          if lastrec() % 1000 == 0
            commit
          endif
          select KART2
          skip
        enddo
      endif
    endif
    select KART2
    goto (rec1)
    @ maxrow(),1 say lstr(curr) color "W+/R"
    @ row(),col() say "/" color "W/R"
    @ row(),col() say lstr(k) color "G+/R"
    skip
  enddo
endif
close databases
fclose(fp)
CloseGauge(hGauge)
if k == 0
  func_error(4,"�� ������� �㡫�������� ����ᥩ!")
else
  viewtext(name_file,,,,.t.,,,reg_print)
endif
return NIL

***** 18.11.18
Function f2dubl_zap()
Local buf := savescreen()
Private dubl1_kart := 0, dubl2_kart := 0, top_frm
setcolor(color0)
box_shadow(15,2,22,77)
str_center(17,"� ��饬 ᯨ᪥ ᭠砫� �⬥砥��� 祫����, ���஬� �㤥� ��७�ᥭ� ���")
str_center(18,"���ଠ�� �� 㤠�塞�� ����窨 - �� �뤥����� ᨭ�� 梥⮬.")
mark_keys({"�� �뤥�����"},col_tit_popup)
mark_keys({"ᨭ�� 梥⮬"},"W+/B")
str_center(19,"��⥬ �⬥砥��� ����窠 㤠�塞��� 祫�����;")
str_center(20,"㤠�塞�� ������ �뤥����� ���� 梥⮬.")
mark_keys({"㤠�塞�� ������ �뤥�����"},"R/BG")
mark_keys({"���� 梥⮬"},"W+/R")
RunStr("������ ���� �������",21,3,76,"W+/BG")
box_shadow(0,2,0,77,color1,,,0)
str_center(0,"�������� �㡫�������� ����ᥩ � ����⥪�",color8)
if view_kart(3) .and. dubl1_kart > 0 .and. dubl2_kart > 0
  mywait()
  Use_base("kartotek")
  // �뢮� �� �࠭ ���ଠ樨
  top_frm := 0
  goto (dubl1_kart)
  kartotek_to_screen(1,8)
  @ 0,0 to 9,79 color "G+/B"
  str_center(0," �������, ���஬� ��७����� ���ଠ�� ","G+/RB")
  top_frm := 10
  goto (dubl2_kart)
  kartotek_to_screen(11,18)
  @ 10,0 to 19,79 double color color8
  str_center(10," �������, ����� 㤠����� ","GR+/R")
  FillScrArea(20,0,24,79,"�",color1)
  if !G_SLock("������஢���� ����⥪� "+lstr(dubl2_kart))
    func_error(4,"� ����� ������ � ����窮� 㤠�塞��� 祫����� ࠡ�⠥� ��㣮� ���짮��⥫�.")
  else
    if f_Esc_Enter(2,.t.)
      mywait()
      // ᯨ᮪ ��樥�⮢ � ॥���� ����� ��ᯠ��ਧ�権
      /*G_Use(dir_server+"mo_r01k",,"R01K")
      index on str(kod_k,7) to (cur_dir+"tmp_r01k")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        r01k->kod_k := dubl1_kart
      enddo
      close databases*/
      // ���ࠢ����� �� ��ᯨ⠫�����
      G_Use(dir_server+"mo_nnapr",,"NAPR")
      index on str(kod_k,7) to (cur_dir+"tmp_napr")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        napr->kod_k := dubl1_kart
      enddo
      close databases // �� ��直� ��砩
      //
      if hb_fileExists(dir_server+"mo_dnab"+sntx)
        Use_base("mo_dnab")
        do while .t.
          find (str(dubl2_kart,7))
          if !found() ; exit ; endif
          G_RLock(forever)
          dn->kod_k := dubl1_kart
        enddo
        close databases // �� ��直� ��砩
      endif
      //
      G_Use(dir_server+"human",dir_server+"humankk","HUMAN")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        human->kod_k := dubl1_kart
      enddo
      close databases // �� ��直� ��砩 (���� ࠡ�⠥� ����� ���)
      //
      G_Use(dir_server+"mo_kinos",dir_server+"mo_kinos","KIS")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      //
      G_Use(dir_server+"mo_kismo",,"SN")
      index on str(kod,7) to (cur_dir+"tmp_ismo")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      // ����� ��㣨
      G_Use(dir_server+"hum_p",dir_server+"hum_pkk","HUM_P")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        hum_p->kod_k := dubl1_kart
        UnLock
      enddo
      // ��⮯����
      G_Use(dir_server+"hum_ort",dir_server+"hum_ortk","HUM_O")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        hum_o->kod_k := dubl1_kart
        UnLock
      enddo
      // �ਥ��� �����
      G_Use(dir_server+"mo_pp",dir_server+"mo_pp_r","HU")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        hu->kod_k := dubl1_kart
        UnLock
      enddo
      // ���� �����
      G_Use(dir_server+"kas_pl",dir_server+"kas_pl1","KASP")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        kasp->kod_k := dubl1_kart
        UnLock
      enddo
      // ���� ��⮯����
      G_Use(dir_server+"kas_ort",dir_server+"kas_ort1","KASO")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        kaso->kod_k := dubl1_kart
        UnLock
      enddo
      // ������� ॣ���� �����客�����
      G_Use(dir_server+"kart_etk")
      index on str(kod_k,7) to (cur_dir+"tmp_kart_etk")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      // �ਬ�砭�� � ����⥪�
      G_Use(dir_server+"k_prim1",dir_server+"k_prim1","K_PRIM1")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        DeleteRec(.t.)
      enddo
      // ����� �� ��� � �����������
      G_Use(dir_server+"plat_vz",,"PVZ")
      index on str(kod_k,7) to (cur_dir+"tmp_pvz")
      set index to (cur_dir+"tmp_pvz"),(dir_server+"plat_vz")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        pvz->kod_k := dubl1_kart
        UnLock
      enddo
      // ॣ������ ���� �/�
      G_Use(dir_server+"mo_regi",{dir_server+"mo_regi1",;
                                  dir_server+"mo_regi2",;
                                  dir_server+"mo_regi3"},"RU")
      set order to 3
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        ru->kod_k := dubl1_kart
        UnLock
      enddo
      // ����
      G_Use(dir_server+"msek",dir_server+"msek","MSEK")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        msek->kod_k := dubl1_kart
        UnLock
      enddo
      // c��᮪ ����祪 ��樥�⮢ � ��᫠���� 室�⠩�⢠�
      G_Use(dir_server+"mo_hod_k",,"HK")
      index on str(kod_k,7) to (cur_dir+"tmp_hk")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        hk->kod_k := dubl1_kart
        UnLock
      enddo
      // ᯨ᮪ �ਪ९����� �� ��樥��� �� �६���
      G_Use(dir_server+"mo_kartp",dir_server+"mo_kartp","KARTP")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        kartp->kod_k := dubl1_kart
        UnLock
      enddo
      // ᯨ᮪ ����祪 � ॥���� �� �ਪ९�����
      G_Use(dir_server+"mo_krtp",,"KRTP")
      index on str(kod_k,7) to (cur_dir+"tmp_krtp")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        krtp->kod_k := dubl1_kart
        UnLock
      enddo
      // ᯨ᮪ �訡�� � ॥���� �� �ਪ९�����
      G_Use(dir_server+"mo_krte",,"KRTE")
      index on str(kod_k,7) to (cur_dir+"tmp_krte")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        krte->kod_k := dubl1_kart
        UnLock
      enddo
      // ᯨ᮪ ����祪 � 䠩��� �� ��९�����
      G_Use(dir_server+"mo_krto",,"KRTO")
      index on str(kod_k,7) to (cur_dir+"tmp_krto")
      do while .t.
        find (str(dubl2_kart,7))
        if !found() ; exit ; endif
        G_RLock(forever)
        krto->kod_k := dubl1_kart
        UnLock
      enddo
      //
      Use_base("kartotek")
      set order to 0
      select KART
      goto (dubl2_kart)
      // �.�. relation
      select KART2
      goto (dubl2_kart)
      if !eof()
        DeleteRec(.t.,.f.)  // ���⪠ ����� ��� ����⪨ �� 㤠�����
      endif
      select KART_
      goto (dubl2_kart)
      if !eof()
        DeleteRec(.t.,.f.)  // ���⪠ ����� ��� ����⪨ �� 㤠�����
      endif
      select KART
      goto (dubl2_kart)
      DeleteRec(.t.,.f.)  // ���⪠ ����� ��� ����⪨ �� 㤠�����
      close databases
      stat_msg("�㡫�������� ������ 㤠���� �� ����⥪�!") ; mybell(2,OK)
    endif
    G_SUnLock("������஢���� ����⥪� "+lstr(dubl2_kart))
  endif
  close databases
  glob_kartotek := dubl1_kart
endif
restscreen(buf)
return NIL

*

***** 03.12.15
Function kartotek_to_screen(r1,r2)
Local i, s, s1, mmo_pr, arr := {}, tmp_select := select()
is_talon := .t. // ���� ⠪
if is_uchastok > 0 .or. glob_mo[_MO_IS_UCH]
  s := ""
  if is_uchastok > 0
    s := "��� "+kart->bukva
    s += space(3)+"���⮪ "+lstr(kart->uchast)
    if is_uchastok == 1
      s += space(3)+"��� "+lstr(kart->kod_vu)
    elseif is_uchastok == 3
      s += space(3)+"��� �� ��� "+alltrim(kart2->kod_AK)+space(5)
    endif
    s += space(3)
  endif
  if glob_mo[_MO_IS_UCH]
    if left(kart2->PC2,1) == "1"
      mmo_pr := "�� ���ଠ樨 �� ����� ��樥�� �_�_�_�"
    elseif kart2->MO_PR == glob_mo[_MO_KOD_TFOMS]
      mmo_pr := "�ਪ९�� "
      if !empty(kart2->pc4)
        mmo_pr += "� "+alltrim(kart2->pc4)+" "
      elseif !empty(kart2->DATE_PR)
        mmo_pr += "� "+date_8(kart2->DATE_PR)+" "
      endif
      mmo_pr += "� ��襩 ��"
    else
      s1 := alltrim(inieditspr(A__MENUVERT,glob_arr_mo,kart2->mo_pr))
      if empty(s1)
        mmo_pr := "�ਪ९����� --- �������⭮ ---"
      else
        mmo_pr := ""
        if !empty(kart2->pc4)
          mmo_pr += "� "+alltrim(kart2->pc4)+" "
        elseif !empty(kart2->DATE_PR)
          mmo_pr += "� "+date_8(kart2->DATE_PR)+" "
        endif
        mmo_pr += "�ਪ९�� � " + s1
      endif
    endif
    s += mmo_pr
  endif
  aadd(arr,s)
endif
s := "�.�.�.: "+kart->fio+space(7)+iif(kart->pol=="�","��稭�","���騭�")
aadd(arr,s)
s := "��� ஦�����: "+full_date(kart->date_r)+space(5)+;
     "("+alltrim(inieditspr(A__MENUVERT, menu_vzros, kart->vzros_reb))+")"
if !empty(kart->snils)
  s += space(5)+"�����: "+transform(kart->SNILS,picture_pf)
endif
aadd(arr,s)
s := inieditspr(A__MENUVERT, menu_vidud, kart_->vid_ud)+;
     space(3)+alltrim(kart_->ser_ud)+" "+alltrim(kart_->nom_ud)
if !empty(kart_->kogdavyd)
  s += " �뤠� "+full_date(kart_->kogdavyd)+" "
  if !empty(kart_->kemvyd)
    s += inieditspr(A__POPUPMENU, dir_server+"s_kemvyd", kart_->KEMVYD)
  endif
endif
aadd(arr,s)
s := "���� ஦�����: "+alltrim(kart_->mesto_r)
aadd(arr,s)
s := "����: "
if !emptyall(kart_->okatog,kart->adres)
  s += ret_okato_ulica(kart->adres,kart_->okatog)
endif
aadd(arr,s)
if !emptyall(kart_->okatop,kart_->adresp)
  s := "���� �ॡ뢠���: "+ret_okato_ulica(kart_->adresp,kart_->okatop)
  aadd(arr,s)
endif
s := "����� ���: "
if !empty(kart2->kod_mis)
  s += "(��� "+alltrim(kart2->kod_mis)+") "
endif
if !emptyall(kart_->beg_polis,kart->srok_polis)
  s += "("
  if !empty(kart_->beg_polis)
    s += "� "+date_8(c4tod(kart_->beg_polis))
  endif
  if !empty(kart->srok_polis)
    s += " �� "+date_8(c4tod(kart->srok_polis))
  endif
  s += ") "
endif
if !empty(kart_->SPOLIS)
  s += alltrim(kart_->SPOLIS)+" "
endif
s += alltrim(kart_->NPOLIS)+" ("+;
     alltrim(inieditspr(A__MENUVERT,mm_vid_polis,kart_->VPOLIS))+") "+;
     smo_to_screen(1)
aadd(arr,s)
if eq_any(glob_task,X_REGIST,X_OMS,X_PLATN,X_ORTO,X_KASSA,X_PPOKOJ,X_MO)
  s := upper(rtrim(inieditspr(A__MENUVERT, menu_rab, kart->rab_nerab)))
  if kart_->PENSIONER == 1
    s += space(5)+"���ᨮ���"
  endif
  if !empty(kart->mr_dol)
    s += ",  ���� ࠡ���: "+kart->mr_dol
  endif
  aadd(arr,s)
endif
if eq_any(glob_task,X_MO)
  if !emptyall(kart_->PHONE_H,kart_->PHONE_M,kart_->PHONE_W)
    s := "����䮭�:"
    if !empty(kart_->PHONE_H)
      s += " ����譨� "+kart_->PHONE_H
    endif
    if !empty(kart_->PHONE_M)
      s += " ������� "+kart_->PHONE_M
    endif
    if !empty(kart_->PHONE_W)
      s += " ࠡ�稩 "+kart_->PHONE_W
    endif
    aadd(arr,s)
  endif
  if !empty(kart_->KOD_LGOT)
    aadd(arr, inieditspr(A__MENUVERT, glob_katl, kart_->KOD_LGOT))
  endif
endif
if eq_any(glob_task,X_REGIST,X_OMS,X_PPOKOJ,X_MO)
  s := ""
  if is_talon .and. kart_->kategor > 0
    s := "��� ��⥣�ਨ �죮��: "+rtrim(inieditspr(A__MENUVERT, stm_kategor, kart_->kategor))+space(5)
  endif
  if !empty(stm_kategor2) .and. kart_->kategor2 > 0
    s += "��⥣��� ��: "+rtrim(inieditspr(A__MENUVERT, stm_kategor2, kart_->kategor2))
  endif
  aadd(arr,s)
endif
//
ClrLines(r1,r2,color1)
for i := 1 to len(arr)
  if r1+i-1 > r2 ; exit ; endif
  @ r1+i-1,1 say arr[i] color color1
next
select (tmp_select)
return NIL

*

***** 13.07.15 ������ ��᫥���� ������஢���� 䠩�
Function wq_ret_last_name()
Local s := "", arr_f := {}
scandirfiles(dir_server, ;
             "mo_wq*"+sdbf, ;
             {|x| aadd(arr_f,Name_Without_Ext(StripPath(x))) })
if !empty(arr_f)
  asort(arr_f,,,{|x,y| iif(substr(x,6,6) == substr(y,6,6), ;
                             val(substr(x,12)) < val(substr(y,12)), ;
                           substr(x,6,6) < substr(y,6,6)) } )
  s := atail(arr_f)
endif
return s

***** 14.07.15 �஢���� �� �� ��᫥���� (�� ���) �������㥬� 䠩�
Function wq_if_last_file(lname,/*@*/flast)
Local fl := .t., s := wq_ret_last_name()
if !empty(s)
  flast := substr(s,6) ; lname := substr(lname,10)
  if left(lname,6) == left(flast,6)
    if val(substr(lname,7)) < val(substr(flast,7))
      fl := .f.
    endif
  elseif left(lname,6) < left(flast,6)
    fl := .f.
  endif
endif
if !fl
  func_error(4,"��� �� ���⠭ ����� ������� 䠩�. ����� ����樨!")
endif
return fl

*

***** 20.10.15 ������ 䠩�� �� ����� � ���⪠�� �ਪ९���� ��� ���
Function wq_import()
Local adbf, cName, i, s, buf, arr, arr_f, fbase
Private p_var_manager := "Read_WQ_TFOMS", full_zip
if !empty(full_zip := manager(T_ROW,T_COL+5,maxrow()-2,,.t.,1,,,,"WQ2*"+szip))
  name_zip := StripPath(full_zip)  // ��� 䠩�� ��� ���
  cName := Name_Without_Ext(name_zip)
  fbase := "mo_wq"+substr(cName,10)
  if hb_fileExists(dir_server+fbase+sdbf)
    return func_error(4,"����� 䠩� 㦥 �� ������஢��!")
  endif
  R_Use(dir_server+"mo_krtr",,"KRTR")
  index on wq to (cur_dir+"tmp_krtr") for !empty(wq)
  find (padr(substr(cName,10),11))
  fl := found()
  Use
  if fl
    return func_error(4,"����� 䠩� 㦥 �� ������஢��")
  endif
  fl := .f.
  if (arr_f := Extract_Zip_XML(KeepPath(full_zip),name_zip)) != NIL
    if (n := ascan(arr_f,{|x| upper(Name_Without_Ext(x)) == upper(cName)})) > 0
      fl := .t.
    else
      fl := func_error(4,"� ��娢� "+name_zip+" ��� 䠩�� "+cName+sdbf)
    endif
  endif
  /*if (fl := Extract_RAR(KeepPath(full_zip),name_zip)) .and. ;
                                       !hb_fileExists(_tmp_dir1+cName+sdbf)
    fl := func_error(4,"�������� �訡�� �� ࠧ��娢�஢���� "+_tmp_dir1+cName+szip)
  endif*/
  last_file := " "
  if fl .and. wq_if_last_file(cName,@last_file)
    s := cName ; name_dbf := cName+sdbf
    if upper(left(s,3)) == "WQ2"
      s := substr(s,4)
      cMO := substr(s,1,6)
      if cMO == glob_MO[_MO_KOD_TFOMS]
        last_file := padr(last_file,11)
        k := 0
        R_Use(dir_server+"mo_krtr",,"KRTR")
        index on wq to (cur_dir+"tmp_krtr") for !empty(wq)
        go top
        do while !eof()
          if last_file == krtr->wq
            ++k
          endif
          if krtr->ANSWER == 0
            fl := func_error(4,"�� 䠩� �ਪ९����� "+rtrim(krtr->fname)+scsv+" �� ����祭 �⢥� �� �����!")
          endif
          skip
        enddo
        Use
        if fl .and. !empty(last_file) .and. empty(k)
          fl := func_error(4,"�� �।��饬� 䠩�� mo_wq"+rtrim(last_file)+sdbf+" �� �� ��⠢��� 䠩� �ਪ९�����")
        endif
        if fl
          R_Use(_tmp_dir1+cName,,"T1")
          k := lastrec()
          Use
        else
          k := 0
        endif
        if k > 0
          arr := {glob_MO[_MO_SHORT_NAME]}
          aadd(arr, "��⠥��� 䠩� "+name_dbf+" � �ਪ९��� ��ᥫ�����,")
          aadd(arr, "�� ���஬� � ����� ��� �� �ਪ९���� ��� (���⪨) - "+lstr(k)+" 祫.")
          buf := save_maxrow()
          if f_alert(arr,{" �⪠� "," ������ 䠩�� �ਪ९����� "},1,;
                     "N+/G*","N/G*",16,,"N/G*") == 2
            adbf := {;
              {"kod_k",      "N",      7,      0},;
              {"uchast",     "N",      2,      0},;
              {"fio",        "C",     50,      0},;
              {"ID",         "N",      8,      0},;
              {"FAM",        "C",     40,      0},;
              {"IM",         "C",     40,      0},;
              {"OT",         "C",     40,      0},;
              {"W",          "N",      1,      0},;
              {"DR",         "D",      8,      0},;
              {"SA",         "C",      1,      0},;
              {"RN",         "C",     11,      0},;
              {"INDX",       "C",      6,      0},;
              {"adres",      "C",     90,      0},;
              {"CITY",       "C",     80,      0},;
              {"NP",         "C",     80,      0},;
              {"UL",         "C",     80,      0},;
              {"DOM",        "C",     12,      0},;
              {"KOR",        "C",     12,      0},;
              {"KV",         "C",     12,      0},;
              {"SMO",        "C",      5,      0},;
              {"POLTP",      "N",      1,      0},;
              {"SPOL",       "C",     20,      0},;
              {"NPOL",       "C",     20,      0},;
              {"LPUAUTO",    "N",      1,      0},;
              {"LPU",        "C",      6,      0},;
              {"LPUDT",      "D",      8,      0};
             }
             /* �⥫��� ��
              {"UCHAST",     "N",     10,      0},; // ���⮪
              {"SNILS_VR",   "C",     11,      0},; // ����� ��.���
              {"KATEG_VR",   "N",      1,      0},; // ��⥣��� ���
              {"SNILS",      "C",     11,      0},; // ����� ��樥��
              {"vid_ud",     "N",      2,      0},; // ��� 㤮�⮢�७�� ��筮��;�� ����஢�� �����;"PKRT_VID �� ""APP_BASE"""
              {"ser_ud",     "C",     10,      0},; // ��� 㤮�⮢�७�� ��筮��;;"PKRT_SER �� ""APP_BASE"""
              {"nom_ud",     "C",     20,      0},; // ����� 㤮�⮢�७�� ��筮��;;"PKRT_NOM �� ""APP_BASE"""
              {"kemvyd",     "N",      4,      0},; // ��� �뤠� ���㬥��;"�ࠢ�筨� ""s_kemvyd""";"PKRT_KEM �� ""APP_BASE"""
              {"kogdavyd",   "D",      8,      0},; // ����� �뤠� ���㬥��;;"PKRT_KOGDA �� ""APP_BASE"""
              {"MESTO_R",    "C",    100,      0},; // ���� ஦�����
             */
            dbcreate(dir_server+fbase,adbf)
            Use (dir_server+fbase) new alias WQ
            i1 := i2 := 0
            G_Use(dir_server+"mo_kfio",,"KFIO")
            index on str(kod,7) to (cur_dir+"tmp_kfio")
            use_base("kartotek")
            R_Use(_tmp_dir1+cName,,"T1")
            go top
            do while !eof()
              @ maxrow(),0 say padr(str(recno()/lastrec()*100,6,2)+"%",maxcol()+1) color "W/R"
              MFIO := alltrim(t1->FAM)+" "+alltrim(t1->IM)+" "+alltrim(t1->OT)
              lkod_k := luchast := 0 ; mfio := padr(charone(" ",mfio),50)
              if !emptyany(mfio,t1->dr)
                select KART
                set order to 2
                s := upper(padr(mfio,50))
                find ("1"+s+dtos(t1->dr))
                if (fl := found())
                  ++i1
                  lkod_k := kart->kod
                  luchast := kart->uchast
                endif
                select WQ
                append blank
                wq->kod_k   := lkod_k
                wq->uchast  := luchast
                wq->fio     := mfio
                wq->ID      := t1->ID
                wq->FAM     := t1->FAM
                wq->IM      := t1->IM
                wq->OT      := t1->OT
                wq->W       := t1->W
                wq->DR      := t1->DR
                wq->SA      := t1->SA
                wq->RN      := t1->RN
                wq->INDX    := t1->INDX
                wq->CITY    := t1->CITY
                wq->NP      := t1->NP
                wq->UL      := t1->UL
                wq->DOM     := t1->DOM
                wq->KOR     := t1->KOR
                wq->KV      := t1->KV
                wq->SMO     := t1->SMO
                wq->POLTP   := t1->POLTP
                wq->SPOL    := t1->SPOL
                wq->NPOL    := t1->NPOL
                wq->LPUAUTO := t1->LPUAUTO
                wq->LPU     := t1->LPU
                wq->LPUDT   := t1->LPUDT
                la := ""
                if !empty(wq->INDX)
                  la += wq->INDX+" "
                endif
                if !emptyall(wq->CITY,wq->NP)
                  if wq->CITY == wq->NP
                    la += alltrim(wq->CITY)+" "
                  else
                    if !empty(wq->CITY)
                      la += alltrim(wq->CITY)+" "
                    endif
                    if !empty(wq->NP)
                      la += alltrim(wq->NP)+" "
                    endif
                  endif
                endif
                if !empty(wq->UL)
                  la += alltrim(wq->UL)+" "
                endif
                if !empty(wq->DOM)
                  la += "�."+alltrim(wq->DOM)
                  if !empty(wq->KOR)
                    if !(left(wq->KOR,1) == "/")
                      la += "/"
                    endif
                    la += alltrim(wq->KOR)
                  endif
                endif
                if !empty(wq->KV)
                  la += ",��."+alltrim(wq->KV)+" "
                endif
                wq->adres := la
                if fl
                  lpoltp := iif(between(wq->POLTP,1,3), wq->POLTP, 1)
                  if !(kart_->VPOLIS == lpoltp .and. alltrim(kart_->NPOLIS)==alltrim(wq->NPOL))
                    select KART
                    G_RLock(forever)
                    kart->POLIS   := make_polis(wq->SPOL,wq->NPOL)
                    select KART_
                    do while kart_->(lastrec()) < lkod_k
                      APPEND BLANK
                    enddo
                    goto (lkod_k)
                    G_RLock(forever)
                    kart_->VPOLIS := lpoltp
                    kart_->SPOLIS := ltrim(wq->SPOL)
                    kart_->NPOLIS := ltrim(wq->NPOL)
                    kart_->SMO    := wq->SMO
                  endif
                  select KART2
                  do while kart2->(lastrec()) < lkod_k
                    G_RLock(.t.,forever) // ��᪮��筠� ����⪠ �������� ������
                    kart2->kod_tf := 0
                    kart2->MO_PR := ""
                    kart2->SNILS_VR := "" // ��.��� ��� �� �ਢ易�
                    kart2->PC2 := ""      // �� 㬥�
                    kart2->PC4 := ""
                  enddo
                  goto (lkod_k)
                  G_RLock(forever)
                  kart2->kod_tf := wq->id
                  kart2->MO_PR := wq->lpu
                  kart2->TIP_PR := wq->LPUAUTO
                  kart2->DATE_PR := wq->lpudt
                  kart2->PC2 := ""      // �� 㬥�
                  if !empty(kart2->DATE_PR)
                    kart2->PC4 := date_8(kart2->DATE_PR)
                  endif
                else
                  ++i2
                  select KART
                  set order to 1
                  Add1Rec(7)
                  lkod_k := kart->kod := recno()
                  wq->kod_k := lkod_k
                  kart->FIO := wq->fio
                  mdate_r := kart->DATE_R := wq->dr
                  m1VZROS_REB := M1NOVOR := 0
                  fv_date_r()
                  kart->pol := iif(wq->w==1,"�","�")
                  kart->VZROS_REB := m1VZROS_REB
                  if TwoWordFamImOt(wq->fam) .or. TwoWordFamImOt(wq->im);
                                             .or. TwoWordFamImOt(wq->ot)
                    kart->MEST_INOG := 9
                  else
                    kart->MEST_INOG := 0
                  endif
                  madres := ""
                  if !empty(wq->UL)
                    madres += alltrim(wq->UL)+" "
                  endif
                  if !empty(wq->DOM)
                    madres += "�."+alltrim(wq->DOM)
                    if !empty(wq->KOR)
                      if !(left(wq->KOR,1) == "/")
                        madres += "/"
                      endif
                      madres += alltrim(wq->KOR)
                    endif
                  endif
                  if !empty(wq->KV)
                    madres += ",��."+alltrim(wq->KV)+" "
                  endif
                  kart->ADRES := madres
                  select KART_
                  do while kart_->(lastrec()) < lkod_k
                    APPEND BLANK
                  enddo
                  goto (lkod_k)
                  G_RLock(forever)
                  kart->POLIS   := make_polis(wq->SPOL,wq->NPOL)
                  kart_->VPOLIS := iif(between(wq->POLTP,1,3), wq->POLTP, 1)
                  kart_->SPOLIS := ltrim(wq->SPOL)
                  kart_->NPOLIS := ltrim(wq->NPOL)
                  kart_->SMO := wq->SMO
                  kart_->okatog := wq->rn
                  if wq->sa == "�" // �� ����� �஦������
                    kart_->okatop := wq->rn
                    kart_->adresp := madres
                  endif
                  select KART2
                  do while kart2->(lastrec()) < lkod_k
                    G_RLock(.t.,forever) // ��᪮��筠� ����⪠ �������� ������
                    kart2->kod_tf := 0
                    kart2->MO_PR := ""
                    kart2->SNILS_VR := "" // ��.��� ��� �� �ਢ易�
                    kart2->PC2 := ""      // �� 㬥�
                    kart2->PC4 := ""
                  enddo
                  goto (lkod_k)
                  G_RLock(forever)
                  kart2->kod_tf := wq->id
                  kart2->MO_PR := wq->lpu
                  kart2->TIP_PR := wq->LPUAUTO
                  kart2->DATE_PR := wq->lpudt
                  kart2->PC2 := ""      // �� 㬥�
                  if !empty(kart2->DATE_PR)
                    kart2->PC4 := date_8(kart2->DATE_PR)
                  endif
                  //
                  select KFIO
                  find (str(lkod_k,7))
                  if found()
                    if kart->MEST_INOG == 9
                      G_RLock(forever)
                      kfio->FAM := ltrim(charone(" ",wq->fam))
                      kfio->IM  := ltrim(charone(" ",wq->im))
                      kfio->OT  := ltrim(charone(" ",wq->ot))
                    else
                      DeleteRec(.t.)
                    endif
                  else
                    if kart->MEST_INOG == 9
                      AddRec(7)
                      kfio->kod := lkod_k
                      kfio->FAM := ltrim(charone(" ",wq->fam))
                      kfio->IM  := ltrim(charone(" ",wq->im))
                      kfio->OT  := ltrim(charone(" ",wq->ot))
                    endif
                  endif
                endif
                dbUnlockAll()
              endif
              select T1
              if recno() % 1000 == 0
                dbCommitAll()
              endif
              skip
            enddo
            close databases
            rest_box(buf)
            n_message({"�⥭�� 䠩�� "+cName+" �����襭�!",;
                       "������� � ����⥪� - "+lstr(i1)+" 祫.",;
                       "������஢��� - "+lstr(i2)+" 祫."},,"W/G","N/G",,,"GR/G")
            keyboard chr(K_TAB)+chr(K_ENTER)
          endif
          close databases
          rest_box(buf)
        endif
      else
        func_error(4,"��� ��� �� "+glob_MO[_MO_KOD_TFOMS]+;
                     " �� ᮮ⢥����� ���� �����⥫�: "+cMO)
      endif
    else
      func_error(4,"����⪠ ������ ��������� 䠩� (䠩� ������ ��稭����� � WQ2...)")
    endif
  endif
endif
return NIL

*

***** 13.07.15
Function wq_view()
Local sh, HH := 78, name_file := "imp_prip"+stxt,i := 0, arr_title, lu, la, ;
      buf := save_maxrow(), fname := wq_ret_last_name()
if empty(fname)
  return func_error(4,"�� �뫮 �⥭�� 䠩�� � ����� �ଠ�!")
endif
mywait()
arr_title := {;
"�����������������������������������������������������������������������������������������������������������������",;
" �� ���               �.�.�                    ���� ஦�.�                     ����",;
"�����������������������������������������������������������������������������������������������������������������"}
fp := fcreate(name_file) ; tek_stroke := 0 ; n_list := 1
sh := len(arr_title[1])
add_string("")
add_string(center("���᮪ ��樥�⮢ �� 䠩�� "+fname,sh))
add_string("")
aeval(arr_title, {|x| add_string(x) } )
R_Use(dir_server+fname,,"WQ")
index on upper(fio)+dtos(dr) to (cur_dir+"tmp_wq")
go top
do while !eof()
  if verify_FF(HH,.t.,sh)
    aeval(arr_title, {|x| add_string(x) } )
  endif
  add_string(padr(lstr(++i)+".",5)+put_val(wq->uchast,2)+" "+padr(wq->fio,40)+" "+;
               full_date(wq->dr)+" "+rtrim(wq->adres))
  skip
enddo
fclose(fp)
close databases
rest_box(buf)
viewtext(name_file,,,,.t.,,,6)
return NIL

*

***** 14.07.15 ����஥ ।���஢���� ���⪮� ᯨ᪮�
Function wq_edit_uchast()
Local fl, buf := savescreen()
Private fname := wq_ret_last_name()
if empty(fname)
  return func_error(4,"�� �뫮 �⥭�� 䠩�� � ����� �ଠ�!")
endif
R_Use(dir_server+"mo_krtr",,"KRTR")
index on wq to (cur_dir+"tmp_krtr") for !empty(wq)
find (padr(substr(fname,10),11))
fl := found()
Use
if fl
  return func_error(4,"���� �ਪ९����� MO2...CSV �� 䠩�� "+fname+sdbf+" 㦥 ��ࠢ��� � �����!")
endif
mywait()
Use_base("kartotek")
set order to 0
G_Use(dir_server+fname,,"WQ")
index on upper(fio)+dtos(dr) to (cur_dir+"tmp_wq")
go top
Private ku := wq->(lastrec())
if ku == 0
  close databases
  restscreen(buf)
  return func_error(4,"��� ����ᥩ!")
endif
go top
Alpha_Browse(2,0,23,79,"f1_wq_edit_uchast",color0,"������஢���� ���⪮� � 䠩�� "+fname+" ("+lstr(ku)+" 祫.)","BG+/GR",;
             .t.,.t.,,,"f2_wq_edit_uchast",,;
             {"�","�","�","N/BG,W+/N,B/BG,W+/B,R/BG,BG/R",.t.,180,"*+"} )
close databases
restscreen(buf)
return NIL

*

***** 16.01.17
Function f1_wq_edit_uchast(oBrow)
Local oColumn, blk := {|| iif(wq->uchast <= 0, {3,4}, {1,2}) } 
oColumn := TBColumnNew(center("���",30),{|| padr(wq->fio,30) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("��� ஦�.",{|| full_date(wq->dr) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew("��",{|| str(wq->uchast,2) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
oColumn := TBColumnNew(center("����",31),{|| padr(wq->adres,31) })
oColumn:colorBlock := blk
oBrow:addColumn(oColumn)
status_key("^<Esc>^ - ��室;  ^<Enter>^ - ।���஢���� ���⪠;  ^<F9>^ - ����� ᯨ᪠")
return NIL

*

***** 14.07.15
Function f2_wq_edit_uchast(nKey,oBrow)
Local j := 0, flag := -1, buf := save_maxrow(), buf1, fl := .f., nr := row(), c1, rec, arr_title, ;
      mkod, buf0, tmp_color := setcolor(), t_vr, sh, HH := 78, name_file := "wq"+stxt, i := 0
Private  much, old_uch
do case
  case nKey == K_F9
    mywait()
    rec := wq->(recno())
    arr_title := {;
"�����������������������������������������������������������������������������������������������������������������",;
" �� ���               �.�.�                    ���� ஦�.�                     ����",;
"�����������������������������������������������������������������������������������������������������������������"}
    fp := fcreate(name_file) ; tek_stroke := 0 ; n_list := 1
    sh := len(arr_title[1])
    add_string("")
    add_string(center("���᮪ ��樥�⮢ �� 䠩�� "+fname,sh))
    add_string("")
    aeval(arr_title, {|x| add_string(x) } )
    go top
    do while !eof()
      if verify_FF(HH,.t.,sh)
        aeval(arr_title, {|x| add_string(x) } )
      endif
      add_string(padr(lstr(++j)+".",5)+put_val(wq->uchast,2)+" "+padr(wq->fio,40)+" "+;
                 full_date(wq->dr)+" "+rtrim(wq->adres))
      skip
    enddo
    fclose(fp)
    rest_box(buf)
    viewtext(name_file,,,,.t.,,,6)
    goto (rec)
    flag := 0
  case nKey == K_ENTER
    old_uch := much := wq->uchast
    c1 := 44
    @ nr,c1 get much pict "99" color "GR+/R"
    myread()
    if lastkey() != K_ESC .and. old_uch != much
      select KART
      goto (wq->kod_k)
      G_RLock(forever)
      kart->uchast := much
      dbunlock()
      select WQ
      G_RLock(forever)
      wq->uchast := much
      dbunlock()
      Commit
      keyboard chr(K_TAB)
    endif
    flag := 0
  otherwise
    keyboard ""
endcase
return flag

*

***** 16.07.15 �����⮢�� � ᮧ����� 䠩��� �ਪ९����� ��� WQ...
Function wq_prikreplenie()
Local i, j := 0, arr_uch := {}, fl_err := .f., buf := save_maxrow(),;
      fl := .f., filename := wq_ret_last_name()
if empty(filename)
  return func_error(4,"�� �뫮 �⥭�� 䠩�� � ����� �ଠ�!")
endif
Private nkod_reestr := 0
mywait()
R_Use(dir_server+"mo_krtr",,"KRTR")
index on wq to (cur_dir+"tmp_krtr") for !empty(wq)
go top
if eof() // �.�. ���� ࠧ
  nkod_reestr := 1
else
  find (padr(substr(filename,10),11))
  if (fl := found())
    func_error(4,"���� �ਪ९����� "+rtrim(krtr->fname)+scsv+" �� 䠩�� "+filename+sdbf+" 㦥 ��ࠢ��� � �����!")
  else
    go bottom
    if krtr->ANSWER == 1
      nkod_reestr := krtr->KOD
    endif
  endif
endif
if !fl .and. empty(nkod_reestr)
  fl := !func_error(4,"�� ��᫥���� 䠩� �ਪ९����� �� �� ���⠭ �⢥�. ����� ����樨!")
endif
if !fl
  index on dtos(dfile) to (cur_dir+"tmp_krtr") for left(fname,3) == "MO2"
  find (dtos(sys_date))
  if found()
    fl := !func_error(4,"���� �ਪ९����� � ��⮩ "+full_date(sys_date)+"�. 㦥 �� ᮧ���")
  endif
endif
Use
rest_box(buf)
if fl
  return NIL
endif
if !f_Esc_Enter("�ਪ९�����")
  return NIL
endif
mywait()
close databases
if hb_FileExists(dir_server+filename+sdbf)
  mywait()
  //
  R_Use(dir_server+filename,,"WQ")
  index on upper(fio)+dtos(dr) to (cur_dir+"tmp_wq")
  go top
  do while !eof()
    if empty(wq->uchast)
      aadd(arr_uch, alltrim(wq->fio)+" �.�."+full_date(wq->dr)+" ��� ���⪠")
    endif
    skip
  enddo
  close databases
  //
  rest_box(buf)
  if !empty(arr_uch)
    fl_err := .t.
  endif
else
  fl_err := !func_error(4,"�� ������ ������஢���� 䠩� "+filename+sdbf)
endif
if fl_err
  if !empty(arr_uch)
    mywait()
    cFileProtokol := "prot"+stxt
    strfile(space(5)+"���᮪ ��樥�⮢ �� 䠩�� "+filename+sdbf+" ��� ���⪠"+hb_eol()+hb_eol(),cFileProtokol)
    for i := 1 to len(arr_uch)
      strfile(lstr(i)+". "+arr_uch[i]+hb_eol(),cFileProtokol,.t.)
    next
    rest_box(buf)
    viewtext(Devide_Into_Pages(cFileProtokol,60,80),,,,.t.,,,2)
  endif
  return NIL
endif
mywait()
dbcreate(cur_dir+"tmp",{;
  {"kod_k", "N",7,0},;
  {"kod_wq","N",6,0},;
  {"uchast","N",2,0},;
  {"vr",    "N",1,0}})
use (cur_dir+"tmp") new
j := 0
R_Use(dir_server+filename,,"WQ")
go top
do while !eof()
  @ maxrow(),0 say str(++j/wq->(lastrec())*100,6,2)+"%" color cColorWait
  if (i := ascan(arr_uch, {|x| x[1] == wq->uchast })) == 0
    aadd(arr_uch, {wq->uchast,0,0 }) ; i := len(arr_uch)
  endif
  select TMP
  append blank
  tmp->kod_k := wq->kod_k
  tmp->kod_wq := wq->(recno())
  tmp->uchast := wq->uchast
  if count_years(wq->dr,sys_date) < 18 // ���
    arr_uch[i,2] ++
    tmp->vr := 1
  else
    arr_uch[i,3] ++
    tmp->vr := 0
  endif
  select WQ
  skip
enddo
close databases
rest_box(buf)
if empty(arr_uch)
  return func_error(4,"�� ������� �ਪ९���� ��樥�⮢ � ���⪠��, �� ��ࠢ������ � �����")
endif
asort(arr_uch,,,{|x,y| x[1] < y[1] } )
cFileProtokol := "prot"+stxt
strfile(space(5)+"���᮪ ���⪮�"+hb_eol()+hb_eol(),cFileProtokol)
R_Use(dir_server+"mo_otd",,"OTD")
R_Use(dir_server+"mo_pers",,"P2")
R_Use(dir_server+"mo_uchvr",,"UV")
index on str(uch,2) to (cur_dir+"tmp_uv")
j := 0
for i := 1 to len(arr_uch)
  s := str(arr_uch[i,1],2)+":"
  if !empty(arr_uch[i,2])
    s += "  ��� - "+lstr(arr_uch[i,2])+"祫."
  endif
  if !empty(arr_uch[i,3])
    s += "  ����� - "+lstr(arr_uch[i,3])+"祫."
  endif
  strfile(s+hb_eol(),cFileProtokol,.t.)
  select UV
  find (str(arr_uch[i,1],2))
  if found() .and. !emptyall(uv->vrach,uv->vrachv,uv->vrachd)
    select P2
    if empty(uv->vrach)
      if empty(uv->vrachv)
        if !empty(arr_uch[i,3])
          strfile(space(5)+"�������������� - �� �ਢ易� ���⪮�� ��� � ����� - �� ��ࠢ�塞"+hb_eol(),cFileProtokol,.t.)
        endif
      else
        p2->(dbGoto(uv->vrachv))
        strfile(space(5)+alltrim(p2->fio)+" (�����)"+hb_eol(),cFileProtokol,.t.)
        f1_wq_prikreplenie(cFileProtokol,@fl_err)
        j += arr_uch[i,3]
      endif
      if empty(uv->vrachd)
        if !empty(arr_uch[i,2])
          strfile(space(5)+"�������������� - �� �ਢ易� ���⪮�� ��� � ���� - �� ��ࠢ�塞"+hb_eol(),cFileProtokol,.t.)
        endif
      else
        p2->(dbGoto(uv->vrachd))
        strfile(space(5)+alltrim(p2->fio)+" (���)"+hb_eol(),cFileProtokol,.t.)
        f1_wq_prikreplenie(cFileProtokol,@fl_err)
        j += arr_uch[i,2]
      endif
    else
      p2->(dbGoto(uv->vrach))
      strfile(space(5)+alltrim(p2->fio)+iif(emptyany(arr_uch[i,2],arr_uch[i,3]),""," (�� ��樥���)")+hb_eol(),cFileProtokol,.t.)
      f1_wq_prikreplenie(cFileProtokol,@fl_err)
      j += arr_uch[i,2]+arr_uch[i,3]
    endif
  else
    fl_err := .t.
    strfile(space(5)+"!������! �� �ਢ易� ���⪮�� ���"+hb_eol(),cFileProtokol,.t.)
  endif
next
close databases
viewtext(Devide_Into_Pages(cFileProtokol,60,80),,,,.t.,,,2)
if !fl_err .and. j == 0
  return func_error(4,"�� ������� �ਪ९���� ��樥�⮢ � ���⪠��, �� ��ࠢ������ � �����")
endif
if !fl_err .and. ;
    f_alert({"� ����� ������ �����⮢���� "+lstr(j)+" (������஢�����) ��樥�⮢",;
             "��� ����祭�� � 䠩� �ਪ९�����",""},;
            {" �⪠� "," ������� 䠩� �ਪ९����� "},;
            1,"N+/GR*","N/GR*",maxrow()-8,,"N/GR*") == 2
  mdate := sys_date
  Private str_sem := "pripisnoe_naselenie_create_compare"
  if !G_SLock(str_sem)
    return func_error(4,"� ����� ������ � �⨬ ०���� ࠡ�⠥� ��㣮� ���짮��⥫�.")
  endif
  mywait()
  s := "MO2"+glob_mo[_MO_KOD_TFOMS]+dtos(mdate)
  n_file := s+scsv
  G_Use(dir_server+"mo_krtr",,"KRTR")
  index on str(kod,6) to (cur_dir+"tmp_krtr")
  AddRec(6)
  krtr->KOD := recno()
  krtr->FNAME := s
  krtr->DFILE := mdate
  krtr->DATE_OUT := ctod("")
  krtr->NUMB_OUT := 0
  krtr->WQ := substr(filename,6) // YYMMDDN - ����砭�� ����� 䠩��
  krtr->KOL := 0
  krtr->KOL_P := 0
  krtr->ANSWER := 0  // 0-�� �뫮 �⢥�, 1-�� ���⠭ �⢥�
  G_Use(dir_server+"mo_krtf",,"KRTF")
  index on str(kod,6) to (cur_dir+"tmp_krtf")
  AddRec(6)
  krtf->KOD   := recno()
  krtf->FNAME := krtr->FNAME
  krtf->DFILE := krtr->DFILE
  krtf->TFILE := hour_min(seconds())
  krtf->TIP_IN := 0
  krtf->TIP_OUT := _CSV_FILE_REESTR
  krtf->REESTR := krtr->KOD
  krtf->DWORK := sys_date
  krtf->TWORK1 := hour_min(seconds()) // �६� ��砫� ��ࠡ�⪨
  krtf->TWORK2 := ""                  // �६� ����砭�� ��ࠡ�⪨
  //
  krtr->KOD_F := krtf->KOD
  dbUnLockAll()
  Commit
  //
  blk := {|_s| iif(empty(_s), '', '"'+_s+'"') }
  delete file (n_file)
  fp := fcreate(n_file)
  //
  G_Use(dir_server+"mo_krtp",,"KRTP")
  index on str(reestr,6) to (cur_dir+"tmp_krtp")
  mywait("�������� 䠩�� �ਪ९�����")
  j := ii := 0
  R_Use(exe_dir+"_mo_podr",cur_dir+"_mo_podr","PODR")
  find (glob_mo[_MO_KOD_TFOMS])
  loidmo := alltrim(podr->oidmo)
  R_Use(dir_server+"mo_otd",,"OTD")
  R_Use(dir_server+"mo_pers",,"P2")
  R_Use(dir_server+"mo_uchvr",cur_dir+"tmp_uv","UV")
  R_Use(dir_server+filename,,"WQ")
  use_base("kartotek")
  set order to 0
  use (cur_dir+"tmp") new
  set relation to kod_wq into WQ
  index on upper(wq->fio) to (cur_dir+"tmp__")
  go top
  do while !eof()
    @ maxrow(),0 say str(++j/tmp->(lastrec())*100,6,2)+"%" color cColorWait
    if (i := ascan(arr_uch, {|x| x[1] == wq->uchast })) == 0
      fl := .f.
    else
      select UV
      find (str(arr_uch[i,1],2))
      if found() .and. !emptyall(uv->vrach,uv->vrachv,uv->vrachd)
        select P2
        if empty(uv->vrach)
          fl := .f.
          if empty(uv->vrachv)
            //
          elseif tmp->vr == 0 // �����
            fl := .t.
            p2->(dbGoto(uv->vrachv))
            otd->(dbGoto(p2->otd))
          endif
          if empty(uv->vrachd)
            //
          elseif tmp->vr == 1 // ���
            fl := .t.
            p2->(dbGoto(uv->vrachd))
            otd->(dbGoto(p2->otd))
          endif
        else // ��
          fl := .t.
          p2->(dbGoto(uv->vrach))
          otd->(dbGoto(p2->otd))
        endif
      else
        fl := .f.
      endif
    endif
    if fl
      select KART
      goto (wq->kod_k)
      ++ii
      select KRTP
      AddRec(6)
      krtp->REESTR   := krtr->KOD      // ��� ॥���;�� 䠩�� "mo_krtr"
      krtp->KOD_K    := wq->kod_k      // ��� ��樥�� �� 䠩�� "kartotek"
      krtp->D_PRIK   := wq->LPUDT      // ��� �ਪ९����� (������)
      krtp->S_PRIK   := 1              // ᯮᮡ �ਪ९�����: 1-�� ����� ॣ����樨, 2-�� ��筮�� ������ (��� ��������� �/�), 3-�� ��筮�� ������ (� �裡 � ���������� �/�)
      krtp->UCHAST   := wq->uchast     // ����� ���⪠
      krtp->SNILS_VR := p2->snils      // ����� ���⪮���� ���
      krtp->KOD_PODR := alltrim(otd->kod_podr) // ��� ���ࠧ������� �� ��ᯮ��� ���
      krtp->REES_ZAP := ii             // ����� ��ப� � ॥���
      krtp->OPLATA   := 0              // ⨯ ������;᭠砫� 0, 1-�ਪ९��, 2-�訡��
      krtp->D_PRIK1  := ctod("")       // ��� �ਪ९�����
      //
      s1 := iif(ii==1, "", hb_eol())
      // 1 - ����⢨�
      s := "�"
      s1 += eval(blk,s)+";"
      // 2 - ��� ⨯� ����
      s := iif(wq->POLTP==3, "�", iif(wq->POLTP==2, "�", "�"))
      s1 += eval(blk,s)+";"
      // 3 - ���� � ����� ����
      s := iif(wq->POLTP==3, "", ;
               iif(wq->POLTP==2, alltrim(wq->NPOL),;
                   alltrim(wq->SPOL)+" � "+alltrim(wq->NPOL)))
      s1 += eval(blk,f_s_csv(s))+";"
      // 4 - ����� ����� ����� ���
      s := iif(wq->POLTP==3, alltrim(wq->NPOL), "")
      s1 += eval(blk,s)+";"
      // 5 - ������� �����客������ ���
      s1 += eval(blk,f_s_csv(alltrim(wq->FAM)))+";"
      // 6 - ��� �����客������ ���
      s1 += eval(blk,f_s_csv(alltrim(wq->IM)))+";"
      // 7 - ����⢮ �����客������ ���
      s1 += eval(blk,f_s_csv(alltrim(wq->OT)))+";"
      fl := .f.
      if empty(ldate_r := wq->DR)
        fl := .t. //�� ��������� ���� "��� ஦�����"
      elseif wq->DR >= sys_date
        fl := .t. //��� ஦����� ����� ᥣ����譥� ����
      elseif year(wq->DR) < 1900
        fl := .t. //��� ஦�����: "+full_date(kart->date_r)+" ( < 1900�.)
      endif
      if fl
        ldate_r := addmonth(sys_date,-18*12)
      endif
      // 8 - ��� ஦����� �����客������ ���
      s1 += eval(blk,dtos(ldate_r))+";"
      // 9 - ���� ஦����� �����客������ ���
      lmesto_r := ""
      if eq_any(kart_->vid_ud,3,14)
        if empty(kart_->mesto_r)
          lmesto_r := "���.������ࠤ"
        else
          lmesto_r := alltrim(del_spec_symbol(kart_->mesto_r))
        endif
      endif
      lmesto_r := charone(" ",CHARREPL("/;", lmesto_r, SPACE(2)))
      s1 += eval(blk,f_s_csv(lmesto_r))+";"
      //
      fl := ascan(menu_vidud,{|x| x[2] == kart_->vid_ud }) == 0
      if !fl
        if empty(kart_->nom_ud)
          fl := .t. //������ ���� ��������� ���� "����� 㤮�⮢�७�� ��筮��"
        elseif !ver_number(kart_->nom_ud)
          fl := .t. //���� "����� 㤮�⮢�७�� ��筮��" ������ ���� ��஢�
        elseif !val_ud_nom(2,kart_->vid_ud,kart_->nom_ud)
          fl := .t.
        endif
      endif
      if !fl .and. eq_any(kart_->vid_ud,1,3,14) .and. empty(kart_->ser_ud)
        fl := .t. //�� ��������� ���� "����� 㤮�⮢�७�� ��筮��"
      endif
      if !fl .and. !empty(kart_->ser_ud) .and. !val_ud_ser(2,kart_->vid_ud,kart_->ser_ud)
        fl := .t.
      endif
      if fl
        // 10 - ��� ���㬥��, 㤮�⮢����饣� ��筮���
        s1 += eval(blk,"")+";"
        // 11 - ����� ��� ��� � ����� ���㬥��, 㤮�⮢����饣� ��筮���.
        s1 += eval(blk,"")+";"
      else
        // 10 - ��� ���㬥��, 㤮�⮢����饣� ��筮���
        s1 += eval(blk,lstr(kart_->vid_ud))+";"
        // 11 - ����� ��� ��� � ����� ���㬥��, 㤮�⮢����饣� ��筮���.
        s := alltrim(kart_->ser_ud)+" � "+alltrim(kart_->nom_ud)
        s1 += eval(blk,f_s_csv(s))+";"
      endif
      // 12 - ��� �뤠� ���㬥��, 㤮�⮢����饣� ��筮���
      lkogdavyd := kart_->kogdavyd
      if !empty(kart_->kogdavyd) .and. !between(kart_->kogdavyd,kart->date_r,sys_date)
        if kart_->vid_ud == 3 // ᢨ�_�� � ஦�����
          lkogdavyd := kart->date_r
        else
          lkogdavyd := ctod("")
        endif
      endif
      s := iif(empty(lkogdavyd), "", dtos(lkogdavyd))
      s1 += eval(blk,s)+";"
      // 13 - ������������ �࣠��, �뤠�襣� ���㬥��
      s := alltrim(inieditspr(A__POPUPMENU,dir_server+"s_kemvyd",kart_->kemvyd))
      s1 += eval(blk,f_s_csv(s))+";"
      // 14 - ����� �����客������ ���
      if !empty(lsnils := kart->snils) .and. !val_snils(kart->snils,2)
        lsnils := ""
      endif
      s1 += eval(blk,alltrim(lsnils))+";"
      // 15 - �����䨪��� ��
      s1 += eval(blk,glob_mo[_MO_KOD_TFOMS])+";"
      // 16 - ���ᮡ �ਪ९�����
      s1 += eval(blk,lstr(krtp->S_PRIK))+";"
      // 17 - ��� �ਪ९����� (��१�ࢨ஢����� ����)
      s1 += eval(blk,"")+";"
      // 18 - ��� �ਪ९�����
      ld_prik := krtp->D_PRIK
      if !between(krtp->D_PRIK,wq->DR,sys_date)
        ld_prik := sys_date - 1
      endif
      s1 += eval(blk,dtos(ld_prik))+";"
      // 19 - ��� ��९�����
      s1 += eval(blk,"")+";"
      // 20 ��� ��
      s1 += eval(blk,f_s_csv(loidmo))+";"
      // 21 ��� ���ࠧ�������
      s := alltrim(otd->kod_podr)
      s1 += eval(blk,f_s_csv(s))+";"
      // 22 ����� ���⪠
      s := lstr(wq->uchast)
      s1 += eval(blk,s)+";"
      // 23 ����� ���
      s := p2->snils
      s1 += eval(blk,s)+";"
      // 24 ��⥣��� ���
      s := iif(p2->kateg==1,"1","2")
      s1 += eval(blk,s)
      //
      fwrite(fp,hb_OemToAnsi(s1))
    endif
    if ii % 3000 == 0
      dbUnLockAll()
      Commit
    endif
    select TMP
    skip
  enddo
  fclose(fp)
  select KRTR
  G_RLock(forever)
  krtr->KOL := ii
  select KRTF
  G_RLock(forever)
  krtf->KOL := ii
  krtf->TWORK2 := hour_min(seconds()) // �६� ����砭�� ��ࠡ�⪨
  close databases
  G_SUnLock(str_sem)
  rest_box(buf)
  if ii > 0 .and. hb_FileExists(n_file)
    chip_copy_zipXML(n_file,dir_server+dir_XML_MO,.t.)
    stat_msg("���� �ਪ९����� ᮧ���!") ; mybell(3,OK)
    keyboard chr(K_ESC)+chr(K_HOME)+chr(K_ENTER)
  else
    func_error(4,"�訡�� ᮧ����� 䠩�� "+n_file)
  endif
endif
return NIL

***** 11.10.15
Static Function f1_wq_prikreplenie(cFileProtokol,/*@*/is_err)
Local s
if p2->kateg != 1
  is_err := .t.
  strfile(space(5)+"!������! � ᯥ樠���� � �ࠢ�筨�� ���ᮭ��� ��⥣��� ������ ���� ����"+hb_eol(),cFileProtokol,.t.)
elseif empty(p2->snils)
  is_err := .t.
  strfile(space(5)+"!������! �� ������ ����� � ��� � �ࠢ�筨�� ���ᮭ���"+hb_eol(),cFileProtokol,.t.)
else
  s := space(80)
  if !val_snils(p2->snils,2,@s)
    is_err := .t.
    strfile(space(5)+"!������! "+s+" � ��� � �ࠢ�筨�� ���ᮭ���"+hb_eol(),cFileProtokol,.t.)
  endif
endif
if empty(p2->otd)
  is_err := .t.
  strfile(space(5)+"!������! �� ���⠢���� �⤥����� � ��� � �ࠢ�筨�� ���ᮭ���"+hb_eol(),cFileProtokol,.t.)
else
  select OTD
  goto (p2->otd)
  if empty(otd->kod_podr)
    is_err := .t.
    strfile(space(5)+'!������! � ��."'+alltrim(otd->name)+'" �� ���⠢��� ��� ���ࠧ�������'+hb_eol(),cFileProtokol,.t.)
  endif
endif
return NIL

***** 12.10.15 �������� ";" � ���� �� " " ��� ��ࠢ�� � 䠩�� CSV
Function f_s_csv(s)
Static c := ";"
if c $ s
  s := charrepl(c,s," ")
endif
return s

***** 20.11.15 ������� ������⢠ ��樥�⮢, �ਪ९���� �� �ᥬ ���⪮�� ��砬
Function prn_itogo_uch_vrach()
Local sh, HH := 60, name_file := "uchvrach"+stxt, arr_title
Local ii := 0, buf := save_maxrow(), i, j, k, fl, arr := ret_arr_uch_vrach()
mywait()
R_Use(dir_server+"mo_pers",,"P2")
index on snils to (cur_dir+"tmp_pers") for !empty(snils)
R_Use_base("kartotek")
go top
do while !eof()
  @ maxrow(),0 say str(++ii/kart->(lastrec())*100,6,2)+"%" color cColorWait
  if kart->kod > 0 .and. !(left(kart2->PC2,1)=='1') ;
             .and. kart2->mo_pr == glob_MO[_MO_KOD_TFOMS]  // �ਪ९�� � ���
    k := iif(count_years(kart->date_r,sys_date) < 18, 2, 1)
    if kart->uchast > 0
      fl := .f.
      for i := 1 to len(arr)
        for j := 1 to len(arr[i,5])
          if arr[i,5,j,1] == kart->uchast .and. eq_any(arr[i,5,j,2],0,k)
            fl := .t. ; exit
          endif
        next
        if fl ; exit ; endif
      next
      if !fl
        if (i := ascan(arr, {|x| x[5,1,1]==kart->uchast .and. x[5,1,2]==k })) == 0
          aadd(arr, {0,0,"",space(11),{{kart->uchast,k}},"",0,0,0}) ; i := len(arr)
          arr[i,3] := "�� ����஥� ���"
          arr[i,6] += lstr(kart->uchast) + {"(���.)","(���)"}[k]
        endif
      endif
      arr[i,7] ++
    endif
    if !empty(kart2->SNILS_VR)
      if (i := ascan(arr,{|x| x[4] == kart2->SNILS_VR})) == 0
        aadd(arr, {0,0,"",kart2->snils_vr,{{0,0}},"--",0,0,0}) ; i := len(arr)
        select P2
        find (kart2->snils_vr)
        if found()
          arr[i,1] := p2->kod
          arr[i,2] := p2->tab_nom
          arr[i,3] := rtrim(p2->fio)
        else
          arr[i,3] := "�� ��� ��� ����� "+transform(kart2->snils_vr,picture_pf)
        endif
      endif
      arr[i,8] ++
    endif
  endif
  select KART
  skip
enddo
use (dir_server+"kart_etk") new
index on str(kod_tf,10) to (cur_dir+"tmp_kart_etk")
R_Use(dir_server+"kart_et")
index on str(kod_tf,10) to (cur_dir+"tmp_kart_et") ;
      for mo_pr == glob_MO[_MO_KOD_TFOMS] .and. !empty(snils_vr) .and. !(kart_et->PC2=='1')
go top
do while !eof()
  select KART_ETK
  find (str(kart_et->kod_tf,10))
  if found() .and. kart_etk->kod_k > 0
    select KART
    goto (kart_etk->kod_k)
    if kart->kod > 0
      k := iif(count_years(kart->date_r,sys_date) < 18, 2, 1)
      if (i := ascan(arr,{|x| x[4] == kart_et->SNILS_VR})) == 0
        aadd(arr, {0,0,"",kart_et->snils_vr,{{0,0}},"--",0,0,0}) ; i := len(arr)
        select P2
        find (kart_et->snils_vr)
        if found()
          arr[i,1] := p2->kod
          arr[i,2] := p2->tab_nom
          arr[i,3] := rtrim(p2->fio)
        else
          arr[i,3] := "�� ��� ��� ����� "+transform(kart_et->snils_vr,picture_pf)
        endif
      endif
      arr[i,9] ++
    endif
  endif
  select KART_ET
  skip
enddo  
close databases
asort(arr,,,{|x,y| iif(x[5,1,1]==y[5,1,1], x[5,1,2]<y[5,1,2], x[5,1,1]<y[5,1,1]) })
rest_box(buf)
arr_title := {;
"�������������������������������������������������������������������������������",;
"���-���⠡.�� ��� ���⪮���� ���                     � �� ���⪠           ",;
"�������������������������������������������������������������������������������"}
fp := fcreate(name_file) ; tek_stroke := 0 ; n_list := 1
sh := len(arr_title[1])
add_string("")
add_string(center("������⢮ ��樥�⮢, �ਪ९���� � ���⪮�� ��砬",sh))
add_string("")
aeval(arr_title, {|x| add_string(x) } )
add_string(center("[ �� ᢥ����� ����� ]",sh))
for i := 1 to len(arr)
  if !empty(arr[i,8])
    if verify_FF(HH,.t.,sh)
      aeval(arr_title, {|x| add_string(x) } )
    endif
    add_string(put_val(arr[i,8],6)+put_val(arr[i,2],6)+" "+;
               padr(arr[i,3],43)+" "+arr[i,6])
  endif
next
if verify_FF(HH-3,.t.,sh)
  aeval(arr_title, {|x| add_string(x) } )
endif
add_string("")
add_string(center("[ �� ᢥ����� ����� + ����� PID ��樥�� ]",sh))
for i := 1 to len(arr)
  if !empty(arr[i,8])
    if verify_FF(HH,.t.,sh)
      aeval(arr_title, {|x| add_string(x) } )
    endif
    add_string(put_val(arr[i,9],6)+put_val(arr[i,2],6)+" "+;
               padr(arr[i,3],43)+" "+arr[i,6])
  endif
next
if verify_FF(HH-3,.t.,sh)
  aeval(arr_title, {|x| add_string(x) } )
endif
add_string("")
add_string(center("[ �� ����ࠬ ���⪮� � ����⥪� ]",sh))
for i := 1 to len(arr)
  if !empty(arr[i,7])
    if verify_FF(HH,.t.,sh)
      aeval(arr_title, {|x| add_string(x) } )
    endif
    add_string(put_val(arr[i,7],6)+put_val(arr[i,2],6)+" "+;
               padr(arr[i,3],43)+" "+arr[i,6])
  endif
next
fclose(fp)
viewtext(name_file,,,,.t.,,,2)
return NIL

***** 28.09.15 ������ ���ᨢ ���⪮��� ��祩
Function ret_arr_uch_vrach()
Local i, j, ar, arr := {}
R_Use(dir_server+"mo_pers",,"P2")
R_Use(dir_server+"mo_uchvr",,"UV")
go top
do while !eof()
  if between(uv->uch,1,99)
    if uv->vrach > 0
      f1_ret_arr_uch_vrach(arr,uv->vrach,0,uv->uch)
    else
      if uv->vrachv > 0
        f1_ret_arr_uch_vrach(arr,uv->vrachv,1,uv->uch)
      endif
      if uv->vrachd > 0
        f1_ret_arr_uch_vrach(arr,uv->vrachd,2,uv->uch)
      endif
    endif
  endif
  select UV
  skip
enddo
close databases
for i := 1 to len(arr)
  ar := aclone(arr[i,5])
  asort(ar,,,{|x,y| iif(x[1] == y[1], x[2] < y[2], x[1] < y[1]) })
  for j := 1 to len(ar)
    arr[i,6] += lstr(ar[j,1])
    if ar[j,2] > 0
      arr[i,6] += {"(���.)","(���)"}[ar[j,2]]
    endif
    arr[i,6] += ", "
  next
  arr[i,6] := left(arr[i,6],len(arr[i,6])-2)
  //my_debug(,print_array(arr[i]))
next
return arr

***** 28.09.15
Static Function f1_ret_arr_uch_vrach(arr,lkod,k,luch)
Local i
select P2
goto (lkod)
if (i := ascan(arr,{|x| x[1] == lkod })) == 0
  aadd(arr, {lkod,p2->tab_nom,rtrim(p2->fio),p2->snils,{},"",0,0,0}) ; i := len(arr)
endif
aadd(arr[i,5],{luch,k})
return NIL
