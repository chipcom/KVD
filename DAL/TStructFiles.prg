#include 'hbclass.ch'
#include 'dbstruct.ch'
#include 'function.ch'

CREATE CLASS TStructFiles

	CLASSDATA oSelf           INIT Nil          // ��뫪� �� ᠬ�� ᥡ�
  
	HIDDEN:
		VAR hbFiles
  
	VISIBLE:
  
		METHOD New()
		METHOD GetDescr( className )		   INLINE   ::hbFiles[ Upper( className ) ]
		METHOD ExistFileClass( className )

ENDCLASS

METHOD ExistFileClass( className ) CLASS TStructFiles
	local ret := .f., descrFile := ::getDescr( className )
	
	return hb_FileExists( descrFile:FileName )

METHOD New() CLASS TStructFiles

	Local cClassName := '', aEtalonDB := {}, aIndex := { }, cName := '', cAlias := ''
	Local arr, xValue
                  
	If ::oSelf != Nil
		Return ::oSelf
	EndIf
  
	::hbFiles := hb_Hash()    // ᮧ���� ���ᨢ ��ꥪ⮢ ����⥫�� 䠩���

// ����� ��
	cClassName := Upper( 'TVersionDB' )
	cName := dir_server + 'VER_BASE' + sdbf
	aEtalonDB :=	{ ;
					{ 'VERSION',      'N',  10,   0 } ; 
					}             
	cAlias := 'VER'
	aIndex := { }
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '����� ��' ) )
//---------

// �ࠢ�筨� ���짮��⥫��
	cClassName := Upper( 'TUserDB' )
	cName := dir_server + 'base1' + sdbf
	aEtalonDB := 	{ ;
					{ 'P1',      'C',  20,   0 }, ; // �.�.�.
					{ 'P2',      'N',   1,   0 }, ; // ⨯ ����㯠
					{ 'P3',      'C',  10,   0 }, ; // ��஫�
					{ 'P4',      'C',   1,   0 }, ; // ��� �⤥����� [ chr(kod) ]
					{ 'P5',      'C',  20,   0 }, ; // ���������
					{ 'P6',      'N',   1,   0 }, ; // ��㯯� ��� (1-3)
					{ 'P7',      'C',  10,   0 }, ; // ��஫�1 ��� �᪠�쭮�� ॣ������
					{ 'P8',      'C',  10,   0 }, ; // ��஫�2 ��� �᪠�쭮�� ॣ������
					{ 'INN',     'C',  12,   0 }, ; // ��� �����
					{ 'IDROLE',	 'N',  4,	 0 } ; // ID ��㯯� ���짮��⥫��
					}
	cAlias := 'TUserDB'
	aIndex := { }
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ���짮��⥫�� ��⥬�' ) )

