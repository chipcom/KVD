#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'
#include 'edit_spr.ch'

********************************
// класс для строки платного договора файл hum_p.dbf
CREATE CLASS TContractDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oContract )
		
		METHOD GetByID( nID )
		METHOD GetListByPatient( nIdPatient, oUser )
		METHOD GetListBySubdivision( nIdSubdivision )
		METHOD GetListByDate( beginDate, endDate )	// получить список договоров в периоде дат
		METHOD GetListByTypeAndIDPayer( nType, nIdOrg )
		METHOD getListByCondition( aHash )
		METHOD getListContractByDateService( date1, date2 )	// получить список контрактов услуги которых оказаны в промежутке дат date1 и date2
		METHOD getListContractByEndTreatment( date1, date2 )	// получить список контрактов дата окончания которых промежутке дат date1 и date2
		METHOD getListContractByDateCloseLU( date1, date2 )	// получить список контрактов дата закрытия листа учета которых промежутке дат date1 и date2
		METHOD getListContractByDatePayment( date1, date2, oUser )	// получить список контрактов по дате оплаты которых в промежутке дат date1 и date2
		METHOD getListContractByDateRefund( date1, date2, oUser )	// получить список контрактов по дате, возврат оплаты которых в промежутке дат date1 и date2
		METHOD getListContractByDateWithoutCheck( date1, date2, user )	// получить список контрактов без чеков оплаты по дате, возврат оплаты которых в промежутке дат date1 и date2
		METHOD getResultWorkShift( date1, numberFR )					// получить результат работы за смену по конкретной ККТ на дату
		METHOD HasSubdivision( param )								// определить используется ли отделение в расчетах
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TContractDB
	return self
	
METHOD GetByID( nID )    CLASS TContractDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !Empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD GetListByPatient( nIdPatient, oUser )    CLASS TContractDB
	local hArray := nil, obj
	local cOldArea
	local cAlias
	local aContract := {}
	local cFind, lFlag := .f.
		
	hb_default( oUser, nil )
	
	if nIdPatient == 0
		return aContract
	endif
	// получим строку поиска
	cFind := STR( nIdPatient, 7 )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 1 ))
//		(cAlias)->(ordSetFocus( 1 ))
		if (cAlias)->(dbSeek(cFind))
			do while (cAlias)->kod_k == nIdPatient .and. !(cAlias)->(eof())
				if !empty( hArray := ::super:currentRecord() )
					obj := ::FillFromHash( hArray )
					If oUser != nil
						lFlag := oUser:IsAllowedDepartment( obj:Department():ID )
					EndIf
					If lFlag
						aadd( aContract, obj )
					endif
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContract

METHOD GetListByDate( beginDate, endDate )    CLASS TContractDB
	local hArray := nil
	local cOldArea
	local cAlias
	local aContract := {}
	local cFind
		
	// получим строку поиска
	cFind := dtos( beginDate )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 3 ))
		if (cAlias)->(dbSeek(cFind, .t.))
			do while (cAlias)->k_data <= endDate .and. !(cAlias)->(eof())
				if ! empty( hArray := ::super:currentRecord() )
					aadd( aContract, ::FillFromHash( hArray ) )
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContract

METHOD getListContractByEndTreatment( date1, date2 )			CLASS TContractDB
	local cOldArea
	local cAlias, cFind
	local aContracts := {}
	
	// получим строку поиска
	cFind := dtos( date1 )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 3 ))
		if (cAlias)->(dbSeek(cFind))
			do while ! (cAlias)->(eof()) .and. (cAlias)->K_DATA >= date1 .and. (cAlias)->K_DATA <= date2
				if !empty( hArray := ::super:currentRecord() )
					aadd( aContracts, ::FillFromHash( hArray ) )
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContracts

METHOD function getResultWorkShift( date1, numberFR )						CLASS TContractDB
	local cOldArea
	local cAlias
	local dateReport := dtoc4( date1 )
	local tmpNumberFR := padr( numberFR, 16 )
	local totalCash := 0, totalRefund := 0, totalPaid := 0
	
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if ( padr( (cAlias)->FR_ZAVOD, 16 ) == tmpNumberFR ) .or. ( padr( (cAlias)->VZFR_ZAVOD, 16 ) == tmpNumberFR )
				if (cAlias)->IS_KAS == 1 .and. equalany( dateReport, (cAlias)->PDATE, (cAlias)->DATE_VOZ )
					if dateReport == (cAlias)->PDATE
						totalCash += (cAlias)->CENA - (cAlias)->SBANK
						totalPaid += (cAlias)->CENA
					EndIf
					if dateReport == (cAlias)->DATE_VOZ
						totalCash -= (cAlias)->SUM_VOZ
						totalRefund += (cAlias)->SUM_VOZ
					endif
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return { totalPaid, totalCash, totalRefund }

