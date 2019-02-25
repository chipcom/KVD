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
		METHOD getIDIssue						INLINE ::FIDIssue
		METHOD setIDIssue( param )
		METHOD getPolicyType						INLINE ::FPolicyType
		METHOD setPolicyType( param )
		METHOD getPolicySeries					INLINE ::FPolicySeries
		METHOD setPolicySeries( param )
		METHOD getPolicyNumber					INLINE ::FPolicyNumber
		METHOD setPolicyNumber( param )
		METHOD getSMO							INLINE ::FSMO
		METHOD setSMO( param )
		METHOD getBeginPolicy					INLINE ::FBeginPolicy
		METHOD setBeginPolicy( param )
		METHOD getStrana							INLINE ::FStrana
		METHOD setStrana( param )
		METHOD getGorodSelo						INLINE ::FGorodSelo
		METHOD setGorodSelo( param )
		METHOD getDocumentType					INLINE ::FDocumentType
		METHOD setDocumentType( param )
		METHOD getDocumentSeries					INLINE ::FDocumentSeries
		METHOD setDocumentSeries( param )
		METHOD getDocumentNumber					INLINE ::FDocumentNumber
		METHOD setDocumentNumber( param )
		METHOD getDateIssue						INLINE ::FDateIssue
		METHOD setDateIssue( param )
		METHOD getCategory( nIndex )
		METHOD setCategory( nIndex, param )
		METHOD getPlaceBorn						INLINE ::FPlaceBorn
		METHOD setPlaceBorn( param )
		METHOD getDMS_SMO						INLINE ::FDMS_SMO
		METHOD setDMS_SMO( param )
		METHOD getDMSPolicy						INLINE ::FDMSPolicy
		METHOD setDMSPolicy( param )
		METHOD getKvartal( nIndex )
		METHOD setKvartal( nIndex, param )
		METHOD getPhone( nIndex )
		METHOD setPhone( nIndex, param )
		METHOD getCodeLgot						INLINE ::FCodeLgot
		METHOD setCodeLgot( param )
		METHOD getIsRegistr						INLINE ::FIsRegistr
		METHOD setIsRegister( param )
		METHOD getIsPensioner					INLINE ::FIsPensioner
		METHOD setIsPensioner( param )
		&& METHOD getInvalid
		&& METHOD setInvalid( param )
		METHOD getDegreeOfDisability				INLINE ::FDegreeOfDisability
		METHOD setDegreeOfDisability( param )
		METHOD getBloodType						INLINE ::FBloodType
		METHOD setBloodType( param )
		METHOD getRhesusFactor					INLINE ::FRhesusFactor
		METHOD setRhesusFactor( param )
		METHOD getWeight							INLINE ::FWeight
		METHOD setWeight( param )
		METHOD getHeight							INLINE ::FHeight
		METHOD setHeight( param )
		METHOD getWhereCard						INLINE ::FWhereCard
		METHOD setWhereCard( param )
		METHOD getGroupRisk						INLINE ::FGroupRisk
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

METHOD procedure setGroupRisk( param ) CLASS TPatientExt

	if isnumber( param )
		::FGroupRisk := param
	endif
	return

METHOD procedure setWhereCard( param ) CLASS TPatientExt

	if isnumber( param )
		::FWhereCard := param
	endif
	return

METHOD procedure setHeight( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0
		::FHeight := param
	endif
	return

METHOD procedure setWeight( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0
		::FWeight := param
	endif
	return

METHOD procedure setRhesusFactor( param ) CLASS TPatientExt

	if ischaracter( param ) .and. param $ '+-'
		::FRhesusFactor := param
	endif
	return

METHOD procedure setBloodType( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0 .and. param < 5
		::FBloodType := param
	endif
	return

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

METHOD procedure setIsPensioner( param ) CLASS TPatientExt

	if islogical( param )
		::FIsPensioner := param
	endif
	return

METHOD procedure setIsRegister( param ) CLASS TPatientExt

	if islogical( param )
		::FIsRegistr := param
	endif
	return

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

METHOD procedure setDMSPolicy( param ) CLASS TPatientExt

	if ischaracter( param )
		::FDMSPolicy := param
	endif
	return

METHOD procedure setDMS_SMO( param ) CLASS TPatientExt

	if isnumber( param )
		::FDMS_SMO := param
	endif
	return

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

METHOD procedure setDateIssue( param ) CLASS TPatientExt

	if isdate( param )
		::FDateIssue := param
	endif
	return

METHOD procedure setDocumentNumber( param ) CLASS TPatientExt

	if ischaracter( param )
		::FDocumentNumber := param
	endif
	return

METHOD procedure setDocumentSeries( param ) CLASS TPatientExt

	if ischaracter( param )
		::FDocumentSeries := param
	endif
	return

METHOD procedure setDocumentType( param ) CLASS TPatientExt

	if isnumber( param )
		::FDocumentType := param
	endif
	return

METHOD procedure setGorodSelo( param ) CLASS TPatientExt

	if isnumber( param )
		::FGorodSelo := param
	endif
	return

METHOD procedure setBeginPolicy( param ) CLASS TPatientExt

	if isdate( param )
		::FBeginPolicy := param
	endif
	return

METHOD procedure setStrana( param ) CLASS TPatientExt

	if ischaracter( param )
		::FStrana := param
	endif
	return

METHOD procedure setSMO( param ) CLASS TPatientExt

	if ischaracter( param )
		::FSMO := param
	endif
	return

METHOD procedure setPolicyNumber( param ) CLASS TPatientExt

	if ischaracter( param )
		::FPolicyNumber := param
	endif
	return

METHOD procedure setPolicySeries( param ) CLASS TPatientExt

	if ischaracter( param )
		::FPolicySeries := param
	endif
	return

METHOD procedure setPolicyType( param ) CLASS TPatientExt

	if isnumber( param ) .and. param > 0 .and. param < 4
		::FPolicyType := param
	endif
	return

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