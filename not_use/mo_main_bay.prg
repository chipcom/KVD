** mo_main.prg - ������ �����
**
* �㭪樨 ��� plug-in'��
**
* my_mo_begin_task()
**
#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

external ust_printer, ErrorSys, ReadModal, like, flstr, prover_dbf, net_monitor, pr_view, ne_real
// ���� (।�� �ᯮ��㥬�) ������ ����᪠�� �� hrb-䠩��� (��� 㬥��襭�� �����)
DYNAMIC i_new_boln
DYNAMIC i_kol_del_zub
DYNAMIC phonegram_15_kz
DYNAMIC forma_792_MIAC
DYNAMIC f1forma_792_MIAC
DYNAMIC monitoring_vid_pom
DYNAMIC b_25_perinat_2

// 24.12.24
procedure main( ... )
  local r, s, is_create := .f., is_copy := .f., is_index := .f., is_ftp := .f.
  local a_parol, buf, is_local_version := .t.
  local verify_fio_polzovat := .t.
  local nameTask := StripPath( HB_ArgV(0) )
  local lQuiet := .f., i
  local sourceDB := '', work_dir := ''

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT('RU866')
  REQUEST HB_LANG_RU866
  HB_LANGSELECT('RU866')

  REQUEST DBFNTX
  RDDSETDEFAULT('DBFNTX')

  for each s in hb_AParams() // ������ �室��� ��ࠬ��஢
    s := lower(s)
    do case
      case s == '-create'
        is_create := .t.
      case s == '-copy'
        is_copy := .t.
      case s == '-index'
        is_index := .t.
      case s == '-ftp'
        is_ftp := .t.
      case hb_LeftEq( s, '--base_dir=' )
        sourceDB := SubStr( s, 11 + 1 )
        if right(sourceDB, 1) != hb_ps()
          sourceDB += hb_ps()
        endif
      case hb_LeftEq( s, '--work_dir=' )
        work_dir := SubStr( s, 11 + 1 )
        if right(work_dir, 1) != hb_ps()
          work_dir += hb_ps()
        endif
      // case s == '-quiet'
      //   lQuiet := .t.
    endcase
  next
  //
  do case
    case is_create .and. is_copy
      quit_app('����饭� �����६����� 㪠����� ���祩 ����᪠ -create � -copy!', lQuiet)
    case is_create .and. is_index
      quit_app('����饭� �����६����� 㪠����� ���祩 ����᪠ -create � -index!', lQuiet)
    case is_create .and. is_ftp
        quit_app('����饭� �����६����� 㪠����� ���祩 ����᪠ -create � -ftp!', lQuiet)
    case is_copy .and. is_index
      quit_app('����饭� �����६����� 㪠����� ���祩 ����᪠ -copy � -index!', lQuiet)
    case is_copy .and. is_ftp
      quit_app('����饭� �����६����� 㪠����� ���祩 ����᪠ -copy � -ftp!', lQuiet)
    endcase

  if is_copy .or. is_index .or. is_ftp
    lQuiet := .t.
  endif

  if ! empty(sourceDB) .and. ! hb_vfDirExists(sourceDB)
    quit_app('��⠫�� ���� ������ ' + sourceDB + ' �� �������!', lQuiet)
  endif

  if ! empty(work_dir) .and. empty(sourceDB) .and. ! hb_vfDirExists(work_dir)
    quit_app('����稩 ��⠫�� ���짮��⥫� ' + work_dir + ' �� ������� � �� 㪠���� ���� --base_dir!', lQuiet)
  elseif ! empty(work_dir) .and. empty(sourceDB) .and. hb_vfDirExists(work_dir) .and. ! hb_FileExists(work_dir + 'server.mem')
    quit_app('� ࠡ�祬 ��⠫��� ���짮��⥫� ' + work_dir + ' ��������� 䠩� server.mem!', lQuiet)
  elseif ! empty(work_dir) .and. ! empty(sourceDB) .and. ! hb_vfDirExists(work_dir)
    hb_vfDirMake(work_dir)
    DirChange(work_dir)
  elseif ! empty(work_dir) .and. ! empty(sourceDB) .and. hb_vfDirExists(work_dir)
    DirChange(work_dir)
  endif
  // �஢�ઠ �� ������ ����� �����, �᫨ "��" - ��室
  if IsExeRunning(nameTask)
    quit_app('�ணࠬ�� "' + upper(nameTask) + '" 㦥 ����饭�. ����� ��ன ����� ����饭!', lQuiet)
  endif

  //SET(_SET_EVENTMASK,INKEY_KEYBOARD)
  SET SCOREBOARD OFF
  SET EXACT ON
  SET DATE GERMAN
  SET WRAP ON
  SET CENTURY ON
  SET EXCLUSIVE ON
  SET DELETED ON
  setblink(.f.)
  READINSERT(.T.) // ०�� ।���஢���� �� 㬮�砭�� Insert
  KEYBOARD ''
  ksetnum(.t.)    // ������� NumLock
  SETCURSOR(0)
  SET COLOR TO
  SET(_SET_DELETED, .T.)
  SETCLEARB(' ')

  if is_index .and. empty(sourceDB)
    quit_app('��� ���� -index �� 㪠��� ���� -base_dir!', lQuiet)
  endif

  if is_copy .and. empty(sourceDB)
    quit_app('��� ���� -copy �� 㪠��� ���� -base_dir!', lQuiet)
  endif

  if is_ftp .and. empty(sourceDB)
    quit_app('��� ���� -ftp �� 㪠��� ���� -base_dir!', lQuiet)
  endif

  declare_public()
  if !empty(sourceDB)
    dir_server := sourceDB
  endif
  if !empty(work_dir)
    cur_dir := work_dir
  endif
  declare_public_2()

  checkAccessDirectory(dir_server, lQuiet)
  checkAccessDirectory(cur_dir, lQuiet)

  if is_index
    Private fl_open := .t.
    OutStd('��砫� ��२�����樨', hb_eol())
    for i := 1 to len(array_files_DB)
      index_base(array_files_DB[i], lQuiet)
    next

    use (dir_server + 'mo_ppadd') new
    pack
    use
  
    pereindex_263(lQuiet)
    copy_ENP(lQuiet)
    ochistka_RAK(lQuiet)
    // 㤠��� �६���� 䠩��
	  filedelete(cur_dir + 'tmp*.dbf')
	  filedelete(cur_dir + 'tmp*.ntx')

    quit_app('����砭�� ��२�����樨', lQuiet)
  endif

  SET KEY K_ALT_F3 TO calendar
  SET KEY K_ALT_F2 TO calc
  SET KEY K_ALT_X  TO f_end

  delete file ttt.ttt
  // is_local_version := f_first(is_create)

  if empty(dir_server)
    if hb_FileExists(cur_dir+ 'server.mem')
      ft_use(cur_dir + 'server.mem')
      dir_server := alltrim(ft_readln())
      ft_use()
      is_local_version := .f.
    else // ���� = ⥪�騩 ��⠫��
      dir_server := cur_dir
    endif
    if right(dir_server, 1) != cslash
      dir_server += cslash
    endif
  else
    if lower(alltrim(dir_server)) != lower(alltrim(cur_dir))
      is_local_version := .f.
    endif
  endif

  if !is_create .and. !hb_FileExists(dir_server + 'human' + sdbf)
    quit_app('�� �����㦥�� 䠩�� ���� ������! ������� � ��⥬���� ������������.', lQuiet)
  endif
  //

  // ���樠������ ���ᨢ� ��, ����� ���� �� (�� ����室�����)
  // r := init_mo(lQuiet)
  init_mo(lQuiet)

  if is_copy .or. is_ftp
    OutStd('��砫� १�ࢭ��� ����஢����', hb_eol())
    // if is_copy
      m_copy_DB(iif(is_copy, 3, 2), lQuiet, .f.) //, spath)
    // else
      // m_copy_DB(2, lQuiet, .f.) //, spath)
    // endif
    quit_app('����砭�� १�ࢭ��� ����஢����', lQuiet)
  endif

  // ���樠������ ��࠭�
  put_icon(__s_full_name() + full_name_version(), 'MAIN_ICON')
  set key K_F1 to f_help()
  hard_err('create')
  FillScreen(p_char_screen, p_color_screen) //FillScreen("�","N+/N")
  cur_year := STR(YEAR(sys_date), 4)
  new_dir = ''
  SETCOLOR(color1)

  r := main_up_screen()

  // ४�������� 䠩��� ����㯠 � ��⥬�
  Reconstruct_Security(is_local_version)

  // a_parol := inp_password(is_local_version,is_create)
  a_parol := inp_password_bay(is_local_version, is_create)

  checkFilesTFOMS()
  
  // ��ꥪ� �࣠������ � ���ன ࠡ�⠥�
  public hb_main_curOrg := TOrganizationDB():GetOrganization() 
  
  if ! hb_user_curUser:IsAdmin()  // tip_polzovat != TIP_ADM
    verify_fio_polzovat := .f.
  endif
  if !G_SOpen(sem_task, sem_vagno, fio_polzovat, p_name_comp)
    if type('verify_fio_polzovat') == 'L' .and. verify_fio_polzovat
      func_error('� ����� ������ ࠡ�⠥� ��㣮� ������ ��� 䠬����� "' + fio_polzovat + '"')
    else
      if !hb_user_curUser:IsAdmin()
        hb_Alert('� ����� ������ ��㣮� ����祩 �믮������ �⢥��⢥��� ०��. �஢���� ��⥬�� ������')
      else
        func_error('����� ����饭! � ����� ������ ��㣮� ����祩 �믮������ �⢥��⢥��� ०��.')
      endif
    endif
    if !hb_user_curUser:IsAdmin()
      f_end()
    endif
  endif
  //

  checkVersionInternet( r + 3, _version() )

  Public chm_help_code := 0

  Init_first() // ��砫쭠� ���樠������ �ணࠬ�� (��६�����, ���ᨢ��,...)

  Init_Program() // ���樠������ �ணࠬ�� (��६�����, ���ᨢ��,...)

  if ControlBases(1, _version()) // �᫨ ����室���
    if G_SLock1Task(sem_task, sem_vagno)  // ����� ����㯠 �ᥬ
      buf := savescreen()
      f_message({'���室 �� ����� ����� �ணࠬ�� ' + fs_version(_version()) + ' �� ' + _date_version()}, , , , 8)
      // �஢��� ४�������� ��
      Reconstruct_DB(is_local_version, is_create)
      // �஢��� ४�������� �� ���� ���ࠢ����� �� ��ᯨ⠫�����
      _263_init()
      // ��� ��砫� ࠡ��� _first_run() (�ࠫ � NOT_USED)
      pereindex() // ��易⥫쭮
      update_data_DB(_version())    // �஢��� ��������� � ���� �᫨ ����室���
      // ������� ���� ����� ���ᨨ
      ControlBases(3)
      if glob_mo[_MO_IS_UCH]
        //correct_polis_from_sptk()  // ���४�஢�� ����ᮢ �� ॥��஢ ����
        //dubl_zap_kod_tf()          // 㤠���� �㡫����� ����ᥩ � ����⥪�
      endif
      // ࠧ�襭�� ����㯠 �ᥬ
      G_SUnLock(sem_vagno)
      restscreen(buf)
    else
      n_message({'�� �����⨫� ����� ����� ����� ' + fs_version(_version()) + ' �� ' + _date_version(), ;
               '�ॡ���� ४�������� (� ��२�����஢����) ���� ������.', ;
               '�� � ����� ������ ࠡ���� ��㣨� �����.', ;
               '����室���, �⮡� �� ���짮��⥫� ��諨 �� �����.'}, ;
              {'', '��� �����襭�� ࠡ��� ������ ���� �������'}, ;
              cColorSt2Msg,cColorStMsg, , , 'G+/R')
      f_end(.f.)
    endif
  endif

  f_main(r, is_local_version, a_parol)

  f_end()

  return

