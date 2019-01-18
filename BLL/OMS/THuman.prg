#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS THuman	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code AS NUMERIC READ getCode WRITE setCode												// ��� (����� �����)
		PROPERTY IDCardFile AS NUMERIC READ getIDCardFile WRITE setIDCardFile							// ��� �� ����⥪�
		PROPERTY TreatmentCode AS NUMERIC READ getTreatmentCode WRITE setTreatmentCode					// 1-������,2-��祭�� �� �����襭�,3-��祭�� �� �����襭�,4-�믨ᠭ ���,5-����祭 ���������,6-���쭮� �� ����稢�����
		PROPERTY FIO AS STRING READ getFIO WRITE setFIO													// �.�.�. ���쭮��
		PROPERTY FIO1251 READ getFIO1251
		PROPERTY Gender AS CHARACTER READ getGender WRITE setGender										// ���
		PROPERTY DOB AS DATE READ getDOB WRITE setDOB														// ��� ஦�����
		PROPERTY Vzros_Reb AS NUMERIC READ getVzros_Reb WRITE setVzros_Reb								// 0-�����, 1-ॡ����, 2-�����⮪
		PROPERTY Address AS STRING READ getAddress WRITE setAddress										// ���� ॣ����樨
		PROPERTY PlaceWork AS STRING READ getPlaceWork WRITE setPlaceWork								// ���� ࠡ��� ��� ��稭� ���ࠡ�⭮��
		PROPERTY Working AS NUMERIC READ getWorking WRITE setWorking										// 0-ࠡ���騩, 1-��ࠡ���騩
		
		PROPERTY MainDiagnosis AS STRING INDEX 1 READ getMainDiagnosis WRITE setMainDiagnosis	// ��� 1-�� ��.�������
		PROPERTY MainDiagnosis2 AS STRING INDEX 2 READ getMainDiagnosis WRITE setMainDiagnosis	// ��� 2-�� ��.�������
		PROPERTY MainDiagnosis3 AS STRING INDEX 3 READ getMainDiagnosis WRITE setMainDiagnosis	// ��� 3-�� ��.�������
		PROPERTY MainDiagnosis4 AS STRING INDEX 4 READ getMainDiagnosis WRITE setMainDiagnosis	// ��� 4-�� ��.�������
		PROPERTY Diagnosis1 AS STRING INDEX 1 READ getDiagnosis WRITE setDiagnosis				// ��� 1-�� ᮯ������饩 �������
		PROPERTY Diagnosis2 AS STRING INDEX 2 READ getDiagnosis WRITE setDiagnosis				// ��� 2-�� ᮯ������饩 �������
		PROPERTY Diagnosis3 AS STRING INDEX 3 READ getDiagnosis WRITE setDiagnosis				// ��� 3-�� ᮯ������饩 �������
		PROPERTY Diagnosis4 AS STRING INDEX 4 READ getDiagnosis WRITE setDiagnosis				// ��� 4-�� ᮯ������饩 �������
		PROPERTY DiagnosisPlus AS STRING READ getDiagnosisPlus WRITE setDiagnosisPlus			// ���������� � ��������� (+,-)
		
		PROPERTY Obrashen AS CHARACTER READ getObrashen WRITE setObrashen						// �஡��-��祣�, '1'-�����७�� �� ���, '2'-���������???
		PROPERTY Komu AS NUMERIC READ getKomu WRITE setKomu										// �� 1 �� 5
		PROPERTY InsurenceID AS NUMERIC READ getInsuranceID WRITE setInsuranceID					// ��� ���.��������, ������ � �.�.
		PROPERTY Za_Smo AS NUMERIC READ getZa_Smo WRITE setZa_Smo								// �����
		PROPERTY Policy AS STRING READ getPolicy WRITE setPolicy									// ��� � ����� ���客��� �����
		PROPERTY Department READ getDepartment WRITE setDepartment								// ��ꥪ� ��०�����
		PROPERTY IDDepartment AS NUMERIC READ getIDDepartment									// ID ��ꥪ� ��०�����
		PROPERTY Subdivision READ getSubdivision WRITE setSubdivision							// ��ꥪ� �⤥�����
		PROPERTY IDSubdivision AS NUMERIC READ getIDSubdivision									// ID ��ꥪ� �⤥�����
		PROPERTY UchDoc AS STRING READ getUchDoc WRITE setUchDoc									// ��� � ����� ��⭮�� ���㬥��
		PROPERTY Mi_Git AS NUMERIC READ getMi_Git WRITE setMi_Git								// 0-��த, 1-�������, 2-�����த���
		PROPERTY AreaCodeResidence AS NUMERIC READ getAreaCodeResidence WRITE setAreaCodeResidence	// ��� ࠩ��� ���� ��⥫��⢠
		PROPERTY Mest_Inog AS NUMERIC READ getMest_Inog WRITE setMest_Inog						// 0-���, 8 - ������,9-�⤥��� ���
		PROPERTY FinanceAreaCode AS NUMERIC READ getFinanceAreaCode WRITE setFinanceAreaCode		// ��� ࠩ��� 䨭���஢����
		PROPERTY RegLech AS NUMERIC READ getRegLech WRITE setRegLech								// 0-�᭮���, 9-�������⥫�� �����
		PROPERTY BeginTreatment AS DATE READ getBeginTreatment WRITE setBeginTreatment			// ��� ��砫� ��祭��
		PROPERTY EndTreatment AS DATE READ getEndTreatment WRITE setEndTreatment					// ��� ����砭�� ��祭��
		PROPERTY Total AS NUMERIC INDEX 1 READ getTotal WRITE setTotal							// �⮨����� ��祭��
		PROPERTY Total_1 AS NUMERIC INDEX 2 READ getTotal WRITE setTotal							// ����稢����� �㬬� ��祭��
		PROPERTY DisabilitySheet AS NUMERIC READ getDisabilitySheet WRITE setDisabilitySheet	// ���쭨��
		PROPERTY BeginDisabilitySheet AS DATE INDEX 1 READ getDateDisabilitySheet WRITE setDateDisabilitySheet // ��� ��砫� ���쭨筮��
		PROPERTY EndDisabilitySheet AS DATE INDEX 2 READ getDateDisabilitySheet WRITE setDateDisabilitySheet	// ��� ����砭�� ���쭨筮��
		PROPERTY DateAddLU AS DATE READ getDateAddLU WRITE setDateAddLU							// ��� ���������� ���� ���
		PROPERTY User READ getUser WRITE setUser													// ���짮��⥫�, �������訩 �/�
		PROPERTY IDUser AS NUMERIC READ getIDUser												// ID ���짮��⥫�, �������訩 �/�
		PROPERTY NextVisit AS DATE READ getNextVizit WRITE setNextVizit							// ��� ᫥�.����� ��� ���.������� 
		PROPERTY IDSchet AS NUMERIC READ getIDSchet WRITE setIDSchet								// ��� ���
		PROPERTY Ishod AS NUMERIC READ getIshod WRITE setIshod
		
		METHOD New( nID, lNew, lDeleted )
		
		
	HIDDEN:
		DATA FCode INIT 0
		DATA FIDCardFile INIT 0
		DATA FTreatmentCode INIT 0
		DATA FFIO INIT space( 50 )
		DATA FGender INIT '�'
		DATA FDOB INIT ctod( '' )
		DATA FVzros_Reb INIT 0
		DATA FAddress INIT space( 50 )
		DATA FPlaceWork INIT space( 50 )
		DATA FWorking INIT 0
		
		DATA FMainDiagnosis	INIT space( 5 )
		DATA FMainDiagnosis2	INIT space( 5 )
		DATA FMainDiagnosis3	INIT space( 5 )
		DATA FMainDiagnosis4	INIT space( 5 )
		DATA FaddDiagnosis1	INIT space( 5 )
		DATA FaddDiagnosis2	INIT space( 5 )
		DATA FaddDiagnosis3	INIT space( 5 )
		DATA FaddDiagnosis4	INIT space( 5 )
		DATA FaddDiagnosis5	INIT space( 5 )
		DATA FDiagnosisPlus	INIT space( 8 )
		
		DATA FObrashen INIT ' '
		DATA FKomu INIT 1
		DATA FInsuranceID INIT 0
		DATA FZa_Smo INIT 0
		DATA FPolicy INIT space( 17 )
		DATA FDepartment	INIT nil
		DATA FIDDepartment INIT 0
		DATA FSubdivision	INIT nil
		DATA FIDSubdivision INIT 0
		DATA FUchDoc INIT space( 10 )
		DATA FMi_Git INIT 0
		DATA FAreaCodeResidence INIT 0
		DATA FMest_Inog INIT 0
		DATA FFinanceAreaCode INIT 0
		DATA FRegLech INIT 0
		DATA FBeginTreatment INIT ctod( '' )
		DATA FEndTreatment INIT ctod( '' )
		DATA FTotal			INIT 0.0
		DATA FTotal_1		INIT 0.0
		DATA FDisabilitySheet INIT 0
		DATA FBeginDisabilitySheet INIT ctod( '' )
		DATA FEndDisabilitySheet INIT ctod( '' )
		DATA FDateAddLU INIT ctod( '' )
		DATA FUser INIT nil
		DATA FIDUser INIT 0
		DATA FNextVizit INIT ctod( '' )
		DATA FIDSchet INIT 0
		DATA FIshod INIT 0
		
		METHOD getCode
		METHOD setCode( param )
		METHOD getIDCardFile
		METHOD setIDCardFile( param )
		METHOD getTreatmentCode
		METHOD setTreatmentCode( param )
		METHOD getFIO
		METHOD getFIO1251
		METHOD setFIO( param )
		METHOD getGender
		METHOD setGender( param )
		METHOD getDOB
		METHOD setDOB( param )
		METHOD getVzros_Reb
		METHOD setVzros_Reb( param )
		METHOD getAddress
		METHOD setAddress( param )
		METHOD getPlaceWork
		METHOD setPlaceWork( cText )
		METHOD getWorking
		METHOD setWorking( param )
		
		METHOD getMainDiagnosis( nIndex )
		METHOD setMainDiagnosis( nIndex, cValue )
		METHOD getDiagnosis( nIndex )
		METHOD setDiagnosis( nIndex, cVal )
		METHOD getDiagnosisPlus
		METHOD setDiagnosisPlus( cValue )

		METHOD getObrashen
		METHOD setObrashen( param )
		METHOD getKomu
		METHOD setKomu( nNum )
		METHOD getInsuranceID
		METHOD setInsuranceID( nNum )
		METHOD getZa_Smo
		METHOD setZa_Smo( nNum )
		METHOD getPolicy
		METHOD setPolicy( cText )
		METHOD getDepartment
		METHOD getIDDepartment
		METHOD setDepartment( param )
		METHOD getSubdivision
		METHOD getIDSubdivision
		METHOD setSubdivision( param )
		METHOD getUchDoc
		METHOD setUchDoc( param )
		METHOD getMi_Git
		METHOD setMi_Git( nNum )
		METHOD getAreaCodeResidence
		METHOD setAreaCodeResidence( nNum )
		METHOD getMest_Inog
		METHOD setMest_Inog( nNum )
		METHOD getFinanceAreaCode
		METHOD setFinanceAreaCode( nNum )
		METHOD getRegLech
		METHOD setRegLech( nNum )
		METHOD getBeginTreatment
		METHOD setBeginTreatment( dValue )
		METHOD getEndTreatment
		METHOD setEndTreatment( dValue )
		METHOD getTotal( nIndex )
		METHOD setTotal( nIndex, nValue )
		METHOD getDisabilitySheet
		METHOD setDisabilitySheet( param )
		METHOD getDateDisabilitySheet( nIndex )
		METHOD setDateDisabilitySheet( nIndex, param )
		METHOD getDateAddLU
		METHOD setDateAddLU( dValue )
		METHOD getUser
		METHOD getIDUser
		METHOD setUser( obj )
		METHOD getNextVizit
		METHOD setNextVizit( param )
		METHOD getIDSchet
		METHOD setIDSchet( param )
		METHOD getIshod
		METHOD setIshod( param )
