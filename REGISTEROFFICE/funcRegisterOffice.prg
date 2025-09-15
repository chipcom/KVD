* различные функции общего пользования для подсистемы Регистратура
*******************************************
*******************************************
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 19.11.18 проверить отдельно фамилию, имя и отчество в GET'ах
function checkGetFIO( oGET, ltip, par, /*@*/msg )
	static arr_pole := { 'Фамилия', 'Имя', 'Отчество' }
	static arr_char := { ' ', '-', '.', "'", '"' }
	local fl := .t., i, c, s1 := '', nword := 0, r := row()
	local getString
	
	DEFAULT par TO 1
	getString := alltrim( oGET:buffer )
	for i := 1 to len( arr_char )
		getString := charone( arr_char[ i ], getString )
	next
	if len( getString ) > 0
		getString := upper( left( getString, 1 ) ) + substr( getString, 2 )
	endif
	for i := 1 to len( getString )
		c := substr( getString, i, 1 )
		if isralpha( c )
			//
		elseif ascan( arr_char, c ) > 0
			++nword
		else
			s1 += c
		endif
	next
	msg := ''
	if ! empty( s1 )
		msg := 'В поле "' + arr_pole[ ltip ] + '" обнаружены недопустимые символы "' + s1 + '"'
	elseif empty( getString ) .and. ltip < 3
		msg := 'Пустое значение поля "' + arr_pole[ ltip ] + '" недопустимо'
	endif
	if par == 1  // для GET-системы
		if empty( msg ) .and. nword > 0
			r := oGET:Row
			fl := .f.
			if f_alert( { padc( 'В поле "' + arr_pole[ ltip ] + '" занесено ' + lstr( nword + 1 ) + ' слова', 60, '.' ) }, ;
						{ ' Возврат в редактирование ', ' Правильное поле ' }, ;
						1, 'W+/N', 'N+/N', r + 1, , 'W+/N,N/BG' ) == 2
				fl := .t.
			endif
		endif
	endif
	if ! empty( msg )
		if par == 1  // для GET-системы
			hb_alert( msg, , , 4 )
		else  // для проверки ТФОМС
		endif
		fl := .f.
	endif
	return fl

* 25.12.18 проверка ввода СНИЛС
function roCheckSNILS( oGet, oPatient )
	local ret := .t., mkod
	
	ret := val_snils( charrem( ' -', oGet:buffer ), 1 )
	if ! ret
		return ret
	endif
	if ( findKartoteka_bay( oPatient, 3, @mkod ) )
		update_gets()
	endif
	return ret

* 18.11.18 переопределение критерия "взрослый/ребёнок" по дате рождения и "_date"
function roCheckDOB( oGet, oPatient, _data, fl_end )
	local cy, k, ret := .t., mkod

	DEFAULT _data TO sys_date, fl_end TO .t.
	cy := count_years( ctod( oGet:buffer ), _data )
	if k == nil
		if cy < 14
			k := 1  // ребенок
		elseif cy < 18
			k := 2  // подросток
		else
			k := 0  // взрослый
		endif
	endif
	if fl_end
		if type( 'm1vid_ud' ) == 'N' .and. empty( m1vid_ud )
			m1vid_ud := iif( k == 1, 3, 14 )
		endif
	endif
	if ( findKartoteka_bay( oPatient, 1, @mkod ) )
		update_gets()
	endif
	return ret

// 10.08.23 поиск пациента в картотеке во время режима добавления
function findKartoteka_bay( oPatient, k, /*@*/lkod_k, oPolicyOMS )
	local s, buf, rec := 0
	local obj
	local oBox

	if ! oPatient:IsNew
		return .t.
	endif
	if k == 1 .and. ! emptyany( oPatient:LastName, oPatient:FirstName, oPatient:DOB )
		obj := TPatientDB():getByFIOAndDOB( oPatient:FIO, oPatient:DOB )
	elseif k == 2	// .and. !empty( mnpolis ) .and. p_find_polis > 0
		obj := TPatientDB():getByPolicy( oPolicyOMS:PolicySeries, oPolicyOMS:PolicyNumber )
	elseif k == 3 .and. ! empty( CHARREPL( '0', oPatient:SNILS, ' ' ) )
		obj := TPatientDB():getBySNILS( oPatient:SNILS )
	endif
	//
	if ! isnil( obj )
		oBox := TBox():New( 10, 0, 19, 79, .t. )
		oBox:CaptionColor := 'G+/RB'
		oBox:Color := 'G+/B'
		&& oBox:MessageLine := '^<Esc>^ - выход;  ^<PgDn>^ - подтверждение ввода'
		oBox:Caption := ' В картотеке найден пациент ' + iif( k == 1, '', iif( k == 2, 'с таким полисом ', 'с таким СНИЛС ' ) )
		oBox:View()
		infoPatientToScreen( obj, 11, 18 )
		keyboard ''
		music_m( 'OK' )
		Millisec( 100 )  // задержка на 0.1 с
		keyboard ''
		if f_alert( { 'Взять этого пациента из картотеки или продолжить вводить нового?' }, ;
					{ ' Новый пациент ', ' Взять из картотеки ' }, ;
					2, 'W+/N', 'N+/N', 20, , 'W+/N,N/BG' ) == 2
			oPatient := obj
			update_gets()
		endif
		oBox := nil
	endif
	return .t.


