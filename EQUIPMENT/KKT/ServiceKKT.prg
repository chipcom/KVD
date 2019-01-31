* 03.04.18 GetDateTimeKKT() - Получить дату и время из кассового аппарата для GET-ов	
* 22.06.17 SetupDate( typeKKT, dDate ) - Установка даты в ККМ
* 03.04.18 PrintReport( flag ) - Печать X-отчетов и Z-отчетов

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

// виды используемых ККМ
#define KKT_NONE 1
#define KKT_OFF 2
#define KKT_SHTRIH 3

static str_Error := 'ОШИБКА'
static str_Warning := 'Не поддерживается в текущей конфигурации.'

* 03.04.18 пустышка-заполнитель
function f_empty()
	return nil

function ClearDrvFR()

	hb_kkt_drvFR := nil
	return nil

* 22.06.17 - Получить дату и время из компьютера для GET-ов	
function GetDateTimePC( get )

	mDateInKKT := Date()
	mTimeInKKT := Time()
	return update_gets()
	
* 02.04.18 - переменные для работы с ККТ
function loadVariableKKT()

	public hb_kkt := nil									// переменная для хранения ссылки на драйвер ККТ

	public hb_kkt_oKKT := TSettingKKT():New( 'Workplace' )		// переменная для настроек ККТ
	public hb_kkt_drvFR := nil									// переменная для хранения ссылки на драйвер ККТ
	public hb_kkt_devMetrics := nil
	public hb_kkt_shortECRStatus := nil
	public hb_kkt_ECRStatus := nil
	public hb_kkt_FNStatus := nil
	public hb_kkt_passwordAdmin := 0
	public hb_kkt_lUserSet := .f.
	public hb_kkt_lIsEKLZ := .f.
	public hb_kkt_lIsFN := .f.
	public hb_kkt_lOpenSession := .f.
	public hb_kkt_serialNumber := ''

	return nil

* 03.04.18 - открыть свойства ФР
function PropertiesFR()

	getDrvFR():ShowProperties()
	return nil

