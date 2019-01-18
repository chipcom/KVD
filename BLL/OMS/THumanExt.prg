#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS THumanExt	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Dispans AS STRING READ getDispans WRITE setDispans	// �, �� �������� �� <F10>
		PROPERTY StatusST AS STRING READ getStatusST WRITE setStatusST	// ����� �⮬�⮫����᪮�� ��樥��;�஢�ઠ �� ᮡ�⢥����� �ࠢ�筨�� �� ��� �⮬�⮫����
		PROPERTY Povod AS NUMERIC READ getPovod WRITE setPovod		// ����� ���饭��
		PROPERTY Travma AS NUMERIC READ getTravma WRITE setTravma	// ��� �ࠢ��
		PROPERTY GUIDPatient AS STRING READ getGUIDPatient WRITE setGUIDPatient	// ��� ����� � ��樥��;GUID ��樥�� � ���� ���;ᮧ������ �� ���������� �����
		PROPERTY GUIDCase AS STRING READ getGUIDCase WRITE setGUIDCase	// ��� ���� ��������;GUID ���� ���;ᮧ������ �� ���������� �����
		PROPERTY Neonate AS NUMERIC READ getNeonate WRITE setNeonate	// �ਧ��� ����஦������� 0-���, 1,2,... - ���浪��� ����� ����஦������� ॡ����
		PROPERTY NeonateDOB AS DATE READ getDOBNeonate WRITE setDOBNeonate	// ��� ஦����� ॡ���� ��� NOVOR > 0;
		PROPERTY NeonateGender AS CHARACTER READ getGenderNeonate WRITE setGenderNeonate		// ��� ॡ���� ��� NOVOR > 0
		PROPERTY Usl_Ok AS NUMERIC READ getUsl_Ok WRITE setUsl_Ok	// �᫮��� �������� ����樭᪮� ����� �� �ࠢ�筨�� V006
		PROPERTY VidPom AS NUMERIC READ getVidPom WRITE setVidPom	// ��� ����� �� �ࠢ�筨�� V008
		PROPERTY Profil AS NUMERIC READ getProfil WRITE setProfil	// ��䨫� �� �ࠢ�筨�� V002
		PROPERTY IDSP AS NUMERIC READ getIDSP WRITE setIDSP	// ��� ᯮᮡ� ������ ���.����� �� �ࠢ�筨�� V010
		PROPERTY ReferralMO AS STRING READ getReferralMO WRITE setReferralMO	// ��� ��, ���ࠢ��襣� �� ��祭�� �� �ࠢ�筨�� T001
		PROPERTY Forma14 AS STRING READ getForma14 WRITE setForma14	// ��� ���.��� 14 � ����� 4 �����: �������/���७��, ���⠢��� ᪮ன �������, �஢����� ����⨥, ��⠭������ ��宦�����
		PROPERTY Diagnosis AS STRING READ getDiagnosis WRITE setDiagnosis	// ������� ��ࢨ��
		PROPERTY Result AS NUMERIC READ getResult WRITE setResult	// १���� ���饭��/��ᯨ⠫���樨 �� �ࠢ�筨�� V009
		PROPERTY Ishod AS NUMERIC READ getIshod WRITE setIshod	// ��室 ����������� �� �ࠢ�筨�� V012
		PROPERTY Doctor AS NUMERIC READ getDoctor WRITE setDoctor	// ���騩 ��� (���, �����訩 ⠫��)
		PROPERTY PRVS AS NUMERIC READ getPRVS WRITE setPRVS	// ���樠�쭮��� ��� �� �ࠢ�筨�� V004, � ����ᮬ - �� �ࠢ�筨�� V015
		PROPERTY ParentDOB AS DATE READ getParentDOB WRITE setParentDOB	// ��� ஦����� த�⥫� (��� human->bolnich=2)
		PROPERTY ParentGender AS CHARACTER READ getParentGender WRITE setParentGender	// ��� த�⥫� (��� human->bolnich=2)
		PROPERTY DateEditCase AS DATE READ getDateEditCase WRITE setDateEditCase		// ��� ।���஢���� ���� ���
		PROPERTY UserID AS NUMERIC READ getUserID WRITE setUserID		// ��� ���짮��⥫�, ��ࠢ��襣� �/�
		PROPERTY TypePlanOrder AS NUMERIC READ getTypePlanOrder WRITE setTypePlanOrder		// ⨯ ����-������ �� 1 �� 99
		PROPERTY CompletedPlanOrder AS NUMERIC READ getCompletedPlanOrder WRITE setCompletedPlanOrder	// ���-�� �믮�������� ����-������
		PROPERTY VerificationStage AS NUMERIC READ getVerificationStage WRITE setVerificationStage	// �⠤�� �஢�ન: 0-��᫥ ।���஢����; �� 5 �� 9-�஢�७�
		PROPERTY PreviousRecordNumber AS NUMERIC READ getPreviousRecordNumber WRITE setPreviousRecordNumber	// ����� �।��饩 ����� (� ��砥 ����୮�� ���⠢����� � ��㣮� ����)
		PROPERTY PaymentType AS NUMERIC READ getPaymentType WRITE setPaymentType		// ⨯ ������;0,1 ��� 2, 1 - � ���, 2 - ।-��; 9-���� �� ����祭 � ᤥ���� ����� �/�
		PROPERTY PaymentTotal AS NUMERIC READ getPaymentTotal WRITE setPaymentTotal		// �㬬�, �ਭ��� � ����� ��� (�����);�ᥣ�;
		PROPERTY FinancialSanctionsMEK AS NUMERIC INDEX 1 READ getFinancialSanctions WRITE setFinancialSanctions	// 䨭��ᮢ� ᠭ�樨 (���);�㬬���;
		PROPERTY FinancialSanctionsMEE AS NUMERIC INDEX 2 READ getFinancialSanctions WRITE setFinancialSanctions	// 䨭��ᮢ� ᠭ�樨 (���);�㬬���;
		PROPERTY FinancialSanctionsEKMP AS NUMERIC INDEX 3 READ getFinancialSanctions WRITE setFinancialSanctions	// 䨭��ᮢ� ᠭ�樨 (����);�㬬���;
		PROPERTY Reestr AS NUMERIC INDEX 1 READ getReestr WRITE setReestr	// ��� (��᫥�����) ॥���;�� 䠩�� "mo_rees"
		PROPERTY ReestrNumber AS NUMERIC INDEX 2 READ getReestr WRITE setReestr	// ����� ��ࠢ�� ॥��� � ������;� ॥��� ���� ࠧ ��ࠢ��� = 1, ��᫥ ��ࠢ����� ��ࠢ��� ��ன ࠧ = 2, � �.�.;
		PROPERTY ReestrPosition AS NUMERIC INDEX 3 READ getReestr WRITE setReestr	// ����� ����樨 ����� � ॥���;���� "IDCASE" (� "ZAP") � ॥��� ��砥�
		PROPERTY InvoiceSendingNumber AS NUMERIC INDEX 1 READ getInvoice WRITE setInvoice	// ����� ��ࠢ�� ���� � �����;� ���� ���� ࠧ ��ࠢ��� = 0, ��᫥ �⪠�� � ����� � ��ࠢ����� ��ࠢ��� ��ன ࠧ = 1, � �.�.;
		PROPERTY InvoiceSendingPosition AS NUMERIC INDEX 2 READ getInvoice WRITE setInvoice	// ����� ����樨 ����� � ���;���� "IDCASE" (� "ZAP") � ॥��� ��⮢;��ନ஢��� �� ������� humans ��� schet > 0

		PROPERTY PolicyType AS NUMERIC READ getPolicyType WRITE setPolicyType	// ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����;�� 㬮�砭�� 1 - ����
		PROPERTY PolicySeries AS STRING READ getPolicySeries WRITE setPolicySeries	// ��� �����;;��� ���� - ࠧ������ �� �஡���
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber WRITE setPolicyNumber	// ����� �����;;"��� �����த��� - ����� �� ""k_inog"" � ࠧ������"
		PROPERTY SMO AS STRING READ getSMO WRITE setSMO		// ॥��஢� ����� ���;;�८�ࠧ����� �� ����� ����� � ����, ����த��� = 34
		PROPERTY OKATO AS STRING READ getOKATO WRITE setOKATO	// ����� ����ਨ ���客���� �����頥��� � ॥��஬ �� ����� ��� �����த���

		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )
		
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FDispans	INIT space( 16 )
		DATA FStatusST	INIT space( 10 )
		DATA FPovod INIT 0
		DATA FTravma INIT 0
		DATA FGUIDPatient INIT space( 36 )
		DATA FGUIDCase INIT space( 36 )
		DATA FNeonate INIT 0
		DATA FDOBNeonate INIT ctod( '' )
		DATA FGenderNeonate INIT '�'
		DATA FUsl_Ok INIT 0
		DATA FVidPom INIT 0
		DATA FProfil INIT 0
		DATA FIDSP INIT 0
		DATA FReferralMO	INIT space( 6 )
		DATA FForma14	INIT space( 6 )
		DATA FDiagnosis	INIT space( 6 )
		DATA FResult INIT 0
		DATA FIshod INIT 0
		DATA FDoctor INIT 0
		DATA FPRVS INIT 0
		DATA FParentDOB INIT ctod( '' )
		DATA FParentGender INIT '�'
		DATA FDateEditCase INIT ctod( '' )
		DATA FUserID INIT 0
		DATA FTypePlanOrder INIT 0
		DATA FCompletedPlanOrder INIT 0
		DATA FVerificationStage INIT 0
		DATA FPreviousRecordNumber INIT 0
		DATA FPaymentType INIT 0
		DATA FPaymentTotal INIT 0
		DATA FFinancialSanctionsMEK INIT 0
		DATA FFinancialSanctionsMEE  INIT 0 
		DATA FFinancialSanctionsEKMP  INIT 0
		DATA FReestr INIT 0
		DATA FReestrNumber INIT 0
		DATA FReestrPosition INIT 0
		DATA FInvoiceSendingNumber INIT 0
		DATA FInvoiceSendingPosition INIT 0
		
		DATA FPolicyType INIT 1
		DATA FPolicySeries INIT space( 10 )
		DATA FPolicyNumber INIT space( 20 )
		DATA FSMO INIT space( 5 )
		DATA FOKATO	INIT space( 5 )

		METHOD getPolicyType					INLINE ::FPolicyType
		METHOD setPolicyType( param )
		METHOD getPolicySeries				INLINE ::FPolicySeries
		METHOD setPolicySeries( param )
		METHOD getPolicyNumber				INLINE ::FPolicyNumber
		METHOD setPolicyNumber( param )
		METHOD getSMO						INLINE ::FSMO
		METHOD setSMO( param )
		METHOD getOKATO						INLINE ::FOKATO
		METHOD setOKATO( param )

		METHOD getInvoice( index )
		METHOD setInvoice( index, param )
		METHOD getReestr( index )
		METHOD setReestr( index, param )
		METHOD getFinancialSanctions( index )
		METHOD setFinancialSanctions( index, param )
		METHOD getPaymentTotal				INLINE ::FPaymentTotal
		METHOD setPaymentTotal( param )
		METHOD getPaymentType				INLINE ::FPaymentType
		METHOD setPaymentType( param )
		METHOD getPreviousRecordNumber		INLINE ::FPreviousRecordNumber
		METHOD setPreviousRecordNumber( param )
		METHOD getVerificationStage			INLINE ::FVerificationStage
		METHOD setVerificationStage( param )
		METHOD getCompletedPlanOrder			INLINE ::FCompletedPlanOrder
		METHOD setCompletedPlanOrder( param )
		METHOD getTypePlanOrder				INLINE ::FTypePlanOrder
		METHOD setTypePlanOrder( param )
		METHOD getUserID						INLINE ::FUserID
		METHOD setUserID( param )
		METHOD getDateEditCase				INLINE ::FDateEditCase
		METHOD setDateEditCase( param )
		METHOD getParentGender				INLINE ::FParentGender
		METHOD setParentGender( param )
		METHOD getParentDOB					INLINE ::FParentDOB
		METHOD setParentDOB( param )
		METHOD getPRVS						INLINE ::FPRVS
		METHOD setPRVS( param )
		METHOD getDoctor						INLINE ::FDoctor
		METHOD setDoctor( param )
		METHOD getIshod						INLINE ::FIshod
		METHOD setIshod( param )
		METHOD getResult						INLINE ::FResult
		METHOD setResult( param )
		METHOD getDiagnosis					INLINE ::FDiagnosis
		METHOD setDiagnosis( param )
		METHOD getForma14					INLINE ::FForma14
		METHOD setForma14( param )
		METHOD getReferralMO					INLINE ::FReferralMO
		METHOD setReferralMO( param )
		METHOD getIDSP						INLINE ::FIDSP
		METHOD setIDSP( param )
		METHOD getProfil						INLINE ::FProfil
		METHOD setProfil( param )
		METHOD getVidPom						INLINE ::FVidPom
		METHOD setVidPom( param )
		METHOD getUsl_Ok						INLINE ::FUsl_Ok
		METHOD setUsl_Ok( param )
		METHOD getGenderNeonate				INLINE ::FGenderNeonate
		METHOD setGenderNeonate( param )
		METHOD getDOBNeonate					INLINE ::FDOBNeonate
		METHOD setDOBNeonate( param )
		METHOD getNeonate					INLINE ::FNeonate
		METHOD setNeonate( param )
		METHOD getGUIDCase					INLINE ::FGUIDCase
		METHOD setGUIDCase( param )
		METHOD getGUIDPatient				INLINE ::FGUIDPatient
		METHOD setGUIDPatient( param )
		METHOD getTravma						INLINE ::FTravma
		METHOD setTravma( param )
		METHOD getPovod						INLINE ::FPovod
		METHOD setPovod( param )
		METHOD getStatusST					INLINE ::FStatusST
		METHOD setStatusST( param )
		METHOD getDispans					INLINE ::FDispans
		METHOD setDispans( param )
ENDCLASS

// ��� �����饭�� ����ᮬ THuman
METHOD procedure setID( param ) CLASS THumanExt

	if isnumber( param )
		::FID := param
	endif
	return

METHOD procedure setOKATO( param )		CLASS THumanExt

	if ischaracter( param )
		::FOKATO := param
	endif
	return

METHOD procedure setSMO( param ) CLASS THumanExt

	if ischaracter( param )
		::FSMO := param
	endif
	return

METHOD procedure setPolicyNumber( param ) CLASS THumanExt

	if ischaracter( param )
		::FPolicyNumber := param
	endif
	return

METHOD procedure setPolicySeries( param ) CLASS THumanExt

	if ischaracter( param )
		::FPolicySeries := param
	endif
	return

METHOD procedure setPolicyType( param ) CLASS THumanExt

	if isnumber( param ) .and. param > 0 .and. param < 4
		::FPolicyType := param
	endif
	return

METHOD function getInvoice( index )	CLASS THumanExt
	local ret
	
	switch index
		case 1
			ret := ::FInvoiceSendingNumber
			exit
		case 2
			ret := ::FInvoiceSendingPosition
			exit
	endswitch
	return ret

METHOD procedure setInvoice( index, param )		CLASS THumanExt

	if isnumber( param )
		switch index
			case 1
				::FInvoiceSendingNumber := param
				exit
			case 2
				::FInvoiceSendingPosition := param
				exit
		endswitch
	endif
	return

