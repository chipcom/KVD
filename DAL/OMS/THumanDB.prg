#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'

CREATE CLASS THumanDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oHuman )
		METHOD getByID ( nID )
		METHOD getListCaseNotReestrbyPatient( param )
		METHOD HasSubdivision( param )				// определить используется ли отделение в расчетах
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS THumanDB
	return self

METHOD function getListCaseNotReestrbyPatient( param, _Human_kod )
	local aReturn := {}
	local cOldArea
	local cAlias
	local cFind := ''
	local nIdPatient := 0
	local obj
	
	DEFAULT _Human_kod TO 0
	if isnumber( param ) .and. param != 0
		cFind := str( param, 7 )
		nIdPatient := param
	elseif isobject( param ) .and. param:ClassName() == upper( 'TPatient' )
		cFind := str( param:ID, 7 )
		nIdPatient := param:ID
	else
		return ret
	endif
	
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 2 ))
		if (cAlias)->(dbSeek( cFind ))
			do while (cAlias)->kod_k == nIdPatient .and. !(cAlias)->(eof())
				if !empty( hArray := ::super:currentRecord() )
					obj := ::FillFromHash( hArray )
					if emptyall( obj:Schet, obj:human_:Reestr ) .and. _Human_kod != obj:ID
						aadd( aReturn, obj:ID )
					endif
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aReturn

METHOD function HasSubdivision ( param )		 CLASS THumanDB
	local nSub := 0, i := 0
	local cOldArea
	local cAlias
	local cFind, ret := .f.
	
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
		(cAlias)->(dbSetOrder( 3 ))
		for i := 0 to 9
			// получим строку поиска
			find ( str( i, 1 ) + str( nSub, 3 ) )
			if found()
				ret := .t.
				exit
			endif
		next
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD function getByID ( nID )		 CLASS THumanDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( oHuman ) CLASS THumanDB
	local ret := .f.
	local aHash := nil

