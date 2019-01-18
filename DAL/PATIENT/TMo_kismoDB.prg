#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS TMo_kismoDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByPatient( param )
		METHOD Save( oMo_kismo )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TMo_kismoDB
	return self

METHOD getByID( nID )		 CLASS TMo_kismoDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByPatient( param ) CLASS TMo_kismoDB
	local cOldArea, cAlias, cFind
	local ret := nil, oRow
	
	if isnumber( param )
		cFind := str( param, 7 )
	elseif isobject( param ) .and. param:classname() == upper( 'TPatient' )
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

METHOD Save( oMo_kismo ) CLASS TMo_kismoDB
	local ret := .f.
	local aHash := nil

	if upper( oMo_kismo:classname() ) == upper( 'TMo_kismo' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD', oMo_kismo:IDPatient )
		hb_hSet( aHash, 'SMO_NAME', oMo_kismo:Name )

		hb_hSet(aHash, 'ID',			oMo_kismo:ID )
		hb_hSet(aHash, 'REC_NEW',		oMo_kismo:IsNew )
		hb_hSet(aHash, 'DELETED',		oMo_kismo:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oMo_kismo:ID := ret
			oMo_kismo:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TMo_kismoDB
	local obj
	
	obj := TMo_kismo():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDPatient := hbArray[ 'KOD' ]
	obj:Name  := hbArray[ 'SMO_NAME' ]
	return obj
