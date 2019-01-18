#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// класс для плановой трудоемкости по персоналу
CREATE CLASS TPlannedMonthlyStaffDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oPlan )
		METHOD getByID ( nID )
		METHOD getByIDandYearMonth ( nID, nYear, nMonth )
		METHOD getByYearMonth ( nYear, nMonth )
		METHOD GetList()
		METHOD Clear()
		METHOD Fill()

	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()  CLASS TPlannedMonthlyStaffDB
	return self

METHOD getByID ( nID )		 CLASS TPlannedMonthlyStaffDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !Empty( hArray := ::super:getById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getByIDandYearMonth ( nID, nYear, nMonth )		 CLASS TPlannedMonthlyStaffDB
	local cOldArea, planned, cFind
	local ret := nil, tObj := nil

	cFind := str( nID, 4 ) + str( nYear, 4 ) + str( nMonth, 2 )
	cOldArea := Select( )
	if ::super:RUse()
		planned := Select( )
		if (planned)->(dbSeek( cFind ))
			ret := TPlannedMonthlyStaff():New( (planned)->( recno() ), (planned)->KOD, (planned)->GOD, (planned)->MES, (planned)->M_TRUD, ;
					, , .F., (planned)->(Deleted()))
			if ret != nil
				if ( tObj := TEmployeeDB():GetByID( ret:IDPerson() ) ) != nil
					ret:FIO := tObj:FIO
					ret:TabNom := tObj:Tabnom
				endif
			endif
		endif
		(planned)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByYearMonth ( nYear, nMonth )		 CLASS TPlannedMonthlyStaffDB
	local aReturn := {}
	local oRow := nil

	for each oRow in ::super:GetList()
		if ( oRow[ 'GOD' ] == nYear .and. oRow[ 'MES' ] == nMonth .and. !oRow[ 'DELETED' ] )
			AADD( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn
	
METHOD GetList()   CLASS TPlannedMonthlyStaffDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:GetList( )
		AADD( aReturn, ::FillFromHash( oRow ) )		// все
	next
	return aReturn
	
METHOD Clear()		 CLASS TPlannedMonthlyStaffDB
	local oRow := nil

	for each oRow in ::GetList( )
		if empty( oRow:PlannedMonthly() )
			::Delete( oRow )
			&& oRow:Delete()
		else
			if TEmployeeDB():GetByID( oRow:IDPerson ) == nil
				::Delete( oRow )
				&& oRow:Delete()
			endif
		endif
	next
	return nil

METHOD Fill( nYear, nMonth )		 CLASS TPlannedMonthlyStaffDB
	local oRow := nil
	local oPlanned := nil
	local aTemp := nil
	
	HB_Default( @nYear, 0 )
	HB_Default( @nMonth, 0 )
	if nYear == 0
		aTemp := TEmployeeDB():GetList()
	else
		aTemp := TEmployeeDB():GetListOnDate( , ;
				ctod( str( LastDayOM( nMonth ), 2 ) + '/' + str( nMonth, 2 ) + '/' + str( nYear, 4 ) ) )
	endif
	for each oRow in aTemp
		if ::getByIDandYearMonth ( oRow:ID, nYear, nMonth ) == nil
			oPlanned := TPlannedMonthlyStaff():New() //::New()
			oPlanned:IdPerson := oRow:ID
			oPlanned:FIO := oRow:FIO
			oPlanned:TabNom := oRow:TabNom
			oPlanned:Month := nMonth
			oPlanned:Year := nYear
			::Save( oPlanned )
			&& oPlanned:Save()
		endif
	next
	return nil
 	
* Сохранить объект TPlannedMonthlyStaffDB
*
METHOD Save( oPlan ) CLASS TPlannedMonthlyStaffDB
	local ret := .f.
	local aHash := nil
	
	if upper( oPlan:classname() ) == upper( 'TPlannedMonthlyStaff' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',		oPlan:IDPerson )
		hb_hSet(aHash, 'GOD',		oPlan:Year )
		hb_hSet(aHash, 'MES',		oPlan:Month )
		hb_hSet(aHash, 'M_TRUD',	oPlan:PlannedMonthly )
			
		hb_hSet(aHash, 'ID',		oPlan:ID )
		hb_hSet(aHash, 'REC_NEW',	oPlan:IsNew )
		hb_hSet(aHash, 'DELETED',	oPlan:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oPlan:ID := ret
			oPlan:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TPlannedMonthlyStaffDB
	local obj := nil, tObj := nil
	
	obj := TPlannedMonthlyStaff():New( hbArray[ 'ID' ], ;
			hbArray[ 'KOD' ], ;
			hbArray[ 'GOD' ], ;
			hbArray[ 'MES' ], ;
			hbArray[ 'M_TRUD' ], ;
			,;
			,;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	if obj != nil
		if ( tObj := TEmployeeDB():GetByID( hbArray[ 'KOD' ] ) ) != nil
			obj:FIO := tObj:FIO
			obj:TabNom := tObj:Tabnom
		endif
	endif
	return obj