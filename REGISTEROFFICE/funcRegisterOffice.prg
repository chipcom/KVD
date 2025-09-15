* ࠧ���� �㭪樨 ��饣� ���짮����� ��� �����⥬� ����������
*******************************************
*******************************************
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 19.11.18 �஢���� �⤥�쭮 䠬����, ��� � ����⢮ � GET'��
function checkGetFIO( oGET, ltip, par, /*@*/msg )
	static arr_pole := { '�������', '���', '����⢮' }
	static arr_char := { ' ', '-', '.', "'", '"' }
	local fl := .t., i, c, s1 := '', nword := 0, r := row()
	local getString
	
	DEFAULT par TO 1
	getString := alltrim( oGET:buffer )
	for i := 1 to len( arr_char )
		getString := charone( arr_char[ i ], getString )
	next
	if len( getString ) > 0
		getString := upper( left( getString, 1 ) ) + substr( getString, 2 )
	endif
	for i := 1 to len( getString )
		c := substr( getString, i, 1 )
		if isralpha( c )
			//
		elseif ascan( arr_char, c ) > 0
			++nword
		else
			s1 += c
		endif
	next
	msg := ''
	if ! empty( s1 )
		msg := '� ���� "' + arr_pole[ ltip ] + '" �����㦥�� �������⨬� ᨬ���� "' + s1 + '"'
	elseif empty( getString ) .and. ltip < 3
		msg := '���⮥ ���祭�� ���� "' + arr_pole[ ltip ] + '" �������⨬�'
	endif
	if par == 1  // ��� GET-��⥬�
		if empty( msg ) .and. nword > 0
			r := oGET:Row
			fl := .f.
			if f_alert( { padc( '� ���� "' + arr_pole[ ltip ] + '" ����ᥭ� ' + lstr( nword + 1 ) + ' ᫮��', 60, '.' ) }, ;
						{ ' ������ � ।���஢���� ', ' �ࠢ��쭮� ���� ' }, ;
						1, 'W+/N', 'N+/N', r + 1, , 'W+/N,N/BG' ) == 2
				fl := .t.
			endif
		endif
	endif
	if ! empty( msg )
		if par == 1  // ��� GET-��⥬�
			hb_alert( msg, , , 4 )
		else  // ��� �஢�ન �����
		endif
		fl := .f.
	endif
	return fl

* 25.12.18 �஢�ઠ ����� �����
function roCheckSNILS( oGet, oPatient )
	local ret := .t., mkod
	
	ret := val_snils( charrem( ' -', oGet:buffer ), 1 )
	if ! ret
		return ret
	endif
	if ( findKartoteka_bay( oPatient, 3, @mkod ) )
		update_gets()
	endif
	return ret

* 18.11.18 ��८�।������ ����� "�����/ॡ񭮪" �� ��� ஦����� � "_date"
function roCheckDOB( oGet, oPatient, _data, fl_end )
	local cy, k, ret := .t., mkod

	DEFAULT _data TO sys_date, fl_end TO .t.
	cy := count_years( ctod( oGet:buffer ), _data )
	if k == nil
		if cy < 14
			k := 1  // ॡ����
		elseif cy < 18
			k := 2  // �����⮪
		else
			k := 0  // �����
		endif
	endif
	if fl_end
		if type( 'm1vid_ud' ) == 'N' .and. empty( m1vid_ud )
			m1vid_ud := iif( k == 1, 3, 14 )
		endif
	endif
	if ( findKartoteka_bay( oPatient, 1, @mkod ) )
		update_gets()
	endif
	return ret

