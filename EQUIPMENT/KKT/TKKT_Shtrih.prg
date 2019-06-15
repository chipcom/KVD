#include 'property.ch'
#include 'hbclass.ch'
#include 'windows.ch'
#include 'f_fr_bay.ch'

#define COUNTER_REPEAT	5	// число повторов обращений к ККТ

CLASS TKKT_Shtrih FROM TAbstractKKT

    EXPORTED:
		METHOD New()
		METHOD ShowProperties()
		METHOD Version()
		METHOD Init
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
		METHOD GetInfoExchangeStatus					// получить статус информационного обмена
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
	HIDDEN:
		METHOD ConfirmDate( date )					// команда подтверждения программирования даты во внутренних часах устройства
		METHOD ExecuteCommand( command, lSilent )
		METHOD ErrorHandling( descFunc, lSilent )
		METHOD SendINNCashier()						// Отправить тег с ИНН кассира
	PROTECTED:
		METHOD GetRegim								// получить режим работы устройства
ENDCLASS

// печать копии чека
METHOD PrintCopyReceipt( number )					CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	::FDriver:DocumentNumber := number
	ret := ::ExecuteCommand( 'FNPrintDocument', .f. )
	return ret

// накопление по виду оплат банковской картой операции возврат продажи за смену
METHOD function GetReturnSaleCard						CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_RETURN_SALE_CARD )
	return ret

// накопление по виду оплат наличными операции возврат продажи за смену
METHOD function GetReturnSaleCash						CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_RETURN_SALE_CASH )
	return ret

// накопление по виду оплат банковской картой операции продажа за смену
METHOD function GetSaleCard							CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_SALE_CARD )
	return ret

// выплаченные суммы за смену
METHOD function GetOutcome()							CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_OUTCOME )
	return ret

// внесенные суммы за смену
METHOD function GetIncome()							CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_INCOME )
	return ret

// накопление наличности в кассе
METHOD function GetCash()								CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_CASH )
	return ret

// получить накопление по виду оплат наличными операции продажа за смену
METHOD GetSaleCash()									CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_SALE_CASH )
	return ret

// сформировать чек коррекции
METHOD BuildCorrectionReceipt( obj )					CLASS TKKT_Shtrih
	local ret := .f.
	
	&& ::FDriver:Password := ::PasswordAdmin
	&& if ( ret := ::ExecuteCommand( 'FNBeginCorrectionReceipt', .f. ) )
		::FDriver:Password := ::PasswordAdmin
		::FDriver:CorrectionType := obj:CorrectionType
		::FDriver:CalculationSign := obj:CalculationSign
		::FDriver:Summ1 := obj:Summ1
		::FDriver:Summ2 := obj:Summ2
		::FDriver:Summ3 := obj:Summ3
		::FDriver:Summ4 := obj:Summ4
		::FDriver:Summ5 := obj:Summ5
		::FDriver:Summ6 := obj:Summ6
		::FDriver:Summ7 := obj:Summ7
		::FDriver:Summ8 := obj:Summ8
		::FDriver:Summ9 := obj:Summ9
		::FDriver:Summ10 := obj:Summ10
		::FDriver:Summ11 := obj:Summ11
		::FDriver:Summ12 := obj:Summ12
		::FDriver:TaxType := obj:TaxType
		ret := ::ExecuteCommand( 'FNBuildCorrectionReceipt2', .f. )
	&& endif
	return ret

// запрос содержимого операционного регистра
// nRegistr - номер денежного регистра
METHOD function GetOperationReg( nRegistr )			CLASS TKKT_Shtrih
	local ret := 0, result := .f.
		
	::FDriver:Password := ::Password
	::FDriver:RegisterNumber := nRegistr
	if ( result := ::ExecuteCommand( 'GetOperationReg', .f. ) )
		ret := ::FDriver:ContentsOfOperationRegister
	endif
	return ret

// Запрос содержимого денежного регистра
// 	nRegistr - номер денежного регистра
METHOD function GetCashReg( nRegistr )					CLASS TKKT_Shtrih
	local ret := 0, result := .f.
		
	::FDriver:Password := ::Password
	::FDriver:RegisterNumber := nRegistr
	if ( result := ::ExecuteCommand( 'GetCashReg', .f. ) )
		ret := ::FDriver:ContentsOfCashRegister
	endif
	return ret

// закрытие чека расширенное
//	oCloseCheck - объект описывающий операцию закрытия чека
METHOD function CloseCheck( oCloseCheck )			CLASS TKKT_Shtrih
	local ret := -1, result := .f., address
	
	// пошлем ИНН кассира перед закрытием чека
//	if !empty( ::INNCashier )
//		::FDriver:Password := ::Password
//		::FDriver:TagNumber := 1203
//		::FDriver:TagType := 7
//		::FDriver:TagValueStr := ::INNCashier //'770405970581' //Здесь указываем реальный ИНН Кассира.
////		::FDriver:FNSendTag()
//		::ExecuteCommand( 'FNSendTag' )
//	endif
	::SendINNCashier()	
	HB_CDPSELECT( 'RU1251' )
