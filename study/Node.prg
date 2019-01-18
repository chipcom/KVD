#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS Node
	VISIBLE:
		PROPERTY Value AS NUMERIC READ getValue WRITE setValue
		PROPERTY Next AS OBJECT READ getNext WRITE setNext
	
		METHOD New( param )
		
	HIDDEN:
		DATA FValue INIT 0
		DATA FNext INIT nil

		METHOD getValue
		METHOD setValue( param )
		METHOD getNext
		METHOD setNext( param )
ENDCLASS

METHOD function getValue()		CLASS Node
	return ::FValue

METHOD procedure setValue( param )		CLASS Node
	
	if isnumber( param )
		::FValue := param
	endif
	return

METHOD function getNext()		CLASS Node
	return ::FNext

METHOD procedure setNext( param )		CLASS Node
	
	if isobject( param ) .and. param:classname == 'NODE'
		::FNext := param
	endif
	return

METHOD New( param )		CLASS Node

	if ! isnil( param )
		if isnumber( param )
			::FValue := param
		endif
	endif
	return self