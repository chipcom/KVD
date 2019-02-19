* 19.02.19 kart_plat()
* 19.02.19 editListContracts( oBrowse, aObjects, object, nKey ) - функция-обработчик нажатия клавиш в списке договоров
* 13.11.18 editContract( nKey, oContract ) - редактирование платного договора
* 10.11.18 valTypePaid( oGet, oldValue, oContract, oContractPayer, lPayment ) -
* 10.11.18 getOtherFieldsPaid( oContract, oContractPayer, lPayment ) - ввод оставшихся полей ввода договора
* 15.10.18 validDateThreatment( get, k ) проверка правильности ввода сроков лечения
* 09.06.17 validICD10( oGet ) - проверка ввода диагноза ( наличие в справочнике МКБ-10 )
* 08.06.17 layoutContracts( oBrowse, aList ) - формирование колонок для отображения списка договоров

#include 'hbthread.ch'
#include "getexit.ch"
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'
#include 'def_bay.ch'

#define BEGIN_THREATMENT	1
#define END_THREATMENT		2

* 19.02.19
function kart_plat()
	local str_sem
	local aContracts := {}
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	local blcCodeColor
	local oPatient
	
	clear_gets()	// очистим все поля ввода
	if polikl1_kart() > 0
		str_sem := 'ПУ Редактирование человека ' + lstr( glob_kartotek )
		if !G_SLock( str_sem )
			hb_Alert( err_slock, , , 4 )
			return .f.
		endif
	
		oPatient := TPatientDB():GetByID( glob_kartotek )
		aContracts := TContractDB():GetListByPatient( glob_kartotek, hb_user_curUser )
		
		blkEditObject := { | oBrowse, aObjects, object, nKey | editListContracts( oBrowse, aObjects, object, nKey, oPatient ) }
		blcCodeColor := { | | iif( empty( parr[ nInd ]:DatePay ), { 5, 6 }, iif( parr[ nInd ]:Total > 0, { 1, 2 }, { 3, 4 } ) ) }
		aEdit := { .t., .t., .t., .f. }
		
		aProperties := { { 'DepartmentShort', 'Уч-ние', 5, blcCodeColor }, ;
						{ 'TotalBank_F', ' ', 1, blcCodeColor }, ;
						{ 'FillColumnCheque', 'N чек', 5, blcCodeColor }, ;
						{ 'BeginTreatment', 'Начало ;лечения', 10, blcCodeColor }, ;
						{ 'EndTreatment', 'Окончание; лечения ', 10, blcCodeColor } ;
						}
		if mem_naprvr == 2	// отображать табельный номер направившенго врача
			aadd( aProperties, { 'SendDoctorTabNom', 'Напр.;врач', 5, blcCodeColor } )
		endif
		aadd( aProperties, { 'Total_F', 'Стоимость; лечения ', 8, blcCodeColor } )
		aadd( aProperties, { 'BackMoney_F', 'Возврат; денег ', 8, blcCodeColor } )
		aadd( aProperties, { 'DateCloseLU', '  Дата  ;закрытия', 10, blcCodeColor } )
		
		// просмотр и редактирование списка договоров пациента
		oBox := TBox():New( 8, 0, maxrow() - 2, 79, .t. )
		oBox:Caption := 'Список договоров пациента < ' + alltrim( oPatient:FIO() ) + ' >'
		oBox:CaptionColor := col_tit_popup
		oBox:Color := color0
		if ! getDrvFR():IsFiscalReg
			oBox:MessageLine := { '^<Ctrl+Enter>^-список услуг ^<F9>^-договор ^<F5>^-справка в ФНС', ;
						'^<Esc>^-выход ^<Ins>^-вставка ^<Del>^-удаление ^<Enter>^-редакт.' }
		else
			&& oBox:MessageLine := { '^<Ctrl+Enter>^-услуги ^<F8>^-возврат ^<F9>^-договор ^<F10>^-чек ^<F7>^-копия чека', ;
			oBox:MessageLine := { '^<Ctrl+Enter>^-услуги ^<F8>^-возврат ^<F9>^-договор ^<F10>^-чек ^<F5>^-справка в ФНС', ;
								'^<Esc>^-выход ^<Ins>^-вставка ^<Del>^-удаление ^<Enter>^-редакт.' }
		endif
		
		ListObjectsBrowse( 'TContract', oBox, aContracts, 1, aProperties, ;
											blkEditObject, aEdit, , , 'N/BG, W+/N, B/BG, BG+/B, GR/BG, BG+/GR' )
		G_SUnLock( str_sem )
	endif
	return nil

* 19.02.19 функция-обработчик нажатия клавиш в списке договоров
function editListContracts( oBrowse, aObjects, oContract, nKey, oPatient )
	local fl := .f.
	local err_close := 'Данный лист учета ЗАКРЫТ. Доступ разрешен только администратору системы!'
	
	do case
		case nKey == K_INS .or. ( nKey == K_ENTER .and. oContract:Patient != nil )
			if nKey == K_ENTER .and. !empty( oContract:DateCloseLU ) .and. !hb_user_curUser:IsAdmin()
				hb_Alert( err_close, , , 4 )
				return .f.
			endif
			if nKey == K_INS
				colorwin( 7, 0, 7, 79, 'N/N', 'W+/N' )
				colorwin( 7, 0, 7, 79, 'N/N', 'BG+/B' )
			endif
			if oContract:IsNew
				oContract:Patient := oPatient
				oContract:BeginTreatment := date()
				oContract:EndTreatment := date()
				oContract:TypeService := PU_PLAT
			endif
			fl := editContract( nKey, oContract )
		case nKey == K_CTRL_RET .and. oContract:Patient != nil
			if !empty( oContract:DateCloseLU ) .and. !hb_user_curUser:IsAdmin()
				hb_Alert( err_close, , , 4 )
				return .f.
			endif
			fl := Services( oContract )
		case nKey == K_F5 	// печать справки для ФНС
			fl := printReferenceToFTS( oPatient, aObjects )
		&& case nKey == K_F7 	// печать копии чека продажи
			&& fl := printCopyReceipt( oContract )
		case nKey == K_F10 .or. nKey == K_F8 .or. nKey == K_CTRL_F10 .or. nKey == K_CTRL_F8	// печать чека продажи или возврата
			fl := printReceipt( oContract, nKey )
		case nKey == K_F9				// печать договора
			if empty( oContract:Services() )
				hb_Alert( 'В договоре отсутствуют услуги. Печать договора не возможна!', , , 4 )
			else
				fl := printContract( oContract )
			endif
		case nKey == K_DEL
			if oContract:HasCheque					// имеется пробитый чек
				hb_Alert( 'Пробит чек.' + chr( 10 ) + 'Удаление невозможно!', , , 4 )
			else
				oContract:deleteAllServices()
				TContractDB():Delete( oContract )
				AuditWrite( glob_task, OPER_LIST, AUDIT_DEL, 1 )
				fl := .t.
			endif
		otherwise
			keyboard ''
	endcase
	return fl

* 13.11.18 - редактирование платного договора
function editContract( nKey, oContract )
	local k, pos_read := 0, k_read := 0, count_edit := 0
	local ret := .f.
	local oContractPayer := nil
	local lPayment := if( isnil( oContract ) , .f., oContract:HasCheque )
		
	private r1 := 12
	private mm_da_net := { { 'да ', 1 }, { 'нет', 2 } }
	
	r1 := r1 - if( mem_plsoput == 2, 1, 0 )
	r1 := r1 - if( mem_naprvr == 2, 1, 0 )
	private oDoctor	:= nil, ;				// направивший врач
		mlpu        := glob_uch[ 2 ], ;		// наименование учреждения
		m1lpu       := glob_uch[ 1 ], ;		// код учреждения
		motd        := glob_otd[ 2 ], ;		// наименование отделения
		m1otd       := glob_otd[ 1 ], ;		// код отделения
		mtabn_vr := 0, mvrach := space( 35 ), ;
		mtip_usl, m1tip_usl := 0, ;
		mpr_smo := space( 20 ), m1pr_smo := 0
		
	private mMyself, m1Myself := 1				// плательщик сам или нет
	
	lPayment := if( hb_user_curUser:IsAdmin, .f., lPayment )
	m1lpu       := oContract:IDDepartment		// код учреждения
	m1otd       := oContract:IDSubdivision		// код отделения
	oDoctor		:= oContract:SendDoctor
	m1tip_usl   := oContract:TypeService
	if m1tip_usl != PU_PLAT
		m1pr_smo := oContract:IdExternalOrg
	endif
	if oDoctor != nil
		mvrach := padr( oDoctor:ShortFIO, 35 )
		mtabn_vr := oDoctor:TabNom
	endif
	
	m1Myself := if( empty( oContract:PayerFIO ), 1, 2 )
	mMyself := inieditspr(A__MENUVERT, mm_da_net, m1Myself)
	
	mtip_usl := inieditspr( A__MENUVERT, menu_kb, m1tip_usl )
	mlpu := inieditspr( A__MENUVERT, TDepartmentDB():MenuDepartments(), m1lpu )
	motd := inieditspr( A__MENUVERT, TSubdivisionDB():MenuSubdivisions( m1lpu ), m1otd )

	if m1tip_usl == PU_D_SMO
		mpr_smo := inieditspr( A__MENUVERT, TCompanyDMSDB():MenuCompanies(), m1pr_smo )
	elseif m1tip_usl == PU_PR_VZ
		mpr_smo := inieditspr( A__MENUVERT, TCompanyVzaimDB():MenuCompanies(), m1pr_smo )
	endif
	
	oBox := TBox():New( r1, 0, maxrow() - 1, maxcol(), .t. )
	oBox:Caption := 'Договор на оказание услуг пациенту: ' + if( lPayment, 'просмотр', if( nKey == K_INS, 'добавление', 'редактирование' ) )
	oBox:CaptionColor := color8
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - выход;  ^<PgDn>^ - запись'
	oBox:View()
	
	ShowDiagnosis( 0 )
	*
	do while .t.
		oContractPayer := TContractPayer():New()
		if ( m1tip_usl == PU_PLAT ) .and. ( m1Myself == 2 )	// оплата наличными и плательщик не пациент
			if ( oContractPayer := TContractPayerDB():GetByIdLU( oContract:ID ) ) == nil
				oContractPayer := TContractPayer():New()
			endif
		elseif ( m1tip_usl == PU_D_SMO ) .or. ( m1tip_usl == PU_PR_VZ )	// плательщик внешняя организация
			m1pr_smo := oContract:IdExternalOrg
		endif
		
		@ r1 + 1, 1 clear to maxrow() - 2, maxcol() - 1
		@ r1 + 2, 2 say 'ЛПУ' get mlpu ;
			reader { | x | menu_reader( x, { { | k, r, c | fillGetFieldDepAndSub( k, r, c, date(), , X_PLATN ) } }, ;
			A__FUNCTION, , , .f. ) } when !lPayment
		@ r1 + 2, 37 say 'Отделение' get motd  when !lPayment
		@ r1 + 3, 2 say 'Способ оплаты' get mtip_usl ;
           reader { | x | menu_reader( x, menu_kb, A__MENUVERT, , , .f. ) } ;
            valid {| oGet, oldValue | valTypePaid( oGet, oldValue, oContract, oContractPayer, lPayment ) } ;
            when !lPayment
			
		getOtherFieldsPaid( oContract, oContractPayer, lPayment )  // остальные Get'ы
		
		if nKey == K_ENTER .and. !ver_pub_date( oContract:EndTreatment, .t. )
			keyboard chr( K_ESC )
		endif
		count_edit := myread( , @pos_read, ++k_read )
		if lastkey() != K_ESC
			err_date_diap( oContract:BeginTreatment, 'Дата начала лечения' )
			err_date_diap( oContract:EndTreatment, 'Дата окончания лечения' )
			if f_Esc_Enter( 1 )
				if m1lpu == 0
					hb_Alert( 'Не выбрано лечебное учреждение!', , , 4 )
					loop
				endif
				if m1otd == 0
					hb_Alert( 'Не выбрано отделение!', , , 4 )
					loop
				endif
				if empty( oContract:EndTreatment )
					hb_Alert( 'Не введена дата окончания лечения.', , , 4 )
					loop
				endif
				mywait()
				if nKey == K_INS
					if m1tip_usl == PU_PLAT .and. getDrvFR():IsFiscalReg  // если не взаимозачет
						oContract:IsCashbox := 2
					endif
				endif
				oContract:Department := m1lpu			// код учреждения
				oContract:Subdivision := m1otd			// код отделения
				oContract:SendDoctor := oDoctor
				oContract:TypeService := m1tip_usl
				if m1tip_usl == PU_PLAT
					oContract:IdExternalOrg := 0
					if m1Myself == 1
						oContract:PayerFIO := space( 40 )
						oContract:PayerINN := space( 12 )
					endif
				else
					if m1pr_smo != -1
						oContract:IdExternalOrg := m1pr_smo
					endif
					oContract:IsCashbox := 0
				endif
				if ( ret := ( TContractDB():Save( oContract ) != -1 ) )
					if m1Myself == 2 .and. ( ! empty( oContractPayer:Address ) .or. ! empty( oContractPayer:Passport ) )
						if oContractPayer:IsNew
							oContractPayer:IDLU := oContract:ID
						endif
						TContractPayerDB():Save( oContractPayer )
					else
						if ( oContractPayer := TContractPayerDB():GetByIdLU( oContract:ID() ) ) != nil
							TContractPayerDB():Delete( oContractPayer )
						endif
					endif
					AuditWrite( glob_task, OPER_LIST, iif( nKey == K_INS, AUDIT_INS, AUDIT_EDIT ), 1, count_edit )
				endif
			endif
		endif
		exit
	enddo
	ShowDiagnosis( 2 )
	return ret

* 10.11.18 ввод оставшихся полей ввода договора
function getOtherFieldsPaid( oContract, oContractPayer, lPayment )  // остальные Get'ы
	local j := row() + 1,  pic_diag := '@K@!'
	local bKeyBlock := { | oGet, nKey | transform_mkb10( oGet, nKey ) }

	asize( GetList, 3 )   // берем первые 3 элемента
	@ j, 37 clear to j, maxcol() - 1
	if m1tip_usl == PU_D_SMO .or. m1tip_usl == PU_PR_VZ
		if m1tip_usl == PU_D_SMO
			@ --j, 37 say '    '
			@ j, 37 say 'СМО' get mpr_smo reader ;
				{ | x | menu_reader( x, TCompanyDMSDB():MenuCompanies(), A__MENUVERT, , , .f. ) } when !lPayment
		elseif m1tip_usl == PU_PR_VZ
			@ --j, 37 say 'Предприятие' get mpr_smo reader ;
				{ | x | menu_reader( x, TCompanyVzaimDB():MenuCompanies(), A__MENUVERT, , , .f. ) } when !lPayment
		endif
	elseif m1tip_usl == PU_PLAT
		@ --j, 37 say space( 40 )
		@ j,  37 SAY 'Плательщик, он же:'
		@ j, col() say '' get mMyself reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) } ;
			valid checkMyself() when !lPayment
	endif
	@ j + 1, 1 clear to maxrow() - 2, maxcol() - 1
	
	@ ++j, 2 say 'Шифр основного заболевания' get oContract:MainDiagnosis ;
			picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } valid { |oGet| validICD10( oGet ) } ;
			when ShowDiagnosis( 2 ) .and. when_diag()
	if mem_plsoput == 2
		++j
		@ j, 2 say 'Шифры сопуствующих заболеваний' get oContract:Diagnosis1 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis2 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis3 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis4 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis5 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
	endif
	if mem_naprvr == 2
		@ ++j, 2 say 'Таб.№ направившего врача' get mtabn_vr pict '99999' valid { | g | validEmployer( g, 'врач', @oDoctor ) }
		@ row(), col() + 1 get mvrach  when .f. color color14
	endif
	@ ++j, 2 say 'Начало лечения' get oContract:BeginTreatment valid { | oGet | validDateThreatment( oGet, BEGIN_THREATMENT, oContract:EndTreatment, oContract:Patient:DOB ) } when !lPayment
	@ row(), col() + 2 say 'Окончание лечения' get oContract:EndTreatment valid { | oGet | validDateThreatment( oGet, END_THREATMENT, oContract:BeginTreatment, oContract:Patient:DOB ) } when !lPayment
	if empty( oContract:DatePay )
		@ j, 60 say 'ДОГОВОР НЕОПЛАЧЕН' color 'GR+/R,,,,B/W'
	else
		@ j, 60 say 'Оплата'
		@ j, col() + 1 get oContract:DatePay when .f.
	endif
	if m1tip_usl == PU_D_SMO .or. m1tip_usl == PU_PR_VZ
		@ ++j, 0 say '╟' + replicate( '─', 78 ) + '╢'
		++j
		@ j, 2 say 'Полис' get oContract:PolisSMO picture '@!@S20'
		@ j, col() + 1 say 'Гарантийное письмо №' get oContract:LetterSMO picture '@!@S14' when !lPayment
		@ j, col() + 1 say 'от' get oContract:DateLetterSMO when !lPayment
		++j
		@ j, 29 say 'Гарантийное письмо №' get oContract:LetterSMO2 picture '@!@S14' when !lPayment
		@ j, col() + 1 say 'от' get oContract:DateLetterSMO2 when !lPayment
		@ ++j, 0 say '╟' + replicate( '─', 78 ) + '╢'
	elseif m1tip_usl == PU_PLAT
		// информация о плательщике
		@ ++j, 0 say '╟' + replicate( '─', 78 ) + '╢'
		@ ++j, 2 say 'Плательщик: ФИО' get oContract:PayerFIO pict '@!@S30' ;
					valid controlPayer( PU_PLAT, oContract:PayerFIO ) when m1Myself == 2
		@ j, col() say ', ИНН' get oContract:PayerINN picture '999999999999' ;
					when m1Myself == 2
		@ ++j, 2 say 'Адрес' get oContractPayer:Address pict '@!@S45' ;
					when m1Myself == 2
		@ j, col() say ', № док.' get oContractPayer:Passport  pict '@!@S15' ;
					when m1Myself == 2
		@ ++j, 0 say '╟' + replicate( '─', 78 ) + '╢'
	endif
	@ ++j, 50 say 'Стоимость лечения ' + lstr( oContract:Total, 11, 2 ) color 'GR+/B'
	return nil

