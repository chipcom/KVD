#include 'property.ch'
#include "hbclass.ch"

//
// Class TServiceKKT
//
CLASS TServiceKKT
    EXPORTED:
		PROPERTY IsFiscalReg READ getIsFiscalReg
		PROPERTY Change READ getChange
		PROPERTY EnableTypePay2 READ getEnableTypePay2	// ࠧ���� ��� ������ 2
		PROPERTY EnableTypePay3 READ getEnableTypePay3	// ࠧ���� ��� ������ 3
		PROPERTY EnableTypePay4 READ getEnableTypePay4	// ࠧ���� ��� ������ 4
		PROPERTY NameTypePay2 READ getNameTypePay2		// �������� ���� ������ 2
		PROPERTY NameTypePay3 READ getNameTypePay3		// �������� ���� ������ 3
		PROPERTY NameTypePay4 READ getNameTypePay4		// �������� ���� ������ 4
		PROPERTY OtherTypePay READ getOtherTypePay
		
		METHOD PrintPatient	INLINE ::FKKT:PrintPatient
		METHOD PrintDoctor	INLINE ::FKKT:PrintDoctor
		METHOD PrintCodeService	INLINE ::FKKT:PrintCodeService
		METHOD PrintNameService	INLINE ::FKKT:PrintNameService
		METHOD OpenADrawer	INLINE ::FKKT:OpenADrawer
		METHOD SerialNumber	INLINE ::FKKT:SerialNumber	// ������� ������ �����᪮� ����� (�� 9 �� 14 ᨬ�����)
		METHOD OpenSession	INLINE ::FKKT:OpenSession	// �ਧ��� ����⮩ ��ᨨ
		
		METHOD Driver 		INLINE ::FKKT:FDriver
		METHOD IsLoaded 		INLINE ::FKKT:IsLoaded		// �ࠩ��� ����㦥�
		METHOD PasswordAdmin	INLINE ::FKKT:PasswordAdmin	// ��஫� �����������
		METHOD Password		INLINE ::FKKT:Password		// ��஫�
		METHOD RegimKKT		INLINE ::FKKT:RegimKKT		// ������� ०�� ࠡ��� ���ன�⢠
		METHOD InfoExchangeStatus	INLINE ::FKKT:InfoExchangeStatus	// ����� ���ଠ樮����� ������
		METHOD MessageStatus	INLINE ::FKKT:MessageStatus// ���ﭨ� �⥭�� ᮮ�饭��
		METHOD MessageCount	INLINE ::FKKT:MessageCount	// ������⢮ ᮮ�饭�� ��� ���
		METHOD FirstDocumentNumber	INLINE ::FKKT:FirstDocumentNumber	// ����� ���㬥�� ��� ��� ��ࢮ�� � ��।�
		METHOD DateFirstDocument	INLINE ::FKKT:DateFirstDocument	// ��� ���㬥�� ��� ��� ��ࢮ�� � ��।�
		METHOD TimeFirstDocument	INLINE ::FKKT:TimeFirstDocument	// �६� ���㬥�� ��� ��� ��ࢮ�� � ��।�
		
		METHOD SetKKT( typeKKT )
		METHOD CheckExchangeStatus( flag )						// �஢�ઠ ����� ������
		METHOD New() CONSTRUCTOR
		METHOD Init
		METHOD Open
		METHOD ShowProperties()
		METHOD Version
		METHOD Beep
		METHOD PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )
		METHOD OpenDrawer( nDrawerNumber )			// ������ ������� �騪
		METHOD CashIncome( summ1 )					// ���ᥭ�� �������� �㬬� � �����
		METHOD CashOutcome( summ1 )					// �믫�� �������� �㬬� �� �����
		METHOD FeedDocument( flag, numStr )			// �த������ ���㬥��
		METHOD GetDeviceMetrics						// ������� ��ࠬ���� ���ன�⢠
		METHOD GetShortECRStatus						// ������� ��⪮� ���ﭨ� �᪠�쭮�� ॣ������
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

// ����� ����� 祪�
METHOD PrintCopyReceipt( number )			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintCopyReceipt( number )
	endif
	return ret

// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ �த��� �� ᬥ��
METHOD function GetReturnSaleCard				CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetReturnSaleCard()
	endif
	return ret

