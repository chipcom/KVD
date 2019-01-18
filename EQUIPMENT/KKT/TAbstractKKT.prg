#include 'property.ch'
#include 'hbclass.ch'

CLASS TAbstractKKT

	PUBLIC:
		PROPERTY SerialNumber READONLY
		PROPERTY OpenSession READONLY					// признак открытой сессии
		PROPERTY OpenADrawer READONLY	//READ GetOpenDrawer			// открывать денежный ящик
		PROPERTY IsFiscalReg READ getIsFiscalReg			// устройство фискальный регистратор или нет
		PROPERTY RNM READ FRNM
		PROPERTY RegimKKT READ GetRegim
		PROPERTY IsLoaded READ FDriverLoaded				// драйвер загружен
		PROPERTY ResultCode READ FResultCode
		PROPERTY ResultCodeDescription READ FResultCodeDescription
		PROPERTY PasswordAdmin READ FPasswordAdmin
		PROPERTY Password READ FPassword
		PROPERTY OpenDocumentNumber READ FOpenDocumentNumber
		PROPERTY ReceiptNumber READ FReceiptNumber
		PROPERTY DocumentNumber READ FDocumentNumber
		PROPERTY InfoExchangeStatus READ GetInfoExchangeStatus
		PROPERTY MessageStatus READ GetMessageStatus
		PROPERTY MessageCount READ GetMessageCount
		PROPERTY FirstDocumentNumber READ GetFirstDocumentNumber
		PROPERTY DateFirstDocument READ GetDateFirstDocument
		PROPERTY TimeFirstDocument READ GetTimeFirstDocument
		
		PROPERTY NumberPos READ GetNumberPOS				// номер кассового аппарата
		PROPERTY NamePOS READ GetNamePOS					// название кассы
		PROPERTY PrintDoctor READ GetPrintDoctor			// печать врача в чеке
		PROPERTY PrintPatient READ GetPrintPatient		// печать пациента в чеке
		PROPERTY Change READ GetChange					// подсчет сдачи
		PROPERTY PrintChange READ GetPrintChange			// печать вносимой суммы и сдачи
		PROPERTY PrintCodeService READ GetPrintCodeService	// печать шифра услуги
		PROPERTY PrintNameService READ GetPrintNameService	// печать наименования услуги
		PROPERTY EnableTypePay2 READ GetEnableTypePay2	// разрешить вид оплаты 2
		PROPERTY NameTypePay2 READ GetNameTypePay2		// название вида оплаты 2
		PROPERTY EnableTypePay3 READ GetEnableTypePay3	// разрешить вид оплаты 3
		PROPERTY NameTypePay3 READ GetNameTypePay3		// название вида оплаты 3
		PROPERTY EnableTypePay4 READ GetEnableTypePay4	// разрешить вид оплаты 4
		PROPERTY NameTypePay4 READ GetNameTypePay4		// название вида оплаты 4
		
		METHOD Destroy()
		METHOD Open( oSetting, nPasswordUser )
		METHOD Init							VIRTUAL		// загрузка драйвера устройства
		METHOD ShowProperties				VIRTUAL		// показать свойства драйвера устройства
		METHOD Version							VIRTUAL		// плучить версию драйвера
		METHOD Beep							VIRTUAL		// гудок
		METHOD PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )	VIRTUAL
		METHOD OpenDrawer( nDrawerNumber )	VIRTUAL		// открыть денежный ящик
		METHOD CashIncome( summ1 )			VIRTUAL		// внесение денежной суммы в кассу
		METHOD CashOutcome( summ1 )			VIRTUAL		// выплата денежной суммы из кассы
		METHOD FeedDocument( flag, numStr )	VIRTUAL		// продвинуть документ
		METHOD FNGetStatus					VIRTUAL		// получить состояние фискального накопителя устройства
		METHOD PrintReportWithoutCleaning	VIRTUAL		// снять отчет без гашения
		METHOD PrintReportWithCleaning		VIRTUAL		// снять отчет с гашением
		METHOD CancelCheck					VIRTUAL		// отмена чека
		METHOD GetInfoExchangeStatus			VIRTUAL		// получить статус информационного обмена
		METHOD GetDeviceMetrics				VIRTUAL		// получить параметры устройства
		METHOD GetShortECRStatus				VIRTUAL		// получить краткое состояние устройства
		METHOD GetECRStatus( flag )			VIRTUAL		// получить полное состояние устройства
		METHOD SetOperatorKKT( nOp, cName )	VIRTUAL		// установить имя пользователя в устройстве
		METHOD ContinuePrint					VIRTUAL		// продолжить печать
		METHOD SetDate( date )				VIRTUAL		// устанавливает дату во внутренних часах устройства
		METHOD GetDate()						VIRTUAL		// получает дату из внутренних часов устройства
		METHOD SetTime( time )				VIRTUAL		// устанавливает время во внутренних часах устройства
		METHOD GetTime()						VIRTUAL		// получает время из внутренних часов устройства
		METHOD CutCheck( flag )				VIRTUAL		// отрезка чековой ленты
		METHOD FNOpenSession()				VIRTUAL		// открыть смену на фискальном накопителе
		METHOD Operation( oOperation )		VIRTUAL		// Операция в чеке
		METHOD CloseCheck( oCloseCheck )		VIRTUAL		// закрытие чека расширенное
		METHOD GetCashReg( nRegistr )		VIRTUAL		// запрос содержимого денежного регистра
		METHOD GetOperationReg( nRegistr )	VIRTUAL		// запрос содержимого операционного регистра
		METHOD PrintHourlyReport				VIRTUAL		// снять почасовой отчет
		METHOD PrintTaxReport				VIRTUAL		// метод печатает отчёт о продажах по налогам
		METHOD PrintDepartmentReport			VIRTUAL		// метод печатает отчёт о продажах по отделам (секциям)
		METHOD PrintCashierReport			VIRTUAL		// снять отчет по кассирам
		METHOD BuildCorrectionReceipt( obj )	VIRTUAL		// сформировать чек коррекции
		METHOD GetSaleCash					VIRTUAL		// получить накопление по виду оплат наличными операции продажа за смену
		METHOD GetSaleCard					VIRTUAL		// накопление по виду оплат банковской картой операции продажа за смену
		METHOD GetReturnSaleCash				VIRTUAL		// накопление по виду оплат наличными операции возврат продажи за смену
		METHOD GetReturnSaleCard				VIRTUAL		// накопление по виду оплат банковской картой операции возврат продажи за смену
		METHOD GetCash						VIRTUAL		// накопление наличности в кассе
		METHOD GetIncome						VIRTUAL		// внесенные суммы за смену
		METHOD GetOutcome					VIRTUAL		// выплаченные суммы за смену
		METHOD PrintCopyReceipt( number )	VIRTUAL		// печать копии чека
	
	EXPORTED:
		METHOD New()				CONSTRUCTOR
		DATA FDriver		INIT nil						// поле для хранения объекта драйвера
	
	PROTECTED:
		DATA FIsFiscalReg	INIT .f.					// поле для хранения вида устройства, кли .t. - фискальный регистратор, .f. - нет
		DATA FOpenSession	INIT .f.					// поле открытой сессии устройства
		DATA FDateDevice	INIT ctod( '' )				// поле для даты устройства
		DATA FTimeDevice	INIT 0						// поле для времени устройства
		DATA FTimeStrDevice	INIT ''						// поле для строкового представления времени устройства
	
		DATA FDeviceMetrics								// параметры устройства
		DATA FShortECRStatus							// краткое состояние устройства
		DATA FFNStatus									// статус состояния фискального накопителя
		DATA FECRStatus									// полное состояние устройства
		DATA FRNM			INIT 'NONE'					// РНМ 14 символов
		DATA FSerialNumber	INIT 'NONE'					// длинный заводской номер (от 9 до 14 символов)
		DATA FDriverLoaded	INIT .f.					// загружен ли драйвер устройства
		DATA FResultCode	INIT 0						// поле для хранения результатов выполнения операции устройства
		DATA FResultCodeDescription	INIT ''				// описание результата выполнения
		DATA FPasswordAdmin	INIT 0						// пароль администратора устройства
		DATA FPassword		INIT 0						// пароль кассира устройства
		DATA FOpenADrawer	INIT .f.					// открытие денежного ящика после печати чека
		DATA FReceiptNumber	INIT 0						// Номер чека
		DATA FDocumentNumber	INIT 0					// Номер фискального документа
		DATA FOpenDocumentNumber	INIT 0					// сквозной номер последнего документа устройства
		DATA FReceiptOpen	INIT .f.					// чек открыт
		DATA FInfoExchangeStatus	INIT 0				// статус информационного обмена
		DATA FMessageStatus	INIT 0						// состояние чтения сообщения
		DATA FMessageCount	INIT 0						// количество сообщений для ОФД
		DATA FFirstDocumentNumber INIT 0				// номер документа для ОФД первого в очереди
		DATA FDateFirstDocument INIT ctod( '' )			// дата документа для ОФД первого в очереди
		DATA FTimeFirstDocument //AS DateTime				// время документа для ОФД первого в очереди
		
		DATA FNumberPos		INIT 1
		DATA FNamePOS		INIT space( 24 )
		&& DATA FOpenADrawer	INIT .f.
		DATA FPrintDoctor	INIT .f.
		DATA FPrintPatient	INIT .f.
		DATA FChange		INIT .f.
		DATA FPrintChange	INIT .f.
		DATA FPrintCodeService	INIT .f.
		DATA FPrintNameService	INIT .f.
		DATA FEnableTypePay2	INIT .f.
		DATA FNameTypePay2	INIT space( 24 )
		DATA FEnableTypePay3	INIT .f.
		DATA FNameTypePay3	INIT space( 24 )
		DATA FEnableTypePay4	INIT .f.
		DATA FNameTypePay4	INIT space( 24 )
		
		METHOD getIsFiscalReg
		METHOD GetInfoExchangeStatus
		METHOD GetMessageStatus
		METHOD GetMessageCount
		METHOD GetFirstDocumentNumber
		METHOD GetDateFirstDocument
		METHOD GetTimeFirstDocument
		METHOD GetNumberPOS
		METHOD GetNamePOS