* 10.11.18
function valTypePaid( oGet, oldValue, oContract, oContractPayer, lPayment )
	local fl := .t.
	
	if oldValue != nil .and. oldValue != m1tip_usl
		if m1tip_usl == PU_PLAT
			oContract:IsCashbox := 2
		else
			oContract:IsCashbox := 0
		endif
		m1pr_smo := 0 ; mpr_smo := space( 25 )
		oContract:PolisSMO := space( 25 )
		oContract:LetterSMO := space( 16 )
		oContract:DateLetterSMO := ctod( '' )
		oContract:LetterSMO2 := space( 16 )
		oContract:DateLetterSMO2 := ctod( '' )
		getOtherFieldsPaid( oContract, oContractPayer, lPayment )
	endif
	return fl

* 09.06.17 проверка ввода диагноза ( наличие в справочнике МКБ-10 )
function validICD10( oGet )
	local fl := .t., mshifr, c_plus := ' ', i, ;
		m1, s, mshifr6
	local oICD10 := nil, toICD10 := nil

	mshifr := alltrim( oGet:buffer )
	mshifr6 := padr( mshifr, 6 )
	mshifr := padr( mshifr, 5 )
	if empty( mshifr )
		ShowDiagnosis( 2 )
	else
		mshifr := mshifr6
		if ( oICD10 := TICD10DB():GetByShifr( mshifr ) ) != nil
			if mem_diag4 == 2 .and. !( '.' $ mshifr ) // если шифр трехзначный
				m1 := alltrim( mshifr ) + '.'
				// теперь проверим на наличие любого четырехзначного шифра
				if ( toICD10 := TICD10DB():GetByShifr( m1 ) ) != nil
					s := ''
					for i := 0 to 9
						if ( toICD10 := TICD10DB():GetByShifr( m1 + str( i, 1 ) ) ) != nil
							s += alltrim( toICD10:Shifr ) + ','
						endif
					next
					s := substr( s, 1, len( s ) - 1 )
					oGet:varPut( padr( m1, 5 ) + c_plus )
					hb_Alert( 'Доступные шифры: ' + s, , , 4 )
					fl := .f.
				endif
			endif
		else
			if '.' $ mshifr  // если шифр четырехзначный
				m1 := beforatnum( '.', mshifr )
				// сначала проверим на наличие трехзначного шифра
				if ( toICD10 := TICD10DB():GetByShifr( m1 ) ) != nil
					// теперь проверим на наличие любого четырехзначного шифра
					if ( toICD10 := TICD10DB():GetByShifr( m1 + '.' ) ) != nil
						s := ''
						for i := 0 to 9
							if ( toICD10 := TICD10DB():GetByShifr( m1 + '.' + str( i, 1 ) ) ) != nil
								s += alltrim( toICD10:Shifr ) + ','
							endif
						next
						s := substr( s, 1, len( s ) - 1 )
						oGet:varPut( padr( m1 + '.', 5 ) + c_plus )
						hb_Alert( 'Доступные шифры: ' + s, , , 4 )
						fl := .f.
					else
						oGet:varPut( padr( m1, 5 ) + c_plus )
						hb_Alert( 'Данный диагноз присутствует только в виде ТРЕХзначного шифра!', , , 4 )
						fl := .f.
					endif
				endif
			endif
			if fl
				oGet:varPut( space( 5 ) )
				hb_Alert( 'Диагноз с шифром: ' + alltrim( mshifr ) + ' не найден!', , , 4 )
				fl := .f.
			endif
		endif
	endif
	if fl
		if right( mshifr6, 1 ) != ' '
			oGet:varPut( mshifr6 )
		else
			oGet:varPut( padr( mshifr, 5 ) + c_plus )
		endif
	endif
	return fl