// ���������� �� ���� ����� �����묨 ����樨 ������ �த��� �� ᬥ��
METHOD function GetReturnSaleCash				CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetReturnSaleCash()
	endif
	return ret

// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 �த��� �� ᬥ��
METHOD function GetSaleCard					CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetSaleCard()
	endif
	return ret

// �믫�祭�� �㬬� �� ᬥ��
METHOD function GetOutcome						CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetOutcome()
	endif
	return ret

// ���ᥭ�� �㬬� �� ᬥ��
METHOD function GetIncome()					CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetIncome()
	endif
	return ret

// ���������� ����筮�� � ����
METHOD function GetCash()						CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetCash()
	endif
	return ret

// ������� ���������� �� ���� ����� �����묨 ����樨 �த��� �� ᬥ��
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
			strMessage := '�������� ������� ' + alltrim( str( ::FKKT:MessageCount ) ) + ;
				' �� ��ࠢ����' + iif( ::FKKT:MessageCount == 1, '� ���㬥��', '�� ���㬥�⮢' ) + ' � ���!' + ;
				chr( 10 ) + '��� ��ࢮ�� ����ࠢ������� ���㬥��: ' + dtoc( ::FKKT:DateFirstDocument ) + ' �.'
			hb_Alert( strMessage, , , 4 )
		elseif hb_DefaultValue( flag, .t. )
			hb_Alert( '���������� �� ��ࠢ����� � ��� ���㬥���', , , 4 )
		endif
	endif
	return


METHOD New()									CLASS TServiceKKT
	return self

// ����㧨�� �ࠩ��� ���
METHOD function Init()							CLASS TServiceKKT
	return ::FKKT:Init

// ��ନ஢��� 祪 ���४樨
METHOD BuildCorrectionReceipt( obj )			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:BuildCorrectionReceipt( obj )
	endif
	return ret

// ��⮤ ���⠥� ����� � �த���� �� �������
METHOD procedure PrintTaxReport				CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintTaxReport()
	endif
	return ret

// ��⮤ ���⠥� ����� � �த���� �� �⤥��� (ᥪ��)
METHOD procedure PrintDepartmentReport		CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintDepartmentReport()
	endif
	return ret

// ���� ���� �� ����ࠬ
METHOD procedure PrintCashierReport			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintCashierReport()
	endif
	return ret

// ���� ���ᮢ�� ����
METHOD procedure PrintHourlyReport			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:PrintHourlyReport()
	endif
	return ret

// ����� ᮤ�ন���� ����樮����� ॣ����
// nRegistr - ����� ��������� ॣ����
METHOD function GetOperationReg( nRegistr )	CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetOperationReg( nRegistr )
	endif
	return ret

// ����� ᮤ�ন���� ��������� ॣ����
// nRegistr - ����� ��������� ॣ����
METHOD function GetCashReg( nRegistr )			CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetCashReg( nRegistr )
	endif
	return ret


// ����㧨�� ����ன�� ���
METHOD function Open( oSettings, nPasswordUser )	CLASS TServiceKKT
	return ::FKKT:Open( oSettings, nPasswordUser )

// �����⨥ 祪� ���७���
METHOD function CloseCheck( oCloseCheck )		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:CloseCheck( oCloseCheck )
	endif
	return ret

// ������ � 祪�
//  service - ��ꥪ� ��㣠 ��� 祪� TServiceOfCheck
//  stringForPrinting   - ������������ ⮢��/��㣨
METHOD function Operation( oOperation )		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:Operation( oOperation )
	endif
	return ret

// ������ ᬥ�� �� �᪠�쭮� ������⥫�
METHOD function FNOpenSession()				CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:FNOpenSession()
	endif
	return ret

// ��१�� 祪���� �����
// flag - 0 ������ ��१��
//        1 ����� ��१
METHOD CutCheck( flag )						CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:CutCheck( flag )
	endif
	return ret

// ��⠭�������� ���� �� ����७��� ��� ���ன�⢠
METHOD function SetDate( date )					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:SetDate( date )
	endif
	return ret