METHOD getListContractByDateWithoutCheck( date1, date2, user )			CLASS TContractDB
	local cOldArea
	local cAlias, item
	local aContracts := {}
	local idUser := 0, isAdmin := .f.

	if isobject( user )
		idUser := user:ID
		isAdmin := user:IsAdmin()
	else
		idUser := user
		isAdmin := TUserDB():getByID(user):IsAdmin()
	endif
	&& date1 := iif( isdate( date1 ), dtoc4( date1 ), date1 )
	&& date2 := iif( isdate( date2 ), dtoc4( date2 ), date2 )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if idUser == (cAlias)->KOD_OPER .or. isAdmin
				if (cAlias)->IS_KAS == 2 .and. between( (cAlias)->N_DATA, date1, date2 )
					if ! empty( hArray := ::super:currentRecord() )
						aadd( aContracts, ::FillFromHash( hArray ) )
					endif
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContracts

METHOD getListContractByDateRefund( date1, date2, user )			CLASS TContractDB
	local cOldArea
	local cAlias, item
	local aContracts := {}
	local idUser := 0, isAdmin := .f.

	if isobject( user )
		idUser := user:ID
		isAdmin := user:IsAdmin()
	else
		idUser := user
		isAdmin := TUserDB():getByID(user):IsAdmin()
	endif
	date1 := iif( isdate( date1 ), dtoc4( date1 ), date1 )
	date2 := iif( isdate( date2 ), dtoc4( date2 ), date2 )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if idUser == (cAlias)->KOD_OPER .or. isAdmin
				if ! empty( (cAlias)->FR_DATA ) .and. between( (cAlias)->FR_DATA, date1, date2 )
					if ! empty( hArray := ::super:currentRecord() )
						aadd( aContracts, ::FillFromHash( hArray ) )
					endif
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContracts

METHOD getListContractByDatePayment( date1, date2, user )			CLASS TContractDB
	local cOldArea
	local cAlias, item
	local aContracts := {}
	local idUser := 0, isAdmin := .f.

	if isobject( user )
		idUser := user:ID
		isAdmin := user:IsAdmin()
	else
		idUser := user
		isAdmin := TUserDB():getByID(user):IsAdmin()
	endif
	date1 := iif( isdate( date1 ), dtoc4( date1 ), date1 )
	date2 := iif( isdate( date2 ), dtoc4( date2 ), date2 )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if idUser == (cAlias)->VZKOD_OPER .or. isAdmin
				if ! empty( (cAlias)->SUM_VOZ ) .and. between( (cAlias)->VZFR_DATA, date1, date2 )
					if ! empty( hArray := ::super:currentRecord() )
						aadd( aContracts, ::FillFromHash( hArray ) )
					endif
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContracts

METHOD getListContractByDateCloseLU( date1, date2 )			CLASS TContractDB
	local cOldArea
	local cAlias, item
	local aContracts := {}
	
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while  !(cAlias)->( eof() ) .and. (cAlias)->DATE_CLOSE >= date1 .and. (cAlias)->DATE_CLOSE <= date2
			if !empty( hArray := ::super:currentRecord() )
				aadd( aContracts, ::FillFromHash( hArray ) )
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContracts

METHOD getListContractByDateService( date1, date2 )			CLASS TContractDB
	local aContractID := {}
	local cOldArea
	local cAlias, item
	local aContracts := {}

	aContractID := TContractServiceDB():getListContractIDByDateService( date1, date2 )
	if len( aContractID ) != 0
	
		cOldArea := Select( )
		if ::super:RUse()
			cAlias := Select( )
			for each item in aContractID
				(cAlias)->( dbGoto( item ) )
				if ! empty( hArray := ::super:currentRecord() )
					aadd( aContracts, ::FillFromHash( hArray ) )
				endif
			next
			(cAlias)->( dbCloseArea() )
			dbSelectArea( cOldArea )
		endif
	endif
	return aContracts
	
METHOD HasSubdivision( param )    CLASS TContractDB
	local cOldArea
	local cAlias
	local ret := .f., nSub := 0
		
	if isnumber( param ) .and. param != 0
		 nSub := param
	elseif isobject( param ) .and. param:ClassName() == upper( 'TSubdivision' )
		nSub := param:ID
	else
		return ret
	endif
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 2 ))
		
		find ( str( nSub, 3 ) )
		if found()
			ret := .t.
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD GetListBySubdivision( nIdSubdivision )    CLASS TContractDB
	local hArray := nil
	local cOldArea
	local cAlias
	local aContract := {}
	local cFind
		
	if nIdSubdivision == 0
		return aContract
	endif
	// получим строку поиска
	cFind := STR( nIdSubdivision, 3 )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 2 ))
		if (cAlias)->(dbSeek(cFind))
			do while (cAlias)->otd == nIdSubdivision .and. !(cAlias)->(eof())
				if !empty( hArray := ::super:currentRecord() )
					aadd( aContract, ::FillFromHash( hArray ) )
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContract

METHOD GetListByTypeAndIDPayer( nType, nIdOrg )    CLASS TContractDB
	local hArray := nil
	local cOldArea
	local cAlias
	local aContract := {}
		
	if nType == 0
		return aContract
	endif
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while !(cAlias)->( eof() )
			if (cAlias)->TIP_USL == nType .and. (cAlias)->PR_SMO == nIdOrg
				if !empty( hArray := ::super:currentRecord() )
					aadd( aContract, ::FillFromHash( hArray ) )
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContract

METHOD getListByCondition( aHash )    CLASS TContractDB
	local hArray := nil
	local cOldArea
	local cAlias
	local aContract := {}
		
	// получим строку поиска
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while !(cAlias)->( eof() )
		
			if aHash[ 'SELECTEDPERIOD' ][ 5 ] <= (cAlias)->N_DATA .and. (cAlias)->n_data <= aHash[ 'SELECTEDPERIOD' ][ 6 ] .and. ;
					ascan( aHash[ 'PAYMENTMETHODS' ], (cAlias)->tip_usl ) > 0 ;//08.05.17
					.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], (cAlias)->lpu ), ;
					IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], (cAlias)->otd ) )//08.05.17
				if !empty( hArray := ::super:currentRecord() )
					aadd( aContract, ::FillFromHash( hArray ) )
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContract

METHOD Save( oContract ) CLASS TContractDB
	local ret := -1, obj
	local aHash := nil
	
	if upper( oContract:classname() ) == upper( 'TContract' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD_K',		oContract:IDPatient )		//if( isnil( oContract:Patient ), 0, oContract:Patient:ID ) )
		hb_hSet(aHash, 'N_KVIT',	oContract:NumberReceiptBook )
		hb_hSet(aHash, 'KV_CIA',	oContract:ReceiptNumber )
		hb_hSet(aHash, 'KOD_DIAG',	oContract:MainDiagnosis )
		hb_hSet(aHash, 'SOPUT_B1',	oContract:Diagnosis1 )
		hb_hSet(aHash, 'SOPUT_B2',	oContract:Diagnosis2 )
		hb_hSet(aHash, 'SOPUT_B3',	oContract:Diagnosis3 )
		hb_hSet(aHash, 'SOPUT_B4',	oContract:Diagnosis4 )
		hb_hSet(aHash, 'SOPUT_B5',	oContract:Diagnosis5 )
		hb_hSet(aHash, 'LPU',		oContract:IDDepartment )  //if( isnil( oContract:Department ), 0, oContract:Department:ID ) )
		hb_hSet(aHash, 'OTD',		oContract:IDSubdivision ) //if( isnil( oContract:Subdivision ), 0, oContract:Subdivision:ID ) )
		hb_hSet(aHash, 'N_DATA',	oContract:BeginTreatment )
		hb_hSet(aHash, 'K_DATA',	oContract:EndTreatment )
		hb_hSet(aHash, 'KOD_VR',	oContract:IDSendDoctor ) //if( isnil( oContract:SendDoctor ), 0, oContract:SendDoctor:ID ) )
		hb_hSet(aHash, 'CENA',		oContract:Total )
		hb_hSet(aHash, 'TIP_USL',	oContract:TypeService )
		hb_hSet(aHash, 'PR_SMO',	oContract:IDExternalOrg )
		hb_hSet(aHash, 'D_POLIS',	oContract:PolisSMO )
		hb_hSet(aHash, 'GP_NOMER',	oContract:LetterSMO )
		hb_hSet(aHash, 'GP_DATE',	oContract:DateLetterSMO )
		hb_hSet(aHash, 'GP2NOMER',	oContract:LetterSMO2 )
		hb_hSet(aHash, 'GP2DATE',	oContract:DateLetterSMO2 )
		hb_hSet(aHash, 'PDATE',		dtoc4( oContract:DatePay ) )
		hb_hSet(aHash, 'DATE_VOZ',	dtoc4( oContract:DateBackMoney ) )
		hb_hSet(aHash, 'SUM_VOZ',	oContract:BackMoney )
		hb_hSet(aHash, 'SBANK',		oContract:TotalBank )
		hb_hSet(aHash, 'DATE_CLOSE',oContract:DateCloseLU )
		hb_hSet(aHash, 'IS_KAS',	oContract:IsCashBox )
		hb_hSet(aHash, 'PLAT_FIO',	oContract:PayerFIO )
		hb_hSet(aHash, 'PLAT_INN',	oContract:PayerINN )

		hb_hSet(aHash, 'FR_DATA',	dtoc4( oContract:DateCashBox ) )
		hb_hSet(aHash, 'FR_TIME',	oContract:TimeCashBox )
		hb_hSet(aHash, 'KOD_OPER',	oContract:IDCashier ) //if( isnil( oContract:Cashier ), 0, oContract:Cashier:ID ) )
		hb_hSet(aHash, 'FR_ZAVOD',	oContract:SerialNumberFR )
		hb_hSet(aHash, 'FR_TIP',	oContract:TypeCashBox )
		hb_hSet(aHash, 'VZFR_DATA', dtoc4( oContract:DateMoneyBack ) )
		hb_hSet(aHash, 'VZFR_TIME', oContract:TimeMoneyBack )
		hb_hSet(aHash, 'VZKOD_OPER',oContract:IDCashierBack ) //if( isnil( oContract:CashierBack ), 0, oContract:CashierBack:ID ) )

		hb_hSet(aHash, 'VZFR_ZAVOD',oContract:SerialNumberFRBack )
		hb_hSet(aHash, 'VZFR_TIP',  oContract:TypeCashboxMoneyBack )
		hb_hSet(aHash, 'FR_TIPKART',oContract:TypeOfBankCard )
		hb_hSet(aHash, 'I_POST',    oContract:EmailPayer )
		hb_hSet(aHash, 'ID',		oContract:ID )
		hb_hSet(aHash, 'REC_NEW',	oContract:IsNew )
		hb_hSet(aHash, 'DELETED',	oContract:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oContract:ID := ret
			oContract:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TContractDB
	local obj
	
	obj := TContract():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Patient := hbArray[ 'KOD_K' ]
	obj:NumberReceiptBook := hbArray[ 'N_KVIT' ]
	obj:ReceiptNumber := hbArray[ 'KV_CIA' ]
	obj:MainDiagnosis := hbArray[ 'KOD_DIAG' ]
	obj:Diagnosis1 := hbArray[ 'SOPUT_B1' ]
	obj:Diagnosis2 := hbArray[ 'SOPUT_B2' ]
	obj:Diagnosis3 := hbArray[ 'SOPUT_B3' ]
	obj:Diagnosis4 := hbArray[ 'SOPUT_B4' ]
	obj:Diagnosis5 := hbArray[ 'SOPUT_B5' ]
	obj:Department := hbArray[ 'LPU' ]
	obj:Subdivision := hbArray[ 'OTD' ]
	obj:BeginTreatment := hbArray[ 'N_DATA' ]
	obj:EndTreatment := hbArray[ 'K_DATA' ]
	obj:SendDoctor := hbArray[ 'KOD_VR' ]
	obj:Total := hbArray[ 'CENA' ]
	obj:TypeService := hbArray[ 'TIP_USL' ]
	obj:IdExternalOrg := hbArray[ 'PR_SMO' ]
	obj:PolisSMO := hbArray[ 'D_POLIS' ]
	obj:LetterSMO := hbArray[ 'GP_NOMER' ]
	obj:DateLetterSMO := hbArray[ 'GP_DATE' ]
	obj:LetterSMO2 := hbArray[ 'GP2NOMER' ]
	obj:DateLetterSMO2 := hbArray[ 'GP2DATE' ]
	obj:DatePay := c4tod( hbArray[ 'PDATE' ] )
	obj:DateBackMoney := c4tod( hbArray[ 'DATE_VOZ' ] )
	obj:BackMoney := hbArray[ 'SUM_VOZ' ]
	obj:TotalBank := hbArray[ 'SBANK' ]
	obj:DateCloseLU := hbArray[ 'DATE_CLOSE' ]
	obj:IsCashbox := hbArray[ 'IS_KAS' ]
	obj:PayerFIO := hbArray[ 'PLAT_FIO' ]
	obj:PayerINN := hbArray[ 'PLAT_INN' ]
	obj:DateCashbox := c4tod( hbArray[ 'FR_DATA' ] )
	obj:TimeCashbox := hbArray[ 'FR_TIME' ]
	obj:Cashier := hbArray[ 'KOD_OPER' ]
	obj:SerialNumberFR := hbArray[ 'FR_ZAVOD' ]
	obj:TypeCashbox := hbArray[ 'FR_TIP' ]
	obj:DateMoneyBack := c4tod( hbArray[ 'VZFR_DATA' ] )
	obj:TimeMoneyBack := hbArray[ 'VZFR_TIME' ]
	obj:CashierBack := hbArray[ 'VZKOD_OPER' ]
	obj:SerialNumberFRBack := hbArray[ 'VZFR_ZAVOD' ]
	obj:TypeCashboxMoneyBack := hbArray[ 'VZFR_TIP' ]
	obj:TypeOfBankCard := hbArray[ 'FR_TIPKART' ]
	obj:EmailPayer := hbArray[ 'I_POST' ]
	return obj