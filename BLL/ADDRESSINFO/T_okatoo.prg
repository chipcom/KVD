#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS T_okatoo	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY OKATO AS STRING READ getOKATO WRITE setOKATO
		PROPERTY Name AS STRING READ getName WRITE setName
		PROPERTY Vybor AS NUMERIC READ getVybor WRITE setVybor
		PROPERTY Zagol AS NUMERIC READ getZagol WRITE setZagol
		PROPERTY Tip AS NUMERIC READ getTip WRITE setTip
		PROPERTY Selo AS NUMERIC READ getSelo WRITE setSelo

		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FOKATO INIT space( 5 )
		DATA FName INIT space( 72 )
		DATA FVybor INIT 0
		DATA FZagol INIT 0
		DATA FTip INIT 0
		DATA FSelo INIT 0

		METHOD getOKATO
		METHOD setOKATO( param )
		METHOD getName
		METHOD setName( param )
		METHOD getVybor
		METHOD setVybor( param )
		METHOD getZagol
		METHOD setZagol( param )
		METHOD getTip
		METHOD setTip( param )
		METHOD getSelo
		METHOD setSelo( param )
ENDCLASS

METHOD function getSelo()		CLASS T_okatoo
	return ::FSelo

METHOD procedure setSelo( param )		CLASS T_okatoo
	
	if isnumber( param )
		::FSelo := param
	endif
	return

METHOD function getTip()		CLASS T_okatoo
	return ::FTip

METHOD procedure setTip( param )		CLASS T_okatoo
	
	if isnumber( param )
		::FTip := param
	endif
	return

METHOD function getZagol()		CLASS T_okatoo
	return ::FZagol

METHOD procedure setZagol( param )		CLASS T_okatoo
	
	if isnumber( param )
		::FZagol := param
	endif
	return

METHOD function getVybor()		CLASS T_okatoo
	return ::FVybor

METHOD procedure setVybor( param )		CLASS T_okatoo
	
	if isnumber( param )
		::FVybor := param
	endif
	return

METHOD function getOKATO()		CLASS T_okatoo
	return ::FOKATO

METHOD procedure setOKATO( param )		CLASS T_okatoo
	
	if ischaracter( param )
		::FOKATO := param
	endif
	return

METHOD function getName()		CLASS T_okatoo
	return ::FName

METHOD procedure setName( param )		CLASS T_okatoo
	
	if ischaracter( param )
		::FName := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS T_okatoo

	::super:new( nID, lNew, lDeleted )
	return self
