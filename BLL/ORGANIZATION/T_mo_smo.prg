#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
#include 'chip_mo.ch'

********************************
// класс для объекта иногородних СМО
CREATE CLASS T_mo_smo	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY OKATO READ getOKATO WRITE setOKATO
		PROPERTY SMO READ getSMO WRITE setSMO
		PROPERTY Name READ getName WRITE setName								// наименование
		PROPERTY OGRN READ getOGRN WRITE setOGRN
		PROPERTY BeginDate READ getBeginDate WRITE setBeginDate
		PROPERTY EndDate READ getEndDate WRITE setEndDate
  
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:                                      
		DATA FOKATO		INIT space( 5 )
		DATA FSMO		INIT space( 5 )
		DATA FName		INIT space( 70 )
		DATA FOGRN		INIT space( 15 )
		DATA FBeginDate	INIT ctod( '' )
		DATA FEndDate	INIT ctod( '' )
		
		METHOD getOKATO
		METHOD setOKATO( param )
		METHOD getSMO
		METHOD setSMO( param )
		METHOD getName
		METHOD setName( param )
		METHOD getOGRN
		METHOD setOGRN( param )
		METHOD getBeginDate
		METHOD setBeginDate( param )
		METHOD getEndDate
		METHOD setEndDate( param )
ENDCLASS

METHOD FUNCTION getOKATO()				CLASS T_mo_smo
	return ::FOKATO

METHOD PROCEDURE setOKATO( param )		CLASS T_mo_smo

	if ischaracter( param )
		::FOKATO := param
	endif
	return

METHOD FUNCTION getSMO()				CLASS T_mo_smo
	return ::FSMO

METHOD PROCEDURE setSMO( param )		CLASS T_mo_smo

	if ischaracter( param )
		::FSMO := param
	endif
	return

METHOD FUNCTION getName()					CLASS T_mo_smo
	return ::FName

METHOD PROCEDURE setName( param )			CLASS T_mo_smo

	if ischaracter( param )
		::FName := param
	endif
	return

METHOD FUNCTION getOGRN()					CLASS T_mo_smo
	return ::FOGRN

METHOD PROCEDURE setOGRN( param )			CLASS T_mo_smo

	if ischaracter( param )
		::FOGRN := param
	endif
	return

METHOD FUNCTION getBeginDate()				CLASS T_mo_smo
	return ::FBeginDate

METHOD PROCEDURE setBeginDate( param )		CLASS T_mo_smo

	if isdate( param )
		::FBeginDate := param
	endif
	return

METHOD FUNCTION getEndDate()				CLASS T_mo_smo
	return ::FEndDate

METHOD PROCEDURE setEndDate( param )		CLASS T_mo_smo

	if isdate( param )
		::FEndDate := param
	endif
	return

METHOD New( nId, lNew, lDeleted )		CLASS T_mo_smo
			
	::super:new( nID, lNew, lDeleted )
	return self