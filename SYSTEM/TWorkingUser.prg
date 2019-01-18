#include 'hbclass.ch'
#include 'property.ch'

********************************
// ����� ��� ࠡ����� ���짮��⥫�� � ��⥬�
CREATE CLASS TWorkingUser
	VISIBLE:
		PROPERTY ID AS NUMERIC READ identRead					// �����䨪��� ��⨢���� ���짮��⥫�
		PROPERTY FIO AS STRING READ userFIORead					// ��� ���짮��⥫� ��⨢��� �����
		PROPERTY IDTask AS STRING READ taskRead					// �����䨪��� ��⨢��� �����
		PROPERTY NameUser AS STRING READ nameUserRead			// ��� ���짮��⥫� �室� � ���
		PROPERTY EnterDate AS STRING READ enterDateRead			// ��� ����᪠ �����
		PROPERTY EnterTime AS STRING READ enterTimeRead			// �६� ����᪠ �����
		
		PROPERTY checked AS BOOLEAN READ getChecked WRITE setChecked			// �⬥⪠ �롮� ���짮��⥫�
		
		METHOD New ( cIDTask, cName, enterDate, enterTime, cUserName )
		METHOD toggleChecked()
		
		OPERATOR '==' ARG cArg INLINE ;
				( ( ::userFIO == cArg:FIO ) .and. ( ::cIDTask == cArg:IDTask ) .and. (::cUserName == cArg:NameUser ) ;
					.and. ( ::cEnterDate == cArg:EnterDate ) .and. ( ::cEnterTime == cArg:EnterTime ) )
	HIDDEN:                    
		CLASSVAR counter	INIT 0
		DATA ident			INIT 0
		DATA userFIO		INIT space( 20 )
		DATA cIDTask		INIT space( 15 )
		DATA cUserName		INIT space( 50 )
		DATA cEnterDate		INIT space( 10 )
		DATA cEnterTime		INIT space( 8 )
		DATA FChecked		INIT .f.
		
		METHOD identRead
		METHOD userFIORead
		METHOD taskRead
		METHOD nameUserRead
		METHOD enterDateRead
		METHOD enterTimeRead
		METHOD getChecked
		METHOD setChecked( lVal )
ENDCLASS

METHOD New( cIDTask, cName, enterDate, enterTime, cUserName )  CLASS TWorkingUser

	::ident		:=  ++::counter
	::userFIO	:= hb_defaultValue( cName, space( 20 ) )
	::cIDTask	:= hb_defaultValue( cIDTask, space( 15 ) )
	::cEnterDate := hb_defaultValue( enterDate, space( 10 ) )
	::cEnterTime := hb_defaultValue( enterTime, space( 8 ) )
	::cUserName	:= hb_defaultValue( cUserName, space( 50 ) )
	::FChecked	:= .f.
	return self

METHOD FUNCTION identRead()			CLASS TWorkingUser
	return ::ident
	
METHOD FUNCTION userFIORead()			CLASS TWorkingUser
	return ::userFIO

METHOD FUNCTION taskRead()				CLASS TWorkingUser
	return ::cIDTask

METHOD FUNCTION nameUserRead()			CLASS TWorkingUser
	return ::cUserName

METHOD FUNCTION enterDateRead()		CLASS TWorkingUser
	return ::cEnterDate

METHOD FUNCTION enterTimeRead()		CLASS TWorkingUser
	return ::cEnterTime
	
METHOD FUNCTION getChecked()			CLASS TWorkingUser
	return ::FChecked
	
METHOD PROCEDURE setChecked( lVal )	CLASS TWorkingUser
	::FChecked := lVal
	return
	
METHOD PROCEDURE toggleChecked()		CLASS TWorkingUser
	::FChecked := !( ::FChecked )
	return