#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8moserv.dbf'
CREATE CLASS T_mo8moserv	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeM		READ getCodeM
		PROPERTY MCode		READ getMCode
		PROPERTY Shifr		READ getShifr
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODEM		INIT space( 6 )
		DATA FMCODE		INIT space( 6 )
		DATA FSHIFR		INIT space( 10 )
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCodeM
		METHOD getMCode
		METHOD getShifr
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCodeM()		CLASS T_mo8moserv
	return ::FCODEM

METHOD FUNCTION getMCode()		CLASS T_mo8moserv
	return ::FMCODE

METHOD FUNCTION getShifr()			CLASS T_mo8moserv
	return ::FSHIFR

METHOD FUNCTION getDateBegin()	CLASS T_mo8moserv
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8moserv
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8moserv
			
	::super:new( nID, lNew, lDeleted )
	return self