ENDCLASS

METHOD New( nID, lNew, lDeleted )		CLASS THuman

	::super:new( nID, lNew, lDeleted )
	return self
	
METHOD function getIDDepartment()				CLASS THuman
	return ::FIDDepartment

METHOD function getIDSubdivision()				CLASS THuman
	return ::FIDSubdivision

METHOD function getIshod()				CLASS THuman
	return ::FIshod

METHOD procedure setIshod( param )		CLASS THuman
	::FIshod := param
	return

METHOD function getIDSchet()				CLASS THuman
	return ::FIDSchet

METHOD procedure setIDSchet( param )		CLASS THuman
	::FIDSchet := param
	return

METHOD function getNextVizit()				CLASS THuman
	return ::FNextVizit

METHOD procedure setNextVizit( dValue )		CLASS THuman
	::FNextVizit := dValue
	return

METHOD function getIDUser() CLASS THuman
	return ::FIDUser

METHOD function getUser() CLASS THuman

	if isnil( ::FUser )
		::FUser := TUserDB():GetByID( ::FIDUser )
	endif
	return ::FUser

METHOD procedure setUser( param ) CLASS THuman
	local tmpObj := nil

	if isnumber( param ) .and. param != 0
		::FIDUser := param
		&& tmpObj := TUserDB():GetByID( param )
	elseif isobject( param ) .and. param:ClassName() == upper( 'TUser' )
		::FIDUser := param:ID
		&& tmpObj := param
	endif
	&& ::FUser := tmpObj
	return