METHOD function getReestr( index )	CLASS THumanExt
	local ret
	
	switch index
		case 1
			ret := ::FReestr
			exit
		case 2
			ret := ::FReestrNumber
			exit
		case 3
			ret := ::FReestrPosition
			exit
	endswitch
	return ret

METHOD procedure setReestr( index, param )		CLASS THumanExt

	if isnumber( param )
		switch index
			case 1
				::FReestr := param
				exit
			case 2
				::FReestrNumber := param
				exit
			case 3
				::FReestrPosition := param
				exit
		endswitch
	endif
	return

METHOD function getFinancialSanctions( index )	CLASS THumanExt
	local ret
	
	switch index
		case 1
			ret := ::FFinancialSanctionsMEK
			exit
		case 2
			ret := ::FFinancialSanctionsMEE
			exit
		case 3
			ret := ::FFinancialSanctionsEKMP
			exit
	endswitch
	return ret

METHOD procedure setFinancialSanctions( index, param )		CLASS THumanExt

	if isnumber( param )
		switch index
			case 1
				::FFinancialSanctionsMEK := param
				exit
			case 2
				::FFinancialSanctionsMEE := param
				exit
			case 3
				::FFinancialSanctionsEKMP := param
				exit
		endswitch
	endif
	return

METHOD procedure setPaymentTotal( param )		CLASS THumanExt

	if isnumber( param )
		::FPaymentTotal := param
	endif
	return