// ����砥� ���� �� ����७��� �ᮢ ���ன�⢠
METHOD function GetDate()						CLASS TServiceKKT
	local ret := ctod( '' )
	
	if ::IsLoaded
		ret := ::FKKT:GetDate()
	endif
	return ret

// ����砥� �६� �� ����७��� �ᮢ ���ன�⢠
METHOD function SetTime( time )					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:SetDate( time )
	endif
	return ret

// ����砥� �६� �� ����७��� �ᮢ ���ன�⢠
METHOD function GetTime()						CLASS TServiceKKT
	local ret := 0
	
	if ::IsLoaded
		ret := ::FKKT:GetTime()
	endif
	return ret

// �த������ �����
METHOD function ContinuePrint()				CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:ContinuePrint
	endif
	return ret

// ��⠭����� ��� ���짮��⥫� � ���ன�⢥
METHOD function SetOperatorKKT( nOp, cName )	CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:SetOperatorKKT( nOp, cName )
	endif
	return ret

// ������� ����� �ࠩ��� ���
METHOD function Version()						CLASS TServiceKKT
	local ret := '�ࠩ��� �� ����㦥�.'
	
	if ::IsLoaded
		ret := ::FKKT:Version
	endif
	return ret

// ������� ����� ���ଠ樮����� ������
METHOD function GetInfoExchangeStatus()					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetInfoExchangeStatus()
	endif
	return ret

// �⬥�� 祪�
METHOD function CancelCheck()					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:CancelCheck()
	endif
	return ret

// ������ �㤮�
METHOD function Beep()						CLASS TServiceKKT
	local ret := '�ࠩ��� �� ����㦥�.'
	
	if ::IsLoaded
		ret := ::FKKT:Beep()
	endif
	return ret

// ���� ���� ��� ��襭��
METHOD PrintReportWithoutCleaning()		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:PrintReportWithoutCleaning()
	endif
	return ret

// ���� ���� � ��襭���
METHOD PrintReportWithCleaning()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:PrintReportWithCleaning()
	endif
	return ret

// ������ ������� �騪
METHOD function OpenDrawer( nDrawerNumber )	CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded .and. ::FOpenADrawer
		ret := ::FKKT:OpenDrawer( nDrawerNumber )
	endif
	return ret

// ���ᥭ�� �������� �㬬� � �����
METHOD function CashIncome( summ1 )					CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded
		ret := ::FKKT:CashIncome( summ1 )
	endif
	return ret

// �믫�� �������� �㬬� �� �����
METHOD function CashOutcome( summ1 )					CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded
		ret := ::FKKT:CashOutcome( summ1 )
	endif
	return ret

// �த������ ���㬥��
METHOD function FeedDocument( flag, numStr )			CLASS TServiceKKT
	local ret := .t.
	
	if ::IsLoaded
		ret := ::FKKT:FeedDocument( flag, numStr )
	endif
	return ret

// ������� ��ࠬ���� ���ன�⢠
METHOD function GetDeviceMetrics()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetDeviceMetrics()
	endif
	return ret

// ������� ��⪮� ���ﭨ� ���ன�⢠
METHOD function GetShortECRStatus()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetShortECRStatus()
	endif
	return ret

// ������� ������ ���ﭨ� ���ன�⢠
METHOD function GetECRStatus( flag )			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetECRStatus( flag )
	endif
	return ret

// ������� ���ﭨ� �᪠�쭮�� ������⥫� ���ன�⢠
METHOD function FNGetStatus()					CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:FNGetStatus()
	endif
	return ret

// ������� ������ �����᪮� ����� � ���
METHOD function GetLongSerialNumberAndLongRNM()			CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:GetLongSerialNumberAndLongRNM()
	endif
	return ret

// ����� ��ப� ⥪�� �� ���
METHOD function PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )		CLASS TServiceKKT
	local ret := .f.
	
	if ::IsLoaded
		ret := ::FKKT:PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )
	endif
	return ret

// �������� ᢮��⢠ �ࠩ��� ���
METHOD function ShowProperties()				CLASS TServiceKKT
	return ::FKKT:ShowProperties

// ��⠭����� ��ꥪ� �ࠩ���
METHOD procedure SetKKT( typeKKT )			CLASS TServiceKKT

    ::FKKT := typeKKT
	return