METHOD function getDateAddLU()				CLASS THuman
	return ::FDateAddLU

METHOD procedure setDateAddLU( dValue )		CLASS THuman
	::FDateAddLU := dValue
	return

METHOD function getDateDisabilitySheet( nIndex )						CLASS THuman
	local ret
	switch nIndex
		case 1
			ret := ::FBeginDisabilitySheet
			exit
		case 2
			ret := ::FEndDisabilitySheet
			exit
	endswitch
	return ret

METHOD procedure setDateDisabilitySheet( nIndex, nValue )				CLASS THuman
	switch nIndex
		case 1
			::FBeginDisabilitySheet := nValue
			exit
		case 2
			::FEndDisabilitySheet := nValue
			exit
	endswitch
	return

METHOD function getDisabilitySheet()				CLASS THuman
	return ::FDisabilitySheet

METHOD procedure setDisabilitySheet( param )		CLASS THuman
	::FDisabilitySheet := param
	return

METHOD function getTotal( nIndex )						CLASS THuman
	local ret
	switch nIndex
		case 1
			ret := ::FTotal
			exit
		case 2
			ret := ::FTotal_1
			exit
	endswitch
	return ret

METHOD procedure setTotal( nIndex, nValue )				CLASS THuman
	switch nIndex
		case 1
			::FTotal := nValue
			exit
		case 2
			::FTotal_1 := nValue
			exit
	endswitch
	return

