#include 'property.ch'
#include 'hbclass.ch'
#include 'windows.ch'
#include 'f_fr_bay.ch'

#define COUNTER_REPEAT	5	// �᫮ ����஢ ���饭�� � ���

CLASS TKKT_Shtrih FROM TAbstractKKT

    EXPORTED:
		METHOD New()
		METHOD ShowProperties()
		METHOD Version()
		METHOD Init
		METHOD Beep
		METHOD PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )
		METHOD OpenDrawer( nDrawerNumber )			// ������ ������� �騪
		METHOD CashIncome( summ1 )					// ���ᥭ�� �������� �㬬� � �����
		METHOD CashOutcome( summ1 )					// �믫�� �������� �㬬� �� �����
		METHOD FeedDocument( flag, numStr )			// �த������ ���㬥��
		METHOD GetDeviceMetrics						// ������� ��ࠬ���� ���ன�⢠
		METHOD GetShortECRStatus						// ������� ��⪮� ���ﭨ� ���ன�⢠
		METHOD GetECRStatus( flag )					// ������� ������ ���ﭨ� ���ன�⢠
		METHOD FNGetStatus							// ������� ���ﭨ� �᪠�쭮�� ������⥫� ���ன�⢠
		METHOD GetLongSerialNumberAndLongRNM			// ������� ������ �����᪮� ����� � ���
		METHOD PrintReportWithoutCleaning			// ���� ���� ��� ��襭��
		METHOD PrintReportWithCleaning				// ���� ���� � ��襭���
		METHOD CancelCheck							// �⬥�� 祪�
		METHOD GetInfoExchangeStatus					// ������� ����� ���ଠ樮����� ������
		METHOD SetOperatorKKT( nOp, cName )			// ��⠭����� ��� ���짮��⥫� � ���ன�⢥
		METHOD ContinuePrint							// �த������ �����
		METHOD SetDate( date )						// ��⠭�������� ���� �� ����७��� ��� ���ன�⢠
		METHOD GetDate()								// ����砥� ���� �� ����७��� �ᮢ ���ன�⢠
		METHOD SetTime( time )						// ��⠭�������� �६� �� ����७��� ��� ���ன�⢠
		METHOD GetTime()								// ����砥� �६� �� ����७��� �ᮢ ���ன�⢠
		METHOD CutCheck( flag )						// ��१�� 祪���� �����
		METHOD FNOpenSession()						// ������ ᬥ�� �� �᪠�쭮� ������⥫�
		METHOD Operation( oOperation )				// ������ � 祪�
		METHOD CloseCheck( oCloseCheck )				// �����⨥ 祪� ���७���
		METHOD GetCashReg( nRegistr )				// ����� ᮤ�ন���� ��������� ॣ����
		METHOD GetOperationReg( nRegistr )			// ����� ᮤ�ন���� ����樮����� ॣ����
		METHOD PrintHourlyReport						// ���� ���ᮢ�� ����
		METHOD PrintTaxReport						// ��⮤ ���⠥� ����� � �த���� �� �������
		METHOD PrintDepartmentReport					// ��⮤ ���⠥� ����� � �த���� �� �⤥��� (ᥪ��)
		METHOD PrintCashierReport					// ���� ���� �� ����ࠬ
		METHOD BuildCorrectionReceipt( obj )			// ��ନ஢��� 祪 ���४樨
		METHOD GetSaleCash							// ������� ���������� �� ���� ����� �����묨 ����樨 �த��� �� ᬥ��
		METHOD GetSaleCard							// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 �த��� �� ᬥ��
		METHOD GetReturnSaleCash						// ���������� �� ���� ����� �����묨 ����樨 ������ �த��� �� ᬥ��
		METHOD GetReturnSaleCard						// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ �த��� �� ᬥ��
		METHOD GetCash								// ���������� ����筮�� � ����
		METHOD GetIncome								// ���ᥭ�� �㬬� �� ᬥ��
		METHOD GetOutcome							// �믫�祭�� �㬬� �� ᬥ��
		METHOD PrintCopyReceipt( number )			// ����� ����� 祪�
	HIDDEN:
		METHOD ConfirmDate( date )					// ������� ���⢥ত���� �ணࠬ��஢���� ���� �� ����७��� ��� ���ன�⢠
		METHOD ExecuteCommand( command, lSilent )
		METHOD ErrorHandling( descFunc, lSilent )
		METHOD SendINNCashier()						// ��ࠢ��� ⥣ � ��� �����
	PROTECTED:
		METHOD GetRegim								// ������� ०�� ࠡ��� ���ன�⢠
