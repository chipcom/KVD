#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TSRF
	VISIBLE:
		PROPERTY OKATO AS STRING READ getOKATO WRITE setOKATO
		PROPERTY Name AS STRING READ getName WRITE setName
	
		METHOD New( cOKATO, cName )
	HIDDEN:
		DATA FOKATO INIT space( 5 )
		DATA FName INIT space( 80 )

		METHOD getOKATO
		METHOD setOKATO( param )
		METHOD getName
		METHOD setName( param )
ENDCLASS

METHOD function getOKATO()		CLASS TSRF
	return ::FOKATO

METHOD procedure setOKATO( param )		CLASS TSRF
	
	if ischaracter( param )
		::FOKATO := param
	endif
	return

METHOD function getName()		CLASS TSRF
	return ::FName

METHOD procedure setName( param )		CLASS TSRF
	
	if ischaracter( param )
		::FName := param
	endif
	return

METHOD New( cOKATO, cName )		CLASS TSRF

	::FOKATO := cOKATO
	::FName := cName
	return self