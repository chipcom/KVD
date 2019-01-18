#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS THuman	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code AS NUMERIC READ getCode WRITE setCode												// код (номер записи)
		PROPERTY IDCardFile AS NUMERIC READ getIDCardFile WRITE setIDCardFile							// код по картотеке
		PROPERTY TreatmentCode AS NUMERIC READ getTreatmentCode WRITE setTreatmentCode					// 1-лечится,2-лечение не завершено,3-лечение не завершено,4-выписан счет,5-оплачен полностью,6-больной не оплачивается
		PROPERTY FIO AS STRING READ getFIO WRITE setFIO													// Ф.И.О. больного
		PROPERTY FIO1251 READ getFIO1251
		PROPERTY Gender AS CHARACTER READ getGender WRITE setGender										// пол
		PROPERTY DOB AS DATE READ getDOB WRITE setDOB														// дата рождения
		PROPERTY Vzros_Reb AS NUMERIC READ getVzros_Reb WRITE setVzros_Reb								// 0-взрослый, 1-ребенок, 2-подросток
		PROPERTY AddressReg AS STRING READ getAddressReg WRITE setAddressReg										// адрес регистрации
		PROPERTY PlaceWork AS STRING READ getPlaceWork WRITE setPlaceWork								// место работы или причина безработности
		PROPERTY Working AS NUMERIC READ getWorking WRITE setWorking										// 0-работающий, 1-неработающий
		
		PROPERTY MainDiagnosis AS STRING INDEX 1 READ getMainDiagnosis WRITE setMainDiagnosis	// шифр 1-ой осн.болезни
		PROPERTY MainDiagnosis2 AS STRING INDEX 2 READ getMainDiagnosis WRITE setMainDiagnosis	// шифр 2-ой осн.болезни
		PROPERTY MainDiagnosis3 AS STRING INDEX 3 READ getMainDiagnosis WRITE setMainDiagnosis	// шифр 3-ой осн.болезни
		PROPERTY MainDiagnosis4 AS STRING INDEX 4 READ getMainDiagnosis WRITE setMainDiagnosis	// шифр 4-ой осн.болезни
		PROPERTY Diagnosis1 AS STRING INDEX 1 READ getDiagnosis WRITE setDiagnosis				// шифр 1-ой сопутствующей болезни
		PROPERTY Diagnosis2 AS STRING INDEX 2 READ getDiagnosis WRITE setDiagnosis				// шифр 2-ой сопутствующей болезни
		PROPERTY Diagnosis3 AS STRING INDEX 3 READ getDiagnosis WRITE setDiagnosis				// шифр 3-ой сопутствующей болезни
		PROPERTY Diagnosis4 AS STRING INDEX 4 READ getDiagnosis WRITE setDiagnosis				// шифр 4-ой сопутствующей болезни
		PROPERTY DiagnosisPlus AS STRING READ getDiagnosisPlus WRITE setDiagnosisPlus			// дополнение к диагнозам (+,-)
		
		PROPERTY Obrashen AS CHARACTER READ getObrashen WRITE setObrashen						// пробел-ничего, '1'-подозрение на ЗНО, '2'-онкология???
		PROPERTY Komu AS NUMERIC READ getKomu WRITE setKomu										// от 1 до 5
		PROPERTY InsurenceID AS NUMERIC READ getInsuranceID WRITE setInsuranceID					// код стр.компании, комитета и т.п.
		PROPERTY Za_Smo AS NUMERIC READ getZa_Smo WRITE setZa_Smo								// ЗаСМО
		PROPERTY Policy AS STRING READ getPolicy WRITE setPolicy									// серия и номер страхового полиса
		PROPERTY Department READ getDepartment WRITE setDepartment								// объект учреждения
		PROPERTY IDDepartment AS NUMERIC READ getIDDepartment									// ID объекта учреждения
		PROPERTY Subdivision READ getSubdivision WRITE setSubdivision							// объект отделения
		PROPERTY IDSubdivision AS NUMERIC READ getIDSubdivision									// ID объекта отделения
		PROPERTY UchDoc AS STRING READ getUchDoc WRITE setUchDoc									// вид и номер учетного документа
		PROPERTY Mi_Git AS NUMERIC READ getMi_Git WRITE setMi_Git								// 0-город, 1-область, 2-иногородний
		PROPERTY AreaCodeResidence AS NUMERIC READ getAreaCodeResidence WRITE setAreaCodeResidence	// код района места жительства
		PROPERTY Mest_Inog AS NUMERIC READ getMest_Inog WRITE setMest_Inog						// 0-нет, 8 - аноним,9-отдельные ФИО
		PROPERTY FinanceAreaCode AS NUMERIC READ getFinanceAreaCode WRITE setFinanceAreaCode		// код района финансирования
		PROPERTY RegLech AS NUMERIC READ getRegLech WRITE setRegLech								// 0-основные, 9-дополнительные объёмы
		PROPERTY BeginTreatment AS DATE READ getBeginTreatment WRITE setBeginTreatment			// дата начала лечения
		PROPERTY EndTreatment AS DATE READ getEndTreatment WRITE setEndTreatment					// дата окончания лечения
		PROPERTY Total AS NUMERIC INDEX 1 READ getTotal WRITE setTotal							// стоимость лечения
		PROPERTY Total_1 AS NUMERIC INDEX 2 READ getTotal WRITE setTotal							// оплачиваемая сумма лечения
		PROPERTY DisabilitySheet AS NUMERIC READ getDisabilitySheet WRITE setDisabilitySheet	// больничный
		PROPERTY BeginDisabilitySheet AS DATE INDEX 1 READ getDateDisabilitySheet WRITE setDateDisabilitySheet // дата начала больничного
		PROPERTY EndDisabilitySheet AS DATE INDEX 2 READ getDateDisabilitySheet WRITE setDateDisabilitySheet	// дата окончания больничного
		PROPERTY DateAddLU AS DATE READ getDateAddLU WRITE setDateAddLU							// дата добавления листа учета
		PROPERTY User READ getUser WRITE setUser													// пользователь, добавивший л/у
		PROPERTY IDUser AS NUMERIC READ getIDUser												// ID пользователя, добавивший л/у
		PROPERTY NextVisit AS DATE READ getNextVizit WRITE setNextVizit							// дата след.визита для дисп.наблюдения 
		PROPERTY IDSchet AS NUMERIC READ getIDSchet WRITE setIDSchet								// код счета
		PROPERTY Ishod AS NUMERIC READ getIshod WRITE setIshod
		
		PROPERTY PolicyOMS AS OBJECT READ getPolicyOMS WRITE setPolicyOMS							// объект описывающий полис ОМС
		
		PROPERTY ExtendInfo AS OBJECT READ getExtendInfo WRITE setExtendInfo							// объекта THumanExt ( human_.dbf  )
		PROPERTY AddInfo AS OBJECT READ getAddInfo WRITE setAddInfo								// объект THumanAdd ( human_2.dbf )
		
		METHOD New( nID, lNew, lDeleted )
		
		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )
	HIDDEN:
		DATA FExtendInfo	AS OBJECT INIT nil	// для хранения объекта THumanExt ( human_.dbf )
		DATA FAddInfo	AS OBJECT INIT nil	// для хранения объекта THumanAdd ( human_2.dbf )
		
		DATA FCode INIT 0
		DATA FIDCardFile INIT 0
		DATA FTreatmentCode INIT 0
		DATA FFIO INIT space( 50 )
		DATA FGender INIT 'М'
		DATA FDOB INIT ctod( '' )
		DATA FVzros_Reb INIT 0
		DATA FAddressReg INIT space( 50 )
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
		
		METHOD getExtendInfo
		METHOD setExtendInfo( param )
		METHOD getAddInfo
		METHOD setAddInfo( param )

		METHOD getCode					INLINE ::FCode
		METHOD setCode( param )
		METHOD getIDCardFile				INLINE ::FIDCardFile
		METHOD setIDCardFile( param )
		METHOD getTreatmentCode			INLINE ::FTreatmentCode
		METHOD setTreatmentCode( param )
		METHOD getFIO					INLINE ::FFIO
		METHOD getFIO1251				INLINE win_OEMToANSI( ::FFIO )
		METHOD setFIO( param )
		METHOD getGender					INLINE ::FGender
		METHOD setGender( param )
		METHOD getDOB					INLINE ::FDOB
		METHOD setDOB( param )
		METHOD getVzros_Reb				INLINE ::FVzros_Reb
		METHOD setVzros_Reb( param )
		METHOD getAddressReg				INLINE ::FAddressReg
		METHOD setAddressReg( param )
		METHOD getPlaceWork				INLINE ::FPlaceWork
		METHOD setPlaceWork( cText )
		METHOD getWorking				INLINE ::FWorking
		METHOD setWorking( param )
		
		METHOD getMainDiagnosis( nIndex )
		METHOD setMainDiagnosis( nIndex, cValue )
		METHOD getDiagnosis( nIndex )
		METHOD setDiagnosis( nIndex, cVal )
		METHOD getDiagnosisPlus			INLINE ::FDiagnosisPlus
		METHOD setDiagnosisPlus( cValue )

		METHOD getObrashen				INLINE ::FObrashen
		METHOD setObrashen( param )
		METHOD getKomu					INLINE ::FKomu
		METHOD setKomu( nNum )
		METHOD getInsuranceID			INLINE ::FInsuranceID
		METHOD setInsuranceID( nNum )
		METHOD getZa_Smo					INLINE ::FZa_Smo
		METHOD setZa_Smo( nNum )
		METHOD getPolicy					INLINE ::FPolicy
		METHOD setPolicy( cText )
		METHOD getDepartment
		METHOD getIDDepartment			INLINE FIDDepartment
		METHOD setDepartment( param )
		METHOD getSubdivision
		METHOD getIDSubdivision			INLINE ::FIDSubdivision
		METHOD setSubdivision( param )
		METHOD getUchDoc					INLINE ::FUchDoc
		METHOD setUchDoc( param )
		METHOD getMi_Git					INLINE ::FMi_Git
		METHOD setMi_Git( nNum )
		METHOD getAreaCodeResidence		INLINE ::FAreaCodeResidence
		METHOD setAreaCodeResidence( nNum )
		METHOD getMest_Inog				INLINE ::FMest_Inog
		METHOD setMest_Inog( nNum )
		METHOD getFinanceAreaCode		INLINE ::FFinanceAreaCode
		METHOD setFinanceAreaCode( nNum )
		METHOD getRegLech				INLINE ::FRegLech
		METHOD setRegLech( nNum )
		METHOD getBeginTreatment			INLINE ::FBeginTreatment
		METHOD setBeginTreatment( dValue )
		METHOD getEndTreatment			INLINE ::FEndTreatment
		METHOD setEndTreatment( dValue )
		METHOD getTotal( nIndex )
		METHOD setTotal( nIndex, nValue )
		METHOD getDisabilitySheet		INLINE ::FDisabilitySheet
		METHOD setDisabilitySheet( param )
		METHOD getDateDisabilitySheet( nIndex )
		METHOD setDateDisabilitySheet( nIndex, param )
		METHOD getDateAddLU				INLINE ::FDateAddLU
		METHOD setDateAddLU( dValue )
		METHOD getUser
		METHOD getIDUser					INLINE ::FIDUser
		METHOD setUser( obj )
		METHOD getNextVizit				INLINE ::FNextVizit
		METHOD setNextVizit( param )
		METHOD getIDSchet				INLINE ::FIDSchet
		METHOD setIDSchet( param )
		METHOD getIshod					INLINE ::FIshod
		METHOD setIshod( param )
		METHOD getPolicyOMS
		METHOD setPolicyOMS( param )
