* PaidServices.prg - подсистема работа с платными услугами
*******************************************************************************
// 19.02.19 printReferenceToFTS( oPatient, aObjects ) - печать справки для налоговой службы
* 13.11.18 printReceipt( oContract, nKey ) - печать чека на ККТ
* 13.11.18 printContract( oContract ) - печать договора
* 13.11.18 printCopyReceipt( oContract ) - печать копии чека, если есть
* 05.11.18 controlPayer( nType, cName )
* 15.06.17 begin_task_plat() - инициализация платных услуг
* 24.06.17 checkMyself() - проверим плательщика сам платит ( очистим поля ввода ), или нет
* 26.06.17 f_usl_date() - ф-ция пустышка для совместимости
* 27.06.17 TransformPhone( address ) - преобразование телефонного номера в нормальный формат для ОФД
* 03.11.17 IncomeCashBayerPay( oCheck, nStartRow, cBorderColor, cBoxColor ) - вывод сообщения о полученных денежных средствах	
* 03.11.17 RecalcCheck( get, oCheck, lBank ) - пересчет полей ввода о платеже
* 27.06.17 ControlAddress( get, address ) - проверка адреса или телефона на допустимость для ОФД
* 27.06.17 BankGet( oCheck, buf, sizeFrame, sizeFrameBank ) - формирование полей для ввода банковских платежей
* 27.06.17 controlSizeBox( g, old, oCheck, sizeFrame, sizeFrameBank, buf ) - управление размером области для ввода банковских платежей
* 03.11.17 yes_chek( oCheck, rm ) - запрос на ввод информации о платеже в чеке
*******************************************************************************

#include 'set.ch'
#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

static emailTemplate := '^[-._a-z0-9]+@(?:[a-z0-9][-a-z0-9]+\.)+[a-z]{2,6}$'
static phoneTemplate := '^(\s*)?(\+)?([- _():=+]?\d[- _():=+]?){10,14}(\s*)?$'

* 15.06.17 - инициализация платных услуг
function begin_task_plat()
	static n_zapusk := 0
	local ret := .t.

	loadVariableKKT()
	// инициализируем драйвер
	InitDriverFR()
	if n_zapusk == 0
		++n_zapusk
		public menu_kb := { { 'платный', PU_PLAT }, ;
							{ 'ДМС    ', PU_D_SMO }, ;
							{ 'в/зачет', PU_PR_VZ } }
		public count_otd := 1
		public count_uch := 1
		public gmenu_kateg := TEmployee():aMenuCategory
	endif
	if copy_Tools_Ini()
		Tools_Ini_OMS( 1, 0, 0 )
		Tools_Ini_Platn( 1, 0, 0 )
	else
		ret := .f.
	endif
	return ret

function fillColumnCheque( obj )
	local ret := '     '
	
	if obj != nil
		if( obj:TypeService == PU_PLAT )
			ret := { '     ', str( obj:ReceiptNumber, 5 ), '' }[ obj:IsCashbox + 1 ]
		elseif( obj:TypeService == PU_PR_VZ )
			ret := 'в/з '
		elseif( obj:TypeService == PU_D_SMO )
			ret := 'д/с '
		endif
	endif
	return ret
	
* 07.06.17 **** вернуть учреждение и отделение в GET'е
function fillGetFieldDepAndSub( k, r, c, date1, date2, nTask )
	local ret, n := 1, oDepartment := nil
	
	if k != nil .and. k > 0
		glob_uch[ 1 ] := k
	endif
	if ( oDepartment := SelectDepartment( r, c, date1, date2 ) ) != nil
		if type( 'm1otd' ) == 'N' .and. m1otd > 0
			glob_otd[ 1 ] := m1otd
		endif
		if SelectSubdivision( r, c, oDepartment, date1, date2, nTask ) != nil
			if valtype( motd ) == 'C'
				n := len( motd )
			endif
			m1otd := glob_otd[ 1 ] ; motd := alltrim( glob_otd[ 2 ] )
			if len( motd ) < n
				motd := padr( motd, n )
			endif
			ret := glob_uch
		endif
	endif
	return ret

// 19.02.19 - печать справки для налоговой службы
// function printReferenceToFTS( oPatient, aContracts )
	
// 	private mPatient := oPatient
// 	private mContracts := aContracts
// 	print_shablon( alltrim( dir_exe() + 'ReferenceToFTS.shb' ) )
// 	return nil

