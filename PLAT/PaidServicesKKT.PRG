* PaidServicesKKT.prg - �����⥬� ࠡ�� � ��� � ������ ��㣠�
*******************************************************************************
* 08.10.18 inf_fr(k) - ��뢠���� � '����� ��㣨/���ଠ��/����� � ���ᮩ'
* 03.04.18 ReportsKKT( r, c )
* 01.05.17 ExtendedReport( r, c )
* 15.12.13 fr_nastrojka(k)
* 01.05.17 ChoiseCorrectionReceipt( r, c )
* 18.11.14 inf_fr_orto(k)  - ��뢠���� � '��⮯����/���ଠ��/����� � ���ᮩ'
* 04.09.17 fr_nastrojka( k ) - ०��� ࠡ��� � ���ᮩ
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
	local mas_pmt := { '����� ���� ~��� ��襭��',;
                  '����� ���� � ~��襭���', ;
				  '~����७�� �����' }
	local mas_msg := { '���⨥ ���� ��� ��襭��', ;
                  '���⨥ ���� � ��襭���', ;
				  '����७�� �����' }
	local mas_fun := { 'PrintReport( 0 )', ;
					'PrintReport( 1 )', ;
					'ExtendedReport()' }
	DEFAULT r TO T_ROW - 3, c TO T_COL-15 					//+5
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

	
* 03.04.18 ****
function ExtendedReport( r, c )
	local mas_pmt := { ;
					'~��⪨� ���� �� ����ࠬ', ;
					'~���� �� ᥪ��', ;
					'~���� �� �������', ;
					'~���� �� �ᠬ' ;
					}
	local mas_msg := { ;
					'���⠢����� ���� �� ����ࠬ', ;
					'���⨥ ���� � ᥪ��', ;
					'���⨥ ���� �� �����', ;
					'���⨥ ���� �� �ᠬ' ;
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

***** 31.01.19 ०��� ࠡ��� � ���ᮩ
*
function fr_nastrojka( k )
	static si1 := 1//, si2 := 1
	local mas_pmt := {}, mas_msg := {}, mas_fun := {}//, j
	&& local buf := savescreen()
	
	HB_Default( @k, 1 ) 
	do case
		case k == 1
			if getDrvFR():IsFiscalReg()
				aadd( mas_pmt, '���ᥭ�� ~����� � �����' )
				aadd( mas_msg, '���ᥭ�� ����� � �����' )
				aadd( mas_fun, 'CashInOut( .t. )' )
				// -----
				aadd( mas_pmt, '�믫�� ����� �� �����' )
				aadd( mas_msg, '�믫�� ����� �� �����' )
				aadd( mas_fun, 'CashInOut( .f. )' )
				// -----
				aadd( mas_pmt, '���४����騥 祪�' )
				aadd( mas_msg, '���४����騥 祪�' )
				aadd( mas_fun, 'ChoiseCorrectionReceipt()' )
				// -----
				aadd( mas_pmt, '�஢�ઠ ����ࠢ������ ���㬥�⮢ � ���' )
				aadd( mas_msg, '�஢�ઠ ����ࠢ������ ���㬥�⮢ � ���' )
				aadd( mas_fun, 'getDrvFR():CheckExchangeStatus( .t. )' )
				// -----
				aadd( mas_pmt, '�����' )
				aadd( mas_msg, '����祭�� ���ᮢ�� ���⮢' )
				aadd( mas_fun, 'ReportsKKT()' )
				// -----
				aadd( mas_pmt, '�த������� ~����' )
				aadd( mas_msg, '�த������� ���� �� ���뢥 �����' )
				aadd( mas_fun, 'ContinuePrintAfterError()' )
					// -----
				aadd( mas_pmt, '~���㫨஢���� �� �஡�⮣� 祪�' )
				aadd( mas_msg, '���㫨஢���� 祪� �� �訡�� ����' )
				aadd( mas_fun, 'CancelCheck()' )
			endif
			aadd( mas_pmt, '~����ன�� ࠡ��� ���' )
			aadd( mas_msg, '����ன�� ࠡ��� ����஫쭮-���ᮢ�� ��設�' )
			aadd( mas_fun, 'SetupKKT()' )
			popup_prompt( T_ROW, T_COL - 5, si1, mas_pmt, mas_msg, mas_fun )
	endcase
	return nil

* 06.04.18 ���� ���४����騥�� 祪�
function ChoiseCorrectionReceipt( r, c )
	local mas_pmt := { ;
					'���४����騩 祪 ��室�', ;
					'���४����騩 祪 ��室�' ;
					}
	local mas_msg := { ;
					'���४����騩 祪 ��室�', ;
					'���४����騩 祪 ��室�' ;
					}
	local mas_fun := { ;
					'BuildCorrectionReceipt( 0 )', ;
					'BuildCorrectionReceipt( 1 )' ;
					}
	DEFAULT r TO T_ROW - 3, c TO T_COL-15
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

* 08.10.18 ��뢠���� � '����� ��㣨/���ଠ��/����� � ���ᮩ'
function inf_fr( k )
	static si1 := 1, si2 := 1
	local mas_pmt, mas_msg, mas_fun, j
	local aHash
	local aContracts
	
	DEFAULT k TO 1
	do case
		case k == 1
			mas_pmt := { '���ଠ�� �� ~����', ;
						'����� ��� ~�����', ;
						'������', ;
						'�������' }
			mas_msg := { '����祭�� ���ଠ樨 �� ���ﭨ� ���ᮢ��� ������', ;
						'���� ������, � ������ ������� ��㣨, �� �� �஡�� ���', ;
						'������ �����', ;
						'���ଠ�� �� �����⠬' }
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

***** 18.11.14 ��뢠���� � '��⮯����/���ଠ��/����� � ���ᮩ'
function inf_fr_orto1( k )
	static si1 := 1, si2 := 1
	local mas_pmt, mas_msg, mas_fun, j
	DEFAULT k TO 1
	do case
		case k == 1
			mas_pmt := { '���ଠ�� �� ~����', ;
						'������', ;
						'�������' }
			mas_msg := { '����祭�� ���ଠ樨 �� ���ﭨ� ���ᮢ��� ������', ;
						'������ ॣ����樨 祪�� �� ������', ;
						'���ଠ�� �� �����⠬' }
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
