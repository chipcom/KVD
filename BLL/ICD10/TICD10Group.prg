#include 'hbclass.ch'
#include 'hbhash.ch' 
#include 'property.ch'

// файл '_mo_mkbg.dbf' - МКБ-10
CREATE CLASS TICD10Group	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY SH_B READ getSH_B
		PROPERTY SH_E READ getSH_E
		PROPERTY Name READ getName			// название группы
		PROPERTY Name1251 READ getName1251	// название группы в кодировке 1251

		METHOD New( nID, cSH_B, cSH_E, cName, lNew, lDeleted )
	HIDDEN:
		DATA FSH_B		INIT space( 3 )
		DATA FSH_E		INIT space( 3 )
		DATA FName		INIT ''
		
		METHOD getSH_B
		METHOD getSH_E
		METHOD getName
		METHOD getName1251
ENDCLASS

METHOD FUNCTION getSH_B()	CLASS TICD10Group
	return ::FSH_B

METHOD FUNCTION getSH_E()	CLASS TICD10Group
	return ::FSH_E

METHOD FUNCTION getName()	CLASS TICD10Group
	return ::FName

METHOD FUNCTION getName1251()	CLASS TICD10Group
	return win_OEMToANSI( ::FName )

***********************************
* Создать новый объект TICD10Group
METHOD New( nID, cSH_B, cSH_E, cName, lNew, lDeleted ) CLASS TICD10Group
	
	::FNew 				:= hb_defaultValue( lNew, .t. )
	::FDeleted			:= hb_defaultValue( lDeleted, .f. )
	::FID				:= hb_defaultValue( nID, 0 )
	
	::FSH_B			:= hb_defaultValue( cSH_B, space( 3 ) )
	::FSH_E			:= hb_defaultValue( cSH_E, space( 3 ) )
	::FName			:= hb_defaultValue( cName, '' )
	return self