#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

********************************
// класс описывающий платный договор
CREATE CLASS TContract	INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Patient AS OBJECT READ getPatient WRITE setPatient						// объект пациента
		PROPERTY IDPatient AS NUMERIC READ getIDPatient									// ID объект пациента
		PROPERTY Department READ getDepartment WRITE setDepartment						// объект подразделение, где оказана услуга
		PROPERTY IDDepartment AS NUMERIC READ getIDDepartment							// ID объекта учреждения
		PROPERTY DepartmentShort AS STRING READ getDepartmentShort
		PROPERTY Subdivision READ getSubdivision WRITE setSubdivision					// объект отделение, где оказана услуга
		PROPERTY IDSubdivision AS NUMERIC READ getIDSubdivision							// ID объекта отделения
		PROPERTY SendDoctor READ getSendDoctor WRITE setSendDoctor						// объект направивший доктор
		PROPERTY IDSendDoctor AS NUMERIC READ getIDSendDoctor							// ID объект направивший доктор
		PROPERTY BeginTreatment AS DATE READ getBeginTreatment WRITE setBeginTreatment	// дата начала лечения
		PROPERTY EndTreatment AS DATE READ getEndTreatment WRITE setEndTreatment			// дата окончания лечения
		PROPERTY DateCloseLU AS DATE READ getDateCloseLU WRITE setDateCloseLU				// дата закрытия листа учета
		
		PROPERTY MainDiagnosis AS STRING READ getMainDiagnosis WRITE setMainDiagnosis	// шифр осн.болезни
		PROPERTY Diagnosis1 AS STRING INDEX 1 READ getDiagnosis WRITE setDiagnosis		// шифр 1-ой сопутствующей болезни
		PROPERTY Diagnosis2 AS STRING INDEX 2 READ getDiagnosis WRITE setDiagnosis		// шифр 2-ой сопутствующей болезни
		PROPERTY Diagnosis3 AS STRING INDEX 3 READ getDiagnosis WRITE setDiagnosis		// шифр 3-ой сопутствующей болезни
		PROPERTY Diagnosis4 AS STRING INDEX 4 READ getDiagnosis WRITE setDiagnosis		// шифр 4-ой сопутствующей болезни
		PROPERTY Diagnosis5 AS STRING INDEX 5 READ getDiagnosis WRITE setDiagnosis		// шифр 5-ой сопутствующей болезни
		
		PROPERTY Total AS NUMERIC READ getTotal WRITE setTotal							// стоимость лечения
		PROPERTY TypeService AS NUMERIC READ getTypeService WRITE setTypeService			// 0-платная, 1-д/страх., 2-в/зачет
		
		PROPERTY IdExternalOrg AS NUMERIC READ getIDExternal WRITE setIDExternal			// код предприятия / добровольного СМО
		PROPERTY PolisSMO AS STRING READ getPolisSMO WRITE setPolisSMO					// полис по добровольному страх-ию
		PROPERTY LetterSMO AS STRING INDEX 1 READ getLetterSMO WRITE setLetterSMO		// № гарантийного письма по ДМС
		PROPERTY DateLetterSMO AS DATE INDEX 1 READ getDateLetterSMO WRITE setDateLetterSMO		// дата гарантийного письма по ДМС
		PROPERTY LetterSMO2 AS STRING INDEX 2 READ getLetterSMO WRITE setLetterSMO		// № 2-го гарантийного письма по ДМС
		PROPERTY DateLetterSMO2 AS DATE INDEX 2 READ getDateLetterSMO WRITE setDateLetterSMO	// дата 2-го гарантийного письма по ДМС
		
		PROPERTY PayerFIO AS STRING READ getPayerFIO WRITE setPayerFIO					// ФИО плательщика
		PROPERTY PayerINN AS STRING READ getPayerINN WRITE setPayerINN               	// ИНН плательщика
		PROPERTY EmailPayer AS STRING READ getEmailPayer WRITE setEmailPayer				// электронная почта плательщика

		PROPERTY HasCheque READ getHasCheck
		
		PROPERTY DatePay AS DATE READ getDatePay WRITE setDatePay							// дата оплаты договора
		PROPERTY NumberReceiptBook AS NUMERIC READ getNumberBook WRITE setNumberBook	// номер квитанционной книжки
		PROPERTY ReceiptNumber AS NUMERIC READ getReceiptNumber WRITE setReceiptNumber	// номер чека, квитанции
		
		PROPERTY DateCashbox AS DATE READ getDateCashBox WRITE setDateCashBox				// дата записи
		PROPERTY TimeCashbox AS NUMERIC READ getTimeCashBox WRITE setTimeCashBox			// время записи
		PROPERTY TypeCashbox AS NUMERIC READ getTypeCashBox WRITE setTypeCashBox			// тип кассы
		PROPERTY TypeOfBankCard AS NUMERIC READ getTypeBankCard WRITE setTypeBankCard	// ТИП банковской карты
		PROPERTY TotalBank AS NUMERIC READ getTotalBank WRITE setTotalBank				// сумма, оплаченная по банковской карте
		PROPERTY IsCashbox AS NUMERIC READ getIsCashBox WRITE setISCashBox				// касса(0-без кассы,1-чек,2-нет чека)
		
		PROPERTY DateBackMoney AS DATE READ getDateBackMoney WRITE setDateBackMoney		// дата возврата
		PROPERTY BackMoney AS NUMERIC READ getBackMoney WRITE setBackMoney				// сумма возврата
		PROPERTY DateMoneyBack AS DATE READ getDateMoneyBack WRITE setDateMoneyBack		// возврат дата записи
		PROPERTY TimeMoneyBack AS NUMERIC READ getTimeMoneyBack WRITE setTimeMoneyBack	// возврат время записи
		PROPERTY TypeCashboxMoneyBack AS NUMERIC READ getTypeCashBoxBack WRITE setTypeCashBoxBack	// возврат тип кассы

		PROPERTY SerialNumberFR AS STRING INDEX 1 READ getSN WRITE setSN					// зав.номер кассы
		PROPERTY SerialNumberFRBack AS STRING INDEX 2 READ getSN WRITE setSN				// возврат зав.номер кассы
		
		PROPERTY Cashier INDEX 1 READ getCashier WRITE setCashier						// объект пользователя создавшего договор
		PROPERTY IDCashier AS NUMERIC INDEX 1 READ getIDCashier						// ID объект пользователя создавшего договор
		PROPERTY CashierBack INDEX 2 READ getCashier WRITE setCashier			// объект пользователя сделавшего возврат
		PROPERTY IDCashierBack AS NUMERIC INDEX 2 READ getIDCashier			// объект пользователя сделавшего возврат
		
		PROPERTY FillColumnCheque AS STRING READ getFillColumnCheque
		PROPERTY SendDoctorTabNom AS STRING READ getSendDoctorTabNom

		PROPERTY Total_F AS STRING READ getTotalFormat
		PROPERTY TotalBank_F AS NUMERIC READ getTotalBankFormat
		PROPERTY BackMoney_F AS STRING READ getBackMoneyFormat
		
		METHOD New( nId, lNew, lDeleted )
	
		METHOD Services()
		METHOD AddService( obj )
		METHOD RemoveService( obj )
		METHOD deleteAllServices()
		METHOD Recount()
		METHOD CountShifrServices()
		
		METHOD MaxLenShifr()					// возвращет максимальную длину шифра в списке услуг
		
		METHOD forJSON()
	HIDDEN:
		DATA FPatient		INIT nil
		DATA FIDPatient		INIT 0
		DATA FDepartment	INIT nil
		DATA FIDDepartment	INIT 0
		DATA FSubdivision	INIT nil
		DATA FIDSubdivision	INIT 0
		DATA FSendDoctor	INIT nil
		DATA FIDSendDoctor	INIT 0
		DATA FCashier		INIT nil
		DATA FCashierBack	INIT nil
		DATA FIDCashier		INIT 0
		DATA FIDCashierBack	INIT 0
		DATA FMainDiagnosis	INIT space( 5 )
		DATA FaddDiagnosis1	INIT space( 5 )
		DATA FaddDiagnosis2	INIT space( 5 )
		DATA FaddDiagnosis3	INIT space( 5 )
		DATA FaddDiagnosis4	INIT space( 5 )
		DATA FaddDiagnosis5	INIT space( 5 )
		DATA FNumberBook	INIT 0
		DATA FReceiptNumber	INIT 0
		DATA FBeginTreatment	INIT ctod( '' )
		DATA FEndTreatment	INIT ctod( '' )
		DATA FTotal			INIT 0.0
		DATA FTypeService	INIT 0
		DATA FIDExternal	INIT 0
		DATA FPolisSMO		INIT space( 25 )
		DATA FLetterSMO		INIT space( 16 )
		DATA FDateLetterSMO	INIT ctod( '' )
		DATA FLetterSMO2	INIT space( 16 )
		DATA FDateLetterSMO2	INIT ctod( '' )
		DATA FDatePay		INIT ctod( '' )
		DATA FBackMoney		INIT 0.0
		DATA FDateBackMoney	INIT ctod( '' )
		DATA FTotalBank		INIT 0.0
		DATA FDateCloseLU	INIT ctod( '' )
		DATA FIsCashBox		INIT 0.0
		DATA FPayerFIO		INIT space( 40 )
		DATA FPayerINN		INIT space( 12 )
		DATA FDateCashBox	INIT ctod( '' )
		DATA FTimeCashBox	INIT 0
		DATA FSerialNumber	INIT space( 16 )
		DATA FTypeCashBox	INIT 0
		DATA FDateMoneyBack	INIT ctod( '' )
		DATA FTimeMoneyBack	INIT 0
		DATA FSerialNumberBack	INIT space( 16 )
		DATA FTypeCashBoxBack	INIT 0
		DATA FTypeBankCard	INIT 0
		DATA FEmailPayer	INIT space( 30 )

		METHOD getPatient
		METHOD getIDPatient
		METHOD setPatient( param )
		METHOD getDepartment
		METHOD getIDDepartment
		METHOD setDepartment( param )
		METHOD getSubdivision
		METHOD getIDSubdivision
		METHOD setSubdivision( param )
		METHOD getSendDoctor
		METHOD getIDSendDoctor
		METHOD setSendDoctor( param )
		METHOD getCashier( nIndex )
		METHOD getIDCashier( nIndex )
		METHOD setCashier( nIndex, param )
		METHOD getMainDiagnosis
		METHOD setMainDiagnosis( cValue )
		METHOD getDiagnosis( nIndex )
		METHOD setDiagnosis( nIndex, cVal )
		METHOD getNumberBook
		METHOD setNumberBook( nValue )
		METHOD getReceiptNumber
		METHOD setReceiptNumber( nValue )
		METHOD getHasCheck
		METHOD getBeginTreatment
		METHOD setBeginTreatment( dValue )
		METHOD getEndTreatment
		METHOD setEndTreatment( dValue )
		METHOD getTotal
		METHOD getTotalFormat
		METHOD setTotal( nValue )
		METHOD getTypeService
		METHOD setTypeService( nValue )
		METHOD getIDExternal
		METHOD setIDExternal( nValue )
		METHOD getPolisSMO
		METHOD setPolisSMO( cValue )
		METHOD getLetterSMO( nIndex )
		METHOD setLetterSMO( nIndex, cValue )
		METHOD getDateLetterSMO( nIndex )
		METHOD setDateLetterSMO( nIndex, dValue )
		METHOD getDatePay
		METHOD setDatePay( dValue )
		METHOD getBackMoney
		METHOD getBackMoneyFormat
		METHOD setBackMoney( nValue )
		METHOD getDateBackMoney
		METHOD setDateBackMoney( dValue )
		METHOD getTotalBank
		METHOD getTotalBankFormat
		METHOD setTotalBank( nValue )
		METHOD getDateCloseLU
		METHOD setDateCloseLU( dValue )
		METHOD getIsCashBox
		METHOD setISCashBox( nValue )
		METHOD getPayerFIO
		METHOD setPayerFIO( cValue )
		METHOD getPayerINN
		METHOD setPayerINN( cValue )
		METHOD getDateCashBox
		METHOD setDateCashBox( dValue )
		METHOD getTimeCashBox
		METHOD setTimeCashBox( nValue )
		METHOD getSN( nIndex )
		METHOD setSN( nIndex, param )
		METHOD getTypeCashBox
		METHOD setTypeCashBox( nValue )
		METHOD getDateMoneyBack
		METHOD setDateMoneyBack( dValue )
		METHOD getTimeMoneyBack
		METHOD setTimeMoneyBack( nValue )
		METHOD getTypeCashBoxBack
		METHOD setTypeCashBoxBack( nValue )
		METHOD getTypeBankCard
		METHOD setTypeBankCard( nValue )
		METHOD getEmailPayer
		METHOD setEmailPayer( cValue )
		METHOD getFillColumnCheque
		METHOD getDepartmentShort
		METHOD getSendDoctorTabNom

	PROTECTED:
		VAR _aServices				AS ARRAY		INIT {}			// массив услуг относящихся к договору
