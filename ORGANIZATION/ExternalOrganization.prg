* ExternalOrganization.prg - подсистема работа с внешними организациями
*****************************************************
* 03.11.18 viewStdds() - редактирование списка стационаров детей-сирот
* 03.11.18 editPayer( nType ) - вывод списка организаций плательщиков по платным услугам	
* 03.11.18 viewSchool() - редактирование списка образовательной организации
* 03.11.18 viewCommitte( nType ) - редактирование списка общих справочников комитетов и страховых
* 03.11.18 editCommittee( oBrowse, aObjects, oCommon, nKey, typeClass ) - редактирование объекта справочника комитета или страховых
* 22.10.18 EditPayerOrg( oBrowse, aObjects, oOrganization, nKey ) - редактирование организации плательщика
* 21.10.18 editSchool( oBrowse, aObjects, oOrganization, nKey ) - редактирование объекта образовательная организация
* 21.10.18 editStdds( oBrowse, aObjects, oOrganization, nKey ) - редактирование объекта стационар детей-сирот
* 05.04.17 layoutSchool( oBrow, aList ) - формирование колонок для отображения списка образовательной организации
* 04.04.17 layoutStdds( oBrow, aList ) - формирование колонок для отображения списка стационаров детей-сирот
* 07.09.16 layoutOrganization( oBrow, aList ) - формирование колонок для отображения организаций плательщиков по платным услугам
* 26.06.17 edit_d_smo( num ) - ф-ция пустышка для совместимости
* 26.06.17 edit_pr_vz( num ) - ф-ция пустышка для совместимости
*****************************************************
#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

static strSchool := 'РЕДАКТИРОВАНИЕ ОБРАЗОВАТЕЛЬНОЙ ОРГАНИЗАЦИИ'
static strStdds := 'РЕДАКТИРОВАНИЕ СТАЦИОНАРА'


* 26.06.17 - ф-ция пустышка для совместимости
function edit_pr_vz( num )

	editPayer( PU_PR_VZ )
	return nil
	
* 26.06.17 - ф-ция пустышка для совместимости
function edit_d_smo( num )

	editPayer( PU_D_SMO )
	return nil

