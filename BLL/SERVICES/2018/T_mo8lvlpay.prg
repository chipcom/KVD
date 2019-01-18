#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8lvlpay.dbf'
CREATE CLASS T_mo8lvlpay	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeM		READ getCodeM
		PROPERTY MCode		READ getMCode
		PROPERTY Usl_Ok		READ getUsl_Ok
		PROPERTY Depart		READ getDepart
		PROPERTY Level		READ getLevel
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODEM		INIT space( 6 )
		DATA FMCODE		INIT space( 6 )
		DATA FUSL_OK	INIT 0
		DATA FDEPART	INIT 0
		DATA FLEVEL		INIT space( 5 )
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCodeM
		METHOD getMCode
		METHOD getUsl_Ok
		METHOD getDepart
		METHOD getLevel
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCodeM()		CLASS T_mo8lvlpay
	return ::FCODEM

METHOD FUNCTION getMCode()		CLASS T_mo8lvlpay
	return ::FMCODE

METHOD FUNCTION getUsl_Ok()			CLASS T_mo8lvlpay
	return ::FUSL_OK

METHOD FUNCTION getDepart()		CLASS T_mo8lvlpay
	return ::FDEPART

METHOD FUNCTION getLevel()		CLASS T_mo8lvlpay
	return ::FLEVEL

METHOD FUNCTION getDateBegin()	CLASS T_mo8lvlpay
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8lvlpay
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8lvlpay
			
	::super:new( nID, lNew, lDeleted )
	return self