METHOD procedure setPaymentType( param )		CLASS THumanExt

	if isnumber( param )
		::FPaymentType := param
	endif
	return

METHOD procedure setPreviousRecordNumber( param )		CLASS THumanExt

	if isnumber( param )
		::FPreviousRecordNumber := param
	endif
	return

METHOD procedure setVerificationStage( param )		CLASS THumanExt

	if isnumber( param )
		::FVerificationStage := param
	endif
	return

METHOD procedure setCompletedPlanOrder( param )		CLASS THumanExt

	if isnumber( param )
		::FCompletedPlanOrder := param
	endif
	return

METHOD procedure setTypePlanOrder( param )		CLASS THumanExt

	if isnumber( param )
		::FTypePlanOrder := param
	endif
	return

METHOD procedure setUserID( param )		CLASS THumanExt

	if isnumber( param )
		::FUserID := param
	elseif ischaracter( param )
		::FUserID := asc( left( param, 1 ) )
	endif
	return

METHOD procedure setDateEditCase( param )		CLASS THumanExt

	if isdate( param )
		::FDateEditCase := param
	endif
	return

METHOD procedure setParentGender( param )		CLASS THumanExt
	local ch

	if ischaracter( param )
		ch := upper( left( param, 1 ) )
		::FParentGenderGender := ch
	endif
	return

