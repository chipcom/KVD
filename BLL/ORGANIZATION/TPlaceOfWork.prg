#include "hbclass.ch"
#include "hbhash.ch" 
#include 'property.ch'

//////////////////////////////////////////////////

// файл "s_mr.dbf" мест работы
CREATE CLASS TPlaceOfWork		INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName				// Наименование места работы
	
		METHOD New( nId, cName, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FName INIT space( 50 )
		
		METHOD getName()
		METHOD setName( param )
ENDCLASS

METHOD FUNCTION getName()					CLASS TPlaceOfWork
	return ::FName

METHOD PROCEDURE setName( param )		CLASS TPlaceOfWork

	::FName := upper( param )
	return

METHOD Clone()		 CLASS TPlaceOfWork
	local oTarget := nil
	
	oTarget := ::Super:Clone()
	return oTarget

METHOD New( nId, cName, lNew, lDeleted ) CLASS TPlaceOfWork
			  
	HB_Default( @nID, 0 ) 
	HB_Default( @cName, Space( 70 ) ) 
	HB_Default( @lDeleted, .F. ) 
	HB_Default( @lNew, .T. ) 
	::FID		:= nID
	::FName		:= cName
			  
	::FNew 		:= lNew
	::FDeleted	:= lDeleted
	return self