ENDCLASS

// ����� ����� 祪�
METHOD PrintCopyReceipt( number )					CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	::FDriver:DocumentNumber := number
	ret := ::ExecuteCommand( 'FNPrintDocument', .f. )
	return ret

// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ �த��� �� ᬥ��
METHOD function GetReturnSaleCard						CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_RETURN_SALE_CARD )
	return ret

// ���������� �� ���� ����� �����묨 ����樨 ������ �த��� �� ᬥ��
METHOD function GetReturnSaleCash						CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_RETURN_SALE_CASH )
	return ret

// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 �த��� �� ᬥ��
METHOD function GetSaleCard							CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_SALE_CARD )
	return ret

// �믫�祭�� �㬬� �� ᬥ��
METHOD function GetOutcome()							CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_OUTCOME )
	return ret

// ���ᥭ�� �㬬� �� ᬥ��
METHOD function GetIncome()							CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_INCOME )
	return ret

// ���������� ����筮�� � ����
METHOD function GetCash()								CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_CASH )
	return ret

// ������� ���������� �� ���� ����� �����묨 ����樨 �த��� �� ᬥ��
METHOD GetSaleCash()									CLASS TKKT_Shtrih
	local ret := 0
	
	ret := ::GetCashReg( CASH_SALE_CASH )
	return ret

// ��ନ஢��� 祪 ���४樨
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

// ����� ᮤ�ন���� ����樮����� ॣ����
// nRegistr - ����� ��������� ॣ����
METHOD function GetOperationReg( nRegistr )			CLASS TKKT_Shtrih
	local ret := 0, result := .f.
		
	::FDriver:Password := ::Password
	::FDriver:RegisterNumber := nRegistr
	if ( result := ::ExecuteCommand( 'GetOperationReg', .f. ) )
		ret := ::FDriver:ContentsOfOperationRegister
	endif
	return ret

// ����� ᮤ�ন���� ��������� ॣ����
// 	nRegistr - ����� ��������� ॣ����
METHOD function GetCashReg( nRegistr )					CLASS TKKT_Shtrih
	local ret := 0, result := .f.
		
	::FDriver:Password := ::Password
	::FDriver:RegisterNumber := nRegistr
	if ( result := ::ExecuteCommand( 'GetCashReg', .f. ) )
		ret := ::FDriver:ContentsOfCashRegister
	endif
	return ret

// �����⨥ 祪� ���७���
//	oCloseCheck - ��ꥪ� ����뢠�騩 ������ ������� 祪�
METHOD function CloseCheck( oCloseCheck )			CLASS TKKT_Shtrih
	local ret := -1, result := .f., address
	
	// ��諥� ��� ����� ��। �����⨥� 祪�
//	if !empty( ::INNCashier )
//		::FDriver:Password := ::Password
//		::FDriver:TagNumber := 1203
//		::FDriver:TagType := 7
//		::FDriver:TagValueStr := ::INNCashier //'770405970581' //����� 㪠�뢠�� ॠ��� ��� �����.
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

// ������ � 祪�
//  oOperation - ��ꥪ� ��� ����樨 � 祪�
METHOD function Operation( oOperation )			CLASS TKKT_Shtrih
	local ret := .f.

	HB_CDPSELECT( 'RU1251' )
	::FDriver:Password := ::Password
	::FDriver:CheckType := oOperation:CheckType // ��� ����樨: 1-��室, 2-������ ��室�, 3-��室, 4-������ ��室�
	::FDriver:Quantity := oOperation:Quantity
	::FDriver:Price    := oOperation:Price
	::FDriver:Summ1    := oOperation:Summ1
	::FDriver:Summ1Enabled := oOperation:Summ1Enabled
	::FDriver:TaxValue := oOperation:TaxValue
	::FDriver:TaxValueEnabled := oOperation:TaxValueEnabled
	::FDriver:Tax1    := oOperation:Tax1
	::FDriver:Department := oOperation:Department
	::FDriver:PaymentTypeSign    := oOperation:PaymentTypeSign // ����� ����
	::FDriver:PaymentItemSign    := oOperation:PaymentItemSign // ��㣠
	::FDriver:StringForPrinting := upper( dos2win( oOperation:StringForPrinting ) )
	::FReceiptOpen := ( ret := ::ExecuteCommand( 'FNOperation' ) )
	HB_CDPSELECT( 'RU866' )
	return ret

