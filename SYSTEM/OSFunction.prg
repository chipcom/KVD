#include 'simpleio.ch'
#include 'common.ch'

* https://docs.microsoft.com/en-us/windows-hardware/drivers/install/system-defined-device-setup-classes-available-to-vendors
* https://docs.microsoft.com/ru-ru/windows/desktop/CIMWin32Prov/win32-serialport

* 29.01.19
* получим список доступных COM-портов
function getListCOMPorts()
	local aRet := {}
	local oLocator := win_oleCreateObject( 'WbemScripting.SWbemLocator' )
	local oWMI := oLocator:ConnectServer( '.', 'root\cimv2' )
	local item
	
	aadd( aRet, 'нет')
	for each item in oWMI:ExecQuery( 'SELECT * FROM Win32_SerialPort' )
		if ischaracter( item:Name )
			aadd( aRet, item:DeviceID )
		endif
	next
	return aRet

* 30.01.19
* получим список доступных ридеров смарт-карт
function getListSmartCards()
	local aRet := {}
	local oLocator := win_oleCreateObject( 'WbemScripting.SWbemLocator' )
	local oWMI := oLocator:ConnectServer( '.', 'root\cimv2' )
	local item
	
	aadd( aRet, 'нет')
	for each item in oWMI:ExecQuery( "SELECT * FROM Win32_PnPEntity WHERE ClassGuid = '{50DD5230-BA8A-11D1-BF5D-0000F805F530}'" )
		if ischaracter( item:Name )
			aadd( aRet, item:Caption )
		endif
	next
	return aRet