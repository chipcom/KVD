#include 'hbclass.ch'
#include 'property.ch'
#include 'ini.ch'

CREATE CLASS TSettingSystem
	VISIBLE:
		PROPERTY PortUDP READ getPortUDP WRITE setPortUDP
		PROPERTY TimeDelay READ getTimeDelay WRITE setTimeDelay
		PROPERTY EMail READ getEmail WRITE setEmail
		PROPERTY Login READ getLogin WRITE setLogin
		PROPERTY EMailPassword READ getEmailPassword WRITE setEmailPassword
		PROPERTY ServerSMTP READ getServerSMTP WRITE setServerSMTP
		PROPERTY ServerPOP3 READ getServerPOP3 WRITE setServerPOP3
		PROPERTY SSL READ getSSL WRITE setSSSL
		
		METHOD New( file )
		METHOD Save( )
	HIDDEN:
		VAR _objINI
		VAR key
		DATA FPortUDP		INIT 0
		DATA FTimeDelay		INIT 0
		DATA FEmail			INIT space( 20 )
		DATA FLogin			INIT space( 20 )
		DATA FEmailPassword	INIT space( 20 )
		DATA FServerSMTP	INIT space( 20 )
		DATA FServerPOP3	INIT space( 20 )
		DATA FSSL			INIT .f.
		
		METHOD getPortUDP()
		METHOD setPortUDP( nPort )
		METHOD getTimeDelay()
		METHOD setTimeDelay( nTime )
		METHOD getEmail()
		METHOD setEmail( cEmail )
		METHOD getLogin()
		METHOD setLogin( cLogin )
		METHOD getEmailPassword()
		METHOD setEmailPassword( cPassword )
		METHOD getServerSMTP()
		METHOD setServerSMTP( cServer )
		METHOD getServerPOP3()
		METHOD setServerPOP3( cServer )
		METHOD getSSL()
		METHOD setSSSL( lSSL )

END CLASS
	
METHOD New( file ) CLASS TSettingSystem
	local cCrypt
	
	::key := TUserDB():New():cryptoKey()
	INI oIni FILE file
		GET ::FPortUDP		SECTION 'MESSAGE' ENTRY 'Port'			OF oIni DEFAULT 39999
		GET ::FTimeDelay		SECTION 'MESSAGE' ENTRY 'Time delay'	OF oIni DEFAULT 2
		GET ::FEmail			SECTION 'EMAIL' ENTRY 'MailBox'			OF oIni DEFAULT ''
		GET ::FLogin			SECTION 'EMAIL' ENTRY 'Login'			OF oIni DEFAULT ''
		GET ::FServerSMTP	SECTION 'EMAIL' ENTRY 'Server SMTP'		OF oIni DEFAULT ''
		GET ::FServerPOP3	SECTION 'EMAIL' ENTRY 'Server POP3'		OF oIni DEFAULT ''
		GET cCrypt			SECTION 'EMAIL' ENTRY 'Password Email'	OF oIni DEFAULT ''
		GET ::FSSL			SECTION 'EMAIL' ENTRY 'Use SSL'			OF oIni DEFAULT .f.
	ENDINI
	::_objINI := oIni
	::FEmailPassword := alltrim( crypt( cCrypt, ::key ) )
	return self

METHOD Save() CLASS TSettingSystem
		 
	SET SECTION 'MESSAGE'	ENTRY 'Port'			TO ::FPortUDP		OF ::_objINI
	SET SECTION 'MESSAGE'	ENTRY 'Time delay'		TO ::FTimeDelay		OF ::_objINI
	SET SECTION 'EMAIL'		ENTRY 'MailBox'			TO ::FEmail			OF ::_objINI
	SET SECTION 'EMAIL'		ENTRY 'Login'			TO ::FLogin			OF ::_objINI
	SET SECTION 'EMAIL'		ENTRY 'Server SMTP'		TO ::FServerSMTP		OF ::_objINI
	SET SECTION 'EMAIL'		ENTRY 'Server POP3'		TO ::FServerPOP3		OF ::_objINI
	SET SECTION 'EMAIL'		ENTRY 'Password Email'	TO crypt( ::FEmailPassword, ::key )	OF ::_objINI
	SET SECTION 'EMAIL'		ENTRY 'Use SSL'			TO ::FSSL			OF ::_objINI
	return nil

METHOD function getPortUDP()
	return ::FPortUDP

METHOD procedure setPortUDP( nPort )
	::FPortUDP := nPort
	return
	
METHOD function getTimeDelay()
	return ::FTimeDelay

METHOD procedure setTimeDelay( nTime )

	if nTime < 0
		nTime := nTime * ( -1 )
	elseif nTime == 0
		nTime := 2
	endif
	::FTimeDelay := nTime
	return

METHOD function getEmail()
	return ::FEmail

METHOD procedure setEmail( cEmail )
	::FEmail := alltrim( cEmail )
	return

METHOD function getLogin()
	return ::FLogin

METHOD procedure setLogin( cLogin )
	::FLogin := alltrim( cLogin )
	return

METHOD function getEmailPassword()
	return ::FEmailPassword

METHOD procedure setEmailPassword( cPassword )
	::FEmailPassword := alltrim( cPassword )
	return

METHOD function getServerSMTP()
	return ::FServerSMTP

METHOD procedure setServerSMTP( cServer )
	::FServerSMTP := alltrim( cServer )
	return

METHOD function getServerPOP3()
	return ::FServerPOP3

METHOD procedure setServerPOP3( cServer )
	::FServerPOP3 := alltrim( cServer )
	return

METHOD function getSSL()
	return ::FSSL

METHOD procedure setSSSL( lSSL )
	::FSSL := lSSL
	return