ENDCLASS

METHOD function forJSON()    CLASS TContract
	local oRow := nil, obj := nil
	local hItems, hItem, h, i := 0

	h := { => }
	hItems := { => }
	hItem := { => }
	if ::Patient != nil
		hb_HSet( hItem, 'Patient', ::Patient:forJSON() )
	endif
	if ::Department != nil
		hb_HSet( hItem, 'Department', ::Department:forJSON() )
	endif
	if ::Subdivision != nil
		hb_HSet( hItem, 'Subdivision', ::Subdivision:forJSON() )
	endif
	hb_HSet( hItem, 'BeginTreatment', dtoc( ::BeginTreatment ) )
	hb_HSet( hItem, 'EndTreatment', dtoc( ::EndTreatment ) )
	hb_HSet( hItem, 'Total', ltrim( str( ::Total ) ) )
	hb_HSet( hItem, 'TotalBank', ltrim( str( ::TotalBank ) ) )
	hb_HSet( hItem, 'DatePay', dtoc( ::DatePay ) )
	if ::SendDoctor != nil
		hb_HSet( hItem, 'SendDoctor', ::SendDoctor:forJSON() )
	endif
	for each obj in ::Services
		hb_HSet( hItems, ltrim( str( ++i ) ), obj:forJSON() )
	next
	hb_HSet( hItem, 'Services', hItems )
	
	&& MEMOWRIT( 'Department.json' , hb_jsonencode( hItem, .t., 'RU1251' ) )
	return hItem

