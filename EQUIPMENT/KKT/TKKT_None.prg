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
		METHOD GetInfoExchangeStatus				// ������� ����� ���ଠ樮����� ������
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
	PROTECTED:
		METHOD GetRegim								// ������� ०�� ࠡ��� ���ன�⢠
	
ENDCLASS

// ����� ����� 祪�
METHOD PrintCopyReceipt( number )					CLASS TKKT_None
	return .t.

// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ �த��� �� ᬥ��
METHOD function GetReturnSaleCard						CLASS TKKT_None
	return 0

// ���������� �� ���� ����� �����묨 ����樨 ������ �த��� �� ᬥ��
METHOD function GetReturnSaleCash						CLASS TKKT_None
	return 0

// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 �த��� �� ᬥ��
METHOD function GetSaleCard							CLASS TKKT_None
	return 0

// �믫�祭�� �㬬� �� ᬥ��
METHOD function GetOutcome()							CLASS TKKT_None
	return 0

// ���ᥭ�� �㬬� �� ᬥ��
METHOD function GetIncome()							CLASS TKKT_None
	return 0

// ���������� ����筮�� � ����
METHOD function GetCash()								CLASS TKKT_None
	return 0

// ������� ���������� �� ���� ����� �����묨 ����樨 �த��� �� ᬥ��
METHOD GetSaleCash()									CLASS TKKT_None
	return 0

// ��ନ஢��� 祪 ���४樨
METHOD BuildCorrectionReceipt( obj )					CLASS TKKT_None
	return .t.

// ��⮤ ���⠥� ����� � �த���� �� �������
METHOD procedure PrintTaxReport						CLASS TKKT_None
	return .t.

// ��⮤ ���⠥� ����� � �த���� �� �⤥��� (ᥪ��)
METHOD procedure PrintDepartmentReport				CLASS TKKT_None
	return .t.

// ���� ���� �� ����ࠬ
METHOD procedure PrintCashierReport					CLASS TKKT_None
	return .t.

// ���� ���ᮢ�� ����
METHOD procedure PrintHourlyReport					CLASS TKKT_None
	return .t.

// ����㧨�� �ࠩ��� ���
METHOD function Init()									CLASS TKKT_None
	::FDriverLoaded := .t.
	return .t.

// ����� ᮤ�ন���� ����樮����� ॣ����
// nRegistr - ����� ��������� ॣ����
METHOD function GetOperationReg( nRegistr )			CLASS TKKT_None
	return 0

// ����� ᮤ�ন���� ��������� ॣ����
// 	nRegistr - ����� ��������� ॣ����
METHOD function GetCashReg( nRegistr )					CLASS TKKT_None
	return 0

// �����⨥ 祪� ���७���
METHOD function CloseCheck( oCloseCheck )				CLASS TKKT_None
	return .t.

// ������ � 祪�
METHOD function Operation( oOperation )				CLASS TKKT_None
	return .t.
	
// ������ ᬥ�� �� �᪠�쭮� ������⥫�
METHOD function FNOpenSession()						CLASS TKKT_None
	::FOpenSession := .t.
	return .t.

// ��१�� 祪���� �����
METHOD CutCheck( flag )								CLASS TKKT_None
	return .t.

// ��⠭�������� ���� �� ����७��� ��� ���ன�⢠
METHOD function SetDate( date )							CLASS TKKT_None
	return .t.

// ����砥� ���� �� ����७��� �ᮢ ���ன�⢠
METHOD function GetDate()								CLASS TKKT_None
	return ctod( '' )

// ��⠭�������� �६� �� ����७��� ��� ���ன�⢠
METHOD function SetTime( time )							CLASS TKKT_None
	return .t.

// ����砥� �६� �� ����७��� �ᮢ ���ன�⢠
METHOD function GetTime()								CLASS TKKT_None
	return 0

// �த������ �����
METHOD function ContinuePrint()						CLASS TKKT_None
	return .t.

// ��⠭����� ��� ���짮��⥫� � ���ன�⢥
METHOD function SetOperatorKKT( nOp, cName )			CLASS TKKT_None
	return .t.

// ������� ����� ���ଠ樮����� ������
METHOD function GetInfoExchangeStatus()				CLASS TKKT_None
	return .t.

// �⬥�� 祪�
METHOD function CancelCheck()							CLASS TKKT_None
	return .t.

// ���� ���� ��� ��襭��
METHOD function PrintReportWithoutCleaning()			CLASS TKKT_None
	return .t.

// ���� ���� � ��襭���
METHOD function PrintReportWithCleaning()				CLASS TKKT_None
	return .t.

// ������ �㤮�
METHOD function Beep()									CLASS TKKT_None
	return .t.

// ������� ०�� ࠡ��� ���ன�⢠
METHOD function GetRegim								CLASS TKKT_None
	return -1

// ������� ������ �����᪮� ����� (�� 9 �� 14 ᨬ�����)
&& METHOD function GetSerialNumber						CLASS TKKT_None
	&& return 'NONE'

// ������� ��ࠬ���� ���ன�⢠
METHOD function GetDeviceMetrics()						CLASS TKKT_None
	return .t.

// ������ ������� �騪
METHOD function OpenDrawer( nDrawerNumber )			CLASS TKKT_None
	return .t.

// ���ᥭ�� �������� �㬬� � �����
METHOD function CashIncome( summ1 )					CLASS TKKT_None
	return .t.

// �믫�� �������� �㬬� �� �����
METHOD function CashOutcome( summ1 )					CLASS TKKT_None
	return .t.

// �த������ ���㬥��
METHOD function FeedDocument( flag, numStr )			CLASS TKKT_None
	return .t.

// ������� ��⪮� ���ﭨ� ���ன�⢠
METHOD function GetShortECRStatus()					CLASS TKKT_None
	return .t.

// ������� ������ ���ﭨ� ���ன�⢠
METHOD function GetECRStatus( flag )					CLASS TKKT_None
	return .t.

// ������� ���ﭨ� �᪠�쭮�� ������⥫� ���ன�⢠
METHOD function FNGetStatus()							CLASS TKKT_None
	return .t.

// ������� ������ �����᪮� ����� � ���
METHOD function GetLongSerialNumberAndLongRNM()		CLASS TKKT_None
	return .t.

// ����� ��ப� ⥪�� �� ���
METHOD function PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )		CLASS TKKT_None
	return .t.

// ����㧨�� ����ன�� ���
//METHOD function Open( oSetting, nPasswordUser )		CLASS TKKT_None
METHOD function Open( oSetting, oUser )		CLASS TKKT_None
	::FIsFiscalReg := .f.
	return .t.
	
// �������� ᢮��⢠ �ࠩ��� ���
METHOD function ShowProperties()						CLASS TKKT_None
	return '��ᬮ�� ᢮��� �� ����㯥�'

// ������� ����� �ࠩ��� ���
METHOD function Version()								CLASS TKKT_None
	return '1.0'