// 10.08.23 ���� ��樥�� � ����⥪� �� �६� ०��� ����������
function findKartoteka_bay( oPatient, k, /*@*/lkod_k, oPolicyOMS )
	local s, buf, rec := 0
	local obj
	local oBox

	if ! oPatient:IsNew
		return .t.
	endif
	if k == 1 .and. ! emptyany( oPatient:LastName, oPatient:FirstName, oPatient:DOB )
		obj := TPatientDB():getByFIOAndDOB( oPatient:FIO, oPatient:DOB )
	elseif k == 2	// .and. !empty( mnpolis ) .and. p_find_polis > 0
		obj := TPatientDB():getByPolicy( oPolicyOMS:PolicySeries, oPolicyOMS:PolicyNumber )
	elseif k == 3 .and. ! empty( CHARREPL( '0', oPatient:SNILS, ' ' ) )
		obj := TPatientDB():getBySNILS( oPatient:SNILS )
	endif
	//
	if ! isnil( obj )
		oBox := TBox():New( 10, 0, 19, 79, .t. )
		oBox:CaptionColor := 'G+/RB'
		oBox:Color := 'G+/B'
		&& oBox:MessageLine := '^<Esc>^ - ��室;  ^<PgDn>^ - ���⢥ত���� �����'
		oBox:Caption := ' � ����⥪� ������ ��樥�� ' + iif( k == 1, '', iif( k == 2, '� ⠪�� ����ᮬ ', '� ⠪�� ����� ' ) )
		oBox:View()
		infoPatientToScreen( obj, 11, 18 )
		keyboard ''
		music_m( 'OK' )
		Millisec( 100 )  // ����প� �� 0.1 �
		keyboard ''
		if f_alert( { '����� �⮣� ��樥�� �� ����⥪� ��� �த������ ������� ������?' }, ;
					{ ' ���� ��樥�� ', ' ����� �� ����⥪� ' }, ;
					2, 'W+/N', 'N+/N', 20, , 'W+/N,N/BG' ) == 2
			oPatient := obj
			update_gets()
		endif
		oBox := nil
	endif
	return .t.


* 29.11.18 - ������� ᯨ᮪ ��ꥪ⮢ ��
function getListSRF()
	local item, iFind := 0, i
	local oSRF
	local aReturn := {}
	local aOKATOR := T_OKATORDB():getList()
	local aOKATOO := T_OKATOODB():getList()

	for i := 1 to len( glob_array_srf() )
		if  glob_array_srf()[ i, 2 ] == '18000'
			loop
		endif
		iFind := 0
		if ( iFind := ascan( aOKATOO, { | x | x:OKATO == glob_array_srf()[ i, 2 ] } ) ) > 0
			glob_array_srf()[ i, 1 ] := rtrim( aOKATOO[ iFind ]:Name )
		else
			if ( iFind := ascan( aOKATOR, { | x | x:OKATO == left( glob_array_srf()[ i, 2 ], 2 ) } ) ) > 0
				glob_array_srf()[ i, 1 ] := rtrim( aOKATOR[ iFind ]:Name )
			elseif left( glob_array_srf()[ i, 2 ], 2 ) == '55'
				glob_array_srf()[ i, 1 ] := '�.��������'
			endif
		endif
		oSRF := TSRF():New( glob_array_srf()[ i, 2 ], iif( substr( glob_array_srf()[ i, 2 ], 3, 1 ) == '0','', '  ' ) + glob_array_srf()[ i, 1 ] )
		aadd( aReturn, oSRF )
	next
	return aReturn

/*
* 29.11.18 �롮� ��ꥪ� �� �� ᯨ᪠ (�� �᪫�祭��� ������ࠤ᪮� ������ ����� = 18000)
function get_srf( k, r, c )
	local ret := { space( 5 ), space( 10 ) }
	local blkEditObject
	local oBox
	local aProperties
	local selObject
	local cMessage := ''
	local r1, r2
	local item
	
	if r <= maxrow() / 2
		r1 := r
		r2 := maxrow() - 2
	else
		r1 := 2
		r2 := r - 1
	endif
	
	oBox := TBox():New( r1, 2, r2, 77, .t. )
	oBox:Color := color0
	oBox:Caption := '�롮� ��ꥪ� �� (����ਨ ���客����)'
	oBox:CaptionColor := 'BG+/GR'
	aProperties := { { 'OKATO', '�����', 5 }, ;
					{ 'Name', '������������', 66 } }
	blkEditObject := { | oBrowse, aObjects, object, nKey | editSRF( oBrowse, aObjects, object, nKey ) }
	cMessage := ' ^<F2>^ - ����'
	
&& {"�","�","�","N/BG,W+/N,B/BG,W+/B",.f.,72}
	// �롮� ��ꥪ� �� ᯨ᪠
	selObject := ListObjectsBrowse( 'TSRF', oBox, asort( getListSRF(), , , { | x, y | x:OKATO < y:OKATO } ), 1, aProperties, ;
										blkEditObject, , , cMessage, , .t. )
	if ! isnil( selObject )
		ret := { selObject:OKATO, selObject:Name }
	endif
	return ret
*/