ENDCLASS

METHOD New( nID, lNew, lDeleted )		CLASS THuman

	::super:new( nID, lNew, lDeleted )
	return self
	
METHOD procedure setID( param )	CLASS THuman

	if isnumber( param ) .and. param != 0
		::FID := param
		if ! isnil( ::FExtendInfo )
			// оповестим класс TExtendInfo
			if __objHasMsgAssigned( ::FExtendInfo, 'setID' )
				__objSendMsg( ::FExtendInfo, 'setID', param )
			endif
		endif
		if ! isnil( ::FAddInfo )
			// оповестим класс TAddInfo
			if __objHasMsgAssigned( ::FAddInfo, 'setID' )
				__objSendMsg( ::FAddInfo, 'setID', param )
			endif
		endif
	endif
	return

METHOD function getPolicyOMS()						CLASS THuman
	local oPolicy

	if ::FExtendInfo == nil
		::FExtendInfo := THumanExtDB():getByID( ::ID )
	endif
	oPolicy := TPolicyOMS():New( ::FExtendInfo:PolicyType, ::FExtendInfo:PolicySeries, ::FExtendInfo:PolicyNumber, ;
				::FExtendInfo:SMO ) //, ::FExtendInfo:BeginPolicy, ::FPolicyPeriod )
	&& oPolicy:OKATOInogSMO := ::FExtendInfo:KvartalHouse
	oPolicy:OKATOInogSMO := ::FExtendInfo:OKATO
	oPolicy:Owner := self
	return oPolicy

