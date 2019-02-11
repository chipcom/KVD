#include 'set.ch'
#include 'getexit.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'common.ch'

#include 'hbthread.ch'

***** 10.02.19 ������ ���� �� ����⥪�
function polikl1_kart()
	static sesc := '^<Esc>^ ��室  '
	static senter := '^<Enter>^ ����  '
	static sF10p := '^<F10>^ ���� �� ������  '
	static sF10f := '^<F10>^ ���� �� ���  '
	static sF10s := '^<F10>^ ���� �� �����  '
	static sF11 := '^<F11>^ ���� ���஭�� �����'
	static s_regim := 1, s_shablon := '', s_polis := '', s_snils := ''
	
	local tmp1, tmp_help := chm_help_code, mkod := -1, i, fl_number := .t., ;
		k1 := 0, k2 := 1, str_sem, mbukva := '', tmp_color, buf, buf24, ar, s
	
	local oSetEquipment := TSettingEquipment():New( 'Equipment' )
	local oScanner := TComDescription():New( oSetEquipment:ScannerPort )
	local oWinPort
	local pThID
	local oPatient, aPatient
	
	public oBarcodeOMS := TBARCODE_OMS():New()	// ��� ��ꥪ� ��⠭���� ����-���� ���
	&& local oBarcodeOMS := TBARCODE_OMS():New()	// ��� ��ꥪ� ��⠭���� ����-���� ���

	chm_help_code := 1//HK_shablon_fio
	// ����� ���ଠ樥� � �ணࠬ��� Smart Delta Systems
	import_kart_from_sds()
	/////////////////////////////////////////////////////
	private tmp, name_reader := ''
	ar := GetIniVar( tmp_ini, { { 'polikl1'  , 's_regim'  , '1' }, ;
							{ 'polikl1'  , 's_shablon', '' }, ;
							{ 'polikl1'  , 's_polis'  , '' }, ;
							{ 'polikl1'  , 's_snils'  ,'' }, ;
							{ 'RAB_MESTO', 'sc_reader', '' } } )
	if ! eq_any( s_regim := int( val( ar[ 1 ] ) ), 1, 2, 3 )
		s_regim := 1
	endif
	s_shablon := ar[ 2 ]
	s_polis   := ar[ 3 ]
	s_snils   := ar[ 4 ]
	name_reader := ar[ 5 ]

	if lower( alltrim( oScanner:PortName ) ) != '���'
		// ��஥� COM-���� �� ���஬ ������祭 ᪠���
		oWinPort := win_com():Init( oScanner:PortName, WIN_CBR_9600, WIN_ODDPARITY, 7, WIN_ONESTOPBIT )
		if oWinPort:Open()
			// �����⨬ ���� ��⮪ ��� �ࠢ����� ᪠��஬ ����-����
			&& pThID := hb_threadStart( hb_bitor(HB_THREAD_INHERIT_PUBLIC,HB_THREAD_MEMVARS_COPY), @readBarcode(), oWinPort, oBarcodeOMS )
			pThID := hb_threadStart( hb_bitor(HB_THREAD_INHERIT_PUBLIC,HB_THREAD_MEMVARS_COPY), @readBarcode(), oWinPort )
		endif
	endif
	
	do while .t.	// ������ 横� �����
		buf24 := save_maxrow()
		if s_regim == 1
			if empty( s_shablon )
				s_shablon := '*'
			endif
			tmp := padr( s_shablon, 20 )
			tmp_color := setcolor( color1 )
			buf := box_shadow( 18, 9, 20, 70 )
			@ 19,11 say '������ 蠡��� ��� ���᪠ � ����⥪�' get tmp pict '@K@!'
			s := sesc + senter + sF10p
			if ! empty( name_reader )
				s += sF11
			endif
			status_key( alltrim( s ) )
		elseif s_regim == 2
			tmp := padr( s_polis, 17 )
			tmp_color := setcolor( color8 )
			buf := box_shadow( 18, 9, 20, 70 )
			@ 19,13 say '������ ����� ��� ���᪠ � ����⥪�' get tmp pict '@K@!'
			s := sesc + senter + sF10s
			if ! empty( name_reader )
				s += sF11
			endif
			status_key( alltrim( s ) )
		else
			tmp := padr( s_snils, 11 )
			tmp_color := setcolor( color14 )
			buf := box_shadow( 18, 9, 20, 70 )
			@ 19,14 say '������ ����� ��� ���᪠ � ����⥪�' get tmp pict '@K' + picture_pf valid val_snils( tmp, 1 )
			s := sesc + senter + sF10f
			if ! empty( name_reader )
				s += sF11
			endif
			status_key( alltrim( s ) )
		endif
		set key K_F10 TO clear_gets
		if ! empty( name_reader )
			set key K_F11 TO clear_gets
		endif
		myread( { 'confirm' } )
		set key K_F11 TO
		set key K_F10 TO
		setcolor( tmp_color )
		rest_box( buf24 )
		rest_box( buf )
		
		if oBarcodeOMS:IsEmpty
			if lastkey() == K_F10
				s_regim := iif( ++s_regim == 4, 1, s_regim )
			elseif lastkey() == K_F11 .and. ! empty( name_reader )
				if mo_read_el_polis()
					mkod := glob_kartotek
					exit
				endif
			else
				if lastkey() == K_ESC
					tmp := nil
				else
					if s_regim == 1
						s_shablon := alltrim( tmp )
					elseif s_regim == 2
						s_polis := tmp
					else
						s_snils := tmp
					endif
				endif
				exit
			endif
		else
			// ��-� ��� ࠡ��� � ����-�����
			exit
		endif
	enddo
	chm_help_code := tmp_help
	
	if oBarcodeOMS:IsEmpty
		if tmp == nil .or. mkod > 0
			if tmp == nil // ������ ESC
				mkod := 0
			endif
		elseif s_regim == 1
			s_shablon := alltrim( tmp )
			if empty( tmp := alltrim( tmp ) )
				mkod := 0
			elseif tmp == '*'
				if view_kart( 0, T_ROW )
					mkod := glob_kartotek
				else
					mkod := 0
				endif
			else
				if is_uchastok == 1
					tmp1 := tmp
					if ! ( left( tmp, 1 ) $ '0123456789' )
						mbukva := left( tmp1, 1 )
						tmp1 := substr( tmp1, 2 )  // ������ ����� �㪢�
					endif
					for i := 1 to len( tmp1 )
						if ! ( substr( tmp1, i, 1 ) $ '0123456789/' )
							fl_number := .f.
							exit
						endif
					next
					if fl_number
						if ( i := at( '/', tmp1 ) ) == 0
							fl_number := .f.
						else
							tmp := padl( alltrim( substr( tmp1, 1, i - 1 ) ), 2, '0' ) + ;
									padl( alltrim( substr( tmp1, i + 1 ) ), 5, '0' )
						endif
					endif
				else
					for i := 1 to len( tmp )
						if ! ( substr( tmp, i, 1 ) $ '0123456789' )
							fl_number := .f.
							exit
						endif
					next
				endif
				if ! fl_number
					if ! ( '*' $ tmp )
						tmp += '*'
					endif
				endif
				if fvalid_fio( 1, tmp, fl_number, mbukva )
					mkod := glob_kartotek
				else
					fl_bad_shablon := .t.
				endif
			endif
		elseif eq_any( s_regim, 2, 3 )  // ���� �� ������/�� �����
			if empty( tmp )
				mkod := 0
			else
				if fvalid_fio( s_regim, tmp, fl_number, mbukva )
					mkod := glob_kartotek
				else
					fl_bad_shablon := .t.
				endif
			endif
		endif
	else
		aPatient := TPatientDB():getByPolicyOMS( oBarcodeOMS:PolicyNumber )
		if len( aPatient ) == 1
			mkod := aPatient[ 1 ]:ID
			m1kod_k := glob_kartotek := aPatient[ 1 ]:ID
			glob_k_fio := alltrim( aPatient[ 1 ]:FIO )
			aPatient := {}
		elseif len( aPatient ) == 0
			aPatient := {}
			aPatient := TPatientDB():getByFIOAndDOB( oBarcodeOMS:FIO, oBarcodeOMS:DOB )
			if len( aPatient ) == 0
			
