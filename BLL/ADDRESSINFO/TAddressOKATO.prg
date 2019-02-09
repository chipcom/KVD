#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

// класс описывающий адрес физического лица с использованием ОКАТО
CREATE CLASS TAddressOKATO
	VISIBLE:
		PROPERTY OKATO WRITE setOKATO INIT space( 11 )
		PROPERTY Address WRITE setAddress INIT space( 50 )
		PROPERTY AsString READ GetAsString( ... )
		PROPERTY Format READ FFormat WRITE SetFormat
		METHOD New( cOKATO, cAddress )
	HIDDEN:
		DATA FFormat INIT ''			// пока пусто
		METHOD setOKATO( cText )
		METHOD setAddress( cText )
		METHOD GetAsString( format, codpage )
		METHOD SetFormat( format ) INLINE ::FFormat := format
ENDCLASS

METHOD New( cOKATO, cAddress )	CLASS TAddressOKATO
	::FOKATO := left( hb_defaultvalue( cOKATO, space( 11 ) ), 11 )
	::FAddress := left( hb_defaultvalue( cAddress, space( 50 ) ), 50 )
	return self

METHOD PROCEDURE setOKATO( cText )	CLASS TAddressOKATO
	::FOKATO := cText
	return

METHOD PROCEDURE setAddress( cText )	CLASS TAddressOKATO
	::FAddress := cText
	return

METHOD FUNCTION GetAsString( format, codepage ) CLASS TAddressOKATO
	local asString := ''
	
	if empty( format )
		format := ::FFormat
	endif
	// изменить для использования форматной строки
	if ! empty( ::FAddress )
		asString := alltrim( ret_okato_ulica( ::FAddress, ::FOKATO, 1, 0 ) )
		if ! isnil( codepage )
			if alltrim( lower( codepage ) ) == 'win-1251'
				asString := win_OEMToANSI( asString )
			endif
		endif
		&& // изменить для использования форматной строки
		&& asString := ret_okato_ulica( alltrim( ::FAddress ), ::FOKATO, 1, 0 )
	endif
	return asString