** 17.05.21
Function f_main(r0, is_local_version, a_parol)
  Static arr1 := {;
    {"���������� �����������"            ,X_REGIST,,.t.,"������������"},;
    {"���� ����� ��樮���"           ,X_PPOKOJ,,.t.,"�������� �����"},;
    {"��易⥫쭮� ����樭᪮� ���客����",X_OMS   ,,.t.,"���"},;
    {"���� ���ࠢ����� �� ��ᯨ⠫�����"  ,X_263   ,,.F.,"��������������"},;
    {"����� ��㣨"                      ,X_PLATN ,,.t.,"������� ������"},;
    {"��⮯����᪨� ��㣨 � �⮬�⮫����",X_ORTO  ,,.t.,"���������"},;
    {"���� ����樭᪮� �࣠����樨"       ,X_KASSA ,,.t.,"�����"};
  }
//  {"��� ����樭᪮� �࣠����樨"         ,X_KEK   ,,.F.,"���"};

  Static arr2 := {;
    {"������஢���� �ࠢ�筨���"         ,X_SPRAV ,,.t.},;
    {"��ࢨ�� � ����ன��"                 ,X_SERVIS,,.t.},;
    {"����ࢭ�� ����஢���� ���� ������"   ,X_COPY  ,,.t.},;
    {"��२�����஢���� ���� ������"      ,X_INDEX ,,.t.};
  }
  Local i, lens := 0, r, c, oldTfoms, arr, ar, k, fl_exit := .t.
  local buf

  PUBLIC array_tasks := {}, sem_vagno_task[24]
  afill(sem_vagno_task,"")
  for i := 1 to len(arr1)
    aadd(array_tasks,arr1[i])
    sem_vagno_task[arr1[i,2]] := '����� ०�� � ����� "'+arr1[i,5]+'"'
  next

  if glob_mo[_MO_KOD_TFOMS] == kod_VOUNC
    aadd(array_tasks, {"����� - �࠭ᯫ���஢����",X_MO,"TABLET_ICON",.T.})
  endif

  for i := 1 to len(arr2)
    aadd(array_tasks,arr2[i])
  next
  //
  arr := {}
  for i := 1 to len(array_tasks)
    if (k := array_tasks[i,2]) < 10  // ��� �����
      array_tasks[i,4] := (substr(glob_mo[_MO_PROD],k,1)=='1')
      if array_tasks[i,4]
        fl_exit := .f.
      endif
    endif
    // ���� ���ࠢ����� �� ��ᯨ⠫�����
    if k == X_263 .and. (is_napr_pol .or. is_napr_stac)
      array_tasks[i,4] := .t.
      fl_exit := .f.
    endif
    if is_local_version
      if array_tasks[i,4]
        aadd(arr,array_tasks[i])
        lens := max(lens,len(array_tasks[i,1]))
      endif
    else
      if array_tasks[i,4] .and. hb_user_curUser:IsAllowedTask( i )
        aadd(arr,array_tasks[i])
        lens := max(lens,len(array_tasks[i,1]))
      endif
    endif
  next
  Public glob_task, blk_ekran, g_arr_stand := {},;
       main_menu, main_message, first_menu,;
       first_message, func_menu, cmain_menu
  if fl_exit
    func_error(4,"��� ࠧ�襭�� �� ࠡ��� �� � ����� �����!")
  else
    // �뢥�� ���孨� ��ப� �������� ��࠭�
    r0 := main_up_screen()
    // �뢥�� 業�ࠫ�� ��ப� �������� ��࠭�
    main_center_screen(r0,a_parol)
    if hb_user_curUser:IsAdmin()
      find_unfinished_reestr_sp_tk(.f.,.t.)
      find_time_limit_human_reestr_sp_tk()
      find_unfinished_R01()
      find_unfinished_R11()
    endif
    //
    r := int((maxrow()-r0-len(arr))/2)-1
    c := int((maxcol()+1-lens)/2)-1
    ar := GetIniSect(tmp_ini,"task")
    k := i := int(val(a2default(ar,"current_task",lstr(X_OMS))))
    do while .t.
      if (i := popup_2array(arr,r+r0,c,i,,,"�롮� �����","B+/W","N+/W,W+/N*")) == 0
        exit
      endif
      oldTfoms := glob_mo[_MO_KOD_TFOMS]
      buf := savescreen()
      k := i
      f1main(i)
      restscreen(buf)
      reRead_glob_MO()
      if !(oldTfoms == glob_mo[_MO_KOD_TFOMS])
        // �뢥�� ���孨� ��ப� �������� ��࠭�
        r0 := main_up_screen()
        // �뢥�� 業�ࠫ�� ��ப� �������� ��࠭�
        main_center_screen(r0)
      endif
      change_sys_date() // ������� ��⥬��� ����
      put_icon(__s_full_name() + full_name_version(), 'MAIN_ICON') // ��ॢ뢥�� ��������� ����
      @ r0,0 say full_date(sys_date) color "W+/N" // ��ॢ뢥�� ����
      @ r0,maxcol()-4 say hour_min(seconds()) color "W+/N" // ��ॢ뢥�� �६�
    enddo
    SetIniSect(tmp_ini,"task",{{"current_task",lstr(k)}})
  endif
  return NIL

