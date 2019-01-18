***** mo_adres.prg
#include 'common.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

Static skod_volg := '18400'
// УРОВЕНЬ-1 Ter (C-2) код территории
// Начало территории 18-000-000-000-1 - Наименование территорий

// УРОВЕНЬ-2 РАЙОН ИЛИ ГОРОД областного подчинения
// Kod1 2XX-000-000-1 РАЙОН 200- шапка
// KOD1 4XX-000-000-1 ГОРОД 400- шапка
// 110-170 - автономные округа
// 200     - районы
// 400     - города
// 500-550 - города федерального подчинения
// фролово           18-428-000-000-1 ниже нет
// УРОВЕНЬ-3 (если есть)
// внутри городов (обл подчинения только РАЙОНЫ)
// KOD2 -ХХХ
// первая цифра в порядке kod2-не нужна
// центральный (в-д) 18-401-395-000-1
// для Районов области - сельсоветы.
//
// 5xx - ПОДЧИНЕННЫЕ ГОРОДА (ПОСЁЛКИ)

/***** инициализация всех БД адресного реестра
Function main()
cls
f_first()

Private MtADRES, M1tADRES := space(11)  // адрес
m1tadres := '18401395000'
//
adrr_index()
@ 1,0 say oktAdRetS(m1tadres)
//
@ 5,5 say 'ОКАТО прописки  ' get mtadres reader ;
          {|x| menu_reader(x,{{|k,r,c| oktAdGet(k,r,c,{m1tadres,mtadres,1}) }},A__FUNCTION,,,.f.)}
myread()

@ 2,0 say m1tadres
inkey(0)
return NIL*/

