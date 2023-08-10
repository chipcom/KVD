#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS TRepresentativeDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByPatient( param )
		METHOD Save( oRepresentative )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TRepresentativeDB
	return self

METHOD getByID( nID )		 CLASS TRepresentativeDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByPatient( param ) CLASS TRepresentativeDB
	local cOldArea, cAlias, cFind, item
	local retArray := {}
	
	if isnumber( param )
		cFind := str( param, 7 )
	elseif isobject( param ) .and. param:classname() == upper( 'TPatient' )
		cFind := str( param:ID, 7 )
	else
		return ret
	endif
	for each item in ::super:GetList( )
		if ( str( item[ 'KOD' ], 7 ) == cFind .and. ! item[ 'DELETED' ] )
			aadd( ret, ::FillFromHash( item ) )
		endif
	next
	return retArray

METHOD Save( oRepresentative ) CLASS TRepresentativeDB
	local ret := .f.
	local aHash := nil

	if upper( oRepresentative:classname() ) == upper( 'TRepresentative' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD', oRepresentative:IDPatient )
		hb_hSet( aHash, 'NN', oRepresentative:Number )
		hb_hSet( aHash, 'FIO', oRepresentative:FIO )
		hb_hSet( aHash, 'STATUS', oRepresentative:Status )
		hb_hSet( aHash, 'IS_UHOD', if( oRepresentative:IsCare, 1, 0 ) )
		hb_hSet( aHash, 'IS_FOOD', if( oRepresentative:HasFood, 1, 0 ) )
		hb_hSet( aHash, 'DATE_R', oRepresentative:DOB )
		hb_hSet( aHash, 'ADRES', oRepresentative:Address )
		hb_hSet( aHash, 'MR_DOL', oRepresentative:PlaceOfWork )
		hb_hSet( aHash, 'PHONE', oRepresentative:Phone )
		hb_hSet( aHash, 'PASPORT', oRepresentative:Passport )
		hb_hSet( aHash, 'POLIS', oRepresentative:Policy )

		hb_hSet(aHash, 'ID',			oRepresentative:ID )
		hb_hSet(aHash, 'REC_NEW',		oRepresentative:IsNew )
		hb_hSet(aHash, 'DELETED',		oRepresentative:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oRepresentative:ID := ret
			oRepresentative:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TRepresentativeDB
	local obj
	
	obj := TRepresentative():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDPatient := hbArray[ 'KOD' ]
	obj:Number := hbArray[ 'NN' ]
	obj:FIO := hbArray[ 'FIO' ]
	obj:Status := hbArray[ 'STATUS' ]
	obj:IsCare := if( hbArray[ 'IS_UHOD' ] == 0, .f., .t. )
	obj:HasFood := if( hbArray[ 'IS_FOOD' ] == 0, .f., .t. )
	obj:DOB := hbArray[ 'DATE_R' ]
	obj:Address := hbArray[ 'ADRES' ]
	obj:PlaceOfWork := hbArray[ 'MR_DOL' ]
	obj:Phone := hbArray[ 'PHONE' ]
	obj:Passport := hbArray[ 'PASPORT' ]
	obj:Policy := hbArray[ 'POLIS' ]
	return obj