// ������ ᬥ�� �� �᪠�쭮� ������⥫�
METHOD function FNOpenSession()						CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::Password
	::ExecuteCommand( 'FNBeginOpenSession' )
	::SendINNCashier()
	::FDriver:Password := ::Password
	if ( ret := ::ExecuteCommand( 'FNOpenSession' ) )
		// ������� ����砭�� ����
		::FDriver:Password := ::Password
		::ExecuteCommand( 'WaitForPrinting' )
		::FOpenSession := .t.
	endif
	return ret

// ��१�� 祪���� �����
// flag - 0 ������ ��१��
//        1 ����� ��१
METHOD CutCheck( flag )								CLASS TKKT_Shtrih
	local ret := .f.
	
//	HB_Default( @flag, 0 ) 
	::FDriver:Password := ::Password
	::FDriver:CutType := iif( HB_DefaultValue( flag, 1 ) == 1, 1, 0 )
	ret := ::ExecuteCommand( 'CutCheck' )
	return ret

// ������� ���⢥ত���� �ணࠬ��஢���� ���� �� ����७��� ��� ���ன�⢠
METHOD ConfirmDate( date )							CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	::FDriver:Date := date
	ret := ::ExecuteCommand( 'ConfirmDate' )
	return ret

// ��⠭�������� ���� �� ����७��� ��� ���ன�⢠
METHOD function SetDate( date )							CLASS TKKT_Shtrih
	local ret := .f.
	local regim, strTitle := '��⠭���� ���� � �६��� � ���ᮢ�� ������'
	local str := '����� �।�����祭 ��� ��������� ���� ��� �६��� � ���ᮢ�� ������.' + chr( 13 ) + chr( 10 ) + ;
		'�믮������ ⮫쪮 �� �����⮩ ᬥ��!' + chr( 13 ) + chr( 10 ) + '�� ��� ������� ᬥ��?'

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

// ����砥� ���� �� ����७��� �ᮢ ���ன�⢠
METHOD function GetDate()								CLASS TKKT_Shtrih
	local ret := ctod( '' )
	
	if ::GetECRStatus( .t. )
		ret := ::FECRStatus[ 'DATE' ]
	endif
	return ret

// ��⠭�������� �६� �� ����७��� ��� ���ன�⢠
//  time   - �६� � �ଠ� ��:��:��
METHOD function SetTime( time )							CLASS TKKT_Shtrih
	local ret := .f.
	local regim, strTitle := '��⠭���� ���� � �६��� � ���ᮢ�� ������'
	local str := '����� �।�����祭 ��� ��������� ���� ��� �६��� � ���ᮢ�� ������.' + chr( 13 ) + chr( 10 ) + ;
		'�믮������ ⮫쪮 �� �����⮩ ᬥ��!' + chr( 13 ) + chr( 10 ) + '�� ��� ������� ᬥ��?'

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

// ����砥� �६� �� ����७��� �ᮢ ���ன�⢠
METHOD function GetTime()								CLASS TKKT_Shtrih
	local ret := 0
	
	if ::GetECRStatus( .t. )
		ret := ::FECRStatus[ 'TIME' ]
	endif
	return ret

// �த������ �����
METHOD function ContinuePrint()						CLASS TKKT_Shtrih
	local ret := .f.

	if ::GetRegim() == 3
		::FDriver:Password := ::Password
		ret := ::ExecuteCommand( 'ContinuePrint' )
	endif
	return ret

// ��⠭����� ��� ���짮��⥫� � ���ன�⢥
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

// ������� ����� ���ଠ樮����� ������
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

// �⬥�� 祪�
METHOD function CancelCheck()							CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	ret := ::ExecuteCommand( 'CancelCheck' )
	return ret

