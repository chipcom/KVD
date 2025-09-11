#include "common.ch"
#include "set.ch"
#include "inkey.ch"
#include "function.ch"
#include "edit_spr.ch"
#include "chip_mo.ch"

// 11.09.25
Function f1main( n_Task )
  Local it, s, k, fl := .t., cNameIcon

  If ( it := AScan( array_tasks, {| x| x[ 2 ] == n_Task } ) ) == 0
    Return func_error( "�訡�� � �맮�� �����" )
  Endif
  cNameIcon := iif( array_tasks[ it, 3 ] == NIL, "MAIN_ICON", array_tasks[ it, 3 ] )
  glob_task := n_Task
  sys_date := Date()
  c4sys_date := dtoc4( sys_date )
  blk_ekran := {|| DevPos( MaxRow() -2, MaxCol() -Len( dir_server ) ), ;
    DevOut( Upper( dir_server ), "W+/N*" ) }
  main_menu := {}
  main_message := {}
  first_menu := {}
  first_message := {}
  func_menu := {}
  cmain_menu := {}
  put_icon( array_tasks[ it, 1 ] + ' ' + short_name_version(), cNameIcon )
  SetColor( color1 )
  fillscreen( p_char_screen, p_color_screen )
  Do Case
  Case glob_task == X_REGIST //
    fl := begin_task_regist()
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~���������� " )
    AAdd( main_message, "���������� ���㫠�୮-����������᪮�� ��०�����" )
    AAdd( first_menu, { "~������஢����", ;
      "~����������", 0, ;
      "~��������", ;
      "�㡫����騥�� ~�����", 0;
      } )
    AAdd( first_message, { ;
      "������஢���� ���ଠ樨 �� ����窨 ���쭮�� � ����� ���⪠ ���", ;
      "���������� � ����⥪� ���ଠ樨 � ���쭮�", ;
      "�������� ����窨 ���쭮�� �� ����⥪�", ;
      "���� � 㤠����� �㡫�������� ����ᥩ � ����⥪�";
      } )
    AAdd( func_menu, { "regi_kart()", ;
      "append_kart()", ;
      "view_kart(2)", ;
      "dubl_zap()";
      } )
    If glob_mo()[ _MO_IS_UCH ]
      AAdd( first_menu[ 1 ], "�ਪ९�񭭮� ~��ᥫ����" )
      AAdd( first_message[ 1 ], "����� � �ਪ९��� ��ᥫ�����" )
      AAdd( func_menu[ 1 ], "pripisnoe_naselenie()" )
    Endif
    AAdd( first_menu[ 1 ], "~��ࠢ�� ���" )
    AAdd( first_message[ 1 ], "���� � �ᯥ�⪠ �ࠢ�� � �⮨���� ��������� ����樭᪮� ����� � ��� ���" )
    AAdd( func_menu[ 1 ], "f_spravka_OMS()" )
    //
    AAdd( cmain_menu, 34 )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ�� / ����� ����⨪� �� ��樥�⠬" )
    AAdd( first_menu, { "����⨪� �� �ਥ~���", ;
      "���ଠ�� �� ~����⥪�", ;
      "~�������ਠ��� ����";
      } )
    AAdd( first_message, { ;
      "����⨪� �� ��ࢨ�� ��祡�� �ਥ���", ;
      "��ᬮ�� / ����� ᯨ᪮� �� ��⥣���, ��������, ࠩ����, ���⪠�,...", ;
      "�������ਠ��� ���� � ����⥪�";
      } )
    AAdd( func_menu, { "regi_stat()", ;
      "prn_kartoteka()", ;
      "ne_real()" ;
      } )

    // if ( ! isnil( edi_FindPath( PLUGINIFILE ) ) ) .and. ( control_podrazdel_ini( edi_FindPath( PLUGINIFILE ) ) )
    //   AAdd( first_menu[ 4 ], "�������⥫�� ����������" )
    //   AAdd( first_message[ 4 ], "�������⥫�� ����������" )
    //   AAdd( func_menu[ 4 ], "Plugins()" )
    // endif
    //
    AAdd( cmain_menu, 51 )
    AAdd( main_menu, " ~��ࠢ�筨�� " )
    AAdd( main_message, "������� �ࠢ�筨���" )
    AAdd( first_menu, { "��ࢨ�� ~�ਥ��", 0, ;
      "~����ன�� (㬮�砭��)";
      } )
    AAdd( first_message, { ;  // �ࠢ�筨��
    "������஢���� �ࠢ�筨�� �� ��ࢨ�� ��祡�� �ਥ���", ;
      "����ன�� ���祭�� �� 㬮�砭��";
      } )
    AAdd( func_menu, { "edit_priem()", ;
      "regi_nastr(2)";
      } )
    If is_r_mu  // ॣ���� �죮⭨���
      ins_array( main_menu, 2, " ~�죮⭨�� " )
      ins_array( main_message, 2, "���� 祫����� � 䥤�ࠫ쭮� ॣ���� �죮⭨���" )
      ins_array( cmain_menu, 2, 19 )
      ins_array( first_menu, 2, ;
        { "~����", "~�������ਠ��� ����", 0, '"~���" �죮⭨��' } )
      ins_array( first_message, 2, ;
        { "���� 祫����� � ॣ���� �죮⭨���, ����� ���.����� �� �ଥ 025/�-04", ;
        "�������ਠ��� ���� �� ॣ����� �죮⭨���", ;
        "������� ���ଠ�� �� ��襬� ���⨭����� �� 䥤�ࠫ쭮�� ॣ���� �죮⭨���" } )
      ins_array( func_menu, 2, { "r_mu_human()", "r_mu_poisk()", "r_mu_svod()" } )
    Endif
  Case glob_task == X_PPOKOJ  //
    fl := begin_task_ppokoj()
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~���� ����� " )
    AAdd( main_message, "���� ������ � ��񬭮� ����� ��樮���" )
    AAdd( first_menu, { "~����������", ;
      "~������஢����", 0, ;
      "� ��㣮� ~�⤥�����", 0, ;
      "~��������" } )
    AAdd( first_message, { ;
      "���������� ���ਨ �������", ;
      "������஢���� ���ਨ ������� � ����� ����樭᪮� � ���.�����", ;
      "��ॢ�� ���쭮�� �� ������ �⤥����� � ��㣮�", ;
      "�������� ���ਨ �������";
      } )
    AAdd( func_menu, { "add_ppokoj()", ;
      "edit_ppokoj()", ;
      "ppokoj_perevod()", ;
      "del_ppokoj()" } )
    AAdd( cmain_menu, 34 )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ�� / ����� ����⨪� �� �����" )
    AAdd( first_menu, { "~��ୠ� ॣ����樨", ;
      "��ୠ� �� ~������", 0, ;
      "~������� ���ଠ��", 0, ;
      "~��ॢ�� �/� �⤥����ﬨ", 0, ;
      "���� ~�訡��" } )
    AAdd( first_message, { ;
      "��ᬮ��/����� ��ୠ�� ॣ����樨 ��樮����� ������", ;
      "��ᬮ��/����� ��ୠ�� ॣ����樨 ��樮����� ������ �� ������", ;
      "������ ������⢠ �ਭ���� ������ � ࠧ������ �� �⤥�����", ;
      "����祭�� ���ଠ樨 � ��ॢ��� ����� �⤥����ﬨ", ;
      "���� �訡�� �����";
      } )
    AAdd( func_menu, { "pr_gurnal_pp()", ;
      "z_gurnal_pp()", ;
      "pr_svod_pp()", ;
      "pr_perevod_pp()", ;
      "pr_error_pp()" } )
    AAdd( cmain_menu, 51 )
    AAdd( main_menu, " ~��ࠢ�筨�� " )
    AAdd( main_message, "������� �ࠢ�筨���" )
    AAdd( first_menu, { "~�⮫�", ;
      "~����ன��" } )
    AAdd( first_message, { ;
      "����� � �ࠢ�筨��� �⮫��", ;
      "����ன�� ���祭�� �� 㬮�砭��";
      } )
    AAdd( func_menu, { "f_pp_stol()", ;
      "pp_nastr()" } )
  Case glob_task == X_OMS  //
    fl := begin_task_oms()
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~��� " )
    AAdd( main_message, "���� ������ �� ��易⥫쭮�� ����樭᪮�� ���客����" )
    AAdd( first_menu, { "~����������", ;
      "~������஢����", ;
      "�~����� ��砨", ;
      "����� ~�⤥�����", ;
      "~��������" } )
    AAdd( first_message, { ;
      "���������� ���⪠ ��� ��祭�� ���쭮��", ;
      "������஢���� ���⪠ ��� ��祭�� ���쭮��", ;
      "����������, ��ᬮ��, 㤠����� ������� ��砥�", ;
      "������஢���� ���⪠ ��� ��祭�� ���쭮�� � ᬥ��� �⤥�����", ;
      "�������� ���⪠ ��� ��祭�� ���쭮��";
      } )
    AAdd( func_menu, { "oms_add()", ;
      "oms_edit()", ;
      "oms_double()", ;
      "oms_smena_otd()", ;
      "oms_del()" } )
    If yes_vypisan == B_END
      AAdd( first_menu[ 1 ], "~�����襭�� ��祭��" )
      AAdd( first_message[ 1 ], "������ ࠡ��� � �����襭��� ��祭��" )
      AAdd( func_menu[ 1 ], "oms_zav_lech()" )
    Endif
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "~����⥪�" )
    AAdd( first_message[ 1 ], "����� � ����⥪��" )
    AAdd( func_menu[ 1 ], "oms_kartoteka()" )
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "~��ࠢ�� ���" )
    AAdd( first_message[ 1 ], "���� � �ᯥ�⪠ �ࠢ�� � �⮨���� ��������� ����樭᪮� ����� � ��� ���" )
    AAdd( func_menu[ 1 ], "f_spravka_OMS()" )
    //
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "��������� ~業 ���" )
    AAdd( first_message[ 1 ], "��������� 業 �� ��㣨 � ᮮ⢥��⢨� � �ࠢ�筨��� ��� �����" )
    AAdd( func_menu[ 1 ], "Change_Cena_OMS()" )
    //
    AAdd( cmain_menu, cmain_next_pos( 3 ) )
    AAdd( main_menu, " ~������� " )
    AAdd( main_message, "����, ����� � ��� ॥��஢ ��砥�" )
    AAdd( first_menu, { "��~��ઠ", ;
      "~���⠢�����", ;
      "~��ᬮ��", 0, ;
      "��~����", 0 } )
    AAdd( first_message, { ;
      "�஢�ઠ ��। ��⠢������ ॥��� ��砥�", ;
      "���⠢����� ॥��� ��砥�", ;
      "��ᬮ�� ॥��� ��砥�, ��ࠢ�� � �����", ;
      "������ ॥��� ��砥�" } )
    AAdd( func_menu, { "verify_OMS()", ;
      "create_reestr()", ;
      "view_list_reestr()", ;
      "vozvrat_reestr()" } )
    If glob_mo()[ _MO_IS_UCH ]
      AAdd( first_menu[ 2 ], "�~ਪ९�����" )
      AAdd( first_message[ 2 ], "��ᬮ�� 䠩��� �ਪ९����� (� �⢥⮢ �� ���), ������ 䠩��� ��� �����" )
      AAdd( func_menu[ 2 ], "view_reestr_pripisnoe_naselenie()" )
      AAdd( first_menu[ 2 ], "~��९�����" )
      AAdd( first_message[ 2 ], "��ᬮ�� ����祭��� �� ����� 䠩��� ��९�����" )
      AAdd( func_menu[ 2 ], "view_otkrep_pripisnoe_naselenie()" )
    Endif
    AAdd( first_menu[ 2 ], "~����⠩�⢠" )
    AAdd( first_message[ 2 ], "��ᬮ��, ������ � �����, 㤠����� 䠩��� 室�⠩��" )
    AAdd( func_menu[ 2 ], "view_list_hodatajstvo()" )
    //
    AAdd( cmain_menu, cmain_next_pos( 3 ) )
    AAdd( main_menu, " ~��� " )
    AAdd( main_message, "��ᬮ��, ����� � ��� ��⮢ �� ���" )
    AAdd( first_menu, { "~�⥭�� �� �����", ;
      "���᮪ ~��⮢", ;
      "~���������", ;
      "~���� ����஫�", ;
      "������ ~���㬥���", 0, ;
      "~��稥 ���" } )
    AAdd( first_message, { ;
      "�⥭�� ���ଠ樨 �� ����� (�� ���)", ;
      "��ᬮ�� ᯨ᪠ ��⮢ �� ���, ������ ��� �����, ����� ��⮢", ;
      "�⬥⪠ � ॣ����樨 ��⮢ � �����", ;
      "����� � ��⠬� ����஫� ��⮢ (� ॥��ࠬ� ��⮢ ����஫�)", ;
      "����� � �����묨 ���㬥�⠬� �� ����� (� ॥��ࠬ� ������� ���㬥�⮢)", ;
      "����� � ��稬� ��⠬� (ᮧ�����, ।���஢����, ������)", ;
      } )
    AAdd( func_menu, { "read_from_tf()", ;
      "view_list_schet()", ;
      "registr_schet()", ;
      "akt_kontrol()", ;
      "view_pd()", ;
      "other_schets()" } )
    //
    AAdd( cmain_menu, cmain_next_pos( 3 ) )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ�� / ����� ���� �ࠢ�筨��� � ����⨪�" )
    AAdd( first_menu, { "���� ~���", ;
      "~����⨪�", ;
      "����-~�����", ;
      "~�஢�ન", ;
      "��ࠢ�~筨��", 0, ;
      "����� ~�������" } )
    AAdd( first_message, { ;
      "��ᬮ�� / ����� ���⮢ ��� ������", ;
      "��ᬮ�� / ����� ����⨪�", ;
      "����⨪� �� ����-������", ;
      "������� �஢�ન", ;
      "��ᬮ�� / ����� ���� �ࠢ�筨���", ;
      "��ᯥ�⪠ �ᥢ�������� �������";
      } )
    AAdd( func_menu, { "o_list_uch()", ;
      "e_statist()", ;
      "pz_statist()", ;
      "o_proverka()", ;
      "o_sprav()", ;
      "prn_blank()" } )
    If yes_parol
      AAdd( first_menu[ 4 ], "����� ~�����஢" )
      AAdd( first_message[ 4 ], "����⨪� �� ࠡ�� �����஢ �� ���� � �� �����" )
      AAdd( func_menu[ 4 ], "st_operator()" )
    Endif

    if ( ! isnil( edi_FindPath( PLUGINIFILE ) ) ) .and. ( control_podrazdel_ini( edi_FindPath( PLUGINIFILE ) ) )
      AAdd( first_menu[ 4 ], "�������⥫�� ����������" )
      AAdd( first_message[ 4 ], "�������⥫�� ����������" )
      AAdd( func_menu[ 4 ], "Plugins()" )
    endif
    
    //
    AAdd( cmain_menu, cmain_next_pos( 3 ) )
    AAdd( main_menu, " ~��ᯠ��ਧ��� " )
    AAdd( main_message, "��ᯠ��ਧ���, ��䨫��⨪�, ����ᬮ��� � ��ᯠ��୮� �������" )
    AAdd( first_menu, { "~��ᯠ��ਧ��� � ���ᬮ���", 0, ;
      "��ᯠ��୮� ~�������" } )
    AAdd( first_message, { ;
      "��ᯠ��ਧ���, ��䨫��⨪� � ����ᬮ���", ;
      "��ᯠ��୮� �������";
      } )
    AAdd( func_menu, { "dispanserizacia()", ;
      "disp_nabludenie()" } )
  Case glob_task == X_263 //
    fl := begin_task_263()
    If is_napr_pol
      AAdd( cmain_menu, 1 )
      AAdd( main_menu, " ~����������� " )
      AAdd( main_message, "���� / ।���஢���� ���ࠢ����� �� ��ᯨ⠫����� �� �����������" )
      AAdd( first_menu, { ;// "~�஢�ઠ",0,;
      "~���ࠢ�����", ;
        "~���㫨஢����", ;
        "~���ନ஢����", 0, ;
        "~�������� �����", 0, ;
        "~����⥪�" } )
      AAdd( first_message, { ;// "�஢�ઠ ⮣�, �� ��� �� ᤥ���� � �����������",;
      "���� / ।���஢���� / ��ᬮ�� ���ࠢ����� �� ��ᯨ⠫����� �� �����������", ;
        "���㫨஢���� �믨ᠭ��� ���ࠢ����� �� ��ᯨ⠫����� �� �����������", ;
        "���ନ஢���� ���� ��樥�⮢ � ��� �।���饩 ��ᯨ⠫���樨", ;
        "��ᬮ�� ������⢠ ᢮������ ���� �� ��䨫� � ��樮����/������� ��樮����", ;
        "����� � ����⥪��";
        } )
      AAdd( func_menu, { ;// "_263_p_proverka()",;
      "_263_p_napr()", ;
        "_263_p_annul()", ;
        "_263_p_inform()", ;
        "_263_p_svob_kojki()", ;
        "_263_kartoteka(1)" } )
    Endif
    If is_napr_stac
      AAdd( cmain_menu, 15 )
      AAdd( main_menu, " ~��樮��� " )
      AAdd( main_message, "���� ���� ��ᯨ⠫���樨, ���� ��ᯨ⠫���஢����� � ����� �� ��樮����" )
      AAdd( first_menu, { ;// "~�஢�ઠ",0,;
      "~��ᯨ⠫���樨", ;
        "~�믨᪠ (���⨥)", ;
        "~���ࠢ�����", ;
        "~���㫨஢����", 0, ;
        "~�������� �����", 0, ;
        "~����⥪�" } )
      AAdd( first_message, { ;// "�஢�ઠ ⮣�, �� ��� �� ᤥ���� � ��樮���",;
      "���������� / ।���஢���� ��ᯨ⠫���権 � ��樮���", ;
        "�믨᪠ (���⨥) ��樥�� �� ��樮���", ;
        "���᮪ ���ࠢ�����, �� ����� ��� �� �뫮 ��ᯨ⠫���樨", ;
        "���㫨஢���� ���ࠢ�����, ����㯨��� �� ���������� �१ �����", ;
        "���� / ।���஢���� ������⢠ ᢮������ ���� �� ��䨫� � ��樮���", ;
        "����� � ����⥪��";
        } )
      AAdd( func_menu, { ;// "_263_s_proverka()",;
      "_263_s_gospit()", ;
        "_263_s_vybytie()", ;
        "_263_s_napr()", ;
        "_263_s_annul()", ;
        "_263_s_svob_kojki()", ;
        "_263_kartoteka(2)" } )
    Endif
    AAdd( cmain_menu, 29 )
    AAdd( main_menu, " ~� ����� " )
    AAdd( main_message, "��ࠢ�� � ����� 䠩��� ������ (��ᬮ�� ��ࠢ������ 䠩���)" )
    AAdd( first_menu, { "~�஢�ઠ ��। ��⠢������ ����⮢", ;
      "~���⠢����� ����⮢ ��� ��ࠢ�� � ��", ;
      "��ᬮ�� ��⮪���� ~�����", 0 } )
    AAdd( first_message,  { ;   // ���ଠ��
    "�஢�ઠ ���ଠ樨 ��। ��⠢������ ����⮢ � ��ࠢ��� � �����", ;
      "���⠢����� ���ଠ樮���� ����⮢ ��� ��ࠢ�� � �����", ;
      "��ᬮ�� ��⮪���� ��⠢����� ���ଠ樮���� ����⮢ ��� ��ࠢ�� � �����";
      } )
    AAdd( func_menu, { ;    // ���ଠ��
    "_263_to_proverka()", ;
      "_263_to_sostavlenie()", ;
      "_263_to_protokol()";
      } )
    k := Len( first_menu )
    If is_napr_pol
      AAdd( first_menu[ k ], "I0~1-�믨ᠭ�� ���ࠢ�����" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � �믨ᠭ�묨 ���ࠢ����ﬨ" )
      AAdd( func_menu[ k ], "_263_to_I01()" )
    Endif
    AAdd( first_menu[ k ], "I0~3-���㫨஢���� ���ࠢ�����" )
    AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ���㫨஢���묨 ���ࠢ����ﬨ" )
    AAdd( func_menu[ k ], "_263_to_I03()" )
    If is_napr_stac
      AAdd( first_menu[ k ], "I0~4-��ᯨ⠫���樨 �� ���ࠢ�����" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ �� ���ࠢ�����" )
      AAdd( func_menu[ k ], "_263_to_I04(4)" )
      //
      AAdd( first_menu[ k ], "I0~5-���७�� ��ᯨ⠫���樨" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ ��� ���ࠢ����� (����.� ����.)" )
      AAdd( func_menu[ k ], "_263_to_I04(5)" )
      //
      AAdd( first_menu[ k ], "I0~6-���訥 ��樥���" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ᢥ����ﬨ � ����� ��樥���" )
      AAdd( func_menu[ k ], "_263_to_I06()" )
    Endif
    AAdd( first_menu[ k ], 0 )
    AAdd( first_menu[ k ], "~����ன�� ��⠫����" )
    AAdd( first_message[ k ], "����ன�� ��⠫���� ������ - �㤠 �����뢠�� ᮧ����� ��� ����� 䠩��" )
    AAdd( func_menu[ k ], "_263_to_nastr()" )
    //
    AAdd( cmain_menu, 39 )
    AAdd( main_menu, " �� ~����� " )
    AAdd( main_message, "����祭�� �� ����� 䠩��� ������ � ��ᬮ�� ����祭��� 䠩���" )
    AAdd( first_menu, { "~�⥭�� �� �����", ;
      "~��ᬮ�� ��⮪���� �⥭��", 0 } )
    AAdd( first_message,  { ;   // ���ଠ��
    "����祭�� �� ����� 䠩��� ������ (���ଠ樮���� ����⮢)", ;
      "��ᬮ�� ��⮪���� �⥭�� ���ଠ樮���� ����⮢ �� �����";
      } )
    AAdd( func_menu, { ;
      "_263_from_read()", ;
      "_263_from_protokol()";
      } )
    k := Len( first_menu )
    If is_napr_stac
      AAdd( first_menu[ k ], "I0~1-����祭�� ���ࠢ�����" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ����祭�묨 ���ࠢ����ﬨ �� ����������" )
      AAdd( func_menu[ k ], "_263_from_I01()" )
    Endif
    AAdd( first_menu[ k ], "I0~3-���㫨஢���� ���ࠢ�����" )
    AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ���㫨஢���묨 ���ࠢ����ﬨ" )
    AAdd( func_menu[ k ], "_263_from_I03()" )
    If is_napr_pol
      AAdd( first_menu[ k ], "I0~4-��ᯨ⠫���樨 �� ���ࠢ�����" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ �� ���ࠢ�����" )
      AAdd( func_menu[ k ], "_263_from_I04()" )
      //
      AAdd( first_menu[ k ], "I0~5-���७�� ��ᯨ⠫���樨" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ ��� ���ࠢ����� (����.� ����.)" )
      AAdd( func_menu[ k ], "_263_from_I05()" )
      //
      AAdd( first_menu[ k ], "I0~6-���訥 ��樥���" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ᢥ����ﬨ � ����� ��樥���" )
      AAdd( func_menu[ k ], "_263_from_I06()" )
      //
      AAdd( first_menu[ k ], "I0~7-����稥 ᢮������ ����" )
      AAdd( first_message[ k ], "���᮪ ���ଠ樮���� ����⮢ � ᢥ����ﬨ � ����稨 ᢮������ ����" )
      AAdd( func_menu[ k ], "_263_from_I07()" )
    Endif
    AAdd( first_menu[ k ], 0 )
    AAdd( first_menu[ k ], "~����ன�� ��⠫����" )
    AAdd( first_message[ k ], "����ன�� ��⠫���� ������ - ��㤠 ����뢠�� ����祭�� �� ����� 䠩��" )
    AAdd( func_menu[ k ], "_263_to_nastr()" )
    //
  Case glob_task == X_PLATN //
    fl := begin_task_plat()
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~����� ��㣨 " )
    AAdd( main_message, "���� / ।���஢���� ������ �� ���⮢ ��� ������ ����樭᪨� ���" )
    AAdd( first_menu, { "~���� ������" } )
    AAdd( first_message, { "����������/������஢���� ���⪠ ��� ��祭�� ���⭮�� ���쭮��" } )
    AAdd( func_menu, { "kart_plat()" } )
    If glob_pl_reg == 1
      AAdd( first_menu[ 1 ], "~����/।-��" )
      AAdd( first_message[ 1 ], "����/������஢���� ���⮢ ��� ��祭�� ������ ������" )
      AAdd( func_menu[ 1 ], "poisk_plat()" )
    Endif
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "~����⥪�" )
    AAdd( first_message[ 1 ], "����� � ����⥪��" )
    AAdd( func_menu[ 1 ], "oms_kartoteka()" )
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "~����� ��� � �/�" )
    AAdd( first_message[ 1 ], "����/।���஢���� ����� �� ����������� � ���஢��쭮�� ���.���客����" )
    AAdd( func_menu[ 1 ], "oplata_vz()" )
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "~�����⨥ �/���" )
    AAdd( first_message[ 1 ], "������� ���� ��� (���� �ਧ��� ������� � ���� ���)" )
    AAdd( func_menu[ 1 ], "close_lu()" )
    //
    AAdd( cmain_menu, 34 )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ�� / ����� ���� �ࠢ�筨��� � ����⨪�" )
    AAdd( first_menu, { "~����⨪�", ;
      "���~��筨��", ;
      "~�஢�ન" } )
    AAdd( first_message,  { ;   // ���ଠ��
    "��ᬮ�� ����⨪�", ;
      "��ᬮ�� ���� �ࠢ�筨���", ;
      "������� �஢���� ०���";
      } )
    AAdd( func_menu, { ;    // ���ଠ��
    "Po_statist()", ;
      "o_sprav()", ;
      "Po_proverka()";
      } )
    If glob_kassa == 1
      AAdd( first_menu[ 2 ], 0 )
      AAdd( first_menu[ 2 ], "����� � ~���ᮩ" )
      AAdd( first_message[ 2 ], "���ଠ�� �� ࠡ�� � ���ᮩ" )
      AAdd( func_menu[ 2 ], "inf_fr()" )
    Endif
    AAdd( first_menu[ 2 ], 0 )
    AAdd( first_menu[ 2 ], '��ࠢ�� ��� ~���' )
    AAdd( first_message[ 2 ], '���⠢����� � ࠡ�� � �ࠢ���� ��� ���' )
    AAdd( func_menu[ 2 ], 'inf_fns()' )
    If yes_parol
      AAdd( first_menu[ 2 ], 0 )
      AAdd( first_menu[ 2 ], "����� ~�����஢" )
      AAdd( first_message[ 2 ], "����⨪� �� ࠡ�� �����஢ �� ���� � �� �����" )
      AAdd( func_menu[ 2 ], "st_operator()" )
    Endif
    //
    AAdd( cmain_menu, 50 )
    AAdd( main_menu, " ~��ࠢ�筨�� " )
    AAdd( main_message, "������� �ࠢ�筨���" )
    AAdd( first_menu, {} )
    AAdd( first_message, {} )
    AAdd( func_menu, {} )
    If is_oplata != 7
      AAdd( first_menu[ 3 ], "~��������" )
      AAdd( first_message[ 3 ], "��ࠢ�筨� ������� ��� ������ ���" )
      AAdd( func_menu[ 3 ], "s_pl_meds(1)" )
      //
      AAdd( first_menu[ 3 ], "~�����ન" )
      AAdd( first_message[ 3 ], "��ࠢ�筨� ᠭ��ப ��� ������ ���" )
      AAdd( func_menu[ 3 ], "s_pl_meds(2)" )
    Endif
    AAdd( first_menu[ 3 ], "�।����� (�/~����)" )
    AAdd( first_message[ 3 ], "��ࠢ�筨� �।���⨩, ࠡ����� �� �����������" )
    AAdd( func_menu[ 3 ], "edit_pr_vz()" )
    //
    AAdd( first_menu[ 3 ], "~���஢���� ���" ) ; AAdd( first_menu[ 3 ], 0 )
    AAdd( first_message[ 3 ], "��ࠢ�筨� ���客�� ��������, �����⢫���� ���஢��쭮� ���.���客����" )
    AAdd( func_menu[ 3 ], "edit_d_smo()" )
    //
    AAdd( first_menu[ 3 ], "��㣨 �� ���~�" )
    AAdd( first_message[ 3 ], "������஢���� �ࠢ�筨�� ���, 業� �� ����� ������� � �����-� ����" )
    AAdd( func_menu[ 3 ], "f_usl_date()" )
    If glob_kassa == 1
      AAdd( first_menu[ 3 ], 0 )
      AAdd( first_menu[ 3 ], "����� � ~���ᮩ" )
      AAdd( first_message[ 3 ], "����ன�� ࠡ��� � ���ᮢ� �����⮬" )
      AAdd( func_menu[ 3 ], "fr_nastrojka()" )
    Endif
  Case glob_task == X_ORTO  //
    fl := begin_task_orto()
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~��⮯���� " )
    AAdd( main_message, "���� ������ �� ��⮯����᪨� ��㣠� � �⮬�⮫����" )
    AAdd( first_menu, { "~����⨥ ���鸞", ;
      "~�����⨥ ���鸞", 0, ;
      "~����⥪�" } )
    AAdd( first_message,  { ;
      "����⨥ ���鸞-������ (���������� ���⪠ ��� ��祭�� ���쭮��)", ;
      "�����⨥ ���鸞-������ (।���஢���� ���⪠ ��� ��祭�� ���쭮��)", ;
      "����� � ����⥪��" } )
    AAdd( func_menu, { "kart_orto(1)", ;
      "kart_orto(2)", ;
      "oms_kartoteka()" } )
    //
    AAdd( cmain_menu, 34 )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ�� / ����� ���� �ࠢ�筨��� � ����⨪�" )
    AAdd( first_menu, { "~����⨪�", ;
      "���~��筨��", ;
      "~�஢�ન" } )
    AAdd( first_message,  { ;   // ���ଠ��
      "��ᬮ�� ����⨪�", ;
      "��ᬮ�� ���� �ࠢ�筨���", ;
      "������� �஢���� ०���";
    } )
    AAdd( func_menu, { ;    // ���ଠ��
      "Oo_statist()", ;
      "o_sprav(-5)", ;   // X_ORTO = 5
      "Oo_proverka()";
    } )
    If glob_kassa == 1   // 10.10.14
      AAdd( first_menu[ 2 ], 0 )
      AAdd( first_menu[ 2 ], "����� � ~���ᮩ" )
      AAdd( first_message[ 2 ], "���ଠ�� �� ࠡ�� � ���ᮩ" )
      AAdd( func_menu[ 2 ], "inf_fr_orto()" )
    Endif
    AAdd( first_menu[ 2 ], 0 )
    AAdd( first_menu[ 2 ], '��ࠢ�� ��� ~���' )
    AAdd( first_message[ 2 ], '���⠢����� � ࠡ�� � �ࠢ���� ��� ���' )
    AAdd( func_menu[ 2 ], 'inf_fns()' )
    If yes_parol
      AAdd( first_menu[ 2 ], 0 )
      AAdd( first_menu[ 2 ], "����� ~�����஢" )
      AAdd( first_message[ 2 ], "����⨪� �� ࠡ�� �����஢ �� ���� � �� �����" )
      AAdd( func_menu[ 2 ], "st_operator()" )
    Endif
    //
    AAdd( cmain_menu, 50 )
    AAdd( main_menu, " ~��ࠢ�筨�� " )
    AAdd( main_message, "������� �ࠢ�筨���" )
    AAdd( first_menu, ;
      { "��⮯����᪨� ~��������", ;
      "��稭� ~�������", ;
      "~��㣨 ��� ��祩", 0, ;
      "�।����� (�/~����)", ;
      "~���஢���� ���", 0, ;
      "~���ਠ��";
      } )
    AAdd( first_message, ;
      { "������஢���� �ࠢ�筨�� ��⮯����᪨� ���������", ;
      "������஢���� �ࠢ�筨�� ��稭 ������� ��⥧��", ;
      "����/।���஢���� ���, � ������ �� �������� ��� (�孨�)", ;
      "��ࠢ�筨� �।���⨩, ࠡ����� �� �����������", ;
      "��ࠢ�筨� ���客�� ��������, �����⢫���� ���஢��쭮� ���.���客����", ;
      "��ࠢ�筨� �ਢ������� ��室㥬�� ���ਠ���";
      } )
    AAdd( func_menu, ;
      { "orto_diag()", ;
      "f_prich_pol()", ;
      "f_orto_uva()", ;
      "edit_pr_vz()", ;
      "edit_d_smo()", ;
      "edit_ort()";
      } )
    If glob_kassa == 1
      AAdd( first_menu[ 3 ], 0 )
      AAdd( first_menu[ 3 ], "����� � ~���ᮩ" )
      AAdd( first_message[ 3 ], "����ன�� ࠡ��� � ���ᮢ� �����⮬" )
      AAdd( func_menu[ 3 ], "fr_nastrojka()" )
    Endif
  Case glob_task == X_KASSA //
    fl := begin_task_kassa()
    //
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~���� �� " )
    AAdd( main_message, "���� ������ � ���� �� �� ����� ��㣠�" )
    AAdd( first_menu, { "~���� ������", 0, ;
      "~����⥪�" } )
    AAdd( first_message,  { ;
      "���������� ���⪠ ��� ��祭�� ���⭮�� ���쭮��", ;
      "����/।���஢���� ����⥪� (ॣ�������)" } )
    AAdd( func_menu, { "kas_plat()", ;
      "oms_kartoteka()" } )
    AAdd( first_menu[ 1 ], 0 )
    AAdd( first_menu[ 1 ], "~��ࠢ�� ���" )
    AAdd( first_message[ 1 ], "���� � �ᯥ�⪠ �ࠢ�� � �⮨���� ��������� ����樭᪮� ����� � ��� ���" )
    AAdd( func_menu[ 1 ], "f_spravka_OMS()" )
    //
    If is_task( X_ORTO )
      AAdd( cmain_menu, cmain_next_pos() )
      AAdd( main_menu, " ~��⮯���� " )
      AAdd( main_message, "���� ������ �� ��⮯����᪨� ��㣠�" )
      AAdd( first_menu, { "~���� ����", ;
        "~������஢���� ���鸞", 0, ;
        "~����⥪�" } )
      AAdd( first_message, { ;
        "����⨥ ᫮����� ���鸞 ��� ���� ���⮣� ��⮯����᪮�� ���鸞", ;
        "������஢���� ��⮯����᪮�� ���鸞 (� �.�. ������ ��� ������ �����)", ;
        "����/।���஢���� ����⥪� (ॣ�������)" } )
      AAdd( func_menu, { "f_ort_nar(1)", ;
        "f_ort_nar(2)", ;
        "oms_kartoteka()" } )
    Endif
    //
    AAdd( cmain_menu, cmain_next_pos() )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ�� / �����" )
    AAdd( first_menu, { iif( is_task( X_ORTO ), "~����� ��㣨", "~����⨪�" ), ;
      "������� �~���⨪�", ; // 10.05
      "���~��筨��", ;
      "����� � ~���ᮩ" } )
    AAdd( first_message,  { ;   // ���ଠ��
      "��ᬮ�� / ����� ������᪨� ���⮢ �� ����� ��㣠�", ;
      "��ᬮ�� / ����� ᢮���� ������᪨� ���⮢", ;
      "��ᬮ�� ���� �ࠢ�筨���", ;
      "���ଠ�� �� ࠡ�� � ���ᮩ";
    } )
    AAdd( func_menu, { ;    // ���ଠ��
      "prn_k_plat()", ;
      "regi_s_plat()", ;
      "o_sprav()", ;
      "prn_k_fr()";
    } )
    If is_task( X_ORTO )
      ins_array( first_menu[ 3 ], 2, "~��⮯����" )
      ins_array( first_message[ 3 ], 2, "��ᬮ�� / ����� ������᪨� ���⮢ �� ��⮯����" )
      ins_array( func_menu[ 3 ], 2, "prn_k_ort()" )
    Endif
    //
    AAdd( cmain_menu, cmain_next_pos() )
    AAdd( main_menu, " ~��ࠢ�筨�� " )
    AAdd( main_message, "��ᬮ�� / ।���஢���� �ࠢ�筨���" )
    AAdd( first_menu, { "~��㣨 � ᬥ��� 業�", ;
      "~������ ��㣨", ;
      "����� � ~���ᮩ", 0, ;
      "~����ன�� �ணࠬ��" } )
    AAdd( first_message, { ;
      "������஢���� ᯨ᪠ ���, �� ����� ������ ࠧ�蠥��� ।���஢��� 業�", ;
      "������஢���� ᯨ᪠ ���, �� �뢮����� � ��ୠ� ������஢ (�᫨ 1 � 祪�)", ;
      "����ன�� ࠡ��� � ���ᮢ� �����⮬", ;
      "����ன�� �ணࠬ�� (�������� ���祭�� �� 㬮�砭��)" } )
    AAdd( func_menu, { "fk_usl_cena()", ;
      "fk_usl_dogov()", ;
      "fr_nastrojka()", ;
      "nastr_kassa(2)" } )
    AAdd( first_menu[ 2 ], 0 )
    AAdd( first_menu[ 2 ], '��ࠢ�� ��� ~���' )
    AAdd( first_message[ 2 ], '���⠢����� � ࠡ�� � �ࠢ���� ��� ���' )
    AAdd( func_menu[ 2 ], 'inf_fns()' )
//  Case glob_task == X_KEK  //
//    If !Between( hb_user_curUser:KEK, 1, 3 )
//      n_message( { "�������⨬�� ��㯯� �ᯥ�⨧� (���): " + lstr( hb_user_curUser:KEK ), ;
//        '', ;
//        '���짮��⥫�, ����� ࠧ�襭� ࠡ���� � �������� "��� ��",', ;
//        '����室��� ��⠭����� ��㯯� �ᯥ�⨧� (�� 1 �� 3)', ;
//        '� �������� "������஢���� �ࠢ�筨���" � ०��� "��ࠢ�筨��/��஫�"' },, ;
//        "GR+/R", "W+/R",,, "G+/R" )
//    Else
//      fl := begin_task_kek()
//      AAdd( cmain_menu, 1 )
//      AAdd( main_menu, " ~��� " )
//      AAdd( main_message, "���� ������ �� ��� ����樭᪮� �࣠����樨" )
//      AAdd( first_menu, { "~����������", ;
//        "~������஢����", ;
//        "~��������" } )
//      AAdd( first_message, { ;
//        "���������� ������ �� ���⨧�", ;
//        "������஢���� ������ �� ���⨧�", ;
//        "�������� ������ �� ���⨧�";
//        } )
//      AAdd( func_menu, { "kek_vvod(1)", ;
//        "kek_vvod(2)", ;
//        "kek_vvod(3)" } )
//      AAdd( cmain_menu, 34 )
//      AAdd( main_menu, " ~���ଠ�� " )
//      AAdd( main_message, "��ᬮ�� / ����� ����⨪� �� �ᯥ�⨧��" )
//      AAdd( first_menu, { "~��ᯥ�⭠� ����", ;
//        "�業�� ~����⢠" } )
//      AAdd( first_message, { ;
//        "��ᯥ�⪠ �ᯥ�⭮� �����", ;
//        "��ᯥ�⪠ ࠫ���� ����⮢ �� �楪� ����⢠ �ᯥ�⨧�" } )
//      AAdd( func_menu, { "kek_prn_eks()", ;
//        "kek_info2017()" } )
//      AAdd( cmain_menu, 51 )
//      AAdd( main_menu, " ~��ࠢ�筨�� " )
//      AAdd( main_message, "������� �ࠢ�筨���" )
//      AAdd( first_menu, { "~����ன��" } )
//      AAdd( first_message, { "����ன�� ���祭�� �� 㬮�砭��" } )
//      AAdd( func_menu, { "kek_nastr()" } )
//    Endif
  Case glob_task == X_MO //
    fl := my_mo_begin_task()
    my_mo_f1main()
  Case glob_task == X_SPRAV //
    fl := menu_X_sprav()
/*
    fl := begin_task_sprav()
    //
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~��ࠢ�筨�� " )
    AAdd( main_message, "������஢���� �ࠢ�筨���" )
    AAdd( first_menu, { "~������� �࣠����樨", ;
      "��ࠢ�筨� ~���", ;
      "�~�稥 �ࠢ�筨��", 0, ;
      "~��஫�" } )
    AAdd( first_message, { ;
      "������஢���� �ࠢ�筨��� ���ᮭ���, �⤥�����, ��०�����, �࣠����樨", ;
      "������஢���� �ࠢ�筨�� ���", ;
      "������஢���� ���� �ࠢ�筨���", ;
      "������஢���� �ࠢ�筨�� ��஫�� ����㯠 � �ணࠬ��";
      } )
    AAdd( func_menu, { "spr_struct_org()", ;
      "edit_spr_uslugi()", ;
      "edit_proch_spr()", ;
      "edit_password()" } )

    // �����ன�� ����
    hb_ADel( first_menu[ Len( first_menu ) ], 5, .t. )
    hb_ADel( first_message[ Len( first_message ) ], 4, .t. )
    hb_ADel( func_menu[ Len( func_menu ) ], 4, .t. )

    hb_AIns( first_menu[ Len( first_menu ) ], 5, '~���짮��⥫�', .t. )
    hb_AIns( first_menu[ Len( first_menu ) ], 6, '~��㯯� ���짮��⥫��', .t. )
    hb_AIns( first_message[ Len( first_message ) ], 4, '������஢���� �ࠢ�筨�� ���짮��⥫�� ��⥬�', .t. )
    hb_AIns( first_message[ Len( first_message ) ], 5, '������஢���� �ࠢ�筨�� ��㯯 ���짮��⥫�� � ��⥬�', .t. )
    // hb_AIns( func_menu[ len( func_menu ) ], 4, 'edit_Users_bay()', .t. )
    hb_AIns( func_menu[ Len( func_menu ) ], 4, 'edit_password()', .t. )
    hb_AIns( func_menu[ Len( func_menu ) ], 5, 'editRoles()', .t. )
    // ����� �����ன�� ����
    //
    AAdd( cmain_menu, 40 )
    AAdd( main_menu, " ~���ଠ�� " )
    AAdd( main_message, "��ᬮ��/����� �ࠢ�筨���" )
    AAdd( first_menu, { "~��騥 �ࠢ�筨��" } )
    AAdd( first_message, { ;
      "��ᬮ��/����� ���� �ࠢ�筨���";
      } )
    AAdd( func_menu, { "o_sprav()" } )
*/
  Case glob_task == X_SERVIS //
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~��ࢨ�� " )
    AAdd( main_message, "��ࢨ�� � ����ன��" )
    //
    If glob_mo()[ _MO_KOD_TFOMS ] == '395301' // ����設 ����
      AAdd( first_menu, { "~�஢�ઠ 楫��⭮��", 0, ;
        "��������� ~業 ���", 0, ;
        "~������", ;
        "~��ᯮ��", ;
        "~���ਠ��" } )
      AAdd( first_message, { ;
        "�஢�ઠ 楫��⭮�� ���� ������ �� 䠩�-�ࢥ�", ;
        "��������� 業 �� ��㣨 � ᮮ⢥��⢨� � �ࠢ�筨��� ��� �����", ;
        "������� ��ਠ��� ������ �� ��㣨� �ணࠬ�", ;
        '������� ��ਠ��� �ᯮ�� � ��㣨� �ணࠬ��/�࣠����樨', ;
        "��ࠢ�筨� �ਢ������� ��室㥬�� ���ਠ���";
        } )
      AAdd( func_menu, { "prover_dbf(,.f.,(hb_user_curUser:IsAdmin()))", ;
        "Change_Cena_OMS()", ;
        "f_import()", ;
        "f_export()", ;
        "edit_ort()" } )

    Else
      AAdd( first_menu, { "~�஢�ઠ 楫��⭮��", 0, ;
        "��������� ~業 ���", 0, ;
        "~������", ;
        "~��ᯮ��" } )
      AAdd( first_message, { ;
        "�஢�ઠ 楫��⭮�� ���� ������ �� 䠩�-�ࢥ�", ;
        "��������� 業 �� ��㣨 � ᮮ⢥��⢨� � �ࠢ�筨��� ��� �����", ;
        "������� ��ਠ��� ������ �� ��㣨� �ணࠬ�", ;
        '������� ��ਠ��� �ᯮ�� � ��㣨� �ணࠬ��/�࣠����樨';
        } )
      AAdd( func_menu, { "prover_dbf(,.f.,(hb_user_curUser:IsAdmin()))", ;
        "Change_Cena_OMS()", ;
        "f_import()", ;
        "f_export()" } )
    Endif
    //
    AAdd( cmain_menu, 20 )
    AAdd( main_menu, " ~����ன�� " )
    AAdd( main_message, "����ன��" )
    AAdd( first_menu, { "~��騥 ����ன��", 0, ;
      "��ࠢ�筨�� ~�����", 0, ;
      "~����祥 ����" } )
    AAdd( first_message, { ;
      "��騥 ����ன�� ������ �����", ;
      "����ன�� ᮤ�ন���� �ࠢ�筨��� ����� (㬥��襭�� ������⢠ ��ப)", ;
      "����ன�� ࠡ�祣� ����";
      } )
    AAdd( func_menu, { "nastr_all()", ;
      "nastr_sprav_FFOMS()", ;
      "nastr_rab_mesto()" } )
    AAdd( cmain_menu, 50 )
    AAdd( main_menu, " ��稥 ~������ " )
    AAdd( main_message, "����� �ᯮ��㥬� (���ॢ訥) ������" )
    //
    If glob_mo()[ _MO_KOD_TFOMS ] == '395301' // ����設 ����
      AAdd( first_menu, { ;
        "~���� ��樥���", ;
        "���ଠ�� � ������⢥ 㤠���� ~�㡮�", ;
        "���쬮 �792 �����~�", ;
        "�����ਭ~� �� ����� ���.�����", ;
        "����䮭��ࠬ�� �~15 �� ��", ;
        "�������� ��� �-�� ~25 � ���.業�� 2", ;
        "~���室 ���ਠ���" } )
      // "~����୨����",;
      AAdd( first_message, { ;
        "��ୠ� ॣ����樨 ����� ��樥�⮢", ;
        "���ଠ�� � ������⢥ 㤠���� ����ﭭ�� �㡮� � 2005 �� 2015 ����", ;
        "�����⮢�� ��� ᮣ��᭮ �ਫ������ � ����� ������ �792 �� 16.06.2017�.", ;
        "�����ਭ� �� ����� ����樭᪮� ����� ��� ������ ��ࠢ���࠭���� ��", ;
        "���ଠ�� �� ��樮��୮�� ��祭�� ��� �������� ������ �� 2017 ���", ;
        "�������� � 䠪��᪨� ������ �� �������� ����樭᪮� �����", ;
        "��������� �� ��室� ���ਠ��� �� ��⥧�஢����" } )
      // "����⨪� �� ����୨��樨",;
      AAdd( func_menu, { 'run_my_hrb("mo_hrb1","i_new_boln()")', ;
        'run_my_hrb("mo_hrb1","i_kol_del_zub()")', ;
        'run_my_hrb("mo_hrb1","forma_792_MIAC()")', ;
        'run_my_hrb("mo_hrb1","monitoring_vid_pom()")', ;
        'run_my_hrb("mo_hrb1","phonegram_15_kz()")', ;
        'run_my_hrb("mo_hrb1","b_25_perinat_2()")', ;
        'Ort_OMS_material()' } )
      // "modern_statist()",;
    Else
      AAdd( first_menu, { ;
        "~���� ��樥���", ;
        "���ଠ�� � ������⢥ 㤠���� ~�㡮�", ;
        "���쬮 �792 �����~�", ;
        "�����ਭ~� �� ����� ���.�����", ;
        "����䮭��ࠬ�� �~15 �� ��", ;
        "�������� ��� �-�� ~25 � ���.業�� 2" } )
      // "~����୨����",;
      AAdd( first_message, { ;
        "��ୠ� ॣ����樨 ����� ��樥�⮢", ;
        "���ଠ�� � ������⢥ 㤠���� ����ﭭ�� �㡮� � 2005 �� 2015 ����", ;
        "�����⮢�� ��� ᮣ��᭮ �ਫ������ � ����� ������ �792 �� 16.06.2017�.", ;
        "�����ਭ� �� ����� ����樭᪮� ����� ��� ������ ��ࠢ���࠭���� ��", ;
        "���ଠ�� �� ��樮��୮�� ��祭�� ��� �������� ������ �� 2017 ���", ;
        "�������� � 䠪��᪨� ������ �� �������� ����樭᪮� �����" } )
      // "����⨪� �� ����୨��樨",;
      AAdd( func_menu, { 'run_my_hrb("mo_hrb1","i_new_boln()")', ;
        'run_my_hrb("mo_hrb1","i_kol_del_zub()")', ;
        'run_my_hrb("mo_hrb1","forma_792_MIAC()")', ;
        'run_my_hrb("mo_hrb1","monitoring_vid_pom()")', ;
        'run_my_hrb("mo_hrb1","phonegram_15_kz()")', ;
        'run_my_hrb("mo_hrb1","b_25_perinat_2()")' } )
      // "modern_statist()",;
    Endif
  Case glob_task == X_COPY //
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~����ࢭ�� ����஢���� " )
    AAdd( main_message, "����ࢭ�� ����஢���� ���� ������" )
    AAdd( first_menu, { ;
      '����஢���� ~���� ������', ;
      '��ࠢ�� ���� ~������', ;
      '��ࠢ�� 䠩�� ~�訡��' ;
      } )
    AAdd( first_message, { ;
      '����ࢭ�� ����஢���� ���� ������', ;
      '����ࢭ�� ����஢���� ���� ������ � ��ࠢ�� ����� �㦡� �����প�', ;
      '����ࢭ�� ����஢���� 䠩�� �訡�� � ��ࠢ�� ��� � �㦡� �����প�' ;
      } )
    AAdd( func_menu, { ;
      'm_copy_DB(1)', ;
      'm_copy_DB(2)', ;
      'errorFileToFTP()' ;
      } )
  Case glob_task == X_INDEX //
    AAdd( cmain_menu, 1 )
    AAdd( main_menu, " ~��२�����஢���� " )
    AAdd( main_message, "��२�����஢���� ���� ������" )
    AAdd( first_menu, { "~��२�����஢����" } )
    AAdd( first_message, { ;
      "��२�����஢���� ���� ������";
      } )
    AAdd( func_menu, { "m_index_DB()" } )
  Endcase
  // ��᫥���� ���� ��� ��� ���� � � ��
  AAdd( cmain_menu, MaxCol() -9 )
  AAdd( main_menu, " ����~�� " )
  AAdd( main_message, "������, ����ன�� �ਭ��" )
  AAdd( first_menu, { "~����� � �ணࠬ��", ;
    "����~��", ;
    "~����祥 ����", ;
    "~�ਭ��", 0, ;
    "��२������� ࠡ�祣� ��⠫���", ;
    "��⥢�� ~������", ;
    "~�訡��" } )
  AAdd( first_message, { ;
    "�뢮� �� �࠭ ᮤ�ঠ��� 䠩�� README.RTF � ⥪�⮬ ������ � �ணࠬ��", ;
    "�뢮� �� �࠭ �࠭� �����", ;
    "����ன�� ࠡ�祣� ����", ;
    "��⠭���� ����� �ਭ��", ;
    "��२����஢���� �ࠢ�筨��� ��� � ࠡ�祬 ��⠫���", ;
    "����� ��ᬮ�� - �� ��室���� � ����� � � ����� ०���", ;
    "��ᬮ�� 䠩�� �訡��" } )
  AAdd( func_menu, { "view_file_in_Viewer(dir_exe() + 'README.RTF')", ;
    "m_help()", ;
    "nastr_rab_mesto()", ;
    "ust_printer(T_ROW)", ;
    "index_work_dir(dir_exe(), cur_dir(), .t.)", ;
    "net_monitor(T_ROW, T_COL - 7, (hb_user_curUser:IsAdmin()))", ;
    "view_errors()" } )
// ������� ��२�����஢���� �������� 䠩��� ����� �����
//  If eq_any( glob_task, X_PPOKOJ, X_OMS, X_PLATN, X_ORTO, X_KASSA, X_KEK, X_263 )
  If eq_any( glob_task, X_PPOKOJ, X_OMS, X_PLATN, X_ORTO, X_KASSA, X_263 )
    AAdd( ATail( first_menu ), 0 )
    AAdd( ATail( first_menu ), "���~������஢����" )
    AAdd( ATail( first_message ), '��२�����஢���� ��� ���� ������ ��� ����� "' + array_tasks[ ind_task(), 5 ] + '"' )
    AAdd( ATail( func_menu ), "pereindex_task()" )
  Endif
  If fl
    g_splus( f_name_task() )   // ���� 1 ���짮��⥫� ���� � ������
    func_main( .t., blk_ekran )
    g_sminus( f_name_task() )  // ����� 1 ���짮��⥫� (��襫 �� �����)
  Endif

  Return Nil

// 25.05.13 �������� ᫥������ ������ ��� �������� ���� �����
Static Function cmain_next_pos( n )

  Default n To 5

  Return ATail( cmain_menu ) + Len( ATail( main_menu ) ) + n

// 11.09.25
Function my_mo_f1main()
  Local old := is_uchastok

  If glob_mo()[ _MO_KOD_TFOMS ] == kod_VOUNC
    is_uchastok := 1 // �㪢� + � ���⪠ + � � ���⪥ "�25/123"
    vounc_f1main()
    is_uchastok := old
  Endif

  Return Nil
