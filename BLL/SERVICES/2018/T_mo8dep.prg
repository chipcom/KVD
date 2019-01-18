#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8dep.dbf'
CREATE CLASS T_mo8dep	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeM		READ getCodeM
		PROPERTY MCode		READ getMCode
		PROPERTY Code		READ getCode
		PROPERTY Place		READ getPlace
		PROPERTY Name		READ getName
		PROPERTY Name_Short	READ getNameShort
		PROPERTY Usl_Ok		READ getUsl_Ok
		PROPERTY VMP		READ getVMP
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODEM		INIT space( 6 )
		DATA FMCODE		INIT space( 6 )
		DATA FCODE		INIT 0
		DATA FPLACE		INIT 0
		DATA FNAME		INIT space( 100 )
		DATA FNAME_SHORT	INIT space( 35 )
		DATA FUSL_OK	INIT 0
		DATA FVMP		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCodeM
		METHOD getMCode
		METHOD getCode
		METHOD getPlace
		METHOD getName
		METHOD getNameShort
		METHOD getUsl_Ok
		METHOD getVMP
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCodeM()		CLASS T_mo8dep
	return ::FCODEM

METHOD FUNCTION getMCode()		CLASS T_mo8dep
	return ::FMCODE

METHOD FUNCTION getCode()			CLASS T_mo8dep
	return ::FCODE

METHOD FUNCTION getPlace()		CLASS T_mo8dep
	return ::FPLACE

METHOD FUNCTION getName()			CLASS T_mo8dep
	return ::FNAME

METHOD FUNCTION getNameShort()	CLASS T_mo8dep
	return ::FNAME_SHORT

METHOD FUNCTION getUsl_Ok()		CLASS T_mo8dep
	return ::FUSL_OK

METHOD FUNCTION getVMP()			CLASS T_mo8dep
	return ::FVMP

METHOD FUNCTION getDateBegin()	CLASS T_mo8dep
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8dep
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8dep
			
	::super:new( nID, lNew, lDeleted )
	return self