#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

// Класс комплексных услуг

// файл "uslugi_k.dbf"
CREATE CLASS TIntegratedService	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName
		PROPERTY Name1251 AS STRING READ getName1251
		PROPERTY Shifr AS STRING READ getShifr WRITE setShifr
		PROPERTY Shifr1251 AS STRING READ getShifr1251
		PROPERTY Services AS ARRAY READ getServices WRITE setServices
		PROPERTY Doctor AS OBJECT READ getDoctor WRITE setDoctor
		PROPERTY Assistant AS OBJECT READ getAssistant WRITE setAssistant

		PROPERTY HasDoctor READ getHasDoctor
		PROPERTY HasAssistant READ getHasAssistant
	
		PROPERTY WithDoctor READ getWithDoctor
		PROPERTY WithAssistant READ getWithAssistant
		
		PROPERTY Doctor_F READ getDoctorFormat
		PROPERTY Assistant_F READ getAssistantFormat
	
		METHOD New( nId, lNew, lDeleted )
		METHOD ChangeShifr( newShifr )
		METHOD CalculatePrice( lAdult, lDMS )

	HIDDEN:
		DATA FName					INIT space( 60 )
		DATA FShifr					INIT space( 10 )
		DATA FServices				INIT {}
		DATA FDoctor				INIT nil
		DATA FAssistant				INIT nil
		DATA FWithDoctor			INIT nil
		DATA FWithAssistant			INIT nil
	
		METHOD getName
		METHOD getName1251
		METHOD setName( cVal )
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cVal )
		METHOD getServices
		METHOD setServices( aVal )
		METHOD getDoctor
		METHOD setDoctor( obj )
		METHOD getAssistant
		METHOD setAssistant( obj )
		METHOD getHasDoctor
		METHOD getHasAssistant
		
		METHOD getWithDoctor
		METHOD getWithAssistant

		METHOD getDoctorFormat
		METHOD getAssistantFormat
ENDCLASS

METHOD FUNCTION getDoctorFormat()				CLASS TIntegratedService
	local ret := ''
	
	if ! isnil( ::FDoctor )
		ret := str( ::FDoctor:TabNom, 6 )
	endif
	return ret

METHOD FUNCTION getAssistantFormat()				CLASS TIntegratedService
	local ret := ''
	
	if ! isnil( ::FAssistant )
		ret := str( ::FAssistant:TabNom, 5 )
	endif
	return ret

METHOD FUNCTION getName()				CLASS TIntegratedService
	return ::FName

METHOD FUNCTION getName1251()			CLASS TIntegratedService
	return win_OEMToANSI( ::FName )

METHOD PROCEDURE setName( cVal )		CLASS TIntegratedService
	::FName := cVal
	return

METHOD FUNCTION getShifr()				CLASS TIntegratedService
	return ::FShifr

METHOD FUNCTION getShifr1251()			CLASS TIntegratedService
	return win_OEMToANSI( ::FShifr )

METHOD PROCEDURE setShifr( cVal )	CLASS TIntegratedService
	::FShifr := cVal
	return

METHOD FUNCTION getServices()			CLASS TIntegratedService
	return ::FServices

METHOD procedure setServices( aVal )			CLASS TIntegratedService
	::FServices := aVal
	return

METHOD FUNCTION getDoctor()				CLASS TIntegratedService
	return ::FDoctor

METHOD PROCEDURE setDoctor( obj )		CLASS TIntegratedService
	::FDoctor := obj
	return

METHOD FUNCTION getAssistant()			CLASS TIntegratedService
	return ::FAssistant

METHOD PROCEDURE setAssistant( obj )	CLASS TIntegratedService
	::FAssistant := obj
	return

METHOD FUNCTION getHasDoctor()			CLASS TIntegratedService
	return ! isnil( ::FDoctor )

METHOD FUNCTION getHasAssistant()		CLASS TIntegratedService
	return ! isnil( ::FAssistant )

METHOD function getWithDoctor()				CLASS TIntegratedService
	local obj := nil
	
	if isnil( ::FWithDoctor )
		if ( obj := TServiceWoDoctorDB():getByShifr( ::FShifr ) ) != nil
			::FWithDoctor := ! obj:IsDoctor
			::FWithAssistant := ! obj:IsAssistant
		else
			::FWithDoctor := .t.
			::FWithAssistant := .t.
		endif
	endif
	return ::FWithDoctor

