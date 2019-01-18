* 03.10.18 ReportPaidSenderDoctorServices( aHash ) - Статистика по направившим врачам с расшифровкой по услугам
* 03.10.18 ReportPaidSenderDoctorPatients( aHash ) - Список врачей направивших на планые услуги
* 16.08.18 addDoctor( oTable, aDoctors, first ) - Добавление строк по врачам
* 16.08.18 addSubdivisions( oTable, aSubdivisions, first ) - Добавление строк по подразделениям

#include 'hbthread.ch'
#include 'function.ch'

#define	REP_DEPARTMENT	1
#define REP_SUBDIVISION	2

* 03.10.18 Список врачей направивших на планые услуги
function ReportPaidSenderDoctorPatients( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local uch_old := '', uch_kol := uch_sum := j := 0
	local aTitle := { 'Врачи, направившие на платное лечение' }
	local tmpArr := {}, counter := 0
	local aDepartments := {}, aSubdivisions := {}, aDoctors := {}
	local aContract, item
	local stDep := '', stSub := '', stFIO := '',	compl := ''
	local rowspanSub := '', rowspan := ''

	oDoc := CreateReportHTML( 'Врачи, направившие на платное лечение' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	
	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Филиал'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Отделение'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Врач'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во пациентов'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Сумма лечения'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 6-я и 7-я колонки
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Итого по отделению'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 8-я и 9-я колонки
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom thright" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Итого по филиалу'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 6-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во пациентов'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 7-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Сумма лечения'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 8-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во пациентов'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 9-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Сумма лечения'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )

	aContract := TContractDB():getListByCondition( aHash )
	
	for each item in aContract
		if item:SendDoctor != nil .and. IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID )
			stDep := alltrim( TDepartmentDB():getByID( item:SendDoctor:Department ):Name1251)
			stSub := alltrim( TSubdivisionDB():getByID( item:SendDoctor:Subdivision ):Name1251)
			stFIO := alltrim(item:SendDoctor:FIO1251)
			compl := stDep + stSub + stFIO

			aDoctors := {}
			aSubdivisions := {}
			if ( counter := hb_ascan( aDepartments, { | x | x[ 1 ] = stDep } ) ) == 0
				aadd( aDoctors, { stFIO, 1, item:Total, item:SendDoctor:TabNom } )
				aadd( aSubdivisions, { stSub, 1, item:Total, aDoctors, 1 } )
				aadd( aDepartments, { stDep, 1, item:Total, aSubdivisions, 1 } )
			else
				aDepartments[ counter, 2 ] += 1
				aDepartments[ counter, 3 ] += item:Total
				aSubdivisions := aDepartments[ counter, 4 ]
				if ( countSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] = stSub } ) ) == 0
					aadd( aDoctors, { stFIO, 1, item:Total, item:SendDoctor:TabNom } )
					aadd( aSubdivisions, { stSub, 1, item:Total, aDoctors, 1 } )
					aDepartments[ counter, 5 ] += 1
					aDepartments[ counter, 4 ] := aSubdivisions
				else
					aSubdivisions[ countSub, 2 ] += 1
					aSubdivisions[ countSub, 3 ] += item:Total
					aDoctors := aSubdivisions[ countSub, 4 ]
					if ( countDoctor := hb_ascan( aDoctors, { | x | x[ 1 ] = stFIO } ) ) == 0
						aadd( aDoctors, { stFIO, 1, item:Total, item:SendDoctor:TabNom } )
						aSubdivisions[ countSub, 5 ] += 1
						aDepartments[ counter, 5 ] += 1
					else
						aDoctors[ countDoctor, 2 ] += 1
						aDoctors[ countDoctor, 3 ] += item:Total
						aSubdivisions[ countSub, 4 ] := aDoctors
						aDepartments[ counter, 4 ] := aSubdivisions
					endif
				endif
			endif
			
		endif
	next
	asort( aDepartments, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each item in aDepartments
		aSubdivisions := item[ 4 ]
		aDoctors := aSubdivisions[ 1, 4 ]
		rowspan := lstr( item[ 5 ] )
		rowspanSub := lstr( aSubdivisions[ 1, 5 ] )
		
		if len( aDoctors ) = 1
			strClass := 'class="td1"'
		else
			strClass := 'class="td11"'
		endif
		
		// 1-я колонка
		oRow		:= oTable + 'tr'
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspan + '"'
		oCell:text	:= item[ 1 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 2-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSub + '"'
		oCell:text	:= aSubdivisions[ 1, 1 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 3-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="left"'
		oCell:text	:= '[' + lstr( aDoctors[ 1, 4 ] ) + '] ' + aDoctors[ 1, 1 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 4-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="center"'
		oCell:text	:= lstr( aDoctors[ 1, 2 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 5-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="right"'
		oCell:text	:= put_kopE( aDoctors[ 1, 3 ], 12 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 6-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanSub + '"'
		oCell:text	:= lstr( aSubdivisions[ 1, 2 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 7-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" align="right" rowspan="' + rowspanSub + '"'
		oCell:text	:= put_kopE( aSubdivisions[ 1, 3 ], 12 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 8-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspan + '"'
		oCell:text	:= lstr( item[ 2 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 9-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center" align="right" rowspan="' + rowspan + '"'
		oCell:text	:= put_kopE( item[ 3 ], 12 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		addDoctor( oTable, aSubdivisions[ 1, 4 ], .t. )
		for i = 2 to len( aSubdivisions )
			addSubdivisions( oTable, aSubdivisions, .t. )
		next
	next
	
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	ViewHTML( oDoc )
	return nil

* 16.08.18 Добавление строк по подразделениям
function addSubdivisions( oTable, aSubdivisions, first )
	local strClass := '', oRow, oCell, oParag
	local nStart := iif( first, 2, 1 )
	local rowspanSub := '', item
	
	for i = nStart to len( aSubdivisions )
		item := aSubdivisions[ i ]
		aDoctors := item[ 4 ]
		rowspanSub := alltrim( str( item[ 5 ] ) )
	
		oRow		:= oTable + 'tr'
		// 2-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSub + '"'
		oCell:text	:= item[ 1 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 3-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= '[' + lstr( aDoctors[ 1, 4 ] ) + '] ' + aDoctors[ 1, 1 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 4-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text	:= lstr( aDoctors[ 1, 2 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 5-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="right"'
		oCell:text	:= put_kopE( aDoctors[ 1, 3 ], 12 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 6-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanSub + '"'
		oCell:text	:= lstr( item[ 2 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 7-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanSub + '"'
		oCell:text	:= put_kopE( item[ 3 ], 12 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		addDoctor( oTable, aDoctors, .t. )
	next
	return nil
	
* 16.08.18 Добавление строк по врачам
function addDoctor( oTable, aDoctors, first )
	local strClass := '', oRow, oCell, oParag
	local nStart := iif( first, 2, 1 )
	local item

	for iRow = nStart to len( aDoctors )
		item := aDoctors[ iRow ]
		if iRow = len( aDoctors )
			strClass := 'class="td1"'
		else
			strClass := 'class="td11"'
		endif
		
		oRow		:= oTable + 'tr'
		
		// 3-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="left"'
		oCell:text	:= '[' + lstr( item[ 4 ] ) + '] ' + item[ 1 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 4-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="center"'
		oCell:text	:= lstr( item[ 2 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 5-я колонка
		oCell		:= oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="right"'
		oCell:text	:= put_kopE( item[ 3 ], 12 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oRow		:= oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	next
	return nil
	
* 03.10.18 Статистика по направившим врачам с расшифровкой по услугам
function ReportPaidSenderDoctorServices( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { 'Врачи, направившие на платное лечение' }
	local tmpArr := {}, counter := 0, counterSer := 0
	local aDoctors := {}, aServices := {}
	local aContract, item, itemService
	local stFIO := '',	stService := ''
	local rowspan := ''
	local quantity := 0, total := 0

	oDoc := CreateReportHTML( 'Врачи, направившие на платное лечение' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Врач'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-я, 3-я, 4-я колонки
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="3"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Услуга'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-я, 6-я колонки
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom thright" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Итого'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 2-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Название'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Стоимость услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-я колонка
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Стоимость услуг'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	
	aContract := TContractDB():getListByCondition( aHash )
	for each item in aContract
		quantity := 0
		total := 0
		if item:SendDoctor != nil
			stFIO := alltrim( item:SendDoctor:FIO1251 )
			if ( counter := hb_ascan( aDoctors, { | x | x[ 1 ] == stFIO } ) ) == 0
				quantity := 0
				total := 0
				aServices := {}
				// список aDoctors {ФИО, общее количество, общая сумма, список услуг}
				aadd( aDoctors, { stFIO, quantity, total, aServices, item:SendDoctor:TabNom, 0 } )
				counter := hb_ascan( aDoctors, { | x | x[ 1 ] == stFIO } )
			endif
			quantity := aDoctors[ counter, 2 ]
			total := aDoctors[ counter, 3 ]
			aServices := aDoctors[ counter, 4 ]
			
			for each itemService in item:Services()
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterSer := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// список aServices {шифр услуги, наименование услуги, общее количество, общая сумма}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0 } )
					aDoctors[ counter, 6 ] += 1
					counterSer := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
				aServices[ counterSer, 3 ] += itemService:Quantity
				aServices[ counterSer, 4 ] += itemService:Total
				quantity += itemService:Quantity
				total += itemService:Total
			next
			aDoctors[ counter, 2 ] := quantity
			aDoctors[ counter, 3 ] := total
			aDoctors[ counter, 4 ] := aServices
		endif
	next
	asort( aDoctors, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each item in aDoctors
		rowspan := lstr( item[ 6 ] )
		
		if item[ 6 ] == 1
			strClass := 'class="td1"'
		else
			strClass := 'class="td11"'
		endif
		
		// 1-я колонка
		oRow       := oTable + 'tr'
		
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspan + '"'
		oCell:text := '[' + lstr( item[ 5 ] ) + '] ' + item[ 1 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 2-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="left"'
		oCell:text := item[ 4 ][ 1, 1 ] + ' ' + item[ 4 ][ 1, 2 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="center"'
		oCell:text := lstr( item[ 4 ][ 1, 3 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 4-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="right"'
		oCell:text := put_kopE( item[ 4 ][ 1, 4 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 5-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspan + '"'
		oCell:text := lstr( item[ 2 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 6-я колонка
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center" align="right" rowspan="' + rowspan + '"'
		oCell:text := put_kopE( item[ 3 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		for iRow = 2 to item[ 6 ]
			if iRow == item[ 6 ]
				strClass := 'class="td1"'
			else
				strClass := 'class="td11"'
			endif
			oRow		:= oTable + 'tr'

			// 2-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := item[ 4 ][ iRow, 1 ] + ' ' + item[ 4 ][ iRow, 2 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 3-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := lstr( item[ 4 ][ iRow, 3 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 4-я колонка
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="right"'
			oCell:text := put_kopE( item[ 4 ][ iRow, 4 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil