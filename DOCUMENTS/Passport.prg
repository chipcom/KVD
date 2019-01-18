#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 25.12.18 ���� ��ᯮ���� ������
&& function inputPassport( oPatient, oPassport, oForeignCitizen, /*@*/sPassport )
function inputPassport( oPatient, oPassport, oForeignCitizen )
	local tmp_keys, tmp_gets, buf
	local iRow
	local oBox
	local series := space( 10 )
	local number := space( 20 )
	local dateIssue := ctod( '' )
	local sCitizen
	local arrError, flagError := .f.
	local sPicture
	local sPictureSeries
	
	if lastkey() != K_ENTER
		return nil
	endif
	private ;
		mstrana := space( 10 ), m1strana := '', ;
		mvid_ud := '', ; // ��� 㤮�⮢�७��
		m1vid_ud := 14, ;	// �� 㬮�砭�� ��ᯮ�� ��
		mkemvyd := space( 46 ), ;
		m1kemvyd := 0
	
	if oPassport:DocumentType != 0
		m1vid_ud := oPassport:DocumentType
		mvid_ud := inieditspr( A__MENUVERT, menu_vidud, m1vid_ud )		// ��� 㤮�⮢�७��
		m1kemvyd := oPassport:IDIssue
		if m1kemvyd == 0
			mkemvyd := space( 46 )
		else
			mkemvyd := left( TPublisherDB():GetByID( m1kemvyd ):Name, 46 )
		endif
		series := oPassport:DocumentSeries
		number := oPassport:DocumentNumber
		dateIssue := oPassport:DateIssue
	else
		if !isnil( oPatient ) .and. oPatient:classname == upper( 'TPatient' )
			if oPatient:IsAdult
				m1vid_ud := 14	// �� 㬮�砭�� ��ᯮ�� �� ��� ������
			else
				m1vid_ud := 3	// �� 㬮�砭�� ��ᯮ�� �� ��� ��ᮢ��襭����⭨�
			endif
		endif
		mvid_ud := inieditspr( A__MENUVERT, menu_vidud, m1vid_ud )		// ��� 㤮�⮢�७��
	endif
	// ��।���� �ࠦ����⢮
	m1strana := oPatient:ExtendInfo:Strana // �ࠦ����⢮ ��樥�� (��࠭�)
	
	mstrana := ini_strana_bay( m1strana )
	
	buf := savescreen()
	change_attr()
	iRow := 10
	tmp_keys := my_savekey()
	save gets to tmp_gets
	
	oBox := TBox():New( iRow, 10, iRow + 7, 70, .t. )
	oBox:CaptionColor := 'B/B*'
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - ��室;  ^<PgDn>^ - ���⢥ত���� �����'
	oBox:Caption := '������஢���� ��ᯮ���� ������'
	oBox:View()
	
	do while .t.
		iRow := 10
		@ ++iRow, 12 say '��-�� ��筮��:' get mvid_ud ;
					reader { | x | menu_reader( x, TPassport():aMenuType, A__MENUVERT, , , .f. ) } ;
					valid { | | ( m1strana := if( IsDocumentCitizenRF( m1vid_ud ), '643', m1strana ), ;
						mstrana := padr( ini_strana_bay( m1strana ), 40 ), ;
						number := padr( number, len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 6 ] ) ), ;
						sPicture := '@S' + str( len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 6 ] ) ), ;
						series := padr( series, if( ! eq_any( m1vid_ud, 1, 3 ), len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 5 ] ), 10 ) ), ;
						sPictureSeries := '@S' + if( ! eq_any( m1vid_ud, 1, 3 ), str( len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 5 ] ) ), '10' ), ;
						update_gets() ) }
						&& sPicture := '@S6', ;

		@ ++iRow, 12 say '����:' get series valid { | oGet | checkDocumentSeries( oGet, m1vid_ud ) } ;
					when if( empty( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 5 ] ), ( series := space( 10 ), .f. ), .t. ) ;
					picture sPictureSeries
					&& pict '@!'
		@ iRow, col() + 1 say '�����:' get number valid { | oGet | checkDocumentNumber( oGet, m1vid_ud ) } ;
					picture sPicture
					&& picture '@!S18' 
	
		@ ++iRow, 12 say '��� �뤠�:' get dateIssue
		@ ++iRow, 12 say '��� �뤠�:' get mkemvyd ;
					reader { | x | menu_reader( x, { { | k, r, c | getPublisher( k, r, c ) } }, A__FUNCTION, , , .f. ) } ;
					when ( IsDocumentCitizenRF( m1vid_ud ) )

		@ ++iRow, 12 say '���� ஦�����' get oPatient:PlaceBorn pict '@S42' ;
					when ( IsDocumentCitizenRF( m1vid_ud ) )

		@ ++iRow, 12 say '�ࠦ����⢮:' get mstrana ;
					valid { | | get_oksm_bay( iRow, oPatient, oForeignCitizen ) } ;
					when ( ! IsDocumentCitizenRF( m1vid_ud ) )
		
		myread()
		if lastkey() != K_ESC
			// ᭠砫� �஢���� �஢��� �� ��������� �㦭� ����
			arrError := {}
			aadd( arrError, '�����㦥�� ᫥���騥 �訡��:' )
			flagError := .f.
			if eq_any( m1vid_ud, 3, 14 ) .and. ! empty( series ) .and. empty( oPatient:PlaceBorn )
				if !( glob_mo[ _MO_KOD_TFOMS ] == '126501' )
					flagError := .t.
					aadd( arrError, iif( m1vid_ud == 3, '��� ᢨ��⥫��⢠ � ஦�����', '��� ��ᯮ�� ��' ) + ;
							' ��易⥫쭮 ���������� ���� "���� ஦�����"' )
				endif
			endif
			if flagError
				hb_Alert( arrError, , , 4 )
				loop
			endif
			oPassport:DocumentType := m1vid_ud
			oPassport:IDIssue := m1kemvyd
			oPassport:DocumentSeries := series
			oPassport:DocumentNumber := number
			oPassport:DateIssue := dateIssue
			&& if ! isnil( sPassport ) .and. oPassport:DocumentType != 0
				&& sPassport := padr( oPassport:AsString, 60 )
			&& endif
			if ! isnil( mPassport ) .and. oPassport:DocumentType != 0
				mPassport := padr( oPassport:AsString, 60 )
			endif
			update_gets()
			// �����࠭��
			oPatient:ExtendInfo:Strana := iif( m1strana == '643', '', m1strana )
			exit
		else
			exit
		endif
	enddo
	oBox := nil
	restscreen( buf )
	restore gets from tmp_gets
	my_restkey( tmp_keys )
	return nil

