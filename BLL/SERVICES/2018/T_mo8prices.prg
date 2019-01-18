#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8prices.dbf'
CREATE CLASS T_mo8prices	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Shifr		READ getShifr
		PROPERTY Vzros_Reb	READ getVzros_Reb
		PROPERTY Level		READ getLevel
		PROPERTY Cena		READ getCena
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FSHIFR		INIT space( 10 )
		DATA FVZROS_REB	INIT 0
		DATA FLEVEL		INIT space( 5 )
		DATA FCENA		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getShifr
		METHOD getVzros_Reb
		METHOD getLevel
		METHOD getCena
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getShifr()		CLASS T_mo8prices
	return ::FSHIFR

METHOD FUNCTION getVzros_Reb()			CLASS T_mo8prices
	return ::FVZROS_REB

METHOD FUNCTION getLevel()		CLASS T_mo8prices
	return ::FLEVEL

METHOD FUNCTION getCena()			CLASS T_mo8prices
	return ::FCENA

METHOD FUNCTION getDateBegin()	CLASS T_mo8prices
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8prices
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8prices
			
	::super:new( nID, lNew, lDeleted )
	return self