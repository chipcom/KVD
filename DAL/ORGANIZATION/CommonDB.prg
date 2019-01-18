#include "hbclass.ch"
#include "hbhash.ch" 
#include 'property.ch'

// файл "s_adres.dbf" адресных строк
CREATE CLASS TAddressStringDB		INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oCommon )
		METHOD getByID ( nID )
		METHOD GetList( )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TAddressStringDB
	return self

METHOD getByID ( nID )		 			CLASS TAddressStringDB
	local hArray := Nil
	local ret := Nil
	
	if ( nID != 0 ) .and. !Empty( hArray := ::Super:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD GetList()   						CLASS TAddressStringDB
	local aReturn := {}
	local oRow := Nil
	
	for each oRow in ::Super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )		// все
	next
	return aReturn

* Сохранить объект TAddressStringDB
*
METHOD Save( oCommon ) 							CLASS TAddressStringDB
	local ret := .F.
	local aHash := Nil
	
	if upper( oCommon:classname() ) == upper( 'TAddressString' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',			oCommon:Name )
		hb_hSet(aHash, 'ID',			oCommon:ID )
		hb_hSet(aHash, 'REC_NEW',		oCommon:IsNew )
		hb_hSet(aHash, 'DELETED',		oCommon:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oCommon:ID := ret
			oCommon:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     		CLASS TAddressStringDB
	local obj
	
	obj := TAddressString():New( hbArray[ 'ID' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj
	
/////////////////////////////////////////////////////

// файл "s_mr.dbf" мест работы
CREATE CLASS TPlaceOfWorkDB		INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oCommon )
		METHOD getByID ( nID )
		METHOD GetList( )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS
METHOD New() CLASS TPlaceOfWorkDB
	return self

METHOD getByID ( nID )		 			CLASS TPlaceOfWorkDB
	local hArray := Nil
	local ret := Nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::Super:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD GetList()   						CLASS TPlaceOfWorkDB
	local aReturn := {}
	local oRow := Nil
	
	for each oRow in ::Super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )		// все
	next
	return aReturn

* Сохранить объект TPlaceOfWorkDB
*
METHOD Save( oCommon ) 							CLASS TPlaceOfWorkDB
	local ret := .F.
	local aHash := Nil
	
	if upper( oCommon:classname() ) == upper( 'TPlaceOfWork' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',			oCommon:Name )
		hb_hSet(aHash, 'ID',			oCommon:ID )
		hb_hSet(aHash, 'REC_NEW',		oCommon:IsNew )
		hb_hSet(aHash, 'DELETED',		oCommon:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oCommon:ID := ret
			oCommon:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     		CLASS TPlaceOfWorkDB
	local obj
	
	obj := TPlaceOfWork():New( hbArray[ 'ID' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj