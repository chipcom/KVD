#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatientExt	INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Passport READ getPassport WRITE setPassport			// удостоверение личности физического лица
		&& PROPERTY Passport WRITE setPassport INIT nil					// удостоверение личности физического лица
		PROPERTY OKATOG WRITE setOKATOG INIT space( 11 )				// ОКАТО места регистрации
		PROPERTY OKATOP WRITE setOKATOP INIT space( 11 )				// ОКАТО места пребывания
		PROPERTY AddressStay WRITE setAddressStay INIT space( 50 )	// адрес места пребывания
		PROPERTY IDIssue AS STRING READ getIDIssue WRITE setIDIssue	// кем выдан документ;"справочник ""s_kemvyd"""
		PROPERTY PolicyType AS NUMERIC READ getPolicyType WRITE setPolicyType	// вид полиса (от 1 до 3);1-старый,2-врем.,3-новый;по умолчанию 1 - старый
		PROPERTY PolicySeries AS STRING READ getPolicySeries WRITE setPolicySeries	// серия полиса;;для наших - разделить по пробелу
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber WRITE setPolicyNumber	// номер полиса;;"для иногородних - вынуть из ""k_inog"" и разделить"
		PROPERTY SMO AS STRING READ getSMO WRITE setSMO		// реестровый номер СМО;;преобразовать из старых кодов в новые, иногродние = 34
		PROPERTY BeginPolicy AS DATE READ getBeginPolicy WRITE setBeginPolicy	// дата начала действия полиса
		PROPERTY Strana AS STRING READ getStrana WRITE setStrana	// гражданство пациента (страна);выбор из справочника стран;"поле ""strana"" из файла ""k_inog"" для иногородних, для остальных пусто = РФ"
		PROPERTY GorodSelo AS NUMERIC READ getGorodSelo WRITE setGorodSelo	// житель?;1-город, 2-село, 3-рабочий поселок;"поле ""gorod_selo"" из файла ""pp_human"""
		PROPERTY DocumentType AS NUMERIC READ getDocumentType WRITE setDocumentType		// вид удостоверения личности;по кодировке ФФОМС
		PROPERTY DocumentSeries AS STRING READ getDocumentSeries WRITE setDocumentSeries	// серия удостоверения личности
		PROPERTY DocumentNumber AS STRING READ getDocumentNumber WRITE setDocumentNumber	// номер удостоверения личности
		PROPERTY DateIssue AS DATE READ getDateIssue WRITE setDateIssue	// когда выдан документ
		PROPERTY Category AS NUMERIC INDEX 1 READ getCategory WRITE setCategory	// категория пациента
		PROPERTY Category2 AS NUMERIC INDEX 2 READ getCategory WRITE setCategory  // категория пациента (собственная для МО)
		PROPERTY PlaceBorn AS STRING READ getPlaceBorn WRITE setPlaceBorn	// место рождения
		PROPERTY DMS_SMO AS NUMERIC READ getDMS_SMO WRITE setDMS_SMO			// код СМО ДМС
		PROPERTY DMSPolicy AS STRING READ getDMSPolicy WRITE setDMSPolicy    // код полиса ДМС
		PROPERTY Kvartal AS STRING INDEX 1 READ getKvartal WRITE setKvartal	// квартал для Волжского
		PROPERTY KvartalHouse AS STRING INDEX 2 READ getKvartal WRITE setKvartal	// дом в квартале Волжского
		PROPERTY HomePhone AS STRING INDEX 1 READ getPhone WRITE setPhone	// телефон домашний
		PROPERTY MobilePhone AS STRING INDEX 2 READ getPhone WRITE setPhone	// телефон мобильный
		PROPERTY WorkPhone AS STRING INDEX 3 READ getPhone WRITE setPhone	// телефон рабочий
		PROPERTY CodeLgot AS STRING READ getCodeLgot WRITE setCodeLgot			// код льготы по ДЛО
		PROPERTY IsRegistr AS LOGICAL READ getIsRegistr WRITE setIsRegister		// есть ли в регистре ДЛО;0-нет, 1-есть;
		PROPERTY IsPensioner AS LOGICAL READ getIsPensioner WRITE setIsPensioner	// является пенсионером?;0-нет, 1-да;
		PROPERTY Invalid AS NUMERIC READ getInvalid WRITE setInvalid		// инвалидность;0-нет,1,2,3-степень, 4-инвалид детства;
		PROPERTY DegreeOfDisability AS NUMERIC READ getDegreeOfDisability WRITE setDegreeOfDisability	// степень инвалидности;1 или 2;
		PROPERTY BloodType AS NUMERIC READ getBloodType WRITE setBloodType		// группа крови;от 1 до 4
		PROPERTY RhesusFactor AS CHARACTER READ getRhesusFactor WRITE setRhesusFactor		// резус-фактор;"+" или "-"
		PROPERTY Weight AS NUMERIC READ getWeight WRITE setWeight			// вес в кг
		PROPERTY Height AS NUMERIC READ getHeight WRITE setHeight			// рост в см
		PROPERTY WhereCard AS NUMERIC READ getWhereCard WRITE setWhereCard		// где амбулаторная карта;0-в регистратуре, 1-у врача, 2-на руках
		PROPERTY GroupRisk AS NUMERIC READ getGroupRisk WRITE setGroupRisk		// группа риска по стандарту горздрава;;если есть REGI_FL.DBF, то взять из него
		PROPERTY DateLastXRay AS DATE INDEX 1 READ getDate WRITE setDate		// дата последней флюорогрфии;;если есть REGI_FL.DBF, то взять из него
		PROPERTY DateLastMunRecipe AS DATE INDEX 2 READ getDate WRITE setDate		// дата последнего муниципального рецепта
		PROPERTY DateLastFedRecipe AS DATE INDEX 3 READ getDate WRITE setDate		// дата последнего федерального рецепта
		
		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )

		METHOD New( nID, lNew, lDeleted )
	EXPORTED:		// временно
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

// для оповещения классом TPatient
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