#include 'property.ch'
#include 'hbclass.ch'

CLASS TKKT_None FROM TAbstractKKT

    EXPORTED:
		METHOD ShowProperties()
		METHOD Version()
		METHOD Init
		METHOD Open( oSetting )
		METHOD Beep
		METHOD PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )
		METHOD OpenDrawer( nDrawerNumber )			// открыть денежный ящик
		METHOD CashIncome( summ1 )					// внесение денежной суммы в кассу
		METHOD CashOutcome( summ1 )					// выплата денежной суммы из кассы
		METHOD FeedDocument( flag, numStr )			// продвинуть документ
		METHOD GetDeviceMetrics						// получить параметры устройства
		METHOD GetShortECRStatus						// получить краткое состояние устройства
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
		METHOD Operation( oOperation )				// Операция в чеке
		METHOD CloseCheck( oCloseCheck )				// закрытие чека расширенное
		METHOD GetCashReg( nRegistr )				// Запрос содержимого денежного регистра
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
	PROTECTED:
		METHOD GetRegim								// получить режим работы устройства
	
ENDCLASS

// печать копии чека
METHOD PrintCopyReceipt( number )					CLASS TKKT_None
	return .t.

// накопление по виду оплат банковской картой операции возврат продажи за смену
METHOD function GetReturnSaleCard						CLASS TKKT_None
	return 0

// накопление по виду оплат наличными операции возврат продажи за смену
METHOD function GetReturnSaleCash						CLASS TKKT_None
	return 0

// накопление по виду оплат банковской картой операции продажа за смену
METHOD function GetSaleCard							CLASS TKKT_None
	return 0

// выплаченные суммы за смену
METHOD function GetOutcome()							CLASS TKKT_None
	return 0

// внесенные суммы за смену
METHOD function GetIncome()							CLASS TKKT_None
	return 0

// накопление наличности в кассе
METHOD function GetCash()								CLASS TKKT_None
	return 0

// получить накопление по виду оплат наличными операции продажа за смену
METHOD GetSaleCash()									CLASS TKKT_None
	return 0

// сформировать чек коррекции
METHOD BuildCorrectionReceipt( obj )					CLASS TKKT_None
	return .t.

// метод печатает отчёт о продажах по налогам
METHOD procedure PrintTaxReport						CLASS TKKT_None
	return .t.

// метод печатает отчёт о продажах по отделам (секциям)
METHOD procedure PrintDepartmentReport				CLASS TKKT_None
	return .t.

// снять отчет по кассирам
METHOD procedure PrintCashierReport					CLASS TKKT_None
	return .t.

// снять почасовой отчет
METHOD procedure PrintHourlyReport					CLASS TKKT_None
	return .t.

// загрузить драйвер ККТ
METHOD function Init()									CLASS TKKT_None
	::FDriverLoaded := .t.
	return .t.

// запрос содержимого операционного регистра
// nRegistr - номер денежного регистра
METHOD function GetOperationReg( nRegistr )			CLASS TKKT_None
	return 0

// Запрос содержимого денежного регистра
// 	nRegistr - номер денежного регистра
METHOD function GetCashReg( nRegistr )					CLASS TKKT_None
	return 0

// закрытие чека расширенное
METHOD function CloseCheck( oCloseCheck )				CLASS TKKT_None
	return .t.

// Операция в чеке
METHOD function Operation( oOperation )				CLASS TKKT_None
	return .t.
	
// открыть смену на фискальном накопителе
METHOD function FNOpenSession()						CLASS TKKT_None
	::FOpenSession := .t.
	return .t.

// отрезка чековой ленты
METHOD CutCheck( flag )								CLASS TKKT_None
	return .t.

// устанавливает дату во внутренних часах устройства
METHOD function SetDate( date )							CLASS TKKT_None
	return .t.

// получает дату из внутренних часов устройства
METHOD function GetDate()								CLASS TKKT_None
	return ctod( '' )

// устанавливает время во внутренних часах устройства
METHOD function SetTime( time )							CLASS TKKT_None
	return .t.

// получает время из внутренних часов устройства
METHOD function GetTime()								CLASS TKKT_None
	return 0

// продолжить печать
METHOD function ContinuePrint()						CLASS TKKT_None
	return .t.

// установить имя пользователя в устройстве
METHOD function SetOperatorKKT( nOp, cName )			CLASS TKKT_None
	return .t.

// получить статус информационного обмена
METHOD function GetInfoExchangeStatus()				CLASS TKKT_None
	return .t.

// отмена чека
METHOD function CancelCheck()							CLASS TKKT_None
	return .t.

// снять отчет без гашения
METHOD function PrintReportWithoutCleaning()			CLASS TKKT_None
	return .t.

// снять отчет с гашением
METHOD function PrintReportWithCleaning()				CLASS TKKT_None
	return .t.

// издать гудок
METHOD function Beep()									CLASS TKKT_None
	return .t.

// получить режим работы устройства
METHOD function GetRegim								CLASS TKKT_None
	return -1

// получить длинный заводской номер (от 9 до 14 символов)
&& METHOD function GetSerialNumber						CLASS TKKT_None
	&& return 'NONE'

// получить параметры устройства
METHOD function GetDeviceMetrics()						CLASS TKKT_None
	return .t.

// открыть денежный ящик
METHOD function OpenDrawer( nDrawerNumber )			CLASS TKKT_None
	return .t.

// внесение денежной суммы в кассу
METHOD function CashIncome( summ1 )					CLASS TKKT_None
	return .t.

// выплата денежной суммы из кассы
METHOD function CashOutcome( summ1 )					CLASS TKKT_None
	return .t.

// продвинуть документ
METHOD function FeedDocument( flag, numStr )			CLASS TKKT_None
	return .t.

// получить краткое состояние устройства
METHOD function GetShortECRStatus()					CLASS TKKT_None
	return .t.

// получить полное состояние устройства
METHOD function GetECRStatus( flag )					CLASS TKKT_None
	return .t.

// получить состояние фискального накопителя устройства
METHOD function FNGetStatus()							CLASS TKKT_None
	return .t.

// получить длинные заводской номер и РНМ
METHOD function GetLongSerialNumberAndLongRNM()		CLASS TKKT_None
	return .t.

// печать строки текста на ККТ
METHOD function PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )		CLASS TKKT_None
	return .t.

// загрузить настройки ККТ
//METHOD function Open( oSetting, nPasswordUser )		CLASS TKKT_None
METHOD function Open( oSetting, oUser )		CLASS TKKT_None
	::FIsFiscalReg := .f.
	return .t.
	
// показать свойства драйвера ККТ
METHOD function ShowProperties()						CLASS TKKT_None
	return 'Просмотр свойств не доступен'

// получить версию драйвера ККТ
METHOD function Version()								CLASS TKKT_None
	return '1.0'
