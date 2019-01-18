* ExternalOrganization.prg - �����⥬� ࠡ�� � ���譨�� �࣠�����ﬨ
*****************************************************
* 03.11.18 viewStdds() - ।���஢���� ᯨ᪠ ��樮��஢ ��⥩-���
* 03.11.18 editPayer( nType ) - �뢮� ᯨ᪠ �࣠����権 ���⥫�騪�� �� ����� ��㣠�	
* 03.11.18 viewSchool() - ।���஢���� ᯨ᪠ ��ࠧ���⥫쭮� �࣠����樨
* 03.11.18 viewCommitte( nType ) - ।���஢���� ᯨ᪠ ���� �ࠢ�筨��� �����⮢ � ���客��
* 03.11.18 editCommittee( oBrowse, aObjects, oCommon, nKey, typeClass ) - ।���஢���� ��ꥪ� �ࠢ�筨�� ������ ��� ���客��
* 22.10.18 EditPayerOrg( oBrowse, aObjects, oOrganization, nKey ) - ।���஢���� �࣠����樨 ���⥫�騪�
* 21.10.18 editSchool( oBrowse, aObjects, oOrganization, nKey ) - ।���஢���� ��ꥪ� ��ࠧ���⥫쭠� �࣠������
* 21.10.18 editStdds( oBrowse, aObjects, oOrganization, nKey ) - ।���஢���� ��ꥪ� ��樮��� ��⥩-���
* 05.04.17 layoutSchool( oBrow, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� ᯨ᪠ ��ࠧ���⥫쭮� �࣠����樨
* 04.04.17 layoutStdds( oBrow, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� ᯨ᪠ ��樮��஢ ��⥩-���
* 07.09.16 layoutOrganization( oBrow, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� �࣠����権 ���⥫�騪�� �� ����� ��㣠�
* 26.06.17 edit_d_smo( num ) - �-�� �����誠 ��� ᮢ���⨬���
* 26.06.17 edit_pr_vz( num ) - �-�� �����誠 ��� ᮢ���⨬���
*****************************************************
#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

static strSchool := '�������������� ��������������� �����������'
static strStdds := '�������������� ����������'


* 26.06.17 - �-�� �����誠 ��� ᮢ���⨬���
function edit_pr_vz( num )

	editPayer( PU_PR_VZ )
	return nil
	
* 26.06.17 - �-�� �����誠 ��� ᮢ���⨬���
function edit_d_smo( num )

	editPayer( PU_D_SMO )
	return nil

* 03.11.18 - �뢮� ᯨ᪠ �࣠����権 ���⥫�騪�� �� ����� ��㣠�	
function editPayer( nType )
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | EditPayerOrg( oBrowse, aObjects, object, nKey ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )
	aProperties := { { 'INN', '���', 10 }, { 'Name', '�࣠������', 30 } }

	// ��ᬮ�� � ।���஢���� ᯨ᪠ �࣠����権
	oBox := TBox():New( T_ROW, 0, maxrow() - 2, 79, .t. )
	oBox:Color := color5
	oBox:CaptionColor := col_tit_popup
	
	if nType == PU_D_SMO
		oBox:Caption := '���᮪ ���客�� �࣠����権'
		ListObjectsBrowse( 'TCompanyDMS', oBox, TCompanyDMSDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	else
		oBox:Caption := '���᮪ �࣠����権 �� �����������'
		ListObjectsBrowse( 'TCompanyVzaim', oBox, TCompanyVzaimDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	endif
	return nil

* 22.10.18 - ।���஢���� �࣠����樨 ���⥫�騪�
function EditPayerOrg( oBrowse, aObjects, oOrganization, nKey )
	local nRow := row(), nCol := col(), tmp_color, buf := save_maxrow(), ;
			buf1, fl := .f., r1, r2, i, c_1, c_2
	local k, ix, x, lC := .t.
	local tmpAr := {}
	local str_1, iRow := 0
	local oBank := nil

	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		oBank := oOrganization:Bank
		if oBank == nil
			oBank := TBank():New()
		endif
		r1 := 11
		c_1 := T_COL + 5
		c_2 := c_1 + 62

		oBox := TBox():New( r1, 0, maxrow() - 1, maxcol(), .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' ) + ' ���ଠ樨 �� �࣠����樨'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()
		
		@ ++r1, 2 say '������������' get oOrganization:Name picture '@!@S30'
		@ r1, col() + 2 say '���' get oOrganization:INN picture '999999999'
		@ ++r1, 2 say '������ ������������' get oOrganization:FullName picture '@!@S50'
		++r1
		@ ++r1, 2 say '����' get oOrganization:Address picture '@!@S50'
		@ r1, col() + 2 say '����䮭' get oOrganization:Phone
		
		@ ++r1, 0 say '�' + replicate( '�', 78 ) + '�'
		
		@ ++r1, 2 say '����' get oBank:Name picture '@!@S50'
		@ r1, col() + 2 say '���' get oBank:BIK
		@ ++r1, 2 say '����. ���' get oBank:RSchet
		@ r1, col() + 2 say '���. ���' get oBank:KSchet
		@ ++r1, 2 say '�������' get oOrganization:Dogovor
		@ r1, col() + 2 say '��� �������' get oOrganization:Date

		myread()
		if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
			oOrganization:Bank := oBank	// TBank():New( mBank, mAccount, mCorAccount, mBIK )
			if upper( oOrganization:classname() ) == upper( 'TCompanyDMS' )
				TCompanyDMSDB():Save( oOrganization )
			elseif  upper( oOrganization:classname() ) == upper( 'TCompanyVzaim' )
				TCompanyVzaimDB():Save( oOrganization )
			endif
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
		&& stat_msg( '����! �ந�������� �஢�ઠ �� �����⨬���� 㤠����� ������ ��������' )
		if len( TContractDB():GetListByTypeAndIDPayer( iif( oOrganization:classname() == upper( 'TCompanyDMS' ), 1, 2 ), oOrganization:ID() ) ) > 0
			hb_Alert( { '������ �࣠������ ����砥��� � ��㣨� ����� ������.', '�������� ����饭�!' }, , , 4 )
			ret := .f.
		else
			if upper( oOrganization:classname() ) == upper( 'TCompanyDMS' )
				TCompanyDMSDB():Delete( oOrganization )
			elseif  upper( oOrganization:classname() ) == upper( 'TCompanyVzaim' )
				TCompanyVzaimDB():Delete( oOrganization )
			endif
			ret := .t.
		endif
	endif
	return .t.

* 03.11.18 ।���஢���� ᯨ᪠ ��ࠧ���⥫쭮� �࣠����樨
function viewSchool()
	local blkEditObject
	local aEdit
	local aProperties

	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editSchool( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Name', '������������', 25 }, { 'Address', '����', 25 }, { 'Type_F', '���', 14 } }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )

	// ��ᬮ�� � ।���஢���� ᯨ᪠ ��ࠧ���⥫쭮� �࣠����樨
	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 77, .t. )
	oBox:Caption := '��饮�ࠧ���⥫�� ��०�����'
	oBox:Color := color5
	ListObjectsBrowse( 'TSchool', oBox, TSchoolDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )

	return nil

* 21.10.18 ।���஢���� ��ꥪ� ��ࠧ���⥫쭠� �࣠������
static function editSchool( oBrowse, aObjects, oSchool, nKey )
	local fl := .f.
	
	private mtype, m1type := 0
	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		m1type		:= oSchool:Type
		mtype := inieditspr_bay( A__MENUVERT, TSchool():aMenuTypeSchool, m1type )
		
		k := maxrow() - 7

		oBox := TBox():New( k, 5, k + 5, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '���������� ������', '������஢����' ) + ' ��०�����'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()
		
		@ k + 1, 7 say '����饭��� ������������' get oSchool:Name picture '@S44'
		@ k + 2, 7 say '������ ������������' get oSchool:FullName picture '@S44'
		@ k + 3, 7 say '�ਤ��᪨� ����' get oSchool:Address picture '@S51'
		@ k + 4, 7 say '���' get mtype ;
				reader { | x | menu_reader( x, TSchool():aMenuTypeSchool, A__MENUVERT, , , .f. ) }
	
		myread()
		if lastkey() != K_ESC .and. !empty( oSchool:Name ) .and. f_Esc_Enter( 1 )
			oSchool:Type := m1type
			TSchoolDB():Save( oSchool )
			oBrowse:refreshAll()
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
	endif
	return fl

* 03.11.18 ।���஢���� ᯨ᪠ ��樮��஢ ��⥩-���
function viewStdds()
	local blkEditObject
	local aEdit
	local aProperties

	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editStdds( oBrowse, aObjects, object, nKey ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )
	aProperties := { { 'Name', '������������', 25 }, { 'Address', '����', 25 }, { 'Vedom_F', '������⢥����;�ਭ����������', 14 } }

	// ��ᬮ�� � ।���஢���� ᯨ᪠ ��ࠧ���⥫쭮� �࣠����樨
	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 77, .t. )
	oBox:Caption := '��樮���� ��⥩-���'
	oBox:Color := color5
	ListObjectsBrowse( 'TStdds', oBox, asort( TStddsDB():GetList(), , , { | x, y | x:Name() < y:Name() } ), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 21.10.18 ।���஢���� ��ꥪ� ��樮��� ��⥩-���
static function editStdds( oBrowse, aObjects, oStdds, nKey )
	local fl := .f.
	
	private mvedom, m1vedom := 0

	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		mvedom := inieditspr_bay( A__MENUVERT, TStdds():aMenuVedom, m1vedom )
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 4, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '���������� ������', '������஢����' ) + ' ��樮���'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()
		
		@ k + 1, 7 say '������������ ��樮���' get oStdds:Name picture '@S44'
		@ k + 2, 7 say '���� ��樮���' get oStdds:Address picture '@S51'
		@ k + 3, 7 say '������⢥���� �ਭ����������' get mvedom ;
				reader { | x | menu_reader( x, TStdds():aMenuVedom, A__MENUVERT, , , .f. ) }
		myread()
		if lastkey() != K_ESC .and. !empty( oStdds:Name ) .and. f_Esc_Enter( 1 )
			oStdds:Vedom := m1vedom
			TStddsDB():Save( oStdds )
			oBrowse:refreshAll()
			fl := .t.
		elseif nKey == K_DEL
		endif
		oBox := nil
	endif
	return fl
	
* 03.11.18 ।���஢���� ᯨ᪠ ���� �ࠢ�筨���
function viewCommitte( nType )
	local blkEditObject
	local aEdit
	local tName, aObjects
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editCommittee( oBrowse, aObjects, object, nKey, nType ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .f., .t., .f. }, { .f., .f., .f., .f. } )
	
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ��ࠧ���⥫쭮� �࣠����樨
	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 76, .t. )
	oBox:Color := color5
	if nType == 1
		oBox:Caption := '���客� ��������'
		tName := 'TInsuranceCompany'
		aObjects := asort( TInsuranceCompanyDB():GetList(), , , { | x, y | x:Name() < y:Name() } )
		aProperties := { { 'Name', '���客� ��������', 30 } }
	elseif nType == 2
		oBox:Caption := '������� ��ࠢ���࠭����'
		tName := 'TCommittee'
		aObjects := TCommitteeDB():GetList()
		aProperties := { { 'Name', '������� ��ࠢ���࠭����', 30 } }
	else
		return nil
	endif
	ListObjectsBrowse( tName, oBox, aObjects, 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 03.11.18 ।���஢���� ��ꥪ� �ࠢ�筨��
static function editCommittee( oBrowse, aObjects, oCommon, nKey, typeClass )
	local fl := .f.
	local mtfoms := 0
	local oBank
	local oBox
	
	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		private m1paraclinika := 0, mparaclinika
		private m1mist_fin := 0, mmist_fin
		
		oBank := oCommon:Bank()
		if oBank == nil
			oBank := TBank():New()
		endif
		if typeClass == 1
			mtfoms	:= oCommon:TFOMS
		endif
		m1paraclinika	:= oCommon:Paraclinika
		m1mist_fin	:= oCommon:SourceFinance
		
		mparaclinika   := inieditspr_bay( A__MENUVERT, mm_danet, m1paraclinika )
		mmist_fin   := inieditspr_bay( A__MENUVERT, mm_ist_fin, m1mist_fin )
		
		k := maxrow() - 19
		
		oBox := TBox():New( k, 5, k + 14, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()
		
		@ k + 1, 7 say '������������' get oCommon:Name picture '@S30'
		@ k + 2, 7 say '������ ������������' get oCommon:FullName picture '@S49'
		@ k + 3, 7 say '���/���' get oCommon:INN picture '99999999999999999999'
		@ k + 4, 7 say '����' get oCommon:Address picture '@S50'
		@ k + 5, 7 say '����䮭' get oCommon:Phone picture '99-99-99'
		@ k + 6, 7 say '����' get oBank:Name picture '@S50'
		@ k + 7, 7 say '������ ���' get oBank:RSchet picture '99999999999999999999'
		@ k + 8, 7 say '����.���' get oBank:KSchet picture '99999999999999999999'
		@ k + 9, 7 say '���' get oBank:BIK picture '9999999999'
		@ k + 10, 7 say '�����' get oCommon:OKONH picture '999999999999999'
		@ k + 11, 7 say '����' get oCommon:OKPO picture '999999999999999'
		@ k + 12, 7 say "������� ����������� � �㬬� ��� �� ������ ��������" get mparaclinika ;
				reader { | x | menu_reader( x, mm_danet, A__MENUVERT, , , .f. ) }
		
		@ k + 13, 7 say '���筨� 䨭���஢����' get mmist_fin ;
				reader { | x | menu_reader( x, mm_ist_fin, A__MENUVERT, , , .f. ) }
//		@ k + 10, 7 say '��� �����' get mname picture '@S30'
		myread()
		if lastkey() != K_ESC .and. !empty( oCommon:Name ) .and. f_Esc_Enter( 1 )
			if typeClass == 1
				oCommon:TFOMS := mtfoms
			endif
			oCommon:Paraclinika := m1paraclinika
			oCommon:SourceFinance := m1mist_fin
			if typeClass == 1
				TInsuranceCompanyDB():Save( oCommon )
			elseif typeClass == 2
				TCommitteeDB():Save( oCommon )
			endif
			oBrowse:refreshAll()
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
	endif
	return fl
	
*****
function ret_arr_dms( r1,c1 )
	static sa
	local r2, c2, nr := 0, arr := {}, t_mas := {}, buf, buf1, i, ret
	
	HB_Default( @r1, T_ROW ) 
	HB_Default( @c1, T_COL + 5 ) 
	arr := TCompanyDMSDB():MenuCompanies( .f. )
	nr := len( arr )
	if nr == 0
		func_error( 4, '��ࠢ�筨� ���� ����!' )
		return nil
	endif
	asort( arr, , , { | x, y | upper( x[ 2 ] ) < upper( y[ 2 ] ) } )
	aeval( arr, { | x | aadd( t_mas, x[ 2 ] ) } )
	r2 := r1 + nr + 1
	c2 := c1 + 33 + 1
	if c2 > 77
		c2 := 77 ; c1 := 76 - 33
	endif
	if r2 > maxrow() - 2 ; r2 := maxrow() - 2 ; endif
	
	if r2 == maxrow() - 2
		r1 := r2 - nr - 1
		if r1 < 2 ; r1 := 2 ; endif
	endif
	
	buf := save_box( r1, c1, r2 + 1, c2 + 2 )
	buf1 := save_row( maxrow() )
	aeval( t_mas, { | x, i, fl | fl := iif( sa == nil, .t., ascan( sa, arr[ i, 1 ] ) > 0 ), t_mas[ i ] := iif( fl, ' * ', '   ' ) + t_mas[ i ] } )
	status_key( '^<Esc>^-�⪠�; ^<Enter>^-�롮�; ^<Ins,+,->^-ᬥ�� �ਧ���� ���� ������ ����' )
		
	if popup( r1, c1, r2, c2, t_mas, , color0, .t., 'fmenu_reader' ) > 0
		ret := {}
		for i := 1 TO nr
			if '*' $ left( t_mas[ i ], 3 )
				aadd( ret, arr[ i, 1 ] )
			endif
		next
		if empty( ret )
			ret := nil
		endif
		sa := ret
	endif
	rest_box( buf )
	rest_box( buf1 )
	return ret

*****
function ret_arr_vz( r1, c1 )
	static sa
	local r2, c2, nr := 0, arr := {}, t_mas := {}, buf, buf1, i, ret
	
	HB_Default( @r1, T_ROW ) 
	HB_Default( @c1, T_COL + 5 ) 
	arr := TCompanyVzaimDB():MenuCompanies( .f. )
	nr := len( arr )
	if nr == 0
		hb_Alert( '��ࠢ�筨� �࣠����権 ����!', , , 4 )
		return nil
	endif
	asort( arr, , , { | x, y | upper( x[ 2 ] ) < upper( y[ 2 ] ) } )
	aeval( arr, { | x | aadd( t_mas, x[ 2 ] ) } )
	r2 := r1 + nr + 1
	c2 := c1 + 33 + 1
	if c2 > 77
		c2 := 77 ; c1 := 76 - 33
	endif
	if r2 > maxrow() - 2 ; r2 := maxrow() - 2 ; endif
	if r2 == maxrow() - 2
		r1 := r2 - nr - 1
		if r1 < 2 ; r1 := 2 ; endif
	endif
	buf := save_box( r1, c1, r2 + 1, c2 + 2 )
	buf1 := save_row( maxrow() )
	aeval( t_mas, { | x, i, fl | fl := iif( sa == nil, .t., ascan( sa, arr[ i, 1 ] ) > 0 ), t_mas[ i ] := iif( fl, ' * ', '   ' ) + t_mas[ i ] } )
	status_key( '^<Esc>^-�⪠�; ^<Enter>^-�롮�; ^<Ins,+,->^-ᬥ�� �ਧ���� ���� ������� �।�����' )
	
	if popup( r1, c1, r2, c2, t_mas, , color0, .t., 'fmenu_reader' ) > 0
		ret := {}
		for i := 1 to nr
			if '*' $ left( t_mas[ i ], 3 )
				aadd( ret, arr[ i, 1 ] )
			endif
		next
		if empty( ret )
			ret := nil
		endif
		sa := ret
	endif
	rest_box( buf )
	rest_box( buf1 )
	return ret		