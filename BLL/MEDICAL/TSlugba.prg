#include 'hbclass.ch'
#include 'hbhash.ch' 
#include 'property.ch'

// файл 'slugba.dbf'
CREATE CLASS TSlugba	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Shifr READ getShifr WRITE setShifr
		PROPERTY Name READ getName WRITE setName
		PROPERTY Name1251 READ getName1251
		
		METHOD New( nId, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FShifr		INIT 0
		DATA FName		INIT space( 40 )
		
		METHOD getShifr
		METHOD setShifr( nVal )
		METHOD getName
		METHOD getName1251
		METHOD setName( cVal )
ENDCLASS

METHOD FUNCTION getShifr()			CLASS TSlugba
	return ::FShifr
	
METHOD PROCEDURE setShifr( nVal )	CLASS TSlugba
	::FShifr := nVal
	return

METHOD FUNCTION getName()				CLASS TSlugba
	return ::FName

METHOD FUNCTION getName1251()			CLASS TSlugba
	return win_OEMToANSI( ::FName )

METHOD PROCEDURE setName( cVal )		CLASS TSlugba
	::FName := cVal
	return

METHOD Clone()						CLASS TSlugba
	local oTarget := nil
	
	oTarget := ::Super:Clone()
	oTarget:Shifr( 0 )
	return oTarget
		
METHOD New( nId, lNew, lDeleted )	CLASS TSlugba
			
	::super:new( nID, lNew, lDeleted )
	return self