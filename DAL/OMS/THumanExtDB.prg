#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS THumanExtDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( param )
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS THumanExtDB
	return self

METHOD function getByID ( nID )		 CLASS THumanExtDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( param ) CLASS THumanExtDB
	local ret := .f.
	local aHash := nil

	// разобраться как лучше
	if isobject( param ) .and. ( upper( param:classname() ) == upper( 'THuman' ) )
		param := param:ExtendInfo
	endif

// доработать	
	if upper( param:classname() ) == upper( 'THumanExt' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )

		hb_hSet(aHash, 'DISPANS',	param:Dispans )
		hb_hSet(aHash, 'STATUS_ST',	param:StatusST )
		hb_hSet(aHash, 'POVOD',		param:Povod )
		hb_hSet(aHash, 'TRAVMA',	param:Travma )
		hb_hSet(aHash, 'ID_PAC',	param:GUIDPatient )
		hb_hSet(aHash, 'ID_C',		param:GUIDCase )
		hb_hSet(aHash, 'VPOLIS',	param:Policy:PolicyType )
		hb_hSet(aHash, 'SPOLIS',	param:Policy:PolicySeries )
		hb_hSet(aHash, 'NPOLIS',	param:Policy:PolicyNumber )
		hb_hSet(aHash, 'SMO',		param:Policy:SMO )
		hb_hSet(aHash, 'OKATO',		param:OKATO )
		hb_hSet(aHash, 'NOVOR',		param:Neonate )
		hb_hSet(aHash, 'DATE_R2',	param:NeonateDOB )
		hb_hSet(aHash, 'POL2',		param:NeonateGender )
		hb_hSet(aHash, 'USL_OK',	param:Usl_Ok )
		hb_hSet(aHash, 'VIDPOM',	param:VidPom )
		hb_hSet(aHash, 'PROFIL',	param:Profil )
		hb_hSet(aHash, 'IDSP',		param:IDSP )
		hb_hSet(aHash, 'NPR_MO',	param:ReferralMO )
		hb_hSet(aHash, 'FORMA14',	param:Forms14 )
		hb_hSet(aHash, 'KOD_DIAG0',	param:Diagnosis )
		hb_hSet(aHash, 'RSLT_NEW',	param:Result )
		hb_hSet(aHash, 'ISHOD_NEW',	param:Ishod )
		hb_hSet(aHash, 'VRACH',		param:Doctor )
		hb_hSet(aHash, 'PRVS',		param:PRVS )
		hb_hSet(aHash, 'RODIT_DR',	param:ParentDOB )
		hb_hSet(aHash, 'RODIT_POL',	param:ParentGender )
		hb_hSet(aHash, 'DATE_E2',	param:DateEditCase )
		hb_hSet(aHash, 'KOD_P2',	chr( param:UserID ) )
		hb_hSet(aHash, 'PZTIP',		param:TypePlanOrder )
		hb_hSet(aHash, 'PZKOL',		param:CompletedPlanOrder )
		hb_hSet(aHash, 'ST_VERIFY',	param:VerificationStage )
		hb_hSet(aHash, 'KOD_UP',	param:PreviousRecordNumber )
		hb_hSet(aHash, 'OPLATA',	param:PaymentType )
		hb_hSet(aHash, 'SUMP',		param:PaymentTotal )
		hb_hSet(aHash, 'SANK_MEK',	param:FinancialSanctionsMEK )
		hb_hSet(aHash, 'SANK_MEE',	param:FinancialSanctionsMEE )
		hb_hSet(aHash, 'SANK_EKMP',	param:FinancialSanctionsEKMP )
		hb_hSet(aHash, 'REESTR',	param:Reestr )
		hb_hSet(aHash, 'REES_NUM',	param:ReestrNumber )
		hb_hSet(aHash, 'REES_ZAP',	param:ReestrPosition )
		hb_hSet(aHash, 'SCHET_NUM',	param:InvoiceSendingNumber )
		hb_hSet(aHash, 'SCHET_ZAP',	param:InvoiceSendingPosition )

		hb_hSet(aHash, 'ID',		param:ID )
		hb_hSet(aHash, 'REC_NEW',	param:IsNew )
		hb_hSet(aHash, 'DELETED',	param:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			param:ID := ret
			param:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS THumanExtDB
	local obj
	
	obj := THumanExt():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:Dispans := hbArray[ 'DISPANS' ]
	obj:StatusST := hbArray[ 'STATUS_ST' ]
	obj:Povod := hbArray[ 'POVOD' ]
	obj:Travma := hbArray[ 'TRAVMA' ]
	obj:GUIDPatient := hbArray[ 'ID_PAC' ]
	obj:GUIDCase := hbArray[ 'ID_C' ]
	
	obj:PolicyType := hbArray[ 'VPOLIS' ]	// вид полиса (от 1 до 3);1-старый,2-врем.,3-новый;по умолчанию 1 - старый
	obj:PolicySeries := hbArray[ 'SPOLIS' ]			// серия полиса;;для наших - разделить по пробелу
	obj:PolicyNumber := hbArray[ 'NPOLIS' ]			// номер полиса;;"для иногородних - вынуть из ""k_inog"" и разделить"
	obj:SMO := hbArray[ 'SMO' ]			// реестровый номер СМО;;преобразовать из старых кодов в новые, иногродние = 34
	obj:OKATO := hbArray[ 'OKATO' ]
	obj:Neonate := hbArray[ 'NOVOR' ]
	obj:NeonateDOB := hbArray[ 'DATE_R2' ]
	obj:NeonateGender := hbArray[ 'POL2' ]
	obj:Usl_Ok := hbArray[ 'USL_OK' ]
	obj:VidPom := hbArray[ 'VIDPOM' ]
	obj:Profil := hbArray[ 'PROFIL' ]
	obj:IDSP := hbArray[ 'IDSP' ]
	obj:ReferralMO := hbArray[ 'NPR_MO' ]
	obj:Forms14 := hbArray[ 'FORMA14' ]
	obj:Diagnosis := hbArray[ 'KOD_DIAG0' ]
	obj:Result := hbArray[ 'RSLT_NEW' ]
	obj:Ishod := hbArray[ 'ISHOD_NEW' ]
	obj:Doctor := hbArray[ 'VRACH' ]
	obj:PRVS := hbArray[ 'PRVS' ]
	obj:ParentDOB := hbArray[ 'RODIT_DR' ]
	obj:ParentGender := hbArray[ 'RODIT_POL' ]
	obj:DateEditCase := hbArray[ 'DATE_E2' ]
	obj:UserID := asc( hbArray[ 'KOD_P2' ] )
	obj:TypePlanOrder := hbArray[ 'PZTIP' ]
	obj:CompletedPlanOrder := hbArray[ 'PZKOL' ]
	obj:VerificationStage := hbArray[ 'ST_VERIFY' ]
	obj:PreviousRecordNumber := hbArray[ 'KOD_UP' ]
	obj:PaymentType := hbArray[ 'OPLATA' ]
	obj:PaymentTotal := hbArray[ 'SUMP' ]
	obj:FinancialSanctionsMEK := hbArray[ 'SANK_MEK' ]
	obj:FinancialSanctionsMEE := hbArray[ 'SANK_MEE' ]
	obj:FinancialSanctionsEKMP := hbArray[ 'SANK_EKMP' ]
	obj:Reestr := hbArray[ 'REESTR' ]
	obj:ReestrNumber := hbArray[ 'REES_NUM' ]
	obj:ReestrPosition := hbArray[ 'REES_ZAP' ]
	obj:InvoiceSendingNumber := hbArray[ 'SCHET_NUM' ]
	obj:InvoiceSendingPosition := hbArray[ 'SCHET_ZAP' ]
	return obj