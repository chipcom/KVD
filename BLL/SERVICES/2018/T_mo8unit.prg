#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8unit.dbf'
CREATE CLASS T_mo8unit	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code		READ getCode
		PROPERTY Pz			READ getPz
		PROPERTY II			READ getII
		PROPERTY C_T		READ getC_T
		PROPERTY Name		READ getName
		PROPERTY Name1251	READ getName1251
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd

		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FCODE	INIT 0
		DATA FPZ	INIT 0
		DATA FII	INIT 0
		DATA FC_T	INIT 0
		DATA FNAME	INIT space( 60 )
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getCode
		METHOD getPz
		METHOD getII
		METHOD getC_T
		METHOD getName
		METHOD getName1251
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getCode()		CLASS T_mo8unit
	return ::FCODE

METHOD FUNCTION getPz()		CLASS T_mo8unit
	return ::FPZ

METHOD FUNCTION getName()		CLASS T_mo8unit
	return ::FNAME

METHOD FUNCTION getName1251()	CLASS T_mo8unit
	return win_OEMToANSI( ::FNAME )

METHOD FUNCTION getII()		CLASS T_mo8unit
	return ::FII

METHOD FUNCTION getC_T()		CLASS T_mo8unit
	return ::FC_T

METHOD FUNCTION getDateBegin()	CLASS T_mo8unit
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8unit
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8unit
			
	::super:new( nID, lNew, lDeleted )
	return self