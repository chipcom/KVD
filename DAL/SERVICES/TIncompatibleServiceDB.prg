#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

********************************
// класс для справочника состава несовместимых услуг ns_usl_k.dbf
CREATE CLASS TIncompatibleServiceDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getByID( nID )
		METHOD getList()
		METHOD getListComposition( nIDIncompatible )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()	CLASS TIncompatibleServiceDB
	return self

METHOD getByID( nID )    CLASS TIncompatibleServiceDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD getList()    CLASS TIncompatibleServiceDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn

METHOD getListComposition( nIDIncompatible )    CLASS TIncompatibleServiceDB
	local cOldArea, cAlias, cFind
	local aReturn := {}
	local oRow
	
	// предварительно проверить что пришло число или строка из 6-ти цифр,
	// если число преобразовать STR( nIDIncompatible, 6 )
	if isnumber( nIDIncompatible )
		cFind := STR( nIDIncompatible, 6 )
	elseif ischaracter( nIDIncompatible )
		cFind := nIDIncompatible
		nIDIncompatible := val( nIDIncompatible )
	else
		return aReturn
	endif

	for each oRow in ::super:getList( )
		if oRow[ 'KOD' ] == nIDIncompatible
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	
	return aReturn
	
	
METHOD Save( oService ) CLASS TIncompatibleServiceDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TIncompatibleService' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'SHIFR',			oService:Shifr )
		hb_hSet(aHash, 'KOD',			oService:IDIncompatible )
		
		hb_hSet(aHash, 'ID',			oService:ID )
		hb_hSet(aHash, 'REC_NEW',		oService:IsNew )
		hb_hSet(aHash, 'DELETED',		oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TIncompatibleServiceDB
	local obj
	
	obj := TIncompatibleService():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:IDIncompatible := hbArray[ 'KOD' ]
	obj:Shifr := hbArray[ 'SHIFR' ]
	return obj

********************************
// класс для справочник несовместимых услуг ns_usl.dbf
CREATE CLASS TCompostionIncompServiceDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD Delete( oService )
		
		METHOD getByID( nID )
		METHOD getList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()	CLASS TCompostionIncompServiceDB
	return self

METHOD getByID( nID )    CLASS TCompostionIncompServiceDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
  return ret
	
METHOD getList()    CLASS TCompostionIncompServiceDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList( )
		AADD( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
	
METHOD Save( oService ) CLASS TCompostionIncompServiceDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TCompostionIncompService' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',			oService:Name )
		hb_hSet(aHash, 'KOL',			oService:Quantity )
		
		hb_hSet(aHash, 'ID',			oService:ID )
		hb_hSet(aHash, 'REC_NEW',		oService:IsNew )
		hb_hSet(aHash, 'DELETED',		oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret

METHOD Delete( oService ) CLASS TCompostionIncompServiceDB
	local ret := .f.
	local item := nil
	
	for each item in oService:IncompatibleServices
		TIncompatibleServiceDB():Delete( item )
	next
	ret := ::super:Delete( oService )
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TCompostionIncompServiceDB
	local obj
	
	obj := TCompostionIncompService():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Name := hbArray[ 'NAME' ]
	obj:Quantity := hbArray[ 'KOL' ]
	return obj