METHOD procedure setParentDOB( param )		CLASS THumanExt

	if isdate( param )
		::FParentDOB := param
	endif
	return

METHOD procedure setPRVS( param )		CLASS THumanExt

	if isnumber( param )
		::FPRVS := param
	endif
	return

METHOD procedure setDoctor( param )		CLASS THumanExt

	if isnumber( param )
		::FDoctor := param
	endif
	return

METHOD procedure setIshod( param )		CLASS THumanExt

	if isnumber( param )
		::FIshod := param
	endif
	return

METHOD procedure setResult( param )		CLASS THumanExt

	if isnumber( param )
		::FResult := param
	endif
	return

METHOD procedure setDiagnosis( param )		CLASS THumanExt

	if ischaracter( param )
		::FDiagnosis := param
	endif
	return

METHOD procedure setForma14( param )		CLASS THumanExt

	if ischaracter( param )
		::FForma14 := param
	endif
	return

METHOD procedure setReferralMO( param )		CLASS THumanExt

	if ischaracter( param )
		::FReferralMO := param
	endif
	return

METHOD procedure setIDSP( param )		CLASS THumanExt

	if isnumber( param )
		::FIDSP := param
	endif
	return

METHOD procedure setProfil( param )		CLASS THumanExt

	if isnumber( param )
		::FProfil := param
	endif
	return

METHOD procedure setVidPom( param )		CLASS THumanExt

	if isnumber( param )
		::FVidPom := param
	endif
	return

METHOD procedure setUsl_Ok( param )		CLASS THumanExt

	if isnumber( param )
		::FUsl_Ok := param
	endif
	return

METHOD procedure setGenderNeonate( param )		CLASS THumanExt
	local ch

	if ischaracter( param )
		ch := upper( left( param, 1 ) )
		::FGenderNeonate := ch
	endif
	return

METHOD procedure setDOBNeonate( param )		CLASS THumanExt

	if isdate( param )
		::FDOBNeonate := param
	endif
	return

METHOD procedure setNeonate( param )		CLASS THumanExt

	if isnumber( param )
		::FNeonate := param
	endif
	return

METHOD procedure setGUIDCase( param )		CLASS THumanExt

	if ischaracter( param )
		::FGUIDCase := param
	endif
	return

METHOD procedure setGUIDPatient( param )		CLASS THumanExt

	if ischaracter( param )
		::FGUIDPatient := param
	endif
	return

METHOD procedure setTravma( param )		CLASS THumanExt

	if isnumber( param )
		::FTravma := param
	endif
	return

METHOD procedure setPovod( param )		CLASS THumanExt

	if isnumber( param )
		::FPovod := param
	endif
	return

METHOD procedure setStatusST( param )		CLASS THumanExt

	if ischaracter( param )
		::FStatusST := param
	endif
	return

METHOD procedure setDispans( param )		CLASS THumanExt

	if ischaracter( param )
		::FDispans := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS THumanExt

	::super:new( nID, lNew, lDeleted )
	return self