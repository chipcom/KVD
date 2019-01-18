#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник T005 _mo_t005
CREATE CLASS T_T005	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code READ getCode WRITE setCode								// код
		PROPERTY Name READ getName WRITE setName								// наименование
		PROPERTY Name1251 READ getName1251								// наименование 1251
  
		METHOD New( nId, lNew, lDeleted )
		&& METHOD listForJSON()
		&& METHOD forJSON()
	HIDDEN:                                      
		DATA FCode		INIT 0
		DATA FName		INIT space( 60 )
		
		METHOD getCode
		METHOD setCode( param )
		METHOD getName
		METHOD setName( param )
		METHOD getName1251
ENDCLASS

METHOD FUNCTION getCode()				CLASS T_T005
	return ::FCode

METHOD PROCEDURE setCode( param )		CLASS T_T005

	::FCode := param
	return

METHOD FUNCTION getName()					CLASS T_T005
	return ::FName

METHOD PROCEDURE setName( param )			CLASS T_T005

	::FName := param
	return

METHOD FUNCTION getName1251()					CLASS T_T005
	return win_OEMToANSI( ::FName )

METHOD New( nId, lNew, lDeleted )		CLASS T_T005
			
	::super:new( nID, lNew, lDeleted )
	return self