METHOD function CountShifrServices()				CLASS TContract
	return len(::Services())

METHOD function getDepartmentShort()				CLASS TContract
	
	return if( isnil( ::Department ), space( 5 ), ::Department:ShortName )

METHOD function getSendDoctorTabNom()				CLASS TContract
	
	&& return iif( ::FIDSendDoctor == 0, space( 5 ), put_val( ::FSendDoctor:TabNom, 5 ) )
	return iif( ::FIDSendDoctor == 0, space( 5 ), put_val( ::SendDoctor:TabNom, 5 ) )


METHOD function getFillColumnCheque()				CLASS TContract
	local ret := '    '
	
	if( ::TypeService == PU_PLAT )
		ret := { '    ', str( ::ReceiptNumber, 4 ), '' }[ ::IsCashbox + 1 ]
	elseif( ::TypeService == PU_PR_VZ )
		ret := 'в/з '
	elseif( ::TypeService == PU_D_SMO )
		ret := 'д/с '
	endif
	return ret


METHOD function getPatient() CLASS TContract
	if isnil( ::FPatient )
		::FPatient := if( ::FIDPatient == 0, nil, TPatientDB():GetByID( ::FIDPatient ) )
	endif
	return ::FPatient

METHOD function getIDPatient() CLASS TContract
	return ::FIDPatient

