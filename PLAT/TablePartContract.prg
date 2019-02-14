* 13.11.18 viewServiceRow( oService ) - вывод информационной строки об услуге
* 13.11.18 editService( oPayService, aObjects, nKey, lPayment, oContract ) - редактирование услуги входящей в платной договор
* 12.11.18 editListServices( oBrowse, aObjects, oPayService, nKey, oContract ) - функция-обработчик нажатия клавиш в списке услуг
* 12.11.18 Services( obj ) - редактирование списка услуг платного договора
* 25.10.18 viewTotalSum( oContract ) - вывод информационной строки об общей сумме платного договора
* 12.06.17 getService( get, isAdult, treatment, aComplexService ) - получить информацию о выбранной услуге
* 15.06.17 validQuantity( get ) - проверка и пересчет общей суммы услуги
* 15.06.17 validTotal( get, iRow ) - проверка и отображения 'редактировалась' ли общая сумма усдуги

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'def_bay.ch'

* 12.11.18 редактирование списка услуг платного договора
function Services( obj )
	local flag := .f.
	local lPayment := obj:HasCheque
	local blkEditObject
	local aEdit
	local oBox, oBoxMessage, oBoxCheque, oBoxHeader
	local aProperties := {}
	
	private oContract := obj
	private pr_kod_vr := 0, pr_kod_as := 0, ;
		pr_med1 := 0, pr_med2 := 0, pr_med3 := 0, ;
		pr_san1 := 0, pr_san2 := 0, pr_san3 := 0
	// объекты для обработки
	private oDoctor := nil, oAssistant := nil
	private oNurse1 := nil, oNurse2 := nil, oNurse3 := nil
	private oAidman1 := nil, oAidman2 := nil, oAidman3 := nil

	blkEditObject := { | oBrowse, aObjects, object, nKey | editListServices( oBrowse, aObjects, object, nKey, oContract ) }
	aEdit := if( ! oContract:HasCheque .or. hb_user_curUser:IsAdmin(), { .t., .t., .t., .f. }, { .f., .f., .f., .f. } )
	
	str_sem := 'Список услуг ' + lstr( oContract:ID )
	if G_SLock( str_sem )
		// окно описания заголовка экрана услуг договора
		oBoxHeader := TBox():New( 0, 0, 0, maxcol(), .f. )
		oBoxHeader:Color := color0
		oBoxHeader:Frame := 0
		oBoxHeader:CaptionColor := col_tit_popup
		oBoxHeader:Caption := alltrim( 'Услуги по договору пациента < ' + alltrim( obj:Patient:FIO ) + ' >' )
		oBoxHeader:View()

		// окно вывода информации о пробитом чеке, что он есть
		oBoxCheque := TBox():New( 1, 0, 1, maxcol(), .f. )
		oBoxCheque:Frame := 0
		oBoxCheque:View()
		if lPayment
			@ 1, 0 say ' ОПЛАЧЕНО '	color 'G+*/B'
		endif

		// окно описания услуги и окно выдачи общей суммы договора
		oBoxMessage := TBox():New( maxrow() - 4, 0, maxrow() - 1, maxcol(), .f. )
		oBoxMessage:Frame := 0
		oBoxMessage:View()

		@ maxrow() - 3, 0 say '╒═══════════════════ Полное наименование услуги ═══════════════════╤══ Цена ═══╕'
		@ maxrow() - 2, 0 say '│                                                                  │           │'
		@ maxrow() - 1, 0 say '╘══════════════════════════════════════════════════════════════════╧═══════════╛'

		if mem_ordusl == 1
			aadd( aProperties, { 'Date_F', 'Дата ;услуг', 5 } )
		endif
		aadd( aProperties, { 'Service_F', '   Шифр;  услуги', 10 } )
		if mem_ordusl == 2	// дата оказания услуги
			aadd( aProperties, { 'Date_F', 'Дата ;услуг', 5 } )
		endif
		aadd( aProperties, { 'Subdivision_F', 'Отде-;ление', 5 } )
		aadd( aProperties, { 'Service_Name_F', '  Наименование;  услуги', 16 } )
		aadd( aProperties, { 'Doctor_F', 'Врач;    ', 4 } )
		aadd( aProperties, { 'Assistant_F', 'Асс.;    ', 4 } )
		aadd( aProperties, { 'Quantity_F', 'Кол.;   ', 3 } )
		aadd( aProperties, { 'Total_F', ' Итого  ;        ', 8 } )
		
		// просмотр и редактирование списка услуг договора пациента
		oBox := TBox():New( 2, 0, maxrow() - 5, 79, .f. )
		oBox:Caption := f_srok_lech( oContract:BeginTreatment, oContract:EndTreatment )
		oBox:CaptionColor := col_tit_popup
		oBox:Color := color1

		ListObjectsBrowse( 'TContractService', oBox, oContract:Services(), 1, aProperties, ;
										blkEditObject, aEdit, 'viewServiceRow', , 'W+/B,W+/RB,BG+/B,BG+/RB,G+/B,GR+/B' )

		oBox := nil
		oBoxCheque := nil
		oBoxMessage := nil
		oBoxHeader := nil
		TContractDB():Save( oContract )
		G_SUnLock( str_sem )
		flag := .t.
	else
		hb_Alert( err_slock, , , 4 )
	endif
	return flag

