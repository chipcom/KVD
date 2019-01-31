* PaidServicesKKT.prg - подсистема работа с ККТ в платных услугах
*******************************************************************************
* 08.10.18 inf_fr(k) - вызывается в 'Платные услуги/Информация/Работа с кассой'
* 03.04.18 ReportsKKT( r, c )
* 01.05.17 ExtendedReport( r, c )
* 15.12.13 fr_nastrojka(k)
* 01.05.17 ChoiseCorrectionReceipt( r, c )
* 18.11.14 inf_fr_orto(k)  - вызывается в 'Ортопедия/Информация/Работа с кассой'
* 04.09.17 fr_nastrojka( k ) - режимы работы с кассой
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

* 03.04.18 ****
function ReportsKKT( r, c )
	local mas_pmt := { 'Снять отчет ~без гашения',;
                  'Снять отчет с ~гашением', ;
				  '~Расширенные отчеты' }
	local mas_msg := { 'Снятие отчета без гашения', ;
                  'Снятие отчета с гашением', ;
				  'Расширенные отчеты' }
	local mas_fun := { 'PrintReport( 0 )', ;
					'PrintReport( 1 )', ;
					'ExtendedReport()' }
	DEFAULT r TO T_ROW - 3, c TO T_COL-15 					//+5
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

	
* 03.04.18 ****
function ExtendedReport( r, c )
	local mas_pmt := { ;
					'~Краткий отчет по кассирам', ;
					'~Отчет по секциям', ;
					'~Отчет по налогам', ;
					'~Отчет по часам' ;
					}
	local mas_msg := { ;
					'Составление отчета по кассирам', ;
					'Снятие отчета с секциям', ;
					'Снятие отчет по налог', ;
					'Снятие отчет по часам' ;
					}
	local mas_fun := { ;
					'getDrvFR():PrintCashierReport()', ;
					'getDrvFR():PrintDepartmentReport()', ;
					'getDrvFR():PrintTaxReport()', ;
					'getDrvFR():PrintHourlyReport()' ;
					}
	DEFAULT r TO T_ROW - 3, c TO T_COL-15
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

***** 31.01.19 режимы работы с кассой
*
function fr_nastrojka( k )
	static si1 := 1//, si2 := 1
	local mas_pmt := {}, mas_msg := {}, mas_fun := {}//, j
	&& local buf := savescreen()
	
	HB_Default( @k, 1 ) 
	do case
		case k == 1
			if getDrvFR():IsFiscalReg()
				aadd( mas_pmt, 'Внесение ~денег в кассу' )
				aadd( mas_msg, 'Внесение денег в кассу' )
				aadd( mas_fun, 'CashInOut( .t. )' )
				// -----
				aadd( mas_pmt, 'Выплата денег из кассы' )
				aadd( mas_msg, 'Выплата денег из кассы' )
				aadd( mas_fun, 'CashInOut( .f. )' )
				// -----
				aadd( mas_pmt, 'Корректирующие чеки' )
				aadd( mas_msg, 'Корректирующие чеки' )
				aadd( mas_fun, 'ChoiseCorrectionReceipt()' )
				// -----
				aadd( mas_pmt, 'Проверка неотправленных документов в ОФД' )
				aadd( mas_msg, 'Проверка неотправленных документов в ОФД' )
				aadd( mas_fun, 'getDrvFR():CheckExchangeStatus( .t. )' )
				// -----
				aadd( mas_pmt, 'Отчеты' )
				aadd( mas_msg, 'Получение кассовых отчетов' )
				aadd( mas_fun, 'ReportsKKT()' )
				// -----
				aadd( mas_pmt, 'Продолжение ~печати' )
				aadd( mas_msg, 'Продолжение печати при обрыве ленты' )
				aadd( mas_fun, 'ContinuePrintAfterError()' )
					// -----
				aadd( mas_pmt, '~Аннулирование не пробитого чека' )
				aadd( mas_msg, 'Аннулирование чека при ошибке печати' )
				aadd( mas_fun, 'CancelCheck()' )
			endif
			aadd( mas_pmt, '~Настройка работы ККМ' )
			aadd( mas_msg, 'Настройка работы контрольно-кассовой машины' )
			aadd( mas_fun, 'SetupKKT()' )
			popup_prompt( T_ROW, T_COL - 5, si1, mas_pmt, mas_msg, mas_fun )
	endcase
	return nil

