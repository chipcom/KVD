#include 'hbclass.ch'
#include 'ini.ch'
#include 'property.ch'
#include 'common.ch'

CREATE CLASS TSettingEquipment

	VISIBLE:
		METHOD New( file )
		METHOD Save()
		
		PROPERTY ComPort READ getComPort WRITE setComPort
		PROPERTY SCReader READ getSCReader WRITE setSCReader
	HIDDEN:
		VAR _objINI
		DATA FComPortScanner	INIT space( 5 )
		DATA FSCReader			INIT space( 50 )

		METHOD getComPort
		METHOD setComPort( param )
		METHOD getSCReader
		METHOD setSCReader( param )
END CLASS

METHOD function getComPort()				CLASS TSettingEquipment
	return ::FComPortScanner

METHOD procedure setComPort( param )		CLASS TSettingEquipment

	if ischaracter( param )
		::FComPortScanner := alltrim( param )
	endif
	return

METHOD function getSCReader()				CLASS TSettingEquipment
	return ::FSCReader

METHOD procedure setSCReader( param )	CLASS TSettingEquipment

	if ischaracter( param )
		::FSCReader := alltrim( param )
	endif
	return

METHOD New( file ) CLASS TSettingEquipment
	local cComPort, cSCReader
		 
	INI oIni FILE file
		GET cComPort				SECTION 'Scanner Barcode' ENTRY 'COM port'	OF oIni DEFAULT 'Нет'
		GET cSCReader			SECTION 'Smart Card Reader' ENTRY 'Type'	OF oIni DEFAULT 'Нет'
	ENDINI
	::_objINI := oIni
	::FComPortScanner := cComPort
	::FSCReader := cSCReader
	return self
	
METHOD Save() CLASS TSettingEquipment
		 
	SET SECTION 'Scanner Barcode' ENTRY 'COM port'		TO ::FComPortScanner	OF ::_objINI
	SET SECTION 'Smart Card Reader' ENTRY 'Type'			TO ::FSCReader			OF ::_objINI
	return nil
