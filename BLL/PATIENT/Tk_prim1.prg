#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS Tk_prim1	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient
		PROPERTY Stroke AS NUMERIC READ getStroke WRITE setStroke
		PROPERTY Name AS STRING READ getName WRITE setName
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDPatient INIT 0
		DATA FStroke INIT 0
		DATA FName INIT space( 60 )

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getStroke
		METHOD setStroke( param )
		METHOD getName
		METHOD setName( param )
ENDCLASS

METHOD function getIDPatient()		CLASS Tk_prim1
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS Tk_prim1
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getStroke()		CLASS Tk_prim1
	return ::FStroke

METHOD procedure setStroke( param )		CLASS Tk_prim1
	
	if isnumber( param )
		::FStroke := param
	endif
	return

METHOD function getName()		CLASS Tk_prim1
	return ::FName

METHOD procedure setName( param )		CLASS Tk_prim1
	
	if ischaracter( param )
		::FName := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS Tk_prim1

	::super:new( nID, lNew, lDeleted )
	return self
