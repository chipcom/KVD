*
*******************************************************************************
* 03.11.18 editDepartments() - ।���஢���� ᯨ᪠ ���ࠧ�������
* 21.10.18 editDepartment( oBrowse, aObjects, oDepartment, nKey ) - ।���஢���� ��ꥪ� ���ࠧ�������
* 27.09.18 inputN_uch( r, c, date1, date2, /*@*/c_uch ) - ������⢥��� �롮� ���ࠧ������� ( ��� ᮢ���⨬��� )
* 13.02.17 SelectDepartment( r, c, date1, date2 ) - �롮� ���ࠧ�������
* 09.02.17 layoutDepartment( oBrow, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� ᯨ᪠ ���ࠧ�������
* 05.05.17 MultipleSelectedDepartment( r, c, dBegin, dEnd, oUser ) - �����頥� ���ᨢ ��࠭��� ��ꥪ⮢ ���ࠧ������� 
* 16.16.17 f_is_uch( arr_u, pole_u )
* 16.16.17 titleN_uch( arr_u, lsh, c_uch )
*******************************************************************************
*
#include 'set.ch'
#include 'inkey.ch'
#include 'hbthread.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

static strDepartment := '�������������� �������������'

* 03.11.18 ।���஢���� ᯨ᪠ ���ࠧ�������
function editDepartments()
	local blkEditObject
	local aEdit
	local oBox
	local aProperties

	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editDepartment( oBrowse, aObjects, object, nKey ) }
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )
	
	aProperties := { { 'Name', '������������', 30 }, { 'ShortName', '����.;����.', 5 }, { 'IsUseTalon_F', '����� �;⠫���� ', 8 } }
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ���ࠧ�������
	oBox := TBox():New( T_ROW, T_COL + 5, maxrow() - 1, T_COL + 58, .t. )
	oBox:Caption := '���᮪ ���ࠧ������� �࣠����樨'
	oBox:Color := color5
	ListObjectsBrowse( 'TDepartment', oBox, TDepartmentDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )

	return nil

