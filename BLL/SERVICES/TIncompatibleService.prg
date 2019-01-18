#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

********************************
// класс для справочника состава несовместимых услуг
CREATE CLASS TIncompatibleService	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDIncompatible READ getIDIncompatible WRITE setIDIncompatible
		PROPERTY Shifr READ getShifr WRITE setShifr
		PROPERTY Shifr1251 READ getShifr1251
		
		PROPERTY Name_F READ getShifrFormat

		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDIncompatible		INIT 0
		DATA FShifr					INIT space( 10 )
		
		METHOD getIDIncompatible
		METHOD setIDIncompatible( nVal )
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cVal )
		
		METHOD getShifrFormat
ENDCLASS

METHOD FUNCTION getShifrFormat()	CLASS TIncompatibleService
	local ret := '', obj := TServiceDB():getByShifr( ::FShifr )
	
	if ! isnil( obj )
		ret := obj:Name
	endif
	return ret

METHOD FUNCTION getIDIncompatible()	CLASS TIncompatibleService
	return ::FIDIncompatible

METHOD PROCEDURE setIDIncompatible( nVal )	CLASS TIncompatibleService

	::FIDIncompatible := nVal
	return

METHOD FUNCTION getShifr()	CLASS TIncompatibleService
	return ::FShifr

METHOD FUNCTION getShifr1251()	CLASS TIncompatibleService
	return win_OEMToANSI( ::FShifr )

METHOD PROCEDURE setShifr( cVal )	CLASS TIncompatibleService

	::FShifr := cVal
	return

METHOD New( nID, lNew, lDeleted )	CLASS TIncompatibleService

	::super:new( nID, lNew, lDeleted )
	return self

********************************
// класс для справочник несовместимых услуг ns_usl.dbf
CREATE CLASS TCompostionIncompService	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Name READ getName WRITE setName
		PROPERTY Name1251 READ getName1251
		PROPERTY Quantity READ getKol WRITE setKol
		PROPERTY IsEmptyServices READ getIsEmptyServices
		PROPERTY IncompatibleServices READ getIncompatibleServices
		
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FName		INIT space( 30 )
		DATA FQuantity	INIT 0
		DATA FServices	INIT {}
		
		METHOD getName
		METHOD setName( cVal )
		METHOD getKol
		METHOD setKol( nVal )
		METHOD getIsEmptyServices
		METHOD getIncompatibleServices
ENDCLASS

METHOD FUNCTION getName()				CLASS TCompostionIncompService
	return ::FName

METHOD FUNCTION getName1251()			CLASS TCompostionIncompService
	return win_OEMToANSI( ::FName )

METHOD PROCEDURE setName( cVal )		CLASS TCompostionIncompService

	::FName := cVal
	return

METHOD FUNCTION getKol()				CLASS TCompostionIncompService
	return ::FQuantity

METHOD PROCEDURE setKol( nVal )		CLASS TCompostionIncompService

	::FQuantity := nVal
	return

METHOD FUNCTION getIsEmptyServices()	CLASS TCompostionIncompService
	return empty( ::FServices )

METHOD FUNCTION getIncompatibleServices()	CLASS TCompostionIncompService
	return ::FServices

METHOD New( nID, lNew, lDeleted )	CLASS TCompostionIncompService

	::super:new( nID, lNew, lDeleted )
	&& if !lNew
		::FServices				:= TIncompatibleServiceDB():getListComposition( nID )	
	&& endif
	return self