#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник группы услуг для способа оплаты = 5 файл u_usl_5.dbf
CREATE CLASS TServiceWoDoctorDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getByID( nID )
		METHOD getByShifr( cShifr )
		METHOD getList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()	CLASS TServiceWoDoctorDB
	return self

METHOD getByID( nID )    CLASS TServiceWoDoctorDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
  return ret

METHOD getByShifr( cShifr )    CLASS TServiceWoDoctorDB
	local cOldArea, cFind, services
	local hArray := nil
	local ret := nil
	
	// предварительно проверить что пришло строка
	if ValType( cShifr ) != 'C'
		return ret
	endif
	cShifr := alltrim( cShifr )
	cOldArea := Select( )
	if ::super:RUse()
		services := Select()
		(services)->(ordSetFocus( 1 ))
		if (services)->(dbSeek( cShifr ) )
			if !empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(services)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getList()    CLASS TServiceWoDoctorDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
	
METHOD Save( oService ) CLASS TServiceWoDoctorDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TServiceWoDoctor' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'SHIFR',			oService:Shifr )
		hb_hSet(aHash, 'KOD_VR',		iif( oService:IsDoctor, 1, 0 ) )
		hb_hSet(aHash, 'KOD_AS',		iif( oService:IsAssistant, 1, 0 ) )
		hb_hSet(aHash, 'KOD_VRN',		iif( oService:IsSenderDoctor, 1, 0 ) )
		hb_hSet(aHash, 'KOD_ASN',		iif( oService:IsSenderAssistant, 1, 0 ) )
		hb_hSet(aHash, 'ID',			oService:ID )
		hb_hSet(aHash, 'REC_NEW',		oService:IsNew )
		hb_hSet(aHash, 'DELETED',		oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TServiceWoDoctorDB
	local obj
	
	obj := TServiceWoDoctor():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:IsDoctor := iif( hbArray[ 'KOD_VR' ] == 1, .t., .f. )
	obj:IsAssistant := iif( hbArray[ 'KOD_AS' ] == 1, .t., .f. )
	obj:IsSenderDoctor := iif( hbArray[ 'KOD_VRN' ] == 1, .t., .f. )
	obj:IsSenderAssistant := iif( hbArray[ 'KOD_ASN' ] == 1, .t., .f. )
	return obj