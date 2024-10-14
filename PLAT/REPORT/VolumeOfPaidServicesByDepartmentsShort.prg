* 30.05.17 VolumeOfPaidServicesByDepartmentsShort( aHash, aReport, cTypeEnded, typeReport )
* 10.05.17 CreateReportHTMLOld( cTitle ) - сформировать заголовок HTML отчета	
*******************************************************************************

#include "hbthread.ch"
#include "function.ch"
#include "edit_spr.ch"
&& #include "f_fr_bay.ch"

#define SUBDIVISION	1
#define EMPLOYEE	2
#define SERVICE		3
#define EMP_SERVICE	4

* сформировать заголовок HTML отчета	
function CreateReportHTMLOld( cTitle )
	local oDoc, oNode, oForm, oButton
	// local item, cFile, tmpDir, aFiles := { 'chip_mo.css', 'chip_mo.js', 'jquery-3.2.1.min.js' }
	local item, cFile, tmpDir, aFiles := { 'chip_mo.css', 'chip_mo.js' }

	tmpDir := hb_DirTemp()
	// вначале запишем необходимые файлы во временный каталог
	for each item in aFiles
		cFile := dir_exe() + item
		if file( cFile )
			__CopyFile( cFile, tmpDir + item )
		endif
	next
	
	// формируем HTML-документ
	oDoc          := THtmlDocument():new()
	/* Operator "+" creates a new node */
	oNode         := oDoc:head + 'meta'
	oNode:name    := 'Generator'
	oNode:content := 'text/html; charset=windows-1251'
	oNode         := oDoc:head   + 'title'
	oNode:text    := alltrim( cTitle )
	
	// прикрепим таблицу стилей дл¤ монитора
	oNode			:= oDoc:head   + 'link'
	oNode:type		:= 'text/css'
	oNode:rel		:= 'stylesheet'
	oNode:href		:= 'chip_mo.css'

	// прикрепим кнопку печати
	oForm			:= oDoc:body:form
	oForm:id		:= 'print'
	oButton			:= oForm + 'input type="submit"'
	oButton:value	:= 'Печать отчета'
	oButton			:= oButton - 'input'
	HB_SYMBOL_UNUSED( oForm )

	// прикрепим скрипт
	oNode			:= oDoc:body + 'script'
	// oNode:text		:= hb_eol() + "document.getElementById('print').onsubmit = function() {" + hb_eol() + ;
						// "window.print();" + hb_eol() + ;
						// 'return false;' + hb_eol() + ;
						// '};' + hb_eol()
    oNode:src		:= 'chip_mo.js'
	// HB_SYMBOL_UNUSED( oForm )
	return oDoc
	

