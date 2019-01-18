#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник услуг ФФОМС 2017 _mo7uslf.dbf
CREATE CLASS TServiceFFOMS7	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Shifr AS CHARACTER READ getShifr WRITE setShifr
		PROPERTY Name AS CHARACTER READ getName WRITE setName
		PROPERTY Type AS NUMERIC READ getType WRITE setType
		PROPERTY Group AS NUMERIC READ getGroup WRITE setGroup
		PROPERTY UETAdult AS NUMERIC READ getUETAdult WRITE setUETAdult
		PROPERTY UETChild AS NUMERIC READ getUETChild WRITE setUETChild
		PROPERTY DateBegin AS DATE READ getDateBegin WRITE setDateBegin
		PROPERTY DateEnd AS DATE READ getDateEnd WRITE setDateEnd
		
		METHOD New( nID, cShifr, cName, nTip, nGrp, nUETV, nUETD, dBegin, dEnd, lNew, lDeleted )
	HIDDEN:
		DATA FShifr		INIT space( 20 )
		DATA FName		INIT space( 255 )
		DATA FType		INIT 0
		DATA FGroup		INIT 0
		DATA FUETAdult	INIT 0
		DATA FUETChild	INIT 0
		DATA FDateBegin	INIT ctod( '' )
		DATA FDateEnd	INIT ctod( '' )
		
		METHOD getShifr
		METHOD setShifr( param )
		METHOD getName
		METHOD setName( param )
		METHOD getType
		METHOD setType( param )
		METHOD getGroup
		METHOD setGroup( param )
		METHOD getUETAdult
		METHOD setUETAdult( param )
		METHOD getUETChild
		METHOD setUETChild( param )
		METHOD getDateBegin
		METHOD setDateBegin( param )
		METHOD getDateEnd
		METHOD setDateEnd( param )
ENDCLASS

METHOD function getShifr() CLASS TServiceFFOMS7
	return ::FShifr

METHOD procedure setShifr( param ) CLASS TServiceFFOMS7

	::FShifr := param
	return

METHOD function getName() CLASS TServiceFFOMS7
	return ::FName

METHOD procedure setName( param ) CLASS TServiceFFOMS7

	::FName := param
	return

METHOD function getType() CLASS TServiceFFOMS7
	return ::FType

METHOD procedure setType( param ) CLASS TServiceFFOMS7

	::FType := param
	return

METHOD function getGroup() CLASS TServiceFFOMS7
	return ::FGroup

METHOD procedure setGroup( param ) CLASS TServiceFFOMS7

	::FGroup := param
	return

METHOD function getUETAdult() CLASS TServiceFFOMS7
	return ::FUETAdult

METHOD procedure setUETAdult( param ) CLASS TServiceFFOMS7

	::FUETAdult := param
	return

METHOD function getUETChild() CLASS TServiceFFOMS7
	return ::FUETChild

METHOD procedure setUETChild( param ) CLASS TServiceFFOMS7

	::FUETChild := param
	return

METHOD function getDateBegin() CLASS TServiceFFOMS7
	return ::FDateBegin

METHOD procedure setDateBegin( param ) CLASS TServiceFFOMS7

	::FDateBegin := param
	return

METHOD function getDateEnd() CLASS TServiceFFOMS7
	return ::FDateEnd

METHOD procedure setDateEnd( param ) CLASS TServiceFFOMS7

	::FDateEnd := param
	return

METHOD New( nID, lNew, lDeleted ) CLASS TServiceFFOMS7

	::super:new( nID, lNew, lDeleted )
	return self