METHOD procedure setPolicyOMS( param )				CLASS THuman

	if isobject( param) .and. param:classname == upper( 'TPolicyOMS' )
		if ::FExtendInfo == nil
			::FExtendInfo := THumanExtDB():getByID( ::ID )
		endif
		::FPolicy := alltrim( param:PolicySeries ) + ;
				if( ! empty( param:PolicyNumber ), ' ' + alltrim( param:PolicyNumber ), '' )
		::FExtendInfo:PolicyType := param:PolicyType
		::FExtendInfo:PolicySeries := param:PolicySeries
		::FExtendInfo:PolicyNumber := param:PolicyNumber
		::FExtendInfo:SMO := param:SMO
		&& ::FExtendInfo:BeginPolicy := param:BeginPolicy
		&& ::FPolicyPeriod := param:PolicyPeriod
		&& ::FExtendInfo:KvartalHouse := param:OKATOInogSMO
		::FExtendInfo:OKATO := param:OKATOInogSMO
	endif
	return

METHOD function getExtendInfo()	CLASS THuman
	
	if isnil( ::FExtendInfo )
		if ::IsNew
			::FExtendInfo := THumanExt():New()
		else
			::FExtendInfo := THumanExtDB():GetByID( ::ID )			// получим объект дополнительной информации о пациенте
		endif
	endif
	return ::FExtendInfo