* 12.11.18 - функция-обработчик нажатия клавиш в списке услуг
function editListServices( oBrowse, aObjects, oPayService, nKey, oContract )
	local fl := .f.
	local lPayment := oContract:HasCheque

	lPayment := if( hb_user_curUser:IsAdmin, .f., lPayment )
	do case
		case ( nKey == K_INS .and. lPayment )
			hb_Alert( 'Пробит чек.' + chr( 10 ) + 'Добавление услуги невозможно!', , , 4 )
			fl := .f.
		case ( nKey == K_INS .and. ! lPayment ) .or. nKey == K_ENTER
			fl := editService( oPayService, aObjects, nKey, lPayment, oContract )
		case ( nKey == K_DEL .and. ! lPayment ) .or. ( nKey == K_DEL .and. hb_user_curUser:IsAdmin )
			TContractServiceDB():Delete( oPayService )
			AuditWrite( glob_task, OPER_USL, AUDIT_DEL, 1 )
			fl := .t.
		otherwise
			keyboard ''
	endcase
	return fl

* 13.11.18 - редактирование услуги входящей в платной договор
function editService( oPayService, aObjects, nKey, lPayment, oContract )
	local fl := .f.
	local r1 := 13			// начальная строка экрана ввода
	local x
	local lComplex := .f.	// комплексная услуга
	local pos_read := 0, k_read := 0, count_edit := 0

	local mDateService
	local oService := nil
	local aComplexService := {}
	local item := nil
	local oPatient := oContract:Patient
	local oTmp := nil
	local resultSave := -1
	
	local flagError := .f.
	local arrError := {}
	local oBox
	local oldDateService
	
	// объекты для обработки
	&& private oDoctor := nil, oAssistant := nil
	&& private oNurse1 := nil, oNurse2 := nil, oNurse3 := nil
	&& private oAidman1 := nil, oAidman2 := nil, oAidman3 := nil
	// поля ввода
	private mtabn_vr := 0, mvrach := space( 35 )
	private mtabn_as := 0, massist := space( 35 )
	private mdoctor, massistant, mNurse_1, mNurse_2, mNurse_3, mAidMan_1, mAidMan_2, mAidMan_3
	
	private mshifr := space( 10 ), mname_u := space( 65 ), mu_cena := 0.0, mQuantity := 0, mTotal := 0
	private mis_nul, mt_edit := 0

	// соберем все объекты
	if nKey == K_INS
		oTmp 		:= TService():New()
	else
		oTmp 		:= oPayService:Service
		
		oDoctor		:= oPayService:Doctor
		oAssistant	:= oPayService:Assistant
		oNurse1		:= oPayService:Nurse1
		oNurse2		:= oPayService:Nurse2
		oNurse3		:= oPayService:Nurse3
		oAidman1	:= oPayService:Aidman1
		oAidman2	:= oPayService:Aidman2
		oAidman3	:= oPayService:Aidman3
	endif
	&& oDoctor		:= oPayService:Doctor
	&& oAssistant	:= oPayService:Assistant
	&& oNurse1		:= oPayService:Nurse1
	&& oNurse2		:= oPayService:Nurse2
	&& oNurse3		:= oPayService:Nurse3
	&& oAidman1	:= oPayService:Aidman1
	&& oAidman2	:= oPayService:Aidman2
	&& oAidman3	:= oPayService:Aidman3
	// заполним необходимые поля ввода
	oldDateService := oPayService:Date
	if empty( oPayService:Date )
		oPayService:Date := oContract:BeginTreatment
	endif
	if ! isnil( oTmp )
		mshifr		:= padr( oTmp:Shifr, 10 )
		mname_u		:= padr( oTmp:Name, 65 )
	endif
	mu_cena		:= oPayService:Price
	mQuantity	:= oPayService:Quantity
	mTotal		:= oPayService:Total
	if ! isnil( oDoctor )
		mvrach	:= padr( oDoctor:ShortFIO, 35 )
		mtabn_vr	:= oDoctor:TabNom
	endif
	if ! isnil( oAssistant )
		massist	:= padr( oAssistant:ShortFIO, 35 )
		mtabn_as	:= oAssistant:TabNom
	endif
	mNurse_1	:= if( oNurse1 != nil, oNurse1:TabNom, 0 )
	mNurse_2	:= if( oNurse2 != nil, oNurse2:TabNom, 0 )
	mNurse_3	:= if( oNurse3 != nil, oNurse3:TabNom, 0 )
	mAidMan_1	:= if( oAidman1 != nil, oAidman1:TabNom, 0 )
	mAidMan_2	:= if( oAidman2 != nil, oAidman2:TabNom, 0 )
	mAidMan_3	:= if( oAidman3 != nil, oAidman3:TabNom, 0 )
	mt_edit		:= if( oPayService != nil .and. oPayService:IsEdit, 1, 0 )

	// начинаем с строки 11
	oBox := TBox():New( 11, 0, maxrow() - 1, maxcol(), .f. )
	oBox:Color := cDataCGet
	oBox:Caption := 'Услуга: ' + if( lPayment, 'просмотр', if( nKey == K_INS, 'добавление', 'редактирование' ) )
	oBox:CaptionColor := color8
	oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
	oBox:View()
		
	do while .t.
	
		pos_read := 0
		k_read := 0
		count_edit := 0
		
		@ r1, 2 say 'Дата оказания услуги' get oPayService:Date when ! lPayment
		@ ++r1, 2 say 'Шифр услуги' get mshifr pict '@!' ;
							valid { | g | getService( g, oPatient:IsAdult( oPayService:Date ), oContract, @aComplexService ) } ;
							when ! lPayment
		@ row(), 40 say 'Цена услуги' get mu_cena pict pict_cena when .f. color color14
		@ ++r1, 2 say 'Услуга' get mname_u when .f. color color14
		
		for x := 1 to 3
			if mem_por_vr == x
				@ ++r1, 2 say 'Таб.№ врача' get mtabn_vr pict '99999' ;
								valid { | g | validEmployer( g, 'врач', @oDoctor ) }
				@ row(), col() + 1 get mvrach color color14 when .f.
			endif
			if mem_por_ass == x
				@ ++r1, 2 say 'Таб.№ ассистента' get mtabn_as pict '99999' ;
								valid { | g | validEmployer( g, 'ассистент', @oAssistant ) }
				@ row(), col() + 1 get massist color color14 when .f.
			endif
			if mem_por_kol == x
				@ ++r1, 2 say 'Количество услуг' get mQuantity pict '999' ;
								valid { | g | validQuantity( g ) } ;
								when ! lPayment
			endif
		next
		@ ++r1, 2 say 'Общая стоимость услуги' get mTotal pict pict_cena ;
					valid {| g | validTotal( g, r1 ) } ;
					when { | g | ( mem_edit_s == 2 ) .and. ( len( aComplexService ) == 0 ) .and. !lPayment }
		if mt_edit > 1
			@ r1, 37 say '[ редактировалась стоимость услуги ]' color color13
		endif
		r1++
		if is_oplata != 7
			@ ++r1, 2 say 'Коды медсестер' get mNurse_1 pict '99999' ;
							valid { | g | validEmployer( g, 'медсестра', @oNurse1 ) }
			@ row(), col() say ',' get mNurse_2 pict '99999' ;
							valid { | g | validEmployer( g, 'медсестра', @oNurse2 ) }
			@ row(), col() say ',' get mNurse_3 pict '99999' ;
							valid { | g | validEmployer( g, 'медсестра', @oNurse3 ) }
			@ ++r1, 2 say 'Коды санитарок' get mAidMan_1 pict '99999' ;
							valid { | g | validEmployer( g, 'санитарка', @oAidman1 ) }
			@ row(), col() say ',' get mAidMan_2 pict '99999' ;
							valid { | g | validEmployer( g, 'санитарка', @oAidman2 ) }
			@ row(), col() say ',' get mAidMan_3 pict '99999' ;
							valid { | g | validEmployer( g, 'санитарка', @oAidman3 ) }
		endif
		&& myread()
		count_edit := myread( , @pos_read, ++k_read )
		if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
			// сначала проведем проверку что заполнены нужные поля
			arrError := {}
			aadd( arrError, 'Обнаружены следующие ошибки:' )
			flagError := .f.
			if empty( mshifr )
				flagError := .t.
				aadd( arrError, 'не выбран шифр услуги' )
			else
				if ( oService := TServiceDB():getByShifr( mshifr ) ) == nil
					if ( oService := TIntegratedServiceDB():getByShifr( mshifr ) ) == nil
						flagError := .t.
						aadd( arrError, 'услуга с указанным шифром найдена' )
					endif
				endif
			endif
			if mQuantity == 0
				flagError := .t.
				aadd( arrError, 'не заполнено поле количество услуг' )
			endif
			if oService:WithDoctor .and. mtabn_vr == 0
				flagError := .t.
				aadd( arrError, 'не выбран врач' )
			endif
			if !oService:WithDoctor .and. oService:WithAssistant .and. mtabn_as == 0
				flagError := .t.
				aadd( arrError, 'не выбран ассистент' )
			endif
			if flagError
				hb_Alert( arrError, , , 4 )
				loop
			endif
			if oService:classname == 'TSERVICE'
				oPayService:IDLU := oContract:ID
				oPayService:Coefficient := 1
				oPayService:Price := mu_cena
				oPayService:Quantity := mQuantity
				oPayService:Total := mTotal
				oPayService:Service := oService
				oPayService:IsEdit := ( mt_edit > 1 )
				oPayService:Subdivision := oContract:IDSubdivision
				
				oPayService:Doctor := oDoctor
				oPayService:Assistant := oAssistant
				oPayService:Nurse1 := oNurse1
				oPayService:Nurse2 := oNurse2
				oPayService:Nurse3 := oNurse3
				oPayService:Aidman1 := oAidman1
				oPayService:Aidman2 := oAidman2
				oPayService:Aidman3 := oAidman3
				resultSave := TContractServiceDB():Save( oPayService )
				fl := .t.
			elseif oService:classname == 'TINTEGRATEDSERVICE'
				mDateService := oPayService:Date
				for each item in oService:Services()
					if lComplex
						oPayService := TContractService():New()
					endif
					oPayService:IDLU := oContract:ID
					oPayService:Date := mDateService
					oPayService:Coefficient := 1
					oPayService:Price( item:Service:CalculatePrice( oPatient:IsAdult( oPayService:Date ) ) )
					oPayService:Quantity := mQuantity
					oPayService:Total := item:Service:CalculatePrice( oPatient:IsAdult( oPayService:Date ) ) * mQuantity
					oPayService:Service := item:Service
					oPayService:IsEdit := .f.
					oPayService:Subdivision := oContract:IDSubdivision
				
					oPayService:Doctor := oDoctor
					oPayService:Assistant := oAssistant
					oPayService:Nurse1 := oNurse1
					oPayService:Nurse2 := oNurse2
					oPayService:Nurse3 := oNurse3
					oPayService:Aidman1 := oAidman1
					oPayService:Aidman2 := oAidman2
					oPayService:Aidman3 := oAidman3
					TContractServiceDB():Save( oPayService )
					if lComplex
						aadd( aObjects, oPayService )
					endif
					lComplex := .t.
				next
				fl := .t.
			endif
			AuditWrite( glob_task, OPER_USL, iif( nKey == K_INS, AUDIT_INS, AUDIT_EDIT ), 1, count_edit )
			
		else
			oPayService:Date := oldDateService		// восстановим дату услуги
		endif
		exit
	enddo
	oBox := nil
	return fl

