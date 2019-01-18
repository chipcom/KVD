* 26.09.18 StatisticsBySlugbaAndService( par ) - составление отчета по объему работ по конкретной службе и услугам
* 26.09.18 StatisticsByAllSlugbaAndService( par ) - составление отчета по объему работ по всем службам и услугам
* 26.09.18 StatisticsBySlugbaAndDepartment( par ) - составление отчета по объему работ по службе и учреждениям
* 11.09.18 StatisticsBySlugbaAndServiceHTML( aHash, oSlugba ) - составление отчета по объему работ по конкретной службе и услугам (сам отчет)
* 11.09.18 StatisticsByAllSlugbaAndServiceHTML( aHash ) - составление отчета по объему работ по всем службам и услугам (сам отчет)
* 10.09.18 StatisticsBySlugbaAndDepartmentHTML( aHash ) - составление отчета по объему работ по службе и учреждениям (сам отчет)

#include 'hbthread.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'chip_mo.ch'
#include 'common.ch'

* 26.09.18 составление отчета по объему работ по конкретной службе и услугам
function StatisticsBySlugbaAndService( par )
	local aHash, oSlugba := nil

	if ( aHash := QueryDataForTheReport() ) != nil
		oSlugba := selectSlugbaFromMenu( T_ROW )
		if ! isnil( oSlugba )
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsBySlugbaAndServiceHTML(), aHash, oSlugba )
			WaitingReport()
		endif
	endif
	return nil

* 26.09.18 составление отчета по объему работ по всем службам и услугам
function StatisticsByAllSlugbaAndService( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByAllSlugbaAndServiceHTML(), aHash )
		WaitingReport()
	endif
	return nil

* 26.08.18 составление отчета по объему работ по службе и учреждениям
function StatisticsBySlugbaAndDepartment( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsBySlugbaAndDepartmentHTML(), aHash )
		WaitingReport()
	endif
	return nil