* 29.11.18 - получить список субъектов РФ
function getListSRF()
	local item, iFind := 0, i
	local oSRF
	local aReturn := {}
	local aOKATOR := T_OKATORDB():getList()
	local aOKATOO := T_OKATOODB():getList()

	for i := 1 to len( glob_array_srf() )
		if  glob_array_srf()[ i, 2 ] == '18000'
			loop
		endif
		iFind := 0
		if ( iFind := ascan( aOKATOO, { | x | x:OKATO == glob_array_srf()[ i, 2 ] } ) ) > 0
			glob_array_srf()[ i, 1 ] := rtrim( aOKATOO[ iFind ]:Name )
		else
			if ( iFind := ascan( aOKATOR, { | x | x:OKATO == left( glob_array_srf()[ i, 2 ], 2 ) } ) ) > 0
				glob_array_srf()[ i, 1 ] := rtrim( aOKATOR[ iFind ]:Name )
			elseif left( glob_array_srf()[ i, 2 ], 2 ) == '55'
				glob_array_srf()[ i, 1 ] := 'г.Байконур'
			endif
		endif
		oSRF := TSRF():New( glob_array_srf()[ i, 2 ], iif( substr( glob_array_srf()[ i, 2 ], 3, 1 ) == '0','', '  ' ) + glob_array_srf()[ i, 1 ] )
		aadd( aReturn, oSRF )
	next
	return aReturn

/*
* 29.11.18 выбор субъекта ПФ из списка (за исключением Волгоградской Области ОКАТО = 18000)
function get_srf( k, r, c )
	local ret := { space( 5 ), space( 10 ) }
	local blkEditObject
	local oBox
	local aProperties
	local selObject
	local cMessage := ''
	local r1, r2
	local item
	
	if r <= maxrow() / 2
		r1 := r
		r2 := maxrow() - 2
	else
		r1 := 2
		r2 := r - 1
	endif
	
	oBox := TBox():New( r1, 2, r2, 77, .t. )
	oBox:Color := color0
	oBox:Caption := 'Выбор субъекта РФ (территории страхования)'
	oBox:CaptionColor := 'BG+/GR'
	aProperties := { { 'OKATO', 'ОКАТО', 5 }, ;
					{ 'Name', 'Наименование', 66 } }
	blkEditObject := { | oBrowse, aObjects, object, nKey | editSRF( oBrowse, aObjects, object, nKey ) }
	cMessage := ' ^<F2>^ - поиск'
	
&& {"═","░","═","N/BG,W+/N,B/BG,W+/B",.f.,72}
	// выбор объекта из списка
	selObject := ListObjectsBrowse( 'TSRF', oBox, asort( getListSRF(), , , { | x, y | x:OKATO < y:OKATO } ), 1, aProperties, ;
										blkEditObject, , , cMessage, , .t. )
	if ! isnil( selObject )
		ret := { selObject:OKATO, selObject:Name }
	endif
	return ret
*/

* 30.11.18 поиск в справочнике субъектов РФ
static function editSRF( oBrowse, aObjects, oCommon, nKey )
	local fl := .f.
	local i

	if nKey == K_F2
		if ( i := findElementInListObjects( aObjects, 'Name' ) ) > 0
			nInd := i // приватная переменная функции ListObjectsBrowse
		endif
	endif
	return fl

