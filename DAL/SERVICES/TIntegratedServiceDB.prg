#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'

// Класс комплексных услуг

// файл "uslugi_k.dbf"
CREATE CLASS TIntegratedServiceDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Delete( oService )
		METHOD Save( oService )
		METHOD getByID ( nID )
		METHOD getList()
		METHOD getByShifr ( cShifr )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TIntegratedServiceDB

	return self

METHOD Delete( oService ) CLASS TIntegratedServiceDB
	local item

	for each item in oService:Services
		TComponentsIntegratedServiceDB():Delete( item )
	next
	::super:Delete( oService )
	return .t.
	
METHOD getList()    CLASS TIntegratedServiceDB
	local aReturn := {}
	local oRow := Nil
	
	for each oRow in ::super:getList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
		
METHOD getByID ( nID )		 CLASS TIntegratedServiceDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
  return ret

METHOD getByShifr ( cShifr )		 CLASS TIntegratedServiceDB
	local cOldArea, complex, cFind
	local ret := nil
	
	cOldArea := select( )
	if ::super:RUse()
		complex := select( )
		(complex)->(ordSetFocus( 1 ))
		if (complex)->(dbSeek( cShifr) )
			if !empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(complex)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret
	
METHOD Save( oService ) CLASS TIntegratedServiceDB
	local ret := .F.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TIntegratedService' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',		oService:Name )
		hb_hSet(aHash, 'SHIFR',		oService:Shifr )
		if ! isnil( oService:Doctor )
			hb_hSet(aHash, 'KOD_VR',	oService:Doctor:ID )
		else
			hb_hSet(aHash, 'KOD_VR',	0 )
		endif
		if ! isnil( oService:Assistant )
			hb_hSet(aHash, 'KOD_AS',	oService:Assistant:ID )
		else
			hb_hSet(aHash, 'KOD_AS',	0 )
		endif
		hb_hSet(aHash, 'ID',		oService:ID )
		hb_hSet(aHash, 'REC_NEW',	oService:IsNew )
		hb_hSet(aHash, 'DELETED',	oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TIntegratedServiceDB
	local obj, oDoctor := nil, oAssistant := nil
	
	oDoctor := TEmployeeDB():GetByID( hbArray[ 'KOD_VR' ] )
	oAssistant := TEmployeeDB():GetByID( hbArray[ 'KOD_AS' ] )
	obj := TIntegratedService():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:Name := hbArray[ 'NAME' ]
	obj:Doctor := TEmployeeDB():GetByID( hbArray[ 'KOD_VR' ] )
	obj:Assistant := TEmployeeDB():GetByID( hbArray[ 'KOD_AS' ] )
	obj:Services := TComponentsIntegratedServiceDB():getListByShifr( hbArray[ 'SHIFR' ] )
	return obj

// ==============================================================================================	

// файл "uslugi1k.dbf"
CREATE CLASS TComponentsIntegratedServiceDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getListByShifr ( cShifr )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TComponentsIntegratedServiceDB
	return self
	
METHOD getListByShifr( cShifr )    CLASS TComponentsIntegratedServiceDB
	local cOldArea, cAlias, cFind, nFind := 0
	local  inserv
	local aReturn := {}
	
	cFind := cShifr
	nFind := len( cShifr )
	cOldArea := select()
	if ::super:RUse()
		cAlias := select( )
		(cAlias)->(ordSetFocus( 1 ))
		if (cAlias)->(dbSeek(cFind))
			do while substr( (cAlias)->shifr, 1, nFind ) == cFind .and. !(cAlias)->(eof())
				if !empty( hArray := ::super:currentRecord() )
					aadd( aReturn, ::FillFromHash( hArray ) )
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aReturn

METHOD Save( oService ) CLASS TComponentsIntegratedServiceDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TComponentsIntegratedService' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'SHIFR',		oService:Shifr )
		hb_hSet(aHash, 'SHIFR1',	oService:Shifr1 )
		hb_hSet(aHash, 'ID',		oService:ID )
		hb_hSet(aHash, 'REC_NEW',	oService:IsNew )
		hb_hSet(aHash, 'DELETED',	oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TComponentsIntegratedServiceDB
	local obj
	
	obj := TComponentsIntegratedService():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:Shifr1 := hbArray[ 'SHIFR1' ]
	return obj