METHOD procedure setPatient( param ) CLASS TContract
	&& if valtype( param ) == 'N'
		&& ::FPatient := TPatientDB():GetByID( param )
	&& elseif valtype( param ) == 'O' .and. param:ClassName() == upper( 'TPatient' )
		&& ::FPatient := param
	&& elseif param == nil
		&& ::FPatient := nil
	&& endif
	if isnumber( param )
		::FIDPatient := param
		::FPatient := nil
	elseif isobject( param ) .and. param:ClassName() == upper( 'TPatient' )
		::FIDPatient := param:ID
		::FPatient := nil
	elseif param == nil
		::FIDPatient := 0
		::FPatient := nil
	endif
	return

METHOD function getDepartment()  CLASS TContract

	if isnil( ::FDepartment )
		::FDepartment := if( ::FIDDepartment == 0, nil, TDepartmentDB():getByID( ::FIDDepartment ) )
	endif
	return ::FDepartment

METHOD function getIDDepartment()				CLASS TContract
	return ::FIDDepartment

METHOD procedure setDepartment( param ) CLASS TContract
	
	&& if valtype( param ) == 'N'
		&& ::FDepartment := TDepartmentDB():getByID( param )
	&& elseif valtype( param ) == 'O' .and. param:ClassName() == upper( 'TDepartment' )
		&& ::FDepartment := param
	&& elseif param == nil
		&& ::FDepartment := nil
	&& endif
	if isnumber( param )
		::FIDDepartment := param
		::FDepartment := nil
	elseif isobject( param ) .and. param:ClassName() == upper( 'TDepartment' )
		::FIDDepartment := param:ID
		::FDepartment := nil
	elseif param == nil
		::FIDDepartment := 0
		::FDepartment := nil
	endif
	return
	