// 12.09.25
function infoPatientToScreen( oPatient, r1, r2 )
	local i, s, s1, mmo_pr, arr := {}
	
	is_talon := .t. // пока так
	if is_uchastok > 0 .or. glob_mo()[ _MO_IS_UCH ]
		s := ''
		if is_uchastok > 0
			s := 'Тип ' + oPatient:Bukva
			s += space( 3 ) + 'Участок ' + lstr( oPatient:District )
			if is_uchastok == 1
				s += space( 3 ) + 'Код ' + lstr( oPatient:Kod_VU )
			elseif is_uchastok == 3
				s += space( 3 ) + 'Код АК МИС ' + alltrim( oPatient:AddInfo:AmbulatoryCard ) + space( 5 )
			endif
			s += space( 3 )
		endif
		if glob_mo()[ _MO_IS_UCH ]
			if left( oPatient:AddInfo:PC2, 1 ) == '1'
				mmo_pr := 'По информации из ТФОМС пациент У_М_Е_Р'
			elseif oPatient:AddInfo:MOCodeAttachment == glob_mo()[ _MO_KOD_TFOMS ]
				mmo_pr := 'Прикреплён '
				if !empty( oPatient:AddInfo:PC4 )
					mmo_pr += 'с ' + alltrim( oPatient:AddInfo:PC4 ) + ' '
				elseif !empty( oPatient:AddInfo:DateAttachment )
					mmo_pr += 'с ' + date_8( oPatient:AddInfo:DateAttachment ) + ' '
				endif
				mmo_pr += 'к нашей МО'
			else
				s1 := alltrim( inieditspr( A__MENUVERT, glob_arr_mo(), oPatient:AddInfo:MOCodeAttachment ) )
				if empty( s1 )
					mmo_pr := 'Прикрепление --- неизвестно ---'
				else
					mmo_pr := ''
					if !empty( oPatient:AddInfo:PC4 )
						mmo_pr += 'с ' + alltrim( oPatient:AddInfo:PC4 ) + ' '
					elseif !empty( oPatient:AddInfo:DateAttachment )
						mmo_pr += 'с ' + date_8( oPatient:AddInfo:DateAttachment ) + ' '
					endif
					mmo_pr += 'прикреплён к ' + s1
				endif
			endif
			s += mmo_pr
		endif
		aadd( arr, s )
	endif
	s := 'Ф.И.О.: ' + oPatient:FIO + space( 7 ) + iif( oPatient:Gender == 'М', 'мужчина', 'женщина' )
	aadd( arr, s )
	s := 'Дата рождения: ' + full_date( oPatient:DOB ) + space( 5 ) + ;
			'(' + alltrim( inieditspr( A__MENUVERT, menu_vzros, oPatient:Vzros_Reb ) ) + ')'
	if !empty( oPatient:SNILS )