METHOD function getWithAssistant()			CLASS TIntegratedService
	local obj := nil
	
	if ::FWithAssistant == nil
		if ( obj := TServiceWoDoctorDB():getByShifr( ::FShifr ) ) != nil
			::FWithDoctor := !obj:IsDoctor
			::FWithAssistant := !obj:IsAssistant
		else
			::FWithDoctor := .t.
			::FWithAssistant := .t.
		endif
	endif
	return ::FWithAssistant

METHOD New( nID, lNew, lDeleted ) CLASS TIntegratedService

	::super:new( nID, lNew, lDeleted )
	return self

METHOD ChangeShifr( newShifr ) CLASS TIntegratedService
	local item

	for each item in ::FServices
		item:Shifr( newShifr )
		item:Save()
	next
	return .t.

METHOD CalculatePrice( lAdult, lDMS )		 CLASS TIntegratedService
	local ret := 0
	local oService := nil
	
	// берем цену для платных услуг
	for each oService in ::FServices
		ret := ret + if( ! isnil( oService ), oService:CalculatePrice( hb_defaultValue( lAdult, .t. ), hb_defaultValue( lDms, .f. ) ), 0 )
	next
	return ret
	

// ==============================================================================================	

// класс состава комплексной услуги
CREATE CLASS TComponentsIntegratedService	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Shifr READ getShifr WRITE setShifr
		PROPERTY Shifr1251 READ getShifr1251
		PROPERTY Shifr1 READ getShifr1 WRITE setShifr1
		PROPERTY Shifr1_1251 READ getShifr1_1251
		PROPERTY Service READ getService WRITE setService
		
		PROPERTY Shifr1_F READ getShifr1Format
  
		METHOD New( nId, lNew, lDeleted )
		METHOD CalculatePrice( lAdult, lDMS )
	HIDDEN:
		DATA FShifr				INIT space( 10 )
		DATA FShifr1			INIT space( 10 )
		DATA FService			INIT nil
		
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cVal )
		METHOD getService
		METHOD setService( obj )
		METHOD getShifr1
		METHOD getShifr1_1251
		METHOD setShifr1( cVal )

		METHOD getShifr1Format
ENDCLASS

METHOD FUNCTION getShifr1Format() CLASS TComponentsIntegratedService
	local ret, obj

	if ! empty( ::FShifr1 )
		obj := TServiceDB():getByShifr( ::FShifr1 )
	endif
	if ! isnil( obj )
		ret := obj:Name
	endif
	return ret

METHOD FUNCTION getShifr() CLASS TComponentsIntegratedService
	return ::FShifr

METHOD FUNCTION getShifr1251() CLASS TComponentsIntegratedService
	return win_OEMToANSI( ::FShifr )

METHOD PROCEDURE setShifr( cVal ) CLASS TComponentsIntegratedService
	::FShifr := cVal
	return

METHOD FUNCTION getShifr1() CLASS TComponentsIntegratedService
	return ::FShifr1
	
METHOD FUNCTION getShifr1_1251() CLASS TComponentsIntegratedService
	return win_OEMToANSI( ::FShifr1 )

METHOD FUNCTION getService() CLASS TComponentsIntegratedService
	return ::FService

METHOD procedure setService( obj ) CLASS TComponentsIntegratedService
	 ::FService := obj
	return

METHOD PROCEDURE setShifr1( cVal ) CLASS TComponentsIntegratedService
	::FShifr1 := cVal
	::FService := TServiceDB():getByShifr( cVal )
	return

METHOD New( nID, lNew, lDeleted ) CLASS TComponentsIntegratedService

	::super:new( nID, lNew, lDeleted )
	return self
	
METHOD CalculatePrice( lAdult, lDMS )		 CLASS TComponentsIntegratedService
	local ret := 0
	
	// берем цену для платных услуг
	ret := if( ! isnil( ::FService ), ::FService:CalculatePrice( hb_defaultValue( lAdult, .t. ), hb_defaultValue( lDms, .f. ) ), 0 )
	return ret
