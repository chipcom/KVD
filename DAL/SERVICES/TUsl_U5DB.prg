#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник группы услуг для способа оплаты = 5 файл u_usl_5.dbf
CREATE CLASS TUsl_U5DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getByID( nID )
		METHOD getList()
		METHOD getListDoctorOMS()
		METHOD getListAssistentOMS()
		METHOD getListDoctorPlat()
		METHOD getListAssistentPlat()
		METHOD getListSender()
		METHOD getListDoctorDMS()
		METHOD getListAssistentDMS()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()  CLASS TUsl_U5DB
	return Self                  

METHOD getByID( nID )    CLASS TUsl_U5DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getList()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		AADD( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
  
METHOD getListDoctorOMS()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		If oRow[ 'TIP' ] == O5_VR_OMS
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getListAssistentOMS()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		if oRow[ 'TIP' ] == O5_AS_OMS
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getListDoctorPlat()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		if oRow[ 'TIP' ] == O5_VR_PLAT
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getListAssistentPlat()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		if oRow[ 'TIP' ] == O5_AS_PLAT
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getListSender()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		if oRow[ 'TIP' ] == O5_VR_NAPR
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getListDoctorDMS()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		if oRow[ 'TIP' ] == O5_VR_DMS
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getListAssistentDMS()    CLASS TUsl_U5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList()
		if oRow[ 'TIP' ] == O5_AS_DMS
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn
	
METHOD Save( oService ) CLASS TUsl_U5DB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TUsl_U5' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'TIP',			oService:Type )
		hb_hSet(aHash, 'USL_1',			oService:Service1 )
		hb_hSet(aHash, 'USL_2',			oService:Service2 )
		hb_hSet(aHash, '_USL_1',		oService:Trans1 )
		hb_hSet(aHash, '_USL_2',		oService:Trans2 )
		hb_hSet(aHash, 'PROCENT',		oService:Percent )
		hb_hSet(aHash, 'PROCENT2',		oService:Percent2 )
		hb_hSet(aHash, 'RAZRYAD',		oService:Razryad )
		hb_hSet(aHash, 'OTDAL',			iif( oService:Otdal, 1, 0 ) )

		hb_hSet(aHash, 'ID',			oService:ID )
		hb_hSet(aHash, 'REC_NEW',		oService:IsNew )
		hb_hSet(aHash, 'DELETED',		oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TUsl_U5DB
	local obj
	
	&& obj := TUsl_U5():New( hbArray[ 'ID' ], ;
			&& hbArray[ 'TIP' ], ;
			&& hbArray[ 'USL_1' ], ;
			&& hbArray[ 'USL_2' ], ;
			&& hbArray[ '_USL_1' ], ;	
			&& hbArray[ '_USL_2' ], ;
			&& hbArray[ 'PROCENT' ], ;
			&& hbArray[ 'PROCENT2' ], ;
			&& hbArray[ 'RAZRYAD' ], ;
			&& iif( hbArray[ 'OTDAL' ] == 1, .t., .f. ), ;
			&& hbArray[ 'REC_NEW' ], ;
			&& hbArray[ 'DELETED' ] ;
			&& )
	obj := TUsl_U5():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Type := hbArray[ 'TIP' ]
	obj:Service1 := hbArray[ 'USL_1' ]
	obj:Service2 := hbArray[ 'USL_2' ]
	obj:Trans1 := hbArray[ '_USL_1' ]
	obj:Trans2 := hbArray[ '_USL_2' ]
	obj:Percent := hbArray[ 'PROCENT' ]
	obj:Percent2 := hbArray[ 'PROCENT2' ]
	obj:Razryad := hbArray[ 'RAZRYAD' ]
	obj:Otdal := iif( hbArray[ 'OTDAL' ] == 1, .t., .f. )
	return obj