* 11.12.18 ���㬥�� 㤮�⮢����騩 ��筮��� ���ᨩ᪮� �����樨
function IsDocumentCitizenRF( nVidDoc )

	return eq_any( nVidDoc, 3, 4, 5, 6, 7, 8, 13, 14, 15, 16, 17, 18 )

* 11.12.18 ������ ��࠭�
function ini_strana_bay( lstrana )
	static kod_RF := '643'
	local ret := space( 10 ), i
	
	lstrana := if( empty( lstrana ), kod_RF, lstrana )
	if ( i := ascan( glob_O001, { | x | x[ 2 ] == lstrana } ) ) > 0
		ret := glob_O001[ i, 1 ]
	endif
	return ret

* 11.12.18
function get_oksm_bay( r, oPatient, oForeignCitizen )
	local c := 7, r1, r2, buf, tmp_list, tmp_cursor, tmp_keys
	local oBox
	
	private mosn_preb, m1osn_preb := 0
	
	if oForeignCitizen:IsNew
		oForeignCitizen:AddressRegistration := left( ret_okato_ulica( oPatient:AddressReg, ;
								oPatient:AddressRegistration:OKATO ), 60 )
		if oPatient:Passport:DocumentType == 11	// ��� �� ��⥫��⢮
			m1osn_preb := 1
		elseif oPatient:Passport:DocumentType == 23	// ����-�� �� �६.�஦������
			m1osn_preb := 0
		endif
	else
		m1osn_preb  := oForeignCitizen:BaseOfStay   // �᭮����� �ॡ뢠��� � ��
	endif
	mosn_preb  := inieditspr( A__MENUVERT, TForeignCitizen():aMenuBaseOfStay, m1osn_preb )

	if r < int( maxrow() / 2 )
		r1 := r + 1
		r2 := r1 + 8
	else
		r2 := r - 1
		r1 := r2 - 8
	endif
	buf := savescreen()
	SAVE GETS TO tmp_list
	tmp_cursor := setcursor( 0 )
	tmp_keys := my_savekey()
	change_attr()
	
	oBox := TBox():New( r1, c, r2, 77, .t. )
	oBox:Caption := '�������⥫�� ᢥ����� �����࠭���� �ࠦ������'
	oBox:CaptionColor := 'GR+/BG'
	oBox:Color := color0 + ', , , B/BG'
	oBox:MessageLine := '^<Esc>^ - ��室;  ^<PgDn>^ - ������ � ���室 � ������ ��樥��'
	oBox:View()
	
	&& box_shadow( r1, c, r2, 77, , '���� �������⥫��� ᢥ����� �� �����࠭��', 'GR+/BG' )
	setcursor()
	@ r1 + 1,c + 2 say '��࠭�' get mstrana ;
			reader { | x | menu_reader( x, { { | k, r, c | getCountry( k, r, c ) } }, A__FUNCTION, , , .f. ) }
	@ r1 + 2, c + 2 say '�᭮����� �ॡ뢠��� � ��' get mosn_preb ;
			reader { | x | menu_reader( x, TForeignCitizen():aMenuBaseOfStay, A__MENUVERT, , , .f. ) }
	@ r1 + 3, c + 2 say '���� �஦������ � ������ࠤ᪮� ������'
	@ r1 + 4, c + 3 get oForeignCitizen:AddressRegistration
	@ r1 + 5, c + 2 say '����樮���� ����' get oForeignCitizen:MigrationCard
	@ r1 + 6, c + 2 say '��� ����祭�� �࠭���' get oForeignCitizen:DateBorderCrossing
	@ r1 + 7, c + 2 say '��� ॣ����樨 � ����樮���� �㦡�' get oForeignCitizen:DateRegistration
	myread()
	
	if lastkey() != K_ESC
		oForeignCitizen:BaseOfStay := m1osn_preb
	endif
	oBox := nil
	
	restscreen( buf )
	my_restkey( tmp_keys )
	RESTORE GETS FROM tmp_list
	if tmp_cursor != 0
		setcursor()
	endif
	return .t.

