* Users.prg - ࠡ�� � ���짮��⥫ﬨ ��⥬�
*******************************************************************************
* 04.11.18 edit_Users_bay() - ।���஢���� ᯨ᪠ ���짮��⥫��
* 20.10.18 editUser( oBrowse, aObjects, object, nKey ) - ।���஢���� ��ꥪ� '���짮��⥫�'
* 20.10.18 inp_password_bay( is_cur_dir, is_create ) - ����� � �஢�ઠ ��஫�
* 20.10.18 get_parol_bay( r1, c1, r2, c2, ltip, color_say, color_get ) - �㭪�� ���� ����� ��஫�
* 11.07.17 layoutUser( oBrow, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� ᯨ᪠ ���짮��⥫��
* 01.09.16 PassExist( obj, aObjects, pass ) - �஢�ઠ ����⢮����� ���짮��⥫� � 㪠����� ��஫��
*******************************************************************************
#include 'hbthread.ch'
#include 'common.ch'
#include 'set.ch'
#include 'inkey.ch'

#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 20.10.18 ���� ��஫�
function inp_password_bay( is_cur_dir, is_create )
	local strPassword := space( 10 )
	local i_p := 0, ta := {}
	local oUser := nil
	local aMessageRepeat := { '�� ���� ��஫�!', '���஡�� �� ࠧ...' }
	local aMessageEnd := { '��� �ࠢ ����㯠 � ��⥬�!', '�� �ॢ�ᨫ� �᫮ ��������� ����⮪ ������� �����!' }
	
	public TIP_ADM := 0, TIP_OPER := 1, TIP_KONT := 3
	public grup_polzovat := 1, dolj_polzovat := '', ;
		kod_polzovat := chr( 0 ), tip_polzovat := TIP_ADM, fio_polzovat := '', ;
		yes_parol := .t.
		
	// ��ꥪ� ���짮��⥫� ��ॣ����஢��襣��� � ��⥬�
	public hb_user_curUser := nil
		
	if ( is_cur_dir .and. ! TStructFiles():New():ExistFileClass( 'TUserDB' ) ) .or. is_create
		yes_parol := .f.
		return ta
	endif
	do while i_p < 3  // �� 3� ����⮪
		strPassword := get_parol_bay()
		if lastkey() == K_ESC
			f_end()
		else
			++i_p
			if ! TStructFiles():New():ExistFileClass( 'TUserDB' )
				hb_Alert( { '��������� ⠡��� ���짮��⥫�� ��⥬�.', '�த������� ࠡ��� ����������!' }, , , 4 )
				f_end()
			elseif ( oUser := TUserDB():New():GetByPassword( strPassword ) ) != nil
				// ��᢮�� ⥪�饣� ���짮��⥫�
				hb_user_curUser	:= oUser
				mfio			:= oUser:FIO
				fio_polzovat	:= alltrim( mfio )
				kod_polzovat	:= chr( oUser:ID() )
				tip_polzovat	:= oUser:Access
				dolj_polzovat	:= alltrim( oUser:Position )
				grup_polzovat	:= oUser:KEK
			else
				if i_p < 3  // �� 3� ����⮪
					hb_Alert( aMessageRepeat, , , 4 )
					loop
				else
					hb_Alert( aMessageEnd, , , 4 )
					f_end()
				endif
			endif
		endif
		exit
	enddo
	aadd( ta, alltrim( fio_polzovat ) )
	aadd( ta, '��� ����㯠: "' + { '�����������', '������', '', '����஫��' }[ tip_polzovat + 1 ] + '"' )
	if !empty( dolj_polzovat )
		aadd( ta, '���������: ' + alltrim( dolj_polzovat ) )
	endif
	if between( grup_polzovat, 1, 3 )
		aadd( ta, '��㯯� �ᯥ�⨧� (���): ' + lstr( grup_polzovat ) )
	endif
	return ta

***** 20.10.18 �㭪�� ���� ����� ��஫�
function get_parol_bay()
	local s := space( 10 )
	local color_say := 'N/W', color_get := 'W/N*'
	local r1 := maxrow() - 5, c1 := int( ( maxcol() - 36 ) / 2 )
	local oBox
	
	oBox := TBox():New( r1, c1, maxrow() - 3, maxrow() + 31, .t. )
	oBox:MessageLine := '^<Esc>^ - ��室 �� �����;  ^<Enter>^ - ���⢥ত���� ����� ��஫�'
	oBox:Color := color_say + ',' + color_get
	oBox:Frame := 0
	oBox:View()
	set confirm on
	setcursor()
	@ r1 + 1, c1 + 18 say s color color_get  // �.�. �� ࠡ�⠥� get � �뤥������ 梥�
	s := upper( getsecret( s, r1 + 1, c1 + 10, , '��஫�:' ) )
	setcursor( 0 )
	set confirm off
	return s
	
* 04.11.18 ।���஢���� ᯨ᪠ ���짮��⥫��
function edit_Users_bay()
	local blkEditObject
	local oBox, aEdit := {}
	local c_1 := T_COL + 5, c_2 := c_1 + 67
	local lWork
	local aProperties
	
	if is_task( X_KEK )
		c_1 := 2
		c_2 := 77
	endif
	blkEditObject := { | oBrowse, aObjects, object, nKey | editUser( oBrowse, aObjects, object, nKey ) }
										
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .t. }
		lWork := G_SLock( 'edit_pass' )
	else
		aEdit := { .f., .f., .f., .f. }
		lWork := .t.
	endif
	if lWork
		aProperties := { { 'FIO', '�.�.�.', 20 }, { 'DepShortName', '���-���', 7 }, { 'Position', '���������', 20 }, { 'Type_F', '���', 3 } }
		if is_task( X_KEK )
			aadd( aProperties, { 'KEK', '���', 3 } )
		endif
		
		oBox := TBox():New( T_ROW, c_1, maxrow() - 2, c_2, .t. )
		oBox:Caption := '���᮪ ���짮��⥫��'
		oBox:Color := color5
		// ��ᬮ�� � ।���஢���� ᯨ᪠ ���짮��⥫��, ������ �㭪樨 �� �������
		ListObjectsBrowse( 'TUser', oBox, TUserDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , ' ^<F9>^-�����', )

	else
		return func_error( 4, '� ����� ������ ��஫� ।������ ��㣮� �����������. ����.' )
	endif
	if lWork .and. hb_user_curUser:IsAdmin()
		G_SUnlock( 'edit_pass' )
	endif
	return nil

