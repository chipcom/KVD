#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

function settingsWorkPlace( r, c )
	local mas_pmt := { '~Подключаемое оборудование', ;
			'~Настройка значений по умолчанию' }
	local mas_msg := { 'Настройка подключаемого оборудования', ;
			'Настройка значений по умолчанию на рабочем месте' }
	local mas_fun := { 'addedEquipment()', ;
			'nastr_rab_mesto()' }
			
	local sItem
	
	&& DEFAULT r TO T_ROW, c TO T_COL + 5
	&& DEFAULT r TO T_ROW, c TO T_COL - 20
	HB_Default( @r, T_ROW ) 
	HB_Default( @c, T_COL - 20 ) 

	sItem := popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
alertx(sItem)
	return nil

* 29.01.19
function addedEquipment()
	static cgreen := 'G+/B'											// цвет для меток
	static group_ini := 'RAB_MESTO'
	
	local ar, sr
	local hb_kkt_Equipment := TSettingEquipment():New( 'Workplace' )		// переменная для настроек оборудования
	local iFind := 0, iCount := 0, item, oBox
	local mmComPort := {}, i := 0
	
	private mComPort, m1ComPort, cComPort := hb_kkt_Equipment:ComPort	// ()
	private mm_reader := { { 'нет', space( 50 ) }, { 'подключить', '1' } }, m1m_reader
	
	for each item in getListCOMPorts()
		aadd( mmComPort, { item, ++i } )
	next
	
	ar := GetIniSect( tmp_ini, group_ini )
	sr := a2default( ar, 'sc_reader' )
	if ! empty( sr )
		mm_reader[ 2, 1 ] := sr
		mm_reader[ 2, 2 ] := padr( sr, 50 )
	endif
	
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
	
	ix := 2
	// выбор последовательного порта к которому подключен сканер штрих-кода
	@ ix, 2 SAY 'Сканер штрих-кода:' color cgreen
	@ ++ix, 2 say 'Порт: ' get mComPort ;
		reader { | x | menu_reader( x, mmComPort, A__MENUVERT ) }
	@ ++ix, 2 SAY 'Устройство чтения смарт-карт:' color cgreen
	@ ++ix, 2 say 'Тип: ' get mm_reader ;
		reader { | x | menu_reader( x, mm_reader, A__MENUVERT ) }

	myread()
	&& read
	&& if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
	if f_Esc_Enter( 1 )
		hb_kkt_Equipment:ComPort := mmComPort[ m1ComPort, 1 ]
		hb_kkt_Equipment:Save()
	endif
	return nil