* 10.04.18 сформировать чек коррекции
* type - вид работы ( 0 - продажа, 1 - покупка )
function BuildCorrectionReceipt( type )
	local mmType := { { 'самостоятельно', 1 }, { 'по предписанию', 2 } }
	local summ1 := 0.0, summ2 := 0.0, summ3 := 0.0, summ4 := 0.0, summ5 := 0.0, summ6 := 0.0
	local docNum := 0, docDate := date(), docDescription := space( 100 )
	local strIn := 'Корректирующая сумма продажи: '
	local strOut := 'Корректирующая сумма покупки: '
	local mpicture := '999999.99' , tmpString
	local oCorrection := TCorrectionCheck():New()
	
	local bufFull := savescreen()
	local j, fl := .f., tmp_color, buf, buf24, r := 10
	
	private mCorrectionType, m1CorrectionType := 1				// корректировка самостоятельно
	
	mCorrectionType := inieditspr( A__MENUVERT, mmType, m1CorrectionType )
	HB_Default( @type, 0 ) 
	
	tmp_color := setcolor( cDataCGet )
	buf24 := save_row( maxrow() )
	
	tmpString := iif( type == 0, strIn, strOut )
	oCorrection:CalculationSign := iif( type == 0, 1, 3 )
	&& buf := box_shadow( r, 5, r + 10, 74, , tmpString, color8 )
	buf := box_shadow( r, 5, r + 7, 74, , tmpString, color8 )
	do while .t.
		r := 10
		@ ++r, 7 SAY 'Тип коррекции:' get mCorrectionType reader ;
					{ | x | menu_reader( x, mmType, A__MENUVERT, , , .f. ) }
		&& @ ++r, 7 say 'Сумма по чеку' get summ1 picture mpicture
		@ ++r, 7 say 'Сумма по чеку наличными' get summ2 picture mpicture valid ( summ2 >= 0 )
		@ ++r, 7 say 'Сумма по чеку электронными' get summ3 picture mpicture valid ( summ3 >= 0 )
		&& @ ++r, 7 say 'Сумма по чеку предоплатой' get summ4 picture mpicture valid ( summ4 >= 0 )
		&& @ ++r, 7 say 'Сумма по чеку постоплатой' get summ5 picture mpicture valid ( summ5 >= 0 )
		&& @ ++r, 7 say 'Сумма по чеку встречным представлением' get summ6 picture mpicture valid ( summ6 >= 0 )
		@ ++r, 7 say 'Номер документа основания' get docNum
		@ ++r, 7 say 'Дата документа основания' get docDate
		@ ++r, 7 say 'Описание документа основания' get docDescription picture '@S37'
	
		status_key( '^<Esc>^ - выход без записи чека;  ^<PgDn>^ - запись чека' )
		myread()
		if lastkey() == K_ESC
			exit
		endif
		j := f_alert( { padc( 'Выберите действие', 60, '.' ) }, ;
			{ ' Выход без записи ',' Печать чека ', ' Возврат в редактирование ' }, ;
			iif( lastkey() == K_ESC, 1, 2 ), 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N,N/BG' )
		if j < 2
			exit
		elseif j == 3
			loop
		endif
		oCorrection:CorrectionType := m1CorrectionType - 1
		oCorrection:Summ1 := ( summ2 + summ3 + summ4 + summ5 + summ6 )
		oCorrection:Summ2 := summ2
		oCorrection:Summ3 := summ3
		oCorrection:Summ4 := summ4
		oCorrection:Summ5 := summ5
		oCorrection:Summ6 := summ6
		oCorrection:TaxType := 1
		oCorrection:DocNum := docNum
		oCorrection:DocDate := docDate
		oCorrection:DocDescription := docDescription
		getDrvFR():BuildCorrectionReceipt( oCorrection )
		exit
	enddo
	rest_box( buf )
	rest_box( buf24 )
	restscreen( bufFull )
	setcolor( tmp_color )
	oCorrection := nil
	return nil

* 03.04.18 - Печать X-отчетов и Z-отчетов
*  flag  - 0 - отчет без гашения, 1 - отчет с гашением
function PrintReport( flag )
	local ret := .f., regim, strTitle := 'Снятие отчета', strNone, strCloseReport, strOk
	
	strOk := 'Снятие суточного отчета ' + iif( flag == 0, 'без гашения ', 'с гашением ' ) + 'выполнено'
	strNone := 'Не произошло снятие суточного отчета ' + iif( flag == 0, 'без гашения', 'с гашением' )
	strCloseReport := 'Закрытая смена.' + chr( 13 ) + chr( 10 ) + 'Снятие отчета с гашением невозможно!'
	if ret_fsytotch( flag )
		if ( iif( flag == 1, getDrvFR():PrintReportWithCleaning(), getDrvFR():PrintReportWithoutCleaning() ) )
			hwg_MsgInfoBay( strOk, strTitle )
		else
			hwg_MsgInfoBay( strNone, strTitle )
		endif
	endif
	return nil

*****
function ret_fsytotch( tip )
	local strTitle := 'Снятие отчета', str
	str := 'Cнятие суточного отчета' + if( tip==0, ' без гашения.', ' с гашением.' )
	return if( hwg_MsgNoYesBay( str, strTitle ), .t., .f. )

* 03.04.18 - Получить дату и время из кассового аппарата для GET-ов	
function GetDateTimeKKT()

	tempDate := getDrvFR():GetDate()
	tempTime := hb_TToC( getDrvFR():GetTime(), '', 'hh:mm:ss' )	// переводим из datetime в string
	return nil

* 22.06.17 - Установка даты в ККМ
function SetupDate( dDate )
	local ret := .f.

	if ( ret := getDrvFR():SetDate( dDate ) )
		hwg_MsgInfoBay( 'Дата в ФР изменена!', 'Команда Выполнена!' ) 
		getDrvFR():Beep()
	else
		hwg_MsgInfoBay( str_Warning, str_Error )
	endif
	return nil

* 03.04.18 - Установка времени в ККТ
function SetupTime( cTime )	
	local ret := .f.

	if ( ret := getDrvFR():SetTime( cTime) )
		hwg_MsgInfoBay( 'Время в ФР изменено!', 'Команда Выполнена!' )
		getDrvFR():Beep()
	else
		hwg_MsgInfoBay( str_Warning, str_Error )
	endif
	return nil

function getDrvFR()
	return hb_kkt

* 21.06.17 - вернуть настройки ККТ
function getSetKKT()
	
	return hb_kkt_oKKT

* 02.04.2018 первичная инициализация драйвера фискального регистратора
function InitDriverFR()
	
	checkDriverFR()
	return nil

* 04.04.18 - создает (возвращает) объект драйвера фискального регистратора
function checkDriverFR()
	local exchangeStatus, messageStatus, messageCount, documentNumber, dateDoc, timeDoc
	local strMessage := ''
	local nameKKT := ''
	local typeKKT := GetSetKKT():TypeKKT
	local aDrvDescription := { ;
								{ '', 'нет', 0, 0, 0, 0 }, ;
								{ '', 'нет', 0, 0, 0, 0 }, ;
								{ 'AddIn.DrvFr', 'Драйвер Штрих-М', 4, 13, 0, 527 } ;
							}
	local ret := .f.
	local oSettings := nil
	local oKKT := nil, obj := nil
	local aDriver := { ;
						{ TKKT_None(), '', 'нет' }, ;
						{ TKKT_None(), '', 'нет' }, ;
						{ TKKT_Shtrih(), 'AddIn.DrvFr', 'Драйвер Штрих-М' } ;
					}

	if getDrvFR() == nil
		oSettings := TSettingKKT():New( 'Workplace' )
		oKKT :=TServiceKKT():New()
		obj := aDriver[ oSettings:TypeKKT, 1 ]:New()
		oKKT:SetKKT( obj )
		oKKT:Init()
		oKKT:Open( oSettings, hb_user_curUser:PasswordFR() )
		oKKT:SetOperatorKKT( hb_user_curUser:PasswordFR, alltrim( hb_user_curUser:FIO ) )
		hb_kkt := oKKT
		hb_kkt:CheckExchangeStatus( .f. )
		ret := .t.
	endif
	return ret

* 22.06.17 - обновить поля GET для даты и времени	
function UpdateDateTime( get )

	if tempDate == nil
		return .t.
	else
		mDateInKKT := tempDate
		mTimeInKKT := tempTime
	endif
	return update_gets()

***** внесение и выплата из кассы
* type - вид работы (.t. - внесение, .f. - выплата)
function CashInOut( type )
	local summa := 0, strIn := 'Вносимая сумма: ', strOut := 'Сумма для выплаты: '
	local colBegin := 0, colEnd := 0, mpicture := '99999.99' , tmpString
	
	HB_Default( @type, .t. ) 
	tmpString := iif( type, strIn, strOut )
	colBegin := Int( ( 80 - Len( tmpString ) - Len( mpicture ) - 2) / 2 )
	colEnd := colBegin + Len( tmpString ) + 12
	if (summa := input_value( 18, colBegin, 20, colEnd, color1, ;
					tmpString, 0.0, mpicture ) ) != nil .and. summa > 0
		if type
			getDrvFR():CashIncome( summa )
		else
			getDrvFR():CashOutcome( summa )
		endif
	endif
	return nil

* 22.06.17 - возвращает .t. если переданный параметр указывает на применение фискального регистратора
function isFiscalReg( param )
	return param != KKT_OFF .and. param != KKT_NONE

* 31.01.19 - настройка кассового аппарата
function SetupKKT()
	static mm_da_net := { { 'да ', 1 }, { 'нет', 2 } }
	static mmTypeKKT := { { 'Не использовать ККТ     ', KKT_NONE }, ;
						{ 'ККТ off-Line            ', KKT_OFF }, ;
						{ 'ККТ Штрих-М: Драйвер ФР ', KKT_SHTRIH } }
	static cgreen := 'G+/B'											// цвет для меток
	local buf
	
	
	***************
	buf := box_shadow( 1, 0, 22, 78, 'B+/B' )
	//	private mtest := 'Запуск', m1test := 0
	private mtypeKKT, m1typeKKT := getSetKKT():TypeKKT	// ()
	private mpassAdmin := getSetKKT():AdminPass
	private mnumPOS := getSetKKT():NumPOS
	private mnamePOS := getSetKKT():NamePOS
	private mFabricNumber := iif( Empty( getSetKKT():FRNumber ), space( 16 ), getSetKKT():FRNumber )
	private mDateInKKT := Date()
	private mTimeInKKT := Time()
	private mnkassa := 'Запуск', m1nkassa
	private mSetDate := 'Установить', m1SetDate
	private mSetTime := 'Установить', m1SetTime
	private mGetFromKKT := 'Получить из ККМ', m1GetFromKKT
	private mGetFromPC := 'Получить из ПК ', m1GetFromPC
	private mopenDrawer, m1openDrawer := iif( getSetKKT():OpenADrawer, 1, 2 )
	private mprintDoctor, m1printDoctor := iif( getSetKKT():PrintDoctor, 1, 2 )
	private mprintPatient, m1printPatient := iif( getSetKKT():PrintPatient, 1, 2 )
	private mchangeEnable, m1changeEnable := iif( getSetKKT():ChangeEnable, 1, 2 )
	private mchangePrint, m1changePrint := iif( getSetKKT():ChangePrint, 1, 2 )
	private mshifrUslPrint, m1shifrUslPrint := iif( getSetKKT():PrintCodeUsl, 1, 2 )
	private mnameUslPrint, m1nameUslPrint := iif( getSetKKT():PrintNameUsl, 1, 2 )
	private mvid2Enable, m1vid2Enable := iif( getSetKKT():EnableTypePay2, 1, 2 )
	private mvid3Enable, m1vid3Enable := iif( getSetKKT():EnableTypePay3, 1, 2 )
	private mvid4Enable, m1vid4Enable := iif( getSetKKT():EnableTypePay4, 1, 2 )
	private mnVid2Name := iif( Empty( getSetKKT():NameTypePay2 ), space( 24 ), getSetKKT():NameTypePay2 )
	private mnVid3Name := iif( Empty( getSetKKT():NameTypePay3 ), space( 24 ), getSetKKT():NameTypePay3 )
	private mnVid4Name := iif( Empty( getSetKKT():NameTypePay4 ), space( 24 ), getSetKKT():NameTypePay4 )
	
	mtypeKKT := inieditspr( A__MENUVERT, mmTypeKKT, m1typeKKT )
	mopenDrawer := inieditspr( A__MENUVERT, mm_da_net, m1openDrawer )
	mprintDoctor := inieditspr( A__MENUVERT, mm_da_net, m1printDoctor )
	mprintPatient := inieditspr( A__MENUVERT, mm_da_net, m1printPatient )
	mchangeEnable := inieditspr( A__MENUVERT, mm_da_net, m1changeEnable )
	mchangePrint := inieditspr( A__MENUVERT, mm_da_net, m1changePrint )
	mshifrUslPrint := inieditspr( A__MENUVERT, mm_da_net, m1shifrUslPrint )
	mnameUslPrint := inieditspr( A__MENUVERT, mm_da_net, m1nameUslPrint )
	mvid2Enable := inieditspr( A__MENUVERT, mm_da_net, m1vid2Enable )
	mvid3Enable := inieditspr( A__MENUVERT, mm_da_net, m1vid3Enable )
	mvid4Enable := inieditspr( A__MENUVERT, mm_da_net, m1vid4Enable )
	setcolor(cDataCGet)
	ix := 1
	ClrLines( 1, maxrow() - 1 )
	// выбор вида кассового аппарата
	@ ix, 2 SAY 'Общие:' color cgreen
	@ ++ix, 2 say 'Работа с ККМ: ' get mtypeKKT ;
		reader { | x | menu_reader( x, mmTypeKKT, A__MENUVERT, , , .f. ) }
	if m1typeKKT != KKT_NONE
		@ ++ix, 2 say 'Номер кассы: ' get mnumPOS  pict '999'
	endif
	if isFiscalReg( m1typeKKT )
		@ ix, 22 say 'Название кассы: ' get mnamePOS picture 'XXXXXXXXXXXXXXXXXXXXXXXX' when isFiscalReg( m1typeKKT ) //m1typeKKT == KKT_SHTRIH
	elseif m1typeKKT == KKT_OFF
		@ ix, 22 say 'Заводской номер ККМ: ' get mFabricNumber picture 'XXXXXXXXXXXXXXXX' when m1typeKKT == KKT_OFF
	endif
	// Настройка кассового аппарата
	if isFiscalReg( m1typeKKT )
		@ ++ix, 2 SAY 'Системные параметры:' color cgreen
	endif
	if isFiscalReg( m1typeKKT )
		@ ++ix, 2 SAY 'Драйвер установлен:'
		@ ix, col() + 1 SAY if( getDrvFR():Driver != nil, 'Да', 'Нет' ) color 'R/B+'
		if getDrvFR():Driver != nil
			@ ix, col() + 1 SAY 'Версия драйвера:'
			do case
			case m1typeKKT == KKT_SHTRIH
				@ ix, col() + 1 SAY getDrvFR():Version	color 'R/B+'
			endcase
			@ ++ix, 2 say 'Настройка драйвера ...' get mnkassa ;
				reader { | x | menu_reader( x, { { || PropertiesFR() } }, A__FUNCTION, , , .f. ) }
		else
			++ix
		endif
		@ ++ix, 2 say 'Пароль системного администратора: ' get mpassAdmin  pict '99'
		@ ++ix, 2 say 'Открывать денежный ящик при начале печати?' get mopenDrawer ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , ,.f. ) }
		// дата и время
		@ ++ix, 2 SAY 'Дата и время:' color cgreen
		@ ++ix, 2 say 'Дата:  ' get mDateInKKT picture '99.99.9999'
		private tempDate := nil, tempTime := nil			// для обновления GET-ов
		if getDrvFR() != nil
			@ ix, 20 say ' ' get mGetFromKKT ;
				reader { | x | menu_reader( x, { { || GetDateTimeKKT() } }, A__FUNCTION, , , .f. ) } ;
				valid { | g | UpdateDateTime( g ) }
			@ ix, 37 say ' ' get mSetDate ;
				reader { | x | menu_reader( x, { { || SetupDate( mDateInKKT ) } }, A__FUNCTION, , , .f. ) }
		endif
		@ ++ix, 2 say 'Время: ' get mTimeInKKT picture '99:99:99' when isFiscalReg( m1typeKKT )
		if getDrvFR() != nil
			@ ix, 20 say ' ' get mGetFromPC ;
				reader { | x | menu_reader(x,{{ || f_empty() } }, A__FUNCTION, , , .f. ) } ;
				valid { | g | GetDateTimePC( g ) }
			@ ix, 37 say ' ' get mSetTime ;
				reader { | x | menu_reader( x, { { || SetupTime( m1typeKKT, mTimeInKKT ) } }, A__FUNCTION, , , .f. ) }
		endif
		// Работа с видами оплат
		@ ++ix, 2 SAY 'Виды оплаты:' color cgreen
		@ ++ix, 2 say 'Разрешить вид оплаты № 2' get mvid2Enable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ix, 31 say 'Название вида оплаты №2' get mnVid2Name  pict 'XXXXXXXXXXXXXXXXXXXXXXX'
		@ ++ix, 2 say 'Разрешить вид оплаты № 3' get mvid3Enable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ix, 31 say 'Название вида оплаты №3' get mnVid3Name  pict 'XXXXXXXXXXXXXXXXXXXXXXX'
		@ ++ix, 2 say 'Разрешить вид оплаты № 4' get mvid4Enable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ix, 31 say 'Название вида оплаты №4' get mnVid4Name  pict 'XXXXXXXXXXXXXXXXXXXXXXX'
		// внешний вид чека ККМ		
		@ ++ix, 2 SAY 'Вид чека:' color cgreen
		@ ++ix, 2 say 'Запрос вносимой суммы и подсчёт сдачи?' get mchangeEnable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say 'Печать вносимой суммы и сдачи в чеке?' get mchangePrint ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) } when m1changeEnable == 1
		@ ++ix, 2 say 'Печать ФИО врача оказавшего услугу в чеке?' get mprintDoctor ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say 'Печать ФИО пациента/плательщика в чеке?' get mprintPatient ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say 'Печать шифр услуги?' get mshifrUslPrint ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say 'Печать наименование услуги?' get mnameUslPrint ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
	endif
	status_key( '^<Esc>^ - выход без записи;  ^<PgDn>^ - подтверждение ввода' )
	myread()
	if lastkey() == K_ESC
		rest_box( buf )
		return nil
	endif
	if f_Esc_Enter( 1 )
		getSetKKT():TypeKKT := m1typeKKT
		getSetKKT():NumPOS := mnumPOS
		getSetKKT():NamePOS := mnamePOS
		getSetKKT():AdminPass := mpassAdmin
		getSetKKT():OpenADrawer := iif( m1openDrawer == 2, .f., .t. )
		getSetKKT():PrintDoctor := iif( m1printDoctor == 2, .f., .t. )
		getSetKKT():PrintPatient := iif( m1printPatient == 2, .f., .t. )
		getSetKKT():ChangeEnable := iif( m1changeEnable == 2, .f., .t. )
		getSetKKT():ChangePrint := iif( m1changePrint == 2, .f., .t. )
		getSetKKT():PrintCodeUsl := iif( m1shifrUslPrint == 2, .f., .t. )
		getSetKKT():PrintNameUsl := iif( m1nameUslPrint == 2, .f., .t. )
		
		getSetKKT():EnableTypePay2 := iif( m1vid2Enable == 2, .f., .t. )
		if empty( alltrim( mnVid2Name ) )
			mnVid2Name := 'КАРТОЙ МИР'
		endif
		getSetKKT():NameTypePay2:= mnVid2Name
		getSetKKT():EnableTypePay3 := iif( m1vid3Enable == 2, .f., .t. )
		getSetKKT():NameTypePay3 := mnVid3Name
		getSetKKT():EnableTypePay4 := iif( m1vid4Enable == 2, .f., .t. )
		getSetKKT():NameTypePay4 := mnVid4Name
		getSetKKT():FRNumber := mFabricNumber
		getSetKKT():Save()
		ClearDrvFR()
		loadVariableKKT()
		InitDriverFR()
	endif
	rest_box( buf )
	return nil