* 13.11.18 - печать договора
function printContract( oContract )
	local oPatient := nil, oPatientExt := nil
	local oContractPayer := nil
	local buf
	
	private moContract := oContract
	private m1vid_ud, mnom, mser, mvid_ud
	private mplat_adres  := space( 50 ),; 			// адрес плательщика
			mplat_pasport := space( 15 )  		// документ плательщика
	private lnomer, l1nomer, muchastok
	//
	buf := savescreen()
	ClrLine( 23, color0 )
	oPatient := moContract:Patient
	//01.12.08 начало
	lnomer := l1nomer := oPatient:ID()
	muchastok := put_val( oPatient:District(), 2 )
	luchast := ''
	if is_uchastok == 1
		if !emptyall( oPatient:Bukva(), oPatient:District(), oPatient:Kod_VU() )
			lnomer := '' + iif( !empty( oPatient:Bukva() ), oPatient:Bukva(), '' ) + lstr( oPatient:District(), 2 ) + iif( oPatient:Kod_VU() > 0, '/' + lstr( oPatient:Kod_VU() ), '' )
			l1nomer := lnomer
		endif
	elseif eq_any( is_uchastok, 2, 3 )
		if !emptyall( oPatient:Bukva(), oPatient:District() )
			luchast := ' [уч-к ' + iif( !empty( oPatient:Bukva() ), oPatient:Bukva(), '' ) + lstr( oPatient:District(), 2 ) + '] '
		endif
		if is_uchastok == 3
			if oPatient:AddInfo() != nil
				luchast += alltrim( oPatient:AddInfo():AmbulatoryCard )
			endif
		endif
	endif
	lnomer := expand( lnomer ) + luchast
	if ( oPatientExt := TPatientExtDB():getByID( oPatient:ID() ) ) != nil
		m1vid_ud := oPatientExt:Passport:DocumentType	//TypeDocument()
		mnom     := oPatientExt:Passport:DocumentNumber	//DocumentNumber()
		mser     := oPatientExt:Passport:DocumentSeries	//SeriesOfDocument()
		mvid_ud := ''
		// if ( j := ascan( menu_vidud, { | x | x[ 2 ] == m1vid_ud } ) ) > 0
		// mvid_ud := menu_vidud[ j, 4 ]
		if ( j := ascan( get_Name_Vid_Ud(), { | x | x[ 2 ] == m1vid_ud } ) ) > 0
			mvid_ud := get_Name_Vid_Ud()[ j, 4 ]
		endif
	else
		m1vid_ud := 0
		mvid_ud := ''
		mnom     := ''
		mser     := ''
	endif
	if ( oContractPayer := TContractPayerDB():GetByIdLU( oContract:ID() ) ) != nil
		mplat_adres   := oContractPayer:Address
		mplat_pasport := oContractPayer:Passport
	else
		mplat_adres   := ''
		mplat_pasport := ''
	endif
	if len( alltrim( mem_dogovor ) ) > 3
		print_shablon( alltrim( mem_dogovor ) )
	else
		private file_sh
		if !empty( alltrim( mem_dogovor ) ) .and. ;
				!empty( file_sh := menu_shablon( 3, 3, dir_exe() + '*.' + upper( alltrim( mem_dogovor ) ), ;
					color8, .f. ) )
			f1_pr_shab( file_sh )
		endif
	endif
	flag := 0
	restscreen( buf )
	return .t.

* 05.11.18	
function controlPayer( nType, cName )
	local lst, iRet, mtitle, nPos := 0
	local aProperties
	local oBox
	local oPayer
	
	&& hb_Default( @nType, 0 )
	&& mtitle := "Найденные плательщики"
	&& lst := TPayer():GetListByName( nType, cName )
	&& if len( lst ) > 0
		&& aProperties := { { 'FIO', 'Ф.И.О.', 49 } }
		&& oBox := TBox():New( T_ROW, 2, T_ROW + 10, 78, .t. )
		&& oBox:Color := color5
		&& oBox:Caption := mtitle
		&& oBox:CaptionColor := col_tit_popup
		&& oPayer := ListObjectsBrowse( 'TPayer', oBox, lst, 1, aProperties, , , , , , .t. )
		&& if ! isnil( oPayer )
			&& mplat_fio := oPayer:FIO()
			&& mplat_inn := oPayer:INN()
			&& mplat_adres := oPayer:Adress()
			&& mplat_pasport := oPayer:Passport()
			&& update_gets()
		&& endif
	&& endif
	return .t.

