#include 'hbclass.ch'
#include 'ini.ch'
#include 'property.ch'
#include 'common.ch'

CREATE CLASS TSettingEquipment

	VISIBLE:
		METHOD New( file )
		METHOD Save()
		
		PROPERTY TypeKKT READ getTypeKKT WRITE setTypeKKT					// тип ККМ
		PROPERTY ComPort READ getComPort WRITE setComPort					// COM-
		PROPERTY SCReader READ getSCReader WRITE setSCReader					//
	HIDDEN:
		VAR _objINI
		DATA FTypeKKT			INIT 1
		DATA FComPortScanner	INIT space( 5 )
		DATA FSCReader			INIT space( 50 )

		METHOD getTypeKKT
		METHOD setTypeKKT( param )
		METHOD getComPort
		METHOD setComPort( param )
		METHOD getSCReader
		METHOD setSCReader( param )
END CLASS

METHOD function getTypeKKT()				 CLASS TSettingEquipment
	return ::FTypeKKT

METHOD procedure setTypeKKT( param )		 CLASS TSettingEquipment

	if isnumber( param )
		::FTypeKKT := param
	endif
	return

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
	local typeKKT
	local cComPort, cSCReader
		 
	INI oIni FILE file
		GET typeKKT				SECTION 'KKT' ENTRY 'Type'							OF oIni DEFAULT 1
		GET cComPort				SECTION 'Scanner Barcode' ENTRY 'COM port'	OF oIni DEFAULT 'Нет'
		GET cSCReader			SECTION 'Smart Card Reader' ENTRY 'Type'	OF oIni DEFAULT 'Нет'
	ENDINI
	::_objINI := oIni
	::FTypeKKT := typeKKT
	::FComPortScanner := alltrim( cComPort )
	::FSCReader := padr( cSCReader, 50 )
	return self
	
METHOD Save() CLASS TSettingEquipment
		 
	SET SECTION 'KKT' ENTRY 'Type'						TO ::FTypeKKT			OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'COM port'		TO ::FComPortScanner	OF ::_objINI
	SET SECTION 'Smart Card Reader' ENTRY 'Type'			TO ::FSCReader			OF ::_objINI
	return nil
