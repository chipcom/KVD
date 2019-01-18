#include 'property.ch'
#include "hbclass.ch"

//
// Class TServiceKKT
//
CLASS TServiceKKT
    EXPORTED:
		PROPERTY IsFiscalReg READ getIsFiscalReg
		PROPERTY Change READ getChange
		PROPERTY EnableTypePay2 READ getEnableTypePay2	// разрешить вид оплаты 2
		PROPERTY EnableTypePay3 READ getEnableTypePay3	// разрешить вид оплаты 3
		PROPERTY EnableTypePay4 READ getEnableTypePay4	// разрешить вид оплаты 4
		PROPERTY NameTypePay2 READ getNameTypePay2		// название вида оплаты 2
		PROPERTY NameTypePay3 READ getNameTypePay3		// название вида оплаты 3
		PROPERTY NameTypePay4 READ getNameTypePay4		// название вида оплаты 4
		PROPERTY OtherTypePay READ getOtherTypePay
		
		METHOD PrintPatient	INLINE ::FKKT:PrintPatient
		METHOD PrintDoctor	INLINE ::FKKT:PrintDoctor
		METHOD PrintCodeService	INLINE ::FKKT:PrintCodeService
		METHOD PrintNameService	INLINE ::FKKT:PrintNameService
		METHOD OpenADrawer	INLINE ::FKKT:OpenADrawer
		METHOD SerialNumber	INLINE ::FKKT:SerialNumber	// получить длинный заводской номер (от 9 до 14 символов)
		METHOD OpenSession	INLINE ::FKKT:OpenSession	// признак открытой сессии
		
		METHOD Driver 		INLINE ::FKKT:FDriver
		METHOD IsLoaded 		INLINE ::FKKT:IsLoaded		// драйвер загружен
		METHOD PasswordAdmin	INLINE ::FKKT:PasswordAdmin	// пароль администратора
		METHOD Password		INLINE ::FKKT:Password		// пароль
		METHOD RegimKKT		INLINE ::FKKT:RegimKKT		// получить режим работы устройства
		METHOD InfoExchangeStatus	INLINE ::FKKT:InfoExchangeStatus	// статус информационного обмена
		METHOD MessageStatus	INLINE ::FKKT:MessageStatus// состояние чтения сообщения
		METHOD MessageCount	INLINE ::FKKT:MessageCount	// количество сообщений для ОФД
		METHOD FirstDocumentNumber	INLINE ::FKKT:FirstDocumentNumber	// номер документа для ОФД первого в очереди
		METHOD DateFirstDocument	INLINE ::FKKT:DateFirstDocument	// дата документа для ОФД первого в очереди
		METHOD TimeFirstDocument	INLINE ::FKKT:TimeFirstDocument	// время документа для ОФД первого в очереди
		
		METHOD SetKKT( typeKKT )
		METHOD CheckExchangeStatus( flag )						// Проверка статуса обмена
		METHOD New() CONSTRUCTOR
		METHOD Init
		METHOD Open
		METHOD ShowProperties()
		METHOD Version
		METHOD Beep
		METHOD PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )
		METHOD OpenDrawer( nDrawerNumber )			// открыть денежный ящик
		METHOD CashIncome( summ1 )					// внесение денежной суммы в кассу
		METHOD CashOutcome( summ1 )					// выплата денежной суммы из кассы
		METHOD FeedDocument( flag, numStr )			// продвинуть документ
		METHOD GetDeviceMetrics						// получить параметры устройства
		METHOD GetShortECRStatus						// получить краткое состояние фискального регистратора
		METHOD GetECRStatus( flag )					// получить полное состояние устройства
		METHOD FNGetStatus							// получить состояние фискального накопителя устройства
		METHOD GetLongSerialNumberAndLongRNM			// получить длинные заводской номер и РНМ
		METHOD PrintReportWithoutCleaning			// снять отчет без гашения
		METHOD PrintReportWithCleaning				// снять отчет с гашением
		METHOD CancelCheck							// отмена чека
		METHOD GetInfoExchangeStatus				// получить статус информационного обмена
		METHOD SetOperatorKKT( nOp, cName )			// установить имя пользователя в устройстве
		METHOD ContinuePrint							// продолжить печать
		METHOD SetDate( date )						// устанавливает дату во внутренних часах устройства
		METHOD GetDate()								// получает дату из внутренних часов устройства
		METHOD SetTime( time )						// устанавливает время во внутренних часах устройства
		METHOD GetTime()								// получает время из внутренних часов устройства
		METHOD CutCheck( flag )						// отрезка чековой ленты
		METHOD FNOpenSession()						// открыть смену на фискальном накопителе
		METHOD Operation( oOperation )				// операция в чеке
		METHOD CloseCheck( oCloseCheck )				// закрытие чека расширенное
		METHOD GetCashReg( nRegistr )				// запрос содержимого денежного регистра
		METHOD GetOperationReg( nRegistr )			// запрос содержимого операционного регистра
		METHOD PrintHourlyReport						// снять почасовой отчет
		METHOD PrintTaxReport						// метод печатает отчёт о продажах по налогам
		METHOD PrintDepartmentReport					// метод печатает отчёт о продажах по отделам (секциям)
		METHOD PrintCashierReport					// снять отчет по кассирам
		METHOD BuildCorrectionReceipt( obj )			// сформировать чек коррекции
		METHOD GetSaleCash							// получить накопление по виду оплат наличными операции продажа за смену
		METHOD GetSaleCard							// накопление по виду оплат банковской картой операции продажа за смену
		METHOD GetReturnSaleCash						// накопление по виду оплат наличными операции возврат продажи за смену
		METHOD GetReturnSaleCard						// накопление по виду оплат банковской картой операции возврат продажи за смену
		METHOD GetCash								// накопление наличности в кассе
		METHOD GetIncome								// внесенные суммы за смену
		METHOD GetOutcome							// выплаченные суммы за смену
		METHOD PrintCopyReceipt( number )			// печать копии чека
    HIDDEN:
		DATA FKKT
		METHOD getIsFiscalReg
		METHOD getChange
		METHOD getOtherTypePay
		METHOD getEnableTypePay2
		METHOD getEnableTypePay3
		METHOD getEnableTypePay4
		METHOD getNameTypePay2
		METHOD getNameTypePay3
		METHOD getNameTypePay4
	PROTECTED:
