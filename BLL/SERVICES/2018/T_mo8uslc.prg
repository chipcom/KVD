#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8uslc.dbf'
CREATE CLASS T_mo88uslc	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeMO		READ getCodeMO
		PROPERTY Shifr		READ getShifr
		PROPERTY Shifr1251	READ getShifr1251
		PROPERTY USL_OK		READ getUSL_OK
		PROPERTY DEPART		READ getDepart
		PROPERTY Uroven		READ getUroven
		PROPERTY Vzros_Reb	READ getVzros_Reb
		PROPERTY Cena		READ getCena
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd

		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODEMO	INIT space( 6 )
		DATA FSHIFR		INIT space( 10 )
		DATA FUSL_OK	INIT 0
		DATA FDEPART	INIT 0
		DATA FUROVEN	INIT space( 5 )
		DATA FVZROS_REB	INIT 0
		DATA FCENA		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCodeMO
		METHOD getShifr
		METHOD getShifr1251
		METHOD getUSL_OK
		METHOD getDepart
		METHOD getUroven
		METHOD getVzros_Reb
		METHOD getCena
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCodeMO()		CLASS T_mo88uslc
	return ::FCODEMO

METHOD FUNCTION getShifr()		CLASS T_mo88uslc
	return ::FSHIFR

METHOD FUNCTION getShifr1251()	CLASS T_mo88uslc
	return win_OEMToANSI( ::FSHIFR )

METHOD FUNCTION getUSL_OK()		CLASS T_mo88uslc
	return ::FUSL_OK

METHOD FUNCTION getDepart()		CLASS T_mo88uslc
	return ::FDEPART

METHOD FUNCTION getUroven()		CLASS T_mo88uslc
	return ::FUROVEN

METHOD FUNCTION getVzros_Reb()	CLASS T_mo88uslc
	return ::FVZROS_REB

METHOD FUNCTION getCena()			CLASS T_mo88uslc
	return ::FCENA

METHOD FUNCTION getDateBegin()	CLASS T_mo88uslc
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo88uslc
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo88uslc
			
	::super:new( nID, lNew, lDeleted )
	return self