* 27.11.18
function getCountry( k, r, c )
	local ret, r1, r2
	local aCountry := {}, item
	local oBox
	local aProperties

	if ( r1 := r + 1 ) > int( maxrow() / 2 )
		r2 := r - 1
		r1 := 2
	else
		r2 := maxrow() - 2
	endif
	
	for each item in glob_O001
		&& if !( item[ 2 ] == '643' ) // �� ������� �����
			aadd( aCountry, TCountry():New( item[ 2 ], item[ 6 ], item[ 1 ] ) )
		&& endif
	next
	asort( aCountry, , , { | x, y | x:Name < y:Name } )

	oBox := TBox():New( r1, 2, r2, 77, .t. )
	oBox:Caption := '��࠭� ���'
	oBox:CaptionColor := 'GR/W'
	oBox:Color := color5
	
	aProperties := { { 'Name', '������������ ��࠭�', 60 }, { 'CodeN', '���', 3 }, { 'CodeChar', '   ', 3 } }
	selObject := ListObjectsBrowse( 'TCountry', oBox, aCountry, 1, aProperties, ;
										, , , , , .t. )
	if isnil( selObject )
		ret := { 0, space( 10 ) }
	else
		ret := { selObject:CodeN, alltrim( selObject:Name ) }
	endif
	return ret

function isCitizenRF( param )
	local ret := .t., oPassport

	if isobject( param )
		if object:classname == upper( TPatient )
			oPassport := param:Passport
		endif
		if ! ( between( oPassport:DocumentType, 1, 8 ) .or. between( oPassport:DocumentType, 13, 18 ) )
			ret := .f.
		endif
	endif
	return ret

***** �஢�ઠ: "� ��ப� �� ᨬ���� ����?"
function allCharIsDigit( s )
	return empty( charrepl( '0123456789', s, SPACE( 10 ) ) )

***** �஢�ઠ: "� ��ப� �� ᨬ���� ���᪨� �㪢�?"
function allCharIsCyrillic( s )
	return empty( charrepl( '���������������������������������', s, SPACE( 33 ) ) )

