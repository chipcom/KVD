#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS T_okator	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY OKATO AS STRING READ getOKATO WRITE setOKATO
		PROPERTY Name AS STRING READ getName WRITE setName
		PROPERTY OKATO_Name AS STRING READ getOKATO_Name
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FOKATO INIT space( 2 )
		DATA FName INIT space( 72 )

		METHOD getOKATO
		METHOD setOKATO( param )
		METHOD getName
		METHOD setName( param )
		METHOD getOKATO_Name
ENDCLASS

METHOD function getOKATO_Name()		CLASS T_okator
	return ::FOKATO + ' ' + ::FName

METHOD function getOKATO()		CLASS T_okator
	return ::FOKATO

METHOD procedure setOKATO( param )		CLASS T_okator
	
	if ischaracter( param )
		::FOKATO := param
	endif
	return

METHOD function getName()		CLASS T_okator
	return ::FName

METHOD procedure setName( param )		CLASS T_okator
	
	if ischaracter( param )
		::FName := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS T_okator

	::super:new( nID, lNew, lDeleted )
	return self
