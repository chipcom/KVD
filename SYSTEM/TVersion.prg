#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'

#include 'function.ch'

// � ����������

********************************
// ����� ��� ࠡ��� � ���ᨥ� ��
CREATE CLASS TVersion
	VISIBLE:
		PROPERTY Major AS NUMERIC READ getMajor			// 
		PROPERTY Minor AS NUMERIC READ getMinor			// 
		PROPERTY SubMinor AS NUMERIC READ getSubMinor	// 
		PROPERTY Character AS STRING READ getCharacter	// 
		PROPERTY Date AS DATE READ getDate				// 
		PROPERTY AsString AS STRING READ getAsString		//
		
		METHOD New ()
		
		OPERATOR '==' ARG cArg INLINE ;
				( ( ::userFIO == cArg:FIO ) .and. ( ::cIDTask == cArg:IDTask ) .and. (::cUserName == cArg:NameUser ) ;
					.and. ( ::cEnterDate == cArg:EnterDate ) .and. ( ::cEnterTime == cArg:EnterTime ) )
	HIDDEN:                    
		DATA FMajor			INIT 2
		DATA FMinor			INIT 11
		DATA FSubMinor		INIT 12
		DATA FCharacter		INIT 'i'
		DATA FDate			INIT ctod( '22.12.2020' )
		
		METHOD getMajor
		METHOD getMinor
		METHOD getSubMinor
		METHOD getCharacter
		METHOD getDate
		METHOD getAsString
ENDCLASS

METHOD New()  CLASS TVersion

	if __mvExist( '_version' ) .and. isarray( _version )
		::FMajor		:= _version[ 1 ]
		::FMinor		:= _version[ 2 ]
		::FSubMinor		:= _version[ 3 ]
		::FCharacter	:= char_version
		::FDate			:= ctod( _date_version )
	endif
	return self

METHOD FUNCTION getMajor()	CLASS TVersion
	return ::FMajor

METHOD FUNCTION getMinor()	CLASS TVersion
	return ::FMinor

METHOD FUNCTION getSubMinor()	CLASS TVersion
	return ::FSubMinor

METHOD FUNCTION getCharacter()	CLASS TVersion
	return ::FCharacter

METHOD FUNCTION getDate()	CLASS TVersion
	return ::FDate

METHOD FUNCTION getAsString()	CLASS TVersion
	return lstr(::FMajor) + '.' + lstr(::FMinor) + '.' + lstr(::FSubMinor) + alltrim(::FCharacter)