* 24.06.17 - проверим плательщика сам платит ( очистим поля ввода ), или нет
function checkMyself()

	if m1Myself == 1
		mplat_fio := space( 40 )
		mplat_inn := space( 12 )
		mplat_adres := space( 50 )			// адрес плательщика
		mplat_pasport := space( 15 )				// документ плательщика
	endif
	return .t.

* 03.11.17 - запрос на ввод информации о платеже в чеке
function yes_chek( oCheck, rm )
	local bufFull := savescreen()
	local j, fl := .f., tmp_color, buf, buf24, r := 16
	local sizeFrame := 0, sizeFrameBank := 0

	private paymentType2 := 0
	private paymentType3 := 0, paymentType4 := 0
	private maddress := space( 25 )
	private mm_da_net := { { 'да ', 1 }, { 'нет', 2 } }
	private mBank, m1Bank := 2				// есть ли платеж по карте
	private vnos_summa := oCheck:Total
	
	mBank := inieditspr( A__MENUVERT, mm_da_net, m1Bank )
	tmp_color := setcolor( cDataCGet )
	buf24 := save_row( maxrow() )
	do while .t.
		do while .t.
			r := 16
			sizeFrame := 0
			sizeFrameBank := 0
			// проверим, если нет лишних запросов, выходим из цикла
			if !getDrvFR():OtherTypePay() .and. !getDrvFR():Change
				fl := f_Esc_Enter( 'печати ЧЕКА' )
				exit
			endif
			sizeFrame := 1 + iif( getDrvFR():Change , 1, 0 ) + iif( getDrvFR():IsFiscalReg(), 1, 0 ) // при наличии запроса сдачи и присутствие ФН
			if getDrvFR():OtherTypePay()
				sizeFrame := ++sizeFrame			// для вопроса о банке
				if m1Bank == 1						// есть банк и он выбран
					sizeFrameBank := sizeFrame + iif( getDrvFR():EnableTypePay2, 1, 0 ) + ;	// на 2 вид оплаты
										iif( getDrvFR():EnableTypePay3, 1, 0 ) + ;	// на 3 вид оплаты
										iif( getDrvFR():EnableTypePay4, 1, 0 )		// на 4 вид оплаты
					buf := box_shadow( r, 5, r + sizeFrameBank, 74 )
				else
					buf := box_shadow( r, 5, r + sizeFrame, 74 )
				endif
			endif
			
			BankGet( oCheck, @buf, sizeFrame, sizeFrameBank )
			myread()
			if lastkey() == K_ESC .or. lastkey() == K_PGDN
				exit
			endif
		enddo
		if !fl
			j := f_alert( { padc( 'Выберите действие', 60, '.' ) }, ;
				{ ' Выход без записи ',' Печать чека ', ' Возврат в редактирование ' }, ;
				iif( lastkey() == K_ESC, 1, 2 ), 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N,N/BG' )
			if j < 2
				exit
			elseif j == 3
				loop
			endif
		endif
		// для ККТ с ФН сформируем адрес направления чека
		if getDrvFR():IsFiscalReg()
			if hb_RegexLike( phoneTemplate, maddress )
				maddress := TransformPhone( maddress )
			else
				maddress := alltrim( maddress )
			endif
			oCheck:EMail := maddress
		endif
		oCheck:Received := vnos_summa - paymentType2 - paymentType3 - paymentType4
		oCheck:Cash := vnos_summa
		oCheck:PayType2 := paymentType2
		oCheck:PayType3 := paymentType3
		oCheck:PayType4 := paymentType4
		IncomeCashBayerPay( oCheck, rm )
		fl := .t.
		exit
	enddo
	rest_box( buf )
	rest_box( buf24 )
	restscreen( bufFull )
	setcolor( tmp_color )
	return fl	
	
* 27.06.17 - управление размером области для ввода банковских платежей
function controlSizeBox( g, old, oCheck, sizeFrame, sizeFrameBank, buf )
	local r := 16
	
	if old != NIL .and. old != m1Bank
		rest_box( buf )
		if m1Bank == 1
			buf := box_shadow( r, 5, r + sizeFrameBank, 74 )
		else
			buf := box_shadow( r, 5, r + sizeFrame, 74 )
			vnos_summa := oCheck:Total
		endif
		@ ++r, 7 SAY 'Платеж по банку:'
		@ ++r, 7 say 'Сумма переданная плательщиком (для подсчета сдачи)'
		BankGet( oCheck, @buf, sizeFrame, sizeFrameBank )
	endif
	return .t.

* 27.06.17 - формирование полей для ввода банковских платежей
function BankGet( oCheck, buf, sizeFrame, sizeFrameBank )
	local r := 16

	clear_gets()
	if getDrvFR():OtherTypePay()
		@ ++r, 7 SAY 'Платеж по банку:' get mBank reader ;
						{ | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) } ;
						valid { | g, o | controlSizeBox( g, o, oCheck, sizeFrame, sizeFrameBank, @buf ) }
	endif
	if getDrvFR():Change
		@ ++r, 7 say 'Сумма переданная плательщиком (для подсчета сдачи)' ;
			get vnos_summa picture pict_cena() ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
	endif
	If m1Bank == 1
		if  getDrvFR():EnableTypePay2()
			@ ++r, 7 say 'Сумма, видом оплаты (' +  Padr( getDrvFR():NameTypePay2(), 24 ) + ')' ;
				get paymentType2 picture pict_cena() ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
		endif
		if  getDrvFR():EnableTypePay3()
			@ ++r, 7 say 'Сумма, видом оплаты (' +  Padr( getDrvFR():NameTypePay3(), 24 ) + ')' ;
				get paymentType3 picture pict_cena() ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
		endif
		if  getDrvFR():EnableTypePay4()
			@ ++r, 7 say 'Сумма, видом оплаты (' +  Padr( getDrvFR():NameTypePay4(), 24 ) + ')' ;
				get paymentType4 picture pict_cena() ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
		endif
	endif
	if getDrvFR():IsFiscalReg()
		@ ++r, 7 say 'E-mail или номер телефона в формате +7XXXXXXXXXX' ;
				get maddress picture 'XXXXXXXXXXXXXXXXX' ;
				valid { | g | ControlAddress( g, maddress ) }
	endif
	status_key( '^<Esc>^ - выход без записи чека;  ^<PgDn>^ - запись чека' )
	return nil

