#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 25.12.18 ввод паспортных данных
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
		mvid_ud := '', ; // вид удостоверения
		m1vid_ud := 14, ;	// по умолчанию паспорт РФ
		mkemvyd := space( 46 ), ;
		m1kemvyd := 0
	
	if oPassport:DocumentType != 0
		m1vid_ud := oPassport:DocumentType
		mvid_ud := inieditspr( A__MENUVERT, menu_vidud, m1vid_ud )		// вид удостоверения
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
				m1vid_ud := 14	// по умолчанию паспорт РФ для взрослых
			else
				m1vid_ud := 3	// по умолчанию паспорт РФ для несовершеннолетних
			endif
		endif
		mvid_ud := inieditspr( A__MENUVERT, menu_vidud, m1vid_ud )		// вид удостоверения
	endif
	// определим гражданство
	m1strana := oPatient:ExtendInfo:Strana // гражданство пациента (страна)
	
	mstrana := ini_strana_bay( m1strana )
	
	buf := savescreen()
	change_attr()
	iRow := 10
	tmp_keys := my_savekey()
	save gets to tmp_gets
	
	oBox := TBox():New( iRow, 10, iRow + 7, 70, .t. )
	oBox:CaptionColor := 'B/B*'
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - выход;  ^<PgDn>^ - подтверждение ввода'
	oBox:Caption := 'Редактирование паспортных данных'
	oBox:View()
	
	do while .t.
		iRow := 10
		@ ++iRow, 12 say 'Уд-ие личности:' get mvid_ud ;
					reader { | x | menu_reader( x, TPassport():aMenuType, A__MENUVERT, , , .f. ) } ;
					valid { | | ( m1strana := if( IsDocumentCitizenRF( m1vid_ud ), '643', m1strana ), ;
						mstrana := padr( ini_strana_bay( m1strana ), 40 ), ;
						number := padr( number, len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 6 ] ) ), ;
						sPicture := '@S' + str( len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 6 ] ) ), ;
						series := padr( series, if( ! eq_any( m1vid_ud, 1, 3 ), len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 5 ] ), 10 ) ), ;
						sPictureSeries := '@S' + if( ! eq_any( m1vid_ud, 1, 3 ), str( len( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 5 ] ) ), '10' ), ;
						update_gets() ) }
						&& sPicture := '@S6', ;

		@ ++iRow, 12 say 'Серия:' get series valid { | oGet | checkDocumentSeries( oGet, m1vid_ud ) } ;
					when if( empty( TPassport():aMenuType[ if( m1vid_ud <= 18, m1vid_ud, m1vid_ud - 2 ), 5 ] ), ( series := space( 10 ), .f. ), .t. ) ;
					picture sPictureSeries
					&& pict '@!'
		@ iRow, col() + 1 say 'Номер:' get number valid { | oGet | checkDocumentNumber( oGet, m1vid_ud ) } ;
					picture sPicture
					&& picture '@!S18' 
	
		@ ++iRow, 12 say 'Дата выдачи:' get dateIssue
		@ ++iRow, 12 say 'Кем выдан:' get mkemvyd ;
					reader { | x | menu_reader( x, { { | k, r, c | getPublisher( k, r, c ) } }, A__FUNCTION, , , .f. ) } ;
					when ( IsDocumentCitizenRF( m1vid_ud ) )

		@ ++iRow, 12 say 'Место рождения' get oPatient:PlaceBorn pict '@S42' ;
					when ( IsDocumentCitizenRF( m1vid_ud ) )

		@ ++iRow, 12 say 'Гражданство:' get mstrana ;
					valid { | | get_oksm_bay( iRow, oPatient, oForeignCitizen ) } ;
					when ( ! IsDocumentCitizenRF( m1vid_ud ) )
		
		myread()
		if lastkey() != K_ESC
			// сначала проведем проверку что заполнены нужные поля
			arrError := {}
			aadd( arrError, 'Обнаружены следующие ошибки:' )
			flagError := .f.
			if eq_any( m1vid_ud, 3, 14 ) .and. ! empty( series ) .and. empty( oPatient:PlaceBorn )
				if !( glob_mo[ _MO_KOD_TFOMS ] == '126501' )
					flagError := .t.
					aadd( arrError, iif( m1vid_ud == 3, 'для свидетельства о рождении', 'для паспорта РФ' ) + ;
							' обязательно заполнение поля "Место рождения"' )
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
			// иностранец
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

* 11.12.18 документ удостоверяющий личность Российской Федерации
function IsDocumentCitizenRF( nVidDoc )

	return eq_any( nVidDoc, 3, 4, 5, 6, 7, 8, 13, 14, 15, 16, 17, 18 )