* 03.11.18 - вывод списка организаций плательщиков по платным услугам	
function editPayer( nType )
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | EditPayerOrg( oBrowse, aObjects, object, nKey ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )
	aProperties := { { 'INN', 'ИНН', 10 }, { 'Name', 'Организация', 30 } }

	// просмотр и редактирование списка организаций
	oBox := TBox():New( T_ROW, 0, maxrow() - 2, 79, .t. )
	oBox:Color := color5
	oBox:CaptionColor := col_tit_popup
	
	if nType == PU_D_SMO
		oBox:Caption := 'Список страховых организаций'
		ListObjectsBrowse( 'TCompanyDMS', oBox, TCompanyDMSDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	else
		oBox:Caption := 'Список организаций по взаимозачету'
		ListObjectsBrowse( 'TCompanyVzaim', oBox, TCompanyVzaimDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	endif
	return nil

* 22.10.18 - редактирование организации плательщика
function EditPayerOrg( oBrowse, aObjects, oOrganization, nKey )
	local nRow := row(), nCol := col(), tmp_color, buf := save_maxrow(), ;
			buf1, fl := .f., r1, r2, i, c_1, c_2
	local k, ix, x, lC := .t.
	local tmpAr := {}
	local str_1, iRow := 0
	local oBank := nil

	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		oBank := oOrganization:Bank
		if oBank == nil
			oBank := TBank():New()
		endif
		r1 := 11
		c_1 := T_COL + 5
		c_2 := c_1 + 62

		oBox := TBox():New( r1, 0, maxrow() - 1, maxcol(), .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление', 'Редактирование' ) + ' информации об организации'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ ++r1, 2 say 'Наименование' get oOrganization:Name picture '@!@S30'
		@ r1, col() + 2 say 'ИНН' get oOrganization:INN picture '999999999'
		@ ++r1, 2 say 'Полное наименование' get oOrganization:FullName picture '@!@S50'
		++r1
		@ ++r1, 2 say 'Адрес' get oOrganization:Address picture '@!@S50'
		@ r1, col() + 2 say 'Телефон' get oOrganization:Phone
		
		@ ++r1, 0 say '╟' + replicate( '─', 78 ) + '╢'
		
		@ ++r1, 2 say 'Банк' get oBank:Name picture '@!@S50'
		@ r1, col() + 2 say 'БИК' get oBank:BIK
		@ ++r1, 2 say 'Расч. счет' get oBank:RSchet
		@ r1, col() + 2 say 'Кор. счет' get oBank:KSchet
		@ ++r1, 2 say 'Договор' get oOrganization:Dogovor
		@ r1, col() + 2 say 'Дата договора' get oOrganization:Date

		myread()
		if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
			oOrganization:Bank := oBank	// TBank():New( mBank, mAccount, mCorAccount, mBIK )
			if upper( oOrganization:classname() ) == upper( 'TCompanyDMS' )
				TCompanyDMSDB():Save( oOrganization )
			elseif  upper( oOrganization:classname() ) == upper( 'TCompanyVzaim' )
				TCompanyVzaimDB():Save( oOrganization )
			endif
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
		&& stat_msg( 'Ждите! Производится проверка на допустимость удаления данной компании' )
		if len( TContractDB():GetListByTypeAndIDPayer( iif( oOrganization:classname() == upper( 'TCompanyDMS' ), 1, 2 ), oOrganization:ID() ) ) > 0
			hb_Alert( { 'Данная организация встречается в других базах данных.', 'Удаление запрещено!' }, , , 4 )
			ret := .f.
		else
			if upper( oOrganization:classname() ) == upper( 'TCompanyDMS' )
				TCompanyDMSDB():Delete( oOrganization )
			elseif  upper( oOrganization:classname() ) == upper( 'TCompanyVzaim' )
				TCompanyVzaimDB():Delete( oOrganization )
			endif
			ret := .t.
		endif
	endif
	return .t.

* 03.11.18 редактирование списка образовательной организации
function viewSchool()
	local blkEditObject
	local aEdit
	local aProperties

	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editSchool( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Name', 'Наименование', 25 }, { 'Address', 'Адрес', 25 }, { 'Type_F', 'Тип', 14 } }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )

	// просмотр и редактирование списка образовательной организации
	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 77, .t. )
	oBox:Caption := 'Общеобразовательные учреждения'
	oBox:Color := color5
	ListObjectsBrowse( 'TSchool', oBox, TSchoolDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )

	return nil

* 21.10.18 редактирование объекта образовательная организация
static function editSchool( oBrowse, aObjects, oSchool, nKey )
	local fl := .f.
	
	private mtype, m1type := 0
	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		m1type		:= oSchool:Type
		mtype := inieditspr_bay( A__MENUVERT, TSchool():aMenuTypeSchool, m1type )
		
		k := maxrow() - 7

		oBox := TBox():New( k, 5, k + 5, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление нового', 'Редактирование' ) + ' учреждения'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ k + 1, 7 say 'Сокращенное наименование' get oSchool:Name picture '@S44'
		@ k + 2, 7 say 'Полное наименование' get oSchool:FullName picture '@S44'
		@ k + 3, 7 say 'Юридический адрес' get oSchool:Address picture '@S51'
		@ k + 4, 7 say 'Тип' get mtype ;
				reader { | x | menu_reader( x, TSchool():aMenuTypeSchool, A__MENUVERT, , , .f. ) }
	
		myread()
		if lastkey() != K_ESC .and. !empty( oSchool:Name ) .and. f_Esc_Enter( 1 )
			oSchool:Type := m1type
			TSchoolDB():Save( oSchool )
			oBrowse:refreshAll()
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
	endif
	return fl

* 03.11.18 редактирование списка стационаров детей-сирот
function viewStdds()
	local blkEditObject
	local aEdit
	local aProperties

	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editStdds( oBrowse, aObjects, object, nKey ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )
	aProperties := { { 'Name', 'Наименование', 25 }, { 'Address', 'Адрес', 25 }, { 'Vedom_F', 'Ведомственная;принадлежность', 14 } }

	// просмотр и редактирование списка образовательной организации
	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 77, .t. )
	oBox:Caption := 'Стационары детей-сирот'
	oBox:Color := color5
	ListObjectsBrowse( 'TStdds', oBox, asort( TStddsDB():GetList(), , , { | x, y | x:Name() < y:Name() } ), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 21.10.18 редактирование объекта стационар детей-сирот
static function editStdds( oBrowse, aObjects, oStdds, nKey )
	local fl := .f.
	
	private mvedom, m1vedom := 0

	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		mvedom := inieditspr_bay( A__MENUVERT, TStdds():aMenuVedom, m1vedom )
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 4, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление нового', 'Редактирование' ) + ' стационара'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ k + 1, 7 say 'Наименование стационара' get oStdds:Name picture '@S44'
		@ k + 2, 7 say 'Адрес стационара' get oStdds:Address picture '@S51'
		@ k + 3, 7 say 'Ведомственная принадлежность' get mvedom ;
				reader { | x | menu_reader( x, TStdds():aMenuVedom, A__MENUVERT, , , .f. ) }
		myread()
		if lastkey() != K_ESC .and. !empty( oStdds:Name ) .and. f_Esc_Enter( 1 )
			oStdds:Vedom := m1vedom
			TStddsDB():Save( oStdds )
			oBrowse:refreshAll()
			fl := .t.
		elseif nKey == K_DEL
		endif
		oBox := nil
	endif
	return fl
	
* 03.11.18 редактирование списка общих справочников
function viewCommitte( nType )
	local blkEditObject
	local aEdit
	local tName, aObjects
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editCommittee( oBrowse, aObjects, object, nKey, nType ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .f., .t., .f. }, { .f., .f., .f., .f. } )
	
	// просмотр и редактирование списка образовательной организации
	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 76, .t. )
	oBox:Color := color5
	if nType == 1
		oBox:Caption := 'Страховые компании'
		tName := 'TInsuranceCompany'
		aObjects := asort( TInsuranceCompanyDB():GetList(), , , { | x, y | x:Name() < y:Name() } )
		aProperties := { { 'Name', 'Страховые компании', 30 } }
	elseif nType == 2
		oBox:Caption := 'Комитеты здравоохранения'
		tName := 'TCommittee'
		aObjects := TCommitteeDB():GetList()
		aProperties := { { 'Name', 'Комитеты здравоохранения', 30 } }
	else
		return nil
	endif
	ListObjectsBrowse( tName, oBox, aObjects, 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 03.11.18 редактирование объекта справочника
static function editCommittee( oBrowse, aObjects, oCommon, nKey, typeClass )
	local fl := .f.
	local mtfoms := 0
	local oBank
	local oBox
	
	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		private m1paraclinika := 0, mparaclinika
		private m1mist_fin := 0, mmist_fin
		
		oBank := oCommon:Bank()
		if oBank == nil
			oBank := TBank():New()
		endif
		if typeClass == 1
			mtfoms	:= oCommon:TFOMS
		endif
		m1paraclinika	:= oCommon:Paraclinika
		m1mist_fin	:= oCommon:SourceFinance
		
		mparaclinika   := inieditspr_bay( A__MENUVERT, mm_danet, m1paraclinika )
		mmist_fin   := inieditspr_bay( A__MENUVERT, mm_ist_fin, m1mist_fin )
		
		k := maxrow() - 19
		
		oBox := TBox():New( k, 5, k + 14, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление', 'Редактирование' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ k + 1, 7 say 'Наименование' get oCommon:Name picture '@S30'
		@ k + 2, 7 say 'Полное наименование' get oCommon:FullName picture '@S49'
		@ k + 3, 7 say 'ИНН/КПП' get oCommon:INN picture '99999999999999999999'
		@ k + 4, 7 say 'Адрес' get oCommon:Address picture '@S50'
		@ k + 5, 7 say 'Телефон' get oCommon:Phone picture '99-99-99'
		@ k + 6, 7 say 'Банк' get oBank:Name picture '@S50'
		@ k + 7, 7 say 'Расчетный счет' get oBank:RSchet picture '99999999999999999999'
		@ k + 8, 7 say 'Корр.счет' get oBank:KSchet picture '99999999999999999999'
		@ k + 9, 7 say 'БИК' get oBank:BIK picture '9999999999'
		@ k + 10, 7 say 'ОКОНХ' get oCommon:OKONH picture '999999999999999'
		@ k + 11, 7 say 'ОКПО' get oCommon:OKPO picture '999999999999999'
		@ k + 12, 7 say "Включать ПАРАКЛИНИКУ в сумму счета по данной компании" get mparaclinika ;
				reader { | x | menu_reader( x, mm_danet, A__MENUVERT, , , .f. ) }
		
		@ k + 13, 7 say 'Источник финансирования' get mmist_fin ;
				reader { | x | menu_reader( x, mm_ist_fin, A__MENUVERT, , , .f. ) }
//		@ k + 10, 7 say 'Код ТФОМС' get mname picture '@S30'
		myread()
		if lastkey() != K_ESC .and. !empty( oCommon:Name ) .and. f_Esc_Enter( 1 )
			if typeClass == 1
				oCommon:TFOMS := mtfoms
			endif
			oCommon:Paraclinika := m1paraclinika
			oCommon:SourceFinance := m1mist_fin
			if typeClass == 1
				TInsuranceCompanyDB():Save( oCommon )
			elseif typeClass == 2
				TCommitteeDB():Save( oCommon )
			endif
			oBrowse:refreshAll()
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
	endif
	return fl
	
*****
function ret_arr_dms( r1,c1 )
	static sa
	local r2, c2, nr := 0, arr := {}, t_mas := {}, buf, buf1, i, ret
	
	HB_Default( @r1, T_ROW ) 
	HB_Default( @c1, T_COL + 5 ) 
	arr := TCompanyDMSDB():MenuCompanies( .f. )
	nr := len( arr )
	if nr == 0
		func_error( 4, 'Справочник ДСМО пуст!' )
		return nil
	endif
	asort( arr, , , { | x, y | upper( x[ 2 ] ) < upper( y[ 2 ] ) } )
	aeval( arr, { | x | aadd( t_mas, x[ 2 ] ) } )
	r2 := r1 + nr + 1
	c2 := c1 + 33 + 1
	if c2 > 77
		c2 := 77 ; c1 := 76 - 33
	endif
	if r2 > maxrow() - 2 ; r2 := maxrow() - 2 ; endif
	
	if r2 == maxrow() - 2
		r1 := r2 - nr - 1
		if r1 < 2 ; r1 := 2 ; endif
	endif
	
	buf := save_box( r1, c1, r2 + 1, c2 + 2 )
	buf1 := save_row( maxrow() )
	aeval( t_mas, { | x, i, fl | fl := iif( sa == nil, .t., ascan( sa, arr[ i, 1 ] ) > 0 ), t_mas[ i ] := iif( fl, ' * ', '   ' ) + t_mas[ i ] } )
	status_key( '^<Esc>^-отказ; ^<Enter>^-выбор; ^<Ins,+,->^-смена признака печати данной ДСМО' )
		
	if popup( r1, c1, r2, c2, t_mas, , color0, .t., 'fmenu_reader' ) > 0
		ret := {}
		for i := 1 TO nr
			if '*' $ left( t_mas[ i ], 3 )
				aadd( ret, arr[ i, 1 ] )
			endif
		next
		if empty( ret )
			ret := nil
		endif
		sa := ret
	endif
	rest_box( buf )
	rest_box( buf1 )
	return ret

*****
function ret_arr_vz( r1, c1 )
	static sa
	local r2, c2, nr := 0, arr := {}, t_mas := {}, buf, buf1, i, ret
	
	HB_Default( @r1, T_ROW ) 
	HB_Default( @c1, T_COL + 5 ) 
	arr := TCompanyVzaimDB():MenuCompanies( .f. )
	nr := len( arr )
	if nr == 0
		hb_Alert( 'Справочник организаций пуст!', , , 4 )
		return nil
	endif
	asort( arr, , , { | x, y | upper( x[ 2 ] ) < upper( y[ 2 ] ) } )
	aeval( arr, { | x | aadd( t_mas, x[ 2 ] ) } )
	r2 := r1 + nr + 1
	c2 := c1 + 33 + 1
	if c2 > 77
		c2 := 77 ; c1 := 76 - 33
	endif
	if r2 > maxrow() - 2 ; r2 := maxrow() - 2 ; endif
	if r2 == maxrow() - 2
		r1 := r2 - nr - 1
		if r1 < 2 ; r1 := 2 ; endif
	endif
	buf := save_box( r1, c1, r2 + 1, c2 + 2 )
	buf1 := save_row( maxrow() )
	aeval( t_mas, { | x, i, fl | fl := iif( sa == nil, .t., ascan( sa, arr[ i, 1 ] ) > 0 ), t_mas[ i ] := iif( fl, ' * ', '   ' ) + t_mas[ i ] } )
	status_key( '^<Esc>^-отказ; ^<Enter>^-выбор; ^<Ins,+,->^-смена признака печати данного предприятия' )
	
	if popup( r1, c1, r2, c2, t_mas, , color0, .t., 'fmenu_reader' ) > 0
		ret := {}
		for i := 1 to nr
			if '*' $ left( t_mas[ i ], 3 )
				aadd( ret, arr[ i, 1 ] )
			endif
		next
		if empty( ret )
			ret := nil
		endif
		sa := ret
	endif
	rest_box( buf )
	rest_box( buf1 )
	return ret		