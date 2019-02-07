#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

// класс двойных фамилий пациента
CREATE CLASS TDubleFIO	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient
		PROPERTY LastName AS STRING INDEX 1 READ getName WRITE setName
		PROPERTY FirstName AS STRING INDEX 2 READ getName WRITE setName
		PROPERTY MiddleName AS STRING INDEX 3 READ getName WRITE setName
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDPatient INIT 0
		DATA FLastName INIT space( 40 )
		DATA FFirstName INIT space( 40 )
		DATA FMiddleName INIT space( 40 )

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getName( index )
		METHOD setName( index, param )
ENDCLASS

METHOD function getIDPatient()		CLASS TDubleFIO
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TDubleFIO
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getName( index )		CLASS TDubleFIO
	local ret
	
	switch index
		case 1
			ret := ::FLastName
			exit
		case 2
			ret := ::FFirstName
			exit
		case 3
			ret := ::FMiddleName
			exit
	endswitch
	return ret

METHOD procedure setName( index, param )		CLASS TDubleFIO
	
	if ischaracter( param )
		switch index
			case 1
				::FLastName := param
				exit
			case 2
				::FFirstName := param
				exit
			case 3
				::FMiddleName := param
				exit
		endswitch
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TDubleFIO

	::super:new( nID, lNew, lDeleted )
	return self