//	::FDriver:Password := ::Password
	
	with object oCloseCheck
		if !empty( alltrim( :CustomerEmail ) )
			::FDriver:Password := ::Password
			::FDriver:CustomerEmail = :CustomerEmail
			::FDriver:FNSendCustomerEmail()
		endif
		::FDriver:Password := ::Password
		::FDriver:Summ1 := :Summ1
		::FDriver:Summ2 := :Summ2 
		::FDriver:Summ3 := :Summ3 
		::FDriver:Summ4 := :Summ4 
		::FDriver:Summ5 := :Summ5 
		::FDriver:Summ6 := :Summ6 
		::FDriver:Summ7 := :Summ7 
		::FDriver:Summ8 := :Summ8 
		::FDriver:Summ9 := :Summ9 
		::FDriver:Summ10 := :Summ10
		::FDriver:Summ11 := :Summ11
		::FDriver:Summ12 := :Summ12
		::FDriver:Summ13 := :Summ13
		::FDriver:Summ14 := :Summ14
		::FDriver:Summ15 := :Summ15
		::FDriver:Summ16 := :Summ16
		::FDriver:RoundingSumm := :RoundingSumm
		::FDriver:TaxValue1 := :TaxValue1
		::FDriver:TaxValue2 := :TaxValue2
		::FDriver:TaxValue3 := :TaxValue3
		::FDriver:TaxValue4 := :TaxValue4
		::FDriver:TaxValue5 := :TaxValue5
		::FDriver:TaxValue6 := :TaxValue6
		::FDriver:TaxType := :TaxType
		::FDriver:StringForPrinting := :StringForPrinting
	endwith
	if ( ::ExecuteCommand( 'FNCloseCheckEx' ) )
		ret := ::FDriver:DocumentNumber
	endif
	return ret

// Операция в чеке
//  oOperation - объект для операции в чеке
METHOD function Operation( oOperation )			CLASS TKKT_Shtrih
	local ret := .f.

	HB_CDPSELECT( 'RU1251' )
	::FDriver:Password := ::Password
	::FDriver:CheckType := oOperation:CheckType // Тип операции: 1-приход, 2-возврат прихода, 3-расход, 4-возврат расхода
	::FDriver:Quantity := oOperation:Quantity
	::FDriver:Price    := oOperation:Price
	::FDriver:Summ1    := oOperation:Summ1
	::FDriver:Summ1Enabled := oOperation:Summ1Enabled
	::FDriver:TaxValue := oOperation:TaxValue
	::FDriver:TaxValueEnabled := oOperation:TaxValueEnabled
	::FDriver:Tax1    := oOperation:Tax1
	::FDriver:Department := oOperation:Department
	::FDriver:PaymentTypeSign    := oOperation:PaymentTypeSign // полный расчет
	::FDriver:PaymentItemSign    := oOperation:PaymentItemSign // услуга
	::FDriver:StringForPrinting := upper( dos2win( oOperation:StringForPrinting ) )
	::FReceiptOpen := ( ret := ::ExecuteCommand( 'FNOperation' ) )
	HB_CDPSELECT( 'RU866' )
	return ret

// открыть смену на фискальном накопителе
METHOD function FNOpenSession()						CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::Password
	::ExecuteCommand( 'FNBeginOpenSession' )
	::SendINNCashier()
	::FDriver:Password := ::Password
	if ( ret := ::ExecuteCommand( 'FNOpenSession' ) )
		// ожидаем окончания печати
		::FDriver:Password := ::Password
		::ExecuteCommand( 'WaitForPrinting' )
		::FOpenSession := .t.
	endif
	return ret

// отрезка чековой ленты
// flag - 0 полная отрезка
//        1 частичный отрез
METHOD CutCheck( flag )								CLASS TKKT_Shtrih
	local ret := .f.
	
//	HB_Default( @flag, 0 ) 
	::FDriver:Password := ::Password
	::FDriver:CutType := iif( HB_DefaultValue( flag, 1 ) == 1, 1, 0 )
	ret := ::ExecuteCommand( 'CutCheck' )
	return ret

// команда подтверждения программирования даты во внутренних часах устройства
METHOD ConfirmDate( date )							CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	::FDriver:Date := date
	ret := ::ExecuteCommand( 'ConfirmDate' )
	return ret

// устанавливает дату во внутренних часах устройства
METHOD function SetDate( date )							CLASS TKKT_Shtrih
	local ret := .f.
	local regim, strTitle := 'Установка даты и времени в кассовом аппарате'
	local str := 'Режим предназначен для изменения даты или времени в кассовом аппарате.' + chr( 13 ) + chr( 10 ) + ;
		'Выполняется только при закрытой смене!' + chr( 13 ) + chr( 10 ) + 'Вы хотите закрыть смену?'

	if ( regim := ::GetRegim() ) != -1
		if regim != ECRMODE_CLOSE
			if hwg_MsgNoYesBay( str, strTitle )
				ret := ::PrintReportWithCleaning()
			endif
		else
			ret := .t.
		endif
	endif
	if ret
		::FDriver:Password := ::PasswordAdmin
		::FDriver:Date := date
		if ( ret := ::ExecuteCommand( 'SetDate' ) )
			ret := ::ConfirmDate( date )
		endif
	endif
	return ret

// получает дату из внутренних часов устройства
METHOD function GetDate()								CLASS TKKT_Shtrih
	local ret := ctod( '' )
	
	if ::GetECRStatus( .t. )
		ret := ::FECRStatus[ 'DATE' ]
	endif
	return ret

// устанавливает время во внутренних часах устройства
//  time   - время в формате ЧЧ:ММ:СС
METHOD function SetTime( time )							CLASS TKKT_Shtrih
	local ret := .f.
	local regim, strTitle := 'Установка даты и времени в кассовом аппарате'
	local str := 'Режим предназначен для изменения даты или времени в кассовом аппарате.' + chr( 13 ) + chr( 10 ) + ;
		'Выполняется только при закрытой смене!' + chr( 13 ) + chr( 10 ) + 'Вы хотите закрыть смену?'

	if ( regim := ::GetRegim() ) != -1
		if regim != ECRMODE_CLOSE
			if hwg_MsgNoYesBay( str, strTitle )
				ret := ::PrintReportWithCleaning()
			endif
		else
			ret := .t.
		endif
	endif
	if ret
		::FDriver:Password := ::PasswordAdmin
		::FDriver:Time := time
		ret := ::ExecuteCommand( 'SetTime' )
	endif
	return ret

// получает время из внутренних часов устройства
METHOD function GetTime()								CLASS TKKT_Shtrih
	local ret := 0
	
	if ::GetECRStatus( .t. )
		ret := ::FECRStatus[ 'TIME' ]
	endif
	return ret

