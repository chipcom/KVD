#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

***** проверка на правильность серии удостоверения личности
function control_UL_series( par, vid_ud, ser_ud, /*@*/msg )
	local fl := .t., i, c, _sl, _sr, _n
	
	msg := ''
	ser_ud := alltrim( ser_ud )
	if vid_ud == 14
		_sl := alltrim( token( ser_ud, ' ', 1 ) )
		_sr := alltrim( token( ser_ud, ' ', 2 ) )
		if ( empty( _sl ) .or. len( _sl ) != 2 .or. !allCharactersAreDigits( _sl ) ) .or. ;
				( empty( _sr ) .or. len( _sr ) != 2 .or. !allCharactersAreDigits( _sr ) )
			msg := 'серия паспорта РФ должна состоять из двух двузначных чисел'
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
		elseif empty( _sr ) .or. len( _sr ) != 2 .or. !allCharactersAreCyrillic( _sr )
			msg := 'после разделителя "-" должны быть ДВЕ pусcкие заглавные буквы'
		endif
	endif
	if !empty( msg )
		msg := '"' + ser_ud + '" - ' + msg
		if par == 1  // для GET-системы
			func_error( 4, msg )
		else  // для проверки ТФОМС
			fl := .f.
		endif
	endif
	return fl

***** проверка на правильность номера удостоверения личности
function control_UL_number( par, vid_ud, nom_ud, /*@*/msg )
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
	
	DEFAULT msg TO ''
	nom_ud := alltrim( nom_ud )
	if ( j := ascan( arr_d, { | x | x[ 1 ] == vid_ud } ) ) > 0
		if !allCharactersAreDigits( nom_ud )
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
		if par == 1  // для GET-системы
			func_error( 4, msg )
		else  // для проверки ТФОМС
			fl := .f.
		endif
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