* 15.10.18 проверка правильности ввода сроков лечения
function validDateThreatment( oGet, typeDate, dateField, DOB )
// typeDate = 1 - дата начала лечения
// typeDate = 2 - дата окончания лечения

	// временно
	if ( typeDate == BEGIN_THREATMENT )
		if empty( ctod( oGet:buffer ) )
			return func_error( 4, 'Ошибка! Не введена дата начала лечения.' )
		endif
		if ( DOB >= ctod( oGet:buffer ) )
			return func_error( 4, 'Ошибка! Дата начала лечения раньше даты рождения пациента.' )
		endif
		if ! empty( ctod( oGet:buffer ) ) .and. ( ctod( oGet:buffer ) > dateField )
			dateField := oGet:original
			return func_error( 4, 'Ошибка! Дата начала лечения больше даты окончания лечения.' )
		endif
	endif
	if ( typeDate == END_THREATMENT )
		if empty( ctod( oGet:buffer ) )
			oGet:buffer := oGet:original
			return func_error( 4, 'Ошибка! Не введена дата окончания лечения.' )
		endif
		if ! ( year( dateField ) == year( sys_date ) .or. year( dateField ) == year( sys_date ) - 1 )
			dateField := oGet:original
			return func_error( 4, 'Ошибка! В дате окончания лечения неверно введен год.' )
		endif
		if ! empty( ctod( oGet:buffer ) ) .and. ( ctod( oGet:buffer ) < dateField )
			dateField := oGet:original
			return func_error( 4, 'Ошибка! Дата начала лечения больше даты окончания лечения.' )
		endif
	endif
	return .t.

***** меняет русские буквы на латинские при вводе диагноза
function transform_mkb10( oGet, nKey, fl_F7 )
	local cKey
	
	if between( nKey, 32, 255 )
		cKey := CHR( nKey )
		************** найти ЛАТ букву, стоящую на клавиатуре там же, где и РУС
		if oGet:pos < 4  // курсор в начале
			cKey := kb_rus_lat( ckey )  // если русская буква
		endif
		if cKey == ","
			cKey := "." // замениь запятую на точку (цифровая клавиатура под Windows)
		endif
		**************
		if ( SET( _SET_INSERT ) )
			oGet:insert( cKey )
		else
			oGet:overstrike( cKey )
		endif
		if ( oGet:typeOut )
			if ( SET( _SET_BELL ) )
				?? CHR(7)
			endif
			if ( !SET( _SET_CONFIRM ) )
				oGet:exitState := GE_ENTER
			endif
		endif
	endif
	return nil