#include "common.ch"
#include "function.ch"
#include "chip_mo.ch"

function menu_X_sprav()

  local fl

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
  return fl