METHOD function getBeginTreatment()				CLASS THuman
	return ::FBeginTreatment

METHOD procedure setBeginTreatment( dValue )		CLASS THuman
	::FBeginTreatment := dValue
	return

METHOD function getEndTreatment()					CLASS THuman
	return ::FEndTreatment

METHOD procedure setEndTreatment( dValue )		CLASS THuman
	::FEndTreatment := dValue
	return
	
METHOD function getRegLech()		CLASS THuman
	return ::FRegLech
	
METHOD procedure setRegLech( nNum )		CLASS THuman

	if nNum != ::FRegLech
		::FRegLech := nNum
	endif
	return

METHOD function getFinanceAreaCode()		CLASS THuman
	return ::FFinanceAreaCode
	
METHOD procedure setFinanceAreaCode( nNum )		CLASS THuman

	if nNum != ::FFinanceAreaCode
		::FFinanceAreaCode := nNum
	endif
	return

METHOD function getMest_Inog()		CLASS THuman
	return ::FMest_Inog
	
METHOD procedure setMest_Inog( nNum )		CLASS THuman

	if nNum != ::FMest_Inog
		::FMest_Inog := nNum
	endif
	return

METHOD function getAreaCodeResidence()		CLASS THuman
	return ::FAreaCodeResidence
	