// ���� ���� ��� ��襭��
METHOD function PrintReportWithoutCleaning()			CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::PasswordAdmin
	ret := ::ExecuteCommand( 'PrintReportWithoutCleaning' )
	return ret

// ���� ���� � ��襭���
METHOD function PrintReportWithCleaning()				CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := '���⨥ ����'
	local strCloseReport := '������� ᬥ��.' + chr( 13 ) + chr( 10 ) + '���⨥ ���� � ��襭��� ����������!'

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

// ��⮤ ���⠥� ����� � �த���� �� �������
METHOD procedure PrintTaxReport						CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := '���⨥ ����'
	local strCloseReport := '������� ᬥ��.' + chr( 13 ) + chr( 10 ) + '���⨥ ���� �� ������� ����������!'

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

// ��⮤ ���⠥� ����� � �த���� �� �⤥��� (ᥪ��)
METHOD procedure PrintDepartmentReport				CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := '���⨥ ����'
	local strCloseReport := '������� ᬥ��.' + chr( 13 ) + chr( 10 ) + '���⨥ ���� �� ���ࠧ������� ����������!'

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

// ���� ���� �� ����ࠬ
METHOD procedure PrintCashierReport					CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := '���⨥ ����'
	local strCloseReport := '������� ᬥ��.' + chr( 13 ) + chr( 10 ) + '���⨥ ���� �� ����ࠬ ����������!'

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

// ���� ���ᮢ�� ����
METHOD procedure PrintHourlyReport					CLASS TKKT_Shtrih
	local ret := .f.
	local regim
	local strTitle := '���⨥ ����'
	local strCloseReport := '������� ᬥ��.' + chr( 13 ) + chr( 10 ) + '���⨥ ���� �� �ᠬ ����������!'

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

// ������� ०�� ࠡ��� ���ன�⢠
METHOD function GetRegim								CLASS TKKT_Shtrih
	local ret := -1

	if ( ::GetShortECRStatus() )
		ret := ::FShortECRStatus[ 'ECRMODE' ]
	endif
	return ret

// ���ᥭ�� �������� �㬬� � �����
METHOD function CashIncome( summ1 )					CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	::FDriver:Summ1 := summ1
	if ( ret := ::ExecuteCommand( 'CashIncome' ) )
		::FOpenDocumentNumber := ::FDriver:OpenDocumentNumber
	endif
	return ret


// �믫�� �������� �㬬� �� �����
METHOD function CashOutcome( summ1 )					CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	::FDriver:Summ1 := summ1
	if ( ret := ::ExecuteCommand( 'CashOutcome' ) )
		::FOpenDocumentNumber := ::FDriver:OpenDocumentNumber
	endif
	return ret

// �த������ ���㬥��
//  flag - 0 ����஫쭠� ����
//           1 祪���� ����
//           2 ��� �����
//    numStr - ������⢮ �ண��塞�� ��ப
METHOD function FeedDocument( flag, numStr )			CLASS TKKT_Shtrih
	local ret := .f.

	::FDriver:Password := ::Password
	::FDriver:StringQuantity := hb_DefaultValue( numStr, 1 )
	if flag == 0 .or. flag == 2 //����஫쪠
		::FDriver:UseJournalRibbon := .t.
	else
		::FDriver:UseReceiptRibbon := .t.
	endif
	ret := ::ExecuteCommand( 'FeedDocument' )
	return ret

// ������� ������ �����᪮� ����� � ���
METHOD function GetLongSerialNumberAndLongRNM()		CLASS TKKT_Shtrih
	local ret := .f.
	
alertx('getnumber')
	if ( ret := ::ExecuteCommand( 'GetLongSerialNumberAndLongRNM' ) )
		::FRNM := alltrim( ::FDriver:RNM )
		::FSerialNumber := alltrim( ::FDriver:SerialNumber )
	endif
alertx('end getnumber')
	return ret