METHOD function getSubdivision()  CLASS TContract
	
	if isnil( ::FSubdivision )
		::FSubdivision := if( ::FIDSubdivision == 0, nil, TSubdivisionDB():getByID( ::FIDSubdivision ) )
	endif
	return ::FSubdivision

METHOD function getIDSubdivision()				CLASS TContract
	return ::FIDSubdivision

METHOD procedure setSubdivision( param ) CLASS TContract
	
	&& if valtype( param ) == 'N'
		&& ::FSubdivision := TSubdivisionDB():getByID( param )
	&& elseif valtype( param ) == 'O' .and. param:ClassName() == upper( 'TSubdivision' )
		&& ::FSubdivision := param
	&& elseif param == nil
		&& ::FSubdivision := nil
	&& endif
	if isnumber( param )
		::FIDSubdivision := param
		::FSubdivision := nil
	elseif isobject( param ) .and. param:ClassName() == upper( 'TSubdivision' )
		::FIDSubdivision := param:ID
		::FSubdivision := nil
	elseif param == nil
		::FSubdivision := nil
		::FIDSubdivision := 0
	endif
	return
	
METHOD function getSendDoctor() CLASS TContract
	
	if isnil( ::FSendDoctor )
		::FSendDoctor := if( ::FIDSendDoctor == 0, nil, TEmployeeDB():GetByID( ::FIDSendDoctor ) )
	endif
	return ::FSendDoctor

METHOD function getIDSendDoctor() CLASS TContract
	
	return ::FIDSendDoctor

METHOD procedure setSendDoctor( param ) CLASS TContract

	&& if valtype( param ) == 'N'
		&& ::FSendDoctor := TEmployeeDB():GetByID( param )
	&& elseif valtype( param ) == 'O' .and. param:ClassName() == upper( 'TEmployee' )
		&& ::FSendDoctor := param
	&& elseif param == nil
		&& ::FSendDoctor := nil
	&& endif
	if isnumber( param )
		::FIDSendDoctor := param
		::FSendDoctor := nil
	elseif isobject( param ) .and. param:ClassName() == upper( 'TEmployee' )
		::FIDSendDoctor := param:ID
		::FSendDoctor := nil
	elseif param == nil
		::FIDSendDoctor := 0
		::FSendDoctor := nil
	endif
	return
	