* 28.07.17 - записать информацию об ошибке кассы
function WriteErrKassa( info )
	local _tmp := ''		//, i, t_arr[ 2 ], ar := { '' }
	// local item:= nil
	local oLog := tIPLogLocal():New( dir_server + GetSetKKT():NameFileLogError )
	local typeKKT := GetSetKKT():TypeKKT
	local numPOS := getSetKKT():NumPOS
	local namePOS := getSetKKT():NamePOS

	if GetSetKKT():LogError
		// bTrace := { |cMsg| iif( pcount() > 0, oLog:Add( cMsg ), oLog:Close() ) }
		oLog:lLogAdditive    := .t.      						// Log to a single file
		oLog:nLogFileMaxSize := GetSetKKT():SizeFileLogError	// Create a new file after 10MB
		oLog:lLogCredentials := .f.								// Do not log username/password
		oLog:InsertDivider()									// A divider between log items
		// aadd( ar, info )
		if typeKKT == KKT_SHTRIH
			_tmp += 'Драйвер Штрих-М, версия:' + alltrim( getDrvFR():DriverVersion ) + chr( 13 ) + chr( 10 )
		else
			_tmp += 'Не известный драйвер фискального регистратора' + chr( 13 ) + chr( 10 )
		endif
		_tmp += 'Касса № ' + alltrim( str( numPOS ) ) + '. Название: ' + alltrim( namePOS )
		_tmp += chr( 13 ) + chr( 10 )
		if type( 'fio_polzovat' ) == 'C' .and. !empty( fio_polzovat )
			_tmp += 'Кассир: ' + alltrim( hb_user_curUser:Name )
		endif
		if type( 'p_name_comp' ) == 'C' .and. !empty( p_name_comp )
			_tmp += '. Расположение БД: ' + alltrim( p_name_comp )
		endif
		_tmp += chr( 13 ) + chr( 10 )
		// for Each item in ar
			// if !empty( item )
				// _tmp += item + chr( 13 ) + chr( 10 )
			// endif
		// next
		_tmp += info + chr( 13 ) + chr( 10 )
		oLog:Add( _tmp )
		oLog:Close()
	endif
	return nil

***** 04.04.18
function ContinuePrintAfterError()
//  продолжение печати
	local strTitle := 'Продолжение печати', strOk, strNone
		
	strOk := 'Команда выполнена'
	strNone := 'Не произошло продолжения печати'
	if getDrvFR():ContinuePrint()
		hwg_MsgInfoBay( strOk, strTitle )
	else
		hwg_MsgInfoBay( strNone, strTitle )
	endif
	return nil

***** 04.04.18
function CancelCheck()
//  аннулирование чека
	local strTitle := 'Отмена чека', strOk, strNone
		
	strOk := 'Команда выполнена'
	strNone := 'Не произошло отмены чека'
	if getDrvFR():CancelCheck()
		hwg_MsgInfoBay( strOk, strTitle )
	else
		hwg_MsgInfoBay( strNone, strTitle )
	endif
	return nil