* 11.12.18 вернуть страну
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
		if oPatient:Passport:DocumentType == 11	// Вид на жительство
			m1osn_preb := 1
		elseif oPatient:Passport:DocumentType == 23	// Разр-ие на врем.проживание
			m1osn_preb := 0
		endif
	else
		m1osn_preb  := oForeignCitizen:BaseOfStay   // основание пребывания в РФ
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
	oBox:Caption := 'Дополнительные сведения иностранного гражданина'
	oBox:CaptionColor := 'GR+/BG'
	oBox:Color := color0 + ', , , B/BG'
	oBox:MessageLine := '^<Esc>^ - выход;  ^<PgDn>^ - запись и переход в карточку пациента'
	oBox:View()
	
	&& box_shadow( r1, c, r2, 77, , 'Ввод дополнительных сведений по иностранцу', 'GR+/BG' )
	setcursor()
	@ r1 + 1,c + 2 say 'Страна' get mstrana ;
			reader { | x | menu_reader( x, { { | k, r, c | getCountry( k, r, c ) } }, A__FUNCTION, , , .f. ) }
	@ r1 + 2, c + 2 say 'Основание пребывания в РФ' get mosn_preb ;
			reader { | x | menu_reader( x, TForeignCitizen():aMenuBaseOfStay, A__MENUVERT, , , .f. ) }
	@ r1 + 3, c + 2 say 'Адрес проживания в Волгоградской области'
	@ r1 + 4, c + 3 get oForeignCitizen:AddressRegistration
	@ r1 + 5, c + 2 say 'Миграционная карта' get oForeignCitizen:MigrationCard
	@ r1 + 6, c + 2 say 'Дата пересечения границы' get oForeignCitizen:DateBorderCrossing
	@ r1 + 7, c + 2 say 'Дата регистрации в миграционной службе' get oForeignCitizen:DateRegistration
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
		&& if !( item[ 2 ] == '643' ) // не включать Россию
			aadd( aCountry, TCountry():New( item[ 2 ], item[ 6 ], item[ 1 ] ) )
		&& endif
	next
	asort( aCountry, , , { | x, y | x:Name < y:Name } )

	oBox := TBox():New( r1, 2, r2, 77, .t. )
	oBox:Caption := 'Страны мира'
	oBox:CaptionColor := 'GR/W'
	oBox:Color := color5
	
	aProperties := { { 'Name', 'Наименование страны', 60 }, { 'CodeN', 'Код', 3 }, { 'CodeChar', '   ', 3 } }
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

***** проверка: "в строке все символы цифры?"
function allCharIsDigit( s )
	return empty( charrepl( '0123456789', s, SPACE( 10 ) ) )

***** проверка: "в строке все символы русские буквы?"
function allCharIsCyrillic( s )
	return empty( charrepl( 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ', s, SPACE( 33 ) ) )

***** проверка на правильность серии удостоверения личности
function checkDocumentSeries( oGet, vid_ud )
	local fl := .t., i, c, _sl, _sr, _n
	local msg, ser_ud
	
	if lastkey() == K_UP
		return fl
	endif
	msg := ''
	ser_ud := alltrim( oGet:buffer )
	if vid_ud == 14 
		if allCharIsDigit( ser_ud ) .and. ( len( ser_ud ) == 4 )	// "Паспорт гражд.РФ"
			oGet:pos := 3  // курсор в 3-ю позицию
			oGet:insert( ' ' )
			oGet:assign()
		else
			_sl := alltrim( token( ser_ud, ' ', 1 ) )
			_sr := alltrim( token( ser_ud, ' ', 2 ) )
			if ( empty( _sl ) .or. len( _sl ) != 2 .or. !allCharIsDigit( _sl ) ) .or. ;
					( empty( _sr ) .or. len( _sr ) != 2 .or. ! allCharIsDigit( _sr ) )
				msg := 'серия паспорта РФ должна состоять из двух двузначных чисел'
			else
				oGet:buffer := _sl + ' ' + _sr
				oGet:assign()
			endif
		endif
	elseif eq_any( vid_ud, 1, 3 )	// "Паспорт гражд.СССР" или "Свид-во о рождении"
		_n := numtoken( ser_ud, '-' ) - 1
		_sl := alltrim( token( ser_ud, '-', 1 ) )
		_sl := convertNumberLatinCharInCyrillicChar( _sl )
		_sr := alltrim( token( ser_ud, '-', 2 ) )
		if _n == 0
			msg := 'отсутствует разделитель "-" частей серии'
		elseif _n > 1
			msg := 'лишний разделитель "-"'
		elseif empty( _sl )
			msg := 'отсутствует числовая часть серии'
		elseif !empty( charrepl( '1УХЛС', _sl, space( 10 ) ) )
			msg := 'числовая часть серии состоит из символов: 1 У Х Л С (I V X L C)'
		elseif !( _sl == convertNumberLatinCharInCyrillicChar( convertArabicNumberToRoman( convertRomanNumberToArabic( convertNumberCyrillicCharInLatinChar( _sl ) ) ) ) )
			msg := 'некорректно введена числовая часть серии'
		elseif empty( _sr ) .or. len( _sr ) != 2 .or. !allCharIsCyrillic( _sr )
			msg := 'после разделителя "-" должны быть ДВЕ pусcкие заглавные буквы'
		endif
	endif
	if !empty( msg )
		msg := '"' + ser_ud + '" - ' + msg
		hb_alert( msg, , , 4 )
		fl := .f.
	endif
	return fl

***** проверка на правильность номера удостоверения личности
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
			msg := 'недопустимый символ в номере уд.личности "' + alltrim( inieditspr( A__MENUVERT, TPassport():aMenuType, vid_ud ) ) + '"'
		else
			d1 := arr_d[ j, 2 ]
			d2 := iif( len( arr_d[ j ] ) == 2, d1, arr_d[ j, 3 ] )
			if !between( len( nom_ud ), d1, d2 )
				msg := 'неверное кол-во цифр в номере уд.личности "' + alltrim( inieditspr( A__MENUVERT, TPassport():aMenuType, vid_ud ) ) + '"'
			endif
		endif
	endif
	if !empty( msg )
		msg := '"' + nom_ud + '" - ' + msg
		hb_alert( msg, , , 4 )
		fl := .f.
	endif
	return fl

***** рисмкое число, записанное латинскими символами, записать русскими символами
function convertNumberLatinCharInCyrillicChar( _s )
	return charrepl( 'IVXLC', _s, '1УХЛС' )

***** рисмкое число, записанное русскими символами, записать латинскими символами
function convertNumberCyrillicCharInLatinChar( _s )
	return charrepl( '1УХЛС', _s, 'IVXLC' )

***** перевести арабское число в римское

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

***** перевести римское число в арабское
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

***** перевести арабскую цифру в римскую
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
