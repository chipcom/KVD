#include 'hbclass.ch'
#include 'property.ch'
#include 'hbhash.ch'

********************************
// класс для строки дополнений о плательщике платного договора файл hum_plat.dbf
CREATE CLASS TContractPayerDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oPayer )
		METHOD GetByID( nID )
		METHOD GetByIdLU( nIdLU )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TContractPayerDB
	return self

METHOD GetByID( nID )    CLASS TContractPayerDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !Empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD GetByIdLU( nIdLU )    CLASS TContractPayerDB
	local hArray := nil, obj := nil
	local cOldArea
	local cAlias
	local cFind
		
	if nIdLU == 0
		return obj
	endif
	// получим строку поиска
	cFind := STR( nIdLU, 7 )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 1 ))
		if (cAlias)->(dbSeek(cFind))
			if !empty( hArray := ::super:currentRecord() )
				obj := ::FillFromHash( hArray )
			endif
			(cAlias)->(dbSkip())
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return obj
	
METHOD Save( oPayer ) CLASS TContractPayerDB
	local ret := .f.
	local aHash := nil
	
	if upper( oPayer:classname() ) == upper( 'TContractPayer' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',		oPayer:IDLU )
		hb_hSet(aHash, 'ADRES',		oPayer:Address )
		hb_hSet(aHash, 'PASPORT',	oPayer:Passport )
		hb_hSet(aHash, 'I_POST',    oPayer:Email )
		hb_hSet(aHash, 'PHONE',		oPayer:Phone )
		hb_hSet(aHash, 'ID',		oPayer:ID )
		hb_hSet(aHash, 'REC_NEW',	oPayer:IsNew )
		hb_hSet(aHash, 'DELETED',	oPayer:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oPayer:ID := ret
			oPayer:IsNew := .f.
		endif
	endif
	return ret
   
METHOD FillFromHash( hbArray )     CLASS TContractPayerDB
	local obj
	
	obj := TContractPayer():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:IDLU := hbArray[ 'KOD' ]
	obj:Address := hbArray[ 'ADRES' ]
    obj:Passport := hbArray[ 'PASPORT' ]
    obj:EMail := hbArray[ 'I_POST' ]
    obj:Phone := hbArray[ 'PHONE' ]
	return obj