* 06.04.18 Ввод корректирующиего чека
function ChoiseCorrectionReceipt( r, c )
	local mas_pmt := { ;
					'Корректирующий чек прихода', ;
					'Корректирующий чек расхода' ;
					}
	local mas_msg := { ;
					'Корректирующий чек прихода', ;
					'Корректирующий чек расхода' ;
					}
	local mas_fun := { ;
					'BuildCorrectionReceipt( 0 )', ;
					'BuildCorrectionReceipt( 1 )' ;
					}
	DEFAULT r TO T_ROW - 3, c TO T_COL-15
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

* 08.10.18 вызывается в 'Платные услуги/Информация/Работа с кассой'
function inf_fr( k )
	static si1 := 1, si2 := 1
	local mas_pmt, mas_msg, mas_fun, j
	local aHash
	local aContracts
	
	DEFAULT k TO 1
	do case
		case k == 1
			mas_pmt := { 'Информация по ~кассе', ;
						'Больные без ~ЧЕКОВ', ;
						'Реестр', ;
						'Возвраты' }
			mas_msg := { 'Получение информации по состоянию кассового аппарата', ;
						'Поиск больных, у которых введены услуги, но не пробит ЧЕК', ;
						'Реестр кассира', ;
						'Информация по возвратам' }
			mas_fun := { 'inf_fr( 11 )', ;
						'inf_fr( 12 )', ;
						'inf_fr( 13 )', ;
						'inf_fr( 14 )' }
			popup_prompt( T_ROW, T_COL - 5, si1, mas_pmt, mas_msg, mas_fun )
		case k == 11
			f1_inf_fr( 1 )
		case k == 12
			if ( aHash := QueryDataForTheReport( .t., .t., .f. ) ) != nil
				hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @PatientsWithoutChecks(), aHash )
				WaitingReport()
			endif
		case k == 13
			CashierReport()
		case k == 14
			if ( aHash := QueryDataForTheReport( .t., .t., .f. ) ) != nil
				hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @InformationOnRefunds(), aHash, .f. )
				WaitingReport()
			endif
	endcase
	if k > 10
		j := int( val( right( lstr( k ), 1 ) ) )
		if between( k, 11, 19 )
			si1 := j
		endif
	endif
	return nil

***** 18.11.14 вызывается в 'Ортопедия/Информация/Работа с кассой'
function inf_fr_orto1( k )
	static si1 := 1, si2 := 1
	local mas_pmt, mas_msg, mas_fun, j
	DEFAULT k TO 1
	do case
		case k == 1
			mas_pmt := { 'Информация по ~кассе', ;
						'Реестр', ;
						'Возвраты' }
			mas_msg := { 'Получение информации по состоянию кассового аппарата', ;
						'Реестр регистрации чеков на оплату', ;
						'Информация по возвратам' }
			mas_fun := { 'inf_fr_orto( 11 )', ;
						'inf_fr_orto( 12 )', ;
						'inf_fr_orto( 13 )' }
			popup_prompt( T_ROW, T_COL - 5, si1, mas_pmt, mas_msg, mas_fun )
		case k == 11
			f1_inf_fr( 2 )
		case k == 12
			CashierReport( .t. )
		case k == 13
			if ( aHash := QueryDataForTheReport( .f., .t., .f. ) ) != nil
				hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @InformationOnRefunds(), aHash, .t. )
			endif
	endcase
	
	if k > 10
		j := int( val( right( lstr( k ), 1 ) ) )
		if between( k, 11, 19 )
			si1 := j
		endif
	endif
	return nil