// �㩫 ��� ࠡ��� �����஢
	cClassName := Upper( 'TAudit_mainDB' )
	cName := dir_server + 'mo_oper' + sdbf
	aEtalonDB := 	{ ;
					{ 'PO',			'C',   1,   0 }, ; // ��� ������ asc(po)
					{ 'PD',			'C',   4,   0 }, ; // ��� ����� c4tod(pd)
					{ 'V0',			'C',   3,   0 }, ; // ���������� � ॣ�������
					{ 'VR',			'C',   3,   0 }, ; // ����� ४������      \
					{ 'VK',			'C',   3,   0 }, ; // ४������ �� ����⥪� => ft_unsqzn(V..., 6)
					{ 'VU',			'C',   3,   0 }, ; // ���� ���            /
					{ 'TASK',		'N',   1,   0 }, ; // ��� �����            /
					{ 'CS',			'C',   4,   0 }, ; // ������⢮ ������� ᨬ�����
					{ 'APP_EDIT',	'N',   1,   0};  // 0 - ����������, 1 - ।���஢����
					}
	cAlias := 'TAudit_mainDB'
	aIndex := { ;
				{ dir_server + 'mo_oper', 'pd + po + str( task, 1 ) + str( app_edit, 1 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��� ࠡ��� �����஢ ������' ) )

	cClassName := Upper( 'TAuditDB' )
	cName := dir_server + 'mo_opern' + sdbf
	aEtalonDB := 	{ ;
					{ 'PD',		'C',   4,   0}, ; // ��� ����� c4tod(pd)
					{ 'PO',		'C',   1,   0}, ; // ��� ������ asc(po)
					{ 'PT',		'C',   1,   0}, ; // ��� �����
					{ 'TP',		'C',   1,   0}, ; // ⨯ (1-����窠, 2-�/�, 3-��㣨)
					{ 'AE',		'C',   1,   0}, ; // 1-����������, 2-।���஢����, 3-㤠�����
					{ 'KK',		'C',   3,   0}, ; // ���-�� (����祪, �/� ��� ���)
					{ 'KP',		'C',   3,   0};  // ������⢮ ������� �����
					}
	cAlias := 'TAuditDB'
	aIndex := { ;
				{ dir_server + 'mo_opern', 'pd + po + pt + tp + ae' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��� ࠡ��� �����஢' ) )
	
	cClassName := Upper( 'TRoleUserDB' )
	cName := dir_server + 'Roles' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',    'C',  30,   0 }, ; // �������� ஫�
					{ 'ACL_TASK','C',  255,   0 }, ; // ����� � ����砬
					{ 'ACL_DEP', 'C',  255,   0 } ; // ����� � ��०�����
					}
	cAlias := 'TRoleUserDB'
	aIndex := { }
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ஫�� ���짮��⥫�� ��⥬�' ) )
//---------

// �ࠢ�筨� ��樥�⮢ 1
	cClassName := Upper( 'TPatientDB' )
	cName := dir_server + 'kartotek' + sdbf
	aEtalonDB :=	{ ;
					{ 'KOD',		'N',     7,     0 }, ;
					{ 'FIO',		'C',    50,     0 }, ; // �.�.�. ���쭮��
					{ 'POL',		'C',     1,     0 }, ; // ���
					{ 'DATE_R',		'D',     8,     0 }, ; // ��� ஦����� ���쭮��
					{ 'VZROS_REB',	'N',     1,     0 }, ; // 0-�����, 1-ॡ����, 2-�����⮪
					{ 'ADRES',		'C',    50,     0 }, ; // ���� ���쭮��
					{ 'MR_DOL',		'C',    50,     0 }, ; // ���� ࠡ��� ��� ��稭� ���ࠡ�⭮��
					{ 'RAB_NERAB',	'N',     1,     0 }, ; // 0-ࠡ���騩, 1-��ࠡ���騩
					{ 'KOMU',		'N',     1,     0 }, ; // �� 1 �� 5
					{ 'STR_CRB',	'N',     2,     0 }, ; // ��� ���.��������, ������ � �.�.
					{ 'ZA_SMO',		'N',     2,     0 }, ; // 0-���,'-8'-����� ������⢨⥫��,'-9'-�訡�� � ४������
					{ 'POLIS',		'C',    17,     0 }, ; // ��� � ����� ���客��� �����
					{ 'SROK_POLIS',	'C',     4,     0 }, ; // �ப ����⢨� �����
					{ 'MI_GIT',		'N',     1,     0 }, ; // 0-���, 9-ࠡ�祥 ���� KOMU
					{ 'RAJON_GIT',	'N',     2,     0 }, ; // ��� ࠩ��� ���� ��⥫��⢠
					{ 'MEST_INOG',	'N',     1,     0 }, ; // 0-���,9-�⤥��� ���
					{ 'RAJON',		'N',     2,     0 }, ; // ��� ࠩ��� 䨭���஢����
					{ 'BUKVA',		'C',     1,     0 }, ; // ���� �㪢�
					{ 'UCHAST',		'N',     2,     0 }, ; // ����� ���⪠
					{ 'KOD_VU',		'N',     5,     0 }, ; // ��� � ���⪥
					{ 'SNILS',		'C',    11,     0 }, ;
					{ 'DEATH',		'N',	1,		0 }, ; // 0-���,1-㬥� �� १���⠬ ᢥન
					{ 'KOD_TF',		'N',	10,		0 }, ; // ��� �� ����஢�� �����
					{ 'KOD_MIS',	'C',	20,		0 }, ; // ��� - ����� ����� ����� ���
					{ 'KOD_AK',		'C',	10,		0 }, ; // ᮡ�⢥��� ����� ���㫠�୮� �����
					{ 'TIP_PR',		'N',	1,		0 }, ; // ⨯/����� �ਪ९����� 1-�� WQ,2-�� ॥��� �� � ��,3-�� 䠩�� �ਪ९�����,4-��९�����,5-ᢥઠ
					{ 'MO_PR',		'C',	6,		0 }, ; // ��� �� �ਪ९�����
					{ 'DATE_PR',	'D',	8,		0 }, ; // ��� �ਪ९�����
					{ 'SNILS_VR',	'C',	11,		0 }, ; // ����� ���⪮���� ���
					{ 'PC1',		'C',	10,		0 }, ; // �� ����������:kod_polzovat+c4sys_date+hour_min(seconds())
					{ 'PC2',		'C',	10,		0 }, ; // 0-���,1-㬥� �� १���⠬ ᢥન
					{ 'PC3',		'C',	10,		0 }, ;
					{ 'PN1',		'N',	10,		0 }, ;
					{ 'PN2',		'N',	10,		0 }, ;
					{ 'PN3',		'N',	10,		0 } ;
				}
	cAlias := 'TPatientDB'
	aIndex :=	{ ;
				{ dir_server + 'kartotek', 'str( kod, 7 )' }, ;
				{ dir_server + 'kartoten', 'if( kod > 0, "1", "0" ) + upper( fio ) + dtos( date_r )' }, ;
				{ dir_server + 'kartotep', 'if( kod > 0, "1", "0" ) + polis' }, ;
				{ dir_server + 'kartoteu', 'strzero( uchast, 2 ) + strzero( kod_vu, 5 )' }, ;
				{ dir_server + 'kartotes', 'if( kod > 0, "1", "0" ) + snils' }, ;
				{ dir_server + 'kartotee', 'if( kod > 0, "1", "0" ) + kod_mis' } ;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��樥���, ᮤ�ন��� 䠩�� ����⥪�' ) )
//---------

// �ࠢ�筨� ��樥�⮢ 2
	cClassName := Upper( 'TPatientExtDB' )
	cName := dir_server + 'kartote_' + sdbf
	aEtalonDB :=	{ ;
				{ 'VPOLIS',		'N',  1, 0 }, ; // ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����;�� 㬮�砭�� 1 - ����
				{ 'SPOLIS',		'C', 10, 0 }, ; // ��� �����;;��� ���� - ࠧ������ �� �஡���
				{ 'NPOLIS',		'C', 20, 0 }, ; // ����� �����;;"��� �����த��� - ����� �� ""k_inog"" � ࠧ������"
				{ 'SMO',		'C',  5, 0 }, ; // ॥��஢� ����� ���;;�८�ࠧ����� �� ����� ����� � ����, ����த��� = 34
				{ 'BEG_POLIS',	'C',  4, 0 }, ; // ��� ��砫� ����⢨� ����� ;� �ଠ� dtoc4();"���� ""beg_polis"" �� 䠩�� ""k_inog"" ��� �����த���"
				{ 'STRANA',		'C',  3, 0 }, ; // �ࠦ����⢮ ��樥�� (��࠭�);�롮� �� �ࠢ�筨�� ��࠭;"���� ""strana"" �� 䠩�� ""k_inog"" ��� �����த���, ��� ��⠫��� ���� = ��"
				{ 'GOROD_SELO',	'N',  1, 0 }, ; // ��⥫�?;1-��த, 2-ᥫ�, 3-ࠡ�稩 ��ᥫ��;"���� ""gorod_selo"" �� 䠩�� ""pp_human"""
				{ 'VID_UD',		'N',  2, 0 }, ; // ��� 㤮�⮢�७�� ��筮��;�� ����஢�� �����
				{ 'SER_UD',		'C', 10, 0 }, ; // ��� 㤮�⮢�७�� ��筮��
				{ 'NOM_UD',		'C', 20, 0 }, ; // ����� 㤮�⮢�७�� ��筮��
				{ 'KEMVYD',		'N',  4, 0 }, ; // ��� �뤠� ���㬥��;"�ࠢ�筨� ""s_kemvyd"""
				{ 'KOGDAVYD',	'D',  8, 0 }, ; // ����� �뤠� ���㬥��
				{ 'KATEGOR',	'N',  3, 0 }, ; // ��⥣��� ��樥��
				{ 'KATEGOR2',	'N',  3, 0 }, ; // ��⥣��� ��樥�� (ᮡ�⢥���� ��� ��)
				{ 'MESTO_R',	'C',100, 0 }, ; // ���� ஦�����;;
				{ 'OKATOG',		'C', 11, 0 }, ; // ��� ���� ��⥫��⢠ �� �����;�롮� �� �ࠢ�筨�� �����;��������� ��ନ஢��� ��� ��襩 ������ �� ���� ࠩ���
				{ 'OKATOP',		'C', 11, 0 }, ; // ��� ���� �ॡ뢠��� �� �����;;
				{ 'ADRESP',		'C', 50, 0 }, ; // ���� ���� �ॡ뢠���;� �㤥� ������� ���⮪ ���� ���� �ॡ뢠���;
				{ 'DMS_SMO',	'N',  3, 0 }, ; // ��� ��� ���
				{ 'DMS_POLIS',	'C', 17, 0 }, ; // ��� ����� ���
				{ 'KVARTAL',	'C',  5, 0 }, ; // ����⠫ ��� ����᪮��
				{ 'KVARTAL_D',	'C',  5, 0 }, ; // ��� � ����⠫� ����᪮��
				{ 'PHONE_H',	'C', 11, 0 }, ; // ⥫�䮭 ����譨�
				{ 'PHONE_M',	'C', 11, 0 }, ; // ⥫�䮭 �������
				{ 'PHONE_W',	'C', 11, 0 }, ; // ⥫�䮭 ࠡ�稩
				{ 'KOD_LGOT',	'C',  3, 0 }, ; // ��� �죮�� �� ���
				{ 'IS_REGISTR',	'N',  1, 0 }, ; // ���� �� � ॣ���� ���;0-���, 1-����;
				{ 'PENSIONER',	'N',  1, 0 }, ; // ���� ���ᨮ��஬?;0-���, 1-��;
				{ 'INVALID',	'N',  1, 0 }, ; // ������������;0-���,1,2,3-�⥯���, 4-������� ����⢠;
				{ 'INVALID_ST',	'N',  1, 0 }, ; // �⥯��� �����������;1 ��� 2;
				{ 'BLOOD_G',	'N',  1, 0 }, ; // ��㯯� �஢�;�� 1 �� 4;
				{ 'BLOOD_R',	'C',  1, 0 }, ; // १��-䠪��;"+" ��� "-";
				{ 'WEIGHT',		'N',  3, 0 }, ; // ��� � ��;;
				{ 'HEIGHT',		'N',  3, 0 }, ; // ��� � �;;
				{ 'WHERE_KART',	'N',  1, 0 }, ; // ��� ���㫠�ୠ� ����;0-� ॣ�������, 1-� ���, 2-�� �㪠�
				{ 'GR_RISK',	'N',  3, 0 }, ; // ��㯯� �᪠ �� �⠭����� ��৤ࠢ�;;�᫨ ���� REGI_FL.DBF, � ����� �� ����
				{ 'DATE_FL',	'C',  4, 0 }, ; // ��� ��᫥���� ��ண�䨨;;�᫨ ���� REGI_FL.DBF, � ����� �� ����
				{ 'DATE_MR',	'C',  4, 0 }, ; // ��� ��᫥����� �㭨樯��쭮�� �楯�
				{ 'DATE_FR',	'C',  4, 0 };  // ��� ��᫥����� 䥤�ࠫ쭮�� �楯�
				}
	cAlias := 'TPatientExtDB'
	aIndex :=	{ ;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��樥���, ᮤ�ন��� 䠩�� ����⥪�. �������⥫쭠� ���ଠ�� 1' ) )
//---------

// �ࠢ�筨� ��樥�⮢ 3
	cClassName := Upper( 'TPatientAddDB' )
	cName := dir_server + 'kartote2' + sdbf
	aEtalonDB := { ;
				{ 'KOD_TF',    'N', 10,0 }, ; // ��� �� ����஢�� �����
				{ 'KOD_MIS',   'C', 20,0 }, ; // ��� - ����� ����� ����� ���
				{ 'KOD_AK',    'C', 10,0 }, ; // ᮡ�⢥��� ����� ���㫠�୮� ����� (����/���)
				{ 'TIP_PR',    'N',  1,0 }, ; // ⨯/����� �ਪ९����� 1-�� WQ,2-�� ॥��� �� � ��,3-�� 䠩�� �ਪ९�����,4-��९�����,5-ᢥઠ
				{ 'MO_PR',     'C',  6,0 }, ; // ��� �� �ਪ९�����
				{ 'DATE_PR',   'D',  8,0 }, ; // ��� �ਪ९�����
				{ 'SNILS_VR',  'C', 11,0 }, ; // ����� ���⪮���� ���
				{ 'PC1',       'C', 10,0 }, ; // �� ����������:kod_polzovat+c4sys_date+hour_min(seconds())
				{ 'PC2',       'C', 10,0 }, ; // 0-���,1-㬥� �� १���⠬ ᢥન
				{ 'PC3',       'C', 10,0 }, ; //
				{ 'PC4',       'C', 10,0 }, ; // ��� �ਪ९����� � ��
				{ 'PC5',       'C', 10,0 }, ; //
				{ 'PN1',       'N', 10,0 }, ; //
				{ 'PN2',       'N', 10,0 }, ; //
				{ 'PN3',       'N', 10,0};  //
				}
	cAlias := 'TPatientAddDB'
	aIndex :=	{ ;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��樥���, ᮤ�ন��� 䠩�� ����⥪�. �������⥫쭠� ���ଠ�� 2' ) )
//---------

// ���ଠ�� �� �࣠����樨
	cClassName := Upper( 'TOrganizationDB' )
	cName := dir_server + 'organiz' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD_TFOMS',	'C',	8,	0 }, ;
					{ 'NAME_TFOMS',	'C',	60,	0 }, ;
					{ 'UROVEN',		'N',	1,	0 }, ;
					{ 'NAME',		'C',  130,	0 }, ;
					{ 'NAME_SCHET',	'C',  130,	0 }, ;
					{ 'INN',			'C',   20,	0 }, ;
					{ 'ADRES',		'C',   70,	0 }, ;
					{ 'TELEFON',		'C',   20,	0 }, ;
					{ 'BANK',		'C',  130,	0 }, ;
					{ 'SMFO',		'C',   10,	0 }, ;
					{ 'R_SCHET',		'C',   45,	0 }, ;
					{ 'K_SCHET',		'C',   20,	0 }, ;
					{ 'OKONH',		'C',   15,	0 }, ;
					{ 'OKPO',		'C',   15,	0 }, ;
					{ 'E_1',			'C',	1,	0 }, ;
					{ 'NAME2',		'C',  130,	0 }, ;
					{ 'BANK2',		'C',  130,	0 }, ;
					{ 'SMFO2',		'C',   10,	0 }, ;
					{ 'R_SCHET2',	'C',   45,	0 }, ;
					{ 'K_SCHET2',	'C',   20,	0 }, ;
					{ 'OGRN',		'C',   15,	0 }, ;
					{ 'RUK_FIO',		'C',   60,	0 }, ;
					{ 'RUK',			'C',   20,	0 }, ;
					{ 'RUK_R',		'C',   20,	0 }, ;
					{ 'BUX',			'C',   20,	0 }, ;
					{ 'ISPOLNIT',	'C',   20,	0 }, ;
					{ 'NAME_D',		'C',   32,	0 }, ;
					{ 'FILIAL_H',	'N',	1,	0 } ;
					}
	cAlias := 'TOrganizationDB'
	aIndex := { }
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ���ᠭ�� �࣠����樨' ) )
//---------

// �ࠢ�筨� ��०�����
	cClassName := Upper( 'TDepartmentDB' )
	cName := dir_server + 'mo_uch' + sdbf
	aEtalonDB :=	{ ;
					{ 'KOD',       'N', 3, 0 }, ; // ���;;�� 'l_ucher'
					{ 'NAME',      'C',30, 0 }, ; // ������������;᮪�⨫� � 70 �� 30;'�� ''l_ucher'''
					{ 'SHORT_NAME','C', 5, 0 }, ; // ᮪�饭��� ������������;;
					{ 'IDCHIEF',   'N', 4,  0}, ;  // ����� ����� � 䠩�� mo_pers. ��뫪� �� �㪮����⥫� ��०�����
					{ 'ADDRESS',   'C', 150, 0}, ; // ���� ��宦����� ��०�����
					{ 'COMPET',    'C', 40, 0}, ; // ���㬥�� �⢥ত���� �㪮����⥫�
					{ 'IS_TALON',  'N', 1, 0 }, ; // ��०����� ࠡ�⠥� � ���⠫����?;0-���, 1-��;��⠢��� 0, ��� ���⠢��� 1 � ����ᨬ��� �� ���ᨢ� UCHER_TALON (�. c_allpub.prg ��ப� 273)
					{ 'DBEGIN',    'D', 8, 0 }, ; // ��� ��砫� ����⢨�;;���⠢��� 01.01.1993
					{ 'DEND',      'D', 8, 0 } ;  // ��� ����砭�� ����⢨�;;���⠢��� 31.12.2000, ��� ��⠢��� ����� � ����ᨬ��� �� ���ᨢ� UCHER_ARRAY (�. b_init.prg ��ப� 428 � �����)
				}             
	cAlias := 'TDepartmentDB'
	aIndex :=	{ ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��०�����' ) )
//---------

	cClassName := Upper( 'TSubdivisionDB' )
	cName := dir_server + 'mo_otd' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',       'N', 3, 0 }, ; // ���
					{ 'NAME',      'C',30, 0 }, ; // ������������
					{ 'KOD_LPU',   'N', 3, 0 }, ; // ��� ��०�����
					{ 'SHORT_NAME','C', 5, 0 }, ; // ᮪�饭��� ������������
					{ 'DBEGIN',    'D', 8, 0 }, ; // ��� ��砫� ����⢨� � ����� ���
					{ 'DEND',      'D', 8, 0 }, ; // ��� ����砭�� ����⢨� � ����� ���
					{ 'DBEGINP',   'D', 8, 0 }, ; // ��� ��砫� ����⢨� � ����� "����� ��㣨"
					{ 'DENDP',     'D', 8, 0 }, ; // ��� ����砭�� ����⢨� � ����� "����� ��㣨"
					{ 'DBEGINO',   'D', 8, 0 }, ; // ��� ��砫� ����⢨� � ����� "��⮯����"
					{ 'DENDO',     'D', 8, 0 }, ; // ��� ����砭�� ����⢨� � ����� "��⮯����"
					{ 'PLAN_VP',   'N', 6, 0 }, ; // ���� ��祡��� �ਥ���
					{ 'PLAN_PF',   'N', 6, 0 }, ; // ���� ��䨫��⨪
					{ 'PLAN_PD',   'N', 6, 0 }, ; // ���� �ਥ��� �� ����
					{ 'PROFIL',    'N', 3, 0 }, ; // ��䨫� ��� ������� �⤥�����;�� �ࠢ�筨�� V002, �� 㬮�砭�� �ய��뢠�� ��� � ���� ��� � � ����
					{ 'PROFIL_K',  'N', 3, 0 }, ; // ��䨫� ����� ��� ������� �⤥����� �� �ࠢ�筨�� V020, �� 㬮�砭�� �ய��뢠�� ��� � ���� ���
					{ 'IDSP',      'N', 2, 0 }, ; // ��� ᯮᮡ� ������ ���.����� ��� ������� �⤥�����;�� �ࠢ�筨�� V010
					{ 'IDUMP',     'N', 2, 0 }, ; // ��� �᫮��� �������� ����樭᪮� �����
					{ 'IDVMP',     'N', 2, 0 }, ; // ��� ����� ����樭᪮� �����
					{ 'TIP_OTD',   'N', 2, 0 }, ; // ⨯ ��-��: 1-���� �����
					{ 'KOD_PODR',  'C',25, 0 }, ; // ��� ���ࠧ������� �� ��ᯮ��� ���
					{ 'TIPLU',     'N', 2, 0 }, ; // ⨯ ���� ����: 0-�⠭����,1-���,2-���,3-���
					{ 'CODE_DEP',  'N', 3, 0 }, ; // ��� �⤥����� �� ����஢�� ����� �� �ࠢ�筨�� SprDep - 2018 ���
					{ 'ADRES_PODR','N', 2, 0 }, ; // ��� 㤠�񭭮�� ���ࠧ������� �� ���ᨢ� glob_arr_podr - 2017 ���
					{ 'ADDRESS',   'C',150,0 }, ; // ���� ��宦����� ��०�����
					{ 'CODE_TFOMS','C', 6, 0 }, ; // ��� ���ࠧ������� �� ����஢�� ����� - 2017 ���
					{ 'KOD_SOGL',  'N',10, 0 }, ; // ��� ᮣ��ᮢ���� ������ �⤥����� � �ணࠬ��� SDS
					{ 'SOME_SOGL', 'C',255,0 } ;  // ��� ᮣ��ᮢ���� ��᪮�쪨� �⤥����� � �ணࠬ��� SDS
					}
	cAlias := 'TSubdivisionDB'
	aIndex := { }
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �⤥�����' ) )

// ᯨ᮪ ���㤭����
	cClassName := Upper( 'TEmployeeDB' )
	cName := dir_server + 'mo_pers' + sdbf
	aEtalonDB :=	{ ;
				{ 'KOD',       'N',	4,	0 }, ; // ���
				{ 'UCH',       'N', 3,	0 }, ; // ��� ��०�����
				{ 'OTD',       'N', 3,	0 }, ; // ��� �⤥�����
				{ 'NAME_DOLJ', 'C',30,	0 }, ; // ������������ ��������
				{ 'KATEG',     'N', 1,	0 }, ; // ��� ��⥣�ਨ
				{ 'FIO',       'C',50,	0 }, ; // ���
				{ 'STAVKA',    'N', 4,	2 }, ; // �⠢��
				{ 'VID',       'N', 1,	0 }, ; // ��� ࠡ���;0-�᭮����, 1-ᮢ��饭��
				{ 'VR_KATEG',  'N', 1,	0 }, ; // ��� ��祡��� ��⥣�ਨ 'kateg'
				{ 'DOLJKAT',   'C',15,	0 }, ; // ������������ �������� �� ��⥣�ਨ
				{ 'D_KATEG',   'D', 8,	0 }, ; // ��� ���⢥ত���� ��⥣�ਨ
				{ 'SERTIF',    'N', 1,	0 }, ; // ����稥 ���䨪��;0-���, 1-��
				{ 'D_SERTIF',  'D', 8,	0 }, ; // ��� ���⢥ত���� ���䨪��
				{ 'PRVS',      'N', 9,	0 }, ; // ���樠�쭮��� ��� �� �ࠢ�筨�� V004
				{ 'PRVS_NEW',  'N', 4,	0 }, ; // ���樠�쭮��� ��� �� �ࠢ�筨�� V015
				{ 'PROFIL',    'N', 3,  0 }, ; // ��䨫� ��� ������ ᯥ樠�쭮�� �� �ࠢ�筨�� V002
				{ 'TAB_NOM',   'N', 5,	0 }, ; // ⠡���� �����
				{ 'SVOD_NOM',  'N', 5,	0 }, ; // ᢮��� ⠡���� ����� (��������, �᫨ � 祫����� ��᪮�쪮 ⠡.����஢, �ᯮ������ � ᢮���� ����⨪� �� ���㤭���)
				{ 'KOD_DLO',   'N', 5,	0 }, ; // ��� ��� ��� �믨᪨ �楯⮢ �� ���
				{ 'UROVEN',    'N', 2,	0 }, ; // �஢��� ������ (�� 1 �� 99)
				{ 'OTDAL',     'N', 1,	0 }, ; // �ਧ��� �⤠�������;0-���, 1-��
				{ 'SNILS',     'C',11,	0 }, ; // ����� ���
				{ 'DBEGIN',    'D', 8,	0 }, ; // ��� ��砫� ����⢨�
				{ 'DEND',      'D', 8,	0 } ;  // ��� ����砭�� ����⢨�
				}             
	cAlias := 'TEmployeeDB'
	aIndex :=	{ ;
				{ dir_server + 'mo_pers', 'str( tab_nom, 5 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ᯨ᪠ ���ᮭ���' ) )
//---------

// �������� ����筠� ��㤮������� ���ᮭ���
	cClassName := Upper( 'TPlannedMonthlyStaffDB' )
	cName := dir_server + 'uch_pers' + sdbf
	aEtalonDB :=	{ ;
				{ 'KOD',       'N',	4,	0 }, ; // ���
				{ 'GOD',       'N', 4,	0 }, ; // 
				{ 'MES',       'N', 4,	0 }, ; //
				{ 'M_TRUD',	   'N', 6,	1 } ; //
				}             
	cAlias := 'TPlannedMonthlyStaffDB'
	
	aIndex :=	{ ;
				{ dir_server + 'uch_pers', 'str( kod, 4 ) + str( god, 4 ) + str( mes, 2 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �������� ����筠� ��㤮������� ���ᮭ���' ) )
//---------

//�ࠢ�筨� ���������
	cClassName := Upper( 'TICD10DB' )
	cName := dir_exe + '_mo_mkb' + sdbf
	aEtalonDB :=	{ ;
				{ 'SHIFR',  'C',  6,   0 }, ;
				{ 'NAME',   'C', 65,  0 }, ;
				{ 'KS',     'N',  1,   0 }, ; 
				{ 'DBEGIN', 'D',  8,   0 }, ;
				{ 'DEND',   'D',  8,   0 }, ;
				{ 'POL',    'C',  1,   0 }  ;
				}             
	cAlias := 'DIAGDB'
	aIndex :=	{ ;
				{ cur_dir + '_MO_MKB', 'SHIFR + STR( KS, 1 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��������' ) )
//---------

//�ࠢ�筨� ��㯯 (����ᮢ) ���������
	cClassName := Upper( 'TICD10ClassDB' )
	cName := dir_exe + '_mo_mkbk' + sdbf
	aEtalonDB :=	{ ;
				{ 'KLASS',  'C',  5,   0 }, ;
				{ 'SH_B',   'C',  3,   0 }, ; 
				{ 'SH_E',   'C',  3,   0 }, ; 
				{ 'NAME',   'C', 65,  0 }, ;
				{ 'KS',     'N',  1,   0 }  ;
				}             
	cAlias := 'DIAGClassDB'
	aIndex :=	{ ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '����ᮢ ���������' ) )
//---------

//�ࠢ�筨� �����㯯 ���������
	cClassName := Upper( 'TICD10GroupDB' )
	cName := dir_exe + '_mo_mkbg' + sdbf
	aEtalonDB :=	{ ;
				{ 'SH_B',   'C',  3,   0 }, ; 
				{ 'SH_E',   'C',  3,   0 }, ; 
				{ 'NAME',   'C', 65,  0 }, ;
				{ 'KS',     'N',  1,   0 }  ;
				}             
	cAlias := 'DIAGGroupDB'
	aIndex :=	{ ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��㯯� ���������' ) )
//---------

// �ࠢ�筨� �㦡 �࣠����樨
	cClassName := Upper( 'TSlugbaDB' )
	cName := dir_server + 'slugba' + sdbf
	aEtalonDB := 	{ ;
					{ 'SHIFR',      'N',      3,      0 }, ;
					{ 'NAME',       'C',     40,      0 } ;
					}
	cAlias := 'TSlugbaDB'
	aIndex := { ;
				{ dir_server + 'slugba', 'STR( SHIFR, 3 )' } ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �㦡 �࣠����樨' ) )
//---------

// �ࠢ�筨� ��樮��஢ ��⥩-���
	cClassName := Upper( 'TStddsDB' )
	cName := dir_server + 'mo_stdds' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',    250,      0 }, ;
					{ 'ADRES',      'C',    250,      0 }, ;
					{ 'VEDOM',      'N',      1,      0 }, ;
					{ 'FED_KOD',    'N',     10,      0 } ;
					}
	cAlias := 'TStddsDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ��樮��஢ ��⥩-���' ) )
//---------

// �ࠢ�筨� ��ࠧ���⥫��� ��०�����
	cClassName := Upper( 'TSchoolDB' )
	cName := dir_server + 'mo_schoo' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',     30,      0 }, ;
					{ 'FNAME',      'C',    250,      0 }, ;
					{ 'ADRES',      'C',    250,      0 }, ;
					{ 'TIP',        'N',      1,      0 }, ;
					{ 'FED_KOD',    'N',     10,      0 } ;
					}
	cAlias := 'TSchoolDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ��ࠧ���⥫��� ��०�����' ) )