* ExecuteCommand( command, lSilent ) - �ᯮ������ ������� �᪠�쭮�� ॣ������
* command - �ᯮ��塞�� ������� ��
* lSilent - ०�� �믮������ ������� (.T. - ��� �뤠� ᮮ�饭�� � ��� ����஢,
*       .f. - � �뤠祩 ᮮ�饭�� � ����ࠬ� 
METHOD function ExecuteCommand( command, lSilent )		CLASS TKKT_Shtrih
	local res := .f., ret := .t.
	local counter := 0

	HB_Default( @lSilent, .f. ) 

	command := lower( command )
	do while .t.
		counter++
		do case
			case command == 'finddevice'
				res := ::ErrorHandling( '���� ���ன�⢠', lSilent, ::FDriver:FindDevice() )
			// ��⮤� �⥭��/����� ������ ��/� ���
			case command == 'getcashreg'
				res := ::ErrorHandling( '������� ������� ॣ����', lSilent, ::FDriver:GetCashReg() )
			case command == 'getoperationreg'
				res := ::ErrorHandling( '������� ����樮��� ॣ����', lSilent, ::FDriver:GetOperationReg() )
			case command == 'getdevicemetrics'
				res := ::ErrorHandling( '������� ��ࠬ���� ���ன�⢠', lSilent, ::FDriver:GetDeviceMetrics() )
			case command == 'getshortecrstatus'
				res := ::ErrorHandling( '������� ���⪨� ����� ���ﭨ� ���', lSilent, ::FDriver:GetShortECRStatus() )
			case command == 'getecrstatus'
				res := ::ErrorHandling( '������� ���ﭨ� ���', lSilent, ::FDriver:GetECRStatus() )
			case command == 'fngetstatus'
				res := ::ErrorHandling( '����� ����� ��', lSilent, ::FDriver:FNGetStatus() )
			case command == 'getlongserialnumberandlongrnm'
				res := ::ErrorHandling( '������� ������ �����᪮� ����� � ���', lSilent, ::FDriver:GetLongSerialNumberAndLongRNM() )
			case command == 'opendrawer'
				res := ::ErrorHandling( '������ ������� �騪', lSilent, ::FDriver:OpenDrawer() )
			case command == 'cashincome'
				res := ::ErrorHandling( '���ᥭ�� �������� �㬬� � �����', lSilent, ::FDriver:CashIncome() )
			case command == 'cashoutcome'
				res := ::ErrorHandling( '�믫�� �������� �㬬� �� �����', lSilent, ::FDriver:CashOutcome() )
			case command == 'feeddocument'
				res := ::ErrorHandling( '�த������ ���㬥��', lSilent, ::FDriver:FeedDocument() )
			case command == 'printstring'
				res := ::ErrorHandling( '����� ��ப�', lSilent, ::FDriver:PrintString() )
			case command == 'printwidestring'
				res := ::ErrorHandling( '����� ��୮� ��ப�', lSilent, ::FDriver:PrintWideString() )
			case command == 'printreportwithoutcleaning'
				res := ::ErrorHandling( '����� ���� ��� ��襭��', lSilent, ::FDriver:PrintReportWithoutCleaning() )
			case command == 'printreportwithcleaning'
				res := ::ErrorHandling( '����� ���� � ��襭���', lSilent, ::FDriver:PrintReportWithCleaning() )
			case command == 'cancelcheck'
				res := ::ErrorHandling( '���㫨஢��� 祪', lSilent, ::FDriver:CancelCheck() )
			case command == 'getfieldstruct'
				res := ::ErrorHandling( '������� �������� ���� ⠡����', lSilent, ::FDriver:GetFieldStruct() )
			case command == 'writetable'
				res := ::ErrorHandling( '������� ⠡����', lSilent, ::FDriver:WriteTable() )
			case command == 'continueprint'
				res := ::ErrorHandling( '�த������ �����', lSilent, ::FDriver:ContinuePrint() )
			case command == 'settime'
				res := ::ErrorHandling( '��⠭����� �६�', lSilent, ::FDriver:SetTime() )
			case command == 'setdate'
				res := ::ErrorHandling( '��⠭����� ����', lSilent, ::FDriver:SetDate() )
			case command == 'confirmdate'
				res := ::ErrorHandling( '���⢥न�� ����', lSilent, ::FDriver:ConfirmDate() )
			case command == 'cutcheck'
				res := ::ErrorHandling( '��१��� 祪', lSilent, ::FDriver:CutCheck() )
			case command == 'waitforprinting'
				res := ::ErrorHandling( '�������� ����', lSilent, ::FDriver:WaitForPrinting() )
			case command == 'printcashierreport'
				res := ::ErrorHandling( '���� �� ����ࠬ', lSilent, ::FDriver:PrintCashierReport() )
			&& case command == 'printreportwithcleaning'
				&& res := ::ErrorHandling( '����� ���� � ��襭���', lSilent, ::FDriver:PrintReportWithCleaning() )
			case command == 'printdepartmentreport'
				res := ::ErrorHandling( '���� �� ᥪ��', lSilent, ::FDriver:PrintDepartmentReport() )
			case command == 'printtaxreport'
				res := ::ErrorHandling( '���� �� �������', lSilent, ::FDriver:PrintTaxReport() )
			case command == 'printhourlyreport'
				res := ::ErrorHandling( '���� �� �ᠬ', lSilent, ::FDriver:PrintHourlyReport() )
			case command == 'readserialnumber'
				res := ::ErrorHandling( '������ �����᪮� �����', lSilent, ::FDriver:ReadSerialNumber() )
			// ������ � �᪠��� ������⥫�� 54-��
			case command == 'fnopensession'
				res := ::ErrorHandling( '������ ᬥ��', lSilent, ::FDriver:FNOpenSession() )
			case command == 'fngetinfoexchangestatus'
				res := ::ErrorHandling( '������� ����� ���ଠ樮����� ������ ��', lSilent, ::FDriver:FNGetInfoExchangeStatus() )
			case command == 'fnoperation'
				res := ::ErrorHandling( '�� ������', lSilent, ::FDriver:FNOperation() )
			case command == 'fnclosecheckex'
				res := ::ErrorHandling( '�����⨥ 祪� ���७��� (��ਠ�� 2)', lSilent, ::FDriver:FNCloseCheckEx() )
			case command == 'fnbegincorrectionreceipt'
				res := ::ErrorHandling( '����� �ନ஢���� 祪� ���४樨', lSilent, ::FDriver:FNBeginCorrectionReceipt() )
			case command == 'fnbuildcorrectionreceipt2'
				res := ::ErrorHandling( '��ନ஢��� 祪 ���४樨. ������� ���ᨨ 2.', lSilent, ::FDriver:fnbuildcorrectionreceipt2() )
			case command == 'fnprintdocument'
				res := ::ErrorHandling( '��ᯥ���� ���㬥��', lSilent, ::FDriver:FNPrintDocument() )
			case command == 'fnbeginopensession'
				res := ::ErrorHandling( '����� ����⨥ ᬥ��', lSilent, ::FDriver:FNBeginOpenSession() )
			case command == 'fnopensession'
				res := ::ErrorHandling( '������ ᬥ��', lSilent, ::FDriver:FNOpenSession() )
			case command == 'fnbeginclosesession'
				res := ::ErrorHandling( '����� ������� ᬥ��', lSilent, ::FDriver:FNBeginCloseSession() )
			case command == 'fnclosesession'
				res := ::ErrorHandling( '������� ᬥ��', lSilent, ::FDriver:FNCloseSession() )
			case command == 'fnsendtag'
				res := ::ErrorHandling( '��ࠢ��� ⥣', lSilent, ::FDriver:FNSendTag() )
				
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
	
* ErrorHandling( descFunc, lSilent ) - �ᯮ������ ������� �᪠�쭮�� ॣ������ � ��ࠡ�⪮� �訡��
* descFunc - ���ᠭ�� ������� �᪠�쭮�� ॣ������
* lSilent - �娩 ०�� (.T. - ��� �뤠� ᮮ�饭�� � ��� ����஢,
*      					.f. - � �뤠祩 ᮮ�饭�� � ����ࠬ� )
METHOD ErrorHandling( descFunc, lSilent )			CLASS TKKT_Shtrih
	local code, ret := FR_SUCCESS
	local errOEM
	local res

	if HB_CDPSELECT() == 'RU1251'
		HB_CDPSELECT( 'RU866' )
	endif
	
	// ����稬 १���� �믮������ �������
	::FResultCode := ::FDriver:ResultCode
	::FResultCodeDescription := ::FDriver:ResultCodeDescription
	errOEM := ::FResultCodeDescription
  
	// ������ ��諠 �ᯥ譮
	if ::FResultCode == FR_SUCCESS
		return FR_SUCCESS
	endif

	// �������� �஡���� � ���ᮢ� �����⮬, ����襬 �訡�� � ����⠥��� ��ࠢ��� ��
	if ::FResultCode == ERR_WAIT_CONTINUE_PRINT
		::FDriver:ContinuePrint()
		ret := IDRETRY
	elseif ::FResultCode == ERR_COM_NOT
		ret := hwg_MsgRetryCancelBay( '������ �᪠��� ॣ������ � ����⠩��� ᭮��.', '�ࠩ��� ����-��' ) 
	elseif ::FResultCode == ERR_NOT_CONNECT
		if ( res := hwg_MsgNoYesBay( '���ன�⢮ �� �������. ��������� ���� ���ன�⢮.', '�ࠩ��� ����-��' ) )
			::ExecuteCommand( 'FindDevice' )
		else
			ret := IDCANCEL
		endif
	else
		if lSilent
			ret := IDCANCEL
		else
			ret := hwg_MsgRetryCancelBay( ::FResultCodeDescription + '. ����⠩��� ��ࠢ��� �訡��.', '�ࠩ��� ����-��' ) 
		Endif
	endif
	return ret
	
// ����㧨�� �ࠩ��� ���
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

// ����㧨�� ����ன�� ���
//METHOD function Open( oSetting, nPasswordUser )		CLASS TKKT_Shtrih
//	return ::Open( oSetting, nPasswordUser )
METHOD function Open( oSetting, oUser )		CLASS TKKT_Shtrih
	return ::Open( oSetting, oUser )

METHOD New()		CLASS TKKT_Shtrih
	return self

// �������� ᢮��⢠ �ࠩ��� ���
METHOD function ShowProperties()						CLASS TKKT_Shtrih
	return ::FDriver:ShowProperties

// ������� ����� �ࠩ��� ���
METHOD function Version()								CLASS TKKT_Shtrih
	return ::FDriver:DriverVersion

// ������ ������� �騪
// nDrawerNumber - ����� ��������� �騪�, �����⨬�� ���祭�� 0 ��� 1
METHOD function OpenDrawer( nDrawerNumber )			CLASS TKKT_Shtrih
	local ret := .f.
	
	hb_Default( @nDrawerNumber, 0 )
	nDrawerNumber := iif( nDrawerNumber != 0 .or. nDrawerNumber != 1, 0, nDrawerNumber )
	::FDriver:Password := ::Password
	::FDriver:DrawerNumber := nDrawerNumber
	return ::ExecuteCommand( 'OpenDrawer' )

// ������� ��ࠬ���� ���ன�⢠
METHOD function GetDeviceMetrics()						CLASS TKKT_Shtrih
	local ret := .f.
	
	if  ::FDeviceMetrics == nil
		if ( ret := ::ExecuteCommand( 'GetDeviceMetrics' ) )
			::FDeviceMetrics := { => }
			::FDeviceMetrics[ 'UMAJORPROTOCOLVERSION' ] := ::FDriver:UMajorProtocolVersion	/* ����� ��⮪��� �裡 � ��, �ᯮ��㥬�� ���ன�⢮� */
			::FDeviceMetrics[ 'UMINORPROTOCOLVERSION' ] := ::FDriver:UMinorProtocolVersion	/* �������� ��⮪��� �裡 � ��, �ᯮ��㥬�� ���ன�⢮� */
			::FDeviceMetrics[ 'UMAJORTYPE' ] := ::FDriver:UMajorType						/* ��� ����訢������ ���ன�⢠ */
			::FDeviceMetrics[ 'UMINORTYPE' ] := ::FDriver:UMinorType						/* ���⨯ ����訢������ ���ன�⢠ */
			::FDeviceMetrics[ 'UMODEL' ] := ::FDriver:UModel								/* ������ ����訢������ ���ன�⢠ */
			::FDeviceMetrics[ 'UCODEPAGE' ] := ::FDriver:UCodePage							/* ������� ��࠭��, �ᯮ��㥬�� ���ன�⢮� (0 - ���᪨� ��) */
			::FDeviceMetrics[ 'UDESCRIPTION' ] := ::FDriver:UDescription					/* �������� ���ன�⢠ - ��ப� ᨬ����� ⠡���� WIN1251 */
			::FDeviceMetrics[ 'CAPGETSHORTECRSTATUS' ] := ::FDriver:CapGetShortECRStatus	/* ������� GetShortECRStatus �����ন������ */
		endif
	endif
	return ret

// ������� ��⪮� ���ﭨ� ���ன�⢠
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

// ������� ������ ���ﭨ� ���ன�⢠
METHOD function GetECRStatus( flag )					CLASS TKKT_Shtrih
// flag - 䫠� .f. - �� ����訢���, .t. ����訢���
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

// ������� ���ﭨ� �᪠�쭮�� ������⥫� ���ன�⢠
METHOD function FNGetStatus()							CLASS TKKT_Shtrih
	local ret := .f.
	
	::FDriver:Password := ::PasswordAdmin
	if ( ret := ::ExecuteCommand( 'FNGetStatus' ) )
		::FFNStatus := { => }
		::FFNStatus[ 'FNLIFESTATE' ]		:= ::FDriver:FNLifeState		// ���ﭨ� ����� ��
		::FFNStatus[ 'FNCURRENTDOCUMENT' ]	:= ::FDriver:FNCurrentDocument	// ⥪�騩 ���㬥�� ��
		::FFNStatus[ 'FNDOCUMENTDATA' ]		:= ::FDriver:FNDocumentData		// ����� ���㬥��
		::FFNStatus[ 'FNSESSIONSTATE' ]		:= ::FDriver:FNSessionState		// ���ﭨ� ᬥ��
		::FFNStatus[ 'FNWARNINGFLAGS' ]		:= ::FDriver:FNWarningFlags		// 䫠�� �।�०�����
		::FFNStatus[ 'DATE' ]				:= ::FDriver:Date				// ���
		::FFNStatus[ 'TIME' ]				:= ::FDriver:Time				// �६�
		::FFNStatus[ 'SERIALNUMBER' ]		:= ::FDriver:SerialNumber		// �����᪮� ����� ��
		::FFNStatus[ 'DOCUMENTNUMBER' ]		:= ::FDriver:DocumentNumber		// ����� ��
		
		::FOpenSession := iif( ::FDriver:FNSessionState == 0, .f., .t. )
	else
		::FFNStatus := nil
	endif
	return ret

METHOD function Beep()									CLASS TKKT_Shtrih
	::FDriver:Password := ::Password
	::FDriver:Beep()
	return ::FDriver:OperatorNumber

// ����� ��ப� ⥪�� �� ���
//	stringForPrinting - ��ப� ��� ���� �� ��
//	lWide - ����� ���� .T., ��� ����� .f. ���⮬
//	typeControlRibbon - ������ �� ����஫쭮� ����:
//		0 - ����� �����, 
//		1 - �� ������ �� ����஫쭮� ����,
//		2 - �� ����� �� 祪���� ����
METHOD function PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )		CLASS TKKT_Shtrih
	local ret := .f.
	
	HB_Default( @typeControlRibbon, 0 )
	HB_Default( @lWide, .f. )
	HB_Default( @lDelayedPrint, .f. )
	
//	if ::FDriver != nil
		stringForPrinting := atrepl( ',', alltrim( stringForPrinting ), ';' )   // �������� ";" �� "," ��ப�
		stringForPrinting := charone( ' ', stringForPrinting )                // 㤠���� ᮢ��饭�� �஡���
		stringForPrinting := substr( stringForPrinting, 1, 249 )                // ��०�� �� 249 ᨬ�����
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
	
// ��ࠢ��� ⥣ � ��� �����
METHOD SendINNCashier() CLASS TKKT_Shtrih
	local ret := .t.
	
	if !empty( ::INNCashier )
		::FDriver:Password := ::Password
		::FDriver:TagNumber := 1203
		::FDriver:TagType := 7
		::FDriver:TagValueStr := ::INNCashier //����� 㪠�뢠�� ��� �����.
		::ExecuteCommand( 'FNSendTag' )
	endif
	return ret
