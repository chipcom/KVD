#include 'hbclass.ch'
#include 'hbhash.ch' 
#include 'property.ch'

// файл '_mo_mkbk.dbf' - классы МКБ-10
CREATE CLASS TICD10Class	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Class READ getClass
		PROPERTY SH_B READ getSH_B
		PROPERTY SH_E READ getSH_E
		PROPERTY Name READ getName			// название класса
		PROPERTY Name1251 READ getName1251	// название класса в кодировке 1251

		METHOD New( nID, cClass, cSH_B, cSH_E, cName, lNew, lDeleted )
	HIDDEN:
		DATA FClass		INIT space( 5 )
		DATA FSH_B		INIT space( 3 )
		DATA FSH_E		INIT space( 3 )
		DATA FName		INIT ''
		
		METHOD getClass
		METHOD getSH_B
		METHOD getSH_E
		METHOD getName
		METHOD getName1251
ENDCLASS

METHOD FUNCTION getClass()	CLASS TICD10Class
	return ::FClass

METHOD FUNCTION getSH_B()	CLASS TICD10Class
	return ::FSH_B

METHOD FUNCTION getSH_E()	CLASS TICD10Class
	return ::FSH_E

METHOD FUNCTION getName()	CLASS TICD10Class
	return ::FName

METHOD FUNCTION getName1251()	CLASS TICD10Class
	return win_OEMToANSI( ::FName )

***********************************
* Создать новый объект TICD10Class
METHOD New( nID, cClass, cSH_B, cSH_E, cName, lNew, lDeleted ) CLASS TICD10Class
	
	::FNew 		:= hb_defaultValue( lNew, .t. )
	::FDeleted	:= hb_defaultValue( lDeleted, .f. )
	::FID		:= hb_defaultValue( nID, 0 )
	
	::FClass	:= hb_defaultValue( cClass, space( 5 ) )
	::FSH_B		:= hb_defaultValue( cSH_B, space( 3 ) )
	::FSH_E		:= hb_defaultValue( cSH_E, space( 3 ) )
	::FName		:= hb_defaultValue( cName, '' )
	return self