//---------

// �ࠢ�筨� ������ ��ப
	cClassName := Upper( 'TAddressStringDB' )
	cName := dir_server + 's_adres' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',     40,      0 } ;
					}
	cAlias := 'TAddressStringDB'
	aIndex := { ;
				{ dir_server + 's_adres', 'UPPER( name )' } ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ������ ᮪�饭��' ) )
//---------

// �ࠢ�筨� �࣠��� ��� �뤠��� ���㬥���
	cClassName := Upper( 'TPublisherDB' )
	cName := dir_server + 's_kemvyd' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',     150,      0 } ;
					}
	cAlias := 'TPublisherDB'
	aIndex := { ;
				{ dir_server + 's_kemvyd', 'UPPER( name )' } ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �࣠��� ��� �뤠��� ��������' ) )
//---------

// �ࠢ�筨� ���� ࠡ���
	cClassName := Upper( 'TPlaceOfWorkDB' )
	cName := dir_server + 's_mr' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',     50,      0 } ;
					}
	cAlias := 'TPlaceOfWorkDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ���� ࠡ���' ) )
//---------

// �ࠢ�筨� ���� ��������
	cClassName := Upper( 'TInsuranceCompanyDB' )
	cName := dir_server + 'str_komp' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',        'N',      2,      0 }, ;
					{ 'NAME',       'C',     30,      0 }, ;
					{ 'FNAME',      'C',     70,      0 }, ;
					{ 'INN',        'C',     20,      0 }, ;
					{ 'ADRES',      'C',     50,      0 }, ;
					{ 'TELEFON',    'C',      8,      0 }, ;
					{ 'BANK',       'C',     70,      0 }, ;
					{ 'SMFO',       'C',     10,      0 }, ;
					{ 'R_SCHET',    'C',     45,      0 }, ;
					{ 'K_SCHET',    'C',     20,      0 }, ;
					{ 'OKONH',      'C',     15,      0 }, ;
					{ 'OKPO',       'C',     15,      0 }, ;
					{ 'TFOMS',      'N',      2,      0 }, ;
					{ 'PARAKL',     'N',      1,      0 }, ;
					{ 'IST_FIN',    'N',      1,      0 } ;
					}
	cAlias := 'TInsuranceCompanyDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� ���� ��������' ) )
//---------

// �ࠢ�筨� ���客�� �������� ���
	cClassName := Upper( 'TCompanyDMSDB' )
	cName := dir_server + 'p_d_smo' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',     30,      0 }, ;
					{ 'FNAME',      'C',     70,      0 }, ;
					{ 'INN',        'C',     20,      0 }, ;
					{ 'ADRES',      'C',    100,      0 }, ;
					{ 'TELEFON',    'C',      8,      0 }, ;
					{ 'BANK',       'C',    100,      0 }, ;
					{ 'SMFO',       'C',     10,      0 }, ;
					{ 'R_SCHET',    'C',     45,      0 }, ;
					{ 'K_SCHET',    'C',     20,      0 }, ;
					{ 'N_DOG',      'C',     30,      0 }, ;
					{ 'D_DOG',      'D',      8,      0 } ;
					}
	cAlias := 'TCompanyDMSDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� ���客�� �������� ���' ) )
//---------

// �ࠢ�筨� �������� ��� ����������
	cClassName := Upper( 'TCompanyVzaimDB' )
	cName := dir_server + 'p_pr_vz' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',       'C',     30,      0 }, ;
					{ 'FNAME',      'C',     70,      0 }, ;
					{ 'INN',        'C',     20,      0 }, ;
					{ 'ADRES',      'C',    100,      0 }, ;
					{ 'TELEFON',    'C',      8,      0 }, ;
					{ 'BANK',       'C',    100,      0 }, ;
					{ 'SMFO',       'C',     10,      0 }, ;
					{ 'R_SCHET',    'C',     45,      0 }, ;
					{ 'K_SCHET',    'C',     20,      0 }, ;
					{ 'N_DOG',      'C',     30,      0 }, ;
					{ 'D_DOG',      'D',      8,      0 } ;
					}
	cAlias := 'TCompanyVzaimDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� �������� ��� ���������⮢' ) )
//---------

// �ࠢ�筨� �����⮢
	cClassName := Upper( 'TCommitteeDB' )
	cName := dir_server + 'komitet' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',        'N',      2,      0 }, ;
					{ 'NAME',       'C',     30,      0 }, ;
					{ 'FNAME',      'C',     70,      0 }, ;
					{ 'INN',        'C',     20,      0 }, ;
					{ 'ADRES',      'C',     50,      0 }, ;
					{ 'TELEFON',    'C',      8,      0 }, ;
					{ 'BANK',       'C',     70,      0 }, ;
					{ 'SMFO',       'C',     10,      0 }, ;
					{ 'R_SCHET',    'C',     45,      0 }, ;
					{ 'K_SCHET',    'C',     20,      0 }, ;
					{ 'OKONH',      'C',     15,      0 }, ;
					{ 'OKPO',       'C',     15,      0 }, ;
					{ 'PARAKL',     'N',      1,      0 }, ;
					{ 'IST_FIN',    'N',      1,      0 } ;
					}
	cAlias := 'TCommitteeDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� �����⮢' ) )
//---------

// �ࠢ�筨� ��㯯� ��� ��� ᯮᮡ� ������ = 5
	cClassName := Upper( 'TUSL_U5DB' )
	cName := dir_server + 'u_usl_5' + sdbf
	aEtalonDB := 	{ ;
					{ 'TIP',		'N',  2, 0 }, ;
					{ 'USL_1',		'C', 10, 0 }, ;
					{ 'USL_2',		'C', 10, 0 }, ;
					{ '_USL_1',		'C', 20, 0 }, ;
					{ '_USL_2',		'C', 20, 0 }, ;
					{ 'PROCENT',	'N',  5, 2 }, ;
					{ 'PROCENT2',	'N',  5, 2 }, ;
					{ 'RAZRYAD',	'N',  2, 0 }, ;
					{ 'OTDAL',		'N',  1, 0 } ;
					}
	cAlias := 'TUSL_U5DB'
	aIndex := { }
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��㯯� ��� ��� ᯮᮡ� ������ = 5' ) )
//---------

