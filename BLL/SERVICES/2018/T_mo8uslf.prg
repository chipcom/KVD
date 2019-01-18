#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8uslf.dbf'
CREATE CLASS T_mo8uslf	INHERIT	TBaseObjectBLL
	VISIBLE:
		
		PROPERTY Shifr		READ getShifr
		PROPERTY Shifr1251	READ getShifr1251
		PROPERTY Name		READ getName
		PROPERTY Name1251	READ getName1251
		PROPERTY Tip		READ getTip
		PROPERTY Grp		READ getGrp
		PROPERTY ONKO_NAPR	READ getONKO_NAPR
		PROPERTY ONKO_KSG	READ getONKO_KSG
		PROPERTY UETV		READ getUETV
		PROPERTY UETD		READ getUETD
		PROPERTY DATEBEG	READ getDateBegin
		PROPERTY DATEEND	READ getDateEnd
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FSHIFR		INIT space( 20 )
		DATA FNAME		INIT space( 255 )
		DATA FTIP		INIT 0
		DATA FGRP		INIT 0
		DATA FONKO_NAPR	INIT 0
		DATA FONKO_KSG	INIT 0
		DATA FUETV		INIT 0
		DATA FUETD		INIT 0
		DATA FDATEBEG	INIT ctod( '' )
		DATA FDATEEND	INIT ctod( '' )

		METHOD getShifr
		METHOD getShifr1251
		METHOD getName
		METHOD getName1251
		METHOD getTip
		METHOD getGrp
		METHOD getONKO_NAPR
		METHOD getONKO_KSG
		METHOD getUETV
		METHOD getUETD
		METHOD getDateBegin
		METHOD getDateEnd
ENDCLASS

METHOD FUNCTION getShifr()		CLASS T_mo8uslf
	return ::FSHIFR

METHOD FUNCTION getShifr1251()	CLASS T_mo8uslf
	return win_OEMToANSI( ::FSHIFR )

METHOD FUNCTION getName()			CLASS T_mo8uslf
	return ::FNAME

METHOD FUNCTION getName1251()		CLASS T_mo8uslf
	return win_OEMToANSI( ::FNAME )

METHOD FUNCTION getTip()		CLASS T_mo8uslf
	return ::FTIP

METHOD FUNCTION getGrp()		CLASS T_mo8uslf
	return ::FGRP

METHOD FUNCTION getONKO_NAPR()		CLASS T_mo8uslf
	return ::FONKO_NAPR

METHOD FUNCTION getONKO_KSG()	CLASS T_mo8uslf
	return ::FONKO_KSG

METHOD FUNCTION getUETV()			CLASS T_mo8uslf
	return ::FUETV

METHOD FUNCTION getUETD()			CLASS T_mo8uslf
	return ::FUETD

METHOD FUNCTION getDateBegin()	CLASS T_mo8uslf
	return ::FDATEBEG

METHOD FUNCTION getDateEnd()		CLASS T_mo8uslf
	return ::FDATEEND

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8uslf
			
	::super:new( nID, lNew, lDeleted )
	return self