ENDCLASS

METHOD function getNameTypePay2()				CLASS TServiceKKT
	return ::FKKT:NameTypePay2

METHOD function getNameTypePay3()				CLASS TServiceKKT
	return ::FKKT:NameTypePay3

METHOD function getNameTypePay4()				CLASS TServiceKKT
	return ::FKKT:NameTypePay4

METHOD function getEnableTypePay2()			CLASS TServiceKKT
	return ::FKKT:EnableTypePay2

METHOD function getEnableTypePay3()			CLASS TServiceKKT
	return ::FKKT:EnableTypePay3

METHOD function getEnableTypePay4()			CLASS TServiceKKT
	return ::FKKT:EnableTypePay4

METHOD function getOtherTypePay()				CLASS TServiceKKT
	return ::FKKT:EnableTypePay2 .or. ::FKKT:EnableTypePay3 .or. ::FKKT:EnableTypePay4

METHOD function getChange()					CLASS TServiceKKT
	return ::FKKT:Change

METHOD function getIsFiscalReg()				CLASS TServiceKKT
	return ::FKKT:IsFiscalReg

// печать копии чека
METHOD PrintCopyReceipt( number )			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintCopyReceipt( number )
	endif
	return ret

// накопление по виду оплат банковской картой операции возврат продажи за смену
METHOD function GetReturnSaleCard				CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetReturnSaleCard()
	endif
	return ret

// накопление по виду оплат наличными операции возврат продажи за смену
METHOD function GetReturnSaleCash				CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetReturnSaleCash()
	endif
	return ret

// накопление по виду оплат банковской картой операции продажа за смену
METHOD function GetSaleCard					CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetSaleCard()
	endif
	return ret

// выплаченные суммы за смену
METHOD function GetOutcome						CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetOutcome()
	endif
	return ret

// внесенные суммы за смену
METHOD function GetIncome()					CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetIncome()
	endif
	return ret

// накопление наличности в кассе
METHOD function GetCash()						CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetCash()
	endif
	return ret

// получить накопление по виду оплат наличными операции продажа за смену
METHOD function GetSaleCash()					CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetSaleCash()
	endif
	return ret

METHOD procedure CheckExchangeStatus( flag )	CLASS TServiceKKT
	local strMessage := ''

	if ::IsFiscalReg
		::FKKT:FNGetStatus()
		::FKKT:GetInfoExchangeStatus()
		if ::MessageCount > 0
			strMessage := 'Внимание имеется ' + alltrim( str( ::FKKT:MessageCount ) ) + ;
				' не отправленн' + iif( ::FKKT:MessageCount == 1, 'ый документ', 'ых документов' ) + ' в ОФД!' + ;
				chr( 10 ) + 'Дата первого неотправленного документа: ' + dtoc( ::FKKT:DateFirstDocument ) + ' г.'
			hb_Alert( strMessage, , , 4 )
		elseif hb_DefaultValue( flag, .t. )
			hb_Alert( 'Отсутствуют не отправленные в ОФД документы', , , 4 )
		endif
	endif
	return


METHOD New()									CLASS TServiceKKT
	return self

// загрузить драйвер ККТ
METHOD function Init()							CLASS TServiceKKT
	return ::FKKT:Init

// сформировать чек коррекции
METHOD BuildCorrectionReceipt( obj )			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:BuildCorrectionReceipt( obj )
	endif
	return ret

// метод печатает отчёт о продажах по налогам
METHOD procedure PrintTaxReport				CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintTaxReport()
	endif
	return ret

// метод печатает отчёт о продажах по отделам (секциям)
METHOD procedure PrintDepartmentReport		CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintDepartmentReport()
	endif
	return ret

