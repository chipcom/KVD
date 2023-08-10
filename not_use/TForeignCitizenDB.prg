#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS TForeignCitizenDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByPatient( param )
		METHOD Save( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TForeignCitizenDB
	return self

METHOD getByID( nID )		 CLASS TForeignCitizenDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByPatient( param ) CLASS TForeignCitizenDB
	local cOldArea, cAlias, cFind
	local ret := nil, item
	
	if isnumber( param ) .and. param != 0
		cFind := str( param, 7 )
	elseif isobject( param ) .and. param:classname() == upper( 'TPatient' ) .and. ! param:IsNew
		cFind := str( param:ID, 7 )
	else
		return ret
	endif
	for each item in ::super:GetList( )
		if ( str( item[ 'KOD' ], 7 ) == cFind .and. ! item[ 'DELETED' ] )
			ret := ::FillFromHash( item )
			exit
		endif
	next
	return ret

METHOD Save( param ) CLASS TForeignCitizenDB
	local ret := .f.
	local aHash := nil

	if upper( param:classname() ) == upper( 'TForeignCitizen' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD', param:IDPatient )
		hb_hSet( aHash, 'OSN_PREB', param:BaseOfStay )
		hb_hSet( aHash, 'ADRES_PRO', param:AddressRegistration )
		hb_hSet( aHash, 'MIGR_KARTA', param:MigrationCard )
		hb_hSet( aHash, 'DATE_P_G', param:DateBorderCrossing )
		hb_hSet( aHash, 'DATE_R_M', param:DateRegistration )
		
		hb_hSet(aHash, 'ID',			param:ID )
		hb_hSet(aHash, 'REC_NEW',		param:IsNew )
		hb_hSet(aHash, 'DELETED',		param:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			param:ID := ret
			param:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TForeignCitizenDB
	local obj
	
	obj := TForeignCitizen():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDPatient := hbArray[ 'KOD' ]
	obj:BaseOfStay := hbArray[ 'OSN_PREB' ]
	obj:AddressRegistration := hbArray[ 'ADRES_PRO' ]
	obj:MigrationCard := hbArray[ 'MIGR_KARTA' ]
	obj:DateBorderCrossing := hbArray[ 'DATE_P_G' ]
	obj:DateRegistration := hbArray[ 'DATE_R_M' ]
	return obj
