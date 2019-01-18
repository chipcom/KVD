#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8deppr.dbf'
CREATE CLASS T_mo8deppr	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeM		READ getCodeM
		PROPERTY MCode		READ getMCode
		PROPERTY Code		READ getCode
		PROPERTY Place		READ getPlace
		PROPERTY Pr_Berth	READ getPr_Berth
		PROPERTY Pr_MP		READ getPr_MP
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )

	HIDDEN:
		DATA FCODEM		INIT space( 6 )
		DATA FMCODE		INIT space( 6 )
		DATA FCODE		INIT 0
		DATA FPLACE		INIT 0
		DATA FPR_BERTH	INIT 0
		DATA FPR_MP		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCodeM
		METHOD getMCode
		METHOD getCode
		METHOD getPlace
		METHOD getPr_Berth
		METHOD getPr_MP
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCodeM()		CLASS T_mo8deppr
	return ::FCODEM

METHOD FUNCTION getMCode()		CLASS T_mo8deppr
	return ::FMCODE

METHOD FUNCTION getCode()			CLASS T_mo8deppr
	return ::FCODE

METHOD FUNCTION getPlace()		CLASS T_mo8deppr
	return ::FPLACE

METHOD FUNCTION getPr_Berth()		CLASS T_mo8deppr
	return ::FPR_BERTH

METHOD FUNCTION getPr_MP()		CLASS T_mo8deppr
	return ::FPR_MP

METHOD FUNCTION getDateBegin()	CLASS T_mo8deppr
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8deppr
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8deppr

	::super:new( nID, lNew, lDeleted )
	return self