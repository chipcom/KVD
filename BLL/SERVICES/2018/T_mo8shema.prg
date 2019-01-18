#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8shema.dbf'
CREATE CLASS T_mo8shema	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Kod		READ getKod
		PROPERTY Name		READ getName
		PROPERTY Name1251	READ getName1251
		PROPERTY DNI		READ getDNI
		PROPERTY KSG		READ getKSG
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FKOD		INIT space( 10 )
		DATA FNAME		INIT space( 75 )
		DATA FDNI		INIT 0
		DATA FKSG		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getKod
		METHOD getName
		METHOD getName1251
		METHOD getDNI
		METHOD getKSG
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getKod()		CLASS T_mo8shema
	return ::FKOD

METHOD FUNCTION getName()			CLASS T_mo8shema
	return ::FNAME

METHOD FUNCTION getName1251()		CLASS T_mo8shema
	return win_OEMToANSI( ::FNAME )

METHOD FUNCTION getDNI()		CLASS T_mo8shema
	return ::FDNI

METHOD FUNCTION getKSG()			CLASS T_mo8shema
	return ::FKSG

METHOD FUNCTION getDateBegin()	CLASS T_mo8shema
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8shema
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8shema
			
	::super:new( nID, lNew, lDeleted )
	return self