***** 21.10.18 ।���஢���� ��ꥪ� ���ࠧ�������
function editDepartment( oBrowse, aObjects, oDepartment, nKey )
	local fl := .f.
	local k
	local oBox
	local oChief := nil

	private m1talon := 0, mtalon
	private mtabn_vr := 0, mvrach := space( 35 )
	
	if nKey == K_F9
	elseif nKey == K_F2
	elseif nKey == K_INS .OR. nKey == K_ENTER .or. nKey == K_F4
		m1talon		:= iif( oDepartment:IsUseTalon, 1, 0 )
		mtalon			:= inieditspr_bay( A__MENUVERT, mm_danet, m1talon )
		oChief		:= oDepartment:Chief
		if ! isnil( oChief )
			mvrach := padr( oChief:ShortFIO(), 20 )
			mtabn_vr := oChief:TabNom()
		endif
		k := maxrow() - 19
		
		oBox := TBox():New( k - 1, 10, k + 10, 70, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' ) + ' ���ଠ樨 � ���ࠧ�������'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()

		@ k + 1, 12 say '������������ ���ࠧ�������' get oDepartment:Name
		@ k + 2, 12 say '����饭��� ������������' get oDepartment:ShortName
		@ k + 3, 12 say '����⠥� � ���. ⠫����?' get mtalon ;
				reader { | x | menu_reader( x, mm_danet, A__MENUVERT, , , .f. ) }
		@ k + 4, 12 say '���.� �㪮����⥫�' get mtabn_vr pict '99999' ;
				valid { | g | validEmployer( g, '���', @oChief ) }
		@ row(), col() + 1 get mvrach  when .f. color color14 picture '@S20'
		@ k + 5, 12 say '������� �� �᭮�����'  get oDepartment:Competence picture '@S34'  // '@!@S34'
		@ k + 6, 12 say '���� ��宦�����' get oDepartment:Address picture '@S40' // '@!@S40'
		@ k + 7, 12 say '��� ��砫� ࠡ��� � ���ࠧ��������' get oDepartment:Dbegin
		@ k + 8, 12 say '��� ����砭�� ࠡ���' get oDepartment:Dend
	
		myread()
		if lastkey() != K_ESC .and. !empty( oDepartment:Name ) .and. f_Esc_Enter(1)
			oDepartment:IsUseTalon := if( m1talon == 0, .f., .t. )
			oDepartment:Chief := oChief
			TDepartmentDB():Save( oDepartment )
			oBrowse:refreshAll()
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
		&& stat_msg( '����! �ந�������� �஢�ઠ �� �����⨬���� 㤠����� ���ࠧ�������' )
				
		if len( TSubdivisionDB():GetList( oDepartment:ID() ) ) > 0
			ret := .f.
			hb_Alert( '������ ���ࠧ������� �ᯮ������ �ࠢ�筨�� �⤥�����. �������� ����饭�!', , , 4 )
		else
			TDepartmentDB():Delete( oDepartment )
			ret := .t.
		endif
	endif
	return fl

* 07.06.17 - �롮� ���ࠧ�������
function SelectDepartment( r, c, dBegin, dEnd )
	local kk
	local aDepartment, ar
	local ret := nil
	
	if empty( glob_uch[ 1 ] )
		// tmp_ini() - ������쭠� ��६�����, �࠭�� ��� 䠩�� ���䨣��樨 ('tmp.ini')
		// glob_uch := { 0, '' } // ������쭮� ��०����� ���ᨢ
		// glob_otd := { 0, '' } // ������쭮� �⤥����� ���ᨢ
		ar := GetIniVar( tmp_ini(), { { 'uch_otd', 'uch', '0' }, ;
                           { 'uch_otd', 'otd', '0' } } )
		glob_uch[ 1 ] := int( val( ar[ 1 ] ) )
		glob_otd[ 1 ] := int( val( ar[ 2 ] ) )
	endif
	
	aDepartment := TDepartmentDB():GetList( hb_defaultValue( dBegin, ctod( '' ) ), hb_defaultValue( dEnd, ctod( '' ) ), hb_user_curUser )
	if ( kk := Len( aDepartment ) ) == 0
		hb_Alert( '���⮩ �ࠢ�筨� ���ࠧ�������', , , 4)
	elseif kk == 1
		ret := aDepartment[ 1 ]
	elseif kk > 1
		ret := choiceDivision( r, c, kk, aDepartment, '���ࠧ�������' )
	endif
	if ret != nil
		glob_uch := { ret:ID, ret:Name }
		st_a_uch := { glob_uch }
		SetIniVar( tmp_ini(), { { 'uch_otd', 'uch', glob_uch[ 1 ] } } )
	endif
	return ret
	
***** 05.05.17 - �����頥� ���ᨢ ��࠭��� ��ꥪ⮢ ���ࠧ������� 
function MultipleSelectedDepartment( r, c, dBegin, dEnd, oUser )
	local aRet := {}
	local aDepartment := TDepartmentDB():GetList( dBegin, dEnd, hb_defaultValue( oUser, hb_user_curUser ) )
	
	return ChoiceObjectFromArray( r, c, aDepartment, .t., '���ࠧ�������' )

***** 27.09.18 - �����頥� ���ᨢ ��࠭��� ��ꥪ⮢ ���ࠧ������� 
function inputN_uch( r, c, date1, date2, /*@*/c_uch )
	static st_uch := {}
	local i, k, mas_u := {}, mas := {}, t_mas, c2, buf := savescreen()
	local l_a_uch
	local aDepartment := {}, item
		
	aDepartment := TDepartmentDB():getList( date1, date2 )
	for each item in aDepartment
		aadd( mas_u, item:Name )
		aadd( mas, item:ID )
	next
	
	count_uch := c_uch := len( mas )
	if count_uch == 0
		hb_Alert( '��ࠢ�筨� ��०����� ����!', , , 4 )
		return nil
	elseif count_uch == 1
		is_all_uch := .f.
		glob_uch := { mas[ 1 ], mas_u[ 1 ] }
		restscreen( buf )
		return { glob_uch }
	else
		if r < 0 // �.�. GET ��室���� ����� �࠭�
			k := abs( r ) - 2
			if ( r := k - count_uch - 1 ) < 2
				r := 2
			endif
		else
			if ( k := r + count_uch + 1 ) > maxrow() - 2
				k := maxrow() - 2
			endif
		endif
		c2 := c + 35 + 1
		if c2 > 77
			c2 := 77 ; c := 76 - 35
		endif
		t_mas := aclone( mas_u )
		if len( st_uch ) == 0
			aeval( mas, { | x | aadd( st_uch, x ) } )
		endif
		aeval( t_mas, { | x, i | ;
				t_mas[ i ] := if( ascan( st_uch, mas[ i ] ) > 0, ' * ', '   ') + t_mas[ i ] } )
  
		status_key( '^<Esc>^ �⪠�;  ^<Enter>^ ���⢥ত����;  ^<Ins>^ ᬥ�� �ਧ���� �롮� ��०�����' )
		do while .t.
			l_a_uch := nil
			if popup( r, c, k, c2, t_mas, i, color_uch, .t., 'fmenu_reader', , ;
					'��०�����', col_tit_uch ) > 0
					
				l_a_uch := {} ; st_uch := {}
				for i := 1 TO len( t_mas )
					if '*' == substr( t_mas[ i ], 2, 1 )
						aadd( l_a_uch, { mas[ i ], mas_u[ i ] } )
						aadd( st_uch, mas[ i ] )
					endif
				next
				if empty( l_a_uch )
					hb_Alert( '����室��� �⬥��� ��� �� ���� ��०�����!', , , 4 )
					loop
				else
					if ( k := len( l_a_uch ) ) == 1
						glob_uch := l_a_uch[ 1 ]
					endif
					is_all_uch := ( k == count_uch )
					exit
				endif
			else
				exit
			endif
		enddo
	endif
	restscreen( buf )
	return l_a_uch

*
function f_is_uch( arr_u, pole_u )

	return ascan( arr_u, { | x | pole_u == x[ 1 ] } ) > 0