//				fl_bad_shablon := .t.
				oPatient := viewBarcodePolicyOMS( oBarcodeOMS )
				if ! isnil( oPatient )
					edit_kartotek( oPatient:ID )	// ��஥� �࠭ ।���஢���� ��樥��
					mkod := oPatient:ID
					m1kod_k := glob_kartotek := oPatient:ID
					glob_k_fio := alltrim( oPatient:FIO )
					aPatient := {}
					oPatient := nil
				endif
				
			elseif len( aPatient ) == 1
				if alltrim( aPatient[ 1 ]:PolicyOMS:PolicyNumber ) != alltrim( oBarcodeOMS:PolicyNumber )
					hb_alert( { '��������!', '����� ����� ��� ����ᠭ�� � ����⥪� �⫨砥��� �� �।�������!' }, , , 10 )
				endif
				mkod := aPatient[ 1 ]:ID
				m1kod_k := glob_kartotek := aPatient[ 1 ]:ID
				glob_k_fio := alltrim( aPatient[ 1 ]:FIO )
				aPatient := {}
			elseif len( aPatient ) > 1
				buf := savescreen()
				oPatient := selectPatientFromList( aPatient )
				if ! isnil( oPatient )
					mkod := oPatient:ID
					m1kod_k := glob_kartotek := oPatient:ID
					glob_k_fio := alltrim( oPatient:FIO )
					aPatient := {}
					oPatient := nil
				else
				endif
				restscreen( buf )
			endif
		elseif len( aPatient ) > 1
			buf := savescreen()
			oPatient := selectPatientFromList( aPatient )
			if ! isnil( oPatient )
				mkod := oPatient:ID
				m1kod_k := glob_kartotek := oPatient:ID
				glob_k_fio := alltrim( oPatient:FIO )
				aPatient := {}
				oPatient := nil
			else
			endif
			restscreen( buf )
		endif
	endif
	
	if ! isnil( pThID )
		// �몫�稬 ��⮪ ��� �ࠢ����� ᪠��஬ ����-����
		hb_threadQuitRequest( pThID )
		oWinPort:Close()
	endif
	oBarcodeOMS := nil

	SetIniSect( tmp_ini, 'polikl1', { { 's_regim'  ,lstr( s_regim ) }, ;
									{ 's_shablon', s_shablon    }, ;
									{ 's_polis'  , s_polis      }, ;
									{ 's_snils'  , s_snils      } } )
	return mkod

