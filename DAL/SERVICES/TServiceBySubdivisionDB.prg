#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл 'usl_otd.dbf'
CREATE CLASS TServiceBySubdivisionDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getByID ( nID )
		METHOD getByIDService ( nIDService )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 CLASS TServiceBySubdivisionDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getByIDService ( nIDService )		 CLASS TServiceBySubdivisionDB
	local cShifr
	local cOldArea, bySubdivision
	local ret := nil

	// предварительно проверить что пришло строка
	if ValType( nIDService ) != 'N'
		return ret
	endif
	cShifr := str( nIDService, 4 )
	cOldArea := Select( )
	if ::super:RUse()
		bySubdivision := Select( )
		(bySubdivision)->(ordSetFocus( 1 ))
		if (bySubdivision)->(dbSeek( cShifr ) )
			if !empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(bySubdivision)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD New() CLASS TServiceBySubdivisionDB
	return self

METHOD Save( oService ) CLASS TServiceBySubdivisionDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TServiceBySubdivision' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',		oService:IDService )
		hb_hSet(aHash, 'OTDEL',		oService:AllowSubdivision )
		
		hb_hSet(aHash, 'ID',		oService:ID )
		hb_hSet(aHash, 'REC_NEW',	oService:IsNew )
		hb_hSet(aHash, 'DELETED',	oService:Deleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TServiceBySubdivisionDB
	local obj
	
	obj := TServiceBySubdivision():New( hbArray[ 'ID' ], ;
			hbArray[ 'KOD' ], ;
			hbArray[ 'OTDEL' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:IDService := hbArray[ 'KOD' ]
	obj:AllowSubdivision := hbArray[ 'OTDEL' ]
	return obj