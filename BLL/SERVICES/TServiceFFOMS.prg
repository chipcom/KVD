#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник услуг ФФОМС _mo_uslf.dbf
CREATE CLASS TServiceFFOMS	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Name READ getName WRITE setName							// название
		PROPERTY Name1251 READ getName1251
		PROPERTY Shifr READ getShifr WRITE setShifr						// шифр услуги федеральный
		PROPERTY Shifr1251 READ getShifr1251
		PROPERTY DateBegin READ getDateBegin WRITE setDateBegin
		PROPERTY DateEnd READ getDateEnd WRITE setDateEnd
	
		METHOD New( nID, lNew, lDeleted )
	PROTECTED:
		DATA FName					INIT space( 255 )
		DATA FShifr					INIT space( 20 )
		DATA FDBegin				INIT ctod( '' )
		DATA FDEnd					INIT ctod( '' )
	
		METHOD getName
		METHOD getName1251
		METHOD setName( cVal )
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cVal )
		METHOD getDateBegin
		METHOD setDateBegin( dVal )
		METHOD getDateEnd
		METHOD setDateEnd( dVal )
ENDCLASS

METHOD FUNCTION getName()				CLASS TServiceFFOMS
	return ::FName

METHOD FUNCTION getName1251()			CLASS TServiceFFOMS
	return win_OEMToANSI( ::FName )

METHOD PROCEDURE setName( cVal )		CLASS TServiceFFOMS
	::FName := cVal
	return

METHOD FUNCTION getShifr()				CLASS TServiceFFOMS
	return ::FShifr

METHOD FUNCTION getShifr1251()			CLASS TServiceFFOMS
	return win_OEMToANSI( ::FShifr )

METHOD PROCEDURE setShifr( cVal )	CLASS TServiceFFOMS
	::FShifr := cVal
	return

METHOD FUNCTION getDateBegin()				CLASS TServiceFFOMS
	return ::FDBegin

METHOD PROCEDURE setDateBegin( dVal )	CLASS TServiceFFOMS
	::FDBegin := dVal
	return

METHOD FUNCTION getDateEnd()				CLASS TServiceFFOMS
	return ::FDEnd

METHOD PROCEDURE setDateEnd( dVal )	CLASS TServiceFFOMS
	::FDEnd := dVal
	return

METHOD FUNCTION New( nID, lNew, lDeleted ) CLASS TServiceFFOMS

	::super:new( nID, lNew, lDeleted )
	return self