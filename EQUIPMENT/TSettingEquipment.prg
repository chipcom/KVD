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
		PROPERTY ComPortBaudRate READ getComPortBaudRate WRITE setComPortBaudRate		// COM-BaudRate
		PROPERTY ComPortDataBits READ getComPortDataBits WRITE setComPortDataBits		// COM-DataBits
		PROPERTY ComPortParity READ getComPortParity WRITE setComPortParity		// COM-Parity
		PROPERTY SCReader READ getSCReader WRITE setSCReader					//
	HIDDEN:
		VAR _objINI
		DATA FTypeKKT			INIT 1
		DATA FComPortScanner	INIT space( 5 )
		DATA FComPortBaudRate	INIT 9600
		DATA FComPortDataBits	INIT 8
		DATA FComPortParity		INIT space( 6 )
		DATA FSCReader			INIT space( 50 )

		METHOD getTypeKKT
		METHOD setTypeKKT( param )
		METHOD getComPort
		METHOD setComPort( param )
		METHOD getComPortBaudRate
		METHOD setComPortBaudRate( param )
		METHOD getComPortDataBits
		METHOD setComPortDataBits( param )
		METHOD getComPortParity
		METHOD setComPortParity( param )
		
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

METHOD function getComPortBaudRate()				CLASS TSettingEquipment
	return ::FComPortBaudRate

METHOD procedure setComPortBaudRate( param )		CLASS TSettingEquipment

	if isnumber( param )
		::FComPortBaudRate := param
	endif
	return

METHOD function getComPortDataBits()				CLASS TSettingEquipment
	return ::FComPortDataBits

METHOD procedure setComPortDataBits( param )		CLASS TSettingEquipment

	if isnumber( param )
		::FComPortDataBits := param
	endif
	return

METHOD function getComPortParity()				CLASS TSettingEquipment
	return ::FComPortParity

METHOD procedure setComPortParity( param )		CLASS TSettingEquipment

	if ischaracter( param )
		::FComPortParity := alltrim( param )
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
	local cComPort, cSCReader, nComBaudRate, nComDataBits, cParity
		 
	INI oIni FILE file
		GET typeKKT				SECTION 'KKT' ENTRY 'Type'							OF oIni DEFAULT 1
		GET cComPort				SECTION 'Scanner Barcode' ENTRY 'COM port'	OF oIni DEFAULT 'Нет'
		GET nComBaudRate			SECTION 'Scanner Barcode' ENTRY 'BaudRate'	OF oIni DEFAULT 9600
		GET nComDataBits			SECTION 'Scanner Barcode' ENTRY 'DataBits'	OF oIni DEFAULT 8
		GET cParity				SECTION 'Scanner Barcode' ENTRY 'Parity'	OF oIni DEFAULT 'Нет'
		GET cSCReader			SECTION 'Smart Card Reader' ENTRY 'Type'	OF oIni DEFAULT 'Нет'
	ENDINI
	::_objINI := oIni
	::FTypeKKT := typeKKT
	::FComPortScanner := alltrim( cComPort )
	::FComPortBaudRate := nComBaudRate
	::FComPortDataBits := nComDataBits
	::FComPortParity := cParity
	::FSCReader := padr( cSCReader, 50 )
	return self
	
METHOD Save() CLASS TSettingEquipment
		 
	SET SECTION 'KKT' ENTRY 'Type'						TO ::FTypeKKT			OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'COM port'		TO ::FComPortScanner	OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'BaudRate'		TO ::FComPortBaudRate	OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'DataBits'		TO ::FComPortDataBits	OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'Parity'			TO ::FComPortParity		OF ::_objINI
	SET SECTION 'Smart Card Reader' ENTRY 'Type'			TO ::FSCReader			OF ::_objINI
	return nil