METHOD procedure setAreaCodeResidence( nNum )		CLASS THuman

	if nNum != ::FAreaCodeResidence
		::FAreaCodeResidence := nNum
	endif
	return

METHOD function getMi_Git()		CLASS THuman
	return ::FMi_Git
	
METHOD procedure setMi_Git( nNum )		CLASS THuman

	if nNum != ::FMi_Git
		::FMi_Git := nNum
	endif
	return

METHOD function getUchDoc()		CLASS THuman
	return ::FUchDoc
	
METHOD procedure setUchDoc( param )		CLASS THuman

	::FUchDoc := param
	return

METHOD function getDepartment()  CLASS THuman
	
	if isnil( ::FDepartment )
		::FDepartment := if( ::FIDDepartment == 0, nil, TDepartmentDB():getByID( ::FIDDepartment ) )
	endif
	return ::FDepartment

METHOD procedure setDepartment( param ) CLASS THuman
	
	if isnumber( param )
		&& ::FDepartment := TDepartmentDB():getByID( param )
		::FIDDepartment := param
	elseif isobject( param ) .and. param:ClassName() == upper( 'TDepartment' )
		&& ::FDepartment := param
		::FIDDepartment := param:ID
	elseif param == nil
		&& ::FDepartment := nil
	endif
	return

METHOD function getSubdivision()  CLASS THuman

	if isnil( ::FSubdivision )
		::FSubdivision := if( ::FIDSubdivision == 0, nil, TSubdivisionDB():getByID( ::FIDSubdivision ) )
	endif
	return ::FSubdivision

METHOD procedure setSubdivision( param ) CLASS THuman
	
	if isnumber( param )
		&& ::FSubdivision := TSubdivisionDB():getByID( param )
		::FIDSubdivision := param
	elseif isobject( param ) .and. param:ClassName() == upper( 'TSubdivision' )
		&& ::FSubdivision := param
		::FIDSubdivision := param:ID
	elseif param == nil
		&& ::FSubdivision := nil
	endif
	return

METHOD function getPolicy()		CLASS THuman
	return ::FPolicy

METHOD procedure setPolicy( cText )		CLASS THuman

	if alltrim( cText ) != alltrim( ::FPolicy )
		::FPolicy := cText
	endif
	return

METHOD function getZa_Smo()		CLASS THuman
	return ::FZa_Smo
	
METHOD procedure setZa_Smo( nNum )		CLASS THuman

	if nNum != ::FZa_Smo
		::FZa_Smo := nNum
	endif
	return

METHOD function getInsuranceID()		CLASS THuman
	return ::FInsuranceID
	
METHOD procedure setInsuranceID( nNum )		CLASS THuman

	if nNum != ::FInsuranceID
		::FInsuranceID := nNum
	endif
	return

METHOD function getKomu()		CLASS THuman
	return ::FKomu
	
METHOD procedure setKomu( nNum )		CLASS THuman

	if nNum != ::FKomu
		::FKomu := nNum
	endif
	return

METHOD function getObrashen()		CLASS THuman
	return ::FObrashen
	
METHOD procedure setObrashen( param )		CLASS THuman

	::FObrashen := param
	return

METHOD function getDiagnosisPlus()		CLASS THuman
	return ::FDiagnosisPlus
	
