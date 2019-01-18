#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

// класс описывающий адрес
CREATE CLASS TAddressInfo
	VISIBLE:
		PROPERTY OKATO AS STRING INDEX 1 READ getValue WRITE setValue	// ОКАТО населенного пункта
		PROPERTY Index AS STRING INDEX 2 READ getValue WRITE setValue		// почтовый индекс
		PROPERTY Region AS STRING INDEX 3 READ getValue WRITE setValue	// регион
		PROPERTY Rayon AS STRING INDEX 4 READ getValue WRITE setValue	// район
		PROPERTY City AS STRING INDEX 5 READ getValue WRITE setValue		// город
		PROPERTY NasPunkt AS STRING INDEX 6 READ getValue WRITE setValue	// населенный пункт
		PROPERTY Address AS STRING INDEX 7 READ getValue WRITE setValue	// улица
		PROPERTY House AS STRING INDEX 8 READ getValue WRITE setValue	// дом
		PROPERTY Building AS STRING INDEX 9 READ getValue WRITE setValue	// корпус
		PROPERTY Flat AS STRING INDEX 10 READ getValue WRITE setValue	// квартира
		
		PROPERTY AsString READ GetAsString( ... )
		PROPERTY Format READ FFormat WRITE SetFormat
		METHOD New( cOKATO, cAddress )
	HIDDEN:
		DATA FFormat INIT ''			// пока пусто
		DATA FOKATO INIT space( 11 )
		DATA FIndex INIT space( 6 )
		DATA FRegion INIT space( 72 )
		DATA FRayon INIT space( 72 )
		DATA FCity INIT space( 72 )
		DATA FNasPunkt INIT space( 72 )
		DATA FAddress INIT space( 50 )
		DATA FHouse INIT space( 4 )
		DATA FBuilding INIT space( 4 )
		DATA FFlat INIT space( 4 )
		
		METHOD getValue( index )
		METHOD setValue( index, param )
		
		METHOD GetAsString( format, codpage )
		METHOD SetFormat( format ) INLINE ::FFormat := format
ENDCLASS

METHOD New( cOKATO, cAddress )	CLASS TAddressInfo
	::FOKATO := left( hb_defaultvalue( cOKATO, space( 11 ) ), 11 )
	::FAddress := left( hb_defaultvalue( cAddress, space( 50 ) ), 50 )
	return self

METHOD FUNCTION GetAsString( format, codepage ) CLASS TAddressInfo
	local asString := ''
	
	if empty( format )
		format := ::FFormat
	endif
	// изменить для использования форматной строки
	asString := alltrim( ret_okato_ulica( ::FAddress, ::FOKATO, 1, 0 ) )
	if ! isnil( codepage )
		if alltrim( lower( codepage ) ) == 'win-1251'
			asString := win_OEMToANSI( asString )
		endif
	endif
	&& // изменить для использования форматной строки
	&& asString := ret_okato_ulica( alltrim( ::FAddress ), ::FOKATO, 1, 0 )
	return asString

METHOD function getValue( index )	CLASS TAddressInfo
	local ret
	
	switch index
		case 1
			ret := ::FOKATO
			exit
		case 2
			ret := ::FIndex
			exit
		case 3
			ret := ::FRegion
			exit
		case 4
			ret := ::FRayon
			exit
		case 5
			ret := ::FCity
			exit
		case 6
			ret := ::FNasPunkt
			exit
		case 7
			ret := ::FAddress
			exit
		case 8
			ret := ::FHouse
			exit
		case 9
			ret := ::FBuilding
			exit
		case 10
			ret := ::FFlat
			exit
	endswitch
	return ret

METHOD procedure setValue( index, param )	CLASS TAddressInfo
	
	switch index
		case 1
			::FOKATO := param
			exit
		case 2
			::FIndex := param
			exit
		case 3
			::FRegion := param
			exit
		case 4
			::FRayon := param
			exit
		case 5
			::FCity := param
			exit
		case 6
			::FNasPunkt := param
			exit
		case 7
			::FAddress := param
			exit
		case 8
			::FHouse := param
			exit
		case 9
			::FBuilding := param
			exit
		case 10
			::FFlat := param
			exit
	endswitch
	return