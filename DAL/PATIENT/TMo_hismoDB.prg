#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS TMo_hismoDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByHuman( param )
		METHOD Save( oMo_kismo )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TMo_hismoDB
	return self

METHOD getByID( nID )		 CLASS TMo_hismoDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByHuman( param ) CLASS TMo_hismoDB
	local cOldArea, cAlias, cFind
	local ret := nil, oRow
	
	if isnumber( param )
		cFind := str( param, 7 )
	elseif isobject( param ) .and. param:classname() == upper( 'THuman' )
		cFind := str( param:ID, 7 )
	else
		return ret
	endif
	for each oRow in ::super:GetList( )
		if ( str( oRow[ 'KOD' ], 7 ) == cFind .and. ! oRow[ 'DELETED' ] )
			ret := ::FillFromHash( oRow )
			exit
		endif
	next
	return ret

METHOD Save( oMo_kismo ) CLASS TMo_hismoDB
	local ret := .f.
	local aHash := nil

	if upper( oMo_kismo:classname() ) == upper( 'TMo_hismo' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD',			oMo_kismo:IDHuman )
		hb_hSet( aHash, 'SMO_NAME',		oMo_kismo:Name )

		hb_hSet(aHash, 'ID',			oMo_kismo:ID )
		hb_hSet(aHash, 'REC_NEW',		oMo_kismo:IsNew )
		hb_hSet(aHash, 'DELETED',		oMo_kismo:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oMo_kismo:ID := ret
			oMo_kismo:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TMo_hismoDB
	local obj
	
	obj := TMo_hismo():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDHuman := hbArray[ 'KOD' ]
	obj:Name  := hbArray[ 'SMO_NAME' ]
	return obj