***** �஢�ઠ �� �ࠢ��쭮��� �ਨ 㤮�⮢�७�� ��筮��
function checkDocumentSeries( oGet, vid_ud )
	local fl := .t., i, c, _sl, _sr, _n
	local msg, ser_ud
	
	if lastkey() == K_UP
		return fl
	endif
	msg := ''
	ser_ud := alltrim( oGet:buffer )
	if vid_ud == 14 
		if allCharIsDigit( ser_ud ) .and. ( len( ser_ud ) == 4 )	// "��ᯮ�� �ࠦ�.��"
			oGet:pos := 3  // ����� � 3-� ������
			oGet:insert( ' ' )
			oGet:assign()
		else
			_sl := alltrim( token( ser_ud, ' ', 1 ) )
			_sr := alltrim( token( ser_ud, ' ', 2 ) )
			if ( empty( _sl ) .or. len( _sl ) != 2 .or. !allCharIsDigit( _sl ) ) .or. ;
					( empty( _sr ) .or. len( _sr ) != 2 .or. ! allCharIsDigit( _sr ) )
				msg := '��� ��ᯮ�� �� ������ ������ �� ���� ��㧭���� �ᥫ'
			else
				oGet:buffer := _sl + ' ' + _sr
				oGet:assign()
			endif
		endif
	elseif eq_any( vid_ud, 1, 3 )	// "��ᯮ�� �ࠦ�.����" ��� "����-�� � ஦�����"
		_n := numtoken( ser_ud, '-' ) - 1
		_sl := alltrim( token( ser_ud, '-', 1 ) )
		_sl := convertNumberLatinCharInCyrillicChar( _sl )
		_sr := alltrim( token( ser_ud, '-', 2 ) )
		if _n == 0
			msg := '��������� ࠧ����⥫� "-" ��⥩ �ਨ'
		elseif _n > 1
			msg := '��譨� ࠧ����⥫� "-"'
		elseif empty( _sl )
			msg := '��������� �᫮��� ���� �ਨ'
		elseif !empty( charrepl( '1����', _sl, space( 10 ) ) )
			msg := '�᫮��� ���� �ਨ ��⮨� �� ᨬ�����: 1 � � � � (I V X L C)'
		elseif !( _sl == convertNumberLatinCharInCyrillicChar( convertArabicNumberToRoman( convertRomanNumberToArabic( convertNumberCyrillicCharInLatinChar( _sl ) ) ) ) )
			msg := '�����४⭮ ������� �᫮��� ���� �ਨ'
		elseif empty( _sr ) .or. len( _sr ) != 2 .or. !allCharIsCyrillic( _sr )
			msg := '��᫥ ࠧ����⥫� "-" ������ ���� ��� p��c��� �������� �㪢�'
		endif
	endif
	if !empty( msg )
		msg := '"' + ser_ud + '" - ' + msg
		hb_alert( msg, , , 4 )
		fl := .f.
	endif
	return fl

***** �஢�ઠ �� �ࠢ��쭮��� ����� 㤮�⮢�७�� ��筮��
function checkDocumentNumber( oGet, vid_ud )
	static arr_d := { {  1, 6 }, ;
					{  3, 6 }, ;
					{  4, 7  }, ;
					{  6, 6  }, ;
					{  7, 6, 7 }, ;
					{  8, 7  }, ;
					{ 14, 6, 7 }, ;
					{ 15, 7  }, ;
					{ 16, 6, 7 }, ;
					{ 17, 6  } }
	local fl := .t., d1, d2
	local msg
	
	if lastkey() == K_UP
		return fl
	endif
	DEFAULT msg TO ''
	nom_ud := alltrim( oGet:buffer )
	if ( j := ascan( arr_d, { | x | x[ 1 ] == vid_ud } ) ) > 0
		if !allCharIsDigit( nom_ud )
			msg := '�������⨬� ᨬ��� � ����� �.��筮�� "' + alltrim( inieditspr( A__MENUVERT, TPassport():aMenuType, vid_ud ) ) + '"'
		else
			d1 := arr_d[ j, 2 ]
			d2 := iif( len( arr_d[ j ] ) == 2, d1, arr_d[ j, 3 ] )
			if !between( len( nom_ud ), d1, d2 )
				msg := '����୮� ���-�� ��� � ����� �.��筮�� "' + alltrim( inieditspr( A__MENUVERT, TPassport():aMenuType, vid_ud ) ) + '"'
			endif
		endif
	endif
	if !empty( msg )
		msg := '"' + nom_ud + '" - ' + msg
		hb_alert( msg, , , 4 )
		fl := .f.
	endif
	return fl