// �뢥�� ���孨� ��ப� �������� ��࠭�
Function main_up_screen()
  Local i, k, s, arr[2]

  FillScreen(p_char_screen,p_color_screen) //FillScreen("�","N+/N")
  s := "��� "+iif(glob_mo[_MO_IS_MAIN],"��","���ᮡ������� ���ࠧ�������")+;
     ", ��᢮���� �����: "+glob_mo[_MO_KOD_TFOMS]+;
     " (॥��஢� � "+glob_mo[_MO_KOD_FFOMS]+")"
  @ 0,0 say padc(s,maxcol()+1) color "W+/N"
  s := iif(glob_mo[_MO_IS_MAIN],"","���ᮡ������ ���ࠧ�������: ")+;
     glob_mo[_MO_FULL_NAME]
  k := perenos(arr,s,maxcol()+1)
  for i := 1 to k
    @ i,0 say padc(alltrim(arr[i]),maxcol()+1) color "GR+/N"
  next
  i := get_uroven()
  if between(i,1,3)
    s := "�஢��� 業 �� ����樭᪨� ��㣨: "+lstr(i)
  else
    s := "�������㠫�� ���� �� ����樭᪨� ��㣨"
  endif
  @ k+1,0 say space(maxcol()+1) color "G+/N"
  @ k+1,0 say full_date(sys_date) color "W+/N"
  @ k+1,maxcol()-4 say hour_min(seconds()) color "W+/N"
  return k+1

