#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'property.ch'

********************************
// класс для справочник привязка участковых врачей к участкам файл mo_uchvr.dbf
CREATE CLASS TDistrictDoctorDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save()
		METHOD getByID( nID )
		METHOD getList()
		METHOD getListIS()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()  CLASS TDistrictDoctorDB
	return self

METHOD getByID( nID )    CLASS TDistrictDoctorDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD getList()    CLASS TDistrictDoctorDB
	local lFlag := .t.
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn

METHOD getListIS()    CLASS TDistrictDoctorDB
	local lFlag := .t.
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList( )
		if oRow[ 'IS' ] == 1
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD Save( oDistrictDoctor ) CLASS TDistrictDoctorDB
	local ret := .f.
	local aHash := nil
	
	if upper( oDistrictDoctor:classname() ) == upper( 'TDistrictDoctor' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'UCH',			oDistrictDoctor:District )
		hb_hSet(aHash, 'IS',			oDistrictDoctor:IS )
		hb_hSet(aHash, 'VRACH',			oDistrictDoctor:IDDoctor )
		hb_hSet(aHash, 'VRACHV',		oDistrictDoctor:IDDoctorAdult )
		hb_hSet(aHash, 'VRACHD',		oDistrictDoctor:IDDoctorChild )
		
		hb_hSet(aHash, 'ID',			oDistrictDoctor:ID )
		hb_hSet(aHash, 'REC_NEW',		oDistrictDoctor:IsNew )
		hb_hSet(aHash, 'DELETED',		oDistrictDoctor:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oDistrictDoctor:ID := ret
			oDistrictDoctor:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TDistrictDoctorDB
	local obj
	
	obj := TDistrictDoctor():New( hbArray[ 'ID' ], ;
			hbArray[ 'UCH' ], ;
			hbArray[ 'IS' ], ;
			hbArray[ 'VRACH' ], ;
			hbArray[ 'VRACHV' ], ;	
			hbArray[ 'VRACHD' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj