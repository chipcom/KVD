#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

********************************
// класс для описания кодов страны
CREATE CLASS TCountry
	VISIBLE:
		PROPERTY CodeN READ getCodeN							// цифровой код страны
		PROPERTY CodeChar READ getCodeChar					// символьный код страны
		PROPERTY Name READ getName							// наименование
  
		METHOD New( codeN, codeChar, name )
	HIDDEN:                                      
		DATA FCodeN		INIT space( 3 )
		DATA FCodeChar	INIT space( 3 )
		DATA FName		INIT space( 60 )
		
		METHOD getCodeN
		METHOD getCodeChar
		METHOD getName
ENDCLASS

METHOD FUNCTION getCodeN()				CLASS TCountry
	return ::FCodeN

METHOD FUNCTION getCodeChar()				CLASS TCountry
	return ::FCodeChar

METHOD FUNCTION getName()					CLASS TCountry
	return ::FName

METHOD New( codeN, codeChar, name )		CLASS TCountry

	::FCodeN := codeN
	::FCodeChar := codeChar
	::FName := name
	return self