* 27.06.17 - проверка адреса или телефона на допустимость для ОФД
function ControlAddress( get, address )
	local ret := .f.
	
	address := alltrim( address )
	ret := hb_RegexLike( emailTemplate, address ) .or. hb_RegexLike( phoneTemplate, address ) .or. empty( address )
	if !ret
		hb_Alert( 'Не верный формат телефона или E-mail адреса!', , , 4 )
	endif
	return ret

* 27.06.17 - преобразование телефонного номера в нормальный формат для ОФД
function TransformPhone( address )

	address := alltrim( address )
	address := AtRepl( '-', address, '' )
	address := AtRepl( ' ', address, '' )
	address := AtRepl( '_', address, '' )
	address := AtRepl( '(', address, '' )
	address := AtRepl( ')', address, '' )
	address := AtRepl( ':', address, '' )
	address := AtRepl( '=', address, '' )
	address := AtRepl( '+', address, '' )
	if len( address ) == 10
		address := '+7' + address
	elseif len( address ) == 11
		if substr( address, 1, 1 ) != '7'
			address := '+7' + substr( address, 2 )
		else
			address := '+' + address
		endif
	else
		address := ''
	endif
	return address
	
* 03.11.17 - пересчет полей ввода о платеже
function RecalcCheck( get, oCheck, lBank )
// lBank - носимая сумма .t. - банковской картой, .F. - наличными

	if !lBank	 // сумма наличными
		vnos_summa := round_5( vnos_summa, 2 )
		if ( vnos_summa < oCheck:Total )
			paymentType2 := round_5( oCheck:Total - vnos_summa - paymentType3 - paymentType4, 2 )
		else
			paymentType2 := 0
		endif
	else       // сумма безналичными
		paymentType2 := round_5( paymentType2, 2 )
		paymentType3 := round_5( paymentType3, 2 )
		paymentType4 := round_5( paymentType4, 2 )
		if paymentType2 + paymentType3 + paymentType4 > oCheck:Total
			hwg_MsgInfoBay( 'Сумма, вносимая безналичными, не может быть больше суммы к оплате!', 'О?ИБКА' )
			paymentType2 := oCheck:Total
		elseif ( paymentType2 > 0 ) .or. ( paymentType3 > 0 ) .or. ( paymentType4 > 0 )
			vnos_summa := round_5( oCheck:Total - paymentType2 - paymentType3 - paymentType4, 2 )
		else
			paymentType2 := 0
			paymentType3 := 0
			paymentType4 := 0
			if round_5( vnos_summa, 2 ) < oCheck:Total
				vnos_summa := oCheck:Total
			endif
		endif
	endif
	return update_gets()