METHOD procedure setDiagnosisPlus( param )		CLASS THuman

	::FDiagnosisPlus := param
	return

METHOD function getMainDiagnosis( nIndex )		CLASS THuman
	local ret
	switch nIndex
		case 1
			ret := ::FMainDiagnosis
			exit
		case 2
			ret := ::FMainDiagnosis2
			exit
		case 3
			ret := ::FMainDiagnosis3
			exit
		case 4
			ret := ::FMainDiagnosis4
			exit
	endswitch
	return ret

METHOD procedure setMainDiagnosis( nIndex, cValue )		CLASS THuman
	switch nIndex
		case 1
			::FMainDiagnosis := cValue
			exit
		case 2
			::FMainDiagnosis2 := cValue
			exit
		case 3
			::FMainDiagnosis3 := cValue
			exit
		case 4
			::FMainDiagnosis4 := cValue
			exit
	endswitch
	return
	
METHOD function getDiagnosis( nIndex ) CLASS THuman
	local ret
	switch nIndex
		case 1
			ret := ::FaddDiagnosis1
			exit
		case 2
			ret := ::FaddDiagnosis2
			exit
		case 3
			ret := ::FaddDiagnosis3
			exit
		case 4
			ret := ::FaddDiagnosis4
			exit
	endswitch
	return ret

METHOD procedure setDiagnosis( nIndex, cVal ) CLASS THuman
	switch nIndex
		case 1
			::FaddDiagnosis1 := cVal
			exit
		case 2
			::FaddDiagnosis2 := cVal
			exit
		case 3
			::FaddDiagnosis3 := cVal
			exit
		case 4
			::FaddDiagnosis4 := cVal
			exit
	endswitch
	return

METHOD function getWorking()		CLASS THuman
	return ::FWorking
	
METHOD procedure setWorking( nNum )		CLASS THuman

	if nNum != ::FWorking
		::FWorking := nNum
	endif
	return

METHOD function getPlaceWork()		CLASS THuman
	return ::FPlaceWork

METHOD procedure setPlaceWork( param )		CLASS THuman

	if alltrim( param ) != alltrim( ::FPlaceWork )
		::FPlaceWork := param
	endif
	return

METHOD function getVzros_Reb()		CLASS THuman
	return ::FVzros_Reb
	
METHOD procedure setVzros_Reb( param )		CLASS THuman

	if param != ::FVzros_Reb
		::FVzros_Reb := param
	endif
	return

METHOD function getAddress()		CLASS THuman
	return ::FAddress

METHOD procedure setAddress( param )		CLASS THuman

	::FAddress := param
	return

METHOD function getDOB()		CLASS THuman
	return ::FDOB

METHOD procedure setDOB( param )		CLASS THuman

	if isdate( param ) .and. param != ::FDOB
		::FDOB := param
	endif
	return

METHOD function getGender()		CLASS THuman
	return ::FGender

METHOD procedure setGender( param )		CLASS THuman
	local ch := upper( left( param, 1 ) )
	
	if ( ch $ '����MFmf' )
		if ch != ::FGender
			::FGender := ch
		endif
	endif
	return

METHOD function getFIO1251()		CLASS THuman
	return win_OEMToANSI( ::FFIO )

METHOD function getFIO()		CLASS THuman
	return ::FFIO

METHOD procedure setFIO( param )		CLASS THuman

	if alltrim( param ) != alltrim( ::FFIO )
		::FFIO := upper( param )
	endif
	return

METHOD function getTreatmentCode()	CLASS THuman
	return ::FTreatmentCode
	
METHOD procedure setTreatmentCode( param )	CLASS THuman
	::FTreatmentCode := param
	return

METHOD function getIDCardFile()	CLASS THuman
	return ::FIDCardFile
	
METHOD procedure setIDCardFile( param )	CLASS THuman
	::FIDCardFile := param
	return

METHOD function getCode()	CLASS THuman
	return ::FCode
	
METHOD procedure setCode( param )	CLASS THuman
	::FCode := param
	return