METHOD function getCashier( nIndex ) CLASS TContract
	local ret
	switch nIndex
		case 1
			if isnil( ::FCashier )
				::FCashier := if( ::IDCashier == 0, nil, TUserDB():GetByID( ::FIDCashier ) )
			endif
			ret := ::FCashier
			exit
		case 2
			if isnil( ::FCashierBack )
				::FCashierBack := if( ::IDCashierBack == 0, nil, TUserDB():GetByID( ::FIDCashierBack ) )
			endif
			ret := ::FCashierBack
			exit
	endswitch
	return ret

METHOD function getIDCashier( nIndex ) CLASS TContract
	local ret
	switch nIndex
		case 1
			ret := ::FIDCashier
			exit
		case 2
			ret := ::FIDCashierBack
			exit
	endswitch
	return ret

METHOD procedure setCashier( nIndex, param ) CLASS TContract
	local tmpObj := nil

	if isnumber( param ) .and. param != 0
		switch nIndex
			case 1
				::FIDCashier := param
				::FCashier := nil
				exit
			case 2
				::FIDCashierBack := param
				::FCashierBack := nil
				exit
		endswitch
		
		&& tmpObj := TUserDB():GetByID( param )
	elseif isobject( param ) .and. param:ClassName() == upper( 'TUser' )
		switch nIndex
			case 1
				::FIDCashier := param:ID
				::FCashier := nil
				exit
			case 2
				::FIDCashierBack := param:ID
				::FCashierBack := nil
				exit
		endswitch
		&& tmpObj := param
	elseif param == nil
		switch nIndex
			case 1
				::FIDCashier := 0
				::FCashier := nil
				exit
			case 2
				::FIDCashierBack := 0
				::FCashierBack := nil
				exit
		endswitch
	endif
	&& switch nIndex
		&& case 1
			&& ::FCashier := tmpObj
			&& exit
		&& case 2
			&& ::FCashierBack := tmpObj
			&& exit
	&& endswitch
	return
	
METHOD function getMainDiagnosis()					CLASS TContract
	return ::FMainDiagnosis

METHOD procedure setMainDiagnosis( cValue )		CLASS TContract
	::FMainDiagnosis := cValue
	return
	
METHOD function getDiagnosis( nIndex ) CLASS TContract
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
		case 5
			ret := ::FaddDiagnosis5
			exit
	endswitch
	return ret

METHOD procedure setDiagnosis( nIndex, cVal ) CLASS TContract
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
		case 5
			::FaddDiagnosis5 := cVal
			exit
	endswitch
	return

METHOD function getNumberBook()					CLASS TContract
	return ::FNumberBook

METHOD procedure setNumberBook( nValue )			CLASS TContract
	::FNumberBook := nValue
	return
	
METHOD function getReceiptNumber()					CLASS TContract
	return ::FReceiptNumber

METHOD procedure setReceiptNumber( nValue )		CLASS TContract
	::FReceiptNumber := nValue
	return
	
METHOD function getHasCheck()						CLASS TContract
	return iif( ::FReceiptNumber != 0, .t., .f. )

METHOD function getBeginTreatment()				CLASS TContract
	return ::FBeginTreatment

METHOD procedure setBeginTreatment( dValue )		CLASS TContract
	::FBeginTreatment := dValue
	return
	
METHOD function getEndTreatment()					CLASS TContract
	return ::FEndTreatment

METHOD procedure setEndTreatment( dValue )		CLASS TContract
	::FEndTreatment := dValue
	return
	
METHOD function getTotal()							CLASS TContract
	return ::FTotal

