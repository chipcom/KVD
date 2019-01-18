#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник совмещения наших услуг с услугами Минздрава РФ (ФФОМС) mo_su.dbf
CREATE CLASS TMo_su	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Name READ getName WRITE setName
		PROPERTY Name1251 READ getName1251
		PROPERTY Shifr READ getShifr WRITE setShifr
		PROPERTY Shifr1251 READ getShifr1251
		PROPERTY Shifr1 READ getShifr1 WRITE setShifr1
		PROPERTY Shifr1_1251 READ getShifr1_1251
		PROPERTY Type READ getType WRITE setType
		PROPERTY IdSlugba READ getIdSlugba WRITE setIdSlugba
		PROPERTY DentalFormula READ getFDentalFormula WRITE setFDentalFormula
		PROPERTY IdProfil READ getIdProfil WRITE setIdProfil
	
		METHOD New( nID, nKod, lNew, lDeleted )
	HIDDEN:
		DATA FKod			INIT 0
		DATA FName			INIT space( 65 )
		DATA FShifr			INIT space( 10 )
		DATA FShifr1		INIT space( 20 )
		DATA FType			INIT 0
		DATA FIdSlugba		INIT 0
		DATA FDentalFormula	INIT 0
		DATA FIdProfil		INIT 0
		
		METHOD getName
		METHOD setName( cVal )
		METHOD getName1251
		METHOD getShifr
		METHOD setShifr( cVal )
		METHOD getShifr1251
		METHOD getShifr1
		METHOD setShifr1( cVal )
		METHOD getShifr1_1251
		METHOD getType
		METHOD setType( nVal )
		METHOD getIdSlugba
		METHOD setIdSlugba( nVal )
		METHOD getFDentalFormula
		METHOD setFDentalFormula( nVal )
		METHOD getIdProfil
		METHOD setIdProfil( nVal )
ENDCLASS

METHOD FUNCTION getName()				 		CLASS TMo_su
	return ::FName

METHOD PROCEDURE setName( cVal )				CLASS TMo_su
	::FName := cVal
	return

METHOD FUNCTION getName1251()				 	CLASS TMo_su
	return win_OEMToANSI( ::FName )

METHOD FUNCTION getShifr()				 		CLASS TMo_su
	return ::FShifr

METHOD PROCEDURE setShifr( cVal )			CLASS TMo_su
	::FShifr := cVal
	return

METHOD FUNCTION getShifr1251()				 	CLASS TMo_su
	return win_OEMToANSI( ::FShifr )

METHOD FUNCTION getShifr1()				 	CLASS TMo_su
	return ::FShifr1

METHOD PROCEDURE setShifr1( cVal )			CLASS TMo_su
	::FShifr1 := cVal
	return

METHOD FUNCTION getShifr1_1251()				CLASS TMo_su
	return win_OEMToANSI( ::FShifr1 )

METHOD FUNCTION getType()				 		CLASS TMo_su
	return ::FType

METHOD PROCEDURE setType( nVal )				CLASS TMo_su
	::FType := nVal
	return

METHOD FUNCTION getIdSlugba()				 	CLASS TMo_su
	return ::FIdSlugba

METHOD PROCEDURE setIdSlugba( nVal )			CLASS TMo_su
	::FIdSlugba := nVal
	return

METHOD FUNCTION getFDentalFormula()			CLASS TMo_su
	return ::FDentalFormula

METHOD PROCEDURE setFDentalFormula( nVal )	CLASS TMo_su
	::FDentalFormula := nVal
	return

METHOD FUNCTION getIdProfil()				 	CLASS TMo_su
	return ::FIdProfil

METHOD PROCEDURE setIdProfil( nVal )			CLASS TMo_su
	::FIdProfil := nVal
	return


METHOD New( nID, nKod, lNew, lDeleted ) CLASS TMo_su

	::super:new( nID, lNew, lDeleted )
	::FKod :=  nKod
	return self