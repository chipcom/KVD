#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatientExt	INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Passport READ getPassport WRITE setPassport			// 㤮�⮢�७�� ��筮�� 䨧��᪮�� ���
		&& PROPERTY Passport WRITE setPassport INIT nil					// 㤮�⮢�७�� ��筮�� 䨧��᪮�� ���
		PROPERTY OKATOG WRITE setOKATOG INIT space( 11 )				// ����� ���� ॣ����樨
		PROPERTY OKATOP WRITE setOKATOP INIT space( 11 )				// ����� ���� �ॡ뢠���
		PROPERTY AddressStay WRITE setAddressStay INIT space( 50 )	// ���� ���� �ॡ뢠���
		PROPERTY IDIssue AS STRING READ getIDIssue WRITE setIDIssue	// ��� �뤠� ���㬥��;"�ࠢ�筨� ""s_kemvyd"""
		PROPERTY PolicyType AS NUMERIC READ getPolicyType WRITE setPolicyType	// ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����;�� 㬮�砭�� 1 - ����
		PROPERTY PolicySeries AS STRING READ getPolicySeries WRITE setPolicySeries	// ��� �����;;��� ���� - ࠧ������ �� �஡���
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber WRITE setPolicyNumber	// ����� �����;;"��� �����த��� - ����� �� ""k_inog"" � ࠧ������"
		PROPERTY SMO AS STRING READ getSMO WRITE setSMO		// ॥��஢� ����� ���;;�८�ࠧ����� �� ����� ����� � ����, ����த��� = 34
		PROPERTY BeginPolicy AS DATE READ getBeginPolicy WRITE setBeginPolicy	// ��� ��砫� ����⢨� �����
		PROPERTY Strana AS STRING READ getStrana WRITE setStrana	// �ࠦ����⢮ ��樥�� (��࠭�);�롮� �� �ࠢ�筨�� ��࠭;"���� ""strana"" �� 䠩�� ""k_inog"" ��� �����த���, ��� ��⠫��� ���� = ��"
		PROPERTY GorodSelo AS NUMERIC READ getGorodSelo WRITE setGorodSelo	// ��⥫�?;1-��த, 2-ᥫ�, 3-ࠡ�稩 ��ᥫ��;"���� ""gorod_selo"" �� 䠩�� ""pp_human"""
		PROPERTY DocumentType AS NUMERIC READ getDocumentType WRITE setDocumentType		// ��� 㤮�⮢�७�� ��筮��;�� ����஢�� �����
		PROPERTY DocumentSeries AS STRING READ getDocumentSeries WRITE setDocumentSeries	// ��� 㤮�⮢�७�� ��筮��
		PROPERTY DocumentNumber AS STRING READ getDocumentNumber WRITE setDocumentNumber	// ����� 㤮�⮢�७�� ��筮��
		PROPERTY DateIssue AS DATE READ getDateIssue WRITE setDateIssue	// ����� �뤠� ���㬥��
		PROPERTY Category AS NUMERIC INDEX 1 READ getCategory WRITE setCategory	// ��⥣��� ��樥��
		PROPERTY Category2 AS NUMERIC INDEX 2 READ getCategory WRITE setCategory  // ��⥣��� ��樥�� (ᮡ�⢥���� ��� ��)
		PROPERTY PlaceBorn AS STRING READ getPlaceBorn WRITE setPlaceBorn	// ���� ஦�����
		PROPERTY DMS_SMO AS NUMERIC READ getDMS_SMO WRITE setDMS_SMO			// ��� ��� ���
		PROPERTY DMSPolicy AS STRING READ getDMSPolicy WRITE setDMSPolicy    // ��� ����� ���
		PROPERTY Kvartal AS STRING INDEX 1 READ getKvartal WRITE setKvartal	// ����⠫ ��� ����᪮��
		PROPERTY KvartalHouse AS STRING INDEX 2 READ getKvartal WRITE setKvartal	// ��� � ����⠫� ����᪮��
		PROPERTY HomePhone AS STRING INDEX 1 READ getPhone WRITE setPhone	// ⥫�䮭 ����譨�
		PROPERTY MobilePhone AS STRING INDEX 2 READ getPhone WRITE setPhone	// ⥫�䮭 �������
		PROPERTY WorkPhone AS STRING INDEX 3 READ getPhone WRITE setPhone	// ⥫�䮭 ࠡ�稩
		PROPERTY CodeLgot AS STRING READ getCodeLgot WRITE setCodeLgot			// ��� �죮�� �� ���
		PROPERTY IsRegistr AS LOGICAL READ getIsRegistr WRITE setIsRegister		// ���� �� � ॣ���� ���;0-���, 1-����;
		PROPERTY IsPensioner AS LOGICAL READ getIsPensioner WRITE setIsPensioner	// ���� ���ᨮ��஬?;0-���, 1-��;
		PROPERTY Invalid AS NUMERIC READ getInvalid WRITE setInvalid		// ������������;0-���,1,2,3-�⥯���, 4-������� ����⢠;
		PROPERTY DegreeOfDisability AS NUMERIC READ getDegreeOfDisability WRITE setDegreeOfDisability	// �⥯��� �����������;1 ��� 2;
		PROPERTY BloodType AS NUMERIC READ getBloodType WRITE setBloodType		// ��㯯� �஢�;�� 1 �� 4
		PROPERTY RhesusFactor AS CHARACTER READ getRhesusFactor WRITE setRhesusFactor		// १��-䠪��;"+" ��� "-"
		PROPERTY Weight AS NUMERIC READ getWeight WRITE setWeight			// ��� � ��
		PROPERTY Height AS NUMERIC READ getHeight WRITE setHeight			// ��� � �
		PROPERTY WhereCard AS NUMERIC READ getWhereCard WRITE setWhereCard		// ��� ���㫠�ୠ� ����;0-� ॣ�������, 1-� ���, 2-�� �㪠�
		PROPERTY GroupRisk AS NUMERIC READ getGroupRisk WRITE setGroupRisk		// ��㯯� �᪠ �� �⠭����� ��৤ࠢ�;;�᫨ ���� REGI_FL.DBF, � ����� �� ����
		PROPERTY DateLastXRay AS DATE INDEX 1 READ getDate WRITE setDate		// ��� ��᫥���� ��ண�䨨;;�᫨ ���� REGI_FL.DBF, � ����� �� ����
		PROPERTY DateLastMunRecipe AS DATE INDEX 2 READ getDate WRITE setDate		// ��� ��᫥����� �㭨樯��쭮�� �楯�
		PROPERTY DateLastFedRecipe AS DATE INDEX 3 READ getDate WRITE setDate		// ��� ��᫥����� 䥤�ࠫ쭮�� �楯�
		
		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )

		METHOD New( nID, lNew, lDeleted )
	EXPORTED:		// �६����
		METHOD getInvalid
		METHOD setInvalid( param )
	HIDDEN:
		DATA FPolicyType INIT 1
		DATA FPolicySeries INIT space( 10 )
		DATA FPolicyNumber INIT space( 20 )
		DATA FSMO INIT space( 5 )
		DATA FBeginPolicy INIT ctod( '' )
		DATA FStrana INIT space( 3 )
		DATA FGorodSelo INIT 0
		DATA FDocumentType INIT 0
		DATA FDocumentSeries INIT space( 10 )
		DATA FDocumentNumber INIT space( 20 )
		DATA FIDIssue	INIT 0
		DATA FDateIssue INIT ctod( '' )
		DATA FCategory	INIT 0
		DATA FCategory2	INIT 0
		DATA FPlaceBorn INIT space( 100 )
		DATA FDMS_SMO INIT 0
		DATA FDMSPolicy INIT space( 17 )
		DATA FKvartal INIT space( 5 )
		DATA FKvartalHouse INIT space( 5 )
		DATA FHomePhone INIT space( 11 )
		DATA FMobilePhone INIT space( 11 )
		DATA FWorkPhone INIT space( 11 )
		DATA FCodeLgot INIT space( 3 )
		DATA FIsRegistr INIT .f.
		DATA FIsPensioner INIT .f.
		DATA FInvalid INIT 0
		DATA FDegreeOfDisability INIT 0
		DATA FBloodType INIT 0
		DATA FRhesusFactor INIT ' '
		DATA FWeight INIT 0
		DATA FHeight INIT 0
		DATA FWhereCard INIT 0
		DATA FGroupRisk INIT 0
		DATA FDateLastXRay INIT ctod( '' )
		DATA FDateLastMunRecipe INIT ctod( '' )
		DATA FDateLastFedRecipe INIT ctod( '' )
		
		METHOD getPassport
		METHOD setPassport( obj )
		METHOD setOKATOG( cText )
		METHOD setOKATOP( cText )
		METHOD setAddressStay( cText )
		METHOD getIDIssue
		METHOD setIDIssue( param )
		METHOD getPolicyType
		METHOD setPolicyType( param )
		METHOD getPolicySeries
		METHOD setPolicySeries( param )
		METHOD getPolicyNumber
		METHOD setPolicyNumber( param )
		METHOD getSMO
		METHOD setSMO( param )
		METHOD getBeginPolicy
		METHOD setBeginPolicy( param )
		METHOD getStrana
		METHOD setStrana( param )
		METHOD getGorodSelo
		METHOD setGorodSelo( param )
		METHOD getDocumentType
		METHOD setDocumentType( param )
		METHOD getDocumentSeries
		METHOD setDocumentSeries( param )
		METHOD getDocumentNumber
		METHOD setDocumentNumber( param )
		METHOD getDateIssue
		METHOD setDateIssue( param )
		METHOD getCategory( nIndex )
		METHOD setCategory( nIndex, param )
		METHOD getPlaceBorn
		METHOD setPlaceBorn( param )
		METHOD getDMS_SMO
		METHOD setDMS_SMO( param )
		METHOD getDMSPolicy
		METHOD setDMSPolicy( param )
		METHOD getKvartal( nIndex )
		METHOD setKvartal( nIndex, param )
		METHOD getPhone( nIndex )
		METHOD setPhone( nIndex, param )
		METHOD getCodeLgot
		METHOD setCodeLgot( param )
		METHOD getIsRegistr
		METHOD setIsRegister( param )
		METHOD getIsPensioner
		METHOD setIsPensioner( param )
		&& METHOD getInvalid
		&& METHOD setInvalid( param )
		METHOD getDegreeOfDisability
		METHOD setDegreeOfDisability( param )
		METHOD getBloodType
		METHOD setBloodType( param )
		METHOD getRhesusFactor
		METHOD setRhesusFactor( param )
		METHOD getWeight
		METHOD setWeight( param )
		METHOD getHeight
		METHOD setHeight( param )
		METHOD getWhereCard
		METHOD setWhereCard( param )
		METHOD getGroupRisk
		METHOD setGroupRisk( param )
		METHOD getDate( nIndex )
		METHOD setDate( nIndex, param )