* 10.02.19
function viewBarcodePolicyOMS( oBarcodeOMS )
	local oBox, oPatient, oPolicyOMS
	local k, arr := {}
	local oDoubleFIO

	oBox := TBox():New( 10, 9, 15, 70, .t. )
	oBox:Color := color1
	oBox:Caption := '���ଠ�� � �㬠����� ����� ���'
	oBox:View()
	
	@ 11, 11 say '�.�.�.: ' + padr( oBarcodeOMS:FIO, 50 ) color color8
	@ 12, 11 say '��� ஦�����: ' + full_date( oBarcodeOMS:DOB ) color color8
	@ 13, 11 say '���: ' + iif( oBarcodeOMS:Gender == '�', '��᪮�', '���᪨�' ) color color8
	@ 14, 11 say '����� ���: ' + alltrim( oBarcodeOMS:PolicyNumber ) color color8
	
	k := 2
	arr := { ' �⪠� �� ����� ', ' �������� � ����⥪� ' }
	k := f_alert( { padc( '�롥�� ����⢨�', 60, '.' ) }, arr, ;
			k, 'W+/N', 'N+/N', 20, , 'W+/N,N/BG' )
	
	if k == 2
		oPatient := TPatient():New()
		oPatient:FIO := oBarcodeOMS:FIO
		oPatient:Gender := oBarcodeOMS:Gender
		oPatient:DOB := oBarcodeOMS:DOB
		if TwoWordFamImOt( oBarcodeOMS:LastName ) ;
					.or. TwoWordFamImOt( oBarcodeOMS:FirstName ) ;
					.or. TwoWordFamImOt( oBarcodeOMS:MiddleName )
			oPatient:Mest_Inog := 9
		endif
		TPatientDB():Save( oPatient )
		
		oPolicyOMS := TPolicyOMS():New()
		oPolicyOMS:PolicyNumber := oBarcodeOMS:PolicyNumber
		oPolicyOMS:PolicyType := 3
		oPatient:PolicyOMS := oPolicyOMS
		TPatientDB():Save( oPatient )
		
		if oPatient:Mest_Inog == 9
			oDoubleFIO := TDubleFIODB():getByPatient( oPatient )
			if isnil( oDoubleFIO )
				oDoubleFIO := TDubleFIO():New()
				oDoubleFIO:IDPatient := oPatient:ID
			endif
			oDoubleFIO:LastName := oBarcodeOMS:LastName
			oDoubleFIO:FirstName := oBarcodeOMS:FirstName
			oDoubleFIO:MiddleName := oBarcodeOMS:MiddleName
			TDubleFIODB():Save( oDoubleFIO )
		endif
	endif
	return oPatient

