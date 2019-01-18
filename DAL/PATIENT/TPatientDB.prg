#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatientDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oPatient )
		METHOD getByID ( nID )
		METHOD getAllDistrict()
		METHOD NextKod_VU( nDistrict )
		METHOD getDublicateSinglePolicyNumber()
		METHOD getByFIOAndDOB ( cFIO, DOB )
		METHOD getByPolicy( sPolicy, nPolicy )
		METHOD getBySNILS ( cSNILS )
	HIDDEN:
		METHOD FillFromHash( hbArray )
		METHOD updateFIO( oPatient )
ENDCLASS

METHOD New()		CLASS TPatientDB
	return self

// вызывается по окончании инициализации всех свойств объекта поциента
METHOD procedure updateFIO( oPatient )		CLASS TPatientDB
	local oDubleName
	
	oDubleName := TDubleFIODB():getByPatient( oPatient )
	if ! isnil( oDubleName )
		oPatient:LastName := oDubleName:LastName
		oPatient:FirstName := oDubleName:FirstName
		oPatient:MiddleName := oDubleName:MiddleName
	endif
	oDubleName := nil
	return nil
	
METHOD getByID ( nID )		 CLASS TPatientDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getBySNILS( cSNILS )		 CLASS TPatientDB
	local ret
	local hArray := nil
	local cFind
	local cOldArea, cAlias

	cFind := '1' + padr( cSNILS, 11 )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSetOrder( 5 ))
		if (cAlias)->( dbSeek( cFind ) )
			if ! empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByPolicy( sPolicy, nPolicy )		 CLASS TPatientDB
	local ret
	local hArray := nil
	local cFind
	local cOldArea, cAlias
	local cPolicy

	cPolicy := make_polis( sPolicy, nPolicy ) // серия и номер страхового полиса
	cFind := '1' + padr( cPolicy, 17 )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSetOrder( 3 ))
		if (cAlias)->( dbSeek( cFind ) )
			if ! empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByFIOAndDOB( cFIO, DOB )		 CLASS TPatientDB
	local ret
	local hArray := nil
	local cFind
	local cOldArea, cAlias

	cFind := '1' + padr( cFIO, 50 ) + dtos( DOB )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSetOrder( 2 ))
		if (cAlias)->( dbSeek( cFind ) )
			if ! empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD NextKod_VU( nDistrict )		 CLASS TPatientDB
	local ret := 0
	local cFind
	local cOldArea, cAlias
	local vr_kod_vu, is_f := 0, t_kod_vu := 0

	cFind := strzero( nDistrict, 2 )
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbSetOrder( 4 ) )
		if (cAlias)->( dbSeek( cFind ) )
			(cAlias)->( dbGoBottom() )
			if nDistrict == (cAlias)->UCHAST
				if (cAlias)->KOD_VU < 99999 // есть запас по номерам
					t_kod_vu := (cAlias)->KOD_VU + 1
					is_f := 1
				else // дошли до 99999
					is_f := 2
				endif
			endif
			if is_f == 0
				(cAlias)->( dbseek( strzero( nDistrict + 1, 2 ), .t. ) )
				if (cAlias)->( eof() )
					(cAlias)->( dbGoBottom() )
				else
					(cAlias)->( dbSkip( -1 ) ) // выходим на нужный нам участок
				endif
				if nDistrict == (cAlias)->UCHAST
					if (cAlias)->KOD_VU < 99999 // есть запас по номерам
						t_kod_vu := (cAlias)->KOD_VU + 1
						is_f := 1
					else // дошли до 99999
						is_f := 2
					endif
				endif
			endif
			if is_f == 2
				vr_kod_vu := 0
				(cAlias)->( dbseek( strzero( nDistrict, 2 ) ) )
				do while nDistrict == (cAlias)->UCHAST .and. ! (cAlias)->( eof() )
					if (cAlias)->KOD_VU - vr_kod_vu > 1
						t_kod_vu := vr_kod_vu + 1
						exit
					endif
					vr_kod_vu := (cAlias)->KOD_VU
					(cAlias)->( dbSkip() )
				enddo
			endif
		else
			t_kod_vu := 1  // новый участок
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return t_kod_vu