//		METHOD GetOpenDrawer
		METHOD GetPrintDoctor
		METHOD GetPrintPatient
		METHOD GetChange
		METHOD GetPrintChange
		METHOD GetPrintCodeService
		METHOD GetPrintNameService
		METHOD GetEnableTypePay2
		METHOD GetNameTypePay2
		METHOD GetEnableTypePay3
		METHOD GetNameTypePay3
		METHOD GetEnableTypePay4
		METHOD GetNameTypePay4
		METHOD GetRegim					VIRTUAL			// получить режим работы устройства
		&& METHOD GetSerialNumber			VIRTUAL
ENDCLASS

METHOD function getIsFiscalReg()						CLASS TAbstractKKT
	return ::FIsFiscalReg
	
// разрешить вид оплаты 2
METHOD function GetEnableTypePay2						CLASS TAbstractKKT
	return ::FEnableTypePay2
	
// название вида оплаты 2
METHOD function GetNameTypePay2						CLASS TAbstractKKT
	return ::FNameTypePay2
	
// разрешить вид оплаты 3
METHOD function GetEnableTypePay3						CLASS TAbstractKKT
	return ::FEnableTypePay3

// название вида оплаты 3
METHOD function GetNameTypePay3						CLASS TAbstractKKT
	return ::FNameTypePay3