ENDCLASS

// ��� �����饭�� ����ᮬ TPatient
METHOD procedure setID( param )					CLASS TPatientExt

	if isnumber( param )
		::FID := param
	endif
	return

METHOD function getDate( nIndex )						CLASS TPatientExt
	local ret
	switch nIndex
		case 1
			ret := ::FDateLastXRay
			exit
		case 2
			ret := ::FDateLastMunRecipe
			exit
		case 3
			ret := ::FDateLastFedRecipe
			exit
	endswitch
	return ret

METHOD procedure setDate( nIndex, param )				CLASS TPatientExt

	if isdate( param )
		switch nIndex
			case 1
				::FDateLastXRay := param
				exit
			case 2
				::FDateLastMunRecipe := param
				exit
			case 3
				::FDateLastFedRecipe := param
				exit
		endswitch
	endif
	return

METHOD function getGroupRisk() CLASS TPatientExt
	return ::FGroupRisk
	
METHOD procedure setGroupRisk( param ) CLASS TPatientExt

	if isnumber( param )
		::FGroupRisk := param
	endif
	return

METHOD function getWhereCard() CLASS TPatientExt
	return ::FWhereCard
	
METHOD procedure setWhereCard( param ) CLASS TPatientExt

	if isnumber( param )
		::FWhereCard := param
	endif
	return

