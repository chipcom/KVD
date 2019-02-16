#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл "s_kemvyd.dbf" органов МВД выдавших документы
CREATE CLASS TPublisher		INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName				// Наименование организации выдавшей документ
	
		METHOD New( nId, cName, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FName INIT space( 150 )
		METHOD getName				INLINE ::FName
		METHOD setName( param )
ENDCLASS

METHOD PROCEDURE setName( param )		CLASS TPublisher

	::FName := upper( param )
	return

METHOD Clone()		 					CLASS TPublisher
	local oTarget := nil
	
	oTarget := ::Super:Clone()
	return oTarget

METHOD New( nId, cName, lNew, lDeleted ) CLASS TPublisher
			  
	HB_Default( @nID, 0 ) 
	HB_Default( @cName, space( 150 ) ) 
	HB_Default( @lDeleted, .F. ) 
	HB_Default( @lNew, .T. ) 
	::FID			:= nID
	::FName			:= cName
			  
	::FNew 			:= lNew
	::FDeleted		:= lDeleted
	return self