* 20.10.18 ।���஢���� ��ꥪ� ���짮��⥫�
static function editUser( oBrowse, aObjects, oUser, nKey )
	local fl := .f.
	local r1 := maxrow() - 10, r2 := maxrow() - 3, i
	local c_1 := T_COL + 5, c_2 := c_1 + 62
	local oBox
	
	local mm_gruppa := { ;
						{ '0 - �� ࠡ�⠥� � ����� ���', 0 }, ;
						{ '1 - �஢��� ���.�⤥������', 1 }, ;
						{ '2 - �஢��� ���.��.���', 2 }, ;
						{ '3 - �஢��� �����ᨨ ���', 3 } }
	
	private mtip, m1tip, mgruppa, m1gruppa := 0, mDepartment, m1Department, mrole, m1role
	
	keyboard ''
	if nKey == K_F8
		if ( j := f_alert( { padc( '�롥�� ���冷� ���஢��', 60, '.' ) }, ;
				{ ' �� ��� ', ' �� ������ ' }, ;
				1, 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N,N/BG' ) ) != 0
			if j == 1
				asort( aObjects, , , { | x, y | x:FIO < y:FIO } )
			elseif j == 2
				asort( aObjects, , , { | x, y | x:ID < y:ID } )
			endif
			oBrowse:refreshAll()
			return .t.
		endif
	elseif nKey == K_F9
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @printUserList(), aObjects )
		WaitingReport( 3 )
		return .t.
	elseif nKey == K_INS .OR. nKey == K_ENTER
		m1tip := oUser:Access
		mtip := inieditspr( A__MENUVERT, TUser():aMenuType, m1tip )
		m1role := oUser:IDRole
		mrole := inieditspr( A__MENUVERT, TRoleUserDB():MenuRoles, m1role )
		m1Department := oUser:IDDepartment()
		mDepartment := inieditspr( A__MENUVERT, TDepartmentDB():MenuDepartments(), m1Department )

		if is_task( X_KEK )
			m1gruppa := oUser:KEK
			mgruppa := inieditspr( A__MENUVERT, mm_gruppa, m1gruppa )
			--r1
			c_1 := 2
			c_2 := 77
		endif
		if is_task( X_PLATN ) .or. is_task( X_ORTO ) .or. is_task( X_KASSA )
			--r1
		endif
		
		oBox := TBox():New( r1, c_1 + 1, r2, c_2 - 1, .t. )
		oBox:Caption := iif( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' )
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()
		
		@ r1 + 1, c_1 + 3 say '�.�.�. ���짮��⥫�' get oUser:FIO valid func_empty( oUser:FIO )
		@ r1 + 2, c_1 + 3 say '��०�����' get mDepartment ;
								READER { | x | menu_reader( x, TDepartmentDB():MenuDepartments(), A__MENUVERT, , , .f. ) }
		@ r1 + 3, c_1 + 3 say '���������' get oUser:Position
		@ r1 + 4, c_1 + 3 say '��㯯� ���짮��⥫��' get mrole ;
								READER { | x | menu_reader( x, TRoleUserDB():MenuRoles(), A__MENUVERT, , , .f. ) }
		@ r1 + 5, c_1 + 3 say '��� ����㯠' get mtip ;
								READER { | x | menu_reader( x, TUser():aMenuType, A__MENUVERT, , , .f. ) }
		@ r1 + 6, c_1 + 3 say '��஫�' get oUser:Password picture '@!' valid func_empty( oUser:Password ) .and. !PassExist( oUser, aObjects, oUser:Password )
		i := 6
		if is_task( X_KEK )
			++i
			@ r1 + i, c_1 + 3 say '��㯯� ���' get mgruppa READER { | x | menu_reader( x, mm_gruppa, A__MENUVERT, , , .f. ) }
		endif
		if is_task( X_PLATN ) .or. is_task( X_ORTO ) .or. is_task( X_KASSA )
			++i
			@ r1 + i, c_1 + 3 say '��஫� ��� �᪠�쭮�� ॣ������' get oUser:PasswordFR picture '99999999'
		endif
		myread()
		if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
			oUser:IDDepartment( m1Department )
			oUser:KEK := m1gruppa
			oUser:Access := m1tip
			oUser:IDRole := m1role
			TUserDB():Save( oUser )
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
	// �� ॠ��������
	endif
	return fl

***** 01.09.16 �஢�ઠ ����⢮����� ���짮��⥫� � 㪠����� ��஫��
* obj	- ��ꥪ� ���짮��⥫� �� ������饣� � �஢�થ
* aObjects	- ᯨ᮪ ���짮��⥫��
* pass	- ��ப� ��஫�
function PassExist( obj, aObjects, pass )
	local ret := .f., oUser := nil

	pass := alltrim( pass )
	for each oUser in aObjects
		if ( alltrim( oUser:Password ) == pass ) .and. ( !obj:Equal( oUser ) )
			hb_Alert( '���짮��⥫� � 㪠����� ��஫�� �������!', , , 4 )
			ret := .t.
			exit
		endif
	next
	return ret