** �뢥�� 業�ࠫ�� ��ப� �������� ��࠭�
Function main_center_screen(r0,a_parol)
  Static nLen := 11
  Static arr_name := {"�����", "������", "���", "���������",;
                    "���������", "梨�", "த���� �ࠢ��",;
                    "����஦����� � ������ ���ᮩ ⥫�",;
                    "��⬠", "������","����ॠ��"}
  Local s, i, c, k, t_arr, r1, buf, mst := ""

  g_arr_stand := {}
  if valtype(glob_mo[_MO_STANDART]) == "A"
    for k := 1 to len(glob_mo[_MO_STANDART])
      t_arr := {glob_mo[_MO_STANDART,k,1],{}}
      mst := padr(glob_mo[_MO_STANDART,k,2],nLen)
      for i := 1 to nLen
        c := substr(mst,i,1)
        if c == "1"
          aadd(t_arr[2],i)
        endif
      next
      aadd(g_arr_stand,aclone(t_arr))
    next
  endif
  if .t.//empty(mst)
    if valtype(a_parol) == "A" .and. (k := len(a_parol)) > 0
      r1 := r0+int((maxrow()-r0-k)/2)-1
      n_message(a_parol,,"W+/W*","R/W*",r1,,"N+/W*")
    endif
  else
    s := "���������᪨� ���, �� ����� �� ������ � �믮������ �⠭���⮢:"
    for i := 1 to nLen
      c := substr(mst,i,1)
      if eq_any(c,"1","2")
        s += " "+arr_name[i]
        if c == "2"
          s += "[*]"
        endif
        s += ","
      endif
    next
    s := left(s,len(s)-1)
    t_arr := array(2)
    k := perenos(t_arr,s,64)
    r1 := r0+int((maxrow()-r0-k)/2)-1
    if (k := len(a_parol)) > 0
      if r1-r0 < k+4
        r1 := r0+k+4
      endif
      buf := save_box(r1-k-4,0,r1-1,maxcol())
      f_message(a_parol,,"W+/W*","R/W*",r1-k-3)
    endif
    n_message(t_arr,,"W/W","N/W",r1,,"N+/W")
    if buf != NIL
      rest_box(buf)
    endif
  endif
  return NIL


