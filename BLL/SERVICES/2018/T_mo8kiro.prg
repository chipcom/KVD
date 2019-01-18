#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8kiro.dbf'
CREATE CLASS T_mo8kiro	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code		READ getCode
		PROPERTY Name		READ getName
		PROPERTY Name_F		READ getName_F
		PROPERTY Coef		READ getCoef
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODE		INIT 0
		DATA FNAME		INIT space( 35 )
		DATA FNAME_F	INIT space( 255 )
		DATA FCOEF		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCode
		METHOD getName
		METHOD getName_F
		METHOD getCoef
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCode()		CLASS T_mo8kiro
	return ::FCODE

METHOD FUNCTION getName()		CLASS T_mo8kiro
	return ::FNAME

METHOD FUNCTION getName_F()			CLASS T_mo8kiro
	return ::FNAME_F

METHOD FUNCTION getCoef()		CLASS T_mo8kiro
	return ::FCOEF

METHOD FUNCTION getDateBegin()	CLASS T_mo8kiro
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8kiro
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8kiro

	::super:new( nID, lNew, lDeleted )
	return self