// разрешить вид оплаты 4
METHOD function GetEnableTypePay4						CLASS TAbstractKKT
	return ::FEnableTypePay4

// название вида оплаты 4
METHOD function GetNameTypePay4						CLASS TAbstractKKT
	return ::FNameTypePay4

// печать шифра услуги
METHOD function GetPrintCodeService					CLASS TAbstractKKT
	return ::FPrintCodeService

// печать наименования услуги
METHOD function GetPrintNameService					CLASS TAbstractKKT
	return ::FPrintNameService

// печать вносимой суммы и сдачи
METHOD function GetPrintChange							CLASS TAbstractKKT
	return ::FPrintChange

// подсчет сдачи
METHOD function GetChange								CLASS TAbstractKKT
	return ::FChange

// печать пациента в чеке
METHOD function GetPrintPatient						CLASS TAbstractKKT
	return ::FPrintPatient
	
// печать врача в чеке
METHOD function GetPrintDoctor							CLASS TAbstractKKT
	return ::FPrintDoctor

// открыть денежный ящик
&& METHOD function GetOpenDrawer							CLASS TAbstractKKT
	&& return ::FOpenADrawer

// название кассы
METHOD function GetNamePOS								CLASS TAbstractKKT
	return ::FNamePOS

// номер кассового аппарата
METHOD function GetNumberPOS							CLASS TAbstractKKT
	return ::FNumberPos

