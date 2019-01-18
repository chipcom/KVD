#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TDisabilityDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByPatient( param )
		METHOD Save( oDisability )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TDisabilityDB
	return self

METHOD getByPatient( param )		CLASS TDisabilityDB
	local hArray := nil, ret := nil
	local cOldArea
	local cAlias

	if isnumber( param ) .and. param != 0
	elseif isobject( param ) .and. param:classname() == upper( 'TPatient' ) .and. ! param:IsNew
		param := param:ID
	else
		return ret
	endif
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		do while ! (cAlias)->( eof() )
			if (cAlias)->kod == param
				if ! empty( hArray := ::super:currentRecord() )
					ret := ::FillFromHash( hArray )
					exit
				endif
			endif
			(cAlias)->( dbSkip() )
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByID( nID )		 CLASS TDisabilityDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( oDisability ) CLASS TDisabilityDB
	local ret := .f.
	local aHash := nil

	if upper( oDisability:classname() ) == upper( 'TDisability' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD',		oDisability:IDPatient )
		hb_hSet( aHash, 'DATE_INV', oDisability:Date )
		hb_hSet( aHash, 'PRICH_INV',oDisability:Reason )
		hb_hSet( aHash, 'DIAG_INV', oDisability:Diagnosis )
		
		hb_hSet(aHash, 'ID',			oDisability:ID )
		hb_hSet(aHash, 'REC_NEW',		oDisability:IsNew )
		hb_hSet(aHash, 'DELETED',		oDisability:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oDisability:ID := ret
			oDisability:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TDisabilityDB
	local obj
	
	obj := TDisability():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDPatient := hbArray[ 'KOD' ]
	obj:Date  := hbArray[ 'DATE_INV' ]
	obj:Reason  := hbArray[ 'PRICH_INV' ]
	obj:Diagnosis  := hbArray[ 'DIAG_INV' ]
	return obj