METHOD getAllDistrict()		 CLASS TPatientDB
	local arr := {}, i
	local cOldArea, cAlias

	// найдем все используемые участки
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSetOrder( 4 ))
		for i := 1 to 99
			if (cAlias)->(dbSeek( strzero( i, 2 ) ))
				if !empty( ::super:currentRecord() )
					aadd( arr, i )
				endif
			endif
		next
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return arr

METHOD getDublicateSinglePolicyNumber()		CLASS TPatientDB
	local ret := {}
	local listID := {}
	local cOldArea, cAlias
	local mis, i
	local j := 0
	local atmp, rec

	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		&& (cAlias)->(ordSetFocus( 6 ))
		(cAlias)->( dbGoTop() )
		&& if (cAlias)->( dbSeek( '1' ) )
			&& do while (cAlias)->KOD_MIS == '1' .and. !(cAlias)->(eof())
			do while ! (cAlias)->( eof() )
				if ! empty( (cAlias)->KOD_MIS )
					mis := alltrim( (cAlias)->KOD_MIS )
					rec := (cAlias)->( recno() )
					if ( i := hb_ascan( listID, { | x | x[ 1 ] == mis } ) ) == 0
						atmp := {}
						aadd( atmp, rec )
						aadd( listID, { mis, atmp } )
					else
						atmp := listID[ i, 2 ]
						aadd( atmp, rec )
						listID[ i, 2 ] := atmp
					endif
				endif
				(cAlias)->(dbSkip())
			enddo
		&& endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
		if len( listID ) > 0
			for i := 1 to len( listID )
				if len( listID[ i, 2 ] ) > 1
					j++
				endif
			next
		endif
	endif
	return ret

METHOD Save( oPatient ) CLASS TPatientDB
	local ret := .f.
	local aHash := nil