* 23.11.18 редактирование списка общих справочников
function viewAddressString()
	local blkEditObject
	local aEdit
	local oBox
	local tName
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editViewAddressString( oBrowse, aObjects, object, nKey ) }
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .f., .t., .t. }, { .f., .f., .f., .f. } )
	aProperties := { { 'Name', 'Подстрока адреса', 40 } }

	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 76, .t. )
	oBox:Color := color5
	oBox:Caption := 'Адресные строки'
	// просмотр и редактирование списка
	ListObjectsBrowse( 'TAddressString', oBox, TAddressStringDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 23.11.18 редактирование объекта справочника
static function editViewAddressString( oBrowse, aObjects, oCommon, nKey )
	local fl := .f.

	if nKey == K_INS .OR. nKey == K_ENTER .or. nKey == K_F4
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 2, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление', 'Редактирование' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		@ k + 1, 7 say 'Строка для записи' get oCommon:Name picture '@S40'
		myread()
		if lastkey() != K_ESC .and. !empty( oCommon:Name ) .and. f_Esc_Enter( 1 )
			TAddressStringDB():Save( oCommon )
			fl := .t.
		endif
	endif
	return fl

* 23.11.18 переиндексировать все файлы адресного реестра ОКАТО
function okato_index()
	local aTemplate := { 'T_okatorDB', 'T_okatooDB', 'T_okatosDB', 'T_okatoo8DB', 'T_okatos8DB' }
	local item

	for each item in aTemplate
		&item():Index()
	next
	return nil

* 11.03.15 вернуть адрес вместе с улицей
function ret_okato_ulica( _adres, _okato, _region, _par )
	local s

	DEFAULT _par TO 1
	_adres := alltrim( charone( ' ', _adres ) )
	if _par == 1 // сначала улица
		s := iif( empty( _adres ), '', _adres + ' / ' ) + oktAdRetS( _okato, _region )
	else // в конце улица
		s := oktAdRetS( _okato, _region ) + iif( empty( _adres ), '', ' ' + _adres )
	endif
	return iif( empty( s ), space( 10 ), s )

* 22.11.18 ввод адреса по ОКАТО в GET'е
function get_okato_ulica( kod11, r, c, mas_adr )
	local ret, buf, tmp_help := chm_help_code, tmp_keys

	private madrs := space( 120 ), m1adrs := space( 11 ), madrs1 := space( 120 ), ;
			mulicadom

	if isarray( mas_adr )
		m1adrs := kod11 // или mas_adr[1]
		madrs := madrs1 := mas_adr[ 2 ]
		mulicadom := mas_adr[ 3 ]
	endif
	old_adrs1 := madrs1
	buf := savescreen()
	tmp_keys := my_savekey()
	chm_help_code := 1	//H_Vvod_adrs
	ret := oktAdGetSt( r, c )
	chm_help_code := tmp_help
	my_restkey( tmp_keys )
	restscreen( buf )
	if ret != nil
		aadd( ret, mulicadom ) // добавляем в возврат третим элементом улицу и дом
	endif
	return ret

* 22.11.18 вернуть адрес в массиве
function ret_okato_Array( kod11 ) //, open_base )
	local arr_okato := { '', '', '', '' }
	local oRegion

	oRegion := T_okatorDB():getByOKATO( kod11 )
	if ! isnil( oRegion )
		arr_okato[ 1 ] := alltrim( oRegion:Name )
		oRegion := nil
	endif
	if left( kod11, 2 ) == '40'
		arr_okato[ 1 ] := 'г.Санкт-Петербург'
	elseif left( kod11, 2 ) == '45'
		arr_okato[ 1 ] := 'г.Москва'
	elseif left( kod11, 2 ) == '67'
		arr_okato[ 1 ] := 'г.Севастополь'
	endif
	//
	oRegion := T_okatooDB():getByOKATO( kod11 )
	if ! isnil( oRegion )
		if oRegion:Tip == 3 // города
			arr_okato[ 3 ] := alltrim( oRegion:Name )
		elseif oRegion:Tip == 4 // федеральные города
			arr_okato[ 3 ] := alltrim( oRegion:Name )
		else
			arr_okato[ 2 ] := alltrim( oRegion:Name )
		endif
		oRegion := nil
	endif
	//
	if ! ( left( kod11, 6 ) == '184013' ) // ни один из районов Волгограда
		oRegion := T_okatosDB():getByOKATO( kod11 )
		if ! isnil( oRegion )
			arr_okato[ 4 ] := alltrim( oRegion:Name )
		endif
	endif
	//
	return arr_okato

* 22.11.18 ф-ия get-а адреса
static function oktAdGetSt( r, c )
	local tmp_color, ret, s
	local oBox
	local oRegion, oOblast, oPunkt

	local r1, c1, r2, c2

	r1 := r + 1
	r2 := r1 + 7
	if r2 > maxrow() - 2
		r2 := r - 1
		r1 := r2 - 7
	endif
	c1 := 2
	c2 := 77
	
	oBox := TBox():New( r1, c1, r2, c2, .t. )
	oBox:Caption := 'Ввод адреса по ОКАТО'
	oBox:CaptionColor := 'GR/W'
	oBox:Color := 'N+/W'
	s := '^<Esc>^ - выход;  ^<PgDn>^ - подтверждение ввода адреса'
	if ! isnil( mulicadom )
		s += ';  ^<F3>^ - выбор улицы'
	endif
	oBox:MessageLine := s
	oBox:View()
	@ r2 - 2, c1 say '╟' + replicate( '─', c2 - c1 - 1 ) + '╢' color 'N+/W'
	
	private pr_adrs := m1adrs, ;
			mregion := space( 63 ), m1region := space( 11 ), ;
			moblast := space( 50 ), m1oblast := space( 11 ), ;
			mnas_punkt := space( 39 ), m1nas_punkt := space( 11 ), ;
			mstr_adrs := alltrim( madrs )
	private blk_s_adrs := { | | DevPos( r2 - 1, c1 + 1 ), ;
							DevOut( padc( alltrim( mstr_adrs ), c2 - c1 - 1), 'W+/W' ) }
	if empty( m1adrs )
		madrs1 := space( 120 )
	else  // т.е. редактирование
		m1region    := left( m1adrs, 2 )
		m1oblast    := left( m1adrs, 5 )
		m1nas_punkt := left( m1adrs, 11 )
	endif
	if !empty( m1adrs )
		oRegion := T_okatorDB():getByOKATO( m1region )
		if isnil( oRegion )
			mregion := space( 63 )
		else
			mregion := padr( oRegion:Name, 63 )
		endif
		//
		oOblast := T_okatooDB():getByOKATO( m1oblast )
		if isnil( oOblast )
			moblast := space( 50 )
		else
			moblast := padr( oOblast:Name, 50 )
		endif
		//
		oPunkt := T_okatosDB():getByOKATO( m1nas_punkt )
		if isnil( oPunkt )
			mnas_punkt := space( 39 )
		else
			mnas_punkt := padr( oPunkt:Name, 39 )
		endif
	endif
	//
	eval( blk_s_adrs )
	//
	tmp_color := setcolor( 'N/W,W+/N, , ,B/W' )
	@ r1 + 1, c1 + 3 say 'Регион' get mregion ;
				reader { | x | menu_reader( x, ;
					{ { | k, r, c | get_region( k, r, c ) }, 63 }, A__FUNCTION, , , .f. ) } ;
				valid { | oGet, o | val_AdGetSt( oGet, o, 1 ) }
	@ r1 + 2, c1 + 3 say 'Район области/Город' get moblast ;
				reader { | x | menu_reader( x, ;
					{ { | k, r, c | get_oblast( k, r, c ) }, 50 }, A__FUNCTION, , , .f. ) } ;
				when when_AdGetSt( 2 ) ;
				valid { | oGet, o | val_AdGetSt( oGet, o, 2 ) }
	@ r1 + 3, c1 + 3 say 'Населенный пункт/район города' get mnas_punkt ;
				reader { | x | menu_reader( x, ;
					{ { | k, r, c | get_nas_punkt( k, r, c ) }, 39 }, A__FUNCTION, , , .f. ) } ;
				when when_AdGetSt( 3 ) ;
				valid { | oGet, o | val_AdGetSt( oGet, o, 3 ) }
	if ! isnil( mulicadom )
		@ r1 + 4, c1 + 3 say 'Улица, дом, квартира' get mulicadom ;
				when when_AdGetSt( 3 ) ;
				valid { | oGet | val_AdGetSt( oGet, , 4 ) }
		set key K_F3 TO v_vvod_adres
	endif
	myread()
	if ! isnil( mulicadom )
		set key K_F3 TO
	endif
	if lastkey() != K_ESC
		ret := { padr( alltrim( pr_adrs ), 11, '0' ), mstr_adrs }
	endif
	setcolor( tmp_color )
	oBox := nil
	return ret

* 21.11.18
static function get_region( k, r, c )
	local ret
	local oBox
	local selObject
	local aProperties
	local aObjects
	local nI := 0
	local aEdit
	local blkEditObject
	
	if r <= maxrow() / 2
		oBox := TBox():New( r, 2, maxrow() - 2, 77, .t. )
	else
		oBox := TBox():New( 2, 2, r - 1, 77, .t. )
	endif
	oBox:Color := color0
	oBox:Caption := 'Выбор региона РФ'
	oBox:CaptionColor := 'BG+/GR'
	
	aProperties := { { 'OKATO_Name', 'Наименование', 72 } }
	aObjects := T_okatorDB():GetList()
	aEdit := { .f., .f., .f., .f. }
	blkEditObject := { | oBrowse, aObjects, object, nKey | findObjectInList( oBrowse, aObjects, object, nKey ) }
	
	if empty( m1region )
		nI := ascan( aObjects, { | x | x:OKATO == '18' } )
	else
		nI := ascan( aObjects, { | x | x:OKATO == m1region } )
	endif
	nI := iif( nI == 0, 1, nI )

	// выбор объекта из списка
	selObject := ListObjectsBrowse( 'T_okator', oBox, aObjects, nI, aProperties, ;
						blkEditObject, aEdit , , '^<F2>^ - поиск по подстроке', 'N/BG,W+/N,GR+/BG,GR+/N', .t. )
	if isnil( selObject )
		ret := nil
	else
		ret := { selObject:OKATO, selObject:Name }
	endif
	oBox := nil
	return ret

* 21.11.18
static function get_oblast( k, r, c )
	local ret
	local oBox
	local selObject
	local aProperties
	local aObjects
	local nI := 0
	local blk
	local aEdit
	local blkEditObject
	local tObj

	if r <= maxrow()/2
		oBox := TBox():New( r, 2, maxrow() - 2, 77, .t. )
	else
		oBox := TBox():New( 2, 2, r - 1, 77, .t. )
	endif
	oBox:Color := color0
	oBox:Caption := 'Выбор района области/города'
	oBox:CaptionColor := 'BG+/GR'
	
	blk := { | | if( parr[ nInd ]:Zagol == 1, { 3, 4 }, { 1, 2 } ) }
	aProperties := { { 'Name', 'Наименование', 60, blk } }
	aEdit := { .f., .f., .f., .f. }
	blkEditObject := { | oBrowse, aObjects, object, nKey | findObjectInList( oBrowse, aObjects, object, nKey ) }
	
	if ! isnil( m1region ) .and. m1region == '18'
		aObjects := T_okatoo8DB():getListByRegion( m1region )
		tObj := 'T_okatoo8'
	else
		aObjects := T_okatooDB():getListByRegion( m1region )
		tObj := 'T_okatoo'
	endif
	if len( aObjects ) == 0
		hb_alert( 'Не найдено областей/городов для данного региона!', , , 4 )
		keyboard chr(K_ESC)
		ret := nil
	endif
	
	if empty( m1oblast )
		if !empty( okato_umolch ) .and. m1region == left( okato_umolch, 2 )
			nI := ascan( aObjects, { | x | x:OKATO == left( okato_umolch, 5 ) } )
		endif
	else
		nI := ascan( aObjects, { | x | x:OKATO == m1oblast } )
	endif
	nI := iif( nI == 0, 1, nI )

	// выбор объекта из списка
	selObject := ListObjectsBrowse( tObj, oBox, aObjects, nI, aProperties, ;
						blkEditObject, aEdit , , '^<F2>^ - поиск по подстроке', 'N/BG,W+/N,GR+/BG,GR+/N', .t. )
	if isnil( selObject ) .or. selObject:Zagol == 1
		ret := nil
	else
		ret := { selObject:OKATO, selObject:Name }
	endif
	oBox := nil
	return ret

* 22.11.18
static function get_nas_punkt( k, r, c )
	local ret
	local oBox
	local selObject
	local aProperties
	local aObjects
	local nI := 0
	local aEdit
	local blkEditObject
	local blk, tObj

	if r <= maxrow() / 2
		oBox := TBox():New( r, 2, maxrow() - 2, 77, .t. )
	else
		oBox := TBox():New( 2, 2, r - 1, 77, .t. )
	endif
	
	oBox:Color := color0
	oBox:Caption := 'Выбор района области/города'
	oBox:CaptionColor := 'BG+/GR'
	
	blk := { | | if( parr[ nInd ]:Zagol == 1, { 3, 4 }, { 1, 2 } ) }
	aProperties := { { 'Name', 'Наименование', 60, blk } }
	aEdit := { .f., .f., .f., .f. }
	blkEditObject := { | oBrowse, aObjects, object, nKey | findObjectInList( oBrowse, aObjects, object, nKey ) }
	
	if ! isnil( m1region ) .and. m1region == '18'
		aObjects := T_okatos8DB():getListByOblast( m1oblast )
		tObj := 'T_okatos8'
	else
		aObjects := T_okatosDB():getListByOblast( m1oblast )
		tObj := 'T_okatos'
	endif
	if len( aObjects ) == 0
		hb_alert( 'Не найдено населенных пунктов для данного района!', , , 4 )
		keyboard chr(K_ESC)
		ret := nil
	endif
	
	if ! empty( m1nas_punkt )
		nI := ascan( aObjects, { | x | x:OKATO == m1nas_punkt } )
	endif
	nI := iif( nI == 0, 1, nI )

	// выбор объекта из списка
	selObject := ListObjectsBrowse( tObj, oBox, aObjects, nI, aProperties, ;
						blkEditObject, aEdit , , '^<F2>^ - поиск по подстроке', 'N/BG,W+/N,GR+/BG,GR+/N', .t. )
	if isnil( selObject ) .or. selObject:Zagol == 1
		ret := nil
	else
		ret := { selObject:OKATO, selObject:Name }
	endif
	oBox := nil
	return ret

*
static function when_AdGetSt( regim )
	local ret := .t., len_okato := len( alltrim( pr_adrs ) )

	if regim == 2 .and. len_okato < 2 // районы
		hb_alert( 'Не выбран РЕГИОН!', , , 3 )
		ret := .f.
	elseif regim == 3 .and. len_okato < 5 // нас.пункт (улица)
		hb_alert( 'Не выбран РАЙОН области или ГОРОД!', , , 3 )
		ret := .f.
	endif
	return ret

*****
static function val_AdGetSt( oGet, old, regim )

	if regim < 4 .and. isnil( old )
		return .t.
	endif
	do case
		case regim == 1  // районы
			if !( m1region == old ) //.and. m1region > 0
				pr_adrs := padr( m1region, 11, '0' )
				mstr_adrs := ret_okato_ulica( mulicadom, pr_adrs )
				m1oblast := m1nas_punkt := space( 11 )
				moblast := space( 50 )
				mnas_punkt := space( 39 )
			endif
		case regim == 2  // районы
			if !( m1oblast == old )
				pr_adrs := padr( m1oblast, 11, '0' )
				mstr_adrs := ret_okato_ulica( mulicadom, pr_adrs )
				m1nas_punkt := space( 11 )
				mnas_punkt := space( 39 )
			endif
		case regim == 3  // поселки
			if !( m1nas_punkt == old )
				pr_adrs := padr( m1nas_punkt, 11, '0' )
				mstr_adrs := ret_okato_ulica( mulicadom, pr_adrs )
			endif
		case regim == 4  // улица
			if !( mulicadom == oGet:original )
				mstr_adrs := ret_okato_ulica( mulicadom, pr_adrs )
			endif
	endcase
	eval( blk_s_adrs )
	return update_gets()

* 22.11.18 вернуть адрес в строке
static function oktAdRetS( kod11, is_region )
// is_region = 0 - не выводить нашу область
// is_region = 1 - не выводить нашу область для Волгограда
// is_region = 2 - выводить область
	local oRegion
	local lregion := '', lnas_punkt := '', loblast := ''

	DEFAULT is_region TO 0	//, open_base TO .t.
	//
	oRegion := T_okatorDB():getByOKATO( kod11 )
	if ! isnil( oRegion )
		lregion := alltrim( oRegion:Name )
		oRegion := nil
	endif
	
	oRegion := T_okatooDB():getByOKATO( kod11 )
	if ! isnil( oRegion )
		loblast := alltrim( oRegion:Name )
		oRegion := nil
	endif
	
	oRegion := T_okatosDB():getByOKATO( kod11 )
	if ! isnil( oRegion )
		lnas_punkt := alltrim( oRegion:Name )
		oRegion := nil
	endif
	
	if left( kod11, 2 ) == '18' .and. is_region == 0
		lregion := '' // не выводим наименование Волгоградской области
	elseif left( kod11, 5 ) == '18401' .and. is_region == 1
		lregion := '' // для Волгограда не выводим наименование области
	endif
	return alltrim( rtrim( lregion ) + ' ' + rtrim( loblast ) + ' ' + lnas_punkt )

* 22.11.18 ввод фразы для адреса из списка
static function v_vvod_adres()
	local k, nrow := row(), ncol := col(), fl := .f., tmp_keys, tmp_gets

	tmp_keys := my_savekey()
	if ( get := get_pointer( 'MULICADOM' ) ) != nil .and. get:hasFocus
		save gets to tmp_gets
		setcursor( 0 )
		if !empty( k := input_s_adres() )
			fl := .t.
		else
			@ nrow,ncol say ''
		endif
		restore gets from tmp_gets
		if fl
			keyboard ( alltrim( k ) + ' ' )
		endif
		setcursor()
	endif
	my_restkey( tmp_keys )
	return nil

* 22.11.18 выбор фразы для адреса
static function input_s_adres()
	local r1, r2
	local oBox
	local aProperties
	local selObject
	local ret := ''
	local aEdit
	local blkEditObject

	oBox := TBox():New( 2, 36, maxrow() - 2, 79, .t. )
	oBox:Color := color0
	oBox:Caption := ''
	
	aProperties := { { 'Name', 'Список фраз для адреса', 40 } }
	aEdit := { .t., .f., .f., .t. }
	blkEditObject := { | oBrowse, aObjects, object, nKey | editAddressString( oBrowse, aObjects, object, nKey ) }
	// выбор объекта из списка
	selObject := ListObjectsBrowse( 'TAddressString', oBox, TAddressStringDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , , .t. )
	if ! isnil( selObject )
		ret := alltrim( selObject:Name )
	endif
	return ret

* 22.11.18 добавление объекта справочника "строк адреса"
static function editAddressString( oBrowse, aObjects, oStringAddress, nKey )
	local fl := .f.
	local oBox

	if nKey == K_INS .or. nKey == K_F4
		k := maxrow() - 3
		
		oBox := TBox():New( k, 34, k + 2, 77, .t. )
		oBox:Caption := 'Добавление'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		@ k + 1, 36 get oStringAddress:Name picture '@S40'
		myread()
		if lastkey() != K_ESC .and. !empty( oStringAddress:Name ) .and. f_Esc_Enter( 1 )
			TAddressStringDB():Save( oStringAddress )
			fl := .t.
		endif
	endif
	return fl

* 30.11.18 поиск по подстроке в справочнике
static function findObjectInList( oBrowse, aObjects, oStringAddress, nKey )
	local fl := .f.
	local i

	if nKey == K_F2
		oBox := nil
		if ( i := findElementInListObjects( aObjects, 'Name' ) ) > 0
			nInd := i // приватная переменная функции ListObjectsBrowse
		endif
	endif
	return fl

* 24.11.18
function getAddressPatient( reg, k, r, c )
	local ret, ret1, oldk, s, mm_menu := { 'тот же', 'другой' }

	if reg == 1
		if ( ret1 := get_okato_ulica( mokatog, r, c, { mokatog, madres_reg, madres } ) ) != nil
			mokatog := ret1[ 1 ]
			madres_reg := ret1[ 2 ]
			madres := ret1[ 3 ]
			ret := { 1, madres_reg }
		endif
	else
		if ! emptyall( mokatop, madresp )
			mm_menu[ 2 ] := madres_pre
		endif
		if c + len( mm_menu[ 2 ] ) + 3 > 77
			mm_menu[ 2 ] := left( mm_menu[ 2 ], 77 - 3 - c )
		endif
		oldk := k
		if ( k := popup_prompt( r + 1, c, oldk, mm_menu ) ) > 0
			if k == 1
				mokatop := space( 11 )
				madres_pre := mm_menu[ 1 ]
				madresp := space( 50 )
				ret := { 1, madres_pre }
			else
				s := iif( oldk == 1, okato_umolch, mokatop )
				if ( ret1 := get_okato_ulica( s, r, c, { s, madres_pre, madresp } ) ) != nil ;
												.and. ! ( ret1[ 2 ] == mm_menu[ 1 ] )
					mokatop := ret1[ 1 ]
					madres_pre := ret1[ 2 ]
					madresp := ret1[ 3 ]
					ret := { 2, madres_pre }
				endif
			endif
		endif
	endif
	return ret

function ini_adres_bay( reg )
	local s := space( 10 )
	
	if reg == 1
		if mo_nodigit( mokatog )
			mokatog := s
		endif
		if ! emptyall( mokatog, madres )
			s := left( ret_okato_ulica( madres, mokatog ), 60 )
		endif
	else
		if mo_nodigit( mokatop )
			mokatop := s
		endif
		if emptyall( mokatop, madresp )
			s := 'тот же'
			m1adres_pre := 1
		else
			s := ret_okato_ulica( madresp, mokatop )
			m1adres_pre := 2
		endif
	endif
	return s