METHOD function getTotalFormat()							CLASS TContract
	return str( ::FTotal, 8, 2 )

METHOD procedure setTotal( nValue )				CLASS TContract
	::FTotal := nValue
	return
	
METHOD function getTypeService()					CLASS TContract
	return ::FTypeService

METHOD procedure setTypeService( nValue )		CLASS TContract
	::FTypeService := nValue
	return

METHOD function getIDExternal()					CLASS TContract
	return ::FIDExternal

METHOD procedure setIDExternal( nValue )			CLASS TContract
	::FIDExternal := nValue
	return

METHOD function getPolisSMO()						CLASS TContract
	return ::FPolisSMO

METHOD procedure setPolisSMO( cValue )			CLASS TContract
	::FPolisSMO := cValue
	return

METHOD function getLetterSMO( nIndex )			CLASS TContract
	local ret

	switch nIndex
		case 1
			ret := ::FLetterSMO
			exit
		case 2
			ret := ::FLetterSMO2
			exit
	endswitch
	return ret

METHOD procedure setLetterSMO( nIndex, cValue )	CLASS TContract
	switch nIndex
		case 1
			::FLetterSMO := cValue
			exit
		case 2
			::FLetterSMO2 := cValue
			exit
	endswitch
	return

METHOD function getDateLetterSMO( nIndex )		CLASS TContract
	local ret

	switch nIndex
		case 1
			ret := ::FDateLetterSMO
			exit
		case 2
			ret := ::FDateLetterSMO2
			exit
	endswitch
	return ret

METHOD procedure setDateLetterSMO( nIndex, dValue )		CLASS TContract
	switch nIndex
		case 1
			::FDateLetterSMO := dValue
			exit
		case 2
			::FDateLetterSMO2 := dValue
			exit
	endswitch
	return
	return

METHOD function getDatePay()						CLASS TContract
	return ::FDatePay

METHOD procedure setDatePay( dValue )			CLASS TContract
	::FDatePay := dValue
	return

METHOD function getBackMoney()						CLASS TContract
	return ::FBackMoney

METHOD function getBackMoneyFormat()						CLASS TContract
	return str( ::FBackMoney, 8, 2 )

METHOD procedure setBackMoney( nValue )			CLASS TContract
	::FBackMoney := nValue
	return

METHOD function getDateBackMoney()					CLASS TContract
	return ::FDateBackMoney

METHOD procedure setDateBackMoney( dValue )		CLASS TContract
	::FDateBackMoney := dValue
	return

METHOD function getTotalBank()						CLASS TContract
	return ::FTotalBank

METHOD function getTotalBankFormat					CLASS TContract
	return iif( ::FTotalBank > 0, 'Б', ' ' )

METHOD procedure setTotalBank( nValue )			CLASS TContract
	::FTotalBank := nValue
	return

METHOD function getDateCloseLU()					CLASS TContract
	return ::FDateCloseLU

METHOD procedure setDateCloseLU( dValue )		CLASS TContract
	::FDateCloseLU := dValue
	return

METHOD function getIsCashBox()						CLASS TContract
	return ::FIsCashBox

METHOD procedure setISCashBox( nValue )			CLASS TContract
	::FIsCashBox := nValue
	return

METHOD function getPayerFIO()						CLASS TContract
	return ::FPayerFIO

METHOD procedure setPayerFIO( cValue )			CLASS TContract
	::FPayerFIO := cValue
	return

METHOD function getPayerINN()						CLASS TContract
	return ::FPayerINN

METHOD procedure setPayerINN( cValue )			CLASS TContract
	::FPayerINN := cValue
	return

METHOD function getDateCashBox()					CLASS TContract
	return ::FDateCashBox

METHOD procedure setDateCashBox( dValue )		CLASS TContract
	::FDateCashBox := dValue
	return

METHOD function getTimeCashBox()					CLASS TContract
	return ::FTimeCashBox

METHOD procedure setTimeCashBox( nValue )		CLASS TContract
	::FTimeCashBox := nValue
	return

