#include 'hbclass.ch'
#include 'property.ch'
#include 'hbhash.ch' 
#include 'common.ch'
#include 'function.ch'

********************************
// класс для строки состава услуг по платному договору файл hum_p_u.dbf
CREATE CLASS TContractServiceDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nId )
		METHOD getListServices( nIDLU )
		METHOD getListContractIDByDateService( date1, date2 )	// получить список ID контрактов услуги которых оказаны в промежутке дат date1 и date2
		METHOD Save( oService )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS
METHOD New( nID, lNew, lDeleted ) CLASS TContractServiceDB
	return self

METHOD GetByID( nID )    CLASS TContractServiceDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !Empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getListContractIDByDateService( date1, date2 ) CLASS TContractServiceDB
	local cOldArea
	local cAlias
	local aContracts := {}

	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->( dbGoTop() )
		do while !((cAlias)->( eof() ) )
			if between( c4tod( (cAlias)->DATE_U ), date1, date2 )
				if hb_ascan( aContracts, { | x | x = (cAlias)->KOD } ) == 0
				&& if hb_ascan( aContracts, { | x | x:ID = (cAlias)->KOD } ) == 0
					aadd( aContracts, (cAlias)->KOD )
					&& aadd( aContracts, TContractDB():getByID( (cAlias)->KOD ) )
				endif
			endif
			(cAlias)->(DBSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aContracts
	
METHOD getListServices( nIDLU ) CLASS TContractServiceDB
	local hArray := nil
	local cOldArea, cFind
	local cAlias
	local aService := {}
	
	// предварительно проверить что пришло число или строка из 7-ти цифр,
	// если число преобразовать STR( nCode, 7 )
	if valtype( nIDLU ) == 'N'
		cFind := STR( nIDLU, 7 )
	elseif valtype( nIDLU ) == 'C'
		cFind := alltrim( nIDLU )
		nIDLU := val( nIDLU )
	else
		return aService
	endif
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(ordSetFocus( 1 ))
		if (cAlias)->(dbSeek(cFind))
			do while (cAlias)->kod == nIDLU .and. !(cAlias)->(eof())
				if !empty( hArray := ::super:currentRecord() )
					aadd( aService, ::FillFromHash( hArray ) )
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aService

METHOD Save( oService ) CLASS TContractServiceDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TContractService' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',		oService:IDLU )
		hb_hSet(aHash, 'DATE_U',	dtoc4( oService:Date ) )
		hb_hSet(aHash, 'U_KOD',		if( oService:Service != nil, oService:Service:ID, 0 ) )
		hb_hSet(aHash, 'U_CENA',	oService:Price )
		hb_hSet(aHash, 'U_KOEF',	oService:Coefficient )
		&& hb_hSet(aHash, 'KOD_VR',	if( oService:Doctor != nil, oService:Doctor:ID, 0 ) )
		&& hb_hSet(aHash, 'KOD_AS',	if( oService:Assistant != nil, oService:Assistant:ID, 0 ) )
		&& hb_hSet(aHash, 'MED1',		if( oService:Nurse1 != nil, oService:Nurse1:ID, 0 ) )
		&& hb_hSet(aHash, 'MED2',		if( oService:Nurse2 != nil, oService:Nurse2:ID, 0 ) )
		&& hb_hSet(aHash, 'MED3',		if( oService:Nurse3 != nil, oService:Nurse3:ID, 0 ) )
		&& hb_hSet(aHash, 'SAN1',		if( oService:Aidman1 != nil, oService:Aidman1:ID, 0 ) )
		&& hb_hSet(aHash, 'SAN2',		if( oService:Aidman2 != nil, oService:Aidman2:ID, 0 ) )
		&& hb_hSet(aHash, 'SAN3',		if( oService:Aidman3 != nil, oService:Aidman3:ID, 0 ) )
		hb_hSet(aHash, 'KOD_VR',	oService:IDDoctor )
		hb_hSet(aHash, 'KOD_AS',	oService:IDAssistant )
		hb_hSet(aHash, 'MED1',		oService:IDNurse1 )
		hb_hSet(aHash, 'MED2',		oService:IDNurse2 )
		hb_hSet(aHash, 'MED3',		oService:IDNurse3 )
		hb_hSet(aHash, 'SAN1',		oService:IDAidman1 )
		hb_hSet(aHash, 'SAN2',		oService:IDAidman2 )
		hb_hSet(aHash, 'SAN3',		oService:IDAidman3 )
		hb_hSet(aHash, 'KOL',		oService:Quantity )
		hb_hSet(aHash, 'STOIM',		oService:Total )
		hb_hSet(aHash, 'T_EDIT',	iif( oService:IsEdit, 1, 0 ) )
		hb_hSet(aHash, 'OTD',		oService:IDSubdivision )
		hb_hSet(aHash, 'ID',		oService:ID )
		hb_hSet(aHash, 'REC_NEW',	oService:IsNew )
		hb_hSet(aHash, 'DELETED',	oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TContractServiceDB
	local obj
	
	obj := TContractService():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDLU := hbArray[ 'KOD' ]
	obj:Date := c4tod( hbArray[ 'DATE_U' ] )
	obj:Price := hbArray[ 'U_CENA' ]
	obj:Coefficient := hbArray[ 'U_KOEF' ]
	obj:Quantity := hbArray[ 'KOL' ]
	obj:Total := hbArray[ 'STOIM' ]
	obj:IsEdit := if( hbArray[ 'T_EDIT' ] == 0, .f., .t. )
	obj:Service := hbArray[ 'U_KOD' ]
	obj:Doctor := hbArray[ 'KOD_VR' ]
	obj:Assistant := hbArray[ 'KOD_AS' ]
	obj:Subdivision := hbArray[ 'OTD' ]
	obj:Nurse1 := hbArray[ 'MED1' ]
	obj:Nurse2 := hbArray[ 'MED2' ]
	obj:Nurse3 := hbArray[ 'MED3' ]
	obj:Aidman1 := hbArray[ 'SAN1' ]
	obj:Aidman2 := hbArray[ 'SAN2' ]
	obj:Aidman3 := hbArray[ 'SAN3' ]
	return obj