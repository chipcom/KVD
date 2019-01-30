#include 'simpleio.ch'
#include 'common.ch'

//  https://docs.microsoft.com/ru-ru/windows/desktop/CIMWin32Prov/win32-serialport

function getListCOMPorts()
	local aRet := {}
	local oLocator := win_oleCreateObject( 'WbemScripting.SWbemLocator' )
	local oWMI := oLocator:ConnectServer( '.', 'root\cimv2' )
	local item
	
	&& ? "Win_SerialPort"
	aadd( aRet, 'нет')
	for each item in oWMI:ExecQuery( 'SELECT * FROM Win32_SerialPort' )
		if ischaracter( item:Name )
			aadd( aRet, item:DeviceID )
		endif
	next
	return aRet