* 30.05.17
function VolumeOfPaidServicesByDepartmentsShort( aHash, aReport )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable, oNodeTitle
	local item, sumTotal := 0, totalAmount := 0
	local aPatient := {}, i
	local typeReport := 0
	local aService, itemService

	oDoc := CreateReportHTMLOld( 'Объем работы' )
	CreateTitelStatistics( oDoc, aHash )
	typeReport := aHash[ 'TYPEREPORT' ]
	
	oTable        := oDoc:body:table
	&& oTable:attr   := 'border="1" width="100%" cellspacing="0" cellpadding="5"'
	oTable:attr   := 'class="Statistics"'
	
	oHTable		:= oTable + 'thead'
	oRow		:= oTable  + 'tr'
	//
	oCell     := oRow + 'th width:40%'
	if typeReport != 7
		oCell:text := 'Ф. И. О.'
	else
		oCell:text := 'Ф. И. О. больного, наименование услуги'
	endif
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	if typeReport != 7 .and. typeReport != 8
		oCell     := oRow + 'th width:10%'
		oCell:text := 'Отделение'
		oCell     := oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
	endif
	//
	oCell     := oRow + 'th width:10%'
	oCell:text := 'Дата окончания лечения'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	if typeReport == 7
		oCell     := oRow + 'th width:10%'
		oCell:text := 'Стоимость договора'
		oCell     := oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
	elseif typeReport == 8
		oCell     := oRow + 'th width:10%'
		oCell:text := 'Учреждение'
		oCell     := oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
		oCell     := oRow + 'th width:10%'
		oCell:text := 'Отделение'
		oCell     := oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
	endif
	//
	if typeReport != 7
		oCell     := oRow + 'th width:20%'
		oCell:text := 'Количество услуг'
		oCell     := oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
	endif
	//
	oCell     := oRow + 'th width:20%'
	oCell:text := 'Стоимость услуг'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	oRow := oRow - 'tr'
	HB_SYMBOL_UNUSED( oRow )
	oHTable			:= oHTable - 'thead'
	HB_SYMBOL_UNUSED( oHTable )
	
	oBTable			:= oTable + 'tbody'
	for each item in aReport
		if ( i := ascan( aPatient, { | x | x == item[ 6 ] } ) ) == 0
			aadd( aPatient , item[ 6 ] )
		endif
		// добавим строку
		oRow       := oTable + 'tr'
		// заполним столбцы
		oCell      := oRow + 'td'
		oCell:text := item[ 6 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		//
		if typeReport != 7 .and. typeReport != 8
			oCell      := oRow + 'td'
			oCell:text := item[ 5 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		endif
		//
		oCell      := oRow + 'td class="date"'
		oCell:text := item[ 7 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		//
		if typeReport == 8
			oCell      := oRow + 'td'
			oCell:text := item[ 8 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			oCell      := oRow + 'td'
			oCell:text := item[ 5 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		endif
		//
		if typeReport == 7
			oCell      := oRow + 'td class="sum"'
			oCell:text := put_kopE( item[ 5 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		else
			oCell      := oRow + 'td class="quantity"'
			oCell:text := str( item[ 1 ], 7, 0 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			totalAmount += item[ 1 ]
			
			oCell      := oRow + 'td class="sum"'
			oCell:text := put_kopE( item[ 2 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			sumTotal += item[ 2 ]
		endif
		
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
		if typeReport == 7
			for each itemService in item[ 1 ]
				oRow       := oTable + 'tr'
				oCell      := oRow + 'td colspan="3" class="service"'
				oCell:text := itemService[ 3 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oCell      := oRow + 'td class="sum"'
				oCell:text := put_kopE( itemService[ 2 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				oRow := oRow - 'tr'
				HB_SYMBOL_UNUSED( oRow )
			next
		endif
	next
	oBTable	:= oBTable - 'tbody'
	
	// подвал отчета
	if typeReport != 7 .and. typeReport != 8
		oNodeTitle      := oDoc:body
		oNodeTitle      := oNodeTitle + 'div class="totalreport"'
		&& oNode         := oDoc:body
		&& oNode         := oNode   + 'div'
		&& oNode:text    := 'И Т О Г О'
		&& oNode         := oNode   - 'div'
		oNode         := oNodeTitle
		oNode         := oNode + 'div id="CaptionTotal"'
		oNode:text    := 'И Т О Г О'
		oNode         := oNode - 'div'
	
		&& oNode         := oDoc:body
		oNode         := oNodeTitle
		oNode         := oNode   + 'div'
		oNode:text    := 'Количество пациентов - ' + alltrim( str( len( aPatient ), 7 ) )
		oNode         := oNode   - 'div'
		
		oNode         := oNodeTitle
		oNode         := oNode   + 'div'
		oNode:text    := 'Количество услуг - ' + str( totalAmount, 7 )
		oNode         := oNode   - 'div'
		&& oNode         := oDoc:body
		
		oNode         := oNodeTitle
		oNode         := oNode   + 'div'
		oNode:text    := 'Стоимость услуг - ' + put_kopE( sumTotal, 15 )
		oNode         := oNode   - 'div'
		
		oNodeTitle     := oNodeTitle - 'div'
	endif
	ViewHTML( oDoc )
	return nil	