**
Function m_help()
  Local tmp_help, pt

  tmp_help := chm_help_code
  chm_help_code := 100  // ?????
  f_help()
  chm_help_code := tmp_help
  return NIL

** 02.11.15
Function hard_err(p)
// k = 1 - �஢�ઠ ��᪠ �� ����稥 �६������ 䠩�� hard_err.meh
//         �, �᫨ �� ����, �뢮� ⥪�� � ����室����� ��२�����஢����;
//         ᮧ����� �६������ 䠩�� hard_err.meh "CREATE"
// k = 2 - 㤠����� �६������ 䠩�� hard_err.meh "DELETE"
  Local k := 3, arr := {}

  if valtype(p) == "N"
    k := p
  elseif valtype(p) == "C"
    p := upper(p)
    do case
      case p == "CREATE"
        k := 1
      case p == "DELETE"
        k := 2
    endcase
  endif
  do case
    case k == 1
      if file("hard_err.meh")
        FillScreen(p_char_screen,p_color_screen)
        aadd(arr,"��᫥���� ࠧ �� ��室� �� ����� �� ᡮ� �� ��⠭��.")
        aadd(arr,". . .")
        aadd(arr,"���⮬� ��� �����⥫쭮 ४��������� �믮�����")
        aadd(arr,'०�� "��२�����஢����", �.�. ������ ����⭮, ��')
        aadd(arr,"������� ������� 䠩�� �뫨 �ᯮ�祭� ��� ࠧ��襭�.")
        keyboard ""
        f_message(arr,,color1,color8,,,color1)
        if f_alert({padc("�롥�� ����⢨�",60,".")},;
               {" ��室 �� ����� "," �த������� ࠡ��� "},;
               1,"W+/N","N+/N",20,,"W+/N,N/BG" ) != 2
          SET COLOR TO
          SET CURSOR ON
          CLS
          QUIT
        endif
        FillScreen(p_char_screen,p_color_screen)
      endif
      strfile("hard_error","hard_err.meh")
    case k == 2
      delete file hard_err.meh
  endcase
  return NIL

