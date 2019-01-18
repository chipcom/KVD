* RepPaidStatisticsOutput.prg - работа с отчетами статистики по платным услугам
*******************************************************************************
* 30.05.17 CreateTitelStatistics( oDoc, aHash ) - создание шапки отчета выходная форма
* 30.05.17 VolumeOfPaidServicesByDepartments( aHash, aReport ) - Объем работы по отделениям по платным услугам выходная форма
*******************************************************************************

#include "hbthread.ch"
#include "function.ch"
#include "edit_spr.ch"
&& #include "f_fr_bay.ch"

#define SUBDIVISION	1
#define EMPLOYEE	2
#define SERVICE		3
#define EMP_SERVICE	4


* 30.05.17 Объем работы по отделениям по платным услугам выходная форма
function VolumeOfPaidServicesByDepartments( aHash, aReport )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable, oNodeTitle
	local item, sumTotal := 0, totalAmount := 0
	local sumTotalDoctor := 0, totalAmountDoctor := 0
	local sumTotalAssistant := 0, totalAmountAssistant := 0
	local subTotalDoctor := 0, subAmountDoctor := 0
	local subTotalAssistant := 0, subAmountAssistant := 0
	local tmpEmployer := '', lEmployer := .f., tmpTabNom, tmpEmployerPos
	local typeReport := 0

	local aTitle := { 'Объем работы' }
		
	oDoc := CreateReportHTML( 'Объем работы' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	
	
	typeReport := aHash[ 'TYPEREPORT' ]
	
	oTable := oDoc:body:table
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	&& oTable:attr := 'class="statistics"'
	
	&& oHTable	:= oTable + 'thead'
	oRow := oTable + 'tr'
	oRow:attr	:= 'id="main" bgcolor="#4CAF50" style="page-break-inside:avoid"'
	//
	if typeReport == SUBDIVISION
		&& oCell := oRow + 'th width:50%'
		&& oCell:text := 'ОТДЕЛЕНИЕ'
		oCell		:= oRow + 'th'
		oCell:attr	:= 'class="thleft"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'align="center" class="bodyp"'
		oParag:text	:= 'ОТДЕЛЕНИЕ'
		oParag		:= oParag - 'p'
	elseif typeReport == EMPLOYEE
		&& oCell := oRow + 'th colspan="2" width:50%'
		&& oCell:text := 'СОТРУДНИК'
		oCell		:= oRow + 'th colspan="2"'
		oCell:attr	:= 'class="thleft"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'align="center" class="bodyp"'
		oParag:text	:= 'СОТРУДНИК'
		oParag		:= oParag - 'p'
	elseif typeReport == SERVICE
		&& oCell := oRow + 'th colspan="2" width:50%'
		&& oCell:text := 'УСЛУГА'
		oCell		:= oRow + 'th colspan="2"'
		oCell:attr	:= 'class="thleft"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'align="center" class="bodyp"'
		oParag:text	:= 'УСЛУГА'
		oParag		:= oParag - 'p'
	elseif typeReport == EMP_SERVICE
		&& oCell := oRow + 'th colspan="3" width:50%'
		&& oCell:text := ''
		oCell		:= oRow + 'th colspan="3"'
		oCell:attr	:= 'class="thleft"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'align="center" class="bodyp"'
		oParag:text	:= ''
		oParag		:= oParag - 'p'
	endif
	oCell := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	&& oCell := oRow + 'th width:20%'
	&& oCell:text := 'Количество услуг'
	oCell		:= oRow + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag		:= oCell + 'p'
	oParag:attr	:= 'align="center" class="bodyp"'
	oParag:text	:= 'Количество услуг'
	oParag		:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	&& oCell := oRow + 'th width:30%'
	&& oCell:text := 'Стоимость услуг'
	oCell		:= oRow + 'th'
	oCell:attr	:= 'class="thleft-right"'
	oParag		:= oCell + 'p'
	oParag:attr	:= 'align="center" class="bodyp"'
	oParag:text	:= 'Стоимость услуг'
	oParag		:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	oRow := oRow - 'tr'
	HB_SYMBOL_UNUSED( oRow )
	&& oHTable	:= oHTable - 'thead'
	&& HB_SYMBOL_UNUSED( oHTable )
	
	&& oBTable	:= oTable + 'tbody'
	for each item in aReport
		if typeReport == EMP_SERVICE
			if empty( tmpEmployer ) .and. !empty( item[ 4 ] )
				lEmployer := .t.
				tmpEmployer := item[ 4 ]
				tmpTabNom := item[ 7 ]
				tmpEmployerPos := item[ 5 ]
			elseif !empty( tmpEmployer ) .and. tmpEmployer != item[ 4 ]
				oRow := oTable + 'tr'
				oCell := oRow + 'td'
				oCell:text := '(' + alltrim( str( tmpTabNom, 7 ) ) + ')'
				oCell := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oCell := oRow + 'td'
				oCell:text := tmpEmployer	//item[ 4 ]
				oCell := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oCell := oRow + 'td'
				oCell:text := tmpEmployerPos	//item[ 5 ]
				oCell := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oCell := oRow + 'td class="total-quantity"'
				oCell:text := if( tmpEmployerPos == 'врач', str( subAmountDoctor, 7, 0 ), str( subAmountAssistant, 7, 0 ) )
				oCell := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oCell := oRow + 'td class="total-sum"'
				oCell:text := if( tmpEmployerPos == 'врач', put_kopE( subTotalDoctor, 15 ), put_kopE( subTotalAssistant, 15 ) )
				oCell := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oRow := oRow - 'tr'
				HB_SYMBOL_UNUSED( oRow )
				tmpEmployer := item[ 4 ]
				tmpTabNom := item[ 7 ]
				tmpEmployerPos := item[ 5 ]
				subTotalDoctor := 0
				subAmountDoctor := 0
				subTotalAssistant := 0
				subAmountAssistant := 0
			endif
		endif
		// добавим строку
		oRow := oTable + 'tr'
		// заполним столбцы
		if typeReport == SUBDIVISION .or. typeReport == EMPLOYEE
			&& oCell := oRow + 'td'
			&& oCell:text := item[ 4 ]
			&& oCell := oCell - 'td'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center"  align="left"'
			oParag		:= oCell + 'p'
			oParag:attr	:= 'class="p2"'
			oCell:text	:= item[ 4 ]
			oParag		:= oParag - 'p'
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		elseif typeReport == SERVICE
			&& oCell := oRow + 'td'
			&& oCell:text := item[ 5 ]
			&& oCell := oCell - 'td'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center"  align="left"'
			oParag		:= oCell + 'p'
			oParag:attr	:= 'class="p2"'
			oCell:text	:= item[ 5 ]
			oParag		:= oParag - 'p'
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		elseif typeReport == EMP_SERVICE
			&& oCell := oRow + 'td'
			&& oCell:text := item[ 9 ]
			&& oCell := oCell - 'td'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center"  align="left"'
			oParag		:= oCell + 'p'
			oParag:attr	:= 'class="p2"'
			oCell:text	:= item[ 9 ]
			oParag		:= oParag - 'p'
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		endif
		//
		if typeReport == EMPLOYEE
			&& oCell := oRow + 'td'
			&& oCell:text := item[ 5 ]
			&& oCell := oCell - 'td'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center"  align="left"'
			oParag		:= oCell + 'p'
			oParag:attr	:= 'class="p2"'
			oCell:text	:= item[ 5 ]
			oParag		:= oParag - 'p'
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		elseif typeReport == SERVICE
			&& oCell := oRow + 'td'
			&& oCell:text := item[ 4 ]
			&& oCell := oCell - 'td'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center"  align="left"'
			oParag		:= oCell + 'p'
			oParag:attr	:= 'class="p2"'
			oCell:text	:= item[ 4 ]
			oParag		:= oParag - 'p'
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		elseif typeReport == EMP_SERVICE
			&& oCell := oRow + 'td colspan="2"'
			&& oCell:text := item[ 8 ]
			&& oCell := oCell - 'td'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center"  align="left"'
			oParag		:= oCell + 'p'
			oParag:attr	:= 'class="p2"'
			oCell:text	:= item[ 8 ]
			oParag		:= oParag - 'p'
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		endif
		//
		if typeReport == EMPLOYEE .or. typeReport == EMP_SERVICE
			if item[ 5 ] == 'врач'
				totalAmountDoctor += item[ 1 ]
				sumTotalDoctor += item[ 2 ]
				subAmountDoctor += item[ 1 ]
				subTotalDoctor += item[ 2 ]
			else
				totalAmountAssistant += item[ 1 ]
				sumTotalAssistant += item[ 2 ]
				subAmountAssistant += item[ 1 ]
				subTotalAssistant += item[ 2 ]
			endif
		endif
		//
		&& oCell := oRow + 'td class="quantity"'
		&& oCell:text := str( item[ 1 ], 7, 0 )
		&& oCell := oCell - 'td'
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center"  align="center"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'class="p2"'
		oCell:text	:= str( item[ 1 ], 7, 0 )
		oParag		:= oParag - 'p'
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		totalAmount += item[ 1 ]
		
		&& oCell := oRow + 'td class="sum"'
		&& oCell:text := put_kopE( item[ 2 ], 15 )
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center"  align="right"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'class="p2"'
		oCell:text	:= put_kopE( item[ 2 ], 15 )
		oParag		:= oParag - 'p'
		oCell		:= oCell - 'td'
		
		HB_SYMBOL_UNUSED( oCell )
		sumTotal += item[ 2 ]
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	next
	if lEmployer .and. typeReport == EMP_SERVICE
		oRow := oTable + 'tr'
		oCell := oRow + 'td'
		oCell:text := '(' + alltrim( str( tmpTabNom, 7 ) ) + ')'
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td'
		oCell:text := tmpEmployer
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td'
		oCell:text := tmpEmployerPos
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td class="total-quantity"'
		oCell:text := if( tmpEmployerPos == 'врач', str( subAmountDoctor, 7, 0 ), str( subAmountAssistant, 7, 0 ) )
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		oCell := oRow + 'td class="total-sum"'
		oCell:text := if( tmpEmployerPos == 'врач', put_kopE( subTotalDoctor, 15 ), put_kopE( subTotalAssistant, 15 ) )
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	endif
	// итоговые строки
	oRow := oTable + 'tr'
	oCell		:= oRow + 'td'
	if typeReport == SUBDIVISION
		&& oCell := oRow + 'td class="total-string"'
		oCell:attr	:= 'class="td1" valign="center"  align="right"'
	elseif typeReport == EMPLOYEE
		&& oCell := oRow + 'td colspan="2" class="total-string"'
		oCell:attr	:= 'class="td1" valign="center"  align="right" colspan="2"'
	elseif typeReport == SERVICE
		&& oCell := oRow + 'td colspan="2" class="total-string"'
		oCell:attr	:= 'class="td1" valign="center"  align="right" colspan="2"'
	elseif typeReport == EMP_SERVICE
		&& oCell := oRow + 'td colspan="3" class="total-string"'
		oCell:attr	:= 'class="td1" valign="center"  align="right" colspan="3"'
	endif
	&& oCell:text := 'И Т О Г О'
	&& oCell := oCell - 'td'
	oParag		:= oCell + 'p'
	oParag:attr	:= 'class="p11"'
	oCell:text	:= 'И Т О Г О'
	oParag		:= oParag - 'p'
	oCell		:= oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	if typeReport == SUBDIVISION .or. typeReport == SERVICE
		&& oCell := oRow + 'td class="total-quantity"'
		&& oCell:text := str( totalAmount, 7 )
		&& oCell := oCell - 'td'
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center"  align="center"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'class="p11"'
		oCell:text	:= str( totalAmount, 7 )
		oParag		:= oParag - 'p'
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		&& oCell := oRow + 'td class="total-sum"'
		&& oCell:text := put_kopE( sumTotal, 15 )
		&& oCell := oCell - 'td'
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center"  align="right"'
		oParag		:= oCell + 'p'
		oParag:attr	:= 'class="p11"'
		oCell:text	:= put_kopE( sumTotal, 15 )
		oParag		:= oParag - 'p'
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	endif
	oRow := oRow - 'tr'
	HB_SYMBOL_UNUSED( oRow )
	if typeReport == EMPLOYEE .or. typeReport == EMP_SERVICE
		oRow := oTable + 'tr'
		if typeReport == EMPLOYEE
			oCell := oRow + 'td colspan="2" class="subtotal-string"'
		else
			oCell := oRow + 'td colspan="3" class="subtotal-string"'
		endif
		oCell:text := 'из них врачи'
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td class="total-quantity"'
		oCell:text := str( totalAmountDoctor, 7 )
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td class="total-sum"'
		oCell:text := put_kopE( sumTotalDoctor, 15 )
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
		oRow := oTable + 'tr'
		if typeReport == EMPLOYEE
			oCell := oRow + 'td colspan="2" class="subtotal-string"'
		else
			oCell := oRow + 'td colspan="3" class="subtotal-string"'
		endif
		oCell:text := 'ассистенты'
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td class="total-quantity"'
		oCell:text := str( totalAmountAssistant, 7 )
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oCell := oRow + 'td class="total-sum"'
		oCell:text := put_kopE( sumTotalAssistant, 15 )
		oCell := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	endif
	
	&& oBTable	:= oBTable - 'tbody'
	ViewHTML( oDoc )
	return nil
	

* 30.05.17 Создадим шапку отчета выходная форма
function CreateTitelStatistics( oDoc, aHash )
	local oNode, oTable, oRow, oCell, oHTable, oBTable, oNodeTitle
	local typeReport := 0

	oNodeTitle := oDoc:body
	oNodeTitle := oNodeTitle + 'div class="title"'
	// название отчета
	oNode := oNodeTitle
	oNode := oNode + 'h1'
	typeReport := aHash[ 'TYPEREPORT' ]
	if typeReport == SUBDIVISION
		oNode:text := 'СТАТИСТИКА ПО ОТДЕЛЕНИЯМ'
	elseif typeReport == EMPLOYEE
		oNode:text := 'СТАТИСТИКА ПО СОТРУДНИКАМ'
	elseif typeReport == SERVICE
		oNode:text := 'СТАТИСТИКА ПО УСЛУГАМ'
	elseif typeReport == EMP_SERVICE
		oNode:text := 'СТАТИСТИКА ПО СОТРУДНИКАМ И УСЛУГАМ'
	else
		oNode:text    := 'СТАТИСТИКА ПО ОТДЕЛЕНИЯМ'
	endif
	oNode := oNode - 'h1'

	// список подразделений
	oNode := oNodeTitle
	oNode := oNode + 'h3'
	if empty( aHash[ 'SELECTEDDEPARTMENT' ] )
		oNode:text := titleSubdivisionForHTML( aHash[ 'SELECTEDSUBDIVISION' ] )
	else
		oNode:text := titleDepartmentForHTML( aHash[ 'SELECTEDDEPARTMENT' ], aHash[ 'SELECTEDPERIOD' ] )
	endif
	oNode := oNode - 'h3'
	// вид окончания лечения по которому составляется отчет
	oNode := oNodeTitle
	oNode := oNode + 'h3'
	oNode:text := aHash[ 'TYPEENDED' ]
	oNode := oNode - 'h3'
	// вид платные, ДМС, взаимозачет
	oNode := oNodeTitle
	oNode := oNode + 'h3'
	oNode:text := aHash[ 'STRINGFORPRINT' ]
	oNode := oNode - 'h3'
	// временной промежуток отчета
	oNode := oNodeTitle
	oNode := oNode + 'h2'
	oNode:text := win_OemToAnsi( aHash[ 'SELECTEDPERIOD' ][ 4 ] )
	oNode := oNode - 'h2'
	if typeReport > 4
		oNode         := oNodeTitle
		oNode         := oNode + 'h3'
		if typeReport == 5
			oNode:text    := 'Список больных, которым была оказана услуга:'
		elseif typeReport == 6
			oNode:text    := 'Список больных, которым были оказаны услуги врачом (ассистентом):'
		elseif typeReport == 8
			oNode:text    := 'Список больных, которым были оказаны услуги'
		endif
		oNode         := oNode - 'h3'
		if typeReport == 5 .or. typeReport == 6
			oNode         := oNodeTitle
			oNode         := oNode   + 'h2'
			oNode:text    := aHash[ 'SUBTITLE' ]
			oNode         := oNode - 'h2'
		endif
	endif
	oNodeTitle     := oNodeTitle - 'div'
	return oDoc
	