// продолжить печать
METHOD function ContinuePrint()						CLASS TKKT_Shtrih
	local ret := .f.

	if ::GetRegim() == 3
		::FDriver:Password := ::Password
		ret := ::ExecuteCommand( 'ContinuePrint' )
	endif
	return ret

// установить имя пользователя в устройстве
METHOD function SetOperatorKKT( operatorNumber, cName )			CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:RowNumber := operatorNumber
	::FDriver:TableNumber := 2
	::FDriver:FieldNumber := 2
	::FDriver:Password := ::PasswordAdmin
		
	if ( ret := ::ExecuteCommand( 'GetFieldStruct' ) )
		::FDriver:ValueOfFieldString := upper( left( cName, ::FDriver:FieldSize ) )
		::FDriver:RowNumber := operatorNumber
		::FDriver:TableNumber := 2
		::FDriver:FieldNumber := 2
		::FDriver:Password := ::PasswordAdmin
		ret := ::ExecuteCommand( 'WriteTable' )
	endif
	return ret

// получить статус информационного обмена
METHOD function GetInfoExchangeStatus()				CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	if ( ret := ::ExecuteCommand( 'FNGetInfoExchangeStatus' ) )
		::FInfoExchangeStatus := ::FDriver:InfoExchangeStatus
		::FMessageStatus := ::FDriver:MessageState
		::FMessageCount := ::FDriver:MessageCount
		::FFirstDocumentNumber := ::FDriver:DocumentNumber
		::FDateFirstDocument := ::FDriver:Date
		::FTimeFirstDocument := ::FDriver:Time
		::FDriver:Password := ::PasswordAdmin
		if ( ret := ::ExecuteCommand( 'ReadSerialNumber' ) )
			::FSerialNumber := ::FDriver:SerialNumber
		endif
	endif
	return ret

// отмена чека
METHOD function CancelCheck()							CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	ret := ::ExecuteCommand( 'CancelCheck' )
	return ret

// снять отчет без гашения
METHOD function PrintReportWithoutCleaning()			CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::PasswordAdmin
	ret := ::ExecuteCommand( 'PrintReportWithoutCleaning' )
	return ret

// снять отчет с гашением
METHOD function PrintReportWithCleaning()				CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := 'Снятие отчета'
	local strCloseReport := 'Закрытая смена.' + chr( 13 ) + chr( 10 ) + 'Снятие отчета с гашением невозможно!'

	if ( regim := ::GetRegim() ) != -1
		if regim == ECRMODE_CLOSE
			hwg_MsgInfoBay( strCloseReport, strTitle )
			ret := .f.
		else
			::FDriver:Password := ::Password
			::ExecuteCommand( 'FNBeginCloseSession' )
			::SendINNCashier()
			::FDriver:Password := ::Password
			if ( ret := ::ExecuteCommand( 'FNCloseSession' ) )
				::FOpenSession := .f.
			endif
		endif
	endif
	return ret

// метод печатает отчёт о продажах по налогам
METHOD procedure PrintTaxReport						CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := 'Снятие отчета'
	local strCloseReport := 'Закрытая смена.' + chr( 13 ) + chr( 10 ) + 'Снятие отчета по налогам невозможно!'

	if ( regim := ::GetRegim() ) != -1
		if regim == ECRMODE_CLOSE
			hwg_MsgInfoBay( strCloseReport, strTitle )
			ret := .f.
		else
			::FDriver:Password := ::PasswordAdmin
			ret := ::ExecuteCommand( 'PrintTaxReport' )
		endif
	endif
	return ret

// метод печатает отчёт о продажах по отделам (секциям)
METHOD procedure PrintDepartmentReport				CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := 'Снятие отчета'
	local strCloseReport := 'Закрытая смена.' + chr( 13 ) + chr( 10 ) + 'Снятие отчета по подразделениям невозможно!'

	if ( regim := ::GetRegim() ) != -1
		if regim == ECRMODE_CLOSE
			hwg_MsgInfoBay( strCloseReport, strTitle )
			ret := .f.
		else
			::FDriver:Password := ::PasswordAdmin
			ret := ::ExecuteCommand( 'PrintDepartmentReport' )
		endif
	endif
	return ret

// снять отчет по кассирам
METHOD procedure PrintCashierReport					CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := 'Снятие отчета'
	local strCloseReport := 'Закрытая смена.' + chr( 13 ) + chr( 10 ) + 'Снятие отчета по кассирам невозможно!'

	if ( regim := ::GetRegim() ) != -1
		if regim == ECRMODE_CLOSE
			hwg_MsgInfoBay( strCloseReport, strTitle )
			ret := .f.
		else
			::FDriver:Password := ::PasswordAdmin
			ret := ::ExecuteCommand( 'PrintCashierReport' )
		endif
	endif
	return ret

// снять почасовой отчет
METHOD procedure PrintHourlyReport					CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := 'Снятие отчета'
	local strCloseReport := 'Закрытая смена.' + chr( 13 ) + chr( 10 ) + 'Снятие отчета по часам невозможно!'

	if ( regim := ::GetRegim() ) != -1
		if regim == ECRMODE_CLOSE
			hwg_MsgInfoBay( strCloseReport, strTitle )
			ret := .f.
		else
			::FDriver:Password := ::PasswordAdmin
			ret := ::ExecuteCommand( 'PrintHourlyReport' )
		endif
	endif
	return ret

// получить режим работы устройства
METHOD function GetRegim								CLASS TKKT_Shtrih
	local ret := -1

	if ( ::GetShortECRStatus() )
		ret := ::FShortECRStatus[ 'ECRMODE' ]
	endif
	return ret

// внесение денежной суммы в кассу
METHOD function CashIncome( summ1 )					CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	::FDriver:Summ1 := summ1
	if ( ret := ::ExecuteCommand( 'CashIncome' ) )
		::FOpenDocumentNumber := ::FDriver:OpenDocumentNumber
	endif
	return ret


// выплата денежной суммы из кассы
METHOD function CashOutcome( summ1 )					CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	::FDriver:Summ1 := summ1
	if ( ret := ::ExecuteCommand( 'CashOutcome' ) )
		::FOpenDocumentNumber := ::FDriver:OpenDocumentNumber
	endif
	return ret

// продвинуть документ
//  flag - 0 контрольная лента
//           1 чековая лента
//           2 обе ленты
//    numStr - количество прогоняемых строк
METHOD function FeedDocument( flag, numStr )			CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	::FDriver:StringQuantity := hb_DefaultValue( numStr, 1 )
	if flag == 0 .or. flag == 2 //контролька
		::FDriver:UseJournalRibbon := .t.
	else
		::FDriver:UseReceiptRibbon := .t.
	endif
	ret := ::ExecuteCommand( 'FeedDocument' )
	return ret

// получить длинные заводской номер и РНМ
METHOD function GetLongSerialNumberAndLongRNM()		CLASS TKKT_Shtrih
	local ret := .f.
	
alertx('getnumber')
	if ( ret := ::ExecuteCommand( 'GetLongSerialNumberAndLongRNM' ) )
		::FRNM := alltrim( ::FDriver:RNM )
		::FSerialNumber := alltrim( ::FDriver:SerialNumber )
	endif
alertx('end getnumber')
	return ret


* ExecuteCommand( command, lSilent ) - исполнение команды фискального регистратора
* command - исполняемая команда ФР
* lSilent - режим выполнения команды (.T. - без выдачи сообщений и без повторов,
*       .f. - с выдачей сообщений с повторами 
METHOD function ExecuteCommand( command, lSilent )		CLASS TKKT_Shtrih
	local res := .f., ret := .t.
	local counter := 0

	HB_Default( @lSilent, .f. ) 

	command := lower( command )
	do while .t.
		counter++
		do case
			case command == 'finddevice'
				res := ::ErrorHandling( 'Поиск устройства', lSilent, ::FDriver:FindDevice() )
			// Методы чтения/записи данных из/в ККМ
			case command == 'getcashreg'
				res := ::ErrorHandling( 'Получить денежный регистр', lSilent, ::FDriver:GetCashReg() )
			case command == 'getoperationreg'
				res := ::ErrorHandling( 'Получить операционный регистр', lSilent, ::FDriver:GetOperationReg() )
			case command == 'getdevicemetrics'
				res := ::ErrorHandling( 'Получить параметры устройства', lSilent, ::FDriver:GetDeviceMetrics() )
			case command == 'getshortecrstatus'
				res := ::ErrorHandling( 'Получить короткий запрос состояния ККМ', lSilent, ::FDriver:GetShortECRStatus() )
			case command == 'getecrstatus'
				res := ::ErrorHandling( 'Получить состояние ККМ', lSilent, ::FDriver:GetECRStatus() )
			case command == 'fngetstatus'
				res := ::ErrorHandling( 'Запрос статуса ФН', lSilent, ::FDriver:FNGetStatus() )
			case command == 'getlongserialnumberandlongrnm'
				res := ::ErrorHandling( 'Получить длинные заводской номер и РНМ', lSilent, ::FDriver:GetLongSerialNumberAndLongRNM() )
			case command == 'opendrawer'
				res := ::ErrorHandling( 'Открыть денежный ящик', lSilent, ::FDriver:OpenDrawer() )
			case command == 'cashincome'
				res := ::ErrorHandling( 'Внесение денежной суммы в кассу', lSilent, ::FDriver:CashIncome() )
			case command == 'cashoutcome'
				res := ::ErrorHandling( 'Выплата денежной суммы из кассы', lSilent, ::FDriver:CashOutcome() )
			case command == 'feeddocument'
				res := ::ErrorHandling( 'Продвинуть документ', lSilent, ::FDriver:FeedDocument() )
			case command == 'printstring'
				res := ::ErrorHandling( 'Печать строки', lSilent, ::FDriver:PrintString() )
			case command == 'printwidestring'
				res := ::ErrorHandling( 'Печать жирной строки', lSilent, ::FDriver:PrintWideString() )
			case command == 'printreportwithoutcleaning'
				res := ::ErrorHandling( 'Снять отчет без гашения', lSilent, ::FDriver:PrintReportWithoutCleaning() )
			case command == 'printreportwithcleaning'
				res := ::ErrorHandling( 'Снять отчет с гашением', lSilent, ::FDriver:PrintReportWithCleaning() )
			case command == 'cancelcheck'
				res := ::ErrorHandling( 'Аннулировать чек', lSilent, ::FDriver:CancelCheck() )
			case command == 'getfieldstruct'
				res := ::ErrorHandling( 'Получить структуру поля таблицы', lSilent, ::FDriver:GetFieldStruct() )
			case command == 'writetable'
				res := ::ErrorHandling( 'Записать таблицу', lSilent, ::FDriver:WriteTable() )
			case command == 'continueprint'
				res := ::ErrorHandling( 'Продолжить печать', lSilent, ::FDriver:ContinuePrint() )
			case command == 'settime'
				res := ::ErrorHandling( 'Установить время', lSilent, ::FDriver:SetTime() )
			case command == 'setdate'
				res := ::ErrorHandling( 'Установить дату', lSilent, ::FDriver:SetDate() )
			case command == 'confirmdate'
				res := ::ErrorHandling( 'Подтвердить дату', lSilent, ::FDriver:ConfirmDate() )
			case command == 'cutcheck'
				res := ::ErrorHandling( 'Отрезать чек', lSilent, ::FDriver:CutCheck() )
			case command == 'waitforprinting'
				res := ::ErrorHandling( 'Ожидание печати', lSilent, ::FDriver:WaitForPrinting() )
			case command == 'printcashierreport'
				res := ::ErrorHandling( 'Отчет по кассирам', lSilent, ::FDriver:PrintCashierReport() )
			&& case command == 'printreportwithcleaning'
				&& res := ::ErrorHandling( 'Снять отчет с гашением', lSilent, ::FDriver:PrintReportWithCleaning() )
			case command == 'printdepartmentreport'
				res := ::ErrorHandling( 'Отчет по секциям', lSilent, ::FDriver:PrintDepartmentReport() )
			case command == 'printtaxreport'
				res := ::ErrorHandling( 'Отчет по налогам', lSilent, ::FDriver:PrintTaxReport() )
			case command == 'printhourlyreport'
				res := ::ErrorHandling( 'Отчет по часам', lSilent, ::FDriver:PrintHourlyReport() )
			case command == 'readserialnumber'
				res := ::ErrorHandling( 'Прочитать заводской номер', lSilent, ::FDriver:ReadSerialNumber() )
			// операция с фискальным накопителем 54-ФЗ
			case command == 'fnopensession'
				res := ::ErrorHandling( 'Открыть смену', lSilent, ::FDriver:FNOpenSession() )
			case command == 'fngetinfoexchangestatus'
				res := ::ErrorHandling( 'Получить статус информационного обмена ФН', lSilent, ::FDriver:FNGetInfoExchangeStatus() )
			case command == 'fnoperation'
				res := ::ErrorHandling( 'ФН операция', lSilent, ::FDriver:FNOperation() )
			case command == 'fnclosecheckex'
				res := ::ErrorHandling( 'Закрытие чека расширенное (вариант 2)', lSilent, ::FDriver:FNCloseCheckEx() )
			case command == 'fnbegincorrectionreceipt'
				res := ::ErrorHandling( 'Начать формирование чека коррекции', lSilent, ::FDriver:FNBeginCorrectionReceipt() )
			case command == 'fnbuildcorrectionreceipt2'
				res := ::ErrorHandling( 'Сформировать чек коррекции. Команда версии 2.', lSilent, ::FDriver:fnbuildcorrectionreceipt2() )
			case command == 'fnprintdocument'
				res := ::ErrorHandling( 'Распечатать документ', lSilent, ::FDriver:FNPrintDocument() )
			case command == 'fnbeginopensession'
				res := ::ErrorHandling( 'Начать открытие смены', lSilent, ::FDriver:FNBeginOpenSession() )
			case command == 'fnopensession'
				res := ::ErrorHandling( 'Открыть смену', lSilent, ::FDriver:FNOpenSession() )
			case command == 'fnbeginclosesession'
				res := ::ErrorHandling( 'Начать закрытия смены', lSilent, ::FDriver:FNBeginCloseSession() )
			case command == 'fnclosesession'
				res := ::ErrorHandling( 'Закрыть смену', lSilent, ::FDriver:FNCloseSession() )
			case command == 'fnsendtag'
				res := ::ErrorHandling( 'Отправить тег', lSilent, ::FDriver:FNSendTag() )
				
			otherwise
				return .f.
		endcase
		if res == FR_SUCCESS
			ret := .t.
			exit
		elseif res == IDCANCEL .or. counter >= COUNTER_REPEAT
			if ::FReceiptOpen
				::FDriver:CancelCheck()
				::FReceiptOpen := .f.
			endif
			ret := .f.
			exit
		endif
	enddo
	return ret
	
* ErrorHandling( descFunc, lSilent ) - исполнение команды фискального регистратора с обработкой ошибок
* descFunc - описание команды фискального регистратора
* lSilent - тихий режим (.T. - без выдачи сообщений и без повторов,
*      					.f. - с выдачей сообщений с повторами )
METHOD ErrorHandling( descFunc, lSilent )			CLASS TKKT_Shtrih
	local code, ret := FR_SUCCESS
	local errOEM
	local res

	if HB_CDPSELECT() == 'RU1251'
		HB_CDPSELECT( 'RU866' )
	endif
	
	// получим результат выполнения команды
	::FResultCode := ::FDriver:ResultCode
	::FResultCodeDescription := ::FDriver:ResultCodeDescription
	errOEM := ::FResultCodeDescription
  
	// операция прошла успешно
	if ::FResultCode == FR_SUCCESS
		return FR_SUCCESS
	endif

	// возникли проблемы с кассовым аппаратом, запишем ошибку и попытаемся исправить ее
	if ::FResultCode == ERR_WAIT_CONTINUE_PRINT
		::FDriver:ContinuePrint()
		ret := IDRETRY
	elseif ::FResultCode == ERR_COM_NOT
		ret := hwg_MsgRetryCancelBay( 'Включите фискальный регистратор и попытайтесь снова.', 'Драйвер Штрих-ФР' ) 
	elseif ::FResultCode == ERR_NOT_CONNECT
		if ( res := hwg_MsgNoYesBay( 'Устройство не найдено. Попытаться найти устройство.', 'Драйвер Штрих-ФР' ) )
			::ExecuteCommand( 'FindDevice' )
		else
			ret := IDCANCEL
		endif
	else
		if lSilent
			ret := IDCANCEL
		else
			ret := hwg_MsgRetryCancelBay( ::FResultCodeDescription + '. Попытайтесь исправить ошибку.', 'Драйвер Штрих-ФР' ) 
		Endif
	endif
	return ret
	
// загрузить драйвер ККТ
METHOD function Init()									CLASS TKKT_Shtrih
	local ret := .f.
	
	if ::FDriver == nil
		if ( ::FDriver := win_oleCreateObject( 'AddIn.DrvFr' ) ) != nil
			::FDriverLoaded := .t.
			::FIsFiscalReg := .t.
			ret := .t.
		endif
	endif
	return ret

// загрузить настройки ККТ
//METHOD function Open( oSetting, nPasswordUser )		CLASS TKKT_Shtrih
//	return ::Open( oSetting, nPasswordUser )
METHOD function Open( oSetting, oUser )		CLASS TKKT_Shtrih
	return ::Open( oSetting, oUser )

METHOD New()		CLASS TKKT_Shtrih
	return self

// показать свойства драйвера ККТ
METHOD function ShowProperties()						CLASS TKKT_Shtrih
	return ::FDriver:ShowProperties

// получить версию драйвера ККТ
METHOD function Version()								CLASS TKKT_Shtrih
	return ::FDriver:DriverVersion

// открыть денежный ящик
// nDrawerNumber - номер денежного ящика, допустимое значение 0 или 1
METHOD function OpenDrawer( nDrawerNumber )			CLASS TKKT_Shtrih
	local ret := .f.
	
	hb_Default( @nDrawerNumber, 0 )
	nDrawerNumber := iif( nDrawerNumber != 0 .or. nDrawerNumber != 1, 0, nDrawerNumber )
	::FDriver:Password := ::Password
	::FDriver:DrawerNumber := nDrawerNumber
	return ::ExecuteCommand( 'OpenDrawer' )

// получить параметры устройства
METHOD function GetDeviceMetrics()						CLASS TKKT_Shtrih
	local ret := .f.
	
	if  ::FDeviceMetrics == nil
		if ( ret := ::ExecuteCommand( 'GetDeviceMetrics' ) )
			::FDeviceMetrics := { => }
			::FDeviceMetrics[ 'UMAJORPROTOCOLVERSION' ] := ::FDriver:UMajorProtocolVersion	/* Версия протокола связи с ПК, используемая устройством */
			::FDeviceMetrics[ 'UMINORPROTOCOLVERSION' ] := ::FDriver:UMinorProtocolVersion	/* Подверсия протокола связи с ПК, используемая устройством */
			::FDeviceMetrics[ 'UMAJORTYPE' ] := ::FDriver:UMajorType						/* Тип запрашиваемого устройства */
			::FDeviceMetrics[ 'UMINORTYPE' ] := ::FDriver:UMinorType						/* Подтип запрашиваемого устройства */
			::FDeviceMetrics[ 'UMODEL' ] := ::FDriver:UModel								/* Модель запрашиваемого устройства */
			::FDeviceMetrics[ 'UCODEPAGE' ] := ::FDriver:UCodePage							/* Кодовая страница, используемая устройством (0 - русский язык) */
			::FDeviceMetrics[ 'UDESCRIPTION' ] := ::FDriver:UDescription					/* Название устройства - строка символов таблицы WIN1251 */
			::FDeviceMetrics[ 'CAPGETSHORTECRSTATUS' ] := ::FDriver:CapGetShortECRStatus	/* Команда GetShortECRStatus поддерживается */
		endif
	endif
	return ret

// получить краткое состояние устройства
METHOD function GetShortECRStatus()					CLASS TKKT_Shtrih
	local ret := .f.
	
	&& if  ::FShortECRStatus == nil
		::FDriver:Password := ::Password
		if ( ret := ::ExecuteCommand( 'GetShortECRStatus' ) )
			::FShortECRStatus := { => }
			::FShortECRStatus[ 'OPERATORNUMBER' ]				:= ::FDriver:OPERATORNUMBER
			::FShortECRStatus[ 'ECRFLAGS' ]						:= ::FDriver:ECRFLAGS
			::FShortECRStatus[ 'RECEIPTRIBBONISPRESENT' ]		:= ::FDriver:RECEIPTRIBBONISPRESENT
			::FShortECRStatus[ 'JOURNALRIBBONISPRESENT' ]		:= ::FDriver:JOURNALRIBBONISPRESENT
			::FShortECRStatus[ 'SLIPDOCUMENTISPRESENT' ]		:= ::FDriver:SLIPDOCUMENTISPRESENT
			::FShortECRStatus[ 'SLIPDOCUMENTISMOVING' ]			:= ::FDriver:SLIPDOCUMENTISMOVING		
			::FShortECRStatus[ 'POINTPOSITION' ]				:= ::FDriver:POINTPOSITION
			::FShortECRStatus[ 'EKLZISPRESENT' ]				:= ::FDriver:EKLZISPRESENT	
			::FShortECRStatus[ 'JOURNALRIBBONOPTICALSENSOR' ]	:= ::FDriver:JOURNALRIBBONOPTICALSENSOR
			::FShortECRStatus[ 'RECEIPTRIBBONOPTICALSENSOR' ]	:= ::FDriver:RECEIPTRIBBONOPTICALSENSOR	
			::FShortECRStatus[ 'JOURNALRIBBONLEVER' ]			:= ::FDriver:JOURNALRIBBONLEVER
			::FShortECRStatus[ 'RECEIPTRIBBONLEVER' ]			:= ::FDriver:RECEIPTRIBBONLEVER
			::FShortECRStatus[ 'LIDPOSITIONSENSOR' ]			:= ::FDriver:LIDPOSITIONSENSOR
			::FShortECRStatus[ 'ISPRINTERLEFTSENSORFAILURE' ]	:= ::FDriver:ISPRINTERLEFTSENSORFAILURE	
			::FShortECRStatus[ 'ISPRINTERRIGHTSENSORFAILURE' ]	:= ::FDriver:ISPRINTERRIGHTSENSORFAILURE
			::FShortECRStatus[ 'ISDRAWEROPEN' ]					:= ::FDriver:ISDRAWEROPEN
			::FShortECRStatus[ 'ISEKLZOVERFLOW' ]				:= ::FDriver:ISEKLZOVERFLOW		
			::FShortECRStatus[ 'QUANTITYPOINTPOSITION' ]		:= ::FDriver:QUANTITYPOINTPOSITION	
			::FShortECRStatus[ 'ECRMODE' ]						:= ::FDriver:ECRMODE
			::FShortECRStatus[ 'ECRMODEDESCRIPTION' ]			:= ::FDriver:ECRMODEDESCRIPTION
			::FShortECRStatus[ 'ECRMODE8STATUS' ]				:= ::FDriver:ECRMODE8STATUS
			::FShortECRStatus[ 'ECRMODESTATUS' ]				:= ::FDriver:ECRMODESTATUS	
			::FShortECRStatus[ 'ECRADVANCEDMODE' ]				:= ::FDriver:ECRADVANCEDMODE	
			::FShortECRStatus[ 'ECRADVANCEDMODEDESCRIPTION' ]	:= ::FDriver:ECRADVANCEDMODEDESCRIPTION
			::FShortECRStatus[ 'QUANTITYOFOPERATIONS' ]			:= ::FDriver:QUANTITYOFOPERATIONS
			::FShortECRStatus[ 'BATTERYVOLTAGE' ]				:= ::FDriver:BATTERYVOLTAGE
			::FShortECRStatus[ 'POWERSOURCEVOLTAGE' ]			:= ::FDriver:POWERSOURCEVOLTAGE	
			::FShortECRStatus[ 'FMRESULTCODE' ]					:= ::FDriver:FMRESULTCODE
			::FShortECRStatus[ 'EKLZRESULTCODE' ]				:= ::FDriver:EKLZRESULTCODE		
		endif
	&& endif
	return ret

// получить полное состояние устройства
METHOD function GetECRStatus( flag )					CLASS TKKT_Shtrih
// flag - флаг .f. - не запрашивать, .t. запрашивать
	local ret := .f.
	
	HB_Default( @flag, .f. ) 
	if  ::FECRStatus != nil .and. !flag
		ret := .t.
	else
		::FDriver:Password := ::Password
		if ( ret := ::ExecuteCommand( 'GetECRStatus' ) )
			::FECRStatus := { => }
			::FECRStatus[ 'OPERATORNUMBER' ] 			:= ::FDriver:OperatorNumber
			::FECRStatus[ 'ECRSOFTVERSION' ] 			:= ::FDriver:ECRSoftVersion
			::FECRStatus[ 'ECRBUILD' ] 					:= ::FDriver:ECRBuild
			::FECRStatus[ 'ECRSOFTDATE' ] 				:= ::FDriver:ECRSoftDate
			::FECRStatus[ 'LOGICALNUMBER' ] 			:= ::FDriver:LogicalNumber
			::FECRStatus[ 'OPENDOCUMENTNUMBER' ] 		:= ::FDriver:OpenDocumentNumber
			::FECRStatus[ 'ECRFLAGS' ] 					:= ::FDriver:ECRFlags
			::FECRStatus[ 'RECEIPTRIBBONISPRESENT' ] 	:= ::FDriver:RECEIPTRIBBONISPRESENT
			::FECRStatus[ 'JOURNALRIBBONISPRESENT' ] 	:= ::FDriver:JOURNALRIBBONISPRESENT
			::FECRStatus[ 'SLIPDOCUMENTISPRESENT' ] 	:= ::FDriver:SLIPDOCUMENTISPRESENT
			::FECRStatus[ 'SLIPDOCUMENTISMOVING' ] 		:= ::FDriver:SLIPDOCUMENTISMOVING
			::FECRStatus[ 'POINTPOSITION' ] 			:= ::FDriver:POINTPOSITION
			::FECRStatus[ 'EKLZISPRESENT' ] 			:= ::FDriver:EKLZISPRESENT
			::FECRStatus[ 'JOURNALRIBBONOPTICALSENSOR' ]:= ::FDriver:JOURNALRIBBONOPTICALSENSOR
			::FECRStatus[ 'RECEIPTRIBBONOPTICALSENSOR' ]:= ::FDriver:RECEIPTRIBBONOPTICALSENSOR
			::FECRStatus[ 'JOURNALRIBBONLEVER' ] 		:= ::FDriver:JOURNALRIBBONLEVER
			::FECRStatus[ 'RECEIPTRIBBONLEVER' ] 		:= ::FDriver:RECEIPTRIBBONLEVER
			::FECRStatus[ 'LIDPOSITIONSENSOR' ] 		:= ::FDriver:LIDPOSITIONSENSOR
			::FECRStatus[ 'ISPRINTERLEFTSENSORFAILURE' ]:= ::FDriver:ISPRINTERLEFTSENSORFAILURE
			::FECRStatus[ 'ISPRINTERRIGHTSENSORFAILURE' ]:= ::FDriver:ISPRINTERRIGHTSENSORFAILURE
			::FECRStatus[ 'ISDRAWEROPEN' ]				:= ::FDriver:ISDRAWEROPEN
			::FECRStatus[ 'ISEKLZOVERFLOW' ] 			:= ::FDriver:ISEKLZOVERFLOW
			::FECRStatus[ 'QUANTITYPOINTPOSITION' ] 	:= ::FDriver:QUANTITYPOINTPOSITION
			::FECRStatus[ 'ECRMODE' ] 					:= ::FDriver:ECRMODE
			::FECRStatus[ 'ECRMODEDESCRIPTION' ] 		:= ::FDriver:ECRMODEDESCRIPTION
			::FECRStatus[ 'ECRMODE8STATUS' ] 			:= ::FDriver:ECRMODE8STATUS
			::FECRStatus[ 'ECRMODESTATUS' ] 			:= ::FDriver:ECRMODESTATUS
			::FECRStatus[ 'ECRADVANCEDMODE' ] 			:= ::FDriver:ECRADVANCEDMODE
			::FECRStatus[ 'ECRADVANCEDMODEDESCRIPTION' ]:= ::FDriver:ECRADVANCEDMODEDESCRIPTION
			::FECRStatus[ 'PORTNUMBER' ] 				:= ::FDriver:PORTNUMBER
			::FECRStatus[ 'FMSOFTVERSION' ] 			:= ::FDriver:FMSOFTVERSION
			::FECRStatus[ 'FMBUILD' ] 					:= ::FDriver:FMBUILD
			::FECRStatus[ 'FMSOFTDATE' ] 				:= ::FDriver:FMSOFTDATE
			::FECRStatus[ 'DATE' ] 						:= ::FDriver:DATE
			::FECRStatus[ 'TIME' ] 						:= ::FDriver:TIME
			::FECRStatus[ 'TIMESTR' ] 					:= ::FDriver:TIMESTR
			::FECRStatus[ 'FMFLAGS' ] 					:= ::FDriver:FMFLAGS
			::FECRStatus[ 'FM1ISPRESENT' ] 				:= ::FDriver:FM1ISPRESENT
			::FECRStatus[ 'FM2ISPRESENT' ] 				:= ::FDriver:FM2ISPRESENT
			::FECRStatus[ 'LICENSEISPRESENT' ] 			:= ::FDriver:LICENSEISPRESENT
			::FECRStatus[ 'FMOVERFLOW' ] 				:= ::FDriver:FMOVERFLOW
			::FECRStatus[ 'ISBATTERYLOW' ] 				:= ::FDriver:ISBATTERYLOW
			::FECRStatus[ 'ISLASTFMRECORDCORRUPTED' ] 	:= ::FDriver:ISLASTFMRECORDCORRUPTED
			::FECRStatus[ 'ISFMSESSIONOPEN' ] 			:= ::FDriver:ISFMSESSIONOPEN
			::FECRStatus[ 'ISFM24HOURSOVER' ] 			:= ::FDriver:ISFM24HOURSOVER
			::FECRStatus[ 'SERIALNUMBER' ] 				:= ::FDriver:SERIALNUMBER
			::FECRStatus[ 'SESSIONNUMBER' ] 			:= ::FDriver:SESSIONNUMBER
			::FECRStatus[ 'FREERECORDINFM' ] 			:= ::FDriver:FREERECORDINFM
			::FECRStatus[ 'REGISTRATIONNUMBER' ] 		:= ::FDriver:REGISTRATIONNUMBER
			::FECRStatus[ 'FREEREGISTRATION' ] 			:= ::FDriver:FREEREGISTRATION
			::FECRStatus[ 'INN' ] 						:= ::FDriver:INN
			::FECRStatus[ 'SKNOSTATUS' ]		        := ::FDriver:SKNOStatus
			
			::FDateDevice := ::FECRStatus[ 'TIME' ]
			::FTimeDevice := ::FECRStatus[ 'TIME' ]
			::FTimeStrDevice := ::FECRStatus[ 'TIMESTR' ]
		endif
	endif
	return ret

// получить состояние фискального накопителя устройства
METHOD function FNGetStatus()							CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	if ( ret := ::ExecuteCommand( 'FNGetStatus' ) )
		::FFNStatus := { => }
		::FFNStatus[ 'FNLIFESTATE' ]		:= ::FDriver:FNLifeState		// состояние жизни ФН
		::FFNStatus[ 'FNCURRENTDOCUMENT' ]	:= ::FDriver:FNCurrentDocument	// текущий документ ФН
		::FFNStatus[ 'FNDOCUMENTDATA' ]		:= ::FDriver:FNDocumentData		// данные документа
		::FFNStatus[ 'FNSESSIONSTATE' ]		:= ::FDriver:FNSessionState		// состояние смены
		::FFNStatus[ 'FNWARNINGFLAGS' ]		:= ::FDriver:FNWarningFlags		// флаги предупреждения
		::FFNStatus[ 'DATE' ]				:= ::FDriver:Date				// дата
		::FFNStatus[ 'TIME' ]				:= ::FDriver:Time				// время
		::FFNStatus[ 'SERIALNUMBER' ]		:= ::FDriver:SerialNumber		// заводской номер ФН
		::FFNStatus[ 'DOCUMENTNUMBER' ]		:= ::FDriver:DocumentNumber		// номер ФД
		
		::FOpenSession := iif( ::FDriver:FNSessionState == 0, .f., .t. )
	else
		::FFNStatus := nil
	endif
	return ret

METHOD function Beep()									CLASS TKKT_Shtrih
	::FDriver:Password := ::Password
	::FDriver:Beep()
	return ::FDriver:OperatorNumber

// печать строки текста на ККТ
//	stringForPrinting - строка для печати на ФР
//	lWide - печать жирным .T., или обычным .f. шрифтом
//	typeControlRibbon - печатать на контрольной ленте:
//		0 - печать везде, 
//		1 - не печатать на контрольной ленте,
//		2 - не печать на чековой ленте
METHOD function PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )		CLASS TKKT_Shtrih
	local ret := .f.
	
	HB_Default( @typeControlRibbon, 0 )
	HB_Default( @lWide, .f. )
	HB_Default( @lDelayedPrint, .f. )
	
//	if ::FDriver != nil
		stringForPrinting := atrepl( ',', alltrim( stringForPrinting ), ';' )   // заменить ";" на "," строки
		stringForPrinting := charone( ' ', stringForPrinting )                // удалить совмещенные пробелы
		stringForPrinting := substr( stringForPrinting, 1, 249 )                // обрежем до 249 символов
		HB_CDPSELECT( 'RU1251' )
		::FDriver:Password := ::Password
		::FDriver:UseReceiptRibbon := 1
		if typeControlRibbon == 2
			::FDriver:UseReceiptRibbon := 0
		endif
		if typeControlRibbon == 1
			::FDriver:UseJournalRibbon := 0
		else
			::FDriver:UseJournalRibbon := 1
		endif
		::FDriver:StringForPrinting  := dos2win( stringForPrinting )
		::FDriver:DelayedPrint := lDelayedPrint
		if lWide
			ret := ::ExecuteCommand( 'PrintWideString' )
		else
			ret := ::ExecuteCommand( 'PrintString' )
		endif
		HB_CDPSELECT( 'RU866' )
//	endif
	return ret
	
// Отправить тег с ИНН кассира
METHOD SendINNCashier() CLASS TKKT_Shtrih
	local ret := .t.
	
	if !empty( ::INNCashier )
		::FDriver:Password := ::Password
		::FDriver:TagNumber := 1203
		::FDriver:TagType := 7
		::FDriver:TagValueStr := ::INNCashier //Здесь указываем ИНН Кассира.
		::ExecuteCommand( 'FNSendTag' )
	endif
	return ret
