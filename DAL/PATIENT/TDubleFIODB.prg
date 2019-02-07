#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

// класс справочника двойных фамилий, файл : dir_server + 'mo_kfio' + sdbf 
CREATE CLASS TDubleFIODB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByPatient( param )
		METHOD Save( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TDubleFIODB
	return self

METHOD getByID( nID )		 CLASS TDubleFIODB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByPatient( param ) CLASS TDubleFIODB
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

METHOD Save( param ) CLASS TDubleFIODB
	local ret := .f.
	local aHash := nil

	if upper( param:classname() ) == upper( 'TDubleFIO' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD', param:IDPatient )
		hb_hSet( aHash, 'FAM', param:LastName )
		hb_hSet( aHash, 'IM', param:FirstName )
		hb_hSet( aHash, 'OT', param:MiddleName )

		hb_hSet(aHash, 'ID',			param:ID )
		hb_hSet(aHash, 'REC_NEW',		param:IsNew )
		hb_hSet(aHash, 'DELETED',		param:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			param:ID := ret
			param:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TDubleFIODB
	local obj
	
	obj := TDubleFIO():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDPatient := hbArray[ 'KOD' ]
	obj:LastName  := hbArray[ 'FAM' ]
	obj:FirstName  := hbArray[ 'IM' ]
	obj:MiddleName  := hbArray[ 'OT' ]
	return obj
