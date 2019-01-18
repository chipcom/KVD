#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8k006.dbf'
CREATE CLASS T_mo8k006	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Shifr		READ getShifr
		PROPERTY KZ			READ getKz
		PROPERTY Profil		READ getProfil
		PROPERTY DS			READ getDS
		PROPERTY DS1		READ getDS1
		PROPERTY DS2		READ getDS2
		PROPERTY SY			READ getSY
		PROPERTY Age		READ getAge
		PROPERTY Sex		READ getSex
		PROPERTY LOS		READ getLOS
		PROPERTY AD_CR		READ getAD_CR
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		PROPERTY NS			READ getNS

		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FSHIFR		INIT space( 6 )
		DATA FKZ		INIT 0
		DATA FPROFIL	INIT 0
		DATA FDS		INIT space( 6 )
		DATA FDS1
		DATA FDS2
		DATA FSY		INIT space( 20 )
		DATA FAGE		INIT space( 1 )
		DATA FSEX		INIT space( 1 )
		DATA FLOS		INIT space( 1 )
		DATA FAD_CR		INIT space( 20 )
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )
		DATA FNS		INIT 0
		
		
		METHOD getShifr
		METHOD getKz		
		METHOD getProfil		
		METHOD getDS		
		METHOD getDS1		
		METHOD getDS2		
		METHOD getSY		
		METHOD getAge		
		METHOD getSex
		METHOD getLOS
		METHOD getAD_CR
		METHOD getDateBegin
		METHOD getDateEnd		
		METHOD getNS		
ENDCLASS

METHOD FUNCTION getShifr()		CLASS T_mo8k006
	return ::FSHIFR

METHOD FUNCTION getKz()		CLASS T_mo8k006
	return ::FKZ

METHOD FUNCTION getProfil()			CLASS T_mo8k006
	return ::FPROFIL

METHOD FUNCTION getDS()		CLASS T_mo8k006
	return ::FDS

METHOD FUNCTION getDS1()		CLASS T_mo8k006
	return ::FDS1

METHOD FUNCTION getDS2()		CLASS T_mo8k006
	return ::FDS2

METHOD FUNCTION getSY()		CLASS T_mo8k006
	return ::FSY

METHOD FUNCTION getAge()		CLASS T_mo8k006
	return ::FAGE

METHOD FUNCTION getSex()		CLASS T_mo8k006
	return ::FSEX

METHOD FUNCTION getLOS()		CLASS T_mo8k006
	return ::FLOS

METHOD FUNCTION getAD_CR()		CLASS T_mo8k006
	return ::FAD_CR

METHOD FUNCTION getDateBegin()	CLASS T_mo8k006
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8k006
	return ::FDATEEND

METHOD FUNCTION getNS()		CLASS T_mo8k006
	return ::FNS

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8k006
			
	::super:new( nID, lNew, lDeleted )
	return self