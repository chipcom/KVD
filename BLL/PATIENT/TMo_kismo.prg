#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TMo_kismo	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient
		PROPERTY Name AS STRING READ getName WRITE setName
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDPatient INIT 0
		DATA FName INIT space( 100 )

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getName
		METHOD setName( param )
ENDCLASS

METHOD function getIDPatient()		CLASS TMo_kismo
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TMo_kismo
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getName()		CLASS TMo_kismo
	return ::FName

METHOD procedure setName( param )		CLASS TMo_kismo
	
	if ischaracter( param )
		::FName := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TMo_kismo

	::super:new( nID, lNew, lDeleted )
	return self