//		s += space( 5 ) + 'СНИЛС: ' + transform( oPatient:SNILS, picture_pf )
		s += space( 5 ) + 'СНИЛС: ' + transform_SNILS( oPatient:SNILS )
	endif
	aadd( arr, s )
	oPatient:Passport:Format := 'TYPE SSS № NNN выдан: DATE'
	s := alltrim( oPatient:Passport:AsString )
	aadd( arr, s )
	s := 'Место рождения: ' + alltrim( oPatient:ExtendInfo:PlaceBorn )
	aadd( arr, s )
	s := 'Адрес: '
	if !emptyall( oPatient:ExtendInfo:OKATOG, oPatient:AddressReg )
		s += left( ret_okato_ulica( oPatient:AddressReg, oPatient:ExtendInfo:OKATOG ), 60 )
	endif
	aadd( arr, s )
	if !emptyall( oPatient:ExtendInfo:OKATOP, oPatient:ExtendInfo:AddressStay )
		s := 'Адрес пребывания: ' + left( ret_okato_ulica( oPatient:AddressStay, oPatient:ExtendInfo:OKATOP ), 60 )
		aadd( arr, s )
	endif
	s := 'Полис ОМС: '
	if !empty( oPatient:AddInfo:SinglePolicyNumber )
		s += '(ЕНП ' + alltrim( oPatient:AddInfo:SinglePolicyNumber ) + ') '
	endif
	if !emptyall( oPatient:ExtendInfo:BeginPolicy, oPatient:PolicyPeriod )
		s += '('
		if !empty( oPatient:ExtendInfo:BeginPolicy )
			s += 'с ' + date_8( oPatient:ExtendInfo:BeginPolicy )
		endif
		if !empty( oPatient:PolicyPeriod )
			s += ' по ' + date_8( oPatient:PolicyPeriod )
		endif
		s += ') '
	endif
	if !empty( oPatient:ExtendInfo:PolicySeries )
		s += alltrim( oPatient:ExtendInfo:PolicySeries ) + ' '
	endif
	s += alltrim( oPatient:ExtendInfo:PolicyNumber ) + ' (' + ;
		alltrim( inieditspr( A__MENUVERT, mm_vid_polis, oPatient:ExtendInfo:PolicyType ) ) + ') ' + ;
		smo_to_screen_bay( 1, oPatient )
	aadd( arr, s )
	if eq_any( glob_task, X_REGIST, X_OMS, X_PLATN, X_ORTO, X_KASSA, X_PPOKOJ, X_MO )
		s := upper( rtrim( inieditspr( A__MENUVERT, menu_rab, oPatient:Working ) ) )
		if oPatient:ExtendInfo:IsPensioner
			s += space( 5 ) + 'пенсионер'
		endif
		if !empty( oPatient:PlaceWork )
			s += ',  место работы: ' + oPatient:PlaceWork
		endif
		aadd( arr, s )
	endif

	if eq_any( glob_task, X_MO )
		if !emptyall( oPatient:ExtendInfo:HomePhone, oPatient:ExtendInfo:MobilePhone, oPatient:ExtendInfo:WorkPhone )
			s := 'Телефоны:'
			if !empty( oPatient:ExtendInfo:HomePhone )
				s += ' домашний ' + oPatient:ExtendInfo:HomePhone
			endif
			if !empty( oPatient:ExtendInfo:MobilePhone )
				s += ' мобильный ' + oPatient:ExtendInfo:MobilePhone
			endif
			if !empty( oPatient:ExtendInfo:WorkPhone )
				s += ' рабочий ' + oPatient:ExtendInfo:WorkPhone
			endif
			aadd( arr, s )
		endif
		if !empty( oPatient:ExtendInfo:CodeLgot )
			aadd( arr, inieditspr( A__MENUVERT, glob_katl, oPatient:ExtendInfo:CodeLgot ) )
		endif
	endif
	if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_MO )
		s := ''
		if is_talon .and. oPatient:ExtendInfo:Category > 0
			s := 'Код категории льготы: ' + rtrim( inieditspr( A__MENUVERT, stm_kategor, oPatient:ExtendInfo:Category ) ) + space( 5 )
		endif
		if !empty( stm_kategor2 ) .and. oPatient:ExtendInfo:Category2 > 0
			s += 'Категория МО: ' + rtrim( inieditspr( A__MENUVERT, stm_kategor2, oPatient:ExtendInfo:Category2 ) )
		endif
		aadd( arr, s )
	endif
	//
	for i := 1 to len( arr )
		if r1 + i - 1 > r2
			exit
		endif
		@ r1 + i - 1, 1 say arr[ i ] color color1
	next
	return nil

* 14.12.18 СМО на экран (печать)
function smo_to_screen_bay( ltip, obj )
	local s := '', s1 := '', lsmo, nsmo, lokato
	local oInogSMO

	&& lsmo := iif( ltip == 1, kart_->smo, human_->smo )
	lsmo := iif( ltip == 1, obj:ExtendInfo:SMO, human_->smo )
	nsmo := int( val( lsmo ) )
	s := inieditspr( A__MENUVERT, glob_arr_smo, nsmo )
	if empty( s ) .or. nsmo == 34
		if nsmo == 34
			if ltip == 1
				oInogSMO := TMo_kismoDB():getByPatient( obj )
			else
			endif
			&& s1 := ret_inogSMO_name( ltip, , .t. )
			s1 := oInogSMO:Name
		else
			&& s1 := init_ismo( lsmo )
			s1 := T_mo_smoDB():getBySMO( lsmo )
		endif
		if !empty( s1 )
			s := alltrim( s1 )
		endif
		&& lokato := iif( ltip == 1, kart_->KVARTAL_D, human_->okato )
		lokato := iif( ltip == 1, obj:ExtendInfo:KvartalHouse, human_->okato )
		if ! empty( lokato )
			s += '/' + inieditspr( A__MENUVERT, glob_array_srf(), lokato )
		endif
	endif
	return s