***** �ᬪ�� �᫮, ����ᠭ��� ��⨭᪨�� ᨬ������, ������� ���᪨�� ᨬ������
function convertNumberLatinCharInCyrillicChar( _s )
	return charrepl( 'IVXLC', _s, '1����' )

***** �ᬪ�� �᫮, ����ᠭ��� ���᪨�� ᨬ������, ������� ��⨭᪨�� ᨬ������
function convertNumberCyrillicCharInLatinChar( _s )
	return charrepl( '1����', _s, 'IVXLC' )

***** ��ॢ��� �ࠡ᪮� �᫮ � ਬ᪮�

function convertArabicNumberToRoman( _s, _c1, _c2, _c3, _c4, _c5, _c6, _c7 )
	local _s1 := replall( str( _s, 3 ), '0' ), _s2, _s3, _n1, _n2, _n3, _ret := ''

	DEFAULT _c1 TO 'I', _c2 TO 'V', _c3 TO 'X', _c4 TO 'L', ;
			_c5 TO 'C', _c6 TO 'D', _c7 TO 'M'
	_n3 := val( substr( _s1, len( _s1 ), 1 ) )
	_n2 := val( substr( _s1, len( _s1 ) - 1, 1 ) )
	_n1 := val( substr( _s1, len( _s1 ) - 2, 1 ) )
	_ret += convertArabicNumeralsToRomanNumerals( _n1, _c5, _c6, _c7 )
	_ret += convertArabicNumeralsToRomanNumerals( _n2, _c3, _c4, _c5 )
	_ret += convertArabicNumeralsToRomanNumerals( _n3, _c1, _c2, _c3 )
	return _ret

***** ��ॢ��� ਬ᪮� �᫮ � �ࠡ᪮�
function convertRomanNumberToArabic(_s, _c1, _c2, _c3, _c4, _c5, _c6, _c7)
	local _ret := 0, i, _nl, aArr := {}
	
	DEFAULT _c1 TO 'I', _c2 TO 'V', _c3 TO 'X', _c4 TO 'L', ;
			_c5 TO  'C', _c6 TO 'D', _c7 TO 'M'
	_s := alltrim( _s )
	_nl := len( _s )
	for i := 1 to _nl
		aadd( aArr, substr( _s, i, 1 ) )
	next
	for i := 1 to _nl
		if aArr[ i ] == _c7
			_ret += 1000
		elseif aArr[ i ] == _c6
			_ret += 500
		elseif aArr[ i ] == _c5
			if i < _nl .and. ( aArr[ i + 1 ] == _c6 .or. aArr[ i + 1 ] == _c7 )
				_ret -= 100
			else
				_ret += 100
			endif
		elseif aArr[ i ] == _c4
			_ret += 50
		elseif aArr[ i ] == _c3
			if i < _nl .and. ( aArr[ i + 1 ] == _c4 .or. aArr[ i + 1 ] == _c5 )
				_ret -= 10
			else
				_ret += 10
			endif
		elseif aArr[ i ] == _c2
			_ret += 5
		elseif aArr[ i ] == _c1
			if i < _nl .and. ( aArr[ i + 1 ] == _c2 .or. aArr[ i + 1 ] == _c3 )
				_ret -= 1
			else
				_ret += 1
			endif
		endif
	next
	return _ret

***** ��ॢ��� �ࠡ��� ���� � ਬ���
function convertArabicNumeralsToRomanNumerals( _s, _c1, _c2, _c3 )
	local _c := ''

	do case
	case _s == 1
		_c := _c1
	case _s == 2
		_c := _c1 + _c1
	case _s == 3
		_c := _c1 + _c1 + _c1
	case _s == 4
		_c := _c1 + _c2
	case _s == 5
		_c := _c2
	case _s == 6
		_c := _c2 + _c1
	case _s == 7
		_c := _c2 + _c1 + _c1
	case _s == 8
		_c := _c2 + _c1 + _c1 + _c1
	case _s == 9
		_c := _c1 + _c3
	endcase
	return _c