// снять отчет по кассирам
METHOD procedure PrintCashierReport			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintCashierReport()
	endif
	return ret

// снять почасовой отчет
METHOD procedure PrintHourlyReport			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintHourlyReport()
	endif
	return ret

// запрос содержимого операционного регистра
// nRegistr - номер денежного регистра
METHOD function GetOperationReg( nRegistr )	CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetOperationReg( nRegistr )
	endif
	return ret

// Запрос содержимого денежного регистра
// nRegistr - номер денежного регистра
METHOD function GetCashReg( nRegistr )			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetCashReg( nRegistr )
	endif
	return ret


// загрузить настройки ККТ
METHOD function Open( oSettings, nPasswordUser )	CLASS TServiceKKT
	return ::FKKT:Open( oSettings, nPasswordUser )

// закрытие чека расширенное
METHOD function CloseCheck( oCloseCheck )		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:CloseCheck( oCloseCheck )
	endif
	return ret

// Операция в чеке
//  service - объект услуга для чека TServiceOfCheck
//  stringForPrinting   - наименование товара/услуги
METHOD function Operation( oOperation )		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:Operation( oOperation )
	endif
	return ret

// открыть смену на фискальном накопителе
METHOD function FNOpenSession()				CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:FNOpenSession()
	endif
	return ret

// отрезка чековой ленты
// flag - 0 полная отрезка
//        1 частичный отрез
METHOD CutCheck( flag )						CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:CutCheck( flag )
	endif
	return ret

// устанавливает дату во внутренних часах устройства
METHOD function SetDate( date )					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:SetDate( date )
	endif
	return ret

// получает дату из внутренних часов устройства
METHOD function GetDate()						CLASS TServiceKKT
	local ret := ctod( '' )
	
	if ::IsLoaded
		ret := ::FKKT:GetDate()
	endif
	return ret

// получает время из внутренних часов устройства
METHOD function SetTime( time )					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:SetDate( time )
	endif
	return ret

// получает время из внутренних часов устройства
METHOD function GetTime()						CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetTime()
	endif
	return ret

// продолжить печать
METHOD function ContinuePrint()				CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:ContinuePrint
	endif
	return ret

// установить имя пользователя в устройстве
METHOD function SetOperatorKKT( nOp, cName )	CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:SetOperatorKKT( nOp, cName )
	endif
	return ret

// получить версию драйвера ККТ
METHOD function Version()						CLASS TServiceKKT
	local ret := 'Драйвер не загружен.'
	
	if ::IsLoaded
		ret := ::FKKT:Version
	endif
	return ret

// получить статус информационного обмена
METHOD function GetInfoExchangeStatus()					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetInfoExchangeStatus()
	endif
	return ret

// отмена чека
METHOD function CancelCheck()					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:CancelCheck()
	endif
	return ret

// издать гудок
METHOD function Beep()						CLASS TServiceKKT
	local ret := 'Драйвер не загружен.'
	
	if ::IsLoaded
		ret := ::FKKT:Beep()
	endif
	return ret

// снять отчет без гашения
METHOD PrintReportWithoutCleaning()		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:PrintReportWithoutCleaning()
	endif
	return ret

// снять отчет с гашением
METHOD PrintReportWithCleaning()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:PrintReportWithCleaning()
	endif
	return ret

// открыть денежный ящик
METHOD function OpenDrawer( nDrawerNumber )	CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded .and. ::FOpenADrawer
		ret := ::FKKT:OpenDrawer( nDrawerNumber )
	endif
	return ret

// внесение денежной суммы в кассу
METHOD function CashIncome( summ1 )					CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded
		ret := ::FKKT:CashIncome( summ1 )
	endif
	return ret

// выплата денежной суммы из кассы
METHOD function CashOutcome( summ1 )					CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded
		ret := ::FKKT:CashOutcome( summ1 )
	endif
	return ret

// продвинуть документ
METHOD function FeedDocument( flag, numStr )			CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded
		ret := ::FKKT:FeedDocument( flag, numStr )
	endif
	return ret

// получить параметры устройства
METHOD function GetDeviceMetrics()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetDeviceMetrics()
	endif
	return ret

// получить краткое состояние устройства
METHOD function GetShortECRStatus()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetShortECRStatus()
	endif
	return ret

// получить полное состояние устройства
METHOD function GetECRStatus( flag )			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetECRStatus( flag )
	endif
	return ret

// получить состояние фискального накопителя устройства
METHOD function FNGetStatus()					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:FNGetStatus()
	endif
	return ret

// получить длинные заводской номер и РНМ
METHOD function GetLongSerialNumberAndLongRNM()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetLongSerialNumberAndLongRNM()
	endif
	return ret

// печать строки текста на ККТ
METHOD function PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )
	endif
	return ret

// показать свойства драйвера ККТ
METHOD function ShowProperties()				CLASS TServiceKKT
	return ::FKKT:ShowProperties

// установить объект драйвера
METHOD procedure SetKKT( typeKKT )			CLASS TServiceKKT

    ::FKKT := typeKKT
	return