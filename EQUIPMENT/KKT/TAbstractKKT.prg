#include 'property.ch'
#include 'hbclass.ch'

CLASS TAbstractKKT

	PUBLIC:
		PROPERTY SerialNumber READONLY
		PROPERTY OpenSession READONLY					// �ਧ��� ����⮩ ��ᨨ
		PROPERTY OpenADrawer READONLY	//READ GetOpenDrawer			// ���뢠�� ������� �騪
		PROPERTY IsFiscalReg READ getIsFiscalReg			// ���ன�⢮ �᪠��� ॣ������ ��� ���
		PROPERTY RNM READ FRNM
		PROPERTY RegimKKT READ GetRegim
		PROPERTY IsLoaded READ FDriverLoaded				// �ࠩ��� ����㦥�
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
		
		PROPERTY NumberPos READ GetNumberPOS				// ����� ���ᮢ��� ������
		PROPERTY NamePOS READ GetNamePOS					// �������� �����
		PROPERTY PrintDoctor READ GetPrintDoctor			// ����� ��� � 祪�
		PROPERTY PrintPatient READ GetPrintPatient		// ����� ��樥�� � 祪�
		PROPERTY Change READ GetChange					// ������ ᤠ�
		PROPERTY PrintChange READ GetPrintChange			// ����� ���ᨬ�� �㬬� � ᤠ�
		PROPERTY PrintCodeService READ GetPrintCodeService	// ����� ��� ��㣨
		PROPERTY PrintNameService READ GetPrintNameService	// ����� ������������ ��㣨
		PROPERTY EnableTypePay2 READ GetEnableTypePay2	// ࠧ���� ��� ������ 2
		PROPERTY NameTypePay2 READ GetNameTypePay2		// �������� ���� ������ 2
		PROPERTY EnableTypePay3 READ GetEnableTypePay3	// ࠧ���� ��� ������ 3
		PROPERTY NameTypePay3 READ GetNameTypePay3		// �������� ���� ������ 3
		PROPERTY EnableTypePay4 READ GetEnableTypePay4	// ࠧ���� ��� ������ 4
		PROPERTY NameTypePay4 READ GetNameTypePay4		// �������� ���� ������ 4
		
		METHOD Destroy()
		METHOD Open( oSetting, nPasswordUser )
		METHOD Init							VIRTUAL		// ����㧪� �ࠩ��� ���ன�⢠
		METHOD ShowProperties				VIRTUAL		// �������� ᢮��⢠ �ࠩ��� ���ன�⢠
		METHOD Version							VIRTUAL		// ������ ����� �ࠩ���
		METHOD Beep							VIRTUAL		// �㤮�
		METHOD PrintString( stringForPrinting, lWide, typeControlRibbon, lDelayedPrint )	VIRTUAL
		METHOD OpenDrawer( nDrawerNumber )	VIRTUAL		// ������ ������� �騪
		METHOD CashIncome( summ1 )			VIRTUAL		// ���ᥭ�� �������� �㬬� � �����
		METHOD CashOutcome( summ1 )			VIRTUAL		// �믫�� �������� �㬬� �� �����
		METHOD FeedDocument( flag, numStr )	VIRTUAL		// �த������ ���㬥��
		METHOD FNGetStatus					VIRTUAL		// ������� ���ﭨ� �᪠�쭮�� ������⥫� ���ன�⢠
		METHOD PrintReportWithoutCleaning	VIRTUAL		// ���� ���� ��� ��襭��
		METHOD PrintReportWithCleaning		VIRTUAL		// ���� ���� � ��襭���
		METHOD CancelCheck					VIRTUAL		// �⬥�� 祪�
		METHOD GetInfoExchangeStatus			VIRTUAL		// ������� ����� ���ଠ樮����� ������
		METHOD GetDeviceMetrics				VIRTUAL		// ������� ��ࠬ���� ���ன�⢠
		METHOD GetShortECRStatus				VIRTUAL		// ������� ��⪮� ���ﭨ� ���ன�⢠
		METHOD GetECRStatus( flag )			VIRTUAL		// ������� ������ ���ﭨ� ���ன�⢠
		METHOD SetOperatorKKT( nOp, cName )	VIRTUAL		// ��⠭����� ��� ���짮��⥫� � ���ன�⢥
		METHOD ContinuePrint					VIRTUAL		// �த������ �����
		METHOD SetDate( date )				VIRTUAL		// ��⠭�������� ���� �� ����७��� ��� ���ன�⢠
		METHOD GetDate()						VIRTUAL		// ����砥� ���� �� ����७��� �ᮢ ���ன�⢠
		METHOD SetTime( time )				VIRTUAL		// ��⠭�������� �६� �� ����७��� ��� ���ன�⢠
		METHOD GetTime()						VIRTUAL		// ����砥� �६� �� ����७��� �ᮢ ���ன�⢠
		METHOD CutCheck( flag )				VIRTUAL		// ��१�� 祪���� �����
		METHOD FNOpenSession()				VIRTUAL		// ������ ᬥ�� �� �᪠�쭮� ������⥫�
		METHOD Operation( oOperation )		VIRTUAL		// ������ � 祪�
		METHOD CloseCheck( oCloseCheck )		VIRTUAL		// �����⨥ 祪� ���७���
		METHOD GetCashReg( nRegistr )		VIRTUAL		// ����� ᮤ�ন���� ��������� ॣ����
		METHOD GetOperationReg( nRegistr )	VIRTUAL		// ����� ᮤ�ন���� ����樮����� ॣ����
		METHOD PrintHourlyReport				VIRTUAL		// ���� ���ᮢ�� ����
		METHOD PrintTaxReport				VIRTUAL		// ��⮤ ���⠥� ����� � �த���� �� �������
		METHOD PrintDepartmentReport			VIRTUAL		// ��⮤ ���⠥� ����� � �த���� �� �⤥��� (ᥪ��)
		METHOD PrintCashierReport			VIRTUAL		// ���� ���� �� ����ࠬ
		METHOD BuildCorrectionReceipt( obj )	VIRTUAL		// ��ନ஢��� 祪 ���४樨
		METHOD GetSaleCash					VIRTUAL		// ������� ���������� �� ���� ����� �����묨 ����樨 �த��� �� ᬥ��
		METHOD GetSaleCard					VIRTUAL		// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 �த��� �� ᬥ��
		METHOD GetReturnSaleCash				VIRTUAL		// ���������� �� ���� ����� �����묨 ����樨 ������ �த��� �� ᬥ��
		METHOD GetReturnSaleCard				VIRTUAL		// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ �த��� �� ᬥ��
		METHOD GetCash						VIRTUAL		// ���������� ����筮�� � ����
		METHOD GetIncome						VIRTUAL		// ���ᥭ�� �㬬� �� ᬥ��
		METHOD GetOutcome					VIRTUAL		// �믫�祭�� �㬬� �� ᬥ��
		METHOD PrintCopyReceipt( number )	VIRTUAL		// ����� ����� 祪�
	
	EXPORTED:
		METHOD New()				CONSTRUCTOR
		DATA FDriver		INIT nil						// ���� ��� �࠭���� ��ꥪ� �ࠩ���
	
	PROTECTED:
		DATA FIsFiscalReg	INIT .f.					// ���� ��� �࠭���� ���� ���ன�⢠, ��� .t. - �᪠��� ॣ������, .f. - ���
		DATA FOpenSession	INIT .f.					// ���� ����⮩ ��ᨨ ���ன�⢠
		DATA FDateDevice	INIT ctod( '' )				// ���� ��� ���� ���ன�⢠
		DATA FTimeDevice	INIT 0						// ���� ��� �६��� ���ன�⢠
		DATA FTimeStrDevice	INIT ''						// ���� ��� ��ப����� �।�⠢����� �६��� ���ன�⢠
	
		DATA FDeviceMetrics								// ��ࠬ���� ���ன�⢠
		DATA FShortECRStatus							// ��⪮� ���ﭨ� ���ன�⢠
		DATA FFNStatus									// ����� ���ﭨ� �᪠�쭮�� ������⥫�
		DATA FECRStatus									// ������ ���ﭨ� ���ன�⢠
		DATA FRNM			INIT 'NONE'					// ��� 14 ᨬ�����
		DATA FSerialNumber	INIT 'NONE'					// ������ �����᪮� ����� (�� 9 �� 14 ᨬ�����)
		DATA FDriverLoaded	INIT .f.					// ����㦥� �� �ࠩ��� ���ன�⢠
		DATA FResultCode	INIT 0						// ���� ��� �࠭���� १���⮢ �믮������ ����樨 ���ன�⢠
		DATA FResultCodeDescription	INIT ''				// ���ᠭ�� १���� �믮������
		DATA FPasswordAdmin	INIT 0						// ��஫� ����������� ���ன�⢠
		DATA FPassword		INIT 0						// ��஫� ����� ���ன�⢠
		DATA FOpenADrawer	INIT .f.					// ����⨥ ��������� �騪� ��᫥ ���� 祪�
		DATA FReceiptNumber	INIT 0						// ����� 祪�
		DATA FDocumentNumber	INIT 0					// ����� �᪠�쭮�� ���㬥��
		DATA FOpenDocumentNumber	INIT 0					// ᪢����� ����� ��᫥����� ���㬥�� ���ன�⢠
		DATA FReceiptOpen	INIT .f.					// 祪 �����
		DATA FInfoExchangeStatus	INIT 0				// ����� ���ଠ樮����� ������
		DATA FMessageStatus	INIT 0						// ���ﭨ� �⥭�� ᮮ�饭��
		DATA FMessageCount	INIT 0						// ������⢮ ᮮ�饭�� ��� ���
		DATA FFirstDocumentNumber INIT 0				// ����� ���㬥�� ��� ��� ��ࢮ�� � ��।�
		DATA FDateFirstDocument INIT ctod( '' )			// ��� ���㬥�� ��� ��� ��ࢮ�� � ��।�
		DATA FTimeFirstDocument //AS DateTime				// �६� ���㬥�� ��� ��� ��ࢮ�� � ��।�
		
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
		METHOD GetRegim					VIRTUAL			// ������� ०�� ࠡ��� ���ன�⢠
		&& METHOD GetSerialNumber			VIRTUAL