// доработать	
	if upper( oPatient:classname ) == upper( 'TPatient' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD',		oPatient:Code )
		hb_hSet( aHash, 'FIO',		oPatient:FIO )
		hb_hSet( aHash, 'POL',		oPatient:Gender )
		hb_hSet( aHash, 'DATE_R',	oPatient:DOB )
		hb_hSet( aHash, 'VZROS_REB',oPatient:Vzros_Reb )
		hb_hSet( aHash, 'ADRES',	oPatient:AddressReg )
		hb_hSet( aHash, 'MR_DOL',	oPatient:PlaceWork )
		hb_hSet( aHash, 'RAB_NERAB',oPatient:Working )
		hb_hSet( aHash, 'KOMU',		oPatient:Komu )
		hb_hSet( aHash, 'STR_CRB',	oPatient:InsuranceID )
		hb_hSet( aHash, 'ZA_SMO',	oPatient:ErrorKartotek )
		hb_hSet( aHash, 'POLIS',	oPatient:Policy )
		hb_hSet( aHash, 'SROK_POLIS',dtoc4( oPatient:PolicyPeriod ) )
		hb_hSet( aHash, 'MI_GIT',	oPatient:Mi_Git )
		hb_hSet( aHash, 'RAJON_GIT',oPatient:AreaCodeResidence )
		hb_hSet( aHash, 'MEST_INOG',oPatient:Mest_Inog )
		hb_hSet( aHash, 'RAJON',	oPatient:FinanceAreaCode )
		hb_hSet( aHash, 'BUKVA',	oPatient:Bukva )
		hb_hSet( aHash, 'UCHAST',	oPatient:District )
		hb_hSet( aHash, 'KOD_VU',	oPatient:Kod_VU )
		hb_hSet( aHash, 'SNILS',	oPatient:SNILS )
		hb_hSet( aHash, 'DEATH',	if( oPatient:IsDied, 1, 0 ) )
		hb_hSet( aHash, 'KOD_TF',	oPatient:TFOMSEncoding )
		hb_hSet( aHash, 'KOD_MIS',	oPatient:SinglePolicyNumber )
		hb_hSet( aHash, 'KOD_AK',	oPatient:OutpatientCardNumber )
		hb_hSet( aHash, 'TIP_PR',	oPatient:AttachmentStatus )
		hb_hSet( aHash, 'MO_PR',	oPatient:MO_added  )
		hb_hSet( aHash, 'DATE_PR',	oPatient:Date_added  )
		hb_hSet( aHash, 'SNILS_VR',	oPatient:SNILSuchastDoctor  )
		hb_hSet( aHash, 'PC1',		oPatient:PC1 )
		hb_hSet( aHash, 'PC2',		oPatient:PC2 )
		hb_hSet( aHash, 'PC3',		oPatient:PC3 )
		hb_hSet( aHash, 'PN1',		oPatient:PN1 )
		hb_hSet( aHash, 'PN2',		oPatient:PN2 )
		hb_hSet( aHash, 'PN3',		oPatient:PN3 )
		
		hb_hSet(aHash, 'ID',			oPatient:ID )
		hb_hSet(aHash, 'REC_NEW',		oPatient:IsNew )
		hb_hSet(aHash, 'DELETED',		oPatient:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oPatient:ID := ret
			oPatient:IsNew := .f.
			// сохраним зависимые объекты
			if ! isnil( oPatient:ExtendInfo )
				TPatientExtDB():Save( oPatient:ExtendInfo )
			endif
			if ! isnil( oPatient:AddInfo )
				TPatientAddDB():Save( oPatient:AddInfo )
			endif
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TPatientDB
	local obj
	
	obj := TPatient():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Code := hbArray[ 'KOD' ]
	obj:FIO := hbArray[ 'FIO' ]
	obj:Gender := hbArray[ 'POL' ]
	obj:DOB := hbArray[ 'DATE_R' ]
	obj:AddressReg := hbArray[ 'ADRES' ]
	obj:District := hbArray[ 'UCHAST' ]
	obj:Bukva := hbArray[ 'BUKVA' ]
	obj:Kod_VU := hbArray[ 'KOD_VU' ]
	obj:Vzros_Reb := hbArray[ 'VZROS_REB' ]
	obj:PlaceWork := hbArray[ 'MR_DOL' ]
	obj:Working := hbArray[ 'RAB_NERAB' ]
	obj:Komu := hbArray[ 'KOMU' ]
	obj:Policy := hbArray[ 'POLIS' ]
	obj:PolicyPeriod := c4Tod( hbArray[ 'SROK_POLIS' ] )
	obj:InsuranceID := hbArray[ 'STR_CRB' ]
	obj:AttachmentStatus := hbArray[ 'TIP_PR' ]
	obj:SinglePolicyNumber := hbArray[ 'KOD_MIS' ]
	obj:IsDied := if( hbArray[ 'DEATH' ] == 0, .f., .t. )
	obj:SNILS := hbArray[ 'SNILS' ]
	obj:OutpatientCardNumber := hbArray[ 'KOD_AK' ]
	obj:AreaCodeResidence := hbArray[ 'RAJON_GIT' ]
	obj:FinanceAreaCode := hbArray[ 'RAJON' ]
	obj:Mest_Inog := hbArray[ 'MEST_INOG' ]
	obj:Mi_Git := hbArray[ 'MI_GIT' ]
	obj:ErrorKartotek := hbArray[ 'ZA_SMO' ]
	obj:TFOMSEncoding := hbArray[ 'KOD_TF' ]
	obj:MO_added := hbArray[ 'MO_PR' ]
	obj:Date_added := hbArray[ 'DATE_PR' ]
	obj:SNILSuchastDoctor := hbArray[ 'SNILS_VR' ]
	obj:PC1 := hbArray[ 'PC1' ]
	obj:PC2 := hbArray[ 'PC2' ]
	obj:PC3 := hbArray[ 'PC3' ]
	obj:PN1 := hbArray[ 'PN1' ]
	obj:PN2 := hbArray[ 'PN2' ]
	obj:PN3 := hbArray[ 'PN3' ]
	if hbArray[ 'MEST_INOG' ] == 9	// имеются двойные фамилия или имя или отчество
		::updateFIO( obj )
	endif
	return obj