#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TMo_hismo	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDHuman AS NUMERIC READ getIDHuman WRITE setIDHuman
		PROPERTY Name AS STRING READ getName WRITE setName
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDHuman INIT 0
		DATA FName INIT space( 100 )

		METHOD getIDHuman
		METHOD setIDHuman( param )
		METHOD getName
		METHOD setName( param )
ENDCLASS

METHOD function getIDHuman()		CLASS TMo_hismo
	return ::FIDHuman

METHOD procedure setIDHuman( param )		CLASS TMo_hismo
	
	if isnumber( param )
		::FIDHuman := param
	endif
	return

METHOD function getName()		CLASS TMo_hismo
	return ::FName

METHOD procedure setName( param )		CLASS TMo_hismo
	
	if ischaracter( param )
		::FName := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TMo_hismo

	::super:new( nID, lNew, lDeleted )
	return self