// доработать	
	if upper( oHuman:classname() ) == upper( 'THuman' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD_K', oHuman:IDCardFile )
		hb_hSet(aHash, 'TIP_H', oHuman:TreatmentCode )
		hb_hSet(aHash, 'FIO', oHuman:FIO )
		hb_hSet(aHash, 'POL', oHuman:Gender )
		hb_hSet(aHash, 'DATE_R', oHuman:DOB )
		hb_hSet(aHash, 'VZROS_REB', oHuman:Vzros_Reb )
		hb_hSet(aHash, 'ADRES', oHuman:AddressReg )
		hb_hSet(aHash, 'MR_DOL', oHuman:PlaceWork )
		hb_hSet(aHash, 'RAB_NERAB', oHuman:Working )
		hb_hSet(aHash, 'KOD_DIAG', oHuman:MainDiagnosis )
		hb_hSet(aHash, 'KOD_DIAG2', oHuman:MainDiagnosis2 )
		hb_hSet(aHash, 'KOD_DIAG3', oHuman:MainDiagnosis3 )
		hb_hSet(aHash, 'KOD_DIAG4', oHuman:MainDiagnosis4 )
		hb_hSet(aHash, 'SOPUT_B1', oHuman:Diagnosis1 )
		hb_hSet(aHash, 'SOPUT_B2', oHuman:Diagnosis2 )
		hb_hSet(aHash, 'SOPUT_B3', oHuman:Diagnosis3 )
		hb_hSet(aHash, 'SOPUT_B4', oHuman:Diagnosis4 )
		hb_hSet(aHash, 'DIAG_PLUS', oHuman:DiagnosisPlus )
		hb_hSet(aHash, 'OBRASHEN', oHuman:Obrashen )
		hb_hSet(aHash, 'KOMU', oHuman:Komu )
		hb_hSet(aHash, 'STR_CRB', oHuman:InsurenceID )
		hb_hSet(aHash, 'ZA_SMO', oHuman:Za_Smo )
		hb_hSet(aHash, 'POLIS', oHuman:Policy )
		hb_hSet(aHash, 'LPU', oHuman:Deaprtment )
		hb_hSet(aHash, 'OTD', oHuman:Subdivision )
		hb_hSet(aHash, 'UCH_DOC', oHuman:UchDoc )
		hb_hSet(aHash, 'MI_GIT', oHuman:Mi_Git )
		hb_hSet(aHash, 'RAJON_GIT', oHuman:AreaCodeResidence )
		hb_hSet(aHash, 'MEST_INOG', oHuman:Mest_Inog )
		hb_hSet(aHash, 'RAJON', oHuman:FinanceAreaCode )
		hb_hSet(aHash, 'REG_LECH', oHuman:RegLech )
		hb_hSet(aHash, 'N_DATA', oHuman:BeginTreatment )
		hb_hSet(aHash, 'K_DATA', oHuman:EndTreatment )
		hb_hSet(aHash, 'CENA', oHuman:Total )
		hb_hSet(aHash, 'CENA_1', oHuman:Total_1 )
		hb_hSet(aHash, 'BOLNICH', oHuman:DisabilitySheet )
		
		hb_hSet(aHash, 'DATE_B_1', dtoc4( oHuman:BeginDisabilitySheet ) )
		hb_hSet(aHash, 'DATE_B_2', dtoc4( oHuman:EndDisabilitySheet ) )
		hb_hSet(aHash, 'DATE_E', dtoc4( oHuman:DateAddLU ) )
		hb_hSet(aHash, 'KOD_P', chr( oHuman:IDUser ) )
		hb_hSet(aHash, 'DATE_OPL', dtoc4( oHuman:NextVizit ) )
		hb_hSet(aHash, 'SCHET', oHuman:Schet )
		hb_hSet(aHash, 'ISHOD', oHuman:Ishod )

		hb_hSet(aHash, 'ID',			oHuman:ID )
		hb_hSet(aHash, 'REC_NEW',		oHuman:IsNew )
		hb_hSet(aHash, 'DELETED',		oHuman:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oHuman:ID := ret
			oHuman:IsNew := .f.
			// сохраним зависимые объекты
			if ! isnil( oHuman:ExtendInfo )
				THumanExtDB():Save( oHuman:ExtendInfo )
			endif
			if ! isnil( oHuman:AddInfo )
				THumanAddDB():Save( oHuman:AddInfo )
			endif
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS THumanDB
	local obj
	
	obj := THuman():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:Code := hbArray[ 'KOD' ]
	obj:IDCardFile := hbArray[ 'KOD_K' ]
	obj:TreatmentCode := hbArray[ 'TIP_H' ]
	obj:FIO := hbArray[ 'FIO' ]
	obj:Gender := hbArray[ 'POL' ]
	obj:DOB := hbArray[ 'DATE_R' ]
	obj:Vzros_Reb := hbArray[ 'VZROS_REB' ]
	obj:AddressReg := hbArray[ 'ADRES' ]    
	obj:PlaceWork := hbArray[ 'MR_DOL' ]
	obj:Working := hbArray[ 'RAB_NERAB' ]
	obj:MainDiagnosis := hbArray[ 'KOD_DIAG' ]
	obj:MainDiagnosis2 := hbArray[ 'KOD_DIAG2' ]
	obj:MainDiagnosis3 := hbArray[ 'KOD_DIAG3' ]
	obj:MainDiagnosis4 := hbArray[ 'KOD_DIAG4' ]
	obj:Diagnosis1 := hbArray[ 'SOPUT_B1' ]
	obj:Diagnosis2 := hbArray[ 'SOPUT_B2' ]
	obj:Diagnosis3 := hbArray[ 'SOPUT_B3' ]
	obj:Diagnosis4 := hbArray[ 'SOPUT_B4' ]
	obj:DiagnosisPlus := hbArray[ 'DIAG_PLUS' ]
	obj:Obrashen := hbArray[ 'OBRASHEN' ]
	obj:Komu := hbArray[ 'KOMU' ]
	obj:InsurenceID := hbArray[ 'STR_CRB' ]
	obj:Za_Smo := hbArray[ 'ZA_SMO' ]
	obj:Policy := hbArray[ 'POLIS' ]
	obj:Deaprtment := hbArray[ 'LPU' ]
	obj:Subdivision := hbArray[ 'OTD' ]
	obj:UchDoc := hbArray[ 'UCH_DOC' ]  
	obj:Mi_Git := hbArray[ 'MI_GIT' ]
	obj:AreaCodeResidence := hbArray[ 'RAJON_GIT' ]
	obj:Mest_Inog := hbArray[ 'MEST_INOG' ]
	obj:FinanceAreaCode := hbArray[ 'RAJON' ]
	obj:RegLech := hbArray[ 'REG_LECH' ]
	obj:BeginTreatment := hbArray[ 'N_DATA' ]
	obj:EndTreatment := hbArray[ 'K_DATA' ]
	obj:Total := hbArray[ 'CENA' ]
	obj:Total_1 := hbArray[ 'CENA_1' ]
	obj:DisabilitySheet := hbArray[ 'BOLNICH' ]
	
	obj:BeginDisabilitySheet := c4tod( hbArray[ 'DATE_B_1' ] )
	obj:EndDisabilitySheet := c4tod( hbArray[ 'DATE_B_2' ] )
	obj:DateAddLU := c4tod( hbArray[ 'DATE_E' ] )
	obj:User := asc( hbArray[ 'KOD_P' ] )
	obj:NextVizit := c4tod( hbArray[ 'DATE_OPL' ] )
	obj:Schet := hbArray[ 'SCHET' ]
	obj:Ishod := hbArray[ 'ISHOD' ]
	return obj