// статус информационного обмена
METHOD function GetInfoExchangeStatus					CLASS TAbstractKKT
	return ::FInfoExchangeStatus

// состояние чтения сообщения
METHOD function GetMessageStatus						CLASS TAbstractKKT
	return ::FMessageStatus

// количество сообщений для ОФД
METHOD function GetMessageCount						CLASS TAbstractKKT
	return ::FMessageCount

// номер документа для ОФД первого в очереди
METHOD function GetFirstDocumentNumber					CLASS TAbstractKKT
	return ::FFirstDocumentNumber

// дата документа для ОФД первого в очереди
METHOD function GetDateFirstDocument					CLASS TAbstractKKT
	return ::FDateFirstDocument

// время документа для ОФД первого в очереди
METHOD function GetTimeFirstDocument					CLASS TAbstractKKT
	return ::FTimeFirstDocument


METHOD New()											CLASS TAbstractKKT
	return self

/*
    Open
*/
METHOD function Open( oSetting, nPasswordUser )		CLASS TAbstractKKT

	&& ::FActive := .t.
	
	::FPasswordAdmin	:= iif( valtype( oSetting:AdminPass() ) == 'C', val( oSetting:AdminPass() ), oSetting:AdminPass() )
	::FPassword := iif( valtype( nPasswordUser ) == 'C', val( nPasswordUser ), nPasswordUser )
	::FOpenADrawer		:= oSetting:OpenADrawer()
	::FNumberPos		:= oSetting:NumPOS()
	::FNamePOS			:= oSetting:NamePOS()
	::FPrintDoctor		:= oSetting:PrintDoctor()
	::FPrintPatient		:= oSetting:PrintPatient()
	::FChange			:= oSetting:ChangeEnable()
	::FPrintChange		:= oSetting:ChangePrint()
	::FPrintCodeService	:= oSetting:PrintCodeUsl()
	::FPrintNameService	:= oSetting:PrintNameUsl()
	::FEnableTypePay2	:= oSetting:EnableTypePay2()
	::FNameTypePay2		:= oSetting:NameTypePay2()
	::FEnableTypePay3	:= oSetting:EnableTypePay3()
	::FNameTypePay3		:= oSetting:NameTypePay3()
	::FEnableTypePay4	:= oSetting:EnableTypePay4()
	::FNameTypePay4		:= oSetting:NameTypePay4()
	
	&& ::_cFabricNumber	:= oSetting:FRNumber()
	&& ::_avtoPKO_Z_Rep	:= oSetting:getAvtoPKO()
	return .t.
	
/*
    Destroy
*/
METHOD procedure Destroy()							CLASS TAbstractKKT
	local driver

    driver := ::FDriver
	if hb_isObject( driver )
		::FDriver := nil
		::FDeviceMetrics := nil
		::FShortECRStatus := nil
		::FECRStatus := nil
	endif
	&& ::FActive := .f.
	return
