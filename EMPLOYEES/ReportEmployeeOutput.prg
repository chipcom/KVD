* ReportEmployeeOutput.prg - формирование HTML-отчетов по справочнику сотрудники организации
*******************************************************************************
* 06.11.18 PrintEmployees( arr ) - печать списка сотрудников
* 06.11.18 PrintLevelPayment( arr, j ) - печать уровней оплаты сотрудников
*******************************************************************************

#include "function.ch"

* 06.11.18 печать списка сотрудников
function PrintEmployees( arr )
	Local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable, oTH
	Local item, counter := 0, s := ''
	local ar := AClone( arr )
	
	oDoc := CreateReportHTML( 'Список сотрудников' )
	
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := 'Список работающих сотрудников с табельными номерами'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'

	// 1-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Табельный номер'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Ф.И.О.'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'СНИЛС'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Специальность'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )

	for each item in ar
        if between_date( item:dbegin, item:dend )
			oRow         := oTable + "tr"
						
			// 1-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text	:= alltrim( str( item:TabNom() ) ) + if( item:SvodNom != 0, ' (' + alltrim( str( item:SvodNom ) ) + ')', '' )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )

			// 2-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="left"'
			oCell:text	:= win_OEMToANSI( item:FIO )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 3-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text	:= transform( item:SNILS, picture_pf )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )

			// 4-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td3" valign="center" align="center"'
			oCell:text	:= win_OEMToANSI( ret_tmp_prvs( item:PRVS, item:PRVSNEW ) )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
						
			oRow := oRow - "tr"
			HB_SYMBOL_UNUSED( oRow )
		endif
	next
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	HB_SYMBOL_UNUSED( oNode )
	
	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := 'Список свободных табельных номеров'
	oNode         := oNode   - 'center'
	
	asort( ar, , , { | x, y | x:TabNom < y:TabNom } )
	counter := 0
    for i := 1 to len( ar )
		if ( counter := hb_ascan( ar, { | x | x:TabNom() == i } ) ) == 0
			if empty( s )
				s := lstr( i )
			else
				s += ', ' + lstr( i )
			endif
		endif
	next
	HB_SYMBOL_UNUSED( oNode )
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := s
	oNode         := oNode   - 'div'
	ViewHTML( oDoc )
	return nil
	
* 06.11.18 печать уровней оплаты сотрудников
function PrintLevelPayment( arr )
	Local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	Local item
	local ar := AClone( arr )
	
	oDoc := CreateReportHTML( 'Уровни оплаты сотрудников' )
	
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := 'Список работающих сотрудников с уровнями оплаты'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'

	// 1-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Ф.И.О.'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Класс оплаты'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-я колонка
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'Отдаленность'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	for each item in ar
        if between_date( item:dbegin, item:dend )
			oRow         := oTable + "tr"

			// 1-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="left"'
			oCell:text	:= win_OEMToANSI( padr( '[' + lstr( item:TabNom() ) + ']', 8 ) + ' ' + item:FIO )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )

			// 2-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text	:= put_val( item:Uroven(), 5 )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 3-я колонка
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td3" valign="center" align="center"'
			oCell:text	:= iif( item:Otdal(),'   да', '' )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
						
			oRow := oRow - "tr"
			HB_SYMBOL_UNUSED( oRow )

		endif
	next
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	ViewHTML( oDoc )
	return nil