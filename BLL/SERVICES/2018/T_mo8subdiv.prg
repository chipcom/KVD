#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8subdiv.dbf'
CREATE CLASS T_mo8subdiv	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeM		READ getCodeM
		PROPERTY MCode		READ getMCode
		PROPERTY Code		READ getCode
		PROPERTY Name		READ getName
		PROPERTY Name1251	READ getName1251
		PROPERTY Flag		READ getFlag
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd

		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODEM		INIT space( 6 )
		DATA FMCODE		INIT space( 6 )
		DATA FCODE		INIT 0
		DATA FNAME		INIT space( 60 )
		DATA FFLAG		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCodeM
		METHOD getMCode
		METHOD getCode
		METHOD getName
		METHOD getName1251
		METHOD getFlag
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCodeM()		CLASS T_mo8subdiv
	return ::FCODEM

METHOD FUNCTION getMCode()		CLASS T_mo8subdiv
	return ::FMCODE

METHOD FUNCTION getCode()			CLASS T_mo8subdiv
	return ::FCODE

METHOD FUNCTION getName()			CLASS T_mo8subdiv
	return ::FNAME

METHOD FUNCTION getName1251()		CLASS T_mo8subdiv
	return win_OEMToANSI( ::FNAME )

METHOD FUNCTION getFlag()		CLASS T_mo8subdiv
	return ::FFLAG

METHOD FUNCTION getDateBegin()	CLASS T_mo8subdiv
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8subdiv
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8subdiv
			
	::super:new( nID, lNew, lDeleted )
	return self