* 15.06.17 - проверка и отображения 'редактировалась' ли общая сумма усдуги
function validTotal( get, iRow )
	local fl := .t.
	local blk_sum := { | | mTotal := round_5( mu_cena * mQuantity, 2 ) }
	
	if !( round( mTotal, 2 ) == round_5( mu_cena * mQuantity, 2 ) )
		if mt_edit == 0
			mt_edit := 2
		elseif mt_edit == 1
			mt_edit := 3
		endif
		@ iRow, 37 say '[ редактировалась сумма для услуги ]' color color13
	endif
	return fl

* 15.06.17 - проверка и пересчет общей суммы услуги
function validQuantity( get )
	local fl := .t.
	local blk_sum := { | | mTotal := round_5( mu_cena * mQuantity, 2 ) }
	
	if mQuantity != get:original
		eval( blk_sum )
		update_gets()
	endif
	return fl

* 12.06.17 - получить информацию о выбранной услуге
function getService( get, isAdult, treatment, aComplexService )
*
* isAdult - логическая переменная показывающая .t. - взрослый, .f. - ребенок
* subdivision - код отделения
* aComplexService - массив содержащий список услуг для комплексной услуги
*
	local fl := .t.
	local oService := nil
	local item := nil
	local blk_sum := { | | mTotal := round_5( mu_cena * mQuantity, 2 ) }
	
	if !empty( mshifr ) .and. !( mshifr == get:original )
		mshifr := transform_shifr( mshifr )
		
		if ( oService := TServiceDB():getByShifr( mshifr ) ) != nil
			if ! oService:IsAllowedSubdivision( treatment:IDSubdivision )
				hb_Alert( 'Не допустимая услуга в выбранном подразделении!' )
				mshifr := ''
				return .f.
			endif
			
			mname_u := padr( oService:Name(), 65 )
			mis_nul := oService:AllowNullPaid()
			if mis_nul  // услуга с нулевой ценой
				mu_cena := 0 ; mt_edit := 1
			else
				// берем цену для платных услуг
				mu_cena := oService:CalculatePrice( isAdult, treatment:TypeService == PU_D_SMO )
				mRateNDS := oService:CalculateNDS( isAdult, treatment:TypeService == PU_D_SMO )
			endif
			mQuantity := 1
			eval( blk_sum )
			update_gets()
		elseif ( oService := TIntegratedServiceDB():getByShifr( mshifr ) ) != nil
			aComplexService := oService:Services()
			for each item in oService:Services()
				if empty( item:CalculatePrice( isAdult, treatment:TypeService == PU_D_SMO ) ) .and. !item:Service:AllowNullPaid()
					hb_Alert( 'Для услуги ' + alltrim( item:Shifr1() ) + ' входящей в комплексную услугу не указана цена!', , , 4 )
					fl := .f.
				else
					//&& if !Empty( item:Service():AllowSubdivision() ) .and. !( chr( treatment:Subdivision() ) $ item:Service():AllowSubdivision() )
						//&& hb_Alert( 'Услугу ' + alltrim( item:Shifr() ) + ' запрещено вводить в данном отделении!', , , 4 )
						//&& fl := .f.
					//&& endif
				endif
			next
			if fl .and. len( aComplexService ) > 0
				mname_u := oService:Name()
				mQuantity := 1
				mu_cena := oService:CalculatePrice( isAdult, treatment:TypeService == PU_D_SMO )
				eval( blk_sum )
				if !emptyall( oService:Doctor, oService:Assistant )
					mtabn_vr := if( oService:Doctor != nil, oService:Doctor:TabNom(), 0 )
					mvrach := padr( if( oService:Doctor != nil, oService:Doctor:ShortFIO, '' ), 35 )
					mtabn_as := if( oService:Assistant != nil, oService:Assistant:TabNom(), 0 )
					massist := padr( if( oService:Assistant != nil, oService:Assistant:ShortFIO, '' ), 35 )
				endif
				box_shadow( 6, 40, 8, 77, cColorStMsg, ;
						'Комплексная услуга', cColorSt2Msg )
				@ 7, 41 say padc( 'Количество услуг - ' + lstr( len( aComplexService ) ), 36 ) color cColorStMsg
				fl := update_gets()
			endif
		else
			hb_Alert( 'Услуга не с указанным шифром найдена', , , 4 )
			fl := .f.
		endif
	endif
	return fl

* 13.11.18 - вывод информационной строки об услуге
function viewServiceRow( oService )
	
	if ! isnil( oService ) .and. ! isnil( oService:Service )
		@ maxrow() - 2, 2 say oService:Service:Name color cDataCSay
		@ maxrow() - 2, 68 say oService:Service:CalculatePrice( oContract:Patient:IsAdult( oService:Date ), oContract:TypeService == PU_D_SMO )
	else
		@ maxrow() - 2, 2 say space( 65 )
		@ maxrow() - 2, 68 say space( 10 )
	endif
	oContract:Recount()
	@ maxrow() - 4, 50 say padl( 'Итого по договору: ' + lstr( oContract:Total, 11, 2 ), 30 ) //color 'W+/N'
	return nil