METHOD function getSN( nIndex )					CLASS TContract
	local ret := space( 16 )
	if nIndex == 1
		ret := ::FSerialNumber
	elseif nIndex == 2
		ret := ::FSerialNumberBack
	endif
	return ret

METHOD procedure setSN( nIndex, param )		CLASS TContract
	if nIndex == 1
		::FSerialNumber := param
	elseif nIndex == 2
		::FSerialNumberBack := param
	endif
	return

METHOD function getTypeCashBox()					CLASS TContract
	return ::FTypeCashBox

METHOD procedure setTypeCashBox( nValue )		CLASS TContract
	::FTypeCashBox := nValue
	return

METHOD function getDateMoneyBack()					CLASS TContract
	return ::FDateMoneyBack

METHOD procedure setDateMoneyBack( dValue )		CLASS TContract
	::FDateMoneyBack := dValue
	return

METHOD function getTimeMoneyBack()					CLASS TContract
	return ::FTimeMoneyBack

METHOD procedure setTimeMoneyBack( nValue )		CLASS TContract
	::FTimeMoneyBack := nValue
	return

METHOD function getTypeCashBoxBack()				CLASS TContract
	return ::FTypeCashBoxBack

METHOD procedure setTypeCashBoxBack( nValue )	CLASS TContract
	::FTypeCashBoxBack := nValue
	return

METHOD function getTypeBankCard()					CLASS TContract
	return ::FTypeBankCard

METHOD procedure setTypeBankCard( nValue )		CLASS TContract
	::FTypeBankCard := nValue
	return

METHOD function getEmailPayer()					CLASS TContract
	return ::FEmailPayer

METHOD procedure setEmailPayer( cValue )			CLASS TContract
	::FEmailPayer := cValue
	return

************************************
METHOD Recount() CLASS TContract
	local oRow := nil
	
	::FTotal := 0
	for each oRow in ::Services()
		::FTotal := ::FTotal + oRow:Total
	next
	return nil

* 24.10.18 добавить услугу в договор
METHOD AddService( oService ) CLASS TContract
	local ret := .f.

	if ( ! isnil( oService ) ) .and. isobject( oService ) .and. oService:ClassName() == upper( 'TContractService' )
		if TContractServiceDB():Save( oService ) != -1
			::Services()
			aadd( ::_aServices, oService )
			ret := .t.
		endif
	endif
	::Recount()
	return ret

* 24.10.18 удалить услугу из договора
METHOD RemoveService( oService ) CLASS TContract
	local ret := .f.
	local nId := 0
	local item
	local i := 0

	if ( !isnil( oService ) ) .and. isobject( oService ) .and. oService:ClassName() == upper( 'TContractService' )
		nId := oService:ID()
		::Services()
		if TContractServiceDB():Delete( oService )
			for each item in ::_aServices
				i++
				if item:ID() == nId
					hb_ADel( ::_aServices, i, .t. )
					exit
				endif
			next
			ret := .t.
		endif
	endif
	::Recount()
	return ret
	
METHOD Services() CLASS TContract

	if empty( ::_aServices )
		::_aServices := TContractServiceDB():getListServices( ::ID )
	endif
	return ::_aServices

METHOD MaxLenShifr() CLASS TContract
	local oRow := nil
	local ret := 0, tmp := ''
	
	if empty( ::_aServices )
		::_aServices := TContractServiceDB():getListServices( ::ID )
	endif
	for each oRow in ::_aServices
		tmp := len(alltrim(oRow:Service( , .t. ):Shifr()))
		if ret < tmp
			ret := tmp
		endif
	next
	return ret
	
METHOD deleteAllServices() CLASS TContract
	local oService := nil

	for each oService in TContractServiceDB():getListServices( ::ID )
		TContractServiceDB():Delete( oService )
	next
	return nil
	
METHOD New( nId, lNew, lDeleted ) CLASS TContract
			
	::super:new( nID, lNew, lDeleted )
	return self