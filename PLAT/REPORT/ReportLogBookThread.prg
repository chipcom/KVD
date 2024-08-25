* 02.10.18 ReportLogBookThread() Журнал регистрации

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'common.ch'

#require 'hbtip'

// 24.08.24 Журнал регистрации
function ReportLogBookThread( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	local totalAmount := 0, totalContract := 0
	local oDepartment := nil, oChief := nil
	local strClass := '', strClass1 := ''
	local aTitle := { 'Журнал регистрации', 'учета заказов на оказание платных медицинских услуг (помощи)' }
	local aContracts := {}, aPatient := {}, aServices := {}, aLogBook := {}
	local rowLogBook := '1'
	local flagPatient := .f.
	local flagPatientAdd := .f.
	local iRowService := 0
	local stService := '', counterService
	local oPatient
	local itemContract, itemService

		
//ContractsToJson( aHash, aContracts )
	
	oDoc := CreateReportHTML( 'Журнал регистрации' )
	
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'
	// первая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Ф. И. О., адрес застрахованного'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// вторая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'НОМЕР мед. карты'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// третья - седьмая колонки
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft-wo-bottom" colspan="5"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Медицинская услуга'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// восьмая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Дата оплаты'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	oTH				:= oTH - 'tr'
	
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'
	// третья колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Наименование'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// четвертая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Цена (руб)'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// пятая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Кол-во'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// шестая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Сумма (руб)'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// седьмая колонка
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Дата оказания'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	oTH				:= oTH - 'tr'
//	

	HB_SYMBOL_UNUSED( oTH )

	aContracts := TContractDB():getListByCondition( aHash )
	for each itemContract in aContracts
		oPatient := itemContract:Patient
		if isnil( oPatient )
			loop
		endif
		aServices := {}
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )

			// список aPatient {объект пациента, дата оплаты, список услуг, кол-во услуг, общая суммв}
			aPatient := { oPatient, itemContract:DatePay, {}, 0, 0 }
				
			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// список aServices {шифр, название, цена, количество , общая сумма, дата оказания}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), itemService:Price, 0, 0, itemService:Date } )
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
				aServices[ counterService, 4 ] += itemService:Quantity
				aServices[ counterService, 5 ] += itemService:Total
				aPatient[ 5 ] += itemService:Total
			next
			aPatient[ 3 ] := aServices
			aPatient[ 4 ] := len( aServices )
			
			aadd( aLogBook, aPatient )
		endif
		
	next
	for each rowLogBook in aLogBook
		rowspanPatient := lstr( rowLogBook[ 4 ] )
		flagPatient := .f.
		flagPatientAdd := .f.
		aServices := rowLogBook[ 3 ]
		++totalContract
		
		iRowService := 0
		for each itemService in aServices
			iRowService += 1
			if iRowService == len( aServices )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagPatient
				// 1-я колонка
				oRow		:= oTable + 'tr'
				oRow:attr	:= 'class="row"'
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center"  align="left" rowspan="' + rowspanPatient + '"'
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p1"'
				oParag:text	:= alltrim( rowLogBook[ 1 ]:FIO1251 )
				oParag		:= oParag - 'p'
				if ! rowLogBook[ 1 ]:IsAnonymous	// проверка на анонимного пациента
					oParag		:= oCell + 'p'
					oParag:attr	:= 'class="p2"'
					oParag:text	:= rowLogBook[ 1 ]:AddressRegistration():AsString( , 'win-1251' )
					oParag		:= oParag - 'p'
				endif
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= 'Услуг: ' + lstr( rowLogBook[ 4 ] ) + ' шт.'
				oParag		:= oParag - 'p'
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= 'Сумма: ' + put_kop( rowLogBook[ 5 ], 15 ) + ' руб.'
				oParag		:= oParag - 'p'
				oCell		:= oCell - 'td'
				// 2-я колонка
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1 p1" valign="center"  align="center" rowspan="' + rowspanPatient + '"'
				oCell:text	:= lstr( rowLogBook[ 1 ]:ID() )
				oCell		:= oCell - 'td'
				flagPatient := .t.
			endif
			// 3-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text	:= itemService[2]
			oCell		:= oCell - 'td'
			// 4-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= put_kop( itemService[ 3 ], 7 )
			oCell		:= oCell - 'td'
			// 5-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= lstr( itemService[ 4 ] )
			oCell		:= oCell - 'td'
			// 5-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= put_kop( itemService[ 5 ], 7 )
			oCell		:= oCell - 'td'
			// 6-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= full_date( itemService[ 6 ] )
			oCell		:= oCell - 'td'
			if ! flagPatientAdd
				// 7-я колонка
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td3" valign="center" align="center" rowspan="' + rowspanPatient + '"'
				oCell:text	:= full_date( rowLogBook[ 2 ] )
				oCell		:= oCell - 'td'
				flagPatientAdd := .t.
			endif
			totalAmount += itemService[ 5 ]
		next
	next
	
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	// подвал отчета
	oTable		:= oDoc:body + 'table'
	oTable:attr	:= 'id="total" class="tab" cellpadding="0" cellspacing="0" border="0"'

	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="200pt"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="200pt"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= 'Итого :'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= str( totalAmount, 11, 2 ) + ' руб.'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= 'Всего договоров:'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= str( totalContract, 11 ) + ' шт.'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	oTable		:= oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	// подписи
	oTable		:= oDoc:body + 'table'
	oTable:attr	:= 'id="sign" cellpadding="0" cellspacing="0" border="0"'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="75"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="50"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="100"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613" width="75" align="left"'
	
	if ( oDepartment := hb_user_curUser:Department ) != nil
		oNode:text	:= iif( ( oChief := oDepartment:Chief() ) != nil, alltrim( oChief:Position1251 ), 'Руководитель' )
	else
		oNode:text	:= 'Главный врач'
	endif
	oNode		:= oNode - 'td'
	
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td111" width="50" align="center"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'

	if oDepartment != nil
		oNode		:= oRow + 'td'
		oNode:attr	:= 'class="td613" width="100" align="left"'
		oNode:text	:= iif( ( oChief := oDepartment:Chief() ) != nil, oChief:ShortFIO1251, '' )
		oNode:text	:= ''
		oNode		:= oNode - 'td'
	endif
	oRow		:= oRow - 'tr'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613" width="75" align="left"'
	if ( oDepartment := hb_user_curUser:Department ) != nil
		oNode:text	:= 'Кассир'
	else
		oNode:text	:= 'Главный бухгалтер'
	endif
	oNode		:= oNode - 'td'

	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td111" width="50" align="center"'
	oNode:text	:= space( 5 )
	oNode		:= oNode - 'td'
	
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613" width="100" align="left"'
	oNode:text	:= iif( ( oDepartment := hb_user_curUser:Department ) != nil, hb_user_curUser:FIO1251, '' )
	oNode		:= oNode - 'td'
	
	oRow		:= oRow - 'tr'
	oTable		:= oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )

	ViewHTML( oDoc )
	return nil
