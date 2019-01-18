#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник учётных единиц объёма _mo_unit.dbf
CREATE CLASS T_Mo_unit	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code READ getCode WRITE setCode								// код
		PROPERTY Name READ getName WRITE setName								// наименование
		PROPERTY Name1251 READ getName1251								// наименование 1251
		PROPERTY PZ READ getPZ WRITE setPZ
		PROPERTY II READ getII WRITE setII
		PROPERTY DateBegin READ getDateBegin WRITE setDateBegin
		PROPERTY DateEnd READ getDateEnd WRITE setDateEnd
  
		METHOD New( nId, lNew, lDeleted )
		&& METHOD listForJSON()
		&& METHOD forJSON()
	HIDDEN:                                      
		DATA FCode		INIT 0
		DATA FPZ		INIT 0
		DATA FII		INIT 0
		DATA FName		INIT space( 60 )
		DATA FDateBegin	INIT ctod( '' )
		DATA FDateEnd	INIT ctod( '' )
		
		METHOD getCode
		METHOD setCode( param )
		METHOD getName
		METHOD setName( param )
		METHOD getName1251
		METHOD getPZ
		METHOD setPZ( param )
		METHOD getII
		METHOD setII( param )
		METHOD getDateBegin
		METHOD setDateBegin( param )
		METHOD getDateEnd
		METHOD setDateEnd( param )
ENDCLASS

METHOD FUNCTION getCode()				CLASS T_Mo_unit
	return ::FCode

METHOD PROCEDURE setCode( param )		CLASS T_Mo_unit

	::FCode := param
	return

METHOD FUNCTION getName()					CLASS T_Mo_unit
	return ::FName

METHOD PROCEDURE setName( param )			CLASS T_Mo_unit

	::FName := param
	return

METHOD FUNCTION getName1251()					CLASS T_Mo_unit
	return win_OEMToANSI( ::FName )

METHOD FUNCTION getPZ()					CLASS T_Mo_unit
	return ::FPZ

METHOD PROCEDURE setPZ( param )			CLASS T_Mo_unit

	::FPZ := param
	return

METHOD FUNCTION getII()				CLASS T_Mo_unit
	return ::FII

METHOD PROCEDURE setII( param )		CLASS T_Mo_unit

	::FII := param
	return

METHOD FUNCTION getDateBegin()				CLASS T_Mo_unit
	return ::FDateBegin

METHOD PROCEDURE setDateBegin( param )		CLASS T_Mo_unit

	::FDateBegin := param
	return

METHOD FUNCTION getDateEnd()				CLASS T_Mo_unit
	return ::FDateEnd

METHOD PROCEDURE setDateEnd( param )		CLASS T_Mo_unit

	::FDateEnd := param
	return

METHOD New( nId, lNew, lDeleted )		CLASS T_Mo_unit
			
	::super:new( nID, lNew, lDeleted )
	return self