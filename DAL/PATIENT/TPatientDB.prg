#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatientDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New( nID, cFIO, cGender, dBOB, cAddress, nDistrict, cBukva, nKod_vu, lNew, lDeleted )
		METHOD Save( oPatient )
		METHOD getByID ( nID )
		METHOD getAllDistrict()
		METHOD getByPolicyOMS( FIO, DOB )
		METHOD getByFIOAndDOB( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByFIOAndDOB( FIO, DOB )		CLASS TPatientDB
	local hArray := nil
	local cOldArea, cAlias, cFind := ''
	local ret := nil

	cFind := '1' + PadRight( upper( FIO ), 50 ) + dtos( DOB )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSetOrder( 2 ))
		if (cAlias)->(dbSeek(cFind, .t.))
			if !empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByPolicyOMS( param )		CLASS TPatientDB
	local hArray := nil
	local cOldArea, cAlias, cFind := ''
	local ret := nil

	if len( param ) == 16		// длина единого полиса ОМС
		cFind := '1' + param
		cOldArea := Select()
		if ::super:RUse()
			cAlias := Select()
			(cAlias)->(dbSetOrder( 3 ))
			if (cAlias)->(dbSeek(cFind, .t.))
				if !empty( hArray := ::super:currentRecord() )
					ret := ::FillFromHash( hArray )
				endif
			endif
			(cAlias)->( dbCloseArea() )
			dbSelectArea( cOldArea )
		endif
	endif
	return ret

METHOD New()		CLASS TPatientDB
	return self
	
METHOD getByID ( nID )		 CLASS TPatientDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getAllDistrict()		 CLASS TPatientDB
	local arr := {}, i
	local cOldArea, pat

	// найдем все используемые участки
	cOldArea := Select()
	if ::super:RUse()
		pat := Select()
		(pat)->(dbSetOrder( 4 ))
		for i := 1 to 99
			if (pat)->(dbSeek( strzero( i, 2 ) ))
				if !empty( ::super:currentRecord() )
					aadd( arr, i )
				endif
			endif
		next
		(pat)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return arr
	
METHOD Save( oPatient ) CLASS TPatientDB
	local ret := .f.
	local aHash := nil

// доработать	
	&& if upper( oPatient:classname() ) == upper( 'TPatient' )
		&& aHash := hb_Hash()
		&& hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		&& hb_hSet(aHash, 'FIO',		oPatient:FIO )
		&& hb_hSet(aHash, 'POL',		oPatient:Gender )
		&& hb_hSet(aHash, 'DATE_R',		oPatient:DOB )
		&& hb_hSet(aHash, 'VZROS_REB',	oPatient:Vzros_Reb )
//		&& hb_hSet(aHash, 'ADRES',		oPatient::FAddress )
		&& hb_hSet(aHash, 'MR_DOL',		oPatient:PlaceWork )
		&& hb_hSet(aHash, 'RAB_NERAB',	oPatient:Working )
		&& hb_hSet(aHash, 'KOMU',		oPatient:Komu )
		&& hb_hSet(aHash, 'STR_CRB',	oPatient:InsuranceID )
		&& hb_hSet(aHash, 'ZA_SMO',		oPatient:Za_Smo )
		&& hb_hSet(aHash, 'POLIS',		oPatient:Policy )
		&& hb_hSet(aHash, 'SROK_POLIS',	dtoc4( oPatient:PolicyPeriod ) )
		&& hb_hSet(aHash, 'MI_GIT',		oPatient:Mi_Git )
		&& hb_hSet(aHash, 'RAJON_GIT',	oPatient:AreaCodeResidence )
		&& hb_hSet(aHash, 'MEST_INOG',	oPatient:Mest_Inog )
		&& hb_hSet(aHash, 'RAJON',		oPatient:FinanceAreaCode )
		&& hb_hSet(aHash, 'BUKVA',		oPatient:Bukva )
		&& hb_hSet(aHash, 'UCHAST',		oPatient:District )
		&& hb_hSet(aHash, 'KOD_VU',		oPatient:Kod_VU )
		&& hb_hSet(aHash, 'SNILS',		oPatient:SNILS )
		&& hb_hSet(aHash, 'DEATH',		if( oPatient:IsDied, 1, 0 ) )
		&& hb_hSet(aHash, 'KOD_TF',		oPatient:TFOMSEncoding )
		&& hb_hSet(aHash, 'KOD_MIS',	oPatient:SinglePolicyNumber )
		&& hb_hSet(aHash, 'KOD_AK',		oPatient:OutpatientCardNumber )
		&& hb_hSet(aHash, 'TIP_PR',		oPatient:AttachmentStatus )
		&& hb_hSet(aHash, 'MO_PR',		oPatient::F  )
		&& hb_hSet(aHash, 'DATE_PR',	oPatient::F  )
		&& hb_hSet(aHash, 'SNILS_VR',	oPatient::F  )
		&& hb_hSet(aHash, 'PC1',		oPatient::F  )
		&& hb_hSet(aHash, 'PC2',		oPatient::F  )
		&& hb_hSet(aHash, 'PC3',		oPatient::F  )
		&& hb_hSet(aHash, 'PN1',		oPatient::F  )
		&& hb_hSet(aHash, 'PN2',		oPatient::F  )
		&& hb_hSet(aHash, 'PN3',		oPatient::F  )
		&& if ( ret := ::super:Save( aHash ) ) != -1
			&& oPatient:ID := ret
			&& oPatient:IsNew := .f.
		&& endif
	&& endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TPatientDB
	local obj
	
	obj := TPatient():New( hbArray[ 'ID' ], ;
			hbArray[ 'FIO' ], ;
			hbArray[ 'POL' ], ;
			hbArray[ 'DATE_R' ], ;
			hbArray[ 'ADRES' ], ;
			hbArray[ 'UCHAST' ], ;
			hbArray[ 'BUKVA' ], ;
			hbArray[ 'KOD_VU' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:Vzros_Reb := hbArray[ 'VZROS_REB' ]
	obj:PlaceWork := hbArray[ 'MR_DOL' ]
	obj:Working := hbArray[ 'RAB_NERAB' ]
	obj:Komu := hbArray[ 'KOMU' ]
	obj:Policy := hbArray[ 'POLIS' ]
	obj:PolicyPeriod := c4ToD( [ 'SROK_POLIS' ] )
	obj:InsurenceID := hbArray[ 'STR_CRB' ]
	obj:AttachmentStatus := hbArray[ 'TIP_PR' ]
	obj:SinglePolicyNumber := hbArray[ 'KOD_MIS' ]
	obj:IsDied := if( hbArray[ 'DEATH' ] == 0, .f., .t. )
	obj:SNILS := hbArray[ 'SNILS' ]
	obj:OutpatientCardNumber := hbArray[ 'KOD_AK' ]
	obj:AreaCodeResidence := hbArray[ 'RAJON_GIT' ]
	obj:FinanceAreaCode := hbArray[ 'RAJON' ]
	obj:Mest_Inog := hbArray[ 'MEST_INOG' ]
	obj:Mi_Git := hbArray[ 'MI_GIT' ]
	obj:Za_Smo := hbArray[ 'ZA_SMO' ]
	return obj