METHOD procedure setExtendInfo( param )	CLASS THuman

	if isobject( param ) .and. param:classname == upper( 'THumanExt' )
		::FExtendInfo := param
	endif
	return

METHOD function getAddInfo()	CLASS THuman
	
	if ::IsNew
		::FAddInfo := THumanAdd():New()
	else
		if isnil( ::FAddInfo )
			::FAddInfo := THumanAddDB:GetByID( ::FID )			// получим объект дополнительной информации о пациенте
		endif
	endif
	return ::FAddInfo

METHOD procedure setAddInfo( param )	CLASS THuman

	if isobject( param ) .and. param:classname == upper( 'THumanAdd' )
		::FAddInfo := param
	endif
	return

METHOD procedure setIshod( param )		CLASS THuman
	::FIshod := param
	return

METHOD procedure setIDSchet( param )		CLASS THuman
	::FIDSchet := param
	return

METHOD procedure setNextVizit( dValue )		CLASS THuman
	::FNextVizit := dValue
	return

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

METHOD procedure setBeginTreatment( dValue )		CLASS THuman
	::FBeginTreatment := dValue
	return

METHOD procedure setEndTreatment( dValue )		CLASS THuman
	::FEndTreatment := dValue
	return
	
METHOD procedure setRegLech( nNum )		CLASS THuman

	if nNum != ::FRegLech
		::FRegLech := nNum
	endif
	return

METHOD procedure setFinanceAreaCode( nNum )		CLASS THuman

	if nNum != ::FFinanceAreaCode
		::FFinanceAreaCode := nNum
	endif
	return

METHOD procedure setMest_Inog( nNum )		CLASS THuman

	if nNum != ::FMest_Inog
		::FMest_Inog := nNum
	endif
	return

METHOD procedure setAreaCodeResidence( nNum )		CLASS THuman

	if nNum != ::FAreaCodeResidence
		::FAreaCodeResidence := nNum
	endif
	return

METHOD procedure setMi_Git( nNum )		CLASS THuman

	if nNum != ::FMi_Git
		::FMi_Git := nNum
	endif
	return

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

METHOD procedure setPolicy( cText )		CLASS THuman

	if alltrim( cText ) != alltrim( ::FPolicy )
		::FPolicy := cText
	endif
	return

METHOD procedure setZa_Smo( nNum )		CLASS THuman

	if nNum != ::FZa_Smo
		::FZa_Smo := nNum
	endif
	return

METHOD procedure setInsuranceID( nNum )		CLASS THuman

	if nNum != ::FInsuranceID
		::FInsuranceID := nNum
	endif
	return

METHOD procedure setKomu( nNum )		CLASS THuman

	if nNum != ::FKomu
		::FKomu := nNum
	endif
	return

METHOD procedure setObrashen( param )		CLASS THuman

	::FObrashen := param
	return

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

METHOD procedure setWorking( nNum )		CLASS THuman

	if nNum != ::FWorking
		::FWorking := nNum
	endif
	return

METHOD procedure setPlaceWork( param )		CLASS THuman

	if alltrim( param ) != alltrim( ::FPlaceWork )
		::FPlaceWork := param
	endif
	return

METHOD procedure setVzros_Reb( param )		CLASS THuman

	if param != ::FVzros_Reb
		::FVzros_Reb := param
	endif
	return

METHOD procedure setAddressReg( param )		CLASS THuman

	::FAddressReg := param
	return

METHOD procedure setDOB( param )		CLASS THuman

	if isdate( param ) .and. param != ::FDOB
		::FDOB := param
	endif
	return

METHOD procedure setGender( param )		CLASS THuman
	local ch := upper( left( param, 1 ) )
	
	if ( ch $ 'МЖмжMFmf' )
		if ch != ::FGender
			::FGender := ch
		endif
	endif
	return

&& METHOD function getFIO1251()		CLASS THuman
	&& return win_OEMToANSI( ::FFIO )

METHOD procedure setFIO( param )		CLASS THuman

	if alltrim( param ) != alltrim( ::FFIO )
		::FFIO := upper( param )
	endif
	return

METHOD procedure setTreatmentCode( param )	CLASS THuman
	::FTreatmentCode := param
	return

METHOD procedure setIDCardFile( param )	CLASS THuman
	::FIDCardFile := param
	return

METHOD procedure setCode( param )	CLASS THuman
	::FCode := param
	return