* 11.09.18 составление отчета по объему работ по конкретной службе и услугам (сам отчет)
function StatisticsBySlugbaAndServiceHTML( aHash, oSlugba )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { 'Статистика по услугам (с объединением по службам)', lstr( oSlugba:Shifr ) + '. ' + alltrim( oSlugba:Name1251 ) }
	local aContracts := {}, aServices := {}
	local itemContract, itemService
	local stService := '', counterService := 0
	local totalQuantity := 0, totalSumm := 0
	
	oDoc := CreateReportHTML( 'Статистика по службам (с разбивкой по отделениям)' )
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
				if isnil( itemService:Service:Slugba )
					loop
				endif
				if ( itemService:Service:Slugba:Shifr != oSlugba:Shifr )
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
				totalSumm += itemService:Total
			next
		endif
	next
	asort( aServices, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemService in aServices
	
		// добавим строку таблицы
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
		oCell:attr	:= 'class="td3" valign="center" align="right"'
		oCell:text := put_kopE( itemService[ 4 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	next
	
	// Подвал отчета
	oRow	:= oTable + 'tr'
	// 1-я, 2-я колонки
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="2"'
	oCell:text := 'И Т О Г О:'
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
	oCell:text := put_kopE( totalSumm, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )

	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 11.09.18 составление отчета по объему работ по всем службам и услугам (сам отчет)
function StatisticsByAllSlugbaAndServiceHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { 'Статистика по услугам (с объединением по службам)' }
	local aContracts := {}, aSlugba := {}, aServices := {}
	local itemSlugba, itemService
	local rowspanService := "1"
	local flagSlugba := .f.
	local stSlugba := '', counterSlugba := 0
	local stService := '', counterService := 0
	local item, iRowService
	local totalQuantity := 0, totalSumm := 0
	
	oDoc := CreateReportHTML( 'Статистика по службам (с разбивкой по отделениям)' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-я, 2-я, 3-я колонки
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="3"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Служба'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Шифр услуги'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Наименование услуги'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 6-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 7-я колонка
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
	oParag:text		:= 'Наименование'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Стоимость услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )

			for each itemService in item:Services()
				if isnil( itemService:Service )
					loop
				endif
				if isnil( itemService:Service:Slugba )
					loop
				endif
				stSlugba := alltrim( itemService:Service:Slugba:Name1251 )
				if ( counterSlugba := hb_ascan( aSlugba, { | x | x[ 1 ] == stSlugba } ) ) == 0
					// список aSlugba {название, количество услуг, общая сумма, список услуг, количество услуг}
					aadd( aSlugba, { stSlugba, 0, 0, {}, 0 } )
					counterSlugba := hb_ascan( aSlugba, { | x | x[ 1 ] == stSlugba } )
				endif
				
				aServices := aSlugba[ counterSlugba, 4 ]
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// список aServices {шифр, название, количество , общая сумма}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0 } )
					aSlugba[ counterSlugba, 5 ] += 1
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
					
				aServices[ counterService, 3 ] += itemService:Quantity
				aServices[ counterService, 4 ] += itemService:Total
				aSlugba[ counterSlugba, 2 ] += itemService:Quantity
				aSlugba[ counterSlugba, 3 ] += itemService:Total
				aSlugba[ counterSlugba, 4 ] := aServices
				totalQuantity += itemService:Quantity
				totalSumm += itemService:Total
			next
		endif
	next
	asort( aSlugba, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemSlugba in aSlugba
		flagSlugba := .f.
		rowspanService := lstr( itemSlugba[ 5 ] )
		aServices := itemSlugba[ 4 ]
		
		iRowService := 0
		for each itemService in aServices
			iRowService += 1
			if iRowService == len( aServices )
				strClass := 'class="td1"'
			else
				strClass := 'class="td11"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagSlugba
				// 1-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanService + '"'
				oCell:text := itemSlugba[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 2-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanService + '"'
				oCell:text := lstr( itemSlugba[ 2 ] )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			
				// 3-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanService + '"'
				oCell:text := put_kopE( itemSlugba[ 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			
				flagSlugba := .t.
			endif
			// 4-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemService[ 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemService[ 2 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 6-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text := lstr( itemService[ 3 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 7-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td3" valign="center" align="right"'
			oCell:text := put_kopE( itemService[ 4 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
	
	// Подвал отчета
	oRow	:= oTable + 'tr'
	// 1-я, 2-я, 3-я, 4-я, 5-я колонки
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="5"'
	oCell:text := 'И Т О Г О:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-я колонка
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := totalQuantity
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 7-я колонка
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( totalSumm, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )

	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 10.09.18 составление отчета по объему работ по службе и учреждениям (сам отчет)
function StatisticsBySlugbaAndDepartmentHTML( aHash)
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { 'Статистика по службам (с разбивкой по отделениям)' }
	local aContracts := {}, aSlugba := {}, aDepartments := {}
	local itemDepartment, itemSlugba, itemService
	local rowspanDepartment := "1"
	local flagSlugba := .f.
	local stSlugba := '', counterSlugba := 0
	local stDep := '', counterDepartment := 0
	local item, iRowDepartment
	local totalQuantity := 0, totalSumm := 0
	
	oDoc := CreateReportHTML( 'Статистика по службам (с разбивкой по отделениям)' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-я, 2-я, 3-я колонки
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="3"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Служба'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Подразделение'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 6-я колонка
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
	oParag:text		:= 'Наименование'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Стоимость услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )

			for each itemService in item:Services()
				if isnil( itemService:Service:Slugba )
					loop
				endif
				if isnil( itemService:Subdivision )
					loop
				endif
				stSlugba := alltrim( itemService:Service:Slugba:Name1251 )
				if ( counterSlugba := hb_ascan( aSlugba, { | x | x[ 1 ] == stSlugba } ) ) == 0
					// список aSlugba {название, количество услуг, общая сумма, список подразделений, количество подразделений}
					aadd( aSlugba, { stSlugba, 0, 0, {}, 0 } )
					counterSlugba := hb_ascan( aSlugba, { | x | x[ 1 ] == stSlugba } )
				endif
				
				aDepartments := aSlugba[ counterSlugba, 4 ]
				stDep := alltrim( itemService:Subdivision:Name1251 )
				if ( counterDepartment := hb_ascan( aDepartments, { | x | x[ 1 ] == stDep } ) ) == 0
					// список aDepartments {название, количество , общая сумма}
					aadd( aDepartments, { stDep, 0, 0 } )
					aSlugba[ counterSlugba, 5 ] += 1
					counterDepartment := hb_ascan( aDepartments, { | x | x[ 1 ] == stDep } )
				endif
					
				aDepartments[ counterDepartment, 2 ] += itemService:Quantity
				aDepartments[ counterDepartment, 3 ] += itemService:Total
				aSlugba[ counterSlugba, 2 ] += itemService:Quantity
				aSlugba[ counterSlugba, 3 ] += itemService:Total
				aSlugba[ counterSlugba, 4 ] := aDepartments
				totalQuantity += itemService:Quantity
				totalSumm += itemService:Total
			next
		endif
	next
	asort( aSlugba, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemSlugba in aSlugba
		flagSlugba := .f.
		rowspanDepartment := lstr( itemSlugba[ 5 ] )
		aDepartments := itemSlugba[ 4 ]
		
		iRowDepartment := 0
		for each itemDepartment in aDepartments
			iRowDepartment += 1
			if iRowDepartment == len( aDepartments )
				strClass := 'class="td1"'
			else
				strClass := 'class="td11"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagSlugba
				// 1-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanDepartment + '"'
				oCell:text := itemSlugba[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 2-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanDepartment + '"'
				oCell:text := lstr( itemSlugba[ 2 ] )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			
				// 3-я колонка
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanDepartment + '"'
				oCell:text := put_kopE( itemSlugba[ 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			
				flagSlugba := .t.
			endif
			// 4-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemDepartment[ 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text := lstr( itemDepartment[ 2 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 6-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td3" valign="center" align="right"'
			oCell:text := put_kopE( itemDepartment[ 3 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
	
	// Подвал отчета
	oRow	:= oTable + 'tr'
	// 1-я, 2-я, 3-я, 4-я колонки
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="4"'
	oCell:text := 'И Т О Г О:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-я колонка
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := totalQuantity
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-я колонка
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( totalSumm, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil
