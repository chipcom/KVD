#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// виды используемых ККМ
#define KKT_NONE 1
#define KKT_OFF 2
#define KKT_SHTRIH 3

function settingsWorkPlace()
	local si1 := 1
	local mas_pmt := {}, mas_msg := {}, mas_fun := {}
	
	aadd( mas_pmt, '~Подключаемое оборудование' )
	aadd( mas_msg, 'Настройка подключаемого оборудования' )
	aadd( mas_fun, 'addedEquipment()' )
	//
	aadd( mas_pmt, '~Настройка значений по умолчанию' )
	aadd( mas_msg, 'Настройка значений по умолчанию на рабочем месте' )
	aadd( mas_fun, 'nastr_rab_mesto()' )

	popup_prompt( T_ROW, T_COL - 30, si1, mas_pmt, mas_msg, mas_fun )
	return nil

* 31.01.19 подключенное внешнее оборудование
function addedEquipment()
	local cgreen := 'G+/B'											// цвет для меток
	local mmComPort := {}, i := 0
	local mmSmartCard := {}
	local mmTypeKKT := { { 'Не использовать ККТ     ', KKT_NONE }, ;
						{ 'ККТ off-Line            ', KKT_OFF }, ;
						{ 'ККТ Штрих-М: Драйвер ФР ', KKT_SHTRIH } }
	local hb_kkt_Equipment := TSettingEquipment():New( 'Equipment' )		// переменная для настроек оборудования
	local iFind := 0, iCount := 0, item, oBox
	
	private mtypeKKT, m1typeKKT := hb_kkt_Equipment:TypeKKT
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
	@ ix, 2 say 'Сканер штрих-кода:' color cgreen
	@ ++ix, 3 say 'Порт: ' get mComPort ;
		reader { | x | menu_reader( x, mmComPort, A__MENUVERT, , , .f. ) }
	@ ++ix, 2 say 'Устройство чтения смарт-карт:' color cgreen
	@ ++ix, 3 say 'Тип: ' get mSmartCard ;
		reader { | x | menu_reader( x, mmSmartCard, A__MENUVERT, , , .f. ) }
	@ ++ix, 2 say 'Контрольно-кассовая техника:' color cgreen
	@ ++ix, 3 say 'Тип ККТ: ' get mtypeKKT ;
		reader { | x | menu_reader( x, mmTypeKKT, A__MENUVERT, , , .f. ) }
	// Настройка кассового аппарата
	if isFiscalReg( m1typeKKT )
		@ ++ix, 3 say 'Системные параметры:' color cgreen
		@ ++ix, 4 say 'Драйвер установлен:'
		// @ ix, col() + 1 SAY if( getDrvFR():Driver != nil, 'Да', 'Нет' ) color 'R/B+'
		// if getDrvFR():Driver != nil
			// @ ix, col() + 1 SAY 'Версия драйвера:'
			// do case
			// case m1typeKKT == KKT_SHTRIH
				// @ ix, col() + 1 SAY getDrvFR():Version	color 'R/B+'
			// endcase
			// @ ++ix, 4 say 'Настройка драйвера ...' get mnkassa ;
				// reader { | x | menu_reader( x, { { || PropertiesFR() } }, A__FUNCTION, , , .f. ) }
		// endif
	endif
	myread()

	if f_Esc_Enter( 1 )
		hb_kkt_Equipment:TypeKKT := m1typeKKT
		hb_kkt_Equipment:ComPort := mmComPort[ m1ComPort, 1 ]
		hb_kkt_Equipment:SCReader := mmSmartCard[ m1SmartCard, 1 ]
		hb_kkt_Equipment:Save()
	endif
	 oBox := nil
	return nil