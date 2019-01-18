#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник совмещения наших услуг с услугами Минздрава РФ (ФФОМС) mo_su.dbf
CREATE CLASS TMo_suDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD GetByID( nID )
		METHOD GetList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TMo_suDB
	return self

METHOD getByID( nID )    CLASS TMo_suDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getList()    CLASS TMo_suDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn

METHOD Save( oService ) CLASS TMo_suDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TMo_su' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',			::FKod )
		hb_hSet(aHash, 'NAME',			::FName )
		hb_hSet(aHash, 'SHIFR',			::FShifr )
		hb_hSet(aHash, 'SHIFR1',		::FShifr1 )
		hb_hSet(aHash, 'TIP',			::FType )
		hb_hSet(aHash, 'SLUGBA',		::FIdSlugba )
		hb_hSet(aHash, 'ZF',			::FDentalFormula )
		hb_hSet(aHash, 'PROFIL',		::FIdProfil )
		
		hb_hSet(aHash, 'ID',			::nID )
		hb_hSet(aHash, 'REC_NEW',		::lNew )
		hb_hSet(aHash, 'DELETED',		::lDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TMo_suDB
	local obj
	
	obj := TMo_su():New( hbArray[ 'ID' ], ;
			hbArray[ 'KOD' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Name := hbArray[ 'NAME' ]
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:Shifr1 := hbArray[ 'SHIFR1' ]
	obj:Type := hbArray[ 'TIP' ]
	obj:IDSlugba := hbArray[ 'SLUGBA' ]
	obj:DentalFormula := hbArray[ 'ZF' ]
	obj:IDProfil := hbArray[ 'PROFIL' ]
	return obj