** 14.07.22
FUNCTION f_end(yes_copy, lQuiet)
  Static group_ini := 'RAB_MESTO'
  Local i, spath := '', bSaveHandler := ERRORBLOCK( {|x| BREAK(x)} )

  BEGIN SEQUENCE
    write_rest_pp() // ������� ������ᠭ�� ���ਨ �������� �� ��񬭮�� �����
    CLOSE ALL
    DEFAULT yes_copy TO .t.
    DEFAULT lQuiet TO .f.
    if yes_copy
      i := GetIniVar(tmp_ini, {{group_ini, 'base_copy', '1'}, ;
                             {group_ini, 'path_copy', ''}} )
      if i[1] != NIL .and. i[1] == '1' .and. G_SLock1Task(sem_task, sem_vagno)
        if len(i) > 1 .and. i[2] != NIL .and. !empty(i[2])
          spath := i[2]
        endif
        // m_copy_DB_from_end(.f., spath) // १�ࢭ�� ����஢����
        m_copy_DB(3, lQuiet, .f., spath)
        G_SUnLock(sem_vagno) // ࠧ�襭�� ����㯠 �ᥬ
      endif
    endif
  RECOVER USING error
    //
  END
  //
  BEGIN SEQUENCE
    G_SClose(sem_task) // 㤠���� �� ᥬ���� ��� ������ �����
  RECOVER USING error
    //
  END
  ERRORBLOCK(bSaveHandler)
  //
  hard_err('delete')
  if __mvExist( 'cur_dir' )
	  filedelete(cur_dir + 'tmp*.dbf')
	  filedelete(cur_dir + 'tmp*.ntx')
	  filedelete(_tmp_dir1() + '*.*')
	  if hb_DirExists(cur_dir + _tmp_dir()) .and. hb_DirDelete(cur_dir + _tmp_dir()) != 0
		  //func_error(4, "�� ���� 㤠���� ��⠫�� "'+'cur_dir'+'_tmp_dir())
	  endif
	  filedelete(_tmp2dir1() + '*.*')
	  if hb_DirExists(cur_dir + _tmp2dir()) .and. hb_DirDelete(cur_dir + _tmp2dir()) != 0
		  //func_error(4, "�� ���� 㤠���� ��⠫�� " + cur_dir + _tmp2dir())
	  endif
  endif
  // 㤠��� 䠩�� ���⮢ � �ଠ� '*.HTML' �� �६����� ��४�ਨ
  filedelete( HB_DirTemp() + '*.HTML')
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X  TO
  SET COLOR TO
  SET CURSOR ON
  CLS
  QUIT
  RETURN NIL

** 03.12.13
Function f_err_sem_vagno_task(n_Task)
  return func_error(4, '� ����� "' + array_tasks[ind_task(n_Task), 5] + ;
                    '" �믮������ ������������� ������. ����� �६���� ������!')

** 03.12.13
Function mo_Lock_Task(n_Task)
  Local i, fl := .t., n := 0

  DEFAULT n_Task TO glob_task
  if glob_task == n_Task // �᫨ ��뢠���� �� ����� n_Task,
    ++n                  // � ���ᨬ� 1 ���짮��⥫�
  endif
  i := ind_task(n_Task)
  if !G_SValueNLock(f_name_task(n_Task), n, sem_vagno_task[n_Task])
    fl := func_error('� ����� "' + array_tasks[i, 5] + '" ࠡ���� ���짮��⥫�. ������ �६���� ����饭�!')
  endif
  return fl

** 03.12.13
Function mo_UnLock_Task(n_Task)
  return G_SUnLock(sem_vagno_task[n_Task])

** ������ ��� ����� �� ��஢��� ����
Function f_name_task(n_Task)
  Local it, s

  DEFAULT n_Task TO glob_task
  s := lstr(n_Task)
  if (it := ascan(array_tasks, {|x| x[2] == n_Task})) > 0
    s := array_tasks[it, 1]
  endif
  return s

** �஢����, ����㯭� �� ������� �� �����⭠� �����
Function is_task(n_Task)
  Local it

  if !(type('array_tasks') == 'A') // � ��砫� �����  ��� �� ��।��� ���ᨢ
    return .f.
  endif
  DEFAULT n_Task TO glob_task
  if (it := ascan(array_tasks, {|x| x[2] == n_Task})) == 0
    return .f.
  endif
  return array_tasks[it, 4]

** ������ ������ ���ᨢ� �����⭮� �����
Function ind_task(n_Task)
  Local it

  DEFAULT n_Task TO glob_task
  if (it := ascan(array_tasks, {|x| x[2] == n_Task})) == 0
    it := 3 // ���
  endif
  return it