// �ࠢ�筨� �ਢ離� ���⪮��� ��祩 � ���⪠�
	cClassName := Upper( 'TDistrictDoctorDB' )
	cName := dir_server + 'mo_uchvr' + sdbf
	aEtalonDB := 	{ ;
					{ 'UCH',	'N',	2,	0 }, ;
					{ 'IS',		'N',	2,	0 }, ;
					{ 'VRACH',	'N',	4,	0 }, ;
					{ 'VRACHV',	'N',	4,	0 }, ;
					{ 'VRACHD',	'N',	4,	0 } ;
					}
	cAlias := 'TDistrictDoctorDB'
	aIndex := { ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ਢ離� ���⪮��� ��祩 � ���⪠�' ) )
//---------

	cClassName := Upper( 'TServiceDB' )
	cName := dir_server + 'uslugi' + sdbf
	aEtalonDB :=	{ ;
				{ 'KOD',     'N',  4,	0 }, ;
				{ 'KOD_UP',  'N',  4,	0 }, ;
				{ 'NAME',    'C', 65,	0 }, ;
				{ 'SHIFR',   'C', 10,	0 }, ;
				{ 'SHIFR1',  'C', 10,	0 }, ;
				{ 'SLUGBA',  'N',  3,	0 }, ;
				{ 'CENA',    'N', 10,	2 }, ;
				{ 'CENA_D',  'N', 10,	2 }, ;
				{ 'PCENA',   'N', 10,	2 }, ;
				{ 'PCENA_D', 'N', 10,	2 }, ;
				{ 'DMS_CENA','N', 10,	2 }, ;
				{ 'PNDS',    'N', 10,	2 }, ;
				{ 'PNDS_D',  'N', 10,	2 }, ;
				{ 'IS_NUL',  'L',  1,	0 }, ;
				{ 'IS_NULP', 'L',  1,	0 }, ;
				{ 'GRUPPA',  'N',  1,	0 }, ;
				{ 'ZF',      'N',  1,	0 }, ;
				{ 'FULL_NAME','C', 255, 0 }, ;
				{ 'PROFIL',  'N',  3,	0 } ;  // ��䨫�;�� �ࠢ�筨�� V002
				}             
	cAlias := 'TServiceDB'
	aIndex :=	{ ;
				{ dir_server + 'uslugi', 'str( kod, 4 )' }, ;
				{ dir_server + 'uslugish', 'shifr' }, ;
				{ dir_server + 'uslugis1', 'IIF(Empty( shifr1 ), shifr, shifr1 )' }, ;
				{ dir_server + 'uslugisl', 'Str( slugba, 3 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ���' ) )
//---------

	cClassName := Upper( 'TIntegratedServiceDB' )
	cName := dir_server + 'uslugi_k' + sdbf
	aEtalonDB :=	{ ;
				{ 'SHIFR',		'C',	10,	0 }, ;	// ��� ��㣨
				{ 'NAME',		'C',	60,	0 }, ;	// ������������ ��㣨
				{ 'KOD_VR',		'N',	4,	0 }, ;  // ��� ���
				{ 'KOD_AS',		'N',	4,	0 } ;  // ��� ����⥭�
				}             
	cAlias := 'TIntegratedServiceDB'
	aIndex :=	{ ;
				{ dir_server + 'uslugi_k', 'SHIFR' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ��� ���������� ���' ) )
//---------

	cClassName := Upper( 'TComponentsIntegratedServiceDB' )
	cName := dir_server + 'uslugi1k' + sdbf
	aEtalonDB :=	{ ;
				{ 'SHIFR',		'C',	10,	0 }, ;	// ��� �������᭮� ��㣨
				{ 'SHIFR1',		'C',	10,	0 } ;	// ��� �室�饩 ��㣨
				}             
	cAlias := 'TComponentsIntegratedServiceDB'
	aIndex :=	{ ;
				{ dir_server + 'uslugi1k', 'SHIFR + SHIFR1' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� c��⠢� ���������� ���' ) )
//---------

// �ࠢ�筨� ��� ��� ��祩 � ����⥭⮢
	cClassName := Upper( 'TServiceWoDoctorDB' )
	cName := dir_server + 'usl_uva' + sdbf
	aEtalonDB := 	{ ;
					{ 'SHIFR',	'C',	10,	0 }, ; // ��� ��㣨 (蠡���)
					{ 'KOD_VR',	'N',	1,	0 }, ; // �� ������� ��� ��� ?
					{ 'KOD_AS',	'N',	1,	0 }, ; // �� ������� ��� ����⥭� ?
					{ 'KOD_VRN','N',	1,	0 }, ; // �� ������� ��� ���ࠢ��襣� ��� ?
					{ 'KOD_ASN','N',	1,	0 }	; // �� ������� ��� ���ࠢ��襣� ����⥭� ?
					}
	cAlias := 'TServiceWoDoctorDB'
	aIndex := { ;
				{ dir_server + 'usl_uva', 'shifr' } ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ��� ��� ��祩 � ����⥭⮢' ) )
//---------

// �ࠢ�筨� ��ᮬ��⨬�� ���
	cClassName := Upper( 'TCompostionIncompServiceDB' )
	cName := dir_server + 'ns_usl' + sdbf
	aEtalonDB := 	{ ;
					{ 'NAME',	'C',	30,	0 }, ; // 
					{ 'KOL',	'N',	6,	0 } ; // 
					}
	cAlias := 'TCompostionIncompServiceDB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ��ᮢ������ ���' ) )
//---------

// �ࠢ�筨� ���������� ���
	cClassName := Upper( 'TIncompatibleServiceDB' )
	cName := dir_server + 'ns_usl_k' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',	'N',	6,	0 }, ; // 
					{ 'SHIFR',	'C',	10,	0 } ; // 
					}
	cAlias := 'TIncompatibleServiceDB'
	aIndex := { ;
				{ dir_server + 'ns_usl_k', 'STR( kod, 6 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ���������� ���' ) )
//---------

// �ࠢ�筨� ��㣨 �����ࠢ� �� (�����) // ��㯯� 䠩���
	cClassName := Upper( 'TServiceFFOMSDB' )
	cName := exe_dir + '_mo_uslf' + sdbf
	aEtalonDB := 	{ ;
					{ 'SHIFR',		'C',	20,	0 }, ; // 
					{ 'NAME',		'C',  255,	0 }, ; // 
					{ 'DATEBEG',	'D',	8,	0 }, ; // 
					{ 'DATEEND',	'D',	8,	0 } ; // 
					}
	cAlias := 'TServiceFFOMSDB'
	aIndex := { ;
				{ cur_dir + '_mo_uslf', 'shifr' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ��� �����' ) )
//---------

// �ࠢ�筨� ��㣨 �����ࠢ� �� (�����) 2017 // ��㯯� 䠩���
	cClassName := Upper( 'TServiceFFOMS7DB' )
	cName := exe_dir + '_mo7uslf' + sdbf
	aEtalonDB := 	{ ;
					{ 'SHIFR',		'C',	20,	0 }, ; // 
					{ 'NAME',		'C',  255,	0 }, ; // 
					{ 'TIP',		'N',	1,	0 }, ; // 
					{ 'GRP',		'N',	1,	0 }, ; // 
					{ 'UETV',		'N',	5,	2 }, ; // 
					{ 'UETD',		'N',	5,	2 }, ; // 
					{ 'DATEBEG',	'D',	8,	0 }, ; // 
					{ 'DATEEND',	'D',	8,	0 } ; // 
					}
	cAlias := 'TServiceFFOMS7DB'
	aIndex := { ;
				{ cur_dir + '_mo7uslf', 'shifr' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ��� ����� 2017' ) )
//---------

// �ࠢ�筨� ᮢ��饭�� ���� ��� � ��㣠�� �����ࠢ� �� (�����)
	cClassName := Upper( 'TMo_suDB' )
	cName := dir_server + 'mo_su' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',		'N',	6,	0 }, ;	// 
					{ 'NAME',		'C',	65,	0 }, ;	// 
					{ 'SHIFR',		'C',	10,	0 }, ;	// 
					{ 'SHIFR1',		'C',	20,	0 }, ;	// 
					{ 'TIP',		'N',	1,	0 }, ;	// 5-��� �⮬��.��� 2016 ����
					{ 'SLUGBA',		'N',	3,	0 }, ;	// 
					{ 'ZF',			'N',	1,	0 }, ;	// 
					{ 'PROFIL',		'N',	3,	0 } ;	// ��䨫�;�� �ࠢ�筨�� V002
					}
	cAlias := 'TMo_suDB'
	aIndex := { ;
				{ dir_server + 'mo_su', 'STR( kod, 6 )' }, ;
				{ dir_server + 'mo_sush', 'shifr' }, ;
				{ dir_server + 'mo_sush1', 'shifr + STR( tip, 1 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ᮢ��饭�� ���� ��� � ��㣠�� �����ࠢ� �� (�����)' ) )
//---------

// �ࠢ�筨� ��� �� ���ࠧ�������
	cClassName := Upper( 'TServiceBySubdivisionDB' )
	cName := dir_server + 'usl_otd' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',		'N',	4,	0 }, ;	// 
					{ 'OTDEL',		'C',	255,0 } ;	// 
					}
	cAlias := 'TServiceBySubdivisionDB'
	aIndex := { ;
				{ dir_server + 'usl_otd', 'STR( kod, 4 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� �ࠢ�筨�� ��� �� ���ࠧ�������' ) )
//---------

// 䠩� ᮤ�ঠ騩 ����� �������
	cClassName := Upper( 'TContractDB' )
	cName := dir_server + 'hum_p' + sdbf
	aEtalonDB := { ;
					{ 'KOD_K'     ,   'N',     7,     0 }, ; // ��� �� ����⥪�
					{ 'N_KVIT'    ,   'N',     5,     0 }, ; // ����� ���⠭樮���� ������
					{ 'KV_CIA'    ,   'N',     6,     0 }, ; // ����� ���⠭樨
					{ 'KOD_DIAG'  ,   'C',     5,     0 }, ; // ��� 1-�� ��.�������
					{ 'SOPUT_B1'  ,   'C',     5,     0 }, ; // ��� 1-�� ᮯ������饩 �������
					{ 'SOPUT_B2'  ,   'C',     5,     0 }, ; // ��� 2-�� ᮯ������饩 �������
					{ 'SOPUT_B3'  ,   'C',     5,     0 }, ; // ��� 3-�� ᮯ������饩 �������
					{ 'SOPUT_B4'  ,   'C',     5,     0 }, ; // ��� 4-�� ᮯ������饩 �������
					{ 'SOPUT_B5'  ,   'C',     5,     0 }, ; // ��� 5-�� ᮯ������饩 �������
					{ 'LPU'       ,   'N',     3,     0 }, ; // ��� ��०�����
					{ 'OTD'       ,   'N',     3,     0 }, ; // ��� �⤥�����
					{ 'N_DATA'    ,   'D',     8,     0 }, ; // ��� ��砫� ��祭��
					{ 'K_DATA'    ,   'D',     8,     0 }, ; // ��� ����砭�� ��祭��
					{ 'KOD_VR'    ,   'N',     4,     0 }, ; // ��� ���ࠢ��襣� ���
					{ 'CENA'      ,   'N',    10,     2 }, ; // �⮨����� ��祭��
					{ 'TIP_USL'   ,   'N',     1,     0 }, ; // 0-���⭠�, 1-�/����., 2-�/����
					{ 'PR_SMO'    ,   'N',     6,     0 }, ; // ��� �।����� / ���஢��쭮�� ���
					{ 'D_POLIS'   ,   'C',    25,     0 }, ; // ����� �� ���஢��쭮�� ����-��
					{ 'GP_NOMER'  ,   'C',    16,     0 }, ; // � ��࠭⨩���� ���쬠 �� ���
					{ 'GP_DATE'   ,   'D',     8,     0 }, ; // ��� ��࠭⨩���� ���쬠 �� ���
					{ 'GP2NOMER'  ,   'C',    16,     0 }, ; // � 2-�� ��࠭⨩���� ���쬠 �� ���
					{ 'GP2DATE'   ,   'D',     8,     0 }, ; // ��� 2-�� ��࠭⨩���� ���쬠 �� ���
					{ 'PDATE'     ,   'C',     4,     0 }, ; // ��� ������ ��㣨
					{ 'DATE_VOZ'  ,   'C',     4,     0 }, ; // ��� ������
					{ 'SUM_VOZ'   ,   'N',    10,     2 }, ; // �㬬� ������
					{ 'SBANK'     ,   'N',    10,     2 }, ; // �㬬�, ����祭��� �� ������᪮� ����
					{ 'DATE_CLOSE',   'D',     8,     0 }, ; // ��� ������� ���� ���
					{ 'IS_KAS'    ,   'N',     1,     0 }, ; // ����(0-��� �����,1-祪,2-��� 祪�)
					{ 'PLAT_FIO'  ,   'C',    40,     0 }, ; // ��� ���⥫�騪�
					{ 'PLAT_INN'  ,   'C',    12,     0 }, ; // ��� ���⥫�騪�
					{ 'FR_DATA'   ,   'C',     4,     0 }, ; // ��� �����
					{ 'FR_TIME'   ,   'N',     5,     0 }, ; // �६� �����
					{ 'KOD_OPER'  ,   'N',     3,     0 }, ; // ��� ������
					{ 'FR_ZAVOD'  ,   'C',    16,     0 }, ; // ���.����� �����
					{ 'FR_TIP'    ,   'N',     1,     0 }, ; // ⨯ �����
					{ 'VZFR_DATA' ,   'C',     4,     0 }, ; // ������ ��� �����
					{ 'VZFR_TIME' ,   'N',     5,     0 }, ; // ������ �६� �����
					{ 'VZKOD_OPER',   'N',     3,     0 }, ; // ������ ��� ������
					{ 'VZFR_ZAVOD',   'C',    16,     0 }, ; // ������ ���.����� �����
					{ 'VZFR_TIP'  ,   'N',     1,     0 }, ; // ������ ⨯ �����
					{ 'FR_TIPKART',   'N',     1,     0 }, ; // ��� ������᪮� �����
					{ 'I_POST'    ,   'C',    30,     0 } ;  // ���஭��� ����
				}
	cAlias := 'TContractDB'
    && index on str(kod_k,7)+dtos(k_data)+str(KV_CIA,6) to (dir_server+"hum_pkk") descending progress
    && index on str(otd,3) to (dir_server+"hum_pn") progress
    && index on dtos(k_data) to (dir_server+"hum_pd") progress
    && index on str(n_kvit,5) to (dir_server+"hum_pv") progress
    && index on str(tip_usl,1)+iif(empty(date_close),"0"+dtos(k_data),;
             && "1"+dtos(date_close))+dtos(k_data) to (dir_server+"hum_pc") progress
	aIndex := { ;
				{ dir_server + 'hum_pkk', 'str( kod_k, 7 ) + dtos( k_data ) + str( KV_CIA, 6 )' }, ;
				{ dir_server + 'hum_pn', 'str( otd, 3 )' }, ;
				{ dir_server + 'hum_pd', 'dtos( k_data )' }, ;
				{ dir_server + 'hum_pv', 'str( n_kvit, 5 )' }, ;
				{ dir_server + 'hum_pc', 'str( tip_usl, 1 ) + iif( empty( date_close ), "0" + dtos( k_data ), "1" + dtos( date_close ) ) + dtos( k_data )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩 ᮤ�ঠ騩 ����� �������' ) )
//---------

	cClassName := Upper( 'TContractPayerDB' )
	cName := dir_server + 'hum_plat' + sdbf
	aEtalonDB :=	{ ;
					{ 'KOD',		'N',	7,		0 }, ;	// ��� ���� ��� (�� �� hum_p)
					{ 'ADRES',		'C',	50,		0 }, ;	// ���� ���⥫�騪�
					{ 'PASPORT',	'C',	15,		0 }, ;  // ��ᯮ�� ���⥫�騪�
					{ 'I_POST',		'C',	30,		0 }, ;  // ���஭��� ���� 01.17
					{ 'PHONE',		'C',	11,		0 } ;	// ⥫�䮭 
				}             
	cAlias := 'TContractPayerDB'
	aIndex := { ;
				{ dir_server + 'hum_plat', 'str( KOD, 7 )' } ;
			}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ����뢠�騩 ���⥫�騪�� ������ ���' ) )
//---------

// 䠩� ᮤ�ঠ騩 ��㣨 ��⠢���騥 ����� �������
	cClassName := Upper( 'TContractServiceDB' )
	cName := dir_server + 'hum_p_u' + sdbf
	aEtalonDB := { ;
				{ 'KOD',	'N',	7,	0 }, ; // ��� ���� ��� (�� �� hum_p)
				{ 'DATE_U',	'C',	4,	0 }, ; // ��� �������� ��㣨
				{ 'U_KOD',	'N',	4,	0 }, ; // ��� ��㣨
				{ 'U_CENA',	'N',	10,	2 }, ; // 業� ��㣨
				{ 'U_KOEF',	'N',	5,	3 }, ; // ����-� ������樨 ��㣨
				{ 'KOD_VR',	'N',	4,	0 }, ; // ��� ���
				{ 'KOD_AS',	'N',	4,	0 }, ; // ��� ����⥭�
				{ 'MED1',	'N',	4,	0 }, ; // ��� ��������
				{ 'MED2',	'N',	4,	0 }, ; // ��� ��������
				{ 'MED3',	'N',	4,	0 }, ; // ��� ��������
				{ 'SAN1',	'N',	4,	0 }, ; // ��� ᠭ��ન
				{ 'SAN2',	'N',	4,	0 }, ; // ��� ᠭ��ન
				{ 'SAN3',	'N',	4,	0 }, ; // ��� ᠭ��ન
				{ 'KOL',	'N',	3,	0 }, ; // ������⢮ ���
				{ 'STOIM',	'N',	10,	2 }, ; // �⮣���� �⮨����� ��㣨
				{ 'T_EDIT',	'N',	1,	0 }, ; // ।���஢����� �� �㬬�
				{ 'OTD',	'N',	3,	0 } ;  // ��� �⤥�����
				}
	cAlias := 'TContractServiceDB'
	aIndex := { ;
				{ dir_server + 'hum_p_u', 'str( kod, 7 )' }, ;
				{ dir_server + 'hum_p_uk', 'str( u_kod, 4 )' }, ;
				{ dir_server + 'hum_p_ud', 'date_u' }, ;
				{ dir_server + 'hum_p_uv', 'str( kod_vr, 4 ) + date_u' }, ;
				{ dir_server + 'hum_p_ua', 'str( kod_as, 4 ) + date_u' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩 ��㣨 ��⠢���騥 ����� �������' ) )
//---------

// ��� ��������������
//
// 䠩� ᮤ�ঠ騩 ��뫪� �� 䠩�� ������
	cClassName := Upper( 'TExchangFile263' )
	cName := dir_server + 'mo_nfile' + sdbf
	aEtalonDB := { ;
				{ 'KOD',		'N', 6,0 }, ; // ��� 䠩��
				{ 'DATE_F',		'D', 8,0 }, ; // ��� 䠩��
				{ 'NAME_F',		'C',26,0 }, ; // ��� 䠩�� ��� ���७�� (� ZIP-��娢�)
				{ 'DATE_R',		'D', 8,0 }, ; // ����⭠� ���
				{ 'NN',			'N', 4,0 }, ; // ���浪��� ����� ����� �� ������� ����
				{ 'TIP_F',		'N', 1,0 }, ; // �� 1 �� 7 (������ �� I01 �� I07)
				{ 'IN_OUT',		'N', 1,0 }, ; // 1-� �����,2-�� �����
				{ 'DATE_OUT',	'D', 8,0 }, ; // ��� ��ࠢ�� � �����
				{ 'KOL',		'N', 6,0 }, ; // ������⢮ ��樥�⮢ � 䠩��
				{ 'DWORK',		'D', 8,0 }, ; // ��� ��ࠡ�⪨ 䠩��
				{ 'TWORK1',		'C', 5,0 }, ; // �६� ��砫� ��ࠡ�⪨
				{ 'TWORK2',		'C', 5,0 }, ; // �६� ����砭�� ��ࠡ�⪨
				{ 'TXT_F',		'C',15,0 }, ; // ��� ⥪�⮢��� 䠩�� ��⮪��� ��� ���७��
				{ 'D_ANS',		'D', 8,0 }, ; // ��� ��⮪��� �⢥� �� �����
				{ 'T_ANS',		'N', 1,0 } ;  // ⨯ �⢥� (0-�� �뫮, 1-��� ���, 2-�訡��)
				}
	cAlias := 'TExchangFile263'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩 ��뫪� �� 䠩�� ������' ) )
//---------

// 䠩� ᮤ�ঠ騩 ᯨ᮪ ���ࠢ�����
	cClassName := Upper( 'TNapravlenie263' )
	cName := dir_server + 'mo_nnapr' + sdbf
	aEtalonDB := { ;
				{ 'KOD',         'N', 6,0 }, ; // ��� ���ࠢ����� - ����� �����
				{ 'KOD_K',       'N', 7,0 }, ; // ��� �� ����⥪�
				{ 'N_NAPR',      'N', 6,0 }, ; // 㭨����� ����� ���ࠢ����� (�-��)
				{ 'NUM_D',       'C',15,0 }, ; // ����� ���ࠢ�����
				{ 'DATE_D',      'D', 8,0 }, ; // ��� ���ࠢ�����
				{ 'MCOD_1',      'C', 6,0 }, ; // ��� �����������
				{ 'CODEM_1',     'C', 6,0 }, ; // ��� �����������
				{ 'DS_1',        'C', 6,0 }, ; // ������� �����������
				{ 'USL_OK_1',    'N', 1,0 }, ; // �᫮��� �������� ���.����� 1-��樮���,2-������� ��樮���
				{ 'F_MEDC_1',    'N', 1,0 }, ; // �ଠ �������� ���.����� �� V014 (��� �-�� 2-���⫮���� � 3-��������)
				{ 'ID_1',        'C',36,0 }, ; // GUID+lstr(mo_nnapr->KOD) ID ���ࠢ�����
				{ 'DATE_H_1',    'D', 8,0 }, ; // ������㥬�� ��� ��ᯨ⠫���樨
				{ 'DISP_1',      'N', 1,0 }, ; // ���ࠢ����� �뤠�� �� १���⠬ ��ᯠ��ਧ�樨/���ᬮ�� ���᫮�� ��ᥫ����
				{ 'OTD_1',       'N', 3,0 }, ; // �⤥�����, ��� �믨ᠭ� ���ࠢ�����
				{ 'PROFIL_1',    'N', 3,0 }, ; // ��䨫� ���.����� �� �ࠢ�筨�� V002
				{ 'PROFIL_K_1',  'N', 3,0 }, ; // ��䨫� ����� �� �ࠢ�筨�� T007
				{ 'VRACH_1',     'N', 4,0 }, ; // ���騩 ��� �� mo_pers
				{ 'KOD_F_1OUT',  'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'KOD_F_1IN',   'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'T_ANS_1',     'N', 1,0 }, ; // 1-��ଠ�쭮, 2-�����㦥�� �訡�� �� �⢥� �� �����
				{ 'S_MCOD',      'C', 6,0 }, ; // ��� ��樮���
				{ 'S_CODEM',     'C', 6,0 }, ; //_��� ��樮���
				{ 'OTD_2',       'N', 3,0 }, ; // �⤥�����, �㤠 �������
				{ 'DATE_2',      'D', 8,0 }, ; // ��� ����� ���� ��ᯨ⠫���樨
				{ 'DATE_H_2',    'D', 8,0 }, ; // ��� ��ᯨ⠫���樨, ��।����� �� ��樮���
				{ 'KOD_F_2OUT',  'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'KOD_F_2IN',   'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'T_ANS_2',     'N', 1,0 }, ; // 1-��ଠ�쭮, 2-�����㦥�� �訡�� �� �⢥� �� �����
				{ 'INF_PAC',     'N', 1,0 }, ; //_�� ���ନ��� ��樥�� 1-���, 2-�����������
				{ 'TIP_ANNUL',   'N', 1,0 }, ; // �� ���㫨஢�� (1-���,2-���,3-���)
				{ 'REA_ANNUL',   'N', 2,0 }, ; // ��稭� ���㫨஢���� (�� 1 �� 9)
				{ 'DATE_3',      'D', 8,0 }, ; // ��� ���㫨஢����
				{ 'T_ANS_3',     'N', 1,0 }, ; // 1-��ଠ�쭮, 2-�����㦥�� �訡�� �� �⢥� �� �����
				{ 'KOD_F_3OUT',  'N', 6,0 }, ; //_��� 䠩�� - �� 䠩�� mo_nfile
				{ 'KOD_F_3IN',   'N', 6,0 }, ; //_��� 䠩�� - �� 䠩�� mo_nfile
				{ 'CODEM_FROM',  'C', 6,0 }, ; // �� ������ �� ���ࠢ��� (�-��, ��㣮� ��樮��� ��� ��� �� ��樮���)
				{ 'KOD_UP',      'N', 6,0 }, ; // ��� �।.���ࠢ����� (��᫥ ��ॢ��� � ��.��-��)
				{ 'KOD_PP',      'N', 7,0 }, ; // ��� �� �� ��񬭮�� �����
				{ 'TYPE_H_4',    'N', 1,0 }, ; // ���-��: 1-�� ���ࠢ�����, 2-��ॢ�� �� ��㣮�� ��, 3-��ॢ�� ����� ��襣� ��, 4-����./����. (I05)
				{ 'DATE_H_4',    'D', 8,0 }, ; // ॠ�쭠� ��� ��ᯨ⠫���樨
				{ 'TIME_H_4',    'C', 5,0 }, ; // �६� ��ᯨ⠫���樨
				{ 'DNEJ_H_4',    'N', 3,0 }, ; // ������㥬�� ������⢮ ���� ��ᯨ⠫���樨 (�� 㬮�砭�� 7)
				{ 'ID_4',        'C',36,0 }, ; // GUID+lstr(mo_nnapr->KOD) ID ��ᯨ⠫���樨 ��� tip_f=4
				{ 'OTD_4',       'N', 3,0 }, ; // �⤥�����, �㤠 ��������
				{ 'PROFIL_4',    'N', 3,0 }, ; // ��䨫� ���.����� �� �ࠢ�筨�� V002
				{ 'PROFIL_K_4',  'N', 3,0 }, ; // ��䨫� ����� �� �ࠢ�筨�� T007
				{ 'DS_4',        'C', 6,0 }, ; // ������� ��񬭮�� �⤥����� ��樮���
				{ 'USL_OK_4',    'N', 1,0 }, ; // �᫮��� �������� ���.����� 1-��樮���,2-������� ��樮���
				{ 'F_MEDC_4',    'N', 1,0 }, ; // �ଠ �������� ���.����� �� V014 (1-���७���, 2-���⫮����, 3-��������)
				{ 'NUM_HIST_4',  'C',50,0 }, ; // ����� ���ਨ �������
				{ 'T_ANS_4',     'N', 1,0 }, ; // 1-��ଠ�쭮, 2-�����㦥�� �訡�� �� �⢥� �� �����
				{ 'KOD_F_4OUT',  'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'KOD_F_4IN',   'N', 6,0 }, ; //_��� 䠩�� - �� 䠩�� mo_nfile
				{ 'TYPE_6',      'N', 1,0 }, ; // ���⨥: 1-�믨ᠭ, 2-㬥�, 3-��ॢ�� ����� ��襣� ��
				{ 'KOD_NEXT',    'N', 6,0 }, ; // ��� ᫥���饩 ��ᯨ⠫���樨 (��᫥ ��ॢ��� � ��.��-��)
				{ 'ID_6',        'C',36,0 }, ; // GUID+lstr(mo_nnapr->KOD) ID �믨᪨ ��� tip_f=6
				{ 'DATE_6',      'D', 8,0 }, ; // ��� �����
				{ 'T_ANS_6',     'N', 1,0 }, ; // 1-��ଠ�쭮, 2-�����㦥�� �訡�� �� �⢥� �� �����
				{ 'KOD_F_6OUT',  'N', 6,0 }, ; //_��� 䠩�� - �� 䠩�� mo_nfile
				{ 'KOD_F_6IN',   'N', 6,0 }, ; //_��� 䠩�� - �� 䠩�� mo_nfile
				{ 'DATE_R',      'D', 8,0 }, ; // ��� ஦�����
				{ 'SEX',         'N', 1,0 }, ; // ���
				{ 'ENP',         'C',16,0 } ;  // ����� ����� ����� ���
				}
	cAlias := 'TNapravlenie263'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩 ᯨ᮪ ���ࠢ�����' ) )
//---------

// 䠩� ᮤ�ঠ騩 ��뫪� �� 䠩�� ������+���ࠢ�����
	cClassName := Upper( 'TExchangFileNapravlenie263' )
	cName := dir_server + 'mo_nfina' + sdbf
	aEtalonDB := { ;
				{ 'KOD_F',	'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'KOD_N',	'N', 6,0 }, ; // ��� ���ࠢ����� - �� 䠩�� mo_nnapr
				{ 'OSHIB',	'N', 3,0 }, ; // ��� �訡��
				{ 'IM_POL',	'C',20,0 } ;  // ��� ����, � ���஬ �ந��諠 �訡��
				}
	cAlias := 'TExchangFileNapravlenie263'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩 ��뫪� �� 䠩�� ������+���ࠢ�����' ) )
//---------

// 䠩� ᮤ�ঠ騩 ��뫪� �� 䠩�� ������+���ࠢ�����
	cClassName := Upper( 'TNapr263' )
	cName := dir_server + 'mo_n7in' + sdbf
	aEtalonDB := { ;
				{ 'KOD_F',       'N', 6,0 }, ; // ��� 䠩�� - �� 䠩�� mo_nfile
				{ 'CODEM',       'C', 6,0 }, ; // ��� ��樮���
				{ 'ID_PL',       'C',36,0 }, ; // GUID �����
				{ 'USL_OK',      'N', 1,0 }, ; // �᫮��� �������� ���.����� 1-��樮���,2-������� ��樮���
				{ 'PROFIL_K',    'N', 3,0 }, ; // ��䨫� �����
				{ 'PROFIL',      'N', 3,0 }, ; // ��䨫� ���.�����
				{ 'KOL_KD',      'N', 3,0 }, ; // ���-�� ���� ��-㬮�砭�� �� ������� ��䨫� �����
				{ 'QUANTITY',    'N', 3,0 }, ; // ������⢮ ����
				{ 'Q_P',         'N', 3,0 }, ; // ���﫮 ��樥�⮢ �� ��砫� �।.��⮪
				{ 'Q_AP',        'N', 3,0 }, ; // ����㯨�� ��樥�⮢ �� �।.��⪨
				{ 'Q_DP',        'N', 3,0 }, ; // ��뫮 ��樥�⮢ �� �।.��⪨
				{ 'Q_HP',        'N', 3,0 }, ; // �������஢��� ��ᯨ⠫���権 �� ⥪.����
				{ 'PLACE_FREE',  'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M',        'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W',        'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C',        'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE1',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M1',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W1',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C1',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE2',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M2',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W2',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C2',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE3',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M3',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W3',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C3',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE4',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M4',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W4',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C4',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE5',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M5',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W5',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C5',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE6',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M6',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W6',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C6',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE7',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M7',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W7',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C7',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE8',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M8',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W8',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C8',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE9',      'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M9',       'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W9',       'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C9',       'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'PLACE10',     'N', 3,0 }, ; // ������⢮ ᢮������ ����
				{ 'PF_M10',      'N', 3,0 }, ; // --""-- ��� ��稭
				{ 'PF_W10',      'N', 3,0 }, ; // --""-- ��� ���騭
				{ 'PF_C10',      'N', 3,0 }, ; // --""-- ��� ��⥩
				{ 'V_H34001',    'N',15,0 }, ; // ������⢮ ��ᯨ⠫���権 ���
				{ 'V_H34002',    'N',15,0 }, ; // ������⢮ ��ᯨ⠫���権 ���
				{ 'V_H34006',    'N',15,0 }, ; // ������⢮ ��ᯨ⠫���権 ���
				{ 'V_H34007',    'N',15,0 } ; // ������⢮ ��ᯨ⠫���権 ���
				}
	cAlias := 'TNapr263'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩' ) )
	
	// � ᫥���饣� 䠩�� ������� �����筠
	cClassName := Upper( 'TNaprOut263' )
	cName := dir_server + 'mo_n7out' + sdbf
	cAlias := 'TNaprOut263'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '䠩� ᮤ�ঠ騩' ) )
	
//---------

// ���� ������
	cClassName := Upper( 'TExchangOneRecord263' )
	cName := dir_server + 'mo_n7d' + sdbf
	aEtalonDB := { ;
				{ 'DATE_R_EDI',	'D', 8,0 }, ; // ����⭠� ��� (�� ����� ��� ������)
				{ 'DATE_R_OUT',	'D', 8,0 }, ; // ����⭠� ��� (�� ����� ��� 㦥 ��ࠢ���)
				{ 'DATE_OUT',	'D', 8,0 }, ; // ��� ��᫥���� ��ࠢ��
				{ 'DATE_E',		'D', 8,0 }, ; // ��� ।���஢����
				{ 'TIME_E',		'C', 5,0 }, ; // �६� ।���஢����
				{ 'END_EDIT',	'N', 1,0 }, ; // 0-�� �����祭�, 1-�����祭� ।���஢����
				{ 'KOD_OPER',	'N', 3,0 } ;  // ��� ������
				}
	cAlias := 'TExchangOneRecord263'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ������' ) )
//---------
// ��� ��ᯨ⠫���樨
/////////////////

	// cClassName := Upper( 'TServiceUSL' )
	// cName := dir_server + 'uch_usl' + sdbf
	// aEtalonDB :=	{ ;
				// { 'KOD',		'N',	4,	0 }, ;	// ��� ��㣨
				// { 'VKOEF_V',	'N',	7,	4 }, ;	// ��� - ��� ��� ���᫮��
				// { 'AKOEF_V',	'N',	7,	4 }, ;  // ���. - ��� ��� ���᫮��
				// { 'VKOEF_R',	'N',	7,	4 }, ;  // ��� - ��� ��� ॡ����
				// { 'AKOEF_R',	'N',	7,	4 }, ;  // ���. - ��� ��� ॡ����
				// { 'KOEF_V',		'N',	7,	4 }, ;  // �⮣� ��� ��� ���᫮��
				// { 'KOEF_R',		'N',	7,	4 } ;   // �⮣� ��� ��� ॡ����
				// }             
	// cAlias := 'TServiceUSL'
	// aIndex :=	{ ;
				// { dir_server + 'uch_usl', 'str( KOD, 4 )' } ;
				// }
	// hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ��� ���' ) )
//---------

	// cClassName := Upper( 'TServiceUSL1' )
	// cName := dir_server + 'uch_usl' + sdbf
	// aEtalonDB :=	{ ;
				// { 'KOD',		'N',	4,	0 }, ;	// ��� ��㣨
				// { 'VKOEF_V',	'N',	7,	4 }, ;	// ��� - ��� ��� ���᫮��
				// { 'AKOEF_V',	'N',	7,	4 }, ;  // ���. - ��� ��� ���᫮��
				// { 'VKOEF_R',	'N',	7,	4 }, ;  // ��� - ��� ��� ॡ����
				// { 'AKOEF_R',	'N',	7,	4 }, ;  // ���. - ��� ��� ॡ����
				// { 'KOEF_V',		'N',	7,	4 }, ;  // �⮣� ��� ��� ���᫮��
				// { 'KOEF_R',		'N',	7,	4 }, ;   // �⮣� ��� ��� ॡ����
				// { 'DATE_B',		'D',	8,	0 } ;    // ��� ��砫� ����⢨�
				// }             
	// cAlias := 'TServiceUSL1'
	// aIndex :=	{ ;
				// { dir_server + 'uch_usl1', 'str( KOD, 4 ) + dtos( DATE_B )' } ;
				// }
	// hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���� ��� ���' ) )
//---------

// �ࠢ�筨� ��㯯� ��� ��� ᯮᮡ� ������ = 7
	// cClassName := Upper( 'TUSL_U7' )
	// cName := dir_server + 'u_usl_7' + sdbf
	// aEtalonDB := 	{ ;
					// { 'NAME',      'C',  20, 0 }, ;
					// { 'VARIANT',   'N',   1, 0 }, ;
					// { 'V_UET_OMS', 'N',   6, 2 }, ;
					// { 'A_UET_OMS', 'N',   6, 2 }, ;
					// { 'V_UET_PL',  'N',   6, 2 }, ;
					// { 'A_UET_PL',  'N',   6, 2 }, ;
					// { 'V_UET_DMS', 'N',   6, 2 }, ;
					// { 'A_UET_DMS', 'N',   6, 2 }, ;
					// { 'USL_INS',   'C', 110, 0 }, ;
					// { 'USL_DEL',   'C', 110, 0 } ;
					// }
	// cAlias := 'TUSL_U7'
	// aIndex := { }
	// hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '��㯯� ��� ��� ᯮᮡ� ������ = 7' ) )
//---------

//
// ����� ����������� � �������� ������
//

// �ࠢ�筨� _mo_form
	cClassName := Upper( 'T_MO_FORM' )
	cName := exe_dir + '_mo_form' + sdbf
	aEtalonDB := 	{ ;
					{ 'FORMA',		'N',	2, 0 }, ;
					{ 'TABLE',		'N',	4, 0 }, ;
					{ 'BOLD',		'N',	1, 0 }, ;
					{ 'NAME',		'C',  250, 0 }, ;
					{ 'STROKE',		'C',   10, 0 }, ;
					{ 'DIAGNOZ',	'C',   40, 0 } ;
					}
	cAlias := '_MO_FORM'
	aIndex := { ;
		;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� mo_form' ) )
//---------

// �ࠢ�筨� _mo_kek
	cClassName := Upper( 'T_MO_KEK' )
	cName := exe_dir + '_mo_kek' + sdbf
	aEtalonDB := 	{ ;
					{ 'SHIFR',		'C',	8, 0 }, ;
					{ 'NN',			'N',	3, 0 }, ;
					{ 'NAME',		'C',  118, 0 } ;
					}
	cAlias := '_MO_KEK'
	aIndex := { ;
		;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� mo_kek' ) )
//---------

// �ࠢ�筨� _mo_kekd
	cClassName := Upper( 'T_MO_KEKD' )
	cName := exe_dir + '_mo_kekd' + sdbf
	aEtalonDB := 	{ ;
					{ 'SHIFR',		'C',	8, 0 }, ;
					{ 'VZR',		'N',	1, 0 }, ;
					{ 'REB',		'N',	1, 0 }, ;
					{ 'NAME',		'C',  150, 0 } ;
					}
	cAlias := '_MO_KEKD'
	aIndex := { ;
		;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� mo_kekd' ) )
//---------

// �ࠢ�筨� ���ࠧ������� �� ��ᯮ�� ���
	cClassName := Upper( 'T_Mo_PodrDB' )
	cName := exe_dir + '_mo_podr' + sdbf
	aEtalonDB := 	{ ;
					{ 'CODEMO',		'C',	6, 0 }, ;
					{ 'OGRN',		'C',   13, 0 }, ;
					{ 'OIDMO',		'C',   27, 0 }, ;
					{ 'KODOTD',		'C',   25, 0 }, ;
					{ 'NAMEOTD',	'C',   76, 0 }, ;
					}
	cAlias := '_MO_PODRDB'
	aIndex := { ;
		{ cur_dir + '_mo_podr', 'codemo + padr( upper( kodotd ), 25 )' } ;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� ���ࠧ������� �� ��ᯮ�� ���' ) )
//---------

// �ࠢ�筨� _mo_smo
	cClassName := Upper( 'T_MO_SMODB' )
	cName := exe_dir + '_mo_smo' + sdbf
	aEtalonDB := 	{ ;
					{ 'OKATO',		'C',	5, 0 }, ;
					{ 'SMO',		'C',	5, 0 }, ;
					{ 'NAME',		'C',   70, 0 }, ;
					{ 'OGRN',		'C',   15, 0 }, ;
					{ 'D_BEGIN',	'D',	8, 0 }, ;
					{ 'D_END',		'D',	8, 0 } ;
					}
	cAlias := '_MO_SMO'
	aIndex := { ;
		{ cur_dir + '_mo_smo', 'okato + smo' }, ;
		{ cur_dir + '_mo_smo2', 'smo' }, ;
		{ cur_dir + '_mo_smo3', 'okato + ogrn' } ;
	}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� _mo_smo' ) )
//---------

// �ࠢ�筨� _okatoo
	cClassName := Upper( 'T_OKATOODB' )
	cName := exe_dir + '_okatoo' + sdbf
	aEtalonDB := 	{ ;
					{ 'OKATO',		'C',	5,	0 }, ;
					{ 'NAME',		'C',   72,	0 }, ;
					{ 'FL_VIBOR',	'N',	1,	0 }, ;
					{ 'FL_ZAGOL',	'N',	1,	0 }, ;
					{ 'TIP',		'N',	1,	0 }, ;
					{ 'SELO',		'N',	1,	0 } ;
					}
	cAlias := 'OBLAST'
	aIndex := { ;
				{ cur_dir + '_okato', 'okato' }, ;
				{ cur_dir + '_okaton', 'substr( okato, 1, 5 ) + upper( substr( name, 1, 30 ) )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� ����� �����⥩' ) )
//---------

// �ࠢ�筨� _okatoo8
	cClassName := Upper( 'T_OKATOO8DB' )
	cName := exe_dir + '_okatoo8' + sdbf
	aEtalonDB := 	{ ;
					{ 'OKATO',		'C',	5,	0 }, ;
					{ 'NAME',		'C',   72,	0 }, ;
					{ 'FL_VIBOR',	'N',	1,	0 }, ;
					{ 'FL_ZAGOL',	'N',	1,	0 }, ;
					{ 'TIP',		'N',	1,	0 }, ;
					{ 'SELO',		'N',	1,	0 } ;
					}
	cAlias := '_OKATOO8'
	aIndex := { ;
				{ cur_dir + '_okato8', 'okato' }, ;
				{ cur_dir + '_okaton8', 'substr( okato, 1, 5 ) + upper( substr( name, 1, 30 ) )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� _okatoo8' ) )
//---------

// �ࠢ�筨� _okator
	cClassName := Upper( 'T_OKATORDB' )
	cName := exe_dir + '_okator' + sdbf
	aEtalonDB := 	{ ;
					{ 'OKATO',		'C',	2,	0 }, ;
					{ 'NAME',		'C',   72,	0 } ;
					}
	cAlias := 'REGION'
	aIndex := { ;
				{ cur_dir + '_okatr', 'okato' }, ;
				{ cur_dir + '_okatrn', 'okato + upper( substr( name, 1, 30 ) )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� ����� ॣ�����' ) )
//---------

// �ࠢ�筨� _okatos
	cClassName := Upper( 'T_OKATOSDB' )
	cName := exe_dir + '_okatos' + sdbf
	aEtalonDB := 	{ ;
					{ 'OKATO',		'C',   11,	0 }, ;
					{ 'NAME',		'C',   72,	0 }, ;
					{ 'FL_VIBOR',	'N',	1,	0 }, ;
					{ 'FL_ZAGOL',	'N',	1,	0 }, ;
					{ 'TIP',		'N',	1,	0 }, ;
					{ 'SELO',		'N',	1,	0 } ;
					}
	cAlias := '_OKATOS'
	aIndex := { ;
				{ cur_dir + '_okats', 'okato' }, ;
				{ cur_dir + '_okatsn', 'substr( okato, 1, 8 ) + upper( substr( name, 1, 30 ) )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� ����� ᥫ�' ) )
//---------

// �ࠢ�筨� _okatos8
	cClassName := Upper( 'T_OKATOS8DB' )
	cName := exe_dir + '_okatos8' + sdbf
	aEtalonDB := 	{ ;
					{ 'OKATO',		'C',   11,	0 }, ;
					{ 'NAME',		'C',   72,	0 }, ;
					{ 'FL_VIBOR',	'N',	1,	0 }, ;
					{ 'FL_ZAGOL',	'N',	1,	0 }, ;
					{ 'TIP',		'N',	1,	0 }, ;
					{ 'SELO',		'N',	1,	0 } ;
					}
	cAlias := '_OKATOS8'
	aIndex := { ;
				{ cur_dir + '_okats8', 'okato' }, ;
				{ cur_dir + '_okatsn8', 'substr( okato, 1, 8 ) + upper( substr( name, 1, 30 ) )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� _okatos8' ) )
//---------

// �ࠢ�筨� ������� 䠬����
	cClassName := Upper( 'TDubleFIODB' )
	cName := dir_server + 'mo_kfio' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD',	'N',	7,	0 }, ; // ��� 祫����� �� kartotek.dbf
					{ 'FAM',	'C',	40,	0 }, ;
					{ 'IM',		'C',	40,	0 }, ;
					{ 'OT',		'C',	40,	0 } ;
					}
	cAlias := 'TDubleFIODB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� _okatos8' ) )
//---------

// �ࠢ�筨� human
	cClassName := Upper( 'THumanDB' )
	cName := dir_server + 'human' + sdbf
	aEtalonDB := 	{ ;
					{ 'KOD'      ,   'N',     7,     0 }, ; // ��� (����� �����)
					{ 'KOD_K'    ,   'N',     7,     0 }, ; // ��� �� ����⥪�
					{ 'TIP_H'    ,   'N',     1,     0 }, ; // 1-������,2-��祭�� �� �����襭�,3-��祭�� �� �����襭�,4-�믨ᠭ ���,5-����祭 ���������,6-���쭮� �� ����稢�����
					{ 'FIO'      ,   'C',    50,     0 }, ; // �.�.�. ���쭮��
					{ 'POL'      ,   'C',     1,     0 }, ; // ���
					{ 'DATE_R'   ,   'D',     8,     0 }, ; // ��� ஦����� ���쭮��
					{ 'VZROS_REB',   'N',     1,     0 }, ; // 0-�����, 1-ॡ����, 2-�����⮪
					{ 'ADRES'    ,   'C',    50,     0 }, ; // ���� ���쭮��
					{ 'MR_DOL'   ,   'C',    50,     0 }, ; // ���� ࠡ��� ��� ��稭� ���ࠡ�⭮��
					{ 'RAB_NERAB',   'N',     1,     0 }, ; // 0-ࠡ���騩, 1-��ࠡ���騩
					{ 'KOD_DIAG' ,   'C',     5,     0 }, ; // ��� 1-�� ��.�������
					{ 'KOD_DIAG2',   'C',     5,     0 }, ; // ��� 2-�� ��.�������
					{ 'KOD_DIAG3',   'C',     5,     0 }, ; // ��� 3-�� ��.�������
					{ 'KOD_DIAG4',   'C',     5,     0 }, ; // ��� 4-�� ��.�������
					{ 'SOPUT_B1' ,   'C',     5,     0 }, ; // ��� 1-�� ᮯ������饩 �������
					{ 'SOPUT_B2' ,   'C',     5,     0 }, ; // ��� 2-�� ᮯ������饩 �������
					{ 'SOPUT_B3' ,   'C',     5,     0 }, ; // ��� 3-�� ᮯ������饩 �������
					{ 'SOPUT_B4' ,   'C',     5,     0 }, ; // ��� 4-�� ᮯ������饩 �������
					{ 'DIAG_PLUS',   'C',     8,     0 }, ; // ���������� � ��������� (+,-)
					{ 'OBRASHEN' ,   'C',     1,     0 }, ; // �஡��-��祣�, '1'-�����७�� �� ���, '2'-���������???
					{ 'KOMU'     ,   'N',     1,     0 }, ; // �� 1 �� 5
					{ 'STR_CRB'  ,   'N',     2,     0 }, ; // ��� ���.��������, ������ � �.�.
					{ 'ZA_SMO'   ,   'N',     2,     0 }, ; // �����
					{ 'POLIS'    ,   'C',    17,     0 }, ; // ��� � ����� ���客��� �����
					{ 'LPU'      ,   'N',     3,     0 }, ; // ��� ��०�����
					{ 'OTD'      ,   'N',     3,     0 }, ; // ��� �⤥�����
					{ 'UCH_DOC'  ,   'C',    10,     0 }, ; // ��� � ����� ��⭮�� ���㬥��
					{ 'MI_GIT'   ,   'N',     1,     0 }, ; // 0-��த, 1-�������, 2-�����த���
					{ 'RAJON_GIT',   'N',     2,     0 }, ; // ��� ࠩ��� ���� ��⥫��⢠
					{ 'MEST_INOG',   'N',     1,     0 }, ; // 0-��த, 1-�������, 2-�����த���
					{ 'RAJON'    ,   'N',     2,     0 }, ; // ��� ࠩ��� 䨭���஢����
					{ 'REG_LECH' ,   'N',     1,     0 }, ; // 0-�᭮���, 9-�������⥫�� �����
					{ 'N_DATA'   ,   'D',     8,     0 }, ; // ��� ��砫� ��祭��
					{ 'K_DATA'   ,   'D',     8,     0 }, ; // ��� ����砭�� ��祭��
					{ 'CENA'     ,   'N',    10,     2 }, ; // �⮨����� ��祭��
					{ 'CENA_1'   ,   'N',    10,     2 }, ; // ����稢����� �㬬� ��祭��
					{ 'BOLNICH'  ,   'N',     1,     0 }, ; // ���쭨��
					{ 'DATE_B_1' ,   'C',     4,     0 }, ; // ��� ��砫� ���쭨筮��
					{ 'DATE_B_2' ,   'C',     4,     0 }, ; // ��� ����砭�� ���쭨筮��
					{ 'DATE_E'   ,   'C',     4,     0 }, ; // ��� ���������� ���� ���
					{ 'KOD_P'    ,   'C',     1,     0 }, ; // ��� ���짮��⥫�, �������襣� �/�
					{ 'DATE_OPL' ,   'C',     4,     0 }, ; // ��� ᫥�.����� ��� ���.������� 
					{ 'SCHET'    ,   'N',     6,     0 }, ; // ��� ���
					{ 'ISHOD'    ,   'N',     3,     0 } ;
					}
	cAlias := 'THUMANDB'
	aIndex := { ;
				{ dir_server + 'humank', 'str( kod, 7 )' }, ;
				{ dir_server + 'humankk', 'str( if( kod > 0, kod_k, 0 ), 7 ) + str( tip_h, 1 )' }, ;
				{ dir_server + 'humann', 'str( tip_h, 1 ) + str( otd, 3 ) + upper( substr( fio, 1, 20 ) )' }, ;
				{ dir_server + 'humand', 'dtos( k_data ) + uch_doc' }, ;
				{ dir_server + 'humano', 'date_opl' }, ;
				{ dir_server + 'humans', 'str( schet, 6 ) + str( tip_h, 1 ) + upper( substr( fio, 1, 20 ) )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� human' ) )

// �ࠢ�筨� human_
	cClassName := Upper( 'THumanExtDB' )
	cName := dir_server + 'human_' + sdbf
	aEtalonDB := 	{ ;
				{ 'DISPANS',	'C',	16,	0 }, ; // �, �� �������� �� <F10>
				{ 'STATUS_ST',	'C',	10,	0 }, ; // ����� �⮬�⮫����᪮�� ��樥��;�஢�ઠ �� ᮡ�⢥����� �ࠢ�筨�� �� ��� �⮬�⮫����
				{ 'POVOD',		'N',	 2,	0 }, ; // ����� ���饭��
				{ 'TRAVMA',		'N',	 2,	0 }, ; // ��� �ࠢ��
				{ 'ID_PAC',		'C',	36,	0 }, ; // ��� ����� � ��樥��;GUID ��樥�� � ���� ���;ᮧ������ �� ���������� �����
				{ 'ID_C',		'C',	36,	0 }, ; // ��� ���� ��������;GUID ���� ���;ᮧ������ �� ���������� �����
				{ 'VPOLIS',		'N',	 1,	0 }, ; // ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����;�� 㬮�砭�� 1 - ����
				{ 'SPOLIS',		'C',	10,	0 }, ; // ��� �����
				{ 'NPOLIS',		'C',	20,	0 }, ; // ����� �����
				{ 'SMO',		'C',	 5,	0 }, ; // ॥��஢� ����� ��� �����頥��� � ॥��஬ �� �����, ����த��� = 34
				{ 'OKATO',		'C',	 5,	0 }, ; // ����� ����ਨ ���客���� �����頥��� � ॥��஬ �� ����� ��� �����த���
				{ 'NOVOR',		'N',	 2,	0 }, ; // �ਧ��� ����஦������� 0-���, 1,2,... - ���浪��� ����� ����஦������� ॡ����
				{ 'DATE_R2',	'D',	 8,	0 }, ; // ��� ஦����� ॡ���� ��� NOVOR > 0;
				{ 'POL2',		'C',	 1,	0 }, ; // ��� ॡ���� ��� NOVOR > 0;
				{ 'USL_OK',		'N',	 2,	0 }, ; // �᫮��� �������� ����樭᪮� ����� �� �ࠢ�筨�� V006
				{ 'VIDPOM',		'N',	 4,	0 }, ; // ��� ����� �� �ࠢ�筨�� V008
				{ 'PROFIL',		'N',	 3,	0 }, ; // ��䨫� �� �ࠢ�筨�� V002
				{ 'IDSP',		'N',	 2,	0 }, ; // ��� ᯮᮡ� ������ ���.����� �� �ࠢ�筨�� V010
				{ 'NPR_MO',		'C',	 6,	0 }, ; // ��� ��, ���ࠢ��襣� �� ��祭�� �� �ࠢ�筨�� T001
				{ 'FORMA14',	'C',	 6,	0 }, ; // ��� ���.��� 14 � ����� 4 �����: �������/���७��, ���⠢��� ᪮ன �������, �஢����� ����⨥, ��⠭������ ��宦�����
				{ 'KOD_DIAG0',	'C',	 6,	0 }, ; // ������� ��ࢨ��
				{ 'RSLT_NEW',	'N',	 3,	0 }, ; // १���� ���饭��/��ᯨ⠫���樨 �� �ࠢ�筨�� V009
				{ 'ISHOD_NEW',	'N',	 3,	0 }, ; // ��室 ����������� �� �ࠢ�筨�� V012
				{ 'VRACH',		'N',	 4,	0 }, ; // ���騩 ��� (���, �����訩 ⠫��)
				{ 'PRVS',		'N',	 9,	0 }, ; // ���樠�쭮��� ��� �� �ࠢ�筨�� V004, � ����ᮬ - �� �ࠢ�筨�� V015
				{ 'RODIT_DR',	'D',	 8,	0 }, ; // ��� ஦����� த�⥫� (��� human->bolnich=2)
				{ 'RODIT_POL',	'C',	 1,	0 }, ; // ��� த�⥫� (��� human->bolnich=2)
				{ 'DATE_E2',	'C',	 4,	0 }, ; // ��� ।���஢���� ���� ���
				{ 'KOD_P2',		'C',	 1,	0 }, ; // ��� ���짮��⥫�, ��ࠢ��襣� �/�
				{ 'PZTIP',		'N',	 2,	0 }, ; // ⨯ ����-������ �� 1 �� 99
				{ 'PZKOL',		'N',	 6,	2 }, ; // ���-�� �믮�������� ����-������
				{ 'ST_VERIFY',	'N',	 1,	0 }, ; // �⠤�� �஢�ન: 0-��᫥ ।���஢����; �� 5 �� 9-�஢�७�
				{ 'KOD_UP',		'N',	 7,	0 }, ; // ����� �।��饩 ����� (� ��砥 ����୮�� ���⠢����� � ��㣮� ����)
				{ 'OPLATA',		'N',	 1,	0 }, ; // ⨯ ������;0,1 ��� 2, 1 - � ���, 2 - ।-��; 9-���� �� ����祭 � ᤥ���� ����� �/�
				{ 'SUMP',		'N',	10,	2 }, ; // �㬬�, �ਭ��� � ����� ��� (�����);�ᥣ�;
				{ 'SANK_MEK',	'N',	10,	2 }, ; // 䨭��ᮢ� ᠭ�樨 (���);�㬬���;
				{ 'SANK_MEE',	'N',	10,	2 }, ; // 䨭��ᮢ� ᠭ�樨 (���);�㬬���;
				{ 'SANK_EKMP',	'N',	10,	2 }, ; // 䨭��ᮢ� ᠭ�樨 (����);�㬬���;
				{ 'REESTR',		'N',	 6,	0 }, ; // ��� (��᫥�����) ॥���;�� 䠩�� "mo_rees"
				{ 'REES_NUM',	'N',	 2,	0 }, ; // ����� ��ࠢ�� ॥��� � ������;� ॥��� ���� ࠧ ��ࠢ��� = 1, ��᫥ ��ࠢ����� ��ࠢ��� ��ன ࠧ = 2, � �.�.;
				{ 'REES_ZAP',	'N',	 6,	0 }, ; // ����� ����樨 ����� � ॥���;���� "IDCASE" (� "ZAP") � ॥��� ��砥�
				{ 'SCHET_NUM',	'N',	 2,	0 }, ; // ����� ��ࠢ�� ���� � �����;� ���� ���� ࠧ ��ࠢ��� = 0, ��᫥ �⪠�� � ����� � ��ࠢ����� ��ࠢ��� ��ன ࠧ = 1, � �.�.;
				{ 'SCHET_ZAP',	'N',	 6,	0 } ;  // ����� ����樨 ����� � ���;���� "IDCASE" (� "ZAP") � ॥��� ��⮢;��ନ஢��� �� ������� humans ��� schet > 0
				}
	cAlias := 'THumanExtDB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� human' ) )

// �ࠢ�筨� human_2
	cClassName := Upper( 'THumanAddDB' )
	cName := dir_server + 'human_2' + sdbf
	aEtalonDB := 	{ ;
				{ 'OSL1',		'C',	 6,	0 }, ; // ��� 1-��� �������� �᫮������ �����������
				{ 'OSL2',		'C',	 6,	0 }, ; // ��� 2-��� �������� �᫮������ �����������
				{ 'OSL3',		'C',	 6,	0 }, ; // ��� 3-��� �������� �᫮������ �����������
				{ 'NPR_DATE',	'D',	 8,	0 }, ; // ��� ���ࠢ�����, �뤠����� ��, 㪠������ � NPR_MO
				{ 'PROFIL_K',	'N',	 3,	0 }, ; // ��䨫� ����� �� �ࠢ�筨�� V020 (��樮��� � ������� ��樮���)
				{ 'VMP',		'N',	 1,	0 }, ; // 0-���,1-�� ���
				{ 'VIDVMP',		'C',	12,	0 }, ; // ��� ��� �� �ࠢ�筨�� V018
				{ 'METVMP',		'N',	 4,	0 }, ; // ��⮤ ��� �� �ࠢ�筨�� V019
				{ 'TAL_NUM',	'C',	20,	0 }, ; // ����� ⠫��� �� ���
				{ 'TAL_D',		'D',	 8,	0 }, ; // ��� �뤠� ⠫��� �� ���
				{ 'TAL_P',		'D',	 8,	0 }, ; // ��� ������㥬�� ��ᯨ⠫���樨 � ᮮ⢥��⢨� � ⠫���� �� ���
				{ 'P_PER',		'N',	 1,	0 }, ; // �ਧ��� ����㯫����/��ॢ��� 1-4
				{ 'VNR',		'N',	 4,	0 }, ; // ��� ������襭���� ॡ񭪠 (������ ॡ񭮪)
				{ 'VNR1',		'N',	 4,	0 }, ; // ��� 1-�� ������襭���� ॡ񭪠 (������ ����)
				{ 'VNR2',		'N',	 4,	0 }, ; // ��� 2-�� ������襭���� ॡ񭪠 (������ ����)
				{ 'VNR3',		'N',	 4,	0 }, ; // ��� 3-�� ������襭���� ॡ񭪠 (������ ����)
				{ 'PC1',		'C',	20,	0 }, ; // ���� (� 2017 - � ��ࢮ� ����� 1-3 - ���-�� �⥭⮢ � ��஭���� ��㤠�)
				{ 'PC2',		'C',	10,	0 }, ; // ����
				{ 'PC3',		'C',	10,	0 }, ; // �������⥫�� ���਩
				{ 'PC4',		'C',	10,	0 }, ;
				{ 'PC5',		'C',	10,	0 }, ; //
				{ 'PC6',		'C',	10,	0 }, ; //
				{ 'PN1',		'N',	10,	0 }, ; // ��� ॠ�����樨 ��樥�⮢ ��᫥ ��嫥�୮� �������樨
				{ 'PN2',		'N',	10,	0 }, ; // ��� ����⮢
				{ 'PN3',		'N',	10,	0 }, ; // ��� ᮣ��ᮢ���� � �ணࠬ���� SDS/���
				{ 'PN4',		'N',	10,	0 }, ; // ������ �/� (1-� �/� - ��뫪� �� 2-�� ����, (2-�� �/� - ��뫪� �� 1-� ����)
				{ 'PN5',		'N',	10,	0 }, ; // 
				{ 'PN6',		'N',	10,	0 };  // 
				}
	cAlias := 'THumanAddDB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� human' ) )

// ���ଠ�� �� ���������
	cClassName := Upper( 'TDisabilityDB' )
	cName := dir_server + 'kart_inv' + sdbf
	aEtalonDB := { ;
				{ 'KOD',		'N',	7,	0}, ; // ��� (����� ����� �� �� kartotek)
				{ 'DATE_INV',	'D',	8,	0}, ; // ��� ��ࢨ筮�� ��⠭������� �����������
				{ 'PRICH_INV',	'N',	2,	0}, ; // ��稭� ��ࢨ筮�� ��⠭������� �����������
				{ 'DIAG_INV',	'C',	5,	0} ;  // 
				}
	cAlias := 'TDisabilityDB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile( ):New( cName, aIndex, cAlias, aEtalonDB, '���ଠ�� �� ���������' ) )
//---------

// 
	cClassName := Upper( 'Tk_prim1DB' )
	cName := dir_server + 'k_prim1' + sdbf
	aEtalonDB := { ;
				{ 'KOD',	'N',	7,	0 }, ;
				{ 'STROKE',	'N',	1,	0 }, ;
				{ 'NAME',	'C',	60,	0 } ;
				}
	cAlias := 'Tk_prim1DB'
	aIndex := { ;
				{ dir_server + 'k_prim1', 'str( kod, 7 ) + str( stroke, 1 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile():New( cName, aIndex, cAlias, aEtalonDB, '' ) )
//---------

// �����த��� ���客� ��������
	cClassName := Upper( 'TMo_kismoDB' )
	cName := dir_server + 'mo_kismo' + sdbf
	aEtalonDB := { ;
				{ 'KOD',	'N',	7,	0 }, ;	// ID ��樥��
				{ 'SMO_NAME','C',  100,	0 } ;	// ������������ �����த��� ���
				}
	cAlias := 'TMOKISMODB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile():New( cName, aIndex, cAlias, aEtalonDB, '�����த��� ���客� ��������' ) )
//---------

// �����த��� ���客� ��������
	cClassName := Upper( 'TMo_hismoDB' )
	cName := dir_server + 'mo_hismo' + sdbf
	aEtalonDB := { ;
				{ 'KOD',	'N',	7,	0 }, ;	// ID ��樥��
				{ 'SMO_NAME','C',  100,	0 } ;	// ������������ �����த��� ���
				}
	cAlias := 'TMOHISMODB'
	aIndex := { ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile():New( cName, aIndex, cAlias, aEtalonDB, '�����த��� ���客� ��������' ) )
//---------

// ᢥ����� �� �����࠭��� �ࠦ�����
	cClassName := Upper( 'TForeignCitizenDB' )
	cName := dir_server + 'mo_kinos' + sdbf
	aEtalonDB := { ;
				{ 'KOD',		'N',	7,	0 }, ; // ID ��樥��
				{ 'OSN_PREB',	'N',	2,	0 }, ; // �᭮����� �ॡ뢠��� � ��
				{ 'ADRES_PRO',	'C',	60,	0 }, ; // ���� �஦������ � ����.���.
				{ 'MIGR_KARTA',	'C',	20,	0 }, ; // ����� ����樮���� �����
				{ 'DATE_P_G',	'D',	8,	0 }, ; // ��� ����祭�� �࠭���
				{ 'DATE_R_M',	'D',	8,	0 } ;  // ��� ॣ����樨 � ����樮���� �㦡�
				}
	cAlias := 'TForeignCitizenDB'
	aIndex := { ;
				{ dir_server + 'mo_kinos', 'str( kod, 7 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile():New( cName, aIndex, cAlias, aEtalonDB, 'ᢥ����� �� �����࠭��� �ࠦ�����' ) )
//---------

// �ࠢ�筨� �।�⠢�⥫��
	cClassName := Upper( 'TRepresentativeDB' )
	cName := dir_server + 'mo_kpred' + sdbf
	aEtalonDB := { ;
				{ 'KOD',		'N',	7,	0 }, ;	// ID ��樥��
				{ 'NN',			'N',	1,	0 }, ;	// ����� �।�⠢�⥫�
				{ 'FIO',		'C',	50,	0 }, ;	// �.�.�.
				{ 'STATUS',		'N',	2,	0 }, ;	// C���� ᮯ�.���: 0-��稩,1-த�⥫�,2-�����
				{ 'IS_UHOD',	'N',	1,	0 }, ; // 0-���, 1-�� �室� �� �����
				{ 'IS_FOOD',	'N',	1,	0 }, ; // 0-���, 1-� ��⠭���
				{ 'DATE_R',		'D',	8,	0 }, ; // ��� ஦�����
				{ 'ADRES',		'C',	50,	0 }, ; // ����
				{ 'MR_DOL',		'C',	50,	0 }, ; // ���� ࠡ���
				{ 'PHONE',		'C',	11,	0 }, ; // ���⠪�� ⥫�䮭
				{ 'PASPORT',	'C',	15,	0 }, ; // ��ᯮ��� �����
				{ 'POLIS',		'C',	25,	0 } ;  // ����� � ���客�� �����
				}
	cAlias := 'TRepresentative'
	aIndex := { ;
				{ dir_server + 'mo_kpred', 'str( kod, 7 ) + str( nn, 1 )' } ;
				}
	hb_hSet( ::hbFiles, cClassName, TDBFile():New( cName, aIndex, cAlias, aEtalonDB, '�ࠢ�筨� �।�⠢�⥫��' ) )
//---------

	::oSelf := Self

	return self