ENDCLASS

METHOD function getIsFiscalReg()						CLASS TAbstractKKT
	return ::FIsFiscalReg
	
// ࠧ���� ��� ������ 2
METHOD function GetEnableTypePay2						CLASS TAbstractKKT
	return ::FEnableTypePay2
	
// �������� ���� ������ 2
METHOD function GetNameTypePay2						CLASS TAbstractKKT
	return ::FNameTypePay2
	
// ࠧ���� ��� ������ 3
METHOD function GetEnableTypePay3						CLASS TAbstractKKT
	return ::FEnableTypePay3

// �������� ���� ������ 3
METHOD function GetNameTypePay3						CLASS TAbstractKKT
	return ::FNameTypePay3

// ࠧ���� ��� ������ 4
METHOD function GetEnableTypePay4						CLASS TAbstractKKT
	return ::FEnableTypePay4

// �������� ���� ������ 4
METHOD function GetNameTypePay4						CLASS TAbstractKKT
	return ::FNameTypePay4

// ����� ��� ��㣨
METHOD function GetPrintCodeService					CLASS TAbstractKKT
	return ::FPrintCodeService

// ����� ������������ ��㣨
METHOD function GetPrintNameService					CLASS TAbstractKKT
	return ::FPrintNameService

// ����� ���ᨬ�� �㬬� � ᤠ�
METHOD function GetPrintChange							CLASS TAbstractKKT
	return ::FPrintChange

// ������ ᤠ�
METHOD function GetChange								CLASS TAbstractKKT
	return ::FChange

// ����� ��樥�� � 祪�
METHOD function GetPrintPatient						CLASS TAbstractKKT
	return ::FPrintPatient
	
// ����� ��� � 祪�
METHOD function GetPrintDoctor							CLASS TAbstractKKT
	return ::FPrintDoctor

// ������ ������� �騪
&& METHOD function GetOpenDrawer							CLASS TAbstractKKT
	&& return ::FOpenADrawer

// �������� �����
METHOD function GetNamePOS								CLASS TAbstractKKT
	return ::FNamePOS

// ����� ���ᮢ��� ������
METHOD function GetNumberPOS							CLASS TAbstractKKT
	return ::FNumberPos

// ����� ���ଠ樮����� ������
METHOD function GetInfoExchangeStatus					CLASS TAbstractKKT
	return ::FInfoExchangeStatus

// ���ﭨ� �⥭�� ᮮ�饭��
METHOD function GetMessageStatus						CLASS TAbstractKKT
	return ::FMessageStatus

// ������⢮ ᮮ�饭�� ��� ���
METHOD function GetMessageCount						CLASS TAbstractKKT
	return ::FMessageCount

// ����� ���㬥�� ��� ��� ��ࢮ�� � ��।�
METHOD function GetFirstDocumentNumber					CLASS TAbstractKKT
	return ::FFirstDocumentNumber

// ��� ���㬥�� ��� ��� ��ࢮ�� � ��।�
METHOD function GetDateFirstDocument					CLASS TAbstractKKT
	return ::FDateFirstDocument

// �६� ���㬥�� ��� ��� ��ࢮ�� � ��।�
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