** 14.06.21
Function find_unfinished_reestr_sp_tk(is_oper, is_count)
  Static max_rec := 9900000 // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Local fl := .t., s, buf := save_maxrow(), arr, rech := 0, af := {}, bSaveHandler

  DEFAULT is_oper TO .t., is_count TO .t.

  mywait('��������, �஢��塞 �����襭����� ���ଠ樮����� ������ ॥��ࠬ� �� � �� � �����...')

  bSaveHandler := ERRORBLOCK( {|x| BREAK(x)} )
  BEGIN SEQUENCE
    if is_count
      R_Use(dir_server + 'human', , 'HUMAN')
      rech := lastrec()
      Use
    endif
    R_Use(dir_server + "mo_rees", , "REES")
    R_Use(dir_server + "mo_xml", , "MO_XML")
    set relation to REESTR into REES
    index on FNAME to (cur_dir + "tmp_xml") for TIP_IN == _XML_FILE_SP .and. empty(TWORK2)
    go top
    do while !eof()
      aadd(af, {rtrim(mo_xml->FNAME), lstr(rees->NSCHET)})
      skip
    enddo
    close databases
    rest_box(buf)
    if (fl := (len(af) > 0 .or. rech > max_rec))
      if rech > max_rec
        arr := {"�� ���௠��� ����� ���� ������ � ���", ;
              "��⠫��� ����������� �������� " + lstr(10000000 - rech) + " ���⮢ ����."}
      endif
      if len(af) > 0
        s := "�� �����襭� �⥭�� "
        if len(af) == 1
          s += "॥��� �� � �� " + af[1, 1] + " (॥��� " + af[1, 2] + ")"
        else
          s += lstr(len(af)) + " ॥��஢ �� � ��"
        endif
        arr := {"", s}
      endif
      if is_oper
        aadd(arr, "")
        aadd(arr, "������ ����饭�!")
      endif
      n_message(arr, {"", "������� � ࠧࠡ��稪��"}, "GR+/R", "W+/R", , , "G+/R")
    endif
  RECOVER USING error
    close databases
    rest_box(buf)
  END
  ERRORBLOCK(bSaveHandler)
  return fl

** 10.06.21 �஢����, ���� �� ����᫠��� ����祭�� ����� ����
Function find_time_limit_human_reestr_sp_tk()
  Local buf := savescreen(), arr[10, 2], i, mas_pmt, r, c, n, d := sys_date - 23
  Local fl := .f., bSaveHandler := ERRORBLOCK( {|x| BREAK(x)} )

  mywait('��������, �஢��塞 ����祭�� ��砨 (����ࠢ����� � �����)...')
  BEGIN SEQUENCE
    dbcreate(cur_dir + "tmp_tl", {{"kod_h", "N", 8, 0}, ;
                             {"kod_xml", "N", 6, 0}, ;
                             {"dni","N", 2, 0}})
    use (cur_dir + "tmp_tl") new
    R_Use(dir_server + "human_", , "HUMAN_")
    R_Use(dir_server + "human", , "HUMAN")
    set relation to recno() into HUMAN_
    R_Use(dir_server + "mo_refr", dir_server + "mo_refr", "REFR")
    R_Use(dir_server + "mo_xml", , "MO_XML")
    R_Use(dir_server + "mo_rees", , "REES")
    set relation to KOD_XML into MO_XML
    R_Use(dir_server + "mo_rhum", , "RHUM")
    set relation to reestr into REES
    index on str(reestr, 6) to (cur_dir + "tmp_rhum") for OPLATA == 2 .and. d < rees->DSCHET
    go top
    do while !eof()
      if (r := sys_date - rees->DSCHET) <= 0
        r := 1
      endif
      human->(dbGoto(rhum->kod_hum))
      // �஢�ਬ, �� ����� �� ��� � ��㣮� ॥��� (��� ��稩 ����)
      if emptyall(human->schet, human_->REESTR) .and. rhum->REES_ZAP == human_->REES_ZAP
        select REFR
        find (str(1, 1) + str(mo_xml->REESTR, 6) + str(1, 1) + str(rhum->kod_hum, 8))
        do while refr->TIPD == 1 .and. refr->KODD == mo_xml->REESTR .and. ;
               refr->TIPZ == 1 .and. refr->KODZ == rhum->kod_hum  .and. !eof()
          if !eq_any(refr->REFREASON, 50, 57)
            select TMP_TL
            append blank
            tmp_tl->kod_h   := rhum->kod_hum
            tmp_tl->kod_xml := mo_xml->kod
            tmp_tl->dni     := r
            if lastrec() % 1000 == 0
              Commit
            endif
          endif
          select REFR
          skip
        enddo
      endif
      select RHUM
      skip
    enddo
  RECOVER USING error
    fl := .t.
  END
  ERRORBLOCK(bSaveHandler)
  if fl
    close databases
    restscreen(buf)
    return func_error(4, "������⭠� �訡��. �믮���� ��२�����஢���� � �������� ���")
  endif
  select TMP_TL
  if lastrec() > 0
    afillall(arr,0)
    i := 0
    index on dni to (cur_dir + "tmp_tl") unique
    go top
    if tmp_tl->dni <= 10 // �� ����� 10 ���� ����祭�, ���� �� �뢮���
      do while !eof()
        ++i
        if i == 10
          arr[i, 1] := -1
          exit
        endif
        arr[i, 1] := tmp_tl->dni
        skip
      enddo
      set index to
      go top
      do while !eof()
        if (i := ascan(arr, {|x| x[1] == tmp_tl->dni})) == 0
          i := 10
        endif
        arr[i, 2] ++
        skip
      enddo
      close databases
      mas_pmt := {}
      n := 0
      for i := 1 to 10
        if emptyany(arr[i, 1], arr[i, 2])
          exit
        elseif arr[i, 1] == -1
          aadd(mas_pmt, lstr(arr[i, 2]) + " 祫. - ����祭� ����� " + lstr(arr[9, 1]) + " ��.")
        else
          aadd(mas_pmt, lstr(arr[i, 2]) + " 祫. - ����祭� " + lstr(arr[i, 1]) + " ��.")
        endif
        n := max(n, len(atail(mas_pmt)))
      next
      if len(mas_pmt) > 0
        i := 1
        r := maxrow() - len(mas_pmt) - 4
        c := int((80 - n - 3) / 2)
        status_key("^<Esc>^ ��室 �� ०��� � �室 � ������  ^<Enter>^ ��ᬮ�� ����祭��� ��砥�")
        str_center(r - 1, "�����㦥�� ����祭�� ��砨:", "W+/N*")
        do while (i := popup_prompt(r, c, i, mas_pmt)) > 0
          f1find_time_limit_human_reestr_sp_tk(i, arr)
        enddo
      endif
    endif
  endif
  close databases
  restscreen(buf)
  return NIL

