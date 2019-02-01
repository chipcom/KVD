#include 'hbclass.ch'
#include 'ini.ch'
#include 'property.ch'
#include 'common.ch'

CREATE CLASS TComDescription

	VISIBLE:
		CLASSDATA aMenuBaudRate AS ARRAY INIT { ;
						{ '75    ', 1 }, { '110   ', 2 }, { '134   ', 3 }, { '150   ', 4 }, { '300   ', 5 }, { '300   ', 6 }, ;
						{ '1200  ', 7 }, { '1800  ', 8 }, { '1800  ', 9 }, { '1800  ', 10 }, { '2400  ', 11 }, { '7200  ', 12 }, ;
						{ '9600  ', 13 }, { '14400 ', 14 }, { '19200 ', 15 }, { '38400 ', 16 }, { '19200 ', 17 }, { '38400 ', 18 }, ;
						{ '57600 ', 19 }, { '115200', 20 }, { '128000', 21 } ;
						}
						
		CLASSDATA aMenuDataBits AS ARRAY INIT { { '4', 1 }, { '5', 2 }, { '6', 3 }, { '7', 4 }, { '8', 5 } }
		CLASSDATA aMenuParity AS ARRAY INIT { { 'Чет   ', 1 }, { 'Нечет ', 2 }, { 'Нет  ', 3 }, { 'Маркер', 4 }, { 'Пробел', 5 }	}

		METHOD New( cPortName )
		
		PROPERTY PortName READ getPort WRITE setPort					// COM-
		PROPERTY BaudRate READ getBaudRate WRITE setBaudRate		// COM-BaudRate
		PROPERTY DataBits READ getDataBits WRITE setDataBits		// COM-DataBits
		PROPERTY Parity READ getParity WRITE setParity		// COM-Parity
	HIDDEN:
		DATA FPort		INIT space( 5 )
		DATA FBaudRate	INIT 9600
		DATA FDataBits	INIT 8
		DATA FParity	INIT space( 6 )

		METHOD getPort					INLINE ::FPort
		METHOD setPort( param )			INLINE ::FPort := param
		METHOD getBaudRate				INLINE ::FBaudRate
		METHOD setBaudRate( param )		INLINE ::FBaudRate := param
		METHOD getDataBits				INLINE ::FDataBits
		METHOD setDataBits( param )		INLINE ::FDataBits := param
		METHOD getParity					INLINE ::FParity
		METHOD setParity( param )		INLINE ::FParity := param
END CLASS

METHOD New( cPort )						CLASS TComDescription

	if ischaracter( cPortName ) .and. Left( ::cPortName, 3 ) == 'COM'
		::FPort := alltrim( cPortName )
	endif
	return self