* 29.01.19
function addedEquipment1()
	static group_ini := "RAB_MESTO"
	&& static mm_wdir := {{'в папку рабочего каталога "OwnChipArchiv"',0},;
					&& {"в другое место",1}}
	&& static mm_wokato := {{'использовать значение из "Общих настроек"',0},;
						&& {"своя настройка на данном рабочем месте",1}}
	local ar, sr, mm_tmp := {}
	
	delete file tmp.dbf
	//
	private mm_reader := {{"нет",space(50)},{"подключить","1"}}
	&& private mm_oms_pole := {"сроки лечения",;    //  1
							&& "леч.врач",;         //  2
							&& "осн.диагноз",;      //  3
							&& "профиль",;          //  4
							&& "результат",;        //  5
							&& "исход",;            //  6
							&& "повод обращения",;  //  7
							&& "способ оплаты"}     //  8
	ar := GetIniSect( tmp_ini, group_ini )
	sr := a2default( ar, 'sc_reader' )
	if ! empty( sr )
		mm_reader[ 2, 1 ] := sr
		mm_reader[ 2, 2 ] := padr( sr, 50 )
	endif
	aadd( mm_tmp, { 'sc_reader', 'C', 50, 0, nil, ;
				{ | x | menu_reader( x, mm_reader, A__MENUVERT ) }, ;
				'', { | x | inieditspr( A__MENUVERT, mm_reader, x ) }, ;
				'Устройство чтения смарт-карт (для эл.полиса)', ;
				{ | | iif( empty( m1sc_reader ), .t., f_read_sc_reader() ) }, ;
				{ | | tip_polzovat == 0 } } )
				
	&& aadd(mm_tmp, {"base_copy","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_danet,A__MENUVERT)},;
				&& 1,{|x|inieditspr(A__MENUVERT,mm_danet,x)},;
				&& 'Выполнять автоматическое резервное копирование при выходе из программы',,;
				&& {|| tip_polzovat == 0 }})
	&& aadd(mm_tmp, {"wdir","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_wdir,A__MENUVERT)},;
				&& 0,{|x|inieditspr(A__MENUVERT,mm_wdir,x)},;
				&& '└> куда выполняется копирование',;
				&& {|| iif(empty(m1wdir), (mpath_copy:=m1path_copy:=space(100),update_get("mpath_copy")), .t.) },;
				&& {|| tip_polzovat == 0 .and. m1base_copy == 1 }})
	&& aadd(mm_tmp, {"path_copy","C",100,0,NIL,;
				&& {|x| menu_reader(x,{{|k,r,c| mng_dir(k,r,c,"path_copy") }},A__FUNCTION)},;
				&& " ",{|x| x },;
				&& ' └> каталог для копирования',,;
				&& {|| tip_polzovat == 0 .and. m1base_copy == 1 .and. m1wdir == 1 }})
	&& aadd(mm_tmp, {"kart_polis","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_danet,A__MENUVERT)},;
				&& 1,{|x|inieditspr(A__MENUVERT,mm_danet,x)},;
				&& 'В режиме добавления в картотеку производить поиск пациента по полису'})
	&& aadd(mm_tmp, {"e_1","C",1,0,NIL,,"",,;
				&& 'Какие поля запоминать и переносить в следующий добавляемый случай при вводе',,;
				&& {|| .f. }})
	&& aadd(mm_tmp, {"oms_pole","N",15,0,NIL,;
				&& {|x|menu_reader(x,mm_oms_pole,A__MENUBIT)},;
				&& 0,{|x|inieditspr(A__MENUBIT,mm_oms_pole,x)},;
				&& 'л/у ОМС:'})
	&& aadd(mm_tmp, {"wokato","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_wokato,A__MENUVERT)},;
				&& 0,{|x|inieditspr(A__MENUVERT,mm_wokato,x)},;
				&& 'Какое ОКАТО по умолчанию использовать',;
				&& {|| iif(empty(m1wokato), (m_okato:=space(70),m1_okato:=space(11),update_get("m_okato")), .t.) }})
	&& aadd(mm_tmp, {"_okato","C",11,0,NIL,;
				&& {|x|menu_reader(x,{{ |k,r,c| get_okato_ulica(k,r,c,{k,m_okato,}) }},A__FUNCTION)},;
				&& space(11),{|x| ret_okato_ulica('',x)},;
				&& '└> ОКАТО по умолчанию',,;
				&& {|| m1wokato == 1 }})
	&& if is_obmen_sds()
		&& aadd(mm_tmp, {"e_2","C",1,0,NIL,,"",,;
					&& 'Каталоги для обмена информацией с программой Smart Delta Systems:',,;
					&& {|| .f. }})
		&& aadd(mm_tmp, {"path1_sds","C",100,0,NIL,;
					&& {|x| menu_reader(x,{{|k,r,c| mng_dir(k,r,c,"path1_sds") }},A__FUNCTION)},;
					&& " ",{|x| x },;
					&& '==> для импорта картотеки',,;
					&& {|| tip_polzovat == 0 }})
		&& aadd(mm_tmp, {"path2_sds","C",100,0,NIL,;
					&& {|x| menu_reader(x,{{|k,r,c| mng_dir(k,r,c,"path2_sds") }},A__FUNCTION)},;
					&& " ",{|x| x },;
					&& '==> для обработанных файлов',,;
					&& {|| tip_polzovat == 0 }})
	&& endif
	init_base( cur_dir + 'tmp', , mm_tmp, 0 )
	use ( cur_dir + 'tmp' ) new
	append blank
	tmp->sc_reader := sr
	&& tmp->base_copy := int( val( a2default( ar, 'base_copy', '1' ) ) )
	&& tmp->path_copy := a2default( ar, 'path_copy', '' )
	&& tmp->wdir := iif( empty( tmp->path_copy ), 0, 1 )
	&& tmp->kart_polis := int( val( a2default( ar, 'kart_polis', '1' ) ) )
	&& tmp->oms_pole := int( val( a2default( ar,'oms_pole', '0' ) ) )
	&& tmp->_okato := a2default( ar, 'okato_umolch', '' )
	&& tmp->wokato := iif( empty( tmp->_okato ), 0, 1 )
	&& if is_obmen_sds()
		&& tmp->path1_sds := a2default( ar, 'path1_sds', '' )
		&& tmp->path2_sds := a2default( ar, 'path2_sds', '' )
	&& endif
	close databases
	if f_edit_spr( A__EDIT, mm_tmp, 'настройке рабочего места', 'g_use( cur_dir + "tmp", , , .t., .t. )', 0, 1 ) > 0
		use ( cur_dir + 'tmp' ) new
		&& mm_tmp := { ;
				&& { group_ini, 'sc_reader',   tmp->sc_reader }, ;
				&& { group_ini, 'base_copy',   tmp->base_copy }, ;
				&& { group_ini, 'path_copy',   tmp->path_copy }, ;
				&& { group_ini, 'kart_polis',  tmp->kart_polis }, ;
				&& { group_ini, 'oms_pole',    tmp->oms_pole }, ;
				&& { group_ini, 'okato_umolch',tmp->_okato } ;
				&& }
		mm_tmp := { ;
				{ group_ini, 'sc_reader',   tmp->sc_reader } ;
				}
		&& if is_obmen_sds()
			&& aadd( mm_tmp, { group_ini, 'path1_sds', alltrim( tmp->path1_sds ) } )
			&& aadd( mm_tmp, { group_ini, 'path2_sds', alltrim( tmp->path2_sds ) } )
		&& endif
		SetIniVar( tmp_ini, mm_tmp )
	endif
	close databases
	return nil