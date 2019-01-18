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
		PROPERTY Address AS STRING READ getAddress WRITE setAddress										// адрес регистрации
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
		
		METHOD New( nID, lNew, lDeleted )
		
		
	HIDDEN:
		DATA FCode INIT 0
		DATA FIDCardFile INIT 0
		DATA FTreatmentCode INIT 0
		DATA FFIO INIT space( 50 )
		DATA FGender INIT 'М'
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
	
	if ( ch $ 'МЖмжMFmf' )
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