* 03.11.17 - вывод сообщения о полученных денежных средствах	
function IncomeCashBayerPay( oCheck, nStartRow, cBorderColor, cBoxColor )
// aMessage - массив с данными
// cBorderColor - строка цвета для рамки
// cBoxColor - строка цвета для текста
// nStartRow - верхний ряд рамки (99 - центрировать)
	local buf := savescreen()

	if oCheck:TotalBank > 0
		f_message( { 'Сумма наличными: ' + str( oCheck:Cash, 10, 2 ), ;
			'Сумма по карте : ' + str( oCheck:TotalBank, 10, 2 ), ;
			'Сумма чека     : ' + str( oCheck:Total, 10, 2 ) }, , ;
			HB_DefaultValue( cBorderColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( cBoxColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( nStartRow, 99 ) )
			&& cBorderColor, cBoxColor, nStartRow )
	else
		f_message( { 'Вносимая сумма: ' + str( oCheck:Received, 10, 2 ), ;
			'Сумма чека    : ' + str( oCheck:Total, 10, 2 ), ;
			'──────────────────────────', ;
			'Сумма сдачи   : ' + str( Abs( oCheck:Total - oCheck:Received ), 10, 2 ) }, , ;
			HB_DefaultValue( cBorderColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( cBoxColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( nStartRow, 99 ) )
			&& cBorderColor, cBoxColor, nStartRow )
	endif
	restscreen( buf )
	return nil

// 17.10.24 - работа с чеком
function printReceipt( oContract, nKey )

	local s := ''
	local strIn := 'Введите номер чека: '
	local oCheck												// объект для чека
	local pict_chek := '999999'
	local buf := save_row( maxrow() )
	local item := nil, oService := nil
	local i, r, c, mas_pmt
	

	private ldate_op := date(), ltime_op := space( 5 ), lnchek := 0
	private lsum_voz := 0
	private lsum_voz_bank := 0

	do case
		case nKey == K_CTRL_F10
			if hb_user_curUser:IsAdmin()
				if  oContract:HasCheque .and. oContract:BackMoney > 0
					hb_Alert( 'По чеку был возврат. Очистка оплаты чека не возможна!' )
				else
					if hwg_MsgNoYesBay( 'Подтвердите очистку данных об оплате чеком' )
						oContract:IsCashbox := 2
						oContract:ReceiptNumber := 0
						oContract:TotalBank := 0.0
						oContract:DateCashbox := ctod( '' )
						oContract:TimeCashBox := 0
						oContract:DatePay := ctod( '' )
						oContract:SerialNumberFR := ''
						oContract:Cashier := nil
						TContractDB():Save( oContract )
						hb_Alert( 'Удалена информация об оплате чеком!' )
					endif
				endif
			else
				hb_Alert( 'Очистка оплаты чека возможна только администратором системы!' )
			endif
		case nKey == K_CTRL_F12
			if oContract:HasCheque					// имеется пробитый чек
				hb_Alert( 'Пробит чек.' + chr( 10 ) + 'Изменение не возможно!', , , 4 )
			else
				mas_pmt := {}
				aadd( mas_pmt, 'оплата наличными' )
				aadd( mas_pmt, 'банк' )
			
				i := 1
				r := maxrow() - len( mas_pmt ) - 4
				c := int( ( 80 - 3 ) / 2 )
				if ( i := popup_prompt( r, c, i, mas_pmt ) ) == 0
					return .t.
				endif
				oContract:IsCashbox := 1
				oContract:ReceiptNumber := 9999	//	oCheck:CheckNumber
				if i == 2
					oContract:TotalBank := oContract:Total //	 oCheck:TotalBank
				endif
				oContract:DateCashbox := oContract:BeginTreatment	//	oCheck:DateFR
				oContract:TimeCashBox := round_5( timetosec( Time() ), 0 )	//oCheck:TimeFR
				oContract:DatePay := oContract:BeginTreatment	//	oCheck:DateFR
				oContract:SerialNumberFR := 'CTRL_F12'	//	oCheck:SerialNumberFR
				oContract:Cashier := hb_user_curUser
				TContractDB():Save( oContract )
			endif
		case nKey == K_F10
			if oContract:HasCheque
				hb_Alert( 'Чек уже пробит', , , 4 )
			elseif empty( oContract:Services() )
				hb_Alert( 'Нет услуг в договоре' )
			elseif !getDrvFR():IsFiscalReg
				hb_Alert( 'На этом рабочем месте ККТ не подключена!' )
			elseif getDrvFR():IsFiscalReg .and. !empty( oContract:Services() ) .and. !oContract:HasCheque
				oCheck := TCheck():New( getDrvFR() )				// объект для чека
				oCheck:Sale()							// установим флаг продажи
				oCheck:Patient := oContract:Patient			// установим пациента
				for each item in oContract:Services()
					oService := TServiceOfCheck():New( item:Subdivision:ID, item:Service:Shifr, ;
								item:Service:NameToPOS, ;
								item:ExecuterFIO, ;
								( item:Total / item:Quantity ), item:Quantity, ;
								item:Service():CalculateNDS( oContract:Patient:IsAdult( item:Date )) )
					oCheck:AddService( oService )
				next
				if !empty( oContract:PayerFIO )
					oCheck:Payer := oContract:PayerFIO
					OCheck:PayerINN := oContract:PayerINN
				endif
				if yes_chek( oCheck )
					if oCheck:Print()
						oContract:IsCashbox := 1
						oContract:ReceiptNumber := oCheck:CheckNumber
						oContract:TotalBank := oCheck:TotalBank
						oContract:DateCashbox := oCheck:DateFR
						oContract:TimeCashBox := oCheck:TimeFR
						oContract:DatePay := oCheck:DateFR
						oContract:SerialNumberFR := oCheck:SerialNumberFR
						oContract:Cashier := hb_user_curUser
						TContractDB():Save( oContract )
					endif
				endif
			endif
		case nKey == K_CTRL_F8
			if hb_user_curUser:IsAdmin()
				if  oContract:HasCheque .and. oContract:BackMoney == 0
					hb_Alert( 'По чеку не производился возврат денег. Очистка возврата чека не возможна!' )
				elseif  oContract:HasCheque .and. oContract:BackMoney > 0
					if hwg_MsgNoYesBay( 'Подтвердите очистку данных о возврате оплаты чека' )
						oContract:TypeCashboxMoneyBack := 0
						oContract:DateBackMoney := ctod( '' )
						oContract:DateMoneyBack := ctod( '' )
						oContract:TimeMoneyBack := 0
						oContract:BackMoney := 0
						oContract:SerialNumberFRBack := ''
						oContract:CashierBack := ''
						TContractDB():Save( oContract )
						hb_Alert( 'Удалена информация о возврате!' )
					endif
				endif
			else
				hb_Alert( 'Очистка возврат по чеку возможна только администратором системы!' )
			endif
		case nKey == K_F8
			if oContract:BackMoney > 0
				hb_Alert( 'Возврат денег уже произведен!', , , 4 )
			elseif getDrvFR():IsFiscalReg .and. oContract:HasCheque .and. oContract:BackMoney == 0
				lsum_voz := oContract:Total - oContract:TotalBank
				lsum_voz_bank := oContract:TotalBank
				if oContract:TotalBank > 0
					s := ' \' + ;
						'      Общая стоимость услуг = ' + lput_kop( oContract:Total, .t. ) + ' руб.\' + ;
						'      Введите дату  возврата  @           \' + ;
						'Введите сумму возврата по карте @   \' + ;
						' \'
					DisplBox( s, , ;								// цвет окна (умолч. - cDataCGet)
						{ 'ldate_op', 'lsum_voz_bank' }, ;	// массив private-переменных для редактирования
						{ , pict_cena() }, ;				// массив Picture для редактирования
						17 )
				else
					s := ' \' + ;
						'      Общая стоимость услуг = ' + lput_kop( oContract:Total, .t. ) + ' руб.\' + ;
						'      Введите дату  возврата  @           \' + ;
						'      Введите сумму возврата  @           \' + ;
						' \'
					DisplBox( s, , ;								// цвет окна (умолч. - cDataCGet)
						{ 'ldate_op', 'lsum_voz' }, ;	// массив private-переменных для редактирования
						{ , pict_cena() }, ;				// массив Picture для редактирования
						17 )
				endif
				if lastkey() == K_ESC
					//
				elseif round( lsum_voz, 2 ) <= 0 .and. round( lsum_voz_bank, 2 ) <= 0
					mybell()
				elseif lsum_voz > oContract:Total - oContract:TotalBank
					hb_Alert( 'Сумма возврата больше стоимости услуг!', , , 4 )
				elseif lsum_voz_bank > oContract:TotalBank
					hb_Alert( 'Сумма возврата по карте больше оплаты по карте', , , 4 )
				elseif f_Esc_Enter( iif( lsum_voz_bank > 0,'возврата по карте ' + lput_kop( lsum_voz_bank, .t. ) + ' руб.', 'возврата ' + lput_kop( lsum_voz, .t. ) + ' руб.' ) )
					oCheck := TCheck():New( getDrvFR() )		// объект для чека
					oCheck:Refund()							// установим флаг возврата
					oCheck:Patient := oContract:Patient
					// соберем услугу возврата
					oService := TServiceOfCheck():New()
					oService:Name := 'ВОЗВРАТ'
					oService:Section := 1				// секция
					oService:Quantity := 1
					oService:Price := iif( lsum_voz_bank > 0, lsum_voz_bank, lsum_voz )
					oCheck:AddService( oService )			// добавим услугу к чеку
					if lsum_voz_bank > 0
						oCheck:PayType2 := lsum_voz_bank
					else
						oCheck:Cash := lsum_voz
					endif
					if oCheck:Print()
						oContract:TypeCashboxMoneyBack := 1
						oContract:DateBackMoney := oCheck:DateFR
						oContract:DateMoneyBack := oCheck:DateFR
						oContract:TimeMoneyBack := oCheck:TimeFR
						oContract:BackMoney := oCheck:Total
						oContract:SerialNumberFRBack := oCheck:SerialNumberFR
						oContract:CashierBack := hb_user_curUser
						TContractDB():Save( oContract )
						hb_Alert( 'Сумма возврата записана!', , , 4 )
					else
						hb_Alert( 'Не поддерживается в текущей конфигурации.', , , 4 )
					EndIf
				endif
			endif
		otherwise
	endcase
	return .t.

* 13.11.18 - печать копии чека, если есть
function printCopyReceipt( oContract )
	local namePatient := ''

	if ! getDrvFR():IsFiscalReg
		hb_Alert( 'На рабочем месте отсутствует подключенный фискальный регистратор. Печать копии чека не возможна!', , , 4 )
	elseif ! oContract:HasCheque
		hb_Alert( 'У договора отсутствует чек об оплате. Печать копии чека не возможна!', , , 4 )
	elseif alltrim( oContract:SerialNumberFR ) != alltrim( getDrvFR():SerialNumber )
		hb_Alert( 'Чек для договора печатался на другом фискальном регистраторе. Печать копии чека не возможна!', , , 4 )
	else
		if ! empty( oContract:PayerFIO )
			namePatient := 'Пациент: '
			getDrvFR():FeedDocument( 1, 1 )
			if (ret := getDrvFR():PrintString( 'Плательщик: ' + fam_i_o( oContract:PayerFIO ), , 1 ) )
				if !empty( oContract:PayerINN )
					ret := getDrvFR():PrintString( 'ИНН плательщика: ' + oContract:PayerINN, , 1 )
				endif
			endif
		endif
		namePatient := namePatient + lstr( oContract:Patient:ID ) + '  ' + fam_i_o( oContract:Patient:FIO )
		getDrvFR():FeedDocument( 1, 1 )
		getDrvFR():PrintString( namePatient, len( alltrim( namePatient ) ) < 20 )
		getDrvFR():FeedDocument( 1, 1 )
	
		getDrvFR():PrintCopyReceipt( oContract:ReceiptNumber )
	endif
	return .t.

function close_lu( param )

	hb_Alert( 'Не реализовано' )
	return nil

* 26.06.17 - ф-ция пустышка для совместимости
function f_usl_date()

	hb_Alert( 'Сделать' )
	return nil

