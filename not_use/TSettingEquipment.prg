#include 'hbclass.ch'
#include 'ini.ch'
#include 'property.ch'
#include 'common.ch'

CREATE CLASS TSettingEquipment

	VISIBLE:
		METHOD New( file )
		METHOD Save()
		
		// Для ККТ
		PROPERTY TypeKKT READ getTypeKKT WRITE setTypeKKT					// тип ККМ
		// Для сканера штрих-кода
		PROPERTY ScannerPort READ getScannerPort WRITE setScannerPort					// COM-сканера
		PROPERTY ScannerBaudRate READ getScannerBaudRate WRITE setScannerBaudRate		// COM-BaudRate
		PROPERTY ScannerDataBits READ getScannerDataBits WRITE setScannerDataBits		// COM-DataBits
		PROPERTY ScannerParity READ getScannerParity WRITE setScannerParity		// COM-Parity
		PROPERTY ScannerStopBits READ getScannerStopBits WRITE setScannerStopBits		// COM-StopBits
		PROPERTY ScannerXonXoffFlow READ getScannerXonXoffFlow WRITE setScannerXonXoffFlow		// COM-XonXoffFlow
		// Для ридера смарт-карт
		PROPERTY SCReader READ getSCReader WRITE setSCReader					//
	HIDDEN:
		VAR _objINI
		DATA FTypeKKT			INIT 1
		DATA FScannerPort		INIT space( 5 )
		DATA FScannerBaudRate	INIT 9600
		DATA FScannerDataBits	INIT 8
		DATA FScannerParity		INIT space( 6 )
		DATA FScannerStopBits	INIT 1
		DATA FScannerXonXoffFlow INIT space( 10 )
		DATA FSCReader			INIT space( 50 )

		METHOD getTypeKKT
		METHOD setTypeKKT( param )
		METHOD getScannerPort
		METHOD setScannerPort( param )
		METHOD getScannerBaudRate
		METHOD setScannerBaudRate( param )
		METHOD getScannerDataBits
		METHOD setScannerDataBits( param )
		METHOD getScannerParity
		METHOD setScannerParity( param )
		METHOD getScannerStopBits
		METHOD setScannerStopBits( param )
		METHOD getScannerXonXoffFlow
		METHOD setScannerXonXoffFlow( param )
		
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

METHOD function getScannerPort()			CLASS TSettingEquipment
	return ::FScannerPort

METHOD procedure setScannerPort( param )		CLASS TSettingEquipment

	if ischaracter( param )
		::FScannerPort := alltrim( param )
	endif
	return

METHOD function getScannerBaudRate()				CLASS TSettingEquipment
	return ::FScannerBaudRate

METHOD procedure setScannerBaudRate( param )		CLASS TSettingEquipment

	if isnumber( param )
		::FScannerBaudRate := param
	endif
	return

METHOD function getScannerDataBits()				CLASS TSettingEquipment
	return ::FScannerDataBits

METHOD procedure setScannerDataBits( param )		CLASS TSettingEquipment

	if isnumber( param )
		::FScannerDataBits := param
	endif
	return

METHOD function getScannerParity()				CLASS TSettingEquipment
	return ::FScannerParity

METHOD procedure setScannerParity( param )		CLASS TSettingEquipment

	if ischaracter( param )
		::FScannerParity := alltrim( param )
	endif
	return

METHOD function getScannerStopBits()				CLASS TSettingEquipment
	return ::FScannerStopBits

METHOD procedure setScannerStopBits( param )		CLASS TSettingEquipment

	if isnumber( param )
		::FScannerStopBits := param
	endif
	return

METHOD function getScannerXonXoffFlow()			CLASS TSettingEquipment
	return ::FScannerXonXoffFlow

METHOD procedure setScannerXonXoffFlow( param )	CLASS TSettingEquipment

	if ischaracter( param )
		::FScannerXonXoffFlow := alltrim( param )
	endif
	return

METHOD function getSCReader()						CLASS TSettingEquipment
	return ::FSCReader

METHOD procedure setSCReader( param )			CLASS TSettingEquipment

	if ischaracter( param )
		::FSCReader := alltrim( param )
	endif
	return

METHOD New( file ) CLASS TSettingEquipment
	local typeKKT
	local cPort, cSCReader, nBaudRate, nDataBits, cParity, nStopBits, cXonXoff
		 
	INI oIni FILE file
		GET typeKKT				SECTION 'KKT' ENTRY 'Type'					OF oIni DEFAULT 1
		GET cPort				SECTION 'Scanner Barcode' ENTRY 'COM port'	OF oIni DEFAULT 'Нет'
		GET nBaudRate			SECTION 'Scanner Barcode' ENTRY 'BaudRate'	OF oIni DEFAULT 9600
		GET nDataBits			SECTION 'Scanner Barcode' ENTRY 'DataBits'	OF oIni DEFAULT 8
		GET cParity				SECTION 'Scanner Barcode' ENTRY 'Parity'	OF oIni DEFAULT 'Нет'
		GET nStopBits			SECTION 'Scanner Barcode' ENTRY 'StopBits'	OF oIni DEFAULT 1
		GET cXonXoff				SECTION 'Scanner Barcode' ENTRY 'XonXoffFlow'	OF oIni DEFAULT 'Нет'
		GET cSCReader			SECTION 'Smart Card Reader' ENTRY 'Type'	OF oIni DEFAULT 'Нет'
	ENDINI
	::_objINI := oIni
	::FTypeKKT := typeKKT
	::FScannerPort := alltrim( cPort )
	::FScannerBaudRate := nBaudRate
	::FScannerDataBits := nDataBits
	::FScannerParity := cParity
	::FScannerStopBits := nStopBits
	::FScannerXonXoffFlow := cXonXoff
	::FSCReader := padr( cSCReader, 50 )
	return self
	
METHOD Save() CLASS TSettingEquipment
		 
	SET SECTION 'KKT' ENTRY 'Type'						TO ::FTypeKKT			OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'COM port'		TO ::FScannerPort		OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'BaudRate'		TO ::FScannerBaudRate	OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'DataBits'		TO ::FScannerDataBits	OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'Parity'			TO ::FScannerParity		OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'StopBits'		TO ::FScannerStopBits	OF ::_objINI
	SET SECTION 'Scanner Barcode' ENTRY 'XonXoffFlow'	TO ::FScannerXonXoffFlow	OF ::_objINI
	SET SECTION 'Smart Card Reader' ENTRY 'Type'			TO ::FSCReader			OF ::_objINI
	return nil