* 08.02.19
function selectPatientFromList( aPatient )
	local oPatient := nil
	local c1
	local oBox
	local aProperties

	c1 := 24
	if mem_kodkrt == 2
		if is_uchastok == 1
			c1 -= 10
		elseif eq_any( is_uchastok, 2, 3 )
			c1 -= 12
		else
			c1 -= 7
		endif
	endif

	oBox := TBox():New( 0, c1, 11, 77, .t. )
	oBox:Color := color0
	oBox:Caption := '������� �⡮�'
	aProperties := { { 'FIO', '�.�.�.', 49 } }
	if mem_kodkrt == 2
		if is_uchastok > 0
			aadd( aProperties, { 'BUKVA', ' ', 1 } )
			//
			aadd( aProperties, { 'UCHAST', '��', 2 } )
		endif
		if is_uchastok == 1
			aadd( aProperties, { 'KOD_VU', ' ���', 5 } )
		elseif is_uchastok == 2
			aadd( aProperties, { 'KOD', '  ���', 7 } )
		elseif is_uchastok == 3
			aadd( aProperties, { 'KOD_AK', '��� ��', 10 } )
		endif
	endif
	// �롮� ��ꥪ� �� ᯨ᪠
	oPatient := ListObjectsBrowse( 'TPatient', oBox, aPatient, 1, aProperties, ;
										, , 'viewShortCardPatient', , , .t. )
	return oPatient