* 30.11.18 ���� � �ࠢ�筨�� ��ꥪ⮢ ��
static function editSRF( oBrowse, aObjects, oCommon, nKey )
	local fl := .f.
	local i

	if nKey == K_F2
		if ( i := findElementInListObjects( aObjects, 'Name' ) ) > 0
			nInd := i // �ਢ�⭠� ��६����� �㭪樨 ListObjectsBrowse
		endif
	endif
	return fl

// 12.09.25
function infoPatientToScreen( oPatient, r1, r2 )
	local i, s, s1, mmo_pr, arr := {}
	
	is_talon := .t. // ���� ⠪
	if is_uchastok > 0 .or. glob_mo()[ _MO_IS_UCH ]
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
		if glob_mo()[ _MO_IS_UCH ]
			if left( oPatient:AddInfo:PC2, 1 ) == '1'
				mmo_pr := '�� ���ଠ樨 �� ����� ��樥�� �_�_�_�'
			elseif oPatient:AddInfo:MOCodeAttachment == glob_mo()[ _MO_KOD_TFOMS ]
				mmo_pr := '�ਪ९�� '
				if !empty( oPatient:AddInfo:PC4 )
					mmo_pr += '� ' + alltrim( oPatient:AddInfo:PC4 ) + ' '
				elseif !empty( oPatient:AddInfo:DateAttachment )
					mmo_pr += '� ' + date_8( oPatient:AddInfo:DateAttachment ) + ' '
				endif
				mmo_pr += '� ��襩 ��'
			else
				s1 := alltrim( inieditspr( A__MENUVERT, glob_arr_mo(), oPatient:AddInfo:MOCodeAttachment ) )
				if empty( s1 )
					mmo_pr := '�ਪ९����� --- �������⭮ ---'
				else
					mmo_pr := ''
					if !empty( oPatient:AddInfo:PC4 )
						mmo_pr += '� ' + alltrim( oPatient:AddInfo:PC4 ) + ' '
					elseif !empty( oPatient:AddInfo:DateAttachment )
						mmo_pr += '� ' + date_8( oPatient:AddInfo:DateAttachment ) + ' '
					endif
					mmo_pr += '�ਪ९�� � ' + s1
				endif
			endif
			s += mmo_pr
		endif
		aadd( arr, s )
	endif
	s := '�.�.�.: ' + oPatient:FIO + space( 7 ) + iif( oPatient:Gender == '�', '��稭�', '���騭�' )
	aadd( arr, s )
	s := '��� ஦�����: ' + full_date( oPatient:DOB ) + space( 5 ) + ;
			'(' + alltrim( inieditspr( A__MENUVERT, menu_vzros, oPatient:Vzros_Reb ) ) + ')'
	if !empty( oPatient:SNILS )