** 29.06.22
Function f1find_time_limit_human_reestr_sp_tk(i, arr)
  Local n_file := cur_dir + 'time_lim' + stxt, sh := 80, HH := 60

  fp := fcreate(n_file) ; n_list := 1 ; tek_stroke := 0
  add_string('')
  add_string(center('���᮪ ��砥�, �������� � �訡��� � ��� �� ��᫠���� � �����', sh))
  if i == 10
    add_string(center('(����祭� ����� ' + lstr(arr[9, 1]) + ' ��.)', sh))
  else
    add_string(center('(����祭� ' + lstr(arr[i, 1]) + ' ��.)', sh))
  endif
  add_string(center('�� ���ﭨ� �� ' + full_date(sys_date) + ' ' + hour_min(seconds()), sh))
  add_string('')
  R_Use(dir_server + 'mo_otd', , 'OTD')
  R_Use(dir_server + 'human_', , 'HUMAN_')
  R_Use(dir_server + 'human', , 'HUMAN')
  set relation to recno() into HUMAN_, to otd into OTD
  use (cur_dir + 'tmp_tl') new
  set relation to kod_h into HUMAN
  if i == 10
    index on upper(human->fio) to (cur_dir + 'tmp_tl') for dni > arr[9, 1]
  else
    index on upper(human->fio) to (cur_dir + 'tmp_tl') for dni == arr[i, 1]
  endif
  i := 0
  go top
  do while !eof()
    verify_FF(HH, .t., sh)
    add_string(lstr(++i) + '. ' + alltrim(human->fio) + ', ' + full_date(human->date_r) + ;
             iif(empty(otd->SHORT_NAME), '', ' [' + alltrim(otd->SHORT_NAME) + ']') + ;
             ' ' + date_8(human->n_data) + '-' + date_8(human->k_data))
    select TMP_TL
    skip
  enddo
  close databases
  fclose(fp)
  viewtext(n_file, , , , .f., , , 2)
  return NIL

**
Function my_mo_begin_task()
  Local fl := .t.

  if glob_mo[_MO_KOD_TFOMS] == kod_VOUNC
    fl := vounc_begin_task()
  endif
  return fl

** 26.06.22
procedure quit_app(sError, lQuiet)

  default lQuiet to .f.
  OutStd(sError, hb_eol())
  if ! lQuiet
    hb_Alert(sError)
  endif
  SET COLOR TO
  SET CURSOR ON
  QUIT
  return