* 09.02.19
function viewShortCardPatient( oPatient )
	local i, s, s1, mmo_pr, arr := {}
	local r1 := 14, r2 := 23
	
	is_talon := .t. // ���� ⠪
	if is_uchastok > 0 .or. glob_mo[ _MO_IS_UCH ]
		s := ''
		if is_uchastok > 0
			s := '��� ' + oPatient:Bukva
			s += space( 3 ) + '���⮪ ' + lstr( oPatient:District )
			if is_uchastok == 1
				s += space( 3 ) + '��� ' + lstr( oPatient:Kod_VU )
			elseif is_uchastok == 3
				s += space( 3 ) + '��� �� ��� ' + alltrim( oPatient:AddInfo:AmbulatoryCard ) + space( 5 )
			endif
			s += space( 3 )
		endif
		if glob_mo[ _MO_IS_UCH ]
			if left( oPatient:AddInfo:PC2, 1 ) == '1'
				mmo_pr := '�� ���ଠ樨 �� ����� ��樥�� �_�_�_�'
			elseif oPatient:AddInfo:MOCodeAttachment == glob_mo[ _MO_KOD_TFOMS ]
				mmo_pr := '�ਪ९�� '
				if ! empty( oPatient:AddInfo:PC4 )
					mmo_pr += '� ' + alltrim( oPatient:AddInfo:PC4 ) + ' '
				elseif ! empty( oPatient:AddInfo:DateAttachment )
					mmo_pr += '� ' +date_8( oPatient:AddInfo:DateAttachment ) + ' '
				endif
				mmo_pr += '� ��襩 ��'
			else
				s1 := alltrim( inieditspr( A__MENUVERT, glob_arr_mo, oPatient:AddInfo:MOCodeAttachment ) )
				if empty( s1 )
					mmo_pr := '�ਪ९����� --- �������⭮ ---'
				else
					mmo_pr := ''
					if ! empty( oPatient:AddInfo:PC4 )
						mmo_pr += '� ' + alltrim( oPatient:AddInfo:PC4 ) + ' '
					elseif ! empty( oPatient:AddInfo:DateAttachment )
						mmo_pr += '� ' + date_8( oPatient:AddInfo:DateAttachment ) + ' '
					endif
					mmo_pr += '�ਪ९�� � ' + s1
				endif
			endif
			s += mmo_pr
		endif
		aadd( arr, { s, color1 } )
	endif
	s := '�.�.�.: ' + oPatient:FIO + space( 7 ) + iif( oPatient:Gender == '�', '��稭�', '���騭�' )
	aadd( arr, { s, color1 } )
	s := '��� ஦�����: ' + full_date( oPatient:DOB ) + space( 5 ) + ;
		'(' + alltrim( inieditspr( A__MENUVERT, menu_vzros, oPatient:Vzros_Reb ) ) + ')'
	if ! empty( oPatient:SNILS )
		s += space( 5 ) + '�����: ' + transform( oPatient:SNILS, picture_pf )
	endif
	aadd( arr, { s, color1 } )
	
	s := oPatient:Passport:AsString()
	if empty( s )
		s := '���㬥�� 㤮�⮢����騩 ��筮��� ���������'
		aadd( arr, { s, 'GR+/B, W+/R', 'W/B, W+/R' } )
	else
		aadd( arr, { s, color1 } )
	endif
	
	s1 := alltrim( oPatient:PlaceBorn )
	s := '���� ஦�����: ' + if( empty( s1 ), '���������', s1 )
	if empty( s1 )
		aadd( arr, { s, 'GR+/B, W+/R', 'W/B, W+/R' } )
	else
		aadd( arr, { s, color1 } )
	endif
	
	s := '���� ॣ����樨: '
	s1 := oPatient:AddressRegistration:AsString()
	if ! emptyall( s1 )
		s += s1
		aadd( arr, { s, color1 } )
	else
		s += '���������'
		aadd( arr, { s, 'GR+/B, W+/R', 'W/B, W+/R' } )
	endif
	s1 := oPatient:AddressStay:AsString()
	if !emptyall( s1 )
		s := '���� �ॡ뢠���: ' + s1
		aadd( arr, { s, color1 } )
	endif
	s := '����� ���: '
	if ! empty( oPatient:AddInfo:SinglePolicyNumber )
		s += '(��� ' + alltrim( oPatient:AddInfo:SinglePolicyNumber ) + ') '
	endif
	s +=  oPatient:PolicyOMS:AsString
	aadd( arr, { s, color1 } )
	
	if eq_any( glob_task, X_REGIST, X_OMS, X_PLATN, X_ORTO, X_KASSA, X_PPOKOJ, X_MO )
		s := upper( rtrim( inieditspr( A__MENUVERT, menu_rab, oPatient:Working ) ) )
		if oPatient:ExtendInfo:IsPensioner
			s += space( 5 ) + '���ᨮ���'
		endif
		if ! empty( oPatient:PlaceWork )
			s += ',  ���� ࠡ���: ' + oPatient:PlaceWork
		endif
		aadd( arr, { s, color1 } )
	endif
	if eq_any( glob_task, X_MO )
		if ! emptyall( oPatient:ExtendInfo:HomePhone, oPatient:ExtendInfo:MobilePhone, oPatient:ExtendInfo:WorkPhone )
			s := '����䮭�:'
			if ! empty( oPatient:ExtendInfo:HomePhone )
				s += ' ����譨� ' + oPatient:ExtendInfo:HomePhone
			endif
			if ! empty( oPatient:ExtendInfo:MobilePhone )
				s += ' ������� ' + oPatient:ExtendInfo:MobilePhone
			endif
			if ! empty( oPatient:ExtendInfo:WorkPhone )
				s += ' ࠡ�稩 ' + oPatient:ExtendInfo:WorkPhone
			endif
			aadd( arr, { s, color1 } )
		endif
		if ! empty( oPatient:ExtendInfo:CodeLgot )
			aadd( arr, { inieditspr( A__MENUVERT, glob_katl, oPatient:ExtendInfo:CodeLgot ), color1 } )
		endif
	endif
	if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_MO )
		s := ''
		if is_talon .and. oPatient:ExtendInfo:Category > 0
			s := '��� ��⥣�ਨ �죮��: ' + rtrim( inieditspr( A__MENUVERT, stm_kategor, oPatient:ExtendInfo:Category ) ) + space( 5 )
		endif
		if ! empty( stm_kategor2 ) .and. oPatient:ExtendInfo:Category2 > 0
			s += '��⥣��� ��: ' + rtrim( inieditspr( A__MENUVERT, stm_kategor2, oPatient:ExtendInfo:Category2 ) )
		endif
		aadd( arr, { s, color1 } )
	endif
	//
	//
	@ r1 - 1, 0 say padc( '_��ᬮ�� ����⥪�_', 80, '�' ) color 'R/BG'
	ClrLines( r1, r2, color1 )
	for i := 1 to len( arr )
		if r1 + i - 1 > r2
			exit
		endif
		@ r1 + i - 1, 1 say arr[ i, 1 ] color arr[ i, 2 ]		//color1
	next
	return nil