//		s += space( 5 ) + '�����: ' + transform( oPatient:SNILS, picture_pf )
		s += space( 5 ) + '�����: ' + transform_SNILS( oPatient:SNILS )
	endif
	aadd( arr, s )
	oPatient:Passport:Format := 'TYPE SSS � NNN �뤠�: DATE'
	s := alltrim( oPatient:Passport:AsString )
	aadd( arr, s )
	s := '���� ஦�����: ' + alltrim( oPatient:ExtendInfo:PlaceBorn )
	aadd( arr, s )
	s := '����: '
	if !emptyall( oPatient:ExtendInfo:OKATOG, oPatient:AddressReg )
		s += left( ret_okato_ulica( oPatient:AddressReg, oPatient:ExtendInfo:OKATOG ), 60 )
	endif
	aadd( arr, s )
	if !emptyall( oPatient:ExtendInfo:OKATOP, oPatient:ExtendInfo:AddressStay )
		s := '���� �ॡ뢠���: ' + left( ret_okato_ulica( oPatient:AddressStay, oPatient:ExtendInfo:OKATOP ), 60 )
		aadd( arr, s )
	endif
	s := '����� ���: '
	if !empty( oPatient:AddInfo:SinglePolicyNumber )
		s += '(��� ' + alltrim( oPatient:AddInfo:SinglePolicyNumber ) + ') '
	endif
	if !emptyall( oPatient:ExtendInfo:BeginPolicy, oPatient:PolicyPeriod )
		s += '('
		if !empty( oPatient:ExtendInfo:BeginPolicy )
			s += '� ' + date_8( oPatient:ExtendInfo:BeginPolicy )
		endif
		if !empty( oPatient:PolicyPeriod )
			s += ' �� ' + date_8( oPatient:PolicyPeriod )
		endif
		s += ') '
	endif
	if !empty( oPatient:ExtendInfo:PolicySeries )
		s += alltrim( oPatient:ExtendInfo:PolicySeries ) + ' '
	endif
	s += alltrim( oPatient:ExtendInfo:PolicyNumber ) + ' (' + ;
		alltrim( inieditspr( A__MENUVERT, mm_vid_polis, oPatient:ExtendInfo:PolicyType ) ) + ') ' + ;
		smo_to_screen_bay( 1, oPatient )
	aadd( arr, s )
	if eq_any( glob_task, X_REGIST, X_OMS, X_PLATN, X_ORTO, X_KASSA, X_PPOKOJ, X_MO )
		s := upper( rtrim( inieditspr( A__MENUVERT, menu_rab, oPatient:Working ) ) )
		if oPatient:ExtendInfo:IsPensioner
			s += space( 5 ) + '���ᨮ���'
		endif
		if !empty( oPatient:PlaceWork )
			s += ',  ���� ࠡ���: ' + oPatient:PlaceWork
		endif
		aadd( arr, s )
	endif

	if eq_any( glob_task, X_MO )
		if !emptyall( oPatient:ExtendInfo:HomePhone, oPatient:ExtendInfo:MobilePhone, oPatient:ExtendInfo:WorkPhone )
			s := '����䮭�:'
			if !empty( oPatient:ExtendInfo:HomePhone )
				s += ' ����譨� ' + oPatient:ExtendInfo:HomePhone
			endif
			if !empty( oPatient:ExtendInfo:MobilePhone )
				s += ' ������� ' + oPatient:ExtendInfo:MobilePhone
			endif
			if !empty( oPatient:ExtendInfo:WorkPhone )
				s += ' ࠡ�稩 ' + oPatient:ExtendInfo:WorkPhone
			endif
			aadd( arr, s )
		endif
		if !empty( oPatient:ExtendInfo:CodeLgot )
			aadd( arr, inieditspr( A__MENUVERT, glob_katl, oPatient:ExtendInfo:CodeLgot ) )
		endif
	endif
	if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_MO )
		s := ''
		if is_talon .and. oPatient:ExtendInfo:Category > 0
			s := '��� ��⥣�ਨ �죮��: ' + rtrim( inieditspr( A__MENUVERT, stm_kategor, oPatient:ExtendInfo:Category ) ) + space( 5 )
		endif
		if !empty( stm_kategor2 ) .and. oPatient:ExtendInfo:Category2 > 0
			s += '��⥣��� ��: ' + rtrim( inieditspr( A__MENUVERT, stm_kategor2, oPatient:ExtendInfo:Category2 ) )
		endif
		aadd( arr, s )
	endif
	//
	for i := 1 to len( arr )
		if r1 + i - 1 > r2
			exit
		endif
		@ r1 + i - 1, 1 say arr[ i ] color color1
	next
	return nil

* 14.12.18 ��� �� �࠭ (�����)
function smo_to_screen_bay( ltip, obj )
	local s := '', s1 := '', lsmo, nsmo, lokato
	local oInogSMO

	&& lsmo := iif( ltip == 1, kart_->smo, human_->smo )
	lsmo := iif( ltip == 1, obj:ExtendInfo:SMO, human_->smo )
	nsmo := int( val( lsmo ) )
	s := inieditspr( A__MENUVERT, glob_arr_smo, nsmo )
	if empty( s ) .or. nsmo == 34
		if nsmo == 34
			if ltip == 1
				oInogSMO := TMo_kismoDB():getByPatient( obj )
			else
			endif
			&& s1 := ret_inogSMO_name( ltip, , .t. )
			s1 := oInogSMO:Name
		else
			&& s1 := init_ismo( lsmo )
			s1 := T_mo_smoDB():getBySMO( lsmo )
		endif
		if !empty( s1 )
			s := alltrim( s1 )
		endif
		&& lokato := iif( ltip == 1, kart_->KVARTAL_D, human_->okato )
		lokato := iif( ltip == 1, obj:ExtendInfo:KvartalHouse, human_->okato )
		if ! empty( lokato )
			s += '/' + inieditspr( A__MENUVERT, glob_array_srf(), lokato )
		endif
	endif
	return s