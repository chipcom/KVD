* 26.09.18 StatisticsByServicesAndPatients( par ) - составление отчета по объему работ по услугам и пациентам
* 26.09.18 StatisticsBySelectedServices( par, lSelect ) - составление отчета по объему работ по выбранным услугам
* 21.09.18 StatisticsByServicesAndPatientsHTML( aHash ) - составление отчета по объему работ по услугам и пациентам (сам отчет)
* 20.09.18 StatisticsBySelectedServicesHTML( aHash, listServices ) - составление отчета по объему работ по выбранным услугам (сам отчет)


#include 'hbthread.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'chip_mo.ch'
#include 'common.ch'

* 26.09.18 составление отчета по объему работ по услугам и пациентам
function StatisticsByServicesAndPatients( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		aServices := FillArrayServices()
		if !isnil( aServices )
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByServicesAndPatientsHTML(), aHash, aServices )
			WaitingReport()
		endif
	endif
	return nil

* 21.09.18 составление отчета по объему работ по услугам и пациентам (сам отчет)
function	StatisticsByServicesAndPatientsHTML( aHash, listServices )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { 'Статистика по услугам' }
	local aContracts := {}, aServices := {}, aSubdivisions := {}, aPatients := {}
	local itemContract, itemService, itemSubdivision, itemPatient
	local stService := '', counterService := 0
	local stSubdivision := '', counterSubdivision := 0
	local stPatient := '', counterPatient := 0
	local totalService := 0, totalQuantity := 0
	local flagSubdivision := .f.
	local rowspanSubdivision := '1'
	local iRowPatient := 0
	local strClass, strClass1

	oDoc := CreateReportHTML( 'Список услуг' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Отделение'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Пациент'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Дата оконч. лечения'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Стоимость услуг'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each itemContract in aContracts
		if itemContract:Patient == nil
			loop
		endif
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )
				
			for each itemService in itemContract:Services()
				aSubdivisions := {}
				aPatients := {}
				stPatient := ''
				stService := ''
				stSubdivision := ''
				if itemService:Service != nil
					if ( hb_ascan( listServices, { | x | alltrim( upper( x[ 1 ] ) ) == alltrim( upper( itemService:Service:Shifr ) ) } ) == 0 )
						loop
					endif
					if itemService:Subdivision == nil
						loop
					endif
					stService := alltrim( itemService:Service:Shifr1251 )
					if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
						// список aServices {шифр, название, количество , сумма, список отделений}
						aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0, {} } )
						counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
					endif
					aServices[ counterService, 3 ] += itemService:Quantity
					aServices[ counterService, 4 ] += itemService:Total
					aSubdivisions := aServices[ counterService, 5 ]
					
					stSub := alltrim( itemService:Subdivision:Name1251 )
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// список aSubdivisions {название, список пациентов, количество пациентов, сумма услуг, кол-во услуг}
						aadd( aSubdivisions, { stSub, {}, 0, 0, 0 } )
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					stPatient := alltrim( itemContract:Patient:FIO1251 )
					aPatients := aSubdivisions[ counterSub, 2 ]
					// список aPatients {ФИО, дата окончания лечения, общая сумма}
					aadd( aPatients, { stPatient, itemContract:EndTreatment, itemService:Total } )
					aSubdivisions[ counterSub, 2 ] := aPatients
					aSubdivisions[ counterSub, 3 ] += 1
					aSubdivisions[ counterSub, 4 ] += itemService:Total
					aSubdivisions[ counterSub, 5 ] += itemService:Quantity
					
					aServices[ counterService, 5 ] := aSubdivisions
				endif
			next
		endif
	next
	asort( aServices, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each itemService in aServices
		oRow       := oTable + 'tr'
		// 1-я, 4-я колонки
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3 total" valign="center" align="center" colspan="4"'
		oCell:text := itemService[ 1 ] + '   ' + itemService[ 2 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		aSubdivisions := itemService[ 5 ]
		for each itemSubdivision in aSubdivisions
			aPatients := itemSubdivision[ 2 ]
			rowspanSubdivision := lstr( itemSubdivision[ 3 ] )
			flagSubdivision := .f.

			iRowPatient := 0
			for each itemPatient in aPatients
				iRowPatient += 1
				oRow       := oTable + 'tr'
		
				if ! flagSubdivision
					// 1-я колонка
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
					oCell:text := itemSubdivision[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagSubdivision := .t.
				endif
				if iRowPatient == len( aPatients )
					strClass := 'class="td1"'
					strClass1 := 'class="td3"'
				else
					strClass := 'class="td11"'
					strClass1 := 'class="td31"'
				endif
				// 2-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="left"'
				oCell:text := itemPatient[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 3-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="center"'
				oCell:text := itemPatient[ 2 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 5-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= strClass1 + ' valign="center" align="right"'
				oCell:text := lstr( itemPatient[ 3 ] ) 
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			next
			
			oRow       := oTable + 'tr'
			// 1-я, 2-я колонки
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1 subtotal" valign="center" align="left" colspan="2"'
			oCell:text := 'Итого пациентов: ' + lstr( itemSubdivision[ 3 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			// 3-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1 subtotal" valign="center" align="left"'
			oCell:text := 'Кол-во услуг: ' + lstr( itemSubdivision[ 5 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			// 4-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td3 subtotal" valign="center" align="right"'
			oCell:text := put_kopE( itemSubdivision[ 4 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 26.09.18 составление отчета по объему работ по выбранным услугам
function StatisticsBySelectedServices( par, lSelect )
	local aHash, aServices := nil

	if ( aHash := QueryDataForTheReport() ) != nil
		// выберем услуги
		if lSelect
			aServices := FillArrayServices()
		endif
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsBySelectedServicesHTML(), aHash, aServices )
		WaitingReport()
	endif
	return nil

* 20.09.18 составление отчета по объему работ по выбранным услугам (сам отчет)
function	StatisticsBySelectedServicesHTML( aHash, listServices )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { 'Статистика по услугам' }
	local aContracts := {}, aServices := {}
	local itemContract, itemService
	local stService := '', counterService := 0
	local totalService := 0, totalQuantity := 0
	local lNotSelect := ! isnil( listServices )
	
	oDoc := CreateReportHTML( 'Список услуг' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-я, 2-я колонки
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Услуга'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Стоимость услуг'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 1-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Шифр'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Наименование'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	
	for each itemContract in aContracts
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )
				
			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				if lNotSelect .and. ( hb_ascan( listServices, { | x | alltrim( upper( x[ 1 ] ) ) == alltrim( upper( itemService:Service:Shifr ) ) } ) == 0 )
					loop
				endif
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// список aServices {шифр, название, количество , общая сумма}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0 } )
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
				aServices[ counterService, 3 ] += itemService:Quantity
				aServices[ counterService, 4 ] += itemService:Total
				totalQuantity += itemService:Quantity
				totalService += itemService:Total
			next
		endif
	next
	asort( aServices, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemService in aServices
	
		oRow       := oTable + 'tr'
		// 1-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text := itemService[ 1 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		// 2-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text := itemService[ 2 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
			
		// 3-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text := lstr( itemService[ 3 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		// 4-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3"  valign="center" align="right"'
		oCell:text := put_kopE( itemService[ 4 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	next
	// Повал отчета
	oRow	:= oTable + 'tr'
	// 1-я, 2-я колонки
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="right" colspan="2"'
	oCell:text := 'И Т О Г О :'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-я колонка
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( totalQuantity )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-я колонка
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( totalService, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil