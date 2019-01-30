#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// виды используемых ККМ
#define KKT_NONE 1
#define KKT_OFF 2
#define KKT_SHTRIH 3

function settingsWorkPlace( r, c )
	local mas_pmt := { '~Подключаемое оборудование', ;
			'~Настройка значений по умолчанию' }
	local mas_msg := { 'Настройка подключаемого оборудования', ;
			'Настройка значений по умолчанию на рабочем месте' }
	local mas_fun := { 'addedEquipment()', ;
			'nastr_rab_mesto()' }
			
	HB_Default( @r, T_ROW ) 
	HB_Default( @c, T_COL - 30 ) 

	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

* 29.01.19
function addedEquipment()
	local cgreen := 'G+/B'											// цвет для меток
	local mmComPort := {}, i := 0
	local mmSmartCard := {}
	local mmTypeKKT := { { 'Не использовать ККТ     ', KKT_NONE }, ;
						{ 'ККТ off-Line            ', KKT_OFF }, ;
						{ 'ККТ Штрих-М: Драйвер ФР ', KKT_SHTRIH } }
	local hb_kkt_Equipment := TSettingEquipment():New( 'Workplace' )		// переменная для настроек оборудования
	local hb_kkt_KKT := TSettingKKT():New( 'Workplace' )					// переменная для настроек ККТ
	local iFind := 0, iCount := 0, item, oBox
	
	private mtypeKKT, m1typeKKT := hb_kkt_KKT:TypeKKT
	private mComPort, m1ComPort, cComPort := hb_kkt_Equipment:ComPort
	private mSmartCard, m1SmartCard, cSmartCard := hb_kkt_Equipment:SCReader
	for each item in getListCOMPorts()
		aadd( mmComPort, { item, ++i } )
	next
	i := 0 // обнулим счетчик
	for each item in getListSmartCards()
		aadd( mmSmartCard, { item, ++i } )
	next
	
	oBox := TBox():New( 1, 0, 22, 78, .t. )
	oBox:Caption := 'Настройка подключаеиого оборудования'
	oBox:CaptionColor := color8
	oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<PgDn>^ - подтверждение ввода'
	oBox:Color := cDataCGet
	oBox:View()
	
	for each item in mmComPort
		iCount++
		if alltrim( item[ 1 ] ) == alltrim( cComPort )
			iFind := iCount
			exit
		endif
	next
	m1ComPort := if( iFind == 0, 1, iFind )
	mComPort := inieditspr( A__MENUVERT, mmComPort, m1ComPort )
	
	iFind := 0
	iCount := 0
	for each item in mmSmartCard
		iCount++
		if alltrim( item[ 1 ] ) == alltrim( cSmartCard )
			iFind := iCount
			exit
		endif
	next
	m1SmartCard := if( iFind == 0, 1, iFind )
	mSmartCard := inieditspr( A__MENUVERT, mmSmartCard, m1SmartCard )
	
	mtypeKKT := inieditspr( A__MENUVERT, mmTypeKKT, m1typeKKT )
	
	ix := 2
	// выбор последовательного порта к которому подключен сканер штрих-кода
	@ ix, 2 SAY 'Сканер штрих-кода:' color cgreen
	@ ++ix, 2 say 'Порт: ' get mComPort ;
		reader { | x | menu_reader( x, mmComPort, A__MENUVERT ) }
	@ ++ix, 2 SAY 'Устройство чтения смарт-карт:' color cgreen
	@ ++ix, 2 say 'Тип: ' get mSmartCard ;
		reader { | x | menu_reader( x, mmSmartCard, A__MENUVERT ) }
	@ ++ix, 2 SAY 'Контрольно-кассовая техника:' color cgreen
	@ ++ix, 2 say 'Тип ККТ: ' get mtypeKKT ;
		reader { | x | menu_reader( x, mmTypeKKT, A__MENUVERT, , , .f. ) }

	myread()
	if lastkey() == K_ESC
		oBox := nil
		return nil
	endif
	if f_Esc_Enter( 1 )
		hb_kkt_Equipment:ComPort := mmComPort[ m1ComPort, 1 ]
		hb_kkt_Equipment:SCReader := mmSmartCard[ m1SmartCard, 1 ]
		hb_kkt_Equipment:Save()
		hb_kkt_KKT:TypeKKT := m1typeKKT
		hb_kkt_KKT:Save()
	endif
	oBox := nil
	return nil