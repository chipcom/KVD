#include 'hbclass.ch'
#include 'property.ch'

*************************	
**
CREATE CLASS TServiceOfCheck

	VISIBLE:
		PROPERTY Section AS NUMERIC READ getSection WRITE setSection		// ᥪ�� �த���
		PROPERTY Shifr AS STRING READ getShifr WRITE setShifr			// ��� ��㣨
		PROPERTY Shifr1251 READ getShifr1251								// ��� ��㣨 � ������� ��࠭�� Win1251
		PROPERTY Name AS STRING READ getName WRITE setName				// ������������ ��㣨
		PROPERTY Name1251 READ getName1251								// ������������ ��㣨 � ������� ��࠭�� Win1251
		PROPERTY Doctor AS STRING READ getDoctor WRITE setDoctor			// �.�.�. ���
		PROPERTY Doctor1251 READ getDoctor1251							// �.�.�. ��� � ������� ��࠭�� Win1251
		PROPERTY Price AS NUMERIC READ getPrice WRITE setPrice			// �⮨����� ��㣨
		PROPERTY Quantity AS NUMERIC READ getQuantity WRITE setQuantity	// ������⢮ ���
		PROPERTY Tax AS NUMERIC READ getTax WRITE setTax					// �⠢�� ������ �� ����
		
		METHOD New( section, shifr, name, doctor, price, quantity, tax )
		METHOD ServiceToString( lShifr, lName )
	HIDDEN:
		DATA FSection				INIT 1
		DATA FShifr					INIT ''
		DATA FName					INIT ''
		DATA FDoctor				INIT ''
		DATA FPrice					INIT 0.0
		DATA FQuantity				INIT 0
		DATA FTax					INIT 0
		
		METHOD getSection
		METHOD setSection( nValue )
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cValue )
		METHOD getName
		METHOD getName1251
		METHOD setName( cValue )
		METHOD getDoctor
		METHOD getDoctor1251
		METHOD setDoctor( cValue )
		METHOD getPrice
		METHOD setPrice( nValue )
		METHOD getQuantity
		METHOD setQuantity( nValue )
		METHOD getTax
		METHOD setTax( nValue )
END CLASS


METHOD function getSection()				CLASS TServiceOfCheck
	return ::FSection

METHOD procedure setSection( nValue )	CLASS TServiceOfCheck
	::FSection := nValue
	return

METHOD function getShifr()					CLASS TServiceOfCheck
	return ::FShifr

METHOD procedure setShifr( cValue )		CLASS TServiceOfCheck
	::FShifr := cValue
	return

METHOD FUNCTION getShifr1251()				CLASS TServiceOfCheck
	return win_OEMToANSI( ::FShifr )
	
METHOD function getName()					CLASS TServiceOfCheck
	return ::FName

METHOD procedure setName( cValue )		CLASS TServiceOfCheck
	::FName := cValue
	return

METHOD FUNCTION getName1251()				CLASS TServiceOfCheck
	return win_OEMToANSI( ::FName )
	
METHOD function getDoctor()					CLASS TServiceOfCheck
	return ::FDoctor

METHOD procedure setDoctor( cValue )		CLASS TServiceOfCheck
	::FDoctor := cValue
	return

METHOD FUNCTION getDoctor1251()				CLASS TServiceOfCheck
	return win_OEMToANSI( ::FDoctor )
	
METHOD function getPrice()					CLASS TServiceOfCheck
	return ::FPrice

METHOD procedure setPrice( nValue )		CLASS TServiceOfCheck
	::FPrice := nValue
	return

METHOD function getQuantity()				CLASS TServiceOfCheck
	return ::FQuantity

METHOD procedure setQuantity( nValue )	CLASS TServiceOfCheck
	::FQuantity := nValue
	return

METHOD function getTax()					CLASS TServiceOfCheck
	return ::FTax

METHOD procedure setTax( nValue )		CLASS TServiceOfCheck
	::FTax := nValue
	return

METHOD New( section, shifr, name, doctor, price, quantity, tax ) CLASS TServiceOfCheck

	::FSection := HB_DefaultValue( section, 1 )
	::FShifr := HB_DefaultValue( shifr, '' )
	::FName := HB_DefaultValue( name, '' )
	::FDoctor := HB_DefaultValue( doctor, '' )
	::FPrice := HB_DefaultValue( price, 0 )
	::FQuantity := HB_DefaultValue( quantity, 0 )
	::FTax := HB_DefaultValue( tax, 0 )
	return self

// ����祭�� ��ப� ������������ ��㣨
// lShifr - �뢮� ���, .t. - ��, .f. - ���
// lName - �뢮� ��������, .t. - ��, .f. - ���
METHOD ServiceToString( lShifr, lName ) CLASS TServiceOfCheck
	
	return alltrim( substr( iif( HB_DefaultValue( lShifr, .t. ), alltrim( ::FShifr ) + ' ', '' ) ;
			+ iif( HB_DefaultValue( lName, .t. ), alltrim( ::FName ), '' ), 1, 40 ) )