METHOD function getHeight() CLASS TPatientExt
	return ::FHeight
	
METHOD procedure setHeight( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0
		::FHeight := param
	endif
	return

METHOD function getWeight() CLASS TPatientExt
	return ::FWeight
	
METHOD procedure setWeight( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0
		::FWeight := param
	endif
	return

METHOD function getRhesusFactor() CLASS TPatientExt
	return ::FRhesusFactor
	
METHOD procedure setRhesusFactor( param ) CLASS TPatientExt

	if ischaracter( param ) .and. param $ '+-'
		::FRhesusFactor := param
	endif
	return

METHOD function getBloodType() CLASS TPatientExt
	return ::FBloodType
	
METHOD procedure setBloodType( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0 .and. param < 5
		::FBloodType := param
	endif
	return

METHOD function getDegreeOfDisability() CLASS TPatientExt
	return ::FDegreeOfDisability
	
METHOD procedure setDegreeOfDisability( param ) CLASS TPatientExt

	if isnumber( param )
		::FDegreeOfDisability := param
	endif
	return

METHOD function getInvalid() CLASS TPatientExt
	return ::FInvalid
	
METHOD procedure setInvalid( param ) CLASS TPatientExt

	if isnumber( param )
		::FInvalid := param
	endif
	return

METHOD function getIsPensioner() CLASS TPatientExt
	return ::FIsPensioner
	
METHOD procedure setIsPensioner( param ) CLASS TPatientExt

	if islogical( param )
		::FIsPensioner := param
	endif
	return

METHOD function getIsRegistr() CLASS TPatientExt
	return ::FIsRegistr
	
METHOD procedure setIsRegister( param ) CLASS TPatientExt

	if islogical( param )
		::FIsRegistr := param
	endif
	return

METHOD function getCodeLgot() CLASS TPatientExt
	return ::FCodeLgot
	
METHOD procedure setCodeLgot( param ) CLASS TPatientExt

	if ischaracter( param )
		::FCodeLgot := param
	endif
	return

METHOD function getPhone( nIndex )						CLASS TPatientExt
	local ret
	switch nIndex
		case 1
			ret := ::FHomePhone
			exit
		case 2
			ret := ::FMobilePhone
			exit
		case 3
			ret := ::FWorkPhone
			exit
	endswitch
	return ret

METHOD procedure setPhone( nIndex, param )				CLASS TPatientExt

	if ischaracter( param )
		switch nIndex
			case 1
				::FHomePhone := param
				exit
			case 2
				::FMobilePhone := param
				exit
			case 3
				::FWorkPhone := param
				exit
		endswitch
	endif
	return

METHOD function getKvartal( nIndex )						CLASS TPatientExt
	local ret
	switch nIndex
		case 1
			ret := ::FKvartal
			exit
		case 2
			ret := ::FKvartalHouse
			exit
	endswitch
	return ret

METHOD procedure setKvartal( nIndex, param )				CLASS TPatientExt
	if ischaracter( param )
		switch nIndex
			case 1
				::FKvartal := param
				exit
			case 2
				::FKvartalHouse := param
				exit
		endswitch
	endif
	return

METHOD function getDMSPolicy() CLASS TPatientExt
	return ::FDMSPolicy
	
METHOD procedure setDMSPolicy( param ) CLASS TPatientExt

	if ischaracter( param )
		::FDMSPolicy := param
	endif
	return

METHOD function getDMS_SMO() CLASS TPatientExt
	return ::FDMS_SMO
	
METHOD procedure setDMS_SMO( param ) CLASS TPatientExt

	if isnumber( param )
		::FDMS_SMO := param
	endif
	return

METHOD function getPlaceBorn() CLASS TPatientExt
	return ::FPlaceBorn
	
METHOD procedure setPlaceBorn( param ) CLASS TPatientExt

	if ischaracter( param )
		::FPlaceBorn := param
	endif
	return

METHOD function getCategory( nIndex )						CLASS TPatientExt
	local ret
	switch nIndex
		case 1
			ret := ::FCategory
			exit
		case 2
			ret := ::FCategory2
			exit
	endswitch
	return ret

METHOD procedure setCategory( nIndex, param )				CLASS TPatientExt
	switch nIndex
		case 1
			::FCategory := param
			exit
		case 2
			::FCategory2 := param
			exit
	endswitch
	return

METHOD function getDateIssue() CLASS TPatientExt
	return ::FDateIssue
	
METHOD procedure setDateIssue( param ) CLASS TPatientExt

	if isdate( param )
		::FDateIssue := param
	endif
	return

METHOD function getDocumentNumber() CLASS TPatientExt
	return ::FDocumentNumber
	
METHOD procedure setDocumentNumber( param ) CLASS TPatientExt

	if ischaracter( param )
		::FDocumentNumber := param
	endif
	return

METHOD function getDocumentSeries() CLASS TPatientExt
	return ::FDocumentSeries
	
METHOD procedure setDocumentSeries( param ) CLASS TPatientExt

	if ischaracter( param )
		::FDocumentSeries := param
	endif
	return

METHOD function getDocumentType() CLASS TPatientExt
	return ::FDocumentType
	
METHOD procedure setDocumentType( param ) CLASS TPatientExt

	if isnumber( param )
		::FDocumentType := param
	endif
	return

METHOD function getGorodSelo() CLASS TPatientExt
	return ::FGorodSelo
	
METHOD procedure setGorodSelo( param ) CLASS TPatientExt

	if isnumber( param )
		::FGorodSelo := param
	endif
	return

METHOD function getBeginPolicy() CLASS TPatientExt
	return ::FBeginPolicy
	
METHOD procedure setBeginPolicy( param ) CLASS TPatientExt

	if isdate( param )
		::FBeginPolicy := param
	endif
	return

METHOD function getStrana() CLASS TPatientExt
	return ::FStrana
	
METHOD procedure setStrana( param ) CLASS TPatientExt

	if ischaracter( param )
		::FStrana := param
	endif
	return

METHOD function getSMO() CLASS TPatientExt
	return ::FSMO
	
METHOD procedure setSMO( param ) CLASS TPatientExt

	if ischaracter( param )
		::FSMO := param
	endif
	return

METHOD function getPolicyNumber() CLASS TPatientExt
	return ::FPolicyNumber
	
METHOD procedure setPolicyNumber( param ) CLASS TPatientExt

	if ischaracter( param )
		::FPolicyNumber := param
	endif
	return

METHOD function getPolicySeries() CLASS TPatientExt
	return ::FPolicySeries
	
METHOD procedure setPolicySeries( param ) CLASS TPatientExt

	if ischaracter( param )
		::FPolicySeries := param
	endif
	return

METHOD function getPolicyType() CLASS TPatientExt
	return ::FPolicyType
	
METHOD procedure setPolicyType( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0 .and. param < 4
		::FPolicyType := param
	endif
	return

METHOD function getIDIssue() CLASS TPatientExt
	return ::FIDIssue
	
METHOD procedure setIDIssue( param ) CLASS TPatientExt

	if isnumber( param ) .and. param != 0
		::FIDIssue := param
	elseif isobject( param ) .and. param:ClassName == upper( 'TPublisher' )
		::FIDIssue := param:ID
	endif
	return

METHOD function getPassport ()	CLASS TPatientExt
	if ::FDocumentType == 0
		return TPassport():New()
	endif
	return TPassport():New( ::FDocumentType, ::FDocumentSeries, ::FDocumentNumber, ;
								::FIDIssue, ::FDateIssue )

METHOD PROCEDURE setPassport ( obj )	CLASS TPatientExt

	if isobject( obj ) .and. param:ClassName == upper( 'TPassport' )
		::FDocumentType := obj:DocumentType
		::FDocumentSeries := obj:DocumentSeries
		::FDocumentNumber := obj:DocumentNumber
		::FIDIssue := obj:IDIssue
		::FDateIssue := obj:DateIssue
	endif
	return

METHOD PROCEDURE setOKATOG ( cText )	CLASS TPatientExt
	::FOKATOG := cText
	return

METHOD PROCEDURE setOKATOP ( cText )	CLASS TPatientExt
	::FOKATOP := cText
	return

METHOD PROCEDURE setAddressStay ( cText )	CLASS TPatientExt
	::FAddressStay := cText
	return

METHOD New( nID, lNew, lDeleted )		CLASS TPatientExt

	::super:new( nID, lNew, lDeleted )
	return self